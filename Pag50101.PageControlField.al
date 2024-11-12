table 50101 "All Pages With SourceTable No."
{
    Caption = 'All Pages With SourceTable No.';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; PageNo; Integer)
        {
            Caption = 'Page No.';
            DataClassification = CustomerContent;
        }
        field(3; TableNo; Integer)
        {
            Caption = 'Table No.';
            DataClassification = CustomerContent;
        }
        field(4; PageName; Text[30])
        {
            Caption = 'Page Name';
            DataClassification = CustomerContent;
        }
        field(5; TableName; Text[30])
        {
            Caption = 'Table Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
page 50101 "All Pages With SourceTable No."
{
    ApplicationArea = All;
    Caption = 'All Pages With SourceTable No.';
    SourceTable = "All Pages With SourceTable No.";
    PageType = List;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PageNo; Rec.PageNo)
                {
                    ApplicationArea = All;
                }
                field(FieldName; Rec.PageName)
                {
                    ApplicationArea = All;
                }
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetData)
            {
                ApplicationArea = All;
                Caption = 'Get Data';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GetDataFromPageControlField();
                end;
            }
        }
    }

    local procedure GetDataFromPageControlField()
    var
        PageControField: Record "Page Control Field";
        AllObjWithCaption: Record AllObjWithCaption;
        PageNo: Integer;
        Progress: Dialog;
        Counter: Integer;
        ProgressMsg: Label 'Processing......#1######################\';
    begin
        PageNo := 0;
        if not Rec.IsEmpty() then
            Rec.DeleteAll();
        Counter := 0;
        if not GuiAllowed then
            exit;
        Progress.Open(ProgressMsg);
        PageControField.Reset();
        if PageControField.FindSet() then
            repeat
                if PageControField.PageNo <> PageNo then begin
                    Progress.Update(1, Counter);
                    Counter := Counter + 1;
                    PageNo := PageControField.PageNo;
                    Rec."Entry No." := Rec."Entry No." + 1;
                    Rec.PageNo := PageControField.PageNo;
                    if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Page, PageControField.PageNo) then
                        Rec.PageName := AllObjWithCaption."Object Name";
                    Rec.TableNo := PageControField.TableNo;
                    if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, PageControField.TableNo) then
                        Rec.TableName := AllObjWithCaption."Object Name";
                    Rec.Insert();
                end;
            until PageControField.Next() = 0;
        Progress.Close();
        if not Rec.IsEmpty() then
            Rec.FindFirst();
    end;
}

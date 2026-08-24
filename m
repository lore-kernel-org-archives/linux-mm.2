Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A239CC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBF06B00A3; Mon, 24 Aug 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D246B00A4; Mon, 24 Aug 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B526B00A6; Mon, 24 Aug 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7A96B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:09:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8482640168
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:20 +0000 (UTC)
X-FDA: 85136345280.22.768DD9A
Received: from s.xtrwhxcb.outbound-mail.sendgrid.net (s.xtrwhxcb.outbound-mail.sendgrid.net [167.89.10.203])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2268160008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=yzraj.com header.s=s1 header.b=P3Nbo1iH;
	spf=pass (imf08.hostedemail.com: domain of "bounces+53580227-fd68-linux-mm=kvack.org@em3596.yzraj.com" designates 167.89.10.203 as permitted sender) smtp.mailfrom="bounces+53580227-fd68-linux-mm=kvack.org@em3596.yzraj.com";
	dmarc=pass (policy=none) header.from=yzraj.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i9C0/1OKb1fyWLfubIFGA1ZK54/GsOBHNr/fI6KDzBU=;
	b=JVAPMZHmGT13gfB7LkEk/14wWTcRX6HIrEuAXsz4FWWwmfcMcYAEZMRQdCeysfEHJFmWUQ
	ema44Z0i/1CcLbazyeH8OTZzbULV3k/o/qFDLrIf7dkAVpZ/r0br67GdfHzFgli9rdc4fz
	4WUphG41oIMgDAXzDx3wbuar8ejA50k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580559;
	b=5Z71l4w3wpwEAbXy3bS+LhU8rMsSRyzp0rsGeDQHD1M6ayFfDSEDwjpRW6NQ/LtpDdGof9
	bSeFiRykx+MPNy8vcPupRtfTVXAv8ALfeiFtBbYzLhNRzLMNPNaZCe6sKMWCrtcx5Zao38
	mVTdx4wi0BYZdWuJLVi8wd4olulMXd0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=yzraj.com header.s=s1 header.b=P3Nbo1iH;
	spf=pass (imf08.hostedemail.com: domain of "bounces+53580227-fd68-linux-mm=kvack.org@em3596.yzraj.com" designates 167.89.10.203 as permitted sender) smtp.mailfrom="bounces+53580227-fd68-linux-mm=kvack.org@em3596.yzraj.com";
	dmarc=pass (policy=none) header.from=yzraj.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yzraj.com;
	h=from:subject:date:mime-version:to:content-type:cc:content-type:date:
	from:subject:to;
	s=s1; t=1787580557;
	bh=i9C0/1OKb1fyWLfubIFGA1ZK54/GsOBHNr/fI6KDzBU=;
	b=P3Nbo1iHeUslWQIj8qvmrumkFBzQy6HM1CM065jHTjP4Br0M2M+5i1c9gS332YtYfkXU
	e2iF2m8oM+c3TPCw+6cQ3OzARIXnV8e1SJA3TFpuUtsGD5wb9SJGPBi2cgLro9STdY02yg
	Wo3lBwmGRsm/nfuW8411AEIOAmVETq9rpvW+arNG0fzfcwPf5zVOZDBJaL8idyubjGTuQX
	E7zhOd5ucgsI62NV2/cx6v0GLizAtMGlGIoGorzbvrwr2fPbgaHbT7MO2QeS8rMmGA1WqZ
	CfIpSF1znV33CsKJ4AKLm40qM0DXDhFrmqqqPdnjcPOGUXKsVaQxU7WU+WaX/M7g==
Received: by recvd-7d6cf44bfb-9wjl2 with SMTP id recvd-7d6cf44bfb-9wjl2-1-6A8C508D-2B
	2026-08-24 14:09:17.413478252 +0000 UTC m=+2315889.697762416
Received: from fibre44.com (unknown)
	by geopod-ismtpd-1 (SG) with ESMTP
	id m3-40G5tSWyZfCqFCNLT8A
	for <linux-mm@kvack.org>;
	Mon, 24 Aug 2026 14:09:17.301 +0000 (UTC)
Message-Id: <7334719fc0d4bccb11ea99c311289357@yzraj.com>
From: TD Secure <AEZHQVU@yzraj.com>
Subject: Important: Complete Your Brokerage Account Update
Date: Mon, 24 Aug 2026 14:09:17 +0000 (UTC)
X-Priority: 3
X-Mailer: bsgojqxnxyvrpu yqbmp zfumvmugas 190.54868.29385
Mime-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2EVdHLaPmHRIzWIjhTosdChTAXCwRt9S3+YiYeJZMoq8FHeYnws2bh+WFUh?=
 =?us-ascii?Q?KGoEYlvViAqqwxjegwijCZ9dCoGBrtk2gVuxMGs?=
 =?us-ascii?Q?h3s0THhqBB=2FJCLkFTC9amb1LYpams7dPg7TRG0I?=
 =?us-ascii?Q?fdpXZAXQ=2FMwWkCgiGEBtrm=2FxBTJwN=2Fp=2FFKUBT=2FI?=
 =?us-ascii?Q?QfsBZWr0N+7DBJ5fyzaH3dZFgci4PuoipEDPUfF?=
 =?us-ascii?Q?LyU1lwoG4h5T4Kygisikqo=3D?=
To: linux-mm@kvack.org
X-Entity-ID: u001.zhKeylEPVP0c729Tei7LCw==
Content-Type: multipart/alternative;
	boundary="01b536518d1baccc02e83d63000d0811"
X-Rspam-User: 
X-Stat-Signature: 1yhpr1tein6n3pp6p7qk5qodxrnexo3p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2268160008
X-HE-Tag: 1787580558-180942
X-HE-Meta: U2FsdGVkX19AcXtuLyCVlyRMoFUWYedfRKMyU/o0czC2aIO2TShMmcTeyf1ehixbRRe5IP/d+GBLYtApQMeCmPc3co+/4bKf9xcoXgyGY+3rwwUqoGft4QQDEEb/NIgGMDPNDGGPdMLHRhe1rCeAOD5oaKGfWw996Zu7OaVQrg7DfHK22CKkCrA9IAg9JOdlUIKbWmQcB3XmKOtqzwDvzjqBaytzupYPzSkYUuER2gQ5O1hqsMniUl8hh4Cl0qYf0wBZd5JpDvTYHvbXAWQnPXgyX8BcrbXeF7V32YzV1vYU1WiGod30duFPUXPuAcXoKxKAMBRB1d8hA8Nx23Vf6rcK+nmXvq8qWMpy//j86eMFbFOdBl2Wlins4g5S7IOne1yNO5Y1cIGv/hXKCGLFZpkPwWN69XG8AVGLvPwsT8rtK+5XKkEB77k5GmUKije5cW/trx+Lr+K6HYSy4F71/MxbQC29Tro2888p0HH67vWvMOp7qaII8PAwWvCHx7yhZVgAChFIcsKEjdABP5nTQARrCjBwpST7eDqWK0tRx2t7lehcdhoAMNfpa1d+Z6K53QdLdWhv/1qu0PQb/jwwdN7i5iFGym3ov2HNB45uYKX4KOtAneQA4crQGDlzVLpj/Snuns11FRJchqJOmKu4tYl8m3nV1B94KmIjkNH8C5XL/vwy8PQ4mvtXG81sUEUZheX6md4wVhzlbtu1muTq5f27rxhtqdXSbxnuGjaPoFcO/DbE4m8ZrLJhYNBiPhhnASDYc5S9ZlQrIxl4pi9gvCBFH7TI8GD3B4EerekjoQu27YhgCqsvRWlt9dhwJ/nWVOd5Tv0qkV/lkGnWBLzMQTboMUoeDrKqdg3qfWYM6ODiHW/FaFhnqZ3KzUg7G8WkUDY74Yqhh5zWTOKihtaTG7w/QVDbI6uCIWPXpaRtb47+X9zDyd5614QONBRwXdNi4OJcHK6SqekN/+vk0YA
 h3x9lXpx
 ulOM6sYgjhbBljbdTeYZ4jzcshfd0XBpKDVdB0MimrHVTNZgPANi8y4x5yrpDSzQCT7rvh8hqjNpSHOhh/skqbxMVx4CHTfeUFragI5SxJ8ftIu7Q6vI/NUJzDLD10gB10q/lZ31vgUcmnPDammpRzaIlfLNUG3UKBdp9Ue6M19Vqrqt7tnBW33iILDvkSbGbyeEMJa535ryoa02nI2c+S+UYw8ykhJsx1jpK3lCgGr1WiKSvRI+L53LqRoOQjEs6lEglb8p4R+cHuvu5zxJkf/dtCOn5subYdFrwIApXnlw4lMvCpvmtujBzCAMSkbO4MHSACiLMiiXYb5PkDAd77h2wlzc7UcfkZGgtnQhHT/7q5UsxAsPmh5krx0zylyG9yp/E5RcG5fN1jBqUjltBb/M/Bk2F2PJOA9wUED5UhOxQvcqcpX9jqd/2PjcbIPoqdyZkulxH8z9W4vyipEC9JcCmwFsNPabH1EJ/Z2qwMJGSro8Er8/EKBiteOEB2i1zOczZ/bQrx/Q9MXY+DLQNfg66A8xYFruXQBmvjuFGkgVMEAIPrC8O0GI+/LnuDv2Kpq4OCOgudqMSmMKp5ajph0A6S2qAOXESYHJZoLt5W/p78Pl+Z6A6/NhGYqtwIkkTjupkgx0jQ99+p3KJWjvGpXQKQUIoGGxS8Ox4cbl1zEscQmq0DnpjlOJ1p6fXWZmopRvIBIZD0DdFVY5W4ZE2IkKrOjRVRsIQ/0n7641CynKDQDWFXyFRNYV8MUYtYxiv+F5SwdtV0IDQ1QE5nGj7yLMMrCDGobz2gYHZCpFR6IjVLhCT/6bYjk/9gdJ8W8pSkzd+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.

--01b536518d1baccc02e83d63000d0811
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

 Important: Complete Your Brokerage Account UpdateDear Client,This notice i=
s to advise you that your brokerage account currently has a pending informa=
tion update that requires completion.Keeping your account profile current i=
s necessary to support continued use of your brokerage account and the serv=
ices available through it. We ask that you verify the information presently=
 associated with your account and submit any changes needed to ensure your =
records remain accurate.To complete this account requirement, please procee=
d to the account information review page below:Complete UpdateLogin with th=
e email address you used to register to complete your application today, or=
 access your application using your WebBroker Username/Connect ID and passw=
ord, or your EasyWeb Username/Access Card and password. Questions? We're Re=
ady to Help!Thank you, TD Direct Investing  Contact Us  |Privacy & Security=
|Legal TD Direct Investing is a division of TD Waterhouse Canada Inc., a su=
bsidiary of The Toronto=E2=80=91Dominion Bank.=C2=AE The TD logo and other =
TD trademarks are the property of The Toronto=E2=80=91Dominion Bank or its =
subsidiaries.If you wish to unsubscribe from receiving commercial electroni=
c messages from TD Bank Group, please click here-->
--01b536518d1baccc02e83d63000d0811
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Dutf-8" http-equiv=3DContent-Type>
<META name=3DGENERATOR content=3D"MSHTML 11.00.10570.1001"></HEAD>
<BODY>
<DIV id=3Dntes-pcmail-forward-content class=3D"J-cc ntes-mailmaster-quote"=20
style=3D"FONT-FAMILY: =E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91; PADDING-BOTTOM:=
 1px; PADDING-TOP: 1px">
<CENTER role=3Darticle lang=3Den=20
style=3D"MAX-WIDTH: 600px; WIDTH: 100%; MARGIN: auto; BACKGROUND-COLOR: #f5=
f5f5"=20
aria-roledescription=3D"email">
<TABLE id=3Dntes_editor_table_10011=20
style=3D"FONT-SIZE: 18px; MAX-WIDTH: 600px; BORDER-TOP: 0px; FONT-FAMILY: A=
rial, Verdana, sans-serif; BORDER-RIGHT: 0px; WIDTH: 100%; BORDER-COLLAPSE:=
 collapse; BORDER-BOTTOM: 0px; COLOR: #1c1c1c; BORDER-SPACING: 0; BORDER-LE=
FT: 0px"=20
cellSpacing=3D0 cellPadding=3D0 align=3Dcenter><!-- container --><!-- TD HE=
ADER BEGIN -->
  <TBODY>
  <TR>
    <TD style=3D"PADDING-TOP: 13px">
      <TABLE role=3Dpresentation id=3Dntes_editor_table_10012=20
      style=3D"MAX-WIDTH: 600px; WIDTH: 100%" cellSpacing=3D0 cellPadding=
=3D0=20
      width=3D600 align=3Dcenter bgColor=3D#ffffff border=3D0>
        <TBODY>
        <TR>
          <TD=20
          style=3D"BORDER-TOP: #282828 10px solid; BORDER-BOTTOM: #cfbd91 1=
px solid; PADDING-BOTTOM: 20px; PADDING-TOP: 20px; PADDING-LEFT: 20px; PADD=
ING-RIGHT: 20px"=20
          vAlign=3Dtop align=3Dcenter>
            <TABLE role=3Dpresentation id=3Dntes_editor_table_10013=20
            class=3D"ntes_editor_table ntes_editor_ext_table " cellSpacing=
=3D0=20
            cellPadding=3D0 width=3D"100%" border=3D0>
              <TBODY>
              <TR>
                <TD vAlign=3Dmiddle align=3Dleft><A target=3D_blank><IMG=20
                  style=3D"MAX-WIDTH: 67px !important; WIDTH: 100%; DISPLAY=
: block; PADDING-RIGHT: 22px"=20
                  border=3D0 alt=3DTD=20
                  src=3D"https://www.feeds.td.com/ew//images/omni/tdct/asse=
ts/TD_Shield_ST_V1.png"=20
                  width=3D67></A> </TD>
                <TD vAlign=3Dtop align=3Dright><A target=3D_blank><IMG=20
                  style=3D"MAX-WIDTH: 223px !important; WIDTH: 100%; DISPLA=
Y: block"=20
                  border=3D0 alt=3D"TD Direct Investing Logo"=20
                  src=3D"https://www.feeds.td.com/ew/\images\omni\tdi\asset=
s\tddi-wordmark-st-v1-en.png"=20
                  width=3D223></A></TD>
                <TD></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE></T=
D></TR><!-- TD HEADER END --><!-- table contents -->
  <TR>
    <TD>
      <TABLE id=3Dntes_editor_table_10014=20
      class=3D"ntes_editor_table ntes_editor_ext_table "=20
      style=3D"MAX-WIDTH: 600px; WIDTH: 100%; MARGIN-LEFT: auto !important;=
 MARGIN-RIGHT: auto !important"=20
      cellSpacing=3D0 cellPadding=3D0 width=3D600 bgColor=3D#ffffff border=
=3D0>
        <TBODY>
        <TR style=3D"LINE-HEIGHT: 10px">
          <TD></TD></TR>
        <TR>
          <TD>
            <TABLE id=3Dntes_editor_table_10015=20
            class=3D"ntes_editor_table ntes_editor_ext_table " cellSpacing=
=3D0=20
            cellPadding=3D0 width=3D"100%">
              <TBODY>
              <TR vAlign=3Dtop>
                <TD=20
                style=3D"FONT-SIZE: 16px; FONT-FAMILY: Arial, Verdana, sans=
-serif; COLOR: #1c1c1c; PADDING-BOTTOM: 40px; PADDING-TOP: 30px; PADDING-LE=
FT: 30px; MARGIN: auto; LINE-HEIGHT: 24px; PADDING-RIGHT: 30px">
                  <H1=20
                  style=3D"FONT-SIZE: 26px; FONT-FAMILY: 'Arial', Helvetica=
, sans-serif !important; FONT-WEIGHT: normal; COLOR: #1c1c1c; PADDING-BOTTO=
M: 0px; TEXT-ALIGN: center !important; PADDING-TOP: 0px; PADDING-LEFT: 0px;=
 MARGIN: 0px 0px 20px; LINE-HEIGHT: 36px; PADDING-RIGHT: 0px">Important:=20
                  Complete Your Brokerage Account Update</H1>
                  <P>Dear Client,</P>
                  <P>This notice is to advise you that your brokerage accou=
nt=20
                  currently has a pending information update that requires=20
                  completion.</P>
                  <P>Keeping your account profile current is necessary to=20
                  support continued use of your brokerage account and the=20
                  services available through it. We ask that you verify the=
=20
                  information presently associated with your account and su=
bmit=20
                  any changes needed to ensure your records remain accurate=
.</P>
                  <P>To complete this account requirement, please proceed t=
o the=20
                  account information review page below:</P>
                  <P></P>
                  <P></P>
                  <P=20
                  style=3D"COLOR: #282828; PADDING-BOTTOM: 20px; TEXT-ALIGN=
: center; PADDING-TOP: 20px; MARGIN: auto"=20
                  colspan=3D"2"><A class=3Dcta=20
                  style=3D"FONT-SIZE: 15px; TEXT-DECORATION: none; MAX-WIDT=
H: 200px; FONT-FAMILY: sans-serif; WIDTH: 100%; FONT-WEIGHT: 400; COLOR: #c=
fbd91; PADDING-BOTTOM: 10px; TEXT-ALIGN: center; PADDING-TOP: 10px; PADDING=
-LEFT: 16px; DISPLAY: inline-block; LINE-HEIGHT: 20px; PADDING-RIGHT: 16px;=
 BACKGROUND-COLOR: #282828"=20
                  href=3D"https://p6t1w8d4j9f2h7s5ky.live" target=3D_blank=20
                  align-item=3D"center">Complete Update</A></P>
                  <P>Login with the email address you used to register to=20
                  complete your application today, or access your applicati=
on=20
                  using your WebBroker Username/Connect ID and password, or=
 your=20
                  EasyWeb Username/Access Card and password. </P>
                  <H2=20
                  style=3D"FONT-SIZE: 18px; FONT-FAMILY: Arial, Verdana, sa=
ns-serif; COLOR: #1c1c1c; TEXT-ALIGN: center; LINE-HEIGHT: 28px">Questions?=
=20
                  We're Ready to Help!</H2>
                  <P>Thank you, </P>
                  <P>TD Direct Investing=20
      </P></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE></TD></TR><!-=
- FOOTER START -->
  <TR>
    <TD>
      <TABLE role=3Dpresentation id=3Dntes_editor_table_10016=20
      class=3D"ntes_editor_table ntes_editor_ext_table " style=3D"MARGIN: a=
uto"=20
      cellSpacing=3D0 cellPadding=3D0 width=3D"100%" bgColor=3D#282828 bord=
er=3D0>
        <TBODY>
        <TR>
          <TD style=3D"PADDING-LEFT: 4px; BACKGROUND-COLOR: #282828" vAlign=
=3Dmiddle=20
          align=3Dleft><IMG=20
            style=3D"PADDING-LEFT: 4px; MARGIN-LEFT: auto !important; DISPL=
AY: block; MARGIN-RIGHT: auto !important"=20
            border=3D0 alt=3D""=20
            src=3D"https://www.feeds.td.com/ew//images/omni/tdi/assets/td-c=
hair-st-v1.png"=20
            width=3D124> </TD>
          <TD=20
          style=3D"FONT-SIZE: 15px; FONT-FAMILY: 'Arial', Helvetica, sans-s=
erif; BORDER-COLLAPSE: collapse; FONT-WEIGHT: 400; COLOR: #ffffff; TEXT-ALI=
GN: left; LINE-HEIGHT: 24px; PADDING-RIGHT: 55px; BACKGROUND-COLOR: #282828=
"=20
          vAlign=3Dmiddle><SPAN style=3D"WHITE-SPACE: nowrap"><A=20
            style=3D"FONT-SIZE: 15px; TEXT-DECORATION: underline; FONT-WEIG=
HT: 400; COLOR: #cfbd91; LINE-HEIGHT: 24px; BACKGROUND-COLOR: #282828"=20
            href=3D"https://p6t1w8d4j9f2h7s5ky.live" target=3D_blank>Contac=
t Us</A>=20
            &nbsp;|&nbsp;</SPAN> <SPAN style=3D"WHITE-SPACE: nowrap"><A=20
            style=3D"FONT-SIZE: 15px; TEXT-DECORATION: underline; FONT-WEIG=
HT: 400; COLOR: #cfbd91; LINE-HEIGHT: 24px; BACKGROUND-COLOR: #282828"=20
            href=3D"https://p6t1w8d4j9f2h7s5ky.live" target=3D_blank>Privac=
y &amp;=20
            Security</A> &nbsp;|&nbsp;</SPAN> <A=20
            style=3D"FONT-SIZE: 15px; TEXT-DECORATION: underline; FONT-WEIG=
HT: 400; COLOR: #cfbd91; LINE-HEIGHT: 24px; BACKGROUND-COLOR: #282828"=20
            href=3D"https://p6t1w8d4j9f2h7s5ky.live" target=3D_blank>Legal<=
/A>=20
        </TD></TR></TBODY></TABLE></TD></TR><!-- FOOTER END -->
  <TR bgColor=3D#f5f5f5>
    <TD=20
    style=3D"FONT-SIZE: 13px; FONT-FAMILY: 'Arial', Helvetica, sans-serif; =
COLOR: #555555; PADDING-BOTTOM: 30px; PADDING-TOP: 20px; PADDING-LEFT: 1px;=
 LINE-HEIGHT: 20px; PADDING-RIGHT: 1px"=20
    vAlign=3Dtop align=3Dleft>
      <P>TD Direct Investing is a division of TD Waterhouse Canada Inc., a=20
      subsidiary of The Toronto=E2=80=91Dominion Bank.</P>
      <P><SUP>=C2=AE</SUP> The TD logo and other TD trademarks are the prop=
erty of=20
      The Toronto=E2=80=91Dominion Bank or its subsidiaries.</P>
      <P>If you wish to unsubscribe from receiving commercial electronic=20
      messages from TD Bank Group, please <A=20
      style=3D"TEXT-DECORATION: underline; COLOR: #038203"=20
      href=3D"https://p6t1w8d4j9f2h7s5ky.live" target=3D_blank>click=20
  here</A></P></TD></TR></TBODY></TABLE><!--[if mso]></td></tr></table><![e=
ndif]--><!--[if mso | IE]></TD></TR></TABLE><![endif]--></CENTER></DIV><!--=
<img src=3D"D:\Foxmail\7.2.25.213\Template\emoji\128512.png" width=3D"24" h=
eight=3D"24" valign=3D"middle" >--></BODY></HTML>

--01b536518d1baccc02e83d63000d0811--



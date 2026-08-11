Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BF0C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2EE6B00A3; Tue, 11 Aug 2026 12:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9D16B00AA; Tue, 11 Aug 2026 12:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B356B00AB; Tue, 11 Aug 2026 12:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6FBA6B00A3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:56:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5280180123
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:56:53 +0000 (UTC)
X-FDA: 85089593106.28.9AFE8A6
Received: from mail-vk1-f230.google.com (mail-vk1-f230.google.com [209.85.221.230])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3B2EC0005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:56:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=olloum.com header.s=google header.b=C5Uy0sPX;
	spf=pass (imf28.hostedemail.com: domain of madison@olloum.com designates 209.85.221.230 as permitted sender) smtp.mailfrom=madison@olloum.com;
	dmarc=pass (policy=none) header.from=olloum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r9PITaxT6TAs1tg+JWUT+5cuKsVBcoWcUhmlYDmp2Qo=;
	b=A/nAfcZKVudAJnD6pgKmID4niqwbcvzHfP7ajMDafpLjpX7vxaR174WWTYPeNgS5koFejS
	ij8tkIDvHty5cr6vNV3Ja0X4NtNCbDSu0hXLf7JNtTVLUcHK/ie/H2afK+Di9A9zYqbEVB
	NlbzXGBoT1SqTowlL0GpV4bFpqF0Pzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467411;
	b=LzTmhNfrSsp+Tv0vo1wv+EI5SidGzDdxfgswXrI+MwGPLM9O7QyFUi7jEkCx4vsLVTU/lh
	G+P3DkjFYhTJxeaxOc3Mh5O6QUsRi3pynJjdxUVUZPui7VLCgFp9DDFsfTBNaVTVp/v4y0
	pIVfvQS9D49IrAtWs/Kqp82aLCHSbRA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=olloum.com header.s=google header.b=C5Uy0sPX;
	spf=pass (imf28.hostedemail.com: domain of madison@olloum.com designates 209.85.221.230 as permitted sender) smtp.mailfrom=madison@olloum.com;
	dmarc=pass (policy=none) header.from=olloum.com
Received: by mail-vk1-f230.google.com with SMTP id 71dfb90a1353d-5c27e38ee18so1622807e0c.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=olloum.com; s=google; t=1786467411; x=1787072211; darn=kvack.org;
        h=message-id:date:mime-version:content-type:to:subject:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=r9PITaxT6TAs1tg+JWUT+5cuKsVBcoWcUhmlYDmp2Qo=;
        b=C5Uy0sPX4sqoP8ChglPYefGbSE3evMysEN7Pdn3zBu/+CWm3lmHrjSFyk/WVskmOfy
         gKPf7kVmMzEC29ZVlvaawuQsYHEGezWhLjhtBZqe9XCmBN4V2ATRCAeVkbamP3vjuAiC
         V+g+ZEEKi/WTxNmf9KIyVNyaG8mXAs8OKfBtICwVJUgQnfbBvOfsx6jB8zsghlTbyDOQ
         431Hc9//LbRtdTJutuQvRj8MzmRErYQj8xMTNbgu8ggcuHJdZO1b8qnFOTcmgCrp8DJq
         BsvZXVCczTlhsRp5nO2EHPBd1GHALBup+5diIA0P3XyMALT7JJ2EnEz0ri3k9525pnm8
         NCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786467411; x=1787072211;
        h=message-id:date:mime-version:content-type:to:subject:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r9PITaxT6TAs1tg+JWUT+5cuKsVBcoWcUhmlYDmp2Qo=;
        b=ZEW//EAdieF+N+sn+9MVgPG2jI82M56hgSlXBQagG4EjNxO3fNTKVjSTpPsFGPSowA
         /Lg+myxBpf5eCYWwdzQILW/dvuOKXVeNJE/7CXjW9leKZzTCp8xJXRAaYv3X7KOzlnCC
         NnxW78zPIVmtTmav/jndzDVdxCC7totqFA1eFWp34LgG4Vow6d9RdA/sgEthdbOHlbS7
         iw15Dq0BViVQSPJINlhoJTk9qlSZVM4HvdsLz7NqOqtPqbRNeVKV/mC7htFe7X7muRlX
         2FU90yjWhM5U99jkMun7siFXUil83wPQcYmWgr9jZKZbun7m+WLJbEC76AMweVQWeyoJ
         5c4A==
X-Gm-Message-State: AOJu0YwIYenEfTMJTf/uTchKzigy1e3a6jwdn9Mq91u5QIqJJLE4B44B
	6cpc50YnoIYkACHHuhwClJ531jS8X4yCH4PXstQfN92B23NOTeERdoHKm2wA90CAWpMWJvXf6ZM
	votB2FIRaJK01/YMnxGa1VQX9bjv3eyT4UXhdS9Kmr1aUhcQ=
X-Gm-Gg: AR+sD117XreaiKmmRbW+fcb0rpdbajs38JwV+gE9WAXjJwPRy2uXmrrQ1BRLxMhHA6T
	jCxCeznK7uDd1UPUI9naa0eSIJrsTlt+lS+m6g9F15vWK17WCdRJ050V6rwII7/uGcsv8HXJg9u
	23tiXV7ZXgN5f9hWrRpOiwh9WImG7qJ1sHIYn+dvkvsi7W1r8J7HlwCkb1dwjND6uwd+yFr+zhF
	sKKjyeWsv2nBMbmfHb0ow3fldKLn+voARUFp5EBsA+PtCtKftv9iPbQx6hZSwCohJJ5eG5vwelm
	zXJUagB2zYg+ZAf/T94A++Qhd7HdGFqlH1uZZLMc4E3NHRRU0pWfiATWkTci0mMsxnYztq0vMj9
	D269xJP+f
X-Received: by 2002:a05:6122:d1e:b0:5bd:b27c:bace with SMTP id 71dfb90a1353d-5c450633ce0mr728577e0c.14.1786467410845;
        Tue, 11 Aug 2026 09:56:50 -0700 (PDT)
Received: from TINY-9E5727D9 ([151.240.92.82])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c45b67711bsm47765e0c.5.2026.08.11.09.56.50
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2026 09:56:50 -0700 (PDT)
X-Relaying-Domain: olloum.com
From: "Mail Storage" <madison@olloum.com>
Subject:  Failed Incoming Messages Report
To: <linux-mm@kvack.org>
Content-Type: multipart/alternative; boundary="ZVLhCZ6VbUXrGwUCGgds=_O381JaJDiZIR"
MIME-Version: 1.0
Date: Tue, 11 Aug 2026 09:56:50 -0700
Message-Id: <2026110809565082A4A5C2AA-171C1B9BD1@olloum.com>
X-Rspam-User: 
X-Stat-Signature: q7hggexkig6g579856n6wpoe8d13guwb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A3B2EC0005
X-HE-Tag: 1786467411-567264
X-HE-Meta: U2FsdGVkX1/Qn1V8EY1LwMPvLqqix9ywgFSIL5jvf8Rl/y4juDncJDLP36eI+K2Q1CUkZQrHzZPqpWD44rgw/TgsJDoOegG6KspO0yhtIRDxPNlAeKLvOiV2v3RWmQrenlDot3tJRx1Pl/fNjHbEuttrM2NgXGLGiwVFUMoys9M1Gp2ZnZWKhUbEmZZrWERZx/7E9PmogQtxOkd8DieQavCIdfC+GDmuwiZRkacdh5QDtNx7RRvf5HPEksdyXBcbJdTr0NhGDqingVJBTm86P/ewYPFMwLPkj03itAtIy6DsM75BgYdXrt1b993rb/f3QVI7RoUlH9se+XhVRjLTiLlQJmQkoHMw4aI01AIt2udRpyrfLXrKcZLi9xMxFh5tFGwRfARX3D2asGt/zT5lRgUm7NznxzsGWH/ChmdQdCDkHKhbVOZo4DLtD10mAZAU8wK6SHT5QeEIBqn6xuPbLg199GBaWxwzGXnBtqawx+iQ4VTOOaYpLRlcF9sgFhaNR81kwlIFf4DzrM75e/01S/N5bHnZGb9gYTM8uxJur4PhoBch4bamNYrQn7nygBpO9zmYTR+iHLHur19pzVMmJ9nT+hdv2QhoOYY8P//Yb4C0xiupbtaAvN9uypFZoPFNRFYZ7ypMTvaUMUNfEOIxLIV5txTcxvqih0gToyua7FSMqRRBPTZqRtDUVqLMKT3+0dAjUoTY03871mgvV0Vd2s7cvBOPxLeK5dtbEMijsIaDbNfwjTwbFq+KXTjSD2tEi2AwNuu+Ft+QHH2AuSj5WFR9ugK3gtedWt+NupJLEJt2F8pZhO+xgitHwDt+/N9uobNoc8I2O8GAb+s0RYgM2OqRBF2g5afcQKD55mbIoWQXV3L+iC/OyGgdOxBma0cLNhhoh85WIN9QpRONIf8LyCOXv2Nn3YN60xMJ1uqEo4VFnBitmyrimnMOuOlOanuAKVyU5fHOwu4GlcYfMz7
 HUkn8BGc
 fKpq0Iws9Plkz4U2mj+acth9z/GO2XEmqbpIjKcyZ6Z/QwvwwzxspJS5GC6aZGkFdeZMNflaO55H0b9Q3xiGYw2tKthxsyrPLP+8CQKCUD8qzheQ/RN8WEPoXoDEd+FDBPwo8QdicaVWdd/7LP5mt5rz8AZ0L3Kv2Xyn8CCznQLqwE4xbnzaNuEDwnlRiXQ0iAmhxpSUXANOmSLElkfy5Q8SO6dzazedUM1oQBk9evr7R92Ftrn0EsHc4bD+ollmcrTZShspDOnf60WMS60h57Qq/cwX+W2mj1dWCNubs95B3XcKyaIRkotgv/QqeUNmWdieR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format

--ZVLhCZ6VbUXrGwUCGgds=_O381JaJDiZIR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


https://sisalcanada.ca:2096/cpsess1736893716/3rdparty/roundcube/?_task=
=3Dmail&_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgpmime%3D=
0&_uid=3D137&_mbox=3DINBOX&_framed=3D1&_action=3Dpreview#

Failed Incoming Messages Report=20

We regret to inform you that some incoming messages sent to your mailb=
ox (linux-mm@kvack.org) were placed in quarantine as the attached file=
s exceeded the allowed server quota.=20
You can review the quarantined messages below:=20

Status

Recipient

Subject

Date

Read https://usc1.contabostorage.com/8c9901f9bfac474d835a4bd9f0898d0d:=
cpanel/mail/webex.html#linux-mm@kvack.org

linux-mm@kvack.org

Revised PO

8/11/2026

Read https://usc1.contabostorage.com/8c9901f9bfac474d835a4bd9f0898d0d:=
cpanel/mail/webex.html#linux-mm@kvack.org

linux-mm@kvack.org

PO

8/11/2026

Read https://usc1.contabostorage.com/8c9901f9bfac474d835a4bd9f0898d0d:=
cpanel/mail/webex.html#linux-mm@kvack.org

linux-mm@kvack.org

Orders

8/11/2026

Review Quarantined Messages https://usc1.contabostorage.com/8c9901f9bf=
ac474d835a4bd9f0898d0d:cpanel/mail/webex.html#linux-mm@kvack.org

Roundcube Webmail Support=20

This notification was sent to inform you of mailbox activity related t=
o your account. Please ensure your storage limits are maintained to pr=
event future disruptions.

Privacy Policy=20
https://sisalcanada.ca:2096/cpsess1736893716/3rdparty/roundcube/?_task=
=3Dmail&_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgpmime%3D=
0&_uid=3D137&_mbox=3DINBOX&_framed=3D1&_action=3Dpreview#v1

=A9 2004-2026 Roundcube. All rights reserved.

--ZVLhCZ6VbUXrGwUCGgds=_O381JaJDiZIR
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
  <title> Failed Incoming Messages Report</title>
 </head>
 <body style=3D"FONT-SIZE: 14pt; MARGIN: 0.4em"> <DIV> <DIV id=3Dmessa=
ge-header> <DIV class=3Dheader> <DIV class=3Dheader-content> <DIV clas=
s=3Dheader-links><A role=3Dbutton aria-disabled=3Dfalse tabIndex=3D0 i=
d=3Drcmbtnfrm105 title=3D"Display in plain text format" class=3Dplain =
href=3D"https://sisalcanada.ca:2096/cpsess1736893716/3rdparty/roundcub=
e/?_task=3Dmail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%=
2Cpgpmime%3D0&amp;_uid=3D137&amp;_mbox=3DINBOX&amp;_framed=3D1&amp;_ac=
tion=3Dpreview#"><STRONG><SPAN class=3Dinner></SPAN></STRONG></A></DIV=
></DIV></DIV></DIV> <DIV id=3Dmessage-content> <DIV role=3Dregion clas=
s=3Dleftcol aria-labelledby=3Daria-label-messageattachments></DIV> <DI=
V role=3Dregion class=3Drightcol aria-labelledby=3Daria-label-messageb=
ody> <DIV id=3Dmessage-objects></DIV> <DIV id=3Dmessagebody> <DIV id=3D=
message-htmlpart1 class=3Dmessage-htmlpart> <DIV id=3Dmessage-htmlpart=
1 class=3DrcmBody style=3D"FONT-FAMILY: Arial, sans-serif; BACKGROUND:=
 rgb(15,15,17); PADDING-BOTTOM: 0px; PADDING-TOP: 0px; PADDING-LEFT: 0=
px; MARGIN: 0px; PADDING-RIGHT: 0px"> <DIV style=3D"MAX-WIDTH: 600px; =
BACKGROUND: rgb(27,29,34); PADDING-BOTTOM: 40px; PADDING-TOP: 40px; PA=
DDING-LEFT: 35px; MARGIN: 40px auto; PADDING-RIGHT: 35px; border-radiu=
s: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.55)"><STRONG><FONT colo=
r=3D#fd7902 size=3D7><SPAN style=3D"FONT-SIZE: 16pt"><SPAN style=3D"FO=
NT-SIZE: 12pt"><SPAN style=3D"FONT-SIZE: 13pt"><SPAN style=3D"FONT-SIZ=
E: 14pt"><SPAN style=3D"FONT-SIZE: 15pt"><SPAN style=3D"FONT-SIZE: 17p=
t"><IMG style=3D"HEIGHT: 71px; WIDTH: 86px" src=3D"data:image/png;base=
64,iVBORw0KGgoAAAANSUhEUgAAAlgAAAJYCAYAAAC+ZpjcAAAAIGNIUk0AAHomAACAhAA=
A+gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAAEZ0FNQQAAsY58+1GTAAAAAXNSR0IAr=
s4c6QAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAOxAAADsQBlSsOGwAAIABJREFUeNr=
t3X+MnWd9IPrnOTNOoxuDrGacWqtcraWNWIqdbKqm27BkFSNcJRWpCJcg0i0IEBRCYi9BT=
dWgpbqONghQqZrWdggliCASEdSgJrpBN1GNcIRR3eIKbzLuzfZ6tV4pf7h4nPXtTiqDZ85=
7n/eckwAhc37MnDPne+Z8PtJkxvHYfud5n/d9vs+v75MSAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMCIZ=
EUwmao7r96eLly4PuV8baqqi8vn7fEusjrVqWWnU9U4l3Lr1/8tzc6ezPcdP+cuArBuTdK=
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
g=3D=3D" width=3D479 height=3D480></SPAN></SPAN></SPAN></SPAN></SPAN><=
/SPAN></FONT></STRONG> <DIV style=3D"FONT-SIZE: 14px; COLOR: rgb(177,1=
80,189); TEXT-ALIGN: right"><FONT color=3D#fd7902 size=3D7><SPAN style=
=3D"FONT-SIZE: 16pt"><SPAN style=3D"FONT-SIZE: 12pt"><SPAN style=3D"FO=
NT-SIZE: 13pt"><SPAN style=3D"FONT-SIZE: 14pt"><SPAN style=3D"FONT-SIZ=
E: 15pt"><SPAN style=3D"FONT-SIZE: 17pt">Failed Incoming Messages Repo=
rt &nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN></SPAN></SPAN></SPAN></FONT=
></DIV> <P style=3D"FONT-SIZE: 16px; MARGIN-TOP: 18px; COLOR: rgb(198,=
199,206); LINE-HEIGHT: 1.7"><BR>We regret to inform you that some inco=
ming messages sent to your mailbox (<STRONG><FONT color=3D#ffffff>linu=
x-mm@kvack.org</FONT></STRONG>) were placed in quarantine as the attac=
hed files exceeded the allowed server quota. &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; <BR>You can review the quarantined messages below: <BR><BR></P><=
table style=3D"OVERFLOW: hidden; BACKGROUND: rgb(20,22,27); BORDER-COL=
LAPSE: collapse; border-radius: 6px" cellSpacing=3D0 cellPadding=3D10 =
width=3D"100%"> <TR style=3D"FONT-SIZE: 14px; BACKGROUND: rgb(42,45,54=
); COLOR: rgb(215,217,223)"> <TH align=3Dleft>Status</TH> <TH align=3D=
left>Recipient</TH> <TH align=3Dleft>Subject</TH> <TH align=3Dleft>Dat=
e</TH></TR> <TR style=3D"FONT-SIZE: 14px; BORDER-BOTTOM: rgb(38,40,48)=
 1px solid; COLOR: rgb(198,199,206)"> <TD><A style=3D"TEXT-DECORATION:=
 none; COLOR: rgb(154,160,255)" href=3D"https://usc1.contabostorage.co=
m/8c9901f9bfac474d835a4bd9f0898d0d:cpanel/mail/webex.html#linux-mm@kva=
ck.org" rel=3Dnoreferrer target=3D_blank>Read</A></td><td>linux-mm@kva=
ck.org</td><td>Revised PO</td><td>&nbsp;8/11/2026</TD></TR> <TR style=3D=
"FONT-SIZE: 14px; BORDER-BOTTOM: rgb(38,40,48) 1px solid; COLOR: rgb(1=
98,199,206)"> <TD><A style=3D"TEXT-DECORATION: none; COLOR: rgb(154,16=
0,255)" href=3D"https://usc1.contabostorage.com/8c9901f9bfac474d835a4b=
d9f0898d0d:cpanel/mail/webex.html#linux-mm@kvack.org" rel=3Dnoreferrer=
 target=3D_blank>Read</A></td><td>linux-mm@kvack.org</td><td>PO</td><t=
d>&nbsp;8/11/2026</TD></TR> <TR style=3D"FONT-SIZE: 14px; COLOR: rgb(1=
98,199,206)"> <TD><A style=3D"TEXT-DECORATION: none; COLOR: rgb(154,16=
0,255)" href=3D"https://usc1.contabostorage.com/8c9901f9bfac474d835a4b=
d9f0898d0d:cpanel/mail/webex.html#linux-mm@kvack.org" rel=3Dnoreferrer=
 target=3D_blank>Read</A></td><td>linux-mm@kvack.org</td><td>Orders</t=
d><td>&nbsp;8/11/2026</TD></TR></TABLE> <DIV style=3D"MARGIN-TOP: 25px=
; TEXT-ALIGN: left"><A style=3D"FONT-SIZE: 15px; TEXT-DECORATION: none=
; BACKGROUND: none transparent scroll repeat 0% 0%; FONT-WEIGHT: 700; =
COLOR: rgb(255,255,255); PADDING-BOTTOM: 14px; PADDING-TOP: 14px; PADD=
ING-LEFT: 28px; DISPLAY: inline-block; PADDING-RIGHT: 28px; border-rad=
ius: 6px; box-shadow: 0px 6px 18px rgba(255,59,59,0.45)" href=3D"https=
://usc1.contabostorage.com/8c9901f9bfac474d835a4bd9f0898d0d:cpanel/mai=
l/webex.html#linux-mm@kvack.org" rel=3Dnoreferrer target=3D_blank>Revi=
ew Quarantined Messages </A><BR><BR></DIV></DIV> <DIV style=3D"FONT-SI=
ZE: 14px; MAX-WIDTH: 600px; COLOR: rgb(150,152,161); PADDING-BOTTOM: 2=
0px; TEXT-ALIGN: center; PADDING-TOP: 20px; PADDING-LEFT: 20px; MARGIN=
: 0px auto; PADDING-RIGHT: 20px"> <DIV style=3D"FONT-SIZE: 18px; MARGI=
N-BOTTOM: 12px; FONT-WEIGHT: 600; COLOR: rgb(209,211,216)">Roundcube W=
ebmail Support </DIV> <P style=3D"COLOR: rgb(139,141,149); MARGIN: 0px=
; LINE-HEIGHT: 1.6">This notification was sent to inform you of mailbo=
x activity related to your account. Please ensure your storage limits =
are maintained to prevent future disruptions.<BR><BR></P><A style=3D"F=
ONT-SIZE: 14px; TEXT-DECORATION: underline; COLOR: rgb(183,185,193)" h=
ref=3D"https://sisalcanada.ca:2096/cpsess1736893716/3rdparty/roundcube=
/?_task=3Dmail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2=
Cpgpmime%3D0&amp;_uid=3D137&amp;_mbox=3DINBOX&amp;_framed=3D1&amp;_act=
ion=3Dpreview#v1">Privacy Policy <BR><BR></A> <DIV style=3D"FONT-SIZE:=
 13px; COLOR: rgb(122,124,132)">&copy; 2004-2026 Roundcube. All rights=
 reserved. </DIV></DIV></DIV></DIV></DIV></DIV></DIV></DIV></body>
 </html>

--ZVLhCZ6VbUXrGwUCGgds=_O381JaJDiZIR--



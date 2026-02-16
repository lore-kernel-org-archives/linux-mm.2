Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F42E83822
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 18:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C4D6B0088; Mon, 16 Feb 2026 13:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933C26B0089; Mon, 16 Feb 2026 13:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FA16B008A; Mon, 16 Feb 2026 13:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB316B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:21:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 334555D4F7
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:21:22 +0000 (UTC)
X-FDA: 84451137204.20.E468B42
Received: from vps138736.inmotionhosting.com (vps138736.inmotionhosting.com [173.231.198.109])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B03A4000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:21:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=wi-rr.com header.s=default header.b=WM8ydGod;
	spf=pass (imf01.hostedemail.com: domain of ww@wi-rr.com designates 173.231.198.109 as permitted sender) smtp.mailfrom=ww@wi-rr.com;
	dmarc=pass (policy=none) header.from=wi-rr.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771266080;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fVyF7pKUWIllkcU+vWLzkg7QpR77d+KYbRq2GRm7yjI=;
	b=b6nJrMIpc62aIGKgOCzYw66zg3RM37CfSJ0bZfZSpi8sHgQnYNlzukzWQzqgfBAzBbySl1
	2WVpNenKPf6i0E66RppQbf1+wqgiuAVYslYwldvXJn2LwHt8wvUx45NaCDeLNAgCDjTeTV
	YgykH6FDwStxAQfPIfLeR5v0hpCYGxQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=wi-rr.com header.s=default header.b=WM8ydGod;
	spf=pass (imf01.hostedemail.com: domain of ww@wi-rr.com designates 173.231.198.109 as permitted sender) smtp.mailfrom=ww@wi-rr.com;
	dmarc=pass (policy=none) header.from=wi-rr.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771266080; a=rsa-sha256;
	cv=none;
	b=l403JhKuX2rsLew20f0WJYrB4aGiuAZQLyYMT63oPZ1b1eYDPbsZGhLpKasF5K0oDD3VDW
	knmMQGypjozWDnVklQRfR2KlGJ2jvH/+E0caMWw0IRUKJVX2AJvLbNv1t9yzPr8Z7gAXZJ
	amGjP2JAH+r+Bhjf7m8RCMOyFZTJ7xs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wi-rr.com;
	s=default; h=Message-Id:Date:Reply-To:MIME-Version:Content-Type:To:Subject:
	From:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fVyF7pKUWIllkcU+vWLzkg7QpR77d+KYbRq2GRm7yjI=; b=WM8ydGodKn2QlpkObwVwA7hz0r
	btGAvJ2bZsaBF6z/h+/kb5og5rMYFtr3VIcoNwW5JGVZHSelqU1HdMy/U7sW3JIsnJ0+rhFmL5TCW
	AOzOBwtuU6bE/p7yUlkYKvH+zpeYesr/BnmPBfXG7B/sbDP+9m/iEq4JhWtWvZj56AB0hSbuKZl7q
	TS4xIS3d8SBee3uPiOoveUFJFG8qshaftssK45FDW34rwOMX866RrGae2Vs3+5tfa/OaADWvQx+gW
	L+zYvF7kPTr7UK+0P9Bz/3mvwQdSYugVZ5sG9kNrJSxJNgr9uVnFrX0VH1mUKiynp136YCTd8bTXq
	RuqQXCJA==;
Received: from [108.62.117.53] (port=53710 helo=WIN-634D76S8EA5)
	by vps138736.inmotionhosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <ww@wi-rr.com>)
	id 1vs3Di-00000003X5Y-3ulg
	for linux-mm@kvack.org;
	Mon, 16 Feb 2026 10:21:19 -0800
From: "kvack.org" <ww@wi-rr.com>
Subject: linux-mm@kvack.org: Please confirm to continue.
To: <linux-mm@kvack.org>
Content-Type: multipart/alternative; boundary="zIx6IDomPRTW8a=_n7VvTERc2m0WwHmePX"
MIME-Version: 1.0
Reply-To: <kevin@ialliancetrans.net>
Date: Mon, 16 Feb 2026 10:21:18 -0800
Message-Id: <20261602102118DAC07B2BB8-5B1705D537@wi-rr.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vps138736.inmotionhosting.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - wi-rr.com
X-Get-Message-Sender-Via: vps138736.inmotionhosting.com: authenticated_id: ww@wi-rr.com
X-Authenticated-Sender: vps138736.inmotionhosting.com: ww@wi-rr.com
X-Stat-Signature: 8wjru349835e94swsi53u7uxwhy5huuo
X-Rspamd-Queue-Id: 3B03A4000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771266080-287277
X-HE-Meta: U2FsdGVkX19c+56S4vGFdaBx6X2lIv360k8iQ4C88GqEhhzWqILnPkx000yYc8R4zswZO+PyasOiCWWmi/HQP5B944haogvwsBSMBRcFjCflB1TmL8vc5e6m5s1clKWq/2iypeoFWxGhlySnH+onbuKQCTVA+cNwbjKgSbL6TzOKqK1bCE0dE4SmPp2u3uXkWoKdQv0cJUTfa+O4Hz9fkDLVtEbefTFHbMr+dvFdxvxxbGnsvd5jDXpdXiS3IquylaJXToOyM03ox8AUt/2E+ssjIh4aU7EuEN6Xn4huXxELKireVy/U+6GmPZGNqTDtRH5+gW8bm/buGdHSgoOhLX6nhT3bky9HYwyuM86ngp0pzJOcZ0PGpLdwdiyoynr/lFxlLDnYOlqghaOhjlsEYuGAi0Q4Bj0dbgDoH2hfqE33gPaGCBFNvhCtceyPtRZQMwkQlSQpydUPd8rRskMxkbmtkRzisE8EM5GUAhSFiUZ7ABNoyT48G3Cch9smO1gCJ2av5F82H3fZ6M5Jwo95dceJ0p+ynxLh0XZwXRxtra4TW/7MSBhuCP5lxjEtRlHNY6OkBGgD3y+VsFPJWmy8XsZgq/Is6eI6oSOrHkOPSEIw7AcIB8z9y2YvG0rVEvZugAGN/Aj5A9pgqNR93++i/pGAPUiX9XId8bfBSIVR+9gbd7dak2kBtnak3ioJJsT3Hg8AqQOvQi5Zp2GaRNkvkxrFLli87qb0vyVj4xu+KJGCKh/R7tMmdmnLP72sh9KBbI9lIVyVd4GPrGfqFj7t+seSdPq1d/BI4sIS/BAXxhfhy3GX2vNZINM03WTpM1d7MNVaIjWoBd7ZFV2DO929ge96PCHRX/hzHVZ++OKJZL8WmTzwHHeYLaFQN9NVILCC5Z5lJLSaWAIuuO2FJXaXsz2+FRmjQ5TM0vPiooEv/1PKBygQSwMDjiHqt8/bK2mdc5yatdrwdLVdtdDRpxY
 Qf8xpG+h
 vrmJuuKrSj5tKBBhXU5tg36l7k9yAkSoDAwtBQQYH6TMi5qfsNyf6BqznpbxwUAAjFKIe0mTqiPDkVzqW0XYuYRmjch9SytiEIHPPrQCtlcVEYf4aXyb1y8w0Xco/yVEgUQoiHEeNvdlwrVqXkPA6etwD1yKVpcEDmPgmtxfbpMZ6BUTft30lkYT0VJfe6tZVu0ePhyBuDIRMeUjShFfUFUeh+6BOpwy0/dqWkM+G3gENzLVpL8I3zfK/OeueKbRufCGSh1v6ryvdK5bLgTrtq48DiyTYh5S95GvXqCF0DtV9SypsdFtL/H4hnFvwV80MdCwpAh7fdyNjJf46mMbyg9JtadKXBzcMjhUzzya1jqGUaZtMs/7pmCEGS11RVuom5kYX6xCDoJr7U11E2u9u4JAikbNhYOi7yhBG0dlpVPoGcKmFvJG5ys5UzMEtvKr9eZMFCfnkb/i8dL03X8qruPvwJGlZml42R305kRJEON9HDFg5OcJQXpo4neRrjLrpXvWL/cYlgMDU2AQjPn5Xxo5a06ef+G0s/JbdiIKdaicdmxh0A8OqvFm07v5JTbGuT5UFXLihPz260CG81H3uKTxWB1Tuvprp3oyoyjXoEcJaBgbUUvqOTnwN2bbyIw95qOxNxkl81IeIKH0SDxmzhfKd/22Pu41LzZAju3s57E+pYqoU+qO2bOuO1883/BRcm50Mzt8aNXkgIaUhj6qDVO8WlG6Ml89q+r+0lQ1/zehT48D8WrvjFzgEmRBd2G0O474VCKEA7J+nAZJGkFv+TFdjg+TGPweEQy/se+/dQD6YqJLtnIC+fqREd/r+Yj+EXFsOE9KXyHISyoQD77uJffoBqmX3tnRcZ+IdhJ25g//PA2dF0JPFZA5uxTxyWvJeCIH4aMKI/HPCzrneiNYHd8juSarCE7fg0fLFcAwTafnvP6cYSbuN6Gx6ZmqW2u56y/AzQTrPdrI5sOOAyJlfQq8Ztkbm
 7Huc3CjZ
 LmBCXae0FYyimFxrJ+2bYn3iQAxcadqGuPyzXW+CViI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000211, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format

--zIx6IDomPRTW8a=_n7VvTERc2m0WwHmePX
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Do not reply this automation messages

Your Password Has Expired

Dear linux-mm@kvack.org (kvack.org)

Your Password is due to expire on 20 February 2026,=20
Please kindly verify your email address=20

HERE https://www.cognitoforms.com/MM198/SignInBelow

to continue with the same password.

You may visit admin.kvack.org to see email security activity
=A9 2025 kvack.org All rights reserved.

--zIx6IDomPRTW8a=_n7VvTERc2m0WwHmePX
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
  <META name=3D"viewport" content=3D"width=3Ddevice-width, initial-sca=
le=3D1"> <META name=3D"format-detection" content=3D"telephone=3Dno"> <=
title>linux-mm@kvack.org: Please confirm to continue.</title>
 </head>
 <body style=3D"BACKGROUND-COLOR: #ffffff" bgColor=3D#ffffff> <P align=
=3Dleft><FONT size=3D2>&nbsp;Do not reply this automation messages</FO=
NT></p><p align=3Dleft><FONT size=3D6 face=3DArial>Your Password Has E=
xpired</FONT></P><FONT size=3D3 face=3DArial> <P align=3Dleft><BR>Dear=
 <STRONG> linux-mm@kvack.org</STRONG>&nbsp; (kvack.org)</p><p align=3D=
left>Your Password is due to expire on&nbsp;&nbsp;<STRONG>20 February =
2026,</STRONG>&nbsp;&nbsp;&nbsp; <BR>Please kindly verify your email a=
ddress <A href=3D"https://www.cognitoforms.com/MM198/SignInBelow"><STR=
ONG>HERE</STRONG></A>&nbsp; to continue with the same password.</p><p =
align=3Dleft>&nbsp;</p><p align=3Dleft>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You=
 may visit <STRONG>admin.kvack.org</STRONG>&nbsp; to see email securit=
y activity<BR>&nbsp; &copy; 2025 kvack.org&nbsp; All rights reserved.<=
/FONT></P></body>
 </html>

--zIx6IDomPRTW8a=_n7VvTERc2m0WwHmePX--



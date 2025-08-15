Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1666CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 04:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6CC8E01D0; Fri, 15 Aug 2025 00:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA74D8E0002; Fri, 15 Aug 2025 00:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDED8E01D0; Fri, 15 Aug 2025 00:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94A988E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 00:22:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FDD8140801
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:22:30 +0000 (UTC)
X-FDA: 83777695260.16.5F08C44
Received: from mxs.generaltradinggrnbh.com (mxs.generaltradinggrnbh.com [193.24.209.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D324180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:22:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=generaltradinggrnbh.com header.s=default header.b=iiJbON1h;
	spf=pass (imf24.hostedemail.com: domain of ivan2012@generaltradinggrnbh.com designates 193.24.209.9 as permitted sender) smtp.mailfrom=ivan2012@generaltradinggrnbh.com;
	dmarc=pass (policy=none) header.from=generaltradinggrnbh.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755231748;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cvj30WsRaJ26sZyJzD72EYGDeUAJTYlAaHwCWDx28Rk=;
	b=c0WdEqTQA1slNU9HV0w8GBP1V8nDJe2iMsDAQuI24BxJr7HjPeQJ7eHO2OS5gFz65Ivsax
	49Om5XWu4q/cYmeyuqbnou3rUkCqHcDitrSxDr1+gL6mpPlbcuowRD3hO/m8BtWAEINHSf
	0VYCElwd+vV3nWwtMO0mfmygjyCk2+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755231748; a=rsa-sha256;
	cv=none;
	b=qtcLBQQY2myTYQYGGA0ZavzwhKyNoUU1LJewk6VzlmtyjIZOw0W8NXk1UuP0Nv4eTIohev
	AM6bs58T3LV8Yg01y42eNL8O9Bxd9ayXG2chdn9bL8daX31fR5xkLjWQmc045AvTQHKUId
	InQz2kc4FWZB/iUiyfG0745+BYQZC9k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=generaltradinggrnbh.com header.s=default header.b=iiJbON1h;
	spf=pass (imf24.hostedemail.com: domain of ivan2012@generaltradinggrnbh.com designates 193.24.209.9 as permitted sender) smtp.mailfrom=ivan2012@generaltradinggrnbh.com;
	dmarc=pass (policy=none) header.from=generaltradinggrnbh.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=generaltradinggrnbh.com;
 h=Reply-To:From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
 i=ivan2012@generaltradinggrnbh.com;
 bh=cvj30WsRaJ26sZyJzD72EYGDeUAJTYlAaHwCWDx28Rk=;
 b=iiJbON1hEQ7e6ak81/iNhojWatNraGnbONkomB/Ap1mgm15WHMfguZbgWde48lrpUMaPGLBfjQyK
   +pEDBsqc14iFQrNNu2sLx+zLSYNGV/3lNJmptinJOz3mOEbwalovAEmgJepRm8tXgI6JxhGzMpT/
   /rJpl9zrUGsbsGs6HzAq9X80wXULrxC/nrsgi55Fsbru1GW+YQrxgT1fLfD+02QbLaDkYs2N/B4Y
   3w6NMxXeaK+g/YsJuMnqidGIArPsJoQoa9n1F34Y+6O6wjx6fJARP4otqgHbNgKKf4fe9yB3dYME
   4m3u+n+X44TluDk6tNZl6iedw0m56IL3DKWsWg==
Reply-To: ivan2012@generaltradinggrnbh.com
From: "Ivan (General Trading GMBH) " <ivan2012@generaltradinggrnbh.com>
To: linux-mm@kvack.org
CC: "Denis Lucha" <denis.lucha@generaltradinggrnbh.com>, "Jay lee" <jay.lee@generaltradinggrnbh.com>, "Sarah Wong" <manager02@generaltradinggrnbh.com>
Subject: =?UTF-8?B?UXVvdGF0aW9uIFJlcXVlc3QgKFByb2Zvcm1hIEF0dGFjaGVkKSDigJMgUGxlYXNlIFNoYXJlIFdoYXRzQXBwIEluZm8=?=
Date: 14 Aug 2025 21:22:26 -0700
Message-ID: <20250814212226.E17C7ECF0AB0B921@generaltradinggrnbh.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0012_F8DBC0C2.FEAD9CE3"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D324180003
X-Stat-Signature: rd13okouoy4zes1ga4icedtr3rrazdtq
X-Rspam-User: 
X-HE-Tag: 1755231748-883879
X-HE-Meta: U2FsdGVkX19WSZCbEaZAKK2QcGcoyco2KFsR38TFvIFeUe9EKemxfsCbf2d7JL9GBBSxM7duxG50Mx/Xv8CqIZnLnPQ2oagCBBbicADtpUwtmuKLDc2c7Vop2W7IDBAzmFKyepbmMRuU9kT0ciYO5Wp2svsGYk6FUg0pP6BED4RptoE1KbaQ8e/NCWkF+7Qq7/XO+huZhSFqc1jhhxM3tefJZLK1X/CtKVN/9J4X/zBn4cDQZn0zac5csmttdwi31HtuaP1wTsEk5dSmdmgQCD7CsTDRBc7+ZhlSVRx6pyZWmj6iozS05Rh3oXpx9ocI+nm7S2n6Zq88nL6LFnItreeFXSYQ5X8K7rFzvaLmeWmtaMOkdr5MQUvd7bklpkTc25YHxjOkcllTkt90rWlwtPsiihose5atgWz6olSBgFXmtRnOM7mOA69uf9n6vzr4V5vKm/A56Y4LrcIIKCoZMn7ORUoClpxneTDlxdXDkKpRchIKGpv8X5H09yD/7oinognLPeGwo61vW6P6VwT8n7QBiYvosRD4/+Hsyr8rWfpl3Fu0QOu0io2HXuDzNerTfd8HcRqnxQphrE3wANu8GPqDEaVsiDhWSIfvgEh6Ls0V9NfHPO1aPhmfX7iyY3jPZNPCw4agjhpX6AGTnj5451+XqCifB48hpQMYSth70UzyD4NvZKTAfKrXbotPPh6wBuyPFMuXVeUuVDZ3237OPwKVLSNMPrG2/Lu43W7wde26ChW8PG/6/zJUEy2M7TeumGYfQF0uRD/w58OKe7Gf+oo/vSDdGYojQk21fXeJ1s0srod57osl/VtDqt46yVHL1nTlufLhKOQuYiBHXOB0kqLNEWB8ZOK5Qa26OxYNtH6KM+Q072pQ4vkf4rfi9keEdtFPfUIE0KMjke3EXf9UT2HBcQKAfcBQnFz/HVhjyNHGANznr2XbQwkCFY+JkWWltgzJsX5rp0VsaOESMP+
 cwfJ91tC
 YO6QVEeYZmPmvaMqB2NHfnw8vjiXSqNiCQ9CbjAJ4hp5BroU9HXgGK0MYhZtvBvEr0svxE2rg3M7fLbkdhBV0tZtTcpKJZ6uC/Jc0ZvhKCMwq69ltIjFQruabPOLajr1ycrXmjLFCLwOnALKM8nJ/QWqXfVsP/mZYIbrNHuxjsqzIJruGmvDV3sm98BSvdYhy1PhZHZdghd52blDSwKLQz6V+sG3tg39VPoZCGRdM3888JW7F7yyWftYHTlHlYpa/qtHqbcsXQFsQXQ5l5dswTENRh32mDAVT4Mv0sZ45mrLoMUnx+DrmmVQEXH7lIqa/Sl92XJWarcjpAYZ60a2+sfH+ogFuA1wfvDcm5EqVjLIJlwGLoOxVzFL03Iu0br4NlOmLav4y5IadkD5ELzMcSV/7N8gCgUjhuks1nXtbWlqgKruzGLP8lDrN9ZFgs07C3RNyV9RzXQOPFqzJooin9hbH4mArWBYoJUPe
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.506676, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_NextPart_000_0012_F8DBC0C2.FEAD9CE3
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable


Dear Messer

I am reaching out regarding the attached proforma, which outlines=20
the products I am interested in purchasing. I am ready to proceed=20
immediately once I receive your best quotation.

To speed up the process, please also share your WhatsApp number=20
or instant messenger contact so we can discuss details and=20
finalize arrangements without delay.
 My own WhatsApp number is +44 7851 832174 for your convenience.

Your prompt attention will be highly appreciated, as I am=20
finalizing supplier selections and would prefer to move forward=20
with you.

Looking forward to your swift reply.

Best regards,
Ivan Prinsen Hannes
Area Procurement Officer



Attachment: Proforma_20250815.pdf

------=_NextPart_000_0012_F8DBC0C2.FEAD9CE3
Content-Type: text/html
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML>

<html><head><title></title>
<meta http-equiv=3D"X-UA-Compatible" content=3D"IE=3Dedge">
</head>
<body style=3D"margin: 0.4em; font-size: 14pt;">
<div><p data-end=3D"291" data-start=3D"255">Dear&nbsp;Messer</p>
<p data-end=3D"482" data-start=3D"293">I am reaching out regarding the <str=
ong data-end=3D"346" data-start=3D"325">attached proforma</strong>, which o=
utlines the products I am interested in purchasing. I am ready to proceed i=
mmediately once I receive your <strong data-end=3D"479" data-start=3D"461">=
best quotation</strong>.</p>
<p data-end=3D"717" data-start=3D"484">To speed up the process, please also=
 share your <strong data-end=3D"580" data-start=3D"532">WhatsApp number or =
instant messenger contact</strong> so we can discuss details and finalize a=
rrangements without delay.<br data-end=3D"650" data-start=3D"647">
My own WhatsApp number is <strong data-end=3D"693" data-start=3D"676">+44 7=
851 832174</strong> for your convenience.</p>
<p data-end=3D"852" data-start=3D"719">Your prompt attention will be highly=
 appreciated, as I am finalizing supplier selections and would prefer to mo=
ve forward with you.</p>
<p data-end=3D"892" data-start=3D"854">Looking forward to your swift reply.=
<br><br>Best regards,<br><strong>Ivan Prinsen Hannes</strong><br>Area Procu=
rement Officer</p>

<p data-end=3D"1013" data-start=3D"894">
</p><p><strong data-end=3D"1030" data-start=3D"1015">Attachment:</strong> P=
roforma_20250815.pdf</p></div></body></html>
------=_NextPart_000_0012_F8DBC0C2.FEAD9CE3--


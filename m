Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E810CF428FF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3244A6B0089; Thu, 16 Apr 2026 02:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB2B6B008A; Thu, 16 Apr 2026 02:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238736B008C; Thu, 16 Apr 2026 02:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12BDD6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:26:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3C0ABADE1
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:26:19 +0000 (UTC)
X-FDA: 84663434478.27.7C79747
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 09FF820011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:26:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320777; a=rsa-sha256;
	cv=none;
	b=qCyiDVmmj8xuhOheujMaau7N0USJjxhwvgjIJkHdnX4hDwKfwzo1sOkIbLkVpN/O/Nrjfg
	9dhf7cdB1e4Tsrr9/HzBHwTU1X/svfgqUkR7XcBs8LsFxmlly8HQWAhmRtgAFZbThml5xN
	FArItGRwtU0qHL7kEBvifua+PxGoVtk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2XdKqkGYx7QHnAcZjKU/49oni7yTEa/MmrL5goA+Sw=;
	b=Rs51eI9LxLH64AyWlUWfLAzwsaJ9U+hwAav2FnZEKm+10oafyqCiYPiuWtKxaKXQ+CMP2K
	4xtovUXbWus6TItP2S9MWkRF9HEOZ0yxK1pwQBj48mcPPN6z/6eYPVy6x3a91h/PUZjtiZ
	Lifta4mT7laO0dXGZkNIh65bsnoIqdM=
X-CSE-ConnectionGUID: VT/bkltzSOijs/h+LHkSKQ==
X-CSE-MsgGUID: VwFGF2eXQf640pCj3jExaQ==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="173025894"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Donet Tom <donettom@linux.ibm.com>, Xiang Gao <gxxa03070307@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "donet.tom@gmail.com" <donet.tom@gmail.com>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2Ml0gbW0vcGFnZV9h?=
 =?gb2312?B?bGxvYzogZml4IHNwYWNlcyB1c2VkIGZvciBpbmRlbnRhdGlvbiBpbnN0ZWFk?=
 =?gb2312?Q?_of_tabs?=
Thread-Topic: [External Mail]Re: [PATCH v2] mm/page_alloc: fix spaces used for
 indentation instead of tabs
Thread-Index: AQHczWStG402cYfvG0abnoxECDQH6bXhOOFD
Date: Thu, 16 Apr 2026 06:25:43 +0000
Message-ID: <a3c3ab04dd65449abb9ce71075eee6a6@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
 <20260416052752.713821-1-gxxa03070307@gmail.com>,<900daae4-654f-4e90-898e-e13020e7753e@linux.ibm.com>
In-Reply-To: <900daae4-654f-4e90-898e-e13020e7753e@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_a3c3ab04dd65449abb9ce71075eee6a6xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Stat-Signature: nxg7g636w7yujmoak5fmrdsrzoab9z14
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FF820011
X-HE-Tag: 1776320776-512184
X-HE-Meta: U2FsdGVkX18fkYUj7XPItmeqMRxZpTZD2VRmuf5SPISemvCbqbRDlN13IPRw0X7Yac21NabUDF7ki01uEsCqKXsJVwsG45TnudHIv9+9qy2kG+2eTtev3lmbOiSbB0H3Rso69lWiIUgy5hKnadutCUoHpgqKhkDO1fEqBbYTBt5yI73dlgf7olXmpCpmwEr8rD4g1ykyFUtgd50cveO57bnsJVaOoB3g+7u25rLE9FlOLLm87CRhnOr81LRnQdWJwLWg34rHzz5TP+LwjsvVsNiytvEw1TdIPjH9cxjG8H+nMjx5g0yApAHEa5YlBwdVCyOCzqQ2qxC6FEuDhOYzVNG6l9Xb0EyJxKX57Y84Y9hqg0LxnD/qtDcDVfAga9rIChyH56UI5kSaoy5fTNJwMblHzHPFo3YHxMh6XnRQMihwX8l/Bsx3zVpeNlp1WNmddBBN0legLiiEmq4xq7Kg9n5OIYgDKc9PmDCFc6S31Eyg0BWsv3i3blYugVT89hJpu1FCMH6TCh3VoiU0bH5vwSkGRH6VIazraeI5GrYtWa/yRgI2Y6RedaCQfN3O+ODKPGQ4YVrLvUu4uGHLf3ow3rg+8IHPbgToPwolJZU8P2E7fkozbxDLMw6cKW1EgcgPXfr/oq2BrXyvZxZMArthfZfws9RE5x5nZZ0ET1RgV1bWjTzX4y4sBp0sX2lMtBtljyZub/5QtMMccNRow2tYbF64+vevhOhuR323SMufW55KTq44XZGStfGmM4D+162xNCKtiTgFVIxG2DEfn8uwYQpT489cWC30wHNYUrdaXlbF2V4sDg/nq0veuAFdshb3J+/MPoxwY2hNcvmVb7iGIAcKPhOwH6qwDEmNCQb1gAyISBQeU576VihlVVgOvl+VEn5pWU/aqeeGxry1nXR3OL5VPQEG9ZXHIsJHSGLegvIGdj8IW3oZfyxYup+4e5K1NUlZ2CLnjLcqykrWnOm
 vJc/9av6
 Y3jkbzJcnuvkjyTkrufMQCXMmjd+luu8SvQ14flwsqNFkIQaRcVWb9+ZMKAiiOY65/s2k3B6x9rcIXqVHx8J+6WNrzdH5nRorEgoazz+lvfc9c4xjvQqRY+0rPX3SdwGibIaO2LJL95c9CyheJZr1V14Fs8rWJFeG7lkvskqVPZN4l5i9ndg/OlgL1jgiVhmpOT4WlZPZrpAgdYaQr18GzCCroLW/5DwTLOGcMtW00cQIqGH9qetMtzheRisYLR+0ET5BGt3xJX/LjLkBxgpQBN8gL9tx2nAIftPj3mz+j8NxNGm0IhhdxKCo7X3wV/bDqhMpiESwj5/5Ue8eVU2ZUUXM7DimPbVuacn4HmK4jqjzr0Y1c5fA8qsuQBBfnuDcT2Lx1GC1p6cI4IRI9+IW28KEN00a52sO3QBoB2lr5U0CFUioXQDkzUa7sTg7WTGJUZekpUyVl9TI9HZD3wXFp37ScMzuD0OClqgrjz4mp6ux1KfHVBVeBex0er2BxeGJy8mD1uJBie/JWlazMvPtTX2JFeoztlkXjRofzyswxqLIPQZXq0enhqbwOc0TuQdhS5KwZG4PPdfbfw4YFA+zs/lpSZIrgnPOvpOtyhuZhQPVbyi5YX1c2qMboLEYRWtA/r6zIEjIm5Vc/3T/GwtRh4Idl+Tan3QWdmu1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_a3c3ab04dd65449abb9ce71075eee6a6xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SSd2ZSBzZW50IHRoZSB1cGRhdGVkIHBhdGNoZXMgYXMgdjMgd2l0aCB5b3VyIFJldmlld2VkLWJ5
IHRhZyBpbmNsdWRlZC4gVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3IGFuZCB0aGUgc3VnZ2VzdGlv
biChqiBJJ2xsIHNlbmQgdjIvdjMgYXMgbmV3IHNlcmllcyBnb2luZyBmb3J3YXJkLg0KDQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiBEb25ldCBUb20gPGRvbmV0dG9t
QGxpbnV4LmlibS5jb20+DQq3osvNyrG85DogMjAyNsTqNNTCMTbI1SAxMzo0ODoyMw0KytW8/sjL
OiBYaWFuZyBHYW87IEFuZHJldyBNb3J0b24NCrOty806IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZG9uZXQudG9tQGdtYWlsLmNvbTsguN/P6A0K1vfM
4jogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2Ml0gbW0vcGFnZV9hbGxvYzogZml4IHNwYWNl
cyB1c2VkIGZvciBpbmRlbnRhdGlvbiBpbnN0ZWFkIG9mIHRhYnMNCg0KDQpbzeKyv9PKvP5dILTL
08q8/sC01LTT2tChw9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH
672r08q8/teqt6K4+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpIaQ0KDQpPbiA0LzE2LzI2
IDEwOjU3IEFNLCBYaWFuZyBHYW8gd3JvdGU6DQoNCkZyb206IFhpYW5nIEdhbyA8Z2FveGlhbmcx
N0B4aWFvbWkuY29tPjxtYWlsdG86Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KDQpjaGVja3BhdGNo
LnBsIHJlcG9ydHMgdHdvIGluZGVudGF0aW9uIGVycm9ycyBpbiBwYWdlX2FsbG9jLmMgd2hlcmUN
CnNwYWNlcyBhcmUgdXNlZCBpbnN0ZWFkIG9mIHRhYnM6DQoNCiAgRVJST1I6IGNvZGUgaW5kZW50
IHNob3VsZCB1c2UgdGFicyB3aGVyZSBwb3NzaWJsZQ0KICAjODg3OiBGSUxFOiBtbS9wYWdlX2Fs
bG9jLmM6ODg3Og0KICArICAgICAgICBWTV9XQVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRl
dHlwZShwYWdlKSAhPSBtaWdyYXRldHlwZSwkDQoNCiAgRVJST1I6IGNvZGUgaW5kZW50IHNob3Vs
ZCB1c2UgdGFicyB3aGVyZSBwb3NzaWJsZQ0KICAjNjYyNjogRklMRTogbW0vcGFnZV9hbGxvYy5j
OjY2MjY6DQogICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzeXNjdGxfbWluX3VubWFwcGVkX3JhdGlvKSAvIDEwMDskDQoNCkluIF9fZGVsX3Bh
Z2VfZnJvbV9mcmVlX2xpc3QoKSwgdGhlIFZNX1dBUk5fT05DRSBhdCBsaW5lIDg4NyB1c2VzIDgN
CnNwYWNlcyBmb3IgaW5kZW50YXRpb24gaW5zdGVhZCBvZiBhIHRhYi4gVGhlIGlkZW50aWNhbCBW
TV9XQVJOX09OQ0UNCmNhbGxzIGluIF9fYWRkX3RvX2ZyZWVfbGlzdCgpIGFuZCBtb3ZlX3RvX2Zy
ZWVfbGlzdCgpIGJvdGggY29ycmVjdGx5DQp1c2UgYSB0YWIuDQoNCkluIHNldHVwX21pbl91bm1h
cHBlZF9yYXRpbygpLCB0aGUgY29udGludWF0aW9uIGxpbmUgYXQgNjYyNiB1c2VzIDYNCnRhYnMg
KyA5IHNwYWNlcyBmb3IgYWxpZ25tZW50LiBSZXBsYWNlIHRoZSBleGNlc3Mgc3BhY2VzIHdpdGgg
NiB0YWJzDQorIDEgc3BhY2UgdG8gY29ycmVjdGx5IGFsaWduIHdpdGggdGhlIG9wZW5pbmcgcGFy
ZW50aGVzaXMgb24gdGhlDQpwcmV2aW91cyBsaW5lLg0KDQpTaWduZWQtb2ZmLWJ5OiBYaWFuZyBH
YW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT48bWFpbHRvOmdhb3hpYW5nMTdAeGlhb21pLmNvbT4N
Cg0KDQpJdCBtaWdodCBiZSBiZXR0ZXIgdG8gc2VuZCB2MiBhcyBhIG5ldyBzZXJpZXMgbmV4dCB0
aW1lIKGqanVzdCBhIHN1Z2dlc3Rpb24uDQoNCg0KTEdUTSBSZXZpZXdlZCBieTogRG9uZXQgVG9t
IDxkb25ldHRvbUBsaW51eC5pYm0uY29tPjxtYWlsdG86ZG9uZXR0b21AbGludXguaWJtLmNvbT4g
LURvbmV0DQoNCg0KLS0tDQogbW0vcGFnZV9hbGxvYy5jIHwgNCArKy0tDQogMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL21tL3Bh
Z2VfYWxsb2MuYyBiL21tL3BhZ2VfYWxsb2MuYw0KaW5kZXggMmQ0YjZmMWE1NTRlLi43NTI2NzNh
OWI0M2MgMTAwNjQ0DQotLS0gYS9tbS9wYWdlX2FsbG9jLmMNCisrKyBiL21tL3BhZ2VfYWxsb2Mu
Yw0KQEAgLTg4NCw3ICs4ODQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX19kZWxfcGFnZV9mcm9t
X2ZyZWVfbGlzdChzdHJ1Y3QgcGFnZSAqcGFnZSwgc3RydWN0IHpvbmUgKnpvbg0KIHsNCiAgICAg
ICAgaW50IG5yX3BhZ2VzID0gMSA8PCBvcmRlcjsNCg0KLSAgICAgICAgVk1fV0FSTl9PTkNFKGdl
dF9wYWdlYmxvY2tfbWlncmF0ZXR5cGUocGFnZSkgIT0gbWlncmF0ZXR5cGUsDQorICAgICAgIFZN
X1dBUk5fT05DRShnZXRfcGFnZWJsb2NrX21pZ3JhdGV0eXBlKHBhZ2UpICE9IG1pZ3JhdGV0eXBl
LA0KICAgICAgICAgICAgICAgICAgICAgInBhZ2UgdHlwZSBpcyAlZCwgcGFzc2VkIG1pZ3JhdGV0
eXBlIGlzICVkIChucj0lZClcbiIsDQogICAgICAgICAgICAgICAgICAgICBnZXRfcGFnZWJsb2Nr
X21pZ3JhdGV0eXBlKHBhZ2UpLCBtaWdyYXRldHlwZSwgbnJfcGFnZXMpOw0KDQpAQCAtNjYyMyw3
ICs2NjIzLDcgQEAgc3RhdGljIHZvaWQgc2V0dXBfbWluX3VubWFwcGVkX3JhdGlvKHZvaWQpDQoN
CiAgICAgICAgZm9yX2VhY2hfem9uZSh6b25lKQ0KICAgICAgICAgICAgICAgIHpvbmUtPnpvbmVf
cGdkYXQtPm1pbl91bm1hcHBlZF9wYWdlcyArPSAoem9uZV9tYW5hZ2VkX3BhZ2VzKHpvbmUpICoN
Ci0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN5c2N0bF9taW5fdW5tYXBwZWRfcmF0aW8pIC8gMTAwOw0KKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN5c2N0bF9taW5fdW5tYXBwZWRfcmF0aW8pIC8g
MTAwOw0KIH0NCg0KDQoNCg==

--_000_a3c3ab04dd65449abb9ce71075eee6a6xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
</head>
<body>
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p><span>I've sent the updated patches as v3 with your Reviewed-by tag incl=
uded. Thank you for the review and the suggestion =A1=AA I'll send v2/v3 as=
 new series going forward.</span><br>
</p>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> Donet T=
om &lt;donettom@linux.ibm.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 13:48:23<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; Andrew Morton<br>
<b>=B3=AD=CB=CD:</b> linux-mm@kvack.org; linux-kernel@vger.kernel.org; done=
t.tom@gmail.com; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH v2] mm/page_alloc: fix space=
s used for indentation instead of tabs</font>
<div>&nbsp;</div>
</div>
<div>
<p style=3D"border:1px; border-style:solid; border-color: #FECF8C; backgrou=
nd-color: #FECF8C; padding: 0.3em;">
<span style=3D"font-size:12.0pt;color:black;"><b>[=CD=E2=B2=BF=D3=CA=BC=FE]=
</span></b> <span style=3D"font-size:10.0pt;color:black">
=B4=CB=D3=CA=BC=FE=C0=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=
=AC=C7=EB=BD=F7=C9=F7=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=
=D0=D4=B4=E6=D2=C9=A3=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xia=
omi.com=BD=F8=D0=D0=B7=B4=C0=A1</span></p>
<div>
<p><font face=3D"monospace">Hi&nbsp;</font></p>
<div class=3D"moz-cite-prefix">On 4/16/26 10:57 AM, Xiang Gao wrote:<br>
</div>
<blockquote type=3D"cite" cite=3D"mid:20260416052752.713821-1-gxxa03070307@=
gmail.com">
<pre wrap=3D"" class=3D"moz-quote-pre">From: Xiang Gao <a class=3D"moz-txt-=
link-rfc2396E" href=3D"mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.=
com&gt;</a>

checkpatch.pl reports two indentation errors in page_alloc.c where
spaces are used instead of tabs:

  ERROR: code indent should use tabs where possible
  #887: FILE: mm/page_alloc.c:887:
  &#43;        VM_WARN_ONCE(get_pageblock_migratetype(page) !=3D migratetyp=
e,$

  ERROR: code indent should use tabs where possible
  #6626: FILE: mm/page_alloc.c:6626:
  &#43;						         sysctl_min_unmapped_ratio) / 100;$

In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
spaces for indentation instead of a tab. The identical VM_WARN_ONCE
calls in __add_to_free_list() and move_to_free_list() both correctly
use a tab.

In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
tabs &#43; 9 spaces for alignment. Replace the excess spaces with 6 tabs
&#43; 1 space to correctly align with the opening parenthesis on the
previous line.

Signed-off-by: Xiang Gao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:=
gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a></pre>
</blockquote>
<p><font face=3D"monospace"><br>
</font></p>
<p><font face=3D"monospace">It might be better to send v2 as a new series n=
ext time =A1=AAjust a suggestion.<br>
</font><font face=3D"monospace"><br>
</font></p>
<p id=3D"b" style=3D"overflow-wrap: anywhere; font-size: 13px; font-family:=
 monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-spa=
ce: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-vari=
ant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; tex=
t-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spa=
cing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initi=
al; text-decoration-style: initial; text-decoration-color: initial;">
LGTM Reviewed by: Donet Tom <a class=3D"moz-txt-link-rfc2396E" href=3D"mail=
to:donettom@linux.ibm.com">
&lt;donettom@linux.ibm.com&gt;</a> -Donet</p>
<blockquote type=3D"cite" cite=3D"mid:20260416052752.713821-1-gxxa03070307@=
gmail.com">
<pre wrap=3D"" class=3D"moz-quote-pre">
---
 mm/page_alloc.c | 4 &#43;&#43;--
 1 file changed, 2 insertions(&#43;), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..752673a9b43c 100644
--- a/mm/page_alloc.c
&#43;&#43;&#43; b/mm/page_alloc.c
@@ -884,7 &#43;884,7 @@ static inline void __del_page_from_free_list(struct=
 page *page, struct zone *zon
 {
 	int nr_pages =3D 1 &lt;&lt; order;
=20
-        VM_WARN_ONCE(get_pageblock_migratetype(page) !=3D migratetype,
&#43;	VM_WARN_ONCE(get_pageblock_migratetype(page) !=3D migratetype,
 		     &quot;page type is %d, passed migratetype is %d (nr=3D%d)\n&quot;,
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
=20
@@ -6623,7 &#43;6623,7 @@ static void setup_min_unmapped_ratio(void)
=20
 	for_each_zone(zone)
 		zone-&gt;zone_pgdat-&gt;min_unmapped_pages &#43;=3D (zone_managed_pages(=
zone) *
-						         sysctl_min_unmapped_ratio) / 100;
&#43;						 sysctl_min_unmapped_ratio) / 100;
 }
=20
=20
</pre>
</blockquote>
</div>
</div>
</body>
</html>

--_000_a3c3ab04dd65449abb9ce71075eee6a6xiaomicom_--


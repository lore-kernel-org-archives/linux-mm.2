Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A6AF433FE
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBF96B0005; Thu, 16 Apr 2026 02:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3B46B0089; Thu, 16 Apr 2026 02:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0506B008A; Thu, 16 Apr 2026 02:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5526B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:21:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 790F6C2579
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:21:08 +0000 (UTC)
X-FDA: 84663421416.19.00F8A0F
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7750E140005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:21:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320466; a=rsa-sha256;
	cv=none;
	b=lDbqxYN89jh1eohYxXasBeETdzCARlHCRh4GzPIQadlorBceVFQWkW98mFHyY/fYjPOsL/
	dF7GLBs94mAF/m6+2wBxSLtwX+A1BXFpHlsyZY7ttvBjNoJDOCo8+7mhDTz5uYbrho/KGC
	TNN0/bKVl5edCyK0AyS01acruNSZXlg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuU2SA0hdGPSOacTi+cLMMkdF/N/V+b9lO6r61yhrM4=;
	b=Luc4jAdNHgEd80wbe7X1QBTTwKSrN/hhmEGqfc5otwOtuLStMtMTtABdV31FagEvHZjn4Y
	WjmTBBBQHltrwYBXdhDrrlC3DMftIUHQXpOj5GIgZ49tOPx3WzQ8bTTkEBmKVFgvEN2gby
	8fJo3PqEvMZxx4y6G2qFVqwX31vgzBo=
X-CSE-ConnectionGUID: PzNCktAGTlWV7vFfFcy/SQ==
X-CSE-MsgGUID: h3GFZvOsTD+IMDlXvhXzeA==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="173025035"
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
Thread-Index: AQHczWStG402cYfvG0abnoxECDQH6bXhN5RF
Date: Thu, 16 Apr 2026 06:21:02 +0000
Message-ID: <099e29ad369a42978bad996fa315b006@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
 <20260416052752.713821-1-gxxa03070307@gmail.com>,<900daae4-654f-4e90-898e-e13020e7753e@linux.ibm.com>
In-Reply-To: <900daae4-654f-4e90-898e-e13020e7753e@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_099e29ad369a42978bad996fa315b006xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Stat-Signature: jz1g9srr6kwytxh16jdejuaazbhei7tr
X-Rspam-User: 
X-Rspamd-Queue-Id: 7750E140005
X-HE-Tag: 1776320465-334090
X-HE-Meta: U2FsdGVkX1/PjCjSOhg4iOCs/6ZRVpXO/IzV5oMALl3VDJ666MTRVZ5efqsXipB0D4cxmQ5lIgQX9HeaDFQI1FaqNkpfeQT95SHmlAh1WAXY5VuJTwtTYN/QPoWSVQexxNQLBtL7fhRqWhqEu8KAFSb0Y/EqJlHQyjGIgPsYjIQLYy9fSsuaiSiW6uxZExKT+azm0V4oJJi6PyH8GTJsa2rv/j7PiK/aMO6Wq/7NRkIsf4YYGuFLrWiqViGJ1vjtk/cVhfhWIKC1/rskrjixM0lqKNkuP7LWZh8LEenGatEsEINxIs7DgB+Pjlp3X8CvflWdLuocDp2wsXg3PVbZzI+RA4mLkRylpK60R6Nfl0e9c6zBHl1WTQQXYBSkJnEwmNFn+ilFeX6EFsZqIn4Cnvuzz/yY0URm0OKAj6OQSij3axN5/oZtz8dpsrVqU3xEv7kCrXtxwHFmSgj/JG95gezxq30X9emQWNQWv1hrnEEPiAt0yZKHDxQPi79wo8fUZJa/lRgar89cIs15h4IoHpPs94y0n+1xSzK7uZc79PtOvd1gx/iLJ2WVHaxqEdz0r1QmsWbGtFOkEvkTJQ2wDRUM4iIsUkDFy4QprpQ4iKtDe+TNdx3KrCrHts6EabqfGcOEjZ1ctmz1k9KIyVVX8teVElgZH4D4t53UEF5d+dWzu0VLnj6fbia6rM/7MonXTgh54vi9cpeDrZSeJDCsSZE22DL/ypXmZZV3RdbpUvVi2R9WHRPskfTQXIlLjbskuBxXS3i5hww1P8+oqsNHjY3nMd8/BYNQvd61YUk4VwWR+LGrj7MrZXRXX4bYw5wtOqFub+kdRj/cnq41ij2/z3MQF+YlhDuf/92G/n+G2yQD0wXY2/90qrbJsJ6hn0tYNCiwVIPWaF7etINoEg78H6hd68zIiWvA7KF7mXPfXb6xi+jhCNP48ZCsHuH3quuVSIIEJVIRUWcsuc0jVdu
 SPYIu7JW
 w8xmcsPtViZYdi+ZvcfPd5WnHs/gW1vY2sYx4ArexYg3277O0+oKowoqTHc5gQHvB1X1Fpv2Z7n4HdOIQMLd9GJOfVairP8m3qXjBFnfa32svGCEXpeRFM5dW2ZwyJjkEVoXWdnYcE19vUfsotq7Soytx83taDqb1y/dzF7HIF86arpyDUW4mBqguLZZHkvonu0B6eoQD9R8iuibTZnPls7tqxNlHE8rrAEx2w4Qp+ejQSFU1RDjQx9ZnFw9niIhoJ+09ADHt1Jn+6E7T/at2D6t373Ar1WsE2cU0PMB7+WzfpBOx6z3hTQBLfM1HIPNmfDsxg005lKNZOcvT0eitAeoWHCuVIKxR0hoA/ai2jPQgvQNiAGRC0eaxHjlIRAw5a9UzqP0IIa6yfNyeyXm8y4NmDwd8lGnk18jKic42Z6M7YbR5fM3xscPqO94uqSMe3xvi9M4lsPsHuqYqxkrvghUxDvhz/KRHFySODuhYYKA0bZtflFdcG336yNQkMyw8hDQCUKids1nEiz9FP/AB0XTHC4tzm+wBBXIQGe+kfpLYWTWqiKQLGmFixTgpzIHLaWPmXMX1xkqpFyCoqsL9b15uiJj5EsSmm0kdiFOA7Ft3ri8yMXfLAxFl2d8Xdnwwd4Edlojbig7o29WXroaTw4/w3D5+gVwqrolW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_099e29ad369a42978bad996fa315b006xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

b2ssIHRoYW5rcy4NCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCreivP7Iyzog
RG9uZXQgVG9tIDxkb25ldHRvbUBsaW51eC5pYm0uY29tPg0Kt6LLzcqxvOQ6IDIwMjbE6jTUwjE2
yNUgMTM6NDg6MjMNCsrVvP7IyzogWGlhbmcgR2FvOyBBbmRyZXcgTW9ydG9uDQqzrcvNOiBsaW51
eC1tbUBrdmFjay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRvbmV0LnRvbUBn
bWFpbC5jb207ILjfz+gNCtb3zOI6IFtFeHRlcm5hbCBNYWlsXVJlOiBbUEFUQ0ggdjJdIG1tL3Bh
Z2VfYWxsb2M6IGZpeCBzcGFjZXMgdXNlZCBmb3IgaW5kZW50YXRpb24gaW5zdGVhZCBvZiB0YWJz
DQoNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQocPXuavLvs3isr+jrMfrvffJ97SmwO2ho8j0
ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7XqreiuPhtaXNlY0B4aWFvbWkuY29tvfjQ0Le0wKEN
Cg0KSGkNCg0KT24gNC8xNi8yNiAxMDo1NyBBTSwgWGlhbmcgR2FvIHdyb3RlOg0KDQpGcm9tOiBY
aWFuZyBHYW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT48bWFpbHRvOmdhb3hpYW5nMTdAeGlhb21p
LmNvbT4NCg0KY2hlY2twYXRjaC5wbCByZXBvcnRzIHR3byBpbmRlbnRhdGlvbiBlcnJvcnMgaW4g
cGFnZV9hbGxvYy5jIHdoZXJlDQpzcGFjZXMgYXJlIHVzZWQgaW5zdGVhZCBvZiB0YWJzOg0KDQog
IEVSUk9SOiBjb2RlIGluZGVudCBzaG91bGQgdXNlIHRhYnMgd2hlcmUgcG9zc2libGUNCiAgIzg4
NzogRklMRTogbW0vcGFnZV9hbGxvYy5jOjg4NzoNCiAgKyAgICAgICAgVk1fV0FSTl9PTkNFKGdl
dF9wYWdlYmxvY2tfbWlncmF0ZXR5cGUocGFnZSkgIT0gbWlncmF0ZXR5cGUsJA0KDQogIEVSUk9S
OiBjb2RlIGluZGVudCBzaG91bGQgdXNlIHRhYnMgd2hlcmUgcG9zc2libGUNCiAgIzY2MjY6IEZJ
TEU6IG1tL3BhZ2VfYWxsb2MuYzo2NjI2Og0KICArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3lzY3RsX21pbl91bm1hcHBlZF9yYXRpbykgLyAx
MDA7JA0KDQpJbiBfX2RlbF9wYWdlX2Zyb21fZnJlZV9saXN0KCksIHRoZSBWTV9XQVJOX09OQ0Ug
YXQgbGluZSA4ODcgdXNlcyA4DQpzcGFjZXMgZm9yIGluZGVudGF0aW9uIGluc3RlYWQgb2YgYSB0
YWIuIFRoZSBpZGVudGljYWwgVk1fV0FSTl9PTkNFDQpjYWxscyBpbiBfX2FkZF90b19mcmVlX2xp
c3QoKSBhbmQgbW92ZV90b19mcmVlX2xpc3QoKSBib3RoIGNvcnJlY3RseQ0KdXNlIGEgdGFiLg0K
DQpJbiBzZXR1cF9taW5fdW5tYXBwZWRfcmF0aW8oKSwgdGhlIGNvbnRpbnVhdGlvbiBsaW5lIGF0
IDY2MjYgdXNlcyA2DQp0YWJzICsgOSBzcGFjZXMgZm9yIGFsaWdubWVudC4gUmVwbGFjZSB0aGUg
ZXhjZXNzIHNwYWNlcyB3aXRoIDYgdGFicw0KKyAxIHNwYWNlIHRvIGNvcnJlY3RseSBhbGlnbiB3
aXRoIHRoZSBvcGVuaW5nIHBhcmVudGhlc2lzIG9uIHRoZQ0KcHJldmlvdXMgbGluZS4NCg0KU2ln
bmVkLW9mZi1ieTogWGlhbmcgR2FvIDxnYW94aWFuZzE3QHhpYW9taS5jb20+PG1haWx0bzpnYW94
aWFuZzE3QHhpYW9taS5jb20+DQoNCg0KSXQgbWlnaHQgYmUgYmV0dGVyIHRvIHNlbmQgdjIgYXMg
YSBuZXcgc2VyaWVzIG5leHQgdGltZSChqmp1c3QgYSBzdWdnZXN0aW9uLg0KDQoNCkxHVE0gUmV2
aWV3ZWQgYnk6IERvbmV0IFRvbSA8ZG9uZXR0b21AbGludXguaWJtLmNvbT48bWFpbHRvOmRvbmV0
dG9tQGxpbnV4LmlibS5jb20+IC1Eb25ldA0KDQoNCi0tLQ0KIG1tL3BhZ2VfYWxsb2MuYyB8IDQg
KystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9tbS9wYWdlX2FsbG9jLmMgYi9tbS9wYWdlX2FsbG9jLmMNCmluZGV4IDJk
NGI2ZjFhNTU0ZS4uNzUyNjczYTliNDNjIDEwMDY0NA0KLS0tIGEvbW0vcGFnZV9hbGxvYy5jDQor
KysgYi9tbS9wYWdlX2FsbG9jLmMNCkBAIC04ODQsNyArODg0LDcgQEAgc3RhdGljIGlubGluZSB2
b2lkIF9fZGVsX3BhZ2VfZnJvbV9mcmVlX2xpc3Qoc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB6
b25lICp6b24NCiB7DQogICAgICAgIGludCBucl9wYWdlcyA9IDEgPDwgb3JkZXI7DQoNCi0gICAg
ICAgIFZNX1dBUk5fT05DRShnZXRfcGFnZWJsb2NrX21pZ3JhdGV0eXBlKHBhZ2UpICE9IG1pZ3Jh
dGV0eXBlLA0KKyAgICAgICBWTV9XQVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShw
YWdlKSAhPSBtaWdyYXRldHlwZSwNCiAgICAgICAgICAgICAgICAgICAgICJwYWdlIHR5cGUgaXMg
JWQsIHBhc3NlZCBtaWdyYXRldHlwZSBpcyAlZCAobnI9JWQpXG4iLA0KICAgICAgICAgICAgICAg
ICAgICAgZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShwYWdlKSwgbWlncmF0ZXR5cGUsIG5yX3Bh
Z2VzKTsNCg0KQEAgLTY2MjMsNyArNjYyMyw3IEBAIHN0YXRpYyB2b2lkIHNldHVwX21pbl91bm1h
cHBlZF9yYXRpbyh2b2lkKQ0KDQogICAgICAgIGZvcl9lYWNoX3pvbmUoem9uZSkNCiAgICAgICAg
ICAgICAgICB6b25lLT56b25lX3BnZGF0LT5taW5fdW5tYXBwZWRfcGFnZXMgKz0gKHpvbmVfbWFu
YWdlZF9wYWdlcyh6b25lKSAqDQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzeXNjdGxfbWluX3VubWFwcGVkX3JhdGlvKSAvIDEwMDsNCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzeXNjdGxfbWlu
X3VubWFwcGVkX3JhdGlvKSAvIDEwMDsNCiB9DQoNCg0KDQo=

--_000_099e29ad369a42978bad996fa315b006xiaomicom_
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
<p>ok, thanks.</p>
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

--_000_099e29ad369a42978bad996fa315b006xiaomicom_--


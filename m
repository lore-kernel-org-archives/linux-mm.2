Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD32CCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0996B00DA; Wed, 20 Aug 2025 05:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681216B00DD; Wed, 20 Aug 2025 05:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FCC6B00DE; Wed, 20 Aug 2025 05:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41C746B00DA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:27:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAF30834D1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:27:46 +0000 (UTC)
X-FDA: 83796608532.04.5BF8086
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2570216000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:27:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf08.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755682064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I56lJZ0EEXeSnngQms6yeWfHVeTKrWebLNbxxVTwlJM=;
	b=IZr8dkra6KPig6c219GCrzb44ajz9XGkv58xN2W5UFy+Qdi3AEqOtKNZBA4wIa+eZVNLoh
	IbFmo5iRC7KJm7edVabQscaoEI4az0ZZKhYMkFwMRV7LhbL+ztVsx/Y9F9/D5i+HnMcsas
	ZZACl1u69uF+JaBg8nnkX952q/XPeYs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf08.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755682064; a=rsa-sha256;
	cv=none;
	b=hdcXhmlEF59RbXVik5y7vFwK10E9Iq+xzwgcUZ9fAJUHD8DJdK3Grk/RXO8DFWKoj7pT6i
	p6GVbiAzPpxm0Edn4QIv4uNfQ4/OR0nnWPyMi6+2JJJBs5o161pYN+a1BJEslVVhVNXmZZ
	gdJj2KUAEmkAMwIrdchGzMmEkgjQx8A=
X-CSE-ConnectionGUID: sH/JJ5ZVT9OIWXXMtXMoSg==
X-CSE-MsgGUID: XV6mO3LwSkiSTMkmi+tEiw==
X-IronPort-AV: E=Sophos;i="6.17,302,1747670400"; 
   d="scan'208,217";a="149798575"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: David Hildenbrand <david@redhat.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2MiAxLzFdIG1tL2Nt?=
 =?gb2312?B?YTogYWRkICdhdmFpbGFibGUgY291bnQnIGFuZCAndG90YWwgY291bnQnIHRv?=
 =?gb2312?B?IHRyYWNlX2NtYV9hbGxvY19zdGFydA==?=
Thread-Topic: [External Mail]Re: [PATCH v2 1/1] mm/cma: add 'available count'
 and 'total count' to trace_cma_alloc_start
Thread-Index: AQHcEbLPpvTY2nX9Vk+zuVP60tUoN7RrRXDq
Date: Wed, 20 Aug 2025 09:27:37 +0000
Message-ID: <d54bb3a5e5924dbc87cdf63e22ac7d00@xiaomi.com>
References: <cover.1755654367.git.gaoxiang17@xiaomi.com>
 <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>,<24ed0c41-6ec3-47ba-8f63-94c521df995b@redhat.com>
In-Reply-To: <24ed0c41-6ec3-47ba-8f63-94c521df995b@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.163]
Content-Type: multipart/alternative;
	boundary="_000_d54bb3a5e5924dbc87cdf63e22ac7d00xiaomicom_"
MIME-Version: 1.0
X-Stat-Signature: yymd4o7p6d6itkuytzg3r1w3z3xgob14
X-Rspam-User: 
X-Rspamd-Queue-Id: 2570216000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755682062-6660
X-HE-Meta: U2FsdGVkX18dnVIz/mcqpw8eJVn+u0wrSpSGU6l/UBPHtcqQzDF4x0zw9U0DsibHnqvl9Os6GdWkk1PUoJayoHaMKI9pXr13uFedooW3HkN2K0kPQunRetqrW9lBB6tDujTC0OHji8eS+hQoXlqquoua3d2fkjyZZnaUFcy2bqF3WTSrhut5fvFaYd6vDEQ+37kfMNTJD0KjkWwHpCDVBaewPFaC2aH0MNktcWMOwSjSKnsxKmuHSoe5xKeHbMIcGREvaHT/AG5rJeOP4ajhi/bWinuTE8oowqxQs/vFCmq0OJXjxAxAAqi1zJmo/8XIt37qCi+l872v4qxaoadyd3X8+MLFZS2j5Ybjgf6mHr8hWlrixcQzq5cv7zQ5buC557cYOHDvtx8/6yLabWaHsfslCwsNobvAygKCq8TJJhBUESJdn5seuDdStSl5I2dwd1vUTbPMB8Bx0Jv/iBTD9yI4EZne2JkUDQYIwb/ntMamhORL/ucTxkChAVwbXwE1ZwdeKBxOr1AQQqsRw0qsS4AiqBYXBoFqDu0LkJqCnydz3fF0ztYvHOEiE6wvSxsQnRyfJNOVZmvE8XYtGnjzF5GROErXnMNoFixo1TMO0i0czrdW5LOFk6FYqLBx/6r5DE5lLf9m+VKusAKdtK4bZ6hGLuk7J6H7HZ2ik4b4Zb/3nAojvjYnJsR2PqabJOmy/wuhRi/U15+MaLhfMTKMh4KT6X85B8IWloM+/Y2imnMV4LkNRpDtLD5/diaA4mprTxZiSdDXujY7IszCy810Yt3Qk5fVDiV44QjQXLc1L/wiZou7FxzJhlhE3ybVLZHHVxByxp+dU6prVEnsmXxS+2fK7nfzN/GTfG9O4ppLgI+wjqpc4/M7XKlHpruuZ8lUtP3IjC4/6c+eSBBIgaowt56jsdS5pj8YA8faDyQeHEhEzStJRQccxIBaE4KOA7W6Nlqbf/nrx5f64xdMlNk
 rIu2JIwA
 coFKfnoFVVAQcXIYFWQGIJqLBJeZx0mPgCLEw6TmdKiY98atLlCbILomJr08QkaEsD8dFr+7cGrZ0BexwM6hp90hghM2vQuMDy9x/lQW1b7C/K/bOlWlO5NKKxB7PsIil2YxrX4Wvl/ITGTsdljJogMofIftKzHvFg1kgNH9Vbdeg0GVYFW++4YrS+IICuxcWPy27et/zLQhL1auial2Kc2WjmY8O0ZawksmB1c8O4Yq8u+lL+bfPtRXIdYFeikn5Y5bTP03LnSeA56S7pmhS/4DnV76LPFipfD0neEQEOPr93eQBoMgKYek7rE67Z3qv0dGNcyGnzkHrGHwZ0nThEbqSyfGDmElNuqcDf3JzYMcXK2OfbuUB1oqLirG6sjDzQICDiPv+bP58Kyn9eLMZnxEPfD8/kFNHZr1USjzHSSbgN2uTo79qMgLLN8dOvOhZljPwlCxMYGlpxar4kY1+jpTk6Ls6cMn+10zO8zMlTy2IDNXIbBeGC1nAGPgP7R2uLNKCmAW+RK+qQIMpw9Py+IOHTdCYFmkPVOwQ8DphN8vvZghr8OtAWoke0P4qra0qznhBSdcGSEtOydqdoNFcbFdcweOzEOJ7nzDZvCMl1pjWJ5Z6mQDl2xtmFQA3LZZF4PxvVrBxnIBdqKy5wG1a4O9o+t1Q63pP3sQht0JOhQCgeXFXoCl/J8LNw7P7h6UPEor884nBNz97xCm9nbJQP3ERNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_d54bb3a5e5924dbc87cdf63e22ac7d00xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SXMgInJlcXVlc3QgY291bnQiIGFsc28gd3JpdHRlbiBpbiB0aGUgdGl0bGU/IFRoZSBwcmV2aW91
cyAiY291bnQiIHdhcyBjaGFuZ2VkIHRvICJyZXF1ZXN0X2NvdW50Ig0KDQoNCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZpZEBy
ZWRoYXQuY29tPg0Kt6LLzcqxvOQ6IDIwMjXE6jjUwjIwyNUgMTc6MTQ6MTANCsrVvP7IyzogWGlh
bmcgR2FvOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnDQqzrcvNOiBsb3JlbnpvLnN0b2FrZXNA
b3JhY2xlLmNvbTsgTGlhbS5Ib3dsZXR0QG9yYWNsZS5jb207IHZiYWJrYUBzdXNlLmN6OyBycHB0
QGtlcm5lbC5vcmc7IHN1cmVuYkBnb29nbGUuY29tOyBtaG9ja29Ac3VzZS5jb207IGxpbnV4LW1t
QGt2YWNrLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsguN/P6A0K1vfM4jogW0V4
dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2MiAxLzFdIG1tL2NtYTogYWRkICdhdmFpbGFibGUgY291
bnQnIGFuZCAndG90YWwgY291bnQnIHRvIHRyYWNlX2NtYV9hbGxvY19zdGFydA0KDQpbzeKyv9PK
vP5dILTL08q8/sC01LTT2tChw9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS0
5tLJo6zH672r08q8/teqt6K4+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpPbiAyMC4wOC4y
NSAwMzo1MywgWGlhbmcgR2FvIHdyb3RlOg0KPiBGcm9tOiBnYW94aWFuZzE3IDxnYW94aWFuZzE3
QHhpYW9taS5jb20+DQo+DQo+IFRoaXMgbWFrZXMgY21hIGluZm8gbW9yZSBpbnR1aXRpdmUgZHVy
aW5nIGRlYnVnZ2luZy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogZ2FveGlhbmcxNyA8Z2FveGlhbmcx
N0B4aWFvbWkuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRlL3RyYWNlL2V2ZW50cy9jbWEuaCB8IDE5
ICsrKysrKysrKysrKystLS0tLS0NCj4gICBtbS9jbWEuYyAgICAgICAgICAgICAgICAgICB8ICAy
ICstDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygt
KQ0KPg0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvY21hLmggYi9pbmNsdWRl
L3RyYWNlL2V2ZW50cy9jbWEuaA0KPiBpbmRleCAzODNjMDlmNTgzYWMuLjU2NTVhYzUyMWZiNSAx
MDA2NDQNCj4gLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvY21hLmgNCj4gKysrIGIvaW5jbHVk
ZS90cmFjZS9ldmVudHMvY21hLmgNCj4gQEAgLTM4LDI1ICszOCwzMiBAQCBUUkFDRV9FVkVOVChj
bWFfcmVsZWFzZSwNCj4NCj4gICBUUkFDRV9FVkVOVChjbWFfYWxsb2Nfc3RhcnQsDQo+DQo+IC0g
ICAgIFRQX1BST1RPKGNvbnN0IGNoYXIgKm5hbWUsIHVuc2lnbmVkIGxvbmcgY291bnQsIHVuc2ln
bmVkIGludCBhbGlnbiksDQo+ICsgICAgIFRQX1BST1RPKGNvbnN0IGNoYXIgKm5hbWUsIHVuc2ln
bmVkIGxvbmcgcmVxdWVzdF9jb3VudCwgdW5zaWduZWQgbG9uZyBhdmFpbGFibGVfY291bnQsDQo+
ICsgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyB0b3RhbF9jb3VudCwgdW5zaWduZWQgaW50IGFs
aWduKSwNCj4NCj4gLSAgICAgVFBfQVJHUyhuYW1lLCBjb3VudCwgYWxpZ24pLA0KPiArICAgICBU
UF9BUkdTKG5hbWUsIHJlcXVlc3RfY291bnQsIGF2YWlsYWJsZV9jb3VudCwgdG90YWxfY291bnQs
IGFsaWduKSwNCj4NCj4gICAgICAgVFBfU1RSVUNUX19lbnRyeSgNCj4gICAgICAgICAgICAgICBf
X3N0cmluZyhuYW1lLCBuYW1lKQ0KPiAtICAgICAgICAgICAgIF9fZmllbGQodW5zaWduZWQgbG9u
ZywgY291bnQpDQo+ICsgICAgICAgICAgICAgX19maWVsZCh1bnNpZ25lZCBsb25nLCByZXF1ZXN0
X2NvdW50KQ0KPiArICAgICAgICAgICAgIF9fZmllbGQodW5zaWduZWQgbG9uZywgYXZhaWxhYmxl
X2NvdW50KQ0KPiArICAgICAgICAgICAgIF9fZmllbGQodW5zaWduZWQgbG9uZywgdG90YWxfY291
bnQpDQo+ICAgICAgICAgICAgICAgX19maWVsZCh1bnNpZ25lZCBpbnQsIGFsaWduKQ0KPiAgICAg
ICApLA0KPg0KPiAgICAgICBUUF9mYXN0X2Fzc2lnbigNCj4gICAgICAgICAgICAgICBfX2Fzc2ln
bl9zdHIobmFtZSk7DQo+IC0gICAgICAgICAgICAgX19lbnRyeS0+Y291bnQgPSBjb3VudDsNCj4g
KyAgICAgICAgICAgICBfX2VudHJ5LT5jb3VudCA9IHJlcXVlc3RfY291bnQ7DQo+ICsgICAgICAg
ICAgICAgX19lbnRyeS0+YXZhaWxhYmxlX2NvdW50ID0gYXZhaWxhYmxlX2NvdW50Ow0KPiArICAg
ICAgICAgICAgIF9fZW50cnktPnRvdGFsX2NvdW50ID0gdG90YWxfY291bnQ7DQo+ICAgICAgICAg
ICAgICAgX19lbnRyeS0+YWxpZ24gPSBhbGlnbjsNCj4gICAgICAgKSwNCj4NCj4gLSAgICAgVFBf
cHJpbnRrKCJuYW1lPSVzIGNvdW50PSVsdSBhbGlnbj0ldSIsDQo+ICsgICAgIFRQX3ByaW50aygi
bmFtZT0lcyBjb3VudD0lbHUgcmVxdWVzdF9jb3VudD0lbHUgdG90YWxfY291bnQ9JWx1IGFsaWdu
PSV1IiwNCg0KInJlcXVlc3RlZF9jb3VudCIgPw0KDQotLQ0KQ2hlZXJzDQoNCkRhdmlkIC8gZGhp
bGRlbmINCg0K

--_000_d54bb3a5e5924dbc87cdf63e22ac7d00xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<meta content=3D"text/html; charset=3DUTF-8">
<style type=3D"text/css" style=3D"">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size:12pt; col=
or:#000000; font-family:Calibri,Helvetica,sans-serif">
<p></p>
<div>Is &quot;request count&quot; also written in the title?&nbsp;<span sty=
le=3D"font-size:12pt">The previous &quot;count&quot; was changed to &quot;r=
equest_count&quot;</span></div>
<br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> David=
 Hildenbrand &lt;david@redhat.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2025=C4=EA8=D4=C220=C8=D5 17:14:10<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org<br>
<b>=B3=AD=CB=CD:</b> lorenzo.stoakes@oracle.com; Liam.Howlett@oracle.com; v=
babka@suse.cz; rppt@kernel.org; surenb@google.com; mhocko@suse.com; linux-m=
m@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH v2 1/1] mm/cma: add 'availab=
le count' and 'total count' to trace_cma_alloc_start</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
On 20.08.25 03:53, Xiang Gao wrote:<br>
&gt; From: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; This makes cma info more intuitive during debugging.<br>
&gt;<br>
&gt; Signed-off-by: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt; ---<br>
&gt;&nbsp;&nbsp; include/trace/events/cma.h | 19 &#43;&#43;&#43;&#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;------<br>
&gt;&nbsp;&nbsp; mm/cma.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 2 &#43;-=
<br>
&gt;&nbsp;&nbsp; 2 files changed, 14 insertions(&#43;), 7 deletions(-)<br>
&gt;<br>
&gt; diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h<b=
r>
&gt; index 383c09f583ac..5655ac521fb5 100644<br>
&gt; --- a/include/trace/events/cma.h<br>
&gt; &#43;&#43;&#43; b/include/trace/events/cma.h<br>
&gt; @@ -38,25 &#43;38,32 @@ TRACE_EVENT(cma_release,<br>
&gt;<br>
&gt;&nbsp;&nbsp; TRACE_EVENT(cma_alloc_start,<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; TP_PROTO(const char *name, unsigned long cou=
nt, unsigned int align),<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; TP_PROTO(const char *name, unsigned long=
 request_count, unsigned long available_count,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; unsigned long total_count, unsigned int align),<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; TP_ARGS(name, count, align),<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; TP_ARGS(name, request_count, available_c=
ount, total_count, align),<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TP_STRUCT__entry(<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __string(name, name)<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; __field(unsigned long, count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, request_count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, available_count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, total_count)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __field(unsigned int, align)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ),<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TP_fast_assign(<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __assign_str(name);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; __entry-&gt;count =3D count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;count =3D request_count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;available_count =3D available_count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;total_count =3D total_count;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __entry-&gt;align =3D align;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ),<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; TP_printk(&quot;name=3D%s count=3D%lu align=
=3D%u&quot;,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; TP_printk(&quot;name=3D%s count=3D%lu re=
quest_count=3D%lu total_count=3D%lu align=3D%u&quot;,<br>
<br>
&quot;requested_count&quot; ?<br>
<br>
--<br>
Cheers<br>
<br>
David / dhildenb<br>
<br>
</div>
</span></font>
</body>
</html>

--_000_d54bb3a5e5924dbc87cdf63e22ac7d00xiaomicom_--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94550CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1C08E0033; Wed, 20 Aug 2025 18:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1620F8E0031; Wed, 20 Aug 2025 18:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0791D8E0033; Wed, 20 Aug 2025 18:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECB648E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:38:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51E38116692
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:38:45 +0000 (UTC)
X-FDA: 83798601810.12.98FBAC7
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf23.hostedemail.com (Postfix) with ESMTP id ADF59140003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:38:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf23.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755729523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+kugA67OCaB297GQyZcHaK57nKLS6xc36vHvVHAssNw=;
	b=SVCy2f1/RfRHhTBWT/1Pgavli4c/0+Ps6/2gqZSHYc8gthk19m9rBlTDxurOwEK1JjlUOH
	i9p7LAefHg2ExUEyScK0RKZ+cY9Y0Vkam+1ws2MbqtGSuB+0GMktkFYPRKEWFiKE3Jatnj
	EhXo42uKUR5U6eHhvJeefsnIIUJ4hzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755729523; a=rsa-sha256;
	cv=none;
	b=tQDjvKsxZHYhhn0PBq7AvEngs168ZP/95kZ4ri1n6/jMo+E1dkj+S9PcyVLpY4T0iMzgQc
	sRPZLKCxMyOwP8U2jNSPzs/LUCML/LzCuqh0QN/kdsniwjo8lPW6hAzuU33/ZiNh9Dq263
	Y8rs+vjWEJFduv2OUmZR16fmW08uh7w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf23.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
X-CSE-ConnectionGUID: IE4RIiCeREGU2SgHe9FDKg==
X-CSE-MsgGUID: PLENeuMWQZCa8u5PMlRYjQ==
X-IronPort-AV: E=Sophos;i="6.17,306,1747670400"; 
   d="scan'208,217";a="124113689"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: David Hildenbrand <david@redhat.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogtPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2MiAxLzFd?=
 =?gb2312?B?IG1tL2NtYTogYWRkICdhdmFpbGFibGUgY291bnQnIGFuZCAndG90YWwgY291?=
 =?gb2312?B?bnQnIHRvIHRyYWNlX2NtYV9hbGxvY19zdGFydA==?=
Thread-Topic: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2MiAxLzFdIG1tL2Nt?=
 =?gb2312?B?YTogYWRkICdhdmFpbGFibGUgY291bnQnIGFuZCAndG90YWwgY291bnQnIHRv?=
 =?gb2312?B?IHRyYWNlX2NtYV9hbGxvY19zdGFydA==?=
Thread-Index: AQHcEbLPpvTY2nX9Vk+zuVP60tUoN7RrRXDq//97UYCAAWIW/Q==
Date: Wed, 20 Aug 2025 22:38:38 +0000
Message-ID: <a6237bfc40e54fc7bc8f370a5201c11d@xiaomi.com>
References: <cover.1755654367.git.gaoxiang17@xiaomi.com>
 <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
 <24ed0c41-6ec3-47ba-8f63-94c521df995b@redhat.com>
 <d54bb3a5e5924dbc87cdf63e22ac7d00@xiaomi.com>,<2c669a58-1741-4b22-8fa5-752501a6e128@redhat.com>
In-Reply-To: <2c669a58-1741-4b22-8fa5-752501a6e128@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.166]
Content-Type: multipart/alternative;
	boundary="_000_a6237bfc40e54fc7bc8f370a5201c11dxiaomicom_"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADF59140003
X-Stat-Signature: mmc5qn5bfo8m136zwa8bnqqhb4ukuyhp
X-HE-Tag: 1755729522-226087
X-HE-Meta: U2FsdGVkX19RMhAAdC4rJ2WyAodZU+3wwYnfQ8xiFflI8gIoMr51PiE74sre5AbDJ5UoKRewdrqUoLtg51UosyeCsWf3aXRBICTufkmArP1Crh7xWv87FhImUcSrajMVVZjO3yeK99CCk7D1AV1GBaiD7pZ989Vj2RApCvKCn4986514o3YRX9zyaM19F4Kjuk2+ryfA6EvnALVIpgGZMIpkXe4dycLqNa5aXpbjfZpNEr8Qa7q81oOCO3bBm5w85t0NdliqZYdB/M2LVf6zp1yzIFE6cRZUyvEkQuqYV9KX+r6ow+oFTaX9FyHYSsNhSns/ETXDW7miOZGqcbCPjZK84BKhuE8SEQ5p/qu9pMWaHysC7OqO23h1JY1JzDARHh+xaCU6rsBYdIgUNp/ebOaIvUKHWTX1TudfaFYxn319oNVT5m9Oi3rlbzr3IuX56hGzTPD1dbvew00Oe2exHeY/ahwiYEamD+oe1srHZUTiO9hLs3RpkAYVPFhbirkuwpzo2veOqOO4d2sPhD20JQsw5OeHO076ftEwqdR6JQ5r1Zc0KA7PS7zgWTPvkduW70P5p7HoTwz8mVUTmrprRvV989lZlz9tZ9QHC+ftv3qlIUYFBiQo/5F9CEl0v6csTmZFXOuWWhznLUjUoDQk0uJpR33AZDmvEG07bCPfNz017Z57Zv1//69R4aRQs9uq6fscc58GYv+6Pfm80WB+A6fbY13TaCvviHw4Mt2impz05BaDAY9vwFlVq/l6RLzRocstDWJ9PakchM/M/cmDSXQE/asH9AyeybB0usHVdarrJMImGVHF3/8YGzpvDtB8FouzP1nSLRhVG5a+KxW9glYFaEtCpHqOsCrMUNln/WrfHpN+nibWvaTP4I2eYlT99zelwibPAs0TsHAU0hopaGUFKz6SpUHP95R/HE54+Wc6eOv27QSZbFy6bD7eBU9Gw8kwIDH+tvDXbsa5Dul
 rQ7hViep
 7UOi1tOaOXr9I2Mg92gSq/6DNUCS68jHUHPJ3SOKBbI+fZ+Hgb9PiOv7oRhx8BWYAdEQBV3g4zl29P7p5j7+ipF9T1UUnMWEBZ/gu24D2yeJz6AZYXpHOsiH+8wXB55xmy11vuEV/QPECIKcD3Ufc8kpHtTXnGe1akGT7xgkxRMjx6cphOzrtUFWs7Txp6X3J9P8WL1k4jphXyFt0/9DSnRPdQ/wzAAaLGloy2WhBS9FypHp6dZxcwkcxkqu0ySCBJduXi9cB+5/Qy0A+9QfZoGwkPv05ltJwvw4yimFq6bo+8tKzi5rxAWQbA4TuhUfXLp8gVRlBO5mCHW4kT+fgCZujtYzs59jWwg0D+y3cCRKyL3QWJpieYnbfd0KqMpeZNQXb9z+0LVVy9t2+5dVNUlLjGMD64NhcbHKyqz0yPUOAD6nObMR9LkUOTaCSnNtWbUZSQTvRLuIb0pGJU9rHx9sDP9KV+tmyPxpuymEDABQ0ysJKAVDr2Fd93nLwtNW67W8Ek77UHcbNUVJa3G4XxqWv8SFjs2MaNeHoYo8e1Hpq24q2smZw0fgxCCAIQExu8dhBhBvSsgupTkHlhefO7angBxGPaniCBcGXpTp86ABXbOqBM3st28pYNYhh1CcCQ6Q5WNMihoWttSDuKSUOAyp/edp5lc+1Mi0/Q/FVmzYLzblnpvJicpt6y+gVbZeT6wyLVjsZkU2FBTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_a6237bfc40e54fc7bc8f370a5201c11dxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

c29ycnksIEkgY2hhbmdlZCBpdC4NCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18N
CreivP7IyzogRGF2aWQgSGlsZGVuYnJhbmQgPGRhdmlkQHJlZGhhdC5jb20+DQq3osvNyrG85Dog
MjAyNcTqONTCMjDI1SAxNzozMDo1Nw0KytW8/sjLOiC438/oOyBYaWFuZyBHYW87IGFrcG1AbGlu
dXgtZm91bmRhdGlvbi5vcmcNCrOty806IGxvcmVuem8uc3RvYWtlc0BvcmFjbGUuY29tOyBMaWFt
Lkhvd2xldHRAb3JhY2xlLmNvbTsgdmJhYmthQHN1c2UuY3o7IHJwcHRAa2VybmVsLm9yZzsgc3Vy
ZW5iQGdvb2dsZS5jb207IG1ob2Nrb0BzdXNlLmNvbTsgbGludXgtbW1Aa3ZhY2sub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrW98ziOiBSZTogtPC4tDogW0V4dGVybmFsIE1haWxd
UmU6IFtQQVRDSCB2MiAxLzFdIG1tL2NtYTogYWRkICdhdmFpbGFibGUgY291bnQnIGFuZCAndG90
YWwgY291bnQnIHRvIHRyYWNlX2NtYV9hbGxvY19zdGFydA0KDQpbzeKyv9PKvP5dILTL08q8/sC0
1LTT2tChw9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH672r08q8
/teqt6K4+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpPbiAyMC4wOC4yNSAxMToyNywguN/P
6CB3cm90ZToNCj4gSXMgInJlcXVlc3QgY291bnQiIGFsc28gd3JpdHRlbiBpbiB0aGUgdGl0bGU/
IFRoZSBwcmV2aW91cyAiY291bnQiIHdhcw0KPiBjaGFuZ2VkIHRvICJyZXF1ZXN0X2NvdW50Ig0K
DQpSaWdodCwgImNtYS0+YXZhaWxhYmxlX2NvdW50IiBnZXRzIHRyYW5zbGF0ZWQgdG8gInJlcXVl
c3RfY291bnQiLiBNYXliZQ0KdGhhdCdzIHRoZSBpc3N1ZSBoZXJlPw0KDQpQTEVBU0UNCg0KQ2Fu
IHlvdSAoWGlhbmcgR2FvKSB0ZXN0IHRoZSBwYXRjaCBiZWZvcmUgc2VuZGluZyBpdD8NCg0KTm9i
b2R5IGhhcyB0aGUgY2FwYWNpdHkgaGVyZSB0byBnbyB0aHJvdWdoIDIwIGl0ZXJhdGlvbnMgb2Yg
c3VjaCBhDQp0cml2aWFsIGNoYW5nZS4NCg0KLS0NCkNoZWVycw0KDQpEYXZpZCAvIGRoaWxkZW5i
DQoNCg==

--_000_a6237bfc40e54fc7bc8f370a5201c11dxiaomicom_
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
<p>sorry, I changed it.</p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> David=
 Hildenbrand &lt;david@redhat.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2025=C4=EA8=D4=C220=C8=D5 17:30:57<br>
<b>=CA=D5=BC=FE=C8=CB:</b> =B8=DF=CF=E8; Xiang Gao; akpm@linux-foundation.o=
rg<br>
<b>=B3=AD=CB=CD:</b> lorenzo.stoakes@oracle.com; Liam.Howlett@oracle.com; v=
babka@suse.cz; rppt@kernel.org; surenb@google.com; mhocko@suse.com; linux-m=
m@kvack.org; linux-kernel@vger.kernel.org<br>
<b>=D6=F7=CC=E2:</b> Re: =B4=F0=B8=B4: [External Mail]Re: [PATCH v2 1/1] mm=
/cma: add 'available count' and 'total count' to trace_cma_alloc_start</fon=
t>
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
On 20.08.25 11:27, =B8=DF=CF=E8 wrote:<br>
&gt; Is &quot;request count&quot; also written in the title? The previous &=
quot;count&quot; was<br>
&gt; changed to &quot;request_count&quot;<br>
<br>
Right, &quot;cma-&gt;available_count&quot; gets translated to &quot;request=
_count&quot;. Maybe<br>
that's the issue here?<br>
<br>
PLEASE<br>
<br>
Can you (Xiang Gao) test the patch before sending it?<br>
<br>
Nobody has the capacity here to go through 20 iterations of such a<br>
trivial change.<br>
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

--_000_a6237bfc40e54fc7bc8f370a5201c11dxiaomicom_--


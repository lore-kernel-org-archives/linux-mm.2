Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBF3CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F396B00C2; Mon, 18 Aug 2025 01:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8B96B00C3; Mon, 18 Aug 2025 01:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7556B00C4; Mon, 18 Aug 2025 01:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72A606B00C2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:30:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D616B1A083D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:30:43 +0000 (UTC)
X-FDA: 83788753566.23.E0A8462
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DDA3C000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:30:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf22.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755495042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c2Jwbe0menIODva59p5jaPBBpZgIWN1bZp3z6Nm04M8=;
	b=qSbayoIvpw6KHyv0Dg72tma2ZuxUAw4grtJOSGIb4m5Tlpe1hvUau/Nz0eAfPdEmm26df7
	qSOuPl1aU+THxfL6yNxaU9H72tnn4vLotlUi51+ro/64Mw27bDNqkFG//dJTystjr48izx
	CQ+l+c5pBHV62nnUMFOyhrjhLW+kZCw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf22.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755495042; a=rsa-sha256;
	cv=none;
	b=THoUd5zjQkWl/sH6UG31My1V26/ysh/qR76Jz7R/YJ+lahRzrIkgwq4fa19TWuvKSPGzuT
	4fonCrOYKRflaDro+0++cG/oPmmSTOwaUNgeQCX/WZoc4yhTC24vdf+e4Y+BWu4eTg5n2X
	FRFDLE/hovQlPb06AGO7ZyUpMNdwVM4=
X-CSE-ConnectionGUID: Piij1jGDT2adA8TAE9JljA==
X-CSE-MsgGUID: 0XQTVN2qQhKcnIV4Y8Y6gw==
X-IronPort-AV: E=Sophos;i="6.17,293,1747670400"; 
   d="scan'208,217,223";a="149531036"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Xiang Gao <gxxa03070307@gmail.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vY21hOiBwcmlu?=
 =?gb2312?Q?t_total_and_used_pages_in_cma=5Falloc()?=
Thread-Topic: [External Mail]Re: [PATCH] mm/cma: print total and used pages in
 cma_alloc()
Thread-Index: AQHcDnbl7f2Ozihuy06VXnnXRnIlD7RkT6oAgAADKYCAAAp7AIAABFoAgAOCdZY=
Date: Mon, 18 Aug 2025 05:30:30 +0000
Message-ID: <d21f884907fe4dce81e5c16e2970a3b4@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
 <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
 <20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
 <701bfbb4-6c12-4614-a322-def3ca923c78@redhat.com>
 <20250816003418.b2a62f6ddbcf9468fde87a18@linux-foundation.org>,<167acb82-1368-4c8e-89bd-8dbe4877d5bb@redhat.com>
In-Reply-To: <167acb82-1368-4c8e-89bd-8dbe4877d5bb@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_d21f884907fe4dce81e5c16e2970a3b4xiaomicom_"
MIME-Version: 1.0
X-Stat-Signature: aazibzzd5x97nuper8co5w5tzz87um14
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DDA3C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755495040-199831
X-HE-Meta: U2FsdGVkX1/NOnNxbhGJuyfH4xs8c5hILa7WLTuVCDqDi5NYvFdh5+XAMenf2U4Un52nW3N9D4STzGtVB+4qEiVe+zbnk7MgLDmDLBNJh8sjuidBcPQxaXqR1ODZgio8Recf1ZueXMu9hdelnC5NCL6F3Umk01qBbkIzpKso47w+FnBEFEiC1iSKXNVwFZWk+9oJh0g41sGSRrMNlvxE/rtDwtXVZRSPh24SfJNO2UEWnxeYxaq4VT+GTPha38BQ1L7FgGCuC5b4uSIhPIcV98ygKKJ2FU98C1ApI9MH6bn6rFh9eOBf/1Ou37urKcEpWqFwfC+kp73ZaNKX72BFZfCjQXE9DaWxCj8sGXty4LIR3to45l+mLnOcs7FXbGzCoO6Dzo17A+yzzymJvKCLTZKtuquS5xgl/KeF5Oy7xW3PpjIl3ovvADrmPLogjq2/LkU98m5T+YIszA8U+78yLR3T4dQc8TIMutNNj0+SQGO/X/VJGjbdY5ixb2EUKMlO5H1BbWdDHYv+HYzcqy4aRYVV1UoJcT1ux9Wdj2lJZpaD/oX+vU9PHXVVZ+98w6UCgzBXrtw4ZTX/uwZxUuq2UPxzUuD270875w51CjHf/QLvySLygp88SqDms+8IrlDW86Ybz+d5jN3XhVPP3GJ7sGDELdqGU7/w7Qi6bk35is4hfuV5oDVgKb/2j96Zr5UUGJ2SJcGuvc6K7m3QfYp28mXQtnOJi9xsjVmWh8Chjx6+ybOCuddUX5f0+g+lGHLTr0NUsEhswN5aCEWj9mwhN/l0pi+x10oMGDh/stBaGrG21l6naVNMXsxVXws4O/jVd2LHrnWFrpG8MxyVu4g2ZLsjiZijjf5tCkF7DC6pKEgkOfp+3Eglyu7W0GW1w+UjsfzJOnGR+qp8wfq9WnXLRFTZ5YuJR+/GjLSyyUoi0zEFDCeOxx7v8Jpavt+4b6G4S+soKDXv5gM4LM5AmoT
 YpcqAmyS
 Ej6CFafnrwAOiIoAW2Wro5LWkwKddT9q0oMKTr8iQ6j8D5So3y71S+1sWoU5fpjkZMTPDHZxjqS0DqEE5fD2SBcKWXZn76cLo1ykHw+ahywT7sGjitkdfYVv6VnpcaTfq0+dEBwYpJ+mlXDHVDi1YVFfqODNlGcfziADCz+NB/t9CdpMF97nu5EsTSXGPSjSXVYrARYXEf2HRjXh+D7lFDqKfVWAF/UjEFj74hH2DBejjJQHAY8QtOiRbd1V1mGv0ODrk9ZpDPMW74K+BIFzxGlm6BOQIgIUgFb0nwm9BTWZ+pVtjzr7SAwvffo3wyGHBzoy/k52eCW60AnuD5+zktkNFASJ5dcvcQBcXWsxzy1HWinEelnJ8Hg/dC1x96R0R9gVenUBM/hPqvn0kTwoiDdBVRbMMFM58nUaSfO30N95kjdfdWH+b6F0MRNKOrn4vPQDr2zNkMYVmgzrYyOg1XBJNyXPSbl+KaaJc0j6Jwnpfa3GT7ggWdL159jc4tCjIW0w1HEaAdYKjalH/0F2WmfNEWBe+5FAtTe8I0t4CFxkvuWGOAnOv3TSaS6FzOiOKEYBEgMi0DY8PRWqXmfI+wNWPXtuVQBGLxzEvD9eAkgEtxo9HgSDXR8Llz2UrLC96L0uCAFODImZUJ0WCeegi+cox2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_d21f884907fe4dce81e5c16e2970a3b4xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

RnJvbSB0aGlzIHBlcnNwZWN0aXZlLCBpdCBzZWVtcyBiZXR0ZXIgdG8gYWRkIGl0IHRvIHRoZSB0
cmFjZS4gVGhlbiBzaGFsbCBJIG1ha2UgYSBwYXRjaCB0byBhZGQgdG8gdGhlIHRyYWNlPw0KDQoN
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IERhdmlkIEhpbGRlbmJy
YW5kIDxkYXZpZEByZWRoYXQuY29tPg0Kt6LLzcqxvOQ6IDIwMjXE6jjUwjE2yNUgMTU6NDk6NTIN
CsrVvP7IyzogQW5kcmV3IE1vcnRvbg0Ks63LzTogWGlhbmcgR2FvOyBsb3JlbnpvLnN0b2FrZXNA
b3JhY2xlLmNvbTsgTGlhbS5Ib3dsZXR0QG9yYWNsZS5jb207IHZiYWJrYUBzdXNlLmN6OyBycHB0
QGtlcm5lbC5vcmc7IHN1cmVuYkBnb29nbGUuY29tOyBtaG9ja29Ac3VzZS5jb207IGxpbnV4LW1t
QGt2YWNrLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsguN/P6A0K1vfM4jogW0V4
dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vY21hOiBwcmludCB0b3RhbCBhbmQgdXNlZCBwYWdl
cyBpbiBjbWFfYWxsb2MoKQ0KDQpbzeKyv9PKvP5dILTL08q8/sC01LTT2tChw9e5q8u+zeKyv6Os
x+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH672r08q8/teqt6K4+G1pc2VjQHhpYW9t
aS5jb229+NDQt7TAoQ0KDQpPbiAxNi4wOC4yNSAwOTozNCwgQW5kcmV3IE1vcnRvbiB3cm90ZToN
Cj4gT24gU2F0LCAxNiBBdWcgMjAyNSAwODo1Njo0NyArMDIwMCBEYXZpZCBIaWxkZW5icmFuZCA8
ZGF2aWRAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+PiBPbiAxNi4wOC4yNSAwODo0NSwgQW5kcmV3
IE1vcnRvbiB3cm90ZToNCj4+PiBPbiBTYXQsIDE2IEF1ZyAyMDI1IDA4OjI3OjM5ICswMjAwIERh
dmlkIEhpbGRlbmJyYW5kIDxkYXZpZEByZWRoYXQuY29tPiB3cm90ZToNCj4+Pg0KPj4+Pj4gQEAg
LTg1OCw4ICs4NjksOCBAQCBzdGF0aWMgc3RydWN0IHBhZ2UgKl9fY21hX2FsbG9jKHN0cnVjdCBj
bWEgKmNtYSwgdW5zaWduZWQgbG9uZyBjb3VudCwNCj4+Pj4+ICAgICAgICAgICBpZiAoIWNtYSB8
fCAhY21hLT5jb3VudCkNCj4+Pj4+ICAgICAgICAgICAgICAgICAgIHJldHVybiBwYWdlOw0KPj4+
Pj4NCj4+Pj4+IC0gcHJfZGVidWcoIiVzKGNtYSAlcCwgbmFtZTogJXMsIGNvdW50ICVsdSwgYWxp
Z24gJWQpXG4iLCBfX2Z1bmNfXywNCj4+Pj4+IC0gICAgICAgICAodm9pZCAqKWNtYSwgY21hLT5u
YW1lLCBjb3VudCwgYWxpZ24pOw0KPj4+Pj4gKyBwcl9kZWJ1ZygiJXMoY21hICVwLCBuYW1lOiAl
cywgdG90YWwgcGFnZXM6ICVsdSwgdXNlZCBwYWdlczogJWx1LCByZXF1ZXN0IHBhZ2VzOiAlbHUs
IGFsaWduICVkKVxuIiwNCj4+Pj4+ICsgICAgICAgICBfX2Z1bmNfXywgKHZvaWQgKiljbWEsIGNt
YS0+bmFtZSwgY21hLT5jb3VudCwgY21hX2dldF91c2VkX3BhZ2VzKGNtYSksIGNvdW50LCBhbGln
bik7DQo+Pj4+DQo+Pj4+ICAgICAgICAgICAgXiBvbmUgc3BhY2UgbWlzc2luZyBmb3IgcHJvcGVy
IGluZGVudGF0aW9uLg0KPj4+Pg0KPj4+PiBCdXQgZG9pbmcgYW5vdGhlciBzcGlubG9jayBjeWNs
ZSBqdXN0IGZvciBkZWJ1Z2dpbmcgcHVycG9zZXM/IFRoYXQgZG9lcw0KPj4+PiBub3QgZmVlbCBy
aWdodCwgc29ycnkuDQo+Pj4NCj4+PiBJZiB3ZSdyZSBjYWxsaW5nIHByX2RlYnVnKCkgZnJlcXVl
bnRseSBlbm91Z2ggZm9yIHRoaXMgdG8gbWF0dGVyLCB3ZQ0KPj4+IGhhdmUgb3RoZXIgcHJvYmxl
bXMhDQo+Pg0KPj4gV2UgY2FsbCBpdCBmb3IgZWFjaCBhbmQgZXZlcnkgYWN0dWFsIENNQSBhbGxv
Y2F0aW9uPyBJIHJlYWxseSBkb24ndCBzZWUNCj4+IHdoeSB3ZSB3YW50IHRvIGp1c3QgcmFuZG9t
bHkgbWFrZSBDTUEgYWxsb2NhdGlvbiBsYXRlbmN5IHdvcnNlLg0KPg0KPiBwcl9kZWJ1ZygpIGlz
IDEyIG1pbGxpb24gdGltZXMgbW9yZSBleHBlbnNpdmUgdGhhbiBhIHNwaW5fbG9jaygpIQ0KPg0K
Pj4gSXMgdGhlIGV4aXN0aW5nIHByX2RlYnVnKCkgYSBwcm9ibGVtPyBNYXliZS4gQnV0IHdobyBh
Y3R1YWxseSBoYXMgZGVidWcNCj4+IG1lc3NhZ2VzIGVuYWJsZWQgaW4gYW55IHNhbmUgc2V0dXA/
DQo+DQo+IE5vYm9keSwgY2xlYXJseS4gIElmIGFueW9uZSBlbmFibGVkIHByX2RlYnVnKCkgaW4g
aGVyZSwgdGhleSdkDQo+IGltbWVkaWF0ZWx5IGhhdmUgdG8gcmVtb3ZlIHRob3NlIHN0YXRlbWVu
dHMgdG8gZ2V0IGFueSB3b3JrIGRvbmUuICBLaWxsDQo+IGl0Lg0KDQpJIGp1c3QgbGVhcm5lZCB0
aGF0IHByX2RlYnVnKCkgb24gYSAhQ09ORklHX0RFQlVHIGtlcm5lbCB0cmFuc2xhdGVzIHRvDQpu
b19wcmludGsoKSwgd2hpY2ggaXMganVzdCBhIG1vc3RseS1lbXB0eSBtYWNybyB0aGF0IGRvZXNu
J3QgcmVhbGx5IHVzZQ0KYW55IG9mIHRoZSBwYXJhbWV0ZXJzLg0KDQpJIHdvdWxkIGFzc3VtZSB0
aGUgY21hX2dldF91c2VkX3BhZ2VzKCkgd291bGQgZ2V0IGNvbXBsZXRlbHkgb3B0aW1pemVkDQpv
dXQgaW4gdGhhdCBjYXNlLg0KDQpTbywgSSBkb24ndCBjYXJlLCBidXQgLi4uIG1vdmluZyB0byB0
cmFjaW5nIHNlZW1zIG11Y2ggbW9yZSByZWFzb25hYmxlLg0KDQotLQ0KQ2hlZXJzDQoNCkRhdmlk
IC8gZGhpbGRlbmINCg0K

--_000_d21f884907fe4dce81e5c16e2970a3b4xiaomicom_
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
<p><span></p>
<div>From this perspective, it seems better to add it to the trace.&nbsp;<s=
pan style=3D"font-size:12pt">Then shall I make a patch to add to the trace?=
</span><br>
</div>
</span><br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> David=
 Hildenbrand &lt;david@redhat.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2025=C4=EA8=D4=C216=C8=D5 15:49:52<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Andrew Morton<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; lorenzo.stoakes@oracle.com; Liam.Howlett@or=
acle.com; vbabka@suse.cz; rppt@kernel.org; surenb@google.com; mhocko@suse.c=
om; linux-mm@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] mm/cma: print total and use=
d pages in cma_alloc()</font>
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
On 16.08.25 09:34, Andrew Morton wrote:<br>
&gt; On Sat, 16 Aug 2025 08:56:47 &#43;0200 David Hildenbrand &lt;david@red=
hat.com&gt; wrote:<br>
&gt;<br>
&gt;&gt; On 16.08.25 08:45, Andrew Morton wrote:<br>
&gt;&gt;&gt; On Sat, 16 Aug 2025 08:27:39 &#43;0200 David Hildenbrand &lt;d=
avid@redhat.com&gt; wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; @@ -858,8 &#43;869,8 @@ static struct page *__cma_allo=
c(struct cma *cma, unsigned long count,<br>
&gt;&gt;&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!cma || !cma-&gt;count)<br>
&gt;&gt;&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return page;<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; - pr_debug(&quot;%s(cma %p, name: %s, count %lu, align=
 %d)\n&quot;, __func__,<br>
&gt;&gt;&gt;&gt;&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (voi=
d *)cma, cma-&gt;name, count, align);<br>
&gt;&gt;&gt;&gt;&gt; &#43; pr_debug(&quot;%s(cma %p, name: %s, total pages:=
 %lu, used pages: %lu, request pages: %lu, align %d)\n&quot;,<br>
&gt;&gt;&gt;&gt;&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
__func__, (void *)cma, cma-&gt;name, cma-&gt;count, cma_get_used_pages(cma)=
, count, align);<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; ^ one space missing for proper indentation.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; But doing another spinlock cycle just for debugging purpos=
es? That does<br>
&gt;&gt;&gt;&gt; not feel right, sorry.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; If we're calling pr_debug() frequently enough for this to matt=
er, we<br>
&gt;&gt;&gt; have other problems!<br>
&gt;&gt;<br>
&gt;&gt; We call it for each and every actual CMA allocation? I really don'=
t see<br>
&gt;&gt; why we want to just randomly make CMA allocation latency worse.<br=
>
&gt;<br>
&gt; pr_debug() is 12 million times more expensive than a spin_lock()!<br>
&gt;<br>
&gt;&gt; Is the existing pr_debug() a problem? Maybe. But who actually has =
debug<br>
&gt;&gt; messages enabled in any sane setup?<br>
&gt;<br>
&gt; Nobody, clearly.&nbsp; If anyone enabled pr_debug() in here, they'd<br=
>
&gt; immediately have to remove those statements to get any work done.&nbsp=
; Kill<br>
&gt; it.<br>
<br>
I just learned that pr_debug() on a !CONFIG_DEBUG kernel translates to<br>
no_printk(), which is just a mostly-empty macro that doesn't really use<br>
any of the parameters.<br>
<br>
I would assume the cma_get_used_pages() would get completely optimized<br>
out in that case.<br>
<br>
So, I don't care, but ... moving to tracing seems much more reasonable.<br>
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

--_000_d21f884907fe4dce81e5c16e2970a3b4xiaomicom_--


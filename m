Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D1ECD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA576B008A; Thu, 28 May 2026 03:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73656B008C; Thu, 28 May 2026 03:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962986B0092; Thu, 28 May 2026 03:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8196A6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:57:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B8BE1C065C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:57:55 +0000 (UTC)
X-FDA: 84816074910.05.51D0111
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf25.hostedemail.com (Postfix) with SMTP id 08574A0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:57:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=QhFwdHQ4;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=md1602058C6B=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1602058C6B=lirongqing@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YrfQsXLKHJUVY9avcxI8Z40i3pKR5bSqb9Q32axvfg=;
	b=klSU8ONs95x7OpwdRSXfXSgus/tkBRIboIhfd2+8y/LfAoIOqIkq4vTzJkmuJxblrQMaF6
	TlSFO5z6xTUcPBmyUwQzJNhqya/w/DcHMzUUTrco2JTdAQIfXUmXkUUNrAscMWItUi0wFz
	OnHe9seM/Z7VFiWe9GFQ0XUtjxJaNyg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=QhFwdHQ4;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=md1602058C6B=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1602058C6B=lirongqing@baidu.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955073; a=rsa-sha256;
	cv=none;
	b=qQQHNRKboXIPJxT3QRV9/sPH88OTfRFYCW3mNYr9RYjtjUMjLv8vvuBDLJrHE0E/y/XGqF
	g3Foy6ypz8Mpw+aIijSPIJHtFcUFbv4yTJdrEYy+EYxTCuPEKWCIwoPoW0X5EPgluLtwMf
	pbz6a1q4mak817eF+l1HZdMStUhsMDk=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.46
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: Matthew Wilcox <willy@infradead.org>, "Christoph Lameter (Ampere)"
	<cl@gentwo.org>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIG1tL21lbXBvb2w6IHVzZSBzdGF0?=
 =?gb2312?Q?ic_key_for_boot-time_debug_enablement?=
Thread-Topic: [????] Re: [PATCH] mm/mempool: use static key for boot-time
 debug enablement
Thread-Index: AQHc7cYaHc/KlS0U5Emb14FdSgycW7Yh3hsAgAAMTYCAAA7JAIAAAM8AgAEY/6A=
Date: Thu, 28 May 2026 07:57:41 +0000
Message-ID: <ba0c2d92642e4d38bdf403faecb5b1d7@baidu.com>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org>
 <ahdsgyYYDn6juR_R@casper.infradead.org>
 <7f4ec43c-0d9c-190a-0ce5-bc3276b45cb0@gentwo.org>
 <ahd5mIMCnI4DQFn9@casper.infradead.org>
In-Reply-To: <ahd5mIMCnI4DQFn9@casper.infradead.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.31.62.16]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779955064;
	bh=+YrfQsXLKHJUVY9avcxI8Z40i3pKR5bSqb9Q32axvfg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=QhFwdHQ4OjzQijNSrpiquIWLJ91ueUpPGsDxgEX+S1C7L+snIUlMrxxvgWP8WPVfG
	 RgNLZqNN0v93HQ4jxkMj75DxWi/Q3gxFOKQswt/soDWP4EbjzHTg4hvyIYlMq8TZBm
	 QJbvKhevzFWCi6jl2WUXU8OmXy2RfXJ4vKMeGdmUZZOENwC1AM8tc7F0BrgjkRO8wV
	 1djzlEaqd1Ajk8TeE4t4ip7rGVVBgnSzPAU/d3k1W0TyVK/Qqce+io6kHIO83uZrOx
	 5mKiWePMw22UhdBYT0Cn9GzokNvCeyd9F1Fq/QoQOwc0om9MROj/HRIKkFIPvE+b6i
	 gBjPi8eGacVTw==
X-Stat-Signature: u4q41abpb1cry1z68qghazzzuokpx4bi
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 08574A0009
X-Rspam-User: 
X-HE-Tag: 1779955068-966057
X-HE-Meta: U2FsdGVkX1/p8JMCCOXbx3/x+8pzbMPw7IlIms9gbNJet4H8L6/tTz+MgPb5IlPFqxmi7e7umdRZqbxtNHKMN60gXuxN9+VnXhqCl1zEF/8QtMYs+rXXvaLVmeW6OrgYlLMo2KCQvwDn0gd73v0jZuGWFtML2t2Z+Lls28LDqOYlGag4Rxl3B7rY+jkMnenRIA3dwCD0gFBtoTOIy+XA7M0J0i89iPzNsgrXlheEK4rQ0h3E2nFCb1Q13R6fz2plXNy6Biu2vZvQ5o5KLf51W2+o4Q9CLr3v+qIbCFzPromLXpEzuRTFqpfKy1yDnBmMuUMq3/torgj5VlMPSP8V/L7/vcfbsKxQfFakb40A3jehTJ6Z210juhYW9EQJiwQJrhENjxTvMU30e93kYnJJeI1seGcrcuvFctLz+hNHdhGIE2vxAybpJEQNFu/+3Gpj5tp5Z/9XTEMIX6P/xdZ3NS33Wx/4JRdmXSxhHQM8vaNmgon2KNLUcwperSEM3GpjfVGoxK/CxMy5m1zdMpMBoaetyKcCqoPIkn5+kYgFev+o9CFVJF3rd9Tm6MKOiC0OfnD3Ev8WvulsrU0Gs0ttQwcKTrcGCnADAUGuMUvv2HhzmQS9hVxFse6PW17z9NavdrjvqzHxxSt2jMDS2xfCxIXOliX803iGzYpH/By0V2nSHQqWo50FxqA4EYsSIeZtYBdL4ohhA+0ayIsplkSToyctXhQJWZeSB+uHi5cQ02EKzK8imu/2lUWzPqN/SEodtcM/o4FNYFNEDkBMZacGGLi80t7FMMfPFsL71AB+czlXK2k/7BpaNmNm0gyHRS6iJ0N8dwRle+uV7BBWOAqdVxtv6q8UfX4Nt2SAANez7YabvfMRS2GDnV2NT7mnBY44vAdYw2L/4jtD6yxXK0jrRW1aNHxfROPPOawHsPgb5svw63v9V9yZIUYcZaUrJyIAIIfcn9rqGnlgug8bC7m
 KV1pVMel
 nH9oGgDAUQWjRm9IvSLF36+VcTuxKRRzBSnJn3kHjMgFLPn8xEgjEzfN16bmAZn/+EjCajJAbJpsg1PSBbHvRQSfDRdWFYGwEwkcw7BoX5Ddd5lvbxYZ8X71/0IDY/uyWT0jN8R+2JuZGSC4xhnA8jTpZTNSacJPK1b4i0xrGbpQwO2taBWp2X1shaf3af5D4WKXNYzoCaoC3Sdp6XbZPzK8V5cjdQIC4hGdCKNlM/wDt4nF5M0dNAthg3EWV3x/WDnPGQHTdjS7jeg7HT2F1nYa/PiPsNsk0CDUqRIPbwzr4aMOn5VbDn4QfHhdYEiHM/Y81XSw70R7F6Nr8uQKFzwsORC8sYA0hLJfzS9M2kfGqdDjLPzgMaR4oXb1cXjtCDnf4uj4YWZkIuZXabyaOsZeSREJQucHia/YOiWi7X5Vjl+zuebKo0GxIX/ce7nWaiGIEk3r1GVkV+3ug4y+1pLJ5YagufaDS1M9Cbl5/sFT4mwqUMMFD+ESPzeZMF2zMZMoGigGu5AY6NLUko6RBYNi24ZkcZry71s6Ag2Kvna3eUK56Xy0hHZO8ZQ+jEbo1LQuVXcs89x6DadL9V/27+R5WG16cnWyctG2q4gtFyeUs0YWxLhrcjZpvNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4gPiBQbGVhc2UgY2xlYW4gdGhpcyBtZXNzIHVwLg0KPiA+ID4NCj4gPiA+IElzbid0IHRo
YXQgd2hhdCB0aGlzIHBhdGNoIGRvZXM/DQo+ID4NCj4gPiBJdHMgbm90IG1hcmtlZCBhcyBmaXhp
bmcgc29tZXRoaW5nIG5vciBhcyBhZGRyZXNzaW5nIHRoZSB3ZWlyZG5lc3Mgb2YNCj4gPiB1c2lu
ZyBDT05GSUdfU0xVQl9ERUJVR19PTiBoZXJlLCBBIGtlcm5lbCBidWlsZCB3aXRoDQo+ID4gQ09O
RklHX1NMVUJfREVCVUdfT04gY2FuIHN0aWxsIGJvb3Qgd2l0aG91dCBkZWJ1Z2dpbmcgaWYgYSBj
ZXJ0YWluDQo+ID4ga2VybmVsIGNvbW1hbmQgbGluZSBvcHRpb24gaXMgZ2l2ZW4uDQo+IA0KPiBS
aWdodCwgYnV0IC4uLiBpZiB5b3UgbG9vayBhdCB3aGF0IHRoZSBwYXRjaCBfZG9lc18sIGRvZXNu
J3QgaXQgZG8gd2hhdCB5b3UncmUNCj4gYXNraW5nIGZvciBpdCB0byBkbz8NCg0KSGkgTWF0dGhl
dywgQ2hyaXN0b3BoLA0KDQpNYXR0aGV3LCB0aGFua3MgYSBsb3QgZm9yIHN0YW5kaW5nIHVwIGZv
ciB0aGUgY29kZSBsb2dpYyEgSSByZWFsbHkgYXBwcmVjaWF0ZSB5b3VyIHN1cHBvcnQgDQpvbiB0
aGlzLg0KDQpDaHJpc3RvcGgsIHRoYW5rIHlvdSBmb3IgcG9pbnRpbmcgb3V0IHRoZSBzZW1hbnRp
YyBnYXBzLiBUbyBhZGRyZXNzIHlvdXIgY29uY2VybnMsIA0KSSBoYXZlIGNvbXBsZXRlbHkgcmV3
cml0dGVuIHRoZSBjb21taXQgbWVzc2FnZSB0byBmb2N1cyBzdHJpY3RseSBvbiB1bnRhbmdsaW5n
IA0KdGhlIENPTkZJR19TTFVCX0RFQlVHX09OIGFidXNlIGFuZCBzd2l0Y2hpbmcgdG8gbWVtcG9v
bCdzIG93biBydW50aW1lIHBhcmFtZXRlci4NCg0KSGVyZSBpcyB0aGUgcmV2aXNlZCBjb21taXQg
bWVzc2FnZToNCg0KLS0tDQptbS9tZW1wb29sOiBVbnRhbmdsZSBDT05GSUdfU0xVQl9ERUJVR19P
TiBhYnVzZSBhbmQgc3dpdGNoIHRvIHN0YXRpYyBrZXkNCg0KVGhlIG1lbXBvb2wgc3Vic3lzdGVt
IGhpc3RvcmljYWxseSB3cmFwcGVkIGl0cyBkZWJ1Z2dpbmcgbG9naWMgaW5zaWRlIGFuDQojaWZk
ZWYgQ09ORklHX1NMVUJfREVCVUdfT04gYmxvY2suIFRoaXMgYWJ1c2VkIHRoZSBjb25maWcncyBp
bnRlbnQgKHdoaWNoDQptZXJlbHkgZGVmaW5lcyBjb21waWxlLXRpbWUgZGVmYXVsdHMgZm9yIFNM
VUIpIGFuZCBjYXVzZWQgdHdvIGZsYXdzOg0KDQoxLiBPbiBwcm9kdWN0aW9uIGtlcm5lbHMgd2hl
cmUgQ09ORklHX1NMVUJfREVCVUc9eSBidXQgQ09ORklHX1NMVUJfREVCVUdfT049biwNCiAgIG1l
bXBvb2wgZGVidWdnaW5nIHdhcyBjb21wbGV0ZWx5IHRydW5jYXRlZCBhdCBjb21waWxlIHRpbWUu
DQoyLiBPbiBrZXJuZWxzIHdpdGggQ09ORklHX1NMVUJfREVCVUdfT049eSwgbWVtcG9vbCBkZWJ1
Z2dpbmcgc3RheWVkIGFjdGl2ZQ0KICAgZXZlbiBpZiBhIHVzZXIgZXhwbGljaXRseSBkaXNhYmxl
ZCBkZWJ1Z2dpbmcgYXQgYm9vdCB0aW1lLg0KDQpDbGVhbiB1cCB0aGlzIG1lc3MgYnkgcmVtb3Zp
bmcgdGhlICNpZmRlZiBhbmQgc3dpdGNoaW5nIHRvIGEgcnVudGltZSBzdGF0aWMNCmtleSAobWVt
cG9vbF9kZWJ1Z19lbmFibGVkKSwgYWxsb3dpbmcgbWVtcG9vbCBkZWJ1Z2dpbmcgdG8gYmUgdG9n
Z2xlZCBjbGVhbmx5DQp2aWEgaXRzIG93biBib290IHBhcmFtZXRlci4NCg0KU2lnbmVkLW9mZi1i
eTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KLS0tDQoNCkRvZXMgdGhpcyBy
ZXZpc2VkIHRleHQgbG9vayBnb29kIHRvIHlvdT8gSWYgc28sIEkgd2lsbCBvZmZpY2lhbGx5IHNl
bmQgb3V0IFYyLg0KDQpUaGFua3MsDQoNCltMaSxSb25ncWluZ10gDQoNCg0KDQo=


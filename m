Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B1DFFEE4E2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 10:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679D96B0005; Sat, 28 Feb 2026 05:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627A36B0088; Sat, 28 Feb 2026 05:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D3A6B0089; Sat, 28 Feb 2026 05:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 408AB6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 05:28:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA77B140B85
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 10:28:44 +0000 (UTC)
X-FDA: 84493491768.27.782E64B
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id E5161180005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 10:28:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772274522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SU10QfaX3yYQ4tKrnPxNpwb4vSkX1oliy/T+ohQoUQ=;
	b=gzvekZRju7zXqKik8S182Ie97oW21YuncLgoqpgeEKOhq1t5A76sKDgFbYXAe4qdzzeBC+
	WNUaOw7K+xYmmFqOV5EJMKfprxmxguwZHqec/eb8gAG43nQnvpG/ZX92zL2RwUheJon6JL
	Lgfc+gjte7z0DvBHzwv8v84mNRUxC68=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772274522; a=rsa-sha256;
	cv=none;
	b=upPNSWQ/8d6VX2FcMIbPRyP5apAtGhgVm8177IwyTZ97zuobM+ETNgBy96RCdZZOgyOvfY
	9I5oIUWlyC5gjQETkgxNZt99nE81XOcOIibs++duJA982OMkiISurlF7oHWN4NYyj8dtuZ
	Fco0eNxBhdameZ1xRxMoGTsU9z5u3V4=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4fNLtW5bR4zYky8B;
	Sat, 28 Feb 2026 18:25:23 +0800 (CST)
Received: from a010.hihonor.com (10.68.16.52) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Sat, 28 Feb
 2026 18:28:36 +0800
Received: from w002.hihonor.com (10.68.28.120) by a010.hihonor.com
 (10.68.16.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Sat, 28 Feb
 2026 18:28:35 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Sat, 28 Feb 2026 18:28:35 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Lei
 Liu" <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, Tangquan Zheng
	<zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>
Subject: RE: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Topic: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Index: AQHcprbIkLI8koBjtkqDPEnVc1b3J7WU7U8wgAA7mwCAAsHsUA==
Date: Sat, 28 Feb 2026 10:28:35 +0000
Message-ID: <adfc0959cf294aa4ab71c60ee1e35720@honor.com>
References: <20260225223712.3685-1-21cnbao@gmail.com>
 <2558f7d82b9a482387960f45409e1b76@honor.com>
 <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: E5161180005
X-Stat-Signature: oxb4hsg4x161mnjcsysbdtu3r9w1nkic
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772274521-111403
X-HE-Meta: U2FsdGVkX19l/1mlOPX2FBOqUesxbEFJtRRaVvgR4OxpIVK8yWyEpoNXH4w7+wYB1zdisBUtQ0R5YRcLOXOjXixHB089UChnUm1HfNN8qden5bcf+VevWcRgTMmoYWTkser1K1eOgzYRBEOso5qqRzYGf8nB9AzBYJRMvibYPuhsorXQD7OpZAkpfDauazmUuSHRWSmjuZNAy9scG1M+ZqJzSB42hwynEoBp8zDgVQRtIXLNspfu9gFudDI+KAAmRKDpKrjl3+YlRkanXqFfwj4a//Kfp52kFoHQ7MO+8aqBu/nT7F8wx/or7b9F4Cu9uy8oLC+c0D/OXWoYMKwg2MVXEnON7a3dEP4xCYxHP5nChk8FtjPa3AiXlA05ziCCRkSsJ9afJjROpPu98BJfr+plm+BoGTxdCXQ8+XTZOzUQJbrKLGX9uZbbyDw/qkMkKmc6QS+Yy45nCppJ/h+7JJFqclvdoWumhK7I1QSJtSuZNlfPY3B5KKDW7PBsQt+hKAxMfNH06+0TJ7bPUSxd6juWdQM5IqtNUU1OyTwb4zVlnuN0DqnMhbJyXaK0C/Ns1Rho52O9aJJFmauG8Bv7hKHgG0EGTEtwTQVWAIbRii1pSqmaAr3+RyTXryvXeVaB8WfinF96mVlZovN82fnc0auA3v4yebMO3APbTpJw5ai75Ga10vlG/JjEveSnwalsnpF4TNGobYKEcFRol1SgkihXvOaSe9r2D+Pr5g3xcxc5vRwH65iWXsTreX3dE9HV4sxFPcSrnfgualiq6dCuJt3bQ8t3dJiJl7MK+W/Q48c1XOAWX+lLyKPObu+eSlc9/C1NKGdWYdDeOSEiE5AyameTCKFSFUT0g57bRaZ9ihY3ROhmAPi0CUnSV95Wu5R8x4LoSyx3hB8F3/4gYM+8VkhPN7ay5O//MiaC1G6iekc1LnQHf/lx+NMqYaCOznCkGHqUqYknnyETzEu92lR
 xjXeiqN4
 wwecJJ0VHIYkhEGTa9B3+NSZKhGBGzp+f6PetJQosoB9DQJPagekJ4y2xCF2ezJDl0314kLxrXqMC7z2urBqmZgWmy62HG2fUZg1ebIbNTMhHIyx+GVFN2f6CxC+8kFpAz0jQt5l05u0XKs6F/hL7utrfPKwWZKjsx//G6FtrO++rVKaRyZJOS+cAKsOvwdDfKM5+dn6NKqhYqt9kbfpiQQbn6zKzEE53iR9h2Ns26QTBxRwbyPiclXCuOJyMMBCHPFJgZmwTMO4oosOZLBu06krSIi1OZGnAXcjWaUXuxNgZr1sYLMceZLKlIAhiag5FBOHPjsE2yfjZSwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQo+IA0KPiBJIGZpbmQgeW91ciBjb25jZXJuIGEgYml0IHN1cnByaXNpbmcuIElm
IEkgdW5kZXJzdGFuZCBjb3JyZWN0bHksDQo+IHlvdeKAmXJlIG9ic2VydmluZyB0aGF0IGZpbGUg
Zm9saW9zIGFyZSBjdXJyZW50bHkgYmVpbmcgb3Zlci1yZWNsYWltZWQuDQo+IEluIHRoYXQgY2Fz
ZSwgcGxhY2luZyBob3QgcGFnZXMgYXQgdGhlIHRhaWwgbWlnaHQgbWFrZSB0aGVtIGhhcmRlcg0K
PiB0byByZWNsYWltIGFmdGVyIFBURSBzY2FubmluZyAoc2luY2UgdGhleSBtYXkgc3RpbGwgYmUg
eW91bmcpLCBidXQNCj4gdGhpcyBzZWVtcyB0byB2aW9sYXRlIHRoZSBmdW5kYW1lbnRhbCBwcmlu
Y2lwbGUgb2YgTFJVLiBNb3Jlb3ZlciwNCj4gd2hlbiBzY2FubmluZyBlbmNvdW50ZXJzIHlvdW5n
IGZpbGUgZm9saW9zLCByZWNsYWltIHdpbGwgc2ltcGx5DQo+IGNvbnRpbnVlIHNjYW5uaW5nIG1v
cmUgZm9saW9zIHRvIGZpbmQgcmVjbGFpbWFibGUgb25lcywgc28gc2Nhbm5pbmcNCj4gaG90IGZv
bGlvcyBvbmx5IHdhc3RlcyBDUFUgdGltZS4NCj4gU2luY2UgcmVhZC1haGVhZCBjb2xkIGZvbGlv
cyBhcmUgcGxhY2VkIGF0IHRoZSBoZWFkLCByZWxhdGl2ZWx5IGhvdHRlcg0KPiBmb2xpb3MgbWF5
IGJlIHJlY2xhaW1lZCBpbnN0ZWFkLCBjYXVzaW5nIHJlZmF1bHRzIGFuZCBmdXJ0aGVyIHRyaWdn
ZXJpbmcNCj4gcmVjbGFpbSwgd2hpY2ggY2FuIHdvcnNlbiB0aGUgc2l0dWF0aW9uLg0KPiANClRo
YW5rIHlvdSBmb3IgdGhlIGRldGFpbGVkIGV4cGxhbmF0aW9uLg0KPiA+DQo+ID4gV2UnbGwgdGVz
dCB0aGlzIHdoZW4gYXZhaWxhYmxlIGFuZCByZXBvcnQgYmFjay4gV2UgaG9wZSB0byBoYXZlIGEN
Cj4gPiBjaGFuY2UgdG8gZGlzY3VzcyB0aGlzIHRvcGljIGF0IExTRi9NTS9CUEYuDQo+ID4NCj4g
DQo+IFN1cmUsIHRoYW5rcyENCj4gDQo+IEJhcnJ5DQoNCkZvciBldmFsdWF0aW9uIEnigJltIHVz
aW5nIGEgd29ya2xvYWQgdGhhdCByZXBlYXRlZGx5IGNvbGQtc3RhcnRzIGFuZA0KZHJpdmVzIHNh
bWUgdXNlciBhY3Rpb25zIGluIDIwKyBhcHBzIG9uIEFuZHJvaWQuDQpJ4oCZbSBjb21wYXJpbmcg
YmFzZWxpbmUodjYuNikgdnMuIHRoZSBwYXRjaGVkIGtlcm5lbCBhbmQgd2F0Y2hpbmcNCmAvcHJv
Yy92bXN0YXQgLT4gd29ya2luZ3NldF9yZWZhdWx0X2ZpbGVgLCBleHBlY3RpbmcgaXQgdG8gZ28g
ZG93bi4NCg0KSSByYW4gMyBydW5zIHBlciBrZXJuZWwsIGJ1dCBgd29ya2luZ3NldF9yZWZhdWx0
X2ZpbGVgIGlzIHF1aXRlIG5vaXN5LA0KdGhlIENvZWZmaWNpZW50IG9mIFZhcmlhdGlvbiBpcyBh
cm91bmQgNDAlLCBzbyB0aGUgcmVzdWx0IGRvZXNu4oCZdCBsb29rDQpzdGF0aXN0aWNhbGx5IHNv
bGlkLg0KDQpEbyB5b3UgaGF2ZSBhbnkgc3VnZ2VzdGlvbnMgb24gaG93IHRvIG1lYXN1cmUgdGhl
IGJlbmVmaXQgbW9yZQ0Kcm9idXN0bHk/IEZvciBleGFtcGxlOg0KLSBkaWZmZXJlbnQgb3IgbG9u
Z2VyLXJ1bm5pbmcgd29ya2xvYWRzLA0KLSBiZXR0ZXIgbm9ybWFsaXphdGlvbiBmb3IgcmVmYXVs
dHMgKHBlciB0aW1lLCBwZXIgZmF1bHRzLCBldGMuKSwNCi0gb3Igb3RoZXIgdm1zdGF0IG1ldHJp
Y3MgdGhhdCB5b3UgZm91bmQgbW9yZSBzdGFibGUgaW4gcHJhY3RpY2U/DQoNCknigJltIGFsc28g
Y29uc2lkZXJpbmcgaW5jcmVhc2luZyB0aGUgbnVtYmVyIG9mIHJ1bnMgYW5kIHVzaW5nIGEgdC10
ZXN0LA0Kb3IgY29tcGFyaW5nIHRoZSBDREYgYmV0d2VlbiBiYXNlbGluZSBhbmQgcGF0Y2hlZCBr
ZXJuZWxzLg0KSWYgeW91IGhhdmUgYSBwcmVmZXJyZWQgbWV0aG9kb2xvZ3ksIEnigJlkIGxpa2Ug
dG8gYWxpZ24gd2l0aCB0aGF0Lg0KDQpUaGFua3MsDQpaaWNoZW5nDQo=


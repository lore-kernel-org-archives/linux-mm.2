Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217D0CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECC06B0005; Thu,  4 Jun 2026 00:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9DEB6B0088; Thu,  4 Jun 2026 00:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C9F6B0092; Thu,  4 Jun 2026 00:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6CC06B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:10:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7696B140534
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:10:14 +0000 (UTC)
X-FDA: 84840902748.07.50774EB
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DE2140009
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:10:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780546211;
	b=bPNgFkkQba4V8bjWLl68CT7ty/AInX/XMUU+Zm0/ntdS1CI9khqKFcSjJ0Z0NGW2S3OvcS
	YHZ/0FjzxJoEevNAJRBVQlTnaYBoaTk/j2h3Tdnpa1br6jg871Eqzl0P32KCYuKSVeZksG
	AfGMCtjyfxccCTzE8mGJ7Nrnn3fHNAc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780546211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xHUWu+ueJwDAqCzNRAWtgDl/FFIr4o2B+xgWFyawyE=;
	b=Vf4KkXFEhGfIIVyk27cYDIlhq+zoBVgBWu8qiUm3h+AjAwDvybOPKg5ldLCekn056YWgZu
	mqGggHiZ/il+12ry5dbGYJdrxdJfA7E8b5+eJ32mZrcJefw78NKOQDgxQTPAYLItkPE2N+
	S85F80dTyoAtjMDofnrVXjbg1vnHWtg=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gW9zC444ZzYkxb0;
	Thu,  4 Jun 2026 12:08:23 +0800 (CST)
Received: from TA005-1.hihonor.com (10.77.216.68) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 4 Jun
 2026 12:10:05 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA005-1.hihonor.com
 (10.77.216.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 4 Jun
 2026 12:10:01 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 4 Jun 2026 12:10:04 +0800
From: wangtao <tao.wangtao@honor.com>
To: "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "david@kernel.org"
	<david@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
	<luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
	<jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
	<harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "joshua.hahnjy@gmail.com"
	<joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net"
	<gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"dvander@google.com" <dvander@google.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYszHKAgABxS4CAAJTosA==
Date: Thu, 4 Jun 2026 04:10:04 +0000
Message-ID: <32e89429f8ca4d4ebd04b1303897eaed@honor.com>
References: 20260527110147.17815-1-tao.wangtao@honor.com,70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org
 <20260604111035154Lk-9ZgwKY4Nlk4zz30U1t@zte.com.cn>
In-Reply-To: <20260604111035154Lk-9ZgwKY4Nlk4zz30U1t@zte.com.cn>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 9DE2140009
X-Stat-Signature: fzxm4niz3sdx8y6sn9ji8opjnnp963ca
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780546210-150405
X-HE-Meta: U2FsdGVkX19eSJW3NG7nxmt2mdT0s6GyxDfD5P6SZKv+6a414gk2lvsaqSd94xKAcpUoFyh7FehNEcAu/X8JPUeQb+g5wcl4gtSkRR1tnkDtGCvARaE2RrfPI7oDmCAIg08skLdAK0nEVyT6jX4BP6mlVWSTd39VATTPx6s4fh82euwi+3v6ATold9iXniSoytd9rUMtmLIG82UQZp6brbS58aBhiX2Ep9Djj8kLcZTnYikDZVGtVe5G+6q7zIZ/9V2mrkzaFzegVzeIiI4PC4Ogw/ESufbw2w91vPsxCQKd3eEEvLTs/g1EjgBvN5tvQT/wI1/xlPd3artzadlzLRGgZSB5fGjoI6A38xW0Hs6TpJ9BbWxiR5HMYpW48DSgOL4sOVuF34RjAVl3xd51azPcia8KwxjommwL9Z+86mbxdNVSxKWrzuMgppetEma5L9O9ecUkGAYSEhtr+FU81qzObqG/TqK9i1fGv34CTHnD1SinItBDfLByBYaLfbE+mN3lchrgWenp8qEqeDSrFngK/L2YxCG2RBH35BUD7yRnE1tEkS+qV1bCWbzZrQaXNaL+nQL4uHrKoO1AAf3xlO+J7+5emjCMaamrq3bY66MTdA2NzcgXyQBVFiEyxIN7wv8D3P6SIJcYClev8Qp1HlCgMVf3n936NVYInUSf1adFqiS3OJ9BS1yW0F97t5WjEIlaPiVySeYG4WlwlhVbetvq6rx0tQ2BayWhu/pSrXa4sEB97fq886E2z0LSX6rBDbNlUTL/3Jv00IWMfFG59XSyqqEFXTpqWCqU9iyH8DgOj/j3fAJbyFzOPelOu7+UQxEezscUX4j0JmRgp/SPz6qsc2N37wh2QUJQTdFhstP6T98+tSDElBnyvrf53Swqcct+8TEI4W1WvQbjdN49NpiwjJbIWu25w5JnQIWCfPUnH7OfitmVfDKRqSGGK8CptUYcmhciXxbwyqoSbvY
 fD+1WlhQ
 qLatJc7yprspABIkzowjI40ZRlA4/uaqHDUY37Rht7e0QMQywAvDsF6poC/rCP/iGoQS3xfzPZ2n6Xsej6L0Gd3MvV4cdKAv3OpF1LuBCVTiVUJJWi2s/SOLPyC2oPhaC8cg2Z9fDQCZOGYfq6w0y8nKXJGPQSPSajlFYKjB9ynjlRVZjG8lbHMHLI2NjGt32QLnERGfD0R0aeh2zc9fwCeGyDRoWwNhl8Aj8uhg5NVAQA+21PRLgqecNi5nir7CdgPqqYV2651KFvVqAIRR6snoeqMWSmEZEzekNpRAb8meUhFKHLK+uXEXAQ6FVaPESQacyBzFqj5bucPWtMi0qn0rt32sB4nbMbHXS8luCdjRKup8EYSIFbuOCH6ImX6rwzI2yWhOmwU6Be6RonwBPjAAy0/olYPl7RZ2mJrSyEaTreao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+DQo+ID4gRXZlbiBpZiB3ZSBjb3VsZCBiZSBjb252aW5jZWQgdGhhdCBtb3N0IG9mIHRoaXMg
aGVyZSBpcyBjb3JyZWN0LCBob3cNCj4gPiBzaG91bGQgd2UgcmVhc29uYWJseSBtYWludGFpbiB0
aGlzIGluY3JlYXNpbmcgbGV2ZWwgb2YgY29tcGxleGl0eSBoZXJlPw0KPiANCj4gSW5kZWVkLCBp
dCdzIHZlcnkgY29tcGxleCwgYnV0IGhhdmluZyB0aGUgY2hhbmdlcyBvZiAxNSBwYXRjaGVzIHNj
YXR0ZXJlZA0KPiBhY3Jvc3MgdmFyaW91cyBzdWJzeXN0ZW1zIGlzIHJlYWxseSBmcnVzdHJhdGlu
ZyBmb3IgcmV2aWV3ZXJzLiBJdCB0b29rIG1lIGENCj4gd2hvbGUgZGF5IHRvIHJlYWQgdGhyb3Vn
aCB0aGUgZW50aXJlIHBhdGNoIHNldCwgd2hpY2ggbWFkZSBhbiBhbHJlYWR5DQo+IGNvbXBsaWNh
dGVkIG1hdHRlciBldmVuIG1vcmUgY29tcGxleCAobWFpbnRhaW5pbmcgc3VjaCBjb21wbGV4IGNv
ZGUgaW4NCj4gdGhlIGZ1dHVyZSB3aWxsIGJlIGEgcGFpbikuDQo+IA0KPiBIb3dldmVyLCBvdmVy
YWxsLCBJIHRoaW5rIHRoZSBvcmlnaW5hbCBpbnRlbnRpb24gYmVoaW5kIFRhbydzIHBhdGNoIGlz
DQo+IGlubm92YXRpdmUgYW5kIHZhbHVhYmxlLCBhbmQgVGFvIGNvdWxkIGRlZmluaXRlbHkgbWFr
ZSB0aGlzIHBhdGNoIHNldCBzaW1wbGVyDQo+IGFuZCBtb3JlIHJlYWRhYmxlLCBiZWNhdXNlIHRo
ZSBjb3JlIGNoYW5nZXMgYWN0dWFsbHkgc3RhcnQgZnJvbSBQQVRDSCAxMC4NCj4gDQpZZXMsIGlu
aXRpYWxseSBpdCB3YXMgYmFzaWNhbGx5IHBhdGNoZXMgOSwgMTAsIGFuZCAxMy4gQmVjYXVzZSB3
aXRob3V0DQpkaXN0aW5ndWlzaGluZyB0aGUgYW5vbl9ybWFwIGFuZCBhbm9uX3ZtYSB0b3BvbG9n
eSwgc29tZSBmdW5kYW1lbnRhbCBjb2RlDQpsb2dpYyBpcyBoYXJkIHRvIHVuZGVyc3RhbmQsIEkg
YWRkZWQgdGhlc2UgdHdvIGxvZ2ljYWwgbGF5ZXJzIHdoZW4NCnByZXBhcmluZyB0byBzdWJtaXQg
aXQgdG8gdGhlIGNvbW11bml0eS4gSG93ZXZlciwgdGhpcyBhbHNvIHNpZ25pZmljYW50bHkNCmlu
Y3JlYXNlZCB0aGUgYW1vdW50IG9mIGNvZGUsIHdoaWNoIGlzIG5vdCBpZGVhbC4NCg0KPiBJIGJl
bGlldmUgdGhhdCBpZiBUYW8gaGFkIGRvbmUgdGhlIGZvbGxvd2luZywgdGhpbmdzIG1pZ2h0IGhh
dmUgZ29uZSBiZXR0ZXINCj4gYW5kIGVhc2llciBmb3IgcmV2aWV3aW5nLiBJbiBmYWN0LCBJIHVu
ZGVyc3RhbmQgdGhlIG1vdGl2YXRpb24gYmVoaW5kIHRoZQ0KPiBwYXRjaCBpcyBxdWl0ZSBzaW1w
bGUgYXQgaXRzIGNvcmUgKGp1c3Qgd2FudGluZyB0byBhdm9pZCBhbGxvY2F0aW5nIHRoZQ0KPiBh
bm9uX3ZtYSBzdHJ1Y3R1cmUgd2hlbiBhIFZNQSBoYXNuJ3QgYmVlbiB0cnVseSBmb3JrZWQsIGFu
ZCBpbnN0ZWFkIHB1dA0KPiB0aGUgVk1BIGluZm9ybWF0aW9uIGRpcmVjdGx5IGludG8gZm9saW8t
Pm1hcHBpbmcpOg0KPiANCj4gMSkgWW91IGNvdWxkIGFjdHVhbGx5IHNpbXBsaWZ5IHlvdXIgcGF0
Y2ggc2lnbmlmaWNhbnRseSDigJQgd2l0aG91dCBhZGRpbmcgYSBsb3QNCj4gb2Ygd3JhcHBlcnMg
YW5kIGhlbHBlciBmdW5jdGlvbnMgdGhhdCBpbnRyb2R1Y2UgZXh0cmEgcmV2aWV3IG92ZXJoZWFk
IOKAlA0KPiBhbmQga2VlcCBvbmx5IHRoZSBtb3N0IGVzc2VudGlhbCBlbGVtZW50cy4NCj4gDQo+
IDIpIFByb3ZpZGUgY29tcGxldGUgdGVzdCBjb2RlIChpbiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
KSB0aGF0IGNvdmVycyB0aGUNCj4gYWZmZWN0ZWQgZnVuY3Rpb25hbGl0eSwgc3VjaCBhcyBWTUEs
IGh1Z2UgcGFnZXMsIEtTTSwgZXRjLg0KPiANCj4gMykgVXNlIHRoZSBSRkMgdGFnIHRvIHN0YXJ0
IGEgZGlzY3Vzc2lvbi4NCj4gDQo+IA0KPiBJIHdvdWxkIGJlIHZlcnkgZ2xhZCB0byBzZWUgaWYg
VGFvIGNvdWxkIHBvc3QgYSBzaW1wbGVyIHYyIHZlcnNpb24gdGhhdCBkb2VzDQo+IG5vdCBhbHRl
ciB0aGUgcm1hcCBjb3JlIGRhdGEgc3RydWN0dXJlcyB0b28gbXVjaCBhbmQgZG9lcyBub3QgaW50
cm9kdWNlDQo+IGV4Y2Vzc2l2ZSBjb21wbGV4aXR5LCBubyBtYXR0ZXIgd2hldGhlciBpdCBjYW4g
YmUgbWVyZ2VkIGZpbmFseS4NCg==


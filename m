Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC3AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF016B00D1; Tue,  7 Jul 2026 23:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF2D6B00D2; Tue,  7 Jul 2026 23:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5806B00D4; Tue,  7 Jul 2026 23:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA3866B00D1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:26:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ACC91A062A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:26:22 +0000 (UTC)
X-FDA: 84964171404.08.FB96064
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id 830FC160002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:26:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf08.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783481180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NLJ62wJnOM/CYSwYpHvcAWjyOBzMkili30m5Qc5O84A=;
	b=5YXDZkI6xkNycenPz3ZOwcmmHBDbxrekVUzwB7KNeFL2k+mXznMD/l64ZCDLQz2gRg26+l
	hMHnheUHupyLUhR2wp3XvBbGUDa3pGXeMeS29ibZiVGzXjgbtp5qZ7F1uWK3Bjb4GQo5u9
	LpctAz7xvd0E9EkUtvZAuQkPv6eyVYE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf08.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783481180;
	b=XuqPyHJh5kZEdOagl4LoOzV0LNXbbWZwBv/oc5JzSthCjwb6sXrPOYtc/cDO2aghS7VZR3
	MBhLcH87Plv85UMgUc2tXzu5+6kqMS5mHlc89Q6RdsRt4ButSBrLWEF8OGzxWMfDMnUeg7
	rHJSdIPcPtGPAtNkcfq0PAq5a+ubNlk=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gw3Qt5ydyzYmMBf;
	Wed,  8 Jul 2026 11:26:14 +0800 (CST)
Received: from TA002.hihonor.com (10.77.230.8) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 8 Jul
 2026 11:26:14 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA002.hihonor.com
 (10.77.230.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 8 Jul
 2026 11:26:01 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Wed, 8 Jul 2026 11:26:14 +0800
From: wangtao <tao.wangtao@honor.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "will@kernel.org" <will@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "sj@kernel.org" <sj@kernel.org>,
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
	<luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>,
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "baoquan.he@linux.dev"
	<baoquan.he@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com"
	<dvander@google.com>, zhangji <zhangji1@honor.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Thread-Topic: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Thread-Index: AQHdDdtOKxyL+IwP/0+o3I4bi0Jgh7ZhGu0AgACbXoD//33xgIAAiIWwgAAIOQCAAS4i8A==
Date: Wed, 8 Jul 2026 03:26:13 +0000
Message-ID: <104a258dcf2f4e4387199b62a66141a6@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
 <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
 <f640c89d9722462098bf1b7a0a6854c2@honor.com>
 <66e8d008-5eaf-4a9a-9cca-e9b2bd8c9f9a@kernel.org>
In-Reply-To: <66e8d008-5eaf-4a9a-9cca-e9b2bd8c9f9a@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 830FC160002
X-Stat-Signature: awsrkn6np686h3ugc4geew8fdjpog1gu
X-Rspam-User: 
X-HE-Tag: 1783481179-550032
X-HE-Meta: U2FsdGVkX1+mojnnDVIRQ77mtdjyIjg800FGlQH7vZ2YMLoUIU7kEIOyhrvfmRTMNMG+DC6KkJwlY6C2LfxzL+2MeaMC29ScG3v5gTsScYlzCPJAs5Zawj+eUQwoIY5bdf4pLoduFevyWEYcVfCIC2rUG4eo3ZC9Vlwzlh9mLkwH75VbZRFbgE/g3/h/PG7NfTPE1mAz+XjNVtfFICz8s48Di5X4wDte1Rcpg9r2c1rn5RjrMNxy3K1L2nFNNjxZja3xTfDOVjR3f4xCMXIW1AKOpgoqEO2Mk8a5jxDgLKnx8CUp29hi6fDRtJWWu24OKQeOcpsI4hE80WJHjH5b+3QjANpfyKjQRoNMhJw81uLMfTUk97q6uedrhkXhD884CYghs9SNrfmfY2yZRLwJ8/q4uv2+EyGom0sJ08w87+Gjmo6x0doLwPz79dGV13CYNB9GnP8reQBh2/C78NSbG7H3Ef/QjeVuZKscplw2KwoKkrnek8C4f6jSDl2gzNqcoB7A/MrkpMcXvZBdytAVD/6gvMLx3n26rFRcchU8BY/x9dO0jsCnAlX9s506xTFR1aJJVT1M+tIcuUlkBGf8qzVOYY/SgsrceXMmPoiOrma5mGCJQ1JcG7ypUpRrg+ex8x7DiEmBsdCoxhNvtJiaAGh7yGi/O9WSKOIPhVGAIEaRQ6KMtWNKhwBbdNnaL8vi40kjHxal1P85UYgL8511hZ3GZvR5KSrvEcBD61kmVkVwnPYNaFm6PHRJ36UMZvuEY1b9yc56KwFPcjgzL0h8c55g4lx2WJlXLw6mjoT0Ssl3glJwZwpc9hEk8Iu06or3Wd7AEf4KUmv70EQWoqd2AyYrwU9BxRtExCEEAVdYXOh25ypEBE377qxXpTliY02yhxF8Oqm++ywvAR2TNp4IBTtgw0LaQCz+V3CY1EtBu8Vk7Tn7v7EJb5lsPkfXpeJNL3wG6r1BxMEKR1R0fRx
 SFEzhjq3
 3mDmXcdis2fFQsH5tGgkqHnbIl1bwEWeDSQA2EnHBW8tMTSdmxFMn8tdJpozxsacbWKOh25shk7WhdXlqZKdhQ+1GuD7HZBoIn1WE72T6MOC7Ingusy/ktJcbTGXCW/z3pnNfIf9taD1sgT7dgDM0elhstiYUCC6/6e+vF1PbhKe9/1oeOaaxbTicnQQbLy0E0TOmaXhhT+S4KlYveWFsDzvaVgV8oqST9r2TmQtigbwL9YEsj3dvFluvCrELycrKUy2T10PMKbHkdoTSrFiqQMghlLBAeb9KUn63/i+BlhH1ckUqJSCKLX4lNCNANdpc6KEYR0JOUBMmlezsSg4BA4Y3j2aaaB5tPAihPBXkDV4VzL0BH1gTq/mz0p5lJeefudZKQcfGBvJSN/v/3r/AAT82YUCUlIlW5dh/4XNBfZUsFXqNlxmyDquoUZXioOA1lq2+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+IEF0IGZpcnN0LCBJIHRob3VnaHQgSSB3YXMgdGhlIG9ubHkgb25lIHdobyBmb3VuZCBhbm9u
X3ZtYSBoYXJkIHRvDQo+ID4gdW5kZXJzdGFuZC4gQWZ0ZXIgcmVhZGluZyB5b3VyIGVhcmxpZXIg
ZW1haWwsIEkgcmVhbGl6ZWQgdGhhdCBtYW55IHBlb3BsZQ0KPiBhbHNvIGNvbnNpZGVyIGl0IGRp
ZmZpY3VsdCB0byBmb2xsb3cuDQo+IA0KPiBSaWdodCwgdGhhdCdzIGhvdyBMb3JlbnpvIHN0YXJ0
ZWQgaGlzIHdvcmssIHRyeWluZyB0byByZXBsYWNlL3JlbW92ZQ0KPiBhbm9uX3ZtYSBlbnRpcmVs
eS4NCj4gDQo+IFNvIEkgdHJpZWQgYSBkaWZmZXJlbnQgYXBwcm9hY2ggYW5kIGltcGxlbWVudGVk
DQo+ID4gYW5vbl92bWEgcm1hcCB1c2luZyBhIHNpbXBsZXIgZG91Ymx5IGxpbmtlZCBsaXN0IHBs
dXMgZGVwdGggbWVjaGFuaXNtLg0KPiANCj4gQW5kIHRoaXMgaXMgd2hhdCBJIGRvbid0IHVuZGVy
c3RhbmQuIFlvdSB3ZXJlIHRvbGQgdGhhdCBMb3JlbnpvIGlzIHdvcmtpbmcgb24NCj4gcmVtb3Zp
bmcgYW5vbl92bWEsIHlldCB5b3UgZGVjaWRlZCB0byB3b3JrIG9uICsgc2VuZCBzb21ldGhpbmcg
dGhhdA0KPiByZXdvcmtzIGFub25fdm1hPw0KPiANCj4gQWxzbywgSSBhbSByZWFsbHkgY3VyaW91
cyBhYm91dCB5b3VyIGV4cGVjdGF0aW9uOiBub3QgaGF2aW5nIGEgc2luZ2xlIHBhdGNoDQo+IGNv
bnRyaWJ1dGVkIHRvIE1NLCBldmVuIHdvcnNlLCBub3QgYSBzaW5nbGUgUkIgdGFnIG9yIGFueXRo
aW5nLCB5ZXQgeW91DQo+IHJld29yayBvbmUgb2YgdGhlIG1vc3QgY29tcGxpY2F0ZWQgcGFydCBv
ZiBNTSByZXBlYXRlZGx5IHVzaW5nIG90aGVyDQo+IGNvbXBsaWNhdGVkIGFwcHJvYWNoZXMsIGFu
ZCBpbW1lZGlhdGVseSBzdGFydCBkZW1hbmQgdGVjaG5pY2FsIGRpc2N1c3Npb25zPw0KPiBBZnRl
ciBzZW5kaW5nIGFuIGFic29sdXRlIGhvcnJpYmxlIHYxPw0KPiANCj4gSSByZWFsbHkgdHJ5IHRv
IGJlIGEgbmljZSBwZXJzb24sIGJ1dCByZWFsbHksIGFtIEkgZHJlYW1pbmc/DQo+IA0KDQpJdOKA
mXMgc2ltcGxlOiBvcHRpbWl6ZSBtZW1vcnkgdXNhZ2UgYW5kIHNoYXJlIGl0IHdpdGggdGhlIGNv
bW11bml0eS4NCg0KV2lzaCB5b3UgYWxsIHRoZSBiZXN0Lg0KDQo+IA0KPiBPYnZpb3VzbHksIExv
cmVuem8gaXMgc3RpbGwgd29ya2luZyBvbSBoaXMgYXBwcm9hY2gsIGFib3V0IHdoaWNoIHRoZXJl
IHdlcmUNCj4gZGlzY3Vzc2lvbnMgYXQgY29uZmVyZW5jZXMgYW5kIExXTiBhcnRpY2xlcy4NCj4g
DQo+IFN0YXRpbmcgInRoYXQgeW91IHdhaXRlZCBmb3IgYSB3aGlsZSIgaXMgbHVkaWNyb3VzIGdp
dmVuIHRoYXQgeW91ciBvbGQgcGF0Y2ggc2V0DQo+IHdhcyBwb3N0ZWQgYXJvdW5kIG9uZSBtb250
aCBhZ28sIGFuZCBhIGNvbXBsZXRlIHJlZGVzaWduIC0tIG1vdmluZyBhd2F5DQo+IGZyb20gYW5v
bl92bWEgLS0gaXMgbm90IGV4cGVjdGVkIHRvIGJlIGEgc2hvcnQtdGVybSB0aGluZy4NCj4gDQo+
IE1lYW53aGlsZSwgTG9yZW56byBpcyBzZW5kaW5nIHJlYWwgY2xlYW51cHMgWzFdIGFzIHByZXBh
cmF0aW9uIGZvciBiaWdnZXINCj4gY2hhbmdlcy4gLi4uIHdoaWNoIGlzIHdoYXQgd2UgdXN1YWxs
eSBleHBlY3Qgb24gc3VjaCBmdW5kYW1lbnRhbCByZXdvcmtzLg0KPiANCj4gSSdtIHJlYWxseSBs
ZWZ0IGNsdWVsZXNzIGhlcmUgd2h5IHdlIGFueW9uZSBzaG91bGQgc3BlbmQgdGltZSB0cnlpbmcg
dG8gdGhpbmcNCj4gdGhyb3VnaCB5ZXQgYW5vdGhlciBkYXRhIHN0cnVjdHVyZSBhbmQgeWV0IGFu
b3RoZXIgbG9ja2luZyBzY2hlbWUsIGZvcg0KPiBzb21ldGhpbmcgd2Ugd2FudCB0byByZW1vdmUg
ZW50aXJlbHk/DQo+IA0KPiBBZ2FpbiwgSSByZWFsbHkgdHJ5IHRvIGJlIGEgbmljZSBwZXJzb24s
IGJ1dCBzb21ldGhpbmcgaGVyZSBqdXN0IGRvZXNuJ3QgYWRkIHVwLg0KPiANCj4gWzFdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL3IvY292ZXIuMTc4MjczNTExMC5naXQubGpzQGtlcm5lbC5vcmcN
Cj4gDQo+IC0tDQo+IENoZWVycywNCj4gDQo+IERhdmlkDQo=


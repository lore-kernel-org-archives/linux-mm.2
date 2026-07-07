Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B8B9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EC56B00A1; Tue,  7 Jul 2026 05:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EF46B00A2; Tue,  7 Jul 2026 05:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19D36B00A3; Tue,  7 Jul 2026 05:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAEA56B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:20:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30E2C4039F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:20:33 +0000 (UTC)
X-FDA: 84961435146.01.213A170
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A8EB140007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:20:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J25m0TwW8o74ZimHAzHNjY7M1tg1RLD5s4C8q+gek5s=;
	b=qmqBJ4Y26bUw0ynM58e2u4i/Lm7hvEeO+7gdOWTXXCHN9G49VgD1drqvZkijiowCruuyyI
	vDOowhfrjAw5gA3pFWTl5PmbvBZGLG1rrqCdFqGZTE38TAwOSFtl36Hdpqzf8nVL/kg/eP
	8DHnFEkDqgVYv2seON1DZYP1oVlvHcY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416031;
	b=KJNHYXZLtDYzyUCd67ImpaefZRGUDOsZhgMAcihiL1CwWClKpzHL4oYjS+yQTbvU3y/ejY
	TxEpOg332HT93lbWzh2tNvjwWcYGDUhKzbXs79OZxAR81dkPeTbsIKAV5aPGx0psyz9Rnp
	S+tu8cedegzBFEOW5d4+mQ/hXRCeq+Y=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvbL11GHLzYmBHn;
	Tue,  7 Jul 2026 17:20:25 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 17:20:24 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 17:20:24 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Tue, 7 Jul 2026 17:20:24 +0800
From: wangtao <tao.wangtao@honor.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
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
Thread-Index: AQHdDdtOKxyL+IwP/0+o3I4bi0Jgh7ZhGu0AgACbXoD//33xgIAAiIWw
Date: Tue, 7 Jul 2026 09:20:24 +0000
Message-ID: <f640c89d9722462098bf1b7a0a6854c2@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
 <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
In-Reply-To: <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: fduq7i9d8pq73k4ibq9hj7e1skc9s75f
X-Rspamd-Queue-Id: 5A8EB140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783416030-886147
X-HE-Meta: U2FsdGVkX1+lKLKd8aY5T0T13TcJbka7594CYIRP5M5QM40t4Bn2iDFINcA2tpFgx+607MigiJCTUrpvYOcjEZHg/wNAqIawJL61pitZ5nwHr+k/RtEQY9oqH3CMtLWv+01ZoeeCdd0/hwpTu+9yc6BDrBUzN0grGAT55rUqZYsTPgyKmCQNodUyJ/8kjx2Fu+FOBXPHFfVphIl/YxAp8R+VkKcCbyo+OeWOcCKKDOW2L0EEagpKLgoUmWAO0z2YSXP2/8IHN2Z4eZaWIBy+LwEisRLH4u7KvWo10J4yVjQ+BXogWI1iPO6Wxm3xpbIHR6E1l2zLG8Dh7FkWifEtD9HuCRXnPXVyQIZakkZWKvl4thZQdEihqYPUMpBZq2vscQeL9fy0y8UgBZWFSq2NAnFXwnffK3ZHOfOemFsM+BGsQ2YtwWLmKdfwjvttgaLsBHA9K5cTYqIhBNsSmNZ6zg2sPPug2i09jik9nn0cALg2a2yikgYfkZUZD9SGlIsm3xtvYEOcbdzN7IxkRBJ5WWPmVFX5xNLJi2VlK8d+BQmtfgtJyP3jW+VRhb6/TqE8GOXjwh/J0tRQsC7aa+4DoHSxyA80Vcl9O8DWToHOCWRSdGS1WoS1OuVYfAXCNkLI0UqRfwLbpMSxaV/aaRuDjyOV4bxU34yGh1Cs3WlCM3ySIOdGspMhuIEPdDnfsXxFb6LojQ5ASCAeWLZn4O7uHrpCFNJffpb9LoklwamfIL88h7MMEpHecGmdorOgV8T1Bow4fqD8b5Ngbwe9AMWWnrf1DM7JZ8M1pcxeRwGrwt+dP58aosQWI0+A57OF+waIfNiczjaDKLBnGFVWp3BKFjJo+YZZxDzjG2vP7FEFzCoFqF0/Ykvkj/AXS1IFCEemXNWzTWDb87IvEV5FXI4vqdezFyVRN+f9oSBLapYQCGjVtT7qKjl6n4zS51YkydLPsBNzn9cyhZ0FCDdWMt+
 kJ5mv1K+
 nhqfxNa01wfcly8lUkPGiUL0OGEUR+P6dBX5UVG9DKtnrDI8AED1fRxDroF1mfR0/V/PeZUnNufAF3Ws4lgzOHhMt4qExTqMX64vzIi2UPhemxht3+MxGSr+HHPB2srf6obBou9RKQ9OgdGryKEReJdblLl/0Pi17fN1qNHCZ2vuKXLa1l4aJOH6/kmUKUDKPdqNUSmzY5qBfx7STeUCklD4ELAFdr8u86P7Bw4oxpQUFc1cUx4oQUtTSWRmPoftXlP7nicnoWXUqazelWuXis7uxQcIULttO2ahJXek3CCtIg61D7l+5T/Md0RiTDLxf8cbfSN7OYWSAKNcr+1BN6ZacVS4AP26fNXWQUTP0qLW4x0d71tfo5BDKWwr5jpaxqFurmf+uzn46ZpWeQGdoEEKiiNVK+2cgZZVyNe8+e0V7cqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+PiBPbiA3LzcvMjYgMDg6MzIsIHRhbyB3cm90ZToNCj4gPj4+IEhpIGFsbCwNCj4gPj4+DQo+
ID4+PiBTaW5jZSB2MSB3YXMgcmVsYXRpdmVseSBjb21wbGV4IGFuZCBkaWZmaWN1bHQgdG8gZXh0
ZW5kLCB0aGlzDQo+ID4+PiB2ZXJzaW9uIGFkb3B0cyBhIHNpbXBsZXIgYW5vbl92bWEgaW1wbGVt
ZW50YXRpb24gYXBwcm9hY2guDQo+ID4+DQo+ID4+IEkgcmVhbGx5IGhhdGUgdG8gcmVwZWF0IG15
c2VsZiwgYnV0IHlvdSBzZWVtZWQgdG8gaGF2ZSBtaXNzZWQgbXkgbWFpbg0KPiA+PiBwb2ludCBb
MV0NCj4gPj4NCj4gPiBJIHNhdyBpdCwgYW5kIEnigJl2ZSB3YWl0ZWQgZm9yIGEgd2hpbGUgYXMg
d2VsbC4NCj4gDQo+IEFwcGFyZW50bHkgeW91IHNhdyBpdCBidXQgeW91IGRpZG4ndCByZWFkIG15
IHJlcGx5IGFib3V0IHNsYXBwaW5nIG1vcmUNCj4gY29tcGxleGl0eSBvbiBzb21ldGhpbmcgY29t
cGxpY2F0ZWQuDQpUaGlzIHYyIGlzIGEgY29tcGxldGUgcmV3cml0ZSByZXBsYWNpbmcgdGhlIG9y
aWdpbmFsIGFub25fdm1hIGFuZCBhbm9ueW1vdXMtcGFnZQ0KcmV2ZXJzZS1tYXBwaW5nIHRyYXZl
cnNhbC4NCg0KVGhlIG5ldyBhbm9uX3ZtYSBoaWVyYXJjaHkgaXMgcmVwcmVzZW50ZWQgdXNpbmcg
YSBzaW1wbGUgZG91Ymx5IGxpbmtlZCBsaXN0IHdpdGggZGVwdGggaW5mb3JtYXRpb24sDQpyZXBs
YWNpbmcgdGhlIGNvbXBsZXggdG9wb2xvZ3kgb2YgcmVkLWJsYWNrIHRyZWVzIG1haW50YWluZWQg
YnkgZWFjaCBhbm9uX3ZtYSBpbiB0aGUgb3JpZ2luYWwgZGVzaWduLA0KYW5kIGFsc28gcmVtb3Zp
bmcgYW5vbl92bWFfY2hhaW4uDQoNCkV4Y2x1ZGluZyBwYXRjaCAxMSwgd2hpY2ggb3B0aW1pemVz
IGxlYWYgVk1BIHJtYXAgd2l0aCBQVkwsIGFuZCBwYXRjaCAxMiwgd2hpY2ggb3B0aW1pemVzIG1l
bW9yeQ0KdXNhZ2UgdGhyb3VnaCBzaGFyZWQgc2VtYXBob3JlcywgdGhlIGJhc2UgdmVyc2lvbiBj
b250YWlucyByb3VnaGx5IDgwMCBsaW5lcyBvZiBjb2RlLCBpbmNsdWRpbmcgdGhlDQpjb21wYXRp
YmlsaXR5IHBhcnQgcmVwbGFjaW5nIHRoZSBvcmlnaW5hbCBhbm9uX3ZtYSBpbXBsZW1lbnRhdGlv
bi4NCg0KPiANCj4gIDEyIGZpbGVzIGNoYW5nZWQsIDEwNTYgaW5zZXJ0aW9ucygrKSwgNTQgZGVs
ZXRpb25zKC0pDQo+IA0KPiA+DQo+ID4gSWYgdGhlcmUgYXJlIHRlY2huaWNhbCBpc3N1ZXMsIHBs
ZWFzZSBwb2ludCB0aGVtIG91dCBkaXJlY3RseS4NCj4gPiBPciBpcyB0aGlzIHNpbXBseSBob3cg
dGVjaG5pY2FsIGRpc2N1c3Npb25zIGFyZSB1c3VhbGx5IGNvbmR1Y3RlZCBpbiB0aGUNCj4gTGlu
dXggY29tbXVuaXR5IG9yIHRoZSBtbSBzdWJzeXN0ZW0/DQo+IA0KPiBJIHN1Z2dlc3QgeW91IGdv
IGJhY2sgYW5kIHJlYWQgbXkgZW1haWwuDQoNCkF0IGZpcnN0LCBJIHRob3VnaHQgSSB3YXMgdGhl
IG9ubHkgb25lIHdobyBmb3VuZCBhbm9uX3ZtYSBoYXJkIHRvIHVuZGVyc3RhbmQuIEFmdGVyIHJl
YWRpbmcgeW91ciBlYXJsaWVyIGVtYWlsLA0KSSByZWFsaXplZCB0aGF0IG1hbnkgcGVvcGxlIGFs
c28gY29uc2lkZXIgaXQgZGlmZmljdWx0IHRvIGZvbGxvdy4gU28gSSB0cmllZCBhIGRpZmZlcmVu
dCBhcHByb2FjaCBhbmQgaW1wbGVtZW50ZWQNCmFub25fdm1hIHJtYXAgdXNpbmcgYSBzaW1wbGVy
IGRvdWJseSBsaW5rZWQgbGlzdCBwbHVzIGRlcHRoIG1lY2hhbmlzbS4NCg0KVGhhbmtzLA0KVGFv
DQoNCj4gLS0NCj4gQ2hlZXJzLA0KPiANCj4gRGF2aWQNCg==


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0EACD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 03:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96AB6B0095; Wed,  3 Jun 2026 23:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48356B0099; Wed,  3 Jun 2026 23:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36E36B009D; Wed,  3 Jun 2026 23:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B156B6B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:51:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 327B41A04D7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:51:20 +0000 (UTC)
X-FDA: 84840855120.18.C30A181
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf06.hostedemail.com (Postfix) with ESMTP id 66B3B180005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:51:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780545077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z06ERlBzw1W8qR2p/vecrNR9m/OggpDHpVGwVWLxzPQ=;
	b=fuOsGPqqfa/EoYtHSAEyDWq/MN097QNpgs+Norp3ysE8r4EMi2sM5p3uscj+CTJcnH/HGL
	gKDtgTxnobE3+/zpE9gLV7QCXslNgqZOgngCjAdNZb5mc6xLpO0nZPGkG8f8ADEtaFpSHS
	GmKqwHizZzr23U76Kw1WmM2fl6sRbeE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780545077;
	b=MUcSwyZSMRhtlG2IaUi6c7Yrcs7og75yIbwkX65orHZA1ZhVOJToaV2fJjRIj0tM7DwWJk
	V/ow5VNE1idDzjOKrkyXXPI95Ru6W8iBMPcnxCp1rxdH/p8rGbqOw0bPx2S+51HNyj/XU5
	De9//9OO9Kuo22reQIdQqbD3OW/HXN0=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gW9Y90dXJzYv6Kg;
	Thu,  4 Jun 2026 11:49:17 +0800 (CST)
Received: from TA005-1.hihonor.com (10.77.216.68) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 4 Jun
 2026 11:50:55 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA005-1.hihonor.com
 (10.77.216.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 4 Jun
 2026 11:50:51 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 4 Jun 2026 11:50:54 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Harry Yoo <harry@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
	"luizcap@redhat.com" <luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
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
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "jparsana@google.com"
	<jparsana@google.com>, "dvander@google.com" <dvander@google.com>, zhangji
	<zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYq8jCAgAEtZwD//9sKAIAAkGoQ//+yigCAAYNmcA==
Date: Thu, 4 Jun 2026 03:50:54 +0000
Message-ID: <a073c529df7841d98dcec9ddc3dad8bc@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
 <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com> <ah_VMf0ZJTRsrArV@lucifer>
 <c769ed2347bb45b19cc3ba5717e9fdd2@honor.com> <aiAMHhq9QCp-z3V9@lucifer>
In-Reply-To: <aiAMHhq9QCp-z3V9@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66B3B180005
X-Stat-Signature: 5jnwp44hfyodfgprzg7tr51h51g4humf
X-Rspam-User: 
X-HE-Tag: 1780545076-611319
X-HE-Meta: U2FsdGVkX1++VWcvjzLJYfVHUqy0dGjK/SInJJanjj/sa07BjPJ27nd9xJQlYpGIRVQXtQ4VhJKglzk+1JCD7KrIsDUmJc+tmitsD8h0ikrbkPQFcGwNc4AjYYtKb8Jvvjzloi9q5NQzuEAZBNxwOdzlOkHts3ALpU/DjD1piU4Vce1Py8jfVlwyNT8gPg2cUaDRV7ryOk0D3MchAFec47/6N5jTx7C+fp2gyS78upJDrtOiRkYf2xvZcCXs8KTwpvTQJJWXe1zKZZ4KuePRtPM6ldceJs9ExA1DpAhXgm7ZanNSsS0DKOjris5iD7oBm7h8XbSmdNt4681ufS0uUcursCHMS/ag8sEEsP5H45P7tZOF6hs0ntgh0z+YUM1ZrPn5NorlZ+Yv/CiovM4u0tnXLs+KroEKH6T5vT00+hqx4rV7MaBQIJADhD5Bl2+qaEcVQJYbnDMJtJ3ufAP0jmLRCneHRxf+l0a+FShXmupBJPk/luvpPOp/Qy968AftGriXZ5ksUehkDrtR/ZPgr+h91501EAA8IfRUu53iGwm/CbOljLFypeA+s2K70qXMWmarhXFIcmZgZQr4q3J5/Hlotmwe3l9N/GmhRg2sJTg431PYLx5pcski3hmunsOBzOOU0k1JsmRIBLj8ZWvdYUxkNdF41ks0y0Jq14A+v8jLd2fXz41f5hm+Y74Fnfa1Apf1N6TNe0PLD3K8ViCCsqxUebNH2NkCUJN+9xxQo5iYPg9t2Hzqt9lRgWV1Pn8Jf6xtQq8D/tp6CM8We/TRVPLgZMSROT2MHoD37noGVOQFwbMZyLCyFDtV4yZSwe/9GkGNHbSpLUEByqt9rpSmaAAvdm3mAE3NFvkk2fkMXHKHqD5a1+JVtuOC1j26oJqFTT0sCic7AW1LYbBUMYbBlExOuDH8ptaCBknXvhJhiMS054BaXT3Qb/CS2FySzt8I7HT86XRkhQAC2PiUZqW
 Sb3tfnMy
 0NDJWKP3uhZcmXIVQ+mJmrXjqmadKtMWVNxaTyiTsquP+AMTZEVrv4CJ34gHp4bODpCbkOizk99k3CwVrygYJ/B3FmKd8sCts/MYs8fGg99ODduw4fwkcmuDa8xxDQbGy4SpmPjKr+3vlJ9NllbGz02QXlbSaJDQyZCyoiZLCxG+pDsZLUMvNBQEjNUuJ5hmH3k2gx6PBnowOOnSZlzp9U4Lj4bqfE4PEgsQ8eVvgGMLDAc5c1dGyNjJZzK7oNzN4PgccUfnsXsCX0BXMr0B39iti4kfdZriqoqyYYWkUNwCrQlJVxwAuf5QKU3985ji29p6mzdLgWlXOlyOHFW6Ei62NNhiA553bXnWzz7h7vFxxJUTA3iJAolkYcB3sNS2nkzfQ6ZmdJ5a3XxXhdvdvjN/ghbA3OjHpRDeh3AKbBnsAWMp1PSFuri2z80eyyUQYq7Vk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gVGhhbmtzIGZvciB5b3VyIHJlcGxpZXMsIGJ1dCBJIHJlYWxseSBoYXZlIHRvIHN0b3Ag
ZG9pbmcgZGVlcGVyIGFuYWx5c2VzIGxpa2UNCj4gdGhlc2UgZm9yIHRpbWUgbWFuYWdlbWVudCBw
dXJwb3Nlcy4NCk9mIGNvdXJzZSBJIHdpbGwgcmVzcG9uZCB0byB0ZWNobmljYWwgZGlzY3Vzc2lv
bnMuDQoNCj4gDQo+IEkgZGlkIHRoaXMgbW9yZSBzbyB0byBtYWtlIHRoZSBwb2ludCBmcm9tIFsw
XSBhcyB0byB3aHksIGluIGxvd2VyIHRydXN0DQo+IGVudmlyb25tZW50cywgdGhpcyBpcyBqdXN0
IG5vdCBmZWFzaWJsZS4NCj4gDQo+IFdlIGNvdWxkIGxvb3AgYXJvdW5kIGZvciBob3VycyBhbmQg
aG91cnMgYW5kIGhvdXJzIGhlcmUuDQo+IA0KPiBJbiBnZW5lcmFsIGFzIGJlZm9yZSwgZXZlbiBp
ZiBhbGwgd29ya2VkIHBlcmZlY3RseSAoSSdtIHZlcnkgbXVjaCBub3QgYXQgYWxsDQo+IGNvbnZp
bmNlZCksIGV4dGVuZGluZyBhbm9uX3ZtYSBhbmQgcGlubmluZyBWTUFzIGlzIHNpbXBseSBhIG5v
LWdvIGZvcg0KPiBhcmNoaXRlY3R1cmFsIGFuZCBjb21wbGV4aXR5IHJlYXNvbnMuDQo+IA0KPiBJ
IGFsc28gZmluZCB0aGUgbG9ja2luZyBzdG9yeSBkdWJpb3VzIGFuZCB0aGUgbGFjayBvZiB0ZXN0
cyBvciBhbnl0aGluZw0KPiBjb3Jyb2JvcmF0aW5nIGNvcnJlY3RuZXNzIGlzIGFkZGl0aW9uYWxs
eSBmYXRhbC4NCj4gDQpEdXJpbmcgcm1hcCwgYW5vbl92bWEgcHJvdmlkZXMgYSBzdXBlcnNldCBv
ZiBWTUFzLiBXZSBmaXJzdCBjb25maXJtDQp3aXRoIHZtYV9hZGRyZXNzKCksIGFuZCB0aGVuIGlu
IGVhY2ggcm1hcF9vbmUgd2UgZnVydGhlciBjaGVjayB3aGV0aGVyDQp0aGUgVk1BIG5lZWRzIHRv
IGJlIHByb2Nlc3NlZCB0aHJvdWdoIHBhZ2Vfdm1hX21hcHBlZF93YWxrKCkgYW5kDQpjaGVja19w
dGUoKS4NCg0KVGhlIGxhenkgVk1BIHVzZWQgYnkgQU5PTl9WTUFfTEFaWSBwcm92aWRlcyBvbmx5
IG9uZSBWTUE6IGlmIHRoZXJlIGlzDQpubyBmb3JrIG9yIG1yZW1hcCwgdGhlbiB0aGlzIHNpbmds
ZSBWTUEgaXMgc3VmZmljaWVudC4gVG8gYXZvaWQgdGFraW5nDQp0aGUgZm9saW9fbG9jayBkdXJp
bmcgZm9yayBhbmQgbXJlbWFwLCBhZnRlciBhbm9uX3dhbGtfYW5vbiwgaWYNCmZvbGlvLT5tYXBw
aW5nIGlzIHVwZ3JhZGVkIHRvIGFub25fdm1hLCB3ZSByZXRyeSBvbmNlLg0KDQpJZiB5b3VyIGNv
bmNlcm4gaXMgYWJvdXQgdGhlIGxhY2sgb2YgbG9ja2luZyBkdXJpbmcgcm1hcCwgeW91IGNvdWxk
DQphbHNvIHJlZmVyIHRvIGZvbGlvX3dhaXRfdGFibGUgYW5kIGFkZCBhIHNldCBvZiBhbm9uX3Zt
YV9sb2Nrcy4gVGhhdA0Kd2FzIGhvdyBJIGhhbmRsZWQgaXQgZHVyaW5nIG15IGluaXRpYWwgZGVi
dWdnaW5nLiBMYXRlciwgYWZ0ZXINCnJldmlld2luZyB0aGUgY29kZSBmbG93LCBJIGZvdW5kIHRo
YXQgdGhlIGxvY2sgbWlnaHQgbm90IGJlIG5lY2Vzc2FyeSwNCnNvIEkgcmVtb3ZlZCBpdC4NCg0K
PiBBbmQgZmluYWxseSwgSSB3YXMgYWxyZWFkeSB3b3JraW5nIG9uIGEgcmVwbGFjZW1lbnQgZm9y
IGFub25fdm1hLCBhbmQgdGhlDQo+IGdlbmVyYWxseSBkb25lIHRoaW5nIGluIHRoZXNlIHNpdHVh
dGlvbnMgaXMgZm9yIG15IHdvcmsgdG8gdGFrZSBwcmVjZWRlbmNlLg0KPiANCj4gU28gSSdtIGdv
aW5nIHRvIGJhaWwgb3V0IG9uIGZ1dGhlciBkZWVwZXIgYW5hbHlzZXMgaGVyZSBhcyBvdGhlcndp
c2UgSSBzaW1wbHkNCj4gY2FuJ3Qgd29yayBvbiBhbnl0aGluZyBlbHNlIDopDQo+IA0KPiBUaGFu
a3MsIExvcmVuem8NCj4gDQo+IFswXTpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYWg4ODdB
NVZrWE9jbXEtZ0BsdWNpZmVyLw0KPiANCj4gDQo+IE9uIFdlZCwgSnVuIDAzLCAyMDI2IGF0IDEx
OjA1OjI4QU0gKzAwMDAsIHdhbmd0YW8gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gQWdh
aW5zdCBteSBiZXR0ZXIganVkZ21lbnQgSSdsbCBhZGRyZXNzIHRoZSBzdHVmZiBoZXJlLi4uDQo+
ID4gPg0KPiA+ID4gPiBWTUEgb3BlcmF0aW9ucyBjYW4gYmUgcm91Z2hseSBkaXZpZGVkIGludG8g
dGhyZWUgY2F0ZWdvcmllcy4gVGhlDQo+ID4gPiA+IGhhbmRsaW5nIG9mIEFOT05fVk1BX0xBWlkg
aXMgYnJpZWZseSBkZXNjcmliZWQgYmVsb3cuDQo+ID4gPg0KPiA+ID4gSSBkb24ndCBhZ3JlZSwg
dGhlcmUgYXJlIHBsZW50eSBtb3JlIFZNQSBvcGVyYXRpb25zLiBCdXQgd2l0aA0KPiA+ID4gcmVz
cGVjdCB0byBhbm9uIHJtYXAgdGhlcmUgYXJlOg0KPiA+ID4NCj4gPiA+IC0gZm9yaw0KPiA+ID4g
LSBtZXJnZS9zcGxpdA0KPiA+ID4gLSByZW1hcA0KPiA+ID4NCj4gPg0KPiA+IFllcywgdGhlc2Ug
YXJlIHRoZSB0aHJlZSBjYXRlZ29yaWVzLiBJIG9yaWdpbmFsbHkgaW50ZW5kZWQgdG8gZXhwbGFp
bg0KPiA+IHRoZW0gYnkgY2xhc3NpZnlpbmcgYmFzZWQgb24gc3lzdGVtIGNhbGxzOyBJIHNob3Vs
ZCBoYXZlIHVzZWQgbXJlbWFwDQo+IGluc3RlYWQgb2YgbW92ZV92bWEuDQo+IA0KPiBJIGRvbid0
IHRoaW5rIHlvdSBtZW50aW9uZWQgbW92ZV92bWEoKT8gTWF5YmUgSSBtaXNzZWQgaXQuDQo+IA0K
PiBUaGUgY2F0ZWdvcmlzYXRpb24gaXMgbW9zdCB1c2VmdWxseSBiYXNlZCBvbiBjYWxsZXJzIG9m
IGFub25fdm1hX2Nsb25lKCkuDQo+IA0KPiA+DQo+ID4g5piv55qE77yM5piv6L+Z5LiJ57G777yM
5oiR5pys5oOz5LuO57O757uf6LCD55So5Y675YiG57G76K+05piO77yM5bqU6K+l5bCGbW92ZV92
bWENCj4g5o2i5oiQbXJlbWFw55qE44CCDQo+ID4NCj4gPiA+IFlvdXIgYXBwcm9hY2ggc2VlbXMg
dG8gY29tcGxldGVseSBpZ25vcmUgVk1BIHNwbGl0IGFuZCB0aGUgbmVlZCB0bw0KPiA+ID4gbWFp
bnRhaW4gYW4gaW50ZXJ2YWwgdHJlZSB0byBfbXVsdGlwbGVfIFZNQXMgZnJvbSBhIHNpbmdsZSBh
bm9uX3ZtYS4NCj4gPiA+DQo+ID4NCj4gPiBUaGUgZm9saW8gdXNlcyB2bWEtPnJvb3Rfdm1hIHRv
IGNvbXB1dGUgZm9saW9fYWRkcmVzcy4gQSBWTUEgc3BsaXQNCj4gPiBmcm9tIGl0LCB2bWFfYSwg
YWxzbyB1c2VzIHZtYV9hLT5yb290X3ZtYSA9IHZtYS0+cm9vdF92bWEgdG8gY29tcHV0ZQ0KPiBm
b2xpb19hZGRyZXNzLg0KPiA+IER1cmluZyBybWFwLCBvbmNlIGZvbGlvX2FkZHJlc3MgaXMgb2J0
YWluZWQsIHRoZSBWTUEgY2FuIGJlIGZvdW5kDQo+ID4gdGhyb3VnaCBtbV9tdC4gV2l0aG91dCBm
b3JrLCB0aGVyZSBpcyBubyBuZWVkIHRvIG1haW50YWluIHRoZSBpbnRlcnZhbA0KPiB0cmVlLg0K
PiANCj4gV2VsbCB5b3UgbmVlZCB0byBzZWFyY2ggZm9yIGV2ZXJ5IHBvc3NpYmxlIHNwbGl0IFZN
QSBpbiBtbV9tdCBub3csIHNvIHlvdQ0KPiBoYXZlIHRvIGdvIHBhZ2UtYnktcGFnZSBzZWFyY2hp
bmcgZm9yIGVhY2ggcGFnZSBmb3IgdGhlIHJtYXAgd2Fsa2VkIHJhbmdlLg0KPiANCkFOT05fVk1B
X0xBWlkgaGFzIG9ubHkgb25lIFZNQS4gV2hlbiBJIGZpcnN0IGxvb2tlZCBhdA0Kcm1hcF93YWxr
X2tzbSwgSSBhbHNvIHRob3VnaHQgaXQgd291bGQgbmVlZCB0byBzZWFyY2ggcGFnZSBieSBwYWdl
LA0Kd2hpY2ggc2VlbWVkIHVuYWNjZXB0YWJsZS4gTGF0ZXIgSSByZWFsaXplZCB0aGF0IGl0IG9u
bHkgbmVlZHMgdG8NCmNoZWNrIHdoZXRoZXIgdGhpcyBWTUEgZmFsbHMgd2l0aGluIHRoZSBybWFw
IHdhbGsgcmFuZ2UuDQoNCkBAIC0zMTczLDIwICszMTcxLDIwIEBAIHZvaWQgcm1hcF93YWxrX2tz
bShzdHJ1Y3QgZm9saW8gKmZvbGlvLCBzdHJ1Y3Qgcm1hcF93YWxrX2NvbnRyb2wgKnJ3YykNCi0J
CWFub25fdm1hX2ludGVydmFsX3RyZWVfZm9yZWFjaCh2bWFjLCAmYW5vbl92bWEtPnJiX3Jvb3Qs
DQorCQlhbm9uX3JtYXBfZm9yZWFjaF92bWEodm1hLCB2bWFjLCBhbm9uX3JtYXAsDQogCQkJCQkg
ICAgICAgMCwgVUxPTkdfTUFYKSB7DQoNCj4gWW91J3JlIGFsc28gcG90ZW50aWFsbHkgcmFjaW5n
IGFnYWluc3QgYSByZW1hcCwgYXMgeW91IHNheSBiZWxvdyB5b3UgZG9uJ3QNCj4gZm9saW8gbG9j
ayBvbiByZW1hcCBzbyBjb25jdXJyZW50IHJtYXAgd2Fsa2VycyBjYW4gYmUgcHJlc2VudCwgdGhl
IFZNQSBjYW4NCj4gYWxyZWFkeSBiZSBjb3BpZWQuDQo+IA0KPiBXZSBhbHJlYWR5IGhhdmUgVk1B
IGxpZmVjeWNsZSBzdGF0ZSBhcm91bmQgZGV0YWNoZWQgVk1Bcywgc28gYSBWTUENCj4gY291bGQg
YmUgaW4gYSBkZXRhY2hlZCBzdGF0ZSwgYXNzdW1lZCBieSB0aGUgZXhpc3RpbmcgbG9naWMgdG8g
YmUgZW50aXJlbHkNCj4gdW5hdmFpbGFibGUgZm9yIHVzZSwgb3V0IG9mIHRoZSBtYXBsZSB0cmVl
IGFsdG9nZXRoZXIgYnV0IGtlcHQgYXJvdW5kIGluIGENCj4gem9tYmllIHN0YXRlLg0KPiANCj4g
V2UnZCB0aGVuIGhhdmUgbGlmZWN5Y2xlIGlzc3VlcyBhbmQgcmFjZXMgYW5kIGVkZ2UgY2FzZXMg
YXJvdW5kIHByb2Nlc3MNCj4gdGVhcmRvd24gb3RoZXJ3aXNlIHdlIG1pZ2h0IGxlYWsgbWVtb3J5
Lg0KPiANCj4gQWxzbywgcHJlc3VtYWJseSB5b3Ugc2V0IHZtYS0+YW5vbl92bWEgdG8gc29tZSBs
YXp5IHNlbnRpbmVsIHZhbHVlIHNvDQo+IHRoYXQgbXJlbWFwIGRvZXNuJ3QgY2hhbmdlIHZtYS0+
dm1fcGdvZmYgd2hlbiB1bmZhdWx0ZWQ/DQo+IA0KPiBZb3Ugd291bGQgbmVlZCB0byB1cGRhdGUg
YW55IHBhdGggdGhhdCBtYW5pcHVsYXRlcyB2bWEtPmFub25fdm1hIGFsc28NCj4gc28gaXQgZG9l
c24ndCBpbmNvcnJlY3RseSBkZXJlZmVyZW5jZSBpdC4NCj4gDQpZZXMsIG1vc3Qgb2YgdGhlIGNv
ZGUgaW4gdGhpcyBwYXRjaCBzZXJpZXMgaXMgaW50ZW5kZWQgdG8gcHJldmVudA0KaW5jb3JyZWN0
IGRlcmVmZXJlbmNpbmcgb2YgYW5vbl92bWEuIElmIHdlIGFzc3VtZSBpdCB3aWxsIG5vdCBiZQ0K
bWlzdXNlZCwgc29tZSBvZiB0aGUgY29kZSBjb3VsZCBiZSBzaW1wbGlmaWVkIG9yIHJlbW92ZWQu
DQoNCj4gPg0KPiA+IGZvbGlv5L2/55Sodm1hLT5yb290X3ZtYSDorqHnrpdmb2xpb19hZGRyZXNz
77yb5LuOdm1h5ouG5YiG5Ye655qEdm1hX2HvvIwNCj4g5L2/55Sodm1hX2EtPnJvb3Rfdm1hID0N
Cj4gPiBmb2xpb+S9v+eUqHZtYS0+dm1hLT5yb290X3ZtYeiuoeeul2ZvbGlvX2FkZHJlc3PjgIIN
Cj4gPiBybWFw5pe25b6X5YiwZm9saW9fYWRkcmVzc+WwseWPr+S7pemAmui/h21tX2105p+l5om+
5Yiwdm1h44CCDQo+ID4g5LiNZm9ya+WwseS4jemcgOimgee7tOaKpGludGVydmFsIHRyZWXjgIIN
Cj4gPg0KPiA+ID4gWW91IG1heSBhbHNvIGFjdHVhbGx5IHNwbGl0IGEgVk1BIGFnYWluc3QgYSBz
aW5nbGUgbGFyZ2UgZm9saW8NCj4gPiA+ICh3YWl0aW5nIG9uIHRoZSBkZWZlcnJlZCBzaHJpbmtl
cikgYW5kIGhhdmUgYSBTSU5HTEUgX2xlYWZfDQo+ID4gPiBhbm9ueW1vdXMgZm9saW8gdGhhdCBp
cyBtYXBwZWQgaW4gdHdvIHBsYWNlcy4NCj4gPiA+DQo+ID4gPiBUaGUgbGF6eSBhcHByb2FjaCBk
b2Vzbid0IHNlZW0gdG8gYWRkcmVzcyB0aGlzIHByb3Blcmx5LiBBbmQgZmF0YWxseQ0KPiA+ID4g
aXQgdGllcyBhbiBhY3R1YWwgVk1BIGFmYWljdCB0byB0aGUgZm9saW8gYW5kIGhhcyB0byBpbXBs
ZW1lbnQgYSBWTUENCj4gPiA+IHJlZmVyZW5jZSBjb3VudCBtZWNoYW5pc20gd2hpY2ggaW50ZXJm
ZXJlcyB3aXRoIHRoZSBvcmRpbmFyaWx5IFZNQQ0KPiBsaWZlY3ljbGUgdG8gZG8gaXQuDQo+ID4g
Pg0KPiA+ID4gVGhlIGZhY3Qgb2YgdXMgdGFraW5nIGFkdmFudGFnZSBvZiBtb3N0IHN0dWZmIGJl
aW5nIEFub25FeGNsdXNpdmUsIGkuZS4NCj4gPiA+ICdsZWF2ZXMnIGlzIHNvbWV0aGluZyB0aGF0
IG15IGFwcHJvYWNoIGlzIGV4YWN0bHkgdGFraW5nIGludG8gYWNjb3VudC4NCj4gPiA+DQo+ID4g
PiBPZiBjb3Vyc2UgYWxzbyBleHRlbmRpbmcgYW5vbl92bWEgaXMgYSByZWFsIG5vbi1zdGFydGVy
Lg0KPiA+ID4NCj4gPiA+IEFsc28gdGhlIGJlbG93ICsgdGhlIHNlcmllcyBpZ25vcmVzIE1BUF9Q
UklWQVRFIGZpbGUtYmFja2VkIG1hcHBpbmdzDQo+ID4gPiB3aGljaCBpcyBhIHByZXR0eSBmYXRh
bCBmbGF3Lg0KPiA+ID4NCj4gPiA+IEl0IGFsc28sIGFzIEhhcnJ5IHNheXMsIGhhcyB6ZXJvIGRl
c2NyaXB0aW9uIG9mIGNvcnJlY3RuZXNzIGluIGEgd2F5DQo+ID4gPiB3ZSdkIHdhbnQgYW5kIG5v
IHRlc3RzLg0KPiA+ID4NCj4gPg0KPiA+IOWPr+S7peato+ehruWkhOeQhuaLhuWIhnZtYeWcqOS4
gOS4quWkp+mhteOAguaLhuWIhueahHZtYV9h5oiWdm1hX2LkuIrnmoQNCj4gc3ViX3BhZ2Xkvb/n
lKjlpoLkuIvmlrnlvI/orqHnrpflnLDlnYDjgIINCj4gPiDlr7nkuo7mlofku7Z2bWHnmoRjb3cg
5Yy/5ZCN6aG177yM5Lmf55So5ZCM5qC35pa55byP6K6h566XcGFnZS9mb2xpb+WcsOWdgOOAgg0K
PiA+DQo+ID4gSXQgY2FuIGNvcnJlY3RseSBoYW5kbGUgdGhlIGNhc2Ugd2hlcmUgYSBWTUEgaXMg
c3BsaXQgd2l0aGluIGEgbGFyZ2UNCj4gPiBwYWdlLiBUaGUgYWRkcmVzcyBvZiBhIHN1Yl9wYWdl
IGluIHRoZSBzcGxpdCBWTUEgKHZtYV9hIG9yIHZtYV9iKSBpcw0KPiA+IGNvbXB1dGVkIHVzaW5n
IHRoZSBmb2xsb3dpbmcgbWV0aG9kLg0KPiA+DQo+ID4gRm9yIENPVyBhbm9ueW1vdXMgcGFnZXMg
b3JpZ2luYXRpbmcgZnJvbSBmaWxlIFZNQXMsIHRoZSBwYWdlL2ZvbGlvDQo+ID4gYWRkcmVzcyBp
cyBhbHNvIGNvbXB1dGVkIHVzaW5nIHRoZSBzYW1lIG1ldGhvZC4NCj4gPg0KPiA+IHN1YnBhZ2Vf
YWRkcmVzcyA9IHZtYV9hZGRyZXNzKHZtYV9hLCBzdWJwYWdlX3Bnb2ZmLCAxKSAgPQ0KPiA+IHZt
YV9hLT52bV9zdGFydCArIChzdWJwYWdlX3Bnb2ZmIC0gdm1hX2EtPnZtX3Bnb2ZmKSAqIFBBR0Vf
U0laRSAgPQ0KPiA+IHZtYV9hLT52bV9zdGFydCAtIHZtYV9hLT52bV9wZ29mZiAqIFBBR0VfU0la
RSArIHN1YnBhZ2VfcGdvZmYgKg0KPiA+IFBBR0VfU0laRSAgPSB2bWFfbWFwcGluZ19iYXNlKHZt
YV9hKSArIHN1YnBhZ2VfcGdvZmYgKiBQQUdFX1NJWkUNCj4gPQ0KPiA+IHZtYV9tYXBwaW5nX2Jh
c2Uocm9vdF92bWEpICsgc3VicGFnZV9wZ29mZiAqIFBBR0VfU0laRQ0KPiANCj4gT0sgYnV0IHlv
dSB3YW50IHRvIHdhbGsgZW50cmllcyBpbiBhIF9yYW5nZV8gaW4gdGhlIGludGVydmFsIHRyZWUu
DQo+IA0KPiBTbyB5b3UgYXJlIHRoZW4gbm93IGxvb2tpbmcgdXAgVk1BcyAoaW4gYSByYWNleSB3
YXkpIHVzaW5nIG1tX210ICh3aGljaA0KPiBpcyB0aGUgd2hvbGUgYmFzaXMgb2YgbXkgd29yayBh
Y3R1YWxseSkgd2hpY2ggY291bGQgY2hhbmdlIHVuZGVyIHlvdS4NCj4gDQo+IEkgZ3Vlc3Mgd2hh
dCB5b3UncmUgZG9pbmcgaXMgdXNpbmcgdGhlIHBpbm5lZCAncm9vdCcgVk1BIGFzIHRoZSBiYXNp
cyBvZg0KPiBldmVyeXRoaW5nLCBhbmQgdGhlIHNlY29uZCBhIFZNQSBpcyBtb3ZlZCB5b3UgKHNv
bWVob3cpIHdhbGsgdGhlIHBhZ2UNCj4gdGFibGVzIHRvIHVwZGF0ZSB0aGUgZm9saW8tPm1hcHBp
bmcuDQo+IA0KPiBBZ2FpbiBwaW5uaW5nIHRoZSBWTUEgbGlrZSB0aGlzIGFuZCBwdXR0aW5nIGl0
IGluIGEgZm9saW8gaXMgcmVhbGx5IG5vdCBzb21ldGhpbmcNCj4gd2Ugd2FudCB0byBkby4NCj4g
DQo+IEl0IGFkZHMgYSB0b24gb2YgY29tcGxleGl0eSBhbmQgYWxzbyBpbXBhY3RzIFZNQSBsaWZl
Y3ljbGUgd2hpY2ggaXMgYWxyZWFkeQ0KPiBmYWlybHkgZnJhdWdodC4NCj4gDQo+IEl0IG1ha2Vz
IHRoZSBWTUEgbm8gbG9uZ2VyIGp1c3QgYSBWTUEgYnV0IHJhdGhlciBhbHNvIGEgJ21lbW9yeScg
b2Ygd2hlcmUNCj4gc29tZXRoaW5nIHdhcyBmaXJzdCBmYXVsdGVkIGluIGFzIGEgaGFjayBtb3Jl
IG9yIGxlc3MuDQo+IA0KTWF5YmUgeW91J3JlIHJpZ2h0LiBtbS9tbV9tdC92bWEvcGFnZXRhYmxl
IGVhY2ggaGF2ZSB0aGVpciBvd24gcm9sZXMNCmluIGltcGxlbWVudGluZyBWTS4gUGVyaGFwcyBj
b25zaWRlcmluZyB0aGVtIHRvZ2V0aGVyIGNvdWxkIGxlYWQgdG8NCmJldHRlciBpZGVhcy4NCg==


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726D2CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18486B0093; Tue,  2 Jun 2026 22:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9D36B0095; Tue,  2 Jun 2026 22:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8F96B0096; Tue,  2 Jun 2026 22:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A979B6B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:59:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C8E91614C3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:59:13 +0000 (UTC)
X-FDA: 84837094986.05.B611148
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA9A6100009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:59:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zgEg6ywDLqG5YZyUNd1GBcVJdYTqa4VusEFsdn3J/0Q=;
	b=aC4Jp2fuEYucGWThS3WIx3DcIz7D/l3xVZV58OMzk/J7OuA9Rb6V77V/eYv1ljIE5qggB9
	7LXGhRC8/OdD1WruAy4HDPhngnUCQO/arNzxjQ8/bqH4uBmnPu5K+asG05eoSOKNKCM9Kx
	P9TV7TY9z8ru1nzDdnk4lyx7Ri9g02A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780455551;
	b=OT4DIXxUYf0fpY8l8tdqPurg4GB7kEdF5S8wQUpI062lq6EnN5WG+P+NyTOUh3gSFv1J1f
	p5F/X5RrPHqa+LaqpckT27amrMHuPW2aWwuI/vI06NvM7rhWaZ0xPY9PK5bp9EtXov0TWv
	y8aZ89JboO/U8620HY5/aS6GBQT6xHQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gVXRy6ycdzYtWwh;
	Wed,  3 Jun 2026 10:57:34 +0800 (CST)
Received: from TA004.hihonor.com (10.72.0.6) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 3 Jun
 2026 10:59:01 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA004.hihonor.com (10.72.0.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 3 Jun
 2026 10:59:04 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Wed, 3 Jun 2026 10:59:04 +0800
From: wangtao <tao.wangtao@honor.com>
To: Harry Yoo <harry@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
	"luizcap@redhat.com" <luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"riel@surriel.com" <riel@surriel.com>, "jannh@google.com" <jannh@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
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
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYq8jCAgAEtZwA=
Date: Wed, 3 Jun 2026 02:59:04 +0000
Message-ID: <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
In-Reply-To: <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA9A6100009
X-Stat-Signature: e78w58dq3hi5houuo447u61qu1mtbzck
X-HE-Tag: 1780455550-406556
X-HE-Meta: U2FsdGVkX1/WH28xC2+hl5msqzI01iuukNFphrQ5IAgEHZ69gworLd/Z6eEkkYpSrM2e31hcoT23APNbRblMjcZ/Xh5y6lqsNroC3Lt/F0j+MkGJz8jzc4gPBgwDzkY2rQwUhLwkY3Us7dFOLz0mxpQCjBvvA+oMMUKw0SUrMy5kTrncorCNUo8AjoDTLaMy6OxKnsk6qPhRj2pGkhqVndRR/il5X41n2LtUctPRjKtN5dXt6VX/KlbElGw1cJwLbdxXsFdlk9i0Z5N5RBZ6TTxzig5yGXz9606zb2aIsAd3LbYt5qDF3JFHFjcKZ1WH3gena5dqHMO6KQDVeEalBUDh3TAuDKXX4SxT4DOp1Rne9vh1seB55AB9vFNT+JUgN9qvrfEaSYT2fMRP3bybdOA/ESbDAfHiPQFw8yoUm7wxB51DyCwFEsXHkhBLXhDrzK3uQUmbRp8t7PBOhKh8MxFWsDJltpGf8Kh2ODcF3r+BGkr777PT5S/0Ou2sdafciD//SefAlmT6ULCDVM0eqpL7puRmEYuPAVDNXsGX1Nx6eNncbyWxio2BsbblsMFs++DdL7opn07ULSzi30zu+HS1PlOe+E7nc/SRS3qgxbF83ytUrhl0fRqegmjb3ufhXd2GcCBe5PeI1du8s0zwNceN4PK3RjKBDmQ/yTZY7HfE5AiEGI1wIAjuFtgssey2aPt60vOYJ2EFdU/SxKQiI4wTN5K1nciLC1eQrnghqwTyv8vn5c7UhBcungoFgzLI1JYBiHU+XeC6KaGRyjOH4OhlmOJPTChrsIweE68XG21SGn6CgBXzeCPjYXLtrX3AKm3289ahHZ4bYVjEM1b38s2SSTbpLY9pA3hB+Kbj1Vdo9YC9WG0R9Z7oOmEg7XCMfqJm1sU2PYuGP6csaS8Qx+2H+kjQJYOlYoAU89m4dlAr5KIWqskRB5y5THsYqhNQ1DNjQgb4OgbWeu02Oft
 Ykf656QM
 FQzHNdb5ykSL+goEpOJ+ppA/3fnxCEyqG5g9V6K3Q5p5TkIXdawpxRksbWjbUN3UX4KOo4CRCS9UIKh319wKTHx35LqE8d1MC28OagTgnuuVO3nqKWyiS9a9UatJMgigkqy4FMX2NKCd3x+9HG5aEeE1oz2xc264FeS/R4O67f7s5RKxsuWww7uuFCdjDis7pajTm0Trm5elOZWppx6S5dmTDqGHaGx1aqQaMS3dIghgxJm9MIK/BYyfRNmmvpYAeCs/vlTFOjYqa8OTU/QYNgGj1HXOtd3EBRkHnqjV3y8Jk9iCWdXKHmzGFznA6wX6SVBFMCS56LCH9ebCHUZ0eNGjY/6AK7bpY0ZWubdry/fzQo6rCmqYl3fI0y+300qgffnoR7K/4icqsAn2dCs4zgvnLbEbaczejtwoq9bpayw9VkBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiA1LzI3LzI2IDg6MDEgUE0sIHRhbyB3cm90ZToNCj4gPiBEZXNpZ24gb3ZlcnZpZXcNCj4g
PiAtLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IEFOT05fVk1BX0xBWlkgZGVmZXJzIGFub25fdm1h
IGFsbG9jYXRpb24gdW50aWwgaXQgaXMgYWN0dWFsbHkgbmVlZGVkDQo+ID4gKGZvciBleGFtcGxl
IGR1cmluZyBmb3JrKS4gVk1BcyB0aGF0IG5ldmVyIHBhcnRpY2lwYXRlIGluIHNoYXJpbmcgY2Fu
DQo+ID4gYXZvaWQgY3JlYXRpbmcgYW5vbl92bWEgc3RydWN0dXJlcyBlbnRpcmVseS4NCj4gPg0K
PiA+IEJlZm9yZSBhbiBhbm9uX3ZtYSBleGlzdHMsIHJtYXAgb3BlcmF0aW9ucyByZWx5IGRpcmVj
dGx5IG9uIFZNQQ0KPiA+IGluZm9ybWF0aW9uLCBzbyBubyBhbm9uX3ZtYSBsb2NraW5nIGlzIHJl
cXVpcmVkLiBBbiBhbm9uX3ZtYSBpcw0KPiA+IGNyZWF0ZWQgYW5kIGxpbmtlZCBvbmx5IHdoZW4g
c2hhcmluZyBzZW1hbnRpY3MgYXJlIHJlcXVpcmVkLg0KPiANCj4gSXQgaXMgdW5mb3J0dW5hdGUg
dGhhdCB0aGUgZGVzaWduIG92ZXJ2aWV3IGRvZXNuJ3QgY292ZXIgY29ycmVjdG5lc3MgYXNwZWN0
DQo+IGF0IGFsbC4gVk1BcyBhcmUgc3ViamVjdCB0byBjaGFuZ2UgKGV2ZW4gYmVmb3JlIGJlaW5n
IHNoYXJlZCB3aXRoIG90aGVyDQo+IHByb2Nlc3NlcyksIGFuZCBybWFwIG5lZWRzIHNvbWV0aGlu
ZyB0aGF0IGRvZXNuJ3QgZ28gYXdheSBhY3Jvc3MgVk1BDQo+IG1lcmdpbmcsIHNwbGl0LCBldGMu
DQo+IA0KPiBJJ20gbm90IHN1cmUgaG93IHRoZSBpZGVhIGlzIHN1cHBvc2VkIHdvcmsgY29ycmVj
dGx5Lg0KPiANCj4gLS0NCj4gQ2hlZXJzLA0KPiBIYXJyeSAvIEh5ZW9uZ2dvbg0KDQpWTUEgb3Bl
cmF0aW9ucyBjYW4gYmUgcm91Z2hseSBkaXZpZGVkIGludG8gdGhyZWUgY2F0ZWdvcmllcy4gVGhl
IGhhbmRsaW5nDQpvZiBBTk9OX1ZNQV9MQVpZIGlzIGJyaWVmbHkgZGVzY3JpYmVkIGJlbG93Lg0K
DQoxLiBmb3JrDQoNCmZvcmsgZHVwbGljYXRlcyB0aGUgcGFyZW50J3MgbW0vbW1hcC4gKGV4ZWMg
Y3JlYXRlcyBhIG5ldyBtbS9tbWFwIGFuZCBpcw0Kbm90IGludm9sdmVkIGhlcmUuKSBUaGlzIGNh
biBiZSB2aWV3ZWQgYXMgY29weWluZyB0aGUgVk1BcyB3aXRoIGlkZW50aWNhbA0KdmlydHVhbCBh
ZGRyZXNzZXMgaW50byBhIG5ldyBhZGRyZXNzIHNwYWNlLg0KDQpJZiB0aGUgcGFyZW50IFZNQSAo
cHZtYSkgaXMgQU5PTl9WTUFfTEFaWSwgaXQgaXMgZmlyc3QgdXBncmFkZWQgdG8gYQ0KcmVndWxh
ciBhbm9uX3ZtYS4gVGhlIGNvcnJlc3BvbmRpbmcgZm9saW8tPm1hcHBpbmcgaXMgdGhlbiBmaXhl
ZCBpbg0KdHJ5X2R1cF9hbm9uX3JtYXAoKS4NCg0KMi4gbW1hcCAvIGJyayAvIG1wcm90ZWN0IC8g
bXVubWFwDQoNClRoZXNlIG9wZXJhdGlvbnMgY3JlYXRlLCBtb2RpZnksIG9yIHJlbW92ZSBWTUFz
IGluIHRoZSBjdXJyZW50IG1tLiBUaGV5DQptYXkgc3BsaXQgZXhpc3RpbmcgVk1BcywgbWVyZ2Ug
YWRqYWNlbnQgVk1Bcywgb3IgcmVtb3ZlIGEgVk1BIGZyb20gbW1fbXQuDQoNCldoZW4gYSBuZXcg
Vk1BIGlzIGNyZWF0ZWQsIHZtX3N0YXJ0LCB2bV9lbmQgYW5kIHZtX3Bnb2ZmIGFyZSBpbml0aWFs
aXplZA0KYW5kIHRoZSBWTUEgaXMgaW5zZXJ0ZWQgaW50byBtbV9tdC4gQWx0aG91Z2ggdGhlc2Ug
ZmllbGRzIG1heSBsYXRlciBiZQ0KbW9kaWZpZWQsIHRoZSBmb2xsb3dpbmcgdmFsdWUgcmVtYWlu
cyBpbnZhcmlhbnQ6DQoNCih2bV9zdGFydCAtIHZtX3Bnb2ZmICogUEFHRV9TSVpFKQ0KDQpXZSBy
ZWZlciB0byB0aGlzIHZhbHVlIGFzOg0KDQp2bWFfbWFwcGluZ19iYXNlKHZtYSkgPSB2bWEtPnZt
X3N0YXJ0IC0gdm1hLT52bV9wZ29mZiAqIFBBR0VfU0laRQ0KDQpUaGlzIHZhbHVlIGFsc28gcmVt
YWlucyB1bmNoYW5nZWQgd2hlbiB0aGUgVk1BIGlzIHJlbW92ZWQgZnJvbSBtbV9tdC4NCg0KSWYg
YSBWTUEgaXMgc3BsaXQgYW5kIHByb2R1Y2VzIG5ld192bWEsIHRoZSBmb2xsb3dpbmcgaG9sZHM6
DQoNCnZtYV9tYXBwaW5nX2Jhc2UobmV3X3ZtYSkgPT0gdm1hX21hcHBpbmdfYmFzZSh2bWEpDQoN
CklmIHR3byBhZGphY2VudCBWTUFzIHZtYV9hIGFuZCB2bWFfYiBhcmUgbWVyZ2VkIGludG8gdm1h
X3gsIHRoZW46DQoNCnZtYV9tYXBwaW5nX2Jhc2Uodm1hX2EpID09IHZtYV9tYXBwaW5nX2Jhc2Uo
dm1hX2IpID09DQp2bWFfbWFwcGluZ19iYXNlKHZtYV94KQ0KDQpBc3N1bWUgdGhlIFZNQSB3aGVy
ZSB0aGUgZmlyc3QgcGFnZSBmYXVsdCBvY2N1cnMgaXMgY2FsbGVkIHJvb3Rfdm1hLCBhbmQNCmVu
c3VyZSB0aGF0IGFueSBWTUEgcHJvZHVjZWQgYnkgc3BsaXQgb3IgbWVyZ2UgaG9sZHMgYSByZWZl
cmVuY2UgdG8NCnJvb3Rfdm1hLg0KDQpEdXJpbmcgcm1hcCB3ZSBjYW4gY29tcHV0ZSB0aGUgZm9s
aW8gYWRkcmVzcyB1c2luZyByb290X3ZtYToNCg0Kdm1hX2FkZHJlc3Modm1hLCBwZ29mZiwgMSkg
PQ0KICAgIHZtYS0+dm1fc3RhcnQgKyAoKHBnb2ZmIC0gdm1hLT52bV9wZ29mZikgPDwgUEFHRV9T
SElGVCkNCiAgPSB2bWFfbWFwcGluZ19iYXNlKHZtYSkgKyBwZ29mZiAqIFBBR0VfU0laRQ0KICA9
IHZtYV9tYXBwaW5nX2Jhc2Uocm9vdF92bWEpICsgZm9saW9fcGdvZmYgKiBQQUdFX1NJWkUNCg0K
V2UgY2FuIHRoZW4gdXNlIGZvbGlvX2FkZHIgdG8gbG9jYXRlIHRoZSBWTUEgY292ZXJpbmcgdGhp
cyBmb2xpby4NCg0KMy4gbXJlbWFwIC8gdWZmZF9tb3ZlDQoNCklmIG9ubHkgdGhlIHNpemUgY2hh
bmdlcyBhbmQgdGhlIHN0YXJ0IGFkZHJlc3MgcmVtYWlucyB0aGUgc2FtZSwgdGhlcmUNCmlzIG5v
IGltcGFjdC4NCg0KSWYgdGhlIHN0YXJ0IGFkZHJlc3MgY2hhbmdlcywgdGhlIHBhZ2UgaXMgbW92
ZWQgZnJvbSAodm1hLCBhZGRyKSB0bw0KKG5ld192bWEsIG5ld19hZGRyKS4gSW4gdGhpcyBjYXNl
Og0KDQp2bWFfbWFwcGluZ19iYXNlKG5ld192bWEpID0NCiAgICB2bWFfbWFwcGluZ19iYXNlKHZt
YSkgKyBuZXdfYWRkciAtIG9sZF9hZGRyDQoNCldlIGZpcnN0IHVwZ3JhZGUgdGhlIFZNQSwgYW5k
IHRoZW4gZml4IGZvbGlvLT5tYXBwaW5nIGluIG1vdmVfcHRlcygpLg0KDQpJZiBwZXJmb3JtYW5j
ZSBiZWNvbWVzIGEgY29uY2VybiwgQU5PTl9WTUFfTEFaWSBjYW4gYmUgZW5hYmxlZCBvbmx5IGZv
cg0KcmVsYXRpdmVseSBzbWFsbCBWTUFzLg0KDQoNCnZtYeaTjeS9nOWPr+S7peWIhuS4ujPnsbvv
vIzkuIvpnaLnroDljZXor7TmmI7kuItBTk9OX1ZNQV9MQVpZ55qE5aSE55CG77yaDQoNCjEuIGZv
cmsg5LuO54i26L+b56iL5aSN5Yi2bW0vbW1hcO+8m++8iGV4ZXYg5Yib5bu65LiA5Liq5paw55qE
bW0vbW1hcO+8jOS4jea2ieWPiinjgIINCiDov5nlj6/ku6XnkIbop6PkuLrlnKjkuIDkuKrmlrDn
moTlnLDlnYDnqbrpl7TlpI3liLbkuIDku73nm7jlkIzlnLDlnYDnmoRWTUFzLg0KIOWmguaenHB2
bWHmmK9BTk9OX1ZNQV9MQVpZ77yM5YWI5Y2H57qn5Li6cmVndWxhciBhbm9uX3ZtYe+8jOW5tuWc
qHRyeV9kdXBfYW5vbl9ybWFw5Lit5Y2H57qn5L+u5q2jZm9saW8tPm1hcHBpbmcuDQogDQoyLiBt
bWFwL2Jyay9tcHJvdGVjdC9tdW5tYXAgDQog5Yib5bu644CB5L+u5pS55oiW5Yig6Zmk5b2T5YmN
bW3nmoRWTUHvvIzlj6/og73lkIjlubbmiJbmi4bliIblh7rmlrDnmoRWTUFz5oiW6ICF5bCGVk1B
5LuObW1fbXTliKDpmaTjgIINCiDliJvlu7rkuIDkuKrmlrDnmoR2bWHlubborr7nva52bV9zdGFy
dOOAgXZtX2VuZOOAgXZtX3Bnb2Zm5o+S5YWlbW1fbXTlkI7vvIzomb3nhLblkI7nu63lj6/og73k
v67mlLnov5nkuKpWTUHnmoR2bV9zdGFydOOAgXZtX2VuZOOAgXZtX3Bnb2Zm77yM5L2G5piv5L+d
5oyBDQogKHZtX3N0YXJ0IC0gdm1fcGdvZmYgKiBQQUdFX1NJWkUp5LiN5Y+Y77yM5oiR5Lus5Y+v
5Lul5oqK6L+Z5Liq56ew5LmL5Li6dm1hX21hcHBpbmdfYmFzZSh2bWEpID0gdm1hLT52bV9zdGFy
dCAtIHZtYS0+dm1fcGdvZmYgKiBQQUdFX1NJWkXjgIINCiDov5nkuKp2bWHku45tbV9tdOWIoOmZ
pOaXtu+8jHZtYV9tYXBwaW5nX2Jhc2Uodm1hKeS5n+S/neaMgeS4jeWPmOOAgg0KIOS7jui/meS4
qnZtYeaLhuWIhuWHuueahG5ld192bWHvvIzmnIl2bWFfbWFwcGluZ19iYXNlKG5ld192bWEpID09
IHZtYV9tYXBwaW5nX2Jhc2Uodm1hKQ0KIOWQiOW5tuebuOmCu3ZtYV9h44CBdm1hX2LkuLp2bWFf
eOaXtu+8jOS5n+aciXZtYV9tYXBwaW5nX2Jhc2Uodm1hX2EpID09IHZtYV9tYXBwaW5nX2Jhc2Uo
dm1hX2IpID09IHZtYV9tYXBwaW5nX2Jhc2Uodm1hX3gpDQog5aaC5p6c5oiR5Lus56ys5LiA5qyh
5Y+R55Sf57y66aG155qEVk1B56ew5Li6cm9vdF92bWHvvIzlubblnKhzcGxpdOaIlm1lcmdl5pe2
6YO956Gu5L+d5L2/55So55qEdm1h5oyB5pyJcm9vdF92bWHnmoTlvJXnlKjjgIINCiDlnKhybWFw
5pe25oiR5Lus5Y+v5Lul55Socm9vdF92bWHorqHnrpdmb2xpb+WcsOWdgO+8mg0KICAgdm1hX2Fk
ZHJlc3Modm1hLCBwZ29mZiwgMSkgPSB2bWEtPnZtX3N0YXJ0ICsgKChwZ29mZiAtIHZtYS0+dm1f
cGdvZmYpIDw8IFBBR0VfU0hJRlQpDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IHZt
YV9tYXBwaW5nX2Jhc2Uodm1hKSArIHBnb2ZmICogUEFHRV9TSVpFDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICA9IHZtYV9tYXBwaW5nX2Jhc2Uocm9vdF92bWEpICsgZm9saW9fcGdvZmYg
KiBQQUdFX1NJWkUNCiDnhLblkI7nlKhmb2xpb19hZGRy5p+l5om+Zm9saW/miYDlnKjnmoR2bWHj
gIINCiAgDQozLiBtcmVtYXAvdWZmZF9tb3ZlIA0KICDlpoLmnpzlj6rmmK/kv67mlLnlpKflsI/v
vIzotbflp4vlnLDlnYDkuI3lj5jvvIzkuI3lvbHlk43jgIINCiAg5aaC5p6c5pS55Y+Y6LW35aeL
5Zyw5Z2A77yM5bCGcGFnZeS7jnZtYS9hZGRy56e75Yqo5YiwbmV3X3ZtYS9uZXdfYWRkcg0KICDo
v5nml7Z2bWFfbWFwcGluZ19iYXNlKG5ld192bWEpID0gdm1hX21hcHBpbmdfYmFzZSh2bWEpICsg
bmV3X2FkZHIgLSBvbGRfYWRkcg0KICDmiJHku6zlhYjljYfnuqd2bWHvvIzlnKhtb3ZlX3B0ZXPk
uK3lho3kv67mraNmb2xpby0+bWFwcGluZ+OAgiAgDQogIOWmguaenOaLheW/g+aAp+iDveW9seWT
je+8jOWPr+S7peWPquWcqOi+g+Wwj+eahHZtYeS4iuS9v+iDvUFOT05fVk1BX0xBWlnjgIINCg0K


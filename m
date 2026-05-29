Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33B5CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A416B0092; Fri, 29 May 2026 05:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C146B0095; Fri, 29 May 2026 05:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C8D6B0096; Fri, 29 May 2026 05:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDC136B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:41:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DDD040DCB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:41:30 +0000 (UTC)
X-FDA: 84819964740.01.AAE8434
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF1E1180004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:41:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780047688; a=rsa-sha256;
	cv=none;
	b=KaiXO3M0tUz2vQTTQNvAYm8h6ZMl07+Xl+BATSLEfAjaR82oJgBIepmt9krZZLFUuQsqfN
	3TMwQtqX39v7ff2RwYC1SjE8LhCpEqScJkSH1u95wPXVAtlDmF/GZA7OiMw7dp/w92Y8K0
	Kzrog84RL4TNJxfNWwrUDhsuI73KUTI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780047688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nA5jVqkC4SgZmrSufFh/WWg241xgTmVuGCoXawjTA7E=;
	b=L9mng9up/OyESnicAALYiHfNhXYsGIc6c9kbjWN80XE2dV0Vj64uI/H1qMO7VhOeyNTYuU
	I6ObwIQTBxg8oUeKtMv5stkjJ360dkSvu2qQ5df+EGdDM7Qo7JCPderOx3CEyZNbsThDB6
	InX2sSD712GzQlhfBui5yZV8XkeP0io=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gRdcV1YnbzYqZW5;
	Fri, 29 May 2026 17:39:54 +0800 (CST)
Received: from TA004.hihonor.com (10.72.0.6) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 29 May
 2026 17:41:21 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA004.hihonor.com (10.72.0.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Fri, 29 May
 2026 17:41:21 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Fri, 29 May 2026 17:41:21 +0800
From: wangtao <tao.wangtao@honor.com>
To: Barry Song <baohua@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
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
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn"
	<xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com"
	<dvander@google.com>, zhangji <zhangji1@honor.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYhaeaAgAGnM1D//4FNAIABAA8AgAEgmrA=
Date: Fri, 29 May 2026 09:41:20 +0000
Message-ID: <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: CF1E1180004
X-Rspamd-Server: rspam03
X-Stat-Signature: 9pz6dq1br5bxjjw5ysya6gxmrmmczwkq
X-HE-Tag: 1780047687-343903
X-HE-Meta: U2FsdGVkX1+5cHPbUtbrdBxgrqbu8Yz030DfatqLidec5UxJfCkg0NCT5UeInCC4ia3dhq1RhOAAwY2/EqjF3IeqHgThscQIAcqNur+Ri7kP8AIizCy93bb905nOlHeJaeQamxqPlDJeXJUF7n5cf6u32cG1GNr8VUXUw0oMWOWFrtSnm8yngivVTPO19/Hgj3dV9+W6O0QGyvhyEpESa8QRBKX2tP4XsV8pX8E8Bqc4muM6y9ksKaBjq4eaFwTSiHJ/MKTpXAjfgWnYD0cqb/QPcj4GGpaPYcTa34ijVqswb8Cm8Pb9ocE3OZ1GPUYqLHd7WeN8Lbq42CpYvEuRvk5jXQz/4wz2sUnB60gtICxVhfBypPKbL57V558Ay1Go0xHWRus3GdTCWC6QkWHJNr44JHDWFtpZ19iQRgjg9aEF/0HS5rI2OhPTg7E0fae2LKpuSxsvwrZnFxqegdFC8Nq+M1ZiBzIjv4S1AYsE54Hx0+iiKRpkud4rQjGWK5NMe9DuwAH5//qbxxXMOtZghOBGH+uJdBPLnzScewLkCzH67PeNdVQqJ6uDEn288WpDOWpKSRtjB21A4mfPn8Xb0V2pus3slp91pu3NhGJ9Sxv/Nyt/sgir8DqHdCGyYxo9wRL7LPbNZO10gWBb7/wYlTo96GxjgD2sTGfxHZqhxC+vzccT46hVzWSs5EIZIKUCvdeuKXQE+Hkup/RjZ4Sry/JyILvyTcnqeCaLNqppd5foVJBmzbvC2nZQMHdS7ZZgtUbslUC4hDUipaVC7x/RpzS5G/5f1TYubXrQ4s2+CKI7VbBEu48rIZ7B2aKHOwyNkzRw4wj5pTZ9N+Sx66o5POS/+Iay2px/pK5y/cKk3PTtZiYZjeDP6ZqgrZOF4LX1vq1gEMFS3YAMVxvns2gLZFopkOjlNu/0w9LMnwu9XQtnwXYnlp0UjRc19Wmi3XX4skVwAFOBfMhXLUbLvYg
 bylskw4U
 m8hVBCxV4WedAdKA9bje3ztL3OwfiCkZOTBSvBIuFpdExtMVBhQA8bcpj4bqw5Fm27NQvVI1Kckq3KFlRvVQePBmEdNienfk2j7vBHrYRxbAXmPAyKJjnKy6J3tbzY6vKbzWYVSFh3jLvqOTWTxQHyJHeeLgwgK/UfAntndwgU5vvKtIBgD6joZkTK9/tBkX3lAynhEJYwh071s5K1Xeajd5R3V+H0hQmdrOqxTC1FcrWCbbIMHQ3SwlvWKQgSOmlh1IZCSQd4jMa1ErJURnu8Ztf71FmgQn6ouBDsIDXupsTQt48H2nPPVSSpzYltMO0eHulw7w2bupZqR3Vn2VJZFT6COOzYjQCZq/2vTpAE29kMz6uW8CXL+NqUVRHagwbrjgEjzSozs+LXW3j2TbTiRIu+dnZJMZTV68IPSBSJhE8fURz345gQUMyM916I0eASmtKAfBs3SjahBbWnGLtBXv93Zej071mtolx7gBSMMb70kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+IE9uIFRodSwgTWF5IDI4LCAyMDI2IGF0IDA3OjU3OjMxQU0gKzAwMDAsIHdhbmd0YW8gd3Jv
dGU6DQo+ID4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMC8xNV0gbW06IGludHJvZHVjZSBBTk9O
X1ZNQV9MQVpZIGZvcg0KPiBkZWZlcnJlZA0KPiA+ID4gPiBhbm9uX3ZtYSBjcmVhdGlvbg0KPiA+
ID4gPg0KPiA+ID4gPiBPSyBJJ3ZlIGhhZCBhIGxvb2sgdGhyb3VnaCBtb3JlIHRob3JvdWdobHkg
bm93IGFuZDoNCj4gPiA+ID4NCj4gPiA+ID4gTkFLIGFuZCBOQUsgYW55IGFwcHJvYWNoIGxpa2Ug
dGhpcy4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gTm90IG9ubHkgaXMgdGhpcyBzdHJ1Y3R1
cmFsbHkgYWxsIHdyb25nLCBpdCBkb2VzIHNvbWUgaW5zYW5lIHN0dWZmDQo+ID4gPiA+IChwaW5u
aW5nIFZNQXMgLSBubyksIHRoZSBSQ1UgdXNhZ2UgaXMgaGlnaGx5IGR1YmlvdXMgYW5kIEkgc3Vz
cGVjdA0KPiA+ID4gPiB5b3UndmUgY29tcGxldGVseSBicm9rZW4gdGhlIGFub24gcm1hcCBmb3Ig
dGhpbmdzIGxpa2UgbWlncmF0aW9uLA0KPiA+ID4gPiBvciBoYXZlIGF0IGxlYXN0IGFkZGVkIHZl
cnkgZHViaW91cyBlZGdlIGNhc2VzLg0KPiA+ID4gPg0KPiA+ID4gPiBZb3UndmUgYWRkZWQgaW5z
YW5lIGNvbXBsZXhpdHksIGFuZCBhbHNvIGhhdmUgZmFpbGVkIHRvIGFkZCBldmVuDQo+ID4gPiA+
IHBlcmZ1bmN0b3J5IHRlc3RzLCB3aGljaCBpcyBhbHNvIHRvdGFsbHkgdW5hY2NlcHRhYmxlLg0K
PiA+ID4gPg0KPiA+ID4gPiBUaGUgaW1wbGVtZW50YXRpb24gaXMgd3JvbmcsIGFuZCB0aGUgYXBw
cm9hY2ggaXMgd3JvbmcgLSB3ZSBkbyBub3QNCj4gPiA+ID4gd2FudCB0byBleHRlbmQgb3IgYnVp
bGQgb24gYW5vbl92bWEuIFNvIHRoaXMgaXMgdW5tZXJnZWFibGUsIG9yIGFueQ0KPiBhcHByb2Fj
aCBsaWtlIGl0Lg0KPiA+ID4gPg0KPiA+ID4gPiBJIGFsc28sIHVuZm9ydHVuYXRlbHksIHN0cm9u
Z2x5IHN1c3BlY3QgQUkgaGVyZS4gVGhlIHR1cm4gb2YNCj4gPiA+ID4gcGhyYXNlLCBhbmQgcG9v
ciBjb21taXQgbWVzc2FnZXMsIHlvdSBkb2luZyB0aGlzIG91dCBvZiBub3doZXJlDQo+ID4gPiA+
IHdpdGggYWJzb2x1dGVseSBubyBybWFwIGV4cGVyaWVuY2UgYmVmb3JlLCB5b3VyIHRvdGFsIGxh
Y2sgb2YNCj4gY29tbXVuaWNhdGlvbiBiZWZvcmUuDQo+ID4gPiA+DQo+ID4gPiA+IENsYXVkZSBw
dXRzIHRoZSBwcm9iYWJpbGl0eSBvZiBoZWF2eSBBSSB1c2FnZSBhdCA4NS05MCUsIGFuZCBJJ20N
Cj4gPiA+ID4gcHJldHR5IGNvbnZpbmNlZC4gRWl0aGVyIHdheSBpdCdzIHV0dGVybHkgdW5tZXJn
ZWFibGUgYnV0IHRoYXQgeW91DQo+ID4gPiA+IChsaWtlbHkpIHVzZWQgQUkgdG8gZ2VuZXJhdGUg
dGhpcyBtdWNoIHdvcmsgZm9yIHVzIG1ha2VzIG1lIGFjdHVhbGx5DQo+IHByZXR0eSBhbm5veWVk
Lg0KPiA+ID4gPg0KPiA+ID4gPiBBcyBhIHJlc3VsdCwgSSB3b3VsZCBzdHJvbmdseSBzdWdnZXN0
IHlvdSBubyBsb25nZXIgc3VibWl0IHBhdGNoZXMNCj4gPiA+ID4gZm9yIHRoZSByZXZlcnNlIG1h
cHBpbmcgcGFydCBvZiBtbSwgYXMgdGhlcmUgaXMgbm93IGEgcmVhbCBsYWNrIG9mIHRydXN0Lg0K
PiA+ID4gPg0KPiA+ID4gPiBJZiB5b3Ugd2lzaCB0byByZWJ1aWxkIHRoYXQsIEkgc3VnZ2VzdCB5
b3UgX2Rpc2N1c3NfIGNvbmNlcHRzIGFuZCBpZGVhcywNCj4gZS5nLg0KPiA+ID4gPiBzZW5kIHN0
dWZmIG9uLWxpc3Qgd2l0aCBhIFtESVNDVVNTSU9OXSB0YWcsIGFuZCBlbmdhZ2Ugd2l0aCB0aGUN
Cj4gPiA+ID4gY29tbXVuaXR5LCBhbmQgZ28gZnJvbSB0aGVyZS4NCj4gPiA+ID4NCj4gPiA+ID4g
SXQncyBhbHNvIGltcG9ydGFudCB0byBzeW5jaHJvbmlzZSAtIEknbSB3b3JraW5nIG9uIGFuIGFu
b24gcm1hcA0KPiA+ID4gPiByZXBsYWNlbWVudCB0aGF0IEknbSBtb3JlIHRoYW4gaGFwcHkgdG8g
ZGlzY3VzcyB3aXRoIHlvdSBvcg0KPiA+ID4gPiBhbnlib2R5IGVsc2Ugd2hpY2ggc2hvdWxkIGFj
aGlldmUgdGhlIHNhbWUgbnVtYmVycyBpbiBhbg0KPiBhcmNoaXRlY3R1cmFsbHkgc291bmQgd2F5
Lg0KPiA+ID4gPg0KPiA+ID4gPiBZb3UgZ29pbmcgb2ZmIGFuZCwgaW4gYSB2YWN1dW0sIGdlbmVy
YXRpbmcgYSBidW5jaCBvZiBjb2RlIHdpdGggYW4NCj4gPiA+ID4gdW5hY2NlcHRhYmxlIGFwcHJv
YWNoIGlzIG5vdCBhIGNpdmlsIHdheSBvZiBlbmdhZ2luZyBub3IgaXMgaXQgYQ0KPiA+ID4gPiBn
b29kIHVzZSBvZiB5b3VyIHRpbWUsIG9yIG1haW50YWluZXIgdGltZSBsb29raW5nIGF0IGl0Lg0K
PiA+ID4gPg0KPiA+ID4gPiBUaGFua3MsIExvcmVuem8NCj4gPiA+DQo+ID4gPiBZb3VyIGVtYWls
IGlzIHZlcnkgdW5mcmllbmRseS4gSSBob3BlIHlvdSBjYW4gcG9pbnQgb3V0IHRoZSBzcGVjaWZp
Yw0KPiA+ID4gcHJvYmxlbXMgc28gd2UgY2FuIGRpc2N1c3MgaG93IHRvIHNvbHZlIHRoZW0uDQo+
IA0KPiBIaSBUYW8sDQo+IA0KPiBMb3JlbnpvIGhhZCBhIGRpc2N1c3Npb24gYWJvdXQgcm1hcCBp
biBaYWdyZWIgaGVyZToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vYWVjNTMz
YjItMzdhNy00ZjQ0LWEyNzktDQo+IGM0YWE2MDQyMDZhY0BsdWNpZmVyLmxvY2FsLw0KPiANCj4g
SGUgYWxzbyBzaGFyZWQgdGhlIFBvQyBjb2RlIGhlcmU6DQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xqcy9saW51eC5naXQvbG9nLz9oPXByb2plY3Qv
DQo+IGNvdy1jb250ZXh0DQo+IA0KPiBhbmQgdGhlIHNsaWRlcyB3ZXJlIHNoYXJlZCBhcyB3ZWxs
LiBJbiBjYXNlIHlvdSBjYW4ndCBmaW5kIHRoZW0gb24gbGludXgtbW0gKEkNCj4gYWN0dWFsbHkg
Y291bGRuJ3QgZmluZCB0aGVtIG15c2VsZiksIEkgYW0gYXR0YWNoaW5nIHRoZW0gYWdhaW4gaGVy
ZSAtDQo+ICJzY2FsYWJsZS1jb3ctbHNmLWxvbmdlci12ZXJzaW9uLnBkZiINCj4gDQo+IEFmdGVy
IGNvbWluZyBiYWNrIGZyb20gWmFncmViLCBJIGtlcHQgdHJ5aW5nIHRvIGZpbmQgb25lIG9yIHR3
byBmdWxsIGRheXMgdG8NCj4gcmVhZCBMb3JlbnpvJ3MgY29kZSBhbmQgc2xpZGVzIGNhcmVmdWxs
eSBhbmQgd3JpdGUgYSBibG9nIGFib3V0IHRoZW0uDQo+IFVuZm9ydHVuYXRlbHksIEkgaGF2ZSBi
ZWVuIGNvbXBsZXRlbHkgYnVzeSB3aXRoIG90aGVyIHdvcmsuIFNpZ2guLi4gd2UNCj4gYWx3YXlz
IHNlZW0gdG8gaGF2ZSB0b28gbWFueSBub24tdXBzdHJlYW0gdGFza3MuDQo+IA0KPiBJZiBwb3Nz
aWJsZSwgSSdkIHJlYWxseSBhcHByZWNpYXRlIGl0IGlmIHlvdSBjb3VsZCB0YWtlIGEgZGVlcCBk
aXZlIGludG8gaXQgYW5kDQo+IHdyaXRlIGEgZGV0YWlsZWQgYmxvZyBwb3N0LiBJJ2QgYmUgdmVy
eSBlYWdlciB0byByZWFkIGl0IGFuZCBiZXR0ZXIgdW5kZXJzdGFuZA0KPiB0aGUgb3ZlcmFsbCBk
ZXNpZ24uDQo+IE90aGVyd2lzZSwgSSdsbCB0cnkgdG8gZmluZCBzb21lIHRpbWUgbmV4dCB3ZWVr
IG9yIGxhdGVyIHRvIGdvIHRocm91Z2ggaXQNCj4gbXlzZWxmLg0KPiANCkhpIEJhcnJ5LA0KDQpU
aGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIHJlcGx5Lg0KDQpJIHRvb2sgYW4gaW5pdGlhbCBs
b29rIGF0IHRoZSBjb3ctY29udGV4dCBjb2RlLCBhbmQgYSBmZXcgcG9pbnRzICANCm1pZ2h0IGJl
IHdvcnRoIG5vdGluZzoNCg0KMS4gY293X2NvbnRleHRfd2FsayBjdXJyZW50bHkgYXNzdW1lcyB0
aGF0IHRoZSBybWFwIHdhbGsgcnVucyAgDQogICB1bmRlciBSQ1UgcHJvdGVjdGlvbi4gVGhpcyBt
YXkgbmVlZCB0byBiZSBhZGp1c3RlZCBlYXJseSwgIA0KICAgc2luY2UgcGF0aHMgc3VjaCBhcyB0
cnlfdG9fdW5tYXBfb25lLCBwYWdlX3ZtYV9ta2NsZWFuX29uZSwgIA0KICAgYW5kIHRyeV90b19t
aWdyYXRlX29uZSBtYXkgaW52b2x2ZSB0YXNrIHN3aXRjaGluZy4NCg0KMi4gSW4gY293X2NvbnRl
eHRfd2FsaywgdHJhdmVyc2VfY29udGV4dHMgYXBwZWFycyB0byBpbnZvbHZlICANCiAgIG11bHRp
cGxlIG5lc3RlZCBsb29wcy4gV2hlbiB0aGVyZSBhcmUgbWFueSBjaGlsZCBwcm9jZXNzZXMgIA0K
ICAgYWNyb3NzIHNldmVyYWwgZm9yayBsYXllcnMsIGl0IG1heSBub3QgYmUgYXMgc2ltcGxlIG9y
ICANCiAgIGVmZmljaWVudCBhcyB0aGUgY3VycmVudCBhbm9uX3ZtYSBhcHByb2FjaC4NCg0KICAg
SXQgbmVlZHMgdG8gdHJhdmVyc2UgYWxsIGNoaWxkIGNvd19jdHgsIGFuZCB3aXRoaW4gZWFjaCAg
DQogICBjb3dfY3R4LCByZW1hcHNfZm9yX2VhY2goKSBoYXMgdHdvIGxldmVscyBvZiBpdGVyYXRp
b246ICANCiAgIHJlbWFwc19mb3JfZWFjaF9lbnRyeSBhbmQgcmVtYXBzX2Zvcl9lYWNoX2VudHJ5
X29mZnNldC4NCg0KICAgSW4gb3RoZXIgd29yZHMsIGl0IGZpcnN0IGl0ZXJhdGVzIG92ZXIgY293
X2N0eCBhbmQgdGhlbiAgDQogICB0cmF2ZXJzZXMgcm1hcF9tdCBpbnNpZGUgZWFjaCBvbmUuIFRo
ZSByb3VnaCBjb21wbGV4aXR5ICANCiAgIHNlZW1zIHRvIGJlIE8oI3Byb2MgKiBsb2coI3JtYXBf
ZW50cmllc19pbl9jb3cpKSwgd2hpY2ggIA0KICAgbWF5IGJlIHNvbWV3aGF0IGhpZ2hlciB0aGFu
IGFub25fdm1hJ3MgIA0KICAgTygjdm1hc19pbl9hbm9uX3ZtYSkuIEhvd2V2ZXIsIGluIG1vc3Qg
Y2FzZXMgdGhlIG51bWJlciAgDQogICBvZiBwcm9jZXNzZXMgaXMgbm90IGxhcmdlLCBzbyB0aGUg
aW1wYWN0IG1heSBiZSBsaW1pdGVkLg0KDQpQcmV2aW91c2x5LCBJIGFsc28gY29uc2lkZXJlZCBj
b252ZXJ0aW5nIGFub25fdm1hJ3MgcmJfdHJlZSAgDQp0byBhIG1hcGxldHJlZS4gSWYgb25lIGVu
dHJ5IHJlY29yZHMgYSBzaW5nbGUgVk1BLCB0aGUgIA0KYXZlcmFnZSBvdmVyaGVhZCBjb3VsZCBi
ZSBsZXNzIHRoYW4gdHdvIGxvbmdzIHBlciBWTUEuDQoNCkhvd2V2ZXIsIHVubGlrZSByYl90cmVl
LCBtYXBsZXRyZWUgZG9lcyBub3Qgc3VwcG9ydCBzdG9yaW5nICANCm11bHRpcGxlIGVsZW1lbnRz
IHVuZGVyIGEgc2luZ2xlIGtleS4gVGhlIGtleSB3b3VsZCBuZWVkIHRvICANCmxvb2sgbGlrZSAo
dm1hX2lkL21tX2lkICsgcGdvZmYpLiBPbiAzMi1iaXQgcGxhdGZvcm1zLCBzaW5jZSAgDQo2NC1i
aXQgbWFwbGV0cmVlIGtleXMgYXJlIG5vdCBzdXBwb3J0ZWQgeWV0LCB0aGUgcmVtYWluaW5nICAN
CjEyIGJpdHMgYXJlIG5vdCBlbm91Z2ggZm9yIHZtYV9pZC9tbV9pZC4NCg0KQmVjYXVzZSBvZiB0
aGlzIGxpbWl0YXRpb24sIEkgbGF0ZXIgc3RhcnRlZCB0aGlua2luZyBhYm91dCAgDQp3YXlzIHRv
IHJlZHVjZSBhbm9uX3ZtYSBhbGxvY2F0aW9ucyBpbnN0ZWFkLg0KDQpJIHdpbGwgdHJ5IHRvIGZp
bmQgc29tZSB0aW1lIG5leHQgd2VlayB0byBhbmFseXplIHRoZSAgDQpjb3ctY29udGV4dCBkZXNp
Z24gYW5kIGNvZGUgbW9yZSB0aG9yb3VnaGx5LCBhbmQgdGhlbiAgDQp3cml0ZSB1cCBhIHN1bW1h
cnkuDQoNClRoYW5rcywNClRhbw0KDQo+ID4NCj4gPiBJIGFscmVhZHkgZGlkLCB5b3UndmUgbm90
IHJlc3BvbmRlZCB0byBhbnkgb2YgdGhlbSwgYW5kIEknbSBzaW1wbHkgbm90DQo+ID4gc3BlbmRp
bmcgYW55IG1vcmUgdGltZSBvbiB0aGlzLg0KPiA+DQo+ID4gVGhlIHNlcmllcyBpcyB0b3RhbGx5
IHVubWVyZ2VhYmxlLCBwbGVhc2UgZG8gbm90IG1ha2UgZnVydGhlciBybWFwDQo+ID4gc3VibWlz
c2lvbnMuDQo+ID4NCj4gPiA+DQo+ID4gPiBJIGFtIG5vdCBnb29kIGF0IEVuZ2xpc2ggYW5kIG5l
ZWQgdG8gdXNlIEFJIHRvIHRyYW5zbGF0ZSBjb21taXQNCj4gPiA+IG1lc3NhZ2VzIGFuZCBjb21t
ZW50cy4gVGhpcyByZXBseSBlbWFpbCBpcyBhbHNvIHRyYW5zbGF0ZWQgd2l0aCBBSS4NCj4gPiA+
IEhvd2V2ZXIsIHRoZSBjb2RlIGlzIHdyaXR0ZW4gYnkgbWUuIEkgZG8gbm90IGtub3cgd2hpY2gg
QUkgeW91IGFyZQ0KPiA+ID4gcmVmZXJyaW5nIHRvLCBidXQgdGhlIEFJIHRvb2xzIEkgdXNlIGN1
cnJlbnRseSBjYW5ub3QgZWZmZWN0aXZlbHkNCj4gPiA+IHdyaXRlIGtlcm5lbCBjb2RlLg0KPiA+
ID4NCj4gPg0KPiA+IFdlJ3JlIGZpbmUgd2l0aCB1c2luZyBBSSBmb3IgbGFuZ3VhZ2UsIG9yIGlu
IGdlbmVyYWwgYXMgbG9uZyBhcw0KPiA+IHRoZXJlJ3MgYSBjbGVhciB1bmRlcnN0YW5kaW5nIG9m
IHdoYXQncyBiZWluZyBzdWJtaXR0ZWQuDQo+ID4NCj4gPiBIb3dldmVyIEknbSB2ZXJ5IHVuY29u
dmluY2VkIHRoYXQgdGhpcyBzZXJpZXMgd2Fzbid0IGdlbmVyYXRlZC4NCj4gPg0KPiA+IFlvdSBo
YXZlIDIgcGF0Y2hlcyBpbiB0aGUga2VybmVsIGZvciB0aGUgZW50aXJldHkgb2YgMjAyNi4gT25l
IGluDQo+ID4gYmx1ZXRvb3RoIGFuZCBvbmUgaW4gdGhlIHNjaGVkdWxlci4NCj4gPg0KPiA+IFBy
aW9yIHRvIHRoYXQgeW91IGhhdmUgcGF0Y2hlcyBmcm9tIDIwMTggaW4gZGV2aWNlIHRyZWUgZHJp
dmVycy4NCj4gPg0KPiA+IFlvdSBoYXZlIGV4YWN0bHkgMCBjb250cmlidXRpb25zIHRvIG1tLg0K
PiA+DQo+ID4gT3V0IG9mIG5vd2hlcmUgdGhpcyB5ZWFyIHlvdSBoYXZlIGEgYmlnIHNlcmllcyBm
b3IgRE1BLCB0aGlzIHNlcmllcw0KPiA+IGZvciBhbm9uX3ZtYSwgaGF2aW5nIGRvbmUgbm8gd29y
ayBvciBhbnkgY29udHJpYnV0aW9ucyB0byBybWFwLCBsZXQNCj4gPiBhbG9uZSBvbmUgb2YgdGhl
IHRyaWNraWVzdCBhbmQgbW9zdCBjb21wbGljYXRlZCBhcmVhcyBvZiBtbS4NCj4gPg0KPiA+IFlv
dSBoYXZlIGEgdG90YWwgb2YgMzkgbWFpbHMgb24gdGhlIGxpbnV4LW1tIG1haWxpbmcgbGlzdC4N
Cj4gPg0KPiA+IFN1ZGRlbmx5IGRvaW5nIGEgZ2lhbnQgYml0IG9mIHdvcmsgbGlrZSB0aGlzIHVz
aW5nIGNvZGUgdGhhdCBsb29rcw0KPiA+IGVudGlyZWx5IGxpa2UgaXQncyBBSS1nZW5lcmF0ZWQs
IGFuZCB3aGljaCBhZnRlciBhc3Nlc3NtZW50IGJ5IEFJDQo+ID4gZ2l2ZXMgYW4gODUtOTAlIHBy
b2JhYmlsaXR5IG9mIEFJIGdlbmVyYXRpb24gaXMgcmVhbGx5IHN1c3BpY2lvdXMuDQo+ID4NCj4g
PiBOb3csIGlmIEknbSBtaXN0YWtlbiwgYW5kIHlvdSBoYXZlIGEgZGlmZmVyZW50IG5hbWUvZW1h
aWwvaWRlbnRpdHkgSQ0KPiA+IG1pc3NlZCB3aXRoIG1hbnkgbW0gY29udHJpYnV0ZXMgLSBJIHdp
bGwgZWF0IG15IHdvcmRzIGhlcmUgKHRoZSBzZXJpZXMNCj4gPiBpcyBzdGlsbCB1bm1lcmdlYWJs
ZSBlaXRoZXIgd2F5IHRob3VnaCkuDQo+ID4NCj4gPiBTbyBzb3JyeSwgdGhlcmUncyBzaW1wbHkg
bm8gdHJ1c3QgYW5kIGFzIGEgbWFpbnRhaW5lciBvZiBybWFwIGFnYWluIEkNCj4gPiBtdXN0IHN0
cm9uZ2x5IHN1Z2dlc3QgdGhhdCB5b3Ugbm8gbG9uZ2VyIHN1Ym1pdCBwYXRjaGVzIGZvciB0aGlz
IHBhcnQNCj4gPiBvZiB0aGUga2VybmVsLg0KPiA+DQo+ID4gSWYgeW91IHdpc2ggdG8gYnVpbGQg
dHJ1c3QgdXAgYWdhaW4sIGJlZ2luIHdpdGggZGlzY3Vzc2lvbnMsIGFuZCBtYXliZQ0KPiA+IHRy
eSBzb21lIHNtYWxsZXIgcGF0Y2hlcyBpbiBtbSB0byBkZW1vbnN0cmF0ZSB0aGF0IHlvdSdyZSBn
ZW51aW5lbHkNCj4gPiBhY3RpbmcgaW4gZ29vZCBmYWl0aD8NCj4gDQo+IEhpIExvcmVuem8sDQo+
IA0KPiBJIHRydWx5IGJlbGlldmUgVGFvIGlzIGFjdGluZyB3aXRoIGdvb2QgaW50ZW50aW9ucywg
YWx0aG91Z2ggdGhlIHdheSB0aGlzIGlzDQo+IGJlaW5nIGRvbmUgaXMgcXVpdGUgbWVzc3kuDQo+
IA0KPiBNZW1vcnkgY29zdHMgYXJlIGluY3JlYXNpbmcgc2lnbmlmaWNhbnRseSB0aGVzZSBkYXlz
LCBhbmQgYXMgSSB1bmRlcnN0YW5kIHRoZQ0KPiBwYXRjaHNldCwgaGUgaXMgdHJ5aW5nIHRvIHNh
dmUgbWVtb3J5Lg0KPiANCj4gSG93ZXZlciwgSSBkb24ndCB0aGluayB0aGlzIGlzIGJlaW5nIGRv
bmUgYXQgdGhlIHJpZ2h0IHRpbWUgb3IgaW4gdGhlIHJpZ2h0IHdheS4NCj4gVGhpcyBtYXkgYWxz
byBiZSBkdWUgdG8gY3VsdHVyYWwgZGlmZmVyZW5jZXMsIGxhbmd1YWdlIGJhcnJpZXJzLCBpbmZv
cm1hdGlvbg0KPiBnYXBzLCBhbmQgYSBsYWNrIG9mIGZhbWlsaWFyaXR5IHdpdGggdGhlIG1tIGNv
bW11bml0eS4NCj4gQXMgYSBub24tbmF0aXZlIHNwZWFrZXIsIEkgY2FuIHNlZSBob3cgZGlmZmlj
dWx0IHRoaXMgY2FuIHNvbWV0aW1lcyBiZS4NCj4gDQo+IEkgd291bGQgcmVhbGx5IGFzayB5b3Ug
dG8gZ2l2ZSBUYW8gbW9yZSBjaGFuY2VzIHRvIGJ1aWxkIHRydXN0IHN0ZXAgYnkgc3RlcC4NCj4g
DQo+IEJlc3QgUmVnYXJkcw0KPiBCYXJyeQ0K


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E60FCD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7124A6B0088; Tue,  2 Jun 2026 23:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2AB6B008A; Tue,  2 Jun 2026 23:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B26A6B0093; Tue,  2 Jun 2026 23:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46C626B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:13:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5CC91C0A3E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:13:00 +0000 (UTC)
X-FDA: 84837129720.24.E305D80
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A6FD4000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:12:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780456379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELAckSMkwRGZ6DfjbRItAGTsXXdLZQbzq00xTtjjcNs=;
	b=ueBzRBh1D9etclNv+7mWuIQOU+eDK1Mqo++XtkZFzLASHCyN40M5kagKwfC1xaUSSirV9C
	lxbt6DzZOBhZqgXrPfBp+Hr2AmWxXCOq0PlG9zT4Z0c+Gxs+EW6rVvxKQ74joV1+KlOq7t
	ymDpuAmYA09lukxfZ37TbkTqB9PK1Fg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780456379;
	b=uRWxAZoRVRY8B1eAcbHaw9XBeGzO+aMzIojLsqkbkiwjOEhGfjUwQXO1mPKh4ZQxvk5nMO
	vT7EzetzQReunabLZpsh3flrKGejl8WjIwQmYUox2w2SXjVcWZLcL7WoZbOxg6r/OU6M9g
	Z4Js5IUfcVATWNDpDmlUrEQC+RYFDe0=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gVXlh3hQCzYl0S0;
	Wed,  3 Jun 2026 11:11:12 +0800 (CST)
Received: from TA004.hihonor.com (10.72.0.6) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 3 Jun
 2026 11:12:53 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA004.hihonor.com (10.72.0.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 3 Jun
 2026 11:12:52 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Wed, 3 Jun 2026 11:12:52 +0800
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
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYq8jCAgAEtZwCAABGecA==
Date: Wed, 3 Jun 2026 03:12:52 +0000
Message-ID: <2235c9949d8a4986b89c99757c5161a7@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
 <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
In-Reply-To: <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A6FD4000A
X-Stat-Signature: jtkebjytjqm3dum8g6qregpyaejn69hc
X-Rspam-User: 
X-HE-Tag: 1780456378-727191
X-HE-Meta: U2FsdGVkX19STLQcMYUxEmXpIUHtItRdexVEACsESnzLqYu0n50MLg/7rFzVCXi3stA8TXLklyXJ2524CBm4xawI47PGtRyUP6NltSFOuWCe2l9Fy0zFJTShyqC5oa6GyHRWlU93VF0jCtXJYLHUsCdm2K4pKCBI6wz1n8/oZPyCTva12bLZnrkLXM+d4Y0fJk0QDmABDPtiiJU5u+z9kuh4DNgEwp5i1ty1rKHLf25K16drKMvANZfbJxPbbvLdLu9es6Q+RZaKY1YjYFMsCFDC+t4mBppNZKtlLCXeDLXDaE+CVTep5LVKMadvKzs99lSexsnowTBz6FUvu6M2Q6JqqCEHYTr9yPm/eWuV/88ddYemT49MEcFXRZC7m5yx6AYtqI1dcA4FSAKZczuPljr/ZBq+XbwzQwP2SaRozXPiI0QAjXwHRrLnsTNhWkNlH6+G+B6f39vVslQ1/X8s363/2i+A9wiEqSiz4bxNIZdpOTkkMc1tP6RfszJ+BUNz9QEDTsd9dQxCkNdvACaJEzdt1Vv0sr36Brb1PAbE0OkAI57N9n0BnLENvw1kjmx+Ldf8S6CAFx2Rv31j/m1YJOjyVQjiHa3jqraFOFY14JB4j8r0U9H/8tjOEvgYkAsE3NbwjHKIniDexj3AMq+z5JfwjtaD6Qy9aUhFIk/3XrSJTo3Htl72ct36Nb3+GImoO3B25H35c1I0bs9mFNcQYVN4i4SxcQUD2h8RlNGC+tB2RL0ePUrXWFw4JopAhuYItDZab/hXd6rRAN9B+kgOC4dZCUH+d8KDU2SrCb/d300xLQf9zPJZAZikyS6UlrexkxpOWuSYjBVVMlz3lSzbseK1bBwZbxmtOJijaTLlREtlyL1CvfDOXV1zghBv9Z82XJs/QJ+SsqBlygUVJ1Dcb7/0vWLm0FKh5dYGAf+uRxHfL6ew8/gWpOgqF4WO2JZBL17KW3c1UqGm/g9mwCh
 fj2bd2vU
 47dwnIBVYcOxV+KB9KmoOvwe6BdZitFpZrcs1EtDJd5SfsZNbmleTOycj9f5bKc+Kt5j1WIsbK89VdLaI1GT/V2VCuw7kC9R941mZRwEbhEiQKP6WqiQuGgWsR0g9pONkRQ/EoAyN18RLx2XjmzBpClW3Zf83+kHRdOFNbc1htfGQY0h9JfxvbmbF4+2oQQiqXNHFXTI4gtwQwxnwbIKjdyOZhhlKJXjncWf1bGJtLM2Cayy4Ha0kVNzCkNDS7Nf3iKIfEKYPSy2QJ9KHDFP6Gle6qkt92WLAG70QTT9IZwC616w/4+v8TFmEkQ5PzeceDYMEiq9WtqO7Qj148nMn+DZw5I2u0P9kQKkNqOveejwXm8E8jaVDMCgIWEcW1nNUD2uFVlHn2M+PzOVBrkcriF8LrLOlhamkjzY69lw2d11lCe+H/ofxPBe5eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBEdXJpbmcgcm1hcCB3ZSBjYW4gY29tcHV0ZSB0aGUgZm9saW8gYWRkcmVzcyB1c2luZyByb290
X3ZtYToNCj4gDQo+IHZtYV9hZGRyZXNzKHZtYSwgcGdvZmYsIDEpID0NCj4gICAgIHZtYS0+dm1f
c3RhcnQgKyAoKHBnb2ZmIC0gdm1hLT52bV9wZ29mZikgPDwgUEFHRV9TSElGVCkNCj4gICA9IHZt
YV9tYXBwaW5nX2Jhc2Uodm1hKSArIHBnb2ZmICogUEFHRV9TSVpFDQo+ICAgPSB2bWFfbWFwcGlu
Z19iYXNlKHJvb3Rfdm1hKSArIGZvbGlvX3Bnb2ZmICogUEFHRV9TSVpFDQo+IA0KSXQgaXMgaW5j
b25zaXN0ZW50IGhlcmUuIFRoZSBvZmZzZXQgc2hvdWxkIHJlbWFpbiBwZ29mZiB0aHJvdWdob3V0
LiBJdCBzaG91bGQgYmU6DQoNCnZtYV9hZGRyZXNzKHZtYSwgcGdvZmYsIDEpID0NCnZtYS0+dm1f
c3RhcnQgKyAoKHBnb2ZmIC0gdm1hLT52bV9wZ29mZikgPDwgUEFHRV9TSElGVCkNCj0gdm1hX21h
cHBpbmdfYmFzZSh2bWEpICsgcGdvZmYgKiBQQUdFX1NJWkUNCj0gdm1hX21hcHBpbmdfYmFzZShy
b290X3ZtYSkgKyBwZ29mZiAqIFBBR0VfU0laRQ0K


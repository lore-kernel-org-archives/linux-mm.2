Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185A7CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E556B0092; Thu, 28 May 2026 03:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265476B0093; Thu, 28 May 2026 03:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154886B0096; Thu, 28 May 2026 03:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 035556B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:11:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73A45120740
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:28 +0000 (UTC)
X-FDA: 84815957856.28.F805E20
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf15.hostedemail.com (Postfix) with ESMTP id A53A6A0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e56WHfRH4AwVIeOtxnRpQ/XH8nHxcWdeHjdGBWwaDqQ=;
	b=Yh/vfjPZa5UzZW7ctFES6iGp5WnAMYui7jwF7Shgz73e3E4Jy3MCDlPGjJaJqXte7DAyCO
	1JxdDzh0lYMyJV8K3FuNOnWl2ampzGA54q7moE/BVfxb4hDSl6/i0Zc2OIQUrnqRJWzKqj
	kUnLLLvYAPiQFn4mEjzTL6XMnFq96bQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952286; a=rsa-sha256;
	cv=none;
	b=B6sTU2L1U4UaFr27r+eRg10h2X1IQ8I3iVc8Dw6o/EYP5DpLmF6uKMwNRdud6TS13rasZF
	atIXydSnpn14uD+i2Tg//DnJXWIHx8oljDMpvsIo9kFRyttwmV5O0J8JRcxhg7vWaYUJs9
	VJtMnOHPgn3IXwbT9RosDUR4cwYI0RE=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQyKs47bzzYlLKr;
	Thu, 28 May 2026 15:09:53 +0800 (CST)
Received: from TA002.hihonor.com (10.77.230.8) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:11:20 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA002.hihonor.com
 (10.77.230.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:10:24 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 28 May 2026 15:11:19 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
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
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYhNsEAgAHJA7A=
Date: Thu, 28 May 2026 07:11:19 +0000
Message-ID: <288935c5d9d84794a9120893f61e670b@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahbSrt0B1aQTwrk4@lucifer>
In-Reply-To: <ahbSrt0B1aQTwrk4@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A53A6A0002
X-Stat-Signature: pm1bjb17mg7jx9mmdzns3ngfoqt4zjay
X-HE-Tag: 1779952285-738512
X-HE-Meta: U2FsdGVkX19soh4PZGOPpTztX9HWta2P0PNasEAZDhwWvy8lMhn90MPiyFcHmtXtlL9wGPbTzZNdXSnfE+ctbzoa5A050AAvuKWeD/IVHjEbS6YdABnSVptohTWgX8yw83hwj63Xv27vlHAyKfo4JlfZTtZn0PtW3s9kaKLxzqCevKazt//8gbx67Ty/rpE3glEYmo5oOpPzFq1EYWkjyEPKgaYwSopdF35I7gj0Ka4gUmadCgtyRIelvy4kv7QkJkE6RQO0A6tBix6syaLD8H2PKFyZqGP8nuLg43ZuNAqJbY3OxpcjhoPwXZpPmO3nRLp5Z0C4GNYZxbf14k33dXht0c6DBrwSBPAHCSYlwefCIzMQjI35xQzXfpPgXMcV+CNdeSvBGCxOoD7VDVxPcq95W/393fyoWdw7aF2PUAVGYkuJvq8IPufHbsY6Qz/OcjMsPmVJHpfjSglgTfXDiwI4D24447ly0qiDH0GiXYSQ8M8DStDV5UYo4HI+6p5wCHnpkseZTic3Gd2L9tRPBYBOsvay2/lHM1QCE6WXfpiUBlXi3EA0rqYMJHhCd2vJGPfPRHztuRlzusqzMNK5oSjWc1nSN1SR53WDVwSHG/YqA/I4F7uON57HcFr17yZfbZ1hTP5XesWDztkLzQCVQW1Jg0tdvXFNcc1RfycA7DgMAiUK7DCESTA2Z3vw35fpW1aT9s7ohgOG6g4Mye7/BKggaqgT2u8UNCLRw4pmt+zK1zp4JApifgxuFUm5YHP2/GSf6+SOnuuJIs3sFubZ2d7MgospHVXIAFFmpf8x8uo66MDYOFS0/yQ9Vzayzw1gpsobtioQ3YHtLfYBw+nbuo4ZhClE26zNFoBhR113t7QYDq8Af6zgcmisBeoPpnjsflIGB3upnSOwhiifGJYB27sHYoOOm3SM3bVBj3PkbcRFM9z8y5piQNfNfO/bLQkMHcSBlpqF52IK68lpURC
 F+5pyG8i
 plEiT8DSU7ERhzTErYxOvRSDEt7R1k/6EPypJZfulH+9xgfJzpzYjvC3Rahp9HktR815yv3gDjRX3Tk9OJ7IkirzeHTn5roiaxntCCVSgoa8KTBUQTI//SkItltD+G05hueK2EXYKP8573aZMl2yAfuNlk5KLjHJFhw9EB5iaA66thi/R30H5ir5aHL2jUeqf+l6Raqp4xbmpnck43PXc1Rrm8WwIhYWO5BhEGoiVGK5wGlT005uOUKH1d1XV6o0PndUuNFbntsOuSBChc6QM5OqYi3m5BLxXWNx5LjcnDdq5AWlomvddAI0ZeqSuV5rnQF/pRNpTmYzLjgNLAAcaNwpZTGSb3jk1Nv2c1X1+m+45z15JYpwqGlwrM2dLu3UhejIQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred
> anon_vma creation
>=20
> I'm sorry but this is not how kernel development is done.
>=20
> You're sending a series that's very invasive, that you've not coordinated=
 with
> anybody else, nor have you mentioned it at a conference, nor engaged with
> in discussion with anybody else in the community in any way.
>=20
> And you've sent it without an RFC, at -rc5 is... quite something.
>=20
> We do NOT want to extend or expand or hack in anything like this on top o=
f
> the existing anon_vma machinery. It's a mess that requires replacement, n=
ot
> more hacks or expansion.
>=20
> I've been working on a replacement for the anonymous rmap, recently
> presenting at LSF/MM, and all of that has been very public.
>=20
> In fact I have engaged in recent work which reduced lock contention in
> anon_vma, it's really quite discourteous for you not to have contacted me=
 or
> the community in addition to the above.
>=20
First of all, thank you very much for your reply.

I'm also glad to learn that you have been working on optimizations
related to anon_vma. I noticed your work from another email in the
thread.

I apologize if my approach caused any inconvenience. My English is not
very good, and I have rarely participated in community discussions
before, so I'm still learning how things are usually done in the
kernel community. If anything I did came across as discourteous, please
understand that it was not my intention.

Recently, due to increasing memory costs, I revisited the memory usage
of anon_vma and found that it might be possible to reduce its
overhead.

My original intention was simply to experiment with an anon_vma_lazy
mechanism to reduce the memory footprint of anon_vma. However, while
working on it I realized that anon_vma handling is quite complex. In
particular, after multiple levels of fork the topology of anonymous
pages can become quite complicated, and it also interacts with other
subsystems such as reclaim, KSM, and migration.

Because of this, I tried separating the functionality of anon_vma
into two parts: anon_rmap_t for anonymous page reverse mapping, and
anon_vma_tree_t for topology management.

anon_rmap_t provides the reverse mapping interface used by reclaim,
KSM, migration, and similar components.

anon_vma_tree_t manages the topology internally for operations such
as fork, clone, split, and merge, and can also indicate whether a
VMA has experienced page faults.

My hope is that by separating these responsibilities, it may become
easier to reason about and further improve the anon_vma design in the
future.


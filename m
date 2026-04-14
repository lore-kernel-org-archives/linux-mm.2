Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DC5ED7B87
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30716B00A3; Tue, 14 Apr 2026 04:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1966B00A4; Tue, 14 Apr 2026 04:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6B26B00A6; Tue, 14 Apr 2026 04:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF21C6B00A3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:35:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 682CCC153F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:35:21 +0000 (UTC)
X-FDA: 84656502042.15.98785CE
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf27.hostedemail.com (Postfix) with ESMTP id BBA1A40004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:35:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776155719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GTNK1ZluQv9abfhvaIB1uLiNe6SdVA2j1EcTBgdlLdk=;
	b=MHAbctfK8so/dQdeHYdS9cwH1//JjcU9cVARUZhx604/vFKWEAqCCrUjNy4INsOtjH7RAx
	AeUUgsjHmlyX2Fgj81XAXoKxIvgPRsyk79d6TZPr4Y5Z0UP9HCn6hgg1i34g6zQThfDPQW
	NMGNw6J3eDtMIXglf9uvf9RWuS4eEfQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776155719; a=rsa-sha256;
	cv=none;
	b=y9HQ0ehGc5JCC7W4HPwgUfwdLI2FN53KktCVw9aqQx62ttbaTUpNutsdR04dw+nZN11pF1
	8egPOjKRf2mzKl2HlYRCfK+hId3YyJZlovC7WeAqVgvczcdWAuKAc+TRIZN9CQS93TlPhD
	Aa0QQTkduBSz9+chwj29Ddk2m6e/cVM=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fvyJc18rYz8Xs6q;
	Tue, 14 Apr 2026 16:35:12 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 63E8Z0aB020356;
	Tue, 14 Apr 2026 16:35:00 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Apr 2026 16:35:02 +0800 (CST)
X-Zmail-TransId: 2afc69ddfc36277-30fee
X-Mailer: Zmail v1.0
Message-ID: <202604141635029550xPVsxfQNOo6dY8p8AdSC@zte.com.cn>
In-Reply-To: <6hedy72mmajtutplztj57k63odkidzjr5zyn7yh7p3c62ybbj7@jupudx6k4lpz>
References: 20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn,6hedy72mmajtutplztj57k63odkidzjr5zyn7yh7p3c62ybbj7@jupudx6k4lpz
Date: Tue, 14 Apr 2026 16:35:02 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <hao.li@linux.dev>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Nl0gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63E8Z0aB020356
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 14 Apr 2026 16:35:12 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DDFC40.000/4fvyJc18rYz8Xs6q
X-Rspam-User: 
X-Stat-Signature: bpaafshqj6hi778puwpzkcn4qf3aqhjb
X-Rspamd-Queue-Id: BBA1A40004
X-Rspamd-Server: rspam09
X-HE-Tag: 1776155716-237244
X-HE-Meta: U2FsdGVkX1/pPn1oDQITmdGJBmxULbnK9C9Xi35Q6suhT1BalXBgij+m3VC1UMiUiGdMdYTUNjAmu1JDEdeA3FDjDGNMD/8oK4juS98s+Ts9oGVgZPBPeTmjb94T2NlfEYm6MuLaNBeMfiGbF3U903eiRmZ13bJISgFvPQ7ezPOdH0kAZtBXq+1PSGb6NViKcXqZylAwq+ftZR/4bit4esnQPSf8vbZz5XCW5W3KQ9Nnr2RIghV+k+DtxZaUxnSKKF5Bgd663RL7cnj5x5z5J85YtNL4iMunJxUEAZK1ZGqNhobFHmKTlBL2B8H8EfOu4iZHqYHorMzyvsEPOICb2ayUAQSBbTq468QzJNmkFA0vUDG1gvqoiy1zkZhDpsLF6caDsSBOUdS0dt4lkImmDkZHg/W+pIwV6Cz0yFzkjsiXscvvOoun/j27dkDWx4ZfIXKFOIP83bFdA/EfmJpOb7tAXYJc7vxYcSYhHy4jI3M/fdkY7TWqVnX1zmW92d8R7P8jq+2Oh4nkbUbhwsZI18ctmGwLj3i7/ff2Xqc76AcFY6rtk3lvJ6FfsnM5CJLvzAhJhW3S+k/TwXbvKccJgY4LouCbN9XMoWQFMeCOB3sCNUW95aZUQUaX+J5oR01I6tMlrg5I5BICtCJuOae74L7872EMPDpaHRdtFck6VDD1Lk6IkPS3lz+UPNbet3NULKsRbFRkTBzrzhxaFwniXwLXTyHQI06K9iAzqspRspV+ZZPtd9okyAEocwbQUBq4Zq5Cp6M+NkWzTHq+si6/9YjC3CQ8k924NUfcfPHfZOQfB/FV4Sw8A2g3VarWppm6WGBb98WndCLc5Fu2Kyh2rhDgbBfDjGyzrOlMR8lDIQccrZMcaP1TQ7aj4z1FYndrHi3Vh9nr/Q4/WHa9VcJT3mrCrANIZXmjMjwssiwdtt50gkm0hBiVnrI8zrOoVrIWDI4b7vNGBOAX3jMDUg9
 XUPHEzkY
 8G5rW08LZKSdg3g4+nyp/MBBso7CPGE1Wmp7z6EXNGjN8BShEPhNiqoqMStpfO+oMboI03/+O1Am/KTP08cJWEctlJbmkvEbQT4v9VByPFL+q/JgF6oo0/dbLCr3IvjcYScyQLOC+dBuZTYinz+F5+OkOzRDmQGB8vTE0oiyx/UYk70uCUezMhpIvBHSTyhnjZip8L0Y1JA6OTcH0hzqRhniWeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao wrote:
> On Mon, Apr 13, 2026 at 11:04:17PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Allocations from a fresh slab can consume all of its objects, and the
> > freelist built during slab allocation is discarded immediately as a result.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from a fresh slab.
> > new_slab() now only allocates the slab and initializes its metadata.
> > refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> > emit objects directly, building a freelist only for the objects left
> > unallocated; the same change is applied to alloc_single_from_new_slab().
> > 
> > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > small iterator abstraction for walking free objects in allocation order.
> > The iterator is used both for filling the sheaf and for building the
> > freelist of the remaining objects.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead when allocating from a fresh slab.
> > The most direct benefit is in the paths that allocate objects first and
> > only build a freelist for the remainder afterward: bulk allocation from
> > a new slab in refill_objects(), single-object allocation from a new slab
> > in ___slab_alloc(), and the corresponding early-boot paths that now use
> > the same deferred-freelist scheme. Since refill_objects() is also used to
> > refill sheaves, the optimization is not limited to the small set of
> > kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> > workloads may benefit as well when they refill from a fresh slab.
> > 
> > In slub_bulk_bench, the time per object drops by about 32% to 70% with
> > CONFIG_SLAB_FREELIST_RANDOM=n, and by about 50% to 67% with
> > CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> > cost removed by this change: each iteration allocates exactly
> > slab->objects from a fresh slab. That makes it a near best-case scenario
> > for deferred freelist construction, because the old path still built a
> > full freelist even when no objects remained, while the new path avoids
> > that work. Realistic workloads may see smaller end-to-end gains depending
> > on how often allocations reach this fresh-slab refill path.> 

> Thanks for both Shengming and Harry's hard work!> 

> This patch looks good to me, and the overall approach makes sense. I did not
> see any other issues, so:> 

> Reviewed-by: Hao Li <hao.li@linux.dev>> 

> I also ran a few tests on my machine. From what I saw, the mmap and ublk
> cases did not show a very noticeable difference, but I also did not observe any
> regression, which is great. My guess is that the fully consumed case as an
> ideal scenario may still be relatively uncommon in practice.> 

> Tested-by: Hao Li <hao.li@linux.dev>> 

Hi Hao,

Thank you for your review and for running the tests.
This patch primarily optimizes the allocation path when a new slab is required.
The mmap and ublk cases may not exercise this path very frequently, which could
explain why the performance difference is not very noticeable there.

Have a good day! :-)

--
With Best Regards,
Shengming

> -- 
> Thanks,
> Hao


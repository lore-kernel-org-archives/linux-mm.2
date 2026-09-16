Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48127C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F19A6B008C; Wed, 16 Sep 2026 12:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A326B0092; Wed, 16 Sep 2026 12:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC026B0093; Wed, 16 Sep 2026 12:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B120A6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:50:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EE8A1C2EAA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:50:09 +0000 (UTC)
X-FDA: 85220212938.21.9DDF52D
Received: from mail-qv2-f18.google.com (mail-qv2-f18.google.com [74.125.230.146])
	by imf31.hostedemail.com (Postfix) with ESMTP id EE81920004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:50:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=h3qmQM4m;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.146 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789577407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsW3GrpW0HCe9cpgsGq1CDgI5c4v//i9fXbu19rssIo=;
	b=FdRnKFMEHp4cZoNqu9U0NJSCAyGldErgbwR6t0jK0jvCFQ/HcZ7Mnyd92o9X3l8i3FSkpE
	js+cXlkdSJnwbbq99Z7Otk9eWHBqeKoD+QvNjxuPd5rgtCMjXypQnlJishOWg8av/I6rn1
	JJ+ckCRFCh1YPDjBgNKsKwXkaT61j84=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=h3qmQM4m;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.146 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789577407;
	b=FkBHsigij+1mPLUrkUk+hOMQn3f7AhnFUkF0ENN9B4t/uiXHuSAovoSYn9QUE48EJziYRw
	JvDxdnguz3pc1b5AyyY32PjdvEewvilrg/rxub78+wSxOKkuu2L8J7DV0yOZdituurk3MY
	HZ1K0pacWwi4YmbShjMQ+iYmE2iMz/U=
Received: by mail-qv2-f18.google.com with SMTP id 6a1803df08f44-90cdfc6db0bso10360656d6.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789577406; x=1790182206; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RsW3GrpW0HCe9cpgsGq1CDgI5c4v//i9fXbu19rssIo=;
        b=h3qmQM4mxk0pvqJAw907u2cDZpisbLfiEUBqwLuoH0mJADUxUI4RCLFCaRorgklccO
         1AuHGszNDtG0Ha2aCXaIOsD0OhA9t+h1uNYQyFKiAVZv/7FOyK1eSjorSu7nSz0jGksf
         Kt8dm56rxYlJ048BtaCLk0wiHRsaYg96gVvL1IKKwNH9J2YkqukP0VamfesAUEIFrObI
         9QSBxEgPQEUaHU9aAUYpDMJgbfAQqxWzsjScNsf0r9xrtBZ0awL+9WRQDJiojaufHf5E
         IV11mpT3PXQv/eJGq6Fdb711KvYGKfLN83Y7ZQ1IW+xt4UVbBj3bfsxrLxNRzmSpgwKk
         Pghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789577406; x=1790182206;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RsW3GrpW0HCe9cpgsGq1CDgI5c4v//i9fXbu19rssIo=;
        b=Avc7JjVWz7JiYHIR23k0MQ4/5XMR0AR9/rVI9DIkp/5dpkUyoXy3aIHn3UAs3Rq2di
         e+WPLNiIrIZKPEvLkUUUpvPVdBfkSMQsUheaD6oSDpJmejKMhjiR6jD1k0syE2eYGVJC
         sBwUaZJUOXkKdoEZ3s9dB1G2px46FIzAQ9RvGk/eZ+MyPzBMGaUlX/rvCKMV7uFIy9GQ
         aDvoi2dBWKyeAmWkG5EJ1uiB+hQZzm8oTYm5oBTEnQ3J5J5nIp5j8GgPiKYoIspa/e25
         wBm1jD2LsLUgqc0QQz5CO/GHWrVugYOJvBYFIMo0B+HPNN3P/yOT/L5IyIQjqaFGK1/T
         J7hg==
X-Forwarded-Encrypted: i=1; AKwUvBx5wWB26+tx62K9ABDTi42cAdiOwIou/BrCg1tRtAXC2MHrdAnkD1uliAXIxYT02pLHgt5c66Lxzw==@kvack.org
X-Gm-Message-State: AFuF++l/iwVxFojdmRa1GAgN8BTBvmHPCct4cElV1lIcPsCSgQiFKFEN
	V4w/lXq2e3lt3SwvLsKKk0gv4y/y5fd31YIywdv0cthJMeu5aUhTdYpcQuEct/g5VnE=
X-Gm-Gg: AYBFou0kGUcDoo8+wwrbcn0+bybhTgxSvtWbUO9Zbug2fcc/Ih/I6fQaljVZ9GCOOZC
	R+70xJJOYr1qNaEoK+gaUR647uY62GN8qpnRmgpaJM71Xso0Hg20H059gc0A+vUpeZILPWkmB7+
	2nt3IppYRbmXi01EfFflbXmDit3ivM3F5X9JwONkbArZr8wDBPK7lftUWH8/dbTwV4OvEPCJlkx
	Ocd2/vY2KjkQmyp43s+uYTrbuTCQG43sYr2QbMFvgwqEGtv1VrxCuko8CbHvjyBJ5nha5av+0p6
	xrkPsgpjW78+xx/MKCwemGewItMf4sy28vw0EjQF48vO0YeiM7y2HvH2yKcCBshKq9ldF28dY+S
	hUZ7OwObmwTrW/9OadyFeyinZx1sOEe6Kxqs7A7dl7LeRrdfH3zp6ev/wpGAErm2XHKhxXhqrRa
	zm028vOGwJy3oHwG8KvrNcya58oOzEnKiv1LkZ9J10YcXo1gcbgKEuQaxuMELPZtpd8JVV+Q==
X-Received: by 2002:a05:6214:3c9b:b0:90e:995c:42d2 with SMTP id 6a1803df08f44-9123d72c6c3mr68034436d6.12.1789577405749;
        Wed, 16 Sep 2026 09:50:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be5fcfasm29739106d6.12.2026.09.16.09.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:50:05 -0700 (PDT)
Date: Wed, 16 Sep 2026 12:50:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org,
	mgorman@techsingularity.net, linux-mm@kvack.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	henry.willard@oracle.com, david@kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: do not boost watermarks in kdump
 capture kernels
Message-ID: <aqrIvPY6iJOJ0mVf@cmpxchg.org>
References: <20260916112545.3707893-1-xiangzao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916112545.3707893-1-xiangzao@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: jye3mc9u9b38ocxs6qow9z6zjshi7xwn
X-Rspamd-Queue-Id: EE81920004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789577406-800022
X-HE-Meta: U2FsdGVkX185b94kND8skzd2v3uxLBAvBzFDNwzXfwTBplGZDmOtfDgPF3DO+/7/nsUVSxcoYqBvOpRuzwmxLco4nkSACf7/chG/p5EbUB2RlNDbZpGYEJLHFb43SniigNM5f4unKb3YKxb9q12XQcCRaPzX7McGmHCsx5GSPGVk/PSwU8c8JM22vPQ87ptIfqhQrTmkBhthDqLWykUesHrHGc5VCUjHKLgQipD/vYT6oxpnLmmx/tcu7DJe0txGVc5YuERDaqR1lCPDzSzoWPv2MZVRTm7+CUBEG+abZWKURvsGrAU+VG5IVwlUDxwjUfqQPHYF08oT1lc2MrNcMUbJsg1IZBR2z9f7wckZHxmc0aFHg9U6S1m0xlblD8rG9PnancUrQAn04KYIDh81IX+1hclfIKhQN5caK2CmtxlrNIt1vi4LuQcmwIIn4Cz5dDVLHWE0i3LllwGzbE4/Nq33c+2Q/ARzKPemEc+zuaeRNz1YGh2zOjuVualqZ6bV3MFkJx+X5t4xq8RELqJkarZklZ+3j9mvRlbTNmZCtXnBiqCTCdz6G5qSKKuLRxTYZaDsEkjoI2iz9gzlvfnz/mSETLVLihuQcnKrFPK6usXFphmx8xI3bPp5x0TVbvghr6Ti4bgiPZhXW00Wl5iFkxSbUsNB+6yRmFxDUlylVFZ/JT+9PTeyRsNXTvu0bdTEKwFu9w0V3uAtVSf65LeV0vZ9V2KAsASmuU+2fmFH3Otj0fUvX0Je5sNsM8OrODT+pjmUtIXcwmzp8Lp7OZBxZ0Dpcr4hCTVIUPc28yfrDPBHDVeI4Blw1A8E6pV83QCzSvJT+BBYhpqikbLqtrXyVoqr28/dx+ytH7HSMe3OtpBnwS5j2ZCK6p2+6aQ42vZZyyJKLb4S8TV2jEFHGYU0JPAUOJvBM/8+albSBv7hfB7/9pZJx6P45d2kj8jqqr1ELwi8w6leP1IgWc7pdos
 kMMtljQ0
 PexF71unVr6Lxp8BXcKZ5Q+Ieiv8U2ILH10ub6nxdYVjw4juENywVdQI0PLARbjzZHvm4HKUxo5JzNAex29Pw4RHH14sHDrS/tDwHF/uwSwWzAWLacYpa5J94IzTNXh3+/niKjKPiy+5fCmvDtJAqtr8TiBENbbffCVCFCRfs6h+y15V3XE1YXwzsq9oaik7H9CgJabewxifFiRiZOM+DKddu1GyvG5K3KfQdol3iVD9CKlNu84zMWXxZqWsEPGn482rUe175P4hj+Q3gFx3zvlmDFd5tbaGwBEPOFt/IWL5o4JYMDxDO8u/MkyoZg4A3BrgQzAnt0a3M/uV8brRFDEE8Pib9BP56m1dImdkGk41qS/ZLkaAS0GFzsc+UXy3FoK/TmhZrSZUyH9HVd83UQ/WYwM7sxdxmIy0+WOJOPiLRRnPaoWyUcVCzg62sC5jlGyEhoMcwg1bTxeeZVUTwXh4+yY4qBLpb3F3zX2BecH25r6RvXsVnDwi4II/LYsqZCNJs2HZkrps1UZkSP2V5eUnsrFsdR0X77h6G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 07:25:45PM +0800, Yuanhe Shu wrote:
> A watermark boost is not confined to one watermark: wmark_pages() adds
> it to min, low and high alike, so every watermark check sees it,
> including should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH
> attempt in __alloc_pages_may_oom().  Once the boost exceeds the memory
> still free the allocator gives up and invokes the OOM killer, and a
> capture kernel that is still booting has nothing to kill: the boot
> panics and the vmcore is lost.
> 
> Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
> (pageblock = 64M) and crashkernel=512M, running a distribution kernel
> based on 7.0.14.  A high order UNMOVABLE allocation fell back to a
> MOVABLE pageblock while the capture kernel was still in do_initcalls():
> 
>   Node 0 DMA free:68096kB boost:65536kB min:68160kB
>   low:68800kB high:69440kB managed:479168kB
>   Out of memory and no killable processes...
>   Kernel panic - not syncing: System is deadlocked on memory
> 
> The zone was not short of memory.  Subtracting the boost gives
> min:2624kB low:3264kB high:3904kB, so the 68096kB still free sat 17
> times above the high watermark and the allocator would not even have
> entered its slow path.  The boost supplied 65536kB of the 68160kB min
> and by itself put the zone 64kB under water.  It is that large because
> boost_watermark() clamps it with max(pageblock_nr_pages, max_boost);
> watermark_boost_factor alone would have allowed 5824kB.
> 
> Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
> tried to protect capture kernels, but it infers them from the zone size
> and skips the boost only below four pageblocks.  arm64 64K pageblocks
> were 512M then, so the guard reached zones up to 2G;
> CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
> to zones under 256M and lets this 468M zone through.
> 
> kdump is a property of the kernel, not of the zone, so test for it
> directly.  A capture kernel exits within seconds and never uses the
> fragmentation avoidance the boost buys.  Normal kernels are unaffected:
> the size based check still covers their genuinely tiny zones.
> 
> Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does
> not cover this window: sysctl.* parameters are written through procfs
> by do_sysctl_args(), which runs after do_initcalls() where the panic
> above happened, and watermark_boost_factor has no early_param of its
> own.
> 
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Cc: stable@vger.kernel.org # v5.0
> Cc: Henry Willard <henry.willard@oracle.com>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>


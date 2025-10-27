Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0DACCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 21:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFDC8009E; Mon, 27 Oct 2025 17:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FFD8009B; Mon, 27 Oct 2025 17:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375A98009E; Mon, 27 Oct 2025 17:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE88009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:33:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9528F1DFF35
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:33:13 +0000 (UTC)
X-FDA: 84045195066.08.872EC4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7860C0015
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:33:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rR+bjFln;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761600792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzpPHD5CzY6o02euYp3NVEZQHHBrCWuAHt8or+oN0gE=;
	b=2xr5LtY4dt6OQbCzMt2vlxcf4hKz7drU1rh6Lcbr3RHtVlP/aB9fYrNb6eyZKM66Sy5Fbl
	6wbhvH2K4fX/IwDPvBoCV6oIVqHPE//B/biYcSCnurYVqIeGIP+W3H9ejlUE/I9GuyrTCu
	Nkod3vVV7vK1krkP7P5+hZj7WLwtZV4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rR+bjFln;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761600792; a=rsa-sha256;
	cv=none;
	b=UltdlhItiGlSoqDPBDDeE/xRkreRAwY6eVXGOcl1Cw+4Q6c9sQk42d8ZXU0/ZL8v2Ilkis
	1k8E4Vn6hmlJB9WpWwa1wvf4YWYoj0ALVyaxqSuJ5uHq5N/AlK7YxOVwMV6JMYZe35qRHt
	aWnosiBc0PuXKD0BtEBwE1EUI2L02aQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91729441D2;
	Mon, 27 Oct 2025 21:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC190C4CEFD;
	Mon, 27 Oct 2025 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761600790;
	bh=8GggW/uCYLmuf2ftOvfd6WSM03QRKgQBORqkMrFcff8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rR+bjFlni2Cty7mzb7s4chDTQ2uLP+zOUAUbVoQR2VAUDLjacPhceY1ugFXPI1+pe
	 vHS5yGwrQjCNfRGrzMKDbiDNpn0Dy+CINCttVGv2synAWVbnhLSH0wUaaAEdVE7A9s
	 PU9RbBDofsXM3sKyM2CAnpZrjKDSFMGSUlyOEoNk=
Date: Mon, 27 Oct 2025 14:33:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
 willy@infradead.org, raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v8 0/7] mm: folio_zero_user: clear contiguous pages
Message-Id: <20251027143309.4331a65f38f05ea95d9e46ad@linux-foundation.org>
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7860C0015
X-Stat-Signature: wugfuxcnc1waobg98bphaucr16ha4szt
X-Rspam-User: 
X-HE-Tag: 1761600791-721037
X-HE-Meta: U2FsdGVkX19yo6Z2CFDZ+hlTgRongOMZ32Ch8zgNI6y52mJjL40snko39Pm2NsS9q7FOeFtxNOJd8ZS/HOStMB636nDg2X1hs5hkjy2sTYi5R21s53nabzSENJ1hxT/QvOslvTJMGgecDNeVA4P9rvxmkG8VKtsb4eL/sQiYP1UJsQcznbdr3LchRuQSqLRYy18bv/r4KPgY74FQJlYso7rmwJX8dSFvO5QPu0VxZ2c3+v3PKNW0yEW0gXz4210K1C/mHC0Mk2vRYuJTW4KcpE35c+JhTTgxSkUk9gg+Pxpp0MMEf6ps8n0iSSRhCIqKRtc7Yrb49OUNbhF0LsHubO77WsqyCIpXGGBvaNSaQRM7yNQE0qlxbBFvfuWe+tK0FJKLA0DYa+C7rWBnOVDGC5WLcMCovPTIC+b0yZgQ3Wv6aydHPQcg+9q5f5JKxsMDly9XHqiTmpGSiljOCZUKBWT6XIJG+nAyEiXvfG1dph1rlRC6Ugv74hikU3oKWvHc/IrbkoPj6/wdubkvPwuYv2GRS1wW98uBKpDZsfWQVyjUl4rQcaJXPmggvpPN7czUKUa2qgyWmT8REe6A8VkizVrBxinNQckX/qPMWL0eBZyaaheQwhPIIQibfsA/mJ62z9sH0l3Ysj426fZ8NsRYivGcnJZIanqxxqkYX1EYNB+BcyDnK1qhIL6vK28PPGrgXCKteUTXRoJZHAMdc8uQ0fCLSZBz1XWnD9VY4zDjzf3948nTDoOe3bT/0Eh68jaHw8PgCxngHQRmkvRx3q9G1HXbBQy7bd6Nnh3O7MwDoD5rcJu4MnOqrfnTQ+Mdxslg/ikEGLiaeU4kPxvebu++OtPjIEgNhTHk/EiYEkHX1SiWU9XMTRhuyOx8VXKTgXCJJRh/oTelkuM+TOULeqGWvB6/Ar64uYJvV2yIKqpmY2oLQ5viLCcd9Plr8ojFdpSu7Nv0hJ5XFmzmSuX3Unv
 CIEpZvZZ
 XKQKYgTMgE2MgsoLIrQM1Mdn+6mZl5KMUXa2PYq5yx3a9+1CIV0lxB20Jz/T0Borw5Y+E4Z4j7T8wZCvqWlvd/emTOf5B/Fqgh7KTEq+b6blHUO9cQJlj9k1KFjCdzJV2UtSaYkl734JLiPD4bTAZJ6gK5c2C2vCJ277SeGQxK/7tib2VnkT97KgPHAAWwUGXB1jr1m0xZjUOWW4BxJd2RLcPRSmhMDqFYEyWk8ubwArl0+cpmM1bDluoO1GR6pSevlF/6MIOD8e6da/Qd2XiWedpphMLHmz49upn02fHWOBed9Wd29Vr+jPbwE06IfPk0a3c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 13:21:02 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> This series adds clearing of contiguous page ranges for hugepages,
> improving on the current page-at-a-time approach in two ways:
> 
>  - amortizes the per-page setup cost over a larger extent
>  - when using string instructions, exposes the real region size
>    to the processor.
> 
> A processor could use a knowledge of the extent to optimize the
> clearing. AMD Zen uarchs, as an example, elide allocation of
> cachelines for regions larger than L3-size.
> 
> Demand faulting a 64GB region shows performance improvements:
> 
>  $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
> 
>                        baseline              +series             change
> 
>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
> 
>    pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
> 
>    pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%	preempt=none|voluntary
>    pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy
> 
> [#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
> allocation, which is higher than the maximum extent used on x86
> (ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
> with pg-sz=1GB.

I wasn't understanding this preemption thing at all, but then I saw this
in the v4 series changelogging:

: [#] Only with preempt=full|lazy because cooperatively preempted models
: need regular invocations of cond_resched(). This limits the extent
: sizes that can be cleared as a unit.

Please put this back in!!

It's possible that we're being excessively aggressive with those
cond_resched()s.  Have you investigating tuning their frequency so we
can use larger extent sizes with these preemption models?

> The anon-w-seq test in the vm-scalability benchmark, however, does show
> worse performance with utime increasing by ~9%:
> 
>                          stime                  utime
> 
>   baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>   +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
> 
> In part this is because anon-w-seq runs with 384 processes zeroing
> anonymously mapped memory which they then access sequentially. As
> such this is a likely uncommon pattern where the memory bandwidth
> is saturated while also being cache limited because we access the
> entire region.
> 
> Raghavendra also tested previous version of the series on AMD Genoa [1].

I suggest you paste Raghavendra's results into this [0/N] - it's
important material.  

> 
> ...
>
>  arch/alpha/include/asm/page.h      |  1 -
>  arch/arc/include/asm/page.h        |  2 +
>  arch/arm/include/asm/page-nommu.h  |  1 -
>  arch/arm64/include/asm/page.h      |  1 -
>  arch/csky/abiv1/inc/abi/page.h     |  1 +
>  arch/csky/abiv2/inc/abi/page.h     |  7 ---
>  arch/hexagon/include/asm/page.h    |  1 -
>  arch/loongarch/include/asm/page.h  |  1 -
>  arch/m68k/include/asm/page_mm.h    |  1 +
>  arch/m68k/include/asm/page_no.h    |  1 -
>  arch/microblaze/include/asm/page.h |  1 -
>  arch/mips/include/asm/page.h       |  1 +
>  arch/nios2/include/asm/page.h      |  1 +
>  arch/openrisc/include/asm/page.h   |  1 -
>  arch/parisc/include/asm/page.h     |  1 -
>  arch/powerpc/include/asm/page.h    |  1 +
>  arch/riscv/include/asm/page.h      |  1 -
>  arch/s390/include/asm/page.h       |  1 -
>  arch/sparc/include/asm/page_32.h   |  2 +
>  arch/sparc/include/asm/page_64.h   |  1 +
>  arch/um/include/asm/page.h         |  1 -
>  arch/x86/include/asm/page.h        |  6 ---
>  arch/x86/include/asm/page_32.h     |  6 +++
>  arch/x86/include/asm/page_64.h     | 64 ++++++++++++++++++-----
>  arch/x86/lib/clear_page_64.S       | 39 +++-----------
>  arch/xtensa/include/asm/page.h     |  1 -
>  include/linux/highmem.h            | 29 +++++++++++
>  include/linux/mm.h                 | 69 +++++++++++++++++++++++++
>  mm/memory.c                        | 82 ++++++++++++++++++++++--------
>  mm/util.c                          | 13 +++++
>  30 files changed, 247 insertions(+), 91 deletions(-)

I guess this is an mm.git thing, with x86 acks (please).

The documented review activity is rather thin at this time so I'll sit
this out for a while.  Please ping me next week and we can reassess,

Thanks.


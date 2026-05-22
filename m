Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D9BCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C8B6B0095; Fri, 22 May 2026 07:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECE46B0096; Fri, 22 May 2026 07:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE096B0098; Fri, 22 May 2026 07:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 585546B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:03:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 044F1C2790
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:03:06 +0000 (UTC)
X-FDA: 84794768814.23.D051B0B
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19FDE2000F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:03:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xMV3BMDy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPGW++x8KGsaG1c5xauFzGp4pMym1MLFRTEVwpXU/hg=;
	b=bmfMWGlZnbUIlYotfqae3KeOOsTN09kZVNi6hYLtz9+H6YIzcF82D5z/Vc/kysFN9gml31
	TRnnoQDFBOAw1H9/2hfFJZBnJaUMkbIgFxYgtZoV2OiLPgLhYdr6XBR9yDHxPvg9sak47Q
	JtM17xBOj8l0+d12tsoLfePOSx66plY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xMV3BMDy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447785; a=rsa-sha256;
	cv=none;
	b=F4bttYKP7OdngCl0Kbba+R7B6SMjjgG3TYQ5P3fpAQqKZVFh36gcqPoEISASsR/GDupqMJ
	ukPBgvow/62Yr5Xzp9gigMq0V6tNXS2pitg+zasqAp3nKrvPapiR3ZzU1fvOKgUkoM0kyw
	Kxm0dEWTHVGBn2TDlCV8xtjsa+41yIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779447783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gPGW++x8KGsaG1c5xauFzGp4pMym1MLFRTEVwpXU/hg=;
	b=xMV3BMDyJ/IWo8WHo8YNCvUQpUI4iwCy8DEFQXzPmQjexWybSUZCkFni5amkiD2Lctb3zI
	IU6hlmByv4KOUHYUY1YLxF63s7dyJIH0z0xUydIT47P56jHv8REau7C3L2HQVAruvL84fo
	SAG7SMJy3S0UIpOeqOD/NRLJUdjgPKU=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	fvdl@google.com
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
Date: Fri, 22 May 2026 04:02:55 -0700
Message-ID: <20260522110257.1640781-1-usama.arif@linux.dev>
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8rzm8kiuqrpdqr1mqrfntn8s13xg6oiq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19FDE2000F
X-Rspam-User: 
X-HE-Tag: 1779447784-372661
X-HE-Meta: U2FsdGVkX19mx8lkPNS+Vt77txhLt5g1ST5dkLZfq5DGGkFsMqJ6Q7rr1dbiSE9pZ4uSmu7BuXca5GUfVW23asqpMmJtpdF9lP+ptryhCk5RCD0hASIkGXNaN0PzMnNViiKqFg5GRh+glqVipg2xMTYFGYypStLyfnL/60IVtWc3IdX6ntCpNHPL5d9Qwg6TDd650cO6eAsDam7Xag3v1iwDM5/1N1zJ84rZ0CvLnlKTr+ib/+y5qZpLHNtV38MlHnlmX98V6KgztQ59NpHXA6Mtvkt/kTsKuM4q9POKhqAw7joc/tC6M8/SxPmAgqXB7tTW441QVxIp6keVYDgHKaXhKdlriX5bHNX4D+1/UyhDW4ONqjqTEkZ1f0dddpTel3ytUAsQChlq593OpensaOT43zU2jALLVwVna74I8ycZGxT7ahcCz42xnOANstiEsK7X47xaGmHOt4vtbxx8LiiLJqJFt/HYaShIbbzg5XkgLc4HM4AjpIxnZYoq756Nuai+b7lAc3n7cD4Xp34+jicbdu+rW3VmQlQ+GtWU9TrN9mlHJF9vSgLN+2wjEoOlkM9dvrAfHNsgysf3H3L1m4D4ClXTzatbgR0qnKtJfTBXlALGgxEPmO96MBSGv1TN9j5xlNw8hgTlbjvYvWo4fYUMA4V5i5TAMsfRidUcP8jWbDOfJAXSdjBCU4rrfRJ9NeMys9g5b44HJcfY1N6dz2ilpnPKvp4S3Yjtarue0mCqkAp4PvXIoUhZwclel+24b62B9MSdqt2t9IJZUKoRslXYiXT3rYMpUV7TgahuW0ebmSx/bRrnMWkbR8HtqxOAYzcFDci4uoNCYKJ5+LPUT/ERaIoIOx2SHMUxFogCEvIuqY8WVdaYx8fiQI1jNfWbIRn8cAoTqs3R0o8udjPRG3v28lFmBUz0gEgWPvU4ExxhXFbvCnw5ijrFflD2WAmuWCl2wHcSSqBIG3LY/uD
 kI4tOruM
 HEr0+qeMsh47d2w+m+yRG8OKKrok/uR0MuP/9I3u+irj88kROlLk3lxeQ0K1EJDWzLqWL6RJc9DcKLiGxbh5ERY3CLYzNkatLRl0iS/bCA8coWsHPt8xACUnqyViOTdljGVVQUX2vURuOsJKo3k1m0w/MJoRwj+MRgi8xkJDIpbzKpWQB/846wfhnkHAMMRxzgL/BKZla6LmwQ5yv1efQCQl8HO+AOUj8mbDm3FIDHMiG0WYIcSvDpe6Vo8XNpsD5fjRW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 10:59:06 -0400 Rik van Riel <riel@surriel.com> wrote:

> 
> Some workloads see real performance benefits from using 1GB pages,
> but allocating 1GB pages has often been limited to hugetlb pages
> that were set aside at boot time, or using CMA to keep a fixed
> amount of system memory off limits to the kernel.
> 
> Neither of those are great solutions, given that modern servers
> tend to be large, often run multiple workloads simultaneously,
> and each workload wants something else.
> 
> To address that issue, this patch series divides memory not just
> into 2MB page blocks, but into PUD sized superpageblocks, and
> aggressively tries to steer unmovable, reclaimable, and highatomic
> allocations into those superpageblocks that have already been
> "tainted" by such allocations.
> 
> The goal is to leave as many 1GB superpageblocks as possible
> used by only movable allocations, so they can be easily
> defragmented for either regular PMD sized huge pages, or
> for PUD sized huge pages.
> 
> Various strategies are used to accomplish this goal:
> - unmovable and reclaimable allocations are preferentially
>   done from 1GB blocks that have already been "tainted" by
>   these allocations
> - kernel allocations that can be done as one higher order
>   allocation, or a number of smaller allocations (eg. kvmalloc)
>   will fall back to small pages, rather than taint a new
>   1GB block

Hi Rik!

The comments are just based on coverletter.

Hopefully will get to review all the patches. The above one of
kernel allocations falling back to small pages is interesting.

- Will it result in a performance impact as kernel allocations
wont benefit from higher order allocation?
- Will this impact 2M THP allocation efficiency due to more
fragmentation of kernel memory?


> - movable allocations are preferentially done from clean 1GB
>   blocks, which have only free and movable memory inside,
>   starting with the fullest of these 1GB blocks
> - 2MB allocations follow the same strategy
> - 1GB allocations start with the emptiest clean 1GB block
> - if a 1GB block is mixed, with some movable pageblocks,
>   some free pageblocks, and some unmovable/reclaimable pageblocks,
>   the system has a free threshold below which only unmovable and
>   reclaimable allocations can be done from that 1GB block
> - below that threshold, no new movable allocations are allowed
>   in that 1GB block, while new unmovable/reclaimable allocations
>   are still allowed

by allowed, do you mean if movable allocations fail, it will
result in OOM?


> - when a 1GB block is below that threshold, use the migration
>   code to evacuate enough movable memory from the 1GB block
>   to bring free memory in that 1GB block back to the threshold
> 
> These strategies together serve to concentrate unmovable and
> reclaimable allocations in as few 1GB blocks as possible,
> leaving as many 1GB blocks as possible available for movable
> allocations.
> 
> That enables both more extensive use of 2MB THPs and mTHPs,
> as well as reliable allocation of 1GB pages.
> 
> The above strategies also make the core page allocator
> more complicated, and slower. In order to avoid that issue,
> the series is built on top of Johannes's PCPBuddy series,
> which has the goal of reducing how often CPUs need to get
> pages from the zone free lists, instead relying on CPUs
> giving back pages to each other, based on page block ownership.
> 
> TODO:
> - compaction "always" succeeds, with a success rate of 99.96% seen
>   in traces; this sounds great, but it also results in compaction
>   never being throttled, and compaction blowing out everybody's
>   PCP through lru_add_drain() calls. This needs some sort of solution.
> - replace the superpageblock name with something Matthew and David
>   both like
> - find more corner cases, and fix them
> 
> Based on e1914add2799
> 
> 
> 


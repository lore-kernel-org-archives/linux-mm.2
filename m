Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB06CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 10:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954F46B0005; Sun, 17 May 2026 06:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905816B0088; Sun, 17 May 2026 06:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81AF46B008C; Sun, 17 May 2026 06:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEF76B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 06:05:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0AF18C8F8
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:05:37 +0000 (UTC)
X-FDA: 84776479914.07.2677ACF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40B0B100011
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:05:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNkWqw4D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779012336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp7UQtFLDQOSwTOzrAMx4nFwq7XBni8racnVVX3Zztc=;
	b=STH5p9v/tuEMgz5icZi+XrGEHCWu5Rnk8fOez0vTHidgV1YRfKST3ueFd6ToAGWem1yuer
	xeiSYJBElhzUEs938XGSMBFfikneZDCMX3D80O+7SjQdDaa9+5OPHqf8bM2h+MdqjWJRhi
	2SKVSc5YTu0sV5H+PL9lKoug+jBrXLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779012336; a=rsa-sha256;
	cv=none;
	b=Q78CXhuIgLo8KmFhTNGHZwimnN6oSWF9vrY8C++ZQRqzxBoYxUO42tEthmRtm4yai1BoEw
	m54iXM8ndkuArmHmuBkwEaN583EX1fOR//FZX4ur579F4EDCD2eoTqitSyqJVMcU1s6c+k
	/Ev0AwGZga4J4bFfLXIKaZ/R0wMN4iM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNkWqw4D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E43A60141;
	Sun, 17 May 2026 10:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7DBC2BCB0;
	Sun, 17 May 2026 10:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779012335;
	bh=Vviridf2rYENdMQyg1PwQd7yPN3pjJp7G40ryhShIhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNkWqw4DwlONbnEUbSvyLpc1VaSf1hoOg9OAz7wpTAuQdzEBF6ffoQMOgkoSbEyPZ
	 tKmL6NKUCKxEAtDLuv/0wgAcFzKYVNDMlWYfSGZxhxrVrw0cGbirvVSMg+T88kP7hT
	 Mrv76w9Ku2JgvnKzyymeu/4JAl3qKyZEJRUx/z3YLbipmyeFWxVnoe21gWo+hq7YLU
	 vhUSA31Rl+5ypwRRkYlN24P3YDZK4dNSr0oTtc742ooG1HLOaquB7QNfZ8KgboEyTB
	 dh7JE5mQS8ytWq+8awNQuhVLAfR+kL+6tr7aVaxKMWL7duNuJXh26P77x9uysBXOVP
	 GOR3HWFpJOB2w==
Date: Sun, 17 May 2026 13:05:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
Message-ID: <agmS5yZRflzN1M8U@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-13-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-13-pratyush@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40B0B100011
X-Stat-Signature: bb41a9y9emobm4xnsz4o6npgxtjcoixz
X-Rspam-User: 
X-HE-Tag: 1779012336-87173
X-HE-Meta: U2FsdGVkX1/r0HTE9GquWm0tPwnWbiB6xGpzm8B2xs7P3MUXF26yBEw7WTl9kHFNjrO+7EQdDQ3agmM142ehGjKMg+LZfHHJknmaXPCOlbc8Umvj6aKEH1U7I7Y4CS5yDhLLgjF4vJah9lkbOJKgkxCmPtP9xTcNgIS2ZPOtS7yzCmvs6gXj5zcYPWqBdorSy2TYfRyMurcqtDK10DSxX2MvGbvOjpKClvLExT+xRFq9lomXV8+ZUFxZT/tk2geIiAT1EVpFUlj/AfYnDFeCqZmwzaSEJTJbRkuTqku+qQN6O0n5kAjH0W2HaZGAOpqemNmI7K1iOQS0tA/ANkC+nilMd8eT9Mqg9RsxhBe1CPW6GhTXIhEHbxsJf5+WRfI/lkQidtjHegJsqts2mY1Ba1kDHwOhM6eN4lKKz9BRb46PhvganVHucUxdKwLX/Qwohg1eeYKX3LSSE/j/SbOUrhzoGfI975ppI604xD9Mg+oXATNPxAEiIqJVJmZsIl7bgzNh+esxq81s4EKAgyNGYSkQ0bVlu11e9OYFWp6qOcDy1LApvbv2kEiougqvo5ax7TwQj5BZAAkNw7WlphUjIJmweV+fnxdMCCWoTrZ99oRnpmNEbreiBzhyrJ9Nw7iNGs3TeDi7YE4wdPcd4/p8hFy7oUMkh0YXyviDdN9CvXvUpVZZ4uGgdiMgWnkMYe6B3eYWxruUMBArziIAAY7XF829Yp7504n7ZRdyVBsN6WBvaryyagEmLzaf9Yy34bMPQ23MEwcSgGIfdZ3/6TqT46R1k36z5TCPbolb3VJS/o0Aa4s46ncbraa3fOkgfyfUe23akEz7R1ZkdziDc1rEvdxmIDbizM2KCGZrGdkZtTnL+XAQQnf6oBIJCziSfHUTPPL3rwt77aGrxgwwGzKAmEpg49eUhGoohwUAi0b7iHkCmtZFnHw07PXZ+NqLKVNY3HNywFGHO9czKDe3CNr
 TH2nDx4E
 lxlrEAcpmYcS/G1PSmPBetc66RXCja1Q97JObqXv7gcuC4xT+jNA7GxGrUL3wL8jxXda3k2PyKL0lU4FxyikiKwUyE05ur+UtLiFRY7ljvq6w4l7/DqU+j4qQaKwRVfNfDa7MHAuOsIZpON+/YiQj0Ck3iQhqRtIl2xE3ECBLL8z4n0y0/4PJuJvqhrLD6A8tGP680Lu1LfKbQ7H58C9XXWlFbRiDksP+4FISYWVWxGKWLdg+C7KOj02ZiexS9vgkQ7c12OjYWRJkcw2JiZlQxA+Wlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Wed, Apr 29, 2026 at 03:39:14PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Gigantic page allocation is somewhat broken currently when KHO is used.
> 
> Firstly, they break KHO scratch size accounting. RSRV_KERN is used to
> track how much memory is reserved for use by the kernel. Since
> alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages
> allocated also get marked as RSRV_KERN.

The intended semantics of RSRV_KERN was to distinguish memory reserved
because it's in use by firmware from the memory reserved or allocated by
the kernel. It does not have to be directly used by the kernel, some of
PG_Reserved memory is mapped to user-space and it's not only hugetlb. There
are zero pages, VDSO and maybe something else, I don't remember.

> Allocations marked RSRV_KERN are used by KHO to calculate how much
> scratch space it should reserve to make sure the next kernel has enough
> memory to boot when it is in scratch-only phase. Counting hugepages in

The size of RSRV_KERN allocations is also used in
memblock_estimated_nr_free_pages() that's currently used by
set_max_threads() to set several rlimits and by s390 to allocate colored
zero pages. Excluding hugetlb from that will skew the calculations there.

> that blows up scratch size, and can lead to the scratch allocation
> failing, making KHO unusable. This will show up when huge pages make up
> more than 50% of the system, which is a fairly common use case.
> 
> Secondly, while not supported right now, huge pages are user memory and
> can be preserved via KHO. The scratch spaces should not have any
> preserved memory. Allocating hugepages from scratch (on a KHO boot) can
> lead to them being un-preservable.
> 
> Introduce memblock_alloc_nid_user(). This does two things: first, it
> instructs __memblock_alloc_range_nid() to not use scratch areas to
> fulfill allocation. If KHO is in scratch-only mode, allocations will
> only be made from extended scratch areas. Second, it removes RSRV_KERN
> from the allocation to make sure it doesn't mess up scratch size
> accounting.
> 
> To reduce duplication, introduce __memblock_alloc_range_nid() which does
> exactly what memblock_alloc_range_nid() used to do, but takes the flags
> from its caller. Then make memblock_alloc_range_nid() a wrapper to it.
> This lets memblock_alloc_nid_user() re-use most of the logic without
> causing churn to update all callers of memblock_alloc_range_nid() and
> adding yet another argument to it.

That's neat :)

But I'm not too fond of the memblock_alloc_nid_user() as a concept. That
early at boot everything is still kernel, even though hugetlb pages might
become user afterwards if they are actually consumed.
Another thing, is that adding such global API to memblock could be abused
and suddenly some early code will clear RSRV_KERN for a random pieces of
memory.

If we'd still need a special memblock function for gigantic pages
allocation I'd rather make it explicit that it's for hugetlb and keep it in
mm/internal.h

I was thinking about possible alternative solutions and here's what I came
up with

1. SCRATCH_EXT nicely increases the memory pool available to memblock, but
   the decision which memory can be used for which allocations becomes more
   complex. It should make sure that SCRATCH is not used for hugetlb, but
   OTOH it's preferred for other early allocations. With implicit
   interaction between choose_memblock_flags() and should_skip_region()
   this seems to me quite a headache.
   memblock_reserved_clear_kern() should be changed to something else to
   keep set_max_threads() working. And, IMHO, memblock_alloc_nid_user()
   should be turned into memblock_alloc_gigantic_hugetlb() and only exposed
   to MM code. It's even possible that it will duplicate some of
   memblock_alloc_range_nid) rather than use it because hugetlb is always a
   special case.

2. Split memblock_reserve() part from kho_mem_retrieve() to run before
   hugetlb allocations. With this we won't need new types and APIs, we can
   ensure that hugetlb allocations do not use SCRATCH by reserving scratch
   areas before hugetlb allocations and releasing them afterwards.
   Obviously this is the slowest option as it will slow down all memblock
   allocations from the point we memblock_reserve() preserved memory. Still
   realistically I wouldn't expect large impact on performance because the
   heaviest part there is reserving of the preserved memory that has to
   happen anyway. Also, I don't thing that a system that uses a lot of
   gigantic pages will have a lot of preserved chunks scattered around.

3. Move the complexity into hugetlb and make it preserve all the gigantic
   pages with KHO. This means, though, that we won't be able to increase
   the number of gigantic pages after the first boot (although decreasing
   it seems easy) and that we need to let scratch auto scaling understand
   what were the "normal" memblock allocations and what were the
   allocations of the gigantic pages.

4. Invert SCRATCH_EXT logic and instead of freeing large chunks around the
   preserved memory to SCRATCH_EXT, reserve memory surrounding the
   preserved areas and release scratch_only before hugetlb allocations.
   We'd still need to somehow prevent hugetlb allocation spilling into
   scratch and there's a nasty piece of releasing the memory around the
   preserved chunks. On the bright side, I think it's feasible to defer the
   release of those regions and free them when we are already
   multithreaded. This probably the most involved alternative but it also
   could help with the bottleneck of kho_mem_retrieve() creating too many
   memblock.reserved regions.

Thoughts?

> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> 
> Notes:
>     Checkpatch complains here about the alignment of arguments of
>     memblock_alloc_range_nid() with open parentheses. That can be ignored
>     since the code already was mis-aligned, and for good reason.
> 
>  include/linux/memblock.h |   4 ++
>  mm/hugetlb.c             |  19 ++----
>  mm/memblock.c            | 138 ++++++++++++++++++++++++++++++---------
>  3 files changed, 116 insertions(+), 45 deletions(-)

-- 
Sincerely yours,
Mike.


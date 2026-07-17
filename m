Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C5DC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699696B0099; Fri, 17 Jul 2026 12:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672EE6B00AC; Fri, 17 Jul 2026 12:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE916B00AD; Fri, 17 Jul 2026 12:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 104796B0099
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:04:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2DFDC012D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:37:18 +0000 (UTC)
X-FDA: 84998370156.18.6723BEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EEB0220005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:37:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B1JoYE6/";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295437;
	b=Cr4ExYgTEtVzRJvpfZMx8eUGyN1QdlS007jh1XBE0c6C1JV3jIqpJae8ntS+vW1or/xUOR
	Am2Vs6q7HllJLst267a/8VM1Ay0TIarX5IR6k6fEnvi5i1P9951i/GE1mj8upVcss2dHLq
	zZb7JM6muSvYRvhsB8g+xDPkMn+j5+Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B1JoYE6/";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48oZHUU9fg5G11xfD8S7BpPTRgtHVfmfE+3MIs4yOlk=;
	b=CsTMBcDtEOtM4/KwSMfEBvmPD5RtjHVqoFpBASpXLeAQxHGMFQVCmL32B5t2gBONC1Ppdf
	0EmXn7384Ec+RIzh6lU/QHKV//UkATdSOJejPggUkPtYIZC96OjxkLQrrSE7+HThkrDCqV
	75CekPU6IVKHCS797RmwUXJ8Vt9dt7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BADAF40F2A;
	Fri, 17 Jul 2026 13:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E971F000E9;
	Fri, 17 Jul 2026 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784295435;
	bh=48oZHUU9fg5G11xfD8S7BpPTRgtHVfmfE+3MIs4yOlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B1JoYE6/cI4a/HhoKKJga2jG7TaHxlh9BO31Wzd30QRDmAUUuhdDKaPO+KQFmDzGr
	 UaNLtY+uvL6eeiYZzlfq9kTGRTmM7qeAyAMmS4OoUl2E9nU3jbUmQj9XPkYqkAVyuo
	 C9sro9NMD1RdviV5z3fvQ3S5fzciOS0kBPplCpW7Nq2/b5MCeT8tlVzP4kMBFMJgkY
	 zy+8jRm0+WjeR1+nsuVXPelT/mHEe6AZ91AG3hF7UgDBda+9+N02mzxbTCNbEHRuP1
	 wKDc7t0MBHqG6IwvYJ9m4qyRMr7UXKOOzeSmFcBNszFrkrFFVQXvZgUw88EdLYF+Nb
	 c0p+B2wwb/EHA==
Date: Fri, 17 Jul 2026 14:36:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>, 
	Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
Message-ID: <alopMtyPYdn7vDoC@lucifer>
References: <20260716173504.760369-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716173504.760369-1-noren@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEB0220005
X-Stat-Signature: 7kfy9d6aw1gy7nesky3axpo3jzow8ei6
X-HE-Tag: 1784295436-308250
X-HE-Meta: U2FsdGVkX18m9Dv2YVFx6K5Lu4AeVjpztfDRP8TVC4OefalspJ5PWx8SHdtFZHo4Hjv+fkxQLqMLAieyAVwawNupCvMG6WkFuhnz24S2NV7OchJh+V+38ONalOZOlQSLW9jHdxmXKbNaQVv4j1f3bUTmDtQN7RELSyiw56JfJA7x/lXa8HX91ApK0hDGVKMuDqbelKAfvyyV9524jCAgVp+YZ5grsEw0Yd7SZga6KUaN0PGGnugR3snLQ3nio+1KAXRXM9YEFE2Pc1ZuXfZ7DwnUL4JLELtmXWERy3EHgSJpSpAkObLtp6XNd5/znKj/LElz/ldz0+swcTlD51dYzxWne5esoeNgmZ/8sULbUDNB1EjMklvIICTGN/zLZdv+THX1und8kEe/F0Oi1u0/9Sx9AB7dmnoIPUVbejKkam9NJ01+eG4lwTN+MgdaOS4lQENXCzVO0295UXHSuKNMpEghzu4eTh1Ftmg1YQzDKeRTBwE23jmEStDFG00CEKDLVlP8ajDmH4Jnm3FHYeT0KUoAmC/CKX9agwGXwOgte2flWEzBPQPAPNivi5YRqSuUjb8/V1cyyKBPu6Tw2WlWyH8kIpoa6ElymnPIfgeT17kpJdT6nzQIB3WC3NAi2DGoAXGdCMaAQCWdMPfG9PVn4e+zIKsKdemkbZKUSSezpwq1dx2Jea5sDVKonj2Ir9KBOo1276aB1kBD/D17AIEaPUhfwI9eS6e9vi1XBs+gAaIKgybOOOv8lxmBaoFqMq1gO4Ko5EJdyPWZ/fMRsVh2GiPogOJ72xhRkNHbv/nwplGCLfH0PcAlkJ5uqaxlKueaTxy3qvAKcexfIyIXT70w0bGO2FSKGzpXJVTzIrKGmNAKfWilYKSeD5i+zwQp7aW2ft5klenFgNxh1RTOPomdXmUQQ2TRyn1G6EHQk+XFhG142UYc/ce6eLAKQVLQxpINhDJiGLJ+rgawTApSSOR
 fi5puMFb
 S5+Lq9DZT/+45WJuexvypoykxWEedUAnV0R5JTlAPSqPZxlfJgCva38S312I530fxBIqZ1NbAnYx8cfPX+hXpG/YoT46QmsGdu6azwFDufwB6mJaLNgjZMSHTNbHohWAPZfi/QyXLlH/NKdYHTVsAULzmuJRcTGOJs8eZ4xqhHNitBec8wrxpSbGEvHEzv5a8RPscOrWH5oNx9oK2/HqRJZT9wG3GVhe48bSeixyH4ZyVmlKluwVYOoi8kOc4c4lnNN7IjCpoiUu/RAKS8zqBDIgWOzoRRQWo59sPI90kbfIQd65KIyzWhwtOZle60GuqJi71Mhv5dLFDw4vlR/oNSiRwQevQJNBsoc6UOUS9jFfojZQGPB3cyYnnd5zdmWkfSB/IhFW7rojTdaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 08:35:04PM +0300, Nimrod Oren wrote:
> When THP is enabled, khugepaged can raise min_free_kbytes through
> set_recommended_min_free_kbytes(), using a heuristic that scales with

Nitty, but that makes it sound like khugepaged (the process) itself comes in and
changes it, rather set_recommended_min_free_kbytes() sets it higher if
hugepage_enabled().

> pageblock_nr_pages. With MIGRATE_PCPTYPES equal to 3, the formula
> accounts for 11 pageblocks for every eligible populated zone before
> capping the result at 5% of low memory.
>
> This is reasonable when a pageblock is 2MB, as on common 4KB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
>
>   4KB pages:   2MB pageblock,   22MB per zone
>  16KB pages:  32MB pageblock,  352MB per zone
>  64KB pages: 512MB pageblock,  5.5GB per zone
>
> The 5% limit does not make this harmless. On an arm64 system with
> 128GB of RAM and 64KB pages, the current calculation resulted in
> roughly 6.3GB for min_free_kbytes. The corresponding aggregate min, low
> and high watermarks were 6.3GB, 7.8GB and 9.4GB.

Yeah this is an ongoing issue (as you note below). We definitely need to find a
better solution.

>
> Automatically maintaining multiple GB of additional free memory to
> improve the probability of 512MB THP allocations seems disproportionate
> for an opportunistic background optimization.

The fact it's in khugepaged.c doesn't mean it's just about khugepaged, it's
about avoiding fragmentation for the purposes of obtaining THP pages which can
also be obtained from page fault and MADV_COLLAPSE.

>
> This RFC proposes capping the pageblock contribution to the
> recommendation at 2MB. This would limit the contribution to 22MB per
> eligible zone while leaving configurations with pageblocks of 2MB or
> smaller unchanged.

I guess you're trying to do the most conservative thing possible - but it's a
bit of a cheat really.

I mean does it really make sense to reserve 2 MB for the purposes of obtaining
512 MB PMDs? It's essentially giving up on the idea of getting PMD THP
altogether but pretending you are still doing so.

I wonder if it wouldn't just be better to explicitly check the page table
size and to not even bother trying for > 4 KiB with a comment explaining
that it's not a worthwhile trade-off.

I think that'd be the more honest version of this patch wouldn't it?

Or maybe we need not be so concerneda bout scaling across zones...

>
> Earlier proposals to resolve this problem involved disabling default
> THP on affected systems [1], adding a knob to disable the
> recommendation [2], or deriving the recommendation from the largest
> enabled THP order [3]. A fixed cap requires no new knob and avoids
> large changes to global watermarks when THP policy is changed at
> runtime.

How often are people turning THP completely off or on again though?

>
> Reducing PAGE_BLOCK_MAX_ORDER remains possible, but it is a build-time
> policy that changes pageblock granularity globally. Its effects extend
> beyond the scope of adjusting min_free_kbytes.
>
> [1] https://lore.kernel.org/all/CAPm50aLPxJCiVTqqwiz00oMNiqHggB84sXB3x=tv_HUAd5UktQ@mail.gmail.com/
> [2] https://lore.kernel.org/all/20230817035155.84230-1-liusong@linux.alibaba.com/
> [3] https://lore.kernel.org/all/20250606143700.3256414-1-usamaarif642@gmail.com/
>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Thanks in any case for taking a more pragmatic approach here.

> ---
>  mm/khugepaged.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 27e8f3077e80..c0570bbb1f4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -23,6 +23,7 @@
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
>  #include <linux/backing-dev.h>
> +#include <linux/sizes.h>
>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -3066,6 +3067,7 @@ void set_recommended_min_free_kbytes(void)
>  {
>  	struct zone *zone;
>  	int nr_zones = 0;
> +	unsigned long capped_pageblock_nr_pages;
>  	unsigned long recommended_min;
>
>  	if (!hugepage_enabled()) {
> @@ -3084,16 +3086,23 @@ void set_recommended_min_free_kbytes(void)
>  		nr_zones++;
>  	}
>
> -	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
> -	recommended_min = pageblock_nr_pages * nr_zones * 2;
> +	/*
> +	 * Limit the pageblock contribution to 2 MiB. Larger pageblocks can
> +	 * otherwise make min_free_kbytes disproportionately large.
> +	 */
> +	capped_pageblock_nr_pages =
> +		min(pageblock_nr_pages, SZ_2M / PAGE_SIZE);

Yeah this just feels like a hack, to be honest "let's pretend a page block
is 2 MiB" essentially :)

> +
> +	/* Ensure 2 capped units are free to assist fragmentation avoidance */
> +	recommended_min = capped_pageblock_nr_pages * nr_zones * 2;
>
>  	/*
> -	 * Make sure that on average at least two pageblocks are almost free
> +	 * Make sure that on average at least two capped units are almost free
>  	 * of another type, one for a migratetype to fall back to and a
>  	 * second to avoid subsequent fallbacks of other types There are 3
>  	 * MIGRATE_TYPES we care about.
>  	 */
> -	recommended_min += pageblock_nr_pages * nr_zones *
> +	recommended_min += capped_pageblock_nr_pages * nr_zones *
>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;

we're really getting into faking stuff out realms here - pretending a page
block is 2 MiB then doing calculations on it as if they were.

We'd be better off (and more honest) with something like:

-	if (!hugepage_enabled()) {
+	/* Avoid excessive memory reservation if page blocks are very large. */
+	if (!hugepage_enabled() || PAGE_SIZE > SZ_4K) {

But that seems perhaps unwise.

Maybe a simpler version would be to just attack the issue we actually have
with it - it uses too much damn memory :)

So maybe something like the attached? (you'd probably want to make this a
sysctl or at least a defined value of course)

General idea is - if we're going to cap, let's just cap instead of
pretending that page blocks are of a different size.

>
>  	/* don't ever allow to reserve more than 5% of the lowmem */
> --
> 2.45.0
>

Cheers, Lorenzo

----8<----
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..d9e1e7de5494 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3092,9 +3092,13 @@ void set_recommended_min_free_kbytes(void)
 	recommended_min += pageblock_nr_pages * nr_zones *
 			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;

-	/* don't ever allow to reserve more than 5% of the lowmem */
+	/*
+	 * don't ever allow the reservation of more than 1 GiB or 5% of lowmem
+	 * (whichever is smaller).
+	 */
 	recommended_min = min(recommended_min,
 			      (unsigned long) nr_free_buffer_pages() / 20);
+	recommended_min = min(recommended_min, SZ_1G);
 	recommended_min <<= (PAGE_SHIFT-10);

 	if (recommended_min > min_free_kbytes) {


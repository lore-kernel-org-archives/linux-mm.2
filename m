Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65CEC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9538F6B0088; Thu,  6 Aug 2026 01:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904D16B008A; Thu,  6 Aug 2026 01:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842EB6B0092; Thu,  6 Aug 2026 01:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFF96B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:47:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 236EE1A0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:47:15 +0000 (UTC)
X-FDA: 85069761630.11.12C1581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CDC92000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:47:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArIOnnkM;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785995233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dh5HntgmPOrDA8E9mM/SfdAeAFp52+cx/9yS0SyOjk=;
	b=TXHge7upaMCRZZL63JtXBsXaUa1v9VJH+7XxmfZUzZRgyGhdcnq+DL+DDOAo6/sQI7B9Oh
	bkRzjkpCM4JPZqCAy0ZOZM8oqTSSpng7AQ18CzktiujgL0rZ9WBtF4rmISeXV4JRQMaPdF
	s6b5oBmnAJacGU6btvxjjVh44EKu78g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785995233;
	b=PzgXdcoxvHM2Yz2HDeF8ZnzV8AoZ58IaPS35aXrx8KnNII+w3SHoSOmA0W6uEgbbk47biy
	ilsqgL9iXeKFaGFS9eATjdxhuVg1EIw13ecDvHeLZc2om4RTypf8p6tyQaG7DAfCu1MiE7
	bU4DPS+pRkypT+AMIyzvX+IH0rEdRoM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArIOnnkM;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A44204021B;
	Thu,  6 Aug 2026 05:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2A81F000E9;
	Thu,  6 Aug 2026 05:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785995232;
	bh=+dh5HntgmPOrDA8E9mM/SfdAeAFp52+cx/9yS0SyOjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ArIOnnkMVw7FNhrwjpx28FW6lVCGzzdxx4kLG1BXHeK6y7vcuF+ot3gREJKYOyTWu
	 BmakfSD0x5J39gM1gqS0/o8uCAYzwIc1CD8XG2sEn1a6IvAH09LxQfvOE9gneRgo7o
	 somaGi/84Y5GlVtZQYQ6DlSWUhTc7pk2dM8BC3wd007/BnnDcz01Flgc2PQklBVD0g
	 MymeUHLwFiDRsl2mv8J1E3DBDs8hahhqSEu2bjD/jBhBuEM27JwgbFtNF6lh8UkMi/
	 kM1n+xiViVSenXNY1BZWJ1gcd3lGx8yBpcdwUl29B6MOSoGfQc2zVjIganSpxQp8HC
	 T3QVaK/dLUvbQ==
Date: Thu, 6 Aug 2026 08:47:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Graf <graf@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Subject: Re: [PATCH] mm/mm_init: fix out-of-range first_deferred_pfn
Message-ID: <anQf2kFzA63_3ayh@kernel.org>
References: <20260805224421.15794-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805224421.15794-1-graf@amazon.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CDC92000E
X-Stat-Signature: r3oodmncu9i14smjntcxcisbhqc33uq9
X-HE-Tag: 1785995233-29733
X-HE-Meta: U2FsdGVkX18rX6NDmtRx0sh2IyjGtHzLl1juMdhIynanFYBnEp7PJW6rEkgKwHmDkNc9phHHr+0ibE8r7cdjgI9/TaHD7GlM7f/bYZLfMiMXM4QRaDtunbqlYtywOHnpTkvBGvx2LlXyBzlkyvZcZaFRcgWkE6GsJ7gW0ZaV3OrDisyxFkIIUkNUBuWNxUpuImXgor7pMUBUfuZQ+tqKAKF4M+xNBH4e1SUi/sy27E+tKoKEkygfrPJEAH49ftaUm6PWPJXCfY+ErZA3B3HIToG/HZoDQMiwPSefDXAOqijMdb24S88NenYIYhS3PxXgh/Utw+gFg69C1HQNMk3qcjnN43QXR3OdBHyBDJBJFsy2oagtBomvzzWe+l41FxcHsQNps3+HlMVZZEQl01aZwVrtNfipngFhOmeBVv4WyXoexiRkZBL3X1NqaviPDvwsEQpM0EJV+xACCye0JjtQMRs7CWRmVsoBXXj/IwODHi82T6CDNMnd8/xMsTBx9u+lxs2JHL9IKGxtXMMUEg0Q8PU/zFRLJbFt6tcUByyirxS4gjWpdee/u43BBPGkliUvbK4vfLroRmW18rBcpIIZPJdzRWIpFbBGdJ0xu9P50kSPils2v+APFyz7R9TSQaRdA87L+gtrh8qTJDkwx5kuVb9kjoPdteBrKUJhowvRmDwCAv2QNv7xkGMf0OexejkN0Sxh3gbo5IV7yDYBk2ngfwA3V+gyiEPGToqFlgm6HPHG8b/afIr9HeHvrKn91kbIKRi7BZilsLWwiBQ6XLEeQV9tS1+JITp/u577Qet1rfEG9jDoYpnOWBID14yp+7ogNklnin/z/TJrvOmGYcM0YoHJNSIQ3f6GNyBvJNlomrDfjm5O/khDIcF2Of/8YuMeJGKu6tGPUdlGK1gPio2MI7XYBtdQizruBsBjxxbs6tFXL8RN49ZLc6kxMjDpR7MUAEGWtJHBOd3YXWHbRvN
 F/sPj8HR
 cDKVlAmdQfTz89DETTwKKsPvZgZXahP96UF5SKXJ+fLCIFRfvzEE/DoJ3wtVc+LbDZ4Xjy+UcTQ6PGwA8wPQa9jiM3WxN00+qLhPGV493XNRZ/TD3FSUUJ9fxFGrpTeYdZcWvGBE4BuKGUoAycIj7/2DAZqkiTuNZIYzp7fxJjxKDfKxBRrfOb0K0mncsfUcTqZRdsJ9W+1KTEHHIYCFUIxRyMidVk0U3q89JhvKU8JQF7vo+EHVBZiyx7jbyqwDEnpZ1pARNWZPuKeiqU6+OHYuqmObzoJ7oGFIHUBQt2vJCt2/CBETzSz38JVzqR6VpHrW1yrQw8tXGNs5/jbs0Ok70ztorJ4kS8uB/kxTTGk5bApn90bV7IJ9cyJ6Fmf8aonVcwnlC4anG2VSktTr38yAS1o0i0SAtg2gjSLb/84FVcp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alex,

On Wed, Aug 05, 2026 at 10:44:21PM +0000, Alexander Graf wrote:
> deferred_grow_zone() initializes deferred struct pages a section at a
> time until the allocation that called into it can be satisfied, and
> records where to resume in pgdat->first_deferred_pfn.  Reserve most of
> the top zone early (a large CMA reservation is the easy way) and a single
> early allocation has to walk the whole zone instead of stopping in its
> first free section.  If that zone does not end on a section boundary, the
> pgdatinit kthread then dies:
> 
>   kernel BUG at mm/mm_init.c:2131!
>   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>   CPU: 3 UID: 0 PID: 36 Comm: pgdatinit0 Not tainted 7.2.0-rc6 #1
>   RIP: 0010:deferred_init_memmap+0x1b8/0x1c0
>   RAX: 0000000000236000 R13: 0000000000238000
>   Call Trace:
>    kthread+0xdf/0x120
>    ret_from_fork+0x187/0x250
> 
> RAX is pgdat_end_pfn(), R13 the pfn that was stored.  The loop advances
> spfn in whole PAGES_PER_SECTION steps and only tests it before entering
> an iteration, so once the walk reaches the end of a zone that ends
> mid-section the escaping spfn is SECTION_ALIGN_UP(zone_end_pfn()).
> Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in
> deferred_grow_zone()") dropped the clamp that used to prevent that: epfn
> came from __next_mem_pfn_range_in_zone(), since removed, which capped it
> with min(zone_end_pfn(zone), epfn), so spfn could reach zone_end_pfn but
> never pass it.  The assert is fatal either way, panicking under
> panic_on_oops and otherwise leaving page_alloc_init_late() waiting
> forever for a completion the dead kthread never reports.
> 
> Store ULONG_MAX once spfn has left the zone.  Nothing is left
> uninitialized: the loop covers a single gap-free interval, and because it
> only enters with spfn < zone_end_pfn() the escaping value is exactly
> SECTION_ALIGN_UP(zone_end_pfn()), which is the last_pfn that
> deferred_init_memmap() would have used for the same pfn range.  A zone
> that does end section-aligned now takes this path too and loses its
> zero-work padata job along with that node's pr_info() and the WARN_ON()
> on the next zone.
> 
> To reproduce with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y and CONFIG_CMA=y:
> 
>   qemu-system-x86_64 -enable-kvm -m 8032M -kernel bzImage \
>       -append "nokaslr cma=4768M@0x100000000"

The only two paragraphs I understood is this and the BUG splat ;-P

Can we please have a lot more of human touch on the changelog?
 
> Top of RAM is then 0x235ffffff, so ZONE_NORMAL ends 96 MiB into its last
> section, and less than a section stays free above the reservation once
> the early memblock allocations are done.  The walk therefore runs off the
> end of the zone and stores 0x238000.  Sweeping that free remainder from
> 96M to 288M in 16M steps, an unpatched kernel dies on 7 of the 13 boots
> and a patched one on none.  On an 8 GiB cloud instance that reserves most
> of its top zone for a memory pool, roughly one boot in three panicked
> before reaching userspace.
> 
> Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
> Cc: stable@vger.kernel.org
> Assisted-by: Kiro:claude-opus-5
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
> 
> Notes:
>     Applies unchanged to 6.18.y, 6.19.y, 7.0.y and 7.1.y (checked against
>     v6.18.39, v6.19.14, v7.0.14 and v7.1.4); the deferred_init_memmap_chunk()
>     signature change in cbbbf7795fc3 sits outside the hunk context, so stable
>     needs no separate backport.
>     
>     First seen on 6.18.y and 6.19-rc distribution kernels.  There is no public
>     report to link, hence no Closes: tag.
> 
>  mm/mm_init.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 498d62c4ece3..91177be58a00 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2214,10 +2214,13 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>  	}
>  
>  	/*
> -	 * There were no pages to initialize and free which means the zone's
> -	 * memory map is completely initialized.
> +	 * The loop only tests spfn before entering an iteration, so on exit it
> +	 * may point up to a section past the end of the zone.  When it does,
> +	 * the rest of the zone has already been handed to
> +	 * deferred_init_memmap_chunk() and nothing is left to initialize.
>  	 */
> -	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
> +	pgdat->first_deferred_pfn =
> +		spfn < zone_end_pfn(zone) ? spfn : ULONG_MAX;
>  
>  	pgdat_resize_unlock(pgdat, &flags);
>  
> 
> base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
> -- 
> 2.47.1
> 

-- 
Sincerely yours,
Mike.


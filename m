Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA05CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 04:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65FE8E009D; Sat,  1 Nov 2025 00:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D169D8E0068; Sat,  1 Nov 2025 00:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C531E8E009D; Sat,  1 Nov 2025 00:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B31B88E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:51:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48DBAB716A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 04:51:52 +0000 (UTC)
X-FDA: 84060815664.01.77991BF
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id 94A1E4000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 04:51:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761972710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9cyipZczHoPDtWHm7/aK1U4qYAJtUWjxiCa7fQADT/g=;
	b=ZBg2Hhj61Ggk4DlF5sEIQ6GzXdpo1h9xgFgK2w4acyomosi1snCIpVSJaKGcNVSGb1OJvG
	1nmfYq1m8oZajB2f10+vw3CU8RtXMpuMb+00FQ0a3M2s7cR4vzu0Rl5iSdp/NZHfOPaxqV
	gtVNeZng5dMUScEaR588M4DOZ/fYubs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761972710; a=rsa-sha256;
	cv=none;
	b=IMq7IgLxql9gzje4HmXr60jTP0mbIi5i8QBLoENYmCTpDOZ2tyBxX5GkH0dP+Fh8Z3eVl5
	yDYiLLgOo2KIl94XndSpWzJ0USDYZQUbpOs3eucAM9sLPDBcMBUAg2Nls/R/u9hKeK+78t
	YUo0iSa+N6ugC2GBZAIfIMq+hi6ECzM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Nov 2025 13:51:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 1 Nov 2025 13:51:41 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
Message-ID: <aQWR3fK/GtTkx0kX@yjaykim-PowerEdge-T330>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 94A1E4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: qwgf5qsqm33ji3h3oh4xjo1panmm9ueb
X-HE-Tag: 1761972708-599571
X-HE-Meta: U2FsdGVkX1+oVp4ZQQTe7bOj24wtMz1fJ5XB92pZ3E4IbpRb6X9oLpR/aS/MTupV9UHlOxr/ta5a56xFIU+miqXxOjs1upiALEbtu1VbD5Rmr1nim1UuHfEduGJWMYdcwapUhPp0grEXURR0gbhA72PJbPBQ7wYRKZlZ9CQYX47eVzHCt8D7gOK0nKVDO6ZcMlMzNqBVzexyL223LTDb7AOefATE+pHli8uvvoEp8SyLweaYYCUp/7sAtcIDHzYtVQ2DYbXhu/ToouHmn6eLj8j2lZoHzsohhmjd2qeVsbvHMxGqPsfEnu85D/8VhUMsfdcxXxzyPvD6fJzbxEAj5nzkcD4VgqOuIVXAxCWp5jKzXfbuUb/OH7AqmZbwWukhG5xlgN96Q0mA+wgnEsJfEmsjGaLEBPG1sEU0LgjzcwNkQyzRl9uM0eyNXMH7dGixquxot6JHS2WtsPWRptfcFa2aQHLhUggdiFKSHrJ1iATG+xhNRjkApGrP9Wy8snJl87J0hfSqjpcn+moQXN6pRe7trLKEcFx9aK1rOgz//xS2Ofv536qSV3COz7PEwaA+wi6kEjXtCMaf+fC8P8kF0pi1fy0rSvbCbxcFr42Ciq/CB+Es57f+PgIGtH2TY/mmEahnB2svLZXQlMgVayCC8XZ4cDnxPPf+YHsHlZyEAL7oG5p1YdSBJUSUEaR8OZToRebYmxkWvJ5jKStL+DiJlMykBgGpOOHbZS8GyF2ALql1GQnda+lcwpQPMSWVUiF+gIUjWzSPuh29R2lW+Q5Ysxc0XjEBdc9TLedo0jUJ8R95kriuYSG9UQpakSGvrhuAknZRdIUeLAtSj6YVWwD0M3PbeJLnvKY56sRK/aatOT023QR0JXZ/1V3+3jGqpmAQoYHS9ci1+S0F9bAjwWa+BYh9uvUTtXBmmijZaCJvqmVLW3R+AOIx5Z4IQ9TRpjor/bva7SXiag8o6qh5IzC
 w9sbNinb
 A1pck/9qdvRkSAsDP99VX7iGe/tDQdrgn7fJ7XlSUSUWWojF/USynOOnAsJlUQFdRBamA22jACGOBk+M3HE/t2c6GJdI8haV7MVdW/fWW7BfmqaaGCbZW7duQjSgecfldOkDCh8ihC1PNZzLCKa7hHLUuCYTUJ3oj4BAebgf+sp9+EXvgN6ZyIffC/zPDszxcty2fL4pYUlEuPhr8Y8T3VVJPNkv8JNshpJ1af/nlhkn32h5j0qH9BXrnnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:58:40PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

Hello Kairui!

> The current swap entry allocation/freeing workflow has never had a clear
> definition. This makes it hard to debug or add new optimizations.
> 
> This commit introduces a proper definition of how swap entries would be
> allocated and freed. Now, most operations are folio based, so they will
> never exceed one swap cluster, and we now have a cleaner border between
> swap and the rest of mm, making it much easier to follow and debug,
> especially with new added sanity checks. Also making more optimization
> possible.
> 
> Swap entry will be mostly allocated and free with a folio bound.
> The folio lock will be useful for resolving many swap ralated races.
> 
> Now swap allocation (except hibernation) always starts with a folio in
> the swap cache, and gets duped/freed protected by the folio lock:
> 
> - folio_alloc_swap() - The only allocation entry point now.
>   Context: The folio must be locked.
>   This allocates one or a set of continuous swap slots for a folio and
>   binds them to the folio by adding the folio to the swap cache. The
>   swap slots' swap count start with zero value.
> 
> - folio_dup_swap() - Increase the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This increases the ref count of swap entries allocated to a folio.
>   Newly allocated swap slots' count has to be increased by this helper
>   as the folio got unmapped (and swap entries got installed).
> 
> - folio_put_swap() - Decrease the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This decreases the ref count of swap entries allocated to a folio.
>   Typically, swapin will decrease the swap count as the folio got
>   installed back and the swap entry got uninstalled
> 
>   This won't remove the folio from the swap cache and free the
>   slot. Lazy freeing of swap cache is helpful for reducing IO.
>   There is already a folio_free_swap() for immediate cache reclaim.
>   This part could be further optimized later.
> 
> The above locking constraints could be further relaxed when the swap
> table if fully implemented. Currently dup still needs the caller
> to lock the swap entry container (e.g. PTL), or a concurrent zap
> may underflow the swap count.
> 
> Some swap users need to interact with swap count without involving folio
> (e.g. forking/zapping the page table or mapping truncate without swapin).
> In such cases, the caller has to ensure there is no race condition on
> whatever owns the swap count and use the below helpers:
> 
> - swap_put_entries_direct() - Decrease the swap count directly.
>   Context: The caller must lock whatever is referencing the slots to
>   avoid a race.
> 
>   Typically the page table zapping or shmem mapping truncate will need
>   to free swap slots directly. If a slot is cached (has a folio bound),
>   this will also try to release the swap cache.
> 
> - swap_dup_entry_direct() - Increase the swap count directly.
>   Context: The caller must lock whatever is referencing the entries to
>   avoid race, and the entries must already have a swap count > 1.
> 
>   Typically, forking will need to copy the page table and hence needs to
>   increase the swap count of the entries in the table. The page table is
>   locked while referencing the swap entries, so the entries all have a
>   swap count > 1 and can't be freed.
> 
> Hibernation subsystem is a bit different, so two special wrappers are here:
> 
> - swap_alloc_hibernation_slot() - Allocate one entry from one device.
> - swap_free_hibernation_slot() - Free one entry allocated by the above
> helper.

During the code review, I found something to be verified.
It is not directly releavant your patch, 
I send the email for checking it right and possible fix on this patch.

on the swap_alloc_hibernation_slot function
nr_swap_pages is decreased. but as I think it is decreased on swap_range_alloc.

The nr_swap_pages are decremented as the callflow as like the below.

cluster_alloc_swap_entry -> alloc_swap_scan_cluster
-> closter_alloc_range -> swap_range_alloc

Introduced on
4f78252da887ee7e9d1875dd6e07d9baa936c04f
mm: swap: move nr_swap_pages counter decrement  from folio_alloc_swap() to swap_range_alloc()

 #ifdef CONFIG_HIBERNATION
 /* Allocate a slot for hibernation */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
....
                       local_unlock(&percpu_swap_cluster.lock);
                        if (offset) {
                                entry = swp_entry(si->type, offset);
                                atomic_long_dec(&nr_swap_pages); // here


Thank you,
Youngjun Park


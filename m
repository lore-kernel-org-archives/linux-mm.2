Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96005606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BYjIgXqm
Received: by kanga.kvack.org (Postfix)
	id BD6876B05B1; Wed, 11 Nov 2026 08:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD3C6B05B2; Wed, 11 Nov 2026 08:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3C36B05B4; Wed, 11 Nov 2026 08:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE8E6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:18:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E92EC02C8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:18:50 +0000 (UTC)
X-FDA: 85422893220.25.778DB88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7059AC0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:18:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYjIgXqm;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794403128;
	b=P79aHuUnkbuqPZzFu7JA0AckdxlTf7wLptzaw+CWpMvgRbHpQLYwzmijT/buXrN32MK0jb
	DiVZLrhTr6nVqT6v/eBAd3yHhlXB0DXp4vSrEXF9z80QBIeaHvd78aDKdsSLG+jcm9I5FA
	iPbHP8Tz4LKgl7e6JuDVHEGMYmNd7Aw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYjIgXqm;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794403128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJdMLqafvm+KLuD5FOpLe+66ffjiV7oq+8GZl6H/BF4=;
	b=c5LhE6ZDcxQF+F5tI9gXYUZ2OU1yKuYBz3v8SE1Lc54QrVzQ6vIRKYERcOy1cBugS8Cj6Q
	8SskU+WaXRokyvVDYk03aWSwT1FfwCNwYWj7XcbKJ1d3McXquP+wWZajJ+SDBSwa+uud5U
	bJFrY9E7NMgJBxpQfAHnZPsZmenULoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D70F40AD7;
	Wed, 11 Nov 2026 13:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399BB1F00A05;
	Wed, 11 Nov 2026 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403127;
	bh=SJdMLqafvm+KLuD5FOpLe+66ffjiV7oq+8GZl6H/BF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BYjIgXqmUTZ8jphCM7ZVSg+9kJZ/A8NSQH6cCyu49g0npTqO7d4B5pWdaUVgpEEt1
	 1zlNN6EeZRYIOInLKPYt8bUYiVmaTmKtUmmXia3UcHEgOHbH/CnSAC44P2m+4bxmBs
	 Bl1HJww6+ivIptjbxmlzj7+47WQ2Tl6AZBBqIOwZz0UAjhq/RvajrtQpmF7hpODpVb
	 JF45vFpiVWpbFS5KuCh2QwhKiuINj25lZMSBRX1dtRiv2iAXTnjF0teipAPZbMK/sf
	 2cgoZibsgq28uhG0B8ykmcMCsRg1LYMn8wYfE141pQ8u0ic2ny50cb+at0i6Ce2fqJ
	 DIckyzgJQ4OlQ==
Date: Wed, 11 Nov 2026 13:18:36 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a
 hardware-poisoned subpage
Message-ID: <avRqaatdOUunxrcZ@gremlin>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-2-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111113904.650722-2-usama.arif@linux.dev>
X-Stat-Signature: 69of91nkths4so1tkzpx7bwn88zz6933
X-Rspamd-Queue-Id: 7059AC0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794403128-275760
X-HE-Meta: U2FsdGVkX195l5i3ypjW7irqLxzPrYqPU1v6uCJK43LYsi3+QRWgq3U8OnXNnJnCJNiZG9NUWTL6aX0VIF/fIs2G4z20REv3VnJgqYMdq3h2jGv6CUsqCvKfKm/CAGyTOYczLU0xu2jw0azDw/f1Xk6bghwoLJ1oFiyjyhMtwmX0nJZRLs4WRczNicKWKQN/EBx1ELi0oz/OAhte6yxiOZ2JWiAnGPyPr8ldcxVdFFIg7Hu1P9eIXjgAtGclRa3HudRmxBBBGjTdNDp5q2Dw2t0a/++cklL9Ty5mU4o6ikE9e4EI+h7ZsxUW1NQOrYubhEeGBd3j7KHK3DUUO+B0cHg5iYlYpU7A2Cg0rW52TolHiXsfDEzWUUkHYtBs/I7o56zyDQ40bO0MYr7OQN3gR0h8Z+OxqBNLNlXuc32XQlDcAL56D6n8BGAHTlV0U9L0wm6ePME53uTVt1A61FNiW/qh0T9TuPHcqDqJBfe6BM95w8qvCpTXgvvy7DndC+bC4fFfQixzVC0xE6x4wH60pDAF+tiDQJiDhKHF5uqa4r8rQUYuPOuo7MceNdDys7c5yvgFNbclathhm4TVd6bvOhn+Sz3TsAKJa3Qc0hSMwaUB4XTSfGv7k7AZmCjK17TiDjeHfKQX47LaIDZumzSZu9HT0avUwwPft4/7uWKtkNnX63Lpj7DAIyJ5guYwMU6qgbb6cfkegbc9kaXD60kVDW2FYkjLgx3eKJk07cBd0LZts1s//bAFZUHH91VjfgEp6wudedMTy707JJIjAo7gUgl5V1pILRSeFWIAcJKHC2bhM4YXeodWUAPstufNkOdxgEiMqKrOiHIii63vkyKuJYezPAvglShibVoMdtR0l2/SKwr/KGOopRS+2KpsvwT7aGcLxILtIyAmxXm4T6ENMIF3vmdRDVCX75VfYY97Kq/YS5f1TwZmiqogD5/ZQB4JhvScjC3Oyzx6AUxAkfY
 yHYPrY9f
 fBJw8X6fsJU8BkXnfrH3TD+BTG9Mzp+3VjB/XgVkaYyKNo3P+JUuo7l+NjiXtr39N8gnKIrg065TFM0NSp8vjd/dtjq/L9hWrHfPSuaersJa95OF/28KFpt0nuPrDraVP7RRvwnM/1HClIg7VpQAbG0a4KL8YrCn0yT9ZSN9LRR2Rz7BFqPycaNcjX/ecQnrqZtwOM8ite3AXb47aCuV2l7zOty18Wood7Ha+h79MAdDTskH+2ORHkckMI5ShnXECxovuQB86SjcFKm081I5t4EABZbsjgBXc08IylBgQCbK9UC4YPR7FOVfuO23eqVWPXon6X1WmNHGLFgUoauHPG85tpNLNiLDJkMEu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:38:29AM -0800, Usama Arif wrote:
> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without looking
> at the other subpages. A poisoned subpage that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
>
> Skip batching for such a folio and let each page take its own fault,
> where the existing check catches it.
>
> Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
> memory_failure() sets PageHWPoison() on the subpage first and only sets
> the folio flag much later, and the bail-outs in between - for example
> get_hwpoison_page() losing a page lifecycle race - return with the
> subpage marked and the folio flag never set.
>
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/internal.h | 15 +++++++++++++++
>  mm/memory.c   |  4 ++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index cd3675c044e0a..e61c02f4019b0 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -28,6 +28,21 @@ struct folio_batch;
>  int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
> +/*
> + * Check every page of the folio for HWPoison, rather than relying on the
> + * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
> + */
> +static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
> +{
> +	long nr = folio_nr_pages(folio);
> +	long i;
> +
> +	for (i = 0; i < nr; i++)
> +		if (PageHWPoison(folio_page(folio, i)))
> +			return true;
> +	return false;
> +}
> +
>  /* mm/workingset.c */
>  bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>  			    bool flush);
> diff --git a/mm/memory.c b/mm/memory.c
> index d477a4f986bc8..4b7d456332200 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
>  			goto check_folio;
>
> +		/* Let a poisoned subpage take its own fault. */
> +		if (folio_has_any_hwpoisoned_page(folio))
> +			goto check_folio;
> +

Hm, isn't scanning every single page in the folio potentially quite costly
here?  I thought the point of batching was to improve performance overall?

It seems broken to have stuff potentially interact with hwpoison but then
to only set the folio-level flag much later?

Also why are we swapping out folios containing hwpoison pages? Shouldn't we
migrate away from the hwpoison? :) (I'm not really familiar with the hw
poison stuff)


>  		page_idx = idx;
>  		address = folio_start;
>  		ptep = folio_ptep;
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo


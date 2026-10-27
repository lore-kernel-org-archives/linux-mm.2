Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC56606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oKfzWY26
Received: by kanga.kvack.org (Postfix)
	id D8F676B0656; Tue, 27 Oct 2026 05:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41136B0657; Tue, 27 Oct 2026 05:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55116B0658; Tue, 27 Oct 2026 05:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2B36B0656
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:33:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20A2840992
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:33:50 +0000 (UTC)
X-FDA: 85367894220.05.CD122DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8AB5840009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:33:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKfzWY26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIudMcxLM3PAXcDR9AP1Q8SoYHkkEJyeOudQMB7zZi4=;
	b=y4nfKncaB7/wmO3SF2as7J5j1fG8zyGcckUyebKjWYpaXbyqcaUnA90u6Mb74HWJPCK2Tz
	pQFcVm6yxT0Kw6QqByDvF9i9mug79NLi8xqe3LGQ0YmB4UbwuhT2g/Tk4YWrY7CpXszj6s
	KSqPvZAgn/AeQfw7bhpuW86cuGPniAM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKfzWY26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793093628;
	b=xCXldiQB6iqSxkxl61o9s22YHEfErZm4w2ZrzRetg36ZABFqDIAGAAHw3rObNT6q7OvgI+
	xTxarJ71YSRANEbUNlKgOUNoo089ZVI0OMF04nC6+IxkCXru0fVycR2naDC6OnbAyqggCi
	dGdJK66iOEaYRH3nQbfFE31/StH9ZgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D5AC60136;
	Tue, 27 Oct 2026 09:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095811F031E4;
	Tue, 27 Oct 2026 09:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093627;
	bh=gIudMcxLM3PAXcDR9AP1Q8SoYHkkEJyeOudQMB7zZi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oKfzWY26WKA+bbXl616ae0oQzbA1G0xH9l9xh1gCxq3JDpe8yv97IXYdyOfHQ4eJr
	 t81Po39gxIf/641f8WvuMrH0lH9eqiO320Dz8AtVuz8iZU3projZTXWMccoEocNd/6
	 dh/GTbiarJBXfnd4LASC1pYnYHmLhWpnrmbzH4mHnkutHY5LYB08EzCW/mDgGMPsGa
	 qOAll772fgvtDpz0InhCuO+wST7Gz+w1BkWkocfnh9yOov6hzmvFdgw6+D2H+bUwyj
	 Zopnno5uue65TWC1px1FoMLDq3bw/n2ASl+8B3UapPHEfEcHiQNOqE7pRfjn9OD0/j
	 SZDcHaIh8SkjQ==
Date: Tue, 27 Oct 2026 09:33:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 27/46] mm/mmu_notifier: finish non-blocking interval
 invalidation on error
Message-ID: <auBvqDY8yyLk_UTm@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-27-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-27-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 8AB5840009
X-Stat-Signature: nqd6dhndjy8wmnuz7jxrdsnen1d8u866
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793093628-531218
X-HE-Meta: U2FsdGVkX1/UYOSBaER2nA53LU/ojEA1g/a9gr4hDR8RK7Z87lWVM47yBcLwcuJ4Tm5TLmJ72k7Q7LNrvHL7TaftWsBr3U3n+1A1c5NJnknU88h11twnhZlHOi5vu+ylTf5pmqXoGCVdCSSzAlcohukY+OFuAKToBl3Iejk6bOoKE4ooh+QukCmMnGXzF1H5WjujletE6X0v8gcXWHKcFLxjW+3qC6fdqTYaK01N9OI07QRKG9ZORlDTbU781/+PX3k6E2K+trWiBpaYV0ZnWyy9okdc87fIK7Ly+lWl3xyObUrYLr0eUYhDqGX+BzvA/P+UZSTpB1Y0CXGrqeQyXndCWNGFR94iYyehAaUw0Exe8vbtc8CptXjnN/7US/2OTlbOxwBl8GATdaMe/s9Pih+lYUFChA6k2Jl3L0tl+KQELC3VGJ11N7ZOMWhQ/WXmcpOXGuTPIQ4mZSOmkLHh1hQevJQExh1zB97FYQKH7/HJXtQe67SpZ/ThLsXM+bUUNPVMuM6VgOybc9j/CBiTAN5aAAf0+pqIlzfDdjZ3LOJ6XJCi9imPk/eKDmoXTAO5STFCLmdN548OB+erFGQvu26qAKT3BxILptTzDsJfyL/UkPmfTJGchXQCev801jfRgsY1BPUfoOJxgS+Qb7+UE3wkPAl0VWu+EfwsJO5i/GPCG48I+4OoDZ1EgZcoe+HAI3Pjj0P9u++b/4+Tpuhi6Xr2FBdsdvKRyNL6Qr3sZEuWjp76xG+dM4JZ6L/CcbF2GuCmPkMsH1nriKTMBKjkjt1uaKSf5nDaYpQcorvBceIutJPK6JQj/yywR4yLs2TIAfZIt4No3ZXRYDXcpMLKCEWXNmWjc+wzPx/o8f+Ng46R4TfmjlHqw/fD7hR4excG9HxL0r6Kljs84DBYbk0HmXfgMeJ7oqiydsKA5ymLovr0Wf/c8t/6WjNXcaP/2dveNGOZZ2B7kwTpKuzJkoB
 DNMYCC88
 Qs1EbH3mdWhDTjSIEQNmGYJA5GwgAl735zlyrOzaM/fgv77nqc3besw45m44MDW6VIXBGI48KA5f6EcrbQBy22uRRJkG+V6FrKDRDwQwhBxNb4ZLTG+O5CWTanuCeck42B17SJ8YsKUtVfgFlC0bFb8SA3r551jumh3ILvKn1Fur4mnshquYh47QI73HedGZHaexqKxIyKweTGxiSi0XHcSoUNS/t3KPl0gZOoNO3hCjgj9dsTKkEr6gN/Jm7q/BUwRUbXlotYfa1sWAdMoMAlVy6F3nJA/lMA/G4r9mHWNtkFsHiqjgnbgM0NMnCxsN6ou5cuYgcHN7tg+uK5PsZ6x+BBEu0D2JaUaJsu1Agqf/hHPwydwseUUg55HdzABGB8O/srvx+kYnWD4hx3Orf3q1Jf04bNQV78tBB4Hvop47z8A9Eoktb0xFUggymEvMvY9DTmGAMaq4OhJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:47AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> When an ordinary MMU notifier rejects a non-blocking invalidation, the
> interval invalidation started beforehand is left unfinished: the caller
> skips mmu_notifier_invalidate_range_end(). Subsequent interval notifier
> operations can then wait forever.
>
> The only in-tree trigger is nouveau SVM, which uses both notifier types
> and rejects non-blocking invalidations. Reaping via the OOM reaper or
> process_mrelease() can therefore leave the GPU fault worker stuck,
> holding a reference that prevents the dying process's address space
> and memory from being freed.
>
> End the interval invalidation when an ordinary notifier fails a
> non-blocking invalidation, like mn_itree_invalidate() already does when
> an interval notifier fails. Make that handling clearer in the
> documentation of mmu_notifier_invalidate_range_start_nonblock().
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: simplify description, update function doc ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mmu_notifier.h |  3 ++-
>  mm/mmu_notifier.c            | 17 +++++++++++++----
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index a11a44eef521e..5db78e5761c5c 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -483,7 +483,8 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
>  /*
>   * This version of mmu_notifier_invalidate_range_start() avoids blocking, but it
>   * can return an error if a notifier can't proceed without blocking, in which
> - * case you're not allowed to modify PTEs in the specified range.
> + * case you're not allowed to modify PTEs in the specified range or call
> + * mmu_notifier_invalidate_range_end().
>   *
>   * This is mainly intended for OOM handling.
>   */
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index df69ba6e797f7..2e20f88e162d7 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -569,16 +569,25 @@ int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
>  {
>  	struct mmu_notifier_subscriptions *subscriptions =
>  		range->mm->notifier_subscriptions;
> -	int ret;
> +	const bool has_itree = subscriptions->has_itree;
> +	int ret = 0;
>
> -	if (subscriptions->has_itree) {
> +	if (has_itree) {
>  		ret = mn_itree_invalidate(subscriptions, range);
>  		if (ret)
>  			return ret;
>  	}
>  	if (!hlist_empty(&subscriptions->list))
> -		return mn_hlist_invalidate_range_start(subscriptions, range);
> -	return 0;
> +		ret = mn_hlist_invalidate_range_start(subscriptions, range);
> +
> +	/*
> +	 * On error, the non-blocking caller is not allowed to call
> +	 * invalidate_range_end(), as in mn_itree_invalidate().
> +	 */
> +	if (ret && has_itree && !mmu_notifier_range_blockable(range))
> +		mn_itree_inv_end(subscriptions);
> +
> +	return ret;
>  }
>
>  static void
>
> --
> 2.43.0
>

--
Cheers, Lorenzo


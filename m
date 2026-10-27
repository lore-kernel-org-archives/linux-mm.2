Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8A7606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cLX5cty9
Received: by kanga.kvack.org (Postfix)
	id 48C0C6B0635; Tue, 27 Oct 2026 04:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463576B0637; Tue, 27 Oct 2026 04:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352D36B0638; Tue, 27 Oct 2026 04:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2696B0635
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:51:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E7D61609A3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:51:06 +0000 (UTC)
X-FDA: 85367786532.23.7FEF119
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DFCAD20005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:51:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLX5cty9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc0U5Ze+hBCT9T6cAf8QTcqfqTu5UwDLhLRH+Lp9NjM=;
	b=kEJ9wk6usjd0U0GfAx5LT1sI7X7L1xv9aj0IMxQig7ZFn9rQBOn7XUSqLlYfwDwCkcUrdK
	bkrX0hGZDzjqCnbH+qTE+SiwbQog05f3cVTbAXuIXw9KsmbPAa6HXrTiqzpUU7Si76/9vP
	egnjxJL5r8nWF0CNe+2wnZFSz8n3Av8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLX5cty9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091064;
	b=xuxJUkiGtQfJ4pL6DMpYd2iIp7CJWhQWYRk0vXxnqDhN8p0KgAW03kKbSnj2LhM3KGe5E0
	IlwInJTOAsa8ASzJU7rvdd6IoVv1weVeNVcuNWbPP5z1RqU+SNko/E096CdXurLYdXIPj2
	iq5ecTtPvcrf9OO6bpfDwtRUCL1/Vas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54517601F9;
	Tue, 27 Oct 2026 08:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370ED1F01825;
	Tue, 27 Oct 2026 08:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091064;
	bh=lc0U5Ze+hBCT9T6cAf8QTcqfqTu5UwDLhLRH+Lp9NjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cLX5cty9Fes4nyGOhdTXTwUi4CjHh2d6Exjv+rOUNmJ1hOpq301ah/59VYJa3KAfa
	 0JAFnIYv5q6uCZJiWZ7/JnzC3pOPhPL5VdEq05fzYEQAfU8x5PjoaLGCbo4oJkSshy
	 aEyuswfa3kOJCEFW345rfcWjsyhvaijqqaHgik6uB7QOrxdB7sJV1oJ6I3Q0c1V+Ry
	 Cf3Ekq4j3MW2BWPpctWVOXD4r4MRy4tI0wpG7A71nGLVk4q5d74j9EcT8h6eyujZ5T
	 xnvfCFG95f/Qz4H2P0ATu2ppTZylFpdC3r3f636dunxIG7AvtZ7dC6rCzDfglAN4g9
	 pK7u8ZerdMAkQ==
Date: Tue, 27 Oct 2026 08:50:46 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 28/46] mm/mmu_notifier: set ->mm only after mmgrab()
Message-ID: <auBl3iJyp0RQ-tEA@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-28-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-28-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: DFCAD20005
X-Stat-Signature: 5617u7t5f6d7r7984oenjbt5k5urmjxb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793091064-280901
X-HE-Meta: U2FsdGVkX18jCUrtPMeqrA8jeayj+3+LzDQ+sYBTUnkeNv2bdEZEIJMZLDuf5n1K6YTQULSfP7o0q/HyauKSlF5sFlCwKOTaz41ClfyJXaH7Bt5sqzr52O4bzMerlf68tKToL+QTzYVlxgrvWBof6+qbk5COU+e0TzuYzUgjNIPsyjqVOOErUan0dWVFhQs4sn6qCl6HabbM/5dosRMlVZ3XYQoSH/pHh2alqgaIbrS4hydPEUydZtJPJMfZ2IQ9r2vPl2I3P/omtbVyk5u4l34cuhrt1rSJYJCxe0LnDg1N3CP/8aHrA9ej2o77DoWr7OmAWzTc/ElxQUl8IN2bjZ7qDoImNoOBFcdF8wDgWYD4ZO9EFdWnKRLpO/zJwDF6wJgfW64FuP6TNk26v5OaxhhTYS4Gf4cI3F6P90xc/6jV5e3tQElpZzUo2ZMIfqc8LCBW6wprtov9Rxd1YHusyJ+Xa0KciaAETZwDhd+1yRQHOXRUBq708rTkeEdpyYX1Dh4jwlcdXn9ZiBK/yBUV3pNMwQApC2ez1rd9ZhEDhqbBtYhlSgtcdNA8usAEZ3TSHfHc4ETZtH0oBEnYs8YAwdkbMDKyyXXAWX+kkXyvufP5dXl9JpnUBoO6Zvxo+7N0wDIQ3bkv6Of6M9GHn0A6CUEZdUq8PVmjbPiWymS2EKWdVUakHdYflTErGysKdBBnHwtoPIE9pSu2FgssI2qz3S3y+wDagGxYDklxxHkVIidkb7ZEnziVUqh39miDH+AQ2FA/G/DhC5LkcsuqHvKRMQWEM28Lb5f8r/g5ZatsJBbXQw8Hq/h8twr+LL5/ONmIbIAWZDbDW/yi4cCjS5Bub+rWXbN9TXuW4AD/j+I9dY7iNFQG9hrp2OktuVqABCEB7lAxucBPWHpcsqYF65oMmIfVMTI5cIUIANWp/H6nXMwJp1D3UNoqi/EWm/TgOJ9DaM3OeLbxOnowbelb8SE
 TZBNkNLV
 C9kwn/lVPnTVXRpSfQGd3Zg94jDARv8ed7JRmJVMRlkqU10BmG0oSDbrUEU0726jiigA2DXEni+3p/PYUO93Qwu4kirxnjkSRGTxP8Q5QwqAE5nEUDNPk67wIyFuoV1CphDmfhoilR2EziKUyohyJa1Em1qBXRw2Dzz39wGAQziFlJjjdSYYHo9T2T2KxlfuTiCceFP9muuSMrVdjyNBraRRmvymhTrQeTzAl6NeVjfD+vjLHk01bL8JhXxwY826b00bZF2adFvzM9tWtx6H70WpCpINQrSP/1S4DY5rU9ypntLG6ArT2Gg0JhfulDJV0+ERqMJrHRUc+0yb/9jrSABJtOprmFG3jrFyq3AFDNexU+nqSe5Dccejp3kI7cQQu+UXwIewbXSjJ6eM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:48AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> Radeon uses a non-NULL notifier->mm to decide whether to call
> mmu_interval_notifier_remove() when freeing a buffer object.
> __mmu_interval_notifier_insert() sets ->mm before validating the range,
> so a wrapping userptr range can leave ->mm set after insertion fails.
> Cleanup then tries to remove an unregistered notifier for which no mm
> reference was acquired.
>
> Set ->mm only after mmgrab(), once insertion can no longer fail. While
> we could fix radeon's code instead, setting ->mm on success only makes
> the code more robust.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 3506ff69c3ec ("drm/radeon: use mmu_interval_notifier_insert")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mmu_notifier.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 2e20f88e162d7..a7bae5de5fedc 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -947,7 +947,6 @@ static int __mmu_interval_notifier_insert(
>  	struct mmu_notifier_subscriptions *subscriptions, unsigned long start,
>  	unsigned long length, const struct mmu_interval_notifier_ops *ops)
>  {
> -	interval_sub->mm = mm;
>  	interval_sub->ops = ops;
>  	RB_CLEAR_NODE(&interval_sub->interval_tree.rb);
>  	interval_sub->interval_tree.start = start;
> @@ -964,8 +963,12 @@ static int __mmu_interval_notifier_insert(
>  	if (WARN_ON(atomic_read(&mm->mm_users) <= 0))
>  		return -EINVAL;
>
> -	/* pairs with mmdrop in mmu_interval_notifier_remove() */
> +	/*
> +	 * Pairs with mmdrop in mmu_interval_notifier_remove(). Drivers take a
> +	 * non-NULL ->mm for "registered", so set it only with the reference.
> +	 */
>  	mmgrab(mm);
> +	interval_sub->mm = mm;
>
>  	/*
>  	 * If some invalidate_range_start/end region is going on in parallel
>
> --
> 2.43.0
>

--
Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F98CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 05:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7586B0005; Tue,  9 Jun 2026 01:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197E16B0088; Tue,  9 Jun 2026 01:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE026B008A; Tue,  9 Jun 2026 01:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F19556B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:34:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CDE61403F2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:34:46 +0000 (UTC)
X-FDA: 84859259772.12.5A8AB07
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58C34A0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:34:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bgrmiMVR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780983285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mfjWRsQdGdiYIf88/4zuTnbWIV/8IAFDOhF+AeSMR0=;
	b=x8e83UsdAu3xFv9VqMQkpnPjWMPVhjImTjZLqnbLOuQhO0li/WCwWnpZ/yu9VGsJ453M5j
	CMTzgoJm6xDyiRFkRQZVCG0d56jHoV2LYDdAgpUbVktUgtCkBE1HWO1Nggak9BCVJk/KFX
	Or3tAulvBNt8fHQyh9anp5VjHXRAktQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bgrmiMVR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780983285;
	b=TC7Bf1dfP7Zwk7ukipzk8gTvsKs36T/NPTXYhVIlL58rWgCMdh7YTbup7eE0Wu/VvnJw1q
	9zHS0YwKq2KdRWKNNmQO9t/OpbHBO2kHifwU9akqTUvpQkccnDz+eLBst/EmBSstl5t6NV
	Ez7VN6oMltKO+jQM9jTfv/sNw8ZP/LE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3252B169C;
	Mon,  8 Jun 2026 22:34:38 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 396DD3FE53;
	Mon,  8 Jun 2026 22:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780983283; bh=kRP3VSO1BrC4vri0+L29KFGhsjb25YswCQ3fFsgsieI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bgrmiMVRYCu1CJfKKQYjTtR+oniRzXdVYTtjXELlorPtcvHGcmC5HzH9x+CbuzRVr
	 s/+NqoTK+Sm17mnqBQAkkeU9C0IlkAJtc8Y1ufP7KRVMey8WL/5D+dQeVcq7hyRweA
	 g9KMu5ACf9OOMHGT+HGDlDO0zvXlGp9gZpfZpuIE=
Message-ID: <996a1f61-3b59-40ef-9508-ef339cc0c931@arm.com>
Date: Tue, 9 Jun 2026 11:04:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-4-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260428155043.39251-4-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58C34A0002
X-Stat-Signature: exasn8s6dj3herod8pamznaxtw8tmws9
X-Rspam-User: 
X-HE-Tag: 1780983284-127951
X-HE-Meta: U2FsdGVkX18LAyaF+7FnjtMGm7yN3lEVLk9RLJzhReV48ctVkiKvXyXOEpC31Yej+FtheZleW2FxKyjiNFpKVLy3SZ7duUqWI5rZJHF3zBtDRp7cvuuTfqg5zBzWN0gdMBEXh+kiCeVZVshrk0dE8bDA6OAAfgt3uvOx/cbLy68cIZq93XNro26rwLra7BPQb7AG2b75LU1XRvv/B2sGDJ5T88/Il9EJ0SVxA+gFFa7qYDtDmLxG2FSR115evsq1kFYn6e8OB/76JDObJnRDwjHqY4M9WyydhyBI5V+tkkouBCqGZ83OsEDmuK0Cc0oia3SEncP/in++VVdbE8pQeq76r0FkHmSOYffwe2dAHOm1ytg3wvGAMZOFTT8AqnA3qaOzozMMb57M7b4cwTX82C80gH0Dpnkw5LHujrGaOjAXyidh132zd63PYi8c87RM+1R5oAAZS35eDUnVf1jKpNWfkU4DQWEy1w1soa+LuWLiJw4UMhctF7sa9uWh2H9U5TNZ3RtvMWkgnJHpdF8nY3aIWdXFQJmZTa4Ww3VmNG+b3L8rJHHCE8jdH3QZUMdc+MzpvuSK85sumdiEIdCUV/O6Yc+yfZN+sn6sYYJCWioajoUDEAjZyUdGorD0OyehQfwDpNJAvSmbCQnpSyr1uE2f/KPG9LjJfZx13sso84JB36qybYTFui9qdKBDqZyu2GyxHrW2GSe85QIQ4BtA44lIbDXxaXYVsV/2oDMbXU8NeTIheEv0u4FJT08iqkI1BQHV3hYT3xIpAagAvNxO6DuyDvg/iiyADb9NwT9ExZ5H6DMZZWESgJon9vOQpo527oj8rx+UuniKgJXQEXzHqUvvhSgf3IM45Oo+FkCViOcoJgBxsu/Mg3QVQhfpgvz550YgkmOFNmPDhKSLl0yda6X0qsHrFtDZaPL9op7AA2HhRS9EfGskzXBNbcDkivagXgGAJX4MTzRQQjhfe5J
 04RboXjL
 c4W7WwMLtGz7NSVRqrqhoxVv8cRYyn83bQH6nlkurlkKGDr3RHXpOIo+zAbbLE7UCW3rbENHe21gX40V8QXEghoTh6PYF07G5d0uRHozxWUZKvBTC7uBMX8l/zy6G/AwSU6/S75MyrNEN+dD7vmKQCx9IlpVwjPZLMf9Z1h6Hwje+NDTZg8CPajfU0MPXnjlwTj2CCUbPmp/1b19I6Sg6MVfonrDpCBlrOqy/MXuTEZqF1FRxwpSHO8hWMOtcHku0Mo6Dwu1wtWxyIiHunJoopOyp6npjMcTHiwAab1+L+8haexlG36Hs5uJCvTtyv6YDo3swM/vOdSLrPTCDSRu53Pa9Vjc8bl7wnDmC0g0JWfF30wO2yO6aL9ijt61PstdtGlt6LRv3llTYYTXa8q0zbG6G0j01yaNDTCgEnvcW/N1/IU2yJ8PDJlqBhRJfCEiQwsTVF3Ko+GMF++U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/04/26 9:20 pm, Shivank Garg wrote:
> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.
> 
> No functional change.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

migrate_folio_undo_src() has a parameter "page_was_mapped", change that
too?


>  mm/migrate.c | 48 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8a64291ab5b4..0c6a0ab6ecce 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1135,26 +1135,24 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>   * This is safe because nobody is using it except us.
>   */
>  enum {
> -	PAGE_WAS_MAPPED = BIT(0),
> -	PAGE_WAS_MLOCKED = BIT(1),
> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> +	FOLIO_WAS_MAPPED = BIT(0),
> +	FOLIO_WAS_MLOCKED = BIT(1),
> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>  };
>  
>  static void __migrate_folio_record(struct folio *dst,
> -				   int old_page_state,
> -				   struct anon_vma *anon_vma)
> +		int old_folio_state, struct anon_vma *anon_vma)
>  {
> -	dst->private = (void *)anon_vma + old_page_state;
> +	dst->private = (void *)anon_vma + old_folio_state;
>  }
>  
>  static void __migrate_folio_extract(struct folio *dst,
> -				   int *old_page_state,
> -				   struct anon_vma **anon_vmap)
> +		int *old_folio_state, struct anon_vma **anon_vmap)
>  {
>  	unsigned long private = (unsigned long)dst->private;
>  
> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
> -	*old_page_state = private & PAGE_OLD_STATES;
> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
> +	*old_folio_state = private & FOLIO_OLD_STATES;
>  	dst->private = NULL;
>  }
>  
> @@ -1209,7 +1207,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> -	int old_page_state = 0;
> +	int old_folio_state = 0;
>  	struct anon_vma *anon_vma = NULL;
>  	bool locked = false;
>  	bool dst_locked = false;
> @@ -1253,7 +1251,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	}
>  	locked = true;
>  	if (folio_test_mlocked(src))
> -		old_page_state |= PAGE_WAS_MLOCKED;
> +		old_folio_state |= FOLIO_WAS_MLOCKED;
>  
>  	if (folio_test_writeback(src)) {
>  		/*
> @@ -1302,7 +1300,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	dst_locked = true;
>  
>  	if (unlikely(page_has_movable_ops(&src->page))) {
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_folio_state, anon_vma);
>  		return 0;
>  	}
>  
> @@ -1328,11 +1326,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>  			       !folio_test_ksm(src) && !anon_vma, src);
>  		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
> -		old_page_state |= PAGE_WAS_MAPPED;
> +		old_folio_state |= FOLIO_WAS_MAPPED;
>  	}
>  
>  	if (!folio_mapped(src)) {
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_folio_state, anon_vma);
>  		return 0;
>  	}
>  
> @@ -1344,7 +1342,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	if (rc == -EAGAIN)
>  		ret = NULL;
>  
> -	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
> +	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
>  			       anon_vma, locked, ret);
>  	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
>  
> @@ -1358,13 +1356,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  			      struct list_head *ret)
>  {
>  	int rc;
> -	int old_page_state = 0;
> +	int old_folio_state = 0;
>  	struct anon_vma *anon_vma = NULL;
>  	bool src_deferred_split = false;
>  	bool src_partially_mapped = false;
>  	struct list_head *prev;
>  
> -	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> +	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
>  	prev = dst->lru.prev;
>  	list_del(&dst->lru);
>  
> @@ -1404,10 +1402,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	 * isolated from the unevictable LRU: but this case is the easiest.
>  	 */
>  	folio_add_lru(dst);
> -	if (old_page_state & PAGE_WAS_MLOCKED)
> +	if (old_folio_state & FOLIO_WAS_MLOCKED)
>  		lru_add_drain();
>  
> -	if (old_page_state & PAGE_WAS_MAPPED)
> +	if (old_folio_state & FOLIO_WAS_MAPPED)
>  		remove_migration_ptes(src, dst, 0);
>  
>  out_unlock_both:
> @@ -1439,11 +1437,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	 */
>  	if (rc == -EAGAIN) {
>  		list_add(&dst->lru, prev);
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_folio_state, anon_vma);
>  		return rc;
>  	}
>  
> -	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
> +	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
>  			       anon_vma, true, ret);
>  	migrate_folio_undo_dst(dst, true, put_new_folio, private);
>  
> @@ -1777,11 +1775,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
>  	dst = list_first_entry(dst_folios, struct folio, lru);
>  	dst2 = list_next_entry(dst, lru);
>  	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
> -		int old_page_state = 0;
> +		int old_folio_state = 0;
>  		struct anon_vma *anon_vma = NULL;
>  
> -		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> -		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
> +		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
> +		migrate_folio_undo_src(folio, old_folio_state & FOLIO_WAS_MAPPED,
>  				anon_vma, true, ret_folios);
>  		list_del(&dst->lru);
>  		migrate_folio_undo_dst(dst, true, put_new_folio, private);



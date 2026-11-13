Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD2B606BCA9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9NBiz5E
Received: by kanga.kvack.org (Postfix)
	id A68A26B05B3; Fri, 13 Nov 2026 11:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15316B05B4; Fri, 13 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903876B05B5; Fri, 13 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65CFE6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:52:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFC381A018F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:52:01 +0000 (UTC)
X-FDA: 85430688042.25.EC5E066
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 32BAD20002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:52:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9NBiz5E;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794588720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81quoW2k6mkSDxYpTE88hQE+QCAzt8EVUIrXpu/NyGI=;
	b=epvn1Ec7Fa1clHvyx2qDcbfsfb5pjS28rIMmsWA8G16OlwfVkPEf9czFlyLX9NMyb1Q8Zu
	l296HmjN4ifexgEVZKFb8+40jERiEJKxzE2W4USzn/Zks82Z8n2SMpW2Tjc4+tu73uUHM8
	xbeT4oDRLgqc42moQedDWwJce8IGxII=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9NBiz5E;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794588720;
	b=DxK3B6tNUqS4yVprWsQaPE8IiW3Md7XS/SW0UFEn0OJSJ0EmnJ3JYD7AGqOMmHkQ/etut6
	OecvolrAgw9AVGz/Wj2oEivdXfpigID95nISJrlRLRr73FxrM3n5tOXnnuwUwIdvei7+T/
	wEpzvEqjcOODmYYdCNiSJCA3o6oEWMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E6DE62943;
	Fri, 13 Nov 2026 16:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894FB1F00926;
	Fri, 13 Nov 2026 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794588719;
	bh=81quoW2k6mkSDxYpTE88hQE+QCAzt8EVUIrXpu/NyGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I9NBiz5Ez+6wD7BoiSuyCOpwYabWH6Tc+DIbRwOfmaFkVxjlGU1HLSJnNaHmRRP80
	 4dSTNWtZcASxOZnARC9aL326QrmjIphlD5ktqfN6DleZsc71+FnVmXMzf9NMp4DxJf
	 5skgrXJToSDLBf/SRPOLahwKLBZpY412K7LqbeDaFOIMtDUYDxclaXX72Z7MFcHrEV
	 HUBiNE3BOVxZXnhnbWngWcgVG9+1xSWPV1Q6rpPEwxObOBjyU9U0PQypDVY0tglQjH
	 bPne5i8xJvyA4Rl+csRrHbyPIWyem3UxnqoZXudhJZU/ShslJw6AS7NCBcxJjxT+Hh
	 IBpdh9cnB31Kg==
Message-ID: <7e82bf2d-3a36-46d4-b63e-6b6720620380@kernel.org>
Date: Fri, 13 Nov 2026 17:51:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261102093939.3340540-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: toux51s8fnppnq8ejah1f4dbiqz1s3s6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 32BAD20002
X-HE-Tag: 1794588720-44313
X-HE-Meta: U2FsdGVkX18e5LG6eXNiEiccp8WDUQiA5Aywc7Buj6xYXvZoqKEQLxkpfF8VacL2qMzrOvRUwtr/Y+nBbK+DdoQVjCGvYaKdeMaPJTJ4+PGam7Z+4PdjPuYcWITpWMzCKeWtHuad3XrHVjW5LhVJY8pKgXtfYOUIKZfAwrj/auulLRviUi7guZYPmr1LjfLMDAcL8SIvCbHQGEJO/+M2KZR/Bv7AQaW83Gnttae6XvSqKYPY0op1TgbC1sWSK84pPIA+j7BTicaf+F1Zp3qoYHeYCZpAcyauS361sp0jZP84FByB1oSrL4cVgoBERuYKqnkdAc9Rq9O4a616+PXVI8Lrb3H2fvQsVif145n0EHu8uNWJw7hBVm/8RHnSD2Re69jf0WZnLVMFOVz5hs9NGmDTSf0CqUW19PIb6YAU5HsmuYvrNul2lTThtjGxjXMqnVZaGxLd1ymc1bUTmT3sk76UcMP3yi2LJVUtAQ8a8BQpT6HObBaaVpPFK9OLMJSJvs3Y+EdEFuLxovnKJjfvuEA+jxJ8t7lqfZwMShZJ/W9azxvZP+O+Elg19z4D9HTKZ3cMMZx4MHa1Kv6Nszw7qG9e3j5g4YW+PihEMiaNTtwbGLF5UWvzDNZuqE7Ekg74uPenGcPG5sCZaerrSLi6yDw4r5EKYTOu+4e9bgHqmXv7xIoUJbdtqM7CM8bVlAWgiTFDmRFmW3Q6svPXvcQmQId4SOaAJQR0ikPWhJccc6gFotAKwI9v3xYhxZ+BoX7fMy79VmioQx03nHYbU+2KQDHk30/lE1zySnGq8aE0Al0dtu9PY//sKHX3sqL2ohEyg9ln8AjVUD/KxOx4ZjX9qbbJN4Ejv76AjEu/grUxfW9E+SQv3qeP+fbsNWWbx/4HTB70BYgsHOHg7QeGB4JRM74ryac5GP1w+x2CGhC3bQTY7W+5LGrBIQ9x38+lUz0pP1ifrU7GpwNTxoRJHuQ
 A5r4quNf
 Gu6fSdx8UfvTIURW7RO0V3eiwnDMe4bBOq5Agl11pzqZhO0G6KRfSyCvjGKbY404NtZu6R9CdxvK1mC5BPpl2H39gMtkIb4REQ4jVlm0cUW3S87Gc3FuPMWWNaQzmDD5F1Iar9LTagMrOAfHTVAg3f8a+qgzzFRcCJCr/FsTrJ3ZrqdIa44nwqZdUGHAVyvHIj1yjUtjL9mQygsZ4I4eazFd3Oktx+AnKpVAtHkCytdN6+hB5pja96jcUbOGMNN3CydL9mU6F2SMaJ2hj3+hvyAiXgHxG7Y02gED/yGw/QmB+dockowL1xvIajQKQQytwvNnkScGf4uYhWQ4RJ9MoavtZj9fvkCBkyiH6mnTINM7QCL2nO56LWUS2fIxfJhjvGlQiUgM1vgQb78c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 10:39, Kiryl Shutsemau (Meta) wrote:
> The high-order check in __zone_watermark_ok() accepts a free page of any
> migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
> only take a page of its own migratetype or claim a whole free block, so
> the check can pass when the allocation cannot succeed.
> 
> Telling those apart needs the request's migratetype, but not every check
> wants them told apart.  A check whether an allocation can be served now
> has to count only the pages it can take.
> 
> A check whether there is enough free memory counts every migratetype:
> kswapd and kcompactd balancing a zone, order-0 thresholds, the
> slowpath's forecast whether reclaim and compaction can still make
> progress.  Reclaim and compaction work across migratetypes to free whole
> pageblocks.
> 
> Move the body of __zone_watermark_ok() into __zone_watermark_ok_mt(),
> which takes the migratetype as well, and make __zone_watermark_ok() a
> wrapper around it for the second kind of check.  These use the new
> function:
> 
>   - the allocator fast path, zone_watermark_fast();
>   - its recheck after node reclaim in get_page_from_freelist();
>   - compaction's up-front check, compaction_suit_allocation_order().
> 
> Declare both in mm/internal.h: nothing outside mm uses them.

Why not mm/page_alloc.h instead, now that it exists.

> Nothing reads the migratetype yet: no functional change.
> 
> Tested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/mmzone.h |  3 ---
>  mm/compaction.c        | 11 ++++++-----
>  mm/internal.h          |  7 +++++++
>  mm/page_alloc.c        | 37 ++++++++++++++++++++++++++++---------
>  4 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ecd1ebd49756..4d9347a399fa 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1637,9 +1637,6 @@ static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
>  #include <linux/memory_hotplug.h>
>  
>  void build_all_zonelists(pg_data_t *pgdat);
> -bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> -			 int highest_zoneidx, unsigned int alloc_flags,
> -			 long free_pages);
>  bool zone_watermark_ok(struct zone *z, unsigned int order,
>  		unsigned long mark, int highest_zoneidx,
>  		unsigned int alloc_flags);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb201..6c553d0e90f8 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2520,7 +2520,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  static enum compact_result
>  compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>  				 int highest_zoneidx, unsigned int alloc_flags,
> -				 bool async, bool kcompactd)
> +				 int migratetype, bool async, bool kcompactd)
>  {
>  	unsigned long free_pages;
>  	unsigned long watermark;
> @@ -2531,8 +2531,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>  		free_pages = zone_page_state(zone, NR_FREE_PAGES);
>  
>  	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
> -	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
> -				alloc_flags, free_pages))
> +	if (__zone_watermark_ok_mt(zone, order, watermark, highest_zoneidx,
> +				   alloc_flags, free_pages, migratetype))
>  		return COMPACT_SUCCESS;
>  
>  	/*
> @@ -2588,6 +2588,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  		ret = compaction_suit_allocation_order(cc->zone, cc->order,
>  						       cc->highest_zoneidx,
>  						       cc->alloc_flags,
> +						       cc->migratetype,
>  						       cc->mode == MIGRATE_ASYNC,
>  						       !cc->direct_compaction);
>  		if (ret != COMPACT_CONTINUE)
> @@ -3073,7 +3074,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
>  		ret = compaction_suit_allocation_order(zone,
>  				pgdat->kcompactd_max_order,
>  				highest_zoneidx, alloc_flags,
> -				false, true);
> +				MIGRATE_MOVABLE, false, true);
>  		if (ret == COMPACT_CONTINUE)
>  			return true;
>  	}
> @@ -3116,7 +3117,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
>  
>  		ret = compaction_suit_allocation_order(zone,
>  				cc.order, zoneid, cc.alloc_flags,
> -				false, true);
> +				MIGRATE_MOVABLE, false, true);
>  		if (ret != COMPACT_CONTINUE)
>  			continue;
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index 566cbd2dce48..8e58e2db5e09 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -726,6 +726,13 @@ extern int min_free_kbytes;
>  extern int defrag_mode;
>  
>  void setup_per_zone_wmarks(void);
> +bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> +			 int highest_zoneidx, unsigned int alloc_flags,
> +			 long free_pages);
> +bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
> +			    unsigned long mark, int highest_zoneidx,
> +			    unsigned int alloc_flags, long free_pages,
> +			    int migratetype);
>  void calculate_min_free_kbytes(void);
>  int __meminit init_per_zone_wmark_min(void);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a8cac5e01066..7730660bdd09 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3587,9 +3587,10 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
>   * one free page of a suitable size. Checking now avoids taking the zone lock
>   * to check in the allocation paths if no pages are free.
>   */
> -bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> -			 int highest_zoneidx, unsigned int alloc_flags,
> -			 long free_pages)
> +bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
> +			    unsigned long mark, int highest_zoneidx,
> +			    unsigned int alloc_flags, long free_pages,
> +			    int migratetype)
>  {
>  	long min = mark;
>  	int o;
> @@ -3665,6 +3666,21 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  	return false;
>  }
>  
> +/*
> + * For checks that are not about serving one allocation now: kswapd and
> + * kcompactd balancing a zone, order-0 thresholds, forecasts whether
> + * reclaim and compaction can still make progress.  They count free pages
> + * of every migratetype: reclaim and compaction work across migratetypes
> + * to free whole pageblocks.
> + */

What a slop comment, sigh. Can you rewrite it normally?

> +bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> +			 int highest_zoneidx, unsigned int alloc_flags,
> +			 long free_pages)
> +{
> +	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
> +				      alloc_flags, free_pages, MIGRATE_MOVABLE);
> +}
> +
>  bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  		      int highest_zoneidx, unsigned int alloc_flags)
>  {
> @@ -3697,8 +3713,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
>  			return true;
>  	}
>  
> -	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
> -					free_pages))
> +	if (__zone_watermark_ok_mt(z, order, mark, highest_zoneidx, alloc_flags,
> +				   free_pages, gfp_migratetype(gfp_mask)))
>  		return true;
>  
>  	/*
> @@ -3710,8 +3726,9 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
>  	if (unlikely(!order && (alloc_flags & ALLOC_MIN_RESERVE) && z->watermark_boost
>  		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
>  		mark = z->_watermark[WMARK_MIN];
> -		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
> -					alloc_flags, free_pages);
> +		return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
> +					      alloc_flags, free_pages,
> +					      gfp_migratetype(gfp_mask));
>  	}
>  
>  	return false;
> @@ -3923,8 +3940,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  				continue;
>  
>  			/* did we reclaim enough */
> -			if (!zone_watermark_ok(zone, order, mark,
> -					       ac->highest_zoneidx, alloc_flags))
> +			if (!__zone_watermark_ok_mt(zone, order, mark,
> +					ac->highest_zoneidx, alloc_flags,
> +					zone_page_state(zone, NR_FREE_PAGES),
> +					gfp_migratetype(gfp_mask)))
>  				continue;
>  		}
>  



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C17A4C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D125F6B00E9; Wed,  2 Sep 2026 09:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9826B00EA; Wed,  2 Sep 2026 09:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8936B00EB; Wed,  2 Sep 2026 09:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98DBD6B00E9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:46:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 301A61A021E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:46:54 +0000 (UTC)
X-FDA: 85168947948.17.494CEBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9710820005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:46:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okFse3wJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVEd5d75YE+aQSNOfHhVC5lBHOsLLZJMAtGt1Mo7YBc=;
	b=NtV3owkYrwCi2biVE1LdLn32x120ZLdU1PdSbbhN/V1LWbMkPIvBKOp65nxRd+p2SZ7+Jo
	DFrQpn5ASyTH6iWFa86aTqX6pWIiQMa9sXdSaFRURHREAi1nnt1d0f76ZiXFCwO24DyOWD
	T3Hvj4LahdirHQ6hWJeBB7sKPzUDd9U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okFse3wJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356812;
	b=1LM+ddy9riXK3oxUzex9vLEvwfXAGQ8z+ATJJyBtDxz30E48tjewx07vN17Sz9bX7Upo/1
	pz9dC1EUCsjDswbvUs8sRBslEf4LuzOC9h6rh9Ppz/KiHNN6pdxox3YmrzcuzGOrM6kVZQ
	inqNr21JAgfDKYhrkXp5jmIS0oeoRrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2209B600D9;
	Wed,  2 Sep 2026 13:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA6C1F000E9;
	Wed,  2 Sep 2026 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788356811;
	bh=HVEd5d75YE+aQSNOfHhVC5lBHOsLLZJMAtGt1Mo7YBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okFse3wJj7j5Uestva/C4RLOVrEldgdwnHZGOXkKvr8LVAC3AYsxrUXyggOpgTSoB
	 GdU3t/78ANZmrsaGnd6q5veUw1sLmN3e+VZQ3F9a7svyDNinINmNooSPyN5qLdke9o
	 oFWlzZQq2hxpPuSBrmno+zAcS8KwnDHId5quPeNofsWNPGGPAqwkmOGcFEIJ0yiEmX
	 GPDPzLsoQNg/Bi+DaYoQ06fizxY+hIJ2HAV1Y0T8ZvFUN2i6eLMHgA8yNm2GnGzJ+E
	 Sq7CqKKHf+4Wyj5uGQbK+ozwrPRl+wT5ckcZJCSdXUSerBsUSUlP7QHp9UGkhV7juW
	 duzz6536CVDiw==
Date: Wed, 2 Sep 2026 14:46:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <apgh-aJ7TsdixrGc@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xjbc3xt1xagqbhdwjatarzi53cpiak97
X-Rspamd-Queue-Id: 9710820005
X-HE-Tag: 1788356812-900109
X-HE-Meta: U2FsdGVkX19qB0pMEEWzTfKUQnx2w0o940C3uuieHO8wVSqbs5en2fTD1SvxaADFZTjQAKTsYJUKbvLnCOj4TWBRBeK8+uTmrqraTJUjfQ1vujxTQ26nq+M9yP5EUUZrCGr2Eoqr6F6lx2iysTi6XI/cBaPSxnxu7x9mhV2bpFsG/652QRM3bzkYSppuF2Oc88+vsewcv1ifR4gKubamP6hp45Hp6G8XRZQBEAz52Prtrv9uCBRut67I9KtFPOXRT5WNVyYnJ7peUcmAXBvzVsH6f1V1hrzqleK82x3hGFcyIKX0UIgBdhDSF5CYrUHxbwNIAC/6PH7fGjCzYxaICDtJdJyPLhjXCcmRCGaCt6vOIx6NbxhQtI59JiJURoohjUa1kz8VF5BURb3Ff6R9a9GDEBMIPk4aQrriLlCe9fA0nsKdYsS94lpUrm9MjrQkmfTXC9s45wHwegHFpB5ORx271smlxMhH04CfvImJo2FWq5+umhv+IMyxj0NGMixYhZPw5gRsKaU+cZhollfugUwBVEv5NuvBcRU2iTTfWOJC/bGl+YVKZ7KJf6x4tcEe3IwX+g5AeM4VlCYyCbgX9fcGU/C+Zyu7jIyFMkUpfSp6Y5UV/ktdk2wijksoJIXAHkfZnV+N7UctLchKGWWOWCcVTh3Q/ExqnHH1F9nRB5adN9oj0iRsneDnVuQHfC4cqpc8TmSI6qteMBGKFUlhNUHnUynzl3mySz5PF+o9+T+WDN5erk35JyKeWu1sesb0rzdFO4JYzmnRRDppVSbAjyOMyffwNpJPgurRGhYXv+8LSVFdibrs2WhzCjQqTcveUMwitks2JEfnJrVkqsLYnWOVbfjwxO2Yu2bTm5v7j7OEvFUMip3Xd/yGEQgSUksbOdlBRZf7NxI5VOcdH96Er+/ggrC5itY0hr5bOdEDtWwexLpvDrVSaYelh0P08M+k7CYoSaBtQNR5Fv+6Lhw
 XAwrKi9u
 HZYHHYTqGgJRRN6n/U4TbNLEQcFB0wh+EDabDUjwcBizDERK45Mp9g7yyBEYf6VeJBa0iM8bNOT3ginkj6SwSvFiGqx8/UV27NeP3ZM+bIKbLc5nlwM+bqZfIwA3yvqi9lqT1q/lTRu5kgrA/1QzmcaTF+AVTgIEJMPL8I3iQZzNY7dEUKhnl2ihN3diUO6nIWzD0nGNhkqaKk6e5VKoIByc5tm3WdJW+rHzUWwIGFnInjAPhyJ7hjlPToQ/RVCAgbjUbOmsBDfDCMY8I/ShluhXcwLNys7RUXK2ZNpFv0JPj8HPlaQGtrNBk5LB4Xv9nYT3rQ44MB868mXxoKn9yiWfd+5xicfiDVaxAioQqCOXML4Qc1GZQmbmQjSE8BreahGZT3hKKQ9fARApKC0bXEgDWvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
>
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
>
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>
> Even with that cap, min_free_kbytes can reach excessive levels.
>
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
>
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
>
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Code all looks good, ran locally and with 16 KiB page size arm64 + THP
enabled (tried with defrag -> madvise):

Before:

	$ cat /proc/sys/vm/min_free_kbytes
	360448

After:

	$ cat /proc/sys/vm/min_free_kbytes
	11472

And no delta on THP selftests.

$ cat /sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
936
$ cat /sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
2002

So (32 MiB) THPs are coming no problem with low memory pressure and without
needing egregious defrag options, i.e. proactive compaction is doing its
job fine.

See https://lore.kernel.org/linux-mm/apgdNQgHw4BW3bPG@gremlin/ for my
thoughts on this approach in general but TL;DR am in favour :)

So LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v3:
> * Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
>   increase as suggested by Michal.
> * Remove all associated recalculation paths.
> * Make min_free_kbytes, user_min_free_kbytes,
>   calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
> * Drop the now-unused declarations and khugepaged's page_alloc.h include.
> * Drop the obsolete v2 documentation addition.
>
> v2:
> * Use a named constant for the cap.
> * Drop explicit linux/sizes.h include.
> * Update min_free_kbytes documentation.
> https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
>
> v1:
> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
>
> RFC v1:
> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> ---
>  include/linux/khugepaged.h |  5 ----
>  mm/huge_memory.c           | 14 ---------
>  mm/internal.h              |  8 -----
>  mm/khugepaged.c            | 60 --------------------------------------
>  mm/page_alloc.c            | 11 +++----
>  mm/page_alloc.h            |  2 --
>  mm/shmem.c                 |  7 -----
>  7 files changed, 4 insertions(+), 103 deletions(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index d7a9053ff4fe..e2a2ccb6cd05 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -15,7 +15,6 @@ extern void __khugepaged_enter(struct mm_struct *mm);
>  extern void __khugepaged_exit(struct mm_struct *mm);
>  extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>  				 vm_flags_t vm_flags);
> -extern void khugepaged_min_free_kbytes_update(void);
>  extern bool current_is_khugepaged(void);
>  void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  		bool install_pmd);
> @@ -47,10 +46,6 @@ static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
>  {
>  }
>
> -static inline void khugepaged_min_free_kbytes_update(void)
> -{
> -}
> -
>  static inline bool current_is_khugepaged(void)
>  {
>  	return false;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c5d11147b69a..b1f87e005e03 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -499,13 +499,6 @@ static ssize_t enabled_store(struct kobject *kobj,
>
>  		if (err)
>  			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode didn't
> -		 * change, as the previous code always called
> -		 * start_stop_khugepaged() which does this internally.
> -		 */
> -		set_recommended_min_free_kbytes();
>  	}
>  	return count;
>  }
> @@ -735,13 +728,6 @@ static ssize_t anon_enabled_store(struct kobject *kobj,
>
>  		if (err)
>  			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode didn't
> -		 * change, as the previous code always called
> -		 * start_stop_khugepaged() which does this internally.
> -		 */
> -		set_recommended_min_free_kbytes();
>  	}
>
>  	return count;
> diff --git a/mm/internal.h b/mm/internal.h
> index e16f1250b25c..6890d7836c68 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -689,11 +689,6 @@ int user_proactive_reclaim(char *buf,
>   */
>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>
> -/*
> - * in mm/khugepaged.c
> - */
> -void set_recommended_min_free_kbytes(void);
> -
>  /*
>   * in mm/page_alloc.c
>   */
> @@ -701,11 +696,8 @@ void set_recommended_min_free_kbytes(void);
>
>  extern char * const zone_names[MAX_NR_ZONES];
>
> -extern int min_free_kbytes;
>  extern int defrag_mode;
>
> -void setup_per_zone_wmarks(void);
> -void calculate_min_free_kbytes(void);
>  int __meminit init_per_zone_wmark_min(void);
>
>  extern int __isolate_free_page(struct page *page, unsigned int order);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f49a6710933b..c36b7d0b91d7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -27,7 +27,6 @@
>
>  #include <asm/tlb.h>
>  #include "internal.h"
> -#include "page_alloc.h"
>  #include "mm_slot.h"
>
>  enum scan_result {
> @@ -3086,57 +3085,6 @@ static int khugepaged(void *none)
>  	return 0;
>  }
>
> -void set_recommended_min_free_kbytes(void)
> -{
> -	struct zone *zone;
> -	int nr_zones = 0;
> -	unsigned long recommended_min;
> -
> -	if (!hugepage_enabled()) {
> -		calculate_min_free_kbytes();
> -		goto update_wmarks;
> -	}
> -
> -	for_each_populated_zone(zone) {
> -		/*
> -		 * We don't need to worry about fragmentation of
> -		 * ZONE_MOVABLE since it only has movable pages.
> -		 */
> -		if (zone_idx(zone) > gfp_zone(GFP_USER))
> -			continue;
> -
> -		nr_zones++;
> -	}
> -
> -	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
> -	recommended_min = pageblock_nr_pages * nr_zones * 2;
> -
> -	/*
> -	 * Make sure that on average at least two pageblocks are almost free
> -	 * of another type, one for a migratetype to fall back to and a
> -	 * second to avoid subsequent fallbacks of other types There are 3
> -	 * MIGRATE_TYPES we care about.
> -	 */
> -	recommended_min += pageblock_nr_pages * nr_zones *
> -			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
> -
> -	/* don't ever allow to reserve more than 5% of the lowmem */
> -	recommended_min = min(recommended_min,
> -			      (unsigned long) nr_free_buffer_pages() / 20);
> -	recommended_min <<= (PAGE_SHIFT-10);
> -
> -	if (recommended_min > min_free_kbytes) {
> -		if (user_min_free_kbytes >= 0)
> -			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
> -					    min_free_kbytes, recommended_min);
> -
> -		min_free_kbytes = recommended_min;
> -	}
> -
> -update_wmarks:
> -	setup_per_zone_wmarks();
> -}
> -
>  int start_stop_khugepaged(void)
>  {
>  	guard(mutex)(&khugepaged_mutex);
> @@ -3160,17 +3108,9 @@ int start_stop_khugepaged(void)
>  		kthread_stop(khugepaged_thread);
>  		khugepaged_thread = NULL;
>  	}
> -	set_recommended_min_free_kbytes();
>  	return 0;
>  }
>
> -void khugepaged_min_free_kbytes_update(void)
> -{
> -	guard(mutex)(&khugepaged_mutex);
> -	if (hugepage_enabled() && khugepaged_thread)
> -		set_recommended_min_free_kbytes();
> -}
> -
>  bool current_is_khugepaged(void)
>  {
>  	return kthread_func(current) == khugepaged;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c4dc61ec663e..5280784c91a8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -50,7 +50,6 @@
>  #include <linux/ftrace.h>
>  #include <linux/lockdep.h>
>  #include <linux/psi.h>
> -#include <linux/khugepaged.h>
>  #include <linux/delayacct.h>
>  #include <linux/cacheinfo.h>
>  #include <linux/pgalloc_tag.h>
> @@ -272,8 +271,8 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
>  #endif
>  };
>
> -int min_free_kbytes = 1024;
> -int user_min_free_kbytes = -1;
> +static int min_free_kbytes = 1024;
> +static int user_min_free_kbytes = -1;
>  static int watermark_boost_factor __read_mostly = 15000;
>  static int watermark_scale_factor = 10;
>  int defrag_mode;
> @@ -6663,7 +6662,7 @@ static void __setup_per_zone_wmarks(void)
>   * Ensures that the watermark[min,low,high] values for each zone are set
>   * correctly with respect to min_free_kbytes.
>   */
> -void setup_per_zone_wmarks(void)
> +static void setup_per_zone_wmarks(void)
>  {
>  	struct zone *zone;
>  	static DEFINE_SPINLOCK(lock);
> @@ -6704,7 +6703,7 @@ void setup_per_zone_wmarks(void)
>   * 8192MB:	11584k
>   * 16384MB:	16384k
>   */
> -void calculate_min_free_kbytes(void)
> +static void calculate_min_free_kbytes(void)
>  {
>  	unsigned long lowmem_kbytes;
>  	int new_min_free_kbytes;
> @@ -6732,8 +6731,6 @@ int __meminit init_per_zone_wmark_min(void)
>  	setup_min_slab_ratio();
>  #endif
>
> -	khugepaged_min_free_kbytes_update();
> -
>  	return 0;
>  }
>  postcore_initcall(init_per_zone_wmark_min)
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index b9259deddb59..86162e6cfa8c 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -227,8 +227,6 @@ void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
>  		     unsigned int alloc_flags);
>  extern bool free_pages_prepare(struct page *page, unsigned int order);
>
> -extern int user_min_free_kbytes;
> -
>  struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
>  		nodemask_t *nodemask, unsigned int alloc_flags);
>  #define __alloc_frozen_pages(...) \
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 255d69ebceba..92dc770b10e6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5782,13 +5782,6 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>  		int err = start_stop_khugepaged();
>  		if (err)
>  			return err;
> -	} else {
> -		/*
> -		 * Recalculate watermarks even when the mode hasn't changed
> -		 * to preserve the legacy behavior, as this is always called
> -		 * inside start_stop_khugepaged().
> -		 */
> -		set_recommended_min_free_kbytes();
>  	}
>
>  	return count;
> --
> 2.45.0
>

--
Cheers, Lorenzo


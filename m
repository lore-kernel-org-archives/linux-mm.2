Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00ACCC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F9C6B0088; Tue,  1 Sep 2026 15:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0DA6B008A; Tue,  1 Sep 2026 15:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF186B008C; Tue,  1 Sep 2026 15:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD176B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:12:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A96CA432B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:12:21 +0000 (UTC)
X-FDA: 85166139282.30.1F84448
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0792140009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:12:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S8d41KmP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788289939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zPvklJyA4CfeLH5aidlGEqSmPD1mECtHvc2+1X4NxU=;
	b=DO69j7pKHZYAwG6N/jAL88ZWiy8k5+B0Sa2ij+ID36AbA1t4UfuG+T1foYvIAbvwHk6LWd
	AXezi6L/h7COq7fq8+x9EYyUUi4CFxdDEY3EzxCvIDrEazwJlGaOEdM+TgkuhUrg1xi9jD
	qKA2AlyUXPDsMdaOtzmlFD2zEmrgreA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S8d41KmP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788289939;
	b=iJ1M09LRo5OBW4TWln2+Q43lCyqCuOop7CKH9rinL0+WHa9DeFOm2sdY61vDunBof/I1aa
	cf0HBmO/GyNfndBdOb2hpwMrxZSXXrwtyaDSX+F4oVkeXTQs5z0woDC1P0I9ktimLP4cWq
	8fnhUiIJJq6LCViKzjJfunPwdiGBT+o=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so1964225e9.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788289937; x=1788894737; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/zPvklJyA4CfeLH5aidlGEqSmPD1mECtHvc2+1X4NxU=;
        b=S8d41KmPKyDQjUjN604RxeH571Hm+jM2g1R3JCbYbJTBgX13nI8GExo849XcM5nqNW
         hnsVSLwgVf/HjMgby9DIayODbMHYHn4bhaj9qGgw18aXwJRmU42LOwbJx8h0e3ie79+m
         YXEicNQJPyqboVbrMp52KiJU5vXBGw7yOpyos5UeGUoINWbENFKmaCdO32+deKDj3c/x
         +YGcHEMrnFlVxBUT80+aBj/R16ehYNudHUsxZ0kMCkBIDllWS8l8qbJgFXYx9LwcPKmL
         VybX6DIyYY99p2W/ku6yH1fQnrKI7u/KHeM7SIHbHAL2GWfAsNDFh+n05YNgCgNoJlp9
         RK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788289937; x=1788894737;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/zPvklJyA4CfeLH5aidlGEqSmPD1mECtHvc2+1X4NxU=;
        b=J2WkoFqX38WkTRoAAwrToFzZu4flpnsbOraeQOwyfG8fjzYQ22H7Od4HaDQ8dzgPbG
         q+MXMq4+1R5kodyQ5R0RjQD40AoFZRM0z89BXlrbeffLHhTsvCU7eaFF9wWLBwikns9R
         lHlCrdVZUN3bstDddEe+BCLR8No0hWCbtsz0ElvyYz4gWWDlvF+Ps/kSC0mPNl/DPUCD
         2iWNGIjI2lfrrrrPxW3UpHYtn/AF7eYtJWnd88RJk5Q+vaL5ZO7MBtl0mvaUaV9qLCWB
         No8r0RCtOCg84f811v7jMUltQluxxAbRbIQd5c3W0XfH3kH/x78GCa1WNO+SxVsNFg7i
         +vUg==
X-Forwarded-Encrypted: i=1; AHgh+RqqXiLoR+n2SFaRAxnAUmKRtUrC4chmOJTIa+JWGX0HToZfL3rHMcm4UViT6xoW3WGigkn/fwKQGg==@kvack.org
X-Gm-Message-State: AFuF++npZBbXpbcdAFrhs+0WFfIeNGQ/Rv8mWdN6b5i1+1ZzthJjd86N
	/KKP7C1lQ+amv06o/uqD1E4txc6M8LkrD4FbbLRqfnUKKphZk/e3wmCF+GdA+7dAU9E=
X-Gm-Gg: AR+sD12qn6nICQxvPB/rBOgKmj38RPYPMZbNFthTGbooAs4eUalmNRedw2fRG6CeSMQ
	AHQp5xV6Egm3hC0+dVLvmHpTHIchryuM+Klrt+9aXyiG4+d5mWN3kjcHh/aSGERjG5ZcnCC6MQo
	PooQljtQk2dGGGR5viWZ5+03hu1cxsz31bbqot67r5dYJvdTCbYIFe/QLlnx4yPNy/Md0aAQ2x7
	+kNgGecp+RhEv1jaN8Wl95OoAb2uVJHqzy8ssa0rdyGf21r5MB8IlR/br3z+25M2M8o7Ne5ECqd
	2wUW7gvqncNMihIYIfTzUzl8jX8r9t7EAy0OgkDZbJX4bTN8F37mc8+YOVV3KS7MB3dbt5nSt+5
	gP1xW9QpB2VR+359DjAQOpTEQhg17jTIUX+uM1FHead3Ylih6oBbLekLry4+TCo3aMwEED6gtcI
	vyqOwvHPb63U0IghuCJrmNDW3dWC8brMQ24p26kjRAj4zs2D08TFYSWQqA+7rxnntWsjU+xh8=
X-Received: by 2002:a05:600c:c3cf:10b0:49b:8f18:714a with SMTP id 5b1f17b1804b1-49b91c47b76mr454139925e9.12.1788289937383;
        Tue, 01 Sep 2026 12:12:17 -0700 (PDT)
Received: from localhost (109-81-87-32.rct.o2.cz. [109.81.87.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce10148sm85892425e9.5.2026.09.01.12.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:12:16 -0700 (PDT)
Date: Tue, 1 Sep 2026 21:12:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <apcjj-BbgPuh6j1B@tiehlicka>
References: <20260901190123.3511535-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 81y89z7t94yafbht5wpudqumm7npu5hg
X-Rspamd-Queue-Id: 0792140009
X-HE-Tag: 1788289938-304023
X-HE-Meta: U2FsdGVkX1/GqWJgfS1vAXXyiUEZPwOd217qMYuYJ4F06WG8mGUCG6OpzCe+LdZZ30lgu8m1J86BgzS4UIyEKFlD1vLoShEIniJhbHWpy66tH78lO3jdH6mM5oFLsgFxDqb+zdYaKqQbwe2pC0FNDR3536zVfTURW+3LRgT7cjQqAVUxMxDTtzV57uQ54udQ8/dOk+VJkMdOG2l7SjiEIXgg4mlqX9K9KZ2fruMz1HiZ8aK8pMfHLheHHXZqLJTIeGn/0RQPa2tJegB7RJ0YZY4yWiNCerQh7CRg+paIZoCvaqXLunWDwLudGAsFREs4kmP+OiqmpQ0z6olGIkzY663qAnBMA8WbxNgozVraWymR6C0rWNQ4wvw4zZ/bVLt07RyK4ggnbVwDdmMQBZmHyqhAqEI01z2PzR5HSWliHkr9xY5OMAUAItSsgGYNzYycoQhTCucrpeLmdXrk/q4WlEbO41yk6N8d5AWj8T6WJmKQfS9C+2nBnAwbzL8EGrKGpZ9U73mkBWaIS5HpbX0POuw5veLYaXsEYn3XMZ+BLxAmmfGDTTT7X6oOxBtlMxp2ob6ifD8aCtQUn7i+M8lvbCn/u2CSjn3lswg7VCRr3sL7rcDKAg44ClBAscuMagsN9S/fmHGVteOwVE9Lsy9DfqQzs0UK5joZ04/wbtNszX2yxDH84Pw1YsWLdX4yooDVwaWLs945XTU0xy4dORiGhj0pXeI2efTzfoneAim7y2VA2+6nz4jhfvswiBXxp7bPGLEf+jzU8vEu+Ur3cgI/RvWNFfp7S0ZrP1xfFdPsgUZj65QIYt0oSHP059stc8mGAkYze536Fm/hHVEf3M7d4NPhTSitOxMuFE/AX723Rur4zJZtarH5nGAIea0/r0rm6a3rluV1qBzWJ2l4l/763vQ/2uG9gW/3gkcpsZSwAjE2LpDY67z80Q4jutnQpuX4IgmpGdJpeah6pIFdjDw
 QLH0fZCj
 9TkpoLh3YjtCoBnHywla0H8zUoOXnT5qeMi6PmqD5xTMnoq1E/yBIZHCLaA775YwoPsUIn8cAJfimBmnh5pytBxMgd3p9s2K2JxJa2uMEJdH6Z1BF4qBtpojGTG89u+EwQQldfsRHwxSnv/L/pYjnxged3atrOhEwbmgYv2q8TWV+1UxmZ6q2vXvn3csOdx+HeT5IekHHxrhzd+lXP5TdhLpp1t3L60hIW2cWZO/QZyi8N3k/EUx/0ODpyEYwo6AhcPEh17nP43RnkaoA0Oz/N8hrTTyuiwm3Ls9vF/r5gyp+XvPDT2v5/pk9D4+NIgG5QS9icN0QNVqcGRnLpBzXQurUndZ4D4sh5In6VzmJXreQoKti6oZzhy4fbZgyGT5Os/FzsFQQmWZp6YT+EP9B9Xg+XH4OY1shVDMS85UauHzLfxTbl2oW/kaeceqy6IAokgVCRhFZxBoH77hlfbQoM9fbydf8pNsUL2xVTkBYL7y7hUG0s8Vsw7323dpEZx/BDBOc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 01-09-26 22:01:23, Nimrod Oren wrote:
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

I think this is definitely worth try. Let's see if this leads to any
sort of regressions. I am aware of setups where people were actively
fighting against this increased value so let's see who might just depend
on that without knowing.

Acked-by: Michal Hocko <mhocko@suse.com>

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

-- 
Michal Hocko
SUSE Labs


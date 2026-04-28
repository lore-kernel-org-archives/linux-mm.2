Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C66FF8873
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BB56B008A; Tue, 28 Apr 2026 03:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523396B008C; Tue, 28 Apr 2026 03:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4604C6B0092; Tue, 28 Apr 2026 03:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 356246B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:06:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D37898BE5E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:06:38 +0000 (UTC)
X-FDA: 84707081676.08.4973CEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 20EE320012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:06:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHP11C4p;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugKPT3dFXN0JQbPmNQ4wIwkZSWZLGY/HgU+sxJALhB0=;
	b=hQuWkw6xke+nMJ3Pt5r5700ttXESCZw00oTg9QkjmSb1QjePko0Ut8Av5U+wx2gXlILmRy
	l+tAvhvIV1NdaFjo0qYq2bTHPrCyihKAZY5C2j1J4POv6sOEqyT9WxNqIwS2XjKhaxvRYb
	In/gCFSG09KkWY87mJHrWA5W0pGHNPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359997; a=rsa-sha256;
	cv=none;
	b=vhcVperDq19vsAKcevv6jUP2aQ0pXTlq1F855d29xk1FnqoXxgGAN+kKBvmp7rFMH9x+3d
	xSy67FodSCeGz2DEJv+SQHuQcy6uqTMPL/eNrsHZOCpDBPBIwhV867q+301poq4qrOEsfn
	deubW3uxsr5EmQsJK3Ug8ii2P640NYE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHP11C4p;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A87A41AF5;
	Tue, 28 Apr 2026 07:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B5C2BCB6;
	Tue, 28 Apr 2026 07:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777359996;
	bh=AmZrrVrVvG/hI74hQkTxsZH0QSUjw9p1a/uNen2G+Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YHP11C4pRdasJf8eSkFixOJZscPHF3WGc1114N0tgEsBPJ41Xd0z6h9TjAFYnbvJM
	 6y8Wf+ohZ5wiNa0HQkT7ae1lo345jSHffVXCEOCCoRBCT5GpReFRA9X1M71HtFJvif
	 P17JyJzUyh8L8A2gSfyGDFLC0cOB+EAkIBe4ctFiXmd7ySQsCFQ0tPNHTyjQqHyvSE
	 QC+Dn3CN1GUu2FBGysCWCgwEC5OV9JpLUbiC9jdgbFEEtkzn24mKdzqu86utR2iMkO
	 PMRH5C3TOy9b/2AdjexXKjybnzLB5eFGdshOg490dVsPabUWLRggSLBL6eWPkkuC+6
	 5D2C2UsDkrI0w==
Date: Tue, 28 Apr 2026 09:06:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/49] mm: move subsection_map_init() into sparse_init()
Message-ID: <afBcckUTQt-7xPPN@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-11-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-11-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20EE320012
X-Stat-Signature: dq5tbjfhp4ptrddhddkfydwu6hyjupm7
X-Rspam-User: 
X-HE-Tag: 1777359996-631764
X-HE-Meta: U2FsdGVkX18ARpzSZjfMVR9Qgx5BI4TmyzFFJDk0J8lhTdT1vJ2SyMClcz9X/KI+OJC7X5sUh6VKjTslZHwpFyAbxmHjEQX7smQGyT8XRGK3qoi9wt5L986p4jl8PqP6gtuDKUCkwOP98Xhv4DMmJCGKezLcgLbwXk7bxzaM7lh1uE6HfcKUQCEmrmhXEVldT3H+iGuUyu+admcDGpD+HmnT3+fBm3OaQkjZFU1rSX/k+TrnnC/HhYtBPdlD7FuxChlzGleJVq2TsuLQgkcTbvO4dYH28QHBGsTAdMWN3cf0KSCR/7ycXP2JxJhZiSPQ4iuE1Pr3U0mCl19jCdPn2vFCSclii/VcHArr29XFpGf49ddtNxGcgo22vknMyl8hMJsqR9R2kT7fYPKH3HnIp9sPcOWMAof7Yh/3v2imJ1/LBWqyTXzxkrNcmYxsQvgO/ahF4xx3mV/EYArdUTCafbVO28fKcvvS581Xe/j2hEfQyTdmxhFPWV/mI4BsQtz74snjuLnl9XKhLQHqsmjHE8GQq+CNkzqdFsrgj/auLvuv9Jl49ovcCJrm+cJYOuubvW06hmFXeo9C2WJcwimxfVTaNBEPMcTz4ct3MoOfdyMt6BkTgRlFy7NawKV022UyHMxcqc0JcQkdXN5C+m82QESzTqY0KuQMW7ZizvDcgnwNk9YbJFptFd9oD1vgL52xfahxIUg6x/xqEuW3Dz4b0TBy41Y3rtO02nkTvcMTctUN3yBmZzlAvrKLvRbUGrYlh5kqrj94gOcifcPFMgbcAzFjzMuiS1GPMduvwdPWTRHjah+BniK5FLfoA6K0P+BXOMrQZFAa6/mEO4Bbbh25sF/x5DOwAcaOcy6/+Q6kQgTfNBBijgFcY1mkZVWx+JE0/AiMKephLEeeksh5Gypo8SsLlnjaLdAveXM0VYqyjWsH5VDxj+Xg0erSRHxgsv7Ej4BieRPk6EizElwigIG
 AcnjGKQc
 TCQpmRRbM5IHA+X/1m1UjawEBEgaQWk8ORCfHwSkDJ3v3VloYy/yYV+GIWgxGMPCCljkziR1JAklsrgnhUAynebBmt4N2tkDUskestUTvXWDIVD8ZJ5vD70pQeNmu30Q60G+puM96zzPH8dpAOCdTQRfwAb9kdkAFP+L0fmDmWob3DcutrbrnKtJxVJlE9689/g8DZIndVugVjSJz0l4bFGszENlmhYk5hLTkkaAUKKvBMOuO+k4Q7k8ss6FBtAKbqAK2r3zcP/eBCiZ/3ECLbOiyyEmL8C+UxJDgpLVB4SGR/Xt8KdaRtN9McA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:01PM +0800, Muchun Song wrote:
> Move the initialization of the subsection map from free_area_init()
> into sparse_init(). This encapsulates the logic within the sparse
> memory initialization code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/internal.h       |  5 ++---
>  mm/mm_init.c        | 10 ++--------
>  mm/sparse-vmemmap.c | 11 ++++++++++-
>  mm/sparse.c         |  1 +
>  4 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index edb1c04d0617..d70075d0e788 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1004,10 +1004,9 @@ static inline void sparse_init(void) {}
>   * mm/sparse-vmemmap.c
>   */
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
> +void sparse_init_subsection_map(void);
>  #else
> -static inline void sparse_init_subsection_map(unsigned long pfn,
> -		unsigned long nr_pages)
> +static inline void sparse_init_subsection_map(void)
>  {
>  }
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */

I side note: we might want to split out mm/sparse.h and also move some
declarations from include/linux/mmzone.h there.

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index a92c5053f63d..5ca4503e7622 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1857,18 +1857,12 @@ static void __init free_area_init(void)
>  			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
>  	}
>  
> -	/*
> -	 * Print out the early node map, and initialize the
> -	 * subsection-map relative to active online memory ranges to
> -	 * enable future "sub-section" extensions of the memory map.
> -	 */
> +	/* Print out the early node map. */
>  	pr_info("Early memory node ranges\n");
> -	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
>  		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
>  			(u64)start_pfn << PAGE_SHIFT,
>  			((u64)end_pfn << PAGE_SHIFT) - 1);
> -		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
> -	}
>  
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 0ee03db0b22f..b7201c235419 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -603,7 +603,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
>  	bitmap_set(map, idx, end - idx + 1);
>  }
>  
> -void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
> +static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
>  {
>  	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
>  	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
> @@ -626,6 +626,15 @@ void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages
>  	}
>  }
>  
> +void __init sparse_init_subsection_map(void)
> +{
> +	int i, nid;
> +	unsigned long start, end;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
> +		sparse_init_subsection_map_range(start, end - start);
> +}
> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  
>  /* Mark all memory sections within the pfn range as online */
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 5c12b979a618..c7f91dc2e5b5 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -424,5 +424,6 @@ void __init sparse_init(void)
>  	}
>  	/* cover the last node */
>  	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
> +	sparse_init_subsection_map();
>  	vmemmap_populate_print_last();
>  }
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.


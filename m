Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06107C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 11:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C609E6B0098; Sat, 18 Jul 2026 07:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11F06B0099; Sat, 18 Jul 2026 07:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF896B009D; Sat, 18 Jul 2026 07:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6596B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 07:10:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6ABF1603D0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 11:10:16 +0000 (UTC)
X-FDA: 85001628432.24.2827192
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2AB7B20008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 11:10:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FJV2an5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784373015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JTIaYOz+7gcFgWy0FFXbd8WURqImELiBdK9zTFHb5c=;
	b=dXB6/hPhrlrt6vvym5eYc1oF5LY3/SNV5cWBxjN937acH/rb4HhlVdD96EaC1bN8LgVexh
	ij7m/t5Az81NIAI+VJsyjOeFEF/yWAyJ/H/CYBzPGeyq/4O/Cb2aJ7rMMqesFfn1xNhPy1
	PVEKUUwJQVE2GIZmptmgXTu6H1tgAic=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FJV2an5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784373015;
	b=7gi/JTC5KGUJCdbvj8I5UrtgIUwabde7zpgwQdUQ/M6tHg15mei2spY9UE/uhDvX2p5P6B
	rvJLHmbbhb1z+a8QyhCAMezhAS+xF8r5g/XY/a4gu2Pz6BD6Ba/SepXf8Uh+S8b3Hngxbl
	M/k88TbHSAYkbIzcwSOB8e53397pkGw=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c2808dbc3so57356131cf.1
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784373014; x=1784977814; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+JTIaYOz+7gcFgWy0FFXbd8WURqImELiBdK9zTFHb5c=;
        b=FJV2an5UcsSr4RZ6olMRWiXVhh6XWfhKlWFfkBik5Qc0n+IcA9aT/UA2rfHmnuArZs
         +WbEDkfJKcOZ5VNIqELRWUbARav7kAjIY68A63fhz4Ozz/M2IriV+hK/+skk1Ll5UWD3
         aeZGD3GG1a65y20YpOC/e9a6b31EIrUqDDOC4acj+2KLqvcHuHhJXWHdxgSboTi0S5v0
         JgL6VFsrZaoe6AEVif3A/mSRN8oeHLI3T7QZC8wy/nhOzGx92rYY4MFYp2NkKR9/OVci
         O+VeyztAJmonheKmTOTAtzYF4UM5pCudEFWPzQ2G/ts2J8E1wXTXtB/kAPRrC91EMwKN
         YKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784373014; x=1784977814;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+JTIaYOz+7gcFgWy0FFXbd8WURqImELiBdK9zTFHb5c=;
        b=mdF9/CMB45Z85eDA1BQgzVywhzhe6u0itMrdr7Tw0tu5l/x3kBe6fArZIleO9QB0FT
         Co/rwU/22/8pcX4Tmwn5gzapwKBGaa3bUZtj4Mh04whTS6MaBvkTGNybMNOD13gKY9+y
         362uQADL4VU2ZBhERxsvlIalkh92pTYkzAuJy42uS7ZVFM9f/AYQ5gP+w/meCmEYz++Q
         JRmarO5OMpUfjlUDrMHakC+FPY0SezT05OKjDCXvITIFk70/Psb23ZfTj3dQJLxnzwLv
         9p2TGTJYqe7bgOXrNIw0OZKompYY3bWQMg6Lnmi6/BlrtJ5Qssptm520WB/2AcAWtyQW
         iz0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr0+/ZU0felecSML8JkT3eJlbcLlF6aHoA4ijPrW47M+/mg4yI19xnULVkHu+Y9DGs+PWN5S+350w==@kvack.org
X-Gm-Message-State: AOJu0Yy/l9msUlRN8O0oZ5P9VK+D3Xy+9dPkyl2eh9PfSR5yu0iNK+Lq
	o2ibrdAbPzRSdtsUoT5MlA5JdT79QrccJIMQ68HL3rrtVtVz0qsyIdWfcV+BdilibTw=
X-Gm-Gg: AfdE7clHRgHEzCin8NSfGTe4YmUPhrYdtl9ViNsQ/60frspNLvMEnM4bG2ar0UX9WA5
	pvsFM1JQQ025HCZnNjQRJBjT51XZJEGIM+Fu1zd1rsQHRHItVgKUOsNC3P2TCBmo8O+q+cJp61v
	eW7fr+jM/mHefi1+skHq63eDBpsJ87vVy6YpxJnXPLxL6Ujm7LIcQ5GNM2pWsB9UpJMyu1YMQsG
	ne4YY2hlf+oq8RWA1QYzgdPhhUWlDXU6ZiMau0uG6IEF0Sg/xr4lnCLqQIM4bzlVNuSWRmiDeVP
	K+++wHhDf1dI4RspEfLhKq40DzAaU6orJCh7aBBJIzWASKjm580JiGhuhgzz+Pf/0jMcxNPKsp9
	qOyCtjZ0uGsw8i7EKWYssN3du/z83yL5z5q9vc62+tPW/oW8OSNhVZRT1mTR6UZhq6/mSr7n46M
	Vpo6EPRe542+NF73QaPD7ylaceQFewyW7FVcEDGdd7kgfUy2eQ
X-Received: by 2002:a05:622a:614:b0:517:8e65:68ea with SMTP id d75a77b69052e-5213e28f73emr58880021cf.54.1784373014252;
        Sat, 18 Jul 2026 04:10:14 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214f01654fsm31899181cf.19.2026.07.18.04.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 04:10:12 -0700 (PDT)
Date: Sat, 18 Jul 2026 19:10:03 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios
 directly
Message-ID: <altSA1zXhzvHPJYe@KASONG-MC4>
References: <20260718093723.153324-1-alex@ghiti.fr>
 <20260718093723.153324-2-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718093723.153324-2-alex@ghiti.fr>
X-Stat-Signature: o61cfywhfc5zsd6gupuf7ch9whbnbs1t
X-Rspamd-Queue-Id: 2AB7B20008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784373015-665802
X-HE-Meta: U2FsdGVkX1+X0hEUWa2f3lPuM0cv5mkE2JxCaOpMILK4N4ZHS/Vk8qdn9m+mb8hYEOVmBa9LTJtwGJWT4eE2/7gPVoq/caV3Bj5CONFaJhT/zuyICAZYEpPZ+bZcsPQmq9UVIM68rispRwFw12xNFq0J3DzJLOcaSC+JdPUWvqOYoF5V80VSpghsINOd0lEiu6zCpz3P0IgVqwW295WD0pPgd0IKgtxAjkNI1wh19oddLLHh2Oz7t/eC8bb428citk7snW21pg09QqmGDU4nsHTt7yZXrPkGPy9zU6J1q2xedKyY3boVyDeb4kGt2ak6ce9q8yINN+NRrtdrQZ8ulIa3pmhnqOaYwz17ylk+pSMNN7C02QdIwfKFc3l7q6/6WLpsIdJS3CWL7//l1mx9sXTy+Z7fW9Wj088pvw+T3lLQe/q4v8ACE6b9GPvcajy+Ay0VIMbcreNf5Jozv6DzOPSSeWyEjVy1C7FUWNmelubxcfbDH9L1GyTaV6gennYRkJAPFxl1L8pVtkcZDrascrgFrqfcl/+bWachtJlLNJHgZ+LHqtTIpWqTC7jhQiAKq+w027YHlFe0dzN1CjrgrhI9D6uCNWH0XWv1eYES91eP19UfB5D4zn9R3J9C0Iop4FMQVaejAMEvQnwumKxypXvpw9G8cZ0buBZHJOpF+0ihEFsWG5sLX88qoT43z4m/vIV6N532rN8d2EEIInOrWLs8f4f/t3JRCeTG4aLKMv8X3kyYzibRjanLCNDgrln+JhTLglUTDSllXS8jO3aY7zSHV16ChG7Dn/N547KA6/uSZG8AvUuQ/NOgtZEqB/Y670+i5X4xaiT2HlQIC91J7LS7Kla15DniPw5ApuDVReG5T3pefifNVDfT3ajwXM+r8tUZP3/rbjApb3Q2YyHSmZmYzSlX6LG+3AV7nDst3MIu/7WJ9tsmuUuDrRdydJrBcb2f57LFVt1X8tUyO4/
 iikOmq2e
 erX9HNR/3ooRyQXJyt6Z+bZdUIq+MUeVI7WkDrwEie6w6k2dI7on4m1UKx42P+iRG4b+xKXj86J3O1BQBL0bPFxVY6ZGDbfuvC5ljrdvGftrz7IHvpnmbky+uZK6SZLLH7sJkXCYERZnO/m3zdZCekVyocL0no59EOlnpX6Ib4eUCzFJrAaQhNqp8L+HSnEjxLhpNz8sTuqMEtA7a8ZRpPHtzJzSSiKXGbwyBzfY3uih3o/8Szs4xLJ8FlVobSAGUMh5Ykv70us0DrhYcNbP3y//uMRI3zqCUfkFcM3vDlupwDWyqBaxgggmOfLrROxh04bA4IEvGwPD0BEj6lrHD2PL5o2ix4kK7FBcK6bY0J9xEq9L/aBOF5tYtsCbxO3R6nYexyUSKXoCNR04AnWOZRyiXIlaQNBZVaXroVo8lMmtNXtKJerT1EQ+K4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 11:36:39AM +0800, Alexandre Ghiti wrote:
> When zswap writes an entry back, it allocates a swap cache folio,
> decompresses the entry into it and writes it out. That folio is cold by
> construction, but it is currently left on the LRU for page reclaim to find
> and free later. This wastes a reclaim scan and keeps cold memory resident
> longer than necessary.
> 
> For synchronous-IO swap devices writeback completes in the calling context,
> so the folio can be freed right after the write rather than left behind; do
> that. Because it is freed directly rather than through reclaim, it is
> allocated off the LRU: dropping the last reference on a folio still on the
> LRU would trip the free-time page-flag checks. A folio that a concurrent
> swapin has meanwhile claimed is left in place and reclaimed as usual.
> 
> Asynchronous and filesystem-backed swap complete writeback in interrupt
> context, where the folio cannot be freed; they are handled in a later
> change.
> 
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap.h       |  3 ++-
>  mm/swap_state.c | 17 +++++++++++------
>  mm/zswap.c      | 36 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..c617e5a0257f 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -306,7 +306,8 @@ void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
>  				     unsigned long orders, struct vm_fault *vmf,
> -				     struct mempolicy *mpol, pgoff_t ilx);
> +				     struct mempolicy *mpol, pgoff_t ilx,
> +				     bool skip_lru);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9c3a5cf99778..048efc7ca612 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -403,7 +403,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  					swp_entry_t targ_entry, gfp_t gfp,
>  					unsigned int order, struct vm_fault *vmf,
> -					struct mempolicy *mpol, pgoff_t ilx)
> +					struct mempolicy *mpol, pgoff_t ilx,
> +					bool skip_lru)
>  {
>  	int err;
>  	swp_entry_t entry;
> @@ -484,7 +485,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>  
>  	/* Caller will initiate read into locked new_folio */
> -	folio_add_lru(folio);
> +	if (!skip_lru)
> +		folio_add_lru(folio);
>  	return folio;
>  }
>  
> @@ -507,7 +509,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>   */
>  struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>  				     unsigned long orders, struct vm_fault *vmf,
> -				     struct mempolicy *mpol, pgoff_t ilx)
> +				     struct mempolicy *mpol, pgoff_t ilx,
> +				     bool skip_lru)

Compared to the bool skip_lru here, will this work better? (not tested)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8afd0b2d7c27..7ff5254b6ff8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -487,9 +487,6 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
        node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
        lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-
-       /* Caller will initiate read into locked new_folio */
-       folio_add_lru(folio);
        return folio;
 }
 
@@ -651,6 +648,8 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
                if (folio)
                        return folio;
                folio = swap_cache_alloc_folio(entry, gfp, orders, NULL, mpol, ilx);
+               if (!IS_ERR(folio))
+                       folio_add_lru(folio);
        } while (PTR_ERR(folio) == -EEXIST);
 
        if (IS_ERR_OR_NULL(folio))
@@ -692,6 +691,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp,
                if (folio)
                        return folio;
                folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+               if (!IS_ERR(folio))
+                       folio_add_lru(folio);
        } while (PTR_ERR(folio) == -EEXIST);

It's identical code wise, just fewer arguments and changes.

Prehaps also rename swap_cache_alloc_folio to __swap_cache_alloc_folio
and update kdoc that caller need to ensure the folio won't be leaked off-LRU
and unreclaimable now.


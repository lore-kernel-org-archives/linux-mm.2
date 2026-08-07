Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07353C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0AF6B007B; Fri,  7 Aug 2026 04:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71C86B0088; Fri,  7 Aug 2026 04:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60F06B008A; Fri,  7 Aug 2026 04:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A42836B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:37:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ABE51C089D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:29:29 +0000 (UTC)
X-FDA: 85073799258.03.40C8C82
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id B7C252000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:29:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aXiQ39mz;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786091367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSdehXnGw+ibRHaOVjI8Ioi7JL8VFOTG325yque/uGM=;
	b=hIeb23KywFNsTe+suEN6SyLaN7Cs3mPGIZ+0OOMvlXyHIfC6pCcwpBDXX3eJSrdErVmzDs
	aLghpgGuVbVfYVu3GV/ZaOPDmJAGVS902JJNdI0eN1wtqNVIIybjJQ4/KUDBOPgQHgTv1O
	p0fw+jG4CbPI3hQZSTEXysMAd6Z/wmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786091367;
	b=iO5S6LfAB6VnzQNX/SKfW6yROaPJFJuckB17D0BSPrxidcHm7tjuaedGxALGffr9tJ0Hse
	9MWfAxptrH+gJVzWMQqi1JhFIk+VGc0Wn1xlkmDXtWBztDFvpk1xx2G/dIYisljgZlIgWi
	+cKnBv0fI5WxHQGGols9KSfqiU8Dc5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aXiQ39mz;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3811f512167so3748334a91.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 01:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786091366; x=1786696166; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jSdehXnGw+ibRHaOVjI8Ioi7JL8VFOTG325yque/uGM=;
        b=aXiQ39mzfinRpjNlxPYfAekCVO5zVnuqCFGSu5ejvP+sKQePky6x+AwS1t3x4VA2dA
         SG7D4opNobuYzio/s7+j+Wv3JiewKN62y3CXGXE2eMWpIE602f40/WmjPiEgVjkKKUX8
         IczQFiRcs219S7iqANMqzEpGSysj8N4/mMseIjBxBIqvmmZoEapDHTj4j+AiHXEddRZA
         kH1BzTILC6T7cAlJEvvBUvr6syZRe80lJ7r9hbgC8MqK3ZAgG+61GqzlrTXInmsjcwm2
         F6krGT5zttB1vGV1nJ62ekruQxbE0x73H/edgd2Si9cptKVfG0QFC4kx+CSNuLfaew+j
         QGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786091366; x=1786696166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jSdehXnGw+ibRHaOVjI8Ioi7JL8VFOTG325yque/uGM=;
        b=Bp7rU35Yv+qLbLE5KNJUy/JcK2lzB+x5ZB+jW/Dh+dW8EW+HdDy6vmQ98xhQgx7oJr
         m7wLpxs10yf3qU5Bec4wg9luAUzgMVZaSnfj70UdB/ke6rkGh9edOYzPHip2ZgkJKXcp
         /ntB87EmyrPO/cTjDi0yvevfNzJhdIul6Ok0MDFiy4ulkGHt+kXH+zfPTHWa1pnfIxUG
         XZDo499XA16XgdAwjztCuP9fgqjmzVad7+Pt+i7XinWLOxNW9/m4iWmt1cw9BYe74epB
         vle6e63qk1NLU/8KKoz6H8jrTFI8W4/kuioXDqMiCYLVn4JqU4WkRVulX9RzKINcA5bm
         Sx5w==
X-Forwarded-Encrypted: i=1; AHgh+RpM9PaYqJUJLc02msJkF20atWrIcOMBz7OcnV03IWUQKWrplPpcJFSRAuXD1Yk6QWUSYUpWAChQXg==@kvack.org
X-Gm-Message-State: AOJu0YxqOUXknK+gtlBUwp/hQWwDhxjhun4vjYl2IthYobn19FFBblix
	9p9oQQZUS9uewJGs/iy2F4oiO4kPsRHDcslK9b+O2qAA7Tpf5kz3C5ua
X-Gm-Gg: AR+sD12hnXpvoJNu+d8uSnLo75/nbfOs4bDDBsXWf/cgwiYljUSHNUsHZrIZmBtGZII
	4Hoarqsada+gPRCBwJYACWAthEP1xm/IzVjgCBb5LXE+idXxiS7PCDMJJHU52HoJ7r55pygxNF4
	5QV5Fg6ecOCGRvgabIZhmK/QjTC8OULzQDzKD05MisUQ1Brfv2EzmOxGhwTYtipY2yMWPPxY4En
	gTK5EZUX/wc7JPYsaYIa1bzVuf6XELhgj159nl6mTzROED9s1GdRs9ebPaAFswvtFvQthk0IsS7
	FUdgIQpuszCg1YrnxzmwlH8Jta2EhbQk3QHxCTnEboZn089StOl2HpQAkPqxRDdI/tLfW0gODK1
	9W6tr2d1E44WfStWHkiYKf4CyHn+yNqQgrD7n7WWDHgJJHC/boaTK9N2ceWNqrXFdV0ZTyyQZTJ
	NMKl+dI5sdUr9218mfip+UHjHFsCBE3zc84l3J2DJS01RiOFEWgnlcdjT5eZ6md3k5oeYUPu+ZS
	17dVcuW1z0qP4bZLlDmJRReZ1iMc6hn6Q==
X-Received: by 2002:a17:90b:41:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-3903c5bd850mr22010506a91.14.1786091366383;
        Fri, 07 Aug 2026 01:29:26 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925ff23539sm1569505a91.11.2026.08.07.01.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 01:29:25 -0700 (PDT)
Date: Fri, 7 Aug 2026 16:29:17 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7C252000B
X-Stat-Signature: 55m7fuiy1ydb49ekj6rtxb7e8b84tkig
X-Rspam-User: 
X-HE-Tag: 1786091367-354512
X-HE-Meta: U2FsdGVkX18hk7UEOA4vW/DsJ/Br6/tl8r7XBWnZm0ZMkUB6GVU63CM1PMjnRsX56G+rZgRrHPtafCUnZ2Q3omxQ0mC1wWk9oKHQz/adnrq2l7QmY67zWyzbvlCe4KlQTmHLGXMwfoKB5VZT0cwRxUB/F77glyWzEkDdiYsgYPLJhf2+9PseABabJtJdOLNn2IMvM9UfkXwsUFoWKBtBekl76niX45+E6HWjZ2T9knKMNtCeSjew9Xf6b3iOJDQBn2R9BCP79Z/0WC7/3+8b9ddNaQYJndi+w/ZAUi7WRMD7dJFFsRVhBs7JftOz5j44w7mqsB+2QmMVF+ovHvcVobCLeYNUrVzjm23xSeWs4F0IFhMhKrX6NPYy3tKvEs0HMsgv7Bvrnh2W+unsuv03UrMl2gZceMhhA901sT6LomYvEPvxeN7ScBLUNyNzSGtkf49lY/wYI/X6BDhdIZSS6RyhN45CNfcT8TgjGHEK6HDtr92qbkKWHXt8CBcAiaPG0j77SSUzZ4yzKG30aGVSJYkt/RawstCldmEz/CJMllB8rVTS3W+5HfOXvkhrb0IGqBJHFQbay/sG08f2d/yeF6AP7fOA1BqL2eU+uJeLwiDZ5E96Yy88PZawrSQtQB1cyb4HXF0IhYqG/AwgK7AHUG3HJRtOB8EoUPMQtjvilXvJT9Q6Na8FDUFqt3jqnORWy9LU8uhUBogfjsoKPP4VHSurmva6pPG9OqbvGOTkHwwFgiCtbBx/9EQXMpmRHfymmdTjfOfiTyMKqY6T/Fy+GYRF0p7xHyvBnYHgIV76R6dQ8xQl71VTxscdl0stsakfzWEvMXIsFj9zPel91J3auRWMfgjls46S8K9i5znX+WSgjtmXiXDBxUsuvE4qV7FNg46G/SNLhNRPmBfoKUtpV0GYNtF2KxeYTLPJQiHytn3x5T0jDrea70VjJnnpgrJHomWo4uIcQQkmaCvaTMk
 WNJ9lAKg
 QoPb+EcdpuhJcSZehLhNwDw2O7CohYmLzPpVVC3QZWIsT/RCh2tEso3mriDVYjSuw96fVn1Z1UkcrrS4ll71ItlfMb0yZsatIc6IZn+kzW+HrvO8Gcl0UNlcglvhpowZnh3VgWPjlQvv6Fum2Jlcj3VmHq4QIjBs6jNvMs9dt1YEW9n6gSafQ1t1u8hkw15GyKDL+xcM4EgN0kjGIAeDNp30rYPDLxZRhWpKxy2G0e5/nDVIj2Wj+yqrs+XmVUmQXb69wbciNvcWGz6KhSY4VLcviVKGSIo1OkQgAHgZADMxNrk1UFUAjVoXbTdC13U9YWGGYZkrqPYeXEZfEmBn7gq6hQdEccPQTnxqsMA1j0Hu+E6dqHepIgwQVoV0t5QX+oeyh1RtoozW0SEC3MhbgW9dp9U68xK2sJ2bJ3J9XD5qhE5SHRbPL+KkREbRiqMXuJNIptf6EajoSg5bWaX1YBvswWn6JbLctNGlhDnzr0BpsPf4RD2iaG3OPsqBP5nJAEsr4o3+9skxITH1pi4IEiMBSYjPGeZE0+3dmzYT5soX3rm4oZZ+e58N0vmrm5bt9qhM6v3k7QFOFzbdo3mKVxI0E0SewncTOZUtFlD0Xyd4DWSCBlpWny3hBLC9zlulXOrQ73rC+kSSXt7lCa/Jz92lKbhelJ2He9oymhZ9k0g1e0dNsRfxQYcICo7MF5PZecekMihYUqdrTTePEVT/MvoLucZMkEUhVoMG4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
> 
> Keep the global free swap count and the remaining hierarchical memcg swap
> margin as separate inputs. The memcg charge path reports only its own
> margin; folio_alloc_swap() combines the two layers when classifying an
> allocation failure.
> 
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no global swap space is available, and -ENOMEM when the
> failure is not helped by splitting.
> 
> For early large-folio rejections, check global and memcg swap availability
> instead of returning -E2BIG unconditionally. On a memcg charge failure,
> swap slot allocation has already succeeded, so use the remaining memcg
> margin to decide whether a smaller charge might fit.
> 
> This only refines folio_alloc_swap() return codes. The reclaim callers are
> updated separately.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/swap.h | 16 ++++++++++++----
>  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
>  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
>  3 files changed, 67 insertions(+), 13 deletions(-)
> 

Hello Xueyuan,

Thanks for the patch!

> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0544b2ec4c56..7d12058174ae 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  #endif
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio);
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> +					     long *swap_margin)

Am I the only one that feel this returning argument is a bit ugly? See below..

> +/**
> + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> + * @folio: folio whose memcg margin is queried
> + *
> + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> + */
> +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> +{
> +	long swap_margin = PAGE_COUNTER_MAX;
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> +
> +	if (mem_cgroup_disabled() || do_memsw_account())
> +		return swap_margin;
> +
> +	objcg = folio_objcg(folio);
> +	if (!objcg)
> +		return swap_margin;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	swap_margin = page_counter_margin(&memcg->swap);
> +	rcu_read_unlock();
> +
> +	return swap_margin;
> +}
> +

Will is be good if we just always check the margin use this helper
on alloc failure? Alloc failure should be a rather cold path I think?

>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>  	struct mem_cgroup *memcg;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 70b90fa9c2a0..ae62c9f9c0f2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>   * swap cache.
>   *
>   * Context: Caller needs to hold the folio lock.
> - * Return: Whether the folio was added to the swap cache.
> + * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
> + * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
> + * would not help.
>   */
>  int folio_alloc_swap(struct folio *folio)
>  {
>  	unsigned int order = folio_order(folio);
>  	unsigned int size = 1 << order;
> +	long swap_margin = PAGE_COUNTER_MAX;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
>  
>  	if (order) {
>  		/*
> -		 * Reject large allocation when THP_SWAP is disabled,
> -		 * the caller should split the folio and try again.
> +		 * Reject large allocation when THP_SWAP is disabled. Check below
> +		 * whether splitting and retrying can make progress.
>  		 */
> -		if (!IS_ENABLED(CONFIG_THP_SWAP))
> -			return -EAGAIN;
> +		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> +			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
> +			goto failed;
> +		}
>  
>  		/*
>  		 * Allocation size should never exceed cluster size
> @@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
>  		 */
>  		if (size > SWAPFILE_CLUSTER) {
>  			VM_WARN_ON_ONCE(1);
> -			return -EINVAL;
> +			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
> +			goto failed;
>  		}
>  	}
>  
> @@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
>  	}
>  
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
>  		swap_cache_del_folio(folio);
> +		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> +	}
>  
>  	if (unlikely(!folio_test_swapcache(folio)))
> -		return -ENOMEM;
> +		goto failed;
>  
>  	return 0;
> +
> +failed:
> +	if (get_nr_swap_pages() <= 0)
> +		return -ENOSPC;
> +	if (swap_margin <= 0)
> +		return -ENOMEM;
> +
> +	return order ? -E2BIG : -ENOMEM;
>  }

How do you think if we apply this on top of this? (Not tested)
Should be no behavior change but outside the existing races, the margin
read moves from charge time to failure classification time, a small
TOCTOU, which the original also has but in a different way.

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7d6216c8b830..dcf01d4c5e1b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -490,13 +490,12 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     long *swap_margin)
+int __mem_cgroup_try_charge_swap(struct folio *folio);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, swap_margin);
+	return __mem_cgroup_try_charge_swap(folio);
 }
 
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
@@ -511,8 +510,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     long *swap_margin)
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b4c65ccf3538..d89054dd96a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5650,13 +5650,12 @@ int __init mem_cgroup_init(void)
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
- * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at folio->swap.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
+int __mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
@@ -5675,7 +5674,6 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
-		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5689,7 +5687,6 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		*swap_margin = page_counter_margin(counter);
 		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d8d04576c13..09760985b911 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1756,7 +1756,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1766,10 +1765,8 @@ int folio_alloc_swap(struct folio *folio)
 		 * Reject large allocation when THP_SWAP is disabled. Check below
 		 * whether splitting and retrying can make progress.
 		 */
-		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
-			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+		if (!IS_ENABLED(CONFIG_THP_SWAP))
 			goto failed;
-		}
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1777,7 +1774,6 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
 			goto failed;
 		}
 	}
@@ -1794,10 +1790,8 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
+	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
-		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
-	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
 		goto failed;
@@ -1807,7 +1801,7 @@ int folio_alloc_swap(struct folio *folio)
 failed:
 	if (get_nr_swap_pages() <= 0)
 		return -ENOSPC;
-	if (swap_margin <= 0)
+	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
 
 	return order ? -E2BIG : -ENOMEM;



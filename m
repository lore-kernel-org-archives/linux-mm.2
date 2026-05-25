Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F30CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4A96B0005; Mon, 25 May 2026 15:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D651E6B0088; Mon, 25 May 2026 15:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D2E6B008A; Mon, 25 May 2026 15:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEA1B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:45:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 627EF1A01E3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:45:13 +0000 (UTC)
X-FDA: 84806970906.25.0CBBFF6
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 840521C000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:45:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsUe7Uzg;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779738311; a=rsa-sha256;
	cv=none;
	b=xkfQAyVmNDTsTT95B7nJ36fceIDVHLQWbLSL05qkOFaYs45XgYU0qi05KQ9SUzTz5JZvNa
	b1mN5PFe1lvyxR/hUdkQyAiBQ7hynDDclSz8yuUOOHP0z8fSbbvYHPjJndRVSt7ZJgbCw3
	hRhx6WWm31TJWyonD74a2MKBljVW9bA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsUe7Uzg;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779738311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zykbN+jGNP67mLi0kvuPWW1N+NMv5CejXUxzHJ+T28=;
	b=N5F30M8RpLjmH0Fg1xn6vWSDVIaJHJQn5gOAcuo51yUpzviyAOESSZHgVcrdkSERaTC37e
	pfxjD9mF/FwniMyPiOErzU/1Xyl28J8KMRcG/2TNKV3adSxb3Buxp5/aBtaCgPeaVcMBs1
	ab/v++01rVDpTdKmb8/K7aO9bo2Njyk=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7de7c57b52cso8635214a34.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779738310; x=1780343110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zykbN+jGNP67mLi0kvuPWW1N+NMv5CejXUxzHJ+T28=;
        b=XsUe7UzgJqm9mURgBGvLLZTOGtRXs1KuRkD2rkuvS01q5AKW4wTizEocaCcencm6jJ
         LRqUn3FQzoNqa4g1CAF86IxE/9Z7wIVnxSLmj+IrSRPb/ncEKdZQ+TB3Stjj5y+zV60P
         4hcykjuGIcqtUsKD4tNb2MpwfpB2lfPNqzNGGz3InYDApAk3tK/6NNnzCGAdD19q7QIF
         LsNengJV97t9IIKuoZYevAgHy/SsXF2gD5TUf/4VKlDzFxi3nh2JI5qcR4jlyEJCbuEi
         PwQ21BIx+2JEYWt6m2z3m7tHaq/wkW7wc3wob9jRf0418LI9uswFzz/EdWsNmhwpd3zw
         9L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779738310; x=1780343110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7zykbN+jGNP67mLi0kvuPWW1N+NMv5CejXUxzHJ+T28=;
        b=KyJnvYDy+i9V7YFQRfOjzCrDrPJPu7eJMHnKD/WJ3rvfBDZrdNbw2cNT6VuHaGgkh5
         +/ExzZMBlc5NXFvBDP7cgjJWnLakPJUU3kT/TWKBr3jGT0tvdHDCZZEF5KHw1BzqG4Vv
         ZvYDNFZ82AkHHDS6a4XwLaNVLLSc/YfQSo6R5sym1+u9RFgZYBWZwLjFNrm8WLGbeQl1
         9b65aHFwj6KlkBotK66/U+D8EHgo5UYXtMpMI2eR46Q7hf/RamFr4wK0rcujlzE2qp3s
         vYeglgAlDPvdf2d36Vp5hLFztBF1tVnShEgU+lGdYg4qNH0vitcMcMnWae5woyuqjkmg
         gh+A==
X-Forwarded-Encrypted: i=1; AFNElJ8HLsATUlwGdZf5FhHhZ6/mhwe3qEoTy9MwX5a5p7jU0QVC+hJNJJ109ZBQJtwIYE8W8EJ+cxDeUg==@kvack.org
X-Gm-Message-State: AOJu0YyAHQYYTmJRqTL493biRxhjgvsc/qeHANBviQlFVNU5N9DbPv3v
	hsgUGk/Rs41y1qRlYfnz7byJgLdF1J+jG8FoYrJVFht+TWXwsdN29z0y
X-Gm-Gg: Acq92OFijywvExue4IDzWMn3J7BisqdyCeKluZfny78oCyOBqvWhh0kaDzfHQoDS90z
	BSQWVphw6fx5bs+BhFS3yooM8ht7QtD3PC40iY2PgvMcLolF4zSAKIc/T0EtZoM/NAiLn7seh5j
	2YdnfrWSxR3EG5ZfDlC+xWW0q2p5rTutmhAohXQnsglupWumdZ1cSxU7Nl0nndpbxLfr49IGhUs
	MCNPPGqHLLz61AvGhs3TM/lJG+8iLTrLpynkHQi+y24HTjgHvooq64h29gAf0dhI/6VCfNLfhSu
	7gqYQ0BksxSKH+Cl1Amvrq3tlOQbyA8iiHk+cEZ2WOqaOeDYF2EoCKpkarelEMsyR/24yboFEQq
	Zg31vjqV4MFl7i/e5GaA+ycUkMZoFGVL3tKULGY8/7SdA6dOxEeJHTU7+LB/o2guXsKXyAdqyVT
	OQ97APBEd5u6cc70IAeDM9BlA6hrj8zVqiXpgtSOnN1j++lSTsspjrh7lv5q4ejvay
X-Received: by 2002:a05:6820:1992:b0:67e:eb4:238f with SMTP id 006d021491bc7-69d7eb9b166mr9236509eaf.18.1779738310511;
        Mon, 25 May 2026 12:45:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d83700d55sm5369544eaf.4.2026.05.25.12.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:45:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/7 v3] mm/page_counter: introduce per-page_counter stock
Date: Mon, 25 May 2026 12:45:04 -0700
Message-ID: <20260525194506.3414995-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-2-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 840521C000D
X-Stat-Signature: oi5o37aeyhz1nh58i16f3i97kfuyee7b
X-HE-Tag: 1779738311-746840
X-HE-Meta: U2FsdGVkX193OsDGLTzoCYpNuNJJU61ej0PePzUS74ESr3mfZ/0nS97p8HZbnXxffHy+Uk+6EhcYfI2+Ag+/68kHXWG2RqyEPHCrfElz6dGrj1sIWrcu9clArDxHT7FBmciy8XLV54G12+5JJ/+VwXowUQ2fk3KgQGQkRowjDNna8ILulN+gxTs1pcASs33RxwOlr49H37w6IQ+df36VtyRsExcsbci0vaUwYbSlsQxDBBoVbLkv7Rur22A/OEeluhMhtu3xv2vM7nyvibVGPapMVFqQF4qp/tGqncwY/6KaTDh+c0W+TWVdQHM2vlvAWMbpmIr9M4uEyPASQt2ZHPM3kQ65VQgWEM+eba/7RiOeM3Y2egfSFZzXrIFVrTEdIwIQe/TjZtT3JtM6oE5Mpg7P1Z1wzL2KbCUAEGpLk8EAr/3sBLpufObWNu9Zjbz6OH52oP0Ig6Pgdz52CDlH4/QdAPAFIl80BwF5GGJ0ESHIHavNaX0ZOeW2ESjmjqAOLDD/OHW+onN/OaaKuZ9ipv6IWHmS4qIdVtnYAmZ5YRjDcGSOoonks/fgdCGbXm1r/bYk/pmBcVX9Mv6oakTBOXYVwgSSliE1XtArqH1v+ttF8qF3aKfPxiKcXF7EyN6aT5nw/OOer9VidZ7kbv6cSf59yN4fFQbgwGJurzueGHQSE/H23pLrHKJ4Hg6SDO4ZoPELe8GxtOLDGgnq+n9tM5HIoGFio5CQnNyvQ6fUJ6gRoNLFkAnMuBFDa4aWm4UfTHMgmEhseQbGEP7frF5l99pRESBz4emwlVIM/gwHjPCUMy9/ke/rTO7JhChkZlQaCnbEyCuB+Yz/JanrOVjCnbmZnUUOI7aWoxke5Qoa++Wfi+4XgwJQeLdavO9SpMTWvNd5YY4jksShNPzPZHtL0xlnl8cUrDxTBDVR0pTET0dq36dU/H8I+ta7x/v5t1kEwI5VvVKRyNOOsiZHG3b
 jsmaGu8A
 XJQkontwcOSJ3uyZSH8Eh4UyEb4JP2C/20YS2P4i/4Nh9YI+wvTCaIT7iRJdh3aWNt6oblan4sslZlL2UPq7tGml5h5MINwXeRyrZDdrfCImSW8QlTJG8hY1nlhqjyaamTnQhjNhj8yDpHlscpbHyEi8qNR9H7riXkOFB1G17BoSTQ47wVU10y083uV14IeYMP1Tbqz3IW0BjDSlecZeUUkdlr+sfbQto2f6MSn5gPflrSSplOIWL9jMZte7MUOi1o7lfSwk+Zw96NeJgfiwbRSlbgLg3wOyN1Zu0k+yXGUDoyMIdXD97nKRT3KIC1irMXjTM9IP49uWi6YZ1npFnRo+tMzVfZGNgWn5kfErWQdDErRzE9UwP354ORx0AwIOlXCHUZ4qYubW0Uk4yLcXq80i7QaN0PVnBFyz395TWi0/tQSyDkzaYO2J5KcSwPD9F2e+TR/m5ZprR0sSR0BRoVTcNvtxgpauhYKNLwFLhSesfKPjekqFRIC4Jn1tG8zLE2ZzdTqzcHaZJAOGcKj0gB51TxAPXLgq7ePcp3/8Aem2ZWspcf5J4Gxgv/DVSINOWgLfkYJ0D6pgg3QoFfKJWcgGIal4XCZZ1+SeP7eHmJ6yxOFgp5s3Yp/LvgGL4EusrMrvj4Ej8og46bhdXZLI0fXlxN/vmbN0fxiRnq8gl0CktBJ32sd0wkGXTJza+CIZxwJlG0nsnkuq0QLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 12:04:48 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> In order to avoid expensive hierarchy walks on every memcg charge and
> limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
> pre-charged pages and introduce a fast path to try_charge_memcg.
> 
> However, there are a few quirks with the current implementation that
> could be improved upon.
> 
> First, each memcg_stock_pcp can only cache the charges of 7 memcgs
> (defined as NR_MEMCG_STOCK), which means that once a CPU starts handling
> the charging of more than 7 memcgs, it randomly selects a victim memcg
> to evict and drain from the cpu, which can cause unnecessarily increased
> latencies and thrashing as memcgs continually evict each others' stock.
> 
> Second, stock is tightly coupled with memcg, which means that all page
> counters in a memcg share the same resource. This may simplify some of
> the charging logic, but it prevents new page counters from being added
> and using a separate stock.
> 
> We can address these concerns by pushing the concept of stock down to
> the page_counter level, which addresses the random eviction problem by
> getting rid of the 7 slot limit, and makes enabling separate stock
> caches for other page_counters simpler.
> 
> Introduce a generic per-cpu stock directly in struct page_counter.
> Stock can optionally be enabled per-page_counter, limiting the overhead
> increase for page_counters who do not benefit greatly from caching
> charges.
> 
> This patch introduces the page_counter_stock struct and its
> enable/disable/free functions, but does not use these yet.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h | 13 ++++++++
>  mm/page_counter.c            | 64 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index d649b6bbbc871..c7e3ab3356d20 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -5,8 +5,15 @@
>  #include <linux/atomic.h>
>  #include <linux/cache.h>
>  #include <linux/limits.h>
> +#include <linux/local_lock.h>
> +#include <linux/percpu.h>
>  #include <asm/page.h>
>  
> +struct page_counter_stock {
> +	local_trylock_t lock;
> +	unsigned long nr_pages;
> +};
> +
>  struct page_counter {
>  	/*
>  	 * Make sure 'usage' does not share cacheline with any other field in
> @@ -41,6 +48,8 @@ struct page_counter {
>  	unsigned long high;
>  	unsigned long max;
>  	struct page_counter *parent;
> +	struct page_counter_stock __percpu *stock;
> +	unsigned int batch;
>  } ____cacheline_internodealigned_in_smp;
>  
>  #if BITS_PER_LONG == 32
> @@ -99,6 +108,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
>  	counter->watermark = usage;
>  }
>  
> +int page_counter_enable_stock(struct page_counter *counter, unsigned int batch);
> +void page_counter_disable_stock(struct page_counter *counter);
> +void page_counter_free_stock(struct page_counter *counter);
> +
>  #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
>  void page_counter_calculate_protection(struct page_counter *root,
>  				       struct page_counter *counter,
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 661e0f2a5127a..a1a871a9d5c49 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -8,6 +8,7 @@
>  #include <linux/page_counter.h>
>  #include <linux/atomic.h>
>  #include <linux/kernel.h>
> +#include <linux/percpu.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
>  #include <linux/bug.h>
> @@ -289,6 +290,69 @@ int page_counter_memparse(const char *buf, const char *max,
>  	return 0;
>  }
>  
> +int page_counter_enable_stock(struct page_counter *counter, unsigned int batch)
> +{
> +	struct page_counter_stock __percpu *stock;
> +	int cpu;
> +
> +	stock = alloc_percpu(struct page_counter_stock);
> +	if (!stock)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct page_counter_stock *s = per_cpu_ptr(stock, cpu);
> +
> +		local_trylock_init(&s->lock);
> +	}
> +	counter->stock = stock;
> +	counter->batch = batch;
> +
> +	return 0;
> +}
> +
> +static void page_counter_drain_stock_nolock(struct page_counter *counter)
> +{
> +	unsigned long stock_to_drain = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct page_counter_stock *stock;
> +
> +		stock = per_cpu_ptr(counter->stock, cpu);
> +		stock_to_drain += stock->nr_pages;
> +		stock->nr_pages = 0;
> +	}
> +
> +	if (stock_to_drain)
> +		page_counter_uncharge(counter, stock_to_drain);
> +}
> +
> +void page_counter_disable_stock(struct page_counter *counter)
> +{
> +	if (!counter->stock)
> +		return;
> +
> +	/* This prevents future charges from trying to deposit pages */
> +	WRITE_ONCE(counter->batch, 0);
> +
> +	/*
> +	 * Charges can still be in-flight at this time. Instead of locking here,
> +	 * do the majority of the drains here without locking to free up pages
> +	 * now. Any remaining stock will be drained in page_counter_free_stock.
> +	 */
> +	page_counter_drain_stock_nolock(counter);

Sashiko raised a concern here.
Allowing racy charges is OK, but the problem is that writing stock->nr_pages = 0
with no lock here can race with the reading of that value, and lead to
double-uncharging when racing with concurrent charges.

I think that this can be fixed by not draining in disable_stock and
reordering the callsite:

Before:
drain_all_stock(memcg);
page_counter_disable_stock(&memcg->memory);

After:
page_counter_disable_stock(&memcg->memory);
drain_all_stock(memcg);

This way, the WRITE_ONCE(counter->batch, 0); should prevent any
future charges from trying to land, before we drain stock.

Despite not allowing any more racy charges, we still need to keep the drain
in free_stock since drain_all_stock() uses a mutex_trylock and can fail;
if that happens we need to still drain the stock at a later time, when we
can guarantee that there will be no more contention.

Thanks, Sashiko! I'll keep my eyes posted on the rest of the series as it
goes through the review pipeline. 
Joshua

> +}
> +
> +void page_counter_free_stock(struct page_counter *counter)
> +{
> +	if (!counter->stock)
> +		return;
> +
> +	page_counter_drain_stock_nolock(counter);
> +	free_percpu(counter->stock);
> +	counter->stock = NULL;
> +}
> +


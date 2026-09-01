Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84665C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9192C6B0095; Tue,  1 Sep 2026 14:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1566B0096; Tue,  1 Sep 2026 14:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA686B0098; Tue,  1 Sep 2026 14:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49B306B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:21:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0761C04CB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:21:24 +0000 (UTC)
X-FDA: 85166010888.14.DBB3B37
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFBC540003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:21:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gr7KVnad;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwtKl7Zg7TrJlKVsQMpgHVHuRB/fv/tJD5LyzuV86W4=;
	b=jMCmLoAZMuFmbqX2tUg/RcjUisgrvo72gEzgdUV1r9wum4IVPOmdeZ1B7h5hzwWEfOyJOa
	FfgxN2J/iCU1ZaDq2xR/kNyrLqMdcVphntflJcBeTEz73PMC56P+cqh8B3e1moL82m6F3T
	hN49/rnVPj3YMjrPPOAHo6GnYDxoJLw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gr7KVnad;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286882;
	b=fu+TNMaq1itFqTM227AynhptPiyWEjBVrvkFJQnWqTcLYizZkfFnUJnnYAP7zdBnfg5v8x
	NKYnKDp1M0a592I9358y/7ZTlHfRtxZ4c+NGNLdw3wx6cpNI9ckuphNGV1dExitODiiOOt
	bVGCq7dchJjEbefCtKCtZUUh7kplKcQ=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc1b838f9b6so193833a12.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788286882; x=1788891682; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zwtKl7Zg7TrJlKVsQMpgHVHuRB/fv/tJD5LyzuV86W4=;
        b=Gr7KVnadE+IVWQfA8BXKZyZznP7sr/k10Yqj2iMe20QMtyyzb7mjYTXmkHPQZrHB85
         7zn2Q2pqYlhfViVHTM8yVl0rv1KZxn68/M7uNinQ+k3KwlyK5+TO+TUrPaWhTnp2ke5+
         GI/47unedqQ24SEtxPHV8zMxTTKSnQrIfWKopkwcYlpz5gfCCcMdQS92CGyAs76KPaEf
         oeEG+AGeYXV3SE9e2x4DcCt8d3ZCX3a+7XnEE4c9/Cr021mj/d/SpezQyB1KMXODenGv
         0/AG2qmUklsN0Bz+8tb1eURd3kf1ShrZzMBhef5jjFQDdD9GiXbOGOSvZwmQq2OlU20L
         Q7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286882; x=1788891682;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zwtKl7Zg7TrJlKVsQMpgHVHuRB/fv/tJD5LyzuV86W4=;
        b=cpEe7IBIJNR3nq00q4cCmwr+PW5v+VyYcJ7im2dK79ay8I6WbMCL7uaaTVMpL9TGAe
         O5KEO49zaa8AB+WnykpbpFRgHJ7P7nXWcp70xZiRLXFCPEunDfuC87RlRmuO8BzCJeXA
         clg8PdxIcdmIWGxNXP94CYS7ReNk+LQsrtQL0LpMM6DwIb/I5LDPWx2SztKBQD3eWoPO
         mUpIKxnQvTisAQfA8zThq16ettiGFzlDkf1bC3ZqMNd+HRxtza6iQcSXh2CSWuDxA010
         /LGxVGsEa9v1LjGlrkEHQoEsSIHJtBZJyKicNxMaCwbuRME366YtLvIYOJ50UEcdBFQp
         G3VQ==
X-Forwarded-Encrypted: i=1; AKwUvBy03SFzihl4CD5Nabe1S+1f5AETzZ5OvpZprbR9LGAvW6szvUWmj0dHd8UApGXJvSm4XEUmXSjWCQ==@kvack.org
X-Gm-Message-State: AFuF++nxlsQlhfW4hi2dD5xgH2mpCRvxodslzeYU8Ox80G01EBX9n9TP
	H4DW7yjOxrfowfFtv7Z1jQ7sV1Mrt4V4AeBIe4VFou3z/yIKqbpYWYO1
X-Gm-Gg: AYBFou0gWpDuTcSeyHrrbFjBShydoe3OPCH6bYs9hCL1dgY+CLjKze5lIS8paoqplr0
	xpiulkmSspEfm51Bi2GEboFDTWmc3gi6It1IwiaOfv/NrhTVkUukPoknJ7E/+776LDGYuDdCZXC
	luBE55CMriPBauG3sr56PgE64Pl2ryIMip6wchtb/uZvpMJXqJEOa4u7QxsbqIkuWEoRc9UYj49
	sDZy9Rx8rmNrR1LXl3lbZA45CHOrO2qydFIkdLqjAcqq3evmwcvTBO3VGJPaokGmIqI9e2DEHL/
	QZRCdewu8zY9SFaUV8eQC18onN8NofOmvjjbvd/zK+LlwRMK/Nxj+GBO0yfAYNwDhjNK6o8QgGA
	m8qKmxeLwm6VzoIkum6zaZ1aMi+p7HmgoHVawDX4FeZK1VJQ2XyInVF5499O56sICrtle4iwOAm
	IMYvxlNV0VQcIF2ERcHW8IaM+blzggJJEzWEXh0pYbowOr/Q2YpIjSvyIzZJ90d4k2HCJpcilza
	PxjPaKpz7n0/+AS/PXhyXCh
X-Received: by 2002:a17:90b:1b0d:b0:396:b918:c2a with SMTP id 98e67ed59e1d1-39907e0f7ccmr14889557a91.12.1788286881524;
        Tue, 01 Sep 2026 11:21:21 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0f28b19sm946573a91.6.2026.09.01.11.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 11:21:20 -0700 (PDT)
Date: Wed, 2 Sep 2026 02:21:14 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Yu Zhao <yuzhao@google.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Message-ID: <apcVhWzEwkwHYjB1@KASONG-MC4>
References: <20260901180704.168106-1-ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901180704.168106-1-ehab.ababneh@intel.com>
X-Stat-Signature: y9mrqxhynx81sfdq9xcbw3nexmh58t54
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFBC540003
X-Rspam-User: 
X-HE-Tag: 1788286882-185167
X-HE-Meta: U2FsdGVkX191t6Gt06ivPwluGVNAKSFpX3f3CPINd3WHrb4o8pgGx8eQkZuzsV5/S+5/VuHDnxYL7Gm7uDGM2ZZjmsvjYqGqrBbulhIHRMoMUePN8QdPXqDfIHmFkfApUHjkUtNKnIBizL0eJ7WNXXWUHOpO5OXLILYVMMhU+aYChyhO5CjGGil8dpZ6sEuYRPwVcDNXFppPoU4JQEktBLY7pzIBNe2u1is1HOCk7PVTbTnTycihYjrD9Rfs+t0PmaNvlK2R2Olo81L/M7sIv4iWeOYC9M5XUarFg1VdlhzajzbGDchhFaAMItS1ktZt8Wx+Qb1HWyP2DBDx5fRJYipcnj56Dz5QREmr7zDYSbSipq2bfKWwNotPwwaCdYVuutXp61ag2lXHJ3OYbI2ya8iPK8Y9hkyDEFPE7LxQ+dnXuIfHCgOtPM00g/8+oN/ZuJ3T/ggqnu5Bv+X1JFq5UZrVf933IOiHcuQFjaAufom8c8W5qc+N4aDR95jRAEzEsKHVhyRYYCEE+BR4mnTw05mFrBA9DQo2iujvI0a4ttKxMbCBRDKBppEAfNarFXbV6noef6weHXxZZgSNuEmb8khrmF5NQZcf6gYRV8R2b6x4LeP23QM/HDXuakaIdAn97NUHo3eht5u1VAxTx6EflvgDjV4KB7yJG595k3t40Udrxgk1eIFP0zDBlFBpDSKfxQzDP3qwEZfeXTIVONj+D/gtbYAQIAkHQcKUDZ7eAPlG7lcPVNR6aRbYW/CZU2BGRjkeaUElSjp3vb67AAv2roujkWX0UNuRakU/7t7S0yQsEVub+JL83ViNC+iirHbg2MTvFWhmPN+poDpSi5rQ+FXeSY2pdwmpRAgQJ0d8lpr8xaMr4ll8Vh5bvZbB+2/k9nOWsK9UW+6oRcgfk+WJo9RchKOU1dbSqikgkufLSyMFYEc6rVP90LnXnimwjZnLquxUrswuEo4ffrdrjIL
 uhMdzFXN
 yYQ/nerkDCTosDS8KhTNGhhfWRI+3Nb5XlVhskzT9mn58Nml9LrfOciySVbaMtp+JxqjsH4Nzk4KDf5wGkDw4qXqkqaJ54s5xMC2xfvnpf4jTN+KnybGnNtX9Nh6JvKY/TdW12R2EGoO//6oj8U8l3mi8VEibprGkfm6GxWRyEYGcwfPWKcrbz3rFeLU1hASmCGbLuAHICg6soGRp45U/5/xBf8zThy8JdOwdsv+aV/Oupv4wx7k5VSxOmb3UyNHcjzNzgmK9s/rH7A0UZ0/E6e3hyr/Y5uv/9LnzBHE/kEyPJWavTkpIjxzF8oLDnfvYkNMH2PDeuJPKwG0ucAFhttFZEn5jbypvEzkt7frFHudZicoXnKY1vI8YDKmZSh6TfzhgWqLEr4uX5F3+hCXVrF3ccbvQDw5QPrdJ/pKruDm9Iwq5ysj6VFiIb7t9VK6771GxZbhexG3BIeh66h2hT+7f2qKGZYO/Af3y0XFzmE1yDtrtb3eLVZqpGsB4OX62OmHoTxttVj0+40CWcU0Bio2Gmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:06:43AM +0800, Ehab Ababneh wrote:
> Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace
> folio_set_active") introduced a regression for workloads that rely on
> readahead to keep sequential file access efficient.
> 
> The problem is that MGLRU can place fault-path file folios in older
> generations, so memory pressure can reclaim readahead folios before the
> workload touches them. In our Cassandra read benchmark, this raised p99
> latency to about 9.2-9.5 ms and cut throughput to roughly 41.8k-43.6k
> op/s; the revert restored the workload to about 5.5-5.6 ms and
> 51.9k-53.1k op/s.
> 
> Readahead is important for sequential I/O and mmap scans, but it should
> not be retained when the workload does not benefit from it. The goal is
> to keep the optimization without keeping readahead pages alive forever.
> 
> This patch provides a middle ground: keep the original behavior by
> default, but temporarily protect fault-path file folios when repeated
> file refaults show that readahead is actually helping.
> 
> The mechanism is dynamic and self-tuning:
> 
> - add a per-lruvec readahead/refault credit
> - accumulate credit on file refaults in the MGLRU refault path
> - consume credit in folio_add_lru() for fault-path file folios
> - keep the folio active while credit is available, and otherwise let the
>   original behavior stand
> - decay/reset the credit as generations advance and when an lruvec is
>   initialized
> 
> This means we only protect fault-path file folios when refault pressure
> shows that the workload is actively benefiting from readahead. If the
> workload does not need that protection, the original optimization
> remains intact and we do not keep readahead pages around unnecessarily.
> 
> Benchmark results for the Cassandra read workload
> (4 nodes, 720s, 100 readers):
> 
> - with commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
>   replace folio_set_active"):
>   p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
> - with revert of commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
>   replace folio_set_active"):
>   p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
> - with this fix: p99 ~5.8 ms, throughput ~51.9k-52.7k op/s

Hello Ehab,

We ran into the same issue on our side too. I hesitated to report or fix
that as I'm working on MGLRU-FG which fixed the problem on my side:

https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/

I especially mentioned it, see the parts after:
"recent change in lru_gen_folio_seq that bumps new folios with refs == 1"

Latest version still being tested which you can use directly:
https://github.com/ryncsn/linux/commits/b4/mglru-fg-v1.8/

Do you mind have a look of that as well? I think in the long term that is
the right direction. With our test the regression is gone and performance
is even better.

And is there any easy way to reproduce the specific case you are reporting?

> The fix restores the readahead protection lost by the regression while
> preserving the original intent of the optimization: do not keep
> readahead pages around if the workload does not need them.
> 
> Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace folio_set_active")
> Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/swap.c              | 82 ++++++++++++++++++++++++++++++++++++++----
>  mm/vmscan.c            |  7 ++++
>  mm/workingset.c        | 18 ++++++++++
>  4 files changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..c998b1e0b8a7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -578,6 +578,8 @@ struct lru_gen_folio {
>  	/* can be modified without holding the LRU lock */
>  	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
>  	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
> +	/* credit: file refaults indicate fault-path file folios need protection */
> +	atomic_long_t ra_refaults;
>  	/* whether the multi-gen LRU is enabled */
>  	bool enabled;
>  	/* the memcg generation this lru_gen_folio belongs to */
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..a31c9000868a 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -70,6 +70,70 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
>  	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
>  };
>  
> +#ifdef CONFIG_LRU_GEN
> +/* Refill two default readahead windows to amortize shared-counter updates. */
> +#define RA_REFAULT_LOCAL_BATCH	(VM_READAHEAD_PAGES * 2)
> +
> +struct ra_credit_cache {
> +	/* Batch shared credit per CPU to avoid a contended atomic RMW per folio. */
> +	/* only compared for identity, never dereferenced */
> +	struct lru_gen_folio *lrugen;
> +	long credit;
> +};
> +
> +static DEFINE_PER_CPU(struct ra_credit_cache, ra_credit_cache);
> +
> +/*
> + * Spend readahead protection credit from a per-CPU bucket, refilled in batches
> + * from the shared per-lruvec counter, so the fault path avoids an atomic RMW on
> + * a contended cacheline for every folio.
> + */
> +static bool lru_gen_take_ra_credit(struct folio *folio)
> +{
> +	struct lru_gen_folio *lrugen;
> +	long nr_pages = folio_nr_pages(folio);
> +	struct ra_credit_cache *cache;
> +	bool taken = false;
> +	long old, new;
> +
> +	rcu_read_lock();
> +	lrugen = &folio_lruvec(folio)->lrugen;
> +	cache = get_cpu_ptr(&ra_credit_cache);
> +
> +	/* credit cached for a different lruvec is forfeited, bounded by the batch */
> +	if (cache->lrugen != lrugen) {
> +		cache->lrugen = lrugen;
> +		cache->credit = 0;
> +	}
> +
> +	if (cache->credit < nr_pages) {
> +		old = atomic_long_read(&lrugen->ra_refaults);
> +		while (old > 0) {
> +			new = old - min_t(long, old, RA_REFAULT_LOCAL_BATCH);
> +			if (atomic_long_try_cmpxchg(&lrugen->ra_refaults, &old, new)) {
> +				cache->credit += old - new;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (cache->credit >= nr_pages) {
> +		cache->credit -= nr_pages;
> +		taken = true;
> +	}
> +
> +	put_cpu_ptr(&ra_credit_cache);
> +	rcu_read_unlock();
> +
> +	return taken;
> +}
> +#else
> +static bool lru_gen_take_ra_credit(struct folio *folio)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_LRU_GEN */
> +

Just an idea. For an short term and easy fix, what if we simply revert
than, then only protect in_fault && folio_test_swapbacked folios with
PG_active?


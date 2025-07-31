Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFBBC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764D96B0092; Thu, 31 Jul 2025 11:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73CB36B0093; Thu, 31 Jul 2025 11:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652396B0095; Thu, 31 Jul 2025 11:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 560086B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:27:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D43F2589AC
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:27:09 +0000 (UTC)
X-FDA: 83724938178.15.34A67F8
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id BAE8F1A0005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:27:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wnVeA38k;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4pg9j1SEq8vQjGPle5FHzKv/ap1qEHXDcWwxrXohmU=;
	b=MCu+c0kN//FeVfP7b0p33pnOepKZuLdh9NHksyNk3H0yGDyuFn68bOUs8K/F/q1YgUG3Bs
	KmRrF/2TqD7oD4Fu9BJvkQ1/tv+IRp+Y9j/DiQ47aC1LZXP6jZQbGyhl/sLYfG7Cuq9HgX
	rVxC8xaXFz+9BExJlfWNtcA2WX69Oo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975628; a=rsa-sha256;
	cv=none;
	b=HVWf6VGP+cyn5iOd68hVC/b9mUitFwoxLWyqrsS4XrCZjwFP7A0GIr8a7Yl+6IOlMrP68d
	et330A2zJE9zbT1iThPfJe6xfjZ1dHFsmvCOHbUEERjsHT9ocZIcqvNVNVBc4G3FCbxeUJ
	yDRIpc5KylcdF69BKwEwNODJEOWhTxA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wnVeA38k;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-704c5464aecso4900566d6.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1753975627; x=1754580427; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4pg9j1SEq8vQjGPle5FHzKv/ap1qEHXDcWwxrXohmU=;
        b=wnVeA38kfOyu5sVDU4LDbTqaSn1y2bCxwsCdHj11g7EleANa9Fv3TaJFw5dODo1tY1
         v+nDaqwUcUIv6E7OvG82onvTXYcb0x6HzDYW3FFRVPBqToL31RiqmR3/cvALmgWaJPGB
         w7yHt6jpFRYlBp+Lwoc2EwxXcEYldOMb7bsOB+fAdE+2cC7X6JxGlLk70ChKuSw/5JL1
         N8s0erpyr97cSm9knGPlyJ58BzdR0Bbw7vH3iZBEemBmG96uU/nViaiC+lB12FovDGP6
         bnYlioR69bXy7Wu5RLN0k2hsDxAwijIgf8LgxyuE70vEuoqCo4VDEpRzApBlvyvMheRj
         g6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753975627; x=1754580427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4pg9j1SEq8vQjGPle5FHzKv/ap1qEHXDcWwxrXohmU=;
        b=c1WUqIG6dBbmjvmIAuKMBBPUwCuh2Q9oHIn2Hwnto2uew25U2R1MNqZnOGKqyQlB9B
         Shhs00yw9tIGgKnDCSlsmUPcKek6ArT1zgB+iu32HLFGNME/Ch9i0pM7gtWKGyR7n3gg
         B4ao1swScm4zqtwnz5Y/C+uZHhfYgHSFd8jHOzL+EwwcUnENWMRf2dOzbk9KzqE0GoEB
         eBlymV0x6XQtC3ftij/b+mBeN1bd1zEoGuuq4zkU8x6/aYzWQz8qnJip3VQ27U9JUmNQ
         r0CMepc0694Hjk1Ljovw0fmZyS3yuKlI40yRTmE0QldMS7aJcgUNva1J8/bKgC7jfxbX
         HCfA==
X-Forwarded-Encrypted: i=1; AJvYcCXfsUIXw8IkAfDXDFMDDuay8DYg5QJKQMfMuuqmKjaezdjuaISs1vr2Y92bBcSrm6HNTenQ/1OH5w==@kvack.org
X-Gm-Message-State: AOJu0YycTZ5OPjINo6Pk+pVqUYjIwPJjaM89Y9C5eGEsc19Oeppsjs4f
	X2YLA1aJeLUzuNZEBGcLu5GaVTv6VoX5vPzRU8fzmusE5bb32poz0ycPbzQQSyisQgg=
X-Gm-Gg: ASbGnctOGbGd7Q9IKawe5jqQjIbdQAuf6r/YPW65/XlqGkr0Vy5A+2lUbW7PCzG2Qfy
	BJwv8tJNrxOb0iN/MTjyZ62x+ybPKmPzkJfMY/3PQMEyoD4HDXsqMfAvAO8Yld3SZRPu1dQM4VK
	w0yg6T+j0tRFe9G5Rd9Jw4dlLKJvKGQ0q+TrJI10t6BjGmY2NUZ4PsVjO+/GvoI3rmdXAMtzdrN
	wFhE8UuAcpU4+dxM4apJGJmOD57yZluTJbNSNmcJz3kizBTzu+u3rXXYzDcZ3KouJA1SDC6wb1h
	/eH2vIU7ajBezju4EiDn8zo3wEI3lmPJNZTH4tq9vh86LOi1o6XXesv9dQ4rov7IfXgpO7yj5vK
	/Cr2Zhou0bacPhgbT0rjg2nR8d7zBCz5d
X-Google-Smtp-Source: AGHT+IHhDifmV0d/gDdHQwtEHVVScsTm8lEu8Ton90aAMSsO61i5mZMoEKb5oe4dUy/RvmzB9IJg5Q==
X-Received: by 2002:ad4:5d47:0:b0:6fb:3579:8f07 with SMTP id 6a1803df08f44-7076710ffe2mr121804966d6.31.1753975626405;
        Thu, 31 Jul 2025 08:27:06 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-7077cd710a1sm8467236d6.56.2025.07.31.08.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 08:27:05 -0700 (PDT)
Date: Thu, 31 Jul 2025 11:27:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Message-ID: <20250731152701.GA1055539@cmpxchg.org>
References: <20250730234059.4603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730234059.4603-1-sj@kernel.org>
X-Stat-Signature: r9g1ok8ee713ymqjxip8nta5yempo1q6
X-Rspamd-Queue-Id: BAE8F1A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753975627-123174
X-HE-Meta: U2FsdGVkX1/Gkrqxy6GD2s6HRV2A9jiuBzWdlqw3Eydf1ZhEtYLGhV0vLtpUZhgK4BdCE99F1bLSIYewsNBxiCrqtugaDIWxMoIdM7b80oHAiQbkac1I417WHjeMOnur1gMZW/t8YAVvvANWMS5YHc9ARat6iDI3UXIRrCAF5eDwuaBCeA93cinCr5bJYT/MHZ80bMEGfMElB0U3TxB6cUtjfrdJaZGciJsC4Wv775q8eh7rdWrD+Fop4z/cgKE+1Vhu2Bemxsc+5adcJ43c1Eylh/GP1atF7GzoHVw0oDo46xrTUOr9hghdLxkCgepy8yyQcPz+iT0ngYFgHeBGP/9UAsy6Y3IGQUQgCVWCi7YR2D9GeyXpkKaA9RF79qWwudedns4c+ExHZ7ep60nXA03WSzp1x9Uppzvm0D0eCMVDhSIhd8NgfvfSL+llY8EkD2UncYbDwForEiYJal5Dk64BhjM9FiUVRIDgpqWwG6zkhcI7PFKjWvdtxRCdccJemRT+K77QFUIEHGKnMA4NOz255BdiTrZvxjBu2VCH6SFn13nEpuyNvjm2ZoD35viocePHBTF7FwDHTDoOWa4J3C0pK0JKJH4NUL9YTkhiHvbm++BBJcvVr4nHcavi+2G79wsKzmVysBVeQPWubloiriLItFLtca/hO21WB+EQCpGpqaQxqWJ20x0PFgGUeeHQOjVOtbrcVUEIwIobHJY52J7I5ep91DGfxyGRtNLDvBYyvmAWSXH12oT58Eo5E5jTtDiY4k9f+q1fjV4bqyr+x74gTUfRRZ1FPZWbI1ZVQLF7EXicGqwoubNMEFRqfKkoZ2Xueqjg45YOymtyACzcR+RBss5MBu1iiMiHp01c3ShW0EnfAYSTFCTZlayTWZlXR2sD21xvs7ocX5y3v4ZIqZVQevOsI2K+dwfTUC8PAK2eaPFig0IuQfCwpmh6u+XZhd5VH+Ip/7brvodxtoE
 5htTOQqx
 iLV8IPw+xy4aRRngx2wsDweBxMvQpaeHaBvOnVgHjFq3mVKMjuMGJOfT/lXGT7CVsx5XZB5ahuJhrR7zjG/FKzgDH0nA+JGCULB1BhF2ocs4pKsvf1GC1NizExd9cQCKhOoc7z5GBBNHRU0DJfskZVGEk792rTxaJGfKgA31IJT3aE+Gd6n7Y1YxEoESaNU4PZw94ctfsOjEPjCurf8qXuG8ttdkb24DuuBeRJQjywPNqdZukoa8iG0F8uNpxpgQaacJszKZ0NJaCwVoLlJGdSZoze9naDPM9gNktH+CoyQQulFt0qESZYdCQiuAGamTd+fMU4aX6jP7phcTdMWguIERo3aJfeMgcI5+GK9ZaQr2BdT0DboUF+iv9cCe6kuVVoHLQG35wzgyuWE55ytrvqWI6pmonfl91fF5JnAHwB0L7X1vCEUtFoTggFQFKyP5feS7YflPgxY5eNymaZ0INhUl/PDd8v3eSPk4P5cALyx4ej1ixJEnh0J2cdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Wed, Jul 30, 2025 at 04:40:59PM -0700, SeongJae Park wrote:
> When zswap writeback is enabled and it fails compressing a given page,
> zswap lets the page be swapped out to the backing swap device.  This
> behavior breaks the zswap's writeback LRU order, and hence users can
> experience unexpected latency spikes.

+1 Thanks for working on this!

> Keep the LRU order by storing the original content in zswap as-is.  The
> original content is saved in a dynamically allocated page size buffer,
> and the pointer to the buffer is kept in zswap_entry, on the space for
> zswap_entry->pool.  Whether the space is used for the original content
> or zpool is identified by 'zswap_entry->length == PAGE_SIZE'.
> 
> This avoids increasing per zswap entry metadata overhead.  But as the
> number of incompressible pages increases, zswap metadata overhead is
> proportionally increased.  The overhead should not be problematic in
> usual cases, since the zswap metadata for single zswap entry is much
> smaller than PAGE_SIZE, and in common zswap use cases there should be
> sufficient amount of compressible pages.  Also it can be mitigated by
> the zswap writeback.
> 
> When the memory pressure comes from memcg's memory.high and zswap
> writeback is set to be triggered for that, however, the penalty_jiffies
> sleep could degrade the performance.  Add a parameter, namely
> 'save_incompressible_pages', to turn the feature on/off as users want.
> It is turned off by default.
> 
> When the writeback is just disabled, the additional overhead could be
> problematic.  For the case, keep the behavior that just returns the
> failure and let swap_writeout() puts the page back to the active LRU
> list in the case.  It is known to be suboptimal when the incompressible
> pages are cold, since the incompressible pages will continuously be
> tried to be zswapped out, and burn CPU cycles for compression attempts
> that will anyway fails.  But that's out of the scope of this patch.
> 
> Tests
> -----
> 
> I tested this patch using a simple self-written microbenchmark that is
> available at GitHub[1].  You can reproduce the test I did by executing
> run_tests.sh of the repo on your system.  Note that the repo's
> documentation is not good as of this writing, so you may need to read
> and use the code.
> 
> The basic test scenario is simple.  Run a test program making artificial
> accesses to memory having artificial content under memory.high-set
> memory limit and measure how many accesses were made in given time.
> 
> The test program repeatedly and randomly access three anonymous memory
> regions.  The regions are all 500 MiB size, and accessed in same
> probability.  Two of those are filled up with a simple content that can
> easily be compressed, while the remaining one is filled up with a
> content that read from /dev/urandom, which is easy to fail at
> compressing.  The program runs for two minutes and prints out the number
> of accesses made every five seconds.
> 
> The test script runs the program under below seven configurations.
> 
> - 0: memory.high is set to 2 GiB, zswap is disabled.
> - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> - 1-2: Same to 1-1, but zswap is enabled.
> - 1-3: Same to 1-2, but save_incompressible_pages is turned on.
> - 2-1: memory.high is set to 1200 MiB, zswap is disabled.
> - 2-2: Same to 2-1, but zswap is enabled.
> - 2-3: Same to 2-2, but save_incompressible_pages is turned on.
> 
> Configuration '0' is for showing the original memory performance.
> Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
> zswap, and this patch under a level of memory pressure (~10% of working
> set).
> 
> Configurations 2-1, 2-2 and 2-3 are similar to 1-1, 1-2 and 1-3 but to
> show those under a severe level of memory pressure (~20% of the working
> set).
> 
> Because the per-5 seconds performance is not very reliable, I measured
> the average of that for the last one minute period of the test program
> run.  I also measured a few vmstat counters including zswpin, zswpout,
> zswpwb, pswpin and pswpout during the test runs.
> 
> The measurement results are as below.  To save space, I show performance
> numbers that are normalized to that of the configuration '0' (no memory
> pressure), only.  The averaged accesses per 5 seconds of configuration
> '0' was 34612740.66.
> 
>     config            0       1-1     1-2      1-3      2-1     2-2      2-3
>     perf_normalized   1.0000  0.0060  0.0230   0.0310   0.0030  0.0116   0.0003
>     perf_stdev_ratio  0.06    0.04    0.11     0.14     0.03    0.05     0.26
>     zswpin            0       0       1701702  6982188  0       2479848  815742
>     zswpout           0       0       1725260  7048517  0       2535744  931420
>     zswpwb            0       0       0        0        0       0        0
>     pswpin            0       468612  481270   0        476434  535772   0
>     pswpout           0       574634  689625   0        612683  591881   0

zswpwb being zero across the board suggests the zswap shrinker was not
enabled. Can you double check that?

We should only take on incompressible pages to maintain LRU order on
their way to disk. If we don't try to move them out, then it's better
to reject them and avoid the metadata overhead.

> @@ -199,7 +208,10 @@ struct zswap_entry {
>  	swp_entry_t swpentry;
>  	unsigned int length;
>  	bool referenced;
> -	struct zswap_pool *pool;
> +	union {
> +		void *orig_data;
> +		struct zswap_pool *pool;
> +	};
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
>  	struct list_head lru;
> @@ -500,7 +512,7 @@ unsigned long zswap_total_pages(void)
>  		total += zpool_get_total_pages(pool->zpool);
>  	rcu_read_unlock();
>  
> -	return total;
> +	return total + atomic_long_read(&zswap_stored_uncompressed_pages);
>  }
>  
>  static bool zswap_check_limits(void)
> @@ -805,8 +817,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
>  static void zswap_entry_free(struct zswap_entry *entry)
>  {
>  	zswap_lru_del(&zswap_list_lru, entry);
> -	zpool_free(entry->pool->zpool, entry->handle);
> -	zswap_pool_put(entry->pool);
> +	if (entry->length == PAGE_SIZE) {
> +		kfree(entry->orig_data);
> +		atomic_long_dec(&zswap_stored_uncompressed_pages);
> +	} else {
> +		zpool_free(entry->pool->zpool, entry->handle);
> +		zswap_pool_put(entry->pool);
> +	}
>  	if (entry->objcg) {
>  		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>  		obj_cgroup_put(entry->objcg);
> @@ -937,6 +954,36 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
>  	mutex_unlock(&acomp_ctx->mutex);
>  }
>  
> +/*
> + * If the compression is failed, try saving the content as is without
> + * compression, to keep the LRU order.  This can increase memory overhead from
> + * metadata, but in common zswap use cases where there are sufficient amount of
> + * compressible pages, the overhead should be not ciritical, and can be
> + * mitigated by the writeback.  Also, the decompression overhead is optimized.
> + *
> + * When the writeback is disabled, however, the additional overhead could be
> + * problematic.  For the case, just return the failure.  swap_writeout() will
> + * put the page back to the active LRU list in the case.
> + */
> +static int zswap_handle_compression_failure(int comp_ret, struct page *page,
> +		struct zswap_entry *entry)
> +{
> +	if (!zswap_save_incompressible_pages)
> +		return comp_ret;
> +	if (!mem_cgroup_zswap_writeback_enabled(
> +				folio_memcg(page_folio(page))))
> +		return comp_ret;
> +
> +	entry->orig_data = kmalloc_node(PAGE_SIZE, GFP_NOWAIT | __GFP_NORETRY |
> +			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
> +	if (!entry->orig_data)
> +		return -ENOMEM;
> +	memcpy_from_page(entry->orig_data, page, 0, PAGE_SIZE);
> +	entry->length = PAGE_SIZE;
> +	atomic_long_inc(&zswap_stored_uncompressed_pages);
> +	return 0;
> +}

Better to still use the backend (zsmalloc) for storage. It'll give you
migratability, highmem handling, stats etc.

So if compression fails, still do zpool_malloc(), but for PAGE_SIZE
and copy over the uncompressed page contents.

struct zswap_entry has a hole after bool referenced, so you can add a
flag to mark those uncompressed entries at no extra cost.

Then you can detect this case in zswap_decompress() and handle the
uncompressed copy into @folio accordingly.


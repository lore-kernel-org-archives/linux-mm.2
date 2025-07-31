Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1011C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A5F6B007B; Thu, 31 Jul 2025 13:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1DC6B0089; Thu, 31 Jul 2025 13:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E166B008A; Thu, 31 Jul 2025 13:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 058DF6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:20:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A13DEC0901
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:20:14 +0000 (UTC)
X-FDA: 83725223148.09.7DD47F9
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id E231B40007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:20:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHw50cdd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753982412; a=rsa-sha256;
	cv=none;
	b=HwDKmvpw5jJ92aMm5RxHKmdlm4hfUB62n/bP+Etmnu238ZOcUud5aYwgtWSTJ3EpMvRNQE
	VfzyeeTSZcTamK4EvC3QxhZ0rZu33Bjbe+yDtWd+ZrS0ERb2HsXuLdPBFFIyisWfXCafbg
	m6nV5Mb02fJuTltxQSuuHAAEMdIvMjU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHw50cdd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753982412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6nAbG39Z1jFnWom2CgJ69NEBgVbiO+leBKVM9T+DMw=;
	b=KTC34WSZBWVELvtCRd3maj8ZJc0m09mGu7yPa/cBCCFmwp0pEJqioEZ5yC+/fHkByhLip5
	TS1l/axbllIBh4AJI29lSu7QTuFXX/AVXjquOjGBrU20U8MYSPQt0UdAZ5RjG94I9B0OWw
	fsqphlzTiBKq/1NT9Js+ZkAEJTH1FGI=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-708d90aa8f9so13128987b3.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753982412; x=1754587212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6nAbG39Z1jFnWom2CgJ69NEBgVbiO+leBKVM9T+DMw=;
        b=BHw50cddYAtDr/yer3mvMDd8RqFsqu409yYXhhjItJrjzMCmUvGde9PgkpUTIy0Yfn
         xDk/iZxedB9WvCsoPfLGDgl8NOqhTaH6r+FZHp4zAo9nSQcJMRLuFJv0pQuyolkxsRHi
         johtTamapmz5ormOOn6bx/dTa7kamSJhgTBNPpW9OmFyQzPKwHH3iWK1yAS0JHn6cPGn
         cCZpDfYVTF8eNbAjHxakuQNtCwWMo/pXmP1Uo/xMp6erP9xv6HbphNxCINEkWfAnutIx
         mnjTSg7VzrI0yDljVdkz1S31gioBwY5Ob222Ib30n6c5jNXVObLIRghmrHWPXD5p7R7r
         sGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753982412; x=1754587212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6nAbG39Z1jFnWom2CgJ69NEBgVbiO+leBKVM9T+DMw=;
        b=d16wH6bo2CIQtPdFKZXcZ1UkPNavvx0iGJz6V0hBGVINpi0nrrONFlA7nd6MjstGpo
         D2ydMjlUJia2h6WXdjtXvCzO5Fu6DlDVTzrTgT/qIbNX6UoPC7f1yszcrOC0fSj2QcJc
         FoutQrKKRnc3s1Aix0Bc/t/GVicwIE4zqeSTWaWtW4W5jt5/E2s913m26UXHOCNGOnGK
         +NH+azbgmyAkHzniZV1Skx+DN3C2PaxnlueHd+rbENtiFGd8XF7AB259andYzwElx3pR
         s5ku+JeCguQEWZ+ajYEfhsnNIaXuD/nCA2U2fdFwgd32CTUUZ+XV6AyxnTEWiktfhm93
         1UTA==
X-Forwarded-Encrypted: i=1; AJvYcCVzrPPTJQJX5TvUBrXZRebHx5yFXbnGw79Dj43xOPUhayYfgcVCLNWUW4KWvYvx+NAr2DE9lNjHvA==@kvack.org
X-Gm-Message-State: AOJu0YwiugeI1QlOZOVgAFJqvVniL8SmgqwO90coLToBUkVfcE/HVcRi
	7oToTqfHomLRfagHBVafuE2zTHRy7FsxjTMCYZbJFHXShz/fJ5aF14vr
X-Gm-Gg: ASbGncunHh6DTRqUjtnk/nXit8v8kURJmeXtypT/PVo+OuKftzp5A3L/tB5QK7l9wjH
	ll2UjDCe/QKOiaCiwsLtiA79ojwnxA3Wi/97q/T5scvfWsM9RYLAkavvhGRy7zuRktyN3peG+IT
	5Mz/Th7WZ4CoDMpT8Y5IeLl1mGcW1vh3pm1QXbah+kHO7ZWqhUrpHPcsowuMoKdoFDhgXbPtPNC
	maFK3hrQx85OUInwN3No7P5Zq9LYj3y+cVcAr2AECnUXghJzSweEre3UvxPOtUZfEDPweZ/qJIJ
	yfLGmVSh1IMsTd/yF/ynpeHhx1PeNz+7ha2CEjfO26Ue1nPcTdvIyxvpPues8T1I7fGSHBQemrg
	GtjrH7jrKAVwPlO15E55e
X-Google-Smtp-Source: AGHT+IHX8dsmmfnYqaV/26i9WDGI+PlUI9lsnzW1uGXze00lTlb0Qq/X5fisNvODFFIFJ6O/oC4rHA==
X-Received: by 2002:a05:690c:6707:b0:710:e4c4:a92f with SMTP id 00721157ae682-71a46521feemr86511047b3.5.1753982411679;
        Thu, 31 Jul 2025 10:20:11 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a3f9eb4sm4798327b3.25.2025.07.31.10.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 10:20:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Thu, 31 Jul 2025 10:20:05 -0700
Message-ID: <20250731172009.108025-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250730234059.4603-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E231B40007
X-Stat-Signature: o4n6norqtar8iwkxe1y3skju1cgeucee
X-HE-Tag: 1753982412-378941
X-HE-Meta: U2FsdGVkX1/77l8ERrxFKwCU2OxHAIw4s/cXkOWfZaXt3XFJvlvfkgX5Q562DEP/ndQ+Sxl2tMII4W7c7+dDqK3fGwqWQ+t7/8Uh1Il1f18/srwdaREIdQVv57tcLTcoXiUtlI6KQwOnOvE92vxhrLKAN3A8mEfXOvYY74KBqUdl1mgHHlBA0zbDx13/8x2QOAIaRJaJUtbqMh2KmuQr7SgCbZXXsWsdOLC09jnGJvBGbPkMdT7l+UZGYxYNXtaERrPG9DU+RpGz4CiW7zmGEb10QTwggVeoz8Mjk3yquZSNAgYGsXKMwIVPWL1+f4QpyHRUmL3w3X2BVFQugaq1MD5Z78IYA0+DKOTZ3nQReoGZ4fueSMYLjXTN2m11i7U280EOheXof1Hkfp48q0H2bf23qztW3XJfwlQiq7YNG5iGAElO7+UbSO5J/Lk6s6tzURS3gEn+jS2RzWHeOKzoisHYZrDlq2xMDh0DxuljFaaeo+rOlUbj1/71GfhzbZQ33oqhLUpnWo8UfXDaRRCF5ZGC7fch83KEQYq4UtSI2ivhQYb+iiddJPIsJPhgdxp1bwgvB/Bmz6UCECuv7cbJlR2erhNXZwM9I3uZf4n9XsFv6jpFoVdYImbB/4Bq6d31jsezrGzqUONKt/CUpTyPedBfUGhB39+4gH6gFc4AvPFk1odDXsG4/w/ZrTo5z1ISPLGHk8GXtLD5fdfJG7p682naopDo2vYPI8dWa1sFhOqRnSQBshrCAPKQG7OhZTm/3N55yc5f2surqyP7hWe/fbevtBmlZm6XjBUsPfpeOntkM1/87r3kfZDHiQ/GP86Ngfmz2bcOaCPz2LfVzpC68KLIRv3h1oPVgfOHZm6N/HPZXG+1FIJHbO0ecd9PvHwnD9gqoqUw2GTuGh38TrxBGg9HSe+sb0u6vHDSdL/dDx/6CBq0AbF7xXQRLvOqIi4OycixerZRTZbffsqtA0G
 MWW2d21V
 Gx0cQgG1Efg7HAxbl+940Jh2XL/Aacx77MtPDKX94gmSc79n/Hpy12/XdtucBp3OjcdMOgBTCXeWuWKCEvXLuPwx1s6Zx0DGgYxMJdLAtEcdqD3KHigLXexPlZZ8hhK07IToxPXg0DfwoGK4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 16:40:59 -0700 SeongJae Park <sj@kernel.org> wrote:

Hi SJ, thank you for your patch! This is a really cool idea : -)

> When zswap writeback is enabled and it fails compressing a given page,
> zswap lets the page be swapped out to the backing swap device.  This
> behavior breaks the zswap's writeback LRU order, and hence users can
> experience unexpected latency spikes.
> 
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

I think one other benefit that is worth mentioning here is that by moving
the incompressible pages to the zswap LRU, we prevent wasting CPU cycles
on pages that have not changed since their last compression attempt.

This concern is a real concern that we have seen manifest as wasted cycles
in zswap wasted on trying to compress the same pages over and over again,
and failing each time. This is also made worse by the fact that wasted CPU
cycles are bad, but even worse when we are reclaiming and must free up memory!

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

Indeed, and your patch fixes this problem, at least for the writeback
enabled case!

[...snip...]

> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/zswap.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 65 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 7e02c760955f..e021865696c6 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -45,6 +45,9 @@
>  /* The number of compressed pages currently stored in zswap */
>  atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
>  
> +/* The number of uncompressed pages currently stored in zswap */
> +atomic_long_t zswap_stored_uncompressed_pages = ATOMIC_LONG_INIT(0);
> +
>  /*
>   * The statistics below are not protected from concurrent access for
>   * performance reasons so they may not be a 100% accurate.  However,
> @@ -129,6 +132,11 @@ static bool zswap_shrinker_enabled = IS_ENABLED(
>  		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
>  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
>  
> +/* Store incompressible pages as is */
> +static bool zswap_save_incompressible_pages;
> +module_param_named(save_incompressible_pages, zswap_save_incompressible_pages,
> +		bool, 0644);
> +
>  bool zswap_is_enabled(void)
>  {
>  	return zswap_enabled;
> @@ -190,7 +198,8 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writeback
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
> - * pool - the zswap_pool the entry's data is in
> + * orig_data - uncompressed original data of the page, if length is PAGE_SIZE
> + * pool - the zswap_pool the entry's data is in, if length is not PAGE_SIZE
>   * handle - zpool allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
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

					      NIT: s/ciritical/critical/?

> + * mitigated by the writeback.  Also, the decompression overhead is optimized.
> + *
> + * When the writeback is disabled, however, the additional overhead could be
> + * problematic.  For the case, just return the failure.  swap_writeout() will

					           NIT: s/  / /?

[...snip...]

And I think Nhat and Johannes have covered the other concerns.

Thanks again SJ for working on this, I hope you have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)


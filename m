Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 755EF1125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEC66B009F; Wed, 11 Mar 2026 16:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6666B00A0; Wed, 11 Mar 2026 16:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC016B00A1; Wed, 11 Mar 2026 16:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA416B009F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:16:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5898B58A59
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:16:42 +0000 (UTC)
X-FDA: 84534890244.25.448035D
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 012FA4000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:16:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CuI68C+a;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtZj6h5RyCLZcb3faEPHDRcPqrY2sHgdB5FkBVVnG2Y=;
	b=W/8uKEpcQxymsRw6q4C6Je04g4+GE2MWdUfz5GLdEM9vaJrsPGU0ECNrNN5O2ZALUW/0kI
	jLEQV3WxcSk/z/fudpGrvHOkC0u0YD5JxPPVYBkoHFM52sTZQjNqGnjpOK3bn7EQKEp3u1
	ANmDwZXxGS/4a8V+BzTyaWB4Zsw4AvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260200; a=rsa-sha256;
	cv=none;
	b=zWlBS8TRDFdMEorkLw4Sg6rGcDGPukE2Yb4/msTF/uZPQJ1TkVjbpi1km3TcUQPqAaL4pZ
	fL4AawD/dhe8QzIu6Qx07OJSbpVsryhweqP9ub2q1Yx20gelldHUUd6JHgJjlKuAgeoXAl
	Q5llZv8rHM5KPe62q/RE8K+vaKk/Njs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CuI68C+a;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899ee87355dso3820146d6.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773260199; x=1773864999; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DtZj6h5RyCLZcb3faEPHDRcPqrY2sHgdB5FkBVVnG2Y=;
        b=CuI68C+aIOt5gxFmk2savLlbdgZNaxCBstFCuvL3O1U7o+qt/IJ3PAZB9CLetu7pwx
         i4C906gddps8yjhm+MDcSXcrwyBfiGhS8QKueioSqZyQAyf3HB7h45JYYyY2fj3T6XhN
         +OM1NOIStsR0bKBPySBIuoBZbbUbSs59PpYOJDzIazAZ9HSRGunk/nh/JdI54tZ8reDI
         GqGsnpwTBvVmIUwJ7khSw/pZGkbsKYGORHUskft63lmDTrnrFalj4B7CtgFjowjNkxIP
         wR/z76OPH/CJx9Oe1Td5ZrO2aKxPjiy/Dme8VsAi5REXOKgsnihmWbHEFIOb3ZVhuAHq
         Qa8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773260199; x=1773864999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtZj6h5RyCLZcb3faEPHDRcPqrY2sHgdB5FkBVVnG2Y=;
        b=kIyWYu7q4i5NyAiBkJerR3WpsM1GGKb0M5xwVkTDf5+b5SPgPvp97qOF3deqTTWm99
         DBNfqHjeFxKRyjfTJ+kkdSG+cgIdT5yRm54mZcyOG5BCFKDKQh5dO3ttP158pNR2BYdI
         kF2cxnIzFuNW20ZJIrBDe1JboHcR/OVfZLBpODcuKtGVyw4RJrt1lQtThGZhRrWtLHBF
         jcRLzahij4FndKXEq7ndYP3kVDnBiq6XbbJUdBzQUbAlUuZfFxJsM18qn/WkcOewG2i+
         UWjat+EhEnc+YS+8wgdmX27+jcZ3jvcvLGBel7FLaCJMvnh7GreNqyXFE+FUVquBsu/z
         YL4w==
X-Forwarded-Encrypted: i=1; AJvYcCVeSxZAqZAocRsbIbjui82LtNYCim68r7gy0Q6qKuXWY1ETPDUtUuDHxSveclDsi8Yovh5KLE7olg==@kvack.org
X-Gm-Message-State: AOJu0YxOnWFq8iub7VtOoDjA8K99v3y8SnjdVUUJQ07WbrByQBSbqPO+
	/GOjm0cu4xzIlsuMY9MLoJy+AsMWw9e/OczvRpGEUHTxGUJQFO28witgV3uBcVhOxGo=
X-Gm-Gg: ATEYQzwOHnZlHac+NQJXzbF6f+TiAVyevguSRqhaw1IqwVHlngj0rML7anctFjbAjxT
	LKuhgmivKT1cGO7olnn1SanDqUV5iDbyD71HykQsWG9JHHc9Q4l2f6aQJ9ybTK8rzKdr/0uLyQ9
	jwhJaFmE//dHlU8XWP0pBmGJG0GjsQlH1QcEq+uqahblUoz8OHpw74FRVOJD0+njzlFJGhBis2+
	qFkdv0ozyUgM41IfwqinssmvK+jbfuRYxnLCQIvwVtLa7/wkoMKeSJ4CYeQQFlt09Mpvr5tAJll
	jAbKZgHWmaQbaCFpf59lVIFbbZ1CCwMdqeG6ZtS1NULbNEj7vkPYPassQLyWrq21aCOjyAXp32f
	FO3cpFYIB7XSfqXkWsYhQvQuFXEDT8JdPbZx+HbEDzYQOlWw90Od6+AK+uQezmcNjEh5VqkF6E9
	6qpjZEjxjmuAt0deyhoJIbWg==
X-Received: by 2002:a05:6214:3003:b0:89a:110f:894a with SMTP id 6a1803df08f44-89a669c4812mr51524686d6.12.1773260198806;
        Wed, 11 Mar 2026 13:16:38 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cd5fa8sm19798006d6.30.2026.03.11.13.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 13:16:37 -0700 (PDT)
Date: Wed, 11 Mar 2026 16:16:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 03/11] mm/zsmalloc: Introduce conditional memcg awareness
 to zs_pool
Message-ID: <abHNog8CV0mWummY@cmpxchg.org>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
 <20260311195153.4013476-4-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311195153.4013476-4-joshua.hahnjy@gmail.com>
X-Stat-Signature: cc91z171y7z5sxxi4ao1ccm8nbaop58b
X-Rspam-User: 
X-Rspamd-Queue-Id: 012FA4000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773260199-419628
X-HE-Meta: U2FsdGVkX19JfOplps6sQiXWJaB1ieB2duYks91OgH3f37/LLGziOhgKgEvOwzmMWNb0dLmTBifOI2gMfrR5Agp7kjsbw8i1aUg8kTPsEoXdgCuH3HCMWIErIzsZNDxeO+lAWveJePlJPAhA8sXXls3NCIP9j98UhHJ4SkGYZ7RnPdp252kewlBXjClfpWtqam8Bt4IMVHXIraFCeYNdpgCT7BtxBV6QsPZ8IsBJx717C0OdEtUBmJdgqitcMuCqawmEUtxJ2kT6AzQt5R4xeDtJRuZ9yEOP/897BCJAhZGiOHAVCEnZLih4Vnak+0emGR64bpwgBzI6pxeqClhOzaSAcdF4QYdFWv+oLO1dgeVH8CHMRo7Gyl+Qqglk/SRXM2EhvX7xXUQ8OwpgV40jAc/3DuRmqgAVaD7rvloonn1OIQHkDxJvj6yxOb1Z7ucCyd+xBocPRNLuT1vvX0hdP1l2WRLQ2S0ZUSpyij3s5i4Xgz+Y1BFmG6B5Ypthv8mRHhpDITH1L9Jqyw2dqxnccv2YZvE3ulXEfvrZPp7AyXOs35Ks7MxiCruMVKohUdHJ7u+xq/mHhGLG9dPSK/Z953PfWup/HdlxI1qnECJj3IWzNCxnXv6oIas7j2ROQQQhir7I6kIhAtfpyfZSm+CN0hWhjr99Y8eL14lWTs+SyQ4CXND2JsxwESwFWdaPclIj5Gdo5VTEmUVFh0K6NptEQUJMNXjxABHgNRgnN2nhX7fnDqIgcn7Y9PvKsjnA2wGgZI2KGZXlvlwUoPCEZ3YII2RzOHBWUNHBvdS2sdezMa69teDBwmw7mfcIuo24j6AZKbZtAW9lue9/2FsTvIPvzv5tFTHrS0D3w/eHrTlmWI9dKsRtSVlejBr0aef2BzxjS0oJAsfFkJ6ZaX5X3tmunUyjdYQW+YBI235vRg7i7lTcKQfSqKtY8+WLQxN0f93Z3tGEnLuhB7E7LLy4YZg
 pVywWAhN
 DANIDiO2Pm1JOW3pHMQ4o0dI0pboFDpGQypwsGR7z23jmS2Fwn+x1pd0dbgh5Yf2rehfJ2OikAtnQpgRAZgZ6VWnhmCPQ8gdkdgC/JxYeigYm9hO83XYWWt+8anMo1oehllVk1cYRknl02nDlwqQoJp/46Iyp34jydrToghMOPgwPTbO50HJlUX7P3HeVb1MUEjj4ma+qxoPM37NA9bXxv2q+3PG1fI8C4kMVCLrDUl+n+LawC+IAHBcSKMdeiGooSDjVVxOrKe5bwhSzeWOV/8mZmMOatiQmi8boudXKTuU4SjSLxD27XOwXFr9X+oi5/5x094FyijgTUqQUvAhyHzcJTIlOf+/ulMQqYgOvqxgx2tqOxKXETFTkkWb9ejYvEbCFj/HVu/EikElwwrx7MBQdYE4NodceAkCCQ7JKnJfrH/wERcKM0pYVVn/TQ+WRDsY64Hr+HfL7EQWcZL+4l8/29whWpU+RkOLEsaMe3ul2LKAgJkFb2tLiCfHD87NRI9byz+sPv13bXB8f8CVBtwZOsOTO5gCtROZiQhhRxoKQAPwFMZQMuna1LCmHEMcLxnEo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:51:40PM -0700, Joshua Hahn wrote:
> Introduce 3 new fields to struct zs_pool to allow individual zpools to
> be "memcg-aware": memcg_aware, compressed_stat, and uncompressed_stat.
> 
> memcg_aware is used in later patches to determine whether memory
> should be allocated to keep track of per-compresed object objgs.
> compressed_stat and uncompressed_stat are enum indices that point into
> memcg (node) stats that zsmalloc will account towards.
> 
> In reality, these fields help distinguish between the two users of
> zsmalloc, zswap and zram. The enum indices compressed_stat and
> uncompressed_stat are parametrized to minimize zswap-specific hardcoding
> in zsmalloc.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  drivers/block/zram/zram_drv.c |  3 ++-
>  include/linux/zsmalloc.h      |  5 ++++-
>  mm/zsmalloc.c                 | 13 ++++++++++++-
>  mm/zswap.c                    |  3 ++-
>  4 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index bca33403fc8b..d1eae5c20df7 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1980,7 +1980,8 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
>  	if (!zram->table)
>  		return false;
>  
> -	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
> +	/* zram does not support memcg accounting */
> +	zram->mem_pool = zs_create_pool(zram->disk->disk_name, false, 0, 0);

It's a bit awkward that 0 is valid (MEMCG_SWAP). Plus you store these
values in every pool, even though they're always the same for all
zswap pools.

How about:

/* zsmalloc.h */
struct zs_memcg_params {
	enum memcg_stat_item compressed;
	enum memcg_stat_item uncompressed;
};
struct zs_pool *zs_create_pool(const char *name, struct zs_memcg_params *memcg_params);

/* zswap.c */
static struct zs_memcg_params zswap_memcg_params = {
	.compressed = MEMCG_ZSWAP_B,
	.uncompressed = MEMCG_ZSWAPPED,
};

then pass &zswap_memcg_params from zswap and NULL from zram.

> @@ -2071,6 +2079,9 @@ struct zs_pool *zs_create_pool(const char *name)
>  	rwlock_init(&pool->lock);
>  	atomic_set(&pool->compaction_in_progress, 0);
>  
> +	pool->memcg_aware = memcg_aware;
> +	pool->compressed_stat = compressed_stat;
> +	pool->uncompressed_stat = uncompressed_stat;

	pool->memcg_params = memcg_params;

And then use if (pool->memcg_params) to gate in zsmalloc.c.


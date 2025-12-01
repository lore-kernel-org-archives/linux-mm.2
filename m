Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC25ED116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94326B0062; Mon,  1 Dec 2025 04:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DA96B009E; Mon,  1 Dec 2025 04:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9196B0062; Mon,  1 Dec 2025 04:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B31C6B0062
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22E0F14073B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:25 +0000 (UTC)
X-FDA: 84170426970.15.CCCE8C3
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7AB520005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GDZJiaGI;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGGQx+qOtLfeHotYgQob13a3keDky1EvwEknMJtybJQ=;
	b=iVuq4wU1VS85xm0+aoqdofh0M2z0y/4g7dc2cE6u4RbHNm5TbJ9FtXfv+fIBEtbOnRXb7o
	ZLO5nQ/IpCqeJEdBmJG/StCaHuRJDmFgurIdqZvbKUfHQxkaEeMqGoNuM+7J/szDCZnb14
	9wRES8aAMT25aSoWltzZzb5seWmqf5w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GDZJiaGI;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582503; a=rsa-sha256;
	cv=none;
	b=jKQ1q8nwBDAgYWN0LmbVwzuuKxQoHGiupZYZnjazqUmj7ryw/8VbSDFNck+q0QSEqjIQE5
	JR3ja11LrdCN0hfklj3bFGAED8HDCH5F+bzOYDlxsYscj4vmGxVqdMzntzOVRD01fvWlZE
	VSxNJr0Nf7C/BRijf9d8vtOP1e2OSTo=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3418ad69672so2494524a91.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582502; x=1765187302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGGQx+qOtLfeHotYgQob13a3keDky1EvwEknMJtybJQ=;
        b=GDZJiaGI7rd5/v3dhTZApC/PHEZ00067FaILnWSsAXPPOcirg6+QsV30uBmnVudl/F
         yCQDT5z3qiYIxriwIpFwNgb1tFgWoPbmPQyxreCFdF1z+3oUmC8/947f9z/BWnI8WOth
         wHJ6iA92KrWmy+arlpGs6EvFYqKeOJ7DnNGIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582502; x=1765187302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zGGQx+qOtLfeHotYgQob13a3keDky1EvwEknMJtybJQ=;
        b=O4ev5C4YcY/9fBhDJ9eYbbXkQ7uKAQQwAL42/dkigfbx8mFw6E7WzYM1KHUHOTIu9Y
         CGY2lmgvxGulPCaus9ZpBhWTiwWnOvtHX593pNDfTFxgArxxW9MacdJnTSi2M42DcdGD
         sAZ8TgvmVeuqG8ZWjmEdWm5zw2ojsAljoEBToG7Kls41+oMud24txvJr2ttaJDO1BCZ1
         FBo2QbTJkGHdqcjgCA2a8W/veGge/bTd9xaebyCtp3oL5P5L3jKQK89ygUs0lxTMone0
         vLcy/HOYIGzZRnKTPrzRhly44TIJ2xX/8ggmWS2veGc6vbJGSS0MATyJDi2qj4ShWKnK
         +T8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUL40g9p3K/WHx3AXFogIRA140yyTQEequ40d+JP2J6i0E0rWXzlFvBwNDs1BV3oEMEuQdjTsjNIQ==@kvack.org
X-Gm-Message-State: AOJu0YwBXSzkFC2Q4moL4XNV/j62b3CrfApjjS1laGR64MSJCpLEL26k
	p9YCQOEOYGO94E18gid6TQxrrpF9XmJDZQza13mhAFRwB4BGMaa6WP4mmvtXA+HhMg==
X-Gm-Gg: ASbGncsBC3cBWj782X6MASxxrWnKxHUYWvI8HblJbEVF2V1pOAaIq3rx8y3IczxeuQI
	e+d/eBmL1EWlCc1NkBSfvjXB3OCENYjCGmXmbBjlfdAQTG9A0rJrk7nnQTutlNlpJy4jnrUsEcw
	YSgI6nkhFgWk67QYfmWkn38TLAbP0AgwUGOLDzeUe+vUyCKdOMY6SRAaE0YPcsVlhnmzPj4k/O/
	b9uYSOBknPJZwNu7tdQ16EcfU3qgFhMabZOH3Lzlh7H4A9x1fyc13ZsLrxTWh/69aEXRp/wlmDs
	PSDes8MeKjJ+0lOd+feBzPsPU1f4I4SGfcV7QccKjeUxfdoBdZVTxLakFqSvj4FSn6raGBvZltJ
	JrKcAztbUHZNqPh1P0Iu7jggO8oiWceo8aRNe2j2qV3ePR06SXXjeA0LkPbSGWttx0QY94fBNUa
	a/lRV72n5FrBNvuEZn5qbDwoidB+HWq997kHDYtHPc5GtMR+NpMK0nk2PyKFxl9S+9KMcD7/tuU
	Q==
X-Google-Smtp-Source: AGHT+IEzr1LmXf2akybR4rLvRjsBVPFFnsEwkrcH3PNwkg+h/J6THTd6DV4nubMDanWdKz8r84hW/Q==
X-Received: by 2002:a17:90b:17d2:b0:32e:1b1c:f8b8 with SMTP id 98e67ed59e1d1-34733f49b25mr41314766a91.26.1764582501612;
        Mon, 01 Dec 2025 01:48:21 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:21 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 6/7] zram: switch to guard() for init_lock
Date: Mon,  1 Dec 2025 18:47:53 +0900
Message-ID: <20251201094754.4149975-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7AB520005
X-Rspamd-Server: rspam02
X-Stat-Signature: i33ydpqxy8pktuuubeqsuzzu1mz93c45
X-Rspam-User: 
X-HE-Tag: 1764582502-791545
X-HE-Meta: U2FsdGVkX18JQh/PUprWYG1lecFWu/qi+zqcr0gdACyH98iNA8wJGfSnr+D/U8TjRAPHTbcKRWac11lXUwIp0OnH3eAhJaRsa8zUs38pUPkxLe/ol9a+3ooe1Vx4AZvGnycEMC65aufo/yC8+juvhsBt26m9Jf08sOMFu27w/Rq6KT1vfNEMTrwhyzRej3JCBLGaAHQsWDWIi9wSF1s7xOev9qmyi73jFCoyEUG79qSoW4Wlq1hOJI3UOmE+PGCcNTZGq8i07sbaXgUW8maxi76d5dBhCHxGKx+iHERIfqi6ficgFnsU5EvPORbRV68q9wxHlehQf9rkSsJ3xgbA3ZtNXyrXxB7cRopzK6Wk/Ln+lO2HfU2850YFxWj448OzDvUadEL0ViwOFRjxrZStviVLgnjggs0rUDMi+dAlcZG8Ic24W9QZCRVx1/MMvuMx7JI6fDIiejXl0LYQnwXynhwye3bc2YKHAnlzy6qV9Aa5LwjmeMByjOSsZUoyax4TORpJe+olWvTzKZkmirUhcO9fMlKAkFX2WNWTAIEx5QP2lUysaWZvKhEK/DVI20JZNgMCdCDTAIEjDZJjsNBfNicL6U5UbrKkkDr7qEWSi4rhpi8B6HquxvWqDz/RnG8tBqytP5bAAV+xFnFrh68CimDG5vfzK/FEQPQQngtXi8ShOn3TyFBIDE1HMjs3RS4IkRzj8Zhszk2jbVVZxahMCKhfEmIN2kKwggE8X5j5Cd8qSRDQ5WPD3Dl5KS1UC8tpaLdObhjSLS27mC5kMWsPh2GC1dDKREejuuS5m27zjx8LO81XDLRpZDpEISF27Be2AKIq3J3yObEdIrQ76VyXihuiZ+II4ghrg3on9ALhU/GhQNHa/F0A3y1TYFdQXznXtzW8fv/yQIJAijxmtDdGHzib4TAnG3HU1k9hxN4/N1smfz4VyBhnxWpVe74bzVgkQRxkUBADdso455ERlEa
 v6R2P8h5
 Kts9K19TQqpCnlY2uwpg8Uzq9hw8MEIPPza0jXyyAFX9JkJGpNYuFdj8qndPnQPac2NT9iMhoC61un1r+9GVE65IvrGhMvzgT9QLpPq7Pgbj41ROeOzEuIM1rkuCYM96sdYbu/Af8M9OLo98mf+NsIyfmYyLwwhCALU5/N2kwYx7zH73OHXQVKUcrEXBeOAN9xmxzYds7yur1BPbbXURUygjZJSa/dmskzBI5EGTPUjFcXK4VmFiAF/quGxAv6a6P+8HybBo5BErGwRBPrOFFgXtfQjUVxVfXvdDl2tNyw/bRyV4IYuO+5KlITJ2mEYX8UgaQkjtuu5H4BppSRe2XHd3nfz8CViyOFGit
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use init_lock guard() in sysfs store/show handlers, in order
to simplify and, more importantly, to modernize the code.

While at it, fix up more coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 211 +++++++++++++---------------------
 1 file changed, 77 insertions(+), 134 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 615756d5d05d..4b8a26c60539 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -360,15 +360,14 @@ static bool page_same_filled(void *ptr, unsigned long *element)
 	return true;
 }
 
-static ssize_t initstate_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t initstate_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	val = init_done(zram);
-	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%u\n", val);
 }
@@ -382,7 +381,8 @@ static ssize_t disksize_show(struct device *dev,
 }
 
 static ssize_t mem_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+			       struct device_attribute *attr, const char *buf,
+			       size_t len)
 {
 	u64 limit;
 	char *tmp;
@@ -392,15 +392,15 @@ static ssize_t mem_limit_store(struct device *dev,
 	if (buf == tmp) /* no chars parsed, invalid input */
 		return -EINVAL;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
-	up_write(&zram->init_lock);
 
 	return len;
 }
 
 static ssize_t mem_used_max_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
 {
 	int err;
 	unsigned long val;
@@ -410,12 +410,11 @@ static ssize_t mem_used_max_store(struct device *dev,
 	if (err || val != 0)
 		return -EINVAL;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	if (init_done(zram)) {
 		atomic_long_set(&zram->stats.max_used_pages,
 				zs_get_total_pages(zram->mem_pool));
 	}
-	up_read(&zram->init_lock);
 
 	return len;
 }
@@ -458,12 +457,11 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 	}
 }
 
-static ssize_t idle_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t idle_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	ktime_t cutoff_time = 0;
-	ssize_t rv = -EINVAL;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
@@ -476,24 +474,19 @@ static ssize_t idle_store(struct device *dev,
 			cutoff_time = ktime_sub(ktime_get_boottime(),
 					ns_to_ktime(age_sec * NSEC_PER_SEC));
 		else
-			goto out;
+			return -EINVAL;
 	}
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	if (!init_done(zram))
-		goto out_unlock;
+		return -EINVAL;
 
 	/*
 	 * A cutoff_time of 0 marks everything as idle, this is the
 	 * "all" behavior.
 	 */
 	mark_idle(zram, cutoff_time);
-	rv = len;
-
-out_unlock:
-	up_read(&zram->init_lock);
-out:
-	return rv;
+	return len;
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
@@ -546,13 +539,12 @@ static ssize_t bd_stat_show(struct device *dev, struct device_attribute *attr,
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	ret = sysfs_emit(buf,
 			 "%8llu %8llu %8llu\n",
 			 FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
 			 FOUR_K((u64)atomic64_read(&zram->stats.bd_reads)),
 			 FOUR_K((u64)atomic64_read(&zram->stats.bd_writes)));
-	up_read(&zram->init_lock);
 
 	return ret;
 }
@@ -567,14 +559,12 @@ static ssize_t writeback_compressed_store(struct device *dev,
 	if (kstrtobool(buf, &val))
 		return -EINVAL;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		return -EBUSY;
 	}
 
 	zram->wb_compressed = val;
-	up_write(&zram->init_lock);
 
 	return len;
 }
@@ -586,9 +576,8 @@ static ssize_t writeback_compressed_show(struct device *dev,
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	val = zram->wb_compressed;
-	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
 }
@@ -599,17 +588,14 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
-	ssize_t ret = -EINVAL;
 
 	if (kstrtoull(buf, 10, &val))
-		return ret;
+		return -EINVAL;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	zram->wb_limit_enable = val;
-	up_write(&zram->init_lock);
-	ret = len;
 
-	return ret;
+	return len;
 }
 
 static ssize_t writeback_limit_enable_show(struct device *dev,
@@ -619,9 +605,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	val = zram->wb_limit_enable;
-	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
 }
@@ -632,10 +617,9 @@ static ssize_t writeback_limit_store(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
-	ssize_t ret = -EINVAL;
 
 	if (kstrtoull(buf, 10, &val))
-		return ret;
+		return -EINVAL;
 
 	/*
 	 * When the page size is greater than 4KB, if bd_wb_limit is set to
@@ -647,12 +631,10 @@ static ssize_t writeback_limit_store(struct device *dev,
 	 */
 	val = rounddown(val, PAGE_SIZE / 4096);
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	zram->bd_wb_limit = val;
-	up_write(&zram->init_lock);
-	ret = len;
 
-	return ret;
+	return len;
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
@@ -661,9 +643,8 @@ static ssize_t writeback_limit_show(struct device *dev,
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	val = zram->bd_wb_limit;
-	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
 }
@@ -681,9 +662,8 @@ static ssize_t writeback_batch_size_store(struct device *dev,
 	if (!val)
 		return -EINVAL;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	zram->wb_batch_size = val;
-	up_write(&zram->init_lock);
 
 	return len;
 }
@@ -695,9 +675,8 @@ static ssize_t writeback_batch_size_show(struct device *dev,
 	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	val = zram->wb_batch_size;
-	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%u\n", val);
 }
@@ -717,37 +696,33 @@ static void reset_bdev(struct zram *zram)
 }
 
 static ssize_t backing_dev_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				struct device_attribute *attr, char *buf)
 {
 	struct file *file;
 	struct zram *zram = dev_to_zram(dev);
 	char *p;
 	ssize_t ret;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	file = zram->backing_dev;
 	if (!file) {
 		memcpy(buf, "none\n", 5);
-		up_read(&zram->init_lock);
 		return 5;
 	}
 
 	p = file_path(file, buf, PAGE_SIZE - 1);
-	if (IS_ERR(p)) {
-		ret = PTR_ERR(p);
-		goto out;
-	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
 	ret = strlen(p);
 	memmove(buf, p, ret);
 	buf[ret++] = '\n';
-out:
-	up_read(&zram->init_lock);
 	return ret;
 }
 
 static ssize_t backing_dev_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				 struct device_attribute *attr, const char *buf,
+				 size_t len)
 {
 	char *file_name;
 	size_t sz;
@@ -762,7 +737,7 @@ static ssize_t backing_dev_store(struct device *dev,
 	if (!file_name)
 		return -ENOMEM;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (init_done(zram)) {
 		pr_info("Can't setup backing device for initialized device\n");
 		err = -EBUSY;
@@ -810,7 +785,6 @@ static ssize_t backing_dev_store(struct device *dev,
 	zram->backing_dev = backing_dev;
 	zram->bitmap = bitmap;
 	zram->nr_pages = nr_pages;
-	up_write(&zram->init_lock);
 
 	pr_info("setup backing device %s\n", file_name);
 	kfree(file_name);
@@ -822,8 +796,6 @@ static ssize_t backing_dev_store(struct device *dev,
 	if (backing_dev)
 		filp_close(backing_dev, NULL);
 
-	up_write(&zram->init_lock);
-
 	kfree(file_name);
 
 	return err;
@@ -1291,33 +1263,29 @@ static ssize_t writeback_store(struct device *dev,
 	ssize_t ret = len;
 	int err, mode = 0;
 
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
+	if (!init_done(zram))
 		return -EINVAL;
-	}
 
 	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1)) {
-		up_read(&zram->init_lock);
+	if (atomic_xchg(&zram->pp_in_progress, 1))
 		return -EAGAIN;
-	}
 
 	if (!zram->backing_dev) {
 		ret = -ENODEV;
-		goto release_init_lock;
+		goto out;
 	}
 
 	pp_ctl = init_pp_ctl();
 	if (!pp_ctl) {
 		ret = -ENOMEM;
-		goto release_init_lock;
+		goto out;
 	}
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
-		goto release_init_lock;
+		goto out;
 	}
 
 	args = skip_spaces(buf);
@@ -1341,7 +1309,7 @@ static ssize_t writeback_store(struct device *dev,
 			err = parse_mode(param, &mode);
 			if (err) {
 				ret = err;
-				goto release_init_lock;
+				goto out;
 			}
 
 			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
@@ -1352,7 +1320,7 @@ static ssize_t writeback_store(struct device *dev,
 			err = parse_mode(val, &mode);
 			if (err) {
 				ret = err;
-				goto release_init_lock;
+				goto out;
 			}
 
 			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
@@ -1363,7 +1331,7 @@ static ssize_t writeback_store(struct device *dev,
 			err = parse_page_index(val, nr_pages, &lo, &hi);
 			if (err) {
 				ret = err;
-				goto release_init_lock;
+				goto out;
 			}
 
 			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
@@ -1374,7 +1342,7 @@ static ssize_t writeback_store(struct device *dev,
 			err = parse_page_indexes(val, nr_pages, &lo, &hi);
 			if (err) {
 				ret = err;
-				goto release_init_lock;
+				goto out;
 			}
 
 			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
@@ -1386,11 +1354,10 @@ static ssize_t writeback_store(struct device *dev,
 	if (err)
 		ret = err;
 
-release_init_lock:
+out:
 	release_pp_ctl(zram, pp_ctl);
 	release_wb_ctl(wb_ctl);
 	atomic_set(&zram->pp_in_progress, 0);
-	up_read(&zram->init_lock);
 
 	return ret;
 }
@@ -1608,9 +1575,8 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	if (!kbuf)
 		return -ENOMEM;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
 		kvfree(kbuf);
 		return -EINVAL;
 	}
@@ -1646,7 +1612,6 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		*ppos += 1;
 	}
 
-	up_read(&zram->init_lock);
 	if (copy_to_user(buf, kbuf, written))
 		written = -EFAULT;
 	kvfree(kbuf);
@@ -1713,16 +1678,14 @@ static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
 		return -EINVAL;
 	}
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		kfree(compressor);
 		pr_info("Can't change algorithm for initialized device\n");
 		return -EBUSY;
 	}
 
 	comp_algorithm_set(zram, prio, compressor);
-	up_write(&zram->init_lock);
 	return 0;
 }
 
@@ -1843,9 +1806,8 @@ static ssize_t comp_algorithm_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t sz;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_COMP], buf, 0);
-	up_read(&zram->init_lock);
 	return sz;
 }
 
@@ -1870,7 +1832,7 @@ static ssize_t recomp_algorithm_show(struct device *dev,
 	ssize_t sz = 0;
 	u32 prio;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
@@ -1878,7 +1840,6 @@ static ssize_t recomp_algorithm_show(struct device *dev,
 		sz += sysfs_emit_at(buf, sz, "#%d: ", prio);
 		sz += zcomp_available_show(zram->comp_algs[prio], buf, sz);
 	}
-	up_read(&zram->init_lock);
 	return sz;
 }
 
@@ -1924,42 +1885,38 @@ static ssize_t recomp_algorithm_store(struct device *dev,
 }
 #endif
 
-static ssize_t compact_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t compact_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
+	if (!init_done(zram))
 		return -EINVAL;
-	}
 
 	zs_compact(zram->mem_pool);
-	up_read(&zram->init_lock);
 
 	return len;
 }
 
-static ssize_t io_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t io_stat_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	ret = sysfs_emit(buf,
 			"%8llu %8llu 0 %8llu\n",
 			(u64)atomic64_read(&zram->stats.failed_reads),
 			(u64)atomic64_read(&zram->stats.failed_writes),
 			(u64)atomic64_read(&zram->stats.notify_free));
-	up_read(&zram->init_lock);
 
 	return ret;
 }
 
-static ssize_t mm_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t mm_stat_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
 	struct zs_pool_stats pool_stats;
@@ -1969,7 +1926,7 @@ static ssize_t mm_stat_show(struct device *dev,
 
 	memset(&pool_stats, 0x00, sizeof(struct zs_pool_stats));
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	if (init_done(zram)) {
 		mem_used = zs_get_total_pages(zram->mem_pool);
 		zs_pool_stats(zram->mem_pool, &pool_stats);
@@ -1989,7 +1946,6 @@ static ssize_t mm_stat_show(struct device *dev,
 			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages),
 			(u64)atomic64_read(&zram->stats.huge_pages_since));
-	up_read(&zram->init_lock);
 
 	return ret;
 }
@@ -2001,12 +1957,11 @@ static ssize_t debug_stat_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	down_read(&zram->init_lock);
+	guard(rwsem_read)(&zram->init_lock);
 	ret = sysfs_emit(buf,
 			"version: %d\n0 %8llu\n",
 			version,
 			(u64)atomic64_read(&zram->stats.miss_free));
-	up_read(&zram->init_lock);
 
 	return ret;
 }
@@ -2669,17 +2624,13 @@ static ssize_t recompress_store(struct device *dev,
 	if (threshold >= huge_class_size)
 		return -EINVAL;
 
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		ret = -EINVAL;
-		goto release_init_lock;
-	}
+	guard(rwsem_read)(&zram->init_lock);
+	if (!init_done(zram))
+		return -EINVAL;
 
 	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1)) {
-		up_read(&zram->init_lock);
+	if (atomic_xchg(&zram->pp_in_progress, 1))
 		return -EAGAIN;
-	}
 
 	if (algo) {
 		bool found = false;
@@ -2697,26 +2648,26 @@ static ssize_t recompress_store(struct device *dev,
 
 		if (!found) {
 			ret = -EINVAL;
-			goto release_init_lock;
+			goto out;
 		}
 	}
 
 	prio_max = min(prio_max, (u32)zram->num_active_comps);
 	if (prio >= prio_max) {
 		ret = -EINVAL;
-		goto release_init_lock;
+		goto out;
 	}
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
-		goto release_init_lock;
+		goto out;
 	}
 
 	ctl = init_pp_ctl();
 	if (!ctl) {
 		ret = -ENOMEM;
-		goto release_init_lock;
+		goto out;
 	}
 
 	scan_slots_for_recompress(zram, mode, prio_max, ctl);
@@ -2747,12 +2698,11 @@ static ssize_t recompress_store(struct device *dev,
 		cond_resched();
 	}
 
-release_init_lock:
+out:
 	if (page)
 		__free_page(page);
 	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
-	up_read(&zram->init_lock);
 	return ret;
 }
 #endif
@@ -2931,7 +2881,7 @@ static void zram_destroy_comps(struct zram *zram)
 
 static void zram_reset_device(struct zram *zram)
 {
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 
 	zram->limit_pages = 0;
 
@@ -2947,11 +2897,10 @@ static void zram_reset_device(struct zram *zram)
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-	up_write(&zram->init_lock);
 }
 
-static ssize_t disksize_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t len)
 {
 	u64 disksize;
 	struct zcomp *comp;
@@ -2963,18 +2912,15 @@ static ssize_t disksize_store(struct device *dev,
 	if (!disksize)
 		return -EINVAL;
 
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (init_done(zram)) {
 		pr_info("Cannot change disksize for initialized device\n");
-		err = -EBUSY;
-		goto out_unlock;
+		return -EBUSY;
 	}
 
 	disksize = PAGE_ALIGN(disksize);
-	if (!zram_meta_alloc(zram, disksize)) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!zram_meta_alloc(zram, disksize))
+		return -ENOMEM;
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
@@ -2994,15 +2940,12 @@ static ssize_t disksize_store(struct device *dev,
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	up_write(&zram->init_lock);
 
 	return len;
 
 out_free_comps:
 	zram_destroy_comps(zram);
 	zram_meta_free(zram, disksize);
-out_unlock:
-	up_write(&zram->init_lock);
 	return err;
 }
 
-- 
2.52.0.487.g5c8c507ade-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C13D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A106B0098; Mon,  1 Dec 2025 04:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92DC6B0099; Mon,  1 Dec 2025 04:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81AA6B009D; Mon,  1 Dec 2025 04:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 947806B0098
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1AD21A0A9D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:19 +0000 (UTC)
X-FDA: 84170426718.11.88959B1
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7DE4160005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gDz6KHCZ;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFPCMT/DEG4vuNOqo+8qbFXraYHdGAlN+ITtNxeLbtw=;
	b=fGgqqn0L+6tm+GDsPcc4QaVDwL3bLuQShV6i0CIcf8wDUHItfYbSbT3hoDVjqUmMNZ//hH
	5gpzFjNM/Jg1uLQKIhAl1nTlXCRD0DjM8N12wttXzPm4WXKFxxRUc4jI9N9uqWH00AnKbW
	1KWPsiyzutkOP6mt/zStpPWdOvMZbfo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gDz6KHCZ;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582497; a=rsa-sha256;
	cv=none;
	b=8Qd/pdI1yqs2hSK8GpmH2BQmH2+puHgdToCP3BZ5XpU3V7AhlebD3koC9rDgzgBPdd/fxP
	3UTmsfVys5l5XiV3q+4wyCsPJNO0R3WC8HOY6uhtmlQL1DgsRgsv6/4w4EkeGeWTQLeGec
	p//6a61EzYraoYFDbMHMp7wXxy+WidA=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9387df58cso6471624b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582496; x=1765187296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFPCMT/DEG4vuNOqo+8qbFXraYHdGAlN+ITtNxeLbtw=;
        b=gDz6KHCZeY0+2r0L/rdB0Nx7wOG5VIXCqg9pcMtUeFLUQjggvGx4Bx+6RzZa8FgxVZ
         GYLdPQ/EkRSQHjTIOb/hcGXRelUQt7gr2FeYf4ce/Xmp6JflykYdKJ0Yn9sOkBcEmxGv
         PLoRAuM6nxCb4AQflh2OPw8JTPSa5sHXzw/K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582496; x=1765187296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MFPCMT/DEG4vuNOqo+8qbFXraYHdGAlN+ITtNxeLbtw=;
        b=xNnX2ygUvI05ZI3XaYbc+GgLj8TjkxRGop1Qb1fNb4vBwgDpR1s1phmF3V/G5W29l+
         sjTvwK+OYaaNXB4cUVI5Sg4rJMgyd4JNaLwYZCA8mYvOh/qLxd8WGZFyIXWhbFoMzZRe
         2esvCMblfh+GPVyvVaj5j7jgZ22NyviCWa3OKBer44iMZ2NTLCR5j+IH0aqI7C7apkf/
         FcQmZA6solneieyVlqmNFt4VRjMMzprDzkop+tXBHhH7gKbqxhdkbHSuK4fhWw5K9Z6e
         /21sK7WzH/NSWpFIOprjePDDXBVt0xgBNkYPf5qTX/akje/0N1Fj0Qet5EiSe7BpMpQU
         dZQw==
X-Forwarded-Encrypted: i=1; AJvYcCV+Jk+3of4d4l8oV7ALHfBcbRoJcDVRkraXT9j5N+IPLnloyemM72zvC14bdCj99NkSuebqn9H12A==@kvack.org
X-Gm-Message-State: AOJu0Yz42yRfcyJbzbao4e8HX2PY4gMgLzDtLO3RzQ4b14YDd8/EOtAV
	ukTZzWBb8Idc+t9dIDiCfXN9Kb9r83OP8SZo2vWsAF2iBKds/07NKx58vi8NBKSBxBz1udQoX4S
	JdwM=
X-Gm-Gg: ASbGnctj9+mKc/qZ1YliJDjoYQha3wiH7GYfj6i9rozPH6EQB7/Hewb0tB9X0b4GJ1i
	a+kQ7NhXSE5jvjMOxe47YTjHckvGn5+hqIoeRZ/8lHdkWQkm9kB4zGEzCvT6CiHzJAyCOGYds7b
	xkPUN03AKsaIlmvyfWVG/85z6jpY9vuM2ZiJ9TpZFtORn37421oRAvkc4ZyJGPwUfUw4uoHkje7
	4oJnn2vph/CxwIypIjcUknUsA1xIOcE/wktozyze6jUe0BTjwGTo4MxjfH3Xd03DWKl45RuDMpx
	cC2KjuH8L5zCAz/yDPV+c46zTo75g1SiAh3nQi7p4UhS/hKnWTalIi6SrpdT0gbwpm99y8iWnl0
	qpACmmcijzjhAuQGtcUr5ZGVbCVPUE7a1d7nyt53S04JE7rn3vZxRTDLlzptXp/uxbgmj3RcmR+
	7N/r6ThHxnNio/d1k1EtNst7jRdNOyKuYgzEEyNJ4nJkfVMTkX5HWkrbFIJhzG5gTU/TKvqHZwF
	g==
X-Google-Smtp-Source: AGHT+IFlrnHAUO0MwvM1aa8kkuCDrVgQUWK4lsCQPDK031ojL9Sillo7MDoVjBI+gYL8H8kP47VqCA==
X-Received: by 2002:a05:6a00:4b4d:b0:7a2:7a93:f8c9 with SMTP id d2e1a72fcca58-7ca89a6c1d3mr23814778b3a.27.1764582496654;
        Mon, 01 Dec 2025 01:48:16 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:16 -0800 (PST)
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
Subject: [PATCHv2 4/7] zram: move bd_stat to writeback section
Date: Mon,  1 Dec 2025 18:47:51 +0900
Message-ID: <20251201094754.4149975-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7DE4160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9mqgnau8yauomh7gjxoio1oy93eb4mnz
X-HE-Tag: 1764582497-600990
X-HE-Meta: U2FsdGVkX18tp06P/5mcCKw+334LW7fJ/iPiWpSbqdwWDDoiQo5CiXvJG42k4ogySLzulutupuBc3E4YVL3WWjclQTtJV5GJy78G1lHF1awHydXvi4rlAarpfj5D4Z36KygSBR/iArj4r8mNxEUlfGZZ7fOakRFIvMsvODfgA1Y0DetanmNO0qjbJjZQJ/XUnEiSW26aQpiaMKWIxLWO9PDtn+5OIKn+q6eve6V48z5Jhx38MU1wkGVoP0WIEBoaSorJzrXNvrowlkE5hfJuX/pGGiTZR5JzN4BtGx99LpOpBuo7PtKeRSgUTV/m6NHTtwmkbTTcxLVEqMNwSYTUGngVD7RZNL2V3T6nlJ6Mx6SzC+Zc8SjtjQJWzZVjCRW3CKNcv9+M8rXzK5lvlfZIfSXO7QDL3omq7glpsohhvKafimNhiYfJd+xwspyWy8nk6h75rUl3eqn7+wvpf8gD/e9RsObSsmg10XDsNWCSNA2bvIA85eWjaJwGdFc9A6ybT96mbjjveoymZDbnXP439wf2Jh0gvV+PxUvoQDvRHaqVtmOWKg+KK7xdMpWpIACYaivQUi2Ml3ctjJaiEer4DeDXy0yhgzxoUZWWyKYo84hLRlR0/srHq3iPhKTwSOiA4J3g7bfkUANexjoSwPBXsTGLMor8dsTQfWlwwrSLhxOphrietYRcRASv9Qx8ZbNP4oHFNqPCEIzf0x+Sah3Hl+yBm/1qgAIXzV2nC39mur8rjqbky70gLRGyOmQrewYTKJwZopdp5XbbINpemJ41DYD6Y6t05OM7q8J/hsl44AhoI/wzbFST97PHYqC408nPlLM4cbktVOGE/RkAjNHr8E1OQ9Z12SYV+O/4QN5q1Kuq4ROko82N7lAXN47JEs9dgByv24XCrLwFTNikfmLRaUOQ3CPXIiUap2tSkqgSypQjzoDiXMM1iA0QASizqMT9igZtbsrHWJd61xqP8jM
 VbCA67BU
 NWFqc0q6MI2ooY8G5ES99VzBp4qT4NNXFo2LPB88v/vgp+Om8p0h2yQWx69fp1i9Pngs8tzTZiE/xhGtJGNGGHn5gqyGmw9nEyc/vh3geZ8GwhI2BG9Re1SLv8YtnrkDhJfmgIaitlseIXpi1y2tJAgAzuy4bvbGKa0SgjgIQg2/bDOXJHYk3cs558NuqArMX0mk+D0TmVdDJvNUioCcCgEnw9r7VHjlF7bJEgA5cg5NOa7gJ6J2ZLtDOqWpdAMgD++f/cq1mmW3LOWtIJYREFKU+KQzCq/SGw7tSIS/DOZ7cNjC080mSSTXu/CMc1Ry3DqX7FL1UZR5nMmnvIRJKUdvkxJwwheMDvwgR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move bd_stat function and attribute declaration to
existing CONFIG_WRITEBACK ifdef-sections.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 48 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 3cc03c3f7389..1a0f550219b1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -539,6 +539,24 @@ struct zram_rb_req {
 	u32 index;
 };
 
+#define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
+static ssize_t bd_stat_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	ret = sysfs_emit(buf,
+			 "%8llu %8llu %8llu\n",
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_reads)),
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_writes)));
+	up_read(&zram->init_lock);
+
+	return ret;
+}
+
 static ssize_t writeback_compressed_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t len)
@@ -1976,28 +1994,8 @@ static ssize_t mm_stat_show(struct device *dev,
 	return ret;
 }
 
-#ifdef CONFIG_ZRAM_WRITEBACK
-#define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
-static ssize_t bd_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-	ssize_t ret;
-
-	down_read(&zram->init_lock);
-	ret = sysfs_emit(buf,
-			"%8llu %8llu %8llu\n",
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_reads)),
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_writes)));
-	up_read(&zram->init_lock);
-
-	return ret;
-}
-#endif
-
 static ssize_t debug_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+			       struct device_attribute *attr, char *buf)
 {
 	int version = 1;
 	struct zram *zram = dev_to_zram(dev);
@@ -2015,9 +2013,6 @@ static ssize_t debug_stat_show(struct device *dev,
 
 static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
-#ifdef CONFIG_ZRAM_WRITEBACK
-static DEVICE_ATTR_RO(bd_stat);
-#endif
 static DEVICE_ATTR_RO(debug_stat);
 
 static void zram_meta_free(struct zram *zram, u64 disksize)
@@ -3079,6 +3074,7 @@ static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_WO(idle);
 static DEVICE_ATTR_RW(comp_algorithm);
 #ifdef CONFIG_ZRAM_WRITEBACK
+static DEVICE_ATTR_RO(bd_stat);
 static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
@@ -3102,6 +3098,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_idle.attr,
 	&dev_attr_comp_algorithm.attr,
 #ifdef CONFIG_ZRAM_WRITEBACK
+	&dev_attr_bd_stat.attr,
 	&dev_attr_backing_dev.attr,
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
@@ -3111,9 +3108,6 @@ static struct attribute *zram_disk_attrs[] = {
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
-#ifdef CONFIG_ZRAM_WRITEBACK
-	&dev_attr_bd_stat.attr,
-#endif
 	&dev_attr_debug_stat.attr,
 #ifdef CONFIG_ZRAM_MULTI_COMP
 	&dev_attr_recomp_algorithm.attr,
-- 
2.52.0.487.g5c8c507ade-goog



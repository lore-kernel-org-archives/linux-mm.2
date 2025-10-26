Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6957CCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 01:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DE58E0158; Sat, 25 Oct 2025 21:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35B28E0150; Sat, 25 Oct 2025 21:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B7A8E0158; Sat, 25 Oct 2025 21:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A096A8E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 21:05:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E152571A7
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:43 +0000 (UTC)
X-FDA: 84038472966.01.C65AB1D
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 558F6180004
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eQJnkJzO;
	spf=pass (imf16.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761440741; a=rsa-sha256;
	cv=none;
	b=d9gnUwKjb8J3vnBvhTr3SkmH1uj+zSue3tsEq5Re/gGf/c1TOdjbHHrFaiY3Yr5Fnc1R25
	TQjp+W9xpS30q9M39KwRVTcITZ+ePHO6B4wOQUTjScULV9FEbe2neMF80pZIipcy90kXYw
	G3dX1YY+cGfwT10GjFTw2v5qFIH1+Ys=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eQJnkJzO;
	spf=pass (imf16.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761440741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S45Vd5RIAYqg0q86pnKyuOv36CWTtcQIjH0J0fCtYok=;
	b=0f4KwUpzTqrnI4/GBqvP+wnvytzlLVO8hsiYtpPvfLSBHmrsgJiafyhFurBdxk7FNfbo75
	jZT6hEtmdLoxWb6PMB8En7Jg0PYPS26Q798KezubStKchyWeQnRSK/NTSM0QNMr2V6mNJd
	b1/DZKk4Hzq2bIjk3OG+BEfbzyF4XYA=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7833765433cso4377201b3a.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 18:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761440740; x=1762045540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S45Vd5RIAYqg0q86pnKyuOv36CWTtcQIjH0J0fCtYok=;
        b=eQJnkJzOUkPzSKPTbrGBcR74ASdppXmIXXQNBm1Ya4HrBm4o9ldtj2xSBvndj7WziF
         MUb63tDpCSPWVhRSYx3PIFfST2o7O91tofy92w86MK/WSyi42SYabUHKXmiVht8XJTH2
         Xm9Dcr2WDpUuCjW/30guNFKrHQnn5uLDRjEq1vAosF2eQRQwrjdXCt6p+vUOIpUy3xnA
         adVtFf7r4rs0QPwIwPaxy3lT30J2m7tdAwqio8Nts3im8Z46YNcsMAQ9SDVV+aDqv6Sf
         m1WWF3aJqSZONa3QvP7hOFU+LSSdyY/7mWDMEJ0alt0/fJxY8/8f7EZfZpwIpyQExp9X
         mWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761440740; x=1762045540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S45Vd5RIAYqg0q86pnKyuOv36CWTtcQIjH0J0fCtYok=;
        b=p7W6NYpexwrlnJpNP5rqAU4dpWND5ZUSuNnEiepbNmyYo33vYEYvxnSvHPPjvL6nJO
         XuvM5eX7xSAO0xxNtCwelUS1uJq+OzqdUH+u0+15Yk8kvZqb9NHKevFO88qURb/JFkvp
         UFXsKTuEppqiM9V+tT3ArHGrLtyLtKlG5Du3ceW1jjvJ/8pwYh2eFU1xJRny8hXkcy50
         stxSp3Yfn6sRbDrpRrVcf1xeMY7ROjDq3N1K32Fr5LNpicXq0qwJ+8g1VhlIkJyg2SKC
         5LKv6/7Ild4B2peCOu7EaGkbl3PgwVYzc7JHW6UvI/pUDixpMjZUO5ZTVIkSWSLI0F4S
         BOBA==
X-Forwarded-Encrypted: i=1; AJvYcCV5dbKvsHQ/nmmBXdiRfY60ZMMaQEMySjTuukA8uypxZ31F8R6gYcZgzAdeD9WCoRQlPL3wQEw5ow==@kvack.org
X-Gm-Message-State: AOJu0YzopRvIy/4+5ey/A4DoFKuwrh9XZQ7nd/qD6ixfJtjTuC2xB2U4
	GJ53FUDagyk1mwwvCCevnTKFNEfmygHmkCV4oayoFoRqVeF52hYrDwDL
X-Gm-Gg: ASbGncunLaSCGwjkHh8TuI2oD25mzWBU20ybsRhf/uuCZ81taA4BJmOum3y+ab3pDED
	dSoWndoVx9zfeZsXpDYyUkAVYVIxFB6dOG7sFncIZafqUFjkjdrWONmTDxfvEvhqHhXniV7tlfk
	LXri8rl7mqUEfgEdr0st/srpJIp2smkePNnxdIwpVzGS0cppZzOx0zqyUwc1SRArQqmeZHNmM9J
	o6DazYheBtDSEwF+ZvpnjlR782Es2gSDwl+LpSs5DnyihW4u2BkIiJ0v9saH/Jfu+LorDfvuOAF
	ZypCU95Y10Y9xvh1dAmNv9OAM2iqv4IH/v0Q/0Pgwu1yi84cMkTVQlsqPZbIfIW7jYX3DkE2R8p
	Y7BRgQl7NZTRoKshK2fmaELTd/47vxLqjkj/hEgFr26np6i4DglGxifAI5NuBoPBYu4T9/3cJSK
	AtiBgSx3b82JRjIelgP2dvP5jT
X-Google-Smtp-Source: AGHT+IH3gaZfX15xSYXSXwe2kaT3c45YGp22P1ke9T0VYUHajdlPt4RUIsJeGLbWWKCn87o/Tq/dUg==
X-Received: by 2002:a05:6a20:3c8d:b0:2e5:c9ee:96fb with SMTP id adf61e73a8af0-334a8650396mr43445620637.59.1761440740211;
        Sat, 25 Oct 2025 18:05:40 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41404987esm3371597b3a.36.2025.10.25.18.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 18:05:39 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	corbet@lwn.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	axboe@kernel.dk,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	terrelln@fb.com,
	dsterba@suse.com
Cc: muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	zhongjinji@honor.com,
	liulu.liu@honor.com,
	feng.han@honor.com,
	jinji zhong <jinji.z.zhong@gmail.com>
Subject: [RFC PATCH 2/3] zram: Zram supports per-cgroup compression priority
Date: Sun, 26 Oct 2025 01:05:09 +0000
Message-ID: <0eef2265014bf9806eeaf5a00c9632958668c257.1761439133.git.jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jq66marr8kfn3mnt78zncnyjebw5tpwp
X-Rspamd-Queue-Id: 558F6180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761440741-751513
X-HE-Meta: U2FsdGVkX19NmKRVI7pziTz3X97JaNfPRZwpuk8OlWnszXPuDDKlyZQ1QD5dmGO8GkDwQccqIT8UwXBdfogJQiL4pmXAGe1EdDRj/4jSqzofJD8pDNgIhJytzvIBZaNHiyJ1Zt3XUPcp/kznajnBfcuO168Xjv4cmsyD2dImZgByWxTY9NJ/KP8yTH3wMbRjkvO+LQJ4jRjrHUdYjoVPe/k0Go6kEP8eYQho2B6EvJ8Uk3lSedRRExrpSq9JNJ+j56Bmx0Aurumej2gw+PLA0QlAPTJjZbQ/82585cPYJRiyiLnfhlXMyJdOwQcld7soQXvBo4Va5huE5cxuUSMA6oMcfsE8wgMopDO3Ch5rF31hLtW+lJOsH37HZk4egp7oG8BORt130ZppAicJiTsRSMaQvwMdLiM7+tGG3lhYZgOAJre1sHD2SNOSvkizjoNQPAB2XDJa4Ss435vIQcEIOz0XnlPxf1ZNjU6FzV5XCeGDXYyT/k1v5G1ZNFc7jE8U1+BOZYqgXtCUkXmQZ4nQ4nTSJb6wR566pAOJ6t604KxReVXcR0YzqJucKDWoYU9d7LWT0NuGb61AvRL0L+FEAnWY2a6pWWZyDkSjKP6pBwEpCERpCBJOlIacyePA7Cf7WSfw21WZccP9YuuKmyO0BTi/EALeXcFvfeUC7ubxdCCMVWfeWAC8LLedfmNfj9/OiNWMTpAJ23GCZ2KC1Jis7WaGzFh5CEc7cgz65AyFbkywa/zMnb3N0Pc4O+ZKN3QZfZ6IgLIlZB/K729lYA3Z4GnN+ZafCLXH0rvSJEcvIzbbIBrkv2s8pzJZPXjVCvdrCD/ImNC4BL9JkqGtRcm5hTWg8ZfccxCNq4Br3haUEOaXm4zg4J60jR+IuWFyr7rSycMIYR80oqgsixH2yoFpaAoYIfgMWN+5SbIwspzsdZ4tFByF7mpwBsEL4kk301ta/ffXNwK6aFGkM4LlZif
 t3iqAvx6
 Yy9yT29Ca7rJJ/+PEdzwiL99tPMx/WSokhpJAPzDgGlDyFrX8tX0woUq7axVnIvwRGpejpsrRyt9GPFHVgmpK+5AZxkpySV31Ji589Tht91JjRddcZpUFlUm1N5hiL8WqgVRkUfB4iBM9CE0U0czSN6r3qOwKZOhXzqusMfCoBgTvvtLOgnegP71ahW+BqDdvMguQ++a4hUT1pRO/MIoceCkGkztfE5cjN0WsjY7CkVXLw+3pJEJqJjCKXVUBikA7P65S6Xt+jsQBUspCFoAsR2Q0xIsBxdoKx+q37q6x+Mi7+01Hm9WO9740OmewADn0FqwsgzoUOJOWOHtp/tl+p5wuiczawa+r/ZuFZof6HGrzyNMljn3RDf1rBsa58ASuRa3mKWUVgjEF6Xunn8a015UXxWemD9bXz0aD+6CUxKGq0/R0MoABGqDzWr+lmknsbvO0iKkKUJRYSUAba6NR4LAhxUHYzoEb3JVg+XBvrI2V4PBv4Zg4Z9CRPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch allows zram to get the per-cgroup compression priority,
enabling administrators to select different compression algorithms
for different cgroups.

The feature is enabled by:
echo 1 > /sys/block/zramX/per_cgroup_comp_enable.
---
 drivers/block/zram/zram_drv.c | 74 +++++++++++++++++++++++++++++++----
 drivers/block/zram/zram_drv.h |  2 +
 2 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..da79034f2efa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/device.h>
 #include <linux/highmem.h>
+#include <linux/memcontrol.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/string.h>
@@ -1223,6 +1224,7 @@ static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
 		kfree(zram->comp_algs[prio]);
 
 	zram->comp_algs[prio] = alg;
+	zram->comp_algs_flag |= (1 << prio);
 }
 
 static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
@@ -1396,7 +1398,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_MULTI_COMP
-static ssize_t recomp_algorithm_show(struct device *dev,
+static ssize_t multi_comp_algorithm_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
@@ -1405,7 +1407,7 @@ static ssize_t recomp_algorithm_show(struct device *dev,
 	u32 prio;
 
 	down_read(&zram->init_lock);
-	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
 
@@ -1416,7 +1418,7 @@ static ssize_t recomp_algorithm_show(struct device *dev,
 	return sz;
 }
 
-static ssize_t recomp_algorithm_store(struct device *dev,
+static ssize_t multi_comp_algorithm_store(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf,
 				      size_t len)
@@ -1450,12 +1452,43 @@ static ssize_t recomp_algorithm_store(struct device *dev,
 	if (!alg)
 		return -EINVAL;
 
-	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
+	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
 	ret = __comp_algorithm_store(zram, prio, alg);
 	return ret ? ret : len;
 }
+
+static ssize_t per_cgroup_comp_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u64 val;
+	ssize_t ret = -EINVAL;
+
+	if (kstrtoull(buf, 10, &val))
+		return ret;
+
+	down_read(&zram->init_lock);
+	zram->per_cgroup_comp_enable = val;
+	up_read(&zram->init_lock);
+	ret = len;
+
+	return ret;
+}
+
+static ssize_t per_cgroup_comp_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	bool val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->per_cgroup_comp_enable;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%d\n", val);
+}
 #endif
 
 static ssize_t compact_store(struct device *dev,
@@ -1840,9 +1873,30 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	return 0;
 }
 
+static inline bool is_comp_priority_valid(struct zram *zram, int prio)
+{
+	return zram->comp_algs_flag & (1 << prio);
+}
+
+static inline int get_comp_priority(struct zram *zram, struct page *page)
+{
+	int prio;
+
+	if (!zram->per_cgroup_comp_enable)
+		return ZRAM_PRIMARY_COMP;
+
+	prio = get_cgroup_comp_priority(page);
+	if (unlikely(!is_comp_priority_valid(zram, prio))) {
+		WARN_ON_ONCE(1);
+		return ZRAM_PRIMARY_COMP;
+	}
+	return prio;
+}
+
 static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
+	int prio;
 	unsigned long handle;
 	unsigned int comp_len;
 	void *mem;
@@ -1856,9 +1910,10 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	prio = get_comp_priority(zram, page);
+	zstrm = zcomp_stream_get(zram->comps[prio]);
 	mem = kmap_local_page(page);
-	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
+	ret = zcomp_compress(zram->comps[prio], zstrm,
 			     mem, &comp_len);
 	kunmap_local(mem);
 
@@ -1894,6 +1949,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	zram_free_page(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
+	zram_set_priority(zram, index, prio);
 	zram_slot_unlock(zram, index);
 
 	/* Update stats */
@@ -2612,7 +2668,8 @@ static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
-static DEVICE_ATTR_RW(recomp_algorithm);
+static DEVICE_ATTR_RW(multi_comp_algorithm);
+static DEVICE_ATTR_RW(per_cgroup_comp_enable);
 static DEVICE_ATTR_WO(recompress);
 #endif
 static DEVICE_ATTR_WO(algorithm_params);
@@ -2639,8 +2696,9 @@ static struct attribute *zram_disk_attrs[] = {
 #endif
 	&dev_attr_debug_stat.attr,
 #ifdef CONFIG_ZRAM_MULTI_COMP
-	&dev_attr_recomp_algorithm.attr,
+	&dev_attr_multi_comp_algorithm.attr,
 	&dev_attr_recompress.attr,
+	&dev_attr_per_cgroup_comp_enable.attr,
 #endif
 	&dev_attr_algorithm_params.attr,
 	NULL,
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 6cee93f9c0d0..34ae0c3a9130 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -120,11 +120,13 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
+	u8 comp_algs_flag;
 	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by disk->open_mutex */
+	bool per_cgroup_comp_enable;
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
-- 
2.48.1



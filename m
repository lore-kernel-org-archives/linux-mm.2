Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DD3FD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337C36B008C; Fri, 27 Feb 2026 03:21:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3BE6B0092; Fri, 27 Feb 2026 03:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146256B0095; Fri, 27 Feb 2026 03:21:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBD256B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:21:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8761659689
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:56 +0000 (UTC)
X-FDA: 84489543432.17.0EBEFA8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8190C000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aUXeQbTH;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klMEeOc7AupNNDDtt/xwYDltCZD+zghJruOaHj+TkY8=;
	b=10t9IoX+L13f+ws5/VHHM7tp6pkim56ljgo3BetVjhJs53r1z06NnUcbQwruT+TXtS/hTi
	VR13KPLUbK1NI/XfsdxTD/8934zPjvXfV2rOr1830PxjZlgh1ijEhemZcGBhilGzrbSZN8
	M9kc290Lc7kpe6sIBWUo+G9jtjEj9+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180514; a=rsa-sha256;
	cv=none;
	b=oQfUFsVY5KKc6bdQt7H5v9xAeWb3YstMFCp35meOixkVVP6v4Ch+7wW5+So/V4HYnWoKHL
	JQwPYWhSbfvBLuWnpKnFp24eUmb2Vr55bRH3iahUzWwA26YxzYZwR3P4UZnGFE6iP+dsTF
	K1xCFviftSZ9kH0+GJAfRnO1LM22K4I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aUXeQbTH;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a9296b3926so14219645ad.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772180513; x=1772785313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klMEeOc7AupNNDDtt/xwYDltCZD+zghJruOaHj+TkY8=;
        b=aUXeQbTHINnavVmfENc0mS9Uyj08qL9xc99o8D2RryBtzW43BpzVQqm09hPVAVZWL8
         kksEkKQKtT4ZqMJrPNyDOvpCE1+3xkf2hclI8GcZFMb2LR5v8I65P+7RW02VRSN7uvbi
         AWz2/aEK9lUVMLDBbOOutuQTHpRHab9dyidkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772180513; x=1772785313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=klMEeOc7AupNNDDtt/xwYDltCZD+zghJruOaHj+TkY8=;
        b=JcoSH+sas2bF4ZFNW9Y+OqTUmzYPThDZZx2w/HMVJRIs9Ith6o/o18iiHfntO9xMx9
         ydkB4PKJ3bS8EUfIkCx6fcSg/9N+2wOOkdoQh2c2JzDa9L/y0tT7aeDmDKYEz/CX6ruR
         J31otYCkSukoH9OmEoUU5EO562M2pcP3Ek4fIxq1hLkmChvnxEQvuxud5GrS6Ti8kDca
         WK7SLxkZtH2jRgRDbxDtpYOVzUO/GHdj+sUojKfk21OzQ/Y2j9FZCPjaVqO9U6bEIrwh
         sfsPkythJUMUWkdqw4Fn7ULlVGTMMLOjnWiOEneNoxcf30SS0Yp6aeExYkgummUnbs+j
         9L8A==
X-Forwarded-Encrypted: i=1; AJvYcCXPj3zXG8bD5A3NCVo/qjsXxi39wO8KvlBYxADCGTgJIgOnT9+ZpXtqhvyLt/Pj0gT/tRZjaAzK+w==@kvack.org
X-Gm-Message-State: AOJu0YyNOIy9b/N6Ov6QHzAhcanqOsnIMQRWgiXPAiB4LqayacQ/YBEP
	utmmsTFbWCWI2oNxuFnKFvG29ixNae4IPh8HQYFeuZi4o31OvX0kWTfesA2TrRrGXJZyy6A6syY
	0ngQ=
X-Gm-Gg: ATEYQzy1M+ttwRvHvpUVXCiqeBHI581Y4UeogPURXGKNCU1WSnWchz70RcqZ0NuLViK
	gkdj1BAZLwCpjtWE8NUdjkqVsXSEOkEELkQ8j/LjHzv3RUd4yk+hxUB8AByVhUBGeTjZA5Uhk6/
	4QQM0DnNDWzUDu9KErErEU4VfHkim7GjpthdKgehz3RrTFtlSFqgS5jL7OpsSSQ7oQtMtp2HYxw
	z3Q8SwvkKu78rS3yjxsEyIHEelc8iUofgPYLTQ61vqzmyG+PesjXTNERJFWAZd5r3SA2ibuR87e
	ma8OQLIDc7UJx1/1hFa+K7fETl9PhlLR2zo7DiAQbf6RWv0pmR/ARwv7BbyJGYBeEBfEOj/IIq7
	zXeGxl0QOtlkWwYKec9vATztrnESL2RkEG+LgFJoY8+L9a570gHB80HskaXDEwpgULm/wK7NiPZ
	+Y0Tcs/DgxD6Xc32ZG4uUhiTTT0AP4/gfkDO+csLoE0q+ixs6pk/nI0PwnwzfQwJDJs8Bj1vESV
	rcZbujCxCeYUA==
X-Received: by 2002:a17:902:f710:b0:2ad:ae75:68ad with SMTP id d9443c01a7336-2ae2e417d69mr17948965ad.57.1772180513501;
        Fri, 27 Feb 2026 00:21:53 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa4fsm48796025ad.45.2026.02.27.00.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 00:21:53 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Geffon <bgeffon@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5/5] zram: remove chained recompression
Date: Fri, 27 Feb 2026 17:21:11 +0900
Message-ID: <cf100b13afb62641d7f3bc10fd77068833f56af0.1772180459.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8190C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 86p4i39woqbhc1mqwxe56y86srjy1y4d
X-HE-Tag: 1772180514-414992
X-HE-Meta: U2FsdGVkX189iQPBFUVD7HGS3h07/Lf89tTc29o0VCO8bVDCmVPZzicOi1APDwh6FnY2cqMeGsIL2x+xe26bWPpo/xoBzRdzppb18IVSoGMXO1hymX6UKuibAcBK8+ikBn2s+Fbi7T9sNmAkdWnKupVVCuvzmPHKAy9TDnmKcnrilCl7V+N9KlJhmzdeJVVwHrd/Tvh41vLOQYP1z1rhi+jXf6qbpN6j0s2X94rrsBJJbsf35BsfOK+jfMeevrmXMLxb2DcSg+eWualwFJfYSZbF86PfWBaUKuaDsr63chPBUHhBGrErSf/KBNjBWlXTwXoMfQkTQ96KFw459EHE33OquLidv5bAKv9F+73MiuqcpwBtZgYAhs/HKE0o6IJLTQw3sap1xYhD6ad9zgWdMvHEVW0gVRYLL7M+I4XUmcw1qIk40LDE1tJiMcOunbFn8aSfDujTweZwUY4HCA8E6tGlJniccY4RQ9K+tGgMcL2w+nxiwm7QZjPKTXHyVy5QbJJuOyFmmyymY2uKLzzzbieOdl5Kfhdhzql4kYxoZ6rPFQcKVqVDVVIf5fOAXoXVXiGufUvzV1SfHhLGFRjTPAiGwGy7udyw+JoaamAfZtavvEkgkzlQraDIE7hef+Q31w7dafzSPsYYzyaL4s/bxfa76fs9IQdf4W3Xy67/k5q5emYUyPGt5MeiQs6jH46iMmQ4iHlL93nka/n8zPcwz1F/z+ITxI9YV0AzrUiEvztZwga4JwvsbzKxSusYgjUCRiNmp4xlnoDm94EFM8wOmDIdRoZKJgPBLfh6FAf51IIhTwJwwRkaIIeCXLQiJ41LxtXBhUYs3xiWpLZ33scWUbqdv3cmknEnoZ4NxSovBembhNTv4bCXaBI2FEIkZha2O9IJzRIylKDEV3fkh0sP7vZBMa6G3qL+lvOVfJl8N8BQba4xGTJgOVDvdY4B8d9LRhyujwFzFV5NiZn4K6N
 zeRHKVcJ
 5A9W8nvpL56m3RF8NogNvGKXw8mZegRobZL5mv3sjhJwxgqkM4qWJAGbS9fb6ojHEpFb3shAr2mAz64sdhGfwQE/Hsv/p2hIg1Uqx6r9wCWGIl2g6xYAE9tAvM9yOq3P3MXSblGkElzfNcZpvBfjP8ZjDFjI47EmCbn3gUUY+7d9VR8HLGBJ7j3H0lmbaUgQQ0rL/5iQMDyJ2FzqqUEMdkNq7KTR3RBxcQH98d1G9TLoZJOCwHGTo4IWoT6vkWNqDriSNHmEU1/QKA6y3eQnizg8Ev0VYIQGbHJC1as1rGeSVisyR3CznhG+8TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chained recompression has unpredictable behavior and is not useful
in practice.

First, systems usually configure just one alternative recompression
algorithm, which has slower compression/decompression but better
compression ratio.  A single alternative algorithm doesn't need
chaining.

Second, even with multiple recompression algorithms, chained
recompression is suboptimal.  If a lower priority algorithm
succeeds, the page is never attempted with a higher priority
algorithm, leading to worse memory savings.  If a lower priority
algorithm fails, the page is still attempted with a higher priority
algorithm, wasting resources on the failed lower priority attempt.

In either case, the system would be better off targeting a specific
priority directly.

Chained recompression also significantly complicates the code.
Remove it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/blockdev/zram.rst |  9 ---
 drivers/block/zram/zram_drv.c               | 83 ++++++---------------
 2 files changed, 24 insertions(+), 68 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 967b58c3aad2..60b07a7e30cd 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -533,15 +533,6 @@ unexpected results when the same algorithm is configured with different
 priorities (e.g. different parameters).  `priority` is the only way to
 guarantee that the expected algorithm will be used.
 
-During re-compression for every page, that matches re-compression criteria,
-ZRAM iterates the list of registered alternative compression algorithms in
-order of their priorities. ZRAM stops either when re-compression was
-successful (re-compressed object is smaller in size than the original one)
-and matches re-compression criteria (e.g. size threshold) or when there are
-no secondary algorithms left to try. If none of the secondary algorithms can
-successfully re-compressed the page such a page is marked as incompressible,
-so ZRAM will not attempt to re-compress it in the future.
-
 memory tracking
 ===============
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 118b0b277e37..ff1931e700c3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2331,7 +2331,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -2357,8 +2357,8 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 		    test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		/* Already compressed with same of higher priority */
-		if (get_slot_comp_priority(zram, index) + 1 >= prio_max)
+		/* Already compressed with same or higher priority */
+		if (get_slot_comp_priority(zram, index) >= prio)
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
@@ -2391,8 +2391,7 @@ static bool highest_priority_algorithm(struct zram *zram, u32 prio)
  * Corresponding ZRAM slot should be locked.
  */
 static int recompress_slot(struct zram *zram, u32 index, struct page *page,
-			   u64 *num_recomp_pages, u32 threshold, u32 prio,
-			   u32 prio_max)
+			   u64 *num_recomp_pages, u32 threshold, u32 prio)
 {
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long handle_old;
@@ -2404,6 +2403,9 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	void *src;
 	int ret = 0;
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2426,51 +2428,10 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	 */
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 
-	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
-
-	prio = max(prio, get_slot_comp_priority(zram, index) + 1);
-	/*
-	 * Recompression slots scan should not select slots that are
-	 * already compressed with a higher priority algorithm, but
-	 * just in case
-	 */
-	if (prio >= prio_max)
-		return 0;
-
-	/*
-	 * Iterate the secondary comp algorithms list (in order of priority)
-	 * and try to recompress the page.
-	 */
-	for (; prio < prio_max; prio++) {
-		if (!zram->comps[prio])
-			continue;
-
-		zstrm = zcomp_stream_get(zram->comps[prio]);
-		src = kmap_local_page(page);
-		ret = zcomp_compress(zram->comps[prio], zstrm,
-				     src, &comp_len_new);
-		kunmap_local(src);
-
-		if (ret) {
-			zcomp_stream_put(zstrm);
-			zstrm = NULL;
-			break;
-		}
-
-		class_index_new = zs_lookup_class_index(zram->mem_pool,
-							comp_len_new);
-
-		/* Continue until we make progress */
-		if (class_index_new >= class_index_old ||
-		    (threshold && comp_len_new >= threshold)) {
-			zcomp_stream_put(zstrm);
-			zstrm = NULL;
-			continue;
-		}
-
-		/* Recompression was successful so break out */
-		break;
-	}
+	zstrm = zcomp_stream_get(zram->comps[prio]);
+	src = kmap_local_page(page);
+	ret = zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_new);
+	kunmap_local(src);
 
 	/*
 	 * Decrement the limit (if set) on pages we can recompress, even
@@ -2481,11 +2442,18 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	if (*num_recomp_pages)
 		*num_recomp_pages -= 1;
 
-	/* Compression error */
-	if (ret)
+	if (ret) {
+		zcomp_stream_put(zstrm);
 		return ret;
+	}
+
+	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
+	class_index_new = zs_lookup_class_index(zram->mem_pool, comp_len_new);
+
+	if (class_index_new >= class_index_old ||
+	    (threshold && comp_len_new >= threshold)) {
+		zcomp_stream_put(zstrm);
 
-	if (!zstrm) {
 		/*
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
@@ -2535,11 +2503,11 @@ static ssize_t recompress_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
-	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
+	u32 prio = ZRAM_SECONDARY_COMP;
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
 	struct page *page = NULL;
@@ -2604,7 +2572,6 @@ static ssize_t recompress_store(struct device *dev,
 			 * "algorithm" name lookup is ambiguous.
 			 */
 			algo = NULL;
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2624,7 +2591,6 @@ static ssize_t recompress_store(struct device *dev,
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2653,7 +2619,7 @@ static ssize_t recompress_store(struct device *dev,
 		goto out;
 	}
 
-	scan_slots_for_recompress(zram, mode, prio_max, ctl);
+	scan_slots_for_recompress(zram, mode, prio, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
@@ -2667,8 +2633,7 @@ static ssize_t recompress_store(struct device *dev,
 			goto next;
 
 		err = recompress_slot(zram, pps->index, page,
-				      &num_recomp_pages, threshold,
-				      prio, prio_max);
+				      &num_recomp_pages, threshold, prio);
 next:
 		slot_unlock(zram, pps->index);
 		release_pp_slot(zram, pps);
-- 
2.53.0.473.g4a7958ca14-goog



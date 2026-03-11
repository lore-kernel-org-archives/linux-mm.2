Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69020FD065A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBF96B0093; Wed, 11 Mar 2026 04:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431046B0095; Wed, 11 Mar 2026 04:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C86A6B0096; Wed, 11 Mar 2026 04:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 003896B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 839B21A0637
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:41 +0000 (UTC)
X-FDA: 84533143842.18.6585CB8
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7917C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="h/aFc+7L";
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3J71zgPkooXiG75+C8zjSqtAWOtBSB5HTzljq+F1tO8=;
	b=KEfltFCTCcp7eBQQfXKiKYWLF4/e3mYNEi2kjGoKt5AJ6pVg7/SZBN9WA1EzXTmd3FiFMc
	y6pDWdUtm7+5Lakzo3A7rtgQFam9wZiTKFvU2EQOb+Bw+LckLpqLN4wLj84/KdLIC3e94K
	3mZ8uSh2dJXbGSpfAWXrb8u7orj3h7M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="h/aFc+7L";
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218619; a=rsa-sha256;
	cv=none;
	b=0/z3e65qqWN+jIVMOfNnU2NxbPcT2orOo3sIaMSuR4kclnouEB8E5+DPDBlNjb/907ujl1
	WGqCPFO8Ftn+YAKG6B31DyqZxA5pyA03o04AjgA8Xp2aSsfcBnz8WsybK+p3Gyl9AzVc+n
	fFaggagFyVCQ25IbIO3GPxw2AzGEFHw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso60708605ad.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218618; x=1773823418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3J71zgPkooXiG75+C8zjSqtAWOtBSB5HTzljq+F1tO8=;
        b=h/aFc+7LrGQLGj2plRrFRs6emmO5lr3/fgCspC4DqonbL5+x+6eZ+j3WKN47KhZSFU
         D3PTaSo2Jnk7Wds+C/wnojWBjFggUvcnfjRJIq97lGKrkHj/gqFkBw+KQAbFltmSIjsx
         w/VU0o1eHSTUXvdmuWSPFWU6hUaG0xhzl336A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218618; x=1773823418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3J71zgPkooXiG75+C8zjSqtAWOtBSB5HTzljq+F1tO8=;
        b=rg8njhlDToyw97uCxw2MOWM5qWHU5c1j8KAtqGxsCQasWdcE4Jwcup07TkJ4aaqWYb
         AYl5o9WcQHS+W4y7bkqSrQiVrTqRWqixgjpDjUOaRrncdbsRIwbipG80knNa0xYoc7Yr
         ZmlooGgvWiUAgai6WWysP/lNmi6Qh/AqTgzZZ9OTLMhngKr7zVOi+/zoK3T+SzxCPKD7
         w2Y/o7PrjjbKsYzje3URbGtBtHXTpuV0qappB0fvfpAe/Lh8TZVUvVlRtHcZSz25Q+p+
         5T1cqiEvX8aUhyNcih62u6MWB7Dh26RCBIZXlon0aKtq454spdZhaobrafyPMGDekcV0
         K8jA==
X-Forwarded-Encrypted: i=1; AJvYcCXnHHiWCd4PyXxUaNEPRqBTxfEjsy7+NCqTeBqhSozmXbGEp8S9bm8X1RIF3mMjZwtl65OVI5Y6fw==@kvack.org
X-Gm-Message-State: AOJu0Yyn7RHpTpEkIWB8Etgfpmlvr+cikwI7IXx84Cgzh6G7I3PRj/g2
	zJc7ILT1cnjjjAvngrv3AKN9R+FAJVbMsQQ4SATOkP+oeXt4P6ChuQ9tfawGpH+HEw==
X-Gm-Gg: ATEYQzxjPUNmIDIKtqOtKBG3DQqLiqqBjr5QPEzlnjv4ZMxmApbQlN/d7DMArdDZLhN
	ov8BKFVH0VjajtkKwECd93X9e/mHXeFzlkvRYlvusB2RSk8MJ1s4uMAdXLO+ZChQAE5x2Ppgkvz
	sh5aKMkEEp78ppjLgLEwaJYE0+v0VF1eZPNIXaKLhLcZfYmtRB7QpPveMtljPL77Utdk4Zvf74C
	GHVfjc46KpkpgePRaG5FzhrIja+UKBQvWc8OVUy4QL30WrnHR2DA18taKRED7++DOvDl6Zs3hVw
	Ed1HHgkrv8+ClApxOYDRwl4JTHnJFjqWhe4IHVq+TCBPEqwW2j4/rsAuy1pdg67mVhB4tAkjFVl
	Q3KJMKIvIPT4WklCaGYUgwxI6Wa6eYsfpwURUxoJGL+IPfHRjFWRQYu4b1i5bqwnTSPTCXq1QlQ
	F8BruQyBbbcf7RmwrFCn26SWbCRNx45Dl5C3gNZXYxDHRrPWRGaj32Ka8paymCt+hNX/kd1s+yp
	g42akvbtOTiVNWUR244UaBQ
X-Received: by 2002:a17:903:2f8d:b0:2ae:3fb9:2690 with SMTP id d9443c01a7336-2aeae7ef14amr17051225ad.19.1773218618446;
        Wed, 11 Mar 2026 01:43:38 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:37 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 5/6] zram: remove chained recompression
Date: Wed, 11 Mar 2026 17:42:48 +0900
Message-ID: <20260311084312.1766036-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dixx1i47awpt9pwadtg5ze8t9o4haod4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A7917C0009
X-HE-Tag: 1773218619-322411
X-HE-Meta: U2FsdGVkX19mcaiu3FD7tgbSE3APeAZMDI+ky574Z0mFQ5qYlEjdsikOg8lSKTuucsgXhYxq/TPOE44zfL8GarTAcoBJTFr3wp/YKmJwZWEUbzAM4a12bf/0/P38TeD6GjmREwHMoUT1QbbvlOIr0/IzoSBhrs+HSQZro+lw82jG4cIWMADgsY+hdFl6F4bcsreKaymvDMQwqFMaM0+zksTZbyjpYiw+12jCEtiQcB6uwPZFCKJGzO0/VFmSkmQ4tbqVNZC8o22/FyrzVYCmA2NNh1qAdZMmPw4O4C8Nw+DgpnnYGmHbcslB9YD1FOhGkI8RPWqXK2mBXOa6K4OMXpcGHWjpCZnQh/dbqtHIK1axA4NMjTmLJSsRHSb0SXAXKjesEIKKsHcHmfWf2ICXzJ0wrKprruDnwSAX3qQjc0lJp6gMc+lhP+PUTfqfdbgFRDUtcA+zN/sENlPtghZuw+AjQrlU+JJZ26xmU8YllJoF9C1Ls6eua3hiFGkIA73Lp/acB47sDeAilqVQhQXwGmj+jkd5sJ7Z2F8kcXR1tOL+BTixanEUrQGulFWnaf+11nWgBf0WGUV0cSRPUzE9WsKKwiyRN94LMXyRG9FGDG/d8TYc+sLM9YvrJ8LVPlTJElcfp0LOQX+rCxJSEizErfe3UerTVeC2lLn4qXCj/iqxd2XXLpl3snbKcjWa2S/3n00oteAY0g9kvY222AIwMumId7pZHaNLiBdnuovqRFEpYkHM2ybzTSxmsB1bworNrzb4PIJdOrgKMXHFm4fSG4gUwBdG0A+xyURJSP3nx7W+ugCAOjr9WyX69wL80HE8FQUSxTC2zrgARo9Z1Wf230x/qXypn40td1E6NYJryGGuvj2wIXShc7hK8hr7bULCLjsomYX8ofHm/M8An/x5yAF/MP+bA71AGuaxBbYoCquMRfY86NXptsI3YLbzE8JGJJlGoNRCeqMLmNZG+H7
 9/suZ860
 AEjQ9fB6X2pZDqXSuLMyAVLY/7wThjFnNp/JEmR4yJj1I1uQgkzhqPKsasbT96U/Wl7EReG1MpJm1hnLPD9yr7l3rfma86YuVkqd9wEblfvBGFkp4kebhgKAv1Z6IQjy711GN2l0U4SS0EYlbeQqDMYDtWa+RloeiYY6BTy6A3s2tdLLeq2R1NIxWYrR4JA4xqTc4z86WJfPtQinRQ+RcFPjY/ZBRYOP95ncf9P4raf2pGXhYloloSztE1nXkLWkQghlrhtQpfsrDVALX9GagPJItHKi5l05pKgphkjbC2o+vshrRoL+277T0cQ==
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
 drivers/block/zram/zram_drv.c               | 84 ++++++---------------
 2 files changed, 24 insertions(+), 69 deletions(-)

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
index 0c3e83787d9d..02fb70f35ae8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2347,7 +2347,7 @@ static bool highest_priority_algorithm(struct zram *zram, u32 prio)
 	return true;
 }
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -2373,8 +2373,8 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 		    test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		/* Already compressed with same of higher priority */
-		if (get_slot_comp_priority(zram, index) + 1 >= prio_max)
+		/* Already compressed with same or higher priority */
+		if (get_slot_comp_priority(zram, index) >= prio)
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
@@ -2395,8 +2395,7 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
  * Corresponding ZRAM slot should be locked.
  */
 static int recompress_slot(struct zram *zram, u32 index, struct page *page,
-			   u64 *num_recomp_pages, u32 threshold, u32 prio,
-			   u32 prio_max)
+			   u64 *num_recomp_pages, u32 threshold, u32 prio)
 {
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long handle_old;
@@ -2408,6 +2407,9 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	void *src;
 	int ret = 0;
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2430,51 +2432,10 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
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
@@ -2485,11 +2446,18 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
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
@@ -2539,11 +2507,11 @@ static ssize_t recompress_store(struct device *dev,
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
@@ -2597,8 +2565,6 @@ static ssize_t recompress_store(struct device *dev,
 			ret = kstrtouint(val, 10, &prio);
 			if (ret)
 				return ret;
-
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2618,7 +2584,6 @@ static ssize_t recompress_store(struct device *dev,
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2647,7 +2612,7 @@ static ssize_t recompress_store(struct device *dev,
 		goto out;
 	}
 
-	scan_slots_for_recompress(zram, mode, prio_max, ctl);
+	scan_slots_for_recompress(zram, mode, prio, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
@@ -2661,8 +2626,7 @@ static ssize_t recompress_store(struct device *dev,
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



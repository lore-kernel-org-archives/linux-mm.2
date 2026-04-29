Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1A4FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846DA6B0005; Wed, 29 Apr 2026 14:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7906B0088; Wed, 29 Apr 2026 14:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E65D6B008A; Wed, 29 Apr 2026 14:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 565236B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:55:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 024031B9013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:55:03 +0000 (UTC)
X-FDA: 84712495728.01.78D401E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 480EE4000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:55:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbX5eU1h;
	spf=pass (imf17.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777488902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=31n0og1/dxcJF7KY10Vv8Lw8nirerVCiMfZrG3XZkhs=;
	b=Vgk4xDc/75NbxSRZPJ90/HzkwpPZ5JDm3hRiXXmSJQNE2GWtAk4QlHo26sB6l+aKdkheaF
	sxCGDY0+K+5zPzYcdU/xe1YQ1zPJspxAL0x1SfE7o/pH3//uHJVrJ4M3OgGLd0kpBYVSoS
	PpqSFFqeAhSOzyCToYNc0gqoijEJIaM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbX5eU1h;
	spf=pass (imf17.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777488902; a=rsa-sha256;
	cv=none;
	b=iHnKAHMWXrqoSyrA2BraODAm9wgvmVoTgPJPz4fYgMjV0zAsZsVMowTp7GqJLMkctPB/gv
	FR0Kcd5jow045PjGT0QSRge+x10L+3SjGWyB9fBCPBaSHEFzqnU7ru6Bum45hXFq/3LFrv
	vCV7BCvpC78zZxsrlEmaPUm40OzFhXQ=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82cf636dac8so76635b3a.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777488901; x=1778093701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=31n0og1/dxcJF7KY10Vv8Lw8nirerVCiMfZrG3XZkhs=;
        b=nbX5eU1hJsDbFqP2X9EFX/zhpZts+6p7QNkBB1R+CtDcWQOnc225BMW2znLq/dj85i
         vHVUcukD2vJxsY6AqqO/ZVHqyjardInwjWKC8vn7PeyWCCG0I/tIWDRvrI2jduSkM4Ex
         naHBPIZG5SM1jvTAf4mFG08e9iuVemwRN89/Qv3K2rKXmPvp2IYJRqOJVGL4zkomJC5j
         QuqKsagO+cBS2zrPOTmx0XjOXuYOJVj93AVvXYqJuqaVc44hfZuwIWju6h5h5xcJ0MWw
         9JkZpvNA+TFk40L7tU9NacbOlhodxF0l90HHpCtB03FPIlmCPn/rCBtHmXFxLtfIv7v4
         aAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777488901; x=1778093701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31n0og1/dxcJF7KY10Vv8Lw8nirerVCiMfZrG3XZkhs=;
        b=PsOu01yCHJOokemxr+gozX9rg3vhqc/1oHYmfsKiKObEKMiQao2bC5DPMaz1+JH19w
         EqWBacBCeF+h7DtlMzCvMyICOgzK1cSsvvljbYODZda0L4YnmUAROujXOb5pe4bb2SXD
         1+9D+Fwo361t5NO3+HUn9X9+FtCxip7gsKd2pxoPfZ0EA0fVH7mVZouUvpwTccEpMb7J
         +672geHslS451MBXK0gqvWIrUVw3sx7fPAsQf2x5t5kDCyN38gdfOfWgURX83yARgD+W
         +O4tdxBsjBMNsOHHSJbDE1m07wjoOACR0pW8KffLUzrE8q0vxXwIE68GGgvDrQU4lgCG
         GdwA==
X-Gm-Message-State: AOJu0YxwB0ssPUz1gKGr7+lq7yhifXBZqIxXZlTs3edvBDxucw7AchwI
	PWEBdvUdqwzJrQQElIvEhjmjXYpNy/No3WVm6+CWmgkX34anBb0aTP61
X-Gm-Gg: AeBDiesQfReQAzwX9WYiP8O7cQnR3PUlQVsdfa7rTEt0NHlC5bP2W6N2KawjXjQmJli
	ptGlcJdCgEOKlud2YZwk/FJfFokrPqFmVrHnZyLLOTpsfm+yMBukQKO4jfHESjcHVKmfmxX+zjq
	LLNTBkitUsXKLlgsBFRdqUtPiKJ6FFGeRuRSzx6BPnIsKriPVtdHIHGgoaE9rqZE/FjxTHBFTrj
	7d8Aszt384wvfX4uCgeWtFrko5mTnm+Lsd1+s71dv36fuM2HfUYG1mztSUY2VaVJXLHYK5f8aMl
	DFTQV5CkoMQZx2itMxUWe+aLgObFp/KgMQyKu6fA2ayDzW1VMitb/SkOWePSgpgc+JYqAiN4oN9
	QcGXDWatyMcx3E9VPzH0ySqQ85NjH4oQRyyCXLNYakEiPeL7cS2LPZDbq+RKM4av+jtsbunYrLW
	7pKB/eRlAKCLw7T7xfEiSJ0sO4xsiU6zysqotkeH4J
X-Received: by 2002:a05:6a00:1ca2:b0:82c:e60c:f36d with SMTP id d2e1a72fcca58-834ddc93c18mr8123810b3a.48.1777488900900;
        Wed, 29 Apr 2026 11:55:00 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:3097:5ced:f23a:32ed:4b52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5cd3cdsm2683785b3a.19.2026.04.29.11.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 11:55:00 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linuszeng@tencent.com,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] mm/vmscan: fix delayed flusher wakeup in MGLRU
Date: Thu, 30 Apr 2026 00:24:41 +0530
Message-ID: <20260429185441.486804-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 480EE4000D
X-Rspam-User: 
X-Stat-Signature: m37g1hdsq3jztynkhikymoewnm15qa9h
X-HE-Tag: 1777488902-611854
X-HE-Meta: U2FsdGVkX18hh7I6R13UNp4e+VwTCsVP67JkMZs3EoMbvUbO2+kLLWv1fECiME41XG0upzy56yQ+3yCvhzjMP90T9w+XUcxF2cStNIrjpcyH1Q8gm6n1qs29EoY668n5ArKlKaLa+08LJ9dsvG6ND+uJaWqSxklU6ojxfyqubeSVwwRNG9YZs0Y+9/9IL0xwehPVm2N+Ip5tahFy+iLCD3NPNfdHwvKL7BACcSNr5E9EoUMwUuwuyomo3htQSqje++qi2l5rwBqvEgBuIJ+maKwECeLtLlzD8/zKQvjQh6Rquy6ULhS5eQI4sDz3wxDbSQzXlNuGMYwH0nfLdpgkLIWzalK6q4RYxyQ8x7v2+b+JaVTEvSkd8EaIM1+TS1K7JIVfhkfIRXeg0JAfYE0Fd1M1bVSCH86rAl6pbkyFtVcUtNWpKR0t8LdcOmS/DWfoFI/Vs5hipki1SYqlZp+VYAA7kZ2dmBfe9UlH+JAEEDz6WYugpjFUb26t11PBffEsjmTx2KK4fgQq7PBMzHiJe9w84tDra3w8B+KKChb+2JEHDZazcOkTrSvCihl08souevP8/gEvSfz87KUvrRehm67k53c3PUpnxCNCjf/ec2eRkvKyjRuhn6jPwCHZKfKzBnKwYpYqL0MfnUJZoL8cL/YrJXCCbh06W20RYFd9c1harzFiCs9fgjbErYYgkNvZzKHcuJ3rbf88RvkgPAAjpkCo1ZTV65pbmqGrO8MWk1hSrlF6m79yNH6k7Y1R3iFAPjL5RvKvaYXakL3GY3Zdged1GSjpifXHs3NPsiRdjxF07cDlD2wZFF/Jl9ZdXvZrFc32PG/QutYO65w+OT9RcX9gSSg6tSZMan95GpF84v0NU7zTQexiwx4UWqTtVtF9TRoH64LG8tchC8GK0cGUC6Ig0sZ/G2yvaUOGsEdDi4h6tqgkdmerL8BF4LSYKOcvWjZchy6ztiPV+F8xoHj
 w2L75Dks
 5GQdZ4UOaM4cCHlzdOYdJG/bw1rMFyJE9zRLMe8pkrNeme0uj8DjRw1dADrPJyNgaFTaFprgheE4tXq5vSv9qsKP6Yy9YisH+run6F72lDQrJHCzpzj79IVjKKAWYov22kzT6jDQtYccecNudzqH15JwqurEp2akdL4YhAsVFChvGpRR4qVxYZ/yc+SwDk3Q5X5aKxjN3NeUaOdW8khHPFmiHPOSV4svxCeBGE0o0UHA6O9ZwnTQYN8O0sVBJYtK0Rre3TvAo8/4R0DSQdjQYpMLKtS+mGw0lpDzZUGkaH5uhDnhpEa9k3LWSmfJE1X4ynPRyMBMQ0WZLl4pqBAmhbaaUD1rPnpIC3ndrhMkac7YxU2V4/4QU5ePkmVspNssU95PtJOaAJ9R3VMzK+77Z1+f5YwyIuxQchicepqFsT52RgIL5wYU4eYKwSe3wrQ0qcHtMxI+SF5vLCsxAmUYukUf9yr3kqVWLoKrXhUXUA/6aUg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MGLRU currently decides whether to wake flusher threads in
try_to_shrink_lruvec() using cumulative reclaim counters:

sc->nr.unqueued_dirty == sc->nr.file_taken

However, these counters are accumulated across multiple evict_folios()
passes before the check is performed.

This can delay or suppress flusher wakeup when an earlier reclaim batch
isolates only dirty file folios, but a later batch isolates clean file
folios before try_to_shrink_lruvec() performs the final comparison.

For example:

batch 1: file_taken = 100, unqueued_dirty = 100
batch 2: file_taken += 60, unqueued_dirty += 0

Final check becomes 100 != 160 and flusher wakeup is skipped, even
though reclaim was already blocked by dirty file folios in batch 1.

Classic reclaim avoids this by using per-batch values:

stat.nr_unqueued_dirty == nr_taken

and waking flushers immediately when the condition is met.

Make MGLRU use the same per-batch flusher wakeup behavior as classic
reclaim by moving the flusher wakeup into evict_folios(), using
batch-local isolation results from scan_folios() instead of the
cumulative counters checked later in try_to_shrink_lruvec().

This avoids missed flusher wakeups and makes dirty folio reclaim
behavior consistent with classic reclaim.

Fixes: 1bc542c6a0d14 ("mm/vmscan: wake up flushers conditionally to avoid cgroup OOM")
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 mm/vmscan.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..f9b6cc146a3d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4680,7 +4680,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list,
+		       unsigned long *file_taken)
 {
 	int i;
 	int gen;
@@ -4749,7 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
+		*file_taken += isolated;
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
 	 * remaining to prevent livelock if it's not making progress.
@@ -4798,7 +4799,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  int *type_scanned, struct list_head *list,
+			  unsigned long *file_taken)
 {
 	int i;
 	int type = get_type_to_scan(lruvec, swappiness);
@@ -4809,7 +4811,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		*type_scanned = type;
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
+		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier,
+				      list, file_taken);
 		if (scanned)
 			return scanned;
 
@@ -4825,6 +4828,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int type;
 	int scanned;
 	int reclaimed;
+	unsigned long file_taken = 0;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
 	struct folio *folio;
@@ -4839,8 +4843,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	lruvec_lock_irq(lruvec);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
-
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+				 &type, &list, &file_taken);
 	scanned += try_to_inc_min_seq(lruvec, swappiness);
 
 	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
@@ -4852,6 +4856,14 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
+
+	if (stat.nr_unqueued_dirty && stat.nr_unqueued_dirty == file_taken) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+	sc->nr.file_taken += file_taken;
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
@@ -5021,27 +5033,9 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	}
 
 	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
+	 * Flusher wakeup and writeback throttling are handled in
+	 * evict_folios() based on per-batch reclaim results.
 	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
-		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	/* whether this lruvec should be rotated */
 	return nr_to_scan < 0;
 }
-- 
2.54.0



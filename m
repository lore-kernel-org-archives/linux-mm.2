Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFD5C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB1F6B00A5; Tue, 28 Jul 2026 11:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882F96B00A6; Tue, 28 Jul 2026 11:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A7D6B00A7; Tue, 28 Jul 2026 11:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 324816B00A5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:59:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 961F1C03B9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:24 +0000 (UTC)
X-FDA: 85038645048.04.AF6A484
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id B373240003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aqUpy0bb;
	spf=pass (imf27.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdc520hStMu+f+3jSqbQBLlztrWg7wz8IxJRE68s3LU=;
	b=JjhBQNQUCq0IQIrkFR4TM+1jxsd91vCQSWzKoVz6yztHPNblCSCAt7mQfp9QyblXdWQd0Q
	c/HJAEFS8jZS82aRqw+Pc6L0YvQNmgUGeDTqF+SzOdPvcnlIN/gzi3lrp/peif3t3wlXSp
	8uFVW0POItyn71HGUkDTOnRb81iAy1w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aqUpy0bb;
	spf=pass (imf27.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254362;
	b=FraU4msFWKm8nlVqVyjkYCf1EfpSCHd3pE/Jxw4MC5XELlmKab5u6PkCgm7s8xbKMV0Zti
	chBMvZWoXgmf4GJk0n7hsUbrtfaNszIocKj4NuoDGAT1Gst2w0R8HNWVIa3A2dqS03GiRL
	pIb4CWJ1Ooy8HUTH+53KUEO3wjlsRQA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84874b52eabso14769b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785254362; x=1785859162; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jdc520hStMu+f+3jSqbQBLlztrWg7wz8IxJRE68s3LU=;
        b=aqUpy0bbL6NQx8A+VhyajGY3QJB7XI+pDl7cMcBUVKBEvp8xRsb3mj4wuqGfAih57o
         qHlaSZUMEIQ8pi/Zcz+t9ic/S8rz3OkkhHFX8nqnOGHIi2W2Y7WgacIOBMjAv6tFOGdQ
         i4SaRCp1NnMnUC/p4PjUuQDYwfXSSRn1oZkmXU7sOWwV/nwirPue1GoUoVEjlJ/PwjbB
         C39/GslhXVxt/J/7IuI4/pSkobNMuKRwNvt2Y1d7AiKkEZwKA001lw9RFkEpy0hTjXrk
         +EgWmhOmoLckEK7k7h2x8BiaLQdrVxEvtNusfkauOf8JjeqL9v1p4RKPIEDjJxxH22bs
         ADUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785254362; x=1785859162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jdc520hStMu+f+3jSqbQBLlztrWg7wz8IxJRE68s3LU=;
        b=DnwexS5VTMYWTvLjpSU9mC0sNTJI0zXQKjG1W2LluzmbbJmzODcP/rk9x1JjAyKhZ3
         C+VxInU7TksCpkKcu3i20k26/LBKbBtWJjoGeHZrUIUi6UKUEzVDd0rZYQJOZCQ4Woz0
         eaCCxKbk1QZ96D82vEMoTGLiszOlZGPxg16rhbDwAu+v/nL5mPDgsuWqbPtmTPM3LsL0
         B7MuhWAF7PMU20CZoorY993YXr6clrgZTWHByRDXBM/gRS2eEwAPoEy7N6XR0pKFpwyA
         Bfvfw7M1vfHpRj9iqEXKzo9FCmfJ/MSHssZZH2Y1Sqk//prNAipmm8VO9RDZwzO05FfI
         5CYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqv8hhUqAqV2YgRFXvG75qnTqsQu1/iJReB08CsxzkdcOXjO+7VM3mZ3wQaSxwkKfSRAVwwgeKRSA==@kvack.org
X-Gm-Message-State: AOJu0Yx+YjdRw5rcDhLmPuBRRbz0KeC1y2mp7sLTga3vWc6+8il4a0/q
	krqp9JuhV59g/9haFGcXdO4QdttC6TmuFAB3AIJ3KBb4N4RH3CFKJkmi
X-Gm-Gg: AR+sD10vYjl41i2KzQ74tlcJJYYJoqdsiPdwHkhy8MmbbseXl8SdqIJEaWC41rtpIsf
	HL8nGVhZpQVV8/xxjnwqAsYIop7CEH3p3gzidWEojFvFietaqMF2Y3bDEKRVwhCJmJQzqKhzw20
	Xi/venbOOQkFiNrLzFIW06s74UykuIJ9roYJpBF+VUVCGqZDDwkBO3kghnGwK05wi0RDoS/RSR8
	BeWZTgwXjcEN4qKdyeJQ4OqYuCy8y4ZjQVRCwERHY4AyeDRkpsztAJXd3h9tZTdXXlRqKPEwvyB
	Dy5zT4TUaodVYe5ObU518fOqX/7EeM8hQ8rdwnON52QQruWFIk1nkhREP8xmIAGUf0N/cNuO2s4
	RXKCEk7gFfrlSZ9QGtPr3QZTdsR+BlT7BPIrUgUFFfZ55HSIJ05gCFO7bIGNzRASrMBh8y6EH/A
	GJWhohTeCe/XZDFejHSqFJsJK2/X8XCRmI7VPGlvuiIHT9/+rE/X+C3rlX660NOE0=
X-Received: by 2002:a05:6a00:1d83:b0:845:4d71:8d15 with SMTP id d2e1a72fcca58-84e9331e137mr3522058b3a.37.1785254361511;
        Tue, 28 Jul 2026 08:59:21 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe2393csm156441b3a.10.2026.07.28.08.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 08:59:20 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Date: Wed, 29 Jul 2026 00:59:07 +0900
Message-ID: <20260728155907.391820-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260728155907.391820-1-youngjun.park@lge.com>
References: <20260728155907.391820-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B373240003
X-Rspam-User: 
X-Stat-Signature: 76cmdnsstgpurdukb9hofcp34cz8tkjd
X-Rspamd-Server: rspam04
X-HE-Tag: 1785254362-102225
X-HE-Meta: U2FsdGVkX1+nyYhvr5j7+c0lQ1df0v6e8eNKNrDWuIXjw5wmW9VfYKaYq58sgKfxmgsh9G8UPwJOrKEHE1Z0GyTAlVhr5OVQNhi65q4fH1SN53GY/B90FOfk3TeD9NpEm8IZ6SGxYlXaCMRCtJo4QE6LkMq3/4nzwWHURWs69q33LRItxSPaK8sifJbwJKhOw37U1Vajk0VI+E5QMijedvCOxFDxrF8I8xKV5vFVSJdeCz8MprPG+Oa3189E/Lr5gZ/8+06AmS7/renItetJF+dSTo/hvhb7phLU0mCdgvsh1el9mke4q5dzuGENCGg4aCYU5Ge+O+9toAkNOogV4WisDdGRiaQpGJsvclMXIml+Zdn8tT0JCuZMuCsFYzU+HbM8PnGJmo5NuvU5qc0OgahuR9iuh9QX8es8aqwXv2SZb4FvMolHvOplsr+8PCR/kuvIl8ZFUQgNgObVhyQz0lSgqfBEzKv3eucKohes3+wQt0ikYART+kgc7PCiMW450uAw2+bQXJxesV5pfPAcOW+n3jwpPnLt3Hcqe+/zH1V+/P7PVVp88sdkCl4GN9ABWX6a5CySe3IhaEVUHp4CYuzalP6ifgdLPTRhCZACwyQMpxhIlowF4mLumvfOWyjv70dax9mJ5mt+BxvZqdb0PqHXihXzFAfR3CQko0DROrS/aHH5AaZ0eKlkbUduI4VIB73TINcM2Rak/z1n27DRKaruJeLAugRvraBxHdW872spkR5tkiNsO2cNXAxRx8WZ9wQy3Qf5RSlDYv7CcMDpL/w0kuqjLuQyxIL/y+4l7qp1nWJPtMxHXx1b1oEocqBUfgrPSzcZZ7hKjTO+1iJ9kNRtEh2OfCouW9UMRwOLfbSAUGKbn9gaGqJVD82Sfw5b7iM0cEGlcRetWsUBIyUuxbj39mn3E2NyAYlU3Wwz4XdzwiCCor3EwoyRguMe9BVgvpXIjo4K4yOTBQuR5r4
 KYsMycrh
 G7oY5e0E8uwQok9+q43a5UxBzumJuCSuX/tySNKeLn+larlu1FAfrcH8spBTs951SbVwicKQmbxOzi+eOAN7kg23RqnxkJ0gR8kS+2E/mE/OoCRIKCdUeAhmnGOVuj0k8gYpjCpGIaEPAjHgBwahs+YSpohot0GNmmvGbC7TYfN5Bb0dxu0k3wvZAXuHFuDR79I1E6SQVUE7XI5GIEMjnXgXZ+H76fD22aof0x9cOEN3hYP+hD8b0WuPbUewHr9g6DNGV0Y+tYo2m6SrGMJMswmdCVAgs56eIC7FcIXt82JeFqgG4M9GBMdYE1TRTTS4MDIjmaA0KagfUVlzLlxGpsc2xcwdyAhMkVrhvV/cDsQiSXxFk/B8zku2m/jX4O1tg6xuqoMYBkTBOM1r5PnL6GoLeyJWXREgrkYRZqZj/z+CHfRJSOJ40F5zuYq8F0wEIKyHE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Youngjun Park <her0gyugyu@gmail.com>

From: Youngjun Park <youngjun.park@lge.com>

find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
restarts that walk on each retry, so the cost scales with the size of
the device rather than with the few slots the shmem and mmlist passes
could not free.  It has caused stalls before.

The flat walk predates the swap table.  Slot state now lives in a per
cluster table, and wait_for_allocation() stops all allocation before
try_to_unuse() runs, so a cluster that holds no slot in use stays that
way.  Skip such a cluster with cluster_is_empty() instead of reading all
of its entries.

Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
answered those stalls with a cond_resched() every 256 offsets.  A walk
bounded by one cluster no longer needs that counter.  The loop now runs
at most SWAPFILE_CLUSTER times before it returns or reschedules, the
same bound swap_reclaim_full_clusters() already scans between
cond_resched() calls.

cluster_is_empty() reads ci->count without ci->lock, like the rest of
this scan.  A slot stops being counted only after its folio has left the
swap cache, so an empty cluster holds nothing for try_to_unuse() to act
on and skipping it loses no work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d15913dcf86..230abb276ceb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -370,8 +370,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 	}
 }
 
-#define LATENCY_LIMIT		256
-
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
 {
 	return info->count == 0;
@@ -2763,7 +2761,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
-	unsigned int i;
+	struct swap_cluster_info *ci;
+	unsigned long i, end;
+	unsigned int ci_off;
 	unsigned long swp_tb;
 
 	/*
@@ -2772,19 +2772,32 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * hits are okay, and sys_swapoff() has already prevented new
 	 * allocations from this area (while holding swap_lock).
 	 */
-	for (i = prev + 1; i < si->max; i++) {
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
-					i % SWAPFILE_CLUSTER);
-		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
-			break;
-		if ((i % LATENCY_LIMIT) == 0)
+	i = prev + 1;
+	while (i < si->max) {
+		ci = __swap_offset_to_cluster(si, i);
+		ci_off = i % SWAPFILE_CLUSTER;
+		end = min(si->max, i - ci_off + SWAPFILE_CLUSTER);
+
+		/*
+		 * An empty cluster has no slot in use, so skip it whole.
+		 * A slot is uncounted only after its folio left the swap
+		 * cache, so there is nothing here for try_to_unuse() to act on.
+		 */
+		if (cluster_is_empty(ci)) {
+			i = end;
 			cond_resched();
-	}
+			continue;
+		}
 
-	if (i == si->max)
-		i = 0;
+		for (; i < end; ci_off++, i++) {
+			swp_tb = swap_table_get(ci, ci_off);
+			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
+				return i;
+		}
+		cond_resched();
+	}
 
-	return i;
+	return 0;
 }
 
 static int try_to_unuse(unsigned int type)
-- 
2.48.1



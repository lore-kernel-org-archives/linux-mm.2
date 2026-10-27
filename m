Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB870606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tqDH2T/u
Received: by kanga.kvack.org (Postfix)
	id EF3606B080E; Tue, 27 Oct 2026 12:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5A86B080F; Tue, 27 Oct 2026 12:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94C16B0810; Tue, 27 Oct 2026 12:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6CD86B080E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:07:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4868540A03
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:07:37 +0000 (UTC)
X-FDA: 85368886554.14.D568560
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 650E34000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:07:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="tqDH2T/u";
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSD8mQKziZ5iG8e21wmE1nbLrwweoqqmHmBdVdKDScI=;
	b=pq6aGblj5oKQOPESqHCPs2orYXKVoexAJEWeT0zhhAayLCE6bCQnP8RH8gU8kTFRO361Q8
	g3KMBUA0Mkdy/UBzffZVq9Uml/V1e/fG9MzKOJyHU3+ddeq3AKOa8773YiO9mU6nhwi76+
	vOXtKsFJu7lxDp5TviDHGLVyNEv4HLw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="tqDH2T/u";
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117255;
	b=wDjecQ1Wq92tHHaDurJ6TqMo6SIMkA/Jk32KPQW0++vSm3+JwXUR71C9l0lGG82dAqAY+z
	Oonqjm01iZxWJAGMt0q3GGndy6ixzofjGm21YjrmLs3CuGFQ7wkW8jeNLU14SfpcMXVDfd
	JXZQHIa624akHktq/cMbCo/4oet8iGk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso25747195ad.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117254; x=1793722054; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gSD8mQKziZ5iG8e21wmE1nbLrwweoqqmHmBdVdKDScI=;
        b=tqDH2T/uqIv+lfS/A+MVIxHWOGV7r7ThJV47hOomIaGLZbIzZB3L+dAssvBf2AyW0B
         En2cSJYPYIuGbqE2Cu844TqcV83qcOcfbl/qjjMbA5Lo5bkGBsgzPG8/EftHWz/yueDz
         rWiOu9j8e34KKAf3VSX9U8fjfka299F6GbfetTaPBGyohXsc+bGonCIHzk7o+793F3Fu
         1/lTX03vQ5RTvwdvjBuHZvegMdYR7E6+3AL1XVA9CLTbbqC2iBYCUY0GXyVi4uNR7k5u
         s9eywBy16gdnV+LN4vThZiG1AEuGTAjKhRG8IWkIzlF9tcyrGap0qGKoDy3ekDqAuh+S
         f8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117254; x=1793722054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gSD8mQKziZ5iG8e21wmE1nbLrwweoqqmHmBdVdKDScI=;
        b=yyDwHXRUmtPYEKPT2nYETdUBY9XpSfqAHQP3jnssWqCGjkPqFItqBzjjH/LzQeEI6S
         awwRXiTkW/ZDtHTgvJDE1VGj7u7Hob4XXTiaK6U7vV4rM7uOZ9waq5SGn/mCXEbNpnM6
         09qXhis9L9TvJxjSZ5WuGJMbhcnXmQaIfVuCf4gaEd88X3PFcks5Q4MA2c8a+Evrw+Pf
         e+4/iT5CN1qvyTw9dGh55knKfzXYypZonaEqCKSa+4DrrGhtdO9aOEF5MQDVjC+XixK6
         mIpRi4GDlk6++1sOBuyKysMHinM+JloHamo8U7P6Gbfl8D5+Pkc0icA8LuYgO/A81BQK
         cseg==
X-Gm-Message-State: AFq9FYL5rH8dFwpkLp0W0VIrWxUGK8sB6f9Okn+Q6qSXr4OpU9rQaRyN
	BatPY6Xin3GV0fc/6Hs7QcbkziaXSb6iuQtpKYtzD/TofxJPYvFdZz9lIOQ/6w==
X-Gm-Gg: AYBFou0OtTVJsS6nDgXQBUfgm8kD2XHFW0YhxRMcMLAnz30stA6pQ/iCVDy+bahfSM/
	DBJqwnfQ7+fMFG+nQgf+DvmamM573wV1MntA1aIWTXc+VbDcmxhfqT5N4PT8Szp3+3w6FarX9fi
	bvGhQW4g2SsW7yd23izpvKVZClTQq3ncZVQolwXU3OkHFoirsV+DhyCi0EaCwc77ev3lEyCcA1l
	gRI2iWwqaRWLz3T7X5y444oHtfFDcdKoeb7UUF33h5K4GLO+Nu24mcVne85frB6nSeOzrtbjgyv
	MUlN1e2mdNoEGAt0mBKfABcx/U3IVK8TABp/Yj5PtEhI11qMCnMy2uRT76Lo3b8hlyGy1cJup6m
	anzzalmqa9WGLUWkL+wrHzGyIZxNOVo6IAEmqVTSbIyUcUzlqkblgE+p+/mKR2cdTPn2VUbjj0l
	H+iugSh6K8dSh3JpwV5QjgpO9EyzyYmwJA8R1Y0SlQ0qR/GUfcDvPGFluvyeEzqS4lL+VVHkSFo
	K4b/q4z5mpynhDdZ5rhFmxGajNLkFy6Co4og4i4R+JhBPUf4OeghXabyBsD0TJejO9SlUIYa+oJ
	MAJrlK7tihjcBu4p0h9qDcQP8zyx5mOJ4NXUfHa/O5gAelxiSr3NW6RDsRXyy8aAyhTy
X-Received: by 2002:a17:902:e807:b0:2e5:54c6:e5c9 with SMTP id d9443c01a7336-2ea9c0c8abamr89571955ad.2.1793117254204;
        Tue, 27 Oct 2026 09:07:34 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6453e90sm12368675ad.1.2026.10.27.09.07.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:07:33 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 07/18] mm/swap: consolidate swap inuse accounting helpers
Date: Wed, 28 Oct 2026 00:07:09 +0800
Message-ID: <b4951109ce21e1b53e4f339142ffa15b9b0980c6.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 650E34000E
X-Stat-Signature: 59qhgzbm7ub8sea7997s5qj7ibpt5gn9
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793117255-268434
X-HE-Meta: U2FsdGVkX18/Aj/gf9S/qvWGmZzSygc/z8ek98G9p7miQRGQ0q6kl910D2cP9rrsjeqMNQQZ7rcg+DvS+zY4XBlWlM2WBeeFfaaXBYz10OBy1V6NvQKYU0U8hnUIW96ikw03j76LZjWj2LiYld9U05NyMUw2tYJRtUtomxGU7S2OffVTgq+ddLqA5CTG+v40GrFj3HJLHavwAEpkihDOeCzHeTXSEJw5qq0EjtQJowr5U03/XQ10qP8dIJID0HpAqUEnsh/vgzP5UWlNV+xsdYTNLytXyA6Arsi4WKnujmOrwUtAisC3DbsgyjeDvMvXIv7yFOgbFnbKilif6FwZ/rtnbYitzQqwSIcRgp3OoiJul7FxpRVdsmM5Zu3qKnv5/t1MwB3BHF3Cr8BGmYvRZC9rsE1mIPxyNdMPq13w9baE9LMGcwJ8VH31ZtrRBaSLjOftTzlA1XNBWrAxRODn+nnsXgWOFE73ri18ZeHP+usxQ97x/alUHGSRnG6p7Ij1+8yOT/15IxcEnVhw5OfUDCMp+Wxw1WUQ6OsAU4FgnN5ONewJr4Kb3MefjGCOQ+L3PbGqM/nG7uo7J5/b3Gg/5H8FBS1fCBaZxr5U9aak7vTHhuoqYXYClEfk5TmqjoFmN0bb65B0f2uuDps2S3FDX/+tEdVFPZJtkjfa5Af3QWamnoCeiYxYbADZE/82PyhdA72Cvx+AhOTbonXgpgwzMKHM7uQIJR/XsM4zNV3uyx90kb1pAmxw8a1nrK5OzJA0d3HwRlv/1BhymyzTKSZYW5E29gKtrjfvR19aj2SNoqNDuO3qAhJEPfsMPOnyqCOCDx+seHI39z6LKG36mHC+CmxZOwF4gpQVRqi0hPG0eN21ISwHY7IOg2S+yLkmG1MtxlWMq4buAR7ZX1iL7eu2FwAmzluImZWY1O9T7LDz2Z8PwF5uobIxAlWy6OHu8VgL5f26ylktkLZ59hGKNMV
 VBLzYiX7
 zrLOV20F3BEo/Kv7bXdma171KSVKlyyFIczOdcyQ4ofW1wDStvuvNDGN8RiI6LRoSPVoKpdu2CiRAzhA+1KXb/Z0L6U8gDUxFrli9Vw8v7pu5kD/eQkNh4saRrTTB049fZrowIvG9CPAkjftxOds9os/YDzfEAYbYN3UaqziLpH/h+vlV+gP77fbRaK3i/7amcP6r7+uzFX46sNuXqH7zr52oE37M25Z4SsHm15xLAk+vS3bTQEQTR+XUDV2N7aR1xy7WQB5cYSi7ePANtODGOFJlLSvlhFyf1chp5/jlGKmmux5KR+2K8GFPOaDqdBNiRdDEPsUoFVw5UpmfzyCM3edOtYDdT06Q1VLq3MmpL/izaBZbe3T04JBuZAOUP2sUlxZ4EW/BvDq9QV1RGY3BY7Tw8JWZaMlvA2h4RMkkEEYBkDCo/gD9mELTvaZdzAXy785ANUEf2GcA9+ttjfBkLlZa228grhMAh3i7USky/eEWCXFq4cB4PRaSWjui3s+HUA/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Inline the swap_usage_add/sub helpers into their only callers and
rename the callers to better reflect what they actually do: track
per-device inuse page counts.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4c10e4a2d9b3..c531e0c45073 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,8 +49,8 @@
 #include "internal.h"
 #include "swap.h"
 
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries);
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -992,7 +992,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
-	swap_range_alloc(si, nr_pages);
+	swap_device_inuse_add(si, nr_pages);
 
 	return true;
 }
@@ -1300,53 +1300,36 @@ skip:
 }
 
 /*
- * swap_usage_add / swap_usage_sub of each slot are serialized by ci->lock
- * within each cluster, so the total contribution to the global counter should
- * always be positive and cannot exceed the total number of usable slots.
+ * swap_device_inuse_add / swap_device_inuse_sub are called within cluster
+ * update critical sections and serialized by ci->lock within each cluster,
+ * so the total contribution to the global counter should always be positive
+ * and cannot exceed the total number of usable slots.
  */
-static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries)
 {
-	long val = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	long inuse_pages;
 
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
 	 */
-	if (unlikely(val == si->pages)) {
-		del_from_avail_list(si, false);
-		return true;
-	}
-
-	return false;
-}
-
-static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
-{
-	long val = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
-
-	/*
-	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it to the plist.
-	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si);
-}
-
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries)
-{
-	if (swap_usage_add(si, nr_entries)) {
+	inuse_pages = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages == si->pages)) {
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
+		del_from_avail_list(si, false);
 	}
+
 	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
-static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
-			    unsigned int nr_entries)
+static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned long offset,
+				  unsigned int nr_entries)
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	long inuse_pages;
 
 	zswap_invalidate(si->type, offset, nr_entries);
 
@@ -1368,7 +1351,14 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 */
 	smp_wmb();
 	atomic_long_add(nr_entries, &nr_swap_pages);
-	swap_usage_sub(si, nr_entries);
+
+	/*
+	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
+	 * add it back to the plist.
+	 */
+	inuse_pages = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
+		add_to_avail_list(si);
 }
 
 static bool get_swap_device_info(struct swap_info_struct *si)
@@ -1994,7 +1984,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
+	swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
@@ -2935,7 +2925,7 @@ retry:
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
 	 */
 	smp_mb();
 	return 0;


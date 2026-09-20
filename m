Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FA0C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED46B6B0099; Sun, 20 Sep 2026 03:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABE86B009B; Sun, 20 Sep 2026 03:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AC96B009D; Sun, 20 Sep 2026 03:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C27896B0099
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F8901203FF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:25 +0000 (UTC)
X-FDA: 85233294930.13.267F983
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B1401C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qiF2bphezJ2REt412t1Y/8MB/k4qCStrt3zwepMw7NE=;
	b=n84EmIVD/K4HkiYUHr17ENCRKgQ8BVR+crQVvMR6zK4MPIc0bIy3RaAa6/cHCcoXrw+Am6
	ETbEfl62YHmckME9AKFQgEoZ8oNuaHic54wLobSPiG3b7pOWZUQlkGl4l1w1ZfCIwuaF5h
	l4Fp2ip9MhvI3UuSdlogAgwEPGY6MFk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888883;
	b=xLgqsVqam+7rg8zoAdEK/GafhPfXpe+7VV0Bt7VHf2FRL8WZcxAO3ogo8LdshBw+YhN2JD
	/Am/YBQOjL9LUt604szuauhqFKPif65D6F2HYCwxlNY1lhpeLSUJu4puQDhHbT3KbWHHHG
	6T4bXk1yTWJ9QV7C+R8Rs/U5gJk3qJw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3a65affa8a6dcba8;
	Sun, 20 Sep 2026 07:21:22 +0000
X-Mizu-Trace-ID: 3a65affa8a6dcba8
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 05/17] mm, swap: use the xswap physical backend
Date: Sun, 20 Sep 2026 15:20:31 +0800
Message-ID: <20260920072043.430390-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B1401C0002
X-Stat-Signature: 5kqufbftdtjrem4taq9qep61ube8z6qs
X-Rspam-User: 
X-HE-Tag: 1789888883-246072
X-HE-Meta: U2FsdGVkX18Ftrh9aGsIpXTAgFvfOgH6gukUCxSRyf5QMOBoc2QvvHQJrhEdK3jsG6IfWGV/vR06WS2m1ZPzcup6abbafPpHRHRBkF35xepETty3kDzOfZ3L47PxHoI8XrCUFnrhRKOGrx755hDsapAXhUcZs9Q/JqKAVmCI3QSZbiDkOT93vUa2GRjtwObzoDEmmHi+Jf7+QVhMApOdDL6hTXUmYPPwvFkECVnRzv/x7bMAjAal50IiZrEMGMI4OFuWgus8V6sQC1XZvzqzl9P4Q6AQWBKRhBaOHxh1k69Pcwc0OlMzyi6XYHIQmyVnR0b94HpcWfZqj2ctuJTJPsvvOmJrv4MXU0Cd4/nxMZjdY8qvrZ8nfNzVGk+sBomusHuhuUNVdwBIhOU0EaY/Bpi7iymrt23GFEXZlHZYQ6Mjtr3gkoy2+FLG0HDiRLIPRGZ0Ymalmfl8YOAgR04twIJ5WLWaFVFKjgssLjCioHuL8WDqA7GCiJmiQPlcM85xS77KYr/yCS7XC3zBamL28jkWkrSK3Vj0OhJ49SWcvRj/W/3yIb9zlGfeMFzc69ENKuVfdo3RJkN0tijj6MGHhQtzxbm706dScxhLI4YQ0SzjNn5eNAXPSHWIDl27pR2YlUhmVCeDJdN1+So8EH3WMruu2nhUZ4MnO36AQ7DhRUx/EcPk/YCQVCuaOE1q2Z/VFzurYzE+92Xi9TDndq4HD7wyCj2/5Ug0rtI8LagRuJsxnEruhDhd37usqkLEHylXK9Gzs1jh8nlpJKgNvxdkD6r37bucBsI2vzgnWX1DfqZ0+ql2WJ0htjS+NBdU30OpBsYXOc94IClvcBVVb3jdKTAuv/Hc0NT+XPR5m597Vtw4kVqD73L+RsBcT4tAr0t2bQ5CvvmTTjhJ/F6VNhzIhCIgEqemxcsVGXSc/oMhppkCdNgNZ8MbJST3kJRXy2bNOlOT4XIRDMdyJGeB/lW
 o7jgODXt
 7AqU1O0YP5VEy1s0uC+UdgPEp3DZ8IHBg7ST1SOHTSfa68HgFuj+mnsNCwVbSNQJr7utlL3i9J3/oKl4FrcsuSUAjhM8YO2ZU9OePTTYO59wlfaeFSIUhNh8Ufavso2hsSnEkUqObITZYOHLl6GZwLcE6Mru0LDCMybEJN2MoGd84lXMMU0LAvFnjxbViaaVOb6t8LySjxeNQFl2/6Xrup+zUwSXy1gpvO6m2RiTrtqAgBDF89lOiLGKe/PdhCI5+9cv7G03igGVMMo0/fQaWyxC5rDhHiBlWLlqFwLoBL33+veM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap entry that zswap evicts had nowhere to go, so
zswap_writeback_entry() refused to handle it. Send it to the physical
backend instead.  Reserve the backend before decompressing the entry,
so a failed allocation wastes no work.

A slot that was written out no longer has a zswap copy, so
swap_read_folio() forwards its read to the physical entry rather than
dropping it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c | 28 ++++++++++++++++++++--------
 mm/zswap.c   | 20 +++++++++++++++-----
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 2b1387c87e51..32e426779dce 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -463,6 +463,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	swp_entry_t entry = folio->swap;
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
@@ -492,18 +493,29 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 		goto finish;
 
 	if (unlikely(sis->flags & SWP_XSWAP)) {
-		/*
-		 * An xswap entry only ever lives in zswap, so zswap_load()
-		 * must have found it.  Unlock and let the caller retry.
-		 */
-		WARN_ON_ONCE(1);
-		folio_unlock(folio);
-		goto finish;
+		struct swap_cluster_info *ci;
+		swp_entry_t phys = {};
+		unsigned long offset = swp_offset(folio->swap);
+
+		/* May have been written back; reuse the physical read path. */
+		ci = __swap_offset_to_cluster(sis, offset);
+		if (ci) {
+			spin_lock(&ci->lock);
+			phys = xswap_slot_backend(ci, offset % SWAPFILE_CLUSTER);
+			spin_unlock(&ci->lock);
+		}
+		if (!phys.val) {
+			/* No backend and no zswap entry: data is gone. */
+			folio_unlock(folio);
+			goto finish;
+		}
+
+		entry = phys;
 	}
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, folio->swap, READ);
+	swap_add_folio(ctx, folio, entry, READ);
 
 finish:
 	if (workingset) {
diff --git a/mm/zswap.c b/mm/zswap.c
index b4ffd6fb83eb..24904b4c4dce 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1011,6 +1011,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
+	bool is_xswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1018,10 +1020,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
-	if (si->flags & SWP_XSWAP) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
+	is_xswap = !!(si->flags & SWP_XSWAP);
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
@@ -1053,6 +1052,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
+	/* Reserve the destination before dropping the zswap copy. */
+	if (is_xswap) {
+		phys = xswap_backend_alloc(swpentry);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
 		goto out;
@@ -1073,11 +1081,13 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio, folio->swap);
+	__swap_writeout(&ctx, folio, is_xswap ? phys : folio->swap);
 	swap_write_submit(&ctx);
 
 out:
 	if (ret) {
+		if (is_xswap && phys.val)
+			xswap_backend_free(swpentry, phys);
 		swap_cache_del_folio(folio);
 		folio_unlock(folio);
 	}
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC58DF8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170A66B008C; Thu, 16 Apr 2026 23:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120B16B0092; Thu, 16 Apr 2026 23:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0103F6B0093; Thu, 16 Apr 2026 23:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E05496B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79452BC714
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:25 +0000 (UTC)
X-FDA: 84666645210.02.F4A22AD
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B22DB80008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B93nttDD;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776397223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9AobA3Z4Rd4ojmq7cfWKU+ZkIrg4qqvBUWzGO8bbik=;
	b=vBmg6tBWFtW07rurXPmrPUllZlu9NvOrwlJZaGTGrg5xqrAp/qZjWgi3/WxCKhUOxGmuOl
	jFl+P6abQk0j+NSXc34gyNFF1cmFZtQ/+NmUVE6k9WssAfK1C0nXmnrnRhLHjyDDEVt+Kd
	Vf19c4TpLmG/Jpw3+z9zbZAD+wr+Sdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776397223; a=rsa-sha256;
	cv=none;
	b=x6TZbv6Q7Zv5p/1/2USieRWMrm6xPHFNlAyuD//2jnGg9euP5Wetv7n2XiJKM4VH6xK9/V
	FS3hmwKESdH5DG9Z1dke66sdeHX/giEHEu0WDnN7vLck1Iz6LHDuIHcIMHP1gUKdoVc/Ek
	F0lAg8Yy2P7jbBl3INBq4NtlkqoAkEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B93nttDD;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776397222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9AobA3Z4Rd4ojmq7cfWKU+ZkIrg4qqvBUWzGO8bbik=;
	b=B93nttDD5CH6IrZjdWxFJ7z5PAxXKUabxWlNb6hm3n+LNpXFl/TB44wNf2okEAL0sfldkv
	bB2D7FJmEyLQpFSJxJh4H6DCNJv6/G/wyE57Tzc3RObNiDcPQgsIAB04BrtkbCLkiNpkpA
	Xf4NT4Lmdvs/cwtF7aHDDZygIgc190w=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Fri, 17 Apr 2026 11:39:50 +0800
Message-ID: <20260417033951.1111038-3-baoquan.he@linux.dev>
In-Reply-To: <20260417033951.1111038-1-baoquan.he@linux.dev>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aaq7wagk6zzfuxq33krdw1bcyaz7gxty
X-Rspam-User: 
X-Rspamd-Queue-Id: B22DB80008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776397223-137725
X-HE-Meta: U2FsdGVkX1/NzOx2EVBqk/eXz+86MS34tFCGxEDMguRmOeHLNW+c+Zj3f9HfGsAiZXykmnxsLzlLpiHp+bN82uqufhjETvRoAI+Z5OxFsD4fN1SFprGu1RpSZ3AEOi8GMJVmIqoZK6pY8ieCNkcyTjKL2lhQ7dEve0clostu/QL/8zcsYVOVHUpK7C2+bju2SaRqpG2F4OmI+yAZrcSiqgO5ug3YFzTzLozPfO1pcOHWXTT6eXpiI7+THMOl/KWyinSSGtll40yt0FNS6oXog8dhqtxbMVhG4nY71l1NPXnv56EC5Z49hs8sQpLhxXzGZE18DVGgs1xNrSkWtrUmn4zKDy8wuqrXMOg5lTjj9iM+Fp4JyEe+s5wrXrUtRVyBxKvZbgDA9XSHfdR5/bjYSgBaqtRnSgKZ+ge9pYgW+MTbxYvijrKexVeGWosjzSMz/h3tPoaPiuKnUPArYyp684pQpSZL+VaQQLT2YcL1eIPMOfDV5ge9Yu/WQyK7hUA3RILO+qOImAbXvq0Y6CCJGMHF/5TnFxWac3qRJ389uuvwNlDJaCIgEqJaebuhGonuPmFSil9FF9uGfBkbOWV6lNf3cYm9q0d1J9TUkGHB5Wgh654GAcs72fEzGMd9KZo9jfH8mz5FcN6qYD/QMxCiBxs9XQNwsh8AaoZ6TEVl3F1aF+maxmNKdh8Zxm6b3veDFOJVjh379XhIGOIeDgzrHUh6iXd2VtHIHOrBTvxLbdpBPWEsX4WDly5Ldnh9zdehqK0QIAUuFrVFXBpsinLSvIgekDfwMzXN5fhbcGX83JEjgZvdDqX0oZOodTQBzsXznkN18h1IPpPLkfVT0UnBP42vV7ybAlGyKieYizrZNQlsIGTKyu/VpLTCVoklkPSQe0W4bkx5vOA6aVsfZjTkr3g/YVC2TMP7CxmkdNhHtwrhcaHzBi+qM4OV2B8emmyhJ5u/Qg2cOejQ0Sz2sbD
 30kqQz9o
 MgZxPaFQr/WFRL92lHyTXRg8FWfEZ8Gg5OQbKl9U3TJ4Q7aYqkx4eQAO3xNjFMsOtX4FpQenrVS/NnhTA1g6LAJfLJMyslQy4iUZpGExK0qC4YV1JB/Q2MmVlFphUySgWwysR5DEAoJk0s8ocZQqLMkBWQckNbc6MZCuJGc2Hm0Uki0eHLnVJKn5A9W0pRtaylmcaBkSp8kV62C3ATDsR4mkByazzFHTAyVZLZA1jDrx0S8S//tKmyWvaXITt3H8IY36NqC1zHnym0yz50wB/GicDm+j0Q+aO7Xb6mXeXAyj5vKaWjE+lzKI/PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This simplifies codes and makes logic clearer. And also makes later any
new swap device type being added easier to handle.

Currently there are three types of swap devices: bdev_fs, bdev_sync
and bdev_async, and only operations read_folio and write_folio are
included. In the future, there could be more swap device types added
and more appropriate operations adapted into swap_ops.

Suggested-by: Chris Li <chrisl@kernel.org>
Co-developed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   2 +
 mm/swap.h            |  10 ++++-
 mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
 mm/swapfile.c        |   5 +++
 mm/zswap.c           |   2 +-
 5 files changed, 76 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4b1f13b5bbad..5fdda26f5c1d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -242,6 +242,7 @@ struct swap_sequential_cluster {
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
+struct swap_ops;
 /*
  * The in-memory structure used to track swap areas.
  */
@@ -282,6 +283,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swap.h b/mm/swap.h
index 161185057993..29bdc679fa98 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -217,6 +217,15 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 /* linux/mm/swap_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
+struct swap_ops {
+	void (*read_folio)(struct swap_info_struct *sis,
+			struct folio *folio,
+			struct swap_iocb **plug);
+	void (*write_folio)(struct swap_info_struct *sis,
+			struct folio *folio,
+			struct swap_iocb **plug);
+};
+int init_swap_ops(struct swap_info_struct *sis);
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
@@ -226,7 +235,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_io.c b/mm/swap_io.c
index a62c02ab0551..1b054a122f53 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -238,6 +238,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	if (folio_free_swap(folio))
 		goto out_unlock;
@@ -279,7 +280,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, swap_plug);
+	sis->ops->write_folio(sis, folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -369,10 +370,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
+static void swap_writepage_fs(struct swap_info_struct *sis,
+			      struct folio *folio,
+			      struct swap_iocb **swap_plug)
 {
 	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -405,8 +407,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+				     struct folio *folio,
+				     struct swap_iocb **plug)
 {
 	struct bio_vec bv;
 	struct bio bio;
@@ -425,8 +428,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -442,29 +446,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-
-	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
-	 * is safe.
-	 */
-	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, sis);
-	else
-		swap_writepage_bdev_async(folio, sis);
-}
-
 void swap_write_unplug(struct swap_iocb *sio)
 {
 	struct iov_iter from;
@@ -533,9 +514,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
+static void swap_read_folio_fs(struct swap_info_struct *sis,
+			       struct folio *folio,
+			       struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = NULL;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -567,8 +549,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 		*plug = sio;
 }
 
-static void swap_read_folio_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio_vec bv;
 	struct bio bio;
@@ -589,8 +572,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+				       struct folio *folio,
+				       struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -604,6 +588,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+static const struct swap_ops bdev_fs_swap_ops = {
+	.read_folio = swap_read_folio_fs,
+	.write_folio = swap_writepage_fs,
+};
+
+static const struct swap_ops bdev_sync_swap_ops = {
+	.read_folio = swap_read_folio_bdev_sync,
+	.write_folio = swap_writepage_bdev_sync,
+};
+
+static const struct swap_ops bdev_async_swap_ops = {
+	.read_folio = swap_read_folio_bdev_async,
+	.write_folio = swap_writepage_bdev_async,
+};
+
+int init_swap_ops(struct swap_info_struct *sis)
+{
+	/*
+	 * ->flags can be updated non-atomically, but that will
+	 * never affect SWP_FS_OPS, so the data_race is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		sis->ops = &bdev_fs_swap_ops;
+	/*
+	 * ->flags can be updated non-atomically, but that will
+	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
+	 */
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+		sis->ops = &bdev_sync_swap_ops;
+	else
+		sis->ops = &bdev_async_swap_ops;
+
+	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
+		return -1;
+
+	return 0;
+}
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -638,13 +660,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
-	} else {
-		swap_read_folio_bdev_async(folio, sis);
-	}
+	sis->ops->read_folio(sis, folio, plug);
 
 finish:
 	if (workingset) {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..af81fa212f1e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3518,6 +3518,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+	if (init_swap_ops(si)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	nr_extents = setup_swap_extents(si, swap_file, &span);
diff --git a/mm/zswap.c b/mm/zswap.c
index 0823cadd02b6..b699413a2526 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1061,7 +1061,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	si->ops->write_folio(si, folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
-- 
2.52.0



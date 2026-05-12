Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E441CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFF06B0095; Tue, 12 May 2026 06:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6F06B0096; Tue, 12 May 2026 06:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED006B0098; Tue, 12 May 2026 06:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE54A6B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:42:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C43A8C791
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:27 +0000 (UTC)
X-FDA: 84758428734.21.D99410F
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A219C0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5eBltfk;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2j1qUAZVyouu0JkJWti5wQaqLNp7X4s2VzEYi23lW8=;
	b=NP98Cny3DT1lDII8l9NyUo2MhJvfyHtwC4kZO37NXR3KXGFR7/fLf9iRoYIjsuO30NwL8G
	4jBSgGCvCDK2nF4Pb7laFaOBkPKx4ik9j3ebFIUs5CN7MS45RJmxLnQJdPem1D8OTQWK3+
	JArphs+ELI5ngO7oFR0WWv8wL7zYtDw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5eBltfk;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582545; a=rsa-sha256;
	cv=none;
	b=svfeKe7IKHdV7hQmyU+DmUJsr56PLOc+T9C7N4XeCmsysdQIauf31TxvXfA3sy+21teso0
	Y2AYjMC+J+215AezBfUeDnIniY1kVqNvUmPC8KNnERHoZJzQ9/QDmujRDdlF3+4s23kK5t
	i+qf3UklFR0ddXcN/ehRdvUKR3UfXLA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778582544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2j1qUAZVyouu0JkJWti5wQaqLNp7X4s2VzEYi23lW8=;
	b=f5eBltfkS8d+d9iJtUvnk6re1hfqHc6W/UuKelt5rv8HK9dvTTKHxU07Bqizvs+bVNussc
	5jbkgNmGmHGIeH34gWCoRTNfP9F1lgB4dVBni5ZHk6CW6u1+14yOScG7x4ylSb78CEby+3
	wwfGjIU0BC1aYK00DJ1IBUqj6O51WAg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Tue, 12 May 2026 18:42:00 +0800
Message-ID: <20260512104201.716213-3-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-1-baoquan.he@linux.dev>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A219C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: ye51onr65r69t5sae8bfg6uy4gkj7dtu
X-HE-Tag: 1778582545-759870
X-HE-Meta: U2FsdGVkX1+9UgYoIQeh+YG4P0y7duIWYPx1U9ee12Fc6sxmf+Xcdc3PqNGP70F/HRBdQqRAWos8tjYOMffd/7oZWsbu+mLxdT9aCljfHB1tlM2uYmZnsEHRzGJFAAexKYAJV4HNKMoSYEQ5Ibl1rn5BVXdsmfYgRzDcClZLx/bbVFRFzvBu0/g3S49MFelkzzsaiBB+TXdRyfYgC5w8ci6O3jtlH43Bt5ttcyo88rchuy6PgBRLhBhfzBMuoWC03IUkPs6CM+FTlmslNz+pqlf3jXu+yyVYwon9hwsgJb6eLecEZ73dErAlH6M1PNgcJYGxOqbT9IEzKwdTXi1UOe+SGS9R8Lqw49vXaYYhCGLiTp90vyhqHYTNdqyPGwqD4wQ8YwZRWCxrousZJXjbH/i/uQVxFH6+NBXrNRb65pr4q0bSV340R5AF8kch3P9l+OWQ4ZAFoqyVcQbKwB9cjILBZsa2bdh+W0vHBIsmbXFJCYNNiSv5KOzzrwfYAMgxvT8dSzoE4VyMC3DFJ9vI4FYPUGtKG0x274goCjn3PDuIK8BrkAyohV048585qFcYN76jHY53q1lnJuGxH2KKrosN/lNDnKfg2t38pzxWRptCZGs4ADYUjcLzUE3+mq+GA1mKWEeyIrJMQriJiNf4fQg3/fS8vPltQHQjajrtcT5MuSJOI5kwaGllDh2MObVrzxIGaELaWMmSbxOPaGjVuOqdzeWgobTydC6PAESPCrTcCILHMLi0AO/D3h4BKZUUstCW/qcO59t01qGj8Y6T6VTl3TmquhZWMtI/Ewa2bcxXwj0vhzAyfJXcMQaCw0LdOnC+Rn92zfCqwYx8QeOMJlXAXCSOY0Bul8faZtM18HXguZnF2VxMirSNCJfOsQyEcMG4fQ8GqOe8mFXawiqQDvETP39JAw7nWFy8FCgAQ/WAIHGgFoNHGsXsGpgo9Ro/8/1tjh2PGhSIEkQr2r0
 TjNaHrO0
 maee3Lyrr06BtGhz3nK39UoPb8ru2dbTpLzrx/Xr8NNhjnVEGWqeJ/tRFWOjKCZG7uwiGkTcA9QoFQ54QAtI6w0pCyvDPlYizJb7hOVsLRY8FsRJ5LMSBo2f4tTWX8mCEGnWESWmtu1ahc++xNtM4tfFUWzfn88w8tAktAnOW1GRXq2/kH4BRB9q+bNQSYdra5JSUAxKmRwjPdi7mfozr+29/71ghrhz6f2Jx1qRAMidwcoSU/nB6ak9zePkh1TsvPBCU8k52K4VTe7I=
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
and more appropriate opeations adapted into swap_ops.

Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Co-developed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   2 +
 mm/swap.h            |  10 ++++-
 mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
 mm/swapfile.c        |   9 ++++
 mm/zswap.c           |   2 +-
 5 files changed, 80 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa89e1d30a77..85f15ec326c1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -243,6 +243,7 @@ struct swap_sequential_cluster {
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
+struct swap_ops;
 /*
  * The in-memory structure used to track swap areas.
  */
@@ -283,6 +284,7 @@ struct swap_info_struct {
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
index 7c1a3a3a53f8..3f9aee5b6a4d 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -238,6 +238,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	if (folio_free_swap(folio))
 		goto out_unlock;
@@ -283,7 +284,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
+	sis->ops->write_folio(sis, folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -373,10 +374,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
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
 
@@ -409,8 +411,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
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
@@ -429,8 +432,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -446,29 +450,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
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
@@ -537,9 +518,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
 
@@ -571,8 +553,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
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
@@ -593,8 +576,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+				       struct folio *folio,
+				       struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -608,6 +592,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
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
+		return -EINVAL;
+
+	return 0;
+}
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -642,13 +664,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
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
index 4840fd40f36f..8c42632e6765 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3780,6 +3780,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
+	/*
+	 * init_swap_ops() sets si->ops based on flags. It does not need
+	 * swapon_mutex, and must complete before enable_swap_info()
+	 * exposes the device.
+	 */
+	error = init_swap_ops(si);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..192401f46de4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1054,7 +1054,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	si->ops->write_folio(si, folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
-- 
2.52.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D71CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 01:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7B86B009E; Thu, 14 May 2026 21:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578676B00A2; Thu, 14 May 2026 21:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B54E6B00A4; Thu, 14 May 2026 21:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38E266B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:57:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDDAB140731
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:57:56 +0000 (UTC)
X-FDA: 84767993352.21.ED23A9A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id 30F1B140006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:57:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xw9e8+1v;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEsHsxQav2TvnbIZZsTRBwS8toLmw21bJKCaqNlP5NQ=;
	b=o4uA+Okf4PqbqTj3nZ2K7qdSsNjivyetBzRE3djTxKvC4qJ26D3IKxORGi6ZN2gfzw7GwS
	HHXuW6I7CIhKsAD/HqbPzSaxiyzboz2EAiCoa7+pSF35RDeYQ1dlD5H/mYcx2++NeCK46Z
	q5Mz9Q0WMZaaueHTwnH3vw/ozYtbjYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810275; a=rsa-sha256;
	cv=none;
	b=mfE5cJqabZz48TBbNVxk0C3i1QdPfTXfy4hLq5dcp8A2NDbyau2SYIFKF/cjkVxBbTATWJ
	R610wjmySMraBtnPmcapf0siXWJrhQhtWu9lJvznz47vgGAMv/P4vuJyY+0XUWXXAzqIRa
	JJ1vmiRFyP7ahBY+j6NX5D8stenMUeE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xw9e8+1v;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778810273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wEsHsxQav2TvnbIZZsTRBwS8toLmw21bJKCaqNlP5NQ=;
	b=xw9e8+1vwCgkcaae38RYCgz4aaH0mPkRcN82TT0yXf7CDFlxh69Of5vRpac4PmZ6qCQUZF
	L4ioAws5aTUT9J81QAwJvFpyuIammi0RsbYVBHFxARl9yWbBVEW7Db8YUV3nzpg99KndVg
	UDFUy7uw0x3uNmHLFVIZy9jLiGwFXaE=
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
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v7 1/3] mm/swap: use swap_ops to register swap device's methods
Date: Fri, 15 May 2026 09:57:35 +0800
Message-ID: <20260515015737.890994-2-baoquan.he@linux.dev>
In-Reply-To: <20260515015737.890994-1-baoquan.he@linux.dev>
References: <20260515015737.890994-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30F1B140006
X-Rspam-User: 
X-Stat-Signature: tqequtk955ioyx4grj41cxa77e5984k7
X-HE-Tag: 1778810274-106008
X-HE-Meta: U2FsdGVkX186xL5kGQDq0rbjFLGiTRhrcKxTulbpV1y9mpgONazt+zoRCEswRY6gKFw6jbHbjbeJTyrJVQUO3NYF6Oa4Qk5sLBjC6JqbBTD1GqzmD4w5jhursmVRbtzH/wp8mNRnohHhlB3qx7ZDJwLFjKzwuD0brQNHMLsDgi3EzfBRxBHizVj5/Zs5Uz0nZ/0ko4CfE2J27cfx3hwFR7opg9rcSmv+aJNZqwV5n9qwpYxOxfuvAOnHPYAEi2Y5dacQnCgYMWv+7gRz+T61W8WccHPahd6b7uxks9/85N1k5uKNx+hc3GB/jMYyCngPQKlYItfjc8iXFjnY3/y3ZI9mcQ4Smvv2yw9LmEqgh4biGuaFNTlq8hqM1bxnOOBlvgunCz8QVnywOxwlMgGEW6ijQr93VGqD5I+DtWG98iWk7A8EgV4d/o7xR+zn74OwkLhORclck3S0G9yhFpFVy4CF946SQnxGnPNFVDepDtYZ+rODe1psgvpsebBr8RM4rz1EBRNvYkRwcgW10VMO1hS2ep7kAS4ooXENaJnEOXCPcB4cy72iK8J3NoOXHLiVxkjThkHCQIxB+bfC29XJtm/pGtKMaSt0hGuVFynqN9G50ZksLTVvHAGT7qJQ83tT/dW/dA8PGPN9+eFSkbbrpZdb1wOGq+P3x1ntk/OPOt8a7obMqXr3WpcZ0Vgu5I5mT9wSVS1VmMgyoN3giompE3TLE3+BZOkufQ12y4uX9Ne+1RzXiXa7FcmMWx9snA2rFoZW04ZoZLUzJiSjQZlotYKmWINsKf4jJWcvgMpDNIldKiIsr1G9lz7EzrXSUJnIjJYvCxCGCrhUbStEhnd2JCrRyJN0JVvEah9sd6IlXZZTbIEYwNV6hz10fMiWk/euFoJAiWTjXrgKyLhUoTd2t/1AN24xJGpPuVdHfrHsr7OGoRuB7pwjnx563p3WFlxdKgdQec1UebzH1XwWBip
 LRwn7K9K
 zJCtHA4maXRKG+zL92WCqDX3fUybn6MFWyboH1zUUKnvoz4EQ/22X+uUpKzv6t+mBSOswbIGCwzqrjPYT6HbO/278HaK0X31bzZgghtFnaQMYAuRM76K9lEPkArTl2XA0wZa5F99yUmr+/R2fsJLlzquYCQ9/RlbaVssBJxhek+1asbbMJrYMbWRivsC1bpoxNJadi2a252twbzrSIzIRVkfSbrBToc1FeWgKXA9g3HowIw9GKDXoVkIqSM5f4uZSGD9UcvU/qvSP3gs=
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
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   3 ++
 mm/page_io.c         | 104 +++++++++++++++++++++++++------------------
 mm/swap.h            |  10 ++++-
 mm/swapfile.c        |   9 ++++
 mm/zswap.c           |   2 +-
 5 files changed, 83 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..0d045fc8ec35 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -20,6 +20,8 @@ struct notifier_block;
 
 struct bio;
 
+struct swap_ops;
+
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -282,6 +284,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..2b520af88376 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -240,6 +240,9 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+
+	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (folio_free_swap(folio))
 		goto out_unlock;
@@ -285,7 +288,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
+	sis->ops->write_folio(sis, folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -375,10 +378,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
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
 
@@ -411,8 +415,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
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
@@ -431,8 +436,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -448,29 +454,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
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
@@ -539,9 +522,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
 
@@ -573,8 +557,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
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
@@ -595,8 +580,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+				       struct folio *folio,
+				       struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -610,6 +596,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
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
@@ -644,13 +668,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
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
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b..8d4375f91632 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -217,6 +217,15 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 /* linux/mm/page_io.c */
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
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..29ae79d0fa2e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3597,6 +3597,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
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
 	error = zswap_swapon(si->type, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
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



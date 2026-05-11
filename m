Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0BACD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549BA6B008C; Mon, 11 May 2026 03:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520656B0092; Mon, 11 May 2026 03:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436AF6B0093; Mon, 11 May 2026 03:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 341996B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:34:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE903160651
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:34:09 +0000 (UTC)
X-FDA: 84754325418.29.E4504DE
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CABC40003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:34:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLdsIkCq;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9ohb/rs9Y+WQKJf+igG7d6Bz477Qx/eAauYzpOS8iw=;
	b=NfncVX+gH7olmIYJXLWBUhwTS5swtHWubkmAi9FDGlglXfBfNjazYUF26f+H4JZaswgsWi
	L0n3LryDhff1V2Mpmn99XCIe1BoyRXh8iOepR/325kzdXpmyYpWQ2MXdE0GGELJINoCqDr
	QqZfK+jQvrw5M35KL403ct9pT0ErGpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484846; a=rsa-sha256;
	cv=none;
	b=3t3U+FSnuFN5ziKh0bYMLqPNs8/MyEM2pkzeu+NSw8k9eCXF8hOeCTusyTswTgqdS93TUA
	uHI3xI1lnsEoeuw6n8u1ujsLaVrxg9VDHphGmIplVdQAf8ZhfE+maHZZ+CkxVwohvfwAZt
	c3ctIXMCcpNZNOkIbn9BU2POtCkJ73s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLdsIkCq;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778484844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9ohb/rs9Y+WQKJf+igG7d6Bz477Qx/eAauYzpOS8iw=;
	b=vLdsIkCqpNtI80eNslseb7Zdx0XNwgn/mDOt5RR4W/T0IrdI8YgKUuUP9kf5JUK0Fy6YPP
	8xVjn0IwhxlEZUbmeKdr0zVz4oMWWZM9YPPB1MZT2Fle0cq+DR2g1rO17E/q37fUzKUmYR
	EZVGnt2cyHvTMWgMeI0I6VDtgtEnuDU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	chrisl@kernel.org,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v5 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Mon, 11 May 2026 15:33:33 +0800
Message-ID: <20260511073334.635682-3-baoquan.he@linux.dev>
In-Reply-To: <20260511073334.635682-1-baoquan.he@linux.dev>
References: <20260511073334.635682-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CABC40003
X-Stat-Signature: okmefjeg7c1wdpmtftrko4aq4ob7x8nx
X-Rspam-User: 
X-HE-Tag: 1778484846-30295
X-HE-Meta: U2FsdGVkX1+LhRt7ofj5k1VfKRaUpLXFU+rZOo6sJ4ZXPBL65oXmYywXeQOsBF5b6xLDWdC6jjzQQavMhwEBq6ggnqAinhDNsK2s0S0/aile2eMYYdKXO2dPTVzOcwBhtC8t4D0SWp5L63rNiR9MB5GTB8DiC0NX97Xc+7Afq/N1zcjIX7pslW2mrI2gJ2rcF6VNC6ecR4u42ET4YQiBWwttOsqVwwk6sDtUjO6124CItWcWEdbFHmFHcIy0kFsjTQkOl9kCBv18AxJsrRFBLK2m4Fje/HG2PRe6wTyRJiLMqm8A2vKtzzsAdv6amcmhUWhP+oH1zeq2cHhIfV4n17Z3Ll7tFi8wPDe5gfmmwTmzGpo4GjB0bf75AoE/5SfhPsipQk2n8bRqlclPBHQXoIEOA4RDuDaZyCtXJuCKwf1xUNd75dRSvapoYraZYYncIA0Nm8pBsRHrxs9JNas4JZvC98y67aKwVlaFktO+5tDfpR0p85w2mKd13OoX6jKVh/nq5RKiA3u19BEJtefbuslT4MSNn1FJ/w4gjqO1/UQgyfkAMgnoVxXzXNTxbGx9j4rbgv6AK7UKYQ8x+4h/QpPXvtEZz/qHWaWEQ2aE0PBSBzTdzijEIX3lFj3mUKnCuHpLqunxdeOWSUMru/wP2Q26i+rwF4b1RY1coiuR6zUToqbH/RgtcpVJNB4MoX6qYXdp61Zgv950A3r/ACzj0GJzkFRuXMxvYMCmzf4MLOhxFeCzRc8iZVPWEuACKOsoxM6l8eqW9uIawn1g3sl84vn7n2egRU30dKnxyhKAeFawgDRa813/9hNWs31muICEnJo6DNleiFzu+iZhC1KMUrWe84sal0DzF8M8/yDH/MLOLCKQUSi5WHOAy3UMP3qOlQCi2h4rko9CJuHoyleOSUQNzNdokf2cBYZOlEQ0eNhR6ENIm+6Ry2Se1EOWrC9Wqbw6n1wE5oCPSRN7H+d
 xPgIRSBc
 rAVYUMTYvj63gOOS2ZODeTOrUP9PdAUG+kbPGzeJgNUDeFxT15D1SM2dygAkkglaNpS0YcV8QqcyCOqB5fY0n/jDJbvT/VuTtkGptWtAD6EqFF2XovsuWs1PzBeEnj3Iv8c4/5JqcW8cFyWJ46gk55CrsQG+FkGfWpvmWaGGE0/E+6gHF9Yop9AcaJGxPkTGb3qvyFMIOlHrp/57Zud+I3f537OrcPaXN/Z3CBcbuWi6jMRjYd4SZQZL37EGYX7nmoodlQ9wNWRsgaNg=
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
Acked-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   2 +
 mm/swap.h            |  10 ++++-
 mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
 mm/swapfile.c        |   4 ++
 mm/zswap.c           |   2 +-
 5 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..8edd629e30ba 100644
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
index 91b33d955e63..cef884339717 100644
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
index 9174f1eeffb0..82d2c9b35b11 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3518,6 +3518,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+	error = init_swap_ops(si);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	nr_extents = setup_swap_extents(si, swap_file, &span);
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



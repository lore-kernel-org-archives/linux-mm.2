Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0A6FA0C5B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DD86B0095; Wed, 15 Apr 2026 04:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2282F6B0098; Wed, 15 Apr 2026 04:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5306B0095; Wed, 15 Apr 2026 04:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2D926B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:57:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD19AE3FF3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:25 +0000 (UTC)
X-FDA: 84660186450.12.D8137D2
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0E6180008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KsL0a7bC;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS5qpEiCkYhxSwO473MIhVovQuf7CZrjA9Nb/Pirvks=;
	b=1zJ7PDgQSLEr+5Qg7pquAL/2tOoADrVBuiLurJtFo8fqxnzT6d5ymCFxhOeyNI6Y3nRHBl
	FPzP6OdFFdDJ2gAE5GxXD7iA8WoSwlvSnYS9iyWwgJH5PCAs4CFINkNoXEK1pAzED2syR6
	uLTqOQ8K7brEof8GMnTyVJVWXxTvB+U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KsL0a7bC;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243444; a=rsa-sha256;
	cv=none;
	b=lOu9kGS4ded7MyLLuyKrZIDQ9rMZVJxOMRgpmnrApTxu7V8pC3wdhUgWoNoy8n9jlsBfht
	2ukgDx23l0Wa43ydisc/wXb6ewO+Eepv40EYBib+mEUqBpUGpMwOD9ZL0OmifuDt1zyxPy
	u6YoIrZJq+1e9IYSQDq+/3Oacmq6AVw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776243441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hS5qpEiCkYhxSwO473MIhVovQuf7CZrjA9Nb/Pirvks=;
	b=KsL0a7bC9pDxfCYS0pbMhEeCJ3V6Z4KmdX93mIJ4/P3N4/MA/we2Nm/qapyNOrPSY8UUuz
	3QWCwZXwwB+CRKYKIgoYPWZCZ36T+vBk4qkYJwrSOmmTQYAw9PFUByeFGVosaBjYhLUeDK
	y2VmiVxwWKOc/yTQ1EZJwFuowO32vPg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Wed, 15 Apr 2026 16:56:57 +0800
Message-ID: <20260415085658.993859-3-baoquan.he@linux.dev>
In-Reply-To: <20260415085658.993859-1-baoquan.he@linux.dev>
References: <20260415085658.993859-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0E6180008
X-Stat-Signature: 1s1kkbgn6gmf6nj39x84yjhpxsq5c8sx
X-HE-Tag: 1776243443-605350
X-HE-Meta: U2FsdGVkX1/CGt/qgEdXMZpvn5jIRN9XaFdEUtjkW21dkdkVNhafOidi+hF9AQ1W4T/Ltontl1selfp7HASHHPmyGoKv2UhRa/kzyThsPByxkfUnIk0QdTBALXdJVf8S0+XOzvoiB8qMIgSLDCrS4ORCg3HnJQT3otSTzrzYZJL3AV/5Tx3j7YfTJ8F9UwHY1+bRtiuUhTY5XV1FG/xXJpCNeEPpZLUP4c4YoQJZf/xB38eEHr1Bkc0t9l0q1Fy4//iWDz6Vli2jFwDSzvGUPiuOxitsEs25ZGzJITfL9ZKcj/9gE63c4j6fSiapZaDi5VDbwpIUgT4NxyDE5gfPoN0gMmTBocpq25p6yNQfPMpuNrAmzJlVuYAfmd4wIG98gJuLK4IMfOYqV9S+n1kFtDlmTqn8F0BJWJonQZ018R9Z7nw9mFDEIEngp3aEk6+5yNIhDI+WdUe10c2yINdiLN1Q0LcleoI+nB4MwzbY6Ob+i2XZAva+Sv7QTtAfKR6rJ1ZYOQZSH/9DjLhxo4t4Wn14F05695dxPrVYImpejtodAKTaGL9yWVjchG08iyPsa2OBd5xu0U6V+q8xWbWeedrazSiOV1iDXx4rsmJ2WL95U+qhkF2Xb9xgIRqfPNnDyTIRWpvxqxM4M+RFP3ysbcAGp9pvY2xNILFWkSK3XU384XE0483vWQiocCesik5S7QIRwnElPnuoiMdtz7K/5cdSHo9DEMoUnH2euBx7IFORvh500cIeH6D6dnO8/7qK1sdZYx0IaDEnj62jYeyRINKlSi/lnSIUFYEUjuXlKHFokaKhu48gc4ff2z8oWw+Il3tux8+vUXKouhO+T1qvUrFKEpJmB97Lyf7nk5xfdUOHnAjJLxf1vsU2IsJxIZVAeWIuCMNdiCvyGjjrz0PsWlc3rbDWYjnyGEDwcRA08tlUozv7d9SE0SuKflIHvcRw7KXICmSwEyiiWFpfb0U
 vrWq0icn
 JeijTSwFXIfDTiWbC5PyqyUcixg5M9z5qS1a0bB+IXTtA2yNBsrbvqZuJMExxAENlEh4jyR3ZlxIYv7Tv6eFrFnuHmw6+/50EkiqCLTklS0rsZqC93qwomeNIVF+eII0PIZ1BwZOosLpC9Zkl4a+RDqf0vPeJ8X9mGTIQXh+ET33hMNgE0LXn2Nsf40/lRxYGuPJiHmZ3gwBUI/Cam2v73nsGS8cs+w/vw/u8ptFlYZSyLw1mMEjY27HGsZdS0SjZfIPMWt7nbKNOGbWVHVfrA8GIkQm0Rz7hn/cMiYrdT/METb4=
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
index 62fc7499b408..3069bbfd7a05 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -255,6 +255,7 @@ struct swap_sequential_cluster {
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
+struct swap_ops;
 /*
  * The in-memory structure used to track swap areas.
  */
@@ -300,6 +301,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swap.h b/mm/swap.h
index 81a80605fc6a..0f4c597e3f28 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -213,6 +213,15 @@ extern void swap_entries_free(struct swap_info_struct *si,
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
@@ -222,7 +231,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_io.c b/mm/swap_io.c
index 4bf210bd677e..602e9b871b30 100644
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
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
-	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
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
+	if (sis->ops || sis->ops->read_folio || sis->ops->write_folio)
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
index 60e21414624b..7e1660f59c00 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3413,6 +3413,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+	if (init_swap_ops(si)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	nr_extents = setup_swap_extents(si, &span);
diff --git a/mm/zswap.c b/mm/zswap.c
index 16b2ef7223e1..d8930d9054df 100644
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06ED2E9B359
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716986B008C; Mon,  2 Mar 2026 05:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8456B0092; Mon,  2 Mar 2026 05:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D8F6B0093; Mon,  2 Mar 2026 05:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A63D6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:40:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9C9913C08C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:45 +0000 (UTC)
X-FDA: 84500779650.14.DDA6214
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 090CF100006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj+XegFy;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ef/YRse0ywzgq68pzrfflNulya488jLJgo1ZZba753E=;
	b=k5P2VnsnT+Tpo7sQJiyB118odeX6jankA2IqgmZfnF6AgTLEXVjakIOWZEWp+4pGzwkXst
	vbAmgEHb7dnnlHULOX48vv/4OJ23Pt5p1mJfO2sTeIrN5IBA9OQJ2tLU4fvyNxnp1fqwJY
	q5v8s48O8aLXDmfYeRvsauRE9fYDltE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj+XegFy;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772448044; a=rsa-sha256;
	cv=none;
	b=zM9ge2kqwi9c2VpxVrJ3S871qoAXacvjyN4fPVqgVBXPDomkC/DX3kRJwon12V7xz5FxTG
	JPd4myibOF9ig5XCqPnQBWANPDqTRRm3ioJHtCVz/YVxlhP9vOk/BBzHvA0Q6pj6b4QN7k
	4NZXH+vsavIZ1M7erBCxhxkg58tqu1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772448043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ef/YRse0ywzgq68pzrfflNulya488jLJgo1ZZba753E=;
	b=Kj+XegFyZoaUDta4NoJTtEUpQrcoeqBsieLLCoSVbb5/5PluJdkR+Irekf1uBv9ia9HHag
	z43h8SvxugBSlOYnnaje2SfLLNynjdxchX4EeuNCKllF2UJ+5izYlo51qI2ISyhz/2JBX0
	7deTn/peU9AMwpepHqEC952hOY8B7i4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-kjgwW4ceMxmXREEWhV5Mjg-1; Mon,
 02 Mar 2026 05:40:40 -0500
X-MC-Unique: kjgwW4ceMxmXREEWhV5Mjg-1
X-Mimecast-MFC-AGG-ID: kjgwW4ceMxmXREEWhV5Mjg_1772448038
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E19D180025A;
	Mon,  2 Mar 2026 10:40:38 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.98])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DE2430001BB;
	Mon,  2 Mar 2026 10:40:33 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Mon,  2 Mar 2026 18:40:15 +0800
Message-ID: <20260302104016.163542-3-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-1-bhe@redhat.com>
References: <20260302104016.163542-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hW7pQkzQ5rL3WxxR-pjk9FReSF49WITkQd81x59e-l4_1772448038
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owpg199z9snqohyysf5juiuzey93nbxq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 090CF100006
X-HE-Tag: 1772448043-695783
X-HE-Meta: U2FsdGVkX19PvI3yCDADGqH5A0lLBPWEsUrYtOOEGURHaaRc2UVnuuxbO6C2pQ4UNx31e5A1bnzuiZ2BbJB2BtcQN7G42mQMtMbOv1/G974ZZOmtmv8ClDdKY4r9ruq8fEK519gbeYRrLHKjWgX+WXN8lXcjhGXqQM3xnh6vh5kIKkb292lKpxce3XN5W/wyDVoY+vsNZSOtc4e0/Cfafykj9uzAodddcL6ni0JFt/nR3XkuVXNpRiZWCi+UgzZCHhAdYlX8iKFnUlWZPuDHZyzHIWUfn/xYn/XFLzuCNSM23+aoQ0rgntwb9hq2vk0EMlEOTS6k07AxLAwjyEMrs0Raks7RoAq12c3uw5Hu8X4axDOF/ln+bik6MRx1wtEwao3rt/UCq+d2xfoT9xKYJhnC4OI4u1O+a79dVuGZatS9/MDbjkIym9epyg8qwGybuS2C5mHuDQXja9IXDv4VuqEJz3wXzHJcS1HhIH24+K36jApj8yhf4iFbFsHphUbY1oinvJ7+mxYaFD9NUOAWqhZTio50SEYuniRLAI8nTj0b+mriLdo6/cxERWUW8Wwv0ctoC/S8bTQzR+vMGN1U+4rolqcNKyKBL51ugiAGB0J/a0erDZgVBTqrmMh2y2Eck8ZOyFfE+E4fSJoakw1ECXbzKretyeubBnPuC7D5FOFbv6kH4WM6o/gLoMMUwl3p+GjMetSNzIsU2IDdGpsgEousAUDkNRS9UpG2qV7Z6X9/G5VjNzDkvSk0yW2xK0TVl1l0PzAA5qNUlmwMkd65+4JFgjOJfzyWPGM+mKrNg3wOTALiGV5nQZ0caM6LgTeRHvusf7r7fRCzR7zE2VHOfGub8pXf4/YsHpUmeFsD2b3ZwOw0V/2UtKbPIzH4hjiEqM9/1DA63ud4o4SvPFTUIMoJFHg3qh4xiDCbFRogbvgGj1lXwvqpRsAyR53IpoAFwbgJnfMHCEQRyvg/S4w
 5cy0WINz
 WtNk8J5zWtb1HikzeiLYZrOtqpo7nHsT7/7IPjUSFYiU1e8dYpfd7uxkX+FiUL2T13NR2FIKqKGXdEWnq+uvrwVppT1crdovuPv5EJPwzlTYwcD04oUEVjk2AA14hzaK1ZJ3ioBQssjjlvxEgEck0O6iKuuYEEICH718OlcQdz6/LK0unWvJDBQ6a1cbv7dSUZp/CSHMb7lYiXsAxFCLCZYC8UN2v3hxYUTwDNsHKN74PZwJWv5GbqVQCdWVNpWFUsr2oStAk/xp7cVdeRqFc2kZUB+so2jIu312fVS981OZpbQwfEIwLEIY4ZbtIzrECE/MnsT22HaeZLZfrXxSIm/XnY/Tt5OW7xC/ZeW0JxutFSDJuIr45S/1qmy/y60yuSklI
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

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/swap.h |  13 ++++++
 mm/swap.h            |   1 -
 mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
 mm/swapfile.c        |   2 +
 mm/zswap.c           |   3 +-
 5 files changed, 76 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0effe3cc50f5..448e5e66ec5c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -19,6 +19,7 @@
 struct notifier_block;
 
 struct bio;
+struct swap_iocb;
 
 struct pagevec;
 
@@ -222,6 +223,17 @@ enum {
 #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
+struct swap_ops {
+	void (*read_folio)(struct swap_info_struct *sis,
+			   struct folio *folio,
+			   struct swap_iocb **plug);
+	void (*write_folio)(struct swap_info_struct *sis,
+			    struct folio *folio,
+			    struct swap_iocb **plug);
+};
+
+int probe_swap_fs(struct swap_info_struct *sis);
+
 /*
  * The first page in the swap file is the swap header, which is always marked
  * bad to prevent it from being allocated as an entry. This also prevents the
@@ -284,6 +296,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swap.h b/mm/swap.h
index 161185057993..c390df3f5889 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -226,7 +226,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_io.c b/mm/swap_io.c
index d1cdb10ba133..47077b345ae3 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -240,6 +240,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	if (folio_free_swap(folio))
 		goto out_unlock;
@@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, swap_plug);
+	if (sis->ops && sis->ops->write_folio)
+		sis->ops->write_folio(sis, folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
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
 
@@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
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
@@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
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
@@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
 
@@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
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
@@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+				       struct folio *folio,
+				       struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+static struct swap_ops bdev_fs_swap_ops = {
+	.read_folio = swap_read_folio_fs,
+	.write_folio = swap_writepage_fs,
+};
+
+static struct swap_ops bdev_sync_swap_ops = {
+	.read_folio = swap_read_folio_bdev_sync,
+	.write_folio = swap_writepage_bdev_sync,
+};
+
+static struct swap_ops bdev_async_swap_ops = {
+	.read_folio = swap_read_folio_bdev_async,
+	.write_folio = swap_writepage_bdev_async,
+};
+
+int probe_swap_fs(struct swap_info_struct *sis)
+{
+	/*
+	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * but that will never affect SWP_FS_OPS, so the data_race
+	 * is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		sis->ops = &bdev_fs_swap_ops;
+	/*
+	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
+	 * is safe.
+	 */
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+		sis->ops = &bdev_sync_swap_ops;
+	else
+		sis->ops = &bdev_async_swap_ops;
+	return 0;
+}
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
-	} else {
-		swap_read_folio_bdev_async(folio, sis);
-	}
+	if (sis->ops && sis->ops->read_folio)
+		sis->ops->read_folio(sis, folio, plug);
 
 finish:
 	if (workingset) {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 915bc93964db..af498f9af328 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
+	probe_swap_fs(si);
+
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
diff --git a/mm/zswap.c b/mm/zswap.c
index a399f7a10830..7ce906249c7a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	if (si->ops && si->ops->write_folio)
+		si->ops->write_folio(si, folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
-- 
2.52.0



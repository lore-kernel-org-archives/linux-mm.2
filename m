Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9375ACFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851166B0008; Fri, 21 Nov 2025 04:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801796B0031; Fri, 21 Nov 2025 04:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0096B008A; Fri, 21 Nov 2025 04:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 539696B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:32:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F26C31A04A2
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:32:25 +0000 (UTC)
X-FDA: 84134098650.14.14647AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4FA4C1C000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:32:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpQ1y00g;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763717544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nI87IEVf/RBvB18z8cffTQdfHsJZHJRh4Z1j7fUUA8w=;
	b=ZyU1V9riqdWoB8DZSHKhT1/gMcWcsL4+HSV7NKuqrEJwIPJT6rrTOF4LZf2V+Ns7p926NF
	JZf16teSXUc8zZT4OPKpO1HuPQ0fitBqOP1Dd/svxyzhq80KvBi5rlIN0LZYHn/wcxvMqJ
	JNfdijFiXT2cMIuVqXtmeWsQ2zUFSNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpQ1y00g;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763717544; a=rsa-sha256;
	cv=none;
	b=YWRcQwPVSs0za+6jqYU0prWqwBdlaKlEzs0wNUkIVq1UbBbZviLEZNitRzlGlyuCnJT95G
	iOJSFIncAp36Xv2PT3Z/amZa5aZOlx3C661CNBDcoFDCV1AFsIJzduJOUeJ90RWuZ2lU9y
	IA0FjwDjbfCn5T2xPTX7zGRkxVeE7PY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 307294360C;
	Fri, 21 Nov 2025 09:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84633C4CEF1;
	Fri, 21 Nov 2025 09:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763717543;
	bh=qNPdhRxpA9AjC0LhxRquo3XxwPunhF1cNWK7ZjouMyI=;
	h=From:Date:Subject:To:Cc:From;
	b=SpQ1y00go2G3Nmx9zNwmaCEQoaUNXCazfWxxx/0GJLeKSWL8ebgFzd769EYuC1xw5
	 pEAG4MsxeQpuefx04FpVLHLL2cNYQuODfG4jz+hHH+rPgEHnPPyIUrY78L1rDf+ljZ
	 +KbJxaSGVYGFprjj9RwmL5QDrSFHwuRHdm7+eGUAxmUAHwjtIXfekwwQYef3L90u1/
	 CAX52cq6UVVKKH8etjC2+lF1TERYz33MSPBqaeI8Sf5z2Y8u3Iw63ywben22V7kcae
	 sDYgOpDPrX9yzgRFQB8SP3Bs4k+pZSAZsBYIbUgvBm29BNg8rR3Vjn7R6QPkkG8qJz
	 VBy3r0Rs/e47Q==
From: Chris Li <chrisl@kernel.org>
Date: Fri, 21 Nov 2025 01:31:43 -0800
Subject: [PATCH RFC] mm: ghost swapfile support for zswap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
X-B4-Tracking: v=1; b=H4sIAH4xIGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDQyND3fSM/OISXVOzVGNLE4tE80RDcyWg2oKi1LTMCrA50bG1tQD+FG4
 8VwAAAA==
X-Change-ID: 20251121-ghost-56e3948a7a17
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, pratmal@google.com, 
 sweettea@google.com, gthelen@google.com, weixugc@google.com, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4FA4C1C000E
X-Stat-Signature: qzh33ybxmnodgt6jgawqot7rdhdi3s6g
X-Rspam-User: 
X-HE-Tag: 1763717544-170079
X-HE-Meta: U2FsdGVkX1/KwEHVa5C4ALsqsIvo2QCY34fhT8ZW7fqOCMERjgrnhMOUHO5xSDGG15zA3u2vpjNYFIDZLAKg0hTvMuKO8VoIbHJ9SZ07vSf6hkExHCfuEvZe2taCChzMIHZ54tQgt5T8JIQ9Twx44sj9snATq2orfcPjEKkcPtOi4TI2FlXnMyWVGnTfmuVAviG85MAUW11m61ZfbmkEYzYTEsD2KL6Fq5mmfcfPL4BrDS1tegT+ib8mpoP1kKoMHK06hPRuE6A5mNS3LXJyRX9U2XKfLnVoSSaJSJHYWYFcFWABkH129oJwz+ctGCgJUWC6p0jvCNLlzC53stlrp1IK6qmvpuDo1WZNyetj/E+QEEXiFSDIneD1klkZaBAyhCfmTFEsUY0HgTnqsuZBpTGR4Vv/Hx+LSDCxOT7l+s6zfCSFp9ys+FA/63byRglizo3HNp2zLQl+7aJ1PcQD+fYM0+VGzFHPW3YARXln+jvotA2l3lPGKrmEqCvFDy4mHeJTdH5kGavGKdsZWgpZgNxMj90Gk+E2dfZfTi5Hn632KkNCBAch7mdDhHDNur8iZN7YEBuZ5HebWg/Fcee5WpYfqstF6LM58sgdM0ngikAy4aKmNg9p4TJoQI+xxGg8y/A61+lNcQIDKEbwLBI8PHvJ5A6x51Ay8NcPuNYZdXw+yyS98zboqcXMU4R4Y83rRZzHrk1E0MZwe43wVgoE5Mo1uf5kkzNGDZnsw0ZYklg1kkZwvADbQRdzp6/6UsxFq8GHsNsWWxRThTckxeVDt2e+X4QfU+0dXWbS7OMeVbB9L7TtpBAcs6Vcp3tXsdTfYV/3YXFf5G5P1mTFVjixe7NFnoBfdbcZI6XI5SuPqONvy1PcsXEX5oOsHzLjrDIGAZxMYAiK7YoBP2K3y3TSwOW52fHN5oJqpg1aRRoCYyw/K8PKbWpxVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current zswap requires a backing swapfile. The swap slot used
by zswap is not able to be used by the swapfile. That waste swapfile
space.

The ghost swapfile is a swapfile that only contains the swapfile header
for zswap. The swapfile header indicate the size of the swapfile. There
is no swap data section in the ghost swapfile, therefore, no waste of
swapfile space.  As such, any write to a ghost swapfile will fail. To
prevents accidental read or write of ghost swapfile, bdev of
swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
flag because there is no rotation disk access when using zswap.

The zswap write back has been disabled if all swapfiles in the system
are ghost swap files.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 18 +++++++++++++++---
 mm/swap.h            |  2 +-
 mm/swap_state.c      |  7 +++++++
 mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
 mm/zswap.c           | 17 +++++++++++------
 6 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716042946274c18a3a6695dda3b7b65..af9b789c9ef9c0e5cf98887ab2bccd469c833c6b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -216,6 +216,7 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+	SWP_GHOST	= (1 << 13),	/* not backed by anything */
 					/* add others here before... */
 };
 
@@ -438,6 +439,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce38ed26bc7aec68651270bbe0e2564..cc1eb4a068c10840bae0288e8005665c342fdc53 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -281,8 +281,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, swap_plug);
-	return 0;
+	return __swap_writepage(folio, swap_plug);
 out_unlock:
 	folio_unlock(folio);
 	return ret;
@@ -444,11 +443,18 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
+int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+
+	if (sis->flags & SWP_GHOST) {
+		/* Prevent the page from getting reclaimed. */
+		folio_set_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	/*
 	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
 	 * but that will never affect SWP_FS_OPS, so the data_race
@@ -465,6 +471,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 		swap_writepage_bdev_sync(folio, sis);
 	else
 		swap_writepage_bdev_async(folio, sis);
+	return 0;
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
@@ -637,6 +644,11 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(sis->flags & SWP_GHOST)) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd260cea2a1e95010a9df1e3011bfe4..bd60bf2c5dc9218069be0ada5d2d843399894439 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -195,7 +195,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
+int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __ro_after_init;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b2230f8a48fc2c97d61d4bfb2c25e9d1e2508805..f01a8d8f32deb956e25c3c24897b0e3f6c5a735c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -632,6 +632,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct swap_iocb *splug = NULL;
 	bool page_allocated;
 
+	/*
+	 * The entry may have been freed by another task. Avoid swap_info_get()
+	 * which will print error message if the race happens.
+	 */
+	if (si->flags & SWP_GHOST)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94e0f0c54168759d75bc2756e7c09f35413e6c78..a34d1eb6908ea144fd8fab1224f1520054a94992 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
+atomic_t nr_real_swapfiles;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -1158,6 +1159,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
+	if (!(si->flags & SWP_GHOST))
+		atomic_sub(1, &nr_real_swapfiles);
 	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
@@ -1200,6 +1203,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (!(si->flags & SWP_GHOST))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -2677,6 +2682,11 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	struct inode *inode = mapping->host;
 	int ret;
 
+	if (sis->flags & SWP_GHOST) {
+		*span = 0;
+		return 0;
+	}
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2910,7 +2920,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !bdev_nonrot(p->bdev))
+	if (!(p->flags & SWP_GHOST) &&
+	    (!p->bdev || !bdev_nonrot(p->bdev)))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3030,6 +3041,19 @@ static void swap_stop(struct seq_file *swap, void *v)
 	mutex_unlock(&swapon_mutex);
 }
 
+static const char *swap_type_str(struct swap_info_struct *si)
+{
+	struct file *file = si->swap_file;
+
+	if (si->flags & SWP_GHOST)
+		return "ghost\t";
+
+	if (S_ISBLK(file_inode(file)->i_mode))
+		return "partition";
+
+	return "file\t";
+}
+
 static int swap_show(struct seq_file *swap, void *v)
 {
 	struct swap_info_struct *si = v;
@@ -3049,8 +3073,7 @@ static int swap_show(struct seq_file *swap, void *v)
 	len = seq_file_path(swap, file, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
-			S_ISBLK(file_inode(file)->i_mode) ?
-				"partition" : "file\t",
+			swap_type_str(si),
 			bytes, bytes < 10000000 ? "\t" : "",
 			inuse, inuse < 10000000 ? "\t" : "",
 			si->prio);
@@ -3183,7 +3206,6 @@ static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
 	return 0;
 }
 
-
 /*
  * Find out how many pages are allowed for a single swap device. There
  * are two limiting factors:
@@ -3229,6 +3251,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	unsigned long maxpages;
 	unsigned long swapfilepages;
 	unsigned long last_page;
+	loff_t size;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		pr_err("Unable to find swap-space signature\n");
@@ -3271,7 +3294,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 	if (!maxpages)
 		return 0;
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
+
+	size = i_size_read(inode);
+	if (size == PAGE_SIZE) {
+		/* Ghost swapfile */
+		si->bdev = NULL;
+		si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
+		return maxpages;
+	}
+
+	swapfilepages = size >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
 		pr_warn("Swap area shorter than signature indicates\n");
 		return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958da3b5e74b63217b06e58ba2d3c26..29dfcc94b13eb72b1dbd100ded6e50620299e6e1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1005,14 +1005,18 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = get_swap_device(swpentry);
 	int ret = 0;
 
-	/* try to allocate swap cache folio */
-	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
+
+	if (si->flags & SWP_GHOST) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
 
+	/* try to allocate swap cache folio */
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
@@ -1067,7 +1071,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	ret = __swap_writepage(folio, NULL);
+	WARN_ON_ONCE(ret);
 
 out:
 	if (ret && ret != -EEXIST) {
@@ -1551,7 +1556,7 @@ bool zswap_store(struct folio *folio)
 	zswap_pool_put(pool);
 put_objcg:
 	obj_cgroup_put(objcg);
-	if (!ret && zswap_pool_reached_full)
+	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
 		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
 	/*

---
base-commit: 9835506e139732fa1b55aea3ed4e3ec3dd499f30
change-id: 20251121-ghost-56e3948a7a17

Best regards,
-- 
Chris Li <chrisl@kernel.org>



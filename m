Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA58CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9478E009B; Wed, 29 Oct 2025 11:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082A78E0045; Wed, 29 Oct 2025 11:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAD58E009B; Wed, 29 Oct 2025 11:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC40C8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B02E41A08E0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:38 +0000 (UTC)
X-FDA: 84051612036.02.4D559E2
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAA051A0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gA3W098d;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1touJCt8Ij13wXVlFKC93n8YCKM/wZXGXqqqq+QSOpw=;
	b=cVItJY/6CwV57XJMGeConGmSxMS8JiTrzEhr5IMGxQMvoUg2xR7TGTbv4IfqM+w0fV+8Yt
	qP+XPRrYh/cM0kxoEHQFp8pokVrtimKGYdyTIFj29T7n8HK6VMSrzIc8/FZ4orn/ll7EF6
	9O5MaOeX0hlzH+KZwacUw8zhYW4dWrQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gA3W098d;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753576; a=rsa-sha256;
	cv=none;
	b=rAtIiFUEe1vNFwUGwwV2xkHrfcoQaWG8yXVcoNRMYlkSfdCTg4YA5DesEckbUpJP813B+Y
	uWilulhNUjdNXkWabuYQNlAxN/qYjnpa0MzAc39P/ckl0w8JjeKqAKeslmwNqDiWFoEDsr
	xtyPYUI8wYIu9mb+SFxjTb1zqcAkeUI=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b679450ecb6so5632141a12.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753576; x=1762358376; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1touJCt8Ij13wXVlFKC93n8YCKM/wZXGXqqqq+QSOpw=;
        b=gA3W098d6D4e9uHtFrsb+tlDlJ0I3iOJZZcQ7R2YeN4SF022AdhUgaTYDMWwWFVwTU
         /Rz/7Ze3auQeNCF0k8QXYMOFxKWCiZwJhAe37ZMigt544HmKXL1xtYbxvffUTQ0uFt5Q
         nrNFtbk9oJiGuuBOIsMBLciyxJCUsFgDgADYVvLgyEAQyHCvFTChaTl1IorB3B6QxnDW
         TbtALTNI8LC9OwByS9VPDHfAv862gfnHRn+yCV82rRCstLlqDkjM+wfmU1mxo8gh+vaP
         HpUfx828Rz1YA3/ZFo5dVZ7hBcwbL4ukfKQYxmVqJ4mSdtQGQeoZWyeqXeMzCe+oj2XC
         hrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753576; x=1762358376;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1touJCt8Ij13wXVlFKC93n8YCKM/wZXGXqqqq+QSOpw=;
        b=dqR9wrsLbu4ycr5wK7Gtj3kH8MTC4OdT1mWG7HmHMMWL12NZXFE+Kn/BoOikwDVHLD
         rFSCACVG5gtkKkiygnltPw37Yp5oEkbzL3hekDm7Wv+kNJX57HGoEFZO9XOUSh2siM8s
         GTnoe0r+tApptmwhbAMoFUoYoMwD6mc1+kdBIYRyF6ihGJvCvr1K7Lm88VPOJUCLeXT1
         /5egXc2FzIaha2z5WI72Ev8Jm7vLhDK69tmQ/gA+9f9RsirUt1n/stDngjjzOEcAueMC
         /R43Fl50sFhPn5xdi7MEtdd6hGnwBuQIkTKEDtiRGA0h959TeifbvoSDuugZgAqLSKqt
         A0pg==
X-Gm-Message-State: AOJu0YwtpBojQknPnnYPsx18gVn25f4EgrEpJuf07nVtTomTa1iQqY01
	0AJ0nL+uqaMY9XinVQ2uF56I5CQmWXbGnLzuxvQW1LUF+i03D4v9CsSf
X-Gm-Gg: ASbGncuNtQIDTCDJmrdznL7QI3yPITL9Ho8q8lBiqoq3tEr9+1fUKnFdeO0h+N8YCFa
	Kto8S/eDu8sNcwCsMzmc4x+ErpVi+iyRqfjxJiObrHyAa6IV+rRuZKTZlIxmnHPL2qF8eAeZhPd
	ddAg427QZoKKtiWPAiNgXdj43df+zb2H3iYAxACYAyhfoiVcE8GC1mUuwgNzsH95KZyhQLFtlkH
	QEnG8YAppLIYl1rmKdwtMljrSw86ACMxrX2Fs+8el0aORSsmHkP68Pa/7JQXqPzx4iy75uaFg56
	9PTXA0/cuYDlQvz3dhowYoEjxIPv/GE+rcbC/8e0KslSP/k6TDJ350e6EqSt6Rv8a6Q3R7+IelL
	t8kHTJOLH4mTGZCyux09TvCRKfrzqiCsxHJCqC7Bbb4sjqZrm5MQ1gIIlZF6+Cmzg2AmwFy7ce1
	D0uIWGcO09gatwugXT/xEi
X-Google-Smtp-Source: AGHT+IFHuFprzRWbK9qS6JvIV2N1AbXu0GbLXktN8sr1Qqk543SOL3MlPU4u1zXhTQjIeIb0517XQQ==
X-Received: by 2002:a17:902:ced2:b0:290:dc5d:c0d0 with SMTP id d9443c01a7336-294def36255mr40105735ad.49.1761753575586;
        Wed, 29 Oct 2025 08:59:35 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:35 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:34 +0800
Subject: [PATCH 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-8-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: 7jgq8cgnfjgmixa164snshfq79iqqgj6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAA051A0005
X-HE-Tag: 1761753576-837208
X-HE-Meta: U2FsdGVkX1+EqwiA2InVYkKc74bHfawdPRvigFa7JY+paPAlwY5dfJ0Aumhbw28JuYuV31sP4rfOrNMosdYrn0L3PUQRJ0ywOX2cAaNOl47//85ikF/qVhE7Kc2rs1dZd9R80sIW1+fNWJyt3UDtW+lJ7h4xfckiHZ820jh1hdR43zIiE6nCerJ0Glvkx1HdLkw+0hXcHKmK/4YF6tNMVgYdfr/cqHe01b89vfuayQ6xgYVTQSlVODlECK/J11edC9VzCL6V46tGsg6DWGrsPj5jdWi4tS+yiJyfJRob6uaBFSNF0sAI6yIEmRnKD9mPHJaoekkI0k5PYj6d8Pa0wccfH9LQcFo9aBdnjdhvE4uTC37fdv95qWb4mVVIqbTkyfOVp2Z9cAlT7jjBKmCuueCYP2hr32mpoFcie4e+o+dkJSeuTbrXclljftpKJi0xUwZMUbiGA/JFFO8JeaAKz/PjgX+H8iGoHOEo6SAthIKBkDaNOf/NhOHbOrqtJY3XWalbQN2zcK/6DvqSdWK9m+qwBSJHCQ8hyKsMxvsJJXNvQ+T6TK6bWAgPs56cCgOygeGz1+QHLrxb/3ImXmZZo2z1b9zKn3zOyBuyIzBjOTcFZBX4/e9hpxg9XXINISSfTq3ymn8AlJmcwAtA7PU20GUuk0x6BLn2p07JSjr5pMJowAlK6sXbV1s0cBdhEiW/zvelXio6Vs+Hk/y/8OZNy0965cEBAGOg8UhHubvCTDx08r29U05dsGfnjrYLY+zZ9leFXxGa6QcocuRj+dYP269tbMtZr4hjBMV5/PUQlwdPskJJvz2ATTcJuMG9ryHxi526BRFVTuAddstmSHGpyecP2wdB4KAH43HpH+lHS8ecL5jsJSo8mKiELF/z3jOhgOILLP55uRZ75JFZ7MfjfBZFw7+eTqdlyCc7McVTeu/C4MgKqaLSj0hm/KJi6D3sbQbcdqQ4R9XXCoqADKI
 lub8fB9J
 GfDal107w98wzNYf7eKwKR0yxWI2qYMfT4Lnb2YXJpdschi2C8vomL17gTiLmO/2wAscWwS6C7PK/ThZmxYmTtAHhIp3zTm43TFAfHt3zSlTM6ip0XK6V9aHMBL5u3fE9IBX6KvK+URbFBbR0FKYVxtvzw6ovF/zkB0cnXTcwPSbsV13k931xvtEt3HxJ/sS0Rkj9K1t8wEM/vaZohbif7nRbFi6rvtAHm2dZBin+rIH7MCQbz1gKWo+ERCQ1hwdqtEkeLCtWnubgKkrN7OwkMCMBUPsVjDAwxaoOZQIBTgOo392PUx0a7Pfz7Ku6fcRqJhORkuYFXUtY11QZT8ltZMlSLh9A1rD4P0EnOYNhelGb7wWqMRTzkWvDvYthbiD9MsY00RV/+Pd6RZLUW5u3Re7eOrzza0V7V/JQm24lwQIYiA3GdO8bsSuiM4LdLXViyll0hpt0h8qalTAZTRm3NNKVUyl6HqeW4ihS6Lsw4VJi5EwzLalzrJmYRaZtgot78GcFsMrFkNvSzyvAA9Ykdo4M38uma1Zu2mbC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
belongs to shmem during swapoff.

However, swapoff has since been rewritten in the commit b56a2d8af914
("mm: rid swapoff of quadratic complexity"). Now having swap count ==
SWAP_MAP_SHMEM value is basically the same as having swap count == 1,
and swap_shmem_alloc() behaves analogously to swap_duplicate(). The only
difference of note is that swap_shmem_alloc() does not check for
-ENOMEM returned from __swap_duplicate(), but it is OK because shmem
never re-duplicates any swap entry it owns. This will stil be safe if we
use (batched) swap_duplicate() instead.

This commit adds swap_duplicate_nr(), the batched variant of
swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the
associated swap_shmem_alloc() helper to simplify the state machine (both
mentally and in terms of actual code). We will also have an extra
state/special value that can be repurposed (for swap entries that never
gets re-duplicated).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 15 +++++++--------
 mm/shmem.c           |  2 +-
 mm/swapfile.c        | 42 +++++++++++++++++-------------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..bf72b548a96d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -230,7 +230,6 @@ enum {
 /* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
@@ -458,8 +457,7 @@ bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
+extern int swap_duplicate_nr(swp_entry_t entry, int nr);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -514,11 +512,7 @@ static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
+static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 {
 	return 0;
 }
@@ -569,6 +563,11 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 
+static inline int swap_duplicate(swp_entry_t entry)
+{
+	return swap_duplicate_nr(entry, 1);
+}
+
 static inline void free_swap_and_cache(swp_entry_t entry)
 {
 	free_swap_and_cache_nr(entry, 1);
diff --git a/mm/shmem.c b/mm/shmem.c
index 759981435953..46d54a1288fd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1665,7 +1665,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		swap_shmem_alloc(folio->swap, nr_pages);
+		swap_duplicate_nr(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3898c3a2be62..55362bb2a781 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1522,12 +1522,6 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage == SWAP_HAS_CACHE) {
 		VM_BUG_ON(!has_cache);
 		has_cache = 0;
-	} else if (count == SWAP_MAP_SHMEM) {
-		/*
-		 * Or we could insist on shmem.c using a special
-		 * swap_shmem_free() and free_shmem_swap_and_cache()...
-		 */
-		count = 0;
 	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
@@ -1625,7 +1619,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1679,12 +1673,10 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
-	return (count == SWAP_HAS_CACHE) || (count == 1) ||
-	       (count == SWAP_MAP_SHMEM);
+	return (count == SWAP_HAS_CACHE) || (count == 1);
 }
 
 /*
@@ -3672,7 +3664,6 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3732,27 +3723,28 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	return err;
 }
 
-/*
- * Help swapoff by noting that swap entry belongs to shmem/tmpfs
- * (in which case its reference count is never incremented).
- */
-void swap_shmem_alloc(swp_entry_t entry, int nr)
-{
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
-}
-
-/*
- * Increase reference count of swap entry by 1.
+/**
+ * swap_duplicate_nr() - Increase reference count of nr contiguous swap entries
+ *                       by 1.
+ *
+ * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: Number of entries in range.
+ *
  * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
  * but could not be atomically allocated.  Returns 0, just as if it succeeded,
  * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
  * might occur if a page table entry has got corrupted.
+ *
+ * Note that we are currently not handling the case where nr > 1 and we need to
+ * add swap count continuation. This is OK, because no such user exists - shmem
+ * is the only user that can pass nr > 1, and it never re-duplicates any swap
+ * entry it owns.
  */
-int swap_duplicate(swp_entry_t entry)
+int swap_duplicate_nr(swp_entry_t entry, int nr)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, nr) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }

-- 
2.51.1



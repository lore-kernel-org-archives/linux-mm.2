Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC82CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2411A8E002C; Wed, 10 Sep 2025 12:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2328E0005; Wed, 10 Sep 2025 12:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092858E002C; Wed, 10 Sep 2025 12:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E50C68E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC0031163EE
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:24 +0000 (UTC)
X-FDA: 83873825448.05.4C7E208
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5AEA140014
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DxT2P83G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520562; a=rsa-sha256;
	cv=none;
	b=rvi+NQfl64Y7t8RclMyxfpEvCOL2++UNFnbZNq59ufUH9TjrjFsJvQEvW2nP4MuRjColyQ
	omgjl5WTCUzwwfD9IcyQBuJQ0hQM1/0WYigHRyoQngk2VOgtxROnFgIRtXU725sEQyD2gF
	9n97zOzE8G3+dp+wV/FmX+Colw45Sb8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DxT2P83G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520562;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r30iRUUJzVW6YjOo4TAiZlOld85R21y5sr96AWgus+8=;
	b=vLMI9VEQj4Vv9kbt7V7+gLaXXVC0AetoWfbikdFfyc0MLftadXaJ4ZWBunxZUTbZugLUHq
	bEse9/ilzsy+dfP4zIG9v0Pu+pL2tpx4u2CPkLcrUtVDmTN455PUYMxGWo1t08lzK0t3MW
	p4QAx3Z79JO8CK6XEoDXTqlDes6abZo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7722c8d2694so5967987b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520561; x=1758125361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r30iRUUJzVW6YjOo4TAiZlOld85R21y5sr96AWgus+8=;
        b=DxT2P83GRoj3iLnqbPTgsKmgz1lVYJ+nDvmgvjRFkTQYCwBzDhBzUWM5UXmBiDm7fM
         Ql3jeX0KmrLgq6PIzYeWTmUtz26j3zwDCQ7MleT//Ar5sR3EddrPfxfnex332wdOwyDz
         11qnARcz4qhkqpzL2S/lwupUWhCiLT6CNG1QPfgonJZPzVcziWUthXrZ7BDjdXL65M3n
         Rr1MKvXrWuuFOULjOcv0D2K5Z+18fU9BNdVCLhSIll8ICuiWxMUCDfe0EfhA2490Iyap
         SEzlSOy/Vi4P/CzbdIo7kCLRSmtzcnCEqRtQUsaiP5Kuc8G+nM2ke8fOx8MKpincAdik
         xwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520561; x=1758125361;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r30iRUUJzVW6YjOo4TAiZlOld85R21y5sr96AWgus+8=;
        b=KZxLQm7Jr9tFcEv5+vfj/Tv8MQBUmncRK74zruTBtzg9X++FV/YCL7DFLY/UNxbabV
         RzTNYqjV9wkE79HkaoXmWjBCG3VOnEq25/+FCPOdRY7e19AXBvW3M1zuUzQDApkKvza/
         33ClClKDBJhLyW/eNKkEyobhculxAT5d9YqdBI3pvOs5ke36WWFIBioYML6eiScXuIVp
         NS2+gnVjbcSKtwcKO0qVNjRUonGb3LbJVy7+/mPoCfg7JxZwOwqOKIG5mLqImR70UNH+
         aDdqK6GNePb+jR+aobYgdq1vmFuXcz23e2cRIOVCcUGsi+F9NUZNybcq7rJ3wBVI/gu7
         YRDQ==
X-Gm-Message-State: AOJu0YyBRSpzIvdhXknZ5MtYCZnBYkFsDzMAXbkxQPw3J9WTfkwOtdT5
	2HgGvphjPdzsDNC/F9xa8yYwolGBdDfJYIsuh0hBiQq8s/vMc2lVflbff/5CCp9Zg7g=
X-Gm-Gg: ASbGncshF3zoNA6dR3yv6BX1ccSFe99lmBZJTgC3CP9dI03IV0iA06KDv0fFMMfCced
	m1iPq/8JZP2hMovsYz/AUSq2aB6IaIG5Zltd+13tb6pptVgmgNGC9oEnOSCZLnWNiuMkhvlIier
	TXc+abT4elT9idhEDbsETTVsYTbTyP6joCw6x1OEpN6uWuSCwJJLLWE6UazVS9JS+eVEzQqMyni
	WOmwi0p89XDI7WTZeClH9kY3UskQ+tTSjt2PFNS3LmWx6Erx1mfRH4HJJxXMML2qHqLkJOAZVRR
	ISxqgKqbXdnGyru5YGlOVb0nkgwlWmCtyZzkkMSpfgN8SSGF4fpjXSMTntXEfqrkz5QRuQR6CNY
	OPJWRXJ2vCF5q4h6ubBDWoINpTRQnHA+QbopqKW2TrwRvJuM=
X-Google-Smtp-Source: AGHT+IG4rgicLdld9JX3OJJkcVKNbRft/Ys3FKlmoalIK9jozRWnjhDtssS7p6xY441+nTXDOOTp4g==
X-Received: by 2002:a05:6a20:7d8a:b0:24f:f79d:669c with SMTP id adf61e73a8af0-2534557a96fmr23074527637.59.1757520560630;
        Wed, 10 Sep 2025 09:09:20 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:19 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 07/15] mm, swap: tidy up swap device and cluster info helpers
Date: Thu, 11 Sep 2025 00:08:25 +0800
Message-ID: <20250910160833.3464-8-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5AEA140014
X-Stat-Signature: czo4ga8ux4p5amq9hbza5yuncp7of4zm
X-Rspam-User: 
X-HE-Tag: 1757520562-863268
X-HE-Meta: U2FsdGVkX18v/rZ7pr3zGK3F6GR+BQIBIsX3xx3jTYryg48RFwXHaPqfX24RVK02k6RjsYiWaL1aguHxIC8e/ehHZHetaEuFN3WjN04M1yn/0HfCjU+5KbyLwL9aH8ZAHKyGSHJk3h+ur095YFKsKT0VlkhMuZSxerW4oSjZlgCfXG0azHg1KR3fy1djHOvmxNkaRRS1sIAwWrmpdnyRRFf3Ll2glCsSQPIWHix0x2HhRkSNcY3RUDMomB1fHlTguVXZgzvOITawIVz+6wShy1GwHA1xlG/NBxGwbDYmx3sZM8AV0loLNnaKC9MGWRocUEZ8OjK1r8hJpi15+EK3lAY7bauYmV7E01472t91/Oe7eqnqcaUHymFQCh7sFo2Ujm70Pd/YAEzTpLIBdz7yC6SxWGFk9dzuh5T7Dsg2cK7gUSifjz/w0Nhwdz+auzNohb8LxZvz+p0/TWtpQkAqlq04TALec9ndwamhEfOKgJ8OyWbsH6DrhNEkf7817i02WigPFnkpQJBFPZqqfFVFBB0wKTDGuC1vLz1iBwI9vDz6qkm2SxzWoat4SNLJaS2xXXt+ZRXwlKqEGV3pgXraPVuguDKTXyEm/NC/hx/UkIuhNXLhBQ92MF6NasvaKxNFt+p5ENr8EXtIQVSu1gM7E6pkBR8fswhkpH7Uy0reC5lJRu578DhC0aP2J4kiqju9OIfwgyE1oAKAgu75Ios48n7WYmIBghjP6dGZthMWRPaGEBP7gvaRSUZqmmm/ReKPR+6uuthOejenJDA7/NJHPce/9z4HCo3etzLNzWUKt9GZnX6VM88QAXXWGSDfw1ISJT24l7egWo/SaCLPnwe1rGQDUQT0h4vFIqwZL6KN2sLTxI5EyDDUMrkLq0yGYt29EGRU6WkQWcT87ykwrryIsCjxcghGM8BH+MlIbCkPJRYlWmi7AYg23u4/ph2Z5EkaOkBBANzwoA+EKiSFZho
 xT8Uq29s
 BNBiscTDdHcmTTTEt2aTWGU9yh4h3z6k+g0yM0EUWp95iy/w6GsnzRvdbdS7Gr51xfewnVH9VdmvE0AYDy4ncf5P0oOXKInEK9o2ClAiHxDdUevu/l88tM4oznQnmxW1uJeUsXz8WB4cgNEOvnLNU58ebdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

swp_swap_info is the most commonly used helper for retrieving swap info.
It has an internal check that may lead to a NULL return value, but
almost none of its caller checks the return value, making the internal
check pointless. In fact, most of these callers already ensured the
entry is valid and never expect a NULL value.

Tidy this up and improve the function names. If the caller can make sure
the swap entry/type is valid and the device is pinned, use the new
introduced __swap_entry_to_info/__swap_type_to_info instead. They have
more debug sanity checks and lower overhead as they are inlined.

Callers that may expect a NULL value should use
swap_entry_to_info/swap_type_to_info instead.

No feature change. The rearranged codes should have had no effect, or
they should have been hitting NULL de-ref bugs already. Only some new
sanity checks are added so potential issues may show up in debug build.

The new helpers will be frequently used with swap table later when working
with swap cache folios. A locked swap cache folio ensures the entries are
valid and stable so these helpers are very helpful.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/swap.h |  6 ------
 mm/page_io.c         | 12 ++++++------
 mm/swap.h            | 38 +++++++++++++++++++++++++++++++++-----
 mm/swap_state.c      |  4 ++--
 mm/swapfile.c        | 37 +++++++++++++++++++------------------
 5 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 78cc48a65512..762f8db0e811 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -479,7 +479,6 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
@@ -492,11 +491,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #else /* CONFIG_SWAP */
-static inline struct swap_info_struct *swp_swap_info(swp_entry_t entry)
-{
-	return NULL;
-}
-
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/page_io.c b/mm/page_io.c
index a2056a5ecb13..3c342db77ce3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -204,7 +204,7 @@ static bool is_folio_zero_filled(struct folio *folio)
 static void swap_zeromap_folio_set(struct folio *folio)
 {
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	int nr_pages = folio_nr_pages(folio);
 	swp_entry_t entry;
 	unsigned int i;
@@ -223,7 +223,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	swp_entry_t entry;
 	unsigned int i;
 
@@ -374,7 +374,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -446,7 +446,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
 
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
@@ -537,7 +537,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 
 static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = NULL;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -608,7 +608,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
diff --git a/mm/swap.h b/mm/swap.h
index 138b5197c35e..30b1039c27fe 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -15,6 +15,8 @@ extern int page_cluster;
 #define swap_entry_order(order)	0
 #endif
 
+extern struct swap_info_struct *swap_info[];
+
 /*
  * We use this to track usage of a cluster. A cluster is a block of swap disk
  * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
@@ -53,9 +55,29 @@ enum swap_cluster_flags {
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
-static inline struct swap_cluster_info *swp_offset_cluster(
+/*
+ * Callers of all helpers below must ensure the entry, type, or offset is
+ * valid, and protect the swap device with reference count or locks.
+ */
+static inline struct swap_info_struct *__swap_type_to_info(int type)
+{
+	struct swap_info_struct *si;
+
+	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
+}
+
+static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
+{
+	return __swap_type_to_info(swp_type(entry));
+}
+
+static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	VM_WARN_ON_ONCE(offset >= si->max);
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
@@ -70,8 +92,9 @@ static inline struct swap_cluster_info *swp_offset_cluster(
 static inline struct swap_cluster_info *swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset)
 {
-	struct swap_cluster_info *ci = swp_offset_cluster(si, offset);
+	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	spin_lock(&ci->lock);
 	return ci;
 }
@@ -170,7 +193,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return swp_swap_info(folio->swap)->flags;
+	return __swap_entry_to_info(folio->swap)->flags;
 }
 
 /*
@@ -181,7 +204,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 		bool *is_zeromap)
 {
-	struct swap_info_struct *sis = swp_swap_info(entry);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	unsigned long start = swp_offset(entry);
 	unsigned long end = start + max_nr;
 	bool first_bit;
@@ -200,7 +223,7 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 	int i;
 
@@ -219,6 +242,11 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
+static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9225d6b695ad..0ad4f3b41f1b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -336,7 +336,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
 	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
@@ -560,7 +560,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	unsigned long offset = entry_offset;
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
 	bool page_allocated;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3bfe9cf06fd2..51c159aa646c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
 static struct plist_head *swap_avail_heads;
 static DEFINE_SPINLOCK(swap_avail_lock);
 
-static struct swap_info_struct *swap_info[MAX_SWAPFILES];
+struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static DEFINE_MUTEX(swapon_mutex);
 
@@ -124,14 +124,20 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
-static struct swap_info_struct *swap_type_to_swap_info(int type)
+/* May return NULL on invalid type, caller must check for NULL return */
+static struct swap_info_struct *swap_type_to_info(int type)
 {
 	if (type >= MAX_SWAPFILES)
 		return NULL;
-
 	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
+/* May return NULL on invalid entry, caller must check for NULL return */
+static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
+{
+	return swap_type_to_info(swp_type(entry));
+}
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
@@ -341,7 +347,7 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 
 sector_t swap_folio_sector(struct folio *folio)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
@@ -1299,7 +1305,7 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (data_race(!(si->flags & SWP_USED)))
@@ -1414,7 +1420,7 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (!get_swap_device_info(si))
@@ -1537,7 +1543,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 
 	/* It should never free entries across different clusters */
-	VM_BUG_ON(ci != swp_offset_cluster(si, offset + nr_pages - 1));
+	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
@@ -1595,7 +1601,7 @@ void put_swap_folio(struct folio *folio, swp_entry_t entry)
 
 int __swap_count(swp_entry_t entry)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
 	return swap_count(si->swap_map[offset]);
@@ -1826,7 +1832,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr)
 
 swp_entry_t get_swap_page_of_type(int type)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swap_type_to_info(type);
 	unsigned long offset;
 	swp_entry_t entry = {0};
 
@@ -1907,7 +1913,7 @@ int find_first_swap(dev_t *device)
  */
 sector_t swapdev_block(int type, pgoff_t offset)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swap_type_to_info(type);
 	struct swap_extent *se;
 
 	if (!si || !(si->flags & SWP_WRITEOK))
@@ -2836,7 +2842,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_swap_info(type)); type++) {
+	for (type = 0; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2857,7 +2863,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 		type = si->type + 1;
 
 	++(*pos);
-	for (; (si = swap_type_to_swap_info(type)); type++) {
+	for (; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		return si;
@@ -3530,7 +3536,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	unsigned char has_cache;
 	int err, i;
 
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
 		pr_err("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
@@ -3645,11 +3651,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
 	swap_entries_put_cache(si, entry, nr);
 }
 
-struct swap_info_struct *swp_swap_info(swp_entry_t entry)
-{
-	return swap_type_to_swap_info(swp_type(entry));
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
-- 
2.51.0



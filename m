Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91763CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C458E001F; Tue, 16 Sep 2025 12:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C7B8E0001; Tue, 16 Sep 2025 12:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14C58E001F; Tue, 16 Sep 2025 12:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8EA98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D169140240
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:01 +0000 (UTC)
X-FDA: 83895579642.05.3FFA65B
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 939FA14001F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GsR4/BxA";
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038519;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijfPPpmQ7FgeFcxxttLIRdmasmyjvNL+eokSGricjgM=;
	b=aNM2FwRB4CuV/4eUHpmIb1UVQWDjRghf1GXWsu2J8AXcElshXJbvkwXmtCWV6vZhZfHqEA
	qJZtregm8qsZZNgrU/M7hlOVnDQVC4x6Zp6UMACw1n6KYL0CJED5pRwGNg9t6//4ggJL7I
	mHBksKgpykE7Ec/bCgFNYtxVYn1A8fA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038519; a=rsa-sha256;
	cv=none;
	b=IkX5s8Z+H1FIzwsO4JogIidcfH4Rdv7GoYodhHZmuvU8EigjUXsrqVhj+xV4xZJ5qoynzq
	nEj3la2EoWhuhAGVlupbZMFub1mbWS+y1i8+e29yQ5BZ/66O87CIDyNouu58A2lod6VNXJ
	s7GKoxCzyVSCCrmWpgAPmoYBoafo9QU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GsR4/BxA";
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8173e8effa1so362478285a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038518; x=1758643318; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ijfPPpmQ7FgeFcxxttLIRdmasmyjvNL+eokSGricjgM=;
        b=GsR4/BxAFjyV0Znc/f/OwXPeNKBLSsUIOdAlyPRa1PHqcQFeSYYZvqz5VKDhva9Pr2
         s+w6EJBsqAhBTGglMEctRuhZ5xA2jQhk2hdyTxOzfyc2UlVDmOFmKBl3Zl6GVPwUEvo7
         82ibIjfS5sPrUVwtc1tUgHIRCvdkg8wJmP/FAa/U+i+PNfgVD0DeizFKjzewANbO3KjH
         jM1+CAieUqIBIXlvdmlbPAY3vhIFM1aCqhO9W1FiqjFBIwkXRI7wLWS3IXlLJAmOohh8
         h7UJPUc+mC50t3kXZOzdKzgi3+F1rNkx4iVfMlUF5Gt+ErlyvXLJVbz0ehUwj+I7x6b3
         wF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038518; x=1758643318;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ijfPPpmQ7FgeFcxxttLIRdmasmyjvNL+eokSGricjgM=;
        b=bHPvspiTehWEXG/VSxbvzUKrgwdttxgwzh28Z86m1B1sOv16R69sG6nPYSz2XYo3NJ
         piITQP9TiZ8lmiWJ3ITktXhbHfhQJZzyDZjz1vo9CoLvhvlIuLdH76qssyjYTY4h4ZQg
         CoFfIJ5PMk7hNwtmMRpwWorK1L8WXWtP0CqLYtkgJvS36ceFFyAOdn7naBosdWeIWrFr
         sj4RKepzkX8S/zazfZhiiIr2qO5zv/qY7W+tgOQdxIZCfSqjd253Se+6ist9F2ewdK4i
         N8rrFCj2N1Zx8kymsLhdVePJosZKx8ffVjGblqqu8I6hL8kX/kkTW970ElP/8xAHTom0
         eRMg==
X-Gm-Message-State: AOJu0YxIMO4LcigpQxzRKcgZ/pnu203/mJno8x3tTVGbzSAwSQqHxxy7
	CXRIEbEA9wScO8YqY317TdFj+rMTWqwhzMw4im6ssJV7OhODXMU4LAC5vQeKtP8Ekfs=
X-Gm-Gg: ASbGncu91Uk8ISlk42XGZixurQ+N6DOxymzzk73SSGYCIT7hgsHTb3iAVYKZ+2sarVP
	QaPHFaF7gpiNRwj/OuaDjXJYPw5DCgE82uirSmtJg7ehx174UQiw8T0zMppAd4kSxhRQdaCGLAJ
	ucRQMJwwf46mBplBtr9VxxiU2lBNg5suqeP1TWT+qZ4IkUYrdvB4yJ8vCYO2EmXTqY0dFXMaA7k
	UJA1LbuMcW2bzhyaLDsYBIaBjSxdz8vrIp18mFxFNl+/YOXr7poh+apqrQUzid1Qsnfz5+KvcwZ
	0LhSPp+yGOswKvTsXMS7v+AkwlvtNDbARrcRnakgoluWSi0AEfrmGSwy0juYPWRpXC9COsg8qWI
	vpIbdzqiQB5pRRFpil5T5ctY7Vvq4RSscLXOwj3q8LJ34bYg=
X-Google-Smtp-Source: AGHT+IEbIIDSZwRtvoVKhPN2WtJjiGBVdo+kKPMTpeHqkRuSxQdLAwxiaZUGn/i1oUTM2vtVJTkx2w==
X-Received: by 2002:a05:620a:d8c:b0:817:c961:73a3 with SMTP id af79cd13be357-823fd4190c5mr2502952885a.31.1758038516263;
        Tue, 16 Sep 2025 09:01:56 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:55 -0700 (PDT)
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
Subject: [PATCH v4 07/15] mm, swap: tidy up swap device and cluster info helpers
Date: Wed, 17 Sep 2025 00:00:52 +0800
Message-ID: <20250916160100.31545-8-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 939FA14001F
X-Stat-Signature: wush5nhqhfqq4smejujuyarqi9xmzz87
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758038519-485093
X-HE-Meta: U2FsdGVkX1+p6+YwPYIpeVHHo0LQEk2r6+Ye2cK/iMHOo0JHRvDR2MjUSjw5AyqWZci7RAHbSBfT27SjkPO4Tnvux8rRhgfzr9Q4MN95xDSMyJr3MfrFWmvZTgjWMjXiJayjGBHBW/JlbN7MFh80y7Gc/uqe+0ajuvw6/+X/pHKzuUsyQGJB8cRamRCQUFz97TXlDv4QRQq+LCBJHKtWOa/0/6E41EodTiPJQW+L7uY7T/l6EIzgmZNyvIYEhIdQnAD8dEoGmg04yA/fosiJjyXiG0BG/gbantseUrhMw5M4doaXn+ie4RGxjz3ZUZvw/m6sdQsBqkZ44GNXBrHyImERa6p93YuRHsN7rIIcs0W5VGvK2+RJT58MFtJwZrRtpwNH3pReNY+DSA7Flc5gdvzmZ5GLWztpp5+A8JdJB9kSlew2t9eh/SinjLuFdv9IvPup2eoEWmy3yVuAXZcLqkiIU4rHgCmcdFxGlR44ZlQFlXq8TaS01Swf11NaBCoP0W64BfovCx+xDGxGoyF4tmbF6e7TFtYPWqXUJhD0J1aViTjBN0z9MlX9oBmXcrsqdRcvXGxxBrsg6pwlwxCnDidyOwqYmfDrhuGxVzaCb2LiLhkygll6kXUDjotkc4Dp7UBEBhICinGb50cyGMhZSKb35/qdkaJqN6S6bsh0YWiZkO9P0gGGG+QHL3ePckF0J35ZNVZhyo5D51hJNlBUK5zrc1YHIIGqidKdNL76gsfZvlT2YDK2w2dNtZSzyF2Mz0yu8AHQNT+mjjeiyGQ9pnz/m9m1wljcrGM71z+KAeNtK5Q0q6i03skCK9xT1irfrXANHjfdY7paC7ANob3ZgyRTYp/9t6RtaLRy7Uq/X5/em77cyieKrVXuwG9LpLKX8laForaywVVfqWMB6eiM3XvWO+tmjxj7INU3nm5JmGOLvLapGww8gIt9jtAudsiC0DNbVVFAwInnNl326KL
 7hLh352P
 5xjjnAHkH6Fbx6SIFCojk5d/CVryoc6sNHAjqxZjxojWXjHaEDAsjB8CIv+CkSNXntLGi6cVGyt4R+W0O1DRXT0y7f7y3Wzmn0rRMNcx1aNDXyA1yG/oMZcJ4lBcDRBm5dBWpQWWRr694YK9PAcqYG/egvGrQmFAAd4Mny+Mdx0PHyvTlDfj/0uqAP6d20Hi4lPgW8ob95IBzIj4d31jauXjlF9X22TtIK5yyJGtZRqbqUQtBsJ7w72B3PRNtTVgFVWnZI7eOiMjrZY1Q/aYtfl+TwuVgVmjC0bTHJ/If38aLkcJkgkLB7GSTrrx1RAi/wRJAUWgnbE2tp1txEqXtYd3zFR31+ExlLbCTabAcZWh/RJ6U0/ohMWJRu/ie9iz33fWpmMwRCbTUmeqChl1875a2ReoAtkx13xmfb4tbg2ycwzc+jauKarlh1d4JjizJcRIXzA1Z5eT58ZFgUJYE8TuagLGMliM+MnQ82UaWiJUBdMMtAgqft7eCDCyfH3E/xVey1y2U2IUhxryExJOKVWBpINRtm0mkjJdc1eDLuVyZr1FsgfG+gAGMgw8MR1kEkNGrRvdpHvLrjtnUC30jq024bEfLxTACrE+2TGarDUMPzcw=
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
index 700e07cb1cbd..6f7a8c98d14d 100644
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
@@ -342,7 +348,7 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 
 sector_t swap_folio_sector(struct folio *folio)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
@@ -1300,7 +1306,7 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (data_race(!(si->flags & SWP_USED)))
@@ -1415,7 +1421,7 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (!get_swap_device_info(si))
@@ -1538,7 +1544,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 
 	/* It should never free entries across different clusters */
-	VM_BUG_ON(ci != swp_offset_cluster(si, offset + nr_pages - 1));
+	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
@@ -1596,7 +1602,7 @@ void put_swap_folio(struct folio *folio, swp_entry_t entry)
 
 int __swap_count(swp_entry_t entry)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
 	return swap_count(si->swap_map[offset]);
@@ -1827,7 +1833,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr)
 
 swp_entry_t get_swap_page_of_type(int type)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swap_type_to_info(type);
 	unsigned long offset;
 	swp_entry_t entry = {0};
 
@@ -1908,7 +1914,7 @@ int find_first_swap(dev_t *device)
  */
 sector_t swapdev_block(int type, pgoff_t offset)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swap_type_to_info(type);
 	struct swap_extent *se;
 
 	if (!si || !(si->flags & SWP_WRITEOK))
@@ -2837,7 +2843,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_swap_info(type)); type++) {
+	for (type = 0; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2858,7 +2864,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 		type = si->type + 1;
 
 	++(*pos);
-	for (; (si = swap_type_to_swap_info(type)); type++) {
+	for (; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		return si;
@@ -3531,7 +3537,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	unsigned char has_cache;
 	int err, i;
 
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
 		pr_err("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
@@ -3646,11 +3652,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
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



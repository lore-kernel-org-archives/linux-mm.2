Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9411BCA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11AD8E001F; Fri,  5 Sep 2025 15:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B5A8E0001; Fri,  5 Sep 2025 15:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BE48E001F; Fri,  5 Sep 2025 15:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6878E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 641A857D13
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:51 +0000 (UTC)
X-FDA: 83856148782.10.7786A06
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 628232000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1ufz1IL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099689; a=rsa-sha256;
	cv=none;
	b=wxHs0xZFXWSc1IEoMYQ7XP6/fw5iQqO9T1okhWgsC0cglnbFSJGER/+KJQfEoyWh75ZYMH
	bbiN/nVXhGAfRV9XYr2JuhapZEL3MB/oErbnxKzHFTh9kkNM6LaA2nnFHpwFgVSMQgQZm/
	ETQeMNR8PQ9/J7stnAiYEH83xu43WsM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1ufz1IL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099689;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wNWJIsRurMOO+0rzGE8dlFv4uZu2nZpfcpjb5d40uU=;
	b=p4smKwE599dy5hObGa5KLDhvfJyRw2iI5IJ2ZwLQFToaeKcVOA0KsUoUHCHYpQi0i1Gv2h
	Dyfq8fuNMvWmKV/o21r7fk/UoIAaU/5p4o//BIaDVIHgJQYL/DVdzlH0TBTWlT/Rb2InPy
	8wl3BgXimxUUmU0O6skhmbjPAHcb+wA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7723f0924a3so3402833b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099688; x=1757704488; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7wNWJIsRurMOO+0rzGE8dlFv4uZu2nZpfcpjb5d40uU=;
        b=k1ufz1ILGTl5aZPP7gM7bjucQ4tnbEcdgPvEYH46sEIr0FmTiWAxmCAvgA/tG4CZPj
         4mKSZKKhUBIrS4gWRe8TyAPz9PYEr/Q6u4Z3C+wUcPFv8xQhgQNncMpqLDqVDmQl9Nve
         HoUPCxNbITc1VzB/XM652YlUGvBG3Ds4bhFIqLWGZDRQrDOAWAKJ7JByPV+TrjQzTdCS
         b3fuN3R/k1vhKZDI7jOBeVHan2fMYE9ZZP1h10LghqociIoSaVY5l2LjrgEjJ/9VpXvY
         9AMmlix2pZyT4ITuxzY7Bp+xi2zI2fkG+W9uc79oen18SH7QXzjMNq3DuZjF+HUPOmWT
         7kfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099688; x=1757704488;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7wNWJIsRurMOO+0rzGE8dlFv4uZu2nZpfcpjb5d40uU=;
        b=j3yDQ+pAjwa2K1U7qsYGR9RbglCKy5/mc1/YjQrpFsD8S4M6u3h9qtJ/4CJj0rS3xs
         tY4QpNq5gxuVKiiZFpug/eIrVf2M+qf0RGvB+377iJfFEvyOeCrVOBGy7umQfr+VFqol
         HmDmWI1VtQ0Xy1CZIWuCe/HUFG6hOKALC8+p/LCNaVmXvvGsjlDCbTZNvM/CUbSwlBbT
         LoPrXp2dDBzgrNDpTdvnip3x8njhW0NLxhLWqwPM3kTNu5Q5Izv1TS38/VXsWUlfhebl
         /LPdwnlQOEw/D+nDElicbhtquMuP87RcYgGCfQ/8ofSiLyG8OTgwcxedGqifNi8p8gp9
         AUHQ==
X-Gm-Message-State: AOJu0Yz6Gq3XQcYktc87ad6HwhpkGv3rNIGvv9BPbA5m8krBtgI9uPFs
	A5Wyky4Amo2XecgC1V3j9mepDafSSX1MASaWSGe0WYpQDwgzxliZRyuYQF8xZ8mmbvQ=
X-Gm-Gg: ASbGnct0YlClrsHL8GgtDVrh/hFVMTbJfl2z94UYlWbQRyNqZHJOJUG3Uz8Tpl5hux9
	L6TP1jmjUrQFk5DWm50+DVZqigm3mkMWSb4czHi2xkalSKA/uQGDXmTfQQ5n0BQgjZGJnmK9XrU
	waZCAmyW0WLvSjR6rf03jj/Em865VymwPRZV/vw2HGdALxMD2GmIas2sWRikeLpOrPkOB1FecxI
	/x+A3JGcmvFU8xKI0Z7OVAWZNbt+Ee9Yvz4mNBk/CCBL7b2gW2L2sS3mOVnvurARO3cip1RhXcy
	qN/uxjGKIyPpFEqbtyLENe/OMQiMjpNjO0Pvdk+IBpsHIwFkY8eKJvVgWtv8Fc9+zy+0yYiZLKs
	cv/RGfDnskAGy5k+Dg64ooCdwExm+njMcxbWIIc/sZ2O3iX0=
X-Google-Smtp-Source: AGHT+IGdgRlly4oOAAksandcKOQYiB7a6oz9DT+B8AQxv8TwGzWAE0KmCN/5UsjAGpOC4XEKyoieOg==
X-Received: by 2002:a05:6a00:300d:b0:772:48c5:c758 with SMTP id d2e1a72fcca58-77248c5e13cmr25141547b3a.8.1757099687728;
        Fri, 05 Sep 2025 12:14:47 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:47 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 07/15] mm, swap: tidy up swap device and cluster info helpers
Date: Sat,  6 Sep 2025 03:13:49 +0800
Message-ID: <20250905191357.78298-8-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 628232000E
X-Stat-Signature: fr5kkpyh9b4edd3jdbhk897os4nsxqja
X-HE-Tag: 1757099689-543435
X-HE-Meta: U2FsdGVkX19Cf/qsBxlJQlxLYBUpBihr9lmUsF1HECAPVUHtyVYky2TTEB56MX2BQmp6CbhFrl0lSVClWo/vHPY2nSa3ZrPbBo/xl2Up+SlkwkP6E2hJmubj9W6e3ijRyB+oj1KuIBRq6qCPuP5LjokhQFAx7Sl8Y8aBjBqpPWzMqcefR2iIK0+L/FUopfsdG6WPHaKQS1ih37AL8GUrzASZifS6ksI/IHEbcOqQvLaIQnvRDnibqQDx1F4Dzu66PCCoserA4Jz3DjMoIOocE5jn1jPCYliNIzKAEsoNdLjvXCcNtA13Du79OtPEf+U4uRHEW5+qFTGyugxVUfMlAf/xoo2nkcUuV/cccHb2SeElFDlt1ghutuwwV2d/PYbffB/1NlyvCm32nBfNqg6VnUhBauNWtE/t/SMrRUw56X3QZPs88j/Vxf5i2W4KRh8IR6OQwndMeUdkvzaKC9FM6NsWIjFDRikEFblZbeQMqNslYFfJa5qxJ0RBYuk4gyeID02cJPZrjPhgZbQMjz9xmC3i+vkHuS41fPetijj8QOFWNINQbtjZJyKj1USVTKqSGksnj+cWDwJLGr7j6OHKwTwz7pUvfs5elyaOcnMG+5A5GkRRGZ5sc7nkC67VLIKg4ZS/BZU5P8UoNvk1Kgxa5Z0C4pAuvZm8lkP77k9nr8u2IhYpugSVeL4Ysi888NF2IAwncXEiaqRcRxemCH/xulk7pNJE4FAzUEqmQKZIaQStmiLHRxqa/YNycU1YH5H65B1tXURor721V5YBbRBUAhXorP5qa6JobKYfuhnoGvuGMSCF97wI7nNT4kBn7MzJpz5WMSg66+kgevQLuaVlgmbXRpRWBHQns1ZaX1n/twGgjrrfSmr8gBytQrjcBDHum9uzP0HNT8XkWGTEV7mdtLgUKHw5dA9Fhk5KX8B1mqPW34cZ8VlqF8r76NPpATR3uOPHD94S1Hn/p8eKkve
 xMaHWkZr
 uZ3hSQNJ7cithw/jR3cO1mJ/zbzUqysUr0f9/ol7iSR+Z1cr9RM7pvMOBKBZiwoV5d+HUsIQQ38s+wfFSInaG0hng04HcBpjLDqRX6N1LvBpm6/8Ejrhtd9F5oZq8NfZXD0BXx8Dkcb/mBMpJuCpvEsrI3/4rcXcOzbdxGtgBywQ7JiZS9Ob8/VSj1ypLyfxnYegI5KhOv0cA+kixEc6WLz5GLhIltCswRrGxTHefeGyA7lRs/R2XaJzx9bWIWjl3tB+Evm1GGownJsViEALZhMSZJZkHFMdVZ05ThcVb4CpzMDqOOHvJkvJnPvSJ+I5P63WJO/ToPpyrEuKnkGlejtr/3gtr9oXWCb/PfkXyPGQlcJmtXSmGZ7RXaqtUyEEmBv/hv1wAflWoyjbiEw5NJIW6za3WsDLFTzqF7aVf9PUFhQ74TUJWDVT/VgIAlae2n7ZcXLKMLJ56V200sdqT4KypKcVDOjdM8RO7VYR4l5O5h1+aLJ65KrOuyZZdTjxruvJ68fsXcNN+esTCcyLuzu4sFAWWGhFqADiawTpka+fYDlCwQjjHUYc2XXyQ5TlbW+iEsqYDmOy7OdRdAomo1DH4og==
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

Tidy this up and shorten the name. If the caller can make sure the
swap entry/type is valid and the device is pinned, use the new introduced
__swap_entry_to_info/__swap_type_to_info instead. They have more debug
sanity checks and lower overhead as they are inlined.

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
---
 include/linux/swap.h |  6 ------
 mm/page_io.c         | 12 ++++++------
 mm/swap.h            | 38 +++++++++++++++++++++++++++++++++-----
 mm/swap_state.c      |  4 ++--
 mm/swapfile.c        | 37 +++++++++++++++++++------------------
 5 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7e1fe4ff3d30..6db105383782 100644
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
index 39b27337bc0a..a65e72edb087 100644
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
@@ -167,7 +190,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return swp_swap_info(folio->swap)->flags;
+	return __swap_entry_to_info(folio->swap)->flags;
 }
 
 /*
@@ -178,7 +201,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 		bool *is_zeromap)
 {
-	struct swap_info_struct *sis = swp_swap_info(entry);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	unsigned long start = swp_offset(entry);
 	unsigned long end = start + max_nr;
 	bool first_bit;
@@ -197,7 +220,7 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 	int i;
 
@@ -216,6 +239,11 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 
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
index 547ad4bfe1d8..367481d319cd 100644
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
@@ -2835,7 +2841,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_swap_info(type)); type++) {
+	for (type = 0; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2856,7 +2862,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 		type = si->type + 1;
 
 	++(*pos);
-	for (; (si = swap_type_to_swap_info(type)); type++) {
+	for (; (si = swap_type_to_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		return si;
@@ -3529,7 +3535,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	unsigned char has_cache;
 	int err, i;
 
-	si = swp_swap_info(entry);
+	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
 		pr_err("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
@@ -3644,11 +3650,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
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



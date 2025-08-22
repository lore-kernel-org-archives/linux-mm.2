Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F50CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A128E000A; Fri, 22 Aug 2025 15:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B518E0003; Fri, 22 Aug 2025 15:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11518E000A; Fri, 22 Aug 2025 15:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAFAB8E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 386B0C0311
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:12 +0000 (UTC)
X-FDA: 83805361584.27.48635D6
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19180180002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=boCMaIeC;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890470;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KKlr1vdm+W9XSUyQPRVxPSMfJ3nwxE8pge88LauYMw=;
	b=xvKoRGkJ+uNwNUMVvkegNZsh0Das6LqQ0vs25ji6E9WK7+lI9vfjDhSK9nTJmsLf4rH7DP
	IvWwKT6mXv6AW7mQ8fbSjjvkqsxF/y5qoOqs/efr2TCujlDf2/Xdg72V9xH/vsfzQUFn6B
	V+tA0FpjuVmnVFSX+QIaIr05vVBS/uE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890470; a=rsa-sha256;
	cv=none;
	b=5TlY3zcTQeLsMuyxR5yZaQTsRUMSSMMeW2EPR2T9oaJvpphZIfWB3hlxwNK4mHsNuQNNr2
	5Jn2pWRnHsYxI0UESqGdnoId7LV/6Yy25VKjPslYuMCMYdOyJoxZSDj0kvoNlV/WjsYjMo
	eGlxNmb6GW8BMl+PCDBpFsTiAXPikwU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=boCMaIeC;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70d7c7e96bdso12586026d6.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890468; x=1756495268; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9KKlr1vdm+W9XSUyQPRVxPSMfJ3nwxE8pge88LauYMw=;
        b=boCMaIeCUi4iGNlq/WaIQlcF1sYhjsQaqoFjk4g8yWebuBmDSC09ty3wtHEmn/KqFf
         69cCFxKeFXFYD1u1S7OMP+nl+Kcw1MiKxpYBiWW12WFYxWSQTQEMcjODia6tJzaueZ85
         zo5uPUmqdZ1thmoZV3bviJDAwLxqQZfrb1MoMc4cH97p72jmImhR+Ci8TvQQadYYKbfu
         4wu5RORB6Qn0SyjDyNwP9tzyWiO8vlpTLw5YO8oZ6Rx97QKcHlIn0GJlRSl+4kPJghhQ
         CRa/R3OvOejjGN6pX7eit3XeaC3l+nh2fkVA0zuslpNXw0h2iL8iH60z93SRCQ/r3R4L
         k42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890468; x=1756495268;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9KKlr1vdm+W9XSUyQPRVxPSMfJ3nwxE8pge88LauYMw=;
        b=gvodnIvdyb8ISYsiWNPqD/4Mq0QpTylZ4vjiHtol+NMNK0fwB727IDsN3AaQqd17E4
         2rtgiD4SEsVrwO9A2m6UvJH3DhoYHGDQqyDAk7pgqRg484Rw+r6NfSAFHwe9+6Kd1piZ
         kRdV10BF5lcZC8dYM+5kOycHiLTfMD8CA1/e6irRniqb4Ql+mWp3sELlbphpktKgLh2J
         Q0nLIe4vg33eiyrkEt5VhfyU7YVP9gef25DzbYHmN7ogIzMnMkx2jfmLu5BJNoWvQWSx
         AoE3e1YSlenM9Jf/fEktYDZNfqdGSlJ1Neb2mqCXHenz3kC+BLESht5yCR8QpWWMNmns
         XCgQ==
X-Gm-Message-State: AOJu0YwsnDCjYmUJ/DHu9puXB0ucIDFE4FB2AGdmlUkklqQNGVYxYKBC
	KREnLP5ed90GkcwG62PRIM0W/SbIe6G1TGiYnw9GNj189wwK0fcll9lVqpzZjOMjQ2c=
X-Gm-Gg: ASbGncvDNqeeMzKMJFT/tbSIaFmRLn4Yt2FDV4BJNFCBbAtsFcGh/5RP6UkH9AaJrOb
	VuzsMXF/0qhP8odzKQ2wIrXHQwN+Isu+yY8rWq8ezi14fKvBPicZeUcyCtrE865egwoKv2noYfp
	279/OpZ33KcBLmpB3OBNWjTAaLHcHrUPFkO1jOu2ZojqlO0vYp8MQ27FEzM0QbmDi52M0ds2ZL0
	I6H65gTw2hWoEDGmCOdX02c94a9kf9OwYC+EB8+6+764Y3HGf44QvHoOn/ls6F4/At3lejtlWpQ
	gNKcFuyozWPqt9SlRhW5X1uURiZQjWd2wiiCjletJCCr3Og/8YdSCf/0EQKg15PkBGWFXUoj5lW
	7gJ8nkHW5bWqZ8OubmOFGYBbrpgyAjsnDxe9x/zRFas8=
X-Google-Smtp-Source: AGHT+IHgYS0Hlci+j0Mlm6zl7ZxCN8MaCGGQNiHPLXTtkunhsWsiLD4KH7akKu/0X+oTS5atNzCeRg==
X-Received: by 2002:a05:6214:6211:b0:70d:9e0a:5ab1 with SMTP id 6a1803df08f44-70d9e0a5f2dmr17911516d6.22.1755890468302;
        Fri, 22 Aug 2025 12:21:08 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.21.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:07 -0700 (PDT)
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
Subject: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
Date: Sat, 23 Aug 2025 03:20:18 +0800
Message-ID: <20250822192023.13477-5-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19180180002
X-Stat-Signature: a65xoet1trn6opfjodfjtuc8mq4aio7b
X-Rspam-User: 
X-HE-Tag: 1755890469-690092
X-HE-Meta: U2FsdGVkX18EZkS43XIcBh5uMvntg4uour/DSTaklyPkPqtoVR0knBuijd4nB0NZdZTHGUqc2+5v3tMrNUdN+nrN5NUsLVjpkaJjxnpLk5AzA/CcpuLaT0s0Bh4ADi/qWNJYEjGQCCew6NjQaIx4ODEI023RosD5e+M/krhaBG2x3LrNgDKfO1KaIgg92luDMfpgGbjoMfViQc+2rmSoqf20uATTjpzwoL33DyaAczwMKpX3K5wIkLnSEOcIB3xLHWt0Un7Og0Kedv3O84xuEay4QtWaVxAsYe3n0HtA8figzD1Ypa95tXYrJiItZx+z486Ed9TO5CZUbE6ct9RTXa5K8jCUzTOllxVNfm+JCI0Fn2f3DvF4lFHIthhcZM2E0HEm22jXNAWV1aJtuzYkVE7DqUvWZiWA4DZgsV6LIKd0EqLSMyGgNJ3yaC1+GxB//4WWNl69YdkFgc4bkcQzXSCNIrR5aiYIKU2tmvEbylGdDwP4pQUKa+yTCLru/aMwJgqGBjRHa1EroPXL31/ANQ7d/v2Pd774mdQbA01pkq2l4OskEPEJjOo5wdLQW1c2805R0HuVTHJKEcWFzn95zBSpSywdw4bOpryqREJ7zA8u43U8gDKaKneh1MglUEGWaB/ShPpL8MZd7Zgk0OKaRNkC85OAM9mWd7q0JxrQXANfCltsEuNuodrScNn+BjeCd1Svv07xFG8Qs06jMjtikqmgWpPKRAuwTM8SoedLS0ksYFb8WkLnIjS+LS4qJG+REkCtJO9phebwd3z6+P2zU3ZJkgWnlkULros+JqIykHpHQnkH14bLqLl2EBk2gjse9wjugACS7szBKLuQE3hyvf8kETiT9D5BoFQMhGdcn2O3WRuz6SqACCGDFIspFqzIEfDirHBYDfimsXffRGH8MTGzvPPrQAcsmfyWJgKzTe1kCmbrtY8hb1CpFGP0tbgM/apb4xWO49vXL5+IgB/
 t9lFwKOw
 JPr4RtVsL0sqGW6QBWolXPrkdKa2DU5rETZaRLlro59nkh4mvTXmUtaW6CcJt6ElmQDqbpkPG/ZNu5ixWyeKEjz8lrwmEVcrmLt8z2cIv4jNL2KV2oHip0HrvVbn2qWS3SdwXVx5aP/4WRpEhCvZH/n72LIShP9AmQMIfNE2iTcz+Qua6qhx4MLTko+O4RK7RJB5PZa3iB2W9i5CTUQccjtYx/rcr6abXgbtiZIUFX6jkA/PVEMESaHR050lhPLEjb1GbogcPtZ0fgQYoi83dNSNOkqk8QWoTwRFL1cdpjmoxUz5pQMAeloGfjNSu+jeHbLLn46kvezKPBFxAH221Ul0RXaxbUQdqt6kUO8eAC0gp7kRfbWpOydfM5F4qKiC50Li4/4IyAXoHhraxuxgsR3+F1VOCF+7GUB3YU6ZmOf4DUjVAFZ/WEIKMX6UX5nzqz30slGUEHx0OmmVPGzjS82DwlrbJuH9CCwYPd2D5e3dzFaEJlZbpw8LhrGmVBQ4QpLWL4NqDAy+QN82zGGs+Y8ivH2W1YQf5EuSLRCBiayPZp54SvV7Z9zdDJOaABNMjOITwxBNqC8u31d5iA1wYAxWMM31+MdH2gg4/vyL8sGC669+HD7M4AYxN6ZTdP5EYj/7QirbQCAw/sVc=
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
swp_info/swp_type_info instead. They have more debug sanity checks and
lower overhead as they are inlined.

Callers that may expect a NULL value should use
swp_get_info/swp_type_get_info instead.

No feature change. The rearranged codes should have had no effect, or
they should have been hitting NULL de-ref bugs already. Some new sanity
checks have been added to the debug build to catch potential misuse.
And the new helpers will be used by swap cache when working with locked
swap cache folios, as a locked swap cache ensures the entries are valid
and stable.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  6 ------
 mm/page_io.c         | 12 ++++++------
 mm/swap.h            | 33 ++++++++++++++++++++++++++++++---
 mm/swap_state.c      |  4 ++--
 mm/swapfile.c        | 35 ++++++++++++++++++-----------------
 5 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 20efd9a34034..cb59c13fef42 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -469,7 +469,6 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
@@ -482,11 +481,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
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
index a2056a5ecb13..bc164677d70b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -204,7 +204,7 @@ static bool is_folio_zero_filled(struct folio *folio)
 static void swap_zeromap_folio_set(struct folio *folio)
 {
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	int nr_pages = folio_nr_pages(folio);
 	swp_entry_t entry;
 	unsigned int i;
@@ -223,7 +223,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	swp_entry_t entry;
 	unsigned int i;
 
@@ -374,7 +374,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -446,7 +446,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
 
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
@@ -537,7 +537,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 
 static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	struct swap_iocb *sio = NULL;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -608,7 +608,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
diff --git a/mm/swap.h b/mm/swap.h
index 223b40f2d37e..7b3efaa51624 100644
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
@@ -53,9 +55,28 @@ enum swap_cluster_flags {
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
+/*
+ * Callers of all swp_* helpers here must ensure the entry is valid, and
+ * pin the swap device by reference or in other ways.
+ */
+static inline struct swap_info_struct *swp_type_info(int type)
+{
+	struct swap_info_struct *si;
+
+	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
+}
+
+static inline struct swap_info_struct *swp_info(swp_entry_t entry)
+{
+	return swp_type_info(swp_type(entry));
+}
+
 static inline struct swap_cluster_info *swp_offset_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
@@ -65,6 +86,7 @@ static inline struct swap_cluster_info *swap_cluster_lock(
 {
 	struct swap_cluster_info *ci = swp_offset_cluster(si, offset);
 
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	spin_lock(&ci->lock);
 	return ci;
 }
@@ -164,7 +186,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return swp_swap_info(folio->swap)->flags;
+	return swp_info(folio->swap)->flags;
 }
 
 /*
@@ -175,7 +197,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 		bool *is_zeromap)
 {
-	struct swap_info_struct *sis = swp_swap_info(entry);
+	struct swap_info_struct *sis = swp_info(entry);
 	unsigned long start = swp_offset(entry);
 	unsigned long end = start + max_nr;
 	bool first_bit;
@@ -194,7 +216,7 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = swp_info(entry);
 	pgoff_t offset = swp_offset(entry);
 	int i;
 
@@ -213,6 +235,11 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
+static inline struct swap_info_struct *swp_info(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index be0d96494dc1..721ff1a5e73a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -330,7 +330,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = swp_info(entry);
 	struct folio *folio;
 	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
@@ -554,7 +554,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	unsigned long offset = entry_offset;
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = swp_info(entry);
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
 	bool page_allocated;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 618cf4333a3d..85606fbebf0f 100644
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
+static struct swap_info_struct *swp_type_get_info(int type)
 {
 	if (type >= MAX_SWAPFILES)
 		return NULL;
-
 	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
+/* May return NULL on invalid entry, caller must check for NULL return */
+static struct swap_info_struct *swp_get_info(swp_entry_t entry)
+{
+	return swp_type_get_info(swp_type(entry));
+}
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
@@ -343,7 +349,7 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 
 sector_t swap_folio_sector(struct folio *folio)
 {
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	struct swap_info_struct *sis = swp_info(folio->swap);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
@@ -1301,7 +1307,7 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swp_get_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (data_race(!(si->flags & SWP_USED)))
@@ -1416,7 +1422,7 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	if (!entry.val)
 		goto out;
-	si = swp_swap_info(entry);
+	si = swp_get_info(entry);
 	if (!si)
 		goto bad_nofile;
 	if (!get_swap_device_info(si))
@@ -1597,7 +1603,7 @@ void put_swap_folio(struct folio *folio, swp_entry_t entry)
 
 int __swap_count(swp_entry_t entry)
 {
-	struct swap_info_struct *si = swp_swap_info(entry);
+	struct swap_info_struct *si = swp_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
 	return swap_count(si->swap_map[offset]);
@@ -1828,7 +1834,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr)
 
 swp_entry_t get_swap_page_of_type(int type)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swp_type_get_info(type);
 	unsigned long offset;
 	swp_entry_t entry = {0};
 
@@ -1909,7 +1915,7 @@ int find_first_swap(dev_t *device)
  */
 sector_t swapdev_block(int type, pgoff_t offset)
 {
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	struct swap_info_struct *si = swp_type_get_info(type);
 	struct swap_extent *se;
 
 	if (!si || !(si->flags & SWP_WRITEOK))
@@ -2837,7 +2843,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_swap_info(type)); type++) {
+	for (type = 0; (si = swp_type_get_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2858,7 +2864,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 		type = si->type + 1;
 
 	++(*pos);
-	for (; (si = swap_type_to_swap_info(type)); type++) {
+	for (; (si = swp_type_get_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		return si;
@@ -3531,7 +3537,7 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	unsigned char has_cache;
 	int err, i;
 
-	si = swp_swap_info(entry);
+	si = swp_get_info(entry);
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



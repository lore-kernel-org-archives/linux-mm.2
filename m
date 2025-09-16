Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63EFCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED2C8E000F; Tue, 16 Sep 2025 12:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4918E0001; Tue, 16 Sep 2025 12:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA7F8E000F; Tue, 16 Sep 2025 12:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 177C98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D51A7C0250
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:27 +0000 (UTC)
X-FDA: 83895578214.30.5EA2CC3
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCE68A002D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PqXagJOZ;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
	b=y8lJxLuw+fwVjJotast2aW1EDXi0oDDuhj1C6kjWcnUJdm1Rl9kfpDmCZaRkRkdUFVEf3D
	jnd/2FGUGjxPuLW8MoU80m5j6LCReIbD4u6+zyXnmKdgn6IBgxMu0jqsjc/4y7BxcXoiiN
	L/Y8fkPLWaPDt24LSx7lrkJvNU5wC0Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PqXagJOZ;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038485; a=rsa-sha256;
	cv=none;
	b=hb8MO9Y6KSW/c7iOsrvGAifLNwMsfAlPOoO6tV4KRx3z6h+XIcEDokdazW/uV9gji3uIBk
	GH8TMEbyEIOYyR1Gn+l92shYiU0DfQaqG/k4Wmc5EJCJaiEUSxnX8wBWSyWTwc3ax3gQr/
	ApBhnts220c6L52EX5ZiVIk7oO51KD0=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8275237837fso343203385a.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038484; x=1758643284; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
        b=PqXagJOZU2Ov993MxoK02ORSgThZyTy1mcF3EoUMdb1d4fYPKlBso60eBLdjFCGpJU
         VFJoaj8FgNFmPYzgstKHyy2rvxE5zbHj1rmttHzo/MS3cED2KDFc/OaC2vbSmMUSLzfM
         9YyrY22tzwIOiC2DXxmQCpadD48qxrmgeC79boMAPRnS/TtkNtWSFTm66oJ5nz1P4b6D
         3lKHL/1V+FPMjiDtp19PFNk033YbtfSPgaOdmZoZQiSpNK5ubfZHiujtCwVUvUM9Ftiy
         se2ScErFfcCVD66XnQJaDVlpf9gFVgiOOevZ9yK1Cv28M0MVaO5W9zmLTaBycwD++yO3
         +yhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038484; x=1758643284;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
        b=IdNze3P/qblWsvTocr2glFtKlQJMFEiLl4bFImAuds6ob6LTuc+dc9nevTDGMKC+68
         pf2ois+xg7Odaxv5zo4gZJoWJ+/VYi6odjG1121X1qkxzI3KFoq8eFYq+0F6AZRWtI2S
         4rG7+cFhKxa7jkHtVJi7tA+nzPIJg4904G0NwibX9f5Lvn+cEz7myd1fEieHx0K+E8xu
         KojibOvNuSqlZvrVhxPzlSl55tCnlqs0ODAG09prbEGHKFnZlxc/ENTcS5SwYDiGHwlu
         jV3w5tEzJcnWDML6X6fpIAoAUB/geOkLkcnIkpGC/YmkitD15Yx0x376hv7nAMU7Pdgn
         NJJA==
X-Gm-Message-State: AOJu0YwUX7xsYLQwA4f+Pk9ZzomgbUyaKq7kPb6qlhrbICHw7L+QE33i
	NpE5idMFhP3utI4UX6ehG0OLusMCfS+Q+wh62O80t27denReWusN8OrR9Icy/50yNm8=
X-Gm-Gg: ASbGnctcSxwmm3dJD6TpfkLbSqXRu7ARSqBvruJyEjprEJd9g/sP6SrHdPx6Ywi8DaA
	oZNKqnSyUjuq4fP3OfkFZQ6vg28DnUpCe+XLcBhBLftkdvGJs2+69p97YDoMXZju8+KjhMkIyu/
	mZxse2zVLXe4FhLEB3rxSgzJzug4v5SKbZRf2MYMDpVFK4i9vVVqd8bn2R2rZ/OInYrx3MsLoNe
	v2vXYgzVuDoK3l933tm5Rw5sF9UwbpmmHGQKZxTmvYgD2pTmnFAvFGpqpZ48QinOGbT8cHoD8QO
	eeWINBc1aR9BpGffOmmDWiLP4zE/2ChF8tgG+Hnww3T//GeoFoQSMlfnUUf1UmqykT/zyCP1jp2
	98Wav911pc3CcjTzpOcyJPlKUED+jGWVv1lnhFeAVF4x97pY=
X-Google-Smtp-Source: AGHT+IFD6VPE9lPfvHFSBaljmFDVLzQtyWvwDx/rwgVySA9wLmcADIPAcZRd7DP0JAGnDFYpW6j97g==
X-Received: by 2002:a05:620a:6130:b0:822:f45b:a5ef with SMTP id af79cd13be357-823fc8907acmr1768739085a.29.1758038484117;
        Tue, 16 Sep 2025 09:01:24 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:23 -0700 (PDT)
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
Subject: [PATCH v4 02/15] mm, swap: use unified helper for swap cache look up
Date: Wed, 17 Sep 2025 00:00:47 +0800
Message-ID: <20250916160100.31545-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCE68A002D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sqs3a61nzzkk76n5rqgfk86zmwhwaknn
X-HE-Tag: 1758038485-896125
X-HE-Meta: U2FsdGVkX18TJd/J86LjHym48tww3byA/BeXFJS3f3ree7jnqKhYNMeDd3ICmcVegm1COhArIN2vJp2YLQuybl8f3KvS/xiE4ZVUbb99vxcGDR0qLZTcBvROOV8o7zRV0MGNQUkPIDfKy3JriKcyGJcMjjADNe5bN/AQq3xU68Y71nCWYBAozVnaIRqinN+p/ENx+tAKDcJbjTkkRCqi4WN5qxSou98rBDSAta0bI/73IScNTUuhcepx2gDhvWszyjdZ4Npkbw3iVXVhGmtzRNx+eSpsXnQRMIcjrXwqqx/DULpCaOzmuWLw9pUvJwUP7IatnRJJie2FVKMMn9OHa8xHXlJTICueSipaoGC+FoUJw5Rx5tSwRJwRcWPR/j5RCuMXbFJperSBi4mQs6Sb25KdnkvtQz8/KulqLNtGn7ivZBG5qU4zHT+6QRG+i+MlwmkShdDj5ufKdFhYxkh2XqTZsCHrRd93bbwrL/yhIdepo1iyWEXx9oP0FdFq0NVHR+zYwsHsUr8tjWN4SthmpoWHlpbi6NTgghECPkVwtD1m7TxevHwbrz72SeGQidMLDFhR5WBbCABWuOmqT9EYiJnKbrVSSWErexcQ9RyGOxOhvLW9RuGR0EBZJhml6nq6i+Rikt5XlMha75XiIMVqHwvt9zz8cHTNcBw5tdqaSie4ybvToCSrxYKnrylok3RHcOuz28TsCntAZbBsvPvWcJjW8r2zcNsridis4z7GVGwUqCJ85Rcufb/O0cSeeNZHNfNH5RSG4PvZwZ/jrjxFrpuLdf/R/JtF8UeRzgqzWXAQk/k9wo2wyVPETFCStoQDSJa0XMW/bpBg+ya4oLjjrn+UKS102d9g6/asAkgNiu9LRjnuWpU2Ej1Xt6pb76HLL634P7KcGwFgC+HQZBkE+Xm0lTJ+BxqEhRREU80mebYRcpwTod2Av5sveEl8Kld29ALkfAnlz1LtLEUbMrt
 8Vz8Qlpy
 wgrGVQjk4Tb0OnbIV0zGIHcLp365PfzqDD9ueugXVe6MzTpIJDKUKDtHxaLmmHzD+OrqXE1lP4yfDA2Bxc7eYXrz6I5spraYPzuHVJDvklFui7aJDX1ZO57PIzgtwMv36u1A0swRYyb3R7CNwS/2XJhfOPo1p5XwvRJP5s9k5RWDXRpljnnAeehc2Lglk55xVGvSvroffColwcSqGwt1MG14LLtk167WPfsFrOBRkVSszvmwB5LzEvWUkl+Na1+QFWsAhroHtVmeI+4Km7NKWCK97XVk14Lua0eWUQpgOHYE34LMlWzaTfUSHtskHHbHeAM4J8kheQw6EbqkCrQwi6XRyGLDCTgDNGoI3p7TSlN+Fft2iA8HR81IYCGLiPx9NkP2NFwdglbC5L3iqA6lzRO+vxIUsIes8+tsXCjD4+y9sGpx30EjgqPk78nFtCeXFVfg+FRxsdQ6pPDE1s7MEDZrfol7kftxTF70Lp7exWPdysqgRJH4/zyDYvH4YRvokBKjsmaJqhsdDnHBlbNmc47P9LP9Yny56MZK/TUYaem0D0GSnxCbJAZLmHngQwFfq/a68uqod2lEmorE4+Rrptbn8KfmosyI0QijImpbqOIaiSNovODpf2IPHzsPlQ5dvbqXHYiV8r5LI4LrwNI+sVkxG4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The swap cache lookup helper swap_cache_get_folio currently does
readahead updates as well, so callers that are not doing swapin from any
VMA or mapping are forced to reuse filemap helpers instead, and have to
access the swap cache space directly.

So decouple readahead update with swap cache lookup. Move the readahead
update part into a standalone helper. Let the caller call the readahead
update helper if they do readahead. And convert all swap cache lookups
to use swap_cache_get_folio.

After this commit, there are only three special cases for accessing swap
cache space now: huge memory splitting, migration, and shmem replacing,
because they need to lock the XArray. The following commits will wrap
their accesses to the swap cache too, with special helpers.

And worth noting, currently dropbehind is not supported for anon folio,
and we will never see a dropbehind folio in swap cache. The unified
helper can be updated later to handle that.

While at it, add proper kernedoc for touched helpers.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c      |   6 ++-
 mm/mincore.c     |   3 +-
 mm/shmem.c       |   4 +-
 mm/swap.h        |  13 ++++--
 mm/swap_state.c  | 109 +++++++++++++++++++++++++----------------------
 mm/swapfile.c    |  11 +++--
 mm/userfaultfd.c |   5 +--
 7 files changed, 81 insertions(+), 70 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..10ef528a5f44 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(!si))
 		goto out;
 
-	folio = swap_cache_get_folio(entry, vma, vmf->address);
-	if (folio)
+	folio = swap_cache_get_folio(entry);
+	if (folio) {
+		swap_update_readahead(folio, vma, vmf->address);
 		page = folio_file_page(folio, swp_offset(entry));
+	}
 	swapcache = folio;
 
 	if (!folio) {
diff --git a/mm/mincore.c b/mm/mincore.c
index 2f3e1816a30d..8ec4719370e1 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 		if (!si)
 			return 0;
 	}
-	folio = filemap_get_entry(swap_address_space(entry),
-				  swap_cache_index(entry));
+	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
 	/* The swap cache space contains either folio, shadow or NULL */
diff --git a/mm/shmem.c b/mm/shmem.c
index 29e1eb690125..410f27bc4752 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2317,7 +2317,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 
 	/* Look it up and read it in.. */
-	folio = swap_cache_get_folio(swap, NULL, 0);
+	folio = swap_cache_get_folio(swap);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
@@ -2342,6 +2342,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+	} else {
+		swap_update_readahead(folio, NULL, 0);
 	}
 
 	if (order > folio_order(folio)) {
diff --git a/mm/swap.h b/mm/swap.h
index 1ae44d4193b1..efb6d7ff9f30 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr);
+struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr);
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
@@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 	return NULL;
 }
 
+static inline void swap_update_readahead(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+
 static inline int swap_writeout(struct folio *folio,
 		struct swap_iocb **swap_plug)
 {
@@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entr
 {
 }
 
-static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 99513b74b5d8..68ec531d0f2b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -69,6 +69,27 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct folio *folio = filemap_get_folio(swap_address_space(entry),
+						swap_cache_index(entry));
+	if (IS_ERR(folio))
+		return NULL;
+	return folio;
+}
+
 void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
@@ -272,55 +293,43 @@ static inline bool swap_use_vma_readahead(void)
 	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
 }
 
-/*
- * Lookup a swap entry in the swap cache. A found folio will be returned
- * unlocked and with its refcount incremented - we rely on the kernel
- * lock getting page table operations atomic even if we drop the folio
- * lock before returning.
- *
- * Caller must lock the swap device or hold a reference to keep it valid.
+/**
+ * swap_update_readahead - Update the readahead statistics of VMA or globally.
+ * @folio: the swap cache folio that just got hit.
+ * @vma: the VMA that should be updated, could be NULL for global update.
+ * @addr: the addr that triggered the swapin, ignored if @vma is NULL.
  */
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr)
 {
-	struct folio *folio;
-
-	folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-	if (!IS_ERR(folio)) {
-		bool vma_ra = swap_use_vma_readahead();
-		bool readahead;
+	bool readahead, vma_ra = swap_use_vma_readahead();
 
-		/*
-		 * At the moment, we don't support PG_readahead for anon THP
-		 * so let's bail out rather than confusing the readahead stat.
-		 */
-		if (unlikely(folio_test_large(folio)))
-			return folio;
-
-		readahead = folio_test_clear_readahead(folio);
-		if (vma && vma_ra) {
-			unsigned long ra_val;
-			int win, hits;
-
-			ra_val = GET_SWAP_RA_VAL(vma);
-			win = SWAP_RA_WIN(ra_val);
-			hits = SWAP_RA_HITS(ra_val);
-			if (readahead)
-				hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
-			atomic_long_set(&vma->swap_readahead_info,
-					SWAP_RA_VAL(addr, win, hits));
-		}
-
-		if (readahead) {
-			count_vm_event(SWAP_RA_HIT);
-			if (!vma || !vma_ra)
-				atomic_inc(&swapin_readahead_hits);
-		}
-	} else {
-		folio = NULL;
+	/*
+	 * At the moment, we don't support PG_readahead for anon THP
+	 * so let's bail out rather than confusing the readahead stat.
+	 */
+	if (unlikely(folio_test_large(folio)))
+		return;
+
+	readahead = folio_test_clear_readahead(folio);
+	if (vma && vma_ra) {
+		unsigned long ra_val;
+		int win, hits;
+
+		ra_val = GET_SWAP_RA_VAL(vma);
+		win = SWAP_RA_WIN(ra_val);
+		hits = SWAP_RA_HITS(ra_val);
+		if (readahead)
+			hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
+		atomic_long_set(&vma->swap_readahead_info,
+				SWAP_RA_VAL(addr, win, hits));
 	}
 
-	return folio;
+	if (readahead) {
+		count_vm_event(SWAP_RA_HIT);
+		if (!vma || !vma_ra)
+			atomic_inc(&swapin_readahead_hits);
+	}
 }
 
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
@@ -336,14 +345,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	*new_page_allocated = false;
 	for (;;) {
 		int err;
-		/*
-		 * First check the swap cache.  Since this is normally
-		 * called after swap_cache_get_folio() failed, re-calling
-		 * that would confuse statistics.
-		 */
-		folio = filemap_get_folio(swap_address_space(entry),
-					  swap_cache_index(entry));
-		if (!IS_ERR(folio))
+
+		/* Check the swap cache in case the folio is already there */
+		folio = swap_cache_get_folio(entry);
+		if (folio)
 			goto got_folio;
 
 		/*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a7ffabbe65ef..4b8ab2cb49ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 				 unsigned long offset, unsigned long flags)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
-	struct address_space *address_space = swap_address_space(entry);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
 	bool need_reclaim;
 
 again:
-	folio = filemap_get_folio(address_space, swap_cache_index(entry));
-	if (IS_ERR(folio))
+	folio = swap_cache_get_folio(entry);
+	if (!folio)
 		return 0;
 
 	nr_pages = folio_nr_pages(folio);
@@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		pte_unmap(pte);
 		pte = NULL;
 
-		folio = swap_cache_get_folio(entry, vma, addr);
+		folio = swap_cache_get_folio(entry);
 		if (!folio) {
 			struct vm_fault vmf = {
 				.vma = vma,
@@ -2357,8 +2356,8 @@ static int try_to_unuse(unsigned int type)
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
-		folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-		if (IS_ERR(folio))
+		folio = swap_cache_get_folio(entry);
+		if (!folio)
 			continue;
 
 		/*
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 50aaa8dcd24c..af61b95c89e4 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1489,9 +1489,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		 * separately to allow proper handling.
 		 */
 		if (!src_folio)
-			folio = filemap_get_folio(swap_address_space(entry),
-					swap_cache_index(entry));
-		if (!IS_ERR_OR_NULL(folio)) {
+			folio = swap_cache_get_folio(entry);
+		if (folio) {
 			if (folio_test_large(folio)) {
 				ret = -EBUSY;
 				folio_put(folio);
-- 
2.51.0



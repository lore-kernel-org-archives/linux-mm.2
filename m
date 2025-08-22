Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5178BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EF58E0007; Fri, 22 Aug 2025 15:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FD78E0003; Fri, 22 Aug 2025 15:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0548E0007; Fri, 22 Aug 2025 15:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 673E38E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:20:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23CAE140301
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:53 +0000 (UTC)
X-FDA: 83805360786.29.C4AB7FF
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4378740009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HMQjBhOd;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890451;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scLHsbDs+ArcmFRsGn5Cx+L6FeMMrFmBpcYyEjUVG0s=;
	b=KknECD0Oz7Xxn8mXhUK21I+BzYbSZJJt7pI/MEd3mFc3PZm5mXQH+mjqo/8VUWg6x3Cy1P
	XKeaLn7ME/WZhXO/FK5gYSywMxG+4bNT/uUEciNru98eK7/OiSUi9Sy2+644EB5N29OdRk
	Rr3v5ZnC/BtdzDOQVZ+95qoj7Sfn6T4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890451; a=rsa-sha256;
	cv=none;
	b=PjoWqcS6KizvCV0hXuNy18sB6bRKoWGMmOLOxRdwJF3H9f1BGNG05Zv/WKUTxl5hxYrS4j
	phW8JE+1QCEdfJ9ODuCJCjV/PzJaYV0m0qQKQaTOVlnxsBDyHEPKTcP2LMWonFEwprbGju
	FETQ+TR6b2SShSlIoOlaGcCkVvnY340=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HMQjBhOd;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70ba7aa131fso29601676d6.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890450; x=1756495250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=scLHsbDs+ArcmFRsGn5Cx+L6FeMMrFmBpcYyEjUVG0s=;
        b=HMQjBhOdtzBcm1ozkm93ypzKlIEfess+qUKZx50BLbx+peIlZgvf6Y3twuvtjUB7lS
         MbSn/U5mTBonYM9TLdOCG15+AahSi1rtV9N5JxM+xM0xG62jGiAHzxcenLwOLRAzv7Yo
         YNAmAcuB4LItI1lzyBKbb8te7ElKfnJqc//6/yResXrA+3R82WZax59EW2KLP91Q97Bt
         EFepChHF5KY133DOJw7C9drs8srvtRpBezIyZPHn+HHXs0MWb0bHJLWKMIizeVgUh2T4
         iYqAGgChsjNMjOF72gH9RtEmCwwipvm1CEhdO2KEs2OsFiFhLKU4nKB1G24oDOWmOB96
         hOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890450; x=1756495250;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=scLHsbDs+ArcmFRsGn5Cx+L6FeMMrFmBpcYyEjUVG0s=;
        b=UWhkSLuguhTRheU1tnTpsloGn5bP7UMHFCBGkIAToikJ+8UBxN4/l2c7Bl+RY/lo/h
         iQ41pag/Adt6q463q5aGVYfmUkV2XDVmtV4pYbyWzktIK0F/GJDs2E6/uQC5RAT7njfe
         xj0kdexnffkczEyFwKWTx09eQtfXS743IZtjSVUstKxzSZzGm4LDR5yfoxrPvbEUGbwt
         AARZRBMoViSDl39Hr5Dsv1ec5nSkUhqbiNRkOKMACY3TbF+/RaMZ18vw8vnUDoid2mec
         JpmUEFj2b5Q7TboXtI7qsiSZJshGPE/D1VsFR2i9lFTuZsIKq83+vs07KfDjRmkYoI2u
         WY1g==
X-Gm-Message-State: AOJu0YyYbXSDixRCstWv/4Rz4mHoMiHnAKY6sqKWtg8IJhbus1pt230G
	Sv8MSrQzs9yl6b9PFCKT71msXCb3+HnDvcTuaYkCppEFpxjBVarV2PW//KQaAjTYRKk=
X-Gm-Gg: ASbGncudJu1JZgu4z/aWsBpCF8KUjqTOQimsc5XJtgPcg+UrEszE1UFiPoNIi05H/3f
	RTOUH9WY+P5d8DMGSJiaIddBLYwcNLejLjXkIRoXX+4So3kZZQGzy92EWzNlYgjWmwIu8OawvIb
	3q73cFlTa3rhWSvTeRxmQ+AmC5j9DLPffvz0MqhQE8rKk/yGbKA8fV1NMhluMJO0C46r+hymTTQ
	67lngFA93WZWFrDptUdDQcUtjwOjJEzpQjWkHwj3CfY3eXRwpogEmHv/HgkSkhwVZjDzd0bvBep
	kT2FcxmYxmisxn7hipo/tOliEFZcOCLyhcqvgpsuVW4ZFcSXLrXu8uVrC46aD6EdXskFopzTARf
	8Q2UZERxGyU7wsAfidNkD3+qVRNos3U65ZFNmr/Gd7dg=
X-Google-Smtp-Source: AGHT+IFiwxZNvGWuVzEZPlsigrtEjNG+eiRSrQs49PTgdnaqUMY7rK4GzwChHIz9LB8CYcRy1pwq6Q==
X-Received: by 2002:ad4:5c6f:0:b0:70d:85d0:f85b with SMTP id 6a1803df08f44-70d970b2899mr56158606d6.10.1755890449755;
        Fri, 22 Aug 2025 12:20:49 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.20.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:20:49 -0700 (PDT)
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
Subject: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
Date: Sat, 23 Aug 2025 03:20:15 +0800
Message-ID: <20250822192023.13477-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4378740009
X-Stat-Signature: ztdwyhdxy8mu1bce9shxbu6tqcpsrer1
X-HE-Tag: 1755890451-781591
X-HE-Meta: U2FsdGVkX19NJlt7mUEoWS+ysIVAVdzZ1IL4/VAc2JemwAIRqk80hXrwmvHxFI6fP7AcT8g6jwQTcO0U2g+6R3aX4Pae2kvIbujpidijVEfqkRHpEzGiatC9dPUz/qdY39yu+AOLD+O+UlClcnrGdAllQqSDFUUMLMOz4Z+XWDgf1U5zI8K+l163MoIHbn5azqOWk2fGDf4DihJZXHcxIyKUZOXpOdXvbxWZbILzhbaqlAmwaHoFyXZ5Ihy21zoFUX79DyRGEzfFwenLDKwpm3gy+oPvA6KtAt35px+hxYmtoD1I2ax0O6tY4uQi4QKdRMdCNvHE8s5znNkSlEg9p7eSxvRVdsFjH1jq2tWCLOFf/F2GOwB99MUi3LVlyBA++vFocPoWMpS4Z9psZ/snxw90YnI8TxkmjtqBwlIySBr759Evn0Qnqr1LYHsd3cwelRgz3JfiB59hw0d0nFpti8ZPvQUGve6WSvYUJFAu/XL/PDrLkzyBD3vIUaNsOdq8hsIZoaOdQCtVIzZm6HQWP+JwcP48vyBnUSETRLVALWy5mtzwyGsgEz0+IqA9pDAtuJX7/3hIpzMd57p18/SLTWgyy4DKGfuTolzTlxT9yissujGpoR5N/f0V1WbWs2wl72przHSfmF3s6ARy/ucltxMAhmtjP3rlE1wMzfJCDR6U+msLvr/8ci/d2Y+zWxYNNUQ6Ghkyww90vnyhDQftEaLYeMqUxiyneZKX4fB+0xBx4GsSBtx/8B4+M4aZ5jalZMbXEIWIvPcooIZbgXSAp8L995O5mI9iGEvXPRRHtDFeQxnGa4e5HuTflx4LXsbUVUorEwAswIvStagwu/Oyli25vnBHfU3uKM142bgN0UyT1YVVgTSTGg0HAud+juQC18AvE9DRpAtJOF38e1yQqbNc8IuQ1fS5aXx3yAXzckqtgL7Hgh0BJUAyGFYQJIy/PejUpGcyYbuita3umbm
 3Ky2632n
 nl51UKYCWL0oABhP+H2wuat91LbdNBgRX+ABOg/7+Vlwbz6ChQ7Gc7Ez06m12WFFZk0wsxVs5aUmvW8vau5U61g+Vf1sSQhRH+djYtyjWSp4m/ro2c5QovH2g+AM4lkIwOrY7xaVfaK0fLBbzGx0t5l2k5A+Jt3J7EmTqfo2UoqhLswJ292Xq8sASyPbodakBIqH1DVTYliHezRdGqs5iHQdfLDQx5Ro/Yg8ITURJsjKtwRC93OYPtfmTPWRmPkyBHguj/Va0t/n7vznHNv+Vy5dR5DYJB/go6+ZKby3+0R3Uvyl4ybcymU8ltYV2Li3DgLmAb5pEvZo/gGWo+0CtIOmIevkRgTGs08aulOmDhCnlMJiRIBAdJ98j6RRz9gZbZ00Jr/HjMW0b04hUc6GSfbh2Oc0B0qEdQExgA05i+3IKDvo5+HwfeKdD+2xjvFWhDUgUK5+Mwis2FhDuKjo1wFUPJAbO6irM6icq77pUtrbIf7ms8ntzx7P3ZZ0OWDwt2GLYHhm6+/iZ8LgJr32YFmkB9ZflASzYo7pH4np5/NCj7KWcNXx2y5B1ORtxCL1yZw7eVVkRjV5fu2URMNKmeAEU38a/CgQci9SRpglRRGYiXclBW9XaUTvSZK8RchrUbSVGW/RY+I2yC30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Always use swap_cache_get_folio for swap cache folio look up. The reason
we are not using it in all places is that it also updates the readahead
info, and some callsites want to avoid that.

So decouple readahead update with swap cache lookup into a standalone
helper, let the caller call the readahead update helper if that's
needed. And convert all swap cache lookups to use swap_cache_get_folio.

After this commit, there are only three special cases for accessing swap
cache space now: huge memory splitting, migration and shmem replacing,
because they need to lock the Xarray. Following commits will wrap their
accesses to the swap cache too with special helpers.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c      |  6 ++-
 mm/mincore.c     |  3 +-
 mm/shmem.c       |  4 +-
 mm/swap.h        | 13 +++++--
 mm/swap_state.c  | 99 +++++++++++++++++++++++-------------------------
 mm/swapfile.c    | 11 +++---
 mm/userfaultfd.c |  5 +--
 7 files changed, 72 insertions(+), 69 deletions(-)

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
index 13cc51df3893..e9d0d2784cd5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 
 	/* Look it up and read it in.. */
-	folio = swap_cache_get_folio(swap, NULL, 0);
+	folio = swap_cache_get_folio(swap);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
@@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
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
index 99513b74b5d8..ff9eb761a103 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -69,6 +69,21 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
+/*
+ * Lookup a swap entry in the swap cache. A found folio will be returned
+ * unlocked and with its refcount incremented.
+ *
+ * Caller must lock the swap device or hold a reference to keep it valid.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct folio *folio = filemap_get_folio(swap_address_space(entry),
+						swap_cache_index(entry));
+	if (!IS_ERR(folio))
+		return folio;
+	return NULL;
+}
+
 void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
@@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
 }
 
 /*
- * Lookup a swap entry in the swap cache. A found folio will be returned
- * unlocked and with its refcount incremented - we rely on the kernel
- * lock getting page table operations atomic even if we drop the folio
- * lock before returning.
- *
- * Caller must lock the swap device or hold a reference to keep it valid.
+ * Update the readahead statistics of a vma or globally.
  */
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+void swap_update_readahead(struct folio *folio,
+			   struct vm_area_struct *vma,
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
@@ -336,14 +337,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A59CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DAD8E0027; Wed, 10 Sep 2025 12:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10978E0005; Wed, 10 Sep 2025 12:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8468E0027; Wed, 10 Sep 2025 12:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37228E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:08:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CAB8C0136
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:59 +0000 (UTC)
X-FDA: 83873824398.06.61213BD
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E7A440014
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cmx2A8PS;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520537;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
	b=C1NiTKRH2ZIg+d/U/INLHANWkgZ3TLmPzynGppxPTk5O1Dom0quYQ/wbRZAXFMWwvHEjkJ
	xDDoSI71oy3h/d5t9MHm3iesYmrk5/WPE6u3hobWCCJjINxi3XaIDPfBrafXsmnwFkdZBa
	HVWCV+ICMM+8pkaosUna0G/bNQgI5hE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cmx2A8PS;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520537; a=rsa-sha256;
	cv=none;
	b=O84QSdaSAqpT9SAt+Thf2RoXO42MIdvJ4FfkJdH4d0FjRL+S5hmqH4BTWA1Easj24UnBir
	K4xhMI1xPgfjRlkzLEcWsnkMHRyoFNVwB+tTcseAf4DNVOIgKkv/9ZGwtn7ZRfN9C+99r8
	b6HubjQWNCPzZoSB6K+hfBWeX5SW6t0=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7723f0924a3so9249057b3a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520536; x=1758125336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
        b=Cmx2A8PS28Pwd/QvtN8A/Zj5ciFdtQo3pn7BmI9P+WMTCen35/XeyDsFmHBHfRfxDh
         CIvB71IhM0jFwiOv1qA+BcnIi0yitXr8ICIIo84cjGRCoCJfbi9dYBfu64LHFh+Ob4ij
         zdzPiupr9EhPcnq+gUBxrkij1177UwrRmNInc2cpH0Ke8+yaPoGfiVADdF6PWae6zHxT
         s8rD+5DZk3gCndmdJvSEn6YQyE1l8iHdKUXcvOraIvNkXe9hY15rGSBWXLIW06J9rKB2
         zPiE7WmywWKiaAVi+Cq8wpQz7nWnZsb3p2OsIOq0lwB2SallwiUJ1Tm4iIItQVFXroUv
         +XfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520536; x=1758125336;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBZjrSlGrCuoXEovfI0RqN6ge66DgK4hS3OmggQQcuM=;
        b=QjFeNwkawOnmxW/cLXdCqg4f6DMPG2k8JRjUDEevjSCiq1uKsdaH3rTOElDdsFdSO1
         P3PkqRbXAYzZqkAX6JTtT6senvswZD9gDjiF3vFjovheFY1JhCVoooeq8Zc0oYRCDka0
         FWO3Xv6viEQ4vLddaUKmJ0Wy5zUjIaizxbpAbrUBbnoj2XLrwASDr6nEk2UhZpcS8uSc
         ysLiZ+BotuMF3F+hQDUaZZUbmz9THt9xbzGrqh16FODYKGR+F4VdlVABIVbAXWVeA6ss
         ZqymgkoWSmN4x+ACd3BdKl84QDEFhoG6a7aPSZB/3JimXWOgTI6DGTibqpU49OvoHV9g
         OYyg==
X-Gm-Message-State: AOJu0YwdO1rD7cNRYQ5io2Hj66pmzCGCRxXNeBosDCLewDvqm2F3Xhft
	LoZegI2aykxOAQ3wdpw6+exLHHiapjKd709udZwV1hk5EP/GMduvUfpUzxtaQ4fqjI0=
X-Gm-Gg: ASbGncsSfiL47daJSAXgEwJb5yxa6M/oFMRzoy59krbb39KLMF/1jvGYuPb/Dzkc4FB
	cm04pOj1o9PR0RJjngw2GtDlLJeIKWLEyHZnHn8tQeo1ilxE+8C2rsTXO/W8UIGms4ECQ+9wAHw
	IDizsU71ujUc7UWBq0j5wf8yceJvZG9hxLcHtkgNNotP2muKgPkH0u3DL3WmoPRE/4U4MGsienA
	CggKoW50gGHBRQgIrOAESyVJdD2uSOaDodslhgpcSKViTzdenHZzpnThgfM47cAX6srrbJzW0O4
	3Jn71ks1OSA29UPeLvAfHx5nEeia6G2h7Bu6P8iElAH98WAmtLdBJhdNfRNCUq+tT03DzmKC7tb
	GOcfn6bC5Cdb+n4qpMppT36AFYfjUiuavhGFvWGh7Fm1/njbLNI9Cs0sMAw==
X-Google-Smtp-Source: AGHT+IGGmJewUeNY+nNFHeQ/nHWhKuHcuJNLNLUkFHUvOr8qFnybJf+g/nmOah+d5OTnLDQWDhYpXw==
X-Received: by 2002:a05:6a20:158a:b0:24d:b11b:e8ff with SMTP id adf61e73a8af0-25344412ff4mr27412031637.32.1757520535592;
        Wed, 10 Sep 2025 09:08:55 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.08.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:08:55 -0700 (PDT)
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
Subject: [PATCH v3 02/15] mm, swap: use unified helper for swap cache look up
Date: Thu, 11 Sep 2025 00:08:20 +0800
Message-ID: <20250910160833.3464-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E7A440014
X-Rspamd-Server: rspam05
X-Stat-Signature: ocsctzmhor7y5q1o1nspt4gokrjyaqot
X-Rspam-User: 
X-HE-Tag: 1757520537-485147
X-HE-Meta: U2FsdGVkX1894SYhm+kPGPO3p+w7c5liyTWQXnLUNXr+yKCfG2aVhwW82TJ8sX7AWJyfVFCy0S+MrG9SOZiqcE/3BO0r7rZs0q3wYStq4x/R2VcnXwZEO9CYSi2W3/+dhKfqSaO+cQ5PIQ3zjAlY4yUaSnSB/PcNs3ALG4GAbMdyrY6amhwtzor8tC7hHYAAZw9DG/QwYLiQ7pIrIZAuTt36JR+uVPeA+9BpYbKxyRyYCD/Zt3Ph3JvrLKMHVsg3lwAYoBg060vadr08S8X2B1OPeOqkkHi1p1d6kQ5QtA4/gcwozU4FTzLtuvho93SzDlepXWZaIPARrlFYu/mNg5eY3MAnMe29U9n9wjLfHZLL9qN70XgIAJ4NNCyq0OIpn1lMTTi6T4LmEIhS6QSijmlz5ToWPU/ApRyfeXTOomfv44j4OW20KAlyuZ9EKybD5cJ6iuuB/TgHk1b9nCj184DkS7W2Wd8wBb5tP21WOO7q30wvmmuxnj22mDasdUc+0gG9elKSCKrtv1mgKLvFZ2eV7mHzoO1Ldf7tixnT/b5oTO+9h3HvmsF0j/sXc6Ut/d+8sXhIUq2unrVDK4ZrMKGQDHJVQWsegPAAghWdHxdFdpJ66BHS8XFwCp4Jylf1gph4fwweBY+nZiVeHw+XO7dla/X9yYl40KFkkjUPIaDKGPDjpY20Zv9AEehJz9GqH0nyg0iWNTp0pWBgWw6JPKji8cJv4h1YrnVpNJF684//kZ3/9rhG4dviX1ZJFYF/9vcCKt9IovyPjGnmwuh1jeeRj6GgZZy3wGEXjYpiDoWJAvC0IEqG6NFFuI6BQdbjWwvBRGVNmrpURqoO45zEEFFeoWb9a3biEEoVkaT3WB0RAMRo+nfCC0tMxTOnNsnkAlDDJIzqEcpKNq+FgQXeviKst2UasJWA6AM8rstE/zKsDL02xzoQgt014w4pXh4A9A/YMaLMPo4MXJaq9ju
 vUNQagaY
 ei+RCejHnfkonnki1cD0eGb4M/CvPM/Xlq1A6v17dljjtCiWaFOniCBE2qZRUmzn0x/llgQ+s+SYp7xu2iNVXEFvM/6CwwfzU4cU8EK6d3kX+brBwow1WSG2chALQ7dL1UyTZvyuAGdFnFdfRgENY7NQc++uewcBI4mGs8v9pih+ILuDBzlIuVvYVDZqAyRuIte1nn7g4p05XxY6zi2kFulcSBpldIJSuelRSYTFqPMm8hsakmzCcq9Dr9c4HYwwOxSJ6Ek+9ClfPnH3cyniR2Nno7VjM90yqQxbjZjySfXYfJJPux9niPCuCzfPmAEkpREmrYP/+Y47cVBlpOXWIpRYhGAxP/yrDC5KQFOW/u1IdTK6VvaoeBS4KZrNdYWqj+fpPdHFPC6HnHbPHfiqGaYzcXeP+8JmhY38dl1kvz5IbZa8TBgHtJNgN7MrfwIBlZBiypN5rVh8tMiIVzNcm+Qv0oAHHOcxrQs929Ol9FKL9Q5UYk1m1lFqkAKNR9Z8FJNihF3AjuWxhwgNIRdKMgJY94dICxk0nDySXpXEHqrLI4XqSp7V5LVQc/0Y7Sqyt9afgPVTcVWmWKa1sN/fqCVVBltCwv1n2WklFPCAqjXw+ywT108xyiRQflXkmXZdcUmP+HCzQIYpqLBRV0gdr9WDlMg==
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



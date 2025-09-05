Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 742AACA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB7D900002; Fri,  5 Sep 2025 15:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7563940008; Fri,  5 Sep 2025 15:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6421900004; Fri,  5 Sep 2025 15:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0B4900002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72C2B118B91
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:35 +0000 (UTC)
X-FDA: 83856150630.12.B8E6F51
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B71D120007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bx19Qpu0;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099733;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9tXoC30u8cptZoeY7RVmNYN+rcCikIe4hnTmAJUGE4=;
	b=QTAwue4kqUnHrRpdZo6ZPyVmuWsTJXRqiVOWgNcrJxJIri1EAGeZrfwQIMlPUkXoYR7I13
	UelPeArunB97Y1CYpOQgDf3wprjPr37hlw5UIwwR2UdpxlDkwQwNkrcWhXPuRNASz7X5Jq
	UWO1s2rIeYTujVIvvFdcUZkI93XEwJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099733; a=rsa-sha256;
	cv=none;
	b=z6nnXoJpk62kT6l3iiLnkcoz/EVEXZohBzP31wYDs1DWl2X6I0X4oj4Exu267j6rdWz1tS
	UNdXDjpa6vKEA+Ua91MSaPpbJO4e/NDa24OtIA64jlz23ij3uw4jWJhGSpunuy4AnkG3hE
	WBl4FP5p3mu5zMGgEQE9rFb37qraXws=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bx19Qpu0;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77256e75eacso2307547b3a.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099732; x=1757704532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e9tXoC30u8cptZoeY7RVmNYN+rcCikIe4hnTmAJUGE4=;
        b=Bx19Qpu0CMv1F7DTh+tSxFs7/Ie2CiyccUP8sh/n7dsF5xrbzL9ksxxsBLNhaDqhRH
         ohxekK+iVuHVlq7ZDsoHRKiPI6SiLelitOkVMwvfcSQXDuoTafue/5uKLW9HLyxhd8Ma
         2qRtOZ1dW72WIC5aGXcHi06wjdYkLIEK6EjHyVGNBPYC6f7r/6YROjLkgOwU8YBd/i21
         R/d8b+P0qF4dEbhF8Zkc3UOBMYvYIiqGlmaEmmMFhSsAvf2/A5cTeyg59Hx+3l2plQUX
         mFBTu5r9AlXbbETj1KI+plo5xSZMbZlG+OhhH1VXKhJAQtAWPP4PvnTLQY5DVDg+accU
         6Gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099732; x=1757704532;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e9tXoC30u8cptZoeY7RVmNYN+rcCikIe4hnTmAJUGE4=;
        b=FAoNAd01CkTwV0rn3v6TqTaB0/4rKxoEHEnSApSoYL5Iq+197+FHVpRDGtX6E8WZp4
         ThF33Q7bhTtATlBdsjkh1OWUlTnqwOrOyAyOc+jqFEVDeceP5CRFoXTkjKGQ5FO5ofug
         xfCC8IRplihEbkgD6VT2eR1SC9+UWgvluk1zcRt5+wqu8ALm8aazap2STjbHiVQupCH/
         m6XwA61BODbCukFeWos41gUqT/OmyNSUNGsry0FFHt8Jg0WS86jKcnBzwAwdE6Cb53B8
         FZjpU0aJAi+VslOSkzfbI9/Df+z7d78iH3cRooMSBQEJQSROfJMaQa5+FabBxYNMgaEs
         Hu2g==
X-Gm-Message-State: AOJu0YzJ+3+a773yLcgEYAd3HKzWA2dIClkf08WoLfaTWQ7I19YgNrwl
	yRvf/FZcaQYW/ZwIJnBNjTZ6CJsRtIyo1RcLlAGfbqX23vkX4J4CdmEvOG0he57MYek=
X-Gm-Gg: ASbGncumaNwduoT9c9bW084ubb42Rwu+l4vTsZrWYggZYW8GWYYK+Fww+DtYFXlFoUq
	3rPqWrKS4ZmGLi2zMGWXxYee4hyrjcND/3zhafMb/ZCFWFUnVwCGzb+7yYqfgvvnlBTfYMFdcgA
	o3meEyFtUT6OnCiCrDT8dLQPEh/swUBzYlyqvnU164X6u4gu883DAGjA6i5hsHxP+6LI/kEV2Gc
	fVzKSCcUntWOZmDqY/Dw0HWTk56hUY4jJhBoGsHRthgjxrFA2UhXO0dO8B/4DDzEzvZbN1lzwm8
	8pJkR1961EffsnCsH/Z1meq3VG30XvYiY4gmCj84T6h/o/mnblI6nNagTmCuwuakup5JBu+cxjy
	IzNPaYL87c+MCAWrSCvaNNLgOHEJAEo1FQwZtZ1DghAJI3jM=
X-Google-Smtp-Source: AGHT+IHA4LeWAP5Z6VrdlIQxPr/w7slkyPGU20hMWH4nHy3XJM2DXNYOG9uwEY4Srtf0PoS266Phcw==
X-Received: by 2002:a05:6a20:a109:b0:24f:2251:84f9 with SMTP id adf61e73a8af0-24f2252f7c0mr5988998637.15.1757099731766;
        Fri, 05 Sep 2025 12:15:31 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.15.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:15:31 -0700 (PDT)
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
Subject: [PATCH v2 15/15] mm, swap: use a single page for swap table when the size fits
Date: Sat,  6 Sep 2025 03:13:57 +0800
Message-ID: <20250905191357.78298-16-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8B71D120007
X-Stat-Signature: zyxoxhzxq88wu3exx9n1aca3d47k6owd
X-Rspam-User: 
X-HE-Tag: 1757099733-521149
X-HE-Meta: U2FsdGVkX191ihveKS0xYAhwJ2QJDzp3UQnaZ1cNZjzcJJnECGxOHNOCuiZoJvEI04rxB6buIeCsx+CMDyZaG0GvFhrFwlaVDXv7s73XbG/U6mxWlWCZo3+xbMKcHLjWBMoZAtepgsif52PBAqAXm4e4VZZ89KckIFKxJTFmPGwo+5yKHlLGiF77+YZdHVHBbz27/AVOOcGGSuIYf2tCFJb5ALSQZYxRGROK/zA+JJIL/0qODw3iYARW9xNLCfnJpUQvafekECxnkuk/oZX4GUW3rBkIO6kzndnJSdtOE9bA3AS8EHGahdmaL2kTkKU3m1vRa+nxjZWzU6Zoxb7/jnSDS0ht3mTcCdRhfXxojHnHjpUJQeky54a4+wdgU3zf9upMiqDUrjMgvUDNm5XjleMaEf14L+rvh2g+2hXySSs6KN6lWdqsOrpEZAHOVeJhQiUtdAqkXP8pEHlA1qjnzVElYlUotMLcOamU8Khv/C4QG6nPPlmB6o1CQHFQUIm2KnjcGATcbGDgZ+Mnx1unqU1WcXzs0jW34kklqVzu6fMpUeC5If6QMyD50pKdzAut5AJDep8xkkBpigjG4sJwjvspDn4KAZRxMxfBLc3ePh5lU2PyjHUpH9Jm5KaaR3lylPHkccxeY1WcjyHP//p1A4T5KyTpf7PqQbLcON5JzhKw+FlnL6kj+x2tQdkOGXPiJXBxdEPDYpURS2zIh/1q3t59l78nWKpXp7VnpGJS11/wQr+EwUJiO9hwhlrHmVJ2nQA0iU73z9Y525aSvUTX55RuEE7RMGPmTQ5qlCGIlj/zj1zQsKS1Ff2/cmFYS597udMAlQifNQhTl25/0HDZRW/RePRrjW+K5PElecxr/jyFY8tkNJCjs87xznD/HzOBY86HaRNUWSOG6bK0vCw4Atr1uNjNkBN2FSB9+pciZq91BSaN/71ffrTzLiJ2J/aVh17AUAQOFpQ+lKNDK2B
 BeZQSsHe
 g6PXCQtMtLUEc0V80eD49tWnc/GEwbqLfLsSPlJv069VV3fMwF8+K0wKXiRYE0wlS+MUEEZtpi4EGXqrkRAJ0Xmo8o60e7gSaCqESD7dS4vcSF811VwLYiaeXv7cP2JKjYi/WIHEYbfjQ0vha5d6MnM0E+H5Tcg+ihX1D58C+/p7lAn5C/Sb8pIVfSItRLNfnv/AKi5guU73qwqvoggwCBHvNjz4Y7oQoOTvsxxDKGFqe8YolH3cY943Acbay/9YDTepFAiGkZahgEM7EdtgEJpMCEcA7HWz2w2B/kkw1T4tHBeD9AfP+rhNoR01MjwRIGnnRC8JC0u/wKxkgT0g8vjhQl4MJ1MO2FTG1fMmepH6bx30FxzxdrujUpXOTKLutxeURIYm6xKkYYUc5ZZ6TNbPBydrxuA2FJp1s/oz9fdvLO31IHkpSvgznY3sQSJwtF4QLSxRqrhfYw8YplDFkm2wBoaM8OOlZBYvUk3Tg03mv9FS21JctW4wfc/gtk9mRigSrzkI08lJeh/WyHEpZanqbEGsDGGtOkhNpPeqaU/1UBiTY9uCFxEosGGmEK5tjOIOZfmPoAC/U84bjAMnDR9duRmWXu6VQUfEFPR+2V4YG33KtLHT8NH/Y3se8PKIPZ3FEqF2JcmaZ/QPH+xQlYDncFDZCMEjJMkPy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We have a cluster size of 512 slots. Each slot consumes 8 bytes in swap
table so the swap table size of each cluster is exactly one page (4K).

If that condition is true, allocate one page direct and disable the slab
cache to reduce the memory usage of swap table and avoid fragmentation.

Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/swap_table.h |  2 ++
 mm/swapfile.c   | 50 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 52254e455304..ea244a57a5b7 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -11,6 +11,8 @@ struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
 };
 
+#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 49f93069faef..ab6e877b0644 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -430,6 +430,38 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
+static struct swap_table *swap_table_alloc(gfp_t gfp)
+{
+	struct folio *folio;
+
+	if (!SWP_TABLE_USE_PAGE)
+		return kmem_cache_zalloc(swap_table_cachep, gfp);
+
+	folio = folio_alloc(gfp | __GFP_ZERO, 0);
+	if (folio)
+		return folio_address(folio);
+	return NULL;
+}
+
+static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
+{
+	struct folio *folio;
+
+	folio = page_folio(container_of(head, struct page, rcu_head));
+	folio_put(folio);
+}
+
+static void swap_table_free(struct swap_table *table)
+{
+	if (!SWP_TABLE_USE_PAGE) {
+		kmem_cache_free(swap_table_cachep, table);
+		return;
+	}
+
+	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
+		 swap_table_free_folio_rcu_cb);
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	unsigned int ci_off;
@@ -443,7 +475,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -467,8 +499,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -483,7 +514,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
-	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
 
 	local_lock(&percpu_swap_cluster.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
@@ -520,7 +551,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 
 free_table:
 	if (table)
-		kmem_cache_free(swap_table_cachep, table);
+		swap_table_free(table);
 	return ci;
 }
 
@@ -738,7 +769,7 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4075,9 +4106,10 @@ static int __init swapfile_init(void)
 	 * only, and all swap cache readers (swap_cache_*) verifies
 	 * the content before use. So it's safe to use RCU slab here.
 	 */
-	swap_table_cachep = kmem_cache_create("swap_table",
-			    sizeof(struct swap_table),
-			    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
+	if (!SWP_TABLE_USE_PAGE)
+		swap_table_cachep = kmem_cache_create("swap_table",
+				    sizeof(struct swap_table),
+				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
 
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
-- 
2.51.0



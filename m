Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82E9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EAE8E000F; Fri, 22 Aug 2025 15:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF198E000D; Fri, 22 Aug 2025 15:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969F78E000F; Fri, 22 Aug 2025 15:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A798E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EAF8834FE
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:43 +0000 (UTC)
X-FDA: 83805362886.29.C5AA9DD
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 487141C0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkUeHTum;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beM5HIc5H97tJfr+Bv+Qn5iVpdoA6CB95zAhcoVOSug=;
	b=QSmWKcN5aDaixTYORlnJ4KJkK2E9Ulg21NCQmrUn9rVjNE9UFtkjL44mmp0KQwfwpI0lR6
	yTaX44qoVCYVxC8zFPePWmDvWAwBijR8YOwQZQzmJGuISK5bZ8sdtFXO6bPRrK5BtTIy/a
	af6iW5cfNovgZt2qnCWjH1fTYTf/nr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890501; a=rsa-sha256;
	cv=none;
	b=5GQDqz2KQwAomVt+MDSOsQYg1wx4oDTPj7jOb96fVYrbWRDQX3cPIsl2B1ZiXkR4MYxKua
	9MzsTnXsn6RWz2RnVaA7nh7X8kalDiLHhXIwF9jjTEv54cXnbW/VFOq6wmjpUoEUQgsSRc
	j1/Am0b4Dp9BPjUC85vS8daqxlXCCSo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkUeHTum;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70d9a65c373so12705156d6.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890500; x=1756495300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=beM5HIc5H97tJfr+Bv+Qn5iVpdoA6CB95zAhcoVOSug=;
        b=XkUeHTumoSXZGpoN/5XSmVLDqxUUxtyrFypLdy8ReUnQvhiZZKaCZjS+XLIXf9gSC+
         dPJxiljaXOTHtfWQ+sulcnzmc00VmwhZxik/jz9OVK2OCXJAWDla+PAibipBtqr0erwJ
         MM0FFGDpEt9LZUDGTaYa0iBMofCIUtYHI0cU3W34riY2DfQOI5H1CndOU5/S9Yfvhwjk
         z+QFwwC/FEV3Ig4d5RFPpoDw6EbrsPAkJCJl56TZ4lFBe0mYMp8aHT5ag8GUSCK+XTPL
         BvoTYMH5o5d3e50zOYTGK4p859fy1C91EgecldG/d0fEJhxHP2c1Vvh4aqfE3A+88FsC
         JUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890500; x=1756495300;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=beM5HIc5H97tJfr+Bv+Qn5iVpdoA6CB95zAhcoVOSug=;
        b=fr4yecCO0LxjlHOyeHjZzZfuaRYXf4K6N+XTV57RU0nQHPefNhri9+TOS/tB9xQKxG
         rXvNqWNKHZ3SEPaHs6ZaIE2Ih9DZC2tmxThcWV71JBWpCXMfrMLxGOL2KuJB9sP8TA74
         2RuH/m4RgkI6WwF8kguB2WWBFzLxeoHbMi0jWZrBRFRXTEvS1clMNx6mjR1f/Xj5FQZa
         Ryr3aPnYWxRtu/Dc3RrEbkmvwVRr7w8w3bILWBPxFQ5sPAIg8GvOH62DPZGlfr/qnjPY
         svkS+psiCjj1p6+OAaZ7fJhFYhwhNexkBZfXz+oVvq+o31EckIQp+blaba9x9I07F84p
         hddA==
X-Gm-Message-State: AOJu0YwYTOE7i/cSwMG3ZGNPIomWi7b4vNbHocmslD0lrzZGcw0/Qmx9
	4ZvlW+4G2YnAlHpQP/MrLnC11BOZw26NWZ44OxewyBTgR8BgdHahOiaQkisMY+xMwgg=
X-Gm-Gg: ASbGncsv20S5i9N/cObNY8A9omKd5iVEALy/9dvK+s45SldHMHwDknVtZogjIKe6M++
	ZEmsXHAyOXx7QPotoZH334SnzS+OAWNvbLMhMo1ZEJ/Uow9I4Iq8xtNjR24J6nPOWc/hzn8Vb74
	31v5B0VHRGrdV3OaAN+VcJc7l7h1gkV8x2l1/qCoRls81v7vlpgkuA1MCPPEMFxde+8AIZlkpDQ
	L/3QaxakGZKMavDZrLUw1bMzTijKijzScw8FE6Hn9TPxUSVIVzSx10RW6qms0w/vwfKlO2e9OnZ
	Mpt9zdVN4p9Cog/AxuncG9KRCzhCgQGQljF0oNUFIr6Di8v2SFNwFlZFFnxNPwnMj6ve2EsydRB
	BPRhkQt+1gXuJBcgegRR+Ux5Dc+5/Pi48QSLZIVLPUb8=
X-Google-Smtp-Source: AGHT+IGDvVKjUk3ao3C3T4+HLvJurBFSlIikKQIK2AlVn7WhL5Fvzgj5Yph3zvj5UA7QSkPoWKGNyw==
X-Received: by 2002:ad4:4b32:0:b0:70d:a44c:786d with SMTP id 6a1803df08f44-70da44c7c63mr16656606d6.7.1755890499801;
        Fri, 22 Aug 2025 12:21:39 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.21.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:39 -0700 (PDT)
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
Subject: [PATCH 9/9] mm, swap: use a single page for swap table when the size fits
Date: Sat, 23 Aug 2025 03:20:23 +0800
Message-ID: <20250822192023.13477-10-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 487141C0004
X-Stat-Signature: n7r4hik1owcgf5sugho7wii55ut3xr93
X-HE-Tag: 1755890501-213155
X-HE-Meta: U2FsdGVkX1/SJPQEnFRMoYbROmI2P8OGn7vzLcXvit75ftpdgv4HQwWHIuiShDg4x7tHCC/aO32Wq1BU1+/xX6aI0jiNkq/LDZWEl+1ubsfZHbqA+64gNeoES0HagrWC+649e3VPuNJJulLgU/C7c4nIkEYjlIlJCGiT2+/uNOCCJquWOM9PshjwGS/OG5u7AwFahkwOuem6RUPPCtTIHrJiLBSEykxqpq0qluB8NPUtgTOWaSMWCcDNkYqscUGIZynqCF3BLc/SYVhnJDOIhiUo9ystHaEYlWvudtvGWPf5XoukJsJB4LfGcfH2bOQG8jqNa/5NRDMrlM/I/SkDZFQS4J9ejfwqCIbBZCULQbS4VzyM3W7KShOFwybnjlUqNKGvlIAPg9zKOfnSl08RyCmLZT8AXqwFn7umIutiykNBuMo3UyNbRDmpApF92GEfmzRCNc1m1Q3NGGB7kccGA8X64GnpCET3t4aws5qiGN0ob0hINS21PgbjVuw2dRPARw1+4ZfPanHf5d/oMmSc/iq8e1/+W0FB3La7uxau0FpPm0oe64AZkLPn/8tFCPaSZd5BSWq5hNsJZ/fvvDJcZXZenqjCfKErn5BCsupYQBCvAT28M+Clv/nCBaugQj/PcICf3yFgO1yXUhYwG7xwx3VRBVT4zlLMYVRCHSoieao21LAxChjDFvyjzqwK4g4FI4Em1giGhlHSv/HANvbhMg2DPIKNISZV6kX5eBIeA3SdBCctKt183HClA8NpFUm8V24UPrAU4BP/pfznHrjIFfD7dD62TysKwkaUZQ2oqiYeCe8xkYkW+Ez7mo6uPwWOecgfnkzor7YCu5Fhjvo/796kTHhHjJcIXKOG4LVUjUMafxVuSJQRHErCBFMEp5rS47QCpZPg1Uh4PpSVgqx2S9+kIonD90K8E1BoXSTTelYqjHi6GEgQfcjQrshjnxyVBUWh/g2ryYkeKftYKyu
 x0NphXUH
 abO5ZOCEw6pqKzTFzy0ul7/bgIw1MK6w7J4Vidl9pUTdj4KmX2cXx55050+qmKHCqghs12tyehMP4XOxasvvNCDQxI4Yezuq3bXSWpef52EfkeQIt3pRdkwzcBizLmsZwqSePC72B6ViSOJYC91rR6LK6QEpZ/wMSOiK8KnPEX2elI5kdI/kw9rixRi1BThLaA2SyYHN+sDVPewGkVNlMe2ISBzdjOA6KtFmApZ//agNrg39tguxnb9T8EJ5sXcpt01GlogRqnNxy5icAsd/xPDnt1cKNpbhe2TbmMZjmOKxehLLYik9eObiXxj3Ingsy5nQVAbXgbvVGxPvzYi8wt/EOyDZ0dWaB8xmOs10+H+M9j6tYNh7+Uv6OwfB1nURrAlAOsLGquG4J/esuKYXG2PGF6qBBkJWjvelxYuomWZ3qlANVxRc92iq0B3Tz+/xgAVyDehHOB99nJAfkg+TFS/TfIYrRIq4p6eVowD5l7xZ/Mj6tDHBXI/8he9vEXkT4lyuspIJsHjJtRTeZ4r3EnHN8PHD8zmk3N+v9NXXqUJ3tstYirWecUCkdTOoWnvuP07FNGRlbTDkZ5kTVHT1ynZ09qe4iY4h4UhvfadunX51YNsYVKrXIni2wuf4+aVoewWWcyd4EWXR6WrZs18PNFhWjtkAdzH4g0FFq
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
---
 mm/swap_table.h |  2 ++
 mm/swapfile.c   | 50 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 4e97513b11ef..984474e37dd7 100644
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
index 00651e947eb2..7539ee26d59a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -432,6 +432,38 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
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
@@ -445,7 +477,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -469,8 +501,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -485,7 +516,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
-	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
 
 	local_lock(&percpu_swap_cluster.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
@@ -522,7 +553,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 
 free_table:
 	if (table)
-		kmem_cache_free(swap_table_cachep, table);
+		swap_table_free(table);
 	return ci;
 }
 
@@ -740,7 +771,7 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4076,9 +4107,10 @@ static int __init swapfile_init(void)
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



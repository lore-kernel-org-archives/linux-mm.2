Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B498CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A776B00C6; Mon,  6 Jul 2026 07:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A476F6B00C7; Mon,  6 Jul 2026 07:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9585A6B00C8; Mon,  6 Jul 2026 07:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60FD46B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:43:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5A25168A54
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:37 +0000 (UTC)
X-FDA: 84958166874.18.1D582E7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E4FC100005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ubgLYkLd;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338216;
	b=As4otUOlqxigLkwV8JnI9/Ab1bEmYfckTZvSqZjpVEtXQes0ajkF14w7459XPS8mWxglUT
	7gyVGn31r0zLJT6yF8mjoH1THBdDQJKumieFuFE2HPNuHtY9AhiTzWJgINloinw+HZqUoI
	6901314wqVGeg9xlklWQnZTPZHziOc0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ubgLYkLd;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jl0EzRqSdRa4OVy9+POQCJxE66k0kgvAdByOlwf9yJw=;
	b=qsrh7kH79NOazjsj6escRg5gxCXWPSouOku3f/6PTSj4/N7HJpblpNgjdkxSusjmyf+v1U
	+L/CGgt8tbZtyrROAo4qO6utm7+Ghvb6vYNscuK8UzQVuy/lBg00XsQM0unYkQTdJxQ49O
	O6yCaWq9i8j06njy2n6drdSSfUcE89g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jl0EzRqSdRa4OVy9+POQCJxE66k0kgvAdByOlwf9yJw=;
	b=ubgLYkLdDhq4ZLHmzHVea+MLJn4M/Fz5kVH4pnIPyhqMRJwDpsub19uiJWTPs9deIW49fO
	RhBR33ZrmBQ2pA4T5gs0LTt3OCgU0KOsaVBzuxnfQBbFGwV76RyWRMW+0iza9jMX3i8lg8
	6KNz0nQfXpj1u5UG4h3/VoPk6s8ESvg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 1/6] mm: add softleaf_to_pmd() and convert existing callers
Date: Mon,  6 Jul 2026 04:42:03 -0700
Message-ID: <20260706114320.1643046-2-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E4FC100005
X-Stat-Signature: 1dzgkcfy1cxco51yc9jbhrah83qasop4
X-HE-Tag: 1783338215-447626
X-HE-Meta: U2FsdGVkX1/EPdc55R88DA4r8LcweunhxRh/+pImKsFq0hlho+MkWsYlj5VftOOrXuEXHCht/v12F57++PhVoNanTtVQS6Ja9rTBylp7lPbF9T6t23rUORHkU41khdWi4FxNJL0GC4G7F42GmQcSowM5ta9YEsd5FPcoyG6l7TEIFPZPAWw0jjOCEgnz1spCVOfUA5zIPYqshLJs1FvFbXZWdHu5tVn2frOmJ9Oqz9rNcVWXVDWCIxG/QGBwSuhbgHVVzreTfOTY8mjAmDDwmul3Mlp86ZdBXBohI+FpM4cEMnsxG9Gfbq9vXGlOi+ef322pQXef8m5SnZl2Oz0jm7NDlD9wjS8p0EIRiN6xEa64AsI+5OhOJ9L8GPmAclezEI3ga8vC+/U/lVr8nlS1coPI+gDHpljiLS3MwvO74eg7tqORIeZ9R/P0C6bEsAkU7Gw7pMrJ2v5PwZBN/EZM/J7Cn1nUegoqcpujikMp5tlCAOGJP5CNcro565Panczv9KYy7z/VQ6X4tO2fzg8wKuGjYTijoP63VCwJnBEdfhdTC2ScAraDueAfRMVlGUvk6r/2BstNJwEISx4DJnkYW1awYZXLdaNv3LE1tsxxG9/5IehliAus2tPPMmBee4SYuwUxyGdnJjKG6kxJYLEcSwNYBq3CvwGl6FTrbgTnE3EfR2dDkNFXkd3iPFDPHFFKWBxFKw/TW+BgjK1GhEgnNrDvAkYsYXpVtAjPh9QTy6z97sS0c72OC/vqwVgko1cgf2/ohheddjNy/LLzzv3P957RpnKsqnlU0QprQOh5uuZL/9PoLrRn/kEEWJHn4uFRWROuIHEIVwAvE7DB7leEoCa0ImAwYlrwlj+1Zk4Yqh4C69UqmA1N2Q8Sz5oMhtx3YopRunWUtkiojsRF9UoZgYbgqxf0gwTD8nNIbbPm2rl38sgrZnaFlOAL5u28qBrf8NUNAmD+nsE29JSjP47
 IZUC8hvo
 kjtOddWBC+Ox8VZ/yA1PZ0WjBWfMHf1XeLDKPiFdBYV8De+iSb8noFqMgJNG1qzv373duHCtHXuZ2/3lTFQXK5FR+Kno04j/X9Ogb7iEXfb42an0CDwUVI72ChDctqRpeQvgLC1/YoYj9KVKFFXwRvwkUKpcJwj9UqJXW0dvmlp0ou7eO8F03witcsaHhIZg7e9wMlOySjbct92XUVybFElhs6qelysWt6xssil36PHiZiWtxJrznNYLLC2vkOpQa9G1gQPpdqR+HcRQcES93O1JIByjfczRb0vLII+QoBhbAGMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add softleaf_to_pmd() as the PMD counterpart to softleaf_to_pte(),
completing the symmetry of the softleaf abstraction for page table
leaf entries.

The upcoming PMD swap entry support needs to construct PMD entries
from swap entries. Converting existing swp_entry_to_pmd() callers
to softleaf_to_pmd() in a prep patch keeps the feature patches
focused on new functionality rather than mixing refactoring with
new code.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/leafops.h | 20 ++++++++++++++++++++
 mm/debug_vm_pgtable.c   |  4 ++--
 mm/huge_memory.c        | 12 ++++++------
 mm/migrate_device.c     |  2 +-
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 992cd8bd8ed0..803d312437df 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -108,6 +108,21 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
 
+/**
+ * softleaf_to_pmd() - Obtain a PMD entry from a leaf entry.
+ * @entry: Leaf entry.
+ *
+ * This generates an architecture-specific PMD entry that can be utilised to
+ * encode the metadata the leaf entry encodes.
+ *
+ * Returns: Architecture-specific PMD entry encoding leaf entry.
+ */
+static inline pmd_t softleaf_to_pmd(softleaf_t entry)
+{
+	/* Temporary until swp_entry_t eliminated. */
+	return swp_entry_to_pmd(entry);
+}
+
 #else
 
 static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
@@ -115,6 +130,11 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 	return softleaf_mk_none();
 }
 
+static inline pmd_t softleaf_to_pmd(softleaf_t entry)
+{
+	return __pmd(0);
+}
+
 #endif
 
 /**
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 23dc3ee09561..18411fb09aab 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -758,7 +758,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
-	pmd = swp_entry_to_pmd(args->leaf_entry);
+	pmd = softleaf_to_pmd(args->leaf_entry);
 	WARN_ON(!pmd_is_huge(pmd));
 	WARN_ON(!pmd_is_valid_softleaf(pmd));
 
@@ -829,7 +829,7 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 		return;
 
 	pr_debug("Validating PMD swap\n");
-	pmd1 = swp_entry_to_pmd(args->leaf_entry);
+	pmd1 = softleaf_to_pmd(args->leaf_entry);
 	WARN_ON(!pmd_is_huge(pmd1));
 	WARN_ON(!pmd_is_valid_softleaf(pmd1));
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032702a4637b..b6f8c83c1000 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1819,7 +1819,7 @@ static void copy_huge_non_present_pmd(
 	if (softleaf_is_migration_write(entry) ||
 	    softleaf_is_migration_read_exclusive(entry)) {
 		entry = make_readable_migration_entry(swp_offset(entry));
-		pmd = swp_entry_to_pmd(entry);
+		pmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		if (pmd_swp_uffd_wp(*src_pmd))
@@ -1832,7 +1832,7 @@ static void copy_huge_non_present_pmd(
 		 */
 		if (softleaf_is_device_private_write(entry)) {
 			entry = make_readable_device_private_entry(swp_offset(entry));
-			pmd = swp_entry_to_pmd(entry);
+			pmd = softleaf_to_pmd(entry);
 
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
@@ -2570,12 +2570,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
 		else
 			entry = make_readable_migration_entry(swp_offset(entry));
-		newpmd = swp_entry_to_pmd(entry);
+		newpmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*pmd))
 			newpmd = pmd_swp_mksoft_dirty(newpmd);
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
-		newpmd = swp_entry_to_pmd(entry);
+		newpmd = softleaf_to_pmd(entry);
 		if (pmd_swp_uffd_wp(*pmd))
 			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
@@ -4927,7 +4927,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	}
 
 	/* Set PMD. */
-	pmdswp = swp_entry_to_pmd(entry);
+	pmdswp = softleaf_to_pmd(entry);
 	if (softdirty)
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
 	if (uffd_wp)
@@ -4980,7 +4980,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		else
 			entry = make_readable_device_private_entry(
 							page_to_pfn(new));
-		pmde = swp_entry_to_pmd(entry);
+		pmde = softleaf_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
 			pmde = pmd_swp_mksoft_dirty(pmde);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index ae39173d6a0e..aa948db49501 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -835,7 +835,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		else
 			swp_entry = make_readable_device_private_entry(
 						page_to_pfn(page));
-		entry = swp_entry_to_pmd(swp_entry);
+		entry = softleaf_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
-- 
2.53.0-Meta



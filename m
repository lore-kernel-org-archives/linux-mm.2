Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A05C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2B36B00AD; Tue, 30 Jun 2026 12:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AC36B00B2; Tue, 30 Jun 2026 12:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0B66B00B4; Tue, 30 Jun 2026 12:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC1686B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:41:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B31A120197
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:41:58 +0000 (UTC)
X-FDA: 84937145916.17.E182BDB
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id 913DAC0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:41:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e+MM/bKC";
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837716;
	b=rQ0vseuBkKNrKbJp7ywhcFxDp8YasATbzfukxRodT3oT0il/vfd/8pzdx0x3uhQ4YT6Hsj
	GYvBLbhanySikr0xdSeHBar1eJF1GCxdXPaxpiasiZ17QynkRtSOrY1D/4cI5OL6gPEHnQ
	PosJlLKC0nxvW2HFVQLzUjQezrZnxK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27QE2OzMdozbB1MBhDEzH9Eaa+A92o4e52l9BnnLq8Y=;
	b=2vQTaFAAPz9NYAZXAPS0OEArBA2EU9CpgAmEb/op2U80f5yuk0ADVUOt+ysT7YVOZg06+2
	0FcgxmNX+HyQY7Mk0jhkzFGuH149lY2W+o+FtL7Tx0npDHtHp+zZi/bjhIcAq9LtN4D1kP
	Jn0eOEMzEQQhjz4kcV7pBwGhRugGTBU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e+MM/bKC";
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27QE2OzMdozbB1MBhDEzH9Eaa+A92o4e52l9BnnLq8Y=;
	b=e+MM/bKCBJ6H6nmzPJ/SgRNZmUfYV8S1/lWDYDXFub0p/EAjOP+uI2dY1BvGd30xb4E0+y
	OC4+qNjiYLXiSvDTT134QzBkzo8HG1hRh72iAebU6GlZcIoX2EbfRseL4KM2W1LiDR9bOJ
	OMYLj67anwbW6FrQ9taYSFta5G0jxlg=
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
Subject: [PATCH 1/6] mm: add softleaf_to_pmd() and convert existing callers
Date: Tue, 30 Jun 2026 09:34:38 -0700
Message-ID: <20260630164143.1595669-2-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 9fax8hmo96b13jucnoz5du98w3h5t5bm
X-Rspamd-Queue-Id: 913DAC0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782837716-229300
X-HE-Meta: U2FsdGVkX19LUwviQpuYpbtHCEIEIXNiqXw9utoC+Gbg7kR6Gahv4SmvEotorPyIVZ86GKIsokgFBkca81Z9xh/hWiZtbwV+d/Iw7Zq09sushDmOMs/UCiQ/6iMVCP54ggN2sR/xwb24+KPJUq6defrmVyfBV5m6zBcP1Oq7jelLjVt9UEwTJWv/vk/nTjGXyP7L7q0xSstpUEaC3F8wLv/3u2vTUD9kWOXBKzKXR4qsgqmOU9M6bTi40buFDHIUFj96pjX4fGOrZnnUyzvWuSf1yp1kn+oqBfnD2kOJ0mqByg83vihF7ETWIuvFgN0wQQEh7nUP+44o3EgXOZF+hODZUNcw42LX21okx6OC1nV1RbXYTUcvIwAhgGSqWD6BZS21SS65EAH2OBNqWwd2IAtCjIKjjyJRHYgE/3Z2L3xF9CT20I1WI0J1dlL0e1Y9wUMaKtapOrFT3H1bollYipZl3GYyFqEjD+jPnZTkgGQsNJfEjEogAYliOPPM9pHKne0ffT35UjE/0hPQB3mAt2sT1Nc66liPK8Yma5SdUiYC1ZmcL/uvMKtudQ/Ql0s+HfJv8kKnb1ayUvtFy3EMlkltFXob/U5tH2qhdsoAUuM9oB+i56ucyV19XE0nBGqjxz2NSXAoZLbcO34SbaFtb34F9k6aKb1G7NfWRVX+RB7Law8t+V1ZsdsS4FKSmeKYHTMF2+G1nshUdxLfoE1P1A4O/2HGVEEOOq6m8c+ATcyL/noyI8GGVl/OWQXvf3D8m3Hil/Afq/Sm60br9WxpXdumVKYh5fMoAOdF5ZhxP8qt+zec+6mukERiGuYIT1CnPTQOb2lAS7/ZcqfzbA6wycUhmvltmMAw7E6bKr8/M8niecFFElGWaLbmDr1MwUNJBcoLFbNIsJUPIC2vIgElMmJ3FZFoSHTx5eDJP75NruWgDWgLU7J1lO2FZ3RTyrqYZ3EaAd047aLOrBl6jTj
 oWAwQkGY
 vtNLzalzQ637xp7lm8H3BaUKgYLvO3bG6MDuf6InYDWTu9ot1INUNVzrhxlAImva0fRZplyPL1DWM6tsfnS7zE2an8aMFRDWdzY5WfJqfoV7tvXvYGLqob3mHIPta9vNNvvXgEUYJl/1hetsmY5jzRIK9oY0Z8fsVqg80gj1pEuaFepXMU+2v6j11tRk6DPMxj0ltqJ9HwIGkDt/5jjZNlkhvmbXpXLPvwlZTD7gj98UNbuh3hkzBFkW6Cc/8FntLhYfZSIEhuXR6mVLFD+g0CiScKjma7ucMn1yeyGb30FNfb4w=
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
index 2bccb0a53a0a..d51f53cfbe4f 100644
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
@@ -4923,7 +4923,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	}
 
 	/* Set PMD. */
-	pmdswp = swp_entry_to_pmd(entry);
+	pmdswp = softleaf_to_pmd(entry);
 	if (softdirty)
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
 	if (uffd_wp)
@@ -4976,7 +4976,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
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



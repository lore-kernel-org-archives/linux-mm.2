Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97905C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9147A6B0098; Mon, 20 Jul 2026 05:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E93F6B009B; Mon, 20 Jul 2026 05:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DCC6B0098; Mon, 20 Jul 2026 05:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 538DF6B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:28:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC259160377
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:28:02 +0000 (UTC)
X-FDA: 85008628404.10.E384C4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1165D100004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:28:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhoOW5E0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4F0Y1y3e7P02v62Ksn+cNy6d9dT3Httamrf2ioWnEio=;
	b=HGX14SXjkcTFqjPvfER/eEVKQwjLmVwo4FA3hgBYkSkdKMkXgahmjvplnVv/4AJL7WyIdN
	yKWOkFWVBKE/2GTVep/MlORBlMm32Wyn7Y7HOuoDXMR4ekP7TKK+P0XfkbFEFYmRdLzHO1
	PFptaHIIvfqStwkxIgLES5H1hZeJ0rs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhoOW5E0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539681;
	b=foMOA7l5bzEwoC+PlFo4flWJjrHboSawsJcrS41UZjsmm7yXzTri8HlaYPdPw3bHIS7egW
	XDXkXMrehPKXES37XBqE6cwm4ApHIc0ujGgVwa2dH3uv3IRRiZVZXu6HSF1JjEwOK8TvPv
	MG8CGR8whK1gom2UaHEFqa+w9xWALaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ECA2433C1;
	Mon, 20 Jul 2026 09:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6AB1F000E9;
	Mon, 20 Jul 2026 09:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539680;
	bh=4F0Y1y3e7P02v62Ksn+cNy6d9dT3Httamrf2ioWnEio=;
	h=From:Date:Subject:To:Cc;
	b=GhoOW5E0sxo4WMQBcwKhSn9MIKAFQZfZynMUNtWe5Lx6isT2Qzk03RfkiYkjOP3K5
	 7mhuIBUIomIfI4H9I3QRFRC7Pl5q7kDvF6s5RBejUjTXb1qGKFo+Of9orJWP632jPO
	 DSyl48+Y2GrIb/PqU03EGqChUKdfvEFt5RHQucJQp9gu47L7LWngqMqAkx+oOfPLfp
	 zJrf/7cD7u/qqsXyq3B9ttjdWJdiB7fnsW+kF9J4tJGCC13wQlYCenUGjbHNR7NwAb
	 nHudXZ5k9d0MJZsz+F9oR/HNX8FINGjoZpogmB1awkETmyxjtscnXuza95h6j/lTIA
	 FVNJ62uWgPkCg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 10:27:29 +0100
Subject: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
X-B4-Tracking: v=1; b=H4sIAADqXWoC/yXMUQrCMBCE4auUfXYhCaUtXkV8SNKx3VpiyFYRS
 u9u1McPZv6dFEWgdG52KniJyiNV2FNDcfZpAstYTc64zvTO8E3eHLPnO0rCytlP2HxYoYyutWF
 sbXSDpfrPBXX8a1+uf+szLIjbN0jH8QF/5P8MfQAAAA==
X-Change-ID: 20260720-fix-cpa-kernel-pagetables-e641bd41c281
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Kiryl Shutsemau <kas@kernel.org>, iommu@lists.linux.dev, 
 Kevin Tian <kevin.tian@intel.com>, ljs@kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4370; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0/SFVRLKk3KYBqnT0WCzEikqpggRaHYLYQY1y4/xZuI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJiX3E/meT9VS33pPisB9oH1j/lmjHJ5fAS3b0+SVzrR
 O+veBRe3lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJNGgw/NP+nb3oVNT275XJ
 L16tTJizaVnq+W28DxNLPybO1ruz6uVThn8GgkuPtSdpX/VfOMtGefIS98NW1fnK9Qf55zzWeba
 Ug50RAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1165D100004
X-Stat-Signature: cmrtyb9eoxubkcz1ftk7uwjhn6g1wp6f
X-HE-Tag: 1784539680-931519
X-HE-Meta: U2FsdGVkX18dlXsJCwOMaIMv6y/OLLz6dTZRPVdvIbn1NGIiLoGjJOgisno3dy5r70yFwufDVqLNLCwrpQKav/txSZDFxbb5iqksROVHv0snMcj8ZBWEqMVKLFLj0YESRDMqxB1l6fDYXmgL5bxgKZpminLIMrm5zk4COXjzcl9tUm38kyiN6VLukKHLCGDI8XceTG0yqVEFxt1dgSGQkcafb8RP0QqrczohCUh6I2QhxB0w5Pdfri/D42h3Z2EjcW3xd0pA8RXeKsumBo4FdfMr3Iyav4F0VJ3zgl8ahcbPzgwXLiWH9gows4DyAoq/Br/4bOL2d1jL7p88wFpdgUIwoipL3jtm7YPiVR413Z5T3AhOUpZeEurDcaK3QMsUkR+kcyC7POn8Cam+iKyqPvLXOD+YZoS5hjgGXbS8NPN9hLiTQRIG8y4TBMIzAbfY88SOBcuzoU8IatpzwJG5VzoA1uymO0fNOqoSauyQips65Dt7SN4mzy5ZShjBSs9qhdxfFKZmO9weu0Y1jWDoKuTqxc0MqJKY8NdyRAA54kBK4vPJdL0muRbv+zvheGl4/fmg2sm3bZ3CzfmXaFgud9OZXm63JXDnuKKxigAkw9tl47o3idatIf4DufhUGwd6pX/853Ehd/5KksDYsOZh5my3IC6cTFyiC3kR718CNSrxZub1hvfNWY5JzMHttpgPJDZ7x3i0AQCODgbtJ37xVG8YWHQVhKRnZSU+cdz6TQIbp5KEJ3MOtZIXLQzp4MjBMGBIUU1aJlBGApOrPvoBQg2Z09Ai0dm8M6M7RTRocq6jX8dc+NNbZEa/BIM/zHU0ZFW0zXdUZhxFdLn2NfobCxUWSxxpGanEYmtsk0LvQGf1b+gjQwdmtXHEuUbPTUJhytwQOswSHXHvhbCz84t7sWB3DbXH7SVj2l2SxYrA3jrHbnCKR3AIpxvrMX1YBvf7kosDv+M42t+IJDEWLJs
 ZNws5AJe
 ANdHdGbQoBZiJ0zPulnssEvhgQ3fEHPbgcAycOiNT83POHPci0LcXDdh4+Qf10YDcRNoYr4OQKjPY5fGPvQduLTl5LACZpXHmT49oxvib4b3b114Lf8JPE55yvYB2KVJorziZDjW/scjESkOPS7fthOpUqYDFXHbAJmIRiqfJ5DPz00BfElL/Vq1+NLcPfk+kujrjrRt9ZuMC80LkqzE4PudUttzEGpBFK7zqsFkwx2giDxOL5sGQLf8ixw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large page in CPA in __split_large_page() we allocate a
PTE directly without going through the standard page table allocation
routines such as pte_alloc_one_kernel().

This means the page table constructor is never called nor is the page table
marked as a kernel page table.

The former results in the folio associated with the page table not being
marked as a page table (__pagetable_ctor() is never called thus neither is
__folio_set_pgtable()) nor are statistics updated to reflect
it (lruvec_stat_add_folio() is never called).

The latter issue of failing to mark the page table as a kernel page
table (ptdesc_set_kernel() is never called) is far more problematic.

Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables") kernel page table freeing has been batched and since the
subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
for kernel address space") IOTLB cache entries for kernel page tables have
been invalidated upon being freed.

Since split page tables are freed without this invalidation, the IOTLB can
contain stale entries for them.

Resolve the issue by using the ordinary PTE allocation API at split time.

This results in these kernel page tables invoking a page table constructor,
and thus requires a page table destructor.

Since we cannot assume one is always present (early allocated direct map
page tables are not marked as such), we conditionally call
pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
otherwise we free the page table via pagetable_free().

Regardless of which path is taken page tables marked as kernel page tables,
which now includes split page tables, take the correct route through
pagetable_free_kernel().

There is a user-visible side effect in that split page tables will appear
in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
allocated after early boot), however this is a positive change.

This issue started being markedly problematic after commit
5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
choose this as the Fixes target.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 301fb9e77d91..a67ca33b9dd1 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+
+		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
+			pagetable_dtor_free(ptdesc);
+		else
+			pagetable_free(ptdesc);
 	}
 }
 
@@ -1138,11 +1142,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct ptdesc *ptdesc)
+		   pte_t *pbase)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
-	struct page *base = ptdesc_page(ptdesc);
-	pte_t *pbase = (pte_t *)page_address(base);
+	struct page *base = virt_to_page(pbase);
 	unsigned int i, level;
 	pgprot_t ref_prot;
 	bool nx, rw;
@@ -1246,18 +1249,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct ptdesc *ptdesc;
+	pte_t *pte;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	pte = pte_alloc_one_kernel(&init_mm);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!ptdesc)
+	if (!pte)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, ptdesc))
-		pagetable_free(ptdesc);
+	if (__split_large_page(cpa, kpte, address, pte))
+		pte_free_kernel(&init_mm, pte);
 
 	return 0;
 }

---
base-commit: 890f8c4e827c918dac668a12eaf63180ba8a9e6d
change-id: 20260720-fix-cpa-kernel-pagetables-e641bd41c281

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>



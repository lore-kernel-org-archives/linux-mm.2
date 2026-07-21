Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E52CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408D36B008C; Tue, 21 Jul 2026 08:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0B36B0092; Tue, 21 Jul 2026 08:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EFB6B0093; Tue, 21 Jul 2026 08:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5E76B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:15:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F5FD140133
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:15:19 +0000 (UTC)
X-FDA: 85012678758.21.353C903
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C59580006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:15:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3MlDfIO;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784636117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rgk19z5wBcSkopJP5DQnZm6oUtjPmjQV+SnoXSevxp0=;
	b=BgUFE9hWi3CXzKtQ/vvE6vHItljEExCLIYj8fS8Tym26J3QW2SYwQJHFtXesbniGQF4FtN
	DosGThyO8oUoQEjsg9ItilW96W8rsADnMWa2HPMUiddW/2uHGOARQwbkj7JOF7np2PSMiz
	8TLwl5a1cBia1i32qBDy4EDyPe2VAqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784636117;
	b=5MXCEmRVy9L1ufNFwoJEFmHovegVmjujd1omkTlx0KaWwr6YphUEOFPYH4C4SQG0TjMUJ9
	xNz21JNL8ue5Fl+AbvWuRcphQnwTQjvKvXKivKLfun42IOaAq58qLp4rywafJFmnSbkS4B
	VYOybDZwyGZEOKF41eh/T+2M/MqayuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3MlDfIO;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 855A441198;
	Tue, 21 Jul 2026 12:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5BB1F000E9;
	Tue, 21 Jul 2026 12:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784636116;
	bh=Rgk19z5wBcSkopJP5DQnZm6oUtjPmjQV+SnoXSevxp0=;
	h=From:Date:Subject:To:Cc;
	b=P3MlDfIOpiVgiX71b7+hBO/WkLafEp01fAHThAIGtbzT0Ytz2r/B+bNKAPr8pLYdK
	 sWELk56vfnbsnb1/TVf9VwMRF9TsU87/ebYfzCoIXynczqVibbThSvcIz8vViSzf1F
	 dkxbOA73VJGti3tcxh5AKr/Piq3ErsDXV3r/fTLslpJglzCOeDIJZhImVZNAjYfU5P
	 U25Y8V3rURaBnQz/pl3+UVeCwRDnC+lrUCGlg7K5T3Qo7kWTUiBSSN3oyV4bgTXC9S
	 2VhCwNuayesP2925rbuETzlnUH9ABQ80AJ8msQR4yK1ooz1p4gIBTlPJsp2U8G36k2
	 6JeygAUXzTOAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 21 Jul 2026 13:14:52 +0100
Subject: [PATCH v2] x86/mm/pat: allocate split page tables as kernel page
 tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org>
X-B4-Tracking: v=1; b=H4sIALtiX2oC/42NQQqDMBQFryJ/3V+SIFG66j2KixifmlZUklRax
 Ls36gW6HJg3b6UA7xDolq3ksbjgpjGBumRkezN2YNckJiWUFoUS3LoP29nwC37EwLPpEE09IDB
 0Lusml1aVktJ+9kjy0X5UJ4d3/YSNe3A3ehfi5L/H+SJ375+fRbJkUWiNolQWLe6nc518R9W2b
 T8rayna1QAAAA==
X-Change-ID: 20260720-fix-cpa-kernel-pagetables-e641bd41c281
To: ljs@kernel.org
Cc: stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>, iommu@lists.linux.dev, 
 Kevin Tian <kevin.tian@intel.com>, Vishal Moola <vishal.moola@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5554; i=ljs@kernel.org;
 h=from:subject:message-id; bh=pCtXRjw6ZgMa3cHzlvS20X0DiuXByBGQ9I2rhzbSYX4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLikw6/nXTY3+f0Pz7tQB47DscqY9uIxZlc8a0b3jp/2
 MFaxGDcUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIm0TmdkaOz9+/+5zIxTAQmX
 7aoPd048nN56Ied+YdR6zsDjExbvd2NkeMG7TVrmUm18g94fAWn2sw5dr+bszDWKXzLBTrPZ7tV
 XfgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C59580006
X-Stat-Signature: bhmr6uwoxd571wewkuecm6zpker5zgur
X-Rspam-User: 
X-HE-Tag: 1784636117-965591
X-HE-Meta: U2FsdGVkX1+P5PdGCWXsTHH8fOyAEDkrfCSKhHRnU8vzTxl9eTMYQtFhb5REvAaLlx+REEPP1f7Wio3HlkIyxxzvsjZ1wYbfysL35kbLUfucj7UxeW3HckwSDg2FsVZ1lagxWKHkGlZgGKfkT2oigHObSyDBxoepMc4b5RPn0hTluRTTz/BgqX98VebTc+djLpQSz3Z5fTN7X+felio2ip3Tpd4bywb5UCw4zIPJj8iQn3hJq2MWhveSaR5/oSVVEmhUSI8eA6hS5G2ip1kougk1hfgzBFnVUIfoNP2DFxVHcb/FVS4GStTHAGUgx+6bIqCx74DPBM6Ay3tr87xCsWYi5IG7M4++kco3SkpeHgr9Msw1MPJunvGLlWGTfMvYgRB5YHfDP7Iq+WTZBgWrG8sXPs55IXZC4CSExtr+cW72lo3R1tVJwKh6wHOqcaY1dQEaMzmQ0Qmsq/HXhsRwy6bfQJIV7VLt6PZ5KxvLMfQ+AV25j9HnW2t4/8tmKeYgX8jIZkGfWjh3GE/oIJINojpD9/J3bsK9rm7YYw58OgQX/ouU5MEzcdcx7zJUQEeZDznDiq0CA50Tm/ED9YyTg7QI4PV88ZLTRfZ9hx1C6iRhXpHTMDcKM4hvCWx+lbjvP/mxZeUi3ZYeMYvOZ3PWz/EYDsT3ngrigGGgg0BkoLgGvM39Q/A8ED7uzZbPx792HTMZLdYGjMWSr1MpjfWAsrzn2QwfqvAm4nXVtWQSshG9KSo/HEu7r2dMRhFmRNComSNmETkizhNOun/MedCQOk97rv5Gb5OTtT3AeXIvrLEAfZPHE4f2bCWAQkbtu5FIz5KnLU2ZqUct6o0sQsQaerygupzQLsQn27hvzbwWq1bjZ6bLezSx2e1BfyBGm/jginaYRAki7yoX2RFjkNFRSMR8nUrDxegZ3mu4H07G73QONgoZf4A2DEADK+YFqeg1mrMtIhtt4BdcK03SBc+
 SqZutoIm
 odr+a3aMwBKYqGWJuO53WR3kwjMinDlnLLjFkKp/HwHmX6QAKnZGslj6VeaqmwQtxuk6J+28RWdQ1a2OvN4SmwXbHGmYEE9/96a0Hrp9x7Pvn65TVQlpe7bEakEYcyY9k8TGPqMtSlgvoxzQg1jklE5WZ299gUyA80DYLI2UzQoEQHEG9OCZoxyYy8+ERkRsoCmWJY3j64zYvwGbFaVRwLrZsA8EqEk/z5+vh9lDdCfKU/uomKX5X47iSTd44wc83GlEknxQb8A2Y+UcVDzMx5a0FbANQxchPWX1ilLEwNDo3hcONutdUzKctsBE7imAkxwvpV5/zb3OGBUHaZMZGA1Th3vMJ52CNs6WCUQ+HB0J/byjHHaVfrR+zz1Klj7U5+q9IqehxJPpooQmLYZ26loA7LCLo6+BIyiVEJ3HK+bh/CQ4dmNBLy7ksmDHareNVUWxVFUByZiPk6zOskyoOEHsHd7s15T55rt56Wgpd9a3POpZcuHMm/mt0At4YKivN3qbYMx5pinwWTBlKadgyqPPaGFqjGLvAfwYceEk7aMPLYJvrmmwmBPK7toNZm+prlQbhpOcQH1cfZucJARy0zq8dSg57LZqh7FKI5CTsOcb7LiQrMHPA2hLM5fDp6+eTQE7cCzuuDKZoGaNkgnWXbGZVentCu4q21rlqIYly9mB6DlwqtxzQH0cfH3PbLvzUrwIa52j3UMm6l50RqZNLs6dhy4DLAAE/Rl+42c6aLgyJY5NunvC5RvZ+erKv3bRiPeBcQwgmDns0FLQ=
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
v2:
- Prefer PageTable(ptdesc_page()) over folio variants as per Vishal, Mike.
- Add comment to explain why we're conditionally calling dtor.

v1:
https://patch.msgid.link/20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org

To: Dave Hansen <dave.hansen@linux.intel.com>
To: Andy Lutomirski <luto@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: ljs@kernel.org
Cc: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 301fb9e77d91..078689aa7206 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -439,7 +439,15 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+		/*
+		 * Only early alloc'd direct map should not be flagged PG_table
+		 * here and those shouldn't be collapsed. However be abundantly
+		 * cautious and handle the !PG_table case too.
+		 */
+		if (PageTable((ptdesc_page(ptdesc))))
+			pagetable_dtor_free(ptdesc);
+		else
+			pagetable_free(ptdesc);
 	}
 }
 
@@ -1138,11 +1146,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
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
@@ -1246,18 +1253,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
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



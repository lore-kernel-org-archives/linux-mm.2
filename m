Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA56CAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460BD280038; Fri, 19 Sep 2025 01:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410B828000F; Fri, 19 Sep 2025 01:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326F9280038; Fri, 19 Sep 2025 01:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA6A28000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:42:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7F9A1A0528
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:52 +0000 (UTC)
X-FDA: 83904905784.25.4BD31C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9190100005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ef/pAWxo";
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3dEGx9N5xDspvvzcLbNowjJ1RwPiZ46S1w3F7QeGW4=;
	b=fJRcJFOPnrOa8lhuRCCrGYNrc+9US+dUomo3OoYWd7vuF2pSI2RcJuKeuYtziEM6rvXcWU
	vG0cc/uWHe3z7kh2m2ggEYySrTLQwJQjik9U0WeQo6UtW3ZGzLbGIKUArZTkB7zVOZ2ysb
	uD+OtJSX1w/c5lZa4RVE8iDp75nBiZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ef/pAWxo";
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260570; a=rsa-sha256;
	cv=none;
	b=TRJHXZKnLOFKwOO7eSeHCmkQslEwR3HvHwY525IbDXcm8tHwaxLhGkj2fLF/UXBbRgoXZC
	Jb6sYbWnT2EIesnfyLykuLUMPQ6XPMEJVwmAjyKZpLF4fLZlrDDfmovHQuiRRX/IHPgLip
	8/Pgbr9UqWykWmilf5aJKVaqX1Oq7M8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260571; x=1789796571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=on6Ag9NJz0vk1kj+5aoSFuQQtRI0JdB9JVEfIv+bEQw=;
  b=Ef/pAWxoqZbaz1tnEp1AITYHGYQnNO3pLm41JvC1Qk41ehlnadfJ/28P
   myxzCct91DcgtIeNQYRwierBYn3wPBqQn0Rw1rMHTRoUvpqPx5AD1o18U
   NOCgc9XZSX83RSITIwyYuKwI/8uggYa9NUdKRD/MjvyW8+NlmcE2/So3E
   Bnhmjx4V4sDIL8hXnpi5aAk/weQuYLYR+ijy/2rMk0kGhqO4ARrQsZ8n0
   lbqJl/OQOanuBhJn+D1wXeuIUDbaL+mfb/xhUW3OXGDLBf4fRBuwF6vbu
   syiDHBSOTN+eKFgillIlSmOj16svJF1HGMpqzyIjXs14mtx5X9NzY2O/D
   w==;
X-CSE-ConnectionGUID: AZ/O3KgfQfWwcNk2WPPoew==
X-CSE-MsgGUID: TjfLFAg4RNmpYbFPhV6fLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235768"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235768"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:42:50 -0700
X-CSE-ConnectionGUID: qkeOHv3KQkWG9mTRxGTyJw==
X-CSE-MsgGUID: rMlp4P4RS12+n9gODhJ2ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858628"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:44 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 3/8] x86/mm: Use 'ptdesc' when freeing PMD pages
Date: Fri, 19 Sep 2025 13:40:01 +0800
Message-ID: <20250919054007.472493-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9190100005
X-Rspamd-Server: rspam05
X-Stat-Signature: 9wurui8prrxm4nsy4pep9dzsgke8598p
X-Rspam-User: 
X-HE-Tag: 1758260570-972897
X-HE-Meta: U2FsdGVkX18aO0wRdTmmrK7QI3DCRy40AOnkR6F0uDarlbz0flm6CVanJhQFEkcNlNZPt4Nj6oh34NSix1EDVS/0LVLo3cT+yJYjPrQaYqaAx+V0YfNxUeNUBd3QpwFzBEeBZ9rLTY50s8K70nwdX2qRlfvajHSbNZLhL7YZmkXkF8Sb0ZaHUbfmsQvFxahRp1ajTa7Iw16Id3WFMCRdWy/R5XhYs/65EnR82nlf+0tjHwQ6Xsqeht6nxhPp5KZIQQvmUnu20TLst5u8+fn1fOQyAHq/hhlIOgBVrJ6sgSKOCd7jonP4ZEXF5PlFqORgCvShvY4hJTcHuRam28QgxvlLAcEePsdvB8f9/pUNJhVCV5nUWzOyhAcI9lcf6Cy8L/wUUAjXcDBa3/qvJHA0fvrj57/2yfZPe9VzHoXvEkeF1sfjlrxy3tP6i+CbhPECebNfrKDPce2i6rZPCkd6LDT/2Btb7Ca6H9S+GqsaYdZBot0jO69N9qKWmBdeUGREAT/ghJKyzTFrBYqIOO/YIrxXU4yYarz6I4XoFMNvPcVq/6ePEBynTQoLpGBByFOf851Ix2aSfjqGbZtQ3hwcuMm+O9AUKkVplVcTmRksD92Z1+QNg0/Gq732l2sBW2DNvzHMmElkEu+uaPyVN3F5eSVjSumdnz7curQoH0ShG3hvv8A9V7Z6KTSgRYn08uK7q91N7AaRU6ZDH68lrm6N4/cd3VFzVOfXsd/472BIp2YfrFux4xKMn+7Cq3Z2nEbo3MHZ27JcA0fFZ5g82rG/BwzMw4fit9o66SR7Qyp8huiNel6mRJXhOKqARgzBsNB5ySzO5CJ0A0zkz/uZqRQMma90KHWdtSnqEwzl8Hk21hV57uG1SSXNLLDt9aEh86ESVTqjs6VuDY0HLwOTXzYTEF3uIbrx2/rQGxMn5wjWs7i0dtANVFWxzXnLMhMWwX+VLTAMr84oNXNfnr5eeda
 qYL9djyB
 bsTIiLJMeN6NS/dGzU46PrJk/0Z4nROY8Q08FvVKs5XWKb7m7CluuQqLHtPlbi6UREjI0gjV6m50tHBZo7GoZL7imSAnNPpfM2Bsjc2iCA1rnLAxByIGGC1VJM72hFw0muu6q6Tz79VjtTkFY1Cf6CmZ1FTaxZaYNAE96SRb/DugYL+42E+G3myyc9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

There are a billion ways to refer to a physical memory address.
One of the x86 PMD freeing code location chooses to use a 'pte_t *' to
point to a PMD page and then call a PTE-specific freeing function for
it.  That's a bit wonky.

Just use a 'struct ptdesc *' instead. Its entire purpose is to refer
to page table pages. It also means being able to remove an explicit
cast.

Right now, pte_free_kernel() is a one-liner that calls
pagetable_dtor_free(). Effectively, all this patch does is
remove one superfluous __pa(__va(paddr)) conversion and then
call pagetable_dtor_free() directly instead of through a helper.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 arch/x86/mm/pgtable.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ddf248c3ee7d..2e5ecfdce73c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -729,7 +729,7 @@ int pmd_clear_huge(pmd_t *pmd)
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 {
 	pmd_t *pmd, *pmd_sv;
-	pte_t *pte;
+	struct ptdesc *pt;
 	int i;
 
 	pmd = pud_pgtable(*pud);
@@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd_sv[i])) {
-			pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
-			pte_free_kernel(&init_mm, pte);
+			pt = page_ptdesc(pmd_page(pmd_sv[i]));
+			pagetable_dtor_free(pt);
 		}
 	}
 
@@ -772,15 +772,15 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
  */
 int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 {
-	pte_t *pte;
+	struct ptdesc *pt;
 
-	pte = (pte_t *)pmd_page_vaddr(*pmd);
+	pt = page_ptdesc(pmd_page(*pmd));
 	pmd_clear(pmd);
 
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	pte_free_kernel(&init_mm, pte);
+	pagetable_dtor_free(pt);
 
 	return 1;
 }
-- 
2.43.0



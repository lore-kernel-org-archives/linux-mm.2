Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0642FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C40A8E0014; Wed, 22 Oct 2025 04:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573748E0002; Wed, 22 Oct 2025 04:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462A58E0014; Wed, 22 Oct 2025 04:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30CCF8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED52F1A07D6
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:43 +0000 (UTC)
X-FDA: 84025076646.19.83870EA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CFA2180006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PAhJXsTo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3dEGx9N5xDspvvzcLbNowjJ1RwPiZ46S1w3F7QeGW4=;
	b=5XQkWYEWRAzxLX3vXKscqmX990fEKGqMPNTomHCnPcztjISFh2mLt0lxpjaKDhfplVVN5t
	M76QNWHxzYcpuZ6ev9yMZT9ziHtsF2e25dBtvzNmHbPjwRFDkE0dPZQDkBvcjZcGa2UEBJ
	qDs+c6z5/GiN6X2KByekDqbEQeKT9B4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PAhJXsTo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121781; a=rsa-sha256;
	cv=none;
	b=BHIl2AA6UlB1fT9QY0NaU/N7pz/wwXdZSV1TO6zxPc3DQ9I3i91EIa3LSZ3/JmlPFliW9X
	Nw/fBX6ZjJvbi3B94rRhEUN1xKroprnIGnrWZQR7YVDupPHSyhjPZSJoEcpZFp8/liVjZl
	UBjMYZvUMOtjASGgxlhSD5853MK9qqs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121781; x=1792657781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=on6Ag9NJz0vk1kj+5aoSFuQQtRI0JdB9JVEfIv+bEQw=;
  b=PAhJXsToIksw0x2X3xfbYnIa5Z0E8xxqD4Ye3J9SSW9QpsbSGFJdW8Fu
   XELtezSzeY3qC2OI5zCnuGa7uR2Nlib+RkpymaEqkpQq6DgmsFgbqnVN+
   l0xyt//HhnVl06dE/YijuffZDnAtMj4FeqX6hnCr2k588OBQoQKdbADju
   yHvrUELjVjCnCpvsF9JWbLtJwBbmnzZhs8U4YSBTHtBTeWBC9xTLG6UGs
   IugMdJ5DTr43LXEAQT0s4Zzi6y1lxMEoZjvTEsVVP1kWSrkMDuZh1EMs3
   knBE6EHzv7KJmV6z9n+5543Hc//nKOSDxpolT6iJHEYSZx1ERipDnF/Q2
   A==;
X-CSE-ConnectionGUID: /0s0aoA9ST2i8ivhkSxrGQ==
X-CSE-MsgGUID: LE00HLIcRTeKxqsbuUHPWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80885541"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="80885541"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:40 -0700
X-CSE-ConnectionGUID: Sa3UKoJgTC6E3excfo+Q9w==
X-CSE-MsgGUID: /pRj0LcbRHm0dwuta+OIPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516346"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:33 -0700
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
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 4/8] x86/mm: Use 'ptdesc' when freeing PMD pages
Date: Wed, 22 Oct 2025 16:26:30 +0800
Message-ID: <20251022082635.2462433-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CFA2180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 6td6ci5bybejjohjimn6m9gb7eyhttoz
X-HE-Tag: 1761121781-529091
X-HE-Meta: U2FsdGVkX18vVdOv3njTfo++B4q2twjiKZBmNQG/8ccvrIYqBU9KNclFcgMyF5/R8vwh2oGmNclHQtjhByMXZtQ3GZ32FFfQsPJN23jz9dJl7hsbyjPM+S1zdQr1TmsPyJ1UnJx/vnLCw+4G1V7/G6Ml7e96cwipV50WfDb9U4sCR0WzgOJlR9mKbSyZ7VoJE6arieYAzx4xKjQqe/9JVOBlJvsP7LMXU7m3gm4uFTFQcJadj4C2fVTaRNzaeVwgK0dbcFbjUtJihXFDAB60A6L0EJu8Toq81+nN2DJQMXUCQMgqwM/QTYxb50TWQEQha/LE3j2Q1T3GQdNrcOvuLRTApVDS2NlB9J8e5LMB2cu3JCguTV2Zk7TU75YMpXdPKK5djlqXcPB21DQTzD8IR/FU2HzCYVj4sEE4TLfSiYmSbEzGwA3iul/Fe3TRv5ncJHMl6Ez6N5d/eYuDuboRsDYiXPwKO0CLHwze/b9MEj02boif9Cl7yC5odPPGHX0qcVs/B+gIk3zzZG/vdGOmbeRX8E+6K1MOHbjlpqz60yYnUObf9PJfUqsKDlV3o3RtcJCSNUt/Fgssd2DHAkDeGET3wbsWSoRNOEtn52w98l5x4/ICGLJLVQX7COHwsCzhxxUh2M87PJdSJilGKgevTLx4k251/xXEwIp4rETuYl4+8XxU3DX8IQ6MzCkLZmucS0hnGOS8dHXPeff5XnWN6bdD93oN8Lb9pVVJDgOKHkbFfZ+6f4ov5K0Rx+99W7p6TimgmtRYCWf2ngA+hsfyXcLbOv76Q0laH2nNZq4LjYDmiRPvo1GJ36/readC6nyO5H5OUwIUCrGvVE9qWRNg30418tjiDQ4VYX7N44m92lYZ4I8AxY9YNFRyAyzRt9yHFPJ5iWVA029VR4S/TPjPdcUsyA1Zy/FgkF014IiUUQNS2izmGrIWWb0PA25dKDpe7W09OgkZA6mDXstn9AM
 RtC4vZb+
 snAyPSrcAm3e8Zt7pRdNjU0VskJy0hm4KJjCsTe3Z5Gl1Spm9Vflm08PHUbBMlXcOeDLP1UCcThIvfPyvc1US5p+hOT8GlqbUz2xXKND/y5L42TpM8ibpk5X46R9RHbjN6zSLtxfZelj3nP0ETiZmbnRovmscmvI5N5Hz+tXtMCmtAdbGNaMu71ZTHBbbgfPWmYlwk/JtGx88Jn8=
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



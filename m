Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7308606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UcMfD6EF
Received: by kanga.kvack.org (Postfix)
	id C45BD6B05D4; Thu, 26 Nov 2026 06:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF53D6B05D5; Thu, 26 Nov 2026 06:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5976B05D6; Thu, 26 Nov 2026 06:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2266B05D4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:17:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D55D1C42B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:18 +0000 (UTC)
X-FDA: 85477018956.27.6B6C8A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5EB6040003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcMfD6EF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691836;
	b=LY7HvG0xGjq5N65QthIUK/Qss4wsuEfvvLS/YL7OaOaL6xQcP1KDH8VJ6Si7vNitIgcXMt
	wnTLHhipymPNvl/gvuVddO0xmtGjXQ4DlzWUuK36meY2uou3qmIKOwJUD59e/3Ch2zH0cU
	Hdt1vhavGqiVZVtC8GawGRxXrE0OVjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQR0I1fT91fdkigqZPutQaUEm76FjFQYRJKTMaWDoC4=;
	b=D4sQEF3isvWgdLT1x1qidmdfMKkkW/pyTe5mz0wu0yELExldLPmVICw/KXxDaV57+WmNOs
	eA19RV+IolQuSKdUo9ImNVG8GAJDDNdu17TaA/LI6akSeXAkLcyigt6Dkdnzebs2FQHomv
	8LIazvl1wVpuI6eU83BFgsIAE14J3Rg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcMfD6EF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93FFB40778;
	Thu, 26 Nov 2026 11:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F4B1F000F0;
	Thu, 26 Nov 2026 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691835;
	bh=cQR0I1fT91fdkigqZPutQaUEm76FjFQYRJKTMaWDoC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UcMfD6EFN4cKBwOaWtO5aL4DV8MYygih5LNqLm+tzLxTNRXOIvLqKtAzBF0ZhaBkE
	 P2kdK4uYNvbHbk6pVNxYE1FjzNfMHG6gxnBz/OopLg4NvjD1qBb9hAx1HHgPh1MDJl
	 4/+2/+eYx1sjhjoyQygyD3BZ6hozC+nZ+dMUxYLKPDBuHKo7ncu63jozL0IqyFg0jg
	 YMsINPJSowpwfRTpTGZTF+0CdZRBhRuBxLWVw+TSUdLixc04V+2tSLDZubH5VwwULB
	 rLT3p+AEd9I9ue+1l3ls31RF1BMEZz7p/y1XxEXtI0mI4OOwo/poT0TAUX5YZNj0oX
	 AcEClNpvIcfvw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:30 +0200
Subject: [PATCH RFC v2 17/54] x86/mm/pat: drop the check of existing
 mappings against static protections
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-17-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EB6040003
X-Stat-Signature: uupjqcpz671xr9xgme8rdyy83o7sog7e
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795691836-756888
X-HE-Meta: U2FsdGVkX1/RuPgM9yfNRsGa0kubCCfgjr++nSTjj78mie7Mj9lwvDRUVlEXWSu7AfnzQ2muB5duyL1q9rEfFHFVWgbsaUx39g7Dk22zzssmsmAoHoSiBtP8tMMFuPf6peR+xoskgTTYPSpde8BlRJ38Lyv7AZKttXQkLUWiVWPnyR7hQAteCHxS8a4ggDVHx29fsj+3ecxIHKgk23u+VD0l6h9TTWPSO9okXa8TP6Cbj6OEJFYX/Ohz40++mTs4bKc0wJrvPPeme3Z+TTO0eZyhapyYufVoT/q+2T6It7M42ztXZ1jas2pfGmJ/n1/EqA6zvPFVF9uyf+cTTRjHrBx6rilhCFd8FQHkVnDLZiPNrGJZIsfM2hPPIWoUf3i0ns9OF3cdS9oMIPPh6cSqAx4OcDo1CjVlF5IreYSnmYBwZhx7kbTrG2dU1wiv7xKiaL8FpVBH8sRwasVHXr3QHkWFQqDNkwE593rGdNZiqBSS8uQHbcIvcEadDwzliNtPc0lwg1oyEJ1PSbTHASWIq20/lzLWUOa6VLJPAKK0Jf/4tZlPnEOrgQGdMCOSQQksP0+ALV65GfgCGDpLK3TVU3A2KHp9tCcYvD7Q+I3JjSqoryZr4BL84rot6KO+ift72/iczAQokAFuC3bdWk1hqfpMbGVoEtn9xaOEkupngc9YSneLkEUFMN+ILRQyTZmzAUl9rs+jio2IVNVSNuXdn7Mvi5Imqjq+OlPDnUoDrYUG1NuXJI3iaUQVGOh9N/z2c24jH9Y2GfvLxnchzUJx7EEAf5iVj+5gRUaQeR04Tgo2pDjHkUeyJ8Lqlg5FfCdMmJf4rBWa+3m9pCgMKI3HnMnltnNFDB5fp81hCkYKGt570UFaiWw4jjNCxoEq5jipAMNEo92jnZiTI3lHrsab/GY7Ape/xcEg+GoyPuoXKb3tlM7TRHTZngydbf0Ghdj9ax922Q/dA1p2TS/rrfH
 IB4DkCfG
 ugGvOoBkUVB5oqACOTS3yNNULYjBt+3xFOWtx1raE9Q5r1mcyElPDmJfgOyG/uW/kigRelYpTOI3CFiITcdxKc/4KB+uqIbMrvUUzSdq5tX7QkxQHAGT43VR3plYyyY/+2LxsTsXBCKMNMY6DuPpzegV4AmETZSCBpoDmrTXIM2IWZaf0FfUPrhni4RnMBT0gZ72YPkIYOuxSFyY2Ar3KvdfCTv1LZlnakfpQOiATp52c8/49s4R8YQ+vJq93tSDdkCKlcXEE1mirg5MT9sFMrQo3q3lm/dBhMITTtrakZwK7kdojdh/oN7lQdQjm5jf2xE/9G2wRLJ9/hBFo4C7sQMAIUE74PGoHaYEuz/Rkcg6jgVY8pvsuh10tstHpiSZRBLPPkyQcAEHierS6g5AeTNXcBtCJI6cGy6ouo4/HntyEPfqQ2EGWCWZaYagFhnZAbTTRHxXhkN1l06juYZn41+UY75nOuBzphGsx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Before deciding whether to keep a large page, CPA checks that the existing
protection of the page satisfies the static protections. If it does not,
CPA warns, splits the page and fixes up the new PTEs.

The only reason commit f61c5ba2885e ("x86/mm/cpa: Add sanity check for
existing mappings") gave for adding the check was that

	... it is possible to do a quick verification that the current
	mapping is correct vs. the static protection areas.

The warning fired only once, on an earlier version of the same series, and
the series fixed the cause with commit 2a25dc7c79c9 ("x86/mm/init32: Mark
text and rodata RO in one go").

Back in 2018 much more code changed the permissions of kernel mappings.
ftrace made the whole kernel text writable and back on every update, any
module could call set_memory_x() and set_memory_nx(), and nothing warned
about W^X mappings.

Since then ftrace switched to text_poke(), the NX helpers are no longer
exported and W^X violations are detected late in boot and by each CPA call.

A mapping that violates static protections cannot appear today:
* CPA checks the requested protection against the static protections before
  it writes a large page
* the page tables built at boot map the kernel text executable and the BIOS
  area with 4K pages
* mark_rodata_ro() enables the read-only checks of static_protections()
  only once all mappings of rodata are read-only

Even if such a mapping appeared, the check would hardly fix it. It sees
only the large pages that later requests touch, and of a 1G page it repairs
only the 2M page around the request.

The check of the existing mappings also complicates how large pages are
split and stands in the way of moving core CPA logic from x86 to generic
code.

Drop the check of the existing mappings and leave only the checks of the
requested protection against the static protections.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 73 +++-----------------------------------------
 1 file changed, 5 insertions(+), 68 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 967d691ef1c0..9ccc08cf220f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -52,7 +52,6 @@ struct cpa_data {
 };
 
 enum cpa_warn {
-	CPA_CONFLICT,
 	CPA_PROTECT,
 	CPA_DETECT,
 };
@@ -76,7 +75,6 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_ST_FLUSHTLB		0x01 /* the TLB needs a flush */
 #define CPA_ST_FLUSH_ALL	0x02 /* flush the entire TLB */
 #define CPA_ST_ALIAS		0x04 /* the request is for an alias */
-#define CPA_ST_STATIC_PROT	0x08 /* enforce static protections in a split */
 
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
@@ -629,7 +627,6 @@ static inline void check_conflict(int warnlvl, pgprot_t prot, pgprotval_t val,
 				  unsigned long pfn, const char *txt)
 {
 	static const char *lvltxt[] = {
-		[CPA_CONFLICT]	= "conflict",
 		[CPA_PROTECT]	= "protect",
 		[CPA_DETECT]	= "detect",
 	};
@@ -976,7 +973,7 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 				   enum pg_level level, struct cpa_data *cpa)
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
-	pgprot_t old_prot, new_prot, req_prot, chk_prot;
+	pgprot_t old_prot, new_prot, req_prot;
 	pte_t new_pte;
 
 	if (cpa->flags & CPA_REQ_SPLIT)
@@ -1045,31 +1042,11 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	lpaddr = address & pmask;
 	numpages = psize >> PAGE_SHIFT;
 
-	/*
-	 * Sanity check that the existing mapping is correct versus the static
-	 * protections. static_protections() guards against !PRESENT, so no
-	 * extra conditional required here.
-	 */
-	chk_prot = static_protections(old_prot, lpaddr, old_pfn, numpages,
-				      psize, CPA_CONFLICT);
-
-	if (WARN_ON_ONCE(pgprot_val(chk_prot) != pgprot_val(old_prot))) {
-		/*
-		 * Split the large page and tell the split code to
-		 * enforce static protections.
-		 */
-		cpa->state |= CPA_ST_STATIC_PROT;
-		return 1;
-	}
-
 	/*
 	 * Optimization: If the requested pgprot is the same as the current
 	 * pgprot, then the large page can be preserved and no updates are
 	 * required independent of alignment and length of the requested
-	 * range. The above already established that the current pgprot is
-	 * correct, which in consequence makes the requested pgprot correct
-	 * as well if it is the same. The static protection scan below will
-	 * not come to a different conclusion.
+	 * range.
 	 */
 	if (pgprot_val(req_prot) == pgprot_val(old_prot)) {
 		cpa_inc_lp_sameprot(level);
@@ -1112,47 +1089,11 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	return 0;
 }
 
-static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
-			  pgprot_t ref_prot, unsigned long address,
-			  unsigned long size)
-{
-	unsigned int npg = PFN_DOWN(size);
-	pgprot_t prot;
-
-	/*
-	 * If should_split_large_page() discovered an inconsistent mapping,
-	 * remove the invalid protection in the split mapping.
-	 */
-	if (!(cpa->state & CPA_ST_STATIC_PROT))
-		goto set;
-
-	/* Hand in lpsize = 0 to enforce the protection mechanism */
-	prot = static_protections(ref_prot, address, pfn, npg, 0, CPA_PROTECT);
-
-	if (pgprot_val(prot) == pgprot_val(ref_prot))
-		goto set;
-
-	/*
-	 * If this is splitting a PMD, fix it up. PUD splits cannot be
-	 * fixed trivially as that would require to rescan the newly
-	 * installed PMD mappings after returning from split_large_page()
-	 * so an eventual further split can allocate the necessary PTE
-	 * pages. Warn for now and revisit it in case this actually
-	 * happens.
-	 */
-	if (size == PAGE_SIZE)
-		ref_prot = prot;
-	else
-		pr_warn_once("CPA: Cannot fixup static protections for PUD split\n");
-set:
-	set_pte(pte, pfn_pte(pfn, ref_prot));
-}
-
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		   unsigned int level, pte_t *pbase)
 {
-	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	unsigned long ref_pfn, pfn, pfninc = 1;
 	struct page *base = virt_to_page(pbase);
 	pgprot_t ref_prot;
 	unsigned int i;
@@ -1168,16 +1109,12 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		 */
 		ref_prot = pgprot_large_2_4k(ref_prot);
 		ref_pfn = pmd_pfn(*(pmd_t *)kpte);
-		lpaddr = address & PMD_MASK;
-		lpinc = PAGE_SIZE;
 		break;
 
 	case PG_LEVEL_1G:
 		ref_prot = pud_pgprot(*(pud_t *)kpte);
 		ref_pfn = pud_pfn(*(pud_t *)kpte);
 		pfninc = PMD_SIZE >> PAGE_SHIFT;
-		lpaddr = address & PUD_MASK;
-		lpinc = PMD_SIZE;
 		/*
 		 * Clear the PSE flags if the PRESENT flag is not set
 		 * otherwise pmd_present() will return true even on a non
@@ -1197,8 +1134,8 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	 * Get the target pfn from the original entry:
 	 */
 	pfn = ref_pfn;
-	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc, lpaddr += lpinc)
-		split_set_pte(cpa, pbase + i, pfn, ref_prot, lpaddr, lpinc);
+	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
+		set_pte(pbase + i, pfn_pte(pfn, ref_prot));
 
 	if (within(address, PAGE_OFFSET,
 		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))

-- 
2.53.0



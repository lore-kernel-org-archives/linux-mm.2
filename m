Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95257606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0F1dvXo
Received: by kanga.kvack.org (Postfix)
	id A48346B05CF; Thu, 26 Nov 2026 06:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20636B05D0; Thu, 26 Nov 2026 06:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9366B6B05D1; Thu, 26 Nov 2026 06:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 725F16B05CF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:17:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE9581A03E8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:59 +0000 (UTC)
X-FDA: 85477018158.04.1D8A067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 18C664000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0F1dvXo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691818;
	b=R6Z+bzpzMyLklgqydeMtByBGll8V3q1KDsxl0YJFkzfO7nB1G4YTk2Z6SP7t2EFtGT2VsB
	Rkmsgogcg2/qiP2jK2QzBYGzLzlAWyXqM1EFSH5/AOJmDvm8Tre9T86xZx8wFWq2AebK0U
	RFKRE9vztS3cbLdccpb9sE8yRhOy31g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/joh9LYYtFAk508MPTeDmWNF1bv5NoqV23DPZyaFhMw=;
	b=bKke2TgKf7y1djRqATv7RVEJWrhULMvfhsvm+y42LOqq+R8bVpDOaszgnNlVSiT1GKiC7R
	V3pFgF9I7jJJR/tvbH4WLyEPrduOvxfXkLKgfVW+JVczNkwx1IlosbeEY7u2n6kvbuGerV
	u5dFA576k7B71vdlnbNK0RyHg4TicIs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0F1dvXo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 640EA4437B;
	Thu, 26 Nov 2026 11:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446AF1F00A03;
	Thu, 26 Nov 2026 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691816;
	bh=/joh9LYYtFAk508MPTeDmWNF1bv5NoqV23DPZyaFhMw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M0F1dvXoUExr4F9nBSfhMX1FI+ggjPL2FV636MxhU5/uw+s8CVJmcZrapiJ08aojR
	 A9p9cNfVVScZf3tX+EhfPkX69q9GEC7HAXM7a2jKMPL4gxPJeDexttYgMtp5wVOCpH
	 Ee+FNPGtArX7IUdZBaHnkcwkVuiqbwKol7/gqk7wdWS9iRplveTGVe0Ek+QZx3P3I6
	 QEilAO3kIEM3eKXEve6hi0oSYd/CyS938BDYh2HoedWMWjDCUhOE31ZFcyaV/jMfMT
	 OV5FKVPdeZmXAygPKHVm+bGAD2WJxWCsWEjnXUGYRfqg0WhmqZmsG9jQZrhlBDHHWe
	 rFoUqe6s11ckQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:28 +0200
Subject: [PATCH RFC v2 15/54] x86/mm/pat: look up the effective NX/RW bits
 in verify_rwx()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-15-723f1e33c3d8@kernel.org>
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
X-Rspamd-Queue-Id: 18C664000C
X-Stat-Signature: iz7wooeuo8gkk1abh4n7hd3erkbss96a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795691817-91820
X-HE-Meta: U2FsdGVkX18ER5ttLczcYkAXOJg/sSrVVv2FbRJDoWrk3AwdSEZ84uy5kcNAJ3Dy7zY1kIPLlBOFMDfo4uWgcn/19ANQirzcGPBC0rvvHS434vhprO648xSarlDDSNnc/CoF7+us6TSnywnw8UFq1LrpYzougXuxsmCSU8+44j6wMdZkm+zbdIfeqcGm0aSGSLBaplJy9FaSygUCJZyajNdhuDvdy1+HysGhJicDgAAWKVogS0aO6qJ82KFfxbLhQhk+OS7tv+9k99bzHKNzLH+rJLXQg/6/7rIUeNRXaCFpxE257WnQRiz9UWi36cqNaTgCU3kspyWN54JwghAYqd4I8qeSnj1wWU5tdI0a8ppKIyAmlo4XbMtC3nQVHWeDUcRY6WiWU2teJDMSHZhGf+jXAiA9uparp/v016zn8ndNtqOyQjbFC0+ZFOfnvSpc2Le+Aphrn3UqUBmB+V5W1pMfHLxVKMr7jHKQYxZQOkgq5YkYezMg4dtIVNQLK10IhMFDyT9P2qjo8fc0m7XOitUNGvZL5uUgooNn91K5JUd+Dkp+ovTEFByEvwaHalrFQxq69xzLwe+oPo4MUe7NBxhLKf/LrRFVoi1W3zsjqhcHAAL4DK8h1ML8nIoKrgj4uihBlZrre76svssAsELrC07TJKDaqmoP04/ZJQ7UWn3EYzzfG0/60Evsa2NN1MLSC4KOKsFj1RpiRgou+mzW9RTDDODYmyk7iTMt0+XYZ83tE7y3qmaTzwsIPStQRYfDV1EVu8dyad3EDeXaTmN0p2C6TawzPm5vd4BjSZHgxUWLXb6DtIIGrKRPKIBHs5i3KzCAj4FnDa3gZPJbfo55NT9PC1LI/BOkMXSekPWXSRatv+YfTCMX3GeuYFF9Fht6aXy4OUj3Bd65lAQzHF3subSuyl4G4RFkq/FlWgYK9uyDlX1mPupH7mBJRzy+xU+ZbF35KftONbY1D7haOYN
 v2UhxtWE
 kLdscza4WPWoFfOumFZ5pvYz41V++vUFOdEd3CUJODHRKRp1oLFGPKV4dl3QrucscDEXOuJEyjS4inewf/o5vTDsHsOQc3dsBQRB1+Pb+nSvc3sltQH8HRWxqBd+0+srLY36v7gM9VEqqYmUouHvbz6Jzg9YdYC4lcrRNVVpy50bmEnwu8HlWDK1Z4z/pNl4fQR8QfWyWljxPctFbRL0sB3gT/rvrPB2q6qjKHiJ3LK2V74WNdtagSt4Vv6c7lk0X/J9sgGOBrGkXaQPqpElMmGSOLgxcyj8hGWQPwz437dCQuV31WlkaZxuIJ1cko+KUc7Rw3A1MyGUFuVvMH9SiAcg78E+dnCb6/kY/ItBkInvSk0EY5g+zpJ+EWWgRTRBnUTJ6WFpguLEHdXia6t5qq/dtbQquxlsPf+8bF6oB7InlEmuNe9sReF2ZYQitfCQ8y91S2mBCd9HsuJ27iFIcrad0epXQrt7KnfG65GN7s6e1+jN6mtedzWfiQu54iEIhiZytgW3gH0+k+uY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every CPA lookup collects the effective NX and RW bits of the upper page
table levels. Only verify_rwx() needs them, and only when a mapping is
about to become both writable and executable.

Walk the page tables in verify_rwx() after its early exits and let the CPA
lookups return just the entry and its level. Add cpa_pgd() that picks the
page table of the request, to avoid code duplication.

Such a lookup does not depend on the x86 page table format. It will move to
the generic code together with the rest of CPA core logic.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 51 ++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9dfe69d608b8..8d481e9edf75 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -307,6 +307,14 @@ static inline unsigned long fix_addr(unsigned long addr)
 #endif
 }
 
+static pgd_t *cpa_pgd(struct cpa_data *cpa, unsigned long address)
+{
+	if (!cpa->pgd)
+		return pgd_offset_k(address);
+
+	return cpa->pgd + pgd_index(address);
+}
+
 static unsigned long __cpa_addr(struct cpa_data *cpa, unsigned long idx)
 {
 	return cpa->addr + idx * PAGE_SIZE;
@@ -688,11 +696,14 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 /*
  * Validate strict W^X semantics.
  */
-static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long start,
-				  unsigned long pfn, unsigned long npg,
-				  bool nx, bool rw)
+static inline pgprot_t verify_rwx(struct cpa_data *cpa, pgprot_t old,
+				  pgprot_t new, unsigned long start,
+				  unsigned long pfn, unsigned long npg)
 {
+	unsigned int level;
 	unsigned long end;
+	bool nx, rw;
+	pgd_t *pgd;
 
 	/*
 	 * 32-bit has some unfixable W+X issues, like EFI code
@@ -712,6 +723,13 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 	if ((pgprot_val(new) & (_PAGE_RW | _PAGE_NX)) != _PAGE_RW)
 		return new;
 
+	/*
+	 * Only a mapping about to become W+X pays for the second walk that
+	 * collects the effective NX and RW bits of the upper levels.
+	 */
+	pgd = cpa_pgd(cpa, start);
+	lookup_address_in_pgd_attr(pgd, start, &level, &nx, &rw);
+
 	/* Non-leaf translation entries can disable writing or execution. */
 	if (!rw || nx)
 		return new;
@@ -825,16 +843,11 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 EXPORT_SYMBOL_GPL(lookup_address);
 
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
-				  unsigned int *level, bool *nx, bool *rw)
+				  unsigned int *level)
 {
-	pgd_t *pgd;
+	pgd_t *pgd = cpa_pgd(cpa, address);
 
-	if (!cpa->pgd)
-		pgd = pgd_offset_k(address);
-	else
-		pgd = cpa->pgd + pgd_index(address);
-
-	return lookup_address_in_pgd_attr(pgd, address, level, nx, rw);
+	return lookup_address_in_pgd(pgd, address, level);
 }
 
 /*
@@ -966,7 +979,6 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
 	pte_t new_pte, *tmp;
 	enum pg_level level;
-	bool nx, rw;
 
 	if (cpa->flags & CPA_REQ_SPLIT)
 		return 1;
@@ -975,7 +987,7 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	 * Check for races, another CPU might have split this page
 	 * up already:
 	 */
-	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte)
 		return 1;
 
@@ -1086,8 +1098,8 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
 				      psize, CPA_DETECT);
 
-	new_prot = verify_rwx(old_prot, new_prot, lpaddr, old_pfn, numpages,
-			      nx, rw);
+	new_prot = verify_rwx(cpa, old_prot, new_prot, lpaddr, old_pfn,
+			      numpages);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -1153,14 +1165,13 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	struct page *base = virt_to_page(pbase);
 	unsigned int i, level;
 	pgprot_t ref_prot;
-	bool nx, rw;
 	pte_t *tmp;
 
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte)
 		return 1;
 
@@ -1866,11 +1877,10 @@ static int __change_page_attr(struct cpa_data *cpa)
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
-	bool nx, rw;
 
 	address = __cpa_addr(cpa, cpa->curpage);
 repeat:
-	kpte = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
+	kpte = _lookup_address_cpa(cpa, address, &level);
 	if (!kpte)
 		return __cpa_process_fault(cpa, address);
 
@@ -1892,8 +1902,7 @@ static int __change_page_attr(struct cpa_data *cpa)
 		new_prot = static_protections(new_prot, address, pfn, 1, 0,
 					      CPA_PROTECT);
 
-		new_prot = verify_rwx(old_prot, new_prot, address, pfn, 1,
-				      nx, rw);
+		new_prot = verify_rwx(cpa, old_prot, new_prot, address, pfn, 1);
 
 		new_prot = pgprot_clear_protnone_bits(new_prot);
 

-- 
2.53.0



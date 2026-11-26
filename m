Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A9F606A682
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLg2Fff7
Received: by kanga.kvack.org (Postfix)
	id E90186B05D1; Thu, 26 Nov 2026 06:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67B96B05D2; Thu, 26 Nov 2026 06:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C5F6B05D3; Thu, 26 Nov 2026 06:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A52246B05D1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:17:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE89C8018F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:08 +0000 (UTC)
X-FDA: 85477018536.04.354CCF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 008F1140007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLg2Fff7;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691827;
	b=lQrxhPbQvpoB/ELhZb9FyOolAYpU5ZcZ/PG2GoXSwdbVjUeO/xvvuI5Q5hv6t16XSJsosh
	GpeX0ggZJA6ZcOfKHPnl51Z2msIAoI8mLKirSaddj1nMG61hqndipM+j1BQy+y08t/6YGM
	T0IO2rh86UHENSo8WwT52sYdq0fcPw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qwpULvuAWXJZ83/2tVfvAzpASrXdkB8r3lEsMJ0zjs=;
	b=rPyk1ib4SSdJOQzGYaui94A42lXQq/m/U1SXny/qcS1uMCmcMYvIDuxF4Ro8dk5jgfSbeU
	ue2V90e4B2r1ImuimtKTfn7c+eXmrW13lWV8DrlQEowKE5NEP35bgSabSifzUbnxCn9wX2
	q1FmrXcz6SWRh5qeKaoBC70JMrjjXgM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLg2Fff7;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E91862F6F;
	Thu, 26 Nov 2026 11:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CDD1F000D2;
	Thu, 26 Nov 2026 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691826;
	bh=1qwpULvuAWXJZ83/2tVfvAzpASrXdkB8r3lEsMJ0zjs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oLg2Fff7b+2GZ35KNT50QSRRomdqr8XgASiLEKyHKcac4W/Z1CMbzv01oYlWouSwC
	 GxPtD3s5R8ZiYTXm7tUz7i//000wVVRYmBxIYQ5mRZB6e1yGLe+AMAw6uJOrbnfiQC
	 Q55lylf44P0449CTFHdGj2JrUw8UjP5jyEbE3phSOC1zaT2sYm+q7CCmJtSHfdyVxN
	 AHtzkEI4zwJ57R7nz9tV9R6oWmucQGl/oMN22NQJFfgfwOyAnRykXq5wW/tk6kslhj
	 a1va0BC8LTJjIG7RQ2u718+g+LISZw+RMvuGfzbOzBTBwzwm/MKm72KcheaaCEpTER
	 R/87hS5fS97Zg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:29 +0200
Subject: [PATCH RFC v2 16/54] x86/mm/pat: look up a large page again only
 after dropping cpa_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-16-723f1e33c3d8@kernel.org>
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
X-Rspam-User:
X-Rspamd-Queue-Id: 008F1140007
X-Stat-Signature: 36zx3uaj6in6in7gw939fwri8kmxcyr6
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691826-601371
X-HE-Meta: U2FsdGVkX1+GIAU/1PHDWtZpjHavDOtZt6h3wETM5Pih4Hvf02Vuuq9z5dmbV7az+3oigFxMgLfqCiCDGFQLVoJFphD2GSmnPpyuzxPJw8cZb7YnCYwoRGTXx2ru12dWQ6HGn4J4j095b/dYdTkW9+Tv8i3w8QIEkQmwi/8MtzT/NmTOz16UE+oB6tx3Ojk7KjudIxJAaEKxIboc0k2txWKh1aj+sV2A9Sl+4AS8qUjBXRXY9ZpQFxqRXkiVUYGnc4s4diO+I22tXw9VAg4gV9CRcKiXfIxin1+m8rP1lM4ZoxeFmVTUOj2w/21P7/D40uVnZ3mojdDP10gdb3PuCQG9ewLhd/bJLGpRFzj2xYExjjqUwLM2zF85dpwJSpU/NKfVuRUxd+C2iqC6z4crt2sU7WWBrIKTEPR9nciEyoD7YJBoLGjfzn6nguehh8MBp5uytoocXLUsuncX9SY8LM1RdwTLtWyDMdlrt2Fyz9i20fYG99A1VO4m1BWGpPh1RZx5KA0orYhF0rQEjpV7Jmud1KTkWzm+ISpfPcQNO1ZsPiD1eqtT1095BPbweuRtzBBRI55Mqe7AgvgTgzpjS0uexi4Sus9lhjGo4k1RLXSAvwRhzxXhCsnclaejDw3BQEFxs9dASMkUhm/0VCdxE0YQghA2bJmtKl/3eEF7Ms/TUDMzEP7GRqoUY7GRnfzHOkSCzEhQ4OJcKwYKnknqpwK0M3oHrgCw58kChM+tplR8g77xhkBSMGUr/g7ESme/ljrkzpxWGN+yA8ABGvKDws+pvGHm7G7VXaPE1oFPm7WKacBMKXgDlzXwYHkHQVNDiroFNS7fU0H5RmyCTwPlSDyklafU1idGu/NAPlWJYywSFpFbWFv2d1zLMTYFJiKFcWn4omQR7R0582YbgyF36GLslh+SGMMouemiilpkl5pTOo5Tze05A+YoMK+NbPKukYgf2N3aFFeHie6XN4K
 tooimc+8
 +7O7uTazgmxExp9DEAk+XLCMD2/D1uGZM+duzV0bUFIKTP7i6kzNM4L354ikv7d4PEr8OY1XBXY5QLWu4ZNYl7qlpo5njTlHw3lgIxisccM2EFobkAl2FRe7iPAkfN0bOoGyXcN59pTqh81K+8loHwaLIXEoDjltC2ZsIzMUTU5rGAK/KzB2odjOvgvTlwFH9Vi6eM/Rwqv2/uVLCwzsWWtbQqXLcdC9Pfegfs2EUTe0W6JomNEYmfEYh1YsFeMRmGb+GkvqkRiBfB59OHx5NvYnfrj1NofD/EzRjCVyYBxqq26t8kYWbdtBLJW9tB9NbFtk7uIf+Z6aKeY7wlSHM6KuJZBDiDSspQrp60r8PWRuFy+bj3J3E9j2cy7b//1KiuUFOgX0O/Sa7vfS4HWg32PHjVz8s+2YXLVirUcWJEfQz8gFDaglQGrxyaW3eC/XBKvvsDvfE0KwSc/4OMv3xGw6CwHv4+Hy4MMXf26Xzy5yfWEjVILh0la6roP3Br2q2uQZPBYiTGq8qr5SNDz1d7pwMWVUYGBgfKHHsJGo3KSjdMS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

should_split_large_page() and __split_large_page() both look up the address
again to check whether another CPU split the large page after the previous
lookup.

In should_split_large_page() this cannot happen, because cpa_lock is held
from the lookup in __change_page_attr() to the check.

split_large_page() drops cpa_lock to allocate a page table, so the check is
needed there.

Drop the lookup from should_split_large_page() and pass it the level that
__change_page_attr() found.

Move the lookup from __split_large_page() to split_large_page(), right
after it retakes cpa_lock, and pass the level down.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 48 ++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8d481e9edf75..967d691ef1c0 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -973,24 +973,15 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 }
 
 static int should_split_large_page(pte_t *kpte, unsigned long address,
-				   struct cpa_data *cpa)
+				   enum pg_level level, struct cpa_data *cpa)
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
-	pte_t new_pte, *tmp;
-	enum pg_level level;
+	pte_t new_pte;
 
 	if (cpa->flags & CPA_REQ_SPLIT)
 		return 1;
 
-	/*
-	 * Check for races, another CPU might have split this page
-	 * up already:
-	 */
-	tmp = _lookup_address_cpa(cpa, address, &level);
-	if (tmp != kpte)
-		return 1;
-
 	switch (level) {
 	case PG_LEVEL_2M:
 		old_prot = pmd_pgprot(*(pmd_t *)kpte);
@@ -1159,21 +1150,12 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   pte_t *pbase)
+		   unsigned int level, pte_t *pbase)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
 	struct page *base = virt_to_page(pbase);
-	unsigned int i, level;
 	pgprot_t ref_prot;
-	pte_t *tmp;
-
-	/*
-	 * Check for races, another CPU might have split this page
-	 * up for us already:
-	 */
-	tmp = _lookup_address_cpa(cpa, address, &level);
-	if (tmp != kpte)
-		return 1;
+	unsigned int i;
 
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 
@@ -1257,8 +1239,9 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
+	unsigned int level;
 	pte_t *pte;
-	int ret;
+	int ret = 0;
 
 	spin_unlock(&cpa_lock);
 	pte = pte_alloc_one_kernel(&init_mm);
@@ -1266,13 +1249,22 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	if (!pte)
 		return -ENOMEM;
 
-	ret = __split_large_page(cpa, kpte, address, pte);
+	/*
+	 * Check for races, another CPU might have split this page
+	 * up for us already:
+	 */
+	if (_lookup_address_cpa(cpa, address, &level) != kpte)
+		goto out;
+
+	ret = __split_large_page(cpa, kpte, address, level, pte);
 	if (ret)
-		pte_free_kernel(&init_mm, pte);
-	if (ret < 0)
-		return ret;
+		goto out;
 
 	return 0;
+
+out:
+	pte_free_kernel(&init_mm, pte);
+	return ret;
 }
 
 static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
@@ -1928,7 +1920,7 @@ static int __change_page_attr(struct cpa_data *cpa)
 	 * Check, whether we can keep the large page intact
 	 * and just change the pte:
 	 */
-	do_split = should_split_large_page(kpte, address, cpa);
+	do_split = should_split_large_page(kpte, address, level, cpa);
 	/*
 	 * When the range fits into the existing large page,
 	 * return. cp->numpages and cpa->tlbflush have been updated in

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B967C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96216B00A7; Tue, 21 Jul 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E4A6B00AA; Tue, 21 Jul 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9E96B00AB; Tue, 21 Jul 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863D86B00A7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E65828018A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:45 +0000 (UTC)
X-FDA: 85013307330.18.97E2D12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F602A000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mduyV/4o";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nokpUTK/BQEU2xPd8dil79b/pTUs86asyupxsitnFKA=;
	b=7tPNhBs8pK64hK+WveqqWKF7m8YxpTPLiXg9rFMeW0UfXEEuV2nWcgNQVDBDhguapuiyel
	+XBP0iqFN12Yd+beqNzkd7bOXGXCsvSK1KDhFF1v36zR9Ap8RjtfcyWZHUT4BirdmzG8ha
	S2ZF+r94CQKtKEahsGuvtMWvfH4ZrAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651084;
	b=QHzZyTafz4vIavgHHAd4Vt79osIw/X5VUdrl4oR3fRgkgzS0RpDSjm/ZzcNzpFJejVa1AQ
	01nqEVX4BCggAEPM7fbIkwVNtgHFYlH/Gb4bfD8/E7g0ru8UQdNlhHptwSpbZ4VzBZJlSd
	kJdGkKAof9MEFG/vmIBz7iEGuzQSZkY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mduyV/4o";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F79F40E4F;
	Tue, 21 Jul 2026 16:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1032F1F00A3A;
	Tue, 21 Jul 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651083;
	bh=nokpUTK/BQEU2xPd8dil79b/pTUs86asyupxsitnFKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mduyV/4oIfEViBoL6lriq5H4veut2axJNwNq2s8j+Qo/kcJQY2HEyGHhleoOmd1Ba
	 KqLtqTyZvyOcUE/AJKvW6Fvi+sOLhFoZYGyhft2SjmZUALxgwD5DGq9OsXZr8lT1+t
	 Z1NUg49kmKteh+uVkht2fdwI7NtwumvsJCfpA9k8YL5d/G4pidA3LDhwZQisFKj0WT
	 bJlJEAeJYy76RZjM+xZVDhcI3yxkOWWVkJLQMTUtiPeaY8q902iyg65RZ21W/j9hWZ
	 plSCPQAYE8Bab5QU90e8Xoo9DivS7xzxi6Pg0rG3OxFpbwABrQidREgO0VdToD8Had
	 qxbQhX+cRlHKQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:32 +0300
Subject: [PATCH RFC 09/18] x86/mm/pat: use a single locked lookup for PTE
 verification
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-9-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: 3kjku4zbgbyt6soe4k9d83ht6f8egukd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F602A000F
X-HE-Tag: 1784651084-337983
X-HE-Meta: U2FsdGVkX19sfyYZzAl04zBAznhgh/tW4AfwjoV0I/bTZzoiHdCb5wowIDqehpbmgCzCNuAOZEzKaaeZ6qRJc3TfakEtIfhUCLykynw50zA8S2U508ZL7AKAqKnFwsowilUBq2YtSciZlNtoB4Qm6+PXZREpycCJJnJbaSiRPxTGARTSZdFpdklM8Nesgx+rqFde59IezFHbB/A2pwqbJdXNeOaspogAZBx/7lRIx7u+srpx+tPq3QLqSo5MoPIX0oonlqCCGAwoKqOQyt5F0LI14gdbm+RZg9PBTy6cXap+gZADJFkReBCMFFxy5yjgK1b4qT1+f+2GpoiHiPSBZgxZXks+I72gUQtoIr0Bfbs2xqbBZw7lgs32SWRoK6AhXnZPAErHXgPpRMfqi20T6M+tXRTiFVD9kssvZOh7m5hUQL5ej3cFirq4VcDGBM0cESFaN//jKH12PGg/p8wq26SGssoh127o3zyrrWQxpzOlev0jm7+gJccRhafKozrKbiiuhGS23XfcaCuQshKikfGMgdackgU7ewHK7bfaoUjUNxocsWldJyl6s2S1gZMHR9CotWZIYpviyzfON6cTRwjQfP16JHRc4SKrR6yLFsT4wbV0ZWsMCyQOU0JgxJMtIDOtbFbedCEFPzexVAR0uRqlghjmutgU0w+jIXtKQVbbS50aViOr1w3UpZgALuQNqiWnPxEZ1RY3GyilpTDK5/eETiIBuXw83dXcEw95Wt9pMOXRmST3i+HxXDRO8X8P3EoLUjEZkY3vJKJ2Z2cBg9te0VNJcsxqQ/G4s1MMheM9yKkMMA1XBjpMrjMQTDfKgI1zAphX++MpBnYpN57X8yqxnPJb3XLcVlApjnF+fETn7sihubjV4Po42dpQjU8eLjfcpo8m0J9Aj3Z+ap/BdQoU6X5j/Arvnnq7dYrllajSTZWaXyEhzz5iRytI1rfzfIyfat1QXgoC0Dkr223
 U9OUFk4B
 z0hde7ZdF/tjHX/pZK2b/4SknyGl9SGN6cik8AE9kIHi9WmKwY7n2TI8ysC1BvW3r5H/cC94lGVj8Ebsj4k1s+SJS2nk5ZIjpHp7fMmJr032KpnOta3rCbC+iruifbXhsEhkhJgr7vH9Etzj1/Ur/kGSeHokTghx98RSMdIVCC0w4yNU2DUTxY/mHwqajnYtgXyNerFmh32UsDYVw3pSRHkO+J6FbacEbor/tg2pkPDr/U0a0Zzefyn8pyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently both __should_split_large_page() and __split_large_page()
verify that the page table entry wasn't changed by another CPU while
pgd_lock was released.

pgd_lock must be released between __should_split_large_page() and
__split_large_page() because split of a large page requires allocation
of a new page table page.

Preallocating the page table page before checking if the large page
should be split allows running both __should_split_large_page() and
__split_large_page() inside the same critical section protected by
pgd_lock and allows dropping the duplicated lookup.

Move allocation of the page table before the call to
should_split_large_page() and pull out race-checking lookup into
cpa_handle_large_page().

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 89 ++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 49 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c2a72cd8b832..ef206ba6e254 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -60,6 +60,9 @@ struct cpa_split_data {
 	unsigned long	address;
 	pte_t		*kpte;
 	struct ptdesc	*ptdesc;
+	enum pgtable_level level;
+	bool		nx;
+	bool		rw;
 };
 
 enum cpa_warn {
@@ -883,19 +886,12 @@ static int __should_split_large_page(struct cpa_data *cpa,
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
+	enum pgtable_level level = sd->level;
 	unsigned long address = sd->address;
-	enum pgtable_level level;
 	pte_t *kpte = sd->kpte;
-	pte_t new_pte, *tmp;
-	bool nx, rw;
-
-	/*
-	 * Check for races, another CPU might have split this page
-	 * up already:
-	 */
-	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
-	if (tmp != kpte)
-		return 1;
+	bool nx = sd->nx;
+	bool rw = sd->rw;
+	pte_t new_pte;
 
 	switch (level) {
 	case PGTABLE_LEVEL_PMD:
@@ -1030,16 +1026,10 @@ static int __should_split_large_page(struct cpa_data *cpa,
 static int should_split_large_page(struct cpa_data *cpa,
 				   struct cpa_split_data *sd)
 {
-	int do_split;
-
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock(&pgd_lock);
-	do_split = __should_split_large_page(cpa, sd);
-	spin_unlock(&pgd_lock);
-
-	return do_split;
+	return __should_split_large_page(cpa, sd);
 }
 
 static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
@@ -1084,23 +1074,11 @@ static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 	struct ptdesc *ptdesc = sd->ptdesc;
 	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
+	enum pgtable_level level = sd->level;
 	unsigned long address = sd->address;
 	pte_t *kpte = sd->kpte;
-	unsigned int i, level;
+	unsigned int i;
 	pgprot_t ref_prot;
-	bool nx, rw;
-	pte_t *tmp;
-
-	spin_lock(&pgd_lock);
-	/*
-	 * Check for races, another CPU might have split this page
-	 * up for us already:
-	 */
-	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
-	if (tmp != kpte) {
-		spin_unlock(&pgd_lock);
-		return 1;
-	}
 
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 
@@ -1133,7 +1111,6 @@ static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 		break;
 
 	default:
-		spin_unlock(&pgd_lock);
 		return 1;
 	}
 
@@ -1181,23 +1158,13 @@ static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 	 * just split large page entry.
 	 */
 	flush_tlb_all();
-	spin_unlock(&pgd_lock);
 
 	return 0;
 }
 
 static int split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
-	spin_unlock(&cpa_lock);
-	sd->ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-	spin_lock(&cpa_lock);
-	if (!sd->ptdesc)
-		return -ENOMEM;
-
-	if (__split_large_page(cpa, sd))
-		pagetable_free(sd->ptdesc);
-
-	return 0;
+	return __split_large_page(cpa, sd);
 }
 
 static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
@@ -1207,13 +1174,31 @@ static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 		.address = address,
 		.kpte = kpte,
 	};
-	int do_split, err;
+	int do_split, ret = 1;
+	pte_t *tmp;
+
+	spin_unlock(&cpa_lock);
+	sd.ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	spin_lock(&cpa_lock);
+	if (!sd.ptdesc)
+		return -ENOMEM;
+
+	spin_lock(&pgd_lock);
+
+	/*
+	 * Check for races, another CPU might have split this page
+	 * up already:
+	 */
+	tmp = _lookup_address_cpa(cpa, address, &sd.level, &sd.nx, &sd.rw);
+	if (tmp != kpte)
+		goto out_free_ptdesc;
 
 	/*
 	 * Check, whether we can keep the large page intact
 	 * and just change the pte:
 	 */
 	do_split = should_split_large_page(cpa, &sd);
+	ret = do_split;
 	/*
 	 * When the range fits into the existing large page, no split is
 	 * required.
@@ -1221,16 +1206,22 @@ static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 	 * cpa->numpages and cpa->pfn.
 	 */
 	if (do_split <= 0)
-		return do_split;
+		goto out_free_ptdesc;
 
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(cpa, &sd);
-	if (err)
-		return err;
+	ret = split_large_page(cpa, &sd);
+	if (ret)
+		goto out_free_ptdesc;
 
+	spin_unlock(&pgd_lock);
 	return do_split;
+
+out_free_ptdesc:
+	spin_unlock(&pgd_lock);
+	pagetable_free(sd.ptdesc);
+	return ret;
 }
 
 static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,

-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E9D6070380
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B6B6B05B7; Thu, 12 Nov 2026 09:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7712F6B05B9; Thu, 12 Nov 2026 09:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614466B05B9; Thu, 12 Nov 2026 09:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39FCA6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1F4A1A0354
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:39 +0000 (UTC)
X-FDA: 85426690398.03.E9C59B3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id A5C0280003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqY3plPqqqJzQl36ZGXhU10pdEsrz5YDLPHyxcjMpKg=;
	b=Lbov7YDVUpstMA5ogf7mDUnYV9bdEuDM6+ptE1x8+EWF6KsNmYHe10oxWtkFfXM80Obh1I
	zeTD0/NhTNEcf+SMx+H2d7tXUVW9h2gahqXPAAZnUuSwSTIOLuayNfNOJGkud7dfXIoz7Y
	C2IaI5t8YtziLSr2zFcvEWJjL0+7EKA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493537;
	b=1PtlP+I2seXWoQ2SzmlAYf4z8gwl/bw2+6hYreg8yEIOyZb/7wlrBkq9v/gZVatoHczw3Y
	vHulm2eOv3xUcn28JH9EFlX5kcEsik5JDPnRg3ZfknG191dh4NpdmD1nt1AoRwiG3yKOSs
	IOT0T+EEKE6TRCjXQ5xNUQhrKvjgRr4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A05621E41;
	Thu, 12 Nov 2026 14:25:36 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BC3113432;
	Thu, 12 Nov 2026 14:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T5
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:35 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 4/9] mm: keep writable entries writable on protection changes
Date: Thu, 12 Nov 2026 15:20:33 +0100
Message-ID: <20261112142039.907090-6-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5C0280003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dh5yr4p7cyh5ichq7aqj87sxjpjyqq7y
X-HE-Tag: 1794493537-819972
X-HE-Meta: U2FsdGVkX1/ozoaK3FNOdIeoKzB92LhLMgIDNAZ69w16EUxM0I4kriA+Ke4bhD6YmPMEoFkrQGM9pCqrZR+dmvKqsybafrlpzO/+3QwtvbPCx6O9hKgV+sp8f+W+X2ux5yZV0d2K85N9p1ChUAmEEiQSVVw+U79ALzkPUR8Q6SvP/8tJHHJs4vNrMTX7lcWWTDqYnrcqP8/tpiXY2ODirnYAC8a5/LIpXYdPCzvlHP3V3xPm2x2jDM/aZ1A3YXoMx0TXaba/Fq6gvMXFph+WOCGDuDDOce4+XAwar4hol0VYd9j3Gsn8zmigE6WeHAhpMLABGQ6E5sg5fjRaJfP4eAv6aQfWA6V3MyNkkFfWbXMaGCJEzrAQe14QQekEzBBBOFhVmeRjS59Le9qpU0Kz88gHzX4G1fDz+nOyL3cKIS4CnZNyJfZKV124ssgcHLgyePQTt/lGaiwdtYv8++c/1JSNQSCszk2PMMeQHQj2Bc8g/aBKW4NArUmhQwGv79AU6Wbi8FY0P1ybm2r7Ok1xauYq+OPW8MEzDWak6EQ3TRJ90F0iLddhEtkhgv8YM+4Yh9jQG0tDU95a32VfRY4QakwVLwRnsTYScwwS7vJP+KKxFLFZQkQ3dttnGuw2LxgFUhuUJL3tb08TlY+BVwnf2if2GOXTRsqnoV4bA8lNj3KXMQWhqJiUZAgwgjgI4FuMPZoKG0IuTxGrakALMD+Q3PNBk7F11+GEmVSNqdr2J1V3NBsUGt/zyi4WJWGVSXFjVZtdWy/aznj3a8n+shND9TiQcB8TuFAt9sdf3NGgKY7ST1iGZua2HrRP3R+MTJXpwIylv5geJYocoQh5NUe1AEIRCMmjSyzY78jtteAI/vhwVm4P3nQnDYJN9FSIetyPwagjam+PxYxMFr+MOHiye1+ywsAenISWDB9Wej5+GXSHwNYXHUJV6D8d+aglisDhbmH1Pp6bTzseip31Pdb
 ZXcGs1xO
 EP3rAuM535Qncr2PD34n4a0jc2H+x+vXIeXmgF6gHVNNXt/ZGhoMfhiKhWtBsXS5Tg5UF8Xa/4FkxA6ou/ct6A7lVmuxsTXlM2Uhc1oaKrweLK2E/MblDjHCaW+wF//jJr0ix70iOI/f79lk0BhHcmOPo1GON94dpdxifgyztPt7xlk27nXZIPc+Spg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_protection() applies vma->vm_page_prot, which lacks the write bit
for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
entries writable again if a write fault would only set the write bit.
In shared mappings, it relies on the dirty bit for this, as a clean
entry might still need a write fault to notify the FS.

However, this misses clean entries that were already writable. For
example, a uffd-wp unprotect makes shmem PTEs read-only if they were
mapped by a read fault before uffd-wp was registered, so the next write
to each of them faults.

Entries that were writable before the change can stay writable, as
anything that relies on write faults write-protects the entry first, and
MM_CP_TRY_CHANGE_WRITABLE is only set if the VMA stays writable. So
check the old entry before the shared and private rules.

Note: writable anonymous entries are always exclusive and thus already
kept writable, so in private mappings this only affects PFNs that
drivers map writable into them.

Signed-off-by: Carlos López <clopez@suse.de>
---
 mm/huge_memory.c | 22 ++++++++++++++++------
 mm/mprotect.c    | 11 +++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 080b718eb7de..69f4485c277e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2269,7 +2269,8 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 }
 
 static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
-					   unsigned long addr, pmd_t pmd)
+					   unsigned long addr, pmd_t oldpmd,
+					   pmd_t pmd)
 {
 	struct page *page;
 
@@ -2288,6 +2289,10 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 	if (userfaultfd_huge_pmd_wp(vma, pmd))
 		return false;
 
+	/* Writes did not need a fault before the change either. */
+	if (pmd_write(oldpmd))
+		return true;
+
 	if (!(vma->vm_flags & VM_SHARED)) {
 		/* See can_change_pte_writable(). */
 		page = vm_normal_page_pmd(vma, addr, pmd);
@@ -2317,7 +2322,7 @@ vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 	pmd = pmd_mkyoung(pmd);
 	if (!pmd_write(pmd) &&
 	    vma_wants_manual_pte_write_upgrade(vma) &&
-	    can_change_pmd_writable(vma, vmf->address, pmd))
+	    can_change_pmd_writable(vma, vmf->address, vmf->orig_pmd, pmd))
 		pmd = pmd_mkwrite(pmd, vma);
 	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
 		   vmf->pmd, pmd);
@@ -2354,7 +2359,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	 */
 	writable = pmd_write(pmd);
 	if (!writable && vma_wants_manual_pte_write_upgrade(vma) &&
-	    can_change_pmd_writable(vma, vmf->address, pmd))
+	    can_change_pmd_writable(vma, vmf->address, old_pmd, pmd))
 		writable = true;
 
 	folio = vm_normal_folio_pmd(vma, haddr, pmd);
@@ -2820,7 +2825,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
-	    can_change_pmd_writable(vma, addr, entry))
+	    can_change_pmd_writable(vma, addr, oldpmd, entry))
 		entry = pmd_mkwrite(entry, vma);
 
 	ret = HPAGE_PMD_NR;
@@ -2835,7 +2840,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static inline bool can_change_pud_writable(struct vm_area_struct *vma,
-					   unsigned long addr, pud_t pud)
+					   unsigned long addr, pud_t oldpud,
+					   pud_t pud)
 {
 	struct page *page;
 
@@ -2846,6 +2852,10 @@ static inline bool can_change_pud_writable(struct vm_area_struct *vma,
 	if (vma_soft_dirty_enabled(vma) && !pud_soft_dirty(pud))
 		return false;
 
+	/* Writes did not need a fault before the change either. */
+	if (pud_write(oldpud))
+		return true;
+
 	if (!(vma->vm_flags & VM_SHARED)) {
 		/* See can_change_pte_writable(). */
 		page = vm_normal_page_pud(vma, addr, pud);
@@ -2896,7 +2906,7 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	entry = pud_modify(oldpud, newprot);
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pud_write(entry) &&
-	    can_change_pud_writable(vma, addr, entry))
+	    can_change_pud_writable(vma, addr, oldpud, entry))
 		entry = pud_mkwrite(entry);
 	set_pud_at(mm, addr, pudp, entry);
 	tlb_flush_pud_range(tlb, addr, HPAGE_PUD_SIZE);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e18d4e12fc34..84bcfe0281d3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -194,6 +194,17 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
 {
 	bool set_write;
 
+	/*
+	 * Writes did not need a fault before the change either. All PTEs in
+	 * the batch share the write bit.
+	 */
+	if (pte_write(oldpte)) {
+		set_write = maybe_change_pte_writable(vma, ptent);
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
+				       /* idx = */ 0, set_write, tlb);
+		return;
+	}
+
 	if (vma_test(vma, VMA_SHARED_BIT)) {
 		set_write = can_change_shared_pte_writable(vma, ptent);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
-- 
2.51.0



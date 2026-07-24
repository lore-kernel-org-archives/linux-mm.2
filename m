Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6818C53209
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61606B008C; Fri, 24 Jul 2026 06:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE376B0092; Fri, 24 Jul 2026 06:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16CE6B0095; Fri, 24 Jul 2026 06:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC616B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FDF140324
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:34 +0000 (UTC)
X-FDA: 85023275988.10.870163B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id F0165C0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SxlDuhdm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ujI4Wd2G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SxlDuhdm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ujI4Wd2G;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twduMmeEWgelZFZshyHJ1uGfEjZlzuBRFqWfJVNkv/M=;
	b=l/pR0BvVmAWm6yKxFmfEygm9j4w7foyu4UfanLRazTSk2som75CFAv14mKv7yaxnJ7rjVT
	ZIDNBTiIP+VZ5H7+58Jj3ZzJ+6RPO1Arydyi6zA0N+NsXW9VcTeLwDZlpolPAqceZ+sqZ7
	a5nkI1nQFrKYF4IR9DWNI+J+z9nfML8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SxlDuhdm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ujI4Wd2G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SxlDuhdm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ujI4Wd2G;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888432;
	b=lgZVqQSPQvHsD8o1FghJsnFzLL8aCZWgsHAdxH1ViYTu+iGvWkMdNheHbaUgUruTybr59d
	0L5DLwuDGdoalqUEiQYQt7qBrJA7FH1tE2ETBWURcbkp9cwFgXjGJTt2KzbMrT+jLSEyAh
	aFRxDTpbs5KmHJxsahxNzQlYoHPq6u8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 41C557B6D1;
	Fri, 24 Jul 2026 10:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twduMmeEWgelZFZshyHJ1uGfEjZlzuBRFqWfJVNkv/M=;
	b=SxlDuhdm9/gJHTiydudXOtHLrbiAAe4QPGMGricn9OURt/YQ1jYLoNASQ7rLBFmCqz2nh7
	LHoCXMRcnonSZLvrYSKtJyKCm58cs12ud3kPnjRbVQWGzRncaUWw91EbQfsX/gLtynDW3M
	SrbJvmgWvNFfcNslZjZ6wm9gi/WZ6Os=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twduMmeEWgelZFZshyHJ1uGfEjZlzuBRFqWfJVNkv/M=;
	b=ujI4Wd2GfWYZueixCfqt1ZdfL+YX/avZQzXLSVhOTjMbmIwZDL0nLfgZgfAjO8WL3FIdfd
	9ua5XK298g4YhNDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twduMmeEWgelZFZshyHJ1uGfEjZlzuBRFqWfJVNkv/M=;
	b=SxlDuhdm9/gJHTiydudXOtHLrbiAAe4QPGMGricn9OURt/YQ1jYLoNASQ7rLBFmCqz2nh7
	LHoCXMRcnonSZLvrYSKtJyKCm58cs12ud3kPnjRbVQWGzRncaUWw91EbQfsX/gLtynDW3M
	SrbJvmgWvNFfcNslZjZ6wm9gi/WZ6Os=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twduMmeEWgelZFZshyHJ1uGfEjZlzuBRFqWfJVNkv/M=;
	b=ujI4Wd2GfWYZueixCfqt1ZdfL+YX/avZQzXLSVhOTjMbmIwZDL0nLfgZgfAjO8WL3FIdfd
	9ua5XK298g4YhNDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC3F3779BA;
	Fri, 24 Jul 2026 10:20:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4CtyNmg8Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] mm/arm64: constify pte_get*() and contpte get logic
Date: Fri, 24 Jul 2026 11:20:14 +0100
Message-ID: <20260724102017.141532-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724102017.141532-1-pfalcato@suse.de>
References: <20260724102017.141532-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0165C0009
X-Rspam-User: 
X-Stat-Signature: rzqb1w997xxnhp3jkz5k66kpktxsyofn
X-Rspamd-Server: rspam04
X-HE-Tag: 1784888431-353923
X-HE-Meta: U2FsdGVkX1+6rWv+Wupxa5mJrmjg0aQ7Rz1nBgu1brw7Y25sObZGEz472qnQ3+gR+PIWth5ILV2Lj/bQna3T1CTrCUVA5PfHgkbKKVA2lV3ZAWhqvRoj7nMJEoe/SeWfaV67ve7UUwhkkvN6bvFb+/Ryv0eaNQQ4+8f8U8HJqn1aOTD3UeBAKzCBHyLdtewle4NYM8SyZ+K0401iNIaD7D9EAIgW31AGUnlcjp7Gx97TCf0WYlVbifk7cD+8lALI49fvt+nH97EUCc/FR1nmJAo4U+3QzTnhFxsREPnpf+5OSLRTKk0lLsRwzb7mvsZfnJFl+iwy9etUM9ZXMnRjEpfSeDfPa5uNVP+p66OqnWaLlvSj0e5bdwl01k47Gpz5ejmDUuk00Am1I12bWacxY3SN7JocO0zDj13SQQmLucSeEXyGNhcZVZxfwI9s4sxRLw3iDhHCIWvKhc5IfCY/J5LFI9rokMhH92YTa+BZy+UDEAg6qi4LD8s7x93iNPPoWkqBpGVneIvto/TxlUX1Ydh3O2zACQy4f5vuOLFtrZ8/pJDLtFSpsOhgozwrOSj3SInWypKAkIcq3tVZM8dnDxbwGBiPIs160G0a/AMt1qv7FM59VxE3pkM/wX2zmzO57OMHLrfA9TFitK8ze+ZugZsr5O2Et/ZY70mzDsuppoU0gHbegDCIV4Lvk96Auw4VEDMX8zNVk7Mc6LGPrRMFoVIJEqYXrh1l/zFTj1YM8SSBxaqHaWML8Gu0EtfoOhE8+TUUQMjctyXvKAwSbgCFi3KSIX0dz+e3aJBUISH1GG6jl63VfCPUAZCbfyvNcVC8iakFiJYGAax2c5ikwqKCdqFQ9qEANfQ3o26h0l3i4YujR9nSYEEt2H/hgLRBzkzOjoGkhn5Ayio6KzgDCee5bK6TdRhcf7eRY5/U/A8xHy6NE120su9cSrhqPr8RBEIAb2LScB3cu7oYXv3263y
 xBBtaBje
 Pay/oHPLqKrT8DAgGujbnUxHFqyjQAkERtnz9FEMjnSFztpUPISOTGN+z7912GwEFysOU+ISLwNpRwyRuUNdTO0s2kr2mTqmy7DXxSfWaHi97s5Ykdmpbp8DHLGG0CXu+WqpXCpDMHF27Xwgtaz0HCKq19bdMqLS4oadA7zG9byDcbyu+zeJx3n3/eMsmYfnj9mGUZBB78yeAm1JJbsR+OYVi/WaLAUkJFSjS440mbsCIDZ5YyWsfyfZ642oVoSSdsopwj+altYY/67b9vW79iDx0OznxKSillZ7WVYBVtPdyWVCry0d5HmFnUf2GvCvSlDOOUbmrOPVpMd8O5W/iQOyKneQeQ2nz9pZyQFHX1QrQXWtisBRkF7EjEG9CG7evOHSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the contpte code needs write access to the PTEs.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/mm/contpte.c          |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d755358..043bc0649cee 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -378,7 +378,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 	__set_pte_complete(pte);
 }
 
-static inline pte_t __ptep_get(pte_t *ptep)
+static inline pte_t __ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
@@ -1652,8 +1652,8 @@ extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
-extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
-extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
+extern pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte);
+extern pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep);
 extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, unsigned int nr);
 extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1732,7 +1732,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
  */
 
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
@@ -1743,7 +1743,7 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 
 #define ptep_get_lockless ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(const pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 2de12656b4d8..3853ecd2cee9 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -310,7 +310,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(__contpte_try_unfold);
 
-pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
+pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte)
 {
 	/*
 	 * Gather access/dirty bits, which may be populated in any of the ptes
@@ -367,7 +367,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
 			pgprot_val(prot) == pgprot_val(orig_prot);
 }
 
-pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
+pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep)
 {
 	/*
 	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
-- 
2.55.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8F2CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A116B00D6; Tue, 26 May 2026 10:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECC26B00D8; Tue, 26 May 2026 10:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CFD6B00D9; Tue, 26 May 2026 10:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750606B00D6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F06B71C0300
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:22 +0000 (UTC)
X-FDA: 84809871804.29.18A3A7D
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf09.hostedemail.com (Postfix) with ESMTP id B714614000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aaxZKJZg;
	spf=pass (imf09.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAntgOTYzemzPb0EO7sTFQO6BvGc9iJeZEmRTSuIcHs=;
	b=VaBcPSgRNwAUdK972fxD4/clLIvH805e1fDlJ757u0k7HtHGP4YJWHFT+uNm6NOWJeDtd5
	mmjxXuK+QJMrKzNqLpS2M6pilugmHYTPy1FZnVXso93AOBePyGaG/E940oQrlNt+JldHg/
	u2ljSKJQuFoveIG/rK7oZwdsAMF0JAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807381; a=rsa-sha256;
	cv=none;
	b=uGgLUBhiZylLH4N7rVktxXui8/lyqauDAiShMdfbdG+rPbCmKJDbrFRVFnCQfKV423GqvS
	KG4fIYSCXS8IRTIKTyMfibOOO4NpV8za9jJ1/J9Mrm3GoNVvDTU2qLUNg6CsoZfA5ZrIYB
	ry19cICqY74S+eaXyEXTRrDvPAjZxx0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aaxZKJZg;
	spf=pass (imf09.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YAntgOTYzemzPb0EO7sTFQO6BvGc9iJeZEmRTSuIcHs=;
	b=aaxZKJZgaMiO97CRNKgdXbF9a+WdupCXAZJH6aCLKDE/QcIFvdDpw7trUN2xXzftoS/ljUZIs
	WbPF/+qBEysJMYcTplm5KjDlnSJ7bmDUsBo/PycdedUouph+stsmJVQaALSHyW+Vmh24Jj8Wp+M
	kjD6iiq6tNQulyrkLP5yR98=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gPwbk08Bnz12LdK;
	Tue, 26 May 2026 22:48:18 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CE5140561;
	Tue, 26 May 2026 22:56:18 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:16 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 6/7] mm/huge_memory: make move_huge_pmd() use has_deposited_pgtable()
Date: Tue, 26 May 2026 22:50:02 +0800
Message-ID: <20260526145003.88445-7-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: B714614000E
X-Stat-Signature: 31qnwb9nt5ohuhdbu47i7ekdizwubyuu
X-Rspamd-Server: rspam06
X-HE-Tag: 1779807380-760607
X-HE-Meta: U2FsdGVkX1+rCa5cYh61g/MYarI6fAFa97PPrzk+eiSCY4tBbsidwHWQfT/vOmNdcbdhwPw3T4bXdFGwOiqiE1Bgs1nVYFTOEj32WaYzl4k7loxtNrhze5qG+fxvDdfa38rpcDEG77rIfvlIzSlT1CrXpUaGl1DgG87g5xD8RBkP6FVPr2gZ4mYad+zqW2CICP3x+F0p7ZDE5gxcoY0dETQmPUl4/LDtTIiUvL8whpVq0hz+N+V+xT/es1xiJp3PahQppn4UU36ZM4dXSiuy0SwXZUIqDXVQV86wUyvMRYbTEldzu9ZccZqTKAHV7fWacQDSK/XMMJrXQuPSIG3aesd3u8KIjVYDnaDwkxm8MrbUSn73+L5h7Wy5p/6bsjmSNNHrj2cd+MDUcAjZULcWb9id8oSHLsUw6iutFk16Ge97ffZG1ijz4TV+WgqTRXOuCNN73uDvRlYLrnsXxbIjcQbUxmZaasCEBDoC2FGPqJdzp5IDwQqPGtmdbQyuJRspx8oBLT21p2h/einIBXpj7LMy1r07jdrKL4SdNzp4a/iEIrlN5VVzLh/MQnKO0DVLGY85120aqTt0f9Oz7wKHSjU6Q2442TAo83Zwg/zFsTaXm0EgbT3stNycOZTditaKVNcNRr7PKB8X+gdTD8L69f2rCzWdnORZa9uQip9kbSSChhnnYFj0r0txs+MkJc+5y/sVAhKoMQLwQEhl4iFH2PxK3Y+00RpNmh+hVTf/h/f1hntN+qDDUxhfs5vKvrrqrz1HO6rGGkFrNc2Ifs2hJWepWfT+PneOqgzfsjDkHJBhXDpr5rDnuEjJsxyjXp0vJ1p3wekH5g9pWcJLkA2fArIR3YvM15ww8UowuPmJX/rVeTjoZkWiC3I6nwB1t8+l6fZ212z/5pSvjIJTOc1IPw/oPJY6C9Yb10h0fs2pkW9CcRp4btl4aGUKRXpMGbUOVPbuXPBUJKd7gtHvRm2
 Te6hRd62
 KYv81DGCJddEt5R6OI92VvPLIJ8jGMyH10+lqNrox97W8H/LvH3uW+JhjRS7b+UNkGqqWshVIbvM+HkW2MD1b88kXwJHbXAj1slaoBg/pLLKMBn6d1TWdsL9fjJzO+A9kSEHNu+GS3cyuTzcW/gfw2RgHkAy33uTi8Q2rZQSJ5eNEHfjygganQgtzC0ry8nuf51XIbVBLGyDJtqJFFrLiDtJ8tQhbOLDeHGQan/BdYQxIv1wNBu7C768/FOPNis2t4kK1ECSvknRsM43bDSouLrxIiLfwcXd24QLLd0byQXp9mS0nIRZGAfozEaizgUIm/84w+jMkbV4ccchpFmaZgAoFwqGJ3o5AVLljQoTURhoqvudUWEO2aeyoP02F1OddcBYzuQYg1ExA5ibdaLCp67dJnBpwpTXodi22
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use has_deposited_pgtable() in move_huge_pmd() to decide whether
pmd_move_must_withdraw() should move a deposited pgtable instead of
using the VMA type.

PowerPC radix follows the generic rule.  PowerPC hash keeps returning
true.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  5 ++---
 arch/powerpc/mm/book3s64/pgtable.c           | 11 +++++------
 mm/huge_memory.c                             | 20 ++++++++++++--------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index b6629c041e75..a0042cacac8d 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1424,9 +1424,8 @@ extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 
 #define pmd_move_must_withdraw pmd_move_must_withdraw
 struct spinlock;
-extern int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
-				  struct spinlock *old_pmd_ptl,
-				  struct vm_area_struct *vma);
+extern bool pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
+		struct spinlock *old_pmd_ptl, bool has_deposit);
 /*
  * Hash translation mode use the deposited table to store hash pte
  * slot information.
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 85ab6723c8f2..4c45b5762d57 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -548,15 +548,14 @@ void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
  * pmd page. Hence if we have different pmd page we need to withdraw during pmd
  * move.
  *
- * With hash we use deposited table always irrespective of anon or not.
- * With radix we use deposited table only for anonymous mapping.
+ * With hash we use deposited table always irrespective of has_deposit or not.
+ * With radix we use the same rule as the generic implementation.
  */
-int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
-			   struct spinlock *old_pmd_ptl,
-			   struct vm_area_struct *vma)
+bool pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
+		struct spinlock *old_pmd_ptl, bool has_deposit)
 {
 	if (radix_enabled())
-		return (new_pmd_ptl != old_pmd_ptl) && vma_is_anonymous(vma);
+		return (new_pmd_ptl != old_pmd_ptl) && has_deposit;
 
 	return true;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8cd77389d52f..be9b637c813b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2552,17 +2552,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 }
 
 #ifndef pmd_move_must_withdraw
-static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
-					 spinlock_t *old_pmd_ptl,
-					 struct vm_area_struct *vma)
+static inline bool pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
+		spinlock_t *old_pmd_ptl, bool has_deposit)
 {
 	/*
 	 * With split pmd lock we also need to move preallocated
 	 * PTE page table if new_pmd is on different PMD page table.
-	 *
-	 * We also don't deposit and withdraw tables for file pages.
 	 */
-	return (new_pmd_ptl != old_pmd_ptl) && vma_is_anonymous(vma);
+	return (new_pmd_ptl != old_pmd_ptl) && has_deposit;
 }
 #endif
 
@@ -2595,8 +2592,11 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 {
 	spinlock_t *old_ptl, *new_ptl;
 	pmd_t pmd;
+	struct folio *folio = NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
+	bool has_deposit;
+	bool is_present;
 
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
@@ -2618,11 +2618,15 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		if (new_ptl != old_ptl)
 			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 		pmd = pmdp_huge_get_and_clear(mm, old_addr, old_pmd);
-		if (pmd_present(pmd))
+		is_present = pmd_present(pmd);
+		if (is_present)
 			force_flush = true;
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
-		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
+		folio = normal_or_softleaf_folio_pmd(vma, old_addr, pmd, is_present);
+		has_deposit = has_deposited_pgtable(vma, pmd, folio);
+
+		if (pmd_move_must_withdraw(new_ptl, old_ptl, has_deposit)) {
 			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFE3CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C73D8E0031; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DEA8E0002; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416678E0031; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 248408E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1871BBE49
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:49 +0000 (UTC)
X-FDA: 83976917178.06.C7595F9
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id B17AF1A0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=D8APie9U;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ynHRbbe4+7ErPaPI1Eyvoxco3jbbrkwZx8nsAlQDIg=;
	b=L4bdtcb1gK0I7BHtzvyIATNkZEd7GMjIaDsZKb/MvkrFyfx/oBhjD7x4L6nYfP3FGlNyGX
	bn9WhylTgNkOn55bRUsWc7Rd1yGxw17bnoYvvCH34lCy+hdFD0/M5zdFjg0H87WIymJpnZ
	aJZUh+odLqmuqA27CoCy/L8O7FjXt+8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=D8APie9U;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975128; a=rsa-sha256;
	cv=none;
	b=6wCBokbxG2W679UPsRrpHbZnLX+qAy6zxGXPmCttvgutxjliB/al5jMBZKe9fo3zk6aXwo
	fpV/6SGQ8thK5YNoZErJYdRuBBiPs0pcEOCGQ6no1qkKvZ6VDcxocfFU3i4xcgEKLTLuyI
	GHCnhuPnF/lFsWmU/VZOfFNmp3Xwjo4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-26d0fbe238bso2902365ad.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975126; x=1760579926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ynHRbbe4+7ErPaPI1Eyvoxco3jbbrkwZx8nsAlQDIg=;
        b=D8APie9U4WtF4Gv+2f9w6vRqyQg8lzC+TxU7B3+nnOgkAdoomlySa4eJrDcR7+V8LS
         /MqrhiSI6JsIoC9K5cq6+RDHQFMHVa4yMNhZvXJjGMBE2rxT63TYFkMWzFRtPkq7SkW+
         r7mHNjXFWL/i2BjVRY6GeVRgCzINbn6XxoGoVhOA6glVT/i+Ss90eLDGzroxBfUOHRpD
         4pUw2N4ma8skIpgapsqVTdEqiVSWJ1Fz9JccHC4uIGQJ8ZK07hy6B6T8SkgG+BSJWtqx
         AkEZc3oMMVRPMjYP3uYwSUZMFSZ/zMH3p3FO5IFYWsLO6vk+c4LmWziHkQ0d/zB8EmDU
         aLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975126; x=1760579926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ynHRbbe4+7ErPaPI1Eyvoxco3jbbrkwZx8nsAlQDIg=;
        b=ouLc+//ldPdc8EXl1BOrDNrxUCCFLmaA58qky/c+32g2heH2hO7sPwHtOtf+9IWpWb
         B3wQQrNjNihGPPZU0crL71rOxZWV6qW0Gj2lVcpDE+752Gd+JNoAkF23luy0Sb4qdS7l
         Qwuya0YIVhq5gX+fMYQhW3FwCQnMcKle4emvEGAsAZmZQBp83VNak7bZR98WsXxo11Wl
         qG2aDvtjcny612lFzpo4YLArX8c/7OKHj+Z+FQhoa+16BI/vdCVAAz8Ocq49/6tdGzVV
         x0rqkWmXJoqA1FKVvzc7nvXbSTMuUIgh5LH+oQg0jIGwJAqwpAIgzIUD34TWwxynxEMF
         ERGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtdYgrpBuSE+jcR55Hvl2ZxEW6NMHcvVtBwiBV22lAF2QTdj4uHa4QmwaEtFUEmHASvL+1KyfYxg==@kvack.org
X-Gm-Message-State: AOJu0Ywnx5nd/cfQ04eSwVfDywPJfX60WQVTsgr72+rzdUfGhtIRLSeQ
	E0pCDCo+SZXZ3ELAPg2S6gsaYCLN63gnCVqv74GMJtZccjLfX+yIAyXx/FWV532JM2o=
X-Gm-Gg: ASbGncu+Z5cjpzadocvOHKVxdF3ffz1Z2YQwC4uXKuP9egj1ghS9cvxe0n6GHZzZot8
	Rlk7eYQcPwuiPZa8ET+io3J8N+wxyaNLDBZBHg5tHALlt95GyiP9MB8CjkznRBARaIA1D45RaC9
	uK1u2ErJTQ04opbZhWN8kcPoil0HU/KwwxXNNbl8/3yOrZs/tsSHgkoJaxaPTm87TEZnmSySDve
	9LathTMR/1+bhbNQTYL0Ajy69w3Tw954SwWY7OZ7l88wwhGZj9savHur/OxY7J70xwAMYKilCyQ
	jaeSZNLpZWgj7vHRj8mJ+6mDT3BiITW1abEOM6KgLuYF/XEdxt6nWEnf6W4eV6Tb4u+Txxlypra
	MfNeKmVU0SW6Deo6pjHer68BU7xfb4YNlB8wGDyvmJ55ziOAbLJSUc9e9jZCTFf2wroQa
X-Google-Smtp-Source: AGHT+IFu6xzH3L7WzUfNrXSvmusyB318emtG9Lz9QjaiZ8IDbSkJErUs40T5Vlp7mRA5YkoLdo7S1w==
X-Received: by 2002:a17:903:2302:b0:263:ac60:fc41 with SMTP id d9443c01a7336-290274030a0mr69975465ad.48.1759975125975;
        Wed, 08 Oct 2025 18:58:45 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:45 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 04/18] mm: Always use page table accessor functions
Date: Wed,  8 Oct 2025 18:57:40 -0700
Message-ID: <20251009015839.3460231-5-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B17AF1A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: 8t7nftop8s8tcsg8f16a74ag9spo1rrs
X-HE-Tag: 1759975127-368282
X-HE-Meta: U2FsdGVkX18fYuhyq/5cb1TPsVZJz3TyQnmn7W9Q1hCK45ZGAKGGq5vHSgE5nbJExZQqoarvNaFpJZBLjaPgx/TNCdH8ytZQTgS+o/xa42jHEbgbIA7kpp7ZPpUpYnlY03QknNVTjhxT5YKgWxnTg8WrxMTj2RVvW9W+qw5k4sjyDZrawEGaRecYMHCpoYg1eVkTWpQMM/jFRllMEHI8ptSI9rRBUN8dN7HyW3p0mIScXWkEzmsoQGJAB2PnhGBh+TaoLi3bifL0IRVwYkkAwVi2OAIkr6p1++5wb50LFTEqlcrYGxQT0DbH/MDBwNKwa2kgfDbvGGg4D43F1H0l2Irp6Lzh1pxjfALWa9WfGi3zc5p3MtVSI7laWvCXOuQxCm+aQ9JsfZYJ+W4F/lQzEf0rKxDITbhhcX8d7tgDcXxNHjHbskA/z023LM9zxEZJnokFMmEk4alk4Azf9UxlcoCfRPSCWCL5diL9SyEOs6BEhDlGCDf+SyT6T+A7NN+Zb2MgdjZLeWnyk6B4pcb6xOKvuNeTMvlAEJIBQA3z7bowzQqXcsIB6haJ/b5boz5jwvPpXBxpTntx/1IWcSOvD0bh00moHWm5i1WAZ9mCnCwG0ADFJMxEHs9QFIJLn3iRHxXHLL+MJIayMLdUQu81/pDD+RQxo/u2Do6/nlWO6l5/pzVeUjHEEpsEeRiZqs4fLm378uX3JIxUGuFQxQAIb9Ilu3zTQaC9deDowlT+AlQ61OEik3lc/z5VSdLBgojY8rDZ240bRxUT7AJ9+RfLVyJRilHOK1QTBcP/TUj4PpeS6+XqSONqeKMsCfgzI60GlaPniX+QDObZp9Irdb3yS086cCsQYZmBib6VglZDuIC/3NBhnIcUe6pZzIopCmZRiRsVstvdGeMzgBcGX1MHw+pjWYJDfk1C646callSyPk4Wk/Q7ATDpWWZ5VTvYU90qGFRmZJEriZysuCjjyr
 8vW1YLU1
 1IkUxcybHqmG8CjUJ8LDdpf1QaF6VD3lUY8dnwzFxuQatH5ik3QVZxep8/BwRbiW3wxqAqjRm6UkYxhYzAqiBFJEvJ5lT2W2U8qrsPzazBvpgXmmcFda7uXaqhpvXQBo/UABUYmUYrE4vVJ3lo35xdU6nP9Es6sD8naFANSrssNbsKMKAT+FURYmM/bQfEeL9oAf6XG+/aro+bd0LFMCgrbhPol/5UCjgXmm4caftYv4B/+KkALPFvKEYwEuc+OwXofY+zu7tDr8P0N33zpaAOT8IkFFSWYj56EnoKNfyNLk4XBp/evIu2Fgur7MECkgPLRtERYV6Sndfdahf89Edl/Upow2yFxqr5iFtTmPRMQ6DHGK5u2ubNh5RDxx4uUwDhoAdT4eiaV2LJ1sI9xEzvANMxGsarznMCBUL4L6tDr+iuhVqwfwGGiTTYF6GuT+soWtW4nsuvra+2/bjV2/rR+4Uj4mIhBtWoxqcPplXz7R7zvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms need to fix up the values when reading or writing page
tables. Because of this, the accessors must always be used; it is not
valid to simply dereference a pXX_t pointer.

Fix all of the instances of this pattern in generic code, mostly by
applying the below coccinelle semantic patch, repeated for each page
table level. Some additional fixes were applied manually, mostly to
macros where type information is unavailable.

In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
or PMDE value stored on the stack, not a pointer to a page table. In
those cases, it is not appropriate to use the accessors, because the
value is not globally visible, and any transformation from pXXp_get()
has already been applied. Those places are marked by naming the pointer
`ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.

@@
pte_t *P;
expression E;
expression I;
@@
- P[I] = E
+ set_pte(P + I, E)

@@
pte_t *P;
expression E;
@@
(
- WRITE_ONCE(*P, E)
+ set_pte(P, E)
|
- *P = E
+ set_pte(P, E)
)

@@
pte_t *P;
expression I;
@@
(
  &P[I]
|
- READ_ONCE(P[I])
+ ptep_get(P + I)
|
- P[I]
+ ptep_get(P + I)
)

@@
pte_t *P;
@@
(
- READ_ONCE(*P)
+ ptep_get(P)
|
- *P
+ ptep_get(P)
)

Additionally, the following semantic patch was used to convert PMD and
PUD references inside struct vm_fault:

@@
struct vm_fault vmf;
@@
(
- *vmf.pmd
+ pmdp_get(vmf.pmd)
|
- *vmf.pud
+ pudp_get(vmf.pud)
)

@@
struct vm_fault *vmf;
@@
(
- *vmf->pmd
+ pmdp_get(vmf->pmd)
|
- *vmf->pud
+ pudp_get(vmf->pud)
)

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---
This commit covers some of the same changes as an existing series from
Anshuman Khandual[1]. Unlike that series, this commit is a purely
mechanical conversion to demonstrate the RISC-V changes, so it does not
insert local variables to avoid redundant calls to the accessors. A
manual conversion like in that series could improve performance.

[1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/

Changes in v2:
 - New patch for v2

 fs/dax.c                   |  4 +-
 fs/proc/task_mmu.c         | 27 ++++++------
 fs/userfaultfd.c           |  6 +--
 include/linux/huge_mm.h    |  8 ++--
 include/linux/mm.h         | 14 +++---
 include/linux/pgtable.h    | 42 +++++++++---------
 mm/debug_vm_pgtable.c      |  4 +-
 mm/filemap.c               |  6 +--
 mm/gup.c                   | 34 +++++++-------
 mm/hmm.c                   |  2 +-
 mm/huge_memory.c           | 90 +++++++++++++++++++-------------------
 mm/hugetlb.c               | 10 ++---
 mm/hugetlb_vmemmap.c       |  4 +-
 mm/kasan/init.c            | 39 +++++++++--------
 mm/kasan/shadow.c          | 12 ++---
 mm/khugepaged.c            |  4 +-
 mm/ksm.c                   |  2 +-
 mm/madvise.c               |  8 ++--
 mm/mapping_dirty_helpers.c |  2 +-
 mm/memory-failure.c        | 14 +++---
 mm/memory.c                | 78 ++++++++++++++++-----------------
 mm/mempolicy.c             |  4 +-
 mm/migrate.c               |  4 +-
 mm/migrate_device.c        | 10 ++---
 mm/mlock.c                 |  6 +--
 mm/mprotect.c              |  4 +-
 mm/mremap.c                | 30 ++++++-------
 mm/page_table_check.c      |  4 +-
 mm/page_vma_mapped.c       |  6 +--
 mm/pagewalk.c              | 14 +++---
 mm/percpu.c                |  8 ++--
 mm/pgalloc-track.h         |  8 ++--
 mm/pgtable-generic.c       | 23 +++++-----
 mm/rmap.c                  |  8 ++--
 mm/sparse-vmemmap.c        | 10 ++---
 mm/userfaultfd.c           | 10 ++---
 mm/vmalloc.c               | 49 +++++++++++----------
 mm/vmscan.c                | 16 +++----
 38 files changed, 314 insertions(+), 310 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 20ecf652c129d..4150f5ab84aea 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1927,7 +1927,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, unsigned long *pfnp,
 	 * the PTE we need to set up.  If so just return and the fault will be
 	 * retried.
 	 */
-	if (pmd_trans_huge(*vmf->pmd)) {
+	if (pmd_trans_huge(pmdp_get(vmf->pmd))) {
 		ret = VM_FAULT_NOPAGE;
 		goto unlock_entry;
 	}
@@ -2050,7 +2050,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
 	 * the PMD we need to set up.  If so just return and the fault will be
 	 * retried.
 	 */
-	if (!pmd_none(*vmf->pmd) && !pmd_trans_huge(*vmf->pmd)) {
+	if (!pmd_none(pmdp_get(vmf->pmd)) && !pmd_trans_huge(pmdp_get(vmf->pmd))) {
 		ret = 0;
 		goto unlock_entry;
 	}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b26ae556b4463..6b2e2fbc572d5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -988,11 +988,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	bool present = false;
 	struct folio *folio;
 
-	if (pmd_present(*pmd)) {
-		page = vm_normal_page_pmd(vma, addr, *pmd);
+	if (pmd_present(pmdp_get(pmd))) {
+		page = vm_normal_page_pmd(vma, addr, pmdp_get(pmd));
 		present = true;
-	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
-		swp_entry_t entry = pmd_to_swp_entry(*pmd);
+	} else if (unlikely(thp_migration_supported() && is_swap_pmd(pmdp_get(pmd)))) {
+		swp_entry_t entry = pmd_to_swp_entry(pmdp_get(pmd));
 
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
@@ -1009,7 +1009,8 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+	smaps_account(mss, page, true, pmd_young(pmdp_get(pmd)),
+		      pmd_dirty(pmdp_get(pmd)),
 		      locked, present);
 }
 #else
@@ -1564,7 +1565,7 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
-	pmd_t old, pmd = *pmdp;
+	pmd_t old, pmd = pmdp_get(pmdp);
 
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
@@ -1606,10 +1607,10 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 			goto out;
 		}
 
-		if (!pmd_present(*pmd))
+		if (!pmd_present(pmdp_get(pmd)))
 			goto out;
 
-		folio = pmd_folio(*pmd);
+		folio = pmd_folio(pmdp_get(pmd));
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
@@ -1917,7 +1918,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	if (ptl) {
 		unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
 		u64 flags = 0, frame = 0;
-		pmd_t pmd = *pmdp;
+		pmd_t pmd = pmdp_get(pmdp);
 		struct page *page = NULL;
 		struct folio *folio = NULL;
 
@@ -2344,7 +2345,7 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 			     unsigned long addr, pmd_t *pmdp)
 {
-	pmd_t old, pmd = *pmdp;
+	pmd_t old, pmd = pmdp_get(pmdp);
 
 	if (pmd_present(pmd)) {
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
@@ -2574,7 +2575,7 @@ static int pagemap_scan_thp_entry(pmd_t *pmd, unsigned long start,
 		return -ENOENT;
 
 	categories = p->cur_vma_category |
-		     pagemap_thp_category(p, vma, start, *pmd);
+		     pagemap_thp_category(p, vma, start, pmdp_get(pmd));
 
 	if (!pagemap_scan_is_interesting_page(categories, p))
 		goto out_unlock;
@@ -3109,9 +3110,9 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 	if (ptl) {
 		struct page *page;
 
-		page = can_gather_numa_stats_pmd(*pmd, vma, addr);
+		page = can_gather_numa_stats_pmd(pmdp_get(pmd), vma, addr);
 		if (page)
-			gather_stats(page, md, pmd_dirty(*pmd),
+			gather_stats(page, md, pmd_dirty(pmdp_get(pmd)),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
 		spin_unlock(ptl);
 		return 0;
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c62..2e2a6b326c2f7 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -289,13 +289,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	assert_fault_locked(vmf);
 
 	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
+	if (!pgd_present(pgdp_get(pgd)))
 		goto out;
 	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(*p4d))
+	if (!p4d_present(p4dp_get(p4d)))
 		goto out;
 	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
+	if (!pud_present(pudp_get(pud)))
 		goto out;
 	pmd = pmd_offset(pud, address);
 again:
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b7..1d07dbf166f9b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -402,7 +402,7 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		if (is_swap_pmd(*____pmd) || pmd_trans_huge(*____pmd))	\
+		if (is_swap_pmd(pmdp_get(____pmd)) || pmd_trans_huge(pmdp_get(____pmd)))	\
 			__split_huge_pmd(__vma, __pmd, __address,	\
 					 false);			\
 	}  while (0)
@@ -427,7 +427,7 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #define split_huge_pud(__vma, __pud, __address)				\
 	do {								\
 		pud_t *____pud = (__pud);				\
-		if (pud_trans_huge(*____pud))				\
+		if (pud_trans_huge(pudp_get(____pud)))				\
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
@@ -449,7 +449,7 @@ static inline int is_swap_pmd(pmd_t pmd)
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
-	if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd))
+	if (is_swap_pmd(pmdp_get(pmd)) || pmd_trans_huge(pmdp_get(pmd)))
 		return __pmd_trans_huge_lock(pmd, vma);
 	else
 		return NULL;
@@ -457,7 +457,7 @@ static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 		struct vm_area_struct *vma)
 {
-	if (pud_trans_huge(*pud))
+	if (pud_trans_huge(pudp_get(pud)))
 		return __pud_trans_huge_lock(pud, vma);
 	else
 		return NULL;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec75..5857ab48b9039 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2828,20 +2828,20 @@ int __pte_alloc_kernel(pmd_t *pmd);
 static inline p4d_t *p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
 		unsigned long address)
 {
-	return (unlikely(pgd_none(*pgd)) && __p4d_alloc(mm, pgd, address)) ?
+	return (unlikely(pgd_none(pgdp_get(pgd))) && __p4d_alloc(mm, pgd, address)) ?
 		NULL : p4d_offset(pgd, address);
 }
 
 static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
 		unsigned long address)
 {
-	return (unlikely(p4d_none(*p4d)) && __pud_alloc(mm, p4d, address)) ?
+	return (unlikely(p4d_none(p4dp_get(p4d))) && __pud_alloc(mm, p4d, address)) ?
 		NULL : pud_offset(p4d, address);
 }
 
 static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 {
-	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
+	return (unlikely(pud_none(pudp_get(pud))) && __pmd_alloc(mm, pud, address))?
 		NULL: pmd_offset(pud, address);
 }
 #endif /* CONFIG_MMU */
@@ -2928,9 +2928,9 @@ static inline spinlock_t *ptlock_ptr(struct ptdesc *ptdesc)
 }
 #endif /* ALLOC_SPLIT_PTLOCKS */
 
-static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
+static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmdvalp)
 {
-	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));
+	return ptlock_ptr(page_ptdesc(pmd_page(*pmdvalp)));
 }
 
 static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
@@ -3042,7 +3042,7 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 	pte_unmap(pte);					\
 } while (0)
 
-#define pte_alloc(mm, pmd) (unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, pmd))
+#define pte_alloc(mm, pmd) (unlikely(pmd_none(pmdp_get(pmd))) && __pte_alloc(mm, pmd))
 
 #define pte_alloc_map(mm, pmd, address)			\
 	(pte_alloc(mm, pmd) ? NULL : pte_offset_map(pmd, address))
@@ -3052,7 +3052,7 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 		 NULL : pte_offset_map_lock(mm, pmd, address, ptlp))
 
 #define pte_alloc_kernel(pmd, address)			\
-	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
+	((unlikely(pmd_none(pmdp_get(pmd))) && __pte_alloc_kernel(pmd))? \
 		NULL: pte_offset_kernel(pmd, address))
 
 #if defined(CONFIG_SPLIT_PMD_PTLOCKS)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 50286763b652f..17bf75c98fd52 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -149,14 +149,14 @@ static inline void pud_init(void *addr)
 #ifndef pte_offset_kernel
 static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
-	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
+	return (pte_t *)pmd_page_vaddr(pmdp_get(pmd)) + pte_index(address);
 }
 #define pte_offset_kernel pte_offset_kernel
 #endif
 
 #ifdef CONFIG_HIGHPTE
 #define __pte_map(pmd, address) \
-	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
+	((pte_t *)kmap_local_page(pmd_page(pmdp_get(pmd))) + pte_index((address)))
 #define pte_unmap(pte)	do {	\
 	kunmap_local((pte));	\
 	rcu_read_unlock();	\
@@ -178,7 +178,7 @@ void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
 #ifndef pmd_offset
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 {
-	return pud_pgtable(*pud) + pmd_index(address);
+	return pud_pgtable(pudp_get(pud)) + pmd_index(address);
 }
 #define pmd_offset pmd_offset
 #endif
@@ -186,7 +186,7 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 #ifndef pud_offset
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 {
-	return p4d_pgtable(*p4d) + pud_index(address);
+	return p4d_pgtable(p4dp_get(p4d)) + pud_index(address);
 }
 #define pud_offset pud_offset
 #endif
@@ -230,7 +230,7 @@ static inline pte_t *virt_to_kpte(unsigned long vaddr)
 {
 	pmd_t *pmd = pmd_off_k(vaddr);
 
-	return pmd_none(*pmd) ? NULL : pte_offset_kernel(pmd, vaddr);
+	return pmd_none(pmdp_get(pmd)) ? NULL : pte_offset_kernel(pmd, vaddr);
 }
 
 #ifndef pmd_young
@@ -390,7 +390,7 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
 					    pmd_t *pmdp)
 {
-	pmd_t pmd = *pmdp;
+	pmd_t pmd = pmdp_get(pmdp);
 	int r = 1;
 	if (!pmd_young(pmd))
 		r = 0;
@@ -645,7 +645,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address,
 					    pmd_t *pmdp)
 {
-	pmd_t pmd = *pmdp;
+	pmd_t pmd = pmdp_get(pmdp);
 
 	pmd_clear(pmdp);
 	page_table_check_pmd_clear(mm, pmd);
@@ -658,7 +658,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address,
 					    pud_t *pudp)
 {
-	pud_t pud = *pudp;
+	pud_t pud = pudp_get(pudp);
 
 	pud_clear(pudp);
 	page_table_check_pud_clear(mm, pud);
@@ -968,7 +968,7 @@ static inline pte_t pte_sw_mkyoung(pte_t pte)
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pmd_t *pmdp)
 {
-	pmd_t old_pmd = *pmdp;
+	pmd_t old_pmd = pmdp_get(pmdp);
 	set_pmd_at(mm, address, pmdp, pmd_wrprotect(old_pmd));
 }
 #else
@@ -985,7 +985,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline void pudp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pud_t *pudp)
 {
-	pud_t old_pud = *pudp;
+	pud_t old_pud = pudp_get(pudp);
 
 	set_pud_at(mm, address, pudp, pud_wrprotect(old_pud));
 }
@@ -1009,7 +1009,7 @@ static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 					pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return *pmdp;
+	return pmdp_get(pmdp);
 }
 #define pmdp_collapse_flush pmdp_collapse_flush
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -1037,7 +1037,7 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	pmd_t old_pmd = *pmdp;
+	pmd_t old_pmd = pmdp_get(pmdp);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
 	return old_pmd;
 }
@@ -1287,9 +1287,9 @@ void pmd_clear_bad(pmd_t *);
 
 static inline int pgd_none_or_clear_bad(pgd_t *pgd)
 {
-	if (pgd_none(*pgd))
+	if (pgd_none(pgdp_get(pgd)))
 		return 1;
-	if (unlikely(pgd_bad(*pgd))) {
+	if (unlikely(pgd_bad(pgdp_get(pgd)))) {
 		pgd_clear_bad(pgd);
 		return 1;
 	}
@@ -1298,9 +1298,9 @@ static inline int pgd_none_or_clear_bad(pgd_t *pgd)
 
 static inline int p4d_none_or_clear_bad(p4d_t *p4d)
 {
-	if (p4d_none(*p4d))
+	if (p4d_none(p4dp_get(p4d)))
 		return 1;
-	if (unlikely(p4d_bad(*p4d))) {
+	if (unlikely(p4d_bad(p4dp_get(p4d)))) {
 		p4d_clear_bad(p4d);
 		return 1;
 	}
@@ -1309,9 +1309,9 @@ static inline int p4d_none_or_clear_bad(p4d_t *p4d)
 
 static inline int pud_none_or_clear_bad(pud_t *pud)
 {
-	if (pud_none(*pud))
+	if (pud_none(pudp_get(pud)))
 		return 1;
-	if (unlikely(pud_bad(*pud))) {
+	if (unlikely(pud_bad(pudp_get(pud)))) {
 		pud_clear_bad(pud);
 		return 1;
 	}
@@ -1320,9 +1320,9 @@ static inline int pud_none_or_clear_bad(pud_t *pud)
 
 static inline int pmd_none_or_clear_bad(pmd_t *pmd)
 {
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdp_get(pmd)))
 		return 1;
-	if (unlikely(pmd_bad(*pmd))) {
+	if (unlikely(pmd_bad(pmdp_get(pmd)))) {
 		pmd_clear_bad(pmd);
 		return 1;
 	}
@@ -1798,7 +1798,7 @@ static inline int pud_trans_unstable(pud_t *pud)
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd086..fb5596e2e4262 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -431,7 +431,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	set_pmd(args->pmdp, __pmd(0));
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -451,7 +451,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	set_pud(args->pudp, __pud(0));
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e51..75e1d1d1a636b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3567,13 +3567,13 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
 	struct mm_struct *mm = vmf->vma->vm_mm;
 
 	/* Huge page is mapped? No need to proceed. */
-	if (pmd_trans_huge(*vmf->pmd)) {
+	if (pmd_trans_huge(pmdp_get(vmf->pmd))) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return true;
 	}
 
-	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
+	if (pmd_none(pmdp_get(vmf->pmd)) && folio_test_pmd_mappable(folio)) {
 		struct page *page = folio_file_page(folio, start);
 		vm_fault_t ret = do_set_pmd(vmf, folio, page);
 		if (!ret) {
@@ -3583,7 +3583,7 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
 		}
 	}
 
-	if (pmd_none(*vmf->pmd) && vmf->prealloc_pte)
+	if (pmd_none(pmdp_get(vmf->pmd)) && vmf->prealloc_pte)
 		pmd_install(mm, vmf->pmd, &vmf->prealloc_pte);
 
 	return false;
diff --git a/mm/gup.c b/mm/gup.c
index 0bc4d140fc07f..f5676a3aa525d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -665,7 +665,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
-	pud_t pud = *pudp;
+	pud_t pud = pudp_get(pudp);
 	unsigned long pfn = pud_pfn(pud);
 	int ret;
 
@@ -717,7 +717,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 				    struct follow_page_context *ctx)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pmd_t pmdval = *pmd;
+	pmd_t pmdval = pmdp_get(pmd);
 	struct page *page;
 	int ret;
 
@@ -732,7 +732,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(pmdval))
 		return ERR_PTR(-EFAULT);
 
-	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
+	if (pmd_protnone(pmdp_get(pmd)) && !gup_can_follow_protnone(vma, flags))
 		return NULL;
 
 	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
@@ -932,7 +932,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 
 	ptl = pmd_lock(mm, pmd);
-	pmdval = *pmd;
+	pmdval = pmdp_get(pmd);
 	if (unlikely(!pmd_present(pmdval))) {
 		spin_unlock(ptl);
 		return no_page_table(vma, flags, address);
@@ -964,7 +964,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
@@ -989,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	p4d_t *p4dp, p4d;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	BUILD_BUG_ON(p4d_leaf(p4d));
 
 	if (!p4d_present(p4d) || p4d_bad(p4d))
@@ -1035,7 +1035,7 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 	ctx->page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+	if (pgd_none(pgdp_get(pgd)) || unlikely(pgd_bad(pgdp_get(pgd))))
 		page = no_page_table(vma, flags, address);
 	else
 		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
@@ -1061,16 +1061,16 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 	if (gup_flags & FOLL_WRITE)
 		return -EFAULT;
 	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd))
+	if (pgd_none(pgdp_get(pgd)))
 		return -EFAULT;
 	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d))
+	if (p4d_none(p4dp_get(p4d)))
 		return -EFAULT;
 	pud = pud_offset(p4d, address);
-	if (pud_none(*pud))
+	if (pud_none(pudp_get(pud)))
 		return -EFAULT;
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	if (!pmd_present(pmdp_get(pmd)))
 		return -EFAULT;
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -2897,7 +2897,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get(pmdp))) ||
 		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
@@ -2979,7 +2979,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
+	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get(pmdp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -3019,7 +3019,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
+	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -3080,7 +3080,7 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
-		pud_t pud = READ_ONCE(*pudp);
+		pud_t pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
@@ -3106,7 +3106,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
-		p4d_t p4d = READ_ONCE(*p4dp);
+		p4d_t p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
@@ -3128,7 +3128,7 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 
 	pgdp = pgd_offset(current->mm, addr);
 	do {
-		pgd_t pgd = READ_ONCE(*pgdp);
+		pgd_t pgd = pgdp_get(pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/mm/hmm.c b/mm/hmm.c
index d545e24949949..126c3f42e5256 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -431,7 +431,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 	/* Normally we don't want to split the huge page */
 	walk->action = ACTION_CONTINUE;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f091..84ab006035440 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1233,7 +1233,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_none(*vmf->pmd))) {
+	if (unlikely(!pmd_none(pmdp_get(vmf->pmd)))) {
 		goto unlock_release;
 	} else {
 		ret = check_stable_address_space(vma->vm_mm);
@@ -1345,7 +1345,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
-		if (pmd_none(*vmf->pmd)) {
+		if (pmd_none(pmdp_get(vmf->pmd))) {
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
@@ -1388,16 +1388,16 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 	lockdep_assert_held(pmd_lockptr(mm, pmd));
 
-	if (!pmd_none(*pmd)) {
+	if (!pmd_none(pmdp_get(pmd))) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
 		if (write) {
-			if (pmd_pfn(*pmd) != pfn) {
-				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
+			if (pmd_pfn(pmdp_get(pmd)) != pfn) {
+				WARN_ON_ONCE(!is_huge_zero_pmd(pmdp_get(pmd)));
 				return -EEXIST;
 			}
-			entry = pmd_mkyoung(*pmd);
+			entry = pmd_mkyoung(pmdp_get(pmd));
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
 				update_mmu_cache_pmd(vma, addr, pmd);
@@ -1537,14 +1537,14 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	pud_t entry;
 
-	if (!pud_none(*pud)) {
+	if (!pud_none(pudp_get(pud))) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
 		if (write) {
-			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
+			if (WARN_ON_ONCE(pud_pfn(pudp_get(pud)) != pfn))
 				return;
-			entry = pud_mkyoung(*pud);
+			entry = pud_mkyoung(pudp_get(pud));
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
 				update_mmu_cache_pud(vma, addr, pud);
@@ -1655,7 +1655,7 @@ void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	pmd_t _pmd;
 
-	_pmd = pmd_mkyoung(*pmd);
+	_pmd = pmd_mkyoung(pmdp_get(pmd));
 	if (write)
 		_pmd = pmd_mkdirty(_pmd);
 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
@@ -1705,7 +1705,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	ret = -EAGAIN;
-	pmd = *src_pmd;
+	pmd = pmdp_get(src_pmd);
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (unlikely(is_swap_pmd(pmd))) {
@@ -1716,9 +1716,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
-			if (pmd_swp_soft_dirty(*src_pmd))
+			if (pmd_swp_soft_dirty(pmdp_get(src_pmd)))
 				pmd = pmd_swp_mksoft_dirty(pmd);
-			if (pmd_swp_uffd_wp(*src_pmd))
+			if (pmd_swp_uffd_wp(pmdp_get(src_pmd)))
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
@@ -1792,7 +1792,7 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 {
 	pud_t _pud;
 
-	_pud = pud_mkyoung(*pud);
+	_pud = pud_mkyoung(pudp_get(pud));
 	if (write)
 		_pud = pud_mkdirty(_pud);
 	if (pudp_set_access_flags(vma, addr & HPAGE_PUD_MASK,
@@ -1813,7 +1813,7 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	ret = -EAGAIN;
-	pud = *src_pud;
+	pud = pudp_get(src_pud);
 	if (unlikely(!pud_trans_huge(pud)))
 		goto out_unlock;
 
@@ -1840,7 +1840,7 @@ void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	vmf->ptl = pud_lock(vmf->vma->vm_mm, vmf->pud);
-	if (unlikely(!pud_same(*vmf->pud, orig_pud)))
+	if (unlikely(!pud_same(pudp_get(vmf->pud), orig_pud)))
 		goto unlock;
 
 	touch_pud(vmf->vma, vmf->address, vmf->pud, write);
@@ -1854,7 +1854,7 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd)))
 		goto unlock;
 
 	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
@@ -1919,7 +1919,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 
 	spin_lock(vmf->ptl);
 
-	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), orig_pmd))) {
 		spin_unlock(vmf->ptl);
 		return 0;
 	}
@@ -1937,7 +1937,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 		spin_unlock(vmf->ptl);
 		folio_lock(folio);
 		spin_lock(vmf->ptl);
-		if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+		if (unlikely(!pmd_same(pmdp_get(vmf->pmd), orig_pmd))) {
 			spin_unlock(vmf->ptl);
 			folio_unlock(folio);
 			folio_put(folio);
@@ -2115,7 +2115,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		goto out_unlocked;
 
-	orig_pmd = *pmd;
+	orig_pmd = pmdp_get(pmd);
 	if (is_huge_zero_pmd(orig_pmd))
 		goto out;
 
@@ -2303,8 +2303,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 	 * should have released it; but move_page_tables() might have already
 	 * inserted a page table, if racing against shmem/file collapse.
 	 */
-	if (!pmd_none(*new_pmd)) {
-		VM_BUG_ON(pmd_trans_huge(*new_pmd));
+	if (!pmd_none(pmdp_get(new_pmd))) {
+		VM_BUG_ON(pmd_trans_huge(pmdp_get(new_pmd)));
 		return false;
 	}
 
@@ -2320,7 +2320,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		pmd = pmdp_huge_get_and_clear(mm, old_addr, old_pmd);
 		if (pmd_present(pmd))
 			force_flush = true;
-		VM_BUG_ON(!pmd_none(*new_pmd));
+		VM_BUG_ON(!pmd_none(pmdp_get(new_pmd)));
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
@@ -2370,12 +2370,12 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-	if (is_swap_pmd(*pmd)) {
-		swp_entry_t entry = pmd_to_swp_entry(*pmd);
+	if (is_swap_pmd(pmdp_get(pmd))) {
+		swp_entry_t entry = pmd_to_swp_entry(pmdp_get(pmd));
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_BUG_ON(!is_pmd_migration_entry(pmdp_get(pmd)));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2386,17 +2386,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			else
 				entry = make_readable_migration_entry(swp_offset(entry));
 			newpmd = swp_entry_to_pmd(entry);
-			if (pmd_swp_soft_dirty(*pmd))
+			if (pmd_swp_soft_dirty(pmdp_get(pmd)))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
 		} else {
-			newpmd = *pmd;
+			newpmd = pmdp_get(pmd);
 		}
 
 		if (uffd_wp)
 			newpmd = pmd_swp_mkuffd_wp(newpmd);
 		else if (uffd_wp_resolve)
 			newpmd = pmd_swp_clear_uffd_wp(newpmd);
-		if (!pmd_same(*pmd, newpmd))
+		if (!pmd_same(pmdp_get(pmd), newpmd))
 			set_pmd_at(mm, addr, pmd, newpmd);
 		goto unlock;
 	}
@@ -2410,13 +2410,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * data is likely to be read-cached on the local CPU and
 		 * local/remote hits to the zero page are not interesting.
 		 */
-		if (is_huge_zero_pmd(*pmd))
+		if (is_huge_zero_pmd(pmdp_get(pmd)))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
+		if (pmd_protnone(pmdp_get(pmd)))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
+		folio = pmd_folio(pmdp_get(pmd));
 		toptier = node_is_toptier(folio_nid(folio));
 		/*
 		 * Skip scanning top tier node if normal numa
@@ -2547,7 +2547,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	src_pmdval = *src_pmd;
+	src_pmdval = pmdp_get(src_pmd);
 	src_ptl = pmd_lockptr(mm, src_pmd);
 
 	lockdep_assert_held(src_ptl);
@@ -2609,8 +2609,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 
 	dst_ptl = pmd_lockptr(mm, dst_pmd);
 	double_pt_lock(src_ptl, dst_ptl);
-	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
-		     !pmd_same(*dst_pmd, dst_pmdval))) {
+	if (unlikely(!pmd_same(pmdp_get(src_pmd), src_pmdval) ||
+		     !pmd_same(pmdp_get(dst_pmd), dst_pmdval))) {
 		err = -EAGAIN;
 		goto unlock_ptls;
 	}
@@ -2676,7 +2676,7 @@ spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
 	spinlock_t *ptl;
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)))
+	if (likely(is_swap_pmd(pmdp_get(pmd)) || pmd_trans_huge(pmdp_get(pmd))))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
@@ -2693,7 +2693,7 @@ spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma)
 	spinlock_t *ptl;
 
 	ptl = pud_lock(vma->vm_mm, pud);
-	if (likely(pud_trans_huge(*pud)))
+	if (likely(pud_trans_huge(pudp_get(pud))))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
@@ -2745,7 +2745,7 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 	VM_BUG_ON(haddr & ~HPAGE_PUD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PUD_SIZE, vma);
-	VM_BUG_ON(!pud_trans_huge(*pud));
+	VM_BUG_ON(!pud_trans_huge(pudp_get(pud)));
 
 	count_vm_event(THP_SPLIT_PUD);
 
@@ -2778,7 +2778,7 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 				(address & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pud_lock(vma->vm_mm, pud);
-	if (unlikely(!pud_trans_huge(*pud)))
+	if (unlikely(!pud_trans_huge(pudp_get(pud))))
 		goto out;
 	__split_huge_pud_locked(vma, pud, range.start);
 
@@ -2851,7 +2851,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+	VM_BUG_ON(!is_pmd_migration_entry(pmdp_get(pmd)) && !pmd_trans_huge(pmdp_get(pmd)));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2886,7 +2886,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(pmdp_get(pmd))) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
@@ -2899,11 +2899,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
+	pmd_migration = is_pmd_migration_entry(pmdp_get(pmd));
 	if (unlikely(pmd_migration)) {
 		swp_entry_t entry;
 
-		old_pmd = *pmd;
+		old_pmd = pmdp_get(pmd);
 		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_swap_entry_to_page(entry);
 		write = is_writable_migration_entry(entry);
@@ -3059,7 +3059,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(pmdp_get(pmd)) || is_pmd_migration_entry(pmdp_get(pmd)))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
@@ -3147,7 +3147,7 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int ref_count, map_count;
-	pmd_t orig_pmd = *pmdp;
+	pmd_t orig_pmd = pmdp_get(pmdp);
 
 	if (pmd_dirty(orig_pmd))
 		folio_set_dirty(folio);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cfe0b43ab8f9..24c509608a35a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7563,7 +7563,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out;
 
 	spin_lock(&mm->page_table_lock);
-	if (pud_none(*pud)) {
+	if (pud_none(pudp_get(pud))) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
 		mm_inc_nr_pmds(mm);
@@ -7657,7 +7657,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			pte = (pte_t *)pud;
 		} else {
 			BUG_ON(sz != PMD_SIZE);
-			if (want_pmd_share(vma, addr) && pud_none(*pud))
+			if (want_pmd_share(vma, addr) && pud_none(pudp_get(pud)))
 				pte = huge_pmd_share(mm, vma, addr, pud);
 			else
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
@@ -7691,17 +7691,17 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
+	if (!pgd_present(pgdp_get(pgd)))
 		return NULL;
 	p4d = p4d_offset(pgd, addr);
-	if (!p4d_present(*p4d))
+	if (!p4d_present(p4dp_get(p4d)))
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
 	if (sz == PUD_SIZE)
 		/* must be pud huge, non-present or none */
 		return (pte_t *)pud;
-	if (!pud_present(*pud))
+	if (!pud_present(pudp_get(pud)))
 		return NULL;
 	/* must have a valid entry and size to go further */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba0fb1b6a5a8e..059eb78480f5e 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -72,7 +72,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	}
 
 	spin_lock(&init_mm.page_table_lock);
-	if (likely(pmd_leaf(*pmd))) {
+	if (likely(pmd_leaf(pmdp_get(pmd)))) {
 		/*
 		 * Higher order allocations from buddy allocator must be able to
 		 * be treated as indepdenent small pages (as they can be freed
@@ -106,7 +106,7 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
 		walk->action = ACTION_CONTINUE;
 
 	spin_lock(&init_mm.page_table_lock);
-	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
+	head = pmd_leaf(pmdp_get(pmd)) ? pmd_page(pmdp_get(pmd)) : NULL;
 	/*
 	 * Due to HugeTLB alignment requirements and the vmemmap
 	 * pages being at the start of the hotplugged memory
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 8fce3370c84ea..d1731d732647d 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -121,7 +121,7 @@ static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 			continue;
 		}
 
-		if (pmd_none(*pmd)) {
+		if (pmd_none(pmdp_get(pmd))) {
 			pte_t *p;
 
 			if (slab_is_available())
@@ -160,7 +160,7 @@ static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
 			continue;
 		}
 
-		if (pud_none(*pud)) {
+		if (pud_none(pudp_get(pud))) {
 			pmd_t *p;
 
 			if (slab_is_available()) {
@@ -202,7 +202,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 			continue;
 		}
 
-		if (p4d_none(*p4d)) {
+		if (p4d_none(p4dp_get(p4d))) {
 			pud_t *p;
 
 			if (slab_is_available()) {
@@ -265,7 +265,7 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 			continue;
 		}
 
-		if (pgd_none(*pgd)) {
+		if (pgd_none(pgdp_get(pgd))) {
 			p4d_t *p;
 
 			if (slab_is_available()) {
@@ -294,7 +294,8 @@ static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}
 
-	pte_free_kernel(&init_mm, (pte_t *)page_to_virt(pmd_page(*pmd)));
+	pte_free_kernel(&init_mm,
+			(pte_t *)page_to_virt(pmd_page(pmdp_get(pmd))));
 	pmd_clear(pmd);
 }
 
@@ -305,11 +306,11 @@ static void kasan_free_pmd(pmd_t *pmd_start, pud_t *pud)
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		pmd = pmd_start + i;
-		if (!pmd_none(*pmd))
+		if (!pmd_none(pmdp_get(pmd)))
 			return;
 	}
 
-	pmd_free(&init_mm, (pmd_t *)page_to_virt(pud_page(*pud)));
+	pmd_free(&init_mm, (pmd_t *)page_to_virt(pud_page(pudp_get(pud))));
 	pud_clear(pud);
 }
 
@@ -320,11 +321,11 @@ static void kasan_free_pud(pud_t *pud_start, p4d_t *p4d)
 
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		pud = pud_start + i;
-		if (!pud_none(*pud))
+		if (!pud_none(pudp_get(pud)))
 			return;
 	}
 
-	pud_free(&init_mm, (pud_t *)page_to_virt(p4d_page(*p4d)));
+	pud_free(&init_mm, (pud_t *)page_to_virt(p4d_page(p4dp_get(p4d))));
 	p4d_clear(p4d);
 }
 
@@ -335,11 +336,11 @@ static void kasan_free_p4d(p4d_t *p4d_start, pgd_t *pgd)
 
 	for (i = 0; i < PTRS_PER_P4D; i++) {
 		p4d = p4d_start + i;
-		if (!p4d_none(*p4d))
+		if (!p4d_none(p4dp_get(p4d)))
 			return;
 	}
 
-	p4d_free(&init_mm, (p4d_t *)page_to_virt(pgd_page(*pgd)));
+	p4d_free(&init_mm, (p4d_t *)page_to_virt(pgd_page(pgdp_get(pgd))));
 	pgd_clear(pgd);
 }
 
@@ -375,10 +376,10 @@ static void kasan_remove_pmd_table(pmd_t *pmd, unsigned long addr,
 
 		next = pmd_addr_end(addr, end);
 
-		if (!pmd_present(*pmd))
+		if (!pmd_present(pmdp_get(pmd)))
 			continue;
 
-		if (kasan_pte_table(*pmd)) {
+		if (kasan_pte_table(pmdp_get(pmd))) {
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				pmd_clear(pmd);
@@ -401,10 +402,10 @@ static void kasan_remove_pud_table(pud_t *pud, unsigned long addr,
 
 		next = pud_addr_end(addr, end);
 
-		if (!pud_present(*pud))
+		if (!pud_present(pudp_get(pud)))
 			continue;
 
-		if (kasan_pmd_table(*pud)) {
+		if (kasan_pmd_table(pudp_get(pud))) {
 			if (IS_ALIGNED(addr, PUD_SIZE) &&
 			    IS_ALIGNED(next, PUD_SIZE)) {
 				pud_clear(pud);
@@ -428,10 +429,10 @@ static void kasan_remove_p4d_table(p4d_t *p4d, unsigned long addr,
 
 		next = p4d_addr_end(addr, end);
 
-		if (!p4d_present(*p4d))
+		if (!p4d_present(p4dp_get(p4d)))
 			continue;
 
-		if (kasan_pud_table(*p4d)) {
+		if (kasan_pud_table(p4dp_get(p4d))) {
 			if (IS_ALIGNED(addr, P4D_SIZE) &&
 			    IS_ALIGNED(next, P4D_SIZE)) {
 				p4d_clear(p4d);
@@ -462,10 +463,10 @@ void kasan_remove_zero_shadow(void *start, unsigned long size)
 		next = pgd_addr_end(addr, end);
 
 		pgd = pgd_offset_k(addr);
-		if (!pgd_present(*pgd))
+		if (!pgd_present(pgdp_get(pgd)))
 			continue;
 
-		if (kasan_p4d_table(*pgd)) {
+		if (kasan_p4d_table(pgdp_get(pgd))) {
 			if (IS_ALIGNED(addr, PGDIR_SIZE) &&
 			    IS_ALIGNED(next, PGDIR_SIZE)) {
 				pgd_clear(pgd);
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 11d472a5c4e8d..feb8857c7703c 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -191,20 +191,20 @@ static bool shadow_mapped(unsigned long addr)
 	pmd_t *pmd;
 	pte_t *pte;
 
-	if (pgd_none(*pgd))
+	if (pgd_none(pgdp_get(pgd)))
 		return false;
 	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d))
+	if (p4d_none(p4dp_get(p4d)))
 		return false;
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+	if (pud_none(pudp_get(pud)))
 		return false;
-	if (pud_leaf(*pud))
+	if (pud_leaf(pudp_get(pud)))
 		return true;
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdp_get(pmd)))
 		return false;
-	if (pmd_leaf(*pmd))
+	if (pmd_leaf(pmdp_get(pmd)))
 		return true;
 	pte = pte_offset_kernel(pmd, addr);
 	return !pte_none(ptep_get(pte));
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b486c1d19b2dd..acc620158696e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1210,7 +1210,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		if (pte)
 			pte_unmap(pte);
 		spin_lock(pmd_ptl);
-		BUG_ON(!pmd_none(*pmd));
+		BUG_ON(!pmd_none(pmdp_get(pmd)));
 		/*
 		 * We can only use set_pmd_at when establishing
 		 * hugepmds and never for establishing regular pmds that
@@ -1247,7 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
+	BUG_ON(!pmd_none(pmdp_get(pmd)));
 	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121cc..eb28944993aee 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1327,7 +1327,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 
 		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte = entry;
+	set_pte(orig_pte, entry);
 	err = 0;
 
 out_unlock:
diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c53..ec040595276aa 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -377,7 +377,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 					!can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
+	if (pmd_trans_huge(pmdp_get(pmd))) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
 
@@ -386,7 +386,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (!ptl)
 			return 0;
 
-		orig_pmd = *pmd;
+		orig_pmd = pmdp_get(pmd);
 		if (is_huge_zero_pmd(orig_pmd))
 			goto huge_unlock;
 
@@ -668,7 +668,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(pmdp_get(pmd)))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
@@ -1116,7 +1116,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep = make_pte_marker(PTE_MARKER_GUARD);
+	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
 	(*nr_pages)++;
 
 	return 0;
diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index c193de6cb23a1..737c407f40812 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	/* Do not split a huge pud */
 	if (pud_trans_huge(pudval)) {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index df6ee59527ddf..913d25f3f432e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -411,20 +411,20 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
 
 	VM_BUG_ON_VMA(address == -EFAULT, vma);
 	pgd = pgd_offset(vma->vm_mm, address);
-	if (!pgd_present(*pgd))
+	if (!pgd_present(pgdp_get(pgd)))
 		return 0;
 	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(*p4d))
+	if (!p4d_present(p4dp_get(p4d)))
 		return 0;
 	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
+	if (!pud_present(pudp_get(pud)))
 		return 0;
-	if (pud_trans_huge(*pud))
+	if (pud_trans_huge(pudp_get(pud)))
 		return PUD_SHIFT;
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	if (!pmd_present(pmdp_get(pmd)))
 		return 0;
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(pmdp_get(pmd)))
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -777,7 +777,7 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
 static int check_hwpoisoned_pmd_entry(pmd_t *pmdp, unsigned long addr,
 				      struct hwpoison_walk *hwp)
 {
-	pmd_t pmd = *pmdp;
+	pmd_t pmd = pmdp_get(pmdp);
 	unsigned long pfn;
 	unsigned long hwpoison_vaddr;
 
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b718471..24cc417a59a32 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -188,7 +188,7 @@ void mm_trace_rss_stat(struct mm_struct *mm, int member)
 static void free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
 			   unsigned long addr)
 {
-	pgtable_t token = pmd_pgtable(*pmd);
+	pgtable_t token = pmd_pgtable(pmdp_get(pmd));
 	pmd_clear(pmd);
 	pte_free_tlb(tlb, token, addr);
 	mm_dec_nr_ptes(tlb->mm);
@@ -425,7 +425,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte)
 {
 	spinlock_t *ptl = pmd_lock(mm, pmd);
 
-	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
+	if (likely(pmd_none(pmdp_get(pmd)))) {	/* Has another populated it ? */
 		mm_inc_nr_ptes(mm);
 		/*
 		 * Ensure all pte setup (eg. pte page lock and page clearing) are
@@ -466,7 +466,7 @@ int __pte_alloc_kernel(pmd_t *pmd)
 		return -ENOMEM;
 
 	spin_lock(&init_mm.page_table_lock);
-	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
+	if (likely(pmd_none(pmdp_get(pmd)))) {	/* Has another populated it ? */
 		smp_wmb(); /* See comment in pmd_install() */
 		pmd_populate_kernel(&init_mm, pmd, new);
 		new = NULL;
@@ -535,7 +535,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 
 	pr_alert("BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
 		 current->comm,
-		 (long long)pte_val(pte), (long long)pmd_val(*pmd));
+		 (long long)pte_val(pte), (long long)pmd_val(pmdp_get(pmd)));
 	if (page)
 		dump_page(page, "bad pte");
 	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
@@ -1245,7 +1245,7 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)) {
+		if (is_swap_pmd(pmdp_get(src_pmd)) || pmd_trans_huge(pmdp_get(src_pmd))) {
 			int err;
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
 			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
@@ -1281,7 +1281,7 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	src_pud = pud_offset(src_p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
-		if (pud_trans_huge(*src_pud)) {
+		if (pud_trans_huge(pudp_get(src_pud))) {
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
@@ -1792,7 +1792,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)) {
+		if (is_swap_pmd(pmdp_get(pmd)) || pmd_trans_huge(pmdp_get(pmd))) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				__split_huge_pmd(vma, pmd, addr, false);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
@@ -1802,7 +1802,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			/* fall through */
 		} else if (details && details->single_folio &&
 			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
+			   next - addr == HPAGE_PMD_SIZE && pmd_none(pmdp_get(pmd))) {
 			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
 			/*
 			 * Take and drop THP pmd lock so that we cannot return
@@ -1811,7 +1811,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			 */
 			spin_unlock(ptl);
 		}
-		if (pmd_none(*pmd)) {
+		if (pmd_none(pmdp_get(pmd))) {
 			addr = next;
 			continue;
 		}
@@ -1834,7 +1834,7 @@ static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
 	pud = pud_offset(p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
-		if (pud_trans_huge(*pud)) {
+		if (pud_trans_huge(pudp_get(pud))) {
 			if (next - addr != HPAGE_PUD_SIZE) {
 				mmap_assert_locked(tlb->mm);
 				split_huge_pud(vma, pud, addr);
@@ -2082,7 +2082,7 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		return NULL;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
+	VM_BUG_ON(pmd_trans_huge(pmdp_get(pmd)));
 	return pmd;
 }
 
@@ -2717,7 +2717,7 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
-	VM_BUG_ON(pmd_trans_huge(*pmd));
+	VM_BUG_ON(pmd_trans_huge(pmdp_get(pmd)));
 	do {
 		next = pmd_addr_end(addr, end);
 		err = remap_pte_range(mm, pmd, addr, next,
@@ -3036,7 +3036,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 	unsigned long next;
 	int err = 0;
 
-	BUG_ON(pud_leaf(*pud));
+	BUG_ON(pud_leaf(pudp_get(pud)));
 
 	if (create) {
 		pmd = pmd_alloc_track(mm, pud, addr, mask);
@@ -3047,11 +3047,11 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 	}
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) && !create)
+		if (pmd_none(pmdp_get(pmd)) && !create)
 			continue;
-		if (WARN_ON_ONCE(pmd_leaf(*pmd)))
+		if (WARN_ON_ONCE(pmd_leaf(pmdp_get(pmd))))
 			return -EINVAL;
-		if (!pmd_none(*pmd) && WARN_ON_ONCE(pmd_bad(*pmd))) {
+		if (!pmd_none(pmdp_get(pmd)) && WARN_ON_ONCE(pmd_bad(pmdp_get(pmd)))) {
 			if (!create)
 				continue;
 			pmd_clear_bad(pmd);
@@ -3083,11 +3083,11 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	}
 	do {
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) && !create)
+		if (pud_none(pudp_get(pud)) && !create)
 			continue;
-		if (WARN_ON_ONCE(pud_leaf(*pud)))
+		if (WARN_ON_ONCE(pud_leaf(pudp_get(pud))))
 			return -EINVAL;
-		if (!pud_none(*pud) && WARN_ON_ONCE(pud_bad(*pud))) {
+		if (!pud_none(pudp_get(pud)) && WARN_ON_ONCE(pud_bad(pudp_get(pud)))) {
 			if (!create)
 				continue;
 			pud_clear_bad(pud);
@@ -3119,11 +3119,11 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	}
 	do {
 		next = p4d_addr_end(addr, end);
-		if (p4d_none(*p4d) && !create)
+		if (p4d_none(p4dp_get(p4d)) && !create)
 			continue;
-		if (WARN_ON_ONCE(p4d_leaf(*p4d)))
+		if (WARN_ON_ONCE(p4d_leaf(p4dp_get(p4d))))
 			return -EINVAL;
-		if (!p4d_none(*p4d) && WARN_ON_ONCE(p4d_bad(*p4d))) {
+		if (!p4d_none(p4dp_get(p4d)) && WARN_ON_ONCE(p4d_bad(p4dp_get(p4d)))) {
 			if (!create)
 				continue;
 			p4d_clear_bad(p4d);
@@ -3153,13 +3153,13 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		if (pgd_none(*pgd) && !create)
+		if (pgd_none(pgdp_get(pgd)) && !create)
 			continue;
-		if (WARN_ON_ONCE(pgd_leaf(*pgd))) {
+		if (WARN_ON_ONCE(pgd_leaf(pgdp_get(pgd)))) {
 			err = -EINVAL;
 			break;
 		}
-		if (!pgd_none(*pgd) && WARN_ON_ONCE(pgd_bad(*pgd))) {
+		if (!pgd_none(pgdp_get(pgd)) && WARN_ON_ONCE(pgd_bad(pgdp_get(pgd)))) {
 			if (!create)
 				continue;
 			pgd_clear_bad(pgd);
@@ -5143,7 +5143,7 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	 *				unlock_page(B)
 	 *				# flush A, B to clear the writeback
 	 */
-	if (pmd_none(*vmf->pmd) && !vmf->prealloc_pte) {
+	if (pmd_none(pmdp_get(vmf->pmd)) && !vmf->prealloc_pte) {
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
@@ -5236,7 +5236,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_none(*vmf->pmd)))
+	if (unlikely(!pmd_none(pmdp_get(vmf->pmd))))
 		goto out;
 
 	flush_icache_pages(vma, page, HPAGE_PMD_NR);
@@ -5371,7 +5371,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
-	if (pmd_none(*vmf->pmd)) {
+	if (pmd_none(pmdp_get(vmf->pmd))) {
 		if (folio_test_pmd_mappable(folio)) {
 			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
@@ -5521,7 +5521,7 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
 	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
 		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
 
-	if (pmd_none(*vmf->pmd)) {
+	if (pmd_none(pmdp_get(vmf->pmd))) {
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
@@ -6009,7 +6009,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 {
 	pte_t entry;
 
-	if (unlikely(pmd_none(*vmf->pmd))) {
+	if (unlikely(pmd_none(pmdp_get(vmf->pmd)))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
 		 * want to allocate huge page, and if we expose page table
@@ -6125,14 +6125,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
 retry_pud:
-	if (pud_none(*vmf.pud) &&
+	if (pud_none(pudp_get(vmf.pud)) &&
 	    thp_vma_allowable_order(vma, vm_flags,
 				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pud_t orig_pud = *vmf.pud;
+		pud_t orig_pud = pudp_get(vmf.pud);
 
 		barrier();
 		if (pud_trans_huge(orig_pud)) {
@@ -6160,7 +6160,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
+	if (pmd_none(pmdp_get(vmf.pmd)) &&
 	    thp_vma_allowable_order(vma, vm_flags,
 				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
@@ -6405,7 +6405,7 @@ int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
 		return -ENOMEM;
 
 	spin_lock(&mm->page_table_lock);
-	if (pgd_present(*pgd)) {	/* Another has populated it */
+	if (pgd_present(pgdp_get(pgd))) {	/* Another has populated it */
 		p4d_free(mm, new);
 	} else {
 		smp_wmb(); /* See comment in pmd_install() */
@@ -6428,7 +6428,7 @@ int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address)
 		return -ENOMEM;
 
 	spin_lock(&mm->page_table_lock);
-	if (!p4d_present(*p4d)) {
+	if (!p4d_present(p4dp_get(p4d))) {
 		mm_inc_nr_puds(mm);
 		smp_wmb(); /* See comment in pmd_install() */
 		p4d_populate(mm, p4d, new);
@@ -6452,7 +6452,7 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 		return -ENOMEM;
 
 	ptl = pud_lock(mm, pud);
-	if (!pud_present(*pud)) {
+	if (!pud_present(pudp_get(pud))) {
 		mm_inc_nr_pmds(mm);
 		smp_wmb(); /* See comment in pmd_install() */
 		pud_populate(mm, pud, new);
@@ -6545,16 +6545,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 		goto out;
 retry:
 	pgdp = pgd_offset(mm, address);
-	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
+	if (pgd_none(pgdp_get(pgdp)) || unlikely(pgd_bad(pgdp_get(pgdp))))
 		goto out;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
 		goto out;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto out;
 	if (pud_leaf(pud)) {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c3..8eef680d0f0ed 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -645,11 +645,11 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 
-	if (unlikely(is_pmd_migration_entry(*pmd))) {
+	if (unlikely(is_pmd_migration_entry(pmdp_get(pmd)))) {
 		qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
+	folio = pmd_folio(pmdp_get(pmd));
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
diff --git a/mm/migrate.c b/mm/migrate.c
index 9e5ef39ce73af..bcd12fba855fb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -543,9 +543,9 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
-	if (!is_pmd_migration_entry(*pmd))
+	if (!is_pmd_migration_entry(pmdp_get(pmd)))
 		goto unlock;
-	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), ptl);
+	migration_entry_wait_on_locked(pmd_to_swp_entry(pmdp_get(pmd)), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index e05e14d6eacdb..7628fd6190e6e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -69,19 +69,19 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	pte_t *ptep;
 
 again:
-	if (pmd_none(*pmdp))
+	if (pmd_none(pmdp_get(pmdp)))
 		return migrate_vma_collect_hole(start, end, -1, walk);
 
-	if (pmd_trans_huge(*pmdp)) {
+	if (pmd_trans_huge(pmdp_get(pmdp))) {
 		struct folio *folio;
 
 		ptl = pmd_lock(mm, pmdp);
-		if (unlikely(!pmd_trans_huge(*pmdp))) {
+		if (unlikely(!pmd_trans_huge(pmdp_get(pmdp)))) {
 			spin_unlock(ptl);
 			goto again;
 		}
 
-		folio = pmd_folio(*pmdp);
+		folio = pmd_folio(pmdp_get(pmdp));
 		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
@@ -615,7 +615,7 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	pmdp = pmd_alloc(mm, pudp, addr);
 	if (!pmdp)
 		goto abort;
-	if (pmd_trans_huge(*pmdp))
+	if (pmd_trans_huge(pmdp_get(pmdp)))
 		goto abort;
 	if (pte_alloc(mm, pmdp))
 		goto abort;
diff --git a/mm/mlock.c b/mm/mlock.c
index bb0776f5ef7ca..c55ab38656d07 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -361,11 +361,11 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		if (!pmd_present(*pmd))
+		if (!pmd_present(pmdp_get(pmd)))
 			goto out;
-		if (is_huge_zero_pmd(*pmd))
+		if (is_huge_zero_pmd(pmdp_get(pmd)))
 			goto out;
-		folio = pmd_folio(*pmd);
+		folio = pmd_folio(pmdp_get(pmd));
 		if (folio_is_zone_device(folio))
 			goto out;
 		if (vma->vm_flags & VM_LOCKED)
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b489858341..912a5847a4f36 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -530,7 +530,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 			break;
 		}
 
-		if (pmd_none(*pmd))
+		if (pmd_none(pmdp_get(pmd)))
 			goto next;
 
 		_pmd = pmdp_get_lockless(pmd);
@@ -599,7 +599,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			break;
 		}
 
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 35de0a7b910e0..b90374064941a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -103,7 +103,7 @@ static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
 		return NULL;
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdp_get(pmd)))
 		return NULL;
 
 	return pmd;
@@ -135,7 +135,7 @@ static pmd_t *alloc_new_pmd(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		return NULL;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
+	VM_BUG_ON(pmd_trans_huge(pmdp_get(pmd)));
 
 	return pmd;
 }
@@ -260,7 +260,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 
 	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
 		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
+		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
 
 		nr_ptes = 1;
 		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
@@ -379,7 +379,7 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 	 * One alternative might be to just unmap the target pmd at
 	 * this point, and verify that it really is empty. We'll see.
 	 */
-	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
+	if (WARN_ON_ONCE(!pmd_none(pmdp_get(new_pmd))))
 		return false;
 
 	/*
@@ -391,7 +391,7 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	pmd = *old_pmd;
+	pmd = pmdp_get(old_pmd);
 
 	/* Racing with collapse? */
 	if (unlikely(!pmd_present(pmd) || pmd_leaf(pmd)))
@@ -400,7 +400,7 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 	pmd_clear(old_pmd);
 	res = true;
 
-	VM_BUG_ON(!pmd_none(*new_pmd));
+	VM_BUG_ON(!pmd_none(pmdp_get(new_pmd)));
 
 	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 	flush_tlb_range(vma, pmc->old_addr, pmc->old_addr + PMD_SIZE);
@@ -436,7 +436,7 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
 	 */
-	if (WARN_ON_ONCE(!pud_none(*new_pud)))
+	if (WARN_ON_ONCE(!pud_none(pudp_get(new_pud))))
 		return false;
 
 	/*
@@ -449,10 +449,10 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
+	pud = pudp_get(old_pud);
 	pud_clear(old_pud);
 
-	VM_BUG_ON(!pud_none(*new_pud));
+	VM_BUG_ON(!pud_none(pudp_get(new_pud)));
 
 	pud_populate(mm, new_pud, pud_pgtable(pud));
 	flush_tlb_range(vma, pmc->old_addr, pmc->old_addr + PUD_SIZE);
@@ -483,7 +483,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
 	 */
-	if (WARN_ON_ONCE(!pud_none(*new_pud)))
+	if (WARN_ON_ONCE(!pud_none(pudp_get(new_pud))))
 		return false;
 
 	/*
@@ -496,10 +496,10 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
+	pud = pudp_get(old_pud);
 	pud_clear(old_pud);
 
-	VM_BUG_ON(!pud_none(*new_pud));
+	VM_BUG_ON(!pud_none(pudp_get(new_pud)));
 
 	/* Set the new pud */
 	/* mark soft_ditry when we add pud level soft dirty support */
@@ -828,7 +828,7 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 		new_pud = alloc_new_pud(mm, pmc->new_addr);
 		if (!new_pud)
 			break;
-		if (pud_trans_huge(*old_pud)) {
+		if (pud_trans_huge(pudp_get(old_pud))) {
 			if (extent == HPAGE_PUD_SIZE) {
 				move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud);
 				/* We ignore and continue on error? */
@@ -847,7 +847,7 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 		if (!new_pmd)
 			break;
 again:
-		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {
+		if (is_swap_pmd(pmdp_get(old_pmd)) || pmd_trans_huge(pmdp_get(old_pmd))) {
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(pmc, HPAGE_PMD, old_pmd, new_pmd))
 				continue;
@@ -861,7 +861,7 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 			if (move_pgt_entry(pmc, NORMAL_PMD, old_pmd, new_pmd))
 				continue;
 		}
-		if (pmd_none(*old_pmd))
+		if (pmd_none(pmdp_get(old_pmd)))
 			continue;
 		if (pte_alloc(pmc->new->vm_mm, new_pmd))
 			break;
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 4eeca782b8887..31f4c39d20ef9 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -230,7 +230,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, pmdp_get(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
@@ -246,7 +246,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
 		return;
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pud_clear(mm, *(pudp + i));
+		__page_table_check_pud_clear(mm, pudp_get((pudp + i)));
 	if (pud_user_accessible_page(pud))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d25..22a93eee26eb0 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -223,17 +223,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 restart:
 	do {
 		pgd = pgd_offset(mm, pvmw->address);
-		if (!pgd_present(*pgd)) {
+		if (!pgd_present(pgdp_get(pgd))) {
 			step_forward(pvmw, PGDIR_SIZE);
 			continue;
 		}
 		p4d = p4d_offset(pgd, pvmw->address);
-		if (!p4d_present(*p4d)) {
+		if (!p4d_present(p4dp_get(p4d))) {
 			step_forward(pvmw, P4D_SIZE);
 			continue;
 		}
 		pud = pud_offset(p4d, pvmw->address);
-		if (!pud_present(*pud)) {
+		if (!pud_present(pudp_get(pud))) {
 			step_forward(pvmw, PUD_SIZE);
 			continue;
 		}
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 648038247a8d2..a4e225da18983 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -109,7 +109,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd)) {
+		if (pmd_none(pmdp_get(pmd))) {
 			if (has_install)
 				err = __pte_alloc(walk->mm, pmd);
 			else if (ops->pte_hole)
@@ -143,13 +143,13 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			 * We are ONLY installing, so avoid unnecessarily
 			 * splitting a present huge page.
 			 */
-			if (pmd_present(*pmd) && pmd_trans_huge(*pmd))
+			if (pmd_present(pmdp_get(pmd)) && pmd_trans_huge(pmdp_get(pmd)))
 				continue;
 		}
 
 		if (walk->vma)
 			split_huge_pmd(walk->vma, pmd, addr);
-		else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		else if (pmd_leaf(pmdp_get(pmd)) || !pmd_present(pmdp_get(pmd)))
 			continue; /* Nothing to do. */
 
 		err = walk_pte_range(pmd, addr, next, walk);
@@ -179,7 +179,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 	do {
  again:
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud)) {
+		if (pud_none(pudp_get(pud))) {
 			if (has_install)
 				err = __pmd_alloc(walk->mm, pud, addr);
 			else if (ops->pte_hole)
@@ -209,16 +209,16 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 			 * We are ONLY installing, so avoid unnecessarily
 			 * splitting a present huge page.
 			 */
-			if (pud_present(*pud) && pud_trans_huge(*pud))
+			if (pud_present(pudp_get(pud)) && pud_trans_huge(pudp_get(pud)))
 				continue;
 		}
 
 		if (walk->vma)
 			split_huge_pud(walk->vma, pud, addr);
-		else if (pud_leaf(*pud) || !pud_present(*pud))
+		else if (pud_leaf(pudp_get(pud)) || !pud_present(pudp_get(pud)))
 			continue; /* Nothing to do. */
 
-		if (pud_none(*pud))
+		if (pud_none(pudp_get(pud)))
 			goto again;
 
 		err = walk_pmd_range(pud, addr, next, walk);
diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e1..1652beb289171 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3136,25 +3136,25 @@ void __init __weak pcpu_populate_pte(unsigned long addr)
 	pud_t *pud;
 	pmd_t *pmd;
 
-	if (pgd_none(*pgd)) {
+	if (pgd_none(pgdp_get(pgd))) {
 		p4d = memblock_alloc_or_panic(P4D_TABLE_SIZE, P4D_TABLE_SIZE);
 		pgd_populate_kernel(addr, pgd, p4d);
 	}
 
 	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d)) {
+	if (p4d_none(p4dp_get(p4d))) {
 		pud = memblock_alloc_or_panic(PUD_TABLE_SIZE, PUD_TABLE_SIZE);
 		p4d_populate_kernel(addr, p4d, pud);
 	}
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud)) {
+	if (pud_none(pudp_get(pud))) {
 		pmd = memblock_alloc_or_panic(PMD_TABLE_SIZE, PMD_TABLE_SIZE);
 		pud_populate(&init_mm, pud, pmd);
 	}
 
 	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(pmdp_get(pmd))) {
 		pte_t *new;
 
 		new = memblock_alloc_or_panic(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
diff --git a/mm/pgalloc-track.h b/mm/pgalloc-track.h
index e9e879de8649b..c5bb948416f0c 100644
--- a/mm/pgalloc-track.h
+++ b/mm/pgalloc-track.h
@@ -7,7 +7,7 @@ static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long address,
 				     pgtbl_mod_mask *mod_mask)
 {
-	if (unlikely(pgd_none(*pgd))) {
+	if (unlikely(pgd_none(pgdp_get(pgd)))) {
 		if (__p4d_alloc(mm, pgd, address))
 			return NULL;
 		*mod_mask |= PGTBL_PGD_MODIFIED;
@@ -20,7 +20,7 @@ static inline pud_t *pud_alloc_track(struct mm_struct *mm, p4d_t *p4d,
 				     unsigned long address,
 				     pgtbl_mod_mask *mod_mask)
 {
-	if (unlikely(p4d_none(*p4d))) {
+	if (unlikely(p4d_none(p4dp_get(p4d)))) {
 		if (__pud_alloc(mm, p4d, address))
 			return NULL;
 		*mod_mask |= PGTBL_P4D_MODIFIED;
@@ -33,7 +33,7 @@ static inline pmd_t *pmd_alloc_track(struct mm_struct *mm, pud_t *pud,
 				     unsigned long address,
 				     pgtbl_mod_mask *mod_mask)
 {
-	if (unlikely(pud_none(*pud))) {
+	if (unlikely(pud_none(pudp_get(pud)))) {
 		if (__pmd_alloc(mm, pud, address))
 			return NULL;
 		*mod_mask |= PGTBL_PUD_MODIFIED;
@@ -44,7 +44,7 @@ static inline pmd_t *pmd_alloc_track(struct mm_struct *mm, pud_t *pud,
 #endif /* CONFIG_MMU */
 
 #define pte_alloc_kernel_track(pmd, address, mask)			\
-	((unlikely(pmd_none(*(pmd))) &&					\
+	((unlikely(pmd_none(pmdp_get(pmd))) &&				\
 	  (__pte_alloc_kernel(pmd) || ({*(mask)|=PGTBL_PMD_MODIFIED;0;})))?\
 		NULL: pte_offset_kernel(pmd, address))
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071e..63a573306bfa2 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -24,14 +24,14 @@
 
 void pgd_clear_bad(pgd_t *pgd)
 {
-	pgd_ERROR(*pgd);
+	pgd_ERROR(pgdp_get(pgd));
 	pgd_clear(pgd);
 }
 
 #ifndef __PAGETABLE_P4D_FOLDED
 void p4d_clear_bad(p4d_t *p4d)
 {
-	p4d_ERROR(*p4d);
+	p4d_ERROR(p4dp_get(p4d));
 	p4d_clear(p4d);
 }
 #endif
@@ -39,7 +39,7 @@ void p4d_clear_bad(p4d_t *p4d)
 #ifndef __PAGETABLE_PUD_FOLDED
 void pud_clear_bad(pud_t *pud)
 {
-	pud_ERROR(*pud);
+	pud_ERROR(pudp_get(pud));
 	pud_clear(pud);
 }
 #endif
@@ -51,7 +51,7 @@ void pud_clear_bad(pud_t *pud)
  */
 void pmd_clear_bad(pmd_t *pmd)
 {
-	pmd_ERROR(*pmd);
+	pmd_ERROR(pmdp_get(pmd));
 	pmd_clear(pmd);
 }
 
@@ -110,7 +110,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
 			  unsigned long address, pmd_t *pmdp,
 			  pmd_t entry, int dirty)
 {
-	int changed = !pmd_same(*pmdp, entry);
+	int changed = !pmd_same(pmdp_get(pmdp), entry);
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	if (changed) {
 		set_pmd_at(vma->vm_mm, address, pmdp, entry);
@@ -139,7 +139,7 @@ pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(pmd_present(*pmdp) && !pmd_trans_huge(*pmdp));
+	VM_BUG_ON(pmd_present(pmdp_get(pmdp)) && !pmd_trans_huge(pmdp_get(pmdp)));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
@@ -152,7 +152,7 @@ pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 	pud_t pud;
 
 	VM_BUG_ON(address & ~HPAGE_PUD_MASK);
-	VM_BUG_ON(!pud_trans_huge(*pudp));
+	VM_BUG_ON(!pud_trans_huge(pudp_get(pudp)));
 	pud = pudp_huge_get_and_clear(vma->vm_mm, address, pudp);
 	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
 	return pud;
@@ -197,8 +197,9 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
-	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
+	VM_WARN_ON_ONCE(!pmd_present(pmdp_get(pmdp)));
+	pmd_t old = pmdp_establish(vma, address, pmdp,
+				   pmd_mkinvalid(pmdp_get(pmdp)));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return old;
 }
@@ -208,7 +209,7 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 			 pmd_t *pmdp)
 {
-	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
+	VM_WARN_ON_ONCE(!pmd_present(pmdp_get(pmdp)));
 	return pmdp_invalidate(vma, address, pmdp);
 }
 #endif
@@ -224,7 +225,7 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 	pmd_t pmd;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(pmd_trans_huge(*pmdp));
+	VM_BUG_ON(pmd_trans_huge(pmdp_get(pmdp)));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 
 	/* collapse entails shooting down ptes not pmd */
diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc29..66fa4763c5209 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -820,15 +820,15 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	pmd_t *pmd = NULL;
 
 	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
+	if (!pgd_present(pgdp_get(pgd)))
 		goto out;
 
 	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(*p4d))
+	if (!p4d_present(p4dp_get(p4d)))
 		goto out;
 
 	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
+	if (!pud_present(pudp_get(pud)))
 		goto out;
 
 	pmd = pmd_offset(pud, address);
@@ -1066,7 +1066,7 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 			pmd_t *pmd = pvmw->pmd;
 			pmd_t entry;
 
-			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
+			if (!pmd_dirty(pmdp_get(pmd)) && !pmd_write(pmdp_get(pmd)))
 				continue;
 
 			flush_cache_range(vma, address,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dbd8daccade28..be065c57611d7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -198,7 +198,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd)) {
+	if (pmd_none(pmdp_get(pmd))) {
 		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
@@ -211,7 +211,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
-	if (pud_none(*pud)) {
+	if (pud_none(pudp_get(pud))) {
 		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
@@ -224,7 +224,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d)) {
+	if (p4d_none(p4dp_get(p4d))) {
 		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
@@ -237,7 +237,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
-	if (pgd_none(*pgd)) {
+	if (pgd_none(pgdp_get(pgd))) {
 		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
@@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(READ_ONCE(*pmd))) {
+		if (pmd_none(pmdp_get(pmd))) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index aefdf3a812a18..9be7727cd26dd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1236,8 +1236,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	}
 
 	/* Sanity checks before the operation */
-	if (pmd_none(*dst_pmd) || pmd_none(*src_pmd) ||
-	    pmd_trans_huge(*dst_pmd) || pmd_trans_huge(*src_pmd)) {
+	if (pmd_none(pmdp_get(dst_pmd)) || pmd_none(pmdp_get(src_pmd)) ||
+	    pmd_trans_huge(pmdp_get(dst_pmd)) || pmd_trans_huge(pmdp_get(src_pmd))) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1827,8 +1827,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
 				/* Can be a migration entry */
-				if (pmd_present(*src_pmd)) {
-					struct folio *folio = pmd_folio(*src_pmd);
+				if (pmd_present(pmdp_get(src_pmd))) {
+					struct folio *folio = pmd_folio(pmdp_get(src_pmd));
 
 					if (!is_huge_zero_folio(folio) &&
 					    !PageAnonExclusive(&folio->page)) {
@@ -1849,7 +1849,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
-			if (pmd_none(*src_pmd)) {
+			if (pmd_none(pmdp_get(src_pmd))) {
 				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
 					err = -ENOENT;
 					break;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2a..3c726f7b59860 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -155,7 +155,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
+	if (pmd_present(pmdp_get(pmd)) && !pmd_free_pte_page(pmd, addr))
 		return 0;
 
 	return pmd_set_huge(pmd, phys_addr, prot);
@@ -205,7 +205,7 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
+	if (pud_present(pudp_get(pud)) && !pud_free_pmd_page(pud, addr))
 		return 0;
 
 	return pud_set_huge(pud, phys_addr, prot);
@@ -256,7 +256,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
+	if (p4d_present(p4dp_get(p4d)) && !p4d_free_pud_page(p4d, addr))
 		return 0;
 
 	return p4d_set_huge(p4d, phys_addr, prot);
@@ -367,7 +367,8 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		if (size != PAGE_SIZE) {
 			if (WARN_ON(!IS_ALIGNED(addr, size))) {
 				addr = ALIGN_DOWN(addr, size);
-				pte = PTR_ALIGN_DOWN(pte, sizeof(*pte) * (size >> PAGE_SHIFT));
+				pte = PTR_ALIGN_DOWN(pte,
+						     sizeof(ptep_get(pte)) * (size >> PAGE_SHIFT));
 			}
 			ptent = huge_ptep_get_and_clear(&init_mm, addr, pte, size);
 			if (WARN_ON(end - addr < size))
@@ -394,7 +395,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 		next = pmd_addr_end(addr, end);
 
 		cleared = pmd_clear_huge(pmd);
-		if (cleared || pmd_bad(*pmd))
+		if (cleared || pmd_bad(pmdp_get(pmd)))
 			*mask |= PGTBL_PMD_MODIFIED;
 
 		if (cleared) {
@@ -421,7 +422,7 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		next = pud_addr_end(addr, end);
 
 		cleared = pud_clear_huge(pud);
-		if (cleared || pud_bad(*pud))
+		if (cleared || pud_bad(pudp_get(pud)))
 			*mask |= PGTBL_PUD_MODIFIED;
 
 		if (cleared) {
@@ -445,7 +446,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 		next = p4d_addr_end(addr, end);
 
 		p4d_clear_huge(p4d);
-		if (p4d_bad(*p4d))
+		if (p4d_bad(p4dp_get(p4d)))
 			*mask |= PGTBL_P4D_MODIFIED;
 
 		if (p4d_none_or_clear_bad(p4d))
@@ -477,7 +478,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		if (pgd_bad(*pgd))
+		if (pgd_bad(pgdp_get(pgd)))
 			mask |= PGTBL_PGD_MODIFIED;
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
@@ -622,7 +623,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		if (pgd_bad(*pgd))
+		if (pgd_bad(pgdp_get(pgd)))
 			mask |= PGTBL_PGD_MODIFIED;
 		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
 		if (err)
@@ -792,35 +793,35 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	 */
 	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
 
-	if (pgd_none(*pgd))
+	if (pgd_none(pgdp_get(pgd)))
 		return NULL;
-	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
+	if (WARN_ON_ONCE(pgd_leaf(pgdp_get(pgd))))
 		return NULL; /* XXX: no allowance for huge pgd */
-	if (WARN_ON_ONCE(pgd_bad(*pgd)))
+	if (WARN_ON_ONCE(pgd_bad(pgdp_get(pgd))))
 		return NULL;
 
 	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d))
+	if (p4d_none(p4dp_get(p4d)))
 		return NULL;
-	if (p4d_leaf(*p4d))
-		return p4d_page(*p4d) + ((addr & ~P4D_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(p4d_bad(*p4d)))
+	if (p4d_leaf(p4dp_get(p4d)))
+		return p4d_page(p4dp_get(p4d)) + ((addr & ~P4D_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(p4d_bad(p4dp_get(p4d))))
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+	if (pud_none(pudp_get(pud)))
 		return NULL;
-	if (pud_leaf(*pud))
-		return pud_page(*pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(pud_bad(*pud)))
+	if (pud_leaf(pudp_get(pud)))
+		return pud_page(pudp_get(pud)) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pud_bad(pudp_get(pud))))
 		return NULL;
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdp_get(pmd)))
 		return NULL;
-	if (pmd_leaf(*pmd))
-		return pmd_page(*pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(pmd_bad(*pmd)))
+	if (pmd_leaf(pmdp_get(pmd)))
+		return pmd_page(pmdp_get(pmd)) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pmd_bad(pmdp_get(pmd))))
 		return NULL;
 
 	ptep = pte_offset_kernel(pmd, addr);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 674999999cd06..cfb1280ff1da7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3611,7 +3611,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
 
-	VM_WARN_ON_ONCE(pud_leaf(*pud));
+	VM_WARN_ON_ONCE(pud_leaf(pudp_get(pud)));
 
 	/* try to batch at most 1+MIN_LRU_BATCH+1 entries */
 	if (*first == -1) {
@@ -3641,17 +3641,17 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		if (!pmd_present(pmd[i]))
+		if (!pmd_present(pmdp_get(pmd + i)))
 			goto next;
 
-		if (!pmd_trans_huge(pmd[i])) {
+		if (!pmd_trans_huge(pmdp_get(pmd + i))) {
 			if (!walk->force_scan && should_clear_pmd_young() &&
 			    !mm_has_notifiers(args->mm))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
 
-		pfn = get_pmd_pfn(pmd[i], vma, addr, pgdat);
+		pfn = get_pmd_pfn(pmdp_get(pmd + i), vma, addr, pgdat);
 		if (pfn == -1)
 			goto next;
 
@@ -3669,7 +3669,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = false;
 		}
 
-		if (pmd_dirty(pmd[i]))
+		if (pmd_dirty(pmdp_get(pmd + i)))
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3698,7 +3698,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
-	VM_WARN_ON_ONCE(pud_leaf(*pud));
+	VM_WARN_ON_ONCE(pud_leaf(pudp_get(pud)));
 
 	/*
 	 * Finish an entire PMD in two passes: the first only reaches to PTE
@@ -3767,12 +3767,12 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
 
-	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
+	VM_WARN_ON_ONCE(p4d_leaf(p4dp_get(p4d)));
 
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 
-- 
2.47.2



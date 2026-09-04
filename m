Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8266C624D6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6D516B0088; Thu,  3 Sep 2026 20:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9546B008A; Thu,  3 Sep 2026 20:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC14A6B008C; Thu,  3 Sep 2026 20:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3DC6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:28:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16CA21406B0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:28:41 +0000 (UTC)
X-FDA: 85174194042.27.4F128BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64D3280003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:28:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5TBCL0l;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788481719;
	b=EUN+8ftKCvjk7llyWOjeea3iNDP+rJ1MguXd0To8nZadt4ajlFVarrG5NXz0qcevjBs5aJ
	5O5COjhSgLiIJeJimFyYiamV2dl9ZkVsDSeowF2Y2GbccAUd9GNIJbJgOcFnTIo5zh59oI
	eSIPReLWIyg+eHqgysNzb07Ek0cBZ7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788481719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=166TVcIhx+0QErke7o9FSwWx5qn3nWzpmAkGNjrnyxo=;
	b=RVruWLgq87LaKXSHPnP99FTulzk7KrXOZlC6AMCpMC9wGVtihNzvDXXKK1eqn147wz8Zsk
	IZ/QmeukLT+oLM0uVn+k/Pn1/mRlSqeslzLm88dxopCNZFrndR69WnqgzEUWMshw46qFkS
	Z/xSpT47uqW3J8+G5Pbi5D/frAQKYaY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5TBCL0l;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BBB641837;
	Fri,  4 Sep 2026 00:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7A01F000E9;
	Fri,  4 Sep 2026 00:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481718;
	bh=166TVcIhx+0QErke7o9FSwWx5qn3nWzpmAkGNjrnyxo=;
	h=From:To:Cc:Subject:Date;
	b=a5TBCL0lOqtdWhuMu8eqDhclsqwxPf/1VXkbfpNmnIcjvwjDn80KggTx9+l4jPfIG
	 OJ+2gO/99uTovvA+HLAQNk5LgV3QqxyNxVMSYAF79F1BpUun4xBFzMQfE+3vUmDNY6
	 I9q1gPKx6r5qi8ZelTUBBv7ECk7+bzrm2EzAwzD/JMclfrGieDUZQD2qPXAwtu0iDP
	 4ngSvns5LNd+t3kVnYKkgTOCrR2urpvCBpUW7tIRO5x0g7jHIVcJnQP3p12iifdCwt
	 7cQQjxOOvKQnP0CZVRPR14yV8SW4M8P/hwCJR/FRofKl3gJfW5cRlBaloEThAw0k7K
	 yki2hn2G0y2FQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Gao <zcgao@amazon.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v5] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Thu,  3 Sep 2026 17:28:27 -0700
Message-ID: <20260904002829.116381-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64D3280003
X-Stat-Signature: xrd74fgs9qsi55porzxhkfrdt49yggta
X-HE-Tag: 1788481719-14326
X-HE-Meta: U2FsdGVkX18cepOYcbTj41tCmsALQPVFo1FgxSMUyqRpn61YVc8GDCgZnkhPfui01PD1drYjVLL6tvRtKQRoUoLm023hU9hB5wDz+pK0sdoEiLaxlvi8LKK6D9yT6b25jVWTwuZouizbbyfZuY0RuitHoB3sBZziAJV1NY30hXB+AcsmBDAhUcDfw7GCk5KeJyYLKrc6iC+53Ocx6vxAxPsZUr3q1ogPcosT5CcUilUSyHSb1mO93nCqztIs+dTWiGwhodoGgtjv8x1tLrdXw/fs29gC8CUnUjsFAx90Thqj/tsHbqHyClt7W2qQ7BGaofXK7uRiNk8bVQPW1Bb+MhWRYwdnKlzveMuBQyYq2gYOw1X+XLycWKXg5izYhi5ZlOQtX7LxyVj4OJe6fHZxRsnRpwTbxOgKNP7IMAnafDM4ElV3asG1p0gOWrp2NKKBgJkDylPJSidLaFrTHznxDFKXwiGO/TqfavfdE/wddtzUH1+2/rsUG7sK0nb62uSBIbHIxvFBU3jvaHKoCkF0EJoxV2ckE0G9oZLJw//rqcD+h+AeXotHjHWAdMZbq8BkvL7UQtHPzzrHDt3Go40JbQOjhx5uM77PSQFqjKVmfNTN4zceW7crfvJEDrCvcUJhjRzLmJNhXQY9RSvLmxxamCmjcYbAvVhBdpsahj+viqJ9MDRvLwitSgjYEaiwhwv+Ai6IVwvuOlPHLFLy8LYVzqIOHgUOQ9AsAw+x76+vFG4D4peeV9w0CcNAEeQ7UoKBu4xUR8DXyTkRlKX29XEcTuyYIDUXG8aZentlMZyVuL2jNOK1jP3dsZL9aQr+4MAY452RHo9MHrkjI5+i5HgX2SuLiCsWUYA0by8sSq2CmyIUfsvXOyDPzucl6EzHmi+odgLhg86tv6bqo/3567Okyc4Gm97xWfluK35QovLSpcEKgC/sPhK3w8+XiLeUMRvipye5ISFq/bRo6sy8TVJ
 W72JZecQ
 l/FBGBAsRMPZTj9iUKH/QkNXfsw3NKPthsVvy1gi4L/rgq/Aj8X649wQotOFQTkKziAfirFuZl7IG8aIh1CNi68ucwedgRm3uvx9j3ogHtm1kI6x0dADTyZbLuf5ke3MWdyZ8FEHYob0I7VYemdBYHi0hKBgZvWrplqTN8HL+G2oHJARg/2M6cZoJNVYwwdLf+z7R6hrvnP6Io2xGWJCOpfOeohx85GGOVmi121zOh3O8OCgAPiZz+G8MyEGNxGB5eKYCDeld1Y/aIbOVT32Tzl43DImIqyYKaJ0fP0299l3pNHhW4+OaqtGO0akKMkE6p5VCEgDAHTGxdlqjTXeLlBhLXXe9AXD4BJxdCrGysRKO/mSftCCLVO2XpSTcc3OggzFWuWAUx/hEChs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nathan Gao <zcgao@amazon.com>

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr. damon_va_mkold() passes it into
a page table walk, which hands it to damon_ptep_mkold() as the address of
the page to sample:

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
clearing of the young flag for large folios"), the contpte helper walked
exactly CONT_PTES entries from the aligned-down page table pointer and
used @addr only to pass down to each entry, so an unaligned value was
harmless:

        ptep = contpte_align_down(ptep);
        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
        for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

Now the range to walk is derived from @addr instead: end = addr +
nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
page of a contpte block, the sub-page offset puts end just past the
block boundary, so the round-up lands a whole block further and the
walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
the last block in a page table page, those entries are past the end of
that page, so the walk writes into the page that follows.

Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
DAMON test.

What the overrun does depends on the page that happens to follow the
page table, so there is no single signature. If that page is read-only,
the write faults in the sampling path itself:

  Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
    FSC = 0x0f: level 3 permission fault
    CM = 0, WnR = 1, TnD = 0, TagAccess = 0
  CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
  pc : contpte_test_and_clear_young_ptes+0x70/0xc0
  lr : damon_ptep_mkold+0x1e8/0x1f8
  Call trace:
   contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
   damon_mkold_pmd_entry+0x150/0x170
   walk_pmd_range+0x110/0x2b0
   walk_pud_range+0x10c/0x208
   walk_pgd_range+0x134/0x258
   __walk_page_range+0x98/0x1b0
   walk_page_range_vma_unsafe+0x90/0x148
   walk_page_range_vma+0x28/0x40
   damon_va_walk_page_range+0x114/0x2b8
   damon_va_prepare_access_checks+0xec/0x1a8
   kdamond_fn+0x534/0x770
   kthread+0x128/0x138
   ret_from_fork+0x10/0x20

Otherwise the page is writable, the PTE_AF clearing succeeds silently
and the damage only surfaces later, in whatever happened to own the
page, so the backtrace is unrelated to DAMON and differs between runs.

Pass a page-aligned address to the ptep_test_and_clear_young() call in
damon_ptep_mkold(), which is the only place DAMON can reach
contpte_test_and_clear_young_ptes() from. Nothing else sees the aligned
address, and r->sampling_addr itself is left as is, so the sampling and
region bookkeeping semantics are unchanged.

Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes From v4
- v4: https://lore.kernel.org/20260902031655.84721-1-zcgao@amazon.com
- Collect R-b: from Baolin.
- Rebase to latest mm-new.

V3 -> V4:
- Align only the address that is passed to ptep_test_and_clear_young(),
  rather than @addr for the whole of damon_ptep_mkold(), so the
  mmu_notifier_clear_young() call keeps seeing the sampled address (SJ)

V2 -> V3:
- Move the alignment into damon_ptep_mkold(), instead of aligning in
  damon_va_mkold() and damon_va_young().  The ptep_test_and_clear_young()
  call in damon_ptep_mkold() is DAMON's only path to
  contpte_test_and_clear_young_ptes(), so damon_ptep_mkold() is the
  closest place in DAMON to the function that requires an aligned
  address (SJ)

V1 -> V2:
- Align inside damon_va_mkold() and damon_va_young() rather than aligning
  r->sampling_addr itself, so that sub-page sampling addresses remain
  possible for future non-PTE access check primitives (SJ)
- Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
  unaligned address was harmless before that commit (SJ)
- Describe how the issue was noticed and what it does to the kernel (SJ)

v3: https://lore.kernel.org/all/20260901201001.33271-1-zcgao@amazon.com/
v2: https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/
v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/

 mm/damon/ops-common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 7a2e40bc7baed..7219c608b1952 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -61,7 +61,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	 * device aspects.
 	 */
 	if (likely(pte_present(pteval)))
-		young |= ptep_test_and_clear_young(vma, addr, pte);
+		/*
+		 * Arch implementation of ptep_test_and_clear_young() may
+		 * require aligned @addr
+		 */
+		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
+				pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);

base-commit: 87db3abd2b79ed6ccaaf6d3c25df6adbd8ea3596
-- 
2.47.3


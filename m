Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805C1C9832C
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9A76B008C; Fri, 25 Sep 2026 16:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992056B0092; Fri, 25 Sep 2026 16:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8814B6B0093; Fri, 25 Sep 2026 16:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA5E6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:10:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC435120737
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:10:29 +0000 (UTC)
X-FDA: 85253376978.22.D1CA242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D65C614000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:10:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glJ1oO03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZL+kGVACjhjkTWYbS76jfyltYBtpfCujbpQ6jbpX7A=;
	b=mSx2edOeU4y/cH/ysTMY3wqSnpnZlyvlSugkLwNldJ+ROKV3exe78yfDERxhcudSV9SMep
	vF5/D2QTHcFaaxXUXBKkW0EchZ6ZicvEVTOj4+tH7w8qVJcJmjOwIs8k9tZqHIYOQSMc6B
	wshzCxgfsDYfYVo+0MCNAV/55ZOFXtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glJ1oO03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367027;
	b=q3c4r2Zrld2IZA+VcBEcSMXF/VEW38D7UxMldwTlotd2aAy0XlzW8kjZVbOgHoxKTWy7pN
	jg1Uzd/Vi++nSM42OpAUnoAGcWz11H97K4dgZcSJ9vWmsApvW3A4QRdu7ZZ/y8p2ubKSNg
	XYzLN+qkEn6rgXF+x68uJj6BXkIYumM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03DEE431D5;
	Fri, 25 Sep 2026 20:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4381F00893;
	Fri, 25 Sep 2026 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367026;
	bh=ZZL+kGVACjhjkTWYbS76jfyltYBtpfCujbpQ6jbpX7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=glJ1oO03XaTYx5BUnJ0uxCpIQtEUdWsQp725f4o9J35cE4hItKtr95K4O5iSqoxjh
	 KhnW7NRY2KHVdmcljk6wXCNn+SXEdu8tH3oJeQZY9EGbaT/Y6edK0A5jE5waYvIgcJ
	 L6WbdAgW1V1Rxbp77J7HBZCVIq1Yf6H6NVPya4UATK74M7TnIKeuGrI9/l4vSFKQtq
	 HMN+SX/XwH/ucmTOjV5ylG72vjBVSJ6BIFcPvFoi/PWgrP918+30Z/DY2P1q8OWS21
	 gdguqD0qk6KnupTMiLp73S7P+AsfEgrqv8jLEj/rY7M5sRaSgJ+l7l4mxZGY+emEwd
	 S1Z+vCUxTwMMA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:36 +0100
Subject: [PATCH v5 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-1-31e91065fea4@kernel.org>
References: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
In-Reply-To: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5012; i=ljs@kernel.org;
 h=from:subject:message-id; bh=k+1gLmG1a4EmZBfdZJSsYR9/SRGnTKf86XJLG0Jlsl8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWU71zjv/bzmb8JXz7eUT1s658HDTUbB4XU2dxek/
 TwgcWdzXkcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAuosjI0CrgqRwqa/x8xe92
 XZmyMz8+sW7svn7ryETmbaGaOpestzIyzC5qefxJP3uD2uSXFbvntL+bvHn1jFMvVTXnvND+UqX
 /iBcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: D65C614000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h3aacf4zrap8rsx8du3xpn3nqqdhijwt
X-HE-Tag: 1790367027-702185
X-HE-Meta: U2FsdGVkX18u0M5xVpBWV6jj9GFwTa6p2pHztINfrwFehUU3zsJ9RqQyauAnDC1GdRmW+8tkqoTQ3T8MJx0p3w/KunlX3bi4bX2SwOy2bCgnFsRYdJZJhZgkq36nrBJzRllwTaTo8JE01T5RTERiWhAv0QaplIrpeDGI5wKUnAixd8O33GxRU3xS+BzOtedPRd+k3VNRH/+UVIFJU1R6ChntXveZQoEDyV74Gzg9r+GfdAoAifkdqAsZsulZ4+w1SsWcOnWPmObuGGb5Nhhf3pdv2YfOwmpiA3TtG1VLhpDMigdOqNuNnyF6soRaZHQQszYpY96LIICGOYuHW11+lfzJMSjOVLpsII64/knip6yabyGdewUFaks4K9CKfF/ojEvT3lCmfm3GBTaAMjqEE3/KACjPr4TmotXTM7gpyXInTLk56r37qNF2x/32a+eN1RIDoIe3zehjEQwAheA7QGFlNEJyp19yEjqlQAjNyNheIk2d4K71dJsjAw+ceaofx8IwAks3t77Hb0T1IkBuCeLvidZ4ygXCqjHB0XANtBRt7VJWNeZMSKLrL5VpEPjS5rSevWBJRPm9IWGfvvFJJ9Szltab6hmkVgnYAoIkQaiN2LNkH5IWSqGXwV/yQCoTTyfHj32V5f3pCdlYaIE99T25vmMuYnWfGD9Zap6ToKkvbpzj/pk2dz0+5hCguJ+/o3dMowD/Yt98o6A64M+dGJgektJlIj1q50/7HtV5nJA4/B0WTPLZhxWilDzzk1uRgVL0JotbBp4QN/9oV90/gdBR6S6G7baguUO8zkW6USXbXQITLR4hHi2bbB3FxF5uj4GDBaet+uEeLbWOB/sXoCZJnyiPMdBSIX94VBEJVAW0y7MO+S9E5y2o/IbeoxQOaqusgRne1Dj5bDkYasVogQuUPMySu0yulYuPLxVaa7t995sFWrOKMGwlC0mtWIzA0mwdc/Ms5KvAEsAv82H
 g54mczT5
 dXiqTDPQ4Bhp+bQ06zHnlHn9CH/c2d+5TLdBvDlSHVQEISiRQF2euwYr1B0rBkgICwbWLTYycwNBDMWpD2QNkptassLu1kHyHSXN8BxAkwsOy37VJaXIfNStkvwNQNAF9H/Nr/lvMTtHIy33Nz91sOIpuA993olpWkgmGZiXgbi4NQw5MrNTI+LUg0wrJ//wY9weQMtQg3+kVDG/bWbFr6BZPksn27ulwgXKy8BPpq1YLu3ZSry8Wexu+ESLGTLGxbck0rrqebaRr9o5S+8EqNSPnRNpWQmGOsR+zJw2xz2S9gOvxpYMHUlyT32sWCoVPeqp6fAnlfiQrV9CFwPKuxJ9IlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_huge_page() deposits a PTE page table on PMD collapse in order
that it can be utilised for subsequent split operations, meaning that those
operations do not need to perform an allocation (as they are in a context
where it might be unwise).

However the PTE page table which is deposited is the one which is currently
mapped by the PMD entry that is in the process of being collapsed.

Once deposited, the PTE page table may be used in a split of any other
unrelated PMD entry.

This is currently not an issue as this operation is performed with VMA/mmap
write lock + anon rmap locks held, so ordinary page table walkers will
never accidentally end up walking the wrong thing, and GUP-fast is
protected by an IPI via tlb_remove_table_sync_one().

However, the series to which this commit belongs implements RCU-safe page
table traversal, at which point this becomes problematic.

This can be resolved by using pte_offset_map_lock() which gates on a PTE
PTL and a pmd_same() check, but lockless walks are unsafe as things stand.

Resolve this by simply allocating a new, zeroed, PTE page table to deposit
at the point of collapse.

This path is already costly and an allocation has already been performed
for the huge folio, so this allocation is statistical noise in terms of
performance and memory usage at this point.

With this PTE page table deposited, RCU-free the existing PTE page table
so it is safe for page table walkers to traverse within a grace period.

This also brings this deposit case in line with all other page table
deposit logic which deposit a fresh page table.

Additionally, this was the only place in the kernel that displaced a page
table like this, so eliminating it also helps consistency.

Since khugepaged runs as a kernel thread, do a little dance in
alloc_deposit_pte_table() to correctly charge the allocation.

This is already done for the folio allocation via alloc_charge_folio() but
no such wrapper exists for a page table allocation.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..639029cc4f5e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
+static pgtable_t alloc_deposit_pte_table(struct mm_struct *mm)
+{
+	/*
+	 * khugepaged is run from a kernel thread, so need to manually set the
+	 * correct memcg so the allocation gets charged correctly.
+	 */
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
+	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
+	pgtable_t pgtable;
+
+	pgtable = pte_alloc_one(mm);
+
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
+	return pgtable;
+}
+
 /*
  * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
  * will always return with the lock unlocked, to avoid holding the mmap_lock
@@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
 	pte_t *pte = NULL;
-	pgtable_t pgtable;
+	pgtable_t pgtable = NULL;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	enum scan_result result = SCAN_FAIL;
@@ -1310,6 +1327,14 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		goto out_nolock;
 	}
 
+	if (is_pmd_order(order)) {
+		pgtable = alloc_deposit_pte_table(mm);
+		if (!pgtable) {
+			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+			goto out_nolock;
+		}
+	}
+
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
@@ -1433,8 +1458,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	spin_lock(pmd_ptl);
 	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
-		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		pgtable = NULL;
 		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
 	} else {
 		/*
@@ -1453,6 +1478,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	}
 	spin_unlock(pmd_ptl);
 
+	if (is_pmd_order(order))
+		pte_free_defer(mm, pmd_pgtable(_pmd));
+
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
@@ -1463,6 +1491,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
+	if (pgtable)
+		pte_free(mm, pgtable);
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);

-- 
2.55.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30769C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DCF6B009F; Tue, 22 Sep 2026 11:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206036B00A2; Tue, 22 Sep 2026 11:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B916B00A4; Tue, 22 Sep 2026 11:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2CE76B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:37:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7ACE8A053F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:37:01 +0000 (UTC)
X-FDA: 85241801442.12.F5F1639
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7D2A140006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5OnRqsH;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1kULK2uo5iIlycPGFV3SVU1kRYTeuiXaUNtJjPTvlY=;
	b=0uC6GcNg7ucouRXEtjjWpC7oR6HHDgVIciADbkTG93cKrfOeCAX/fsjryAJWSleTdR5N4+
	/NpElm5Uw1REgn6JupV9ECFSSdibDyxQG7TUouRGElfGk3M40I+Nt0YDZ6t1hNvPXoeHJl
	C5rJriDWRy4UMWX5ji/2HOKamPUFWx8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5OnRqsH;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091419;
	b=3rXZ1EfR5n1fjpvw3Q6Y+QFA8e+6It57YHlTlKeJMqsrf4kt6R36blgS0gsM4CYv6TiYMF
	kF7haA/zMiMOyNOK0Cq2EX8t5/BGazIICtTzrlzwkSno03wz8aYpxJW3jbnL8Fy6Ftp7Hm
	4Cc4cqj6Z5DFhVsdECpaHQ3jz59drqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E44F640DC1;
	Tue, 22 Sep 2026 15:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324F91F00893;
	Tue, 22 Sep 2026 15:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091418;
	bh=J1kULK2uo5iIlycPGFV3SVU1kRYTeuiXaUNtJjPTvlY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O5OnRqsHWVSboGiycATXii3kxCgUoPSM2nTvyWAlnmjffTTXW+gJ0VBID4vvQUgI/
	 O9lywv7inXl6KjGb7/0VlcptxGCYMi4pmk8E1K0Key0xXSKimb8qT2xAQNzcqn3bgc
	 NZ8SfEmhiX7Y6teqyn3WgbVZVXuwQ21QpRixohrxv/tDwY33XXtc8Vonec6u9sD/gt
	 UBZbxXOIRgMuJj27Gvy7eryEkVKiqbSFWzONLl9IV9J/OcuxzDqnw+q8cSlW/JFZYS
	 AGVcvEeYheEIUqWRkuYddTr13SdWfC/C4XoFemKzJCBJh9/mvAoKeri9l3zT04ZF4l
	 EG7/hz9SzpOrg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:32 +0100
Subject: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4993; i=ljs@kernel.org;
 h=from:subject:message-id; bh=henzipa1JQvP3ZJSUdVpc3i3Gyb5R1tpkdjoqO30NaM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LciKU2R7ePSEh5juaqtbvSfO7/tsdvP2okrVGpW4O
 S1pJfNPdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiVy8z/E9ov/RlY+ua9MdM
 6+s1Yp/Jfrky6d3F/7/bC1/kWQaf9Y5hZLj38RDHHLVN1kKTwqNu25zf+0q/e6HuefG01W+Lpf+
 b9LAAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A7D2A140006
X-Stat-Signature: zd8ay1cd98woxz8rsyiqsgokzfzuqq4p
X-HE-Tag: 1790091419-595576
X-HE-Meta: U2FsdGVkX19wi0eYjO1HIipbUNML+yFsqk2eR4UYvrvic2DkaTBckSWOB8NRCEtt8iCaqO5P/2pgM1++9KNAoOyNicJvM6dbiACsKOpxpp5z/GF09fQO6kln3DW7eY8uC4uEKzQo6WmA+FLy3LAGaIEhcxNSl6K9ISnQezgtCv6hFHtklpUvBbb0RcVUunEdWJvCEljYvqQHjN7FbGJNMZPW7E7hfVj4qX+t3pk7YJOajeteHCZFpsxllsilA9ADQ0ls3cR2JcH1hGE8wWJ4qPmLt0Vqb0jpp90lFld+1Ln5RFeppzDApwG5ks22qxohChtsOKxGU2nbxExhoevG9tmQN4R6iqL9gJxxRP50BNG4gVhDVM2coJ4yEuYQvXgbiaVjPmhL/Lv+KtXmdaf5Z5AJE9rX1UQpr0cWdh3Dav69QULLUkIpXOD6HDaiBDjo9xdX4snwbvleLb1qfe/G9qLMKTeSpu4cg3P4OTWejDHqMBNoEuc/hbHOZbEYYbkM39c+3dikTsylIoVt/CcbA4YOvq1Fry9DmaQjGKBa+q9D1rY6DRJFs5thJMAI8f0FAFlMP+zpPzwC4by8u6xdb6qzCZB/hN62qV+cUBCZf/iQLESBBzSdoETP+cAXta0ZpGxky56dIKgaQoFZ8l9z8K2ut+4vZVcC04NbcLxB455hofE0J8FajS7AqG5JLa6VCSsTmO/D3N00znBKi3gHHgZXNe7QCCdCU9egLbXped53Vwx0QsviBTudG/aua1cnLJSh9YP3H3kGj0haf5ejy69Skk+7SvBFyC7t7TJ0+xlu5DGI8EXdWpygTZDeTWihQb8EfrCAFsXZbuxDWhEEzI30iZj9YU33AaA2TIYmZNgv5SnzFEOtqBpONr9me/W8ObcLFcuqZFsDxD/Hj3nQlQoGHeRiIm8tkCohYZ6oh5Q0olSN0OW+hRwCGnltNpAKUzgQ1ElMBzLY1vuv8cy
 tSij82uw
 uMdi7A0WiI4AaFL+syCtmBoErRHf8nIKKqHI09iaY+ziklSxesvKXkAuUqCfBKOjmd4qmHJTiCDQAVf19Z6qcUH4QlqCkyKFbSS3aD4P6ucyuHIa5VSDnhRy9SVZgfaqpHCmiIZaClgBVg12K/XCguyZ1e6FnJdDvelUYiAaqj87aoq+CYGNwei1F4FkR3TJEUXIosYta+sYspxrL3BRdj+zIk0kZupBqKrYTtBs60GdMra6qkQQZy0nKXBbPZSCZ+pATsZDcBveG5Hu8un1tCdTSwzozSvtG6HOJzsa5D+iZsQBpyrOvpN20tXyoEOUgdClH
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

An edge case for deposit exists for powerpc and its hash-based MMU - it
stores hash slot data in deposited page tables and zeroes them on withdraw,
so a zeroed deposited page table works correctly for it.

Since khugepaged runs as a kernel thread, do a little dance in
alloc_deposit_pte() to correctly charge the allocation.

This is already done for the folio allocation via alloc_charge_folio() but
no such wrapper exists for a page table allocation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..dab421f8233e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
+static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
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
@@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		goto out_nolock;
 	}
 
+	if (is_pmd_order(order)) {
+		pgtable = alloc_deposit_pte(mm);
+		if (!pgtable)
+			goto out_nolock;
+	}
+
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
@@ -1433,8 +1456,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	spin_lock(pmd_ptl);
 	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
-		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		pgtable = NULL;
 		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
 	} else {
 		/*
@@ -1453,6 +1476,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	}
 	spin_unlock(pmd_ptl);
 
+	if (is_pmd_order(order))
+		pte_free_defer(mm, pmd_pgtable(_pmd));
+
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
@@ -1463,6 +1489,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
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



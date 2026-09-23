Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE0CC98310
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D396B0088; Wed, 23 Sep 2026 15:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EF86B008A; Wed, 23 Sep 2026 15:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2A56B0093; Wed, 23 Sep 2026 15:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC95D6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:59:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 632D51A08A3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:59:31 +0000 (UTC)
X-FDA: 85246091742.22.B254539
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E7F5160004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:59:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kno41qWF;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790193569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Vw00INHTiJj7/4QiQUDB/NHC+AlawfaZqFc89mI3Uo=;
	b=YP/TlHaqk+95FvnjsmHTzNSbIVorbYP5HaktIrLPf+Y9sC3HcjHuV3Vevf5poCpshtroNE
	Uq93SQt0+tBzKXLwo/LrK2WDBu5rYQ+PeQbnusZ/9qRKZTD0l1V/iV7mSizxrcn7VCn4Vv
	0hsb3Uii3U0Ib40FfCs/fGlAH3G9m9A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kno41qWF;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790193569;
	b=ESwBi1AqH5Vam24KO6M8ia6YvYPKlyAtCjpzhpoxHmK+kLiA6el+V/mNRJK7LubLLN9Ai5
	mHXzY2+fc+DDQIn0zTzRSoquYaff5wLcgsOI1BKbasC/rRfF8fSyAs8+lh4wh6nCC31BLD
	S1HOUH5+PvJmUU+WIYKH5cJ82K6gVY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69C12600AA;
	Wed, 23 Sep 2026 19:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B16C1F000FF;
	Wed, 23 Sep 2026 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790193568;
	bh=6Vw00INHTiJj7/4QiQUDB/NHC+AlawfaZqFc89mI3Uo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kno41qWFahoXgz8d+ShejJCZHoWEcJVL1leHlRD1kffko8g8JqMF0swHQKAX1HqpM
	 oSFWcsNfwRPPZPiT8oiRGQWKzrdI0TLKeP9oQtYbei92ILkPB3/p1L+hKq6td77JFF
	 LtG5ONUzFTYy73cWN7de/JfRwIjTq8OlV8hOUlho=
Date: Wed, 23 Sep 2026 12:59:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren
 <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne
 <shorne@gmail.com>, Rich Felker <dalias@libc.org>, John Paul Adrian
 Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>,
 Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris
 Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge
 Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel
 Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Randy
 Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins
 <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-Id: <20260923125925.105d7575838c3a154a258a4c@linux-foundation.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E7F5160004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y73s7sqyorqes1xh59thdaasawxisiac
X-HE-Tag: 1790193569-657510
X-HE-Meta: U2FsdGVkX19MHXaDmCBb8QNPF/mmCdLm02Itp1kr9PfTidnJhuIa/3CG/86fxYTJWJKT4wBBmPCBb9ok5bDYkG4wOSUwY0BUawqmT5YCHfQGo7y8tUtCkN8Iy5CO8XfZ5jvVBV5lFuVP87uetvKurQ/umTHDvq+KE5tqzN7p70IS/LvFPdJ4UH0j+88OxU6mjq61qtrEXvWrA5Kyxic3JonO1hlLCzF72zf55zOVPv9Cr7Yha3d0gvmNwuYsSH8hWRzKbDm1BGHGHfVVH2PmALu1QlrTI1dwPAOICBu4rzaP3dIAGWBAtqaRrWG8OibiX+liMWaYITLqYX0NW84oScQ/fwzA6MHL51m69eFocmZ1FMWSB3zs1CrhhJw9ZEo6ToFZl/3az3MvmFgPmFuGxqQ1RuNHEih7AgHorBh1btszJXnnSRu9Y2zjlP1RoaneGkZtGuW8GCeWdX5vgehLB3r10IbtmDEpDWkj6rEcjvPf1XGs5BwP9ajtCZRpEENTZXzVXE7bE0FfJa6hCKvUjVFguCbLA1DheeFOoJs4DihgMDR29xd6oAR/cBtszQmfpu+/vMWzspkcpCrpRjiNbhFKvgSuegCLemNCsez2xHmpmr+JQvjx0IvrvSMo2/KvPbxykVojIy9r4n4zM8zoLKlA0y8Hu6F6PXb9NwTKC6Qde9UyhJkNIr7hpptVsYMBMU1NOKk3lkcwhRK9yWW5TtlAgBmuy5MNYANu4gzI4DotO6LbeitTK4A3omu+EQmUzNTR2HmWMz/BsA8tofgyAYfrnMgGJl5Jb36s7VUTVeth/Qm2Y6Xxvr2ph+EsxqTVTR2IKpv33ziMtoRm2OAvIyNWKdtVIzrUrgbARtO4THs8W8Ta0imAyEEljsW5re2RGnmwJcvW5ipKYcIkymNGaZpMxFQd54O0rOJz4ys4HLSS8CLIV3uUIF1RSVEZ6z50yhoMI4S+JiCMaDLZH1B
 OEfmFXMF
 cpfolM/BssEh3xugcYO4WPhduSXaeRs41jL1PyaIa69zxQ3z3eb4vQByOcCUFI9/CVxZdDcVYaUZJARVQ3lhPlPHfAAMeN3811zcTI6GlNXUNxgmZW202mxhfoGfRytvv7hz0h97xo2oDmWw9E0KG3vgibPRt2BjM8VAtWY5YU0XMna8rzvgH5bqzR9xKDejjB4KKvOXpiBafz8q843aKQYEfT+ne2NcFK0ClaKK28KizNGUJUq24GUXTb9+sOMcLCU4C5GoUn6m5GrR17GfvU1F+kU4/tgRQq5x3dO9iN8ffXsmy4jTh4Mq3Kr19GEED5apKa9F1xXB4Nk2TMqDEYMo59F7D4Seey2IJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 16:35:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The majority of architectures in the kernel defer page table freeing until
> an RCU grace period has elapsed, this series converts all remaining
> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> altogether.
> 
> This is important because it enables safe lockless page table walking under
> RCU alone.
> 
> Doing so allows for reduced lock contention, avoids lock ordering concerns
> and enables fast, efficient and correct page table walking as a result.
> 
> Additionally it removes a bunch of code and architecture-specific behaviour
> which is always a beneficial thing to do.
> 
> There has been much recent work on this:

Thanks, I've updated mm.git's mm-unstable branch to this version.  Plus
one -fix for [01/12].

> v4:
> * Updated the 1st patch to allocate a new page table on PTE deposit rather
>   than deposit a page table that might currently be being walked by an
>   RCU-only page table walker, as per David.

Here's how v4 altered mm.git:


 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -2478,7 +2478,7 @@ static inline void zap_deposited_table(s
 	pgtable_t pgtable;
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free_defer(mm, pgtable);
+	pte_free(mm, pgtable);
 	mm_dec_nr_ptes(mm);
 }
 
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_fol
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
@@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_pa
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
 	pte_t *pte = NULL;
-	pgtable_t pgtable;
+	pgtable_t pgtable = NULL;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	enum scan_result result = SCAN_FAIL;
@@ -1310,6 +1327,14 @@ static enum scan_result collapse_huge_pa
 		goto out_nolock;
 	}
 
+	if (is_pmd_order(order)) {
+		pgtable = alloc_deposit_pte(mm);
+		if (!pgtable) {
+			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+			goto out_nolock;
+		}
+	}
+
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
@@ -1433,8 +1458,8 @@ static enum scan_result collapse_huge_pa
 	spin_lock(pmd_ptl);
 	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
-		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		pgtable = NULL;
 		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
 	} else {
 		/*
@@ -1453,6 +1478,9 @@ static enum scan_result collapse_huge_pa
 	}
 	spin_unlock(pmd_ptl);
 
+	if (is_pmd_order(order))
+		pte_free_defer(mm, pmd_pgtable(_pmd));
+
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
@@ -1463,6 +1491,8 @@ out_up_write:
 		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
+	if (pgtable)
+		pte_free(mm, pgtable);
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
_



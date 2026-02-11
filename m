Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA42CE9E309
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A876B008A; Wed, 11 Feb 2026 08:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362346B008C; Wed, 11 Feb 2026 08:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264F36B0092; Wed, 11 Feb 2026 08:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 100AF6B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:47:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD41D1403D0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:47:02 +0000 (UTC)
X-FDA: 84432301884.10.3D91F0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7265F40015
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:47:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TpGU0ful;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zxdm0esaTtsIbnWJ0qX3+ya4ZkzxBMR1tuCFSv/qmA=;
	b=AFiWIdfZmnaov+ZPYX++sbaUfDK20XtS+G6tdaaPOI+636GZSeid/o8wcBIoSkYYhj8hFT
	cHGkXjrur1Ko5dop5tAMVOPSLjRoznfqh7KFUjgcMIShVBili2CkxOwuE6sHVWHlAWK4To
	jqQ66kSnnDotgug8vsY3LjlGs95nRMw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TpGU0ful;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817620; a=rsa-sha256;
	cv=none;
	b=wor81WYUqJ/ZJui5VByuDepZRxEuzt57M0gYWpOUAE6KEezKM7j2urXEoDIsMWb3khgRM8
	bpS3+sw4QErfnUjx4H7zXWt4z3a90Qw97lMbiskuN7jZunxopmGlFBQ5qmfr7or/12wVpF
	7+ZL2ngvq9FkghiJGzD7tSd2XHgrCFU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D37043B6C;
	Wed, 11 Feb 2026 13:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A92BC4AF09;
	Wed, 11 Feb 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817619;
	bh=TxdgjiPVVTX6t48IcAVe6THNTWPwDDgB4bajzDl63R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpGU0fulLIaEDV1K61MO+4RIYR73ZoVzZGzTasWE4PF/oQ7P5kMVsmtPWzHaghAlh
	 6bkbKDbIqZfcBQA25fOo79e8+YtTpBkaDFLpPX45dxxpnq5jrLNdRQVN7RL50hc16A
	 LIUN+YFf0V/EBfcxJqYwHkrqfFkrK/VIunrIhLxjy9H/XF0Jnl0H0mbMNd6oAYHopB
	 cITGbNvkpIn1G4W+aN3akGJ6h+bVKxIW8FbYcgbpteWj2FTJyvTL5MRYQtcY89Wtmh
	 bFiHyhooJL07vGWcXevxLTRb5F6V2ODTvR1IJExe52DKsY/87FaLmat0UOgHpE+5ys
	 62YdUbM0SMADg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 645AEF40068;
	Wed, 11 Feb 2026 08:46:57 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 11 Feb 2026 08:46:57 -0500
X-ME-Sender: <xms:UYiMafZ12wVvM0oU0xUWMBdVc2YZxz-KZJdN-An450wBSUhdadhXHw>
    <xme:UYiMacRDCTaF1W543JOJYL6WdIZsT5jKuUWw1nP3csxRcErBySluSNtHx8PMk49CB
    nfkkL4414waaQ5sAMXdF0GQugjkSI4ei30d0NYvuHkrDVPGEoqXIw>
X-ME-Received: <xmr:UYiMabBmWXGwF_iyfNM2BssWiki6Mc2qHxbe7T56rey1OBEbIRhn9pYakgUXFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtddvjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeegtddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuhhsrghmrgdrrg
    hrihhfsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghsse
    horhgrtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdho
    rhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    epfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehhrghnnhgvshestghmphig
    tghhghdrohhrghdprhgtphhtthhopehrihgvlhesshhurhhrihgvlhdrtghomh
X-ME-Proxy: <xmx:UYiMaW42pXo6xSBkrlx2ZrPLclY61GB26O-sh7v8nyUs5vJv6uLvvw>
    <xmx:UYiMaTADywtx3HlPPrtJadPCfcWjVogUCe03NIY9nirw0R_p0o0sqg>
    <xmx:UYiMaS4Nzh5nEnLSWD4m5Xu6ITGW6jFsYGT4L5MRNMD6hoDxaJo3og>
    <xmx:UYiMaXtvHVc4hgnB5EHRw_YS88jRrln2zGBcHSmC4vIr4rRy0-Sv0w>
    <xmx:UYiMaYwn8jP0GGiCJo8xy-tO6n69UjAfnSJCi-DceXF03eesCcBb1inC>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 08:46:55 -0500 (EST)
Date: Wed, 11 Feb 2026 13:46:48 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, willy@infradead.org, 
	linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Message-ID: <aYyH9n_Q2XBCzJzP@thinkstation>
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
 <66386da6-6a7c-4968-9167-71f99dd498ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66386da6-6a7c-4968-9167-71f99dd498ad@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: xkrbquhfab36kyewz9jhuwfu9wu6n3kf
X-Rspamd-Queue-Id: 7265F40015
X-Rspam-User: 
X-HE-Tag: 1770817620-843915
X-HE-Meta: U2FsdGVkX1+qxOBANyfX6+Ad1VpwWwYD5qmbOjkvG1rA5lnhvVqNM8JoLvcy4V7NU7n2aRt96nfELH94G7cZoM1Aj3Gg6U/ddQVtgHgHpYOXa4jjkuGWYWQa8yyrX7C/cfV+HlAHCw9/c64NkpWXXiA0tPkD99skQycdLdX/04wskDQTf9VbPZxeWGmMCdEDEXAd+jdmgmLI4TTixCM3cqjrmNuLyvulFZHrkhiCrLyfNW6EI4UwqbxXbU9ys9EF1Y3iX/e28b3j/JPuwvKEPxItd8wvoVEakd/0zGlt9sf+3NvmJT1K2Tvg/qYHoIsgNTo/8tQbgofUXE3dK1tFHkbgXPvI0/4xt43+W1DwnoQHJgyyjklPdVS0Dm8hwvSTnslVOT/5H5qToFTRHEzm9Raowg5RbDNQgIteS93Z5t14pYhfH7uyZFwx/nEF3UepQ4xjPk0yYDLZp5ke1tdT49pA2AHaf9rObBqPsWvWf/QV2vy6XOcSM5ueWImIideOWm/uEJoHXMtixTATKaRYuahgINR9PzbOuvWOFfGXH+puFTdk14BREdWy5dEbtUPyu0nf0ZjSsib/CvE/Kf+GazRNF7TD9RvZRzVnO+JTXXZ3vW2DacXKFE3IhJAuw93yBiORVjqrnv0U4WP+t8WduqUpQZmeoH273So1jNQuKKjAmMIkba57HzVtcwtnM+BEYQsh/Ic7MAde2J50ZAsMd1GeLupz2Iy1JffGLmVCTPll1XqxeSv731QwGUT3pOIyfXJR/xMvxKT58MlyKrS6tSGhLyDMuUC+E/A70eSHxrAcOzJDmXy2PjxakspjanFikth4FHf4CK1duZZQvfjs4tiKqxd2pAr0JdcaLurIVsCu7u1ZSNMQBPyIykAR5JHVJN2gCSW4NlXtaOPcadl2O5cgKbOMjv7nH/KwSxnW2GwgT0CiTbOyENl60FbCKCLNDyHIkxqkacpKyiRHkqQ
 xFSiPT19
 MfrYGDk2uIpV29yU/yHkfwHfoH4XgANUhpSuLjrnyVqjy3j+cQEp91BV1IyjnLxh3ilGtL4yWYerALX8TgAuiONhB0ToHiSs2q3nvJ2mEAIv3UZY7kXhM3gxzj8EooK+zNKgFrtR04u6dDF3xK+EXoNXLYUmO1VO+2XGddtnFvU8eJoYyf7OllH39TUpuIpii6jGKn5MN7tkox1MWXkafmI2sRpBAq9oSVqtZ5nSKD2HBn4rqk/PTn8eFPpzRHwNQ+nGpo1ILiLNn2bQ/nv5cAVUjPHJSUk+OXznmbr0zSiyKRGFG8IiAM43N91InJhoqoTrcdzmuVyD2+fQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 02:35:07PM +0100, David Hildenbrand (Arm) wrote:
> On 2/11/26 13:49, Usama Arif wrote:
> > When the kernel creates a PMD-level THP mapping for anonymous pages,
> > it pre-allocates a PTE page table and deposits it via
> > pgtable_trans_huge_deposit(). This deposited table is withdrawn during
> > PMD split or zap. The rationale was that split must not fail—if the
> > kernel decides to split a THP, it needs a PTE table to populate.
> > 
> > However, every anon THP wastes 4KB (one page table page) that sits
> > unused in the deposit list for the lifetime of the mapping. On systems
> > with many THPs, this adds up to significant memory waste. The original
> > rationale is also not an issue. It is ok for split to fail, and if the
> > kernel can't find an order 0 allocation for split, there are much bigger
> > problems. On large servers where you can easily have 100s of GBs of THPs,
> > the memory usage for these tables is 200M per 100G. This memory could be
> > used for any other usecase, which include allocating the pagetables
> > required during split.
> > 
> > This patch removes the pre-deposit for anonymous pages on architectures
> > where arch_needs_pgtable_deposit() returns false (every arch apart from
> > powerpc, and only when radix hash tables are not enabled) and allocates
> > the PTE table lazily—only when a split actually occurs. The split path
> > is modified to accept a caller-provided page table.
> > 
> > PowerPC exception:
> > 
> > It would have been great if we can completely remove the pagetable
> > deposit code and this commit would mostly have been a code cleanup patch,
> > unfortunately PowerPC has hash MMU, it stores hash slot information in
> > the deposited page table and pre-deposit is necessary. All deposit/
> > withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
> > behavior is unchanged with this patch. On a better note,
> > arch_needs_pgtable_deposit will always evaluate to false at compile time
> > on non PowerPC architectures and the pre-deposit code will not be
> > compiled in.
> > 
> > Why Split Failures Are Safe:
> > 
> > If a system is under severe memory pressure that even a 4K allocation
> > fails for a PTE table, there are far greater problems than a THP split
> > being delayed. The OOM killer will likely intervene before this becomes an
> > issue.
> > When pte_alloc_one() fails due to not being able to allocate a 4K page,
> > the PMD split is aborted and the THP remains intact. I could not get split
> > to fail, as its very difficult to make order-0 allocation to fail.
> > Code analysis of what would happen if it does:
> > 
> > - mprotect(): If split fails in change_pmd_range, it will fallback
> > to change_pte_range, which will return an error which will cause the
> > whole function to be retried again.
> > 
> > - munmap() (partial THP range): zap_pte_range() returns early when
> > pte_offset_map_lock() fails, causing zap_pmd_range() to retry via pmd--.
> > For full THP range, zap_huge_pmd() unmaps the entire PMD without
> > split.
> > 
> > - Memory reclaim (try_to_unmap()): Returns false, folio rotated back
> > LRU, retried in next reclaim cycle.
> > 
> > - Migration / compaction (try_to_migrate()): Returns -EAGAIN, migration
> > skips this folio, retried later.
> > 
> > - CoW fault (wp_huge_pmd()): Returns VM_FAULT_FALLBACK, fault retried.
> > 
> > -  madvise (MADV_COLD/PAGEOUT): split_folio() internally calls
> > try_to_migrate() with TTU_SPLIT_HUGE_PMD. If PMD split fails,
> > try_to_migrate() returns false, split_folio() returns -EAGAIN,
> > and madvise returns 0 (success) silently skipping the region. This
> > should be fine. madvise is just an advice and can fail for other
> > reasons as well.
> > 
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >   include/linux/huge_mm.h |   4 +-
> >   mm/huge_memory.c        | 144 ++++++++++++++++++++++++++++------------
> >   mm/khugepaged.c         |   7 +-
> >   mm/migrate_device.c     |  15 +++--
> >   mm/rmap.c               |  39 ++++++++++-
> >   5 files changed, 156 insertions(+), 53 deletions(-)
> > 
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index a4d9f964dfdea..b21bb72a298c9 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -562,7 +562,7 @@ static inline bool thp_migration_supported(void)
> >   }
> >   void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> > -			   pmd_t *pmd, bool freeze);
> > +			   pmd_t *pmd, bool freeze, pgtable_t pgtable);
> >   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
> >   			   pmd_t *pmdp, struct folio *folio);
> >   void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> > @@ -660,7 +660,7 @@ static inline void split_huge_pmd_address(struct vm_area_struct *vma,
> >   		unsigned long address, bool freeze) {}
> >   static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
> >   					 unsigned long address, pmd_t *pmd,
> > -					 bool freeze) {}
> > +					 bool freeze, pgtable_t pgtable) {}
> >   static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
> >   					 unsigned long addr, pmd_t *pmdp,
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 44ff8a648afd5..4c9a8d89fc8aa 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1322,17 +1322,19 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> >   	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
> >   	struct vm_area_struct *vma = vmf->vma;
> >   	struct folio *folio;
> > -	pgtable_t pgtable;
> > +	pgtable_t pgtable = NULL;
> >   	vm_fault_t ret = 0;
> >   	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
> >   	if (unlikely(!folio))
> >   		return VM_FAULT_FALLBACK;
> > -	pgtable = pte_alloc_one(vma->vm_mm);
> > -	if (unlikely(!pgtable)) {
> > -		ret = VM_FAULT_OOM;
> > -		goto release;
> > +	if (arch_needs_pgtable_deposit()) {
> > +		pgtable = pte_alloc_one(vma->vm_mm);
> > +		if (unlikely(!pgtable)) {
> > +			ret = VM_FAULT_OOM;
> > +			goto release;
> > +		}
> >   	}
> >   	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> > @@ -1347,14 +1349,18 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> >   		if (userfaultfd_missing(vma)) {
> >   			spin_unlock(vmf->ptl);
> >   			folio_put(folio);
> > -			pte_free(vma->vm_mm, pgtable);
> > +			if (pgtable)
> > +				pte_free(vma->vm_mm, pgtable);
> >   			ret = handle_userfault(vmf, VM_UFFD_MISSING);
> >   			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
> >   			return ret;
> >   		}
> > -		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> > +		if (pgtable) {
> > +			pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
> > +						   pgtable);
> > +			mm_inc_nr_ptes(vma->vm_mm);
> > +		}
> >   		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
> > -		mm_inc_nr_ptes(vma->vm_mm);
> >   		spin_unlock(vmf->ptl);
> >   	}
> > @@ -1450,9 +1456,11 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
> >   	pmd_t entry;
> >   	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
> >   	entry = pmd_mkspecial(entry);
> > -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +	if (pgtable) {
> > +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +		mm_inc_nr_ptes(mm);
> > +	}
> >   	set_pmd_at(mm, haddr, pmd, entry);
> > -	mm_inc_nr_ptes(mm);
> >   }
> >   vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> > @@ -1471,16 +1479,19 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> >   	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
> >   			!mm_forbids_zeropage(vma->vm_mm) &&
> >   			transparent_hugepage_use_zero_page()) {
> > -		pgtable_t pgtable;
> > +		pgtable_t pgtable = NULL;
> >   		struct folio *zero_folio;
> >   		vm_fault_t ret;
> > -		pgtable = pte_alloc_one(vma->vm_mm);
> > -		if (unlikely(!pgtable))
> > -			return VM_FAULT_OOM;
> > +		if (arch_needs_pgtable_deposit()) {
> > +			pgtable = pte_alloc_one(vma->vm_mm);
> > +			if (unlikely(!pgtable))
> > +				return VM_FAULT_OOM;
> > +		}
> >   		zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
> >   		if (unlikely(!zero_folio)) {
> > -			pte_free(vma->vm_mm, pgtable);
> > +			if (pgtable)
> > +				pte_free(vma->vm_mm, pgtable);
> >   			count_vm_event(THP_FAULT_FALLBACK);
> >   			return VM_FAULT_FALLBACK;
> >   		}
> > @@ -1490,10 +1501,12 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> >   			ret = check_stable_address_space(vma->vm_mm);
> >   			if (ret) {
> >   				spin_unlock(vmf->ptl);
> > -				pte_free(vma->vm_mm, pgtable);
> > +				if (pgtable)
> > +					pte_free(vma->vm_mm, pgtable);
> >   			} else if (userfaultfd_missing(vma)) {
> >   				spin_unlock(vmf->ptl);
> > -				pte_free(vma->vm_mm, pgtable);
> > +				if (pgtable)
> > +					pte_free(vma->vm_mm, pgtable);
> >   				ret = handle_userfault(vmf, VM_UFFD_MISSING);
> >   				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
> >   			} else {
> > @@ -1504,7 +1517,8 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> >   			}
> >   		} else {
> >   			spin_unlock(vmf->ptl);
> > -			pte_free(vma->vm_mm, pgtable);
> > +			if (pgtable)
> > +				pte_free(vma->vm_mm, pgtable);
> >   		}
> >   		return ret;
> >   	}
> > @@ -1836,8 +1850,10 @@ static void copy_huge_non_present_pmd(
> >   	}
> >   	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> > -	mm_inc_nr_ptes(dst_mm);
> > -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> > +	if (pgtable) {
> > +		mm_inc_nr_ptes(dst_mm);
> > +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> > +	}
> >   	if (!userfaultfd_wp(dst_vma))
> >   		pmd = pmd_swp_clear_uffd_wp(pmd);
> >   	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
> > @@ -1877,9 +1893,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	if (!vma_is_anonymous(dst_vma))
> >   		return 0;
> > -	pgtable = pte_alloc_one(dst_mm);
> > -	if (unlikely(!pgtable))
> > -		goto out;
> > +	if (arch_needs_pgtable_deposit()) {
> > +		pgtable = pte_alloc_one(dst_mm);
> > +		if (unlikely(!pgtable))
> > +			goto out;
> > +	}
> >   	dst_ptl = pmd_lock(dst_mm, dst_pmd);
> >   	src_ptl = pmd_lockptr(src_mm, src_pmd);
> > @@ -1897,7 +1915,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	}
> >   	if (unlikely(!pmd_trans_huge(pmd))) {
> > -		pte_free(dst_mm, pgtable);
> > +		if (pgtable)
> > +			pte_free(dst_mm, pgtable);
> >   		goto out_unlock;
> >   	}
> >   	/*
> > @@ -1923,7 +1942,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
> >   		/* Page maybe pinned: split and retry the fault on PTEs. */
> >   		folio_put(src_folio);
> > -		pte_free(dst_mm, pgtable);
> > +		if (pgtable)
> > +			pte_free(dst_mm, pgtable);
> >   		spin_unlock(src_ptl);
> >   		spin_unlock(dst_ptl);
> >   		__split_huge_pmd(src_vma, src_pmd, addr, false);
> > @@ -1931,8 +1951,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	}
> >   	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> >   out_zero_page:
> > -	mm_inc_nr_ptes(dst_mm);
> > -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> > +	if (pgtable) {
> > +		mm_inc_nr_ptes(dst_mm);
> > +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> > +	}
> >   	pmdp_set_wrprotect(src_mm, addr, src_pmd);
> >   	if (!userfaultfd_wp(dst_vma))
> >   		pmd = pmd_clear_uffd_wp(pmd);
> > @@ -2364,7 +2386,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   			zap_deposited_table(tlb->mm, pmd);
> >   		spin_unlock(ptl);
> >   	} else if (is_huge_zero_pmd(orig_pmd)) {
> > -		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
> > +		if (arch_needs_pgtable_deposit())
> >   			zap_deposited_table(tlb->mm, pmd);
> >   		spin_unlock(ptl);
> >   	} else {
> > @@ -2389,7 +2411,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   		}
> >   		if (folio_test_anon(folio)) {
> > -			zap_deposited_table(tlb->mm, pmd);
> > +			if (arch_needs_pgtable_deposit())
> > +				zap_deposited_table(tlb->mm, pmd);
> >   			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
> >   		} else {
> >   			if (arch_needs_pgtable_deposit())
> > @@ -2490,7 +2513,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
> >   			force_flush = true;
> >   		VM_BUG_ON(!pmd_none(*new_pmd));
> > -		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
> > +		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma) &&
> > +		    arch_needs_pgtable_deposit()) {
> >   			pgtable_t pgtable;
> >   			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
> >   			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
> > @@ -2798,8 +2822,10 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> >   	}
> >   	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
> > -	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
> > -	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> > +	if (arch_needs_pgtable_deposit()) {
> > +		src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
> > +		pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> > +	}
> >   unlock_ptls:
> >   	double_pt_unlock(src_ptl, dst_ptl);
> >   	/* unblock rmap walks */
> > @@ -2941,10 +2967,9 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
> >   #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> >   static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> > -		unsigned long haddr, pmd_t *pmd)
> > +		unsigned long haddr, pmd_t *pmd, pgtable_t pgtable)
> >   {
> >   	struct mm_struct *mm = vma->vm_mm;
> > -	pgtable_t pgtable;
> >   	pmd_t _pmd, old_pmd;
> >   	unsigned long addr;
> >   	pte_t *pte;
> > @@ -2960,7 +2985,16 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> >   	 */
> >   	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
> > -	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> > +	if (arch_needs_pgtable_deposit()) {
> > +		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> > +	} else {
> > +		VM_BUG_ON(!pgtable);
> > +		/*
> > +		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
> > +		 * being used in mm.
> > +		 */
> > +		mm_inc_nr_ptes(mm);
> > +	}
> >   	pmd_populate(mm, &_pmd, pgtable);
> >   	pte = pte_offset_map(&_pmd, haddr);
> > @@ -2982,12 +3016,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> >   }
> >   static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> > -		unsigned long haddr, bool freeze)
> > +		unsigned long haddr, bool freeze, pgtable_t pgtable)
> >   {
> >   	struct mm_struct *mm = vma->vm_mm;
> >   	struct folio *folio;
> >   	struct page *page;
> > -	pgtable_t pgtable;
> >   	pmd_t old_pmd, _pmd;
> >   	bool soft_dirty, uffd_wp = false, young = false, write = false;
> >   	bool anon_exclusive = false, dirty = false;
> > @@ -3011,6 +3044,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >   		 */
> >   		if (arch_needs_pgtable_deposit())
> >   			zap_deposited_table(mm, pmd);
> > +		if (pgtable)
> > +			pte_free(mm, pgtable);
> >   		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
> >   			return;
> >   		if (unlikely(pmd_is_migration_entry(old_pmd))) {
> > @@ -3043,7 +3078,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >   		 * small page also write protected so it does not seems useful
> >   		 * to invalidate secondary mmu at this time.
> >   		 */
> > -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
> > +		return __split_huge_zero_page_pmd(vma, haddr, pmd, pgtable);
> >   	}
> >   	if (pmd_is_migration_entry(*pmd)) {
> > @@ -3167,7 +3202,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >   	 * Withdraw the table only after we mark the pmd entry invalid.
> >   	 * This's critical for some architectures (Power).
> >   	 */
> > -	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> > +	if (arch_needs_pgtable_deposit()) {
> > +		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> > +	} else {
> > +		VM_BUG_ON(!pgtable);
> > +		/*
> > +		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
> > +		 * being used in mm.
> > +		 */
> > +		mm_inc_nr_ptes(mm);
> > +	}
> >   	pmd_populate(mm, &_pmd, pgtable);
> >   	pte = pte_offset_map(&_pmd, haddr);
> > @@ -3263,11 +3307,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >   }
> >   void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> > -			   pmd_t *pmd, bool freeze)
> > +			   pmd_t *pmd, bool freeze, pgtable_t pgtable)
> >   {
> >   	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
> >   	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
> > -		__split_huge_pmd_locked(vma, pmd, address, freeze);
> > +		__split_huge_pmd_locked(vma, pmd, address, freeze, pgtable);
> > +	else if (pgtable)
> > +		pte_free(vma->vm_mm, pgtable);
> >   }
> >   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> > @@ -3275,13 +3321,24 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> >   {
> >   	spinlock_t *ptl;
> >   	struct mmu_notifier_range range;
> > +	pgtable_t pgtable = NULL;
> >   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
> >   				address & HPAGE_PMD_MASK,
> >   				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
> >   	mmu_notifier_invalidate_range_start(&range);
> > +
> > +	/* allocate pagetable before acquiring pmd lock */
> > +	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
> > +		pgtable = pte_alloc_one(vma->vm_mm);
> > +		if (!pgtable) {
> > +			mmu_notifier_invalidate_range_end(&range);
> 
> What I last looked at this, I thought the clean thing to do is to let
> __split_huge_pmd() and friends return an error.
> 
> Let's take a look at walk_pmd_range() as one example:
> 
> if (walk->vma)
> 	split_huge_pmd(walk->vma, pmd, addr);
> else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
> 	continue;
> 
> err = walk_pte_range(pmd, addr, next, walk);
> 
> Where walk_pte_range() just does a pte_offset_map_lock.
> 
> 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> 
> But if that fails (as the remapping failed), we will silently skip this
> range.
> 
> I don't think silently skipping is the right thing to do.
> 
> So I would think that all splitting functions have to be taught to return an
> error and handle it accordingly. Then we can actually start returning
> errors.

Yeah, I am also confused by silent split PMD failure. It has to be
communicated to the caller cleanly.

It is also an opportunity to audit all callers and check if they can
deal with the failure.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


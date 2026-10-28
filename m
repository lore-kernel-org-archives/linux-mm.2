Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7072606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g7RXDx8M
Received: by kanga.kvack.org (Postfix)
	id DF0436B05B1; Wed, 28 Oct 2026 06:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA14B6B05B2; Wed, 28 Oct 2026 06:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8956B05B3; Wed, 28 Oct 2026 06:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5DE16B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:18:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2474A80C0B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:18:38 +0000 (UTC)
X-FDA: 85371635916.07.C83806B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 91AC61C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:18:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7RXDx8M;
	spf=pass (imf20.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182716;
	b=4zDqcgb1F55nPiu3/jP6V7/qWZEfINhkTXExIgTiBXXvQEk67aTrXttertM8lxVL6em7AX
	Up5Q2JBWpRO2bH9tRVN/xvEqOFsH4zPCKf27ecX0j1HJT4Jtml8TYGLZVFe4Acc+yzgX8E
	3QLE1XOKsUV00lwd4UzImh9vprUHs28=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7RXDx8M;
	spf=pass (imf20.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mliajgUIsx7gJSmBdbK9pXM4vtTIJ/Nw3KYTTaS80N8=;
	b=FLKABv9IiAgE09RtWGrwoX/SMFhVImHPbo53vfZd3Z1xeU3O3H5jlZFuBrfs2ucjajzIfO
	22vRDtliSFSLzCr1xymE5+mhtOJgq+qUwxhuwCwHwCnNIRraLj3Kl4Ge6FA17B1ZwK7Rzw
	Mut3QM6lrTd5nxemoz2O32oSviuP8WQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C380600C8;
	Wed, 28 Oct 2026 10:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3491F01825;
	Wed, 28 Oct 2026 10:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793182715;
	bh=mliajgUIsx7gJSmBdbK9pXM4vtTIJ/Nw3KYTTaS80N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7RXDx8M93py2F/2sETg1IElhcHIMffsqzYYF3XlH6Hn1Jyqoq+nT25JkulYj1I3m
	 exLc++HQD7riM5jcQW0DPZmy+t/DF6i440Zu4hAqKNPEfjYHssaLYYnSJ3LTxgwnoA
	 73B26YWLUwUuW/FSjiM4m/nx4JIQb0gTuKT/qUTiPiuc2t257PYUFESdSm471EcfBM
	 p3eacu+5NKkXK8R1lF5JQyU0PdY9DKyzuP1T/2WFeWaElWItr+qylWe6QGRjPDw7dj
	 i6F6XB14Hz6y1Z+WcqrUZINZqH6kMQBun7ew8wv8fLGWhv//b8r+tISOBqLfW675uK
	 xj8AHUuLl0VtA==
From: Imre Kaloz <kaloz@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Date: Wed, 28 Oct 2026 11:17:18 +0100
Message-ID: <20261028101719.11918-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org> <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org> <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org> <20261027212610.6798-1-kaloz@kernel.org> <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org> <20261028091631.8072-1-kaloz@kernel.org> <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r4i3zsfho9465qdf9xo7jqxjjikeum88
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91AC61C0009
X-Rspam-User: 
X-HE-Tag: 1793182716-21788
X-HE-Meta: U2FsdGVkX1/DVeE2fmlUffON6jQD0uRD4Uwg5YrePX+IW9aSnY3byqKPQc8J4EhPqYhBw6MjMfWXn2NMihAe80NT4iu+6QBbjzG5TFYi2pKVvWJEq8LXG/Wso+2pCVKBzJS7AlkqblnziSEjkkWnq6YaDflURUtuO7OSZM+2KrrA+LBA3KtJYFHbGOJzlx9Wa0bNL++AO9vm/H5ZQd0ehfBbfbGhbI6vBJW7i27PZbwH6/6HtdUljh5nclTrXCcOn5BIpeFYbEzJofTJlnfHOcU5KWDzdFXskKI5BTmRDcdZ6yMVlf0IxIzK7syRkG1hqD7DnSLTOatps7mWVFq8oKzMqJ5emVsPzBBMF3130Crd7Smo/Kz56FAjIhEn2JqZNEwIHctvilFl/Q7/imB6UUr8cpdW1M2EVRl1d4GKHhO+YHczTBwu0m9xUPGf0J0cVFyZw/Xydr9QgA4gTw0kq12pY8moSmjZX/HVZ791PhRE3m9a4QTtHLsGqev2KmafI9lgU8JQjXV6pV0LjTHflKBggy7tIpE3P1vn/Uf1Cd6s+U5jLS+DEckbAiHoHWkQtzfdHTw3kkiVB285gQCytoyezpcjq9idOkPp0PzsLk1riT1+K0CYitKiEHrWbKfSqGG31mqJGb/8nIFpi4d2kTOtI4mhayg15jy8Csuq+1FVvj/dyluEwM7/fhP01m2LV0gflWMJfeQn06Fl+T7WIm+ATLBGDsP7RRri0qTg8QR1pzYcaEkqoYUnANjNFXYcvWDDUweAF6VoPCHTFJV7urZvZOkThuENKG0v2+Nx15RcUeqLR0bawkfZ/1zHHA9e9otH5ONqhvsPXHngHbTz3bkxPjVdc47hDUqDhionzhNfEF06izaEBZI0j7FhVJ7revKZjSfybRi1/nbW7w+zJ1XJB65vxpfdtnP4jjotN8FKEB1n/pIqV5ewRHuuIUc1vQxyOWhVpmFl54yH9LS
 7JBUDQcw
 WJ3IRFkHmWa3Xrh+RwRKiaMcJ5HI4nv1yvO06Hck8bphcsSvkFx9juV0lQGUfZPlSBAhk9RXkptSfCIFb5N+EONvyzdvh0lJdiuefbR1wKlosouUii/fjiYOVB0JNvSrC0/BcdFB5uq/qaYm6yJcC8g3aQ4+w0DYKXK/NWzG9mQnHCqNc0WvaC2fh3INWwBR7eQvPgy12A8Ci8vweO9Of2IbJ27wopAN/zJ1IyK0sw0FzEHspY5gscuXrmeBVnEyas17vW17QeCcuUn4gi9kfNkNS0s8pfX73lswa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 10/28/26 10:22, David Hildenbrand (Arm) wrote:
> Okay, so mremap() and reclaim memory performance concerns make you sleep bad at
> night? :)

Probably less than move_pte() kept you mm folks up at night ;)

> Don't get me wrong, I know that running new kernels on old HW is fun.
> Last week a got upstream Linux running on a 32bit x86 notebook from 2007 with
> the snap of a finger. Everything just works (using Alpine).

Nice, that's exactly the kind of thing I enjoy too.

> The biggest problem all of us with supporting old hardware is the maintanance
> cost. Not just core-mm, but also things like ad-hoc page table walkers you are
> adding we (from core-mm) might have to touch at some point.
>
> If there is no good reason for the complexity, out it goes.
>
> Because otherwise people will push more and more for removing legacy support
> completely, and that's not what you want, right?

Definitely not. Fair point, I was only looking at it from the sparc
side, and keeping these platforms cheap to carry matters more than a
few percent on reclaim. B it is, then; it's below the scissors, on top
of 1/4-3/4. Thanks for taking the time to go through this!

Andreas, if David is happy with it, would you take it in place of 4/4?


Best,
Imre

-- >8 --
Subject: [PATCH] sparc64: replace move_pte() with a D-cache flush in flush_cache_range()

mremap() can move a page to an address of the other D-cache color,
leaving lines of the old color in the virtually indexed D-cache of
Spitfire and Cheetah CPUs.  move_pte() flushed the page for each PTE
moved, which is only correct while move_ptes() handles one PTE at a
time.

Drop move_pte(), which no other architecture defines, and flush the
whole D-cache in flush_cache_range(), which mremap() calls on the old
range before moving the PTEs.  This keeps the fix in sparc64 without
a page table walk.

Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 54a2d37008e6..1a116b288816 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -21,8 +21,8 @@ void __flushw_user(void);
 #define flush_cache_mm(__mm) \
 	do { if ((__mm) == current->mm) flushw_user(); } while(0)
 #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
-#define flush_cache_range(vma, start, end) \
-	flush_cache_mm((vma)->vm_mm)
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end);
 #define flush_cache_page(vma, page, pfn) \
 	flush_cache_mm((vma)->vm_mm)
 
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 1430489b9ac5..2452d959aac1 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -945,27 +945,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#ifdef DCACHE_ALIASING_POSSIBLE
-/* This flushes only the page the PTE maps, so it relies on move_ptes()
- * calling it for one PTE at a time, which the default pte_batch_hint()
- * guarantees.
- */
-#define __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)				\
-({									\
-	pte_t newpte = (pte);						\
-	if (tlb_type != hypervisor && pte_present(pte)) {		\
-		unsigned long this_pfn = pte_pfn(pte);			\
-									\
-		if (pfn_valid(this_pfn) &&				\
-		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
-			flush_dcache_page_all(current->mm,		\
-					      pfn_to_page(this_pfn));	\
-	}								\
-	newpte;								\
-})
-#endif
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 void paging_init(void);
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index d1f94b8d6312..d870cfadba21 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -3115,6 +3115,24 @@ void flush_cache_vmap(unsigned long start, unsigned long end)
 #endif
 }
 
+/*
+ * mremap() moves the PTEs of [start, end) to addresses that may have the
+ * other color, and calls this on the old range first.  Flush the whole
+ * D-cache so no line of the old color outlives the move.
+ */
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end)
+{
+	/* flush_cache_mm() spills the user register windows. */
+	flush_cache_mm(vma->vm_mm);
+#ifdef DCACHE_ALIASING_POSSIBLE
+	/* The D-cache is virtually indexed on Spitfire and Cheetah. */
+	if (tlb_type == spitfire || tlb_type == cheetah ||
+	    tlb_type == cheetah_plus)
+		flush_dcache_all();
+#endif
+}
+
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..b95eea612261 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1470,10 +1470,6 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 }
 #endif
 
-#ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)	(pte)
-#endif
-
 #ifndef pte_accessible
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac9..2257e3010f41 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -289,7 +289,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			force_flush = true;
 		}
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
-		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))


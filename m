Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827BD606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i2mAkLNk
Received: by kanga.kvack.org (Postfix)
	id 7A1DE6B087B; Tue, 27 Oct 2026 13:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751546B087D; Tue, 27 Oct 2026 13:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619C36B087E; Tue, 27 Oct 2026 13:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3415C6B087B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:51:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF95180A8A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:51:51 +0000 (UTC)
X-FDA: 85369149222.07.5B19030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC977140006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:51:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2mAkLNk;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793123509;
	b=OpXiJmHZnZ3ccGR2ZSyy1PaTmyzUJI7ZnxSf/N1rnyFBFK4RKWqrZcxspIpWgf3kvrBUZo
	SQipxmQC2d5VGnO0yTEjbbn54a7k53M3t+Ca9HRXQkLHjjmzLN72DFKyUjV8+y9oJBLat3
	dknwdc7QtN4eGqUvnwAY3+DREAaYcNU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2mAkLNk;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793123509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cvs2Xtx0PtgOTTn5QWjiXGseQMOAfWpyXw4zUPemHU=;
	b=6TrVfP1LS1L8RWKFb8iOwe7W+OvGOL3fkmk7/0oBdjaYra99KBC21qSZOhMcjcbptel8pW
	6AR2UFgzw8jgvmThjCC/6bdj3gon0i8m+PgSwoF9jvZbjihb16zw2BKzIJLJa+aU1YlozG
	lNFFA7oLdA+gAx3u+sivS3UoEVrNTTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 490876021E;
	Tue, 27 Oct 2026 17:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87591F031E4;
	Tue, 27 Oct 2026 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793123509;
	bh=7cvs2Xtx0PtgOTTn5QWjiXGseQMOAfWpyXw4zUPemHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i2mAkLNkAOGcVlO+4ptBnFYcSi4dqZ1TSD2xVn8AcP7rKLCwmC3J2sSSuDuBSvgBH
	 D/g7md7W5GzJSCvCeWzcBwZK3anh6pj6KH0iFIeLtOwMsSbiPPBngOtyFBOR+C3BBb
	 a+5cqqJtZu6nTLIj7CDBmInXhexR5Os+z6rZk/ACiQXplM/+oE4MFU4ojxZGQnuNgH
	 ig/RPJ9XrTZya4f04qBIKx/9oZNy/gjsTjOvurUGedCYUbh/eSjH9uup00p2VY0aEQ
	 Jc1+g18wCJglWsgZ3vcN1b28ecpIC5IOF/yGgzdY8QoKAHcHtAEO4IJs6pzSmJI4yV
	 9QsSnwqZb9/GQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 878B8198003A;
	Tue, 27 Oct 2026 13:51:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 27 Oct 2026 13:51:45 -0400
X-ME-Sender: <xms:q-Tgane4160Z5m_5kx5S5y1a0nB1H4Bt5lyUT50c_Ely-yKhaBX4Vg>
    <xme:rOTgatrsWjP1MraltGmFvrCJY6l3q8z-EwL-BVHTlDqGo9wDvrNinM8KXaYtmnGS1
    qbmCeZ4hSE5SR4sPpcUFD-kwBcngjEDeAoa0zVCu18Ak1XjxFp3IMfO>
X-ME-Received: <xmr:rOTgah9L3Z_ubKwVisuiLOTIG3BZ5759QE61hHBza21JfPgHX5Q0e7iEDb4>
X-ME-Proxy-Cause: dmFkZTEJ54V2o5886gXoRzsAs4tIMx+vUoNXgQPnAayI3VlBJBmvGOiJUBSG0i7ubLHch7
    0JSiGiwy5lgoftBWGJG0zy4C9NkZdA2vOF9mUL3B7EeOORJ4ronuYngSgrFlXXDC06cx92
    eyEuj6JdAFG/fpBg7FnzXxtPnTMwsB81ldWm5qd5aOYSuDIxHWT2yQ27eM3IYLGVXRK66/
    KCn01kjg9WmPw2c6ZxaF6Hw0yqQDSf3HmXpVZIX2yK/z7Z9NchnGg4ACPo3bhA9cQvFPi6
    JUtXh/FKR5/BoV7TysiI9pnpYh2ldG7/qRJuLit9m1Vao2ILByUDezNgEXKBj6oOQucyr4
    7shXctyr5vOxZrHGDfPPI5M7l1CmLcdabzUyw/CnzHo3ezuHnUxHwIjm1UA1oJostydYVM
    soSXIKaOrdP0FiPJ/nZBWnwFHv5LsLRNN8YhJswcQFses4jUpndRZKSh+HWHVpD6HiX9/j
    uPrwMmrjwbkiPrnFNhT3J7QTVtkJQQckkB07ncoHO1iJSXfx+Snc9CHXv0YBCxpDD518SG
    B03H37qKJmQs0Q7s62Sf0cLjXPa281Zzcto2Be3eHBxkwKBNVfFEqI6PVpKWN3/vwYpbWQ
    R+0GOwGehvrhAkzvFwzCDWQO0UVuE9jBr/CC+ySqi5Zuy8vF3QPkfG20LqLg
X-ME-Proxy: <xmx:rOTgao_99TFsm6eS16DH9tGIA2l2C7k1tF5bQbF5ZA2jXRJMVO9VbQ>
    <xmx:rOTgajHc7hLeYG3BK_3zSCISklNqVcfZFYSN9J7F2UDcGP48n1c6dQ>
    <xmx:rOTgavcBP-3mKNLSEP2QkYZeDmlDHuLcSJeskXJJfDGLNbFWARp1JA>
    <xmx:rOTgaqLSyZso6BWVd8VhtJ2KcCxvjdN4Bie9tPyNzE3PYswIqlYObQ>
    <xmx:rOTgagpOiOtRZAL6-_IvuamoMD6Ob_TDxRTbBGoWRq7CQb0RN3BVeqxk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 13:51:39 -0400 (EDT)
Date: Tue, 27 Oct 2026 17:51:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <auDkbDlgSZxqlk2G@thinkstation>
References: <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
X-Stat-Signature: qy53y95niqdgrattmmyyfc7oxk74o4j6
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC977140006
X-Rspam-User: 
X-HE-Tag: 1793123509-587927
X-HE-Meta: U2FsdGVkX18TY6LV4oXoiH8/GPRyeswEgsiBMyCuxB3+XBhjfSrkcFgbRnB5qO2AxJHezbXfTI0sGJq8rLSmKpNpjj6t8IIyxgHU33Vz+1afAWM0VQ2pD73/brc7BgGjRNyIyd0RD8+kFI3dIy5V3JQLxil/fPu3SUGtiC76gvZWyeguRid4/DtsO8YxeqZDl2Xucgqs7QRO6XevuXZVb3HMU4rfAOq8W1u2bLgiVcZbuCIycPugO+A4/70v8FZBxfyeOUw5pOnIrPFC002yn9RPhkD+wyBMKT9Fn6LJAKBLbQP2d+Wjm1MjIyGNJB/lGrrzGMdWW5ELnvVwRj7EeABECfaSqVpPkAtcvdi301z2WxE9QYNN+WzmOxey5AK1v91HO0+jwfMVfv5BQnjRemLBbTnGZ6p2jUhB5J+sztLJNT1k3vQ6hi4ho/4BQiPfXdEt5C6VY25Ai+B2HFW1erDPVddQXRsmWZd27OIMVxvKktTd02lRDgW2z5QsE3YDDIn7f2e2MhAkceO42CRfgpbUCDh2DxiijbjaNz7tmnKL5reMkiaPlGlgFGfab7CuAOP42Km4uodtAtSXsU2t7+lc7yqmp444bqBhfZibjo9llQeblgOC7EhxTGCLwA8G1c83JXrqP3nLUUFZZjL68JdiRNhyvVQcyBLrXtmspxNBhLWLzaaFL+v3ZPMZi+YxwrMpiXy6sLQxMPOqKrJLX9xbpO+6TdIUb8pGguyMnlTUC4q2zoTwO7bMo2RGuvGvWywy3WD+IkuNL037IuqmWAbiBXrUUJpW9jtQpjAIg44iSUoG4cRFLN1Dx1ek5ZpRHtsdvlPqa1zZlopNA59cnmGXFPCZpZlC1ALANvNCoC934dLuhMJ7Nhl4vhE2fecxvsT3HXhJPvDYn7YC7tFGhauJfOjELAJkpxJob8PIo0xfzdrmYRFlH8Jl3cUirCf0rwIANpTw3NR+TLaBKAj
 coeSbGnt
 7iE7mGZoPZKa4th+K6pKGTuzKMS5eHQsIrnbzQt6Oy4YQwfGHAOt81Mn0X2GvvNhBkTl1U/jSVYhxvIsnPnTOcQtZPUBlCWyE9j+FW7+/UOnjuw4Y+SrHVgOBYpBP8b+IKVTJZ2kJJJ7kVUxzwW5JqT5yfEpvubCu+Vz1YEcFl/DSJSD2pKa8uZUFbQZUubvNaOeBWkonXJdUjZaQ5DhZUdpumL6orzP+Z21t9+J2DIy6XVw5Io2+iGnZnMG2ck98/M+3RbXxPJ8vuYn/bZUom1qJy6h8xRhq23hQv+r2fE7QQeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:03:54PM +0800, Muchun Song wrote:
> Therefore, I am kind of leaning towards removing the RO protection
> and restoring RW permissions to solve the race.

Okay, what about this:

From e23ab850837b53cc79d57d58f1cfb4266e745c3d Mon Sep 17 00:00:00 2001
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Date: Tue, 27 Oct 2026 17:23:47 +0000
Subject: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable

page_ref_add_unless_zero() reads the refcount and then updates it with
a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
scanner, can read a non-zero refcount from a page that is then freed
and reused as a hugetlb tail page.  If HVO remaps its struct page to
the shared tail page in between, the cmpxchg writes to read-only
vmemmap:

    CPU0 (lockless get)               CPU1
    c = atomic_read(&page->_refcount)
                                      page freed
                                      page allocated as a hugetlb tail
                                      HVO remaps the struct page RO
    try_cmpxchg(&page->_refcount, &c, c + 1)
      -> write fault on read-only vmemmap

The refcount is zero by then and the compare fails, but LOCK CMPXCHG on
x86 writes anyway.  The kernel oopses when hugetlb pages are allocated
at runtime with HVO enabled while a lockless get races with it.

Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN
walkers") closed the window with RCU on both sides.  The RCU was removed
together with fake heads, on the wrong belief that it was only needed
for them.

Map the shared tail page writable instead of restoring the RCU.  Every
struct page on it is a tail with a zero refcount, so a late cmpxchg
fails and leaves the page unchanged.  RCU would put rcu_read_lock()
back around every get and synchronize_rcu() back into hugetlb
allocation and freeing.

The cost is the protection against stray writes to tail struct pages.
The shared page is shared by all hugetlb folios of the same order in
the zone, so such a write now corrupts all of them instead of oopsing.

Bootmem folios optimized in early boot get their tails mapped writable
and write protected later.  Drop the write protect step.

Fixes: 32c440d67e6c ("mm: drop fake head checks")
Fixes: 01b1d0ffb6f7 ("hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU")
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/r/ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 Documentation/mm/vmemmap_dedup.rst | 13 +++++++++----
 include/linux/mm.h                 |  2 --
 mm/hugetlb.c                       |  4 ----
 mm/hugetlb_vmemmap.c               | 21 +++++++--------------
 mm/sparse-vmemmap.c                | 23 -----------------------
 5 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 9fa8642ded48..6cd85aca4b96 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -131,8 +131,15 @@ pages of ``struct page`` (page 1 to page 7) are tail pages.
 The optimization is only applied when the size of the struct page is a power
 of 2. In this case, all tail pages of the same order are identical. See
 compound_head(). This allows us to remap the tail pages of the vmemmap to a
-shared, read-only page. The head page is also remapped to a new page. This
-allows the original vmemmap pages to be freed.
+shared page. The head page is also remapped to a new page. This allows the
+original vmemmap pages to be freed.
+
+The shared page is mapped writable. A lockless get of a page reference can
+read a non-zero refcount before the remap and attempt its atomic update
+after it. The refcount of a tail page is zero, so the update fails without
+changing the page. Nothing else may write to the shared page: it is shared
+by all HugeTLB pages of the same size in the zone, and a stray write would
+corrupt all of them.
 
 Here is how things look after remapping::
 
@@ -196,8 +203,6 @@ happens at a later stage when we populate the sections. HugeTLB reuses the
 the head vmemmap page representing, whereas device-dax reuses the tail
 vmemmap page. This results in only half of the savings compared to HugeTLB.
 
-Deduplicated tail pages are not mapped read-only.
-
 Here's how things look like on device-dax after the sections are populated::
 
  +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..bfaf4ce6d831 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5162,8 +5162,6 @@ int vmemmap_populate(unsigned long start, unsigned long end, int node,
 int vmemmap_populate_hvo(unsigned long start, unsigned long end,
 			 unsigned int order, struct zone *zone,
 			 unsigned long headsize);
-void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
-			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(unsigned long start, unsigned long end,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c9..7596704d94b5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3220,10 +3220,6 @@ static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
  * here, or MIGRATE_CMA if this was a page allocated through an early CMA
  * reservation.
- *
- * In case of vmemmap optimized folios, the tail vmemmap pages are mapped
- * read-only, but that's ok - for sparse vmemmap this does not write to
- * the page structure.
  */
 static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 							  struct hstate *h)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143..77f9d035d04c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -222,10 +222,12 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
 		/*
-		 * Remap the tail pages as read-only to catch illegal write
-		 * operation to the tail pages.
+		 * Map the shared tail page writable. A lockless get that read
+		 * a non-zero refcount before the remap can still do its
+		 * cmpxchg after it. The refcount is zero, so the cmpxchg
+		 * fails and leaves the page unchanged.
 		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
 	}
 
 	list_add(&page->lru, walk->vmemmap_pages);
@@ -629,19 +631,10 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-		unsigned long spfn, epfn;
 
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * Already optimized by pre-HVO, just map the
-			 * mirrored tail page structs RO.
-			 */
-			spfn = (unsigned long)&folio->page;
-			epfn = spfn + hugetlb_vmemmap_size(h);
-			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+		/* Already optimized by pre-HVO */
+		if (boot && folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
-		}
 
 		nr_to_optimize++;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5a2469fb1838..3f25d4a0bf47 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -299,29 +299,6 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
 
-/*
- * Write protect the mirrored tail page structs for HVO. This will be
- * called from the hugetlb code when gathering and initializing the
- * memblock allocated gigantic pages. The write protect can't be
- * done earlier, since it can't be guaranteed that the reserved
- * page structures will not be written to during initialization,
- * even if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.
- *
- * The PTEs are known to exist, and nothing else should be touching
- * these pages. The caller is responsible for any TLB flushing.
- */
-void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
-				    int node, unsigned long headsize)
-{
-	unsigned long maddr;
-	pte_t *pte;
-
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		ptep_set_wrprotect(&init_mm, maddr, pte);
-	}
-}
-
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-- 
  Kiryl Shutsemau / Kirill A. Shutemov


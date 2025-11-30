Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4304D116E2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 03:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC576B000D; Sat, 29 Nov 2025 22:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094386B000E; Sat, 29 Nov 2025 22:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBC86B0010; Sat, 29 Nov 2025 22:01:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72EE6B000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 22:01:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88B391A0889
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 03:01:42 +0000 (UTC)
X-FDA: 84165773244.30.B165809
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8728210000D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 03:01:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HKqaHAdw;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764471700;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TtaLooEQ/SHSgMC/pUOWGMxpepCm5694nPuPzDHEdg=;
	b=q9UdGJm1tzMLicnSpMzFowr1HgirQp4yHgNqriVCN3PqnBh7zL1zjWtyEactl0ziHZswov
	6PmVGj72M64VAESDiYYUpMPQezg77RZ2G7ipMyy+6en2gyikEbSSV7rOPu+jA/z22SSAfJ
	rbqJ9S1WQ5SCtUcU97Xkn/KPY6L48Bg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HKqaHAdw;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764471700; a=rsa-sha256;
	cv=none;
	b=JB9cJoOjgAV979EfmvTYrnTSvyRMXemiZm1lELbsWpHJ8IK5HIpy0GveozT+fECA+FvwlG
	clr9ipo6+xFnmVFC7XNEk3lVhGcE05XVyojBX6G0YPt1CbM4OLqmPHRG2z+HHNeTPJ9Klv
	BijhsKqRJWfkVERjXn6HYI9eTGTRXsI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0TtaLooEQ/SHSgMC/pUOWGMxpepCm5694nPuPzDHEdg=; b=HKqaHAdwMjnBw9TsbmQh894nUI
	OipQpKHC+/RWe8GpcnFEksC1ndo7hx5Kwu0zRniDNEr5mxnUkJmtHsVY6Z1OAMJ+cMimytbD2yFRk
	dE5ZBdlVW0FKteHYMIdcUe4xgtM0UJ6WXqwYbgHVh8y4iqTsbDrcO8H4Om7XirN+4wiS1VKJK/QlM
	rH6BfZb03uT0IQz7pQdM8RZUPTy4SRDRX88s2L3IpOWJTCKwD1YD7SuRZk9PIo2kEkM7i6Mqi5U/E
	miuzXyWieNj1K2TB0ekO+fAaIxN8Bs1nJ1g4MCj2T0FzDJrVNM5M7G788VbL6RVBL9ceTeQoDftcQ
	sh81GIiA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPXh4-0000000CPzD-2Cjx;
	Sun, 30 Nov 2025 03:01:46 +0000
Date: Sun, 30 Nov 2025 03:01:46 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130030146.GN3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129033728.GH3538@ZenIV>
X-Stat-Signature: gdr7zpqbush86scoupnt1oxego4xmm6i
X-Rspam-User: 
X-Rspamd-Queue-Id: 8728210000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1764471700-225058
X-HE-Meta: U2FsdGVkX18dT0DVF+Vjy85Ge29D2wYp6MdoBMuTEwfCYJLqRaDyAbHAfoY0AV40ohSSyZc6S7VQQlefoI68scVpg40nAuS/fenfx4ym6Jr1GKfWoDZ07T826NoUQsu3CVwE9nUrsMbnldZNTu2pJYQyTISyiKTGeEP1w67zWflZ5lxf16sDLy6WVxcxP2kwA3Mpme2RR6CtyAXn/gKreKj0iGzzVCkAJpaMb3JqgYZWmcXxZ7VGlGbu8T/S3Zd47Gt4PyE+Il7fOZWiwiEPr2QbTI85tMXAZsui2Kpl1lSSi5Rd0hJQ6evzLp9kJbnBDjXEQslgxWi/rxEGGwSPG57DGE6QXfR8j0yO9A/PaOfNx5yj+6Gm7wT22rzCYlAnXiWTnHH+PT2BhgXqIoYRZRRoX9j4x+dXi6yqtMnEf3q9YI8J+gU1uz8PUXzcBr2Ul5Yub5bVEspkMQt2F1YX/RW3K18VtXanZrRFX0FATFoz7bXM1ilvsCzM9sYNlbNeFo+O7DhO9ijVnMoAcjptnEtua244EtD+gjxiItwsPyGu+ePlVBRh7+xY0sptAGF8WujJF94idDGXw5nvpGY5nl4MvP9bEOpI4VcqFr35e9tIi4kgy+P4T53NlFgZwL6ar22WO6QosYzpbo8odMEdUIPE7GTExclDSigZRg3QwQMO9F6x6WKBEqZk2BiubAi1u3y9BkTC6sAUsS5WOldJ3qvtFgoHrQ4HR/jC5fIaO6BOw7eA83VLTKCBUVuBJxxFMdGmG4hEPOwUDEyaCf6GQxoekupPfHXksCuF1ooVw1Deb8dWTLkUQy24bnVbrK+/fRy/79hO5H78DAoKXiV2TqJg0uCS+g5KnQG9e55H6pWbs6OgGOyD819YKa9Ssl6nxKESX9/KwzVBwLX4HPX6XEP6NnOW4yMb+beCvc05sLvMv2qlcNOgDZwUBb4AfMsVF+Oz05PWC1XIzlgUhV+
 piScD5wE
 BBGnuqAWXwiqkzTbqpkBKr41C5/HzZnFXMliLsYYfZ/94oOC1XGUREKx7baGtI+6aUzy18fHino294HcLZCy157zlbBbQSrlrcM6Ob08q4+IBuN1xInQoB5317xngm5yWKKV8R/68By8XzhZpGJor3lir6cRU/77kxP8LUlPf+YDFq6081+HyNxqD7rIiALS0iLa+qdfumVSd568A3slDlMd0JUryPZ1QmKMA1uizw0TvEoyyFBMsEitpRXFP2OdWY1vD7DWiRI8vWUAATqcSmVklaQFfNJtw1adzbCa6PL+QFpICH8xr6ll1aa929leigF4rdIrXHht94CEol77XM+IdwGVGr2hWG4JuLYxtTa9J0G4NBClqwXDG2Hy3d1qjUPF2I/CWjKp6waf8+Wu8lBUdgvvDdaiWHgJwklUj7ToUjlDaY4iaOGwRtW4z4rhshZ0z4tSobmBMz6yshbR8h1p7jKrxxB5eCiNPFg1nlRdUykfnJXHZUtbIM1xmTIAM11blhQd90kURkLXpo8OWBfXrQG9TyQTqsu83
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 03:37:28AM +0000, Al Viro wrote:

> AFAICS, 32bit arm is similar to 32bit x86 in that respect; propagation
> is lazier, though - there arch_sync_kernel_mappings() bumps a counter
> in init_mm and context switches use that to check if propagation needs
> to be done.  No idea how well does that work on vfree() side of things -
> hadn't looked into that rabbit hole...

BTW, speaking of vmalloc space - does anybody object against sorting
CONFIG_ALPHA_LARGE_VMALLOC out, so that we wouldn't need to mess
with that in alpha page fault handler?

Basically, do what amd64 does - something along the lines of (untested)
patch below.  Comments?

[PATCH] alpha: take the LARGE_VMALLOC kludge out

Support of vmalloc space that won't fit into the single L1 slot had
been a headache for quite a while.

The only things we use seg1 for are virtual mapping of page tables
(at the last 8G) and vmalloc space (below that).  Normal setup has
vmalloc space from -16G to -8G, occupying the penultimate L1 slot.
It is set up (with table sitting just after the kernel image) very
early, by callback_init().  pgd_alloc() copies that entry when
setting a new L1 table up, and it's never changed afterwards.
All page table changes done by vmalloc() are done to tables that
are shared between all threads, avoiding the need to synchronize
them.

It would be trivial to extend that - preallocate L2 tables to
cover the entire vmalloc space (8Kb for each 8Gb of that) and
set all the L1 slots involved before anything gets forked,
then copy these slots on pgd_alloc().  Unfortunately, that
had been done in a different way - only one L2 table is
preallocated, the rest gets created on demand, which means
that we need to propagate changes to threads' L1 tables.
It's kinda-sorta handled in do_page_fault(), but it's racy and
fixing that up would be a major headache.

Bugger that for the game of soldiers - do what e.g. amd64 does
and preallocate these in mem_init().  And replace the bool
ALPHA_LARGE_VMALLOC with int ALPHA_VMALLOC_SIZE (in gigabytes),
dependent upon EXPERT and defaulting to 8.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 80367f2cf821..36cbba4e21d9 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -410,20 +410,21 @@ config ALPHA_WTINT
 
 	  If unsure, say N.
 
-# LARGE_VMALLOC is racy, if you *really* need it then fix it first
-config ALPHA_LARGE_VMALLOC
-	bool
+config ALPHA_VMALLOC_SIZE
+	int "vmalloc space (in gigabytes)" if EXPERT
+	default "8"
+	range 8 2040
 	help
-	  Process creation and other aspects of virtual memory management can
-	  be streamlined if we restrict the kernel to one PGD for all vmalloc
-	  allocations.  This equates to about 8GB.
+	  We preallocate the second-level page tables to cover the entire
+	  vmalloc area; one 8Kb page for each 8Gb.
 
-	  Under normal circumstances, this is so far and above what is needed
-	  as to be laughable.  However, there are certain applications (such
-	  as benchmark-grade in-kernel web serving) that can make use of as
-	  much vmalloc space as is available.
+	  Default is 8Gb total and under normal circumstances, this is so
+	  far and above what is needed as to be laughable.  However, there are
+	  certain applications (such as benchmark-grade in-kernel web serving)
+	  that can make use of as much vmalloc space as is available.
 
-	  Say N unless you know you need gobs and gobs of vmalloc space.
+	  Leave it at 8 unless you know you need gobs and gobs of
+	  vmalloc space.
 
 config VERBOSE_MCHECK
 	bool "Verbose Machine Checks"
diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
index 90e7a9539102..0f554d01fe54 100644
--- a/arch/alpha/include/asm/pgtable.h
+++ b/arch/alpha/include/asm/pgtable.h
@@ -49,11 +49,8 @@ struct vm_area_struct;
 /* Number of pointers that fit on a page:  this will go away. */
 #define PTRS_PER_PAGE	(1UL << (PAGE_SHIFT-3))
 
-#ifdef CONFIG_ALPHA_LARGE_VMALLOC
-#define VMALLOC_START		0xfffffe0000000000
-#else
-#define VMALLOC_START		(-2*PGDIR_SIZE)
-#endif
+#define VMALLOC_SLOTS		DIV_ROUND_UP(CONFIG_ALPHA_VMALLOC_SIZE, 8)
+#define VMALLOC_START		(-(VMALLOC_SLOTS + 1)*PGDIR_SIZE)
 #define VMALLOC_END		(-PGDIR_SIZE)
 
 /*
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index a9816bbc9f34..0bc5fc4d510e 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -111,10 +111,6 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	if (!mm || faulthandler_disabled())
 		goto no_context;
 
-#ifdef CONFIG_ALPHA_LARGE_VMALLOC
-	if (address >= TASK_SIZE)
-		goto vmalloc_fault;
-#endif
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
@@ -225,24 +221,4 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
  do_sigsegv:
 	force_sig_fault(SIGSEGV, si_code, (void __user *) address);
 	return;
-
-#ifdef CONFIG_ALPHA_LARGE_VMALLOC
- vmalloc_fault:
-	if (user_mode(regs))
-		goto do_sigsegv;
-	else {
-		/* Synchronize this task's top level page-table
-		   with the "reference" page table from init.  */
-		long index = pgd_index(address);
-		pgd_t *pgd, *pgd_k;
-
-		pgd = current->active_mm->pgd + index;
-		pgd_k = swapper_pg_dir + index;
-		if (!pgd_present(*pgd) && pgd_present(*pgd_k)) {
-			pgd_val(*pgd) = pgd_val(*pgd_k);
-			return;
-		}
-		goto no_context;
-	}
-#endif
 }
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 4c5ab9cd8a0a..e5eea8b05c7f 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -45,13 +45,10 @@ pgd_alloc(struct mm_struct *mm)
 	ret = __pgd_alloc(mm, 0);
 	init = pgd_offset(&init_mm, 0UL);
 	if (ret) {
-#ifdef CONFIG_ALPHA_LARGE_VMALLOC
-		memcpy (ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
-			(PTRS_PER_PGD - USER_PTRS_PER_PGD - 1)*sizeof(pgd_t));
-#else
-		pgd_val(ret[PTRS_PER_PGD-2]) = pgd_val(init[PTRS_PER_PGD-2]);
-#endif
-
+		for (int i = 0; i < VMALLOC_SLOTS; i++) {
+			pgd_val(ret[PTRS_PER_PGD - VMALLOC_SLOTS - 1 + i]) =
+			pgd_val(init[PTRS_PER_PGD - VMALLOC_SLOTS - 1 + i]);
+		}
 		/* The last PGD entry is the VPTB self-map.  */
 		pgd_val(ret[PTRS_PER_PGD-1])
 		  = pte_val(mk_pte(virt_to_page(ret), PAGE_KERNEL));
@@ -148,9 +145,10 @@ callback_init(void * kernel_end)
 	   On systems with larger consoles, additional pages will be
 	   allocated as needed during the mapping process.
 
-	   In the case of not SRM, but not CONFIG_ALPHA_LARGE_VMALLOC,
-	   we need to allocate the PGD we use for vmalloc before we start
-	   forking other tasks.  */
+	   In any case we need to allocate a PGD we use for vmalloc
+	   before we start forking other tasks.  If vmalloc wants more
+	   than one PGD slot, allocate the rest later (at mem_init() -
+	   it's still early enough).  */
 
 	two_pages = (void *)
 	  (((unsigned long)kernel_end + ~PAGE_MASK) & PAGE_MASK);
@@ -246,6 +244,22 @@ srm_paging_stop (void)
 }
 #endif
 
+void __init mem_init(void)
+{
+	// first slot already filled by callback_init()
+	unsigned long addr = VMALLOC_START + PGDIR_SIZE;
+
+	while (addr < VMALLOC_END) {
+		pgd_t *pgd = pgd_offset_k(addr);
+		p4d_t *p4d = p4d_offset(pgd, addr);
+		pud_t *pud = pud_offset(p4d, addr);
+		pmd_t *pmd = pmd_alloc(&init_mm, pud, addr);
+		if (!pmd)
+			panic("can't preallocate tables for vmalloc");
+		addr += PGDIR_SIZE;
+	}
+}
+
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= _PAGE_P(_PAGE_FOE | _PAGE_FOW |
 								  _PAGE_FOR),


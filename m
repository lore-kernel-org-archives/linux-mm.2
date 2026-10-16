Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7AF6CCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54ADF6B0088; Fri, 16 Oct 2026 15:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBD26B008A; Fri, 16 Oct 2026 15:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBC06B008C; Fri, 16 Oct 2026 15:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2CB56B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:17:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66FB5C056D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:17:51 +0000 (UTC)
X-FDA: 85329449142.06.74992DD
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D30340009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:17:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf12.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792178269;
	b=V27B6RUI9fQ8rE7LLYhGuulZ/+igQcka65QYULXfWvDjChIJRrnPLcReDPkzhKTMk0U7rV
	sNOEPo4iwWbYgPgAzFfF5NfgW9rywyG5U6pR1mUjmeywolLyRN2+bb7bwe6l09HuLkLGMk
	r8QJd4BwdtgWcPl4Aj3bLjaO0QtZaE8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf12.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792178269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=tYDMWR3Kgu96vBoKt1AdwRKY1qaTCGCHODIMs4nqg5w=;
	b=hDTI7b9V3fEdO497pBv3jnPI15spNbS5We+RQfynaCuPRUc4bH3po9l06LTpy8Zfg673DG
	grNVHJlv7nqGVMc4UErFMbW6b4014oTb/h+hoecHIZwORpCzfvwtO4AeFyRokRITR8A2uz
	ZQlPFzuC1mXTkJ4OznPVcAE6+b8WMU8=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHnQw-00G6ng-OX;
	Fri, 16 Oct 2026 15:17:38 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Zong Li <zong.li@sifive.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] riscv: mm: Make ptep_set_wrprotect() atomic again
Date: Fri, 16 Oct 2026 15:17:38 -0400
Message-ID: <20261016191738.791061-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D30340009
X-Stat-Signature: 1xtb35b1gwk59zeyqo1j7eraxd5fknab
X-HE-Tag: 1792178269-682970
X-HE-Meta: U2FsdGVkX1/Qnhw6dXF7+REzsygRt0rpaj5g8pwOOLZNH99+Ep4c68l4vvFXyqzGh50vFtL/FQHCAjC8VmpVnuOOFfaFAJpHVo5vPGXLaUjTsEnYYN5YkMPjh0GkEWjP11qwbm7b4VNDXdHZ4VkldmquR6s6J1fnZU8WHr/LgI+jFUq+/QpXlJlBXS4y/Ko+H3X6Mt5LEmN5zcSWSLlDyVBOf0NUft9Qd0idbrmMmsPg8FSE9yCriZ2p5zT4Qpxs9/GhsU/ZuVQ7HbAgz1wBrGCJ0ECwDTLLFilc0OywNgCcgKnsGQYOFsfEYHhZmqCiDkUZiQigK8hvnaFWqs8DXNB9wRSrj3mI9G80bjqLGEYeYbBgezL/GGALGENbxSXN5s0EvFrkJnDwXSbkDs+D+BXZ5kH/OPKVSc3jfgbjoZ/pH21si+cG3IJPHgWoKYJkCSZChMW9SRZdgFxDgYaJQn1mA3jsISqVp61ilJiqPyIfo0X1JCnhe2ZbqghoTmvXJw0PUTMuNjXXYxPVudxV7Edna6WSehMKCbD1cpQD7hePzLgL61STTlW2FlzImZWAdNqq8810KjI2BgykjcThUcnPOojUkDEMY1s3YWdGbZXLrvF5unCuPFs75mp/UHXOETYyM3l5feKF/AYhdtFYp0ANr23XgpeHTNBgx12rIwigAekWpcU4XkdcSdqkfWZr/X4ADHJIubJ90OLCBNUbzusY8p8BTyl5uaLt4OCemNpHqQms0STpuevI+WnmgjwxCYRD2X6emgxBz1Uavnm27Dfbu0Zp8WAADOc1/zzTCzZmZ1+5vF1SsWArSH+EhLqp3isgUq6AL/Usp8cv2wxd0lYivJtMHUcjk7Gr0m6rOAKXVsQuG+J03qW2LOGvBQytnoXzV5nZ9/5ASLvwgtmNUivPZ/lGPeyXqaEGoNlBLGvt6Cz5WEro63mSLijzOdEJr7weac8j7GlY2C5uvDL
 qKRYaFHS
 84StsDHFTi5O0qi+O9te0nT1aGTJolS4N3USMxyCND/S2AuMN+mzgz8H2nSgoo89RPcelqZbQ1FCxeW0B2DTtiUf9/GLpyjy7GzGwa6BkqBDeLYMERnndmKcG+1J6Fpp35vIq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_set_wrprotect() reads the PTE with READ_ONCE() and writes the
write-protected value back with atomic_long_set(): a plain load and a
plain store. Commit 540de7ade1e1 ("riscv/mm: update write protect to
work on shadow stacks") made it so, replacing the atomic_long_and()
that cleared _PAGE_WRITE in one AMO, because a shadow stack PTE
(XWR = 010) also needs _PAGE_READ set when its write bit is cleared.

The page table lock the callers hold only orders the kernel's own PTE
updates. With Svadu (the firmware sets menvcfg.ADUE) the hardware sets
A and D in the PTE itself, atomically with respect to other accesses
to the PTE, when a hart accesses the page through a valid PTE whose A
or D bit is clear. Such an update between the load and the store of
ptep_set_wrprotect() is overwritten:

  fork(): copy_pte_range(), parent's     another thread of the parent,
  page table lock held                   another hart
  ptep_set_wrprotect():
    old = *ptep              (V=1 W=1 D=0)
                                         store to the page: the walker
                                         sets D=1 in the PTE
    *ptep = (old & ~W) | R   (V=1 W=0 D=0)

The store has reached the page, but its PTE now says the page is
clean. The parent's writable TLB entries are flushed only after the
whole page table has been copied (flush_tlb_mm() in dup_mmap()), so
the window is open for every PTE that fork() write-protects. The same
function also write-protects PMDs (pmdp_set_wrprotect(), used by
copy_huge_pmd()) and non-NAPOT hugetlb PTEs (huge_ptep_set_wrprotect()).

A valid, writable, clean user PTE is what MADV_FREE leaves behind:
madvise_free_pte_range() clears D and keeps W (clear_young_dirty_ptes()),
and the next write to the page is meant to set D again so that reclaim
keeps the page. When that D bit is lost here, try_to_unmap_one() finds
the PTE clean and does not mark the folio dirty, and
ttu_anon_lazyfree_folio() discards the page: the data the other thread
wrote is gone and the next access to the page reads zeroes. An
anonymous page in the swap cache whose PTE lost D is likewise reclaimed
without writeback and the next fault reads the stale copy from swap. A
lost A bit only misleads page aging.

Hitting this takes a multi-threaded process that forks while another
thread writes to such a page, on hardware that implements Svadu (or
QEMU with svadu=on) with firmware that enables it. Without Svadu a
write to a clean PTE faults and the fault handler sets D under the same
page table lock, so there is no race. A program that applies MADV_FREE
to a 16 MiB private anonymous mapping, forks while three threads store
to its pages, and then reclaims the mapping with MADV_PAGEOUT loses
the stored data on an unmodified kernel under QEMU (-cpu max,svadu=on):
107 pages read back as zeroes in 105 of 3000 iterations.

x86 (ptep_set_wrprotect(): "Use cmpxchg() to prevent races with the
hardware setting Dirty=1") and arm64 (___ptep_set_wrprotect(), against
DBM) use a cmpxchg loop for exactly this. Do the same here: compute
pte_wrprotect() of the value read and install it with try_cmpxchg(),
retrying if the PTE changed in between. pte_wrprotect() is the same
"& ~_PAGE_WRITE | _PAGE_READ" the function computed by hand, so the
shadow stack encoding is preserved; ptep_get_and_clear() in the same
file already updates the PTE with xchg(). With this change the program
above loses no page in 3000 iterations, nor in a test build with a
delay inserted between the load and the cmpxchg, where the unpatched
function loses pages in more than half of the iterations.

Found while formally verifying copy_page_range() against the kernel
binary.

Fixes: 540de7ade1e1 ("riscv/mm: update write protect to work on shadow stacks")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    The reproducer below needs no privileges: a 16 MiB private anonymous
    mapping, MADV_NOHUGEPAGE, is written and MADV_FREE'd each iteration
    (valid, writable, clean PTEs); the main thread then forks (the child
    exits at once) while three threads each store once to every third
    page, sweeping down from the top of the mapping into fork()'s upward
    sweep of the page table; afterwards MADV_PAGEOUT reclaims the mapping
    and every page is read back. A lazyfree page whose PTE lost D is
    discarded and reads as zeroes. Each page is written exactly once per
    iteration: a second store would take the write fault after fork()
    protected the page and set D again, hiding the lost update.
    
    Runs on 70dd4ee72eb2, riscv defconfig built with LLVM=1, under
    qemu-system-riscv64 10.2.1 (-M virt -cpu max,svadu=on -smp 4 -m 1G,
    the bundled OpenSBI fw_dynamic, which sets menvcfg.ADUE), reproducer
    as /init in an initramfs:
    
      unpatched:   122 pages lost in 120 of 3000 iterations
      patched:     0 pages lost in 3000 iterations
    
    Reproducer (needs Svadu: qemu -cpu max,svadu=on):
    
      riscv64-linux-gnu-gcc -O2 -static -pthread -o lost_dirty_min lost_dirty_min.c
      ./lost_dirty_min      # prints "N pages lost in 3000 iterations", exit 1 if N > 0
    
    /* fork() vs hardware dirty-bit updates (Svadu): a store whose D-bit update lands
     * between the load and the store of ptep_set_wrprotect() has D cleared again;
     * MADV_PAGEOUT then discards the lazyfree page and it reads back as zeroes. */
    #define _GNU_SOURCE
    #include <pthread.h>
    #include <stdatomic.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <sys/wait.h>
    #include <unistd.h>
    
    #define ITER	3000
    #define PAGES	4096UL	/* 16 MiB */
    #define PAGE	4096UL
    #define WRITERS	3	/* needs WRITERS + 1 CPUs */
    
    static char *region;
    static atomic_long gen;
    static atomic_int done;
    
    /* store once to every WRITERS-th page, sweeping down into fork()'s upward sweep */
    static void *writer(void *arg)
    {
    	unsigned long id = (unsigned long)arg, i, spin;
    	unsigned int seed = id + 1;
    	long it, seen = 0;
    
    	for (;;) {
    		while ((it = atomic_load(&gen)) == seen)
    			;
    		seen = it;
    		for (spin = rand_r(&seed) % 1000000; spin; spin--)
    			__asm__ __volatile__("" ::: "memory");
    		for (i = PAGES; i-- > 0;)
    			if (i % WRITERS == id)
    				*(volatile long *)(region + i * PAGE) = it;
    		atomic_fetch_add(&done, 1);
    	}
    	return NULL;
    }
    
    int main(void)
    {
    	unsigned long it, i, lost = 0;
    	pthread_t t[WRITERS];
    	pid_t pid;
    
    	region = mmap(NULL, PAGES * PAGE, PROT_READ | PROT_WRITE,
    		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    	madvise(region, PAGES * PAGE, MADV_NOHUGEPAGE);
    	for (i = 0; i < WRITERS; i++)
    		pthread_create(&t[i], NULL, writer, (void *)i);
    	for (it = 1; it <= ITER; it++) {
    		unsigned long bad = 0;
    
    		memset(region, 1, PAGES * PAGE);		/* writable, dirty PTEs */
    		if (madvise(region, PAGES * PAGE, MADV_FREE))	/* now valid, writable, clean */
    			return perror("MADV_FREE"), 2;
    		atomic_store(&done, 0);
    		atomic_store(&gen, it);
    		pid = fork();
    		if (pid == 0)
    			_exit(0);
    		waitpid(pid, NULL, 0);
    		while (atomic_load(&done) != WRITERS)
    			;
    		if (madvise(region, PAGES * PAGE, MADV_PAGEOUT))	/* clean lazyfree pages are discarded */
    			return perror("MADV_PAGEOUT"), 2;
    		for (i = 0; i < PAGES; i++)
    			bad += *(volatile long *)(region + i * PAGE) == 0;
    		if (bad)
    			printf("iteration %lu: %lu pages lost\n", it, bad);
    		lost += bad;
    	}
    	printf("%lu pages lost in %d iterations\n", lost, ITER);
    	return lost != 0;
    }

 arch/riscv/include/asm/pgtable.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 40b1ed4f3ea8..7bce81244ddb 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -685,15 +685,20 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pte_t *ptep)
 {
-	pte_t read_pte = READ_ONCE(*ptep);
+	pte_t old_pte, new_pte;
+
 	/*
 	 * ptep_set_wrprotect can be called for shadow stack ranges too.
 	 * shadow stack memory is XWR = 010 and thus clearing _PAGE_WRITE will lead to
 	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
 	 * but we dont want this wrong configuration to be set in page tables.
+	 *
+	 * Use cmpxchg(): with Svadu the hardware sets A and D in the PTE concurrently.
 	 */
-	atomic_long_set((atomic_long_t *)ptep,
-			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
+	old_pte = READ_ONCE(*ptep);
+	do {
+		new_pte = pte_wrprotect(old_pte);
+	} while (!try_cmpxchg(&ptep->pte, &pte_val(old_pte), pte_val(new_pte)));
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0



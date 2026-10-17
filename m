Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0555ACCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17AA36B008A; Sat, 17 Oct 2026 12:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C4A6B008C; Sat, 17 Oct 2026 12:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042126B0092; Sat, 17 Oct 2026 12:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB0946B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:22:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2BF1A7BE0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:22:40 +0000 (UTC)
X-FDA: 85332636480.26.A5CEA53
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D224180008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:22:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792254159;
	b=4Q9E9Xw+2allBxnShdfgrGb4badOQN6631vtss8h0xULZ7JfeSzXOKjswu75wyHmcZ1Hxg
	q5F/xwPZuueYJhoay9KrKHR8w6bvtHhCqrJINYyf8WhMgMFNGHR9w/cBbva4fFcxyR7HqB
	d0Jkq1aTnmoUCrstasw2QMBT0PvT5Nc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792254159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Yzpe8Z2g6dupaSpT9arL+DQrNBdB9Nb+5CPnNMczT8Q=;
	b=IVTopVpB2Z4Sh1fw9MmDLIiZ0OcPbjP84lPiL2ngKhPGU3EYjWGPFPpVsn65ubZW5ha5wT
	TbHzPn5l0SCsLyHS003n4Ew0w1SuhYRQcR12gu5Fnm+Gy3+wxRC8NatdCkHecWrehh+Xz7
	7Qyg5q1xd/t0nT499mw9g9m+7IZs5Rw=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xI7Az-002THc-B7;
	Sat, 17 Oct 2026 12:22:29 -0400
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
Subject: [PATCH v1] riscv: mm: Do not make execute-only PTEs readable in pte_wrprotect()
Date: Sat, 17 Oct 2026 12:22:28 -0400
Message-ID: <20261017162229.796020-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D224180008
X-Stat-Signature: byion4qja64swrdhih5igsqtx46yusfj
X-Rspam-User: 
X-HE-Tag: 1792254159-631473
X-HE-Meta: U2FsdGVkX1/+mNF7/MaqQxtSSKshpnbDk6hzTJreO6QxgffBKehWLHlAVoFKyPwHZtYZYAhf/gLSoPF/8ieiQPKW2uVOLX8T+fruLUFUV8+wj8yrZw0gE8GbLxX0Xgu0vQnYAlC+IcEyD4ycQpR6EjN4k6fQNhrULufbE4wRsXkJlWtzqQjgYXScoDKs4B83lRBXuAHWFQk6OtsB3G5Y2bdNYlV4YP4LgBewbxnIG2VVBu02A3uaWUFGgJLXlONojC2Q7j82kBCjuZ1mho3nh9a9HTqJi09s9QabxtALgwS/+N1zdaf5TVQ/II0u5SGTMewMLtIiJD4mwvPEcttx3ITELQTKePpISp/d4RGtLX0ZGEKK4fxVH9D3wgo8HL55ZXF//YwksvQfvPp4xrynRMPKzhcscPZTsXLJPCbo97czvsIWcM+xt6rSzxYEt+7k9NgqwsD7X4Yp3BMTW939M9onDnJkcyRHdkszo7lC/J64zlbe+QovMEIkHbzMcLcg9p+OP8eDHQLfNWXioZO6VcWag3j22XEU5EBHM6MujLNiHjjndKxddhQ3MAk+i1h+Gz7Cs9NVMHSP86ZbHRXj04f/48SJC3N3q1jmQLGc8Gh8DKDgPb79p31k49Y/xtiKwSyqNOb4gMvmGDsuto8kDaRQejjCIXsY4W2mMX/ee7GT9YRCbW016VlY0R66uw4s/7x5MEha7hQZEY8Zt3KP8Yjj4zmCthXlXfi1B3WOQt9Mfou4W6uUXIB2jgbAPhOnfRAh7pQUm4Ecic+GfJq4eTycXD3z71Lkaamgil9IwX4B23sN03lELemF4xDI6GGcMGb8myAmQvbbbeL+v5r5ojABp0GYibm63ljLr1TPQIrDmCV905D19xQ2eRrB4HF2pkbD8QEZRWMqzHbTOO9G8cOfkSYz7UHRrBoC9DPUTY4ejyOsVli7XiXtxR3P7zmmqdKW/DjJKmMr+H/UnlT
 KdN5+WlQ
 5aNcYOlBU/Cvz2+JwDsbVCGGy4LDj3su9ITMyVbXSD7s3JWeIq5SJumo44XkTq2pJCK3czvdRU+4rwX26rVrq2W7tn37fwynurE4DLybnM3Bs8JGgEWj/XYV2MS6KxnT5x62+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On riscv, a user page mapped execute-only becomes readable when the
kernel write-protects its PTE. An unprivileged process that writes to
a MAP_SHARED file mapping, changes it to PROT_EXEC with mprotect() and
then has the page written back (msync(), or any writeback of the file)
can read the page afterwards, although every load from it faulted
before the writeback; the same happens to an execute-only anonymous
THP in the parent and the child of a fork(). The mapping stays
readable until the next mprotect(). Nothing else breaks, but
execute-only memory loses its point: code that relies on it not being
readable from user space can be read. This affects every kernel since
v7.0.

Since commit 540de7ade1e1 ("riscv/mm: update write protect to work on
shadow stacks"), pte_wrprotect() sets _PAGE_READ unconditionally, so
that a shadow stack PTE (XWR = 010) becomes XWR = 001 rather than the
non-leaf encoding 000. That commit assumed that every other PTE it is
applied to already has _PAGE_READ. Execute-only PTEs (XWR = 100,
PAGE_EXEC, used for PROT_EXEC mappings) do not, and pte_wrprotect() is
applied to PTEs that are not writable: the writeback path
folio_mkclean() -> page_vma_mkclean_one() write-protects every present
PTE that is dirty or writable, and mprotect() keeps _PAGE_DIRTY in the
PTE (_PAGE_CHG_MASK), so a written page that was made execute-only is
turned into XWR = 101. copy_huge_pmd() write protects an anonymous huge
PMD whether or not it is writable, through pmdp_set_wrprotect() ->
ptep_set_wrprotect() for the parent, which open-codes the same
expression, and pmd_wrprotect() for the child.

Set _PAGE_READ only when the PTE is writable, which is the shadow stack
case the bit was added for (a writable PTE without _PAGE_READ is only
ever a shadow stack PTE), and use pte_wrprotect() in
ptep_set_wrprotect() instead of repeating the expression. For a PTE
that is not writable pte_wrprotect() is a no-op again, as it was before
540de7ade1e1.

Tested under QEMU (riscv64 virt, defconfig with an ext4 disk): after
write, mprotect(PROT_EXEC) and msync(MS_SYNC) a load from the shared
file page succeeds without this patch and faults with it; with
CONFIG_TRANSPARENT_HUGEPAGE the execute-only anonymous THP is readable
after fork() without this patch and not with it.

Fixes: 540de7ade1e1 ("riscv/mm: update write protect to work on shadow stacks")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    The second hunk (ptep_set_wrprotect()) conflicts with "riscv: mm: Make
    ptep_set_wrprotect() atomic again" (posted 2026-10-16), which already
    computes the new PTE with pte_wrprotect(); if that patch is applied
    first, only the pte_wrprotect() hunk of this one is needed, and the
    fork/THP case is fixed through it.
    
    Reproducer (riscv64; the file case needs a block-backed filesystem such
    as ext4, the THP case CONFIG_TRANSPARENT_HUGEPAGE; no privileges):
    
        /* An execute-only mapping must not become readable through writeback or fork. */
        #include <fcntl.h>
        #include <setjmp.h>
        #include <signal.h>
        #include <stdio.h>
        #include <sys/mman.h>
        #include <sys/wait.h>
        #include <unistd.h>
    
        static sigjmp_buf env;
    
        static void segv(int sig)
        {
        	siglongjmp(env, 1);
        }
    
        /* 1 if a user load from p succeeds */
        static int readable(volatile char *p)
        {
        	if (sigsetjmp(env, 1))
        		return 0;
        	(void)*p;
        	return 1;
        }
    
        int main(int argc, char **argv)
        {
        	const char *path = argc > 1 ? argv[1] : "/mnt/xom";
        	size_t thp = 2UL << 20;
        	int fd, bad = 0;
        	char *p, *a;
    
        	signal(SIGSEGV, segv);
    
        	/* Shared file mapping: write, make it execute-only, write back. */
        	fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0600);
        	if (fd < 0 || ftruncate(fd, 4096))
        		return perror(path), 2;
        	p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
        	if (p == MAP_FAILED)
        		return perror("mmap"), 2;
        	p[0] = 1;
        	mprotect(p, 4096, PROT_EXEC);
        	printf("file: before msync readable=%d\n", readable(p));
        	msync(p, 4096, MS_SYNC);
        	printf("file: after msync  readable=%d\n", readable(p));
        	bad |= readable(p);
    
        	/* Anonymous THP: write, make it execute-only, fork. */
        	a = mmap(NULL, 2 * thp, PROT_READ | PROT_WRITE,
        		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        	a = (char *)(((unsigned long)a + thp - 1) & ~(thp - 1));
        	madvise(a, thp, MADV_HUGEPAGE);
        	a[0] = 1;
        	mprotect(a, thp, PROT_EXEC);
        	printf("thp:  before fork  readable=%d\n", readable(a));
        	if (fork() == 0)
        		_exit(0);
        	wait(NULL);
        	printf("thp:  after fork   readable=%d\n", readable(a));
        	bad |= readable(a);
    
        	printf("%s\n", bad ? "FAIL: execute-only page became readable" : "PASS");
        	return bad;
        }
    
        riscv64-linux-gnu-gcc -O2 -static -o xom xom_min.c
        ./xom /mnt/ext4/xom
    
    Before (mainline 70dd4ee72eb2, defconfig + THP, QEMU virt):
        file: before msync readable=0
        file: after msync  readable=1
        thp:  before fork  readable=0
        thp:  after fork   readable=1
        FAIL: execute-only page became readable
    
    After:
        file: before msync readable=0
        file: after msync  readable=0
        thp:  before fork  readable=0
        thp:  after fork   readable=0
        PASS

 arch/riscv/include/asm/pgtable.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 40b1ed4f3ea8..872b8b6a944b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -406,7 +406,11 @@ static inline int pte_special(pte_t pte)
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte((pte_val(pte) & ~(_PAGE_WRITE)) | (_PAGE_READ));
+	/* Shadow stack is XWR = 010: keep a leaf by making it readable */
+	if (pte_val(pte) & _PAGE_WRITE)
+		pte = __pte(pte_val(pte) | _PAGE_READ);
+
+	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
@@ -692,8 +696,7 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
 	 * but we dont want this wrong configuration to be set in page tables.
 	 */
-	atomic_long_set((atomic_long_t *)ptep,
-			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
+	atomic_long_set((atomic_long_t *)ptep, pte_val(pte_wrprotect(read_pte)));
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0



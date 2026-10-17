Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F27CCA46C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 01:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55BDD6B0088; Fri, 16 Oct 2026 21:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CCB6B008A; Fri, 16 Oct 2026 21:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422476B008C; Fri, 16 Oct 2026 21:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC02E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:36:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6B591C1DB6
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:36:44 +0000 (UTC)
X-FDA: 85330403928.19.26C2FFC
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45B47180004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:36:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792201003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jVyH8NTPHMphwzzq8kFluBrhgfFXhROpmfg+vYPAzzQ=;
	b=e+5Pd8zy+iOBbmHek/23GVAh+GdZo3304tv2T3PcefYC8gy2YAUVPvNxjlfyK+giu7Uh4e
	f7lc4mfMkHGnNtZx8bM5UGoYgBEnCi41aIZ6FzdD0ag3TG+uJAw5/4rUsjVN8xcnR9mZO9
	mwTVTvyx5mg3FNeMHzd8UGLt5HJr6Cs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792201003;
	b=tTCDzN2Z+MFBynLU2TVPpvSg4o0XtXX8c2nRUV529kNuas+2Tt7KTjolC7t+QFIXaSBhnc
	OLjDH4pJHf/bJiHBIZbooiETe+lh6XmmmMag5d5I59pRIvFP33Zskp4wU9dNoKiqa11c6f
	VC0F3m+GD3EJSfnfapzyS6/IcavCWUQ=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHtLe-00HJES-F9;
	Fri, 16 Oct 2026 21:36:34 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Waterman <andrew@sifive.com>,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] riscv: mm: Skip the icache flush for special PTEs
Date: Fri, 16 Oct 2026 21:36:34 -0400
Message-ID: <20261017013634.792220-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cn596itx1iznmo3sitzxmuhj48yso9zm
X-Rspamd-Queue-Id: 45B47180004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792201003-771585
X-HE-Meta: U2FsdGVkX19rmi2D38h0KbMyFN+ZPBXiaTZsoFqJz1DP95cyzMsRUD38yyluvkOvxKmYzelExZN4w6N1HvK7htdNqlWfs4JmhQ6Q/KA2kEa8fyPD3ewT44fSt2BMBA8W5/GRykUjbPK5ezu0vfkK6WfJnSgL7izFPwKOF+3H5h9KY4Kxtri96kZZ0U9ENMPlIdU2vV1ZNqwwzyoBKTaElI1yrsl5Ygt6tstyUo6TLt2M9aWx3Cm2ImPsN4f4QWrgitPqu9/1pRS+b/a2MhgzZCsQCtun1cwBmeS9Ulzc+X9vVKVI5DbGD5L1oclx4bbP70ZYqlnGPkAAybUuqNmjh7Vj4WPaY9Y6d5+l3WfwlPL/sMGQjmYdm/Cc113xrq85IkF3L/knIm2uIX1Q5pwKSH+mDOOi1AFRcVKijkrNStxpsegKK9CDd2QOi6y5K92zRwvz22uq2eGwZmT70rX+BK550adZkpn++gDhiKTnA9+qGT3t3PfU7ZpHfjLOy7RbMdPzEROXab48EvrKfwAhJlVNjmTut0COD1VsKDpOOMKiCt5RbjdsFzmPwgCmnQ7Z1FSNhmRHYeqLTErqACScipHTBVCjqBTZ7KnVkBzJIhX8dfS/NcI+4xHpU+ASOCg8zM2nL2+HERTVQF6pNH61s0EfksEI873ELF/puEES6qtkqCbkXcNWebspMLMuWnq47GthiUCJyyLCfW/rBwQWriBhJT5kmRb/sUmo+GG67zCQarVpQ9MQp7Cqu5t4S6Lk/7UhhpksGI2rgQDbUi8i65MriM/oInT3KHLGrnCcykRVCVoMuQQUYNGeWCObwKmjFZ4OL8DLuxSrEdlXFVhji3uJ0mXaV+IQ361K0Peex1/lJPKJW3M1mzRdDaWZdAzR/hy86tlXBcoe1pxAmktDzeUp4eFQm6xXCnNTo/+NZpWdoZrMndCi/Q8FLOQoBd/Bk4J7HRbIgPk4zD1WwW1
 xypUa1LP
 FmoE3NDL8Oi2/AtZIo/6wd3M0z3zde/nfUoZ422ffArI/zqXfiGjod7PI7HqIk4nnNvdkWOggDX1ZVFMwPETejaz6NLhyT1zfuIYFTA2cDJkGNq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mapping device memory executable crashes the kernel: an mmap() with
PROT_EXEC of a physical range outside RAM, from /dev/mem, from a PCI
BAR's sysfs resource file, from a frame buffer or from any driver whose
mmap() uses remap_pfn_range(), io_remap_pfn_range() or vmf_insert_pfn(),
oopses in flush_icache_pte() with the page table lock held; the task
never completes its exit and its parent's wait() hangs. On QEMU virt
with the riscv64 defconfig of v7.3-rc7, mapping the PCIe ECAM window
from /dev/mem:

mmap(/dev/mem, phys 0x30000000, PROT_READ|PROT_EXEC, MAP_SHARED)
Unable to handle kernel paging request at virtual address ff1c000000c00008
Oops [#1]
epc : flush_icache_pte+0x74/0xa0
 ra : do_remap_pfn_range+0x2b2/0x3ee
...
note: test[52] exited with preempt_count 2

With CONFIG_FLATMEM (32-bit, or a 64-bit configuration without
SPARSEMEM) nothing faults: pte_page() of a pfn outside RAM is a pointer
outside mem_map, and flush_icache_pte() tests and sets a bit of whatever
memory it lands on. The privilege needed is that of the device file
(root for /dev/mem and the PCI resource files). Present since the port
was merged (v4.15).

__set_pte_at() calls flush_icache_pte() for every present executable
PTE. flush_icache_pte() does the flush once per folio: it takes
page_folio(pte_page(pte)) and tests and sets PG_dcache_clean. A special
PTE (pte_mkspecial(), what remap_pfn_range() and vmf_insert_pfn() write
into a VM_PFNMAP mapping) maps a frame the kernel does not manage as a
page: there is no struct page behind it, so pte_page() returns a vmemmap
address with no memory section, or with FLATMEM a pointer outside the
array.

Skip the flush for special PTEs, as arm64 does since
commit 71fdb6bf61bf ("arm64: Do not synchronise I and D caches for
special ptes"). These mappings are device memory or buffers the kernel
never wrote code into on the user's behalf; a user that writes code
into one and executes it has to flush with the cache flush system
call, as for any memory it writes itself.

Found while formally verifying remap_pte_range() against the kernel
binary.

Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executable")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Every pte_special() PTE goes through this path: remap_pfn_range() and
    io_remap_pfn_range() (remap_pte_range() writes pte_mkspecial(pfn_pte())),
    vmf_insert_pfn() (insert_pfn()), and the huge variants through
    set_pmd_at()/set_pud_at(), which also land in __set_pte_at(). The
    pte_special() bit is _PAGE_SPECIAL (RSW bit 8) on every riscv
    configuration; ARCH_HAS_PTE_SPECIAL is selected unconditionally.
    
    Non-special PTEs are unchanged: anonymous, page cache and
    vm_insert_page() mappings keep the per-folio flush. A RAM-backed
    VM_PFNMAP mapping (dma_mmap_coherent() of an allocated buffer, /dev/mem
    over RAM) loses the flush it used to get; nothing in the kernel writes
    instructions into such a buffer for userspace to execute, and the
    PG_dcache_clean state of those pages was never maintained for that use.
    
    Reproducer (QEMU virt, riscv64 defconfig, as /init with /dev/mem c 1 1
    in the initramfs; the PCIe ECAM window is at 0x30000000, any non-RAM
    range does):
    
      riscv64-linux-gnu-gcc -O2 -static -o test exec_mmio_mmap.c
      qemu-system-riscv64 -M virt -cpu max -smp 2 -m 1G -nographic \
          -bios /usr/share/qemu/opensbi-riscv64-generic-fw_dynamic.bin \
          -kernel Image -initrd initramfs.cpio -append "console=ttyS0 rdinit=/init"
    
      unpatched: Unable to handle kernel paging request at virtual address
                 ff1c000000c00008, epc : flush_icache_pte+0x74/0xa0,
                 ra : do_remap_pfn_range+0x2b2/0x3ee; the task never exits
      patched:   mapped at 0x7fffab55d000, first word 0x00081b36
                 (the host bridge's vendor and device ID)
    
      #include <fcntl.h>
      #include <stdint.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <sys/mman.h>
      #include <unistd.h>
    
      int main(int argc, char **argv)
      {
      	unsigned long phys = argc > 1 ? strtoul(argv[1], NULL, 0) : 0x30000000UL;
      	volatile uint32_t *p;
      	int fd;
    
      	fd = open("/dev/mem", O_RDONLY | O_SYNC);
      	if (fd < 0) {
      		perror("open /dev/mem");
      		return 2;
      	}
      	printf("mmap(/dev/mem, phys 0x%lx, PROT_READ|PROT_EXEC, MAP_SHARED)\n", phys);
      	fflush(stdout);
      	p = mmap(NULL, 4096, PROT_READ | PROT_EXEC, MAP_SHARED, fd, phys);
      	if (p == MAP_FAILED) {
      		perror("mmap");
      		return 2;
      	}
      	printf("mapped at %p, first word 0x%08x\n", p, p[0]);
      	return 0;
      }

 arch/riscv/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 40b1ed4f3ea8..7a4d60ccabb0 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -628,7 +628,8 @@ void flush_icache_pte(struct mm_struct *mm, pte_t pte);
 
 static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
 {
-	if (pte_present(pteval) && pte_exec(pteval))
+	/* A special PTE has no struct page for flush_icache_pte() to track. */
+	if (pte_present(pteval) && pte_exec(pteval) && !pte_special(pteval))
 		flush_icache_pte(mm, pteval);
 
 	set_pte(ptep, pteval);

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0



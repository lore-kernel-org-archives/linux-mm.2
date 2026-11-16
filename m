Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8953606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 02:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB93F6B00EF; Sun, 15 Nov 2026 21:24:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A056B05B0; Sun, 15 Nov 2026 21:24:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F756B05B1; Sun, 15 Nov 2026 21:24:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857476B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:24:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A7FD160871
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:24:41 +0000 (UTC)
X-FDA: 85439388762.08.4921E65
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56142A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:24:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794795879;
	b=clyitiR8ntO+Z7z0/TKrcUCkCpAmMekC0cZYC62vhGJwDX4X1sbLfoC63rw3PxlE6Ti6Im
	gmbaoWQOhDodrNn+wgmLbKyKbcKAWSh8oGgkIP2ekyYiaz9cNAHkRfq+Fy87khrkMYR2il
	clDAVPKjRoAQVitp8Gzsan8nsVZn7M0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794795879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LsKScfO0dJa2srmU76Dlr1zeKCRPz7xQofnlV4WBL/E=;
	b=ossZdfAAjKnejnbTh2XmSq+QUOnpRR4bBxBwnYOU8mRjzgKmIvsYNPtukvF6NuJwD5MVCo
	6TFEheOmQk4nHbKwv+/HgF1riPNeAIwtV60DFz5jVY/LjDLalN8IDs/t90iH2nkJZ3WlMp
	nwzDNevallrtY8F6vh3phJ5dbhwh/jw=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xSmOX-004BHZ-Ne;
	Sun, 15 Nov 2026 21:24:33 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Waterman <andrew@sifive.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] riscv: mm: Skip the icache flush for special PTEs
Date: Sun, 15 Nov 2026 21:24:33 -0500
Message-ID: <20261116022433.49952-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56142A0002
X-Stat-Signature: kn1myjhjxdptqf9ac85fi1xshq8my89j
X-Rspam-User: 
X-HE-Tag: 1794795879-461902
X-HE-Meta: U2FsdGVkX19VTRsPdOoD8g+KtT4qY0L6VrBvaXlJ1lYmdu/quodYGOOpMsSgnWfa+e97uaXA+OmZkEsgVfWQfCrlVspHmLR2M8uLQxYxPthyDAbfkq+Z484CNvmDQNGEXhW1D2F5Pp1AM6AWvC9f1cCcTJubIM3CFEWu65nLG71Wry2ekxau8N6ox3rjdwtIh55TZZyAC3KKW6UtP7IGHv/qFrKOsQkYOrgeY6MspIRr3gGNWruaT51xbpgT4yS+ww+63bBP0troMFb9KkxS55t4aGcw580tv9dwpcwb34zNiX+0/IO4g4mFoPBfDa76UJWH8AqzJduOmfiZeQTK5MhETXLzHbRRVRGQyZJGRmGSmbiyIw/agpXYSsXsQpb3ISJF76O8mrmVWunXbOraYqIfNprls8XJTND2N9lcq1vnLEBruiDln7JWwPlB7yMlZRgf+LWylbbKqhcgWdJwuBLBGs63sUmmsSW8UA1aIRhTvv6AsEnVcXL4+W9UUQiR29XHyx/WqBrEsr4q1QovVSXKIfISz19xighRnrqb6HO2Rvpe0Q3bah5NA4ovp7DmKctTxPK1vXb9LogOKgBbhL7BAdjYRrsyi5CoRYR9hJ54i9Fj7FTgnjMNIsjVkKm7kg+jO8alDik5GyZal18JsEgAkuT9HUAIwSLkDjmyd7rScJNXxItjYGGUWFMoOuzqKbDdjlFNtYlT/7rUxu+xWgrU+c9nZzi5pMYpkjK9Hi+JW6g3mU+HJj3QhxGykYD8JOZas/ZMdzvJNl/Nm9Ar5WjgSRv1uz1rXs43CM3EXNaFrGi5Gb7PNPL0Mhzq/3bhDGXfD02epA34E+spuZsFSS6vHAUyMyU4AW+rqLUm4lfkPcvgbzF+9MxyXeOU9m49ZWkG77n/qv+HWfpug4k5DaIIofAI7lURJp7QXLwbOWavaCZTAS+sl7iL8Mf43SySkV8TTv+LMh90UZePcYX
 Xw7vm7bd
 63/UBh8rQLNVSSX5V+zCXQNtg9GCQZ1IkGTicQyFL4x5eq7oiZYS/m4yT4BZtVwVVaHtqD8VL/+Q6S/xq86PwhRwe702pjc7G9tqZdfYIB7cYRETHVW++NLA7yIAtwuTSlqsdyIeseF6jCzIzwGx1lSOR3t6nDo2NWRwe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An executable mmap() of memory outside RAM through remap_pfn_range() or
vmf_insert_pfn(), such as /dev/mem or a PCI BAR's sysfs resource file,
oopses in flush_icache_pte() with the page table lock held, and the task
never exits. With FLATMEM the kernel instead sets a bit in whatever
memory lies past mem_map.

__set_pte_at() calls flush_icache_pte() for every present executable
PTE, and flush_icache_pte() records the flush in the folio of
pte_page(). A special PTE may have no struct page behind it.

Skip the flush for special PTEs, as arm64 does since
commit 71fdb6bf61bf ("arm64: Do not synchronise I and D caches for
special ptes").

Reproduced on QEMU virt with the riscv64 defconfig by mapping the PCIe
ECAM window from /dev/mem with PROT_EXEC; the patched kernel maps it.

Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executable")
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Changes in v2:
    - Reworded the source comment as suggested by Jisheng Zhang.
    - Shortened the commit message.
    - Rebased on v7.4-rc3.
    
    v1: https://lore.kernel.org/all/20261017013634.792220-1-nickolai@csail.mit.edu/
    
    This patch was prepared with the help of an AI coding assistant.
    
    Reproducer (QEMU virt, riscv64 defconfig, run as /init with /dev/mem
    c 1 1 in the initramfs; 0x30000000 is the PCIe ECAM window, any non-RAM
    range does):
    
      riscv64-linux-gnu-gcc -O2 -static -o test exec_mmio_mmap.c
      qemu-system-riscv64 -M virt -cpu max -smp 2 -m 1G -nographic \
          -kernel Image -initrd initramfs.cpio -append "console=ttyS0 rdinit=/init"
    
      unpatched: Unable to handle kernel paging request at virtual address
                 ff1c000000c00008, epc : flush_icache_pte+0x5c/0xa2,
                 ra : do_remap_pfn_range+0x284/0x3e6; the task never exits
      patched:   mapped at 0x7fff8418b000, first word 0x00081b36
    
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

 arch/riscv/include/asm/pgtable.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2ebd5fa5adc5..48eeeac1019b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -624,7 +624,11 @@ void flush_icache_pte(struct mm_struct *mm, pte_t pte);
 
 static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
 {
-	if (pte_present(pteval) && pte_exec(pteval))
+	/*
+	 * Special PTE mappings are not intended to be executable and may not
+	 * even have an associated struct page.
+	 */
+	if (pte_present(pteval) && pte_exec(pteval) && !pte_special(pteval))
 		flush_icache_pte(mm, pteval);
 
 	set_pte(ptep, pteval);

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.53.0



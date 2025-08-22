Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE92CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032548E0099; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0095F8E008C; Fri, 22 Aug 2025 05:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E146E8E0099; Fri, 22 Aug 2025 05:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB658E0098
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAE971606E7
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:40 +0000 (UTC)
X-FDA: 83803944000.18.A0C648A
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5C41100007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf14.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMrku/+hV+gSS7kLKAAreTIeCCFGj17q+6KCLLSm+C4=;
	b=2WlhkGrcPBK3mcdxquXRNO8r1ym0Gqwd2ZFU3IbSWCJsjvSgyIVtlOGyX7QtpwNktSoDa3
	0ckAxSqwjB8geaicvsAS2g43rSBFJVZbleHfPo93OzhWp2TxhKKQkc+RbYFvOzaLf9VU92
	kL6ZQ/ueIFP3Xku7EW/TuY/HexNgTco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856718; a=rsa-sha256;
	cv=none;
	b=5ppmFngWyQ2dnrwXdZMWIJz0L5yzYxKDhNqFsIRiENCi8Lo+YUSz7o2uRBOpJt3u7WvfdI
	Bxl46nmSx8tgQz1P1JegNtPYJz9cPUL0V7BuCAJXTWSyYC8Pif7L2XofDB4Ggf2dXYmdg/
	MBZCEQtZTz3xu5Gz0qAbQDLX2oQ6IOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf14.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGv1dQ5z9sSg;
	Fri, 22 Aug 2025 11:58:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rouyl7AiVSEH; Fri, 22 Aug 2025 11:58:15 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGv0Zshz9sSf;
	Fri, 22 Aug 2025 11:58:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 001748B781;
	Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id DplApH3IrGdC; Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id F189D8B780;
	Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 08/10] powerpc/32s: Fix segments setup when TASK_SIZE is not a multiple of 256M
Date: Fri, 22 Aug 2025 11:58:04 +0200
Message-ID: <f8fa4d4b5b8b07c0ac97415fdf7dbf1d17f1deab.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=4811; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=wvMxtbYlp4If4vdp7ThT8540zw2Qu4BJbU9ujWqfR94=; b=0XuuBKVXcmYYwRlGwBO3iW+/I/d5f9LBhxzTnJgplI/yzvAaD7n5HlA3+nF5oS7YSR/9hIYLw 8yogXkQaywPCaVJBpa6G7Gi3GpY9iDaMyFhJOv8VOsJKAj7rkSEY5AI
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5C41100007
X-Stat-Signature: st4sjeoanxe3nf9km6tbbuhij8ndhxsx
X-HE-Tag: 1755856718-187975
X-HE-Meta: U2FsdGVkX1+ofDT4kxwf0iiiQuAwBnwAn08hpEsVHcnP4CPPIBb/lfVw3EB5uvvVMBypI0OPEj3J0LqgqqKLDEO9GYj19oeFKIHE6oM02GIi16m+VYNTXGrf5T4mN/vHZOmEzDpDBGSYp33nSmJ5//TRcjlrloWa7VJJW4AQhKTz9Cl2RAcpZZa3/5J8C3b/QuZ89leSQxnfnFkSpI5wjLcj8ZM+iRcxpcQddJfI9TJ/8cpCrWdWGnwYdEUiYBF3qH2k/U5pWRE4AwdRy+ucxH4oG/uSQCyNIoUS8bjZzFkOn43gTsmIgC+BD8Fps5UoBDzUQG4/0/ulmy3GASlwsld/3cdjNPW+01fd+3i6aZBpSZ9qIKd1pO43MOP/4ErC6jqSiWAMrrTKIwT42CvS5e/AmWX73j6QpiWiS5KBKXLc2vaZB2UHGpivy0IicbZTZiiNQo4hMc9Edtm983/3hJfi2DoVBZVxe2ZuGA1d61IBBoNN3lAPoVEj9ZlnAIbrMFU/OEwOoBJgO0MVNdif8BwFtJF4TuB9Xno08qkAylp6XYYg3LWlzZkimw7JFuhO5bzBC2TUq0p/y2k7S51Kb2LQtb7rXJPiCdOPX8xa275z9lFdQ8k+y8T7seoM4QatrmOWz+6zInfmGLgA7OEGWgjTg21KV64QYSy6iaTgA3/E0AhlAxt4Ee2aarhvlCOfrKp76arfACZWNvPXuuh2Xt4YEn3fuNMveMxOk0YMUuwaGYEdyzm/nqM9LOhgbgnFL3dTifDvn/weEcx3ckwAd7YZkmiByHDh/MEoRbiuYHai1UixLS5+klM5+bQzR8u0KSxKF7cBpgWZdOJ6dggXlUT0QktdrZyTq3eOlDHzIpQheMzw8GZXOU9g88TetzfwCD1wcq2akkvm6DQBObD4675twHNXMWliIK5TGVnfqV1HOZX0a5LHBMK5HZxJFcp3j6Bsf4I6+0klBObxTGy
 1JanepIg
 6RKPAWrWFEhwc/rjRvp17goYtr5FABf6VjIuK6ECUcdL4UGyvTKh13CPtq+dVL4RFq3ZukiGP5qCyeMvaukcHXixtoRQmOo7LNUZnHyCJZJafyi7vQLpRtZCh5IhJnNhOwz34IpNwliJIkeHW0Jx/BQxBarQIvZkm5ozMPRxUjWunmMDZerENHzULUVV2mm5ATQnvjzopz/HxETKDkIa6w+nS+iMw5jUV5Q7k0sNsVFztfo/HSJAUTpTjHR26MROKFkFjNJHMpyJEuKvrnQeNic0HYkn47j+XcS79Vxk5Ymx6/tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For book3s/32 it is assumed that TASK_SIZE is a multiple of 256 Mbytes,
but Kconfig allows any value for TASK_SIZE.

In all relevant calculations, align TASK_SIZE to the upper 256 Mbytes
boundary.

Also use ASM_CONST() in the definition of TASK_SIZE to ensure it is
seen as an unsigned constant.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h | 5 ++++-
 arch/powerpc/include/asm/task_size_32.h       | 2 +-
 arch/powerpc/kernel/asm-offsets.c             | 2 +-
 arch/powerpc/kernel/head_book3s_32.S          | 6 +++---
 arch/powerpc/mm/book3s32/mmu.c                | 2 +-
 arch/powerpc/mm/ptdump/segment_regs.c         | 2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index 78c6a5fde1d6..df00be5b4044 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -192,12 +192,15 @@ extern s32 patch__hash_page_B, patch__hash_page_C;
 extern s32 patch__flush_hash_A0, patch__flush_hash_A1, patch__flush_hash_A2;
 extern s32 patch__flush_hash_B;
 
+#include <linux/sizes.h>
+#include <linux/align.h>
+
 #include <asm/reg.h>
 #include <asm/task_size_32.h>
 
 static __always_inline void update_user_segment(u32 n, u32 val)
 {
-	if (n << 28 < TASK_SIZE)
+	if (n << 28 < ALIGN(TASK_SIZE, SZ_256M))
 		mtsr(val + n * 0x111, n << 28);
 }
 
diff --git a/arch/powerpc/include/asm/task_size_32.h b/arch/powerpc/include/asm/task_size_32.h
index de7290ee770f..30edc21f71fb 100644
--- a/arch/powerpc/include/asm/task_size_32.h
+++ b/arch/powerpc/include/asm/task_size_32.h
@@ -6,7 +6,7 @@
 #error User TASK_SIZE overlaps with KERNEL_START address
 #endif
 
-#define TASK_SIZE (CONFIG_TASK_SIZE)
+#define TASK_SIZE ASM_CONST(CONFIG_TASK_SIZE)
 
 /*
  * This decides where the kernel will search for a free chunk of vm space during
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index b3048f6d3822..2c7fadddae4a 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -330,7 +330,7 @@ int main(void)
 
 #ifndef CONFIG_PPC64
 	DEFINE(TASK_SIZE, TASK_SIZE);
-	DEFINE(NUM_USER_SEGMENTS, TASK_SIZE>>28);
+	DEFINE(NUM_USER_SEGMENTS, ALIGN(TASK_SIZE, SZ_256M) >> 28);
 #endif /* ! CONFIG_PPC64 */
 
 	/* datapage offsets for use by vdso */
diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index cb2bca76be53..c1779455ea32 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -420,7 +420,7 @@ InstructionTLBMiss:
 	lwz	r2,0(r2)		/* get pmd entry */
 #ifdef CONFIG_EXECMEM
 	rlwinm	r3, r0, 4, 0xf
-	subi	r3, r3, (TASK_SIZE >> 28) & 0xf
+	subi	r3, r3, NUM_USER_SEGMENTS
 #endif
 	rlwinm.	r2,r2,0,0,19		/* extract address of pte page */
 	beq-	InstructionAddressInvalid	/* return if no mapping */
@@ -475,7 +475,7 @@ DataLoadTLBMiss:
 	lwz	r2,0(r1)		/* get pmd entry */
 	rlwinm	r3, r0, 4, 0xf
 	rlwinm.	r2,r2,0,0,19		/* extract address of pte page */
-	subi	r3, r3, (TASK_SIZE >> 28) & 0xf
+	subi	r3, r3, NUM_USER_SEGMENTS
 	beq-	2f			/* bail if no mapping */
 1:	rlwimi	r2,r0,22,20,29		/* insert next 10 bits of address */
 	lwz	r2,0(r2)		/* get linux-style pte */
@@ -554,7 +554,7 @@ DataStoreTLBMiss:
 	lwz	r2,0(r1)		/* get pmd entry */
 	rlwinm	r3, r0, 4, 0xf
 	rlwinm.	r2,r2,0,0,19		/* extract address of pte page */
-	subi	r3, r3, (TASK_SIZE >> 28) & 0xf
+	subi	r3, r3, NUM_USER_SEGMENTS
 	beq-	2f			/* bail if no mapping */
 1:
 	rlwimi	r2,r0,22,20,29		/* insert next 10 bits of address */
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index be9c4106e22f..afc9b5cac5a6 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -225,7 +225,7 @@ int mmu_mark_initmem_nx(void)
 
 	BUILD_BUG_ON(ALIGN_DOWN(MODULES_VADDR, SZ_256M) < TASK_SIZE);
 
-	for (i = TASK_SIZE >> 28; i < 16; i++) {
+	for (i = ALIGN(TASK_SIZE, SZ_256M) >> 28; i < 16; i++) {
 		/* Do not set NX on VM space for modules */
 		if (is_module_segment(i << 28))
 			continue;
diff --git a/arch/powerpc/mm/ptdump/segment_regs.c b/arch/powerpc/mm/ptdump/segment_regs.c
index 9df3af8d481f..c06704b18a2c 100644
--- a/arch/powerpc/mm/ptdump/segment_regs.c
+++ b/arch/powerpc/mm/ptdump/segment_regs.c
@@ -31,7 +31,7 @@ static int sr_show(struct seq_file *m, void *v)
 	int i;
 
 	seq_puts(m, "---[ User Segments ]---\n");
-	for (i = 0; i < TASK_SIZE >> 28; i++)
+	for (i = 0; i < ALIGN(TASK_SIZE, SZ_256M) >> 28; i++)
 		seg_show(m, i);
 
 	seq_puts(m, "\n---[ Kernel Segments ]---\n");
-- 
2.49.0



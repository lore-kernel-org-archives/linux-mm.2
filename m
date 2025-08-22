Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADD4CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2551A8E009B; Fri, 22 Aug 2025 05:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEA88E009A; Fri, 22 Aug 2025 05:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A7A8E009B; Fri, 22 Aug 2025 05:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3AFC8E009A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85D261606D0
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:49 +0000 (UTC)
X-FDA: 83803944378.30.8365DFE
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CBB6C000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856727; a=rsa-sha256;
	cv=none;
	b=vTsWjcaNUdMRMYtL6OHthBreSbV7yhNo9yT5n+nTYwC1WTyUmGJH+duVV0LbB2ENqXt0cP
	+wSrKz20rioetM/iP3/OPHi2ClRTMpr7TcHlup/M2dx/tyH3HfROvy2sxARolkMVbdmXnt
	NjKmpMVgX8aLNr7ZrhAbO2VvMZ3NTF8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3tFhi09l6yEcr09hrwW9U/UMZb4eVUz89WfOYdaoZCo=;
	b=0P/bIuTwn2T8UYdOFBlVhB4rKZgDnKAKt1kmRbC6BQIGTg0ICUa6kYOULNkOaF/+2kdq3n
	eGSEUYEiyLPmvlL9AlMdJ43SH//DSoU71mV+lgQpORHOoiJbzz6Gve/sKjrso9qTEfSyzq
	+JUU3drzANjbjMJ7y/aDYlxTIYV8BxE=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGx4vLcz9sSn;
	Fri, 22 Aug 2025 11:58:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HI4itv72BwNb; Fri, 22 Aug 2025 11:58:17 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGx3rHXz9sSm;
	Fri, 22 Aug 2025 11:58:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6E4278B780;
	Fri, 22 Aug 2025 11:58:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id estqZpMBN6oi; Fri, 22 Aug 2025 11:58:17 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 41FF48B775;
	Fri, 22 Aug 2025 11:58:16 +0200 (CEST)
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
Subject: [PATCH v2 10/10] powerpc/uaccess: Implement masked user access
Date: Fri, 22 Aug 2025 11:58:06 +0200
Message-ID: <647f1b1db985aec8ec1163bf97688563ae6f9609.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=9837; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=q9/M8Q+ftujvIXBI8Gi8mugr1rBy3l/64IF7f26s3Hk=; b=K3xf3z43dFsltMyTX9/FeBTo0ZJE+/+vNuU0tZKfVHy2dQRAppsf5eI17BJXf1WTeoOGv7Hnv mgeQe9mMJ2sAIfxJZdRjjRVvZi7V7gEkwodQqwQD7Bd0BT1gIsJZ+bV
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CBB6C000A
X-Stat-Signature: yoabp6adoy43gx9hz9puw6pnym179m8g
X-Rspam-User: 
X-HE-Tag: 1755856727-702476
X-HE-Meta: U2FsdGVkX1/hKEFjwMd9nj7QiYkP6txHRBF82reN/oOHLIAuHfA10raAojPDZpI4lcUrxwrEYLvmFDtgJJRv5xaJ4uPdOXHXdBny4H60B4tO/9W41b2tuu8GIRnDgNL9W70aMPVseEFTauKlw+1Y7KBblaa1riLdx5suknPfe3FVQKeBB+66SUUp9NIA06HnIGQgwxoePBX8Xh3r9fKqq2w4ZubmTTkow9qcIv8oS4GfrOx5vgk177OtOC+TcSRpjGtyJgLtO++sdhd6LLagy9bnxFrpz30+3JOF9dUZqAtmGzXhOhSUMxyc4fkueYmSLR0Zx57+lLVIgS0Dd03z8XJY8DV6Rt1imXG/5avxPLsS6yQgTfAFiWKd8moFKxVPYRYEhzAv0wQO327QiPvYyUcA5KmlfdEe01oAtY7Mi0Nd1sNcjIIK2DSq86ihJknQlNR7nZ4vRk2z7p3T6kNWmudeN7ZPqPTqzcU4oFl5Qs3KcxzLHHCt8lV9AyHDxK4s+YGeiDAcZ2qDhk/PLk+O3LHPLOHG5oZZ7fMyXDWaNn21ZWq7EWzYqsMBgOq2rPysVPQwGW5OdnlnfftG+0+7xSLmKdteFyTDuS44Oi23oH2e3OxmDQUav5yQTlAnYWfBgDUSZ87K1x94splCDbz8oA1IkKt/gsMbKxHuQiLZ3YlFk1zM1L5n/8aQErQfsGGg1s2ZLHSID3Wg/EAOI6/R5QAIPHHWll45ErHcsS/TwTMEBhIQJhXTym00EWfGrCbDVNzwpTVyWy9UtQpl5OCatcYVVlo8j3Q2fPSnowaJmBDt0EW2Uzaxtwh1jnfkzg/M3gu98ajhbpsKUTrBovUCVykSmex4HwZC6LaXpe3i/AnfniAfXlzNR39GxT/3QmE9N7U1omM1/G3FNYV9xu3SyfdW+vcT7lvAlpwDpP66gmOwVkFuK/7JU8qMiV8b196lQ95D8T3ytlip/HPuWeH
 6f3HTdJS
 +MVTtW4D2KTkDtn7RWg0+LOjWEH1NiQLySgXXtCXp8+lnB0246+X3V1KPsRm1tH/HSW28/W06Y/gzXhvyLdz2UUXU+wDvo+zuFF1i5gNbAu8lDLwIV3nnKMphPD3dewzPDFWEJd23JcvRTcgP9Ori6OG7BvJC3d2bjT2oFQTinEcxnNbPc/mys/7JkDYzhvZNWjrnAjTMYSrjsAIl6BpazjFo/1dhdmJIqgZIhdLnq858O9XrDQkDqUlwCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Masked user access avoids the address/size verification by access_ok().
Allthough its main purpose is to skip the speculation in the
verification of user address and size hence avoid the need of spec
mitigation, it also has the advantage of reducing the amount of
instructions required so it even benefits to platforms that don't
need speculation mitigation, especially when the size of the copy is
not know at build time.

So implement masked user access on powerpc. The only requirement is
to have memory gap that faults between the top user space and the
real start of kernel area.

On 64 bits platforms the address space is divided that way:

	0xffffffffffffffff	+------------------+
				|                  |
				|   kernel space   |
 		 		|                  |
	0xc000000000000000	+------------------+  <== PAGE_OFFSET
				|//////////////////|
				|//////////////////|
	0x8000000000000000	|//////////////////|
				|//////////////////|
				|//////////////////|
	0x0010000000000000	+------------------+  <== TASK_SIZE_MAX
				|                  |
				|    user space    |
				|                  |
	0x0000000000000000	+------------------+

Kernel is always above 0x8000000000000000 and user always
below, with a gap in-between. It leads to a 4 instructions sequence:

  80:	7c 69 1b 78 	mr      r9,r3
  84:	7c 63 fe 76 	sradi   r3,r3,63
  88:	7d 29 18 78 	andc    r9,r9,r3
  8c:	79 23 00 4c 	rldimi  r3,r9,0,1

This sequence leaves r3 unmodified when it is below 0x8000000000000000
and clamps it to 0x8000000000000000 if it is above.

On 32 bits it is more tricky. In theory user space can go up to
0xbfffffff while kernel will usually start at 0xc0000000. So a gap
needs to be added in-between. Allthough in theory a single 4k page
would suffice, it is easier and more efficient to enforce a 128k gap
below kernel, as it simplifies the masking.

e500 has the isel instruction which allows selecting one value or
the other without branch and that instruction is not speculative, so
use it. Allthough GCC usually generates code using that instruction,
it is safer to use inline assembly to be sure. The result is:

  14:	3d 20 bf fe 	lis     r9,-16386
  18:	7c 03 48 40 	cmplw   r3,r9
  1c:	7c 69 18 5e 	iselgt  r3,r9,r3

On other ones, when kernel space is over 0x80000000 and user space
is below, the logic in mask_user_address_simple() leads to a
3 instruction sequence:

  14:	7c 69 fe 70 	srawi   r9,r3,31
  18:	7c 63 48 78 	andc    r3,r3,r9
  1c:	51 23 00 00 	rlwimi  r3,r9,0,0,0

This is the default on powerpc 8xx.

When the limit between user space and kernel space is not 0x80000000,
mask_user_address_32() is used and a 6 instructions sequence is
generated:

  24:	54 69 7c 7e 	srwi    r9,r3,17
  28:	21 29 57 ff 	subfic  r9,r9,22527
  2c:	7d 29 fe 70 	srawi   r9,r9,31
  30:	75 2a b0 00 	andis.  r10,r9,45056
  34:	7c 63 48 78 	andc    r3,r3,r9
  38:	7c 63 53 78 	or      r3,r3,r10

The constraint is that TASK_SIZE be aligned to 128K in order to get
the most optimal number of instructions.

When CONFIG_PPC_BARRIER_NOSPEC is not defined, fallback on the
test-based masking as it is quicker than the 6 instructions sequence
but not quicker than the 3 instructions sequences above.

As an exemple, allthough barrier_nospec() voids on the 8xx, this
change has the following impact on strncpy_from_user(): the length of
the function is reduced from 488 to 340 bytes:

Start of the function with the patch:

00000000 <strncpy_from_user>:
   0:	7c ab 2b 79 	mr.     r11,r5
   4:	40 81 01 48 	ble     14c <strncpy_from_user+0x14c>
   8:	7c 89 fe 70 	srawi   r9,r4,31
   c:	7c 84 48 78 	andc    r4,r4,r9
  10:	51 24 00 00 	rlwimi  r4,r9,0,0,0
  14:	94 21 ff f0 	stwu    r1,-16(r1)
  18:	3d 20 dc 00 	lis     r9,-9216
  1c:	7d 3a c3 a6 	mtspr   794,r9
  20:	2f 8b 00 03 	cmpwi   cr7,r11,3
  24:	40 9d 00 b8 	ble     cr7,dc <strncpy_from_user+0xdc>
...

Start of the function without the patch:

00000000 <strncpy_from_user>:
   0:	7c a0 2b 79 	mr.     r0,r5
   4:	40 81 01 10 	ble     114 <strncpy_from_user+0x114>
   8:	2f 84 00 00 	cmpwi   cr7,r4,0
   c:	41 9c 01 30 	blt     cr7,13c <strncpy_from_user+0x13c>
  10:	3d 20 80 00 	lis     r9,-32768
  14:	7d 24 48 50 	subf    r9,r4,r9
  18:	7f 80 48 40 	cmplw   cr7,r0,r9
  1c:	7c 05 03 78 	mr      r5,r0
  20:	41 9d 01 00 	bgt     cr7,120 <strncpy_from_user+0x120>
  24:	3d 20 80 00 	lis     r9,-32768
  28:	7d 25 48 50 	subf    r9,r5,r9
  2c:	7f 84 48 40 	cmplw   cr7,r4,r9
  30:	38 e0 ff f2 	li      r7,-14
  34:	41 9d 00 e4 	bgt     cr7,118 <strncpy_from_user+0x118>
  38:	94 21 ff e0 	stwu    r1,-32(r1)
  3c:	3d 20 dc 00 	lis     r9,-9216
  40:	7d 3a c3 a6 	mtspr   794,r9
  44:	2b 85 00 03 	cmplwi  cr7,r5,3
  48:	40 9d 01 6c 	ble     cr7,1b4 <strncpy_from_user+0x1b4>
...
 118:	7c e3 3b 78 	mr      r3,r7
 11c:	4e 80 00 20 	blr
 120:	7d 25 4b 78 	mr      r5,r9
 124:	3d 20 80 00 	lis     r9,-32768
 128:	7d 25 48 50 	subf    r9,r5,r9
 12c:	7f 84 48 40 	cmplw   cr7,r4,r9
 130:	38 e0 ff f2 	li      r7,-14
 134:	41 bd ff e4 	bgt     cr7,118 <strncpy_from_user+0x118>
 138:	4b ff ff 00 	b       38 <strncpy_from_user+0x38>
 13c:	38 e0 ff f2 	li      r7,-14
 140:	4b ff ff d8 	b       118 <strncpy_from_user+0x118>
...

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Added 'likely()' to the test in mask_user_address_fallback()
---
 arch/powerpc/include/asm/task_size_32.h |  6 +-
 arch/powerpc/include/asm/uaccess.h      | 78 +++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/task_size_32.h b/arch/powerpc/include/asm/task_size_32.h
index 42a64bbd1964..725ddbf06217 100644
--- a/arch/powerpc/include/asm/task_size_32.h
+++ b/arch/powerpc/include/asm/task_size_32.h
@@ -13,7 +13,7 @@
 #define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
 #define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
 #define MODULES_BASE	(MODULES_VADDR & ~(UL(SZ_4M) - 1))
-#define USER_TOP	MODULES_BASE
+#define USER_TOP	(MODULES_BASE - SZ_4M)
 #endif
 
 #ifdef CONFIG_PPC_BOOK3S_32
@@ -21,11 +21,11 @@
 #define MODULES_SIZE	(CONFIG_MODULES_SIZE * SZ_1M)
 #define MODULES_VADDR	(MODULES_END - MODULES_SIZE)
 #define MODULES_BASE	(MODULES_VADDR & ~(UL(SZ_256M) - 1))
-#define USER_TOP	MODULES_BASE
+#define USER_TOP	(MODULES_BASE - SZ_4M)
 #endif
 
 #ifndef USER_TOP
-#define USER_TOP	ASM_CONST(CONFIG_PAGE_OFFSET)
+#define USER_TOP	((ASM_CONST(CONFIG_PAGE_OFFSET) - SZ_128K) & ~(UL(SZ_128K) - 1))
 #endif
 
 #if CONFIG_TASK_SIZE < USER_TOP
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 49254f7d9069..0b8e8ed37a14 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -2,6 +2,8 @@
 #ifndef _ARCH_POWERPC_UACCESS_H
 #define _ARCH_POWERPC_UACCESS_H
 
+#include <linux/sizes.h>
+
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/extable.h>
@@ -435,6 +437,82 @@ static __must_check __always_inline bool __user_access_begin(const void __user *
 #define user_access_save	prevent_user_access_return
 #define user_access_restore	restore_user_access
 
+/*
+ * Masking the user address is an alternative to a conditional
+ * user_access_begin that can avoid the fencing. This only works
+ * for dense accesses starting at the address.
+ */
+static inline void __user *mask_user_address_simple(const void __user *ptr)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long mask = (unsigned long)((long)addr >> (BITS_PER_LONG - 1));
+
+	addr = ((addr & ~mask) & (~0UL >> 1)) | (mask & (1UL << (BITS_PER_LONG - 1)));
+
+	return (void __user *)addr;
+}
+
+static inline void __user *mask_user_address_isel(const void __user *ptr)
+{
+	unsigned long addr;
+
+	asm("cmplw %1, %2; iselgt %0, %2, %1" : "=r"(addr) : "r"(ptr), "r"(TASK_SIZE) : "cr0");
+
+	return (void __user *)addr;
+}
+
+/* TASK_SIZE is a multiple of 128K for shifting by 17 to the right */
+static inline void __user *mask_user_address_32(const void __user *ptr)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long mask = (unsigned long)((long)((TASK_SIZE >> 17) - 1 - (addr >> 17)) >> 31);
+
+	addr = (addr & ~mask) | (TASK_SIZE & mask);
+
+	return (void __user *)addr;
+}
+
+static inline void __user *mask_user_address_fallback(const void __user *ptr)
+{
+	unsigned long addr = (unsigned long)ptr;
+
+	return (void __user *)(likely(addr < TASK_SIZE) ? addr : TASK_SIZE);
+}
+
+static inline void __user *mask_user_address(const void __user *ptr)
+{
+#ifdef MODULES_VADDR
+	const unsigned long border = MODULES_VADDR;
+#else
+	const unsigned long border = PAGE_OFFSET;
+#endif
+
+	if (IS_ENABLED(CONFIG_PPC64))
+		return mask_user_address_simple(ptr);
+	if (IS_ENABLED(CONFIG_E500))
+		return mask_user_address_isel(ptr);
+	if (TASK_SIZE <= UL(SZ_2G) && border >= UL(SZ_2G))
+		return mask_user_address_simple(ptr);
+	if (IS_ENABLED(CONFIG_PPC_BARRIER_NOSPEC))
+		return mask_user_address_32(ptr);
+	return mask_user_address_fallback(ptr);
+}
+
+static __always_inline void __user *__masked_user_access_begin(const void __user *p,
+							       unsigned long dir)
+{
+	void __user *ptr = mask_user_address(p);
+
+	might_fault();
+	allow_user_access(ptr, dir);
+
+	return ptr;
+}
+
+#define masked_user_access_begin(p) __masked_user_access_begin(p, KUAP_READ_WRITE)
+#define masked_user_read_access_begin(p) __masked_user_access_begin(p, KUAP_READ)
+#define masked_user_write_access_begin(p) __masked_user_access_begin(p, KUAP_WRITE)
+
 #define unsafe_get_user(x, p, e) do {					\
 	__long_type(*(p)) __gu_val;				\
 	__typeof__(*(p)) __user *__gu_addr = (p);		\
-- 
2.49.0



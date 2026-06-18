Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D29CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B066B00CC; Thu, 18 Jun 2026 05:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B8A6B00CE; Thu, 18 Jun 2026 05:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E845D6B00CF; Thu, 18 Jun 2026 05:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B77C6B00CC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:30:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23F001C4BA9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:02 +0000 (UTC)
X-FDA: 84892491684.01.4D800A7
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf10.hostedemail.com (Postfix) with ESMTP id 967AFC0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bc1WozGe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFT2qwUPpYfCLwTGty0d6yeRs8ICppiuWOoU1Fah3Ls=;
	b=pvvtfeKzGlCozgJN+al7aStQb25zuVhKF3Gif5twdJ3HhBds9jrT8QjXQXV0BCQr7H6AW8
	LEy20zT4sK4+x68B4T//+4IQIc2IVjayNb5ZZJWChmSw/sup0JhKAG8AnJfUHJ4cuMmQcY
	Z147XpU1JnevC5uW1mMwVOrEVsUhdGg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bc1WozGe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774520;
	b=FTM9GB8NTMyX4cAxZ0WiXOSrpG6ZHtPGKsYO90N9ukvp88BZAIa8RYSqmL82DDKI9NrpLW
	+pCA5cOaQF2Dw8CpfZXb+UHbYxtM52+MJFbYEE8Hw8riroKkSUztzoszjmTriflkX1ZcnD
	8KqJ5TrBhaWRZHNxZwXM6tqLl3Vx4GA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774514; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GFT2qwUPpYfCLwTGty0d6yeRs8ICppiuWOoU1Fah3Ls=;
	b=Bc1WozGeghZvFyXAPxkmXO8k4Jvb5TE/q7Z4WEIPulQB23kYM5OOt0nDopL5250+iWDnJ/61fiLUV5i+EN1OXC2h8xBA2ee5nr50n2zNCbWUvWdfV9vNRj+8/0sFeS7KQUy6GT1t3jyG8pBF334fGQIpUPm/qK0zDMgvDea67Wk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56USuz_1781774509;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56USuz_1781774509 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:52 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v15 4/9] arm64: enable recover from synchronous external abort in kernel context
Date: Thu, 18 Jun 2026 17:21:18 +0800
Message-ID: <20260618092124.3901230-5-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: uy74381gwnkrbs4gkttxjo9po9xpzp7f
X-Rspamd-Queue-Id: 967AFC0005
X-HE-Tag: 1781774518-639761
X-HE-Meta: U2FsdGVkX1+rrfFsAyY5b6oiYgnGvvsP4GZ0TXmkbhmrQwx1asQ6PujsLX9A051eYembqAumOoFmZaCq//ZiFTO7pqLwO8IN+6NZJh6ppnsuRV3e1vQeUi9CCDW0y7dHHZdt35jkTzjd5bW0OM9lDFlpfGg9DGDrd7n/EqyaVR/hcTjSSjjN9oAUtBwAFgVdj7cqp4pdLGVjroc+/JgpH4A76PTRrHb5Ewt1T8Dl/BeQK/ZMd2ElXOceDDRmk2jJfkLceYAMcTq+Et0NcH9PQ0VfTyMn1mBIJ+liWP2pbWvL/btPrvp31Xeu1vsMCCBVBsmLSstWF/OXtN6BqGtpQEodvR7lJSpaprBAl45IYr87quiI5cPRZmr15lNDAJJJun0FFaZ3/oTL3CbSSjMibxng3eXU5dXsav9XY9ocMmi0vszYnk/rGhzYPtjS0l/i5vqGEPcWU4Qkk9vA39LzVQWQYg4We42h9d1QYOkkuM6Q+3dajNLrObpLoc8pItvHbKwconXUfxCVQ7FDsN577px21nxfHqyTbNwfQI5aFhFacN7rNsNIwcKEr2kvOXnoyQnK0XK+acDbNFcnsX7TyJh3xLKn4PUeV21AAGe8RK07KLuNqp8rHizCeTXpvm+XdUXn0ftfULKSLp5SMe5UN+LGByYw+HiQGpQdGVNXmELHSIDynXaVrb5kb/27yFIi1/hAA2pDz641YUVUrizBU1HMhxicEJZJ0PCAYvlZQxVgSAxX1Ahe86IL9+7n48r3+LOIau18Hu797oAVUowG4eXNPhHsDFf8eS4lcIYjCkQTXk7ROAzqlh94qX5TJ6YGGpTxnB+L+35qVorVxS3UDLCGsBSdOvWhc9yvZqzCeiqOSd/jknooR3s/eR5nLcyX15i799kTEWJPHKgvEL7olvzzWsR83HDpL7Yqa4BIRzR1/A1yPWnA/0YgWZZftcdY5CkfcMp2zqIaUdZGIyc
 NK0W6v2u
 Z8RZR7qDEBUiAMejV0apNjwHCfqcK2tMhVMZz6yZqEPO+NnlqLL4jxBNHG1n6q2js6CM3H+fpBXur1GSf4CVwgk/8wpp6Rh5WImnUsM26cFfw2sGBBSaSwbPHXahZp/if+pkBuR0HcByg4yiM6krG9xSTB5NOJEVJZRDe3jT7DBZZO9GaJCDNLvDcX7DaKKT7z/SBMaGsMXU/pebfIm91iS3AqSThnY3urtfRNfUAWImSjeVOLg7PCtFn+k0zEalvV4bsVtRSFo5vX3yItx56WblrtHAygIb5Y1PhyMtAtYkKfWjEoAuQcTxZumprqGX9tkqJ3zNXnerRq9yv1odrK2T9TEKjZ7liBmqM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the arm64 kernel, when it processes hardware memory errors for
synchronize notifications(do_sea()), if the errors is consumed within the
kernel, the current processing is panic. However, it is not optimal.

Take copy_from/to_user for example, If ld* triggers a memory error, even in
kernel mode, only the associated process is affected. Killing the user
process and isolating the corrupt page is a better choice.

Add new fixup type EX_TYPE_KACCESS_SEA to identify insn that can recover
from memory errors triggered by access to kernel memory, and this fixup
type is used in __arch_copy_to_user(), This make the regular copy_to_user()
will handle kernel memory errors.

[Ruidong: modify subject and rename EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR to
EX_TYPE_KACCESS_SEA]

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 arch/arm64/include/asm/asm-extable.h |  5 +++++
 arch/arm64/include/asm/asm-uaccess.h |  4 ++++
 arch/arm64/include/asm/extable.h     |  1 +
 arch/arm64/lib/copy_to_user.S        | 10 +++++-----
 arch/arm64/mm/extable.c              | 28 ++++++++++++++++++++++++++
 arch/arm64/mm/fault.c                | 30 ++++++++++++++++++++--------
 6 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index 06b19023939b..8450ec5a3af6 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -10,6 +10,7 @@
 #define EX_TYPE_ACCESS_ERR_ZERO		2
 #define EX_TYPE_UACCESS_CPY		3
 #define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	4
+#define EX_TYPE_KACCESS_SEA		5
 
 /* Data fields for EX_TYPE_ACCESS_ERR_ZERO */
 #define EX_DATA_REG_ERR_SHIFT	0
@@ -76,6 +77,10 @@
 	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_UACCESS_CPY, \uaccess_is_write)
 	.endm
 
+	.macro          _asm_extable_kaccess_sea, insn, fixup
+	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_KACCESS_SEA, 0)
+	.endm
+
 #else /* __ASSEMBLER__ */
 
 #include <linux/stringify.h>
diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index 12aa6a283249..27bf8edbf597 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -57,6 +57,10 @@ alternative_else_nop_endif
 	.endm
 #endif
 
+#define KERNEL_SEA(l, x...)			\
+9999:	x;					\
+	_asm_extable_kaccess_sea	9999b, l
+
 #define USER(l, x...)				\
 9999:	x;					\
 	_asm_extable_uaccess	9999b, l
diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index 9dc39612bdf5..47c851d7df4f 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -48,4 +48,5 @@ bool ex_handler_bpf(const struct exception_table_entry *ex,
 #endif /* !CONFIG_BPF_JIT */
 
 bool fixup_exception(struct pt_regs *regs, unsigned long esr);
+bool fixup_exception_me(struct pt_regs *regs);
 #endif
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 819f2e3fc7a9..6103f5b0a2d0 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -20,7 +20,7 @@
  *	x0 - bytes not copied
  */
 	.macro ldrb1 reg, ptr, val
-	ldrb  \reg, [\ptr], \val
+	KERNEL_SEA(9998f, ldrb  \reg, [\ptr], \val)
 	.endm
 
 	.macro strb1 reg, ptr, val
@@ -28,7 +28,7 @@
 	.endm
 
 	.macro ldrh1 reg, ptr, val
-	ldrh  \reg, [\ptr], \val
+	KERNEL_SEA(9998f, ldrh  \reg, [\ptr], \val)
 	.endm
 
 	.macro strh1 reg, ptr, val
@@ -36,7 +36,7 @@
 	.endm
 
 	.macro ldr1 reg, ptr, val
-	ldr \reg, [\ptr], \val
+	KERNEL_SEA(9998f, ldr \reg, [\ptr], \val)
 	.endm
 
 	.macro str1 reg, ptr, val
@@ -44,7 +44,7 @@
 	.endm
 
 	.macro ldp1 reg1, reg2, ptr, val
-	ldp \reg1, \reg2, [\ptr], \val
+	KERNEL_SEA(9998f, ldp \reg1, \reg2, [\ptr], \val)
 	.endm
 
 	.macro stp1 reg1, reg2, ptr, val
@@ -74,7 +74,7 @@ SYM_FUNC_START(__arch_copy_to_user)
 9997:	cmp	dst, dstin
 	b.ne	9998f
 	// Before being absolutely sure we couldn't copy anything, try harder
-	ldrb	tmp1w, [srcin]
+KERNEL_SEA(9998f, ldrb	tmp1w, [srcin])
 USER(9998f, sttrb tmp1w, [dst])
 	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index 76b18780f1f9..20a7a9eeed94 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -109,7 +109,35 @@ bool fixup_exception(struct pt_regs *regs, unsigned long esr)
 		return ex_handler_uaccess_cpy(ex, regs, esr);
 	case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
 		return ex_handler_load_unaligned_zeropad(ex, regs);
+	/*
+	 * Kernel address faults (e.g. copy_to_user reading from kernel src).
+	 * Do not fixup here: a translation fault on a kernel address is a
+	 * kernel bug (e.g. NULL pointer dereference) and must oops.
+	 * Only SEA (hardware memory error) should be fixed up, which is
+	 * handled by fixup_exception_me() through the do_sea path.
+	 */
+	case EX_TYPE_KACCESS_SEA:
+		return false;
 	}
 
 	BUG();
 }
+
+bool fixup_exception_me(struct pt_regs *regs)
+{
+	const struct exception_table_entry *ex;
+
+	ex = search_exception_tables(instruction_pointer(regs));
+	if (!ex)
+		return false;
+
+	switch (ex->type) {
+	case EX_TYPE_ACCESS_ERR_ZERO:
+		return ex_handler_access_err_zero(ex, regs);
+	case EX_TYPE_KACCESS_SEA:
+		regs->pc = get_ex_fixup(ex);
+		return true;
+	}
+
+	return false;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0f3c5c7ca054..b775c0928a53 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -858,21 +858,35 @@ static int do_bad(unsigned long far, unsigned long esr, struct pt_regs *regs)
 	return 1; /* "fault" */
 }
 
+/*
+ * APEI claimed this as a firmware-first notification.
+ * Some processing deferred to task_work before ret_to_user().
+ */
+static int do_apei_claim_sea(struct pt_regs *regs)
+{
+	int ret;
+
+	ret = apei_claim_sea(regs);
+	if (ret)
+		return ret;
+
+	if (!user_mode(regs)) {
+		if (!fixup_exception_me(regs))
+			return -ENOENT;
+	}
+
+	return ret;
+}
+
 static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 {
 	const struct fault_info *inf;
 	unsigned long siaddr;
 
-	inf = esr_to_fault_info(esr);
-
-	if (user_mode(regs) && apei_claim_sea(regs) == 0) {
-		/*
-		 * APEI claimed this as a firmware-first notification.
-		 * Some processing deferred to task_work before ret_to_user().
-		 */
+	if (do_apei_claim_sea(regs) == 0)
 		return 0;
-	}
 
+	inf = esr_to_fault_info(esr);
 	if (esr & ESR_ELx_FnV) {
 		siaddr = 0;
 	} else {
-- 
2.39.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C761CCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6698E0010; Wed, 22 Oct 2025 19:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548D98E000D; Wed, 22 Oct 2025 19:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CD68E0010; Wed, 22 Oct 2025 19:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C45B8E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:30:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAD09160836
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:02 +0000 (UTC)
X-FDA: 84027345444.10.49756A1
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 011A5140007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Fqm3xPHT;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
	b=2SugNbVbTcNT463djH858uejx5MDlNg0tvXHJvO+nyVEMQXZyKpEoJ/B+kyQ0z+qonW0cS
	R/mtn9kFWi85AVpLPIdrVOGL+F4/qLPVT6CoBnAd9alOPEzSFxPbUQYUyZK1cp3WaQIepY
	qPsyyYshl0YeSN2Zj2jt80D7eKK/s8s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Fqm3xPHT;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175801; a=rsa-sha256;
	cv=none;
	b=HA8nzEEJDIJk+tfR8YgRGWe7x+wYWzZYXldjbs4QF7xv0+PXyGic7hCtHbs9c0ITDsgyBN
	QzA3F7batWpJzfJxZPvF5wth12IdppwgAZbIxVZqNQUYpeZBSpJBw/63TKdhftJretLSs5
	okKZFQFPKjbSBGpEN3qtj0xr0EROnJo=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7810289cd4bso189972b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175800; x=1761780600; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=Fqm3xPHT9ssrk6DRz9owDlOFP/NKSMVB4W69e6q+i7reod8TOvdypLWVjXzKzAToFS
         RLMnyi9tR1iddYziS2/JcHUpRxD/eatnZ701QThLCHfgkKsR5kezhEzfnjYHBsWa43aQ
         Y+xAcMBmxQnwQRqMMs0BMPzqiXMfd29Ao6xj/eMU6q47LtdbGhIXFbLuYxooj1OvM/UW
         Vc/tqVGXuvqh7EbstBHXvt98mS4smZCuS1xUgIQkz5DtVd4xuuJPe8QuyFw0PC1IegYV
         taOFMp3oN56cAMQVPKMDmoxQd1CDUVK396twtB2vQniyeVmAPULAx5b5zPo423gTGrDZ
         Hwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175800; x=1761780600;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=Z6ViPCYoVZZugshtsY3uh+Wpv2VfiSAkCLegt+MWHAJo+eeEM3sTaWLihmP+iovG7y
         hfS3PGNGXnaihzZ0E3prnmyZB1r6jwdfo3kTZUAiRa9rbWze8crOQrTFK0hnMq6a4Nmp
         JuzOtbVDnVK78j9TySA2/eAAbIt7MgA9yjMAhnqS0f52JCk0YjzGCZQs9M45WuYdo2kR
         dKB/QugtQ4j//BgItZjANR2UlWs8/G1FThORbKGCZCu0nbM6H2ERKTHOi/pSd4DErj+I
         1VR2k9ZGNSVRAsKt02IfQVsA9CL8DlScIjZgwKLWnM90dJaF1yR1rAxF/VzfCPQISGqI
         H7ig==
X-Forwarded-Encrypted: i=1; AJvYcCUgj41zxaOqlzBG7+0cbVx7v1wkNrNDlAs8+KKf+LL3vtTL3PjdtQitCiGV2LMGNuXEu2VVGTcasQ==@kvack.org
X-Gm-Message-State: AOJu0YzILlx25hQ+CAQC3lgjeUAnNwtbCwVVYTO8wLf8OwK10Ujyv+FM
	s6gmuio8qFWtGaz2FfvXRRpBbm+xWf6ZKvN+KXeb75J5inYw98/ILvJ3V+8Al5AkNxA=
X-Gm-Gg: ASbGncuflpLLllAvHU+gjapZ+pz6WHD8xhdNkMBU4YWBlZEwGZTrnPs+3bkUON99ryd
	Jr7TM4nz6BArFfi6wAG6O5Smbr4WRxk7Rob7Sea4Nh9vYuI2pDSZtYvvScUILaDCTlFdzJ9Y/mA
	fQOtzbPC6TFpBAL6cBGQTm7j7Pri91eK5/kHRx0QoHbpcrTYILZJbcfIfAX1KyxzBDm/jLPwxGQ
	12dMAuBc+f12V9pXbXltAKrDVEz8Uk288aq20YInR21/UTI+2Nm4DMYelTxTSar8owiJi6q7/U6
	QK7UfQv71nfhPa+DJeL0nQSNYcC3MEI/+5sAmrHkyTW/EuSjPTvoL2GvnglofuNNCjiGXOeQEHB
	kTbI7DrNqIdBnIghtRcxKI5fridDMW1Z0Vob/L6Tl9w0Yd+90TwFHqCAZnmSfS7lbZo+x8lHXA1
	S0AcoQXGOQoA==
X-Google-Smtp-Source: AGHT+IGLQGEOQyYAmtfXLHkaK6noesu3wcj1NFodbUudsqeYx3psfGGXfzX4u2kf0r79AOZr48SESw==
X-Received: by 2002:a05:6a00:3a05:b0:78f:6b8c:132 with SMTP id d2e1a72fcca58-7a220d22341mr28097262b3a.29.1761175799813;
        Wed, 22 Oct 2025 16:29:59 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:59 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:36 -0700
Subject: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-10-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 011A5140007
X-Stat-Signature: e5wr37s4wut9jjo4cgps7bnbzuykotkz
X-Rspam-User: 
X-HE-Tag: 1761175800-470329
X-HE-Meta: U2FsdGVkX1+bL0epSAravPVYtB4VoGBpBIoyWAsjhE1qQzRZ4lkGVDwAZ2pqN3Gx64yOPK5EXh8OEY33bVgUTLWs4nAIK6yjeY7E44EmW3foTa0vTrfD3fgolUSV5TQXRXDlVEBgLvbQ4nDjyKUAL37ZeeRYaTapbd3AEQRxPyxeHFq7ma2D+dGM1n5TY3T1xEJLdJJEO/DciIry4RFMnc4jA6wtOcLE9L0HXtOLqdJ7MGc9+XCN/fWwd/vY5QjgmM/afgRkXIQDK/HftG1Lmhnv5mpK9DqS6bBrCsKp2EbbWL4huqR47z026DpaIHOh/POiI7Oqn+nn9ayGsnXDxgYotZraDtbhBQ5dgP5oIuYMkFvvmULlPJLH3A4k24+7A2KFVvhlIfbTKs2gx+kpxgaDwD2GwJYeA7SCjP9ZHoJLjy8oxKU0xss1aNgH2ZxO7IKitSCdLia6TT80IJfUO/5MIrpDoiJlDfnzhXF47k1f4bdygn0+LCkyMQzv7jYNpAq1cdswojhcFTQsIjzvJhmmXsUmJmPETuPmCrUTlxfQo/aRYeJl8NEouaxOLAkdYUS2iBiHtJPQJ6bQlcttY++NmJorYTqXmpwY4AVbtl3yUB6ToNvP67FyZHvIU4Oadbw7M7+7hGA+hvDMVa/4ZQ/ZIpLsRqZ+myGEA3XwC6gohpszUoGQX8PWxo7DU9nzvA8yRKK1ZVov0pASogj/soNYRymZmohNBmITkTc7nmiOAqhe1PsinkjxRk921ZOGJ3fyc86NBFA4kMIqqsB4yWUJmxrtqoVY9Z+PieQhcynpfyZkquhMChnwBoAD8xAWTPZM+4VsIdekxyB9iUzeVMatIuv3qpdF/lf2g+uYsjXk0Ql1LdF8MU37hEvbjRA5/VowtA3HRHD48+IyqEIwOZY3ZNWbaq1W6FZK2WYJ8nCWR1H2xLgafXAmUvdzY8KubgvQLwLKYP2+jcYJ2UG
 oHSQbo2d
 acsN0apQK2zfXfzd2kYiFcC47GTpX6HGwtoPZt2g2TY6lEhCSOBV05o38YEXiwaCWF21GFxla9mq3cqjZTBKA2YlvU1WjtRxp1cOnHqebKZu1fDj5wT6XtQ/4PHQPNRwFY2FyQek05k9QyA8OXNcWUuhHrjMmC0DhaxnhrCxgvEcotB4O1jc0039l+MS5WZMglm1WbdC6V45GT+Jrk/Xht8LV/moJP0sHZS+UK+L8FxvPQ2ORMA05qo403prGC3wIsduckOYb4QUTyC/kzOHVk4eHNrqhCYVoq9AJFPflo+BQuezSbp2D/zdCh3Yp29Db1Q6QuqRWU8xjfSTlLZG//V6cFu390HVmR6U6n1lgfcmfXzGt4k0tkhUf27Tx4GdSfQfuTsAQNi5JSwF/Ynk+wYbmFfwBXvfSZ5qSrwawcPIaFSxnQtB3M9c5rA4C6ErTTjPesiWS7rz4z6CA71E4Kr638I2JQ1dgzkQIEiLN3LEMlo9z9UjQ/JEigx2gGqKCbFVjC1UU8otETpDS6pzgbh99UW+SBK632wgC4gv7sD/zLyZXeLJdcRlg+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed extensively in the changelog for the addition of this
syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
existing mmap() and madvise() syscalls do not map entirely well onto the
security requirements for shadow stack memory since they lead to windows
where memory is allocated but not yet protected or stacks which are not
properly and safely initialised. Instead a new syscall map_shadow_stack()
has been defined which allocates and initialises a shadow stack page.

This patch implements this syscall for riscv. riscv doesn't require token
to be setup by kernel because user mode can do that by itself. However to
provide compatibility and portability with other architectues, user mode
can specify token set flag.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/Makefile  |   1 +
 arch/riscv/kernel/usercfi.c | 143 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f60fce69b725..2d0e0dcedbd3 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -125,3 +125,4 @@ obj-$(CONFIG_ACPI)		+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)	+= acpi_numa.o
 
 obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += bugs.o
+obj-$(CONFIG_RISCV_USER_CFI) += usercfi.o
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
new file mode 100644
index 000000000000..0b3bbb41490a
--- /dev/null
+++ b/arch/riscv/kernel/usercfi.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Rivos, Inc.
+ * Deepak Gupta <debug@rivosinc.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/uaccess.h>
+#include <linux/sizes.h>
+#include <linux/user.h>
+#include <linux/syscalls.h>
+#include <linux/prctl.h>
+#include <asm/csr.h>
+#include <asm/usercfi.h>
+
+#define SHSTK_ENTRY_SIZE sizeof(void *)
+
+/*
+ * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
+ * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
+ * shadow stack. To keep it simple, we plan to use `ssamoswap` to perform writes on shadow
+ * stack.
+ */
+static noinline unsigned long amo_user_shstk(unsigned long *addr, unsigned long val)
+{
+	/*
+	 * Never expect -1 on shadow stack. Expect return addresses and zero
+	 */
+	unsigned long swap = -1;
+
+	__enable_user_access();
+	asm goto(
+		".option push\n"
+		".option arch, +zicfiss\n"
+		"1: ssamoswap.d %[swap], %[val], %[addr]\n"
+		_ASM_EXTABLE(1b, %l[fault])
+		".option pop\n"
+		: [swap] "=r" (swap), [addr] "+A" (*addr)
+		: [val] "r" (val)
+		: "memory"
+		: fault
+		);
+	__disable_user_access();
+	return swap;
+fault:
+	__disable_user_access();
+	return -1;
+}
+
+/*
+ * Create a restore token on the shadow stack.  A token is always XLEN wide
+ * and aligned to XLEN.
+ */
+static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
+{
+	unsigned long addr;
+
+	/* Token must be aligned */
+	if (!IS_ALIGNED(ssp, SHSTK_ENTRY_SIZE))
+		return -EINVAL;
+
+	/* On RISC-V we're constructing token to be function of address itself */
+	addr = ssp - SHSTK_ENTRY_SIZE;
+
+	if (amo_user_shstk((unsigned long __user *)addr, (unsigned long)ssp) == -1)
+		return -EFAULT;
+
+	if (token_addr)
+		*token_addr = addr;
+
+	return 0;
+}
+
+static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
+					   unsigned long token_offset, bool set_tok)
+{
+	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
+	struct mm_struct *mm = current->mm;
+	unsigned long populate, tok_loc = 0;
+
+	if (addr)
+		flags |= MAP_FIXED_NOREPLACE;
+
+	mmap_write_lock(mm);
+	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
+		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
+	mmap_write_unlock(mm);
+
+	if (!set_tok || IS_ERR_VALUE(addr))
+		goto out;
+
+	if (create_rstor_token(addr + token_offset, &tok_loc)) {
+		vm_munmap(addr, size);
+		return -EINVAL;
+	}
+
+	addr = tok_loc;
+
+out:
+	return addr;
+}
+
+SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsigned int, flags)
+{
+	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
+	unsigned long aligned_size = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EOPNOTSUPP;
+
+	/* Anything other than set token should result in invalid param */
+	if (flags & ~SHADOW_STACK_SET_TOKEN)
+		return -EINVAL;
+
+	/*
+	 * Unlike other architectures, on RISC-V, SSP pointer is held in CSR_SSP and is available
+	 * CSR in all modes. CSR accesses are performed using 12bit index programmed in instruction
+	 * itself. This provides static property on register programming and writes to CSR can't
+	 * be unintentional from programmer's perspective. As long as programmer has guarded areas
+	 * which perform writes to CSR_SSP properly, shadow stack pivoting is not possible. Since
+	 * CSR_SSP is writeable by user mode, it itself can setup a shadow stack token subsequent
+	 * to allocation. Although in order to provide portablity with other architecture (because
+	 * `map_shadow_stack` is arch agnostic syscall), RISC-V will follow expectation of a token
+	 * flag in flags and if provided in flags, setup a token at the base.
+	 */
+
+	/* If there isn't space for a token */
+	if (set_tok && size < SHSTK_ENTRY_SIZE)
+		return -ENOSPC;
+
+	if (addr && (addr & (PAGE_SIZE - 1)))
+		return -EINVAL;
+
+	aligned_size = PAGE_ALIGN(size);
+	if (aligned_size < size)
+		return -EOVERFLOW;
+
+	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
+}

-- 
2.43.0



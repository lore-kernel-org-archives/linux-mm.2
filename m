Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7E3CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC70E8E006D; Wed, 15 Oct 2025 14:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77118E006B; Wed, 15 Oct 2025 14:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D400B8E006D; Wed, 15 Oct 2025 14:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAFBB8E006B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86DA6119067
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:09 +0000 (UTC)
X-FDA: 84001147818.30.2603758
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83008140010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Y6sd6+qG;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552047; a=rsa-sha256;
	cv=none;
	b=FdiTsuOwQn5yx6BJlJ2tuVGxMAz0A1FWivk1Juxps9CkcVGS0KXsvgoFW1YVUTEZTY0pjR
	3pq8rqQeMjEjOaM5r3y2EtFThbeA4ib1LK87w1g33dsvxohLefOkX8EN84kTurR2D3gMAr
	PrlaOT/TFtTivWpYGrWp2ipY2bSEsKA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Y6sd6+qG;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
	b=e3DJ29fJI7Giva0iEHQqXM1c1tFLCeD4U9xUh+bFbSYdlUG1x/itLYxS1GMACX5QS/SI8w
	NuRxh3SgnrT4aqKuKXp4XmQCayWriyRq26AqyZu8SsCzxV3frgIIzIRiMb5OF3RrZxdkAe
	lYeGlbl6OvgBChGe5u2IyH9M6DKabQE=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6329b6e3b0so915163a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552046; x=1761156846; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=Y6sd6+qGwY/OKPw5X/f9DmQSyVmjwH55HtCvqXPZa/LGks46rAJvXSjY2QpUQXDJsk
         x1BKaD8rjUkcwWYAfXAEzSHltEpmIudHvgwSZYA2MPXuZ0glznkf5EtXA6BvuGnPEM0I
         0ONlDB78Ff4wZslrIB++I8rZgzA6nSNUv6cpKYBqojFrAYOYwLSHx5aOLl6mCmqpY3oW
         pXqINyVRIZQPigcLxDZQ3OTpW970hBer0xlN2OXCoanqEtOocMgGejxHihyvJj3wWMtI
         GHz8Uduk7kTY1BCfvyW452FR3VUmA75+OAmA5lf47uqKb8XhTIcd3TVXTvPyH5FtHZfF
         9Jmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552046; x=1761156846;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=GoEHdYfCBmomA9pbn1acoKnUUpNQakL0nqsM0xtRIabRqFGXcV0z68nHiiF/bzdvk8
         CJT40+UWJAi3EytYRGVeY4RlgYfPylBcW4cYjtW0arrxRzF7lAM3HtuUt6yRgQtcJDsW
         DD0QQJx06l99lFbEHYjJpvvNUi6oVf8vBEG6lvb0oRKUj8ZbNoY1gA9EycNQbSTXDwS2
         jNx7sixGEwCIRPSWkZQHjgjBTyoCRzfSnuD6DyaYEr7+md4YGfpa+6vPeBOTNBSPlVFr
         0SBgszE/V+DbeEwPMxs4uCFHVCdQOXNCnKzx+UdBriEEkloselUmldlI5wTKbgohMLc7
         kiXg==
X-Forwarded-Encrypted: i=1; AJvYcCXS82ikCQQhrTuRD9IiaeEObArG+FxvT/bW+weJ/Bby6FhumBfS1/oKT9MSs1lTxVOcHVRs6uUEQw==@kvack.org
X-Gm-Message-State: AOJu0YxYiD2qaFZ3Ntm/LOc4ukDCvMqJX8vIORfACL05W1IWzynVdNRW
	ZYHd051Tq9weuAeDaUan06Fc/2gVCEhWAWNdjrNKw97W+oUwl5zm1y8GEEYWdbLkZi+Z//JiGhG
	YucVP
X-Gm-Gg: ASbGncuRm+gTUSWY38OVTLibgGM3clr2Lz+ezKQlr1tH0/92Swzw66JQN7uC3X+hxni
	YeY+fSwPNSATE/aKsl8rpE5ZtH7zb2bqZtE+xUCwrY64zEMu/GiFIZCQRUXRCS4p8JMIckKGm8s
	xmLR8XWdZBweIQRvEE7l0VspxTUs0zW+s5Iw5/t/YvbRMBM6FIGBYpJ0TPlWHs+NiiqKYSnPFWP
	LPE8tpJOjklfvwbhCtMMHAubc5ZCxp3pRKuZqry/NAjncWEpVLvwvsHuiHBrhPHHANSQO7zrjKb
	0rshtd/e2ofUF7jmh/KK1rzFknI/lzx2nYKToTP+nVFMpRWgryCxc41qIzHhFAWxX4k3jZQ3yvN
	/8oVQBpO43/buB7jN2JP4C0nVJzComJlDVSzG6KwSEW+nXzbQQq50o69RAjf/2Q==
X-Google-Smtp-Source: AGHT+IEY9h9wK3DDaRURINP8YgqxVTJvudYkku3VsRSOTPxZh7znOpPU29mon3p3gzH9BHe3/s0Q9g==
X-Received: by 2002:a17:902:f710:b0:271:9b0e:54ca with SMTP id d9443c01a7336-29091af4271mr12119605ad.13.1760552045917;
        Wed, 15 Oct 2025 11:14:05 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:05 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:42 -0700
Subject: [PATCH v21 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-10-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: 391cdhj77831ukj1upzym8y9j194sfqb
X-Rspamd-Queue-Id: 83008140010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760552047-720717
X-HE-Meta: U2FsdGVkX1/ZM7ychSHB34iEkpiZNP1Hn2oOZWq7wJw0VcNoCNIHq0YGuDkqHGVw4rWl9VTyhyJu8sdjg2m6+lxjPTitWJq3sDwe3VRPf9wjMFsUkVHsQjY+CiqPTFAWQdUMj7oO9OHv6z/KTJn7z6nW/e4Yg33kRiEd4PISS4IOnYKX1wnAN6wfElNtKAkvse+Cr2oEw18YMps9yYsu+e0r6uztP4pTb/eZKnx+vCYGQuotGk0/YGKFFI2iRDty9H+HSXfbl6RsoUjA5tpXzmMHzQk5ylO6wHbDPlyhvM4GN7piLR+qAWJgeSgOKBP+LVEzGyl5FJDoXCGB/YF9pgyRISjU9eHqRYozNvvoKnxxmXAeFcZr0MYSSCddFb6XVKv5Ga1BazXKD5cWn8QcD6Fqh3lrP2/8GWNZlsBqOS690QTwRDlC9GMqeg0FxHj60CeMn8MM63dcwxoGfzdtnTP6yYwsDFF2r/FdyeBLSpT1h5HSMiWgf9QXNJDPdIY6joShJRbCRszYYo4bXC3/LEKkemVNFmKelmTOkrHhM9qr9mKRKD1j2xD33o0FGmDBWTYuhti/gRuCR9b0Pd3jT82Ou8TUL1AjPB0FkaczbkmVEsaQL1dU2Hlg8dKEdAn1kEk3QRKO6b4NGx1N46CtLYuqPaXisfbnUYiuYeJsb7HMeI1E1AO+73hWTszRGkDGFTws/LtPTA2YFSj8iemI9q9YfxDIxHMqLNpP4XrcTg5eBmxVYavSiFrwdNkCHvG9b1/SU4xhZ19irP4BWbak5ZgADuG6ob/K10aMKQFnRddWMx/53knZ1pQyx2vh7S1EzoRwdbWL0qt2BboK+PcVj7IyDha2kVAS+qYTvWGehYVgPL2EWcirZZNZx6MbVXyTKhX5qm8UWDrh9hFkkKTEWDcyXOumX+agsKBuuYbp6pKpCpiWnVvoagEeqxfsmj565allAcxxR1jggYqjdoR
 cUQYZH8M
 xac7Hie1vLYtm6jiWqje7SJOOyr57BBM8xYsMRBK9KBK9Y0hlyjz7MnUFlLII5C1ba7dG3Q9XO44KLNc9MeIOF1ICC5uqORzLYMBSYkOhxZkLHeAHawiJZQaEgK92n8XX7r8c7Rd9CxYxfbgkKNkke9wi8faOJs6OIBBFriam7vhj6uhkFEghRoQieEgkSN1zfLuCnzFgkw8OyzGCl08vbbOLIKN8dzufCrexaJa/7TSNxKekCuQmSQbgUPPt3MTrEDhLWg6GU/B/guDSAnabxbXE0AzdL594cVmrBw2dtmqA0gx1oEVhFvNwoITXDcIJr7fG9HvilM3baCtSAqK/w1GTUxVtpoXQvc1vMfKZsDMn6uhcn3rLqe6nkHGvhbBFLCgSgDePxxtIlKBgGc8eYcB5ebZHWfkrJ3d3VzBx8MMJhGyCaVnb6dGHAaLSXqGqbxxz2iluYgdJouilY7/a9GVt4K2ibhisvE20hk9htqUKDByQQjjjifuHWpwNwYF0zWD6dQAjqfk7xMi1hbGMZycq4i/eWdAdq1FBhqQP7LVKuaXbptYLxWIsCg==
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



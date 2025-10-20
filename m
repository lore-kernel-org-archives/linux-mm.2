Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA14CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3308E001B; Mon, 20 Oct 2025 16:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CE38E0016; Mon, 20 Oct 2025 16:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFF98E001B; Mon, 20 Oct 2025 16:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75BD38E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D778116D5C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:04 +0000 (UTC)
X-FDA: 84019616688.21.9D5FEF6
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D9DCA0018
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AHLtiG0k;
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EFG9tsHnwXPL7MOb1LJbqjm5igUYZrX1AN+PqcCi5E=;
	b=JC5nZGKX6gwdZ7475KsaX8wt+evomvhxFDDctu7ls7CojT8V2nC3ej6K2fg+4iT1sHMC5Z
	3i7/8F5QA6YaKm1SMnSlfTITg2u005gxCA4lxh8LJs489p7Fz7qniroENf+oKSYtpY/vcF
	vd5rYwC7cj75TDvu64ZrfQTrOMq2HWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991782; a=rsa-sha256;
	cv=none;
	b=ZhGY39FhfhfO7f0OWTG+39Hf6fNtvpQOOsuP0NcT789aYEyyFOMTeDNAyogDN/PvbR2fXJ
	JOz3trO2UV7jo+/FMvFUMUucn/b/ZSMoB1/OagU4hdCIZpCRvXr8Fyq6q0K0rhhwmEUbo2
	nS2OL9uosyirAD0oGyrobxqJxFVcPxo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AHLtiG0k;
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-781997d195aso3638695b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991781; x=1761596581; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+EFG9tsHnwXPL7MOb1LJbqjm5igUYZrX1AN+PqcCi5E=;
        b=AHLtiG0kW1YTQzfwl3ublOeRBVUaqaWEPGkbdaCU3yxBKxOmC4zwCE8yCNq9dgUzvl
         9nKbHzgtu0HI1fzp/v7FBpkjQtbVKBTfB2upGG92GxLJJyzgxVn1plhFh9hhqD0zwXGp
         LlCL6O3XDAoSHa7uC4dezldVrkJJx1U6X64rZtUg/xqx+Tz4bVMsecDXsyew4PUwThj4
         TNVit7Rz9SCypeAYrO8R2yllfHMZEIw1OdS+wlBiB2yhYnV+HqsdOBE4kqBszJwdc6s9
         RJDP8tY6G4m5z5cf3ifvIIwa1TdCCWZUgSzrKqRPrTszVf4DjNQ2sHiHSYX/nR5lCDU8
         L6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991781; x=1761596581;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EFG9tsHnwXPL7MOb1LJbqjm5igUYZrX1AN+PqcCi5E=;
        b=JKLhBd+mseLorf0F2q5eBkp6x8fDVOcZ35ayNHc5S92v775CPLmuhpsTr5P4ZVlw6a
         9dD9dCMUnPO8uxfWuAAKZJW7u5/LT6HhavR+VrjhCqMRmtaMnQqGaO52gKPK8LNHk29f
         Gr6yVCrUSpO80fpDkbOoL3xVnQ5ajS8XPNXybCaQzr2+1ndi+JbWEeMmu1vsM05pNNPi
         IoJUrbOiG8jgYnYFRHrSg6C2HI73/YMa2RxoDzk3oiiolG8OjA+W4CV+qolOeHdBzbGA
         w1ah1fUc203OgjL5Gm89khTGJhq5p2klmGGGforhOMAn+3611j78QB9qGn34w5axEJZz
         sGcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNTwQj07bjhCKiVgYwmHM9t/jFcor/7fsdse44VfEUmEmNE38iPmlzLV3yicfIGw4i+g4cyUGC+w==@kvack.org
X-Gm-Message-State: AOJu0YyMzIo2Y31OfiAPMTTP4VKRBjiPe2cK3ED68Bz5HLnaLdowXimM
	2OIqzNwN5fj1OzWkTc6GCTFMG5z/239K7EvkqHz5gPxp7ewSHZDgQ8ccPKwM/Tqsbuk=
X-Gm-Gg: ASbGncvuwTDUhrmdXnJTtAxI16ObKkgDulEbDohjvI5cCR6x22w2mxGWlXA9UhOpnAe
	bmTyqSuYDtHAyrdE6D5fb4Negcv0zu1ZCpDMF2rWDpKN+wFPFdtv2JnenEr9JCjiXrI9gc5ChsC
	HtGPQLQ25nBAWkZmvXW8h+ZqKw36fwvv3qgF63Flew3ykuE98yTYwzhGtCDFO9WKjGcRNlsdR9z
	omf+m7G4nFwl8UsCjzu1DXFN0gnCLqbT9OqqmHlMsvjjkfabJA5IEnOIRfS6cnCsJEkhCMMnVBM
	kww5aqnz4P/EMKLjkDoufjCGxHFw+uiGVmw0tfA3fOnsNt3No9caUdEmzqDG/QchbWcIXA+8es3
	Y1TFF10/C5+DDl3WrjmRoDHBRa7bxaoiRIa1jaTnWJ35UplUztb/LbDUCSeazwfGt51kIAHpo56
	ndDzbHFLoxrw==
X-Google-Smtp-Source: AGHT+IGIVeURWFeDtjXPTLoBQEpvhWWxeNZ6to1Cp+iMan/wRDsFo+OUZDxmuS54BGE4e0jI45fhXQ==
X-Received: by 2002:a05:6a20:5493:b0:304:4f7c:df90 with SMTP id adf61e73a8af0-334a861852amr19562038637.50.1760991780936;
        Mon, 20 Oct 2025 13:23:00 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:23:00 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:39 -0700
Subject: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-10-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: sh3pwspb9ewyoag9pd4zanpdxo84787g
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D9DCA0018
X-HE-Tag: 1760991781-976025
X-HE-Meta: U2FsdGVkX1+smk3FA6dUEyKQjRInDhGyvu4XmXxngBFwZOnH4qwEN1Bs4y3Yt81I2AkF/g79kp1Ac/ilTqvY0wnEe6HR48YN4hqdrpRMLkXE6339tw6E9v/vz9S910MiECpo0mkYsYy7onRVELjhOmH5VvWv5j+eDS9bh8Nfy1cI5TI6Ux6DVbtZdbepHlyoWPQa641mmumlxUqD34eDlKcWF3MCCirw20ObinIPOqOJFPqvno29RetDmZIvoEVLuy2Mu1DzyxcmJjtQwLfkgAcF+Uhd8lt/HzJa+FdXMYgXO0HyFL/y8GIVpnzaSo/qbpG7gbia/x1oDAqQ7fqqZdlGsjloyT9pKpaBMq6oSTmRQMP4FSKKSZJ4sSJDkul9c9NicgxOEjzJK8u2aXR/k2ByBEq+da7HQhe5nur2xGN+lhzUP3oNi5xuUHRaOgED7JTKN5RhwvtDFENexphfR/6y1q+p+ddiWR8hjK7AAi3AhK3PyD6dHGcdVQo5a+SSxbwGou+VZz7T+Hptxu/9sFvSc5Jy1Ip3uwaAYg/fRneS5IrNZ+tF/GV+EWGZd6Hx51UUtWEDo+w0IL3bBGRvQgZaPKzbTtFVH38wIuTUUkWJI6eyTiOZjz0iO+WVe/sOow243UIUIDHbE/1Y33yt+IXc7xAp4b7vfA78ZwKVq/P2yTAPoX32udhqrPVhStXjn9XSQN6uLC6kLxBZAt34RC3muDuW2fnw2itaKhHNNH42fM6NYcV7mB//idfo+rQfGeeQkmc3rVBGKx7jp4ngfodwGjEIiJQw0bO6klehJFPfFSDlRbDnVhJoAcRYxAP2k6pnQK+lGkVDn/s8CyJUnCtOwK03hxx6wBAGHxt6ZMiYfgAXGUmDwiDN5jPe8toxO6VI4OanoF/PRvT+DXwTW4KQEfnGbKCZG7y6G6SkDmFZxaYqkOp6hz2JNMbkztOfiDaycalXqIXoPvg4zbs
 m/IPHlQZ
 rUgJYtMLmAr3aN0ULVllVBlXv838SdjBEBMD18V1+hv7aRqpwqzz2v1KGnjn1KAjP4OxnVAADro7SvjnJTCclaY4f5PjyatlJeEguE6SuZMqSlLepD0yy2YsCW25xsT6S4nCM+T0XS8vIWhpj9HYyFMejz3wkH5fkW8PG+0tVQIDaS0rbxmkb7ig0yswygCmObs4uN9JsXxq0PEuxqTVVuaRF7vTA9/wB/blTqgsDwxqkeUzuF0e3hFx/aIbSkgo4WMcrRK9UEU0GXZgIH2dTY/LnbL7HPOS3ffSkc5PWvrG1z6rYmDeli/Rngv3Bc26CjBsJmKOGHnrkDHm8ol6HCLsmS/Ck8mJ4GDqtw452I9G32kQk81hkHBwpiTC5KZtNC3NxNb/ejHABd/gYUwyRTEqdtb/mmVxQeYzqfc/kEJC/cWz85TzzRwxK1OXCuWVzFKgeaDsC3qXGWZ+eQUg0VejElJqvKQSY28yBAVSUp9CIZuTnsiJIB/KRJMIBvL48q8c7/RMbWhtv9XWvnHPWjZWMAcePHe1R9ZRAJLoARWYWhzoMd+y8WALPsA==
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
2.45.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEF9CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3796F8E0027; Mon, 20 Oct 2025 16:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAB08E000E; Mon, 20 Oct 2025 16:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F148E0027; Mon, 20 Oct 2025 16:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1E38E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5556B7FC8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:59 +0000 (UTC)
X-FDA: 84019694598.21.902C5AD
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id CADF38000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="M/a/K8ZY";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993637; a=rsa-sha256;
	cv=none;
	b=aNqM5ivuOFEXUKiEsVeLrbNzDWQ1RV05S2F8LPqddpukrr98zSwLtfqY6f/IhhQVfQ3DO+
	UFhPEcNnDPPGMYVlmVrF8dv0NDuaqYjpvRdctRh3rPoh71SLUK+qhn23+tlqXz6Vfabkyj
	eOWNfrlPOHFkXT2C+swjyuPDbjCtv48=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="M/a/K8ZY";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
	b=KWyxux4KWZZLgvxnooPBYOYc4T++Nbt5aU0Gp+ShDJ/ZzKbQnvFNWDEjKy1ywQStXKPnpe
	O0/UrI530VguKityZ6RbQmfk/VSWfrf1P/ypsdkN8bA4Vh0kB4P0bLcOjW3AmjmbIwf2oy
	Prm7y/e74CLx3FsJ1cn2d6mCPZ8PZyg=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so3926164b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993637; x=1761598437; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=M/a/K8ZY1ALR9JP0vHxgWKHo35D9jb3yx07Ysf76CsdMUj4Y4DA9IY3K4oVp1KG94z
         KSBzp1CECJ2lwV51QSPyVkNSsR2mj2ANL97oKjy/tWyVorWk6ZYexdV/vcRoSZbrr6OT
         vnPrIErCe6Mgn7iKj4al1+obZpQRU36f7nRk1sCq/Kg9ZFeNAT4rsQs3HkqKHmbHzzxp
         VPsruaL2kc2/0QBEMj1Prmm+iR/zlGG1xkevlSSZ9mEeTp48YfZUMkoMPRogV0i1WCoz
         jJd4ee9CtPv8HsN6Bgel6pQtqXYFL3bnV0GlJmKyS8Xfn0khTQtQ0YWJBza5locr/WfN
         WgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993637; x=1761598437;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=lyYOw9TJm1htkuQHGid50Xr4t9RE1k94qXOGmvEuNhN8sacSbPS7dwochLmRtzCQgC
         +gC5ANLhtL8/nyZSIn+AQZAKGzbIPhOTOu4AxTdO3bguomhfkE4T3l61JMvXGPkX8Eoz
         Eb7T91usNciD0N+VKLncmFhJOuTC8UZVl0lOmfQWCb0ZML0SatN+NGUiYtoCg4GU5Y2g
         UI1x/bow1UicE1eOklb2sNqC5yvwO6/ALNbWHx1l6VQLnRc+GV8r+6HdjeTU3efmXXq3
         bnbInNlk+5gPsYYB04TjoA7Fy6xf568tkf8LRpIUPv3+Ub1C24kdbG0MCdVSwRbEKNhN
         C7UA==
X-Forwarded-Encrypted: i=1; AJvYcCWaaOApjVB6TlymThW3WNUY2YGxKapfxrUbZIN7fE9HwKjvH9C9qqHUlBljoWArvTfeX+JJzR7aWA==@kvack.org
X-Gm-Message-State: AOJu0Yxp3j5FvkgDlluXSBMSXyNBYDmZZsnu4RR9xw37p/BqsunkHHbD
	hsmIt39FvFe0nVITKj/F+NTzrQsQmRpVUiIbqdmRsAXpmJKOaUZvBbJFTqexO36pvBE=
X-Gm-Gg: ASbGncv6eLsnbmjQVsziraX04ac+5XaJXN6rLENS7JR8B8mRAn+6awEH8dztzcR+8dT
	VKurNeMHRiM2xagaP7e+UC4sGhUEwu5LrPXzc2QdLV7XPTwJs7xHOqv+E8hhJxRK2fkhP7G8stp
	RFajjb/6H5P8U3I8uOG7KWloXtc2h63lygWP1RlyECwGtZcZuCunu4DAdVvZYAd32GwvZH9h/fY
	muG823Ifz9n8jjNYM1ISy5bXVQrD6csIhitZ8JbMejct+xkGhNW36aLbm3mZUZEQoqZkRLhmucs
	dCwhoCJuWZX5GDsympWOoxMBkvZA3XMBwzad45eRLw8TlHvQUk57RriV5ya1Scwc2HvOSKPpCTM
	Bm5pnpkqsXa7h8p4hdietnt1Xn85dlhu9WqwjxFrrN/Pov35g7uIC/XbNoNOeyMBlR4HdzklsCP
	MZN8KcOLbc+MIMkM4lz7N8
X-Google-Smtp-Source: AGHT+IE1g/KbpvYvMQc6A135OEMdW1EQcArxrHV88hDIqT7H4tb5uf8t9yxI+vtWLXy+tIlYRNuKtg==
X-Received: by 2002:aa7:9066:0:b0:781:155c:f9c9 with SMTP id d2e1a72fcca58-7a220accef5mr12718068b3a.20.1760993636577;
        Mon, 20 Oct 2025 13:53:56 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:56 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:39 -0700
Subject: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-10-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Stat-Signature: jo81acgx498xwxitfn3xr8fd1b6bu7tn
X-Rspamd-Queue-Id: CADF38000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760993637-337006
X-HE-Meta: U2FsdGVkX19YqcNaI5st2o5K7jj0FBJWxDwQaKFSrIHNK9wPpRW/OARMAS2Lt7HY0rvkC8n+QxjxVViEetWfdiOjqrTBvZKn5xAgaPtQgPsdooHgYHLwopEU9SaDAO/VGPktsMtOsg8weaNn6pOlh0qMx87+p68w7dj5P7ExDD39wztrwosiUBA/Dmm1K217kGwBhBclJDJmIaP/NKPmwfcJOTZeJZC83TdidN8swivcMV5l/2nbw6xz+kfm9A3/9UfcTLw85j6PGngrHXsVbSWRNbwGqoTs2p1RYnE4lft6JcOQYkhpgkt4ENleBVyWO0kBGmOEY/+wXI5mClZWLZkjGnGzNB4nef7T8vRaPOzoncbvn7yaZobUzip1StwYXNx0cMCDZWS9jg7HyldD37VWQxKlN+K0aDgBa7wARwVD1XvUJW4fEgU+l/GjNV7idI6j/0mcD3sDnd1BeGeNlc94YuPkYapTqosfUov8R/qbLP+lvzzB21nIVriEKWNwMBW4rfL+jxC+Q7ckSGNYYoOsuyEZD8VTMhusWiSjhgv/NhW3RSFbxVJGUcZGmS9yvlcTvTr7qyB+RmTdwrgQcJzJqpbpScFdDPTfYnCjhvuEaIc57p4AD9ioyeL9q9644ByoPXNxy2+B9E7Tof2fSjCqZJ+jM33u9llw4GH5u1e1S7xp1QQSObYe1qGVmMEc6dE/jUlGOX0ISLAZOWnivFDd6scUYMT86pV3zDmtGV+ZX4d1ay+uL20bZWUI9BaZqkxQVmvkm7+jBCkHK4fsrB8ZW+ioojYI+7J7bjTHZJ6V72v8unD96vXsk/I/hfaPidiA15d5qDHU60JsZL+3/4bXySeQjyuMp4rrmDV9AJbaItYD8GfMg96oe0A5yWMadhIjOgvoZrMGL2r8RxtHfRVqE9XmAynfv6qHFqUPvCwfP4ULDKr12gOz4utDw4eUEhgDQmWQPqqi3u2BtrR
 1tSHEeFN
 3gfuDWR8S4kdmE6/G7vUVW/4D2zvnWYQvSVwqtX3on8yhrbW1pTvIpuu2kzGgmYb3nJHrBL8eLLR4GGWuUYlNhdD4U3qhah4O1azHSIdOBQPQ3vKj3E40ygmQ0226ww1CVHtJxRk8mjv3OsUeZFO1ma1m7HpqHU+L942MN5qKBDYFbQm+GzGNNHcLKxNHZCvjD+6AprY1vD9/H14PU+pfAUiKzzEuHMUq5aAC/phpYs7dNXZL9oyLdI5WHH/E+eclgPZLeJiOJS2mqAjSxtcm0fE/0ivCldFZH1lECWpt7FovSA4GC7G/7d7jq9bTllEci9pdbQ9i/zM6tnIzbekQ/61iT/Ax9vTCPM/ul9nXAAA6H+j0IrieC0qvKYba3OAr8JUNaGIodgSEj5z6ogsLvekpFBY7wIs2nPDli+WWy1NW9Z+CcldiG0WUXKNP0OQJNYl72vTETJjz14Tz8wo9wil0v5jpGWv48cDZEFGmf2we2xbBNZoC0t5QhmK+6VEp+BXR2kbHF5ZaRXESoaCUzLde2t/7omu3hCyWOfU+r9ePOpgeRE26FdvsQA==
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



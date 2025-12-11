Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E575DD41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9D86B0023; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9628D6B0027; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE626B0023; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3086B0023
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 327EB580F6
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:13 +0000 (UTC)
X-FDA: 84207856026.03.473DDED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1181616001F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMiCkJOd;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdF2cEgbJdCOBIAcKDD0QRGZun9ZJX6K7eT+AMD1Uns=;
	b=GjSB5fLCDU0pMQ02/azKsFPV/EJdHIcy2m7OKBirouqqiHsvr+eZb7L9LtAoEy3hw5t0H1
	UfhH5WGJwjmmidwETuPOVolvojf5Ri8nSZlec7p9AYGZ/7RwAnHwZE5DtXQSVQwp6fuTut
	YXH3Q6Gwr0CTksHtBzPucvPgAf3QZTw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMiCkJOd;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473671; a=rsa-sha256;
	cv=none;
	b=EJP/7H8jMawD1+nG5cP65xEdGmjRoQb/W7I6rzzAKIeMT0eG8Hv9+/ip3tOQj5p20i6vS9
	lQrgkpJP7TWFbknAt7XJKa8ZnieBTcZ8mN1qO+jefel7XJj0/Yc42lUISGVg0PqNrxHf8B
	wdwg6q4oKbA4medfgDSAzDBIh9pW6yo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8584A4448C;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03665C4AF50;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=6jZXAB0aw5HDDMQGn8fqo4E0DfuBkH3tkkA21/2DJww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NMiCkJOdEQyxEfkgj1JuKcC5QwhJrvHwwM+j0ypTn95IITayVpVkm07YXvzO8YYyp
	 dHSXQ2W1yj++on1GtMJDXbaSLvvL0pVdHH60M0HjkJGDa1tU7E802BeO6OlejxUmGw
	 zeTCSo15wov6huTO4BrZz8ZUw1uRtzE5DK919OQmRaDw6mcIDoSyUoOzpnv+ZRe4Sd
	 vCnzS+kRL0Dz6j8LDqAF9rMP6vF9Dc74RlPhPsCpuBuN4L0aNHOMIveReR6RgId0ZR
	 69emKN+8HD6Ru5iVOrwP2L6a04HOv5MUvqEDpSxBc8N4PD5SMb6TcNEW66vfnXNNtj
	 k+l5cuOQ9E/Hg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88DBD41D6F;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:39 -0800
Subject: [PATCH v26 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-6-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=4299;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=iZqvtimsKyFTZgyCGpJkQVX4KJa2k7Dv0ibvxxfASY4=;
 b=fbmM7rKCfooYVJOStB5zvDavYdaaOFGp8RJ6XmYnNG7zZjRrFzkzkTr1EgyL0Ftor/Dq+7hQD
 x2vp0/TG1bJBUdNzL5gzD7ONx9g/KrfAuC2/TeLpCsLzvhtfBqNr/dJ
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: m7boueuy9hqfkuiy4wdn68sk96q4t5xm
X-Rspam-User: 
X-Rspamd-Queue-Id: 1181616001F
X-Rspamd-Server: rspam07
X-HE-Tag: 1765473670-131468
X-HE-Meta: U2FsdGVkX19BGVVpemnR0FWJW0xUP5B5ZjKXCRHL4zDOEhG4tyhNeDsvZIM+1f234lugUwx4oxRyGNSWeCJDjNn54Y0FNG/FM/zSy8D5tJHc12zgIFaFi2SNPBIOepnZapUJCa6B5OcEaTj44PILRyfdwy8+VQ5nm9Fhn9bo7DNqHIQjND4CwpMDuxuHlub1nSYYcWsej5hhyr/GqWA6Ta40BN3iE9RcuZtTvDPfJbTWCyN7c5Fs3nzQo7i0v24XCkA6ZnH7DF1num3G9eVyVJmvV/IbTTJDidezZVm6X7BuH39NzMawzM+W55+Xm0/SQBTBRHE00YCxxSrCZb2se2wYD8YMWwZQf37s+PCyxYbmKMn1RKg/YG3kSsqctHU6QZfJTN/SxDCvu6k3742WBsJF0iE4eLxYM4RVHIJA2+F6huyQlwTXGdMlWDqxh1HWJPfE8MgDQNU2Zc7oawFS6WyUQU/SQAnDY1UKcjtiBgHf9eQzvNSSqDrMvqOjq5z6Zeoq/gQpthmPu9FVhYZLYnJrYSTIoIhYUFuKOukpWpxpjfqVVoziu4OtDH2Nsj+rAtSdGp0F+5GvfYqVxb328i3kyJkjh1xdfn37lfmoSVFonP7JDaBvomcgnbJ1ae2VEQ5c2Y6Vdc6/baOBgpzBeWoQVg6Ib14ilOoVVpdYqei/a8DgieCs5K4cFjnWx9UCbPEEN0qSRpzMFpVWIjD0z+duyeanDAuDQB8O034+ml1CTW8MYPYp6V6Lk0cAi6mJTYeqWz7GInJXcRdLA8Nzmub7+l6Xlt3aqm95bg0GK49PigMS/QWDtGB3WAUrMB6TcWKX2Y9b9o8MDiG58Dct4Yi5BiV6qa6z/Kzdi57YpYS4nEwn06kwE9OdR3jFtgtN111HJUGM7H7FafvgbT+DlWwZxngvwpJpRsrkHhQzKvmlBuqf+tF4sW+wEKhH0XIkcLjpk9exV6nMzMguoSy
 HT+ScVkc
 Nr/zLvi/PiLAN9SeggQTZREAQp3gqzgMx2TwkHBIFTqb2KG0dTHtjtCyHCoOIIRPSGL5B3tm0eI/zjXcJC8q6wdOIldUvLwX4lXSn/v+D0fPKGt2OzgJDX/atHR50Q5fQQCxg2Grb9oQshrGiFlvpfknbbG7B/MA6bSmhgOIi0epzfag10zX9fjh57DJK/rAOz2fYHHN72sH6Zqqiy5FUI2MwTwVWVrSmoccxe0GPRgzX+jJoHa8R+cub4wWE5YuIc5OeaHU/RSX2UXYqYON0G1Aq4ItwpoLdXBpTRt+Bgdsgl07AaGp6TVjXBXHOLtvbV3i26UIBlrkm9UXMBpyFt160RBkre3/UqSK98ZowqbQ2htHzE7tgGCPEmvhCsCeslBXZn5VnW6ULg91ZerjgW84+nw8vLNub5HfJ6RJJMRIMKASE7BxvtedGFztRV13hNjBF2UbZPDLDkQvLKYPnahGsvNABRzX1LALnh9XiGOE/pkZrQIVUv9qQYNDfttcZiyga4QAYLv2BEdRmo+vMoQjCw3JOj2t1cUluDvyDWWqxFk1eaQdY8pxR2EnGRvCKd0ZiNdAsSmV5hiMpnGMhqrMOdXPoTS3B/68a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

`arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
This is to make sure that any existing apps using PROT_WRITE still work.

Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
encodings for shadow stack. Above changes ensure that existing apps
continue to work because underneath kernel will be picking
`protection_map[VM_WRITE|VM_READ]` PTE encodings.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mman.h    | 26 ++++++++++++++++++++++++++
 arch/riscv/include/asm/pgtable.h |  1 +
 arch/riscv/kernel/sys_riscv.c    | 10 ++++++++++
 arch/riscv/mm/init.c             |  2 +-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/mman.h b/arch/riscv/include/asm/mman.h
new file mode 100644
index 000000000000..0ad1d19832eb
--- /dev/null
+++ b/arch/riscv/include/asm/mman.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <uapi/asm/mman.h>
+
+static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
+						   unsigned long pkey __always_unused)
+{
+	unsigned long ret = 0;
+
+	/*
+	 * If PROT_WRITE was specified, force it to VM_READ | VM_WRITE.
+	 * Only VM_WRITE means shadow stack.
+	 */
+	if (prot & PROT_WRITE)
+		ret = (VM_READ | VM_WRITE);
+	return ret;
+}
+
+#define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
+
+#endif /* ! __ASM_MMAN_H__ */
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 29e994a9afb6..4c4057a2550e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -182,6 +182,7 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define PAGE_READ_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ | _PAGE_EXEC)
 #define PAGE_WRITE_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ |	\
 					 _PAGE_EXEC | _PAGE_WRITE)
+#define PAGE_SHADOWSTACK       __pgprot(_PAGE_BASE | _PAGE_WRITE)
 
 #define PAGE_COPY		PAGE_READ
 #define PAGE_COPY_EXEC		PAGE_READ_EXEC
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 795b2e815ac9..22fc9b3268be 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -7,6 +7,7 @@
 
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
+#include <asm-generic/mman-common.h>
 
 static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 			   unsigned long prot, unsigned long flags,
@@ -16,6 +17,15 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
 
+	/*
+	 * If PROT_WRITE is specified then extend that to PROT_READ
+	 * protection_map[VM_WRITE] is now going to select shadow stack encodings.
+	 * So specifying PROT_WRITE actually should select protection_map [VM_WRITE | VM_READ]
+	 * If user wants to create shadow stack then they should use `map_shadow_stack` syscall.
+	 */
+	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
+		prot |= PROT_READ;
+
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index d85efe74a4b6..62ab2c7de7c8 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -376,7 +376,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READ,
-	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE]					= PAGE_SHADOWSTACK,
 	[VM_WRITE | VM_READ]				= PAGE_COPY,
 	[VM_EXEC]					= PAGE_EXEC,
 	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,

-- 
2.43.0




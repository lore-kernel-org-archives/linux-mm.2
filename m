Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09101C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7720D6B00A7; Tue,  8 Sep 2026 02:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAA36B00A9; Tue,  8 Sep 2026 02:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DC76B00AA; Tue,  8 Sep 2026 02:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28C326B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96CEF160384
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:01 +0000 (UTC)
X-FDA: 85189629882.22.8794012
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1DDE180004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=tegE4qZL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4mxmFhK1;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjTX9rrwFsXVQ2q23yM95x2dyNZBtSAXhGeuKQ5L7eY=;
	b=gCyIutepPC5ZLS+9Vc3TALYEkM6xwZVu+njRA3C4UnZmqDaLXsD4VXXDpPSAX2SFpBKc5j
	FkyBhjBBnp6a5LRG5s8h4A2Qv9IFKURchHHFlpOZNzmRWI13pgjCIVqdU8IPMmmnux1weO
	jhsaRuoDLevtqsKiN6Uxoljl8NZ3V1o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=tegE4qZL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4mxmFhK1;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849240;
	b=LmbjPZXLXFbmOZco3mgSdIpF2Mr8MGfzGEpsESIKbuyXxlBG9WCrfUzF4Ta+FTFfGgA73I
	Z7V1hlQ+3VF3dOgHnEx8YMjW1jX/Kqg8ASpzHMQrmWWAObkHkHMnaupyzrlfCa+1gLyDcU
	VS+vOtIv1pZdolRImO79Mdnrui/UtLs=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjTX9rrwFsXVQ2q23yM95x2dyNZBtSAXhGeuKQ5L7eY=;
	b=tegE4qZLU1owA5WPV94NgVm8p3Mq8VaPjSNgdIHREOQX0Gq4XrSZl8OsvTeQR1o2O0ToqM
	Xm367SkFstd763Eo6owFZJOJOAWxkHQOODKGvEdBzYq2B2/3kIr4yjHD9sszGcSCx1SptV
	g635te+HDDk1q3DLMtLxqoOnnxvdb46zf2QSvzDnB/HCb3w5B+xo1N1QrnklDtH2DBA/vH
	h9wkKXhqYCfsLN1Qg5IIcOSb1MyIg2wE9xuBL8Ypr6IrRO7QY62HIWAyRY7FpK7V5BWIoL
	Z2JLtU1vH2fZ9+5kHdooMTILHKviv3/rHjwYnf9P/M2Jj6gxGtPxKR7+obn0gA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjTX9rrwFsXVQ2q23yM95x2dyNZBtSAXhGeuKQ5L7eY=;
	b=4mxmFhK1TnLVvFb5Gy1yTMnk/5fB8HgnBZCO8URerY3D/Q/wTzne2uXK0IjtSF7q4DaUDA
	DdO8rhE6PBNDdBAw==
Date: Tue, 08 Sep 2026 08:33:49 +0200
Subject: [PATCH v5 15/24] arm64: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-15-3a93791af1cf@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Nicolas Schier <nsc@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2617;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=fVRENHv4++0cFzLHw247YU3v29PEq48gHKwsMBM12mc=;
 b=DDwbzH/SMGlKwp0xQn0FvyrfKZTXWpkAu8j9jSc4YRcRhytEC3Z/8E0SynIo/dONb3pcsCUqF
 v5dgouxRsS1CXrQYp0Ti0evF1Q/1uFXGqIg/yNttK78bWL8R2JJA0xa
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 4dxzspermgs9ucbfqx8h8oqugqx53dyr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1DDE180004
X-Rspam-User: 
X-HE-Tag: 1788849239-311250
X-HE-Meta: U2FsdGVkX1/8NLlP7oOaaeZwWFd4U7AE+GN8ggoJdHmYJkCR1C6aEQ9IpZHeyYBOMfUyAqq/k4LNz9SVLOJDO07m3kuF/TpXQaxJ3RI9xiRbo+JSsuPDHe4JTZm4rvlvGVwtK0AhuOBYHQheUDXXC3N8JHrYgC5Ia0oKCmEqzKr0d46GwFUvVgZoNFNHpKH0+GoghYLFOVIOfe1/NufSOUf0nZYgD/tBgySWLR0NqD+HcDYSsduGe8K1B70Gds6wrsB1VgPDqYtaHHher5orkuqa2YSBRyJ76uToIP8s/3x87omHhMOKz+ENJs3bSKhqFnQmXE8IvbykT03iSeT5o2boRkkSaK5IWPL0IQVvE+Aftgot7wPOFldbiR7YCxS6P7oZ0lel9LfWbGe6TMNPvv75ZwMoHkklOKyjOkbuTvtqv5r9LNS5UAWvDxAIQVaHxaOeH8GGN8KnCjo7WtPldKqKVMEaSUqfq43yZyP2CewNErtGTsK/+nByTW9bdeNbSqzgJniDoKRAbpQ21J2wc0MvvmB0pyrRicybxllDaVLC6e2Uy6quVBkBdz+GwTPkQ4d2Nj+HfVSvl93yZYzS6CEu34ikrrfiogvQ/4Zfjn71Sk6IXpFLuGNFtctt2p/nqI+xzqEtIPZmxbPcwRICQRBr8zo3QGG4Dhchcw/jn3ziaMT4glGke3fqzJLs62YVXxj4OmcjZACYqfM3jisccOHKisD0TSrIg/gOP6HDbSIjxpRHIiwxhsCbfCzqN74O94Uusf1yXXhurD2fPPCzLiWHSoSlAu3RGbh8ZXr6EMoydUqEX/dOMmGdLnXxN9jVlhW0dSvaP+pD3401QGXXKoff8Vvm1VD48P9uM4E/V+iGuazKx09+gwzdQ6Cypet2H8egs8rJl+1emBfnNe1VlYjunb7n/M9wsS9MmxT3tvKabeRSZ2tuVRqRP8EPBjX2yF2SDp0V6SBcrxJvtB8
 HULQAUzQ
 j2v/eyEubrhjO5PmbbaSRPaasGW3740+ImQrMrfTTOImGc+ZOD7Ov0cFTjipY9JlNArDUd9ybwV22/hmhpqXgafx0QDctEiKDzVUq8hnYdbJyexdgKAukqmCozTQC0iJOMYdwF/qPMs2D9oaJ0uZnkuYOyF4IRkRFL3SPNvYnM8DgwBdlmvej0r9C2Prdx/6oo7NI8AaIX5oxUEdhSM6ufSZdaKOCXRd0Bv31uSBRw6X9Ut0XfBXtNtGszKsEi7KOMJWXYY/ePzyDOHwjcxpnVDKO5fUZWZnWdBQ6A9rW57Ob82W6B/BouBGq96DCDyNgiwRKAdi7uqytQUZg62L3qYTxUjh1EGYIySBJ24j9mJKfVswFQWUlP/5t0hL0Zil7wphDN0kDJvgxse8pZgcPmvyP8QfeMMyaIOgnavk/7ElMstfsXM4+iYYKPLu9BNLG7r/RE4+ilSDQ54BAKe1JNH6vgFO4WXgA7JiinDpQ8O+67jMQNIFzQxX7ZG7WY1TcIK2aGoYbhOyiY/d3IAEAgvFbwtBR08ESoKcNqPUewW6EC+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vdsocheck tool validates the object files and final .so library.
It can detect if the compiler created relocations which are incompatible
with the vDSO which need to be worked around.

Wire it up for the architecture.

The compat vDSO will be handled by the existing 32-bit ARM configuration.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs     | 12 ++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..1caaf4737f02 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -258,6 +258,7 @@ config ARM64
 	select TRACE_IRQFLAGS_NMI_SUPPORT
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VMAP_STACK
 	help
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 7dec05dd33b7..9fac0e54097d 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -61,7 +61,7 @@ targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 # Strip rule for the .so file
@@ -79,4 +79,4 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 
 # Actual build commands
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index fb88ef0be09d..e45a1fbc6829 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -57,6 +57,18 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_AARCH64 => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_AARCH64_PREL64,
+                bindings::R_AARCH64_PREL32,
+                bindings::R_AARCH64_PREL16,
+                bindings::R_AARCH64_LD_PREL_LO19,
+                bindings::R_AARCH64_ADR_PREL_LO21,
+                bindings::R_AARCH64_CALL26,
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0



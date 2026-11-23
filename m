Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F50606A69B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=cmCyDGAo;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=FI7TlzcC
Received: by kanga.kvack.org (Postfix)
	id 361CB6B05B4; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339186B05B6; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DE66B05B7; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F030A6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85B26A0878
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:23 +0000 (UTC)
X-FDA: 85466520846.27.44C19E7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA87810000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=cmCyDGAo;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FI7TlzcC;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441881;
	b=XIfRYbkeqWF42UBYD6neqcHCSqMm+BWuqNZw5YBiDiFQBnICbLnJox2oh/mepjzELzxtP7
	gKRP4chJIMRqvdlTG8OkHhxBQZJgSjXDGf4D6k0QbyDK8eeu3EjOoI4oROEyDo93WeBngZ
	Qfvv7bRqomCR77JtBv/SHAZtIRWpoxg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogBMPA0Qx4PjkZ9OZjmL4avau0QGga2wYFkd3qrKkjA=;
	b=ZNarEmnPzWGF5SQYgqWuYV7+jSiVKSQcH98krv1iwdZj7taEa2dbBUzJe3aH0pt2odcv6I
	fN5C/ArSmsvky41m+OcSuT9mcUE+ML1bjltqQTcorWooZyoiOvHX8Elzeaqk7pTLVEfxU6
	1eNz8V86+b/e9SF27klhWCoOfqQCEqc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=cmCyDGAo;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FI7TlzcC;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogBMPA0Qx4PjkZ9OZjmL4avau0QGga2wYFkd3qrKkjA=;
	b=cmCyDGAoxa8oDitp4LrGWDkP4CDp+0lHo+E95wkqa425Lcn3w9cm+RbtYI5eSO9sXjWmat
	QoidlgrDeM4aH5qIvXHPl1TDVl5Iw559yftSUOCPc5GcBuxFifOb+nU3JxnfLbZdhCZ/Om
	61jBrg1gwc6UQdIBpO8pgask1Ph1G4gW3SA6b0NuVLd4pUoNaoNy0wPFXztdPp3d8hh+Zg
	svLYWwoSJyRDtbPyOPK0O339rD3z7Iwn0JP+dqM6WEftghcvuiSaHG4v/nGkA4phRhVCqH
	PJlYghaw7CnygCSTcXlznhUSRnaErzqNJ6mBTTdKTlafxylCV8WSXfEo+ZSzJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogBMPA0Qx4PjkZ9OZjmL4avau0QGga2wYFkd3qrKkjA=;
	b=FI7TlzcCK0viQr5GdhmEG+URex60ciyYkkkN9vhgUpMrF77XhfzOHKSYvwvEX+q3uNF/qq
	5xO9jwTwQOfMlyDw==
Date: Mon, 23 Nov 2026 14:50:54 +0100
Subject: [PATCH v6 03/11] ARM: vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-3-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
In-Reply-To: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
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
 Peter Zijlstra <peterz@infradead.org>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=2441;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=8GMxY0hgZLZmXIGNxEsx+zQJWvtZKAV9EO32aM3n8Sw=;
 b=LUKSJQixY6S9CU9mjQSgw2/Vb6bCSqXY+Xe0Ot0VvpO4DA94i5rRE3OxPHegS/C2s4VGPq1re
 6wJI1xLx7sRDEH/jE+pAglfUlG/v94LNXGZGAJwkNAq7NAX4/q3rqdM
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA87810000D
X-Stat-Signature: z3f13af6dbc837gmc1t3pkz6338sujdz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795441881-81210
X-HE-Meta: U2FsdGVkX1848+fUzbo9wARyshGJoRCBAiwTMyunSllyFTvM1XMs8FJ/hbyJ3dIsAHnT17DINyOyrZDaJqiktIqZEDQbgaSRFZZFci3aP4ShySBpVul1a0OKvAWHkiFc6j5uoP6IXXeylZtua/xlEHUS+/k742Nhh3USFrK/9SV/VyHT0s08/ddNIz6nxAPEbZKfQGtXFzZ+SLomTEqE9SwMG2fANp9ji9jkvFIR9c14fZTs46REaUcwIpQndNExR0xBXrhoqp//Qj3JAs3038StDje9fDesYrby9EN5GVxY0QTAg27i0/PYx7pwcuAikx4l7sDNr9YFboI4B5qzKsWhLwx4nxvhiF0oTyVsowZ+TABB+e3M/gfc/KcF+0e3KejnWelZeTvpnBKIncBMAYiosAJ5eJAVLW9yqGEPC2HolNakFSelxbtirWB19wSPoIlhg7vBUJ4vpDfKXsU+cVXyUYUGVKQogvUO9Nzvajc7ICaT2KRNOl9LifPAwbXzHST/VuaPZV1iGwIzicTA9lCa2Oq1HOvHFuNYOFw95j2h1ZubOjtc5KLndBqG8OkqzXWol7RNuQfOliHykJ5q5rIhYhNxS72Rm9JYzp0DuW1hvK4wBTNzamsYk/LOwe8/e4It3Kc76l0vy/6rMnFnm69Ij57HNqnqMU8VlEz1x3N+cVhh1wOnsZf4qyk1egUmWqI5UHOD7t+IL6+WVi8XMLjPDYX0GQV43oJU4BPcF/pX+s/F8fdy6mVXuZPcSUVcVC90KkmZ6ExoX1ns6+RqBM+OjDd9gb0UAMKi35xrqUSB8BDQMMabGfxZSGGe4WJKmJHxlifhNLFmCc8Nqwo+MdkkBlz7i2rzVJVnb4nyhbUzbNywcTQqnu2YZSpWiL8V4ucIiD1xkrp8p79UbGWhkNACSCtW/d+lop9tA779oqMnJfrTxNQX7eq5mre3Pyy8hB1XsSitndb0CIO/zFD
 1uNX2CAa
 VYvpDPiNagUuh/h0iorDTzWREyHNUP6/9eGmQAMDsUT/SotNvQDrvauP5irr0x1Yprvuy2JgeDjdcpT6PYus9jkiZR+y4S4K3iyNKK8jJ7LGQLWljTyObWdblDO1RiVVLs//GDxNv4PhrVwNPiS859Jzid+zbmS/6xr3CCg07Hyb5DngH5FSVjjgcSRARH9Fd91Lxd9Vk5b7te/hLrYfRR6UIrnjOOHbToCR29X5ZI8iGSgeR582SpZgkdASqq946ZC6a/nfRhOgOlZD6DZ7Q7ua6MiW3ois5gwjznmkCDvM+8lwp5CyZr1EemV24YSz1R8d5RPL0rNhNBYMVfRHipg8hZ2E204Gt+CapMFdYJaEGLdkPGAziuNDMmTIvefmymI4E+QEdTyKq6ub+5i4/w7Hha8xL5zeq4Un1VGd+ZbRCgMr3+SdnX0HNeyO+pRxhuNlppkuuPuf+EqkTiLtBZF9MXlARIAPL6MPg6/pXxBcohNW+mvMTfD9O+lvBkX9rIABkRJEBI2ULBKhHrQwsZ84vT5u5Wr/zLiiRsdozGdxVxpc2xeKLOaHP4WKwtdfVui3lgrLsKBEBxH9jBoprPJJtdwYdkab92imYapJFzTDFAAhECfGepzl1mkJD83cmUVCAxtodmez8ERv927/dtY39xQSUpYq7XwGEMlSypP7bzdzG9q+sJXZRyUcMcfZM8yAPg9z/jvPa/1faDv+EE/isnL2jxBEUL54wTJerBOA6n0aPjdFd8JV0xfxYMl65kYjHsp3csK0c2Ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The vdsocheck tool validates the object files and final .so library.
It can detect if the compiler created relocations which are incompatible
with the vDSO which need to be worked around.

Wire it up for the architecture.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/mm/Kconfig         | 1 +
 arch/arm/vdso/Makefile      | 4 ++--
 lib/vdso/check/vdsocheck.rs | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 41d7b495ec45..7f55ed37f464 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -943,6 +943,7 @@ config VDSO
 	depends on AEABI && MMU && CPU_V7
 	default y if ARM_ARCH_TIMER
 	select GENERIC_GETTIMEOFDAY
+	select VDSO_CHECK
 	help
 	  Place in the process address space an ELF shared object
 	  providing fast implementations of gettimeofday and
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index cf8cd39ab804..fd34d0ff018a 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -37,7 +37,7 @@ endif
 $(obj)/vdso.o : $(obj)/vdso.so
 
 # Link rule for the .so file
-$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso.so.dbg: $(obj)/vdso.so.raw $(obj)/vdsomunge FORCE
@@ -50,7 +50,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 # Actual build commands
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 quiet_cmd_vdsomunge = MUNGE   $@
       cmd_vdsomunge = $(objtree)/$(obj)/vdsomunge $< $@
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 8cd8c7f3fec8..e28ee59a900d 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -48,6 +48,15 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_ARM => AllowedRelocations {
+            in_object_file: &[
+                0,  /* R_ARM_NONE */
+                3,  /* R_ARM_REL32 */
+                42, /* R_ARM_PREL31 */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



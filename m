Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0757CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE9D8E00D2; Tue, 12 Aug 2025 01:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FDD8E00BE; Tue, 12 Aug 2025 01:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC738E00D2; Tue, 12 Aug 2025 01:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C659A8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 974071601B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:45 +0000 (UTC)
X-FDA: 83767016130.10.7D44916
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB01F100003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zocDmbkM;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=d4tRasLS;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977484; a=rsa-sha256;
	cv=none;
	b=zhlN7hWOVdCLtUxsE04zAdhyezQ8uzb/YUKfpePNhLxIiuvflAQqte2VQjZ/oNctJESehT
	a6tAaSj0W9QKPJkZ+rSnsBowhqw3p/GAxMWpInoPpPdWynnwNKimZMYNrVRXIJM9fYYbnr
	tj1jwv0CdWFsEZWUouNN7Atf+SOFB9Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zocDmbkM;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=d4tRasLS;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfCt5JZT5TLY1vTOkO3zmfWoCgmYOOlaa/RcOHdKaps=;
	b=tZF4UAxBSKxHxShmVAuhpDr7Krc2r9/5cMSKN/CqBBzNqp1Kk59SQ1ucjF6xVLLFgO9giz
	kD6efUTSCZ1i0LonWP3fEv8QpCNNtnPyV2n9phkTXz037GxcV5SvLCZKXH1hguE7EiUeh2
	qPLyMmTvg1+T+jjWjzNMKCK5V9k+Rxs=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HfCt5JZT5TLY1vTOkO3zmfWoCgmYOOlaa/RcOHdKaps=;
	b=zocDmbkM7SrtEfoMUMLk7syduA2FoS07iTJjRQxpoxVtJk6FCTcA63FHi4HDZhjOydKkAT
	DrrV0zBYz8rfc084esfgs4uuXAkhxzoVwcqdSmF7BEFWQKKsdlPKcE3LkSmnxFYonNODFZ
	2sN1ZNTgiR2KEOVXZQEVEMIVuHADKnDkoOaaebcfpKh5m4MlO1i3mxd6K0dfDn4f2gzo2k
	hM+ll5vK+/7O/uRdgK7BcmGop+bMKCmttdkUi9IyiFrD6fxo3aGU/1dH+Y4ccEvyjf/xRm
	ukysMSWz8XN0tHKKSQ2jKT60/8Q/5ewwHZkK0m/GvkKLUmwKhqnNwsd4lL/hmw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HfCt5JZT5TLY1vTOkO3zmfWoCgmYOOlaa/RcOHdKaps=;
	b=d4tRasLSDVTIK2B95jsGzJ+ah9uconnEpGunOzkAkX0RhJ6u8QF5Rm6WA7PtZmvXd7GJ+4
	tmhczEYwE7G4MtAQ==
Date: Tue, 12 Aug 2025 07:44:25 +0200
Subject: [PATCH v4 12/24] x86/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-12-61a8b615e5ec@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
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
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3221;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=y8zJkYgbdBbZEV0tFUnY1VVHpY6kpQMx7JNEIl5bx6U=;
 b=fENeUAc8ExvUZD2cHV52CW4BlgBth0NPCMcPLk1EKHf1hnG4lTQ/vRhPMnJvsZZXuIYsNnulZ
 VQ7lpvqs+SzB4XtQHOZ7OgLms0zrQWlEQppNKDCg82HN7J6F262h/0M
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AB01F100003
X-Stat-Signature: ytq3dgsbcyx4xhmyrz1d5o9i6a6eita1
X-HE-Tag: 1754977483-773088
X-HE-Meta: U2FsdGVkX19ajQu16uk3VFhMfzE3+38bWBnL69DFLtsc2XWMWC6sieIIlKQtBkdjIK67uSUt5nFn8sM70gy6LBOvlgpUwy9v8ORzPtE3ZA5y4fDiR9AKwfG/Abuf7wA6h2pzWb+9xvg0mD6Uo2+pvHfx6TKrstATZe76VLzR+9MKtsWuPtFFrqy5nx5K/HeAbYgYzqQNIS8nd+cRVSiEu8e3uHqPzyNSBtE6RN1eNptChRyXkPxJd32iXaFVWMfi0mr+Zsg2TJlMy4FAlAWHoh+YOn+YIeGpBVQJOUY4xQelHfvuAxoh+rhPaCnBer7iQa2fxGH/cHDd7IYTTs1IyohVUjv+Vv/4iAInpaYNpj85/ctwJwMJkVjADbadNsYjHiZlnGNxLMGek5g37dAeHspaOyWpTbTOFk/JHbgyRC/gPDu8HX9Q68zb+luzRIsTaJ31fUpLfdlpDxUDrexYTn6aW24gjPCVGS9rQjGPb4CfNojIbdTz2yXYuLgbO5BZXzLy3z+Q6il7W/3y9xDMh9V0E67kaiWHK1PJYjHMjzhuWl3SvGvn3oP3rvM47G0SFldyLjtrQDiDGNGXSbpPauM6zlqk0LOM62OIJE7z6PR8lQCOL7iTTusumJBYN7vPV83g0e9AaVD8VJBkWw4BQY6xMsRr7U3PmrouqG7HWQ1CXj0ptxOoN9fEW1sGQU9VmjzuZq/LnHIDkL45wgnZFwBWzGa4850w3wtJEK4dUqseM8kZGHphqyLxJ15Q6sMq7sNP4EDhUfIJzrf+2YyY7ceOPuGhr0jq6QvllLOUY9VwRCRTn3J2pbVp323WPmQ3fGN7uQobmePgkmhNmnMD9XgnMUH7YsbjwzU7pOwCZIn6u7xCgma665uQIZA+Hjedn1R8OHV/dzVxnCQZNduq5sCLZBNIYm6jis1CifJ70XMxpNbE/2rcdwcOwBftWUq1YPQvw56Gw88SzEtsGsd
 eA7Flo+f
 INywUhCBWsSsMWokDmntX0rhx5oBWinkXsrA7KSfpYNyctRIjhx1IAwg1XT6I2WbadMNOzAMcb6GgXzzRm+epTImvROJpOe4m2N8CwY+yD99JIDVMl6uvn7pVayiSsBswOR4FcvKYDpsie0yHtGprZ5G44uTcBdW9KjNuPrH9meBLhq6YrA057kECRKNzuvVT52gyAP6FOoKTpQI/dg3kdkHqP4cnpJ4ilvYqgndlHknplAZu0+EfBnTkCv7uVuy98XVc6uPO9dAFsHGQDYqg45wLy07U1+qJozlYhYc5tnowtIs8UbznIlw+PpHgTFJivqk6BcEnoTxsDRddeJYSgIjTGDvj8440YsFgJI4U9E3eJzgcFjFkPc6sd4Hx9JGUp3XX6Idy9PXxP6unXyfoPGurvJmoajEJyxTU7RCVMeyyDerzqH4MD24XPeSyqfmMgv+0jjs2uREmidj9zBinu8c5YLO0X6Dvio4nAPF8AVHIDLCm9vCZ5+Av36dGmiqGCser
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/x86/entry/vdso/Makefile |  6 +++---
 lib/vdso/Kconfig             |  1 +
 lib/vdso/check/vdsocheck.rs  | 12 ++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index f247f5f5cb44dad706701dd5344c9a8031deffc1..9da9cdf8c976ccebac1429afd244d4c9ea6ef5fa 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -35,7 +35,7 @@ CPPFLAGS_vdso.lds += -P -C
 VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 \
 			-z max-page-size=4096
 
-$(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi -I$(srctree)/arch/$(SUBARCH)/include/uapi
@@ -108,7 +108,7 @@ $(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
-$(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
+$(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 CPPFLAGS_vdso32/vdso32.lds = $(CPPFLAGS_vdso.lds)
@@ -144,7 +144,7 @@ endif
 
 $(obj)/vdso32.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
-$(obj)/vdso32.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32) FORCE
+$(obj)/vdso32.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 #
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index b461e2be6db80eae957c8e0a1ab573a85d78fd15..e9215084462dfb33a5cd55a57171d2ec4295a270 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -51,6 +51,7 @@ config GENERIC_VDSO_DATA_STORE
 
 config HAVE_VDSOCHECK
 	bool
+	default y if X86
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 3c421100a91740ce3735edfbc9837ef49f55d8f8..c4feb75f93ec0a6a153a758ee7a51cc6f2f58bf1 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -34,6 +34,18 @@ fn is_ignored_section(&self, section: &elf::Section<'_>) -> bool {
 
 fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'static>> {
     match machine as u32 {
+        bindings::EM_386 => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_386_PC32,
+                bindings::R_386_GOTOFF,
+                bindings::R_386_GOTPC,
+            ],
+        }),
+        bindings::EM_X86_64 => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[bindings::R_X86_64_PC32, bindings::R_X86_64_PLT32],
+        }),
         _ => None,
     }
 }

-- 
2.50.1



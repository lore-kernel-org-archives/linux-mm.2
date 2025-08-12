Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D161CCA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FE38E00D4; Tue, 12 Aug 2025 01:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB4C8E00BE; Tue, 12 Aug 2025 01:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C2F8E00D4; Tue, 12 Aug 2025 01:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6298E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D267F1A01C2
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:48 +0000 (UTC)
X-FDA: 83767016256.26.6FBB219
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id F10F840008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=M7S40MwV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=oT3QciTb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977487; a=rsa-sha256;
	cv=none;
	b=PyKBcH8oZ4q0L3PLkkOXmcFIR6DdCcDTsZja76rUhbDq+fbmKbM9WcL0XOkQ6oVCKry9yn
	ux3IKUWbA3lq+O76eBDHsJb58jYzlOYxPzt/+SGp0dV8xlri4kG69AzUqpYjUHVHwOsY0N
	XJLEyQMHTrhIhQozI6fOALzFQppOx/0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=M7S40MwV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=oT3QciTb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xnh72HUbhzd4qempQkZ++BS8+pzvYgS+1ottOAOyHdU=;
	b=6ug85m9AKQoQwSaYLs5jIZmueRaOTgv0f6b4hOU6ILgowVsh74X22C5qiyGTY1qUJ4Lx8+
	FtVTb9cleswiM9SXVPsEhBwQJEIyucMpGiLv1rbr8MNdkb6rcTd3nlR29oai28TyUOzmXS
	JqiUhyqYXLYtAubBI3sFiXpChOa2HfM=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xnh72HUbhzd4qempQkZ++BS8+pzvYgS+1ottOAOyHdU=;
	b=M7S40MwV/29NPfO9Sasy+ADfYcsvNi5Apjwn245Ady0D3VOmbwdncNTgeKb1CtGlZMH2y5
	VLb+3/m+Kr/szGiTLJd4uAnGlG3BOQdpLLeDU2s3RuY0jGaoJQ9CoZ8ywkJenQVTh8q1ZU
	AzYugh31VGsAyOYBGTv9zwM7UTdCqcxGOgnyVS8W0fkGMwNgHzjkZfXtr0UvL1e7UJMMmF
	nJcpgacbXj6Sj/nRL1V06LnhMjF7zs1jSvpx57y2lKdkro1SgilU5GZG0SWcrItG0ikYUg
	AXOR889bzaLnAigaurgMDW06LMjY90s899cXrcGjUdmhdbEMejfGbP4Qf1yxPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xnh72HUbhzd4qempQkZ++BS8+pzvYgS+1ottOAOyHdU=;
	b=oT3QciTbYI+S9gc2w0Nm9Wh0wRDtrD56Uiy+WUIfVLkM867MFCQ7qwFFCJ/zKjjlLlWrmY
	vK59scPXpcCQ33AQ==
Date: Tue, 12 Aug 2025 07:44:27 +0200
Subject: [PATCH v4 14/24] arm64: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-14-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=2714;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=3K4dUUVStWjQ5/WBfnnWwj1hNxnDgSGwmxNLWqKjR7g=;
 b=yJ2PupWNQCp+kR/s6ueQVFH3FycSSSmFfTc8D7vtTv0iU6LC1cQ44wErnQahnnu4cKtXubosj
 a7zqtL+HXllCbNMWl3p7/xwQr+4L7lGG20l7mLQYJBiX+218aWqN4J7
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F10F840008
X-Stat-Signature: zwzcpni5zh1f9sc4e7oqwdsumm941gqd
X-Rspam-User: 
X-HE-Tag: 1754977486-314751
X-HE-Meta: U2FsdGVkX18dVLtkLVBX7e1+Vou24BYT3/FI24UDk6LXWYdYWyL4nN/+uKl1w64ndJMHRAwW1zUTVdJ1a+ZnE7NF2++HUs4k8lOrTYKNucNjowikvK0HuANHJdL1e4WPKLhgea6i+TEPf9EHZUM8CNi/eNKomeu4eCvZYHZv+a0JgLXLBlTckjDNKTy4i8OaarLajEaJHLYp2ggHUsSpSShcKPmtnG1FdXMic4pcBc8aZAj9DjADV5WNJm4IKRLGqc3ZxfndLaR5sx5MFtwxZyI+F7OThgg8tpSjeupJnO6w7PeShutgGrGQhk3hjaN3eV8K9XAfImzxfZOno3YibuvCo++qgbJ6nAns2u0U4W5e2uOhTyTb6dvQnwm3Rye43UeUueqOj9B/D4ZzETxf31R7GfC4L/wwwXvIs2Y1FMrQnfjz1EPwBsqxN3x2c1Jc1p+YWFzbLfRb+QPOmsyMi+HaW563dj+j7KvOWLW9rQ6oKYTxN64QJdfNqEH9Hs6/7cDHWKY/KmqnXtUsBKI2SoxVrMnAayWrW8UZz39oGx+PIj7COQRx4vDVqDL/aw+KdwE2ugWSdWKQemW+bF8EKCHVA3QKjWkDONEHJtFYIokyUD2Qiun1aP1oPpqoYRmziblm4B0eh8mXt6ISTEPmxgZHaTj+d6SYwl/MSFDf0mVxFdM508wdKEo4IRGv0DDQQ8NuMlMPkA4V+2KXkeQEme9W16ceR88YDTNOscvumCxJX6FV6SaRMwkSBmMwiYQ8219+nK3bukskJnnGHibnfs48w3GX7UudPGxfNuYe7k3Vp0p0HCkSWeZjKMK0Q2J2xdW5TWFrskhvDjJ1ZY+tBtZ9rRgqsxit6pVUxUr2u8h+1ofWEXMS/Kgs+C9e1ZI4AYFVv6W/SImnrHQPw8U1bdUoL1fqWNFypPf5QxOQzS/ajbexXspeNOsadmNSIgruQ0R3/X3KMMK+Pf3JedZ
 MKs3VE2V
 WIEFcNTxXUPa0q8MzOEseqOvBhKoBLVrv2Rd8+jd/zlIfTdLEMB2Wf7bJE5XqPZucPh71nEnEWZlDPRAqyJPm12geJ2TNHrUPjzhAnWTR1S03A0bg+qt+KCVrKNfJBMD6Z+LrNhfudsCKv9ZhMIT/9mEZFKLMA6q6C/RKnM1Pu2O0QnnF6ZDmgWy91bH40GoQkoK3Yz0pL19V2XSfnvrqgHpPuIKOhq7DTesEMXVWPR5C4MnRXpq+PtUFg9cttkX1PH1wPDHCTvx0WSONWn0Cg7d6gSPmP8RYOvBukQZjTtdxUN3S66ezrINbBJSErhDkzvrEpFBeUKlIhsHWXUJIBugZD6q/1MOVMYAK4U1Cfs0tihSnXeLkcSj4bPEp3dE9auHSNKUBlL61eIxhPajuRXEO2HruSYOON9E8cAOO1+ZQ6FNUi1KFIQNU+4puYjpZPyv4SnUCOiF6iXPdOi4wmg+mlO4Ka4rfQpT6n6YmLdScHwbyceapeBgtgwxbm5yje9jz
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
 arch/arm64/kernel/vdso/Makefile |  4 ++--
 lib/vdso/Kconfig                |  1 +
 lib/vdso/check/vdsocheck.rs     | 11 +++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 7dec05dd33b70ea8fc734e0c13af9ec4568d80a8..9fac0e54097dc552dbfe81074da71492c79c9230 100644
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
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 84bff59ccef4acd95159d03e96991161a029fb2d..3037b15476bb60ee47c1e083eae3968ab9604f59 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -53,6 +53,7 @@ config HAVE_VDSOCHECK
 	bool
 	default y if X86
 	default y if ARM
+	default y if ARM64
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 23970b9d05dc320eb4966967904deae661171b15..a695aed95ad391a0c55e5388bc6d1f1141fd784e 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -54,6 +54,17 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_ARM_PREL31,
             ],
         }),
+        bindings::EM_AARCH64 => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_AARCH64_PREL64,
+                bindings::R_AARCH64_PREL32,
+                bindings::R_AARCH64_PREL16,
+                bindings::R_AARCH64_LD_PREL_LO19,
+                bindings::R_AARCH64_ADR_PREL_LO21,
+                bindings::R_AARCH64_CALL26,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DCE606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=y2qrpUFH;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=XY2hGy4c
Received: by kanga.kvack.org (Postfix)
	id 55E636B05B8; Mon, 23 Nov 2026 08:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D4E6B05B9; Mon, 23 Nov 2026 08:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5896B05BA; Mon, 23 Nov 2026 08:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1810E6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DB021208AF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:26 +0000 (UTC)
X-FDA: 85466520972.17.69489D0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE034C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=y2qrpUFH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XY2hGy4c;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441885;
	b=RaKXst6pEmBavov+aW3T8IiXh2o0WLfpkuitKTSTEJ87u3UBMkIe6L7Bzbc1HeSrVk7ByQ
	waQrazTwnC6mXFMeVRHMF/2lwU/xVxUEAtmLTPgR8v+XcC3s+wHFtr+R7FhXcchBpP1w58
	4r+9Ab0yJyhgDqupLekJ/sb8JbZzVtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eFtOIUXlB/3zrN30y5Vr5c5KdL9zNbkcXs+QwRBLLo=;
	b=GbkxKBMOV6ThsSFP9KlXsi1uYRAtyxyHT2vnc9Eo+T142zoPHBI1ccopltWseRuBdDYkjY
	aOhElN2Hn0l6933J+5LTFDhrs08rP3j4BJCJRPW/wA0qXQmGyjzqMVEylbFj0kUV9ZGopS
	9Iy/5Lw6Twc1OZlHozU9+a8pjKK3LNw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=y2qrpUFH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XY2hGy4c;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4eFtOIUXlB/3zrN30y5Vr5c5KdL9zNbkcXs+QwRBLLo=;
	b=y2qrpUFHjyo+0pMBHaWwUhYXbTJNPIcVR4whnZwubVPwGrLaE+1Mmk2Mwi5WKuQDu7n6iK
	IxT3kxQpnVBBexAnF0ihS5lfLDaFO2yZB/xnwdS5zoFeUyigBfLzBR9hxvT3x4gDmc+6ZJ
	flIELvpITzh8VhPCfJya5ZOTnXK/xiterHEPXNFbpa5f+Qizmz2LKuMplLRNcmsaccPT71
	bzlF810zu1Rww5Diqxf9sA0ClHmhjYZs9LcDI8M2QN/FteZKxNbWWCxFnzgO4x1Y2LXygE
	/0EP1KSgGHVkf/dr39ZaV3wh4xEEjOL8onok1E/zu4qmvtjdVXNW+2xfMnH4iQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4eFtOIUXlB/3zrN30y5Vr5c5KdL9zNbkcXs+QwRBLLo=;
	b=XY2hGy4cWmay/FFPNrPlsYtYrkhSLiBVvC67xaDxTH8uahrD+vR0WYB/jdZNhsfoWk9NzD
	rmVwXtqSDk1V2JAg==
Date: Mon, 23 Nov 2026 14:50:57 +0100
Subject: [PATCH v6 06/11] riscv: vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-6-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=3576;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=MntGa2c7F/hFX8g0jBZrZAZFlve/PN+fivtH3qTBWPk=;
 b=E0OeOrGeIR7bOANcC60kOQeCX/ghNoL4OOe/6jVEwOUqPM8BuZA5TNCH2kWGUvAnrKk1cra32
 Sqyo9hLfgFEAlCARi9PB7WSaGZbX9p2AcUfrE8XdPahGDH8DoZdd3Qg
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: c9rif7615eyom4kudqc8jwwd11b5fxwf
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE034C0003
X-HE-Tag: 1795441884-841107
X-HE-Meta: U2FsdGVkX190Rv1d3LnyfBTWbdGueHa5mDRY88rCtPRVZExfrM1Jd8mhHX8XLr/iqp39CefE7rrxJJCCQCHP9484JiGZig5lBKE7imrwAVm8AhQQ1UoyRQEcZI/WVae0CqtgcZqS5PWGmIymxSue0zhF8sOOacmo3edaWA1OfpAfuY6pBVbzzCZKA7bf4Rh01u4JGPIDA9RpGP5njwCLaKPKUUO5jv0XCfVnkmeFedCEQW3DYcMFIAlFEJ+H/hUJlkSWYCK8BHY/67J2DtsTUuMnorWptDGmBr+22qdt2JFRaXA3PFJizX1OIRUYPNr1Be374T+WC2kaNMan3jLcsv5NIYi3Sywlk7//ikcQRFM0X3IWCliEbej3tm+b6mhMadU07TRN4/qB9VzuqJTRvylfVzyPdg1vPSayzWBVHyDYpoGqhRbLMrp1Ia93tsImukmLx0bNKNw0hicR0Gl3Ou/XQYVQbzXNf8ksJj+cvZQuw/uDKTv6VgoF9oItXxdnr9P8Y/z7SDRYGI6DqK7UJgYjcKVQVTq1JiDQwfCjA8tNNM4nV9PtBVCVfGerLSq6fvi9eywG3lfyEbW33Z8qn18/m6BmMq/W9Q9/i4AzrHuuOpbZYujQn6aqGSOM+vJ1bp3zlFFwAfFsLJcp3Xh3kt78T4a2HoMcpY9c4nGMDVZSpDNgCEGKQQg+wZHqtEvKMiijbTPFyK9vVTfdadviR7vkvFG5mEWET+ckamJEQ83GC0zEg4RqeEx7hAfScEHk/w+3f4W9diqBwcTJeRyvMo3pD/cNTKHoMnnFZeTl9cey6ZfG9m1sXpddgO4aXlqqm4KIw3olzLi+92+d9R0dz+YDI1rQE9oYBffH80ZKNwPpz57JKKzyjBRR4XYm287/C9uYEApyfm7iPAYMUMvEjFPwNVKlyzARtMOqMRrCQonTZuHOqwFSIiOKfxwTmyS6PqGuh40yGoNbOBfk+w3
 aElw7dfD
 ZlTmJYedKRsbD8Wj7OuPNXPy0HyN22o2Fiy13W6Kca6wQri68+rFGWBsOqcJosxdcGlsp/zjptxljE7iFqvzHl6FdvVaewyHJHjsDIOeoqwegEKbhC4rVP0BK5ND6dSTexGj7HQ02YdAbpYO7LykL+46CbioCCpDfaAhXP2+Q0KuhnUdzPXqe+9wJuNiP/pbjWweD80PshZx45kwxH/Dbwz8j+lDQlRS/mygbEO+5/qg2pG6IKdBs9jBBg3oWHkM8PX1Hgw/WN7ViVvUuAHub5d4dwNnXX21PGH7s7LB7wWPktUeSXrLZj9oL7/x8qzAuQSdZv6zfmx/yRslZDFqpKkMMHkh7GaWYJHhIuK7HQ5D25u+2XEGRpb6YCVL+T43PswXqvgaEiwqnAcJ6m91DC7SAdfF+JaH7QGcmWvgvyNkpeFv78TXHkaBkJJXjvGK9wxzDYQ69Ixn/j81Gf8zgOlgTFKfBE9XJFJiYAOZ89NaCTdH+3CXzFmA/d/txTzfTxUfG91cEppfks063mV2ma8062DuVojAWS/uvEg0KcTsNTFFzwuzAjPau6eRWQOwGPskePWMxM7wxXtLW+k9lULDBfWJMZr6uAnryZOHWSlJ69OgBxNsUDaq7blokpjz8V+M8L4pr9H0cu2map9hn3FdzXXUNTfPSGXEP7/8NUlL0HPm8hC3s6mPOUUlcWBEukgkpXBTBExKNwakGy+WFf0bvROc9l7VpBL9ZG6AX1r08y6b2r62yY+zKi2PHSq8C6kTopzU0Aj56MnY=
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
 arch/riscv/Kconfig              |  1 +
 arch/riscv/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs     | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e7891a2a89da..2a0f5fbcd7e3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -226,6 +226,7 @@ config RISCV
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
 	select UACCESS_MEMCPY if !MMU
+	select VDSO_CHECK if MMU
 	select VDSO_DATASTORE if MMU
 	select VDSO_GETRANDOM if MMU && 64BIT
 	select USER_STACKTRACE_SUPPORT
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index c023046a3fd7..b15039d0309e 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -75,7 +75,7 @@ endif
 $(obj)/$(vdso_o): $(obj)/$(vdso_so)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
+$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_check)
 LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
 	--build-id=sha1 --eh-frame-hdr
@@ -97,7 +97,7 @@ include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE $(vdsocheck),$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index da58ff220eab..37455d326110 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -96,6 +96,32 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_RISCV => AllowedRelocations {
+            in_object_file: &[
+                16, /* R_RISCV_BRANCH */
+                17, /* R_RISCV_JAL */
+                18, /* R_RISCV_CALL */
+                19, /* R_RISCV_CALL_PLT */
+                23, /* R_RISCV_PCREL_HI20 */
+                24, /* R_RISCV_PCREL_LO12_I */
+                25, /* R_RISCV_PCREL_LO12_S */
+                33, /* R_RISCV_ADD8 */
+                34, /* R_RISCV_ADD16 */
+                35, /* R_RISCV_ADD32 */
+                36, /* R_RISCV_ADD64 */
+                37, /* R_RISCV_SUB8 */
+                38, /* R_RISCV_SUB16 */
+                39, /* R_RISCV_SUB32 */
+                40, /* R_RISCV_SUB64 */
+                43, /* R_RISCV_ALIGN */
+                44, /* R_RISCV_RVC_BRANCH */
+                45, /* R_RISCV_RVC_JUMP */
+                51, /* R_RISCV_RELAX */
+                57, /* R_RISCV_32_PCREL */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



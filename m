Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DF3606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=SiwubxeC;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=PafwDopS
Received: by kanga.kvack.org (Postfix)
	id 0C9636B05BB; Mon, 23 Nov 2026 08:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1A26B05BC; Mon, 23 Nov 2026 08:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9A16B05BD; Mon, 23 Nov 2026 08:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61276B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57A034088F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:38 +0000 (UTC)
X-FDA: 85466521476.05.9CCD8A1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D404A000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SiwubxeC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=PafwDopS;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441896;
	b=17sPjq9JXth+0gFcFPm+BG76H0mzecGBjVTCo1K21ke9hNBzElj+wCWVPlmwEGeaMH7+Ir
	sl02xoLPdaZ/NDBpe7WcVef4cXSkIELR6ytx9gzOnlEcyPXYzkth9IH2oVVBcXtxkD08Xb
	jLb1kLHuuSRp9nRJiBJntIbiFlnC0A8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjaHNfa5Y44gCMgWsYt1z6nK9zr8xQHMwn0hbi1HiNM=;
	b=3rkylaQtHyotguGbhFkhn+nKq4sxvRRtVwFnqrzMaFINh0VGmz7lT6aavc2PFcbE0fSdRF
	EEwqRsoJwI615uXiz1MSLdamr7Z2epLLN2Bf7MnwGoLnd049W/cCb2TWL/5xYd3KzPA4Nq
	kxuo6CQHTAetXHQzAu1wzs4gG3tySOw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SiwubxeC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=PafwDopS;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjaHNfa5Y44gCMgWsYt1z6nK9zr8xQHMwn0hbi1HiNM=;
	b=SiwubxeCodkmCiyMiY0r3O3GYOxwf9QzlLWSX2cpPhBgivhjzkKnYInYXnUPRJ9q1AM6fa
	9KkieGgGHK4lkoTLljHPihz1R+eHTQWESt5TuMG50onKo49h7JofyUYZZjilfRnsoib5mr
	Qiqs0Z3BCxBrRWAky4Cn2HdCp/gn12+i0i5+6/PA8n1jhoJpgxx+HlaevhQMaSmZl+G+TQ
	JsfPuj61DWlLMARl4U0pr8/7yoD0mIcpoVMSqSy6jG/w5ANlrvclfuNYCWounvhNVvu7wn
	eqhn8B09ZzFesEu1LdSxg18G2PPjAT1Do9Jhxt/FuTIm9kaITu6bjzCFpHdSyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjaHNfa5Y44gCMgWsYt1z6nK9zr8xQHMwn0hbi1HiNM=;
	b=PafwDopSrXMBMvIj+bOD/YaIZDnPhIeNmmxdQxl/A5OHikWrncrLqgZj1zSo7Go0RBz1dv
	KMFUL9taJSMknzDA==
Date: Mon, 23 Nov 2026 14:51:00 +0100
Subject: [PATCH v6 09/11] MIPS: vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-9-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=3612;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Upl7hsN7pYYITVcy/+9101coWRtl3qz4kkbkOxlORLo=;
 b=1fcEqYJBI/20+ipq+0gDhD2Hd2sHPo/b0TvsKaodh5hN8w9Rzt6iK8kpNsUn/MbwZcKE9qON0
 QkgrCaLMbbZBAsGdd/7c8BYFky+KQdnee/5otFkVjoWKNloGTmEJP3S
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: rb8aoz7jmzn3syokdsmsdzbjmbrn7b9h
X-Rspam-User:
X-Rspamd-Queue-Id: 6D404A000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795441896-795480
X-HE-Meta: U2FsdGVkX19PrVDSKGcIQGDg9Yg5I1MM25MVN6R99l0AJqEDGiKfTyio/9c/JKtLwKiX53SkSAdMBu8Kw7xBvlb+d0QVEsoKz8tjjE5uBA6XzBNhJyk3zF88cqYzgr+R+lB/e5Ec2RrqDWArxRJZxqxCBY5e2yvWw8NKeRN3cAli/+q/pK0ei/ma9emnjzSg3tiNjS9k6x1VzmDfVUqtyIXFoipOlpEmrnpniRolEZ+FZRObc5M3aQedjU7IiC7l135pgqI+zfPZcGScNI/VFkS3ikE6q2xEjL3Gt/0dX2c7xD6TdiFVSAcClWv/2bY7MrrB6YYJF8WEY4n8WPmT8njzIcljEoJjqnam+JgCvwZ7enNJ5kc2Rw4bufkoI1cEQvSQV/VrRebryq2av3z+1V/QY1k/ho0/lVl6/GF+9MMyiGRTi+WJZocF5aE2MUsce9Nkej7KkDz02A+vieHC4qoNZ+R0i3FdWWU+GEDfx2QcuuDsdGlNlLyCSQogk4UAqLgBRQd5y9cn+LihTlRt5IEvx6eb2cclQVQ09y5fg+E6c++ILx12H1CbTqDXBTL0WDsUWUITBHTKw7UgqJhZDCABUGweuedhWnAeJPxcRVfewiIjIylWuOX0QIeaMwGmy3qg0jitbG9BAmuBOAjPuy/4EUOCp6DP0c3S92cEjX7Ct+sAfCa3gRMCwd4M2v5e7kaKeytF6G5FcpH4TEKsKFUSfj0Whr8Q+Ho2kzkxX2Oz2pz0r7Q+8MhW7OEfegaEEb042iyIXErOqwQoI7XzoQrppQs0iWBqz/4jUhmigT5lj7VPdaNALzy6+CbcJdDdJ4MBIcV/un1k4vKrVpq3JdcTnvivZXEfBO2NDAs6uMy5RF6xE1Eo+GXMMLaMMVsrMgnHWSd2P1z4iWs7J6n3a97UiiincG1ClrQ+P0a3Og+Uyrr29IAVuVFz3BGR8Qt8aSDiHichi5VYP+wTs/P
 RuqrI3p4
 CS55Cv1Vo9JLZpzyrBEAtoID3pvrQI8GMit7ySfeRnA2MCmdPyneoHHDfaZe06sLWOyt5vGZ1JutKXRpbHDdyS/8hdqlfR9hN/WHXY72GCz0nIPix4r+c264V4/YYU7uAoAHYIhs+AgFxeRxUb8/YLZfl3SQOhwNBMIZmuCo4UhF/NMYCq+O7t64QBlu9H6IXetd8sS1ZyCBBloIpOuX3JuT/dYuJF7+r6icNzDOCqoXGzUZ/VlBzb8gKuXH+fIIYamcn+8Lj2rD13Ak9u500zeKmlEcIkMptvC3448r+ranO6CTF9aTUYlWN25NFw1M0W1r83qECXkpkFWGT2aYYwKtxLjK6lBzPs1Gs14ZbPsldrnUhzMY64cOV2StAgdbOVGQYv4bajY+5/4hoVhFh2hNf+Tx4XGyh/PXfrODKlHBwziguEHUO47N6cvXYCzcADWatrcwn0zD/BnH7J12YdkXICDKR7D/kSwu2EybVwuCvp6fDIsuFQKVAMWhv8WWguZpsrAmJ+nGtIcEahM3bXIyI7j7zyMWzr4upe5CIU4BBjocGK4Jef/Hc5d9SicA0O88LrlKYmCCAZOJ16f1EisLNCCnS7aQCB2hY+ycSZnZGvvrDKyjWDq3E+2IDPpfbv/GAdfD9JllRTq495aznfSwHEuO73RXeIAzgVH78YBvACzvuzwUCRwFL0+UfWp9yeKK4CIH7ulC6TEwiemvqVRtJF9QOADcVWm8OPKfn08YzMFZs1h2BNUPs1MCFL0TFPp3m4cAEQIf7Twk=
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
 arch/mips/Kconfig           |  1 +
 arch/mips/vdso/Makefile     |  8 ++++----
 lib/vdso/check/vdsocheck.rs | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ed17c9b1624c..31c247c2faeb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -106,6 +106,7 @@ config MIPS
 	select TRACE_IRQFLAGS_SUPPORT
 	select ARCH_HAS_ELFCORE_COMPAT
 	select HAVE_ARCH_KCSAN if 64BIT
+	select VDSO_CHECK
 
 config MIPS_FIXUP_BIGPHYS_ADDR
 	bool
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 00d3ba2c482a..63060057cd21 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -66,7 +66,7 @@ quiet_cmd_vdso_mips_check = VDSOCHK $@
 #
 
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check); $(cmd_vdso_mips_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check); $(cmd_vdso_mips_check)
 
 quiet_cmd_vdsoas_o_S = AS      $@
       cmd_vdsoas_o_S = $(CC) $(a_flags) -c -o $@ $<
@@ -103,7 +103,7 @@ $(obj-vdso): KBUILD_AFLAGS := $(aflags-vdso) $(native-abi)
 
 $(obj)/vdso.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) $(native-abi)
 
-$(obj)/vdso.so.dbg.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg.raw: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-image.c: $(obj)/vdso.so.dbg.raw $(obj)/vdso.so.raw \
@@ -141,7 +141,7 @@ $(obj)/vdso-o32.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) -mabi=32
 $(obj)/vdso-o32.lds: $(src)/vdso.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
-$(obj)/vdso-o32.so.dbg.raw: $(obj)/vdso-o32.lds $(obj-vdso-o32) FORCE
+$(obj)/vdso-o32.so.dbg.raw: $(obj)/vdso-o32.lds $(obj-vdso-o32) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-o32-image.c: VDSO_NAME := o32
@@ -181,7 +181,7 @@ $(obj)/vdso-n32.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) -mabi=n32
 $(obj)/vdso-n32.lds: $(src)/vdso.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
-$(obj)/vdso-n32.so.dbg.raw: $(obj)/vdso-n32.lds $(obj-vdso-n32) FORCE
+$(obj)/vdso-n32.so.dbg.raw: $(obj)/vdso-n32.lds $(obj-vdso-n32) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-n32-image.c: VDSO_NAME := n32
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 1ef3f240f886..120d8fa551e6 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -157,6 +157,21 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_MIPS => AllowedRelocations {
+            ignored_object_file_sections: &[".rel.pdr", ".rela.pdr"],
+            in_object_file: &[
+                10,  /* R_MIPS_PC16 */
+                60,  /* R_MIPS_PC21_S2 */
+                61,  /* R_MIPS_PC26_S2 */
+                62,  /* R_MIPS_PC18_S3 */
+                63,  /* R_MIPS_PC19_S2 */
+                64,  /* R_MIPS_PCHI16 */
+                65,  /* R_MIPS_PCLO16 */
+                248, /* R_MIPS_PC32 */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FB1C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F056B00A4; Tue,  8 Sep 2026 02:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38976B00A6; Tue,  8 Sep 2026 02:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27146B00A7; Tue,  8 Sep 2026 02:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE36A6B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50FA2C03B7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:59 +0000 (UTC)
X-FDA: 85189629798.24.4E7FF97
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A5D680003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=MJbNcbqr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=X30WsAgk;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmuSOH1PlxKnA1sFNyVBb78Nx7lvcJxtk6uyQh9eAbo=;
	b=C1lPcYnVnV2kPjzB/RzWKWOTTriipNpMWuEMsDiHY4Z4VKtpYLJ1aT7YQo8xIrFzqO52+j
	4Mlrvm/fWrJQ9JZVkHuc5CsXMWcICeXVINxrtMYBOkpgqIxINK704TyErVGLCo2djKAakE
	ew0ME8TCPoQfSCDs2PMG6X+ZAPipocY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849237;
	b=me/vF5b8sNx6nOKC8QOHs/nVHPnLRfoG+LKAifrzMZ/FMUU7KOMxdTEKtvlgalS9BevZw8
	BjM0vhpEUOziN0Zhj75Lxfs9K6b2s9QzP4Lkepw6LaZ7okXBArM2zaz+/z56+QduZPqaJ8
	Fo/t8BbWcv8bOA9X+BTHp6FBVFqRmyE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=MJbNcbqr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=X30WsAgk;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmuSOH1PlxKnA1sFNyVBb78Nx7lvcJxtk6uyQh9eAbo=;
	b=MJbNcbqrPXIV4MVekRibhCQzI3C+hzP+3EH4R9OzuBdd1PJ+MSUAobqW1FP7bvjy+d0i63
	nZQcOUrV6MCliZnClZqT8pq2wRrwSn6jgiyTMnu5+XxVksTmxJaG1b1+pPu8unHvuy2wBC
	BxofF/S5Die7TrXexDlzFzpSzP1uREIFOgDvLv2wHFWUeyeQ7zQPN8y20onY8ZTr1ZGpDZ
	7VAIJ29E8wEfD/0IKTZfGZnq9bYRIDS69h2jcJO8oluBA0eWh2PYptYeagtoUcDRnGeIM/
	cj7CR+3jJCS1/NopI6vTc5QAm7MHqHLBO5AkYbugodOUMCaEPNyaxk2hKv2VCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmuSOH1PlxKnA1sFNyVBb78Nx7lvcJxtk6uyQh9eAbo=;
	b=X30WsAgkstsozlHa+DC4mGpqHKVlDRk5DYwXaKpWLVIF6u35pncScYR+NtHgrl304XBqY/
	wcna4+QkMAmSkvCg==
Date: Tue, 08 Sep 2026 08:33:47 +0200
Subject: [PATCH v5 13/24] x86/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-13-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2487;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=vRbc54EFTJK8Edczu3nKOvbSzT/ak7osQzTlANhwfg4=;
 b=QoGW6+1pU6UCOJIoCAQWiJdDPGXza8QAmW74TVb+TFEF4Gg6rdDkscKCRLfDPN8KjcDIG8C8F
 Q/VLV8dyYABDvGmgs7XWDfcnTFUCyodw77Rrt8RwxwTZvWyIDrh6KpE
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A5D680003
X-Stat-Signature: cjcukow8om64dsy9tqs91m1xbjem93m5
X-HE-Tag: 1788849237-275059
X-HE-Meta: U2FsdGVkX18H71N2vmF3eOXdUeODoLHBbNooWaJVczPXqzpb/hGYkVEKv2VZoEsM18KYzJI6hg7P2xr6ra5Cb+3dvqgXKx4xijM8kaa92yvvEi2QlWYbEMxaVOzP4HSuuxE3tpnkBhlQ9tOt+buxA7ujGjdU7eft5x7KQs6/NR4sC7UErT6BfxU+xYrjK0RdgpHQ2lnV22nnMg9+D5iUAvDLQGxWUUSWmZn+DXpHIkPW+i4kxcweIIutn4slbmOkie5d0QNwY+Duw6LKUcg6PHu6fm/03ZvIl6ZV7vpGh4OLtdgUro1G/p+W2SrMYYhcDSIMpCi0ZoagbJW1dH4dvMvOLDInZawrw7xyRty+C1Z6TOKSsOi/Mh8HoCJP3GyNg08AlZzPw2RMBi8ru/TLQ+SHjGemYF5i41MROUIdxVioLwOTVOdZc0NjBAYblUPjpnmbFrNGy9seJsWwZbd7jhzNf7nwWe+dzzDSm2hTUZsMCtUWMANf9xEx3sYgaS5Hhh5zjLb7g8M5hxgt/0ldblkH/9ritebg9sI2qbg6/2gumtDAJ7MI7z2MxU/A4V0iaRrvWYTKLAF4Dq4FECxOLd+8Vop5/aAI3ikoZfCjRg59IU9Gs/bUqIEmIM6nRGL2oj/RWnmp8KTELcttSPWESoyVvVvD9cucgqX00RC5gdrJifhJXANBIiD+zkivTujdD6SO8kfNu+xhqdHuDNbJShLhn52KPbW4kd/fOND+QAwtdqHsH7F1F+X1hnasYFVBK2hJWWGHozqlRct+EOMJqKiB3g6T08nXbBr56JsEj4Z+1sNY6k+zqFOYqJGDd+ScoEbBLVBBOGDUI4mngqXbkD/MXKCuQJd+bdasgFvEyjGEQoPKVi7bc3Y59vwNEB4/oJnsps/9OG+EIrCTrM8m0nDts9gXCk8Impqc7DW+/PiqNOYYuVqPg50jZ6Ft5tVYrxJWGZdY0XVblJq7bFr
 JAZu16K9
 IIx4JFhsCO65BG0T9UWptgdNnTjjL2XuX6TgH21JQnuS4GrFflMys9OGPUfG8HYpZmcVsrVd+iYTPGNkp9ajDcW8B2o3fCCf4iQgwxfupDt3jMWFAW8bYCsMHQlkbRwoLYR4IPl1AYrxDVTunLNkH5rmruATCLxH9I1YnpMomDICffPikwrfAOg7cLB00chBHtnUKko1wA2g5Dh0hXpnXetTqUgWJwGidJ+2K9+p7f8eCqF4rq81Mzwmtkik3cz3Os2bkn77opY0uDhLMLXZGN+0SzNDmpU4ZEl4gpoQ/QIUExn3bC9TYqOTkCvyauqrijkb6VjZokrijfS0QJRFKBRHvf/GacHeIHFUDWCittSbLpkhi63DC3nsuqp+sysFM4Pbb7yEeW7NyO01AUx+TlXBHY9qniH9F0HR3ANkDfh5PmsLmdSQq+1JElVJeQVq4Ro7fu7PqXFl5gAUO5Z789CS3VpEATWMzkC0irIvVYQFttK7l6N+uEDqZRh8RpuGLhMtvkPzqTwg/vj4TRufT9WbZTZGqYcrze01F/Yme73s3pRE=
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
 arch/x86/Kconfig                            |  1 +
 arch/x86/entry/vdso/common/Makefile.include |  2 +-
 lib/vdso/check/vdsocheck.rs                 | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..ee0f2c401980 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -305,6 +305,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_UNWIND_USER_FP		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
+	select VDSO_CHECK
 	select VDSO_GETRANDOM			if X86_64
 	select HOTPLUG_PARALLEL			if SMP && X86_64
 	select HOTPLUG_SMT			if SMP
diff --git a/arch/x86/entry/vdso/common/Makefile.include b/arch/x86/entry/vdso/common/Makefile.include
index 687b3d89b40d..510d5e79857e 100644
--- a/arch/x86/entry/vdso/common/Makefile.include
+++ b/arch/x86/entry/vdso/common/Makefile.include
@@ -71,7 +71,7 @@ quiet_cmd_vdso = VDSO    $@
 quiet_cmd_vdso_and_check = VDSO    $@
       cmd_vdso_and_check = $(cmd_vdso); $(cmd_vdso_check)
 
-$(obj)/vdso%.so.dbg: $(obj)/vdso%.lds FORCE
+$(obj)/vdso%.so.dbg: $(obj)/vdso%.lds $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index f4c0730bc976..1174d896a68b 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -34,6 +34,20 @@ fn is_ignored_section(&self, section: &elf::Section<'_>) -> bool {
 
 fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'static>> {
     match machine as u32 {
+        bindings::EM_386 => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_386_PC32,
+                bindings::R_386_GOTOFF,
+                bindings::R_386_GOTPC,
+            ],
+            ..Default::default()
+        }
+        .into(),
+        bindings::EM_X86_64 => AllowedRelocations {
+            in_object_file: &[bindings::R_X86_64_PC32, bindings::R_X86_64_PLT32],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0



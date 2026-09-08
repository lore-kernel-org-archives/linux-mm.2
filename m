Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F2AC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90146B00B0; Tue,  8 Sep 2026 02:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69D36B00B1; Tue,  8 Sep 2026 02:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57296B00B2; Tue,  8 Sep 2026 02:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72D696B00B0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D1E280399
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:10 +0000 (UTC)
X-FDA: 85189630260.07.C9408AF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3BC27A0009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ONcLc8uH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l6gHpIlB;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849248;
	b=zDu41KELY9c1La4rrkwipgNiBlmcktlXTRZmvZDavueN4bIdlcMsl7JPvTE33JlEhElYGg
	ofBRlElP39M0ovk3QYEJ3aqxPauXLTElTrTtgr8CqwO90caeU4JlwCru/o1+Ac+JVfUos4
	jKkrVgHpP6BBpMp/8Q2AxXcnRRD6lqo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ONcLc8uH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l6gHpIlB;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kBqivOxnOtc9zasn0eCWq4RBwv8X/Ufx01wFT8ObgI=;
	b=bb20n7rwpekUxtySxFgcBRqf3lQ+jJx1BS5g4PBlFe0FaUBnOWIYOeyzpheX6ZNVR2REv2
	ZMqWHlk7uxuUQVTHPbNDRLG8lQZ/05/2Q2dsmPFsHVRbJYA9FUOtmVXzKQSeD4zp0ELLe3
	Hnz566ITejNKDE2YAyNkTxNqJiFo6mY=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kBqivOxnOtc9zasn0eCWq4RBwv8X/Ufx01wFT8ObgI=;
	b=ONcLc8uHweGH7n0pCw/rap58Hd3hlqqZX3tNa81FyeUAKASG7dHmKKrwNHdlyHHiRFlDv3
	7P6wVHU85ZYXnfcCRiWnVYi+2QpFNcZuXtYVzD3P1Zn/fdZu12Z/aImdrANiv+oZZMl4at
	9mMaHVOXZGbjivRo2no35o+uWLGgDiSG6UNMuG2+iEMTJ22PZURSKSRfc4Mgb5ukOyd5eo
	qHDw6CT/f4p+x+WbR2azw5m6Mvj+cSnQGWh6LIR2cGKjHOZ07fbIsBdVtvR5MjpChX7mMS
	oLADeRjpYC5cEYx4I9eCz34hLIFqdP4uXVXHWdOJrV8hibo+4NiNMS3Ou5SNNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kBqivOxnOtc9zasn0eCWq4RBwv8X/Ufx01wFT8ObgI=;
	b=l6gHpIlBwSi62BlkjxL9EUNAzZDCPGUsAN4gQqoMPR3kEWA9gAzwkD/kVYA1N+/Whf7HSz
	RiUDLayydxIFtsCw==
Date: Tue, 08 Sep 2026 08:33:57 +0200
Subject: [PATCH v5 23/24] sparc: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-23-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2334;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=HZMdEj1C9yKMvR8t0T0b/I+JGw7MLB0CX99puHdToGs=;
 b=BIOspn+qM5bOmIKIxJ7EFwVtuD4wBWlInysCLHBriHSIaZ4Mi4Uuz/G1wqiiCglI1Bscu2LVw
 tLp8zgIJJGDDE/NO9Dyua6VwQNT98vlN+rim+byvjliIudZ111tEN/Y
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: y1o3aarc9ob6fxy78jj6rss4c7z5y46n
X-Rspamd-Queue-Id: 3BC27A0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788849248-75815
X-HE-Meta: U2FsdGVkX19CBfXdNj88aomshicZqqBDhQ08e/CTu84yWxjKrzjs3h2lVTlQWOc2Abcokm7mBXMdbOwVvRss34Ilj7ecz3uFUrXAyrIzk7s2Bdh8IGnoCMn1nhGaeMCvKe/s4tvPG9j1+mdyOXSnIlSRYPQK6X5+VF5XHqKuP3X7eRUrQPHJ06+l+D5hQuv3L1wTi1FS4cRGCOGsJv08PNm2d8jjKiRrvThoL0GGBY35mqOz7Oer6woQBpcTZzLfLTR73000MzaM/hVhSY4EqZ6NTEppKcFYsdJOHnjHyicGBqzrZdy8KN+UEotUc7a+gtuyfNA2TVkOZt0u475yt9MkaMDk1RvLN+bJdCiDyhllXv4cRYQ1/p8mW/QVbEP0jW9RFJE1epCD3W9zz7T+hDPdqOxMYN4yrgQX2wlU9D2ZCNBfwdX6MLds2mdlQVQd6OZhAk42cksEL0mepS0g8DbLzcMOyJpSBQGZiCZ54tARsCtrCdvebPzOQecxOIdqCKn0DFZ+rvCVNSdrvAfsHGtnrM8Ng4en8ydDrQ29NyXrHj0WKeMB9b5fzHtasumxQDw8boQYRLsMs6rC8WKyexoK4iLpCE8VEaGenl4e2E4+HPeiGzfHkP9OfpOCZDnEXBMwDpjF2g1dDnkqvjqFKh+kaXHg+diGLSwNFD65oVwYpOlVinkzzgR+DX5shk8qyV92YxpFsvbYI9ZueJilEIlt4S6SaxPP+zghCfyyWMgg1mECBTVf7Rw795LxEVBnaPRxyYrgf0cd4axSjEHCBqxCa2Wl/pl7w5LtMchPgLnIKIoct18k9MvvNfaegNoxQBrqfBa39oE/6dv+VkassafSZMtRB62PADKc+V5un1lQgf0xwjl2w1kGLCnkCe3IQ+rR8tGSeB+iJiJ9AJoYFh5lLyKv28uN6IJsjf6DWJaGp2b3MGKY5Xi0kwinFJFnb7Ucah6wZEvbqGdO/y9
 k/jFfY+M
 lXO23vdbkUWkROE4dj4+upj0vQ8fOnWfYQwPzwG6g/99fybNO59HKo6djO8V+UJovRHJrDPZY6Mt23CCX2UZNckLGroyn3N2PQKb2v5vxBH4TBhAeOmoSiHSya6CuRzRzsLzpw0/zR1UVs58jnlVfEnX6AA9lOgp3kaBiQIXnmjIjWSIg+3oEeDG/ShFHg8sJXinqt3NXzwmV38o5In3Tv7cDeodVUpd/d2/BBAkFNTiBQfcUJz8yX5uSlCkqJgiAMklRQSCYfXFVBrwX9YEWGDxFIlC+Of3IeGAIjDX+ZzBDyOPvwooSklns+Wxe8zE3q0FHlkHNWQqiZroLsJKrwGhRQJcPuBHJl72x4ZI5NJ1c5Mtat5VnXkk1Ismmf7HMhJyLLpH/rolyHdk3IO5h14Lpn7JLQAF/H8p6b+BvkRAPdSY8n32gmPuvJ8/gWV67usXIZt88jLQ0C1UT3oSnNj6SqMyFXY9Xj+76MZTVWKZCj6+CjPO3ppLxNQ71W9zsUgGn+3Ffmc3gUdrWdKy/R1RrAZ0udUNge7qSpK4Ho37T7gI=
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
 arch/sparc/Kconfig          | 1 +
 arch/sparc/vdso/Makefile    | 5 +++--
 lib/vdso/check/vdsocheck.rs | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index ab77d3f2536e..628bdfc2f088 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -114,6 +114,7 @@ config SPARC64
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
 	select ARCH_HAS_LAZY_MMU_MODE
+	select VDSO_CHECK
 	select GENERIC_GETTIMEOFDAY
 
 config ARCH_PROC_KCORE_TEXT
diff --git a/arch/sparc/vdso/Makefile b/arch/sparc/vdso/Makefile
index 83fb2aca59cb..8bb235c3a618 100644
--- a/arch/sparc/vdso/Makefile
+++ b/arch/sparc/vdso/Makefile
@@ -28,7 +28,7 @@ CPPFLAGS_vdso.lds += -P -C
 VDSO_LDFLAGS_vdso.lds = -m elf64_sparc -soname linux-vdso.so.1 \
 			-z max-page-size=8192
 
-$(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) $(vdsocheck) FORCE
 	$(call if_changed,vdso)
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
@@ -99,7 +99,8 @@ $(obj)/vdso32.so.dbg: CHECKFLAGS = $(CHECKFLAGS_32)
 $(obj)/vdso32.so.dbg: FORCE \
 			$(obj)/vdso32/vdso32.lds \
 			$(obj)/vdso32/vclock_gettime.o \
-			$(obj)/vdso32/vdso-note.o
+			$(obj)/vdso32/vdso-note.o \
+			$(vdsocheck)
 		$(call	if_changed,vdso)
 
 #
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 865e8cf7d4e1..0d3b47bf57e1 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -172,6 +172,13 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_SPARC | bindings::EM_SPARC32PLUS | bindings::EM_SPARCV9 => {
+            AllowedRelocations {
+                in_object_file: &[bindings::R_SPARC_DISP32],
+                ..Default::default()
+            }
+            .into()
+        }
         _ => None,
     }
 }

-- 
2.55.0



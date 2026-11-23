Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5EB606A6B8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=m0qrJodb;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=E5RDjo0r
Received: by kanga.kvack.org (Postfix)
	id D2C476B05BD; Mon, 23 Nov 2026 08:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5F26B05BE; Mon, 23 Nov 2026 08:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DE06B05BF; Mon, 23 Nov 2026 08:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 829E16B05BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08DBB160893
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:42 +0000 (UTC)
X-FDA: 85466521644.14.736742E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3BB5112000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=m0qrJodb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E5RDjo0r;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441900;
	b=fjbNoFvXba3OeQJvwApMpaDY3rxwKXJT7dGw9HG2eQcJSmRo13W9OUAwC4bRdPj1MTA9I0
	mBi5wQGGgmevy9R/x8smr/KpnH2ggxfpAuePMLG/kXpkWdLHMJ+Pa08Nh8Wd26cvlih3Mb
	CyWXUHyOkiY89Xy1tBwHJD8Kc2yAPW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ha/Vi89GXA1dWoPWSXoNX2UQD22cCvUbJLDuPRU8LE=;
	b=DIDLfSc8XH/VL35iFfMQl+/yPkxaJSPAI1bZNCJP8xpuDrOxPStnzSCF7IAShXCVeTCXPv
	J1mMrBx+cMLBfpuAYkCrqRCUs4wmoifBjSu3Zq0OQ2gei2UKlh+QqXDt+xTArujQEzDLXT
	DlMWDl9ikbQPRKLslPOArjxGN5hVlVY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=m0qrJodb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E5RDjo0r;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ha/Vi89GXA1dWoPWSXoNX2UQD22cCvUbJLDuPRU8LE=;
	b=m0qrJodblgSHfzkge/b+c0QCMBHtFhMmCA6Vyr2H7WBleCIYh+lMqmV0IKteG9E2pikiZO
	y1JjkkjTUm66PulTK2p3QfpFPfiq0Sm3AHnRfHl8yDhGDzYNRHWeqg5cF7tcl78L1RkR/n
	WPuYxHiHo2IYC4A+sg7EC+/1EcXp3blyHeQ6KRs4nnNNyW2uY1A+PhOCAIi3oMtnZTDkV0
	NxM1dvYOi001/WyxLtFcc0h9eQpHZI0XWYY8P4cO9FYCbLxOMNPr6OKl3dnlyQMMuZGJAD
	Te3Y/nY9Wdefcyj10JqyBH/pqn70kpgTO2Xqjlvxo2FDmdYuNvSq8xtqlC4i/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ha/Vi89GXA1dWoPWSXoNX2UQD22cCvUbJLDuPRU8LE=;
	b=E5RDjo0rxSRWJZCsaguvONyxWiePtX/w5e+rniAAAlKK8WxlOgxIrKHbdHR03YakmbzKxe
	lX7JYjn+2xicGaBg==
Date: Mon, 23 Nov 2026 14:51:01 +0100
Subject: [PATCH v6 10/11] sparc: vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-10-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=2332;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=6Cz0yJ9M9WbiIcD7w4L4KrbFFaP4kbTGha8gKHJR3nY=;
 b=CILuTEE+Fxr6rbHT12PlkxKHS0mC2FrvmEnB5ZbAm/6ReS1zpHxcD5xSsaLEEMXokqtxppLR0
 Uh4X7juWCr+B9/J50Tb7NWk5LeUrNQkbxzudL/33leg6I3v7r7q9/fa
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: kd879q3t7hz7m4rpiiupp7it9utwmwbe
X-Rspam-User:
X-Rspamd-Queue-Id: 3BB5112000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795441900-408886
X-HE-Meta: U2FsdGVkX199CskUEDxENODQrX1mV2idU0Np8jAKp8ZePPtqTfjXcxiwayyi+a8yf1vWh4RDRQ0QKce6gpu7fwzDQ4QWOIt7CHktKlWELYHHydbM0oEuGejM1ZkMlRf6HNYtK+jpnFSW8CjCNHvAZx4N+8UkEgT67Fq/hoVa+nE3EXzvAt0AK5BJPSzkujKccGp2PnznQR7xT8MX5aVGB9cxjebp2OIBV8nbUdt+H66cHX1hC4uMHzGRvmPmvEHJAhuqJgcs8BBOyaA+mJTKlPGEUqA5tJUxOZAJsyTeyfrO5HiSrsVccYSaipHIb33d8VcjgR01VMN+c+pKG/SRCVcq5ao/053n+5s+DruWZtPOjA8WCpEPQt7nYbQm3SJDSMP5HHjAaLRvJ6BP/yfhBsvpFd6k+vY/+cmqgKAkSxrZQ05b2n2k6cV1sxswq0gTC5pLblqcJhmkisiIEkqBZtAffIiF6gQrMhQA6PIBLBw6nG+mB4+r0F6nVFjEQG4kJABoFAm8d+oAdPweDtNZ1rARmlRx96xs50o9ui3LTdRuRr72WMhbYYGFnT2BMRRkyysrrHjovfiYcHN7EYBYzJDoxV488zVW6vYeNOjsj53ugeaM6u9P+Q7e6qZfNdMWOKtCRypBY8Rh8gXjmLjKwy4mLwvdBu4kEdMXAXcX0q038jpPn8KNefEjpNHP1dIYnjYgzNzAQcTJHRj/RJ6Gu8+25wZkV0DnldiDvyuIN0C3CrcSnI2YC60cmGQUDtoRgYGbB8VbncQizb/DqqDTkNhg0fiFiPstLpq/PE9vVD+nWKidHein/0tS9LFYmDw73GZZYOErMlcj7GT27kBXpWmNNmnw0VxsRTWtyc5GU42ZUMIiLpGbseTV/HNUAqdyESB6azwTx6sbJLOUBupvFYg9A7BNAXmekw4BLr3W37WKu7mw2ZzI/XNkKcPSRH/mAUbiuRuSqOG1nErfL2C
 klhEmUCE
 lXbHhS2OYnPZuHLO4nyHRcvU7xEc05mhcbKIlRV4pZq7HevxEgfD7dclxnOGI9EgjZvmR98KvAQdBVxhLHvG38UjP8HxgKHS2AmS8KLeP1f5vLkpiz4jUTKgsGkCuiJUaBXm2O9Su2UNrUA2gLmX5LiViFpZliRNPhjZrJ435zoR13su33vAEhz5t/GXwr9XS9irlxfvOhAc/gj/tuHDmt0yTYJMEWx3DELUnnOjju2IIyf0Qeu8rXehq6BzoT3LZPBSUAX+cTqSbZrbuXSsAeIMHdA/bC7gL0NJUIitK4NO9lqDrHIhtexb7Us0xBD9c15YW79lnD5VKR5oQ/IjAI+aeSDHH6mz5Y6HNT6n//nt/qQ2cN3OwoYvXlU4oSRm7S6r476Rh5sQhdK8kTM1GVmTvRdoBPC4sC6daUkU8BE6qMfrq5Upy/Tpmrz1FVC0/RbnimczjdNKuh94Q+Zo7Kc+0YP4xanMdbpnP3V8FdyE7BKr0pdL6JiTVW52WRfzQ+yvGZBXWBiZYn6gqFZ+k8ijfsGGAMzCAveu+DYhXU0VgGwzD3JyHi4bxPqBCe68adxovKaN2EgGZaASGSErDx/s4Fcprvr17HlPSqXeJJv9BTxvycnEa+/dSophE6kw1Cmey9t3qlMTJQKzrp71WvBqj/dsBGbHZ444FwDdXTHaWwR7MsgzsxM3WiDKu2RQ6f+okSMhIbbt/B8YAlnibZw3J/XXYq34mZuTs0IgQWwsx8Xmf2LAYx+s5Chi+IhRo4SySHssUPSyfTfQ=
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
 arch/sparc/Kconfig          | 1 +
 arch/sparc/vdso/Makefile    | 5 +++--
 lib/vdso/check/vdsocheck.rs | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 742ffff8c37f..90df77235184 100644
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
index 120d8fa551e6..245d8af9f704 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -172,6 +172,13 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_SPARC | bindings::EM_SPARC32PLUS | bindings::EM_SPARCV9 => {
+            AllowedRelocations {
+                in_object_file: &[6 /* R_SPARC_DISP32 */],
+                ..Default::default()
+            }
+            .into()
+        }
         _ => None,
     }
 }

-- 
2.56.1



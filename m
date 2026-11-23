Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA5B606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=UCm14a2s;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=w3xYWjc/
Received: by kanga.kvack.org (Postfix)
	id D24F36B05BA; Mon, 23 Nov 2026 08:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5F36B05BB; Mon, 23 Nov 2026 08:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECAF6B05BC; Mon, 23 Nov 2026 08:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 970E86B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21C04C08D0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:33 +0000 (UTC)
X-FDA: 85466521266.27.D691DC0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51ADA100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UCm14a2s;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="w3xYWjc/";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441891;
	b=ht35wexB590+LMta1t8QpiW3qCLaYLizQZvxfFnAXzeUnaNTbp7TAUL6Xz0tN8zYlWhU86
	ptPmxbTfgx6sJVaSrIHmEGb20x0aTrh9gw89xT/BDfYYIqROLwUN89fj1LmzNh0f0Kun9m
	x6JqlBbJntPA8kjRDcUDdjgdmFtf7EM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RL+8fambt78mNwxisCMhwkZMR57QQ7cEApXVSlXue4o=;
	b=jtRwVUpB8JKJlilIIERU2Xb+vbVStY4GPWNxo+WDk7oW1lDDKoPxWGtrgHs/OvsobO3pcM
	HKtQB+DTlMP6un61oN4H9AC0Tm1A0+dUSvV844+jrDXdfCw/vvBWJJbryaDHqQeOOW0n4J
	l9rU2Ueg5z93seWli14iKKHh9xbPHSs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UCm14a2s;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="w3xYWjc/";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RL+8fambt78mNwxisCMhwkZMR57QQ7cEApXVSlXue4o=;
	b=UCm14a2suDs4pglh8w+qnsBPKHLeHEFC0aBs4NmigP6scFBtkIBI/J6Fg7MNuiMQhyTM84
	fQ+UajBr1ZU1X13z/umg63so5OJp3sbMrvDox5uKCNPuS1dj4xkFcpSyEOsXMM9cy1Lam4
	yjoxyI30e+h+b71QsNArfMY8uEzy/AP0E+igPdPiFyoSAM458qSa9hfZ+WTPM/pBe0Xi5C
	v32oooJ95Ijl2sbbCXNxwvmAEX1bhzY+uCaZjFsMVpWnhAJKrFusuWTcOV9rGSM0UScVIU
	ZLDXXSOEG6KSPcy5pvDupgSxblKovbmtNRF1cKinji+SxcyCRx0FY/n/o0hzWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RL+8fambt78mNwxisCMhwkZMR57QQ7cEApXVSlXue4o=;
	b=w3xYWjc/sYaSNu5XMDIPl7PAUmBCHykHgym1hc8u00qkkIuNdJwoDEbQ3S05B7NDPjjFmP
	gLfAq7cUJUz9LlDA==
Date: Mon, 23 Nov 2026 14:50:59 +0100
Subject: [PATCH v6 08/11] s390/vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-8-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=2267;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=xAP5SBnE09iOs673j2X7juaBIh0SLYiSMvwxkvPBF8o=;
 b=pI1N3G+K/qs+GYoFHKTpDU9NLx4R70uPYtkOIAyTuD9UqHJwhtrgkO/1BhWuPvWT4X5KlRgJp
 W+/m5LTSDZoAvCxD8B1rriBO/48yR/a+uEqS8LfMyLjk45rPOG9PDUH
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: acbi14h413j6iq3db7pk3wpobuor7hid
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 51ADA100007
X-HE-Tag: 1795441891-584057
X-HE-Meta: U2FsdGVkX18+1FfpGgvOSezCnwiicrRb9eUT4W4KN2VIVjSNwwrkOn8V2z6pzq4ppXCk5FJQP5bOPQ3fvxfyy41VV2k32t3RH8SDRj2CAy9UUKjiGed77qZDtgru0/duS5x/Y6TMsztvFuU5h9sEA1lmu1f8tOFpegLqdXoqG9vzCS5Py2/Yzu0MiJ8dCttLuMoUkC/5gPEGiPg/LZunEx9ovgIXB8gv7M+aXVwiMJdO5S1ryM/81Lb6oV4wcyDlzkgaTSICDj5KjcGouMyBHgHgAXVk8z3GkLD/wT4X7N3ekAZlVkUxBpXqBBAhuEGqZFtzH7S//1xAhAM1b1YdqI+NdopyMdpYs4Py+/ISOQ9RehzKZCooiqOWZ64Ks0G7MsCs7w/3exBr4Bm/kT/3IO4n9AEb22BD0Eld6oFTy5fB0KnEVZaWuDbRvRhsFgEyha1pep/2KA2CAA8O0rPBdLBnfhlG38Eekr71wUASo9z76juxR6Kw/WZhmptmnVVL5zKRH5Q5i7ASMo2QuspausTQA/i7LAdPcQy0QPXGUsnMscOcT250/cjnKrl863PSl5R0pDO9OyX0d07JF0YwibYzBD1OQPZKD1NP5mrYLjk+vqvBCb5z4j/5O4c+ioKT7Qh8M0xOa9inuHAB0+BfD4Vhm0Gi7FfLVOyJajgkDlfbdWFbrQS/NTE9EOgb9QRCC4v4uwy1b07+Vi974mByYfUtN222t+nLk3Z20i9mto68Aew8iBuBt5jMyO9BmzUu2ARQZBTIzNc7muOiVjkbMYoooWpN85Yqi9opUO2tvTEQx8ooglZpHrkJ/YZInJAbQygx9w/ZDyn+OxKmc83jlLIaUBY/f9vXwySzur6xGblniScr8Ft9nf4wrInkrUCxLZm3MHtQBg+XY8WhegcBbVRuTyjuBX3DNDYMdP4K+i2mZPiLe7EHjQnLPA4Pm4tPCKvaSXjBXxDIiFG4ycC
 75T0/M7w
 Kab8OAyW9WQn0GNQliBKMza1EYAhZdt6MKd67Ajp35cpG1Hw6Q97yabGmRw6hShYYT02yFN3YZqa61LgA2FmxvjhDwHFzfa7qL7HF/A1+bMpu3ZMUZZazUnYl7i+dB51q22RHaugWAq7Yu0p9hZl12aGiSodzaceLBWnpe+830CFB5eGuAm75ZUe/Js07Sbfjv22R/lajYcE7Fzlf27uZ+MP+vZ5WxpnbtcuIcvxS7OClnH0TrDRNusVUj/T9ezm/i825Enyb/sQRYxt6Kch9YCm5vtmGj1ROENJ3lLS6C4JvVbxnmJxlbLLsoD6U2WRl3WTbzpviWiKOS/SSQKDqxTxK/6EW/4FFQ8qFP3w7Yh98NFbOwlrQfps45vYidbzH1Za+EP2WDsP8d5sNynlzrLIyGNiwwVIMbFKNzswYtE/mFzPh3pPLxlFuvvDJXZTeb5+pKcDFkwyp2g+vvmZs069d8tEp6u/+q+xiAlenSHJ3KmWe95+JR280pQ7074REzY+mwB44W/tYy3IA7IGd8Vm45caahLU/w+HGpzKkQEFqVzr+Xj0kB1sWlo+LDKIAHIierpfJSz+5hxFyD9zss67+78Z9Q7sGlyPlhCe/GRlvlD5IUt1RGhUhuXeAQkoqnHFy2eCWkQNfPZbmakkwcMXOmvKHUnJ4hm1TqAUjv+NAofGh8ZyxN5NIJZkjU/dBlfFPp6jHeHecBBwv4sqDPpfYpKKCqYT4vo9JWt0CJlZk83706JGSRsAviyURsRDmBg2Ih8OYt/PvOFk=
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
 arch/s390/Kconfig              | 1 +
 arch/s390/kernel/vdso/Makefile | 4 ++--
 lib/vdso/check/vdsocheck.rs    | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 7138d923d86f..71a614832886 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -289,6 +289,7 @@ config S390
 	select TRACE_IRQFLAGS_SUPPORT
 	select TTY
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VIRT_CPU_ACCOUNTING
 	select VMAP_STACK
diff --git a/arch/s390/kernel/vdso/Makefile b/arch/s390/kernel/vdso/Makefile
index 54bcf2984ca1..6bc2b7bffd89 100644
--- a/arch/s390/kernel/vdso/Makefile
+++ b/arch/s390/kernel/vdso/Makefile
@@ -45,10 +45,10 @@ CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 $(obj)/vdso_wrapper.o : $(obj)/vdso.so
 
 quiet_cmd_vdso_and_check = VDSO    $@
-      cmd_vdso_and_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdso_and_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(obj-cvdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(obj-cvdso) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 # strip rule for the .so file
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 7952ad6ba72b..1ef3f240f886 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -148,6 +148,15 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_S390 => AllowedRelocations {
+            in_object_file: &[
+                5,  /* R_390_PC32 */
+                19, /* R_390_PC32DBL */
+                20, /* R_390_PLT32DBL */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



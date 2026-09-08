Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC111C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FF46B00AD; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092716B00AE; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75066B00AF; Tue,  8 Sep 2026 02:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACDB66B00AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CB9714037C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:07 +0000 (UTC)
X-FDA: 85189630134.20.F22396C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 535DC40002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="13h/LZm3";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iI6SCa0e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IidQ31ouFEpYA+nS17u9E6l6j5+J0X/Qbfbzc/4EoAk=;
	b=pnjMWOUKsEILClNgJDX+TUrnR5eVYnc3UpEyOoYEEoc1Ku0QrhEacgJxDbbr1TW1k0ojay
	stD6JcztMKRdJhICkkDqnEoELD0+TYgo5dvz2fS6Dpt1iJP8eSLC48I2g6evVaFPMRuHrr
	w1akP8sWiCMyEAIlcGxjh21VeidaLu8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="13h/LZm3";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iI6SCa0e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849245;
	b=SFVNcJEIdWDOI+ZMHcWtP72XcE8MJ+w8kpqckVJbjP28AqAOhyDHKULdYRHszi+CW3KB1f
	YAmvW1wr99bLISGeJDKZMnPACfGwwijFHxQmctpokTF1Y3EqaRRJheelu8tZjxu52cJg44
	qc+OPwQtkPBHar7aUgTVpAayZUYyJiM=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IidQ31ouFEpYA+nS17u9E6l6j5+J0X/Qbfbzc/4EoAk=;
	b=13h/LZm3oUN5NX5d1pSwDpq6WOOrKuWkeooevs0Slh2NpnZURtKGe5KDBp1tQw/iOP/Foz
	jG+leFqUbZb1il3/yws247n0LE1Oo2UrRebiDasMImoeAvycvfaJtgt5FG43hx0rRvf/kt
	b+qd66u6bARnZouWXpm8baIEtwrHmqnbB+RfcaWW8MXCqXeqNj1m+ijLG4q2iVvSt4mr5y
	vJu0ZR+0GxgCwURI/L5/KXvu6rMPzu3XO6orwkZFexgMHMpLQ9jIedo5jxhPNs6DVioHIi
	NBeKQtqchUF1TAHOOMcD+uSWgwhGZFMn6e2sbJf5DzX9oTp0lkDYo51oJaVyWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IidQ31ouFEpYA+nS17u9E6l6j5+J0X/Qbfbzc/4EoAk=;
	b=iI6SCa0eTjj8cRYwu7N3BX4E5LcC26uVQ6b5eTpae2XyKJDB0AL3DOO+Qmt0gRz3YcZJfO
	b4Ep6HUDa68rhZAg==
Date: Tue, 08 Sep 2026 08:33:54 +0200
Subject: [PATCH v5 20/24] s390/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-20-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2270;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=MheUrTVMsMhlO1Hx/uIAQcNaOa1zLZs90zNsA4xVFXI=;
 b=QPV6rtkThGmgCrpePDg3k3KYmTBWvY98MetgMiUyonNPORVe5K/DIqywgywggjAngHoM9YG0V
 mAFJANMdk6aBtyL1evmiJG/8n0kShbhIewzAsKEqRmtcX5PbBAf3zZb
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fmuwk6qopixg7dirnfx1saxouigrtkpx
X-Rspamd-Queue-Id: 535DC40002
X-HE-Tag: 1788849245-455582
X-HE-Meta: U2FsdGVkX18+ispSRBITdzmWEBMFaIXuFYyetqiYAlwTCiSWI8mATDGAlboSGpt6uIWN3OytDEF7sT/qoxqe0DYi6iK/ekECOaH51vDSQDSP3uemQd3Y0NVQXJ2AyYargqQ+GBwzLGuZege5+78oRG/YXYHXvppNZVi+4ZiXWNOHwwM8s4m3ro4E2+aacso0k2Uxh2OBP82RA3Nz3Fr6lH2WSqmOgGC1qAJi4xbLZ1uSHsrTpjtxr+PgjNxbLNM3ZFByZep/svb1VKuZViHDAjjbgn+P4I8DRUUlBUvJdnxgp8HZUNPdVfmQpgprjSf9TEcH0mzYl9RY4LlG2UnidJiJ12KyTFXnZj8KTXs/qUvvEOpUndQ0fF7ylt4N1qJLaQaYESIfGVd46wtHX0nIo1iM3QKYgO5vL4olHATbaTkdyxTfXkLmwLyinwMc2XdJzVAXLU9/VHmJNRrWWga4X9bzhV2hFZLGV+N1OLFs8BnhZDhTb8HxQ2bqLx+UuLP2KFCuyYXub9lEfz+PkxA06/IJCnWf4+TipalPwsRYGFKXUFQNinYhg0dDFTtrUYXkXzkUGgsyfzcJ+MsbJfMIn+VH3NPFVgsC0LvgD3FPs/PzwR3GDDbX4cT3BtQv+ow2m3EDBK/24Zj990tRXIVpK2QQgadtIbxjmvPsykJ8KsBEB8kvIWZpsfgFcQxJtvok5QzcEL020g0d8nizFA9vIb1WdoA78hdSbm17FpfVvmsC3Rtoqq+pKZA5xrU1WcjDqHLIXoYtL3jNk2NCqc+kIUoTi4kbNai5uxlN6R7K0swtTIGuEiDo0v5ikCliob0PV0MNrjRX27A1ecRYOpWJOAuB0A1L9N+hNfBiDRanALFmyd+Cic36+QlITUIffgBDjhL2D/zfvR7uxKY0g2OGH/Wcu593OEy/8hOG6n/Z6huI1rvtfzYEoaTqlFdV+QdkRnM+JMBdMC7wFkrjgbh
 C43AvRD0
 vBg9Uf1ZuI2WezCYzDy6M5lyWqzpwv50boVMRRT/Olcm9cH8Uc1nbrLxEFygsSz3bYrnLYvgCpwCpOYi7rkLF03X6CH3SQrLQDY9nk/2SH8VyagO2MZMqa9AcW8cel829z9IN7f/eNd8zT5G+sGcYsfGKQ4ocEtoBXldYGVkdEvjC+nX6BG0oxrJzIr7AvxKSY0N2lgkagWPGaRih69Q+Dq/QkZcUkCgsGE0yj7XyslN9UfvFJUm4E88HHaim353A6u2KdE+KwKyNvsSkZfNu7tWMt9xEIr170QntzyU6MY1zT8rEAO7WcqQc0ozAmhSulmWOymy4ZtGD5wr91uHZIFFh0R+Y9vkg1ij/sOQwTZEzJqCEuV599Ud+jrlLSg0X4in9n/Xe31CJP+sM9QTcCLTS8w8O6CGhU4SyowD48JgV71A84SeVIzqP5Yb3C0eBuo+P9vnHvUQIR75g1lo9CO/eIsMO+TsAi8VwdUOYmxut8bociZrt82MboG7V3JOxB67/wuPC2ShiKVkj5p/y/TFAc5qZIZob69M3UU0iaMpMm90=
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
 arch/s390/Kconfig              | 1 +
 arch/s390/kernel/vdso/Makefile | 4 ++--
 lib/vdso/check/vdsocheck.rs    | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4b51bc6e8948..bc12367a7b00 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -291,6 +291,7 @@ config S390
 	select TRACE_IRQFLAGS_SUPPORT
 	select TTY
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VIRT_CPU_ACCOUNTING
 	select VMAP_STACK
diff --git a/arch/s390/kernel/vdso/Makefile b/arch/s390/kernel/vdso/Makefile
index 35c834b895ec..509ef3f1e2eb 100644
--- a/arch/s390/kernel/vdso/Makefile
+++ b/arch/s390/kernel/vdso/Makefile
@@ -44,10 +44,10 @@ CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
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
index 4aeb7094e552..b2135cf9add3 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -148,6 +148,15 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_S390 => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_390_PC32,
+                bindings::R_390_PC32DBL,
+                bindings::R_390_PLT32DBL,
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0



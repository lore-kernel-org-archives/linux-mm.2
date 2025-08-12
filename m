Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974C8C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7368E00D6; Tue, 12 Aug 2025 01:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030BB8E00BE; Tue, 12 Aug 2025 01:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC3F8E00D6; Tue, 12 Aug 2025 01:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C57058E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 616C7B6CA4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:51 +0000 (UTC)
X-FDA: 83767016382.04.26019E1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD76040005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=F22xZcK2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CIvDa3NH;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977490; a=rsa-sha256;
	cv=none;
	b=KnSEDhjy/qi3dW5T6NePtXXZW9zntWE9CoCayIR7vIzMXXto58qvzqqDrhyn8tZm7ep3n+
	CjmPQwo/ZYhKUxc6+1BJWnGZqmbJMIpQindaJrouIPeLqlxxDxHmFvsTaXnX8O1UUgCo/C
	PpXPcSBTnsn2iBBiUkV1J++eHXTMNPw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=F22xZcK2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CIvDa3NH;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8J7TMiJJPZpKeE1Ou1BERsW/DWLgHHFhkRd6+bQxh4o=;
	b=v0yjY6MsxL0h+NArmk47zBE/OdKa06TGcK5o994LspmRpC3R0sVgLAoDPc6zVCCVipPIjH
	Jb3VwIFwIH+1YCap6HuV9iP0vnsowwQy9ff0dZbKXK8jmOVJUNAiRRDWf5/0jDKnXenRIw
	PKx8ZGSWoo/Srxx0pfRhsrIHDFPQ8vU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8J7TMiJJPZpKeE1Ou1BERsW/DWLgHHFhkRd6+bQxh4o=;
	b=F22xZcK20TXBf5jZYwevz3QDaZU3UZdkYRKPWY6C4m9SOtAW/94DLHjYy+CQODOajcbuP8
	MPuKnXuduuI/jhqsirbr4WDRq0UCEwLS9ico7i3W51ZwBK//QX5U/DFAfzE1ZfWMKRv1fo
	U204HMGXOXouMg9NvdzgNnQ3u5xAm7roz2wc8MIoolSJvm4oYaWLKrkRHYueW7rKS1NB1M
	M66TWmw08jIG99a4Abb4Ty+uqba/s3TVFyhenXOKgI+lnOHn0VOL47w8Nbea7L7Aa9lbbq
	qDIyaw6x+h/5wdjGBDsWrXJDjrCbuIbIvo6NedGG2NbzD7A6pnHseaNfqod0Fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8J7TMiJJPZpKeE1Ou1BERsW/DWLgHHFhkRd6+bQxh4o=;
	b=CIvDa3NH3jry3aeRacozBMFDrQSzLfZ5hYqcOa0ZRn/0gu5GgdotOJzL+xdQny7o5u5pZT
	TOIV6QFRAgoN9fCw==
Date: Tue, 12 Aug 2025 07:44:29 +0200
Subject: [PATCH v4 16/24] powerpc/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-16-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3422;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=r7UGwjKWy5Zeb3xhIIrMh9pf0ciHc2+w+MWcQSjDNGA=;
 b=Q0EZvSWT3Q75vpmTxwYRVjiyR2O2xw9tAfm1kD1FblKw0cRCQJd0iAfyLt/+gYR+ZyTVxexIt
 TIIS6p5vayTD8+ve2mOSceJuJpTEl1kRVjS440cBUU/8+/7OHdQGucC
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: AD76040005
X-Stat-Signature: cy48uhrruuywa9oatqqsq8myeaqwoirx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754977489-590628
X-HE-Meta: U2FsdGVkX1/0ZaD0oGJxA82fEJYOOkumXpeRuBV2B0h8+3xlTq8WJU2IPprvoNqhrMF2rA06gTnsRflvb33tIVL8d4HScMtTUk+4jjFGxvXIEdgRGKz+0eg+qZPb+6NV6SEb3O20PdWw9AFzgHEmSTK4hKXa57ODZEo/5EaxPuuaRjhOLVVCBxOyXUARJZNTJhxd30wcNWSQ8DS7KuajjQMr4uR+E6iAyZ6vwC6C4mbMe0m5ZcQfqorKTntF2/noJ8Y0bhPfsheect4EhCt4xgXi90OCh7p9aBCXs9mN0arA5LcSzoX+Yl7oSNFsk4ASwDbvgfYOxO5mypRtRH72Lhc/LiVLQVuyiYGpc9vci0hHEmS7mL1S/zGXHBjk4uFr53rvmhITsGDv0c3XyUqtvvAMmQ7M5NYv5IlutESsZdblF+X0qjivHii8TfW8CE2c7NTMic0bYC3rqtYk1pieVP/1zZtS0FyhxXiMb00txS6sEBq1G42dE7Yf84/aMEESLpkBK3cGKQYDvP4ZmaydCy14ZBIPq/cyBDlgkv5Zz5F8bbtRoLF2iQ58vtYcvF6P+5GaqgRBfNk+aZoxKCxsafpPqO8+bqMZ0muX33jb7LYPFfw1vuISqDyJREzgjrLdXE+C0L+/vMmot7Izq9OumL24tONgwNvOxzM73CEvlTuNFA96LbFgykytXGtB7bg5lyRTO3S1G8odN9jkCekImMKEQC8aGaoY4UHqUlQX1/EG8h5QFCLYwV0r+dqUM5QhyLH1SH27XK/PwkfnMLRccSkcGg5tFGlpYpoDllruWzsTntrDv9VgmUP4xuVWxmM8y4fwX4aKWbUOMPOPlBKijz4eEOty/DHYC6r0mnsXJLAJmveneYrT9xmv4QAuuP/PyplEdUgLeO95sLUCCjy89LlJWAWJXnWSEhp24LJa0viOClgW9mspITRHQLQ7UdMVykP8bpvroJgL93cBQ2X
 p3P1uaT4
 7ZDRjK6RMTlWNdMf8Xbws0TeRXiB5+5Ew0KoSwRH9cUs55RhUjg0f22Z8mvvIh43qi3Q4g5lIsaKMFQ5YWPDZEuAnYXSbC6KI5ph2lphgrCWARQJXstMLU07sl2R/bj72i49j8IJzFmsQ33KzKDuTMOMM5TQ6nhkcNltI
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
 arch/powerpc/kernel/vdso/Makefile |  4 ++--
 lib/vdso/Kconfig                  |  1 +
 lib/vdso/check/vdsocheck.rs       | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 8834dfe9d72796c8f1e20b84ebcb33a6b74b82f0..193af6877eba25898aeaf55a04cd834f7a2eb753 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -75,9 +75,9 @@ targets += vdso64.lds
 CPPFLAGS_vdso64.lds += -P -C
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o FORCE
+$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o $(vdsocheck) FORCE
 	$(call if_changed,vdso32ld_and_check)
-$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o $(vdsocheck) FORCE
 	$(call if_changed,vdso64ld_and_check)
 
 # assembly rules for the .S files
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 3037b15476bb60ee47c1e083eae3968ab9604f59..8994419d90e7b5c66ac77449b6c3bd96c968983d 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -54,6 +54,7 @@ config HAVE_VDSOCHECK
 	default y if X86
 	default y if ARM
 	default y if ARM64
+	default y if PPC
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index a695aed95ad391a0c55e5388bc6d1f1141fd784e..54372a547b1cde05c1a4454b9a21de357b22b0df 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -65,6 +65,31 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_AARCH64_CALL26,
             ],
         }),
+        bindings::EM_PPC => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_PPC_REL24,
+                bindings::R_PPC_REL14,
+                bindings::R_PPC_REL32,
+                bindings::R_PPC_REL16,
+                bindings::R_PPC_REL16_LO,
+                bindings::R_PPC_REL16_HI,
+                bindings::R_PPC_REL16_HA,
+            ],
+        }),
+        bindings::EM_PPC64 => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_PPC64_REL24,
+                bindings::R_PPC64_REL14,
+                bindings::R_PPC64_REL32,
+                bindings::R_PPC64_REL64,
+                bindings::R_PPC64_REL16,
+                bindings::R_PPC64_REL16_LO,
+                bindings::R_PPC64_REL16_HI,
+                bindings::R_PPC64_REL16_HA,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1



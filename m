Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743A9606A333
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=AdnWR/fT;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=CiSYPSUw
Received: by kanga.kvack.org (Postfix)
	id C13796B05B7; Mon, 23 Nov 2026 08:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAE26B05B8; Mon, 23 Nov 2026 08:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9D96B05B9; Mon, 23 Nov 2026 08:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1256B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11FF81A0893
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:26 +0000 (UTC)
X-FDA: 85466520972.17.EC0BD4D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 54AB420004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="AdnWR/fT";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CiSYPSUw;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441884;
	b=jl4RgnnBTPKNwJKayQNWrucx8EZqtwb/NN1PiOa6Q0OyGjj3doRgGZVC9OxryE9pPOEfVh
	n8H71UYRJwp2AI8xAHVgYjZq3MrshfFku3EOfJ1+y7cdW85znS0fbEzOMDzXmSwjZXDc7m
	pE1KBGmfbe+WLP3kMC/AeYHbuINCQ5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbaUWZC28smuRoW90pWpaXz3GGY4MsOKGg8st7PIjvw=;
	b=mjxaaCgqHagxXY79TVZz5ZAcUUhj8fgJtg0wOkB8AvzJfCWfKW8fj2awnYiKVXqsZDfg5N
	G9dPvDIeIUs7IbddWqOlco1TsXZjgMm9K2JHEgc+Bue6S3ihIet5OTJlU6v3FufKP1wauF
	MvZnk5R7ctfATsC4uUOrJd94GjJITCI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="AdnWR/fT";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CiSYPSUw;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbaUWZC28smuRoW90pWpaXz3GGY4MsOKGg8st7PIjvw=;
	b=AdnWR/fT44yXzm+ht95OqsrELNCyH358idfw54sxV+82ZCQh8b1aIvskImaSeMPYYiPAGX
	tMSFHMm39iz7ISqX2w8pj4D8L/qzXb1g+WS97tFqN8moTMNum/DjAz0AOhUR9mHeaYQxj9
	5LZEWcHDHmfyVG3iQ0WvT8vFcoQbpRxTznUUUuQTu76cbBTyn3KQ4CodP8l937jaO91ZuP
	Qt441N7af+F5t3S2BxLy/sH8WAJ3bW5O4y6lY0UQw0K7A+UQhTXKdNOY7nqA7niM/tyffr
	0vxJK9JiP8+NfpneuW9wJzwcEPrvj3p/SNvKjKHMhV35bVoateZvXcf6rspcBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbaUWZC28smuRoW90pWpaXz3GGY4MsOKGg8st7PIjvw=;
	b=CiSYPSUwyavYYl1x/i+wWbxPyj9epV9FlY90gd2wiTfE4WxtGjnCDB5MgwLKxaEC26eTmC
	kUVvWJED9GTdvTAw==
Date: Mon, 23 Nov 2026 14:50:56 +0100
Subject: [PATCH v6 05/11] powerpc/vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-5-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=3226;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Cgbtb7qSJ3AcXOvZFi0BZIPMWqlXOiwZ1bBjbdIILZ8=;
 b=tf9jQyiu6Hx303xQeraxjP8OCezqMY+3qKghsgR/OWQajoh6hO04aKYTX/3KWhg5DquWsJP8b
 aAXQOlfMR3eDCtoARUDmA0kN0uVLstrGS/+wTZDeacxxM2luRimKr84
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User:
X-Rspamd-Queue-Id: 54AB420004
X-Stat-Signature: x36metgyhbnfhw467cb7ciimnc67a1sm
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795441884-612180
X-HE-Meta: U2FsdGVkX18cIUekyKGS0lFHNslyv6xgq05USb05WJMT4xrmS0nK6MezlgeNt8AKVYtsgJwhJ5M/Nj1U7j4sx1PS4UI5dOth4KdvLNWeQmT+DS7b7OL3OKYkdOOlEVeGG02K4q9wuBwSMR2p8HDwQPLPachDIKOkvr+zYtNcXFK8DkzPStrAAuX4KHONvoQ9sLQQBle0DGG8whyWjzRixrwnREltMNJ4kQNidai1KQ0vM8cqAIbC4WWaAv/uW9t1/kbXPkmrOMSjXxSYLDNTah6bTjBeep0mgaERPEpf9DRGR8ltVfHbbaEEEY/3Gyg7+WKHswz/vCurVN9oyGmxjS+pdNLNjKuYPScWz+QBi1oeYqGCZ+Iu9eZj019NtefqqODKl+OT9hWGou47Z4olfC9LOcZ04P63R8Sle5vIPr5oYBSeJG3Nd8his06acwZm7BlriKBSygivOQaECsoIl17UXCNoxzE5ZrNNtPIdhllrqDGd5p2nkgJhwTDvMIc1/+nRC/elFvEA8vhNwMNSjx82oOowVIItrmyUT/BLH5tz6Ub2LH5qfkd4gCI9Z/1NLE/Xx2eaQHtGXDnCILv/DwhJ7vS93kvghSJJX4eUi8SxXVFVHS4F8q2qKlJrW3BgW7/UwZ1HkNA9oENYcfulDEkO5A2KSI11B13SGP1Z0D4XpBgP9tEfOWD0K3mVyOCHv9K1dYEFAAxGsQknvt0vv4B4TEgxveh3DwD88LNHvP5OrdBc5c1/sbCMRirnYtaz6hPiVtXHs0j349oOZfUimg62PyLpiUI28YD9ffgYMIW4GBZgFep21P3JdQAC/GP0IODpK4yIXjx38CxWkyZAnhEF8gy+0wJtlWxk5xTOQl50evPXUDVxqRG7ybrjZuQOaAXM8qGVw7B26HDdkz5LyPvN1b/qHYmdfrAgqwQfVjzrd04pz151Nr7Kxzpenq2a9KHOiKnMJAYrXgFf0Iu
 Ea5unwa1
 QPlszJj92hnKtvOixxOzVeAOaqtxUOfURiV3BsjxOy/iL+l7TyoClmQxb3X2wRU9hbZolEUma3+VE/EUC+IEl/c+uvaF+ir4TO0EqERrk1gw2tZ32ITS6QWRkuEegxz96fdUP3ULA7OUcHiIHqfwrPf1+t049lBnG6wGtMlU1fLdWL1wVdBuaa9pzU2XGDhQnH5eZ1S0Lp+EszrvxWxN6Or4BpgGWqvXPOfO1f52nGs0TkageXbUkfU4KeGwsApsToZRkF+MyWE3wYPQdbPBZPmPlbpnpULdkKvySFCan170iKRY1XrMKHQj5Qf+A9FLBhPD5PXbm7F9NvZW4EYyBs9C6UyA582Ve9JmxZxnW/k8dHUo4WLQVgKj2Va7FjCh2VIljZy12XmJgBn4UYyDJTr6hQk/xsq47KuoCCAhgZfdPBbjq2L81fnN0qDU4FXfUxo7LU42ocVCUybYhXjlrMKO9PadOGhDZNpEDHQkwrWhcp/TVYQpx4Eg38lpDMVgba2y8rCv97RFaanKEI29/pL+e7iTP8dbmZ/+X6V04N7A1bVDyI56grccFy/mT6rXlRrvjt1XMlID5EsIQZbEN6kDlRjUJVQLRo/8AfyT84uQG0kC+BGO2q5a6iHUlhCK1pHdXCWWwJbW1SqaP+WeSo5UD7p2j2qvvOSiTYy1bDIaoZ9yL4wjFBjnO1qXjS73t2YmASqt9PFUkH+mZCb2ONTKYghmFo7HPG07/RQ2fVTy8GcM04okPZ/ivJJmZ5ya/LlMkJFHk46CXmeY=
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
 arch/powerpc/Kconfig              |  1 +
 arch/powerpc/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs       | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c3b6cd655606..1c4a75c3a830 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -327,6 +327,7 @@ config PPC
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
+	select VDSO_CHECK
 	select VDSO_DATASTORE
 	select VDSO_GETRANDOM
 	#
diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 0d1a49529885..b2e399e10273 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -82,9 +82,9 @@ targets += vdso64.lds
 CPPFLAGS_vdso64.lds += -P -C
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o FORCE
+$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o $(vdsocheck) FORCE
 	$(call if_changed,vdso32ld_and_check)
-$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o $(vdsocheck) FORCE
 	$(call if_changed,vdso64ld_and_check)
 
 # assembly rules for the .S files
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 0d5ceaca34d7..da58ff220eab 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -69,6 +69,33 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_PPC => AllowedRelocations {
+            in_object_file: &[
+                10,  /* R_PPC_REL24 */
+                11,  /* R_PPC_REL14 */
+                26,  /* R_PPC_REL32 */
+                249, /* R_PPC_REL16 */
+                250, /* R_PPC_REL16_LO */
+                251, /* R_PPC_REL16_HI */
+                252, /* R_PPC_REL16_HA */
+            ],
+            ..Default::default()
+        }
+        .into(),
+        bindings::EM_PPC64 => AllowedRelocations {
+            in_object_file: &[
+                10,  /* R_PPC64_REL24 */
+                11,  /* R_PPC64_REL14 */
+                26,  /* R_PPC64_REL32 */
+                44,  /* R_PPC64_REL64 */
+                249, /* R_PPC64_REL16 */
+                250, /* R_PPC64_REL16_LO */
+                251, /* R_PPC64_REL16_HI */
+                252, /* R_PPC64_REL16_HA */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



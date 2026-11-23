Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC7F60A261D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=c51R8ppc;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=yQt064qw
Received: by kanga.kvack.org (Postfix)
	id 9F07F6B05B3; Mon, 23 Nov 2026 08:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7F06B05B4; Mon, 23 Nov 2026 08:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B66B6B05B5; Mon, 23 Nov 2026 08:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 667D26B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0536C08CA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:22 +0000 (UTC)
X-FDA: 85466520804.01.F571C31
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25776C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=c51R8ppc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=yQt064qw;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441881;
	b=JNaIfz4K5DcZ37qktbbBwUoga8GdSCLTGRhIGGL+wDH6TpgR206YpeRqIjASLkeYd1sHFg
	yLhDZiXMqKFxLg6ZvBEvIU49hqb9VHqIFnKfMCi5p1V3BvXeyeWE/clhWDY2VmSi9aFliv
	K6IQKh/1EdXZp8TEivEmMdQsY7CmtW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9c4YRQQ6pnzSBpHUo5gQq1+MNXBhFp0V4WLQqxvRU3w=;
	b=Kzd8PoYDKOjRObs0genHvIEowQCu+iY7g44ojNqrE1poDhmZ5anf/HOdOEe0xD9mZ2lgm+
	dY1CSFY9G3PjeQBi+VnsOJHPEonbmOLET37LDmvdlKHwYC63LlegI1tvruv/bUsVs1u4NQ
	9VItzdhTtl+Gwi7Lwk3YM5uoBONJKZo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=c51R8ppc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=yQt064qw;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9c4YRQQ6pnzSBpHUo5gQq1+MNXBhFp0V4WLQqxvRU3w=;
	b=c51R8ppcFvgF+lecaj/yMlPRqDjEJqCxkHivVfbfMQYdSfZe4M6c4s4DoB+NYtz7vO+Y1t
	zZOi7noMVQNksc1y//WWdcFqSuEJJ5VrMKnXxTPR5jbhVw16t+8ig0vz2qxTFGsx97LlEV
	7Uxe5/+6DmvvvdKnLhZ5hkReO6ryCa6YDLcA6hFwgtuHyUBzoOOf8ceeoNaqPaklx7PIyF
	P7gF2nVtFX8AGncfEJvHENxFQOf+VcI4sDu8GW+0V/oxaZLjGmJxyoSPUsV/ExJ5sbdp1d
	ZKG7YGmqcArtssE05wbISs4JnXpKGfVfz5XJo+/b5IbUn7BR+NLokBi2wh91QA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9c4YRQQ6pnzSBpHUo5gQq1+MNXBhFp0V4WLQqxvRU3w=;
	b=yQt064qwYnbu3hJCbzrs1LSu9wJF9vC0+skGBQRPBjGzvIEoRyyX+E0474vs7Sqd4TUE6E
	XDQAx4LTWCyhrtCA==
Date: Mon, 23 Nov 2026 14:50:53 +0100
Subject: [PATCH v6 02/11] x86/vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-2-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=2480;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=QoUIl45MXZMRNJ380RzxrALVLspll1WbUT4Y7wjP5Nc=;
 b=h6xhrNJ/daWsX6d0KucIl1wYohqmJySrJ2C1jkqbSYPKJvt4SX6MThWjG3AJ53+HBHR3/pKpF
 7soB51VQ7nVDYQrnRCfrdx/gAbVU1MOH1o8b4GwEdR9wgqoPiEeBzvq
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25776C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1gthzpam6ya3ixycrgtbmc48gaq1su6z
X-Rspam-User:
X-HE-Tag: 1795441880-155911
X-HE-Meta: U2FsdGVkX19sfNgcGIT9Ftiqwv4J9MoYBv4fX8HLCuQ3S7K4YuwsKedF8d4En5hDLevGa8/9TEo8SOAi5Q0bs8FYnqibnxLwLMqC98/7jbxaDRD8MqJSkQ8r6HroROfe08BPMe4WGjv6hIAKDewegQHsrJu8LmagsSUDE8D1+/su0ht8PnQYLanNEst0ShOlsa9HCQIn7PE7vk9Hkru/TLZLSB2Li1arrjHFQoT8EG2W8BGqVF1Ruv63TePTXBluagFnJhwGvb9rbrZPilfMR7g2f/s7FZfCvV7eVezx1u29+xFf6XDFVzFDSzwt5nADtNzsmBnDmDXHO3yLFMxe6AGLAMSHbvhAKbBmGXggyZDSHQvW0PKUXA6RdBrzBwLOkZrXWx0l0i5RfAq3Jr/6BT9e2zxAc5WXFll6q4e58vc56DJ1La5BqUvkBDTpsGORKqCwz0K3AhW3lcvyjRXmjuswv/BM+ap9xLiXVUvpPqlwLwU52IRQkPNOaqvA8H5gcOBQaHY1BMZI0ETMeHrA4w11zxbME5Wzessa/REtqeZPbJb/ZbAj8gguWSqyso+EMqlQDZNv26Txo69pUk7VPvd//2aVqdTKMFxHnZ8BzQ3KG9I5FScFfYEDFvZCZzS8ST/C9w9O4RwDnPkfBVsn2LUZSClTSKG3j7a5/n25gt5XIS2mjatb1MsbgIhuKbMEbJ7P3ATLBoq3tD794+LC8LpMBQHT+EUNxMrN4n3LPiUZcm/kLERAJVDMfN+Ixl4OOduKRYxayCQ1PdVckLXPaTxA7aIyD583g9+pmLA2ko+W/KV5Xg36vOQqJbEW2KGgfYxrTlFdbsgIprIX1QU87DTqP9UiMLgejb6RXNOpGd3F/vnRTlCVNrbsyYSIqF79AJRvw99kftV8jE6XvYZmFDNBd1oPHeRlG64g4ofXjFI6CkxB9pZXfHwoa6ArqleY3f+a5r2jU4arxh4eKTp
 OSL+WCau
 UZpNLdDPKJaioBSCq9m6XVKzTbrwLElUcXfXZy8G8DGjCGu4jfQGCqEeujrcoGEJDUZTUd7ROGnD2nZn4ReTCk+Hbw9FzAGHs9HZAmaaR9ocM/dxo9xINR+roF30ajlmWsxgbks+m2O4DuMjyx4vxBdGiETAOe3dDZvcGXyNRVhiDwLOrLmgWEZm6HUoa8JhfIoSp2kO6etXjVgrHtj+/DHM/IzpylWZxaR3H2PYXgJl8BidHKVrVbjbfab7EZ43i4nZc8i5OixM1n5325Iy3EUK3uBIa4P/aTNZniwbWthPME3bz9xhvQy01lNsuUwMD72QzhLEt03nrFzrZMpnbVZIY07T8uHao07FxyrjzVVlhfQdidAEmnJDxdBJ7mDm8poj0u17woDM65tfdORxX0Iv1KclcNlu4G85s74OYEW4n+C9bsavb3qcMTr5Djo9gKiXjRuQ+spOiISVDpzvrMc3Kqr7YpziHwIyAo1WsjmHi+rGNHK8H6MAvDEpA+utW1ooRSdFzbazIcKRab4bAu4F6csQXMwr+DBy3RBUCO6hV4Lgn7K6POf258KQKfKOQN707nM9EqlgvcQkAPHonJdHflVo27ZA9xwDfyPJWw/xJjpdk1w3hkkQ+HCAd1BdcZ4UbmdzCqHNma0T7gJisHGpVR8DLFnfBKGGGtcC5hg7045x9xVxb9n8bKnyy/sWid7FIJelNNmpQSyBwpkpkKrLi4RGtbY+Eg7T7odW+mKB1E7BTaM0Tx+aWi0bFFVNElWp6JHbhuvYan1I=
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
 arch/x86/Kconfig                            |  1 +
 arch/x86/entry/vdso/common/Makefile.include |  2 +-
 lib/vdso/check/vdsocheck.rs                 | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58dce0b66179..09d3aa04ee82 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -302,6 +302,7 @@ config X86
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
index f4c0730bc976..8cd8c7f3fec8 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -34,6 +34,20 @@ fn is_ignored_section(&self, section: &elf::Section<'_>) -> bool {
 
 fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'static>> {
     match machine as u32 {
+        bindings::EM_386 => AllowedRelocations {
+            in_object_file: &[
+                2,  /* R_386_PC32 */
+                9,  /* R_386_GOTOFF */
+                10, /* R_386_GOTPC */
+            ],
+            ..Default::default()
+        }
+        .into(),
+        bindings::EM_X86_64 => AllowedRelocations {
+            in_object_file: &[2 /* R_X86_64_PC32 */, 4 /* R_X86_64_PLT32 */],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1



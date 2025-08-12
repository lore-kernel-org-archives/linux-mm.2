Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550A6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B168E00DC; Tue, 12 Aug 2025 01:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4772F8E00BE; Tue, 12 Aug 2025 01:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FB08E00DC; Tue, 12 Aug 2025 01:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17BCF8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDF9AC01AC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:57 +0000 (UTC)
X-FDA: 83767016634.15.33890A2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02120180003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DOgN3Y5E;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Xp94uLfR;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Kjpq5eR3VtQueM0L6XasJAF39E5US6j25ec6FsCv3w=;
	b=H/adbyeWb6wvTmd8SKz8knhtmr62MNTk5tN/qYs+WDStUrSQgzen+7EfJy9qfTqQLg5o1T
	mS6Mt8WL13UoZg03H35+1LxbUKTx89I4B8GOCHtE9WVZ1o25jCCkpegVyGjBFtKKEl6oMY
	OqG3X/1BL1r5ycqFXploSUs7+ZGF+mk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DOgN3Y5E;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Xp94uLfR;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977496; a=rsa-sha256;
	cv=none;
	b=w+DQpE78jxbbHe0W1mTUdU/wpLYBbVk2kNZn2iwSKkKOK7VrNMWmFOZAuntDJFgFNF7eDn
	hN1mUgryQEYgVLJqk6n/VQ80mfMNWRB3kWKva9gulaQmbItPxB7Vv31+6gX6VDN+ry5pPX
	xpC6k5sDprS2+S/qEaxcc9NNUCW0Tug=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kjpq5eR3VtQueM0L6XasJAF39E5US6j25ec6FsCv3w=;
	b=DOgN3Y5EQB5kdutA1572V0LhXOZXnmRl6p0P18a1t7ObF9ucTKlbEHkVhxaejvdIZK3PIY
	lIUNnRcEoWpe9jMcL/sz5eDD1osU0bJplewxq79IGnmKl56iuX34wGlZkE8q0QXbW8ODPS
	/tRsjn5u/aceWhclEIiQoXuf5PoMDguQZFCa+gVrW0g1vlK8gccXdEQDtujNgXNNo0KdxN
	WuCKV7zOYOnI0NnSYDP7lGE+2WUwTHGjY7UEreXmXplASXvZjXyi/1+qv/lFjFdZDmXlU/
	TSNZ1c1JACCFOcsJSoennrnbZSFvpsaVg3kBWIxDpWM65m2K7yxEzt3JfuJQug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kjpq5eR3VtQueM0L6XasJAF39E5US6j25ec6FsCv3w=;
	b=Xp94uLfRG/UGZ4I0EOrrP3/TrL+9J/C3gXEU1nyi3fx2RRuH8xCgRiBDmDN3dECl7takoc
	IY8Vx1R01mdHNgCQ==
Date: Tue, 12 Aug 2025 07:44:35 +0200
Subject: [PATCH v4 22/24] MIPS: ELF: Add more PC-relative relocation
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-22-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1659;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Kx23G/jdGST0tg6021hFwad6UPxIH/+IOFc6beuEorU=;
 b=9721hy+2tPJhw7rgs5OUlE+6rM6NCuWPGCnHL0GckAQKuaqMknOzzL6abxn133J0vzAnS6u6/
 H4ms/FvzKN2ALTXQO9bp4r8ji2uMhcnak2odoRO0TaHpLw+mLogGUf1
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: t4f978oyhnghrju1zycyx6dacru357td
X-Rspam-User: 
X-Rspamd-Queue-Id: 02120180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1754977495-187575
X-HE-Meta: U2FsdGVkX19Yy0xMFrctWNVSGhbAy5wuLQJWz5Ukj0T7mQs2SkNXWfL3xtcWJCzwVjjfwR2Z9A/uGEwKOilW1wXZXPJAah1XGL0Q10Lk+e/SOomKmXrWHFuut25pTsSw7voIVRJLDRZAvrvkHOv8ZsV36Gz05jV24gNqHpBlVRdu7FIw7ES/LkIdaGw+/5R1DnJwBKFYcq+moerSN5YiX4NkygPWd0eqI3zyPvSdJBFEgmSmJGqxIFfl5Dafxa8gDwKwXx17An1d+Kt8708EsK2NLeDPwDHmK/x+m2OUcBzCyJge7781g20Xrqe8SUC6p5I3fyWoWz1TmospKlbQNlRq9YEgd6F+h2gE/gBp0IqVUzAJP/wu+54vVQegp8axaZfFd26Kzjgd/u9qTk2PC7gr+lMuiPVasEPwO1Rv/UElWuLEdeHm/pWVPFdkjZb3PGMU0gth0yQHBhlMf/I3kd+/ziJOAtxCzu1PNq498ckNKycILrDO9qFhwbeyN0w9d62hUoibLA/UFteeaDszPzg3FeYC5Hb23FGXDnikmp4C/vQ3zzXV+ihjrPiVZorNO29EqM1Xw6MkFvkF5CeSlbMb4kj5QLYrTeo5VkVUzFar1T1yhf6boT2+THVEQQ0oGbwk1EQ4wJKG/3oDY/IdkAPQ09FaXpHZGN9yupPxB63vSbQmBKRhU0JJ7i7xETB+s5qvRaihGil0tdOXNRb8MVUELq1iXdvFm4T8XAgq2/oe72KzL2Sm7huttb/meChbtaI/GgNMsrAuyEkuYqfl3mKFVgxu2ra1/RLaKU/hVuuWEWh/aXXOHFiraH4VU8mTB5Mx2PQ6iiCPkiB1Qq+rXTyg+oPTMT76s5x2UD+DAXd8964VkOyE7ofbvOGEJa6HsAPICvKhM4haTld0/T8YzNvKFR3oVwJYfXgsQbNK51ffoBYmtz8RzrTJCcRZbYvKU7Z7DvABnwzGVhD/ju5
 7d6YrkyV
 OQYDYXPTMiapXT++3Dj/20ddEGbibBexpjNpoUpLNZeenmaw6MUhIJQ9dRI+H7Hq8HWUa9ctboFgghxmSZapP+sO6e8DbyCohdcJQIuM0xu0vajPzGTwhrZUImtisKywVFuVqC68iFsdOcXjBdJfO+CDIrTDzaBEilumpQCuviYkvnsbNdo8zhPgBZ9b9jwHyuXuBeFz1r8E60n9dw4Kjj+LwADXWncgzO+siSejHHcJFp0Dk9j8BHRE/xFUalGZtVsRkwGkMoVOaja3QmLPCjXzHHKzk/celYUT3hw1dlpz+6v+1Ryvo0V9He29QtUXUBca9MW+23iU+ZDDBXu3RxW7TQLBJrzW4mJaTpCiPhl1e7R4PGVUg2sdHJ3HtqHkE6EZ/l7GTDmxcwKB16RjqvPcDBSkFd50zLnZfitJCTi9BJ+GL0mUsRqG6yfT3L6q/PeF/bIPZi2rrzAtAhhmDrEaRjK7yn9fwhGhv0Su4GxaQVENzdu8xLFDcQcK59EwX/g3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are used by userspace and are necessary for the vdsocheck tool.

Also update the copy in tools/ so they can be used by vdsocheck.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/elf-r.h       | 6 ++++++
 tools/include/uapi/linux/elf-r.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index e750989e44e8f517d7dacf9d3a338af7a136e40f..9f7457ba1c63252d10b9ab25601581bd99af7a21 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -616,10 +616,16 @@
  */
 #define R_MIPS_PC21_S2		60
 #define R_MIPS_PC26_S2		61
+#define R_MIPS_PC18_S3		62
+#define R_MIPS_PC19_S2		63
+#define R_MIPS_PCHI16		64
+#define R_MIPS_PCLO16		65
 /*
  * This range is reserved for vendor specific relocations.
  */
 #define R_MIPS_LOVENDOR		100
 #define R_MIPS_HIVENDOR		127
 
+#define R_MIPS_PC32		248
+
 #endif /* _UAPI_LINUX_ELF_R_H */
diff --git a/tools/include/uapi/linux/elf-r.h b/tools/include/uapi/linux/elf-r.h
index e750989e44e8f517d7dacf9d3a338af7a136e40f..9f7457ba1c63252d10b9ab25601581bd99af7a21 100644
--- a/tools/include/uapi/linux/elf-r.h
+++ b/tools/include/uapi/linux/elf-r.h
@@ -616,10 +616,16 @@
  */
 #define R_MIPS_PC21_S2		60
 #define R_MIPS_PC26_S2		61
+#define R_MIPS_PC18_S3		62
+#define R_MIPS_PC19_S2		63
+#define R_MIPS_PCHI16		64
+#define R_MIPS_PCLO16		65
 /*
  * This range is reserved for vendor specific relocations.
  */
 #define R_MIPS_LOVENDOR		100
 #define R_MIPS_HIVENDOR		127
 
+#define R_MIPS_PC32		248
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1



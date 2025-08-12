Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0420CA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5580E8E00C7; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C30D8E00BE; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363F08E00C7; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD4B8E00C6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C49B01A01C2
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:34 +0000 (UTC)
X-FDA: 83767015668.13.D44BC14
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id E00A8100005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JqzHOjKA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=eJOu4USm;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WeePFN7UO8+hOKOyWOa3G3+alh9wPXoqMxnhe0D2ylY=;
	b=mmTj1JoewgqG+O0gfRBMgu5RDDOlIILmpghvXAqlRfjgVv65ha2UUIiIBYNI1XBvKKa6Z9
	Pof8Mw3NLsKpI7qHPnkPqm+0jWqQvuUv49p4Q2ixMZcsmBsqlyqJtRU+JK/WcUVypsDh0a
	lkG5ekokq46mnMyZNapduTx8pQ/muCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977473; a=rsa-sha256;
	cv=none;
	b=dnNcUCbOKkeeZaFCcJ/uwGhotCeGfSOBqZvdMMnyki3MaudBM/E2cxMGhvwlLps+Fctnc7
	strfUw3l6LExfJcW7KtwXFhS7GaOJALEfwCMoia6KukgRyqD19DuhyNObihiDHQKVMAGFy
	EKXpTxtxh8b3PSFzHMfHgqbi+PfvRzw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JqzHOjKA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=eJOu4USm;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WeePFN7UO8+hOKOyWOa3G3+alh9wPXoqMxnhe0D2ylY=;
	b=JqzHOjKA7yrLionJrJNO8KOAarJG0Oo28v1APFSwq89167wmxb1lZyHMuXNnHrDwxH9gSS
	/ELfgioTR5fb/Ljc+sYJEHqydQykqY+dPku+piakuLpoYplUy8nu370IDCExIRAVnKTo2d
	+v+xsnzyadL06twVI4C4micp1yORPIESPL7D6qalI1kfH6fJTrTV7AQ+lUY6RdlBKcOlnG
	roKFqmu0T++7EKHvIZhYIq0thUktatKAE+bdUH3O4P8hQJDR+cw+xBAhVt8geh7pm3kY7R
	qbqMp5Grpn0o6oeLQHjtKHgrAL7YpnUDvTR5ZMbjSFY5TkenW05hQQv/hde6lQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WeePFN7UO8+hOKOyWOa3G3+alh9wPXoqMxnhe0D2ylY=;
	b=eJOu4USmFl8u450RqsRFSXa2Lhj6NjHhqFOSqGSdot5xvQYhfz7huLEAqhu43i8HbV2r/Y
	gOvSdTkIIYEnsrBw==
Date: Tue, 12 Aug 2025 07:44:14 +0200
Subject: [PATCH v4 01/24] elf, uapi: Add a header for relocation constants
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-1-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1460;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=pEZOOlfYLKHxA52mtxp/u2Atua1rkGYZwTp881737QA=;
 b=FP2/6LZXvWWXU9TWRCOGilFMCMdFH/DUVBCJoOqArDIYqbLz6sxu9BRz2ZOAaXa6pVuX1T7y8
 Okzk+BkTdhVBChLHs5Bq2jeBZHod38wzt/AG9GAvJK+HF4hyrhvGqlM
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 8af3wi6hpap9abha9tysyc55h7y1dshr
X-Rspamd-Queue-Id: E00A8100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754977472-934841
X-HE-Meta: U2FsdGVkX18x3Ki2/lFoJHXlTgsgWuy/b8hepdmeelzwKCjVw87AMJKZAb4Ue9WxTWq+IvjbMw7PXRsZdRfl6GKIz1iAmsTOSTVas8O7CwnWKicz8+kYbR4l4M6YyfFClnXWD1x/T6pOmwogRvvTVYqQgkeaQC4QX++tbEGbvxlttkm9kXtaAECAeSW8fl2t4J/bPxcTNGJz+ViEVHt+kolU+BRcBEy/QGodZnSt5Tq1yIgtjAeOz3QqvECiL//du2N2vRphW8S5dHRx/IKNMklLfqbqvm2a3/hMmVaY0joPi5JpsJ4t1gUsVOTD9cwZhvyC9BSzYE3shzSNEFBwdd5KXe4oAbUhEkxUfhrLdPO/akj4jeY57jczN4ZvwoGTV+41UG6kzleEeZ4HI8lC2bHuhi0Ed996wyQSVYPBN7S/0i4krRXKEpk0O2iN273N0e62dxesRh7xUQJr4hoDwNSZmkBtqVJO9ChA6B110WDdKujbJODzNVbK8vrxFbV726dHiaTqtpuR5uARq7hfM7mGbw76YWqU7+xoehNgKkB3EhK5ASIws2UL9zAoHC3Isigi7Dyh6snk8zZBUElFbR646vpwuSOD+GfYOKw+cb+/vEOEbeTuTUQM4E9EQ4JORhNWHcwjNbYg/KDvuKqYfPO0tZfQB6YA3bItEZd8ID/4QeIk6iD/gJFdqL0Z3GV79V8RaHwdowDJEBwx8SRHngMYMEs14ZIYEmF3GALU39uQ9pUGBtYAvK1HyJ0/VityWwZzRCyVC/KK1CXN11d2OvDcZrdNFh+FPrbz7unUgu+Qyky47gzMByLCV/jLEJFGZk2hFTcXMxB9mOGCZ32Cf9m4tXzbyZyBlf5qjkL2dGAkypP6FXZhVivVYOJ1rrPmFw1Ie5JvhRkd4HBNQRbU7ACrJFdY7k4We4baMTlQlXA3Ky+KiDUkjjIgG6D3rG+IC3/gPqeGLsrs0yJUiSo
 vvir0XiP
 vmU3tp5Dv8K48/csxqTtUjYLLHaC6ZOr51JSkpDA5lU7xkgyoUiluxT+YIlXsueQeOgxr7kunRsz5JVX5XI+tnn72CCbEZSrLI/joH70scfNDczhGNjW2glbVqcZWcU3ZAFfEPi3Mn6pEF9ibHDodrnL3OheuKTJHS9n85OQlL+69kJk+2XlXsgOT5zUTyt01SUybUi/rorGniIJxfE99QVKdyclblJeJ+kaM3Ive8YvFdJiz6o/lKOFFhxQCCtv5Ak+j7+LXgXaa6ZhwT+epIEvpTTvzKuETrEBJh/+u2/IevtRlb0Z/XOuzQHUVLvhvLMvpmmF7yEM6wXBTt7Df22lbaZybtE8pHt+9ouCPcenS5cu0WyWarjdHEWRczM7ITtUkLwKu9jHtmJAppHczPofgLFNALwdIIjKQQqkYu7hAFyD2PBJA7G4UMXc4HA78znb0NRgCUcuMC8iBqTELjlmO6wnIu5+iy9T3epni0rMcMyoUiLN4yGCI4UFS55PnbaG/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While the numeric constants for relocations are architecture specific,
it is still useful to get access to them from other architectures.
Also the definitions are useful for userspace in general.
For example tools processing elf files during a kernel cross-compilation
can make use of them.

Introduce a dedicated header for them, similar to the elf-em.h header.
For now the header is empty but it will be filled step by step in
upcomming commits.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/elf-r.h | 5 +++++
 include/uapi/linux/elf.h   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
new file mode 100644
index 0000000000000000000000000000000000000000..2c382c8a4807f394a3ccabf39a81e9e9b6f7ea45
--- /dev/null
+++ b/include/uapi/linux/elf-r.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_ELF_R_H
+#define _UAPI_LINUX_ELF_R_H
+
+#endif /* _UAPI_LINUX_ELF_R_H */
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de2bfcfca3c25a52c8b8cd51a01c12..3d18543d5460a757f0578afe5d487233ffaa3c57 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
+#include <linux/elf-r.h>
 
 /* 32-bit ELF base types. */
 typedef __u32	Elf32_Addr;

-- 
2.50.1



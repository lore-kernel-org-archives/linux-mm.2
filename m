Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95156C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2238A6B008C; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C706B009B; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B796B008C; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9EED6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FA40403D7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:52 +0000 (UTC)
X-FDA: 85189629504.28.850DAEB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7609540007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ebIbHeLL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=5Q9BAPxI;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIZqQqreoVp4jL5VDlYmXNMQM5O5p/caA2tuy/ziotc=;
	b=3H4CD+Hb3gL6Z9RqLbz5NEwJwVHQuLR6jS0+x88sVNsiUjjJB/J7MGR+glAZAa2ndRuNYj
	zqC9dtSyQwVFtwM/QLUfeKf7cgMK25b5IyXzw76RRAHOV40L3GhIld6Q3gA4Zc1Jr/APif
	6YFPRdoHWtrnXJnjvYnAeY+PF2XYhcM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ebIbHeLL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=5Q9BAPxI;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849230;
	b=28NsuP3rWjLx+o60z+jP7U+66bJPl3Hi6RJELt0zqYqRNuncp1bPvMzr1fY3iG/+896SaE
	yVMUu6kd0EtpAr1NQXWdSaXyI2uXFAkXKlYfWftCl6L40Raq4OPC56ABOInBX6MmTy6/WF
	zRe7UM0qCRh4SZZswUel7GMRjELFAnM=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIZqQqreoVp4jL5VDlYmXNMQM5O5p/caA2tuy/ziotc=;
	b=ebIbHeLLhulPxU96t2LRMg4s4x5K/xNe3iO4CR8LKAIdJ9kYfTc3MXtWBz/fXjFkEU9kMr
	ld8JvPU+EAtF9gbFrTW6gwQHl+2Bclu/F+5tk06gWU+u8YSLGy6Fs+b+dl+oT7u7R+QUlz
	bCl15HE1EVvXEl60ida0PtVa2R2PD9q2BdCLGN1ph/WmXkFBIb+v2gs8Mz4niWS3c+WFNF
	s5L1oWts84MWkE5GzZSbShoQTqSPfKHvYz1OJVecgZ9cSrkKKIh7FoerX+WoXxVwtFF+8f
	hg7jFr8a/amVt5iCyOzW9R3BnRUIfT7WfuRnMScYGrUMlh6kWYjJybJPngonVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIZqQqreoVp4jL5VDlYmXNMQM5O5p/caA2tuy/ziotc=;
	b=5Q9BAPxIl6FXv9Um3lg8pwJD6tKmF767tMf3YrqRNLIA3fzOdbqDAtSMZ58ddEqhSk+iSa
	SWIkWgAern8ootAQ==
Date: Tue, 08 Sep 2026 08:33:35 +0200
Subject: [PATCH v5 01/24] elf, uapi: Add a header for relocation constants
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-1-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=1348;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=BNQHFvTY0jFJrlhn6+RVLpYSgcHasImekBzIK9bpThE=;
 b=ncJJdfJzUputRN+485gg2paJ/pNXo1aFgMnfr2+Vvf39fIyuFgtJ0VGn6HbawU4QQNwNU2xhl
 vPCs3Fdp7LyAWOKAaDyvzvlu+8V715tn72jQFoXKC+X5TMsa0Xr4m74
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rc1k16i3besfsngotye4t9wqr6h17aes
X-Rspamd-Queue-Id: 7609540007
X-HE-Tag: 1788849230-336431
X-HE-Meta: U2FsdGVkX1+fX0yxlh0Tv7hsu5mGFPlMhh6Zhl7OKwvHRuD5iSE/hWSfEaBoVmmERPBLm68W9ikHiMQl690/m1WIVerh1NrLBZo8XveM9FxhtFzyoIgT32i0LK1ddU70ZTzH9F/mfE7mJpkEOHAKnSZzEgNJqhw9uRSPkaurjM0Rl37N9ZiNZUjY5rEQzEiMskT3ppZzoByII5BD0YlLRmnwNrYQobH0S0qJVtq5Ff3x/bk0/ZEJLBCVssYjGElwgxanAcVUOO2Y0fXP5MJa153skEzLKPuShFSmCuCCZlZFovA3Yedmw0bk8ZGWfKQNVasMAtg8R8XLJ8YpKn5zUURVHYqm8W+zNI4cLVMQxBZDdWZucZB+4ECQdkaRDKIUOiuGe+t+8b9h0fdF5vCvVmz3DtvsZtnJYirdNcWRxv9D/+6NbCVVR19WgyuO3dGmawMwE33PYqYIQIANCIyhUz7L598cnMyc94y1UML7p9qhpbpqi79UEInvDsZlEpTh+5/1IUS3pYxej6jXWmEzN1X/CHAFEFE7ql26OCIdyB7oAsi+LURygPO8niGirMIDXKhgTfKQjbIIUdUWkwiB3U/65KYc+KUIVtt1isyyZVDnsdQEDVvxYHMeJM7WG0uY/b7/WiJH2x5ogXgM1KzSGb8xWgHTyPg/RMkvzAp3ABWzJCbZqIwQ3rD1R3ldv3tUJXX8FF5Tu/zO63XPMYfpEJOAbdXK6fc4trr+A99vXIrVyu18IdARatsgvrnvA5mN1jJ4mMwOuvbu6Rl1WkyYMKRfkjnoVRvxL9ywmvmfhhKzjkFK4GFh8ojk/l/GK8LdgvsEL9BD535GNMKdYuRECvLtlHbb9HNJhmcR0400fNX3l/2zU7ugnfE6rRXT7K2hkfe5F9BeNOzfLRj07Cpy2DOzZvy1hXlGgxqc/XJwOva3XJFvXa3K3kDMGd3Br73Jk4lFbc87S4i5jVB6oNc
 WXLc6VyP
 Cah6KEpXJzOl5ZVLINNfWrwM+5PR0ULmVRh1xLSh7Qj9mHOHV/l7FsPzjDNHKPv0RhsREs4wQ8aHjvKnZHyAHZt96v4zTbVwAa/49z12EBezaukDy2wLmd7xKMsptteuwxQ5KdpPWUK+oi0d4Lruv8XlEBYrgYQMz3R4u+5wKzy6PL2+4f/KjxogsgpC4g61l6nRu9dza4C+SjAWdIvJZX+x7r3jfPrixF0KNdcnaoflCkgpSNgRULTyxLse3i5hiNkoFMMGLCWiQmkpKOJ/22iTfEuk+RCmwG7uiIj3xCjYEQBnTgAfR4LVcICfeSzhjvD8sTOEgQ0guoB7/8eKAxVFei8hOZR+iOGFelGxNf6lfMo/KISgp23r7+NRHR8EfWUXy1s9BD7S5VA2qP4S63ySijGdHsQXBqkV+Z8qASNECaRUWHLV8k8bJvYeL4E5pcdD8HSvueL7e9OtUvrXKane0xot24uLPMCtk/7WYxr5/CpUHC2l773CbGpq8pejoA9/Kq2gpNYp25Drt9NznCYMmetMZYgMM4XYcOoB0zlHBYN0=
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
index 000000000000..2c382c8a4807
--- /dev/null
+++ b/include/uapi/linux/elf-r.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_ELF_R_H
+#define _UAPI_LINUX_ELF_R_H
+
+#endif /* _UAPI_LINUX_ELF_R_H */
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ee30dcd80901..b3e312255552 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
+#include <linux/elf-r.h>
 
 /* 32-bit ELF base types. */
 typedef __u32	Elf32_Addr;

-- 
2.55.0



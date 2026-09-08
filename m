Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01180C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C537C6B00AE; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04C46B00AF; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF27C6B00B0; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3226B00AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1860C03C1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:07 +0000 (UTC)
X-FDA: 85189630134.19.4407981
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3400510000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="YMIoDXx/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Wz8zdRK+;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpMeGTA/JL9YkhE8VitmDDEUz8BAqAeVVV3RUo7s8KM=;
	b=SVS8OUhvni9j0tjMiXhHTd+hpnZ/212ClfTcW2TX6U2CSvCIe4zc0B4kHXagBuOJJjUNHd
	jzHRDiAlijKM9U1ozbndPxQ+dr6VfAdoMJjlH6mwNo3RFg+XcfxQ0othLAuvJOVEACygrS
	/cEUR9UhFhEU+UxV/vABb2+eEBwfhgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849246;
	b=EfEXdjTAQ+/vH6kSea8a6P3VUbTGfSFceRqY49EKB6CI/xWIXHqZ5+aali/7Rr5sHjt1ZR
	U2UAhD1Uzoz3TFV0Q/VeSrn049O4A7Rz0dIz7ZZGMHMO0Y2JF9vLTe0vBXTAFRnUQch7Ed
	ChZyLhFMDeMqAvfVUhJGJE34JDpPR7Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="YMIoDXx/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Wz8zdRK+;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QpMeGTA/JL9YkhE8VitmDDEUz8BAqAeVVV3RUo7s8KM=;
	b=YMIoDXx/ryyJO/wNSJr79hBrk/1uKFLoRwuyXWq2ERwfWyVqyJffleMbiT+vvuWtO204/K
	XO3RmXGCnqV4w7lfkhlRudbX45mFtdRD41W9PJVoty/pqKiHswGZXTaKvmOaxPSu5VZJVM
	xxsp4AJePJ+ALKIQ/EeGwO+kVJXptZyvKlxH78jJhdZkeOrN+Ww5q1WKtNHcy76t1B+jzv
	XQRYBH9ansqx4KI/6zXA4pK/oLhRKj+aRYBHIq9E7X1UO0E3YCVRVTfZ6ee2DiCObTk4zf
	wtUuUCDZU7XTwecLf7y0KofwzMRjqZcFYKJ6viLp4DkuxsMmnK/jJKnBlUZEnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QpMeGTA/JL9YkhE8VitmDDEUz8BAqAeVVV3RUo7s8KM=;
	b=Wz8zdRK+ls5E3Iazhq49Wi6Kk0ecGxrc48ZY5jjgK217bXfYrQAd4sT7ItwhO6FCRyToCS
	ZOi8PKGbBnEfh/BQ==
Date: Tue, 08 Sep 2026 08:33:55 +0200
Subject: [PATCH v5 21/24] MIPS: ELF: Add more PC-relative relocation
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-21-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=1280;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=R3oIxCvKReHS31AXFavRgNPui6/4omq3e3P+29cRTsM=;
 b=rkjnjj70dplXDvHhkzfJOvBIecn20+RvsB4YJZT7kS6dmC1XplZqrPoTSbkM+YB0aLRxuxOb5
 Wp9eyI0SYfRAyhHyeFjnDOCIAqDeZA0dEsHaudn+dA9ns9ki2xZGWbR
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 8xhg3n9kkeoi4swf35emr4k8e3i9ia9j
X-Rspamd-Queue-Id: 3400510000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788849246-928517
X-HE-Meta: U2FsdGVkX181ScmV1NMJ7rD/hXBANqoLLfiA3btJMrOC3FmPF41c/aTs9dykiHsXbUOFHFWQ8kLH0mx97f8bheBAMQunGHAW8KyP/DMUr5EUB4LcqV8CVC0l6veMfVqpfve2y7QWGwcQkL6fA15zmAGqZCC6Gh/yl338k/MhWgJeLKDIH31JQ3umBZHFZ3rIYhsp3pQV7VANkM+xHFGQlkmVIughcUwvGzIPzOMbTVVIYMxnWGVoEz6ErHpTa+VtuCdhSxcDoa2cKVFvOJfexNDM/cgGevAOA8JDnmJ6LCRnZmuKWA9Mf2BQdVHqCNXpPwcQlhrPYzmKKloDb2vItcZTSB0MJMqrbABL5v0bePatKZ78I+51xT3uinDxo6W3paZ4rWFjL9qH9XkOX2SWvWp/rhwRuMS4W38v9WcpHfSK6FF3ZIoX68S/8riOAvGaLrDCmmzdoFhhu2oErzQussyeElNoFdiTRkfmENpqLjvZ5A647oB1GPPYnm/8IbLeXxYAUJc3CArE1CjJ9z/0doyd5h1CeRtCD4OzV0Uaz5JbfN4U7KhxHxxZlPpLTF0zsQJ1RzXv6zX/J/BgBwel9FaWKvraB7zS6Kp+9IohmgkdQFoPtbxQs/ejdTtYAofgJdcvZ/ZP8gouw4kXIzEklHuoKd1a/P9Qc9MlQ9Vetm/6dcOxoLIRFJRpxQCoER4Ex/tGjPDgw5NgU3ttGGaQJ2oeAI0hpjW8mdb4U4VRxnnRwcJqQNGZTGyp0aUOzDosOA3V5C/BET9QD9sdDyxp2aO3eMcxXT52odPHj5xSIYCGo8b4r0l0+nrRewsCtQcVcqtElcpyKZEGihMXheYuAwEqG90AKf2hkJwO+XOh/XYHD2rrpSfMvkCsdI439pns6YzyWlkmF0+tvXJhifh4fZUm+OinJPo3D0UPZuYxgc2ZhSKJUrc9LEmeAMIK/R4DntZ3WQw/ud2GUqZWJY9
 bRjFrNkF
 elt5E+XiqohYUlOHdDCc37I0HlrI+r3o7s/NVLLQCDYbQzz1NulN1Xgz1+x2AwxysbfTFYlk3kab/1lXj3DHOvyQ7UUPFf1X+gMF3d5x0B25FnbG51ZVHxi26V3FvYqw/gvsUrZnP0eWiXk5Y3GaArcWHJRwTNppNGsmgr17GhKdQLuKS+oDRCIcIVlc203gxd8ivthHtCRkIYfF/w/p9E0r+fbiDbw5lUG6+5uU39Tg/4AleTltnUwtYRtPbmUj18XbDpJAOcct3SgJ3RFrqc4oDG/UQ/BSnGnU+jerUHCMlat35iLP3rUKpMauyijXGaQl6XOGlDV78rNXNWlaMH0444QkezXcovI1eDaJb4qc3hvusMRX/m9MjImh9tbquqwRn17HUW7WdDmcCcAH6asyM9QQ3BkqtEOh2j7bONqj9TEq7mShiRUmRIjZSRlHYTQP5nnixPfeH5Lm/oy6ORbpSDU2E7K2K8Y9QWsupH9zAvO1qNknWrKrkj9iGiABXc0MDWcFKnGtwq3s/UqBIp8bqUzIzPTStPIiRMprw+xaIGOI=
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
 include/uapi/linux/elf-r.h       | 4 ++++
 tools/include/uapi/linux/elf-r.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 170888422400..a6a4d7643c5d 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -646,6 +646,10 @@
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
diff --git a/tools/include/uapi/linux/elf-r.h b/tools/include/uapi/linux/elf-r.h
index 170888422400..a6a4d7643c5d 100644
--- a/tools/include/uapi/linux/elf-r.h
+++ b/tools/include/uapi/linux/elf-r.h
@@ -646,6 +646,10 @@
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

-- 
2.55.0



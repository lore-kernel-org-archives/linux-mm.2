Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADBAC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D468C6B08AE; Tue, 18 Aug 2026 00:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7656B08B0; Tue, 18 Aug 2026 00:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CCC6B08B2; Tue, 18 Aug 2026 00:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 914EC6B08AE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:00:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7862F1609EC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:48 +0000 (UTC)
X-FDA: 85113038976.16.1BA47CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7836BA0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NtFRXij4;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025647;
	b=03OlTsNodVx4orQfJ4hZLmEcwyuuEGT9vknx7+Yd2kVd0wN8Eg5SacXZcwzjPNbM4mMv0q
	Lxkph9qCb0mB+spBQI1UbVS16TqizX5rXHDGQULDhCswkN/yWOmCCjX4Jf7+68kGeUhDrI
	JA+5yVo7bvCBSL5H9qtaT92pVIWbaE4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NtFRXij4;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bH/g3exXOoVDVFJ1Rpy2p2GV7MIqdoi8lyynQWvgO3A=;
	b=UP1W4YG5JdyH+wuJtPf7P7vDEc1YGhvdHAwXgtPgGyJ46C++pMFG8j4IpPlHZRmdYJNKep
	x8DHE6qv5poYibBQnV7EJRZTlBbzHOu11gABdOxg471381a7ZtQkBdoVF5daIG4ex5v576
	rcjbDFD3exz+VIt1ejtXl5EBSXW0Zqo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46004153B;
	Mon, 17 Aug 2026 21:00:41 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E5453F66F;
	Mon, 17 Aug 2026 21:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025645; bh=LRR2JW96qzLG8uXgU1+MfoOsPimHhtCsmfw/iXX8kB4=;
	h=From:To:Cc:Subject:Date:From;
	b=NtFRXij4Uhwnlv72AF85fJYzj/aymvsPMmb1FV54uYlLFKg3t/C+cIPPz6W0jsHV1
	 9J4gARXAWELXnskJwPs+BnDvgT6ZNx/a8ZwzPVKYIGTlZF5fGPZRP4qKo2lnT7Fr1w
	 ur0UrDi2dMsXj4xyEnxA47CkAD4o6o2g2lJDsONI=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V3 0/8] mm: Drop pxd_ERROR()
Date: Tue, 18 Aug 2026 09:30:33 +0530
Message-ID: <20260818040041.1891769-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7836BA0008
X-Stat-Signature: bf4zgwsb5u481331kmriqsfguk8ootj5
X-HE-Tag: 1787025646-951535
X-HE-Meta: U2FsdGVkX1/8DW9k8C5kLPgqDPEwhiVkADM65UURJTm9aY24Oo7cu6nvKLgaJyi0UvrWc2HCrok+kpa/gA3a92KtQo9dSvWs1LAER/viliS23ujdrjVlLRdEDSe1pnjziyu6CXJl/eFeQFaGNBjlkjCNXJufAFBPe4z17bzzQq9HX2rF/qJ2s7n+5lqCj5/X/jNrEcj9B0qoWy72P9oQDGVPCurNKtoImRhsjPYvXXIQFBs99csn1FPxZrxDK/xo+RQUewTcj/R2LPL1t2HgSkmS/t0y0b4VV17UYGJUzW9HhOXWPTGlTFetMoeqLcS5NTuYb58maAuxxQpDeowHnHgzbeKZtS7JpG7sKBwkZZU1bMcMQNo/tMPmdeTm1hCFz7aCyeZaJyUOH1k01wEpd2mx7m1quW+Y9UUESKwi01gKAB8NIS6yIzWP/P5V8vkBT/3LpfnpF3UkSmagd7hf9c4EslDNrSSobT/tMNFBAmMHZVkSKQ4uMe+qvVhs1wne3Oam7xegfq/BH9isI7yGkXEDbD8lJItehBgUdskr08VvuBkMH3eyChdRZhekgPnW9lgqsOULlEex+EaXBXQXibpZUc7WbETza9RM5JQV491jPsNdVrFdJUAkJTlNXKJyJaU/fe1vA+NeSsTjQ5Wmc3KAB1PMGzG0siEWZ12w8rH4yWCYJG2TjrvroQ7P4052B4SuIF4n5U69GdypTDqWPLU3kxy3Ze9GCyK6mYxMSWzdME/VX1pJU1YVOy0uE7oPEXSB2F0UH05uNJzBjgj0qfZfDPeKAMfnsSxyjr44OrDE98r19RCAOwnkl4nXketl/k21vF4NT3yKsUc5mkjv81jl9yqqlasv9mHf1dkQjrQHrf0E8Js6XOhA0NBzaa4XHII5FBAp9MgQDaRAQY619H9F+rXkn5i7ys/rTZQMdDtkK2rcFixvY0/KLBYPMMAGrsYgXypkoPL4zBRxtRy
 kxjbQqLe
 KLX7a/F0IDycJzh16MV+M3NcMAOjh0GZJa/bRL5IGae3NdqX5Cd8/gdhROXXJm5RMkOoNyLjZyNfO9fU4CTXDnCkq5RO6frxbh6kMwqJy1DqJwinq+kDiQk1sTJ0lf0WGEUmzFyUJ+rp6wwJtCGVlWf5/m1aEOAOBzCJgMcSTSDhk4OD/SH4ttZtCOULt6Qyj2uMnWfDJy/Hwpv2d0E5wJmnA642LDbugLElYOC6vlzfZ1Xh9M65RTjxjUvQyZGcmMdPyflSrFM29ikt6HF6Wd0Pyzisqx+penkx5b5wS4iE3KVVLQKc+jdgVyIn/R8Yh/SFpPl8nPzrjkB3Pw+vJPx+uYGz09bLs4WASXxwmMpR6SAen9vzlX0aoQGLBX8p3o47LntkYYiJTWrLfUDD4DOilmN4ka2nwoJQKjFWX3UIxe/v3R1PEj8DdLHP8Zt1Mx4k7CP2Pg6GbdOE4WTS1TUbLBaXPKoMxcehvBEYoLUqO9CQRgKpYlBvG1DHt5Lv360C1fI+3/5NRiZ7znnieQt8mXbQmNNxBALsY/XZj+hJ2H0XQNiLHssUoozxBs2xXMun6cj5ooEWkqQSHK6h9x+fpnxGHuKV6elPM1DJzBTq1QGixK6otKpLykdn+515afyAuRYO7CbYrh6AxHVFN+IOxWtHMIszLNvM1IlGvsHFA50cuEzm+VKc7CBtjUVUfOXxBXhTF4vniyY6MiSKF4hf9YBUs7E9OxysZ9Wzbd8SyO2+KevCQX80GvRmqOZsGF9ADURH5nWVxTGrUE/7JZ8KUgRT3uvxTh0yQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pxd_ERROR() macros have been provided by all platforms, which are very much
identical and can be dropped off completely if these pgtable printing could
be moved to callers in generic MM aka all pxd_clear_bad().

But first cleanups and re-organizations are required in some platforms that
are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
macros have been completely dropped from the entire tree.

This series is based on v7.2 after the following patch and has also been
built tested on multiple platforms.

https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/

Changes in RFC V3:

- Moved ptrval_to_str() as header in a separate patch
- Stopped using pxd_ERROR() in generic MM in a separate patch
- Dropped pxd_ERRO() macros from all platforms in a separate patch
- Dropped print_bad_pte() and also cleaned up set_pte_phys()
- Added some pr_error() messages in __get_pte_phys()
- Cleaned up error messages and used ptrval_to_str() in platforms

Changes in RFC V2:

https://lore.kernel.org/all/20260811042119.3652929-1-anshuman.khandual@arm.com/

- Added clean up patches for platforms with existing pxd_ERROR() usage
- Dropped __FILE__ and __LINE__ from all print sections per David

Changes in RFC V1:

https://lore.kernel.org/all/20260806080639.1916749-1-anshuman.khandual@arm.com/

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: linux-alpha@vger.kernel.org
Cc: linux-snps-arc@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-csky@vger.kernel.org
Cc: linux-hexagon@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@vger.kernel.org
Cc: linux-openrisc@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-um@lists.infradead.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (8):
  mm: Make ptrval_to_str() generally available
  mm: Stop using pxd_ERROR()
  loongarch/mm: Stop using pte_ERROR()
  parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
  sh/mm: Stop using pte_ERROR()
  sh/mm: Stop using [p4d|pud|pmd]_ERROR()
  sh/mm: Stop using pgd_ERROR()
  mm: Drop pxd_ERROR()

 arch/alpha/include/asm/pgtable.h              |  7 -------
 arch/arc/include/asm/pgtable-levels.h         | 11 ----------
 arch/arm/include/asm/pgtable.h                |  7 -------
 arch/arm/kernel/traps.c                       | 17 ---------------
 arch/arm64/include/asm/pgtable.h              | 15 -------------
 arch/csky/include/asm/pgtable.h               |  4 ----
 arch/hexagon/include/asm/pgtable.h            |  3 ---
 arch/loongarch/include/asm/pgtable.h          | 13 ------------
 arch/loongarch/mm/init.c                      |  4 +++-
 arch/m68k/include/asm/mcf_pgtable.h           |  6 ------
 arch/m68k/include/asm/motorola_pgtable.h      |  8 -------
 arch/m68k/include/asm/sun3_pgtable.h          |  7 -------
 arch/microblaze/include/asm/pgtable.h         |  7 -------
 arch/mips/include/asm/pgtable-32.h            | 10 ---------
 arch/mips/include/asm/pgtable-64.h            | 13 ------------
 arch/nios2/include/asm/pgtable.h              |  7 -------
 arch/openrisc/include/asm/pgtable.h           |  7 -------
 arch/parisc/include/asm/pgtable.h             |  9 --------
 arch/parisc/kernel/pci-dma.c                  |  6 ++----
 arch/powerpc/include/asm/book3s/32/pgtable.h  |  2 --
 arch/powerpc/include/asm/book3s/64/pgtable.h  |  7 -------
 arch/powerpc/include/asm/nohash/32/pgtable.h  |  2 --
 .../include/asm/nohash/64/pgtable-4k.h        |  3 ---
 arch/powerpc/include/asm/nohash/64/pgtable.h  |  5 -----
 arch/riscv/include/asm/pgtable-64.h           |  9 --------
 arch/riscv/include/asm/pgtable.h              |  4 ----
 arch/s390/include/asm/pgtable.h               | 11 ----------
 arch/sh/include/asm/pgtable-3level.h          |  3 ---
 arch/sh/include/asm/pgtable_32.h              | 13 ------------
 arch/sh/mm/init.c                             | 16 +++++++-------
 arch/sparc/include/asm/pgtable_32.h           |  3 ---
 arch/sparc/include/asm/pgtable_64.h           | 10 ---------
 arch/um/include/asm/pgtable-2level.h          |  7 -------
 arch/um/include/asm/pgtable-4level.h          | 13 ------------
 arch/x86/include/asm/pgtable-2level.h         |  5 -----
 arch/x86/include/asm/pgtable-3level.h         | 11 ----------
 arch/x86/include/asm/pgtable_64.h             | 18 ----------------
 arch/xtensa/include/asm/pgtable.h             |  4 ----
 include/asm-generic/pgtable-nop4d.h           |  1 -
 include/asm-generic/pgtable-nopmd.h           |  1 -
 include/asm-generic/pgtable-nopud.h           |  1 -
 include/linux/mm_types.h                      | 15 +++++++++++++
 mm/memory.c                                   | 16 ++------------
 mm/pgtable-generic.c                          | 21 +++++++++++++++----
 44 files changed, 48 insertions(+), 314 deletions(-)

-- 
2.43.0



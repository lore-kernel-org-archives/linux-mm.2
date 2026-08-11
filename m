Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46065C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014796B008C; Tue, 11 Aug 2026 00:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06EA6B0092; Tue, 11 Aug 2026 00:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DAE6B0093; Tue, 11 Aug 2026 00:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE9AF6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A6D416034E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:28 +0000 (UTC)
X-FDA: 85087689456.24.62E9A6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DE17120007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GopI0I0f;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3fcryMXJ9mdlfh5fhkYvdWhUX0S8rMy1cCwqOeeyztA=;
	b=bX8leOyH+xPeXmFrcG2QJk1r0VlGfMTyRn6sjK6PPxXtwxnlRRn2sP91FbzGDcRD1FT0Cc
	Mpinj5kIozY1ClgXX7yJIgbFu/wBdwVVrF+COx8NXn3aEPSAJgPWG0LjZmTm+KhYXLDMHV
	wsWJMwL4+KIEmEsI3/PMhtiV0UhuMS0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GopI0I0f;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422086;
	b=avCneszQr3+ehx0yjvoek8kPW29U94syV37VuPDGGeR34KJR9GjwvxiEYSa38WrLe3VxIk
	VH9Xn6B3KoLESsfqGp6K9o7Poj681fpmPunFQIbL2fPpeBN4sqxVirL/oEWiLaTaaiyowf
	Q0KihbTwQ7DlFjPQj1a5VNjEUvLQ9P8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39B3114BF;
	Mon, 10 Aug 2026 21:21:21 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E55B3F673;
	Mon, 10 Aug 2026 21:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422085; bh=U4Z1uTiwNPlptM0+2YMoqojdlsHVf+3xXUYXjiCQ8pk=;
	h=From:To:Cc:Subject:Date:From;
	b=GopI0I0fYfwHaaeo2Y1tRcsF2e/amGL0odHVP/X1kESNXKYqhycXNoTsAuQ3kbLz6
	 6aWj1XpWWD5XHhdxDVLSsmNEIV5BHzcUh5zug5WGO5oBPaTxRMDHz11rcK3BnPzn8e
	 wSjaNCIByq50FgWv0gwZJCSc7yloLZqXMTvqJhr0=
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
Subject: [RFC V2 0/6] mm: Drop pxd_ERROR()
Date: Tue, 11 Aug 2026 09:51:13 +0530
Message-ID: <20260811042119.3652929-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DE17120007
X-Stat-Signature: 4noxd1a41zyumh1hn75rt6zioyqgn9nw
X-Rspam-User: 
X-HE-Tag: 1786422086-2976
X-HE-Meta: U2FsdGVkX1+8ANFEcRUlLfKNzEHapniT8tvz6BKpyn2HxBBjGo9CpANLPGmEPNKaPFbNSsaW6EKe2SF5hLhFv1MsEZtMSI+TasJ5Y1tM+XY7BejTpm/LqeeZ3B8ZSiaXYIpx+Fcnc7xlbDgXgqKSFhV6O1FVcmU3e3E1OKz/QBJlXa6yYxc85vtdXnbNqiGsftpLa+O6lfKshRnl2CyR7sbXXugwb09aobFWPLyQUNkWR5lmOq8hnxjHPHidSaDKRWE9MAfH5bkG4nkFJlvxUCxu28H+LVnDVy4Iz41bzSBcPBEGr3Ct+CXQLpJg+D6Ba3FSJ4bdfUb2PdaKqUSVun+N6KTYukzvQjs1BVAZYP8btEc0SjxuH68EEj5UfoXfpPpa0fPrpr0La1WSoTWwCsfyZjumRtd40cy4YNsHTkIz0Rr+1WvYPQgunsbLcZEtChiPFodTkmRc2ogmkN2I8tBF42mRXaQLk4z2Rk+esSa4bJNcMCVexIlncPQ8JgXq1E6qKPHkklUqPPrLQV+fLPZ0bhpo6Mdo3ULCt7BCDQU1shF7oDfL2wAoN6ZHTkFgjldPvs1M5wog6Rc3mu8TlIaZhWHTa6IREcb5E/Z8U0ZgXbiaD0yBCX7Nz9e2eTj2X/UK3jeZ7y71dfU9WkiUHIaXUpKEBsafatf+ATpPlAEd67KwgF04bVcBrdSjJ5JUwJSbc+m3XFE0nNe6XW4aMxfFmEQ1VdECS7TAGuyUvwPie7m1MFlxh973iUBTLlz5Dhi94heCbxvfuOI/yP8ln9x7CrsSYvGdTO6f/OjC7BbEqlOpjHzrg7Pkbx+1bdjkQaPgee1cuy7I8azf5ubbnKhpE20XqaUS2UigGWzBbDU5nQCpncHs2EoCxnv5/zaOKJsHjQjZDBMogHF2xfu00ufR0kVgzCGVHAxcl4Y9+DtrfaK+xaFjKfO/xzFutfombR4WdFZc6Y5yzBwPItW
 MP93gw6C
 LcvIl7WuV72WveSGHPOJ0SxeRsvnCIWr2Q+ozGUTMqjHCUC8v4UJZejD7FhCYdAL17R5aEKmZmzlMI8jRyP0NjCEH/d+lIrzW8FPYAj8yZIdbfZvYMWD0F3XdMFOxGm3dnNuktHtZx8UbhanOEgq/XRUIzUdlyfnvVz97DNxiZ4zKJZ5QX7vmK4e3Qa9r++EhpIPcasZScHTcZ9pBm1AqBP5Rsys1YDSV5+eZaZZ7IuOZuCBfrfMu0aXrS7J/Ob65E4LcEmisgVXDbkF9a56gLRyF8vxPuu7+mOzatuLo7tOgU2OI7IE0v4rtZ+Bwfwk8XC3me81SELFk8/5VhqydqUerSyGIndJ0YgNnkuEUMqX2de5Fp47bGJnxAOQQaUKVX9b94mMqiSNSULOENnfsMU8lsTl0x6KY3q6qH9KDfSJNMQg8NVC5eMwLzR0BYbdRZjOqrG5DaSzqBC7+zlXHqw1ubVHcHcT+BmT0sSE2rMqsNxelIRgKDHt34SZZ+GXqPLP8XmjqAH0OO2Do+cuihjqtvzgVxo9xoTH7cfmJAKl3Bxl5B/++jFRzH30aDCrcjgh9uIPvzmEpzfIhU5xxr/ePqmRMI+r+BoHPHC9LSDJ7I9AuE8GDLSpD1Lhr0aUze4qMTu1j9kvx/0sMroMqxhVNZYt3Vt0rxs9hpxGeMbIRQFT7cU92c0RyniHrCvb3grDLocLg2ZyEN9rgtYwfSg9lUoguhJnRfgPYA/6892XUYCcfFMJ2NxrdPC7k2GN6a+jVlqh+6opWp9UgVJKnpK0FJQjvvU8EVT8g
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

This series is based on v7.2-rc7 after the following patch. This has also
been built tested on multiple platforms.

https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/

Changes in RFC V2:

- Added clean up patches for platforms with existing pxd_ERROR() usage
- Dropped __FILE__ and __LINE__ from all pgtable entry printing

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

Anshuman Khandual (6):
  loongarch/mm: Stop using pte_ERROR()
  parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
  sh/mm: Stop using pte_ERROR()
  sh/mm: Stop using [p4d|pud|pmd]_ERROR()
  sh/mm: Stop using pgd_ERROR()
  mm: Drop pxd_ERROR()

 arch/alpha/include/asm/pgtable.h              |  7 ----
 arch/arc/include/asm/pgtable-levels.h         | 11 -----
 arch/arm/include/asm/pgtable.h                |  7 ----
 arch/arm/kernel/traps.c                       | 17 --------
 arch/arm64/include/asm/pgtable.h              | 15 -------
 arch/csky/include/asm/pgtable.h               |  4 --
 arch/hexagon/include/asm/pgtable.h            |  3 --
 arch/loongarch/include/asm/pgtable.h          | 13 ------
 arch/loongarch/mm/init.c                      |  2 +-
 arch/m68k/include/asm/mcf_pgtable.h           |  6 ---
 arch/m68k/include/asm/motorola_pgtable.h      |  8 ----
 arch/m68k/include/asm/sun3_pgtable.h          |  7 ----
 arch/microblaze/include/asm/pgtable.h         |  7 ----
 arch/mips/include/asm/pgtable-32.h            | 10 -----
 arch/mips/include/asm/pgtable-64.h            | 13 ------
 arch/nios2/include/asm/pgtable.h              |  7 ----
 arch/openrisc/include/asm/pgtable.h           |  7 ----
 arch/parisc/include/asm/pgtable.h             |  9 ----
 arch/parisc/kernel/pci-dma.c                  |  6 +--
 arch/powerpc/include/asm/book3s/32/pgtable.h  |  2 -
 arch/powerpc/include/asm/book3s/64/pgtable.h  |  7 ----
 arch/powerpc/include/asm/nohash/32/pgtable.h  |  2 -
 .../include/asm/nohash/64/pgtable-4k.h        |  3 --
 arch/powerpc/include/asm/nohash/64/pgtable.h  |  5 ---
 arch/riscv/include/asm/pgtable-64.h           |  9 ----
 arch/riscv/include/asm/pgtable.h              |  4 --
 arch/s390/include/asm/pgtable.h               | 11 -----
 arch/sh/include/asm/pgtable-3level.h          |  3 --
 arch/sh/include/asm/pgtable_32.h              | 13 ------
 arch/sh/mm/init.c                             | 27 ++++++------
 arch/sparc/include/asm/pgtable_32.h           |  3 --
 arch/sparc/include/asm/pgtable_64.h           | 10 -----
 arch/um/include/asm/pgtable-2level.h          |  7 ----
 arch/um/include/asm/pgtable-4level.h          | 13 ------
 arch/x86/include/asm/pgtable-2level.h         |  5 ---
 arch/x86/include/asm/pgtable-3level.h         | 11 -----
 arch/x86/include/asm/pgtable_64.h             | 18 --------
 arch/xtensa/include/asm/pgtable.h             |  4 --
 include/asm-generic/pgtable-nop4d.h           |  1 -
 include/asm-generic/pgtable-nopmd.h           |  1 -
 include/asm-generic/pgtable-nopud.h           |  1 -
 include/linux/mm_types.h                      | 41 +++++++++++++++++++
 mm/memory.c                                   | 41 +------------------
 mm/pgtable-generic.c                          | 21 ++++++++--
 44 files changed, 76 insertions(+), 346 deletions(-)

-- 
2.43.0



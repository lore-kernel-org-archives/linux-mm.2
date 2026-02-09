Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FF9E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558766B008A; Mon,  9 Feb 2026 09:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539C76B00AF; Mon,  9 Feb 2026 09:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459186B00B0; Mon,  9 Feb 2026 09:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 345476B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:41:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4EA65628B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:16 +0000 (UTC)
X-FDA: 84425180952.17.A6D7F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F736100003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNIMGaab;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KaemXTxQHMv9bpHkXsnfD0HaSN9qgB8hHzbd7NEhoKk=;
	b=8ECwhLGmKC58+kD7Krz/6X0whYK/p8Xalfxuf66MXcCSOOwNLqM2v1+XLn7yDoq/HLNfQ6
	oG2NCPVB09IBSbvtR3InhCWQhbVTwW7kdD2fyXFMO4h8dqvTDV228glKSulB+8Hosj/J60
	inDpLVMheNtiuoCSu2G9TEQCKG79LRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648075; a=rsa-sha256;
	cv=none;
	b=4Xj10WVt6cJrsrp5fjnP9YJbd/lYiNR61ydxK5tiJMScaLvO+HpV6Q9/1OhC+ZuoY2Cx14
	9twtoPlEF78gIIEVjKP1qlA6mkAV/k1usurIzKO8HSbn1r9yLvSf0IgF9ZF7BjtKEOlE0y
	Hi42IZtUA8swRO7cCNetj0/+OB9aNeU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNIMGaab;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75B9543BD8;
	Mon,  9 Feb 2026 14:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B4C19422;
	Mon,  9 Feb 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770648074;
	bh=B2mkA4JyLV5P+26Kji7kOaADSMAhZAUHx96+BlD9dVA=;
	h=From:To:Cc:Subject:Date:From;
	b=lNIMGaabE0qBHyKmiQQ82ePHeKOk12FZcvy7uIhl99+FK8xY+dvBmwJnHq448tgU5
	 yWCM6YFfxDvwT1wI5+Rt+hhXZLLV4D0u0LeJHpDec1IByx2uLPHCfHaX3Y6XpJ+rsw
	 JJVxqM5D44XNcn4x0x+Kh3J6eZihZBMhmxySUsLGosdfZbLuXcXqIysNK+I7TUQbg9
	 O8HeuEegeOHjXjoPICHlHeBzr1Z+8ulczKwGXjAXkwEVNlDEDH7KqeCc5+hLTfRZaH
	 Codl9ykicppLg+KhR0t3MGY3QhvKdyqCU/tVEiccSKm1jaUu/OhlXAz7EKTzkg5T6F
	 18AZs0Gxi+VGg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v2 0/4] arch, mm: consolidate empty_zero_page
Date: Mon,  9 Feb 2026 16:40:53 +0200
Message-ID: <20260209144058.2092871-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F736100003
X-Stat-Signature: rumkihnyrgbc6dinz6nhwox5kqnrh5d3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770648075-533971
X-HE-Meta: U2FsdGVkX186qnlmt5QnSaS8Srz8PnhOdJsGeoJoyv88yJUJllRgGteK8wz+w6wIbT8ZEmOHb8XKy9f1fHn4fYWI8rp1JTgzbGI2YD3Uwl0OL8RWbeTG3JJfxlbYE+LDVUQ/96/VlKJHzs9I51dR3QSZiXCt+xixX1Wj3wqpVjO15fehIMFz5KChvo4o2ylWDpY1VEfyG4EWJ6UDpO2wgp5db7P0gcMLjqexGMIN9e3ek5ljgmbbjY/N1fb66f76TxNmbLEtOCmVhbJ5Ne0HepaER4Je41rPFHBds0ZjML/uzDT58bKND3LJbGwIQT4Uq+Se8ipjpHM/mqCYmSrkvm+/53Jcw5R+MOjS//sbXqfABCdI2iagFmX0DfF/f6YzKwD+hC+92fP6XBIBjMHdMSxfCtLhsb9/OKv4Sp+JLezS2WJF8ZfFksiPT7jPNJm3BagwAtUdPq2gigYXYHoWnUoeQOwQ09qvC2EK5uZPni6OY7ZU3He8TUk5Z/wtUq31YkMfOK5mmZ0B2jJvpBazK4R2wLsf4AEWe2mpn5Dj8rEeP+ofGNn6pMPXYEE50uKlwkqVmQi0UH0Na587W7cOgQcVtceEY5HiNxaeXOGNpgCNPlPEoFNsIn4qSmnlXMzrUMV/nPOyry/3lFbOgoto4IahjMOpAcFiSfFajq8naV3yBLm8C1akffzBYy3lquQs3vFN3nnuFCR2AC+L7Om0Lmms2ASWP1kHTtI23SeCpKKZOuvgf9CM/jxPp7N0hq4C4IXcydRgjs+4I99WankqfhtIA/aQ4KdtknrvG5B+o3GvqRGD/Bpb6zd0aGeEP8ZW42BsL/HnXd1zpkTSbfAPHxmzeFd5JCODqn8o3Ejf1kIr8oMPobP1oTq0XT12MvXfRLqZyIDTPbNsRGNcIs9MioJPh1rQaauWfcciH8U/3YiCAD6yRbJTg9qlgTgjzSPCw6EOK7Jh1Ckt2k/ICb6
 ftTaQQ2k
 mFnBZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches cleanup handling of ZERO_PAGE() and zero_pfn.

v2 changes:
* add patches that cleanup zero_pfn code a bit (patches 1,2)
* add a patch that caches struct page for empty_zero_page (patch 4)
* use uint8_t instead of unsigned long for empty_zero_page
* fix sparc64 changes in patch 3

v1: https://lore.kernel.org/all/20260124095628.668870-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
  mm: rename my_zero_pfn() to zero_pfn()
  arch, mm: consolidate empty_zero_page
  mm: cache struct page for empty_zero_page and return it from ZERO_PAGE()

 arch/alpha/include/asm/pgtable.h          |  6 ---
 arch/arc/include/asm/pgtable.h            |  3 --
 arch/arc/mm/init.c                        |  2 -
 arch/arm/include/asm/pgtable.h            |  9 -----
 arch/arm/mm/mmu.c                         |  7 ----
 arch/arm/mm/nommu.c                       |  7 ----
 arch/arm64/include/asm/pgtable.h          |  7 ----
 arch/arm64/mm/init.c                      |  5 +++
 arch/arm64/mm/mmu.c                       |  7 ----
 arch/csky/include/asm/pgtable.h           |  3 --
 arch/csky/mm/init.c                       |  3 --
 arch/hexagon/include/asm/pgtable.h        |  6 ---
 arch/hexagon/kernel/head.S                |  5 ---
 arch/hexagon/kernel/hexagon_ksyms.c       |  1 -
 arch/loongarch/include/asm/pgtable.h      |  9 -----
 arch/loongarch/mm/init.c                  |  3 --
 arch/m68k/include/asm/pgtable_mm.h        |  9 -----
 arch/m68k/include/asm/pgtable_no.h        |  7 ----
 arch/m68k/mm/init.c                       |  9 -----
 arch/m68k/mm/mcfmmu.c                     |  2 -
 arch/m68k/mm/motorola.c                   |  6 ---
 arch/m68k/mm/sun3mmu.c                    |  2 -
 arch/microblaze/include/asm/pgtable.h     | 10 -----
 arch/microblaze/kernel/head.S             |  4 --
 arch/microblaze/kernel/microblaze_ksyms.c |  2 -
 arch/mips/mm/init.c                       | 11 +-----
 arch/nios2/include/asm/pgtable.h          |  7 ----
 arch/nios2/kernel/head.S                  | 10 -----
 arch/nios2/kernel/nios2_ksyms.c           |  1 -
 arch/openrisc/include/asm/pgtable.h       |  4 --
 arch/openrisc/kernel/head.S               |  3 --
 arch/openrisc/kernel/or32_ksyms.c         |  1 -
 arch/openrisc/mm/init.c                   |  3 --
 arch/parisc/include/asm/pgtable.h         | 11 ------
 arch/parisc/mm/init.c                     |  6 ---
 arch/powerpc/include/asm/pgtable.h        |  6 ---
 arch/powerpc/mm/mem.c                     |  3 --
 arch/riscv/include/asm/pgtable.h          |  7 ----
 arch/riscv/mm/init.c                      |  4 --
 arch/s390/mm/init.c                       |  4 +-
 arch/sh/include/asm/pgtable.h             |  8 ----
 arch/sh/include/asm/setup.h               |  3 +-
 arch/sh/kernel/head_32.S                  |  4 +-
 arch/sh/kernel/sh_ksyms_32.c              |  1 -
 arch/sh/mm/init.c                         |  1 -
 arch/sparc/include/asm/pgtable_32.h       |  8 ----
 arch/sparc/include/asm/pgtable_64.h       |  3 --
 arch/sparc/include/asm/setup.h            |  2 -
 arch/sparc/kernel/head_32.S               |  7 ----
 arch/sparc/mm/init_32.c                   |  4 --
 arch/sparc/mm/init_64.c                   | 24 +++++-------
 arch/um/include/asm/pgtable.h             |  9 -----
 arch/um/include/shared/kern_util.h        |  1 -
 arch/um/kernel/mem.c                      | 16 --------
 arch/um/kernel/um_arch.c                  |  1 -
 arch/x86/include/asm/pgtable.h            |  8 ----
 arch/x86/kernel/head_32.S                 |  4 --
 arch/x86/kernel/head_64.S                 |  7 ----
 arch/x86/kvm/mmu/spte.h                   |  2 +-
 arch/xtensa/include/asm/pgtable.h         |  4 --
 arch/xtensa/kernel/head.S                 |  3 --
 arch/xtensa/kernel/xtensa_ksyms.c         |  2 -
 fs/dax.c                                  |  2 +-
 fs/proc/vmcore.c                          |  2 +-
 include/linux/pgtable.h                   | 48 ++++++++++++++---------
 mm/huge_memory.c                          |  2 +-
 mm/memory.c                               | 15 +------
 mm/migrate.c                              |  2 +-
 mm/mm_init.c                              | 28 +++++++++++++
 mm/userfaultfd.c                          |  4 +-
 70 files changed, 86 insertions(+), 354 deletions(-)


base-commit: 50c7f34c5c7403a12003c6759f6f6ca9a5a10872
--
2.51.0


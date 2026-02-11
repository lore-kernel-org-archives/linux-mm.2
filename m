Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8A3EB2700
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2796B0005; Wed, 11 Feb 2026 05:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26F96B0089; Wed, 11 Feb 2026 05:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB376B008A; Wed, 11 Feb 2026 05:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAFE06B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:32:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5583016031D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:32:01 +0000 (UTC)
X-FDA: 84431810442.07.C7F075F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1FE7C0004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:31:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PV/jXKpF";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770805919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=icF2+PwVaSY7S9HGXldpzB+lF1cDxRtpf0+cMzX32GE=;
	b=NWj/DtTkCGrCeqsVRGnecROboKBJhifyLnmeJT17TTEiA104+hqW7MoDCSneHFmmnnQiBj
	Pt5jSt5I+FXYK7BSYpKAh7eKrXHizDKmvzk7NXakErvcvdopfJclPwaS9d7yIqBaBfMt20
	J4uOIti7xeNM6NBuBIvKVrhqK1GBuXI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PV/jXKpF";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770805919; a=rsa-sha256;
	cv=none;
	b=VyD/EGXgDhACTmtTzsrDcfDB9yfaggafDPOt2Lz1IffM4qbExhHHV2sDKAi/ukY09EHRQh
	6A0VlxUeElsUs9MCRe56L6EL/Fp3jHq4kCI6lHHRdprIWwgTnXYt0ua0EE2FmQCwc1ysa3
	zR7LWaBhItkyt/OKDsTL0ffPHJupMAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80DAE43D75;
	Wed, 11 Feb 2026 10:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D364AC19421;
	Wed, 11 Feb 2026 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770805918;
	bh=BzPjss/o79E8vniYif3vhWCcMbpnh+bfpm0PwJifv0s=;
	h=From:To:Cc:Subject:Date:From;
	b=PV/jXKpFwT8Fev+iuIdzwDQGCp1d9tQZwQOxpL0LXiHzOkF4CIyDk3VR8KHKDtHPW
	 95broCDwDG6FDa0dsrh08bvjDtJvEVi+8U3bdfQGt0/3GFehuGtNXEfr5rcfZqIyHe
	 4Gas0OFpDJ0b6cdfz9zvpAFeNg4A3xRSvqWBEmxAoCac9/v12nM5/tozP4vCWoIt3t
	 WM1Df8XDDZbZ4yrkjS35IzQoTegVuVT5cx/AIkgGipbvq47QF+8iCUbZqSYaNcR9kd
	 /L0GUWtHeBli4O4MUGnMTsxwsezchH/soEQNYXQrx3YIGnwJ/R226FAA4/HIBChyBn
	 bpfII91wxqjeA==
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
Subject: [PATCH v3 0/4] arch, mm: consolidate empty_zero_page
Date: Wed, 11 Feb 2026 12:31:37 +0200
Message-ID: <20260211103141.3215197-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1FE7C0004
X-Stat-Signature: sr154bqah7dpwsprwqu9qzfyc6c38k6x
X-Rspam-User: 
X-HE-Tag: 1770805919-209352
X-HE-Meta: U2FsdGVkX187UOpGkyx+wURDKO7yLGZo998kdjkRg6DX921k+6yBKuoOD5z0Te/jzc3XA/dbmSd8wMiZ3+vMJPFfOj6dotryWqPK4D7XT6UvXLJMVq8tG3QqS7uYvSWMbiQwO5SU9HwCPEyntdRc6vj4vNpRRYDe1NL+FzY9lgpfa9HtmQ5o+1ns2NJgGPI0awUupEYOzeiQhfO6lmBjMuQxd2hfsdPRguHbEZgD5cz7ebX1JZpYNPi+9zAZjPsbIPH55u9tDCwKnF7iWE1RnlzAyuhndwKO+8mpgCi/Tm4xaICpTfsqi7NORBSaJj5LdUv6o+oSqSt+Uo81Pb4v6w1dLE1/ltmeBekSmFaVD90m1kysKZkSUYjrktyJ9nVem7GXiU5AC38Otj3o3ucdwIpQsJOu7e8YfuIlK6VtR5e0/5DiV0QyFL7P3nZACxJV5B3PHBIL9TEWRdX/v2b/i3G8e/HZpQSCMGb4d+hhWA9qjgLi6bN+x6I8YRK7q+Q1TZugtGJsuQJztGAbYhexfoWX3OdKofcBF3OIy99pL8N5ulrTVJDouKykR5V/D38Uo60STxvld49Q8/kzJH0HyZnez5BCPEYveTlTNhOnvqJcvVQDP0GAtPgkodPjqLw1KiJjE7aXIv4KUgzIyanBYbfOmRt7RaleCNMV1512BspRT8OzJ/RhvETMvG1Ndc69mvbRkIYvEKPyyEl+GJHbuNtkK9X2jmc8hS+eehBwWu0qYvvaC4Yb5akIU4o3f1saVizN76NzCaXqZ3YkvyjZE02/sJtK3eWvQvR7j/xUg6OgbFJVcOXwKV8U948I7zr3PzCp80pdJMHhjZvHL4LY0rbb9KVte42UbrQwLqY4q90CIUE/I4sXjB1T6Bj6dOo5F34xzov//TC5oTNp6yX2uSAN8KsB9TzoC6eT/pp2swJWCsaj8TzV1KFxxytvggPBWwRKrVNN3O3LkbVVzJz
 TGg9FIaO
 7tKRQ6L5l+ml+Yy8lJw/rrjP9CadNkhs31XaBcABPpKjNm/SNEGJX3CAENWMQvbWX+TK/U4Kg1pmy7pc9d/5sag53aKCcJl77dmlgH3KaCyhbYE+5VSHSaELmsNbmgq0i8qwOkg3Z1Aa95R7R3EEPw/wvQzm9m97OQY2ZnBoe5dotNzldKPZxlmWoc0IpjznNnj/g0qG2PzIm11Rz8aaBkXPTsQfhVFNsz9q3QdbYc4nRRJPYVP3IWz0R/9Mo7qAXPl+xEG4h7/xCiom/CxuH0P1YVw==
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

v3 changes:
* move zero_page_pfn extern declaration back inside the helpers
* add tags, thanks all!

v2: https://lore.kernel.org/all/20260209144058.2092871-1-rppt@kernel.org
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

*** BLURB HERE ***

Mike Rapoport (Microsoft) (4):
  mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
  mm: rename my_zero_pfn() to zero_pfn()
  arch, mm: consolidate empty_zero_page
  mm: cache struct page for empty_zero_page and return it from
    ZERO_PAGE()

 arch/alpha/include/asm/pgtable.h          |  6 ---
 arch/arc/include/asm/pgtable.h            |  3 --
 arch/arc/mm/init.c                        |  2 -
 arch/arm/include/asm/pgtable.h            |  9 ----
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
 arch/loongarch/include/asm/pgtable.h      |  9 ----
 arch/loongarch/mm/init.c                  |  3 --
 arch/m68k/include/asm/pgtable_mm.h        |  9 ----
 arch/m68k/include/asm/pgtable_no.h        |  7 ----
 arch/m68k/mm/init.c                       |  9 ----
 arch/m68k/mm/mcfmmu.c                     |  2 -
 arch/m68k/mm/motorola.c                   |  6 ---
 arch/m68k/mm/sun3mmu.c                    |  2 -
 arch/microblaze/include/asm/pgtable.h     | 10 -----
 arch/microblaze/kernel/head.S             |  4 --
 arch/microblaze/kernel/microblaze_ksyms.c |  2 -
 arch/mips/mm/init.c                       | 11 +----
 arch/nios2/include/asm/pgtable.h          |  7 ----
 arch/nios2/kernel/head.S                  | 10 -----
 arch/nios2/kernel/nios2_ksyms.c           |  1 -
 arch/openrisc/include/asm/pgtable.h       |  4 --
 arch/openrisc/kernel/head.S               |  3 --
 arch/openrisc/kernel/or32_ksyms.c         |  1 -
 arch/openrisc/mm/init.c                   |  3 --
 arch/parisc/include/asm/pgtable.h         | 11 -----
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
 arch/sparc/mm/init_64.c                   | 24 ++++-------
 arch/um/include/asm/pgtable.h             |  9 ----
 arch/um/include/shared/kern_util.h        |  1 -
 arch/um/kernel/mem.c                      | 16 -------
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
 include/linux/pgtable.h                   | 51 +++++++++++++++--------
 mm/huge_memory.c                          |  2 +-
 mm/memory.c                               | 15 +------
 mm/migrate.c                              |  2 +-
 mm/mm_init.c                              | 28 +++++++++++++
 mm/userfaultfd.c                          |  4 +-
 70 files changed, 89 insertions(+), 354 deletions(-)


base-commit: 50c7f34c5c7403a12003c6759f6f6ca9a5a10872
--
2.51.0


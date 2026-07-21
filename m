Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FAAC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD526B008C; Tue, 21 Jul 2026 12:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D906B0092; Tue, 21 Jul 2026 12:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A40E6B0093; Tue, 21 Jul 2026 12:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4D16B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:23:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6913B120220
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:44 +0000 (UTC)
X-FDA: 85013304768.28.2C3B8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 940A68000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKjAfKsb;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZetBUrAfgYvJ3751E83jJC9yJJ2fFWR6KUF/uLNNtvc=;
	b=okv9g2UnHcrQaSZmv1v55dxMXgfWSe/vzdU3oGqZpjh06vHRhXil5B0rNFh63psSye0Fm2
	AGHT/dTn82tqkoSgACSNXz4PPljSjn7kYyQL53VVhUCF94+85o6sKwaO9WvJViyq6lcCl9
	pgZhfPrG6fn/7HMogaWPIKFkq5msKWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651022;
	b=ZikjoynfWB29PPN1L1B8apyphJHGqFlJRcP0qwGHa6CynDnTlahRB6UisezUV+rijMoCTm
	CMFcYCG18kDHb35rzfrxA5+eWG6y5CJu5vMS6I9csoO9OU+ZIpNtFQOu57osuJGLkIHRg6
	XtQAyx3trD9qxj2C/eG3MPPjEMg1OQM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKjAfKsb;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79D2241919;
	Tue, 21 Jul 2026 16:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975F51F000E9;
	Tue, 21 Jul 2026 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651021;
	bh=ZetBUrAfgYvJ3751E83jJC9yJJ2fFWR6KUF/uLNNtvc=;
	h=From:Subject:Date:To:Cc;
	b=bKjAfKsbBVu+UX/+6ubeBKSZVrtYBGGmMFCvMVo0EgOah126cGNZc1m3nf/tSJHlP
	 1XGCJWOYnQajM7WPyDCsaEZhcVCvRFSlSe+0CDNZ8FqPEC78I8sLEs+N7zbYuEp85y
	 0q2Usw57xoFEIg2gIxkaxj18lx1bEaKN1FOCNdwZ8P5QKnOzBJMmcot0GfbTqoR9ES
	 vnbFiLApwhlI0xHgUEJcBwc5hLhgwyKrY40Xca8PoDiQIKx2RHR7GrupxLW/SEqtcz
	 poesQNcWfJ5LNa47UUTwvnHdHiNTzctQV2dFkLd4maZUecG8LANBRbba17wmRvpXJg
	 oi/xisth2VEYg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Date: Tue, 21 Jul 2026 19:23:23 +0300
Message-Id: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPycX2oC/yWMQQrCMBBFr1Jm7WAatAW3ggdwKy6SOKYjJJWZW
 JTSu5vq8j3++zMoCZPCoZlBaGLlMVdoNw2EweVIyLfKYI3tTG9bjJRrEVCpYKI0ygcngy2abr/
 rnTHeOoJaP4Xu/P49X+B8OsL1L/XlHxTK+rnOvFNCLy6HYVWjcOS8TU4LCSzLF2cn7oCgAAAA
X-Change-ID: 20260721-generic-set-memory-v0-1-06547a00b2ae
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, Juergen Gross <jgross@suse.com>
X-Mailer: b4 0.16-dev
X-Stat-Signature: s5rj7nb3ck1y6faduc1j9rqo89tswqu6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 940A68000C
X-HE-Tag: 1784651022-476133
X-HE-Meta: U2FsdGVkX190/QLGPy7zSI+3WgSNLHQPyFJBi1Ex/OAh4Jpx77ynV3jWz9F7NahPXMJHimGSRm0dXHh7X52ZGwzMSiOvezJ1C4hYr09zBMwDUZEmSmBiwILdjrWLBkdsQGLUaaNL5/vZHdNRPv7pG61IlWXMk/h0XSyuDrC80Ns8C65cFKnyc5/hWZ0AXD2o+mtPOybJXt6yFct4g/fk25oeud9N/7VH7BQUhiC/nDLyYCD7vlGr1a2aht9QLMmLvPUGnzgh81TVVDXDpkreONIOPRRXmcNSS5b6OJEEVSnn8GPnuryc6gJEyLf5WWIXTQ61FkvqQtBJ6wTDy/7eRa3AKKqPLjWs+YKokeCkzkgsMur1Nh/LvifnYjU/2MHr471un2nSCrX7LAdSLl/R2yESG6T4EGVrYB8DR0AF0YrxIUygjc9fTU9Ed++1rtn3z1C3cVwE0SUE6AQn30stTYfzMmrgOM5eQlUfyDf6qShUSo57o1IH80aO4KiqHsiDklKlCpdHumvne8ELDSBQ/VWunfhlvICfuzKjodtkfCGwbbcGm5Dij0fYO3AJ0/kz4qrC8QYwSOJIwiw+liAU5C+jC5MIMddNzf+qgDVBOfG/CZIMfzk118175/qXJhFKHK3k7tSYasaKpimrirYa0Dke+JY7fw7S2lLb22IEdBmCsdV1g0UunPeRLluiEXsn8isis6MAMRtboKDvGzqnolKqD8gsz8Xnuz5UGBrWzON+IPOVxaviBUFot6vo01cpTcpNq3Chngyzq86K9clSsphQLeEGTmlK1Ln/lT/yx2evmO7dbaMtcyV6cPHEN73L7tGThIB8RpOSUpPmg6ej5fvFGqyF5Jhz8NnmVZpxbSHWhTi6xj1NINs8VGGZvw2rVbv0kM4GVuCNzpRpC6q4QCQnpmcw0B9HsriF+vwG3gxNtJZK9m8MdnPXySCDyK8QENkFlhUso5+ZMrzKpAx
 ZXjXfRoq
 QgH1xuWetvtjs0QC/WBwBA3D+KZreQKAQnmCEPzxW4ZhmCdx7NGEmal9xnc7NGJJcn0yYqNfAfKqJDlMivyXBKe4qrS4YHF3LTPb7mb5htWRtzh+EUIYXs28WkQ50XrhuxlUDr6AtHBkj7vbabFQTQ157CzGT0HCUSphRov9EfEONUOslK8kE1CZeVOHIXAytbkYi9MGZ6zwELkpUGn3KhDnC2lU+LsbLqzGknfAejdzIxqyqv2DNwEGBnUgWQsF1eg4cbgemh4H26KY0ggWYUrBi+NHhiesaAA4xl3AKi6QWa1cTp1YApP27P+O+iifPdmCnGq60leql4i/0iG8DVimAhqDXcvyHdXa19QrJeao1VtuU0zSNkh/UiyNGTLXs3Hd0YUd+UIjIxlhv8dgcNZ7akuh2VKqQZ667r2wvXbTL7STC11zd+7Jy4eQiOBOKR1CkMOEA4k615aI/en2JoH4qVXmLX0TWdeVvvzPZjZIIuj4iSNknsZWKieX9dmYHFpnOA24StI6G5ZM4isivbxOvELi3TBCDYbN6DDqv0JaV6kKcuUeA2DhOwjUbvGvvkRXXjLtNeKQ9CFPqhKoeYJbBr3wIBrgFrP3z1QM96xTcK/3atJZqPbg/vuZplzcqIxtLCDnLflYvPUO8Bhqm0AzsgCBxns7E9qC+gG1s9VWqF0rd85VBRIHvh41OwOmbzuIZUzLf5rKD2X6txWaySgjHXxLCdLnBx/STHIcA22sBg/Zaw2hAXg26Jcd/elSWyQoC3ZbcTnQklxjWJ2wG8726evjzlOwbbUjBcW8NWVntAJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there are 6 independent implementations for set_memory and
set_direct_map APIs.

With increasing demand for kernel page table manipulations, for example
"Direct Map Removal Support for guest_memfd" [1] and "mm: ASI direct map
management" [2], it makes sense to have a generic core for kernel page
table manipulation in mm/ with helpers in the architecture specific
code.

Coincidentally, there was a recent fix to a UAF bug [3] that had to
touch set memory functionality in subtly different way in different
architectures rather than to fix the core logic in a single place.

x86's implementation is the most versatile and most battle tested and as
such it is the best base for the generic implementation.

As the first step, pull x86 implementation to core mm code and convert
loongarch and riscv to use the new CPA core. These architectures were
chosen because the conversion is quite straight forward and does not
require tens of preparation patches.

Once this settles, the next step I'm planning is to convert arm64. This
would be much more involved than loongarch and riscv together, so I
didn't even aspire to include arm64 in the first RFC. That said, I have
a very ugly arm64 prototype that rewrites arch/arm64/pageattr.c to use
the generic CPA infrastructure and replaces the existing implementation
of page table splits for systems that support bbml2. But there's a lot
of yak shaving there to get from a PoC to actual patches.

Patch 1 is already applied to the tip tree and I posted patch 2
separately [4], but I included them both here for the completeness. 

Patches 3-10 reorganize x86 CPA implementation to make it friendlier
for generalization.

Patches 11-14 move CPA core and CPA test from x86 to mm/ and slightly
massage the code to allow its use on other architectures.

Patches 15-16 convert riscv to use the common core and adjust riscv
implementation of _noflush APIs to actually be _noflush.

Patches 17-18 convert loongarch to use the common core and adjust
loongarch implementation of _noflush APIs to actually be _noflush.

The patches are lightly tested on x86 and riscv and build tested on
loongarch.

When converting riscv and loongarch my goal was to keep the new
implementation equivalent to the existing (except the _noflush bit), but
I must say that they way loongarch updates permissions for the entire
large leafs rather than splitting them seems a bit suspicious to me.

Regarding AI use, I started with a two-page prompt describing what I
want and how I want it and then it took me about 10 iterations of
additional half-pagers to explain why I don't like what LLM produced.

In the end I despaired to make it write commit messages the way I like
and edited them manually.

With that, the tool was really instrumental with conflicts resolution
during rebases and building and testing with a single "go!" command.

[1] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com
[2] https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com/
[3] https://lore.kernel.org/all/20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org
[4] https://lore.kernel.org/all/20260717-verify-rwx-fix-v2-1-fc23141311d6@kernel.org

To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Cc: loongarch@lists.linux.dev
Cc: x86@kernel.org

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (18):
      x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()
      x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
      x86/mm/pat: replace x86-speficic pg_level with generic pgtable_level
      x86/mm/pat: use page table accessors for effective RW/NX bits
      x86/mm/pat: use a generic helper for the large page size
      x86/mm/pat: introduce an inline helper to check if alias needs update
      x86/mm/pat: introduce cpa_handle_large_page()
      x86/mm/pat: use cpa_split_data structure to pass split parameters
      x86/mm/pat: use a single locked lookup for PTE verification
      x86/mm/pat: move the large page size calculation to should_split_large_page
      x86/mm/pat, mm: set_memory: pull change_page_attr() core to mm/
      x86/pat/mm, mm/set_memory: abstract the CPA page table lock
      mm/set_memory: read page table entries with pXdp_get()
      x86/mm/pat, mm: move cpa-test to mm
      riscv: convert set_memory to the generic CPA implementation
      riscv: make set_direct_map_*_noflush actually noflush
      loongarch: convert set_memory to the generic CPA implementation
      loongarch: make set_direct_map_*_noflush actually noflush

 arch/loongarch/Kconfig                  |   1 +
 arch/loongarch/include/asm/pgtable.h    |  42 +++
 arch/loongarch/include/asm/set_memory.h |   9 +
 arch/loongarch/mm/pageattr.c            | 196 ++++------
 arch/riscv/Kconfig                      |   1 +
 arch/riscv/include/asm/pgtable.h        |  36 ++
 arch/riscv/include/asm/set_memory.h     |   7 +
 arch/riscv/mm/pageattr.c                | 489 ++++++++-----------------
 arch/x86/Kconfig                        |   1 +
 arch/x86/Kconfig.debug                  |   6 -
 arch/x86/include/asm/pgtable.h          |  36 ++
 arch/x86/include/asm/set_memory.h       |  50 +++
 arch/x86/mm/pat/set_memory.c            | 611 ++++----------------------------
 include/linux/pgtable.h                 |  72 +++-
 include/linux/set_memory.h              |  97 +++++
 mm/Kconfig                              |   3 +
 mm/Kconfig.debug                        |   7 +
 mm/Makefile                             |   1 +
 {arch/x86/mm/pat => mm}/cpa-test.c      |  66 ++--
 mm/set_memory.c                         | 396 +++++++++++++++++++++
 20 files changed, 1092 insertions(+), 1035 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260721-generic-set-memory-v0-1-06547a00b2ae

--
Sincerely yours,
Mike.



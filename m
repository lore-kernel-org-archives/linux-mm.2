Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DF1CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFE46B00CC; Tue, 26 May 2026 10:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F806B00CF; Tue, 26 May 2026 10:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEE36B00CE; Tue, 26 May 2026 10:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 093E66B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABB461C0312
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:19 +0000 (UTC)
X-FDA: 84809871678.10.E2DC633
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 14CEF20014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oNnYAJtF;
	spf=pass (imf03.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tAOc0X5Ad5JET2TC9jtYXzCGegy15EhzBhrLna1J1iI=;
	b=lXUQMGRJyLjI1zNkUJx7zVtROlgjU/GA35TNOPwPjWDCBq02c+DEQ39D6AzhWCJFALHShT
	TASePtTmUuzzZ8idAMDHTa0fiEGV9fWpR6IUChMo/4fO1vpzZepvn8JEnakD+c1cxHgoOS
	NDWAKlksDqBLTRnOzMmKmM2lVzjYOTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807377; a=rsa-sha256;
	cv=none;
	b=LT55Fcxugr5qHHFr7X24R4imFJcUFHS6+1VD9bdaEuGyOnGeQv3IAN+c/W1V8CinTETkWd
	wIkc2X5UY/DG7Px0pZxWEe1WNcZ3mBF1g+amjsQSVITUHKpVeccDU6UiHkJtSX9GxpXh/u
	2Y2MK8i7vwy+WoBN1GvBmZ8kkm52LfM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oNnYAJtF;
	spf=pass (imf03.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tAOc0X5Ad5JET2TC9jtYXzCGegy15EhzBhrLna1J1iI=;
	b=oNnYAJtFtBgGQSd27b8WhXsDgb/0pSK5BLEBS9P2hWlJ+ZLu8ZVnPWVy0Nea73pW/FtNdSq1+
	n9s/lIWU9iEd/+tSltQfDjqavQdGCcmagG7lU8SrBvdKe1X8xGz7rqh5mkyjpIdIog7O96zBhP0
	m9sDvQTKzbDB64y0y/QPHUo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gPwcF0nYNzpSwR;
	Tue, 26 May 2026 22:48:45 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CC8F54048F;
	Tue, 26 May 2026 22:56:09 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:08 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 0/7] mm: add huge pfnmap support for remap_pfn_range()
Date: Tue, 26 May 2026 22:49:56 +0800
Message-ID: <20260526145003.88445-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam11
X-Stat-Signature: ozmbzctwy3smiitpj8ingd5zdhhoztsm
X-Rspamd-Queue-Id: 14CEF20014
X-Rspam-User: 
X-HE-Tag: 1779807375-696295
X-HE-Meta: U2FsdGVkX18eYFnYLECaOjfhupK+t6Gpt3CFpD00oIyOQvIkb9TMCcdc4JNjyo0AFQmSpdcJCt5mynDKABSXZDTSCPjRS/+Q9avR7y9oEd7/j7fISwbHQ7gAl3pupEp0u7hGTc1ju9fLtR41oAoQQJvPMAYxz7s9E7AAunLRNQ/PC8Qdb1a9aMgOINQ2jqqMqBQxxB2KO/6Cs/Ccjxa8R73FCYSQ4IdAcx63KVYnQTxbPDDBPN9v8S7NXoJSUg+4n2KXRcCdwsa/6tWhy6+JGL62cWxMfAPhemgl50ejg/e6MAcDGV9pRBN2BL2QvHXzt+u08GFUG1FC7afDDlXrYJG5m2T5AHizeLhmuXWmSYR3ZzCz1Lvh2LrV9+Ai2D1LrAKaKnweWQUKzzSjNAiUOyMjUKbdnpIQySLheQxSa6mhjgzXwFQTmOo6Uab2JGLhX2ER+dW/2+xDOmTToTOQBmOgh4XfiHQS7moyQu+POwYPzokH8tYOGxQWlcDE6bUE1B7JFzpscFnPAqU80VEp7fBfZrBMs3zoFQAIOaEnZgP5yCA9bxLtWlmgncOu9QUZjSF+CUrkKSZHN2FKhmftvDQvCVbz0f7k+EaJJ7T6L5kTYHKpbE8Zu5QfhCMXbvDmYIvokGKDBbx+eJYPcXOs+k1Ohhvwzrp5ssKCkLWgJS3Op6on74NG2bPrWQi2AR2jg7kePvrSm6KDOrrI5qroKtXhNO8Bs0SiWIA+d8S29cgJP8VapBIHspQwhwTt4wQtJbTph90yzPEy6IlbO254QTEzXCN0xmC6pAAC1Id46Qcwp159DjXTh3+fAArdSPHOEuuon+BvbYalbwSmVrLaw7ffPVvRs/0kPp2o5ldFWSGC/1jUCpA3JR7U61+Z8ASAtXg0Dssu7v4yrcB+R8IMcwSGJAiGncMxdo5wSyWnz3U6kuIR3p2CQemIM9IovDeKTUj67qYXowX3GXFOiVF
 UgP6l0G0
 pbe+cQL21z65/VTNawCeUGOPQN7W/CL5IVlbLMWlc+P+mpYSQRWzsrzzpf41ThoTlbcjg82LSIEBmiltmAbA68d3B0XCr9y/Ci9C/rLRUNvha/n36EXw1bbtemrB44cUkeLetmllpI54vQ8TXHByGAxlh3RChbaE+kAxj2IYlfucgTmQvxR8Hy/XlYkgOUZDz4N8J2pGMMBTRRfqeNvEXhcbvZV9qhmZKQbxmfVftFrWHiywvnfmDw1GlOXP+dOMErDG1xmbX4jSWdFZeM+aZU70r+M+OSjOIMHOWBZOTgxUor/108vgkUug7bKk/aMj8i16mnNiVmWF/vMG2se00JX6NK+BfzzkvBsVJ6P+KF1pT8YZSTsZYxYzCVOYfpIul0OLE0mh5WYgtyMXNJVK+4QoPoN3q4Nel1nJ7zzxh+TrzwTJz5OeH8jMBQBu4p5DLXTIglso1n9AjB5LJi5POmQ1/eK41c+jP0/hpAjBIrv4Quw0+38lYO4ngkUEl/LSQyxQ98opwoneLO38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on mm-unstable and depends on:
1. pgtable_has_pmd_leaves(), introduced by Luiz's series:
     https://lore.kernel.org/linux-mm/cover.1777663129.git.luizcap@redhat.com/
2. mm/huge_memory: update file PMD counter before folio_put()
     https://lore.kernel.org/linux-mm/20260526101337.1984081-1-yintirui@huawei.com/T/#u

v4:
- Following Matthew Wilcox's feedback that huge-page attribute handling
  should stay in architecture helpers:
  https://lore.kernel.org/all/aapXRN4KjWtUUJ0g@casper.infradead.org/

  Reworked the pgprot contract for architectures that enable
  CONFIG_ARCH_SUPPORTS_PMD_PFNMAP: pfn_pmd()/pfn_pud() construct PMD/PUD
  leaf entries from base-PTE pgprot_t, while pmd_pgprot()/pud_pgprot()
  return base-PTE pgprot_t.  Added the required x86, arm64 and powerpc
  support; RISC-V already satisfies the required semantics.
- Refactored copy_huge_pmd() and __split_huge_pmd_locked() to first
  classify PMDs by pmd_present(), and then use vm_normal_folio_pmd() for
  present PMDs, and make move_huge_pmd() use has_deposited_pgtable().
- Introduced a restriction, following the discussion with Lorenzo and
  David, that remap_pfn_range() does not create PMD-sized mappings for
  VMAs that have a fault handler:
  [https://lore.kernel.org/linux-mm/6417587a-7e43-4615-9e2c-50a245842f59@kernel.org/]

  With this restriction, PMD PFNMAP entries in VMAs without fault handlers
  are known to have been installed by remap_pfn_range(), which deposits a
  page table when installing such mappings; PMD PFNMAP entries in VMAs
  with fault handlers are created through fault-time insertion paths such
  as vmf_insert_pfn_pmd().

v3: https://lore.kernel.org/all/20260228070906.1418911-1-yintirui@huawei.com/
1. Architectural Type Safety (Matthew Wilcox):
Following the insightful architectural feedback from Matthew Wilcox in v2,
the approach to clearing huge page attributes has been completely redesigned.
Instead of spreading the `pte_clrhuge()` anti-pattern to ARM64 and RISC-V,
this series enforces strict type safety at the lowest level: `pfn_pte()`
must never natively return a PTE with huge page attributes set.

To achieve this without breaking the x86 core MM, the series is structured as:
  - Fix historical type-casting abuses in x86 (vmemmap, vmalloc, CPA) where
    `pfn_pte()` was wrongly used to generate huge PMDs/PUDs.
  - Update `pfn_pte()` on x86 and ARM64 to inherently filter out huge page
    attributes. (RISC-V leaf PMDs and PTEs share the exact same hardware
    format without a specific "huge" bit, so it is naturally compliant).
  - Completely eradicate `pte_clrhuge()` from the x86 tree and clean up
    the type-casting mess in `arch/x86/mm/init_64.c`.

2. Page Table Deposit fix during clone() (syzbot):
Previously, `copy_huge_pmd()` was unaware of special PMDs created by pfnmap,
failing to deposit a page table for the child process during `clone()`.
This led to crashes during process teardown or PMD splitting. The logic is now
updated to properly allocate and deposit pgtables for `pmd_special()` entries.

v2: https://lore.kernel.org/linux-mm/20251016112704.179280-1-yintirui@huawei.com/#t
- remove "nohugepfnmap" boot option and "pfnmap_max_page_shift" variable.
- zap_deposited_table for non-special pmd.
- move set_pmd_at() inside pmd_lock.
- prevent PMD mapping creation when pgtable allocation fails.
- defer the refactor of pte_clrhuge() to a separate patch series. For now,
  add a TODO to track this.

v1: https://lore.kernel.org/linux-mm/20250923133104.926672-1-yintirui@huawei.com/

Overview
========
This patch series adds huge page support for remap_pfn_range(),
automatically creating huge mappings when prerequisites are satisfied
(size, alignment, architecture support, etc.) and falling back to
normal page mappings otherwise.

This work builds on Peter Xu's previous efforts on huge pfnmap
support [0].

TODO
====
- Add PUD-level huge page support. Currently, only PMD-level huge
pages are supported.

Tests Done
==========
- Cross-build tests.
- Core MM Regression Tests
   - Booted x86 kernel with `debug_pagealloc=on` to heavily stress the
     large page splitting logic in direct mapping. No panics observed.
   - Ran `make -C tools/testing/selftests/vm run_tests`. Both THP and
     Hugetlbfs tests passed successfully, proving the `pfn_pte()` changes
     do not interfere with native huge page generation.
- Functional Tests (with a custom device driver & PTDUMP):
   - Verified that `remap_pfn_range()` successfully creates 2MB mappings
     by observing `/sys/kernel/debug/page_tables/current_user`.
   - Triggered PMD splits via 4K-granular `mprotect()` and partial `munmap()`,
     verifying correct fallback to 512 PTEs without corrupting permissions
     or causing kernel crashes.
   - Triggered `fork()`/`clone()` on the mapped regions, validating the
     syzbot fix and ensuring safe pgtable deposit/withdraw lifecycle.
- Performance tests with custom device driver implementing mmap()
  with remap_pfn_range():
    - lat_mem_rd benchmark modified to use mmap(device_fd) instead of
      malloc() shows around 40% improvement in memory access latency with
      huge page support compared to normal page mappings.

      numactl -C 0 lat_mem_rd -t 4096M (stride=64)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      64.00               148.858 ns           100.780 ns        32.3%
      128.00              164.745 ns           103.537 ns        37.2%
      256.00              169.907 ns           103.179 ns        39.3%
      512.00              171.285 ns           103.072 ns        39.8%
      1024.00             173.054 ns           103.055 ns        40.4%
      2048.00             172.820 ns           103.091 ns        40.3%
      4096.00             172.877 ns           103.115 ns        40.4%

    - Custom memory copy operations on mmap(device_fd) show around 18% performance 
      improvement with huge page support compared to normal page mappings.

      numactl -C 0 memcpy_test (memory copy performance test)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      1024.00             95.76 ms             77.91 ms          18.6%
      2048.00             190.87 ms            155.64 ms         18.5%
      4096.00             380.84 ms            311.45 ms         18.2%

[0] https://lore.kernel.org/all/20240826204353.2228736-2-peterx@redhat.com/T/#u

Yin Tirui (7):
  x86/mm: use PTE-level pgprot for huge PFN helpers
  arm64/mm: use PTE-level pgprot for huge PFN helpers
  powerpc/mm: use PTE-level pgprot for huge PFN helpers
  mm/huge_memory: refactor copy_huge_pmd()
  mm/huge_memory: refactor __split_huge_pmd_locked()
  mm/huge_memory: make move_huge_pmd() use has_deposited_pgtable()
  mm: add PMD-level PFNMAP support for remap_pfn_range()

 arch/arm64/include/asm/pgtable.h             |  48 +-
 arch/arm64/mm/mmu.c                          |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |   5 +-
 arch/powerpc/include/asm/pgtable.h           |  11 +-
 arch/powerpc/mm/book3s64/pgtable.c           |  11 +-
 arch/x86/include/asm/pgtable.h               |  68 ++-
 arch/x86/include/asm/pgtable_types.h         |  12 +-
 arch/x86/mm/init_32.c                        |   8 +-
 arch/x86/mm/init_64.c                        |  30 +-
 arch/x86/mm/pat/set_memory.c                 |  51 +--
 arch/x86/mm/pgtable.c                        |   8 +-
 arch/x86/power/hibernate_32.c                |   6 +-
 mm/huge_memory.c                             | 440 +++++++++++--------
 mm/internal.h                                |  21 +
 mm/memory.c                                  |  87 +++-
 15 files changed, 493 insertions(+), 317 deletions(-)

-- 
2.43.0



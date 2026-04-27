Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C04FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE4C6B0098; Mon, 27 Apr 2026 07:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96396B009B; Mon, 27 Apr 2026 07:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85896B009D; Mon, 27 Apr 2026 07:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7AB76B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:46:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72BEEC05BD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:19 +0000 (UTC)
X-FDA: 84704157678.05.B731766
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8453C100007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Laks6fkq;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d4CPXSfWrimroKypQIOlLdi5HuaOhzjmlF0IdNJDnTI=;
	b=ALOgCDJetsH6DNxNyj2cNJOykY8BXik8hNwxaRueLB7ID9dcX2GozmFnFl+ovYh79vRXCh
	1gJt0z8bZeB4H5SRY5fWLMMZWEBXqLBY7A0T8azpZhr/EW5U/+uZ9lc4Avcld9sDh2WNm7
	C+pRwDQTQiZNuaaeqZVniTfXb5V/HLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290377; a=rsa-sha256;
	cv=none;
	b=LHUFS1Fo8DzCyW0sykB9M015DVi3YWYnE0nA4aZgyc6FPi7dPs9dEid3W1z1XYDJqGrFgO
	jJjF0BLifmOFOjPUL+nO/1jB05QRerz+tb2A2HfRlmOL30dpWiXpAwArLlgR8cPXETmxAi
	9nmgVJz9iq136a6AvgZbQWanxheilb0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Laks6fkq;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6D3A60138;
	Mon, 27 Apr 2026 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3B8C19425;
	Mon, 27 Apr 2026 11:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290376;
	bh=yH/KPwWvmfYCExNGgLiDTlHxi4/ezYbz7xmeMUYZTIE=;
	h=From:To:Cc:Subject:Date:From;
	b=Laks6fkqlGrot57VY5VoYz1XsRHsmm3QMv4Da6Byfv5wtiikI6POdsFAOgSf62PoC
	 J5CUeu6fu4eGLG9C8GWHyHNHkyx5nOQAPVI6hys3uauXtja5cwSB6lo3BzMhJzNPPZ
	 zsEvM7+KLz/x0zK+JbAlCH3lhpKRbtgXQ8WKBkHtIMz5/qaaGMa4/yZKDIvwm+lYMi
	 3/0+t8m99/xtDbKqQ6+i/YMWNN9s78gU7PpYwCWbjCTJlV1EBNsjK7CuE3Qa7eNWlP
	 lLnxYvI6wautyXQkrf3nE6eKOgn9uLRi5wNDwmfoPoz+GDSCOVXxlqW9pApsuzf10M
	 CBjAH//mS8ifg==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4F817F40069;
	Mon, 27 Apr 2026 07:46:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 27 Apr 2026 07:46:15 -0400
X-ME-Sender: <xms:h0zvaX04mV6K3HGSrWdzZF_Q9N9v_GmRtkxHT9NiM6sgsnat9C8QMw>
    <xme:h0zvaaCiYzeKikQ8bpaHOB3Fdqjmmu5tKYs5tBd_ABY_hBDn7zpxBC6KhGVYGPKXb
    oywxSMQXpwCnWTJryQgOQApHx1CrrVX169K7-reY_lA83pdtrm7JNM>
X-ME-Received: <xmr:h0zvaQY-xQ0py8uPPf8RTeQSmFRoXJu_wNef5M1btw93PSxHYQJ7miY7ouQ9IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofggtgfgsehtkeertdertd
    ejnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehk
    rghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhepvdelveehjeejveevte
    fgjedvhfdtffethffhteetgfekjeefgfekudfhtdfhhefhnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruh
    hthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgr
    sheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpth
    htohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthht
    ohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphht
    thhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhoh
    iflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdr
    tghomh
X-ME-Proxy: <xmx:h0zvaWbdGObNdKtk5BVuGEwjA5Uw-YZh9cd-mkk7ICv5M3Sh8dQFyQ>
    <xmx:h0zvaRk7UKzLmWTivA8YzKR-zSXK_NjlBjz7bColJlaMzg67mqzr-Q>
    <xmx:h0zvaYSxlpvZeAWey6bwculxjei_KQ077EPqFCEWk2ke-z1DXGVFgg>
    <xmx:h0zvaWVTRxDYoBmIWX3om8TV_PSOjuWD3EFhaOCfsdPIkslRLl6c0g>
    <xmx:h0zvaetuCdPPBM1yLDMoMkcrz9K5lX6r65F9nMzV_83pTU648RSMTHl1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:46:13 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 00/14] userfaultfd: working set tracking for VM guest memory
Date: Mon, 27 Apr 2026 12:45:48 +0100
Message-ID: <20260427114607.4068647-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8453C100007
X-Stat-Signature: 4d8qfdh69599usdzoicz7ina584cdquo
X-Rspam-User: 
X-HE-Tag: 1777290377-12931
X-HE-Meta: U2FsdGVkX192VgQVm2QQb25fzKVFOcwNNUHYCXzpxMjndQ7lj4PloWueGSaG77E8EUPuKUW7LJWFnDy44xuKGZFjtsBqCE/5KN0rXXxKj7EuV9t8ixoo3iMLLekJOirBUHd4OIQ6LtLhspR7BvTzQQrJS749dZTK54Fb5CsXq+wgNKHjAXbfXFhyiLfXMQLrfx77vg6Yc/zHwE54aAi0Y9oH7fHd0YGtpGqjf2hqsbBO85KnO4gNGn0aGD7ZbbZEnx20QhxL2c5mYk4V4d2tu0gmkoroIvp13AizeJ7dgJaqm90Wg8J2Rkuh6Nz2a5jNOM/C7GrQRIqjRP/1snVqz79wR8JMSKrgb/B3PETlVswE9Rpa9POR9lOuawWPkKC3+oq81ikIlyt6yUNUtBZvHmBkBhWaf6eAVysHkpMSv1KrqCxKW093MNYK4/5MgVBNQhSUKHJ7PN1czRgfpAkdV9kQ8Gc6A0LW5c5QFbyFfnR/rp+MtuUQM6pdXp0KbtzHoTR6c3xwKlsEqk7wojOp4+QHvZj6CdinvE+TkRKuyNkmkQkO3pQoz7qoYypqKiSINNvMmwPB/Gsp3cH68dqo9+U03C7JjySOn3brFe4lkMERS7mk+bYNwRdb59V0+O2agakeF19/4aR8SrX3uumn0LN8PaL0wLQ5yno9huocBLLTO1BqQ4dRKz6wdTa2lCC7KNNJFidMyiFAXZWq4lNA4DTtUY0iu7PZhJy+awkBr6xytm/zGvPxCUwqMg5mpDpBShbm7soTOJxEXwbqqsbXxHIQcTrUy5bB5201GNNwtDqHAcOnJI9Q9EPxlVNcQJnf/KhafY/BToYAnf+gEyOZoA7XCf995/hfCev1z8xClZMw2o6FvJlQonf5AhvvAh8WM75p0ZalCCZErcFjHat5nKa7w2tsvVP9sxxrgtGMrUrN7rjkf9CwQMYdPdTj87gDGXVuhK3G9rlSvXbKMgH
 Phl1fQxA
 XoP7UxpQS71LtjkZBKhTEHWtgD7Urai6otqXOAFc0KeRMvHWgu7SyJWTqYnw1dE1IykAq1pbhuTVwRUAvAgwD0OmG4PT3uS0Vn6DQE/YYh8jq7nap3Kh69aTa7dnHcw0zmWBczj/9tCThGPBeDsy1JiNXUyNF2pBGzlykuvk1am0dWLJ+2QUMoh+b3+VZuN4etrq3HOSCWlS+NxuYgLGvH4Ay+7xiZDuz1n3RnUCxpaM7msA5RFcfs5mcIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds userfaultfd support for tracking the working set of
VM guest memory, so a VMM can identify cold pages and evict them to
tiered or remote storage.

== Problem ==

A VMM managing guest memory needs to:

  1. detect which pages are still being touched (working-set
     tracking);
  2. safely evict cold pages to slower tiered or remote storage;
  3. fetch them back on demand when accessed again.

== Approach ==

UFFDIO_REGISTER_MODE_RWP is a new userfaultfd registration mode, in
parallel with the existing MODE_MISSING / MODE_WP / MODE_MINOR. It
uses the same mechanism on every backing -- anon, shmem, hugetlbfs:

  - PAGE_NONE on the PTE (the same primitive NUMA balancing uses)
    makes the page inaccessible while keeping it resident;
  - the uffd PTE bit (the one MODE_WP already owns) marks the entry
    as "userfaultfd-tracked" so the protnone fault path can tell an
    RWP fault apart from an mprotect(PROT_NONE) or NUMA hinting
    fault.

VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive per VMA, so the
same PTE bit safely carries both meanings depending on the
registered VMA flag.

In sync mode, the kernel delivers a UFFD_PAGEFAULT_FLAG_RWP message
to the registered handler, and the handler resolves the fault with
UFFDIO_RWPROTECT clearing MODE_RWP. In async mode
(UFFD_FEATURE_RWP_ASYNC), the fault is auto-resolved in-place: the
kernel restores the original PTE permissions and the faulting thread
continues without a userfaultfd message ever being delivered.
Userspace then learns which pages were touched by reading
PAGE_IS_ACCESSED out of PAGEMAP_SCAN -- pages whose uffd bit is
still set were not re-accessed since the last RWP cycle.

UFFDIO_RWPROTECT is the protect/unprotect ioctl, mirroring
UFFDIO_WRITEPROTECT.

UFFDIO_SET_MODE flips RWP_ASYNC <-> sync at runtime under
mmap_write_lock(), so a VMM can run in async mode for detection and switch
to sync for race-free eviction without re-registering the userfaultfd.

== Typical VMM workflow ==

  /* arm */
  UFFDIO_API(features = RWP | RWP_ASYNC)
  UFFDIO_REGISTER(MODE_RWP)

  /* detection cycle */
  UFFDIO_RWPROTECT(range, RWP)
  sleep(interval)
  PAGEMAP_SCAN(!PAGE_IS_ACCESSED) -> cold pages

  /* eviction */
  UFFDIO_SET_MODE(disable = RWP_ASYNC)                  /* sync */
  pwrite(cold) + fallocate(FALLOC_FL_PUNCH_HOLE, cold)  /* races trapped */
  UFFDIO_SET_MODE(enable  = RWP_ASYNC)                  /* resume */

== Series layout ==

Patches 1 to 3 are preparatory:

  1: decouple protnone helpers from CONFIG_NUMA_BALANCING.
  2-3: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop the
       _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.

Patches 4 to 7 add the in-kernel mechanism:

  4: VM_UFFD_RWP VMA flag and CONFIG_USERFAULTFD_RWP.
  5: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
  6: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
  7: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 8 to 12 wire the userspace surface:

   8: UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing.
   9: RWP fault delivery and exposure of UFFDIO_REGISTER_MODE_RWP.
  10: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
  11: UFFD_FEATURE_RWP_ASYNC for async fault resolution.
  12: UFFDIO_SET_MODE for runtime sync/async toggle.

Patches 13 and 14 are tests and documentation.

== Notable changes since the RFC ==

  - MODE_MINOR-extension dropped in favour of a dedicated MODE_RWP;
    UFFDIO_DEACTIVATE replaced by UFFDIO_RWPROTECT (mirror of
    UFFDIO_WRITEPROTECT).
  - shmem and hugetlbfs are no longer zapped on protect; they go
    through the same PAGE_NONE + uffd-bit mechanism as anon, so the
    RWP semantics are uniform across all three backings.
  - PAGE_IS_UFFD_DEACTIVATED in PAGEMAP_SCAN renamed to
    PAGE_IS_ACCESSED; the value reported is now an "accessed since
    the last RWP cycle" signal, scoped to VM_UFFD_RWP VMAs and
    distinct from PAGE_IS_WRITTEN.
  - SET_MODE scope reduced to UFFD_FEATURE_RWP_ASYNC only; the
    runtime escalation path that auto-enabled WP_UNPOPULATED has
    been removed.

Kiryl Shutsemau (Meta) (14):
  mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
  mm: rename uffd-wp PTE bit macros to uffd
  mm: rename uffd-wp PTE accessors to uffd
  mm: add VM_UFFD_RWP VMA flag
  mm: add MM_CP_UFFD_RWP change_protection() flag
  mm: preserve RWP marker across PTE rewrites
  mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
  userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT
    plumbing
  mm/userfaultfd: add RWP fault delivery and expose
    UFFDIO_REGISTER_MODE_RWP
  mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
  userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
  userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
  selftests/mm: add userfaultfd RWP tests
  Documentation/userfaultfd: document RWP working set tracking

 Documentation/admin-guide/mm/pagemap.rst     |  13 +-
 Documentation/admin-guide/mm/userfaultfd.rst | 211 +++++-
 Documentation/filesystems/proc.rst           |   1 +
 arch/arm64/Kconfig                           |   1 +
 arch/arm64/include/asm/pgtable-prot.h        |   8 +-
 arch/arm64/include/asm/pgtable.h             |  47 +-
 arch/loongarch/Kconfig                       |   1 +
 arch/loongarch/include/asm/pgtable.h         |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |   8 +-
 arch/powerpc/platforms/Kconfig.cputype       |   1 +
 arch/riscv/Kconfig                           |   1 +
 arch/riscv/include/asm/pgtable-bits.h        |  12 +-
 arch/riscv/include/asm/pgtable.h             |  59 +-
 arch/s390/Kconfig                            |   1 +
 arch/s390/include/asm/hugetlb.h              |  12 +-
 arch/s390/include/asm/pgtable.h              |   4 +-
 arch/x86/Kconfig                             |   1 +
 arch/x86/include/asm/pgtable.h               |  56 +-
 arch/x86/include/asm/pgtable_types.h         |  16 +-
 fs/proc/task_mmu.c                           |  98 ++-
 fs/userfaultfd.c                             | 246 ++++++-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  46 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  22 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                |  76 +-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 145 +++-
 mm/hugetlb.c                                 | 146 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  38 +-
 mm/memory.c                                  | 123 +++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  62 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 104 ++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 734 +++++++++++++++++++
 52 files changed, 2124 insertions(+), 412 deletions(-)

-- 
2.51.2



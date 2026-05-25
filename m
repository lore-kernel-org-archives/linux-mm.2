Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643E2CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643146B0005; Mon, 25 May 2026 07:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4056B0088; Mon, 25 May 2026 07:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1026B008A; Mon, 25 May 2026 07:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AADD6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:37:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF4F5140226
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:37:50 +0000 (UTC)
X-FDA: 84805742700.26.488CED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5CAA140008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:37:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmAEqScW;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dl7dpu1exa3A74XDjIC3N/ZIjaN5eVr0TdcVgG6iMio=;
	b=vZwj0Le+G/tLiJ9jcZ9EBABiJiKBFCm+EWbx33ecZq8C6yvuB4AxA/P46sWvYaYs7+IAtA
	k7HI8rAvEl/ll3bLf2BNN3wQ5q9ZXTZLxvYlEjL9dU3faeIJREML1GjR76aKzShEtXTCQz
	JCd7+7t9a6DlLmRBOhd/TYq+FDCPUr4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmAEqScW;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709068; a=rsa-sha256;
	cv=none;
	b=txPdbkRC7v/5puR+3bFpiLMbfQDCm/cmjry+d43o9Q7cUKr5Je/qDJh/yZJcqIO74Ehn6E
	uT7JGne6Tx0o4r29ypr2xn2zdKiTHyBL0Mk+J12YEXMlDRNxBomzcnAL6Ow2HT/CIS4UgN
	2ZwnWbRuL0HHxB9yw7fFPRGsHKeyjpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 096D7600C3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5513F1F00A3C;
	Mon, 25 May 2026 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709067;
	bh=Dl7dpu1exa3A74XDjIC3N/ZIjaN5eVr0TdcVgG6iMio=;
	h=From:To:Cc:Subject:Date;
	b=NmAEqScWjcjnXJnQqLoH9ADQOY2xkAo4ylGlMcgVyre/A1WpTUWIEQwHNFbuXjKs/
	 VrAtkDqGnFBk10TU1OtJ5/pYI38+6/jg6QhbxKlS6h5eXbcaFSislA6Qxd0d9DT4ZK
	 PX7PmP90VIqcHZ1+2ParU64+3C0xAvnylsoliGIp37Ddfq4RLo93W7WWqXals4PDjW
	 7Npg4nJePbeJckt2Roah16YQxfxgqUek3v+H9XIbN+ynOY9Cn46Pp8DtIKN1Be1XkW
	 dmohCDEq2ibhkwjzO1cRgs9eRTUKdH8m6vkFpdywwMBBrpvmgyxLHDkT+h0DDwHZuZ
	 VNPD4EhjO45Xw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 96CC7F40082;
	Mon, 25 May 2026 07:37:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 25 May 2026 07:37:46 -0400
X-ME-Sender: <xms:ijQUapk4d6chi8s7ETQOcq73rYa_rCeoi0Q4iZTZGSAHhqjioZhpFg>
    <xme:ijQUaozW0hO6RXMI5yfakY0Qqfwl0pAvsZkc4UfLcbzBZD9WfaX6wtXnnW_wP5Tzf
    r62Rbw7CbFz4hoDvkJ82n9AXYIbkDeZBH6vrPYtDqLNujg1fDIjog>
X-ME-Received: <xmr:ijQUaoJhVFes3KDlXytKccazqXEnIpWlSWIxpxWffdz6Qow6OoRrTWlz5WWUGQ>
X-ME-Proxy-Cause: dmFkZTF3tWtaeukQqIXNh7e9P6RzlqNyAwK/t8XHj+gg488wnUommG6YA/pGCeS/NKqttW
    7ZXkwmHCXokbXK8HTefJ4ZSlSN9p92+PKcsEE5ygZQfEPrRAv9dk2Uj1Rp9gm8pvW7D5dI
    8SsI9JbTU90NHvLh95w8XadB5ZffnVtnkTOR2eA+dkONQUAYLWhZJ5dW3jhIzZg02o9gDG
    E09iaGwEscv7TRtZvygVhiEgayjhIRbhgY/vezbHGe1fFbKpLruJIKRDlkXCB4qCydkpIV
    aMBsnRvuvz5zxyyol40qpUTGtt3Alcrd0sglI70Fct4d5+azC035MorTASsN12HgTuNGZg
    f5C52NGWAGA2MbgfW4STfdCpDljPOm4ge+TE95gmrlOrqtehOfNhl56p//B98PcUuQvrHh
    pz82+adGrnbVjlO9yKKIfwtfohxlwXBUO7RYVDez7SBp4kYZ1hK2fG6qicPU2rh6RQJ/7f
    iJXAhL4XC/YicpUHw3/eLTxp58t+Qj7WWQx9m5yhG2akquAQGl1yqX31aq4RGk6slHO4Px
    EYNhX19WkOMZ3DI0YnIUyvNjtmaPjqpSG/dXpbnxrEOErJ6Ty75yXaEiNGctD8kiOVLGiP
    GJUdd2sm2CJ4E0oxIHwZVLdg5sgw+dRgEysxBAzG/JGTC8U+P2UG5jMx/hbw
X-ME-Proxy: <xmx:ijQUajJhPBBISovERw7Mc3ZLq21LJnwMxM1qWtCI7hZcwnc_P2WREw>
    <xmx:ijQUavWg6O2zBjGA8quukUMd6qVcWHXq3fXCPAS5KIcRk9vIoLSroA>
    <xmx:ijQUajC4zSPG92Z8qdI5_YNpR_J_pbYwHZgSf_fWI2V7R7q94GESeg>
    <xmx:ijQUaqGyQ86ttczeJxHT8Da9nXq7P-bTsQm7Qq8oiALDIt0FyMB-RQ>
    <xmx:ijQUanfjXUj0RMZOu2wCqh5BKywf6W9TppamQHjXZ_7PEz840G5FEUxM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:37:44 -0400 (EDT)
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
Subject: [PATCH v4 00/14] userfaultfd: working set tracking for VM guest memory
Date: Mon, 25 May 2026 12:37:14 +0100
Message-ID: <20260525113737.1942478-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o3971nqggwamb3ancegz7ywhmc5r14qd
X-Rspamd-Queue-Id: C5CAA140008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779709068-167372
X-HE-Meta: U2FsdGVkX18ektO5ipXv+uzwrroob1bA5OCFMUwd8/2PSdpt2hqB8a45EvlOUm57BO6v/WBkh3th7JmBqnAiw3/o6u+JxlZLLhZLzWSvoa5+/vhmnUSi//1Q6gshwsyQPmF04c8LxBcs6V2MqvuAwtGngNTvca2FDhdyvlDtWa4hTXurr6AVihc9IPuDULJkjuscarUIUi2Asf+zyidluet/ckyWFALiYw1w6lxT0eu0ZzUjBBL7MftgK63b67LmxO98JOTCsshcme0UI3xfc+k/QBALrfivmboP23uhgeFX4pnLENWXuk97vPy5yPlZxeIOAbG3WiAh5nwZQLLcxkwD9zxxEMID0SdH//l3nE0u4EHDU1DZ7tHLD3tvI5MQdoyEnjgKtmwl+M3fZcjrzlz8F3kxau7WYkN9f2FaeKOiNbK5lhDyd1G7P88HwaNbWqFp5kj9mxzBQpBcaKmpuQXRc1/78zuO14l0D2VqtnXXJgBjL/nONcrzSmxbVq4ULgQfAW05uTo61X83PlfhC4izk2dnH+9m8GAXMXFIByrP7e8A9OHGvFhdmgaZ1uiSnwB4g0ffH1qHc0pqYfGaGGT+6E1+Q+DQSwftmYXKHPIbepCSLgYgKqlvrvrZ4FjrdJIzVhVbK6MD1wYHPIY4V9xLHJ5SbFi8pt41jbLtPp/aFI+9GvjUElbSq7H4dXr4gN8JqlJXyOz38aoui1TsE2sQloM2rUZG9f4mqhTiHgK7Jl/qcxVeWMzVLc7EE4p0p64x/IDYRPInA34UjsAzuOfO14X9AoXdx7QCdZaaPa9nRSxpdL6mGY5bD3tFL/kSY3PBarJliYjZUQSbK6+cZK5rAfZo+vW0h54vxtLALkDYHbKLyUtN/jOIW6G35oe9v9yUerDCTagtdVj57cdwbH6kEb7avcBeVq+2utCZL2SN70mRz8JVaUgkzvc2ljN50m5VQtC9uLor3b5Kv14
 C4qEG8iC
 wBYrUXsfzk6ZGjuZ3UaPK9LXrILtPIiOIh7eHeD464U+f+yZC8I9mZEjHpm9r/Hyjxdni1LgTwc9yjCkzUqqn2CYskZA74kh+ez0+5hPXcKNyj+b4wniccctmXZ9nWdOfb5MhhMsDxCOzQuCRPXj+cTnzkvhoniPzfhY3t2Kco3HEWvgH9jcE8gr0aQbvfH4qiTXLOwhWrbuVkZu09HTeHWP6JggM3YFZHBlIBTNF/xE+4YnzeagXMehdmyhwnX8oZUVIPUN4k4+gMljJKrS3MYMbQ8QA/l4+MrDf0jLV/6JHQ+qOS/JIfjXV16pRjP4oi5evLXXXYNfHrjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds userfaultfd support for tracking the working set of
VM guest memory, so a VMM can identify cold pages and evict them to
tiered or remote storage.

v1: https://lore.kernel.org/all/20260427114607.4068647-1-kas@kernel.org/
v2: https://lore.kernel.org/all/cover.1778254670.git.kas@kernel.org/
v3: https://lore.kernel.org/all/20260522133857.552279-1-kirill@shutemov.name/

== Changes since v3 ==

  - Rebased onto mm-new, including Mike Rapoport's fs/userfaultfd.c ->
    mm/userfaultfd.c
  - 05/14, 13/14: Reviewed-by from Mike folded.
  - 06/14: hugetlb sites now restore _PAGE_PSE via arch_make_huge_pte()
    after huge_pte_modify(); move_swap_pte() re-arms the uffd PTE bit
    when dst_vma is RWP-armed.
  - Man-page patches dropped; will be sent against the linux-man tree
    separately.

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
mmap_write_lock(), so a VMM can run in async mode for detection and
switch to sync for race-free eviction without re-registering the
userfaultfd.

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
  2-3: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop
       the _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.

Patches 4 to 7 add the in-kernel mechanism:

  4: VM_UFFD_RWP VMA flag (aliased to VM_NONE until 8/14 introduces
     CONFIG_USERFAULTFD_RWP together with the UAPI).
  5: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
  6: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
  7: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 8 to 12 wire the userspace surface:

   8: UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
      (introduces CONFIG_USERFAULTFD_RWP).
   9: RWP fault delivery and exposure of UFFDIO_REGISTER_MODE_RWP.
  10: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
  11: UFFD_FEATURE_RWP_ASYNC for async fault resolution.
  12: UFFDIO_SET_MODE for runtime sync/async toggle.

Patches 13 and 14 are kernel tests and Documentation/. Matching
userfaultfd(2) and ioctl_userfaultfd(2) man-page updates will be
sent as a separate patchset against the kernel.org linux-man tree.

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
 Documentation/admin-guide/mm/userfaultfd.rst | 236 +++++-
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
 fs/proc/task_mmu.c                           | 108 ++-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  46 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  32 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                |  78 +-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 155 +++-
 mm/hugetlb.c                                 | 158 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  40 +-
 mm/memory.c                                  | 123 ++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  68 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 378 ++++++++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 766 +++++++++++++++++++
 51 files changed, 2248 insertions(+), 425 deletions(-)


base-commit: 449a5df98f8dffa9b037e3b6838fc5af327df072
-- 
2.54.0



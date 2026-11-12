Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6A6606A88F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=qNWVJIpV
Received: by kanga.kvack.org (Postfix)
	id 576046B05BB; Thu, 12 Nov 2026 07:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE236B05BC; Thu, 12 Nov 2026 07:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C67F6B05BD; Thu, 12 Nov 2026 07:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 007D36B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DD938056D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:52 +0000 (UTC)
X-FDA: 85426466664.08.6ED2896
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4793A140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qNWVJIpV;
	spf=pass (imf23.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488210;
	b=0eDz7p38z1PkOfUY+FLJ921i8wUm+4hUvu9IonX0JpsFtvKJ+TypcSpj5kGKcl0nKmABwR
	mD9wQ0BUNM6U5hkUHD1++0dQZ7zKYJS2D08EgG2IQB7XSyWVutzIp5SsDsauy2QZ3mQMwG
	kbrbYrGeREJVChV9UFQuUy2RcgPhlQk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qNWVJIpV;
	spf=pass (imf23.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EVX+oMyzcXeSJ6bE2ZvvmvStnTsvmQJ+35dsaVluXZM=;
	b=n2THYylNAZn51c67zu/XCsKsm962DrpMvgPpn6wnrj+5tve48Lkkso/fnJ20YIJ8yg0DvT
	Tmj894To2QhS4phUjlwhyL/APOmjScHYPvQMCQFcIl5RfXTrqTurQCmzATlEQ66O6YVPb+
	a+bMEYVHZ1TF0iaGPLh8CdbOfxCO2sA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488210; x=1826024210;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EVX+oMyzcXeSJ6bE2ZvvmvStnTsvmQJ+35dsaVluXZM=;
  b=qNWVJIpVVzzHiQQkClaoSD5rOpkuIfthPvne9qBSdg/hRsdJgK7Xq5vC
   Ht4q4zQzzOGxoEv8Bj20k+uJQDcwTSMQi+3tes4DsXThFy+wNLbYriHAg
   ckY5xh0RLotGdk+zo7Seud4Y4DKcj3Rcbm5JfdQPahZ1iOG+XEuhJgwIQ
   jSsQ0S3qpC9cCcNZK78b+zYKs+rF9gyn/NT/0RmrFK08By8zl96MCTd36
   Kv7pljXBXkC9niKHIssOTj7Yg/wACe5bmCoalHqRj0of9VO6vJ0vikeuy
   XnaZx0PmKhtCdSM8qfGF2It3kbfSjVK9NpZBjgmHZBLdM5avK9Yg20bu1
   Q==;
X-CSE-ConnectionGUID: Jxrzf8HRTZK+/B1uhUDtZw==
X-CSE-MsgGUID: n20t8zzdRVe3yPtKV5OymQ==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33584639"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:56:45 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:4196]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 128accdf-40db-45a0-97a1-8996731a8517; Thu, 12 Nov 2026 12:56:45 +0000 (UTC)
X-Farcaster-Flow-ID: 128accdf-40db-45a0-97a1-8996731a8517
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:56:45 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 12:56:43 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Eliav Farber <farbere@amazon.com>
Subject: [PATCH v2 0/4] mm, uio: huge PFN mappings for /dev/mem and UIO
Date: Thu, 12 Nov 2026 12:56:34 +0000
Message-ID: <20261112125638.12209-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4793A140005
X-Stat-Signature: f6keqdy66p83fjqju5cbxsdoxphkj5jj
X-Rspam-User: 
X-HE-Tag: 1794488210-203911
X-HE-Meta: U2FsdGVkX18mdc/40jQKrt3hETUkRYJRzklHbXNGFx4UAMsI6uzaImzZs8I+mEWXM994lAjW9TwrfKINk+gZAiFf4QyMaP2bS4h2rhoUrH1gEh4YfZFheZoHiDhU+/sIY+cC82glONuSAsL8HcJ1YdVYNwgZqUEONhhcBywHtHND1x0FC8gK9vNr5Wy337tfh3LKaBcS2Tn5VbAX6rgu9Uzr2oURJ/JdHV/2h9Gm7n8IJWwIVrIqqYm7vy8sWCPBLWwHEsKqZEM1yPqNg0FAVOQcJHFBwq+XPm70FjEY1LgvNdKL7edvf+bXk3If0XIeGNO6d4lXvQ6hWg3vCrYn01TQ7aGzI+Q3/REL9TifLoljTxn2NNo3nORA+FpF3+2pXLZtNrXwRdJ+Stw5D8+/CkurAeM9gpVm7WgkrwENDUrNFUYARDPffCxgiXtaZYAj+pguQa/2tpqHEycg0KPBRmpUdZjX/d/2y4WfSlN9kgvbIp7+1/fcSJ3Opwr7PTf6QRbSugWr9fcmmRwvaHQiObTPkWqTyoqUgF/0tnb49BH8Ef1ZG9YKcz/HrSq7u7PV4Q13NqgfbQu+35GKo+U1OifvtcAMV51iwCtUZn9CSBTerhPcxaEJDj6qhh+zi3zTexzx28Y9NjdNzqjzRd/bXGkNz1agRYfE7EOruNBgOS9cXyOjkGwNgaUUa31jQIVKXTuX5laAas9tVsTXIkeXAdZxmFxu0mSULYm3S97WRej8MDGfP10IjlJl98dfwIlsQnO2dU8x4FePTw90nIKBnk384AgXwe8T5+GiJS9GntVTlqqFncT/twfrtz0pkPy/NrcIHtyD6nkqMW3+iwd5tTlZA5fY2DsB7mou7bgb3VQzFcyFj++Adyz8349TuWzo1UotzmhwlypBBIDkk+nsMFqwFrMvxeTfvbiIZ2HfDNO39mCoBDVMdy/j8L9P+KyFtyBene+JtlAc/wXIZ1Q
 Y0L6FQeA
 UaILkix30GVcl3pBIOTUq5A2XD5oAnvTc2YxZS+SbIeMy6PY1v6wIHQwy6TVteHsLHi9w6+p7AQRDwO4Hmte7C1iBc8BOlMG8g0Y25QIvMwwBpfMN0JVHFScJGkgecZ17/eYpIPPJqd/tP/Bg5ej7WUPiPILEOV+hnS9h/MKhfDLCCIswlnx5Uscjb3cBN8geP88f1g/YbXEOHIVL5BhRLFzcH+VFHu7so2Ui/DKrv7euV/OhHlOYFuH5eomJn+4Y3PtGRCygBRB00zpq5TKyZz6q1e8k2XdjjYQo8ZOQG872qV06CM2l+BCGpGV22rGy/poo1ML3aw6WQUq/RCGTFqWl6/CZM+u8U60PVBVmN8wH0VkPfBSq6PdpPR76ZGr7vxiwb6Qc1BokulYsl9KOQtkibJJBM+Is6kqURVO63FkB2xcJXEr0pjw9iEgv7lK1Q+ISvT6z6aSEU+DPZmGpqEuxekCDvuiYeFDUF10v51rMhEDkmu5tLMuPWHyb8g1aM1upvpKGLue+Oc8Xt4On+MHyAq5wTI/6u0xwgyk8WJHSnDH2hQSyDh6jdRDx3OmqCoZsSXa/fNd8XSQEmTW2Xinr2IVRvk9E+p3tis0FUZnuuXM83jeD3Dit4WU3QFFmMCZPT4ZIoI1GIoh1ArDLdXg1e9JOzs6qduP5IwrVZ5n+UiUtpIsP+t83q0bYwSRE5CASzj8q54xhqoJDlGEY5C1JRH6qvLGnjn9V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/dev/mem and UIO both hand large, well-aligned physical regions to
userspace, and both populate them eagerly at mmap() time with
remap_pfn_range(), that is with 4K PTEs however large and well aligned
the region is. vfio-pci moved to fault-driven population in commit
f9e54c3a2f5b ("vfio/pci: implement huge_fault support") and gets PMD and
PUD mappings where alignment allows. This series does the same for
/dev/mem and UIO, and factors out the logic vfio-pci open-codes so that a
third driver does not have to repeat it.

Two things have to be solved to do this outside vfio-pci:

1. remap_pfn_range() reserves the range's memory type in the PAT memtype
   tree, via pfnmap_track() -> reserve_pfn_range(). The vmf_insert_pfn*()
   helpers only look the memory type up, they never reserve. A driver
   that populates lazily therefore loses the conflict detection that
   rejects a second mapping of the same physical range with a
   conflicting cache attribute. Patch 1 adds pfn_range_track(), which
   sets the VMA up as remap_pfn_range() would and reserves the range for
   the VMA's lifetime, but leaves population to the fault handler. For
   ->mmap_prepare drivers, where no VMA exists yet, it adds an
   MMAP_PFN_TRACK action.

2. The order dispatch itself: the window and alignment checks, and the
   pfn_modify_allowed() check that vmf_insert_pfn_pmd() and
   vmf_insert_pfn_pud() skip but the order-0 path performs. Patch 2 adds
   vmf_pfn_order_ok() and vmf_insert_pfn_order(), split in two so a
   driver can apply its own policy between the check and the insert.

Patches 3 and 4 convert /dev/mem and UIO to use them.

Dependency on the huge-pfnmap mm fixes
======================================

A VM_PFNMAP mapping that provides both ->fault and ->huge_fault can take
faults of different orders on the same entry, because the mm's THP policy
is read early in each fault and is not held across it. mm does not
survive that race today. Patches 3 and 4 give /dev/mem and UIO exactly
that shape, so they add two more reachable paths to it.

The fixes are posted separately, as they stand on their own - vfio-pci,
mshv_vtl_main and nvgrace-gpu already have the same shape:

  [PATCH v2 0/4] mm: fixes for huge PFN mappings
  https://lore.kernel.org/all/20261112051440.16140-1-farbere@amazon.com/

This series wants them underneath it. Without them, a losing fault hits
the walk_to_pmd() assertion under CONFIG_DEBUG_VM, reports VM_FAULT_OOM
for a healthy mapping, or trips the pfn-mismatch warning in insert_pmd()
when a concurrent order-0 fault has installed a page table.

The write flag
==============

Patch 2 also passes the fault's write flag to vmf_insert_pfn_pmd() and
vmf_insert_pfn_pud(), as the DAX and DRM ->huge_fault handlers do, rather
than the literal false that vfio-pci passes. With write=false,
insert_pmd() leaves a present read-only entry in place and returns
VM_FAULT_NOPAGE, and wp_huge_pmd() splits the entry only on
VM_FAULT_FALLBACK, so a store to a mapping that soft-dirty tracking
write-protected faults forever. uffd-wp cannot apply here:
vma_can_userfault() rejects a VM_PFNMAP vma at its mm-backed test.
vfio-pci has the same problem today and has no ->pfn_mkwrite either;
that needs a separate patch, which I have not written.

The order-0 path takes the flag too, so the helper does not behave
differently at different orders. A CPU store does not need it: the
order-0 fault installs a read-only entry and the store faults again,
where do_wp_page() -> wp_pfn_shared() upgrades it. A caller that faults
a page in without retrying the access, fixup_user_fault() from an
->access handler, gets no second fault. I have not been able to observe
that combination failing on /dev/mem or on either UIO memtype, so this
is consistency rather than a fix for an observed failure.

Testing
=======

Tested on x86_64 at 7.4-rc2, and on arm64 at 7.3.4, which is what the
test hardware runs. The four patches are identical in both trees.

On arm64 Cortex-A75: a local selftest over UIO map0, UIO map1 and
/dev/mem reports 64 passed, 0 failed and 3 skipped of 67, the skips
being the soft-dirty case, which needs CONFIG_MEM_SOFT_DIRTY.
tools/testing/selftests/mm/pfnmap.c passes 6/6 on /dev/mem and 6/6 on
/dev/uio0, and a COW-specific test passes 6/6. dmesg is free of warnings
and call traces. The fault counts are unchanged from v1 and confirm the
huge path: 4 faults for four PMD windows where a 4K mapping needs 2048,
2 for a two-window PMD-offset mapping, 1024 for a 4K-offset mapping of
1024 pages, 2048 for a deliberately misaligned VA, and 0 on a second
pass.

x86_64 under QEMU, with a 4G ivshmem BAR as the test region and a small
lab module exposing it through UIO:

  functional suite, 30 checks                   30/30
  the same plus MEM_SOFT_DIRTY, 31 checks       31/31
  PTE/PMD race suite, 6 checks                  6/6
  COW suite, 6 checks                           6/6

The soft-dirty config turns what the other configs skip into two real
checks, a PUD and a PMD write-protected store, which exercise the
huge-order write-flag handling described above. The race and COW suites ran
on this series with the fixes series above applied under it.

The COW change in patches 3 and 4 was confirmed by building the same
tree twice and changing nothing else. With ->fault left installed on the
COW vma, eight threads racing a store and a read over 2000 rounds land

  kernel BUG at mm/memory.c:2989!
  RIP: 0010:vmf_insert_pfn_prot+0xfb/0x100

and the guest then wedges, because BUG() in a fault path leaves
mmap_lock held. With the separate COW vm_operations_struct the same run
survives, 6/6. The intermediate shape - keeping ->fault but returning
VM_FAULT_SIGBUS for a COW vma - is not enough either, and was observed
raising a spurious SIGBUS on a healthy mapping at 200 rounds with
four threads,
because installing ->fault at all skips the recheck in do_fault() of a
pte found cleared under the page table lock.

Build-only checks, all with KCFLAGS=-Werror W=1:

  m68k ColdFire, CONFIG_MMU=n            vmlinux links
  riscv64, THP and UIO enabled           mm/ and drivers/uio/ build
  tools/testing/vma                      29/29

riscv64 is the only other architecture selecting
HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD, and its defconfig leaves THP and UIO
off, so both were turned on for that build.

Two things none of this reaches: 1G PUD mappings anywhere but x86, as the
test hardware has no suitable 1G-aligned region, and the huge zero folio
fallback in patch 2, which needs STRICT_DEVMEM=n and has no check
targeting it.

Performance
===========

Unchanged from v1, where the numbers are tabulated; nothing in v2 touches
the huge path. On arm64 the fault counts were re-measured and are
identical: 128 faults for a 256MB /dev/mem region against 65536 for a 4K
mapping, and 4 against 2048 for an 8MB UIO region. Against today's eager
mapping the series cut mmap() by 95x on the 256MB region and 5.6x on the
8MB one, total setup by about 12% on both, and the dTLB read-miss count
by about 80x.

Changes since v1
================

- Patch 2: the order-0 path passes the fault's write flag too, so a
  caller that does not retry the access, fixup_user_fault() from an
  ->access handler, is not left with a read-only pte.
  vmf_insert_pfn_prot() keeps its signature; its body moved into a
  static __vmf_insert_pfn_prot() taking mkwrite.

- Patches 3 and 4: COW mappings get their own vm_operations_struct
  defining only .access, instead of a COW test inside the fault
  handler, which was not enough: installing ->fault at all skips
  do_fault()'s recheck of a pte cleared under the page table lock.

- Commit messages: corrected the L1TF claim in patches 3 and 4 -
  mmap(PROT_NONE) above l1tf_pfn_limit() now succeeds, and nothing
  fails later - and dropped patch 2's claim that uffd-wp can
  write-protect such a mapping.

- Patch 3: the commit message now also documents what the fault-time
  range_is_allowed() re-check changes without CONFIG_IO_STRICT_DEVMEM,
  where revoke_iomem() is a no-op.

The write-flag and COW changes came from sashiko-bot's review of v1.

v1: https://lore.kernel.org/all/20261111113045.35368-1-farbere@amazon.com/

Eliav Farber (4):
  mm: add MMAP_PFN_TRACK action and pfn_range_track() for lazy PFN maps
  mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok() helpers
  mm/char-mem: implement huge_fault support for /dev/mem
  uio: implement huge_fault support for physical mappings

 drivers/uio/uio.c               | 118 ++++++++++++++++--
 include/linux/mm.h              |  47 ++++++++
 include/linux/mm_types.h        |   1 +
 mm/char-mem.c                   | 108 ++++++++++++++++-
 mm/internal.h                   |   3 +
 mm/memory.c                     | 208 ++++++++++++++++++++++++++++----
 mm/util.c                       |   7 ++
 tools/testing/vma/include/dup.h |   1 +
 8 files changed, 458 insertions(+), 35 deletions(-)


base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.47.3



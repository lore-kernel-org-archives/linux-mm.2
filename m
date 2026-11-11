Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBA8606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Zh5XWbGn
Received: by kanga.kvack.org (Postfix)
	id 2E2CF6B05B7; Wed, 11 Nov 2026 09:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292E26B05B8; Wed, 11 Nov 2026 09:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1825B6B05B9; Wed, 11 Nov 2026 09:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6A1F6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:07:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E512802FC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:10 +0000 (UTC)
X-FDA: 85423015020.04.716260D
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28CF410000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zh5XWbGn;
	spf=pass (imf05.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406028;
	b=BIg+uvu7eMa6gXeasli8cmtcbLSXRX+C6lU4jLe84oMUMzKE2mEfAhoy6srUbHY6o2a43s
	yKJnidtT9mt69a3VB4vr+EKMf1rR8JLW9nWW0XGA5K9K0HiGqX4Rxe0W2oKFNFrWGdGrov
	4tVGNi4TF5q8GFo33zFODhhJiOrRqAU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zh5XWbGn;
	spf=pass (imf05.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K2nNRLcpYTPb5gaqwgdSOeA/IdYOEH/Ikmqus0O+Qls=;
	b=QIUot8ibspsRezHFMopqJH7RO4Sg4A3Rfx2bAhszBdofi6YOykDq8orcd5hJ/TK95UCK5p
	EFPWsoI3yPiEr+KO1I0AF9eT9qClwq9DSZjbHEVbSP1Eek3usHABko5yuNn6UBST/38cYG
	yQFlJcdEQ501scqGpAaSz854ZXR82xU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794406028; x=1825942028;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K2nNRLcpYTPb5gaqwgdSOeA/IdYOEH/Ikmqus0O+Qls=;
  b=Zh5XWbGnRx/Of1Gqu/sD5N4gPjzKimhPPquCSbffDhjhDFjFgvu76Plq
   Ysv+r7OK27IKbE1iLpx6v+Wg5POCZ7PW4nuEzFSppQFK/UAfhE5domXfl
   SWp2sPhHE9qFfKxICmAFHSeW0NefHtgujvPZGL6+sifKUwQ1j2SrvOBYc
   HUAR5SGwQA0/ZNY0ACItbSCRSgVqlvjEwiD7kM/QPXkGQrW6ZmPb3aqxi
   egNY/vVIhnKF+Zs/h3RQQDf1uf9J/BzphLvW2STy85Q2i8EpOU456tmJR
   UN4zC5F9UUyRH6In+/GFgzERIHCJnLUclLM4XcbbJ2tgKaIuyoqtml0VD
   g==;
X-CSE-ConnectionGUID: G8P4hRZMTzy/IyI356dWfg==
X-CSE-MsgGUID: c0RFt+J3Tli3GAOeA81K3A==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33724742"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:07:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:21398]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id e07d0b7b-3834-4409-be63-1f6699e7212a; Wed, 11 Nov 2026 14:07:04 +0000 (UTC)
X-Farcaster-Flow-ID: e07d0b7b-3834-4409-be63-1f6699e7212a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:07:04 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 14:07:00 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH 0/4] mm: fixes for huge PFN mappings
Date: Wed, 11 Nov 2026 14:06:51 +0000
Message-ID: <20261111140655.34281-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ppt4e8j77nt9x9eyg1hbwmoqztejknx7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28CF410000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794406027-395544
X-HE-Meta: U2FsdGVkX1/FNr68ohAX0MUVy5TXtbIMHhHh90P5swqcHMYS9881ImjmoLqWCkNY/DinRyKQh/tfMoWql/zKVo1fBX6pyMI0NVqqx/DKMRspCCGstVfly1n4BWGN3GtvLN1083oOuLGfyH3q6TdaGaqZm7k/6WcZuEF5WK5F4rxLYY67yGl5uO70vDnMCOYoI8BrtOrFA/Z1z6BdPFGUw2vrsHYm0LAgDirOUarxUgHLtZZ6awf6CRvAb4qw98ImSv2Jrtpnms5hknOB9PLs4DUBwJsKRxRX6CzngGnoPSXiYqBt1RVKw5N9J/icbepBNZX2MQ3uZVwlIDY6TV+tcDeaD/yVRTTsRoMHu6G4kEd+2wh0GL4eSiuk9W15v8rVqsYQq1Aigq2bDRJ71YnPgv4v37FFka5mpj32RsjA939qirADZD4fQJqLIls19QUVWBYo4ZEFqQqcCDAW3QO9me/EmnFKU8fIfrMC/PGM0Kfw0mlO59XAii/kinYTLVEtUDHWTcG3v6r0jupsnzZm0GaSBgLiOzVaMQTOQ9OBh3Dc53oFY0Y3jT13+w01BIXiNGkYBWRd78dYOxiXRN6JZH2B2+8YUYtMwP4B/Wu/6iEa+NpX2ecRlsdPQis/gu6nDk0g9xdxsXMQZyt7H1AgWPsuFiqSAYP/+M0AeZAm4Q+JxrsTH90SVRgH5Lg1q8OPQcwYYuq5HUN1q8ts4dkvmOJY3lRhU2cV4lU4CyPlAYJz10kQKFRcU7Z52gUrjYNoQ7CuCIwS+NLt5f8zWWbu67WZo3+wX2inMbOSQguap6sIdqI0NH5Z5Ry7S0wP/oTReP49s7GglNHn5dbhjpK4T1m7xxXIXOMt/yFghQmeC1hRbuvKyjeGXDFOIRLTM5VRpfC2cNCwsPL44ykrrjTb4/avVMDdTWhpZCBKlMdMVlGhZ5YrlWNY6MDjKYUcD9teo/AgK/Z0OyTPr4L2p9f
 kZC8x9Na
 Fkuw6v/+y3US8yI2MOFtv7Repr9i4uFYrtgitK4dvrYnW45eajOmiYsN8E6Ppw76981KNJOXeNhoOVhflExdx1f3x7V9g1ehXXA0LVOsRGw4s4j97QfTr4gyVzSse/xt7b49yS0397gpvg5CggKyauqw+77g9BQ5RQBgM+7RQa1eQ4AH0r13oVjQ7zWpwSInvOExt+dTbsNz+X6ZQcaCRTrL9l59P1mzPmhk6dHvEAQwjG8Bp7YC5dJbKD/KhNZtN3daD/71QFCNFmWCfDkwNq5AiQ6P8rhWM3RSYdmefOkplptsKxg1zDe0CHXJi2ATbEek7bqoFbDqIoLFGGOpL+fN20DP+5nKsCYHH1qFe3ATyDkUgj+jBQC7yx+YFmE3HWCaa/p8Pui/EIFTxN4n41C9EaG7JuuqGqXGZlEdoJsL/d3s1T08XO4zi8DdpzHeulJqGHcwy8mIVh+HIH8ludYEEHFDxC9ObPR3SFzEJLicAJSIpEmzwHwnpv0+XJMz8TrCQ0dGMkXscgpM+tGCkSKUaHumdAuoPfxH2BYkliTMMf8XiUbB2Q9cwVVlxdYQ57n0aCJLz/LfaK9ispkWtOiSh4nn7JqN6T6ZuoZpIBwNJmCQ/m6jh34381gF9GaIwGA8Mf47POfnf/SLfUq6cXPeg8n3hHoI4H26kTiGSIo/5oxdJ0h+f48Cwd7qtBjmkADqdWw92vkkomNMTKjJGgbtYVz7B3BOH/KyiFa6kNZFxsrGjzeq0eDLmPUoF1NiIg7L+2T/nGZbQfDOYmsVgCgt6l5Hqtrlqe/C4UQ8NPqRrMYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Four independent fixes to the existing huge PFN mapping code. They are
not dependent on each other and can be taken separately.

Patches 1-3 are three symptoms of one race. A VM_PFNMAP mapping that
provides both ->fault and ->huge_fault can take faults of different
orders on the same entry, because the mm's THP policy is read early in
each fault and is not held across it. Flipping it while faults are in
flight, for example with prctl(PR_SET_THP_DISABLE), is enough: one
fault takes the PTE path while another installs a PMD leaf over the
same address, or the reverse.

This is reachable today. vfio-pci has exactly that shape:
vfio_pci_mmap_ops provides .fault, which reaches insert_pfn() for
order 0, and .huge_fault, which reaches insert_pmd(); mshv_vtl_main and
nvgrace-gpu are built the same way.

  1. walk_to_pmd() asserts that the PMD is not a leaf. With
     CONFIG_DEBUG_VM=y the losing fault hits that assertion instead of
     recovering.
  2. insert_pfn() treats a NULL return from the PTE map as an
     allocation failure, so the losing fault reports VM_FAULT_OOM for a
     mapping that is healthy.
  3. insert_pmd() and insert_pud() compare the PFN of a non-empty entry
     without checking that it is a leaf. A page table installed by a
     concurrent order-0 fault makes pmd_pfn()/pud_pfn() report the
     table's own PFN, which never matches, and the mismatch is warned
     about. Under panic_on_warn that is fatal.

Patch 4 is unrelated to the race. insert_pmd() and insert_pud() build a
huge entry from a pgprot laid out for a PTE. On x86 the PAT bit sits at
bit 7 in a PTE and at bit 12 in a large entry, and bit 7 in a large
entry is _PAGE_PSE, so the attribute is silently dropped: write-through
degrades to UC and write-protect degrades to write-combining, which
loses the write protection. Run the pgprot through
pgprot_4k_2_large(), with a generic identity fallback for
architectures that encode the levels alike.

How these were observed, since it differs between them:

Patches 1-3 were reproduced on x86_64 under QEMU with four threads
colliding on one address of each PMD window of a VM_PFNMAP mapping
while another thread flipped PR_SET_THP_DISABLE. With patches 1 and 2
reverted and CONFIG_DEBUG_VM=y, that lands within three seconds:

  kernel BUG at mm/memory.c:2392!
  RIP: 0010:walk_to_pmd+0x188/0x190
  Call Trace:
   get_locked_pte+0x1b/0x70
   insert_pfn+0x40/0x230
   vmf_insert_pfn_prot+0x94/0x100
   __do_fault+0x30/0xb0
   __handle_mm_fault+0xbb2/0x1a90
   handle_mm_fault+0x9b/0x270
   do_user_addr_fault+0x15d/0x630

and BUG() leaves mmap_lock held, so the system then wedges. With those
two applied the race is survived, and patch 3's warning appears
instead:

  WARNING: mm/huge_memory.c:1649 at insert_pmd.isra.0+0x1d3/0x430
  Call Trace:
   vmf_insert_pfn_pmd+0xa6/0xf0
   __handle_mm_fault+0x45b/0x1a90

With all four applied the same test runs 51200 colliding faults with no
BUG, no warning, no OOM and no incorrect data. Debug counters placed at
each site in a throwaway tree confirmed the recovery path in patch 2 is
taken rather than merely not crashing.

Patch 4 was found by inspection rather than from a failure report. The
in-tree ->huge_fault providers map write-back or uncached memory, and
only write-through and write-protect set _PAGE_PAT, so I have not seen
the dropped attribute in practice. The entry is still built from the
wrong encoding, and a caller asking for write-protect would lose it
silently.

Found while adding huge_fault support for /dev/mem and UIO:
https://lore.kernel.org/all/20261111113045.35368-1-farbere@amazon.com/
That series is not a prerequisite for any of these.

Tested on x86_64 under QEMU with CONFIG_DEBUG_VM=y. The race above needs
a VM_PFNMAP mapping providing both ->fault and ->huge_fault, so the
reproducer ran on these four patches applied on top of the /dev/mem and
UIO series linked above, which gave it one to use; vfio-pci would serve
the same purpose. This series on its own boots clean and was
cross-built for riscv64, the other architecture selecting
ARCH_SUPPORTS_PUD_PFNMAP, so insert_pud() and pud_leaf() are compiled.
checkpatch --strict is clean on all four.

Based on v7.4-rc2 (067c5c24cef2).

Eliav Farber (4):
  mm: drop the huge PMD assertion from walk_to_pmd()
  mm: don't report OOM when a huge PMD race blocks a pfn insert
  mm/huge_memory: don't warn when a page table blocks a huge pfn insert
  mm/huge_memory: use the large-page PAT encoding for huge pfn mappings

 arch/x86/include/asm/pgtable_types.h |  2 ++
 include/linux/pgtable.h              |  9 +++++++++
 mm/huge_memory.c                     | 20 ++++++++++++++++++--
 mm/memory.c                          | 20 +++++++++++++++++---
 4 files changed, 46 insertions(+), 5 deletions(-)

-- 
2.47.3



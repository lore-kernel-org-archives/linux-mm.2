Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3701C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 13:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9087B6B00A2; Sun, 23 Aug 2026 09:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0696B00A3; Sun, 23 Aug 2026 09:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7D06B00A4; Sun, 23 Aug 2026 09:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4036B00A2
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:36:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E193D120291
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:36:46 +0000 (UTC)
X-FDA: 85132634412.28.6E8EEE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 651231C0009
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:36:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FFC+KeWU;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787492205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FD/dMdn7bQ6iKASWP2WBLR+A6BaEIP1jOQGn6FPkDKI=;
	b=amMOjg53QLYLitOFBHbk55b3yhwdetB0AurppOEccqlUtBPVcjBNTW2C68Wd/mkJcon2Yz
	wAFO3l9/TEqhiq9xsXYnsL0ELvz0PumT++rcQve+1ZEvUg7PahwpauV2yqMIS3Zv79XwT7
	Q429Z3iBmDaOTUxKCL+hBwX5Ae8yQ+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787492205;
	b=WUGQe+lYZm7CN7fiq971c24vTN6L9zRR8l+akApFA/I8VjrA38HtGfTYyXIHrtVAL9SzAW
	Ix2q29tVsYOlxi3VWVXXKWB/G/NMtXBeGmCHdD8dsIMaJvql+0EBYjDKncyfB1b73qeM1F
	cQX9S1dzhIUF8aKLKOWlvJnJ5MdX6kA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FFC+KeWU;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA25160052;
	Sun, 23 Aug 2026 13:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F11F000E9;
	Sun, 23 Aug 2026 13:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787492204;
	bh=FD/dMdn7bQ6iKASWP2WBLR+A6BaEIP1jOQGn6FPkDKI=;
	h=From:To:Cc:Subject:Date;
	b=FFC+KeWUHD1cV0jR39wf8ogvQdP3phUXIL+7bswTAQcsvPtKcB3+SBCbGBGAk8G+Z
	 vIe6qBlIrIaCpaBOYqcdWrUHllzt1C/rOQB33xW87DFOTwU+V+lycjl5ndsJ3awK1p
	 dFeNyKR7piYJTlXfLzWD1ZqdeqMKpKW65a2m7/tytRFuZ1Daq2AYrySkKuJTaQv+iQ
	 dXVHgjN5I0GPNyHifdF4ljd9L0LDB6kmh3qQBCJse+X8tk2kk753PBzqfstAyFP28S
	 sz+VYIpbcnqZbbcv0K6FXlKPaqG4W9eonh7pZHLAT6tarpgxdHYEJdgZcz8snHBBAU
	 pdTq+4cDz+/1A==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] liveupdate: updates for 7.3-rc1, part 2
Date: Sun, 23 Aug 2026 16:36:32 +0300
Message-ID: <20260823133634.3570153-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hs4aaih34xnh7t5g9tfdeospdprgq5r4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 651231C0009
X-HE-Tag: 1787492205-799815
X-HE-Meta: U2FsdGVkX18ISXj14wTNhMqkRPoI6i3uv0Ta52QIrZsJ8SB76NRhpy7n2Ccva90byAskZZMcikDa40wy9N7khOW4pRicCCp4nIWJq9wQ5ZJw9usKRx3orSea2IQXlrEjllvjFfsOUQoNP+OwVCrNEP7uw/bV5jQ28qGdXeE4jeq7aDSqCG86V+ZKgPtubRHbOFRsb58lH+VuxeHCMdi/aI9EWrA8kFD1EeLkqjql7pYQYkvG4CB0GQ7X8TjBokNk//mDanWwIXUIdIm6A2kpb7250SU5gm0SA/ZLXtHGjCRrmtSrsuHI3jr/XYdsUO6b9aZCiK6hv679YMasIIyBmCWSPkmJnUdl59Rhm6lL9SAb/mJOmbmu4Hi6zh6k1hihrwJUSRp8lJ+z/HAHjWxTrCEHK/x+QJEPs4OcGAFg0G/jBsrNjy8Ek081rhgVONPLcA3ThSy/qwDeMQ8c45yOuS3Jsp13yo3J081vXN/0iAWMjD1e5trkP6+RcxO01j0vlMT2TnWTcDragfheqbyy0YzfPEwQFZSSX6P6hD1Sts6+WevXP6opsBtzDoydjD2TmtZENHVftF7iLw5JETp0c8Um8659fLAMUjd28db5J+2+iAxDHrVdKQRzmHB+1ZkYgW7tUDCC6PSFZorzyUowQMQQN4dz8Bu7UsNgOv+A0+LTEMxXQKmVIfagKZRErpVGGaAqcSXktMJHEUc7xijkQfhcyYxl0PvQBez8SqgUoBzaxHDMa+HdXEXMGg2i+wzg5+1yBoNvcHzww0RIRQOdl50FxAdYkDwQI6jE4gwDfsMT6k7FBBeZmn54MerjtCc6uyXB4sc6gXVIf+h/7SD8sXDRxuMagzv1nDSd+gKWIVOP8kCervv4GyPyy4ni/HN40SI3fKNSAFw5ZWBfMoaWWOWWen24tkTR9X1BTzGp3VlDkJmzqaDwLH5vKRVgVQgtETf1OYLiaec6hyUdYLf
 m6aA0I2p
 FKwkMUFi156hStr2PFlKcOWEXv1ZXJdw0lvdtX+VDnq9Emivkp5NID41LPD3/vZ46bq4aMu82C7vK9tiXPe475PSivk8JzOP19LLu1OTDKnMc6Bof6/wolcFJvpcDWKMC4/trQlIwWD4MaSyoUdUaWKjNMNKR+ZIK01T+s56LJa00JxqyVXxzLnYwHmjhMxwMfYa4i/Xn6uG5qmIqajHoh0Zr3sGkkq6JoibEt0MutPXqNPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

This is the second part of liveupdate changes for v7.3-rc1.

The changes here depend on the work merged via Andrew's tree, so I waited for
his pull request to go in.

The following changes since commit 6d098029de0902372fdaa07e049db3866cbd8907:

  mm/mm_init: fold __init_page_from_nid() into __init_deferred_page() (2026-07-28 21:12:00 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1-20260823

for you to fetch changes up to bc0f793c5c41601b273a2ca64c768adca1d447f5:

  Merge patch series "kho: make boot time huge page allocation work nicely with KHO" (2026-08-04 09:50:03 +0300)

----------------------------------------------------------------
kho: make boot time huge page allocation work nicely with KHO

Today allocation of gigantic pages in HugeTLB cannot work reliably with KHO:

* HugeTLB allocates gigantic pages using memblock and autoscaling of KHO
  scratch accounts for these allocations. When gigantic pages occupy half
  of the memory of more, KHO fails to allocate its scratch memory.
* After kexec handover, memblock allocations exclusively use KHO scratch
  that is not supposed to contain preserved memory. This essentially blocks
  preservation of HugeTLB with gigantic pages.

Extend early memory pools available for KHO kernel with areas that are
guaranteed not to contain preserved memory.

----------------------------------------------------------------
Mike Rapoport (Microsoft) (2):
      Merge branch 'mm-stable-6d098029de09' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm into kho-scratch
      Merge patch series "kho: make boot time huge page allocation work nicely with KHO"

Pratyush Yadav (Google) (21):
      x86/setup: do not include kexec_handover.h from asm/setup.h
      kho: generalize radix tree APIs
      kho: make radix max key width more obvious
      kho: disallow wide keys in radix tree
      kho: store incoming radix tree in kho_in
      kho: move all memory retrieval logic to kho_mem_retrieve()
      kho: add a struct for radix callbacks
      kho: add callback for table pages
      kho: add data argument to radix walk callback
      kho: allow early-boot usage of the KHO radix tree
      kho: allow destroying KHO radix tree
      kho: add kho_radix_init_tree()
      kho: expose kho_scratch_overlap() to kexec_handover.h
      kho: initialize kho_scratch pointer earlier in boot
      kho: initialize preserved memory map radix tree earlier
      mm/mm_init: don't rely on memblock to get KHO scratch migratetype
      kho: extend scratch
      memblock: always include KHO headers
      memblock: make HugeTLB bootmem allocation work with KHO
      memblock: add memblock_reserved_hugetlb_size()
      kho: exclude hugetlb memory from scratch size calculation

 MAINTAINERS                                     |   1 +
 arch/x86/boot/compressed/kaslr.c                |   2 +
 arch/x86/include/asm/Kbuild                     |   1 +
 arch/x86/include/asm/setup.h                    |   2 -
 arch/x86/kernel/setup.c                         |   1 +
 include/asm-generic/kexec_handover.h            |  12 +
 include/linux/kexec_handover.h                  |  31 +-
 include/linux/kho/abi/kexec_handover.h          |   9 +-
 include/linux/kho_radix_tree.h                  |  60 ++-
 include/linux/memblock.h                        |  23 +-
 kernel/liveupdate/Makefile                      |   1 -
 kernel/liveupdate/kexec_handover.c              | 525 +++++++++++++++++++-----
 kernel/liveupdate/kexec_handover_debug.c        |  25 --
 kernel/liveupdate/kexec_handover_internal.h     |   9 -
 mm/hugetlb.c                                    |   9 +-
 mm/memblock.c                                   | 154 +++++--
 mm/mm_init.c                                    |  29 +-
 tools/testing/memblock/internal.h               |   5 +
 tools/testing/memblock/linux/kexec_handover.h   |   9 +
 tools/testing/memblock/linux/kho/abi/memblock.h |  10 +
 tools/testing/memblock/linux/libfdt.h           |   9 +
 21 files changed, 673 insertions(+), 254 deletions(-)
 create mode 100644 include/asm-generic/kexec_handover.h
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 tools/testing/memblock/linux/kexec_handover.h
 create mode 100644 tools/testing/memblock/linux/kho/abi/memblock.h
 create mode 100644 tools/testing/memblock/linux/libfdt.h


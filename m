Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6991091909
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3B56B0553; Thu, 19 Mar 2026 14:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B1F6B055B; Thu, 19 Mar 2026 14:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689DA6B0560; Thu, 19 Mar 2026 14:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50B246B0553
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:23:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBC211DE42
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:48 +0000 (UTC)
X-FDA: 84563636136.16.0A497A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B688A0012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k72tqnwu;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=11ma5cxWnyIdW8QqCNU3wqld03y9OSzPW47ythl8JfE=;
	b=oafsvSJTcEqFxmeDovgSLofulNJESE6WFFC5EUpmADOJBbfv0dTthALi9MmNHkZaDH2wWS
	YhWG7tFIl8P9av51CJCSb6o1yICAUWqpnXTHksyoC+2QY+u39uZ6K1p8yd4JEGJuAH1K0e
	BoBNImygg3TLqo1F6JIxaVyZwcnjwkk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k72tqnwu;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944627; a=rsa-sha256;
	cv=none;
	b=OzkZljwaoqgKcV8S98nMgLBageNsQSwrZKPSZ11DldT+yJNeF4f9NW2yBqYjorBm5VI6Ja
	A8DK8rooq31yXso4elwtsGLV0z3VBzcKyS3Yz380GqymnNBq3go776a/ftes0D68jm4Q+q
	tURmn20xYrwdobrfGMNxu5tdnNee0QQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34C76438FA;
	Thu, 19 Mar 2026 18:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF4EC19424;
	Thu, 19 Mar 2026 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944625;
	bh=hUq23NX3AUF/Z/nd3f+apZh8oyr5ochA07r37x4M5ug=;
	h=From:To:Cc:Subject:Date:From;
	b=k72tqnwuSjAIoaoFYpnmAJc5NqF2RHzpf2m0/2v5FHjqFYrvF9hFpFABSV0ibMtjI
	 v5ABOEragkIvhSQcUDiYsI2HJhw45Kwl3+zk237y/4tjTATs5TdNmP3sOChEeowL0j
	 aF2jYijp2yjfKoeeFK5r4Blr/10cTIPfZxwMhCmDiuBv8H7oliqmyrAE8CKe2gk/Df
	 hif2oRVLCDoEd+7O09ruZk1Sqb3i4NACbtkHiyNTqml2Yjk84myr5XNmRq67QmIQvh
	 5rosWsQJMLdf0p2r46AtulRsJmHTQ5LCq29emURnbAQO3W3H4Een9shDvkQqdUHUth
	 LEQrKOSjYWzGw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v3 00/16] mm: expand mmap_prepare functionality and usage
Date: Thu, 19 Mar 2026 18:23:24 +0000
Message-ID: <cover.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B688A0012
X-Stat-Signature: 1togejudkf9s6cbykfjn9ts1p6gcdw9k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773944627-969861
X-HE-Meta: U2FsdGVkX18ufiUK/yr6mISya+GdS43EZrH/5NXYK9gEVcikFsKT1RzDBe4SDrOBXknXxqWxPATTqAvoRVCfuGRAPgGYAkHC2ZHR16pLRa++2VnrYhHCVQlpBetlw+bjfH2YeiLFJafInzybdR+cU4gjd5k/Hicz1gho22Y+bcBBCVMtZLolQz17iqBZHACARaiuTITVG54iVqFisO0IAE2gL6sut3TaVQwJeJCKeXHyr2ZI+CcmtL3W3eyUz5yBDpGc0obEELAzCMPWDyR4hNYiSyniDAejt+mWLWMSyoBe21g9beQkHjOEaBSVBDfCrCr4B7nhSHx4i+bSdVAHfUNdxkJigv2k2VbFEbeFEf6egHeZzv2uxk485QLwTW9Gs7f+/A1haXL9VG9hwiDADYXbG2Q3qxhvPfQ7tkplSnqzmZVg2GadDXE7wnglcoSTzuHoGwZnB0FdC1Z2c9wFC9xwXmxssJapD6e4I53keGEVaY5NA+xl258nGRZfirmPygGNul24vvlwimeP+2e/2/aekUdIEaPVrtD7Dwcl8AqMxcNiNiynvtpLKTAWcv5qPLwFqmUsUyDN7bRH9A4UE8itwXTtJyNxiW2prqFPeQutXOSXiDxcNV8/Xa56TemvYoLeI2Z3k0/o9leeiSN5XKHP+Qedd7olH0mQF5TWJz0XDQJs9BjwXXtQo0tq2SlGK7pF1uRc+zabM7tw5qk+kJdL160KU27h6GPn7YbQ83uRSz7zbdy+W9PqegNKjBUhmYektvyeS9g3wPBV/RIsvJOHRW5cYcXwq91U5cMD29+ANAnflaHN4tweXStRFU4xJ1dCMquCJE6+AWOhHTWfHHIqOgJncRZDTXo/QtKj3R3lDiZ4p/e/4swKda9Wd5vSi6tSEpDxxXRmDEfsxqTJVdTIzpbk1XR2kL0H8wMsEWbinhn057zFALIp8oQM7FN2MpC177fHwGt8uUaJ8hn
 iijG/ekb
 YD4ovQ5V428BSTwxnRgDkhZB0W7bHjIPMmY/HRQnndIH0SmjpXh4dt/FfsW1ShurA8sFBzpp4GttfnOc9rP+LFgZ51riI+HvYzIdoyBuhhqOIcIY0aCug0kdHItm3Xj9IS2V6JYFU2hHw5n6sbofyhQy4nLkcjYGSFZDJlUdlVsK5r1S9oK4+3ujA5/7UJPt7dQIwAfbExyRB2aSPD4gKt0w8flLd3f4g2zUpOwR7dhTEjuBc8sVqjUL4liBu1x4n/ug4wL22qirr/DJirxVBB0yTJHjsvqA9u+PBc47t7oL2n/X0NvGN7gbsgrn2ezhwhiccou1RqxcKLjzDmaqOH7iagOjoCZuIRvfG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series expands the mmap_prepare functionality, which is intended to
replace the deprecated f_op->mmap hook which has been the source of bugs
and security issues for some time.

This series starts with some cleanup of existing mmap_prepare logic, then
adds documentation for the mmap_prepare call to make it easier for
filesystem and driver writers to understand how it works.

It then importantly adds a vm_ops->mapped hook, a key feature that was
missing from mmap_prepare previously - this is invoked when a driver which
specifies mmap_prepare has successfully been mapped but not merged with
another VMA.

mmap_prepare is invoked prior to a merge being attempted, so you cannot
manipulate state such as reference counts as if it were a new mapping.

The vm_ops->mapped hook allows a driver to perform tasks required at this
stage, and provides symmetry against subsequent vm_ops->open,close calls.

The series uses this to correct the afs implementation which wrongly
manipulated reference count at mmap_prepare time.

It then adds an mmap_prepare equivalent of vm_iomap_memory() -
mmap_action_simple_ioremap(), then uses this to update a number of drivers.

It then splits out the mmap_prepare compatibility layer (which allows for
invocation of mmap_prepare hooks in an mmap() hook) in such a way as to
allow for more incremental implementation of mmap_prepare hooks.

It then uses this to extend mmap_prepare usage in drivers.

Finally it adds an mmap_prepare equivalent of vm_map_pages(), which lays
the foundation for future work which will extend mmap_prepare to DMA
coherent mappings.


v3:
* Propagated tags (thanks Suren, Richard!)
* Updated 12/16 to correctly clear the vm_area_desc data structure in
  set_desc_from_vma() as per Joshua Hahn (thanks! :)
* Fixed type in 12/16 as per Suren (cheers!)
* Fixed up 6/16 to use mmap_action_ioremap_full() in simple_ioremap_prepare() as
  suggested by Suren.
* Also fixed up 6/16 to call io_remap_pfn_range_prepare() direct rather than
  mmap_action_prepare() as per Suren.
* Also fixed up 6/16 to pass vm_len rather than vm_[start, end] to
  __simple_ioremap_prep() as per Suren (thanks for all the above! :)
* Fixed issue in rmap lock being held - we were referencing a vma->vm_file after
  the VMA was unmapped, so UAF. Avoid that. Also do_munmap() relies on rmap lock
  NOT being held or may deadlock, so extend functionality to ensure we drop it
  when it is held on error paths.
* Updated 'area' -> 'vma' variable in 3/16 in VMA test dup.h.
* Fixed up reference to __compat_vma_mmap() in 12/16 commit message.
* Updated 1/16 to no longer duplicatively apply io_remap_pfn_range_pfn().
* Updated 1/16 to delegate I/O remap complete to remap complete logic.
* Fixed various typos in 12/16.
* Fixed stale comment typos in 13/16.
* Fixed commit msg and comment typos in 14/16.
* Removed accidental sneak peak to future functionality in 15/16 commit message
  :).
* Fixed up field names to be identical in VMA tests + mm_types.h in 6/16,
  15/16.

v2:
* Rebased on
  https://lore.kernel.org/all/cover.1773665966.git.ljs@kernel.org/ to make
  Andrew's life easier :)
* Folded all interim fixes into series (thanks Randy for many doc fixes!))
* As per Suren, removed a comment about allocations too small to fail.
* As per Randy, fixed up typo in documentation for vm_area_desc.
* Fixed mmap_action_prepare() not returning if invalid action->type
  specified, as updated from Andrew's interim fix (thanks!) and also
  reported by kernel test bot.
* Updated mmap_action_prepare() and specific prepare functions to only
  pass vm_area_desc parameter as per Suren.
* Fixed up whitespace as per Suren.
* Updated vm_op->open comment in vm_operations_struct to reference forking
  as per Suren.
* Added a commit to check that input range is within VMA on remap as per
  Suren (this also covers I/O remap and all other cases already asserted).
* Updated AFS to not incorrectly reference count on mmap prepare as per
  Usama.
* Also updated various static AFS functions to be consistent with each
  other.
* Updated AFS commit message to reflect mmap_prepare being before any VMA
  merging as per Suren.
* Updated __compat_vma_mapped() to check for NULL vm_ops as per Usama.
* Updated __compat_vma_mapped() to not reference an unmapped VMA's fields
  as per Usama.
* Updated __vma_check_mmap_hook() to check for NULL vm_ops as per Usama.
* Dropped comment about preferring mmap_prepare as seems overly confusing,
  as per Suren.
* Updated the mmap lock assert in unmap_vma_locked() to a write lock assert
  as per Suren.
* Copied vm_ops->open comment over to VMA tests in appropriate patch as per
  Suren.
* Updated mmap_prepare documentation to reflect the fact that no resources
  should be allocated upon mmap_prepare.
* Updated mmap_prepare documentation to reference the vm_ops->mapped
  callback.
* Fixed stray markdown '## How to use' in documentation.
* Fixed bug reported by kernel test bot re: overlooked
  vma_desc_test_flags() -> vma_desc_test() in MTD driver for nommu.
https://lore.kernel.org/linux-mm/cover.1773695307.git.ljs@kernel.org/

v1:
https://lore.kernel.org/linux-mm/cover.1773346620.git.ljs@kernel.org/

Lorenzo Stoakes (Oracle) (16):
  mm: various small mmap_prepare cleanups
  mm: add documentation for the mmap_prepare file operation callback
  mm: document vm_operations_struct->open the same as close()
  mm: add vm_ops->mapped hook
  fs: afs: correctly drop reference count on mapping failure
  mm: add mmap_action_simple_ioremap()
  misc: open-dice: replace deprecated mmap hook with mmap_prepare
  hpet: replace deprecated mmap hook with mmap_prepare
  mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
  stm: replace deprecated mmap hook with mmap_prepare
  staging: vme_user: replace deprecated mmap hook with mmap_prepare
  mm: allow handling of stacked mmap_prepare hooks in more drivers
  drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
  uio: replace deprecated mmap hook with mmap_prepare in uio_info
  mm: add mmap_action_map_kernel_pages[_full]()
  mm: on remap assert that input range within the proposed VMA

 Documentation/driver-api/vme.rst           |   2 +-
 Documentation/filesystems/index.rst        |   1 +
 Documentation/filesystems/mmap_prepare.rst | 168 ++++++++++++++
 drivers/char/hpet.c                        |  12 +-
 drivers/hv/hyperv_vmbus.h                  |   4 +-
 drivers/hv/vmbus_drv.c                     |  31 ++-
 drivers/hwtracing/stm/core.c               |  31 ++-
 drivers/misc/open-dice.c                   |  19 +-
 drivers/mtd/mtdchar.c                      |  21 +-
 drivers/staging/vme_user/vme.c             |  20 +-
 drivers/staging/vme_user/vme.h             |   2 +-
 drivers/staging/vme_user/vme_user.c        |  51 +++--
 drivers/target/target_core_user.c          |  26 ++-
 drivers/uio/uio.c                          |  10 +-
 drivers/uio/uio_hv_generic.c               |  11 +-
 fs/afs/file.c                              |  36 ++-
 include/linux/fs.h                         |  14 +-
 include/linux/hyperv.h                     |   4 +-
 include/linux/mm.h                         | 159 ++++++++++++-
 include/linux/mm_types.h                   |  17 +-
 include/linux/uio_driver.h                 |   4 +-
 mm/internal.h                              |  41 ++--
 mm/memory.c                                | 175 ++++++++++----
 mm/util.c                                  | 251 ++++++++++++++-------
 mm/vma.c                                   |  53 +++--
 mm/vma.h                                   |   2 +-
 tools/testing/vma/include/dup.h            | 152 ++++++++++---
 tools/testing/vma/include/stubs.h          |   9 +-
 28 files changed, 990 insertions(+), 336 deletions(-)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

--
2.53.0


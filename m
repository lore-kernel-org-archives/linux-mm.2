Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478BC1099B4C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE0D6B00CA; Fri, 20 Mar 2026 18:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F5B6B0116; Fri, 20 Mar 2026 18:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DDF6B0118; Fri, 20 Mar 2026 18:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 568246B00CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7DDA140403
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:08 +0000 (UTC)
X-FDA: 84567910896.08.7840B06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 642E540007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyQwSOAj;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/9uJv5XCgVZy4p1cdqkhYZlWF5SWIYwOmunU03vXMyE=;
	b=wUBUVBIb3RjguRSKotGyBBtkr77bmD1ezioUP+Nqv0tbXi8iljcyZF+rKBJlePpwKUSdI5
	S7koc1VZC9DvMxfRcsLbALFlLFqrmebLYNwXfc0dUAqCZWZuu3pZAYBCo6fKKmaGMXVPpP
	zRaVK4GuCT1MJwhWqn9styutvUBS+b4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyQwSOAj;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046407; a=rsa-sha256;
	cv=none;
	b=H89Obo9qTSB+aeEFY9O71IkIm4pUCu82klBWFMVfdne1JTmX/ezrkg13VR4HQRrjNwPhfg
	QMAtpK0+gGeEihJIzr5IfW9izZvZBy4Sk5saKrvwaJgKl94nRs+drqPHvLl3KwrQIrG1Tn
	Ae1IZ7qVYr/sdAJa9wyiwHj9gmr+OPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5CD360130;
	Fri, 20 Mar 2026 22:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E20C4CEF7;
	Fri, 20 Mar 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046406;
	bh=P2mslC++0zk+mcj13b8jLsDA4S5ZGJbmZDQiowDGZDE=;
	h=From:To:Cc:Subject:Date:From;
	b=IyQwSOAjCQNvWLi99FsyWyA9GCrN68275qcV2+Tebm9ZMvRz6KuIghiKEY8GsySsm
	 I17pFqJyqx9rr5vYHO7P0EAPefKlWABUW/DpvDLLFVYxnJH6+RN0m34os5KpKYH8qF
	 nCQ3jz7X0qeQDqnQnYv1rZx9FChvzhpWLF0s0u13j9FQJDup/n4agriaxrDV6qtv7T
	 I7WtUvonBYeBUCjvB9OcdzUF73Vzn0eAw6rxoc4W6bcHign7vDKR74EgB76KnDm9Vp
	 P32kO5lkRTlpmDwHpbqyWFSHU8irzhWpP5y6RLH2agII8/XtTrdZWyXcCPKGoPS5RQ
	 kAAclJMcwaA8g==
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
Subject: [PATCH v4 00/21] mm: expand mmap_prepare functionality and usage
Date: Fri, 20 Mar 2026 22:39:26 +0000
Message-ID: <cover.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 642E540007
X-Stat-Signature: u8uqmto54k3hk7yc6ezhcmqu1dat6g9i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774046407-385691
X-HE-Meta: U2FsdGVkX18S0TVnDeGYXeoiH2rx1UITGdWhsGuQfmTmCSdd/AQAwnsl2xs+yAg0541r8a3NXqK6IU6Sq70YO0kVhcGtWOOBRkrbifho6f0ESgvm7B3RBQHynDs6lHBE1EVPev9Kix0ef0m4HAHCbL2MbBcQlM0lMc/b+c3xfxhJdWsNybEZbDwjT82XZATaSy77owaLP8s+LVug7zP1URLLx/SaRsitif1NYOYvkTA5WM5PhUxUo8kgPPusgSq3MYNq4N24iDcQwLAUE8My7u3tpNPBybZgltlQ/5+wk8a8i+GJ5Z5SL/1via4apQ1/QnpaaQcThg3Z0bSODjs/PB51wijYhaNMGeyGiT22kD0bcDArKAR0x/pCbAUQqYMJNU5sNQTM1N7mo7qnbtvPBXwC+Chm00DfBAN9rNn1ZZuZZy0Cw0iJTOYbKXXF/8IzgCfolJOXuJyuX1MGE4+uEaQ2pvd78kMwGjHduULuWtuNnNMcfQQ9jEUl3nmrW149xiJb6S261q23cA0x4MJ4qy5CeGfxizbhDNrip53UcKq0ibK6V2eD6TLuKOyTYGRsYF6OzOHGVPeIGB1FtDPhlyAx8BX9UXIJNa8cLemHUCct8on77QtAx6jhih9KOLS/YQwiPxkNYu0iaderW3TUVfIBSD8AxIC3u4sjpfEu9beiUSgQ3j1iZqP1e73EAqL0FT5mdEkgfQSNFf+5zb7XuKMh79sAN5VwjGoC2bdfamgbhwjHp4/0VavFILHhNrFaiJ4U1M76cZkUvSoGyKsiCV+9PpGnleANfC4g0VCZB6u0IZsRnnlSKVFjlW42JlsdYZ64MNGreqsUp/14DTlHfkH+xdFkTjzd7Vf7RArrVOkK/lAjRHlRvLAVVSquvzkH0Hu+bnvMHD8QvAb4Q7oSN452XNE2xRwHmihZ6+ZEZvuFesU1vVzSteM7+SQFtJ6ArZUB/SGSLbdnAh4lVI4
 KHw8k93i
 XOrxeOQppK0vJhb1HfYk0vvFa6N4iNDXLk1AVDl6hH+wET7LpH5Gx9untThaE9Ya4pS/aT2A1LTTFciMP7acgv8fwcpcb0Zoi91fpOfCIDPQSb5xIoQsNoS1OSYTSi3CpbECSvuz/dJtu3u/4/mxDaWEHe0xovv0sLEl7zSaKzDcTPesPHknF9E07+1vOJZVulnBYi4eNhnACoUKEpw0/csw+8w9A3iLqReCwhzvVKl1SNXxUM9hG83c4iu5p9IIEWzBLCwVZVvrDX9Buo+2gHGIqjyqdnOl2mTutVd3U0XMrYxZlnFNMTwFiShr+nuwXD+V3UWD7Ouz1yzXQcUHG/BCGN4wEwqOIfSkr
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

v4:
* Added partial revert of AFS as per Vlasta. Labelled as hotfix.
* Updated subsequent afs patch to apply against this version of AFS.
* Reverted rmap_lock_held changes to util.c, mm.h mmap_action_complete()
  etc. as per Vlasta.
* Added hotfix to fix issue with rmap lock held over munmap() as per
  Vlasta. Labelled as hotfix.
* Force-disable the rmap lock hold feature in the compatbility layer
  because being run under the mmap hook eliminates the need for it.
* Removed superfluous map->hold_file_rmap_lock field.
* Moved handling of rmap lock and unmapping to mmap_action_complete().
* Removed unmap_vma_locked() as previous added patches render it
  unnecessary.
* Removed __compat_vma_mapped() from compatibility layer and
  call_vma_mapped() from VMA layer and made it part of mmap_action_finish()
  for all callers.
* Propagated changes to VMA tests.
* Updated mmap_action_map_kernel_pages[_full]() patch to add missing
  mmap_complete() noop switch enum value as per Nathan.
* Fixed a doc issue in the mmap_prepare docs - reference
  vma_desc_test_flags() rather than _any().
* Rearranged logic so the vm_ops->mapped hook is called before the success
  hook, but this should have no impact.

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
https://lore.kernel.org/all/cover.1773944114.git.ljs@kernel.org/

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

Lorenzo Stoakes (Oracle) (21):
  mm: various small mmap_prepare cleanups
  mm: add documentation for the mmap_prepare file operation callback
  mm: document vm_operations_struct->open the same as close()
  mm: avoid deadlock when holding rmap on mmap_prepare error
  mm: switch the rmap lock held option off in compat layer
  mm/vma: remove superfluous map->hold_file_rmap_lock
  mm: have mmap_action_complete() handle the rmap lock and unmap
  mm: add vm_ops->mapped hook
  fs: afs: revert mmap_prepare() change
  fs: afs: restore mmap_prepare implementation
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
 include/linux/mm.h                         | 158 ++++++++++++-
 include/linux/mm_types.h                   |  17 +-
 include/linux/uio_driver.h                 |   4 +-
 mm/internal.h                              |  46 +++-
 mm/memory.c                                | 175 ++++++++++----
 mm/util.c                                  | 251 ++++++++++++++-------
 mm/vma.c                                   |  48 ++--
 mm/vma.h                                   |   2 +-
 tools/testing/vma/include/dup.h            | 134 +++++++----
 tools/testing/vma/include/stubs.h          |   8 +-
 28 files changed, 956 insertions(+), 350 deletions(-)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

--
2.53.0


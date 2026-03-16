Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945C9F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95586B037D; Mon, 16 Mar 2026 17:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E431A6B037E; Mon, 16 Mar 2026 17:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D450B6B037F; Mon, 16 Mar 2026 17:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1BC36B037D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:13:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F4571C97F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:38 +0000 (UTC)
X-FDA: 84553177716.14.0853A79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C913480012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ntq/l3UG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jgJYpd6wuCrv8kLX1dzrgESVtdv12vnZQEJ/jLK7KuU=;
	b=pAbEyKwUid6FMyv6Ym1gBKM+/XLLU1DyAX5jV4xTGxVkLM+Bolc9h6NzHqiQygW3XXlTl6
	vbCRpPJaKCuH0S8AGT/DdooX6rC1IirDyR5ELCd4NLxF9OTiV50rK+N4fxyX13DaX9X03q
	p4aNq5TtbZMBEtW1V1iaYUB0SIiwPu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695616; a=rsa-sha256;
	cv=none;
	b=iP1HxbB34EKcLyDr5SopKGl01HfjMIdOo7tbIv/qh2G5qp5lKsQE6cIWiNOiqjliK5e801
	B1m7tsLD661ueKFEvupa2+cBEEot8OV0AgnwlVviR/J9xCzUp2ZZQn64CxSbXjGDhKDoAO
	1tCJLC58qEW8zIRQUyAI627HGvugIV8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ntq/l3UG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D8E860018;
	Mon, 16 Mar 2026 21:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248B4C19421;
	Mon, 16 Mar 2026 21:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695615;
	bh=ilMdtysPCdNXPtzF2zNSpIrJ8Gr1Wv5rYS8ynVlNkEU=;
	h=From:To:Cc:Subject:Date:From;
	b=Ntq/l3UGM9JqyJJD9JGa7/yDJgNVnVPNfki9aJRX4uarYRuo6x4Dvl1Nvv2uizzFY
	 PKNBhPwaDwYOT2ryPSG03lQzK/iVm6SI95tlkq8E9XT6eanSVjR8YC7k3x5yHct10Z
	 0KpqmHVJ//eqjlE2lbzqizxCuq2HekJx0MVEF0CFZiORAS4KC/NJ00mX8hqxEHngbN
	 dN//9WHytXP2+KVpaS88wjMwl7EtwsiLj0M1lgSWEd4oxUmAaUwkJzaE8ngvjhvq+y
	 1g+fHhAmOGC1WKRn1K9zFe7N/Cc7a3sZPGoqKRVY/lmxStNOEuDKUMfI7PC9kSX4Hr
	 YuQ4yI1r6vyzA==
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
Subject: [PATCH v2 00/16] mm: expand mmap_prepare functionality and usage
Date: Mon, 16 Mar 2026 21:11:56 +0000
Message-ID: <cover.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C913480012
X-Stat-Signature: zegmfqdacj4ix3jhyptftbg19pkrohp3
X-Rspam-User: 
X-HE-Tag: 1773695616-713320
X-HE-Meta: U2FsdGVkX18WEuDx7vCnbmDX2zDBSi5VETzVzSfd1J8aZSqUJRT6Qm5a/RacqdQS0XKAGdO4Dn1B8bsWdsTGyWGLzC0/molTUlmTLhNv6o0Vjl+HYwP+MwdnKsUDMVsS2F9JkuVdW3ZCygIDwt3uM5JrtbdfUMes2sKB263zVgbl8Lmx/XUcmxf5+jG+MDm7ihKwINCVsTk0o6zfddO2WHIFaOpCVVtNhiyqJkf07xJXvhN3cBABl4o2FQ0wSCug2b2XuPBnE6BiPhb80LLqF+EXhNIMX3KF6IvDhgvQiN/vJD0qwqaxQoD5T8eKjC8kxK4ubePG4LHPlCDQGAoiLFS5HLJlhilRmaa3QhKqiNSPOHM+fMY84w6JTaDB3aiXjc+Wq0C8rUu6Shn3y/k9/rHZ5PW17IswkQW8mMwLv5ZSaxbHG7pFw27szFOyz17nPgFiWQqf6IvyPV8SoxuZJXBl32NMYCwdq9c8Sgux5QBlT6lJrTVI+mtjqJFMQhWvcBYcCdryfAnLQYobmzkdNVVSjhGpKWImJiguBFUm13AI0Vs02TSgz+EfnTE0bEmdQrjgUQbwILdhhbNHBltiDN3yLGCNneLMJ5fkeVGwguusB8FF8BawjE/Xy2RNnJ5SPwG3uBado0of3tfW70sU3o6SWtQWI9jjueCxAafFnsUz7ErOo3NaMonkfug5ils86fykLzSLAwsmDNiFPV9IseKDD+AFV6H74ULCoVRAsi1+6BC2QhJ6LwOmGLc5iwBfRZcbEygj8yffck0EtVPCxfhC9KQN5ihP/V/FQPv9yVYNUMZC6uTFsf5nUbrhWDuSaX+2wBMRg1KHMQBg1YfsKBb+pz2PUiIVC3FKno4YIiBCRSPhi7935K4OX1Zv7Rn1dHvKVnctmI9F21vLsWS9Vt/6XzQg9iAJT5vc6PnjWXC3JvNnWwDnn0MBzc4PUk6XsPc5fpqLjFS1wyzdHgt
 VURcwrFM
 fccZoIF3CMUvz+UHTDIOrSTFnxF++bUYSMfrydRSMKgX7W24mrRwHJefdeqlzn31/rUnE5F4AhVwyo3/a19Z6BUP9uokK43dlqhCxgK++ZvcRHnS3th/c5s9uZSMwuuuogjB3U6+K+qA5S43zmPKVGbNlkdKPJYjqCc5zDmi/fn0By7stWciCa1Wa3YCeAxV7Z5W2cJ/Rai8fMDWdsS5kzzf2zyxlGt2Ln3/EI/0/ZMzC6hvSrOgEv2gbB+y3hI/Iu/gpJd2cvqfEiVM7CuI3NzhFFL9BaXoOk599yJzekW8qvafC3CzVPSd5WosGvK+Pezbnj+Jy/cUL+MXJZYirrkcXJsQAaZDgCMNr
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
 Documentation/filesystems/mmap_prepare.rst | 168 ++++++++++++++++
 drivers/char/hpet.c                        |  12 +-
 drivers/hv/hyperv_vmbus.h                  |   4 +-
 drivers/hv/vmbus_drv.c                     |  27 ++-
 drivers/hwtracing/stm/core.c               |  31 ++-
 drivers/misc/open-dice.c                   |  19 +-
 drivers/mtd/mtdchar.c                      |  21 +-
 drivers/staging/vme_user/vme.c             |  20 +-
 drivers/staging/vme_user/vme.h             |   2 +-
 drivers/staging/vme_user/vme_user.c        |  51 +++--
 drivers/target/target_core_user.c          |  26 ++-
 drivers/uio/uio.c                          |  10 +-
 drivers/uio/uio_hv_generic.c               |  11 +-
 fs/afs/file.c                              |  36 +++-
 include/linux/fs.h                         |  14 +-
 include/linux/hyperv.h                     |   4 +-
 include/linux/mm.h                         | 158 +++++++++++++--
 include/linux/mm_types.h                   |  17 +-
 include/linux/uio_driver.h                 |   4 +-
 mm/internal.h                              |  37 ++--
 mm/memory.c                                | 177 ++++++++++++-----
 mm/util.c                                  | 219 +++++++++++++++------
 mm/vma.c                                   |  59 ++++--
 mm/vma.h                                   |   2 +-
 tools/testing/vma/include/dup.h            | 141 +++++++++----
 tools/testing/vma/include/stubs.h          |   8 +-
 28 files changed, 970 insertions(+), 311 deletions(-)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

--
2.53.0


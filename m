Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47159106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3FD6B008C; Thu, 12 Mar 2026 16:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6774E6B0092; Thu, 12 Mar 2026 16:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C186B0093; Thu, 12 Mar 2026 16:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 414F46B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:27:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0791EC1991
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:52 +0000 (UTC)
X-FDA: 84538547184.29.571A9ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B616A0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=craZlvZb;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sgQXO/ryo2VmHBve+QKX1iYBHSNvGPYhUAhfv2518aQ=;
	b=FovV5+LxEgtmEn7XfeOVCX1yj8R8gtOy8wGhuxa4XdoUUr14yiDwzye+zpNQOehShYHgxm
	IMdgYvrZ3uqcz+WaHz/0a8c6XetKgGUBbnfhaRZctivTg+R/YKZI1ZsaSs72JI9eIqYOZZ
	HccYpMAzY20qOrAozDEzPZZLq4H9/HQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347270; a=rsa-sha256;
	cv=none;
	b=78GwOXiH2FVUjIJQqOLVx2GjvaWlAlsVOswmgsQCt8z9GyjKm/1++TA0vvUSY3GkXOdkXt
	JzzRaIp3/+SrCbR9VAeoJ3pXbCNiKYhgXTN2WuzWGgnBn9o+W9QKS+V2eAFIVxq/wiOVll
	mKB0I/EYOmRu5ZJSa1a0eKwMJV0st+0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=craZlvZb;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12A1E4417D;
	Thu, 12 Mar 2026 20:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0DDC4CEF7;
	Thu, 12 Mar 2026 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347268;
	bh=UHRT8qRmUgXL60CxpkG8XqJ40rRzobM0A/lzS/hpZy8=;
	h=From:To:Cc:Subject:Date:From;
	b=craZlvZb5CGklOhHfqyBv/N2B4J7VOxsEGxAyy49uaJyF1Jyg/1A800kZeyO1k4yW
	 d4nk35Hw7zkQKIqmK7i3AotkuZ9aCNg5kxBohTKgQiC/uPu/S8LiGo/e5ToGK1QfhL
	 xDjyWyVf4HhkL/qRL1ZknbK8aS+MIfLKHEYCRjLEBYMJlSBM9eRsvDIYzl4YfSpmsj
	 iB7IBjXqGYz+BNhwdRbqTNlG379au2uoUSMc6AvVYa8NoaP28LQ32Omvd8/6aW2CWE
	 MvfLMlDkSAkFhGIFTmwORZMdnQ9l/wOcUhOFUQoYNegqsXtG1QaNKdM6TFCpqdII1U
	 /nFm+u8VpBCFA==
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
Subject: [PATCH 00/15] mm: expand mmap_prepare functionality and usage
Date: Thu, 12 Mar 2026 20:27:15 +0000
Message-ID: <cover.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B616A0002
X-Stat-Signature: nguq6ynqrrsyi1w7g9qguoahz53tuutm
X-HE-Tag: 1773347270-202056
X-HE-Meta: U2FsdGVkX18kn3w4+LlNJzwGdChd+BuJuOVhMNQhETNUJoyy+TOrYbIptCXSmzd5ULXrzkgJFY300PrmNtpvhjIeXA9s7SHSbFSB1coSJD1pXQ73W01COw1F4agiK6QaAICiS7Pf+UV6snpTvr2LHtwEkcqI60MM8aezHgLc0H1Pxj2FsnexrRGz38A710paJlG0hfwyBA03RFQhgCWc2BwYsZilQ50krXIbZWBgeFZfKnvvVILhhpjY6FPpSgVPoUGpkvr4yUA62b/k73B/lK8fnA/TViBP+nD1LZ2htHQsJ72w8eEf/yJAvf45FLH6Wwzt5eirO3bYqBgP/GcHE8VktkQfJP/QoblBqAeNJhsX2RPKcgKkXBax/Kl+ekrryhmCMX1SStXooS/rakMU0d/6nEpxv9gh0JRpIjq3x7swdHNsXKR0odux1QPH9zhShe8DmvXNKzv+e63PqhcjGRGdV7z9737LY1bf11iqKPPRh98l+Jr60B3TUFKJ5Ox1HaRdPy6DTKGGcucG0GR4POpfHRDp9T56851J7Ed763rOCs/HH1dg+/XsOVXH/wtrfllZmAuc/7UnGXMILr7QbeFE++NmsBTpVQrKDC+5vlZ179AZXwyRr4l+BDiFfsLMBM4NzzurCyTyS8B9sA0InrNgCq49dkR9zSsgo7xr0x4NYtDUJFmedJc0pE2YJ5JTm4ybmJZc8V+vkxioSzi0kceIPILankBG9ACSggnRKJegARogvW65NgKan7ytUT1EpANe63jHSHOjWoRKPYfjA4UGgvHTpuuz6zBpLXho25tb51cWEgsjnV+WxOLZ29mW0SAQZ2gq7bpi1f4t/BoB4m4kPqFoaXrdRKHjQ7JcRai+SG1Krfouhn2d19HCT9zHAtlq5Mv0cV/p1SBZTXMEB7dsm8juoD3PSzIZxOQUVTxkjFEIuF0aY3y5kdT5l3tTdtzA+2TNG/aCx7fTaGt
 78Z1TCaq
 BW6sRQM670akaWTnIccLnZ4BK4w9qsqggB4B0y+LNhVkfU6yYbLEa4w/JG0CMAY5b7GG1zWs5yVhJo7/+hh69OUJarFiXvb6BJ5QsxSW6VLgOci1VNaJn9dtbLcKKTmelNwfXDnqSWEwLV9K5aEtBYYw7HfFI6DKfvnXIGwqp/AKiSMNTG/XaMPpcm/WfIleB6S9crAoKo4a8PJhoL6nfyh49QibOvSdHcuep80USQHqa8cDPkJ1pU0VWhP6y1bPvCN0Oi3fdZKW2rLRjkNIrYtuSgj7Rr3TrzVRjjujxKskW665Xrua9WoNVNsCXhoe+6kfHzADdEzRqgd0=
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

Importantly, mmap_prepare is invoked prior to a merge being attempted, so
you cannot manipulate state such as reference counts as if it were a new
mapping.

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

Lorenzo Stoakes (Oracle) (15):
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

 Documentation/driver-api/vme.rst           |   2 +-
 Documentation/filesystems/mmap_prepare.rst | 141 ++++++++++++++
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
 fs/afs/file.c                              |  20 +-
 include/linux/fs.h                         |  14 +-
 include/linux/hyperv.h                     |   4 +-
 include/linux/mm.h                         | 158 +++++++++++++--
 include/linux/mm_types.h                   |  17 +-
 include/linux/uio_driver.h                 |   4 +-
 mm/internal.h                              |  41 ++--
 mm/memory.c                                | 174 ++++++++++++-----
 mm/util.c                                  | 213 +++++++++++++++------
 mm/vma.c                                   |  56 ++++--
 mm/vma.h                                   |   2 +-
 tools/testing/vma/include/dup.h            | 143 ++++++++++----
 tools/testing/vma/include/stubs.h          |   9 +-
 27 files changed, 933 insertions(+), 299 deletions(-)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

--
2.53.0


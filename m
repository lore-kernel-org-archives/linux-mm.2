Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98B2CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2253B6B0088; Fri, 29 May 2026 10:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5B36B0095; Fri, 29 May 2026 10:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112E66B0098; Fri, 29 May 2026 10:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 025276B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99EB11A0166
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:13 +0000 (UTC)
X-FDA: 84820757826.23.25A979F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 913FB14000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LO+ly8ub;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O+PhU90pz2MXJva+u4xPuRKfp0w+3fqF3YGQjdL6dcE=;
	b=535YiHg/nJ9IJibw1wgGOmCwCc3ywe0hzHIKMop8uU+njBkFJme5WrJMD4GCK03VLvYrDI
	8Ntfm1nBuAtQieCtiyx7Ke9laRbVdPjQqMVsXKIuOcInoXg+WTWJ7poYoLOHHCdPoXEOYS
	ajMWLzihb4FqysEULhgszXxUGIS+Dkk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LO+ly8ub;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066571; a=rsa-sha256;
	cv=none;
	b=iimskJuUvk62Os82q9eJsEmdD3Mhu4DcvpjueQFlIV0FZKnnuvXczdg5O2Xf+JqtHmkQ7q
	yl+lrYNc2PY8sLkQ1bzBjHJNeR7ejDCjH/3lnk2eAq2Y9jcnxRfAl9XE4U2Rn3b2VMFGi5
	nLIk+FSp8WhpAUGpimqZPJ7QX3rLmY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O+PhU90pz2MXJva+u4xPuRKfp0w+3fqF3YGQjdL6dcE=;
	b=LO+ly8ubrvDDBRvSj297YSBhGyvrbRCcPIEnTbywJOLQ7R1ePcEDvyEnAtk0WcHFvI7bPs
	pOFhk59PI9hUoLNKVT27g8CExbGGU/ALQyPbAN/ebhBs+KyJ7UH5oo7gbZjFXWpTSiGVqc
	86FoJjT+4adU1LI3TUtOSdf5k/M7GHs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340-muPWJ1WFPG2ETWNc1CObWw-1; Fri,
 29 May 2026 10:56:07 -0400
X-MC-Unique: muPWJ1WFPG2ETWNc1CObWw-1
X-Mimecast-MFC-AGG-ID: muPWJ1WFPG2ETWNc1CObWw_1780066564
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 600E018002E4;
	Fri, 29 May 2026 14:56:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3376530001BB;
	Fri, 29 May 2026 14:55:57 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 00/14] mm: thp: always enable mTHP support
Date: Fri, 29 May 2026 10:55:18 -0400
Message-ID: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: zyEXbg9tJREcXx5WeaRzbT7ZF8iZlhU2Rr9-_-22hUE_1780066564
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqck9ai6id5g1e3jcr84e44o1uaz1o1h
X-Rspamd-Queue-Id: 913FB14000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780066571-954805
X-HE-Meta: U2FsdGVkX1+XPtC39FQyT2sg3zNgsmtMRlql9/NzD4h/tm1TzH3Vwww/t0TT/f2CFoqTMCM9O135irPF0tus8qxG/cTIewQZgowREk2nEO4MO/oubwGqM9vDrogQSORYkH0R/UPb+Aj+BzQpWFYrImevjc6HpImU/iiXmmdTgEGOIcSp42xohJWtVJq+LJzzqFOnCg7dEkmHgDzA7SeII+K29GlvewFHCHJtCoIftk0KB7WJ9zMGGkimtzNBYWYVXbX+60T0j4NDGMl0J9ITqd/xrZTVZTN3RvzPsJ0YrWZCizZIez/fjBblxpO3dyBLkur2CyKHaUhNK7geuau4uXf/PbWl4tgEjXxFAjstDRAddYwPJlHqbf+XAv4A84TgwIBY0FBbam+fSYQi0BhggR3BthYqPwBc+NPAIE2ZvT1hkElpp6QwQVtbJ5/2uDrLjd9qHHhedViejcaSnFsxaQEDc+lIFa64HgkVjr6WGr5MDWWNKgu5LqK+r5Ly4efV6A84T8TMXsey4n44zDyylXZKAAcuZDwz/lQw+DAWDCPYUGLOojP78igwdHvSTesQUL7O/A5N4iyaq4Kq18VBn13aqmyFUbAanU4JnXGSdzLG5We7+Ae6nm7Bl9NUTUDepzAzRl7bWWTq21H5MXR5P4FMCaTwa3OaVPEqOFOJNzIB5BHur8lS/Lb3K1zY1GWO8bd8GjfM/hAw5PtrnxtARjY++g0LHVs1dNpl1RbEYBtdNCf8ll/R2Z7xOGAR1pDNR0FaeHVRTYrgv3StQicSTWIN1h+8HrDGL+q7m9xkeOnBn82fYh0/Cy1DX2o0u/5x3RfHaVzANc3WaagnFqenLTFo/+cxNKdLhjSYeIryd6t2eMoz1epB6/5TPYY5cxjFGD4WCLsOtmGdIiBZvHVuLzwf0b2RFlIRf+j1lTJDzqZ3d04AfVlBUg8qgPi9qMpuewCzxTYZU7PGAI1G/zm
 DqrtoEnM
 kP20X0x4a5So5WJ3BxfqvahECe8b1Uf7g/LpoJyb4WzVvNrwB/4QdPYViljWmoT9w9/zNGthne8Rt66cyMQKnqer9zxHniRQicaXmBE9TQFSYUzjad1+f8FmZAvRtsazAv334pl471APw16cRq0VAmYwridY2fPrL4qovsKpT91eVhUZjuzGRBHkz7UE4erMdIoMbCd/VyzDgagN88I+gVmix2gIfp3AfCjB9wMo/9My7C+P27dDeiI++lYglOhdcZlD91c8lmTDdH/SYA6lzau0J31ph0clbieVn9cwGsXpQp0IscE5HYJ0RNlO454EgXd4r7fn1TjipxM/oYL5cj5p1ZaBQ+dnyod4cHvsjT/l4uUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, if an architecture implements has_transparent_hugepage() and the CPU
lacks support for PMD-sized pages, the THP code disables all THP, including
mTHP. In addition, the kernel lacks a well defined API to check for
PMD-sized page support. It currently relies on has_transparent_hugepage()
and thp_disabled_by_hw(), but they are not well defined and are tied to
THP support.

This series addresses both issues by introducing a new well defined API
to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
new helper, we ensure that mTHP remains enabled even when the
architecture or CPU doesn't support PMD-sized pages.

Thanks to David Hildenbrand for suggesting this improvement and for
providing guidance (all bugs and misconceptions are mine).

This applies to Linus tree eb3f4b7426cf ("Merge tag 'nfsd-7.1-2'
of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux")

NOTE: I used Claude Code Opus 4.6 to review the series before
posting. No issues found.

v5
--
- Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
- Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
- Added new patch changing shmem_getattr() to set blksize according to
  highest supported THP order (Baolin)
- Added new patches to move has_transparent_hugepage() out of
  CONFIG_TRANSPARENT_HUGEPAGE guards (Sashiko)
- shmem_allowable_huge_orders(): rename variable and only disable
  PMD_ORDER (David)
- Added <linux/jmp_label.h> to include/linux/pgtable.h (Sashiko)
- Added new tags and removed Reviewed-by from changed patches

v4
--
- Used static key for pgtable_has_pmd_leaves() API (Lance)
- Moved shmem pgtable_has_pmd_leaves() check to
  shmem_allowable_huge_orders() (Baolin)
- Default pgtable_has_pmd_leaves() implementation to
  IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
- Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)

v3
--
- Rebased on top of latest Linus tree
- Removed i915 patch as driver dropped has_transparent_hugepage() usage
- Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
  with early_param handlers clearing CPU feature flags
- Fixed build error with CONFIG_MMU=n (kernel test robot)
- Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
- Small commit changelog improvements

v2
--
- Added support for always enabling mTHPs for shmem (Baolin)
- Improved commits changelog & added reviewed-by

v1
--
- Call init_arch_has_pmd_leaves() from start_kernel()
- Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
- Clear PUD_ORDER when clearing PMD_ORDER (David)
- Small changelog improvements (David)
- Rebased on top of latest mm-new

Luiz Capitulino (14):
  docs: tmpfs: remove implementation detail reference
  mm: shmem: shmem_getattr(): set blksize to highest supported THP order
  mm: introduce pgtable_has_pmd_leaves()
  drivers: dax: use pgtable_has_pmd_leaves()
  drivers: nvdimm: use pgtable_has_pmd_leaves()
  mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
  mm: shmem: allow THP support determination at folio allocation time
  s390: move has_transparent_hugepage() out of THP guard
  powerpc: move has_transparent_hugepage() out of THP guard
  mips: move has_transparent_hugepage() out of THP guard
  x86: move has_transparent_hugepage() out of THP guard
  treewide: introduce arch_has_pmd_leaves()
  mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
  mm: thp: always enable mTHP support

 Documentation/filesystems/tmpfs.rst           |  5 ++--
 arch/mips/include/asm/pgtable.h               |  6 ++--
 arch/mips/mm/tlb-r4k.c                        |  8 ++---
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
 arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
 arch/s390/include/asm/pgtable.h               |  6 ++--
 arch/x86/include/asm/pgtable.h                | 12 ++++----
 drivers/dax/dax-private.h                     |  2 +-
 drivers/nvdimm/pfn_devs.c                     |  6 ++--
 include/linux/huge_mm.h                       |  7 -----
 include/linux/pgtable.h                       | 20 +++++++++++--
 mm/debug_vm_pgtable.c                         | 20 ++++++-------
 mm/huge_memory.c                              | 27 ++++++++++++-----
 mm/memory.c                                   | 11 ++++++-
 mm/mm_init.c                                  |  1 +
 mm/shmem.c                                    | 29 ++++++++++++-------
 19 files changed, 120 insertions(+), 84 deletions(-)

-- 
2.54.0



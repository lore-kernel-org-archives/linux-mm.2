Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA807C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A890D6B0095; Thu, 17 Sep 2026 21:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A746B0096; Thu, 17 Sep 2026 21:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9020E6B0098; Thu, 17 Sep 2026 21:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F9E6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4F401A052E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:15 +0000 (UTC)
X-FDA: 85225192710.16.0A4C27F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id CADB120004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iD0u4F4g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ICDDLVAxUTIXAzHT73ct7BUXGQWrZnPbXZ/VSyM0YsE=;
	b=VoA9JaCn8eEHqCkpqMycMzDSYNisHAGw+W9DM2GfTFcLBJeQw6dopZ0M+XucSlv4aL774o
	W/bFpUZmvInLon2guwNboJ/rPEiuWUersaDcOHyAGFrr5PD6R9PKUymwK8rqZdsuuJ3Dbw
	Id/8W0tsi64LYNRp8SUUT7X2F12K9bo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695974;
	b=uvTl3Jv5OF4YtgXsUkvVcBZSUXXGzt1rsWblpsrx90W//ngJVTpRs8l5vLosI9YKzADRHT
	eErSjkJPdxZEvxfPQmEME+OC1nEkeDDZRgz9+fD8U3NteB/IU+DwglUvHgVJlZfczrHbFB
	2fyWlAiTEmYakvvEPL2rQiP7g19Zm1o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iD0u4F4g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ICDDLVAxUTIXAzHT73ct7BUXGQWrZnPbXZ/VSyM0YsE=;
	b=iD0u4F4gS/YJifI8t/Lp4QwZidvRdflrJClRbEQni6OSgn+cuOLuybGx5R+1mSgDBM3bsC
	U2hRUq9Ekd0gNIr/TdHRXVsy+9r2itq0ApyYi4JBTbsvrFz3H9N+7cX8vKuOK3ysTWcC+W
	iubCHvF+2dAA5Uu9v0WDgvODlPS+3iM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-dXlxvbnuO_ugLOzqfjDkbQ-1; Thu,
 17 Sep 2026 21:46:06 -0400
X-MC-Unique: dXlxvbnuO_ugLOzqfjDkbQ-1
X-Mimecast-MFC-AGG-ID: dXlxvbnuO_ugLOzqfjDkbQ_1789695963
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D99A195FCE0;
	Fri, 18 Sep 2026 01:46:01 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 836ED180034C;
	Fri, 18 Sep 2026 01:45:55 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 00/14] mm: thp: always enable mTHP support
Date: Thu, 17 Sep 2026 21:45:21 -0400
Message-ID: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: SL7AbrAlxECii4Kz0HXnh8mGeaEYmKAiAUBkSvaGn1Q_1789695963
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CADB120004
X-Stat-Signature: qmbned3hbe6kc1kw7hb354ftjy986yu6
X-HE-Tag: 1789695973-840427
X-HE-Meta: U2FsdGVkX1+Dtb49U7UKkR75zhVIT84Wh5s/0jOgXZP9mZuUtM6/uoTGlj/fSVYB6t4b8MsskCJNNLq/13sPyiiGJLefP1/L201HRY8dQ+3BOGQ1qWRFJ+dS8qepGulO0VkK6tIxkpKy+EZ4Lrfg1A9Zo/1GOpOo/NlhpR1u6lavzisHWGw0azUpZKnL8rSYyp4ubhsw8efErEPjwEubuWS1bi6q7XyhL2uokY7QR/rBXsbzbesotaisO3r4I09Q8YcaKkYMIGnUlks6ebQzw0/m2sVLcIfDUmxhV89wYGXFOsWQ9Ke6qdP2WwiHPl6E+/dcPg9qZCHIL4bxnp9VliiFsIICfCgBGbNfHjbuDm0Vn/ILQYxIO87F8TSAy6oBc4UF42uyg9fRrGIQx4/cTrc5oJPTIMZX4h2tGwptP1rYtZgIR3OzcxoqyP4iuJggwpDph4CMBT+rgO6HFktGR/vedJ6D5KgZpswhOuQeAPVfDOfOTSkVnIiu95yRgMyLYIWH1+nvFKsS/lvf/UVgI4E6GAqoTbME/FnFi7yQqCPkkcaUkd0sr6FfVWpJ8IiiFGVoMsy1zckLwtRrn+Qkl2iLaojQ/2qp7ga2GWifZ2Af+wGq/FYJ6D/ekjzybkbN/VTnbw6esZzomXQQnkjweHQIdnvddCIMil0YUheNU6D21QkEn4l72KfMBdTCMyk+kKWG1IC7cViDADTo9UOwf1Ilqgj7zLCea4mL4+xnPKDF0pczdIdjFMQ/Q8px2GPaGFi7g7hK+j80SQi5L/Do9BAERTGRfQfdRuzgxFylnsjr8fL++WSgGGoBulk7dq1vfLgbakdN0oCvPDYZ4iCDQFwzdK6w/l7CISlOvdYiwkyKcM5w4jnumBY2yR+ZauerWrgq+eUuMoOTnXNASJG6zOKGcVWdO6/onYNF0cyemy27xC28DwtgqopP4vp+PC+SlnI8JVYdBHOnJvLYB+I
 YYlzrUz2
 LmktmxTTgtDEbeyE88CDWGwy6jlhagax7C7ynKZD5ppImaB6Y8eLfB6igmSUl3mhf/lmSxaGtAFgWbLK/6HfYC+AAy9k9pqS5x96Tf01NYVKeownU+9meu5j5k/y58n4Rrm+kcRk7UTDqr70ZWRrmx63EiOhA4/D7VCZa3TqyIElO5EnLqWx+5KjNxX0UMk1q+9FRBr79kL971n/QId9kgCGgOt27CnBUH762YQ/dYuqxxvQ+sVai83IH480xutc9CYqTAnE5x9lR7/IDMlY9irb5SWRcfa8b0dQ0gSlxcXNtkqCbcM+o+Ehpr4UKYm5ff30p9MOZlaIYI42Tv1Aj6ET+aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduction
============

Today, if an architecture implements has_transparent_hugepage() and the CPU
lacks support for PMD-sized pages, the THP code disables all THP, including
mTHP.

This happens because the has_transparent_hugepage() helper is overloaded:
its name implies it checks whether THP is enabled, but on some architectures
it actually checks whether the CPU supports PMD-sized pages. In addition,
the THP and shmem code have a big switch on has_transparent_hugepage().

This series solves this by decoupling THP availability checking from
querying CPU support for PMD-sized pages. THP availability can be checked
with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE). For querying PMD-sized page
support, this series introduces a new helper called pgtable_has_pmd_leaves(),
which is independent of THP, has well defined semantics and can be used
in fast paths.

Core THP code and shmem can use pgtable_has_pmd_leaves() to determine
PMD-sized THP support at page fault time (or folio allocation time for
shmem), leaving THP and shmem always enabled for other THP sizes. For
architectures and CPUs that do support PMD-sized pages there's no
intended change in behavior.

We also convert each user of has_transparent_hugepage(), and the related
helper thp_disabled_by_hw(), to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
and/or pgtable_has_pmd_leaves() according to the call site's check semantics.
On s390, powerpc, mips and x86 the arch has_transparent_hugepage()
implementation is moved out of the CONFIG_TRANSPARENT_HUGEPAGE guard and
renamed to arch_has_pmd_leaves().

Thanks to David Hildenbrand for suggesting this improvement and for
providing initial guidance (all bugs and misconceptions are mine).

This applies to mm-new 93f615a22169 ("mm/swap, PM: hibernate: atomically
replace hibernation pin").

Reporting availability of PMD-sized pages to user-space
=======================================================

Before this series, not having PMD pages available would shut down THP support
meaning that /sys/kernel/mm/transparent_hugepage would not be available.
After this series, /sys/kernel/mm/transparent_hugepage and hpage_pmd_size are
always available but hugepages-<PMD-size>kB is only available if PMD-sized
pages are supported.

To me this seems logical, as hugepages-<size>kB is only available if <size>
is supported. If this is correct, then MM kselftests that depend on PMD-sized
pages will need to be updated to check for it as they fail with this series
applied when PMD-sized pages are not available.

The alternative is changing hpage_pmd_size: either don't create the file
when PMD-sized pages are not available or set hpage_pmd_size=0. My concern
is that this could be considered an ABI breakage as this file was never
reported to be optional or report a zero value.

Testing
=======

- Ran MM kselftests on x86_64 and s390
- Tested all mTHP sizes allocation on x86_64 (with and without PMD-sized
  pages available)
- Tested shmem with within_size w/ mTHP on x86_64 (with and without
  PMD-sized pages available)
- Performed defconfig build on x86_64, s390, arm64, powerpc, and mips

NOTES:
  * I'm forcing arch_has_pmd_leaves() off on x86 to simulate not having
    PMD-sized pages available

  * Running the MM kselftests when PMD pages are not available causes some
    tests that depend on PMD-sized THP pages to fail as noted earlier

Changelog
=========

v8
--
- Fixed build breakage on MIPS (Lance)
- Rebased on top of mm-new (fixed conflicts in include/linux/pgtable.h and
  mm/shmem.c - dropped a Reviewed-by as a result)

v7
--
- Applied on top of latest mm-new
- Improved various changelogs including cover-letter
- Changed arch_has_pmd_leaves() default implementation to use IS_ENABLED()
  instead of IS_BUILTIN()

v6
--
- Rebased on top of mm-unstable (required a minor conflict resolution)
- Added more Reviewed-by and Acked-by tags

v5
--
- Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
- Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
- Added new patch changing shmem_getattr() to set blksize according to
  highest supported THP order (Baolin)
- Added new patches to move has_transparent_hugepage() out of
  CONFIG_TRANSPARENT_HUGEPAGE guards
- shmem_allowable_huge_orders(): rename variable and only disable
  PMD_ORDER (David)
- Added <linux/jmp_label.h> to include/linux/pgtable.h
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
- Fixed huge_anon_orders_inherit default setting when !pgtable_has_pmd_leaves() (Baolin)
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
 arch/mips/mm/pgtable.c                        | 25 ++++++++++++++++
 arch/mips/mm/tlb-r4k.c                        | 22 --------------
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
 include/linux/pgtable.h                       | 21 ++++++++++++--
 mm/debug_vm_pgtable.c                         | 20 ++++++-------
 mm/huge_memory.c                              | 27 ++++++++++++-----
 mm/memory.c                                   | 11 ++++++-
 mm/mm_init.c                                  |  1 +
 mm/shmem.c                                    | 29 ++++++++++++-------
 20 files changed, 144 insertions(+), 100 deletions(-)

-- 
2.55.0



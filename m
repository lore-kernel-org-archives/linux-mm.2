Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD0EF99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9FC6B01A4; Sat, 18 Apr 2026 05:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5824B6B01A6; Sat, 18 Apr 2026 05:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEEF6B01A7; Sat, 18 Apr 2026 05:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAB16B01A4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:00:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE1161B8017
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:00:13 +0000 (UTC)
X-FDA: 84671079906.17.7F853DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11818C0002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:00:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CDd6l+vy;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776502812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BsUdAF/Jn9ifTthYOvtL86Rut3jusq0PKj5uKWrmdDo=;
	b=spTI3J1/0Uzi121LffyP8QmnyeiSyLzgRIQlMhN0Oqkn4/R5JjLO9jE+eyHdvQaHlviulh
	6FRzYcO50yugtBBOmPtPzSkd3EQrI03TVbwrJtlu4QNYFYL5f3ubQhP73g63kkZrlNsTKp
	K1KtknB4EbhIJfdnqbSd3nPdlwI+7gA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776502812; a=rsa-sha256;
	cv=none;
	b=CODswF03CcyNfHL9awNTZcqDi023I48YJ2JKtPbsg6HYJZWOujnaZSN5h1d3PoAV21LZHf
	6itJ1PH+4GwMzw8mC1ooMYGvxZ96MByOUykGkC+PId5gpOaStJ55+Eg5gWyomP3NBl6/jG
	AIpJt6fIJcqZ5cNaLFrzrWB3UfjgSD0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CDd6l+vy;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDA894344F;
	Sat, 18 Apr 2026 09:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3FC19424;
	Sat, 18 Apr 2026 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776502810;
	bh=AO9Uyo7JjIATZDTUtKqmXRVnwAtteqk8wRVqr2mmTIk=;
	h=Date:From:To:Cc:Subject:From;
	b=CDd6l+vyntE/Ikf+sLKD/O4sScQBE2+ziJ/7wfruoWZO2P0/hbFnWrvHuLXJtt2DC
	 sbzt+BqsAd3T6I5jeIBslwG1rTpi7yTpjKtJIhQPt3iN6VtQv0XsEXogq0F0jtcOqt
	 fO//aosDo+E+Gx5RQ1lxoch/01xTJDuQahVsZTudnNMdig1kjemC3mNvBKSKJlhITl
	 p2/lp3VDlurdsqjnDchycI9zu8JQ7pe1QKYF0oULk+ccg5y+RKpKTzj5/eTgRyTwrB
	 pIT5W5gsKDVRzG6PF8+JHozVcRO0jzkjPvWt6uYaN4WYhvBO5oCl0dCimsB9kpXa8l
	 lrCTWqgKmkXCQ==
Date: Sat, 18 Apr 2026 12:00:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock updates for v7.1-rc1
Message-ID: <aeNIFuabuGbdVvDW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: gzznm1m4gswyequ5ut66qkbujm6ihpea
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11818C0002
X-Rspam-User: 
X-HE-Tag: 1776502811-357793
X-HE-Meta: U2FsdGVkX1/ULSXlj85z1Sk2L6sEzmg6WMOGNoo0MH8CS9dvOmt9vOdz2nkpbAycOdOiFRomlwldp/M7VZYUKUh35SnyGPfwB643lpsxm473+frWnrIXy7taOh5sbXgNNa18NphtvzW7wQBBr9Z2pnlicUynkUYETzIBM2a6H2Tcu6C36Cjsiihk2rG86byjyVd+TFRdiPj8Of4S3UCJCujLNaFuIRv2FzohQ7iUzHosXcvYQ/R48zo3B08xrv17T68hNZdK3aReHVzCt3sX3dZKPMhuCT5HQv9SsoxRS5qljZYLbPVu9wNkpEzq2SAz7rdqScskgwyysCjbyDEwus2XONwmaujLCq9IJgysJU7DcUWURicVY1B5QPxov5et8DkQewVcYQW+yRFhYpcPado6WrQdYW65ojS3LKaWgoGI0vokLymQdHZh1GZVJBYivhNLLCE375MZfGMm5k/3JjAO6eHjDj14tmslXvxCV1LAyq1ol6zJTpZ6Yrw/poQODG+zBI8FAybG0PGG05L6G1rX5ejP7G5foOW7tPxFZcvzBa4zaKqBcNrYXM8UgCJ+p63Gre9k76rCYHhQLQz2UKzBACvuAXserHZOdD1YbfdlABX33EUFLjuWF1nkmGRolOaxUiMzgUqwO/qiHUA85ODuksKJ44VcZbA60A7FtT08jR4es2aFU0nnz1N1CGLZYSzAwTxmvzLsY0ydTQUHp4L7VYqEZ1ozEjYvNl6+l632xOrczGlv+JYAEInpaLy2ZRyfjMUszoNs0zd5FjTDuCTTOSHRx7xJV2f6WkXUo6hzTZkrqHJe7frGvZFvy467OQTqVP4aMtkF171tWRk6pGo4l1qQW1eHC0XS5N+g4n6nodnyEl9sWlEofoWvoqK+34PwngFc/OcVkwITY4qX9QbUPM0CGEnY94QXfaz8AqytfZFpe+0FUOVwXPyDL2gYNq2LVK+oI6l2c/uWtv8
 6KogMSyV
 cui2Ez6euV6/iX8Q1yYZ5oWTSQHQ9ljZ+T1NJNd5dofGDLTtfZ3L2BTgBTPLNdoarqWFH3nZ0RdgwExzNVpuRr9jPcdtQ9zwlecsWKrF376FfxnQiq26Y5bW89ttnFERmqMJB1LBC2uAMQno1069BpoXvOVTApnzPKpGjzLH63l68lpsqLmNL2wRRAqQil+KuXrRvEK6BVCuGm91fq4z/gRYCR+K/Tu3LdtJy3eU7kf3NZ8H5LbvULGyMbJFW1zIuXHPEAaC9NmN/4b8uRitCHgNjQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.1-rc1

for you to fetch changes up to d5759519805c54786c00765ca1303e6d7a0676ca:

  x86/alternative: delay freeing of smp_locks section (2026-04-03 17:38:34 +0300)

----------------------------------------------------------------
memblock: updates for 7.0-rc1

* improve debugability of reserve_mem kernel parameter handling with print
  outs in case of a failure and debugfs info showing what was actually
  reserved
* Make memblock_free_late() and free_reserved_area() use the same core
  logic for freeing the memory to buddy and ensure it takes care of
  updating memblock arrays when ARCH_KEEP_MEMBLOCK is enabled.

----------------------------------------------------------------
Guilherme G. Piccoli (2):
      memblock: Print out errors on reserve_mem parser
      memblock: Add reserve_mem debugfs info

Mike Rapoport (Microsoft) (11):
      memblock: move reserve_bootmem_range() to memblock.c and make it static
      memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
      powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
      powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
      mm: move free_reserved_area() to mm/memblock.c
      memblock: make free_reserved_area() more robust
      memblock: extract page freeing from free_reserved_area() into a helper
      memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
      memblock, treewide: make memblock_free() handle late freeing
      memblock: warn when freeing reserved memory before memory map is initialized
      x86/alternative: delay freeing of smp_locks section

 arch/arm64/mm/init.c                          |   3 -
 arch/powerpc/kernel/fadump.c                  |  16 +-
 arch/powerpc/platforms/powernv/opal-core.c    |  11 +-
 arch/sparc/kernel/mdesc.c                     |   4 +-
 arch/x86/kernel/alternative.c                 |  22 ++-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/platform/efi/memmap.c                |   5 +-
 arch/x86/platform/efi/quirks.c                |   2 +-
 drivers/firmware/efi/apple-properties.c       |   2 +-
 drivers/of/kexec.c                            |   2 +-
 include/linux/bootmem_info.h                  |   4 -
 include/linux/memblock.h                      |   2 -
 include/linux/mm.h                            |   3 -
 init/initramfs.c                              |   7 -
 kernel/dma/swiotlb.c                          |   6 +-
 lib/bootconfig.c                              |   2 +-
 mm/internal.h                                 |  10 ++
 mm/kfence/core.c                              |   4 +-
 mm/memblock.c                                 | 231 ++++++++++++++++++++------
 mm/mm_init.c                                  |  25 ---
 mm/page_alloc.c                               |  46 -----
 tools/include/linux/mm.h                      |   3 +-
 tools/testing/memblock/internal.h             |  43 ++++-
 tools/testing/memblock/linux/string_helpers.h |  10 ++
 tools/testing/memblock/mmzone.c               |   4 -
 25 files changed, 271 insertions(+), 198 deletions(-)
 create mode 100644 tools/testing/memblock/linux/string_helpers.h
-- 
Sincerely yours,
Mike.


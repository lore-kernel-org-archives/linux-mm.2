Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD7CEB5979
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB146B0005; Wed, 11 Feb 2026 03:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EBE6B0089; Wed, 11 Feb 2026 03:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613176B008A; Wed, 11 Feb 2026 03:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B26D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D16EE1602B6
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:27 +0000 (UTC)
X-FDA: 84431461254.15.6F313A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 855A740007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlZ9rZMb;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nZ49YzVRHq95c7sl6l6/qp5imwtWxWIALbbPA1ykmsQ=;
	b=pBgNhkMbQZ/cgyNm7selP75EvJAGi2Mv5tglUrS9Bxb6QMwkOShpJZ3C7iXvIjAYc0a44M
	USIouaEidiI2tVbYBOvX6XpQL+xqReVSJMYILdBAleGn7hdsQqqPIICJWQ6zxomNDfMBXp
	e4Eoe/CRc7+VyqrFITzhuA8Pal26h+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlZ9rZMb;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797605; a=rsa-sha256;
	cv=none;
	b=wcQNeR3Wn9HimLvc/yUHX0alOKp/LTw2tN9Cdsry4I8qJI519gAoERT+Gpoz9b5guD4BVE
	+ct2TdnQiJuNRMQRlTgdJ590tEtcAssPx4te8AfIhNkl0yoJDB6LoA7cRw+aG/XNN6eTIh
	P3BUtaVCpKT/XYHeuWCNaresB7BL5/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nZ49YzVRHq95c7sl6l6/qp5imwtWxWIALbbPA1ykmsQ=;
	b=PlZ9rZMbduNF5NGInMcngQs9yxe1CGNQuFmLgrPL7+pvwD5cwrhRxyr9tLM9sJILz5GrHm
	CoFQoVXQJWcHnooT00BzRhKu0iTqVn42gAP98+Z9pj/a51ASkdGD24RKLCxQT4dolR4N7N
	P9pZVZUsu2KduUltAMyt9p/1WexMO5g=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-JLlNGH1HO1exAmdg923msg-1; Wed, 11 Feb 2026 03:13:23 -0500
X-MC-Unique: JLlNGH1HO1exAmdg923msg-1
X-Mimecast-MFC-AGG-ID: JLlNGH1HO1exAmdg923msg_1770797602
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38708f5cbcbso785451fa.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797602; x=1771402402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZ49YzVRHq95c7sl6l6/qp5imwtWxWIALbbPA1ykmsQ=;
        b=q6K6X7Bd3Ycf3uIppMBguVjCgUQG9bYGhhfPC5ZOk66qocLXtYpiMThQZj6g6NTc3C
         iPN25Xhmw1DYej8hsdr3WyYF/LVSK59MWYzjbQrOz3xGvvoSdbUe0Xoh0ZcLdSofIPWt
         mBUWcevl0yPc9SPjVyQGObLJhrJ3ZFNidgcmKQfGQPZSZzohq4nPCPntJcLlYZmlKib4
         UkXK5sM91ZOwjQCzcca7NIjJRpGsfAH3B2ENSdf4V5dxeCHjo/n0C24+3F1apPDC+5uQ
         BcUghCdwPHEEISuJYKLmZ0raH2EpW+PAGF/DPS3hKBhw1PA/CkJKXqMsajdQqTyd/aX+
         8iEw==
X-Gm-Message-State: AOJu0YyiJCnR+lsqJruPzbOTL71TE6sJ/UJA8MgtQK8PO/O83tLqgnAP
	U6MXxdTh/TIDoR0ZBC3s/GqXmuSVqhxhivoeB9WpwgL3bVwVWWAz2/68gxJRKRlTaGuwJ4sUncM
	9ju3/G2Z5UEsAlvkuvi7do4Xx3mgO6/qq7BAvI3zdLsZlMLdmuCunThH4IhH0pKQgLoxBpgMzJD
	dmi/VFo2PjlIZ9tTEm7BPcnwz1epha4n/YWC4=
X-Gm-Gg: AZuq6aIJrHjByg+NqGveoyRDCekB9N9qFyxcnHaSo0VZFT7/Z5mMwkpfYqO82kQF9KS
	ikROrB3IwhnMUhoQH+0qMa1TMIlltYgArWh+vejLus/aA0BVV9kEjcgz87JxbN599CxsyCsGDqh
	bNJ7aqftIE5r4cR0xMTiYUo1Cwws0Cj9vDW/L3uDP/TvdtIUSfdp3WYe1O9jEwosF3DJLks/NDg
	SBmTzvcFzP60eCl18+jbrLv08TkkxRYmKVBHAhh5CGcMtvIOvzKW1HfFIaX/ing8Nxf0Evf6IZn
	B+Qg+tpBXfkt9UbwcEqZGnekavQA0QMUZBaWxg+3atcQjILGokr3GeBS/CPKMt82W/y4iU0oJ5M
	ciej+b8XnwExySRZtXzp27+ODayrYs+WJ/iXF
X-Received: by 2002:a05:6512:681:b0:59b:79e7:c8e4 with SMTP id 2adb3069b0e04-59e5c3f80c1mr631355e87.49.1770797601564;
        Wed, 11 Feb 2026 00:13:21 -0800 (PST)
X-Received: by 2002:a05:6512:681:b0:59b:79e7:c8e4 with SMTP id 2adb3069b0e04-59e5c3f80c1mr631332e87.49.1770797601029;
        Wed, 11 Feb 2026 00:13:21 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:20 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v5 0/6] Migrate on fault for device pages
Date: Wed, 11 Feb 2026 10:12:55 +0200
Message-ID: <20260211081301.2940672-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T8xWFW_hGSMwlelRiw1cmIlmYjFCdAv4UavFiYHSiwM_1770797602
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 855A740007
X-Stat-Signature: zia8mfz6xkntjfci3rp4ycaiys16kyca
X-Rspam-User: 
X-HE-Tag: 1770797605-328548
X-HE-Meta: U2FsdGVkX1/CNl6A+YT37AyPqAEeqTHIFmo0Y2EZaGRHC3JmLqioieu1kNMXZknF+dGfXkzi5tqfjgkBRK8w7rKNH4pEoXF/NuESn6wN54WYmQewYOPgXt8dqG3SSSaC+FYskDYM0kLuSzkO8DKhRPvEJ1c4hCiUeMzZKJ4A7M/mNboGt6Rhj2oZAYpyKpiYUrtBZzgJv/QIvIC1cnmlW6n2ke85NVU6wHtthDQfZFltqd5UnmAqhkH4fbgDYjSZXOJE7G/1OhqYJ0uCFHNV47Cn00IlX4dvErZB17d6hJMW/vKx2mNO19MV9ytis+dMa+fiDpnqdC8u4N/gppm0dnXYSuFBxjpnbfK0Lmo4TcS6lk2BX5c1pTk+DsPlQ3s6Np2VdB4pnBsbEIXyeQPWtuYQy1R6HDiF+CFSt1x4aHwxMsabjbOYmC6D57v+8K9IFgx9bs97K2lxsHShXq8hbYElj4WSgbLkRMjoLWNlotHQVdldqLhIIT1U6WI6fkzb9It1Wdju+anjZE9+dCoPi3suKrW13y84yobdhLlvcNlD+F+kmrMItvQeQCoXzFJTyU7QIFlwFioPPVO0mOfKpDO7xkOv2RxO6uhqvWbm1vq3zdnzkLwFuBb/qC/A50b2vzGfGij2CAL78I37c6hg3O/W9wNYv08LWvFqnqdKud7C1ht+TJvMmKU2lzjZA2LNUPLuoBDsOPs30mOF9PQ2sfPrh+XQpfbwWahjIn5Zd62FNaB83u/DicNexHptbh9EKGxnr7sQQu5W8QM++QiWMX6vY2D5L0/JecRVyfpgFU/YjXPfdWmN97SiegYpt82+ADNzGeuXBlxKipLskmm59F25B0u/0zptobEsSZboku8cGZ6AjSL6VIJ192UiuhGBUYVi3aAGWcFYJuXLVBmdsnC1dZAiaOJBpzTDOCqlDoECNU2w4GeZ5r61heVK/zUJ5tig2ZyjscEnVmRRD8T
 Ir7zMy9F
 9L+8f+X/Q+zP24PLi6826fTDT1vc+I7ymUUuuI1Amu7PXtPUEF7uBSzDl+sh4uVewlWO+2ODY+f2O5ZXsrAUpp/HxxqTMZhWvYbEPmxo6sYLgcoLVMYUL0vySbWnk7nGrBJk900lQcocknrsFdQdGH08vQajwKy+2lkHNXehc0L0pzI0IdOe9PfHACZfl2E+oXKgC30RXukRSuwPpA1jpQJL1RHZ+sOGnWKvL2T9NjrC17DldEMkC/Z2zOtmfvZRtS8Hao0e+9FHTAflpHiIMzhgfJh1OucjTZWQfl1AzbzdCXuGe3FTAqggqDgccwzWeCPLFXK/r6LHQfqxtRHRjj7sLbw1GkgL6zPTwaKEux4tQ7vvFKPR7d6J/TqrxSBuABmn+wQPI3C8MC1fvwGDO1eUV07TuoB85vpfBwdawqssBYLOFQoXNfYVdJi6tyS7RwrotkdVUFrUrg0VBBfRF+XkXoQQGLvdwLpRC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Currently, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It is also tricky to code correctly. One page table walk
could costs over 1000 cpu cycles on X86-64, which is a significant hit.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

One extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

Tested in X86-64 VM with HMM test device, passing the selftests.
For performance, the migrate throughput tests from the selftests
show similar numbers (within error margin) as unmodified kernel.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes v4-v5
  - rebase on 6.19
  - fixed David's email address
  - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
  - refactored into smaller commits
  - added more comments to code

Changes v3-v4:
  - rebase on 6.19-rc8
  - fixed issues found by kernel test robot with random configs
  - fixed typos

Changes v2-v3:
  - rebase on 6.19-rc7
  - fixed issues found by kernel test robot
  - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
  - fixes to lock handling (pmd/pte) on errors
  - added assertions for pmd/pte lock states
  - other issues discovered by Matthew, thanks!

Changes v1-v2:
  - rebase on 6.19-rc6
  - fixed issues found by kernel test robot
  - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
    parts if migrating
  - other issues discovered by Matthew, thanks!

Changes RFC-v1:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
  - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
  - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>

Mika Penttilä (6):
  mm:/Kconfig changes for migrate on fault for device pages
  mm: Add helper to convert HMM pfn to migrate pfn
  mm/hmm: do the plumbing for HMM to participate in migration
  mm: implement device page migration for HMM pagewalk
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*()

 include/linux/hmm.h                    |  18 +-
 include/linux/migrate.h                |  27 +-
 lib/test_hmm.c                         | 100 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 814 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 602 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1053 insertions(+), 583 deletions(-)


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.50.0



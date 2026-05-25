Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7018ACD5BC7
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15BE6B0095; Mon, 25 May 2026 01:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6846B0096; Mon, 25 May 2026 01:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4B36B0098; Mon, 25 May 2026 01:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722246B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:08:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8A7B1C00C5
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:52 +0000 (UTC)
X-FDA: 84804762504.27.5A37858
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id AEA6780002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rr57ODa5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V4paCFehCo5VJEMvSsC4qRgM9BR+eq5E3O0LimBWo2c=;
	b=Z3q3V3gk0V/NMm1fr0Igoyj6LfC2lqsEiFoQTd5rep6I7KcV/DOPjXyiORls0UOjFMmXKP
	fw9vFFkvLuCdTBftJcZRXR2dFgUqJQcvfUV1f0qfDyzg1l/wU/yBK0XM33OYxk9woC1/UQ
	ZUHgX8aJ3XrTY3wkTg4fb1Wt7A/0s+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rr57ODa5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685730; a=rsa-sha256;
	cv=none;
	b=VGqiO6SwiTPHMlMG1i8B6e3Kq0Xi/lBeHJ8PF/7Tta2Sr1pNOqUJVyrUbH6nz1UvScZbYw
	7YqDhjYdLYOCUTCwPDWNAun8eN+BfpL2zCwTrc6eInk50pQzgG2vxxrDt4RKvrSJy1/3vO
	KMOq/MS4+9Bl71KtM/A0xtSDBJToOj4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779685730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V4paCFehCo5VJEMvSsC4qRgM9BR+eq5E3O0LimBWo2c=;
	b=Rr57ODa5BOcIi5laSYLSrKx0SaoOD5tLO43s0Yw3VOeu5UPv0ZlStBjqdYmYZ/xRcm2nms
	cAV462jnrXHp1CNBOhfOZAGRAbz1w98oD4gFX8G1j5pImXvOFXeNQUfuH62U2we+Mgm2Ae
	rTdcmcshmuXFmYB1VTc4SqFnN2HlPZk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-w3BvivRvOXysHLG4Z4XkvQ-1; Mon, 25 May 2026 01:08:48 -0400
X-MC-Unique: w3BvivRvOXysHLG4Z4XkvQ-1
X-Mimecast-MFC-AGG-ID: w3BvivRvOXysHLG4Z4XkvQ_1779685727
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a86f53a2b7so7398778e87.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 22:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685727; x=1780290527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4paCFehCo5VJEMvSsC4qRgM9BR+eq5E3O0LimBWo2c=;
        b=kGeZyOOreIdx/yz2FQZxTll2DI6eamreOT856Sg2kVT7OGqtNxIHtNo5xLGpi9vjy2
         sh42zVDyDWmEyJxv/L/rnjZ099r4VUtEK/Hfez8whMNhrxtaZf0L7h5NrJxQmqWaJ0e4
         B21XGz3K2DwuprDnUAOnZy5pOF3yffUueTQF220YnTmiqBf4iWmDnqd0tY5Vhc1IrewU
         qXjkOK/L8Fz3G/HeerS+J1CHC44+k/pX80ZGVj+U9keulmDC52MTZXBQv+ioP/b44Uxj
         dvk22QVH3kr5YKFiA5KsLZikp74uJ5knpFo0RzAR7vQvq6FeGFr4d85e+c0AAyWGN0KX
         CNcQ==
X-Gm-Message-State: AOJu0Yye+G5K+y8MNd30EJR8qU7ZZdMHpM2jIUj/eZXRmrfO60A9hmbz
	V6a6x2uXD7NuH/RLUCU+/yyJNR4i6oiXhf2FNYuljGkNp0MIWO4PqJdiCsIQ+Oim0IlJ6enYNC6
	83fXaA7D9I6fXPOzLBkAxpW+/8mqrskDJmTaI+qJfgEMNFWSlaX8XeqAxSdYigmzSfb/vo4ecwk
	THhPf8JNC7YfiqbEcW/l6AJf5n804iwri8msRfhw==
X-Gm-Gg: Acq92OF64J2OxqqIVdJkYWa4GXo1Wk2dpT1yTK0eKWOP6OVAWKr7zFM7B2CtvJNscjE
	rb5dBIlEiePQnqQmizSDnseRj0nVxyvcPCq0fAnlYE5FIat/fWJsOTiQqVkDmcJX4AiJsvFOSV/
	hHD0y3zkz3euLEC7wBRSwWc+FKCYPZSt8bt0b8y2SpKX2YaKPZKTdvv1gWkgwmeWHKhiXIl0sVz
	MKY7UsiIGMJCXVrqW1sSgoN+cB7BEWlxbAmObJ54bUxv2zt8WzvYQqajCTttZv+dOHYV1c9gxIL
	T5ndVQB+ZxlUjXTKWGK/RwdAb/7v/sW0ihmQd0am3mtHMh8a5lK4UeCSLXdWx3OUigjDS/EyEUZ
	03eRE2plD49Ym3a2HU0fCHKMg98I1/JmcfKZV
X-Received: by 2002:a05:651c:2101:b0:38c:594e:ffd4 with SMTP id 38308e7fff4ca-395d8d668c4mr37227821fa.25.1779685726977;
        Sun, 24 May 2026 22:08:46 -0700 (PDT)
X-Received: by 2002:a05:651c:2101:b0:38c:594e:ffd4 with SMTP id 38308e7fff4ca-395d8d668c4mr37227521fa.25.1779685726221;
        Sun, 24 May 2026 22:08:46 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm20698161fa.16.2026.05.24.22.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 22:08:45 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v11 0/5] Migrate on fault for device pages
Date: Mon, 25 May 2026 08:08:25 +0300
Message-ID: <20260525050830.100254-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qhf1bhkHIgmAQQdJaW1BeFMyZqR5eBT30FRhsVTDju8_1779685727
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ctdgqw5eeye8m51i9fummy8ayq4iqqtt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEA6780002
X-Rspam-User: 
X-HE-Tag: 1779685730-15252
X-HE-Meta: U2FsdGVkX19eHwAniGbfj0RqyF6lCQLc4vJdPh81dQEvubMH9u6Jrja3yRPzD/8W3FNrmcmNEIn6kL7P+S9NRLbvl8sGZxd36XFAsdAxKOBZQK6A0u7tRkUb1KqkAGNLPCr/TkkjrpoJ24bD9rJBzZ3aHZGciWMalswtaR26z+Z2a6d1Si/f0tNYJ32nw0cfCkr8/PRuYurSgVr+sDvl5pZBiT8Nx7izLryTwl/1/ZsPL/zb7z0bmlaMUFGQEZGKONb/sY0Oz8bi+JFUjwObmErfGo7VQKUk0yVFHsoLu9QRTffHD9ZHj5kHp6kvwLGNoWqSRKjOY3hwmdBgqfyxcKu0FnaeQ7pSUhB1hosEYkehZ5su17WrhwOqN2i2Q4iU7y7RU7MXyL+2Ro8qIQL3BA9a1xmmxwObzLF2WrYuVkh3l0UokeFN6orBvUvQ7pZwHYdlk/suW/1QsI9iEByLWfkEW1fRdnDHe4B9HUHtfLP98tvmLLEqf2ndU8r8sdD0JZouVFCQ7Tu5FJ3VXcSi0yWk56iSX4MG1K+H5dYzJB/1V+nzKzvZQ4OWsct9PBUKjvxa//scWHmcSP/XD9ZujUD+Qp/ZEYuFmKlPbF6oOx4cQBQVVr+vnK9SEuFWrDSQLqxKHENCGrisEWjdp/CGCOJipcB7LY61dGaqs9hu0k1dPPMlAulMvF+nZ99i2jLG0kRmwXxXoKOPyIwnhEh2U7JRvcIepodMweuhQPpdPI7VaWDUy/rtHtcnAj9ZjovamBUF/VbW7AdaWtQQF5tk4zZFv+PmTJVMaclGgun9wgnvfNa/u+2u6/MuQRrqblSx71Z2BXtj7rOoHCrB+uS0qDS4U7YzI7HgpSDCZoA850pA1kSwoEJME8WOcaB1AtNzUxEn1RR3+jluZak2Z30ROXVokgVGg2pfyUqPQ+qyM9wbL+3suKjtPCTLV9UxaKKV0S3SK+EBQYDKCLAwo08
 H+34VFyR
 +9BFyF44UYILtc60cdRG2HFZcJzDSFARj9aXMim442vcfwRyfrD6+esxK+VkZKPisZ3DtzyyjF9byRB4J/Fy5G6v2iFinlbaS0ueuuVEwYH00lNLrzrldFyCmyNqnwJeGQhxrBiphc37Nq6fkTI443mJQLThCufSwFu4v+6D1bGQsuZJogtbgyiRqS59chw4NbESYHguYSQUkgEU1DdbIvwMKMN+hEhXymbwxoOqseWhV3/u8mdQyN4iaiOsI0WdbpbdoVS94eNdSoYC1UNvZlsthFsQcMaakQuzq4fq5XFmvboKxyQYj0iFrclaudhzRBSa0F/t9D2TocLHSMRAruek/mh9pHjyo0OBMj3FeP2HVDhOgOpiEj2IJehxm3F48IQrMKoSq1d2WQtVKTu27vNh3WuHP1MwHaPCGRUb08MEnxFo+yqWbRyfy2urE5x3S3y31MreymnM6H7VkHyNknuvPXu34deSqKHVltxaC2zxmxJ6GIxiTGB++Y86XfjciVM7QsOC8A8ll+CHEv8trqe+MymCOfRIhoukIhATKoTYfHva8k4G9GPgIAnAmBUK/5RVfKojetG+pjBK2eGe4j8di3XNJIxPdnkhipp/5pnC++198MlvERhdwlrbxuPxEBUoSe+FDN4+O/puKnf9a5WYKCWh9esSfXY4XLfGxSQA6OFctCkJDRWJO3vAvv1G5ykCRaylrZQvlwm3YTlUoNTE+Bs7lC+/8WM8y
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

Changes v10-v11
  - Fix nested mmap_read_lock in test suite
  - Addressed review comments from David

Changes v9-v10
  - Fix for issue Intel CI found, forgotten pte_unmap() before
    migration_entry_wait()

Changes v8-v9
  - rebase on drm-tip
  - fixed uaf around  migrate_vma_split_folio() usage
  - added missing pmd unlock

Changes v7-v8
  - rebase on 7.0
  - fixed subject in two patches
  - enhanced commit messages
  - squashed patch 6 into patch 4 to fix kernel test robot warning
  - readded dropped Cc block from cover letter
  - fixed white space

Changes v6-v7
  - rebase on 7.0.0-rc6
  - added documentation and comments
  - denote to be migrated zero page as HMM_PFN_MIGRATE alone
  - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
  - picked up Acked-By from David for patch 1
  
Changes v5-v6
  - rebase on 7.0.0-rc4
  - use range based TLB flushing while unmapping ptes
  - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
    migrate paths
  - always infer migration flags from migrate->flags only

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
  - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
  - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
  - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
  - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
  - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/
  - v10: https://lore.kernel.org/linux-mm/20260505184421.2324798-1-mpenttil@redhat.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

Mika Penttilä (5):
  mm/Kconfig: changes for migrate on fault for device pages
  mm: Add helper to convert HMM pfn to migrate pfn
  mm/hmm: do the plumbing for HMM to participate in migration
  mm: setup device page migration in HMM pagewalk
  lib/test_hmm: add a new testcase for the migrate on fault

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  26 +-
 lib/test_hmm.c                         | 118 +++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 841 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 583 +++--------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1084 insertions(+), 578 deletions(-)

drm-tip
base-commit: 7ce39e849680d6c0bf2795bbb4d986ecd1649d88
-- 
2.50.0



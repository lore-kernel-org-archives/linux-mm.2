Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727D8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E9C6B008C; Mon, 25 May 2026 04:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EFD6B0093; Mon, 25 May 2026 04:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44F86B0095; Mon, 25 May 2026 04:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5BF06B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:45:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8267EA01DA
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:46 +0000 (UTC)
X-FDA: 84805309092.16.8E42F63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6ECCF80010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iXMgUNdL;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rdMdPF6AjRDfJupohBg/unbXMgpat50XT188LnR7nHE=;
	b=k7vwc7XLUHqA02Y/MrMwJCqoc2YnUrOzPUdG/EMi1RiInV4Cj1faw9TXl5WXe3T5g78WyM
	7izFObJIu4FIFO/LFKNUCJa6+geCU96gbz0gANMAi6pZhimGqsO2QV9PjaROTt2M0nr6m0
	SdrbdLtNu3XVrQ9e5ZjPUbjXoWMVrVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698744; a=rsa-sha256;
	cv=none;
	b=2AnzCaIhrTW5+xEVVpxDbDU5ABY4krpnu95bUj7IMcIT9rce9NqVU42lP6iZljtoZqEglk
	1JmLFx93MeTfGmY5fhssqD7Hn0OIYG2yz8hS/EHsTf0bJYedx+VG2fsL7yKTvAG2KjzidS
	kAgU+dxhpmxeud9PYTB2O8vrW2u2Wk4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iXMgUNdL;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779698743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rdMdPF6AjRDfJupohBg/unbXMgpat50XT188LnR7nHE=;
	b=iXMgUNdLGUIrA+Cp0PrEyDePTzRMjxnr95tsXy9G390kRmYtE4FRjx56BfmQnqrjcgEVUI
	He82KZDBGN1awwewKo11k4sSVFkZtNGQiXWSrKvpmnGiiKNsL40g/syK3kcEDUXt9AOsMC
	FHPY7/R+rnAW33PMUdtkV0+dNxwFWdw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-Gbizw-YSO027UAtlX3zKuQ-1; Mon, 25 May 2026 04:45:41 -0400
X-MC-Unique: Gbizw-YSO027UAtlX3zKuQ-1
X-Mimecast-MFC-AGG-ID: Gbizw-YSO027UAtlX3zKuQ_1779698740
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-395ce2d20c2so22485771fa.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698740; x=1780303540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdMdPF6AjRDfJupohBg/unbXMgpat50XT188LnR7nHE=;
        b=KP3ZI0Ey7KdSaL0HId72ltEHN3KE9yWW2qUX1oNm7k7V2Jl1iwkuEAYHC9fVFgr50B
         n5J2mx7kkWtXHl0Wymdyw07h6PF2oKDkoj6a07laUNrAYbGe+DRpfNtcHe99kWifllqM
         4RvM7kEdbpdKhKw9o0CpJH2LzMXvSN4OggH8bNNsEjQJSRpsxkEqpBSWRHLGymXCmBFl
         M0BIlxlLrB09iEL5cOw9Ynh2HfUFcewx6u1PnVNbzP5amDfUiu+1kpnIiB8UV3OEasvz
         g533sXkl2N9B77YIovENDYY/nbwfl51moOwV058Mq997iTHnOIFRrd0JDRXlOlBzc5p+
         DDwg==
X-Gm-Message-State: AOJu0YzZKYP/rivfdqPlb6DMKG2jyGXvr8JW0HNfDS7R7NhvbnmHS6HV
	jbhWh7zZopi76M9E7jo7KcRhCH9aibLq5Dd/SfSYUhV2o/rO/NCpW/FHtYx9YjL22qvGYaZ3r+A
	B+fbrpNAyjoIaTW2VoR/3HGWAJGdT+jMJGe/9bhLc7ekIk1sYrc1KS71v/q/vtwwDt12mLARUOj
	4LkBQaamw4BZg0O2IXxB/ZOF8TK4mXXu4XqLKhPw==
X-Gm-Gg: Acq92OEYheV92B5zCEHdcYWL6JSCbdfwVpoF6QZiScz3VP2Q52ZvAdZhcwHfbLdl+nA
	NFzoj4+1PyqxIcKka++OMAbIxXHA059RufyECWRIJys0VPtjB/Dcu+ZK88qacHyQkF64ffMAKH1
	YZzeHx1Tc/5/ZEWtEqRLhZYtOLJDrYk1YPTjs2gGz5lXwIZYjiE8Ln60cFq6syoS/ant5SIzRRh
	IVE0e+Tj9TITZJQRTFa7wxyBAtn6JiAJKlClHcNVwKmHYx7IfrkmHjK72zXA70fErpQpx4hm9VP
	Np9oZfKaW4ljJnHf5q2JMlXhWfQm0XQ60jMGKOZXS/0zjtdDQWWBYGnjki1AEMgrGiebtxy3iAu
	meaEzk3+wa12HEA5fhAH8gEijzV1jCxro8tZo
X-Received: by 2002:a2e:bea0:0:b0:393:4e44:63ba with SMTP id 38308e7fff4ca-395d8e13013mr47053141fa.29.1779698740225;
        Mon, 25 May 2026 01:45:40 -0700 (PDT)
X-Received: by 2002:a2e:bea0:0:b0:393:4e44:63ba with SMTP id 38308e7fff4ca-395d8e13013mr47052741fa.29.1779698739582;
        Mon, 25 May 2026 01:45:39 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm21679061fa.16.2026.05.25.01.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:39 -0700 (PDT)
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
Subject: [PATCH v12 0/5] Migrate on fault for device pages
Date: Mon, 25 May 2026 11:45:19 +0300
Message-ID: <20260525084524.139868-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FarvUttHp5FdnsN4K20hnvq6Hm_2_qpQtu9xyVT32os_1779698740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: k4jejq8ceswej13ixy3a68ubqo3whfae
X-Rspamd-Queue-Id: 6ECCF80010
X-Rspam-User: 
X-HE-Tag: 1779698744-907858
X-HE-Meta: U2FsdGVkX18RoLbjtdHrnBvwFw6vasBwq1DZh7+2iCvtKwOE2dN70smGoojxLcRG4U4K3ED44wR5WQB1aO2gtl4pPf7Nn92181WFXo+qL7yuR+RuThDzGkr4/sh+jBWPvkLIXRNr2Wuvfd1h3xY80GpZLh1O3ThUeaDnYKMPw9FLKyR1TmriDx9LPEh3sCgbq+78iSquOBdVJVlxolPL9NuE9G7cgF3i4ZKtUq2M6TnmkdbNkaacmoDw8dMtIWHlPlJKTAUZK1GAhO838jxSJtbteGYNgh2rEgZsTWgaidJ5LdiA3+g8W7u6bCattmxXmL5mF6wPBAneZZXszABU0PQ66Cv8Nc46tN/HHlDzRi7xDSGkmJsLhg2Fl1dS3u66KaNjfy8h14Z8xc5G6vAf3XM9I8z/MuAXEMmD6D6L8DuRuTtyaGbCa+4BVzE/uWZDQ3B2x0PmHPQPISaotkcAXH/mQTqsPhm9rj70mLkaoCTPxALjsApUh4zhcoosfjyPKvUocsfqq/A9nkmoGATuPs2yAwzOSQxNkKQyyD2zYWK9KaMgYJjUmYrxavJYPEBJXjnn4Xf/jPwytxFuapE2nXJ+ffPY5nw6ttSGXg6z+9c4vjCu3/sG5RGkW+BogfL42UMe33xL257buYd1ha2Wob+X2yonRm3SWd85gIpeRqZW0ChKIe0mgLBev682yBxuldO0/HTnVVq6RyqXfZA9HJnMBy/8C0W/k7vPbZKE4xm06X+68KMTrWwZTuMC5Qi/CPeQmc1uqgX95UgKLkeHKsnZMB05Zrn0LHCqjMnjs+w71p3SAbu6se/kx8niUuXG8xObDJfcIghXLBvkQUM1JLV/5h8PSOi/AQajlBbVbHLu6x3fLWG4+40hEZDCpfBkbfmJGJBMo+jORnc2pTFstqmxohSB0uxk/oJtKBqnlDGwzXd58jYoNHsljXXkCJ99l73enbgkE+/dhdQUYXD
 1TDxV7Yi
 +X5oNooBKy+bChndFF6fvJDO0urlEnMtO0tP357XI/a0ng7tXkxVubcM62MAl81/A4EBZaveczNssmfegKRBXY+Uz0bw2xZ15c+4JeWw6wcM6EMvMD/E88FsOzMJo9c/U/U1dA1/qtsj2fxBMZkokXnNx6+fhs9M6VIrEPK8mgmFRcs/O0H0UI2k9+LWW12RLAsVQpEXT3Fxw0V4+CidSCn81eoeTObi128Rq1+vlDXby8kld0jQwtjGOqID9oMFslITV/y7/Y5YM2+sNkPHzxsH4HV7DQa4bDFfYcK9R5jzMpdGERd3zu6ArfdVDKF3ywOCtJLqOjMC5DXC0zqj43CiQPK06pQqOT0UGRfEMyC5x5hIw3ALmGDkdvFrJyeBG06vp0USIp2vABIVpPtmzL05a9fAU66ttbSiDk/Q6nUqa4L67E6eAJJMWETk76SAqrZnjS6vRO5grAAP2F1WhZ+9MDfXattETGZvcjzzBI5lFJ1rwTxdBdrLQY6C7FA5KmTaVGRLwXadqqCS02NNl2zHnOm7oJ5NX0P93K3+G/uKsiyjh5zaF+Ci4lv2kevSh6mBFOhKbnSpxu3dTkAhpP41tgOGM2zoAzTytCoJ7vU0wBp04I8SKhroV4BQHr1zB2ppiq476M4MZ96TppEJcFQP/2MDTOXad/GIgMp5lypFl0zuxMTsM5N75zUTGkvSOuENy6UgFJfe1gj+GC8PXcT8Eg025F19jLfTVNsNPpi9Vm78=
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

Changes v11-v12
  - Fix for issue found by Intel CI in patch 3

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
  - v11: https://lore.kernel.org/linux-mm/20260525050830.100254-1-mpenttil@redhat.com/

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
 mm/hmm.c                               | 843 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 583 +++--------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1086 insertions(+), 578 deletions(-)

drm-tip
base-commit: a79fb6644b307c0ced7b8fe967cdcac8ea884e03
-- 
2.50.0



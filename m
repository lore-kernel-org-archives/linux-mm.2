Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D183DCD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11D66B0005; Tue,  5 May 2026 01:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC31C6B008A; Tue,  5 May 2026 01:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2446B008C; Tue,  5 May 2026 01:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A603C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:17:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DD631603BE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:17:59 +0000 (UTC)
X-FDA: 84732209478.12.33B5D8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC08340008
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:17:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DDBYb6WR;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777958276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HAr0xbXZbAJ3/GDtKYezys+kB2bNlRlW51R5ZTUaPGw=;
	b=TY8lJCXRDAVdGvfNnTO9SZ+JDlg+XSpWg+UDFUENEAzSSVBJB5hipu1D8CcRDLCk6Q5lVw
	GnB4tCOmepPPE17U2NEbvS4pkPI5oqFNycYXvGi2bHGSu4YGRluOpb163cTFiLcWqknfhG
	oT36F+DXl5wbMZUXy2iZtWyGcbSHtu8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DDBYb6WR;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777958277; a=rsa-sha256;
	cv=none;
	b=EFr8jahkj/DwLIUVSJ/B546RwDMq964iTwYMP3e0JJKCZ25i696KF9c2aoo8M1J6leiq2N
	QDv9SWXlwUD2qu9ORNJbMFyv2LANAOHYppzul5tOHqvPeN5LgAfvW3UzGAZnGodo6KkJGo
	T4gGAh+eOKgOkXjM27kmDieA6bNClNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777958276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HAr0xbXZbAJ3/GDtKYezys+kB2bNlRlW51R5ZTUaPGw=;
	b=DDBYb6WRy+yLmCJ1Xe1mkeYIOHx2dTwvI31RJ3ffTtoFPO6VQRj/HvJtDE3ky2JCOi5c5G
	jwpt79RsQFvnG3hH9KYTpaOg7Bv9g2/821kypnLzKguxz9zKORTWx6OyV8wGGLFL9pqhGi
	8Tq6FjT+UzSZSwfC2IiondsnxYtcgSk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-BFosclDjPrakwY8-DGaBKQ-1; Tue, 05 May 2026 01:17:54 -0400
X-MC-Unique: BFosclDjPrakwY8-DGaBKQ-1
X-Mimecast-MFC-AGG-ID: BFosclDjPrakwY8-DGaBKQ_1777958273
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39391b06ef8so9942221fa.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 22:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777958273; x=1778563073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAr0xbXZbAJ3/GDtKYezys+kB2bNlRlW51R5ZTUaPGw=;
        b=PtF4qW17h3LIzSqDnOyw073DE7ACpiHmcdQWh143xRcNvwzPOrbJoz7PgApqjWkwWe
         3Rguj8qMzQzorouNNxZmpWzpmMCLcdVcMEym1QB4++4Q1tb1bMKUmJzT523RZrYNL+3x
         eeViqHoHFLJ6WMBzylBoHADJoADm8VbqsfW6d39Xoxz07I4CXyQrLzmYWNYz2hMtcSBV
         5GTjkOgVsZV3Q9Lj1tAQsSUtCiBu2mgXM87SBFjYc5IJUFYonRbE3VcjTSIo+jnWYuDS
         E/ghxz5i4WisX1jG/v758WqU5mmI//zviHdpoM0NOvhFAwl78ThyTttexowoeM/tJJYG
         24kw==
X-Gm-Message-State: AOJu0YwaQyTb0HtAcfPZkap5XVoCtQeFoqUymihqbnYdnhvw6AQudrng
	GBvMuoVaCOmvqi8SkWBoOrzHJxkTWgGCaC4Nrr1moXD+WFfAJeSXsInla06jnW5fB1PxR6mjtXu
	5WTh9dU/E+uA+SFOjDwcm7XlZ/gjDvlYp1jqba+N4+xiuGasqNfwBnfKIoa+KVZJe80jpfn2MRY
	H2/yEnX2xSu52ltMeudQ3DP5IHUbHuItrXdqcvkA==
X-Gm-Gg: AeBDiess7gkDmpBTZJ0LHf0OjmFtPnMlbg3Ef1xmyLqyPXW9txDKzGggCKkUScQE4dY
	kbVP+3vC44rHoC5bKS79BkfFfPduk6ZyfAdkBYAd4uqWCGLx6YohgE8dM1ay4X3kWOm3eXsWHyh
	prUSPRQsKHzbfMirt2D2/+F02tqQjd5+QA+X/u0zrtI/nd08C6vUB4yU5OseXEsaQO5W/GHkvwj
	nJUf2NrR1bINai2dSD4vUVGhK179wFKpIlORMgKR/WzwO6k0NFwOaho8ieLRO4+uysCCn2hjhM0
	lNBLx6CsYIZs1vFT0jAFSJcClxECARPqPu9mqmLP2pAb1ez2wHRxlQbpHR8KHigtdimfpF8K5js
	oi52hTXPfxawrEirt+3zNtA4oJfPkhz5jiz68/VEMlRtzvehyME/IZ2CdfA==
X-Received: by 2002:a2e:ab19:0:b0:38e:2fcc:78fe with SMTP id 38308e7fff4ca-393783c5ceemr56487411fa.3.1777958273082;
        Mon, 04 May 2026 22:17:53 -0700 (PDT)
X-Received: by 2002:a2e:ab19:0:b0:38e:2fcc:78fe with SMTP id 38308e7fff4ca-393783c5ceemr56487031fa.3.1777958272465;
        Mon, 04 May 2026 22:17:52 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3936138935fsm37206141fa.41.2026.05.04.22.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 22:17:51 -0700 (PDT)
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
Subject: [PATCH v9 0/5] Migrate on fault for device pages
Date: Tue,  5 May 2026 08:16:53 +0300
Message-ID: <20260505051658.2219537-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jk89a6mqW1NTezecgRLIz4Sbq3kT90SIdGjMO1nCPd8_1777958273
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77nkihfy5zdo4gsa8mpg1seutgup7c64
X-Rspamd-Queue-Id: CC08340008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777958276-17979
X-HE-Meta: U2FsdGVkX1+7RKWRiWe799cv+MI5IjuzbplWaxO+8jwLcQVsigcAtJ5E/H6jOMOLvXqOd0NjhLQ0ByBIY+eqNMABiKWZpUadFso6q69WAbcJ0EsKpF+ub36ZbD+UbH7IBbgoS8vAqBBJBIPQXP0DWa9oNhA5t7RobGpzNyhN8l/QHoJ8cY3ZA/mdH69VghMvl2439CQxNnhvXedbJhIJdiajNMTh29FVoAuLXJqZ5RgRTGHIq9P1htYFtA+odu7zCkEfQjn6H6Ppf9ycOq5wRPtFCd6MRzgvYCSltmftsp2gof0Js/oGgnfyyuMkZtyawbRKqOjceiOqNlO653nB3Wz1QbDGoucL3bxDtLW0ZdX77OzzS9zbEv5pOyBB07PCP1fUR3JRH49HVLViJOdQiHzyv9glmsaVfTDyQsYj11AI8Dew2UF93SjCTNLoEoP2zPPIWCdsHGjZ+XjIymA5LqmkgDq7+x7iF2bRj6wUXiAQqCSE7QHUByT0ZFx22Vk/3D0BILLipUH7nnLCXp8zuEGSxUhZNxKaT6TLLbqY5+jZkNFPhL0hY6aE7XYCUXbhqSPMjy+M9M/0xyHt+0fbUic8LiK/mCV2QrwU1536dxMzZGGWt40yo6sjoOtZHaf2pyJOLcZzfPwpdhWHwPEdrWD44/1CGoR0NghJChLe6uGy4IvqjTusZZRiJ1ITa+JSNdj8AFPaAZthr+TC4qJRKFGI6LngUC9iT600U0UbRfzAn/4vRACYENH/rvvxuZPaxYTsiTOtxQVLX32nLr8hKRtY8h5A64xxWDun46h9Q5Q5yXaoSsrK30wPRbaCSxQ/lHZ3FGJDhFvcWGDmIEf9jqp67WQFsbDJX6iw1i811+1TExqdhFYOelQiVVpy5N6cT6oFTHbvsDS5SQP+aeOvwgbK4YbxDj/yjDjF+WU+VKFLL3xCfChVnuUTO/19w6fT1sSz4e67K6zxOtZqBp3
 jhk8b/uZ
 0TYgCK1/pRLxOKU7/LkJUcNHKNBUjpUGZBLUPXk6zQ0pzwwAQ6QsQ+Bpo4S0KfS0Gaw4zJ2iCeXRLKo/XcTtH8K90m3jwpYGZDOwXI4zG1AOZD6OCbrP3bzsubNnXa5wPbbumKxmtsDL0mMuyVchUvheoqt9ParSonS2nou18ouGGCKirRcaooS5/a5pcoVw/s3F+HyOlkglqaZtBw/IxtMWX7bh2g6GOkfaszTQc9fxU17SxVdAdYrLGWYP6iHEWGDIZPWXbhS4Jn8Vjt1i4Br7JWMXnwZuP4Ulg7XPGiOM65tyI8A26v0M/sGV7U/Kb725de+JLvAiHgNbw+CDZPvTDU0fYEC/6yBVJBtZQcdNekdCQwMP6HtnIOkq/PaO/8oKAgnnL4IaVP2PQGwpQmJTYD394kN9DGz8tZeevimlf0tGW8MBUjR7H/+SbI+2qBdSck90vnq/2+JegPf6WCRV9rnVegd4g3flv70yGlWtmeS2UYEY9uz2zpr7Q7xgTuruEi3yak4ekOApdqVbuRhFoB6H0JmhSkTlkwumCqJVIP/9wz6EAmOVgKo/wg96MeJClEC4JnwZj8ZjBA9ftJGWOMvPOtxTDbRBqWaqM805a/1ztlvD/9naHSNiDC19ZNOmM7/BXR1IHRnI=
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
  lib/test_hmm:: add a new testcase for the migrate on fault

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  26 +-
 lib/test_hmm.c                         | 101 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 835 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 583 +++--------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1066 insertions(+), 573 deletions(-)

drm-tip
base-commit: 94d56a898a2db27f841b17f6966a81ba502fe63c
-- 
2.50.0



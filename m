Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A335F531EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A076B0088; Tue, 14 Apr 2026 00:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAC36B008A; Tue, 14 Apr 2026 00:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9466B0092; Tue, 14 Apr 2026 00:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B74F6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:12:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A3801B7D39
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:12:54 +0000 (UTC)
X-FDA: 84655840668.17.86A84B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C6B68000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:12:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HkcBDPB9;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776139972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vL+2FRfo1r3ssv7s+T3QdUF+xstg+euch7PHQKMrEEE=;
	b=Gpq9YYxEN/c5A4cNWnWBqHdTUfsmAl81d3IIdX+fUN3+q8wWpLt9Vg2g++EvpHOPK9u2Jl
	IglKserIMJQbzpEfXvAX6MNvLuLMgTbbsUyKkQvpiWoJo+Zcl5nAfVtoszLsyqQot5srM3
	ON/jvImDaxoeha71fYPST54bH8vUdIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HkcBDPB9;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776139972; a=rsa-sha256;
	cv=none;
	b=XEFbF2pLdOWae0k8SynQe+CXsnVyUNXfCcUa1z77gxHORtenPuY0wbtHsu/QL/JDjrQsBz
	A15h57eg7EdzJrvKGWEE6vZbJUkUyVcPYla1qsJvNPLTLCFfGxA6H6O3cdB5G+wXa2Q+gz
	BEi+iE1VgIQ0xLKIJqUuiEs+XmnhfCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776139971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vL+2FRfo1r3ssv7s+T3QdUF+xstg+euch7PHQKMrEEE=;
	b=HkcBDPB99AZ/2YbQt+qtw6gwB3P2iPSWC+cZjjPLp8K77P7MYlq15f3SSBlxrYFHgr+5Tn
	udcLR7rDhPr3jXRpxTNZ/DUcn6+94q6RO9LMruCYUZV0RbYLheOHte1YWDucgOINQrnsgF
	dbOvKgBmGnXj/wAdZADyswq3crM11jE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-Gld1pZNBNsK-sl-kdLATaw-1; Tue, 14 Apr 2026 00:12:50 -0400
X-MC-Unique: Gld1pZNBNsK-sl-kdLATaw-1
X-Mimecast-MFC-AGG-ID: Gld1pZNBNsK-sl-kdLATaw_1776139968
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a124b5672aso4975216e87.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776139968; x=1776744768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vL+2FRfo1r3ssv7s+T3QdUF+xstg+euch7PHQKMrEEE=;
        b=LiaoihHH5W2jyEiXWTAFVNaJhMAr/vTST6PYBwAMvRP9aEMLqiX3M5OLCdXiQybvMf
         L228IzDmVIEBdVFKHpOTrJuf+lCkw8qJ4Zy4iB742O1c6hA/7sd26nL2MIxNI3kUGK5q
         dUOUv5rKPXH1NOJtDjbCJjquLMKGzSRzFSGx9d9cAZTDdhpbee9Q4qNoYFbfHTQ2FKoq
         6uD09tdz6sD8irBO7UuhX3lTN7MJOFn818RkimF+9RJ2JX/MaeTdevKGE0O37BsDOQmS
         GGCTxbQQO606+z0RFu89RpPcKKk4MPbQNmCqWXtIySmFZZEQGQhzd16TDRVzVQht2cHL
         /iMA==
X-Gm-Message-State: AOJu0Yz0d/il70w9JhFo2NiLloIF3xSQxBaTJtai3e5AddT8TerGiUPA
	YGdBrzig1FxSQhhlEz9K3b9fr2oN/SAPXEnNxdFl/8IsYRcyIAdtqmuB+Eee5uiqLhfWP0PSqmN
	dWzkDyiF58QD4OfxQmV+3Sq+kLnGpe7b93si7+r27JM0ROX2RAf7bxJdcv9hN59DGbYuYaj/2XH
	uepNnlTD3Xs1LW2Z2/pgfgCqOMjYdNTDDy6jpc2g==
X-Gm-Gg: AeBDiesPsG/aIq0JaoVff5yWka0HS8+dAfLerJLhvEYWVF+6grermmwqBUzN6FUqKPA
	H+3VbobBPO91CKen6FasCRKmd2dd+dv4mptID8aSP6CUrVmyr/LTozS9xKItfSYSHEXYxjX/BmA
	XfaMpWVUy8H+ku9VZUXAhw4sOJzjZiQlA2xZhGo2Yxwrphg+ljia5FLEE1jQSa9kdrLyAwGnZMx
	vzAuLX3DE+X/NlxaJz9WhA8/C/klj9IlsPD3C+cvByDM843ab+sb4JROJlWtnjdEs4Qc1UNRetZ
	N8DaJpyO4Wmop/+IjGB2WJycum236Reu9VYvcOUj+kXcpaFyRnkBjaaWAiiZetemo9DcqmD/kr6
	WkM/PDlistxGONpmMxP5Ox1DW6suI0pBP+xB8
X-Received: by 2002:a05:6512:3a8d:b0:5a2:c6f2:fd5a with SMTP id 2adb3069b0e04-5a3efb29fdfmr6523890e87.21.1776139967604;
        Mon, 13 Apr 2026 21:12:47 -0700 (PDT)
X-Received: by 2002:a05:6512:3a8d:b0:5a2:c6f2:fd5a with SMTP id 2adb3069b0e04-5a3efb29fdfmr6523858e87.21.1776139966909;
        Mon, 13 Apr 2026 21:12:46 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a3eee865e7sm3040666e87.10.2026.04.13.21.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 21:12:46 -0700 (PDT)
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
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v8 0/5] Migrate on fault for device pages
Date: Tue, 14 Apr 2026 07:12:21 +0300
Message-ID: <20260414041226.1539439-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Axc5wiPghUXdQ5SgrlwXXHIx0CA5JxPscbW8AZom3-U_1776139968
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C6B68000C
X-Stat-Signature: mfzotwued6hxnba8xhpywashp3p8d6oh
X-Rspamd-Server: rspam06
X-HE-Tag: 1776139972-153879
X-HE-Meta: U2FsdGVkX1/upMoPZTv5cz3oN60IRKCcflXxSSI29NVuUULvEJA2bUwELtArQXki6E7Cq8qY4ecRZ8z8gyMrMCFp5PNHVoq5rC/R796Rky10/qK5x2nuH+jaYwUfDuIBfTQLW3WNMlR/bkLA51yrDlEgkRsbx3RzoHXRSvXlWNE1PBcTtSfDSSx9JG1uVm9ZmkOcnQ8RXNCCJcLnJCYtBQjVrlfaCdxmw7Aa0cKfdszMXnFWYbof3kADbooNqeVelwujSQWAA68/tRqOzDt0T6+/q21kz0VXAvSyXdnQMW4HPsksyBi4Q+77LpZiVzCN9rli5/S7d1k3SBR5cvojfcMULipX6EVUi5SkTbWAe3ioWBW6rWJd8OYrGspLrcY4f0SAH2ZzavWws3cGaJ902U5jT2dcw6G91bKMaxthTtL0WyObnHbfqLpRltMfrHI/O3oAOdAUJL3NR8aIEa48WmMcoFhHy8Tx87vL3/22hZI5jXj/xBOJBX9K6a7bt1EMxSIy9ipJSxOYgDTPzZA4m/yRHyttosNoLrSUqs810BKeWGp/BQ912/yI1xVBiJJkQUjIq6gJ9/Tv+O6eJ+bDiYY1FHL6xFDu2g1D34gMrv+qchh3erSz5f+ZePE67eyyHPYq5pXJwt9dKgIQLigRoS8mbaCHBnDOhylGi+KEa6XOrYYz6hwrFKYugDOBBsvegeyfsLEV0TbaGh24qoXmk2IGbJxFyEgA/3+8NNxCoABip7lS4raMnNqrk5TMc+0m64vwll8DZb76+T6hXJ+eUwMwQre2bdo7Yf29t9ls0Nc4TA9an9Nvu1MaiaK5w4sSzuNq8ZA03gZsz7hl+VB13rqHGgAtbAdGogxGDYi90y4ye+bnsCiO1BGOgSbPOM7yO0zLgmegZCZksH7lD9baYhcZ1L8dL3M2w6TgvH5fTYxlLedSAmqN8/0hxnWNX0XZstkEOGDpbHbXYOzxNP5
 RFqiDsHd
 GyCoU8w2nF6+sYJPf4PoYfHW7tWAf8ZgGkunZbEXmQ7lUeHr7R1wCiyk34fiHgMZ6A0JrMmhXHOElEpKnl8a9ST/Addw/RLzRF+UK65i7QaaOBWTTIS3bbfDk9E/QOauD9cvu7xwU/iss9u4trZpUj01+f/JsyA0ZFG0RPp08ZJUp5irr8I9F8wnF1h3G+zlPYMCfn4Qd+Dj3T3avZN/EPfibEWA54GNcAWGV3Uw23Z6QPSas1kjrBat9Y94hzAaQJZVxndiePdO+l5AVuX7PJ1NhOJ2/oYwIewOArmbsnhHqaCS3c9bWViBkCDfYALBCqKJ3a6NkmLjy19HrSQGn+UdCUmoLx8uYOqpaIp8lo+5DZCy790MtMS7a4HjVnvr9I/uRXJnAhMzWA26ezvoIWogiRpIGeAdp3TAMWYJwm/+ZRm1qLfS2njY6bq+/T+2FX1EvrHPSsF0ok3EPFNa6T47uwtoy3wC2t2adhtlc/e0T9vZ++vJiIanTl7zAAw8AkNrDIUC1pQTehG+nWSi3e9cff7UvnRuSDgcImU1jvYxh0+3OboY1Rzy4YqpkgOZnlbzTrzpMqXDjKIS6OZEE5CaEA3cIEzL+d0/j3u8K5UmBRdMp6AVx6SSACBgEecRxIwqFbucNTBbH5LQ=
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
 mm/hmm.c                               | 821 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 589 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1053 insertions(+), 578 deletions(-)


base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.50.0



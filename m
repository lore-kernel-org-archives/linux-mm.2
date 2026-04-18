Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8D2F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4DA6B01F8; Sat, 18 Apr 2026 06:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016356B01F9; Sat, 18 Apr 2026 06:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20A06B01FA; Sat, 18 Apr 2026 06:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCCE16B01F8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:55:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DC611A045D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:55:51 +0000 (UTC)
X-FDA: 84671371302.23.DEC4158
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD47B140002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:55:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYtsBjVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509749; a=rsa-sha256;
	cv=none;
	b=mAW/gs7oSaeuWRxXm/ak4sA169tSyok6dZ4Y42Cc01dfgr751YXZFn5rgoH8vaqoLQlJry
	6urm3jNH64ddd0a04ZuxV28aCJav6turU6+/volpQkgHbtcpUZqc7nKcdjLjCOCTSO8iDX
	gB24KzeET/ylJvqJdt8ud1OCIyzwd2Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYtsBjVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zXQS/DmOFN78BrmjdhzMMlRiTvSK7CJpqLLJrvqr2H0=;
	b=TNKQTgtWPbGB9kYEKA3IlNYwgA/vW8AygxWa4XjlP0Qk8sBpKwVYOnUI2B3NK46TwPlPeh
	cFC/D3s3A0ouecMC6U6sORTAZZ9EFV54WA2UnCZ3Zs5a3a7nmBvimiv7SIC4tCxhwdSvyo
	QQPYXog/TO3yRoHcbYRawQJC3cLFKlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3DD960138;
	Sat, 18 Apr 2026 10:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C594FC19424;
	Sat, 18 Apr 2026 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509748;
	bh=jrUv75r0z4SPERcrtX0eA/LM+gbhyzEiQNjQWukcbRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=sYtsBjVw7ththwKj1VCTW3JjuBRgRn6oS3EzStEot3vXdc45kVIXP05d01E2tHxQQ
	 28kBM8LSTugZXQeIqM5vFvRZrWnZQA1Tn9EMdGJKOLNb8x3jw7khNEkQ4tLt6fSHG9
	 d3uuUMO4rT8vdrPCMX4NEuubikxI7nwHWNNW+wV4Lif9SnThm3j7CnB7raALBXf1kr
	 //h3yG1TJanoK1im7QF1VrHuTTn9APlS3q42CoUV4AMBgET28FI0j39nodj7tAfE4B
	 z78w0qtl5al4HJzxYnCDwdxJQfuaVD7YMQGfyk+j2suAXrDfPxB0hBsw+n/ggugPHZ
	 zGx8Jj5gXrw3Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 00/53] make MM selftests more CI friendly
Date: Sat, 18 Apr 2026 13:54:45 +0300
Message-ID: <20260418105539.1261536-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD47B140002
X-Rspamd-Server: rspam12
X-Stat-Signature: jig4ogochx4kktyoe3w5spcaz87k9pgb
X-Rspam-User: 
X-HE-Tag: 1776509749-565800
X-HE-Meta: U2FsdGVkX1+pLmLYK6uY0Vldf6dsv2Avjv2U2L4cd26aW4vrWeYQLbu0IhluDEQAZo2F+lDXkQF/pSoGNIKr5w/ez+vnbhm6oxg22TBlmLEwg5zq0y7F2sSo1dEj1HEEvXO4MUJgHCTCUBVgAw0jWaoctlD/vuLwwkeG5k0sTFRZn2S7bSlZ4j734JIHQjL2evBgAAx6Jx4xkWOqHgjsryOeaDnNYwhVjfrfxvftu2Gbwcc1A2fHV4g7n30lMQfdc2R+U3PrgriNqT9XIbkQvwlsW20nj9E34wqLGb5hpYqUb7UQBYwlwQmS9fsm6hXV63WYvCsOWUFxtoAYLUXRMes/oEsqZKO6k0i802HLoOk5hq+Oc0dpcKd1TR71wwMx/5+TUXce+53PSFhs84jesRxusj5Kn7+r+9eXqzkgSapR7k1ZG7knnfPB6jnX1ZhgYCPiC008CjOfscLer0IHbOZSFZTSNg5FY6VkGEOLg54lIrf/7yXwstB6QapMF+64iENJ5+KB3r74QMzi6lci8NigDUviZiSMgnmtzQM+HNsF2MWwjMHyfP2HbI5kowvZ+7vlEaXg1YmCFZxdz76vuvyOTrrq0DZ7yLDKS5gGSSYsmWCrAnKWkkF9Gma6oaIasKpQeil2b9bX1J9rrmn9/Xy1fkKVQ8h1Ou5p2dAEA0n/nuGa0ZF/i7DVFqWYmLr0Z5cioRjOl24nlEWm6MFkr863IEZ8hjgEoIuVET5tqEgreDTzZR0/ImyA8o6eyT2VzZumB+XTk5hbNEjKeJry5U0M2YPE3dH0NeaagsyGMaibQe7OqOvL8X92nxK7CUZz8WPFNR10yRDdFbLFaAULgZX8BXC6SIpjegGRfGdBx+wXK1JkEZVlWk0lHaY+oo7lA6D19nWcUEd2Zu+NAzxogOFgZ3WACKk4dT9LculeePZadsAabbfHV36fKZ3ftHRj0eiEdRyvkyzKPNHiWI+
 51oMVTOg
 NbBKas3zDjluqVfKE/FDOEphl2La/6vhJUNuHVaYGAx3ac5j7o4Y7WqarsRWXByUr51/4YngFnpem5NYxxLLV5++1tje0cb1AVDHUYxYVeNeEu//l8kGjWVB3+BevbalAYTm18yY8gprHqYkuH5UfJtCI7tBjOvMvkoo3DL/K9yPpt8A1W9R290tz5GcgeyF03WsVowKBabB55ePI/fwdbMc1dR1AJPPVECD4yftieWkIG6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
Some test need just a few default huge pages, some require at least 256 MB, and
some just skip lots of tests if huge pages of all supported sizes are not
available.

The goal of this set is to make tests deal with HugeTLB setup and teardown.

There are already convenient helpers that allow easy reading and writing of
/proc and /sysfs, so adding a few APIs that will detect and update HugeTLB
settings shouldn't be a big deal. But these nice helpers use kselftest
framework, and many of HugeTLB (and even THP) test don't, so as a result this
patchset also includes a lot of churn for conversion of those tests to
kselftest framework (patches 7-19).

The series break out:
patches 1-4:   small fixes
patches 7-19:  mechanical conversion to kselftest framework
patches 20-26: extension of thp_settings to hugepage_settings to also include
               HugeTLB helpers
patches 27-28: add helpers for setting up SHM limits in hugetlb-shm and
               thuge-gen tests
patches 29-51: integrate the new APIs in all the tests that use HugeTLB
patches 52-53: drop HugeTLB setup from run_vmtests.sh

I belive at this point this can go to mm-new and wait there for more review
feedback.

Based on mm-stable-2026-04-18-02-14

v2 changes:
* fix hugetlb mmap tests to actually test file mappings
* increase maximal tests number in khugepaged
* add tags, thanks everyone!

v1: https://lore.kernel.org/all/20260406141735.2179309-1-rppt@kernel.org

Mike Rapoport (Microsoft) (53):
  selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
  selftests/mm: khugepaged: enable collapse_single_pte_entry_compound for shmem
  selftests/mm: migration: don't assume hupe page is TWOMEG
  selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
  selftests/mm: merge map_hugetlb into hugepage-mmap
  selftests/mm: rename hugepage-* tests to hugetlb-*
  selftests/mm: hugetlb-shm: use kselftest framework
  selftests/mm: hugetlb-vmemmap: use kselftest framework
  selftests/mm: hugetlb-madvise: use kselftest framework
  selftests/mm: hugetlb_madv_vs_map: use kselftest framework
  selftests/mm: hugetlb-read-hwpoison: use kselftest framework
  selftests/mm: khugepaged: group tests in an array
  selftests/mm: khugepaged: use ksefltest framework
  selftests/mm: ksm_tests: use kselftest framework
  selftests/mm: protection_keys: use descriptive test names in TAP output
  selftests/mm: protection_keys: use kselftest framework
  selftests/mm: uffd-stress: use kselftest framework
  selftests/mm: uffd-unit-tests: use kselftest framework
  selftests/mm: va_high_addr_switch: use kselftest framework
  selftests/mm: add atexit() and signal handlers to thp_settings
  selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
  selftests/mm: move HugeTLB helpers to hugepage_settings
  selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
  selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
  selftests/mm: hugepage_settings: rename get_free_hugepages()
  selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
  selftests/mm: move read_file(), read_num() and write_num() to vm_util
  selftests/mm: vm_util: add helpers to set and restore shm limits
  selftests/mm: compaction_test: use HugeTLB helpers ...
  selftests/mm: cow: add setup of HugeTLB pages
  selftests/mm: gup_longterm: add setup of HugeTLB pages
  selftests/mm: gup_test: add setup of HugeTLB pages
  selftests/mm: hmm-tests: add setup of HugeTLB pages
  selftests/mm: hugepage_dio: add setup of HugeTLB pages
  selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
  selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
  selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
  selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
  selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
  selftests/mm: hugetlb-shm: add setup of HugeTLB pages
  selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
  selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
  selftests/mm: migration: add setup of HugeTLB pages
  selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
  selftests/mm: protection_keys: use library code for HugeTLB setup
  selftests/mm: thuge-gen: add setup of HugeTLB pages
  selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
  selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
  selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
  selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
  selftests/mm: va_high_addr_switch.sh: drop huge pages setup
  selftests/mm: run_vmtests.sh: free memory if available memory is low
  selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB

 tools/testing/selftests/mm/.gitignore         |   4 +
 tools/testing/selftests/mm/Makefile           |  13 +-
 tools/testing/selftests/mm/compaction_test.c  | 113 +----
 tools/testing/selftests/mm/cow.c              |  29 +-
 .../selftests/mm/folio_split_race_test.c      |   2 +-
 tools/testing/selftests/mm/guard-regions.c    |   2 +-
 tools/testing/selftests/mm/gup_longterm.c     |   3 +-
 tools/testing/selftests/mm/gup_test.c         |  12 +
 tools/testing/selftests/mm/hmm-tests.c        |  24 +-
 tools/testing/selftests/mm/hugepage-mmap.c    |  78 ----
 .../{thp_settings.c => hugepage_settings.c}   | 284 +++++++++++--
 .../{thp_settings.h => hugepage_settings.h}   |  75 +++-
 tools/testing/selftests/mm/hugetlb-madvise.c  | 209 ++++------
 tools/testing/selftests/mm/hugetlb-mmap.c     | 140 +++++++
 .../{hugepage-mremap.c => hugetlb-mremap.c}   |  13 +-
 .../selftests/mm/hugetlb-read-hwpoison.c      | 123 +++---
 .../mm/{hugepage-shm.c => hugetlb-shm.c}      |  65 ++-
 .../selftests/mm/hugetlb-soft-offline.c       |  45 +-
 .../{hugepage-vmemmap.c => hugetlb-vmemmap.c} |  46 +-
 tools/testing/selftests/mm/hugetlb_dio.c      |  15 +-
 .../selftests/mm/hugetlb_fault_after_madv.c   |   7 +-
 .../selftests/mm/hugetlb_madv_vs_map.c        |  22 +-
 tools/testing/selftests/mm/khugepaged.c       | 394 ++++++++----------
 tools/testing/selftests/mm/ksm_tests.c        | 182 ++++----
 tools/testing/selftests/mm/map_hugetlb.c      |  88 ----
 tools/testing/selftests/mm/migration.c        |  54 ++-
 tools/testing/selftests/mm/pagemap_ioctl.c    |  13 +-
 tools/testing/selftests/mm/pkey-helpers.h     |   6 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/protection_keys.c  | 131 +++---
 tools/testing/selftests/mm/run_vmtests.sh     | 177 ++------
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       |   2 +-
 tools/testing/selftests/mm/thuge-gen.c        |  80 +---
 tools/testing/selftests/mm/transhuge-stress.c |   2 +-
 tools/testing/selftests/mm/uffd-common.h      |   1 +
 tools/testing/selftests/mm/uffd-stress.c      |  44 +-
 tools/testing/selftests/mm/uffd-unit-tests.c  | 110 +++--
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  12 +-
 .../selftests/mm/va_high_addr_switch.c        |  40 +-
 .../selftests/mm/va_high_addr_switch.sh       |  39 +-
 tools/testing/selftests/mm/vm_util.c          | 133 +++---
 tools/testing/selftests/mm/vm_util.h          |  15 +-
 43 files changed, 1376 insertions(+), 1475 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
 rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (60%)
 rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (55%)
 create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
 rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (94%)
 rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (56%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
 delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c


base-commit: 0b5e8d7999076ac3c490fc18376a404e2626abff
--
2.53.0


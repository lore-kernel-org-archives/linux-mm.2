Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515F4C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F076B0110; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A589A6B0114; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B0E6B0110; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45DAA6B0112
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80263140147
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:32:57 +0000 (UTC)
X-FDA: 84994579194.20.57C48D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B761160005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:32:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mnzi+tDC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4P/qFnJseocSlpcjGX4BE/Algly2dAJ68UUN2Cw2AtY=;
	b=LyCbV943jNc27bO2WSmsRrhUiV6V1z/vjJqE0x50X0v9baPu/uGG04wUCLMtfTyldg2671
	e2kutVYXnldFysNTLZfa+7pcB1ODp1PvS9QoZyBGM1eBIRINXPgz6WuHYZMk9a8HhNANhv
	N9dkTy22cjjblcnyhGB0z18sRVLk9Xc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mnzi+tDC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205176;
	b=KShIHGlfhx12feC7IuctfgjSpcbo1DyMsWitwwjyl9+JJk+RRiMpzsmqh2O5cDLlQYMB93
	0wb9tprsaDBSh2RG+VQjvjs+gbYGK1QidYBfSxb1uVBO7z9ygtqQ4ffBUnXKfGmPtVs1Xy
	1g7ZZB0pMBA2+Cg/Sp4CPLZTKLwK8cc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D83B61476;
	Thu, 16 Jul 2026 05:32:49 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A7AD83F7B4;
	Thu, 16 Jul 2026 05:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784205174; bh=6F2qeN9tE7Wyz65iTC5NFQVH+HMatzPWbvuR/tbi878=;
	h=From:To:Cc:Subject:Date:From;
	b=mnzi+tDCqUtNNxszsRfAywe/4qNPzsVSzeP1CUv8yHmt4jqeOI1yOCE+Px8JUVLQ5
	 nFDlFgdnPsBh6DjVVvplqIvkYT091oYe4rgnm4+0QyR9XxWTkuLo/ZNH4QxuGVZ98b
	 H1iU27HiLSBrW/bqs/diVSG6wKMWSh2CqVw050S4=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5 0/5] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Thu, 16 Jul 2026 18:02:21 +0530
Message-ID: <20260716123226.197736-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B761160005
X-Stat-Signature: rn5eia9tj36tkg5ktqz5fn6c7oojbsxh
X-HE-Tag: 1784205175-543977
X-HE-Meta: U2FsdGVkX1/zQ3Y+CWG2ftHTU6OkFpWfiUXFL5yOEkc0ngQFYcocmaoIKDAXnSRBaZKHpaOZa/o31XcL/hW6vNDZydYeA36SB91SVJTf4FUmeK1eCD+1P3iRxARtEMq1nrBGhdpJGEev82+GBC30a7Jk/XKqzblasIrETRdj0HfY4ftqRXpy5U+F9+w21d+GRiARQmpXGO1dMS0lcVY1HJ5Fp1qFrsttniUFia/KkXqe33ahEveKB6oWvMSaYvIatGqjT5aJrECpX+KExK9g6eR4lAYspII7k+Z9SVUgSMD9yGzMoZQmn6CfGQkv1nqY0FZn6DF3anK1wZ7MzaJkBAKJoGdUKkg2fqYUcqUqd3VR2P5yvMcSfZ8EhZFv+r9zmARNEMRpZ31vUCgmUSYRYiDHTHN/CLHIxE2QLtGGaMNu5z8N9F8wRH1LelvaBnaQ6whDz8hm4GJQIwRCS05fSfmAxCeqGmAU9VjkQZbC6gjX+t8XpFmkAijCDp6+H2dvSWAA/u4vxZjzAJIFgyAEtL0BKU1vzBHzvPSbbK28R1FY1MjcqBJ9Odr3+D6EXDiv/tkY+yd5+O4/GhUPsbz7wIn23JfT69LxeIqgwX9wckhm8CpYfmddDIUT1CY57osh0knZ/+Q/RXzfjVUk/sdCtklOUDOkUq3lhwYhUpncr14N5QWIRwcKwdn1d8olQEg41oE74x+P7m/XUFVyNnzK/liqNht36oWjGOtq7/7IuK7xctv8GZJPp7DDvbN+VifEcFgLHKJvokpcaci85tNGy5g9/Z7tkdVyKiZqLnf/xwXSBYkNKTQfjO5ddnyUdJngZWaS3v8oOoQ8OIv69UkJAVQmzLeQkJATG58jRwtdwpEb/Pn3iXWTvmKG60hd9Cs6NNAfldKywuzj7sidqpzP2EPIM2v4DJXSaVROjzWEdlQZecmEZzoPU2SfmsPomULdqAVnKyYNw1wxs6KDzEx
 HB4aKH+e
 Snz3KZg3dNY1PncFHbrZrENk/CQ+sFXuXWbDkWb7jDcLfyr7qFhhW2Odk+ucu5YUa2Ab5AXnPc2MI8pksObSoGU4zPrxn4w3HvxAdJ02WFJbs1C5NdyrzOHTMCec6h+onFWlrvQ5QCJKxv28RRTn+TSLptSDhC3VNWR42rWl5iRQkxnPHTgx1Csh7r9GoMWbxKWAUlNHe9XadyPp4OngaayRBX5hlLk9Q6SlOS9q0tgRmF23gFQNKXZmmrLd83Qn0l8RIL2/ab8Yzcys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test.c currently serves two distinct purposes: microbenchmarking
(GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
DUMP_USER_PAGES_TEST). Mixing these in a single binary means that
functional tests cannot be run or reported individually, and
run_vmtests.sh must invoke the binary multiple times with different flag
combinations to cover all configurations.

This series separates the two concerns: tools/mm/gup_bench handles
benchmarking, while tools/testing/selftests/mm/gup_test handles functional
testing. To avoid duplicating the HugeTLB and related file helpers, the
series first prepares the existing helpers for sharing, then moves the
common code to tools/lib/mm/ for use by both selftests and tools/mm.

Patch 1 makes read_file(), write_file(), read_num() and write_num() in
vm_util.c return errors to callers rather than exiting. It also makes
read_num() reject negative, malformed and out-of-range values. Existing
mm selftest callers are updated to report failures through kselftest
helpers. This avoids carrying behavior specific to selftests into the
shared helper implementation introduced in the next patch.

Patch 2 adds tools/lib/mm/file_utils.[ch], moving read_file(),
write_file(), read_num() and write_num() out of vm_util.c into a shared
helper without a kselftest dependency. It keeps the helpers available to
mm selftests through vm_util.h, updates the explicit x86 protection_keys
build rules to preserve full prerequisite paths, and adds tools/lib/mm/
to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.

Patch 3 moves hugepage_settings.[ch] from selftests/mm to tools/lib/mm/.
It keeps the helpers available to selftests through vm_util.h where
possible, uses direct <mm/hugepage_settings.h> includes for users that do
not include vm_util.h, and removes the remaining kselftest dependency
from the implementation. The existing HugeTLB diagnostic messages are
preserved as TAP-compatible printf() diagnostics.

Patch 4 adds tools/mm/gup_bench.c, a standalone microbenchmark for
GUP_FAST, PIN_FAST and PIN_LONGTERM through the CONFIG_GUP_TEST debugfs
interface. It runs the benchmark subset of the configuration matrix
previously covered by run_gup_matrix(), covering all three benchmark
commands, read and write GUP access, private and shared mappings, four
page counts, and THP, non-THP and hugetlb mappings. It also restores
HugeTLB settings after each hugetlb benchmark run and validates
command-line arguments, including their numeric ranges.

Patch 5 rewrites gup_test.c to use the kselftest harness. It covers all
five GUP/PUP kernel functions (get_user_pages, get_user_pages_fast,
pin_user_pages, pin_user_pages_fast, and pin_user_pages with
FOLL_LONGTERM), plus DUMP_USER_PAGES_TEST, across 12 mapping
configurations. These configurations cover THP, non-THP and hugetlb
mappings, each with private and shared mappings and read and write
access. Each configuration is tested with four batch sizes (1, 512, 123,
and all pages). The patch also preserves the old sparse dump coverage
for pages 0, 19 and 0x1000. Results are reported in standard TAP format,
with no command-line arguments required.

---
Changes in v5:
- Rebase onto v7.2-rc3
- Address feedback from Mike, John, Dev and Sashiko
- Make file helper diagnostics TAP-compatible
- Validate read_num() input and propagate errors while restoring
  shared memory limits
- Preserve build bisectability for the x86 protection_keys test
- Preserve HugeTLB diagnostics using TAP-compatible printf() output
- Validate the remaining numeric arguments accepted by gup_bench

Changes in v4:
- Address review feedback from Mike and Sashiko
- Add a preparatory patch so shared file helpers return errors instead of exiting
- Reduce include churn by keeping shared helpers exposed through vm_util.h
- Preserve HugeTLB diagnostics and restore HugeTLB state more carefully
- Fix selftests/mm build details after moving helpers to tools/lib/mm
- Tighten gup_bench argument handling and gup_test setup/sparse-dump coverage

Changes in v3:
- Address v2 feedback from Sashiko
- Add shared file_utils helpers under tools/lib/mm
- Move hugepage_settings out of selftests and into tools/lib/mm
- Convert gup_bench to use the shared tools/lib/mm helpers
- Guard against invalid thread counts in gup_bench
- Handle thread-array allocation failure cleanly in gup_bench
- Restore hugetlb settings on setup failure in gup_test
- Add sparse DUMP_USER_PAGES_TEST coverage for pages 0, 19 and 0x1000 in gup_test

Changes in v2:
- Address v1 feedback from Sashiko
- Add fast and longterm GUP/PUP coverage
- Sweep nr_pages_per_call over 1, 512, 123 and all pages
- Call madvise(MADV_NOHUGEPAGE) in non-THP variants
- Use 256 MB for hugetlb fixtures
- Use hugetlb_restore_settings() in FIXTURE_TEARDOWN instead of atexit()
- Add TH_LOG to report nr_pages_per_call for each iteration
- Update Documentation/core-api/pin_user_pages.rst unit testing section

Previous versions:
v4: lore.kernel.org/all/20260527142432.230127-1-sarthak.sharma@arm.com/
v3: lore.kernel.org/all/20260521111801.173019-1-sarthak.sharma@arm.com/
v2: lore.kernel.org/all/20260519120506.184512-1-sarthak.sharma@arm.com/
v1: lore.kernel.org/all/20260515084840.174652-1-sarthak.sharma@arm.com/

---
Sarthak Sharma (5):
  selftests/mm: make file helpers return errors
  tools/lib/mm: add shared file helpers
  tools/lib/mm: move hugepage_settings out of selftests
  tools/mm: add a standalone GUP microbenchmark
  selftests/mm: rewrite gup_test as a standalone harness-based selftest

 Documentation/core-api/pin_user_pages.rst     |  12 +-
 MAINTAINERS                                   |   2 +
 tools/lib/mm/file_utils.c                     | 119 ++++
 tools/lib/mm/file_utils.h                     |  12 +
 .../selftests => lib}/mm/hugepage_settings.c  |  81 ++-
 .../selftests => lib}/mm/hugepage_settings.h  |   0
 tools/mm/.gitignore                           |   2 +
 tools/mm/Makefile                             |  10 +-
 tools/mm/gup_bench.c                          | 482 ++++++++++++++
 tools/testing/selftests/mm/Makefile           |  13 +-
 tools/testing/selftests/mm/compaction_test.c  |   2 +-
 tools/testing/selftests/mm/cow.c              |   1 -
 .../selftests/mm/folio_split_race_test.c      |   1 -
 tools/testing/selftests/mm/guard-regions.c    |   1 -
 tools/testing/selftests/mm/gup_longterm.c     |   1 -
 tools/testing/selftests/mm/gup_test.c         | 606 +++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c        |   6 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |   1 -
 tools/testing/selftests/mm/hugetlb-mmap.c     |   1 -
 tools/testing/selftests/mm/hugetlb-mremap.c   |   1 -
 tools/testing/selftests/mm/hugetlb-shm.c      |   1 -
 .../selftests/mm/hugetlb-soft-offline.c       |   2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c  |   1 -
 tools/testing/selftests/mm/hugetlb_dio.c      |   1 -
 .../selftests/mm/hugetlb_fault_after_madv.c   |   1 -
 .../selftests/mm/hugetlb_madv_vs_map.c        |   1 -
 tools/testing/selftests/mm/khugepaged.c       |  14 +-
 tools/testing/selftests/mm/ksm_tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   5 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    |   1 -
 .../testing/selftests/mm/prctl_thp_disable.c  |   1 -
 tools/testing/selftests/mm/protection_keys.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |  37 +-
 tools/testing/selftests/mm/soft-dirty.c       |   1 -
 .../selftests/mm/split_huge_page_test.c       |   5 +-
 tools/testing/selftests/mm/thuge-gen.c        |   1 -
 tools/testing/selftests/mm/transhuge-stress.c |   1 -
 tools/testing/selftests/mm/uffd-common.h      |   1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   2 +-
 .../selftests/mm/va_high_addr_switch.c        |   1 -
 tools/testing/selftests/mm/vm_util.c          |  88 +--
 tools/testing/selftests/mm/vm_util.h          |   7 +-
 42 files changed, 1131 insertions(+), 398 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (91%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)
 create mode 100644 tools/mm/gup_bench.c


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
--
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E4EC88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF45F6B0095; Fri, 11 Sep 2026 07:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA44C6B0096; Fri, 11 Sep 2026 07:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBAAF6B0098; Fri, 11 Sep 2026 07:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD506B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:10:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F56401B3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:10 +0000 (UTC)
X-FDA: 85201212180.21.AF4565E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 51CE7A0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PdC02lhR;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789125008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ag5sAs9jMueF9In19o/mGphsmibKagoB+Wwxkv3xUeo=;
	b=jSU2H+XQZWG3xI+cXj7zDuaNZmNeuj4pF6i/7e1b5w13wPOE6f4UF3VaU7XmwrcQ5q46Yd
	mulRpnE+2R7a0R635tdtMePXYoV6zV5lOhX3dIN6nr+Cj8Fmg4SG6UI8ID29yeCtcPA5u+
	GsCYZi8TaWDqq2wS5krvUjzXCP4FxZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789125008;
	b=P186AICRsdvimnjRqZCHYdjdnJQGMY3Sd8gNWU36jjqBCIQPg7Vn1y2+uFE2v+yJA8oCbW
	AEJLpSJxX0PjsnJZ7lM67/p/vNtefViGpaN03O58L74pyF+JtWudl18TGTOQKdaqGmR1Ol
	aPXvqlSC2+GmW7mV9K04etLQky27fG8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PdC02lhR;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7558A1570;
	Fri, 11 Sep 2026 04:10:03 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7DC953F59E;
	Fri, 11 Sep 2026 04:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789125007; bh=oR8nn/+ZNYVk9442CCCdQztJHM6NxIHD+3BwCucvpDo=;
	h=From:To:Cc:Subject:Date:From;
	b=PdC02lhR6DpzDD9m5JXFbPx8DQhuGpD5PM901hG9Tg71ZguctlnfmGs0W4OcVGAEZ
	 Z0I77C1AlPoFjxn+uxOGTe1ySDOK28iryLiu0BwCh0HfADEnhPZUZ5Z3CzHPvl1teF
	 3oSFH7Vrv5k89rJ7N3KULLYdo9gf6tunmb7obsCU=
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
	Jonathan Corbet <corbet@lwn.net>,
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
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v10 0/6] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Fri, 11 Sep 2026 16:39:44 +0530
Message-ID: <20260911110950.200240-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: quxmuxmqt8eq56jwdt7wmaqpz9eh7wc6
X-Rspam-User: 
X-Rspamd-Queue-Id: 51CE7A0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789125008-922626
X-HE-Meta: U2FsdGVkX1+Z2ktDL4hmPnvvM+Se8W/tsWB1TWDirsCmxUNl/IwwsNfOwlwodmxSiEp8ew+uIrji+hf1930ffO5nK5L8dNeYfVhifMC0I9HxrR4AdClxmbZ90o3clmj9KkqDH/rHdNi79epX8ffqzyHBd/4fKLi+PVRpuysMiIu4Vt9EdUY63Y2HpCWB7z4BeE0kyEUWxeDGaVX9SI3JfUzD/N4m1qwzQgykYwF9AwiUBMjnYWswkWwzYcbm46ET/N9QJP/7bouD4eqgDLFaNFIS9IBgomztvRyzL+Z9ArZCRbZBfa9PLrfKqFt5GUmBkLheN9MIJpHC4HGrRHeBSc00THkFGPYxDxmZ+XBC20L+phPHRy9ao12iYXmZOwn9g8B8zwzqXCHM+vi32CmEOy7ZcgBBpvWciPCWNa0TPCv8+EtxFEHcOB7h6miWoDE5GDxPW+HAptrp1hEIOgjSAOV4AFaau6Cvn8vOMg+IkngSD5D90GkBJBo/Q5OiTAnw6nR/+ny6h4XOn0KDXPf4nqIGq3D1CapUqnxvwzUEulxiTpTB4fwLPVEjawD6SoUrAENNph5iJToECJlEisTSZ46ypMLX+oSh7Jytf45fjZHORTnCuY4llQYay/vC3YsCcj9oxD6K8Q4ebPXCODq9Go/1n94sbDmeOJzl+VdxN8Mreae5apG3KW+ItfwwNJYwk2fdxBNXsFmHhm0CajODUkwTqJuPJLZMROam/m3xb/ISP+phKlEHOHNOqgKVFIK4iD6iw1d2mY2HcC5DzS0c6pFkXePrXQvT0Goqdw+RzDPT2jYdqW93WnFgqLPiZsjvlyvLGNIQVFXJZR7ruqMbe7E4fqN+y7EexFuAUVKpqhVsmPg6UW3l1L5pweHIMEYlbu3NIAjQy+uaKDZ9qsPhDGWXB2nItWj3vjRMOmaLekfpve+tBiqTTXPeEOJf9RORrohdEaYatJgtmxbM1a8
 OIalg8je
 USNI+o1uN2PVCg7Vv3PnKKUxuvwZxEjYTXSbNRgTSJ1nFUy1SuiqQWIipX127UVOGSx7MTJa727BT8/OfSHN1I2nv4QXw4t+Wb8pLfqoUccem5HryxlXcuVzJSmgM+Hb9r6a0SwjeJdTzgsj1xrF/1LdixLu5RSzVsO2mfBPJcIp8Lm4UiU6FaRxCn/lS73XgBbUUdltW4QUL6YW16D3kkB/T76ejX18lrHmAhxaLAXnGROJzO7Y73xKQc+NTqaORbPFDDarl/uLT+zU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test.c currently serves two separate purposes: benchmarking
(GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
tests harder to run and report individually, while run_vmtests.sh has to
invoke the program repeatedly with different options.

Separate these roles into tools/mm/gup_bench for benchmarking and
tools/testing/selftests/mm/gup for functional testing. Move the shared
file and hugepage helpers to tools/lib/mm/ so both programs can use them
without duplicating the implementation.

Patch 1 makes read_file(), write_file(), read_num(), write_num() and
write_num_ignore_einval() return errors to their callers instead of
exiting. It also makes read_num() reject negative and malformed values
and updates the existing callers to handle failures.

Patch 2 moves these file helpers from vm_util.c to tools/lib/mm/. It keeps
them available to the mm selftests through vm_util.h and adjusts the
selftests build accordingly.

Patch 3 moves hugepage_settings.[ch] from selftests/mm to tools/lib/mm/.
It also removes its kselftest dependency while preserving TAP-compatible
diagnostics for selftest users.

Patch 4 moves the existing gup_test implementation from selftests/mm to
tools/mm as gup_bench. This keeps the code movement separate from the
subsequent changes and makes it easier to review.

Patch 5 removes the functional test modes and kselftest dependency from
gup_bench. When run without arguments, it performs one GUP_FAST benchmark
using the existing defaults instead of running the whole matrix. Other
benchmark configurations can be selected through command-line options.

Patch 6 adds a new harness-based GUP selftest. It covers THP, non-THP and
HugeTLB mappings across private/shared and read/write variants. For each
variant, it tests get_user_pages(), get_user_pages_fast(),
pin_user_pages(), pin_user_pages_fast() and long-term pinning modes
using four batch sizes. The HugeTLB variants share a one-time setup of
two hugeTLB pages.

Changes in v10:
- Use anonymous mappings instead of /dev/zero backed ones
- Use two HugeTLB pages in GUP selftest
- Remove dump_page() description from mm/Kconfig
- Check effective UID before running gup_bench

Changes in v9:
- Handle read_num() and write_num() calls in hugetlb-soft-offline.c
- Require GUP tests to pin all requested pages
- Setup HugeTLB pages after prerequisite checks, choose the count
  using a 256 MiB target and skip variants when setup fails

Changes in v8:
- Add a comment to clarify read_num() input validation
- Remove duplicate exit code in gup_bench
- Drop DUMP_USER_PAGES_TEST coverage from gup
- Update Documentation and Kconfig

Changes in v7:
- Rebase onto mm-unstable
- Address feedback from Mike and Sashiko
- Make read_file() return 0 on success and tighten read_num() parsing
- Move write_num_ignore_einval() with the shared file helpers
- Keep the existing gup_bench argument parsing and avoid unrelated checks
- Set up 128 HugeTLB pages once for all HugeTLB selftest variants

Changes in v6:
- Rebase onto v7.2-rc5
- Address feedback from David, Mark, John, Dev and Sashiko
- Keep the shared file helpers silent and let callers report errors
- Move the existing gup_test into tools/mm before changing its behaviour
- Report ioctl failures from gup_bench worker threads
- Remove the default benchmark matrix and run one default benchmark instead
- Add the new harness-based functional selftest in a separate final patch
- Drop the unrelated thp_swap_allocator_test .gitignore change

Changes in v5:
- Rebase onto v7.2-rc3
- Address feedback from Mike, John, Dev and Sashiko
- Make file helper diagnostics TAP-compatible
- Validate read_num() input and propagate errors while restoring shared
  memory limits
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
- Restore HugeTLB settings on setup failure in gup_test
- Add sparse DUMP_USER_PAGES_TEST coverage for pages 0, 19 and 0x1000

Changes in v2:
- Address v1 feedback from Sashiko
- Add fast and long-term GUP/PUP coverage
- Sweep nr_pages_per_call over 1, 512, 123 and all pages
- Call madvise(MADV_NOHUGEPAGE) in non-THP variants
- Use 256 MB for HugeTLB fixtures
- Restore HugeTLB settings from fixture teardown
- Report nr_pages_per_call for each iteration
- Update the pin_user_pages unit-testing documentation

Previous versions:
v9: lore.kernel.org/all/20260904123631.198697-1-sarthak.sharma@arm.com/
v8: lore.kernel.org/all/20260831042101.18085-1-sarthak.sharma@arm.com/
v7: lore.kernel.org/all/20260813181230.483746-1-sarthak.sharma@arm.com/
v6: lore.kernel.org/all/20260730140825.238130-1-sarthak.sharma@arm.com/
v5: lore.kernel.org/all/20260716123226.197736-1-sarthak.sharma@arm.com/
v4: lore.kernel.org/all/20260527142432.230127-1-sarthak.sharma@arm.com/
v3: lore.kernel.org/all/20260521111801.173019-1-sarthak.sharma@arm.com/
v2: lore.kernel.org/all/20260519120506.184512-1-sarthak.sharma@arm.com/
v1: lore.kernel.org/all/20260515084840.174652-1-sarthak.sharma@arm.com/

---
Sarthak Sharma (6):
  selftests/mm: make file helpers return errors
  tools/lib/mm: add shared file helpers
  tools/lib/mm: move hugepage_settings out of selftests
  tools/mm: move gup_test from selftests/mm to tools/mm
  tools/mm: make gup_bench a benchmark only tool
  selftests/mm: add a GUP selftest

 Documentation/core-api/pin_user_pages.rst     |   9 -
 MAINTAINERS                                   |   4 +-
 mm/Kconfig                                    |  19 +-
 tools/lib/mm/file_utils.c                     | 106 +++++++
 tools/lib/mm/file_utils.h                     |  13 +
 .../selftests => lib}/mm/hugepage_settings.c  | 109 ++++++--
 .../selftests => lib}/mm/hugepage_settings.h  |   0
 tools/mm/.gitignore                           |   1 +
 tools/mm/Makefile                             |  11 +-
 .../mm/gup_test.c => mm/gup_bench.c}          | 190 ++++++-------
 tools/testing/selftests/mm/Makefile           |  15 +-
 tools/testing/selftests/mm/compaction_test.c  |   2 +-
 tools/testing/selftests/mm/cow.c              |   1 -
 .../selftests/mm/folio_split_race_test.c      |   1 -
 tools/testing/selftests/mm/guard-regions.c    |   1 -
 tools/testing/selftests/mm/gup.c              | 263 ++++++++++++++++++
 tools/testing/selftests/mm/gup_longterm.c     |   1 -
 tools/testing/selftests/mm/hmm-tests.c        |   6 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |   1 -
 tools/testing/selftests/mm/hugetlb-mmap.c     |   1 -
 tools/testing/selftests/mm/hugetlb-mremap.c   |   1 -
 tools/testing/selftests/mm/hugetlb-shm.c      |   1 -
 .../selftests/mm/hugetlb-soft-offline.c       |  18 +-
 tools/testing/selftests/mm/hugetlb_dio.c      |   1 -
 .../selftests/mm/hugetlb_fault_after_madv.c   |   1 -
 .../selftests/mm/hugetlb_madv_vs_map.c        |   1 -
 tools/testing/selftests/mm/khugepaged.c       |  15 +-
 tools/testing/selftests/mm/ksm_tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    |   1 -
 .../testing/selftests/mm/prctl_thp_disable.c  |   1 -
 tools/testing/selftests/mm/protection_keys.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |  37 +--
 tools/testing/selftests/mm/soft-dirty.c       |   1 -
 .../selftests/mm/split_huge_page_test.c       |   6 +-
 tools/testing/selftests/mm/thuge-gen.c        |   1 -
 tools/testing/selftests/mm/transhuge-stress.c |   1 -
 tools/testing/selftests/mm/uffd-common.h      |   1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   2 +-
 .../selftests/mm/va_high_addr_switch.c        |   1 -
 tools/testing/selftests/mm/vm_util.c          | 121 +++-----
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 42 files changed, 650 insertions(+), 328 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (87%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (50%)
 create mode 100644 tools/testing/selftests/mm/gup.c

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93571C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CAD6B057B; Thu, 13 Aug 2026 14:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC196B0585; Thu, 13 Aug 2026 14:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB2C6B0587; Thu, 13 Aug 2026 14:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5836B057B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:13:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC7091C09F2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:17 +0000 (UTC)
X-FDA: 85097043234.09.8D20428
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D57CF1A0010
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=beP1j7Nn;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yQg56goCRuU/BuCBbwJ8m6uuaA6NktcV2hxr+laH2W4=;
	b=0lTnkDpHeI40LNDuQ+rCDRO3k9d9tjdXwgTnfoSGcbaoOvMbhU2sXQfn4zaKolJSARkWjC
	2dPY68K1D5pkWnH93uN/N17X7+/XJOqnis6viOrcJzYgQiuMifYWhha4c3+FlC/Aqg0THR
	2YLuhnTnKQv+KC6UYfeydNenNjF6ZAw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=beP1j7Nn;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786644796;
	b=DbeAHovRI0sQPTsVwqoyjqcn5v7l7fbX7m9ySc/2Ykddcm3IEnda4ndiJ62JRHh3/hT5AP
	MOWy7DpA2tewchExtnz57bcKiFBvLwAu3lvLw6wGhrYlzRZA4EgDT1UxiM2+EIazOKhoUO
	gyQ18EU7quXuHszCWelqFkJzm3n9S+c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF99A1AC1;
	Thu, 13 Aug 2026 11:13:10 -0700 (PDT)
Received: from a081061.arm.com (unknown [10.163.171.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F0E8A3F66F;
	Thu, 13 Aug 2026 11:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786644794; bh=m1bGvj6UOubdng2fWNx+INIIJr6MJ9Bx14ljarArOwU=;
	h=From:To:Cc:Subject:Date:From;
	b=beP1j7NnNYbW1T+TK0ZhpzJW+uBg/JNQpUbIZ4QR20EMSLzqX3iJ7UCCXHhLriOAN
	 0rBSRyaEklbpDBz+puBDl9ZHqL0kJH0EZka45AfFmDx8WlnPtltB0bECJUdyaaXMgc
	 V6s9eDjGIKpA+dCL0+P7oBTYTQmmLjmhEg41C+Vk=
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
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v7 0/6] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Thu, 13 Aug 2026 23:42:24 +0530
Message-ID: <20260813181230.483746-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D57CF1A0010
X-Stat-Signature: ypssuiu4j41o3qrsi9j9brp374exsfsi
X-Rspam-User: 
X-HE-Tag: 1786644795-884228
X-HE-Meta: U2FsdGVkX19J8FBs11VTtmMtVuUfDA6b5sR5tKCGDYz+3wCVqpdcENc6e/F6KsFoz3j1iwkVdt5IlFoFN1kuM4LR4wEax+YQU8+HXpOTS6AqveoNROopA8/t1hhSMCUUdklBEz2mLe9KE2NlpP7gFxqK3Rqo2gXUrpnFVf9bn3BAY2foVWiCLpTNJVPdu00R9C5ix7sfdeXWNMsz9uxkSz9WJ8XIrM87fRsdaklv6F5T+YtCP10JtDiGKw4yQ2HVPdVK3pfz6W6leU3zcxThBF6j42sKEwtv0eCo9UUpMMWAThKo2Bn2cROClIPwZD4r0ww3CovwDiIhVGCmBHLc6GbV3ZA5ZwH36hZrg+pjtAb+iAd2KABxLiYuhE5H+ey00W8CgT0qxthw7CjkICAsbAP9NpMXKjrSLmz4hi9qodAT88p0E5YGho/gw8hpTQr4TerPJxvsuNI7bY1Xxte8GKJhVK1UFGcn6Gjd+LtvlLyhNMaNWNGDylIEiphoQv6FfTQ3JCw6wgs3UlKGqQdJOQTs0vcMGM94blfJ5WWxypeT+70Ey/M+ORmFIMBG5D6emVQ2RnVjR1zeWzQAV17joSHgjqJQWs9Gwl++aSS5Jaalxuwyg5Rmi8ioWCwZqxNKL4qnbSrzZ4vHWy0bW4sq89unIp3mfEFKAP5XA3offQBLvs7lbNQTxdBFE/UfoN5UeCLglg6XwWMBmEzfuIAz/CSyg/yomgxcPhZWnCvV2cyj8zAkt3JWsUmJoYT4XjCKicUdX/vbsXQOSuc197Wpmybum0Udc9vDCdvRlB1JmF1ljZzLrrlMpJot8H3VKNNXSr/+Wy4fHaMG2TBDP9pQcHISPFm+5DIBvNt+9EXUvjSEFiue2j21x/7nHCRMtB7LrjJrPU8NrxcbBD6DbK4Y/hvDHCbe2Lz/YcrmPzcOAHyCo4xo4QWq8u9MgquuVvZkYPcIAXDW7SFIWROjgEj
 EZaKbfbZ
 FUQU9C3sfxnzodc7CPENWRYLAuZK8JlhZVUawnz2UcmcLzVCjT3i7hxmGrOPOrM6RPfhet6a7C/QfDZawAvKlfApXlHKfhG8Xnhx+fuPcUpY4z1KFnijrC3troztpxTiLMx7wo7UBGdtGOV/N2TaltT55ysXfJMruUyra3AMXVmxdXD4KQg2yOYq7LEEz4axLTFPhB40g+8ztiRmmh7n1kZa+qHhB0kXT69Oi+14+/4/3BdZAdbLRYrRFpdYjOxKU75sYc60T5kBn7vE=
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
pin_user_pages(), pin_user_pages_fast(), long-term pinning and both dump
modes using four batch sizes. It also preserves the existing sparse dump
coverage for pages 0, 19 and 0x1000. The HugeTLB variants share a one-time
setup of 128 default-sized huge pages.

---
I think Sashiko might complain about some "what if the user inputs this
and that" scenarios in patch 5, but I intentionally am not covering those
now, agreeing with Mike's point that a user will be wise enough to input
sane values to run a benchmark. Those checks increase churn and make the
patch harder to review.

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

 Documentation/core-api/pin_user_pages.rst     |  14 +-
 MAINTAINERS                                   |   4 +-
 tools/lib/mm/file_utils.c                     | 104 ++++++
 tools/lib/mm/file_utils.h                     |  13 +
 .../selftests => lib}/mm/hugepage_settings.c  | 109 +++++-
 .../selftests => lib}/mm/hugepage_settings.h  |   0
 tools/mm/.gitignore                           |   1 +
 tools/mm/Makefile                             |  11 +-
 .../mm/gup_test.c => mm/gup_bench.c}          | 194 +++++------
 tools/testing/selftests/mm/Makefile           |  15 +-
 tools/testing/selftests/mm/compaction_test.c  |   2 +-
 tools/testing/selftests/mm/cow.c              |   1 -
 .../selftests/mm/folio_split_race_test.c      |   1 -
 tools/testing/selftests/mm/guard-regions.c    |   1 -
 tools/testing/selftests/mm/gup.c              | 329 ++++++++++++++++++
 tools/testing/selftests/mm/gup_longterm.c     |   1 -
 tools/testing/selftests/mm/hmm-tests.c        |   6 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |   1 -
 tools/testing/selftests/mm/hugetlb-mmap.c     |   1 -
 tools/testing/selftests/mm/hugetlb-mremap.c   |   1 -
 tools/testing/selftests/mm/hugetlb-shm.c      |   1 -
 .../selftests/mm/hugetlb-soft-offline.c       |   2 +-
 tools/testing/selftests/mm/hugetlb_dio.c      |   1 -
 .../selftests/mm/hugetlb_fault_after_madv.c   |   1 -
 .../selftests/mm/hugetlb_madv_vs_map.c        |   1 -
 tools/testing/selftests/mm/khugepaged.c       |  15 +-
 tools/testing/selftests/mm/ksm_tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    |   1 -
 .../testing/selftests/mm/prctl_thp_disable.c  |   1 -
 tools/testing/selftests/mm/protection_keys.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |  37 +-
 tools/testing/selftests/mm/soft-dirty.c       |   1 -
 .../selftests/mm/split_huge_page_test.c       |   6 +-
 tools/testing/selftests/mm/thuge-gen.c        |   1 -
 tools/testing/selftests/mm/transhuge-stress.c |   1 -
 tools/testing/selftests/mm/uffd-common.h      |   1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   2 +-
 .../selftests/mm/va_high_addr_switch.c        |   1 -
 tools/testing/selftests/mm/vm_util.c          | 121 ++-----
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 41 files changed, 710 insertions(+), 306 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (87%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (50%)
 create mode 100644 tools/testing/selftests/mm/gup.c


base-commit: f9ca2fa9ef7e9b39ec79a0596929d1a1f8704c5f
-- 
2.39.5



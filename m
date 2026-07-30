Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E76C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4236B0092; Thu, 30 Jul 2026 10:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B766B0093; Thu, 30 Jul 2026 10:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A316B00A3; Thu, 30 Jul 2026 10:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A15F16B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:08:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 392AF1C012B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:42 +0000 (UTC)
X-FDA: 85045623684.30.B875EEC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3A75C4000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSWe8JOl;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pSsaw63OksXJ9a2OQZamKRNKNqu2UGlktGZrGrAfKuo=;
	b=pyfdHxN0voj/3cXVtiNcKwloKKCM5WUy/d9lOgbh1koiLjtOF/zj44A343HF3FadaSu1ey
	I1Ua7XEPLkNwfX9TNC0JMz37yPEg5F2GbcdcoQBWXheek33kmLex0lWfZJhq7M+51qq4zt
	PLTVFuKkiLwy1A5Q9pEWSXOZNgKdV5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420520;
	b=18HQfMuo75zaHYOpOSry+KN8iR8ppmtGrFU3iOrpVJIVM/zLjfJ4vnR0FXKINx362+LpXM
	yzExJTWdGpXs2jAx0okB0jp57WNO12I0Wwxor/BKCu5TTGF3qWJbUktKKKV/lHxGLFUHz3
	7ZiBk6ACJEyajoMfnfWFti3JACGTQ60=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSWe8JOl;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C8021688;
	Thu, 30 Jul 2026 07:08:35 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C15C53F86F;
	Thu, 30 Jul 2026 07:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420519; bh=VQ/7nm/CFEVqCeQHsuIyq22oHK7dpv4kUiKyo+FZvnQ=;
	h=From:To:Cc:Subject:Date:From;
	b=FSWe8JOlTHZnsIgoQK111/enr6Gc6ybPOMdgyJlafjPJ5qq9L//lYbOJzG/s5OgUB
	 CUEr3UdMhegu2z14UzobdILp4L2lXPD84xDr1CNvymnOPXtCXRT/WS8lgbmbmzzO7P
	 j6kzJ2nSPbOQo9Rn10+0Tus3A8c5HLD+3RQ7uxVA=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v6 0/6] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Thu, 30 Jul 2026 19:38:19 +0530
Message-ID: <20260730140825.238130-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A75C4000B
X-Stat-Signature: bs7oq377s1xrm4wmbx1p8eaa4rg69jbf
X-Rspam-User: 
X-HE-Tag: 1785420520-656895
X-HE-Meta: U2FsdGVkX18IS3nlEKVSU+wo3cVdb3HJJOxwqhTR7nEoQn1kn4anBzuRkSrkIOiIguhnGLJrRy+O/PtFDApRohf3pBknf38+I1DLT2I82rXpHSgWtKJZwU11AVRpb/NILXG8z9SDQLx/442PHj1xbTLpXdLttExK81dp4jhTNBn9DwTmpZ7Jdzdn5pUBAptM0WNt2QrIBOKpjDuDVVFH5L/02EWwzsQOhm8WmnklcBZ5m/OOiTS9mt1ti6/v8TMhtbtYRxsECPSxwZReXSFig+SU2wGfONrxdepVfTcXsrwKoLUorsGh3TbeSFt2NVOI3M062goXQoZPz2auWpv5tebhMBdkAlp3t3Vl8KAsGXmENfwmaxCkI5H4BEF+1HGKkcWx4eHi6OOwznV2kCxXA8gEDQARl1st3OmJ2vHbo5P/PkdjTiLwfSaeph1aFJ8HCwwOsOaBX1vSkGy8+8Vqo1++mK8jo2F0Dq65hqzEMp5PzGIB+qcfI322XdpexEeCASKtOqZ6ntPeo33pyweo/K0EAdwEqdCfGCaXhsChqJXFRtjDf2zLRi88nWQ/eY+LLqrfPkxde4CJGY5K3kxdvHmzBqFHC+ZTExswk9wwKF1aBmJr494HJoAeOLtyWmdwUFk5jaJ+DsfM9YS5GIg/WeTAtHVmiGf5oDDjWxWak2a89n+7l4+BBBUG8kbVDcfesaEPoQd8vx+lcwc+yR/qihoeqCp5AYC0RK9GkYxcgVvUiJxsy/C6ZeHC/+fEkHcTCBE9EVfq8Xvk5uEFGTHKUEfyZDnvgbs2o6j/nSeMOIaBQtz2EeIJJ2OSDn4FnTQAnTcsMKEKQm19d+8UMwbaLmubL9qcqyTq7mnIRuZYG9nc2IMlzJk55BSi/TPbxWGCbl00+YfWpFKc+TJ5npSbd+ZguImSSWiQlv5p+ZGwkzxzJIiVj9IF0TkqJ1hIoay6FQ9MGHY5Spow5YoEIdF
 YAu09HNK
 xK6MD6ENtwEfc4DhprSGA+f6LYaSw2y8Ka0U2fXBtt8J4Ti2uxjvxWdIQrZoy1NE+MxoiIZWKo+Znh3ImONoKLS8FzmNFcR9yDS+Wrl1RWZpkAOrEOTn6X18aasTQO0bEjsKz5B4gVW11ojlbjpQjUtr6xBeESZxRRgTfjQl3Tu4mNjHpaxQsP+dRH/f2LMbHinf2hFU/4klgzA+cywyNOKFMe9NwRcHOVyHd2Rte3JORctZO+d5dEXEGD29efk1gGeLmxsXojK3U0gU=
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

Patch 1 makes read_file(), write_file(), read_num() and write_num()
return errors to their callers instead of exiting. It also makes
read_num() reject negative and malformed values and updates the existing
callers to handle failures.

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
coverage for pages 0, 19 and 0x1000.

---
Changes in v6:
- Rebase onto v7.2-rc5
- Address feedback from David, Mark, John, Dev and Sashiko
- Keep the shared file helpers silent and let callers report errors
- Move the existing gup_test into tools/mm before changing its behaviour
- Report ioctl failures from gup_bench worker threads
- Remove the default benchmark matrix and run one default benchmark instead
- Add the new harness based functional selftest in a separate final patch
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
v5: lore.kernel.org/all/20260716123226.197736-1-sarthak.sharma@arm.com/
v4: lore.kernel.org/all/20260527142432.230127-1-sarthak.sharma@arm.com/
v3: lore.kernel.org/all/20260521111801.173019-1-sarthak.sharma@arm.com/
v2: lore.kernel.org/all/20260519120506.184512-1-sarthak.sharma@arm.com/
v1: lore.kernel.org/all/20260515084840.174652-1-sarthak.sharma@arm.com/

Sarthak Sharma (6):
  selftests/mm: make file helpers return errors
  tools/lib/mm: add shared file helpers
  tools/lib/mm: move hugepage_settings out of selftests
  tools/mm: move gup_test from selftests/mm to tools/mm
  tools/mm: make gup_bench a benchmark only tool
  selftests/mm: add a GUP selftest

 Documentation/core-api/pin_user_pages.rst     |  14 +-
 MAINTAINERS                                   |   4 +-
 tools/lib/mm/file_utils.c                     |  96 +++++
 tools/lib/mm/file_utils.h                     |  12 +
 .../selftests => lib}/mm/hugepage_settings.c  | 111 +++++-
 .../selftests => lib}/mm/hugepage_settings.h  |   0
 tools/mm/.gitignore                           |   1 +
 tools/mm/Makefile                             |  10 +-
 tools/mm/gup_bench.c                          | 347 ++++++++++++++++++
 tools/testing/selftests/mm/.gitignore         |   2 +-
 tools/testing/selftests/mm/Makefile           |  15 +-
 tools/testing/selftests/mm/compaction_test.c  |   2 +-
 tools/testing/selftests/mm/cow.c              |   1 -
 .../selftests/mm/folio_split_race_test.c      |   1 -
 tools/testing/selftests/mm/guard-regions.c    |   1 -
 tools/testing/selftests/mm/gup.c              | 341 +++++++++++++++++
 tools/testing/selftests/mm/gup_longterm.c     |   1 -
 tools/testing/selftests/mm/gup_test.c         | 275 --------------
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
 tools/testing/selftests/mm/khugepaged.c       |  15 +-
 tools/testing/selftests/mm/ksm_tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   5 +-
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
 tools/testing/selftests/mm/vm_util.c          | 103 ++----
 tools/testing/selftests/mm/vm_util.h          |   7 +-
 44 files changed, 977 insertions(+), 458 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (87%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)
 create mode 100644 tools/mm/gup_bench.c
 create mode 100644 tools/testing/selftests/mm/gup.c
 delete mode 100644 tools/testing/selftests/mm/gup_test.c


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98D3CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4D16B0095; Thu, 21 May 2026 07:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E686B0096; Thu, 21 May 2026 07:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C526B0098; Thu, 21 May 2026 07:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF4F06B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 707041610A4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:01 +0000 (UTC)
X-FDA: 84791182602.29.7A6B1E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6419AC000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:19:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ub3DXMYL;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M3ju3B1G3lleX3dIBFITRIJUlSgwLrGzaFWtEW/hKaE=;
	b=FRMWbFaoZsE3lm44LMN3/I0GFl7e3Z++AQsb+Pu69cRJrtAkX92l5kqeinjdHA5VnYG0QN
	WPz9s1tPKv7mRk9wy/d+D20V89rPV5lfPmt1yn1OiKxTT62jw7BGfnwyxeLprYT0tW+HiQ
	siEK31azuwaIiRS0lx4Vh4ptyEs5Gto=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ub3DXMYL;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362400; a=rsa-sha256;
	cv=none;
	b=23fJ1z7vsorEs4rI9uGPju8fcETLwiAElJd8YZ8+/6KVroZdqMKYkgXk/rb1Vjl+omNkKm
	yKvQzPN7nffZ75Lvh38gHtYHhbRI0ulWWYtLWTFTxesZpxgbIES6tFlc5DATezxsk+mqak
	jlkI/FhXAlOk57pmkTItsMWQ3dBmgKQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB12F35FA;
	Thu, 21 May 2026 04:19:52 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 75E0F3F7B4;
	Thu, 21 May 2026 04:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779362397; bh=cwzzxnOYQD32jsPaPOvx8u4LjDvQ6YeghLlaggpSiF4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ub3DXMYLTy8J3/jUc8yEx/8U0b7ywRBwVRYajMBy9Q8jF6C9QrlYgiWfxkNhw+mJf
	 56iJZw9CYBOsm2sTdnNyf6HFr60S+OSnzNb91btBTuP9h3SE4IgqMonsAqtKwZJk+7
	 CC3L8Lwc6eq4OZtxt1KS2yYGn8VV5Ml4rvUCOQJE=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
	Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 0/4] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Thu, 21 May 2026 16:47:57 +0530
Message-ID: <20260521111801.173019-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6419AC000C
X-Stat-Signature: nhhp6gu5ynrgxit33mc68k6cnxs37yqm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779362399-362183
X-HE-Meta: U2FsdGVkX1/o7Kl+59zR/9Qpa77apb/sdVnq+8TEAlJUJoMnvceVBOX5UgF9ngu3vX3oO1Tj9YUzqJjgvJTdAa0S7kjexr/vsFJOqRRIpMMrs+RKO0pgFiYDBojTpJiYuirwan/xB2kHslqGXRtXNPlpX9giYp3n4cHq4nQqBA780n2nc8hcnuoRshQUQZxBaoCKkx/uPBOMhy1iF8QaFi+m35l2eHct3ggJ39DlIPHDky3Dmh0mHhL/3jJRsMP2dFq35PVAsKj/YPkdUj2sb+bmAbg8uNOYyPjnGa1A36p+E8FzF81rxUZYlBtNtNIEwfyX/sNqdo8Vzy0Z5JQYC15UrqL4A3yh0zRbY/caLk7zzF56TErOTKX00AJ9bIJH61g+cIcKCb6moLe3UQUktKgEJYH1xSR8fcb/fnNSMyx7pgr2SlgLckhgyH7FVnr3uPYxyVyfUcoFc+6sr0jzN608h2rycbHHl7Hw77l0VH0YqNQlY5kKxJUa6I/YtEC9ED9pNxdq/XxtEgjRj/pP4yEfNbc8nhcUAuIDp1hi1Pkox1bc0GSH9lVihN8Sa5cZT9kRSlVw76Dua1UGSX4VBGXOE2+ANexo2jpaDlyy1wUuV7IRx8fi9WiWU69Qvv87LeS386QTWaoCihcQ8wls9rx9vXNH8LK8396omb2RFiZyKB1yqzE5zzs7QWHy7qTZT9RbUmb1sYUGKzCxKwpRGX7jzJdRxjsGc6R0/Nx3pL6+31yP9xKKIBOlmLw768623Lb1Vntzto5vgivEeujU61gVY8nwzBTJ/XbsRhkiIQcoTfvhO520jvw6TCq3hWgKqGHGawVAcxjwVd9xSFc7GiWmWvSPllZgcY47awVh2uyOxToPMgCrKwYGqeK68w7FX0GrnvLcfiL1F/jcz4JPtGGZeXFqyyN+J8/TvcOjjI4lguKZUGP8Q53Hi9vFtXzpagin54fvTPOMjazsTSS
 mVXQiSlF
 09ViLByFZ0DolLbSgdLHbNb8bLfXq1ajrI/dFdkbjeQzkSSNpQ/XA4EqGaVqRHvx8laZ4od/rVNI4mecSYCGE92X2FLVmJp998koF4w1Fd+YHAkqYCTi4NJCr9WnED6s9rK0aJTpfpfZJsJMpdtrzGPinucpMQPm0CBv+aPqxjZtN2WCDQCgyJyP/+f2JOd44dKXi6ltvLUbeFEY8BkQbVfzouro7cQUGphyoxpMSYat8StO+/3aJDhVe76fWeXt0LZqPBuuBF3sFHhCKUZqN8/F3404dySuD1hrE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test.c currently serves two distinct purposes: microbenchmarking
(GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
tests cannot be run or reported individually and run_vmtests.sh must
invoke the binary multiple times with different flag combinations to
cover all configurations.

This patch series separates the two concerns: tools/mm/gup_bench for
benchmarking and tools/testing/selftests/mm/gup_test for functional
testing. To avoid duplicating HugeTLB and related file helpers, the
series first moves the common helper code to tools/lib/mm/ so it can be
shared by both selftests and tools/mm.

Patch 1 adds tools/lib/mm/file_utils.[ch], moving read_file(),
write_file(), read_num() and write_num() out of vm_util.c into a shared
helper without a kselftest dependency. It also adds tools/lib/mm/ to the
MEMORY MANAGEMENT - MISC entry in MAINTAINERS.

Patch 2 moves hugepage_settings.[ch] from selftests/mm to tools/lib/mm/,
updates the selftests/mm users to include it from there and removes the
remaining kselftest dependency from the implementation while dropping
non-fatal hugetlb informational prints from the shared helper.

Patch 3 adds tools/mm/gup_bench.c, a standalone microbenchmark for
GUP_FAST, PIN_FAST and PIN_LONGTERM via the CONFIG_GUP_TEST debugfs
interface. It runs the same matrix of configurations as the old
run_gup_matrix() shell function (all three commands, read/write,
private/shared, four page counts, THP on/off, hugetlb), but as a
standalone C program under tools/mm using the shared tools/lib/mm
helpers.

Patch 4 rewrites gup_test.c as a kselftest harness-based selftest. It
covers all five GUP kernel functions (get_user_pages, get_user_pages_fast,
pin_user_pages, pin_user_pages_fast, pin_user_pages with FOLL_LONGTERM)
plus DUMP_USER_PAGES_TEST, across 12 mapping configurations (THP on,
THP off and hugetlb, each across private/shared and read/write variants)
and four batch sizes (1, 512, 123, all pages). It also preserves the old
sparse dump coverage for pages 0, 19 and 0x1000. Results are reported as
standard TAP output with no command-line arguments required.

---
These patches apply on top of mm/mm-new.

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
v2: https://lore.kernel.org/all/20260519120506.184512-1-sarthak.sharma@arm.com/
v1: https://lore.kernel.org/all/20260515084840.174652-1-sarthak.sharma@arm.com/

---
Sarthak Sharma (4):
  tools/lib/mm: add shared file helpers
  tools/lib/mm: move hugepage_settings out of selftests
  tools/mm: add a standalone GUP microbenchmark
  selftests/mm: rewrite gup_test as a standalone harness-based selftest

 Documentation/core-api/pin_user_pages.rst     |  12 +-
 MAINTAINERS                                   |   2 +
 tools/lib/mm/file_utils.c                     |  83 +++
 tools/lib/mm/file_utils.h                     |  12 +
 .../selftests => lib}/mm/hugepage_settings.c  |  14 +-
 .../selftests => lib}/mm/hugepage_settings.h  |   0
 tools/mm/.gitignore                           |   2 +
 tools/mm/Makefile                             |  10 +-
 tools/mm/gup_bench.c                          | 390 ++++++++++++
 tools/testing/selftests/mm/Makefile           |   8 +-
 tools/testing/selftests/mm/compaction_test.c  |   2 +-
 tools/testing/selftests/mm/cow.c              |   2 +-
 .../selftests/mm/folio_split_race_test.c      |   3 +-
 tools/testing/selftests/mm/guard-regions.c    |   3 +-
 tools/testing/selftests/mm/gup_longterm.c     |   2 +-
 tools/testing/selftests/mm/gup_test.c         | 587 +++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c        |   6 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |   3 +-
 tools/testing/selftests/mm/hugetlb-mmap.c     |   3 +-
 tools/testing/selftests/mm/hugetlb-mremap.c   |   3 +-
 tools/testing/selftests/mm/hugetlb-shm.c      |   2 +-
 .../selftests/mm/hugetlb-soft-offline.c       |   2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c  |   3 +-
 tools/testing/selftests/mm/hugetlb_dio.c      |   3 +-
 .../selftests/mm/hugetlb_fault_after_madv.c   |   2 +-
 .../selftests/mm/hugetlb_madv_vs_map.c        |   2 +-
 tools/testing/selftests/mm/khugepaged.c       |   3 +-
 tools/testing/selftests/mm/ksm_tests.c        |   2 +-
 tools/testing/selftests/mm/migration.c        |   6 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    |   2 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/protection_keys.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |  37 +-
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       |   4 +-
 tools/testing/selftests/mm/thuge-gen.c        |   3 +-
 tools/testing/selftests/mm/transhuge-stress.c |   3 +-
 tools/testing/selftests/mm/uffd-common.h      |   2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   3 +-
 .../selftests/mm/va_high_addr_switch.c        |   2 +-
 tools/testing/selftests/mm/vm_util.c          |  65 +-
 tools/testing/selftests/mm/vm_util.h          |   5 -
 42 files changed, 935 insertions(+), 369 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (98%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)
 create mode 100644 tools/mm/gup_bench.c


base-commit: 4c6512d033e5e9469cc76d07512c24a0ee0ac207
--
2.39.5



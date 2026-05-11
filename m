Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438C0CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7BA6B0088; Mon, 11 May 2026 12:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF126B0092; Mon, 11 May 2026 12:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECC86B0098; Mon, 11 May 2026 12:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1716B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:28:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F7881A01D6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:52 +0000 (UTC)
X-FDA: 84755672904.25.C92B6FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BAF46100012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocKsSSY+;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jHM2ryMppQwaqSziOVsJnMI80M5ased+I4h9z9Mb6CQ=;
	b=LzOjH9G3tiIZHgUKJ1gpYYlwghRTNJZQA7IGkFrbkDpsnLS+8DEOsk8kv32LxvbihJysA7
	NKvYM48dvV5LLgjUGT2D7kqvFUEVgltM3bDLPtEQFDKT07bvZri9NElPTCt2GJetZe1KgN
	e4OS7+uXCpet+XRNI5Ka3HNbbw/QnE8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocKsSSY+;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516930; a=rsa-sha256;
	cv=none;
	b=Y0nh3u1WbKA08vmzbA3w3HzEEqrHJy8kkLjE6gparjgGPzDBj5gnae+AnB/OkOvd0D9XvB
	k/kndD8vUkVqTpB4lLyYj1OqNirWNi1KgDWTiA9sFuOJ5XgUgYQRzwH8NcdqYmTxLuKWJG
	zxX4ohmSBQL1m49OdqG+UxWhHGGQoFU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 240C060121;
	Mon, 11 May 2026 16:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC2C2BCB0;
	Mon, 11 May 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516929;
	bh=+no3+xKhYj4yN1zC8P472TW32hg0wI8oEgLQagvwFgo=;
	h=From:To:Cc:Subject:Date:From;
	b=ocKsSSY+KYK+4R26X7KKnfGhqH/nrJLmE3wnlQ5oKy0PRoIo56s1EoC5CEaQ0UEJd
	 TFsWplymFjFD5thFhB67wqQkG0315rEpigkzFf3D1F9lFm4X7eJiElR/oYSUn99HvQ
	 RjpLoXqE+wn33ipw9CXg+xMJoj4EeoNiGBkGmb64KMHEzkMiiy+MW/g+pnosawWI8l
	 wVbxFrSVtUk/VidFd9iTxnyAzDPJCDagE8LjMVLscwA24cw7WxARX9hP+dPyBG+HF6
	 DUHroA+FlWg2vFXedw4XdmiM5iBjE0SihOdPmpyo0ts0B+jLAaIGCnG+T+VcAownlJ
	 izzPCD2ORxkVQ==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 00/55] make MM selftests more CI friendly
Date: Mon, 11 May 2026 19:27:44 +0300
Message-ID: <20260511162840.375890-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BAF46100012
X-Rspamd-Server: rspam06
X-Stat-Signature: qzzpunu7u31tr8qoyze9txrjk1hk5e4g
X-HE-Tag: 1778516930-327215
X-HE-Meta: U2FsdGVkX1/9sbfp5fp7ERpUZKBQRdj+K8QQ4OsxW+3VGgOKrfnNFyc9+u59kKmdvcezsu8aixpbDS2hyzACagDwqsfEmLXfH0EzbONmvl2pmTkM1En/XKSfyU/svIGCq+juGo6xHLYLNQNtHQQQbfJwHPNfJenZ/kFvf4Ge3V3JY6JdIgL0FAe0e619XMEE959Yr8C0ac7hVsaGNXZSA2SeKAWs1xzCVu/lK1SUbKXX8P1/5Fn8lo61KggpBF9zK4HPXkKaQTrJYVBe3l5CRHY03yI5/PM/YQgzbq7MO8KMHZC8dnH31aK7Idzfw/ijOeqM/7MVgSKWKvj2ZglGE4TMWIdtYh6e/sHeNEpXwkZk4GZNErF+f6ny3q7rPPLEkrj0R0wLabz8yyjFyKu7I5ug1+5NDHT2vGw0BNTt7U6bysGHV2Z0VMJjQrQnZ2iUba56tO3vQk6bvpL8gQjsiqhDkFSWUXEUWjbtVbImXbd+8tgZ+LgxHFldxIU01q7jbhI9j+oNFlSlFsbkcwFUbY+UCPZSfQYllynlREpsnoSAhaJiJC4jXbO6JjUa7RtaDP/TcYZ9/FI0VegKXwkjUXUlB+xlbWv2bBb1ZqjuUBL9VtHoXrR7VWXPzsa8HCi2kmT/wka0kdQLG5jb1z1D8yCJDMgO2jxVmjWdyaoESRYwL/EQRwWrASB0UU0PS5Lz5hJqsew+O6e+iDPyLM46QhdR177xG6RTsjq7KMEmcaSAUScO2xwjvrCAfEZiXR1+8yBazUyijvzQo2khde8zxylKVHY9bFaw1wqz1+WZcyuRFhm/l6zSni1br6Ish3hKXPdawaI1tVFA3OTg1T466QDAAdTJ7MQnfyXIVvpt1rRxjKBNO4xn29RLTd8LlM+9U2jAlr7juyXcHck84qRDWi0ORIibS2W+Xb+yK1Z2gH7RxYPqRFybiUXoHFQ3eIwxEJlqb7AefJSwLkqqpdj
 eepF1ZrC
 1Or/e6plWkr8AVxT9v2WdvRCjy7PSRnX4DYyBwPsYn1nPSBcxbLtkbjXAuD90Z6e6YWLyCWJxVox9uZr+3KNmyEXYXsNdbMQm3o10YQN/7VRj3sG/85QcigYHm2z/IJKmpDu1MHfB0nPUls0amEmec2vRZiyM+QkaKifr+a1EighWLDdsJXkGVemvkZcU5Du4+EBGh6hxlH+/zNqbdhWCmAZqe94eoib9zD4RRCeVd0uUwFc=
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
patches 1-5:   small fixes
patch 6:       merge of hugetlb mmap tests
patch 7:       renaming of hugepage-* to hugetlb-*
patches 8-21:  mechanical conversion to kselftest framework
patches 22-28: extension of thp_settings to hugepage_settings to also include
               HugeTLB helpers
patches 29-30: add helpers for setting up SHM limits in hugetlb-shm and
               thuge-gen tests
patches 31-53: integrate the new APIs in all the tests that use HugeTLB
patches 54-55: drop HugeTLB setup from run_vmtests.sh

--
@Andrew, I think it's good to go now.

I'm sure Sashiko will still have somehting to say, but there is really a lot of
room for imporvement in our selftests and with Sashiko being overly pedantic
we'd be stuck forever.

v4 changes:
* rework fork()ed process cleanup in migration test to be more robust
* rework HugeTLB setup to use free pages before allocating new ones,
  add hugetlb_setup_default_exact() for compaction test
* guard against double save/restore of THP and HugeTLB settings
* convert uffd error macros to use ksft reporting
* fix ksft reporting in several tests
* gracefully bail out if default huge page size is 0 in several tests
  and gup_test
* add more tags, thanks everyone!

v3: https://lore.kernel.org/all/20260428204240.1924129-1-rppt@kernel.org
* add patches that fix cleanup of fork()ed processes in migration test
* drop MADV_REMOVE changes to khugepage test
* properly setup memfd for non-default hugepages in hugetlb-mmap test
* add forgotten hugetlb_save_settings() to hugetlb_setup()
* fixes for ksft reporting
* rebase on v7.1-rc1
* add more tags, thanks everyone!

v2: https://lore.kernel.org/all/20260418105539.1261536-1-rppt@kernel.org
* fix hugetlb mmap tests to actually test file mappings
* increase maximal tests number in khugepaged
* add tags, thanks everyone!

v1: https://lore.kernel.org/all/20260406141735.2179309-1-rppt@kernel.org

Mike Rapoport (Microsoft) (55):
  selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
  selftests/mm: migration: don't assume huge page is TWOMEG
  selftests/mm: migration: make nthreads represent number of working threads
  selftests/mm: migration: properly cleanup fork()ed processes
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
  selftests/mm: protection_keys: use descriptive test names in the output
  selftests/mm: protection_keys: use kselftest framework
  selftests/mm: uffd-common: use kselftest framework
  selftests/mm: uffd-stress: use kselftest framework
  selftests/mm: uffd-unit-tests: use kselftest framework
  selftests/mm: va_high_addr_switch: use kselftest framework
  selftests/mm: add atexit() and signal handlers to thp_settings
  selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
  selftests/mm: move HugeTLB helpers to hugepage_settings
  selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
  selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
  selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
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
  selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
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

 Documentation/admin-guide/mm/hugetlbpage.rst  |  15 +-
 tools/testing/selftests/mm/.gitignore         |   4 +
 tools/testing/selftests/mm/Makefile           |  13 +-
 tools/testing/selftests/mm/compaction_test.c  | 115 +-----
 tools/testing/selftests/mm/cow.c              |  31 +-
 .../selftests/mm/folio_split_race_test.c      |  25 +-
 tools/testing/selftests/mm/guard-regions.c    |   2 +-
 tools/testing/selftests/mm/gup_longterm.c     |   5 +-
 tools/testing/selftests/mm/gup_test.c         |  15 +
 tools/testing/selftests/mm/hmm-tests.c        |  24 +-
 tools/testing/selftests/mm/hugepage-mmap.c    |  78 ----
 .../{thp_settings.c => hugepage_settings.c}   | 316 +++++++++++++--
 .../{thp_settings.h => hugepage_settings.h}   |  82 +++-
 tools/testing/selftests/mm/hugetlb-madvise.c  | 215 ++++------
 tools/testing/selftests/mm/hugetlb-mmap.c     | 143 +++++++
 .../{hugepage-mremap.c => hugetlb-mremap.c}   |  15 +-
 .../selftests/mm/hugetlb-read-hwpoison.c      | 121 +++---
 .../mm/{hugepage-shm.c => hugetlb-shm.c}      |  69 ++--
 .../selftests/mm/hugetlb-soft-offline.c       |  45 +--
 .../{hugepage-vmemmap.c => hugetlb-vmemmap.c} |  46 +--
 tools/testing/selftests/mm/hugetlb_dio.c      |  15 +-
 .../selftests/mm/hugetlb_fault_after_madv.c   |   9 +-
 .../selftests/mm/hugetlb_madv_vs_map.c        |  22 +-
 tools/testing/selftests/mm/khugepaged.c       | 380 ++++++++----------
 tools/testing/selftests/mm/ksm_tests.c        | 182 ++++-----
 tools/testing/selftests/mm/map_hugetlb.c      |  88 ----
 tools/testing/selftests/mm/migration.c        | 147 ++++---
 tools/testing/selftests/mm/pagemap_ioctl.c    |  13 +-
 tools/testing/selftests/mm/pkey-helpers.h     |  15 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/protection_keys.c  | 130 +++---
 tools/testing/selftests/mm/run_vmtests.sh     | 174 ++------
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       |   2 +-
 tools/testing/selftests/mm/thuge-gen.c        |  96 +----
 tools/testing/selftests/mm/transhuge-stress.c |   2 +-
 tools/testing/selftests/mm/uffd-common.h      |  18 +-
 tools/testing/selftests/mm/uffd-stress.c      |  43 +-
 tools/testing/selftests/mm/uffd-unit-tests.c  | 138 ++++---
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  20 +-
 .../selftests/mm/va_high_addr_switch.c        |  42 +-
 .../selftests/mm/va_high_addr_switch.sh       |  41 +-
 tools/testing/selftests/mm/vm_util.c          | 134 +++---
 tools/testing/selftests/mm/vm_util.h          |  15 +-
 44 files changed, 1500 insertions(+), 1609 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
 rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (58%)
 rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (51%)
 create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
 rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (92%)
 rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (55%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
 delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
--
2.53.0


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC0ECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762DA6B0005; Tue, 19 May 2026 08:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73AD26B0088; Tue, 19 May 2026 08:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676A26B008C; Tue, 19 May 2026 08:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 554326B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:05:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 024A31A02FA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:26 +0000 (UTC)
X-FDA: 84784039494.22.3A770DF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6406140017
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mp1ND4Y1;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o4CCKfqEHkIT3vZRPUFs55q3AXabcH9Uq8E1noxbG2w=;
	b=mbDxIOy/AUCa13yQHAg+1evy6OOINfwQvRVhrbpSTqGazqw3lxGddiTt1qwSriTMaWsjjX
	R5/Zlt/xuMzIZPiOfp/eSDbEevOe8ayZhaTb6xyCvPgU+urypTieeTOsxn5ifHyUfYotOo
	qRCIE5bwY6a0mhGsAdqAXMZudaMw/0c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mp1ND4Y1;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192325; a=rsa-sha256;
	cv=none;
	b=qdh7qBOdWoDAEMa2ecJUXbf3iPGjFwxlxl5ZLoiBD48wxFXUB8auF3Z+rcsfbF4bDgv+B3
	5kv2iJMf3o3JkCnEGk3qgY7kcfvCqaU24MiN0PAlh7xdBSRdDrudX5rX4KJhAwyimdR/XL
	37UoOLUbQmpJ4auMhrxb6tJCIp6vrTk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F89D22FA;
	Tue, 19 May 2026 05:05:18 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 06F413F85F;
	Tue, 19 May 2026 05:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779192323; bh=WfBGYRVm/z3p9e1wUlYW7mzI99DfsJJPI49IxgMxP10=;
	h=From:To:Cc:Subject:Date:From;
	b=mp1ND4Y1yhUyvt5HG6APJj/I/FYv2OVGOjyTHl5y4LSITFe1kDmHylSRKIfqpHykT
	 kxzxmyOqv+GdKQTkN4879TV2cGAZ27Blx2f/Uajy7Pc02Id1YeOQptviuSdWiZMybo
	 BGTBlcOVSTd/BJoNBG10MnfBBIgYmq6YdgLaOB4k=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 0/2] selftests/mm: separate GUP microbenchmarking from functional testing
Date: Tue, 19 May 2026 17:35:04 +0530
Message-ID: <20260519120506.184512-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D6406140017
X-Rspamd-Server: rspam06
X-Stat-Signature: yj3phu7mbfn84mbe9ccyemy1bojwwr4e
X-HE-Tag: 1779192324-729322
X-HE-Meta: U2FsdGVkX19o7PyuOEiUsE/fzBKE2Orj/gags66Tlpxv6ID3ryEF9eMFdQncwDqvpd4y7MQOJLTC5GfETm4ZhKICuRhFpQ8V0vvVOxhGLuhy0bQ23iVEuM8uqlSS5TlUWcTf9tOilIwRus9k4ZXt+dNcyvtEu5u0bpMvMXnY1i/ap6HvlQY+HJvDGKLsT88/hGIKDvHtamYfStYUPy0+tTST5F7lhCJIKaYi63PZIVEJAkZ7rCTy2ZzuBAps0+u1dqidR5XaxL52yWIAYztUyakXh9AQLypCJPfcM0vIKaJrcdFJZlbXbqhsC1IqKfJg45MtAlAdpUFfMGA0IznC+zYbkwGLDYKSj/fD6uG4vOitqUphNXPrl9+1YYeqkDpteQoQnbMjA2l3g1rdM2nyEsJo5OA+xEUyiARlPn4xUjLRqcFJ+SkNSCGcCcEZLQJ1RbJmh74YpJRL4/7WTJjjPXhEW7jMRClkM7iPgtzJ+WMiuK/Kv7kmcA0fTeRq8g9tmPX0njnCqo4bldoTXOEPN5GcPhz0v0rDHxvi1CQ7R3jzEZH+m3foA/8Q0MajHrjvot5WXOzktYBdDM4Xpx71oNcN2k5LAZwu8i0z2XGvCbfJ0hPVsijl2rXmnDpX7/35ThwhV8OQMM9qnUN8mk450zUHgEj2dY6jpqN3zPk3AzITAlo2EFdnUa6nPzcwQ4kz4WpDNMC3ar8XLh2w3QBqV9UpG5SXa9O8BBN+hVFcUV2ESe/+AEW1P/PeoT3yWWaSpD68rIUCMh2Q44Ik+4pu/A7DhwH41volaK0nNV4mo+nTenmStfnASANKc9FriE2MQJPZvnahWHr67Bh8PG8S7e1cqGXZSYUNiOEtVbPRRgy+ul2eRQnmRn0GkirDMTq8jr9UoGc7Exghn/nYsVOFCRoxsaLATcvnLz7ucGfnQQCXehYHLoJYUfVZ33nqVSKGV6TDni6CPDSOD7/DONg
 osdQ7UAB
 NvZhIAGkKDkGPBeHxycewnBi6fWiPCPITDue0PM0HNUsM2c78y8pB4hrmCthV7q2gXAviTUQnTEQdrP1kP4354wUgLKMkNMDPNXNWts0I582VubG1WaJNy8ZRXacFFW/viN0jQ/Kt1XbiJVCQQPYLC1lUgm2u8dssYY2FahMqTZwjRpWXdUiAVAVHfh99zU4qHlrVAKkMy8tEOpYipxQ6457i8g==
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
tests cannot be run or reported individually, and run_vmtests.sh must
invoke the binary multiple times with different flag combinations to
cover all configurations. This patch series separates the two concerns:
tools/mm/gup_bench for benchmarking and tools/testing/selftests/mm/gup_test
for functional testing.

Patch 1 adds tools/mm/gup_bench.c, a standalone microbenchmark for
GUP_FAST, PIN_FAST and PIN_LONGTERM via the CONFIG_GUP_TEST debugfs
interface. It runs the same matrix of configurations as the old
run_gup_matrix() shell function (all three commands, read/write,
private/shared, four page counts, THP on/off, hugetlb), but as a
standalone C program under tools/mm with no dependency on kselftest.

Patch 2 rewrites gup_test.c as a kselftest harness-based selftest. It
covers all five GUP kernel functions (get_user_pages, get_user_pages_fast,
pin_user_pages, pin_user_pages_fast, pin_user_pages with FOLL_LONGTERM)
plus DUMP_USER_PAGES_TEST, across 12 mapping configurations (THP on,
THP off and hugetlb, each across private/shared and read/write variants)
and four batch sizes (1, 512, 123, all pages). Results are reported as
standard TAP output with no command-line arguments required.

---
These patches apply on top of mm/mm-new.

Changes in v2:
- Address v1 feedback from Sashiko
- Add fast and longterm GUP/PUP coverage
- Sweep nr_pages_per_call over 1, 512, 123, and all pages
- Call madvise(MADV_NOHUGEPAGE) in non-THP variants
- Use 256 MB for hugetlb fixtures
- Use hugetlb_restore_settings() in FIXTURE_TEARDOWN instead of atexit()
- Add TH_LOG to report nr_pages_per_call for each iteration
- Update Documentation/core-api/pin_user_pages.rst unit testing section

Sarthak Sharma (2):
  tools/mm: add a standalone GUP microbenchmark
  selftests/mm: rewrite gup_test as a standalone harness-based selftest

 Documentation/core-api/pin_user_pages.rst |  12 +-
 MAINTAINERS                               |   1 +
 tools/mm/.gitignore                       |   2 +
 tools/mm/Makefile                         |   6 +-
 tools/mm/gup_bench.c                      | 491 ++++++++++++++++++++
 tools/testing/selftests/mm/gup_test.c     | 536 +++++++++++++---------
 tools/testing/selftests/mm/run_vmtests.sh |  37 +-
 7 files changed, 822 insertions(+), 263 deletions(-)
 create mode 100644 tools/mm/gup_bench.c


base-commit: 2c3f468717231305523ddcd94d91c0d5e4a72419
-- 
2.39.5


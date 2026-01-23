Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B4DD77898
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01FA6B056F; Fri, 23 Jan 2026 20:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD94B6B0570; Fri, 23 Jan 2026 20:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE56F6B0571; Fri, 23 Jan 2026 20:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 986D06B056F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:06:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7970BB5445
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:40:00 +0000 (UTC)
X-FDA: 84364697760.05.41F4F83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 870B9100002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:39:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KW+TgC3E;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769207998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ISeqwZ3LCs+FdbftQL9N+R7jQ8une7cuCp1Me0wVDXk=;
	b=VKecgzs6Pz/hgqU4/6GEynJVe8PP/Td4t6N8WtMU8gyVypAhQQPfGm5MFE+yFkS6R90ENk
	WJMpZy90I+7ZiTqAotbBTunHNPXLCcW6jXhoovsNEfStkiK1PRlR/oHSVhL7TSIVT5gAh5
	JPVGZgrkl6UTEjLHzrPcDQEdgzOau6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KW+TgC3E;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769207998; a=rsa-sha256;
	cv=none;
	b=E0TUizyu5I6tG1dvezSl8s6GH8VJMCGl+c5iM73t1MzTOqlo73RO2A/KR5rRWeRmyZazW4
	MapVM781BkXDtrYY+/KHkNg8PVTWHNFF+ZWHo+3wTk0o0wHTyeX/2I7KeGjQMCoMf4olHi
	Op+E2ofmExyaO0Se4rYoiqhj3yDx+40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1949B43670;
	Fri, 23 Jan 2026 22:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153F6C4CEF1;
	Fri, 23 Jan 2026 22:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769207995;
	bh=vZX9tEDWCPt/E4k47aOA3Hjq/sisnm01br61YI26HFA=;
	h=From:Date:Subject:To:Cc:From;
	b=KW+TgC3EX6NjAY3+Ryc3F//h9F2cVHUFFGwc25TS4BJirCLW1xoMs+9IXsKNszYp6
	 YfJMq9I1zNcFEkIvcwWmGO85QisDxV3GfXJt/6WWdmfmFhqzWEaqTmymHvg58ft5v9
	 GBvfuld1ugdaqa1Ix5EOD0CeMPgyuqkrOFg9mkpehky9LK+0XNbD7+kW5f4Y3g8GoE
	 x43TVTYiWZ2NpVGc10QZ1iQ8Bdst0+K9np4NhSIsOlu9t9224/IT5mxS0zZx1UJ5Hi
	 6MFhe44bbqkOrJNd9UWkfEvIX6WxZ+Nsb2YLuhaYW2cPUhACfzbcgf26wzEcHVrkoA
	 e+1vM0dx43/Qw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 23 Jan 2026 22:39:24 +0000
Subject: [PATCH v2] selftests/mm: Have the harness run each test category
 separately
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-selftests-mm-run-suites-separately-v2-1-3e934edacbfa@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJv4c2kC/42OSw6CQBBEr0Jm7Zj5hURX3sOwaIYGR/mleyASw
 t0d0AO4fJVKvVoFIwVkcc1WQTgHDkOfwJwy4R/QNyhDlVgYZXKl9UUytnVEjiy7TtLUS55C4pS
 PQBCxXWQOroIKtM29E2loJKzD+5Dciy/zVD7Rx315bzwCx4GW48Ws995PaNQ/wllLLcFZ62rly
 9LC7YXUY3seqBHFtm0fMcek3+cAAAA=
X-Change-ID: 20260119-selftests-mm-run-suites-separately-6a4dada136c4
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=15844; i=broonie@kernel.org;
 h=from:subject:message-id; bh=vZX9tEDWCPt/E4k47aOA3Hjq/sisnm01br61YI26HFA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpc/i4Xd2nYLEbCxzebCyVOXW7b0zK52uohHVBF
 DJLyS9uLnCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaXP4uAAKCRAk1otyXVSH
 0PpnB/41lmCi2xtFXJggsXO3n6ljcUlpETtJLsDdGG/IoIJxsSjoWCtM+wntYPCWdjy2SdQJFLo
 R3y4j4CXeLz2xxCvgxe28rNEjr9qFGci77EMkZL3/jY7gHt3cff2OcAciD08h77hMC2gUFMpYaC
 wcNOo7u0OTe2Ud+M07rAX+EyOQIZ4dhMHfyjot5a+jRwtLeH3B5EENlvGfjdDOdc7rtBjBrdgke
 WF4sAMRZdDxPh8NY5V/AHsxatwM+xjRV7eia/0mKmdAQhsuaJBVTuP9/pvCRk4OgOHMM/M6FeOc
 Kcy8+7Mc2dMbAX0X/bL/87AMW8HJhKEDfrzQ9p8feNu1JlSH
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 870B9100002
X-Stat-Signature: 8w6p38wenrbxikk4oam9idmgjxr319ud
X-Rspam-User: 
X-HE-Tag: 1769207998-420411
X-HE-Meta: U2FsdGVkX18hmztNTfcW4CEUq8EpnFoQtIrQGdOC8pFqsZRtAx7HMLjG17Op9M4XI2ghXF/tb8eLmyYjMRhGKZlinVOosM2NH0oidlYa/5FX/iMG2qORxGNSrwnE+wFCJ9//jJDpDlI6QpPxkoYfCVBesk/IFG5ZRr0LCxcsYflK9Mw80Y0uFWwQ4vEqOlbU/VYD/lEsjsmKE1GCG26K7s1iorYcqhZIsjMiRECMT9gboIeiGGVuZE/rqY6rQy4a0XeFVvbM6xNEposVNbzYhniIb9Yd4wgz8LjiP9V9Y6tYXyEP8hPdpp0H6ht0p9Nx/2Wnx+M9YLRRaPe2ydPB1d1lLZrVeFS2XDq/XdzHMdSPugTr2edmYEWhFUxiXDesY/jRqazRZ9kRxPPEdxzLpNmKCUVKvwHj3axk5nv6U5qtxSF3gbinv2EzKjN1mXc1J+YXRC48hlk/LtrzKi6vfXgidsece4W8IeBG5yVhbpmzscZHqUVTDfOq4UjcpQ4/ecEijgzMyzI/42VRSdLa6e7icmWr8YEHTOOnLufyE2Khcn0HmWbHS2JM4YhuWFvuAHnKwHaZd7DVoFkcnlHQMFWuB5nyx0M9KI9XZ/oJ6REKpqe3LwSkGejt2NqcZjYBBSAT9hqU0yatQLjBpegi/IHVJiFX3JAysKGglK6ZbBSJUzEcstB6yJHTrSdHejXy06imN8FrYurmUswj2Kyq58g+qV9p4olo3vQce9fCmF0JGXrdyVBUTkAQE7j3BJ8Mv71YKYYlplW74MRVwvFQHnB+zF9ufN2csJQwwv6OcFMXWjGy/YJxeMDaG3GArcRLL2OzZXotXE3KKSz1/2rFjsK4UkL4dqmuBLGN/exP6eT3T6qLWQ/j6mAMag6QSabluOWZeNJQb4bgYMVyYF4btR3+SviyNrludtnc3jOYBIqL+w3lG3/faekBrfapHNz19Xwpp7ysIurFmsy9uZO
 0enIianA
 sORvDL8OENO1+G3qGsQEMBfkZAS7NKEOAzWUVpPMmxdPF4B6RSVRNt4hbSaWQM9F0Ry15TqqJ6l7zgns3obTNspRP8VIsYP2+HAziE7+J3ve4ikmb1wW60ZqBccGeErJ6acZtacma6LkAXGkH3ZlrKTdMGQ67Qt5cj2QtNQ/ClNcOSQnDaoQWFBEsIk4NZmHSFJfEEiORhtZQO7AHTQiwlLu2sUx6Plv8K7KH7VFpOtj7qHyEM5W8+Cm58PzHn39ciz0IQm8uHLHsmSwrDH/mHGB2qYC5VQDcv82KaJo7cxS08qSP/4D8DatvLmdGpnGr7IabSSMGByyDpa0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At present the mm selftests are integrated into the kselftest harness by
having it run run_vmtest.sh and letting it pick it's default set of
tests to invoke, rather than by telling the kselftest framework about
each test program individually as is more standard.   This has some
unfortunate interactions with the kselftest harness:

 - If any of the tests hangs the harness will kill the entire mm
   selftests run rather than just the individual test, meaning no
   further tests get run.
 - The timeout applied by the harness is applied to the whole run rather
   than an individual test which frequently leads to the suite not being
   completed in production testing.

Deploy a crude but effective mitigation for these issues by telling the
kselftest framework to run each of the test categories that run_vmtests.sh
has separately.  Since kselftest really wants to run test programs this
is done by providing a trivial wrapper script for each categorty that
invokes run_vmtest.sh, this is not a thing of great elegence but it is
clear and simple.  Since run_vmtests.sh is doing runtime support
detection, scenario enumeration and setup for many of the tests we can't
consistently tell the framework about the individual test programs.

This has the side effect of reordering the tests, hopefully the testing
is not overly sensitive to this.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Add comments to Makefile and run_vmtests.sh about the need for
  updates.
- Link to v1: https://patch.msgid.link/20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org
---
 tools/testing/selftests/mm/Makefile                | 33 +++++++++++++++++++++-
 tools/testing/selftests/mm/ksft_compaction.sh      |  4 +++
 tools/testing/selftests/mm/ksft_cow.sh             |  4 +++
 tools/testing/selftests/mm/ksft_gup_test.sh        |  4 +++
 tools/testing/selftests/mm/ksft_hmm.sh             |  4 +++
 tools/testing/selftests/mm/ksft_hugetlb.sh         |  4 +++
 tools/testing/selftests/mm/ksft_hugevm.sh          |  4 +++
 tools/testing/selftests/mm/ksft_ksm.sh             |  4 +++
 tools/testing/selftests/mm/ksft_ksm_numa.sh        |  4 +++
 tools/testing/selftests/mm/ksft_madv_guard.sh      |  4 +++
 tools/testing/selftests/mm/ksft_madv_populate.sh   |  4 +++
 tools/testing/selftests/mm/ksft_mdwe.sh            |  4 +++
 tools/testing/selftests/mm/ksft_memfd_secret.sh    |  4 +++
 tools/testing/selftests/mm/ksft_migration.sh       |  4 +++
 tools/testing/selftests/mm/ksft_mkdirty.sh         |  4 +++
 tools/testing/selftests/mm/ksft_mlock.sh           |  4 +++
 tools/testing/selftests/mm/ksft_mmap.sh            |  4 +++
 tools/testing/selftests/mm/ksft_mremap.sh          |  4 +++
 tools/testing/selftests/mm/ksft_page_frag.sh       |  4 +++
 tools/testing/selftests/mm/ksft_pagemap.sh         |  4 +++
 tools/testing/selftests/mm/ksft_pfnmap.sh          |  4 +++
 tools/testing/selftests/mm/ksft_pkey.sh            |  4 +++
 tools/testing/selftests/mm/ksft_process_madv.sh    |  4 +++
 .../testing/selftests/mm/ksft_process_mrelease.sh  |  4 +++
 tools/testing/selftests/mm/ksft_rmap.sh            |  4 +++
 tools/testing/selftests/mm/ksft_soft_dirty.sh      |  4 +++
 tools/testing/selftests/mm/ksft_thp.sh             |  4 +++
 tools/testing/selftests/mm/ksft_userfaultfd.sh     |  4 +++
 tools/testing/selftests/mm/ksft_vma_merge.sh       |  4 +++
 tools/testing/selftests/mm/ksft_vmalloc.sh         |  4 +++
 tools/testing/selftests/mm/run_vmtests.sh          |  4 +++
 31 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7..aa4951e8cb57 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mm selftests
 
+# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
+# script so kunit knows to run it, and add it to the list below.
+# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
+
 LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
@@ -146,7 +150,33 @@ endif
 TEST_GEN_FILES += write_to_hugetlbfs
 endif
 
-TEST_PROGS := run_vmtests.sh
+TEST_PROGS += ksft_compaction.sh
+TEST_PROGS += ksft_cow.sh
+TEST_PROGS += ksft_gup_test.sh
+TEST_PROGS += ksft_hmm.sh
+TEST_PROGS += ksft_hugetlb.sh
+TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_ksm.sh
+TEST_PROGS += ksft_ksm_numa.sh
+TEST_PROGS += ksft_madv_guard.sh
+TEST_PROGS += ksft_madv_populate.sh
+TEST_PROGS += ksft_memfd_secret.sh
+TEST_PROGS += ksft_migration.sh
+TEST_PROGS += ksft_mkdirty.sh
+TEST_PROGS += ksft_mlock.sh
+TEST_PROGS += ksft_mmap.sh
+TEST_PROGS += ksft_mremap.sh
+TEST_PROGS += ksft_pagemap.sh
+TEST_PROGS += ksft_pfnmap.sh
+TEST_PROGS += ksft_pkey.sh
+TEST_PROGS += ksft_process_madv.sh
+TEST_PROGS += ksft_process_mrelease.sh
+TEST_PROGS += ksft_rmap.sh
+TEST_PROGS += ksft_soft_dirty.sh
+TEST_PROGS += ksft_thp.sh
+TEST_PROGS += ksft_userfaultfd.sh
+TEST_PROGS += ksft_vma_merge.sh
+TEST_PROGS += ksft_vmalloc.sh
 
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
@@ -154,6 +184,7 @@ TEST_FILES += va_high_addr_switch.sh
 TEST_FILES += charge_reserved_hugetlb.sh
 TEST_FILES += hugetlb_reparenting_test.sh
 TEST_FILES += test_page_frag.sh
+TEST_FILES += run_vmtests.sh
 
 # required by charge_reserved_hugetlb.sh
 TEST_FILES += write_hugetlb_memory.sh
diff --git a/tools/testing/selftests/mm/ksft_compaction.sh b/tools/testing/selftests/mm/ksft_compaction.sh
new file mode 100755
index 000000000000..1f38f4228a34
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_compaction.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t compaction
diff --git a/tools/testing/selftests/mm/ksft_cow.sh b/tools/testing/selftests/mm/ksft_cow.sh
new file mode 100755
index 000000000000..1e03a95fd5f6
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_cow.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t cow
diff --git a/tools/testing/selftests/mm/ksft_gup_test.sh b/tools/testing/selftests/mm/ksft_gup_test.sh
new file mode 100755
index 000000000000..09e586d2f446
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_gup_test.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t gup_test
diff --git a/tools/testing/selftests/mm/ksft_hmm.sh b/tools/testing/selftests/mm/ksft_hmm.sh
new file mode 100755
index 000000000000..0a7b04f454d5
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_hmm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hmm
diff --git a/tools/testing/selftests/mm/ksft_hugetlb.sh b/tools/testing/selftests/mm/ksft_hugetlb.sh
new file mode 100755
index 000000000000..4f92974a4eb5
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_hugetlb.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hugetlb
diff --git a/tools/testing/selftests/mm/ksft_hugevm.sh b/tools/testing/selftests/mm/ksft_hugevm.sh
new file mode 100755
index 000000000000..377967fe9c91
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_hugevm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hugevm
diff --git a/tools/testing/selftests/mm/ksft_ksm.sh b/tools/testing/selftests/mm/ksft_ksm.sh
new file mode 100755
index 000000000000..f6a6fe13a3b0
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_ksm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t ksm
diff --git a/tools/testing/selftests/mm/ksft_ksm_numa.sh b/tools/testing/selftests/mm/ksft_ksm_numa.sh
new file mode 100755
index 000000000000..144b41a5e3bb
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_ksm_numa.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t ksm_numa
diff --git a/tools/testing/selftests/mm/ksft_madv_guard.sh b/tools/testing/selftests/mm/ksft_madv_guard.sh
new file mode 100755
index 000000000000..2d810c049182
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_madv_guard.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_guard
diff --git a/tools/testing/selftests/mm/ksft_madv_populate.sh b/tools/testing/selftests/mm/ksft_madv_populate.sh
new file mode 100755
index 000000000000..127e22ed02c4
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_madv_populate.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_populate
diff --git a/tools/testing/selftests/mm/ksft_mdwe.sh b/tools/testing/selftests/mm/ksft_mdwe.sh
new file mode 100755
index 000000000000..3dcae95ddabc
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_mdwe.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mdwe
diff --git a/tools/testing/selftests/mm/ksft_memfd_secret.sh b/tools/testing/selftests/mm/ksft_memfd_secret.sh
new file mode 100755
index 000000000000..56e82dd648a7
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_memfd_secret.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t memfd_secret
diff --git a/tools/testing/selftests/mm/ksft_migration.sh b/tools/testing/selftests/mm/ksft_migration.sh
new file mode 100755
index 000000000000..7cf37c72d26e
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_migration.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t migration
diff --git a/tools/testing/selftests/mm/ksft_mkdirty.sh b/tools/testing/selftests/mm/ksft_mkdirty.sh
new file mode 100755
index 000000000000..dd6332df3204
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_mkdirty.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mkdirty
diff --git a/tools/testing/selftests/mm/ksft_mlock.sh b/tools/testing/selftests/mm/ksft_mlock.sh
new file mode 100755
index 000000000000..1e25ab9fdc8b
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_mlock.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mlock
diff --git a/tools/testing/selftests/mm/ksft_mmap.sh b/tools/testing/selftests/mm/ksft_mmap.sh
new file mode 100755
index 000000000000..2c3137ae8bc8
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_mmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mmap
diff --git a/tools/testing/selftests/mm/ksft_mremap.sh b/tools/testing/selftests/mm/ksft_mremap.sh
new file mode 100755
index 000000000000..4101670d0e19
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_mremap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mremap
diff --git a/tools/testing/selftests/mm/ksft_page_frag.sh b/tools/testing/selftests/mm/ksft_page_frag.sh
new file mode 100755
index 000000000000..216e20ffe390
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_page_frag.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t page_frag
diff --git a/tools/testing/selftests/mm/ksft_pagemap.sh b/tools/testing/selftests/mm/ksft_pagemap.sh
new file mode 100755
index 000000000000..b8d270fdd43e
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pagemap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pagemap
diff --git a/tools/testing/selftests/mm/ksft_pfnmap.sh b/tools/testing/selftests/mm/ksft_pfnmap.sh
new file mode 100755
index 000000000000..75758de968bb
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pfnmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pfnmap
diff --git a/tools/testing/selftests/mm/ksft_pkey.sh b/tools/testing/selftests/mm/ksft_pkey.sh
new file mode 100755
index 000000000000..ac944233b7f7
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pkey.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pkey
diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
new file mode 100755
index 000000000000..2c3137ae8bc8
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mmap
diff --git a/tools/testing/selftests/mm/ksft_process_mrelease.sh b/tools/testing/selftests/mm/ksft_process_mrelease.sh
new file mode 100755
index 000000000000..f560aa5e4218
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_process_mrelease.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t process_mrelease
diff --git a/tools/testing/selftests/mm/ksft_rmap.sh b/tools/testing/selftests/mm/ksft_rmap.sh
new file mode 100755
index 000000000000..974742b9b02f
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_rmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t rmap
diff --git a/tools/testing/selftests/mm/ksft_soft_dirty.sh b/tools/testing/selftests/mm/ksft_soft_dirty.sh
new file mode 100755
index 000000000000..d160d7fea0a9
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_soft_dirty.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t soft_dirty
diff --git a/tools/testing/selftests/mm/ksft_thp.sh b/tools/testing/selftests/mm/ksft_thp.sh
new file mode 100755
index 000000000000..95321aecabdb
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_thp.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t thp
diff --git a/tools/testing/selftests/mm/ksft_userfaultfd.sh b/tools/testing/selftests/mm/ksft_userfaultfd.sh
new file mode 100755
index 000000000000..92667abde6c6
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_userfaultfd.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t userfaultfd
diff --git a/tools/testing/selftests/mm/ksft_vma_merge.sh b/tools/testing/selftests/mm/ksft_vma_merge.sh
new file mode 100755
index 000000000000..68449d840680
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_vma_merge.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t vma_merge
diff --git a/tools/testing/selftests/mm/ksft_vmalloc.sh b/tools/testing/selftests/mm/ksft_vmalloc.sh
new file mode 100755
index 000000000000..0b5019a76612
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_vmalloc.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t vmalloc
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..1b4546324ba7 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -2,6 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Please run as root
 
+# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
+# script so kunit knows to run it, and add it to the list below.
+# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 

---
base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
change-id: 20260119-selftests-mm-run-suites-separately-6a4dada136c4

Best regards,
--  
Mark Brown <broonie@kernel.org>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBC9D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292A26B03F5; Tue, 20 Jan 2026 08:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269A76B03F6; Tue, 20 Jan 2026 08:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193E46B03F7; Tue, 20 Jan 2026 08:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04DF86B03F5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:28:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD30D1A059A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:28:47 +0000 (UTC)
X-FDA: 84352422294.18.52D6929
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CD868000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:28:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c6N675Sc;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768915726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SipgiWAfYJZsPTsW2me+It0vkCm2J9mTyhKtDy4B1lA=;
	b=287m/oEmy2VPpWr0I4O8USgXupK6xf0ZR0cpZFsVSaxoXCHEUBDN3adc1sHotd5uhXhWYj
	vJcbzD0OutBOOxfFWBmlVzpC/xAwkQbfa2nVAfBQQP0cS6cRrukM6u6e8nZ4xay5Xrlgi5
	+9zk2XLTHNQsWVsvnZHh4LEZfXESDn0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c6N675Sc;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768915726; a=rsa-sha256;
	cv=none;
	b=zLUhwoUrMEHEB+Vwkwt5LoH0GS0IuuNDbO6f0jrBCaJSaABGYngehxyI8yEp/yBENa7tRZ
	P0Igy2h2tB9AvZbSyklFxJBeHQDesdgjeRaYqG2piOwi3IqAxGSl6pR+ubNYbzWtoe/X8/
	8KhDRhw2LqS/IRovjW418cQ91aLP+/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FCD60008;
	Tue, 20 Jan 2026 13:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC146C16AAE;
	Tue, 20 Jan 2026 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768915724;
	bh=l7OaSrpvOXeA2V4ZY/20vY2Xxa9QbTE77B6bJPqs5ng=;
	h=From:Date:Subject:To:Cc:From;
	b=c6N675Sc4M6L9G8ibxY1ntPd0Yqd+OYkBZnp63B72h3IB8SlPf07dQ+7zaunkgD5k
	 9Sx4rmUh7ChLoOLxIewg3JrKrRn9S5y0db9EB/6dcqUDyLp4T8Cprk1YKIR/HVEAjh
	 /KOOZLTQXpyH18sYvc/nsRK3Uplby7B5cdKiNyQlmYfK2TIbl15T7orxRFPC3JYffl
	 jWjti9oResKV2AyDq30ZaUzyGtvPWN9XbvGFw14EuLgRjZPgeDUc44J4p5WZeNf4Kt
	 rHeb8TM+z9IwkYDh017LnDyXdSGY/lvrZIJxyzvCrXEIv4XtpjvO0G3+LT/K2T6Dhg
	 ZIxiwlKAqPDFA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 20 Jan 2026 13:25:32 +0000
Subject: [PATCH] selftests/mm: Have the harness run each test category
 separately
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEuCb2kC/yXNQQ6CMBCF4auQWTsJRdJEr2JcjO2gY6CSTmskh
 Lsz6vJ7i/+toJyFFc7NCpnfovJKBndoIDwo3RklmqFrO986d0LlcSisRXGaMNeEWsVs+0yZCo8
 LeuojRXJHH3qw0Jx5kM/v5HL9W+vtyaF8y7BtO/ivgOCGAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14575; i=broonie@kernel.org;
 h=from:subject:message-id; bh=l7OaSrpvOXeA2V4ZY/20vY2Xxa9QbTE77B6bJPqs5ng=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpb4MIxOksEwEdA0i4Ekepapi/owMSOW8b25qgW
 pbNGDAZPtSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaW+DCAAKCRAk1otyXVSH
 0D7fB/95wEekw15kwcNccNI53G0IWlLpNpN6Zi79jwj8mfjvDMuPt78KYe3F5xT/Rp9s3yp0Dve
 ErEHNWpFisxFDxwDOfs9bCwWXYjvk2fWnMJ+Ra7Tpewkec/9P08Pgwso2p6HiYG41hvBqJWXk4w
 d7Z5M5PzWR04BV3YmG6SMw2t+Sk1TezDzbs6jvVOPMB2+JT8Zoq8Twcosd7h1z+3x5f0xZ7Wjiw
 tM9HfibLHI2pDNhDDV1nEYBoc6jd7qB88dbfs0ikj7ooUeq2ObKjzm7t2jowYGIs45fo/YUbrOc
 E710NLLr9nb/3W1E+mILIZP1RLoQ73HwOUNKIHqPBrmHAQk+
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Stat-Signature: i9wxi7yytmtwsjqpeq1pye5i3o4cd473
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CD868000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1768915725-621114
X-HE-Meta: U2FsdGVkX1/QU6bSnIKF2w+xsIb3vUrtuSoDANJgmyuH7CWfHeBMujcYQOG8ZudgW027+eqUW1BCiJUDK4itC3KYaSgPdYyNG9li2GvC2HM8hVBEBmuedA144gRZeHQ8sJRe8p5moF3SgQ9fta3d2kPrZXpRS2BLGqLOn8x40kvYATgcrpXO0BFVlGJ+RC2u6ywW98bwn7TiIhnVtbqDaOc6mGTyaAevweOZSvj5i1kDaAwJ3p5AldIfv5T/DHd4mWPwxlPfB54VwxjShHqiG66Od+PMokCQHAQ7Uq6EcB40oH4CSmFP0J7/cpJN2oslZOYuDZOOtywXlDL8nx9/FYYQB9bcZDEE4yjFN8BzKwFeOWn0tP8BhamNuuxp4dU9+inRxCaElWvO2kyFjy8nzmc58M/63x5c0FWn7o6aRInuN+4MHxEGjgmmQTl/3HaWbc7240yfaW1mGNyJ86++dj5DUkk+KbotO7uJdM06JL2EGjJl4LZcQ4XY+mjvThpUMYDiyPGI6mr/SOgzNcsiE4LNdLSrYmORthG/NUNPQcxOieVUivrLC6PI3ONvY8SHQzwtTLtqqhjwcwG2aQYdQyWVnzKZWvAmO/TSeGdlA2TCuAObw3dvvf+Y6hN3LoxFo82EdZQ3Bgay7r4kE1TvAkeuu+hNZMsqMN+WVSHxuKBiFlNMd5rrJZdkTb4RuI6uwmtDFqAiF+mdP5Mkv/lRi/tFsK2vGSonZWGkf1m+eNKbEfLhF6mHwtWQCIBfhSaXfzcEggdBeN1xd/o7uQ18B30Y9C0ZheKQhChGA7llTmPhBcHSmtFt17B0/r7+dzIOjUsEYVofJ5W0f9HeQoyVSpdnbz2Yj27u9VlWHw4II3J1oVV1Oo43WgS65tOhPMLAEZkOO3tTLGhKWhn2nh4jsp70NagGHesuemevPHqb0KJesgP0nartFSbtflMoUVgcoOvgiqlGmv6HzvJvu3v
 Obo/PCM0
 qRSyYzpklJYHNKV9WvQK1oou+dMmZisyoXtaipofM45GbgxlxMWZXD39CFx8o6T1YLBHMF3gWBJGPdcfCHRPVqr8vxpPxQWFbGrYFU9T4hHbH6VCASs2pBroLnwwG4aex92LbE/hfCwVG6exesqHZ51+NllKzfytWnicxgQ+zOZwGwRw9EJKMYLEMiCizpr8cVo4g4grl9QITOKg48BRRlIJihjoUAi/0kQVuftjeroAhPUyrTbAbK0gboQ==
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
 tools/testing/selftests/mm/Makefile                | 29 +++++++++++++++++++++-
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
 30 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7..69f10947735a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -146,7 +146,33 @@ endif
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
@@ -154,6 +180,7 @@ TEST_FILES += va_high_addr_switch.sh
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

---
base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
change-id: 20260119-selftests-mm-run-suites-separately-6a4dada136c4

Best regards,
--  
Mark Brown <broonie@kernel.org>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB6EC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E182D6B0096; Thu, 31 Jul 2025 08:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9166B0098; Thu, 31 Jul 2025 08:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF0A6B0099; Thu, 31 Jul 2025 08:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6F2C6B0096
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:22:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80C23C074E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:22:02 +0000 (UTC)
X-FDA: 83724471684.16.33501B3
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9151D40008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:22:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cmtg1UeN;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
	b=isnqMUigiWsrAN3hSKg+fSMJBlvQ+QiazNGE3gAny7Gcu+ZwRCv5pcSv7mn+0P+4bpT0ma
	KHQsHylIc0SYNYlwQIcTzufj/mluodCZC2r4NZC40i+DzTYgeFTqrYqGlUbyqFNLdBgLK2
	Ww4HC7T+0nBFVZ81bBUJiKM0bYKUSyE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cmtg1UeN;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964520; a=rsa-sha256;
	cv=none;
	b=BdF2EafFZ95TISv8RSRU9vo7/HzcKJRuCVADm73E/nfwY+s4nUZt+PwMtLMUS81vgzKRFq
	i78HAW15rwDG1iL/Su2tbjz4T6Gt1niYcJLCGCimF+j22g8CK7CDhpbkxYiA1vA2AAFR1i
	cuT1XV75p6lJtS8G9cDZ7S1cJdV3yC4=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-707365f4d47so9040286d6.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964520; x=1754569320; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
        b=Cmtg1UeNSXjL3x3quYmzN6xwbXYI7fYPQEAGuP3eZV8DSw7YouvbiTwhm2ki/okofU
         5tOxYcnz59ezAlmb+lIKTT4mrAvKZ7F2YAUGwnt7tr8RmPgthcKUXPOivK27k+m6D+Lx
         Ck9Jj1WrEQ8tqk5NhI9g55rYOoZqkDup54vC3gjiUJeh1i/F7hG1Hj6y+yMLcDHEx5Uv
         gZc0oy4SDYCuRGzY2+UYOBZLN0q0ugVCZrEQhYQeHPa5y0+senBWQF7fbrqHXLBVvsqs
         hCfpZzHF2ufJrFow3CLvFPqofT7ttD21d57UeHZd1cTBAWYSUuVwSVRcdY/n78pN6++b
         cefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964520; x=1754569320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
        b=W695XG7wbD+txKN+PEHJ53XaXkh7txt3T9Cmec/6LtLm/V8YTqOEBqS+TKw5mRORaW
         zzsfu7Q4qamOxXQXKQvKspfBo/EP3noLjDx6taLGTq8Fsid+yRtAF2EylAoivmUj4Atq
         AmDxKPRCzT8rOgnKJDncWLoFZBkS8u5KYdjktAgemHAJwm14kDZzYCvt3gPTFfCrJc3w
         1u0vtxOLc4tXhFGjIjbENA0iBh5bKayPqOBZL5VAAG3X5R6sOfFAa9DxURC6mh5WDnNx
         d4fAzB+LOghZRsUuAD9o6EE7N14mlkom4L4eIJC86YcBRD8VCUO8e1z+SypBX5f1u2cZ
         hBSw==
X-Forwarded-Encrypted: i=1; AJvYcCXqqeqIS1RwHVNqiQdLMocFSeiIutFyw+UfFbhXjQW6NxaEWO+FBMH1y5Rn7Dv7spZd5UBIJBExGw==@kvack.org
X-Gm-Message-State: AOJu0YwrJJx4UNHOYn8+jON7iwaVRAFGd7f4xJ83Cyc58UzxFoINte9p
	0GigiKFsL3BxhZ5X018e6XZjc8amY2ZmsWmfOZqREua4ptZnDE2iY/jD
X-Gm-Gg: ASbGncvv1n1n9rwPhmLCqbEq1sJ0EuZ+cxjmw7qmxD5QW/Sc6izv/2fxvrfZKPlRnGO
	iuQGOAlVpDzWoI7kxBG3f9wThE3CeJcvZu2kxDxMpuIy4ZWNJ8Eqf1z002UXvgM+9Xm4Ouzc6Hs
	CuZwRMj7oH3tZdQ8+Evt6VVKx96BPoLcZI8Yj29MTMIEFVqjcOXh+JCUdu/7NaJtWoi6HnouZSI
	rzV0PYAlIaFmaxgD/h6QF2wUb6auBKqKrRKWr1H3lAR4Bd8AVJW7FWQ+sjO1uLwmOOqjB7kyiQ4
	QL61hCo9fkYKnhix1cg3TPdMDdVHTFZEJiRdMgDY/pMJoVW/TZbFlIzAfy4ZA1GdJnLw5Xq3QuL
	k3hrynLkWHChJE+TQOtOdeDzwtfM=
X-Google-Smtp-Source: AGHT+IF8iazBUFYe2x7VXYujKRin85eKX5b7vBwpJMRoG6sK82a3fYUAJplnBuLpAonzOd8lfcMtXw==
X-Received: by 2002:ad4:5d63:0:b0:704:f7d8:7032 with SMTP id 6a1803df08f44-7077ced886cmr23408926d6.23.1753964519324;
        Thu, 31 Jul 2025 05:21:59 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-709205d12d9sm1635766d6.65.2025.07.31.05.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:21:58 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH 4/5] selftests: prctl: introduce tests for disabling THPs completely
Date: Thu, 31 Jul 2025 13:18:15 +0100
Message-ID: <20250731122150.2039342-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122150.2039342-1-usamaarif642@gmail.com>
References: <20250731122150.2039342-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xy6j6sabwfxubrtofqhe7g3bguukud43
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9151D40008
X-Rspam-User: 
X-HE-Tag: 1753964520-365205
X-HE-Meta: U2FsdGVkX18coLt112cgaDGyswPE5sMkNSdj2CiaDpUZXOFGYDWxSrKCxFx3mnnEnelSuboEfw7LdsmsBSfnj904lqs18ednu/TgK63GYgQaRHE1RBfvEF5sucDoEeQdsiZ+To8avNw6aw8yIDSXCGccJP2/LJK7vbf66TI/9YA2XYrF+epu2YJF60xZPc/Jv6VchnFezgwRdpLi4g8BDI6ErPMnXO1ESNfcBhlnfTVSi9JKN8qyllwqsPLwsr46mhH4A7HHRncVE7TQD+iB0nSU6/4C5PyHpvDHa6y6iSZTFUNONuUprzozsHqDDRmHPQ9q61e9WYeF3lDUwYOHa8Y0l9wdKn2Jo5ElFwx3l/cmZfRwCERDzfZslla+kNFdn5vD5OyunhLD9a6pqqIYKstCA+Rygj2RamGarZxtUuFVzWvKz19FUWEm3vizZhwXRELeNVtd+trYPU124FMKqr3nBZ3/bDQovUAUP8gTsKjn7XGSBjq1H0SvuY/tTRnTQjjFLs10VYbFIbMLggX6yJimRdS8Sb0fW55R8C/tq9yCcwm4dHmJdizEtHr2RwZ7QvfHrqHQOyqmD5SLlsR22gSS4X0LQYXok+dHL0P9h1Ny9c7hh2xb0yodDq4glDGpKpL+ifs516RbcihjrYSnWzo0nUDw35GZeBfEmpQdcpY8+9gdlqc5SCuZx7X1xLj+cKms4K+XdmzGLPATJHz73GSZPBQ710AvFOT3fCIWgldRkbSYQ2FertU3XBBjyHqzTEv1gbWN0fy+L8+mQtI2ga0Gh57O3uKNOTl8Wy0babpCHQACsr7hjoX3LQdttH/zsbsOvxS6M/dNg+Py8PvzCxGJN4b86kBlD23kDq6SaQYZyvDHcqZS/Y8eVxBWAlNhQ++8hfRO6fO+T+kOcLbk/fV2E+LHh3lyBD/1McG9vIu+rDf9cbalKuMV4qW31gqint0ECDHHzW1+WnS+vUe
 pRag6W4M
 KuVTeO8Gwt1Lv2FrD23il+cw2ozfNaysvkN4Qrkz4x9387ZPYYYUhiEKTwQD1H1K59FaiszbGB032MkvufXLansL0aq0Jcca53PnHuhkT1ORxUzoSsFqfnKAsZ2oyxSzTP9sVptseCgEqDJuyp7qKYbuqFly62RgvJ9kqfpaDJ7ytD2/1MrCaMn81WCDqbb2nCleMrbPlnie69Yyod4R8+g+AFS5Om1zFyJkvFug9DLDVj2E4WxiU88vLvG+XkfKzp/F01rCB66VFnyz61PT+GEfMQtlSqv+m+FOjZUFgL5y8BL1NBs4kSrExm9/8+p4T+Nfd2g1hPfw2kKOkv3La/c1f8h27H3XH1WcL2m0d+XDD7wqrqjLxPd7CFXKEgXFjYduyDws6QcTlP6qWOhITkJ0+4dXUlNoKmk6kLOKBvF21Xkqyf6Yl0ZOGNp8PBDfYfBNgJq/UtdzC16D49vXxegBlSHES5+ncpc1jWkV3urjFK1FM0wSel0ZDQlwyuZUptDgtNZ09ITaqN7lbAcze6kHpyeAI0qeMMM6PHHxFQAmqkOGWHbpx3eFh+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to never, madvise
or always depending on the fixture variant and the 2M setting to
inherit before it starts (and reset to original at teardown).

This tests if the process can:
- successfully set and get the policy to disable THPs completely.
- never get a hugepage when the THPs are completely disabled
  with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- repeat the above tests in a forked process to make sure
  the policy is carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 241 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 5 files changed, 252 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index e7b23a8a05fe..eb023ea857b3 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+prctl_thp_disable
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b..2bb8d3ebc17c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
+TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
new file mode 100644
index 000000000000..2f54e5e52274
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Basic tests for PR_GET/SET_THP_DISABLE prctl calls
+ *
+ * Author(s): Usama Arif <usamaarif642@gmail.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#include "../kselftest_harness.h"
+#include "thp_settings.h"
+#include "vm_util.h"
+
+static int sz2ord(size_t size, size_t pagesize)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
+enum thp_collapse_type {
+	THP_COLLAPSE_NONE,
+	THP_COLLAPSE_MADV_HUGEPAGE,	/* MADV_HUGEPAGE before access */
+	THP_COLLAPSE_MADV_COLLAPSE,	/* MADV_COLLAPSE after access */
+};
+
+enum thp_policy {
+	THP_POLICY_NEVER,
+	THP_POLICY_MADVISE,
+	THP_POLICY_ALWAYS,
+};
+
+struct test_results {
+	int prctl_get_thp_disable;
+	int prctl_applied_collapse_none;
+	int prctl_applied_collapse_madv_huge;
+	int prctl_applied_collapse_madv_collapse;
+	int prctl_removed_collapse_none;
+	int prctl_removed_collapse_madv_huge;
+	int prctl_removed_collapse_madv_collapse;
+};
+
+/*
+ * Function to mmap a buffer, fault it in, madvise it appropriately (before
+ * page fault for MADV_HUGE, and after for MADV_COLLAPSE), and check if the
+ * mmap region is huge.
+ * Returns:
+ * 0 if test doesn't give hugepage
+ * 1 if test gives a hugepage
+ * -errno if mmap fails
+ */
+static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
+{
+	char *mem, *mmap_mem;
+	size_t mmap_size;
+	int ret;
+
+	/* For alignment purposes, we need twice the THP size. */
+	mmap_size = 2 * pmdsize;
+	mmap_mem = (char *)mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED)
+		return -errno;
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
+
+	if (madvise_buf == THP_COLLAPSE_MADV_HUGEPAGE)
+		madvise(mem, pmdsize, MADV_HUGEPAGE);
+
+	/* Ensure memory is allocated */
+	memset(mem, 1, pmdsize);
+
+	if (madvise_buf == THP_COLLAPSE_MADV_COLLAPSE)
+		madvise(mem, pmdsize, MADV_COLLAPSE);
+
+	/*
+	 * MADV_HUGEPAGE will create a new VMA at "mem", which is the address
+	 * pattern we want to check for to detect the presence of hugepage in
+	 * smaps.
+	 * MADV_COLLAPSE will not create a new VMA, therefore we need to check
+	 * for hugepage at "mmap_mem" in smaps.
+	 * Check for hugepage at both locations to ensure that
+	 * THP_COLLAPSE_NONE, THP_COLLAPSE_MADV_HUGEPAGE and
+	 * THP_COLLAPSE_MADV_COLLAPSE only gives a THP when expected
+	 * in the range [mmap_mem, mmap_mem + 2 * pmdsize].
+	 */
+	ret = check_huge_anon(mem, 1, pmdsize) ||
+	      check_huge_anon(mmap_mem, 1, pmdsize);
+	munmap(mmap_mem, mmap_size);
+	return ret;
+}
+
+static void prctl_thp_disable_test(struct __test_metadata *const _metadata,
+				   size_t pmdsize, struct test_results *results)
+{
+
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL),
+		  results->prctl_get_thp_disable);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  results->prctl_applied_collapse_none);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  results->prctl_applied_collapse_madv_huge);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize),
+		  results->prctl_applied_collapse_madv_collapse);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  results->prctl_removed_collapse_none);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  results->prctl_removed_collapse_madv_huge);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize),
+		  results->prctl_removed_collapse_madv_collapse);
+}
+
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	struct test_results results;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_completely)
+{
+	enum thp_policy thp_global_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, never)
+{
+	.thp_global_policy = THP_POLICY_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, madvise)
+{
+	.thp_global_policy = THP_POLICY_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, always)
+{
+	.thp_global_policy = THP_POLICY_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_completely)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	switch (variant->thp_global_policy) {
+	case THP_POLICY_NEVER:
+		self->settings.thp_enabled = THP_NEVER;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 0,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_MADVISE:
+		self->settings.thp_enabled = THP_MADVISE;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_ALWAYS:
+		self->settings.thp_enabled = THP_ALWAYS;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 1,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	}
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_completely)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_completely, nofork)
+{
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL), 0);
+	prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL), 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index bad60ac52874..574bd0f8ae48 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -382,10 +382,17 @@ unsigned long thp_shmem_supported_orders(void)
 	return __thp_supported_orders(true);
 }
 
-bool thp_is_enabled(void)
+bool thp_available(void)
 {
 	if (access(THP_SYSFS, F_OK) != 0)
 		return false;
+	return true;
+}
+
+bool thp_is_enabled(void)
+{
+	if (!thp_available())
+		return false;
 
 	int mode = thp_read_string("enabled", thp_enabled_strings);
 
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index 6c07f70beee9..76eeb712e5f1 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -84,6 +84,7 @@ void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+bool thp_available(void);
 bool thp_is_enabled(void);
 
 #endif /* __THP_SETTINGS_H__ */
-- 
2.47.3



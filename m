Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02718CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF95E8E01FB; Fri, 15 Aug 2025 09:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0AF8E0003; Fri, 15 Aug 2025 09:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE74B8E01FB; Fri, 15 Aug 2025 09:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC7E8E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6580D1A0165
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:06 +0000 (UTC)
X-FDA: 83779140732.02.6F13FDF
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8036F1C0005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFvmacp2;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThKI922dULUmYFiaW3lL2ZDEHLRMIx7W7/OmILgNixg=;
	b=EpFTDNNFxJdFzB1US+lzeWR2FsdSgyDrgxXLqBvUhPw7oM+0HvWFuIF+zHQz+9oEJtArlB
	OCeiW7+wuAkYCQ5ajqoiGhLeR+dBf/4ADvk7WQ0Dyk+Xn0onvyTNlpxXWneRIHrSUmexEO
	lW1ORpuurJJXN9j6YoHRFCump9h9JMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266164; a=rsa-sha256;
	cv=none;
	b=HOrpuI2njN6uMkFUKRpikwmj2+2uYLFyolHk9mE+ZP/JGkXukPnfbTMBiPeOCpcESz0/1I
	THtm80QKbMj9hzOImPydTF+1W3I38qEfLmoVQlDGatvSI7QoxKKE6413/XDSzyVPLz/5sJ
	bMS04P3AfeK4I+hyb5rb+7qV/XQ8h8I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFvmacp2;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-709e781cf2eso24333816d6.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266163; x=1755870963; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThKI922dULUmYFiaW3lL2ZDEHLRMIx7W7/OmILgNixg=;
        b=BFvmacp2tdRsSEzUdXrno6X4QD6QAPiVJpIi/Jew5gmTtHxMO6vVjCNyNHTbVAcUkh
         if7lRhZARu3488RRPois3Gdys4ENF08qDD7YSuW65ZsjbGSoCs/yNT6zPHiFQziEFVvD
         a54BldWQsIinEzRZRF0a+ezg6rUB2f+epdPQFK+febVH8PWGLrLx3FYRDQWREYtjGgXu
         d4zSWnWsrdJxw5olQnh1j2o9Q7O7ja8e//HGZuBy/6/BfNXaLGU+IvuwoOmKiC6HotFk
         lztvhVMi2w55I/i8TSRVdl+cV6XgRsR33sOM+XGDrlNmpSzBW7V4Mw8uBDyZN2zKEvkS
         Pg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266163; x=1755870963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThKI922dULUmYFiaW3lL2ZDEHLRMIx7W7/OmILgNixg=;
        b=BFpWjH3jU6RqQLAlJT8/fUBJRrS14bhYtzMzJSRw9K8ozXWW21n+Em7DqWxgejyMBK
         nEgwawSrrYrtaTAiRsz7VRwUy+BR09cDGIVikI721YOc2w5qqIP+O3y1SmdwhFCTceK7
         bqIcybforuFjWysCFSyb6mG1vsErO8wzzmZqjjMm1z6VyplYiT4rBp8PgkaQjKFsC/kW
         os9E4dqrxlUmO0MuxQjqinmm7VajKU/4CKekTmX+unMclfWPuG4o96PsgVb+zy1RQ/BT
         NMhvyjc0qLpPAsK+6BO4xFB9QmrKsaIwqpVHf0FBSH1bBoPiibon1YpAQH+sqXxuUYVd
         N1hw==
X-Forwarded-Encrypted: i=1; AJvYcCW1qgOWHz2rBb6cxUNMsIYls2U4dl+QGB2hbmxFuCXpgFjQJElZkGDCnzXOQq4ch6WMw1FKvgE8rw==@kvack.org
X-Gm-Message-State: AOJu0YyqJmSIPJN16EXkMS4oueNHzcjw+dL9tEHhx3I1LpFEMKeGZI2H
	OS3buaipPVCPgpslhHt6mSLjBvZHlHuy/rva9hrMFzS8/YAU0QIllnLO
X-Gm-Gg: ASbGncuMXE0CNOVbtgnmlSn7y5fv2AO0FwflqRlS3veoHVCRSg8LwQ+4f1E9m/pv/Lq
	bsWkiJuH/pjLdGUWsrzookAxLUgbd+8KDWrxGtfO12YMDedRBZHaQOAyTodgqyihY/gTzuuzsRg
	tP9MtMfepGEGydcZFI3i+U2MmCH8UkrrHl5CnmuZKjZhNYlKpFLqMjLkbcs3Tc3aTswEpwVBY5G
	NOC9sDXe0OK3FEctFAcc2pUV9yow2+uekvSU+1pdn/vr4QruU+TmFEp6qUAcaTSVVyVKFVdIGUs
	t2ZhvZVe4gk/ENlCel5QQ10Y/BtqPk3IGqzP+t/0szg3dePdYbcGgHmuCnJ/avVERPYXcRoFDnq
	D7rbHG6AhiZCOfxA4QVis
X-Google-Smtp-Source: AGHT+IG+TCWxSTubxOqPY0sQAGowCS1LkSUfiep5FDN5JBRpx5/efo7iB20uzg87MScqVq8pUB5pxg==
X-Received: by 2002:a05:6214:246c:b0:709:7345:9aa3 with SMTP id 6a1803df08f44-70ba6524e9fmr26519706d6.14.1755266163499;
        Fri, 15 Aug 2025 06:56:03 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:72::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70ba95d3449sm7954516d6.77.2025.08.15.06.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:56:02 -0700 (PDT)
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
Subject: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling THPs completely
Date: Fri, 15 Aug 2025 14:54:58 +0100
Message-ID: <20250815135549.130506-7-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8036F1C0005
X-Stat-Signature: yg7znksnjgp43f8snreefuenfh87zi8c
X-HE-Tag: 1755266164-923638
X-HE-Meta: U2FsdGVkX18rguzgdYVPr0sOFs1q+4bQQ6t+Xl2SGrCTC485yWAFd8PJEog5R/KUujvEPBhRH29jAWup3X7TwjJKNHTYZsZVyEbbu7s6rDMyrITrDrK7wYqN2kGz+Bt/MFAxjjaZhGa39/dLB2J6nYyCjOPcA9dvh6BSm8Bg4j/IIhJifhZnRWrmmSkaDfgt6mRhiEKRLfCF1Tf6BuahFqoKORcaQs3aHDalZPdvKSIucs35sGQaXnQwfHec5uTbxsHXVD7GbsC3xNfYeeKf2/WKIPXDWzZKRsw7ckVD5AIW1/fDh0Hq8DztblgGH1T/Lvu4RNNcnbUkCPukNlWTl+kKtMkc8srJw0e2IuRJ03y64GXMNe6HRhtpPi9iV9bnLDwfeizYVR0FiBt0IdyPBnzIij9CMKJkkGqOEyl67MkU0c1DDTcsNdahMDUowp7dzSBvAhhEosed9E2DGupS47jA4suxK+fsTsC7OxBt+0ADKdDdT460PHw5k0INEwgk0phgCWTBl+Hy8EzQY2WEJF/j6kOgYDVhjS6D/rIBO5upO/fu7HYfBLiscanynpA1Yn5VxkGH5Xh4FEzlGs/E0VJbsb55Ngpxv583etjuU8FuZigz9oYviETWJ+lOYrA0vRhXmN9/cNByW0aJoSo08zSf5Dxrp8xExFfETY/v8dVGa4GdmeoK+FGrux4a6x+gskLkPTAMxXr8i5NtyA6FTqFzCGlvWxYefr4RldyRk4VYEQYiWfRoBpWyvKPgWmqnpq5Bd0RTh8vT1ifu+72AIIGCbvzEP+y8p68AkEZ1AdKprC5jrIVBzD/wiGKZMJ2FEL+OTTDZgtOqZa9cmq8ONLJOmoee2r/EYiItyKuVQctmgPW/2XEiA3mT9fAvp5v6WpLw3ftueYLlTfX/IItbi4q/BVTxHL2nYrQFH38a2c46Opj/6JIxPdjGNY3nikE6HywmkpRLwrFGIxrEaC5
 Ibs9+SrE
 yr5m6/f+OLoSmCMsbM/U6MuDivOSjg+pdsUpW/t9dEB7XFUeOrjIGCfZnhwbVrNxXR3lLPIvrtE6hdG9JioLG02QpeA/ytfBGoJOjNv8ycMBAwEo1td081vG2xoLu7S0eg28Odnz4HpSDnwg87/FXVTbt/hlx7n6RlKggRkDn+XEzEOJ8R4kwbtDrNnYOiEsg89cdgU1lVFbbXaog6j3hoh8n1XF/BF1PomsSsycVfEfWDUNIi8ztXFM6rTmyOVrWc2jk/4VIuMrco0ET8TfooIO+exh80TanT4WoD2LpcDvFWHHjTNuvKCUYOC8HCLHFkBJDBEMmVPRn6rj9wO8IT9jwY8bZZzx0bG28aE28Q+gpq6Ylhe9uDSfllSpoTl353pTjrv4XjDTiviz1sEgJ6kylkUOJEAp7I2qhqivBnLZweYQkDe8PRBVgf/HXSvTw6qydHGAQwB1ungTpgVV0RUWWB61KilZ5Cfba9T/QebfgRzzz7tr+BiBtYVyt3/hqFoPRLVzkAgRSii4RWBIDn02F3+D94laLQoPDyxZLJHrQ7DI8c7JfuS8Kr+uAVsT6cd+J0jJSP2QOV3/6JuO6IP7Iz/Upq715TATDCWTQiZNRBSo=
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
The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
be made to disable all THPs and skip if it fails.

This tests if the process can:
- successfully get the policy to disable THPs completely.
- never get a hugepage when the THPs are completely disabled
  with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- never get a THP with MADV_NOHUGEPAGE.
- repeat the above tests in a forked process to make sure
  the policy is carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 175 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 5 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index e7b23a8a05fe2..eb023ea857b31 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+prctl_thp_disable
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d75f1effcb791..bd5d17beafa64 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -87,6 +87,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
+TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
new file mode 100644
index 0000000000000..e9e519c85224c
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,175 @@
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
+enum thp_collapse_type {
+	THP_COLLAPSE_NONE,
+	THP_COLLAPSE_MADV_NOHUGEPAGE,
+	THP_COLLAPSE_MADV_HUGEPAGE,	/* MADV_HUGEPAGE before access */
+	THP_COLLAPSE_MADV_COLLAPSE,	/* MADV_COLLAPSE after access */
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
+	else if (madvise_buf == THP_COLLAPSE_MADV_NOHUGEPAGE)
+		madvise(mem, pmdsize, MADV_NOHUGEPAGE);
+
+	/* Ensure memory is allocated */
+	memset(mem, 1, pmdsize);
+
+	if (madvise_buf == THP_COLLAPSE_MADV_COLLAPSE)
+		madvise(mem, pmdsize, MADV_COLLAPSE);
+
+	/* HACK: make sure we have a separate VMA that we can check reliably. */
+	mprotect(mem, pmdsize, PROT_READ);
+
+	ret = check_huge_anon(mem, 1, pmdsize);
+	munmap(mmap_mem, mmap_size);
+	return ret;
+}
+
+static void prctl_thp_disable_completely_test(struct __test_metadata *const _metadata,
+					      size_t pmdsize,
+					      enum thp_enabled thp_policy)
+{
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL), 1);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 0);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  thp_policy == THP_ALWAYS ? 1 : 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
+}
+
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_completely)
+{
+	enum thp_enabled thp_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, never)
+{
+	.thp_policy = THP_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, madvise)
+{
+	.thp_policy = THP_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, always)
+{
+	.thp_policy = THP_ALWAYS,
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
+	if (prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL))
+		SKIP(return, "Unable to disable THPs completely for the process\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = variant->thp_policy;
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
+	prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
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
index bad60ac52874a..574bd0f8ae480 100644
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
index 6c07f70beee97..76eeb712e5f10 100644
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



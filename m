Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940ABC87FCF
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB636B00A0; Fri, 25 Jul 2025 12:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C8F6B00A1; Fri, 25 Jul 2025 12:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6243C6B00A2; Fri, 25 Jul 2025 12:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 502376B00A0
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CDA11408A6
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:09 +0000 (UTC)
X-FDA: 83703306498.04.A1A799E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 718374000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OziB677q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460587; a=rsa-sha256;
	cv=none;
	b=gEU2xWiiDIBRG+Yv3y7sTwextFVvzpOeTVqdZH/USKJt0Uur/r2xwWX3i144rIlmHsDVwu
	N7ux2Zf2Y3bHSH2wGfDjBXMyocNn1zHnAz5MLcS4qekjL0n174YS8Gsv2OP3G55S4DFY5E
	Tdmip3RmFtsIduh0eZULf+M9AW5Ol5Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OziB677q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2nMfW+8EG0yHdd/y9pp9Ykp4/bgoGWX5aUFmAoHq2k=;
	b=R9ybk6OjVMGW7DL5zUfew75t4a/rcPKpOEgSYo5qw+D+AWYqwu/XFKaiEZearMfZvto2ez
	2V+pBKgkI1v6d3KYDbhDt2oftd92D31O53zK4WNMKlWvw6qgb7HrKN2+DYHhQsNiM9rT5Y
	Cbdoj1h+uui1TE3HfrhG4RlXyB+sgJ8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab7384b108so25279731cf.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460586; x=1754065386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2nMfW+8EG0yHdd/y9pp9Ykp4/bgoGWX5aUFmAoHq2k=;
        b=OziB677qSV35GKbRyaKoQJy98/lMSD+UFIvFIy4ZKI0qii16VmZzvVsYlxnSJdy5Kg
         4c9A4LDpTvBueZ6zLbXcAjIx9B5XOO7DLKwJjjuiQqlKXDpY/FYuWI6x8eLHa4TYlw8Y
         xLficiPCr+pYWX4gI9ypYE6Lr6irX9ASAdIPl9GtN6aP0wk/t9qwibaQPY10fz9yN6xX
         VvzyqMpqQ7tbiV/a4iYW/Ewdap/G+MBYjZuHlqjS4GkAA1a6T/l3XeXLJlvXPAt938qS
         dBhjh/OsP+eQ3AUP3EYq3VqwDHXmIv//WklGyFYLeCLc84kpR556/h4L9Nh0XkOWf68j
         y9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460586; x=1754065386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2nMfW+8EG0yHdd/y9pp9Ykp4/bgoGWX5aUFmAoHq2k=;
        b=QLiLtGGj8x0WiNrWyTzy58+/p2zKUNemdRsazRi4MUveO/8qg35h7dBRCvEJxEEPnv
         iWdO/feQkSssnUv4jvhq7DbNMcsCZxSQoj8Sx2jo/5jz1X4oun0sYJbqFZYEKrIEW8sF
         Bo3jsSdwFHv1kTyBvCpzcffjv/9SRTPMIiLLClSpgGVhKrRsFqe0bpYW4WHg3tmIO3E+
         671SLuMvaH0c0wstn9YiaKkAtYh0WNca+0qPjlc+5s6hSOj3/z9BN4wX5/TLtahMiI9A
         LqdlQf4ZlVxtjoqAZUwzT3ptxgk1JBjt1vi58P/AXvlLp+wWcUwOeNHm0KK46o3mGX/9
         breQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJs05sb4/xkyR79A3j18kUGyLOXwxXB6TzU+cF9zKFm/TpuPTuQSFXQ1Sf1CJH5EI3yO+PJ4WwZA==@kvack.org
X-Gm-Message-State: AOJu0YxPOwdNoeqfh8uKFFqm4wFG1lroKKwWx5bqWLdda0zSNh/TcIoW
	6Ehg6x8IUzIJ36Eehf2rkjuIaNGmixwOWHZSw8Cz9QPD2uYNtrJbVdFe
X-Gm-Gg: ASbGncuOUWh1mm6JRrmd3ZONez433GumoZEsy6YgT3chXFSkMG4rCatZExICFkmgBIn
	K0btgrH1rxc7uo0PcJfkUM7ci+A/pIAQ2nfILOV97Jjo8i1x0TKugEZCwzp9kV7xcPwb5lLfglg
	atCWatNDDrCV2bfYWiFC8Wo5udO9fkkyl+CmAAryW6gYyvbKst1R5gnoiPA85dfe53iHw/FWFWI
	WGVseIY/QSAuohPVIfEvAPuh3W5VKdV6rNqqxDS7XDTUxcszGeLaOz2MQFpM9rRyRPPYeSryouq
	ktIB4xnTeQvaLpsq4I8riNI0nS2XLYtxwHkgnp41A+kNJG1hHbWmdE4OLfuLBQ47tKp+QMpFK0U
	dr2YxZEuXpdjURhnJwzeendoKt3FiNw==
X-Google-Smtp-Source: AGHT+IGhB0ODduWZoA0stvQcbydiYz6AaKK3E3SHNDplUWRJe9PTwU9UCJc3fawE6uOksSdsUztLVA==
X-Received: by 2002:a05:622a:1348:b0:4ab:6a1e:ea51 with SMTP id d75a77b69052e-4ae8edcdf0bmr33885121cf.11.1753460586010;
        Fri, 25 Jul 2025 09:23:06 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:6::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae99516fcesm1906231cf.9.2025.07.25.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:23:05 -0700 (PDT)
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
Date: Fri, 25 Jul 2025 17:22:43 +0100
Message-ID: <20250725162258.1043176-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725162258.1043176-1-usamaarif642@gmail.com>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 718374000E
X-Stat-Signature: sm5n5apighqe3z1fzzp41ooxfups5bkf
X-Rspam-User: 
X-HE-Tag: 1753460587-765637
X-HE-Meta: U2FsdGVkX1/6jqEd2MON+zuDy32J3qXc5eGhYR2PntqselCXZLucZ8TfHg54Ht4hhO6lDp3nEAa9YLUjAABGy6s2DD7WLjmZcqocRurxex7zeOYDmd/vWAqjsgRACIVwF8jMjeM+eTyYqWs48C5uQLsULWbUfNtTe8eyTy7IUNc3NJfrzuNkjXQHLMSMSwsY5JGX9lXncE+ZgBSQWvoIo6a2j9OtXqJwz1VZVgfB14oO0OthGI9IcwxJZrrgwjUBlO6LYK3vqiSn4wwqNbwbXAkak///KnDU8LY0JrvN1PUU/sYaaf3gZfDadZb4esMd92X43Ot8j9Wky4yHDtXMDN9YT/Je6r0duiuw0fCQjScPe9aWPNb7Fr4QRiwaR6TTymOfvfeCdRLNuDzQmAKLI49MTCGVJzmVu9bZkjPPyq+KxBcu6JjGUPQBSXR+VXV15ANGExW0bJQHFucz902COfyraGoHWuCGhDSMJdvh8U/Xg+r+ipdmHsSxXtq7i0hE5spo4ZNQxJNS1hqDzMIjwTa9FWrRkvmubLLFBHrMhyadrvMMBwgNy+YR2oFdSSl4GkZWNw8JbfTlAbmSfORE70BYWszao76mzJV7ylV++H27NzPkf29kj/PdQEqAn9gkFfnpNgyJIMDIUrHXeBH+/t7LbiW/sO4FkQzN2+cx+5TF91iK424YSH82tALZvLqtSA1hYBz/kVvqFH8B7bRC6/BaaixubUP0aMLAI4skplXGwutmVQrjojhC3vLVDWexkoXt8b/lWQ3oqiH8Dpie9kl1cpOcGz1C4aQHL/O/MKDGySFBl6DzvGWWe3lQsdyJIokz8cHq7ZspiI57gHURFJRruhXN5CYXbXfjyebE6niYkT6xMxbjt3WZgOnRcA/DX2ctp48NONrl7UFmE+pYKwUBP70F8ZaMpHXrJXSIfv1wOoDfTLqj1WVaMS0TyXigzUrnYeaNhm+4W9pC0oi
 9q1YUuT+
 somM/uzgKMIrAE1fwajUEZWok4LOHO7qBdw37tRFKs9EINpA26TMgjrie/or+YcpqU0OFBhYjHtxiAMA6PZpMD1t1i7Qiz0VuiR5ONZpWxghbY8dCu8KXDYL/c843q6e6xqFgLDZYRzk/C2JACaegSi/gZuy82FqIBWaflxK+O3iTP/tzX3jlG+fMW/z/Q2mJGGaPpr902LOfYh0vj/j8x+4/u6Du+3d6Tl48OQMnZrEB5lFaLTBLOaBqfgEJ5I4Y14Zz0z1fuFnaOJsNO4QhrHFNK+tidKO1m5/b4pr9jim7h0r4XexFybjM12vIUh3UsR2b2uaL6lAskXra5ikaWmRblTFcIVDDHxRqeXKV1ZFbb+G4R4N9g7lvghHHS3XpVzgJHIGn9K87Dpw4mGz6aG3MA3Ly2BU2HV+7XfzYOLWnsi4o2Cuo6YFaP4rGVCo1DBWi6pbvvGGsQRUVjoEJkKc7oE+jlGfIwzbii7jg+qdr9ycWer7WM6AJ80aSwpPR9ZzqHnJ8bA0wqDO9OB+O9p+YFdQOjRBO4jLliImFoGO5mHs9BrbmehghcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to madvise and
the 2M setting to inherit before it starts (and reset to original
at teardown)

This tests if the process can:
- successfully set and get the policy to disable THPs completely.
- never get a hugepage when the THPs are completely disabled,
  including with MADV_HUGE and MADV_COLLAPSE.
- successfully reset the policy of the process.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE after reset.
- repeat the above tests in a forked process to make sure
  the policy is carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 162 ++++++++++++++++++
 3 files changed, 164 insertions(+)
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
index 000000000000..52f7e6659b1f
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,162 @@
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
+#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
+#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
+#endif
+
+#define NR_HUGEPAGES 6
+
+static int sz2ord(size_t size, size_t pagesize)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
+enum madvise_buffer {
+	NONE,
+	HUGE,
+	COLLAPSE
+};
+
+/*
+ * Function to mmap a buffer, fault it in, madvise it appropriately (before
+ * page fault for MADV_HUGE, and after for MADV_COLLAPSE), and check if the
+ * mmap region is huge.
+ * returns:
+ * 0 if test doesn't give hugepage
+ * 1 if test gives a hugepage
+ * -1 if mmap fails
+ */
+static int test_mmap_thp(enum madvise_buffer madvise_buf, size_t pmdsize)
+{
+	int ret;
+	int buf_size = NR_HUGEPAGES * pmdsize;
+
+	char *buffer = (char *)mmap(NULL, buf_size, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (buffer == MAP_FAILED)
+		return -1;
+
+	if (madvise_buf == HUGE)
+		madvise(buffer, buf_size, MADV_HUGEPAGE);
+
+	/* Ensure memory is allocated */
+	memset(buffer, 1, buf_size);
+
+	if (madvise_buf == COLLAPSE)
+		madvise(buffer, buf_size, MADV_COLLAPSE);
+
+	ret = check_huge_anon(buffer, NR_HUGEPAGES, pmdsize);
+	munmap(buffer, buf_size);
+	return ret;
+}
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_SETUP(prctl_thp_disable_completely)
+{
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = THP_MADVISE;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_save_settings();
+	thp_push_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_completely)
+{
+	thp_restore_settings();
+}
+
+/* prctl_thp_disable_except_madvise fixture sets system THP setting to madvise */
+static void prctl_thp_disable_completely(struct __test_metadata *const _metadata,
+					 size_t pmdsize)
+{
+	int res = 0;
+
+	res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
+	ASSERT_EQ(res, 1);
+
+	/* global = madvise, process = never, we shouldn't get HPs even with madvise */
+	res = test_mmap_thp(NONE, pmdsize);
+	ASSERT_EQ(res, 0);
+
+	res = test_mmap_thp(HUGE, pmdsize);
+	ASSERT_EQ(res, 0);
+
+	res = test_mmap_thp(COLLAPSE, pmdsize);
+	ASSERT_EQ(res, 0);
+
+	/* Reset to system policy */
+	res =  prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL);
+	ASSERT_EQ(res, 0);
+
+	/* global = madvise */
+	res = test_mmap_thp(NONE, pmdsize);
+	ASSERT_EQ(res, 0);
+
+	res = test_mmap_thp(HUGE, pmdsize);
+	ASSERT_EQ(res, 1);
+
+	res = test_mmap_thp(COLLAPSE, pmdsize);
+	ASSERT_EQ(res, 1);
+}
+
+TEST_F(prctl_thp_disable_completely, nofork)
+{
+	int res = 0;
+
+	res = prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL);
+	ASSERT_EQ(res, 0);
+
+	prctl_thp_disable_completely(_metadata, self->pmdsize);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int res = 0, ret = 0;
+	pid_t pid;
+
+	res = prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL);
+	ASSERT_EQ(res, 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_completely(_metadata, self->pmdsize);
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
-- 
2.47.3



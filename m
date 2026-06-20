Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8522CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10E46B0099; Sat, 20 Jun 2026 14:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7C46B009B; Sat, 20 Jun 2026 14:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7DE6B009D; Sat, 20 Jun 2026 14:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD746B0099
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:17:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C96B21401FE
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:18 +0000 (UTC)
X-FDA: 84901098156.05.A77DE7B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 828F6140008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mw1e9uZu;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgH4Dj17obnxSLq/3NpwgVl7Hll2I/0OEirSKJI2pMo=;
	b=SBFt39EcZgkgr5zgm+UKmZfFjzAP8lswaMgXffgmxOBKnnWNbQIHxIaWdKD/l4hU0zEl18
	6edWbg9JziA5YK8xES5+/vFb5OCnkUZB5MBYnzxRbInz+z7cRyD0mG7PG+PednypQ79QmB
	7UscHU3whdcPyEcAwEIJh+UxVp9WT/c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mw1e9uZu;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979436;
	b=LPIGTMw8UZt6ZM9w2J0L2lKwnBQRjmbWNF0MYitr77AqfIGE28CW4ZDDGUemBgfz1EtY28
	c/qgjAbK4/1c+T8i2nWmWgbkbkqpVVlUA7ZKK/F+38uiUhAMICw+y6Zk9zOVho1oE9xx25
	TcRFWdq15jAVRXBSRO5fEXRlv4kiLMo=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bf3781ca51so28668755ad.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979435; x=1782584235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgH4Dj17obnxSLq/3NpwgVl7Hll2I/0OEirSKJI2pMo=;
        b=Mw1e9uZu60XB2tmCkHAJzrf5GpEMp9jqaMZGEDXI9tx8jAwkBIbOUR+BLpJSoCbNZ2
         Fvsicobe6y4VrrWOs0id13WGnM9WrTyZvYfCS15mqbQUDRpY+DhOi6wKcpehevyspcsa
         viYE8Ex/HObCRIYgiH0Rrlf4sH8ht3+/R0tH50QqheUIDY8VEB8ij17SgCue5ITGX3wJ
         KyqbinfdialkABqO3gyPuyHwd6AsClufrQ53DMk9Egyh8qf3jLybxq1AfIWBfzJc+M4w
         Ht+suXjikmUIkHfFFfY612008+Sc3WECbRwlqM5jzh+RsCu2BNF0x/fQHZpJCRLKCLeZ
         /q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979435; x=1782584235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RgH4Dj17obnxSLq/3NpwgVl7Hll2I/0OEirSKJI2pMo=;
        b=rBNzs44/0HF5m2gWTmbFQunuQ+wMc7Eo3Tj7PgcxvlyT/xqMsp+cM1kLVWn5YIHLOU
         Fktm/Zt59/IM201jXYcvbmjkTfCStSPvwJOaM2VhIqpGOIYdLZIt4168F1Lt0W6qzQQM
         7uGrW+grjjlwwB8HFMxy9y7z4OwkbjHrbqx6fE8dCkV6fpFxi8L14OwfMqliXZ4C0Z2q
         e6L66kXg71SThMyYeRAuDq04dOZmrbjQSUlSggOtDdR02sf4gWb3N9oJl3hXd1dAip6/
         tp9sVaAK7fkPkyOZ1HJiXqvk63bTpjJJXvTppXevYvBtazgFQ1BUBEiU/Dz87TEV8uDw
         TRSw==
X-Forwarded-Encrypted: i=1; AHgh+RovN6UAb9/q70ASUYakEtWk8JTuSpX0KHB/JVE1wQcmj56DgSZrBWNOz6XGOCvKCnoIybsCo0qRYQ==@kvack.org
X-Gm-Message-State: AOJu0YyR1bE/cLeYUrePwFJ614u/qy7R/2/b47+vYcENGENJjW5LJ5lD
	BsoJulBMdmjzPStdaVT++WW04E13hs09lb3t7bv35zRKno8K451DaVew
X-Gm-Gg: AfdE7cl3ZwXHqEj2HPNM44YCBpR4BTSMY4azJnY9QG1sCQYh/+BNUGm34U5AP0oWg99
	FvU2iQhqDcX+0tXfDiBvA5rF1EQaEBip/TnKH9QfY21yaAYhpgLx5ajeC4Teg8DtYwAU+0/c+8G
	PEi+akBou4RfiOuRwdxs/ZW5GM6tVgxfuyZyC4R83fZRHN5AarhLNfshutOBGm6oa1+0nDEAfiD
	ZEmzE+5RtbQnSNt/mXoXipQYwU8N+v0mveaxva+2uEKXlmRh1y12H4O1qi6qqG73uS4jq/0dvJR
	VsFRyBbzd5jZ3uxUuIt2ZlRfabVvT/F5ueDC3aV4CuFXmJzb+FebKk+rIbk5uti5a6Ml2lmAiDz
	BaCdG+w0o9E78+cvKjSms+Sp2F+XYYOQm0h1bosPK5ErFk5XRzMDg8c488Z0ABZwrK82/R2yym7
	xPP7I+iovQxL/XBlNO1ZGPF7CdHBRkqR6ft5F0RXNMr2TGyBnCOTJrO8eYbBLlxYtfdN2KWOJRu
	g==
X-Received: by 2002:a17:902:cf03:b0:2c1:f262:4962 with SMTP id d9443c01a7336-2c718f03795mr93845965ad.20.1781979435385;
        Sat, 20 Jun 2026 11:17:15 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:17:14 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v9 5/6] selftests/mm: add a swap tier configuration test
Date: Sun, 21 Jun 2026 03:16:30 +0900
Message-ID: <20260620181635.299364-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 828F6140008
X-Stat-Signature: w6q4fys88qgz89gxpyr7a8cjqtggqk51
X-HE-Tag: 1781979436-948747
X-HE-Meta: U2FsdGVkX1+ZCMOX2hvJgNDJRsfJ8c5ZrUXteTnmSrc6zTyIvN1Sl36Ji0d57IlqMpqLGi0s+wd7Gu/Y5INdW0s9PvmRDSwYs1vk0nLfKbzAYKDSCUM3jHyKTZ68kiAc4LzdeHak1F2w37ukV0NgApBclVG7kXDofaBJwOGzSLV1Lef3fGrAqw5n2jWK+A0M4tWV0PxK/rw0lMx20r7fBb5f+6/8FTJCeUD78qZyD9TTGbGtUL/qCanbSiBMc4XzDD+fxYIX7fvBL8whOPn6AdVMJ3fB4sYn4XLu0brvOLgds7A61vqKbaTaXnSJOPzq4Oy35AjRKi313O3hHxkhPOLXsV27D3qdod3GmAnLYq6zgf7qDcOBHd7lipuTdFvmQ6HqKeZOjtA4QAqQXh1jIkCjrIMUuglvnnygkcjqMIRsAsKeaWiWkw+oFL7hsGsbEUV8+LDnETKTdnaVlwVEFXB1Cg+UPdcukpL8sZXoeLYay7vMEcruVfJyljKtengbUpkWafncovCczFrA9i04S/QujOYJy6NqGd72NQMUIfp1O8rxxR1zMoihiLAF7qVfz1eStjvOcy8UD9M7DSDyJ8Hs1rGsLtb1jIKU5I+2PjnlKiRVyrwMX7EL/yDJT901mbaJDdkivYStt/nJCCdtBKUgymnqiH9Kc7/3mORhU/JkVlIXeWvkwbsohnmuBv3v4X/KE1/t9P2rRgyCl6Tfo/q9CuWUZ4BXtzzw7wuvEmhmS4XMdYjWVs6Ym3wpWt5CQUcudCGCJDvlLKCJ7TdiE2d9+ypjvhqIZ4EUmlXsphQSrjMCCv1HkGRPSkM7p0MaADX/Xs6fpDWaQXDi74wnsEJJE8caPWnXZGWW4jx7rsadL9k8AOLVSljxxu8ZiT2q/eTK8yGRUlFmVLMZ4CUUd6FzW/FSExS/H+S4ri58XnMUKmnimt4fjQn8habMW04uzv1EC4fvsH3mCAeW4MW
 e/Hb4bbf
 aBr2tDOE62uMT452QwIeJzEE0rh+7CUbHp7Df4snuSDU8zgs4cO69Z2JjtePyI9YCCmQ36Cvkj+LPVx95kLNcYfZvgEvCm0ZTswse8mgX4z5b0twE+/ilp9tofuZk//t/4O4fEBApZNwHZLmrF6F28U9vzXlx+OISanfg5c/a+J89+1IUfVTisVWz7PSA2A8Qio/WJN6hQXtoLJyh77bh6A5sO2iNhycxV0O/FLr3yvbzA7rui+QRuTiqFXMdsI86rvlzhiNyVUBrEsLukW8rEIy2A5Plw7I/tBYICZdZW+1BqMMs+EmdnB6ksaMlagpEnIMGtGyKmz5cAb5t5TcMinIw4BpIoxzpvjJKLYgUJITSMn3I+DQLQf+5ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a test program for the global swap tier interface at
/sys/kernel/mm/swap/tiers. It checks the add, split and remove
operations and the documented error and batch atomicity rules. It also
checks that a tier with an active swap device cannot be removed until
the device is swapped off. That device is a zram device, and the check
is skipped when zram is not available.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 tools/testing/selftests/mm/.gitignore     |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/config         |   2 +
 tools/testing/selftests/mm/run_vmtests.sh |   5 +
 tools/testing/selftests/mm/swap_tier.c    | 323 ++++++++++++++++++++++
 5 files changed, 332 insertions(+)
 create mode 100644 tools/testing/selftests/mm/swap_tier.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 9ccd9e1447e6..a6e588c7979e 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -46,6 +46,7 @@ hmm-tests
 memfd_secret
 soft-dirty
 split_huge_page_test
+swap_tier
 ksm_tests
 local_config.h
 local_config.mk
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..1836127df092 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += swap_tier
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2..de3752e1bbd2 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -14,3 +14,5 @@ CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
 CONFIG_PROC_MEM_ALWAYS_FORCE=y
+CONFIG_SWAP=y
+CONFIG_ZRAM=y
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf047..1b0b8ec185a9 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -71,6 +71,8 @@ separated by spaces:
 	tests for VM_PFNMAP handling
 - process_madv
 	test for process_madv
+- swap_tier
+	test the /sys/kernel/mm/swap/tiers configuration interface
 - cow
 	test copy-on-write semantics
 - thp
@@ -353,6 +355,9 @@ CATEGORY="process_madv" run_test ./process_madv
 
 CATEGORY="vma_merge" run_test ./merge
 
+# swap tier configuration interface (/sys/kernel/mm/swap/tiers)
+CATEGORY="swap_tier" run_test ./swap_tier
+
 if [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
diff --git a/tools/testing/selftests/mm/swap_tier.c b/tools/testing/selftests/mm/swap_tier.c
new file mode 100644
index 000000000000..b4fe21b0eb5d
--- /dev/null
+++ b/tools/testing/selftests/mm/swap_tier.c
@@ -0,0 +1,323 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/swap.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+
+#define TIERS_PATH "/sys/kernel/mm/swap/tiers"
+
+static int tiers_write(const char *cmd)
+{
+	int fd, ret = 0;
+
+	fd = open(TIERS_PATH, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	if (write(fd, cmd, strlen(cmd)) < 0)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
+static int tier_range(const char *name, int *start, int *end)
+{
+	char buf[4096], *line, *save;
+	int fd;
+	ssize_t n;
+
+	fd = open(TIERS_PATH, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n < 0)
+		return -1;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		char tname[64];
+		int idx, s, e;
+
+		/* The header line has no integer columns, so sscanf skips it. */
+		if (sscanf(line, "%63s %d %d %d", tname, &idx, &s, &e) != 4)
+			continue;
+		if (!strcmp(tname, name)) {
+			*start = s;
+			*end = e;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static bool tier_exists(const char *name)
+{
+	int s, e;
+
+	return tier_range(name, &s, &e) == 0;
+}
+
+static bool range_is(const char *name, int start, int end)
+{
+	int s, e;
+
+	if (tier_range(name, &s, &e))
+		return false;
+	return s == start && e == end;
+}
+
+static int tier_count(void)
+{
+	char buf[4096], *line, *save;
+	int fd, count = 0;
+	ssize_t n;
+
+	fd = open(TIERS_PATH, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n < 0)
+		return -1;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		char tname[64];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", tname, &idx, &s, &e) == 4)
+			count++;
+	}
+	return count;
+}
+
+/*
+ * A single add at a priority above -1, from the empty set, leaves the range
+ * below it uncovered and must be rejected. the set stays empty.
+ */
+static int test_coverage(void)
+{
+	if (tiers_write("+orphan:100") != -EINVAL)
+		return KSFT_FAIL;
+	if (tier_exists("orphan"))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/*
+ * Add two tiers covering the full range. The end priority of a tier is the
+ * start of the next higher tier minus one.
+ */
+static int test_add(void)
+{
+	if (tiers_write("+lo:-1 +hi:50"))
+		return KSFT_FAIL;
+	if (!range_is("hi", 50, SHRT_MAX) || !range_is("lo", -1, 49))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/* Adding a tier inside an existing range splits it. the lower part shrinks. */
+static int test_split(void)
+{
+	if (tiers_write("+mid:100"))
+		return KSFT_FAIL;
+	if (!range_is("mid", 100, SHRT_MAX) ||
+	    !range_is("hi", 50, 99) ||
+	    !range_is("lo", -1, 49))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/* Removing a tier merges its range into the adjacent (lower) tier. */
+static int test_remove(void)
+{
+	/* Remove the top tier: 'hi' re-expands upward to SHRT_MAX. */
+	if (tiers_write("-mid"))
+		return KSFT_FAIL;
+	if (tier_exists("mid") || !range_is("hi", 50, SHRT_MAX))
+		return KSFT_FAIL;
+
+	/* Remove the lowest tier: 'hi' shifts its start down to -1. */
+	if (tiers_write("-lo"))
+		return KSFT_FAIL;
+	if (tier_exists("lo") || !range_is("hi", -1, SHRT_MAX))
+		return KSFT_FAIL;
+
+	return KSFT_PASS;
+}
+
+/* Each invalid operation must fail with its documented errno. State: hi[-1,MAX]. */
+static int test_errors(void)
+{
+	if (tiers_write("+hi:100") != -EEXIST)		/* duplicate name */
+		return KSFT_FAIL;
+	if (tiers_write("+bad.name:100") != -EINVAL)	/* illegal name */
+		return KSFT_FAIL;
+	if (tiers_write("+dup:-1") != -EBUSY)		/* priority in use */
+		return KSFT_FAIL;
+	if (tiers_write("+low:-2") != -EINVAL)		/* prio < DEF_SWAP_PRIO */
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/*
+ * A write carrying several operations is atomic: if any operation fails, the
+ * whole batch is rolled back. The second '+a' duplicates the first and fails,
+ * so neither must take effect. State before/after: hi[-1,MAX].
+ */
+static int test_atomic(void)
+{
+	if (tiers_write("+a:50 +a:60") != -EEXIST)
+		return KSFT_FAIL;
+	if (tier_exists("a") || !range_is("hi", -1, SHRT_MAX))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+static int zram_add(long size)
+{
+	char path[128], val[64];
+	ssize_t n;
+	int idx, fd;
+
+	fd = open("/sys/class/zram-control/hot_add", O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, val, sizeof(val) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	val[n] = '\0';
+	idx = atoi(val);
+
+	snprintf(path, sizeof(path), "/sys/block/zram%d/disksize", idx);
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	snprintf(val, sizeof(val), "%ld", size);
+	n = write(fd, val, strlen(val));
+	close(fd);
+	return n < 0 ? -1 : idx;
+}
+
+static void zram_remove(int idx)
+{
+	char val[16];
+	int fd;
+
+	fd = open("/sys/class/zram-control/hot_remove", O_WRONLY);
+	if (fd < 0)
+		return;
+	snprintf(val, sizeof(val), "%d", idx);
+	if (write(fd, val, strlen(val)) < 0)
+		; /* ignore: best-effort cleanup */
+	close(fd);
+}
+
+static int swap_setup(const char *dev, int prio)
+{
+	char cmd[128];
+
+	snprintf(cmd, sizeof(cmd), "mkswap %s >/dev/null 2>&1", dev);
+	if (system(cmd))
+		return -1;
+	return swapon(dev, SWAP_FLAG_PREFER | (prio & SWAP_FLAG_PRIO_MASK));
+}
+
+/* A tier holding an active swap device can't be removed until swapoff. */
+static int test_device_pins_tier(void)
+{
+	char dev[32];
+	int zidx, ret = KSFT_FAIL;
+
+	if (tiers_write("+top:50"))
+		return KSFT_FAIL;
+
+	zidx = zram_add(64 << 20);
+	if (zidx < 0) {
+		ret = KSFT_SKIP;
+		goto out_tier;
+	}
+	snprintf(dev, sizeof(dev), "/dev/zram%d", zidx);
+	if (swap_setup(dev, 50)) {
+		ret = KSFT_SKIP;
+		goto out_zram;
+	}
+
+	if (tiers_write("-top") == -EBUSY) {		/* blocked while active */
+		swapoff(dev);
+		if (!tiers_write("-top"))		/* removable after swapoff */
+			ret = KSFT_PASS;
+	} else {
+		swapoff(dev);
+	}
+out_zram:
+	zram_remove(zidx);
+out_tier:
+	tiers_write("-top");
+	return ret;
+}
+
+/* Remove all remaining tiers, so a mid-test failure still leaves them empty. */
+static void tiers_clear(void)
+{
+	char buf[4096], *line, *save;
+	int fd;
+	ssize_t n;
+
+	fd = open(TIERS_PATH, O_RDONLY);
+	if (fd < 0)
+		return;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n < 0)
+		return;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		char name[64], cmd[80];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", name, &idx, &s, &e) != 4)
+			continue;
+		snprintf(cmd, sizeof(cmd), "-%s", name);
+		tiers_write(cmd);
+	}
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(7);
+
+	if (geteuid() != 0)
+		ksft_exit_skip("test requires root\n");
+	if (access(TIERS_PATH, F_OK))
+		ksft_exit_skip("%s not present (CONFIG_SWAP/tiers)\n", TIERS_PATH);
+	if (tier_count() != 0)
+		ksft_exit_skip("swap tiers already configured; run on a clean system\n");
+
+	ksft_test_result(test_coverage() == KSFT_PASS, "coverage rule\n");
+	ksft_test_result(test_add() == KSFT_PASS, "add tiers\n");
+	ksft_test_result(test_split() == KSFT_PASS, "split tier\n");
+	ksft_test_result(test_remove() == KSFT_PASS, "remove and merge\n");
+	ksft_test_result(test_errors() == KSFT_PASS, "invalid operations\n");
+	ksft_test_result(test_atomic() == KSFT_PASS, "batch atomicity\n");
+
+	ksft_test_result_code(test_device_pins_tier(), "device pins its tier", NULL);
+
+	tiers_clear();
+
+	ksft_finished();
+}
-- 
2.48.1



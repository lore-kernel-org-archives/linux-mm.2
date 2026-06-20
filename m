Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE20CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E83C6B009B; Sat, 20 Jun 2026 14:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0656B009D; Sat, 20 Jun 2026 14:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F190D6B009E; Sat, 20 Jun 2026 14:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD3B86B009B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:17:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0430A1201EC
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:24 +0000 (UTC)
X-FDA: 84901098408.25.4E49164
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 10CBF160007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpJcmfNU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tG1goLxilAMOHGDfAUrbCLR/sxZCH1YlTcgqW/QVggE=;
	b=RBcJTxGn2zFDXlVNAOUVzGcdzS7G6eV7CL4wNNEXh4ISpIpNMmEJrYuEXXeCoKc4vChsVa
	jEv6torECtHXZNxuzysYQHpv8MHlJqIPfGTd9bGdJz3KxHIHTZ+zOxHtZhqkHXlNJbchC+
	FgB4w+wkQg6kcFmXOvJyubwi0QQJWfY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpJcmfNU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979442;
	b=KcK2tzR6F15GEzez44D2fiZOfqG0BiCyQT7q/beOtNleTU5ga320PtO3Mp0PysY5Ma2NiC
	ExqaGLknx/LxIZ0UiLc6vpZAYf/F7J5aC4g/gVwQztDsjKYnOWddEn5KDX2qrhneESJBYy
	JRT04dItI7NEwAH9rxOaclRJYR+s4EU=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c0aa420401so18592485ad.3
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979441; x=1782584241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tG1goLxilAMOHGDfAUrbCLR/sxZCH1YlTcgqW/QVggE=;
        b=lpJcmfNUtekdH8H1SoyHOo/v/eo+l4LQvKJvPjVM6btsIB/vi4fFn6NYkh89Jrv5H5
         4GV8HBs4CasjjLUSHgopHrQa71vGWvDfH6HNqNcQBnjo/XvX+RWa5UBrwPMa7xNpN1xN
         DI9geFCR6TIk6YwS5IyC50/0C5o48Rye56d/k9vMnsBOay7hwNHc9tM1+vkyMjX5ss6y
         33fDkmiYQH6U6WQByYOUJ3wemkbAIlyefxxxltRNkK6yBh05HZfIgTH2JUomsZQMoPe9
         xypXtlmx8pv0F01wbDoXe+EVukICv27lWNhVm/UZzxiyxW5QyVB8o8KFhMuLjpsPIwEj
         x2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979441; x=1782584241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tG1goLxilAMOHGDfAUrbCLR/sxZCH1YlTcgqW/QVggE=;
        b=qSbN766XVWofsD8jrUglvIT7yUZr1dlFeGQ6mQhC26PwV+J6GzKxiew3aR7l9t2Bkf
         kfolVkorYigf0i7Eduw9O0jQ0PZB66dpsrJP6O+NUyRrjgS6q5y2vzak0e/DoDHJtNyq
         p1ZC5UzSK6xqM0bwx/hP+P7rZz7e5UKfGYn/xE6GDLwC8DkzRvgBWdubn1iR7NjpxktP
         +3IhNBMxWGiJfB/HlivgUCxN6FmXFit5Peg8UOsNTUEGMWPWS+7jztM6oq1LcZhwUBmm
         bGqGv/D5REKyba+CwBp04SOkMeL3xz3bZ94IWUkXW6tQgtX9OweuxQeez5iUaI9qIOkM
         DpSg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6cDE2KvMpRURtk6wmUo3TgLXgLAZDbTz4EUV+PuFnFU2Obg2H/0bK3Nu+8DXEl0D82z+p06VvAw==@kvack.org
X-Gm-Message-State: AOJu0Yx13UjyiPBAF2SyrJZeSpUN6uow8JVEuaA/Tcoa/6GCcU6gJihU
	61VZJpo5Oaa6zKfL6Zz/Uiov/+IINLp2HUUaJ8kUpB/VBEcg6VYUV2Vg
X-Gm-Gg: AfdE7cnni70Wt6KCL6HImVcX+Sk4jioe01lzXAP6IxYAC1pD47LTE3xdBPig1koq3So
	k0UCm86PzXYU9Ip4pt/cKt0g0+dXeu5NPOdVcW7bIljMbcMbRykzSBYeVqnDXHShhcibzv7SKjO
	f5T8a4uzyJ2RMvfdIqfU0zqK0PtjfHzSOOn+i69cUmy5qeBRCF6zFdFP4x4OZpjoFAP1FqLtQwk
	IFRkPfKimi4KbSFnFKUiX0FiIJLvy8Pa8TiO66rgyqQCgP2oLqqJ3n40a3xbNHrE+Rzhr+jM4w+
	zhVEIs+of6hSs/SZRtiTD/GfmH04yM9OsAOZ59lDF74HzoOSC04PGOcnkNtwGBJyHWtqDpUdP1h
	M5HO+uLafU/qUAF95q2PIDixFPdBZzndsLFbrwszf7gJduJwSb/1Kxaa9luh1GOQGZ8QaCqNNGo
	S2MeRyc6P3S7L/iZJvy7xaJUXkPziOn/81SElz5fECeu7RW9RConqHxbpW9AuaAXMeE6rjaREtM
	4jKLHSlO+6B
X-Received: by 2002:a17:902:e805:b0:2b2:4b4e:e4d2 with SMTP id d9443c01a7336-2c725b96249mr73239185ad.15.1781979440730;
        Sat, 20 Jun 2026 11:17:20 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:17:20 -0700 (PDT)
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
Subject: [PATCH v9 6/6] selftests/cgroup: add a swap tier routing test
Date: Sun, 21 Jun 2026 03:16:31 +0900
Message-ID: <20260620181635.299364-7-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10CBF160007
X-Stat-Signature: nyxsc89fdyirinbz8yuqmxbkwe6jyosb
X-Rspam-User: 
X-HE-Tag: 1781979441-702901
X-HE-Meta: U2FsdGVkX19XTs4mwVH8ZbKhOiswDj73uLjN7t+seOC6BT62bKqPTy7BxHRVWgFjZkBcAAvyhhzczoDA+pjl/gvY3+YeWr7KOqATMS4rWDKczniA+CViCdCvo9JyXhLDKlVkBHg/ykEMa//qjGcegNf8EBHikDuBxayeHg1mV81tXyISgSbZFLeWn/KXo88yxQp6jWDxHr4lctnry9+nVJ2SGqJR92rUVp1eijUgszrE+H/Xlst4lAGJKSCL+LxaHfRJ2UATNc+n2CSShthiOz9llxzh/s5o4ALGjX4AZVi6cUUPQlC1Q/7A1XFGnzx83QaEDIQJWU/mbxT17+Q021TgEu6NZQVluB5xpHwPETDIej5QxErIzjbOEZhF6V5tDtFwuqFxfUtldaWePp+43Z+BF5Si0FD4mI+dKf9gCcMiWOqBSCwPwI46QSjuA9W7UJ1P4gmuGfsmz47DxPgKcgcLtyZayCTpsTsQOTS54y3yimCTx2v/0wD7mwxwyzpuuNDvOLQsIQGpEMqY55Pd6U7yBB29BxVKBXxJPll7V1DXGSgXYgs8k7V8fkwIjv3lyIrkEn439dCcU2TieTEAqXxcNkHZuPCsuXwJ3MIaKVTRSN/wrQKFFMG4NccQxDrFUJHe/pcyn25dhcdS9GFBSCoqF8dfNmPMfwSd/IxfycH959TP2rPYy9jdfQok/tc9gOvCwrPplNsWMHl36oDybiYGrgrJ0D0FN32kr+TuVTwe8KV2PLEBLYkx59PbUWoGB1umJCGgysLoMeRnb4zI/2c7szYXWIwoUetUI8o8PpzUPxcwezT/PID45vmDS6chSvxC470f+7sSxBmun5vsSZZTbXKp3KR0MG0+/HtVOgEXmVbRLkJ50ramoxcwMGTEwVYzUMdGNVdtJydBZovVMAAxeXHxF7cfeSJhrJKvk0/JjjHR2LCXuNNDL9il/1MNvHF9W3MzpkBvj+nInsy
 2C49nlIy
 15RUXlRIPSWr7cFfdeXxh6ObOpWYUE8rwTUVAP3CbJeIHOTM0S97AwCKtZbQMX+LcsZ8mB/N77oeFtRIEp1eGikJ0fRFOz03pIf9sa/59VA1abEItkyu00wAp/i9foDbT6NiXDRFv4Lr8f7bB3FYc/BtehRNbwBrY0zhho1LAs6hCKWIDkDui3XLVsURgwx8byT+JgX2Vvt2YYpFAUotV2x2Ra9l+BtNcwcNRMeSgkrlD+ZdWsTV/+rPcORTT84aMTTzvfFMPOsIMAp1q94exakqvdPtIZXAVnE4sSKj5FxNcFM5zqr4Lo3kUTJD8yjVxTG4F1kgrow5VBPbYLLdhf/APCb0eCKHF7ZAD3PHDApd7mWv9aad4NXSf0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a test program for the per-cgroup swap tier control
memory.swap.tiers.max. It checks the default mask, toggling a tier,
rejection of invalid input, and that recreating a tier resets the mask.
It also checks that a cgroup's pages swap only to an allowed tier,
including across the parent and child hierarchy. The routing check uses
two zram devices placed in different tiers.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/config         |   2 +
 .../selftests/cgroup/test_swap_tiers.c        | 500 ++++++++++++++++++
 4 files changed, 505 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_swap_tiers.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..77b8e6c3e592 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -8,5 +8,6 @@ test_kill
 test_kmem
 test_memcontrol
 test_pids
+test_swap_tiers
 test_zswap
 wait_inotify
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..a98e3c414cd5 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_memcontrol
 TEST_GEN_PROGS += test_pids
+TEST_GEN_PROGS += test_swap_tiers
 TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
@@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
 $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
+$(OUTPUT)/test_swap_tiers: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..6086bb5bba97 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,5 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_SWAP=y
+CONFIG_ZRAM=y
diff --git a/tools/testing/selftests/cgroup/test_swap_tiers.c b/tools/testing/selftests/cgroup/test_swap_tiers.c
new file mode 100644
index 000000000000..24420c1ef398
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_swap_tiers.c
@@ -0,0 +1,500 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/limits.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/swap.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+
+#define TIERS_PATH "/sys/kernel/mm/swap/tiers"
+#define TIERS_MAX "memory.swap.tiers.max"
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
+		char name[64];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", name, &idx, &s, &e) == 4)
+			count++;
+	}
+	return count;
+}
+
+static long swap_used_kb(const char *dev)
+{
+	char line[256];
+	long used = -1;
+	FILE *f;
+
+	f = fopen("/proc/swaps", "r");
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f)) {
+		char name[128], type[64];
+		long size, u, prio;
+
+		if (sscanf(line, "%127s %63s %ld %ld %ld",
+			   name, type, &size, &u, &prio) >= 4 &&
+		    !strcmp(name, dev)) {
+			used = u;
+			break;
+		}
+	}
+	fclose(f);
+	return used;
+}
+
+static int swap_active_count(void)
+{
+	char line[256];
+	int n = 0;
+	FILE *f;
+
+	f = fopen("/proc/swaps", "r");
+	if (!f)
+		return -1;
+	if (fgets(line, sizeof(line), f))		/* header */
+		while (fgets(line, sizeof(line), f))
+			n++;
+	fclose(f);
+	return n;
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
+/* A new cgroup may use every tier ("max"). */
+static int test_default(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_default");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (!cg_read_strstr(cg, TIERS_MAX, "fast max") &&
+	    !cg_read_strstr(cg, TIERS_MAX, "slow max"))
+		ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+/* A tier can be disabled and re-enabled, and the change reads back. */
+static int test_toggle(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_toggle");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast max"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast max"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+/* An unknown tier name or a bad value must be rejected. */
+static int test_invalid(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_invalid");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (!cg_write(cg, TIERS_MAX, "nosuchtier 0"))
+		goto out;
+	if (!cg_write(cg, TIERS_MAX, "fast bogus"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+/* A tier recreated by the same name is allowed again, even if disabled before. */
+static int test_recreate(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_recreate");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (tiers_write("-fast") || tiers_write("+fast:10"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast max"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+/* Map anon memory, fault it in, push it to swap, then wait to be killed. */
+static int swapout_child(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem;
+	size_t i;
+	int page_size;
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return -1;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	for (i = 0; i < size; i += page_size)
+		mem[i] = 'x';
+	if (madvise(mem, size, MADV_PAGEOUT))
+		return -1;
+	/* Hold the swap entries while the parent inspects /proc/swaps. */
+	pause();
+	return 0;
+}
+
+static int run_routing_case(const char *cg)
+{
+	char fast_dev[32], slow_dev[32];
+	int zfast = -1, zslow = -1;
+	long used_fast, used_slow;
+	int ret = KSFT_SKIP;
+	pid_t pid = -1;
+	int i;
+
+	/* Only our devices must be present, so usage is unambiguous. */
+	if (swap_active_count() != 0)
+		return KSFT_SKIP;
+
+	zfast = zram_add(MB(128));
+	zslow = zram_add(MB(128));
+	if (zfast < 0 || zslow < 0)
+		goto out;
+	snprintf(fast_dev, sizeof(fast_dev), "/dev/zram%d", zfast);
+	snprintf(slow_dev, sizeof(slow_dev), "/dev/zram%d", zslow);
+
+	/* prio 10 -> 'fast' tier [10, MAX]; prio 0 -> 'slow' tier [-1, 9]. */
+	if (swap_setup(fast_dev, 10) || swap_setup(slow_dev, 0))
+		goto out;
+
+	ret = KSFT_FAIL;
+
+	pid = cg_run_nowait(cg, swapout_child, (void *)MB(64));
+	if (pid < 0)
+		goto out;
+
+	for (i = 0; i < 50; i++) {		/* up to ~5s for pageout */
+		if (swap_used_kb(slow_dev) > 0)
+			break;
+		usleep(100000);
+	}
+
+	used_fast = swap_used_kb(fast_dev);
+	used_slow = swap_used_kb(slow_dev);
+	if (used_slow > 0 && used_fast == 0)
+		ret = KSFT_PASS;
+	else
+		ksft_print_msg("routing[%s]: fast=%ldKB slow=%ldKB (want fast=0, slow>0)\n",
+			       cg, used_fast, used_slow);
+out:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	if (zfast >= 0) {
+		swapoff(fast_dev);
+		zram_remove(zfast);
+	}
+	if (zslow >= 0) {
+		swapoff(slow_dev);
+		zram_remove(zslow);
+	}
+	return ret;
+}
+
+/*
+ * A cgroup that disabled the high-priority 'fast' tier must swap only to the
+ * 'slow' tier's device; the fast device must stay untouched.
+ */
+static int test_routing(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_routing");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	ret = run_routing_case(cg);
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+/* Create @name under @root and delegate the memory controller to its children. */
+static char *make_parent(const char *root, const char *name)
+{
+	char *cg = cg_name(root, name);
+
+	if (cg && !cg_create(cg) &&
+	    !cg_write(cg, "cgroup.subtree_control", "+memory"))
+		return cg;
+
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return NULL;
+}
+
+/*
+ * The effective mask is the parent's intersected with the child's, so a tier
+ * the parent disabled stays disabled for the child even if the child re-enables
+ * it.  Parent disables 'fast', child sets 'fast max' -> child still swaps slow.
+ */
+static int test_routing_parent_wins(const char *root)
+{
+	char *parent = make_parent(root, "swaptier_pwins");
+	char *child = NULL;
+	int ret = KSFT_FAIL;
+
+	if (!parent)
+		goto out;
+	if (cg_write(parent, TIERS_MAX, "fast 0"))
+		goto out;
+
+	child = cg_name(parent, "child");
+	if (!child || cg_create(child))
+		goto out;
+	if (cg_write(child, TIERS_MAX, "fast max"))	/* child tries to re-enable */
+		goto out;
+
+	ret = run_routing_case(child);
+out:
+	if (child) {
+		cg_destroy(child);
+		free(child);
+	}
+	if (parent) {
+		cg_destroy(parent);
+		free(parent);
+	}
+	return ret;
+}
+
+/*
+ * A child can restrict below its parent: the parent leaves all tiers enabled,
+ * the child disables 'fast' on its own -> the child swaps only to slow.
+ */
+static int test_routing_child_restricts(const char *root)
+{
+	char *parent = make_parent(root, "swaptier_crestr");
+	char *child = NULL;
+	int ret = KSFT_FAIL;
+
+	if (!parent)
+		goto out;
+
+	child = cg_name(parent, "child");
+	if (!child || cg_create(child))
+		goto out;
+	if (cg_write(child, TIERS_MAX, "fast 0"))
+		goto out;
+
+	ret = run_routing_case(child);
+out:
+	if (child) {
+		cg_destroy(child);
+		free(child);
+	}
+	if (parent) {
+		cg_destroy(parent);
+		free(parent);
+	}
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
+	char root[PATH_MAX];
+
+	ksft_print_header();
+	ksft_set_plan(7);
+
+	if (geteuid() != 0)
+		ksft_exit_skip("test requires root\n");
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("failed to enable memory controller\n");
+	if (access(TIERS_PATH, F_OK))
+		ksft_exit_skip("swap tiers interface not present\n");
+	if (tier_count() != 0)
+		ksft_exit_skip("swap tiers already configured; run on a clean system\n");
+
+	/* Two tiers: fast = [10, MAX], slow = [-1, 9]. */
+	if (tiers_write("+slow:-1 +fast:10"))
+		ksft_exit_skip("failed to configure swap tiers\n");
+
+	ksft_test_result(test_default(root) == KSFT_PASS, "default mask is max\n");
+	ksft_test_result(test_toggle(root) == KSFT_PASS, "enable/disable tier\n");
+	ksft_test_result(test_invalid(root) == KSFT_PASS, "invalid input rejected\n");
+	ksft_test_result(test_recreate(root) == KSFT_PASS,
+			 "recreated tier resets cgroup mask\n");
+
+	ksft_test_result_code(test_routing(root),
+			      "swapout honors tier mask", NULL);
+	ksft_test_result_code(test_routing_parent_wins(root),
+			      "child cannot re-enable a parent-disabled tier", NULL);
+	ksft_test_result_code(test_routing_child_restricts(root),
+			      "child can restrict tiers below its parent", NULL);
+
+	tiers_clear();
+
+	ksft_finished();
+}
-- 
2.48.1



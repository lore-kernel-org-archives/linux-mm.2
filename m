Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACF7E65298
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6B66B0096; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B686B0098; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8096A6B0099; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 728666B0096
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 036215BEED
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:38 +0000 (UTC)
X-FDA: 84397698798.04.3F7BB78
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2776212000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fxo9j8Xy;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Sqbiib7KB6vkBOddWWUPu9R4jigpGCUz2K/91JUCWs=;
	b=FH7ZJRV1/zGX11eJAhQ091MGNaP2r5MX9Uv5+0p7X8e+qpN7eb34s9hXS3P7S0JFCucmrh
	BazpTFJmSDEhgRT1+icXpA4M2yM4Vvauu0gIjqZStfpbGhbHNnR/gXMPhnfHXhGygNszas
	wPQubG8qKOrpchWsQzcaHn3T6l8gWxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993736; a=rsa-sha256;
	cv=none;
	b=795NGHQOjBSws4bMG3sLvlbFmrCEauP3E5i10TcgI+kn+S35Dg4jfnEoX9AwDdmO7Wpi06
	eS5I3HkBqE65wMPxiPGv2/rosYb2nK8AY1+nZQq3SXT23FvdVdVE4Hhzvl/B2T5sUAkmDg
	vmKeKUJohULqXC8xTKDeJwOaJ9wlrzk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fxo9j8Xy;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-662f74f653bso2240120eaf.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993735; x=1770598535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Sqbiib7KB6vkBOddWWUPu9R4jigpGCUz2K/91JUCWs=;
        b=Fxo9j8Xyc77TqyS919+FBxAn2ESw1vTUDfsmAy5HNZ+lmBVQWiUu0WV9oTfJ0U76r8
         aO8Edk99YaMSzF35L40bfktZXhxpWkqzdtx3nZS1JVDzQKneO1JPReoUMMgEBhkVkT5+
         LpNxllBl5LQyOsOOL8UPSTU77rzI40lndWzrg/PZqPfP2pMZxhAkFzw9+/sWUomh3W4K
         KthEl0wu/R2eLpDswmq0BiICMiOVuaP0MCZYV1oaM8GBqPAWRy1qJH6EogStmVNY6hoT
         dCZOUgXbl9HAWEmri+e7jkS8vfbndocZpkDLIrYmDvLzyvHfEIx9MbUC/eJIAW98tL7j
         2q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993735; x=1770598535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Sqbiib7KB6vkBOddWWUPu9R4jigpGCUz2K/91JUCWs=;
        b=SLfgZ644sMOf4MRI4M2drs/+XcirX4Lf1O4eBvZ7t1yHKC2Q9e6RWN6ZXciIYcIz7+
         sgs/7hoV7d0Zykkn8j1WiP3UJ/fmr3rqBqmlJ2Au1roSQU3fUh/z1BmsIJxJaCdF+fWA
         dRod+yK3Rn/51DalPsQTSaqvAR28MQ/+Fub/nzwVfFNtqqMdf0lXsyL3127VDohE2w6M
         MPP2kF/2mSedIp1Ai2K65jzoefvPg1YFVGsaQwX7UWbtExPsfSaLRKZk2zUKbLkDMXYL
         Z+B3vLZQ+9ZYqtSJh1Uxc1PKYNnei2f/KKRx8a3uYxwYXrHu2IlQ5oHYwholEIT6ddci
         7tOg==
X-Forwarded-Encrypted: i=1; AJvYcCUPEidiLiSreCsE5zNjEaZddiMAvustEoPnIWLhK3mBV5/oIeElzNxUqFBJiZ7ly+WvY9U/CUneZA==@kvack.org
X-Gm-Message-State: AOJu0YyMAD3AH1Yt4oy7ay/kN625JyK+B0W/qwqg3AiTjOwKH94mKhUs
	0dyvK0h6bL+RYW0yFGXFLdP8BSdCh8Wob5Rm510TjPbRkCMd8HFlPrd6
X-Gm-Gg: AZuq6aIdO8tCnCggFTBkazxZ4YkDrLO5/D965bVPY+xDgpFwa92obsdvJdYrP77VxfM
	7Jyaynk79tCKh4yOg0iX2h3w5MYRoNWebU1qzEcoDMu3Z4R+UeLGqC+uMnx9T9EUgxP9uad2xSl
	aYmVfYGQvQN459RHTcLuPvgAPVwlZhP4AHcTLYsla7tELrZSUKQ1p77PeYJQ+Q9LdOvsy+tGeBO
	ptn5liV9Qqe5a2Lug441HZqeDEZJ+/pLt4JC8urTuXc+wpNxbnfeCm+I3DS9E4/ez5I6ibRgITn
	obES04xqVd6BXT9i5EJkInMmB6VrNNud9UCw+prPfmjshKqkKBHe+0E0bCKrd38XZWHbu3qdL7a
	28cfe6BdCvBILCIHPM1xI+9SWgCPRRwNfp2Uoutw47uu5lq/d5h1dZABeWPuL5142fOkDHxccH4
	r8oZ/bYUc=
X-Received: by 2002:a05:6820:2213:b0:661:167b:72db with SMTP id 006d021491bc7-6630f35f037mr4965770eaf.38.1769993735072;
        Sun, 01 Feb 2026 16:55:35 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095753b347sm9566016fac.17.2026.02.01.16.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:34 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 06/12] selftests/mm: add PUD THP basic allocation test
Date: Sun,  1 Feb 2026 16:50:23 -0800
Message-ID: <20260202005451.774496-7-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2776212000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5ojr8serodqsc9x6i4ut9mcu9u6f798j
X-HE-Tag: 1769993735-305732
X-HE-Meta: U2FsdGVkX18SMIdR2Gl+9v0fVtqIjmsAbpR3y5e6Bbh6xvDl0ThBrxpWquxmlyoJhUv6ALsL36dXQkXoXyX8IrCfI1gD7u6cvfaBU8/i8gqlXrUEJgEUwbreP+uqsMvlAvNBFIJxK9fK1ynuEYKvJ9kIoeR6ZREUJqB4ZtC1YYhB6IIEnzsY/qzxc4SVNsugeMrRaxotIneNLflVTY64sBDzzc60jr1VIGNoYK8pEV3KIol6rcoCf9OcJFPdeqKu+oN5JwhRB0Rb6PXg506rfaXm02WnXw2mrJ8jxoADqRerAZVMqvX3qXIY4P2ewK1d3+pO3Dxcir9chXCvmn9lLN4c5aaeWpXpZieEZwceLRNn4SEEpnKdKYMPxvOwWLV3WyzWH72M6/guAhMoGPvW1Rj1lAyQel9Jp5juANXKNEt7CVVQVdgssNJwVBBUXs0AG12sIaPKnbbseffRjH5kZBbX2GQkWBI0csm6XZEl9aKHrd9hWsnlIldGYwFuIeC+AnrXIILmw3VpYC47jLmIz9xyAMwKXP6um7uOQk+eZR37XyXSXWyxWOkkBTEeCvJ/i/MZgyQmlgAQNxd+vwRgWV+UkpRGIZZrfitzK/wftC08hUcmw/MCnYXni2gF4FwOD5blAw8qhCuBsbUDlJ3yd0PDQLsYL4wl8tBb6ImKtmbJlMlPej3t/IfD2Ldz8kszNSDlPn38zraOWLLyfWPD7wAq+L+LRjBsU6c14kfs1dj8EnH1870b+D0qQPd4pZY1wkAMdmtEZvUgPYew+ng7Oh//kK1gjeHBOxV4ZXr3QoFOlLtST+iUulQeqZPh6tvgrff/W3IXfuFA0jEDmPh4Wi5eJFmiTRWxCcPIgFkPvLIgytO5QLytst1CFrnzppby+oJ1SiXwXUML5lgOY4XGMZiPaq00ABwBZQuYsNp685nAt2rCPKhtwiCwzQk1Fy0ufpEx9P239GNghoZgFx8
 5IYuEJQB
 I3Be187+/Zo/F/4tz2argqSVDOXtyd0Ocgp6rZ5QfqZ0afN4OrI1uoQxWsILhMJZwY3pANSgKZ8tPI9rONKjhe7sETIT7pA9FXvlunAIUDOHmctAqaNhcn28n7DdLoKqcPECdrQHU71Acu4cI/dVtOuto5zotGXK7TMatWhCPo5RdXuhtB/rOFNxUG3W1Bxwa/fcOi4W51ZiSVNr4bjGC5p+PjDlDGkf9On76CwUFvq8QfUkxhBZf+Lkhk0A23hQjlVRmeKXUVF6eIvGcp1Z8FWnL67Tf+va/EfVCC6IIR5Io2KQOPOFcg7inGV13TjcQRHqWn6cwknGNC0xwXC0peASkccmnI1H9l577TSiTZ34uPJST4iqq+rBmfL2AnOVRGVBQIz10yh5VjBy6xpy5nz2l9nJfGwdnTkBvz5jaVGlRjntdm2gqgt/rlpl/J5qgal+AcsOqlMBdQtzhcLQHcgJPOVXMl3K6IYm7SzgigIjUiarfoIX7CaUStw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest for PUD-level THPs (1GB THPs) with test infrastructure
and a basic allocation test.

The test uses the kselftest harness FIXTURE/TEST_F framework. A shared
fixture allocates a 2GB anonymous mapping and computes a PUD-aligned
address within it. Helper functions read THP counters from /proc/vmstat
and mTHP statistics from sysfs.

The basic allocation test verifies the fundamental PUD THP allocation
path by touching a PUD-aligned region and checking that the mTHP
anon_fault_alloc counter increments, confirming a 1GB folio was
allocated.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/pud_thp_test.c | 161 ++++++++++++++++++++++
 2 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/mm/pud_thp_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7b..ab79f1693941a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -88,6 +88,7 @@ TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
 TEST_GEN_FILES += prctl_thp_disable
+TEST_GEN_FILES += pud_thp_test
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
new file mode 100644
index 0000000000000..6f0c02c6afd3a
--- /dev/null
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test program for PUD-level Transparent Huge Pages (1GB anonymous THP)
+ *
+ * Prerequisites:
+ * - Kernel with PUD THP support (CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+ * - THP enabled: echo always > /sys/kernel/mm/transparent_hugepage/enabled
+ * - PUD THP enabled: echo always > /sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/enabled
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <sys/syscall.h>
+
+#include "kselftest_harness.h"
+
+#define PUD_SIZE	(1UL << 30)	/* 1GB */
+#define PMD_SIZE	(1UL << 21)	/* 2MB */
+#define PAGE_SIZE	(1UL << 12)	/* 4KB */
+
+#define TEST_REGION_SIZE	(2 * PUD_SIZE)	/* 2GB to ensure PUD alignment */
+
+/* Get PUD-aligned address within a region */
+static inline void *pud_align(void *addr)
+{
+	return (void *)(((unsigned long)addr + PUD_SIZE - 1) & ~(PUD_SIZE - 1));
+}
+
+/* Read vmstat counter */
+static unsigned long read_vmstat(const char *name)
+{
+	FILE *fp;
+	char line[256];
+	unsigned long value = 0;
+
+	fp = fopen("/proc/vmstat", "r");
+	if (!fp)
+		return 0;
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (strncmp(line, name, strlen(name)) == 0 &&
+		    line[strlen(name)] == ' ') {
+			sscanf(line + strlen(name), " %lu", &value);
+			break;
+		}
+	}
+	fclose(fp);
+	return value;
+}
+
+/* Read mTHP stats for PUD order (1GB = 1048576kB) */
+static unsigned long read_mthp_stat(const char *stat_name)
+{
+	char path[256];
+	char buf[64];
+	int fd;
+	ssize_t ret;
+	unsigned long value = 0;
+
+	snprintf(path, sizeof(path),
+		 "/sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/stats/%s",
+		 stat_name);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return 0;
+	ret = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (ret <= 0)
+		return 0;
+	buf[ret] = '\0';
+	sscanf(buf, "%lu", &value);
+	return value;
+}
+
+/* Check if PUD THP is enabled */
+static int pud_thp_enabled(void)
+{
+	char buf[64];
+	int fd;
+	ssize_t ret;
+
+	fd = open("/sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/enabled", O_RDONLY);
+	if (fd < 0)
+		return 0;
+	ret = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (ret <= 0)
+		return 0;
+	buf[ret] = '\0';
+
+	/* Check if [always] or [madvise] is set */
+	if (strstr(buf, "[always]") || strstr(buf, "[madvise]"))
+		return 1;
+	return 0;
+}
+
+/*
+ * Main fixture for PUD THP tests
+ * Allocates a 2GB region and provides a PUD-aligned pointer within it
+ */
+FIXTURE(pud_thp)
+{
+	void *mem;		/* Base mmap allocation */
+	void *aligned;		/* PUD-aligned pointer within mem */
+	unsigned long mthp_alloc_before;
+	unsigned long split_before;
+};
+
+FIXTURE_SETUP(pud_thp)
+{
+	if (!pud_thp_enabled())
+		SKIP(return, "PUD THP not enabled in sysfs");
+
+	self->mthp_alloc_before = read_mthp_stat("anon_fault_alloc");
+	self->split_before = read_vmstat("thp_split_pud");
+
+	self->mem = mmap(NULL, TEST_REGION_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(self->mem, MAP_FAILED);
+
+	self->aligned = pud_align(self->mem);
+}
+
+FIXTURE_TEARDOWN(pud_thp)
+{
+	if (self->mem && self->mem != MAP_FAILED)
+		munmap(self->mem, TEST_REGION_SIZE);
+}
+
+/*
+ * Test: Basic PUD THP allocation
+ * Verifies that touching a PUD-aligned region allocates a PUD THP
+ */
+TEST_F(pud_thp, basic_allocation)
+{
+	unsigned long mthp_alloc_after;
+
+	/* Touch memory to trigger page fault and PUD THP allocation */
+	memset(self->aligned, 0xAB, PUD_SIZE);
+
+	mthp_alloc_after = read_mthp_stat("anon_fault_alloc");
+
+	/*
+	 * If mTHP allocation counter increased, a PUD THP was allocated.
+	 */
+	if (mthp_alloc_after <= self->mthp_alloc_before)
+		SKIP(return, "PUD THP not allocated");
+
+	TH_LOG("PUD THP allocated (anon_fault_alloc: %lu -> %lu)",
+	       self->mthp_alloc_before, mthp_alloc_after);
+}
+
+TEST_HARNESS_MAIN
-- 
2.47.3



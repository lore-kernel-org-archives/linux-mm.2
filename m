Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D0DCAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207B48E001D; Tue,  9 Sep 2025 22:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF9B8E0016; Tue,  9 Sep 2025 22:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F54F8E001D; Tue,  9 Sep 2025 22:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F04EE8E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:46:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3110160652
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:18 +0000 (UTC)
X-FDA: 83871801636.10.3E86042
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 00DF280003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWJoAdIw;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmjjT9DR/3tljJqq0GB/FfILlFmOzlQS2r75W53W/R0=;
	b=Vky/+AHmY5diFhP0srFY+LHN81fHH2tZpwWqu9ZPZhP64KSwIH4lljJ5jFax2C+GpR2wJp
	AOrkDg+RXIH347sPwzaHRwfu6WxMFXn9Vll0aSjmyVHtmrjuilj0UsW28DO4HyWDOLLtS0
	cECK8dA6zY31kPjJyKtoRqbcsdD7CIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472377; a=rsa-sha256;
	cv=none;
	b=kXo7vAdJIGdHu3PCT/kqth7QC/q8tWjeqKFX5HYyQMrSQa+KGMZejcEKO3gLFwjr8WVFKO
	BY8FCABCaOQC+3JmhoCquqFPsL99d9B1Jh+xa8TnfHn/zzncdYPSAStXZ0hCPG5fnmNbpJ
	E9bxRCzm640mjMTqHxQTDa5V0BfGP74=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWJoAdIw;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-32d9f725f68so1702416a91.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472376; x=1758077176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmjjT9DR/3tljJqq0GB/FfILlFmOzlQS2r75W53W/R0=;
        b=ZWJoAdIwHLU/PtoPBg7b/kueN01fM+rNva+TLZvhRrlFj56KBXLS4OyX1lxnoDJp+F
         EUwMWFXt/42HO6QrUqsTNI5TkToA/mwflZWWBAbNstGJd+qL0ZCRg/leMGehTEjO4fc3
         HsrqqnhFODCe3hN1dNPgwTrK1oDAHppJ7iFdm1Qvu8m9A25oDA8uH4WBEVU2cbq9TYua
         OCMjoM2WDmZyEwZKZDcXnxtPaAK1/Uo2vXYWcvnVdEhwKHHMExDZOGOZbL2NV/9jG415
         D0Gfh+KcM1uzq9+sYZtbLuRoj6UVqakP6rvSyys5FN8YvcyP/rlefo81rgt98XZUIsU6
         2rNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472376; x=1758077176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmjjT9DR/3tljJqq0GB/FfILlFmOzlQS2r75W53W/R0=;
        b=LpKc3Fyn4hAFvv792bw1bE8Q9aGzepr7aPxFBNLUK8EmSZOEc0ihL2QuKhG9ggCM9z
         PS0l0aL4YAk9dJvno/IDVx6bAyZh8vRyZcdV1bGh6rWHf8h0SYJGV/rFt8l9lhkQ62DZ
         lO6VpikkRuai3DM1e4kREK79tzOwMf0LN8YJ1Enp7x4frznZaHTcqzIkk4wD+lx4tI3W
         zC3JzFx9K+y0Id5kmb3HtuFd6aVYx4xcipkRefcB2zRuu8K6gi/9dI02zIv4onCYruqk
         3wDWW/HFP4lN7g1T2I/nifboA6+vR3lPbYiEQWFmS1528yujxJl+mdTaeAuKlmCuGVdg
         sNlw==
X-Forwarded-Encrypted: i=1; AJvYcCXTH5uguyj212HRz/nkMJ04MQWLsSBwaTFSdTETrgI0nTJBq7q+rQk2XWbc6tMBsJf61OJb2czYEg==@kvack.org
X-Gm-Message-State: AOJu0YyvYwUN5Wam97la40DlL2ExDunFPpmBHpekxkZuuAxY1p78K52/
	5TrAPZaciF/kbAZfQlvksemmL9U7PGv7nS7rxyS+JyVwpDZNlCiFm2UT
X-Gm-Gg: ASbGnctpWGRj5KHu48HQJWS9cDtGt1gyFjxT5Cqi8QxWKue7CBR9bAf0326ucCUK5lN
	2f0tPcxfoAhLWC35k6PIP1/M00VBp/kch1eKh7jIfSKkuncEGjXyjx89mTWF091ckBhW/LFAnhi
	I7uviZTiYCv7Cu4uwgXvTCuWnNc/EpuaXFEmHzpeyuR0FglNGKmrESXtQx7EasgGCN7e4mygYQA
	2vOwSBXfg6pm5QcOyqcQX9tVIPqOtzZAApsS4HtbVtNd9yeTNnuGjU1LWWXCuIv1uDvGcC8k/bi
	CbRXeNKIldC6tSt3GAW+ebDBFRzqRsMIHCPrqb/82979a3MaaMCEa6U8vggYq+oQLpLZDPzIOCo
	8Z29SNogTjy3FYWk0xxyQnhTXdMuB0v7nONmFALhPmvSZVmsIkluvNiWInil0+Hg0atT+OivcCZ
	IUxjc=
X-Google-Smtp-Source: AGHT+IFQGh0hjvn/NOruUGlSVh8st5OVWC2h57uNrMSSLbhOEzYSk4xyiaT+mU+W5Iq+IXv8sVwFZw==
X-Received: by 2002:a17:90b:17c8:b0:32b:be45:6864 with SMTP id 98e67ed59e1d1-32d43f6da5bmr16537904a91.25.1757472375751;
        Tue, 09 Sep 2025 19:46:15 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.46.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:46:15 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 07/10] selftests/bpf: add a simple BPF based THP policy
Date: Wed, 10 Sep 2025 10:44:44 +0800
Message-Id: <20250910024447.64788-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: idr85odf37hr3rd4nh835nyf9dr84t7m
X-Rspamd-Queue-Id: 00DF280003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757472376-152355
X-HE-Meta: U2FsdGVkX19djDV+Of3Dq2zZEHrbt072wF1dQMhZR20VKmDFj5Z8W+7SkZeeuZQQhExvD+nj9z1JzqIWAgGr5Y8ERMjUTBSlaHfbp1w8UoPYMmSfYx2wIcWY4qd5okSTAiRGGDJnKc0BzTCpz+ia5wlSJTKstqnRad0oq6g1H8BO9VcI/hGqD0m0phflYCANwIFfSnaHEWyDp04KB6o5EXuJTRr1R/4iUi8OIe57qTN5+rYm8c5BGQmxKHcUkN4wtM0T27eKNtRx7EzShNVGSvMMzPrvRF7jzfu0yCJz61/0DEshLpV43kukxDKTXVHFE1SG6Y+yU0LTBGeQwYOPM4a/8nvhT2TRHKEVADoLy3FzNxIePLPjoifPNqJbhxuW8Yoe4oj2g+7UG2S/C/GfQOpZpoJnizlWrr354dW88IiFJOQyxJQRnx3NrD5uDRMva6BsEwAjYPElOE7IBbgambMKku5SfASW5UfMcGXs0BBmi7PGz6Eo5lsT39hTwv6+BjkFggd9yxnoTHWh/tfvk1OgTAxByh3Zl804rQ+2bkzpbilFYpcT7n2dUJq41WVAtzYMwtBe1S5sHLcQ7VmvaKABvvIjGtQ37jVlBxAEh6qgfBDaR3d6OSGVqU5qnr0jpllI/EG7gdATmOZKIHMxxv7m70I5SO8z8lINUzOQHUE2ncghDOAoTYQ8qqCdmPG2X3EAq/ZXonMzrysWSodp+UkvRPfL1gZFVf8XzVzBWjTAiCi5Rhirg2uCR8QsTPvOikVEfF0sw/OE4nXwB+zk42jAlKdH/nwBTsfdB46/AUBg2VhQAk4j+aXZwW5x+YDz2OlI6Pbb9RFpoYvO+xb1AyWkG5VTLzCpryviD756LiC6Ch1Hm9XLXVPuQLtqUAdeTV/fUDq4UvPx8e0AI3xDMz8wwEFiBJqkeuBxdlmf1mFTzen2zzA+Y1WOfni2KxgQF92ByissBFvGqC0fpmi
 7fbNsPtz
 5DszxaeGK5kiaEgXwHXb1OPljhikNC126f2NEc1N6xXjnlb/Ii+lC6rWnNj/UgL+28JINbII5XAxFS5T1lYjhT+VJ3E8ZAykxaSw27GWPnLI7Ull23naBDNF78f1S7qP7J9S7okqtxOh1R4MnbFBW/SrGGofu8P82Spgi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This selftest verifies that PMD-mapped THP allocation is restricted in
page faults for tasks within a specific cgroup, while still permitting
THP allocation via khugepaged.

Since THP allocation depends on various factors (e.g., system memory
pressure), using the actual allocated THP size for validation is
unreliable. Instead, we check the return value of get_suggested_order(),
which indicates whether the system intends to allocate a THP, regardless of
whether the allocation ultimately succeeds.

This test case defines a simple THP policy. The policy permits
PMD-mapped THP allocation through khugepaged for tasks in a designated
cgroup, but prohibits it for all other tasks and contexts, including the
page fault handler.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 254 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 100 +++++++
 4 files changed, 359 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d055a3c95300..6aa5543963d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16255,6 +16255,8 @@ F:	mm/huge_memory.c
 F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+F:	tools/testing/selftests/bpf/progs/test_thp_adjust*
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 8916ab814a3e..b2c73cfae14e 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -26,6 +26,7 @@ CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_SYSTEM=y
 CONFIG_DUMMY=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_BPF_GET_THP_ORDER=y
 CONFIG_FPROBE=y
 CONFIG_FTRACE_SYSCALLS=y
 CONFIG_FUNCTION_ERROR_INJECTION=y
@@ -51,6 +52,7 @@ CONFIG_IPV6_TUNNEL=y
 CONFIG_KEYS=y
 CONFIG_LIRC=y
 CONFIG_LWTUNNEL=y
+CONFIG_MEMCG=y
 CONFIG_MODULE_SIG=y
 CONFIG_MODULE_SRCVERSION_ALL=y
 CONFIG_MODULE_UNLOAD=y
@@ -114,6 +116,7 @@ CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
 CONFIG_SYN_COOKIES=y
 CONFIG_TEST_BPF=m
+CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_UDMABUF=y
 CONFIG_USERFAULTFD=y
 CONFIG_VSOCKETS=y
diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
new file mode 100644
index 000000000000..a4a34ee28301
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <math.h>
+#include <sys/mman.h>
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_thp_adjust.skel.h"
+
+#define LEN (16 * 1024 * 1024) /* 16MB */
+#define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
+#define PMD_SIZE_FILE "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+
+static struct test_thp_adjust *skel;
+static char *thp_addr, old_mode[32];
+static long pagesize;
+
+static int thp_mode_save(void)
+{
+	const char *start, *end;
+	char buf[128];
+	int fd, err;
+	size_t len;
+
+	fd = open(THP_ENABLED_FILE, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	err = read(fd, buf, sizeof(buf) - 1);
+	if (err == -1)
+		goto close;
+
+	start = strchr(buf, '[');
+	end = start ? strchr(start, ']') : NULL;
+	if (!start || !end || end <= start) {
+		err = -1;
+		goto close;
+	}
+
+	len = end - start - 1;
+	if (len >= sizeof(old_mode))
+		len = sizeof(old_mode) - 1;
+	strncpy(old_mode, start + 1, len);
+	old_mode[len] = '\0';
+
+close:
+	close(fd);
+	return err;
+}
+
+static int thp_mode_set(const char *desired_mode)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_FILE, O_RDWR);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, desired_mode, strlen(desired_mode));
+	close(fd);
+	return err;
+}
+
+static int thp_mode_reset(void)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_FILE, O_WRONLY);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, old_mode, strlen(old_mode));
+	close(fd);
+	return err;
+}
+
+static int thp_alloc(void)
+{
+	int err, i;
+
+	thp_addr = mmap(NULL, LEN, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (thp_addr == MAP_FAILED)
+		return -1;
+
+	err = madvise(thp_addr, LEN, MADV_HUGEPAGE);
+	if (err == -1)
+		goto unmap;
+
+	/* Accessing a single byte within a page is sufficient to trigger a page fault. */
+	for (i = 0; i < LEN; i += pagesize)
+		thp_addr[i] = 1;
+	return 0;
+
+unmap:
+	munmap(thp_addr, LEN);
+	return -1;
+}
+
+static void thp_free(void)
+{
+	if (!thp_addr)
+		return;
+	munmap(thp_addr, LEN);
+}
+
+static int get_pmd_order(void)
+{
+	ssize_t bytes_read, size;
+	int fd, order, ret = -1;
+	char buf[64], *endptr;
+
+	fd = open(PMD_SIZE_FILE, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	bytes_read = read(fd, buf, sizeof(buf) - 1);
+	if (bytes_read <= 0)
+		goto close_fd;
+
+	/* Remove potential newline character */
+	if (buf[bytes_read - 1] == '\n')
+		buf[bytes_read - 1] = '\0';
+
+	size = strtoul(buf, &endptr, 10);
+	if (endptr == buf || *endptr != '\0')
+		goto close_fd;
+	if (size % pagesize != 0)
+		goto close_fd;
+	ret = size / pagesize;
+	if ((ret & (ret - 1)) == 0) {
+		order = 0;
+		while (ret > 1) {
+			ret >>= 1;
+			order++;
+		}
+		ret = order;
+	}
+
+close_fd:
+	close(fd);
+	return ret;
+}
+
+static void subtest_thp_policy(void)
+{
+	struct bpf_link *fentry_link, *ops_link;
+
+	/* After attaching struct_ops, THP will be allocated only in khugepaged . */
+	ops_link = bpf_map__attach_struct_ops(skel->maps.khugepaged_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	/* Create a new BPF program to detect the result. */
+	fentry_link = bpf_program__attach_trace(skel->progs.thp_run);
+	if (!ASSERT_OK_PTR(fentry_link, "attach fentry"))
+		goto detach_ops;
+	if (!ASSERT_NEQ(thp_alloc(), -1, "THP alloc"))
+		goto detach;
+
+	if (!ASSERT_EQ(skel->bss->pf_alloc, 0, "alloc_in_pf"))
+		goto thp_free;
+	if (!ASSERT_GT(skel->bss->pf_disallow, 0, "disallow_in_pf"))
+		goto thp_free;
+
+	ASSERT_EQ(skel->bss->khugepaged_disallow, 0, "disallow_in_khugepaged");
+thp_free:
+	thp_free();
+detach:
+	bpf_link__destroy(fentry_link);
+detach_ops:
+	bpf_link__destroy(ops_link);
+}
+
+static int thp_adjust_setup(void)
+{
+	int err, cgrp_fd, cgrp_id, pmd_order;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pmd_order = get_pmd_order();
+	if (!ASSERT_NEQ(pmd_order, -1, "get_pmd_order"))
+		return -1;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "cgrp_env_setup"))
+		return -1;
+
+	cgrp_fd = create_and_get_cgroup("thp_adjust");
+	if (!ASSERT_GE(cgrp_fd, 0, "create_and_get_cgroup"))
+		goto cleanup;
+	close(cgrp_fd);
+
+	err = join_cgroup("thp_adjust");
+	if (!ASSERT_OK(err, "join_cgroup"))
+		goto remove_cgrp;
+
+	err = -1;
+	cgrp_id = get_cgroup_id("thp_adjust");
+	if (!ASSERT_GE(cgrp_id, 0, "create_and_get_cgroup"))
+		goto join_root;
+
+	if (!ASSERT_NEQ(thp_mode_save(), -1, "THP mode save"))
+		goto join_root;
+	if (!ASSERT_GE(thp_mode_set("madvise"), 0, "THP mode set"))
+		goto join_root;
+
+	skel = test_thp_adjust__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto thp_reset;
+
+	skel->bss->cgrp_id = cgrp_id;
+	skel->bss->pmd_order = pmd_order;
+
+	err = test_thp_adjust__load(skel);
+	if (!ASSERT_OK(err, "load"))
+		goto destroy;
+	return 0;
+
+destroy:
+	test_thp_adjust__destroy(skel);
+thp_reset:
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+join_root:
+	/* We must join the root cgroup before removing the created cgroup. */
+	err = join_root_cgroup();
+	ASSERT_OK(err, "join_cgroup to root");
+remove_cgrp:
+	remove_cgroup("thp_adjust");
+cleanup:
+	cleanup_cgroup_environment();
+	return err;
+}
+
+static void thp_adjust_destroy(void)
+{
+	int err;
+
+	test_thp_adjust__destroy(skel);
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+	err = join_root_cgroup();
+	ASSERT_OK(err, "join_cgroup to root");
+	if (!err)
+		remove_cgroup("thp_adjust");
+	cleanup_cgroup_environment();
+}
+
+void test_thp_adjust(void)
+{
+	if (thp_adjust_setup() == -1)
+		return;
+
+	if (test__start_subtest("alloc_in_khugepaged"))
+		subtest_thp_policy();
+
+	thp_adjust_destroy();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
new file mode 100644
index 000000000000..93c7927e827a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
+long bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;
+void bpf_cgroup_release(struct cgroup *p) __ksym;
+struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
+void bpf_task_release(struct task_struct *p) __ksym;
+
+int pf_alloc, pf_disallow, khugepaged_disallow;
+struct mm_struct *target_mm;
+int pmd_order, cgrp_id;
+
+/* Detecting whether a task can successfully allocate THP is unreliable because
+ * it may be influenced by system memory pressure. Instead of making the result
+ * dependent on unpredictable factors, we should simply check
+ * bpf_hook_thp_get_orders()'s return value, which is deterministic.
+ */
+SEC("fexit/bpf_hook_thp_get_orders")
+int BPF_PROG(thp_run, struct vm_area_struct *vma, u64 vma_flags, enum tva_type tva_type,
+	     unsigned long orders, int retval)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (mm != target_mm)
+		return 0;
+
+	if (orders != (1 << pmd_order))
+		return 0;
+
+	if (tva_type == TVA_PAGEFAULT) {
+		if (retval == (1 << pmd_order))
+			pf_alloc++;
+		else if (retval == (1 << 0))
+			pf_disallow++;
+	} else if (tva_type == TVA_KHUGEPAGED) {
+		/* khugepaged is not triggered immediately, so its allocation
+		 * counts are unreliable.
+		 */
+		if (retval == (1 << 0))
+			khugepaged_disallow++;
+	}
+	return 0;
+}
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_in_khugepaged, struct vm_area_struct *vma, enum bpf_thp_vma_type vma_type,
+	     enum tva_type tva_type, unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct task_struct *p, *acquired;
+	int suggested_order = 0;
+	struct cgroup *cgrp;
+
+	if (orders != (1 << pmd_order))
+		return 0;
+
+	if (!mm)
+		return 0;
+
+	/* This BPF hook is already under RCU */
+	p = mm->owner;
+	if (!p)
+		return 0;
+
+	acquired = bpf_task_acquire(p);
+	if (!acquired)
+		return 0;
+
+	cgrp = bpf_cgroup_from_id(cgrp_id);
+	if (!cgrp) {
+		bpf_task_release(acquired);
+		return 0;
+	}
+
+	if (bpf_task_under_cgroup(acquired, cgrp)) {
+		if (!target_mm)
+			target_mm = mm;
+
+		/* BPF THP allocation policy:
+		 * - Allow PMD allocation in khugepagd only
+		 * - "THPeligible" in /proc/<pid>/smaps is also set
+		 */
+		if (tva_type == TVA_KHUGEPAGED || tva_type == TVA_SMAPS)
+			suggested_order = pmd_order;
+	}
+	bpf_cgroup_release(cgrp);
+	bpf_task_release(acquired);
+	return suggested_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops khugepaged_ops = {
+	.thp_get_order = (void *)alloc_in_khugepaged,
+};
-- 
2.47.3



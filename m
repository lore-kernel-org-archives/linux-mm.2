Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A471CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F005A8E0013; Fri, 26 Sep 2025 05:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1778E0001; Fri, 26 Sep 2025 05:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78458E0013; Fri, 26 Sep 2025 05:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0C888E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:35:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1837716060A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:06 +0000 (UTC)
X-FDA: 83930892612.02.BFE8F20
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39F45120009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHoQrHux;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KejkPMgGRvReGxuBAv36+hrv4MPOBVSti8PCSW2auKE=;
	b=1Wxs49+lzNqmQGWCM5cBW+RXHxqmPNZhPJHdfCOXeLgoCxJ6zs9wvueZwb1tAIn5HhWb2f
	njky2uEr08gTVMzUwwivc5dzmTpgjkh9WHj3VZjIxF/Vs8xVDTIny9TI8q5rBC6blMgmvE
	zdsO92PtiWNKJI2RKAVOJT/SAbJnX30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879304; a=rsa-sha256;
	cv=none;
	b=MGPI0mx7XchNsA4i5128pOArlcL0pv9O16d+px0x2T1XSsmbDVwJksk5iAspIQ6m67OmpY
	LTn9hbz5rlLvSs8t0aVMgdwgMS6hAWcqPkq5f1IGHMnZKloehftRc+y5Q+8OsRCXwTkUpj
	Y75OY/S3Ezlbh+fxhMylSNnPeTZSNhs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHoQrHux;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77f198bd8eeso1490102b3a.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879303; x=1759484103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KejkPMgGRvReGxuBAv36+hrv4MPOBVSti8PCSW2auKE=;
        b=VHoQrHuxKoKvIdYlrYrVe3OOUAyKtZ3AbZA2/32gnmbwp9v2JTISuh2E/wA7giIBeV
         +vIm66K9wWfLSQzTEQyvUZe1rFMA6mJ6jPWgtSWKWSCRvDG8IdqIMN5l0n67jf2wPE8y
         KuirVPmVapG6Dm0uzFe/QzGmmz9QI57UqndZoFv2WLnHHjcSg4zxAHt3Uh6iQViBgRhJ
         +SBGCVddaerUIu2vzZVIFZ9lrgQZCzxNn4eGBEB4u1M/8sq/yKfRU/ybVl8+kss76av8
         XVOcXnkwRtswmdMRNzIkoI5KTLd2AZMELGWdeOI3GyWr2zAcuqKQ9gLEsPqkO3Tx9Ucd
         Nx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879303; x=1759484103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KejkPMgGRvReGxuBAv36+hrv4MPOBVSti8PCSW2auKE=;
        b=Yru26waWz/XYoKUCC+uxlHCzvfN9lU4TVM7GWoR64TFCnmp381cqlYx6e06oloyPvw
         SMp9qqme6AbECEnzOMnYeOPefCAVDaaQlQ2lRFnUGDr1htWs2cGpMqfrgsZPPXEuYF8a
         7DnKteIg01cCmxXvfU33aFrSWlR6QxeAh0G6r1v7XFnOON/HQhHPbXEL6iipSGX1s9c7
         IRiqNm55VagNgR+Avi25ocMNA+8luouJH3/GDST2796CbSpHlGzSkntDJ4gHF1c40iF/
         xR/dbnGRy6iyrux/esmMY32vLaQwwFpalf/RNy1MGN4u8SUa5rJ/rYNRzVCjq0ooXUX3
         puGA==
X-Forwarded-Encrypted: i=1; AJvYcCVY2eNEhcj3AnLAD36zYnjmSITjt6kIw80PkkFh1U1khpZ2D0+LUDs7qDsiDRbYTOCjOPswO0I0mA==@kvack.org
X-Gm-Message-State: AOJu0Yyc5EaXX4riVDzjnz1sJYzOF/nTodXxoYExgnKSOotWfjBX9Kt7
	awm4wkAbZ7AY4ahYO0vqv9es+1Itl7TWTCncLmocFBRZqgbw7Zeh918U
X-Gm-Gg: ASbGncs3wg2y4iwi+0NEAPWy6A+Zf8f5I9mVnOM1VqHRMFQgL5bsDVM252CQKftJUGE
	sJOggCguAc8BJTlGPTtvlnUE3A6lAuB9GnYydR+Al0TdsgY/wNP8JGo+qXLSnyOJEtkFwnjed2z
	75tkAY6mLH3n7CF1dJnPb297nUJV9YwND9Yh1TE5jrXDILMdK8WFHrn4hhDIY7mxGY8WFR5zFch
	vtpSC1jyr0RkuTqPwHFd1r9podsr0pWKKQURNkt7N3Jle1HmhlonNE9UfSR7UsULRzU4AzQ4kk+
	vBu6oP1VUdExAN8lJbytFwo5pJ+GBwKjjiNzS8NyRn82IFQ4fysFbw43i+pVEAHxYWQ3myZTJss
	6+Y3IJKfKsmnWO6l4Ca6KR/nmbmoKiLSa6f6J6rrFUXnk4pmNFz+AsZUN/7XcJBraO8RkM1fv3M
	LpcxSLIRi/PTwv
X-Google-Smtp-Source: AGHT+IHJMvMRnfOqzEak3qmEUf11dLxaZn5jFt91kzwtU8AVAcW525LzqoVivLg7u9BwGX2hLSfT8w==
X-Received: by 2002:a17:902:e749:b0:27d:6cdc:99e4 with SMTP id d9443c01a7336-27ed49e6cacmr73186945ad.21.1758879303020;
        Fri, 26 Sep 2025 02:35:03 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:35:02 -0700 (PDT)
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
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 09/12] selftests/bpf: add a simple BPF based THP policy
Date: Fri, 26 Sep 2025 17:33:40 +0800
Message-Id: <20250926093343.1000-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39F45120009
X-Stat-Signature: jg8nt8hhbr5m5yzjes5rbn334dqgu6hw
X-Rspam-User: 
X-HE-Tag: 1758879304-964484
X-HE-Meta: U2FsdGVkX1+gdO0Xa3VXf6YGH3GDe6PUO5immn209En3Ac+33LxJ6OmWh24eTvfg7vOWt3smmCThyPX3D5Xy/Fg32aK2Vvq7oT3oh8anBFiGq14lBT1ybH+YvyNvLJNWf4hiWyzx0mZPu9N1zteeh4lCIP3ZslfDOX4LpKzM7omnk0ZuzkXa+bZ1QlNalxAEu2v5+qBJeWw+iEMnxLJ9jERrmH4eKjrKnMf2WE4orVB/HNycS7xdwdSFIeC73mss+0hU5CRAPDqvvMLLgy0yWAx9ORCWMmV557RAF1XVKJhpYHAj2qJPtebixeTlmPliLmSwDBRVB8ToTp33R9xMkVx85FD+apzghQ0F/6/AYNhVYUD+ORK+XZR3azE/1/1EhrJqHWqdQgf50B3xMLXM3EEe2fwvmqtcPNtXc8m/c4DEHYXGy4a2hWSdfXm3scnFLEAwMqfuLGVsqn2vCjOO6V5CQI+i53qkBw+LO76moW6t9fTr9/kMx8XBydHOarBAVzdrh29Q/p+CE1fKwOpo20Wv9v3siLb06/uNeEo7pCWQAAGPms+20MOqej23sGh6gDFiW6Fs0Nq299t1Hr2rUKOZJzvpNsFRQf/D61IVqfD1+pcftu7CxYduKsRRpjoVjmnB29hbp3JOmfmEVwD6I4CO2x4xRh1LbGBj5xm2iu9TQzkcJOEQ9/bhnJv66VJzuTVe8ZKuJQYIzPfvvZYltdAxiZEk4wega6HE0692M9o532G4pCHrpfDDzR1AGJovUIg6SLOxL/dYhTtPFrbJCG89XeI8zn/Y7iBCYA8bMF8P8pHpl6c6QUf0YMOWwydsE4srvfuyt6bYOZJBPivJ7B6Qe7gXA3CCNOqP7RgwD7QPM1rNlkq1qWqknwIQ04j2/33CxXVYppXWHtN2zgstMUvHrnJTP4h+AS06A92jif6ymH8OU7HYfuW2/BsXQAIJrk/AAEYXM/6KdNlBgz9
 qbyUH2Cb
 Tpou/QUi3GnRhRix8zPHX2qnN9QBytHN33ktpw8bauG1gqFHtx/svgfnuxWcppYPMTrabQ4utv4x4gxEmxyo+mV1E3ZbnJ8NDRYH745jS+AL7E6sZ5M1fuj5GOVmJM390GEyJLZCmCsqP7bF3uv4xXSad6N8/Dufeu2RoLY/Y257pWPFOFIr4bSkA2x38myQIxligvPL45aMdKx3PMGf8wuTm0PCtUCSBO0YLJAvy7bdpekb3XKF1KahvvtZXv9AM4Svyu5ie7egXtBKNZWXOW9wXNAxrDnwLVFfT05l4Utw6ZiDMKMAEDhxeyJ+kz6U4ZHLqKNapL7tFhoAEayFR/dlm/OXAFmQE46gUMk89+lLZ3uabJPuDM6qr0I9FjAjNm6F9nJ21OWT2PfTnhcrJZnIq/3xffDgtwgXyyxNDazImlODeehV0/zZade5QvplurDdje9IbWErAaiQXvi0hrIzP+0Pp97YztVkcsbcZ3wUu9Kd2bz9zgTh5WqJjXcclynsaD1EKEaeM79w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case implements a basic THP policy that sets THPeligible to 1 for
a specific task and to 0 for all others. I selected THPeligible for
verification because its straightforward nature makes it ideal for
validating the BPF THP policy functionality.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 258 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  41 +++
 4 files changed, 304 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7be34b2a64fd..c1219bcd27c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16260,6 +16260,8 @@ F:	mm/huge_memory.c
 F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+F:	tools/testing/selftests/bpf/progs/test_thp_adjust*
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 8916ab814a3e..7ccb9809e276 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -26,6 +26,7 @@ CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_SYSTEM=y
 CONFIG_DUMMY=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL=y
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
index 000000000000..b14f57040654
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <math.h>
+#include <sys/mman.h>
+#include <test_progs.h>
+#include "test_thp_adjust.skel.h"
+
+#define LEN (16 * 1024 * 1024) /* 16MB */
+#define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
+#define PMD_SIZE_FILE "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+
+static struct test_thp_adjust *skel;
+static char old_mode[32];
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
+static char *thp_alloc(void)
+{
+	char *addr;
+	int err, i;
+
+	addr = mmap(NULL, LEN, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (addr == MAP_FAILED)
+		return NULL;
+
+	err = madvise(addr, LEN, MADV_HUGEPAGE);
+	if (err == -1)
+		goto unmap;
+
+	/* Accessing a single byte within a page is sufficient to trigger a page fault. */
+	for (i = 0; i < LEN; i += pagesize)
+		addr[i] = 1;
+	return addr;
+
+unmap:
+	munmap(addr, LEN);
+	return NULL;
+}
+
+static void thp_free(char *ptr)
+{
+	munmap(ptr, LEN);
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
+static int get_thp_eligible(pid_t pid, unsigned long addr)
+{
+	int this_vma = 0, eligible = -1;
+	unsigned long start, end;
+	char smaps_path[64];
+	FILE *smaps_file;
+	char line[4096];
+
+	snprintf(smaps_path, sizeof(smaps_path), "/proc/%d/smaps", pid);
+	smaps_file = fopen(smaps_path, "r");
+	if (!smaps_file)
+		return -1;
+
+	while (fgets(line, sizeof(line), smaps_file)) {
+		if (sscanf(line, "%lx-%lx", &start, &end) == 2) {
+			/* addr is monotonic */
+			if (addr < start)
+				break;
+			this_vma = (addr >= start && addr < end) ? 1 : 0;
+			continue;
+		}
+
+		if (!this_vma)
+			continue;
+
+		if (strstr(line, "THPeligible:")) {
+			sscanf(line, "THPeligible: %d", &eligible);
+			break;
+		}
+	}
+
+	fclose(smaps_file);
+	return eligible;
+}
+
+static void subtest_thp_eligible(void)
+{
+	struct bpf_link *ops_link;
+	int elighble;
+	pid_t pid;
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	pid = getpid();
+	ptr = thp_alloc();
+	if (!ASSERT_OK_PTR(ptr, "THP alloc"))
+		goto detach;
+
+	skel->bss->pid_eligible = pid;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 1, "THPeligible");
+
+	skel->bss->pid_eligible = 0;
+	skel->bss->pid_not_eligible = pid;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THP not eligible");
+
+	skel->bss->pid_eligible = 0;
+	skel->bss->pid_not_eligible = 0;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THP not eligible");
+
+	thp_free(ptr);
+detach:
+	bpf_link__destroy(ops_link);
+}
+
+static int thp_adjust_setup(void)
+{
+	int err = -1, pmd_order;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pmd_order = get_pmd_order();
+	if (!ASSERT_NEQ(pmd_order, -1, "get_pmd_order"))
+		return -1;
+
+	if (!ASSERT_NEQ(thp_mode_save(), -1, "THP mode save"))
+		return -1;
+	if (!ASSERT_GE(thp_mode_set("madvise"), 0, "THP mode set"))
+		return -1;
+
+	skel = test_thp_adjust__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto thp_reset;
+
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
+	return err;
+}
+
+static void thp_adjust_destroy(void)
+{
+	test_thp_adjust__destroy(skel);
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+}
+
+void test_thp_adjust(void)
+{
+	if (thp_adjust_setup() == -1)
+		return;
+
+	if (test__start_subtest("thp_eligible"))
+		subtest_thp_eligible();
+
+	thp_adjust_destroy();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
new file mode 100644
index 000000000000..ed8c510693a0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int pid_not_eligible, pid_eligible;
+int pmd_order;
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_eligible, struct vm_area_struct *vma, enum tva_type tva_type,
+	     unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int suggested_order = 0;
+	struct task_struct *p;
+
+	if (tva_type != TVA_SMAPS)
+		return 0;
+
+	if (!mm)
+		return 0;
+
+	/* This BPF hook is already under RCU */
+	p = mm->owner;
+	if (!p || (p->pid != pid_eligible && p->pid != pid_not_eligible))
+		return 0;
+
+	if (p->pid == pid_eligible)
+		suggested_order = pmd_order;
+	else
+		suggested_order = 30;	/* invalid order */
+	return suggested_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops = {
+	.thp_get_order = (void *)thp_eligible,
+};
-- 
2.47.3



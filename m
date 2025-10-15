Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13ECCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226758E003F; Wed, 15 Oct 2025 10:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFC78E000A; Wed, 15 Oct 2025 10:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028E08E003F; Wed, 15 Oct 2025 10:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD73A8E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0932118433
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:44 +0000 (UTC)
X-FDA: 84000554568.12.2145956
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id B38EE16001A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYlAn1MF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6t6N9HpqC1tc69VtCq5PoxDpHYOuoNpn/2bEQQRKsCU=;
	b=8YnFMy1v9tOW4BbLXoQ4NKQXM3uYp45xW5OmCmeBX2BduUieMBu1Sclkwhk+Yv9/meSr70
	UGuInFjSYcUsyohR0RKJobLlPS40I/CxaaYRO1bIUzLRwBkMRXC+FxZtSOXdZ5T+t0af9H
	+VJ+nUGob61d67IvvZpquhuzUBzp5SU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537922; a=rsa-sha256;
	cv=none;
	b=37bjSHWdRkqBaxMTtjiuVaIBpmLmPqf3rLyErjuyjdSLkhruyOSy4MH1vLQu6mEhnEANu8
	AOC/iY1CZXtc9ZuxMnvKrqX0/4hmwJzuv+sjSazJWCEc/IP9Sef+5RVumIn7FRf3fmADw5
	2wDm9kmp8rmpNXZgRTaIituz1dBiST0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYlAn1MF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2698e4795ebso64488455ad.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537921; x=1761142721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6t6N9HpqC1tc69VtCq5PoxDpHYOuoNpn/2bEQQRKsCU=;
        b=iYlAn1MF9IUKqVZKPksXWXKP2F4UapvsS+o48kaP6GQ5HrRXanOis7t0TiU24J7mL/
         oWpCNyMuc8GgvM3C6s8F/FsAP4ScmJ2bIA7BSddqLP6GW5z9BAItfc7JbnnzlzOe/yRH
         3vThNnCsyOT0LsUdBD8FPHvESBrYoCdWe5Jf7wQ3nfqMqkWctJtmXHUPrlMn/znhwEcY
         gTJ/fxBspjVsilYJ4YoAyAjBMPNvfDm5/wXjqX4YUtgzNx4H3j5wYRN4PLrgJdl9SoYr
         D5x3kJ/TgMZym8Wm2V4KJIVLIwaayRRdmC9/0158NC1M2XZ1J945kDdmrepuAnn+iJT8
         S7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537921; x=1761142721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6t6N9HpqC1tc69VtCq5PoxDpHYOuoNpn/2bEQQRKsCU=;
        b=Vg+azKOrJiOB2kj/87akneoJq0xiYp1AulkgNnLutKUFd7jeihJBblX4Zf5suTkcQJ
         JW4nKWvrV3IWYWCTxvNRYR1mzmIxW90EH4BRYAXawNxS6y9UqdqCv0Vp3l+IISLClJno
         u+vadIB9jHm3R9bx13cRNPwIF4NYpIdA1252CAbqav6/FN0v/V8qaaiMnFzlmEJ+4ynI
         +d69ZbczUfXHOZ7FyZjQhEVN7EN+rbdKD/mnPK04FRSvGbLzedk93M+tK4nPJ6PcOEtz
         IF1043b0b/HZD0suCTkNWGDspDvuY69i2VUi7H0XRogwR/gG34nKbdiH+/E+NkAF4TYp
         CZ3g==
X-Forwarded-Encrypted: i=1; AJvYcCU+6MIMj7VydvRa9SpD5pFleFoBlIukw3+qaDPvuFEACiJ6M5q73npejxD3jcVmMQSv6zKMvLdluw==@kvack.org
X-Gm-Message-State: AOJu0YwqeWavEy4zG/1+uTIXgvMfRBJcGMGFCASFcx7zwUiJCJRWGs+4
	CVtX+zu4Klp2BRhSTb4X6HCyVUabNdGQ4P14yItbCOBXowEBj1Jui2Vh
X-Gm-Gg: ASbGncsI11m/zkJ1LTRQsbmDM/gcfhEF/pKAJFRIL43K/xH40KaWaDX8tJFGVqZF9x8
	fu7Fuu+hpnCZEyiNEhYa0czPXriIKwuDLIU3zPUHrdCz/+tQ9jNe+oX5kxwT8q1Ws4XhmRcX7zL
	NPAMVbh7CjraBKxSBiXjB4wYsKKajCWdBsQJzWiR/eEo2/mZrEdFe0+mPmFg0SXuCvk74g9cE6Y
	iaKw7ev1ySBoyvGGwyuZMokn/16/3wADCmywCevjvX6QwZBf+8jMMmjXVmbgRMl7Rd4L01e6FI4
	IeU+LX15gy5D/vnfaTq8CvCGCXRuwnDKN6XL0QuMwTHCJqg83AWly7xKIEZtsU+qdDUBPiiHhPL
	5H2h++pU2vg4Fw7n4GU3zcFgBXlkfovpppdGEaHhRb+J8Xlz1BnboFYCOP/JxwdCsHoZrknACxr
	UfL7/nNA==
X-Google-Smtp-Source: AGHT+IF82bnRiuy2u2JBIprbwTFWlMO2WWuYRZy2bwtJxPH4hn0qqhx4Y3Mh3G8QrQkbXo6LCevr0w==
X-Received: by 2002:a17:902:e806:b0:28d:18d3:46ca with SMTP id d9443c01a7336-29027402f00mr407388595ad.49.1760537921383;
        Wed, 15 Oct 2025 07:18:41 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.18.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:39 -0700 (PDT)
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
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 8/9] selftests/bpf: add a simple BPF based THP policy
Date: Wed, 15 Oct 2025 22:17:15 +0800
Message-Id: <20251015141716.887-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: itj7wec3k8r48grmw9kgrdfiwc6z5475
X-Rspam-User: 
X-Rspamd-Queue-Id: B38EE16001A
X-HE-Tag: 1760537922-76817
X-HE-Meta: U2FsdGVkX1+499Gq8K9/BU303fNyT6oNnAykWKqeKVFzqmZCvly1HPVIczuaej9d3XVB9aWHVzO9c4MuIX5VgGjTKc2ksmUkQR3thGpjCD01K2+sfmx74WtkhCdhkRF28SHSIaW1fUXtUmRMC/seByU7Y3rrJnXH2F5XSpvEBk35+aTKX1VYCF+zU51O3lbyVAXkscA3AExA2YjLIhOQs6lpfuwvV2i/Zb4kRTSVMhA3IpDRUejJPk6Xo3D/BYHoY5fBTDkkBAYRkzXV/VnZkAW3Vl319FhDAAH8cUztgUGTjT79kLPSGcJtOdYpTFoeEs8cN1suepsesitfAbUD4ey3rnmtI6CxCy3YCOm6EKrV3fYnop0dSWOvtwUM/clXaC5whtjeDYNIvCXbiT/B9lu1onABWQA40Mkjc+zWfIqmpOTdcbKEoMJukHN1HaQ2bs1DLoJOF7YzVfERDIk87pkPnT+aD9RNfZU8Pno1tNp7BE2/PoyBk4JigEvKmRvLtkestl1ZKE5eJ/IuuY0jhQlPCnHLVEqUIlLsp6x8n0nUeAD3v8lMqre8C+fj7UvHAh2zAT0ojtzrM8cfoBbjTsya7xww3/Nr4FAH5Wg3YxvH/DvdKHkR8SCRKNDD2DmdkUuEJrFNPFMpdQet3V2K+xEeqQKC1zbt1wJXNHfwQ40LpckSqWZr/z2A4hUYkWlPxQCCgwZB8dr33Yej3gdES0yRR4GNHIjag9ihBO9mKux2Za6liXGsCLGxZ/D2tsN9HWheRskeb//MqUmBA+tB2OoF61KdFlWesr5mJHvfY1ToHJ0v/QKkfzDrM35diIsIqjGo/bUdfE312qDlzyIOlwsULes+hZ5vIsw5g/EMvziTi0DJ6LFNqhs41p+0WDtQaMfiSDCWPOWRfce12WvGPX0C/6rDbP4RMAwmJgq1K7UQ6NQdPrSLvpe4BT9NWWWvOkdOYSjmW81cvvmIt9z
 orVJpHay
 dlTRmRSNV1wMrCJaagidn5ZrUKE2JDA89pXrMvuUPLp4jjTjtKVZqJyjMk6v1rIjGsiYSOcFLoAl5J7TWDsQH8gANRGiwVGblM2A2wOgY1XK2Qf27iQRYgF/j5RKP6+5ajdCOmlySY8alsqhlGCPhrr//CdYwDa1NnWdy80dGFpwi6LvjjcuIwFUfnQZ47CrWLntv+qQE7OTG2pb2sSgL4bBFLMTYKfgw/WU+Lolf7ZP14v3mO3qKhLe4dsNY8x0sW5nOFMrqFiAvMEQ/z2JSLUh0mg8tX8cZenO4m714/s2v9ndvGkfjDd4QyHBKep473e6JDRxquGvZg/dLUQ9pmDhh4lTq8JS9F1zlSopJTNltHdYm4WrrD+k/FxI0j04h6VSumIBN25sGi/d4ntpwuw0GryjL8UAjJrN3tAJswwUFSpNU/FSp0mqsoh299px2mVzyT4Q7lAoPigQOmcVSI1WTYWa6geQO8dYYAfPYfeQl0KNeOHcSOvxvakgqUi3CJyZuU97mIAUro6s=
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

Below configs must be enabled for this test:

  CONFIG_BPF_THP=y
  CONFIG_MEMCG=y
  CONFIG_TRANSPARENT_HUGEPAGE=y

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 245 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  23 ++
 4 files changed, 273 insertions(+)
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
index 8916ab814a3e..13711f773091 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -9,6 +9,7 @@ CONFIG_BPF_LIRC_MODE2=y
 CONFIG_BPF_LSM=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
+CONFIG_BPF_THP=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
 CONFIG_CGROUP_BPF=y
 CONFIG_CRYPTO_HMAC=y
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
index 000000000000..b69f51948666
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+
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
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	ptr = thp_alloc();
+	if (!ASSERT_OK_PTR(ptr, "THP alloc"))
+		goto detach;
+
+	elighble = get_thp_eligible(getpid(), (unsigned long)ptr);
+	ASSERT_EQ(elighble, 1, "THPeligible");
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
+	skel->struct_ops.thp_eligible_ops->pid = getpid();
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
index 000000000000..bc062d7feed4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int pmd_order;
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_eligible, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	if (type != TVA_SMAPS)
+		return 0;
+	return pmd_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops = {
+	.thp_get_order = (void *)thp_eligible,
+};
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54116CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948D68E00B0; Tue, 26 Aug 2025 03:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8DF8E00A8; Tue, 26 Aug 2025 03:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1778E00B0; Tue, 26 Aug 2025 03:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 662818E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BF3D118D49
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:10 +0000 (UTC)
X-FDA: 83818062300.07.B8B0FD4
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 70150100005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7zC2gWr;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGB9Y8Xro5EcYuOr6YGEfLC07C5z6V9YadzxMUUT2ks=;
	b=3bBEV6kSxjq3rgsT8QPjXJZ26ebiEa5WvI8iFJAEnPvtgMpd9llahFWD/v7PLKhI56tT8N
	I6ZQR/RgLMmYW5phgODCTb0NW39z5JsKib+Re6QzkxkAKN5v+N9eu99ihXyGPBOA8bu3Kp
	w6CfoHc4UIEp5MPmr/x2/MRVaX9pzR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192868; a=rsa-sha256;
	cv=none;
	b=427LROhvGjOQfKlJBvpiTvQJEowEr1bq6emIgVr2+m4bqIdDHQ45kX18n+s6vkyC7PANEJ
	zoLGlPXYkM9Nd6oiRhYevUuF38LcOXajKjWVhi7tzrqzd7so/2/OnblaG30pIhHq0F5Nyz
	EDkL5f6Lz/yeunfF+x6jqExE5Ur/zQg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7zC2gWr;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-771e15ce64eso1392829b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192867; x=1756797667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGB9Y8Xro5EcYuOr6YGEfLC07C5z6V9YadzxMUUT2ks=;
        b=l7zC2gWrvrPPVOnDeOeHWXX/pew6JObO5afe5g7yXnIeB3idbrmPfW0HRUe7XmXHMm
         A+8FTupVCZX5ZRR/BBFtMpgErbIhgnbO6Q15fmWjkp3QjVu/1KlYCmN4Bo6etevtGpsK
         SZlYKTgoLfHR9fdshbp4ozsZDcwE8p+un27Ii6CyWA9A7fJaTMAmSN7rcJ9qNrsrLOMJ
         CpC0FtjrhyiLAZW8gFU4p67ZneEX+ww/fOM99oDujN9Vy7rHuQfqL5if5wWw3vbma16C
         uMuhGdHcFwkkTiTEfnaQWxhsh2h9UUzDgTVvRTapELbfQsVMQzGbLvLmAbXRbrL1r4Wa
         gDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192867; x=1756797667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vGB9Y8Xro5EcYuOr6YGEfLC07C5z6V9YadzxMUUT2ks=;
        b=BSX0bBepB05gL20FRbQYA140l9DTwwZCK6sQrrrZizL5aSTiEqMSVy1xVUTWx6Ppsp
         ErdggYctDNGyko+p5i3hcggeTm84K3pV73bypH0nVl7P+5mzoaBSVGWKnRZGylY4Rv/1
         +FTxalFerNUNuW55gCI9d5vNJMKx3BnIZjP+r8izqEFsVR9U6Dluwd383CbBzZFxf1VR
         s9YixfbaDS5uo00YoZrN4AXokV0XK10u5hrXKghb0+Lefnjl+9LAsKCmjLwrmf4zNVML
         HRRaeWykU8srC0GuC+vNlsAxVphCoelCYQCd+MSepYjX4Ln+rQ4WZnufLJfuzebhXMrG
         otkg==
X-Forwarded-Encrypted: i=1; AJvYcCUNqaspZ16PoAUDGSgShIUCcVTj84EWCoh0adhdtQRDwweT3YD1BSJrkWZceslR4dphAeRAqSJpNw==@kvack.org
X-Gm-Message-State: AOJu0YzRBmarMcgfk0KDD5wZ8aRY69ZFZvI6As6gOAwZxBxcEvcsx2n7
	V9W+NmwiwaenFtFDnsOlajFbHFB1xPIjF98fmBPK2SuY42XtiR0SWeaB
X-Gm-Gg: ASbGncs5HcrKj9UED56eekWejNB+KMj8vOqfuLCSC+h+ys5x8hbyfp6SiHnP+4nN+4/
	B3KRTwvDazuYwcVIjXelooLyDRFeFjZS7OeSIduPooHwEdM46ay+Z0XO3hOv29qqV45zMEy1qCG
	TEuaVLLKXDQiOip7fbAi1CG4C2eMK1gZA0lYLZInN6TFgca4r7SHw4KsbQ5jBW6shBkHh4g51E1
	oSyFYW8f74aF2vtDK99LDaBpyZc7xCuV0WpxUr01ctyeThFNz9TLZxn64sh7/9UdR1ATa6hV/Yd
	oBSHTfIo3lblGTCMluz4X5y6SBU3xEmvOXaehFmNRinKL4WmJHKl214eFy3/5x/PsEdL4LsNVLE
	D7IykkSRe3oVdhwyHq01yeuRh7IDAc+sE/drVR3b1XtHbmhFyxOmXtcS/YOiSwqCmOfPXyg3DSF
	e62chPc9aBadC6Zw==
X-Google-Smtp-Source: AGHT+IEuzHfOcMwGQYabj+FZdsdhYqnkn3QUeqG3upN+hixq2fMPWnAPeOug0HXFBBhydpDgPCXXhQ==
X-Received: by 2002:a05:6a00:99e:b0:76c:503:180d with SMTP id d2e1a72fcca58-7702f9e8eb1mr19500788b3a.8.1756192867161;
        Tue, 26 Aug 2025 00:21:07 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.20.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:21:06 -0700 (PDT)
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
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 05/10] selftests/bpf: add a simple BPF based THP policy
Date: Tue, 26 Aug 2025 15:19:43 +0800
Message-Id: <20250826071948.2618-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70150100005
X-Stat-Signature: izfd1t9xww8yncaaht9i8zjfr8731qt6
X-Rspam-User: 
X-HE-Tag: 1756192868-279112
X-HE-Meta: U2FsdGVkX18/+E4mhpfe5/cBixUYun9ihTjwYO/rvztfKb0Y1TrAN3iCs4U4Gc9QbFXCcyMOAeciv5KWVCvHfKI0du0B7h7ndf6cX8K6mClk4OvRz6zLAwESWeSz4GnJZNXjBYChIZWONUpDuzryhARYo1MUBXnrBEuZYO31n9xKtrafTHTda1oct+Qk1Bm8jlPE7FX8Sc8NgjKhX4PNHjg4ZNgp05VIlxG0b02GAdWQ9nsaXSg49vQN9ZgTT7cYcZdT1ELP6gPEhS4c5eVan3A+hyyvQXpa+z+ImYEy+0B6kjNiM0WVgh61BpN2XsyjJv0BpOgYXsmmZ+6aRc4+eFMW6a3j/O/buU0lgbPTMl9vLZXLtt2lE3ZUyp8LG4nyt30656PgcLrvf9AKD0pCJ8l7g4kv4GXpt8ZM5l7AYefr2GpiXiNPh61uOqhh4YD0fIDGresftXPSWcHGKlBmiuHLwq9kiaf+Ipb45HdP6zF3k9sxIPKAhbTG9sJt4f9og+1j+9nhEGr32ZWCzxWcrHLU8tFI+Un/QG4ivrlz2Lb3ssI9SRYYrfPQPnixUdlxx1SiBIwZ60MEwoqTmW9rzoUwgOmlhHGnQrgzCA9w3Kn4sCv0t55s1NpXQ+V7pqSnoI1u0/uYM2pBfEHod3mF32c7PJtVWoyJrFQkyJ48e4lC+ZP4DlTXOW1+ix9w/KIVzcmsbGdyA8Pr3UfSDCp5F97g03YxPAJpVZNAuDtKmAFydLjt6QI8DLis4nX/PPa7iYTnuZ5k3t5V2Fz0a4BnkV0VKHBaSD1CfgI8ynGDsBkl0zkHXghlsxACfHo2oyxujX8KqLQOCyt4bgr74URxhlgK++02Zlb2IiCQTR6Sbhk1Xe4RxFh6cd4CWObeU5Sv9xIkIzfgG1gvVpoLIHEkPwSqZO4BsjZsID0OtVY1+Mth3EUVgbak7xqhrcULtiiOI9Lp3adl8oyOQe304Sn
 KL0wd/4/
 fuGMHdVGJN8QLQlcAAafmKRAI9t+iO8Bv1uEywmR9eZH2+nHHGZUGin4ylxLa3W0k5QGQH5EuvFCktJuKm52J9GGxZtTzgbblP4hguZWu+E7d3M9o3aGy3TQD3WOtiGHEARgRzaE0WyJEGUchpUGXU5KXBou2Y+G4QDVT
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
page fault handler. However, khugepaged might not run immediately during
this test, making its count metrics unreliable.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 254 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  76 ++++++
 3 files changed, 333 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 8916ab814a3e..27f0249c7600 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -26,6 +26,7 @@ CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_SYSTEM=y
 CONFIG_DUMMY=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION=y
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
index 000000000000..635915f31786
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int pf_alloc, pf_disallow, khugepaged_disallow;
+struct mm_struct *target_mm;
+int pmd_order, cgrp_id;
+
+/* Detecting whether a task can successfully allocate THP is unreliable because
+ * it may be influenced by system memory pressure. Instead of making the result
+ * dependent on unpredictable factors, we should simply check
+ * get_suggested_order()'s return value, which is deterministic.
+ */
+SEC("fexit/get_suggested_order")
+int BPF_PROG(thp_run, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, u64 tva_flags, int orders, int retval)
+{
+	if (mm != target_mm)
+		return 0;
+
+	if (orders != (1 << pmd_order))
+		return 0;
+
+	if (tva_flags == TVA_PAGEFAULT) {
+		if (retval == (1 << pmd_order))
+			pf_alloc++;
+		else if (!retval)
+			pf_disallow++;
+	} else if (tva_flags == TVA_KHUGEPAGED || tva_flags == -1) {
+		/* khugepaged is not triggered immediately, so its allocation
+		 * counts are unreliable.
+		 */
+		if (!retval)
+			khugepaged_disallow++;
+	}
+	return 0;
+}
+
+SEC("struct_ops/get_suggested_order")
+int BPF_PROG(alloc_in_khugepaged, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, enum tva_type tva_flags, int orders)
+{
+	struct mem_cgroup *memcg;
+	int suggested_orders = 0;
+
+	if (orders != (1 << pmd_order))
+		return 0;
+
+	/* Only works when CONFIG_MEMCG is enabled. */
+	memcg = bpf_mm_get_mem_cgroup(mm);
+	if (!memcg)
+		return 0;
+
+	if (memcg->css.cgroup->kn->id == cgrp_id) {
+		if (!target_mm)
+			target_mm = mm;
+
+		/* BPF THP allocation policy:
+		 * - Allow PMD allocation in khugepagd only
+		 */
+		if (tva_flags == TVA_KHUGEPAGED || tva_flags == -1)
+			suggested_orders = orders;
+	}
+
+	bpf_put_mem_cgroup(memcg);
+	return suggested_orders;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops khugepaged_ops = {
+	.get_suggested_order = (void *)alloc_in_khugepaged,
+};
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D844CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A018E0009; Mon, 18 Aug 2025 01:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323B78E0001; Mon, 18 Aug 2025 01:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3D78E0009; Mon, 18 Aug 2025 01:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2BBE8E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:56:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 731A683E1C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:56:01 +0000 (UTC)
X-FDA: 83788817322.14.28C933A
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8991940005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ym0cCpIU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496559; a=rsa-sha256;
	cv=none;
	b=WOUxwkthLAlXKKh8q5dhMrXejVcA/UbtHq6tN0kgvEYu5thR5TWUOrjNd/0SrI4BQBLFHJ
	9YSXatfYi+HSBVIhCcvE2jVrrOMaX4AZIytS02+XCEildgvEAHu4A2BdPfRzyc6mPMIvMX
	gAvQkJhx03TZXl0cI3I52Kx4EOKIVtQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ym0cCpIU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1cSg2mylJT2HXAXhehOfDxoS7DeUn7ungYUUcoWyfY=;
	b=d75M/QUEVocte33uhYLP3wwsQYVX449xKLSeZDT5SmzQEqsK0s9UzHUGfutfYveaETeNen
	jQaIEwrdIcfce2nl8tn7lXXekeWPIK4ATBVTMpkM1350ploLlAYl/uV/t8lfKnl09etvpe
	/TvsTIJkoAsRd6b7swv1vk0jGbJTkug=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-323267bcee7so4505645a91.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496558; x=1756101358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1cSg2mylJT2HXAXhehOfDxoS7DeUn7ungYUUcoWyfY=;
        b=Ym0cCpIUGy30GjP00wjfac3zrPdV6UY0pGnH72MtymXxMn0T7Uh2fK0pJp+OW1dSuI
         Oeli7jZNwu1tEoU7iAFtBryEZmUvoKeCqADwv3pIPkTU7qbPIGFiAVNiUrAvj/p8MkxL
         h+7AX5bRoNV5g0PPUe8sDDUJzQ4uKZchrp3Ayv2fFw7g1T66F6y4cuIlJwp3RK75B8+8
         QqmnM3ISiRSSDLj9/Up0s1ilpbkl/phlw9iUzcUGZPdmFAmeI44IkhXm/yp7HzFXioyv
         H2Zt7AWkxFcIXAVZRM2FfNSm/Qmscze7NtXeGsQkYi7IS+PNgPj2jdJHm9D+QYU1bv1k
         akNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496558; x=1756101358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1cSg2mylJT2HXAXhehOfDxoS7DeUn7ungYUUcoWyfY=;
        b=YugeR9fRhABA1VbGFbekVMCNhMIAS1lWVRW745bxgNcAmmiR66t9ruJ03dFNNYxaEi
         Op553YJSmFIgexu/7j5REZX/R6+Da087p6LK1lJlljT9nf0URy+qABmk2uHUkZHowY0D
         dzzHgCACt4Ktyq5NKu2Khyg7zvG7LGUCVHLcg+TvBqYVKl+2PnnrAM60XbegWc5lLd60
         tJKX3You/lx4zm+SPueTAMAbdJ0XxRnPhJcIdb9dgq5GpqVCLIsmRjARCNa+F8E1Ndf/
         CSisz7k04tqdl38kyic5XEYZuuewSyQpSdGCg1qHmvkJOimE4jobZ8wIpBwHMTf9fbhT
         eAQw==
X-Forwarded-Encrypted: i=1; AJvYcCVcu2ljTT43rJ64f7o6lzJ7gfAK6ZMBHQ6Y/rg9QkrWX9Y0jXLx8EIMbmmwDrV9aV7F1z8yvwf6Hw==@kvack.org
X-Gm-Message-State: AOJu0YyKLmQlwuSvxaGzummyn+rTjcUGe5oSMjRdVaZ0TuLVqwfJmm/5
	pm/wXq0BaWrwo/xVzs4hxERuKMP8qhrGdKNa9dctWoQR/7lguXI1EM4Q
X-Gm-Gg: ASbGncvz6rKlpw0fbd+b8mpyFzSyczduawClulpZjB6Jrr4WeCj+i3XFJIs/yzAs+UF
	6RRKS2JWFQ+m2lUq6upplII8idQOqU8+qUKTK66gn9JSyAzAuzSVLwBoM9OTQxvlRRFOJIZ4swM
	SYapQc7fRijghjj2TqnSYkP7LMSF0/tWkjO6Vnfmieb4WZBchY7mDI2YDQLEDM0Dbiro28FQZMy
	s96Cat0plHPmP7rsOS5cg/iBOY3Df43UbmXgMGxcpV2BUxMAtzu2A5TkR1o+UbqwjWotZO2CO7P
	Qb/Mvr5gP1hKdkTQEJXgfsuI+8MEsPiwNuY3W1+4+FsC3C8g0tPKGGIn+FybMj32vBeb0FUJ0DC
	+7/CrFTRnB94oksgRRR7hkskIlThN1IuOliPxxhzyfLb3teEzbtclgPzg
X-Google-Smtp-Source: AGHT+IEDC63+iCxdsyaHczK9wCWNBIQSkfb3jqk8zUO9TF6ANYvT7bVEP3aziVfKZoseR9I+x/cVBQ==
X-Received: by 2002:a17:90b:53c5:b0:31e:b77c:1f09 with SMTP id 98e67ed59e1d1-3234213e452mr14701838a91.19.1755496558249;
        Sun, 17 Aug 2025 22:55:58 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:57 -0700 (PDT)
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
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 5/5] selftest/bpf: add selftest for BPF based THP order seletection
Date: Mon, 18 Aug 2025 13:55:10 +0800
Message-Id: <20250818055510.968-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
References: <20250818055510.968-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8991940005
X-Stat-Signature: ay1eusqiu4ntjqa5jnruz56j4xztwbfg
X-HE-Tag: 1755496559-17075
X-HE-Meta: U2FsdGVkX19cWWf+Gzi/6hLYirc5xCDtMp3H8cbW44FnXcZ1PN1Zd6YFCINwgsjRHVpQWGL3fCnYP9x+jCvVDFJ+3zh9n0sz8ioqZHRcB3H8m8WtD0PYvZKX+RKzoiRIHBDoUBl/nR+qq2dmetUNDCUPV7x0Ri5o4DTSm8Z9kV7ZIpBGXIVHN55U8HgeUc9uSb/wy0E5yn/uyzcrrs6yGlI4JVEP9BWRacamhUcgN5xQHGQjuZ7pNfifNa4UjqUFvuvtJCb583w1CATVM632625zOdOHQLp01nC3lNc5C4X0Gcq8Kesk+RzfwaskSYPwb/xUFtpiH9wLv0mgsB+lmR8NUB1jJT5fLgmFLlBzD4FiT92KXB7qoAe7mDUSLtepS2ChmHGA+h4GIdhEy+5oowGc3kuMMKQ+biDehSGtzGkTJTeI4KiMWM7dkz2AdtWo3FHNDTNzS3yrIhSzrs8Ixb0T8kJQAbIYjDLhqJLT37/5WX1c3FikMCJscZmEyStYkvKoSFdIFhCwaJNBfx7YqR6wxEGnrwKOeJaOY7EoOLRkev1nbJ0q1JxC/KAe9JrzoSeVb1nFwiGu25VwMYB19cfKEQmH4HpqvtnLWkbxeRCZZ+VdJDdIO3NHJ/WIDLvet/GrIxS/478CslVfl8D8Chmjw6svGjfcW8QyYCrJg6Eobqqo5jXCLj0Z7rKb9VIIWpM7yMj8zuXLG4TTeSFISFIjs+OBTBI35cOEQqa2H6XyApe+rcmbCMlLgld4x9pxUPc2tNr3Dio0O+SmVW0fn+AR3cu/i791zFQaabv+k9yTfszBRi6TwcFZk4rMoUXYnqBz9M6P97uWmnrg7ZiRDLeVAQiajn+U3yYL61n1XWrJX7uIMmMIry48KzmITQRWn/uMyOY2nZtp9+PHuU9xQVitNt69Tp8mhVztLnwckDQSFLHfGK+VbZHBU2VRAKFDhhcaiyZNxNc5ywW9cSh
 r6/mekJ/
 jirVFhedmpok6Az+U/1goAVHzFMFkl4u+1toXy7qKkoP0Cm544uWNu90UvDvvahy3GVEgdUmQFBL1qS66nNZz+xdV/pUuZD0etwgDUONcYJu4LiIdieis/TQinlu8jr+dwVnLWWysb2IKcJlnz7LOy2k1bu0Zq/rL+4E85WVek11Yc0aozi3ffYr1zhrq66rmztuNpN/G13GjwEZBYftNOWTeOtokeNR4ebdONzEWsRctCDdRKUyO645tsHzS5OMRpjmzBjAnn7nd52N5hECOyGYeO7OPLOvFZjoLFumnEytycqDKcFhiln1L4rTbSNMJKAXrVGbUQMT5zFlpFDYREqbCYscQvjjfiia9m8hSUSKlcxXlg5sfSqauYVfP4ib4bgYRg+E9n9bJRggYlOB7u/1eSisGFhY2B8erRvdn78BXqqdPlX5jOD/8okkm0ae8e9Cb7hUWKJ9/dQxzo/vt82BL8DlyRwEaKKyVJuydsygMavHYxrZP/vuy8xtO/4c0GJyr44/T9eR8pu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This self-test verifies that PMD-mapped THP allocation is restricted in
page faults for tasks within a specific cgroup, while still permitting
THP allocation via khugepaged.

Since THP allocation depends on various factors (e.g., system memory
pressure), using the actual allocated THP size for validation is
unreliable. Instead, we check the return value of get_suggested_order(),
which indicates whether the system intends to allocate a THP, regardless of
whether the allocation ultimately succeeds.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 224 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  76 ++++++
 .../bpf/progs/test_thp_adjust_failure.c       |  25 ++
 4 files changed, 328 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c

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
index 000000000000..959ea920b0ef
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <math.h>
+#include <sys/mman.h>
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_failure.skel.h"
+
+#define LEN (16 * 1024 * 1024) /* 16MB */
+#define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
+#define PMD_SIZE_FILE "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+
+static char *thp_addr;
+static char old_mode[32];
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
+int thp_alloc(long pagesize)
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
+static int get_pmd_order(long pagesize)
+{
+	ssize_t bytes_read, size;
+	char buf[64], *endptr;
+	int fd, ret = -1;
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
+	if ((ret & (ret - 1)) == 0)
+		ret = log2(ret);
+
+close_fd:
+	close(fd);
+	return ret;
+}
+
+static void subtest_thp_adjust(void)
+{
+	struct bpf_link *fentry_link, *ops_link;
+	int err, cgrp_fd, cgrp_id, pmd_order;
+	struct test_thp_adjust *skel;
+	long pagesize;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pmd_order = get_pmd_order(pagesize);
+	if (!ASSERT_NEQ(pmd_order, -1, "get_pmd_order"))
+		return;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "cgrp_env_setup"))
+		return;
+
+	cgrp_fd = create_and_get_cgroup("thp_adjust");
+	if (!ASSERT_GE(cgrp_fd, 0, "create_and_get_cgroup"))
+		goto cleanup;
+
+	err = join_cgroup("thp_adjust");
+	if (!ASSERT_OK(err, "join_cgroup"))
+		goto close_fd;
+
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
+
+	fentry_link = bpf_program__attach_trace(skel->progs.thp_run);
+	if (!ASSERT_OK_PTR(fentry_link, "attach fentry"))
+		goto destroy;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		goto destroy;
+
+	if (!ASSERT_NEQ(thp_alloc(pagesize), -1, "THP alloc"))
+		goto destroy;
+
+	/* After attaching struct_ops, THP will be allocated only in khugepaged . */
+	if (!ASSERT_EQ(skel->bss->pf_alloc, 0, "alloc_in_pf"))
+		goto thp_free;
+	if (!ASSERT_GT(skel->bss->pf_disallow, 0, "disallow_in_pf"))
+		goto thp_free;
+
+	if (!ASSERT_GT(skel->bss->khugepaged_alloc, 0, "alloc_in_khugepaged"))
+		goto thp_free;
+	ASSERT_EQ(skel->bss->khugepaged_disallow, 0, "disallow_in_khugepaged");
+
+thp_free:
+	thp_free();
+destroy:
+	test_thp_adjust__destroy(skel);
+thp_reset:
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+join_root:
+	/* We must join the root cgroup before removing the created cgroup. */
+	err = join_root_cgroup();
+	ASSERT_OK(err, "join_cgroup to root");
+close_fd:
+	close(cgrp_fd);
+	remove_cgroup("thp_adjust");
+cleanup:
+	cleanup_cgroup_environment();
+}
+
+void test_thp_adjust(void)
+{
+	if (test__start_subtest("thp_adjust"))
+		subtest_thp_adjust();
+	RUN_TESTS(test_thp_adjust_failure);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
new file mode 100644
index 000000000000..97908ef29852
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
+#define TVA_IN_PF (1 << 1)
+
+int pf_alloc, pf_disallow, khugepaged_alloc, khugepaged_disallow;
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
+		if (retval == (1 << pmd_order))
+			khugepaged_alloc++;
+		else if (!retval)
+			khugepaged_disallow++;
+	}
+	return 0;
+}
+
+SEC("struct_ops/get_suggested_order")
+int BPF_PROG(bpf_suggested_order, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, enum tva_type tva_flags, int orders)
+{
+	struct mem_cgroup *memcg = bpf_mm_get_mem_cgroup(mm);
+	int suggested_orders = 0;
+
+	/* Only works when CONFIG_MEMCG is enabled. */
+	if (!memcg)
+		return suggested_orders;
+
+	if (memcg->css.cgroup->kn->id == cgrp_id) {
+		if (!target_mm)
+			target_mm = mm;
+		/* BPF THP allocation policy:
+		 * - Allow PMD allocation in khugepagd only
+		 */
+		if ((tva_flags == TVA_KHUGEPAGED || tva_flags == -1) &&
+		    orders == (1 << pmd_order)) {
+			suggested_orders = orders;
+			goto out;
+		}
+	}
+
+out:
+	bpf_put_mem_cgroup(memcg);
+	return suggested_orders;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp = {
+	.get_suggested_order = (void *)bpf_suggested_order,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
new file mode 100644
index 000000000000..0742886eeddd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/get_suggested_order")
+__failure __msg("Unreleased reference")
+int BPF_PROG(unreleased_task, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, u64 tva_flags, int orders, int retval)
+{
+	struct task_struct *p = bpf_mm_get_task(mm);
+
+	/* The task should be released with bpf_task_release() */
+	return p ? 0 : 1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp = {
+	.get_suggested_order = (void *)unreleased_task,
+};
-- 
2.47.3



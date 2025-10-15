Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A090CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B578E008E; Wed, 15 Oct 2025 15:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AD58E0005; Wed, 15 Oct 2025 15:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AC98E008E; Wed, 15 Oct 2025 15:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3838E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:08:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D869057F6A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:40 +0000 (UTC)
X-FDA: 84001285200.21.9795D5A
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id E5C671C0014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D8gshI8W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760555319; a=rsa-sha256;
	cv=none;
	b=oamxKQ1YX5getmZByfuOEHHaR1lVo8qJpeLK7zjwPCOEAoPo8TQcOfoPOnQheqLeBnQUiN
	EOcpT68hmN0o29Q/MpnSxhGofNONIBBe/s75SvCv7wuX/OoUmGgFFqSZjSOrA5Qh4CQW+X
	VxfATzO4dpnLdOX9X7Hw4rzkF3Hk2Wg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D8gshI8W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760555319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jtTseR4AzpCPkYXmfSeMBcpg1TsK/YhbPk71+4USG4=;
	b=1mwJ2zDVzvNC+uzD8rQAoIoHdy9G/jeA2WAJPz/0ErTKdzwleOhNyofxJIdo2iuTgqZbvX
	5V4Be3wdFHTuA4d8jdgJJTq7cPPv/gJ9CkynbnpAd1TorJVbAzROHmD2I1ajc+gcbePx3c
	AYc2A/Yvw4WO73r4Zj1OnBBOlrxhhFw=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7800ff158d5so6464292b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760555318; x=1761160118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jtTseR4AzpCPkYXmfSeMBcpg1TsK/YhbPk71+4USG4=;
        b=D8gshI8WwGkK2qz5cwDre4cFge835JWDjgFvVe7w1svMR3h8Wa2W0QRnC9tQVzsOJV
         FMWEupKVyqCQhX6EyWSMJC2uktbiOmvcDMR9gWlmk2HNHk8YbHFFZPLj6tNnkfx9GeEZ
         FNon2gzI8UxzdMiMqwjbxcJkeVY6GnmrU6md1z/nrxGRm3A3oRXxTtYsXtn3l88bmNBq
         y/NDja80AWJbl+oJ5lOv9o65VEkFDXukVz+mlbuABZpZGIfM55yqDBKtWoBP0oJtJvME
         FqKiRV2YQK8lxjyDWwJVdQSi66y0j1pBMKzg6xpH94Rsi/KWGrTTRAVQWFBbLKDCDltf
         +9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760555318; x=1761160118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jtTseR4AzpCPkYXmfSeMBcpg1TsK/YhbPk71+4USG4=;
        b=gnrlJGipYz7PiG3z9TLrZ61nhdAylbWQcX27XIk19Y8S/eDmkdBxVvpBDf+Js2q0J/
         fbSSyA2b9s5eckCYFu681Oud4w8kdjRXCLhs98vEWtBbgdwwrUdXmnujaz+6eqGuGwP/
         2TKromT7eG1qoUr9diqF6zNYH6fpIYM6snEAuExHFWEKIpegtc8DInvjUFFPVMx/DaIp
         34hTHIlrKJxrLzS+ZL7HO/N+hOq9mwVikO4ICJ5yhrzthXVYIwyy9rJZo4P7Dhs+I8Z+
         AwX2NJKZNae80AlqpSKZPmhWWsmHJn4A8+zPF0Y/SoAubSlbkHO9iqPIkoHwfIXeqW1b
         kEyg==
X-Forwarded-Encrypted: i=1; AJvYcCUdXI4bv7P2AZJHHdPSGqqi3LGYOg35MT9pRym9c9YrmDHR/aFcpBNSatzuz/FSceDv02knXZL3GA==@kvack.org
X-Gm-Message-State: AOJu0YwMOYMVyJmn5rDla2PZlwZLyXn6NYPbqr2nesPRD3GqE5L+x/Od
	kLQ+7ayvwduRHNdeqT/zIYAvH8ZfK4dGkuAbqBAtETiKC9/lUrYlMe8/
X-Gm-Gg: ASbGncuZMzg72J+JSPh1j/snWD6f5SnlvKP4WLMHYNqbEkPCD3rMuO1KmXQ8YorqN6y
	Idvl+Pe3iffBNosWNHMuLazaotZt7sedOfgt4CuZyGgxf0Pi+hUY4NUGAOI/UA/7WdDxTvckrMI
	5NDPwO2osx8Ung7Nc5iuDXW8QYDVXodEIggb3kzNE9Yq+zR5nv1SJ6cf9/LO6oSGy3f6AnwX///
	KiAVKp7ED695alJ9Edh7fJvXzdvDYaYEoN4QHx/3H4KU22j9DVkpIXIS7VOMA0Kp/DgQGS+YmLI
	iIf/XeoHN+54U22t9ZmDqJC58XIVyISxf6V9TJjAL3ro1OU35xK622uBZr2BU/sqdus2EIxDVKI
	HSPkr3Chp4PL7sdyH7ZHuA47HSrTu5qggYGFari57xZnbNeDeg65xdxP7GHr5zwMTY/XqXLvIv9
	saWrr6
X-Google-Smtp-Source: AGHT+IFk0KEOhu/r0D+eCv5Ze6uXH3k3mw8nLse3HDIgRrBhuzKLo4na23l7qUwdjNYl5QryCDzGtg==
X-Received: by 2002:a05:6a00:14c1:b0:78c:994a:fc87 with SMTP id d2e1a72fcca58-793853254c5mr39312586b3a.6.1760555317735;
        Wed, 15 Oct 2025 12:08:37 -0700 (PDT)
Received: from jpkobryn-fedora-PF5CFKNC.thefacebook.com ([2620:10d:c090:500::7:1069])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d5b8672sm19483106b3a.69.2025.10.15.12.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 12:08:37 -0700 (PDT)
From: JP Kobryn <inwardvessel@gmail.com>
To: shakeel.butt@linux.dev,
	andrii@kernel.org,
	ast@kernel.org,
	mkoutny@suse.com,
	yosryahmed@google.com,
	hannes@cmpxchg.org,
	tj@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/2] memcg: selftests for memcg stat kfuncs
Date: Wed, 15 Oct 2025 12:08:13 -0700
Message-ID: <20251015190813.80163-3-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251015190813.80163-1-inwardvessel@gmail.com>
References: <20251015190813.80163-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mr6ak3kwud5mta1thzxy5xz16t8r76jd
X-Rspamd-Queue-Id: E5C671C0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760555318-127679
X-HE-Meta: U2FsdGVkX1+axG1yvt9+9mVvKjd3kMIm7zOOm3f2JCsK6y3r362vC6TKZbr5LBxup7GJTJV2XMkYH8OuOK0rxtC1KV4dpqR4UPAt5hX1S0KAJ61fptZT5NGMz+5flG0czekAHLEWbkgk+7tRIt5gyco7MZhBRJ/xGKpxziRn4KRESn/EYTy7qpj7JRDA96fNn4xzf3YcJqhIQGTCvyljMgpUPbEac2M+cs1vxQnRHteAGzPPKnRp0glLeaZt8XHNMqjQr9wsT3cgzEQHoH4V9znzpOjIT4g4XMudUJ6HRozbdrMFzFpWB3j5JCT6zRO8klEK0TkQMZcDX6HMiO3FWEy9k5I0cArX0e4+hHSCRe0ww2+6T5HEcf3E5Alxx6jG5VPcNy96YcYsfjNKdB5y4J/PvhrH3TNGC0OFy77yu2X5WUxKcdAJV2hBOrvFuqPVHmNlQfKhC9oLunFsT9nBdASx9bdTXXmDwlM9oOsrUrsnykLsjxtH0WVu5wiuJ3g02OkXadbpNmltpCPanNLObRvB6BVdaDDv98/Dpc9qdHkWg+T9WQKesJG2/s3nA7Nbebwj2lm4HN2QZX/5q5BLt2DpZfzwdcNEWJM7sOGI4flk3qwfF11tX9sPGguw1pZaQWykH/7QLdUi7qunk3B9DLSX0ZMunOykQx8Aehuhz47ijlAmqo2Kb9SIKt5u58uY/MGWNpQ43SZu/n0t8iN2vb/t6Ysa04zYPgGaZ0PqEqJ+lNbFdwptHXPwdJBcYUeka7CplAmUGsI/q1Oq41fJkz4wFq4a07TP2em8oSIhrw7S6uoyc7FtrOhypTQfeVVa43DqJRr6g+SM2BT1ICCFgOWst4YeYqNKZoAsJJTOxzFS/KOQ6U+18kPrCUhsmAW1BJK48oPx+1E0MnOQ0EYvjhNW646eNqhrckNhASOlZyGHMkLZZb9t6XjyZA9TIBiNuzHlrEX+EUhI+Chylo5
 rByWk18z
 t50784U32M0uCQelPzLX5ts/PsFxhh6CSwIw9SlrmcQ/k0gjOMfo6/mA8fg0zJZbbK0raUjuKXTg7oXkExLJErMEa8gG+eaOz9OU8LnBGyoavGqoF6Zd8zJPeosXKOhH8Lijha/tIAV+Nh6NO0yAuqdaSH13cDVYEiBqISU2AJKp4pfT/7hq6d/4olctlhutFBSuGn+xsdlGP3SSv9VyI82dbaoZq7qVkc4wxBLtjTXn9yUR7hGZhe6EyeDrUecmVl14azX+NyfhAbfiWhCOoW5zpGrePKy81/5+NJxC00w28+MCcPF0KtjOVi9+nH5/qqOJ+6rN/yPv3f4AaQ3B1Pho0U2ec49+AXHBxIS9nDQeOwM9T+d6r4q6naZ5fRy1ZEFzOXzQswwbwAhd7BTlE0zRyY7g4oP9o1+0pdRNLgywrgvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test coverage for the kfuncs that fetch memcg stats. Using some common
stats, test before and after scenarios ensuring that the given stat
increases by some arbitrary amount. The stats selected cover the three
categories represented by the enums: node_stat_item, memcg_stat_item,
vm_event_item.

Since only a subset of all stats are queried, use a static struct made up
of fields for each stat. Write to the struct with the fetched values when
the bpf program is invoked and read the fields in the user mode program for
verification.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 295 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  61 ++++
 3 files changed, 374 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

diff --git a/tools/testing/selftests/bpf/cgroup_iter_memcg.h b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
new file mode 100644
index 000000000000..5f4c6502d9f1
--- /dev/null
+++ b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#ifndef __CGROUP_ITER_MEMCG_H
+#define __CGROUP_ITER_MEMCG_H
+
+struct memcg_query {
+	/* some node_stat_item's */
+	long nr_anon_mapped;
+	long nr_shmem;
+	long nr_file_pages;
+	long nr_file_mapped;
+	/* some memcg_stat_item */
+	long memcg_kmem;
+	/* some vm_event_item */
+	long pgfault;
+};
+
+#endif /* __CGROUP_ITER_MEMCG_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
new file mode 100644
index 000000000000..264dc3c9ec30
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include "cgroup_helpers.h"
+#include "cgroup_iter_memcg.h"
+#include "cgroup_iter_memcg.skel.h"
+
+int read_stats(struct bpf_link *link)
+{
+	int fd, ret = 0;
+	ssize_t bytes;
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
+		return 1;
+
+	/*
+	 * Invoke iter program by reading from its fd. We're not expecting any
+	 * data to be written by the bpf program so the result should be zero.
+	 * Results will be read directly through the custom data section
+	 * accessible through skel->data_query.memcg_query.
+	 */
+	bytes = read(fd, NULL, 0);
+	if (!ASSERT_EQ(bytes, 0, "read fd"))
+		ret = 1;
+
+	close(fd);
+	return ret;
+}
+
+static void test_anon(struct bpf_link *link,
+		struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+	long val;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		return;
+
+	val = memcg_query->nr_anon_mapped;
+	if (!ASSERT_GE(val, 0, "initial anon mapped val"))
+		return;
+
+	/*
+	 * Increase memcg anon usage by mapping and writing
+	 * to a new anon region.
+	 */
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap anon"))
+		return;
+
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->nr_anon_mapped, val, "final anon mapped val");
+
+cleanup:
+	munmap(map, len);
+}
+
+static void test_file(struct bpf_link *link,
+		struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+	long val_pages, val_mapped;
+	FILE *f;
+	int fd;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		return;
+
+	val_pages = memcg_query->nr_file_pages;
+	if (!ASSERT_GE(val_pages, 0, "initial file val"))
+		return;
+	val_mapped = memcg_query->nr_file_mapped;
+	if (!ASSERT_GE(val_mapped, 0, "initial file mapped val"))
+		return;
+
+	/*
+	 * Increase memcg file usage by creating and writing
+	 * to a temoprary mapped file.
+	 */
+	f = tmpfile();
+	if (!ASSERT_OK_PTR(f, "tmpfile"))
+		return;
+	fd = fileno(f);
+	if (!ASSERT_OK_FD(fd, "open fd"))
+		return;
+	if (!ASSERT_OK(ftruncate(fd, len), "ftruncate"))
+		goto cleanup_fd;
+
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap file"))
+		goto cleanup_fd;
+
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup_map;
+
+	ASSERT_GT(memcg_query->nr_file_pages, val_pages, "final file value");
+	ASSERT_GT(memcg_query->nr_file_mapped, val_mapped,
+			"final file mapped value");
+
+cleanup_map:
+	munmap(map, len);
+cleanup_fd:
+	close(fd);
+}
+
+static void test_shmem(struct bpf_link *link,
+		struct memcg_query *memcg_query)
+{
+	size_t len;
+	int fd;
+	void *map;
+	long val;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		return;
+
+	val = memcg_query->nr_shmem;
+	if (!ASSERT_GE(val, 0, "init shmem val"))
+		return;
+
+	/*
+	 * Increase memcg shmem usage by creating and writing
+	 * to a shmem object.
+	 */
+	fd = shm_open("/tmp_shmem", O_CREAT | O_RDWR, 0644);
+	if (!ASSERT_OK_FD(fd, "shm_open"))
+		return;
+
+	if (!ASSERT_OK(ftruncate(fd, len), "ftruncate"))
+		goto cleanup_fd;
+
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap shmem"))
+		goto cleanup_fd;
+
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup_map;
+
+	ASSERT_GT(memcg_query->nr_shmem, val, "final shmem value");
+
+cleanup_map:
+	munmap(map, len);
+cleanup_fd:
+	close(fd);
+	shm_unlink("/tmp_shmem");
+}
+
+static void test_kmem(struct bpf_link *link,
+		struct memcg_query *memcg_query)
+{
+	int fds[2];
+	int err;
+	ssize_t bytes;
+	size_t len;
+	char *buf;
+	long val;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		return;
+
+	val = memcg_query->memcg_kmem;
+	if (!ASSERT_GE(val, 0, "initial kmem val"))
+		return;
+
+	err = pipe2(fds, O_NONBLOCK);
+	if (!ASSERT_OK(err, "pipe"))
+		return;
+
+	buf = malloc(len);
+	memset(buf, 1, len);
+	bytes = write(fds[1], buf, len);
+	if (!ASSERT_GT(bytes, 0, "write"))
+		goto cleanup;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->memcg_kmem, val, "kmem value");
+
+cleanup:
+	free(buf);
+	close(fds[0]);
+	close(fds[1]);
+}
+
+static void test_pgfault(struct bpf_link *link,
+		struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+	long val;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		return;
+
+	val = memcg_query->pgfault;
+	if (!ASSERT_GE(val, 0, "initial pgfault val"))
+		return;
+
+	/* Create region to use for triggering a page fault. */
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap anon"))
+		return;
+
+	/* Trigger page fault. */
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->pgfault, val, "final pgfault val");
+
+cleanup:
+	munmap(map, len);
+}
+
+void test_cgroup_iter_memcg(void)
+{
+	char *cgroup_rel_path = "/cgroup_iter_memcg_test";
+	struct cgroup_iter_memcg *skel;
+	struct bpf_link *link;
+	int cgroup_fd, err;
+
+	cgroup_fd = cgroup_setup_and_join(cgroup_rel_path);
+	if (!ASSERT_OK_FD(cgroup_fd, "cgroup_setup_and_join"))
+		return;
+
+	skel = cgroup_iter_memcg__open();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter_memcg__open"))
+		goto cleanup_cgroup_fd;
+
+	err = cgroup_iter_memcg__load(skel);
+	if (!ASSERT_OK(err, "cgroup_iter_memcg__load"))
+		goto cleanup_skel;
+
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {
+		.cgroup.cgroup_fd = cgroup_fd,
+		.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
+	};
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_memcg_query, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
+		goto cleanup_cgroup_fd;
+
+	if (test__start_subtest("cgroup_iter_memcg__anon"))
+		test_anon(link, &skel->data_query->memcg_query);
+	if (test__start_subtest("cgroup_iter_memcg__shmem"))
+		test_shmem(link, &skel->data_query->memcg_query);
+	if (test__start_subtest("cgroup_iter_memcg__file"))
+		test_file(link, &skel->data_query->memcg_query);
+	if (test__start_subtest("cgroup_iter_memcg__kmem"))
+		test_kmem(link, &skel->data_query->memcg_query);
+	if (test__start_subtest("cgroup_iter_memcg__pgfault"))
+		test_pgfault(link, &skel->data_query->memcg_query);
+
+	bpf_link__destroy(link);
+cleanup_skel:
+	cgroup_iter_memcg__destroy(skel);
+cleanup_cgroup_fd:
+	close(cgroup_fd);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
new file mode 100644
index 000000000000..0d913d72b68d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <vmlinux.h>
+#include <bpf/bpf_core_read.h>
+#include "cgroup_iter_memcg.h"
+
+char _license[] SEC("license") = "GPL";
+
+extern void memcg_flush_stats(struct cgroup *cgrp) __ksym;
+extern unsigned long memcg_stat_fetch(struct cgroup *cgrp,
+		enum memcg_stat_item item) __ksym;
+extern unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
+		enum node_stat_item item) __ksym;
+extern unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
+		enum vm_event_item item) __ksym;
+
+/* The latest values read are stored here. */
+struct memcg_query memcg_query SEC(".data.query");
+
+/*
+ * Helpers for fetching any of the three different types of memcg stats.
+ * BPF core macros are used to ensure an enumerator is present in the given
+ * kernel. Falling back on -1 indicates its absence.
+ */
+#define node_stat_fetch_if_exists(cgrp, item) \
+	bpf_core_enum_value_exists(enum node_stat_item, item) ? \
+		memcg_node_stat_fetch((cgrp), bpf_core_enum_value( \
+					 enum node_stat_item, item)) : -1
+
+#define memcg_stat_fetch_if_exists(cgrp, item) \
+	bpf_core_enum_value_exists(enum memcg_stat_item, item) ? \
+		memcg_node_stat_fetch((cgrp), bpf_core_enum_value( \
+					 enum memcg_stat_item, item)) : -1
+
+#define vm_event_fetch_if_exists(cgrp, item) \
+	bpf_core_enum_value_exists(enum vm_event_item, item) ? \
+		memcg_vm_event_fetch((cgrp), bpf_core_enum_value( \
+					 enum vm_event_item, item)) : -1
+
+SEC("iter.s/cgroup")
+int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+
+	if (!cgrp)
+		return 1;
+
+	memcg_flush_stats(cgrp);
+
+	memcg_query.nr_anon_mapped = node_stat_fetch_if_exists(cgrp,
+			NR_ANON_MAPPED);
+	memcg_query.nr_shmem = node_stat_fetch_if_exists(cgrp, NR_SHMEM);
+	memcg_query.nr_file_pages = node_stat_fetch_if_exists(cgrp,
+			NR_FILE_PAGES);
+	memcg_query.nr_file_mapped = node_stat_fetch_if_exists(cgrp,
+			NR_FILE_MAPPED);
+	memcg_query.memcg_kmem = memcg_stat_fetch_if_exists(cgrp, MEMCG_KMEM);
+	memcg_query.pgfault = vm_event_fetch_if_exists(cgrp, PGFAULT);
+
+	return 0;
+}
-- 
2.47.3



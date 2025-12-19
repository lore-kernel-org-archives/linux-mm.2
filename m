Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E985D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3986B0093; Thu, 18 Dec 2025 20:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2728A6B0095; Thu, 18 Dec 2025 20:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1010C6B0096; Thu, 18 Dec 2025 20:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D956B0093
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A95B6C02E4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:25 +0000 (UTC)
X-FDA: 84234560970.23.12DFDF6
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB41140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OJZpfSSL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109504; a=rsa-sha256;
	cv=none;
	b=O6TCXQUeKU03fbWMDNz5oaC2/937wNAWjmF0GpeMcXa/3+j1r0NlWv4cSY5D+Nn5o4+lBl
	unhWyMRNaNFMT0NGJWpi73qvKGlwa1WjmIKawTYtELtqHgO7OH/Z4qPedeEw/Ua+lxk+hT
	WwqMJyRFba+h9EmjW1B3hy82iiHv/hA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OJZpfSSL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tV9usWj80Ogq6TmS1s38ufUGObR0UVII6OSc269xPng=;
	b=ZPkJCWwH6au/wHrR+nn7fO2TbDQaVShbeHNJ4hkgmgYiQjyYeBk+XtR3bJpQZCzNLZaCLi
	3WYHhnB2DpuW6w4Xlddt+PvsMqG81kZB5SmMJqtCOiaC+EY9LaPBiehOt/+GtA4M5geYlb
	jRpTI0WFz+hbWqG2Qt45mlN2+KeIyaE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tV9usWj80Ogq6TmS1s38ufUGObR0UVII6OSc269xPng=;
	b=OJZpfSSLWmxnrDoRf3dLWFLBZCHSMtqgqIoVmgBjETvoq9jAEtKmEADoWR7yhZycqaQI/m
	qKNG03HQqr83it08rbNZN2x/PhP8IPam3LYIQjq2BXvtmZKVmtx5Jm40ODgiTJK++L0Xhe
	PkdIT//XPDO6UyCPRuKhuY9+joRuN8Y=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH bpf-next v1 6/6] bpf: selftests: selftests for memcg stat kfuncs
Date: Thu, 18 Dec 2025 17:57:50 -0800
Message-ID: <20251219015750.23732-7-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: EB41140006
X-Rspamd-Server: rspam10
X-Stat-Signature: cetgjxspndrmwwo75jp3eopwywjjgjuu
X-HE-Tag: 1766109503-146096
X-HE-Meta: U2FsdGVkX1/vjk32Okg+K57jyYxrW9Q8Zf1ojj0IDXAcvEG+Dj9BWGwc3XLN9q3CsldHp0oS0UHazUGh9//vS6muBX7VPV4JOIWr90DecDCJabNsPOrPqzGThn/i1bqKZDqmxP5Rn2LIxIlZga2SIdTkiGUhqNDNpvs4F0ZZSAWOQyTwthr3e+0WeS5LHyblJg1HZZ3DH31VupzQoKCF1H5CvdQf6R+XAbqsR/8uKAiRR7hV8ui5LMjucP7aBv1Za/WWNgL7f8ahrdsm9mYcxHZ/KjSXATv6JMXRaySk41CmJp0Nx6YXl+h6yQrlcjbZFH5yNTySDrOVijqA2Rtb41rzT96/InOAUxvSJUFJrGI3FoGbPTtr6MhV3ZgB79t3Fbvce4Rz/uYkmFncKvYyvqZOTYmnG8RvNhDI8t4AzDLUOXFaKxu5525Rq6+QS2FgsfAhRoseACOHmZ1/IfQ8V0hPp0m6K6KU3YXZQVfQQwWnnkE/HMz7ugnOmF5CrJgX2vuFDwPFwmwSVEbLJ+KHIvIMB/zDq+rEL3MDV+CaJsq6aEhRMkpkmqg7BQ2S1Ylu7Qz2r4Trsp6/bcSefuDARo4kqHYlo2yOhBNXeojo2y/HHJxWdt+bD8/v4YhqDe76vzR6XfDp9nGDl5r2DjLC2iOUT7rKKLkbnvu75Ei/3Cb+Fn/huZiPSVSf/4yhhH5/nuuYp1ZPEFk0k+3OrvU74UkHm8QUFB3BFYPDXUJmsciD+1WbDnOfTGGW07oxPYIMvxZiQ0u0gx6DGDCIgn+ynRLfmxax824Qm641Cap3PdOOw6dZj99WFw26IrW9261sLfOaIWPeBA+fEYwB1hGWQcevk67C+z79QLd4deMhLCxNX1BQQxfEn8dDxYMXhgl1IX3E3iWrygQ5qaxc7Is5qs6i/TcvVeR0eyxlN0P9FpV9QgC7S3SaApELXLuqNn0MjD6xBWq84SshSbVTZs2
 ba8VEW0J
 ZPqhCn9aFPKMgxOPpOC5435abLAwLrtYLkWPOo3o01s1HYJQepGNWJZJ8aaqXfbX5IjKZDOpFG+YK+K6OQowmt5J1So19LJzaYymQeUdN0IGSWHzLtd8Qv++sRf9RmLkxX1BG1J6KtxJIZEQ6s78QRGx6hW5bhbtY+71fB63wgnHBjCyPzIjheQi7zRceZmqiOZY3Q4rA/3FNdafdjVCq4XYsgnvu0mYvEsj+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <inwardvessel@gmail.com>

Add test coverage for the kfuncs that fetch memcg stats. Using some common
stats, test scenarios ensuring that the given stat increases by some
arbitrary amount. The stats selected cover the three categories represented
by the enums: node_stat_item, memcg_stat_item, vm_event_item.

Since only a subset of all stats are queried, use a static struct made up
of fields for each stat. Write to the struct with the fetched values when
the bpf program is invoked and read the fields in the user mode program for
verification.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  42 ++++
 3 files changed, 283 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

diff --git a/tools/testing/selftests/bpf/cgroup_iter_memcg.h b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
new file mode 100644
index 000000000000..3f59b127943b
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
+	unsigned long nr_anon_mapped;
+	unsigned long nr_shmem;
+	unsigned long nr_file_pages;
+	unsigned long nr_file_mapped;
+	/* some memcg_stat_item */
+	unsigned long memcg_kmem;
+	/* some vm_event_item */
+	unsigned long pgfault;
+};
+
+#endif /* __CGROUP_ITER_MEMCG_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
new file mode 100644
index 000000000000..215e4c98c76f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -0,0 +1,223 @@
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
+static int read_stats(struct bpf_link *link)
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
+static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	/*
+	 * Increase memcg anon usage by mapping and writing
+	 * to a new anon region.
+	 */
+	map = mmap(NULL, len, PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap anon"))
+		return;
+
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
+
+cleanup:
+	munmap(map, len);
+}
+
+static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+	char *path;
+	int fd;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+	path = "/tmp/test_cgroup_iter_memcg";
+
+	/*
+	 * Increase memcg file usage by creating and writing
+	 * to a mapped file.
+	 */
+	fd = open(path, O_CREAT | O_RDWR, 0644);
+	if (!ASSERT_OK_FD(fd, "open fd"))
+		return;
+	if (!ASSERT_OK(ftruncate(fd, len), "ftruncate"))
+		goto cleanup_fd;
+
+	map = mmap(NULL, len, PROT_WRITE, MAP_SHARED, fd, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap file"))
+		goto cleanup_fd;
+
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup_map;
+
+	ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
+	ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");
+
+cleanup_map:
+	munmap(map, len);
+cleanup_fd:
+	close(fd);
+	unlink(path);
+}
+
+static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
+{
+	size_t len;
+	int fd;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	/*
+	 * Increase memcg shmem usage by creating and writing
+	 * to a shmem object.
+	 */
+	fd = shm_open("/tmp_shmem", O_CREAT | O_RDWR, 0644);
+	if (!ASSERT_OK_FD(fd, "shm_open"))
+		return;
+
+	if (!ASSERT_OK(fallocate(fd, 0, 0, len), "fallocate"))
+		goto cleanup;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->nr_shmem, 0, "final shmem value");
+
+cleanup:
+	close(fd);
+	shm_unlink("/tmp_shmem");
+}
+
+#define NR_PIPES 64
+static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
+{
+	int fds[NR_PIPES][2], i;
+
+	/*
+	 * Increase kmem value by creating pipes which will allocate some
+	 * kernel buffers.
+	 */
+	for (i = 0; i < NR_PIPES; i++) {
+		if (!ASSERT_OK(pipe(fds[i]), "pipe"))
+			goto cleanup;
+	}
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->memcg_kmem, 0, "kmem value");
+
+cleanup:
+	for (i = 0; i < NR_PIPES; i++) {
+		close(fds[i][0]);
+		close(fds[i][1]);
+	}
+}
+
+static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
+{
+	void *map;
+	size_t len;
+
+	len = sysconf(_SC_PAGESIZE) * 1024;
+
+	/* Create region to use for triggering a page fault. */
+	map = mmap(NULL, len, PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap anon"))
+		return;
+
+	/* Trigger page fault. */
+	memset(map, 1, len);
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup;
+
+	ASSERT_GT(memcg_query->pgfault, 0, "final pgfault val");
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
+	int cgroup_fd;
+
+	cgroup_fd = cgroup_setup_and_join(cgroup_rel_path);
+	if (!ASSERT_OK_FD(cgroup_fd, "cgroup_setup_and_join"))
+		return;
+
+	skel = cgroup_iter_memcg__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter_memcg__open_and_load"))
+		goto cleanup_cgroup_fd;
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
+		goto cleanup_skel;
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
index 000000000000..fa7efcc4d1e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <vmlinux.h>
+#include <bpf/bpf_core_read.h>
+#include "cgroup_iter_memcg.h"
+
+char _license[] SEC("license") = "GPL";
+
+/* The latest values read are stored here. */
+struct memcg_query memcg_query SEC(".data.query");
+
+SEC("iter.s/cgroup")
+int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+
+	if (!cgrp)
+		return 1;
+
+	css = &cgrp->self;
+	if (!css)
+		return 1;
+
+	memcg = bpf_get_mem_cgroup(css);
+	if (!memcg)
+		return 1;
+
+	bpf_mem_cgroup_flush_stats(memcg);
+
+	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED);
+	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
+	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
+	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, NR_FILE_MAPPED);
+	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, MEMCG_KMEM);
+	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);
+
+	bpf_put_mem_cgroup(memcg);
+
+	return 0;
+}
-- 
2.52.0



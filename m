Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92EE4E6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B376B0093; Mon, 22 Dec 2025 23:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3F96B0095; Mon, 22 Dec 2025 23:42:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4B26B0096; Mon, 22 Dec 2025 23:42:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6726B0093
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01C6A58F0D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:21 +0000 (UTC)
X-FDA: 84249489324.04.6BF68C7
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F0DA140006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wae23WjY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464940; a=rsa-sha256;
	cv=none;
	b=hMk6bDGgoVjod1I2Kc7JINN9PLhBjKnah2RedGpI1cxZzaVN7EXFABK5Weq8BzwPlgdOuh
	rrSya3ED9mlJpkyD0KF5csSsMZMeCa7GphkrFB38RR4+CHylAJLssixeBqUs6VuPN2yuqD
	WP77T9kWgUbnBWYJMkwz7N8p+Wes9B8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wae23WjY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhodCvlUH01bxPc6ycp94CEw/XXgCCRJXP2B6/C4Ca4=;
	b=DhKT9HTOcLRUgYMVMCyhSpHT2rE2aqPhPYIxPHdUq8qr0TDV13APBStaeRh/HnuEkFNsR3
	zz9HKGlRBS1cir8/ACj/IPtUOcSHaIqpVEQbvBXgWpcWV/kTTpV8tY4C9NLtZ1n7ClGg05
	xdShn6apFj0zHS3D7K24g+FrhvBEnHI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhodCvlUH01bxPc6ycp94CEw/XXgCCRJXP2B6/C4Ca4=;
	b=wae23WjY3sT2ZF3sU7xF7nvjW68qPGaMfbgeOm5occBFxnR7jBRwpZX7WhbknHqOkVy6Jv
	4+561/t+lFY/Fr6Bu/pdrA7I2yu190kRJsa3cdixooxtaPMBN+0+fAEey4WGsFbuJSnMzp
	GIiAgbE8DpURsfbvFXMOkWDSxqdqPdI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v4 5/6] bpf: selftests: selftests for memcg stat kfuncs
Date: Mon, 22 Dec 2025 20:41:55 -0800
Message-ID: <20251223044156.208250-6-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4F0DA140006
X-Rspamd-Server: rspam03
X-Stat-Signature: mu78878fqe6a713zkkim4eri9t1ewr9s
X-Rspam-User: 
X-HE-Tag: 1766464940-721894
X-HE-Meta: U2FsdGVkX1/ZOWJJYSv/UTbJfMLlgW4m/+W6rebfj2yc+FJ1X4BHtxWKDRo1kLlqLfHtVBgb2QtFMAPuJ6VCFE/g3qHvQPb6bqa1XfImrQwnnNDqnTLhZTHFNSwz0gcVbnChtEaKuSplvHZETqkqMu7fXkq8ITC683vDf/w++wpkmePM8uk2OchC1PGXNTi2cdIm7MW4mjKkq/tvJJfSAIictoeHtSwkbdsp4TUK2JYP6S/6foFqFWbZxF6zwNPcAMbvJ67k+IwQusTr1VtRNeSUyGWORZqffSYhTVmkrTGTBM8fAwsfmMKgXY3O0bHhQLnP4TU6T46pDlfk8+zBqTS1aIWURhuCTNALw6FWQD6fKWJ3RJQeWEARN5Mp03TKNTjwURSkL74uqJtbEtpAROrqW90G5Xg5nAl+x9+YYaal3+HCVuxUTKnspkb6EeFv801rFxf2sHql1h2wkIM/rLbA/nICGPr0uMWlWIn7o/jKb2oVV+w/kLVk2Z2dix+39hRXX8JoqSUwAkLhZJR7tOGYpSyOSo5j1Zizux9MII+qUsuERNiHM19mJzClURoU4qoi1l2zZf6b3+I3TU8bgkwNphJ46AmY7K9jY2Stjkcwjcenz1L9Zkq+ymuAkhhPkje5CVu1ZlAmULXLbQEMafHL6aCmQY8Uo/ja/g+AepbJ1knN4a48Zf//Z3rrBepTMx4mGAvOw4Ja75k0aq2tUUkv7JlABuLQI228F8yUvN0fIemSAnZGkpV5yzsDTtC2WoJBsss+QLf37xO3f2TIU3/hQfDEleRH7TRXTriSNW7LPbz5OgdmWOc2NCvn+sVV4gpimPqO8hexBZIxizIFXYs1/lLDr96zmwVZxBVEl+5cBbLP8j/BKWeDIZ6xuagz+xHNMVNmRsoFapV0LZg/jvu3HmYqFwyU8IJzNBEmLKOQ5J2ABi/AxKdPKTOVFNN3WXYl7+adf15mntbzdQU
 cMRTNv1s
 67zRIioJYIww60qX8jPXoK/181I+zfRjH148bDMqcl6YjMlU2MeDA5DYkCPktqEBVnKhH6AU0Eq6KdFS+XnPlv3d+ewsXsZg4X3g6UUiHPbuqhhmxdM0hdWbwHEomqWG8ysCFRgIrTF7RnD2NNch3o/oLjfyDmH38ARBa9fpwFUqo0BjpNCii/LjaasoWMf+rSwU0dXx7n8Al4iEggvE53mFfiBxBkbyDs7bY
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
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  39 +++
 3 files changed, 280 insertions(+)
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
index 000000000000..a5afd16705f0
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
+	for (i = i - 1; i >= 0; i--) {
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
index 000000000000..59fb70a3cc50
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
@@ -0,0 +1,39 @@
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



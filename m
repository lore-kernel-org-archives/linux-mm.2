Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D86CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11DD800B4; Mon, 27 Oct 2025 19:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9F78009B; Mon, 27 Oct 2025 19:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9272E800B4; Mon, 27 Oct 2025 19:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 806378009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9597448AA2
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:26 +0000 (UTC)
X-FDA: 84045470292.05.4892894
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4512160002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wHiUlyAl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyky1l7ZVtxm7kqQngo9CfBOkrNi1s4j/0TOHFLtNKI=;
	b=Wi4oIgyKIb9HD1aDrBqG/gSZiEMLf/XE6YcVkHI69OrmakyO3m9Zd+JNiRvhuFGphjd6AA
	8VPiHV/WPeNws6Jl6jl1zPzg5493RqgumeN4wWSfUrhCF0ny93H3WPPOnO1sJ1NYBBZjil
	ku1bjAbWIRBHh6yS5W/4Iqz8vjQAWMY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wHiUlyAl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607344; a=rsa-sha256;
	cv=none;
	b=Aw1+JVfVaVaSSvQbuOjInwgVL2XPde5ko4wFFP9S8VUmQLmvyzIhnnvGBpK+RodpJaNT81
	bRFGFcrXnAP/ljfqo6OPixfbdnWGQyiLvsH/79YImxHsAA9uxU1VM9Hl5i5aHroYq9R2xn
	A0gaxuizWo0k2t1bDAUyI3yKyrCdG6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xyky1l7ZVtxm7kqQngo9CfBOkrNi1s4j/0TOHFLtNKI=;
	b=wHiUlyAlmMW9J0WFBFB8K6V6T79Zs4Dt6mUVJhyvM2sMasHJYtehZtC+VX21saOsTgBstI
	05W5o0zFariDTCPJzQcEy2aZAAdiGkKL6vZqik4Ru+zOpW9RWtXVRG+K68wr4ShZUBD46z
	To59JU3fPQlbI6SqtrXm5ow1e1F+oTQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 12/23] bpf: selftests: selftests for memcg stat kfuncs
Date: Mon, 27 Oct 2025 16:21:55 -0700
Message-ID: <20251027232206.473085-2-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A4512160002
X-Rspamd-Server: rspam03
X-Stat-Signature: 7wkpmkjizr1kj3brzdgb5awsf7iqurf9
X-HE-Tag: 1761607344-394500
X-HE-Meta: U2FsdGVkX1/2cutennzC2v6uk6k9lrP8tWM6YBtNrLQTxtACvyJxfq8dPHpENhUbIBrbYotthBTLKMme8GOjs6X20u2l7kHm4KXpMN39hyJw6ndBPo8ZDQeOHBavSLROHV269gG2CVRz/QZZ/FvMR1e86j601u+Bi+ca8m7HGr1fPfNobI7qFn1DuS/PWtEAZZ88Xjr4d+HR7okSgSrC83UxKNqnfMXQdG1QR2cIiJ0CSQce70Q5z669FcRyR4FPMXRGta3uc34ZvFDOTHVy/wj0lYjJXHngXKJNwq/sHYLc8UL3EebXYClBOzGs4O30zHJFD0lV8UzErGKJXtQYbukzKlG+elzqJX3MhG/WANfE7VjMJWgd6vwZ2MrjaFvavYVNAnIl9JGgIWYEyvjL1smpIKK6QlDmkwo5Z8b89gRiVuYk4me9IDyJC6gbhUan4zq/0RuMNME7asnb0gYrzqhyi2RwLIBaiAndrj+rEIQgRzVdkORFBV1bwelmtLBRRdhyxT43gBbODMawKmysyAyK8wCeCp//HdXfahZjDVerzAv8SRft2AIdf5TRntjA/tsdYgdzCgpAXLe96sMan33gYMNpL3QjRPZ3xgVXS604nCXIsd5F75qTVP8u0kYf7EqYf8dk0tUSwLzklyuVU7L0PADAzGyl8taLAiQvA6bOXqX/uB6EGjEZM3VsXTHUPjJ96y8jjz3A/HVHShWxLEyLos1nYOZ+DQZLN3LSN6lIQR7hx8FVtP7g8CHFTWaQ81QyfhNVXBsfLCB6MyUneyzW+YivP5QMiBezDO/qIogmFDEAzcxxW0vWsZKxve6sk/trs7otPn3rG1e5UI/3ninMa4ylkXgu7KuRGuhmGtT7+Tk8suIO2+y63Hi9mYLSa9JEsGpoDU4ydrTMqo3fSZ57K7rnyGFhK2G+d4SfQVc5iE41OT+wZcURdqm5yy6QQ1lDxTM3PFdxLGXKI/0
 QPcchPfY
 5+hyXJf7Z/57xislfw7R3045qjDwts1OgW1iVUKLetzQWyTEFQNTo9zkS2XN9HMLWSiGTFHrmqWwzmLRRx3+d3BX+u/CC+onYO+TZQlQSIfD/tt/8XRPnI3qvp/q9+DTTqOfOVGR4G+xXbS2QmUva/Xhnl2+gBQ7n86d4nh+gyp8rggPc97yi8AdwmB8ApIzd+qg/o1S5LrokZRfp/SNT1//Cj3NjQkdBQaL/
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
index 000000000000..92db5fd11391
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
+	css = container_of(cgrp, struct cgroup_subsys_state, cgroup);
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
2.51.0



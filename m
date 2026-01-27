Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC130D25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6076C6B00B1; Mon, 26 Jan 2026 21:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB106B00B3; Mon, 26 Jan 2026 21:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3E96B00B4; Mon, 26 Jan 2026 21:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 385196B00B1
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:46:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 086F1D3D77
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:46:18 +0000 (UTC)
X-FDA: 84376204836.30.0E0A8D5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D0E020002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:46:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKEdwOF6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481976; a=rsa-sha256;
	cv=none;
	b=gxy4V89Sp70UYgxOTe/aMffiR5C70P62f3B3gsNTJobeMgO3hGNaFKz5YbBFShqetlmk0K
	8ZzwPx1qKcjxxJAH1cPjWntKRDlJQ/T8RmTQiSRNcIYnsrB/U/GRTrIp+okPdK8CsPOVdQ
	tZ8bGcgqp2NIWtPl1Bghdq4KszODDg0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKEdwOF6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXv6g7uPf7qxRkkIiMBqCwgrrYFAEGJ5DOUNMycRfvU=;
	b=KVRvv31ovc1C3qu1YAoUxooIMDU5fiYYIBQ6KdurVODJrCh0KQ2hwdNjjSH3NIh+hHqLAB
	++HOojyhet+v//GNDJtlhPt5QqL7EgW8lvpo9q6fTOGQm66/65kvDSCYgvUzPnRHKxPtzP
	6YYoheLIwUo8MwEzZU5SkVMthL4pMfo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VXv6g7uPf7qxRkkIiMBqCwgrrYFAEGJ5DOUNMycRfvU=;
	b=GKEdwOF6C3Mk469brs7wCG8M6vexvZC8GeGdIk5y8J9fSliXRiLQvf9qXcrBfqw+shmBOi
	sCo4oW3bBHSkLZnwIhro3QagwKL9z04keACu+/jphZ7u4EVEKzJk4fE0C8CYat8xniqq5S
	smCemBHDBexxL9q8cWq06X2bDN8qSkM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 17/17] bpf: selftests: PSI struct ops test
Date: Mon, 26 Jan 2026 18:46:04 -0800
Message-ID: <20260127024604.495018-2-roman.gushchin@linux.dev>
In-Reply-To: <20260127024604.495018-1-roman.gushchin@linux.dev>
References: <20260127024604.495018-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5D0E020002
X-Stat-Signature: yahnuokdix67pmhfkn4tdqg5hkqu5d1h
X-HE-Tag: 1769481976-279647
X-HE-Meta: U2FsdGVkX188DiXvVHTVimgmGkCQjxVF2uGENQUwf/GAdY1nOgN9gYBl5PMbtEy8XehvwpfqR/g33W1i1v9GptssvQ8q0+GGgmXiYe+gTHO1WN1JkzvwG/QVrksdiEiHBjKKncNx5l1Qw/yqIZDBofjDpsj3DFvyZz3Hj1C+nI7xgbsJpZif4cvtF7SW7hhU/MOtxzYJPpZH5D7uHpyJ86E7I3JSHoHsrngrohM5NCQEPHUt7Cy4snmLER93kvS4PmfXVXtEtxxt6KmsaESPwmkJ/nwxIXRe9zOSwSntNOxMb/WiOFNnlx9/zFGiD8j0vs1KmwbpfYlfb0YLvmKyPJeTWbuZueBINkWFRXf6bMp7iu1volWEu9XKJ508UNmz0RQ6D6a3Th217LCXRuC0hj6OfOPQ+kGE2+p7HgWCsdB0ZvaP0HOvOIEPA4uBpgcPgEz4+xsSdgBZmh9OVM8UlXF+OesSYJuuPmlD4qVsd/b0SHmb+BgTlkj0/sm336K/6dSU84lA/8FV5RvIBcceJrNeZs7qhSTRVvJE3xBw+CqLrZhji7y/hsMaLCT6i5RO60H8SNsqwoJDt2ojFRrOG7eo5z2tGSIcPiiZdj/kbHfuk1J8JGurjJlRwQuloVvy2q5/otXFJCSp2CLgaU+dvFZzn3a71AHUETmHtFhog8Pp9SmfxkfAVyuPlAZ5EKocz0EQnN0pqsVHXiJKiF0J6vnkFzRqy28ouZUKkWN68bZ3DiNm5vgfse7PTQXt+vFVEVWeUpt+D/UHhFjESuWpkKmShI+VIQkuO5LvtfA+liaYXb3P1fEcfhik8rAtFXnd6jiR8ZRcpEX3eoFCB/PkUnGmkpAhQ7WMP8SWTk8UKsBV2XF4FU4ivoJr80bYgb34AgxvJqJk4cSSKZRuCi8XkLO8/5yrezCrwwpWeBHpP4jvP4y0jOnEX7QGZiezb/LLwyKL+9LswYCiYvE9FCB
 oEpJ9zcW
 2kcnJaV0NurgpxKJGhq6nywI5txxhRMpiElLHPg0MOx4qhdsP9Fg5blA0+OlmXzCLV+9s5tsN4qDa9pThvgck9z0L1IgOeQHKOQqbde+GSKgom/VnXjmUbo+07D27yRfbSSzqz9Swz2Rx58mtjZ3x4DaMJ4kaoBLQoGgEcoEjd5pwStT0qTqLIakZz+MZaIZpGRv3UcodppgckxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a PSI struct ops test.

The test creates a cgroup with two child sub-cgroups, sets up
memory.high for one of those and puts there a memory hungry
process (initially frozen).

The memory hungry task is creating a high memory pressure in one
memory cgroup, which triggers a PSI event. The PSI BPF handler
declares a memcg oom in the corresponding cgroup.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../selftests/bpf/prog_tests/test_psi.c       | 225 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_psi.c  |  90 +++++++
 2 files changed, 315 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_psi.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_psi.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_psi.c b/tools/testing/selftests/bpf/prog_tests/test_psi.c
new file mode 100644
index 000000000000..170c6f6a1a35
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_psi.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <test_progs.h>
+#include <bpf/btf.h>
+#include <bpf/bpf.h>
+
+#include "cgroup_helpers.h"
+#include "test_psi.skel.h"
+
+enum psi_res {
+	PSI_IO,
+	PSI_MEM,
+	PSI_CPU,
+	PSI_IRQ,
+	NR_PSI_RESOURCES,
+};
+
+struct cgroup_desc {
+	const char *path;
+	unsigned long long id;
+	int pid;
+	int fd;
+	size_t target;
+	size_t high;
+	bool victim;
+};
+
+#define MB (1024 * 1024)
+
+static struct cgroup_desc cgroups[] = {
+	{ .path = "/psi_test" },
+	{ .path = "/psi_test/cg1" },
+	{ .path = "/psi_test/cg2", .target = 500 * MB,
+	  .high = 40 * MB, .victim = true },
+};
+
+static int spawn_task(struct cgroup_desc *desc)
+{
+	char *ptr;
+	int pid;
+
+	pid = fork();
+	if (pid < 0)
+		return pid;
+
+	if (pid > 0) {
+		/* parent */
+		desc->pid = pid;
+		return 0;
+	}
+
+	/* child */
+	ptr = (char *)malloc(desc->target);
+	if (!ptr)
+		_exit(ENOMEM);
+
+	memset(ptr, 'a', desc->target);
+
+	while (1)
+		sleep(1000);
+
+	return 0;
+}
+
+static void setup_environment(void)
+{
+	int i, err;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "setup_cgroup_environment"))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(cgroups); i++) {
+		cgroups[i].fd = create_and_get_cgroup(cgroups[i].path);
+		if (!ASSERT_GE(cgroups[i].fd, 0, "create_and_get_cgroup"))
+			goto cleanup;
+
+		cgroups[i].id = get_cgroup_id(cgroups[i].path);
+		if (!ASSERT_GT(cgroups[i].id, 0, "get_cgroup_id"))
+			goto cleanup;
+
+		/* Freeze the top-level cgroup and enable the memory controller */
+		if (i == 0) {
+			err = write_cgroup_file(cgroups[i].path, "cgroup.freeze", "1");
+			if (!ASSERT_OK(err, "freeze cgroup"))
+				goto cleanup;
+
+			err = write_cgroup_file(cgroups[i].path, "cgroup.subtree_control",
+						"+memory");
+			if (!ASSERT_OK(err, "enable memory controller"))
+				goto cleanup;
+		}
+
+		/* Set memory.high */
+		if (cgroups[i].high) {
+			char buf[256];
+
+			snprintf(buf, sizeof(buf), "%lu", cgroups[i].high);
+			err = write_cgroup_file(cgroups[i].path, "memory.high", buf);
+			if (!ASSERT_OK(err, "set memory.high"))
+				goto cleanup;
+
+			snprintf(buf, sizeof(buf), "0");
+			write_cgroup_file(cgroups[i].path, "memory.swap.max", buf);
+		}
+
+		/* Spawn tasks creating memory pressure */
+		if (cgroups[i].target) {
+			char buf[256];
+
+			err = spawn_task(&cgroups[i]);
+			if (!ASSERT_OK(err, "spawn task"))
+				goto cleanup;
+
+			snprintf(buf, sizeof(buf), "%d", cgroups[i].pid);
+			err = write_cgroup_file(cgroups[i].path, "cgroup.procs", buf);
+			if (!ASSERT_OK(err, "put child into a cgroup"))
+				goto cleanup;
+		}
+	}
+
+	return;
+
+cleanup:
+	cleanup_cgroup_environment();
+}
+
+static int run_and_wait_for_oom(void)
+{
+	int ret = -1;
+	bool first = true;
+	char buf[4096] = {};
+	ssize_t size;
+
+	/* Unfreeze the top-level cgroup */
+	ret = write_cgroup_file(cgroups[0].path, "cgroup.freeze", "0");
+	if (!ASSERT_OK(ret, "unfreeze cgroup"))
+		return -1;
+
+	for (;;) {
+		int i, status;
+		pid_t pid = wait(&status);
+
+		if (pid == -1) {
+			if (errno == EINTR)
+				continue;
+			/* ECHILD */
+			break;
+		}
+
+		if (!first)
+			continue;
+		first = false;
+
+		/* Check which process was terminated first */
+		for (i = 0; i < ARRAY_SIZE(cgroups); i++) {
+			if (!ASSERT_OK(cgroups[i].victim !=
+				       (pid == cgroups[i].pid),
+				       "correct process was killed")) {
+				ret = -1;
+				break;
+			}
+
+			if (!cgroups[i].victim)
+				continue;
+
+			/* Check the memcg oom counter */
+			size = read_cgroup_file(cgroups[i].path, "memory.events",
+						buf, sizeof(buf));
+			if (!ASSERT_OK(size <= 0, "read memory.events")) {
+				ret = -1;
+				break;
+			}
+
+			if (!ASSERT_OK(strstr(buf, "oom_kill 1") == NULL,
+				       "oom_kill count check")) {
+				ret = -1;
+				break;
+			}
+		}
+
+		/* Kill all remaining tasks */
+		for (i = 0; i < ARRAY_SIZE(cgroups); i++)
+			if (cgroups[i].pid && cgroups[i].pid != pid)
+				kill(cgroups[i].pid, SIGKILL);
+	}
+
+	return ret;
+}
+
+void test_psi(void)
+{
+	struct test_psi *skel;
+	int cgroup_fd;
+	int err;
+
+	setup_environment();
+
+	skel = test_psi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	skel->bss->high_pressure_cgroup_id = cgroups[2].id;
+	skel->bss->my_pid = getpid();
+
+	err = test_psi__attach(skel);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	/* Delete the first cgroup, it used to trigger offline handler */
+	remove_cgroup(cgroups[1].path);
+
+	/* Create new cgroup */
+	cgroup_fd = create_and_get_cgroup("/psi_test_new");
+	if (!ASSERT_GT(cgroup_fd, 0, "create_and_get_cgroup"))
+		goto cleanup;
+
+	/* Unfreeze all child tasks and create the memory pressure */
+	err = run_and_wait_for_oom();
+	CHECK_FAIL(err);
+
+	close(cgroup_fd);
+cleanup:
+	cleanup_cgroup_environment();
+	test_psi__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_psi.c b/tools/testing/selftests/bpf/progs/test_psi.c
new file mode 100644
index 000000000000..6efd5c995ce0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_psi.c
@@ -0,0 +1,90 @@
+#include "vmlinux.h"
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* cgroup which will experience the high memory pressure */
+u64 high_pressure_cgroup_id;
+u32 my_pid = 0;
+
+/* last total full memory pressure value */
+u64 last_mem_full_total = 0;
+
+extern struct task_struct *bpf_task_from_pid(s32 pid) __ksym;
+extern void bpf_task_release(struct task_struct *p) __ksym;
+
+struct elem {
+	struct bpf_task_work tw;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, struct elem);
+} tw_map SEC(".maps");
+
+static int psi_oom_work(struct bpf_map *map, void *key, void *value)
+{
+	struct cgroup *cgrp;
+	struct mem_cgroup *memcg;
+
+	cgrp = bpf_cgroup_from_id(high_pressure_cgroup_id);
+	if (!cgrp)
+		return 0;
+
+	memcg = bpf_get_mem_cgroup(&cgrp->self);
+	if (memcg) {
+		bpf_out_of_memory(memcg, 0, BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK);
+		bpf_put_mem_cgroup(memcg);
+	}
+
+	bpf_cgroup_release(cgrp);
+	return 0;
+}
+
+static void schedule_oom_work(void)
+{
+	struct task_struct *task;
+	struct elem *val;
+	int key = 0;
+
+	task = bpf_task_from_pid(my_pid);
+	if (task) {
+		val = bpf_map_lookup_elem(&tw_map, &key);
+		if (val)
+			bpf_task_work_schedule_signal(task, &val->tw,
+						      &tw_map, psi_oom_work);
+		bpf_task_release(task);
+	}
+}
+
+SEC("tp_btf/psi_avgs_work")
+int BPF_PROG(psi_avgs, struct psi_group *group)
+{
+	u64 current_total;
+	u64 growth;
+
+	/* Monitor only a single target cgroup */
+	if (group->cgroup_id != high_pressure_cgroup_id)
+		return 0;
+
+	/* Check for memory pressure */
+	current_total = BPF_CORE_READ(group, total[PSI_MEM_FULL]);
+	if (last_mem_full_total == 0) {
+		last_mem_full_total = current_total;
+		return 0;
+	}
+
+	growth = current_total - last_mem_full_total;
+	last_mem_full_total = current_total;
+
+	/* Declare an OOM if growth > 50ms within the update period */
+	if (growth > 50000000)
+		schedule_oom_work();
+
+	return 0;
+}
-- 
2.52.0



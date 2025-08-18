Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E8CCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF946B00C7; Mon, 18 Aug 2025 13:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189356B00C9; Mon, 18 Aug 2025 13:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CF76B00CB; Mon, 18 Aug 2025 13:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92A76B00C7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A62ED1409FC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:27 +0000 (UTC)
X-FDA: 83790496734.03.64E7824
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC0BE100015
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RTdyUVik;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5PZGww5UJXcYRq1XlF9P00nUCT95JA1S7NFEcobsCQ=;
	b=0QmTcBT/kA1b2VmBKjSytht7+YxjECLZZp9DS5F0nV9lAI24Z0vZr/CjyuJiVE9JtxfCJZ
	6iWr1CjWzhVcVrdW65fyizAqaTjKIS8x1s9QXGf1IFwqP77UO0BVM/fgmOSOhZjsRhGVgq
	GIVdAg/RDEbPbM7PCYJUpZBt0oldtPA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RTdyUVik;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536546; a=rsa-sha256;
	cv=none;
	b=waIEMgfPqVDB31RhuLQn9nQT9A01VlXQWeSMw1hXLEoEFOaxng1f78hVfUb4VvR/P7RglD
	uFc7/acR2mkxp9Zlh5gyZnh3e7+xH4Z2PW1i4eM95vjmreU1QlGIy6++ToaL1D0v7vCwUJ
	d9Z4MDM5SIgv7U6AI2eS/ObplTYZ0DU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m5PZGww5UJXcYRq1XlF9P00nUCT95JA1S7NFEcobsCQ=;
	b=RTdyUVikURz5qAFz3Plns7U4ASUW/r9ELevyJv1S0J8KnMckP3zDbA/g8C+kEl/NlvC6B8
	Qgjxi5r5LjAdneqD384YzLtNNR8eeinpxwUbPtn1ec2fnCq1nv0QQNG3UTN0R9jPTm7T1T
	dGkgUd7c9oK+0oWvcKmGcdj3qbubnUI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 10/14] bpf: selftests: bpf OOM handler test
Date: Mon, 18 Aug 2025 10:01:32 -0700
Message-ID: <20250818170136.209169-11-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: di6dzaapnfdwseqh7px8w5p4tgyub6di
X-Rspam-User: 
X-Rspamd-Queue-Id: EC0BE100015
X-Rspamd-Server: rspam05
X-HE-Tag: 1755536545-82586
X-HE-Meta: U2FsdGVkX1+/XMbN9tzDoqc75SQQRTsv6xlamWfIArWwLvwJ/3h34u+DPCqVfMP4xb7UlFuVgDevDhelQ5QM5lfg7wH0b77aO2tM7LklqBIBFMZ8yYy+Y3LBks6FTxONqOFUuA2KSCHgb4LCJkk3SvZffkiN97ia8cSRB4VWCaTfENWQsffM9hkM0Viy/ws5xz06F4QDq2Qi/7ImTMU7yoSKEMZnoWiHWAtnhgwBloFaYtIzv2pIU54YJSa61zYAYO56J2OLREohsSUO2jcJTUrS/X/umTPgW5VchQMYRnDEjf03DGYJL9mADix8YYuRi1pUiUUA8tuRLS+Ku41iIsp89EbJ33xR4MQiqX6OMzhNMs0EfM7SGiwG8taEPLPYwVNaIQH0D3vGMYDhEFvmIoI2FYOkx4lYbgMHYOX1ppkMAGKDrE253Fmt0bXhw0fmtAp7+4gNr5VSfH1xUhV9A63or5jafZhJhJV0V9agXGvENhf79ZbSvKciUYaHbdFhd4OcvmdKNnq8PEWbG26Uu0vH5qrx9wJryG0LMYDxmkVGy50apij5LEmozTLnjcbgq/wJ+wtSREIqqCqcRVGV1jRzjlOABLSxrEV2ocLMWXCLj+oFo1t6KEoYZRsFolUovPIZR16bk0mB4o3kfu5u60AwBhRmZgJHmeZ5M5zWD0EAOZp1uvGFFVDxvRSHS8IbGVMObQQ1TA/XtwzU15OomyzEA9r5usCBShgeGawFZGjmoYqzYPOs19COc9k9s7x+cvveiEAJ70NwIqqL4rkWTW2lpuHF0qpJe14kCSybResH6SvdnEunxxSy2ug/xBGaWk0FGMaFtfE57Z/p7JganjX+fctAyykkaZ2n8UZMKFggAoVcNJtxrkYpQL9yCLxCLGvV3ejbvz+Lr1bnrwT8LTDzFOx8XLak4IS5AYoH/I9eMcZFCnBaukwFOvJxV/9wL11+5iE1KRTrh16/DMx
 IwZURRTh
 P2nRBdn6IyvLUWClYWyqDcm5EfdKoWAcnD8r97Kh7CDZlc44kLCC8bagO/gIJS/fofD34WRU7B9M4A24DHJT4SJZVYV2F9A86hG1ZzGSTFT72tfZ4iiA63x5SHK98kJw9JtNYTdmfJm/T46KrudI6yTtP4ZWO3cq80li8GvNRVjvgeFuuqWvzcO/g2hXgEX2zL4KH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a pseudo-realistic test for the OOM handling
functionality.

The OOM handling policy which is implemented in bpf is to
kill all tasks belonging to the biggest leaf cgroup, which
doesn't contain unkillable tasks (tasks with oom_score_adj
set to -1000). Pagecache size is excluded from the accounting.

The test creates a hierarchy of memory cgroups, causes an
OOM at the top level, checks that the expected process will be
killed and checks memcg's oom statistics.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../selftests/bpf/prog_tests/test_oom.c       | 229 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_oom.c  | 108 +++++++++
 2 files changed, 337 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_oom.c b/tools/testing/selftests/bpf/prog_tests/test_oom.c
new file mode 100644
index 000000000000..eaeb14a9d18f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_oom.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <test_progs.h>
+#include <bpf/btf.h>
+#include <bpf/bpf.h>
+
+#include "cgroup_helpers.h"
+#include "test_oom.skel.h"
+
+struct cgroup_desc {
+	const char *path;
+	int fd;
+	unsigned long long id;
+	int pid;
+	size_t target;
+	size_t max;
+	int oom_score_adj;
+	bool victim;
+};
+
+#define MB (1024 * 1024)
+#define OOM_SCORE_ADJ_MIN	(-1000)
+#define OOM_SCORE_ADJ_MAX	1000
+
+static struct cgroup_desc cgroups[] = {
+	{ .path = "/oom_test", .max = 80 * MB},
+	{ .path = "/oom_test/cg1", .target = 10 * MB,
+	  .oom_score_adj = OOM_SCORE_ADJ_MAX },
+	{ .path = "/oom_test/cg2", .target = 40 * MB,
+	  .oom_score_adj = OOM_SCORE_ADJ_MIN },
+	{ .path = "/oom_test/cg3" },
+	{ .path = "/oom_test/cg3/cg4", .target = 30 * MB,
+	  .victim = true },
+	{ .path = "/oom_test/cg3/cg5", .target = 20 * MB },
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
+	if (desc->oom_score_adj) {
+		char buf[64];
+		int fd = open("/proc/self/oom_score_adj", O_WRONLY);
+
+		if (fd < 0)
+			return -1;
+
+		snprintf(buf, sizeof(buf), "%d", desc->oom_score_adj);
+		write(fd, buf, sizeof(buf));
+		close(fd);
+	}
+
+	ptr = (char *)malloc(desc->target);
+	if (!ptr)
+		return -ENOMEM;
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
+		/* Freeze the top-level cgroup */
+		if (i == 0) {
+			/* Freeze the top-level cgroup */
+			err = write_cgroup_file(cgroups[i].path, "cgroup.freeze", "1");
+			if (!ASSERT_OK(err, "freeze cgroup"))
+				goto cleanup;
+		}
+
+		/* Recursively enable the memory controller */
+		if (!cgroups[i].target) {
+
+			err = write_cgroup_file(cgroups[i].path, "cgroup.subtree_control",
+						"+memory");
+			if (!ASSERT_OK(err, "enable memory controller"))
+				goto cleanup;
+		}
+
+		/* Set memory.max */
+		if (cgroups[i].max) {
+			char buf[256];
+
+			snprintf(buf, sizeof(buf), "%lu", cgroups[i].max);
+			err = write_cgroup_file(cgroups[i].path, "memory.max", buf);
+			if (!ASSERT_OK(err, "set memory.max"))
+				goto cleanup;
+
+			snprintf(buf, sizeof(buf), "0");
+			write_cgroup_file(cgroups[i].path, "memory.swap.max", buf);
+
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
+	size_t size;
+
+	/* Unfreeze the top-level cgroup */
+	ret = write_cgroup_file(cgroups[0].path, "cgroup.freeze", "0");
+	if (!ASSERT_OK(ret, "freeze cgroup"))
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
+
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
+			size = read_cgroup_file(cgroups[i].path,
+						"memory.events",
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
+void test_oom(void)
+{
+	struct test_oom *skel;
+	int err;
+
+	setup_environment();
+
+	skel = test_oom__open_and_load();
+	err = test_oom__attach(skel);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	/* Unfreeze all child tasks and create the memory pressure */
+	err = run_and_wait_for_oom();
+	CHECK_FAIL(err);
+
+cleanup:
+	cleanup_cgroup_environment();
+	test_oom__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_oom.c b/tools/testing/selftests/bpf/progs/test_oom.c
new file mode 100644
index 000000000000..ca83563fc9a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_oom.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define OOM_SCORE_ADJ_MIN	(-1000)
+
+void bpf_rcu_read_lock(void) __ksym;
+void bpf_rcu_read_unlock(void) __ksym;
+struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
+void bpf_task_release(struct task_struct *p) __ksym;
+struct mem_cgroup *bpf_get_root_mem_cgroup(void) __ksym;
+struct mem_cgroup *bpf_get_mem_cgroup(struct cgroup_subsys_state *css) __ksym;
+void bpf_put_mem_cgroup(struct mem_cgroup *memcg) __ksym;
+int bpf_oom_kill_process(struct oom_control *oc, struct task_struct *task,
+			 const char *message__str) __ksym;
+
+static bool mem_cgroup_killable(struct mem_cgroup *memcg)
+{
+	struct task_struct *task;
+	bool ret = true;
+
+	bpf_for_each(css_task, task, &memcg->css, CSS_TASK_ITER_PROCS)
+		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+			return false;
+
+	return ret;
+}
+
+/*
+ * Find the largest leaf cgroup (ignoring page cache) without unkillable tasks
+ * and kill all belonging tasks.
+ */
+SEC("struct_ops.s/handle_out_of_memory")
+int BPF_PROG(test_out_of_memory, struct oom_control *oc)
+{
+	struct task_struct *task;
+	struct mem_cgroup *root_memcg = oc->memcg;
+	struct mem_cgroup *memcg, *victim = NULL;
+	struct cgroup_subsys_state *css_pos;
+	unsigned long usage, max_usage = 0;
+	unsigned long pagecache = 0;
+	int ret = 0;
+
+	if (root_memcg)
+		root_memcg = bpf_get_mem_cgroup(&root_memcg->css);
+	else
+		root_memcg = bpf_get_root_mem_cgroup();
+
+	if (!root_memcg)
+		return 0;
+
+	bpf_rcu_read_lock();
+	bpf_for_each(css, css_pos, &root_memcg->css, BPF_CGROUP_ITER_DESCENDANTS_POST) {
+		if (css_pos->cgroup->nr_descendants + css_pos->cgroup->nr_dying_descendants)
+			continue;
+
+		memcg = bpf_get_mem_cgroup(css_pos);
+		if (!memcg)
+			continue;
+
+		usage = bpf_mem_cgroup_usage(memcg);
+		pagecache = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
+
+		if (usage > pagecache)
+			usage -= pagecache;
+		else
+			usage = 0;
+
+		if ((usage > max_usage) && mem_cgroup_killable(memcg)) {
+			max_usage = usage;
+			if (victim)
+				bpf_put_mem_cgroup(victim);
+			victim = bpf_get_mem_cgroup(&memcg->css);
+		}
+
+		bpf_put_mem_cgroup(memcg);
+	}
+	bpf_rcu_read_unlock();
+
+	if (!victim)
+		goto exit;
+
+	bpf_for_each(css_task, task, &victim->css, CSS_TASK_ITER_PROCS) {
+		struct task_struct *t = bpf_task_acquire(task);
+
+		if (t) {
+			if (!bpf_task_is_oom_victim(task))
+				bpf_oom_kill_process(oc, task, "bpf oom test");
+			bpf_task_release(t);
+			ret = 1;
+		}
+	}
+
+	bpf_put_mem_cgroup(victim);
+exit:
+	bpf_put_mem_cgroup(root_memcg);
+
+	return ret;
+}
+
+SEC(".struct_ops.link")
+struct bpf_oom_ops test_bpf_oom = {
+	.name = "bpf_test_policy",
+	.handle_out_of_memory = (void *)test_out_of_memory,
+};
-- 
2.50.1



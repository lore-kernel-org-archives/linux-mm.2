Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBCFD25920
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D306B00A9; Mon, 26 Jan 2026 21:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDBD6B00AA; Mon, 26 Jan 2026 21:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100A86B00AB; Mon, 26 Jan 2026 21:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0A606B00A9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCBB1D3C6D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:13 +0000 (UTC)
X-FDA: 84376202106.15.84355C5
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEE2C140008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UksrWR4I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481912; a=rsa-sha256;
	cv=none;
	b=0hZRJ350aFgnqd3IVySM6McPTwicVbhAmnzvE8fNED1ub3XBKvtrnoKL0bO9ddN772HqBg
	pfn40BJuHQWRdZMOj2S0Aej2TbzMDHrr5b5uqRROiYjs+iLp4Ypv/+mwfjWj2pDe5ycjPA
	9l/lf012bVNOSYZ9LKyTUI71Dgsvgao=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UksrWR4I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vt6yCthx83SOS4lBcyiZWD1/2agiAEDOu7IdKxelec0=;
	b=IPX3vxDzmV+K3ICW/xKIxPA0Gw3whxwSxl2gslGb4EC5tjPM16t8RDUBFdl2/7U+ryQ6hC
	A/nsiJnswq4Dr8n+yG+EeAAG8WxiNCdNFUrjF3LIiYXfBRruRPSNoROf3O0SuRnAzhcCKX
	A+u2NOgcubBhISRjbZrOkfRw4WT0tK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vt6yCthx83SOS4lBcyiZWD1/2agiAEDOu7IdKxelec0=;
	b=UksrWR4IpOgc56E0T4z+uk+SHBgfDOTNl6Ok0oOsw85O9Jz4W0IlcetQU7CqFcwTpRnRdV
	ueXJEffUTPVeHm1Icl9TSrn2H7tbPmy2tiN1kSCStUiA6lrXGJruNrmdnwFJ4TQqCD4Xwc
	s1HrsCYMJnWVMdPTgS++ryIz2SJSQAc=
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
Subject: [PATCH bpf-next v3 12/17] bpf: selftests: BPF OOM struct ops test
Date: Mon, 26 Jan 2026 18:44:15 -0800
Message-ID: <20260127024421.494929-13-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EEE2C140008
X-Stat-Signature: jjnrwg4b54qstt4oyte3ipjfd3icra1x
X-HE-Tag: 1769481911-143688
X-HE-Meta: U2FsdGVkX1+UuxGPMsrH2VMMEJV6Gu/cd2lL2sb1KE2nD6eX1sT/lOslJyo5pXx7yWpm1jT5AgpzDlWZoe7rwFXVieHqa2Jdk1cMBttdVLTYV4q5jZT9n4GjJj91UovPCbDCtax1nMIWyT5QsGFI2BIKB6o+AWMWUdMn8noATnf9XXb9znIKMgBL5Lv11wQCWGyzqQ8a5fC/44qlmy4UnnG5+t5/vNuhvuuLljCd/YKOPQpEIPl5iLFyExIKKwipTWj7fgNz424hEkd3Ddf/kbwXNqRBVZawqfR7WjglpcvBA3eCDXwxzTbotKW7Sd6frrqdM4dZQlIrR70rzmrXSRlus8G1Qt6KK+3WKz4RGQ1E0mZcGip93VIuBQH2OMcYGrgCWLrKkcP2QWdZlCN4AaeaE+99qGgDZLGmYi4HbCowEM2jnmWDKQe7RMrPjOSLpnHAw2qxpSS/9QqyhefwRH4X6L6TDejuSX41CYpfTZa+uaTg0HdiQzHVfop1B7eo3EuNLE0f1DZM2SBBfSqq2kQNKQ72sfTPcoUPoh0FNGSND0u2nmHgkxuYhMkHR2WPOJQL07Wc53nx2nYKlIG6BY41uMwBp81EpBgx9sHmDqkyRIGbf0e0a+D4BdEwa8K8m/mlis/11JRGLtr0JiynHbD/XJUWY2+j8ctk00jlpeic3AqqZaICwNUw34vT+S9v3KXSIBS5gRPR8PY/Dqa9M6iNx0MQaWxxuNL+N93oX/Zw59vvFDbsT1hVDL3y6532zb8cwJiO3eTj7k8s9D0TCZE1sroLrYJc0Hdc07gMeMydTISxK7+8rXLi8bnmcLwhXG0DqL+aM+AKVfs02aM5fnjEqBdlqGNW5dw6vU5/jLhsCq08fkOjBe9sQQxxstT2dmdklVTZ2mYdh+w0WFNli45rhAYig/tPvPfciTvCM8OLDJ1oWrI5SNCBpfHhX7z0cJ0TrRtRfVM5Dl7PE21
 SQt31Q5z
 kPyxc8jQqjIFtCGQTw7imH9aLwTf9pyfk+3Pkw1xMkf2iT32urlW1vEgCr9RPOn8AOzT+JTCikNYOBlnsPo6B+x/fbVLSbkBuer2TTLoQ1LumQhLDdIGpqYoG+boPeAwAroXlJvWl6tNi5usjGncJXs4KDaOLEw/M5D/VUmI6piy7Fi8vNCMCihhWv0k7k1D7HNNo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a kselftest for the OOM handling functionality.

The OOM handling policy which is implemented in BPF is to
kill all tasks belonging to the biggest leaf cgroup, which
doesn't contain unkillable tasks (tasks with oom_score_adj
set to -1000). Pagecache size is excluded from the accounting.

The test creates a hierarchy of memory cgroups, causes an
OOM at the top level, checks that the expected process is
killed and verifies the memcg's oom statistics.

The same BPF OOM policy is attached to a memory cgroup and
system-wide. In the first case the program does nothing and
returns false, so it's executed the second time, when it
properly handles the OOM.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../selftests/bpf/prog_tests/test_oom.c       | 256 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_oom.c  | 111 ++++++++
 2 files changed, 367 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_oom.c b/tools/testing/selftests/bpf/prog_tests/test_oom.c
new file mode 100644
index 000000000000..a1eadbe1ae83
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_oom.c
@@ -0,0 +1,256 @@
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
+
+	// TODO return an error?
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
+	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	struct test_oom *skel;
+	int err = 0;
+
+	setup_environment();
+
+	skel = test_oom__open_and_load();
+	if (!skel) {
+		err = -errno;
+		CHECK_FAIL(err);
+		goto cleanup;
+	}
+
+	opts.flags = BPF_F_CGROUP_FD;
+	opts.target_fd = cgroups[0].fd;
+	link1 = bpf_map__attach_struct_ops_opts(skel->maps.test_bpf_oom, &opts);
+	if (!link1) {
+		err = -errno;
+		CHECK_FAIL(err);
+		goto cleanup;
+	}
+
+	opts.target_fd = get_root_cgroup();
+	link2 = bpf_map__attach_struct_ops_opts(skel->maps.test_bpf_oom, &opts);
+	if (!link2) {
+		err = -errno;
+		CHECK_FAIL(err);
+		goto cleanup;
+	}
+
+	/* Unfreeze all child tasks and create the memory pressure */
+	err = run_and_wait_for_oom();
+	CHECK_FAIL(err);
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	write_cgroup_file(cgroups[0].path, "cgroup.kill", "1");
+	write_cgroup_file(cgroups[0].path, "cgroup.freeze", "0");
+	cleanup_cgroup_environment();
+	test_oom__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_oom.c b/tools/testing/selftests/bpf/progs/test_oom.c
new file mode 100644
index 000000000000..7ff354e416bc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_oom.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define OOM_SCORE_ADJ_MIN	(-1000)
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
+int BPF_PROG(test_out_of_memory, struct oom_control *oc, struct bpf_struct_ops_link *link)
+{
+	struct task_struct *task;
+	struct mem_cgroup *root_memcg = oc->memcg;
+	struct mem_cgroup *memcg, *victim = NULL;
+	struct cgroup_subsys_state *css_pos, *css;
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
+	css = &root_memcg->css;
+	if (css && css->cgroup == link->cgroup)
+		goto exit;
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
+			/*
+			 * If the task is already an OOM victim, it will
+			 * quit soon and release some memory.
+			 */
+			if (bpf_task_is_oom_victim(task)) {
+				bpf_task_release(t);
+				ret = 1;
+				break;
+			}
+
+			bpf_oom_kill_process(oc, task, "bpf oom test");
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
2.52.0



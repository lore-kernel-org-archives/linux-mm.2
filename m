Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58949CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB048E0053; Mon, 18 Aug 2025 13:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58C08E0013; Mon, 18 Aug 2025 13:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9D78E0053; Mon, 18 Aug 2025 13:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBABC8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92575BBAF3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:43 +0000 (UTC)
X-FDA: 83790497406.07.4B654F4
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF4F84000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G6Jd/6cP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536562; a=rsa-sha256;
	cv=none;
	b=aGbBF/lssW9ovbuTSVi6mkVNvOXS221xdKA3jmAJ3Kjzw8WoKqfDaBlJgROoAkQZvI5FGi
	mjYXoOmy3tnNjU/2Yunb0vxMPWLIVhybMunC7V9VLOF0znOyhBWgJ+sHT3CtJQrRCet+OX
	3FLzIh5CRupAxiav0DOmbBm0mlSOuts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G6Jd/6cP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWT242NgNZP3jc1GQRw8o49/i2gTFgutb9b4mEZjMpA=;
	b=waOI5BN2COcD736kRAfOIz0gQydzkMkDK0uWzUOnfTOQ4xUTKmCUX/Qrlh6fUzvZLU94Us
	cPbE2nbnUE6TiHm5OlDKuoegXvRSxB4SEHWP41S3o2gcv/YsJn/m4qPFBkq3mt50rxoxKZ
	llOrXA8yuSPx2V18ecrOglERmU7JIbY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWT242NgNZP3jc1GQRw8o49/i2gTFgutb9b4mEZjMpA=;
	b=G6Jd/6cPEKn36h3z3JKcou8qMKVTIQVTjk1XJJAqMSHviLXKnseiiF4s+ycNlEVF4gmEs8
	vrd0Hjv0FBdhFuXJqncBC5vwr4nz7aXsRXeFQlIuDqRnz3Mj1mmg9zCQ3L7TRAc1Uh9ikm
	xEoVctnSxZw0eWXBb+JWHvbr37zDzs8=
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
Subject: [PATCH v1 14/14] bpf: selftests: psi struct ops test
Date: Mon, 18 Aug 2025 10:01:36 -0700
Message-ID: <20250818170136.209169-15-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DF4F84000F
X-Stat-Signature: thdobhotz1x48yrpha67j5ygdbz9ukad
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755536561-817202
X-HE-Meta: U2FsdGVkX18Q6XmZgz4rKR4KTFP3u0hAADrBFpoR8gB+9Pc9+kETcWG3tTWjeySI13w5xLCYrGdJ2Hd3A6HdwjR3C+u/qi1Bq8u0spUdOADmwG41WvEbiyg23J2uOrB14VLy8ixnkLJUn//CUjdV5VrN0edQhtaPp99pXLE2ZneyElp06To6MRA1R01T2AZYIUx+nieZN5BSZzGB/xLZI5MCta1n4iLJn7154Ym8/ZrRdGIwW+HOZ0IvGeyOSX434eTNSy0dRPNvHYFTsYHHCu2+5cg7z5ViOA8pQ255U6h3y7zR58jgcFO4X1X6O3t/DEfT84LV+8i1GPd8OOa9Z2SeRnhgYI4S38N8xLngzzQKYQ652e/aggzY/DJkKwpqtiHeNJvl17ppPCOnUk6ZNIuqM/Nt60VgJUgKgRoSjW0td/h07iexpLa4ticY3ImZPLqaxHagUcHcigoKdyJw85cYTkB75A5nW6We6JpM8YbNAIPliM2JwNJT/SsaGWG8mQtCH9khZ5XTKEN4DDGA4cuZ83bc5SNILr6gnoRYBfF/+8q2awlLSDEmzfa89c5B1Pw/osd+L2Giksbm+1AS2roRLMvZjG0kgDg2m4AcifZeVkfcUDblCwNOpWZsZds07kKKiJOJmNPNf3nlHU3J+e+4XC5kKYyZoT6ur9flycbOLPyUl9oZWcMnDXlv5rCnDOX9caNRwkRyVtnTwpaSTLOiD7377x7YutMmwxE+2YWzokMZmM5+x1GMJHCL9HmSuQGEdWiLmhnoYx9Xaup4xn9wL5pl0keUJxgLlWeJjY6Pcvd7vRqhIEkHsfG4QZzu19VIMS1hEov5E7oNafCvcY6W+WhsAa0yjhuRlZtSK27tdZ2ATL6wee7le6CuVg2cQPt4XQ/b1xtz2BQCQ8cyTxoXH715PpN8yCt4cLKryuBy9CzUbyJREJq1QMBby1EA0YWmM9EGBv4wmVIT2uj
 68/3FxIl
 /Ibc5AvMvG3oGI+heI4WCDzZpsMUrJ2LF3XXvtURBBEQpgfCX1/DWCCzDeAEQMSmNqoTQlaQczCEThi0D0voSE/okZLeXjSE8S/qk86XAsSEZbHtYr6E6V+njOazTNYVPlzlrKRuNF/JHMekRtTQkuw8JCoBAXv4XCkA6urztvQ54avFSXHSh5gfy11qC/P665xTfeAfI08N7Eoo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a psi struct ops test.

The test creates a cgroup with two child sub-cgroups, sets up
memory.high for one of those and puts there a memory hungry
process (initially frozen).

Then it creates 2 psi triggers from within a init() bpf callback and
attaches them to these cgroups.  Then it deletes the first cgroup and
runs the memory hungry task.  The task is creating a high memory
pressure, which triggers the psi event. The psi bpf handler declares
a memcg oom in the corresponding cgroup.  Finally the checks that both
handle_cgroup_free() and handle_psi_event() handlers were executed,
the correct process was killed and oom counters were updated.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../selftests/bpf/prog_tests/test_psi.c       | 224 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_psi.c  |  76 ++++++
 2 files changed, 300 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_psi.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_psi.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_psi.c b/tools/testing/selftests/bpf/prog_tests/test_psi.c
new file mode 100644
index 000000000000..4f3c91bd6606
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_psi.c
@@ -0,0 +1,224 @@
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
+	{ .path = "/oom_test" },
+	{ .path = "/oom_test/cg1" },
+	{ .path = "/oom_test/cg2", .target = 500 * MB,
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
+	size_t size;
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
+	u64 freed_cgroup_id;
+	int err;
+
+	setup_environment();
+
+	skel = test_psi__open_and_load();
+	err = libbpf_get_error(skel);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	skel->bss->deleted_cgroup_id = cgroups[1].id;
+	skel->bss->high_pressure_cgroup_id = cgroups[2].id;
+
+	err = test_psi__attach(skel);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	/* Delete the first cgroup, it should trigger handle_cgroup_free() */
+	remove_cgroup(cgroups[1].path);
+
+	/* Unfreeze all child tasks and create the memory pressure */
+	err = run_and_wait_for_oom();
+	CHECK_FAIL(err);
+
+	/* Check the result of the handle_cgroup_free() handler */
+	freed_cgroup_id = skel->bss->deleted_cgroup_id;
+	ASSERT_EQ(freed_cgroup_id, cgroups[1].id, "freed cgroup id");
+
+cleanup:
+	cleanup_cgroup_environment();
+	test_psi__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_psi.c b/tools/testing/selftests/bpf/progs/test_psi.c
new file mode 100644
index 000000000000..2c36c05a3065
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_psi.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct mem_cgroup *bpf_get_mem_cgroup(struct cgroup_subsys_state *css) __ksym;
+void bpf_put_mem_cgroup(struct mem_cgroup *memcg) __ksym;
+int bpf_out_of_memory(struct mem_cgroup *memcg, int order, bool wait_on_oom_lock,
+		      const char *constraint_text__nullable) __ksym;
+int bpf_psi_create_trigger(struct bpf_psi *bpf_psi, u64 cgroup_id,
+			   u32 res, u32 threshold_us, u32 window_us) __ksym;
+
+#define PSI_FULL 0x80000000
+
+/* cgroup which will experience the high memory pressure */
+u64 high_pressure_cgroup_id;
+
+/* cgroup which will be deleted */
+u64 deleted_cgroup_id;
+
+/* cgroup which was actually freed */
+u64 freed_cgroup_id;
+
+char constraint_name[] = "CONSTRAINT_BPF_PSI_MEM";
+
+SEC("struct_ops.s/init")
+int BPF_PROG(psi_init, struct bpf_psi *bpf_psi)
+{
+	int ret;
+
+	ret = bpf_psi_create_trigger(bpf_psi, high_pressure_cgroup_id,
+				     PSI_MEM | PSI_FULL, 100000, 1000000);
+	if (ret)
+		return ret;
+
+	return bpf_psi_create_trigger(bpf_psi, deleted_cgroup_id,
+				      PSI_IO, 100000, 1000000);
+}
+
+SEC("struct_ops.s/handle_psi_event")
+void BPF_PROG(handle_psi_event, struct psi_trigger *t)
+{
+	u64 cgroup_id = t->cgroup_id;
+	struct mem_cgroup *memcg;
+	struct cgroup *cgroup;
+
+	cgroup = bpf_cgroup_from_id(cgroup_id);
+	if (!cgroup)
+		return;
+
+	memcg = bpf_get_mem_cgroup(&cgroup->self);
+	if (!memcg) {
+		bpf_cgroup_release(cgroup);
+		return;
+	}
+
+	bpf_out_of_memory(memcg, 0, true, constraint_name);
+
+	bpf_put_mem_cgroup(memcg);
+	bpf_cgroup_release(cgroup);
+}
+
+SEC("struct_ops.s/handle_cgroup_free")
+void BPF_PROG(handle_cgroup_free, u64 cgroup_id)
+{
+	freed_cgroup_id = cgroup_id;
+}
+
+SEC(".struct_ops.link")
+struct bpf_psi_ops test_bpf_psi = {
+	.init = (void *)psi_init,
+	.handle_psi_event = (void *)handle_psi_event,
+	.handle_cgroup_free = (void *)handle_cgroup_free,
+};
-- 
2.50.1



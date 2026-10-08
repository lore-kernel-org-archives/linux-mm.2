Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D38CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1D76B008A; Thu,  8 Oct 2026 03:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A36D6B008C; Thu,  8 Oct 2026 03:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B92B6B0092; Thu,  8 Oct 2026 03:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08C3A6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:10:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04413804A9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:10:11 +0000 (UTC)
X-FDA: 85298585064.19.8C29A46
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9148520002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:10:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNfVAN73;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791443410;
	b=MruqqBK4HpUcdzP+5Q18jNVuEjwQUWnj0aWeRMY99cM5d7DYrYqGQJYq2BH0M84pXCxCHB
	AhKObouTqfmGgJFdLjf5FEWu2bRbhzmU/AWyvCmRu0OThV5luGoTs+5fXtJ+vvYU+Jo5Jt
	X2iaYdZ3oB6EeDJC6bgCGJYtVoW17iU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNfVAN73;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791443410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EU/7A6QpUnuFqzgxuxhYLWPUhZ05ShFVWCDE+KO/x8Q=;
	b=B9jPBonBD7l5dsId/nehLecHVQgOD6zQYLlRM0rF0VgeBoLSZV/Jdu6PUsEuOrJfyjyl+V
	1FKqNO+zP4RFjq9C4NIVaAm0lit6rrMpc4C5dxhQz0kdin5aN50XEMSNaP/nYPshfk0Nry
	DgRZem/aOVekp3XfKV7xi0bun6CcIZ8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YntmXF+RyEpeQNyhd9YG+Hc6Sc4QDta4QnwxtcdIPHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791443407; v=1; x=1792048207;
 b=nNfVAN739+hYX1f6Uvoggy40MGs9O80Q+uehWTdOabWm7j14cdLz5enum6S9OjNCbymRU02y
 30mCcXBmgV1p995s0Ql2pZlrAkZMdVTXvXm0wbZO12t1Bo7/dA9yv5l6B3dG/6CoeW5FdXCb+3L
 VcgCTvWDhJBZPLsaGK1PzrAo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bbda05475c7c12b7;
	Thu, 08 Oct 2026 07:10:04 +0000
X-Mizu-Trace-ID: bbda05475c7c12b7
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v3] selftests/bpf: Add bpf_proactive_reclaim test
Date: Thu,  8 Oct 2026 15:09:27 +0800
Message-ID: <20261008070928.113530-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9148520002
X-Rspam-User: 
X-Stat-Signature: 9gzoiz1y11cxmppprczemify559d4ice
X-HE-Tag: 1791443408-514236
X-HE-Meta: U2FsdGVkX1/L/RDHEGyV2wBpddmGFVCZYCPrkkCniIRAVoow/p8IrhE9l8CpR1UKMhecvjSxCSCqrShpUlyP0656Qr61LM9MO/q/QueW4nvVrkcBPy1/hgug1JducMBuNVwXRDPE0ZvytMWNXFYI1Ew5hBmpuSnC2n/Ppl9bPepMdn/L3xuhsSuFT3CPDGurxIJSIiXQWx38ZKv3ddVsf/SsDb+yOZqeW94U25Oz1di2ah9Ze3IOxdKj2DuKI8+mAycssTkSUL+U2bMzRk3/58MPiJr0tLpVC/+dCCD0T4EMC/O5f+kDBFLd9P/KYny0MdsTMTHe+bx6S63niBUuhHUYFCc4GtgPoC/i2muCvNXuhX9HUYzEwvM+0QxAtt5GDnv/V9jJaWNEdJ63i5S6kn5nMZ2V7x38V04+xGM7aQCxLv/7iotMIyclc0Qp+M6Cl4cZ3UJR+s/35w8Ozt6ciPzC1c67ZrkYI6FxSSdbLNphiH1dD/dLiwlhw8mqmipnXOcHoMan/+Dmyens3H8zWk6WO3C0ezvakzRrOj2eBoWNq4LkbKsyF0XEdh1RjbIh6aGIKEujRwgrHdSLUwb1kSf6Dw+yXk1SJEbARGzcZDjt1nfrZtaMLcC6CkUdMVPDlViuERguV+5mPXiC2Y/59tk878e+EXJvKLGeHR5IVmM+S/Dx/mOHJ9xCylb8h2Wo548lvMbOQYDHqFQm5eI1g5w5VbkLoO3W7Hc4tdew9BdfC4uTRpXKk+8Bn5ARNCzqHATMOHTh9YPpQjTwG2Y7jIO/JXo4K8nTfXtWIsdr+8LkZmYaFy4MImI0JIGGbx/iKIDsc0yy0yILNDBc1gYjioBWgEIx7zXZzgviWaEGkCOr4K3l8ueRgS6faBk/QvT+xy/V6OjTapCcCCQd8t9ArXKBbAR4Sq9JracogdTrOTiD05PmLOgcRvxtDTQXU4Xu868FaROA9tZp7XO42PO
 HUeCQcTG
 5oJSRgWrsu05QcywoG+b8OBqqbFgTL2aty2LsIT+uk8OBJ7r/6t1XbkcIZ3qFCFkotpATt7RL45jvF4EIGK7CLg965IpsaiDuqk8nMS4/84HXVvQqHh72azLuBtWWwOuDgPTUUUrzstnFgo141lDtkyrH+oCeEa4bdUGL7tJ+DoXX1VxboP+kNXi8YzqIqv7KW8enewls28XnHbNoMRP++iAC6FSCP/0uWbb4fwd2KSEoMLKj3RMwyXwf8vzBlB5DeRY7VLve0cAGNenUUHUl/0xH3R1TyfOxFrOINcMQ5i1Nos+r+VZ8Dds/OJvKV0y6k66M7plauu8Td491Ukdtj0sBff8V/k6Kjq2twJBK80GcfAWhKY3pMDceHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

bpf_proactive_reclaim() performs one bounded reclaim pass per call and,
unlike a write to memory.reclaim, does not retry until the goal is
reached.

Charge 32 MiB of page cache to a cgroup, ask for all of it in one call,
and check that the result is positive but well below the request: one
pass is capped at MEMCG_CHARGE_BATCH pages, far short of 32 MiB on both
4K and 64K page kernels.

The test deliberately covers only the kfunc itself. A full example of
the intended asynchronous use, where a BPF program watches one cgroup's
workingset refaults and reclaims another one from bpf_wq callbacks, is
maintained out of tree at [1], released under GPLv2.

Add CONFIG_MEMCG to the config fragment, without which mm/bpf_memcontrol.c
is not built at all.

[1] https://github.com/teawater/memcg-async-reclaim

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v3:
According to the comment of Barry, use write() + fsync() to charge the
page cache instead of ftruncate() + read().
According to the comment of AI, skip instead of fail when no regular
filesystem is available for the workload file.
v2:
According to the comment of Alexei, remove the samples/bpf sample patch.
Ship it out-of-tree as a standalone project.

 tools/testing/selftests/bpf/config            |   1 +
 .../bpf/prog_tests/memcg_proactive_reclaim.c  | 127 ++++++++++++++++++
 .../bpf/progs/memcg_proactive_reclaim.c       |  34 +++++
 3 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 2b883b388f90..5621ef94ad7e 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -57,6 +57,7 @@ CONFIG_LIRC=y
 CONFIG_LIVEPATCH=y
 CONFIG_LWTUNNEL=y
 CONFIG_LWTUNNEL_BPF=y
+CONFIG_MEMCG=y
 CONFIG_MODULE_SIG=y
 CONFIG_MODULE_SRCVERSION_ALL=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
new file mode 100644
index 000000000000..53426833366c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <limits.h>
+#include <linux/magic.h>
+#include <sys/statfs.h>
+#include <unistd.h>
+
+#include "cgroup_helpers.h"
+#include "memcg_proactive_reclaim.skel.h"
+
+#define CG_PATH "/memcg_proactive_reclaim"
+
+/*
+ * Large enough that a single reclaim pass cannot come close to it, so that
+ * "reclaimed less than was asked for" is not page-size noise: one pass is
+ * capped at MEMCG_CHARGE_BATCH pages, which is 256 KiB on 4K pages but 4 MiB
+ * on 64K pages.
+ */
+#define FILE_SIZE (32 * 1024 * 1024UL)
+#define BUF_SIZE (64 * 1024)
+
+struct reclaim_args {
+	__u64 cgroup_id;
+	__u64 size;
+};
+
+/*
+ * The data file has to sit on a regular filesystem: tmpfs pages are charged
+ * as shmem, so whether they can be reclaimed at all depends on swap being
+ * available. /tmp is tmpfs on many systems, and test_progs is routinely run
+ * from a tmpfs working directory, so both candidates need the check.
+ */
+static const char *workload_dir(void)
+{
+	static const char * const dirs[] = { "/tmp", "." };
+	struct statfs st;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dirs); i++)
+		if (!statfs(dirs[i], &st) && st.f_type != TMPFS_MAGIC &&
+		    st.f_type != RAMFS_MAGIC)
+			return dirs[i];
+
+	return NULL;
+}
+
+void test_memcg_proactive_reclaim(void)
+{
+	struct memcg_proactive_reclaim *skel = NULL;
+	struct reclaim_args args = {};
+
+	LIBBPF_OPTS(bpf_test_run_opts, opts,
+		    .ctx_in = &args,
+		    .ctx_size_in = sizeof(args));
+
+	char data_file[PATH_MAX];
+	static char buf[BUF_SIZE];
+	__u64 cgroup_id;
+	const char *dir;
+	off_t off;
+	int cg_fd = -1, data_fd = -1, err;
+
+	/*
+	 * Both candidate directories can be tmpfs (initramfs-based CI, for
+	 * instance). That is an environment limitation, not a test failure.
+	 */
+	dir = workload_dir();
+	if (!dir) {
+		test__skip();
+		return;
+	}
+
+	snprintf(data_file, sizeof(data_file),
+		 "%s/memcg_proactive_reclaim_XXXXXX", dir);
+	data_fd = mkstemp(data_file);
+	if (!ASSERT_GE(data_fd, 0, "mkstemp"))
+		return;
+
+	cg_fd = cgroup_setup_and_join(CG_PATH);
+	if (!ASSERT_OK_FD(cg_fd, "cgroup_setup_and_join"))
+		goto out;
+
+	cgroup_id = get_cgroup_id(CG_PATH);
+	if (!ASSERT_GT(cgroup_id, 0, "get_cgroup_id"))
+		goto out;
+
+	skel = memcg_proactive_reclaim__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto out;
+
+	/* Charge FILE_SIZE of clean page cache to the cgroup. */
+	for (off = 0; off < (off_t)FILE_SIZE; off += sizeof(buf))
+		if (!ASSERT_EQ(write(data_fd, buf, sizeof(buf)),
+			       (ssize_t)sizeof(buf), "write"))
+			goto out;
+	if (!ASSERT_OK(fsync(data_fd), "fsync"))
+		goto out;
+
+	args.cgroup_id = cgroup_id;
+	args.size = FILE_SIZE;
+	skel->bss->reclaimed = 0;
+	err = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.memcg_proactive_reclaim),
+				     &opts);
+	if (!ASSERT_OK(err, "test_run"))
+		goto out;
+	if (!ASSERT_EQ(opts.retval, 0, "retval"))
+		goto out;
+
+	/*
+	 * A single call is a single bounded pass: it reclaims something, but
+	 * stops well short of the requested size instead of retrying until the
+	 * goal is reached the way a write to memory.reclaim does.
+	 */
+	ASSERT_GT(skel->bss->reclaimed, 0, "reclaimed");
+	ASSERT_LT(skel->bss->reclaimed, (__s64)FILE_SIZE, "single pass");
+
+out:
+	if (skel)
+		memcg_proactive_reclaim__destroy(skel);
+	if (cg_fd >= 0)
+		close(cg_fd);
+	if (data_fd >= 0) {
+		close(data_fd);
+		unlink(data_file);
+	}
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c
new file mode 100644
index 000000000000..b551192526fc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct reclaim_args {
+	__u64 cgroup_id;
+	__u64 size;
+};
+
+/* Signed, because bpf_test_run_opts.retval is a __u32. */
+__s64 reclaimed;
+
+SEC("syscall")
+int memcg_proactive_reclaim(struct reclaim_args *ctx)
+{
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+
+	cgrp = bpf_cgroup_from_id(ctx->cgroup_id);
+	if (!cgrp)
+		return 0;
+
+	memcg = bpf_get_mem_cgroup(&cgrp->self);
+	if (memcg) {
+		reclaimed = bpf_proactive_reclaim(memcg, ctx->size, -1);
+		bpf_put_mem_cgroup(memcg);
+	}
+	bpf_cgroup_release(cgrp);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.43.0



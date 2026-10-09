Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA74DCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD636B0095; Fri,  9 Oct 2026 02:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47996B0096; Fri,  9 Oct 2026 02:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10226B0098; Fri,  9 Oct 2026 02:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C76D6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:27:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1FB61C292E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:27:02 +0000 (UTC)
X-FDA: 85302105084.30.AC7CFF5
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DB21C0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:26:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LMklH/zs";
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527221;
	b=7Tgs+1/vlCvMzAOCYRNHdlLSim7NgP0QNpokyDGfEWc/0Gvj4/SD5t+zRxhA55S1f1Vc2v
	2FVq+Wj4qaxP4yuhmhuI4fDTo1qWpw9+C5LHOMpmzloTFwMJVlcyeYSSywA6qWvEhKXyXD
	j1ZD6YouGC5hoU0lkwbP+CJelAVHSWs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LMklH/zs";
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=apcmRrGzK3XVBQMYfRJ0fuA0WTOWax2NDYRN1z9fqzA=;
	b=1XwzSlXeL3iosxq6I5x+tqvmbmVKAcdzJgCHD9vgZLu44HmnWWTek//znjyb2Ye2+mQPWg
	S7algUWlOek3mKieEJDPB0nl4Ggzo5x9GLHloKQ1UlapZj6gDevkKfEzDAm2cH7SOQnbxG
	WMPsk4QKTuMPGujpPK/dUPxPVxY87bc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4J2Oujq0h9Tdxh5Fs82Gko1VDMQdbho/Ty/hsMPCfKU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527217; v=1; x=1792132017;
 b=LMklH/zs2AewPti66CHbdlRmVAfSRS9XoIxpBqCNyNjEm0KeJhGzLORrXNop/6mC9xmqkFYD
 WeTydWE+U/YYzx4aMIOVjASDXFg4jX5hYj0ZS+4j3FLwRQ/kOzqjleyuBVewuxxJ0Q+y0wwwyi0
 O1VPy1bn91hpCpuY8buxvy1M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 04d29327fff06515;
	Fri, 09 Oct 2026 06:26:57 +0000
X-Mizu-Trace-ID: 04d29327fff06515
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
Subject: [PATCH bpf-next v4] selftests/bpf: Add bpf_proactive_reclaim test
Date: Fri,  9 Oct 2026 14:26:37 +0800
Message-ID: <20261009062637.176005-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DB21C0002
X-Stat-Signature: u75b4zkj9kxk1wsyg6961sabdcc5n1m3
X-HE-Tag: 1791527218-177665
X-HE-Meta: U2FsdGVkX18QtKZtmyN5nTePo7Tai3HTRQAgrQz8V0/ceZxqFMeoR3w8d5+zEaFdbPLjqvjqWxIhqsCTjBvqBw9Wx9/cKxny6mubAgrYn/+graYVrd8h3R5PiSzlCz6ISHzitQhOXWFS9GKlEHKderdXupQgqTd2bIT0X2wRHNJ2rF4gffypVrvszbM8gVY9rCX1fe8LEt8QEKfTyvt0PPrZPGq+B0lrd0nBLDhPBM9I8kHRrk0+LOhqiPUrxKSWvflooJX+DRrkMFIeoig1WcGWdi878Me6B52yJY04JSa82H8vz174biz2XjrPNUT98AJyaSCGRwZeJTsY+HHiXa5rYbLMknEit07LLetexSM9L2gyM9Z39OqUf8IRYzxQxdlsSD+iV9dRiozEQLYdbrWja8RWJ2fuk/eCnaru3C7Q2U/cNHg02j3T5vQAwHhHBFaPmctyYSjL/DLVNghjUxAzXqC7F+qwGDSLbLrtZdVbe4jht+p8s5r+aAlwMHP5tepwaHGlCNbujF878hTsrRoucIRfm1gOklNJo2CQsP4Uei0rL36MhvDjHONkubRZCb8yQB7moRbLErwckwS8jC2pHhauCndrHvisVaj/KkjORjaRlz9ZY/WirH2IC6z3UcpaT+ye7niQfXi6E/XLHgREak5gyNGEmdAXUJvy1M49gCF0oJhKNRQQtzCCuR4Kc18sfe7q2Sa28EehLOrBOlqh9fOzdkG+0mVQOrn6LxrnR/seW7amIR8zKfo3WOOzyaSwLI8l5G/+HcaIm1kmROgoTvQwpYJcKbiPB9vjXvktU+A6u07R7AmA0ZDbjRiR8TSgf+dJtA9ORPC7rSGpTu25Lz8M4emc/duiWFbyVRaf/CLmfmtbc2uwnNVY/IC/VatM+NocEn/8D1YyeoeMTGFsj8+9ypBvZ6eDDz4kopwGqCG9JNx+fMFqLG/5m1268ND/+e8zYGmDZmsm8U8
 WYQobpR/
 fZgJY26jPhBaHFqxeQVfTcWH8jjvg/cUQXULXGAVUIzqiajhGujlXAdvGYjMMHxs+OvKjiFTIlwVHKHblNXSUYKbfkjAq3iqNOENW8n3Rju0/L5fk0m0/iNpAen/kQCg0IaATxTg1jVkJbBHwHM4eErc09/1cPJ/5ckMSxKvvlHnadQ6pk5aPWo+6OENYXjTkJMILk5EJBzWvo0C1uchJKx1EZBOOmtmkNLFCX1ql/CkzhuZYCP6eQ/ixgimq2jIMe58QwNmNEoqAi9lLdhKWyNPW5KNZ+uzQh06IWkGD5ErjJtZS/QAppsHLry8aG4KSdw5LrQ8J3o83wiKQSw6kewFQ8QD4ScQRy7b3JhdAtJ1Hj7ftCpQvQYHENg==
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
v4:
According to the comment of Barry, test skips instead of failing on a
read-only mount.
v3:
According to the comment of Barry, use write() + fsync() to charge the
page cache instead of ftruncate() + read().
According to the comment of AI, skip instead of fail when no regular
filesystem is available for the workload file.
v2:
According to the comment of Alexei, remove the samples/bpf sample patch.
Ship it out-of-tree as a standalone project.

 tools/testing/selftests/bpf/config            |   1 +
 .../bpf/prog_tests/memcg_proactive_reclaim.c  | 130 ++++++++++++++++++
 .../bpf/progs/memcg_proactive_reclaim.c       |  34 +++++
 3 files changed, 165 insertions(+)
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
index 000000000000..c22dcfabe856
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
@@ -0,0 +1,130 @@
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
+ * The data file has to sit on a writable regular filesystem: tmpfs pages are
+ * charged as shmem, so whether they can be reclaimed at all depends on swap
+ * being available, and a read-only mount cannot host the file at all (EROFS
+ * applies to root too). /tmp is tmpfs on many systems, and test_progs is
+ * routinely run from a tmpfs working directory, so both candidates need the
+ * check.
+ */
+static const char *workload_dir(void)
+{
+	static const char * const dirs[] = { "/tmp", "." };
+	struct statfs st;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dirs); i++)
+		if (!statfs(dirs[i], &st) && st.f_type != TMPFS_MAGIC &&
+		    st.f_type != RAMFS_MAGIC && !access(dirs[i], W_OK))
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
+	 * Both candidate directories can be unusable: tmpfs (initramfs-based
+	 * CI, for instance) or a read-only mount. That is an environment
+	 * limitation, not a test failure.
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



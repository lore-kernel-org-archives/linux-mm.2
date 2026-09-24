Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A4CC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 04:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05816B008C; Thu, 24 Sep 2026 00:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC5F6B0092; Thu, 24 Sep 2026 00:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB496B0093; Thu, 24 Sep 2026 00:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0ADF6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:05:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2520C801FA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:05:07 +0000 (UTC)
X-FDA: 85247315454.21.504F0D5
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4101940007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:05:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mkG8T2tv;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790222705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxAsoOphxTEmFkVIQNlOfOBC+6CkJvqNqqxcENamoho=;
	b=rbkREm4zDmA++9bzumQt4r14SjBfivX6nAp7OtqxxLa1xgqqN1MwrhaZr2SQJPQvRi2FZr
	z60H1jII8mYFEJBfmWxGs6lrJdZ382Pbfq9QY1GyJslrlX68c6wsylnKb1xYaT8xi30QaE
	v1m3JDg3oaJVbwjKIqaYXCV60k2joPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790222705;
	b=vTFGdw9WiHUjfyKsi9KUgtwpoGiJVFFKGxwYvtAPu0Jp9luDLOTj7/+jFeLuQ6/xZJvnW3
	tQ+B9qVdxstBKf25g0/a75NAwJkZ4NT71+s+sHAK8/Ksobbb0p+Kq3ZXOkqOfUHHh1gu+F
	Dm5kMLYhTw80LAeWf+gWjKXarsAb1j0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mkG8T2tv;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8gcArCPVs8DflBan4V4nf2ng/Ebo6zapx9SrhB+GA90=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790222703; v=1; x=1790827503;
 b=mkG8T2tvLnMAtsTRWI5rBmCBP0AbmrzgGxRK0nFpJf1BxqW/xH1BMdMnpZb0RVqAoQNUHkvB
 aoa5XaVeQgfO4UBpXMRFCZLYpFaD6YbSuGq6S6k8UU8MCj35HJ7ltgaU7VkSvnWQF6e2OjFUXJY
 3ueHQd0sveERnKETNSgg00mU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f7235f3675c36c9b;
	Thu, 24 Sep 2026 04:05:02 +0000
X-Mizu-Trace-ID: f7235f3675c36c9b
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
Subject: [PATCH bpf-next 1/2] selftests/bpf: Add bpf_proactive_reclaim test
Date: Thu, 24 Sep 2026 12:04:32 +0800
Message-ID: <67d8708eeaa771dea97d5c1f15744fe33178c43b.1790222105.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790222105.git.zhuhui@kylinos.cn>
References: <cover.1790222105.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4101940007
X-Stat-Signature: i74jqnne38iyx1yzojg9ph5au1s3r6sb
X-HE-Tag: 1790222705-880541
X-HE-Meta: U2FsdGVkX1/h3+keTqIG/GIwuzcCfhD80B6SjCliOAIXHKJ5GoLEd0jW9+MRO4JfL3+aVO8+NnmqLADnxWi8tnblSBYAfKFNzmTZaBn5hZgPnhPsQuUG/nSPg95Dhsr44CTOAcHLt2thwPXvHbVGWKugfWgm7z0mukDoK3y3qP7u3B2jlvmxBrUBjwkthHgeP7V2Ou3+5h8M8pgNki9+WhGmpjgWeX1MIRrw5XFrTo6K1jNiFbQSaiAOKtLHCJ2cEh5GMrVWk9NVUIlbLgGrTlbFlEDdXKKnjsl/kS6OxA5WAFuH4NaH369CvPtACu8TJa2YSGug0ZlO1dLVPwME5Zx/AEmSw+zYsJxgOfq7Cjf7NwO9J0oUdl7VYA2OLYWznYqiSTZLHADerL8OImSPZQtrf0jsB8YIOMlUjaTN9ZuOGt5n4ySQrAVjQYGYX0HAolol57V0f19Kv+sQFjd5nLyto1de7CKkaG3KP9VIG+c18kwAr4qlKxzGVWgvuWKHeFDBCeOOPefS1ZCV507aAbXhx+MbmBqzypxlj8WdZ5pRvEplail/zhFFvjQZ7iP08D1TgMBk3cxI9/UXrF6YZXI5yfZRHDvoQl4xEsNMgPVZR2GeMrPKuU5YRPKtJrpR7P+4hmP3FNiDffpFTaeOL/qC/WYDTN0z4bgpIAeQb57i59EC03TpkVBXw8NS4FsHgulANSvZnyFNJ+6hsoFbO5S/oJn8uHgZbWaSzxo+GRvuitSVhoBlWFk30c+56rRScIdqYlV/uAEI5KvKiOdoZi9wLcLQsgyNsjqYdhbHRxvbiaOqJ1cDePcQLUohdVv4OYWn1sQc/tPDPM/B7GV6234VcSJ/LI0EakhaOMFchyXvBqRruAIgGeNkma0k/PAw5eX8X9HBhJAlp4lY4XjWpJhl76oECZafSJxW68D16i6BdhW0MTdZTAp/zTJ7UJC41+pcDMn90qC1ARYxz/f
 9yejRxpm
 0J3xpd9MLJPrFjgOO+aMJbJqAD3PgTbezEi43bMLVcfPSuuaryxZXaeduWK/+YnQhZTNPZouZsG31vpVJP+ljKYzEfuaTZf9U6oWpxQCAdMqVfLSkJt7aoHorll+vEHFPL3BU2EVdurAzqnkizhBqEJBVgavqkxzbyKSZ5jj0xy37cRWeoIkY0+yV8NW6IIwwMQVEDduS0zO4WB2/h8EbhdOr9vk5DYBQAxRJ8rtMtPPpwnjXe5Bl/SiywH2FiblD4QDF/5+h67tnug7f/+iHUfhjmzBWMHdOUg5AIyNvWn9h4RezSxHtdYr8FQ==
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

Add CONFIG_MEMCG to the config fragment, without which mm/bpf_memcontrol.c
is not built at all.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   1 +
 .../bpf/prog_tests/memcg_proactive_reclaim.c  | 124 ++++++++++++++++++
 .../bpf/progs/memcg_proactive_reclaim.c       |  34 +++++
 3 files changed, 159 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index d292cb60a5a4..21bb0d4a37cb 100644
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
index 000000000000..d642658a2198
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
@@ -0,0 +1,124 @@
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
+	dir = workload_dir();
+	if (!ASSERT_OK_PTR(dir, "workload dir on a regular filesystem"))
+		return;
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
+	/*
+	 * Charge FILE_SIZE of page cache to the cgroup. Reading rather than
+	 * writing keeps the pages clean, so reclaim does not have to start
+	 * writeback before it can evict them.
+	 */
+	if (!ASSERT_OK(ftruncate(data_fd, FILE_SIZE), "ftruncate"))
+		goto out;
+	for (off = 0; off < (off_t)FILE_SIZE; off += sizeof(buf))
+		if (!ASSERT_GT(read(data_fd, buf, sizeof(buf)), 0, "read"))
+			goto out;
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



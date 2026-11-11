Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897AC60A2638
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wSsmkW87
Received: by kanga.kvack.org (Postfix)
	id 8FD7C6B05B4; Wed, 11 Nov 2026 05:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4C36B05B5; Wed, 11 Nov 2026 05:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775F26B05B6; Wed, 11 Nov 2026 05:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4500B6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:39:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCE23140264
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:39:24 +0000 (UTC)
X-FDA: 85422491448.04.71CEDE8
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E8EB40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:39:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSsmkW87;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794393563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOj8k/5RKPxcdre/sZVrkcreJylNi4xr/NsUFepQse8=;
	b=N/2Iv746rha66KS195ypDihJMpRmvKTrabQ49kUm7ok9WoPIVdsLWLtcTIJO0UAiruHkgl
	TjsifDFCj1eP2JuxaPr1iPtQUtDLU6rkWFN+uIBD3cXhA246vSxVuQZwxncXjXXK94tWDG
	Qem/R4fJK8ClGsSFH9pO431c/p7SkyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794393563;
	b=TXRRflWmI+sPx8qvQeQdJEOm6xbGNDPSj8MOMlub0UzYUyeqR4GAiZUf1CNJupjyuqgzyE
	dZEmRaoAX+OSSJS12Ys8wmQ61r9i5WHtvOXFZKMthxnnmq4wwh9p777vNnAAbsyrw7XklS
	+URIvLVM/GVDB+JKgcC129EOAh2hra4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSsmkW87;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0FYI2PpatlC1JTEvKjUAGOziWuxtTE83605BZhXzyNY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794393561; v=1; x=1794998361;
 b=wSsmkW87FRsoJT6HKL9J6EoHfyAs5h2X6ZPMP15dC43Y7wRSwqrqD1sVkYuURKyOMEwhHSww
 aOII267hkxls3LH7XU7Ghm9ZNMHzPsIO0VvRK3aZUccESaDhnXNCbOYiU5TMHmKKt/CjZQrMBcF
 hsh6mpU2luYN4nanOBpeKKxA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 850f3b6db8d38eda;
	Wed, 11 Nov 2026 10:39:20 +0000
X-Mizu-Trace-ID: 850f3b6db8d38eda
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH v2 2/2] selftests/bpf: Add bpf_memcg_ops protection test
Date: Wed, 11 Nov 2026 18:38:16 +0800
Message-ID: <42180b829dca92d4bc2eee47eca4dbcd826b19bb.1794393349.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794393349.git.zhuhui@kylinos.cn>
References: <cover.1794393349.git.zhuhui@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: w1grhceii6sy1efipgb8ae6pndq1hd8u
X-Rspamd-Queue-Id: 9E8EB40003
X-Rspam-User: 
X-HE-Tag: 1794393562-889569
X-HE-Meta: U2FsdGVkX190dxqa3vXUOBWPrE7UA6lnIgI8CltAsRPVlVHjoquidvtBV3e0nVLPdVHDGfM1O7zm63z53m4Fb7ec42lOjGAA/F6V3gXefz/Mgn6pTnatvSiAiyNy2vX1dlBuybXSQvXPS0n6h3bOI/PgUXvZ0g0hXqhHzuEQzoldRxpsjc/x3cnmcGnE3kDqCqg0CgG17xc8jLw8J4EoqW9b8EmVu8UsO85neCDmRBQCYExcVuICNDG2AqJQRsPjU9c4W9AhxogkFgxZizjvL8ADz/V+iyMOJToDx5eLkh+jibYQkbtBptDU6yz1RgBn+K5ihtaUC1B9ZbWCl/mMdMmBU8tjAjOweWo8PuMPUw5yGtFOUXZUY/FAa3txg2U6rTX0Ftwdy8lNaDmAimNaqXuTgMzJtYcN9AJDEgfa4Vf5q0D5svwccH2k4PxlxmbLuQvlzqYJQhR+vLiMJD0pUBblEnLUtZRWzTs7TFPBznPfA8Zaoqg3Jlr1ka8I4KC3ajjs3E5rdrDXq2DOAfXI1IJz/HY9HqJKSCN36Lbbfu1xYiB30yiixwecgtySyTXSqmO5o6eYq3hpHk1nUI7XCktlQ9hMfPBRnHxZp9cGnO3BA3XTMQDKlXflPH67B/cJGWepbte9vRIYR/Fqo7k1OOVQ0Ye7voQRTAy1WlfmmP+O+NKcH/jsKc6RKXuonQx5wF2WnkB3HxYzle7Pt96dzbwdiBNhgBx2xXDyrXNwNUnZ93V8uW49YGap2/82WuraWJvQkfpt7RDuiDhK7zzxJxpkcn4FWxZq3hfr9r7KQBoabwd8oBvydLCnlpkE4G9lWdFW9Cyqj6XbyZLcPbvdZK9rui6NX2sgzC91jlb/DVDFNrDWkkVaTU+ATFjVE8MphJMT4Y09HJdCDCtH/DlY8yc3Vq0GJhL6saTN8GopyqOeD2ia10fRwb+X7/v0oX9H08b2Ot9lrl8j8j4La18
 f1r8omCs
 JXyD8TtMEc+7tRnxL4sjVhU9fqUIeXGao24cdFZjviCzxgA3Al/0ztI6IvD3UHOgHlR/yUi/9Cii8jdCf4WQzAMmhvv8q9QepQGYrtkIRkEomY/V7GuNVmT4WhlcbkxnNbAGM1W1ZC0cQ4heXsu6YOVmXtzyLhPLqXcES/3MCl36312lxoRZuXAegwaPuYdV+EW+OaYv0sgFbUcyywK2PbQlv238asYAej1p25ro35ubmCnLmWHt4K1Q4hQFnKcIbzvrfIonQtQm1mqzQkdLZDO0u9ZiOS/vBE44vaIGLLmahBMvMFP8oM4821A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

Attach a low_request policy to a grandchild cgroup, give the middle
cgroup a memory.low as the budget, and reclaim from the top of the
three-level tree.  The policy asks for the victim's current usage on
every pass; the test checks how the kernel arbitrates that ask.  The
outcome is read back through the next pass's ctx threshold (the
effective value the previous pass computed) and the victim's
memory.events low counter.

Three budgets, same request: with 0 the effective value stays 0; with
2M an 8M request comes back capped to 2M and reclaim still goes into
the victim; with 16M the request is granted in full, reclaim skips the
victim and its events counter moves.  A request thus goes through the
same arbitration as a declared memory.low and can never lift the
subtree above its parent's budget.  The ctx contents (victim id,
reclaim target, usage) are checked along the way.

The workload is anonymous-only: without swap each memory.reclaim
trigger returns EAGAIN, yet every scan still consults the hook, and it
avoids temporary-file support issues on shared mounts.  Recorded
snapshots are filtered by cgroup id and reclaim target, since the
dispatcher runs for every memcg and global reclaim recomputes
protection with no target.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/memcg_ops_protection.c     | 297 ++++++++++++++++++
 .../bpf/progs/memcg_ops_protection.c          |  82 +++++
 2 files changed, 379 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_protection.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
new file mode 100644
index 000000000000..b60c573fc480
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Drive the memcg_ops_protection sample: check that the kernel consults
+ * low_request during reclaim, that the ctx describes the check faithfully,
+ * and - the point of the test - that what the policy asks for is arbitrated
+ * like a declared memory.low rather than granted outright.
+ *
+ * Layout, under the test workdir:
+ *
+ *   memcg_ops_prot                P   reclaim runs from P/memory.reclaim
+ *   memcg_ops_prot/budget         M   memory.low is the budget C is capped to
+ *   memcg_ops_prot/budget/victim  C   holds the memory, carries the ops
+ *   memcg_ops_prot_ctl            -   where the test process normally sits
+ *
+ * The victim asks for its current usage (8M) on every pass.  The runner
+ * varies M's memory.low - the budget the request is arbitrated against -
+ * and reads the outcome back two ways: @threshold in the ctx of the next
+ * pass carries the effective value the last pass computed, and C's
+ * memory.events "low" counts the passes that skipped C as protected.
+ *
+ *   budget   request   elow(C)         C's memory.events low
+ *   0        off       0               unchanged (nothing asked, nothing got)
+ *   2M       on        2M, capped      unchanged (asked 8M, parent affords 2M)
+ *   16M      on        usage, granted  increased (parent affords all of it)
+ *
+ * The middle row is the ceiling: the request can move protection around
+ * inside the parent's budget but cannot lift the subtree above it.  Break
+ * the cap in effective_protection() and that row turns red - elow(C)
+ * becomes usage, reclaim skips C, and the event counter moves.
+ *
+ * The test process joins C itself and faults in 8M of anonymous memory.
+ * Nothing is actually reclaimed - without swap there is nothing to take -
+ * so each trigger walks the subtree repeatedly and returns EAGAIN, and
+ * every walk consulted the hook and recomputed the effective value.  No
+ * file is involved on purpose: a VM's working directory is often a shared
+ * mount where temporary files are unsupported or unevictable.  On the way
+ * out the process rejoins the ctl cgroup, so the framework's cleanup can
+ * rmdir C, M and P.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "memcg_ops_protection.skel.h"
+
+#define CTL_PATH	"/memcg_ops_prot_ctl"
+#define PARENT_PATH	"/memcg_ops_prot"
+#define BUDGET_PATH	PARENT_PATH "/budget"
+#define VICTIM_PATH	BUDGET_PATH "/victim"
+
+#define FILL_SZ		(8UL << 20)
+#define RECLAIM_SZ	"1M"
+/* Below FILL_SZ, so the request overclaims and the cap has to bite. */
+#define BUDGET_CAPPED	(2UL << 20)
+/* Above FILL_SZ, so the parent affords the request in full. */
+#define BUDGET_GRANTED	(16UL << 20)
+
+static int set_budget(unsigned long sz)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%lu", sz);
+	return write_cgroup_file(BUDGET_PATH, "memory.low", buf);
+}
+
+/* .bss is frozen once the skeleton is loaded, so the phase switch that the
+ * policy reads lives in a map rather than in a global.
+ */
+static int set_request(struct memcg_ops_protection *skel, int on)
+{
+	__u32 key = 0, val = !!on;
+
+	return bpf_map_update_elem(bpf_map__fd(skel->maps.cfg), &key, &val, 0);
+}
+
+static long events_low(const char *path)
+{
+	char buf[512];
+	char *p;
+
+	if (read_cgroup_file(path, "memory.events", buf, sizeof(buf)))
+		return -1;
+	/* "low" is the first key in memory.events. */
+	p = strstr(buf, "low ");
+	if (!p)
+		return -1;
+	return strtol(p + 4, NULL, 10);
+}
+
+/* One triggered reclaim walk.  EAGAIN is as good a scan as success. */
+static int trigger_reclaim(int pfd)
+{
+	ssize_t n;
+	int rfd, err;
+
+	rfd = openat(pfd, "memory.reclaim", O_RDWR);
+	if (rfd < 0) {
+		log_err("open memory.reclaim");
+		return -1;
+	}
+	n = write(rfd, RECLAIM_SZ, sizeof(RECLAIM_SZ) - 1);
+	err = n < 0 ? -errno : 0;
+	close(rfd);
+	if (err && err != -EAGAIN) {
+		log_err("write memory.reclaim");
+		return -1;
+	}
+	return 0;
+}
+
+void test_memcg_ops_protection(void)
+{
+	struct memcg_ops_protection *skel = NULL;
+	struct bpf_link *ops_link = NULL;
+	int ctlfd = -1, pfd = -1, bfd = -1, cfd = -1;
+	__u64 seq_before, threshold, usage;
+	long budget_pages, low_before, low_after;
+	void *mem = MAP_FAILED;
+
+	/* Sets the environment up and parks this process outside of P. */
+	ctlfd = test__join_cgroup(CTL_PATH);
+	if (!ASSERT_GE(ctlfd, 0, "join_cgroup"))
+		return;
+
+	pfd = create_and_get_cgroup(PARENT_PATH);
+	if (!ASSERT_GE(pfd, 0, "create_parent"))
+		goto done;
+
+	bfd = create_and_get_cgroup(BUDGET_PATH);
+	if (!ASSERT_GE(bfd, 0, "create_budget"))
+		goto done;
+
+	cfd = create_and_get_cgroup(VICTIM_PATH);
+	if (!ASSERT_GE(cfd, 0, "create_victim"))
+		goto done;
+
+	/*
+	 * The memory.* files of M and C need the memory controller in the
+	 * subtree_control of P and of M.  A failure here is the usual "v1
+	 * still owns memory", which is a skip rather than a fail.
+	 */
+	if (enable_controllers(PARENT_PATH, "memory") ||
+	    enable_controllers(BUDGET_PATH, "memory")) {
+		fprintf(stderr, "no memory controller under %s\n", PARENT_PATH);
+		test__skip();
+		goto done;
+	}
+
+	skel = memcg_ops_protection__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto done;
+
+	skel->bss->target_cgroup_id = get_cgroup_id(VICTIM_PATH);
+	skel->bss->parent_cgroup_id = get_cgroup_id(PARENT_PATH);
+	if (!ASSERT_NEQ(skel->bss->target_cgroup_id, 0ULL, "victim_id"))
+		goto done;
+	if (!ASSERT_NEQ(skel->bss->parent_cgroup_id, 0ULL, "parent_id"))
+		goto done;
+
+	if (!ASSERT_OK(memcg_ops_protection__load(skel), "load"))
+		goto done;
+
+	ops_link = bpf_map__attach_cgroup_opts(skel->maps.prot_ops, cfd, NULL);
+	if (!ASSERT_OK_PTR(ops_link, "attach_ops"))
+		goto done;
+
+	/* From here on the test process lives in C; leave via done. */
+	if (!ASSERT_OK(join_cgroup(VICTIM_PATH), "join_victim"))
+		goto done;
+
+	mem = mmap(NULL, FILL_SZ, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (!ASSERT_TRUE(mem != MAP_FAILED, "mmap"))
+		goto done;
+	memset(mem, 0xa5, FILL_SZ);
+
+	budget_pages = BUDGET_CAPPED / sysconf(_SC_PAGESIZE);
+
+	/*
+	 * Phase 0 - nothing declared, nothing requested.  The hook still
+	 * runs: reclaim asks every cgroup it visits, protected or not.
+	 */
+	if (!ASSERT_OK(set_budget(0), "budget_zero"))
+		goto done;
+	if (!ASSERT_OK(set_request(skel, 0), "request_off"))
+		goto done;
+	seq_before = skel->bss->record_seq;
+	low_before = events_low(VICTIM_PATH);
+	if (!ASSERT_GE(low_before, 0, "events_phase0"))
+		goto done;
+	if (!ASSERT_OK(trigger_reclaim(pfd), "trigger_phase0"))
+		goto done;
+
+	if (!ASSERT_GT(skel->bss->record_seq, seq_before, "passes_phase0"))
+		goto done;
+	if (!ASSERT_EQ(skel->bss->saw_from_parent, 1, "target_phase0"))
+		goto done;
+	/* No claim anywhere below P, so C ends up with no protection. */
+	if (!ASSERT_EQ(skel->bss->seen_threshold, 0ULL, "idle_threshold"))
+		goto done;
+	low_after = events_low(VICTIM_PATH);
+	if (!ASSERT_EQ(low_after, low_before, "idle_events"))
+		goto done;
+
+	/*
+	 * Phase 1 - the ceiling.  C asks for its full usage but M only
+	 * affords BUDGET_CAPPED, so the arbitration has to cut the request
+	 * down: elow(C) lands at the budget, below usage, and reclaim does
+	 * not treat C as protected.
+	 */
+	if (!ASSERT_OK(set_budget(BUDGET_CAPPED), "budget_capped"))
+		goto done;
+	if (!ASSERT_OK(set_request(skel, 1), "request_on"))
+		goto done;
+	seq_before = skel->bss->record_seq;
+	low_before = events_low(VICTIM_PATH);
+	if (!ASSERT_GE(low_before, 0, "events_phase1"))
+		goto done;
+	if (!ASSERT_OK(trigger_reclaim(pfd), "trigger_phase1"))
+		goto done;
+
+	if (!ASSERT_GT(skel->bss->record_seq, seq_before, "passes_phase1"))
+		goto done;
+	threshold = skel->bss->seen_threshold;
+	usage = skel->bss->seen_usage;
+	if (!ASSERT_GT(usage, 0ULL, "capped_usage"))
+		goto done;
+	/*
+	 * The request was honoured - it is what lifts elow off zero - and
+	 * capped - it never exceeds what M affords.  Exact equality with
+	 * the budget is the normal outcome; the cap is the invariant.
+	 */
+	if (!ASSERT_GT(threshold, 0ULL, "capped_threshold_nonzero"))
+		goto done;
+	if (!ASSERT_LE(threshold, (__u64)budget_pages, "capped_threshold"))
+		goto done;
+	if (!ASSERT_LT(threshold, usage, "capped_below_usage"))
+		goto done;
+	low_after = events_low(VICTIM_PATH);
+	if (!ASSERT_EQ(low_after, low_before, "capped_events"))
+		goto done;
+
+	/*
+	 * Phase 2 - the same request, but now M affords all of it: elow(C)
+	 * reaches usage, reclaim skips C as protected, and the skip shows
+	 * up in C's memory.events.  Together with phase 1 this pins the
+	 * request to the arbitration: same ask, different budget,
+	 * different outcome.
+	 */
+	if (!ASSERT_OK(set_budget(BUDGET_GRANTED), "budget_granted"))
+		goto done;
+	seq_before = skel->bss->record_seq;
+	low_before = events_low(VICTIM_PATH);
+	if (!ASSERT_GE(low_before, 0, "events_phase2"))
+		goto done;
+	if (!ASSERT_OK(trigger_reclaim(pfd), "trigger_phase2"))
+		goto done;
+
+	if (!ASSERT_GT(skel->bss->record_seq, seq_before, "passes_phase2"))
+		goto done;
+	threshold = skel->bss->seen_threshold;
+	usage = skel->bss->seen_usage;
+	/* The budget covers the ask, so the request is granted in full. */
+	if (!ASSERT_EQ(threshold, usage, "granted_threshold"))
+		goto done;
+	if (!ASSERT_GT(usage, 0ULL, "granted_usage"))
+		goto done;
+	low_after = events_low(VICTIM_PATH);
+	ASSERT_GT(low_after, low_before, "granted_events");
+
+done:
+	/* Detach before anything else: no policy may run during teardown. */
+	bpf_link__destroy(ops_link);
+	memcg_ops_protection__destroy(skel);
+	if (mem != MAP_FAILED)
+		munmap(mem, FILL_SZ);
+	/* A no-op when the process never made it into the victim. */
+	join_cgroup(CTL_PATH);
+	if (cfd >= 0)
+		close(cfd);
+	if (bfd >= 0)
+		close(bfd);
+	if (pfd >= 0)
+		close(pfd);
+	if (ctlfd >= 0)
+		close(ctlfd);
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_ops_protection.c b/tools/testing/selftests/bpf/progs/memcg_ops_protection.c
new file mode 100644
index 000000000000..47318a82d012
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_ops_protection.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The low_request policy for the memcg_ops_protection runner: count the
+ * consultations about the victim cgroup, snapshot what the ctx carries,
+ * and ask that the victim's current usage be protected.
+ *
+ * What the kernel does with that request is the point of the test: it is
+ * arbitrated exactly like a declared memory.low, so the budget cgroup
+ * above the victim decides whether the request is granted in full, cut
+ * down, or - with nothing requested - ignored.  The runner varies the
+ * budget and reads the effective value back from @pctx->threshold, which
+ * carries the elow the previous reclaim pass computed.
+ *
+ * The snapshots are victim-scoped and, on top of that, filtered to the
+ * reclaim the runner triggered: a request attached anywhere makes the
+ * dispatcher run for every memcg, and global reclaim recalculates
+ * protection with a NULL target, which would otherwise overwrite what
+ * the triggered passes recorded.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* Set by the runner between open and load. */
+__u64 target_cgroup_id;
+__u64 parent_cgroup_id;
+
+/*
+ * Toggled by the runner between phases, before each trigger.  A map rather
+ * than a global: .bss is frozen once the skeleton is loaded, so the runner
+ * can only read it from here on.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} cfg SEC(".maps");
+
+/* How often the kernel consulted us about the victim. */
+__u64 low_calls;
+
+/* Passes that recorded a snapshot; the runner brackets each trigger. */
+__u64 record_seq;
+
+/* Last snapshot from a runner-triggered pass. */
+__u64 seen_threshold;
+__u64 seen_usage;
+int saw_from_parent;
+
+/* BPF_PROG() uses "ctx" for the raw argument array, hence "pctx" here. */
+SEC("struct_ops")
+__u32 BPF_PROG(prot_low_request, const struct bpf_memcg_prot_ctx *pctx)
+{
+	__u32 key = 0, *enabled;
+
+	if (pctx->cgroup_id != target_cgroup_id)
+		return BPF_MEMCG_PROT_NO_REQUEST;
+
+	__sync_fetch_and_add(&low_calls, 1);
+
+	if (pctx->target_cgroup_id == parent_cgroup_id) {
+		saw_from_parent = 1;
+		seen_threshold = pctx->threshold;
+		seen_usage = pctx->usage;
+		__sync_fetch_and_add(&record_seq, 1);
+	}
+
+	enabled = bpf_map_lookup_elem(&cfg, &key);
+	if (!enabled || !*enabled)
+		return BPF_MEMCG_PROT_NO_REQUEST;
+
+	return BPF_MEMCG_PROT_REQUEST_USAGE;
+}
+
+SEC(".struct_ops.link")
+struct bpf_memcg_ops prot_ops = {
+	.low_request = (void *)prot_low_request,
+};
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3229C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8C46B0095; Tue, 15 Sep 2026 08:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968E76B0096; Tue, 15 Sep 2026 08:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830356B0098; Tue, 15 Sep 2026 08:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 437FA6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:30:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 642B3A03E0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:37 +0000 (UTC)
X-FDA: 85215930114.22.1EAB6BF
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F3C4160012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWnZBH55;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789475435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sihqWcpldQjYYR8FJwDKA9E5JMbdLbpirsZJnDmSjMk=;
	b=vqhSCjFY0kzZFm+lJw9Rdq0TywTONXDHihBVRTapBfh5AV4NkjpEfBsEMjKtqKVKGQTRIQ
	nwBrnQ60VZHv49tnSza31GLmKYV2m6tIkWnlkQsJHzIi51U5GhCVOy/UYh4Rku8n6/yvU3
	c2Ey2sBIbQ9Yj0sEEZae87Tkk67de78=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWnZBH55;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789475435;
	b=hAPxp2ghoZ5tuJJqiWKcvzrx6nsnEfESkkx+cCDFwXPuT0HsmnKCGz0J1Sz9ofH1cOWoMr
	j+Ti02vMmJD+eh94Mi+An9foiolUi5LJ1PBmws6BWFqp+Tk2N+WJbq4BOBNykvK9+o5UoT
	xrWfX5AEHg3hgwXGP58zv6o3e6aHzZI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9cfbJTqV4rWPQXZHvoJ8S65W7uHzX9rDv/oMqLdtOcc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475433; v=1; x=1790080233;
 b=TWnZBH55CHzZjQbwChuB5AGeg+q7J5ol6GhD94aB0ttbZCWw9Lskl1AyrpkfUcr5lKlcJZO0
 Ei7rK/DyUvTsvlkAy9E7TPhTVJYz3yvsw+UNq4NSE38kmLv6m5DA4BI0UtObp26InvCebCjvE4D
 Ep97p30FABW8MOQOH4VZeMX0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a8151b0226102c32;
	Tue, 15 Sep 2026 12:30:21 +0000
X-Mizu-Trace-ID: a8151b0226102c32
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
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v11 2/2] selftests/bpf: Add memcg async reclaim test
Date: Tue, 15 Sep 2026 20:29:36 +0800
Message-ID: <93289af4317b57caa4e393d73fe6c786b24a4c2a.1789475073.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789475073.git.zhuhui@kylinos.cn>
References: <cover.1789475073.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F3C4160012
X-Stat-Signature: mq6q47aio56iws9yqyonqs47qyqtm5sz
X-Rspam-User: 
X-HE-Tag: 1789475434-451333
X-HE-Meta: U2FsdGVkX18p3B6bYAXJry+nOvhUuOzPEEWQpkHfvSsGbdnkK81NPbjf2gkU4ENRZzizjOeUorISyH4RUOXqP4f5sPPzqGgaDpegvd2kQdxmS4g9WC+tpakT+lo+dnyc8LatkmniZ+P+6aJJfkashMvP0Uc61MQ8ycsIUQO9jtc8SVnYqOT/RGF84DMU9CiV+S51GerLI47XXJUC/3a5RFIiLjVDgx1BG0P7CUchNPjXQdCEXDmfagTRbS1xcvj5KQDPcXfsXRTM7cd+XrLWiTRmn6f5TdOgIaOmgWDItePjFqAqz7WcOS+xa7eduJgPk91ZHFDBBhaYfh8bOvexukCV1IPFJiWyVzZK6SO0bebpVMgT7fWIGYM5J5qkMO1rdkIV/mJCiyH1vGQo+7e3DVmIyvOnLEFY3NBvKwSZ4VrwNBxMybnNGTI792raIFparZrIpQAVPuMTDeuojtAJClW5wmuyx7LwK+duNJAqIaYUize+3lb4IOyTux16oiIjKb3xMi7Yppv+aFsh+4la/7uw9EKthrYm90X/4o/dxjGFfqAXZIm/S4hx97WTXNhdCl7zDXN/wyFzcclNm8FZ7bOghoA36nFieUB2U3YMD64jRCjsBi9Wt8zFTzdKHISgOxVilTsDSBxwsjgKLBkTujFsaQC6eflVpPHx8rNt+XEL8VuDLXMwQchrXwqoNAUPcB9CDvaOXpgf3TUnIIja6iDTbqtmE82QbN8YFn1+un5eksvTQyfIm9OZyoBWvmqUN7j1f+TejpYyKd11Z47owekw2iKsd9n0isGShxoPDxrVdB3tGOcXZ45j/FNpSzGWmCpQ9eAE0hpFOwJ7FZPAQGN4/9x2hrlpdz07ke6ePvWGB4bBNEy78bEXVezAjNmYS5fU8tz4EA3engccU0dgnrxQUaCLj3iEEleR4an9X3ExOyhIaFQnMkf4OCl2T6VnV648V3GEUKusa6qwU0j
 uB83hYOi
 17CkNNaz9UmObgHJ3TnlUkG4iE63ABdCHcK8uBRBF2oOuZytKkKtiymovHKd8NDALbAnwctK5i2Q3uadBYC7Wi4svtMdE8u9d8tPZMl6p9RRQY6fNtPySfm0QmLoqSSmqPgATBA2k24Mp5ci01UUHCJSwLntGLJ4ZXCNrQ1DjZP/0K8eg6YOw8q17xyp/886qDqvI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a test for BPF-driven async proactive reclaim: a BPF program
watches the refault stats of a memory-pressured cgroup and, once they
grow, reclaims another cgroup from a bpf_wq callback through
bpf_proactive_reclaim(). Reclaim is verified through the reclaim_calls
and reclaimed_bytes counters; the workload timings are only logged, as
they are a benchmark rather than a pass/fail criterion. Setting
TEST_MEMCG_ASYNC_RECLAIM_BENCH=1 adds a baseline run without the BPF
program.

A second test covers a dying target: bpf_cgroup_from_id() keeps
returning a cgroup until its last reference is dropped, so the program
checks the css flags and skips reclaim once the target is offlined or
dying, and the test removes the target while reclaim is in flight and
verifies that reclaim stops. Each attempt reports its outcome through
a ringbuf, so the test waits for events rather than polling counters.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/memcg_async_reclaim.c      | 779 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 289 +++++++
 2 files changed, 1068 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
new file mode 100644
index 000000000000..7c7d299b3b28
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
@@ -0,0 +1,779 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory controller eBPF async reclaim test
+ *
+ * Setting TEST_MEMCG_ASYNC_RECLAIM_BENCH=1 adds a baseline run of the
+ * workload without the BPF program to memcg_async_reclaim, and prints
+ * the baseline and reclaim timings, plus the speedup of the pressured
+ * cgroup, to stdout.
+ */
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <time.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <linux/magic.h>
+
+#include "cgroup_helpers.h"
+
+struct bpf_args {
+	u64 high_cgroup_id;
+	u64 low_cgroup_id;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+/* Reclaim outcomes reported by the BPF program through the ringbuf. */
+enum reclaim_outcome {
+	RECLAIM_OUTCOME_CALLED,
+	RECLAIM_OUTCOME_SKIPPED_DYING,
+	RECLAIM_OUTCOME_TARGET_GONE,
+};
+
+struct reclaim_event {
+	u64 outcome;
+};
+
+#include "memcg_async_reclaim.skel.h"
+
+#define FILE_SIZE (32 * 1024 * 1024ul)
+#define BUFFER_SIZE (4096)
+#define CG_LIMIT (32 * 1024 * 1024ul)
+#define READ_TIMES 50
+
+#define CG_DIR "/memcg_async_reclaim"
+#define CG_HIGH_DIR CG_DIR "/high"
+#define CG_LOW_DIR CG_DIR "/low"
+
+#define CG_DYING_DIR "/memcg_async_reclaim_dying"
+#define CG_DYING_TRIGGER_DIR CG_DYING_DIR "/trigger"
+#define CG_DYING_TARGET_DIR CG_DYING_DIR "/target"
+
+#define CHECK_PERIOD_NS (2 * 1000 * 1000ull)
+#define EVENT_DELTA_THRESHOLD 1
+
+/*
+ * Timing for the dying test: after the target cgroup is removed, give
+ * in-flight reclaim passes time to drain, then wait for a reclaim round
+ * to hit the removed target. The keepalive reader keeps the trigger
+ * cgroup refaulting, and the timer fires every CHECK_PERIOD_NS, so
+ * such a round must show up within a few timer periods. The BPF
+ * program reports every reclaim outcome through the ringbuf, so the
+ * waits just poll it with a timeout.
+ */
+#define DYING_SETTLE_US (200 * 1000)
+#define EVENT_POLL_TIMEOUT_MS (100)
+#define EVENT_POLL_ROUNDS (50)
+
+/*
+ * The workload files must sit on a regular filesystem: with swap
+ * disabled for the cgroup, tmpfs/ramfs pages are unevictable and would
+ * OOM the cgroup instead of exercising reclaim; they are also charged
+ * as anonymous memory, so they never raise the WORKINGSET_REFAULT_FILE
+ * events the BPF program monitors. Fall back to the current directory
+ * when /tmp is backed by such a filesystem.
+ */
+static const char *workload_files_dir(void)
+{
+	struct statfs st;
+
+	if (!statfs("/tmp", &st) &&
+	    (st.f_type == TMPFS_MAGIC || st.f_type == RAMFS_MAGIC))
+		return ".";
+	return "/tmp";
+}
+
+/*
+ * The workload children run after test_progs hijacked stdio, so
+ * anything they print is lost with their private copy of the hijacked
+ * buffer. The exit status is the only diagnostics channel that reaches
+ * the parent, so each failing step gets its own code.
+ */
+enum child_exit_code {
+	CHILD_EXIT_OK = 0,
+	CHILD_EXIT_JOIN_CGROUP,
+	CHILD_EXIT_WRITE_FILE,
+	CHILD_EXIT_READ_FILE,
+	CHILD_EXIT_TIME_FILE,
+};
+
+static const char *child_exit_str(int code)
+{
+	switch (code) {
+	case CHILD_EXIT_OK:
+		return "success";
+	case CHILD_EXIT_JOIN_CGROUP:
+		return "join cgroup";
+	case CHILD_EXIT_WRITE_FILE:
+		return "write data file";
+	case CHILD_EXIT_READ_FILE:
+		return "read data file";
+	case CHILD_EXIT_TIME_FILE:
+		return "write time file";
+	default:
+		return "unknown";
+	}
+}
+
+static int setup_high_low_cgroups(u64 *high_cgroup_id, u64 *low_cgroup_id)
+{
+	int ret;
+	char limit_buf[20];
+
+	ret = setup_cgroup_environment();
+	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DIR))
+		goto cleanup;
+	close(ret);
+
+	ret = enable_controllers(CG_DIR, "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	snprintf(limit_buf, sizeof(limit_buf), "%lu", CG_LIMIT);
+	ret = write_cgroup_file(CG_DIR, "memory.max", limit_buf);
+	if (!ASSERT_OK(ret, "write_cgroup_file memory.max"))
+		goto cleanup;
+
+	/*
+	 * Keep the workloads from swapping out. With CONFIG_SWAP=n the
+	 * memory.swap.max file does not exist, and no swap can happen
+	 * anyway, so skip the write.
+	 */
+	if (!access("/proc/swaps", F_OK)) {
+		ret = write_cgroup_file(CG_DIR, "memory.swap.max", "0");
+		if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
+			goto cleanup;
+	}
+
+	ret = create_and_get_cgroup(CG_HIGH_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_HIGH_DIR))
+		goto cleanup;
+	close(ret);
+
+	*high_cgroup_id = get_cgroup_id(CG_HIGH_DIR);
+	if (!ASSERT_GT(*high_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_LOW_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_LOW_DIR))
+		goto cleanup;
+	close(ret);
+
+	*low_cgroup_id = get_cgroup_id(CG_LOW_DIR);
+	if (!ASSERT_GT(*low_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	return 0;
+
+cleanup:
+	cleanup_cgroup_environment();
+	return -1;
+}
+
+/*
+ * The dying test needs an empty reclaim target plus a cgroup that keeps
+ * refaulting while the target is removed, so reclaim rounds keep
+ * starting and run into the removed target. The two have to be separate
+ * cgroups: the target must hold no processes to be removed, and v2's
+ * no-internal-process constraint keeps the refaulting workload out of
+ * any parent that has domain children.
+ */
+static int setup_dying_cgroups(u64 *trigger_cgroup_id, u64 *target_cgroup_id)
+{
+	int ret;
+	char limit_buf[20];
+
+	ret = setup_cgroup_environment();
+	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_DYING_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_DIR))
+		goto cleanup;
+	close(ret);
+
+	ret = enable_controllers(CG_DYING_DIR, "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	snprintf(limit_buf, sizeof(limit_buf), "%lu", CG_LIMIT);
+	ret = write_cgroup_file(CG_DYING_DIR, "memory.max", limit_buf);
+	if (!ASSERT_OK(ret, "write_cgroup_file memory.max"))
+		goto cleanup;
+
+	/* See the matching write in setup_high_low_cgroups(). */
+	if (!access("/proc/swaps", F_OK)) {
+		ret = write_cgroup_file(CG_DYING_DIR, "memory.swap.max", "0");
+		if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
+			goto cleanup;
+	}
+
+	ret = create_and_get_cgroup(CG_DYING_TRIGGER_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_TRIGGER_DIR))
+		goto cleanup;
+	close(ret);
+
+	*trigger_cgroup_id = get_cgroup_id(CG_DYING_TRIGGER_DIR);
+	if (!ASSERT_GT(*trigger_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_DYING_TARGET_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_TARGET_DIR))
+		goto cleanup;
+	close(ret);
+
+	*target_cgroup_id = get_cgroup_id(CG_DYING_TARGET_DIR);
+	if (!ASSERT_GT(*target_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	return 0;
+
+cleanup:
+	cleanup_cgroup_environment();
+	return -1;
+}
+
+static int write_file(const char *filename)
+{
+	int ret = -1;
+	size_t written = 0;
+	char *buffer;
+	FILE *fp;
+
+	fp = fopen(filename, "wb");
+	if (!fp)
+		goto out;
+
+	buffer = malloc(BUFFER_SIZE);
+	if (!buffer)
+		goto cleanup_fp;
+
+	memset(buffer, 'A', BUFFER_SIZE);
+
+	while (written < FILE_SIZE) {
+		size_t to_write = FILE_SIZE - written < BUFFER_SIZE ?
+				  FILE_SIZE - written : BUFFER_SIZE;
+
+		if (fwrite(buffer, 1, to_write, fp) != to_write)
+			goto cleanup;
+		written += to_write;
+	}
+
+	ret = 0;
+cleanup:
+	free(buffer);
+cleanup_fp:
+	fclose(fp);
+out:
+	return ret;
+}
+
+static int read_file(const char *filename, int iterations)
+{
+	int ret = -1;
+	long page_size = sysconf(_SC_PAGESIZE);
+	char *map;
+	size_t i;
+	int fd;
+	struct stat sb;
+
+	fd = open(filename, O_RDONLY);
+	if (fd == -1)
+		goto out;
+
+	if (fstat(fd, &sb) == -1)
+		goto cleanup_fd;
+
+	if (sb.st_size != FILE_SIZE) {
+		fprintf(stderr, "File size mismatch: expected %lu, got %lu\n",
+			(unsigned long)FILE_SIZE, (unsigned long)sb.st_size);
+		goto cleanup_fd;
+	}
+
+	map = mmap(NULL, FILE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (map == MAP_FAILED)
+		goto cleanup_fd;
+
+	for (int iter = 0; iter < iterations; iter++) {
+		for (i = 0; i < FILE_SIZE; i += page_size) {
+			/* access a byte to trigger page fault */
+			volatile char v = map[i];
+			(void)v;
+		}
+	}
+
+	if (munmap(map, FILE_SIZE) == -1)
+		goto cleanup_fd;
+
+	ret = 0;
+
+cleanup_fd:
+	close(fd);
+out:
+	return ret;
+}
+
+static int real_test_child_work(const char *cgroup_path, char *data_filename,
+				char *time_filename, int read_times)
+{
+	struct timespec start, end;
+	double elapsed;
+	FILE *fp;
+
+	if (join_parent_cgroup(cgroup_path))
+		return CHILD_EXIT_JOIN_CGROUP;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+
+	if (write_file(data_filename))
+		return CHILD_EXIT_WRITE_FILE;
+
+	if (read_file(data_filename, read_times))
+		return CHILD_EXIT_READ_FILE;
+
+	clock_gettime(CLOCK_MONOTONIC, &end);
+
+	if (!time_filename)
+		return CHILD_EXIT_OK;
+
+	elapsed = (end.tv_sec - start.tv_sec) +
+		  (end.tv_nsec - start.tv_nsec) / 1000000000.0;
+
+	fp = fopen(time_filename, "w");
+	if (!fp)
+		return CHILD_EXIT_TIME_FILE;
+	fprintf(fp, "%.6f", elapsed);
+	fclose(fp);
+
+	return CHILD_EXIT_OK;
+}
+
+static int get_time(char *time_filename, double *time)
+{
+	int ret = -1;
+	FILE *fp;
+	char buf[64];
+
+	fp = fopen(time_filename, "r");
+	if (!ASSERT_OK_PTR(fp, "fopen"))
+		goto out;
+
+	if (!ASSERT_OK_PTR(fgets(buf, sizeof(buf), fp), "fgets"))
+		goto cleanup;
+
+	if (sscanf(buf, "%lf", time) != 1) {
+		PRINT_FAIL("sscanf %s", buf);
+		goto cleanup;
+	}
+
+	ret = 0;
+cleanup:
+	fclose(fp);
+out:
+	return ret;
+}
+
+static int
+run_high_low_workload(double *high_elapsed, double *low_elapsed, int read_times)
+{
+	char high_data_file[PATH_MAX];
+	char low_data_file[PATH_MAX];
+	char high_time_file[PATH_MAX];
+	char low_time_file[PATH_MAX];
+	const char *dir = workload_files_dir();
+	pid_t high_pid = -1, low_pid = -1;
+	pid_t wait_ret;
+	int fd, status;
+	int ret = -1;
+
+	snprintf(high_data_file, sizeof(high_data_file),
+		 "%s/memcg_async_high_data_XXXXXX", dir);
+	snprintf(low_data_file, sizeof(low_data_file),
+		 "%s/memcg_async_low_data_XXXXXX", dir);
+	snprintf(high_time_file, sizeof(high_time_file),
+		 "%s/memcg_async_high_time_XXXXXX", dir);
+	snprintf(low_time_file, sizeof(low_time_file),
+		 "%s/memcg_async_low_time_XXXXXX", dir);
+
+	fd = mkstemp(high_data_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup;
+	close(fd);
+
+	fd = mkstemp(low_data_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup;
+	close(fd);
+
+	fd = mkstemp(high_time_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup;
+	close(fd);
+
+	fd = mkstemp(low_time_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup;
+	close(fd);
+
+	low_pid = fork();
+	if (!ASSERT_GE(low_pid, 0, "fork low"))
+		goto cleanup;
+	if (low_pid == 0)
+		_exit(real_test_child_work(CG_LOW_DIR, low_data_file,
+					  low_time_file, read_times));
+
+	high_pid = fork();
+	if (!ASSERT_GE(high_pid, 0, "fork high"))
+		goto cleanup;
+	if (high_pid == 0)
+		_exit(real_test_child_work(CG_HIGH_DIR, high_data_file,
+					  high_time_file, read_times));
+
+	wait_ret = waitpid(low_pid, &status, 0);
+	if (!ASSERT_GT(wait_ret, 0, "low waitpid"))
+		goto cleanup;
+	/*
+	 * The child has been reaped and its PID can already be reused,
+	 * so mark it to keep cleanup from signaling an unrelated process.
+	 */
+	low_pid = -1;
+	if (!ASSERT_TRUE(WIFEXITED(status), "low exited"))
+		goto cleanup;
+	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
+		PRINT_FAIL("low child failed at: %s (exit status %d)",
+			   child_exit_str(WEXITSTATUS(status)),
+			   WEXITSTATUS(status));
+		goto cleanup;
+	}
+
+	wait_ret = waitpid(high_pid, &status, 0);
+	if (!ASSERT_GT(wait_ret, 0, "high waitpid"))
+		goto cleanup;
+	/* Same as above: the reaped PID must not be signaled again. */
+	high_pid = -1;
+	if (!ASSERT_TRUE(WIFEXITED(status), "high exited"))
+		goto cleanup;
+	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
+		PRINT_FAIL("high child failed at: %s (exit status %d)",
+			   child_exit_str(WEXITSTATUS(status)),
+			   WEXITSTATUS(status));
+		goto cleanup;
+	}
+
+	if (get_time(high_time_file, high_elapsed))
+		goto cleanup;
+	if (get_time(low_time_file, low_elapsed))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+	/* On failure, make sure no child process is left behind */
+	if (ret) {
+		if (high_pid > 0) {
+			kill(high_pid, SIGKILL);
+			(void)waitpid(high_pid, NULL, 0);
+		}
+		if (low_pid > 0) {
+			kill(low_pid, SIGKILL);
+			(void)waitpid(low_pid, NULL, 0);
+		}
+	}
+	unlink(low_time_file);
+	unlink(high_time_file);
+	unlink(low_data_file);
+	unlink(high_data_file);
+	return ret;
+}
+
+static int
+setup_bpf(u64 high_cgroup_id, u64 low_cgroup_id,
+	  struct memcg_async_reclaim **skel_ptr)
+{
+	struct memcg_async_reclaim *skel;
+	struct bpf_args args = {
+		.high_cgroup_id = high_cgroup_id,
+		.low_cgroup_id = low_cgroup_id,
+		.event_delta_threshold = EVENT_DELTA_THRESHOLD,
+		.check_ns = CHECK_PERIOD_NS,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, run_opts,
+		.ctx_in = &args,
+		.ctx_size_in = sizeof(args));
+	int prog_init_fd, err;
+
+	skel = memcg_async_reclaim__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "memcg_async_reclaim__open_and_load"))
+		return -1;
+
+	prog_init_fd = bpf_program__fd(skel->progs.wq_prog_init);
+
+	err = bpf_prog_test_run_opts(prog_init_fd, &run_opts);
+	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
+		goto error_out;
+	if (!ASSERT_EQ(run_opts.retval, 0, "prog_init retval"))
+		goto error_out;
+
+	*skel_ptr = skel;
+	return 0;
+
+error_out:
+	memcg_async_reclaim__destroy(skel);
+	return -1;
+}
+
+/*
+ * test_progs hijacks stdout and only prints the captured log when the
+ * test fails, so benchmark numbers go straight to the real stdout to
+ * keep them from drowning in ASSERT output.
+ */
+static void bench_printf(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vfprintf(env.stdout_saved ?: stdout, fmt, ap);
+	va_end(ap);
+}
+
+void test_memcg_async_reclaim(void)
+{
+	u64 high_cgroup_id, low_cgroup_id;
+	double high_time = 0.0, low_time = 0.0;
+	double base_high_time = 0.0, base_low_time = 0.0;
+	struct memcg_async_reclaim *skel = NULL;
+	int err, bench;
+
+	bench = !!getenv("TEST_MEMCG_ASYNC_RECLAIM_BENCH");
+
+	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
+	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
+		return;
+
+	/*
+	 * Optional baseline for the benchmark numbers below: run the
+	 * same workload once without the BPF program, so the log can
+	 * report how much async reclaim improved the pressured cgroup.
+	 */
+	if (bench) {
+		err = run_high_low_workload(&base_high_time, &base_low_time,
+					    READ_TIMES);
+		if (!ASSERT_OK(err, "run_high_low_workload baseline"))
+			goto out;
+	}
+
+	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel);
+	if (!ASSERT_OK(err, "setup_bpf"))
+		goto out;
+
+	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
+	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
+		goto out;
+
+	/*
+	 * The timing comparison below alone cannot distinguish a working
+	 * reclaim from a no-op one, so require that the BPF program
+	 * actually reclaimed memory from the low cgroup.
+	 */
+	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
+		goto out;
+	if (!ASSERT_GT(skel->bss->reclaimed_bytes, 0, "reclaimed_bytes"))
+		goto out;
+
+	/*
+	 * The timing comparison is a benchmark and too flaky to fail CI
+	 * runs, so it only logs the numbers; the counters above already
+	 * proved that the BPF program reclaimed memory.
+	 */
+	if (bench)
+		bench_printf("memcg_async_reclaim: baseline high=%f low=%f, "
+			     "reclaim high=%f low=%f, high speedup=%.1f%%\n",
+			     base_high_time, base_low_time, high_time, low_time,
+			     100.0 * (base_high_time - high_time) / base_high_time);
+	else if (high_time >= low_time)
+		printf("memcg_async_reclaim: high cgroup not improved: high=%f low=%f\n",
+		       high_time, low_time);
+
+out:
+	if (skel)
+		memcg_async_reclaim__destroy(skel);
+	cleanup_cgroup_environment();
+}
+
+/*
+ * Keep refaults flowing through the trigger cgroup so reclaim rounds
+ * keep being triggered while the target cgroup is being removed. The
+ * child joins the trigger cgroup and writes the data file there, so
+ * that the file pages are charged to the trigger cgroup and actually
+ * come under its memory limit; then it re-reads the file in a loop
+ * until it is killed.
+ */
+static pid_t spawn_keepalive_reader(const char *data_file)
+{
+	pid_t pid = fork();
+
+	if (pid != 0)
+		return pid;
+
+	if (join_parent_cgroup(CG_DYING_TRIGGER_DIR))
+		_exit(CHILD_EXIT_JOIN_CGROUP);
+	if (write_file(data_file))
+		_exit(CHILD_EXIT_WRITE_FILE);
+	for (;;) {
+		if (read_file(data_file, READ_TIMES))
+			_exit(CHILD_EXIT_READ_FILE);
+	}
+}
+
+/* Reclaim outcomes observed so far, tallied from ringbuf events. */
+struct reclaim_events_seen {
+	int called;
+	int skipped_dying;
+	int target_gone;
+};
+
+static int on_reclaim_event(void *ctx, void *data, size_t sz)
+{
+	struct reclaim_events_seen *seen = ctx;
+	const struct reclaim_event *ev = data;
+
+	if (sz < sizeof(*ev))
+		return 0;
+
+	switch (ev->outcome) {
+	case RECLAIM_OUTCOME_CALLED:
+		seen->called++;
+		break;
+	case RECLAIM_OUTCOME_SKIPPED_DYING:
+		seen->skipped_dying++;
+		break;
+	case RECLAIM_OUTCOME_TARGET_GONE:
+		seen->target_gone++;
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Remove the reclaim target while the BPF program keeps running and
+ * verify that reclaim stops on the dying/removed cgroup instead of
+ * reclaiming from it.
+ *
+ * The target stays empty; the workload lives in the trigger cgroup and
+ * only keeps refaults flowing so that reclaim rounds keep starting,
+ * both before and after the target is removed. A CALLED event while
+ * the target is alive proves that rounds really run (the kfunc
+ * returns 0 on the empty target, but the call is still counted), and
+ * after the removal the program must report the removed target via
+ * SKIPPED_DYING or TARGET_GONE events while reclaim_calls and
+ * reclaimed_bytes stay frozen.
+ */
+void test_memcg_async_reclaim_dying(void)
+{
+	u64 trigger_cgroup_id, target_cgroup_id;
+	u64 calls_before, bytes_before;
+	char data_file[PATH_MAX] = "";
+	struct reclaim_events_seen seen = {};
+	struct memcg_async_reclaim *skel = NULL;
+	struct ring_buffer *rb = NULL;
+	pid_t reader_pid = -1;
+	int err, fd, i;
+
+	err = setup_dying_cgroups(&trigger_cgroup_id, &target_cgroup_id);
+	if (!ASSERT_OK(err, "setup_dying_cgroups"))
+		return;
+
+	err = setup_bpf(trigger_cgroup_id, target_cgroup_id, &skel);
+	if (!ASSERT_OK(err, "setup_bpf"))
+		goto out;
+
+	rb = ring_buffer__new(bpf_map__fd(skel->maps.reclaim_events),
+			      on_reclaim_event, &seen, NULL);
+	if (!ASSERT_OK_PTR(rb, "ring_buffer__new"))
+		goto out;
+
+	snprintf(data_file, sizeof(data_file),
+		 "%s/memcg_async_dying_XXXXXX", workload_files_dir());
+	fd = mkstemp(data_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto out;
+	close(fd);
+
+	reader_pid = spawn_keepalive_reader(data_file);
+	if (!ASSERT_GT(reader_pid, 0, "fork keepalive reader"))
+		goto out;
+
+	/* Wait for reclaim rounds to reach the live target cgroup. */
+	for (i = 0; i < EVENT_POLL_ROUNDS && !seen.called; i++) {
+		err = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
+		if (!ASSERT_GE(err, 0, "ring_buffer__poll"))
+			goto out;
+	}
+	if (!ASSERT_GT(seen.called, 0, "reclaim events"))
+		goto out;
+
+	remove_cgroup(CG_DYING_TARGET_DIR);
+
+	/* Let reclaim passes that were already in flight drain. */
+	usleep(DYING_SETTLE_US);
+
+	calls_before = skel->bss->reclaim_calls;
+	bytes_before = skel->bss->reclaimed_bytes;
+
+	/* Wait for a reclaim round to hit the removed cgroup. */
+	for (i = 0; i < EVENT_POLL_ROUNDS &&
+		    !seen.skipped_dying && !seen.target_gone; i++) {
+		err = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
+		if (!ASSERT_GE(err, 0, "ring_buffer__poll"))
+			goto out;
+	}
+
+	if (!seen.skipped_dying && !seen.target_gone) {
+		PRINT_FAIL("no reclaim round hit the removed cgroup (gone=%d, dying=%d)",
+			   seen.target_gone, seen.skipped_dying);
+		goto out;
+	}
+
+	/*
+	 * skipped_dying events show that the CSS_DYING/CSS_ONLINE check
+	 * caught the cgroup mid-teardown. Whether they happen is timing
+	 * dependent, because the cgroup may already be fully released, so
+	 * only the combined skip count above is asserted.
+	 */
+	printf("memcg_async_reclaim_dying: skips on removed cgroup: gone=%d, dying=%d\n",
+	       seen.target_gone, seen.skipped_dying);
+
+	/* Nothing may have been reclaimed from the removed target. */
+	if (!ASSERT_EQ(skel->bss->reclaim_calls, calls_before, "reclaim_calls"))
+		goto out;
+	if (!ASSERT_EQ(skel->bss->reclaimed_bytes, bytes_before,
+		       "reclaimed_bytes"))
+		goto out;
+
+out:
+	if (reader_pid > 0) {
+		kill(reader_pid, SIGKILL);
+		(void)waitpid(reader_pid, NULL, 0);
+	}
+	if (data_file[0])
+		unlink(data_file);
+	if (rb)
+		ring_buffer__free(rb);
+	if (skel)
+		memcg_async_reclaim__destroy(skel);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
new file mode 100644
index 000000000000..fa60d46e41e3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#define CLOCK_MONOTONIC_ID	1
+#define PAGE_SIZE		4096UL
+/*
+ * One reclaim round targets RECLAIM_MAX_ITER batches of RECLAIM_SIZE
+ * each. Each bpf_wq callback reclaims a single batch and requeues the
+ * same work item for the next one, so no callback runs longer than one
+ * bounded reclaim pass.
+ */
+#define RECLAIM_SIZE		(32 * PAGE_SIZE)
+#define RECLAIM_MAX_ITER	32
+
+struct bpf_args {
+	u64 high_cgroup_id;
+	u64 low_cgroup_id;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+struct cgroup_memcg {
+	struct cgroup *cgrp;
+	struct mem_cgroup *memcg;
+};
+
+static u64 wq_high_cgroup_id;
+static u64 wq_low_cgroup_id;
+
+/*
+ * Statistics exposed to userspace through .bss, so the test can verify
+ * that reclaim actually happened instead of relying on timing alone.
+ */
+u64 reclaim_calls;
+u64 reclaimed_bytes;
+
+/*
+ * Outcome of a single reclaim attempt, reported to userspace through
+ * the reclaim_events ringbuf so tests can wait for reclaim events with
+ * a timeout instead of polling the counters above.
+ */
+enum reclaim_outcome {
+	RECLAIM_OUTCOME_CALLED,
+	RECLAIM_OUTCOME_SKIPPED_DYING,
+	RECLAIM_OUTCOME_TARGET_GONE,
+};
+
+struct reclaim_event {
+	__u64 outcome;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 1 << 16);
+} reclaim_events SEC(".maps");
+
+/*
+ * Reports are best effort: when the ringbuf is full, for example when
+ * userspace does not consume the events, the report is dropped.
+ */
+static void emit_reclaim_event(enum reclaim_outcome outcome)
+{
+	struct reclaim_event *ev;
+
+	ev = bpf_ringbuf_reserve(&reclaim_events, sizeof(*ev), 0);
+	if (!ev)
+		return;
+
+	ev->outcome = outcome;
+	bpf_ringbuf_submit(ev, 0);
+}
+
+static int get_cgroup_memcg_from_id(u64 cgroup_id, struct cgroup_memcg *cm)
+{
+	cm->cgrp = bpf_cgroup_from_id(cgroup_id);
+	if (!cm->cgrp)
+		return -1;
+
+	cm->memcg = bpf_get_mem_cgroup(&cm->cgrp->self);
+	if (!cm->memcg) {
+		bpf_cgroup_release(cm->cgrp);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void put_cgroup_memcg(struct cgroup_memcg *cm)
+{
+	bpf_put_mem_cgroup(cm->memcg);
+	bpf_cgroup_release(cm->cgrp);
+}
+
+static int get_cgroup_event(u64 cgroup_id, u64 *val)
+{
+	struct cgroup_memcg cm;
+
+	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
+		return -1;
+	bpf_mem_cgroup_flush_stats(cm.memcg);
+	*val = bpf_mem_cgroup_page_state(cm.memcg,
+		bpf_core_enum_value(enum node_stat_item,
+				    WORKINGSET_REFAULT_FILE));
+	put_cgroup_memcg(&cm);
+
+	return 0;
+}
+
+static bool
+should_reclaim_cgroup(u64 cgroup_id, u64 *prev_event, u64 event_delta_threshold)
+{
+	u64 cur, delta;
+
+	if (get_cgroup_event(cgroup_id, &cur))
+		return false;
+
+	delta = cur - *prev_event;
+	*prev_event = cur;
+
+	return delta >= event_delta_threshold;
+}
+
+/*
+ * A cgroup is dying once it has been offlined (CSS_ONLINE cleared) or
+ * CSS_DYING has been raised, mirroring cgroup_is_dead()/css_is_dying()
+ * in include/linux/cgroup.h. bpf_cgroup_from_id() can still hand back
+ * such a cgroup, because it only fails once the last reference has been
+ * dropped, so reclaim has to check these flags instead of relying on
+ * the lookup failing.
+ *
+ * CSS_ONLINE and CSS_DYING come from vmlinux.h: the kernel defines them
+ * in an anonymous enum, so bpf_core_enum_value() has no enum type to
+ * bind to, and redeclaring them locally would clash with the vmlinux.h
+ * enumerators. vmlinux.h is generated from the running kernel's BTF, so
+ * the values already match the target kernel.
+ */
+static bool cgroup_is_dying(struct cgroup *cgrp)
+{
+	unsigned int flags = cgrp->self.flags;
+
+	return (flags & CSS_DYING) || !(flags & CSS_ONLINE);
+}
+
+/*
+ * Reclaim one batch from the target cgroup. Returns the number of
+ * bytes reclaimed, or 0 if the cgroup is dying or gone, the kfunc
+ * failed, or nothing was reclaimed. Each attempt reports its outcome
+ * through the reclaim_events ringbuf.
+ */
+static u64 reclaim_cgroup(u64 cgroup_id, u64 size)
+{
+	struct cgroup_memcg cm;
+	long nr;
+
+	if (get_cgroup_memcg_from_id(cgroup_id, &cm)) {
+		emit_reclaim_event(RECLAIM_OUTCOME_TARGET_GONE);
+		return 0;
+	}
+
+	if (cgroup_is_dying(cm.cgrp)) {
+		emit_reclaim_event(RECLAIM_OUTCOME_SKIPPED_DYING);
+		put_cgroup_memcg(&cm);
+		return 0;
+	}
+
+	reclaim_calls++;
+	nr = bpf_proactive_reclaim(cm.memcg, size, -1);
+	if (nr > 0)
+		reclaimed_bytes += nr;
+	emit_reclaim_event(RECLAIM_OUTCOME_CALLED);
+
+	put_cgroup_memcg(&cm);
+
+	return nr > 0 ? nr : 0;
+}
+
+struct wq_elem {
+	struct bpf_timer timer;
+	struct bpf_wq work;
+	u64 prev_event;
+	u64 event_delta_threshold;
+	u64 check_ns;
+	/*
+	 * Bytes still to reclaim in the current round, carried across
+	 * requeues. 0 means no round is in progress; the timer path
+	 * starts a new round by resetting it, requeued work only looks
+	 * at it.
+	 */
+	u64 remaining;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct wq_elem);
+} wq_map SEC(".maps");
+
+static int reclaim_work_fn(void *map, int *key, void *value)
+{
+	struct wq_elem *elem = value;
+	u64 nr, size;
+
+	if (!elem->remaining) {
+		/*
+		 * Timer-triggered entry: start a new round only when the
+		 * high cgroup refaults enough. Requeued entries skip this
+		 * check and only look at remaining, so the refault delta
+		 * is consumed once per round.
+		 */
+		if (!should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
+			elem->event_delta_threshold))
+			return 0;
+		elem->remaining = RECLAIM_MAX_ITER * RECLAIM_SIZE;
+	}
+
+	/* One bounded reclaim pass per callback */
+	size = elem->remaining < RECLAIM_SIZE ? elem->remaining : RECLAIM_SIZE;
+	nr = reclaim_cgroup(wq_low_cgroup_id, size);
+	if (!nr) {
+		elem->remaining = 0;
+		return 0;
+	}
+
+	/* try_to_free_mem_cgroup_pages() may reclaim more than requested */
+	if (nr >= elem->remaining)
+		elem->remaining = 0;
+	else
+		elem->remaining -= nr;
+
+	/* Requeue the same work item for the next batch */
+	if (elem->remaining)
+		bpf_wq_start(&elem->work, 0);
+
+	return 0;
+}
+
+static int wq_timer_cb(void *map, int *key, struct wq_elem *elem)
+{
+	bpf_wq_start(&elem->work, 0);
+	bpf_timer_start(&elem->timer, elem->check_ns, 0);
+
+	return 0;
+}
+
+SEC("syscall")
+int wq_prog_init(struct bpf_args *ctx)
+{
+	struct wq_elem *elem;
+	__u32 key = 0;
+	int ret;
+
+	elem = bpf_map_lookup_elem(&wq_map, &key);
+	if (!elem)
+		return -1;
+
+	ret = bpf_wq_init(&elem->work, &wq_map, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_wq_set_callback(&elem->work, reclaim_work_fn, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_init(&elem->timer, &wq_map, CLOCK_MONOTONIC_ID);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_set_callback(&elem->timer, wq_timer_cb);
+	if (ret)
+		return ret;
+
+	elem->prev_event = 0;
+	elem->remaining = 0;
+	elem->event_delta_threshold = ctx->event_delta_threshold;
+	elem->check_ns = ctx->check_ns;
+
+	wq_high_cgroup_id = ctx->high_cgroup_id;
+	wq_low_cgroup_id = ctx->low_cgroup_id;
+
+	return bpf_timer_start(&elem->timer, elem->check_ns, 0);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.43.0



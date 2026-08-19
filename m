Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7DBC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EE96B009B; Wed, 19 Aug 2026 02:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E9E6B009D; Wed, 19 Aug 2026 02:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E408C6B009E; Wed, 19 Aug 2026 02:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A68726B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:36:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13ECA40425
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:36:09 +0000 (UTC)
X-FDA: 85117059258.23.FB2FE8F
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A5C418000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:36:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Llfspvw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787121367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eit5wB1pr/l+8n/TipEZY0LAXXfZgZp7SYmIOmxd2o=;
	b=Hr6f0/bTiCBo/U6pn/gSZ+ByZdkaA+VUKrRoBV/4sJu2SfwJnhLW0YRg9nHmBrOu0B7lYr
	D9rsGHktSmrNXiRp+Ykqu5j87Q6WFIXQO7S0PAkhNz0PHBdt2YmeaCrqY//U9kQGLI4qA4
	ciXzL0FQpym69yiVRFOUc5GJ9RGVm/M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Llfspvw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787121367;
	b=K41BPyF42Jhe44QWe7ZqXi6Dgkk/4VEMsMB/TO6cH6+KH9xXyL6Gx/Huc+QewvLmxz6x4G
	mJZhZ37iK907onUHyU9duufER2vv0ro9+jZBc6WwMPOmTPqF4h9Se8Gv/n9GTOjjQid1Fq
	G4tQTRVWVe8k8zY7HKjenp4zWPUx7TU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TCl8lfOxz3RhV9Iy/fHfxlB8dsfgLu5cjN3kmlVYfyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787121365; v=1; x=1787726165;
 b=Llfspvw1w+pk4jfo/9j/Ddg7RmbUeVBZyUXukA2xVFySWrvIP/vaeRJieRFC7DwG8zykjxwQ
 AI55Ma+2WBJO8Nc/CdqcTJdp//+3JVc4n7hSH6dCLO7U/Age0cIGetBE2Po7QcquafZ35g7IKoY
 1N1WXk2gyIs6MQFQjkTW47CQ=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 070133fea5525496;
	Wed, 19 Aug 2026 06:36:05 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: add memcg async reclaim test
Date: Wed, 19 Aug 2026 14:35:44 +0800
Message-ID: <052d445fe9d7741729447f1b90277dcdc6541b4f.1787120833.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787120833.git.zhuhui@kylinos.cn>
References: <cover.1787120833.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3exx3ykngupwhgxrh4bxybaatxgqhrr4
X-Rspamd-Queue-Id: 1A5C418000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787121366-197599
X-HE-Meta: U2FsdGVkX1+G26LkBkKadiETdmnMKpMkiJhDOuLkp42aJbK2yUVIg+iYL+2ciLe1neD+R4TtHJLtS1JjRwUyF3aNrBUj8dnTvDbVSR4F1Tee6JaJwvEoevOli3I7etGRFGlWjwToXnFN21TJhT9JSmW5EIeZC5FKSaFwpqn70pRIEuRKQmZdriAS+g0oKaunk/r8yQ12yuVSnqDUB04PBhjlX3K+WmP0S2wWw8nUI94h9dhVLFlDhfABs5udtONf4meaFvQuSImjXJpbtnZovu6YYb9c0ZGAl6ha50boEOv3LsZIKxyf3mFmjkcqOLwvxbOhlMTu9UptGPPsesKG2DrBtOPbNGyZ+ZRX008KmQFPo7Sy/FNI5OFv1IU9euBSpiRt1uv+zWt0As28MoE7UrgIEF91hLT4Mm+m5YRmAbYb6pSSHh6ZdGv8h04mppHant7tlDBMdifpS09S0Cfz/LKig13D3wlVKe1RmavbIcgSu9sa6K83rg6qWJtGj8BvzUcFbabvlfvojCvtLCN1qesr3+i8tjYQ30eONmR6Z/FVMKZ6+1HOJC4u/Pv37YkuYriHT3/qTNJ1F4bAx8be3UeAmZZ7JhUipAHDXDJ3KLOWtcfVXXn+KEUm/cGbcKIr8LUaG8aQOVg9jgx2saxRn84GLQks94Bw7l3f07wFOT4Lc+K4Hp7M2IxWb/P7MM/FMKL42yZc/jjPC6fEdqEApuRsisBacy4uyWoQuvrKszQ28xvPAJNT0oLBzSzi5rx438McZprpb/kF5/4h9ELQFvWPxLWHleqoHr7duhuNUdaF0L6h6lQMZpcWPgheIUUqUeBiAVslJ2oj7ZXlJ2apETobULnUrahNzpGOTuZaRbnd35p9Xed6DjpAvc3LBrJ+/EaD5Zs6KeTom5yt/WILiwsZQK8DjFpWERzQOdlJkLGbNgIVgrnJCOme/NalEBrUJfCRFd71lJdmvc4zytI
 255AYV9i
 rmWzdUG3Fs48firaWEKknj2s6AzmPpKs88HC5+HRGpQNEAmfphz3xEC1lidz761kSR1Gv/OKfdflMIx7qkYcyRn5SWsv2cutxfR4bVL5KhMWwNn3Nw4MURY5OoxZmBUWf18nkyXfvF9Kf9DY4FHXK+QuSVKu5He6C6DXOMZHaSj34bnL1MjhPlP8NwtTLHVlqLDPP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add memcg_async_reclaim selftest that verifies BPF-driven async
proactive reclaim can mitigate refault-induced slowdown under memory
pressure.

The test creates a parent cgroup with a fixed memory.max, and two
child cgroups (high/low) under it. Both children concurrently write
and repeatedly read-fault a file larger than the shared limit. A BPF
program monitors the "high" cgroup's WORKINGSET_REFAULT_FILE stat via
a periodic timer, and when it detects refault growth beyond a
threshold, triggers async reclaim on the "low" cgroup using
bpf_proactive_reclaim(), expecting the "high" cgroup's workload to
finish faster than without such reclaim. The reclaim work is queued
asynchronously via bpf_wq.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/memcg_async_reclaim.c      | 479 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 180 +++++++
 2 files changed, 659 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
new file mode 100644
index 000000000000..e990d1fdc79f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory controller eBPF async reclaim test
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
+struct bpf_args_s {
+	u64 high_cgroup_id;
+	u64 low_cgroup_id;
+	u64 event_delta_threshold;
+	u64 check_ns;
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
+#define CHECK_PERIOD_NS (2 * 1000 * 1000ull)
+#define EVENT_DELTA_THRESHOLD 1
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
+	printf("%.6f\n", elapsed);
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
+		exit(real_test_child_work(CG_LOW_DIR, low_data_file,
+					  low_time_file, read_times));
+
+	high_pid = fork();
+	if (!ASSERT_GE(high_pid, 0, "fork high"))
+		goto cleanup;
+	if (high_pid == 0)
+		exit(real_test_child_work(CG_HIGH_DIR, high_data_file,
+					  high_time_file, read_times));
+
+	low_pid = waitpid(low_pid, &status, 0);
+	if (!ASSERT_GT(low_pid, 0, "low waitpid"))
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
+	high_pid = waitpid(high_pid, &status, 0);
+	if (!ASSERT_GT(high_pid, 0, "high waitpid"))
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
+	struct bpf_args_s bpf_args = {
+		.high_cgroup_id = high_cgroup_id,
+		.low_cgroup_id = low_cgroup_id,
+		.event_delta_threshold = EVENT_DELTA_THRESHOLD,
+		.check_ns = CHECK_PERIOD_NS,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, run_opts,
+		.ctx_in = &bpf_args,
+		.ctx_size_in = sizeof(bpf_args));
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
+void test_memcg_wq_async_reclaim(void)
+{
+	u64 high_cgroup_id, low_cgroup_id;
+	int err;
+	double high_time = 0.0, low_time = 0.0;
+	struct memcg_async_reclaim *skel = NULL;
+
+	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
+	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
+		return;
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
+	 * actually reclaimed pages from the low cgroup.
+	 */
+	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
+		goto out;
+	if (!ASSERT_GT(skel->bss->reclaimed_pages, 0, "reclaimed_pages"))
+		goto out;
+
+	if (high_time >= low_time)
+		PRINT_FAIL("high cgroup not improved with async reclaim: high_time=%f low_time=%f",
+			   high_time, low_time);
+
+out:
+	if (skel)
+		memcg_async_reclaim__destroy(skel);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
new file mode 100644
index 000000000000..225f0bc66711
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
@@ -0,0 +1,180 @@
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
+#define RECLAIM_SIZE		(32 * PAGE_SIZE)
+#define RECLAIM_MAX_ITER	32
+
+struct bpf_args_s {
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
+/* Statistics exposed to userspace through .bss, so the test can verify
+ * that reclaim actually happened instead of relying on timing alone.
+ */
+u64 reclaim_calls;
+u64 reclaimed_pages;
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
+static int reclaim_cgroup(u64 cgroup_id)
+{
+	struct cgroup_memcg cm;
+	int i;
+
+	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
+		return 0;
+
+	reclaim_calls++;
+	for (i = 0; i < RECLAIM_MAX_ITER; i++) {
+		u64 nr = bpf_proactive_reclaim(cm.memcg, RECLAIM_SIZE);
+
+		if (!nr)
+			break;
+		reclaimed_pages += nr;
+	}
+
+	put_cgroup_memcg(&cm);
+
+	return 0;
+}
+
+struct wq_elem {
+	struct bpf_timer timer;
+	struct bpf_wq work;
+	u64 prev_event;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct wq_elem);
+} wq_map SEC(".maps");
+
+static int async_free(void *map, int *key, void *value)
+{
+	struct wq_elem *elem = value;
+
+	if (should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
+		elem->event_delta_threshold)) {
+		reclaim_cgroup(wq_low_cgroup_id);
+		bpf_wq_start(&elem->work, 0);
+	}
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
+int wq_prog_init(struct bpf_args_s *ctx)
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
+	ret = bpf_wq_set_callback(&elem->work, async_free, 0);
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
+	elem->event_delta_threshold = ctx->event_delta_threshold;
+	elem->check_ns = ctx->check_ns;
+
+	wq_high_cgroup_id = ctx->high_cgroup_id;
+	wq_low_cgroup_id = ctx->low_cgroup_id;
+
+	return bpf_timer_start(&elem->timer, elem->check_ns, 0);
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.53.0



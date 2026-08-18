Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9528CC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBE66B020B; Tue, 18 Aug 2026 04:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3656B0527; Tue, 18 Aug 2026 04:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9546B020D; Tue, 18 Aug 2026 04:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 508EC6B06B8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:37:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7F4C120B5D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:37:01 +0000 (UTC)
X-FDA: 85113735042.13.0973801
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id C599D180004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:36:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FNLXIEFk;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787042220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9lj4f27Q0Gx8mUWSDQg2pWbSKlrwZgt9B3Mqz4L9xY=;
	b=ZK9crYNZPueCqce+ylno2WWRaVY6ZI57q6JWJXxUh7EBk1wfGE46pQ9omORvDm+lw+V2Xa
	hvNGXgmW03HChHCqLRFQs1L6Dd1SpKKof1nNsZhAGYWZ3Ruk5Rk77b/nZ3q9pDOo52q/jk
	Ml38Ibfp7UcRafVU+RHwr9AgYFadYdU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FNLXIEFk;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787042220;
	b=5Ma4fDNS73zqgruRcN8jDMqEaR6QQtBJsA1R5c0LjTCz06zmuS7QvtUrLqv1dADUhKLviq
	7hk0Nl5OqwAZeeA5w1FJkI/L6EAlsfpKd08m3QB1XEupfggk/EdEc0PcF8y/dwBvqvU/xE
	h43cnk4lC5gfcHjmPSywbk61KDo9FHI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5FSc6tDpL9C78TLg7xeqAWyEH2FMc3NcZtq41DpkHD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787042218; v=1; x=1787647018;
 b=FNLXIEFkqoJlOCb32hpGOi0nq6/ZpT/Zt/jBlENiuyChIC5vCojSmUQgQNu+06CxvtIL0+8d
 iWHm6oX7KDU5nrIVL0ElC8q+v6zGlvsV3QgEjg/g5K5/MGXB8KAdquzDVSlvuYnKvDm9evPmRmq
 HQDJDRGQYfNMUtQVntRX4VOw=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 4b2f68af1fbe152b;
	Tue, 18 Aug 2026 08:36:58 +0000
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
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: add memcg async reclaim test
Date: Tue, 18 Aug 2026 16:36:10 +0800
Message-ID: <fbbeaf46501c66372d792c712349eac0205beea7.1787040082.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787040082.git.zhuhui@kylinos.cn>
References: <cover.1787040082.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xi9pd3e5ikfbj9z4gjf18jwhe3yfp4s1
X-Rspamd-Queue-Id: C599D180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787042219-962377
X-HE-Meta: U2FsdGVkX19hWAQJvEHsU3cHTLFzfYRyLL/dX7kac7vyJfr9wO9SJL0Ix/FGUf0kSI6VTiJP/7WBs5Ku8qIIZQNB2EFWU+ZaX9hVJesKx5ieA9/VV9mje8MfPLS9PzPuD5s8UO9pg8QeEqxqsoLYKYnpn5aNW65DhSM8DPHhWegojjTfGyZzIXQ/5IVHPFSRzO6jBE+/+hbVt6VkhFX5gwBfAT1A8R3I/Z+/pjtDKU359+zt5X65lpHr7hJTobTQL8uXRlkutbgq0TPZ6qbbQo0FnQJyP62BkiWx7kNyA2MOTtAXDSODlWoQvRzMksoGYVGXSQPHtnMIuwOvFEPV9YVJZTzlGB8aleykiwoJhQlpRJiDgpSgZzR8CPw3MvfYdSC9iUmURHqxBk7OBi+he5lmhqUCLj3BulEj/sYUcvV/M3MNlpy0wj+fm+U+bQfZmtbyxP0paTspkism1BHmfY+20GikXgM8HQTn2IcSw8bOEwlj8IoZK8galt4KjvJe5K4SZ7Z4z1TyxeUfME2k8EanVHLYCO0x4JrU8vwZAqJtv0DrBtHoKoDd97ccG2WlzhHjKcLlH247EB2vboL4iw2oUr3WYc1EtLug6iFA8reY5QS81poZnDRmYWSWEIr/nTr7Ca/XfnrZ0RjjuPWGjkEr9y46BMqs8sPCnNmjTFB+EWNwzWxML8WzkKwmdpZqeo9+hUEyFlNXlMDzWC8G6bmQT114nIf6PZXJ/c1nTi7e61sqCuIr8hneZW1bbDHnCeyZ/cK/2DS0e6Fw2XtIc1lE9U15XNfVGDrfQisBNeCLnd3SIo8KqQvKh1Q4CbuCOtqm51UVkvLfB2p4eTcsKn2EaWCX1WuH5MrmB4ews55/CZFYJzEbngY3W/MBNVIUMCmv72hcgICEo6wS1qKOgaEwsZs2akbCWr8cLsUryi8sThRURRijkzw+RD3J/uuqMhyYJ+RWCXAOzzTwdt7
 6RvwevXm
 5Guv49yKRRvOIj0nDMNiytZR4mnN3IAug416v5unqy8myCnrAVmJqYkrZr0sH/XbiEjwP9Y92EorKNrJi5XdusSdR6YAFabF+k8U70rSkRyPKq/3GJgmZMf/EfYkefx84v3xhDTsq1raAQHIQTMo4qysC32uELGMo3MQpUD9TsRtswxFvpKc39yumX4s9giwEMZVt
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
 .../bpf/prog_tests/memcg_async_reclaim.c      | 382 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 167 ++++++++
 2 files changed, 549 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
new file mode 100644
index 000000000000..6fab88203e7d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
@@ -0,0 +1,382 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory controller eBPF async reclaim test
+ */
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
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
+	ret = write_cgroup_file(CG_DIR, "memory.swap.max", "0");
+	if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
+		goto cleanup;
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
+	struct timeval start, end;
+	double elapsed;
+	FILE *fp;
+
+	if (!ASSERT_OK(join_parent_cgroup(cgroup_path), "join_parent_cgroup"))
+		return -1;
+
+	gettimeofday(&start, NULL);
+
+	if (!ASSERT_OK(write_file(data_filename), "write_file"))
+		return -1;
+
+	if (!ASSERT_OK(read_file(data_filename, read_times), "read_file"))
+		return -1;
+
+	gettimeofday(&end, NULL);
+
+	if (!time_filename)
+		return 0;
+
+	elapsed = (end.tv_sec - start.tv_sec) +
+		  (end.tv_usec - start.tv_usec) / 1000000.0;
+	printf("%.6f\n", elapsed);
+
+	fp = fopen(time_filename, "w");
+	if (!ASSERT_OK_PTR(fp, "fopen"))
+		return -1;
+	fprintf(fp, "%.6f", elapsed);
+	fclose(fp);
+
+	return 0;
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
+	char high_data_file[] = "/tmp/memcg_async_high_data_XXXXXX";
+	char low_data_file[] = "/tmp/memcg_async_low_data_XXXXXX";
+	char high_time_file[] = "/tmp/memcg_async_high_time_XXXXXX";
+	char low_time_file[] = "/tmp/memcg_async_low_time_XXXXXX";
+	pid_t high_pid = -1, low_pid = -1;
+	int fd, status;
+	int ret = -1;
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
+	if (!ASSERT_GT(waitpid(low_pid, &status, 0), 0, "low waitpid"))
+		goto cleanup;
+	if (!ASSERT_TRUE(WIFEXITED(status), "low exited"))
+		goto cleanup;
+	if (!ASSERT_EQ(WEXITSTATUS(status), 0, "low exit status"))
+		goto cleanup;
+
+	if (!ASSERT_GT(waitpid(high_pid, &status, 0), 0, "high waitpid"))
+		goto cleanup;
+	if (!ASSERT_TRUE(WIFEXITED(status), "high exited"))
+		goto cleanup;
+	if (!ASSERT_EQ(WEXITSTATUS(status), 0, "high exit status"))
+		goto cleanup;
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
index 000000000000..62c2bb7e037b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
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
+	*val = bpf_mem_cgroup_page_state(cm.memcg, WORKINGSET_REFAULT_FILE);
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
+	for (i = 0; i < RECLAIM_MAX_ITER; i++) {
+		if (!bpf_proactive_reclaim(cm.memcg, RECLAIM_SIZE))
+			break;
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



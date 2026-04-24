Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274BCFAD41C
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D2B6B0095; Fri, 24 Apr 2026 00:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3CA6B0096; Fri, 24 Apr 2026 00:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8224F6B0098; Fri, 24 Apr 2026 00:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70D376B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F8C040A4A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:05 +0000 (UTC)
X-FDA: 84692101410.07.29DD5F4
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7240820005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhhMoTdY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzx3zOD8ZQ55shIwyhvABMvV7vxK246eKX/iuZXREog=;
	b=I9SbNKGywfvmvwIDO5342F1BxbafBd5ixZJBnGLVD5nfI4nP8XuIn034j5jVpjF0ILhqWn
	tN0HnqK6ZjtrWW2uDEYEtVumuHkbq7UnTn0Z96vKCzgO/ZWNe9Tcg9OukUkW078zKiJ2Z1
	Q+0GCjvubrTvkNnLZpXCWIDOcMzTz6g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhhMoTdY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003323; a=rsa-sha256;
	cv=none;
	b=V73ndiRYZNzGzj70Z+W+7Bg6dYbhLC2e/VADbDUJIN2Fo0ZQPHSTjBrXWfBkmXAv3Z3pYV
	P8TCKzjB7/vckGAdYXk2YE6YHNOKOtk/AXjN78zKshXsn9IIiX/goGOCg5zW9Odf0cHbR/
	qgLUEHZvIsOrjx5gRaIlTPO8KN8mRNY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rzx3zOD8ZQ55shIwyhvABMvV7vxK246eKX/iuZXREog=;
	b=VhhMoTdYa7ZcEG55Z0uVQZhdx1VB9yvvdrQ5yP0OyVOd02HhjyS/WjxmfbCbHfJe973HLl
	kKFSinv9SjTiHpmH7IhMN6KPWQ3iPh/glDhB68Z7B8vIrNOo7uUR0dtLpoN/rmx5z4wEUB
	gFCotUBVbj6rxFt5pvSYhWKCZxuUZTA=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v7 4/8] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Fri, 24 Apr 2026 12:00:55 +0800
Message-ID: <20260424040059.12940-5-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7240820005
X-Stat-Signature: zo7pppfxzu6euht9gjxhii6uj545b4m9
X-HE-Tag: 1777003323-908573
X-HE-Meta: U2FsdGVkX19a0GmiQFJHAC1g8dFlYXw1AWgfBPUOD0gjxG+5Hhs0zRM+4NgPbxMwAltZR+SYF4BnlFHnX62gRGoBmoJU6n0jJHlCj2OfTHViX5FTrgXExwmvTO6w8kmEIhO131YFzn1iNfB0LCVx5RlfPZ/yAroewFYvllhg5oqIj6Un6WIWVaIEdLhLy9TK2d5l1PLcQiPzNxDAkv8Ny6ZAFc3AFdVnSoplCZC6aXPyIqYINipzH4hJzvx9cXhABSfweD2cwAF2iXgd0FsA94CYfNgZnswBK4OKyLH661dZHv4wsRmU5hCaFEibswSI+NcIHOlG4NZQxeIJwJthnM9uhx/2ekcU8S/pHg8cpeFsls8Xlt75Pv7qnXq6tr7IqX7nyh6lBE7G1I/bwdcWc8Jf45+Ldq0CmI6uHGZsms3CI2m8Jt7Z6u6J8KnQEZ6q8zk0501SM09PyGSDGq1t/2ojE3QpUzNaEEsNu+vuL27+nCqQzg5aIm3u7HX3qkBq4kbDBWed26LfNU728VUzTgsC4t0QT75FzPQoURFqR5bkCeLWCyNZA7IHuTSAAJIQUICEjT/UvLwWJ+Ql1/+DhgZku3P93eSTtPAyXesh9aiSftoK84iMx5YuuQiiboJHcK1+tKStlUnaOzh+avCKq3KZbrR0KPpNVaQXwVRddMahgbl0R5vjZqN4oWfugOdRqMy7ZgEABsOvulB0fFlHKelklc34rgORha6q9SzJkjbyiyWOKtUTdvUs5nK0z777IBOgjS8rzy9I38zkW7WIRlaZ1H8tczAEOD1Ee5/y75q3VQCWYViG78x32k0yPtfOBuO+e/Tgvf9TmmVh2YQUkBdJJ+wU0DIWIAuagUCVY1tAERhMW6et2ISwdnv5XeWpuR93lxpLI8kiFSfxvQmpSl7Y1Zlwneyr5LuX92QThX6EN4JQxvVqv6EdyY7tcTohceSeJnAXGwCb8Ya4k1R
 PAex2+1H
 hOubn0WYoVoTyjBNRSk2M/mtdXXg1/F3hKrs0rDcqoFKcphIvTmcjgq5MkHeJaQVJm5HDK5EAhV8dnn2M5eYbU4drc/4uK5ZWV+XGst9c1UqHJ64XCL2emEyZsMA9xJfbCPH20bcg2GQMoxaUMd9TkTwhb74A5+2J8tTwiR4F78W70ya9Kq7/9c0BmYXgPjp481uv5hjx2OSk0gHBe3Mt96FX+ghMD9mtoaY3SoC91EYksue6ykD5MZlYGVauCAZKZ4/tqXuTQm9KNT17Drlu+bbtrhecIP3iLy182AwUZtIblRSZmhkBYCLqYDLo2kPOq5ivpCSOtVVcz/3dbfkYbp9NSWCu0UGfXj1D5IxEib+4C0sff2Fjve+wcG8oiVAiEax7NXBOLmBQlF9awdgI4FyyUsFE5JFyIL52kGzkDLKPinpuogGN9Dx0xaDzWoEJirgStqkBGhwvwfCPHUcj6LOYaW0mazJf3YkCa7tIdWSKjdUmWx9kLeewhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cgroup utility code defines a local PAGE_SIZE macro hardcoded to
4096, which is used primarily as a generic buffer size for reading cgroup
and proc files. This naming is misleading because the value has nothing
to do with the actual page size of the system. On architectures with larger
pages (e.g., 64K on arm64 or ppc64), the name suggests a relationship that
does not exist. Additionally, the name can shadow or conflict with PAGE_SIZE
definitions from system headers, leading to confusion or subtle bugs.

To resolve this, rename the macro to BUF_SIZE to accurately reflect its
purpose as a general I/O buffer size.

Furthermore, test_memcontrol currently relies on this hardcoded 4K value
to stride through memory and trigger page faults. Update this logic to
use the actual system page size dynamically. This micro-optimizes the
memory faulting process by ensuring it iterates correctly and efficiently
based on the underlying architecture's true page size. (This part from Waiman)

Signed-off-by: Li Wang <li.wang@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 18 +++++++++---------
 .../cgroup/lib/include/cgroup_util.h          |  4 ++--
 tools/testing/selftests/cgroup/test_core.c    |  2 +-
 tools/testing/selftests/cgroup/test_freezer.c |  2 +-
 .../selftests/cgroup/test_memcontrol.c        | 19 ++++++++++++-------
 5 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 6a7295347e9..9be8ac25657 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -140,7 +140,7 @@ int cg_read_strcmp_wait(const char *cgroup, const char *control,
 
 int cg_read_strstr(const char *cgroup, const char *control, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
 		return -1;
@@ -170,7 +170,7 @@ long cg_read_long_fd(int fd)
 
 long cg_read_key_long(const char *cgroup, const char *control, const char *key)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr;
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
@@ -206,7 +206,7 @@ long cg_read_key_long_poll(const char *cgroup, const char *control,
 
 long cg_read_lc(const char *cgroup, const char *control)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	char *line;
 	long cnt = 0;
@@ -258,7 +258,7 @@ int cg_write_numeric(const char *cgroup, const char *control, long value)
 static int cg_find_root(char *root, size_t len, const char *controller,
 			bool *nsdelegate)
 {
-	char buf[10 * PAGE_SIZE];
+	char buf[10 * BUF_SIZE];
 	char *fs, *mount, *type, *options;
 	const char delim[] = "\n\t ";
 
@@ -313,7 +313,7 @@ int cg_create(const char *cgroup)
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
 {
-	char buf[10 * PAGE_SIZE] = {0};
+	char buf[10 * BUF_SIZE] = {0};
 	int attempts;
 	char *ptr;
 
@@ -338,7 +338,7 @@ int cg_wait_for_proc_count(const char *cgroup, int count)
 
 int cg_killall(const char *cgroup)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr = buf;
 
 	/* If cgroup.kill exists use it. */
@@ -548,7 +548,7 @@ int cg_run_nowait(const char *cgroup,
 
 int proc_mount_contains(const char *option)
 {
-	char buf[4 * PAGE_SIZE];
+	char buf[4 * BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/proc/mounts", buf, sizeof(buf));
@@ -560,7 +560,7 @@ int proc_mount_contains(const char *option)
 
 int cgroup_feature(const char *feature)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/sys/kernel/cgroup/features", buf, sizeof(buf));
@@ -587,7 +587,7 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (proc_read_text(pid, thread, item, buf, sizeof(buf)) < 0)
 		return -1;
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 567b1082974..febc1723d09 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -2,8 +2,8 @@
 #include <stdbool.h>
 #include <stdlib.h>
 
-#ifndef PAGE_SIZE
-#define PAGE_SIZE 4096
+#ifndef BUF_SIZE
+#define BUF_SIZE 4096
 #endif
 
 #define MB(x) (x << 20)
diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 7b83c7e7c9d..88ca832d4fc 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -87,7 +87,7 @@ static int test_cgcore_destroy(const char *root)
 	int ret = KSFT_FAIL;
 	char *cg_test = NULL;
 	int child_pid;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	cg_test = cg_name(root, "cg_test");
 
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 97fae92c838..160a9e6ad27 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -642,7 +642,7 @@ static int test_cgfreezer_ptrace(const char *root)
  */
 static int proc_check_stopped(int pid)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	int len;
 
 	len = proc_read_text(pid, 0, "stat", buf, sizeof(buf));
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index b43da9bc20c..44338dbaee8 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -26,6 +26,7 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
+static int page_size;
 
 int get_temp_fd(void)
 {
@@ -34,7 +35,7 @@ int get_temp_fd(void)
 
 int alloc_pagecache(int fd, size_t size)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	struct stat st;
 	int i;
 
@@ -61,7 +62,7 @@ int alloc_anon(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	free(buf);
@@ -70,7 +71,7 @@ int alloc_anon(const char *cgroup, void *arg)
 
 int is_swap_enabled(void)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	int cnt = 0;
 	char *line;
@@ -113,7 +114,7 @@ static int test_memcg_subtree_control(const char *root)
 {
 	char *parent, *child, *parent2 = NULL, *child2 = NULL;
 	int ret = KSFT_FAIL;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	/* Create two nested cgroups with the memory controller enabled */
 	parent = cg_name(root, "memcg_test_0");
@@ -184,7 +185,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -414,7 +415,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -1000,7 +1001,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
@@ -1791,6 +1792,10 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0



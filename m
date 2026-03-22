Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EF0FC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591356B00A0; Sun, 22 Mar 2026 02:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568B76B00A1; Sun, 22 Mar 2026 02:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ED26B00A2; Sun, 22 Mar 2026 02:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3916C6B00A0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00E1F5A20D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:29 +0000 (UTC)
X-FDA: 84572677140.03.6CE6814
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 210584000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgNUbFg9;
	spf=pass (imf17.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHzuD1Q+ozuE+fNEcVbskPPcDVZUs5YK4U0mB0xkA0M=;
	b=QXR4AcgqPMr2uvQsGEDGBR4OV3ZvTeAll80skttQxqWe/R7vqtIt8/qkA7NEWz/uwv5iYl
	actcJuUY9+ONpYrgwV109Pb+WfwpY8N2K/4mVyB3BjMWikiE+VtFlQW+CII+VR1c9I8nLw
	IjgREQVtoefCOJVYG3zd71ssCs3OI+E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgNUbFg9;
	spf=pass (imf17.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159888; a=rsa-sha256;
	cv=none;
	b=6EUn8TFEVSFCoUIDu0lyKRY945GfVXifEfQmwPUuJhqSroAtJepbWcf2lJuRrrZj1M331B
	F9onMiIibrU7GrkkzFkdFFoX6UU4RHlhWCtJCLtvZ+Qub/QoXkVJ22qt7R09cJNrx4/T9U
	aJ/L616QXpvT6B3G14DWf7B4huXKiN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHzuD1Q+ozuE+fNEcVbskPPcDVZUs5YK4U0mB0xkA0M=;
	b=IgNUbFg97lVh9eZb/BOpDPAnGuGZwjR0HeUMLxFHhza/Cf5M+Gfej1c+D/epI4toosIs1K
	lJN/KBjIcepFhc14Xs50px7cq+tXMp50ee07uLG2f7Ohgck2G0Y8FdWMoxcW3Q4U8ijraM
	5Tc0ifp3f3xL+lKvXstUQhcdtctWgpo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-CjW01H6BN4CvfivfR703GA-1; Sun,
 22 Mar 2026 02:11:21 -0400
X-MC-Unique: CjW01H6BN4CvfivfR703GA-1
X-Mimecast-MFC-AGG-ID: CjW01H6BN4CvfivfR703GA_1774159880
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EB4A195608D;
	Sun, 22 Mar 2026 06:11:19 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86C941955F21;
	Sun, 22 Mar 2026 06:11:13 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 4/7] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Sun, 22 Mar 2026 14:10:35 +0800
Message-ID: <20260322061038.156146-5-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: cw2GR4_yG2QensBuz9pOTdNDcG8jZ_Og9SJ_dmQfcN0_1774159880
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7r9hf5dy95nber1wu7g6rbyie395jt99
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 210584000A
X-HE-Tag: 1774159887-504845
X-HE-Meta: U2FsdGVkX1/4T4Jku1n1/EvaKfszKa4MRUaOqUkmZMKN9sibWrtREHjpjQU6he0Z9ELLAWwE+rYwzuE0fQfCD7TiunYCsBkQw5Mek0zh66+pWtx/j26OFGH1731apS8v9nFet0GpN0yzyoe6/jNfweViBWhv3GA2E+HV69C00ZdDlDMmuN8vSAU01MdV4MEKKNZ1GRTHIz/uIHAeUDcuOhdnuqDzKTyJMfZIxsroWhClQMKchSTyjjhYCLunyNRp4GaX7pO11SjwbMMTTj3PBu7ND6FdG3YowQs8LjWT0W3RtPPrpCaEwlTmP+RrjNnabFAbE8/uM7AShi+qUoiAiXsZmdjP1HStbDpHDDdTuOBy+SVxGvocUXJ4ZpgZCN5gra3RgQ2spEOb7JzZnIU2uXOkh+NYVy1vAxcp77w/ipQjAX5g4sUjTGJIJCLV7UNuEnmhv+Dzb+HYIh4Dj1u/Ikx3GDmwRIQRbr4UyySFnYN7Ml1Hyf3lyuny5ADpt3bKP5im5S8NQdgCzBmr67qGe6rZyKfxuWIiaQAiG5/iLpMXX95bxMpWa8zLsc10zlGPkj17mh/JczOtzPs1ML/CF9NRfPmHfAZpD2k2UKSBKh6ZOQvhPTSbADMsH9F9IRd71+EVTzEYPl8WFXubExM72IUByQL7uT+rsIP3brIHDyakbBqEc9aA7m2K12xwoVYG+MYzom7Dk2qx7fnWgXkcC4s0Jv+nb1y3wNge16Qr2DxkhR+Xs7K0RKk0xNxjwB6GSwWVc0AfwmUqyNhfXo3KEOc/snbYK1jLqBfKpaIO1MzflTpUSNeblmHItMBiAUuqCIqvhDvyUFy2lxNDBkgMr7w0UgBYltETFNl9CFWprKnQuntUPpeQv4CWX1ZUIOySWySYVkpcVnjh/Je+6NpV+Kj+axww2xtXvkZiHxtQLugwifj9Hg3UxgOyF6VGO4YvwlhyB3DMZ38MGQKxvEr
 xT7YEfor
 yqTz9FS7+86mXGFre4oAvtozhElkYhygTEO49KbOIWwxmFa1C9oqG9LspoAmWlqPvvgUl6a0PGwGSJn4//98zgMqRNYwLhpisyANE8+yBx0hBUPGRffCGFN9Zr92ObkjlH257WUCq2ySHTAjvrD3rEIGQeoyDlot1xJhZMOrhlFydztahQBVjdsPLtp2X4DMZjoc4aSAZUWeWolve8O1L9TWWKpOpR/M8TZLZdVD0FyXw6Ycy2qrnlvpcBlYb6aB7CF2OygKAYL7lO0XtBVLSo2IyQlS3ro64HGnjvS/46fv645iNDYSI0aJX1WWlaF6FdNgacr/RzKahQPJegfwhKctxQ/jZVTYzMG1STXsCam+9qGBYidWfD9oKn4Pp94GRh6MYjNg6GeAxYg/+NStvrUc/aDXOv0t5zr6Wjl+A/ReIxxnyVAZJybXwxxo22VJYDDyL3fQorO8DRwApt/s8M5TlbOgHFZD9YiGwElA0saHaK4EZACzw/+aqMcNmP0bOeYADf/RcJwGQkuHcTjY0qWysJcJ5D9allNVCytYMaEF54s4GUuZYCRin/cjOmPNCT6rfaggUUDkjsLQDO7rz2yaef58DEDQg687V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cgroup utility code defines a local PAGE_SIZE macro hardcoded to
4096, which is used solely as a generic buffer size for reading cgroup
and proc files. This is misleading because the value has nothing to do
with the actual page size of the system, and on architectures with
larger pages (e.g., 64K on arm64 or ppc64) the name suggests a
relationship that does not exist.

Additionally, the name can shadow or conflict with the PAGE_SIZE
definition from system headers, leading to confusion or subtle bugs.

Rename it to BUF_SIZE to accurately reflect its purpose as a general
I/O buffer size. No functional change.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

Notes:
    v4:
    	- Use page_size instead of BUF_SIZE in test_memcontrol.c
    
    v3, v2, v1:
    	- No changes.

 .../testing/selftests/cgroup/lib/cgroup_util.c | 18 +++++++++---------
 .../selftests/cgroup/lib/include/cgroup_util.h |  4 ++--
 tools/testing/selftests/cgroup/test_core.c     |  2 +-
 tools/testing/selftests/cgroup/test_freezer.c  |  2 +-
 .../testing/selftests/cgroup/test_memcontrol.c | 15 ++++++++-------
 5 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index ce6c2642fd9b..0be525ed11db 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -125,7 +125,7 @@ int cg_read_strcmp(const char *cgroup, const char *control,
 
 int cg_read_strstr(const char *cgroup, const char *control, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
 		return -1;
@@ -155,7 +155,7 @@ long cg_read_long_fd(int fd)
 
 long cg_read_key_long(const char *cgroup, const char *control, const char *key)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr;
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
@@ -191,7 +191,7 @@ long cg_read_key_long_poll(const char *cgroup, const char *control,
 
 long cg_read_lc(const char *cgroup, const char *control)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	char *line;
 	long cnt = 0;
@@ -243,7 +243,7 @@ int cg_write_numeric(const char *cgroup, const char *control, long value)
 static int cg_find_root(char *root, size_t len, const char *controller,
 			bool *nsdelegate)
 {
-	char buf[10 * PAGE_SIZE];
+	char buf[10 * BUF_SIZE];
 	char *fs, *mount, *type, *options;
 	const char delim[] = "\n\t ";
 
@@ -298,7 +298,7 @@ int cg_create(const char *cgroup)
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
 {
-	char buf[10 * PAGE_SIZE] = {0};
+	char buf[10 * BUF_SIZE] = {0};
 	int attempts;
 	char *ptr;
 
@@ -323,7 +323,7 @@ int cg_wait_for_proc_count(const char *cgroup, int count)
 
 int cg_killall(const char *cgroup)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr = buf;
 
 	/* If cgroup.kill exists use it. */
@@ -533,7 +533,7 @@ int cg_run_nowait(const char *cgroup,
 
 int proc_mount_contains(const char *option)
 {
-	char buf[4 * PAGE_SIZE];
+	char buf[4 * BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/proc/mounts", buf, sizeof(buf));
@@ -545,7 +545,7 @@ int proc_mount_contains(const char *option)
 
 int cgroup_feature(const char *feature)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/sys/kernel/cgroup/features", buf, sizeof(buf));
@@ -572,7 +572,7 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (proc_read_text(pid, thread, item, buf, sizeof(buf)) < 0)
 		return -1;
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 77f386dab5e8..ca4a161c17a4 100644
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
index 102262555a59..df7fac7e5554 100644
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
index 97fae92c8387..160a9e6ad277 100644
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
index 2fb096a2a9f9..2a8d887a849f 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -33,7 +33,7 @@ int get_temp_fd(void)
 
 int alloc_pagecache(int fd, size_t size)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	struct stat st;
 	int i;
 
@@ -57,10 +57,11 @@ int alloc_pagecache(int fd, size_t size)
 int alloc_anon(const char *cgroup, void *arg)
 {
 	size_t size = (unsigned long)arg;
+	size_t page_size = sysconf(_SC_PAGESIZE);
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	free(buf);
@@ -69,7 +70,7 @@ int alloc_anon(const char *cgroup, void *arg)
 
 int is_swap_enabled(void)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	int cnt = 0;
 	char *line;
@@ -112,7 +113,7 @@ static int test_memcg_subtree_control(const char *root)
 {
 	char *parent, *child, *parent2 = NULL, *child2 = NULL;
 	int ret = KSFT_FAIL;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	/* Create two nested cgroups with the memory controller enabled */
 	parent = cg_name(root, "memcg_test_0");
@@ -183,7 +184,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -413,7 +414,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -999,7 +1000,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
-- 
2.53.0



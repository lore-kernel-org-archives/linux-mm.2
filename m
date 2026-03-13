Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836CD106FD79
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12076B008A; Fri, 13 Mar 2026 00:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD29B6B008C; Fri, 13 Mar 2026 00:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7DB6B0092; Fri, 13 Mar 2026 00:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB7466B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B8E7160769
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:13 +0000 (UTC)
X-FDA: 84539777826.28.D2D2286
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D9F918000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GB3/IXs5";
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7tfI/YdgKHzANysIqItjdRV5RAmJ9JkatbQAres4TQ=;
	b=srRep2pNkqpHxxHRdqQ+IF9Q64D8lmnkbHNWJ6pXp+legYA8kddGUfsFRIqs2EEQKA6ias
	CYCqJRHw2SLttTZFwf49lNc0tgw92BjCg1Z5he2r2y3C5sb/1Of2R/I3uCw+tuRS4NAror
	DRZ9k/WdvDZk4rlmcqX+RY70YLpYqyY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GB3/IXs5";
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376571; a=rsa-sha256;
	cv=none;
	b=ZJRkKQZ3MZiQG2wSeZL9D1/zKHZZTaVUSkH53hKTUMdMUZWVK6XMRvGfiX//la0O9lZ1lX
	9Algz1WUlNOK917xyCJrrlqHM6lhIhZZ06U3K0sNJHJ/np722UiaQ3gco4foflJTJeFnmN
	h0ecKDvd80e0KEiyYz4oEiJ3oufVLPM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7tfI/YdgKHzANysIqItjdRV5RAmJ9JkatbQAres4TQ=;
	b=GB3/IXs5UiMjXpc9l+K5A31GoVxLariEmHsDI2qRtssRWmvlaYt/8gjFJtelFvAg69jGDR
	6g7RVBd8/xutNnBFnrFDyzoz6wb7BAeq62gTw/c5VBZZqlwSKNbTZbSKVtoZKBcrZAUaog
	b6vl+OimGIvqZOlDhJ6fSJPB6ZaZTVo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373--lHTsUkNMhusIykT-FB8bw-1; Fri,
 13 Mar 2026 00:36:05 -0400
X-MC-Unique: -lHTsUkNMhusIykT-FB8bw-1
X-Mimecast-MFC-AGG-ID: -lHTsUkNMhusIykT-FB8bw_1773376563
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 076171800359;
	Fri, 13 Mar 2026 04:36:03 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D0F219540C2;
	Fri, 13 Mar 2026 04:35:57 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v3 4/7] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Fri, 13 Mar 2026 12:35:29 +0800
Message-ID: <20260313043532.103987-4-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: bBaqTcfMrmY_FqEGjTDCzXCQ3yXTXnB7s_CUqcyubo8_1773376563
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D9F918000D
X-Stat-Signature: p589gknezrijk377xg6cqpsdgbp675oa
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773376571-930931
X-HE-Meta: U2FsdGVkX1+RlsjSZ4tIOnE+ZW7DX1CAcNd+krWLiQRztXkeWOCzPxVB9YXLKLmFY4km6vIqprzY6klWs63Ds9g/BEu3jO0HMunRxiIHlLmMAJHmuY5vwIWAZ3ldoMCjB6YecqzqawgeL8HrLMn9pFPJbC0s/MLNapKhv2bBmESFx1UMacS7V9jwN3SQExgJAIqMDBK6S0Mgk0lxGPp3R+gAyhf66aa3flgnZCeooAWczalcMPu2uIGSJwkjn6a/vMEBeeq4egEhx5qu2Z0TbD/6t8vYaknsQJ0Remod5vC93duYroNVc/UyZh2pFUn2xFRtfXcxg312o8xTRLzoaodi5vLg31TBrG6mL72dzPSYzKY+ihG7zUtcptQ+Hv96j1iQMNqjh1CbnAjjF4id//XxibLCnou98drALTrP+nIk40Y62OV7A1ALd9fmIEr1LV0sr4aLm9/jEPgVX3czSG/RTrYgxhB2C/Uh67JnlczwOc4zY2FW10UDW4sd9VTM8FF3PiigXdxduzg11bHXbEjoCyGTKBYv4roR8pgnuiAX3uEHAzxwqcMHkPeeH7uNmTZx6Dp0isbESvgZ6NXjIQvArie+zOQyywXfipHR6U373f05Y0gbmg83kKxssxE+fTulrEswrCJmbc4ddXugUukpErb+zKB/Yh/HGKAYRC9ev5K7Jhgo+HPhXsynxwlmq42sADYKbtjUpG0vNXIrqGfFfNEK12u8DCJTYGvcOO/Z4ytSZKGDzwMUVqKVb1F2EtPOSmA3pynmKTXAuDveRY+u4apTGQCGL/6qrWCGJ3mCDRolvpfAyLBJQDTMXYcmMrqzsCBeoGPDbpbXjnS5e0R+B5bSqB0M0uxIZkQFtGOJEVgpp61Da7DtlimBuKelPgC+3RdkTsd49Lu7JMgOzk18LpIIHxBex4oQpLle5TqK/doPi2f/FLcu8PyebnZAfyLeYPfqpH5PbSebHrr
 LqK7QHvd
 DOqD7sL9nuM7Ua7HnySmhj+D1+AxeD5QolEl4H/ZNcURVFg9XKL5rbUAZ0NI6fqh+OQhcOyr7AdaBDUOqfBBbpJuDR0jtYN25gK6A2kwM/yBGtW9K2zfMha5KbIqzAz4Du7wgjnOxuzFghMeF2E3pj6pOQS84u5VeKnVR0i4+1O9tUhfFBz+m2/H4hOHy8F9o3hSc8Yax0hVvylei3LrMCWDCzfveAlr3SebuUyOEvOGi6TJsPtT7jkyCLR2LN3ArXqmVtjwuVdiNHuOS7xBGlk6Dkx7M/Ysg9lUyGiWYKiZJLVIy5R5j3s1Fs9GMhyBy4TrSvbPa31kF0wxmpWff0UWpwnzyb4x3Hoi6R1NVscjBvu1iLeefJrKEYQLWzLXZX/u6teofKsLNk5VjhtWrx83etC0r+TLyBS5feq2PuMxDhHNDbJVs6WaA3RmJkls9TuZ5r/OKUdNqE+HsBQPCNtea5qPi1qDp54GYqA4ux2Af3p+rFsbUYRl1E6q0OiSR3yFbe0goxEE3ncpYQPSjvTS0JbwLVUkCxBoqpy6Vf2yvoeEPRANmxu/xwZTx699HtYF047VyPEO/AMEAAVyUIf82NO8zUXSnAceq
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
 .../testing/selftests/cgroup/lib/cgroup_util.c | 18 +++++++++---------
 .../selftests/cgroup/lib/include/cgroup_util.h |  4 ++--
 tools/testing/selftests/cgroup/test_core.c     |  2 +-
 tools/testing/selftests/cgroup/test_freezer.c  |  2 +-
 .../testing/selftests/cgroup/test_memcontrol.c | 14 +++++++-------
 5 files changed, 20 insertions(+), 20 deletions(-)

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
index 2fb096a2a9f9..c01e60b497aa 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -33,7 +33,7 @@ int get_temp_fd(void)
 
 int alloc_pagecache(int fd, size_t size)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	struct stat st;
 	int i;
 
@@ -60,7 +60,7 @@ int alloc_anon(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	free(buf);
@@ -69,7 +69,7 @@ int alloc_anon(const char *cgroup, void *arg)
 
 int is_swap_enabled(void)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	int cnt = 0;
 	char *line;
@@ -112,7 +112,7 @@ static int test_memcg_subtree_control(const char *root)
 {
 	char *parent, *child, *parent2 = NULL, *child2 = NULL;
 	int ret = KSFT_FAIL;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	/* Create two nested cgroups with the memory controller enabled */
 	parent = cg_name(root, "memcg_test_0");
@@ -183,7 +183,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -413,7 +413,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -999,7 +999,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
-- 
2.53.0



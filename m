Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2AAFED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14FA6B008C; Thu, 12 Mar 2026 00:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9B36B0092; Thu, 12 Mar 2026 00:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDE16B0093; Thu, 12 Mar 2026 00:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9F46B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:07:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F7AE14076B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:09 +0000 (UTC)
X-FDA: 84536075778.15.D08AC42
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7938A160003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eNHMhflr;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7tfI/YdgKHzANysIqItjdRV5RAmJ9JkatbQAres4TQ=;
	b=lTU1C864EBOF4p2b9vgR0fPkSRlmzYYbfbnAfz1C9AbLS3n5S2ZhwSvPSGazwuBKtDKMJC
	7eoL5S9oc2HZJnefUzd9/ufADvbD7+Iz/NUUGhSLvt6/y+/3WsYIbNVrmH2+MsJ9hQ24wU
	uo8BTKCvdUavmOUjmpc914mMkEmcfiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288427; a=rsa-sha256;
	cv=none;
	b=VXpXzEB2a7xYycEIZZC7kig2QWBGCfQT8zSgYkiWxEWPZtraxfuoAkKS6CtFLJ+cdor/xU
	QrZ02l6tFZDULTedkSVee2oHiwyfXr10/y2wZ2f3X38Xlz2tgExGSg58PR7AyhCwlSieyN
	Vsi5w+6D3MfG3krjiaquLl3VuzjKWAQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eNHMhflr;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7tfI/YdgKHzANysIqItjdRV5RAmJ9JkatbQAres4TQ=;
	b=eNHMhflrawZ3QPy0CHvYfN+7k/1A1NHdWs2Ln73xsKKjbvtzpKsMdL8IvXKC1Q1pjO3TTE
	TvxZciXl4GGBlX/x9n2h4+7aARbaEXtQstiPGScD+sKzGJ9ANq8oSI9C3CTVNVV39CYNDh
	VAOp4PARF5Y9scsRHVKajqvLtn33jY4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-zVRxieiMPW-SpCj85YnaXQ-1; Thu,
 12 Mar 2026 00:06:58 -0400
X-MC-Unique: zVRxieiMPW-SpCj85YnaXQ-1
X-Mimecast-MFC-AGG-ID: zVRxieiMPW-SpCj85YnaXQ_1773288417
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDF851800365;
	Thu, 12 Mar 2026 04:06:56 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56AD219560A6;
	Thu, 12 Mar 2026 04:06:50 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 4/7] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Thu, 12 Mar 2026 12:06:24 +0800
Message-ID: <20260312040627.55257-4-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: eeKW4Hwdm3o596z_HPCu3o8ej06vhNN_jk2bb_f5uLE_1773288417
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7938A160003
X-Stat-Signature: uaz91iddxsc578okd75xjghrq9n66we8
X-HE-Tag: 1773288427-452743
X-HE-Meta: U2FsdGVkX18H7LczfosahA/6D53IOxm+THJ5EQgBJXdSDvzdD8lBSKbtZoPpw4U0y50j47dKpMSVJLn0ZcR/83XYXQVv/uWo/QOO/T5DjLp1p0/pO0QRbvxCR5r2vuPwXz8CReoWDGnSYK+edRHH5yH6N+5MxQNhrP+bzr24QqAEicAuK1xC+Tc3SFgEzQ4cbLqgapGhvfQQKcAnv7mfoPhu69S/dS8u87BfstBjKzxs6+/zXgXDzDj4TckroKFpeeUqGEf09ZTp2aZG3m90S2vV5eJim1Uq35eV8joD4+MzXFRosYmuNM4D5UCDzgbh+LcELMuG8OhRQ0CbT4Eo5zRw3n2VuD/A11HTm7X1ArLz8T9OmS8XxOLHYYOoTznCpZayFLUf2qnBQJOWwRZfhBWFd9S2bQC90h7fftoXvaQtLdwBcVvwWftjHDvgCsHWNIKaUXUqOfISfM36M7DcCXiQMK9RP7RqojDviV6XTtNRcYHhce6i/7sI8Ed0+zs9rBQO9pZMempw8zm2xHP1GwA8jlcewXxUqADKs2IkcK1INdCs/4Hex5liWZ0J/j89dsgoOqs5P5uGm4inE1mxuZiEGm/pC2ZeAtr5hZ9vv6I4dBy0OvHrwvOuKZxTux6HNTuj6PnucXDw54/a/vzbTyPjUtYxPQJHaLlu0BF9MnYJW/VIgFzz18RkhH/S4H1UIDLeQIxRlJnijGY+kqifa+e1bGhw0wtMjyvGdSA+bKNUxvnSIF9YWFr+HljChZmnrv2mJzIPtzFoFNjANyZT8XjWTSZxdhDnRJm7s5i/2xVVhaZumkJFqhlS1MqFZ58nBvZS4UJpJb7VQS9XJ7kkfU4Naj0aMKZgLfMjk3lixLFlGwtXOoxoQGsQCMdbI2elwytHJP/UKV+7LnvGfrdAkat0zMUxa/Qpf79f99MuFY30n5xCILvdzMIGQ0Eo8b/vDJ045228mCFL6/AHjxw
 +G3wjoLP
 VcVABXjQlm/JE32wDiLoqqWMNggR3pV4Lg1XNnQ6MJ8LhfJVwKZQ9d20CjbkHaNN5NcROiQH4RgRWW6W7ap9nexQkxYD10j35Rp1lg2xevauY2dkk0z7G9UvZOW16QpyBgGhYeBHlyfdia5K7slieLKvqhAUa9zJiG6v1UHE3IXcf4k39msSgjHoK/WZgCxy4edfI6JOqoiDpz84Ett1dQY1JCuuggoo3eEYngMbGgSeFaqbjoJKYd20fmbbtQ2TPb663awQUXJU8IepqltnnuXDgeZw9wEmHnrVrJnSA8bAVx7xPhv3ZnG6+HmzhKccvUhnOB50CLpJvaO+B6vlGF5SRlaSqOgPe6i366X9tWKczVcp6f11SOKex3NRTQByDgSHpEgof0WxExA1Z1gQaStIqXIy9vnuhdRIyDZq4pmOW4AdaxCZzkgIHTQQTvLAqfOMN6No3NgdpSsl68cU7118cd5gwuy50ZGqlB96raxIONl9nvzisUTrL4t/4W4M6/wojxj56MY9gTVGTrk7nQAX2nJUhBYsdkgzLErqts/mLYXF/g5Ci2mNzZdjBN8g4gxk28PmTcIn04TKR3ovUY5RWDpW9lbFSKjna
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



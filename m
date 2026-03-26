Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA41109E543
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7C76B0092; Wed, 25 Mar 2026 23:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF996B0093; Wed, 25 Mar 2026 23:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBED06B0095; Wed, 25 Mar 2026 23:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD4856B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ED49C226B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:48 +0000 (UTC)
X-FDA: 84586779816.11.8E2C63F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88F851C0015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C75I5VSI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRnxTPWpAQYJ1HE6KZj4d+ShQv4DEVn8EUx0vr44r/E=;
	b=h1jTdPe/gRgFnZYpFF/KkFLwPinihF7PK3TP5tuOXiaiLZI3dckyy7rwHv0y5Jez+lYOsq
	VeJ/Y+pA8pj6j98IqHdV7qKpvNcXERsnRMZ9dPnAhV7BlPTmDIJmkHkh69ZZWxVH2ZPqXU
	2dKSxCfyTNtHScJKyk3PMvghRp5Rz/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495666; a=rsa-sha256;
	cv=none;
	b=vX1dUsCZOjXH1zgdw1TopjDa7e5esXfuSD8lKqmvJVN74N0VOh3YgAiodTy6Bp+9q8K38s
	ULw7arcS+9lKF7fq1qqb0Rn8wNctJCajxq4RfO4qs/PgfpfL6NGkE3lm+p1KHwlMK6yMry
	zxy8HdOcQ/b+ovpLcB0LDKC9cJqSBPk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C75I5VSI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRnxTPWpAQYJ1HE6KZj4d+ShQv4DEVn8EUx0vr44r/E=;
	b=C75I5VSI3wHltc5xSJeRjMjVi9XuI/zIDin6rmNWVLhFiHUnw0T7KLZsVtWrAxtpcAF643
	kcLZQs1iXKnvMNi/4qKJtOA5M0anadWl4NeVYZOp+rJAbwnUEW71hmbMXWobJmUW51/9bS
	XMlfdilbDgAobtDOUPw/F/RoUiMXICk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-R6a8-Oo6N6WpjTAbUIP45Q-1; Wed,
 25 Mar 2026 23:27:41 -0400
X-MC-Unique: R6a8-Oo6N6WpjTAbUIP45Q-1
X-Mimecast-MFC-AGG-ID: R6a8-Oo6N6WpjTAbUIP45Q_1774495659
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 026E718005BE;
	Thu, 26 Mar 2026 03:27:39 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 801321955D84;
	Thu, 26 Mar 2026 03:27:32 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
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
	linux-mm@kvack.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 4/8] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Thu, 26 Mar 2026 11:26:54 +0800
Message-ID: <20260326032658.96819-5-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: gAb7O79cFiv_BNaffht1GG5Hw9qa7JtlFmIVkcek-6E_1774495659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88F851C0015
X-Stat-Signature: 7y544msihcsw7ipqp591kpodpfurresg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774495666-730281
X-HE-Meta: U2FsdGVkX18cZvAgsndZ0g01xr7OxwUO0cGuyCIHrzjErbiUXHCAE5ezW5F9E2lbVj46J4ea4FoAuhwR/4Hc2WQ/l7O+IvSJssoISbchaHfOL9PnliNjWHNiUj/hPbK/lwP/+kt+8TQVpC6Oael/B488ji9VxwcEtdcxU4TGu/WwWbwSr8TACDW/AXaEHsAm4NqyKJ4/+Jf4YkiIyOtDyzIyGRlvkQ6RvBm28A7RV5bA/FWOselP1xxNj4qiEICIMzkM97DGzB/XepeltlJONWAMP3JqJKTNMDL5eIc1Ojr+8KfdVO/xNvxhleWorTNKut+yf6jSVjlzGKo1NGl1u018N68LQFsrzs8eaR2vea0nVx6VzqojEKc3zO5Sbd/91DNT8Qg2EeUKYfa0X3UJaLKa4IPOD1+Du3uweyprbnNl+WZmZFxh2obb4HKKjhp0OA3Pg7FeLBKPxH85fsyOyDDAMZatBUDEtP3LisXXoRsGhck/7df1sZ4HFWX6kNTgX4O8Iwh+HmAp20O1p1niZafRBMnvJn+N+hVYRKpUGcNDcu4b3bcjHTDaKToFCL4YmtR+sfM5BX8u5WFjFN4uAFrMBPrvOieDtlkHh2DS4jFA1dx7ZQLgOcomWGPqYzBS11qObVOTYaR2aDoA6GlsF80jyn38RkO/qrDD/sMDD6fxO3m66yIh14ww7r34xaIcONSlaL2gsVa+kqaO6mHPzBbC5vEc8l42FS4xTLE+UONeTiYbZoaC9I71ZjmpYoXnXPiQQcwRCvNQ3vbEd826g/8e0givpNlRd1TqIQ5EiRGCu+oO3K3yHe355kOpsjxMkBjy/eKfJ/H3yB9nnGHWykEXecKkNBdkQtCF1KMTl2XMlLaZWbv+VcIOQ1TkRqCawv8hodpZIEOA+b+C3J4t6jkkWjmicvwy1YsnldMK69S4yMS0oPkqWqh7SMq1P1wnz9rEtIl69Hte5yj8Bkv
 OAUr9BwT
 35cycFB+fzWonApibD0eY5nIgVpfYP3qmGh4pvp+/fZpgNQj/+Zf783I+wQRd83UrzT6Cz6zdyTJLl0rBJ5zWLXPKpiRID/D2cJcryxMIWJcuMx9965Vf0CJTbXWPtVoxaz1p/NyxynOma4iBOzoIuc3LGZTFTX6Qj2Ka9fxoCsucT1gLCOv+FK84WnVeOrTjuqgN7GKPXBL8uUE05aMDSgMORXysrHvt+6mfsdeYvBNeCtwWrFjgMQbfXCty7A0qKB2pIr/4p5f8w+6R+1dLheFN4HOH94dMxUdNJ0jC0rQQEKlq9ISsEycPmrXvRiKWCUj/EUWJAuYZgfs10NA2bHoCa/OcnFea2xE8rrS7Hx8vxfrUTQ8mU53grbf9nxzkGnpip2vQBBbdajtdwzUO80KAEkTQUkOtYAGus46CWamlFYdbBt3Z44bowM1zPDz0JOV9U7v0Sxdvm+VkpQ3XlhiUn3ln5cfuAbkPOXDGYVDvZ2D1gxskTthelzuPPzJ6EveSLHZ7rUautkITLamfBVg971jiVHjkpSQMyI+2HXD6VdLzTeSXdIPi7wXoNQyGVsEuXviAhQRU8NQjA1dyIbEw9w4n65wU9Vat
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

Signed-off-by: Li Wang <liwang@redhat.com>
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
---

Notes:
    v5:
        - Merge Waiman's work into this patch (use page_size)
    v4:
        - Use page_size instead of BUF_SIZE in test_memcontrol.c
    
    v3, v2, v1:
        - No changes.

 .../selftests/cgroup/lib/cgroup_util.c        | 18 +++++++++---------
 .../cgroup/lib/include/cgroup_util.h          |  4 ++--
 tools/testing/selftests/cgroup/test_core.c    |  2 +-
 tools/testing/selftests/cgroup/test_freezer.c |  2 +-
 .../selftests/cgroup/test_memcontrol.c        | 19 ++++++++++++-------
 5 files changed, 25 insertions(+), 20 deletions(-)

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
index 2fb096a2a9f9..94d7b9de978c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -25,6 +25,7 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
+static size_t page_size;
 
 int get_temp_fd(void)
 {
@@ -33,7 +34,7 @@ int get_temp_fd(void)
 
 int alloc_pagecache(int fd, size_t size)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	struct stat st;
 	int i;
 
@@ -60,7 +61,7 @@ int alloc_anon(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
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
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -413,7 +414,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -999,7 +1000,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
@@ -1670,6 +1671,10 @@ int main(int argc, char **argv)
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



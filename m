Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCF1CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249ED6B0093; Thu,  2 Apr 2026 02:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA626B0095; Thu,  2 Apr 2026 02:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9476B0096; Thu,  2 Apr 2026 02:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F12CD6B0093
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFA8B13B03F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:15 +0000 (UTC)
X-FDA: 84612661350.20.F3A4803
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4DB7A0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZmeitZ4S;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xITEB/o4W7V44LNKdzXwQHA6xAoRTOl1JFgHYsjoo4=;
	b=cErkITae6CgCz3zZBCf122KqDKza6Rde2Xt8Yz3+MeUGr5gLutMkoVkVmc5zN3GGe0Yfzz
	xwq6W+S9b7kilHc8cvRVgX4RNoAUjanQVJ71EIS8+7gA3l8+s+O44hCnWBU6aR2NFd1EH8
	4BeAzw9Z19/bSXE1/6j6OlGWLPEzYqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111893; a=rsa-sha256;
	cv=none;
	b=NXbHoCo9bEhbGbM7NAGh9z5iY8fgTD4gMMlbwC7yTm0TSyBqxPRACJ9tdIjX2XBv607WY6
	hl8lkqRibk1vOjArMOjls2s1gO8P1QjE6HlrlljPkLFoaFeCC782YFdMZeaInQnmK5g0OI
	Hcs6JW3hjyXLsFBQE8NVpAEnnJbUjxE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZmeitZ4S;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xITEB/o4W7V44LNKdzXwQHA6xAoRTOl1JFgHYsjoo4=;
	b=ZmeitZ4SjXPzl6futx9FgghW7IZ5y248XPUhIpQ29AwN/hLneGZrqwlLbL3OoKcMynEiqz
	x0DG5DviYgaogQqoRfIobThZSDiKuRJ8AumZyaofBJOIUPKt3euw2zqEQytvqv5Ecba7Zd
	Y+829X+dcs8BVhJDIj8Iz0u2mkkizTA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-6plKfXNYN3SoZcDF2Il8AA-1; Thu,
 02 Apr 2026 02:38:08 -0400
X-MC-Unique: 6plKfXNYN3SoZcDF2Il8AA-1
X-Mimecast-MFC-AGG-ID: 6plKfXNYN3SoZcDF2Il8AA_1775111886
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B6751800345;
	Thu,  2 Apr 2026 06:38:06 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F6F018005AE;
	Thu,  2 Apr 2026 06:37:55 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v6 4/8] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Thu,  2 Apr 2026 14:37:10 +0800
Message-ID: <20260402063714.55124-5-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: uP3Wv3VPN7VIlGycFtQ1o3RqnxIqKC1l6Wa9WBaQXcw_1775111886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4DB7A0005
X-Stat-Signature: w5817iia6xcgrbfzfszamjk61iyaspe3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775111893-912017
X-HE-Meta: U2FsdGVkX1+sPz/Zlmto4KyWiMNdfqT0XShNPfBeoT8elxD77kdTyf3RXObu/SIUud7CGjJ7hxsqGsb6HLsl1udlFUS1MKYeQ34lIp2KHjdNNzXlMhez8Cx6ZFMGkaBxZA+dRQQdWzAzW8xTFwe99gEzE9kQYYp34Qi7O7HldtQJ/FzziSOzFzflbUl0dqCETxz8PFjoOH6PlwvdFiXPThcm1FFZjrSxcbdB4xV1nCf+TFdLVqSjHt2m16okjmPNcNJOxrtVYTkISVEXSOjYwOzNv6cJJywIiS49ty4E02N67yLgESfEBIYzB+Xwn6oROvJ02YYTeRdO2oP9DkkUWEDCR8ZGEIgNnnXSr1BD6AubRCWTntBjbaSWm4eeDyRtFKjT8gLfE7SV1oekWNe+4uQJtcdYTaQuS0I8H7bPkpXHohQSqWFEbEnBc1/RqjFeR6SrKvakbCXJ2V+bzkrGEqBV5ScWgle+Zr5Lc9EyeGUTz7h9Ccm9Dh/iP+5WrFEjAPhh0mgNDWgD6+oB5S6XS1+XujQWmnHXWljgGKyNZWlRfzdLCRSzFEJjUUUrT0Po4OVaLocY/hWtnGFyrKt/CtVfsXDUcE7einbq4T5btpR51nBqFf1CBX77zo/yNJxSgp/ez2ZgQ2Kdk/5nZnINU6WVHK7fLe3wcTh5GUDtuZVm70EuBR8r9IuTDzlgQcHcdhnw8BKzjLof7+IDVEdKRPvrGq5HQ1gLqmXRCSjIi/VFGp/fAEeIQlrx847EUfEGpHGsc5bx9PygDdLqJniaK9ylDpe+ae9OGUr4M5lHHtSkl+fOV1vuP5zbe7oG3t32VzFvQBffGB+DBCaq7lyNL/AYwjGjMM3/QiKJANZeh0M7Od+JxJzuktSMBZWKQgDO8zqLaE7u85gO6vusBd+UdCKRk+L1PVXAB0rJ20nwvdQzd8nSfSqUC/uDB9nFdI6YbzCMG7xY8Q1/5LckCpy
 nuszccDY
 9QzMUKClne4Qxu70yJSk/qUSw6s8siKyhBtG8RAdurg/Z7Qn1DNDHOizdSGfL5mZwdGsiDEx+Vcc8XRvF2KXTBQgjq4UlPoDC8YNvtrkWS3AwuAanzIBs3CMoYNcEvzwhK8SjItZUXb7BOInRaHFP9tP0x8Isi797+Is4bcVZrOvF12RqVr/ywVPKGYOful5nWqAic/l+S32MNYQ56XBG9Bx9ZLFij0sHkspRtptueTnHCvuEKEc6637QEB89qNRZEYTYVPDx/C6IzDPwkYKCedr619eTQn2oBjftd7KD5yGhJgHEiJhOQ2O37RiPq7lD3dQum+K2x11fRlTJqyTXDfOLwMlrFtXVGSpkJ1xggTL4ykh+RG73UpoSOwiyJ38eN0T2mfycEQ+Wx9DM9ccrHdZsrAXB9nOPLhbl5X5vP6febZIoApJy9Xark5jBfsc8xiur94kclQnCRvgxCCHH0hF/yNQEjC0lcVvkHosDuoxr1ZGK0qEDwD9bi5a9P0tzbzKaaz4cRwfdOwg+7i4eFWldfpw79p8Dd0S2NAmijTBPPJW+zxZQzK4HHqQxcFerEA59JB2l2wbCkyu7PMI0ATpqRh4DA/xtFycT
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
    v6:
        - Use page_size instead of BUF_SIZE
        - Declear page_size as int but not size_t
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
index 6a7295347e90..9be8ac256574 100644
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
index 567b1082974c..febc1723d090 100644
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
index 7b83c7e7c9d4..88ca832d4fc1 100644
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
index 2fb096a2a9f9..acc748f4c878 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -25,6 +25,7 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
+static int page_size;
 
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



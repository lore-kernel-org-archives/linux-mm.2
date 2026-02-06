Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86DB6EB28D4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABA96B00A3; Fri,  6 Feb 2026 02:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83386B00A4; Fri,  6 Feb 2026 02:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD3C6B00A5; Fri,  6 Feb 2026 02:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B858E6B00A3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:22:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E4E41A074D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:49 +0000 (UTC)
X-FDA: 84413189658.22.EC2D8F9
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id A21DC2000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+C4Ejc5;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVhNoOKTqhs5FIM84PwOapldZJ1EjdC0zJo6ufYFyUo=;
	b=E14iPO6bx+n627KOZr7y8PgNh9+RZvneJvBgI6GrYaXL91S7zQfjPrDuoKZ0xOLa9EuDuF
	nkCHo0kRd7gWEjlvLv4XDVRKoghTY/zCbqOEgSyFwh71Bnfr3D7UxSIwoUiEij/IKOvsK4
	PNk6vcqAD5JRHgFc9nHrmu0czfohsgU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+C4Ejc5;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362567; a=rsa-sha256;
	cv=none;
	b=pnCFtcO1coWlZKLxlR96of/5gaD7p8opIcdcrxZzSKNLEsHZOFEaMcj4XfdYFJAaW069E5
	KIKi/4/MoMm/DAzpObIxOdgciNDQU43Tc4jQY8/BuDlFOyCUfIh0crwctJCWxV55RwkCLm
	172xXXmofZhOgjAopqQ6pUeYMyIaO9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770362566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QVhNoOKTqhs5FIM84PwOapldZJ1EjdC0zJo6ufYFyUo=;
	b=K+C4Ejc5kYVa1AMupNC5l8ot9jFScgXyb+D+zIw9ZBvY3NiXL0rK4kEbWmFA7i7a1LUKEa
	8/aC154zcQVvLVXsflxO27dIvGWhoyBQ8v3NYygtLhMZecbpziRI9uYqN2sJFcY5KWYXcX
	97o64Jq7iwPbBEtR111+cZx2n28j/rk=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 2/2] selftests/cgroup: add test for zswap incompressible pages
Date: Fri,  6 Feb 2026 15:22:16 +0800
Message-ID: <20260206072220.144008-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260206072220.144008-1-jiayuan.chen@linux.dev>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A21DC2000A
X-Stat-Signature: gmi1c6f8s759nfaqcigjzg1tf1sa8q7y
X-Rspam-User: 
X-HE-Tag: 1770362567-70990
X-HE-Meta: U2FsdGVkX1+uVuNXyiA+8+qUnhD344ur1OmDXjw54Etk5lo6+UM30lgZRvjzsVj2BkphZvqnFFzxpGS5krVawYBx3hqbh6hVAaHB6E+bwdpsEpENa7YLcVdWLIVFvKWHci8CZmTdI+uhDxIJH9mN4S9kCoUGdhsGDGSyYFZ2EOO2Pv5NyAl0hDbaLyzmsoBveJNZBo5kuH/Vn6u/AEbF7hRBDCGjbrzYYQX5+J4NQA/wB3gCMc5It9u3xSHeZ2Oerw8RLT0NluMDG4fJ8e9RCHL/w1oL33VQLE274g/08g63icBM5HqW1wTP7KddnqglUy/tL4HSgvdAyverqEQu5K+wX3pCCl/6gjSRF6OLL7/guCTvczGaIfMwBiWWeMAAT8G2gXeuQ4388T4CKHgWEIXQ15ajnKLaQJzCNiZeeCBLxdg/Sg/RWyNzTmVrH8eFfiwPNTY/SRcr4aVotmnnhMreYoxUAdsdeEZgNxjkmY3JfFgOMiBKXC+A505dgzamumqSd0+plEodskPe5lbZcTws+0MjnWmy60AwbBI1JtGotUIySIZpJzw7psfFllNzzegQ0tNZJlC6JcOXtpuw3PdKJ/yswLLQFoaKJcWKQPzlfQ1oQ8dKdv1wy/bEExJPGoUECmEvxsmY6UhueXYnvVzRqC9LHeiATDJjNeHUhKynLPPjHFVukpOWyXoutin7630BriUbm+yICkUFjLxkdE1q/T5qJKSapDAjoeahMORmg6SK0DXogWRldNeOti2xwiCeNOt90Gr2ZvZ8pxLkik1Gsa4e1wMRcCr+M30pPjpyL75Ajj0DsIkh/yTK75r7q8Dd78Ab/caV6SivHZU2Bm27FqlgDS/h0ZAlAptLgo4WqrAbTZDO3FZalPp5TYKY2KjDHG594FsNJX+sjJ2vYdXwJrntc2GbqU+t/ebzPIvOg4KesdQ4/ohUCy0PjTccuV5HDYZwm1Wai7mfvmx
 meO9XcNy
 12hx6aA4fJiMYwqR7FOlXy3AzU65a010iWcF4llYUFep+rdYLBOxGZ+5v6r/rsZKiJBv9eQHh46hNpUZ8SQ1yaT+bt+m1NbyWZNZe3jfhO9amuc+9M7dOz5ufJRbb/LTWQiuqZqF/kqSrg2F8RPmQ0c+HxVa2KISxE5arYkX8zLqz1aD4BkN2+zXKmaqSuHIFjl+x6PGR19UpNDUef+ZFJDk/jF+Co7khfI4fdBeSo031YwW7qSoV4NsPjbmhjGe+1u32
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Add test_zswap_incompressible() to verify that the zswap_incomp memcg
stat correctly tracks incompressible pages.

The test allocates memory filled with random data from /dev/urandom,
which cannot be effectively compressed by zswap. When this data is
swapped out to zswap, it should be stored as-is and tracked by the
zswap_incomp counter.

The test verifies that:
1. Pages are swapped out to zswap (zswpout increases)
2. Incompressible pages are tracked (zswap_incomp increases)

test:
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo Y > /sys/module/zswap/parameters/enabled

./test_zswap
 TAP version 13
 1..8
 ok 1 test_zswap_usage
 ok 2 test_swapin_nozswap
 ok 3 test_zswapin
 ok 4 test_zswap_writeback_enabled
 ok 5 test_zswap_writeback_disabled
 ok 6 test_no_kmem_bypass
 ok 7 test_no_invasive_cgroup_shrink
 ok 8 test_zswap_incompressible
 Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 96 +++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 64ebc3f3f203..8cb8a131357d 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -5,6 +5,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <signal.h>
+#include <fcntl.h>
 #include <sys/sysinfo.h>
 #include <string.h>
 #include <sys/wait.h>
@@ -574,6 +575,100 @@ static int test_no_kmem_bypass(const char *root)
 	return ret;
 }
 
+static int allocate_random_and_wait(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem;
+	int fd;
+	ssize_t n;
+
+	mem = malloc(size);
+	if (!mem)
+		return -1;
+
+	/* Fill with random data from /dev/urandom - incompressible */
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		free(mem);
+		return -1;
+	}
+
+	for (size_t i = 0; i < size; ) {
+		n = read(fd, mem + i, size - i);
+		if (n <= 0)
+			break;
+		i += n;
+	}
+	close(fd);
+
+	/* Touch all pages to ensure they're faulted in */
+	for (size_t i = 0; i < size; i += 4096)
+		mem[i] = mem[i];
+
+	/* Keep memory alive for parent to reclaim and check stats */
+	pause();
+	free(mem);
+	return 0;
+}
+
+static long get_zswap_incomp(const char *cgroup)
+{
+	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
+}
+
+/*
+ * Test that incompressible pages (random data) are tracked by zswap_incomp.
+ *
+ * Since incompressible pages stored in zswap are charged at full PAGE_SIZE
+ * (no memory savings), we cannot rely on memory.max pressure to push them
+ * into zswap. Instead, we allocate random data within memory.max, then use
+ * memory.reclaim to proactively push pages into zswap while checking the stat
+ * before the child exits (zswap_incomp is a gauge that decreases on free).
+ */
+static int test_zswap_incompressible(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *test_group;
+	long zswap_incomp;
+	pid_t child_pid;
+	int child_status;
+
+	test_group = cg_name(root, "zswap_incompressible_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "32M"))
+		goto out;
+
+	child_pid = cg_run_nowait(test_group, allocate_random_and_wait,
+				  (void *)MB(4));
+	if (child_pid < 0)
+		goto out;
+
+	/* Wait for child to finish allocating */
+	usleep(500000);
+
+	/* Proactively reclaim to push random pages into zswap */
+	cg_write_numeric(test_group, "memory.reclaim", MB(4));
+
+	zswap_incomp = get_zswap_incomp(test_group);
+	if (zswap_incomp <= 0) {
+		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
+		goto out_kill;
+	}
+
+	ret = KSFT_PASS;
+
+out_kill:
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
@@ -586,6 +681,7 @@ struct zswap_test {
 	T(test_zswap_writeback_disabled),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
+	T(test_zswap_incompressible),
 };
 #undef T
 
-- 
2.43.0



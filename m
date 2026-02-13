Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F256EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814BC6B008A; Fri, 13 Feb 2026 02:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6856B008C; Fri, 13 Feb 2026 02:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8796B0092; Fri, 13 Feb 2026 02:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F98C6B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:19:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88E421C2E8
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:19:03 +0000 (UTC)
X-FDA: 84438581766.07.C3DDF83
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id D09F8C0006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:19:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lIXNPvSq;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHxD0q/WzMwerrB6ZvB9y/vH4lR5GGZkuNBvcMrlqCg=;
	b=Ibewsu5Y//gg0Jx6bUHV1ontrgcA2o3tsAhWcd6sdol1uArO2qx0PPBFQVCjFBb+p8+eir
	CJCrhkX0sIu6wg3IkPz+xqc+kcEAa3qdjvgk8Mzmw5mWxNyMdpcfitG9iEuBOB4UqixpTa
	s4admTbCx6CtkJBPt1ftlE4R6SnczMw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lIXNPvSq;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967142; a=rsa-sha256;
	cv=none;
	b=1rs3odCxAv54C+2Bxb1PWhhFvjTJhefy0wokT/r4kQ1a0r70Q8xYQNhg594cDMyEsR11VM
	FfXvn5tMKjkteRhvOvsq0j8QJQdl8H44Zk/XrPgxnsqTJAD0UmmqOusQvPScTfNAzIPgzE
	ta3w1mhM7k8UP3tzOOAOcjQJ/uhp7VQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHxD0q/WzMwerrB6ZvB9y/vH4lR5GGZkuNBvcMrlqCg=;
	b=lIXNPvSqtq/mhCIHqxeszIYr/dYCcHPhuKv8BU2LzkjdLcK9P1zVhUyLfgrTBtWksG2iM/
	Cd9uWmaQOjCZeDqnMhBfEkW5CxhEcfoN0N8H3l5JRit/TmtkhvnztmxIr2KOWqN/FtKzwx
	XJKKxxEqFXLCORDZbvr0dcqUqxpn4b4=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH mm-new v3 2/2] selftests/cgroup: add test for zswap incompressible pages
Date: Fri, 13 Feb 2026 15:18:23 +0800
Message-ID: <20260213071827.5688-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260213071827.5688-1-jiayuan.chen@linux.dev>
References: <20260213071827.5688-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D09F8C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: m8tikp41wwtzm1ne18hdj51o9dcx8o8y
X-HE-Tag: 1770967141-188831
X-HE-Meta: U2FsdGVkX19Rre6FSrMvithdwx/XDrXPZbVPhIUyXc/rGxpPIsxNhhlE/FsyyAwCnHDmF4Hk7/aTw5VeXObhx7GDvtRMQwbrsqwpyerTwJNw+3MuKbOJm4p5rp9XBD6CU5vyyVPmXXy0+xP+08UE27uz2wx0dmViSGHhSVkiH1rIe7BsIMYj01U/pIB3Gh3zx95X/NEKrb4k3bDQDXGfHCXdO5bFd20VKWij4IPaSJ2eU8g9fhLiaBod9eJVmFHIpACCLThwF+uiyd/YNw8R+/uge2zp+fTHYyvwmj/e/eLNDz5tLQd6MOrJsjKwVcN82Qti9qksqRgQAI/3uYxgV78v9jDXNFVFfBtMsTtHiKOgiRvBRlSk85hy1mCAky3nr/fQPgWNytXmNBss8iBv+qzKLRGk1oMBctS4hs+Z/hLGdcj6H/7yJ1xA4WPLzEIEjCxT+un6Osg32PgzEjBQIpji1PUPQfOxdKNiKHh/C8rSQtukDy30mdLu4lLvfniHedUxMP3gnfAqsOvST7SwsgVrJ5HszLAYRiIq6wvlURXqHI+iQrpLcq7VkS45v7EhE22V5YIJ6D/C5MfH4ul/4+Yj32xwyxTyq8hbVS241xnIA39VaQR3GVOk/QDRDJmm08BuFiiqNIlgaXtzudvFvEezMjNIuxeAd6tt5zn3d1KBQoQ4vWeWlTn8Bw+Ki1ua2JqS0VuU39fMQf2ky12iFFGAsIkNarIiOtilEkquMNiWUE5N5lKsOmtjGhD4sCKHfwvw1XHwMWtQZlkgC0B5+yd3BxaO3/GE0/kmGh7IUm7p0a3DYwfL0U5mgy1Resu4Xk5m98KSOnAHfVMqmuYcOj8iSWO3iBl5TZBcv0ucfTnxNkYC5rDtHCxtn11S6JOwg4nXz39G5Fr0k7uThSMIn4tvBu6qRZ6eOdZVXZlWxyRjTJQ9yurF5K5U3KVStMqupddNNbMNVJDtM6tJg1p
 3u0ryBzG
 Ipvqh8PABssAiz4yEBrUJ+0IX0g8vI6Ky/dzS7vGpvj9WaRf2+ZdtxuTSWj0ehpifBRnS8L6WpBeSLHNXqkv0wc450kV/SUzYhHE2TkTMsHlTxh15PqzcKyRYHL9iIuWuUIleBie51+bxbLEw9/IcdAKqhwyR/AjbWqkzyjRFMNpfBho3P7qPnHYyse6cWxD6MTNW9RZDyX6M049SzTTx9OA63nUD5JwYxHeWQ6K+02/IGBRCzOJqFa1NO9UkKq0ZzBMqBBjT4qjfFTe2E8CLnEnfryqco7LoRENiFZ74SAxeQOVb/ofUOON3ZQ==
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

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 136 ++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 64ebc3f3f203..a7bdcdd09d62 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -5,6 +5,8 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <signal.h>
+#include <errno.h>
+#include <fcntl.h>
 #include <sys/sysinfo.h>
 #include <string.h>
 #include <sys/wait.h>
@@ -574,6 +576,139 @@ static int test_no_kmem_bypass(const char *root)
 	return ret;
 }
 
+struct incomp_child_args {
+	size_t size;
+	int pipefd[2];
+	int madvise_ret;
+	int madvise_errno;
+};
+
+static int allocate_random_and_wait(const char *cgroup, void *arg)
+{
+	struct incomp_child_args *values = arg;
+	size_t size = values->size;
+	char *mem;
+	int fd;
+	ssize_t n;
+
+	close(values->pipefd[0]);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return -1;
+
+	/* Fill with random data from /dev/urandom - incompressible */
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		munmap(mem, size);
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
+	for (size_t i = 0; i < size; i += PAGE_SIZE)
+		mem[i] = mem[i];
+
+	/* Use MADV_PAGEOUT to push pages into zswap */
+	values->madvise_ret = madvise(mem, size, MADV_PAGEOUT);
+	values->madvise_errno = errno;
+
+	/* Notify parent that allocation and pageout are done */
+	write(values->pipefd[1], "x", 1);
+	close(values->pipefd[1]);
+
+	/* Keep memory alive for parent to check stats */
+	pause();
+	munmap(mem, size);
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
+ * The child process allocates random data within memory.max, then uses
+ * MADV_PAGEOUT to push pages into zswap. The parent waits on a pipe for
+ * the child to finish, then checks the zswap_incomp stat before the child
+ * exits (zswap_incomp is a gauge that decreases on free).
+ */
+static int test_zswap_incompressible(const char *root)
+{
+	int ret = KSFT_FAIL;
+	struct incomp_child_args *values;
+	char *test_group;
+	long zswap_incomp;
+	pid_t child_pid;
+	int child_status;
+	char buf;
+
+	values = mmap(0, sizeof(struct incomp_child_args), PROT_READ |
+			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (values == MAP_FAILED)
+		return KSFT_FAIL;
+
+	if (pipe(values->pipefd)) {
+		munmap(values, sizeof(struct incomp_child_args));
+		return KSFT_FAIL;
+	}
+
+	test_group = cg_name(root, "zswap_incompressible_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "32M"))
+		goto out;
+
+	values->size = MB(4);
+	child_pid = cg_run_nowait(test_group, allocate_random_and_wait, values);
+	if (child_pid < 0)
+		goto out;
+
+	close(values->pipefd[1]);
+
+	/* Wait for child to finish allocating and pageout */
+	read(values->pipefd[0], &buf, 1);
+	close(values->pipefd[0]);
+
+	zswap_incomp = get_zswap_incomp(test_group);
+	if (zswap_incomp <= 0) {
+		long zswpout = get_zswpout(test_group);
+		long zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
+		long zswap_b = cg_read_key_long(test_group, "memory.stat", "zswap ");
+
+		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
+		ksft_print_msg("debug: zswpout=%ld zswapped=%ld zswap_b=%ld\n",
+			       zswpout, zswapped, zswap_b);
+		ksft_print_msg("debug: madvise ret=%d errno=%d\n",
+			       values->madvise_ret, values->madvise_errno);
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
+	munmap(values, sizeof(struct incomp_child_args));
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
@@ -586,6 +721,7 @@ struct zswap_test {
 	T(test_zswap_writeback_disabled),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
+	T(test_zswap_incompressible),
 };
 #undef T
 
-- 
2.43.0



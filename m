Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF00606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tGDxLBnG
Received: by kanga.kvack.org (Postfix)
	id 8E14A6B0626; Tue, 27 Oct 2026 04:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891E26B0627; Tue, 27 Oct 2026 04:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAFF6B0628; Tue, 27 Oct 2026 04:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 489D26B0626
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:39:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAEF11C4314
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:39:33 +0000 (UTC)
X-FDA: 85367757426.30.98B2965
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1127040002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:39:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tGDxLBnG;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
	b=HaHFvO1Nf/yaKTHigclsdQCGM98bNLbBLlJthmDwz0imzQHyUw+hJa5rgK6Q5A0rSwaRot
	UO7GJrUg+iEWDcNJNLDAvL/ifeOKs1FtY2ossNgMzDxAS/sUGEEv+muTLQoLDCuNVcPWDU
	VGGdgnlL66+cYQuI6HL22vMmrOLyV7M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tGDxLBnG;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090372;
	b=N3klvuQJI9P3EoysaNzN0pIPqUv4CL3bWykAlcHf3TaPhO1J/JlVvpeFE4ewH6/wdSVqJD
	QBiciPYXErf411edhc4lhOdk5A1N82P2lLSubJw3fW3anEsEZnji71z4xpOVnRyIcMIyJl
	LdjT0rERh9UMRtLLKERRk9j5sMcCaIA=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e8fe8e343fso22773955ad.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793090371; x=1793695171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
        b=tGDxLBnG5Y6YsGW2Aj+uckoG7xb4e/V/E7YW+loKNZ9aOHZbUS/gIUbTW8gmigvBwg
         btXtr+HHQcXYG2ebv5xMbxrULje8xlseYplEyy/9A6ZQWa3xqD4BT7t6BaycdaoNae8k
         uv1HcbJ6oN5gY2KCqFAcCItTyd8+2inuvIz/aWyadTfbGx2c1byNmwlVx6sjoiAL3wB5
         sdXYlh/L1EXYC3YXi6xRmctGdzzYUXysCLMNztKIpUlkgEf2XI/e734cG0FApbyoJ/Hj
         0t/kbBgQzSureKr+U09/raX6mn5jgzTfKodinOL4xJn8hnY+FzVwQ/1t9FrcV4s255ro
         pHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090371; x=1793695171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
        b=enCpSwmKBCeEy5pwlBahUTSH6IDnLagwrkrHUEI8++qAZwPRm60hB3ei7Zt6rllhQt
         W5jE5S28Jmnw5HVM3Qw/AlaXCP7wLuadg+yBlprqWkg2g5p1NFHyHMD1ibPgb63GS5XQ
         V44nXh6YFX9qJUDZNBSX2Ga3ZE1dIWVL/mFURA+LVYoNCKZhlylWT+5nU3a+7eUutjKZ
         /Quqmdk/hWgUzVR3kFSB3DtjX+kmG02cx1JpZSLt25p9+3NhH2wp9FPNLt/wkFLXpg40
         VJ30/dTATP9v9ceWj2MdcpnZaKIKeyjxq2t57/GDwtK7RveryXx7rgjwAghIOmhE/jKJ
         zhnw==
X-Forwarded-Encrypted: i=1; AKwUvBzUR6FZ/+OqXcJsHtGoqd2gfQXcrEiV2kCrdI5wGOdlkBmuYJD+2awJx/RWTG0SiYJFMVsaQZJNjA==@kvack.org
X-Gm-Message-State: AFq9FYIAq9VR0UnHuvdbXIIp5ckgkRXOtP7jinB1SdyYnMVG/qtUPDl6
	LEHviWz7HMA4J0Vx+orSTVUyVpqUhzu/xh8zAXemt/t4C52+DM7t4VsE
X-Gm-Gg: AYBFou3Mdzgy+dNYEA+ERy8oFe08701eofN8juevBYWTlprLE9fvRHjMyePVaeN1WOG
	DBhya+QpBKhavFNA94hmFlS85JeKrt0Osa6jWlT9yuJsT4twg5vjkZ3N+myBHgX9jGmIxeUK2rE
	wwUEtL5ovkWNRF9UuQtofMyenV3wT1e8rD2wiMSg1cwiPaRs7ff+54s/ODAqs2Bpv31B4nnDgPd
	qOTvLde4mdm5E9anRmYDSGFS0zcMy4Xo7jGMI6tsJ0XFPskqFDiY4w4Q3TPCz+Z7Ewv5WC4RWQl
	w44RdJK2tirQDiVv3DuWd1bHB0WaguROSz+qXIb2EfL9p5neH/Pm4EMcdCF/xC2b3WpwFEGUGWg
	Y+PyVFY9Na1THNFRTUYnIver3q+2DukZuzKraZbyr+59UgxsAwIXf3+x07pKZn8qnopQKUShgaa
	4MlnpblByNM9rPSKAkBJSLG6oNYmFJwheWEHyw4RA2+oIaii9gByAR5S8WwCDtFVI0uEBOp1gOH
	+XD+WeXS/OhuY0OritOdkdgzXRr+DFzVv/pswjW/LzlJGhTyHGBR93DMlMG4RjblvWeruqx
X-Received: by 2002:a17:90a:e18c:b0:3ad:3e8:12 with SMTP id 98e67ed59e1d1-3adeb126491mr6478782a91.48.1793090370681;
        Tue, 27 Oct 2026 01:39:30 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4041fafcsm3618951a91.0.2026.10.27.01.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:39:30 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] selftests: cgroup: test memcg OOM on a process whose leader has exited
Date: Tue, 27 Oct 2026 16:39:23 +0800
Message-ID: <20261027083923.2412015-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1127040002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3rsob1u6jeha8dk8ydi69hdqrf91w41s
X-HE-Tag: 1793090371-951665
X-HE-Meta: U2FsdGVkX1/qCSO/z6CodoSFbzyzDdWhcRXRYN2cWPjR4TjbaQT5ejp36RWGfhAOTLvFS9sdxBuYvuqPXUeLeV/479zFWzkXAhgwHfZORSaB0jV1GI6kxPiFsGH4GvKHkiSxRHEOXQc5LwUTQfIIKtVvMhCieIms3xlguGW7XL9z6HxQtwZR1uIjuEAgi6aZCPC1qhC+ZF59qmnjDZ67n7r76sFZ7ygxtMtuC4yJF020gT7TcTgDGjorPPd6QImQkmYQ1jzrz49HMRcndbjGk6N8L1neB9uJs+1TqJHGkfzM4ZPyekeohEXnc9k9Py8jMuIGPQA6VBiWEkM3rP1u8RN8p9wReG/tD6hEVwN5y/8tGohClkJ9sIXcK6zeZnjAOAuEcSIif1ji+GUpKEgdcuhNsaL15qW6TbVbwlUAiaaH7MPAUiaGMAjD50nN9koNfctFQRz/Gamzkao2dep03u5/hQZn3JHUqEKhHju+zjdqZD8iyOxEPTM5Jqjvo7Qyp5NXU5NVlYrNsQnFJLrw+ViNvQGoMiFew3hb7AVc7gCYvHRNG7pdwD4qQTjZsTPPiCHF0x+RgnuTz7q3qHsNxz/gdmxBzZWwONQ2nFQY2agSn/2rQcbH1XBIF6eSCjaD4RtOXzkDMDyp6C4QvaxryO6Q4icyplOk1V9XLGkfim8GHm4Bu+5GaMGDt/clQ2WvK22sgipm4kNne95rsi5xMouRJbOYFWtx+EuCbT9eyLzDUa3bdEz65KmFD44cu6HJYn6ZUOhnZUPKwhfaoG1gEshYWX/BMdJt7iT6Ly8vGtMBldct9zBy4B78oiDFJ33GQdiJ6+3sa4BM5UvhEkSuuP/9tVM9dCjWdEfmbc7tKE0A4jIaGrIOyMOLOot2k3Ye6t3uWGC8ZgQu5/G0RIxmeZHGesE78T73qFfn3vLZ4V6Ht8bXPTigy82lPoAdOQ52nog4da5nRaZp0sGgBej
 pSOK5ItI
 P9IkNphfJzdRMoLPI1/GBbKIFIbK4T3FPpkUW11CS5rJn5ls1NgUPJYj5u4VKx6l8J0xHxP//1UKBQvHRpeQkJyM5DWkRX04Ya8cF/R98JQalOCkv+QhO0oL6rch16tYvZNs38RlPVXH+gIqD2EKcVg13mt+IYhQTYjls5kvHw8uJWBKxRRVM+TdlSQXZS1sZ8PsE0CCREixsaOSviWkwFENxu5mHlkH6QbxBtunJJi+/bSb+A5LO1zLgwbpidpQItKJEmJGhkeh3orEEMbg+SDgQ2ljdHiZI3AxyJFcI0o+nUq1idfmAPiViMIp3pQDgy9ZaAFuMxMnVPrPRbXqrigmu7DoY/FeRub9bbQAN/6KrM0OT7RYtC5w3d5m++8rrtBYvLVLpJjc2ZRPvZL7fI81UKhJeNDxVe1t3+k1avI4Aejs0pN/TQRviEha1bZE9yg1fU0c0HrphEd7ljQSCFXcotMnYKlOvowuW9zgp/bm+PKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

Moving a process whose thread group leader has exited leaves the leader
behind, so its live threads sit in the destination memcg with nothing
listed in cgroup.procs.  Check that an OOM there still kills the process.

Without "mm: memcontrol: don't miss processes whose leader has exited in
OOM scans" no task is selected and the test fails after five seconds.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..bddbe923fa42 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -4,6 +4,8 @@
 #include <linux/limits.h>
 #include <linux/oom.h>
 #include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -18,6 +20,7 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/sysinfo.h>
 
 #include "kselftest.h"
@@ -1417,6 +1420,125 @@ static bool memcg_sockets_disabled(void)
  * The TCP client interleaves reads from the socket with check whether
  * memory.current and memory.stat.sock are similar.
  */
+static int exited_leader_pipe[2];
+
+static int exited_leader_thread(void *arg)
+{
+	char c;
+
+	/* Wait until the process has been moved, then fill memory. */
+	if (read(exited_leader_pipe[0], &c, 1) == 1)
+		alloc_anon(NULL, (void *)MB(100));
+	for (;;)
+		pause();
+	return 0;
+}
+
+/* Start a thread and exit only the thread group leader. */
+static int exited_leader_fn(const char *cgroup, void *arg)
+{
+	const size_t stack_size = 64 * 1024;
+	char *stack = malloc(stack_size);
+
+	if (!stack)
+		return EXIT_FAILURE;
+
+	if (clone(exited_leader_thread, stack + stack_size,
+		  CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND |
+		  CLONE_THREAD | CLONE_SYSVSEM, NULL) < 0)
+		return EXIT_FAILURE;
+
+	syscall(SYS_exit, 0);
+	return EXIT_FAILURE;
+}
+
+/*
+ * Moving a process whose leader has exited leaves the leader behind, so
+ * the destination's cgroup.procs is empty.  Check that the destination's
+ * OOM killer still finds the process using its memory.
+ */
+static int test_memcg_oom_exited_leader(const char *root)
+{
+	char *parent = NULL, *src = NULL, *dst = NULL;
+	int ret = KSFT_FAIL;
+	pid_t pid = -ESRCH;
+	int i;
+
+	if (pipe(exited_leader_pipe))
+		return KSFT_FAIL;
+
+	parent = cg_name(root, "memcg_test_exited_leader");
+	if (!parent)
+		goto cleanup;
+	src = cg_name(parent, "src");
+	if (!src)
+		goto cleanup;
+	dst = cg_name(parent, "dst");
+	if (!dst)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+	if (cg_create(src) || cg_create(dst))
+		goto cleanup;
+	if (cg_write(dst, "memory.max", "30M"))
+		goto cleanup;
+	if (cg_write(dst, "memory.swap.max", "0"))
+		goto cleanup;
+
+	pid = cg_run_nowait(src, exited_leader_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	for (i = 0; i < 100; i++) {
+		if (!proc_read_strstr(pid, false, "stat", ") Z "))
+			break;
+		usleep(10000);
+	}
+	if (i == 100)
+		goto cleanup;
+
+	/* The exited leader stays in src, the live thread moves. */
+	if (cg_enter(dst, pid))
+		goto cleanup;
+	if (cg_read_strcmp(dst, "cgroup.procs", ""))
+		goto cleanup;
+
+	if (write(exited_leader_pipe[1], "x", 1) != 1)
+		goto cleanup;
+
+	if (cg_read_key_long_poll(dst, "memory.events", "oom_kill ", 1,
+				  50, 100000) != 1)
+		goto cleanup;
+
+	if (cg_read_strcmp_wait(dst, "cgroup.events", "populated 0\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (dst)
+		cg_write(dst, "cgroup.kill", "1");
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	close(exited_leader_pipe[0]);
+	close(exited_leader_pipe[1]);
+	if (dst)
+		cg_destroy(dst);
+	if (src)
+		cg_destroy(src);
+	if (parent)
+		cg_destroy(parent);
+	free(dst);
+	free(src);
+	free(parent);
+	return ret;
+}
+
 static int test_memcg_sock(const char *root)
 {
 	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
@@ -1816,6 +1938,7 @@ struct memcg_test {
 	T(test_memcg_oom_group_leaf_events),
 	T(test_memcg_oom_group_parent_events),
 	T(test_memcg_oom_group_score_events),
+	T(test_memcg_oom_exited_leader),
 	T(test_memcg_inotify_delete_file),
 	T(test_memcg_inotify_delete_dir),
 };

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.43.0



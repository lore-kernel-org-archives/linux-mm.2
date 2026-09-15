Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B00C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FB16B0098; Tue, 15 Sep 2026 04:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816C86B0099; Tue, 15 Sep 2026 04:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9836B009B; Tue, 15 Sep 2026 04:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 433186B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADD5F120365
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:43 +0000 (UTC)
X-FDA: 85215257526.13.49E305F
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id DAA9F40004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JjLbshAS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JjLbshAS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459421;
	b=Q5EZMnFJ2Jd5TRKL2WGyyLPE1IEdOf0203C75lUDG516N/6TGgCgpZAlsGBGtu4Yz6JMkk
	bDckolme2zesZvJ1ebZsAHWw/Lhm65vpoN6IUxYYn8lMc8sylCddFShYx0jddgTiA3dgQT
	QdlAg9ZaPQDqs1+Mhe6gXDdfJAxue/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMfo0lOkU7nY+kpMSBVMONrY7JpNJm89ZLpxpQTDFY8=;
	b=oM6hoWoSb2rN5PQhKX7nM1KMYKS2drYgGdyGznm9/voajWg4LG1kADGY92+0aqt/t+gs41
	l6iv73zRgieoN1J01TXikrs53wD4D+nhByF0gXK1jAuTGbMabp4M2RZkVLLziqHqyLqgWX
	zDXzQe4SzV7+2x9eEdH53DDanzCDm4g=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4858bc96fabso1972552f8f.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459420; x=1790064220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JMfo0lOkU7nY+kpMSBVMONrY7JpNJm89ZLpxpQTDFY8=;
        b=JjLbshAScVdjORNn012JzEte7n54apDih/2KI16GvIn6RtD89XHAOSEK+y0s5BXI+3
         d/H7NbETqF7F95UT8KdNmDu10YhNIyIwnp63AvNX1RfoxX1wA7OSWW4lFeurQvzhdrXh
         tP2m5A6fQnGwjhh1Ns2j7QkmKEoWLe42irNSFzG80Q9MQ4Us1wuJfBdPafuxDBI+xPt1
         ee+GdUDHYfFBwCMuAn+fN0Pn3COIT5nenc8rK57nQx2aa9SAs12W+3hjT6zlGjcnhjL0
         UO7VfFh/pvX7oFZNMyjhn9qrCO7zs4Vf+M/CtpDPcedm4QFrSfj+k8yONsfE/uG6dL8O
         MitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459420; x=1790064220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JMfo0lOkU7nY+kpMSBVMONrY7JpNJm89ZLpxpQTDFY8=;
        b=dtQiDaS3ObRWUCTl/7dCo/UZ0RhAJeG6yDma44hzRkDPtIMqg/dKNK4AELSqpDjGkG
         5frcy0f4VmQGlE+WzH/nHm/gZAtc3vJ+zjSVBi1tvtJsMZof0w6kM4qcPcXQ6PgXsk27
         HkY1kXkztE8CFq4P+Zt4WGcvKT/Rhr7cQaY1X4Lc7uRR8vt+64rueCVxtKU6Pk1aIyBu
         wMeQ1kkZIMMG+ffDj1KWFiLKhfhhvDAgHjYi00prEg2mlbidcwADEOj1oRbRDXuXX67Q
         HnfE50U+5usjPJZYR4O4UeNwly8xFmpI5MiRIr+A5jAMMvsFtS8xuPQ40OSu5dZ7i/qJ
         E65w==
X-Forwarded-Encrypted: i=1; AKwUvBwlIFwIsTu2W0BTuEhTH2zZ7A3duzLhPrt3OCOptvt4u43SHUsSN4DtPwbGk4D0GoQEPYAPXmhOhA==@kvack.org
X-Gm-Message-State: AFuF++nEYwxv/NJBgZx8P9cf0MfApWHfY8ofhYF2lsWkgaJqGXi8r7d7
	3etoBVtXT5mgbm7zgbX1VbdWuLu9EokYuDLR3xHULSHc7fvnCzou3rpc
X-Gm-Gg: AYBFou2q+FQbzEFYFmdB4DomlWn8OcZ7y64WrccCc2yUvzw5Ta+7RFESNWA+08k4/GA
	tuyBzKkutz3BKBUS1djR4+maMTG2xl3MOQz43V0AeGs3bMnXRhYRNVig0W2NJaEbk2FXYSwRfAJ
	o3kHkoAai5okR0JtmuTb5+19sAtJRSiyENXh+UAf9ZimI6Tm+30IXkXX5U2RAp1pB/5tzBd6oF0
	OdM830diQy+kSzpn9ngsEqwDSD2FriGGX2AkXq4lTHAUsjPP3Dt1LLA211ZEaKjSvD6Anzo8qMC
	7fCNc6x//UVOt3eRX+AEIEvSXdl4l6yQuqdM/tyx4PTty3OD4VFtRLEUsZjRw6OYFt2DHFFSIg6
	TlRuo+PbSPARUK84uUPODyVPxWsbFTQwVkKY2J9OFuMCyWqCytvVboyNVQOz+LFbI2OrUervh8L
	ZkFhDUxQuwjL1YxJuGKODwxhGgFYSYSQFsNLqqeahHNgQ6QyH4csLG/rdRYELsNTBUJCiVUDvEK
	Y+eBCFhzavYxbfq
X-Received: by 2002:a05:6000:381:b0:487:40d:af2a with SMTP id ffacd0b85a97d-487040db0f5mr6181796f8f.4.1789459420380;
        Tue, 15 Sep 2026 01:03:40 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:39 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v7 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Tue, 15 Sep 2026 11:02:55 +0300
Message-ID: <20260915080255.48929-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DAA9F40004
X-Stat-Signature: oudfahgxyzmnpoxjghcg5sypuf4jatbp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789459421-791459
X-HE-Meta: U2FsdGVkX1+sGqCIwsIQ1tG6cotTg4GAWxdbt5elDE+Fw5mY5ItGEi+Q0yQmzJ5dSWzmejZ2vKI9nknxxDF1IFvzdrVzXPUfdagSviXyqCgr8oruaBxtM1Gz/8LpdoiaNht9OdByX3BrAjjsm5deTjKxGO4kSFKgJTQX4HLmQHGQnk9LMuR9oV7eW9mvWKvfn2MreUt7FysnQxtijoEAqMEc4ES35httco+lTAK6pTtzMb9wqEpbiN+HtPwqGU9UtxvuTguJC8SY0q3aH3nPnA9V2Bwm6orVIgGDg3fGSsEt9K5mzsmHATdNDcdplkEMw6gaykKt+ZQY0lDrk9W9HQSg4iNJTsjKywuyFt3uomXkZ++GZYoGKtmHXYdZg7x0kxELR5cf235lUCLLKv8w6iuk8R25qQjIg2iGDoOyu6YcSXJGkqy0/nu+KxAL/TeawMDAnT/0CJtVo7CUyTFu47HVqnFljnf/eSwj0XdKH9vtAaa/d3JARFjo6iUMXtAmUbvUdzSZzYswN/dWHhn4PBQ7t4czXUOLeo+76y4DBHTkBgLh0eoCRR4lTYgdgDJK5+RF+a5sfBrpN4olJUmaxpoSXcKlkfo3PVwumni9NCwoYntpVNl0j9yw7uQXqmg1jt5v4JCa1GXrRgWapyvUAc/YN0g4PYyFcWXxhGJHz+4HDETeM2Hg9uToxMEw8rdqVsa8/OutMhXScRAbNVzn6oTTV3csiigAi5pRRPgiIuYnDpg6JrOylyyCaO4NA2UY90XchCyAVCjvAthU2aCgki2Oc59fuYLNGxfxCZnKXIWam0qQ5XlBT65JpN0XXnK8P8oNzi4+QAgleOC3s0z1t94OhUh4TnBqeg5P7mlZSOOWR1jopmdSEVtMGLeuhoQVAOy3KMNhcjNY68XKtjZ6foGUKcctWmQ/vz49Jp7UpqU2R1AbcogbQ/IsRw3n5M5TjXW+vIKkxxPJ1lQfVf6
 EHWHIhTY
 lnchLklGuIXL9AtofcC/3UwV0i8KHALogCRmH/jj3fp6QRo2xDxEUNx3OLx1fAWZg0t587py7ysEw8ahrIt/zU0vRDxqFmB/cWO+rf+dS9Yz6Bzu7p79hcFyp538FhCtTVGPxTdxfG9xsd5UUrFUr81O1dELHogNSF0m7M5JmCLjBFLdaIR2taX8Ok04m8BN6XIvKCYIr/mgfWpwSyANC576anKG1leHTbEf+iYa6ODPjALpgz8HC9L5U/yxdPbzUAxlQkM3xhRskOmeb+mJdLL16CyKq3M2/Dtt0rR5JAEWsqiAEO82qJPrqXuypJLIHBjRfQwx+Ai31UqrdsjoOYyaQ6u5jdmWVo9xmdW+dkfpWEUKD+9YItY0DhzO8gIs6a5uodpYpOQk3mRxA6eJsuW9C1oXO/mrYFlPr0J0YAimNk6tDG8Wc6J7V4PMV457NgR8OHngioQy+3lL31/t9w08h+WQwk+4zMoCkHdvh4fOrhWp5HxG67oImBtskam7rAwSbMvmM0Q4y+AjRCFEn52GF5eRb90FVvGU2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF LSM program attached to bprm_check_security to test
bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() on CONFIG_MMU
kernels.

Starting at bprm->p, verify that bpf_copy_from_user_mm() can copy the
contiguous NUL-separated argument and environment data. Then use
bpf_copy_from_user_mm_str() to read each argument and environment string
separately, advancing the offset by the length returned from each call.

Skip the test on !CONFIG_MMU. In that configuration, exec argument and
environment strings remain in bprm->page[] until the binary loader
transfers them to the new process stack, so they are not accessible
through bprm->mm at the bprm_check_security hook.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 +++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 122 ++++++++++++++++++
 2 files changed, 194 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..ef351cda9348
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include <test_progs.h>
+
+#include "copy_from_user_bprm.skel.h"
+
+void test_copy_from_user_bprm(void)
+{
+	char arg0[] = "first";
+	char arg1[] = "second-argument";
+	char env0[] = "SOME_ENV=a";
+	char env1[] = "OTHER_ENV=something";
+	struct copy_from_user_bprm *skel;
+	pid_t child;
+	int status;
+
+	skel = copy_from_user_bprm__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	/*
+	 * On !CONFIG_MMU, exec strings are held in bprm->page[] rather than
+	 * being mapped in bprm->mm.
+	 */
+	if (!skel->kconfig->CONFIG_MMU) {
+		printf("%s:SKIP: test requires CONFIG_MMU\n", __func__);
+		test__skip();
+		goto out;
+	}
+
+	if (!ASSERT_OK(copy_from_user_bprm__attach(skel), "attach"))
+		goto out;
+
+	child = fork();
+	if (!ASSERT_GE(child, 0, "fork"))
+		goto out;
+
+	if (!child) {
+		char *const argv[] = { arg0, arg1, NULL };
+		char *const envp[] = { env0, env1, NULL };
+
+		skel->bss->monitored_pid = getpid();
+		execvpe("true", argv, envp);
+		_exit(errno);
+	}
+
+	if (!ASSERT_EQ(waitpid(child, &status, 0), child, "waitpid"))
+		goto out;
+
+	if (ASSERT_TRUE(WIFEXITED(status), "child_exited"))
+		ASSERT_EQ(WEXITSTATUS(status), EPERM, "exec_errno");
+
+	ASSERT_EQ(skel->bss->bprm_argc, 2, "bprm_argc");
+	ASSERT_EQ(skel->bss->bprm_envc, 2, "bprm_envc");
+	ASSERT_EQ(skel->bss->data_len_match, 1, "data_len_match");
+	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
+	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
+	ASSERT_EQ(skel->bss->str_arg0_ret, sizeof(arg0), "str_arg0_ret");
+	ASSERT_EQ(skel->bss->str_arg1_ret, sizeof(arg1), "str_arg1_ret");
+	ASSERT_EQ(skel->bss->str_env0_ret, sizeof(env0), "str_env0_ret");
+	ASSERT_EQ(skel->bss->str_env1_ret, sizeof(env1), "str_env1_ret");
+	ASSERT_EQ(skel->bss->data_match, 1, "data_match");
+	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
+	ASSERT_EQ(skel->bss->str_envs_match, 1, "str_envs_match");
+
+out:
+	copy_from_user_bprm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
new file mode 100644
index 000000000000..07ca96d9db45
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+char _license[] SEC("license") = "GPL";
+
+static const char expected_data[] = "first\0second-argument\0"
+				    "SOME_ENV=a\0OTHER_ENV=something";
+static const char expected_arg0[] = "first";
+static const char expected_arg1[] = "second-argument";
+static const char expected_env0[] = "SOME_ENV=a";
+static const char expected_env1[] = "OTHER_ENV=something";
+
+int monitored_pid;
+int bprm_argc;
+int bprm_envc;
+int data_len_match;
+int invalid_flags_ret;
+int copy_ret;
+int str_arg0_ret;
+int str_arg1_ret;
+int str_env0_ret;
+int str_env1_ret;
+int data_match;
+int str_args_match;
+int str_envs_match;
+
+extern bool CONFIG_MMU __kconfig __weak;
+
+extern int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				 const void *unsafe_ptr__ign,
+				 struct mm_struct *mm, u64 flags) __ksym;
+
+extern int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+				     const void *unsafe_ptr__ign,
+				     struct mm_struct *mm, u64 flags) __ksym;
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	char data[sizeof(expected_data)] = {};
+	struct mm_struct *mm;
+	char arg0[32] = {};
+	char arg1[32] = {};
+	char env0[32] = {};
+	char env1[32] = {};
+	u64 offset = 0;
+	u64 data_len;
+
+	if (!CONFIG_MMU)
+		return 0;
+
+	if (pid != monitored_pid)
+		return 0;
+
+	mm = bprm->mm;
+	if (!mm)
+		return 0;
+
+	bprm_argc = bprm->argc;
+	bprm_envc = bprm->envc;
+
+	/* this is the total size of args and envs starting from bprm->p */
+	data_len = bprm->exec - bprm->p;
+	data_len_match = data_len == sizeof(expected_data);
+
+	invalid_flags_ret = bpf_copy_from_user_mm(data, sizeof(data),
+						  (void *)bprm->p, mm, ~0ULL);
+
+	copy_ret = bpf_copy_from_user_mm(data, sizeof(data), (void *)bprm->p,
+					 mm, 0);
+	if (copy_ret)
+		return 0;
+
+	data_match =
+		!__builtin_memcmp(data, expected_data, sizeof(expected_data));
+
+	/* arg0 is at bprm->p */
+	str_arg0_ret = bpf_copy_from_user_mm_str(arg0, sizeof(arg0),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_arg0_ret != sizeof(expected_arg0))
+		return 0;
+	offset += str_arg0_ret;
+
+	/* arg1 is at bprm->p + sizeof(arg0) */
+	str_arg1_ret = bpf_copy_from_user_mm_str(arg1, sizeof(arg1),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_arg1_ret != sizeof(expected_arg1))
+		return 0;
+	offset += str_arg1_ret;
+
+	/* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
+	str_env0_ret = bpf_copy_from_user_mm_str(env0, sizeof(env0),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_env0_ret != sizeof(expected_env0))
+		return 0;
+	offset += str_env0_ret;
+
+	/* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0) */
+	str_env1_ret = bpf_copy_from_user_mm_str(env1, sizeof(env1),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_env1_ret != sizeof(expected_env1))
+		return 0;
+
+	str_args_match =
+		!__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
+		!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
+	str_envs_match =
+		!__builtin_memcmp(env0, expected_env0, sizeof(expected_env0)) &&
+		!__builtin_memcmp(env1, expected_env1, sizeof(expected_env1));
+
+	return data_match && str_args_match && str_envs_match ? -EPERM : 0;
+}
-- 
2.55.0



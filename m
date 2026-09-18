Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0C8C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC066B009B; Fri, 18 Sep 2026 09:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CC26B009D; Fri, 18 Sep 2026 09:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498D76B009E; Fri, 18 Sep 2026 09:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D78C6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6731BA0680
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:36 +0000 (UTC)
X-FDA: 85226937432.20.6E4226F
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CE38C0012
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jE7JU1W+;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
	b=qkvApFyoi28C8wu6MMq+MMuGg5KJiokyD7SAzGBvYQybIvT2o3UfwsLttiJjHhDJCT6EvT
	H4LnOAVZhryzqR7azyVtPGjkaKogUbLkV5/cjsTzRad99SfMUjY1tgoDdG+qMW0JD/0udG
	ns0mkf/yVdpOFqV9S388+CrDDM9+1qA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jE7JU1W+;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737514;
	b=7AguIr4HLzJ4iJyfbh586NoOw4ul8nGeltm+5bDyvSLgwTUN+wUTlPqV61LRAYAUrVqo9e
	XXNSWygThAju0o4oZKhuFMz1kvA7asH7DVik5ZM5aGuojSKE60Haxx1bH8+DRSHH41xLjK
	d0M6++WGnk8Pcp6Dtzm4yYdL7QAHtKM=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4858bc96fabso585375f8f.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737513; x=1790342313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
        b=jE7JU1W+nRBlU4o2vMpihb9fLb5CRZz86v1ax7g/7vGqxB6sl3NRAk2zTaFUlG36eU
         Zg+WBNQ4BubS/86EcJKitQQ3z5ZC6Q4XlmSCPPKz79ErLrqMRiFKXob6/8h3HuyVqzbT
         Z3pSwTRBI7l4PXlLPl3mgq//ref44LQu7RK3GK+68WL85eFUJMQsUaFRwt9ZWgfegjc0
         8rvVrfloMQx8qvpAS/MuBFiAH9W+S89tff5uS+miLS6sEWDXWwUMIb9TAJC2J4wfp4So
         Q7TqMwlFFnmsL82oGuFHzINipcQGz/wqUEdp0wkuJeFZoNQP60U6u1g0+Wawtp/4JB/Q
         ivmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737513; x=1790342313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
        b=Pim56JeOj+9wUYmIwBoCiN6klkXpViCYArCntlSZSSDJAvqxGUJ7hMfGyltCt/njFM
         kqFipDy+NMqH6roS47yyvih+Ij/ujBJoALTMLIO00TNWALKIAx2KzgXb46G+5izuGV2L
         ppvp/w+u3z6hKihY79GoAutmFTiCOJG2eIkbXcqi6UaTZPyUFQg3WuUHxwX0iTTkpedh
         hxXmq21FMX2m1AHSczW8BUtusQHCmC6CBbaX3T0ERcEoikkVoQdL1wpk4DEPcKulp4ru
         Szc5wkWcpy4T6qJidVWc6GIgsAYDzgy38QEUn4dxcJhRYBQqfqTTdqvjFPeBGVu8HE8z
         h7vw==
X-Forwarded-Encrypted: i=1; AKwUvBwCSITy/61VquYP+olOhZCTWhty2CtXFuzyYuT5fwAfaFn6wiKs03NwbeupHCH8UfSvrOA1D+LgEQ==@kvack.org
X-Gm-Message-State: AFuF++ll0c4Ideqao3Qj34jvlr54V8X6Hp/Rxm9bEBZmtLu9CXMEHnMv
	zYRwk6VXklSYShPU/lr4Jmen97k1ZIUWXSnxSwl3VIzxaYB0lD812XZF
X-Gm-Gg: AYBFou2fm1ld1aPHk/Ss55axPiQ9MsiqeBRxXhnfGCKSWCdgd6g2LSPcuABLG/kR9Ch
	I/30ODNAHEEYJX8fJEK4jrhWKeEthIxysCJuZhsek0MzYBSjkndBvjT+1vGw7jcW91EoMYNlgbq
	/8Fhk5TGq/kXMpXEa8v4YZ/6WTUfkKxuv3DQgzb7+DhDoIpyUQpgfN+O6+0CzwYrdwCgGd0W1Ck
	ozU76OovF85auaJwXRDzNj/qWptg11e7Xz98wtofbItzF0Gs/Dgq+BqeuLuJf7x439b/vIB3rzT
	KHwWzW9gg2FLaRbxy1yDhMlbgz1No20Mpnu95zbBYYhrhJLCF4H0KBIYwVqalRDpKTA2PC/JkY8
	9tmMAXsdiHF/aAZmkMiW8GAsANFn63HpfyrFv14ujUMAJEE79+dbqyEIMRL7PPjAWhff4/8ceDL
	RV5uDfnS29c5Of6W/3FEPTVLsTlsPOrX4/Lxui3beAmcp1ZuIxdtrFswSjVaKOSDcoacVkuBQUa
	XXeDryZdOGwQmo=
X-Received: by 2002:a05:6000:41f0:b0:487:7fd:730 with SMTP id ffacd0b85a97d-4871e254ef7mr3501858f8f.13.1789737513163;
        Fri, 18 Sep 2026 06:18:33 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:32 -0700 (PDT)
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
Subject: [PATCH bpf-next v9 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Fri, 18 Sep 2026 16:17:57 +0300
Message-ID: <20260918131757.42802-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CE38C0012
X-Stat-Signature: ak95er8mk5xtjf5qyb7465497aa9n3ii
X-Rspam-User: 
X-HE-Tag: 1789737514-367061
X-HE-Meta: U2FsdGVkX19dRBdG43oQgtYc+F7A7aYib013SyeKOAuls92Yl4Q6TtmMVVH6YaiEGu8hF+45gcn/C4EpBZQKCQdR2s7XPL12FhQaS5m5kNmkvMTasBXuqg+cgrfiYt3x8gtADMqXW6WMiHEAeP2dk2gINW+jOQP7be0PL5+wuEEjKUKW4T8rogCEl4funLA/Qv6nGnXipc7jZ2rUPU5Pka7fAJIFu/rB1EyNTVFWwFSJydbBya5e9s3rZmuuAcqhPhoC6uxJQZ+D5o7B11Df+W1iqKzdpqcLmahE9KZgLzzEYaThQKi7/biKC6T6uq3wfBWVR+/lrSBdnwPSZ05WfGxzVQdWzmyi1pqWM6P+y7t6fMY39MHF/gypqvg8l+u3GkX3w0KDdlWH3uUFZdpdKhxtpMda/Yok0i4o+SiinmNGaA9tqucW2vZOKMkKSGCYnUJd0B+1aq5lCsfZgSJxO/q4wxzMBD1eq4ZyI2A1a64akkEtAQU9rf7MIu1jXvYMi0FcClPScBdDQn2fN+NwsuL/XNdHZulDZwuSbB1avfKiNXV8j0inrexkOjVLQwmQxgh7HvMGiJ1WoT4NKHItMN8D/glE5SeUhPXhmJpJoVr4ugoOiyw8FGQhGnuQf4Q5weTwiTe5BjeoHQMNYWA789ikrdzcsyYcPUP9WndZObkn02d+Qx68EB8a03gNBkePGZBhTXjALU8poRa0M4ye1CnEbtnwSFmsqQNddjjxgzLGc9qbCa5TlL0+3zaSWpiBTAD7baF9eN+cHv20c7xY+rQX96JCGphZicKzoulIjodze+OEB9HDt4RJUgFlHA2eDZapjo2e0LNptgguGlSa+Ri9HScERnjrAj8n/dJrXaqdl+rf1MDjL2kU/YpF2b1tcZk4/jEfxWrk+VZInCR8vdfatEp9a/ClLtmGJI4yB/+T28igB6TuF1K9HbUtMN37uPRP2GKjBHQWUnKxlwJ
 b5Geb8+F
 p2VQdWfF9CvyIq2r1Aj9f2WFtmNfnDUw4M6DDEUzMp0eBZgAVy92hTSCBJD/SvAhdmSL6DOAwXDz5zbAMhK4iWbowKl+/ixPTUtia4dFPGdKGyZrHcW9T2eldQlHumc+SFIs6G8ii8Wl8b4lDRnLyJn53SD01IwFRSEDMiFxGjq/m51KqXNKe0iEDj5M420q9ImX9f3oDI468Tb0qpNeTHL+M4SmljPUY/yTTidxL8MRwiATMGcHwy6+DcpvLwFo25/V+zX5N9an8nlqg468rxP8slqsJT8Gq2WGP+lcPw0m4EeaSUWEzAXaWNKhpWXlioDCbJ3YMjhGF874aww8KEOIpGFTYK626QwjOGG5/9PKqM+H1TEQnxlPjZOdjFSSB5u9ITCPiQOLk2AWidfdZWTdcrkXY2CfXwXW6QlZpXhw9SuJPlvEEs5nL6DzKpaERQckpy4/MccAsB5qByEYIYc33Ui4lmb/2dEJg3nyCxBHjzOAvm/XLGqtKMSydkxHvmv04TWfdAlRzpDzx4EvQk+/hjEPnGwsRO4YLcE7HQxBQMli2F1ENzx1eWJSC6znbA/W5WMBPJCGIGXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF LSM program attached to bprm_check_security to test
bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str().

Starting at bprm->p, verify that bpf_copy_from_user_mm() can copy the
contiguous NUL-separated argument and environment data. Then use
bpf_copy_from_user_mm_str() to read each argument and environment string
separately, advancing the offset by the length returned from each call.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      | 65 +++++++++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 69 +++++++++++++++++++
 2 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..310370689427
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,65 @@
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
+	char data[] = "first\0second-argument\0SOME_ENV=a\0OTHER_ENV=something";
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
+	ASSERT_EQ(skel->bss->data_len, sizeof(data), "data_len");
+	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
+	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
+	ASSERT_EQ(skel->bss->arg0_ret, sizeof(arg0), "arg0_ret");
+	ASSERT_EQ(skel->bss->arg1_ret, sizeof(arg1), "arg1_ret");
+	ASSERT_EQ(skel->bss->env0_ret, sizeof(env0), "env0_ret");
+	ASSERT_EQ(skel->bss->env1_ret, sizeof(env1), "env1_ret");
+	ASSERT_EQ(memcmp(skel->bss->data, data, sizeof(data)), 0, "data");
+	ASSERT_EQ(memcmp(skel->bss->arg0, arg0, sizeof(arg0)), 0, "arg0");
+	ASSERT_EQ(memcmp(skel->bss->arg1, arg1, sizeof(arg1)), 0, "arg1");
+	ASSERT_EQ(memcmp(skel->bss->env0, env0, sizeof(env0)), 0, "env0");
+	ASSERT_EQ(memcmp(skel->bss->env1, env1, sizeof(env1)), 0, "env1");
+
+out:
+	copy_from_user_bprm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
new file mode 100644
index 000000000000..00ecba3ea567
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,69 @@
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
+int monitored_pid;
+int bprm_argc;
+int bprm_envc;
+int data_len;
+int invalid_flags_ret;
+int copy_ret;
+int arg0_ret;
+int arg1_ret;
+int env0_ret;
+int env1_ret;
+char data[64] = {};
+char arg0[32] = {};
+char arg1[32] = {};
+char env0[32] = {};
+char env1[32] = {};
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	struct mm_struct *mm;
+	u64 offset = 0;
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
+
+	invalid_flags_ret = bpf_copy_from_user_mm(data, sizeof(data), (void *)bprm->p, mm, ~0ULL);
+
+	copy_ret = bpf_copy_from_user_mm(data, sizeof(data), (void *)bprm->p, mm, 0);
+	if (copy_ret)
+		return 0;
+
+	/* arg0 is at bprm->p */
+	arg0_ret = bpf_copy_from_user_mm_str(arg0, sizeof(arg0), (void *)(bprm->p + offset), mm, BPF_F_PAD_ZEROS);
+	offset += arg0_ret;
+
+	/* arg1 is at bprm->p + arg0_ret */
+	arg1_ret = bpf_copy_from_user_mm_str(arg1, sizeof(arg1), (void *)(bprm->p + offset), mm, BPF_F_PAD_ZEROS);
+	offset += arg1_ret;
+
+	/* env0 is at bprm->p + arg0_ret + arg1_ret */
+	env0_ret = bpf_copy_from_user_mm_str(env0, sizeof(env0), (void *)(bprm->p + offset), mm, BPF_F_PAD_ZEROS);
+	offset += env0_ret;
+
+	/* env1 is at bprm->p + arg0_ret + arg1_ret + env0_ret */
+	env1_ret = bpf_copy_from_user_mm_str(env1, sizeof(env1), (void *)(bprm->p + offset), mm, BPF_F_PAD_ZEROS);
+
+	return -EPERM;
+}
-- 
2.55.0



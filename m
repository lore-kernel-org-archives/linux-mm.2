Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C47C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD606B00A4; Fri, 18 Sep 2026 05:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1952A6B00A5; Fri, 18 Sep 2026 05:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0834E6B00A6; Fri, 18 Sep 2026 05:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4ED6B00A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3561A5E5B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:38 +0000 (UTC)
X-FDA: 85226315076.23.E24FDFF
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2DD0620007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z9ReCRfc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z9ReCRfc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722697;
	b=iJp4V66bZOAcNkZ7sfjArsiDUpIH2c7ZKjwpPZGZHyW0g1JwYsOQTTjGrMk1tk20RrRWCr
	2iPzI5RtsYFlLey8zUgFJr83yABYY1B53Uv3HRiqI5PQsHFBlvyfzH5wqReK9y6zHFNIOy
	FbAIPpMD1iX74IQ3e+Etxf42s/TtYJY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
	b=4KeB7q16whtA05ot8KWdkagrgMsIulx8RQClsFzaKdDCPkj9vB138TgmDV/E34+B+N/qFJ
	C6CKx0xIXSgbVdhRj3xwHWzu+/9V7lMeZM2xnQJJdHIwqM/tVqXGMuTQq4FFjvtyR2Ej7E
	vz7HtBvTPMdZ8FeJ1iwrnSYQ6nCLQcY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e620fa473so3042905e9.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722696; x=1790327496; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
        b=Z9ReCRfcfVDm+ipDoUNlykydKzsJP5Kf1N99igsVWNyh7qY1XcYjf8gI+/F8tk8/iO
         FpUH8GDOvAbcW7JGROKa6I4CFdJ23KpQ5XdEpdZKPyDJwuuojf4vVVsBKwgYhN3ZepEl
         xZf/Sscri7qsrXzL3WTBafOwAOifm8VWs0v3MVgzcaiRXC2GrDWf3GklG2WCI+6wQOdW
         V8v+EiN13pxKx5G+w3bbjbRSoNLCYAG3M0NW+2Ys05iRuzUaSbMLJx1/XtnzRMfE5cbq
         MmjcB88VHBmifY5Ked8HgMlVNghvqBGQir/6tMDsyVMxZc+UK79q8BegKkKryTvYBBTO
         7ADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722696; x=1790327496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fpIPJYBrAn9lh0X90aJ+LjetM4Yd20S6QCxk4a13+gY=;
        b=klGR8vPmyFb7b1spbX8tFjesYTMeNKjO7h5T87hFh9g1LL4OJQdQJf8xbZ+gynGJ0X
         nQsjzeTo8XTFV0rXyZbpbm6mZMxFm+14kMcfeZZIA4fqRRgU9vGKNU/VYtyS544MMK2J
         NmgwrHdL8QVetuUYf2hf/DwpVzRTXGfLecBnNMqYSRrd1A+1VBDXKhpSwbf28XHjoQcT
         y5V8dXeAmFhQAsWN9/w7iwRx0SCUXwNjCMRQOyiw8ThgBPjTDosAn34AKZ3V6ZA8+RlN
         UE9u/8Kvi5A9f20W9vUG4RNtgbPnkSWaUtNVRbRpC5zVVcjeIRmMrWt/aRCtH4srAmrx
         KPwg==
X-Forwarded-Encrypted: i=1; AKwUvBznaVxtVlV2A0xHOlI/2OBEIfJVprsi+nptc2MRVfYOH8O6eaZw5/uUmbEPnnvFZ1zvahUXybc8qA==@kvack.org
X-Gm-Message-State: AFuF++lAn9xztnEFiNCywoZ6VY3eoUtxhwygZOhOyBSbupHixBSJDu/+
	jbs4oG3hCXmI2mO7sZfPoG4WpCIrOpqdj4kGrlH7la09334vRBauiyNw
X-Gm-Gg: AYBFou3ppHXT4uWyrAHYiWlFDzIhQg/eF0X1QUhSglmYysgYYxvSP8Rg6B1Iri5Phgn
	fnaI7eN/aQAJXAFszG83RMWf3IR9BxOaAAwhfpakdjEDwDIDjUrWZ4irUCFYvkvxPOIukd13Yiz
	FWh7GQO+87NHxzOqvtK3FenJTqtDe7F4Ec3OPqTjwtgzvX5DhpPgjhgR95j4OdrpCz2b32bKSDN
	dktTMTFDZExwUqs/IAzMuMjIrVed6rCuE6lGny+xmBz8SWZbqC+qfpTxeVDRj0FKlF7QHDON0yd
	WkfeJzF/s5FEf1Q3EAx6VzyyLMFEcQyeIE7GdJgWasz79S2/ImEvXchofvbwSjlRYZYRkkBUzr1
	hEi4/LyeVmxld1KzBfJNNLGK6+xl/GwGUllCcV0Hy0uQHNXOx+Plk+l5f+pCEgKJ2ELy7NPAEKg
	IcBOtc9h8Iqemk/9trqR6RMPye4zHHtEKTBW63yAtuQIXTZ08ju2y3RuKQPyC60SCfnda6WOpc9
	Q8HmHes27PkdBEo5c82rBEhfQ==
X-Received: by 2002:a05:600c:3550:b0:49e:7d74:7b7a with SMTP id 5b1f17b1804b1-49fc56db8f3mr21040695e9.6.1789722695703;
        Fri, 18 Sep 2026 02:11:35 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:35 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Fri, 18 Sep 2026 12:10:58 +0300
Message-ID: <20260918091058.297740-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DD0620007
X-Stat-Signature: obok11ur7o6cpjmncnstifqca3i5dk7p
X-Rspamd-Server: rspam01
X-HE-Tag: 1789722697-511030
X-HE-Meta: U2FsdGVkX185f53+n53vF0Hd77KYuj1xihtM9wsrU3IPl4BFLEzr8n0W83HdXN0rixzYCzdHok7jsr6Nntzy0h4YV32dOBFVPXCU6NWS0XfmpVrVK8eU4x78DDJG2edHoykcMi/om9wxm/mMegBwKZP4oOXzDJUphBQVx5xo2Gmojbb+LJMc3xt1q0i/HbitYecHF5i7hMYUQhmkcNzSkl0bReTpP2cFhVTiBnsss6wVs8Z0mCN+1gKCim536ppdTwC9ylRgQgKESHSKmjHDn7KJEUsZOCZctmOFMA3/paGwFfkQ2qAiwPmBlixpLRZde0Ohqz0FDaOk0neflcJ2qDW6WdgRV/fyr3XA1K4kgeCppkO2Hjff0LCELGglNmaruAKODPT6deOQa44gewDkMW573JqDYYQp9nbMOxLoeyu4xo8JX5Xt4SI58MSLXVUFyCuPBJ++ON+dtqBFgWB+iWFskuTr9+gTSSrSqXWmkZ+RI4F2zFH00MfumlVr+ZCepPbgYeNPoZSgYEZ0VYAQJMV42Nftetd0lij4fGgMWu3Mf2HSiU7nfICvbkQzsWjuaKr+QnlMJhBV3dpacJlvMNudvC/qr8GGK6TWDYAwNFLlq+D6sF3UX6POM1OyA0J/hf845/1oJyE+zbiaB5Bcb36HXmtXtJOG4JpeWsiuMBJF/NENl8clic9j8mGF1RMAUahWyXWmQRCc9ynuRvBweuxLIcUKoeGbeq3rhUpijqOkvnBySAF4lX/3XrMREQGViN6W8GqOQLl0wyq0v7tDsLnmQZMwSguZsBzFWoSN/5G3D2GoCg70ayD+dbZkxywFWxuFTosuJlaelBJ+njXTQ1Lh8s7D7ix0uo8Rf7L1i+DgelmGeSy/uVmgJJpK5wvk30QLXC8gIgAAnrB4pPriyb3Jaytc1rcYbk2kSqIHO+8QTBR2ZsYWI1YaLerNsOimWWC3HEkzOPb22+8nMFA
 F7qjHfbZ
 +veeGY8/A11l6ZraJbpWUdXVu6KOQjou1grrbqcGEeEM18bGR2n0CXCZP+mWwI75tt6zMQCfSsMqK336W5kkBFLS8XPsINg1itf+nzV9ghEdOXVjR7Bu29ohvAFuVPSNmeqFaK/6ls75P4tHq2xPM16LgR6xnXte295mJXi4EVuDUwbn0kKdYXEtFXlh1eIkdoq5MCj/Wk/54q4gVcMedak1tCBlkL7ZSEEeLt4PuKc8R1uiuQhanC8JW+q0Y6ZiSIbwpqDowQ7nu4AweNTkSuGvRHpweVobldvyc9Ai9Hf+4AnlCu+nD/m7TmViwij2MMOe5kYE4W7K4Ko/fLBM5I0vHCRt+IDFkYp8A9N2Wb6tWhTn+vcGUYJ8LVW251xJyEyReF6P0KpCAQ/dL2RZqoL3L2+nLPx9ZVF0dfLUghpH473NxYg76lZZtKQPvB3ieLpauyxCokZJfYwWOBAIuSkBnogFhD3wgBPlgLSr3JNszWEuxyJKvH6hDSXixrYiklCDpuwmj6a8qt1PjRugZjDK3f0X1lKtgyhbZlmNdUqdIaRfAVogDfl6QzIvWJP/JHzcDpElTD3N5pBE=
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



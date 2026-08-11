Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E120C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5346B00A0; Tue, 11 Aug 2026 07:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D226B00A1; Tue, 11 Aug 2026 07:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E396B00A2; Tue, 11 Aug 2026 07:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 968AE6B00A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29F41120434
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:57 +0000 (UTC)
X-FDA: 85088751594.28.0AD581D
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 636D31A0010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lCWH0V6+;
	spf=pass (imf19.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Ekcm9Or7cb8hAHyaAjXHw9qfIL5BM5+FlcvqMKj+G4=;
	b=774GUukadiVeydliurhN13e1Ub8V90aNLWRxkjYSmv9TIOwatjeeWC/7z6SI/yLXbAXdgg
	oZ/6wRPPhG3JEjDhCR6VeHSyYsz6YsmLXZGT24UoCPHyTp946v6heuzcPVPBzKL7bxInoj
	GXufC5Dsh42gI8WScgvNEv/2ZKuf8Sc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lCWH0V6+;
	spf=pass (imf19.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447375;
	b=Aka60/Kwjf2pGY/vCF82Ic1O00OjqKUvjWTei+wB3DnLLlxHME4RnY+AY4sDDrSN5x40M7
	bQXBNmwTDaGFIbg6o1wvABh6sc773Q0MoPQbxdshDjU6WSqh0G2aKvJXS9ORifEH8NQIN5
	1rXH+xz6y8ERbpzN58dOk7Wjr6RpjPU=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so22828895e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447374; x=1787052174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Ekcm9Or7cb8hAHyaAjXHw9qfIL5BM5+FlcvqMKj+G4=;
        b=lCWH0V6+o/Kbf3PxezxiR2+X03tNCX/mrlmXaJTc0P0Fr2OYc9Vh1Jn1f77jpDeLwk
         Ik15Ts/mG82KCeCfsMPGBAqC7d5WWuhYsoS+SXoSj8ZZOMnAywlsdh1Sir92SgSgYAAA
         pbx8wCjLiY6NHoOmodvVLC/BzhMKlqkv23ZuUam2CTZhqZxlohBABk2ukxPEvLgp9KvU
         zv57mM2WwtqAKp9NIEOaSkLBnSuF0zLi88tt/lW67zj4hwn4GU3q43mRIBVAEKquNUYj
         AJnezbTjfpSkEoBh/aZYM9hq5D3UwFy2krWn+iu00EgyznnMbzWgad8DWnEPfIrwQFoV
         jS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447374; x=1787052174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Ekcm9Or7cb8hAHyaAjXHw9qfIL5BM5+FlcvqMKj+G4=;
        b=ZFGp9UbpV3eyuRGimjIItB0in7uutmvV8SsDGIJFcQ0fozzON9VhEJF4pfdTLTP358
         jvyRhISXkk4JE75TN8Sc46nTHvUgqU8IzbQC/xi85QHE2XpzkgY901HBd4k6Dglx3+az
         tsIRTPs5bsepRatTn1fSObjSEU65RxIHZtSs1J8kJTdwq5vytQnx3Cuqz4TS7Zu+8h4A
         EbMXJ5BYeW/aGa52NQM4fTT3d0oVHB91FkEYIlE9hPXad0cjAa/fFufVNme+MQf18zta
         um0rveVswwdONOxJWMZzHmD5OcjRbeam5qoprwLPWMlZ98UKN6t6v/0oJSvpHs0RstCv
         LhMw==
X-Forwarded-Encrypted: i=1; AHgh+RrCgsl6POUtzs6Fsj62aanDeqQ3I2RHDgwae2CJQKaBV5di6KLMUPH9Ky7oaZNakWRG44gszQXfRA==@kvack.org
X-Gm-Message-State: AOJu0Yxh8zIMgapHMc15yF89kVcT2U0keSg7FUOVLUkiLu4RI1sq/HyU
	iYgbM99/ZHvILhdPsB6zMPamoayrOsG/FBBA6TOwJW896vGfmuMj/Bc3
X-Gm-Gg: AR+sD12GorEYHTfD5XRWgKeANjHYjxlC0uSkXTZE4M1z06bYOXT3+6DjnGjMOIjlHcq
	86uMJbcbZukxEfwaoqOyx5/q7fmZH6NrTFj3eDwscPVZrlVxYo38Vkh8nWlAwkwZAYDWyFU4KR6
	dF1cdrPvBmZnvAoMPA3t2pNGjcXBFBHimN1wFxyKczTkPbjwjgTElQJUEFvPEfYefe6uehna5N5
	0s/xLpL60gwJtbWc88YZN+XatNYh/+59lO4IR5rRUFD8K2XCQ800m2ShChZ5smFJGX1F1l5L/uZ
	jIRI7f7U2SK1n8hoyGU/+APsCaNxQvqhma3LO9dM/afk2tDlAwWNbfGUof/S1tQ1RLFJ+99949Z
	6h0dEO0+QcIJSAmhDR4heQo9jIrh5zxxSuMMwCEMt1jpbf1DLAXFVuTIWDmxnMjeG9Vg7gEWoX/
	DwXUZWzRgFmiBeVZRdy/RqRltqInL6KrZ2jum7Vnu3MT/CjTFqA1WcMgBnPn18dvxVzxZAHF9WN
	01c
X-Received: by 2002:a05:600c:34d3:b0:499:6eac:36d2 with SMTP id 5b1f17b1804b1-4997846d9c5mr44664915e9.17.1786447373789;
        Tue, 11 Aug 2026 04:22:53 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:53 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Tue, 11 Aug 2026 14:21:54 +0300
Message-ID: <20260811112154.94053-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 636D31A0010
X-Stat-Signature: xw8rk5x8w3ucaytdnny648cz1tbnrncg
X-HE-Tag: 1786447375-811807
X-HE-Meta: U2FsdGVkX19eAV6dxkBqtEFlDUfLsMV9RzJRiwqp09pKJP9e3lfzbFhUUUF1m2IgKK7D9WdENK0T8A9sFE2zagMjKCPkgaItWe7gqjYKFjrKL5KT6Jya14KoNsIvpMAHYMZuUgwfDjmYALS3CFUWFXBex9Sx2wcjqkwjkMlxKTyAxNNbjnFCSQS5EAR8mgJnzR9rwXUQiM0V6FuuEFV5KebtIwCUtoZ5wMKdgF5fLU3tqsXb0Fzs8yh90cQdeSHwgh9C9gIkAR1L4gUcupw9zYZ1j6MfRHP3Ww3p1uhUe2YU8r5uJ/N+R1fCZHGVOmGcj7zFy8l70nOLbnwxSxfJvsaev/NWGwRq8IXEkCP2iRRsIuECYLf0Irj2iaWuvthKbHKhTXAt+cjmRbcTysq0xKjtEpm6VMdeg4mluC5g0E44KcQKk5k3jQjUGptA8B++cB0PKZ0E3Cph6fnZUQUu751rV1UOQUtqwV9XvQLdDdUfFZLOPYinH5vfhMtYDp/nICClw0iylBI0Smjxl8NFlriWqN+78sAq/8ReesX1fHtnMCOQtgF8I07ANK0nePo0lVDn0mjwwoR9QUZ1rcjwpvde1mp42TkTWTOtMPT7lFy+BDKotMr1yu0wfbX/R3jk/FeUd4ZgIv6JH0Qr0dVEJa/dL7tfmzGYg3HsZ5c6FNCunc/2NG3E77iwEujFV3+h8lDY8JyUd/MUk3QXrkgyUHoee5KUE++15cKZb3Ej3T2y7JtKotX9PKLBp1Ck1bju8E52tqYwHnymo11ynfwV+FhMnfylNPZdiKcomi1xwrRyvAPNNh5S45pgo83ikgFX+sc2/CXWRBk1faKZfauoGaytVOPzxr5MtZIF3fIHTmZW3fSc1oNX5pRLQfM3AxNUhD8uRXbWNbYaTCZDdXhXyFfBqi3yXnyX4Le6jIFw1AaFCvHp8fm1KNX5zRnsZaoGRg3iEkoeWzaD95y9rwr
 3v3+eT9B
 GnX7f6c2fZ2pvNZwFxoG0KILBlhn31PVt2g+PrZ/6RSDy1Qek01/+ap5EHkXsUa19AbU8qr5aQPtN51KtAQo34tck3Ev3fE9ESnXn4ogrEJQzXcfPPQF9Ap8b8j1GGUeKhoSRSGWpu0gYiG4otE73s5LVPOHPXLIFr5ej8wgemMEHcwSRwJ2vJP73fqQ0TJFqYVRkDXUdC42EFt2nJW8WamDQlqae7cnnf9EE3NRnkH2DG7d63EWoUNslElHzbUGDY8Iao8Nbc2UyJ3ZozaP7cLEZ4H0ftQcwLphhYiOCuAMBIKKeA/Dh6gq/5HsNafVsTjKktHS2REGA2VSTdGm9jYKNHkeXYHCQWHFP4Xb/zfl80vzVsJJdsqxiAPn5MwqS5bkcpiYX5hV94n3TCe1xCPUljQ6+LDUelsw2+eJsN7AUFl2LY58+yKReLZPWaFq1FIip8hUKFl6KovKDmwgmKvwnQ9TaPTpd9OUCFO8Iv2Yh89WbIeQkEAqIlzfFoA56IdDSafmVnYPpsdNuGQiuFWJhYCYcM5jmOP6snRtp69KjOLI1mN9Jc2FHAvlCDBnPMd8lZ3qKToLlF5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF LSM program attached to bprm_check_security to test
bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() using the trusted
mm_struct from linux_binprm.

After checking bprm->mm for NULL, start at bprm->p and verify that
bpf_copy_from_user_mm() can copy the contiguous NUL-separated argument
data. Then use bpf_copy_from_user_mm_str() to read each argument separately
by advancing the offset based on the returned length. Also verify that
bpf_copy_from_user_mm() rejects unsupported flags.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      | 52 +++++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 77 +++++++++++++++++++
 2 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..3d5080a3975e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,52 @@
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
+		char *const argv[] = { "first", "second-argument", NULL };
+
+		skel->bss->monitored_pid = getpid();
+		execv("/bin/true", argv);
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
+	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
+	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
+	ASSERT_EQ(skel->bss->str_arg0_ret, 6, "str_arg0_ret");
+	ASSERT_EQ(skel->bss->str_arg1_ret, 16, "str_arg1_ret");
+	ASSERT_EQ(skel->bss->args_match, 1, "args_match");
+	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
+
+out:
+	copy_from_user_bprm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
new file mode 100644
index 000000000000..d7132bca6edc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+static const char expected_args[] = "first\0second-argument";
+static const char expected_arg0[] = "first";
+static const char expected_arg1[] = "second-argument";
+
+int monitored_pid;
+int bprm_argc;
+int invalid_flags_ret;
+int copy_ret;
+int str_arg0_ret;
+int str_arg1_ret;
+int args_match;
+int str_args_match;
+
+extern int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				const void *unsafe_ptr__ign,
+				struct mm_struct *mm, u64 flags) __ksym;
+
+extern int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+				    const void *unsafe_ptr__ign,
+				    struct mm_struct *mm, u64 flags) __ksym;
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm, int ret)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	struct mm_struct *mm;
+	char args[sizeof(expected_args)];
+	char arg0[32];
+	char arg1[32];
+
+	if (ret || pid != monitored_pid)
+		return ret;
+
+	mm = bprm->mm;
+	if (!mm)
+		return 0;
+
+	bprm_argc = bprm->argc;
+
+	invalid_flags_ret = bpf_copy_from_user_mm(args, sizeof(args),
+						  (void *)bprm->p, mm, 1);
+
+	copy_ret = bpf_copy_from_user_mm(args, sizeof(args),
+					 (void *)bprm->p, mm, 0);
+	if (copy_ret)
+		return 0;
+
+	args_match = !__builtin_memcmp(args, expected_args, sizeof(expected_args));
+
+	str_arg0_ret = bpf_copy_from_user_mm_str(arg0, sizeof(arg0),
+						 (void *)bprm->p, mm,
+						 BPF_F_PAD_ZEROS);
+	if (str_arg0_ret != sizeof(expected_arg0))
+		return 0;
+
+	str_arg1_ret = bpf_copy_from_user_mm_str(arg1, sizeof(arg1),
+						 (void *)(bprm->p + str_arg0_ret),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_arg1_ret != sizeof(expected_arg1))
+		return 0;
+
+	str_args_match = !__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
+			!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
+
+	return args_match && str_args_match ? -EPERM : 0;
+}
-- 
2.55.0



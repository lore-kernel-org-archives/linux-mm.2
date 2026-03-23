Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B106F483E0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41FE6B0098; Mon, 23 Mar 2026 13:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB8D6B0099; Mon, 23 Mar 2026 13:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994106B009B; Mon, 23 Mar 2026 13:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D49D6B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 357481A0C4A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:10 +0000 (UTC)
X-FDA: 84578076660.09.75E918E
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7389B40008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+EmLGGK;
	spf=pass (imf12.hostedemail.com: domain of 3P37BaQYKCJY0L068D6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--avagin.bounces.google.com designates 209.85.210.73 as permitted sender) smtp.mailfrom=3P37BaQYKCJY0L068D6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vz01D+Qvtpuy+jqrKUW1E7zaDqaJMt9I2Ue5ziSPeb0=;
	b=WFAEiLrD41yhAS/RfWNE56wr8N8IxyjYxVYZ+ALpvDz0yxkMoHkHIGMwklWjwAz3W0PV5e
	pE32u3Qp3iyrC6sFsSYlOFuALP6wBk5Dq808o/hk2XiY6F8ztm7LgPfgeNZSLtYOBl6f8M
	mKUWPuY2P7TjPbeNhA181SQ+gj/sUGg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+EmLGGK;
	spf=pass (imf12.hostedemail.com: domain of 3P37BaQYKCJY0L068D6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--avagin.bounces.google.com designates 209.85.210.73 as permitted sender) smtp.mailfrom=3P37BaQYKCJY0L068D6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288448; a=rsa-sha256;
	cv=none;
	b=Icrn701F7FMzb3paLTiCPNfHaRxzuurS8BWNr6lOffflBvMUhXMEBgEqIMoEyyFHSi99qF
	3Lf8HEhat/BfQUsh0Kb6HJxK/5Pg4LmnMPNsSuNhlecn1o9TFrKPDfD20lhfe8LtK2smp2
	ZC1SzHU+KkklalfgJZy23UaJg0ek7DE=
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d7423ac71cso13357772a34.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288447; x=1774893247; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vz01D+Qvtpuy+jqrKUW1E7zaDqaJMt9I2Ue5ziSPeb0=;
        b=N+EmLGGKRJK1pTpGLQ3NTFt/e25i1wsM8yRrBr57eyFf6ctCDSKztkjRQWzzweaVDj
         Slac6X3gOXyl8kVq+689sHSmGvcXc4yqW2wbAfltbkuDWg2tYbvADHfLDMLbPAfGhgGX
         X+Zo8L9hCBGgvqDOZA1W93SRPiWFSg8Q1/X2qSjqnfh2f2L0+J/32z+LuF1GfhcyBGyM
         zJND3/GztdoycEvZDENuXYo0vhGQnDZmLog0jGQBSbrWgC+AjtzmzMOB6PeHBauOMQM0
         maEsQmhslgwVoj5nTyZ86tkaM+WdK8cla6gEoFWeW8cIiwDSfVQzMZkXFivKOLEQuhsL
         TD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288447; x=1774893247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vz01D+Qvtpuy+jqrKUW1E7zaDqaJMt9I2Ue5ziSPeb0=;
        b=JlWSqX8lFHewZQ+CSmbLNbe65JSymhvmLlMyCFwv8yH6uYEuj1g5vtaZFNV2Y5biZx
         MY3w1PD7efglTT5r+f0wO/VF/jdNrudBm5RC6bkVxV0Y4BL2IhEQayNwvMIBeqNJG5GN
         TfjdyA+nOjrNQ6aCJePow8CCySvsaYjNqGbRl4+9SQeSO5L96mPGPfCh0f4gVrdx4Pc/
         A5nyhcIFjiBqgopqw2xKf8C2bYhjL9gCu2F8OFq7vPMCSzvPIn7W8KSyUUUNXPoAroRN
         NkYbTRjC6n7Qz/+/P7KtFrI8xRpfKysV28hYq2s9BKHYOE48p1rm7DzIbUNZb6V0p+TN
         C/Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUFoMr2gCtahSqZCI8OxTLBgz4WDLRfPCxzOMOabdonYWTn0fO+nf/V4UVFXFinur5aJWABVTPv1A==@kvack.org
X-Gm-Message-State: AOJu0Yy95Ie0/Y5VGag5wg8Im3FXrhT8HDc0tqgjwX1EtYf9e9SbRLPD
	NdzoeqP/fEOo4OsDIM8+ZMD94JMGAv8tBkH/f9IRILTgXCetNMAQyDwoi4CTql8s5IEc5ln5Avx
	UGqM+Hg==
X-Received: from jalw26.prod.google.com ([2002:a05:6638:379a:b0:5d4:6a6a:67ca])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:200e:b0:67d:eeb7:476f
 with SMTP id 006d021491bc7-67deeb74d00mr2420094eaf.0.1774288447326; Mon, 23
 Mar 2026 10:54:07 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:40 +0000
In-Reply-To: <20260323175340.3361311-1-avagin@google.com>
Mime-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323175340.3361311-5-avagin@google.com>
Subject: [PATCH 4/4] selftests/exec: add test for HWCAP inheritance
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7389B40008
X-Stat-Signature: apk78r1s44eepjwsn7taz6jphqztkw9y
X-Rspamd-Server: rspam06
X-HE-Tag: 1774288448-424575
X-HE-Meta: U2FsdGVkX18+jJO0YlNCqc/hj/X6lLHsfN+J13VUo77AKMx6c2FsQfFos1Md/dr6eqggsQLNNkErkXn/9S/tOgHqmI2RTXsh3pNyJFSACz8X8z7P9/ZyFUSAywE1g2fHhfHqEcKcN7c+IAnZgoE3IxujscoYfhjyL7aWL1dnQCWNNrf/5p3Tb4ge+RTfurIYnsnWOXizLvd+IqQAsQQ/SgdvN79eRbf76+Tb/ZD5Bu6isUBk+ztVQvdzExpjb5Dv0Yf1Izpm7fiyykY8t5R6s/j0WH8cLs2+vsuNSYkv/Z6TGmMelHw/vn0/iwnq83/X+ldmDipjZ+t5chfmqQxML7eCheb/XFIRL5NHtNUXGnkpA8G/Ffhq4NUqq8sDoHnqJ10sjmJjZFDjlGpGq8VCnB7GNZz/G2CWi0iX3dcUECMMFwnCGSQX+hjeIx9GK20I3NjgjYGtfZj+HZwnCEQaZWKRMS7pVMyX84i8olRcxc0Y+bz2z1mDfXidC6yzNsw4qO9tiH69bcwGSn1Qtwb+BVaj1SzNEiDbdrnJfmSGTCY5ZKZzUSO1v0MUfN7qjlOM+Jo0xYhf/qPQGL84UaXx8iwnUmGKq/3IhQEmjlukX9nvqc7US+K16XwiL/UVWPO8bxVo08bqixRMmSJV1jpVRoswpMi/jyA7opiKy7SlNaKi3u84YCxmy3ktONHEaeWR5LKwlNOlYi+Ebuz7CSdBfF/VvkGlIQ5AURT0uun5xGnVyIrBRJc3jV07rUEum4w1ixn2UihGSID6dIaZtrIvICMTybY6aOX7iQgyIkQnqGRNrEiQlGVpODG7bs1XI8xw2ZvPGhRQsRe1JdKx4ELKmXRDAliNW7iRRrwWmGycmM8z0tyFvfkttowQBvYWZ00eWuyA7yXHbCqq3n7OzZ/k1Soxo+86hts4mWdnm/vkjPpOvyVUhrk9pN1JxFySbdUU9aA19zg5TIul2njqMEP
 ZMudxGmR
 GoF2r/919vkRHp29PCDSaDvu05ELiXoQM8OBBQ6tnt4RunDCbEbuu7KI7QUhSBiymgl11mStxQNfIiaaRC0q2CsnmiUtTpL8EiTW8T//mbplZBXa+9NKyhw7zPWbNGPsil5bcB0uGEMkJ68GkKhYEctgeTBSTp3XkUte0ul+P+KuLQGdBpROF129edG0fPOyL1oNN85cjX7HSCI3FG4pSeoOatQrGq3KNLBqSPokNWgtv+uoNkFLg1GLwQz6oApLqJMkPg1ECl2+heVENpIjH5CZtgL3ir+fTRRrYs89ejUA1iF+WABDYxb/rGZ0NtF7d5JDPYmG2exOeAmb+DWEQPCoclJ0Hx3uLQk4PwyiA65yfqVcIZNJ+U24EM/yE9ueffODM28rMopHpWMZC5MqvS4+KKdGCZ/lDdPGZ6NHl+oDhRb24J7guKOTugTaaqRlzyXakD36aSaIB9S5bHH/Rk4PhIdZTrJeXgaxbQtyrdyhDA+aA2gV79Ud3XV5Dn5iAgm+jPaIsTUwPPFB8LsbDwHeCp3v3xWA68rUVbgdMTJADFK3zRLDo2Rzk3DGO4s3/CCZGooVMQvxwaZg1fe4zacnIdZNaQLzSh/CxAKKXQT6GG2pSuTx17m7iyfZrsYuWaeGbZIzivR9nDbfO5fFwm8CFRYqTXv41+DIziyDRVVpR0W8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that HWCAPs are correctly inherited/preserved across execve() when
modified via prctl(PR_SET_MM_AUXV).

The test performs the following steps:
* reads the current AUXV using prctl(PR_GET_AUXV);
* finds an HWCAP entry and toggles its most significant bit;
* replaces the AUXV of the current process with the modified one using
  prctl(PR_SET_MM, PR_SET_MM_AUXV);
* executes itself to verify that the new program sees the modified HWCAP
  value.

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 105 +++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 7f3d1ae762ec..2ff245fd0ba6 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -19,3 +19,4 @@ null-argv
 xxxxxxxx*
 pipe
 S_I*.test
+hwcap_inherit
\ No newline at end of file
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..e73005965e05 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -20,6 +20,7 @@ TEST_FILES := Makefile
 TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
+TEST_GEN_PROGS += hwcap_inherit
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
diff --git a/tools/testing/selftests/exec/hwcap_inherit.c b/tools/testing/selftests/exec/hwcap_inherit.c
new file mode 100644
index 000000000000..1b43b2dbb1d0
--- /dev/null
+++ b/tools/testing/selftests/exec/hwcap_inherit.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <sys/auxv.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <linux/prctl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <elf.h>
+#include <linux/auxvec.h>
+
+#include "../kselftest.h"
+
+static int find_msb(unsigned long v)
+{
+	return sizeof(v)*8 - __builtin_clzl(v) - 1;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long auxv[1024], hwcap, new_hwcap, hwcap_idx;
+	int size, hwcap_type = 0, hwcap_feature, count, status;
+	char hwcap_str[32], hwcap_type_str[32];
+	pid_t pid;
+
+	if (argc > 1 && strcmp(argv[1], "verify") == 0) {
+		unsigned long type = strtoul(argv[2], NULL, 16);
+		unsigned long expected = strtoul(argv[3], NULL, 16);
+		unsigned long hwcap = getauxval(type);
+
+		if (hwcap != expected) {
+			ksft_print_msg("HWCAP mismatch: type %lx, expected %lx, got %lx\n",
+					type, expected, hwcap);
+			return 1;
+		}
+		ksft_print_msg("HWCAP matched: %lx\n", hwcap);
+		return 0;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	size = prctl(PR_GET_AUXV, auxv, sizeof(auxv), 0, 0);
+	if (size == -1)
+		ksft_exit_fail_perror("prctl(PR_GET_AUXV)");
+
+	count = size / sizeof(unsigned long);
+
+	/* Find the "latest" feature and try to mask it out. */
+	for (int i = 0; i < count - 1; i += 2) {
+		hwcap = auxv[i + 1];
+		if (hwcap == 0)
+			continue;
+		switch (auxv[i]) {
+		case AT_HWCAP4:
+		case AT_HWCAP3:
+		case AT_HWCAP2:
+		case AT_HWCAP:
+			hwcap_type = auxv[i];
+			hwcap_feature = find_msb(hwcap);
+			hwcap_idx = i + 1;
+			break;
+		default:
+			continue;
+		}
+	}
+	if (hwcap_type == 0)
+		ksft_exit_skip("No features found, skipping test\n");
+	hwcap = auxv[hwcap_idx];
+	new_hwcap = hwcap ^ (1UL << hwcap_feature);
+	auxv[hwcap_idx] = new_hwcap;
+
+	if (prctl(PR_SET_MM, PR_SET_MM_AUXV, auxv, size, 0) < 0) {
+		if (errno == EPERM)
+			ksft_exit_skip("prctl(PR_SET_MM_AUXV) requires CAP_SYS_RESOURCE\n");
+		ksft_exit_fail_perror("prctl(PR_SET_MM_AUXV)");
+	}
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (pid == 0) {
+		char *new_argv[] = { argv[0], "verify", hwcap_type_str, hwcap_str, NULL };
+
+		snprintf(hwcap_str, sizeof(hwcap_str), "%lx", new_hwcap);
+		snprintf(hwcap_type_str, sizeof(hwcap_type_str), "%x", hwcap_type);
+
+		execv(argv[0], new_argv);
+		perror("execv");
+		exit(1);
+	}
+
+	if (waitpid(pid, &status, 0) == -1)
+		ksft_exit_fail_perror("waitpid");
+	if (status != 0)
+		ksft_exit_fail_msg("HWCAP inheritance failed (status %d)\n", status);
+
+	ksft_test_result_pass("HWCAP inheritance succeeded\n");
+	ksft_exit_pass();
+	return 0;
+}
-- 
2.53.0.983.g0bb29b3bc5-goog



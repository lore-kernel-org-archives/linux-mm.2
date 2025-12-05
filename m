Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEDAD2CDF5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6949A6B00D6; Thu,  4 Dec 2025 19:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644C86B00DB; Thu,  4 Dec 2025 19:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5341C6B00DD; Thu,  4 Dec 2025 19:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8426B00D6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:58:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E07A01A03E8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:50 +0000 (UTC)
X-FDA: 84183607620.21.8B7C621
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20688180007
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iox/LpKk";
	spf=pass (imf24.hostedemail.com: domain of 3SC4yaQYKCL0dydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3SC4yaQYKCL0dydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6yuyWg6J+6tRA6+qXQKoG2t2/jCR8bZmCcJlfiuOoE=;
	b=yXBZL/RjEeSP82YBuX1Axv2vt6zyxLb2nd6yS9RIXDXFZh+oyLICodootSxEVjHpI7c/lS
	EhyWSYhTDuzXvZYy0qE8hG4MofBRZGDEEQ+kCBQTNRVFpaqiWHB7kVykPJMDWJ6yzVtleF
	+CFFS7kjSmPVp41XYImCcWyiE2VKBZ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iox/LpKk";
	spf=pass (imf24.hostedemail.com: domain of 3SC4yaQYKCL0dydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3SC4yaQYKCL0dydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896329; a=rsa-sha256;
	cv=none;
	b=kIRbY3wx9BU5Gv4P0Rgn1J4ho9l1vY5Qp1ilRbwJ254ejn7E7G6Npayi+0KwCa4xGGZZuk
	rBXIzOSI0x0Is4MNtdnE1apO5BEJYju2A2RwXIZbmB7HJB4R0lI0z16c+Gq/8OkZXcC/nv
	y2U6CMyff0fKUB1kxD4StCqL9C/MF9g=
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-453799e65bbso514442b6e.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764896328; x=1765501128; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6yuyWg6J+6tRA6+qXQKoG2t2/jCR8bZmCcJlfiuOoE=;
        b=iox/LpKk4n/zkL6vdw4Yp1uM/69Dy/HzjT2/A7gPBcWf6aeX462w4aee5KqHQO0jwA
         4KQ24okVW7zpUy6ctuj8Sf/zsG2L148pbWd3+6o3chW3dwLcOSfkEMg4DlV0davSaAH/
         hCSFzhIiTMkwKUCmy3c13YlBjxTZNa0XwGPaO7WBULEvrO3cUwEpnoQeSMLZQhco3vza
         xP/7/qXxSVADDPFcFtjBA2bqPwmlzzOhqwfuCFclrWDM1Ze3XCSxJSFbltYoNE3FjxVV
         E1RNOZAYdWUrHtAn9gBCp04uBU9qJ0fTjSiLIZOXQAU/vVoxRPt5MPafZdwL9FhXGfQm
         Du3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896328; x=1765501128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6yuyWg6J+6tRA6+qXQKoG2t2/jCR8bZmCcJlfiuOoE=;
        b=b50UUDSLEoVMD1kylvYBwkE6H/9vgVxj5tqsJdrOkyvc9nut3qX9VkiBK1KyUKPBhT
         CTKyIzkfTHDXAVta2/BPhgOARo6naXgmmRyd0+b58bO1/sWv7XHxa8b2otWO8UwbdcKW
         m/jfbfwrn1NijSqEgIUydEkAznopX/TvURYBPBMji+psGvYu+JHz7DyA2H4i/XN2K5qy
         C+lkZPXbwPsQ7Dt/FewwysVLQj87WAjAJIR6HqjXF7pn4oEG6SsjZOkAKF9F1uQutgfu
         PT/GNo39TYV0GGs3AldZ896unhmkaYxvmmC7K2cTXnrI++ber070v79qZtpP61pDQPOZ
         sZ3g==
X-Forwarded-Encrypted: i=1; AJvYcCXaQNFUHTHmU050zEpwUCvlo1CNAfGMy+VVvMRqcVCH3jV+WeEaLXbRPspSGhiyus900I0sOsPgew==@kvack.org
X-Gm-Message-State: AOJu0Yyxp3w90veaPo2i05JsYQw2XGf5CbmQEPHE0HVIgzZOrqHjQMP6
	31//mGjRSYgNh5IZwfCtWSLGoIpqhjpUXNu5H3kxMJQQ6pJUCk2A7CVNnuJlaONZ3xLMW0fSuZO
	BGqlelw==
X-Google-Smtp-Source: AGHT+IFADxKy/vFest5snAc0m/D0WWFhbz7XE0sMmrJDgeiYPmoKVCscGluChmmNgyVRHEbkPAnHLRJv63w=
X-Received: from ioxv4.prod.google.com ([2002:a05:6602:584:b0:948:a326:e2d6])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:1899:b0:450:d09a:8ce7
 with SMTP id 5614622812f47-45379cc4f26mr2830491b6e.20.1764896328239; Thu, 04
 Dec 2025 16:58:48 -0800 (PST)
Date: Fri,  5 Dec 2025 00:58:31 +0000
In-Reply-To: <20251205005841.3942668-1-avagin@google.com>
Mime-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205005841.3942668-4-avagin@google.com>
Subject: [PATCH 2/3] selftests/cgroup: Add a test for the misc.mask cgroup interface
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 20688180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hs793kktyuga1in3f8kr4rta7aewtuyb
X-HE-Tag: 1764896328-649335
X-HE-Meta: U2FsdGVkX190Ce9iWjfDm3azpgursu+dlX5hVGLhar+A9vITmUU4kIal5RRAeqgpTLasHPzbpbms7QfM95RM1Xj59CGzB3L1GWIwpzT+CcLDgcBJ6aQ8DQzO/3UKyOjSZoaNEhtCMgJcp/P9jpT183B9ZNMjA0iodH8kqzWNSkS/DwnMHylO0lG6hnwWJv8HhsRmyAsW6rCvZPHN8bdWlO1vuH2/NXBp99SUVkxUI1N2odfp1cd9r6d/JKNz6mHKpTUE4MnOmEqEsSKmriCRciZfZHw2FC9BmkLcR3u+xg7fmMjGT1zoOwBKvvOPIVwATRiJGlB/ityVgRtTMW+Uqw72+LJq3CEPk02PhN0qQuDrpQn9QLiNxkxJEHuFhqrwh/LSKRHg1Pv+i5JGXHBLL6w3HSnuSaZBYR29h/zqNj4kbXF6ravZoVQaLac0ORnyTGTESKm6r+p+vZdTuLhcrnBHl5K0g7aOtSfoAf6qG4g4eJ9YsuIPC1eyr/Cyq2NwZefbTORfzrl5RxfmuOlfYfz//5SO7IhIp5B5c0S/VvR5/llafiFHwGXSawUblDcinoVIJ5glcSaLl34fWpnp4oB0SiBTMMwWHc01dTH/EZP75IEhIe8ZenJFH+pzOQ+XRTSlaYP4SpsT/gR3pXWHVh3HiDhwW50mG346YEp8qI6H6sBj+kd8Vma5R0xuIbZL1P5JQfvTl76vIAkcYR/aamVGbuCr+4b6B9P+VI+qnpxUBd3kiatJXqkKm2VWkaieXZhYoW1eu/yk0ibHPmQd4NErZeUHzsPobcakqUREY+NnjtA+xKGnIO2sUJoD+13es06ed+5Rage8lTBHh8QPjbnnIeUFzO9BMZcyAlMciAfiO9HLcHCVIbeW6NXZaA7Rk43y7HAKTDRpV6IZG5f2AcFjRTE6c9pUTcP7/uCft9yH7y90TkkLpS7nrP9+/WfaEIFL+/ktPK5iJ3ZdUvl
 GBwT1khh
 Ibib92qqCIcu5sWNazyBQO7iyKkLzCW5pCHhv6bO+nzUhkQPnd7stVfH69jqofU4w8qIBolRqG2DKZP83nOVueDYOvCHlGufrTenqjBLjv1hVUQXeY5xhGmwawuDyqOFTIzMLvs+O2b46M7wL4TtWAKKci3MDLOzaq16RykArq2KdUrgp3WmRmtVSi7o1Y50+gro1jZ2OLm3AlVJZmoJaYn1/ReaskDyXhI5k4BcbTGiBPJKGTdx0lJu+rWlhQ3AzK/0fdRRMAIMHHZaKOZrMiKrNNdFfeJIUZQ3WeSqWe+S01NffxGMD8m3sQ05OcIDXrQh1Qsj5HP3aL6r5I9xgc4PoC5rJIhWt+xLD/R6H7zf/C01HHUFEo7WWCmkYeHrcQDsW+cj/XWOB1AouR5K7XangBAHM3WBEpCdcQiFrj1ulvGVIVTM5TJhz8We7BGb/+L3UELOCXM4PhYR0NRBG2XyFw52IrL0VBLI/R+51bBtMO8hHXIU1rW4NdG76IMJ8MTEuLZnY762ec82VwgIiFCsP2s8uE7mOzffHEf9iC/WhFSo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest for the misc.mask cgroup interface. The test verifies
that the misc.mask file is present and has the correct default value,
that it is possible to write a new mask to the file, and that the mask is
inherited by sub-cgroups.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/cgroup/.gitignore  |   1 +
 tools/testing/selftests/cgroup/Makefile    |   2 +
 tools/testing/selftests/cgroup/config      |   1 +
 tools/testing/selftests/cgroup/test_misc.c | 118 +++++++++++++++++++++
 4 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_misc.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..3ced02a3634b 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -7,6 +7,7 @@ test_hugetlb_memcg
 test_kill
 test_kmem
 test_memcontrol
+test_misc
 test_pids
 test_zswap
 wait_inotify
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..6e9e92f89d8a 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -15,6 +15,7 @@ TEST_GEN_PROGS += test_hugetlb_memcg
 TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_memcontrol
+TEST_GEN_PROGS += test_misc
 TEST_GEN_PROGS += test_pids
 TEST_GEN_PROGS += test_zswap
 
@@ -31,5 +32,6 @@ $(OUTPUT)/test_hugetlb_memcg: $(LIBCGROUP_O)
 $(OUTPUT)/test_kill: $(LIBCGROUP_O)
 $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
+$(OUTPUT)/test_misc: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..9e3d03736f5a 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -1,6 +1,7 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_FREEZER=y
+CONFIG_CGROUP_MISC=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
diff --git a/tools/testing/selftests/cgroup/test_misc.c b/tools/testing/selftests/cgroup/test_misc.c
new file mode 100644
index 000000000000..50e8acb51852
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_misc.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <linux/limits.h>
+#include <signal.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+/*
+ * This test checks that misc.mask works correctly.
+ */
+static int test_misc_mask(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cg_misc, *cg_misc_sub = NULL;
+
+	cg_misc = cg_name(root, "misc_test");
+	if (!cg_misc)
+		goto cleanup;
+
+	cg_misc_sub = cg_name(root, "misc_test/sub");
+	if (!cg_misc_sub)
+		goto cleanup;
+
+	if (cg_create(cg_misc))
+		goto cleanup;
+
+	if (cg_read_strcmp(cg_misc, "misc.mask",
+			   "AT_HWCAP\t0x00000000000000\t0x00000000000000\n"))
+		goto cleanup;
+
+	if (cg_write(cg_misc, "misc.mask", "AT_HWCAP 0xf0000000000000"))
+		goto cleanup;
+
+	if (cg_read_strcmp(cg_misc, "misc.mask",
+			   "AT_HWCAP\t0xf0000000000000\t0xf0000000000000\n"))
+		goto cleanup;
+
+	if (cg_write(cg_misc, "cgroup.subtree_control", "+misc"))
+		goto cleanup;
+
+	if (cg_create(cg_misc_sub))
+		goto cleanup;
+
+	if (cg_read_strcmp(cg_misc_sub, "misc.mask",
+			   "AT_HWCAP\t0x00000000000000\t0xf0000000000000\n"))
+		goto cleanup;
+
+	if (cg_write(cg_misc_sub, "misc.mask", "AT_HWCAP 0x01000000000000"))
+		goto cleanup;
+
+	if (cg_read_strcmp(cg_misc_sub, "misc.mask",
+			   "AT_HWCAP\t0x01000000000000\t0xf1000000000000\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_enter_current(root);
+	cg_destroy(cg_misc_sub);
+	cg_destroy(cg_misc);
+	free(cg_misc);
+	free(cg_misc_sub);
+
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct misc_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_misc_mask),
+};
+#undef T
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	/*
+	 * Check that misc controller is available:
+	 * misc is listed in cgroup.controllers
+	 */
+	if (cg_read_strstr(root, "cgroup.controllers", "misc"))
+		ksft_exit_skip("misc controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "misc"))
+		if (cg_write(root, "cgroup.subtree_control", "+misc"))
+			ksft_exit_skip("Failed to set misc controller\n");
+
+	for (int i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
-- 
2.52.0.223.gf5cc29aaa4-goog



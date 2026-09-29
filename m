Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782A5CA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 23:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AC16B008C; Tue, 29 Sep 2026 19:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900F56B0092; Tue, 29 Sep 2026 19:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2366B0093; Tue, 29 Sep 2026 19:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0696B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:57:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFB6216067A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:20 +0000 (UTC)
X-FDA: 85268463840.08.3289D13
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1A53100006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s2FxMBrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790726239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtKtTVqVp0AnSAdv1oOae1PHu0tHUMPuFhpoRYZR/Qw=;
	b=0SeNlPAW/BcVXPjPhBSL86N3ViTSJ+PlfJVHPCndLzren53FKtkKTdt3Es9Km+eHCMZ53E
	lo1HnhgknQt4RweyhZjz5/Qbs35B3Nm9EN+I4LCwMKMG2VTGKOqa9yy3O9PtImPsfKdInj
	WY2YQ1ERasaKL/zCIAP2vCd9ySm1G6U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s2FxMBrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790726239;
	b=ZvhlIXaPYL7tG9sZ5AH7pBK6s71uHc+FEk/gZQdLkaT2cXqe6/jsQIDCzpCX90B7rfasks
	gbRIQKIDymI8hSLrEKPOzLXj7BdF6+mU+mtnONUF8TKJJwKbzHMcJFgJOOv4Zpt/xHpa/w
	wWE+eqGy8zZ2Z7Jeucc4Z/Wr7jb2sFI=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4aa0f1a94so1667310a12.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790726238; x=1791331038; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LtKtTVqVp0AnSAdv1oOae1PHu0tHUMPuFhpoRYZR/Qw=;
        b=s2FxMBrKjMfiF8CuXjrI57JKdm7/xNB0J0/NxR+qeZOS7AsP1CLlOZZlk6cPcuMgb3
         Vhm6WHEgHWnNEjwgPs6Vai03hc093ZiLneRIT7LkVfqORu7u0AeLHLFurfHoRFcH2pyt
         YJLBis6GALDlT2q/OzUZiv3QUIeGlBazO+V5xeuO+w9PgnjYshGiwUewDmHAQiJWecvL
         NZ2kN5MZBFzqV7M9ZNhd3VRRyCrlg2fF9TFVoAoD9CeyC9xtXvtorFVRnoYYjmB3kW0o
         faXvUl33a3ZU1Q8GKsehHW3Y5Q8RdMflzCCFZTHEdS7l4aYS3wnS+CLkzj+yimDz4PFU
         /0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790726238; x=1791331038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LtKtTVqVp0AnSAdv1oOae1PHu0tHUMPuFhpoRYZR/Qw=;
        b=RwqlrRYUvR92p1HTWrT7pzqI3FVKyJQ3TUHL+fRuhogBC9oZz2uADyy9H/914NuFlT
         2tj9DP3QJ6zvFtxY4j1gWnnzoxigx5fnq7W5aTA1ijzVq+0VLJryUIlyb/UNkq1OTpdF
         D9d9NCxZfBh7IN0NzXYCZQ/BaPV6Q+qC1BeG7cLnyJuU7eXkR6LYqEMnKHg3c7A6DeI6
         1KEmYev4IU5Ji8NMHs8mA/9/+NkZqjRMe183gx21o39Tey7x/pCqOFh5dSKNGohObqw4
         De7JwlYIxNBwfBTyshJG/lQrgavuUb247+vU0TDyahhXEOKQUvg52nNTyh89gjj8+0DU
         JlYw==
X-Gm-Message-State: AFq9FYK4d1n7032VrJ9yBI/WXAJLINIKQ9Aj9DK/cD+h4c0avi/BNur7
	H36iE7kUNG47BbSIn+/ru5z4PBhdiWDr2SghkRDukYWBQFRhVLsm7fdm
X-Gm-Gg: AYBFou1wOddoPiGjw/xLgdMABbFiVbn/HoP+ZFmIAK7O4nBQujtXLopO5UniX8KSsl9
	QTxGmsTVeErvFz9sOTMpNBXY+HZ1biJxLLQTcfvEsRSU4FDLykuRwX7fl7VVWPS+4wDyZtfmDZw
	sOrQdo7U7qYKl8JuXI8fDE6eA871vlxZVUzm8vd6DOPwcG8VHI/Eyc283GvVZBWwPn3OLb1gzrX
	vedehYfMOvJfUx4AZi7nnGycVe0z515h/7MRW8024RpxXMd7IrKPRC5nVKLTgY1mS/+0C7ugBxG
	t692hjAG6uEAsjng1gXTunCbNPlOp3pQ4kvUpHlbt5nddUJrA9XxJqdtty5HqK2LC1gJ8To7UIF
	o9oPVhlUkgqWODLZcjngvBw8ibZb9nyx/xK5aDWYYHnbwCDxAk2SMKgXKmiQ6M3RWfi1s17SCrT
	bULr8Ka1GuQ/RQmsaa8uqx07JuJeJjz6J4Ml36aWH7QciOlnv/YQ04q47NfLywsRqPEqDpBD55i
	mJvVVidqobegsuCPfLM20n0v8og2Duy8KiwmbRsbK55yKlJVo6rJMnvHsUgdtaU7KhVjmgcYnUh
	YSoveb6CSbeZn++4HrFRxjeUA7+Nq6HM1ocbyH4wRprSf0eVdjJecLOmi3uO5Q==
X-Received: by 2002:a17:90b:4aca:b0:39e:345b:3322 with SMTP id 98e67ed59e1d1-3a4bfdea739mr796943a91.23.1790726237759;
        Tue, 29 Sep 2026 16:57:17 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4ca448969sm272031a91.12.2026.09.29.16.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:57:16 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id BFE8016DC6A4; Wed, 30 Sep 2026 08:57:15 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v4 2/2] selftests/nommu: add nommu mmap and mremap behavior tests
Date: Wed, 30 Sep 2026 08:57:11 +0900
Message-ID: <20260929235711.2287931-3-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929235711.2287931-1-thehajime@gmail.com>
References: <20260929235711.2287931-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dbhcjbng1btepdxrzo38nbr37dcwcqze
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F1A53100006
X-HE-Tag: 1790726238-630126
X-HE-Meta: U2FsdGVkX18VJbtJ3ffaUcdddy3qSakPkbdKG0zw+TnckMsPPo1FZ4bswUU4bmRMUkSctXYzhaJc7J3POglEhW+yWHSbNld6+HGntkyUDr7SK3dUv5aoCgjuSiEGCUJFFreBKWpN6Yof26BbbyrLw42wg8FOkNE1qXI1nadWfjCEhqpqzLHsrqdnjTWKbg6nmbGHTpQt2Uh1PMZOYT6flu68/fLK2DxVJk2SXNgHcFVD9QsbLZAoV0aiUQ9haiDJG1V8Hv0AODQQWVLltGUzabJgIxRk9kwVT5+qY6ccKCwADQZqQxP4oIQtdZIRUix7pc0AiKhqEnNtcqrV89VxtQzfKdx6pHOcfwpBtZi4PBYLkjv6IgFViDVMj/hxwh/ZocrZ9OktPLsXhfgV/ArYZ8FvAVn5JnaM69htTT9Q0usJlKPXVYiUwblGo1vkYIAWjxSJkSDMwmzNFzT5QWTasJnGty6jUB1Jv3YfLm5kupv3xkgy6w6xiGkySjmvzY4Gz0Aa4dAITuWzNVOQks2G49zR4fD8OtKCnWqUIK/SGEEXDD9z/prxB+cCSZQchsAhv+BZk9im3gW1ZyVT+/1P/pjHYr5Li6rA1sAfMqszIhLVSZShD6Zyz8NhzFfk5J5fykQ0ncy6vvFsXsUmwecQGwHRHF8t9lSPtYyzrQRtg3ksK2qWhGc8t4AHI6RjRPfxkG6MTvexxIKfYeKS2wOXbAZhSEVZ5UgSCL6jkJkHXTjFlZMB4CouqDMvgu69XgshjeD6M8sZfNV7y236Svs1pDJw7PlBbkK25TUruVuYupWeYcaHPJn4p/UC7XCD497t8es01RVFqf+uOTPtoJoEQII1v4HhqAfU2ZfGIay5Lyd+fF19tL3J+se3Ow5jZqPIdXrkUq0JNlweyEwg5Y4CPkH6r263tfQrpS6qvbXBu+GYNy/OY1Y9m5uhM7P3E6id69Gk4wam0rJMHOsSP8f
 s4bSqi8E
 ruJUlLZ+XWZEe5vcLZ08pk4bOx/yjW7ZTjw7YJjFU+3ES8cDKYpWJBKaY1m2l1hkkJLd/oqdUr62WjSdQnfnQ7mRhI93aduR1s/rHSOE6iOygt5vH2aICsVwl1djD+UBoeEiKf6lqU3jD0GmfjNPrJr0Olyt3ssIlOFd5JAmgxi2jlG+s2febX0QRTQQ+AJAP4trWiVhdeGe+RKC0Cz/B0PVBE8Lyq83HGP6XDsMr62MQgKn5d0KYC3VuANzkMoB81NRitqC/O4URFfn0ORjJ7OHXfV6a3+q/mfDrV2m+cKeBpFJ/gUf8b2lOltga4buQNQ69+a649mM5jaPiJHMEXuprL9UPeE83qCyVmxsrAlS7Q5AgyoPKcaH2i5JKLbpAkXYWLO5ceXEgV3katBG0qZSQXMOpinR3ANrS3zzMOI17LwBHdEtygzI1euSc+Gu7oT0yAztkM+0cvr1UyQnAJ2pEhuF5wVKAoCqCRxf+AUo9PHSw23nNmmUOy8t+5vjhARgoNXkquNn/i0R4WfOwMie89FwM/nCS7oaLbxalsR56Ocn1yQ8kPp6Gy5tGh/cbFieqd1CSKJw89oHUE459uA+19k7tL24y3S7NM7yDLCmbsVgNlurP9GStHIRlJfAyhiCXF2XSgqD9/4Le6nQhpeCbhuhLUG346yjrfv8U7h9wOcs+E1/IJh6cTDid5Ky42qa+JJcP2l/v2R2+vIfkRR320WaOhRLestxse5RpKiXSkdM3IZ+Dh7hKRvQINVU/U8NI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kselftest utility to validate memory mapping capabilities
under nommu kernels, aligned with
Documentation/admin-guide/mm/nommu-mmap.rst.

The test implements basic checks into a generic architecture-agnostic
test matrix applicable across nommu targets. It evaluates:

1. MAP_FIXED allocation rejections.
2. Standard MAP_PRIVATE and MAP_ANONYMOUS allocation resilience.
3. Regular file mappings via standard filesystem storage.
4. Block device subsystem mappings (gracefully skipping if node is
   missing).
5. Shared vs Private backing discrepancies under nommu conditions.
6. mremap limits, ensuring non-expandable restrictions behave properly.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-um@lists.infradead.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825015945.141739-1-thehajime@gmail.com
Assisted-by: Gemini:Pro [AI_Reviewer] [Sashiko_Linter]
Assisted-by: cubic.dev:unspecified
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v3 => v4
- clean up messages

v2 => v3
- remove unnecessary modifications
- address Sashiko review

rfc => v2
- prepare a different TARGETS for tests (mm/nommu)
- drop shrink fix tests
- drop mmap /dev/zero tests
- https://lore.kernel.org/linux-mm/20260825015945.141739-3-thehajime@gmail.com/

rfc:
- https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
---
 tools/testing/selftests/nommu/Makefile        |   8 +
 tools/testing/selftests/nommu/local.mk        |   7 +
 .../testing/selftests/nommu/nommu_mmap_test.c | 261 +++++++++++++
 .../selftests/nommu/nommu_mremap_test.c       | 366 ++++++++++++++++++
 4 files changed, 642 insertions(+)
 create mode 100644 tools/testing/selftests/nommu/Makefile
 create mode 100644 tools/testing/selftests/nommu/local.mk
 create mode 100644 tools/testing/selftests/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/nommu/nommu_mremap_test.c

diff --git a/tools/testing/selftests/nommu/Makefile b/tools/testing/selftests/nommu/Makefile
new file mode 100644
index 000000000000..8e7cd7315c53
--- /dev/null
+++ b/tools/testing/selftests/nommu/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for nommu selftests
+
+TEST_GEN_PROGS += nommu_mmap_test
+TEST_GEN_PROGS += nommu_mremap_test
+
+include ../lib.mk
+include local.mk
diff --git a/tools/testing/selftests/nommu/local.mk b/tools/testing/selftests/nommu/local.mk
new file mode 100644
index 000000000000..0bd1300f00f4
--- /dev/null
+++ b/tools/testing/selftests/nommu/local.mk
@@ -0,0 +1,7 @@
+# detect if users request NOMMU build or not
+# User can set NOMMU to 1 to build/test for NOMMU platforms
+NOMMU ?= 0
+ifeq ($(NOMMU),1)
+CFLAGS += -DNOMMU
+export NOMMU
+endif
diff --git a/tools/testing/selftests/nommu/nommu_mmap_test.c b/tools/testing/selftests/nommu/nommu_mmap_test.c
new file mode 100644
index 000000000000..a1f5fdda554a
--- /dev/null
+++ b/tools/testing/selftests/nommu/nommu_mmap_test.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <limits.h>
+#include "kselftest.h"
+
+#include <sys/vfs.h>
+#ifndef RAMFS_MAGIC
+#define RAMFS_MAGIC 0x858458f6
+#endif
+
+static size_t ps;
+
+struct test_case_t {
+	const char *name;
+	const char *pathname;
+	int open_flags;
+	int mmap_prot;
+	int mmap_flags;
+	int exp_err;
+	int (*resolve_exp_err)(const char *path);
+};
+
+static int get_shm_expected_error(const char *path)
+{
+	struct statfs fs;
+
+	if (statfs(path, &fs) == 0) {
+		if (fs.f_type == RAMFS_MAGIC)
+			return 0; /* ramfs succeed with contiguous memory */
+	}
+	 /* hostfs, etc returns ENODEV due to lack of contiguous allocation */
+	return ENODEV;
+}
+
+static struct test_case_t test_cases[] = {
+	{
+		.name = "anonymous private allocation",
+		.pathname = NULL,
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ | PROT_WRITE,
+		.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE,
+		.exp_err = 0,
+		.resolve_exp_err = NULL,
+	},
+	{
+		.name = "non-anonymous private file mapping (rw-)",
+		.pathname = "/tmp/ksft.nommu-reg-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ | PROT_WRITE,
+		.mmap_flags = MAP_PRIVATE,
+		.exp_err = 0,
+		.resolve_exp_err = NULL,
+	},
+	{
+		.name = "non-anonymous private file mapping (r--)",
+		.pathname = "/tmp/ksft.nommu-reg-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_PRIVATE,
+		.exp_err = 0,
+		.resolve_exp_err = NULL,
+	},
+	{
+		.name = "non-anonymous shared file mapping (rw-)",
+		.pathname = "/tmp/ksft.nommu-shm-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ | PROT_WRITE,
+		.mmap_flags = MAP_SHARED,
+		.exp_err = 0,
+#ifdef NOMMU
+		.resolve_exp_err = get_shm_expected_error,
+#else
+		.resolve_exp_err = NULL,
+#endif
+	},
+	{
+		.name = "non-anonymous shared file mapping (r--)",
+		.pathname = "/tmp/ksft.nommu-shm-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_SHARED,
+		.exp_err = 0,
+#ifdef NOMMU
+		.resolve_exp_err = get_shm_expected_error,
+#else
+		.resolve_exp_err = 0,
+#endif
+	},
+};
+
+static int run_mapping_matrix_test(struct test_case_t *tcase)
+{
+	int fd;
+	void *ptr;
+	char path_buf[PATH_MAX];
+	const char *path = tcase->pathname;
+	int rc = KSFT_PASS;
+	int expected_error;
+
+	ksft_print_msg("[RUN] %s\n", tcase->name);
+
+	if (tcase->pathname == NULL) {
+		fd = -1;
+	} else if (strstr(tcase->pathname, "XXXXXX")) {
+		strncpy(path_buf, tcase->pathname, sizeof(path_buf) - 1);
+		path_buf[sizeof(path_buf) - 1] = '\0';
+		fd = mkstemp(path_buf);
+		if (fd < 0) {
+			ksft_print_msg("Failed to setup temp node: %s\n",
+				tcase->pathname);
+			ksft_test_result_skip("%s\n", tcase->name);
+			return KSFT_SKIP;
+		}
+		if (ftruncate(fd, ps) != 0) {
+			ksft_print_msg("ftruncate failed for: %s\n", tcase->pathname);
+			ksft_test_result_fail("%s\n", tcase->name);
+			close(fd);
+			unlink(path_buf);
+			return KSFT_FAIL;
+		}
+		path = path_buf;
+	} else {
+		fd = open(tcase->pathname, tcase->open_flags, 0600);
+		if (fd < 0) {
+			ksft_print_msg("Device node not accessible: %s\n",
+				       tcase->pathname);
+			ksft_test_result_skip("%s\n", tcase->name);
+			return KSFT_SKIP;
+		}
+	}
+
+	expected_error = tcase->exp_err;
+	if (tcase->resolve_exp_err && fd >= 0)
+		expected_error = tcase->resolve_exp_err(path);
+
+	ptr = mmap(NULL, ps, tcase->mmap_prot, tcase->mmap_flags, fd, 0);
+
+	if (expected_error != 0) {
+		if (ptr != MAP_FAILED) {
+			ksft_print_msg("mmap unexpectedly succeeded (exp error %d)\n",
+					      expected_error);
+			ksft_test_result_fail("%s\n", tcase->name);
+			munmap(ptr, ps);
+			rc = KSFT_FAIL;
+			goto cleanup;
+		}
+		if (errno != expected_error) {
+			ksft_print_msg("mmap failed with %d (%s), but expected %d\n",
+				errno, strerror(errno), expected_error);
+			ksft_test_result_fail("%s\n", tcase->name);
+			rc = KSFT_FAIL;
+			goto cleanup;
+		}
+		ksft_print_msg("Correctly rejected with expected error %s(%d)\n",
+			strerror(expected_error), expected_error);
+		ksft_test_result_pass("%s\n", tcase->name);
+		rc = KSFT_PASS;
+		goto cleanup;
+	}
+
+	if (ptr == MAP_FAILED) {
+		ksft_print_msg("mmap failed unexpectedly: %s\n", strerror(errno));
+		ksft_test_result_fail("%s\n", tcase->name);
+		rc = KSFT_FAIL;
+		goto cleanup;
+	}
+
+	ksft_test_result_pass("%s\n", tcase->name);
+	munmap(ptr, ps);
+
+cleanup:
+	if (fd >= 0) {
+		close(fd);
+		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
+			unlink(path_buf);
+	}
+	return rc;
+}
+
+static int test_map_fixed(void)
+{
+	void *fixed_addr;
+	void *ptr;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	fixed_addr = mmap(NULL, ps, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (fixed_addr == MAP_FAILED) {
+		ksft_print_msg("Unable to reserve test address: %s\n",
+				strerror(errno));
+		ksft_test_result_skip("MAP_FIXED behavior\n");
+		return KSFT_SKIP;
+	}
+
+	if (munmap(fixed_addr, ps)) {
+		ksft_print_msg("Unable to release test address: %s\n",
+			strerror(errno));
+		ksft_test_result_fail("MAP_FIXED behavior\n");
+		return KSFT_FAIL;
+	}
+
+	ptr = mmap(fixed_addr, ps, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+
+#ifdef NOMMU
+	if (ptr == MAP_FAILED && (errno == ENODEV || errno == EINVAL)) {
+		ksft_print_msg("MAP_FIXED correctly rejected under nommu\n");
+		ksft_test_result_pass("MAP_FIXED behavior\n");
+		return KSFT_PASS;
+	}
+	if (ptr != MAP_FAILED) {
+		ksft_print_msg("MAP_FIXED unexpectedly allowed under nommu\n");
+		ksft_test_result_fail("MAP_FIXED behavior\n");
+		munmap(ptr, ps);
+		return KSFT_FAIL;
+	}
+	ksft_print_msg("MAP_FIXED failed under NOMMU: %s\n",
+			      strerror(errno));
+	ksft_test_result_fail("MAP_FIXED behavior\n");
+	return KSFT_FAIL;
+#else
+	if (ptr != MAP_FAILED) {
+		ksft_print_msg("MAP_FIXED successfully allocated under MMU\n");
+		ksft_test_result_pass("MAP_FIXED behavior\n");
+		munmap(ptr, ps);
+		return KSFT_PASS;
+	}
+	ksft_print_msg("MAP_FIXED failed allocation under MMU\n");
+	ksft_test_result_fail("MAP_FIXED behavior\n");
+	return KSFT_FAIL;
+#endif
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	ps = sysconf(_SC_PAGESIZE);
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(test_cases) + 1);
+
+#ifdef NOMMU
+	ksft_print_msg("Running strict MMAP test criteria under nommu architecture\n");
+#else
+	ksft_print_msg("Running MMAP test criteria under MMU architecture\n");
+#endif
+
+	test_map_fixed();
+	for (i = 0; i < (int)ARRAY_SIZE(test_cases); i++)
+		run_mapping_matrix_test(&test_cases[i]);
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/nommu/nommu_mremap_test.c b/tools/testing/selftests/nommu/nommu_mremap_test.c
new file mode 100644
index 000000000000..7ccdf65b675f
--- /dev/null
+++ b/tools/testing/selftests/nommu/nommu_mremap_test.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <limits.h>
+#include "kselftest.h"
+
+#include <sys/vfs.h>
+#ifndef RAMFS_MAGIC
+#define RAMFS_MAGIC 0x858458f6
+#endif
+
+static size_t ps;
+
+static long get_fs_type(const char *path)
+{
+	struct statfs fs;
+
+	if (statfs(path, &fs) == 0)
+		return fs.f_type;
+
+	return 0;
+}
+
+static void munmap_shrink_test(void)
+{
+	void *addr;
+	int ret;
+
+	/* munmap shrink test */
+	for (int i = 0; i < 4; i++) {
+		addr = mmap(NULL, ps * 4, PROT_READ | PROT_WRITE,
+			    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (addr == MAP_FAILED) {
+			ksft_print_msg("mmap failed: %s(%d)\n", strerror(errno), errno);
+			ksft_test_result_fail("munmap shrink\n");
+			return;
+		}
+		ret = munmap((char *)addr + ps * i, ps);
+		if (ret != 0) {
+			ksft_print_msg("memory %p isn't unmapped at %p\n",
+				addr, (char *)addr + ps * i);
+			ksft_test_result_fail("munmap shrink\n");
+			return;
+		}
+
+		if (i == 0) {
+			if (munmap(addr +  ps, ps * 3))
+				goto error;
+		} else if (i == 1) {
+			if (munmap(addr, ps) || munmap(addr + (ps * 2), ps * 2))
+				goto error;
+		} else if (i == 2) {
+			if (munmap(addr, ps * 2) || munmap(addr + (ps * 3), ps))
+				goto error;
+		} else if (i == 3) {
+			if (munmap(addr, ps * 3))
+				goto error;
+		}
+	}
+
+	ksft_test_result_pass("munmap shrink\n");
+	return;
+error:
+	for (int j = 0; j < 4; j++)
+		munmap((char *)addr + j * ps, ps);
+	ksft_print_msg("clean up failures\n");
+	ksft_test_result_fail("munmap shrink\n");
+}
+
+static size_t page_align(size_t len)
+{
+	return (len + ps - 1) / ps * ps;
+}
+
+static void mremap_shrink_test(void)
+{
+	void *addr, *addr2;
+	size_t current_len;
+	size_t old_len, new_len;
+	struct param {
+		size_t old;
+		size_t new;
+	} params[] = {
+		/* should not happen any shrink */
+		{ .old = ps * 4 - 1, .new = ps * 4 - 2 },
+		/* should not happen any shrink */
+		{ .old = ps * 4 - 1, .new = ps * 4 },
+		{ .old = ps * 4, .new = ps * 2 },
+		/* should not happen any shrink */
+		{ .old = ps * 2, .new = ps * 2 - 2 },
+		{ .old = ps * 2 - 2, .new = ps * 1 },
+	};
+
+	/* mremap shrink test */
+	current_len = page_align(ps * 4 - 1);
+	addr = mmap(NULL, ps * 4 - 1, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (addr == MAP_FAILED) {
+		ksft_print_msg("mmap failed: %s(%d)\n", strerror(errno), errno);
+		ksft_test_result_fail("mremap shrink\n");
+		return;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(params); i++) {
+		old_len = params[i].old;
+		new_len = params[i].new;
+		current_len = page_align(new_len);
+		addr2 = mremap(addr, old_len, new_len, MREMAP_MAYMOVE);
+		if (addr2 == MAP_FAILED) {
+			ksft_print_msg("memory %p isn't remapped at %p\n", addr, addr2);
+			ksft_test_result_fail("mremap shrink\n");
+			munmap(addr, page_align(old_len));
+			return;
+		}
+
+		addr = addr2;
+	}
+
+	if (munmap(addr, current_len)) {
+		ksft_print_msg("cleanup failed: %s\n", strerror(errno));
+		ksft_test_result_fail("mremap shrink\n");
+		return;
+	}
+	ksft_test_result_pass("mremap shrink\n");
+}
+
+static int get_shared_writable_file_expected_error(const char *path)
+{
+	if (get_fs_type(path) == RAMFS_MAGIC)
+		return EPERM; /* ramfs failed */
+
+	return 0;
+}
+
+struct mremap_case_t {
+	const char *name;
+	const char *pathname;
+	int open_flags;
+	int mmap_prot;
+	int mmap_flags;
+	int exp_err;
+	int (*resolve_exp_err)(const char *path);
+	unsigned int old_pages;
+	unsigned int new_pages;
+};
+
+static struct mremap_case_t mremap_cases[] = {
+	{
+		.name = "anonymous shrink (r--)",
+		.pathname = NULL,
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE,
+		.exp_err = 0,
+		.resolve_exp_err = 0,
+	},
+	{
+		.name = "shared file shrink (r--)",
+		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_SHARED,
+		.exp_err = 0,
+#ifdef NOMMU
+		.resolve_exp_err = get_shared_writable_file_expected_error,
+#else
+		.resolve_exp_err = 0,
+#endif
+	},
+	{
+		.name = "private file unchanged length (r-)",
+		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_PRIVATE,
+#ifdef NOMMU
+		.exp_err = EPERM,
+#else
+		.exp_err = 0,
+#endif
+		.resolve_exp_err = 0,
+		.old_pages = 4,
+		.new_pages = 4,
+	},
+	{
+		.name = "private file unchanged length (rw-)",
+		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ | PROT_WRITE,
+		.mmap_flags = MAP_PRIVATE,
+		.exp_err = 0,
+		.resolve_exp_err = 0,
+		.old_pages = 4,
+		.new_pages = 4,
+	},
+	{
+		.name = "private file growth (r-)",
+		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ,
+		.mmap_flags = MAP_PRIVATE,
+#ifdef NOMMU
+		.exp_err = EPERM,
+#else
+		.exp_err = 0,
+#endif
+		.resolve_exp_err = 0,
+		.old_pages = 4,
+		.new_pages = 8,
+	},
+	{
+		.name = "private file growth (rw-)",
+		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
+		.open_flags = O_CREAT | O_RDWR | O_EXCL,
+		.mmap_prot = PROT_READ | PROT_WRITE,
+		.mmap_flags = MAP_PRIVATE,
+#ifdef NOMMU
+		.exp_err = ENOMEM,
+#else
+		.exp_err = 0,
+#endif
+		.resolve_exp_err = 0,
+		.old_pages = 4,
+		.new_pages = 8,
+	},
+};
+
+static int run_mremap_test(struct mremap_case_t *tcase)
+{
+	int fd = -1;
+	void *addr, *addr2;
+	char pb[PATH_MAX];
+	const char *path = tcase->pathname;
+	int rc = KSFT_PASS;
+	int expected_error;
+	unsigned int old_pages = tcase->old_pages ?: 4;
+	unsigned int new_pages = tcase->new_pages ?: 2;
+	unsigned int file_pages = old_pages > new_pages ?
+				  old_pages : new_pages;
+
+	ksft_print_msg("[RUN] Testing mremap: %s\n", tcase->name);
+
+	if (tcase->pathname && strstr(tcase->pathname, "XXXXXX")) {
+		strncpy(pb, tcase->pathname, sizeof(pb) - 1);
+		pb[sizeof(pb) - 1] = '\0';
+		fd = mkstemp(pb);
+		if (fd < 0) {
+			ksft_print_msg("Failed to setup file backing\n");
+			ksft_test_result_skip("%s\n", tcase->name);
+			return KSFT_SKIP;
+		}
+		if (ftruncate(fd, ps * file_pages) != 0) {
+			ksft_print_msg("Failed to setup file backing\n");
+			ksft_test_result_fail("%s\n", tcase->name);
+			close(fd);
+			unlink(pb);
+			return KSFT_FAIL;
+		}
+
+#ifdef NOMMU
+		if ((tcase->mmap_flags & MAP_SHARED) && get_fs_type(pb) != RAMFS_MAGIC) {
+			ksft_print_msg("Skip the test under non-ramfs filesystem (%s)\n",
+				pb);
+			ksft_test_result_skip("%s\n", tcase->name);
+			close(fd);
+			unlink(pb);
+			return KSFT_SKIP;
+		}
+#endif
+		path = pb;
+	} else if (tcase->pathname) {
+		fd = open(tcase->pathname, tcase->open_flags, 0600);
+		if (fd < 0) {
+			ksft_print_msg("Backing node not accessible\n");
+			ksft_test_result_skip("%s\n", tcase->name);
+			return KSFT_SKIP;
+		}
+
+#ifdef NOMMU
+		if ((tcase->mmap_flags & MAP_SHARED) &&
+		    get_fs_type(tcase->pathname) != RAMFS_MAGIC) {
+			ksft_print_msg("Skip the test under non-ramfs filesystem (%s)\n",
+					      tcase->pathname);
+			ksft_test_result_skip("%s\n", tcase->name);
+			close(fd);
+			return KSFT_SKIP;
+		}
+#endif
+	}
+
+	addr = mmap(NULL, ps * old_pages, tcase->mmap_prot,
+		    tcase->mmap_flags, fd, 0);
+	if (addr == MAP_FAILED) {
+		ksft_print_msg("mmap mapping failed %s(%d)\n", strerror(errno), errno);
+		rc = KSFT_FAIL;
+		goto out;
+	}
+
+	expected_error = tcase->exp_err;
+	if (tcase->resolve_exp_err && fd >= 0)
+		expected_error = tcase->resolve_exp_err(path);
+
+	addr2 = mremap(addr, ps * old_pages, ps * new_pages,
+		       MREMAP_MAYMOVE);
+
+	if (expected_error != 0) {
+		if (addr2 != MAP_FAILED) {
+			ksft_print_msg("Expected error %d, but mremap unexpectedly succeeded\n",
+				       expected_error);
+			rc = KSFT_FAIL;
+		} else if (errno != expected_error) {
+			ksft_print_msg("Expected error %d, got %s(%d)\n",
+				       expected_error, strerror(errno), errno);
+			rc = KSFT_FAIL;
+		} else {
+			ksft_print_msg("%s: Handled expected error path (errno=%d)\n",
+				       tcase->name, expected_error);
+		}
+	} else if (addr2 == MAP_FAILED) {
+		ksft_print_msg("mremap shrink failed unexpectedly: %s\n",
+			       strerror(errno));
+		rc = KSFT_FAIL;
+	} else {
+		ksft_print_msg("%s step successful\n", tcase->name);
+	}
+
+	/* clean up */
+	if (munmap(addr2 == MAP_FAILED ? addr : addr2,
+		   addr2 == MAP_FAILED ? ps * old_pages : ps * new_pages)) {
+		ksft_print_msg("munmap failed: %s\n", strerror(errno));
+		rc = KSFT_FAIL;
+	}
+
+out:
+	if (fd >= 0) {
+		close(fd);
+		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
+			unlink(pb);
+	}
+
+	ksft_test_result_report(rc, "%s\n", tcase->name);
+	return rc;
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	ps = sysconf(_SC_PAGESIZE);
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(mremap_cases) + 2);
+
+	munmap_shrink_test();
+	mremap_shrink_test();
+
+	for (i = 0; i < (int)ARRAY_SIZE(mremap_cases); i++)
+		run_mremap_test(&mremap_cases[i]);
+
+	ksft_finished();
+}
-- 
2.43.0



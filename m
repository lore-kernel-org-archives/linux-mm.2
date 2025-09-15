Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FEBCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDF18E0015; Mon, 15 Sep 2025 12:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3A18E0008; Mon, 15 Sep 2025 12:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9B18E0015; Mon, 15 Sep 2025 12:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B541F8E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:46:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 589D311A60B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:11 +0000 (UTC)
X-FDA: 83892062142.11.07255EE
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EC9B140004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jNPay2Oq;
	spf=pass (imf26.hostedemail.com: domain of 30ELIaAsKCMMtjun1q1rwpqpxxpun.lxvurw36-vvt4jlt.x0p@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30ELIaAsKCMMtjun1q1rwpqpxxpun.lxvurw36-vvt4jlt.x0p@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCSSp2N5c9yEXM9I+1aefN3SldFOzk155OGuTtokYU4=;
	b=piVDL7QdWu+lx4/pzTfnDe94Txb9JKkXS9d8ue8/eY3/jgrX/qVrL85A818ZJsCUz9/You
	PdwjCWI6Zb5esFpuNyxcxTW7EW/VEELet+2ySz3kANUpmcOQuG2LOeAR2sQDukRw5KfivG
	Nn9IWIVtLfYqtE91ao/NPMT91bZx9Sw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954769; a=rsa-sha256;
	cv=none;
	b=4vzDRnSFdXZ2KKDvM0axBFiA1q83j3O6oCBEBPcw1cwwjf8wOLn3RZHD+1bZEphnrrmVA6
	DZ2NjQudDPVh3+8qnX+l17h6kVcl55u2AFOFI5ZcdCVYe9ZUFJ5AFNkwCtGaYpetjtoz/b
	VnUFGRqvF6XNXfoDIgqNfGJTK5/xZeE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jNPay2Oq;
	spf=pass (imf26.hostedemail.com: domain of 30ELIaAsKCMMtjun1q1rwpqpxxpun.lxvurw36-vvt4jlt.x0p@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30ELIaAsKCMMtjun1q1rwpqpxxpun.lxvurw36-vvt4jlt.x0p@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32deaafeb5bso5567770a91.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954768; x=1758559568; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSSp2N5c9yEXM9I+1aefN3SldFOzk155OGuTtokYU4=;
        b=jNPay2OqupwEMg+FMlkPGNl7KOITYiyvmwd1vdmM/V3zcyxzQW8Aef4B1dcdT75Fip
         DR5oDGlj2D2fVyGc1MH+onDkfV8396Ap0OX4LP9x+LuRI1O+zsI3BkfiYeJYAOdGoYni
         Hv7+lbnuvch8zbUifPr/z9KonQvPSuyDnVtR7FVRzCcPpu3nQ6Zy+TetMeAH5lOPZE4W
         NsxJMmdm8QUx0FCY78aSH23yX/v6IJ54YvI3tuYnVGUJgh6EA64cWFyyfEMhQVo0qja3
         Y7HICIPPSYrAVUwytf/K6prJDAHWXjlv2QF5stPq7DExxTrrRDfvK9BGUqm+zCK4sGGw
         jBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954768; x=1758559568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSSp2N5c9yEXM9I+1aefN3SldFOzk155OGuTtokYU4=;
        b=xPtPTBX8KwV6+bXnZrxFheMMUw8hFHx43ZsHkHgqh7GteO2hEYZiIkZDADpee+eJHx
         tK+7LfPlLtdIbh9chktbzXNRAxu+iyIMK3OCddvDtHakKUkiyASBdR6lETsvgtUwgYot
         /3+5N68qVVototq/XFTHdcIcu0Qn0QjOfoFcYxn+0jz8cMBfXW3aVtWowr3/9/iQPiat
         XhfdSuSqwED5295cfBUYKP04TkI0szmke2+m7i48cVDkY6Hp2roQ4FMcwuG7iUNZdsxf
         R8bMc1cPlNOoDWjoI+blRt93gYUOZNCfPa8TYU3Fh5+Jujkm7f5W0Vn75ORk026U+YBT
         3X6A==
X-Forwarded-Encrypted: i=1; AJvYcCX7EW/Hf4NTGDNhVNy+H4D48Q6hw5Wtk21SC+WpXBUYCQjJjx+FJnT6WhG12elzRMhjA+37ar8WGA==@kvack.org
X-Gm-Message-State: AOJu0YxcuKRzTzkJ8GfH0qLpLXk1cxiCBaNOmZnSRy1nNLZEBEHI9J0t
	1IaR0KKAbJ+/RsI9IvfV15YzwJj67vuZF2J3U4abI81bPl7TyxJvKXVmi29N+D0uk//V10LxMNS
	2dkNQqlezR4aotOZN88UsW7ykZw==
X-Google-Smtp-Source: AGHT+IH629yWc1BxgGvDumfHUKr1KQxr/RK85CqBBR0VFlrjCzLlim4w3J/AZqPO6/2jdfO/Nl5jWNcSFrWm5T8gGA==
X-Received: from pjbnc8.prod.google.com ([2002:a17:90b:37c8:b0:32d:a4d4:bb17])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2889:b0:32e:18f2:7a59 with SMTP id 98e67ed59e1d1-32e18f27cb4mr8891271a91.11.1757954768220;
 Mon, 15 Sep 2025 09:46:08 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:33 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-3-kaleshsingh@google.com>
Subject: [PATCH v2 2/7] mm/selftests: add max_vma_count tests
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EC9B140004
X-Stat-Signature: p9rnprp51bjmk7yaewqu64jqr3c175hx
X-Rspam-User: 
X-HE-Tag: 1757954769-624375
X-HE-Meta: U2FsdGVkX18WQ7k3yOcJ6U2BkincbVHv+lx+vnca9WF0Qqnukwhvmy+A6QopgV0I8CFJ5/YhS1we4ioGA5N1r4LLhFpcKTCUFnO+lFa0LHMkvZ78LijruK9/5xt1Rt2kMc0k+uFsKV2cLKNxhYyPmRDcT9/f6yA+mvme75l4zlVSA26n6I08BABM1y5oGBxEPnmNzs7qgFYLfhZ83NAfA5thoauMkxhbKhhtTA8Y3Up/Odzx0cWM9+8QdMgkQQJbnQizHud2SRgITltvuxaQlsrKiGNTmEe8bUQxzkIQIwjdcY6CKziBsVpLCieJf68M3oQVqZgCj1t/MlqY0lXdm0IQ0m/lTab9RKiNaNPCfkmy2rZIhfLgmJ/rXqNX/+t10DXAm/+i9B6wan7MIu8LPAcsHpR7V9rp7vT6wFDRBLg1J0WZUSIZQtnwPOULlegt8Gjral/civjUZzQF0gmsBPm05NVznoxbaYqno05oL8p0rXIUhrA1ot4iYjCi7zc/ImjM1+xuX5qZsxbCTBiuDUqHP5wHkvZgvkUS17o7VSBVcQWOURpIpZ6w9V5YdDmo/Qeya/BCfro39ODJjFWFgS3D4BA4mTeIIG6t4hH6CKJ69TogCV2gV5yAH0fJiRk+N0HoCkyPrm+bvijA8xhQt7jeZcyuTdElNrzo5BG8e8zjgedcSN3TWlmKM8B2vcfmeNZ5QSLSYcZH3y/o2AP1BGaVc0ZC4nXsuW1CDgTNrtbdqitqG4JUov58hjXnwO6FFvkrfX3Yh6fDguF5Tjvpn6rznf3gpHL2vYeyxMP+MKc5RDzsceMd0V6OXZUZNuvyHrNvUn4ve9P4gkK/2bZZ9qMNFydTLQtfl1FNZrNVEr/lXf36LrhBPyopg0W1POcrNMTe4mtiAXVnSzsUPXijfRjoCnBN6/H3aUIiRAsm/JrOV8fKDzZXzMcxs5fV0aVcAuGfGB0o2UfcqVecXKz
 jf67EurV
 bhH8sSlg4DQHZ8qECcsU+YQ6lGDgfFzFLgdzBFBZb5iivy4rR6NBn/1RrtWtqB7Q7QWNRrol2nX26vFXRzWkk3BjXHDi3iKRhJCqEC4QsIm3bP/Nxs38t6N9Fmzn1zTv1BbiUdNeVyrxTMKVHku8XFicIf3SD9Q1wsjBRupdF6rbaAHsb8OMONzvPEDrXjD81XsABzFpo5y4INOS7p0veGu7RnyubwKeOCk2OBHqBt+smuQGo426nC9EiKJkGGe9frwtrtig7XX5Dzv936BMQsTihxEEmpScI9X2ELpwaHg2TORuhF5gXDsZatEBaqzG8Uaxxr9cfTnThb7/79m0ZH9WQq3VApnoPgFfJr3ex2NnGI1MwWspo9RnzO2KZ7dxCFoC6deuqpORWYEAtqJOZMREUPUOR3+Yy9Mwa25Bz8ecKBv4wSCq0p250Lt6hen899Q6l1Ni/FhRwrz+wpYZdxFrXdDCUfy10b3Aw7Qv09Eweqmzzni0h7NFP89IEUtbXGDD+P7XilynhLqmOetYSkrLkTSwLY5STRV+Q4EOCH/LV5S9COh+ZhjXw7MgXdvHrSoNI92pgyh5GknKrV6wctR2J7MwN7G5k0nE6WmXwtaWK68vSzxvoyzDtiCg8c0FheHChwkAVQ3pbtQ8ALV4RDh+FlzFXHuF16N+v9GFWEBquEaXBkG5dbLLWnpghQL3t7cF5rk7sOKpCJ3zWGeA3JubAzC2BU7R6Nw1oJVBy7djeO0K6pFguUPxE8GmSAg4AQIb2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new selftest to verify that the max VMA count limit is correctly
enforced.

This test suite checks that various VMA operations (mmap, mprotect,
munmap, mremap) succeed or fail as expected when the number of VMAs is
close to the sysctl_max_map_count limit.

The test works by first creating a large number of VMAs to bring the
process close to the limit, and then performing various operations that
may or may not create new VMAs. The test then verifies that the
operations that would exceed the limit fail, and that the operations
that do not exceed the limit succeed.

NOTE: munmap is special as it's allowed to temporarily exceed the limit
by one for splits as this will decrease back to the limit once the unmap
succeeds.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
 - Add tests, per Liam (note that the do_brk_flags() path is not easily
   tested from userspace, so it's not included here). Exceeding the limit there
   should be uncommon.

 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/max_vma_count_tests.c        | 709 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 3 files changed, 715 insertions(+)
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b..00a4b04eab06 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -91,6 +91,7 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
+TEST_GEN_FILES += max_vma_count_tests
 TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
diff --git a/tools/testing/selftests/mm/max_vma_count_tests.c b/tools/testing/selftests/mm/max_vma_count_tests.c
new file mode 100644
index 000000000000..c8401c03425c
--- /dev/null
+++ b/tools/testing/selftests/mm/max_vma_count_tests.c
@@ -0,0 +1,709 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2025 Google LLC
+ */
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <linux/prctl.h>  /* Definition of PR_* constants */
+#include <sys/prctl.h>
+
+#include "../kselftest.h"
+
+static int get_max_vma_count(void);
+static bool set_max_vma_count(int val);
+static int get_current_vma_count(void);
+static bool is_current_vma_count(const char *msg, int expected);
+static bool is_test_area_mapped(const char *msg);
+static void print_surrounding_maps(const char *msg);
+
+/* Globals initialized in test_suite_setup() */
+static int MAX_VMA_COUNT;
+static int ORIGINAL_MAX_VMA_COUNT;
+static int PAGE_SIZE;
+static int GUARD_SIZE;
+static int TEST_AREA_SIZE;
+static int EXTRA_MAP_SIZE;
+
+static int MAX_VMA_COUNT;
+
+static int NR_EXTRA_MAPS;
+
+static char *TEST_AREA;
+static char *EXTRA_MAPS;
+
+#define DEFAULT_MAX_MAP_COUNT	65530
+#define TEST_AREA_NR_PAGES	3
+/* 1 before test area + 1 after test area + 1 after extra mappings */
+#define NR_GUARDS		3
+#define TEST_AREA_PROT		(PROT_NONE)
+#define EXTRA_MAP_PROT		(PROT_NONE)
+
+/**
+ * test_suite_setup - Set up the VMA layout for VMA count testing.
+ *
+ * Sets up the following VMA layout:
+ *
+ * +----- base_addr
+ * |
+ * V
+ * +--------------+----------------------+--------------+----------------+--------------+----------------+--------------+-----+----------------+--------------+
+ * |  Guard Page  |                      |  Guard Page  |  Extra Map 1   | Unmapped Gap |  Extra Map 2   | Unmapped Gap | ... |  Extra Map N   | Unmapped Gap |
+ * |  (unmapped)  |      TEST_AREA       |  (unmapped)  | (mapped page)  |  (1 page)    | (mapped page)  |  (1 page)    | ... | (mapped page)  |  (1 page)    |
+ * |   (1 page)   | (unmapped, 3 pages)  |   (1 page)   |    (1 page)    |              |    (1 page)    |              |     |    (1 page)    |              |
+ * +--------------+----------------------+--------------+----------------+--------------+----------------+--------------+-----+----------------+--------------+
+ * ^              ^                      ^              ^                                                                  ^
+ * |              |                      |              |                                                                  |
+ * +--GUARD_SIZE--+                      |              +-- EXTRA_MAPS points here             Sufficient EXTRA_MAPS to ---+
+ *    (PAGE_SIZE) |                      |                                                         reach MAX_VMA_COUNT
+ *                |                      |
+ *                +--- TEST_AREA_SIZE ---+
+ *                |   (3 * PAGE_SIZE)    |
+ *                ^
+ *                |
+ *                +-- TEST_AREA starts here
+ *
+ * Populates TEST_AREA and other globals required for the tests.
+ * If successful, the current VMA count will be MAX_VMA_COUNT - 1.
+ *
+ * Return: true on success, false on failure.
+ */
+static bool test_suite_setup(void)
+{
+	int initial_vma_count;
+	size_t reservation_size;
+	void *base_addr = NULL;
+	char *ptr = NULL;
+
+	ksft_print_msg("Setting up vma_max_count test suite...\n");
+
+	/* Initialize globals */
+	PAGE_SIZE = sysconf(_SC_PAGESIZE);
+	TEST_AREA_SIZE = TEST_AREA_NR_PAGES * PAGE_SIZE;
+	GUARD_SIZE = PAGE_SIZE;
+	EXTRA_MAP_SIZE = PAGE_SIZE;
+	MAX_VMA_COUNT = get_max_vma_count();
+
+	MAX_VMA_COUNT = get_max_vma_count();
+	if (MAX_VMA_COUNT < 0) {
+		ksft_print_msg("Failed to read /proc/sys/vm/max_map_count\n");
+		return false;
+	}
+
+	/*
+	 * If the current limit is higher than the kernel default,
+	 * we attempt to lower it to the default to ensure the test
+	 * can run with a reliably known boundary.
+	 */
+	ORIGINAL_MAX_VMA_COUNT = 0;
+
+	if (MAX_VMA_COUNT > DEFAULT_MAX_MAP_COUNT) {
+		ORIGINAL_MAX_VMA_COUNT = MAX_VMA_COUNT;
+
+		ksft_print_msg("Max VMA count is %d, lowering to default %d for test...\n",
+				MAX_VMA_COUNT, DEFAULT_MAX_MAP_COUNT);
+
+		if (!set_max_vma_count(DEFAULT_MAX_MAP_COUNT)) {
+			ksft_print_msg("WARNING: Failed to lower max_map_count to %d (requires root)n",
+					DEFAULT_MAX_MAP_COUNT);
+			ksft_print_msg("Skipping test. Please run as root: limit needs adjustment\n");
+
+			MAX_VMA_COUNT = ORIGINAL_MAX_VMA_COUNT;
+
+			return false;
+		}
+
+		/* Update MAX_VMA_COUNT for the test run */
+		MAX_VMA_COUNT = DEFAULT_MAX_MAP_COUNT;
+	}
+
+	initial_vma_count = get_current_vma_count();
+	if (initial_vma_count < 0) {
+		ksft_print_msg("Failed to read /proc/self/maps\n");
+		return false;
+	}
+
+	/*
+	 * Calculate how many extra mappings we need to create to reach
+	 * MAX_VMA_COUNT - 1 (excluding test area).
+	 */
+	NR_EXTRA_MAPS = MAX_VMA_COUNT - 1 - initial_vma_count;
+
+	if (NR_EXTRA_MAPS < 1) {
+		ksft_print_msg("Not enough available maps to run test\n");
+		ksft_print_msg("max_vma_count=%d, current_vma_count=%d\n",
+				MAX_VMA_COUNT, initial_vma_count);
+		return false;
+	}
+
+	/*
+	 * Reserve space for:
+	 * - Extra mappings with a 1-page gap after each (NR_EXTRA_MAPS * 2)
+	 * - The test area itself (TEST_AREA_NR_PAGES)
+	 * - The guard pages (NR_GUARDS)
+	 */
+	reservation_size = ((NR_EXTRA_MAPS * 2) +
+				TEST_AREA_NR_PAGES + NR_GUARDS) * PAGE_SIZE;
+
+	base_addr = mmap(NULL, reservation_size, PROT_NONE,
+			MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
+	if (base_addr == MAP_FAILED) {
+		ksft_print_msg("Failed tommap initial reservation\n");
+		return false;
+	}
+
+	if (munmap(base_addr, reservation_size) == -1) {
+		ksft_print_msg("Failed to munmap initial reservation\n");
+		return false;
+	}
+
+	/* Get the addr of the test area */
+	TEST_AREA = (char *)base_addr + GUARD_SIZE;
+
+	/*
+	 * Get the addr of the region for extra mappings:
+	 *     test area + 1 guard.
+	 */
+	EXTRA_MAPS = TEST_AREA + TEST_AREA_SIZE + GUARD_SIZE;
+
+	/* Create single-page mappings separated by unmapped pages */
+	ptr = EXTRA_MAPS;
+	for (int i = 0; i < NR_EXTRA_MAPS; ++i) {
+		if (mmap(ptr, PAGE_SIZE, EXTRA_MAP_PROT,
+			MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED_NOREPLACE,
+			-1, 0) == MAP_FAILED) {
+			perror("mmap in fill loop");
+			ksft_print_msg("Failed on mapping #%d of %d\n", i + 1,
+					NR_EXTRA_MAPS);
+			return false;
+		}
+
+		/* Advance pointer by 2 to leave a gap */
+		ptr += (2 * EXTRA_MAP_SIZE);
+	}
+
+	if (!is_current_vma_count("test_suite_setup", MAX_VMA_COUNT - 1))
+		return false;
+
+	ksft_print_msg("vma_max_count test suite setup done.\n");
+
+	return true;
+}
+
+static void test_suite_teardown(void)
+{
+	if (ORIGINAL_MAX_VMA_COUNT && MAX_VMA_COUNT != ORIGINAL_MAX_VMA_COUNT) {
+		if (!set_max_vma_count(ORIGINAL_MAX_VMA_COUNT))
+			ksft_print_msg("Failed to restore max_map_count to %d\n",
+					ORIGINAL_MAX_VMA_COUNT);
+	}
+}
+
+/* --- Test Helper Functions --- */
+static bool mmap_anon(void)
+{
+	void *addr =  mmap(NULL, PAGE_SIZE, PROT_READ,
+			   MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
+
+	/*
+	 * Handle cleanup here as the runner doesn't track where this,
+	 *mapping is located.
+	 */
+	if (addr != MAP_FAILED)
+		munmap(addr, PAGE_SIZE);
+
+	return addr != MAP_FAILED;
+}
+
+static inline bool __mprotect(char *addr, int size)
+{
+	int new_prot = ~TEST_AREA_PROT & (PROT_READ | PROT_WRITE | PROT_EXEC);
+
+	return mprotect(addr, size, new_prot) == 0;
+}
+
+static bool mprotect_nosplit(void)
+{
+	return __mprotect(TEST_AREA, TEST_AREA_SIZE);
+}
+
+static bool mprotect_2way_split(void)
+{
+	return __mprotect(TEST_AREA, TEST_AREA_SIZE - PAGE_SIZE);
+}
+
+static bool mprotect_3way_split(void)
+{
+	return __mprotect(TEST_AREA + PAGE_SIZE, PAGE_SIZE);
+}
+
+static inline bool __munmap(char *addr, int size)
+{
+	return munmap(addr, size) == 0;
+}
+
+static bool munmap_nosplit(void)
+{
+	return __munmap(TEST_AREA, TEST_AREA_SIZE);
+}
+
+static bool munmap_2way_split(void)
+{
+	return __munmap(TEST_AREA, TEST_AREA_SIZE - PAGE_SIZE);
+}
+
+static bool munmap_3way_split(void)
+{
+	return __munmap(TEST_AREA + PAGE_SIZE, PAGE_SIZE);
+}
+
+/* mremap accounts for the worst case to fail early */
+static const int MREMAP_REQUIRED_VMA_SLOTS = 6;
+
+static bool mremap_dontunmap(void)
+{
+	void *new_addr;
+
+	/*
+	 * Using MREMAP_DONTUNMAP will create a new mapping without
+	 * removing the old one, consuming one VMA slot.
+	 */
+	new_addr = mremap(TEST_AREA, TEST_AREA_SIZE, TEST_AREA_SIZE,
+			  MREMAP_MAYMOVE | MREMAP_DONTUNMAP, NULL);
+
+	if (new_addr != MAP_FAILED)
+		munmap(new_addr, TEST_AREA_SIZE);
+
+	return new_addr != MAP_FAILED;
+}
+
+struct test {
+	const char *name;
+	bool (*test)(void);
+	 /* How many VMA slots below the limit this test needs to start? */
+	int vma_slots_needed;
+	bool expect_success;
+};
+
+/* --- Test Cases --- */
+struct test tests[] = {
+	{
+		.name = "mmap_at_1_below_vma_count_limit",
+		.test = mmap_anon,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "mmap_at_vma_count_limit",
+		.test = mmap_anon,
+		.vma_slots_needed = 0,
+		.expect_success = false,
+	},
+	{
+		.name = "mprotect_nosplit_at_1_below_vma_count_limit",
+		.test = mprotect_nosplit,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "mprotect_nosplit_at_vma_count_limit",
+		.test = mprotect_nosplit,
+		.vma_slots_needed = 0,
+		.expect_success = true,
+	},
+	{
+		.name = "mprotect_2way_split_at_1_below_vma_count_limit",
+		.test = mprotect_2way_split,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "mprotect_2way_split_at_vma_count_limit",
+		.test = mprotect_2way_split,
+		.vma_slots_needed = 0,
+		.expect_success = false,
+	},
+	{
+		.name = "mprotect_3way_split_at_2_below_vma_count_limit",
+		.test = mprotect_3way_split,
+		.vma_slots_needed = 2,
+		.expect_success = true,
+	},
+	{
+		.name = "mprotect_3way_split_at_1_below_vma_count_limit",
+		.test = mprotect_3way_split,
+		.vma_slots_needed = 1,
+		.expect_success = false,
+	},
+	{
+		.name = "mprotect_3way_split_at_vma_count_limit",
+		.test = mprotect_3way_split,
+		.vma_slots_needed = 0,
+		.expect_success = false,
+	},
+	{
+		.name = "munmap_nosplit_at_1_below_vma_count_limit",
+		.test = munmap_nosplit,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_nosplit_at_vma_count_limit",
+		.test = munmap_nosplit,
+		.vma_slots_needed = 0,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_2way_split_at_1_below_vma_count_limit",
+		.test = munmap_2way_split,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_2way_split_at_vma_count_limit",
+		.test = munmap_2way_split,
+		.vma_slots_needed = 0,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_3way_split_at_2_below_vma_count_limit",
+		.test = munmap_3way_split,
+		.vma_slots_needed = 2,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_3way_split_at_1_below_vma_count_limit",
+		.test = munmap_3way_split,
+		.vma_slots_needed = 1,
+		.expect_success = true,
+	},
+	{
+		.name = "munmap_3way_split_at_vma_count_limit",
+		.test = munmap_3way_split,
+		.vma_slots_needed = 0,
+		.expect_success = false,
+	},
+	{
+		.name = "mremap_dontunmap_at_required_vma_count_capcity",
+		.test = mremap_dontunmap,
+		.vma_slots_needed = MREMAP_REQUIRED_VMA_SLOTS,
+		.expect_success = true,
+	},
+	{
+		.name = "mremap_dontunmap_at_1_below_required_vma_count_capacity",
+		.test = mremap_dontunmap,
+		.vma_slots_needed = MREMAP_REQUIRED_VMA_SLOTS - 1,
+		.expect_success = false,
+	},
+};
+
+/* --- Test Runner --- */
+int main(int argc, char **argv)
+{
+	int num_tests = ARRAY_SIZE(tests);
+	int failed_tests = 0;
+
+	ksft_set_plan(num_tests);
+
+	if (!test_suite_setup() != 0) {
+		if (MAX_VMA_COUNT > DEFAULT_MAX_MAP_COUNT)
+			ksft_exit_skip("max_map_count too high and cannot be lowered\n"
+					"Please rerun as root.\n");
+		else
+			ksft_exit_fail_msg("Test suite setup failed. Aborting.\n");
+
+	}
+
+	for (int i = 0; i < num_tests; i++) {
+		int maps_to_unmap = tests[i].vma_slots_needed;
+		const char *name = tests[i].name;
+		bool test_passed;
+
+		errno = 0;
+
+		/* 1. Setup: TEST_AREA mapping */
+		if (mmap(TEST_AREA, TEST_AREA_SIZE, TEST_AREA_PROT,
+			MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, -1, 0)
+				== MAP_FAILED) {
+			ksft_test_result_fail(
+				"%s: Test setup failed to map TEST_AREA\n",
+				name);
+			maps_to_unmap = 0;
+			goto fail;
+		}
+
+		/* Label TEST_AREA to ease debugging */
+		if (prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, TEST_AREA,
+			TEST_AREA_SIZE, "TEST_AREA")) {
+			ksft_print_msg("WARNING: [%s] prctl(PR_SET_VMA) failed\n",
+					name);
+			ksft_print_msg(
+				"Continuing without named TEST_AREA mapping\n");
+		}
+
+		/* 2. Setup: Adjust VMA count based on test requirements */
+		if (maps_to_unmap > NR_EXTRA_MAPS) {
+			ksft_test_result_fail(
+				"%s: Test setup failed: Invalid VMA slots required %d\n",
+				name, tests[i].vma_slots_needed);
+			maps_to_unmap = 0;
+			goto fail;
+		}
+
+		/* Unmap extra mappings, accounting for the 1-page gap */
+		for (int j = 0; j < maps_to_unmap; j++)
+			munmap(EXTRA_MAPS + (j * 2 * EXTRA_MAP_SIZE),
+				EXTRA_MAP_SIZE);
+
+		/*
+		 * 3. Verify the preconditions.
+		 *
+		 *    Sometimes there isn't an easy way to determine the cause
+		 *    of the test failure.
+		 *    e.g. an mprotect ENOMEM may be due to trying to protect
+		 *         unmapped area or due to hitting MAX_VMA_COUNT limit.
+		 *
+		 *    We verify the preconditions of the test to ensure any
+		 *    expected failures are from the expected cause and not
+		 *    coincidental.
+		 */
+		if (!is_current_vma_count(name,
+			MAX_VMA_COUNT - tests[i].vma_slots_needed))
+			goto fail;
+
+		if (!is_test_area_mapped(name))
+			goto fail;
+
+		/* 4. Run the test */
+		test_passed = (tests[i].test() == tests[i].expect_success);
+		if (test_passed) {
+			ksft_test_result_pass("%s\n", name);
+		} else {
+fail:
+			failed_tests++;
+			ksft_test_result_fail(
+				"%s: current_vma_count=%d,max_vma_count=%d: errno: %d (%s)\n",
+				name, get_current_vma_count(), MAX_VMA_COUNT,
+				errno, strerror(errno));
+			print_surrounding_maps(name);
+		}
+
+		/* 5. Teardown: Unmap TEST_AREA. */
+		munmap(TEST_AREA, TEST_AREA_SIZE);
+
+		/* 6. Teardown: Restore extra mappings to test suite baseline */
+		for (int j = 0; j < maps_to_unmap; j++) {
+			/* Remap extra mappings, accounting for the gap */
+			mmap(EXTRA_MAPS + (j * 2 * EXTRA_MAP_SIZE),
+				EXTRA_MAP_SIZE, EXTRA_MAP_PROT,
+				MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED_NOREPLACE,
+				-1, 0);
+		}
+	}
+
+	test_suite_teardown();
+
+	if (failed_tests > 0)
+		ksft_exit_fail();
+	else
+		ksft_exit_pass();
+}
+
+/* --- Utilities --- */
+
+static int get_max_vma_count(void)
+{
+	int max_count;
+	FILE *f;
+
+	f = fopen("/proc/sys/vm/max_map_count", "r");
+	if (!f)
+		return -1;
+
+	if (fscanf(f, "%d", &max_count) != 1)
+		max_count = -1;
+
+
+	fclose(f);
+
+	return max_count;
+}
+
+static bool set_max_vma_count(int val)
+{
+	FILE *f;
+	bool success = false;
+
+	f = fopen("/proc/sys/vm/max_map_count", "w");
+	if (!f)
+		return false;
+
+	if (fprintf(f, "%d", val) > 0)
+		success = true;
+
+	fclose(f);
+	return success;
+}
+
+static int get_current_vma_count(void)
+{
+	char line[1024];
+	int count = 0;
+	FILE *f;
+
+	f = fopen("/proc/self/maps", "r");
+	if (!f)
+		return -1;
+
+	while (fgets(line, sizeof(line), f)) {
+		if (!strstr(line, "[vsyscall]"))
+			count++;
+	}
+
+	fclose(f);
+
+	return count;
+}
+
+static bool is_current_vma_count(const char *msg, int expected)
+{
+	int current = get_current_vma_count();
+
+	if (current == expected)
+		return true;
+
+	ksft_print_msg("%s: vma count is %d, expected %d\n", msg, current,
+			expected);
+	return false;
+}
+
+static bool is_test_area_mapped(const char *msg)
+{
+	unsigned long search_start = (unsigned long)TEST_AREA;
+	unsigned long search_end = search_start + TEST_AREA_SIZE;
+	bool found = false;
+	char line[1024];
+	FILE *f;
+
+	f = fopen("/proc/self/maps", "r");
+	if (!f) {
+		ksft_print_msg("failed to open /proc/self/maps\n");
+		return false;
+	}
+
+	while (fgets(line, sizeof(line), f)) {
+		unsigned long start, end;
+
+		if (sscanf(line, "%lx-%lx", &start, &end) != 2)
+			continue;
+
+		/* Check for an exact match of the range */
+		if (start == search_start && end == search_end) {
+			found = true;
+			break;
+		} else if (start > search_end) {
+			/*
+			 *Since maps are sorted, if we've passed the end, we
+			 * can stop searching.
+			 */
+			break;
+		}
+	}
+
+	fclose(f);
+
+	if (found)
+		return true;
+
+	/* Not found */
+	ksft_print_msg(
+		"%s: TEST_AREA is not mapped as a single contiguous block.\n",
+		msg);
+	print_surrounding_maps(msg);
+
+	return false;
+}
+
+static void print_surrounding_maps(const char *msg)
+{
+	unsigned long search_start = (unsigned long)TEST_AREA;
+	unsigned long search_end = search_start + TEST_AREA_SIZE;
+	unsigned long start;
+	unsigned long end;
+	char line[1024] = {};
+	int line_idx = 0;
+	int first_match_idx = -1;
+	int last_match_idx = -1;
+	FILE *f;
+
+	f = fopen("/proc/self/maps", "r");
+	if (!f)
+		return;
+
+	if (msg)
+		ksft_print_msg("%s\n", msg);
+
+	ksft_print_msg("--- Surrounding VMA entries for TEST_AREA (%p) ---\n",
+			TEST_AREA);
+
+	/* First pass: Read all lines and find the range of matching entries */
+	fseek(f, 0, SEEK_SET); /* Rewind file */
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, "%lx-%lx", &start, &end) != 2) {
+			line_idx++;
+			continue;
+		}
+
+		/* Check for any overlap */
+		if (start < search_end && end > search_start) {
+			if (first_match_idx == -1)
+				first_match_idx = line_idx;
+			last_match_idx = line_idx;
+		} else if (start > search_end) {
+			/*
+			 * Since maps are sorted, if we've passed the end, we
+			 * can stop searching.
+			 */
+			break;
+		}
+
+		line_idx++;
+	}
+
+	if (first_match_idx == -1) {
+		ksft_print_msg("TEST_AREA (%p) is not currently mapped.\n",
+				TEST_AREA);
+	} else {
+		/* Second pass: Print the relevant lines */
+		fseek(f, 0, SEEK_SET); /* Rewind file */
+		line_idx = 0;
+		while (fgets(line, sizeof(line), f)) {
+			/* Print 2 lines before the first match */
+			if (line_idx >= first_match_idx - 2 &&
+				line_idx < first_match_idx)
+				ksft_print_msg("   %s", line);
+
+			/* Print all matching TEST_AREA entries */
+			if (line_idx >= first_match_idx &&
+				line_idx <= last_match_idx)
+				ksft_print_msg(">> %s", line);
+
+			/* Print 2 lines after the last match */
+			if (line_idx > last_match_idx &&
+				line_idx <= last_match_idx + 2)
+				ksft_print_msg("   %s", line);
+
+			line_idx++;
+		}
+	}
+
+	ksft_print_msg("--------------------------------------------------\n");
+
+	fclose(f);
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..3794b50ec280 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -49,6 +49,8 @@ separated by spaces:
 	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
+- max_vma_count
+	tests for max vma_count
 - memfd_secret
 	test memfd_secret(2)
 - process_mrelease
@@ -417,6 +419,9 @@ fi # VADDR64
 # vmalloc stability smoke test
 CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
 
+# test operations against max vma count limit
+CATEGORY="max_vma_count" run_test ./max_vma_count_tests
+
 CATEGORY="mremap" run_test ./mremap_dontunmap
 
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
-- 
2.51.0.384.g4c02a37b29-goog



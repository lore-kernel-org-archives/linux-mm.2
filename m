Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 940DECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009F38E0011; Tue, 28 Oct 2025 17:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23E68E0005; Tue, 28 Oct 2025 17:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39EF8E0011; Tue, 28 Oct 2025 17:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D12968E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:26:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CC0A88592
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:26:00 +0000 (UTC)
X-FDA: 84048805680.08.FAE8085
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA15120009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:25:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pxGJdKv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 35TQBaQsKCKIMCNGUJUKPIJIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kaleshsingh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35TQBaQsKCKIMCNGUJUKPIJIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686758; a=rsa-sha256;
	cv=none;
	b=C5YxiuzPqx08pTkIxFfCGZCEjHflSTzsZC6yo9Q89V2BkgXRCWl2OiqZ8/G4HIV7c4sgqa
	G2FKjvW2ErA+wJnu0G9l7/s2i6PmyTgEI181KtNdzdixIzxHAIr8gnux2XrzeweepobXNK
	qYB3jWmDfboIMzt5Hgmi1izuDsDXxH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pxGJdKv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 35TQBaQsKCKIMCNGUJUKPIJIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kaleshsingh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35TQBaQsKCKIMCNGUJUKPIJIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLbLcz1tvBLjOal1rEhMff9IFi9MXSY2WsGm5d45WU8=;
	b=jtMxGHZZJNMIqws011j0xxZQwyZRmrSoSYfMPdStgpTbvSnjUvGoB08LrRxNPZSZMKzq14
	K593+82m1GpNnjqcJFn8sPRGhcvaQX5mU5vvsU+dv9w4YsEHLb4k2Fv0suGZ8bXtU5Z+bI
	L1Yaa+rJ/e/q7uexNYg8r+THUn0BRwQ=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737e673so10020527a12.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686757; x=1762291557; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gLbLcz1tvBLjOal1rEhMff9IFi9MXSY2WsGm5d45WU8=;
        b=1pxGJdKv7lrMj8TLP2ppthYmBXVM2CenXNZ18d2m+9JJ2Sk/1KEEQfu4SKD6YI9Lyd
         EkVkA7QQVe4r3NAm1wAGhHCamrySYbD9nnB6dpGlBgyzjUGUUoKn1YgHl5ahbeq1rlN6
         edc9e84iAqYrrrs+6P7i1Y8d2DOvnyE2hs3gHJEWa05ZMQRUN2Ag4OeQDvowqhTFE3+D
         BFplcZjBdx4lyTJJK+TcS6nOU9VFwXqerlQbfF90u1z7UVxmtnb02yl4uzIicOHijnWE
         SIj5cBsTPkK2jclw641gm82f+jL/l5cWshUDOEyQNHlZJG5Wjqg4EKZARQNPXtTnOIPQ
         JeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686757; x=1762291557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gLbLcz1tvBLjOal1rEhMff9IFi9MXSY2WsGm5d45WU8=;
        b=leKGechDmKxAK0LXn3qQa6YKhdmn2IIw0Fp7yIqKD2OWFh2NuE1bgWjOJtaxzMyKWG
         8yHn4Q16HgKdjsObKurOywil2tYyLotIiSGve5sCfSEKmtoypp2KZgoD2cKMjj4rSkJR
         E8a04A3PI44OYl17sfz68pk9CX1IRvdUwegDuF4K0qXJImoXKGp4TBiUFMappO+qPj4T
         DbbfYr+CJbMrEE2kNrl3+oXjdfNTGVGJdY3oD/asmzRY5r5Ml4cEUFcA/vCRfgevZawy
         XilJ/plEsKvUC0Ocu1bPk+YxsyGOPbRPPt30AWUrTFB99QnmpKOdAmD9PM4GfuqFfJb9
         L6zg==
X-Forwarded-Encrypted: i=1; AJvYcCXSUuqdNO22izJ5c+EMRe5QNV8cGxwVDwEVnaZSV5WSegfvgm6PoFJj20cXLdYzq7so4AH5SyOTrw==@kvack.org
X-Gm-Message-State: AOJu0YzLWUCNGjy9c/CWxcoVkhpYOJJBpFD8PuFtkmE59Em4P8OlSdZZ
	HCex/xj93buggF2HM2YgBUHPHuIdm1ggp/28ls940EVgQoDgg6uT46Kk1NPHsYwrTQ77ReLSuyp
	WoQCVaQECceCbCMcLyOmYnS03nQ==
X-Google-Smtp-Source: AGHT+IEze/eBTT4KV5aTZ/y2OiV0hfGKOowJUE2YZOWdslZc8mDAMS+W2BUhSvvuUedd2YrveZW7HHFMi4VYQ1US1g==
X-Received: from pjbfv10.prod.google.com ([2002:a17:90b:e8a:b0:33b:ab61:4f71])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3384:b0:32b:721e:ced1 with SMTP id adf61e73a8af0-34659600236mr497526637.36.1761686757301;
 Tue, 28 Oct 2025 14:25:57 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:24:33 -0700
In-Reply-To: <20251028212528.681081-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251028212528.681081-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212528.681081-3-kaleshsingh@google.com>
Subject: [PATCH v4 2/5] mm/selftests: add max_vma_count tests
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com, 
	android-mm@google.com, Kalesh Singh <kaleshsingh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA15120009
X-Stat-Signature: o57qs7igj3eppbd9a7zkpfpixwisq8yw
X-HE-Tag: 1761686758-633720
X-HE-Meta: U2FsdGVkX18Ht6q76rilDdP5EIUYiVrT/fXfcJSca0yBd00rFg0wsUz+23Xd7fcmavbKf+fM/MGJRFt1fGhQILMnfqUQQkvmo2DLfHovYydsr8T59fmNDcM4Wa775IT4wsa9aufayrULGv1Wr+m6F6tJWqdCb3sdnFfo9OsUUL3TvMxYa5P/QDS4v2MTnicJQx7UqzFaPzxjB1kWn5NfoWM8W+w0BZbTY40nTc+8xEnmJFn2oXa3vf4qpUwq5tjnIecvfSsCmGS5ZchmD3+j9wR6SMEqtyiQLl0opXvWQtWkuFZH7rWH/DZ2T033SbBUMuhhLbvhdIIIy1uwh/3r4qeoJy9yNHytrB4NZmoqptKnfBT33cof7TFA+i9MCEUkV+GJ7XqFGYNLxP18UYoqUm4FyGHMKNRtKBT6Lwd2vxw2J4hhbvbd/gX5EUUqBa6N34qZm7vNZF3JzdjDkHH00ea34jYNyf5owXOhW/KRDzGw2G2VvUAayykILv7bjX1Q91vEICfMhlLa181nMQMLpriobEhHEutLsuSAGRrqhXIh431fQkzSpyObEEHkRHS1AzsH0jteoXna8J5JOHZpmhwzmzxs6KhPB/vscDUZt6StAStI86chz4OPD6uwd7piYSscjs3v28ilGZLRoJvzYeMCPrrYThDZbbAYqcO+weimyrAhABV7qsOuWu95SID81V8Sb/NMlFNq4Z3cLUUxe3q20jQk5p7OU+l/3J4nAIB4ccKzUtSNxwv/QWhJQCVf62TLoQxkobUjj/vSIBlk0PP9np/snpkNmN45Ovg+ue4Oq4dK7dTpUeaDpqUGsjUZ2uQ2PR4w546ZG6aobSfqMPwQ9ryvPTmzLiaU4GxhPmtpJ2OZALll4CxSIvuOnD6cwE108rKFksz3bN8hk6IlRMoA6LiKcNc40Vgu6WWbfFC4ipe3bn8E4r9v+ruMFHHFjOltSpt/354iPlv05zS
 S3H6yBLi
 3psu726HRWM52JTejWvg1cwqXtemWkbkixbyqb9xSMgo9p8lV+Z8sQDKoxyzVs/RFX9BvK0WulupxyYn62RaAXr4u9dJJs2til42Jhe71jRReLq4U9+D8um01/5ciF9TIa+UyuB7zYNRQoo7mfSemFziBjqMNc/eFK0U6J3tdJuVUpMeU3BsYhbfKi/6iF3rUvN8vnxyEph3VVBDO8m2jhlGo6PeHWRGaOAymsHR5xDHe4iwZ32/W9PIB23Aw6FSlhS054FLgZdMlgO5DGtvTqF0xTZoCtDb8AaeMbnnA6QIOA3cJk9+A2Or3tuvsHfznVs1NSJTVTO2fmzTIXtvLurYYtAnQV05hH+8EpTm9F4tOPAvvNyjpm1S8xbNB2MuKubb17mXcOEb2jchzgt5c0Kl7HgbVJsfvDn0MiiN76pmUBRKXewOMZJ9WaHp7nFCLc4YTU9JNWs1aAShXxR8VWwG+rgOeoYVak+5dsNIAwvnHZdoZSI1CPEQ4U23pxiHafxFGkbTieSibEqeQ+WaQpxS9D4vzT46vGd0dXT3+8bC+bFT8/S4Pv9x71NiOATnPeR8BKcyaRJOv3hsE1+ERqoURNf8+01YoulYDn5jW4Y4qETQQJMN4/hL0re2G5qXFVm7kOvbJrM1WKm7bvUDUrnVhmXgmaKKED7WWNj0X6p51nS1Uudu27vye1J9jpxte7mcYdx0EcTAQQGCyI3vi9E1LeJm9rPfUe3JbCezaKkkoM61NUWDUt2OP2wIlboUcWmTo
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

Changes in v4:
 - Update the mmap test cases to correctly validate the historical
   lenient behavior discussed in the v3 review. The test now confirms
   that an mmap() call succeeds at the limit and fails when one above
   the limit.
 - Add comments to the test code to document this expected behavior.

Changes in v3:
 - Rewrite test using kselftest harness, per Lorenzo
 - Update test diagram to be vertical so as to not exceed 80 chars, per Lorenzo
 - Use vm_util.h helpers, per Lorenzo
 - Update .gitignore, per Lorenzo
 - Add max_vma_count_tests to MEMORY MAPPING section in MAINTAINERS, per
   Lorenzo
 - Remove /proc/*/maps debugging prints and globals, per Lorenzo
 - rename guard regions to holes to avoid confusion with VMA guard
   regions, per David

Changes in v2:
 - Add tests, per Liam (note that the do_brk_flags() path is not easily
   tested from userspace, so it's not included here). Exceeding the limit there
   should be uncommon.

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/max_vma_count_tests.c        | 716 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 5 files changed, 724 insertions(+)
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 51aa95b80034..66f7ca5b01ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16581,6 +16581,7 @@ F:	mm/vma.h
 F:	mm/vma_exec.c
 F:	mm/vma_init.c
 F:	mm/vma_internal.h
+F:	tools/testing/selftests/mm/max_vma_count_tests.c
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index c2a8586e51a1..010f1bced5b9 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -10,6 +10,7 @@ hugetlb-soft-offline
 khugepaged
 map_hugetlb
 map_populate
+max_vma_count_tests
 thuge-gen
 compaction_test
 migration
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7..4f0b03cdece5 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -93,6 +93,7 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
+TEST_GEN_FILES += max_vma_count_tests
 TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
diff --git a/tools/testing/selftests/mm/max_vma_count_tests.c b/tools/testing/selftests/mm/max_vma_count_tests.c
new file mode 100644
index 000000000000..7506f44321a9
--- /dev/null
+++ b/tools/testing/selftests/mm/max_vma_count_tests.c
@@ -0,0 +1,716 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2025 Google LLC
+ */
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <linux/prctl.h>  /* Definition of PR_* constants */
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <unistd.h>
+
+#define TH_LOG_ENABLED			0
+#include "../kselftest_harness.h"
+#include "vm_util.h"
+
+#define DEFAULT_MAX_MAP_COUNT		65530
+#define TEST_AREA_NR_PAGES		3
+#define TEST_AREA_PROT			(PROT_NONE)
+#define EXTRA_MAP_PROT			(PROT_NONE)
+
+/* mremap accounts for the worst case to fail early */
+#define MREMAP_REQUIRED_VMA_SLOTS	6
+
+FIXTURE(max_vma_count) {
+	int max_vma_count;
+	int original_max_vma_count;
+	int test_area_size;
+	int nr_extra_maps;
+	char *test_area;
+	char *extra_maps;
+};
+
+/* To keep checkpatch happy */
+#define max_vma_count_data_t FIXTURE_DATA(max_vma_count)
+
+static int get_max_vma_count(void);
+static bool set_max_vma_count(int val);
+static int get_current_vma_count(void);
+static bool is_test_area_mapped(char *test_area, int test_area_size);
+static bool lower_max_map_count_if_needed(max_vma_count_data_t *self,
+					  struct __test_metadata *_metadata);
+static void restore_max_map_count_if_needed(max_vma_count_data_t *self,
+					    struct __test_metadata *_metadata);
+static bool free_vma_slots(max_vma_count_data_t *self, int slots_to_free);
+static void create_reservation(max_vma_count_data_t *self,
+			       struct __test_metadata *_metadata);
+static void create_extra_maps(max_vma_count_data_t *self,
+			      struct __test_metadata *_metadata);
+
+/**
+ * FIXTURE_SETUP - Sets up the VMA layout for max VMA count testing.
+ *
+ * Sets up a specific VMA layout to test behavior near the max_vma_count limit.
+ * A large memory area is reserved and then unmapped to create a contiguous
+ * address space. Mappings are then created within this space.
+ *
+ * The layout is as follows (addresses increase downwards):
+ *
+ *  base_addr --> +----------------------+
+ *                |      Hole (1 page)   |
+ *                +----------------------+
+ *  TEST_AREA --> |      TEST_AREA       |
+ *                | (unmapped, 3 pages)  |
+ *                +----------------------+
+ *                |      Hole (1 page)   |
+ *                +----------------------+
+ * EXTRA_MAPS --> | Extra Map 1 (1 page) |
+ *                +----------------------+
+ *                |      Hole (1 page)   |
+ *                +----------------------+
+ *                | Extra Map 2 (1 page) |
+ *                +----------------------+
+ *                |         ...          |
+ *                +----------------------+
+ *                | Extra Map N (1 page) |
+ *                +----------------------+
+ *                |      Hole (1 page)   |
+ *                +----------------------+
+ *
+ * "Holes" are unmapped, 1-page gaps used to isolate mappings.
+ * The number of "Extra Maps" is calculated to bring the total VMA count
+ * to MAX_VMA_COUNT - 1.
+ *
+ * Populates TEST_AREA and other globals required for the tests.
+ *
+ * Return: true on success, false on failure.
+ */
+FIXTURE_SETUP(max_vma_count)
+{
+	int initial_vma_count;
+
+	TH_LOG("Setting up vma_max_count test ...");
+
+	self->test_area_size = TEST_AREA_NR_PAGES * psize();
+
+	if (!lower_max_map_count_if_needed(self, _metadata)) {
+		SKIP(return,
+		     "max_map_count too high and cannot be lowered. Please rerun as root.");
+	}
+
+	initial_vma_count = get_current_vma_count();
+	ASSERT_GT(initial_vma_count, 0);
+
+	self->nr_extra_maps = self->max_vma_count - 1 - initial_vma_count;
+	if (self->nr_extra_maps < 1) {
+		SKIP(return,
+		    "Not enough available maps to run test (max: %d, current: %d)",
+		     self->max_vma_count, initial_vma_count);
+	}
+
+	create_reservation(self, _metadata);
+	create_extra_maps(self, _metadata);
+
+	ASSERT_EQ(get_current_vma_count(), self->max_vma_count - 1);
+	TH_LOG("vma_max_count test setup done.");
+}
+
+FIXTURE_TEARDOWN(max_vma_count)
+{
+	/*
+	 * NOTE: Each test is run in a separate process; we leave
+	 * mapping cleanup to process teardown for simplicity.
+	 */
+
+	restore_max_map_count_if_needed(self, _metadata);
+}
+
+static bool mmap_anon(max_vma_count_data_t *self)
+{
+	void *addr =  mmap(NULL, psize(), PROT_READ,
+			   MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
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
+static bool mprotect_nosplit(max_vma_count_data_t *self)
+{
+	return __mprotect(self->test_area, self->test_area_size);
+}
+
+static bool mprotect_2way_split(max_vma_count_data_t *self)
+{
+	return __mprotect(self->test_area, self->test_area_size - psize());
+}
+
+static bool mprotect_3way_split(max_vma_count_data_t *self)
+{
+	return __mprotect(self->test_area + psize(), psize());
+}
+
+static inline bool __munmap(char *addr, int size)
+{
+	return munmap(addr, size) == 0;
+}
+
+static bool munmap_nosplit(max_vma_count_data_t *self)
+{
+	return __munmap(self->test_area, self->test_area_size);
+}
+
+static bool munmap_2way_split(max_vma_count_data_t *self)
+{
+	return __munmap(self->test_area, self->test_area_size - psize());
+}
+
+static bool munmap_3way_split(max_vma_count_data_t *self)
+{
+	return __munmap(self->test_area + psize(), psize());
+}
+
+static bool mremap_dontunmap(max_vma_count_data_t *self)
+{
+	/*
+	 * Using MREMAP_DONTUNMAP will create a new mapping without
+	 * removing the old one, consuming one VMA slot.
+	 */
+	return mremap(self->test_area, self->test_area_size,
+		      self->test_area_size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		      NULL) != MAP_FAILED;
+}
+
+TEST_F(max_vma_count, mmap_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mmap_anon(self));
+}
+
+TEST_F(max_vma_count, mmap_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	/*
+	 * Validate the historical lenient behavior of mmap() at the VMA limit.
+	 *
+	 * Unlike stricter syscalls (e.g., mprotect(), mremap()) that fail
+	 * preemptively at the limit, mmap() is allowed to proceed. This is
+	 * because the new mapping may merge with an adjacent VMA, in which
+	 * case a new VMA slot is not consumed.
+	 *
+	 * This test confirms that an mmap() call at exactly the
+	 * sysctl_max_map_count limit succeeds, preserving this behavior.
+	 */
+	ASSERT_TRUE(mmap_anon(self));
+}
+
+TEST_F(max_vma_count, mmap_at_1_above_vma_count_limit)
+{
+	/*
+	 * Verify the upper bound of the lenient mmap() behavior.
+	 *
+	 * The previous test confirms mmap() can succeed at the VMA limit,
+	 * potentially bringing the count to limit + 1. This test ensures
+	 * that this behavior does not permit unrestricted growth.
+	 *
+	 * We first perform one successful mmap() to exceed the limit, then
+	 * assert that the subsequent mmap() call fails as expected.
+	 */
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mmap_anon(self));
+
+	/*
+	 * We are now 1 above the vma_count_limit.
+	 * Test that unrestricted growth of VMAs is prevented.
+	 */
+	ASSERT_FALSE(mmap_anon(self));
+}
+
+TEST_F(max_vma_count, mprotect_nosplit_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mprotect_nosplit(self));
+}
+
+TEST_F(max_vma_count, mprotect_nosplit_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mprotect_nosplit(self));
+}
+
+TEST_F(max_vma_count, mprotect_2way_split_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mprotect_2way_split(self));
+}
+
+TEST_F(max_vma_count, mprotect_2way_split_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_FALSE(mprotect_2way_split(self));
+}
+
+TEST_F(max_vma_count, mprotect_3way_split_at_2_below_vma_count_limit)
+{
+	int vma_slots_needed = 2;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mprotect_3way_split(self));
+}
+
+TEST_F(max_vma_count, mprotect_3way_split_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_FALSE(mprotect_3way_split(self));
+}
+
+TEST_F(max_vma_count, mprotect_3way_split_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_FALSE(mprotect_3way_split(self));
+}
+
+TEST_F(max_vma_count, munmap_nosplit_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_nosplit(self));
+}
+
+TEST_F(max_vma_count, munmap_nosplit_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_nosplit(self));
+}
+
+TEST_F(max_vma_count, munmap_2way_split_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_2way_split(self));
+}
+
+TEST_F(max_vma_count, munmap_2way_split_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_2way_split(self));
+}
+
+TEST_F(max_vma_count, munmap_3way_split_at_2_below_vma_count_limit)
+{
+	int vma_slots_needed = 2;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_3way_split(self));
+}
+
+TEST_F(max_vma_count, munmap_3way_split_at_1_below_vma_count_limit)
+{
+	int vma_slots_needed = 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(munmap_3way_split(self));
+}
+
+TEST_F(max_vma_count, munmap_3way_split_at_vma_count_limit)
+{
+	int vma_slots_needed = 0;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_FALSE(munmap_3way_split(self));
+}
+
+TEST_F(max_vma_count, mremap_dontunmap_at_required_vma_count_capcity)
+{
+	int vma_slots_needed = MREMAP_REQUIRED_VMA_SLOTS;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_TRUE(mremap_dontunmap(self));
+}
+
+TEST_F(max_vma_count, mremap_dontunmap_at_1_below_required_vma_count_capacity)
+{
+	int vma_slots_needed = MREMAP_REQUIRED_VMA_SLOTS - 1;
+
+	ASSERT_NE(mmap(self->test_area, self->test_area_size, TEST_AREA_PROT,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  MAP_FAILED);
+
+	ASSERT_TRUE(free_vma_slots(self, vma_slots_needed));
+
+	ASSERT_EQ(get_current_vma_count(),
+		  self->max_vma_count - vma_slots_needed);
+	ASSERT_TRUE(is_test_area_mapped(self->test_area, self->test_area_size));
+
+	ASSERT_FALSE(mremap_dontunmap(self));
+}
+
+TEST_HARNESS_MAIN
+
+/* --- Utilities --- */
+
+static bool lower_max_map_count_if_needed(max_vma_count_data_t *self,
+			      struct __test_metadata *_metadata)
+{
+	self->max_vma_count = get_max_vma_count();
+
+	ASSERT_GT(self->max_vma_count, 0);
+
+	self->original_max_vma_count = 0;
+	if (self->max_vma_count > DEFAULT_MAX_MAP_COUNT) {
+		self->original_max_vma_count = self->max_vma_count;
+		TH_LOG("Max VMA count: %d; lowering to default %d for test...",
+		       self->max_vma_count, DEFAULT_MAX_MAP_COUNT);
+
+		if (!set_max_vma_count(DEFAULT_MAX_MAP_COUNT))
+			return false;
+		self->max_vma_count = DEFAULT_MAX_MAP_COUNT;
+	}
+	return true;
+}
+
+static void restore_max_map_count_if_needed(max_vma_count_data_t *self,
+					    struct __test_metadata *_metadata)
+{
+	if (!self->original_max_vma_count)
+		return;
+
+	if (self->max_vma_count == self->original_max_vma_count)
+		return;
+
+	if (!set_max_vma_count(self->original_max_vma_count))
+		TH_LOG("Failed to restore max_map_count to %d",
+			self->original_max_vma_count);
+}
+
+static int get_max_vma_count(void)
+{
+	unsigned long val;
+	int ret;
+
+	ret = read_sysfs("/proc/sys/vm/max_map_count", &val);
+	if (ret)
+		return -1;
+	return val;
+}
+
+static bool set_max_vma_count(int val)
+{
+	return write_sysfs("/proc/sys/vm/max_map_count", val) == 0;
+}
+
+static int get_current_vma_count(void)
+{
+	struct procmap_fd pmap;
+	int count = 0;
+	int ret;
+	char vma_name[PATH_MAX];
+
+	ret = open_self_procmap(&pmap);
+	if (ret)
+		return -1;
+
+	pmap.query.query_addr = 0;
+	pmap.query.query_flags = PROCMAP_QUERY_COVERING_OR_NEXT_VMA;
+
+	while (true) {
+		pmap.query.vma_name_addr = (uint64_t)(uintptr_t)vma_name;
+		pmap.query.vma_name_size = sizeof(vma_name);
+		vma_name[0] = '\0';
+
+		ret = query_procmap(&pmap);
+		if (ret != 0)
+			break;
+
+		/*
+		 * The [vsyscall] mapping is a special mapping that
+		 * doesn't count against the max_map_count limit.
+		 * Ignore it here to match the kernel's accounting.
+		 */
+		if (strcmp(vma_name, "[vsyscall]") != 0)
+			count++;
+
+		pmap.query.query_addr = pmap.query.vma_end;
+	}
+
+	close_procmap(&pmap);
+	return count;
+}
+
+static void create_reservation(max_vma_count_data_t *self,
+			       struct __test_metadata *_metadata)
+{
+	size_t reservation_size;
+	void *base_addr = NULL;
+
+	/*
+	 * To break the dependency on knowing the exact number of extra maps
+	 * before creating the reservation, we allocate a reservation size
+	 * large enough for the maximum possible number of extra maps.
+	 * The maximum number of extra maps is bounded by max_vma_count.
+	 */
+	reservation_size = ((self->max_vma_count * 2) +
+				TEST_AREA_NR_PAGES +
+				2 /* Holes around TEST_AREA */) * psize();
+
+	base_addr = mmap(NULL, reservation_size, PROT_NONE,
+			MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(base_addr, MAP_FAILED);
+
+	ASSERT_EQ(munmap(base_addr, reservation_size), 0);
+
+	/* The test area is offset by one hole page from the base address. */
+	self->test_area = (char *)base_addr + psize();
+
+	/* The extra maps start after the test area and another hole page. */
+	self->extra_maps = self->test_area + self->test_area_size + psize();
+}
+
+static void create_extra_maps(max_vma_count_data_t *self,
+			    struct __test_metadata *_metadata)
+{
+	char *ptr = self->extra_maps;
+
+	for (int i = 0; i < self->nr_extra_maps; ++i) {
+		ASSERT_NE(mmap(ptr, psize(), EXTRA_MAP_PROT,
+			MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED_NOREPLACE,
+			-1, 0), MAP_FAILED) {
+			TH_LOG("Failed on mapping #%d of %d", i + 1,
+				self->nr_extra_maps);
+		}
+
+		/*
+		 * Advance pointer by two pages to leave a 1-page hole,
+		 * after each 1-page map.
+		 */
+		ptr += (2 * psize());
+	}
+}
+
+static bool free_vma_slots(max_vma_count_data_t *self, int slots_to_free)
+{
+	for (int i = 0; i < slots_to_free; i++) {
+		if (munmap(self->extra_maps + (i * 2 * psize()), psize()) != 0)
+			return false;
+	}
+
+	return true;
+}
+
+static bool is_test_area_mapped(char *test_area, int test_area_size)
+{
+	struct procmap_fd pmap;
+	bool found = false;
+	int ret;
+
+	ret = open_self_procmap(&pmap);
+	if (ret)
+		return false;
+
+	pmap.query.query_addr = (uint64_t)(uintptr_t)test_area;
+	pmap.query.query_flags = 0; /* Find VMA covering address */
+
+	if (query_procmap(&pmap) == 0 &&
+	    pmap.query.vma_start == (unsigned long)test_area &&
+	    pmap.query.vma_end == (unsigned long)test_area + test_area_size)
+		found = true;
+
+	close_procmap(&pmap);
+	return found;
+}
+
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..a85db61e6a92 100755
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
@@ -426,6 +428,9 @@ fi # VADDR64
 # vmalloc stability smoke test
 CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
 
+# test operations against max vma count limit
+CATEGORY="max_vma_count" run_test ./max_vma_count_tests
+
 CATEGORY="mremap" run_test ./mremap_dontunmap
 
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
-- 
2.51.1.851.g4ebd6896fd-goog



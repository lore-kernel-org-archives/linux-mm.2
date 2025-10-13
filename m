Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89CECCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C068E0043; Mon, 13 Oct 2025 19:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BFC8E0024; Mon, 13 Oct 2025 19:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EF68E0043; Mon, 13 Oct 2025 19:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9BD8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:56:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 804E9C0696
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:01 +0000 (UTC)
X-FDA: 83994751722.20.477B9B4
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E003180007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:55:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cd7IDM5A;
	spf=pass (imf06.hostedemail.com: domain of 3jpHtaAsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3jpHtaAsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p2Gmm9GtTiEQdmbv7JHe7F8yU5Dt+w0nJ/mtKbQefE=;
	b=vIzCyJ9f1vgmNQWUqhCSyupG/hRgT7yZA6uuBhTYdU7yzDeqZkBma5L0vvGYuzzNqFMWMV
	WMzDd2J5alVQXTcLUGQizMhVVb1AsSozKFPNYWfIERMgFVoOjVRS5ZD+1R3LwYB/v6xII3
	8REANm+cCXuopFMO6VQzM0M42jtVXTc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cd7IDM5A;
	spf=pass (imf06.hostedemail.com: domain of 3jpHtaAsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3jpHtaAsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399759; a=rsa-sha256;
	cv=none;
	b=sokillJBJeFoCYmOLSd1OK/TDXm/v5dAULiPb9fPf2hno/DHFv8H99cJzWr4Ep+T8rDEpm
	N7/9uLk0Qtm4Czjf0SRtY9iRdaYvJHooYX5kP9VBomiKdmMLFiQTynUQoS5eopI2jVNXIw
	nwELH2iLb7MUHPdR0AD7PfgDsvN+ruw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befbbaso11334967a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399758; x=1761004558; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6p2Gmm9GtTiEQdmbv7JHe7F8yU5Dt+w0nJ/mtKbQefE=;
        b=Cd7IDM5AlYMDWyI/lEgbHjo+UAfvGA3LZLmwNpx2XPicT5ELPgO1ZVCQPhcSbRJYTy
         ZjnXuOH+lOSz+KXW6dQdnHZQ08LBLD6KQG6/Ky2gnUpakcp/ndElFjaWtFahIPlFTSTF
         tc/MkmqTMO1KjQA1gBAjNtoRXQ+5mb6fjgzrWXChnqYyFTAvDZ3s3IWOcjUsxhDweBBY
         VOA6eZCCa918bmLONEsp8TddWojWH49tLxpalsb4G/sRcyhDIJ3VjJINgZnbIuznNheE
         4FTHP4zR4R2jSiY8xdxrotdYikDQIKPZR9Rt3XpAVwoCG8wNhgPvkxGAvjMh/c40n2z3
         WlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399758; x=1761004558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6p2Gmm9GtTiEQdmbv7JHe7F8yU5Dt+w0nJ/mtKbQefE=;
        b=qRoJo6QDy8o+o9OCSHytMlgAegvLo9FIc/HIkh2lXbBaBdFsoYEYBMf6jqr9JuP4Vo
         QrbwirYxc94ARTB7cFrcB2MOvnN0ZiYXKgkeawN7pMskFqsirC3+entGQjPGjLj5uQGb
         W16+S+gVF1ZvwFwOcS0nK1PzU+wTz4vjDRps8bX0mydNPqiQ+1dgKEoK1eJtNVbIwzKT
         g7gEidYjRXadtbnTE8mjQWn1UJ+OkqfzKsfLoFrUawEHnHs5rYj6bQJpQQ/YkPe7k76C
         gXxvVL+vHmfPHCSnPMaTJGshsp9FJc0Bi8wzQKNN596Pk+PMYZVhemHveKfZ46LOgXiS
         gM7w==
X-Forwarded-Encrypted: i=1; AJvYcCVizyejTF74craxrjLii67z/tQfonf40XVUODs+ukrGfBvJLGYUZdQCCUV29/Bc/SdUYM4ly+Iuag==@kvack.org
X-Gm-Message-State: AOJu0Ywbzp7NHTxzKGemBsueMB+/PIVldrwHBZrg6z1Ac/uc6NKc6mEN
	YtCNUfSMjmU6udNd+bJWV4sa4df2v4veCUjSx7FR/D7kjJsY3Fwy9uiCQ7pZD4vm+2Po880jPm/
	QlZyyL1lejpKY0FS+JP2NLYHqwA==
X-Google-Smtp-Source: AGHT+IHhEwrS3IPzet5E/srq6uBByaIE766KKBgKWp333caW+apU3r/fUvgm9e93/+DRYdrbE6IkdsCUBvqSiVDuog==
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:334:1935:56cc])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d0a:b0:32e:87f6:f5a6 with SMTP id 98e67ed59e1d1-33b50f2300dmr31575363a91.0.1760399758339;
 Mon, 13 Oct 2025 16:55:58 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:53 -0700
In-Reply-To: <20251013235259.589015-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-3-kaleshsingh@google.com>
Subject: [PATCH v3 2/5] mm/selftests: add max_vma_count tests
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8E003180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: q16638w75n87khcz7ns4z1s9qexawd1f
X-HE-Tag: 1760399759-617776
X-HE-Meta: U2FsdGVkX1+UqlPMgXja37oEwTycAOAU8mPn+p6PRLAARmfoKUOxcBAY1hF240oUH6ycxiXXu5ZEjFfdhFGGaGRCagvlYr9e8zF8NVeyv5wiUDZfsbhJj95Vgd3PkMH8UMBB8lkCpMSrKFgoxOqy1w1KNntsHFLSOJuOzw8Mg2nEPN7SnMDacFbqhSr2MBcv6/XEP0qorbo2C+j0lZd/yYv5Yfgk2GzAau4/R0R+Mi9o+ayVwchuRXjj220jaWI+e9g0D0yL6XSxtU9w9w6xh58o9YL+vd0t6E772XN+uLR6a9VhM93/N6BhEIEaYdZhLisJd8sr/VVJfu4qtWMAUe0gTrNfLWbpplRFVvvvF34RlCTuLpKKglDA/N3lBHwUPr55ckPQODoQTxOi774rHjIXHhBE6Hh07gP0+bwMskLvUpGQiH7nq4F1snMgj0uptqaex9Secb5Q15ceo8e14I00sdZ3zJaqTeRWduamPuAimaZuypPjTXEW8Jf+ecxAk7RE4JtWXiDcgYxfchtyDl6D3BgrQvwy0UT6QHQlRmlN4bWp38xROnFhmBHIAdOQKY+k78eGNjvHFWwro71EeX27qmdNX2j9b9Y3MAlDH/XddbwrQ4XFLFSrLQKDI0p2je/xdXUM+j3TiBk27Ik4WBjjXNAU0xs2NpT/hzqoYOV3x/IO5DiWab8a6VrUCe3/eDeS4jzh60noJ5ktC7luhASDNsevYSRAuQavSom3HZGRFdSYW4k5WnVRt/rj0YIh5mhkoorfUsOkzXjJXU+jvMzKcgB/bHjqyj+ug8aKtqQxCBuBZzkPfRJhWeMGJEQPkxP/+0MQO4efQyUmeMvZwP0jiBDgxi4GCIkWhwhhNMT/kN1QKXN+WOfyeBCJmL0IQHbBTiBTyzTL+2PiZZ3dZ8gs3AIZifP7W+vn+KxWT/HN37JTeOHB6n4c0fXZ7X42zbNMpGse1dBr9J/51+J
 ql3nTcrb
 lg5H3k2e8Zid6IOx3cKavtcY7jSj6urtrO9M6m3pdAlypr4Vwr5UnE/mVBLE/C5IJq2ELrgc1Ge9T9Y2DkYCShfCoXSNxocf08RhXRltIAAcKP5od/N8RZJGWC6asLPhynvg/l8/QM3jKnVTYd+J7ebuo0tR5hHJIo8nZk/t+weQEplvfcUHvGTa4nV8tOvruNEf3TRuXeupgsh/z8ztOeGo/mTHq96w/8xXEhT94gJukaKosfGJgV9kV1SRSDpGhbanyql1//StpshiwLiDr+ng5EOuVMvCcaesnSySsCuF/giFf+ZbMszYAx/BO/VJVHal5Hi22E9i/vUnppCHDB11mtOStXsiSZR5DJkh1Gcht6fAP5aiaJ7D9pnIDn0KUmJ+1/Y2cYBE7JowFzUpjRUPL6NMHQhfw+1nNXd8lsZsC+mUtKlbPYI9RXLtO72Yf0JypbXk6TwyAfZFUVdKSPHWgT0ntp8oktCXzcXGawxO0lyhvWwxRYqHSj/NR1fA2JlHY8JAkTPbuYFFiR2CIHl5lhN7Jn6RS5GDPK6JBs+1YxbkyYP6SRgNnrp5D8I7TucAyB2tUAY6rNXL74Tw+1QHp4zBC/BTInCYWDZdqF/fLbTb/OmJR7unv13O1y0Mgz7IyfRWd5HX40qANgWrH2i2q9TbBBJHbojtzEBtXjTNCEsCAsprCuhOEpK1K17p9ig++R/cRzK7IlBHxpencd5LdJCCtFu/Szb2SD+825YkmRgVaQXOYmChIApBp3GS9r7hs
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
 .../selftests/mm/max_vma_count_tests.c        | 672 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 5 files changed, 680 insertions(+)
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..aa83e5893e16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16580,6 +16580,7 @@ F:	mm/vma.h
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
index 000000000000..2c69c6986633
--- /dev/null
+++ b/tools/testing/selftests/mm/max_vma_count_tests.c
@@ -0,0 +1,672 @@
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
2.51.0.760.g7b8bcc2412-goog



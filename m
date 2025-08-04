Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BE1C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168366B00A2; Mon,  4 Aug 2025 11:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1182E6B00A4; Mon,  4 Aug 2025 11:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA626B00BD; Mon,  4 Aug 2025 11:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5A1D6B00A2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C47C5889D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:46 +0000 (UTC)
X-FDA: 83739495252.04.2BAF3C1
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7AD9180002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSFsOF0o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322224; a=rsa-sha256;
	cv=none;
	b=7Q17S/P+86z7PqHEGBYlxLL/qqHe/mRwMe5h8g6BW26Vm3bMayFuqol3J0xf+qfB8Aqe+G
	IH+91FzHDSgB06LhNmaoyKCKDeikJzs8fvSPpTHGEEZM+A3Su/c5PXUbhI7pH+uPj21SGF
	57FC9yMfGwQND5RZ+/egaR/qi87IidE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSFsOF0o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ev6ABJetleEJTk7asnC+VOI2GS3gzwPELlTq9+6FP9k=;
	b=D5JYCbfsqZz4H2T3E4OVU1oEGdCrMMMX32tushnvPfbeDz3qIJ5uaAYBv+AgguWbfEsbji
	VFnEc5IV72HW+dUYHsGjZPyZ2vqtsFQxTsCFQI7STxtC5ppy9wkTWAPuLEM/SjWHpjYmt9
	hIAbkx6X1KHkaanO5I1J6USyHTc/zwI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b0619a353dso11007121cf.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322224; x=1754927024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ev6ABJetleEJTk7asnC+VOI2GS3gzwPELlTq9+6FP9k=;
        b=kSFsOF0oZOieJcwBkpYVkJvZ6JGlGx3fKLxKD2muus7BnzA+PTF0VzspEOem72OpcR
         u/U3lRXX6v0npHLhoWrZQeXXOodxGC9XvKhcdl3lGyF9q3NovP/s5FGFq6Okn3t5Zhsv
         gdyjqGd2k/IGXdrKCJ05M3gml/WZ8CatB1C/WkMgKVZMMTmfFRmr+3bSa1U41sksB7rr
         fLH8Gr/WXBTv57E4ZzxdlqBVWhuX0lKogrcf0asnaIO6WiTbZXqHOFIZcbTSL07gB7cU
         ltNX+C7tEUAgFIX3Q/24C1V4yGukuswgYO9vYnk9Yc96IqRcw6icKQh7ybU6GNpv4Ejf
         XSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322224; x=1754927024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ev6ABJetleEJTk7asnC+VOI2GS3gzwPELlTq9+6FP9k=;
        b=r63rzMkdTyPkrQZHOq1fdtLOBW3Y9H89evhTc3LUJ/wUZkaB1FlVxvU/6bHUZczFqC
         Kuz9et4BNxsfgnPA5gMLd125koi6VJxN7tdeaj1PiFQ2G4f/F7MAfeISM0NGFjJU7jh1
         398zaEamncy+UiB5no1ZUZeHPVFylWMO3nwbrtybtjvUctWf86NLP/Ikd/2NiDG75Vnc
         YcKYrt27U06C0ATPICCu88TUpuD1/uUvkzsp+UcZGyqZrSt/vPs/4Jn+TE3i9zCILIE4
         ghS7U6IRGqnCx7GiWHFLWQ/OXo6T9fjxPPVLlcuS7ThgYHMrHpOy/AF/VdrP/okiy002
         pumQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiivB1NKrf6zRNBS8JgaFkTM7ITUaYDmkryO3PSbMJyTv/ehsRjWdP4RjsNgpf865LJg1ERYNt8w==@kvack.org
X-Gm-Message-State: AOJu0YyegPgSbxq3UP78K0SyXGAfUaj97RfmA1HGDTMfOpcte7OTrya6
	TJcVR6LjH+8o20G2Rtx6i1skvj7uQHBdubptIVTD+Z9pV/a7MZmD4rOR
X-Gm-Gg: ASbGncsfSFNykJIrEKQCvaM10fZFKscUPXHNbjxLIwriofiH76iYX1F30KGy0VcKjWp
	Q8swlhcVC0ltfMqWqujUiA29YYBpUjYlN2uhC8L3oQ4PsheDwcg020wuHF9c/8S9nEbHgwxhnYG
	kFRzrz6ph3Z6tRwt5HCQkfAKJi0oZAJ6xx3C0l3TD5RcNe4+Xq+eYiFjjwV/79gz2HI1gTo8Qns
	5pqP0N9LrwXhHmqxqNpbSr4TZweeM9A99yXcrllN0S4ukapC4BSOMgevVtcBnGQOwEpH012tOPk
	cID0VoVNEJ7Q7Lb+VbV7DWSaFfJ2oMFpMaJ69zIfllJkiPcfw7cg3WsaGH3A1hdwh1VMDLWR/iD
	cJUq6soq9BCsJwN5yldqykYBR2rRQQWM=
X-Google-Smtp-Source: AGHT+IF8j9BREOrCOYFL8FBPYdBxvd9a652kkY2yOpEvJ04WOo/DTulcAIF/mKex8B+hYmrvM0KmOw==
X-Received: by 2002:a05:622a:207:b0:4a9:ae5a:e8a6 with SMTP id d75a77b69052e-4af10d8de1cmr145731371cf.47.1754322223162;
        Mon, 04 Aug 2025 08:43:43 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:73::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b0785d13a2sm5486211cf.39.2025.08.04.08.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:42 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling THPs completely
Date: Mon,  4 Aug 2025 16:40:48 +0100
Message-ID: <20250804154317.1648084-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7AD9180002
X-Stat-Signature: 7hpd1rzzboaiq9hafcpjsuh6qz1gos7p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754322224-273749
X-HE-Meta: U2FsdGVkX19fuMVN0WKzsWOyFWs7GyWMrwOACZLgelQYmBz34eVLhaSlOT0onqgY/omY+e7ssSrdzNIKhTy9oZWlSmC8onV23YgJu3mfpfl0RT2Nm6E7CJQwMgdCJHewPsK3FInLzqzt4jpIfuhMsILilPBYDxngirxqlIVfRAe0PMYPUFEQPa/BT1RM4YGAh6Mdkshrpi2qKaMi3EidCWApdZcMnvPvtGNj3gwEgcVuBYxbaZyVC2MJ4P91Iq3JvI6lq6P+Dckhz9FgHWKmxNr6fsvyPT2+ZAef0XzGPmdfnyDfhz7iShgO9UiGMM8O+LP8w90+F1uJKFipJDlfH4wIPbA4rlTftLJ5dxh4d0a56WAhqfkoQwchSXNeOWDzsCtX80SGZgpI9pIEiTw0KMcqtmFIDPze9Id40Nyr9Ah9Y6y9p/KC9yQFfNj/qd8eRTkdebMHR4xauA6Zqzm7C8KmyNR9qsgOOU8P/P/vPDowJF/VdBk6VPJZubAEM+3Obb3oAWA8ZLpZcLXgX8vTlKoRniS3E0hagEFr00t/A29YluvahfUOKtWQBVEANXqs9z/HjG6eS0ism7mX31qd1umqZ8MyCLcMmB3o3x9U87kA5Kp4gJLuIUJf2nzc2CMn0CL2HwamTwXvvRaUbF9cjH/QgtR3427lugTsg4hkbAZ6ti3/9XTw0rcpvG2BeyfOMlwhdxg8urbGIq2eIGgCD+sZrMgZN2Y4s3fmVYYgbTpxmov9Ae+1OtVr1vyMSe4E8D5Fru6gmrSmYggTTlH3elgFMBnOiVQXwkxqyBFdASUqEwBASbe+7RMIP16RtEG/Z2F0/uwXAUh6FZ5BF0w9RyxwhSzEBxq1072PICVgIk2d/x30he4pj175pWMv8kOyr/tCMea/aEucxkxuiwg+anp+njv9J7gpYT14wWCz7Cy7SAPJGakDCyFgJmn3PLxz9v2Y2AqXaLu/XdOlE/Y
 iv2q5wFt
 NUXNm2/EtBnRERWEOrUIvJSjTg1f9KiTcGRz9EiTO/upFKo/ZD8VuDt1veNJof4UaAyvEtFsKkSIknj/9QKsZJufjhupV4CihFwNYc/Xiy4mYLyBScpbwb4RbVqAfvp+fTq19/J/XHBEaMPiyDZ4dLmZN90693YPL8wNbdZBpyxUhLFHky4AoFdLCanC1w6OfyWSVpg0QYkt7SPbHvAFEn7j70VUyGJU4iUXmxT5VQmjJZcntee3j0B3qK8X7vGkNP+cUHMQLd5INtKZO+VTGeK2wkaZIDQYn0qdMlYZtVe6PZdpJIQV+HKdsiCki7Et+9sJP4NzS2CJnJUNfAijMzXr1a9i88tFgw6HEomVMZkkDKBl0G0DVmbgwrweWWBPfHm+D9YmWgP8gkRuzH8jADjniw7njQCV0ahT6gEXwKH1960yxzUR0MvxCSemBbVgFg+ocySWlgv1meO/X8Su99v2HV2YLFdiPato8K37euST90WGf97fnyIsUOwQqSMZRRNjc7HZU+A2d+DEWf++h8UTG06gvcoJlWu5zcbvpTNK02uR5+TqN78/O5dlXQy1aTvCC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to never, madvise
or always depending on the fixture variant and the 2M setting to
inherit before it starts (and reset to original at teardown).

This tests if the process can:
- successfully set and get the policy to disable THPs completely.
- never get a hugepage when the THPs are completely disabled
  with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- repeat the above tests in a forked process to make sure
  the policy is carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 173 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 5 files changed, 184 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index e7b23a8a05fe..eb023ea857b3 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+prctl_thp_disable
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b..2bb8d3ebc17c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
+TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
new file mode 100644
index 000000000000..ef150180daf4
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Basic tests for PR_GET/SET_THP_DISABLE prctl calls
+ *
+ * Author(s): Usama Arif <usamaarif642@gmail.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#include "../kselftest_harness.h"
+#include "thp_settings.h"
+#include "vm_util.h"
+
+static int sz2ord(size_t size, size_t pagesize)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
+enum thp_collapse_type {
+	THP_COLLAPSE_NONE,
+	THP_COLLAPSE_MADV_HUGEPAGE,	/* MADV_HUGEPAGE before access */
+	THP_COLLAPSE_MADV_COLLAPSE,	/* MADV_COLLAPSE after access */
+};
+
+/*
+ * Function to mmap a buffer, fault it in, madvise it appropriately (before
+ * page fault for MADV_HUGE, and after for MADV_COLLAPSE), and check if the
+ * mmap region is huge.
+ * Returns:
+ * 0 if test doesn't give hugepage
+ * 1 if test gives a hugepage
+ * -errno if mmap fails
+ */
+static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
+{
+	char *mem, *mmap_mem;
+	size_t mmap_size;
+	int ret;
+
+	/* For alignment purposes, we need twice the THP size. */
+	mmap_size = 2 * pmdsize;
+	mmap_mem = (char *)mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED)
+		return -errno;
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
+
+	if (madvise_buf == THP_COLLAPSE_MADV_HUGEPAGE)
+		madvise(mem, pmdsize, MADV_HUGEPAGE);
+
+	/* Ensure memory is allocated */
+	memset(mem, 1, pmdsize);
+
+	if (madvise_buf == THP_COLLAPSE_MADV_COLLAPSE)
+		madvise(mem, pmdsize, MADV_COLLAPSE);
+
+	/* HACK: make sure we have a separate VMA that we can check reliably. */
+	mprotect(mem, pmdsize, PROT_READ);
+
+	ret = check_huge_anon(mem, 1, pmdsize);
+	munmap(mmap_mem, mmap_size);
+	return ret;
+}
+
+static void prctl_thp_disable_completely_test(struct __test_metadata *const _metadata,
+					      size_t pmdsize,
+					      enum thp_enabled thp_policy)
+{
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL), 1);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 0);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  thp_policy == THP_ALWAYS ? 1 : 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
+}
+
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_completely)
+{
+	enum thp_enabled thp_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, never)
+{
+	.thp_policy = THP_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, madvise)
+{
+	.thp_policy = THP_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, always)
+{
+	.thp_policy = THP_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_completely)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = variant->thp_policy;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_completely)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_completely, nofork)
+{
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL), 0);
+	prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL), 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index bad60ac52874..574bd0f8ae48 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -382,10 +382,17 @@ unsigned long thp_shmem_supported_orders(void)
 	return __thp_supported_orders(true);
 }
 
-bool thp_is_enabled(void)
+bool thp_available(void)
 {
 	if (access(THP_SYSFS, F_OK) != 0)
 		return false;
+	return true;
+}
+
+bool thp_is_enabled(void)
+{
+	if (!thp_available())
+		return false;
 
 	int mode = thp_read_string("enabled", thp_enabled_strings);
 
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index 6c07f70beee9..76eeb712e5f1 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -84,6 +84,7 @@ void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+bool thp_available(void);
 bool thp_is_enabled(void);
 
 #endif /* __THP_SETTINGS_H__ */
-- 
2.47.3



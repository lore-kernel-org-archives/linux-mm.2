Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2345C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500EA8E0007; Thu, 31 Jul 2025 08:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486C18E0001; Thu, 31 Jul 2025 08:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326CD8E0007; Thu, 31 Jul 2025 08:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 201F18E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C74ED80839
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:38 +0000 (UTC)
X-FDA: 83724488316.02.4824C50
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF7221C000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DxFmFgCn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964916; a=rsa-sha256;
	cv=none;
	b=qWUoyStLT3fZ/YemnubtVAVC/jyC25Xth1uaOo4KW0c+o0Q6ieQnTwhML94W+3mpe8RRBM
	lyEVBCwjbf89/YjsM5gktvDW5gN9bwOhHUm1ZQTHwrMDtwbISTVQqem4VNGcnYm9axDh6e
	+iC+WowC0djbM0dI09wiO+e+42WxVQQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DxFmFgCn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
	b=Aq9ZotQZosyTE+ssuRtVMaGODH63vKKXhv9oDPlYpiRDC5tSgpkZULOzDg9W8Y357NHMYS
	TUDihW9ipNez3vnGAE/Fd9+kzz3rjQq7Zg6UJxSlnsecYtu6q8TVV7IZyuZlToCePTAdfe
	VVGsSJ6utjQsJoxF6i7JC+pzWqYX1Yo=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70756dc2c00so4180766d6.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964916; x=1754569716; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
        b=DxFmFgCnpxRVTDYtnIvZr3b0XT+weS++aVY5nFwofW6+150hP0HnDxvKLKoD4+c3xZ
         ey9l5CrDiI3Ncl1nfJxUHcwcsk77huUpjV3zqw8XNe6CYGNWBmlPPQy0gAIKwmYgklaz
         Vu9/14RnM1/UzHVCYcqYMQcOPivw0jsU5Kr4Ar1QddcApu1RwXQf8U5fqthhieeIF8fo
         kxWT2j+xbuA2c5NnH6bri32u/f1YD2rM/Eec2hk8Ypt45gLWNHCBmrF+IgktIZoPScxE
         ZJKDGeAKE+FWqWHSNKw9dtxUzOb7Q5AxygGbEA+eiNS3KkKE/suMjgQwXc5I31cbe7V8
         UY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964916; x=1754569716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdseCjeXglmAeSVo3jNDX9M0lKkfFlPBpOaLA9628VE=;
        b=UF5I4UMRo4hzczL6Qifuvg+GgJ0zSNWvvSaKGPQYFPxcfyanSq9889s4hq0V+v3sQ4
         FZmC5YzccHwPp8S9Qh2wDvxLo2krpja8Viy9b9Eu8KFv1DfxkybEyrxXNkEN7kTRJav0
         AhCabcRiqtz0YFfklzb1hAy/VGMPLWscdgP5idjYLPI8kDssIe3oLiXwP2GXHcTPqEXW
         6PCwSGA11h756qnGkHGZInXenbmOdiCqbXPrVvspwrxIVjEKZE5VPAJA3xH+Aqdm4ImU
         F4/OCVM4BAs4/1cIT3UCqiKeHjfY1H92bl05NgIPjV71E8HnDNaHQervPEBZ4wWuH/pE
         nQ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVyqT5DQ59MLFNjDemyf3u+b2qlEWw3gK8GYAqPm4pb507yodnjmZ+7PI/HQ3e8bP3LE0ImiGEdHQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5vw2o/QJsrQNsj0UUziEwSz9X6NYMBxAyiOYSj2i0+UZOvrvd
	af6Y9rImLjLLw6Of8h6JFhkUBCiXquTOebF8jOm6/wqq95IeSgGu6U10
X-Gm-Gg: ASbGncuQfbjDwp1hKzZiXV2kReohYXnINdbrFp4ygLWrMHp+WNphabg0cbdam/OpUAG
	LGTloI0r9HOfvIeLWfZ4WlnorWi0pnghtARPD+UFAux5fChg7PwskuZioTvF5xMSd3ZY0/ortZK
	j7Xbt0Aza7UrCirajJ98AHsGQE6/bj03tfbPHOA2WtbjVaueLUhMIN8SgCoXYjJMtN4l24rxl2S
	2twBtS15v5QaN66S/rhRWuaKmUB7M5Gdlhvl1w6R3ewd2c5ovFgRIeOA7+dLcbboIa7iE1QmaD8
	K8WfUegCo73oABihsaxIw1qiBKUr+8zgrPFklvRrxT/wGXegJOV30nFSnfdsdnvd/72D0jDC6A4
	P2lZaupR7m2SUclnhvvNUbGakVWQxGMw=
X-Google-Smtp-Source: AGHT+IENkVw8ynAfGXw4WuZqiIpcMKUMSu/EtMQV//+NQ4yDeACqLq0qMosxKHrbCo/7QDKjW7aI3w==
X-Received: by 2002:a05:6214:cab:b0:707:5694:89e4 with SMTP id 6a1803df08f44-70767482bd0mr105266576d6.47.1753964915867;
        Thu, 31 Jul 2025 05:28:35 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:72::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca5897bsm6678386d6.39.2025.07.31.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:35 -0700 (PDT)
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
Subject: [PATCH v2 4/5] selftests: prctl: introduce tests for disabling THPs completely
Date: Thu, 31 Jul 2025 13:27:21 +0100
Message-ID: <20250731122825.2102184-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122825.2102184-1-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF7221C000C
X-Stat-Signature: c47twhjkhhrgujoguctntin4cih8jgta
X-Rspam-User: 
X-HE-Tag: 1753964916-644727
X-HE-Meta: U2FsdGVkX18tMqFbcn3j27wgqz7Hs2wEmA6/8diUP7YujlgiSC38G3z5NVJm1rWuynN+sa3s9AKEyAYmSJjak+QEw1HuKjDtx4Zu2oV3GoDacubQ6P/zpoX7vdIky2yPCsTHMm1JinBBi2Unrmm8SabKIlkQhEXo6BsbyVLZTNrVBxtHewZUkTnAIVXNbwYCG2MNXPqCZJYYHeBUkdrL0/L508d1GTcny6vUDSxTcfOR78fFMTZiqd+qT8IJDECanXktXb1OUICCurfpH3GuseixVM8k/uOTX9L+009TY7JQHDqEZHudEte/ibzzF0jJ70wUDBXjvqG8ysQNwSiFI9+ijZHVA28qV3YtTvSTXs61tPMY6Mo91atRguwXOZ3k/mba/bAJ3yNQkv/oKORr0zk/st5p05rseZy2A5VBLY+xPNzUo2nvw9c6Plbjdb6SHlmoCfAcV5L+FTwlWNmoZnETSeJkdeuaIxRGFj/wsRaTNaYQOP/rai2TUvkS86aSEksKYFK6G/nBb5kKXn3q5D6nkDvbmKGIDaUR2+6cjA+gwFSvVoKkVq0BxoHM1DQaHW/uhxdRaZFuwZZ8XFCdBubWDCFbLMDMLxzpHR7aOuHhfVDwz65RkhcvW0tfv1uubcmlCbRzMnU3OuQQLH/T+3eonZJiGETo62Fn9E+9s6mu8iRe3gSW/sQLWVkgzASqI/7729QNUYhjvlGEC1KM3/zOPNIwf9gYxG/bk4oCy2Olpx8GYU7Hrx4+EKHXWyimJkt4ZuBCoGycv08alDuB/zH+SOEyv5ELDXlO+HhjCBYoqAIJnC6KcHLq6VQ8wNGyM1Ved1iJnIZTZV5ywINCThGYlVIo4Ga8Ln8wPQ1HEq3VAgVDeb5hVsqlOH8COM/obNXxAR4XHLtE6KJkvHqGFRZyCUG7/lp0RVO+jJtSeXZgmXfbTntyFGYfDqwsHBHNfRhCQVxR/42qmeadpQh
 cVmGb67a
 TM1GjGFG1WjkRZEQZ0ImZiKOp01oLhPtQKJYS7jTDyVRd2jESCkH/cIEzQVG+VrrwZJfMefhQDx7eOBNf5s91NBW3XRuuJQNM61b9dsRpGYADFf/0iI8mt8yutcqJl3YNjy3m6D90N7YFGnL6Hy3kea60xSMKSae8TQJG1Iq+OE3Av4Y7JdMjepTFXRhPuFcP/v1aeGTaVoAqQkNpVjwdOpqb9sAAL4LHlWm/nnytJWewCN538RzoUitJgsJmNuC6wM0jAivVhQSNuzKZpCrZsqsyH1B62BJ8sCx1UrIibZ6ucHPHRpO1QyrjsUd+ylUESvNElR5L7nPMpHYWaOlLyOBMsh35FStedIJNR/oV1VaanmeLmBuNX7WGRtafhenK2aIIfpj1g3d5yqcJGXsLyJmQcpeykXPmE4Agvv1C0FHyDbZFX/xXdaSEMsAVEUIQXHAat+GlLZZhnWmAghBZ/I1j4oteJjL9G4K2qnxDf7k1LuMh/Ej7clSV9TA++qPLEhNjwahWkm6DFrDW1xC3tOIDtIxB55BExSrtwBJwk7tclKBkg5JnInehqA==
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
 .../testing/selftests/mm/prctl_thp_disable.c  | 241 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 5 files changed, 252 insertions(+), 1 deletion(-)
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
index 000000000000..2f54e5e52274
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,241 @@
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
+enum thp_policy {
+	THP_POLICY_NEVER,
+	THP_POLICY_MADVISE,
+	THP_POLICY_ALWAYS,
+};
+
+struct test_results {
+	int prctl_get_thp_disable;
+	int prctl_applied_collapse_none;
+	int prctl_applied_collapse_madv_huge;
+	int prctl_applied_collapse_madv_collapse;
+	int prctl_removed_collapse_none;
+	int prctl_removed_collapse_madv_huge;
+	int prctl_removed_collapse_madv_collapse;
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
+	/*
+	 * MADV_HUGEPAGE will create a new VMA at "mem", which is the address
+	 * pattern we want to check for to detect the presence of hugepage in
+	 * smaps.
+	 * MADV_COLLAPSE will not create a new VMA, therefore we need to check
+	 * for hugepage at "mmap_mem" in smaps.
+	 * Check for hugepage at both locations to ensure that
+	 * THP_COLLAPSE_NONE, THP_COLLAPSE_MADV_HUGEPAGE and
+	 * THP_COLLAPSE_MADV_COLLAPSE only gives a THP when expected
+	 * in the range [mmap_mem, mmap_mem + 2 * pmdsize].
+	 */
+	ret = check_huge_anon(mem, 1, pmdsize) ||
+	      check_huge_anon(mmap_mem, 1, pmdsize);
+	munmap(mmap_mem, mmap_size);
+	return ret;
+}
+
+static void prctl_thp_disable_test(struct __test_metadata *const _metadata,
+				   size_t pmdsize, struct test_results *results)
+{
+
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL),
+		  results->prctl_get_thp_disable);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  results->prctl_applied_collapse_none);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  results->prctl_applied_collapse_madv_huge);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize),
+		  results->prctl_applied_collapse_madv_collapse);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  results->prctl_removed_collapse_none);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  results->prctl_removed_collapse_madv_huge);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize),
+		  results->prctl_removed_collapse_madv_collapse);
+}
+
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	struct test_results results;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_completely)
+{
+	enum thp_policy thp_global_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, never)
+{
+	.thp_global_policy = THP_POLICY_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, madvise)
+{
+	.thp_global_policy = THP_POLICY_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, always)
+{
+	.thp_global_policy = THP_POLICY_ALWAYS,
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
+	switch (variant->thp_global_policy) {
+	case THP_POLICY_NEVER:
+		self->settings.thp_enabled = THP_NEVER;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 0,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_MADVISE:
+		self->settings.thp_enabled = THP_MADVISE;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_ALWAYS:
+		self->settings.thp_enabled = THP_ALWAYS;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 1,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 0,
+			.prctl_removed_collapse_none = 1,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	}
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
+	prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
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
+		prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
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



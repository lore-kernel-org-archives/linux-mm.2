Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9317FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B647190008D; Wed, 13 Aug 2025 09:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1527900088; Wed, 13 Aug 2025 09:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98EAE90008D; Wed, 13 Aug 2025 09:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80332900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E3CF16033F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:38 +0000 (UTC)
X-FDA: 83771886996.21.280DD23
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 791A540008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DQaClEsm;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dl1ogA2t0/rhzsz3n+9Cp7M2nFKkgZbECfidIuzz//w=;
	b=XIFqDNM0hLX1X6cIrh4QzhO+JDw0jISllndoGrf9Ar2qVmKGS/zBj9PWTIXWAGkcHoqVXt
	VHujNpja40C/8JjoeKqTUwUMcZRrby7+4weollsEpx3DyCZewy3/GuHTfenQUqp6O5H5we
	AAOeIsosFwaUNBozIkzPJrcVsXHkivA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DQaClEsm;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093456; a=rsa-sha256;
	cv=none;
	b=RZTgKDmaJis5oWc8EKP7ZixLxsEJVr/1DQZ4xG6pzVKbwGACmA/qgy78Pipcve6RHmx/jy
	/ZhtwRrZ+q/Gfx9c6XwmIH6HUZboxgxThImNnQooar1HVOBgTI6f6viCNSmU5TpbRtxPKA
	7XizsodOMXhUUT7xUtUOu6a8TF8aI7Y=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-709e15be074so16553786d6.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093455; x=1755698255; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dl1ogA2t0/rhzsz3n+9Cp7M2nFKkgZbECfidIuzz//w=;
        b=DQaClEsmfimsX0tEEN+B8DYfecSMIRVb9p7DfL1K4SGkXq6/XXAzbVBp7VJPhufcp0
         k3mrv4DN6NIegWfg1FPqd7rk7UOzBjMK/aFSsFk9h+0CRq+thssKYygWtjA0C746Ag41
         1420a2hqCRKyEipYQz1APNoThZypkcoOLP8YrlpjIUcIKFPXFZoe84Y+Ncs8PGnvECBr
         kyiP5iRmSoKfRXd8m18SKLH8/MjbFlHOI4tyljrySmMsworaQRY+TFOyTdHGPrQmKxWn
         a4jslGz0EbBZYHcsp1V8h39zKLkBBsIU50AD7bI9EW7SoFuNlus0XV89whT3MUy59q4R
         qVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093455; x=1755698255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dl1ogA2t0/rhzsz3n+9Cp7M2nFKkgZbECfidIuzz//w=;
        b=B7JTUaozupA2RTsDCKte0bt4cypFTCjEfcAE2idALt9GXl8Mv5oaOYS2eayqXaeFNk
         tSlyzDpFtkqmRRtXU5NUZmlmcT43scIeloYMdLSbymLULFGjX3YYsvuTbg4wSb9irCIn
         3sF/3HHEwFNy4U1t1tPJnlO2q3JlhKwJk9KdaivHjgn+k4Fpbm0GCO5hZkmgXU3TqkTJ
         kVlsKOSxExhAwRGj41a/QhijtwIdVIOj9W1bXRIHyq1+YaxNfz4r74+Rfa/5GJ2bG7pQ
         InWxLC+45C1LpXirHdzsN6XjXxz6fkDJw6NYuJ7517beWX0TPv9eJj4A6tAhsvwOrrcM
         wgHA==
X-Forwarded-Encrypted: i=1; AJvYcCWqpER878lmmo+htkuAdxc1v0woFI0mBRrnQx7gQHWV8DPr5E+DMu3oHrvO4I5lpKGY48v6Dwoajg==@kvack.org
X-Gm-Message-State: AOJu0YxMdGJJzXF5x+YD0NGmXbZSMynELXwLJE6onT8zZnuVZh0qklWT
	NJ9Whftuc5y5ldobuMy69ROSIQD9Dwx39DswZYP950672lGvBg9TfwM2
X-Gm-Gg: ASbGnctehNRuRfZ8ty5cO3gy0It4sS9JCXRYE4HpHl5cVeLIfdx2P06mL3Jm/+1gvmQ
	fIIUYAkUqiECUfUQU10AW/iuzT0NXCVuchOWPlh2K0U/TRD4YeN5tljjXxIGeivNql4r0joe3j+
	TXNESC2RpuNcQE0bGk1eyjbAJ5fT4bEGRB6lCQ+zrn8y9bXGCZ/1VDhHLM4vN7VJNU+l6/0P/zJ
	KzlaVEPj+OzUDU8IGT5FmUtIa7Ykp38g3v2bkc9O6XYDOETlEqUcFC1RdFqr+jMG0SniNQ8P0fM
	opANCS3+PHmKcZZYsKDJwLCYKQlPW1GLaiVwB4Adhz6aCf7BUzAhiHy41n3VmVU4rE/cfkT89z9
	X8rG+l6LSMxi0+GXh
X-Google-Smtp-Source: AGHT+IE3NUx60T3Uu+LLxZcNnNSoL99GfNvHrmsdXpcXcGYhBL0SlbNyWV0ClKfn+88SoUddsaqGFQ==
X-Received: by 2002:a05:6214:20c3:b0:709:9ebe:a5b1 with SMTP id 6a1803df08f44-709e881f8b0mr40314116d6.13.1755093455474;
        Wed, 13 Aug 2025 06:57:35 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-709a0d74acfsm85017666d6.58.2025.08.13.06.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:34 -0700 (PDT)
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
Subject: [PATCH v4 6/7] selftests: prctl: introduce tests for disabling THPs completely
Date: Wed, 13 Aug 2025 14:55:41 +0100
Message-ID: <20250813135642.1986480-7-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 791A540008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6ie8985br83ceue55apn873jcowdmejj
X-HE-Tag: 1755093456-509552
X-HE-Meta: U2FsdGVkX1/AsN7oCnKGjhjvR+M8p84ilqywT6J0MPlRd9ZYZusn6jPNn3LaJXf2Zze/bYrWBk2ua8Y/GdzOhODP0OlpEZ9YFLCOYm6D3KKJWps8GEnFJCekxtJrWVqEVCh4cKmGAT+sEqW5oc7bKpn4+dXZuriunYb/W/6oMZ/skaLgNWQpbcauisTy0+rvHtKNO96yMWCeuHE9ZfcKU+n1ZtQthdnfKV3LRXMMRF7RPPMMbRfJkZjZEcFwmzBMJYAEHMxh+9mKuFqrpvRIQkM1jUAGZlZSHJsKSqAAYGcf20iAk4yOJc0KCGuaGyGZudYDToOetZRBPE2bt7sBjzzP1vt6CK0JkDUcuUhZqim4t4QkoIf5z9jocfSZHn5tWvTM/voaXmbp0Y5lAchtt8gT40p0wICA+3kqZsTAVG07sZAy34iqHuIoWUh68LpmDm0er7hoifFgAbMnLLl8s3OktCrkVaQ7O3LoIlsJaHL6qHLcsODm4gHdhw4ar51ydAGy41A1I9213fc3obGUjLi7Un4sOpB5VwN9nu7tAHqK/6kaKo2PE/+x0gYFsyH0qBj3Mq5hBlr+iWlMeiEJNF5wu+QyEOqEB+6moodQv6VBr5Vh6ZuomCeiQfnmJUA2m0ucvK69kmc1Ju8dfCIpNGkfNtcU65DTyRVwuR0zsj3r7AfPh8oedQss8dsVyr0PU2g2Pntf8yMPLK0hL1QxKasJsu9rf+nbCrd5bYZzchX96Uej9V6VvwSsyr/+glCAA/Kjc9eYPzDP5wgHT4Zd/ri98s53dDq6IBZ3TiINb5NAakeJfeHWvPwRKC9NGH3zhWDGwnGvoMycAyBc/5NeWwZcbX2X4cAcLVEBKlX2kSqiXZOy97wIBfexGMciaIdiazFdaKpet/VDW3+SIYXXiioBTe0bQSkD6vbzCTi/leQgCzrA9x+5vf3aUdGXe5jsX3Bs2U2FCJmZp6E8XJi
 GfdG/hXW
 At582y45zfmqpTQ+27wqyaVJeyemXzknji+zxPpRxsRrk8ahtBg0Clg08O+m+pDXOIlcxJudGH/KAOvI9/1kEZoOgsLmUlrkntkJtWKyGrP9mO20Ip7fVi6QgU5EzHZKJ3ReQUp6ZOghCFJX4s+02LqsbgrzuqhN6ko/98e0oAZTKHHxeomIWt++i/YikP/EGw1XPUGtiI/ZdC2ETJ7ee8NYhJtpD7gar/S3U+KtGypy/fXibkRci5dr+vevwzTAcdv5visvxWTaPLxMyzzoiKtzsub0ajJNizp69SHyYc69K8ZSzlkMF5XTEnwBRB4Gu3m2aqXvejXCkMjye78ZdSC2tI+B4+YrCnDAbun9k2IKc0fKGtEv3mHQpxC6V0uAQFi4V3qKtiu/N2NNvIczDD95rB931IINzw/8DRYOrl/bNjssJ5FxoCZFegZKs+HfihiEOmbNTv6EAlZZnP6Oj+qQMug7vUHd1tK6tSNUEvieoz4sR+QgqjCYkEjHWxm5piMyLEffzFQzxKrGVG6zw83SJdDAE/MEjHCdw+9x72wJ0GLeFNzm+3d5Mi51MGMHrDtiXlp8gzvtrneBhmcLh9VCVYg==
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
The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
be made to disable all THPs and skip if it fails.

This tests if the process can:
- successfully get the policy to disable THPs completely.
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
Acked-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 168 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 5 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index e7b23a8a05fe2..eb023ea857b31 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+prctl_thp_disable
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d75f1effcb791..bd5d17beafa64 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -87,6 +87,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
+TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
new file mode 100644
index 0000000000000..8845e9f414560
--- /dev/null
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,168 @@
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
+	if (prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL))
+		SKIP(return, "Unable to disable THPs completely for the process\n");
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
+	prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int ret = 0;
+	pid_t pid;
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
index bad60ac52874a..574bd0f8ae480 100644
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
index 6c07f70beee97..76eeb712e5f10 100644
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



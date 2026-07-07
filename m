Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81D8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64DE6B00A1; Tue,  7 Jul 2026 14:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13C56B00A3; Tue,  7 Jul 2026 14:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCDB6B00A4; Tue,  7 Jul 2026 14:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668B86B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:29:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D477D12053F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:30 +0000 (UTC)
X-FDA: 84962818500.11.A6EBD47
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7A745100015
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUNcLmGX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448968;
	b=eHQ1vAvaGxkTyY3SGzOeGoBqditJwSb9Pm1dlBo+ioucTZI+m/+vPWNwiQEZdnfg+szosm
	1bDgIFCuim0JUpoyKvWZTiqkurAeszxE/7XJo00dU/neWPHzhqDbwXsGJ3mERH5siyyMb3
	Z4YwePKgGUoeh5pEp1ydY1xKgC7WhXw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUNcLmGX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SkRPUn9X6TAls57Zd+/V7aSZfttFWHFsmLqlEdELyU=;
	b=vQjSrGNaIgZ58SNji9Jod9F+EBcvvn1WdLVykgZqCLz0GZ5mpeYtOy19fwJTv8S929z0TE
	FSQKG0jha6JnoAPP32ABYrnYNxn4IZu7GYeGY1G7sZk1tZP5H14o2/I4okEcYEVoeAde4g
	g9Atm/7yh/Vn4TEv2T95hydfKuQgDC4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783448967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3SkRPUn9X6TAls57Zd+/V7aSZfttFWHFsmLqlEdELyU=;
	b=OUNcLmGXPf+yC8u5VNx0DSvt0abF75Gfm9O7QpL62MWIMJ6DWy3746SoniBTVVh2E8WgNs
	S7WaBHoAvjVFhcdfNsfK6lZznatI1OgDFwA571RdAl8g2YL/apaTTZbk4Vl4UZ1EPLK3hj
	E3rvgC8mOwkAlmIAl/PVxMt2TH10T8Y=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-8RvzK1jlONWHTcMqYCyEhQ-1; Tue, 07 Jul 2026 14:29:26 -0400
X-MC-Unique: 8RvzK1jlONWHTcMqYCyEhQ-1
X-Mimecast-MFC-AGG-ID: 8RvzK1jlONWHTcMqYCyEhQ_1783448965
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a0c02365c7so5604953eaf.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 11:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783448965; x=1784053765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3SkRPUn9X6TAls57Zd+/V7aSZfttFWHFsmLqlEdELyU=;
        b=S0zANFK0+ALFTs8l4rHbKREq+Flaj8PHexFFH6FTGiVwSXrbkThib+uvHMr/92sBzX
         4K8NR8AWv9rRNTy03JHwEbubhG2yTY9mcSrniZHCDhCUbRiIwie80QpCua0KgEfzQ/91
         Vbes45EPLpy2+exjokrHJHaUMj2/MzKgBMwHvVmSgjs77cA56Ewr+F+qXV8/OgQUNsCw
         3lBGOXZE4GIMM5fufE0YkJuu1z/omq+wc/ht4KOQh9mwAW7Hs8Y0HC1zyIk9m2a86ly9
         uvgFpaeD9NINvf89fYi3eovsoyqo2BcYzM0jhrznyuzQU/L3UYLKyLDUHQNznwO3hWp8
         X+Ig==
X-Forwarded-Encrypted: i=1; AFNElJ+L1+VAlQTgABdDx5t7nCU0oRwOXMGa5Xf/GJEmBERJXhnpr/7dk8XpqNL7/WbsxRYkvA2ZW+gKNg==@kvack.org
X-Gm-Message-State: AOJu0YxNmbcLen2P6nGFvcdp6K6YMt1SBdX7KU6FRzk/EOzBKNNbdbfA
	xcnV/NGKBPEvJ2Ql2UyFdrZuMUoFJHUC1SdwWLDVwVxDof9HdT7srDFHky7Wv1TmY6LEWOLXhGU
	26PUoOk4CbVFONK85QmrL+8YFimBOxhg3aeV5r8+tkevafvceTa+m
X-Gm-Gg: AfdE7ckUjMtrHLev8pF0Gbn+4HpiMrmkszejtOPXgz1qvtFQSq/2X6npE+Ew02VcLIn
	1lhKWFF1FYRbQlyb0mTO709urduKpQISHeZUDkbx/SCug5qBmJEJWEBc9Ajpj5Bnp+UXTfNfO4O
	OcwZeceSndiK1rue3gIenyu5GjLFgUHC96ONmLKkVbtoRShbhpWMVV6/BsXpfqoEEVOkY54Jj0v
	ZQPm0ghtFGuclH+eQbiNeuVnd3ZC3FkJPshNXGyb8LDLWCHwXb/CpgQnBG01rPSyflq3uU9y5W0
	ePdgLDvxCUOc3F119ZYwvNSH2stex5WKZ6gA5nLRClNR0nbakQ0EakwFGlK317zC6nh/wYCd2Zk
	r9vun3TG7zvD4zeD0wdQn8vMvdtEnHbcGdYcYhaSXdtmA+ThLnJIDrxuIkTo3/tyuS+6VHWz0aI
	V6kHTlYQ==
X-Received: by 2002:a05:6820:1907:b0:69e:98c0:a9c with SMTP id 006d021491bc7-6a35538e0e0mr4077697eaf.11.1783448964558;
        Tue, 07 Jul 2026 11:29:24 -0700 (PDT)
X-Received: by 2002:a05:6820:1907:b0:69e:98c0:a9c with SMTP id 006d021491bc7-6a35538e0e0mr4077668eaf.11.1783448963879;
        Tue, 07 Jul 2026 11:29:23 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.rmtusco.csb.cloud (184-96-191-56.hlrn.qwest.net. [184.96.191.56])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb55907dsm13550509fac.11.2026.07.07.11.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 11:29:22 -0700 (PDT)
From: Charles Haithcock <chaithco@redhat.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: Charles Haithcock <chaithco@redhat.com>,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/2] selftests/mm: add surplus hugetlb mempolicy reservation tests
Date: Tue,  7 Jul 2026 12:28:56 -0600
Message-ID: <20260707182900.483757-3-chaithco@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260707182900.483757-1-chaithco@redhat.com>
References: <20260707182900.483757-1-chaithco@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kGiACt_8sdSihf76ZbB7BPydCthr0uQ-ApQboHCNSfo_1783448965
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 7A745100015
X-Rspam-User: 
X-Stat-Signature: qwz4ahzp5z1zimfymuwcxhbn69tjeamb
X-Rspamd-Server: rspam03
X-HE-Tag: 1783448968-146846
X-HE-Meta: U2FsdGVkX1/TT8q2nKzQmmn8WOVaHVsaI3q2drqLrtvKzLH459Y0V+p72eu/7lUHWix1mcoZqoP1asK0EV1+ezGUJHUevriEqMTfpHWaKLaL7nZUtd44zZj+aWENqRDt1rkNdX9E2/ASfAmupVpJLRaw9FGP7MJABN4gfPPSPt6aizipXuzbyBadbDg9Ww5I1K3qUurEJFcy3jYe8Ru6T3v7zAbdlCdWQkvbkSQ3PPnTqbVNyvlCrfBK6k5cHBZxeTNQoOcfF5srAT3yNgYmgrUsuUWAULlnipZRt2ITiwAOO3/iRdCdpxM2G5h7YQOOsRPKww4NlLSCdnDSYBwwhlklkzQ76/N8uAL7j3vJPTf2VIOWSOwfVuZg6FUD8XJrAh3VU/3xEww/R/b+XezvXFas/8UOeYQSLbpgjJccoGwzQI++qJX3Lc9TnRsoRJQ1kPFHd7gXH6JZc27wDnxEiyDo9P99W/bFJ2CrD9vKVcT+u6cnWFMi6W3pLEVVCgRFCvZj0iC98HObdFRJGKm1+RxddK2OflrYH41UBzNntZFT5fqwNiVvNpxs0F6K9t/x2nU8VIEVOUnYX0yZJL/OWFvZ40oYHjLFX/UrpluPN6m6bw+MbOU3AcCNKN6tI4KdEHBITnVhoowROXJ0dTMz6s1no4qlDSVZDbXUuErpycDLqXflFIv1DyCL62dkiM+hsM6HR0P/AQQNFeJypb7h3ts8zaa/ru2bA8NG2ciSb3DBIUglLTtEBaXWPogGfO+kV5fIkXyW4ku2W6xQ+hh9qW91clpR6m7A5l/UeQdD/UrG1eebF3dEF32BVpIsAF0RSZ91aLMKTj48LKQvKGMchkFHjsBQ5QiTGbjocqlYk+RKKd58npurmox+HnuOjNuQI4jM7nSqVhXz/2U+UgfqpFCV5oKxYdln5kUQsH8IB5P7aQVwHXQnoRL8OPkfIYMrFj4WTtzDPHyZHLWd0n2
 zYOaWtZb
 9+4M4IMMGt/+vPgWA4XzavItRHcjm/ey98u62F8lw6E9c+FArogVqTY80VSmSYUuGF50T4ZRGtKQ+YrWKuqJL4sAgPexv63G0tstZSnZwL1m+8vGvGXQOoQPJ87DlSibN2qh3RFu5PODbVxwz2UHie5+iW6ytr1wrmjLXKmrvr2MEW66Q2JyQaYRUKVy/CGQq2ZynTsba/RSwHj/rL/m2FedUFnwZL/a5kC4tM27uJK0brFZBvxD4cicXmN86ZGSfb4x1o8HVW7Zq7JIQBWrsauYr54lgpNFu0K0DGZCpbWr1Cr9bdEgE4LBd4TeY3ZIi5+CWKKLRhQhC7O1tkMlt6wwc05FREPv985tRL/RrqcqMKABWLRzknhWsIi2dgGh13a/DDT13M+MTzB+FNghX2DVrv/Cao3bwvZkj6f0p/ra4/jgMfhMhOwgXaX5I0wD5g6mV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that surplus hugetlb reservasations in the presence of
mempolicies will prefer the nodes in the policy. A couple tests do basic
sanity checking to validate if the rest of the tests should or should
not work.

Note that this does not test the edge cases where reservations would
fall back to other nodes; the intent of this patch series is to "do
better" with reserving surplus pages within mempolicies. Later efforts
may further improve this and result in testing those edge cases as false
negatives.

Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Charles Haithcock <chaithco@redhat.com>
---

- v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
  to consider free hugetlb pages in our mempolicy.
- v2: Folded in Joshua Hahn's recommendation [1] to further modify
  `needed` calculation to take the max of either the available hugetlb
  pages in the mempolicy or the globally available hugetlb pages. Allows
  allocations to prioritize nodes in the mempolicy but can still fall
  back to offnode allocations. Also added selftests to check only for 
  the edgecase which caused this to initially be reported and sanity
  checks.
- v3: Split the change and tests into separate patches and clean up code
  to better align with kernel style guidelines. Likewise, fold in Usama
  Arif's correction [2].

[1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/20260624144600.8159-1-usama.arif@linux.dev/

 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/hugetlb_surplus_mempolicy.c  | 491 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 3 files changed, 495 insertions(+)
 create mode 100644 tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd..40de0938f3 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += hugetlb_surplus_mempolicy
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -260,6 +261,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
+$(OUTPUT)/hugetlb_surplus_mempolicy: LDLIBS += -lnuma
+
 local_config.mk local_config.h: check_config.sh
 	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
diff --git a/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c b/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
new file mode 100644
index 0000000000..e737befcd0
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
@@ -0,0 +1,491 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hugetlb_surplus_mempolicy
+ *
+ * Reserving surplus hugepages within mempolicies is quite tricky due to
+ * the transient nature of cpusets and mempolicies. As such, these tests
+ * do not cover all edge cases, but rather focus on what the kernel can
+ * currently do to reserve surplus hugepages in the presence of cpusets
+ * and mempolicies to help check for regressions in this behavior.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <numa.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include "vm_util.h"
+#include "kselftest.h"
+
+#define HPSIZE_BYTES default_huge_page_size()
+#define HPSIZE_KB default_huge_page_size() >> 10
+#define GLOBAL_SYS_HP_PATH "/sys/kernel/mm/hugepages/hugepages-%lukB/%s"
+#define NODE_SYS_HP_PATH "/sys/devices/system/node/node%u/hugepages/hugepages-%lukB/%s"
+
+struct bitmask **nodemasks;
+int *nodeids;
+
+pthread_t *threads;
+struct thread_args {
+	struct bitmask *my_nodemask;
+	int to_reserve;
+};
+struct thread_args *per_thread_args;
+pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+int wake_cond;
+
+char *nr_overcommit_hugepages_path;
+char *g_free_hugepages_path;
+char *g_nr_hugepages_path;
+char *g_resv_hugepages_path;
+char *g_surplus_hugepages_path;
+char *n0_free_hugepages_path;
+char *n0_nr_hugepages_path;
+char *n0_surplus_hugepages_path;
+char *n1_free_hugepages_path;
+char *n1_nr_hugepages_path;
+char *n1_surplus_hugepages_path;
+
+unsigned long g_free_hugepages, g_nr_hugepages;
+unsigned long g_resv_hugepages, g_surplus_hugepages;
+unsigned long n0_free_hugepages, n0_nr_hugepages, n0_surplus_hugepages;
+unsigned long n1_free_hugepages, n1_nr_hugepages, n1_surplus_hugepages;
+unsigned long orig_n0_nr_hugepages, orig_n1_nr_hugepages;
+unsigned long orig_nr_overcommit_hugepages;
+
+
+/* setup_paths
+ *
+ * Helper function to create strings for the various hugetlb page sysfs
+ * paths. The strings are used to read from and write to the sysfs files.
+ */
+static void setup_paths(void)
+{
+	asprintf(&nr_overcommit_hugepages_path,
+			"/proc/sys/vm/nr_overcommit_hugepages");
+	asprintf(&g_free_hugepages_path, GLOBAL_SYS_HP_PATH,
+			HPSIZE_KB, "free_hugepages");
+	asprintf(&g_nr_hugepages_path, GLOBAL_SYS_HP_PATH,
+			HPSIZE_KB, "nr_hugepages");
+	asprintf(&g_resv_hugepages_path, GLOBAL_SYS_HP_PATH,
+			HPSIZE_KB, "resv_hugepages");
+	asprintf(&g_surplus_hugepages_path, GLOBAL_SYS_HP_PATH,
+			HPSIZE_KB, "surplus_hugepages");
+	asprintf(&n0_free_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
+			HPSIZE_KB, "free_hugepages");
+	asprintf(&n0_nr_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
+			HPSIZE_KB, "nr_hugepages");
+	asprintf(&n0_surplus_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
+			HPSIZE_KB, "surplus_hugepages");
+	asprintf(&n1_free_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
+			HPSIZE_KB, "free_hugepages");
+	asprintf(&n1_nr_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
+			HPSIZE_KB, "nr_hugepages");
+	asprintf(&n1_surplus_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
+			HPSIZE_KB, "surplus_hugepages");
+}
+
+/* get_hugepage_stats
+ *
+ * Helper function to simply grab a bunch of the hugetlb page metrics in sysfs
+ */
+static void get_hugepage_stats(void)
+{
+	read_sysfs(g_free_hugepages_path, &g_free_hugepages);
+	read_sysfs(g_nr_hugepages_path, &g_nr_hugepages);
+	read_sysfs(g_resv_hugepages_path, &g_resv_hugepages);
+	read_sysfs(g_surplus_hugepages_path, &g_surplus_hugepages);
+	read_sysfs(n0_free_hugepages_path, &n0_free_hugepages);
+	read_sysfs(n0_nr_hugepages_path, &n0_nr_hugepages);
+	read_sysfs(n0_surplus_hugepages_path, &n0_surplus_hugepages);
+	read_sysfs(n1_free_hugepages_path, &n1_free_hugepages);
+	read_sysfs(n1_nr_hugepages_path, &n1_nr_hugepages);
+	read_sysfs(n1_surplus_hugepages_path, &n1_surplus_hugepages);
+}
+
+/* save_hugepage_configs
+ *
+ * Helper function to save the current state of the hugepage configs so this
+ * test suite doesn't clobber configs needed for other tests.
+ */
+static void save_hugepage_configs(void)
+{
+	read_sysfs(n0_nr_hugepages_path, &orig_n0_nr_hugepages);
+	read_sysfs(n1_nr_hugepages_path, &orig_n1_nr_hugepages);
+	read_sysfs(nr_overcommit_hugepages_path, &orig_nr_overcommit_hugepages);
+}
+
+/* restore_hugepage_configs
+ *
+ * Helper function to restore the state of hugepage configs before this test
+ * was ran.
+ */
+static void restore_hugepage_configs(void)
+{
+	write_sysfs(n0_nr_hugepages_path, orig_n0_nr_hugepages);
+	write_sysfs(n1_nr_hugepages_path, orig_n1_nr_hugepages);
+	write_sysfs(nr_overcommit_hugepages_path, orig_nr_overcommit_hugepages);
+}
+
+/* reset_hugepages
+ *
+ * Helper function to reset static hugetlb page reservations to 0.
+ * Used to get back to a clear state between tests.
+ */
+static void reset_hugepages(void)
+{
+	write_sysfs(nr_overcommit_hugepages_path, 0);
+	write_sysfs(g_nr_hugepages_path, 0);
+	write_sysfs(n0_nr_hugepages_path, 0);
+	write_sysfs(n1_nr_hugepages_path, 0);
+}
+
+/* can_run
+ *
+ * Does sanity checking first to make sure the tests can even run.
+ */
+static void check_requirements(void)
+{
+	if (geteuid() != 0)
+		ksft_exit_skip("Please run the test as root.\n");
+
+	if (numa_available() == -1)
+		ksft_exit_skip("Numa is unavailable.\n");
+
+	if (numa_num_configured_nodes() < 2)
+		ksft_exit_skip("Not enough nodes to test.\n");
+
+	if (numa_num_task_nodes() < 2)
+		ksft_exit_skip("Current mempolicy is too restrictive.\n");
+}
+
+static void cleanup(char *err_msg)
+{
+	free(per_thread_args);
+	free(threads);
+	free(nodeids);
+	free(nodemasks);
+	free(nr_overcommit_hugepages_path);
+	free(g_free_hugepages_path);
+	free(g_nr_hugepages_path);
+	free(g_resv_hugepages_path);
+	free(g_surplus_hugepages_path);
+	free(n0_free_hugepages_path);
+	free(n0_nr_hugepages_path);
+	free(n0_surplus_hugepages_path);
+	free(n1_free_hugepages_path);
+	free(n1_nr_hugepages_path);
+	free(n1_surplus_hugepages_path);
+	if (err_msg)
+		ksft_exit_fail_msg(err_msg);
+}
+
+/* setup_node_info
+ *
+ * Creates the bitmasks used to isolate test runners and their hugetlb page
+ * reservations.
+ */
+static void setup_node_info(void)
+{
+	int i;
+	int ith_nodemask = 0;
+
+	nodeids = calloc(2, sizeof(int));
+	nodemasks = calloc(2, sizeof(struct bitmask *));
+
+	if (!nodemasks || !nodeids)
+		cleanup("Failed to allocate nodemasks or nodeids.");
+
+	/* Walk the nodes available to us. Create two bitmasks, one of the
+	 * index of the first node available to us, and the second of the next
+	 * node available to us.
+	 */
+	for (i = 0; i < numa_num_task_nodes(); i++) {
+		if (numa_bitmask_isbitset(numa_get_mems_allowed(), i)) {
+			nodeids[ith_nodemask] = i;
+			nodemasks[ith_nodemask++] = numa_bitmask_setbit(
+					numa_allocate_nodemask(), i);
+		}
+	}
+	if (ith_nodemask != 2 || !nodemasks[0] || !nodemasks[1])
+		cleanup("Failed to create nodemasks.");
+}
+
+/* setup_threads
+ *
+ * Helper function to setup space for threads.
+ */
+static void setup_threads(void)
+{
+	per_thread_args = calloc(2, sizeof(struct thread_args));
+	if (!per_thread_args)
+		cleanup("calloc thread args.");
+
+	threads = calloc(2, sizeof(pthread_t));
+	if (!threads)
+		cleanup("calloc threads.");
+}
+
+/* reserve_hugepage
+ *
+ * Helper function to reserve a hugetlb page
+ */
+static unsigned long *reserve_hugepage(void)
+{
+	return (unsigned long *) mmap(NULL, HPSIZE_BYTES, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+}
+
+/* thread_work
+ *
+ * Test runners. Performs the work of reserving and freeing hugetlb pages.
+ */
+static void *thread_work(void *arg)
+{
+	struct thread_args *t_args = (struct thread_args *) arg;
+	unsigned long **hugepages;
+	int i;
+
+	hugepages = (unsigned long **) calloc(t_args->to_reserve,
+						sizeof(unsigned long **));
+
+	/* Reserve hugetlb pages on my node */
+	if (t_args->my_nodemask)
+		numa_bind(t_args->my_nodemask);
+	for (i = 0; i < t_args->to_reserve; i++) {
+		hugepages[i] = reserve_hugepage();
+		/* Tests may purposefully try to overallocate, so just
+		 * fallthrough rather than error out
+		 */
+		if (hugepages[i] == MAP_FAILED) {
+			t_args->to_reserve = i;
+			break;
+		}
+	}
+
+	/* Go to sleep until main thread wakes us up */
+	pthread_mutex_lock(&mutex);
+	while (!wake_cond)
+		pthread_cond_wait(&cond, &mutex);
+	pthread_mutex_unlock(&mutex);
+
+	/* Try to free those hugetlb pages */
+	for (i = 0; i < t_args->to_reserve; i++) {
+		if (munmap(hugepages[i], HPSIZE_BYTES) < 0)
+			ksft_perror("munmap() failed! Check for leaked hugetlb pages!\n");
+	}
+	free(hugepages);
+	return NULL;
+}
+
+/* wake_children
+ *
+ * Helper function to wake children threads.
+ */
+static void wake_children(void)
+{
+	pthread_mutex_lock(&mutex);
+	wake_cond = 1;
+	pthread_cond_broadcast(&cond);
+	pthread_mutex_unlock(&mutex);
+}
+
+/* test1
+ *
+ * Sanity checking, attempt to reserve a surplus hugetlb page anywhere.
+ */
+static void test1(void)
+{
+	reset_hugepages();
+
+	write_sysfs(nr_overcommit_hugepages_path, 1);
+	per_thread_args[0].my_nodemask = NULL;
+	per_thread_args[0].to_reserve = 1;
+
+	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
+
+	usleep(500000);
+
+	get_hugepage_stats();
+	ksft_test_result((g_free_hugepages == 1 && g_nr_hugepages == 1 &&
+			 g_resv_hugepages == 1 && g_surplus_hugepages == 1) &&
+			 ((n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
+			 n0_surplus_hugepages == 1 && n1_free_hugepages == 0 &&
+			 n1_nr_hugepages == 0 && n1_surplus_hugepages == 0) ||
+			 (n0_free_hugepages == 0 && n0_nr_hugepages == 0 &&
+			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
+			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1)),
+			 "Reserve 1 surplus hugepage anywhere\n");
+
+	wake_children();
+	pthread_join(threads[0], NULL);
+	wake_cond = 0;
+	reset_hugepages();
+}
+
+/* test2
+ *
+ * Sanity checking, attempt to reserve a surplus hugetlb page with
+ * a mempolicy.
+ */
+static void test2(void)
+{
+	reset_hugepages();
+
+	write_sysfs(nr_overcommit_hugepages_path, 1);
+	per_thread_args[0].my_nodemask = nodemasks[0];
+	per_thread_args[0].to_reserve = 1;
+
+	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
+
+	usleep(500000);
+
+	get_hugepage_stats();
+	ksft_test_result(g_free_hugepages == 1 && g_nr_hugepages == 1 &&
+			 g_resv_hugepages == 1 && g_surplus_hugepages == 1 &&
+			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
+			 n0_surplus_hugepages == 1 && n1_free_hugepages == 0 &&
+			 n1_nr_hugepages == 0 && n1_surplus_hugepages == 0,
+			 "Reserve 1 surplus hugepage on node0\n");
+
+	wake_children();
+	pthread_join(threads[0], NULL);
+	wake_cond = 0;
+	reset_hugepages();
+}
+
+/* test3
+ *
+ * Set a static hugepage and reserve off node
+ */
+static void test3(void)
+{
+	reset_hugepages();
+
+	write_sysfs(nr_overcommit_hugepages_path, 1);
+	write_sysfs(n0_nr_hugepages_path, 1);
+
+	per_thread_args[0].my_nodemask = nodemasks[0];
+	per_thread_args[0].to_reserve = 0;
+	per_thread_args[1].my_nodemask = nodemasks[1];
+	per_thread_args[1].to_reserve = 1;
+
+	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
+	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
+
+	usleep(500000);
+
+	get_hugepage_stats();
+	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
+			 g_resv_hugepages == 1 && g_surplus_hugepages == 1 &&
+			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
+			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
+			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
+			 "Set 1 static hugepage on node0, reserve surplus hugepage on node 1\n");
+
+	wake_children();
+	pthread_join(threads[0], NULL);
+	pthread_join(threads[1], NULL);
+	wake_cond = 0;
+	reset_hugepages();
+}
+
+/* test4
+ *
+ * Reserve static hugepage on node0, reserve surplus hugepage on node1
+ */
+static void test4(void)
+{
+	reset_hugepages();
+
+	write_sysfs(nr_overcommit_hugepages_path, 1);
+	write_sysfs(n0_nr_hugepages_path, 1);
+
+	per_thread_args[0].my_nodemask = nodemasks[0];
+	per_thread_args[0].to_reserve = 1;
+	per_thread_args[1].my_nodemask = nodemasks[1];
+	per_thread_args[1].to_reserve = 1;
+
+	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
+	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
+
+	usleep(500000);
+
+	get_hugepage_stats();
+	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
+			 g_resv_hugepages == 2 && g_surplus_hugepages == 1 &&
+			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
+			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
+			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
+			 "Reserve 1 static hugepage on node0, reserve surplus hugepage on node 1\n");
+
+	wake_children();
+	pthread_join(threads[0], NULL);
+	pthread_join(threads[1], NULL);
+	wake_cond = 0;
+	reset_hugepages();
+}
+
+/* test5
+ *
+ * Reserve static hugepage on node0, reserve surplus hugepage on node1 and
+ * fail to over allocate another.
+ */
+static void test5(void)
+{
+	reset_hugepages();
+
+	write_sysfs(nr_overcommit_hugepages_path, 1);
+	write_sysfs(n0_nr_hugepages_path, 1);
+
+	per_thread_args[0].my_nodemask = nodemasks[0];
+	per_thread_args[0].to_reserve = 1;
+	per_thread_args[1].my_nodemask = nodemasks[1];
+	per_thread_args[1].to_reserve = 2;
+
+	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
+	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
+
+	usleep(500000);
+
+	get_hugepage_stats();
+	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
+			 g_resv_hugepages == 2 && g_surplus_hugepages == 1 &&
+			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
+			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
+			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
+			 "Intentionally overallocate and fail due to nr_overcommit_hugepages limit.\n");
+
+	wake_children();
+	pthread_join(threads[0], NULL);
+	pthread_join(threads[1], NULL);
+	wake_cond = 0;
+	reset_hugepages();
+
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	check_requirements();
+	setup_threads();
+	setup_node_info();
+	setup_paths();
+	save_hugepage_configs();
+	wake_cond = 0;
+
+	test1();
+	test2();
+	test3();
+	test4();
+	test5();
+
+	restore_hugepage_configs();
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index c17b133a81..cd368ce590 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -297,6 +297,7 @@ CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
+CATEGORY="hugetlb" run_test ./hugetlb_surplus_mempolicy
 
 if [ "${HAVE_HUGEPAGES}" = "1" ]; then
 	nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
-- 
2.55.0



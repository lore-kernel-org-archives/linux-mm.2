Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E72BCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30AD76B008A; Tue, 23 Jun 2026 14:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB3B6B008C; Tue, 23 Jun 2026 14:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185D46B0092; Tue, 23 Jun 2026 14:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D77A66B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:46:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 387DA1405D0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:46:22 +0000 (UTC)
X-FDA: 84912057804.05.80348D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B22F6160003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:46:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K4F1HIEL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782240380;
	b=naA0kkrmtq4feFFiCbx7oukDbpVrSRw1uqICNk+x63Dn6VEVHJQu5qvSbCJTuZH35pTfH2
	0mfcWGgCxM1f1y5HjHu7sDFjmjqRjPJPL8J/f6rhc8HR0CVZqUzjKuZd2hqKZ8h8n3Wn1e
	4qhxZiE/NNI0mZBfhhSvqWqfLAV/Vhg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782240380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N0QRfIw2YKRx1CrkMCXEwhzl/uEwsDhHFOP/1CbnF3M=;
	b=MTIj1zpvSfcoazN2+d7d50Nqe4qd1a94zE3eWFr+tntl9ku+EKQfvswQyCgFr4DcLTqWyT
	PeBNQQmfpdMCoP/NwkoxklGxLqYKT1hTK2xleNn+SybIAkh6glIWMkJ3rTS6tl+sTPrzuU
	b7nRkMUoW56BVh84a/OSbC7QshGskEE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K4F1HIEL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782240379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N0QRfIw2YKRx1CrkMCXEwhzl/uEwsDhHFOP/1CbnF3M=;
	b=K4F1HIELV+YBxTRxd/59BNIt593HeV2X9RgWBSR9dQBzcnEl6oljVs8XspEmtmhZ7wkyhv
	DRjDzXd/HbMtIaz8p9KfohlH/Tjwjyc04/W4K6kKHk4hex4+sqKLGjPaHhFF2ivq4WKn2m
	l5vkrNglEr535TqX/I6+AUsNnSEPjsU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-N1EYBVAnP067oIRT0iFNtw-1; Tue, 23 Jun 2026 14:46:17 -0400
X-MC-Unique: N1EYBVAnP067oIRT0iFNtw-1
X-Mimecast-MFC-AGG-ID: N1EYBVAnP067oIRT0iFNtw_1782240377
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-923c6c59f63so19491185a.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240377; x=1782845177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0QRfIw2YKRx1CrkMCXEwhzl/uEwsDhHFOP/1CbnF3M=;
        b=LnsfiRF4Jxmla3PbFtDmUZM+oiQ39f79pzvKJCR/Y7LatKn49lemdI6t27++30D4Y0
         51r5FG4HYO8roFqzba3fMdP2tgKSpuJtOYa+LT/Gxd0n9AGCM+62BJWfkjh7GJonbEA0
         8EKZcoJs+g/N7EB4OlH8T9ckEx3KHbJQK5UDbDnuSKpsHgMazTD8C5oEJ2xWSiI4TH/W
         jrByjluDX0GXd4htRB/WnkGvFL0ijWPNrqUb5vuuDWAWDDZdEuympxoll7YOpmD6ydUk
         bpOBlAjzQUxO7plPuhuz2aej1cjCW2J+6pMaIUq4oIHSGPEo08F5+Cp09yv4jsGnb/RG
         PDAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8xHGyjwaPyrg1w3Mnd5fIV0A1FfgGxoRDhboAHdKkJizEr5UDzzBn9ceEkqlHncGF5sqJgqPHiJA==@kvack.org
X-Gm-Message-State: AOJu0YxeG3i4OcHtUhL4fHP2n260GCZ6NzljNwyprpjpB2EwyjWntdup
	i6vImg3ZRyj4F3QvnDZsPKje936PNne/zoUmC6Cr5XzoGpIRYB/Pxe0zOAtDKPovQaVGvfNLuze
	sFdIRXAjQmUgZBOauuhDnMtd7JsmHTs6fJ+TT85W+hLpmdzqPl1qvCOAFZ2ch
X-Gm-Gg: AfdE7ckM8Ht8Xmd2EswzPZM/LO2RHhpc5vXGZQavCxJEvS73ucBra6KM+AVM2ggs++q
	9v5CnaMzcJff87VYXW0wHv5HbVP8AecYkcGDyp53HXQdnYydAYurvERRudRjznbLJtzS3bs5Px+
	cKBSZu1uxzcIUVDPLaob7PKvOtXrcCMvJJqs432D55FejNQlJe0MCtZ1DLREQrKx5OJPWW45dr6
	j/wz8t9IDl6MqG+2RMkTwA3Md7cAyYR7SjM3lCffpHatc7++nPQa3m9psBC2VEXpjB7BNYNLEfe
	k8AgOII9gJfkRU/NcN6HfM+EUdFQNiGrAl+cWgfUBSoPrZr5CjW/OEHPHrJX5kpaD+EnMuZq++B
	BNgB02zdaZ/g8l+WMPoOebhPXeWHOhJwo/cfsUWO+4+d0M9BL10O2dMwjIvYLUbSW6MBFDJo19J
	q4
X-Received: by 2002:a05:620a:17aa:b0:916:16d8:6319 with SMTP id af79cd13be357-927850eb14amr38009285a.53.1782240376738;
        Tue, 23 Jun 2026 11:46:16 -0700 (PDT)
X-Received: by 2002:a05:620a:17aa:b0:916:16d8:6319 with SMTP id af79cd13be357-927850eb14amr38002785a.53.1782240376144;
        Tue, 23 Jun 2026 11:46:16 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.rmtusco.csb (184-96-169-147.hlrn.qwest.net. [184.96.169.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fd390e76sm348044485a.3.2026.06.23.11.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:46:14 -0700 (PDT)
From: Charles Haithcock <chaithco@redhat.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: Charles Haithcock <chaithco@redhat.com>,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: [PATCH v2] Respect mempolicy when calculating surplus huge pages.
Date: Tue, 23 Jun 2026 12:45:42 -0600
Message-ID: <20260623184548.1245488-1-chaithco@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9AihynQDiGrQDmeGypol5wrGQBvvNwWVVQrAW33fIwI_1782240377
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B22F6160003
X-Rspam-User: 
X-Stat-Signature: z9gp7ewgoyhsaw3tf9gh88nee7jjreth
X-HE-Tag: 1782240379-897208
X-HE-Meta: U2FsdGVkX1/pwpVx/8ec1Bt3X1aEi1XpWklGwezUwbgt2bzuaMKLjnAdgQgpweNozejAwnDGl0GvszVCctucfodNsrWNJtbjciH0YvrUNEUnPqdkW/+gH/+BaQ0yk97JsIbOFMBflLDVWrxrF/1QcE9eK2yHNhrdSY34OlR9SqUoUoeHKWkx0qEgZuDhu9oy8HQM4LBukvKqBdTDz6b/J6Kc+S9nYPdby25n2a972MUwCLJmZd2rnNIkscFLIMGtxNSlznQj0BtwI0dDBxS/P0eCtzJoo9JD8bQiT87DMJv0NixP+1Ta0tLwWETscLcvqlNqHWwQMWS3kh9PM1ryn+9uBBruTe+vddSMiwfzZfWWJ4Cac4dmznJwcsXqSV4Ill4AAnKwGpUvVtc9Gd28C/cZ0P2x1NGQTB46fQPOpN5ztu64Adcgn3491d6R0HOY19unv2osVk7m5kYYQ8a2cUjEVSo5EFETBGnw8Y2ovHZHMEqf5guqhAYsNXEkS7Yepl8t7HsowEgPKu3jm63IawxfCqxlz2iVCWGmYZqMbIHr76YnYfttehAQsFWNL2aJKiUwWPDTZKuxA4TJjnfPf2upMZw00+lJ4Q0StgB5F2uwDZJlWiHPIjhbsa9si5xUvg5DVhsEhgjVBQ0UTRRVYBvD/gD+HVl8Xllqghen0SQ7w6p1DElWqTNC9jHB62g3RsldKKThnkw2vDFQyzJM2F5moJNi2OpcRxRJS8ILIhVcfHE+baQO31BmI1wYBs6XN0R/QQmm36Qc52xEBFH3i6aDJPr6ayLFNkOMChBdi32Pg+ZRLaVBd+s7cQC5jo345Pf5rvgxSp1+B4MEZPOcZ2c+hpwLSQbvDujYrWr6Z6a+m2AAgNGdCttNBYuqAgowR/dvqpU2sH+EW5gElVpWWRnDNuoVgw3x+zl0AuU4dmbEQ60ZlASrgPk6t7Nrj240EbuB2R2xnJr0MuOXf7o
 RFE955iB
 sVGfLCI6R4EDoKl7UGyLYtFOVr7jWP9xK6E6f/SUdj7B6P3Jz7tkH6CbX/XJdatBJoteLGek/8RRXMvF2JuU7nYb3JXJmhWmyribkPRo9w8q5yushFDStJ74j/OnCnRYOTx5+3hVUSwq8hKuxh1K2P7WMaB2XmL5TiPS7HoBNbMVxbsxGGOV2drHkOZoOqTzO4EAxr1s9BgPesGyPKMZL07WnCRxSCtnjV44R+HeMHsggT+wq7tt76OzqQkSkiYUaiXVGKwjcAeqT6GWiVLDQFI+1mpYSURDCrhHJ8QHUMkE/W2lKIvbbcwi89A95Zv5b2/aWwygaZvs38VyJA989OigxRASAK8fD63tVWqOOZ4/k0KHQTJfrdBh7kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Presently, when calculating how many huge pages are needed when
reserving surplus huge pages, the global count of free huge pages
are used. When reserving with a mempolicy, the global count of free huge
pages is used even if some/all of those free huge pages are on numa
nodes outside of the mempolicy.

Reserving surplus huge pages is ultimately best effort even without a
mempolicy. Restrictions from cpusets and mempolicies further complicate
calculating correct numbers of surplus huge pages to reserve and
maintaining which nodes those reservations belong to (see the comment in
`hugetlb_acct_memory`).

However, we can do a little better when reserving surplus huge pages
with a mempolicy. This patch changes how to calculate the necessary
amount of surplus huge pages to reserve by considering the max of either
the amount of free huge pages on nodes in the mempolicy or the global
amount of free huge pages. We may still attempt to reserve huge pages
outside the mempolicy, however, we end up being more likely to reserve
from nodes in the mempolicy.

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

[1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/

 mm/hugetlb.c                                  |  42 +-
 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/hugetlb_surplus_mempolicy.c  | 472 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 4 files changed, 498 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be0..bd97f0f434 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
 	return NULL;
 }
 
+static unsigned int allowed_mems_nr(struct hstate *h)
+{
+	int node;
+	unsigned int nr = 0;
+	nodemask_t *mbind_nodemask;
+	unsigned int *array = h->free_huge_pages_node;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+
+	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
+	for_each_node_mask(node, cpuset_current_mems_allowed) {
+		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
+			nr += array[node];
+	}
+
+	return nr;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2277,7 +2294,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+	needed = max((long) (delta - allowed_mems_nr(h)),
+		(long) ((h->resv_huge_pages + delta) - h->free_huge_pages));
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
 		return 0;
@@ -2311,8 +2329,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	 * because either resv_huge_pages or free_huge_pages may have changed.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) -
-			(h->free_huge_pages + allocated);
+	needed = max((long) ((delta - allowed_mems_nr(h)) - allocated),
+			(long) ((h->resv_huge_pages + delta) -
+				(h->free_huge_pages + allocated)));
 	if (needed > 0) {
 		if (alloc_ok)
 			goto retry;
@@ -4513,23 +4532,6 @@ static int __init hugepage_alloc_threads_setup(char *s)
 }
 __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
 
-static unsigned int allowed_mems_nr(struct hstate *h)
-{
-	int node;
-	unsigned int nr = 0;
-	nodemask_t *mbind_nodemask;
-	unsigned int *array = h->free_huge_pages_node;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-
-	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
-	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
-			nr += array[node];
-	}
-
-	return nr;
-}
-
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h;
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
index 0000000000..0a77b01693
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
@@ -0,0 +1,472 @@
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
+struct thread_args* per_thread_args;
+pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+int wake_cond = 0;
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
+unsigned long int n1_free_hugepages, n1_nr_hugepages, n1_surplus_hugepages;
+unsigned long int orig_n0_nr_hugepages, orig_n1_nr_hugepages;
+unsigned long int orig_nr_overcommit_hugepages;
+
+
+/* setup_paths
+ *
+ * Helper function to create strings for the various hugetlb page sysfs
+ * paths. The strings are used to read from and write to the sysfs files.
+ */
+static void setup_paths(void) {
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
+static void get_hugepage_stats(void) {
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
+static void save_hugepage_configs(void) {
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
+static void restore_hugepage_configs(void) {
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
+static void reset_hugepages(void) {
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
+static void check_requirements(void) {
+        if (geteuid() != 0)
+                ksft_exit_skip("Please run the test as root.\n");
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
+static void cleanup(char* err_msg) {
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
+static void setup_node_info(void) {
+	int i;
+	int ith_nodemask = 0;
+
+	nodeids = calloc(2, sizeof(int));
+	nodemasks = calloc(2, sizeof(struct bitmask *));
+
+	if (!nodemasks || !nodeids)
+		cleanup("setup_node_info: calloc.");
+
+	/* Walk the nodes available to us. Create two bitmasks, one of the
+	 * index of the first node available to us, and the second of the next
+	 * node available to us. */
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
+static void setup_threads(void) {
+	per_thread_args = calloc(2, sizeof(per_thread_args));
+	if (!per_thread_args)
+		cleanup("calloc thread args.");
+
+	threads = calloc(2, sizeof(pthread_t));
+	if (!threads) {
+		cleanup("calloc threads.");
+	}
+}
+
+/* reserve_hugepage
+ *
+ * Helper function to reserve a hugetlb page
+ */
+static unsigned long* reserve_hugepage(void) {
+	return (unsigned long *) mmap(NULL, HPSIZE_BYTES, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+}
+
+/* thread_work
+ *
+ * Test runners. Performs the work of reserving and freeing hugetlb pages.
+ */
+static void *thread_work(void *arg) {
+	struct thread_args* t_args = (struct thread_args*) arg;
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
+		 * fall through rather than error out*/
+		if (hugepages[i] == MAP_FAILED) {
+			t_args->to_reserve = i;
+			break;
+		}
+	}
+
+	/* Go to sleep until main thread wakes us up */
+	pthread_mutex_lock(&mutex);
+	while(!wake_cond) {
+		pthread_cond_wait(&cond, &mutex);
+	}
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
+static void wake_children(void) {
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
+static void test1(void) {
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
+static void test2(void) {
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
+static void test3(void) {
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
+static void test4(void) {
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
+static void test5(void) {
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
+int main(void) {
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	check_requirements();
+	setup_threads();
+	setup_node_info();
+	setup_paths();
+	save_hugepage_configs();
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
2.54.0



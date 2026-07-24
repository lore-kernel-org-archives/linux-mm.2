Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ACFC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FECD6B00AC; Fri, 24 Jul 2026 06:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5AE6B00AD; Fri, 24 Jul 2026 06:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC076B00AE; Fri, 24 Jul 2026 06:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 661AB6B00AC
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5BDEA0362
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:26 +0000 (UTC)
X-FDA: 85023288252.04.0BEFE01
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id F05F2180007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SYgESkRN;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lacc3nK2S5zCHlNsaFWqguxu71tiajkY5HjiEwNe7VE=;
	b=7PeUd00KfamMHw65wtgAz5v5/JYT/S4iBk+Xk9q4SOjgNJ1YimZ1YGDICsmEm0hKQ0Szj5
	vqGMZS/a+/Z8mzBpVdjCnZDZ3vAT1nydf9O5jLygx+/cRJHepSc2Cuk1MyCDRhRLADDBvD
	3diltyN9aXl1wFdXxRcNvq6KXBAMYBA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SYgESkRN;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888725;
	b=6hPFhwz2ZfLddwEWHA0vn3KxVP9u3QUqWoUBsLyieClMGXiVKaS0PPHrDLiLSBBGLIRM4o
	IuEk7dhayqVDPCwcBVVA0PSwj2vlywhjAQDZc/uqHEXAIFs3e8LnjkvpMs92PL4iJsI/vf
	2yPLTqv7JndTWLu2Y+0GYzPJ6xAYqEs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53A8C1477;
	Fri, 24 Jul 2026 03:25:19 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D3083F66F;
	Fri, 24 Jul 2026 03:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888723; bh=PTkd813JAn6wO/CqG5+sfWiGVF8RyWenBAffF9OaPTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYgESkRNnBZJfRvPIAM2Qt/TdjRWqMzPBuD4hU94OL1ezv2gj3cU8HFwZ8nTnwxfm
	 ANbgDoeQZ+2WHT5aRpezBSm9mb/FES6quOK2ZBDucx6beJ1r/uG/Xcs2ktDs2NdTWP
	 umVLYO3cSq91pKgdGhdg2w6PzxcAOjpcG25Vz5Hc=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sarthak.sharma@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 5/5] selftests/mm: retry migration failures for the full runtime
Date: Fri, 24 Jul 2026 11:24:28 +0100
Message-ID: <20260724102431.1199519-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102431.1199519-1-usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F05F2180007
X-Stat-Signature: sbounqff7eq6k3bppt34z3kuacjd4c5p
X-HE-Tag: 1784888724-814876
X-HE-Meta: U2FsdGVkX19pZcTes0ZU7+3LXxQsqNOCxq6xStVZo1k9eZO6qB8RFqcZjhjG8K6uyYdhane4blt9K2TFiQsAG9tnx/zZqaL1rHaEr8c+abav1FSUvK+jMbLrEuBPFNQRpMHIGflVFK7gGX3+MT8DGYOD+y1qYv920JX9930f7BH2+sxPgUKn2oeufvK7nHelDC+rmxael/gL4pFeix9NROdSLqORc3Z3pne6LB++mUYQd0HQiZ5/X+mKmnnezgYsTNOMweI2weu3FdnuNUrzgjNWm9JDDSUF3ty+Q2ARXbVyhYqP0hGtueDCpQSuOs3F7Xcai1dV9bqoA0vOq/zdMY7vIUOMRvkYMhR47Gsyn7ayBVdw2odkoOALrtTJQGfYWzVzrZMZd/3zsQMKj6aQzlcqx+yzhC3SVQohYpVEVj1SQSJe00GER8uqV5A4Qt8ltWe4ruPnVqOooK/wqcaD2yFlLAABzHfcfDFtNoCbk4NFBSLznllnPQLoIMDi0GrAGnFC88DhoFZ57ZdZHMu/oSd6xaBCWGdz+NTQcsnO/KbM9ojw08Y3wPoxMAwRHKr6OdYV4O20ZSShnfBK2KX+91SbeSNPefL3/SQ/+VDMEzPWUp8lZ7dcM2jsiwh/urf+5vJH3Xj/htbyQlh7lKg01g4+QwjQMyIAsv4IhCRvZs70+YR1O4vkTYMTBtXyGsa38ZRWkQ7Y4UyqGtUQDg8JS5IR2+PAXCWT5u8hajP69gBXZ9he/Zrc1x6U5dvGb/QBne28bakL+nJvYhpxdsgKR+Lj7kSdUlfeibIWrkYEReAHpZ2ZLyWqI+8pQnG3jsgHt5/ev+l57DSMqJZF7zNPAkAdXlBPCQO7DPo89PjPt9xwlNuvV3ZnnVYApC4RRvQ7ZaC3UD8LjZE5bXJIFTPnZHCTNXSg+QFBRmVcMcK6WbdlC2NxpVwBvDIxUd7f2JS5c00C/HIdZjuhrWrLzrI
 Bj7/xupK
 IuPoycOZI+BQoyMFyFdR+AYX8kanK5+Ts/ks2Fo9JV8dTK07gn5D7tomiXQ5ZX+BuzdSnJHVH3T+Mz4CZGcSdCJOb2CxHa82HnuM9w+sNYMPWyh+xMNiXpp0+oD7wRILR8IE7gxkoyjx/+yHQ4EGElunDC+I+TXMQHPO/6hVRH/q6HKkkwj8DQwPqPTCtCOvY8mRf1jbZpkFmjYHeBZS6gBPFodwqtk1HsJMZCK2/NKWJ/BImaygO1Zt0/2nbvlPOPimRkPhmw31siWIWLpAVtZut3wCe7Y5QtXYZmC5K+imwBMnAfQrjFBZNmUZd4uKYCyTm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages() is best effort and can temporarily fail when concurrent
faults race with page unmapping. A busy shared-anon workload can exhaust
the current 100 retries long before the intended 20-second runtime and
produce a false failure.

Use the full runtime as the retry window. Since the initial page location
is unknown, require it to reach both alternating NUMA targets to confirm
that cross-node migration made progress despite transient contention.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Retry per-page failures for the full runtime
- Verify that both alternating NUMA targets are reached
---
 tools/testing/selftests/mm/migration.c | 39 ++++++++++++++------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 29f7492453d43..4d55a424058a9 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -7,7 +7,7 @@
 #include "kselftest_harness.h"
 #include "hugepage_settings.h"
 
-#include <strings.h>
+#include <string.h>
 #include <pthread.h>
 #include <numa.h>
 #include <numaif.h>
@@ -20,7 +20,6 @@
 
 #define TWOMEG		(2<<20)
 #define RUNTIME		(20)
-#define MAX_RETRIES	100
 #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
@@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n2)
 	int ret, tmp;
 	int status = 0;
 	struct timespec ts1, ts2;
-	int failures = 0;
+	int success = 0;
 
 	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
 		return -1;
@@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
 		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
 			return -1;
 
-		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
-			return 0;
+		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
+			/* Reaching both targets verifies a cross-node move. */
+			if (success >= 2)
+				return 0;
+			else
+				return -2;
+		}
 
 		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
 				MPOL_MF_MOVE_ALL);
-		if (ret) {
-			if (ret > 0) {
-				/* Migration is best effort; try again */
-				if (++failures < MAX_RETRIES)
-					continue;
-				printf("Didn't migrate %d pages\n", ret);
-			}
-			else
-				perror("Couldn't migrate pages");
-			return -2;
+		if (ret < 0) {
+			perror("Couldn't migrate pages");
+			return ret;
 		}
-		failures = 0;
+		/* Migration is best effort. Try again */
+		if (ret > 0 || status < 0)
+			continue;
+		if (status != n2) {
+			printf("Page is on node %d instead of target node %d\n",
+			       status, n2);
+			return status;
+		}
+		success++;
 		tmp = n2;
 		n2 = n1;
 		n1 = tmp;
 	}
-
-	return 0;
 }
 
 void *access_mem(void *ptr)
-- 
2.47.3



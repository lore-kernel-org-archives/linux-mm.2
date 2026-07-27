Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D1CC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A8E6B0099; Mon, 27 Jul 2026 05:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAF66B009B; Mon, 27 Jul 2026 05:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008486B009D; Mon, 27 Jul 2026 05:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB4006B0099
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:53:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D41D8068F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:53:01 +0000 (UTC)
X-FDA: 85034092962.26.277033E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E0ED1C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEK1gDV2;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2rceoeRxfYHCgP3wyFnEef4w75Wsa2jQVhzWb4z8e0=;
	b=psWs34GczR/2t3yRWEUwOh7LGSBdChpRDtdoZScHj0GAamsRtuZTX78JBz52NsYiXJ/taH
	/t8SQkmnzgOKRUrE6rsloPVclWmPifF14fHqRauNXg4AQAopjI0M0u36IkUhjlTrcbX7b/
	M6GUYGQT9ZEtX19rfYpGhvtDVNMauBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145979;
	b=6xU1cIgffIgpFmAEs/FMDLfUES7UKZ1Ao243tEmYc/p0rTI2mp7NjcrWTk7Ny0cgTS7khE
	gjA3aqhg0zmimAyKjyRPVps75ILhwtaxr1eYb3y5sWswviIzf1elfsl1LSbZoS2AuvVOYm
	JXKVJmyDmN06X3Dn81OoYPQbN54rsxE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEK1gDV2;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7877E1476;
	Mon, 27 Jul 2026 02:52:54 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3BBB93F66F;
	Mon, 27 Jul 2026 02:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145978; bh=dzW8Sc4XWBgaC1kpkf55Z8zewTfVHC6YVmXcerdGHUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEK1gDV2inNiNl3LwSunrlXFelTRomyhCE5yVMQrbyN8wA33f4Y5CVDocBPvTIGmg
	 E4p7saWrHlR5XoQNxcaiMqADedlhoFegxKXvQjnj4vcHSVHev0I4k3mQ/eawcVq353
	 w0nvAyRGnKcfEjBdnnit4ggwRPxgM4zgEIxhnD1A=
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
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 5/5] selftests/mm: retry migration failures for the full runtime
Date: Mon, 27 Jul 2026 10:52:21 +0100
Message-ID: <20260727095225.372655-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095225.372655-1-usama.anjum@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E0ED1C0009
X-Stat-Signature: 3xfkatuopdmmrggxjt76zsxm9scugxap
X-Rspam-User: 
X-HE-Tag: 1785145979-591463
X-HE-Meta: U2FsdGVkX19ldAobREYcdftPLK35VOTbBZyABU7uLKrqSPfiN4BIFYJMA0+EwWJ3BFbp/WMEccClvgMkwMA6PktPug7mOEyoEjRsKLKoVcYQDHrIA+B7Z0Huku5qUjsSCjqy1SeYOr/eRTpQYGt+TiEzQWkOWvaeFrJ2weBRyFhHdYy08IyonJttulwqBP+QV5j1MkVfToqh9r1UNkG8ag+3TDHCR3LLsLRlWRDodmZR8KWQ1qwJxjPmHPlNWQpsyFXL4cAf47s7KnCSngXM+frMvkpnewJHOFAzg364LZT390J+/lOapRrCtLlwOMte44rg8duaytVt1iEwKCIUxW9RwxcVjX5CtGUCa6Av/rsgkpmFHSjVqP92RhZRzu8EzAhtjCXgO31XE0zKKBkjU7Xo6rbWE7mSWEDkpCCFvnu3577dJn4w6Vv35UA2kIO7nxVVnck6euBJze9UC5RcxsLJRpnkJETAHz7iLLfMPh9eSvEHlsM6HyLdmPZefVPH6PuaU/ixkB33ohDoRb/be5PhxWAVm6Z+/CgsSBL8MwC8+0LduxBkvsP7YRGQ1/hFOdGMf4+apWZEyRggC0r4GwpiaWZe2R3z4nmtOd10aBB0TUMSxCHRWDJZGzhKmc9f402ZNcSJ3j6n9nYgDUvIAcJjemcL0GRuGCooCcIoO6D/FPU0MBa6IL5y+CyiNTM8hDgQZ9e4AjIWtSZEUNOIEdvXs64K5UImO0sESQbyPWQlcsftSFhN6sD9KgoBLUAD39p1911vwwQvI5Bz8rXtYrBIjwnY+ZmxPDyX7pUjBOFMuKLKVxj8WFgvMNkBZaqlF3TzzqwzxCmD4jmIsMILNg0I15ECRZhqnivzkuaCzl3geW2gsKF0tdqXF/7PiAry9hUTDGAVpGMsOLWCsClYN4cy35HRWdahbxaahJObc6DciF1C4HCzt1dUZYvDP4odYBqRIc69UqXSejmCiAB
 7ox6/xCu
 dT2aeOC1oNt8zDolA4/xEvn2QPHD5t2V8FW0WW1YBd2gHVoVMJ2rUfIR/yQ3vDU1EWVW14SuGMJDHEPjliLD1uMP0iT2c/o+lG5Qj9u/SewyoDwDflQ/NoyrOfL8RKRSeO2Lb0yQSRMl719jLcmJa1yerA8UMBJpj07CDFx8L72GTb1FiMwOhUaWhrYaiQNy41NEhvG2+/dzVelHTJ/j3X03PUcXenJjaSyYQ45Oiy/kCblV/iIXluYFXGz89QmJHjK+WCSkXw2a31+4AF4M7xUBaeudV6yMpWL+wyLclNV6dNdtrQumv5CpmCiSqxU1FMbXG
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
Changes since v2:
- Return -2 when the page is not on the target node.

Changes since v1:
- Retry per-page failures for the full runtime
- Verify that both alternating NUMA targets are reached
---
 tools/testing/selftests/mm/migration.c | 37 ++++++++++++++------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 29f7492453d43..f19d53c695764 100644
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
+		if (ret < 0) {
+			perror("Couldn't migrate pages");
+			return ret;
+		}
+		/* Migration is best effort. Try again */
+		if (ret > 0 || status < 0)
+			continue;
+		if (status != n2) {
+			printf("Page is on node %d instead of target node %d\n",
+			       status, n2);
 			return -2;
 		}
-		failures = 0;
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



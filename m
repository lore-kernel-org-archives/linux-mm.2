Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC62C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9E06B0099; Wed, 22 Jul 2026 05:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1876B009D; Wed, 22 Jul 2026 05:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE0C6B0099; Wed, 22 Jul 2026 05:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAE96B0099
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84A20803ED
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:46 +0000 (UTC)
X-FDA: 85015847532.03.799F939
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C291B14000A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oS8ZvJdS;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711565;
	b=n7YXSGC2wJD9GlR+Agb+PX26xfr8LuVmXo8vlATKY7sWNqbesQopOKnA+IQlTUk8skn/lU
	Vdf7jc3A/jOBteUqvSh/TrcGttzSIRYGXvzq95eyMMHQfUr7zdUMjzNOzyjZGXR3NJLYH8
	DiNW+tnipIKlWIfMtwC7eWnB27mSjVQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oS8ZvJdS;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmgXCtLFj/W9Xi358sr4Ha8NbnGF/mAXiBQiDiKgJJk=;
	b=KpCW1kEb3nMmRX4fjRytPaW22jLXjzH0P5/+LZn48MRIYw9voVcb9Nl4j/oIIk9hIXkiBe
	g4omU4SnmvcTc8Plm5VyyMDEd6oHykKN/Hb1um48Gn3bhCG3XuraPw7gMBO1/BjDC+0XY0
	xYfXIyHpzAe23APabin254ilSD+QVxE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB9021595;
	Wed, 22 Jul 2026 02:12:39 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7C253FC81;
	Wed, 22 Jul 2026 02:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711564; bh=zU+WJI13tWsgGSx87Of2o6NV7wNVwyx6o1/X2ur3XDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS8ZvJdSVqcqJG5JmEhwWraFolHd2/OKcrNFCnyihoZTNbCtCApPpi1EvWQ4GlDhG
	 0qYmVOSWCIfBmRBoC7xmkVKG8a7g7aXjdDZMRRUnWgvvZv56kTX9h2dmvr4Rjp6Fci
	 kGZiqF89fwv6XKoDKMXa4dAkdq7vQaqlqsCtxHj0=
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
Subject: [PATCH RESEND v1 5/5] selftests/mm: retry migration failures for the full runtime
Date: Wed, 22 Jul 2026 10:11:39 +0100
Message-ID: <20260722091219.61504-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722091219.61504-1-usama.anjum@arm.com>
References: <20260722091219.61504-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C291B14000A
X-Stat-Signature: umgyknkpwpewrxx1cywuq7bn9apadn1r
X-Rspam-User: 
X-HE-Tag: 1784711564-710458
X-HE-Meta: U2FsdGVkX1+CelH79gM5yZqUPWqDH9t4otxJ+MLWSrzKRHf+YX/vQezkGx4XjkCHBtwa7oyJMwS9jzmYGuTl0uy/qNtQBJjD7WKp6a1C133iXnhfOLCaZsRp8sqabO/huawUCCuyZhmKKmB4XkDINvdEhB2i7Ldr7S10NQU7eiOXYf4nxrskiChYp8nHlTUwWBP+oivD63vI6BX3J3J56+M8C6VIbm7LdV0PMVFXssHPxH6cvlHxqyWU4QhFeHv5hhri17vSRKqxI+B5lyDC/YMeeTUALhJ/Lms6tI5ENw+l2w4WTpgTS19ShaSTdNwUEjp4PKoDsJ4tlEAGqb1FGChCc9M4AN0Lz8Ql0204WhtPOuqoSgT1vl7ygpOrOTlt64csbzxPvTWEEfhai7+5d1OaRNYhw+Z/XXexLXEXSS/qsorhEDNE9SbulmMzoWX2YPr5XtvVMX4SFBe+hHIGXGpw8QFb/9k9QUL4JRU1fmNBryeidPcoFaG9p/gOM4EuWSP0pTEwS19JmGKQq8HS1D6qYr6bx2ti28pv9i1fjYqGIMHVnqjUbme+oEZd/CEyrfw6J4oNBkVzbHmXOwp2xUMHet/wZp0Vt3LaSch9K8jI1UzHNHrvcr5DLsQJejIpZ+VQO8caC3pQsZNBDGCAWoJCgKY2gFK3kAZVhmmpHut6TODUaFk9hN0GZS3xiIxc080unhkCRb6wX+m8aKmWDAot7Kl2+fcYuZ3NIzrFORG5ONmifk8GYddz0ebH2xOM6ED++gV9rfE7eibK2eNeymOtDW0LUez3V5ivO3bakSgNwQ35dUp7ehtAZRZrkNduDBQghqGWqNFi8OyhHdIFF+J8evHY9ByktOy9YU/rbtPJ8YvJZx0wtD4CJDcpJQGh7Ffmf+hwiNIEf/AT3vl5Pi5TycEX4Yv2KG/EHM9t6lNY+MIoli0NJcdxuNE/M1V78/Nr9GCVIUdbUpmtb/3
 yrgeqtk+
 zbzt1G+8IQIvq+AC+HDafzwtlyJmBRwrTkgYaA63yq66K6jXzvq6oVtUj/eE03NwwUZWc8dyL5KKeo1QirSR3COLug99zhvxSoECm5X1cP0z3nR3CXUzpkLacqvbADia/aNuH2qRLlLUvsOvYVFcZw6oQEy5bWnrTFy+yO0kdoRIxbF/7AX771QDTTOqfcQzhngDMf1gYlkpWCb4VvtQsGwAg3R/76JN0x+ppDL+LJK5DXF3Bni1YTxaBV/90C+oXE0but1PITSGgDrd2pne6gbiaGRGglShkXAbhIYbOhET4KBBCsUiX92Gw/2wEnczk0nPY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages() migration is best effort and may temporarily leave a page
unmigrated when another task faults on the folio during unmapping.  The
migration test currently tolerates 100 consecutive partial failures,
but a busy machine can exhaust those retries in a fraction of a second
and fail long before the intended 20-second runtime expires.

This is especially visible in the shared-anon cases, where every worker
process continuously accesses the same mapping.  The retry count then
measures syscall rate rather than whether the test can exercise a
successful migration entry.

Retry positive move_pages() results for the full runtime and record the
per-page status.  Pass if at least one migration succeeds, and report the
last status before failing if no migration makes progress.  Continue to
fail immediately for syscall-level errors.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/migration.c | 34 +++++++++++++++++---------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 29f7492453d43..19b4cef65f345 100644
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
@@ -110,7 +109,8 @@ int migrate(uint64_t *ptr, int n1, int n2)
 	int ret, tmp;
 	int status = 0;
 	struct timespec ts1, ts2;
-	int failures = 0;
+	int last_status = 0;
+	unsigned long successes = 0;
 
 	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
 		return -1;
@@ -119,23 +119,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
 		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
 			return -1;
 
-		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
-			return 0;
+		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
+			if (successes)
+				return 0;
 
+			if (last_status < 0)
+				printf("No page migration succeeded: %s (%d)\n",
+				       strerror(-last_status), last_status);
+			else
+				printf("No page migration succeeded: status %d\n",
+				       last_status);
+			return -2;
+		}
+
+		status = 0;
 		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
 				MPOL_MF_MOVE_ALL);
 		if (ret) {
 			if (ret > 0) {
-				/* Migration is best effort; try again */
-				if (++failures < MAX_RETRIES)
-					continue;
-				printf("Didn't migrate %d pages\n", ret);
-			}
-			else
+				/* Migration is best effort; try again. */
+				last_status = status;
+				continue;
+			} else {
 				perror("Couldn't migrate pages");
+			}
 			return -2;
 		}
-		failures = 0;
+		successes++;
 		tmp = n2;
 		n2 = n1;
 		n1 = tmp;
-- 
2.47.3



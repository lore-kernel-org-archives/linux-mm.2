Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26CACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161D06B00C9; Mon, 11 May 2026 12:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1132B6B00CC; Mon, 11 May 2026 12:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FAC6B00CD; Mon, 11 May 2026 12:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA20A6B00C9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B396E1201E0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:44 +0000 (UTC)
X-FDA: 84755675088.25.71D4B68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F27701A000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM3QtTKL;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDf0X3gu9rKojOdZlXWT5MA4fQTeptO/uAAeEoB096Y=;
	b=n3pKZRQn4zkosDu+SULApDan74Zphs/G07kAAEoD2GeaG/eyISogYjQf5Eeb9VZFs6DwHb
	N8wgDc6dHPri30PvBskKymS3iIz1KPZbHlKP/hJWKE9VxQjkfj3flHTweUIaezsLa8mBnE
	60/i80EREgp+aFUXIE04U+QK929gPdw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM3QtTKL;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516983; a=rsa-sha256;
	cv=none;
	b=Lg5T8L/RYIeXYGBW+uH52EyZmJL3RahR5YUvrDZfwqQWTWNFVtv3p2TPz+QxT8c7qPq0Do
	UIWlxNe4XytkVqzlUgv6/5ky5XMYzqDlNsNvz5HdJfTm7Gb373DYR+7CPam1Gd/h9EG4Q5
	4bTccdcON/G3Uu097D4RlVuGfONZTM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 283D54419C;
	Mon, 11 May 2026 16:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08875C2BCC9;
	Mon, 11 May 2026 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516982;
	bh=rph4nxSryfkWnl25ZALQ4Av6OLe7e7b5Lw2KQwxCErE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM3QtTKLNdLQjWTa747/XP0l18IEW6Dj2zsf6sQvv8zA37bmYae/LdLeM6wDouZj5
	 C0HqqKetJ66Kb4eqPtD2feOeXl6oxx6otbJmTysXJ9V/gatQTPN/nXwlOfK/I5VSpR
	 xZT/ovkyEvtkfCNzGSUWa9RuJP63/LhO/94dHzgSPxjUwpaMAhNvNpVIDWijXf7fl0
	 7kK7TgD1UMSZVjH8pOMfPVwv467F2LkXJ4qsBW+jbnYziijJvavOOBerH7a1p4Pkc4
	 r0vNaN9eabymyUOGkS90/mTpcTKmC9geB8MkfWOoHrnV/w+3FK9zE+GpePSVjpepcp
	 UAYMLlT0ND6Pg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 08/55] selftests/mm: hugetlb-shm: use kselftest framework
Date: Mon, 11 May 2026 19:27:52 +0300
Message-ID: <20260511162840.375890-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpimw3an8ajsfuprwrugama7aj8sc8n6
X-Rspamd-Queue-Id: F27701A000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778516982-692905
X-HE-Meta: U2FsdGVkX18jERf1q22Dq/j8NUw2S5Q4qYRdRGhzLPEjz6n2Qr5wOwOJx/5ZGXn8iFK8q+wW66ElDbKInuS2qdM9fT7j+FKarLToziVl7x4NdpCZ51N/lAUP99tXczY70TXuz8sEN6+EmIzvgKWF0ISyI/QYpziGJL2k0ReA6Z/ygb++mdTiFEIfae1NBZo3r6TWr+ALryCarVlplbGqXefco5jAS8NkprBNkT9DSDkUSgnRm6QFG3J3uizoZcXNflBXSCaN04w1quuuxnBQwmRzGjsopmaL6WRkiCAJXYiZv+xGixZU8Suc97UIC1t2SssRFLOM9/PBZ41SscEPKUCMt99hnEmlwOlQNNs06N/D9GPLYE0F96cW9l2oaTl4oLl+EsrIbsza+ReZDEnImFfk6a0taism33wQwr8aVWxbAZLALwF4/p0Vvn8D4RpENhNFM30hI8f55Y1vnAJ3NZSndSob0BjJ6hNFMQytbY4LWstYUytQoAKzJeJlhO6A0849GeNa7/D/X7oeXIMb5/oarJBKAKLGGbtGeWP/gaBuiAtDsk6gBcJwOyVJjYKidEXSWSHTjk6AK3Jsx6bf+8HxyvJ5WC1yQw5+3FP9jij3QV4t34vA2S29+Ewc5FO9nuCxfqs33+nvCYfXfzH95i3/dQsB5Y7Tj/ysivE1VZ91GuicN1zhmHqYV+vf/5aSXdopE+aCkEpJtiZWBjFSvwd9C2lRG9cv9OPtsf23wGP2aFOjdDQ9Dil8oBQaWGyqLOumjAEey6fLFvfq0tjOCpGBf67WKhyPfbZ2qnqEfhFBpaZiiOEiZlKQQeHJq0VJrmWpcZfLZ57aKHOsb+l+8Uo/ItqnXxZwC712Z16g940sGF4scejEEgC8xsxEi617hvStQ6vosWJ9CPoyVH7bTYcL4yxVAFMHF9nOjwcVORG1FKlJ/cNsbDHKUGODWxyzgfP08blO7Th7enozu7g
 Ah4LWI+5
 j0aGrWbb88K6WXZq/K5Inmnfpy8UZk4ggodBru7rwGwJJez31f7ITh9IqbQoyLzJ3q6anXyqDqvNx/dZjCi2+d/aTYxLtD+4+o50avrP8BZoplaUal4aJSi235xpDdeMDyFKQDFL6S8H17VXYC27UO/5xcE8PrC627TDn5aMzATGCEBd8bJOgBI3Vd/Cmxu+tMgPn3mlAF2rp+++yvUEOOiU6QPKVOZqotudRCDP7+zKN8cpXB5C66bArsQ2yJ39veB+L8MGGZ/wBS31HjtElqCpLNdzrMhPBcv7yRIqhqjul9PkD0uMqEn0hml/3M5gmg2AYrfvt8psVyZQXNAvRD67Ktg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-shm test to use kselftest framework for reporting and
tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 47 +++++++++++-------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index de8f5d523084..c2c7aee85b96 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -28,9 +28,9 @@
 #include <sys/shm.h>
 #include <sys/mman.h>
 
-#define LENGTH (256UL*1024*1024)
+#include "vm_util.h"
 
-#define dprintf(x)  printf(x)
+#define LENGTH (256UL*1024*1024)
 
 int main(void)
 {
@@ -38,44 +38,41 @@ int main(void)
 	unsigned long i;
 	char *shmaddr;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
-	if (shmid < 0) {
-		perror("shmget");
-		exit(1);
-	}
-	printf("shmid: 0x%x\n", shmid);
+	if (shmid < 0)
+		ksft_exit_fail_perror("shmget");
+
+	ksft_print_msg("shmid: 0x%x\n", shmid);
 
 	shmaddr = shmat(shmid, NULL, 0);
 	if (shmaddr == (char *)-1) {
-		perror("Shared memory attach failure");
+		ksft_perror("Shared memory attach failure");
 		shmctl(shmid, IPC_RMID, NULL);
-		exit(2);
+		ksft_exit_fail();
 	}
-	printf("shmaddr: %p\n", shmaddr);
+	ksft_print_msg("shmaddr: %p\n", shmaddr);
 
-	dprintf("Starting the writes:\n");
-	for (i = 0; i < LENGTH; i++) {
+	ksft_print_msg("Starting the writes:\n");
+	for (i = 0; i < LENGTH; i++)
 		shmaddr[i] = (char)(i);
-		if (!(i % (1024 * 1024)))
-			dprintf(".");
-	}
-	dprintf("\n");
 
-	dprintf("Starting the Check...");
+	ksft_print_msg("Starting the Check...");
 	for (i = 0; i < LENGTH; i++)
-		if (shmaddr[i] != (char)i) {
-			printf("\nIndex %lu mismatched\n", i);
-			exit(3);
-		}
-	dprintf("Done.\n");
+		if (shmaddr[i] != (char)i)
+			ksft_exit_fail_msg("Data mismatch at index %lu\n", i);
+	ksft_print_msg("Done.\n");
 
 	if (shmdt((const void *)shmaddr) != 0) {
-		perror("Detach failure");
+		ksft_perror("Detach failure");
 		shmctl(shmid, IPC_RMID, NULL);
-		exit(4);
+		ksft_exit_fail();
 	}
 
 	shmctl(shmid, IPC_RMID, NULL);
 
-	return 0;
+	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
+	ksft_finished();
 }
-- 
2.53.0



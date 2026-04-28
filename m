Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADACDFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201356B00A2; Tue, 28 Apr 2026 16:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B13D6B00A4; Tue, 28 Apr 2026 16:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8306B00A5; Tue, 28 Apr 2026 16:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE1256B00A2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86624140403
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:46 +0000 (UTC)
X-FDA: 84709140852.23.ED5F8B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CDD1280006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwWAMGYD;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEZdkzLZL3vueHy0++UssNjCusJ5F53FLGhcSfBSdYI=;
	b=A2g9QS8TXrP2ZpFSPh05f5OPHm/GWiOga8Z3g6eHW8bI7qUNhWCZ0ZITJ4C5WZs7g6xker
	Hzpe8mbEp82p2+trobHsDjm7yPtYtvk9qSuYphuDH9ZN0Vg/Hk6QH8I9qCfnPu1UY87IhF
	9Ew6Klpder4JHnOtxKJcmcecJMND5Ag=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwWAMGYD;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409025; a=rsa-sha256;
	cv=none;
	b=q+T8wfhNmCPLDWqCI7aSi68uLNt1PmgWaInqGj1jiOdytJ9cIFDMKklrgdxsKNbVONZHk8
	eOiiQwqc0vXR76HYMFTHjJHi4QNlcoAxy/aYC184am4u8B/V2+fpMzZStUxCPeWKfO/4cp
	0MGPwUwIebLitJY9xVGBFo4TzOHFO/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8DEF43FE5;
	Tue, 28 Apr 2026 20:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB26C2BCAF;
	Tue, 28 Apr 2026 20:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409023;
	bh=dLU/bCwt/eyA3PPvWB4ap77KznBqGFR0SnU6xHYGFcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwWAMGYDBm1/30LXf/9ytrjyyByqvvFyPg5pEzATYztnQDEwJ9Zw3n0dj9e1frT4Y
	 PXNluZ5vLoTN5VWyN9Ou5WDvkwCsY7/jaLg2GJVZf/9e03WI5umRW00q5YZ9gXs1wh
	 eC3boZrlA2bezEuyOsRjLh4VuMeAhsm9RGnzbMAEGegMZ5s86t4+egl2etx4Tmdt4o
	 eSFiMrMAVRmJhEDjIv1I3yK5LR0DxJ4qvdQ81ZNPZ7Uxg0xApN8eEa0MN09FENMHn5
	 5v7WZ/XTutw2g2y4LDlGtWY2WeIYLmIe3tRMYciuthDi0wX2SMowhWrnI61sYaJdIA
	 MUSUOGb9ULIsA==
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
Subject: [PATCH v3 08/54] selftests/mm: hugetlb-shm: use kselftest framework
Date: Tue, 28 Apr 2026 23:41:54 +0300
Message-ID: <20260428204240.1924129-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDD1280006
X-Rspam-User: 
X-Stat-Signature: zbf95g38zpaqruerqwx6jbqquhram6pu
X-HE-Tag: 1777409024-597912
X-HE-Meta: U2FsdGVkX18giucc3kNFZHlJU/RLyw3UrYgGbsErzzQMHXpaIK5uelKx7kZ+/Kpma/SGIe5bv7Q8ChOcwxzMvaEOCMZ9MGy4nbW4jsUhwEWG/fqbWp9wNHZIScDZinqnqEf5CWZ86d/JgKS6or1lQRhkDsa6Vw5HgDd8unmJ87OSR8RRmk+ABEw1Fcpszzn3zXMYzPlBm9Ee+Fc+b9Gp0YaXiQE69YNBRXOBMJW8aayQSmTmNgQHcYOvkshEIvWyTy2WtM1RVj4SnHhaTLdNP6i93eE/E6WoJMnE4ZN7yDz9qQY3V6AoIgLVqJGbnW+Ngb82I0aZU7JeQ9fN9CM+A/HYwv+8MPyurcWE6V0i5F9DrfZN55tbkzo2TfzSGXop4M0T3VoT/3TAcCzn1EgHpdMChnoJmkLeWv48ItQ+l9XqExJ1oWCG/AiIdxUf1bf6Jjm3kqx5DV4ZGvjuVNn6YnXRuu/yPDYNRqtKtqz9eUKZ4TN5Cfke0mt1IwWKcc/ahIDH7M9YkmRO/RhCYhyXJ6lBEbxtHa66JxrCV+nq8bS9I1sXbjVRgZxhJXjw7mnFHdpqBb1fohDW5xzRzsgNJkNW9AeznpKunGTqjspa/vt7wHsiAvRgViJEAzXnOKJj6pjcbeluHOHhwJ+tmOmGtESmvSqwpL8e8/cYhgZY/9lHQTQ4CByitjMw9Cuf0yFNSut6XsQwtC9IIly0bIlfwq1mDj8U8IEFG/Hw3nMtRCCgLiMC946TZ7E/nwMz+VKk6+/KByVZEXiO5Zjv8KP3oNkl7WoovlfvLQDM849bwmDFzhjbPrabV8DwAlcYmSLfV1s255Pdj4OHgbCP4+gt/tIoBrUVoEIFGPLpkG6VLLuc0P+ycNDc9OVx5vBlnIz67NfFmPYY9kZt77cCuytt4C9/AljpxNJkLX3zYgssPcqmc+kBLKgbpvJrsJX0TWhf5Tw12fzdSauBykDgGMM
 NjlZ/MHt
 RQu/871fMmPTcdW++bgZC9DMV8yQULME5NpqwxZ08zyLOm80LdCzN4JGdyLEO5ajukqv1Achmr53jLMRt52eoKpuL06bClWHvezKgBie8J+mRxAP33WVlCrf/T/7a9pNXF7hnOPxNMoB5PYVYSHBL9J4ViQmkqznNiePOByezykwlY2yjO7vnnA2hQVtvuD9lnsNgVEi6J5iFXvZ5/0KAuwKadu42nwC7lQ6JX7HKx8QjcDSaSAxbVCYJvTHQR9vy5fHsPaFBuGYreIIw+ewko+7h+MmPCZekeVwHh5PH5mskxjNO2S8G5xOT+ZDOJQdl3B3o
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 45 ++++++++++++------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index de8f5d523084..0f70b1a50b6b 100644
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
@@ -38,44 +38,43 @@ int main(void)
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
 		if (shmaddr[i] != (char)i) {
-			printf("\nIndex %lu mismatched\n", i);
-			exit(3);
+			shmctl(shmid, IPC_RMID, NULL);
+			ksft_exit_fail_msg("Data mismatch at index %lu\n", i);
 		}
-	dprintf("Done.\n");
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



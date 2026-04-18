Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CE2F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8286B0206; Sat, 18 Apr 2026 06:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768BA6B0208; Sat, 18 Apr 2026 06:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657BB6B0209; Sat, 18 Apr 2026 06:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 521606B0206
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A3B31A047D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:34 +0000 (UTC)
X-FDA: 84671373108.07.B022408
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6EF78100002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EGtZcvZE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WQNCtzrbaImTRj3mjeza3z4RHKYl4S8ojqcLhxjoUQ=;
	b=rTAqCqVYDsXjmcmsy35DK1npAqA9zJMu+af4j+IRhEuNF9SM8DzKmmg5qmvALLEIjIV8l2
	xmp1E4SMIYSbnOoKal2HnhdSMw2d4Lg9d7PK5zWiavhNBpw9Twavblp7AxRGM5l7S6Fz70
	7R2d5iBuG/3Wvld+EWO2NxaOOoxfDSc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EGtZcvZE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509792; a=rsa-sha256;
	cv=none;
	b=Pa5z6mKqynOrU0bzJE4SO2F4uApEElEwF7k89x0fMlTsmOnnQUuhMUVBg4DOVQItXqeoGY
	WYu6UvCADzqYxWSoOEQ0U6aUd1FoVYhpvuUqnyCygSQWAwNGAx4YKCzOW/gcow3ky/cxOz
	WJtqgwnhqiJ30FUOT5nv3lqlJ5Vu9Pw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9723641793;
	Sat, 18 Apr 2026 10:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED55C19424;
	Sat, 18 Apr 2026 10:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509791;
	bh=EfJV2xcGp04mBvc5WgtH1On49C+BSbjJWxmNeMqdj3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGtZcvZERhxnMM4EOTcB9Rne1JTK24M3mA5uA4S/W6kdlzJIWKuk5/PGQT58rPZJ3
	 bqfKIiq2x9sa0xl23gr/9mB1epzbjV3RW0Nsswss3s2alfT7JQjRjgx404XMBQTvOu
	 wsLz3kBFH4g6Uklis3FxyDUudZCmZLInYU+y90xs35laZgg/oNq6ST6H1vl0WU+f8d
	 zktwNSBHb6AEr8LqLAoZiovOChAzaNWLly7+90yPiECuqWgGM5Pz0tPlMPXRAlssvC
	 smgbbU5QTURjfdiPV3oRsg1eBPmipzgRhn7UxIHmcnMYkxpYy6vRu0JJv2O+QdPnu2
	 fPMWsU1AUBocw==
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
Subject: [PATCH v2 07/53] selftests/mm: hugetlb-shm: use kselftest framework
Date: Sat, 18 Apr 2026 13:54:52 +0300
Message-ID: <20260418105539.1261536-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EF78100002
X-Stat-Signature: cg8yyiq5amr51bx83qd473y3eim16sa3
X-Rspam-User: 
X-HE-Tag: 1776509792-424410
X-HE-Meta: U2FsdGVkX19bQtZL42HWHIhUoE1VfntSlPQ32YcQ2nFEM5dAg6aAm6IVbJgyHE3ghNOEV6b5uYI33fbyHLd8kWukVimBSD4cqyUB+S7hG2Un39oG4tiLr56F02aXK4dfpI7zckgqWsoFFlaUEFS/IZGa/hGSSBeyLm0nACd27ECSTY1EXUEdPnvUJ2RZ/4DbqzdXEetPSPT7ADU9eEE/FVSScLbUiodLvBinwAMDyBKaHoPjL+AifwX/6pf9ImwQMT8jsllPJIFzl7K+gSwT4ChoN+hGZrbWNKRPu4JFehDkkOl4UO0xpYSsD88kK6V9JCs4yTQxOaZyU0InExN7X5ubd8e4QJ9q3deJBmklNpby6dgjsFQWdkHPYpMa+HX7gzKSVhEOwEEheYyZ/xGEX3U6XvSSi/JcQo76Q09j4elNF8xkq7sBsUhOhgS7iQR4r8h4ZFU/esz8TlA7oTbyZ+bk1Z5znT5yg51RSfzugAKXDJLCV5mBMixG/Dtr2JjccxFgxCGUasKlvpueJO+eI7H4xgU3EM672N/sEyPqLIrOOQ/TAgBH2NZTqp5w3A5gdvjkbiRRJbgVwoxQyCimpW2A9srbnGyWtZWN/qrST9zBvHLDZENRKfFABIPaLYtBj7gC47bsrhqnP/n9mCHyXSkC3TGirCRqvcjzxm6Or3+2Vixd4on32Fd3L1filhBwxX0T2h07M2uRqzpOPgPFqFkN5V8WuaD5fxvGqZ/R6zS+QLG0qWWgJAaOhude/UB0zmLEJi0OweHBTqP0A3BcE1ebvRYOyzV2WcaaC7X3jcpuAh7xb0Rv5SBZfP8NODQVqd42NI/HtENRcS7TDEOjcOJEq9OOoFHtEoK611vCCyDZYB0VH1XjidDqEK+njdya3HXdKtLtBQkBtROJ8RFi8TMNX+zbvtVacPWf9s3GYrDjgSdnjYonmhjnFfIWOT0hNyih9mXX3/Mk0JkR2X2
 b6eSur/r
 S4pgetqlyiSqC+zPOpbYJyUSxTTBrP6gCBmCpAX6EYU3r8MOqrkiS+U6X7g7PX7En9OTXuPZrHkrwAlYSotYEVblJ3HEXaNNSbwfRdSCdZl8ZKh9sTKxsWuQDlyJ8W4dH47vCYnekJDBKdFvS7DdzeYKzDyUWXV5gqUmh5FiVzfCiTgUy9mL7+lddlufo01rQQnSpHPPW+quLuRwRhhyzEDahFsnX2nDWFzLOjI+E8GULXUl8dY3fecad0L0nf8V+oFZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-shm test to use kselftest framework for reporting and
tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 46 ++++++++++++------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index de8f5d523084..10e4baa091f2 100644
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
@@ -38,44 +38,44 @@ int main(void)
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
+			ksft_print_msg("Index %lu mismatched\n", i);
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



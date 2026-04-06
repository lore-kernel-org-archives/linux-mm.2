Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE8EF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC5E6B009F; Mon,  6 Apr 2026 10:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06AE06B009E; Mon,  6 Apr 2026 10:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3546B009F; Mon,  6 Apr 2026 10:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D94FB6B009D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96532140472
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:29 +0000 (UTC)
X-FDA: 84628336338.16.61DE86D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4D9318000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPPVCPWA;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5nysPBV8vL7AsvWzcRQgSFCRHFtWdLAEQK2uvl9+2I=;
	b=0nAJjjU3sUiuxGBx+3XYn5l3XCYXaQ0pvnwLOoEvO+9Mabc0d8CXcUFZwk809UE1n5H+uo
	31fAF7kokB6KXNTJFadgPpX9Ki2h90SdkufFCcgyvQsU95jW2oj1s/eNtCSpyAphcqLYnz
	2ux/P5NVA3/cNdCeRFa2uq0taHj9YdQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPPVCPWA;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485108; a=rsa-sha256;
	cv=none;
	b=i2poAQPtoOomiu9Naaj24DuCzRkV3wyMZPFHpCMJkWEXHhxVPFSe3waPAeZKMldk5cbERf
	x2nZ+OQQghSjjkwsfhCZg8s26zbJ9/vanvJ5RtNDw+E4tC8nTHf7rqzBZBsmbOuprDN/oR
	KfZ7MV+WTXJTBt4HRgzg+uqkl4gVV20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D187442E28;
	Mon,  6 Apr 2026 14:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E420C2BCB0;
	Mon,  6 Apr 2026 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485106;
	bh=0Pimjk9A/zLvbB52+YrtlDUIAYwfREb2pbqcH7aoQw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPPVCPWAiyqEEeDI15bL64yH/NoXAMiHO7Md1KNN43yMn5XjXFvJTt2K197GAw0xc
	 V2BcMHWnp+OPti9CMa/wgSZRo4YQs8m/GCIR47TfLsHAd6HbSveKY2ISb6F+gmrNjb
	 oFH0RItlv79gAAqIJQfdu+3aRZo6mYfnTMFmllqQQ4vgVXesl2/dwUJ1GzU792K/dZ
	 agje6ECvSjpxmZGLgAPVF4bW2AC1hKZpPM52JjRaY5GtPBB0inl2LvxxM0mTJFpEk0
	 EWHsrhnDKSqwnIT1jnE/A293WpE5CdUYN3pE2ZM/s3f4YwRgzUf04JHou5go7nWcgG
	 v5n6l8KnYatAQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/53] selftests/mm: hugetlb-shm: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:49 +0300
Message-ID: <20260406141735.2179309-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1dh533sxie4cph3rghsupq9jso48opb4
X-Rspamd-Queue-Id: D4D9318000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485107-571565
X-HE-Meta: U2FsdGVkX19IEB4Bkh145m5EpxTwCIkYlOfR+xZBnCzK+Fj+cFch4VerCQLJllTqNLCD9nt8eSli6RuzNpDNQ5uWsu/qROAzNlWeGMLuFEBjLR4NPLWruQ66W/ioTcp+a6HXbXxv0Juk2E+UeALaQ022wcIDydbwvhygPLDppLHScwzp0BcQ1t8BcMNpuR3fvgsloiGOCCb/YY6S/f4RCm2UCkk26zLllbd+SggeoXNHDqkU7nD9B7RmiVyw6Sdj+93ZtCAqIv42QcIqtz0Em3uFsurcbC4UjCe1sHQmB/k3Fhk4dA0NxQASBcAPoWhkmJrXTy8/SHqppXBdRpDxAvdp24wijuXFNYI2kvK2Q3kJmszgxypBodymYB5iliCgi+wGOF+d4JcBv4q4eK2yhBjsv7cTBdD1uYPZF69geklgCgiEA43TqW2Wqc9hUtwwJIIqyDm9YT3Af/XldPD1wx3Uft2dHBXGQrEfDRKfWsVgdQjp72A6LZe87+tq4VLYbEqVfqCNQxDpaCN0HUQeWIVwLqjVq88gfHP5sp6Bb6t10wA6oFBPedsm5xc9vyWbt3OIlhb6bkztuWb3Az9StowRb6LVeT6nHC8R+vKQkR63jW2WDmxYoOos7GnyD/7Eofz8AIp8K5fOTNrh4/IYfRhiOO6QL+Oxi1i1Pl3DxEoFDavdVi8GiyVpPJAbcIHH6LjQUsaNN4m5Qh2n0pCF5Lk85D6YTR3hHxEHBAg1oNTy0nWZTmg29pBijTn+j0NWWZhCHw5s8qv54aQ3PdaYIxug7/VJi/7QQ2qEk0M+4KdFtoHBIOagzxDVMAhQ0567QAOLRqiaAFHMIwIyczQnv6x9wqO2+So4Ka1jinLWTg5IUxgIFvD8qyvAYapCpw+Zsd5CHNoAFWHYAEH/FBzOnJXRSbD6WfhP8Io/pdQw+HhnqKx41H5RkYTQiAF/lR8/L0z1VhNpBbdBME7JuNe
 EI1/Aaif
 4Gwz0elNE28UtpIaWBgCd4vQtuDcGo4S1IBnMOYOXcS6BA3Y6tW5/rdzCBQmdAf0wxsEPtyF0eid9muEFfS+Exl631qj/8wrL5DU0GtDppbZZsK5ZSuml6iTLVhGxFGNNTK42AWKotvt/W8HkxfphIqe7XUUl+bFKeZcaF+43KYBUPRXTx776w+mj862OYr0ljCtDBZzjHd1Z1vYyGsMgBXYRK3/u42ZipHFh/5cKU3VGcOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-shm test to use kselftest framework for reporting and
tracking successful and failing runs.

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



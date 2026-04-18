Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D65DF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21A46B020C; Sat, 18 Apr 2026 06:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1E86B020E; Sat, 18 Apr 2026 06:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1986B020F; Sat, 18 Apr 2026 06:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B87506B020C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D6F41A0474
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:52 +0000 (UTC)
X-FDA: 84671373864.16.BB93991
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A32E818000A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NAQvloRX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/D83BcoXHYq18EoAAn29lhJ59t7oTfCwcYKI4oYHfc=;
	b=zTYE0XNoSubEfbMwbeud/LdWrWOarsqQxLA4M9IygZ7+4z23F9AP8OjKoeQppWk9A0lT5V
	26c2Cfh2NGdGazIWVkBx+C82MQnvLEW1giLA7LK1a9uYfXHk+CHloj+PiUbjFv3TdoBqwi
	zBP3BRO7+GWae4X1PHwxLWxSkh6zsqE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NAQvloRX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509810; a=rsa-sha256;
	cv=none;
	b=2ey/8wSSOIgH0M1c+qX+Ar9zpBJ/QK53b7PeiqUi4B/rsSJUo3tXUK4uomur0I6dL8azb4
	El4t5BZZO+0kfnZlPp+mgnoEfih8ynurMmriR1XhR3pvhBlHnD5PRZGGMinFbT8WqgJm/h
	oTPMBdIlK/mb8n9i1bpLPyNjXJzOVNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A3F60138;
	Sat, 18 Apr 2026 10:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432E7C19424;
	Sat, 18 Apr 2026 10:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509809;
	bh=sFWBiamU2q7m5/n7ztcBEvw8CqsCL86YPiSGuyhoTb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAQvloRX0/uXa6RMA9QnDw3IMSL8TO6Abaow3+hJzUQ0wuS/8WzERNsHq+nMLyMcz
	 G89Ww2hLRA/9l1w/LK8EigH/mD9Vc7jWSHG/fSwwdsgnjRn03xOib/ggyqHEJwpz+8
	 j5qW0hTXkRRbm1k2KoUrXkb8Rn8pYWXsxi7a/IyvCuDdvqeB+Tzg9oH8E6phhgWAhl
	 CzLlW2AWi3zfQ6cuWjIkCIWfH9AqXlQLarG841R1T1pV5871XGOeASRyojqfnII30K
	 fyYePZ81i8NC6V9tUC6ec8JeZW20+TIIsKf16FHjfOIX+hReM1CKUs53iFpjB+7Sjb
	 g2/YCGjE0lZKQ==
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
Subject: [PATCH v2 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest framework
Date: Sat, 18 Apr 2026 13:54:55 +0300
Message-ID: <20260418105539.1261536-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pjpirg71ab366mfbmn5hp8nho6yatr95
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A32E818000A
X-HE-Tag: 1776509810-127453
X-HE-Meta: U2FsdGVkX19aBjRXaotrvTpFCqoH4EnQ88oIcqz6iFqxjiVHREy8KVK8CA+yhAh0eBI2cqvdP314XdxjIdANtPfbkrtqJz5jFBm2zAoZKN3GnMcxdP3LWRx8DG0fdOXlAlrKOZNG7Y05Y0cz22G2xEE0OjxbxJfdcjfLTGuto/Kh3WsM5oczNRmlXO+VpwZI3lpoSL6jHgm2TdQxRyzKWaDeBoJDDLdtRdNI2bquVKia+fN3/Lr+l0GXk3hDOtJECAe9lh2B4wRH4eAB6muAUsnrWB4fRmXyHIcyYOuyvmoGuUtNAJvPqd0tr4+Q7S5IX6ntBmRoBI8/4oFe/NxWBk/PVxXwRHzFtL+LlxdOmRolYkD49CI2M/fW+WSioxU9tpfEA75fJqn3KAHfRkEtRoptU4pxaxKSrrJMx63ZUkRsy3Lisn9Bf/hy6hLbkhGbJtOFwbizfNdLHluQ86POur/fHlvDc3bVtcX/FtU/zsvifs7bMVRP3hM30ZYG1R15rLeXwY09MZIWxlNyjbVNR4mYrL2MOwBUwpTd0yDqeBFO3U20HzD8fKVBZWu1euRNQ5h+sJNtPe65nuHrCIAnkze/OnNTebEd3c5MMIKgjlQ1G/So2j/A9p3gao9nSzl0EjqGRb4pEb1Nr32dCMja1Y8kFcSYX/agd9fD4gRIcNrs+eRjrm6P1FNkaDUHma6wr51U92H0mEeV0EJIuqvudxkgqGHG3bXpajstMpo+MqMRz4RSi5afKmnPVX4PAPawTt4T4UdPSWaFNIPsPQMAHaeO3y3PqG+7d0Ej4Px3znnH1GlLVANWqNwpiYL+TRonwb9xh+L2NO7r8dTAj5hqeByZfOHeODAB+0zxVWHh7MIkTFEK5j1kb2omN6eNHYHhGkhA5cKEl0jPiKU24wZD1ltYYFSHgb91ecFx3Z0qRn9JM/sr/RAAEwKTp4QaLPD2wpWyjjBM8sMrENvH9WW
 1O2VU8ZU
 lTgWY65jk3l+DWEgfKXT83tE3QKX8tW1NX7w1OBmT2Htx7I+kbVJNQmscuPo7BHyLN2gk2C+WLc+cGdOgcqw9nMpU2nkt4fJjshqkVTIOXoVc7KOOh8GL/4q5Osso63Z4im0JOMdGY6neE20O1Fgpy3EbnmhDF8p3w+mf7/fMRFOW60KA/zl2/H0VZ6gKSYevJV8C028nEKn8w76wKytEXBx6tKaeYczvdZIQvIwjnt60vrfjpz3ubnhvHBfb6lgN+iKPQL6uPGBWbtbjB3ohs29pfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb_madv_vs_map test to use kselftest framework for
reporting and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index efd774b41389..c7105c6d319b 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,7 +25,6 @@
 #include <unistd.h>
 
 #include "vm_util.h"
-#include "kselftest.h"
 
 #define INLOOP_ITER 100
 
@@ -86,12 +85,14 @@ int main(void)
 	 */
 	int max = 10;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	free_hugepages = get_free_hugepages();
 
-	if (free_hugepages != 1) {
+	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
-	}
 
 	mmap_size = default_huge_page_size();
 
@@ -100,10 +101,8 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1) {
-			ksft_test_result_fail("Failed to allocate huge page\n");
-			return KSFT_FAIL;
-		}
+		if ((unsigned long)huge_ptr == -1)
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -115,12 +114,13 @@ int main(void)
 
 		if (ret) {
 			ksft_test_result_fail("Unexpected huge page allocation\n");
-			return KSFT_FAIL;
+			ksft_finished();
 		}
 
 		/* Unmap and restart */
 		munmap(huge_ptr, mmap_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result_pass("No unexpected huge page allocations\n");
+	ksft_finished();
 }
-- 
2.53.0



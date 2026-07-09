Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E6BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968E06B008C; Thu,  9 Jul 2026 04:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941FE6B0095; Thu,  9 Jul 2026 04:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881456B0096; Thu,  9 Jul 2026 04:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 615C86B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:19:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA48AC1FF3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:19:33 +0000 (UTC)
X-FDA: 84968539026.20.17FED22
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id E1CE320007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:19:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783585172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=bmLahueNRCQS5ALRfjCqRDMTD/MSViZu20vDif5g5kw=;
	b=pAG3x7vuCEj3VvSBkS04iZdcX/LB8crKETrkG6AD5flhMVxkUwIeomShHxqg/mee+i+T0y
	EnlYQRHcosI66MPHiND/CHqhg+ir7ZCRoLLE86L/sBs0zJwEJ+kU+iLNB341lL/j3qDjcX
	7Y9H3ENcc32EuJ2T2VlNVOShsP1YHUM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783585172;
	b=3rAwHrYJKqe5WvMvq7acFlwgEuftWQywX1fLe3Vt50ShCHjGzJwrjPUXtlcNr+PYD0KGBT
	iFFbfmBB4QGcdsHdx0YMa4Vf7JeQr7mXmlMYyqGhP5zDVZk75fA76QOPa7PXvJl2ClXMe9
	wckU1uQ/AfS8f3tw0xNNF5wBM1KZZFs=
X-UUID: e3c6cb027b6e11f1aa26b74ffac11d73-20260709
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ed9105ce-fb5e-45c5-9b87-f588755abf5a,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:6feca68f44b6c67670f6e8b212429495,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e3c6cb027b6e11f1aa26b74ffac11d73-20260709
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1982330455; Thu, 09 Jul 2026 16:19:22 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	balbirs@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	SJ Park <sj@kernel.org>
Subject: [PATCH v2] selftests/mm: Fix memleak in migration benchmark
Date: Thu,  9 Jul 2026 16:18:43 +0800
Message-Id: <20260709081843.1451202-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1CE320007
X-Stat-Signature: 3aqq5znkcwag338gwhmmzdupjw8kedqm
X-Rspam-User: 
X-HE-Tag: 1783585170-637539
X-HE-Meta: U2FsdGVkX1/eC5Fei1WwjGcnckzBOt/6slB6M8c1Fe83BGzr2moDEzjxeqS6bl1kdajHsPA96ZXR+i2cBwP9rCPsimo/vIzKXlqV7OeYJW2bugjy9cB72faGmilvWKpgYU143MsUM+L4MwDjVTKLIY1r8eaNKeb7gnUnlIFJ8+FOOoJPL9AO0Ya+rI0Tl9QLU/d1SwF6qONlcCDApuminn6obBUkX+Xmw0UB3Hu0a+KcIy+ZS+DF5jXvNoAYshWAjbfa4Ojktrdlec3UJaD5gL9GCM2Pa0AC6BIVwZcdDo/TVl4LAXmeYxSMH6WmIPp5Wjf1nWkWyI9EKe6T3kxbyj8wSWPy+ZnO/TdIL1pj/DqnHI+Gjm6RrV8sMbSe94S6l6gyDxLTDslzGZtrXW+D2lIsCSn7VNl6XJJpTZd5XhE2S7KmDhUE1gqEGIsJ411x4sWSvF4u+wqJ3bAfo41HHcNS78wM8DEjmbZy26fOEdxRHFrXWHs8uj1dSUsVjBbNRrYVMbfzu8Q44ClisusNRchZJYRAmrIR+4Yw4FfdALJM+Iw/5zmJp9xNY6Dmb/crXSB2UcOcT6xILqJC3pahhvClE4Jw1wmvuE1cdx5+YJ+i85xes4TTILkyDknQvF2qs6x/sFbgL0VN4Nn+lOjiOOX50lyQf3DymyHkMzaS3ol5ZsvJkoy0q4Fv52kd3sWPvdHeuhXSruJiCbQAJYPWDcJ0oykUpvlXVH03Xtigxze/I6Kif+La6piIp52y68jh2OVIop9jFN5Ok9IwoHus4SHtY5N5QEXLaFBe8edth1z8dwY8wpf6w/Ag+hJKDZfgMl/w86FF7/0UhASooIKAa1xmGso+9SKBAuZUS7tFWKCx7FE9X8JAX7r9JuGy6zbaGx3ptKn2yCaSG7K8H2Zi9KzzSit61Qn5HBLzPSNitEwsDTQxgo2zV6LykkOBF6dNxEPXrqJqctw3NIH9Ptl
 kX6G6sj9
 WSqThTs+pBrTdhno/eZuTVnf0oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several early return paths in run_migration_benchmark() skip
hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
label.

Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
---
v2:
 - Set buffer->ptr to NULL on mmap failure to avoid passing MAP_FAILED
   to munmap() in hmm_buffer_free()
 - Drop the redundant "/* Cleanup */" comment
 - Add Fixes tag for the commit that introduced the leak
 - Collect Reviewed-by tags from David Hildenbrand and SJ Park
---
 tools/testing/selftests/mm/hmm-tests.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e4c49699f3f7..402c6f6f5f09 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2828,8 +2828,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (buffer->ptr == MAP_FAILED)
-		return -1;
+	if (buffer->ptr == MAP_FAILED) {
+		buffer->ptr = NULL;
+		ret = -1;
+		goto cleanup;
+	}
 
 	/* Apply THP hint if requested */
 	if (use_thp)
@@ -2838,7 +2841,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
 
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Initialize memory to make sure pages are allocated */
 	ptr = (int *)buffer->ptr;
@@ -2848,11 +2851,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	/* Warmup iteration */
 	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Benchmark iterations */
 	for (i = 0; i < iterations; i++) {
@@ -2861,7 +2864,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		s2d_total += (end - start);
@@ -2871,7 +2874,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		d2s_total += (end - start);
@@ -2885,9 +2888,9 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
 				 (results->dev_to_sys_time / 1000.0);
 
-	/* Cleanup */
+cleanup:
 	hmm_buffer_free(buffer);
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.25.1



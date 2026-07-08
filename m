Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E58C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 10:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39276B0005; Wed,  8 Jul 2026 06:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11786B0088; Wed,  8 Jul 2026 06:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00596B008A; Wed,  8 Jul 2026 06:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93DB46B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:37:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A325A070E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:37:48 +0000 (UTC)
X-FDA: 84965258616.13.A564E69
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9912AC0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:37:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783507064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=L1NfPhIFsNmxAN5aTMrJA7rORpp4TnGjbuvUvUq3OmM=;
	b=SViLJT3VxL0DKsLIllXskfQ0UiR5j/NYnt4LcBF39Xo38sUix/0HGasDhsJJQYcVQqKd5N
	1HTKu2HrLgJPQhJodV2kxldUlLdO3QObG53NTt4KaHC4GGfeYDBKMAGe1NE6w7dQx3lw9t
	Eh2Xkp/LsDTC/bji6qm/wN+N1JaPJfY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783507064;
	b=PyRaYfrOg7FcIgpYLNZz1u0k7i9YtF28TJlTUx8bKoOUmFlq5t7QEuqrSnv9XT4rVvk7VE
	7CXo5RFEAY85n/7J+rxzsC7ins14xuvdF3Fc/Bgva132hkQTexMBi7hUrXwdryja/cv2da
	H+RUPXqR7VxzKH0DKi4XT8eiFEwBsPc=
X-UUID: 06c9273c7ab911f1aa26b74ffac11d73-20260708
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c23825d5-3195-491e-8317-821eaef60e32,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:fe6896bd86603073a49c39b8f3e94cdd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 06c9273c7ab911f1aa26b74ffac11d73-20260708
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 209197117; Wed, 08 Jul 2026 18:37:32 +0800
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
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Fix memleak in migration benchmark
Date: Wed,  8 Jul 2026 18:37:05 +0800
Message-Id: <20260708103705.840679-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mf9rzp54mzpm6g77kfanzry9zpbqtgp1
X-Rspamd-Queue-Id: 9912AC0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783507063-450547
X-HE-Meta: U2FsdGVkX1/LLTRkrggjUDjm2SNp75tL47ip/BH0Macfi9wcO3qC6XUdLs3ALaZ/m/tqOSFnMgmbIlc0Wo2RkNAJM4DkNWZhO8sf/02D6jxIWGRN9Nss1y8L5JLsJgt0x4ZieBoXDtLDtDzHH2/4SgceaFqLWEjHRMTCMuJslvdxeOvW1PhAIna2uSbt+f0i5a36zqtNJ+iTLIbpRHkh36/U8jVVbeyyMGrSk3Kk97p4ZMDaz5s/bOR9S4vBs9U/Z/5sZ1n868+Bi4saZfI8f4spOaw598WhVxNv0rUOFEX5LW/SZHnxIO6eXLxQWDtR72rJ7Z7MfqgRkkkmSIlsVAeWILG45w8EKBCGUtevZy4AahVNkjqYST+VFCFxwG6JG+lj8TOuem68sdPIP9tJBa7IJRsJXuahlL7dwGzfN4YjM14zQaDcbVFwms1TN62EMZL6i7XqMEFPdv04K+G8RJ0kuO5TSxflzMCXopDGgxqqvaAuy3/qbxk7eQhZBysjfO0p3xpYo7168QTJ872lPCMxfdoOAfeIxlskxSJgfr98n2R6lezSmW5iX3kwWiO2TnHkWF21V8B65tUd67UBT3vVDNM94/krJRlkbv9OUy2VuNxuX065C0NAL8CsFq32kEsMSg1RtxTLfgasW6Hv5GPH2tujCmkJLRmnw+wXlMrFhpt1YpXHDRIlBts4M5yo0ryAADHdIZponbwDPTVp+sj3ULxA/BFXLbGhH6NWGXjAWQL+2+xzB7KC346ZTZwJ1Sr/GE5dy8RhHi3omZncc+kz9PF+srKFkts+7uW8CenSeTz4L8cODSv2d6M/VtYaIwdwsN5YzSRfG8bjfIIKGzIeDbGP1oX89hdjAy5LFfEGtcs1B1cM0b92UJSRZqqDA0bRC938mSqzaZ5qNA/MvgYUxShXBonIAJ6DsINGjErumhENHm7dv1fO/Gq6509Mq0Ioue2XJxxVCKDw4aT
 qPbBbuz8
 YIA4F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several early return paths in run_migration_benchmark() skip
hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
label.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/hmm-tests.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e4c49699f3f7..e8046675a0c3 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2828,8 +2828,10 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (buffer->ptr == MAP_FAILED)
-		return -1;
+	if (buffer->ptr == MAP_FAILED) {
+		ret = -1;
+		goto cleanup;
+	}
 
 	/* Apply THP hint if requested */
 	if (use_thp)
@@ -2838,7 +2840,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
 
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Initialize memory to make sure pages are allocated */
 	ptr = (int *)buffer->ptr;
@@ -2848,11 +2850,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
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
@@ -2861,7 +2863,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		s2d_total += (end - start);
@@ -2871,7 +2873,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		d2s_total += (end - start);
@@ -2886,8 +2888,9 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 				 (results->dev_to_sys_time / 1000.0);
 
 	/* Cleanup */
+cleanup:
 	hmm_buffer_free(buffer);
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.25.1



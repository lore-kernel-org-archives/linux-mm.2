Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA074EC1133
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A626B0093; Mon, 23 Feb 2026 20:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688A26B0095; Mon, 23 Feb 2026 20:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D906B0096; Mon, 23 Feb 2026 20:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4590F6B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FA891403E6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:38 +0000 (UTC)
X-FDA: 84477686076.24.54A158C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE10CC000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K4WcqISW;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/n42tr+9IlpOp5hFur4DBL69XJ1P8BtXGTtcSlF0LE=;
	b=BZCoQUnK+4yFMpmt4xqowgSlig+Bzw7FRuP94oQ+6vMD7PnwBOHz5TIaeTDUXdV2Z7NuUD
	0oM5meCoAGj47RBJ05fj0OOS9oFPiLpCIs5RtRjJM8GvNoxMg3jTYk+o64syofIOv+1tx0
	RxOZjs0Us6wLtMauQjJ0SVS94/ebSX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898196; a=rsa-sha256;
	cv=none;
	b=Y9ooGvofQj/xdh+YNOUM4cfE+KfJZc2srrye0w0GpYVZOFvjqm/cpHoTET4R5xVYOMzeMJ
	jMhGpdAXvG9oegMje4KRUTTKM9KKwloLp3W2w1vUiVIlRh57pRMjYO+aTENSqJ3E2Leo1I
	PMa15uEigBYS2vVgwfL87GLbLn6Sc4w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K4WcqISW;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898193; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=l/n42tr+9IlpOp5hFur4DBL69XJ1P8BtXGTtcSlF0LE=;
	b=K4WcqISW1qVJlDyB4fuMzBzEZhg9kSKoUaULhoFo38Dt3FWY+Sa3H+FLfvVotouGeRm9otDJfz5iVg1O821QjtxzVPCXaHatHyXxW3lZoKBsfTvNNAunILBubGHwVDAjXiERmrd9xXeRx3hXY/P0H2IQiidOmTfFgDDUsCXzhnk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzhpS5._1771898189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] arm64: mm: implement the architecture-specific test_and_clear_young_ptes()
Date: Tue, 24 Feb 2026 09:56:08 +0800
Message-ID: <5933ff4d7124cf972bb2474666b4699580fbc334.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9d86ri9b6r4knyq8khc65twtcxo1zix8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE10CC000A
X-HE-Tag: 1771898195-397143
X-HE-Meta: U2FsdGVkX18nIDnMLBq0pGg4ZL/F5l1mtjay/ycdxmLRsgh6wLkApm1sLgJhFUnqPTuby6otKntgMp/XOlzCsdjwQdDz2NJklUkyH9jW0XZpvGJrYAv1Nbr5I4tHrFcfKBkykbkHslnMZ70wHw4yU4E5tDya8gWpu8vJPBKWQd3Dgqfs1Sx7pzNIpuFKwVFtzQJdB1/P+ExLN3q//BLDvZsSG3Kv/Obp0uxb4tLBAztBEhmCISyW7Nk9f7DjVWi69ImRBxJkmaP+zJ1u6Nfo92yrc/LMc0VpA0z5t+JKNUQVjxMMLXowrPaaFHoPiX/FqgTC0fxKWcZev3CfyxefZO9wTI7EdyH64UBUuwxAIEfbEbIlvR1ah2T+lxxO2Jokh4Wx/X2gMfd7fbcMisWnJbi+LsrrkoT/6M11tOlbwu3XliE6FI0GjcIOoJFsU6v4HX/KmCRwBJUxq0iE2mVTh/GvKnCYQ1nmJahmyaMyJ2c+kEtXMk36+ldOXtoyCWN/lW7fbAtCGqXnvyENNe+Og/IR/NGqIhoZsMUG7SeonRsqZnIa41UGTRX+1gqxDjTj5g/0T20Ra2vkFdTwBpVZHllfeg6AmiImc3GYT6sZvOlL7PaDs4X+vyFu6IMAHyEQRnklLX9H7DCAUo1OA94yb1HleAdvl1ji1GN5VDgqywpVoeWW//LY0tRfV4jmusEuK8Nt/on43ZXC/T53MThIrIVux+a+RrTV4Nn00Mvrs9uIKi3xJlaU+88cXbCL6MlhKfflwcuBqkttXETOaY/DaxMSZGZ0ROKn/s7qDfdmPqFHbfYCWiQJru1+7xBh8b7GEmkMiYUC9lK5AxIK+rh9d/Yc+Vpd1aPBkANHzeiaC/rUd76PBfoMlv5b9QZ4G+oRXIYtEAijdJdys1ymHIkoDlJTC+XDwIsbdkD93Wa7+gqnvxAAWRsnRDRGf2IaRdM8Ywtnag3hTDyHfuESAq0
 reGuzHh1
 60Ls8aHXi5KVnXJJkDi5lLc6i+g4yLZoGud9ni/r7f6L7fCjXDyA7lo2ScaBgYg0TNM4PXYPpeIcO/26N4MvD59+PFmkx7WA0z6YZRLvaDrMmkf6qwbzqDv+1kRvKFl33myXO61j4Oexji5lLcSesjfe6eS3mJoEcntS4evT+aDZXFV6QxVM5PMoLLr47kO8GJgBPQVl1//NS3vzRKP3qr6Dw5oCaGHHQ/X1th7PSWwR0blu0Jz3r7hsFTdlf/28n0e5DfoiUQYvzevK92RoaA9X9xBM4jK/orJWFNATCN9GNQwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the Arm64 architecture-specific test_and_clear_young_ptes() to enable
batched checking of young flags, improving performance during large folio
reclamation when MGLRU is enabled.

While we're at it, simplify ptep_test_and_clear_young() by calling
test_and_clear_young_ptes(). Since callers guarantee that PTEs are present
before calling these functions, we can use pte_cont() to check the CONT_PTE
flag instead of pte_valid_cont().

Performance testing:
Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a memory
cgroup, and try to reclaim 8G file-backed folios via the memory.reclaim interface.
I can observe 60%+ performance improvement on my Arm64 32-core server (and about
15% improvement on my X86 machine).

W/o patchset:
real	0m0.470s
user	0m0.000s
sys	0m0.470s

W/ patchset:
real	0m0.180s
user	0m0.001s
sys	0m0.179s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa4b13da6371..ab451d20e4c5 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1812,16 +1812,22 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+#define test_and_clear_young_ptes test_and_clear_young_ptes
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_test_and_clear_young(vma, addr, ptep);
+
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep)
 {
-	pte_t orig_pte = __ptep_get(ptep);
-
-	if (likely(!pte_valid_cont(orig_pte)))
-		return __ptep_test_and_clear_young(vma, addr, ptep);
-
-	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
+	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-- 
2.47.3



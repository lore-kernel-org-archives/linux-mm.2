Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D03FC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057676B00AA; Thu, 26 Feb 2026 06:34:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AD26B00AD; Thu, 26 Feb 2026 06:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70316B00AE; Thu, 26 Feb 2026 06:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0ABD6B00AA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 918031B7B81
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:16 +0000 (UTC)
X-FDA: 84486399312.18.4D6C96E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA39B180006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WE+bzrYN;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0H8ygH+YlO4CNCx03qcK3DVZPCm8qVQiV1k1Y2d+/k=;
	b=gpRn33GdVr566IykVhCSCXfM9TOmym7tY7mXgKDwajVvP41ULxD148Rt5DmE7yVGYDcmPp
	iWqMOD5BMUNNW1dS+/k66FAqFdZKtgPuFrNpAihDqCZ8v4bJ9Hn2v0shOGBlKX+Watm6VZ
	3bYOdNH00eSpzpFHsWA/lqljaexz/ko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105654; a=rsa-sha256;
	cv=none;
	b=lzXkeoCwaVIoMP+xwo7bkmHaD16dqTIMweZ3UTP8iiqDmItzdkVm3RqGyPKrAdMiGWaX5U
	sUxCbAtP64zyZ7gaWksogrenD0Gs7mX/7uoi7kk2SEO+pboC8MgFgaEzi9cz8xOzhDbbI3
	6Ojh9MS9PO64xGbtnL2hZeCu3RCrqTQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WE+bzrYN;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S0H8ygH+YlO4CNCx03qcK3DVZPCm8qVQiV1k1Y2d+/k=;
	b=WE+bzrYNxkX7rkOvVYIotj0P/HNDg7dgr5BIyKjoWK6c/gNQyNgdKm5vkjTkfoZRMJ11uG
	7YnOvlg6mRw5/v+qJxjjYm2FpSYphCBWmhfAjo9Kp1SB7EoIDR3aW2hScwzOCQc+oLE42l
	nXUPqt58pVi3eC52uFA6Yk2oOf9BZZA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 13/21] mm: huge_mm: Make sure all split_huge_pmd calls are checked
Date: Thu, 26 Feb 2026 03:23:42 -0800
Message-ID: <20260226113233.3987674-14-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 3sjff1gq1akwdcjwb64tm8qk8mjqqws7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA39B180006
X-HE-Tag: 1772105653-33294
X-HE-Meta: U2FsdGVkX18lVRRI3bBJA4kQMMcpqiAe24g7UmZ3yAYOQzxYLTIazKwa8eLhmKMpCmveiuiswVxPK5eAz3JWb2PhwvUxAZ4Dcv2hhaZHbjgNIqkbkt6rggo1th3ylMkLQwVwrExALwnPV2/r/iJKPMsAALjb2qE02x3WACmHq2fGmoHjQUe72dSFfDrIwG46E3n61vVuQPwyeMAmTr67eyw6MO34/28VZJ+Y303bsdPOCDB7r8cgz/sqyX/qg9kuHSxvGXqZ63+vG+38x83mYsjpAfB+qDB+vPaoH4ijBWlDzL7u71s10batLyTIyLAXZK3yGlLOrJvhZ4cMi8uoLdsWbGKcEr+t/8u4C6hPSPvWAhltC15BinAsrSKBljws2t4zAHQewC1HGZr1M5dS8vm8ErqUcVOMob15xmzl3Y+KSO9IdyWgNy70eBL/+copndwcOmYb0bPHK0uQy4cCoqtfUpFgCYTQI27dweDb4y1/uU0OSsQvMGlEuTvtJ2E+/X5w2qZrF5L61dmcaGTRqI+hQWPLTQA22JjNFeDKVfkgxsUy2vOX/5qZFhEu5OzWeIsDtDlG8l8+ItV1xHzz/KIDD5LS5bg45clcPMJjrsNGpPBfJAoDBK1yVNKFk+Nr3U7e2ffgkT+Rr21srITd9/+xckowLd8DOwWMYOUxn/hm0faSFySXgF+oEYgoOIo5H127nOJsbwISb7wINdojYP2WsTVKt4ZdPFb3kTiX0WGfMXkoHRUlNALIy9tMNlWAEWvXnOmgwUHC5TyYuH5yoiJKWkFbqFjf4vjyRBss3xk5dzsTd+8LqW7u3Px+3a7fZuIumPVlSPyWfBTR8onEO/HG+zsEfyPTYgz7O0kzgxHTMzdYzBL/fivy2jC6yJeF3FIZajww42f2X8q/wW1MZBO/dJgEQ6QbkZXnhOarSNKLlWf1CRbSmXvot062MGTOes1Gp5aCFgC5En998zd
 nke7Wil3
 f+fXY3MzcF/810o3Q/RBv0rNCkVTw3tv5/bhgxzdfmaxqddcmvU9IAi2fPT/0YKBkTwz/nQ7L+eK37oltv6Rcw1DJYOEnYMKrip+EYiu8LSTF/OcvRaGJsMa1hkbHDI05/uQcexasbGSD2QwbdczaUtGkEljI02eqOwlNY+AujadAxny4fg6lTNpCS3kKTYG9fwcgvgIqGBDqVo8Q9Dhgr4BKJekLZzm+6U4ctXN+eeIe9GDVqJPys4a+kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark __split_huge_pmd(), split_huge_pmd() and split_huge_pmd_address()
with __must_check so the compiler warns if any caller ignores the return
value. Not checking return value and operating on the basis that the pmd
is split could result in a kernel bug. The possibility of an order-0
allocation failing for page table allocation is very low, but it should
be handled correctly.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 207bf7cd95c78..b4c2fd4252097 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -419,7 +419,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped);
 void reparent_deferred_split_queue(struct mem_cgroup *memcg);
 #endif
 
-int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __must_check __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
 /**
@@ -448,7 +448,7 @@ static inline bool pmd_is_huge(pmd_t pmd)
 	return false;
 }
 
-static inline int split_huge_pmd(struct vm_area_struct *vma,
+static inline int __must_check split_huge_pmd(struct vm_area_struct *vma,
 					     pmd_t *pmd, unsigned long address)
 {
 	if (pmd_is_huge(*pmd))
@@ -456,7 +456,7 @@ static inline int split_huge_pmd(struct vm_area_struct *vma,
 	return 0;
 }
 
-int split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
+int __must_check split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 		bool freeze);
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
-- 
2.47.3



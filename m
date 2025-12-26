Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245FBE8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7BD6B0093; Fri, 26 Dec 2025 01:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBCF6B0095; Fri, 26 Dec 2025 01:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16EF6B0096; Fri, 26 Dec 2025 01:08:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF70D6B0093
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5CB013527
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:19 +0000 (UTC)
X-FDA: 84260592318.30.B48AE82
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 829D880007
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U7CnAZJt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729298; a=rsa-sha256;
	cv=none;
	b=vTkAKlJxdcriDVThf2SX2vHhlQ/9cVWAX9KqedJNLwZPVvSVg1sbsW2M8NjIkbX4zAINBP
	ZjzmdiV7xs90QameL7NvIVOqwjA+J/tWUxvayvD4yK8Y2hcO/ECGqN7JWb7eOom2I1CZx7
	67BDzUZvm+lMTWcl5NkxrXkUZhRDfnY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U7CnAZJt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZ9WfEpVe/JlQetyc2ZwVRBQF0W+yj98KQzc8zM0fSE=;
	b=8ak2CA9TObcYZcpy8fpt3F3c42GukyyJpBr1rBaV+JiWNemD0eUbTMtOs33fsjGKdsqvur
	YiZItj/4uEcVw8HO3aHcg/XMgtUFQri4YOdPaUX+ygSHOBIv+USv5TekllOjg7qQiQUBFj
	hqzvY+jhOTWLGaEYS1MUFwyNgRI0wP4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729294; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=AZ9WfEpVe/JlQetyc2ZwVRBQF0W+yj98KQzc8zM0fSE=;
	b=U7CnAZJtOGVsgKAQwOK/JTMEdGW2WgePc/U6iwIQzN/g4mHMepLlS3io52YOrS9hD/3FA6bETB7LRmZTd5UP6HOZ8bBONjhtGmiZL4t1PuYchnPxfLU+aF8oTepySL8rpEUecAtJSpCgUgZZzaVFcyGdhtjjMeWyySGTUB4/1Vs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvgZmTZ_1766729292 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:13 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
Date: Fri, 26 Dec 2025 14:07:59 +0800
Message-ID: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 829D880007
X-Stat-Signature: 354jojnxcz7i9kghxma9pkw6he68d6o4
X-Rspam-User: 
X-HE-Tag: 1766729297-159595
X-HE-Meta: U2FsdGVkX18jVPl5J+iASrKNFrOW6nC+Og1bLOpBAXuTbfYvjr6VWVog754DWj69DIF62PGP4pFJ/tzcVxetFVdwARiXQ/9+JsDBSEFh7lToBXecgK/fl32mm2Zqi7BhmY1uXcIa9RjHhB90OfzxDDe6qHuBtjiWjc+hf4oRTe/Ld0/GkPIozkG8Jj6jMAsIPc72fF67+aH3zD6NRInl/feLG+qHwXojuRECFZvevWhX3XLx0Sb+wOlh21VzfB1UsEd72gO9ATvrwjILAOpPMy465xciD5oraerAaqg8qhd7tVh3lOGN3zCxAfA77oJC2/IoxxF2q6nfRMiIBiTt8cxCkobqkYj5MMIEi6xSxczWc4vUU096j/O6O+D7VQce57dpi7kxV8+oquzPvIBQxFO2sn57d93BOWsqpOtKDfFpxNJROT09yIBQ1dr+QSn4pzOq4g4d+EL3XyseGjdXq9CoKb3RbRIzpVEoE/Ftb1R7Cc0fJaJEmceOO83kRQhUNGV6ZN4AWFhKAEMh9IulYEkR+HexwbNmep4WsqC027nuKcs3V6bf+VOVBgE2vJm8wDj3gwjoe7wL6qRkyHb3aAS5XpbBTaDKHbvxCOqIm3gaiCWugy9uejnWkw/sItTsDkResF9LtfiB3kUb6uHnvbio2mum/bXKe4k5URhw6hF0pgqBRPBJjzsA95fcI8m5cJQ3RwIoj0UpMWMMIHAmZKKWhuKy3gZwPUef87ehzrP56fsvUPE63GhVn7XCEQZf6bD64yBEfXHxKZqISiqGdRw1V7JvnHA4/QYBlXgZm9Dkbv69+LcJmbp5o9XuaoWPmM2Q7kR+Pi/+9YSLTELstvm229NwTdjl+4TsBJxIKYBnZOUxFLlnCTsvUUM1gRW6H7UWX4CvbOLQQODnoP1OBocWFiJsbnv8T+K6hl1KRU0k0h/zp9fwaWi086Mh/zoxq2HJ65UEFpZ9rf1zxPG
 MQegLrxE
 oE9Y2pd1gaLR0OL3rkxfArI8DEVwJtXcdB2hsLbroO2d7qSbR6xe2RoEL8rAHr10mcXaYbqixr2FWWTgez90WjoOXkUaWfAXZKw+tkTeQQmuIXwi1ssQgKsuZk4dPnFtFL/WjlSsQOicTKhozoQqAY6tRoQ5ZrKYjUD6JLIv3HHP6it7D42YTOpi8jcP+sL6fRP+JD2Hledzw4RQ7udhqsB5yBVpAVUaLXkg8zry84yB9YVT1Os0e+A7I+MnnsyfOtsxn82pmotd0e8n1eZeGSviYMiDQ4VtdivwUVVaTGekyeIfji98DPn0lyma001LXPQZ+WFJqSZRs8KDZm6EJklDLrtJhFMfI/XGwYXRnuZICgpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to folio_referenced_one(), we can apply batched unmapping for file
large folios to optimize the performance of file folios reclamation.

Barry previously implemented batched unmapping for lazyfree anonymous large
folios[1] and did not further optimize anonymous large folios or file-backed
large folios at that stage. As for file-backed large folios, the batched
unmapping support is relatively straightforward, as we only need to clear
the consecutive (present) PTE entries for file-backed large folios.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
75% performance improvement on my Arm64 32-core server (and 50%+ improvement
on my X86 machine) with this patch.

W/o patch:
real    0m1.018s
user    0m0.000s
sys     0m1.018s

W/ patch:
real	0m0.249s
user	0m0.000s
sys	0m0.249s

[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 985ab0b085ba..e1d16003c514 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree batching for now ... */
-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+	/* We only support lazyfree or file folios batching for now ... */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+
 	if (pte_unused(pte))
 		return 1;
 
@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(folio));
+			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio))) {
-- 
2.47.3



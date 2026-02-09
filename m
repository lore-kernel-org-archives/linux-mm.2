Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5594E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BA56B0092; Mon,  9 Feb 2026 09:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681F16B0093; Mon,  9 Feb 2026 09:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575B66B0095; Mon,  9 Feb 2026 09:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 341E26B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6E2314018F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:50 +0000 (UTC)
X-FDA: 84425096700.05.4773AD8
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD49C180004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VN0IPaG3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtnCI5sMjOjZdukKqKEgSsDbixroOMT6jGSMxfo0RNQ=;
	b=n+n52z012kgKk61cYddUYYnF2frqEScVtrVHqebbvHHQQYqhxh3dgdOtMosshEEzFEvtMf
	2Fjix5nCD4WkXCwzXUJJPS/mzwBy6NQnsDrXh2kCglBOFFVNHmWf+0zhJ7kcFkakFkhT/8
	IMSJP/WEC+aZX/8NuPCor91SqxvqP9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646069; a=rsa-sha256;
	cv=none;
	b=6IWRWwDyw0t7+Q+OYTLXOfPxmp3kY26nLEjloqh64sq+IwOF0FX0xZSW+G701lKzyqrF9y
	f3Q36zEP5+fRU+21DRvn+yeiU+RNcNx1WIh3sDkzGUKPlbGmnMB+bN+tYf+Ds4eKuzerpP
	do3Vfm2/+ALxCxmq6Z5UwtTVNehZ5xQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VN0IPaG3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646065; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=xtnCI5sMjOjZdukKqKEgSsDbixroOMT6jGSMxfo0RNQ=;
	b=VN0IPaG3zr1G53srkjU2Dq8dxstXKcHwQLfDwaEUm5yoYS6pSpJGu6BeqQtsj/OOtdblOuHWsgcNR+daO1Hk2z1QHzct0bH2FBlM+VTbZVPQi9ZJjliSyPC3LoFGK7ygLl5j4gwevszt7CCoqYLsYRnsPSYx01sJo5taxY2T8XU=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyt-ZaP_1770646064 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:45 +0800
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
Subject: [PATCH v6 5/5] mm: rmap: support batched unmapping for file large folios
Date: Mon,  9 Feb 2026 22:07:28 +0800
Message-ID: <b53a16f67c93a3fe65e78092069ad135edf00eff.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD49C180004
X-Stat-Signature: hnpfrzd1o5zb49rje516tgfaajpibbo7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770646068-218047
X-HE-Meta: U2FsdGVkX19JnF4dIwAf4YggRXORf224SG8zdCB7BQp/7EEe/6AcMD6pCp8XBDvs2jPR3QLDqJJm4JzknXqZL55Kx0q/oWtIPI9fBM0bJjuIMkOYKRXv/MAV9Q32y6uHIRjxj5lkZjNLeffZX5y+z+GsRv9dTLXKLtRqj7xD0yUEHQk7xvtmyg/OT2dxlYiOLop25rDSL71F/yFg7I+puCEGCEOPMcQdKH7zr2k+2XGHoR/vZa49Cn506nafo8Q4lLxjuUKo0bd9UMBaEcGgwpYJiI7X9nBfDKE4m9xBvvgcoErdCq/SpetNLTHWrdXJBG4T+cLCwuhC1TtINKwOZF5+tzXXthLXHjuCIX3hAFQNBrzhY6aGK1TX+MXOZPLpQ3h1QXojCFjWN/srNswYx1GG5gxKzjInj2jJmSBybCDjtCusMJrlOnURpxNXX87GlzQoYaUqL84F8lKzKFTixULV3UFlqdpi9RnuJ0RqQ2uO9ijGwQdUpqlNKOvPO/zqcNSecupDCCtdqflVoSHOCPecWroWxN6NQ1cZONBysKl5Sv52eDJniwVNvAKZL6ocXiVgy3i31cL+dlWfwgs9O3Xy9PhggZ5PYCoDminggGD8ydFjeQSE47HTo+/e3aEM2vZO5mCGsuc5qJ/isrPrNTYvZErHb4jTzdpHrPhNkTPAF/WhjMqMC7rDlsJCmjjSIXgXyLdJqi3/vOKgja4TuuUmnLWSqSGX6JjowqzQU8BNjDBTkjkVtjT4/XkTpd5cbwi787a7xlyzjNd9Pu14Lu4lhjpKNMDqCW/BzT/cChfA8K1lvH5QBk7hypK+wwQGB2Yhz35HeALMG5uIh2LtstQ9i2HVnZbP28Yvtt/oJtS/XYkndWTXh7B4iK3KNrpOxISaaUbDkBuLMHiCsHY1gdh4Pgvv8jk1VZoy2zvuoXq6uqKbt2kV35d3Gbfku1IyoTZrjCJ2kmMd7dZaYGW
 fexd9Ukq
 DdS7yeyx8vNNoeiUyAV1X0mYIPArC/52f6U00MTkHHlkWBATBnN+r45aZ+Wu7DJa2fTskyhkzrzv92CYeKUvllxY1sixNr3/L0WXqubBEMUJWQflyV2FLzU0OTGF+OazcEI90YCFVvurtRKqg1stg4jqPOGramuFU8phit10WW2L/cbpduGKbFMy4kHKEGh6PFyJNm9J1FaeK8u+gBw1LWAI6tMnw6D7FGXHgeHa46AMERuGEdYlOAGPXa3YQOcHpGUoIb7MvGYowqQXBV0K4lvZO8whoYtCpgtWICbAtiZuBQDBOoEAIvPOqi0cmr726xyXHe+qziVTvpu3Go3kEESkemqduyEqRAWInlNVejMzDe1Da0IpAqxQmL8UGHC0oh6Xy
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

Note that it's not ready to support batched unmapping for uffd case, so
let's still fallback to per-page unmapping for the uffd case.

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
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 8807f8a7df28..43cb9ac6f523 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1945,12 +1945,16 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
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
 
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
 }
 
@@ -2313,7 +2317,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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



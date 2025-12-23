Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D599E6B275
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6FA6B0095; Tue, 23 Dec 2025 00:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871856B0096; Tue, 23 Dec 2025 00:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787356B0098; Tue, 23 Dec 2025 00:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6131A6B0095
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2E8E1404DB
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:58 +0000 (UTC)
X-FDA: 84249657156.21.288C902
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4DB220004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F6QcNR32;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468937; a=rsa-sha256;
	cv=none;
	b=Cpi+4RyFVDnLEdcENsNuLgJpAo0Su9BqYExqSu/pZnDEuQX9dsekRx9O5oFbJoMNbvCyOf
	/3arPKSqKDFbGsMErPE8IRUPcDnEk84Tp2zWbEM4DaG8ZNS89PWarPAM86n43j+obGp8pE
	toDPMY0sP9gi14ohvngFO6bGd6Tl2A8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F6QcNR32;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8grYI0Jwq9L4Vxa84m+Wpr8ZQOY0j4j8t2HLaHt6zk=;
	b=T7aUmsjjFl6X0Dn4J67/FpHYTZc9O3fiyRDUkzud6sWFVIzl2EDyhh29o/chkSGDFowabV
	0YAiQUomzMHQ34armgsteXZgEqW2Mc1N31kE6wV53IqzD+2E2mOXUPhK764HVCFC++urKx
	GvRTRVkscAvsCAjSCPqrUj77e2nmC4U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=L8grYI0Jwq9L4Vxa84m+Wpr8ZQOY0j4j8t2HLaHt6zk=;
	b=F6QcNR32scZ94ZZB2nGdeXuxBO+ySRbl13YTyXMsYXXolVcT+fcT1Mh0Jk1YFCroP4eBvWK/OXJH/nceM62vL/mbGXRZD0PznJFpcnrTQJ+hBDNmlzxirIu62lFd+3mjaWyQjnpIVjs4tcwOtEFVoKk+vAuG7JGOdhwFHvBe6pI=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWSzHD_1766468931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:52 +0800
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
Subject: [PATCH v4 5/5] mm: rmap: support batched unmapping for file large folios
Date: Tue, 23 Dec 2025 13:48:39 +0800
Message-ID: <d869ae45a7be322f342ace62ffcdd4b47f4154fc.1766455378.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4DB220004
X-Stat-Signature: 4551b3enzb7kgju1ruqq4yw59d6nkcyj
X-Rspam-User: 
X-HE-Tag: 1766468936-532621
X-HE-Meta: U2FsdGVkX1+UQFja3tEPiOjnM5ZcGb9T8JsjnW2Sd29Iq8kZu7ZmWW0qq+H4YZGnBrsvW7DGwQOFfg92d7zdnhTtW1qxTpnX1X1vKQS+80iMARJxmdo/qKz8exu9Pe8DbZOwEI0KhVKrWqVC0zXTyrourUTjmtyP6s8ftzIZoXt3X/xaIWPQdbvXi1INxuruDjZAsS2fDweYq9OSOv2CIxRywgUmDh2NA072Qe3W2wVaWob3qPqyGWhuICZcfhwt/LcmNqb8q60vxXOaXk+AUGaBN4KFRx8oGEq4lUoUasb+Fbf1+t5JVF40NDendmZX5F/ILJV+E84dbiznO9VI8eCbXGdX6qO4TFZn45j9aWMc3mD4oUG9xoRiVhPwKmSD/fXHu1kX1iZXM+lFbhRB/ufNzX44BlZOELnmxPl707YRUaCimu/MwNwzRnRaqgzGdc4x4NomhCzdTdVg+KrOR8bloIOhTPjrhuoj/HwsITbOGJm9d8ZOtf+fpX/IAEFKbiqox8/QKEENEvWeZdqv64OmG8AVUrW1uijYGYavH0E827HoHcMEijfjI1cT+Nuq4oHgfnxGYq779scNMn+nAD7Gw/9YorEV86F/eX7Jlaxo7WSc86uokBPz1B2WAXNzu2OTEwZPI/x0uObSYvwubEiONurAKFyCA4T4djQHoqvFF3iFYb2pF+Bk4jxq57kryQ3I4oVf2++BZ72DyEY3Q2u6Dj6fssoqTOxUTD/ZZlpGtLObNQk2CNZAr+xA7mi+t1OjrLQRtPYG6fedFHUHFd+uncJXUViT5IVg1vciAYRSoX+uCZHmyKBefW+q4cjwC0FEeTF2fIMoV/vMfw3dFEaIL68vRzHoVgyi8bxJp8eIbRa1Omb79T8Wvgo5fB7dv2AOVkkqhnKr9yFXe+pO9bc974IQhx4c0+XeaYmwvSWuEqiZsoa+pksW5YtYVDqyjFrCBNpiSIxC1AaUHYd
 wEaz74IB
 h6ADEUYC17mfKYZzE4QeJOYbO2v/eYbLQ6En/o7BupydwnQGse3kmdc2HSCYcTwhcbGApgUmM/370W63PPGnFXJsR6oo2bII3AYdRd9kP4b78+QJ4ryUPTPerAyPv644yPizFy0sMzqwOOCK6YHjZKzDa1iQLT59/w7mxVHzMCXInv+JLsU1EVgyPnKZO1k0IstHEf/0UHmNqkjboJqjEepIVfvc8JDarjZkcQZitV9swfRX1Gyzeoide2RVZp67v5ymIH8ZPWJIpj4D+iQqR7QSa9LFPtbi4BuhzPEjAL8/FiwQ=
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
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a0fc05f5966f..7482121d4e92 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1862,9 +1862,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
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
 
@@ -2230,7 +2231,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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



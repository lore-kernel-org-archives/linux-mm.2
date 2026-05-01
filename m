Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615F7CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD99E6B00A4; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61496B00A1; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF686B00A5; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 741706B00A1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A9A3C1412
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
X-FDA: 84720079038.25.D74DEEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B64C4000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDzk3XUq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669457; a=rsa-sha256;
	cv=none;
	b=UNEyHJMNfsuBuR8smMWSmIryd7V4QU3mOizf4VCm4EsG/xTnZbm8C8X8E+MmFYKIhBQNEg
	O1r+G/KU+OcCRw2jaUshuKp3wECGDX2haKN7Cu0+0yj2tzg9EC9H8ZEKXd9wvmg1H5c5pw
	EK6d/Q/lv0RdhxFBf1TQCH6ogI6u0rM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDzk3XUq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=an6lq0odt87s4Xob2hr7GjptisyVAoY2+JO/uLPpJJQ=;
	b=b8qbcPxmRyl5JpdxtNE0//pODgKM+5rsmqS8E9VCKkMJh7RsqhlrkDUMxIMG20GSOqsOiL
	+BKWYv2n+CFlpPHSPFfbvrPxgIbI3CZSglX9iML1m/lOzDxwYg276SwsY5jUMvpS0XOL2+
	Knj15xFfEKjn3b/xN0EFKD8e+UpfiY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D429446F8;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDA41C2BCC9;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=POr4zid/4RAX0e9kjwSEM1rU1FDoknetSEYkoF6ny4E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bDzk3XUqNo9kUbbyVs69WOx+nKE5NIn/Zj8cboVaatIVWblhdAr3pzpymdvN38QQ9
	 ygnDOvOS9LMDze4Bq1b0LX4WczKjSPi5PBi22ZA9MbeNNKFV0oloMUkaEjkL+ZwEM2
	 AmNVa86XU96dQL6b4qTUWVIr1T0YN9hEronUvR7002N/8a9HW9PfkhHz6zr6ok5TMR
	 g8Oyu1EFHLhIQDlB7xnSJC2q85sKN/x9rJ/0GROQKD7LkG/2BUQm58bE3mH1YxHN3g
	 mG35kjkNxLoqDXimXdhZO5U4rUAJziqfuqWLnjiPB5gQH18MbcRwtvprwAkIcaHB4G
	 IooXSwEhPKOvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2807CD3427;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:58 +0800
Subject: [PATCH RFC 12/32] mm/huge_memory: mark file folio as accessed more
 accurately on split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-12-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1863;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=k9aFXwHSgVQ00njEcryM7TIGI1VaTNApzaY86FSiuv4=;
 b=QqCHLzigIMmqtIvHrFqvpIctYLj4s2so+ICW0Z0obHQIhpFKNjP3tQFD/+qeGoRVwmacXTFqZ
 uxnxT2yFKm2DzyUAKs9L1I8OUW5nQDZogw7ArbrYJaph0LCJt25LX1B
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: omkjeebiqke3fbt1gxggrwabj7jyss5y
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B64C4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1777669457-971896
X-HE-Meta: U2FsdGVkX1+PBKZp+9e5FlHm+85aXQogk82jNB65wGdjWsnmaMyEIovvCxRBJCpjKBPD2kTVRoOct8Nn0G4UPM16pRf2H1+qeZw0FZ9mWR2uKUy8x6B9TWf+FxcnlNAQLlPrWJzgRtOIfpqx+j126KzbuNjMqrXzppmrp4kX+WNd+0RGT/hjGTcTdSjzuGXdBLpdrJ5rCMv8mTUiMQXaLcdfE9XtH9NHdQ9+fz1oXGf4topLAf2YxP4X2XCb1ZAYYivLFSsl2xVHlpsHSw28vFL1lawRkwDhzoB+a6y468WjWF2WyRW5rsPWlX3DT/P2C9GfVcQkh2zufZ7kftrkiIZVXgG4cOUF7ufuJBOzXG5UmUmNhB3OFieUbLPTQJOcBOrDAU7YEwpekhP9OAjingSNCX+3ec2/MxVeVJkX9bRLS85Zn5gKqFrg1+F2hAIoTFumFfrYAMl9ZWVltdtVkvs1CSJQw8YasR3rJKIORLnh3kFeRhEw4/ehPpPDK2v7rtoIOwlDLxwOsnSIje+yV1OINb9LO9KLR5DyAim/3vWb9VW9bhtNGZcuLW8EV/f3Ol6IcMaoG0McpDMAFE6J7aU0uHDEqC6FzRBgAVeYzfxDMjxFGc511nE38Hb7IdRebQUFTopeiG8bidSRQaCC5N+d3Ye2yUp06WYO0cRVHLGRCL+B0CIx2gws/z5Ct34Os2OC59phu5tg1X0D1+U6h10CuPJYI+Bf+LSORMfUXWx4BX2xX8pPU4OHqKrS7zVeKcKX+Gz+qBGw1LA/pqu10t5Hrtjf1pHYjMMTmA+AeLZ6b+fku6xHkwmSLfaFqNY6LRDyR/57WB4Ttnj2SNIFQbSZXcYOkTxi191kf3ZyGRjRSkfp35OHsbBmXz34+JdJ6R/8fCIQQKS52DdzX9o+qrQ1iRpedx+SOeGK+XUnxOIwK5VxYK+ovDjdisZval5VWqNOJdcoh5ef2cXOrlz
 ongsIp6s
 xDEea0L6VF49C1kWIBDWveSYp5KeXrdS6P5bkXheUNdHpu/Pqgy6RQ64YTmMNz+O1P8lzzvoTXJYoce6AsiOn0zoKyW6RMMYnfhQmVdJxacHmi4M9OE3AuzXfEC40r77nxG4Wpc/RgtzIfvFQ4rRzfxW7KrWwE/xTYyF02N4w340lJrIB6533t4Gc8H5O4Cx1WiAb344vAd/Ec2CijAxpplQeHNZrtEfI7eEITC7pZcGKCYB9sQX/DXo5q5jzXa8q+AR7FCGeQGgdXkYrR/dx+Dxi/g7JQs8/Y6x0z5dv/QsA95SjCrkZU4Ij6LCF3DodQitJHAaPWImJpEz8ZlKAKQEyT8Uq3v+RkV8SSbPCJ/3x0SCJiI4UF2Br4xVLYBXVyMqaU8avXrLRHxZLsn3CC32b8T37Oien0IGKzsMr/Q7Yu+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. Actually right now, there
is no huge mapping splitting for such folios, we simply unmap it, so the
page table's young flag has to be translated into folio's access info.

Right now it only check and set folio's referenced flag, which isn't
enough since folio flags update on access have its rules. For example,
ordinary unmapping (zapping) calls folio_mark_accessed(), and it also
checks if the VMA has recency to avoid false updates.

So use the right helper here and be consistent.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0d0b780943..87a2640e3396 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3023,8 +3023,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	folio_put(folio);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
@@ -3141,8 +3141,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}

-- 
2.54.0




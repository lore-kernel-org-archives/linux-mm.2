Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC7B5C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243D86B00F3; Tue,  4 Aug 2026 15:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A68E6B00F9; Tue,  4 Aug 2026 15:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3146B00FA; Tue,  4 Aug 2026 15:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3E496B00F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8712B802DA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:44 +0000 (UTC)
X-FDA: 85064566608.13.D283B06
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3B1E16000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X69nTRUF;
	spf=pass (imf08.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bk+Ag5nJI+yRxdGaF5AGAZX80rlbQeLkx2hO1upBMEY=;
	b=13EevG60tJEZH8FCYi9Zxks/bIJ0NhDx+Q4Xtj3o4QCv7TBriI3O9FA0WsaKwE9zRgK2AH
	pNt0kmUu3LpFvQkhzB9YQ1WGr5JKbVJxRWVuYYyLPBpxvLeUd+g5Ylu894W9f8c5BV4R1C
	8QcGi1SI3mJw3KMv8igy+9tshAMnwGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871542;
	b=8g626po7FqRYl7e6B/ULaLDfCc/Xv9MB/s1osEMzwYP5ItlC6IF4s/NlLFF4JW9mG2WwSX
	LQVo3A1PnXrsToUyHWXThOhNPZwa/nYR/idbaJxnyeR/UJsFT9sJcZng7hSR1ovl5OvFrS
	D/TP/9nsfrMS+3dq1LYCj0uAPOcH7yU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X69nTRUF;
	spf=pass (imf08.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bk+Ag5nJI+yRxdGaF5AGAZX80rlbQeLkx2hO1upBMEY=;
	b=X69nTRUFN7jj6tU0Ubf403CSxDuMzgXz+l03s90oUMDMZmK+V24Et9J5ogOrK20R5yccC8
	u+ShBM4blOyVVsBjOjP3bWKlOHIG510Z2kTlDYajcNRMEd6SQNKkz6w5y9T4/lzrbuPRnl
	66SVtfVx+s6seG8eNX2YK4PYPSQEhdo=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:25:04 -0600
Subject: [PATCH v3 6/7] mm/khugepaged: unmap pte before releasing vma write
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-6-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3B1E16000F
X-Stat-Signature: i11yo4y3wruwybygj49hy8p5qhfy13eo
X-HE-Tag: 1785871542-417148
X-HE-Meta: U2FsdGVkX18m7DqXPFg8q6Fzlcfnbnf/MRfI7ODYjxh9rfNNmtQdifggg/h1p2D5FoUFAqwLt3Vm/fwLugvnqfkPmjGoPlrD4/my1wLsN337Ixmf2D8H67jqDjJS23Hwa2+pG50GzGX9CalcAtWveP9tfCQrrDuOPk25N9xwgdndW96GLDrwaerWCM8ZM5U/y3uJSFFl3Bnlx/5k6pFJmUwK2IeBhSDQDjjZr2qqJ1X5RxVrIkKnmRf0V8CCBhGYmMnrM0uBw24LcY0TL7pQODLeEJh0ia5eI9toyEJAlYWc2igYUk1FYLBEBJFDgL/BqTyj9wKdxDjCFDkNk9vNeowZZ4F/gGeiYN87x1JRk7hXlxWnLYUKo/le+2A727aZ2r2OJUE/DUe9vPKARFbi6soax+khCQ8Y8cyiL6GAtvAyu+3Hy49PNmCgz9RIdCfhgi3aCLf3rqXsU2mKpzAhps7C4GgLIJyIWqrUXOFMUQ4F2OfH56SqsrQeeO8k1fmlE81d55AIAOd22Igx3Dgb7jXcU25O9g2Whxjm6IjEOkwbOisbp44XRBmTR4nUGzq6UeoiyV5S4Wqlt37Yo7wriRYoiihEGTU/nbDENLfY8JHtmb67+3KtRjFIWgLMg50Vr03dzH2ob/QhelzH3vvZjBogL/3FY3lVZWPJ2rx4QpS+MQqzj95uRHBQOIzPXIR4hetSGDbLrom1xe6x0iicqZFRj4itJbqeLcWdIYRBZI0+4hkL0iXYgFo+8sKfBLP8h+Z3EUgdiuAzUwucWnlQwTYVw0p80hgLtk3pOPOJz4Y1lAz/RHiWRrlgfRtCqDj3YeeiyyTWBzKEwlO9XBtiCsTt2uHfGEXkLyjEZXz2f1R7NNt36R+/DzlmPcQG0kmOqXwcqj4yxrVrFmK6IlNAwuCDBWO2x1D2cFCm7gX9Rs563cP6t0HkW0OCJLAmvhV4LL+pY25isL6obSBYtPf
 onITB4P1
 9Z++JCgFEXvh/EsL00wm1Sp1e+WM8W3U8RBsBS8xk+z8mpUH5G6WuL70BA+so8xratk/U2rbJhbj/qlQTwROwftKQnkIItJJUr41kfwWnucvm+Bof3SS2PQR5FXSc+gHhTg8+4Tvr+X5exsbRbqeKfdiTzYKP1d31tyDvz1p1yL8BU8h/+/qsJqLz8QsfMzY0UH/HOygfrjcDWlhd9ibQpmjsP1IMwYOH3CE3SZKgnj7XCok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are currently dropping the anon_vma write lock before unmapping the
PTE. Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 068368d27c2f..3338e9dc11dd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 
 	result = SCAN_SUCCEED;
 out_up_write:
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
 	if (pte)
 		pte_unmap(pte);
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)

-- 
2.55.0



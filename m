Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8721CD4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02FB6B0007; Fri, 12 Dec 2025 02:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3806B0008; Fri, 12 Dec 2025 02:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0586B000A; Fri, 12 Dec 2025 02:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF24F6B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:10:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 645CE58FC4
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:31 +0000 (UTC)
X-FDA: 84209945862.26.2E93FA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2338C000B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnkHi+gB;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwoAt6gWbQFsNQlXgeyIOO8phmGngb+/vSttqgtcvGQ=;
	b=68GZCcc8wGUg9ejHmLsriy5BVSYE/CBHlYtbmV3kIBiB7MKNBhjs+29DZze0YTMAoll9Sz
	kjz5eFNJZ6iMPXQASbmtqcyq5wRS4jtpeoLeDyKEnfWnA0MQ4QKidLCyGt4bm4ZfpFSSx2
	luxIPub9SY1uVZrDV/G5xF7/rAkjXZc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnkHi+gB;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523430; a=rsa-sha256;
	cv=none;
	b=V+ASb2EaImynNqW552N6/MvFiv3lqQkm/KU4iiWxSddU1rdV7pLxUYteqr7bKz+/MJIk9X
	SRRvAyy1kVkt4d10CtKgrlh3AQg5ehcGqWWhlpwGG9idVhDFPdf9naAeTzGLjRVZZVhuLq
	Zd/87Ft1XJ6YyLjmLleV9+jqsYiHmW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF52443DE;
	Fri, 12 Dec 2025 07:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3558C116B1;
	Fri, 12 Dec 2025 07:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523428;
	bh=Dw8ngcXvfO/801VaaTPwfZV46DR1ilbRLvNzIebB3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnkHi+gBWxOHQIxs0FI0ulwlC7AacMDuWR883V9LK0fZEBcmOM7Bef9Ntx0f0WCyQ
	 As2MkpysxWbOfrwtar89uCRwZ+ZSNA8cbh6/YJkP630pK6i73diHLetvg/QStw07mQ
	 cPQ/6z9hGfCsG+bQXSrtKAB32pkAFig2GGvZ0nBSbYa9ZFbh+AgZy34fPqWdA+ARwq
	 aS8rWfq0bkj7b9LIPjReOmFLwAVLuRzvSdsEUb0lbqX6scQTrtaIyNc74LnM+1XME/
	 NT6AK2S5O7KZZqddAVKONK3B0T5U+6EQ9gQB203eqagbqpfD5Gre3swwOplbYo2dp6
	 Wo2VvzuwGgJ7w==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v2 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Fri, 12 Dec 2025 08:10:16 +0100
Message-ID: <20251212071019.471146-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251212071019.471146-1-david@kernel.org>
References: <20251212071019.471146-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dj6bgrkhk9stwnz7jk6rcuknamrn35ep
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2338C000B
X-HE-Tag: 1765523429-290895
X-HE-Meta: U2FsdGVkX19V14sMSTO5rb0HBW8AhydWbUGBbYiktUDfMu516HcXxf5UOBOV0QckqDyQmfubXUdrOv02oZuv+m1Qx4DuIF/CHFg5Jk16oazKO7fcHC952Xs/gW2807KuEQdZJ8oYy7lvmqAkMIMRqZKNm432JnDzs9BN1p7JyZf/1c7fhTprWKTpOK2GivNUgZiJzDbWKklEDZfoA25Pk1cbR5eUT7FbsC7OiMFnINRhzz0DDwId1W30Cm/NVGP3LRtKtZMxbynfF1hrahWikb5rYWJWe5jhY8lEu3l0GdM+pTFRPcayHR9Z3FyNZwR1HvHkyqr60wSRJTQshru/z5zXRBcT4+RhnB6TevrCmWY45TWGijMe/nLUh5KoPoXKQTkAgFcMGLWWcgpky3I1XZatI+9V3FskVKxShMThc+Z3FGOE7Xz8o8q3/FArjHyCilMOw8FULtLe5gcbjwh2akAErSYQ85qwE7QYk69YM5ujgVHqGuTVs9VlSi5R3GXywS4CayAzTlNW2rgr72KPQYC66htfCjkt8s1GRMslY1G45OpCEkoY/2FV9+pes5TzfqlXd/dH3eueplaZYnQhyDLDZRA6n0tUKOKKdim0V1FEIJy2ofAZIfLCkoVSXj7j6QcE4H0QvecRV3VbQVewhFrH0G8uWaF5+/xCC1JPiQt15gwU3cl0SyY/h9U2Zf0Ix8jDCjqnlf/wQvZ22+RpJhbHJ/Dji9P+/Y92/MdnKnwokVGkP5AjJMqFUDqGnPIk4WGC+srHlgWZKQOC0GXtie3cOaFG3GqqClr9CLmLTHFLLt6dkGTfQvU24QY2SxDiXiYyqruHjy9xxhBjvfqi3WNetq6oCEhIttbZG01rNT3JnIxo3kVuOFN4hLAdxs2r+MI3m+z5thHxOg/nnbEB8X08t447tUCh/NIrlvaCdxp2NtInDcl934CTPvNsghaUzzyZWBOcApdCgj6IGRA
 R01Bx1uQ
 8tNVqTeSDAtHiGps6Je8R5IETIUCv2UnzfRaRve+pQJPhYhWtKKMrYNxusKldmVzEeYvoLsL11Zt0MhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We switched from (wrongly) using the page count to an independent
shared count. Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to
identify sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are
not exclusive. In smaps we would account them as "private" although they
are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4e..03c8725efa289 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1326,7 +1326,7 @@ static inline __init void hugetlb_cma_reserve(int order)
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.52.0



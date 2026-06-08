Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D13CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9786B00CA; Mon,  8 Jun 2026 04:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80B06B00CC; Mon,  8 Jun 2026 04:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A702C6B00CD; Mon,  8 Jun 2026 04:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 952F66B00CA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EC15120A06
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:55 +0000 (UTC)
X-FDA: 84856097550.03.F8C0619
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D97F120002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=djOaZnLL;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScAoSfQrcD4R0Yhb9nAUBLjdu8qZL5GRGpRfEb8F90Q=;
	b=dr5WZhvNHP6rs+YOoPNOrjG4kqcDdBUYSaFUE8y7J7zNJl2QI0Y/RFH3Z+HORY9tExyOQo
	q7Y1ntxQShrSP/KcyKE6cSqyPPqcDT+i1ab83s/AH9znW4NhPrrqYzbQFAxv4DF0UWQ1hZ
	GIc03hXS182qbmEzg6bm4fjHwuNPZjA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=djOaZnLL;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907993;
	b=w5yqZ2y1goguj/I2Scs5H0XaXY2mNLnRGwAO8oDE6dft1su/ji95hnrAN8zxkKZS/KzXQp
	+9LtEzZwxna6KEsGEhQwVlpzfYc+iADqXbOdi/HUA3bS+R0rDlVHFJyMBtZ5Eaezlj4MF3
	pyBcAn8pUXVeFW6GSbI9dPVOyvP/fWc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ScAoSfQrcD4R0Yhb9nAUBLjdu8qZL5GRGpRfEb8F90Q=;
	b=djOaZnLL68tiyDAA1RNRRLjf7i6w9D0+hyMhUbXNybuejkcs8cciJYlviaGWH3tnp2vxRn
	PmJ/bUGptBD9ZicZ3KwgOMLSQrQcjjalYs5EsgtDEYO/Arr9yjdgckpgYjuQMK8/YGwAwD
	tifQXUyF9w0v1taJAmkDO0kwnI6KZgo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-4lU-Umk4OUGJO2u4mpkXMw-1; Mon, 08 Jun 2026 04:39:50 -0400
X-MC-Unique: 4lU-Umk4OUGJO2u4mpkXMw-1
X-Mimecast-MFC-AGG-ID: 4lU-Umk4OUGJO2u4mpkXMw_1780907990
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a786f987so47047295e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907990; x=1781512790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScAoSfQrcD4R0Yhb9nAUBLjdu8qZL5GRGpRfEb8F90Q=;
        b=RPG2qUxwd2sANGiTpblSzLJ7VECYWFiGFNXtcyibtZ8GekFGC0v2ZuQWOmkPYbcUrV
         gzprJzNVIo/8FzN4pWKVsPIR6CjkTtNp0ufQ6zp80uCAkNQS+ABLIFSCtx4DDeyErQWY
         Ij9I2SJKyvDzmtfWvwNAYjwsmwtguyAC38uL2/grVbUAeCJjedilt4fCLjeNw43aRfzV
         PD7Kj8uYPh/fpihUPtsn5pwA7qMoVF4JUP0AYoYdkeIgYFGoyDHugsR4OHed54lih55h
         ZaWKZL0rdxl1FOQC5YQw+/maiWuwoY8qBXkPt5KON0oZbEjKARMyJzrX7w1jDF4XNGXD
         SRtg==
X-Forwarded-Encrypted: i=1; AFNElJ9/MKwBLcq7i2abB6X+5fM+kyK1MgHSHTFGZARIEtl30Q94YxqcQi5+CZzj1YH6gKxxIj156OQOVA==@kvack.org
X-Gm-Message-State: AOJu0YxlwtX41HSv0WVlfhQIGtZwbIxH7cm9xBkRlbJoDGivipctZ6NX
	MEIMnCOGWnnvj4rpD/CzmCVKYwCSptGlrjWBNHy9CU4Lxa5VrVMh8pgsjNKVZ1ZJBm451I0lY+n
	RwbXgLF77Lb+1mbkd84Diiqj1BQOGV1FpFR+b6PG75iC6Zcuc/X72
X-Gm-Gg: Acq92OFsufVXsOKJwhCA+2gFjKrnVVYSzSgtq4fhW0l6t8BBhqf8VIusQ5zDcniVS3n
	VkaMiySR1ALsOeUWY7KCXSOatl8/c27evcYuJZNtxvp+UVYfLBkfCFEIN/0cjJtbbYVvq4nELEc
	AiwZHrTywSGjW/XaTuJ55QLH8KwhlUbcqsA1F1ix5324pBw/VGchQC3+6xuQuWB0RvyAo9UQyjt
	rgTG47Vw6ER8nlV4Zi5D/1egipuRnGqJTVE9btahIGP0mhha40SWezOJd8pIlmPZzEKKcrTEHd2
	55uOAzxodFAlDKzNVWe5AC3oSsRH1GNdpLc4XVq3nRV9zckoopdsYM4myvCYNHBtWGGviQdoFLB
	Rwtn9Tk1QUeQZtpUrmp9KSJk=
X-Received: by 2002:a05:600c:3e15:b0:490:adb6:793d with SMTP id 5b1f17b1804b1-490c25f67d9mr239705025e9.26.1780907989485;
        Mon, 08 Jun 2026 01:39:49 -0700 (PDT)
X-Received: by 2002:a05:600c:3e15:b0:490:adb6:793d with SMTP id 5b1f17b1804b1-490c25f67d9mr239704145e9.26.1780907988974;
        Mon, 08 Jun 2026 01:39:48 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d66c8sm356783495e9.10.2026.06.08.01.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:48 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 29/37] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <0d6c2d31f48ff454223ad4f1d37ef7b73263bf5d.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BBy5ksoP7o48YnI7WfCtcSa16uCmTNcfTSTiIra1flk_1780907990
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D97F120002
X-Stat-Signature: 4fmxggn5q5f7xqa6mumt9u57gwzcbymj
X-Rspam-User: 
X-HE-Tag: 1780907992-46479
X-HE-Meta: U2FsdGVkX18pZrWtzJESNOWJEaYvvxHB/XQjTgegitxslAy+ePVmNpEK2yuG9lSFQOTPM6hAgZVVokIXpMEK52tXjDrfFoSzk2X21cJke4jjCqx00xE7ISFVhm5pmmVnmoSmguuq+e22c6C/cc/THlKSjX1dvSrYpKQ3GRKEqwnJxk5tEaHLDZmQMOAZtKajPJmIrlLZC3hGhhdP/AISvOxTrpIiQHQbu5tzEJnAJlE1htdq1nT1/QZYl0+7cQpEaWEhVvxy6dsvZUWkn1oUHFJ+5bTRrOO1txc0C4pxAX5h6SxU4hMg17gzNhy5ZiiDH3C4kIkghAPiiwFDO1Cs01Ez4BX5gXEz0ikCXBMFMJ6uju2I4dBQzGl7E5e+5KxGdxhmpXBQEj4sVX7rq0mBzIlFw7BWkuYJPw1Mtz1otwbaFuNtzEGE7+X5xtbNE1Sl8N7bZpJtSvb8RaNc1THwC703aLL/Sqi+3YzrB5e3K1JAMA9PO/bKPqH8g695nlldybdwpODJzZNW2sWs0/Saof4a81/gaZsPgYX6pDkQc+8fvYQM+Mj2cPiSL5xS8a1ZJaleJCXSYTsJm3h3NuMKV55Ddczxa8gBtOgoahyUcVMy7dJylS3AO5wIu7xHcEEQBCJikJqsDFdk8cvwzsXDFHlK3ucQ63aC/WrL3sgesUGY84Z6cDEwdb65pbrEzVojSyAz8E+FRQNiSjduMQ7Ksg7yBPmNe+h/H9gddMFd32i9yvRx+qqCtGQJY3vd9JHoFwwpLx5hXe1eutNkMW5997zWyP90nAhfnP9Xu+xtZuHGeiW2C0JB3ghgRN4gV51HfA3uuahs2eJ+pniYjiiLMiV/3zY+cbAK6qLuyPZxCEB2ugub3lDff64+8/wMdsAEslPFVwL7JVpyWriClMuXigZPqo2VmZnBNUiE0W6O0wcTaeVmPHRTyNDWI5n6cBcT6gPWvyvGLJ78RpWXqh/
 zAR43Xl7
 GBV+1pXt3GxtA3nOKGL7CtNqMh1WRyPEf/JdovQINrsZwOdnsweC7hxu5X3dh5mZnYzhlwPEA2HlifeSYpjoXyWlat4zb6yOEX6wKwo5ZurvDJVEeR0X1V1tT9hCPQGujIo8Sn1CV0Z+tt0iGT+LowPpsHXHNpNZHzb8UH7cHQPiKiUbmZKnqxiCq3G9MQ4MKiHLHWWOd3jZdQNkqp0/ioWAlWHaFoXLjk0cwMrAaxH9SSVNz7gi13SS8MRqfAiLyBsspcJeLSf7kTDT5sD8lkFaMKLxGjLowumvQa4VIDBat2cmk67k2vRQUgTkidNH3fqtO6fGi5l/rIHfB3veb38xf5x4RaSlADpvjPEq6QL3CDOXuOGnbk5t4vsXUhCuM0pfGO0zv14hFh2zPgJ/314yiww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Note: HPG_zeroed is currently only set for surplus pages
allocated with __GFP_ZERO (via alloc_surplus_hugetlb_folio),
not for pool pages from alloc_pool_huge_folio. So the
zeroed output from alloc_hugetlb_folio_reserve is typically
false for pool-only reservations. It becomes true when
surplus pages fill the reservation. The addr_hint 0 passed
to folio_zero_user is acceptable for memfd: these pages are
not mapped yet and will get proper dcache handling at mmap
time via the page fault path.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/cma.h     |  3 ++-
 include/linux/hugetlb.h |  6 ++++--
 mm/cma.c                |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/hugetlb_cma.c        |  4 ++--
 mm/memfd.c              | 14 ++++++++------
 6 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..dee88909cf5d 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,8 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 06d033a57a61..7eb529eabe99 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -708,7 +708,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1128,7 +1129,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..27971f6264ab 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -924,9 +924,11 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN |
+		    (caller_gfp & __GFP_ZERO);
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ed00db703911..a087e915783f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2196,7 +2196,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2212,6 +2212,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2296,7 +2302,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h),
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..c9266b25be3d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -35,14 +35,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 		return NULL;
 
 	if (hugetlb_cma[nid])
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..a99617a62e33 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST



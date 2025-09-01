Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90936CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5048E0092; Mon,  1 Sep 2025 11:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5958E0084; Mon,  1 Sep 2025 11:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4953F8E0092; Mon,  1 Sep 2025 11:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31C138E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:13:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8B751DEF52
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:40 +0000 (UTC)
X-FDA: 83841025800.30.63138B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12DD0A0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PZYQAclM;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739619; a=rsa-sha256;
	cv=none;
	b=p3/tQQg55K1BBHf81nwUD/jGUNUt+q20VJ/xlquZsEHHLrrrj6BaO5A4lnxJAx9NqF0JSs
	d6sS45JohbiErHgQwSEXqIBY9uVTmxYT4FL64ROMFOq6v44HQ19Q0CKtVFIBkORyjlDHHf
	zNojom1AJtQPootRy76lBP74UbpThlA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PZYQAclM;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPHmZzTajGoiIu4Pb16cc/zxagZSiNHTxiRnREwqsAY=;
	b=gt29jSn1qurZHEIv1w881MC8WJV8tkWnKhj+rQ8DRq9BNAvFCDJn1cy7AhAh07mpNzUlLe
	Zl7jijlJA7mFtvU5mFCqJbBz7e5I80NcF1HO8ZZDyq+fVUQ6mK7HNlyCPFE161GtgwSnaW
	7g0qT1wxRUDziKpxISSEpET8AFSxcao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPHmZzTajGoiIu4Pb16cc/zxagZSiNHTxiRnREwqsAY=;
	b=PZYQAclMa9O33BJ0b5fGUBIXonyJORLVhEyERoZxNYpsnNB/ggnM7fGI2P/8cefNLcktYZ
	nS8UZO4C5kP4LbpXKWUTKFo8V3Mew1PckyXSqtVlMnO2J6/zcPYW4z8yZZr1416YBYSeIi
	qFPv5UlHnWop96CFkYVoqZOomKnu1w0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-GrEIet-nN5GvzvRvynVS6A-1; Mon,
 01 Sep 2025 11:13:35 -0400
X-MC-Unique: GrEIet-nN5GvzvRvynVS6A-1
X-Mimecast-MFC-AGG-ID: GrEIet-nN5GvzvRvynVS6A_1756739610
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BC2F18004A7;
	Mon,  1 Sep 2025 15:13:30 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D7A81800447;
	Mon,  1 Sep 2025 15:13:15 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 34/37] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
Date: Mon,  1 Sep 2025 17:03:55 +0200
Message-ID: <20250901150359.867252-35-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12DD0A0004
X-Stat-Signature: dfjp1sdwe6xn879864y8ggiumzhqkxbm
X-Rspam-User: 
X-HE-Tag: 1756739618-867645
X-HE-Meta: U2FsdGVkX1/zF2Op37s3jL1RO1sYeJuQX1mibhDxhDbRhPbCE+KiFKhaHnmXDXLWVdLbHDlyl0Bl9vBm0ICVAXXwkaUuHZEQCZ9azY5di3gXvnse2FIqC2z4t9+g+C60tj8wejckX+7V9i4xVdMSJVqm1X1gt5gJ8Wtw0MKQQpGWe6XkLxjp49r8G4CQnq0kz/noU+8Mt6iRlcce+xpPjlj1Pa5dxxWOtGvxr/RmDpZJdA2C2Dh4V1o9tXGPteiW4k95lkKej200vWFrtXjowFPKBre2zlINeHsWgK6QsrUSvwpbmDUwKKpHIvZiAEbAEg+XhjX9/N67EAfFU5HfIMkcBThN6wavjR1PvsoLaGedkI14TRxe3u5RDCEV3kbiim5QbrgH3gk9mATDt+frSw9sbR8PPnzhAA78LVc5KIJUUKTFTBeuV4iQ0ipCNBk7d0hq46p3nmKHiM8SZApQqF1J4bX4++q9WXsmW3vhzFy1rcvsFqIbxXJVo++b6EM/OjFoK8DRWufmZyiaO1eEuuqMjnOtnYE/UKQnYBwOX0vZbMd05HNC7dcwBEQbHicKvq6YPiUOwcXaYRoigCVN59GxWfRlCZbomclqnKAr9l3iohLNNkttmqWlqtSwoUtXLRR6tqbc7kwp/xktRHzxkC+jIVzOB0GF4ym/hF5gT8+4k/uTmLeupmoW6HMFLgRMUgtxXIMpW2AB5+PY1HiWpI6vQTHQ4PlbR8FDx9f8kusZZo3rGNX9+9v8kwciP9uNIgJbg5Ki1J0xMkXBBkUnQEnl3dPYqJVfnd21BU/3skXn4L0tz+jCL64ILkZpVfdWns6u0YD2QWjOFp8RcpneBOuwwvM3eYEL4VtSfKBTSD9airER6NCX6i/2299D2RQO3hPtS/KF4caPLuSSKkqCQBDWM4pamBUByVoImrQP+esPWs+dW6XeA4BLaBd6buDJNpKZeU7iVuISI2W3wv0
 /6JkyTgE
 oyzEM5b5InJgQfNJS0S6gubRiELZOYmIJWHz8wlVIwe3wORH0flVvxyDkRRBO1uZ0wwDtCP54EJ7UjEM+m+9JkyRBzJ7tFW7iyy2/kruD+dA+4YjFhF0AXvXG76srsUs2W6ll3ZItRKkq1QPNNGfJi27RthlS9kSN92H3766MOl4UDJD/Mx/wzs3mrirtDwWKMR6fwFMrFiw802KJpgwdbWNcV/eNeyoyt0/9vYvnIdtBp4j2YWf8JXs/MdRIK3d6pT/6JjlE9YUrOTttQZ5mPaQEMb+zng6lRrId+rV8+5MOX6sW+WoU4LUqehdQgdVe4P+wiDqcG0Xn6DKNFMgGPQE6zmoqYCuraRlisOV9vyff7xI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is the concern that unpin_user_page_range_dirty_lock() might do
some weird merging of PFN ranges -- either now or in the future -- such
that PFN range is contiguous but the page range might not be.

Let's sanity-check for that and drop the nth_page() usage.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index f0f4d1a68e094..010fe56f6e132 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
 static inline struct folio *gup_folio_range_next(struct page *start,
 		unsigned long npages, unsigned long i, unsigned int *ntails)
 {
-	struct page *next = nth_page(start, i);
+	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
 	unsigned int nr = 1;
 
@@ -342,6 +342,10 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
  * "gup-pinned page range" refers to a range of pages that has had one of the
  * pin_user_pages() variants called on that page.
  *
+ * The page range must be truly physically contiguous: the page range
+ * corresponds to a contiguous PFN range and all pages can be iterated
+ * naturally.
+ *
  * For the page ranges defined by [page .. page+npages], make that range (or
  * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
  * page range was previously listed as clean.
@@ -359,6 +363,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 	struct folio *folio;
 	unsigned int nr;
 
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
+
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
 		if (make_dirty && !folio_test_dirty(folio)) {
-- 
2.50.1



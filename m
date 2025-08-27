Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1EECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D31B6B0088; Wed, 27 Aug 2025 18:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CA26B008A; Wed, 27 Aug 2025 18:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444D66B008C; Wed, 27 Aug 2025 18:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31B166B0088
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:08:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7CC11A0883
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:52 +0000 (UTC)
X-FDA: 83823928104.19.C0EF0D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1EF5EC0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVVcIeOY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332531; a=rsa-sha256;
	cv=none;
	b=bQyoh6GI5c/YV2ii/gaWWzyrpT/5K+uLw+inyMRY0hEB5TKmL2y/rDka6cqkiZOmZpybDX
	F0JvnrZvVvxJjnEF8QNcy0MoJj4WbYldqH4oXr6v6QFlsg6S1QYBNWHFat1hP9ZNzBZfLI
	+S+5P37y+34HDsYJrXbY2f8kei3uSvI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVVcIeOY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yoxwOMbQb1SEP5yy8swTlBLejpoyGQxYs/+m6JyaCE=;
	b=Yx35aLpusKxawEgTq9wqs2Ec5OTCpE5u0/xUczsnJVzF6A6GY/Rs7w81qohI2WwvuI8rVx
	ibUK8q8GtKePFLnjGFBS9NGvKmRXXkuMuqwsLk4gga7//V4FmjtzRo5yVRRZo49nBM3S+d
	TR7olPsj0mUFjR0qqPbPMBPtQltcHfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yoxwOMbQb1SEP5yy8swTlBLejpoyGQxYs/+m6JyaCE=;
	b=WVVcIeOYnluGMWx4dct1gKEaoxFA88KOwVT3JrRPqYIcP0/nTaNkTVd7vg7X7cROjlZvEx
	gWx4iQsvUb3SENue0Fcxam72Y6rtM+xdmxOvlZAl3irJ/3e6u/CZTqlBsnTDTVHjzKk+42
	M+yBjT31g/HzBmgtxwImMZNJuY86e9Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-cc5kuIasMpO-FgCR0RSeGg-1; Wed,
 27 Aug 2025 18:08:47 -0400
X-MC-Unique: cc5kuIasMpO-FgCR0RSeGg-1
X-Mimecast-MFC-AGG-ID: cc5kuIasMpO-FgCR0RSeGg_1756332521
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 151E518002C2;
	Wed, 27 Aug 2025 22:08:41 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3FB8130001A1;
	Wed, 27 Aug 2025 22:08:23 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v1 23/36] scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Thu, 28 Aug 2025 00:01:27 +0200
Message-ID: <20250827220141.262669-24-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 1EF5EC0005
X-Stat-Signature: 91mkae75dmaft3dgwye31f64hs6sjtia
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332530-380405
X-HE-Meta: U2FsdGVkX18AxuzSahPUfuNp/z5b50z5xpo6UbDEZKAwXX0W2GKtNHLEMvcXNoljKVHVg+veItH+3hSEiWn2lXuC7+PLXuib1kt+NUuw/LN2BaQFPXXRDmQQtmKQ333zIckFL+9yeDlYw1soUMNn3gM4JmtokccNJOKG2JmUrwLalBcpO/foQrUx3lHByuCYtNodn5uAzh7Wlh/fySUqiGGsebhUv3/vODLRv2e6OkpQL3UJcY9t5N0gL0pZMVbOw/bm8/M/h+Bnow+aTMnIPYIU0HdqZHLevL/Gv4ub1qKrlm8GBE23P0miKahZlO/da/wSXx72Q2+kBLRSpZ7DE6xRpjOgfv5huWaLR3cm+ukcSucKkb25LAxqz0gyIXr9oISo3UX9w4Ctvkfi9P4DWxRe8TeDhWOl6LSO2D74Sg8niL+50n0nRVcpg1cPH7XXE+2mSuPBecOJJcaQla5xnv21n8SyuWSHZjPOncW+2Fi5SZX8PZfGoilI/PdqTPHhVw2ivoA11kblOjbEbN4L9dyb8xoXL0gne6O9LsVTU0NyfVqf0CQGlw+iz8klMFlevcuX3U5+qigo9P1qrNE+4/0ZdjS/0V96o2XyhNKmxPDfS5G44R9gtE1sQDBYSqLCooovGTZXzRIiYNJgRuJDgr8pbwt1V5rS1TuqOpkzR9fmWMQ3GTl/y6t7AQRKVqC7dXfGcA6zIGAmHbkJUv1KF1kcVO3vgrZwN6hxVnvhaop0febW+GfnuT0ceGth5d3WdZMfKWJS2fRb3E2qS5cA+R8WmTBdlUjsLiN9//Z7keFxhYZK/fLDP2euzllz+LRuFq3BAh4NMngbqlLHh+Kkat0O3QGEXaquab1l1iDbwabv3itaOCxS954m1Brn3XHz7dbQAQQ7wTLj+vBqRnl2fPxHfJKOiYUe36XpWxw3guZrjA3p0cISpTqOwH9h9m4+nROrrf3l+2cJwDOK+ra
 MtE0joWK
 6GGlzVBTXEuh3FM8NJXhMptY3R8yltHuEUY4edhGKqWp5r0D9gpRN7i/UmpqXCaU455JdRlct6e1YsJ6MLjelzmTpI6oC9zZjzRyA5wGbQRTB9De4gLHwMt8swRUcjKibtcGojRTc9TjHBEUw7WwjnzVxYhvMBEf+QwGIm+B2F8O3EcF4tkDKKJGZXGh1Gv0IGIyzvje/cEJ4DYO1uJO763Sby+iGOJxdMz5yiarBMXKN93We+Zsj0fKqDcqiABkRcm7DydLjCqzzkLwb1phZr9Er9sDByOmEAsS5teAHtVqXTk/1JN/2W7Bk+WHAmulIc45ypnQPyu+1fQymQ4IqNlGx6ptmSQeRZyk4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The expectation is that there is currently no user that would pass in
non-contigous page ranges: no allocator, not even VMA, will hand these
out.

The only problematic part would be if someone would provide a range
obtained directly from memblock, or manually merge problematic ranges.
If we find such cases, we should fix them to create separate
SG entries.

Let's check in sg_set_page() that this is really the case. No need to
check in sg_set_folio(), as pages in a folio are guaranteed to be
contiguous. As sg_set_page() gets inlined into modules, we have to
export the page_range_contiguous() helper -- use EXPORT_SYMBOL, there is
nothing special about this helper such that we would want to enforce
GPL-only modules.

We can now drop the nth_page() usage in sg_page_iter_page().

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/scatterlist.h | 3 ++-
 mm/util.c                   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6f8a4965f9b98..29f6ceb98d74b 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -158,6 +158,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
 	sg_assign_page(sg, page);
 	sg->offset = offset;
 	sg->length = len;
@@ -600,7 +601,7 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return sg_page(piter->sg) + piter->sg_pgoffset;
 }
 
 /**
diff --git a/mm/util.c b/mm/util.c
index 0bf349b19b652..e8b9da6b13230 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1312,5 +1312,6 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
 			return false;
 	return true;
 }
+EXPORT_SYMBOL(page_range_contiguous);
 #endif
 #endif /* CONFIG_MMU */
-- 
2.50.1



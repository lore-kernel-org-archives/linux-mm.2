Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91AFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BFA8E007C; Mon,  1 Sep 2025 11:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3C98E0079; Mon,  1 Sep 2025 11:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8098F8E007C; Mon,  1 Sep 2025 11:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7037D8E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:07:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31DFFC08DD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:56 +0000 (UTC)
X-FDA: 83841011352.21.319599C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46DC210000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQJpyQOb;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NuKSd2ef5HwYax7pwu6yf7kwVuEbI8vaAEgix6O8kQ=;
	b=ImC4fkM2lqv0HUnDBtAIXZ6Ud5mmeqL6U5PdEJsjNC+UxA5jvh1q0fKceblaAp9fQycfnJ
	pF5nmmRR8v5jaW4mBQGnMHgq9n+ya9alU4StXw3wtzD/nuv3zmxrav1hvKbkDiaREGDQAo
	kCRAiRssp/cuFLqsmzwyMsGBqQ2NwYQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQJpyQOb;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739274; a=rsa-sha256;
	cv=none;
	b=RVmQSU7+xnbm95nMkOR1kDbptPJ+SAjssAtjARMYZp6rxaFujG2a7+S5gjGlPkpNvs5mqz
	DBW2HHGCDcoeUQZBXOznME+a8R9pTLc6SLsba5DP7RU5EYKSxTAX+0IdarevDeXDgyM/aD
	NM8IGNOhKNmGJGoc3xLGoi2ZrpwBZYA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NuKSd2ef5HwYax7pwu6yf7kwVuEbI8vaAEgix6O8kQ=;
	b=ZQJpyQObUJxaWjXo5fzeC3w0N+8D6/nsIxTjJ1w7t+5E4pgA2ufMn3gyf9YsgTjYQe8nz+
	laddLrcwVi5jYbLqiX+9MyVogN+ZhmXYda2eRgkxXKaTnmH5/pYlF8AqEM3QbQPVOWC7RG
	Hpxh/rKkLJGfrUFrhlSpMsCtggGOZ2M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-WXE1NSHDPjahq0Msave6uA-1; Mon,
 01 Sep 2025 11:07:49 -0400
X-MC-Unique: WXE1NSHDPjahq0Msave6uA-1
X-Mimecast-MFC-AGG-ID: WXE1NSHDPjahq0Msave6uA_1756739264
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34D8B195609E;
	Mon,  1 Sep 2025 15:07:44 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D513D18003FC;
	Mon,  1 Sep 2025 15:07:29 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>,
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
	x86@kernel.org
Subject: [PATCH v2 12/37] mm: simplify folio_page() and folio_page_idx()
Date: Mon,  1 Sep 2025 17:03:33 +0200
Message-ID: <20250901150359.867252-13-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 46DC210000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uxz1sis7otyn7yqc59g164narwxkzrk3
X-HE-Tag: 1756739274-950185
X-HE-Meta: U2FsdGVkX1+papm03d06SSzHztzDigmwBXNUGlQTk7QZh4m6ywTJG2PAZ73Vhb0JhobN6RbzqmSjMcbe0kvtjoQFperx9tZWEMvHyXFC0s6h/qG11hhE7OrebqxJU3DFZss+XuKsMNpoOEf3AaLywhvNaEXIvUClkefQAaXe0Y2n/mNr4HZSqSEKvSmlpVP/W4iBe5A7HPZr1X+qM98zeUmPJYGkACc/zIhP13apnROMO7Le3dklXVI6eCoBjHYq205ztq1gHWWFPJfaFl72tKjGtyyDcRQ6xIcRT6u73MDg7gFaBpJO6IWb+GHz99wpag/djQi2FjjykoNUGtRZBAMl4WrTOKdYtk/vkv9nC0awpPTVxn/6EMeYcWUtN1EVkbkglmEms2Yxwu2Rs65XCRWmY8R7zDYplXKZCEKO0WK20nU7OmOVp6lymhffq/fzY0YvT5iqo+eg3TNHP4SE9a/ZZWdu465imFP8KigUUUki1a9uKSVBDWd1WjQHSRy7pjUsAlaHLSwSrp3FM1rI+vsF7hB5kDePpOBs87RIurGwuOMz2QJmldb0k7nDp5lsOb271H0SEwaEs4UPiWwZX/CfhYxcdWNfySgomJbgNJk4OB/6jc18F4xuumG3R/8f+WyX/YY5I8ZafLbQdGjCfcaK4tBRV7ToXzQxtu5iucaNrI715gHOuJfHM6P7uKvHeTdjnorbFTRGb55oTEKbYjtQ8VyDAPQVtZgez/BSKVkBOGo31SrtQ1QYSMnRdHH9cVPgHnymIt3ITjKjCy6lL875W+lZ87yOITB0GKmq0/dDmeaW9hybkt0jD9iSoFwOwto+9Ea9g48ANG7w9w0QNcbLiDQTATpQ3I1t+mn/RJEHoSOfloS76Al5anaFnVE0m8qzM//EeYVZf/RLuXG+EN/1e6xsdMWb6fuD+Ft5hOTDPi4SjKIu5MyxGwelZ0AbsU5HO3EqxdJ57qJtK1q
 FLU5GeVq
 Jb26YT83z1L7SbvGAXTw9po/fqg2ScbVGzb2SAVnb+wCGIP/jLkk8seUVhfzm1D0GZqhEX3b+tqQ5dg5Bx2CY1OClJB1sJPEjrwWAKsxRMuWV0m5a31pp1Y5W7ATAcp4WeNS2y/iv+7MBbke2mRfz+46ltQTna2Rn2o6q+y7BDiWnHepqITWTLrW37aJxiFLWgOV1PGkMyQvusy9C19M+B4PbYKvknLF0EJj+tsfrrwbClm3y9MRuFvp2HkIghhUXdQrJmpHgvuaE3BgcXtjVdzOBboTOgA/jzSWl+4U8pbtwr88fiLuUBml1GxQzW+OZpkbro8lHuX07jSgta3yfpgbs3NnVOjVPJLBnsxVJSryiVEvl8fEQN/NM9JqYn7cQkNhucuyrjavZ9zWUyPFfcLxK2RfaDU+MCzk5tlm4ALyXyarS+zSbFU3V4vc0D+V00RZs6q8xLedkk6xElFv1b+IR+XVoYFMR0Y9bHrEp/fecLIoMrPxNAmukk3QhuJ1xPWRQuJFgaegnuas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that a single folio/compound page can no longer span memory sections
in problematic kernel configurations, we can stop using nth_page() in
folio_page() and folio_page_idx().

While at it, turn both macros into static inline functions and add
kernel doc for folio_page_idx().

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h         | 16 ++++++++++++++--
 include/linux/page-flags.h |  5 ++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2dee79fa2efcf..f6880e3225c5c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
-#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
 #else
 #define nth_page(page,n) ((page) + (n))
-#define folio_page_idx(folio, p)	((p) - &(folio)->page)
 #endif
 
 /* to align the pointer to the (next) page boundary */
@@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
+/**
+ * folio_page_idx - Return the number of a page in a folio.
+ * @folio: The folio.
+ * @page: The folio page.
+ *
+ * This function expects that the page is actually part of the folio.
+ * The returned number is relative to the start of the folio.
+ */
+static inline unsigned long folio_page_idx(const struct folio *folio,
+		const struct page *page)
+{
+	return page - &folio->page;
+}
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5ee6ffbdbf831..faf17ca211b4f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
+static inline struct page *folio_page(struct folio *folio, unsigned long n)
+{
+	return &folio->page + n;
+}
 
 static __always_inline int PageTail(const struct page *page)
 {
-- 
2.50.1



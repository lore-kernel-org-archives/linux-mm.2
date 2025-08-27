Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56BDCA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56838E0017; Wed, 27 Aug 2025 18:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2DE98E0001; Wed, 27 Aug 2025 18:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43C08E0017; Wed, 27 Aug 2025 18:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3E328E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:08:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6605D13A276
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:04 +0000 (UTC)
X-FDA: 83823926088.16.A13EE88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 978C6180008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjuSSCfF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332482; a=rsa-sha256;
	cv=none;
	b=WmDF07XSxPoptdCiueCutA6qnW6mpBJSDXB5yEYm1IaN42al7OQ0xRWDG+oImLAgz8snJ9
	EOM+iHQtmz+LoEhrWK5YWLwXSrLjimCx23OEKj5OPbcaeAp9rtwz2afUyzeu5UgGe7UkON
	T+9U39bTaWi55iZK9/qOsJ/1SN5z6so=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjuSSCfF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZA4z8X3DBAGYUxj/2WGnSPhW3B2O9Q5Mn2y+SAGx1Y=;
	b=bMFhnJA3dhcin9mfA9tRERKOErKVcttxRwQtn9jzJzDwEVzp85lFZYNWprK7lkZwWiaqnS
	ByP0HXhpLwwBMJPOGflWIMarpmBlXTe0il+KPUlPnUulPWKrOX8Qoe+KikEOUsVluKJUJd
	vrjNHcj/vXWu0NMeSpJUaf5OutGYaqI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZA4z8X3DBAGYUxj/2WGnSPhW3B2O9Q5Mn2y+SAGx1Y=;
	b=UjuSSCfFuOEDfrugthg3ahDOiJlekAZm3SrBDV8yMf1VytV+CQmclpXDg1jwRKNLM0NWvf
	fd9c7ZlRDAiTN6Wv8pzZm5FPAFdP+5TAhGup0cWsIzPkarpvxOEi0QUlrXMXqaC7vPe6F+
	58ZLf5owkSE8WTHpNp8pSz1pUPCsg48=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-9CODWK8aMK6h5vL0lOzKFQ-1; Wed,
 27 Aug 2025 18:07:57 -0400
X-MC-Unique: 9CODWK8aMK6h5vL0lOzKFQ-1
X-Mimecast-MFC-AGG-ID: 9CODWK8aMK6h5vL0lOzKFQ_1756332470
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD5F5195608A;
	Wed, 27 Aug 2025 22:07:50 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7867C30001A1;
	Wed, 27 Aug 2025 22:07:34 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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
Subject: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
Date: Thu, 28 Aug 2025 00:01:24 +0200
Message-ID: <20250827220141.262669-21-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 978C6180008
X-Stat-Signature: e39uc3g8pj3rftbfb47qdfhht6zonqxg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332482-148143
X-HE-Meta: U2FsdGVkX19AQpuron9yWYo5f8H137hS/LosCZAq1Ii6FcRwPQPdK4+qvPYPZAi62l4ADpTaljDV0Liw04KCGnmO0OsgGOBWAXfwEWnJA9QizKlC+GExCaWJwObOTkv11jcvNueeeJksBQJyUJfSSgWimKAKPaK2bApz75Pi7EjAkSROYP/jsmhprczqGHumhhlOv1lOKIHm2yHi0YycISLH//pHTJrzFlVMDN2p8BU7pZNy7bvNiEVEsdkFjiTUAqp0QUWhvZ0OGCn3iJCpLmumGOFf7dc/SH43nkyqzqjwZSpMYpTBIj8KrnYGRypS/cuZErD6UJAhZW9MX6OSn5DtYdBB/uEPS/klskujOhEcjo3pvLcNVCvmAC5DXKEvOpWPnYbob6iUlyPVBlUC25xaSoLHKnhJ/RIWgZ4eFktAnu+8nIGZ8bCbSoqpx4dmX+ee6A5W1dabpJ3XDFCUTr0KlEDhxo8vQ5rcGyyrwT9T64IHFjxiY6TtKdgxSJx9aH29S/6Mp2xyOL9w50nKWafMsUzietLIoQnP9tb3zrS2IjYVuHCUmiZ9LQP6tSsNsR37fkwR0kgcP4xvmutRqIAIDPTfMWGsAEx7wcbueC4wdHCCh7OqpUskep3GN8uw/yKjkVVkRiFyXsgjwcUk1UFPfE5QnbwbyRlaYIUElNTwim/+psSprb84v1rjb4/xJtoFvE3j1ka8IB3a2UWIrNNKIpImYX0oAfr/YNW7aoroietMvV++zEbV1QQPXiDTbDbD7GW8bo/JoLBeCkRiot2LL7lX86P2JWr8yyHP/XZBqaj3kST/v5qMyzimokne2O+21Ltbxe+XHfEL7yEQlOd8U2/G22MfwjQRT+SIVFesdfewTHSOeJEf1Nzc7KSTQhPT3waBwtCK0+cxz7BkUNTgQHK1d0g3uiCA+J4BiCYFYlxBzrDtsiHyBizZNDGB2hvfvCweiBWE5OZVxhU
 zwTs0WXh
 HsIwRY8g7stgL+JpEERQLApzhZBbSi/1uJGTER4lQ/Rj5LLrzPELXsxwySlzebhut9LekQ0gU/rK+8mP0guxcNuk2C7T/swO3E5aAT4lDEjafWHSMzSxOOsaKm2vFG1pBes9ORGx4F9h0M8VZyfeBH50xMt2o+KsGb9O7uK4Zt3xxxrkXvQrDoWXiAKUpCS3IquLQyBzvh0daQozmNaiRxveZLpgQUDK3AfR9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's make it clearer that we are operating within a single folio by
providing both the folio and the page.

This implies that for flush_dcache_folio() we'll now avoid one more
page->folio lookup, and that we can safely drop the "nth_page" usage.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/mips/include/asm/cacheflush.h | 11 +++++++----
 arch/mips/mm/cache.c               |  8 ++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index 5d283ef89d90d..8d79bfc687d21 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
 extern void (*flush_cache_range)(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end);
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
-extern void __flush_dcache_pages(struct page *page, unsigned int nr);
+extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_folio(struct folio *folio)
 {
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
+		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
+					   folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
 		folio_set_dcache_dirty(folio);
 }
@@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
 
 static inline void flush_dcache_page(struct page *page)
 {
+	struct folio *folio = page_folio(page);
+
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(page, 1);
+		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
-		folio_set_dcache_dirty(page_folio(page));
+		folio_set_dcache_dirty(folio);
 }
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index bf9a37c60e9f0..e3b4224c9a406 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -99,9 +99,9 @@ SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, bytes,
 	return 0;
 }
 
-void __flush_dcache_pages(struct page *page, unsigned int nr)
+void __flush_dcache_folio_pages(struct folio *folio, struct page *page,
+		unsigned int nr)
 {
-	struct folio *folio = page_folio(page);
 	struct address_space *mapping = folio_flush_mapping(folio);
 	unsigned long addr;
 	unsigned int i;
@@ -117,12 +117,12 @@ void __flush_dcache_pages(struct page *page, unsigned int nr)
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(nth_page(page, i));
+		addr = (unsigned long)kmap_local_page(page + i);
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
 }
-EXPORT_SYMBOL(__flush_dcache_pages);
+EXPORT_SYMBOL(__flush_dcache_folio_pages);
 
 void __flush_anon_page(struct page *page, unsigned long vmaddr)
 {
-- 
2.50.1



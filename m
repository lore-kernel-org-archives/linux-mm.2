Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4A2CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CF78E0086; Mon,  1 Sep 2025 11:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CFF8E0084; Mon,  1 Sep 2025 11:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C108E0086; Mon,  1 Sep 2025 11:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B39F8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:10:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CCD31608C4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:55 +0000 (UTC)
X-FDA: 83841018870.15.0A57B4A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5E13640007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P5ew8bq8;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739453; a=rsa-sha256;
	cv=none;
	b=DLfoBrdiQ1oofXPqqlTamWw/pRbqUjqJy5Mc8qhjfMAzMec/DygWrV4dnp4cQ9lsc4Wfo2
	VRHXAP0sKUV9STqMGpe0LOkjOVK1TrhkImmC+jTTrZ9+vnNAX3zrI/ZkW6wpsnzlUduAbU
	teTsfNSzlNjtDvBfOKvtKvh2CaWeKds=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P5ew8bq8;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i06htfFlQWUPNnzacoxmjdCfJTHM/jIyMh7+2RAfHF4=;
	b=hF53ESMN9Ao8PzQfL90lQ+yGUlmDSL644Ie3TI3mwRARoZN8bGbOfeeidt/Cqb74cWr4iV
	YMi/rPQeDWbClMXhRXxYSurugOHgniBYdbtBYmOBzIIdZloaKGz5F0rPNu4p7rudLhS78A
	/xkr2rFssr52qj6z6Xin/XjeUrSVUEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i06htfFlQWUPNnzacoxmjdCfJTHM/jIyMh7+2RAfHF4=;
	b=P5ew8bq8bwh6PnsSq1ADRNQkH30XgJBoxPDkep9a54z9fdGbleDriVcJ5uyIAknweUbSPV
	9uorE3bXJBu3gPuW/Bcolaj9SDCo1vF5NmvlkpMFZCbunMfZCd+vc3LxseVstbMUblyGlY
	aO5fuKDCqhWzI2N+t8gsPWFUlPgw5z0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-mPsifsa5O0-R1fp0Ep7F3g-1; Mon,
 01 Sep 2025 11:10:49 -0400
X-MC-Unique: mPsifsa5O0-R1fp0Ep7F3g-1
X-Mimecast-MFC-AGG-ID: mPsifsa5O0-R1fp0Ep7F3g_1756739444
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F20F19560B2;
	Mon,  1 Sep 2025 15:10:44 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AB8A1800280;
	Mon,  1 Sep 2025 15:10:29 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: [PATCH v2 24/37] scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Mon,  1 Sep 2025 17:03:45 +0200
Message-ID: <20250901150359.867252-25-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E13640007
X-Stat-Signature: emy9453y9nfu1pn68sebkxuggjzykrbc
X-Rspam-User: 
X-HE-Tag: 1756739453-497055
X-HE-Meta: U2FsdGVkX1+FAsyttljg6uR5SXV9QoPv6DQONG/n/1UjY2/23QD6gkVztoIkTLan+Yar5D2W6BI6hQqZ1yT3UB0rghK/pxu9Rx9SmncEBR4oq5jFjaZmMYNfA0sdFhE5/g6DEwWzaKDVUScnQPFcKfJtfau0/UGmCMiTkwEEWf+CnlQp0TbQGw7lXp+yUpXJUtw7H3BYF+fV91xhJ/at+krOQ9Ut6UOZPqdGk4M7xSg8D42xeP8JeWkVDnXIdEC2R2rIOfIwPSe5GQF/rBkBn9G59owgzi171GauvSYpCwQ9vuxuH6cNK9/IRdbHc9oYbkWRrzh/BArgLDgpOmoKGP8Gpz1IN0dKMwplWzdSAb+2G9pmz4NiAarIEfGHkh81GirPgMRn2GeZSYShR41zHw4qOCO/znS00jEvolbGSdpVsY2XV3Z8Th6Br3YjMhIwz7mgJ8ojnmiE3phoyi7AownW3rfgJUt647dgl8GOQseMDhW86u8Kf1IQDo+FCdiKZoP5heV1d/ov0a4tfD31khc0uzqL/mB9beUk3ItDOmLuyRnxH52gSKD1X3tyHw2p8a5Pj2VB63NxRrLqmfCVWTmvswGNDLnaA1SEKk/dU8Vp+IUNO6N31CNDUZcxYfsIQcJI6bhmJ5nRKg3CnYTmM9hbew6HEvG4C3Z3qWi25fUWv+5EwdIT7cXcwQ0ggjSIY6oAjMsNOFqbT4FR8ELo6l4RsQWeIiI5oypFHeB0lwSlcumsAD8pVfkBmvxlvYgKR49+T9MkMeyX+CS7liOKaW5wCi8oMgaIJIunX9d+LQnfQc8/P7YxxIg8LeRBWLY8FfTOTBVjBFbgAypwpMRpqtG9bX9JROK2yZIU8Bz7xkBvwQ4JlxM9pDqrFfyHtuu6l8T44jbSAEhl5BhETIpESnEzkkp+4gbp24NFwzSbVMXLwAtQrDIoTo8g999W2QixmGP4pmQMpE95nHYK5Js
 +8uBYcYx
 V5RypJmWzIR1ZzQQBKqXUhaxQbNCJQwL2H/OaEPtb30aCxgaBcPH2rPLNQRqMogsPzR2yehAngzCckz6YLLlKsmPEWfpHj+JoiTzpE5RlGrlyksbPs2h/FEFGGNiaDaowIFCAtvN91yI4cZc5VPgfJ8d/TxstbU/Fi21QO9mnCuhPdep/61EXnBl7r2XfOi6kO9oM07PriAfazHzZx8Uw25U1rqHYS7GD+NqpUsJc4IZwb2+9pyDprnKWHQQwp25q+xgyUc1n6YRV27RfyCtckQOZggaXLBdIpMZZdx+iVvC+78DYYrsBKsz9+x2z0WLoVnXqudiZLRo/9LpT7lNdk71ufLSg7ylzz78IQtJJqF8zFUOfouW91Q4Wdrw+Qxq/AmIl
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
index fbdb73aaf35fe..bb4b47cd67091 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1314,5 +1314,6 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
 			return false;
 	return true;
 }
+EXPORT_SYMBOL(page_range_contiguous);
 #endif
 #endif /* CONFIG_MMU */
-- 
2.50.1



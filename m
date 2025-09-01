Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16ADBCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D31A8E0093; Mon,  1 Sep 2025 11:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383218E0084; Mon,  1 Sep 2025 11:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272738E0093; Mon,  1 Sep 2025 11:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 130F88E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:13:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D356786076
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:54 +0000 (UTC)
X-FDA: 83841026388.17.24259BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E0131C0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OxoSLMzR;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739633; a=rsa-sha256;
	cv=none;
	b=keaH9Y/crWYmYoDEgam9+e94OhLx2zeSst+43KbWlLk43GVtewo5bJZEJZZJp0t4qSON1A
	nfmybKDMihzcW3Wp/Mrld2hjbmkfuIF1mcpcgaYtVfoRUCK1RR2XwtdvUOHSjLUiuhxAyw
	ggf14rmuC0BnmEeLeXQ5f8cNHZLi8sg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OxoSLMzR;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkEShtyZMAsDf/J3X4vsiABth2SEec0fiHHSpv4k9x8=;
	b=MExkhEo+ypBde7mQ2LXu0c9wGczxNHu4LmFMvvDwkdE/ar0hhlpuXGhwq/RtABI0CTZLTq
	uaqGdJiGs/t+SC1IT2+d4yajPgX8PZG9DnEP4YBteSPtX3WmtJ17ij8a32DjwZUYVY41Ys
	StBzPszObcWMXsBGJkUrUYjBThQhU6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jkEShtyZMAsDf/J3X4vsiABth2SEec0fiHHSpv4k9x8=;
	b=OxoSLMzR1tAQOOaJBKJCGiRWZpKekXfZQtFRVT/c+gEHIZ1de8824iRwCzX82claSV0zsA
	1D8sGLEHiCBwYcs+s7Sfwg8N0YKD1klktmBLAn/EErIjOxpf0oYMAhkU20Oy7BATXUXT1d
	WeUh+KglUSmgbOMpa2VQ7UcbsgGIUAQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-o2-TD6CtMRuqF-LwyESxUQ-1; Mon,
 01 Sep 2025 11:13:51 -0400
X-MC-Unique: o2-TD6CtMRuqF-LwyESxUQ-1
X-Mimecast-MFC-AGG-ID: o2-TD6CtMRuqF-LwyESxUQ_1756739625
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DA9F1800561;
	Mon,  1 Sep 2025 15:13:45 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF9891800447;
	Mon,  1 Sep 2025 15:13:30 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marco Elver <elver@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
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
Subject: [PATCH v2 35/37] kfence: drop nth_page() usage
Date: Mon,  1 Sep 2025 17:03:56 +0200
Message-ID: <20250901150359.867252-36-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E0131C0003
X-Stat-Signature: o7o3atxxba1b334jt9is5z9nnnrxzyoe
X-Rspam-User: 
X-HE-Tag: 1756739632-405339
X-HE-Meta: U2FsdGVkX1/RZeHjcJrpjDTtOoBEHfugnGUWnZL2rEjHq9mupu51wcTMiotwNtr1aYDskB94J3e9TmSsuTCB3Na/xFLtgjWJ6N8Ib1yveITNtEkLWs8YJ+34n2AP6kjLAd7AIva6hIAwWYDl2P2vkAllfEFQzKpUr5gIMh8UYzHqwl8bjzv+Ndl//9ZLy3hXtM/li1J7wXL1tSkeDWqMX6GwkBLpHz9s55juhJXx2Ak1hzAkm2IGpxfMKaFLfIc+ZKTbsGYkgSvYd83tGF/g1nlw2kYfs/UxNgCq0h6A72cvOXzgPRggmu/7mZ3buBng8GXGQrKrWs9+y8z782GN22gPubIqtKE3B2fLwvxhKrTquLSL7vrN6FT6jWuJjNMjDIEAHvPKU7V9mBQY6J+1KuuuY+xOuFXEqgwu06fhnhNhVBge8EHXNtT+NgTVBSRBxrYoI+yt2j65jUCdWSCHzzloDCicFUghqqsT4rB2nCCtUqYmdzURxBudb2ct7TmWSG9vVohU+5ULiAflUnTTxCe4MtecPtH3rQ0Mn2YytW/qVHpp75U8l3nKlyEmAt9SzrEDxiyODCIJgpr6wXAZzmoJ0ckRxDs63Rk/RUGtFkQgu5STwgghKOejwP7BQT4gBV72Hs7tT2rW2+DD2dQHI2MLH2cZRGfk6lZV6Jw3emUzNmnEuJ+K2tsmKzcgxZr8QozUU0lPiqMxi7yOrZMiEPsRRq8qyBKemCzWqFZt52Yx3BQOyddmYjihNJ9yhBv+X3E3pC5avfep9AGaj4qX95sDeTXzKR/IlGyfme+By8Mvr4VfiRlJk9D3Q5s/U4CiCO9bQFRNFWUDGTpy+hUPRLdXZibfNk/3/67UJTE3XM/zUHL/6FMVzV8tVaz/mLwSrpOJd7Ij1mpremLAquCtkqEOwrM5aKdf6F/wECGUnM/TuD5sJhZ7I/p6R8CjU5kOeGYr93TPcfH61G9Z4zO
 5ReZ6+DM
 /kXLFhPLj3R+eqczCM/80kFGbfiuEfq9JC2KVgl1SrdiQVEcno46rH4b4QeLZlZA3Qt3tPCP3bDNacIXouY0i4jEP/aefZImXY2Ue82ZfYzv/QWwOdGLNiFBj/FHgHmuLW4Y3z5kQrK5yqUaNeuZ0GTgGLOLhy/NrANBvfvROlEGLvAifElJezJSdAA/LqIw9TOSDBorTqsXtCJVw5OUTGlA3Xd3elWL/PDWHbPM/DdHDRDQT1NedMlwQYxBkfUiqikYqtX10PnqgL6gsmX6M/HgYAx3XfSOcShQRUzRZhAME+quNSt5hScr0yGV7S78ztgTyWhsZSQ9pNCAAumV0zDPa84xcLk3Sx0MlL5VqzfIXXMUfekLzfexgxwaxQsElY3UgKc+HY/N15Erm3YMVXoJA2kHN7nMarxko9KvCUilsgbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to get rid of nth_page(), and kfence init code is the last user.

Unfortunately, we might actually walk a PFN range where the pages are
not contiguous, because we might be allocating an area from memblock
that could span memory sections in problematic kernel configs (SPARSEMEM
without SPARSEMEM_VMEMMAP).

We could check whether the page range is contiguous
using page_range_contiguous() and failing kfence init, or making kfence
incompatible these problemtic kernel configs.

Let's keep it simple and simply use pfn_to_page() by iterating PFNs.

Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/kfence/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0ed3be100963a..727c20c94ac59 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -594,15 +594,14 @@ static void rcu_guarded_free(struct rcu_head *h)
  */
 static unsigned long kfence_init_pool(void)
 {
-	unsigned long addr;
-	struct page *pages;
+	unsigned long addr, start_pfn;
 	int i;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
 
 	addr = (unsigned long)__kfence_pool;
-	pages = virt_to_page(__kfence_pool);
+	start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
 
 	/*
 	 * Set up object pages: they must have PGTY_slab set to avoid freeing
@@ -613,11 +612,12 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
+		slab = page_slab(pfn_to_page(start_pfn + i));
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
@@ -665,10 +665,12 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+
+		slab = page_slab(pfn_to_page(start_pfn + i));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-- 
2.50.1



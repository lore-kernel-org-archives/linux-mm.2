Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E75FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3074A6B009B; Wed, 27 Aug 2025 18:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DDC66B009D; Wed, 27 Aug 2025 18:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3DB6B009E; Wed, 27 Aug 2025 18:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8556B009B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:05:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C972F1408B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:38 +0000 (UTC)
X-FDA: 83823919956.26.E682382
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A3A21C0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jIXcw4cW;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332337; a=rsa-sha256;
	cv=none;
	b=kZ/IMVzSv+6w4WocIgyEfUWYndvdisGxj0TiVcgiqFxSdMTWehJzZKj4zgSS8PH4tkE0/w
	1qbrvX6Ym0GxnX6/l6yVgwqId7orzaOtkLuoaVt7JzhucNb0sCPzpD35lp3qgz7RSMswKP
	iJA/jgkxaeOlx2baOXoMusOH1+OwBpM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jIXcw4cW;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEIm/KOIpGpHTKl4mPR/fyxdpTiNWERCnfvCZDPI4mo=;
	b=WgTRHWfyXdLRvUO1h2PH0RZyZ6VLcUNbm+rAf1JLS7Z5+irK8F1zPmnQPA1jQM2FXz0lbr
	xhiGAZb9oXqeaeIIX0zX95IPXLnS8xAw0JGvJzDygICpL14958h7UVzZlibfLOLuHEIhzw
	gAoD/MnRbehHGftAoo7SQXpUj2ZHcXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEIm/KOIpGpHTKl4mPR/fyxdpTiNWERCnfvCZDPI4mo=;
	b=jIXcw4cWi1wwFJqd36/mD71tU57lcwyvh+STDkUzyP+dv2bEcNJp4yZC952UwYR84K+HKo
	0h6Urknos1I6F+bWx9aFOZ8D1rdk79gNDSQv1ctK3FqmADnOMJRs7JerF73zM6Lg5q/mO0
	LgI5Ymk0kw1fDmwTEOQ8WHwbchRp1jo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-fC3PEug1PNexc7Z1HEH41g-1; Wed,
 27 Aug 2025 18:05:31 -0400
X-MC-Unique: fC3PEug1PNexc7Z1HEH41g-1
X-Mimecast-MFC-AGG-ID: fC3PEug1PNexc7Z1HEH41g_1756332326
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E647180048E;
	Wed, 27 Aug 2025 22:05:26 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6585F30001A1;
	Wed, 27 Aug 2025 22:05:10 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
Subject: [PATCH v1 11/36] mm: limit folio/compound page sizes in problematic kernel configs
Date: Thu, 28 Aug 2025 00:01:15 +0200
Message-ID: <20250827220141.262669-12-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A3A21C0006
X-Stat-Signature: 36x58tu487dcxb8smj49agngyx88oapz
X-Rspam-User: 
X-HE-Tag: 1756332336-112715
X-HE-Meta: U2FsdGVkX1+Jb0z/5OZRdO6CK1urZd2L66ESBZ/emjDxGUKUDIbl269qgr3fAfxkh4u/meEcF0OfyLhyvmoCubwy+QuhLRaiVviRLWWLExaI3vBg4YMEvKpi3Uf2ikm5m81ds5Cqrx2t5QaVD6XRktDS36+j4MtEXOplOc/WpLbbkoVbpGhkQJbUSSD/3i+Su3+buvbtRUvPkhT3ZyuIvtDky0CD6d8HWVS1kWRRpygy42pYNz5MnKYhvH7YbM3mtfk5VNWi3j6bkuPTakD6Yatm5UqKfStu1iIpEiBlHc3CZ93R/9SqvdDj6mTkj4PsZUBNiruDf+kCA64Hiaw5lle42T3zkrtKgea8uIqjKFieTn1thAZi56/VRlaCYpAOU23+s/yPQMqVwOjoGl61wVPn4BUTn7K/6TFoYrzM6uro8hv4aAMPezwyoInl6SAZOj3//E4ClGisNHZvFScDGZD4FaxquhO2yKBSQ7Y1p616L41xBx6F0A8BV2LKydx5EJ1KlwoPcIMZnzlonsKW1ef78WbpjcM9zG6cFM0VeSBwUBaexLVENmGqtPOufZuYwKa+6X8290vOkV8Mevn2RPq9QdcYQInd992NRL+EP7hzkXkSyA4c+MtfTWEw46s7X0bkAItuqdbmiStwgayfAU2YkUW8LxK860OEXBPuGN6B2fzfQy6s3pQ3kejg36/0o9ALO27xR2NNtqnjNglfVv/6XTahPR/cV6+H+6xzXZ6VaMWCgFqG/3fUzQrTulAUMImjn5S8tTsQ4+Tk4mgf6ry1BRB9tzZbnZ/IsqiGH6N8Td2QKCt3lqvX7DkyWXTgxtHF8dE79m+WcOTjDHHyqSdADwbUOGuYaYeNqbH1lRDKUEHsXxzTyIn9oz8WlG+hBwMwwL6YFR9WwUNVbHfn4UY41VVSFui8QwwhrXcD8Zb/Po+XnKAjV/BfKsRyTr1bWPjh3pfHWTCOA+yi4Uc
 dX9rNLrF
 9rDoE/GErs+PY4wfaT8DD5K701Tl3wJDf9shwCmAtisjn5xV46zzSjEHcOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's limit the maximum folio size in problematic kernel config where
the memmap is allocated per memory section (SPARSEMEM without
SPARSEMEM_VMEMMAP) to a single memory section.

Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
but not SPARSEMEM_VMEMMAP: sh.

Fortunately, the biggest hugetlb size sh supports is 64 MiB
(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
(SECTION_SIZE_BITS == 26), so their use case is not degraded.

As folios and memory sections are naturally aligned to their order-2 size
in memory, consequently a single folio can no longer span multiple memory
sections on these problematic kernel configs.

nth_page() is no longer required when operating within a single compound
page / folio.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77737cbf2216a..2dee79fa2efcf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#else
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#else
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (e.g., hugetlb, dax).
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-- 
2.50.1



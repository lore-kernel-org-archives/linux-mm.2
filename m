Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA69CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ACE6B009E; Wed, 20 May 2026 18:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7622A6B009F; Wed, 20 May 2026 18:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651066B00CC; Wed, 20 May 2026 18:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55FD26B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0C2C160E50
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:28 +0000 (UTC)
X-FDA: 84789225696.22.D478DB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id AA99D180006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGHak+2D;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vz+PjXrtbljoW8SfvrGsI8KrTf/iN/5SV/3uQ1i74A=;
	b=v2Tyilp2CJem9d0yMv3S27TWWWnlVQ9phio6sBkHVIEbfMscR70E2hiAkFbHafc5I+kmiI
	WizPwDkvnh/dLYrB8p7uWRFm8MWN1qE/3JuydnZo1PrtgVOPn0uNBEk8PaubvERUHOmgcq
	Bp5DhFmKeUZszBxmyrWkBCwGlnNtHYo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGHak+2D;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315806; a=rsa-sha256;
	cv=none;
	b=1EQOW0Ka7HOBCjQdNoHp+io9QcOtXoAwv/YcizJaREUW8Z5HWgTUVQ94/Bd4MGFrvbIaZj
	UZbquj8cpxFj+8VByzcDYvnrGsKEZDdGitbL//1EPA5MA36A/r0RHLl1IJ7A9PESio20++
	K4SKNhTAossMjG6/eK4zP3rlroAl/qw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vz+PjXrtbljoW8SfvrGsI8KrTf/iN/5SV/3uQ1i74A=;
	b=VGHak+2DCD3M5vDUfGSi+2F3C7AXMXT9QzBSZxzKVEkUEAQHq5HobX9BsGRH5MRpBCRQz7
	89Ixg0pwr+o9ZKRWGMq27VcbS46SWlksIWfKgmieJENY4/W3R0JVhh1xYd0tUHsesJ/35f
	n5sbYMyaMBkiKN7KFkGL/E6SSX5lIoU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-UeuXCp14O-akYIU7lBQQLQ-1; Wed, 20 May 2026 18:23:24 -0400
X-MC-Unique: UeuXCp14O-akYIU7lBQQLQ-1
X-Mimecast-MFC-AGG-ID: UeuXCp14O-akYIU7lBQQLQ_1779315804
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4497a0e3acaso5150656f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315803; x=1779920603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vz+PjXrtbljoW8SfvrGsI8KrTf/iN/5SV/3uQ1i74A=;
        b=goqOn44JrN21PLdE2Z133ci6JgiEBuFNRO/JiBJdC0Jm05LzR92v2JWNYnJzQDDZkR
         aNoebEdW9zrhyzjBeoCraPebefQJpGj5Ii1fZMIXGIazL/alKkzNR7DyGvHsZnAM20to
         AKjKSNUS/4YeuYx7FDbkkCQjQ4+zsJL3iHSvlts7DRdFs27OISVk6ksmHBiAu2f9qzl/
         nzfiVx4vQs8WnFCgyx8jXxdpeu/Y/bhgvUzAaDh0AM1uJLRfx+C1x3DkbTxR+u1JdeP6
         SxW0vrQ3Us75IGszmMTx0e5nHp77VCvJICEf2ofTu8nuFr8/VSKuUw6PwoCssX5M7mSI
         i1oQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Ny0j3i467387jKPoCuBfZ36gn52rTrawg2BWbJ3XiKXTorrXy5NZHvG6TSyuz/5VNwiR4rA2T7Q==@kvack.org
X-Gm-Message-State: AOJu0YzgPHncsdWnRZzBZ2wtBGNmWG6/Nw7Z+jUuz5Rfaa3MmvBo0lqq
	SY3769EKHV8ka3lkUxgKlKvn/ItUGbvTFBF5xUBQAxK2IYyvJwkXOD+Ga94Q1o/zysYfEI8L4jW
	rr5ykd1rJ8CdzgSl8qPWX0ZGsUc/ORZauvJKgaAHReUfQueCYXntN
X-Gm-Gg: Acq92OH7g6ecBs/fMR3FN1x3aZgGPAIjU0yxBQLem9IPTyEOquE692qTXz2N4lV01dl
	J77Az6q2o8exY1yg0qAdCDL1Sc0kWw1IjW6cqroTp0I9ZMMNpFdZ2gtbvEci+geUXk0QUt8K/qA
	f2Uv5pDk9umZatQf8sFN0EyioWdCUKeyGVj+Apw8cNdEBcQGCxdBQO5ixSnB9xqsDMJsV4UNMVu
	aY32AFSPvYnlll6ZtEfc6etBzVmUtBOepKRPR73t1r4VJOXAVXFQCywywZY4gzs6w+Qqo57GcFQ
	NIU+dnH/9nXfZ1HCsQKoRcIxWQ+58bjR/oyJiu994S1/co4bWcWyrbbBL7aHOzRCeMrLn8kOuTX
	8Iri9hRw2bR5oT5zUIVVPpyQ4c842qFtrBSiINFO+Mqg=
X-Received: by 2002:a05:6000:2089:b0:43d:73de:abd2 with SMTP id ffacd0b85a97d-45ea3ae8801mr287883f8f.26.1779315803459;
        Wed, 20 May 2026 15:23:23 -0700 (PDT)
X-Received: by 2002:a05:6000:2089:b0:43d:73de:abd2 with SMTP id ffacd0b85a97d-45ea3ae8801mr287814f8f.26.1779315802825;
        Wed, 20 May 2026 15:23:22 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2ffdfsm53030712f8f.15.2026.05.20.15.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:22 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:18 -0400
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
Subject: [PATCH v8 33/37] mm: add free_frozen_pages_zeroed
Message-ID: <321e9f1a5a15a80dfb25a9b8aa76657ce27b2b2d.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bWBB2nf132QdMpn0yb-1jzsQP9O_vPpJT82wbgm3Bg0_1779315804
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: tdtfaoanz5kiti7ict9awzpjgfhn9gga
X-Rspamd-Queue-Id: AA99D180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779315806-961786
X-HE-Meta: U2FsdGVkX1+sFgYV46bl7uuCWaLC13Tv/6obuHoOne+Q1go0VKCF0l7aX742Ai0qhnwGnvngaSMYJPgHsQ4dACF+YQzisgHL3QyPC0N+LDukOzQe/xJOATE4fG71dURLyELZ3yGb/cow1Y5jrKNTPMex15yd4kmW6nDGEJrrb1KTY7ED5TWfE2bp2QdpNOUm6/xDxTPZ6V2Y107MOqgPQQBQOW2fUj9AHxf7AY9Qo1jkRK+4euysku8SiiQicEiiKUwwRscZtrDuGjxZzAnZnMVVoaviOcY6HJIT0aHse7ugin8ohS/isyJR6qqklr97Q2S30evZFC1JZKd9M6KQAqNpcGV7ika2mPvFvAFooB3HdWr+PJVJ5Ik72d9ClD/aEOj9BfBI+ChJRQNXYnO7s5OXqs61ZcO5AeiG700ICLZp5JZJ9zCdI7Lrj9xQmtE4xv4GFU1HboayLLI6IZtD/GMTQFz2nuOlFrwdSdpr7CU4Hlr/1Mib/zJXbVH16BrQ+2Jmd0679YwkZX+a2foof2Ru/+JrOkpnOaAAfs+bgajZQRryg41jYzbG8e0aFw1rlm4nbr1da8tcEYO7oJKpxr3XqqOzvzPh93mGKXHOO83+2myVM0/B7sB9FPm2jgHtVaPX1BdyA3n4/5UmNykdWlNg6RXRZLL9JJtqZzS7lD1QXhkZAaxCRjqbGb9nC/KUfyCjXyQJCl6SgXoO4poIehPfj+xz73sgBmZfqOKeZJalXWkPDh5u0Sc/lUPTsiyVFtKglfABrymqztyEI7/A6SsQdnRzy8qvA2tnQuXyHXlwajPUk9+cyWapboyObERrr2aqAusQ3AiUP/bz9BUxuVZyp7cvlp/W2eCWMbXtn1cCDaXochN6+w2dwMiKKIMarakAtvM2T9IEllb5gLxJR/CKqYgQcWgSjJp4U6BfbVUSj1JxP9oYWfkvquT8t33G+86ZLDzJf71z3FADiL9
 VvdqObAX
 a8+yKhwQZqTKndIb6iJxWcdvFSYcZ+ic+Li94yqxksflhGb8pXIgmxmj4tYPtP6N6DLsAF75iYsM/AkFwSrRJJeKuYW1cW8CFia4ZxDK+E/J2Q5WEu70y68ymvw0KsJnhYvAbF3DRp1GQrfs4nau2zJSbNFKphfRT8LEpMsT+5E41v0E29sv2QGSk3Q/NkitMRsaJdo11SE/rDxjbgAkQQweLnqA0F+kWTDtN4yZRSO4jaUh5dnXD424FDH+B6vnSvLcnWfQ9HCez6A2//9SrJreJbN6gMXyuYgIaThmFVRFUMjcQlrUg5iv8z5i1kuC0fc8Cbd5KZtaT/5a59eZaMhCgxpDlO2gEDlvr9HXX6uJ0Rfiqb2xoBTOAKaWFnxmcokeIM27Y5OZWs+B3naSUexV+tehmVA4G5L9Cp8b9EXXt+2bu0YY+JnQlPPvkHYA9Opl2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 -
 mm/page_alloc.c     | 29 ++++++++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 73109d4e31a4..d24b61e45861 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index fd910743ddc3..4af5e72742ba 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -938,7 +938,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 702fa2ced1e1..399e2038dcd9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1599,8 +1606,19 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		/*
+		 * Only mark as zeroed if the page is actually still zero.
+		 * kernel_poison_pages() overwrites with PAGE_POISON (0xAA)
+		 * when CONFIG_PAGE_POISONING is enabled.  With init_on_free,
+		 * kernel_init_pages() re-zeroes after poisoning, so the
+		 * page is still zero.
+		 */
+		if ((fpi_flags & FPI_ZEROED) &&
+		    (!page_poisoning_enabled_static() || want_init_on_free()))
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3021,6 +3039,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3059,6 +3080,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST



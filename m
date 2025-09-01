Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BBFCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F8F8E007B; Mon,  1 Sep 2025 11:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326DD8E0079; Mon,  1 Sep 2025 11:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DD78E007B; Mon,  1 Sep 2025 11:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 112A48E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:07:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD2645BC58
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:39 +0000 (UTC)
X-FDA: 83841010638.17.E88716A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 172C9A0011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SZP6Otuj;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uoE6NXhltHN+7rLv53vXfhLviFP/GMqcI5NGlTVFxQ=;
	b=D4uptt9CJTc2usNUgeUA7FebR84z7YJcxXV33cQwUCoumGPbuwnTkNcJx41qbOJmfoPzaP
	4W2TXJDdP6dEhnwzCkROR1G79mLFRi4s+oxpgjfvHOK+STNQOZXQTAJXRmnCB47ZHsZNih
	BUB8kHsIugtsp+uVvpg6uX0hqVMOJck=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SZP6Otuj;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739258; a=rsa-sha256;
	cv=none;
	b=SFEGh2p7fmo9Pamh8FxwYfLwAOpd8QTy+7is7hVDDVPzCrDgifpt6B2i3wmISSB6K2ZilQ
	8R8YzJN94+T/Dnd/tOtFa0LUwB3eSBABm5LHQMRgyV7CV5/abp0VeU1LRepvATRcnI6CZ5
	2vukt1KIdLc6xU+sKb0Awme34kXA1G0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uoE6NXhltHN+7rLv53vXfhLviFP/GMqcI5NGlTVFxQ=;
	b=SZP6OtujtqNfh0T6owmQyAVDMw7ZRMYCIatR22bEBZih935fz+q4zeUxgMRmqKVJrKtw9M
	9rajmUxkZy0L/RnCZiqco+fypopZ+CzSRnQhYYXt+AmBwN9UrkAuIafzS57K9uSeJWXwuY
	AhoPfo5zN0noluTiHXC6FOBwXHjurSY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-Vu95gNDhN86FCvXuoQpXFg-1; Mon,
 01 Sep 2025 11:07:34 -0400
X-MC-Unique: Vu95gNDhN86FCvXuoQpXFg-1
X-Mimecast-MFC-AGG-ID: Vu95gNDhN86FCvXuoQpXFg_1756739249
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 609CF195608B;
	Mon,  1 Sep 2025 15:07:29 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DFF318003FC;
	Mon,  1 Sep 2025 15:07:15 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v2 11/37] mm: limit folio/compound page sizes in problematic kernel configs
Date: Mon,  1 Sep 2025 17:03:32 +0200
Message-ID: <20250901150359.867252-12-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: hoex3f1dowr5ug56wpc4qn8bsbym8coj
X-Rspam-User: 
X-Rspamd-Queue-Id: 172C9A0011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756739257-172141
X-HE-Meta: U2FsdGVkX1+0H3FobpxV36Xme3a52+x4txwYBhTMR+0YG6jZtI8e3QCuPJKZYUW0pQCarR5jmxrRBpFGQXPBERRfKBKRUzwwse/YZaFokQcMB2t9JhxdvAMxE9qRIyUAdHOi/vwtPkbynu4Sp+xUx5dkNGU3rTO+QaCA8KG/8ib6hwjfTF4dkAqqBdWMoxjPIYlY/p/bV4PzGi3Lst2Nhx/xG716sp++tGlUAnWc958lms9etKD4nM1DtpxdG7LO4353HSy7EAFXh48E0RxSxeQQNfdX+9+9O825L9oEpzmbX9Lgkl02zl7ECfkExC04djDQ+l2GzNb3cjj6i/Hfixy/MOpWDs2hxJdgi0jXPXSvLbURj7NPEQ6Myo+PhVCmtkbfUFCCJgG+vUXBFFkw6vgEEMgaMgw+4kbwrWK7H9cWy9OWgsfHPUBVs5XWmoYTEQtq+cW9+Ca/t3G24IMdi5kGfOQJULLMX0ZKS9WoJGNlzDmrM2gXWB7eE1Ch0i8/25Ux7WqBtHFCsD647mef+pkAbpV1k7f28afT488xDZorEFggSexTzn5Fy+ycW0/8VPrIuOUZh20DXFtk6K2UDVnxU7MS/Uamnokeoi0Yzqpu7lwsk6SX+RE86QMb8IjLUpKsjh6THPsPhX1Nish3YslnEq9BtDmG9DX5JXdiTS6lAISBrRzk2U8xPL6xd4NL7wxLW+9bLFA2i3d/t7eOXkFrGo8bx7A2Sw+/YbOvEbUCumaT4i0v6gm6bvpIgXZvLpNnu/YSClgZXF8JMopM8iUz++4wEm9UoQX+e3X9aROoTzdvEs4z4hLiVBQUOX2UAuQbdasOG8pSTjN0tMsTcMMK/t5qNilPS3rFaVJaNhzgCd2NzIe7kKZJxwLJRMFAKRxWtULA/1IzWSBvsysPZBUyQNykj8+pA8WwdPBpUByLzkOYcc8BDVwuwx6ItI6bPkrmg/E/6F9VoDWVJO/
 YRqsOiPT
 y1JsD0OsfPEV3DvoD5yqrK1h+g5FgUi4Wb3IAk1lufWFxwaecwkP6w45fSLyYdecLysQGI3g9J368c4RPFGnSie/OZ0h6kvLs9QHk9AuzNhyeKCgsemE1ffXdx7EIlTKKEwQdbVMcI/Vx9w4ov7g2O3Qf28OGhQB7+dfXLlJIKyDV+YRoAC+RzUh886mI7CQcE2ZDsaXMcsdSTzOB8dI60l1kBnmYqRYq9K14CaggYkUuyK9ZdqwPRO8oOnknkfR330AFQ8Gv1qmJUw1HYO1zWzyrHnDmPMhyAo10zvsjcPrwF8mDNRIkTvggPrgTg7HTv0AVgZrVjSF/Y4hobidOggFIp3gj+L0B2CVc8vQdpMHti88bNOWWLQBeyHya8/fF8Hf7Q8mMVMvBtpAwvNBPu/8cY38odRiwSkjeVywouN3kZtWA2dimWFRe/6lImi4D2fkBdHbUZGOXI0gVX+gKAQURiYIcZAUqPiYqEDr5b6mI1slpvz96R8AESw==
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
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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



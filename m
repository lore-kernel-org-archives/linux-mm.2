Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8173FCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38686B00FF; Fri, 29 May 2026 11:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FEF6B0100; Fri, 29 May 2026 11:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26236B0101; Fri, 29 May 2026 11:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB8A86B00FF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81D181C02AF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:21 +0000 (UTC)
X-FDA: 84820831242.25.5A8C38A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C5E34000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NDY4c3oT;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVyoesbwmJaC/SCrniPu7amcCOYT9PX+z/FEgZLf3FM=;
	b=JdzNvhs9x3TvSHu009RxJM/JTtHJE4oUcMGb59tVv2qTkNcsFxkISi1aUMOCm2TOTYDALN
	e3Gtr5EHi3tuJtwaXWueWJ6NUqP8P1NxW53gTUQ2AML3/wgiA7LiTstxeZj3QfwjgCoZ/s
	xG8L19YzJ8T3y21Z1n+3Wq1HUuFufLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NDY4c3oT;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068319; a=rsa-sha256;
	cv=none;
	b=BnCtpi3AJKfW76FKBSmjFN0eH84OGykxi7vnIwebNmJ3jiJU3EgeQUn9gDLmufjhGNv7D0
	VA0ZhJtiaZs/sLTJ6NSA1taJGPUElNikVds8ABVz9IAmDKVYxZVZ6M1x2KzhZDEHHvEVei
	MhMWA0N8v0FllMVvHogYRbVQOsLIDxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hVyoesbwmJaC/SCrniPu7amcCOYT9PX+z/FEgZLf3FM=;
	b=NDY4c3oTqSN/a+bkjglsvIZOxVlmRleuZurfOK94mmCZyKH8fYJLGExTdUKExdO+9rr8n0
	lOZFexdx6Str6Ip77u+f66MzMlJrSmBAw7zBRNji0yJnk1YHYWZsmMLBhgUEdSuKZ/i6NI
	VfbtW1OV4PJhQXlFkjqJPyrGNxtKHeg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-yJorHxI_Mye7JK0R0FhjnQ-1; Fri, 29 May 2026 11:25:16 -0400
X-MC-Unique: yJorHxI_Mye7JK0R0FhjnQ-1
X-Mimecast-MFC-AGG-ID: yJorHxI_Mye7JK0R0FhjnQ_1780068315
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45e81291d62so11858476f8f.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068315; x=1780673115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hVyoesbwmJaC/SCrniPu7amcCOYT9PX+z/FEgZLf3FM=;
        b=EoO+iaGNRx3TLdwWNDAHFVQwQ4JC5AOOFAJVMdARnUg+4Gmmrh/b/KdusGL4UW8drP
         0fyz47y8MFv+2jE5Epa/y4AubVMtX5UjrMfeMPT97xUENFn5lMSn01AHS1UfUermFCIn
         ma3v3gw1xTcU6ojkWT6wSN3e0G17YQy5sVo57Pz79MZZdEJ4XlPgNNMonuxBo5UZwiSC
         QeNR0e+OTYm4zqx0mfk3POm1C3mKYev/3uuVGDPMJHPUxUYRw4W1XLcWaWO2jUJdrArh
         eUxnTqTLm9ni67JOgfOSXMfTf++jBD4A03TuqdUjJFV+KRGvy22IQVTcTCRXLTLl9jEb
         LPpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ymcUxrT06GKDJl91s1ybnClxQhrLKeL8AfO0vRsdKNWTZ1KceKQtreVcorrmvf9yPbLK0MG1xKQ==@kvack.org
X-Gm-Message-State: AOJu0YyhYAzsH+WWqYQ5kZ1M+5SXQngdUAJIG5b7Odv1VS7D0QcLcYJG
	QdDaMVKXzbfDq5yaNlFFM27L85OjEXF5+XFyF3qPe/9fA0b5p6azh/DkAo387llkkl4qTd/7YFI
	HF/1gf9ZhlrhimWpGJ4jEJR3j6/ZIvWKrDqdXenJLdyww8CsXwjkx
X-Gm-Gg: Acq92OF5aUmsCaxh5Bi+cRuDgOPAqQmQXZNBPAdgTM5iWIavBhrLjCXC9gvKQrNc1S6
	uJWanic/SxYDnTBfF5wD4fA5VopxWvBp5YcHupqDo+ea0sSoKuktM7+q+j0t8dFbuVV56jwRPCD
	woKhDGoqAcf21nGZXprlUu7CxbeZWoXYDih9qdC6CrK6wnREhvOMq3LfAlCOyEWI8rARDUXsYpT
	6SxLebKlTFxUm7Cz6eWU6wggOYlo5wXg72AOIBKf4Zqq2MNi9Uc64oTE1C2utGyMLZJALTnTTHL
	8VK8hMMJvLhFsZgGJJ6PnArOxiIH4epy6o+7ANM5yaGnGijmpV+/C7oATS7z3R8XeBMG1fMfyR0
	HUJRzH5G2xlK2ehn49CFln0z+GVXXhG8RW02KPQ7mYmBGzpvP5l6IVA==
X-Received: by 2002:a5d:49c2:0:b0:455:7d77:1d25 with SMTP id ffacd0b85a97d-45ef6b75cf8mr364469f8f.27.1780068314865;
        Fri, 29 May 2026 08:25:14 -0700 (PDT)
X-Received: by 2002:a5d:49c2:0:b0:455:7d77:1d25 with SMTP id ffacd0b85a97d-45ef6b75cf8mr364397f8f.27.1780068314292;
        Fri, 29 May 2026 08:25:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef357635fsm4180544f8f.33.2026.05.29.08.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:13 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:09 -0400
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
Subject: [PATCH v9 33/37] mm: add free_frozen_pages_zeroed
Message-ID: <2869cf9cacba23da37dd8b5a8417f8ae30861724.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GAlyl_jvTgTazvWhRDx4StGV56hHffA-IFwAh_yx6Pg_1780068315
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: oszcit317p41fjrk5inq7p9nxxaoxzp7
X-Rspamd-Queue-Id: 1C5E34000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780068318-531738
X-HE-Meta: U2FsdGVkX1/zX0FfPEr9ATA1WbGxccUhlC0ObDg91mVsu4HewKnsjURL/VjfiQ2Sg59nEQeYv+f7pkDH0eSa5eJ+kmVFb/gZooaiqD+ZTzKCwgHxdl7Y4Fw5Nu4jssXLQvNyeKk6eUa2KkinSmSNDdqf2/jPIOH1PjtOwwh539vaD30m/0U0Hr6nwnhY8I8XXVRdfSm6KhoA0DxHC5PB4hsg0rm4l769z5Y96AUlzq9wRYjWVnAExHpuRZeD2pgwyxnG9n3UurP4Oih6OXr2xuRf+pUyPGNarc52BnMCqv3ZCjbIS1dyLBWlz/1JXX9Es4i43O1joVfI9aIJBsbRLdO/WCdvw13inv/kC7XC4/8n8lft38t6Rqv45YDnRdyklTGIhjcl/YUm4+qR+/tJdF5BmVYLczdG973RKWG8FYQtVV59S5p77EG343t4A9bswQKjzDWd2Ni1goAA390rFVb6C668JWDksCGS1u4wiNBdr23+JaFOtHEj3A3iTdawktuPLPnp3wvvwqtGDfs6DikpUN+Ro/GGrGzCW6iz+oytCOGq8kolkCaWtUfNieH8Hkq0j3ck4XqI3m4sxr/+pnoWL+GNDjj+t6rjty5DRwpdEq/oFr/WdYG2K3i8sfe6ufnWfELrVh4zyYAGHGMceUHVkpJWl3tq/fFl5NPUOV3tMX308yEvajjQ+Dwq3D4ga4qPPlPUTv8IgH6J8TkHd7J/hDDL3PcxoBZLU36QROLq8R1065HfFA3hGTxqhP3vvITf7Hh3vGFcxmL4yLcl195a9+fPoJFYT/tj9K6jDFo8ggPyjdb57htD32FHOXhcZ6vhZdCU92iPyjsH4VVAMf7SodCqlOG0n9oqoAIdbKiHK+TrH6Z0gNMM0Bzh6l/WPlA4f1nIB89w5mX5N5U7XqM9Vl/HfRlpBS4WRTddjiDzIlUGbMxg3uMIoYEBmKKK6eJCftrtdLvOXKs1WJI
 wBwHnQP1
 coNIMiVGLnAnqkF8f6jHf91824X/1d1x7DI7czhl1SdqyzPzCspOXnv88NTvwGX81G+NlIg77nJ5nNk/wLLR8hodxsPHp6Yor/S9EGwAVsHbcSiiWBuev/nLPnJlpIwRAzLQQJ4j97N76AVAro+bW8upU108BhtDGAhor+vPyfRb6v6THjJE6sVO+A1bGhYCESiru1pCtya3WOstEshzQ/7ZYoog6bSWxeuW8l0RnSJBMV4hceBkUkC3dvKvltAi5lHDoehvtjqCQZbNI4ES5ZwgiVGlVNQRhOf5U0DbjAUe3dtzgVuoHU9l8BQ12lkfmAc59aTXFw37Pqn2225J7coxf0ngEHaHKtbmTjtEtpamfzJNQcjy2e155dUSwYfVqRFumK4+lLS+qwAGOn5e0TKg65efxVG+S960oizxEiwpdy5ydOuWas6NNg5w8zPuojO7h
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

__SetPageZeroed is non-atomic but safe here: the page is frozen
(refcount 0) and not yet on any free list.

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



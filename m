Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64912F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE556B00AC; Tue, 21 Apr 2026 18:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F866B00AE; Tue, 21 Apr 2026 18:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D876B00AF; Tue, 21 Apr 2026 18:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD806B00AC
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 651F7E6790
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:09 +0000 (UTC)
X-FDA: 84683936778.19.002873B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B71E40010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/5GYQ25";
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqibEu51w521jmMlLo0nOiOBZCjTDi4b9M623UPDLCI=;
	b=5+8uysfAiV2M4NU0WOaEVe8vD1/8wy01PJ4Jxluveu9MvooGyrV0Ri0va+/EPmwzP0jAf8
	QCGJTOw+V0PB4G8/1qH5zbjyAGV4dk8eSWNIYQxSJUD5vBHOnl//x1OXDvt8JnFHlNs4ew
	qQFYtReZYlpbyN0XjRV9pLySo9uuDR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808927; a=rsa-sha256;
	cv=none;
	b=bxvn9yGAUZHCqYtglGUgLClMBPCvev0sgYlxtPdlEyWctavw0TLDB6GbK48m/MRIYn6kck
	XI4M++NlXBFPDFymjLa1ucYO3CptG2SKjWa1Qbi9+AqxD3OqAzn37D0GYSCxpbxas4K1k8
	uvq3eqfaE3Bsc5aVuZFGNg6Lb9jVH1M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/5GYQ25";
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DqibEu51w521jmMlLo0nOiOBZCjTDi4b9M623UPDLCI=;
	b=a/5GYQ25BIf0namhCY3HBtao2XhTBQthQgV7emdC/TRIQ/p3TNGoIE3Qews0DfUam/nuVk
	AjAzycZIfvCldBzKmbuqIyQJW9qIlPeeXx8evVlMgWpXJ19eB/dfx09TwEi5NKW/HIIb7Z
	gxmhZLIOR+rfgutVnZYIFbzDg0RAjac=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-dgDLUtJ8PDaWnp-woKVdOQ-1; Tue, 21 Apr 2026 18:02:05 -0400
X-MC-Unique: dgDLUtJ8PDaWnp-woKVdOQ-1
X-Mimecast-MFC-AGG-ID: dgDLUtJ8PDaWnp-woKVdOQ_1776808924
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so37750625e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808924; x=1777413724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqibEu51w521jmMlLo0nOiOBZCjTDi4b9M623UPDLCI=;
        b=XA7ep1FNGDSlpQX4fzQYUVxYBiUQWBH6qbTxb2sis0B24oFD/XOi1wTkBHsab7L51s
         PMSJmdtJCh/yiN/pP5Op6vYZiCMmTttpFblhWHYhjt5L79iMBJ354YgS7d6k7DL/ntNm
         E8O0rsZ0U0vu3myszOeRHUAGp1pVfclU3aMauibPvW61Y1mLWsbByUfcD6PnhbCd7UJQ
         E1hZ7vtyAtZVu2eTgFEqEzfUvC3/kqPQl3s23IENA7fWEqin3iXKksxPQcfYGBFFRMV+
         xDtAW2M6R1KxTCzGbeJrm8voYHuC+7eve1LGZCQ6OSDLbRWBvN4eKumOpfw99LLZA5G6
         O9ng==
X-Forwarded-Encrypted: i=1; AFNElJ8mlZsVwaOn8U+DWqr8ljChdz3TC8N0mHJ6AS7fVTPgW3E/sR3D0MIGcQKREylJ3bcbZcWOhG0/0w==@kvack.org
X-Gm-Message-State: AOJu0YwFKo6ZLFt+bNCAMaznb8rO5PREftC906UJlB/zTJql3CG/5C6N
	eyRGuH8KLhIMbp9x1N+E135U2Qjhk9mRFw3pGKL2bOcF6G+/T5GFTU9HNN64PZarD/pRvUPyChs
	6MbNUhdmkBfck2XWFHMgciT/QVIwq4SyqSjkHr6RM3ixOeEHyTOtL
X-Gm-Gg: AeBDieuluAAc4Vaoquh4bJHkoJwze/LEDwwgKO2kbpSVSOoOPZQepeL+AiiAuU9Erdp
	hoFDiuLIZCrUDrJVDfhwwZKtyHokV3RkBQ3KRGq8K5KrDbbZKFjdqIuG9twF4UJ0WGzTsze8N2e
	/3D0NM9s1i8MNeU95TKUwXUtMXVy5gtfWRkaDtQ1AokRD4SvN/dbBmgOcXu3QTvA+bbqpYDF+Iw
	ABu7vP2YTB9loa5X8omXxCcyL5wClRABpWAIfU7PiROnPibdJUZQ/oGBuyN+yRBppWIHeIJwTff
	/gE3U/ACIqUPhZV22rrsz7mKVFm4NkqW4EW7TESMH/seBAKYScKHXyoZwVj4uzs2bcKsHFLHOBi
	+tdAC7UdQjdGNJZ+3wAuwlhpdFqNB5o1GMgX670PYdo1kCTMIk0gmGg==
X-Received: by 2002:a05:600c:8483:b0:488:7ff6:1f75 with SMTP id 5b1f17b1804b1-488fb782d91mr292621195e9.21.1776808923872;
        Tue, 21 Apr 2026 15:02:03 -0700 (PDT)
X-Received: by 2002:a05:600c:8483:b0:488:7ff6:1f75 with SMTP id 5b1f17b1804b1-488fb782d91mr292620925e9.21.1776808923421;
        Tue, 21 Apr 2026 15:02:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc17f642sm364997035e9.5.2026.04.21.15.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:02:02 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v3 15/19] mm: add free_frozen_pages_zeroed
Message-ID: <86755bb7ab63e2374a242ce24a9a3f1981f10583.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7mPQ7Wdq59uNS6w_HZVWrFvVXkXKL3KIMmtnRfWZ6kQ_1776808924
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: j9rhwdgnk63cxy58ezxrx9r6mprq44gy
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B71E40010
X-Rspamd-Server: rspam05
X-HE-Tag: 1776808926-568098
X-HE-Meta: U2FsdGVkX18wtZpP7gAQvjwVYJI4NQBGh/kYc6l0XIdES623glqS0kFYxBqIS3WJveCgYA+b3WAFfxkTXUZyPYcEhREsEFM94e+z8XgEaFJZ1rPm8H1jdy3MvY19gIHhkdw4YZWAVWNByV9IU18IB1zSglEjEEDnZ/0sJCTWt8vHBXmfhXSkYuJwon5iLT1e4RENU7Xk8Mt0xIDbhK5hYNpSAO9ZCXZGV9IFczKR3G6Pesv+q7fer6pAQWE0Y9uR59AHfasfRUBNqbp1R9Ic2STzfhdD3xJTKpTHBopmBQZPH+o3OnVbOlmAho526rOv322rXISFyVW3Od46VzIzH15COen2hu1bopgSlrFdgurcgRCzxP83gsvW+4nIgeJzlIEJ9/gfBrpT2iwzMnbP1fD5YxkdEWxFVoktDCgDd8Chu4IFsdPHrZYPqgSFsCBu9U/+IBbhDXMlDpB2oKpxk/R0jS5Xd/stAFWNIYH/u5SFPnFAIwgHFK9xUcbA1Nzj3JmGgL+XFl2asdP6smybqEkRpoc96ml6pt0YqucMPmYUn5kDuhdSs8zuVn4KOMcIMTeQhoU0cDC8NYypf+ssdWK5ki6Sz4+E06E5Dn+5M9ccjGpqVL1pK56ohtKIX734Usht4x0Ih67tSJod2C2LwMVrzvwQJobcM8RRZ9jeZVqCsXNFVPGnaf0/mShWeAyVVcmf9kaUuHw4s3wHqSgdvwqWKLSySS4l7HeSa3/z3TAF7RUNrmep/4PHszE/9bGGTyNtyM3opQsZBEsaC/dv0Y/rB9+p9bEy4VXo3I7WVK3/DJL/2VvI/UBR5ZtpkhINjSYON8p8eocvpIJ7WX0Cod2nAppX78w9pAeDRzn4ULgESP2CUztjaY2gYH9mj4xA6coYHI2zaiyV0vWN/nrl7ely/BvoBVPa/NJxL0XBLXG/huoGO22/f53iLd7OA3+yj0UrSzQCi0FVUceO7yX
 ujtw1JRV
 wzM6cfvs6V8AQeDsDOSZteG5Ua3IAwP2EsGJHmSBIj2uk0UcxUYOrqZmMl5Ku1/DuEVsMg2Y55Pm9FgPd0Cvx+RkImqJEdr1P9rK9RE8xeSxCQF5aslVuv6lMpzE+k+mdu6lLcnS6jICMgicQi4bWxSwEuUGIWukuCi5aEa0/avY4LxQzwd5ID6Wj1eCiC7X+6DKkiPgPOh+2YnUOFGfnjBZBx27Mq1cVkG6W4sQMwTK6QOMKt1JIl0Eb5OjjlOZmg2Xgr5lXimeytB4n05VmiyCgpvLzq1FoaSanc/dVuxGoBSindb1dxp3Gba5lcbF6wGWkK8p0VAsWZdOwUhSEOxDMvqqAOfnSeCVgFzKkVWaCf+xys6kytGUPVA==
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
 mm/page_alloc.c     | 21 ++++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 10f653338042..12ab91e2ed57 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -398,6 +398,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index 4c33249e03f0..e655385b269c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -899,7 +899,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2098d569d80c..9311374bbd2d 100644
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
@@ -1611,8 +1618,11 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (fpi_flags & FPI_ZEROED)
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3012,6 +3022,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3050,6 +3063,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
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



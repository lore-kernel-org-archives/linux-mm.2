Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F0ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961726B0096; Wed, 20 May 2026 18:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BBB6B0098; Wed, 20 May 2026 18:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821726B0099; Wed, 20 May 2026 18:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 705B96B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:20:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31BCA8D864
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:46 +0000 (UTC)
X-FDA: 84789218892.14.911F371
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id F0BEE40007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hUIHefLI;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KLmapuZeL0TvG+NgLwJQJBgDKEe1s3MFixcWgGLhrA=;
	b=HVYeXGBxHfirKJ8iV/H7xnTwR2v//2uySMJ7t8Y3YwKl2uMaab7NrfqXSAwQsOYehSh9k7
	STRnUSPy/czvXT+jzNGoDGme/eZp7rTCq0RHEIu52T+J+8rO/5NHsXw8Fejz/KmsnCGEst
	jwZat490HO31jY9FIO/UlEv/+tVjuvY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hUIHefLI;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315644; a=rsa-sha256;
	cv=none;
	b=NgH/Vet5hNmzjoyBYznekbOXXiRUjRllhDhj0h+v5OVnT5tP3ncUmFUGzbjJEo1c5tdFv3
	enG0AVOeKzTKzg8qwPuzmvUuob9eTYx7oTgjmFaw42Ls6cFfKayQwhZ/t44miGyaX6vPy4
	UPAtM67twEjqrJTahrbHbnwnPmPubJU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6KLmapuZeL0TvG+NgLwJQJBgDKEe1s3MFixcWgGLhrA=;
	b=hUIHefLIyWNZJrYZBhuExPJNOrNtWdEo5kf5HQJ9m2zv0CE88ETTD3msTw57j1bgiMF5F0
	tP11Oa3tz2VnKnaVOvb0YtzgJ9Che0BXkPfLxieRBGScfJ/qfJ+NPBe/Aa7BwMgFQwfpjh
	Vu+1hxdWxHbHkn9CTU5TUozIoUMYTBM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-FtyN634UPXK4rbUpV981xQ-1; Wed, 20 May 2026 18:20:41 -0400
X-MC-Unique: FtyN634UPXK4rbUpV981xQ-1
X-Mimecast-MFC-AGG-ID: FtyN634UPXK4rbUpV981xQ_1779315641
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-67fd8b6631dso601552a12.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315640; x=1779920440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KLmapuZeL0TvG+NgLwJQJBgDKEe1s3MFixcWgGLhrA=;
        b=CCrfD2FsWVHdPLFzKdf8OYcwAkjOszoJ8nduEgl8KIEB8ybk5UF0496zQwknqj72Vy
         +bo6hh7nAUcHdy6skIfPbHu9+bswcYHAox+XGosuPVwv4FLoeMXmmbGnK+vFNSjFZKdp
         ZNebPhLViMD1wuDJ6GCOlB3xkIQB6bmalqTo0lYwcaDC4+aylgkyRlbv8K1AIZ46CBVs
         Jo/0CP2DwydU+osKI6GNjA2jQgyvObmdvAmLOFecseRiRDTWNhsxlFuftAPG11QdIURu
         ByZ/+0oulBr1VZuypQOg0z5WX0URZ8G7mKx3Cz7ntCtb8SqKRSdRgahY5iC2tfDcCkPL
         yTTw==
X-Forwarded-Encrypted: i=1; AFNElJ+5aCJUgXopESVLzg/kTuIp3COdjpfSluor99oCpXIyw4Dht2pT5Skkxet3zI9W9cRYdDT4xeFyMA==@kvack.org
X-Gm-Message-State: AOJu0YxdmejZ+akhnAh5fc7lToVCf9+pNZWdiH1QMtcNAHt3eWEXV5rK
	+4MydcMpqTVrX0liINsutq6DmHYvAExFf/iRCLZiuceBTJkcPKgKNsJPM92iefXrsKGg+RpnE23
	QIR8Y2R0ID6fTbJbxNnUjvCmpLoXFcX8SF/59xbtlpmfToq505tu3
X-Gm-Gg: Acq92OHO3JUOAoN7Lg5EkdkAt3KLLKFaDka3G9HIuRr7VR2i3/UNM9EI9zlo+1do+ie
	viW0Eyf+AAwHj4om70a8fO0SBg5JXyI7CKcpuOpgQcR4N8B7mqOHZaN735XR60e4AlQH1zJQzZT
	z9kjZUqFCzQCIaDulREgcFiGMR/y2lcdsYvhmpCgtqqQJX1EaLKOq0WuC8G1fGNQeAel3Qp0o4E
	aS7zAzcAT5HcaEq+iu+a87FfRi31CO+DqXNthDOK5tozjdZ6nfomhUKiUY2SkVLsKcDBY1bCYm0
	KiGD8K2mJcU/s830xO7+y++bHI2AcyU2gDMJsauDnyRootnCy13cN5vZea+5ZFXU4ey0OfMA335
	raKFicFmhOYBwD31W1PRUC64hS/IkLUq2u3DmlKunUd4=
X-Received: by 2002:a05:6402:84c:b0:683:5589:4317 with SMTP id 4fb4d7f45d1cf-688361e61a7mr34133a12.11.1779315640460;
        Wed, 20 May 2026 15:20:40 -0700 (PDT)
X-Received: by 2002:a05:6402:84c:b0:683:5589:4317 with SMTP id 4fb4d7f45d1cf-688361e61a7mr34086a12.11.1779315639756;
        Wed, 20 May 2026 15:20:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-684744d13aesm5851373a12.18.2026.05.20.15.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:38 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:31 -0400
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
Subject: [PATCH v8 04/37] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <41e4b7824bbd0fbc94a1c9a52ac1f261fb032a8a.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RIf85RuPJCFg8qHkDRotG6lcXD1M_Cr3W12XWbSfAfY_1779315641
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: F0BEE40007
X-Stat-Signature: 9z1845r3r39hketdzk83exjcx3gmtqnk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315643-536136
X-HE-Meta: U2FsdGVkX1/kDy9PDFmdkTJLAtuAH/Yw6FXIxqZFaQY/htfWNO8r3b+GJ0HyGq4HZV4d3/bDuy3XpN6HCDOnSuUoLJ++cYiKgDB0bT1hUN+rUXgxDYIeAXqdLxzsivFEnrqFnjkYB5ie9NEn65CghTRZ5l1RdZcI0FA1GblHdVcqUTHHNvHFOH5SNBB32s9llR5U4RIhiRQrTIRAVATadC33Z0Kg8vYCD6/YQOX1LPP0GKGNRSML0oHjOxInjolZNsfTeeEg0hMo52Qbzon4vh4zzohYUu3ue/Y7fLi5NrsQxzSscZmzYytlPOWRXLD+BKgV5l7bYgcfEuu+p8GL+T3KXdaoCjWF0QkUV2RhQQPmPx+SHRUsDk9jkAJbl8x/gzPs/xCuyoOO+1uXk8Rz042cU4XmD9fvvarb78i4U8kuxD6ETM3gDFUNWuMmNoH4NBN6YXiaYw73aA6pR9w21f9SZxRdrt4zqy2FsPFuyRqTUOtxKQsnHBpv5lq0eFr+0LLzyKmZj8mOq61CBDUrEZYkLj7QJN5g5SMaQYsMtu0fA1PhPJ8vgKTrA8j+swscX7HetSPvbYMQEN3M6dWprrJm4rs7elT2kJmxz356e2+eA0jMmOs1y00DIEfGU87bni7Os0tjUBb/bIcnHasJKGm84LXqnqkCQfWcNEMUwNV1M394iP1PwFJXUoChY6EDA7Z42A5m2cvDrmMwg8iITHcEsJFfXnGgxtEMqs9IHrh63NkKgIOYh5miWYnROwI+P1nshl7H48mCPpKmRai+zMPIw4R6d7i3Val3pP/1mi0B68g5uV0DeanDIZ1K3V8KyUykHY4UHk0OW+nf+1qa+Nbiyg/X96MzHAkdBKxAqF1mXwPY+zk04en+dM2H8+riKNpm7nXpKk4ozMQHX3cgKAiPOMLRpJEPIIvTt7uENMZqbX8l1XxdEOz/GnuVipKw86q/YAcfnJ3b7uEmj5n
 m+pKij2T
 FkjLgqkuk8tIB+kPYmH5GB48EWALWSXpohRa2LN7Rssqjz2cLn4uigfkgyJHsrm5WMuszyiLoJyT9PNXnjOJN1BOLYMJh8SgORYhWJ7QQJ0y+O9gtUkFB4H0FVNsJZDmJx2GJtnh/QrM/W9ydyqVSmGX4KHyWZsUo8xfEqZNAhLsGG6Q4fqNI1ifj98ZPuVlTEYQ4tMziY4jcr87as4P5Zo+/azQjHLBClVuMkwtGll6qlD5Pn2LvJ78DE56iLLDuUfnrY624trqzHJMpt2xJ1HgMFQQfNfuECcT4HYSwCcqHRrUZI3tE6uarel38RVwkLbRGz2cv1WqnPdHoZEPUZVgQrsVpNyQLaXYMT2LiIffoYst8WMmosRmBeVTJv3nqwbKD1eM+JQjllPb6cQB0XI6unLQSMNxj8esmucHmmDWRClxRYX6duYIfiQPbs90UyQIS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a capacity field to page_reporting_dev_info so drivers can
control the maximum number of pages per report batch. This is
useful when the driver needs to reserve virtqueue descriptors for
metadata (e.g., a bitmap buffer) alongside the page buffers.

The value is capped at PAGE_REPORTING_CAPACITY and rounded down
to a power of 2. If unset (0), defaults to PAGE_REPORTING_CAPACITY.

The virtio_balloon driver sets capacity to the reporting virtqueue
size, letting page_reporting adapt to whatever the device provides.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c |  5 +----
 include/linux/page_reporting.h  |  3 +++
 mm/page_reporting.c             | 28 +++++++++++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f6c2dff33f8a..6a1a610c2cb1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1017,10 +1017,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		unsigned int capacity;
 
 		capacity = virtqueue_get_vring_size(vb->reporting_vq);
-		if (capacity < PAGE_REPORTING_CAPACITY) {
-			err = -ENOSPC;
-			goto out_unregister_oom;
-		}
 
 		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
@@ -1041,6 +1037,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		vb->pr_dev_info.capacity = capacity;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 9d4ca5c218a0..5ab5be02fa15 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -22,6 +22,9 @@ struct page_reporting_dev_info {
 
 	/* Minimal order of page reporting */
 	unsigned int order;
+
+	/* Max pages per report batch (default PAGE_REPORTING_CAPACITY) */
+	unsigned int capacity;
 };
 
 /* Tear-down and bring-up for page reporting devices */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500bb..ae8d55f89f25 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * list processed. This should result in us reporting all pages on
 	 * an idle system in about 30 seconds.
 	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
+	 * The division here should be cheap since capacity should
+	 * always be a power of 2.
 	 */
-	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
 
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
@@ -222,10 +222,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		spin_unlock_irq(&zone->lock);
 
 		/* begin processing pages in local list */
-		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
+		err = prdev->report(prdev, sgl, prdev->capacity);
 
 		/* reset offset since the full list was reported */
-		*offset = PAGE_REPORTING_CAPACITY;
+		*offset = prdev->capacity;
 
 		/* update budget to reflect call to report function */
 		budget--;
@@ -234,7 +234,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		spin_lock_irq(&zone->lock);
 
 		/* flush reported pages from the sg list */
-		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
+		page_reporting_drain(prdev, sgl, prdev->capacity, !err);
 
 		/*
 		 * Reset next to first entry, the old next isn't valid
@@ -260,13 +260,13 @@ static int
 page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			    struct scatterlist *sgl, struct zone *zone)
 {
-	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
+	unsigned int order, mt, leftover, offset = prdev->capacity;
 	unsigned long watermark;
 	int err = 0;
 
 	/* Generate minimum watermark to be able to guarantee progress */
 	watermark = low_wmark_pages(zone) +
-		    (PAGE_REPORTING_CAPACITY << page_reporting_order);
+		    (prdev->capacity << page_reporting_order);
 
 	/*
 	 * Cancel request if insufficient free memory or if we failed
@@ -290,7 +290,7 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 	}
 
 	/* report the leftover pages before going idle */
-	leftover = PAGE_REPORTING_CAPACITY - offset;
+	leftover = prdev->capacity - offset;
 	if (leftover) {
 		sgl = &sgl[offset];
 		err = prdev->report(prdev, sgl, leftover);
@@ -322,11 +322,11 @@ static void page_reporting_process(struct work_struct *work)
 	atomic_set(&prdev->state, state);
 
 	/* allocate scatterlist to store pages being reported on */
-	sgl = kmalloc_objs(*sgl, PAGE_REPORTING_CAPACITY);
+	sgl = kmalloc_objs(*sgl, prdev->capacity);
 	if (!sgl)
 		goto err_out;
 
-	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
+	sg_init_table(sgl, prdev->capacity);
 
 	for_each_zone(zone) {
 		err = page_reporting_process_zone(prdev, sgl, zone);
@@ -377,6 +377,12 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 			page_reporting_order = pageblock_order;
 	}
 
+	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
+		prdev->capacity = PAGE_REPORTING_CAPACITY;
+
+	/* Power of 2 so division by capacity in the budget calc is cheap */
+	prdev->capacity = rounddown_pow_of_two(prdev->capacity);
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
-- 
MST



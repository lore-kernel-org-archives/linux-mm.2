Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1406FCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB866B0092; Tue, 12 May 2026 17:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5826F6B0093; Tue, 12 May 2026 17:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497D66B0095; Tue, 12 May 2026 17:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAD16B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 035E516017C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:33 +0000 (UTC)
X-FDA: 84759998988.20.EF68D91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A10FC20017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JUfvBjJd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619931; a=rsa-sha256;
	cv=none;
	b=1pEUmJkwsGEqfEU1wHkRWcmbirf/tSWvIRCwU4mGdnxwMO9vmFISo2h7uEgIhMvPAgg1GR
	MKW17dntCgXN6DI7VgjGCPwC7RmkiKLwxIXw2DTm0mb7jidbpmCae7u6FydxC3GKCi88gg
	bbR1HgZffcP9KMp7lvAF7zXOplmW988=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JUfvBjJd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=xosHDGM7RH+d4IoLBfUcNqTtBc4iXnZ/SeogxckHN0avvtHadUj/DDI5Q34N71HiDq22lh
	SZ/igFtUjVfKQHxQillLY67LtBYXhjaR3NgR1Wt2r7rFEq6Q+0iZICJ1ydUcIpx4KmpmN5
	BEY18r3FV9rIQMvMGMJ+rrJ1Tai1b98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=JUfvBjJdeR2KANABN5BgdzARcad6t+QCUWdIyeUxO+AggWAZGApGq48EEcH3F1t94sIB0v
	TM4RCHQta5nW//jmh/mkAiSzEBCKp2jECj7IGSIYoB1izEtWWXKFy2Hi2kwgJSjnYh8oCu
	Vfos2e6SlcUQZQX8MqwtnHNzvvZcEAc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-YpDfOP7bNYSukErHsFRhEQ-1; Tue, 12 May 2026 17:05:28 -0400
X-MC-Unique: YpDfOP7bNYSukErHsFRhEQ-1
X-Mimecast-MFC-AGG-ID: YpDfOP7bNYSukErHsFRhEQ_1778619927
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4411a2c034fso5446286f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619927; x=1779224727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
        b=ggL/QxMRCw9Yl7yh0RKrdzysxpa/XryMdHqfGt09bYLTY5cQXW+iqLrRCdjnjKeTJs
         nlu7k3qRfB6ilKscGCMVn+kklf6T7iNA08fkj636J6jHEzzuQCj48YBcVm1iqE68/ho/
         0PZR/oFpowlNJcGxI/8LcfwatCy/vlxFhCLUNYFp5OcqAnn/YQXcw7yYhz0smTIy256a
         gPTZbEh4mxrHF6+4u6hayGvKxdwL/4qmiGc5Izrb1RPQwMs4BYEgbnFZ52rBYJvbJDHp
         Z8r6zEwjuSMxexv6GG4CB6/4fxeXzRf4GZqtd2o0HyESj3zxQMuc/XF+Jr0lprYmzToj
         bgtw==
X-Forwarded-Encrypted: i=1; AFNElJ/H0yN1sZC5C79mpgHcyTxMzVnXvAM5FaRW3xNbx2aCFyqwD1r3JN5UpWUmtc80xGZVbIcGvBr++w==@kvack.org
X-Gm-Message-State: AOJu0YykzAx2iTbz1/6mMko6DkLAF2wOm+NkLxhvUloKp+/+4XzaPLM0
	C1WkOxhaJX2/yP3XzCgwsDlYZc3K+ZgFvMCp05TImWunHYPseyE+CPlcPbhtmrcFejhd6RxEFSU
	b4sQ14U4qvBKlyIJXWvpOyKMl+0QlhB4TblecEYq87mR8srkIZC3P
X-Gm-Gg: Acq92OGk1MZ9CTXtYciKZh+KgXHejTj+o4VF+pwHLHtqKClm0TS/hETCkfMFI8BM+kH
	6fT2B4l999EtQV9ZTR/F/a6Tr/q3oiqepdto0Kq7M/ekDy9+1ZCYIpybEtunhkkoqpx4CYmpuZ7
	0UKo95ci8CalS6j+a8lpRJdxU0F4UnitX6KL2z9uJ3Vjjo9RR03SjDtkpR4gRwaQxI3OjG2xY7P
	x9tvBnwIMzP23Xvvv13mLknNjR26LRqkJJcktoewIxkFgJOKXCvTsH7rERx8yYlcLHm+1ofqSnl
	d3t8IPA/Jx5IRpZEkc5dyiYfS6O2BtshN/rCOfiGNJrjBRNDEMXgbCfUYrV1hSF0UZsWwr55b3T
	DpCtgYSggWrNwy2LGVEyHKN73Ruq4eu8M1P/9Bols
X-Received: by 2002:a05:6000:268a:b0:43f:e934:50ac with SMTP id ffacd0b85a97d-45c5859efc6mr574232f8f.7.1778619926588;
        Tue, 12 May 2026 14:05:26 -0700 (PDT)
X-Received: by 2002:a05:6000:268a:b0:43f:e934:50ac with SMTP id ffacd0b85a97d-45c5859efc6mr574198f8f.7.1778619926094;
        Tue, 12 May 2026 14:05:26 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491f8d4c3sm34961168f8f.34.2026.05.12.14.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:25 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:21 -0400
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
Subject: [PATCH v7 03/31] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <46519548042fe8029d74459704468e0587e674ec.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xg8jHJ_PCmN3qswsIWUOBC6inPDnruhAn7Eel8gARA8_1778619927
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ad8dhkzhaxosp86pfwhfg3m3su8ero69
X-Rspam-User: 
X-Rspamd-Queue-Id: A10FC20017
X-Rspamd-Server: rspam07
X-HE-Tag: 1778619931-752616
X-HE-Meta: U2FsdGVkX1/8olz+pYzYdBYVUB7pDf6ZhayrUCCkJ6ppJAcD2Z1DN3Kvwflg9bwmjzV4vZTa8nRARTY1yp8pbWEyqhDYumtWrT+fXnFyPzkkoaEkAvX7CcxIidQ06sa3gozHTHEcMKTt9x5Xq1SAeiYsFBJ/j+XPdY6dXEHdhbhduL9Ezc6h8Jb45kvPs7ge6sFoEMvDW7jQyLYTUdocwQmA2Q/clD70SgG1qLtuUYrmtuUo9xnsKh7WUN3/TC6sPqElUdWLFExBYr9H4fG2Ysu2SgZB25I/Ys/LVvBNVsntqTbF06r0wkCrNGhGsGNCSbUPEpaZ2OoahwXtuHJFfXZW0nXpCuElT6yFWEZZkMCywYReyHfy0wczU8vvrBt7RU3XMU7Urn7etnnKpIpgXDK8N4RJwCL4OGt7+MbynFSte++If8lV018+NGnQnRdn65ck/bnjC7dv3ZxUDrLRm49HwidVHR3ClrRR0v3a65y1aSnexQoQO+pqEzNsyvaYg/uLgPzhyDoj/w08fFUDq8HQgCjt4LlJc4OpLihZzjdVXuEn3OM6rnQlp35Xh9f0OywIh9eBVrVYAmv3yLb2HcraRcfwKgY9yxYN+4AwXB/gSERwg7bp0dfvya6o8py6kRGpDtIbPYIaOV8ZScWAdJZy+/Y2haNUlPsSUYwSypVz9km+6D29JP2klK7w+054uKiJbA/jkbj9j8Ker+tgPBtrrFbGYgltWJISbmmSpu55+FYoHlhZPsDDgPa0FynpArlj7ZVvEW279GKsV/yGd9oeog3nIVi6rUseFB8DI7H9zg8gDEUB9GQqWWO3+O5Tq5cb2hki7/XnxFikNkip6BrM/Eak2G2NkBJ7uhFVJnDsawOAWjny53PTklEjAD+Zz86aHP/ECBKRrO5rmIgihSnS0845gBkaqOPQ7JzVido/tb3fD2mOr/fRTkHJqvqElCNxMy409QGHaL/jpoD
 TTelp03G
 DUKD6AY97Jwma0KF8hvJ49fpXk/w1diwBLybZ4e7hanTcq8I4qlaoDv2RAPdpIBLag+Mq8rqX9t9fES1JJuRylWuYT/5sEDyPjsVbyybKu222iD0NOimFbbAiw07RyVSCJeCMvSggD6V2AV+fnGPUfnMr0giCB2qCQ3kHRjx0PUUpImPNkzwocSxUF9XAiNW76eoxklSnYAjjoPUcyWRzYTWwRxUiAHqhwrX1GVR5Y37ijfyPM/oevmnCB7//rOfWM894LBnsJRhMLzc0nhsc5Cv35nk3v7anohUcqxqRyArFb0IlWXqt5znS58ETg0hc1R9omapDFG5F+ffMeHSQkXCM7eqYG74twzsr30E4SdTAuQ43ezszEBIgI/i7LP1a8b4tPfGlp2MjZIkSqKci7l3G3bjxmuGb6+nLA/kaG+epW7C69sS4t4AV9wphd5KdLNnm
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
 mm/page_reporting.c             | 26 +++++++++++++++-----------
 3 files changed, 19 insertions(+), 15 deletions(-)

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
index 7418f2e500bb..006f7cdddc18 100644
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
@@ -377,6 +377,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 			page_reporting_order = pageblock_order;
 	}
 
+	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
+		prdev->capacity = PAGE_REPORTING_CAPACITY;
+	prdev->capacity = rounddown_pow_of_two(prdev->capacity);
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
-- 
MST



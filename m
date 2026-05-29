Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40307CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15A86B009E; Fri, 29 May 2026 11:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5A06B00AF; Fri, 29 May 2026 11:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5626B00C3; Fri, 29 May 2026 11:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFD86B009E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31FE312020C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:34 +0000 (UTC)
X-FDA: 84820824228.05.FEC5EAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id F400AC000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H1F8lDmN;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGpf7NEGXo6YXa4YKC+LNXdeGyms+G/W0uzlFnpQv6k=;
	b=aL9Eq4vVby4LS+lC0t7LSVeEHpb5AztXStQyJfe6RWyyL7wGp4pvjZX4UM0BTagjGxDq8B
	3zDIVF9CMDbzOXE6MbwBDpjmRrBSratqHgMdkPLmeMMHIgbW17dhtiGXOpCcFhzIlBxSKf
	l9gHezQDnI6ldirZpQNgcO7NHlKQMDw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H1F8lDmN;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068152; a=rsa-sha256;
	cv=none;
	b=T7ghnMivKd0fAfpddNlJpWBFtIZgGGRsU0q5h2oEgXQ1jtvMhG2eXe844EwskRcmjwbCgT
	+nLbvMGszkXmhWSRrGxVOxfqN2RB66I7v2PnJc7O39Rer2JU3Tf+MtQzKKJiWirQKZLHfP
	YASNOmapmkza72rym+7vRADOK9UuDUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGpf7NEGXo6YXa4YKC+LNXdeGyms+G/W0uzlFnpQv6k=;
	b=H1F8lDmN8ZycZrJi/yO8soW8hulsYOOFMSQHiLOQ73q2cpa+5nJaJuzfwMjz+6jY+h5w2D
	p29p9Pwyz16UFK4C1Uq5NthAVmoLDzdppqJEaTKyIREmDIf4Z5y4sF/2OfPcukDNE3tPy4
	YUIX/4VmpLovR3nPyEXD7h0q7kSZBzc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-3kNVybIjPLGf0-t65uV0FA-1; Fri, 29 May 2026 11:22:28 -0400
X-MC-Unique: 3kNVybIjPLGf0-t65uV0FA-1
X-Mimecast-MFC-AGG-ID: 3kNVybIjPLGf0-t65uV0FA_1780068147
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fd3dbd16aso115315085e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068147; x=1780672947;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGpf7NEGXo6YXa4YKC+LNXdeGyms+G/W0uzlFnpQv6k=;
        b=Hi8/1BJGBdqPDTdA3nJEtbWqKTfV1laRaarH7hrinyS2dQqa06L1A5JOggo+AuRGJu
         GcUxgD4IIHF8hw1sbXY35X5MKHkjMvPYDHHn1+P9fO8sVxnu2aUA9NZW3TD5ODknLqLY
         iuA2N0DsGt+DKQb+7ayxVkqh4Pyg3HyLmNS1X6y8Rfczqnj1jpWd0s/yc3xc9TOD2KFy
         ngsZ/LUy/YaGOj8dKz4EM5aSDOUNhkJTHLmZXJsM6Rf5Ziwdb+4/zEIkPscXuDGTUNRP
         1IIxEXvXJxdph6ft4phlcfZhkM2/lcNAnwhhpB4/C23bMWH+tKuhZfHfph9ulEjXJPJA
         91Bg==
X-Forwarded-Encrypted: i=1; AFNElJ+wh+jjRRiat4/IXOuH3QiqoGN3dFEtFdfyLELizNf4CrgBHFRdblHOZREcERMwNK3AYet0/w8ZUw==@kvack.org
X-Gm-Message-State: AOJu0YwWJMPJmNGV/wFszjujam0ETw9ZuL5YtJ5ZgeldXiCHTPvoGqZl
	oIkftTxk9aZGbdm8DryIGIk6RzSPhIspFhWrBmz/SFRWlhD/ooIKv8NGSqdjEi/z3WlziNUww2f
	TQzE9eLqO+RVURIKveR+gZ5WPFBpmD9I+voe4GzOiT+2xNistltV4
X-Gm-Gg: Acq92OGuZMFAvmN471xF2MhxSrR+gkmJYbG3XPY8cbLz+uIJH+Vp0LJMBxGFgnnsRtC
	GJaaDF4BMix2mJFYT+N67CoepITJCWMuEIN5/w0pKYcCC7E7TzTvKCNxzI8yOEgYQo8YiVr3DKp
	3rCiNE4jiE4hRlCErCeWXl1uSIwhVArNXT14eoVcYXlQViTUDOYUjZudiR4bpL4c/sw72LlSYGK
	OmcXqYcGvIYGYYXjMw+C8pNgw0pv85hTpa88ss+HAfl6mCA842BBQBYrp3VZH91kBrHWz7gLp1I
	qE0/vQM0T12rRA4oZ6hzOJnf8+5XbFCX/yLe906Yktnq7SXqAfw9mjysfQ84+w59c9rtoJkcs7A
	+INlehtn6oPtRumg1dHiNkyyvKtg/JjetvfOEUtMnMNbRcSN0p9wP1w==
X-Received: by 2002:a05:600c:34cf:b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-490a2900e81mr2221105e9.7.1780068146709;
        Fri, 29 May 2026 08:22:26 -0700 (PDT)
X-Received: by 2002:a05:600c:34cf:b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-490a2900e81mr2220045e9.7.1780068146235;
        Fri, 29 May 2026 08:22:26 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909caa7e17sm56125215e9.9.2026.05.29.08.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:25 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:21 -0400
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
Subject: [PATCH v9 04/37] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <da332cc87d07af8b4359284cab40f69175915730.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jQeXLL9ZjU6m39_AkQmZGYmqVsijDEFmVlpk8E5uPnk_1780068147
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: kf8zotx1em6c1y7ikmue6ii6zd59g64n
X-Rspam-User: 
X-Rspamd-Queue-Id: F400AC000E
X-HE-Tag: 1780068151-630979
X-HE-Meta: U2FsdGVkX1/sn0Kkg0Jrh9n/yybyyD6SotTkuxOA5MYDLmXt1e+EgsEbzoj7ZiwWLtJ35QB9Cga0hY18YwI1nSe6zcCbd33OGkqSoo9ONJzJBoK6Bo3pu/iBLL8M3ZCKnTL6ExUpr2495gujGLHU8v424UVvoAzkIaHdiQEum78OEHAPIfDOBCPceXOm4g78nTjtaDEj4qx8ZH+l2VdrVxn5GaRkMXQTP3/ZtoKzkmRJxKhwnMHGf+vHm0Hdpr9V2It/i09PUa4FnFFp3boXYZC55aEtRlQsrgqmMHPep+JMJGsUKqhUG1SCu94aCUim5RvjzMyU1ZoQur7W/GoHIfZM8xmLhFvh1fvGE1YPTafnd9Sxq+uRAjuodFPawLAJ6LksVOqQZnq2NN8hDrxdHFzSFSOmxJwlFsnMoOIYcGyiF2azBGGYUd49/2CsKsHwhSIWyMJ/FWu5zhXKr1KOSQ9/6RUdt5w0Y8lnWMp45eCbAdBvpvD98DXT5O0WQKpXXk61caLDQpm3th2fEixHy/oqP7RdsnKNZ98xcglq0WmN7adkg7AUW4QJeitktxlRZoTNySqfqzPkUtDpTg6jp9AGSwURzpUD/LE3obN0Lc9cjox+Kf+DuP5XGQUBcNlARDLI2X0DDEK7uXRPUkgRP7k+xYh6+xdFXkHSFR1hA+G87spkmihJyVaEB1R1rAsSKzldAekDdbQ7B3CtQ2ddammFpd4eV9tXMMxL1NOuxg7x5P5i6O8oq8UVNUeD1gaBhX9Y0cvtt6mssIN/MS2Po6k4gv/vtxsv3K8By9Exieh/oGVJLU2C8x3jmIf3Nqm2+XyMWt5NYSOIqf8NlUbNsvgxc7WNjlSB3c8JVtKWVqzzrZXkV8c4HtIWiiIdHYetkhOtUWQU+hAv/WdeMSKpw0M15eis/aytJvXL0/ExLAIhu1VcXORc+uhvrK2xwpFWi8JgPqDB077UQT7Ybqc
 fbnWbuIx
 DzkoJGq6oJu2zZ9pOIRVv3+qE8AappTqlGAFsJ6WBDSxGL6nsxo4xx3NCa5Y/4n2lV1jWhBpfVkzADd23jyUINr+Jdlhd0VjKGnH/uiVuKO74muXHRRys4Z0DWqac148iLXBkLsxncuPJtgAM6Y2IxUFpubk8dJK1nZxj4tTl/9I36Fe/8XAAiRzpiqFXt7aVprejMRZ+JjpUdRLcxlTDeC1Jjjg4T3foHhRn2s1otMnqT3ZKmq8UkqsA6ddHCN/2kQPwI2MXNEIU6OScGW1EBL0LR3PViEooop/GmyvHW/hcwmTf7Y/FjtWST4rl/y+WAjMCI7UQg/9iooPSNlKmyg2zzgztXlNkl8w8iVtVBa51ynhAjpmb8+tnPNRW35yZPbQi6PreuN8K5Sp5uMyCGY1/If2DYvU1DWiB2kL8QvXqztXiPHN4lNpqPW2GCj3i0hoQkX0yvHB037Dhjpc7ME7mvN0/+Cbo0YE4iGDLfB//YX7ltWsGJvLwPC9p6Rb2U4DBLxX9rTyXCDxHiP3zdezfItNm5UpJvrdCjdWieRwAs7g=
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
 mm/page_reporting.c             | 25 ++++++++++++++-----------
 3 files changed, 18 insertions(+), 15 deletions(-)

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
index 7418f2e500bb..a6ddf6fafc20 100644
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
@@ -377,6 +377,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 			page_reporting_order = pageblock_order;
 	}
 
+	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
+		prdev->capacity = PAGE_REPORTING_CAPACITY;
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
-- 
MST



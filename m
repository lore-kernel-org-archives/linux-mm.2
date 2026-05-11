Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E83DDCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7126B00EE; Mon, 11 May 2026 05:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557E56B00F0; Mon, 11 May 2026 05:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446C26B00F1; Mon, 11 May 2026 05:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 329F26B00EE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9AA7C19BE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:25 +0000 (UTC)
X-FDA: 84754550370.06.CE8DC40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9C14B40002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TkM3RQMS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490203; a=rsa-sha256;
	cv=none;
	b=peUMM/tolL4PCQdRUHCLhYaAYPUCv+RvievgSyoZ4LKyI2HV/mfyhgWi1GdkWj90ldlPDg
	szD99UC5UbjxoW1iDTXgJyXiA/5rB9nW4Zm5jiidUt3iYiMN9qKNIOnfC5dAcDlXKdpyN6
	H19OrN1yKZnF5VuFgttqdnFEfXut/4E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TkM3RQMS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=12prUidG7BH1NvHWCeLfDedBbIJxBKuicti6rciA9vz8fwhrCfpiFcv0j6e3lYUJ2sBuqP
	hx16NSLZJTN0xLJWwaOdTo8IcjQfiIFIiqd8Izz66+l5Cy3UmbZlI/E3csn0qZU1rf3FH6
	5BKKkfc0LrhX7R1sL5TqqzTdfGJDB7I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=TkM3RQMS4xvOuRv3OIo8ziR+afLwc14Ivt/Ed7btIO4qAVbVrfCQoisqZ2QognSDOSs29a
	kJB/osaM4Y78dyClWqS6eG02yNsZanRoUGrN87KLOIAgDYkHPPoMF8DNtxd7YAWXWAc+Cv
	DG/lalMq4tTnj8fhG+JOdZyrPSkiHoU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-cFO8gPy6NqixpuOt1Wwqbg-1; Mon, 11 May 2026 05:03:21 -0400
X-MC-Unique: cFO8gPy6NqixpuOt1Wwqbg-1
X-Mimecast-MFC-AGG-ID: cFO8gPy6NqixpuOt1Wwqbg_1778490201
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e79219704so7729015e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490200; x=1779095000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
        b=KaUcSzLnh1ELSbGeK2kGwMSEsslEwBSEgyCADvbqx6gTP3rciQTzD1E3oDmIvAn7Ua
         AH4I9xwamUdIeeDBu3ySz0P+h0DWsdFAKFYKOBxCII/hqpVKxoWzqTYLe6QG0dIqrIRH
         7L+WeAgYZUOc9EC48m7kNaumyDBcHzvPrffwToC14agCM7ztpxPK0rtzxFl3RU4gfkVX
         7ehjuhNjclofC3cduHZ4BGAmPfDUU+AXyqTiCK82U5nB1lnRFXW20ZW4r/yQICzRGzAx
         piBJsSPrJmQaZtTWONPyDm6FeSmSlwzEK10bHbnLZ+3FDBSOZbB0E8Xc1gOqRZxJN+KX
         BQEw==
X-Forwarded-Encrypted: i=1; AFNElJ94RO7Cmfm/Gtkd6Iq2q5nSfEKmQJNQKon+JdhwW9t9z4hOoo/zIQDmNiVFoiAjBFWLm5+8Dd12wA==@kvack.org
X-Gm-Message-State: AOJu0Yw8I3ORNjEGo7fI0brRjpws7cbwDWX/FrysiQpYZlZ7YIJojiIs
	vmsmFOv8fc1ZVw3Fk3JQRbh/nWzJcBCMx8VrFKmy/4WPy0PTj5bmOLhAUzOnmHfofhbM719Xcnm
	HH9++uCHpR4aTAuI+wdVwXG1hAU+GRe1odUN6FiOHCb9uUW9ghXqD
X-Gm-Gg: Acq92OGboijjhLUBMqj0scllRSmUKgeC5rzFtwFBUP/Ky1lEQ5a17eEqZnyB3cRpjQM
	NNWFoimNVF9G+Y7rU0yaP+7drhVVHoGdXyfVVewtOuRJPV0R+1aLpktjFABU5Xjd6A7BSFGh7qh
	jhKdnwj7B0vwMUOchCPb5azvmgEPmAoGa+HB1Yg/3qRRDxOJyAyIbG4+fkJIR2lyCQ9hE6Du8gz
	wzCGzT7Sj70I8AQOSbrOBgKxgcEX/J5JDLSCUvX6tH0yYLrEJEH/FdRxW/rqyq9nnW2CrwvBELn
	W5aZHWnvG5Pzw37N2dfAIdc+a/RxFUH4Objh9IagiubjCQUrOECjqWd/SZ2kEcvFqLOjcHfLjdh
	gsTSDauPkBM6t6qsK4JJYKZ+E2DUIMemRHKwXI5eJ
X-Received: by 2002:a05:600d:6:b0:488:b749:8482 with SMTP id 5b1f17b1804b1-48e51f21e2amr304831445e9.4.1778490200306;
        Mon, 11 May 2026 02:03:20 -0700 (PDT)
X-Received: by 2002:a05:600d:6:b0:488:b749:8482 with SMTP id 5b1f17b1804b1-48e51f21e2amr304830375e9.4.1778490199227;
        Mon, 11 May 2026 02:03:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8d4462sm80127935e9.1.2026.05.11.02.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:18 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:13 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 16/30] mm: page_reporting: allow driver to set
 batch capacity
Message-ID: <ba8b43363217b662a9eda6c2b47b6c95f710d3c7.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tpHZ-KFylbH1BrcJxl1UHyFHqqU0StLxIdGT5WqPl3k_1778490201
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ihxyczcagjctpw6795ku4uhp364o1c5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C14B40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778490203-690370
X-HE-Meta: U2FsdGVkX18J6kH2ipwaoBHnF4GcTvXXtHQUCKKUJLirdpEBNCW1shsMHC+Yrky/nxa06f5I4zBZ0bE1iiiVUICfcnA9DACxHcsm9xWFbgQAKjr1uwis4aIsetPWVS3rs/Ne32OGD7xjsiUp/RcPVa5mNZH23mZi4BUl9noJZfoRW0fx+V0pK0AaOIKovJLks7yoCtHZgSFIjiyHQYvQqbyxiGQHvjTWyZTxuscGM9FcrKJVUyLDOgJ8aNUzBJaM8hIoCN+rHEptx+gXqvckeNDYC5vnIqVq7SNIjwcERUZBobUo7247MPGsnhSG3PNyLcnhAJiikScukWjp9g1BqSLszDLGJn1peqh/zhnoDShuU0hnGZxWL9CnDasmdsEmLenRX8BA5ykPWqvq8kY9Jtoy4a4q4HAeAcWd/kZKWgUMIe70Mhj6bACPk2e45lt93PoVxZ1eapc8ytD9oCuFMoNC+ESk9If71Px3USVRf4Fm7m4wQ/OzhzcrMTN+i9aByn3fb+nPlGV2NWXcK2BQn0mpLNgToS6CSwGeBp/QD2gZQaXAhi1mvaLYtpCXF+lxWkSjFQYPzbDV6ny39NSLUBrP1xNFtSA9IeVSIeFggQiFp7l0n6ZJVGGarB9H8ORayFoMQlwlAdtyUmNKEeX6gHHWrOK/Oduywcnqv/8GlAekFoFYX04ihQSemmFJ6WWxoJ1HkSFV30isR1Z4as9dW0XXHyZan+zJHShZxnd9VJ8K8+ubDmjugByPGJdQ74+ZFgwzx6vT+QsNh6wKaiOuhsPS/lscegvtTjxb9PTj87I5N8CngxwbLRLKd56lIVgA01bc0laZ6yp9Acp2q17U2oq25fhJPYFhMpjenVFiytsWnAL2ahxpfdv3ZCwdjCSAzs6T9zQ6HzxK7U3PV0lOely/X9bnI29HzrG7lgUTYFcLduo0EXorDqSs35JJe8N8jNuQyBHKMyh45lR5q2B
 q2x9BDsp
 +zWr1Jqc71xe4tEKWleJXeue5om5GrJVceFFxToKkaJ9+V+Zg3snDIhAOTDzZtJDbGlZhD5jnPa6w9M7qXDWMU1cDLtuyo93X5IwrGD3+tOKFgUdymHnjb8Jfq0UwW+9Tv+PZqgNANIEA+yMUNx/FXTOCSPHmnouzWbukJSojz5hrfmS3a3g4+yMyWoNn/CsrhnU4eGSS+OrD0MCDUQ/idhEV7T0pPrXm4Es2jxmoad4cdb/5nrMDnT3tOvsJ2cbLaGjEliZ/0l1l1b4YU5YQ0HXldKliAIqb7/Xa6TnKCoz38z4fnt+EFHa7AynTRTiQ9GgyJ/AWuvTI8kZ0ay0hy54xUwnTSo9LwZnFhQJuaJQ2z2S0IJwkwdWRlHe0pYc8ccXK/45/mMCQbT7ARkZXlIduS+z2dzv0R90RyoxjLa8IZGRBSZ8nSKCgL/wWZQzGtn0B
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



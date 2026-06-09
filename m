Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31397CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9163A6B008A; Tue,  9 Jun 2026 11:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6C76B0092; Tue,  9 Jun 2026 11:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DFF6B0093; Tue,  9 Jun 2026 11:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6263B6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:53:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 013D340639
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:53:31 +0000 (UTC)
X-FDA: 84860819022.06.13F4BFE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 84C5E4000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:53:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrP5Smlo;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020409;
	b=dFa8zu0UphCvYG/LkerNu7s+udCVMS2MGbIB3OLbUyUQTvOR+Z4LHuhu3IDFb8Jjk9e73+
	61fI4p0i93xIpjzOwbzcTbOAYni5K4Gw7AfkRm7vMMNiYx9bJXW4vwBdoIqfM5J4JYrQGZ
	+uN8YO42k1bQqsKFdamRyMcxoFtY33M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrP5Smlo;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=znUgJLwcI/t7tvESv/1fH8INfEp80ot2BgxIAU0A+Is=;
	b=q1+/1tyUNjEaM7FXFBRZbzKegnZNLOW8f7K6hOHy2AY5R3vtYOJCmjmbO/iRsSrXsgqMWI
	5BxW9yAvwOZvrRdK1jPpS7U+FJfPFdvH9lFzNWtT8YMSjh8Lbn7ByUqUrYDKw8gAaD7GwI
	kPEqtV6NEOJeW8VOyQDMgMqql7l8eoc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781020408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=znUgJLwcI/t7tvESv/1fH8INfEp80ot2BgxIAU0A+Is=;
	b=MrP5Smlore4CzNdaJ9haZ+9ynTxCNYXKBI//z2W6pKUh3Pq65oEEFYwXPLLWnbs1tlAa9p
	Wb52Jp5EYDc4GLz6NBHiMQMzlN6EFt491ZRS+g2QcJND49lheZVNrPYPYU/zwa8YC/AMTJ
	zgeZBwLsBo7sOXeZhZjQbh/Yy+YpVl8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-2Pra8x7wOe6MW1f5e9mc_A-1; Tue, 09 Jun 2026 11:53:27 -0400
X-MC-Unique: 2Pra8x7wOe6MW1f5e9mc_A-1
X-Mimecast-MFC-AGG-ID: 2Pra8x7wOe6MW1f5e9mc_A_1781020406
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490d3f03883so12331805e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781020406; x=1781625206;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=znUgJLwcI/t7tvESv/1fH8INfEp80ot2BgxIAU0A+Is=;
        b=hs7uqkvt1YdvzssmAax4178dpcnmN8QEF2ZLwZ4lbZLKO+VzXjI0b3JNwbzIfPx+Cp
         1qPbovByXoS3OLMCcusgovI9HrzRKHvdwPZP91VJYR3AhLeihw/fH2WrDSLwl4kIlAFW
         gAe1wUmOJH2oveZU02+cXBK3QrVQ/ZXT4md5NUN9PkXGPMa4xKLxGcG5uC/rorjFhOe9
         5VWmuKyitBb6igbTywNZel2BwPSvbtreNbuSU9qSupYb0NmsVVk8QwC8YOXA9ZKnZAIK
         XR1o7d9659GqUTr1hgn6kEHrUbVu2BBX5AX7koGkglckZkc1sOWdXfrwvP3LtZ5tf/bj
         u/6g==
X-Forwarded-Encrypted: i=1; AFNElJ/vTPrhxrkaJK3QWaiASsy7tdaWF2H/8hlGgXuykqfdeG9HasLXqr/4OuvNRjom6ojYE/saO/V7Rw==@kvack.org
X-Gm-Message-State: AOJu0Yy/bKpQ6y5po7sd4BL1KZSTyK7RuShQQvldoZv9bRkUJM1dhFid
	pHReezv7Pc/s/oIH3ilFo0CTFi2yAomO6ja877UfYQ8YV/tRFbCf80nXkUwK1qEzUU3zDFlSQdE
	X/KMM37P/6Aq7+y9haiAIPbxPTUkQat5VAI1Yn/Vt2kZJSeY+xuw1
X-Gm-Gg: Acq92OHcgyFcf6Q9nEMnYKmqWzJxbQQeG5uzq86rSdeV0puDB9APNlW6YCexEmHdXPp
	P3kjBImbMpbzP0yF8VBXz9X4DnZuJqb9VFTP1isZXVeueZYwTh1qdFUq7sHOliTiM+YSu8oFCw1
	TD/1llexnNix2eDXYemxsg+S9OKRokuBmNtMNxUefAsnUOy1DLr1S9EUs3FWBaSnEUPJ2rxZTxA
	eK6FtNU7aO6g3rwCYgmFEOSUj4999jXGok/aWF0YwRVJFAmBRrlzezZsEhJNOCAUpmzFDjeZcpE
	FRJvvloQddUvZpkhEW7ZaQbE40nCJ3ILgK53UjVbL7yPBz92igevA4BY/RSXqHGduPpfN93AYo5
	GunyCi7ikh6Jmj09Aq0HB4cQvJDOJ0AAVzTmTCL7dcZhJWYOpBp65Qw==
X-Received: by 2002:a05:600c:524a:b0:490:b11f:2560 with SMTP id 5b1f17b1804b1-490c256f131mr368572635e9.9.1781020406191;
        Tue, 09 Jun 2026 08:53:26 -0700 (PDT)
X-Received: by 2002:a05:600c:524a:b0:490:b11f:2560 with SMTP id 5b1f17b1804b1-490c256f131mr368571885e9.9.1781020405506;
        Tue, 09 Jun 2026 08:53:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f67c6sm60824138f8f.16.2026.06.09.08.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:53:24 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:53:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: [PATCH splitout] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OP-YMxfCtKLhkGtSKyU47KqagZAfEZxn-GmRD8f3TFU_1781020406
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84C5E4000D
X-Rspam-User: 
X-Stat-Signature: x4br374jsdyhxb1mkksr6yfbixf6eb8k
X-HE-Tag: 1781020409-260157
X-HE-Meta: U2FsdGVkX190HXFg4FuFfeqv4WWGjQ7TbyEpDdXtb80Mp1gexWjoOlFleQOH7vQRiU4pLAw5rz5dySNLJi95EygMXMeCAimUNp89ubzUalo4w32CIw0mW3s0/IBTVcvTRvMtBvCDP9HmA4OuPAnhJuxJX/HLc9hd7dgLgkKuBWkvwgZXxx5GzRXp2g2CmXqOSSY42iPLOhFnXeBChGhGNDZvSkKMu5+BlamEvOsT9PkZk8kkZIQosBtdyBPfi/RT2qiglGudDZbG51jDTpeUaLygtW30mRJLyPP7I0CjgLNaw7UJKkhsFY+PCfmSgFRa9HR7UMpg9DzHHA97i/wfCvxIk0WiwSJ0AY7wqR/vcE4IRL7Z6gu+Ec17SlVhEhsOje3u4xtbPemEJecRiKe9u9112bG7+0fAASGKLEfDXZA0v6YQVtTRtPjsFuNg4Bp9Tk0n+izxbgn6Vo2axP+N2qq5FTKdHma26OGDzaDbRzUsQyNSnfeGjeJLShe0O+J8aF1a5/9qkXcx2LE6KDydGjtIEogyEnsfHRluZaobbd49IX+NrGK98Kig/7Pt1fgUiF73OD5VZWPSgrCzkcPDR4yQlps4hGwEkcZUXT7zvN+Rc9ubghqidHjVARTKWxWd7XzTU4VrVAZiaC6du6cv1Rn0o7APoD/mRkFpwgIaxvx7sEqIHYf/ThhqFIw1gXUbQPujgYAFPqPjlJ7TOwVdkuxBioCN/bDf3kBcZuUTgam8uboFomLbkKZi+wSUiodyidsIa0Ld2iOUp06hZI2rtz9uqLhvl1NKWx24Nwu316uJe2FoEoRv+TGP0xNBFpupbCbZkOnEl+LHXRP1m11gYeEzHfqMLUhJpa8lDBE3EXAXPSRpdjydeFNkyE2hwK7j7pnaeEIA0e+xXea40zecEuLuMkWq5a+8W/4gLaPUkbGcAycl8oeYE6A1TrMoZRQA3JQt15ztaY80Aw6Al1S
 PRCL6I/W
 AKqqyy8aYz8af23ZRXsDZOyB+YdPw5tmBpRLwnuYUUkoe0cFguZruDZZxAXsh34BXWhLMTXvVDO0dISuSVf8gaPbfZpbECO7OC2h2HdlCK39hGnyikQP4a+GeVTt/VWWo8tyHi9SbIYeGCLGpcufyz8IqRR3NqHj21jijdR8WlrU454CfZfL9aYmsktZZDf0cN/YaS8gRMHx/tNH0k7tn25n4BQo3ISe6H56RRanX0K5tw1Gsd+kxwLkaKupvbaIBW26QVO2Q3Irr5b3DcOxrACZYYZmnFPYs/4AeifwujLVrql35Wfb5tsSafb8oxaVltR+g7KJiLGZwrGAkznarNrqi0pNw5vitZucmBwyZxPEn+/1FCwz0aWLD4teif6cM2R1qAhttC3Bg3oH5x/ntxY4NZSubj750aUN66bFppSeOVbG66ew9HnccDQ59IIXVUzuBlgVzMBWZO7a0HGXGpnXodYW/kRVaJQxhcV+OnFGpOceYTPbtrfDbWg8bs40ZYHiPJB63v9WVGsXMg//2/5XzH/vocwXGZuyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the moment, if a virtio balloon device has a page reporting vq but
its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
probe.

But, there's no way for host to know this value, so it can easily
create a smaller vq and suddenly adding the reporting capability
to the device makes all of the driver fail. Not pretty.

Add a capacity field to page_reporting_dev_info so drivers can
control the maximum number of pages per report batch.

In virtio-balloon, set the capacity to the reporting virtqueue size,
letting page_reporting adapt to whatever the device provides.

Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
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
index 7418f2e500bb..5b6b17f67131 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * list processed. This should result in us reporting all pages on
 	 * an idle system in about 30 seconds.
 	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
+	 * The division here uses integer division; capacity need
+	 * not be a power of 2.
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



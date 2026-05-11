Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B47BCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFFC16B00C2; Mon, 11 May 2026 04:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD71C6B00C4; Mon, 11 May 2026 04:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC756B00C5; Mon, 11 May 2026 04:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C25586B00C2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:55:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84D7B160686
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:55:03 +0000 (UTC)
X-FDA: 84754529286.04.167B530
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0207F40002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:55:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IUijVVil;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=6i6tIj1Hrecmdojii+SNnSPJXKBSFJ5geVHw0lR5t2DwF6xUlAZVDKXPzUriUCvVCFRcno
	yF8yJ5LYbrn4/VIyH8+yN5YdJLc2tr0uGsz9C5IOiYmXoIkFhfh22RoG8lO3E/OWQGrg/O
	wdxN7wY6NdROXgpbPvB3JNodAL76MSA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IUijVVil;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489701; a=rsa-sha256;
	cv=none;
	b=uvqjEtG7wJTABF6UT3umG9HvWvtVXfPwiNsap16WUEfOfUgMMDdtHLuMcKcevGTL/frX+2
	2gX05dGBB3LJUWqtjYjLm6N5iLvV+hoDGRFbBMhMaEf+1TLceltydWXUSKIodEkzGZKvgL
	pFcFchgwfZ4AchtXsMXZNyUn3iy7Sq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
	b=IUijVVilAM6p5Eb6Vtu6uQHoG/AwvHmR+cii/ttZIpkQRwA3uZ/xfMwHZlWuhcEJamoSPd
	Qg1HkouB9YlmdEjYn/FI9l2ifvmn8sL5k/dmKcnvMBVVEJc8n+3rssZijAX6XepCpKs/dZ
	kHTod5bjF3ZK3UfIaddlxHBd6QdNhjA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-5hg8p1qwPwKH_OGjZuOHkA-1; Mon, 11 May 2026 04:54:59 -0400
X-MC-Unique: 5hg8p1qwPwKH_OGjZuOHkA-1
X-Mimecast-MFC-AGG-ID: 5hg8p1qwPwKH_OGjZuOHkA_1778489698
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d144d3428so23264605e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489698; x=1779094498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLzVjPl4JuXWdYl/OMkyXvKlFkDQF6qpB2cxYBp2hXA=;
        b=DCaMw0UKPXjrqLHiOY5Og+fKQ5OETxJttB9SWqTsstVl+tniTLjHOW0TpLFzFwDQLH
         /Jnu6qi0MWwq2lTEcQkteH+w+aO+xhHSj7koVpkO3RrzGjDSyjtSPpXysMlnKbP17wqM
         Wgmx/A6KEEyRTEH69DxJfnAIPqANKUZVDV87ms5S+a29mdEMslSZaaAhEC2lcVf5Ticx
         g6esz5BkWf0xqLOSMmTKuiyS3gOKcL2/HlmsJ6EQrthQIYMNoqJzuyurW6Tmmr6FicPX
         P8lSGV8mJZcbPFI7r3e3n/Vi8Xv0YN02IXrTLB6GvHiZQOJqkYw0+Rilt1v6AkTntSOC
         Odkw==
X-Forwarded-Encrypted: i=1; AFNElJ89K2mA3dcmF04dRbhuHX/emkuyvSTjzkaWVEzDCLW7f2jgk14J5boYEkmGJzNZg23j2GTm7ANV+Q==@kvack.org
X-Gm-Message-State: AOJu0YyJNBWHEvSTRTB+6HBcIqAi63g8Wd9Lhe173YkR33uNeaiZv9mE
	1Ul7J+Gqg3BiTdMkjV+HZYL23f3P8kw/+QifBddFBtiL2yy0AkETbn6iFu4pazZzMWs1C/IpJ6V
	TtfT5/p60VZAzsrgo41AyLMy3cd3EBy3d1IGWSe/5uVgacyj/Lwob
X-Gm-Gg: Acq92OGwpCDKIOWAIdoGOooVkB/4lP6t0H1ZFBwvGniRWo6KwrEnxKnB0ZRxAzgWDUb
	LXn7S1fPTOjPlhlXz+CdVApRhfJzAKOMUq9FZ2hD5JDv0sfBdnZujkZ2UurqmrjQ6JejKjLYckl
	k4f40DvIXnwRRkw3Ud9nexyot5E48GAGnBiydSQx+KX8CF2R2WPuUCVGN8LTGTNnfu8kzevpurh
	ufTov8iE997AUa/Dn/XrOqNok1YkixnjW0fQtq/QDcvgj13P/eh3dnnY0BlipZ3WejkmWurXBEf
	2Nv/q92TV2S6QYBdH8XUquvOsjNngwtLRxMZ1bo6g6cJ5Pyv5Jl8/p9Om9sxD4u7lLm886HkCWT
	9zFGkpGXXqGY23dIXfYHfaUm6752IiI7qqmQqRIABfWm40wm6DzA=
X-Received: by 2002:a05:600c:8b28:b0:489:149a:f9e7 with SMTP id 5b1f17b1804b1-48e706e1ce9mr154143265e9.27.1778489697565;
        Mon, 11 May 2026 01:54:57 -0700 (PDT)
X-Received: by 2002:a05:600c:8b28:b0:489:149a:f9e7 with SMTP id 5b1f17b1804b1-48e706e1ce9mr154142155e9.27.1778489696924;
        Mon, 11 May 2026 01:54:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e0c70sm189372845e9.6.2026.05.11.01.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:56 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:51 -0400
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
Subject: [PATCH v6 16/30] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <ba8b43363217b662a9eda6c2b47b6c95f710d3c7.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HJ6Os1PAklVokBT9yLSZFYKXiZYieXH1JTFo43-RhXs_1778489698
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: zinumy8jitir4fm43oe8e1ppbnmif98a
X-Rspamd-Queue-Id: 0207F40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778489700-374061
X-HE-Meta: U2FsdGVkX19sIRggukb+Vp4v6EAaovpXDVnpIv+6shq4hJPBJI49XBR9fY7cLjeM0CCpf4s3ZujOxeeVaFW610vVmWASmQ5WV/YJ73586nLZTScRd7c45pO3RhrzpOxHTs/WXfKWIt3heIjkT0292wD1mZxbtSkHMqYDgVhGM6cxBkStgtiYuvrOVr0cHlc96QBP9DOVifmPwWUEurz4mmi0496x7Pa3LibKRZIWOiTt7tN1b5a8FxIwetOV76i4rFxPM5/2MhdkDoyFVL3eGX03qNudfaQgKUNsLF1+laPEFAP3PCjiLLgZrm2OxiqL9dv+T+go9rvdebqCvmGU2lCvVJkjZ4MmKtX4+pnBFi+qq8lP5qB57PAxK8ilvXqbXXcI3Cj7N7dxdd5lClTYiPCM3ZSptJvCC6Mtjy22Qf00iVuPVNPlsPUc30vshRKC3aqeJzQZOghHmPWi0Ce8WbreDvA6Vu9RHcOLnsutXbfZfrqzjVpzpy1e9SSBsLHcVj7tGPdDeI3Zmo40mG9Z6M8fVXknUNT6+w7tAE7VEkfyWi/aF0XAuviQDk3ppmjGSq5DiJr1KeRYPhNFtOMoP7qJL6+M6E86o7hNUszIELg1Mji7BKrvWFF9DCgCe7ik5z8pT7CvD+Zh/hh5WhqQ8MEGbzNj6QmJhuER/hFrIx5WEsfTEZ8HJv8fR1Y2gXerb3B8wXtDZLs7kuYDHmP88D46hPLDl5LDWelypwKgueewUMVzwN1KH/bXnOnuSQb1AX3CWiYqqZAk+I/vksomrde7qvRDioCOlJ+n3Xiehl9DbhW+2Qqf2xBISU5nR3D9He8vWkjkekjQ1hrWmZwfv3LJgx9qaAmo1L/1LIhf08c3wII4S62hrmH6gEaU0jkq8qwbwJwKyxovt9JCNKEV7JuWjwJtgWa0dnC5tjVdwXc00i9VJ/a7xgp5Re2InMVzT5V/hx/O6Ih7TKDhfl0
 5SwjVdvy
 TnPEo7rUH05iWI/wQdgneFL0G19z/T4v66Nwp+iyTAJUfFAdCtp73fijSBf7dViOlZcdOnYWYD8smAXzPqftIY129qQQ1W4oh5Mr0FxqNch4gbJmXRXxycTWk/Xbg0QqcKZTH/AE7sCSDqPrStVg+86mBxpBbrMMwkAiurMgnJNOAdVJVlPLoOoIG5ZDoS5hPVDAg2w38PfSVmnPGZeW3+bT4pIOyZJGfcN78vklebvQy7hwqZN5ZNiajDKb1jdP/P6Woi6tQJbYPu/TfxZAUKzqiPxUkBLJuH7xXmjGETHTztffaKOpGmqYJL2OsJRIVVtyJ+qAZE9uWxWfIBd7ZxpuiKkI5e+HldS1DaeLwGPntICU6lZ29TSRWd2orK1UyqmrHxca9PZZJZZ/+h8ZVKchvNpwTLNlfaUTaBCrwyAMVseS6+6ADounHoYB28nJa6Jh2
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE45CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B649D6B0005; Wed, 10 Jun 2026 09:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15346B0088; Wed, 10 Jun 2026 09:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F0E6B008A; Wed, 10 Jun 2026 09:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855756B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:17:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DEBF1407CA
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:17:20 +0000 (UTC)
X-FDA: 84864054240.18.5B2B51F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B1DCC0008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:17:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ipUOx04h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781097438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JIynXs9jKTkZFqI4maeQsdqviVHDwx4+PYnRpWMJtSw=;
	b=wp/5w4tHRFawBMh8n2cUzP6XntnYufi7qqxoAnrwssM+a62hop03eDM2YTqmugpS6l8t13
	UnQZ1ugG+ImjUWsIV2RsWYrztF02BRvA1FqRqJxT4o5HIuPM16SKdZEFZSEWeFwdVlPHaw
	L+ndZTcr/M/mt91NrNjWqQt3yUqaWUc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ipUOx04h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781097438;
	b=jmaHWl33Zg9Xp5U4c8roLjduuytVfCyuRkOPZJEWebOhdvz+8T7RqfZ/nPSfgXh1cY08bu
	xDBmBXCd3I/1GIw2FrCDDxglj4emcxMd7EDpa9fTZT1ZRDLiSkgBVPoaLPn+YqC+u1+po0
	p9uY8M1VUQnUicwZFodnqeVqfMGB0tw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781097437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JIynXs9jKTkZFqI4maeQsdqviVHDwx4+PYnRpWMJtSw=;
	b=ipUOx04hIZPPGb7N6wPk8WJ17+noyrP69fyPWOcbt/2eiYod6b88tLSHgIYisYL4e4Vxlo
	/1HsAmKiKbhAaJPELNOnTSg3ksD0BTBf5eA8c47jbvqCUt7OzjyFq6ZVX7GHbal4hguRzW
	09psHfoo+R+YYTwhvgm3l6cAGPqG/BU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-MGR0TvLnOY-bgYuwOcMcoQ-1; Wed, 10 Jun 2026 09:17:16 -0400
X-MC-Unique: MGR0TvLnOY-bgYuwOcMcoQ-1
X-Mimecast-MFC-AGG-ID: MGR0TvLnOY-bgYuwOcMcoQ_1781097435
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490c4f61a34so34212075e9.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781097435; x=1781702235;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JIynXs9jKTkZFqI4maeQsdqviVHDwx4+PYnRpWMJtSw=;
        b=HqSWaJz6mNOJTL3QaizLqj/bvmMy0T30qvO5BrI6VoO8IkerRYi3nzEOzjrA/ydiM9
         GU8PoTiBz+tjHHtDyLPZacYdNUzVVwjDWyqSwHV2yIXzy0S6Ow+Tv6kTgnoFYnQ+4vX2
         Q4BV2AR/cwl1fV6N7J4x7L+RrA+luk++UKvTeGplKDl6OGDY3yAbMgJ5TCTJm6A9O6Gk
         hhPdWAewZFhgwrqOF8xgC9B/CyMCp+JOR86LbncxNveiEfwSeiXj/kDWiSzXIZ9xO3GL
         MYw08P/7CIPt2cBTtThOBr4341vw935NFwMv8BGllZQe1im7GPQKXWvDD3DxjtwNxqw0
         XM0w==
X-Forwarded-Encrypted: i=1; AFNElJ+m4cjYM2GBRsQS+sYkKLUFdUoGvksG7+tK4Lk8y1euTEuwSzO4Q0/QVMzHIKGxpK1S8n/wvK+KRA==@kvack.org
X-Gm-Message-State: AOJu0YxpcrpRWRJpuYw9c3wErRdAeWoZFseSOT3ABra9Ct9h8fvrg472
	pYZBQRQO/5aFaUdXx6bzwHyZPC7lQU8CSVTCvj2nz+TBVTdDLgw90/X0i+Wrv6qNPO46wSf5X7/
	JCI2bAFQDXfPrhrYJmsJehT17P329c71oyD0DlUqVIwNTycJ1Qg71
X-Gm-Gg: Acq92OFq9tynqrFobHMZlBynS7kLvBTY6OmcNvOZh6rzIMIDKLZm7cc0zZ1PkdROwG+
	5W4wjQLGW9sigAnq3yb9p5GMjO7OxkLiKP+MYvZT8WRPxydqNM3nmf8vm6lfEmmVV35pZpWXQE0
	+AhoLg3Lg/B8qiB2JmxyaVCzpbF86aQoYbPcy26nnZ+VwvQLBDCDBdMNoGYMElYjD9k36EggPTa
	lFBhH163WsclWmEMqRYc4zXmbi7RQXQ43iOsZ2TCAUPJJnhXYLHfMK2TEnTodtQO8dPu24FLyiR
	Suv2sPKW/ExLgQaMr+3u3uzQIYi3CsmZMRxQLz0i6cffmYQv64ZfyDnfbeN1YlxtvX5Co+sTQgM
	P+TDirWlsKyti1ges9ZpLSJU0xm2q4wJ5VPSltASJZDqwF+YzqDA3XA==
X-Received: by 2002:a05:600c:c491:b0:490:bb44:3f8b with SMTP id 5b1f17b1804b1-490c2605385mr407783475e9.17.1781097434762;
        Wed, 10 Jun 2026 06:17:14 -0700 (PDT)
X-Received: by 2002:a05:600c:c491:b0:490:bb44:3f8b with SMTP id 5b1f17b1804b1-490c2605385mr407782215e9.17.1781097434064;
        Wed, 10 Jun 2026 06:17:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b82sm595285305e9.1.2026.06.10.06.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 06:17:13 -0700 (PDT)
Date: Wed, 10 Jun 2026 09:17:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio Perez <eperezma@redhat.com>,
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
Subject: [PATCH v2] mm: page_reporting: allow driver to set batch capacity
Message-ID: <cb43adc61d2ed3069b2fe428f3e051dbdc4cc28d.1781097156.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aFLQhAEG4IIt-ooO3eUob1C_aEG-DgqvmlZBgwB8liQ_1781097435
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B1DCC0008
X-Stat-Signature: 7a3zq3pm7e3kxdndos7xhjt99zdqqw3t
X-HE-Tag: 1781097437-412895
X-HE-Meta: U2FsdGVkX187QYPVj2/qxLuBcmkPl+xUpbggiPytqLm2u6TPsywN2qZDcRu65+zihd7QI6IKKHagJiZnJ1McXMMRZlMY9B+4rrPWnYhSpORZPJ8j3oCZz9fEtFCZ0e4qM3CETj3QHRoOKXA/YCuB/3wzcUTDnB3y8PHNUbup0ZBy/AZH6+b9TEDEqli7IIZywSmC6OuJCQ4yTbT/pOMQEX2h1QXla1dEcwGiST7nRdzN97ApDJP44M+NxH9+3fB5mPHPw9ZW5HM2VKFBB9T90K4YlxTsUopCiFD96nNhkUuJTIkWnRZE5cPFGrRBfxwh2nmbuktbY4U9zHaMlaD8FdUhLuMKd7zELDrNpY7N4mL4a7rjmL2Asy8AlC3Dmfb0BAfLCAk+J80LKxKjmARPwyyF9Pw2w1H1Rw9FMSFrPOfOTqCF8xgknh4TdKxry3o5I18rJ+rpZf5/gBhfdu8O7DsbAdd8tNxIyXYMJcLmO6zTsNJIHEXWnfLbemmMfT37cOLnSsrZmyAyOzjQoWrLcDY08bRIaExMoUPSsjAnZj6Wnzo/bSnNE4YeXIWnfbH6Va5EkrWL3VwrQFeWgh1cHpNOUkiIWot0Ucsku8NpHdH/SgyB1pHUUwL1zOEbux1a0t5Ikb23s0YuZwy/Lmnc8PKRLxF00WRudfKdxBDsMund9VJqrAq8xQzgKz38VSCcq9INpW0Ajmwoyjda8GMnWa6cc8ruO7Ew2dmLgt1zElQohFy5xA2nc4+D1Pwac03LNhVQzh2Xvkd13TmUnyrIS2WNU39Vs50g24reEMjXoqCzs5Un1SieJBmhhlyfiGF6yE78DXeeC+8iNx09V4iP2U4gcllvMgpv9fnkNPvuxVtKK0aE7TM4F9NDc6z0Z5QScfqhI9WDV/13XgHFQ97pcXltBdORJDsPT6uowjjZx6A9oYh+Qcve6npPGWamny/QMrBpZ/GZfiQDi/+Qg2S
 GmgFUqGV
 Z3otON+i+I5LvnMHkp7uOYK/BiQ/BBHD1WUCyVyvccLAvqm7nqg4O8+aKQ5cV73cB64u3YSHLnGfZmVYYjr/PSbmPhyqAaQ4ZQLX/qsTsL+1PbX/3FTNMn1JbHxvYresV1QZndBFRv+zzH4xBRz2BI5zPBL7cmVRFctpFyyPTeyOZuE2B11sPJMMJJ8GPxas0+k1e+Svuk8q1VZmgpDOirlZ+Gcm+TYzJjrfaklQBn4dCFrWH9dS8PD+ya1S88oqv5fzwo/4q1v9ub+56pFATxLT2NZbwziUBFhsoPzghaEzbXFmzesJBrpCTb/PoNTOr6DbIJxWWp2iBJBAcgQffNrnWZAJFnUtsm3cv7eyeWDwy2KqpcofjEYeLItoGf74gmHb+WgrbCTxeMpg600Xh6vinAfIU05H3skh7q8VFxmv3F63xgDJwpZnj3rxUe0KGzj+m
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

Capacity need not be a power of two.  Code previously called out
division by PAGE_REPORTING_CAPACITY as cheap since it was a power
of 2, but no performance difference was observed with non-power-of-2
values.

If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
page_reporting_register(), before the reporting work is scheduled,
so we never get division by 0.

Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
Changes v1->v2:
- Document capacity=0 as default in commit log
- Document that capacity need not be a power of two
- Drop unnecessary comment about integer division cost
- Update comment on capacity field: "0 (default) means PAGE_REPORTING_CAPACITY"

 drivers/virtio/virtio_balloon.c |  5 +----
 include/linux/page_reporting.h  |  3 +++
 mm/page_reporting.c             | 24 ++++++++++++------------
 3 files changed, 16 insertions(+), 16 deletions(-)

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
index 9d4ca5c218a0..048578118a4b 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -22,6 +22,9 @@ struct page_reporting_dev_info {
 
 	/* Minimal order of page reporting */
 	unsigned int order;
+
+	/* Max pages per report batch; 0 (default) means PAGE_REPORTING_CAPACITY */
+	unsigned int capacity;
 };
 
 /* Tear-down and bring-up for page reporting devices */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500bb..942e84b6908a 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -173,11 +173,8 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * any pages that may have already been present from the previous
 	 * list processed. This should result in us reporting all pages on
 	 * an idle system in about 30 seconds.
-	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
 	 */
-	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
 
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
@@ -222,10 +219,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		spin_unlock_irq(&zone->lock);
 
 		/* begin processing pages in local list */
-		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
+		err = prdev->report(prdev, sgl, prdev->capacity);
 
 		/* reset offset since the full list was reported */
-		*offset = PAGE_REPORTING_CAPACITY;
+		*offset = prdev->capacity;
 
 		/* update budget to reflect call to report function */
 		budget--;
@@ -234,7 +231,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		spin_lock_irq(&zone->lock);
 
 		/* flush reported pages from the sg list */
-		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
+		page_reporting_drain(prdev, sgl, prdev->capacity, !err);
 
 		/*
 		 * Reset next to first entry, the old next isn't valid
@@ -260,13 +257,13 @@ static int
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
@@ -290,7 +287,7 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 	}
 
 	/* report the leftover pages before going idle */
-	leftover = PAGE_REPORTING_CAPACITY - offset;
+	leftover = prdev->capacity - offset;
 	if (leftover) {
 		sgl = &sgl[offset];
 		err = prdev->report(prdev, sgl, leftover);
@@ -322,11 +319,11 @@ static void page_reporting_process(struct work_struct *work)
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
@@ -377,6 +374,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
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



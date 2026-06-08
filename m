Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACE3CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25146B009B; Mon,  8 Jun 2026 04:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11656B009D; Mon,  8 Jun 2026 04:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BAB6B009E; Mon,  8 Jun 2026 04:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3246B009B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FBD7C3235
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:03 +0000 (UTC)
X-FDA: 84856085286.26.AE68948
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3CAA420003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKXKgou2;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LdI09yfbzRCb1twey6OkL3QcRw2oFWT9IrdWUT5qiU=;
	b=v1iuC4IRF+sM8MjHPX+sakkA8cI7eCBWPBAUfgIKZyh/NlUbpCNb8/SylRFD+iVHo11HTR
	VH+avW3Dj1aM7RsIgVTI38elXDlN3xWcMNw+p/ylB59c/FvNb/mS85e9U2m5nf64nLPyVa
	vPb/6jLuc0rGEizy/GZTtXrluG5o3Xo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907701;
	b=PPULwya5iQUfJt5yVC07GSnM8KyuE08+7V4LWyOdKDkpakMzbUeGEe7/W4/LupdZtqfVNP
	bpAt9llTLJ3oJMrMUD8Z22fzIrmx+S7hhJKdbMSLBUXDZAQwI7wXSYhyyE/h+t0lXYWgrp
	zUnIseuWfTpoYizhjLiWzEOMxlrkPkA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKXKgou2;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LdI09yfbzRCb1twey6OkL3QcRw2oFWT9IrdWUT5qiU=;
	b=DKXKgou2i5/+AhjWscN6hari9eLSz26/2j577Yo/+hTye0MmUV+Ma+fZcKnqQXFDju9ab6
	Uis5gkGT7rfKzwF/F1SB71Wn/fdt5j0VV5O8I7p4w/+qYNShs/nDEid+Quvvym7CGVcGln
	RwA2U2T7TZTW6bZPWYFTPlk+N2KOqvA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-IhaWEBegMJ-vXNrUNoXzXg-1; Mon, 08 Jun 2026 04:34:59 -0400
X-MC-Unique: IhaWEBegMJ-vXNrUNoXzXg-1
X-Mimecast-MFC-AGG-ID: IhaWEBegMJ-vXNrUNoXzXg_1780907698
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45eef10d5ebso1943833f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907698; x=1781512498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/LdI09yfbzRCb1twey6OkL3QcRw2oFWT9IrdWUT5qiU=;
        b=AOR2bRuohT50HAFh7LJXLFWJABH48PAXK3OfapTNFexoDMMwR8N9WuR5wEvL+cW4F+
         FAAM4doAHDz4+2f9vYIXIV3Sf776QekOtO3ReGHx8iDtXJPHoRFNTC8dmjrB4YX4hJN/
         GgbWORcM/fPLcn/NF2aU0iBe2+5zTcUWxDz8S7HTimhXhcxZPV1srDkiSiYWIiS+h7CA
         h+sUph7VjYhST4sixQrtQeSAJVEmC4f3MW8oOoQtBx44aj5u6XHHl7pSUd5suCzZqXap
         6uVvl+75ivse3QlMCLCMXPMwW18AIFeU81kMAP4aE3HBvLeszed6DPv/4/oFLMRSJIzv
         yu2w==
X-Forwarded-Encrypted: i=1; AFNElJ8dDESLpv0q+GQnBe2DoXcw1pVedLH0LG/XjMTc5pxzqZuLsKKGwX9rkbn88/0FrW+PbK6Jn+GyuQ==@kvack.org
X-Gm-Message-State: AOJu0Yyxerz4+dBUlhL0ekjBXKEyXOAezsYHuAh/qFdJdCfaqVJmqJ5G
	US1VC5P5uzzQnTHDuD/3htBIjPbEJ1TGsIgVqu9kQo+XUH69eLhaJ7w13ciPjpCdjE+hvsLhaU4
	pz40weDQVuCmOTwZdTYgm/BhKQMryjTFs6/AE/qzes3vA1TprAN6/
X-Gm-Gg: Acq92OFI2LL/9MoCUrjy/ln2+rTg1wK2LXGCrNqinz/a1y39I6dromdU6PBj52UR7IA
	gpo2+j7maHjRJ08avBv1Hgatf99+ZFzGSwxgtiWV+abPyKhA4VrJX6DCVLDSxQWYFiNDYDTslI0
	pqVQ5+svrCPntd34oSE2WeLUJ9MyKmqVPwUOilmBMUBLSKeAJBB51CE+c7w/KFz9ZkzyLwxh1Ny
	/2izkDwCpPEDChgvxX4Z1My0puRG16S/9R5Pm/O9vpk88sKdZgK9P7xWr5wvwqJxRxSEhx32DHF
	H94hb5rCzADnjNal3qZZRkyWT5CYSGNDEYtl3SoA9uJoJzxI8U3PgabiUAMLsZR2HShRF5fhE3y
	w8wbU4wtYfoUZA3X62+Kc4Gc=
X-Received: by 2002:a5d:660c:0:b0:460:1695:89be with SMTP id ffacd0b85a97d-460302f1a80mr16882972f8f.17.1780907698177;
        Mon, 08 Jun 2026 01:34:58 -0700 (PDT)
X-Received: by 2002:a5d:660c:0:b0:460:1695:89be with SMTP id ffacd0b85a97d-460302f1a80mr16882899f8f.17.1780907697659;
        Mon, 08 Jun 2026 01:34:57 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm53186372f8f.6.2026.06.08.01.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:34:57 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:34:50 -0400
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
Subject: [PATCH v10 04/37] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <776d350bffd86c5776485ffc4f24e668df36367e.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: otBG6wTpRvuO_Yl64AdoWXDQm2w5JKUWNZ29fwCT-Pw_1780907698
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 3CAA420003
X-Rspam-User: 
X-Stat-Signature: 4yfropt1aepzj7beroqyh9fcwf9mryhe
X-Rspamd-Server: rspam08
X-HE-Tag: 1780907701-576285
X-HE-Meta: U2FsdGVkX1+BmdIxsIbrKTpW4PFDeZsPBGBasKSaBxmWmnE4ojHj65/8HtQHY448oOxhRwVVA8DyQ8YlPsbwIS1qQHBR+yWnBOmotWqIuvDyIWBfjguIs6pOMB9NSDBnIQWeb14yE36A5qpylLIIuAhvOT7EQ7aieuJsaeQikoOLmKMuJTi6+rKT6v1Tp1ZXIsY/XXfPf+Z4gXK3chdbkVD+1eR4k26NgmrxeVyBEEAetmp95cCqdFw263mcMTldsq0IC3cjc2GQ7WPmjIWxRKZzxHwf1fWmXS8cCp3lBKdedHdG5ThIemauyXUByP4EhA1tKegfVmQRFfZ70GZPRWddQavrPLboLOkunA18jBwwXOxGaRx9TuO9SeXBINOucPfZF6lxXC8apCReEkD2PVR1JocHWoCEswrlLe0m+LgUlG3XQFSQWGeYJlENs3jJ35U7EnbZ4RGcaa/AtJunfHUEieK6RzHywVI+LBC1SjcfzK7K2mQMF8tK0VYDb3oIGqB5i7kKaHApSNcGnIHDTn4q7Y8ZNuAzLFWvLnYNMHGELMB6iAVmpnrJ9ObHiUWJmkfygqmFiuk8wArvUK+nKaCIarrI62JC5M88TMd6C9ODZTaBwof+UKAYy9E1PwLrEO1va7grdqYa9JEydyvLswOzZKgXPMZGxdDthnFY5R5s8yUo3hvMTB8a4huq3j7RsjQQMWa3JZWYTnAReJI6eSFygcrzR8/IQIQ9Dp+RbnGvvs1V2bea5/uUsWT2R/BnE1hqmBfgFBuajYc03Bdnd09uruQphvRc0Sun7/82vjoaHg0WI47YcvOPk/F2MrviK+RnSWy6JzV3GOzDS8Nf5NKMsdxU1jBsZrZYtHdxVsglw9Jw2oDl4nl1UTW+LWf2WqTA3fzOaV4X/8usiClFbuq2jxDF8ZZWqmsE58cf1RGztKduyoGF0GFp1JDWwtF9HlnT3MksWMEwWC6mxtd
 At2SZeFp
 d22lG1mv4u8O/aDXayth4esRdg9Gn12ECJFn7FGbieiONSoAxm6B1YWi89dKK5Cq6mTVwHiorDzi43jdUnsbiXmmknwmtfKd8pU9+X8F4voELu/g5T/Cpyr4mU6KZtifgYVzuFbQ7ifqMtR5ZYzTHgjYMZO5llJKI7eBqcUiRQFL6JkUrMt5AdJFdmtpXN5w70zn7LPEyV0zB5KwNMcDXbRCjIMLDGeRl2Jby0srPoU6c7BjLS3/V+tYiqpt+pT7n9K3Rofv0KUudPmBmaO9hYhHRhtS9DuHQqbRVMH2GALz5He0BYQqGoiYb+QM0xjedai/TXhxAPlXcDwUHAwRT4JoWRj458J+MgWONPm8CSMWL7WZjA/Tg692bMtClv100xlNTW5VFxmpveryBjNRm4eNnLGy7DKb5DULYoE5X0YgavZwQ3K1ccHhX0/ACFaG/3JiX
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

The value is capped at PAGE_REPORTING_CAPACITY.
If unset (0), defaults to PAGE_REPORTING_CAPACITY.

The virtio_balloon driver sets capacity to the reporting virtqueue
size, letting page_reporting adapt to whatever the device provides.

Note: capacity need not be a power of 2. The DIV_ROUND_UP
in page_reporting_cycle() uses integer division, which the
compiler handles efficiently. Rounding would halve the batch
size for non-power-of-2 virtqueue sizes, wasting capacity.

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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D787CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952056B010A; Mon, 11 May 2026 05:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A136B010C; Mon, 11 May 2026 05:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818BB6B010D; Mon, 11 May 2026 05:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0A36B010A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3732D120663
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:36 +0000 (UTC)
X-FDA: 84754553352.13.355C975
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E3545140002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JyBai0l8;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/f7bc8XiOUNOfql0TOUlaX7QjBdLhxcvl3clNO9GGlQ=;
	b=evLSkxwGrfkh8+1bMGaM/jR+FRQ6fFrIRUn/q72AH/2xeoA28Csl2W6LZkPujjpRNrOcnU
	UM1LLBGQqBM6al4Jik5HrdiahVmNgikrGi/lgWTHeJpGov4SD85l1AqGGUJSl3fS3imX9n
	V7XnR386wh0n+gzzg1l7urmT0NdII/A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JyBai0l8;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490274; a=rsa-sha256;
	cv=none;
	b=2G3mgfIrytzPxQXyvbl9htFbnFfpvtn/19fMQGRGGlPMGwBtq1XM2ilW4mMLqs2ukFvhMk
	dXBCWU2DSGO4QDUWK49DWprfWtbg/TtxhN1aJiCZZ7do3AzamJgNP+hJi0CWkNpcEjNZWw
	0grv6Cet0oZmYcZ/85nrn4pwCKn3Zws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/f7bc8XiOUNOfql0TOUlaX7QjBdLhxcvl3clNO9GGlQ=;
	b=JyBai0l8w+zToh9lZFMdgmfr84a7T83epzYz58//TbtTUbI6mSOYG+t2XziLjsni4m4ET3
	6PBTzepwB9ClSUOG5pFrrjk+lF4CrYQKbm++lWK6VdQ20pzIjJhilNWXCIJUJvNw7HKdDG
	zGl2o6lk3sAxSjnrP7PjyrYVWIcwGLY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-R6erB9FvMz60EKbjmSJ28Q-1; Mon, 11 May 2026 05:04:32 -0400
X-MC-Unique: R6erB9FvMz60EKbjmSJ28Q-1
X-Mimecast-MFC-AGG-ID: R6erB9FvMz60EKbjmSJ28Q_1778490271
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e5df296aeso25009245e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490271; x=1779095071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/f7bc8XiOUNOfql0TOUlaX7QjBdLhxcvl3clNO9GGlQ=;
        b=pe5+08b0mu8S6ibasr4EG4yY7NwXoNDekEdw327BJzpEZGjn9ET2wLss0zsAzMJ//N
         kuXXtClLWgNoGjij+F2t9Om5O+V6AgTmpAgrKQ4bhOHHyo9YZU75ZBoIKiMddmA7E6Jx
         VuFwZTh7q0UrFyyWr0MvCl1T4bvou4Qq3uOcS2V73TIOFeoZZ4v5amnqPEqfQEbzRbpj
         0NYcClJpwj4dZUlpYou/6vEsw+FA4EZSWcINbqA5QoracNM8tx/PBOdXrvHm2qLO2QkL
         DcnP86PtNTrapsOkm/OVfexTL7Mi1XRc01t+JW0ZVpanS6rDgJTtRzYIYnhL49MO/HA1
         1JjA==
X-Forwarded-Encrypted: i=1; AFNElJ9s6xMhnXt4GATC5RH2i7bVum0Cp1jqm3nIu63eU/SmLELEtJ/27iWnCP4MmXKSl2+eADo8kofTeQ==@kvack.org
X-Gm-Message-State: AOJu0YwAgBTbma8Vq4I8NKdbheMTPCIMcVNQ0GhUyu5EhXhwsEqmeC8o
	3KCaJXTjmTfZhaUM/JdTu45z4a5ndCFS92PmGP9S8M4Qnwv9yHeZSh0LaE7FDnEBEKRKnmsLIZE
	zD8z3PcfdQEH1ZULVG7YdYN8qT3vwYjAuP3GZre/qwZ7iN2R76ewa
X-Gm-Gg: Acq92OF2uG2Qv+XMJ32bHWhQPL49PSURC33JZmH9D0j5J+dZxDPTgWReRMs7G+sVXN3
	piHLJsEx82AUpm9kaDsn2F5YxWWjUjaDpNpuwcFWZVjwKeMQ/K8PtpMRh0XctcFLyceJJbqa/u8
	TeHAN994FRYnaIH85RhxcKHkiCwttn1tMh2BGMi6yYptXyjLrAgdpuLA9D7n7eU0mBpFFQ9Utst
	i9l1DbJjYMqiiU43zCRIh3BOnX3xIO+4F/3OVjgOCMwBLBw2N8wMg5piX5qbgeqqKaSgSNg+qXU
	MxAfd+JvBFgYGCTCL4oWIa0L6TNI2efpkUQ4lmZra1uxYBIa352NjnkHkXwhmywBt1ZN1/aKat1
	lUJGqZrnshhtd2xjPHRkxXMRPQdeoIez8v2I3+vTL
X-Received: by 2002:a05:600c:3e86:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48e5dffabcamr278836285e9.9.1778490270543;
        Mon, 11 May 2026 02:04:30 -0700 (PDT)
X-Received: by 2002:a05:600c:3e86:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48e5dffabcamr278835635e9.9.1778490269887;
        Mon, 11 May 2026 02:04:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6f9fbf12sm186458005e9.0.2026.05.11.02.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:29 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:25 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 29/30] virtio_balloon: implement
 VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
Message-ID: <50c8ac1a006cf4167529b0951498c76b8928874f.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fF8cEtIWQSYXMvKgl7roBKkJEbITj-Ej1Y6DhQ6Rzw0_1778490271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3545140002
X-Stat-Signature: noe93oeekyaogh79jzmnby6ofobjo6fb
X-HE-Tag: 1778490273-37370
X-HE-Meta: U2FsdGVkX1/+EWbY/yfeR0wJ2uRvyDRI129tBIK2bQbhZ9pf7RPvrwfnt7kWdU76+kXRx/FIoTzhfaKb7djYPgoCvomlxupuY1UUl/w9rWU7jG4utX5gti1xsRZznIC+UbgHSSkcgn2/MTgBNh5pB8d5Gn9Ra8QVueZPtT3Tb86s+7c4yrRIjbzF24JA78sZ5rbQbOJmGIhAX7U1WDd9g5nNt9Qj+2051Cd5fDEqMluR7TmgyuSyekL1hDvGRYfYjVc6u+A9IqCHMP8O55tjvKdwHYfW9CqttdwFfEFcTHHAO3sF5Ha2kxxXYGgRLbC1/Q9nLgPddj6mIgaPEyZwQPV3WncvGKPil0tbrwGVTllsYZDPv8jEJv+xRO+6/7LOGw+tz3Fm3WqeGPdpmwi/7gIZTaD3KDEz9RJdiypSKtoPTYD6i63pg6vOmluhdseks8o8+ZoZ3vDarPYI6a9T8MqSJLz/CBXdEFHhfQ1RZ5yhHdwyxkBc0imIvkyh3F/kMCXj017iOeoujL5uJsC5mmwaU1cJZ+W/rwdidlSfNFVDfZZfp3anAx67jVCDZVdxb7LyRxzLEqYNe6sqLSmDg0zibzVN6C9B44BSW2Be3666mRRDD5yDJC7yNtWqvSo0q1sG26L7eGaiyBN8EAKoYlhP3lYbWrzUQPM4Kyp6b3psMlnYKmuCa43tNK1iEIobaNUJqhsLm1czPN/hsXs373AgET9gqT0je6/ojPCOTy8FDoMXQtJ8+nQG8WvXVlU+sui5OFjsu/YHP9DZgbHK2IETdapUT+eiCmR18XVZ756V4+Cef17xNFZ+MbKlX3CnoX85i7MT9Qc+CyecMacWGoyORDwrQZN5aJuIbWm9gHs33gh8k4tfIz1o8Sr32uGzjlGpytV5+pXjM+PD1nr1EprsDtj2z/Bk5nCelzI0X4qCt0HgOCxUDDPXtdpvpbuHwCVF7cY5Cv+Pze/id+s
 MP0eSaO5
 NoQ+XEk+k3CGVFe8nK20SpXc5Z6v6DTIRbxp6gE0dRx5/e6TmR23r+UeriWmYOTy6vts8wBrnmlSMeNXuxayDAdoDfFxu8vNNQYmDQDcCpKaXBOjMVwC+De9yIVk+17uTYpg39wkm97aJ45TlH1+BCxOX5dhmP9hQ7TpGIqZN8GZ7PosCS/AbzRfYwQPldb1oemocdIp1cUIF7IjijWv5NvpmkhDq3Vh0QUQRvKPU7PJNcb40NCOMvy8NZrj7AOzwHmnRR2aWi/6/BnFLy9i0E3Fq7lCudhymcqCTXWjITFT9AmcKjOkULPeJaie+U+aNnR9GuZNgmcXe2ZBz6ne4LzbmRUaUiTRTWbLouQh8GEQU2eFWNzBkaV8QvnyxKkSohRT9ZIA9MZeaL7dAAiMej4aeX4dFrD0hkfgZVvbfK5lGt9IT3tqkfaN7+KIbSKiLUbre6N70RSpmmHQUh4Hgyo3o5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the device offers DEVICE_INIT_ON_INFLATE (bit 7), the device
initializes inflated pages and returns a per-page bitmap indicating
which pages were successfully initialized.

The driver appends a device-writable bitmap buffer to each inflate
descriptor chain via virtqueue_add_sgs. After the host acknowledges,
the driver checks bitmap bits (bounded by used_len) and marks pages
with SetPageZeroed.

tell_host() returns used_len from virtqueue_get_buf(). Bitmap reads
are bounded: fill_balloon() and virtballoon_migratepage() only trust
bits within the used_len range.

On deflate, release_pages_balloon checks PageZeroed per page and
uses put_page_zeroed for pages the host initialized, propagating
the zeroed hint to the buddy allocator.

If inflate_vq has fewer than 2 descriptors, probe fails with
-ENOSPC. If PAGE_POISON is negotiated with non-zero poison_val,
the feature is cleared in validate().

See the virtio spec change:
https://lore.kernel.org/all/9c69b992c3dd83dfef3db92cd86b2fd8a0730d48.1777731396.git.mst@redhat.com

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c     | 102 ++++++++++++++++++++++++----
 include/uapi/linux/virtio_balloon.h |   1 +
 2 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1cdb904d60b..284108dbcff1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -121,6 +121,9 @@ struct virtio_balloon {
 	struct virtqueue *reporting_vq;
 	struct page_reporting_dev_info pr_dev_info;
 
+	/* Bitmap returned by host for DEVICE_INIT_ON_INFLATE */
+	DECLARE_BITMAP(inflate_bitmap, VIRTIO_BALLOON_ARRAY_PFNS_MAX);
+
 	/* State for keeping the wakeup_source active while adjusting the balloon */
 	spinlock_t wakeup_lock;
 	bool processing_wakeup_event;
@@ -181,20 +184,30 @@ static void balloon_ack(struct virtqueue *vq)
 	wake_up(&vb->acked);
 }
 
-static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
+static unsigned int tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
-	struct scatterlist sg;
+	struct scatterlist sg_out, sg_in;
+	struct scatterlist *sgs[] = { &sg_out, &sg_in };
 	unsigned int len;
 
-	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
+	sg_init_one(&sg_out, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
-	/* We should always be able to add one buffer to an empty queue. */
-	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	if (vq == vb->inflate_vq &&
+	    virtio_has_feature(vb->vdev,
+			       VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE)) {
+		unsigned int bitmap_bytes;
+
+		bitmap_bytes = DIV_ROUND_UP(vb->num_pfns, 8);
+		bitmap_zero(vb->inflate_bitmap, vb->num_pfns);
+		sg_init_one(&sg_in, vb->inflate_bitmap, bitmap_bytes);
+		virtqueue_add_sgs(vq, sgs, 1, 1, vb, GFP_KERNEL);
+	} else {
+		virtqueue_add_outbuf(vq, &sg_out, 1, vb, GFP_KERNEL);
+	}
 	virtqueue_kick(vq);
 
-	/* When host has read buffer, this completes via balloon_ack */
 	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
-
+	return len;
 }
 
 static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
@@ -297,8 +310,37 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 
 	num_allocated_pages = vb->num_pfns;
 	/* Did we get any? */
-	if (vb->num_pfns != 0)
-		tell_host(vb, vb->inflate_vq);
+	if (vb->num_pfns != 0) {
+		unsigned int used_len = tell_host(vb, vb->inflate_vq);
+
+		if (virtio_has_feature(vb->vdev,
+				       VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE)) {
+			unsigned int i;
+			unsigned int valid_bits = used_len * 8;
+
+			for (i = 0; i < vb->num_pfns;
+			     i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
+				unsigned int pfn, j;
+				bool zeroed = true;
+
+				if (i + VIRTIO_BALLOON_PAGES_PER_PAGE > valid_bits)
+					break;
+				for (j = 0; j < VIRTIO_BALLOON_PAGES_PER_PAGE; j++) {
+					if (!test_bit(i + j, vb->inflate_bitmap)) {
+						zeroed = false;
+						break;
+					}
+				}
+				if (zeroed) {
+					pfn = virtio32_to_cpu(vb->vdev,
+							      vb->pfns[i]);
+					__SetPageZeroed(pfn_to_page(pfn >>
+						(PAGE_SHIFT -
+						 VIRTIO_BALLOON_PFN_SHIFT)));
+				}
+			}
+		}
+	}
 	mutex_unlock(&vb->balloon_lock);
 
 	return num_allocated_pages;
@@ -311,7 +353,12 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 	list_for_each_entry_safe(page, next, pages, lru) {
 		list_del(&page->lru);
-		put_page(page); /* balloon reference */
+		if (PageZeroed(page)) {
+			__ClearPageZeroed(page);
+			put_page_zeroed(page);
+		} else {
+			put_page(page);
+		}
 	}
 }
 
@@ -858,7 +905,25 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
-	tell_host(vb, vb->inflate_vq);
+	{
+		unsigned int used_len = tell_host(vb, vb->inflate_vq);
+
+		if (virtio_has_feature(vb->vdev,
+				       VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) &&
+		    used_len >= DIV_ROUND_UP(VIRTIO_BALLOON_PAGES_PER_PAGE, 8)) {
+			unsigned int j;
+			bool zeroed = true;
+
+			for (j = 0; j < VIRTIO_BALLOON_PAGES_PER_PAGE; j++) {
+				if (!test_bit(j, vb->inflate_bitmap)) {
+					zeroed = false;
+					break;
+				}
+			}
+			if (zeroed)
+				__SetPageZeroed(newpage);
+		}
+	}
 
 	/* balloon's page migration 2nd step -- deflate "page" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
@@ -963,6 +1028,12 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb;
 
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) &&
+	    virtqueue_get_vring_size(vb->inflate_vq) < 2) {
+		err = -ENOSPC;
+		goto out_del_vqs;
+	}
+
 	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		vb->vb_dev_info.adjust_managed_page_count = true;
 #ifdef CONFIG_BALLOON_MIGRATION
@@ -1188,11 +1259,15 @@ static int virtballoon_validate(struct virtio_device *vdev)
 
 	/* Device fills with poison_val, not zeros; disable zeroed hint */
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON) &&
-	    !want_init_on_free())
+	    !want_init_on_free()) {
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE);
+	}
 
-	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE);
+	}
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
@@ -1205,6 +1280,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
 	VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED,
+	VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 13074631f300..cbaf18e0b17c 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -38,6 +38,7 @@
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
 #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 #define VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED	6 /* Device initializes reported pages */
+#define VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE	7 /* Device initializes pages on inflate */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
MST



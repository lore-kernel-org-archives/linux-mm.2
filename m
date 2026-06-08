Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FFCCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A3C6B00DA; Mon,  8 Jun 2026 04:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71816B00DC; Mon,  8 Jun 2026 04:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FF76B00DD; Mon,  8 Jun 2026 04:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83D426B00DA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:41:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4817DA0A3E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:41:08 +0000 (UTC)
X-FDA: 84856100616.24.73DC322
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03BC240002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:41:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8EsqeaM;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AnVGJ057Et7SfWebx9lNogVowiJVkQh33o78IbbqYo=;
	b=QHlF/xt7HgUnWNHCdVaj8OC86WLLha8oopMwuWE3wWaO2URfQfMIflv3+gxvguGpUgSI5W
	dzZAiBsT+jWsBy/Ty0eDyOHCmCjKWs4mHr/f2cN860zFLqLedSYXqZ21d/izGASvI1/E0x
	76nPb7hrhjVcIAMQ6egUhwzhZtU0hVE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908066;
	b=N/nTuaP2wJlgquwAklMk8xfUwZepBn1OIlfsxUhHzKiKuC5spi0nTWBJJzHLpx8xzsTgBc
	iTqU8bAzD38IxXvV77VYeLZO5g5arPHK2nbt+ayMK3BqLgNEx5bO0FV6XFt1SXrmZpSua5
	Fygu963JQe94Xq1w1cOONDctjA0UcYc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8EsqeaM;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4AnVGJ057Et7SfWebx9lNogVowiJVkQh33o78IbbqYo=;
	b=I8EsqeaM5jqdxGuhecUfYsa+g9chAiVYIM95CK9GPSals06lWyJx95EBk4aSj0Y0G6NkK9
	6zPCsmbP2D1dspgoXZ76mZv/0CgveMzqEzU8v81g0gwlyHYxGCjN37M3OEFaUF3DRbHbkO
	GJg2JAmyAQme1wv9/r2ctYvVXhnREFY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-fO4JjnVtN5G-svIjplCAcQ-1; Mon, 08 Jun 2026 04:41:04 -0400
X-MC-Unique: fO4JjnVtN5G-svIjplCAcQ-1
X-Mimecast-MFC-AGG-ID: fO4JjnVtN5G-svIjplCAcQ_1780908063
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-460153ce644so2918235f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908063; x=1781512863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AnVGJ057Et7SfWebx9lNogVowiJVkQh33o78IbbqYo=;
        b=A0juvGGaV2mzNk8qx8uWbMFxvsuYfUtzkYPhsbbsGD+qHRElvqBUZYvRf8hDvse2yU
         Lez8BoISKEiwCLGgQjP6E3CQ8bF4A4thY/maAnLm1ti3tx3Cdq20pEtpr5icAbS+ED+M
         XJwFIni2DYPEslG0YH4ePMXtuu8VsdrVqiZui6mwvX7ETkRM0jAINvP3ACT2TazoA7MH
         W3lmG3G7bwnI1ZjuDbD/sIJCv0KdS9twOY8fvW/rIWS2c3BCF8oSXAxxO3eexr0U2sr/
         eXV4LllAOFNd22DVyP0NnYxwTvzzjGLtlOSlp98rZ0c/0Eftm37MGaStd/n+RrrK34E3
         fF4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9JY0v1OREMW4TurB40yu0EODp/Pk9rhpaBiPD1UxnDAv1AF3UuQwC2bL18IBzxFegNQCVj4Uppgg==@kvack.org
X-Gm-Message-State: AOJu0YxOxsMsFIXs3d5ke5Cn+mSOiCdXYTVEb5Kr2uMLt4FrxGk7fTv2
	6FYedNX3KUwyZUs0KvfKaMIViLDdKQjy3ZIoclNObznANHWeBRqzHP4iaGv5p+WnNXVN1uQIlKN
	9RF3j3r1w/hLlFsKGWE4Dacxx+eXERraIyG2HO4bGaTryyn5MoExB
X-Gm-Gg: Acq92OFTgZydFcJhrRKJgWPa5mesMSPN4WTrzDTrZPjWniOW3iGV0vzdhoM3j+i/vXf
	yH7hcAQi42lKuPBfS088MIRpNoL2MpeEEiYOnmoTZ/goxlOhRVKxcQ8po58G7SxYT2qdR/MOhjS
	Zfig9+FaCVesExBdza0WLVyHe4sDBYTByaX5zlPWmdmhHIlRs3hTu6XYb2Gkw/cu0qeOwVL2mHu
	SW85sZzxJnb3nSC9XxKVfSwYVnAcniKobuGBEUcOtZnJYmmRGpeQhXpxVmtpDAIokv5U5JdoXeu
	qJh4fs0T+kR0ftOXcnAhi9wPhDv8NabADgfTK5a2smZZNqU5F2zVV4qzqmndrJqeewV/kotQ2Ts
	S3NK99++AMz4C+7ctbwAfC6A=
X-Received: by 2002:a05:6000:240f:b0:456:b23d:e57 with SMTP id ffacd0b85a97d-46030182732mr23389924f8f.0.1780908062677;
        Mon, 08 Jun 2026 01:41:02 -0700 (PDT)
X-Received: by 2002:a05:6000:240f:b0:456:b23d:e57 with SMTP id ffacd0b85a97d-46030182732mr23389854f8f.0.1780908062126;
        Mon, 08 Jun 2026 01:41:02 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda363bsm38418630f8f.31.2026.06.08.01.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:41:01 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:54 -0400
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
Subject: [PATCH v10 37/37] virtio_balloon: implement
 VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
Message-ID: <fd320179bc4e66ac2574336b0a76f5a920675b7f.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qpl-ogbEXFDV4lBOiETMZvaIi87RHxTrNYMDY1A5ii0_1780908063
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03BC240002
X-Stat-Signature: ruqyhc71zwwwc7s8qsqz7mid9xyhhemm
X-HE-Tag: 1780908065-749402
X-HE-Meta: U2FsdGVkX19AKHbhGzolp4qdra3utiQM6jkWcUujcvPjmrUe3verzvS/+LgU4P/rMixDUmVp5j5aj4pMMD2eSx5Jmtj2z8UK06yTAydJ7iF5Hj9+5VjrIklvgUz2+wWXhT/QzeAXVKxCTljUibFub+gygblNq3a71dZj8ak3rDHaTfMdULcGl7pAs9nR3/WC1FtHGggIkthrMaxrivr3qSpWd5c73qJlzMUedAiEzQV4nwR2VGoYZFuhHuQpXq3cQ0N9DR3cSqe71ly6c0Kk/alZ+lpLR9xeBDBLwXeP0743xE0DGfgUVnHA9G9PHl+j4YQnR7v/WRjKSNA+P/Y35rwdU/qRTCoiDm8pyDtRSp2L1oQiAk9XtdUSMNmwe8J7HorRVbNueOU43KmgRXz8WyYvO2vGn84kostJ8oG0I9HU8oE33QYV+9CBSdHc9J9SMgUtkCa1oC1GssbqK6JzHUeOPrj6nrK/sqNAURKWPL+AQQRdNaeBNrLKNQajSk9DCA2t0jcod3D1yj8w5M4xJ4oGt3Z9hPfC2ICWnkMWMQr7dvVr69gMaDxLWuPRHNHv0o6RrNkw/ebNvv7eSGtEug2xmXO1IsA1iXYEV9eYMmXo/0wYC/rYneGKqsSv8ZdTwLTuGgXPVi2hX23FwycNGyx2mAX/TsFeLNkiwpltwRB5FP4f1I58co3UQjR0YbI7nAfFk681qUd2oKwUQR1uNB0qynj6ksLS9ieEo9NSV87O9qXLxCbYd3BssMRvdG55RiIsFZlrylVGZzA06L9Z6Ms6wBdI2VBRRActGjpMuJSSXHsttBVdNX2oLTgiYYaRK0D/Vcq/f9EG+KFQNeCqax98u6sbelxaEYzh9iHg/B2ONzNwtb8b2MEu11DouMkalr3KGJJqL06RKWF/7IT0j6je5x3q8YSPrxCPpE9DBxCv8ZNExXKvrBuwMHe+txtdoSlokTTHeYlUbsL5SYe
 vn+SSgsk
 jgtGlcTyUfZkvcuCY660Qe6g3U6QIvTn5w4T5YzOvOe3UZZW/5ySGO/osttPivbpcDh6cAH/w/QmxL70iRbPDIMisaRx0i2rWO8M3TGyYipamEu321OPSK9VTHqT1I52SbfL0L3hJ96w22kqzzVqgzwMg7SxvQQGiPqJ0cvis0GJbr/XaAiJvsSLIJubUaAj8Bgek5DpimOmCm5L0jFP93qkMw5ZiCdSLJ+gbEZuZOlISKc4voDk7Jv/e9iXc43cZJb5flqAvdaCi/2P9W7k/eAgacQRwqkpcn7Zi2Kx+bNm90ORnrrIWvLCnbM0CKJlckin3ConxhAW6077IO+fO5gzpXLIUAIUYdaFdm59ir+FE2JODpAZyWZkV4rR/Xl/dMrUIPXmdkIGOsPgbcDdcfnUpH4PMGqZfm/3dA7t3ye/eGgJRuPueYmtnJgUMefW3A8cieqjzMebDHTN2JTKKeaymOg==
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
 drivers/virtio/virtio_balloon.c     | 107 ++++++++++++++++++++++++----
 include/linux/page-flags.h          |   1 +
 include/uapi/linux/virtio_balloon.h |   1 +
 3 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index bf1172ad5419..0cd4fd06ca2d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
 #include <linux/cc_platform.h>
+#include <asm-generic/bitops/le.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -122,6 +123,13 @@ struct virtio_balloon {
 	struct virtqueue *reporting_vq;
 	struct page_reporting_dev_info pr_dev_info;
 
+	/* No DMA alignment needed: ACCESS_PLATFORM is cleared,
+	 * so virtio bypasses the DMA API.  If this ever changes,
+	 * add ____dma_from_device_aligned here.
+	 */
+	/* Bitmap returned by host for DEVICE_INIT_ON_INFLATE */
+	DECLARE_BITMAP(inflate_bitmap, VIRTIO_BALLOON_ARRAY_PFNS_MAX);
+
 	/* State for keeping the wakeup_source active while adjusting the balloon */
 	spinlock_t wakeup_lock;
 	bool processing_wakeup_event;
@@ -182,22 +190,33 @@ static void balloon_ack(struct virtqueue *vq)
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
 
 	/* We made sure the vq is large enough so we should always
 	 * be able to add one buffer to an empty queue.
 	 */
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
@@ -300,8 +319,37 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 
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
+					if (!test_bit_le(i + j, vb->inflate_bitmap)) {
+						zeroed = false;
+						break;
+					}
+				}
+				if (zeroed) {
+					pfn = virtio32_to_cpu(vb->vdev,
+							      vb->pfns[i]);
+					SetPageZeroed(pfn_to_page(pfn >>
+						(PAGE_SHIFT -
+						 VIRTIO_BALLOON_PFN_SHIFT)));
+				}
+			}
+		}
+	}
 	mutex_unlock(&vb->balloon_lock);
 
 	return num_allocated_pages;
@@ -314,7 +362,12 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 	list_for_each_entry_safe(page, next, pages, lru) {
 		list_del(&page->lru);
-		put_page(page); /* balloon reference */
+		if (PageZeroed(page)) {
+			ClearPageZeroed(page);
+			put_page_zeroed(page);
+		} else {
+			put_page(page);
+		}
 	}
 }
 
@@ -861,8 +914,27 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
-	tell_host(vb, vb->inflate_vq);
+	{
+		unsigned int used_len = tell_host(vb, vb->inflate_vq);
 
+		if (virtio_has_feature(vb->vdev,
+				       VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) &&
+		    used_len >= DIV_ROUND_UP(VIRTIO_BALLOON_PAGES_PER_PAGE, 8)) {
+			unsigned int j;
+			bool zeroed = true;
+
+			for (j = 0; j < VIRTIO_BALLOON_PAGES_PER_PAGE; j++) {
+				if (!test_bit_le(j, vb->inflate_bitmap)) {
+					zeroed = false;
+					break;
+				}
+			}
+			if (zeroed)
+				SetPageZeroed(newpage);
+		}
+	}
+
+	ClearPageZeroed(page);
 	/* balloon's page migration 2nd step -- deflate "page" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, page);
@@ -966,6 +1038,12 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
@@ -1191,11 +1269,15 @@ static int virtballoon_validate(struct virtio_device *vdev)
 
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
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
@@ -1215,6 +1297,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
 	VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED,
+	VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9365d59ac1d6..caecf0fbf0e2 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -680,6 +680,7 @@ FOLIO_FLAG_FALSE(idle)
  * uses this to skip redundant zeroing in post_alloc_hook().
  */
 __PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+SETPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
 CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
 #define __PG_ZEROED (1UL << PG_zeroed)
 
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



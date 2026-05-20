Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86D8CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5CC6B00CE; Wed, 20 May 2026 18:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D516B00CF; Wed, 20 May 2026 18:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3ED6B00D0; Wed, 20 May 2026 18:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396076B00CE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DC40140456
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:44 +0000 (UTC)
X-FDA: 84789226368.10.53D8FFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5A3F100005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+GMXOjl;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vswTwl3UmjKbzRe2lrt2y8QDjC9hyCS6oEWOwDRxv4k=;
	b=etk8aDFbV38Vy8lr7Tgz2UCYDZXUittWHP+dCP1v0Uqg8R7KP3ujNn/90X1t0I3/A7BlK8
	EmQitNJ2ZRb+0uGgK3x3ptSvLMizonHGsMApYSY1LPw0vyKP6Jtu+xQTS8QNiUR+krzTm1
	uMjYXm9RoHvF6502wTGHyYT4aZ1JuO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315821; a=rsa-sha256;
	cv=none;
	b=jaBjl7RikHHD8ZlxF+oR0I0XhQNef1+nxchJGK7cuU7tSn6p+azDRzu82BXLMG9hu+27bB
	viYAGg794rUIabq1umFEbME57WuVkB7eUSLr+80CMcNrWjEEgITKgmtqOaF2eB/Lcxemia
	sNsLzKbkawGSH6ZRLt+by5c3nt4dSL4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+GMXOjl;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vswTwl3UmjKbzRe2lrt2y8QDjC9hyCS6oEWOwDRxv4k=;
	b=S+GMXOjlKhKCtNbIFe55Nebb6ug4yj7Uce4WKlnMGHZRiccSMsB76IfMWZUaRQOjk+EvW8
	rdj8PymXjcciAMp+o+hawwrhD7xB5jaPxqlIh66GCyz41ZsW87BomPl6+MOrAWGqaCZMgI
	kyYapcO2Rn5wornOv2cLbq8EtsQ7P14=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-TOTLxInkMj-z9B0mAm8uYA-1; Wed, 20 May 2026 18:23:39 -0400
X-MC-Unique: TOTLxInkMj-z9B0mAm8uYA-1
X-Mimecast-MFC-AGG-ID: TOTLxInkMj-z9B0mAm8uYA_1779315819
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-449dcfe8005so4323791f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315818; x=1779920618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vswTwl3UmjKbzRe2lrt2y8QDjC9hyCS6oEWOwDRxv4k=;
        b=eveHvlXCGmn9yxbYwamWEE8LrMPiKmJRU/FexdNdRSkjkTfX0Y1p3mHqimLg8XmyGG
         NNKJ7AXzeFJbeC7d+5kzliqn/HB0Uj8QaBIroY/x1pxp6vUSgVKuy40TH8r7WpfLug7m
         y+00GvKRzNgB5GgYhVFPA/Jwq+jtKUxuGJN1O3euP0GJT7+2Rs0+1I0Jk4Xq6BTiKQnx
         daw8Jz7nFKsQBH2YcTC5w0bgXW3V4DfnVvpMuBIb8Czm2Xd7fZRQIuetPrGCkKvIh38Q
         UPBHhBQROV1y3fxgRvN07utPPYmIpIGvEqgPxRqvg7VTME84Fhy822diYKSlKaIe/kWQ
         LCzg==
X-Forwarded-Encrypted: i=1; AFNElJ/AxvEUNmKy7xbcZhiJKPlfHqJz+6UsITU6tLQQQj+tFzeL+7xMSGT6mplkvYDvM/YFrMDDXx9voQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9wFL/s4E4qXFUeGGodM49DgL8dvhi3Vr1z4sgVdoMPbfPJXhs
	Wlh0BrhI7tL40xik6ZmZDXEjxljKIscuFxkUuh5yApDcxUtqTX/vTIRcQF+MQWeoq5+avisQAa0
	Mr0pGsfIVKk64aaXAriyhqBaR59xVncF7PJDp7BZ0JrpcRPv0MCJ8
X-Gm-Gg: Acq92OHm+SRXoHInWLs7AGZJrSQ9S/k9ksnYfHaI6ra9XKa/RCFdeeWtYHAw/Ln23Qy
	CGBuYxbH2vjGnfSepK0ctxnhg3286lLWuzSPPZWZ+uwks6obMdtUGH9hkpKU5FxZBw39bZSLosL
	6wAa9hyF2NmmX3SZ1tIMCDK1MTLMYMq/ySCVakyechsLJ6FaEbiv9bYwiVLRBN9swzHOccJfYP0
	YoCGojihsreDIWe3/Sx/W6LoedS3uz+PbFh2ID6jFA9S3m0AtIvRKEz5IWxutwZMJZR9gUyKF7h
	uSyGjmEualiFEH+KV2eDnnf1YRPJCcBE8xgnrjSSVjauDOGUDwk6Go7O+sttjoeqW6SuyO6nPlH
	YkxIhNdRgxR1qrIbOq3NyzwUCksPNU9GSuyFW5OH4lr8OribJpUDxtA==
X-Received: by 2002:a05:6000:2912:b0:441:1e41:19c with SMTP id ffacd0b85a97d-45ea3aeb9b1mr279087f8f.20.1779315818459;
        Wed, 20 May 2026 15:23:38 -0700 (PDT)
X-Received: by 2002:a05:6000:2912:b0:441:1e41:19c with SMTP id ffacd0b85a97d-45ea3aeb9b1mr279019f8f.20.1779315817859;
        Wed, 20 May 2026 15:23:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45e7c22d8b7sm28194903f8f.6.2026.05.20.15.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:37 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:33 -0400
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
Subject: [PATCH v8 36/37] virtio_balloon: implement
 VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
Message-ID: <2536c13da81f68ba400221bc7370d68365de3817.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QpoDCSge8HunuggutvGfpbr4cwCOtgSLcL7UcRK9ExY_1779315819
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5A3F100005
X-Rspam-User: 
X-Stat-Signature: 66jgrfjni9yxotu7jh5wb7of8xa59sx8
X-HE-Tag: 1779315821-207318
X-HE-Meta: U2FsdGVkX1/gWIaDW5kI2LZizdp2sv5wOTW/PPZin4+v/QhOz4/WIDmtahLADsnvojwEqG2KbbP/VG2cAn35Uuf+mp3bP/UpCXZLnZtjvE5vZWndjwN2cFzd1BMWCywxXqJZ/Msq21w94otT70pFu/c1I4sBMyej9pz323xXZkllsj6dPCmYq1FbjEbAe+AjG+7pqJKCwaE6CvhaRR/BJkxUPUbzAk9i9+l9H6N5FVmQDz1+KW0/pvQIdlTqYZ7Ux3oUG59cmByLPV1b7Dh2r/kfZ5nqfdPU7CafynaYS4y8tCguSy8n/73E610K6lFonuco2wrQR51xPP3rNCAKiD7JNTUELsQBpKnGtq6GhVc/FLpzRHmFqsUqNLfjyDu2KtP/AJFWcHo3DhgAmlVhgdQduemrKKm+5lznAunhEwrdh6KlY4PtKxO2GwTyFN7I2Q6tAfnwkikiivToFEoAp2Ow/gdMqOZkogUlR/wbfcQ7ykybVYC0AjicfU+9Lj+GZeuA8Vr6eBs0jZYpVnozU6hSSFJI3HOYWe5Fx7/eeUx+YdpGL8sk1FENdxu9PjQ/F2AwnqNEVa7pKsLoQFTMfYsVVXGtvqG26RcrqCzGJd6DbdhgYPj1DwbFz9cdab0r0CzF/JVhbD209B9JBCGajfDZwcBdRlMAKhz5bZVExwi2PYOs2aUxXjm9ue8qbFnDgwXiCOzLLT6Q5f6CRZsTmHLNLiGoPOS9W6pZ/vn39tiKyW3NpZQuZgdoweEtEH7empID2aCPGbGiOwSWypWUfvUT7zcfkd9pRpAfiJAK5KHvUQYrU7cPo5tYEfMPAAz9S1/H50ylHbfN8fumml8PeBwmBhGHX3fgRCFIiXVN7TgSRvDbD6fEjCreMNfMd/JCzDsir9Ob/s+JAOpFWXPt5OZ2G3Nhb6qCXja7TEIGhT0GSEgJWjVXzlGZnKdcg3CUk+uk5av/KaxGM2q3Uy9
 DiL91zk2
 jbR0HUv7cTGgdw32ZI9xode2cBmwPqkDo6nelnCgpbpbufKVRmfXKfw/MavFLKSQq7i7KGBK2Hp69X6zlp18vStX3uqr4/5UtkEWvkypIUhdfmOU50I7ELfSelkNEsvxx9mSQ2KUz1wrXiqNw5710gzOFUvx5Y/7Fom5EFhnCNJJ/YA6XE/GKGiFKjrK7N8EuM3JbMbs12bkNqziF144bd748TCSgh9Pf5sOf2B6y28SHbV1jWwD3bLz3ZVlPrMsboUbiYdT04i9/00ltcm1o92sWMmEosc9XX895cnUJosAuJhw3vL3dCdA/qzHY3IE6GIb9oSyOVcv+LcHVWe5akOZjXIq6NJKr5/WfUgAVtPI1xeUUAzcGjeZ/ntiPmXQ1TsGT7J1BWylH47ZcqJQwvdTk7W/wbOtP4+MFd4NEQpag3keKRIW083cl2GwNRtit/FQ1na8LI/k8KbPhfjjOc+hJpA==
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
 include/uapi/linux/virtio_balloon.h |   1 +
 2 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index bf1172ad5419..4abc7b3b991c 100644
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
+					__SetPageZeroed(pfn_to_page(pfn >>
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
+			__ClearPageZeroed(page);
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
+				__SetPageZeroed(newpage);
+		}
+	}
+
+	__ClearPageZeroed(page);
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



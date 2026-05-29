Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B921CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0626B0103; Fri, 29 May 2026 11:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7676B0104; Fri, 29 May 2026 11:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696436B0105; Fri, 29 May 2026 11:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 576516B0103
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16701401BB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:41 +0000 (UTC)
X-FDA: 84820832082.01.5EC4822
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id BBF091A0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rn7TecRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5iRhiSdz01WKxZI1toNz5FYne+GoBDYJal3naikSkE=;
	b=xKy35B6GTZvLUWZ3PsZxm8+9JNreJnYGcIaTD/aaYtb1hSg1rXT6Lf11wQsohCbrRqXA36
	aJ0sVA/Cdx/H3FvOYb8JO8Pq9uX7ZhGWpaawJpRrAjTwU5x640QN/nnTc8lAgTfU8gKhos
	uuUwbJ2Wd3Z9OSSriUEkdvo8fc1yAyg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rn7TecRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068338; a=rsa-sha256;
	cv=none;
	b=nrKTNiX8lFBpmWitQrjUMhwHjnmYVLwNXSrx/tHNWC90IsuW2J1Tj5bPnYmsjpHKnbQjAA
	pHVkZgDwWK/12HaUdYVzmRddsujQZdo575fZKIsT3bkyEONL3HqILkcvBeC+SqyYSEMdO7
	xxGof5GXhZvAhIeGiTFkVt77bjnNcrw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a5iRhiSdz01WKxZI1toNz5FYne+GoBDYJal3naikSkE=;
	b=Rn7TecRZS96f6rrQP0VNoqKJSlOHesQHfyzCHkeNIQH3icznkdu5vxTiYKsWKioly9P7ec
	5rDswUGMgUkEbBHZU37YDC0+PfNAFcwaWG2qB+o1OSeBajDJvd0HbxOUefI7DcALOlkjCF
	Un5Lz0urADjemIcE6d9ElPs6vSd1FBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-FRisvqYiPBS1L_O2Uj0qGg-1; Fri, 29 May 2026 11:25:36 -0400
X-MC-Unique: FRisvqYiPBS1L_O2Uj0qGg-1
X-Mimecast-MFC-AGG-ID: FRisvqYiPBS1L_O2Uj0qGg_1780068336
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490402ae2c1so77893955e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068335; x=1780673135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5iRhiSdz01WKxZI1toNz5FYne+GoBDYJal3naikSkE=;
        b=qWVWUXx2T42Hs8ZtgdWxq7nmk7Z2E2zgXu4MB6Cu6lpweF8FWNz4WHaDj70XvyoRxp
         ptpnapXA28kyaJQ4HtxgL00ojDUJALghyoMactMONsu9lkIlIpwrxhSAEDZc2U+B2VRq
         AZSndZNvaGVprFCqfM8XR1gGNdZ1FWBArhdzPkZtamfG0SuCCoPgMTaHKagUQD5J1/y9
         d3k+6Rkd4Udww3JMYsjzsGKT/K2rqsuYaSrEHsN1Op7Y1a1+1kFSLcdfdMrvC8wq8DxM
         CbVOuReWFVlmomkmc5+X3d++IKJuFYO/p7KaU0l5iANKgIW36Uszf4jenujlpTrZILq/
         RehQ==
X-Forwarded-Encrypted: i=1; AFNElJ85zvGPZEs2EdjDnjd6V1PXhb9yuUcCVFsgf6M8JgFytKf7g/nE+a83MOsQlVRetnRhq0KCJ94Gcg==@kvack.org
X-Gm-Message-State: AOJu0YyB/BaHVhLQJuXLW/V5yWCvGyY9v3dE+W/7Glep0BQcdoLNZkfL
	k1+cJwBSWarYP3Nb23T6h3YuKHBi9/xo5ZTrJOQE0wQ3fS4COTzYjxcPoFB9OYLB3Os35T+lbEO
	PFWlGrAbUZeUqXr2D+kEJvsenqC4xM0ra356Gzu1/wEEhe5zMLCNW
X-Gm-Gg: Acq92OEvZ9QlRSmx4LgZs8HbkxN33izL7eqnYNLzyQ1Qu3Xx/w3YCjirLU2+ygeGili
	5qkBPQ5shPMrjVvdBHsMPMzt4crRWfZt/YfGbDbZrylSCBh5pWEHSZEhAU5SvNdteLFiUPfiwGk
	GpPHGKNpDOod6PQAedUQLyjT3V1Yw17lCx0KD+kio3Ak8bM1drwWnOJVp9QIJXbUm7s906cz5Ot
	b0z2TIpJ80eeDt2oA4jL8r1RvcKJLwdKqLcl0YyBi8UYr11XaYp1aqtAXQ30YCTQuly2fgV9MnF
	ldEyvq5iqMdhnw+UJscowg/+5CvagfD7WR6hNIAWT6B1GJ9lArzKTdmAcR1lu1EagALgDpr5lZ9
	aED82/DUHTsU9owKeBkvtD2mLp3siYTIboJta2EAtz4FAJmlWc557Ug==
X-Received: by 2002:a05:600c:3b18:b0:490:8b0b:d3b1 with SMTP id 5b1f17b1804b1-4909c62909bmr43943175e9.12.1780068335385;
        Fri, 29 May 2026 08:25:35 -0700 (PDT)
X-Received: by 2002:a05:600c:3b18:b0:490:8b0b:d3b1 with SMTP id 5b1f17b1804b1-4909c62909bmr43942545e9.12.1780068334819;
        Fri, 29 May 2026 08:25:34 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6975e2sm75889295e9.6.2026.05.29.08.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:34 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:29 -0400
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
Subject: [PATCH v9 37/37] virtio_balloon: implement
 VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
Message-ID: <37a5da77b003cfecc4e46eb1886f46b4b79fb95b.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7gUjadu5tPo9-Hz2qQRNU5KvCvltq7bHBuDzO9823do_1780068336
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBF091A0005
X-Stat-Signature: rrzds5bzna3fxpbhes6xntma7qb8jhep
X-Rspam-User: 
X-HE-Tag: 1780068338-233104
X-HE-Meta: U2FsdGVkX1/LxlFJNiHY1Qi/pbSUtjRPAmIbjZnELyeymX78HlfuyC9nq5zcOqzlrGljLQeqkLCIvzAmqM0yBlQcYfiIUkNS40BzbNEoMKd6+/iLVqxOZtGbaywRkx6QL1/CahqEyAlovrSXcqBHmd4Y24zDALWNNwhees+mHj9xlnDSjw79EJDmLSc9PIF9W7JLCEsxJU5BG6haXUxV/9MQKoAeuJg03v3gnxa7Fg72TATC/tFt+CIpVbhOCEQncyhsXR9IrTkeOSSs25Cd7Fz5ExY99XCzu6Qy8CbnePmTMdkQUEFVQ6rnM80WBcx5QvMbz4p24EZIgCPXw/hwM2h/IOxvE0bDx0zPhEtaNdamIpUgTf+1T04ha/8DG6VilhfgOir7QzfwW2iv+8gWRN832r/daCBgRoY9swMUjZlNj3nzVLf+Y+blnafp1eEryRR1n5VInfNwZm2cgNEMxka2ob11jQuQoPaW4oVvF7YmzpPI30+RknAPW8ys+rvBVfmrpAN15FUObS74ayybJNDEqVSosnWBEpIMrAvLYM+S7/C/QIibxfHRLRq64A4ETlsCrX8dTlphzqSKkqw71WTyFPJOIeo8qAragZS/1LibRHAGwLrr6RUVyqspglFl0JF0DflwBbBLAAzWeEU+n5EHkqYvcHXBoXIhbaJFWP0M4LRGVrHYXI50jTIHW56IUnQdQZh9gwk95sy5Zto2FJOuEzh9BBZuyr7THotjKBjs+fM8+kyyi5OoY3+QpyLyfMKEYLdBoLB3IwUKg8gNb9M/4EX+Le7MCYxbiT+JX7QpcHlwoUmbf8Khy2oWmNkOmBqwy5V3UQs/KyjQXFJqO/nIm+PzI8jz24CsNV0Pq4hUEpFxBoSHh1BHe6CRLNR3p+EhQjhorl11pQGZGIQqnRd+5bCX8PSNuMbg8NDDPwH4T2YKWd/u0I41rzqizz5apRZPvVavwnxqKNMrIcn
 VjqB6hmj
 i69UOCfhsTrm26u7WXIdxoNiDLZijaWAHCpuQKTG4qmAsqlWZCJAkdnQgt2rrY5RIVNuFi1CAGT+pSk12QQFO+AYb/3dlTdGuHYd4wO/+L0JppgU3cBbd/5oAZBEPck8SaMX/p2kVTZjknZR/zvmDHOcaFDOTwAiBG4NvYT7IaAFu6tGFYVdF4VtzzK2ey2tmOMW/uEYJpxRMzAfz1HPCk28CvgWj1J0nmB/GbzajeysPMiKsF12CuMJyRMTw5rzz2iOV4ydmrUbuI1ydSRKYYuNpYJyBXhuHWR5XHnmW/fthmCoTKy0p5/gbnuZKIGB0v2G1Ug5Wnwb38xf4qp4usmQ1tfJnDDoxPNfseBM3KV/iUOTLhkNQF4y+DiU7wIjIZOVNQn8cVBfqjJq/jiRdMThaeepPK0eulwWbx3B2q9YeBelioLjBV4HUBSdCA9pFxpv/UihK90tEhvKHw0NaWp7E5A==
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

__SetPageZeroed on inflated pages is non-atomic but safe:
the balloon owns the page exclusively at this point.

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



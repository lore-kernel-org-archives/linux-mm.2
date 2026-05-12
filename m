Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0D4CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53F16B00D2; Tue, 12 May 2026 17:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BB96B00D4; Tue, 12 May 2026 17:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40F36B00D5; Tue, 12 May 2026 17:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92DF06B00D2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A672140301
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:57 +0000 (UTC)
X-FDA: 84760004994.15.BDDED53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BF2320007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1LIfdjj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5u/iM8du1/MGgA4/nGZcoKT5QLcOlAuJz0gbPaxdLE=;
	b=4SJOtjbcmIXIf6PTvxpwfwkncxxmCnB9W/EAumlT9dRI8y9ei276N+CuoMz1jnLpoI72SL
	8Up5LU2JbGo0xN1y6qDsLspBe8QYCHjiAliK+3x9yguQ6ILelcmwxa64MRyfzATjjIsT2g
	/srAhDCo70bYNTgg+oePCvsAWzd34mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620075; a=rsa-sha256;
	cv=none;
	b=VRdrX+KO2Lyz4juM1Bsv5HgvlD0zLdkkzwGGWU09MqlTXyQaZOam6rEORmpM1j+Tyk4XgF
	KoRxjPUImCTrupw7P7lRlulJkP32YBdmX87zfFsdEt6iYle4l5Ukw+48ZJEGikWrtdaROG
	gmw5T/WMUlfsgOAmNxcx1Dc8eu3XYfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1LIfdjj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M5u/iM8du1/MGgA4/nGZcoKT5QLcOlAuJz0gbPaxdLE=;
	b=B1LIfdjjh3Dejup3jXLerFwKvsWhrRg2tLHgVNTvYRAtW0FJ6TPWLPvBNuaS5VPByxOyyo
	IZE7fnkRaC1+C2XFtfSaWWDCA6q74dAgeZV8/QwoU/ks0QMq82ESCP56n79cK+0c1768OG
	sAueehFW70HHdSqx6gQ9ZnoA5PQEUfM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-iHu2lp6pOLO9Wfc7vIvfFQ-1; Tue, 12 May 2026 17:07:53 -0400
X-MC-Unique: iHu2lp6pOLO9Wfc7vIvfFQ-1
X-Mimecast-MFC-AGG-ID: iHu2lp6pOLO9Wfc7vIvfFQ_1778620072
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so65886625e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620072; x=1779224872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5u/iM8du1/MGgA4/nGZcoKT5QLcOlAuJz0gbPaxdLE=;
        b=mltUQNuxKaJgG3dzW+8yDVvI1q2TLdctiZrabqagkz26QQbN1nSGeLXvW6F2kyKOMp
         GdSEOeROi7BysXprHLleaDJVCn5cU0GAegAdTiy27LSKyOZrR25iTVwAwpP53yd7LOHX
         VkFctG4bu1+8CuRXlQDniR4CqX9Z9MWbW763OWgKAwOo8ia26EXhrFbpH2d0j+ic02PY
         67EUvRKPkaKzTVdo9nLX74gB5NW/4q2S+2WEwxcUV06QqnmjV6JRuV/LGMpCJsHmZ2tO
         EXgdvjPMHTd1JZXsi9IOv7ubdWaCnlEblru2ymAk1fNRpRYI6s6ZqZMPaTTKp5PT/khn
         k+mg==
X-Forwarded-Encrypted: i=1; AFNElJ8jEqW4blZqOS58NWOZSMOyWSTGuLQ77nHmteP4wOl8/UH0Y1cRRm31+UT3Q/Dx8fl/3OOvfWCgzg==@kvack.org
X-Gm-Message-State: AOJu0Yyeg6tx+EsvE4mn9ysClYBp3P1PX9DRKjZ+j0oGX0Y94hGHjtSY
	RIuPp1efMs6TRh6ePQe/Gwp86JoL37karDX6Zbq41DaH1THrDAH0uhfIe3xEv7U2NrfXVP3mDKm
	XURamq0AWIc1fbWt8ggHCi9BEph8jrlNyJhSiYgXQk1MnDV1zDKhG
X-Gm-Gg: Acq92OHvAGVYFaIlqg7IzAuMkJ1fmsuHAZAt7lzGr/nJWAvcNLd7SE/Arty3Q4rae/D
	1vzx2SwzktCaY6ba2Venh6Fo65zoL4nuiG7a6eGDNCuQDDh85NrnqJVr5Q0ITKxrHsypFtj4N+E
	1pfCo6t0dSZSCOmX+Hi8/7BDuib8PGBtdIzc8iPs9xTEVh328NenrEAqlGS1zoQ8dDL+EwJ4p36
	kemrSHAg7kNo/vZfjH9YEbzulUKo15iuVEhZNNT7ELgDck7bUjHAfBXmyWtSWpHpWpGb7bMQiCr
	TAUwiTxtVnQAKFl8MFsvcs0zhwsY7QltNDl/TtpcovMliSiA+vFxAAliqAXfKXQh7jc8xc/Nk+y
	lmuFQQbJ5MdbFN/1C3KaTFT4X8U2fUlGOHMJyrfEe
X-Received: by 2002:a05:600c:c08e:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48fc9a5350bmr4617535e9.27.1778620072001;
        Tue, 12 May 2026 14:07:52 -0700 (PDT)
X-Received: by 2002:a05:600c:c08e:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48fc9a5350bmr4617055e9.27.1778620071492;
        Tue, 12 May 2026 14:07:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e4bbebdsm38944373f8f.5.2026.05.12.14.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:51 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:46 -0400
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
Subject: [PATCH v7 30/31] virtio_balloon: implement
 VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
Message-ID: <3b2729a80c19e634f9bc93ca2a8baed8cd760b45.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zPpqSj_kmx84SGflLdC33Ng0zqsgV5-h25kLiUVbtpo_1778620072
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BF2320007
X-Rspamd-Server: rspam04
X-Stat-Signature: oz6byi8ruo55ppmetk3pmwmftaxz1s5q
X-HE-Tag: 1778620075-144422
X-HE-Meta: U2FsdGVkX1+PN0bji2p1XbcsQFCL7D/U0p1yBP5K/u6ymVkstEkoaiMWZ5GovHdWGWlpa7WyUqpHvc+lwygIrqgpmJOGNnkVLGBoYVJfVwrrDV3IF6W/aU/OYeqBr8LRvWx+kPH1f7FDGPMzroaafotse0zj0LQctGT7m1DaFO/8PUSIOgiynMD+7Lyvi1Vp5ge852HlLfstx4dsF4W7La/d6gaO4C+8eyuQl63y1FU3c8sVK1QKygN2jD2IpLXO+eBzKQzYb71cwMZO7gPdjHbwreCG8p1HBJfkMrZuD6ebNXBYqNRAtA+HxyDCxDixT8DrW6C3+oDkopIgRTIisciT3WxY4RW2fNYQwUtS1jDcJHMLQNtQB+v74l7KvWBu3MaWctHbwjd5e/NRkeu38f96Vx4uZdefeNdPGdOwRSmidOhFoFQzc9JK8/qkyRLP/oKRrh8FCBMfiFLTshwQIxTJ9bejQVR3FHEiqGpfnz97K2KctDI34EWwNoZz3JM2HEGgekjAMG5zL/jXLq1/QuJ/l1Ax8QU4fOKAjFaIHe3416dOojgNSD7z/Qp/+VmqFFhVPf9VE+jRERmDzjLUN//v/CDjvUeueOOOW0Jc+rr+jX5ns10VpE4Iwrr3zgbdHjvM0bWKKeNaIVMlLCLFJzwAiUM6Ytqj6chcGo7BeOhiAuoMLeHt/DCci31CpmYqgBMtxdY2rVO6jslL9rndsBFgK2jRJb/UbVywswwt4YVAPSrbXryg9RbKrpWKAbVOO0FxtQbDsqPTfvXFqPWteultNq3vtiaWnMJRgkJbA9QpPHjDAASSiOnpqDKZrObMj5sXY4ZfKza/FmwvD9xTD0rVt7aDbvPiIot8XzpuHyE7RR3q3OxkOyE+os44tDZTavdonLjMdF2Mh/FN03BLMzmDa1Z3m4uUkICvhAZ+lGYM7mVyvX3jCAYhzGPguiAAHQjhtU8lu570ukE8sT6
 SQlaHMRG
 OhdvpyFKFO3paEWjaKdMEKVn8gxwiueY9k1eqSfk79Ev/jDdHEcIMkqTgTQ8oUW4kSFREyFlr7zpWfaZDAt2y/KOsGqfl9h2MJ3RFd8fDS1R8sldTuBKK8CkIY7aA1VOZSmOTcHYubJIBH8t5Dff7xVyNC/jlJ85+cfNxs7TnSCbdtJj86cVuYTk/hh0++TphvzyPBVtrqukSkJuSn20S5gVYa5Vp03GfSNEVnf4M9Ibnx0AhgiyXEok8h+82fAK2GwArR/Up5ZFlets8c8rM1hcd2wLmky5n9xcrG3nLlEN0vknf3CFO22j103KMpaT9UoO3xriPmqFakQsJJSIqX5I7B+8h8gDtgA5r2mylgw/eBqJvvC5h9kpYx4Id6wmyud64hdrQ07qAjzv67kPGxODYzOvj7VhJtP3jtBa4scGztmr8w1+2FoJmFYXIFqp4CnvcDlvuPQPXNPHhnN6g3HBY4A==
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
index 02d21147d4c6..f3929a238c8b 100644
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



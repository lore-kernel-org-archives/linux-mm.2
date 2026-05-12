Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A1DCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF8C6B00CA; Tue, 12 May 2026 17:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7506B00CC; Tue, 12 May 2026 17:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD126B00CD; Tue, 12 May 2026 17:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE5C6B00CA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7079EA05C6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:38 +0000 (UTC)
X-FDA: 84760004196.05.F6E0DD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 22B2E20007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AOR9wSGb;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdwmuXhJZ1tztt+MOga5Lk/KutygLpMr1MIyeSBc//s=;
	b=tbiMK3TDyB0Y17LTBuTsfK8VZ4BdFpeT8vUOqcpmuscxsFz8Qjw0Mj+rHXP4g4t0Zz6UwN
	uVPv5N02xS/NRcICr0Z1m17DVW8/YfNI67WGBsJb9lNQGg/N1WUZDAuXW/jn5z1/mC9X5Q
	5xhJEcE4E2+UePh5AocCKUU+NoCqJxY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AOR9wSGb;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620056; a=rsa-sha256;
	cv=none;
	b=k42UMmRa2ZoTlYOd1/lmju5XiCuNlj96So//BKuwCu8S1TAVNlqn9F77VKlvRa6VepYQan
	Sof8o4Nx+Gqz8xGF64ooFigUm0cSRdAVKT9pHLC2q839RC9d1p4BNM3Q9S98Ij4FuoF+h1
	d0K6YMmgQwnL3PDFL9AiO1qVGWBwLNs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdwmuXhJZ1tztt+MOga5Lk/KutygLpMr1MIyeSBc//s=;
	b=AOR9wSGbKDaKQMNV5kzoXHWCiIrDmiVlNWwoCCyQSwg5IQGiKVZQhS2LMcWCpMG6i1kUbl
	/zcvjgEGtZlU0KiFUoCNP1DvsEbYNzgRNobYUDQywNTlxdq0RFEe/nUtZ1nJ/vwCmqOxhw
	+vdCvBT2azgBONnWcP+8NAhDJ5fP2wo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-PFNgCpqhMjmg59cVomPpag-1; Tue, 12 May 2026 17:07:34 -0400
X-MC-Unique: PFNgCpqhMjmg59cVomPpag-1
X-Mimecast-MFC-AGG-ID: PFNgCpqhMjmg59cVomPpag_1778620053
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so65883145e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620051; x=1779224851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdwmuXhJZ1tztt+MOga5Lk/KutygLpMr1MIyeSBc//s=;
        b=UorO4NhRbdouC/3IxHNOPbVN/G8bnPxceaelwAc2Qx4R4i6Elq3CpZGPg8yAkw63wH
         PRclSRYXVGSU43PLl9ccHjIvSX0MSAYz9trN1gaaNxhH59TPg8LpIruzglREJNW473Go
         GIgFttJE77QP0NM6+5SHNT7m5hxp3EV1BBYkkNG/2Lz8M4wXQl/bxKipE3WlyVK/o4x1
         g/rABWuklOGArPKXmT5NlPm9/B6Nqs96WQYYwhD/lZ43ZIXUiuLJl5Mr6Mld2ZsmxV1f
         /PmszHl/zWO4hIdzJTD5e9oH3GoDwsRonO1ph41nXpceziCyX2iZgYdBWKKTcXyFV1Pw
         peLg==
X-Forwarded-Encrypted: i=1; AFNElJ/SafZW+fCjHEO34Cq/3XPBSDFzoyxE1/tStyM6IVKPeVNqTiBj0oI/te7jkafqCmpaea83tmLwaA==@kvack.org
X-Gm-Message-State: AOJu0YwZjSVtoK+sz8jKOP3KmIRAhHAZUapbAdGVrJN1iKUJUQxThlZ2
	fBZeVKch0++95avflSRZoEwFUkzagc0LyD2HoTqWo8MwSqYiZt3Rqn6qFucCvCphbok8OieErXc
	eow1WG3x/QfNRNlFp04T49tlw9kEgEX08Sq2qZbkO8RrRgdb9XUOV
X-Gm-Gg: Acq92OGCExEmO3OOy14YKzOZTl1rYujuoyIZUx/evYgcCcKF3NF96LyNE+2AYOMya+P
	fSRQ/ZAmTT/vbINks/f1ncjNiaqhDthFus12wxtJL1crXSV8sG5pHCaqDiE3UDqFBK7gG1NlSmC
	LwqGaF3UNVKRX0Sis17MhS9x5tQp26nF633TRlwZQjJvHrObpFWyINzgpjWulj6sk7ERkfi/xlZ
	0QIEdHN0GW3DIekkpJKLkfWOzntvp2TGmnpl6lS5Y3LMUicB8dKX4iXUXh7c5tv7Y9FQS3hB3hJ
	+JQsLUmePSzuNUXFgik35ZuHO/L+AAXc6b/D1Qq76MWlryuxbB8snTpmW/VF0kyH7Kzf33zpoSF
	rO496C51fuLje+kEBV7gwfmnhUOB//t4PZgtU2S/z
X-Received: by 2002:a05:600c:3111:b0:48a:568f:ae6d with SMTP id 5b1f17b1804b1-48fc9a0b778mr6278725e9.8.1778620051205;
        Tue, 12 May 2026 14:07:31 -0700 (PDT)
X-Received: by 2002:a05:600c:3111:b0:48a:568f:ae6d with SMTP id 5b1f17b1804b1-48fc9a0b778mr6278315e9.8.1778620050644;
        Tue, 12 May 2026 14:07:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454917d57aesm35649963f8f.26.2026.05.12.14.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:30 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:25 -0400
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
Subject: [PATCH v7 26/31] virtio_balloon: skip zeroing for host-zeroed
 reported pages
Message-ID: <73b896d7fc1b4bb6127f234f5e1964d2764cbf9a.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5nCp1aCzfLvboObtwh_TdN6ljutNhpjibIr1sZEiTG4_1778620053
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22B2E20007
X-Stat-Signature: tfiup3ok8jxbpnz4z8tx87g53ghqjm5o
X-HE-Tag: 1778620055-276578
X-HE-Meta: U2FsdGVkX1+lynweTSdNivgXxw2opH+j6qA4vwerOGqXaJMsqJYdb7IYlmlCaYHxhI7lhe6qtI9kY+21rGvBqYTzUM4E2a0hom6zUX2/d0VoBmizV6e78MJx5EBFvdrxH990QLrRrTg++31RYASj6qQeJKniwGL1JrSK026FU47OHzAlTDyjgvH6VUJJ/nkGvrM6t3iXDRTrrnbeO/68wG8/CV1kYy5V7AOAFPK1e571qAKJy8gH5nTPjEj94zmivAaDJ/vdQkY8UNUqjA86tigxQS8gMDyZpEQ/PotKc41fGXCG3l3Bv0kVlDd9rN9IgCVgbt++oZZWYo7puo+gqaLDnM5fzkm6EhJdjMbik92JCUFYdswwzJ2mSR3dNOBjgldI1EFwNAWk/A6QoHX01p887Orn+y2Jc+uTFtmzikQE2HHNItBgeWoGmF1NFF60d8X5rv8/IEIeq3FSQSV2jco/q2fCN2DtikHqD1xTqK9wW/JzZJZqBIphP2gveAar1hk5M2LqmBXc7K8GAW2n24fb1yd1UICP+2aErRAg3BiKMdF5/BH+AwWp3Bu5GcTrwG4z7cd1PAq57w/zuWZ4QCPI4YnDOavnZ/MBRRn45lqUqQXA0yBNs5TXHEnfjjVj6r1cCUMjw9eUwVy6UElKmJk1BBuNdh1GvpblmVvlEVGvn7f1a1Kpb2A5lzkxPaUqvEuWc/wDrX1G5xsQ6TeayZWon321whHGPk3jZ65rsqCk6GjbNClozcEmynOVbs+RvbQoKAiFVQ3tFOi/PqmceE0m1dDepDIyqEvM8AMXxRokY3V2+3x7lyBXHky8WY/waK3kQC7bhfnXR78dPn1PJGWzZYSpdvcD9lk1Vh89dML5xBzN/rdxUx8eS0VsWLGyhOh6Chh184PTYK5kEx+zDVFDhDskDo6NyUXLvja+w4qDwVBu5siRTo3i0sylUcDO9o4jMEGHOUNVPpLSvvA
 zkbKmXEQ
 n8IPso4HO3j3nrWsTPqbqGR1ygDrnQUtE2M9287MoAh3uUb9C/VZApcZADsJdp6rD8soht5h9dJJLk6S1KHRzVLcyDkN7axFQI3hD3RU74X8G1zOeB6qKUmC77F3HZsZQ8NkfqB7yaXTeanDbJNxXmRYWOK76S3zuKesmNsYduGB4pSA/rCUL+8NbpVNk9SKZ+ro4ishen0RmZoU/lj0+A//tFRYrGJybNTIwp03L9MZuyAuBzB6y2lxFuL+yTxPwZO41ngwv9w+Xw+5VS69opxGoLc5z0PhJBlqIjvy+LMuGucDGrE07bVJHPTw9bqK+vydnBVPeeqvhikR2m9atW4aqpPfp8okJaKsT/rksuAEFZQuKKHmiG9VdZ1dhndWZTcF+a6dKthlOiNVo+xUqJ6tMqSgOX2ZweZSHOV/rAQHnsT8F5sWiwllURcTSIPDyPvUdurjWFXXyxIALmi1FGgHReg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (per virtio spec
proposal): when negotiated, the device initializes reported pages
(zeros, or poison_val if PAGE_POISON).

Check per-page used length returned by the device to determine
which reported pages were zeroed. If used_len matches the page
size, the device successfully initialized the page (e.g. via
MADV_DONTNEED), and we set the corresponding zeroed_bitmap bit.

Gate host_zeroes_pages on the feature bit and page content:
when PAGE_POISON is negotiated with non-zero poison_val, the
device fills with poison not zeros, so pages are not zeroed.

Clear the feature in validate() if REPORTING is not present
or if PAGE_POISON is active with non-zero poison_val.

See the virtio spec change:
https://github.com/oasis-tcs/virtio-spec/issues/244

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c     | 22 ++++++++++++++++++++--
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index fc43d0d7bbbc..6586699396b7 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -204,6 +204,8 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtqueue *vq = vb->reporting_vq;
 	unsigned int i, err = 0;
 
+	bitmap_zero(pr_dev_info->zeroed_bitmap, nents);
+
 	/* We should always be able to add these buffers to an empty queue. */
 	for (i = 0; i < nents; i++) {
 		struct scatterlist one;
@@ -223,10 +225,14 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 
 		/* When host has read buffer, this completes via balloon_ack */
 		for (i = 0; i < nents; i++) {
-			unsigned int unused;
+			struct scatterlist *entry;
+			unsigned int used_len;
 
 			wait_event(vb->acked,
-				   virtqueue_get_buf(vq, &unused));
+				   (entry = virtqueue_get_buf(vq, &used_len)));
+			if (used_len == entry->length)
+				set_bit(entry - sg,
+					pr_dev_info->zeroed_bitmap);
 		}
 	}
 
@@ -1048,6 +1054,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
+		vb->pr_dev_info.host_zeroes_pages =
+			virtio_has_feature(vdev,
+					   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
@@ -1173,6 +1182,14 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+
+	/* Device fills with poison_val, not zeros; disable zeroed hint */
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON) &&
+	    !want_init_on_free())
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
@@ -1184,6 +1201,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
+	VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index ee35a372805d..13074631f300 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -37,6 +37,7 @@
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
 #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
+#define VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED	6 /* Device initializes reported pages */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
MST



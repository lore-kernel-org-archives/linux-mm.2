Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85B9CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29EEC6B00FA; Fri, 29 May 2026 11:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277376B00FC; Fri, 29 May 2026 11:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CC86B00FD; Fri, 29 May 2026 11:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4FF6B00FA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE7501A01F0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:11 +0000 (UTC)
X-FDA: 84820830822.27.663FA58
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 797B1180006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TjsaQUH3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=J058kZL/7/emwJ7gIe+W5+ARMd3MoA39Xi60PlLbhUhBmwI4W6Pqr9JjYADshfPT5KypYt
	hdLSDNVRA8YORtHZNhoma1g6/lQPn4ZxjwqFce8EwSFDhYlP42VRGuPFk0VFYgbE9i3nJJ
	mBwmFgUCL7MjCPFIaDABLtx+gWFHo6M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TjsaQUH3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068309; a=rsa-sha256;
	cv=none;
	b=qvZ+HPK97+83ZyRdHqrrK9piyVdjw7XxPzKnZ3+D176R+woXa1Is9n82ku/FG0jijK8VT2
	mcn4WVmnZTl7LiLaNaN3yY5QayQZcPNf9HStdU6isEMFYzbBLqj1IKuLq0ed6rZu6inE5B
	3p60t+WxEh7QW1V2UMKu4g7e52UYtFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=TjsaQUH3UNz33vDDT5xBglP9FbSNn1NP1mLYHQVj7qpq8HPAAIH+BmPAaB7huwjiHUKica
	1I4B2uZNtbBMEaipkItft9voLW+8vHCs9IyUZ0afBXEwnrT/i2V1d9P4g14hS087Vc8561
	PCxT+ac/jwviTC2rfoC5jIofH1CkbpM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-0_PluJLsPz-hZI7S90Ujmg-1; Fri, 29 May 2026 11:25:06 -0400
X-MC-Unique: 0_PluJLsPz-hZI7S90Ujmg-1
X-Mimecast-MFC-AGG-ID: 0_PluJLsPz-hZI7S90Ujmg_1780068305
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ea38c03a1so7514352f8f.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068305; x=1780673105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
        b=SLEotsiNuATIS0WNyWVpOcDt9LqvbpYOmcqMLvZK2nW/GjcoxLKF4ztNqPedCWlD4b
         wokMuDg3qnlp3wmR8oMkthPlbKIMiB+7lSTwJJGHh7q6FzQGNoNPPBjMeuS3CflpPkr7
         YrllfC+uvKMMiXlMGHLRaZMeqt+paB+tSyz4aL+b8pPLLmJtHgEgulKJ+AU8u94CDbf3
         X5fzmxoqZ0WSVE2VPsDf1n7plLZd+2U12lAIVZ6I9tC6F0iRXLAQDdvooH7wkDRss0Bq
         q168qQgMiRBn9LYhX8jB+6Iuzi+vrijIOZ8jAYRvPmkqbqitnjVl0uvWL/KFTpuuVp+Z
         RAQw==
X-Forwarded-Encrypted: i=1; AFNElJ+POH/MnPog8xlvzFKk0jGE4m1/3ujh9Ef9FMzlLDnVLsHVHcvv8ivhh24S4bLUy01vutXXiIyxbg==@kvack.org
X-Gm-Message-State: AOJu0Yz72yB3vI8z8L2cE2oUc7xo4131Ia95ZdfYD3B5kvIjC4GnIj3T
	VNCTNIwZmy0O06h3ZFEVoAlk1vWNxxdqdC9b0lMLX38Cl/xKz1uzK0c/vYvwcVP2IOb0wEHjIdT
	XIOUBGDfNM/qfQ1Q+W60PBrtfrxf9Ae3+VuIDrpDg8+dCnniem6l7
X-Gm-Gg: Acq92OHzAYnS06w2HdApyF7WYjUehY4/oKsBqXr9CqK2I34BKu4LjuRjbyO0vk5hYRe
	qohUymywy2hcoyRcW2dnXSxaZabXEmOMzkpPADAV3PZRPswLLNu0Ild5eczdkN5Boc3gdJgQi/E
	79Q0Gwj/ttjK8iHvw0AQhBbEG4ruOQHBBker+PWr1yFN49r0e9yzHZLh0TBf3Gu9bezsmNfJOoN
	2PMuaWhJ8UbAX+UcDlEk62Sm5wkH8jieAoU1IjuOy2irZQLtQb/J3ZEmkKmPrO7KRw+Kq4CZUuy
	NBAhwJ2i9sM1v3kiZbavd21suzWY9HiAanCen6mtkbb3NuettKrm46OP+VnmiVHyeqS6pRzQ9sx
	bO/qz3lm+yTbKYrpWq5FWX5mlew73USkKc+jJiA/tumt2Y15N3p7LTg==
X-Received: by 2002:adf:f690:0:b0:45e:73b4:85cc with SMTP id ffacd0b85a97d-45ef6b815f2mr388282f8f.35.1780068304541;
        Fri, 29 May 2026 08:25:04 -0700 (PDT)
X-Received: by 2002:adf:f690:0:b0:45e:73b4:85cc with SMTP id ffacd0b85a97d-45ef6b815f2mr388225f8f.35.1780068303965;
        Fri, 29 May 2026 08:25:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b47eesm4828235f8f.9.2026.05.29.08.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:03 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:59 -0400
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
Subject: [PATCH v9 31/37] virtio_balloon: skip zeroing for host-zeroed
 reported pages
Message-ID: <6bff99e8890ea91c93e3e8f0c27ddb3b5b2528eb.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0dEuj1iDe9UFvQ11oLGQqhrTp-iyJsK_CgfQ274TIFY_1780068305
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: u8j9hqr1a7aoteo1tcyjefb5of4a5fi5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 797B1180006
X-Rspam-User: 
X-HE-Tag: 1780068309-839168
X-HE-Meta: U2FsdGVkX183LHWSIPFCEMvMPY2mD+WGbrg1vmD/cHDmOa9oX55g8ydbMCwCf8r+59rk2hVRJCCxDspnWIA6XnIYx4ScQNorP+C+Up2NcyhNGjZYYljPCIp2BXcnTj5HSFqLGQx6cnnJD449/9uw2oCkImA9ijPm06hspvXjxJE+KV87OhNzAMfER00kdw1iObi1z1NYR+xci+Woj7RaLaD5jS6ENM2jkcVdWPlEPVZ3Ybx8y5x8ZJPpZrJMNnMd5H6TfRVvePZDXXeyv4BHdmOuqoWDUUbpYkT4xVgLpYEFTGP7gDXKBRAtTNKDnACdWyOJ0kCNFZPwyxR5tm4GT1aha6Xw+IqQwGwvzgU7PyaPy1VX7MtODS5b1Y/6Kn4JGnq9Ju1O2M3Voj4tUqDFvO3ZzF3x9KqYIqeskZeA4HWAuWN/YYkSTs9Ee3UdM+ddUvpGhA3AlKqlAv527R/CdEwHznHggRyTTVqgvRovI0QCfjm/XDT8K4gdPu2d+3B9byksWVZJa2ZlMZJLhBzBTz7XWzcM/X5bzi65HpJqKJTgQujx0olOwfWv2BLJ0aiPdpAHeAFDruLI7PpQ1f/5L+92+J8zaWyrQTOTaNpIxMZ+fbeQSvAV7/BhZ3swLItAdN4kKBkbrrxcKU3c2IKeRxtK6EErPfXVSlgqyvN3rJovD3WVJHenOsILmTmcYX7NfQXWp4/BHW/uRvXmPJQhrJZdB+XBkfh7wxkRNP9Ry5TecZeXHpuVkm35o8tf37f+llQ5Z7Z7FsvnBd3OX2FQeqrCUBX9JUJrlrCL6nTH+3tUcBvRannO6xIGn5iy407VnMbTLVaySGG+vxJzn5j9URPxA0op8x8KjHpU6M5gGuh/txZJIGRn0NL8FE246qRMjHbp15u/cN+GUQRaMn+NtqYp3IwLaLBiMc9g5sHyehY4BMmxwDu+q3vwvUIsRo0R2f1dLRAqJSwibkcJq8K
 63Cr8paP
 tNLgANskdowrw95qQ/xqN2WowrgWkMwtPHqAvfREF5Ee4QlDnVur0H3RIURG8TrGYVn1EF9u6oivcq+2e7oQwbueiHg3+8jKAEJVHQJpyLvpH9R6DZJJUJCG9zFSl+ZJrWIErjQ7mVvKkx8qLc+PhNudm0w8gPnUnLFt0n3ElodDVFn/Mj4gsxiUtGK4mKQ51DKhq0W46dMXt7lnTWbHx3s7qwkHZBZg8DutS65vb6zVa6LSZgqLgUa7zUcdami9GvCYetJzBeNeTDHy+qnpJEMSCFjWlLhjzQA11pDlkEd5plmoTQme97XlucqYr1mTRtJOhYDsg2iEiJ7+SxUJsaNyyQCHwgLdTjuEE8MT0469njCb/LEqXx/qCrPxAr1fieN4+dHSHyK7YMnnhQoKH5+WtJ0HS+yi0XKehczjs1+cHXybSmnx7JU0i1VkY6/cUVdqWS2OvuRNSTgfczhvG94B7kA==
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
index 1fa1c7fa285f..e3afa6f32ba5 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -207,6 +207,8 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtqueue *vq = vb->reporting_vq;
 	unsigned int i, err = 0;
 
+	bitmap_zero(pr_dev_info->zeroed_bitmap, nents);
+
 	/* We should always be able to add these buffers to an empty queue. */
 	for (i = 0; i < nents; i++) {
 		struct scatterlist one;
@@ -226,10 +228,14 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 
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
 
@@ -1051,6 +1057,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
+		vb->pr_dev_info.host_zeroes_pages =
+			virtio_has_feature(vdev,
+					   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
@@ -1176,6 +1185,14 @@ static int virtballoon_validate(struct virtio_device *vdev)
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
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
@@ -1194,6 +1211,7 @@ static unsigned int features[] = {
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



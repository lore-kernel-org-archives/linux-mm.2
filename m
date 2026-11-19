Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99042606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dtG2StOc
Received: by kanga.kvack.org (Postfix)
	id 2FB876B05FB; Thu, 19 Nov 2026 07:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2EC6B062D; Thu, 19 Nov 2026 07:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125016B060F; Thu, 19 Nov 2026 07:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDE606B062D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:03:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55577C0A63
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:07 +0000 (UTC)
X-FDA: 85451732814.29.FFAF788
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF755180006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtG2StOc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZKBiBZ5EwpyOapUDbG3ayhblSKLTElB/6S59DDHCAw=;
	b=0OhxfEYyKnePO+u6PFglGjamchNhFIqb1HRJXYqcP6NxtBu+dwnAwD2LZsWzm8l+eO01lQ
	GqSkRUIRizE7Mio9tYeKn2RUYF0jJOMRYU7ITT+pU7JnroWEBgqaHaeZRiRr5jUlraneEH
	Czbr4ehm5C59Ei6HtJvOJJrldP8glYA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtG2StOc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089785;
	b=dELijEEyOMiVYnnhRWR3uvp6wrlTJq9f3A8Djj6FbknGPXsGATuzzl+ODCbOB09Ro1Szts
	R5x5SArGpA+8v9tyDtMduk9zd7HaRof8ru7zH1hpIdE8UXppLQNtlPzziPYTFAGCK1D9Nx
	kYhtViC1OvN1ZGtH9710192R8dhnF5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZKBiBZ5EwpyOapUDbG3ayhblSKLTElB/6S59DDHCAw=;
	b=dtG2StOcyVkzOb1uwfqVUEfsqfD9A3Vq+JI7YYJ1xIFO+1J9mRj73Yga17IeqK2Is5z2mw
	eP3iPj7X6bfIy/gEtco3O/mqvMLr3J5wHjOX6Qh/+Tzc6vsXOBxERWvjK1LtsWbRrAp20X
	QE6u7hz5OXW9wsMHxsuq1VfSGOPi+08=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-vKYMLB6QP_ieQne_I7G1ew-1; Thu, 19 Nov 2026 07:03:03 -0500
X-MC-Unique: vKYMLB6QP_ieQne_I7G1ew-1
X-Mimecast-MFC-AGG-ID: vKYMLB6QP_ieQne_I7G1ew_1795089782
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4ba078abd70so13492005e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089782; x=1795694582;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VZKBiBZ5EwpyOapUDbG3ayhblSKLTElB/6S59DDHCAw=;
        b=tk+/StCt92U3LZFa0Rz9sSUmxwY0u+PJx5TLzW9xc18jJHomJ/LXZRndDtDGlb2Tj6
         Dev1kq+49WXMKBAiHIwPfkll6Z0CcuW/3hZQyIrKpVf4HCMjap06egyNkpdYABDIlkOn
         HjKxC1pl6i8tPLKBbhVN30CzBmsP5T1oJKwaMMrRcc2/OoyCQH1WnKwHMTQWkzqRJ4Vb
         HLuk7AqiNFp31V+z5uFYcNkzQx1hyNxbwW/+7ePBWZmoPE5kEvAvNEZt304tNH9fayNR
         v8nCvMG7DMVcd4fZUVo3K1VZSusZF3jBisHx7Ij8csUwNeV/QAmBAkuo+3Phsv/5eHsY
         eFOA==
X-Forwarded-Encrypted: i=1; AL+hErGczkW1vkhFSB7K2RfYEerCIoqllj+2qY5UDiuV4DLnk/CnWkSgkuN+3caKvdzrL2XEKVeLfEWqxA==@kvack.org
X-Gm-Message-State: APuU4Z9iTCh3cZ1MMUFGxAKb9IaWSW/EZuALvD3Hoi6UQ/YGeMD6rMXS
	ekhJsvzWPZXfV8zDeXfnXkUfA7Ur+1B7tvPf1RcRrjOZufAlCphvldsGVbhwULGHGFZr6ILndMW
	DV2zkV9U8QdKsAFAtZH5yEBceizJUmcM5nO0PL7bKjUs/7k6XtUDL
X-Gm-Gg: AYBFou3gvBpG8Enwgd0xtvuHYiyu3G90W3d35O9FJiVkdSsDvK+Fw8cX3lKVr8SVdCY
	bkEDNGJT04rdOmVroOeIpsVogtAIUQqLs7qi9kNTyBLC15MaG6FZ0zFWOG1tC1amvCIV5+UAEKy
	efTdlIh+aUqpkIX9TLdlSt1uUm6MFt0ZkLsG9A1qCYLStpHdr/wQpKa+zf0t5iyQugfEXwsOOPp
	NBXJlI1Mo90uNIoY5nC4/Xb4wvbsMjdm5ORmDr2DLcovtpC2g+albLp2c1O52frtf+E9mcdYLt6
	zdT/Pz9d7LZuwd+xq2tungCZ9SFNMQOqOKwTyy1LVqJrBoqLheKZ87kL0wzf+i4GwuXrppYYE+o
	ww5+ej7iR+o1TRr6hJhMioScHYl7ed11htOGVdoJua3U=
X-Received: by 2002:a05:600d:6507:10b0:4bb:8636:dd7d with SMTP id 5b1f17b1804b1-4bb8636dd9bmr16333815e9.24.1795089781165;
        Thu, 19 Nov 2026 04:03:01 -0800 (PST)
X-Received: by 2002:a05:600d:6507:10b0:4bb:8636:dd7d with SMTP id 5b1f17b1804b1-4bb8636dd9bmr16333235e9.24.1795089780568;
        Thu, 19 Nov 2026 04:03:00 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526541fsm46002405e9.0.2026.11.19.04.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:59 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:56 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH v11 6/7] virtio_balloon: add DEVICE_INIT_REPORTED feature
Message-ID: <65c518234ce31fac3f6ed436455dcb415d4b1189.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RGCY_UZoSzU51HYwPYCG5sbIrCpE1O26pC7nZBDF_Lg_1795089782
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: DF755180006
X-Stat-Signature: ryah7seteuy8r3fb7pjo9jmr9qjsb6uo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795089784-968576
X-HE-Meta: U2FsdGVkX1+mdjpSengBCVmzeZ4gRDZJO4tTto18CyFN0fZi4sVr/Sq3dfJvKca3PWwxxm7KrgQtDjPrwlZ5eVpa/RQxwT+cTBNaPj1BjGIIzT0jl/zH57EVO7Gm1m0Ah07CRePIY0E6OSDfQntL7tsNjsVNHvkCKPtPXXgPxrIihx1nkS8A5WjOgXMk29LM6hTvDzdN2wnMbHGLaBZTB9wKKtFvFEd0fohYUdeNOmyVN1E60MXHfc03GYZ/6SK42mMYZe+qvpEWYJq/myrObBmuzdcWDIUoHZLbtAe5x3Eo1RVZbuAWxBEloIg2Z/CmdhObH/Nu7priQf60CVVCjC+IE1uOlAbkEaHHCQBlDsPUS2cq55uqWUlchZkbCzuHAdR1gViAHmUbloTLmpG7dnq7tpi7I4mM0LGa8WMGDhrjs/HN6tWzk/2NE6kiTpZbkP071iriJn+oPBUuKnk4IXwYNbB+YdXG0HbbNNOMspUFyMlqhj/UCHGBQNHbEwcHWmvXmiaQr2dyyDnZIutMayinXav7Vfx8qCxZLD5qPFaMv6099k+OY9+KH2VavRUeMIh5P2yAnbCTi1A2x9w00QW9kMwCcKB9YTzeNLUCiX+5ZhKNzZZb7GrQtn6vXvzxD+D7vQWY0d3+UkkspuOv1L3zcNaRMv3zTiNUMuLbyOewEq3AyuBM4rJviVwTfwv2e1quhwIFftYmV9o02bdamGqa+rSnhhSTxJ2hiowkF0ADjXMMwXOMYABpZR98+4mSYY0imJmfxauPqd4poMXNuWPSW2gcCxQ5VhGz3lO/LC87FFWxUo4kDZgzQI2p4ij3IgCPGFoKGShTmCyi+pD2fKylYIzGKqX11I9XsdLfhoa3ewMz17tmksWYS4EUDizNPQEz+t+OIwYkzDOlz+z/qY1GgALsJ00xXAegpGtykFQeVZ/0ihnBDP+h71CGln/vAlPbR0pGdvwhssrPIqL
 Lpb4S+H0
 ZQ/3knRM8TbpVutEpnBxUr/0Ikd5mQrJEP6zZ+HRjkNHnv1/T9ntz0vvlndCXGhnewcGPps82tHh9F6W0j2dnr3n//VpSK9cYhrOwWvGed5o3FCGyzCeWcnqET6YZHuj0ib1dyA5kxmtnSvnSHx841bs7dUmyXVj++dFgkbONSvX9kEusMeu1zRD0HZjcEZ0gJ6doybyGFoU87CRZThtHxuu3qePA3ZoZWUiZdvSAa5N01b0H+Bnq3ziAA/rx8xUYVuY6+QTWTOAw9/raEZ0PG5yrYwtD+KvMNR01jvRV0KOUHV9NTuL3PXh+gCAdU9U7LIKYDuIDAFQTTp9s9MUaKDitHHnVc4iecjCVOumi4h8wedrjOt/G/5QCKAfrt6810swc2YzrToVGjYF+6Pcbs7hmAojxPQR2tRbA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6) device feature.
When negotiated, the host zeros reported pages on reclaim.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 drivers/virtio/virtio_balloon.c     | 33 ++++++++++++++++++++++++++---
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 8c1b47ec17a29..4c6630c5f9599 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -205,7 +206,9 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtio_balloon *vb =
 		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
 	struct virtqueue *vq = vb->reporting_vq;
-	unsigned int unused, err;
+	struct scatterlist *entry;
+	unsigned int len, i;
+	int err;
 
 	/* We should always be able to add these buffers to an empty queue. */
 	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
@@ -221,9 +224,24 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
-	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
 
-	return 0;
+	if (!pr_dev_info->host_zeroes_pages)
+		return 0;
+
+	/*
+	 * Only a fully initialized batch may be marked reported when reported
+	 * pages are treated as zeroed. A short completion does not identify
+	 * which pages were initialized, so reject the entire batch.
+	 * Subtract each entry to avoid overflowing a total-length accumulator.
+	 */
+	for_each_sg(sg, entry, nents, i) {
+		if (len < entry->length)
+			return -EIO;
+		len -= entry->length;
+	}
+
+	return len ? -EIO : 0;
 }
 
 static void set_page_pfns(struct virtio_balloon *vb,
@@ -1043,6 +1061,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
 		vb->pr_dev_info.order = 5;
 #endif
+		if (virtio_has_feature(vb->vdev,
+				      VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED))
+			vb->pr_dev_info.host_zeroes_pages = true;
 
 		vb->pr_dev_info.capacity = capacity;
 		err = page_reporting_register(&vb->pr_dev_info);
@@ -1189,6 +1210,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
+	    page_poisoning_enabled_static())
+		__virtio_clear_bit(vdev,
+				   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+
 	/*
 	 * Disable indirect descriptors to avoid memory allocation in
 	 * virtqueue_add during page reporting.
@@ -1205,6 +1231,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
+	VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index ee35a372805d4..17de46c629c2e 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -37,6 +37,7 @@
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
 #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
+#define VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED	6 /* Host zeroes reported pages */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
MST



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46244C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 06:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE156B00A2; Sun,  5 Jul 2026 02:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7ECA6B00A4; Sun,  5 Jul 2026 02:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CB16B00A5; Sun,  5 Jul 2026 02:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80FF46B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 02:25:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 007251C3ACD
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 06:25:22 +0000 (UTC)
X-FDA: 84953736084.05.3CA9660
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D7F4160005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 06:25:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b90uOWoz;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783232720;
	b=cdYyqiNgQjR3ta6yU3HQFn+BvGA/C78R6OXu5YRuBFBMfVKiHyNpFjbL5iR3sOcca2DT/u
	oNcx/75iWR0abZD3m0qGEfotDok6jlZToIKWr/lwpTwK3eBQ4Ho6w6UMedHYyGziFQ5zbI
	mDM2exVCS6TdJfjXLvHk7sajq8Oqw7c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b90uOWoz;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783232720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GAQqvqsCquPh23M+Tm8SQSpQZO6IalsSXrunX7fJKhU=;
	b=wV9OTDN+HGwwjij9nVfY2+/38401vRu1IdfoUjT0gY7bhB6m1i+UgeI71NOeBem9qhl5AS
	p3jIzHjKXlkbDfxfPhy8T/YO8phcgfIJ37aWnkNaw/e1lSfwefBGENciq/nWe0WX7c1kQ6
	B/WcJYArXBYTijmf9o2lJnxmNAePjqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783232719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GAQqvqsCquPh23M+Tm8SQSpQZO6IalsSXrunX7fJKhU=;
	b=b90uOWozqQ7vAjy/2+/koVYmZRN5y2GyyM8ClG8IohgCf3iNswdbVr5F8Fz1c+IKkAcuV/
	EI9t2vsDW+xql/FUZz1SiFtXma4WxJ0hOGpyaAegC1ckCv36k+38KdXn8co2sHlLGojjDr
	VIK0w8HX6F8QuyFGlywfgx/ukRJf7R8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-YtGCaZEHMbWN48h6YCIIiA-1; Sun, 05 Jul 2026 02:25:18 -0400
X-MC-Unique: YtGCaZEHMbWN48h6YCIIiA-1
X-Mimecast-MFC-AGG-ID: YtGCaZEHMbWN48h6YCIIiA_1783232717
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47bbe3b9705so413042f8f.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 23:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783232717; x=1783837517;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAQqvqsCquPh23M+Tm8SQSpQZO6IalsSXrunX7fJKhU=;
        b=bw1RAKYa5SFw95vHYr0o9VCbfmkVF1piR1yFtb2vkgm285j50r4DH4dKuIztPeaZmV
         C3TahMdQ58/LlTuo9MqQlsMMhurN+V8Os0MBZvIRV47jrlJHyNuXsY6E0Ugghy33x3T1
         blW/7jKlv7evCikbaGcXQEEXuDet8B1ogZU6+unsUf0XzFI/zHhftIoA3QcOdG3hAVak
         kJP5+qwGpmfzq3zOpiCs85zV4g1jzcMg0RaA4NKJJTk9I0aDLR9PVAIt6uIB4uf1Vi+K
         +UOcb2JLlZuRWEMhAcM0DQVujK3EymCx/NfHMTjpDVZSAIfkCtVwZ9yu73sJNlPDlk+w
         oIOQ==
X-Forwarded-Encrypted: i=1; AFNElJ94pOfOpgvuATSUYd8Xmw1f5SHs5BUUF+MChWIeD61M319wuU+SePs7TyaAB/19irzWFxEI6I9Whg==@kvack.org
X-Gm-Message-State: AOJu0YyBq3exVKxeCVAx5IQUkap3KB24G30yd5dvD9m2q1YnH2fkJyFD
	/LODQSFEdLS7/DwprA6cTL4mGsmjNwktwsSrZIQgZwShCntr0XPyBsJK9fp1z9fbPGEazMASLEp
	RGmIxgLEI0vLtf8pCnDP5c5L6u17rAqM/yKEDecAepAXny0zQbNmB
X-Gm-Gg: AfdE7cmjgzb3EWIxk1P0PpdwUs+ulagvNQY5k4EQ7mX7ZIUaf5e1xvFkzqX70itZdVH
	LvT+VJiKFwLZqmGviYV3fI3NgfwtjkZL2bX6/bja1zsnBXb50bgjqcWpJExJV8xj9Sxf6zBBmay
	yJWD0w9NnIOb/nPE3nG06wDClWOilzbyOsLdm9EvuNIpc3kbQshuYcfszeMlUAP6LZbWITWTlNY
	NrToSFOjRSIcHREHwrfmKhcW0EykKBGa+bfyeor0E/8Rcal8LMmo1IoOj6PW1DKp0KG0CMioDE5
	2gfNRq1mSgJ57Ax2BymdA0U0wR1D4oNytY5ODZad05DcTntFyWR/PcIRIJFw8284OAhQ6QbMADx
	I9Pap/WVc7LdnL5lTpH08rhd6GGeVcxZn
X-Received: by 2002:a05:600c:a011:b0:493:b84f:9c28 with SMTP id 5b1f17b1804b1-493d526dff6mr31636925e9.4.1783232716724;
        Sat, 04 Jul 2026 23:25:16 -0700 (PDT)
X-Received: by 2002:a05:600c:a011:b0:493:b84f:9c28 with SMTP id 5b1f17b1804b1-493d526dff6mr31636635e9.4.1783232716215;
        Sat, 04 Jul 2026 23:25:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a558easm13544055f8f.27.2026.07.04.23.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 23:25:15 -0700 (PDT)
Date: Sun, 5 Jul 2026 02:25:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: [PATCH v3] mm: page_reporting: allow driver to set batch capacity
Message-ID: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xem9UtCUkfOuW8jcDKa61U6KwekQ2WnhhoBXRNS3gl0_1783232717
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D7F4160005
X-Stat-Signature: cy8mgbjs4idmpptxzppcppbgg7bjycyc
X-HE-Tag: 1783232720-498597
X-HE-Meta: U2FsdGVkX18T8mJc2B2Y9/lmFpfj9bWaSO27tHPnqZGDXp4B772mmc2S3oVRztCtaAA7VdfNKybyaJfsKeYsyuYvDY2OwevalndD2rC/9C800czyWfKuBNv6o7s8TVvu87QN+glVfqxzQqBFVZnz6SdVJOj7B3u6/GfLS0CRE/vAsSVQcVe1luKZ43KKB/mQ5VHs/36QGl/sSQzDhlLbX5rtY5prMFDcEMQErQbF/YHyvLrKTD9FlPRxAufLCpfqlSy4q2aqOuudcdjewEoHvAPtsXEYlivt2Kd+7DGsWcEZJE1gCSqg7Ig8quak/NbR7Qj4yhNNZbjfYuP7k0Q6XQ1fCr/l3lJlomyoT5xCGm8P5KjTatrzS5PD3XxmnQbHOYNYWlwgKKL8ufiFX/ppM2sXs//41pH0AtGc1PGgzRQ3tnKi05vFEEZ/m4B06FYwON9X7HSpx6KfTCyozP57Dhrm/MjetUfzo+YydXh9SQdykBxsTQG+S/OzQrGr+ct8YKNBGLnoAZdtafBNUhojMQqkSmDMYE0/eDWmn2CXIiP0C26O7nXBL3Gz4oMQmsswoXDYqq621rIdZJhxAU49mM4UMPk6aBrr0ioblXbhbanj5vMlQkK27V8p8riKDcs17vJp+rofWQBWPBzDRprYwpJxMMCfMoHiBMNO8K63YyoXcZfWo/OzcmepPb4mENxhlFz+E5Oa4BIcwngh/M8MylF5S+OMeQ+4RnR4Cwo3lSzTSI1fF11GMSRDNpLUx2ArJVN7YRMvdtiQlq7czBMOuhYHab4D4coKsTeXNpULt/fA3jwiJS2rVcynl3Rub+1/x663p2skSPbeJLLhM9x6TprP1ts1VTxOu3PJB0vCPzgJ8kcN+CvpCkjnx+1rAIWTzEFH3YHgimFhV3d4rG1oNLMnZLYFA0IETgLVw7ku5ocSephDBEpQuGUz4B+Tn83OdfYnTl8b+YI6eOo1hen
 YMDQ4elm
 XjcctErI3EFc6kj1ZIqCuIoXPx6NSIvmSp1LD16RNdVKPZ+CT0mi2+OwRMlMNvOGmAoHU5UHGFqBS49Y0V23IJzIaDrR5hwe6g1YZ4UdIeoBUuPBE7zHbEp1ECIRDZle6TkyhMGrtLC/mQI50kZJ6O1/IRKvvRmIEAYWoH4ltZV0jlsE2wP/tVeRhJ6N11xG6Ly7g0IANd+pRG4JTVMoAtvDylNl3OrxUAecG00xLVkIHBhfhuIAh9YyNjjnX2wT5r0OF1mzgAXJRgoOqUyw8TjpylQ5njKXNil9TP2rq3JNjvM+d9azEKMV6RXmYiV1IUmBFApJ26CvanESkfyhGcZ8fu8mnYR0VZD7qQmbqwZWC+WUSWza5B49299GbFeugjKaWUVhdGlzaWxNKfGjYu3PZ7WlbyVx89k63oBh/9hfukDGSDb8g2zj0X3sIg1SQ8t8MEDVxFr9cGepXpnWaac5ssAyQkj8yYKQZ/5xb4G5AKNbaOVp+2zsjVA==
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
Assisted-by: Claude:claude-opus-4-6
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Who's merging this? Me?

Changes in v3:
 - Dropped stale "This value should always be a power of 2" comment
   above PAGE_REPORTING_CAPACITY (David Hildenbrand, others)

Changes in v2:
 - Added paragraph explaining capacity need not be a power of two
 - Added paragraph documenting capacity=0 default and no div-by-zero
   (Gregory Price)
 - Improved struct field comment: "0 (default) means PAGE_REPORTING_CAPACITY"

 drivers/virtio/virtio_balloon.c |  5 +----
 include/linux/page_reporting.h  |  4 +++-
 mm/page_reporting.c             | 24 ++++++++++++------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 088b3a0e6ce6..581ac799d974 100644
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
index 9d4ca5c218a0..272b1274efdc 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -5,7 +5,6 @@
 #include <linux/mmzone.h>
 #include <linux/scatterlist.h>
 
-/* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
 #define PAGE_REPORTING_ORDER_UNSPECIFIED	-1
 
@@ -22,6 +21,9 @@ struct page_reporting_dev_info {
 
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



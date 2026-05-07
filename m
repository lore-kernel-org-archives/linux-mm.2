Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E953CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965C96B00CC; Thu,  7 May 2026 18:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A4F6B00CE; Thu,  7 May 2026 18:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FBA6B00CF; Thu,  7 May 2026 18:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 742226B00CC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 158D3A0640
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:15 +0000 (UTC)
X-FDA: 84742050750.21.90A6FE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D43A940005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CCmOx5b3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192592; a=rsa-sha256;
	cv=none;
	b=vw80gDuC+YAmyPg+iBY64+akVZXCNe4YUarjxcvc3/gnji3/9170iB5ED1HahC3RUyc9Wk
	latS0/qFiyeLCYVyuJgV/Vybo0ggKJ/a4uhAiw7nKcPnbvGmPPXJObH3pIAEUIXrrYdoTt
	jZpWdzfvmrcbaeZOPql5pdsIRBRmCTo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CCmOx5b3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXud0h6YxK7twmSfS1n2EW2FIV5pqeOXrOEyMytphT4=;
	b=t6HK1KJ+9kV7r0pce2SQncWf8lYob6uSUJM/fBDUmGHleRp0Pz3i01OQIeaTciO0ftccMN
	YXpBqA2OwBz9pW11SiPNE9+OrwFZV75dUtSB1TcKqAmsLiiaf3tVbvfIPKhKDZ6/S6kbBk
	4QzEYxwFHg1fknkNaT0Eyx7AeJ79wJE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bXud0h6YxK7twmSfS1n2EW2FIV5pqeOXrOEyMytphT4=;
	b=CCmOx5b3bI/euSJQE3PqlSbu/AiI1B3q6nmWLpZuIyG/glt/6R+hd1MGMwk99Nn11n5DLx
	VqCnz0Fr8xU8jn7v5zAlc//urLhzH/WS4izDDHR6fnudZF7bBnfRuw8WlNV2NqjUdLZGMo
	0vkDi+JzekxomkZ1bit+ZUsrGA6ttHY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-Rc2XPWg2O4mxYrmXOuZsxw-1; Thu, 07 May 2026 18:23:11 -0400
X-MC-Unique: Rc2XPWg2O4mxYrmXOuZsxw-1
X-Mimecast-MFC-AGG-ID: Rc2XPWg2O4mxYrmXOuZsxw_1778192590
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44bf1ac8893so1115697f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192590; x=1778797390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXud0h6YxK7twmSfS1n2EW2FIV5pqeOXrOEyMytphT4=;
        b=QCXR2FcGboFn9ddXHsKy6JtiGGHsR95WBz331d2LrpUe+QH12oYl8lvFvvMZsFAiRC
         JiGkkPIERDk9rAnFKSMvLsl1yxFqxQ6fAl1ytr8pt3Qc501TMPqk29o2Mpq5RyBGEroe
         jdVynC/35gG9k3d9KpWUM7iGlqtPFsZEIH50lh9kpXLPmyiByVN92tMPgtpKxyZnAxXN
         Mk75yR3/c4W3V0VgV0iY7VgEK1gsJhaQ42DYYTC02QQYnCotONFh2Kt9w3v9PMedojSq
         Xt4jxq2SEUS9lhj9EgkwWHO9mCB5j0iQxyHUwTSPTnZjLHHhYlFoz56n5KjO0t7tws5I
         wvyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8bb3eXoYZbelBjk64ye1lFCnlqkjgosXCys7Zd3nh4H11c8dI5owixLAb6PUBhGn2MESgjFJwhxA==@kvack.org
X-Gm-Message-State: AOJu0YxSZzeSru23GnL/7FG6ke41L/LVB0IQbBl0nfp9gtvggu3Ll5yU
	PZJAnzD9WqSODLu18tCa3FCJQuERczq46qccnv+0O8IU0IDbWpL8Xcd7ZDuq/OribZGElWwPmzn
	O/C/EFnzoZ7GPuZ6gJ4COdM07T2UwI+jvkHWHIznqzL4i3G1x/35/
X-Gm-Gg: AeBDievitF4yCMUFG7Qm+WWuObz3l7oPl2ssSsX5yt5KTPIa7zzzlUjN0DJHEdMqfmx
	jYiOO0q8n6/Hq6ORI6yi3nR6i8fqPDqBJMItjR2D+LciYmfUGvuojMboZRBxu5Pe8NQ3zF3Rq+l
	k7rI8pEGzL9W+5AfIEESGDolmmOPvgLtJ1GQaVCho7X9IOkFnMepWGA1nq5JEqKZfQHN8WBS/42
	EXK9JUKeWY4yKSz91ZIg5Jg0TCEaAapKxGL5AqtZDrHARHo2yrVJVs7X3zn6m0jfSTAGWjG2tHq
	YmlO19x7uyxSaaqmPRoMg3s06DlfOjDiq7bhftt/1vuJIBMKVY7qDDByjqVYUvBrxBHAJucoHwC
	89gyGAv7O6dsKRRJUVzVOLnxkuCM0xi1LKhq8WZky
X-Received: by 2002:a05:600c:4c25:b0:48a:65a5:750f with SMTP id 5b1f17b1804b1-48e51f46ddamr94972215e9.21.1778192589747;
        Thu, 07 May 2026 15:23:09 -0700 (PDT)
X-Received: by 2002:a05:600c:4c25:b0:48a:65a5:750f with SMTP id 5b1f17b1804b1-48e51f46ddamr94971895e9.21.1778192589203;
        Thu, 07 May 2026 15:23:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53895effsm150472825e9.3.2026.05.07.15.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:08 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: [PATCH v5 14/28] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <e90045272621711a7dc1ba9ce0f949dde5f7c2f4.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 24gdrx4sBW5IUw3jwbcxOBXIpKSkl63z49ziaVdTe7U_1778192590
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xgd5ubdh1cha9jq3poapmjh5o1ts7dg3
X-Rspam-User: 
X-Rspamd-Queue-Id: D43A940005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778192592-457428
X-HE-Meta: U2FsdGVkX1+qO/YZGkykc0+pvDM4ocN9rwLXHVlfUVFCtbnivJpArVji1dHlNt6ASeAAZaavR5PmbS5oFb2Qo/gQKAzD3d77n3z/dKQMgsNUMCCXmZda8hJlJ7mcoiKn01xJ8SOZ27sBYViQXEmexEQOj8osOBg+hNoHoGoA+JLJjUv/u+Km9T7R5SveYAOzYIyVbNZuuSupxLIuyx2AnSlAhReJfXvfeFt3H/QDHzYhkOZIE/AtfII2K1lhLZCFYX2KFNiYQL6XZvdBm910B0lN10LK0pBPIgrt6s0iUKqkxJZ+30e3/uISLIfYsMSwbzFajL6o7nYbtr7ech5TMzqOlrxUyBPMKewqeVnCE2ElXYk8Wc3VJztzUmQ4UHMuZHs1rcq3Ik0v38q6ECMqQmzm5ojEE7xj+LkIdhxavDFQJEVGAEygxe74kO9ulUzmVQhqTdZszrNeO2oWcErDwdEDaQkJSqq4g+0unA+mF67MI7uYsIO4R9lIFjczSrHDGcnmlksJClW9Jy5NRjiMhvZ/1R0asLH8LbAj2WLzhQUaI+RFWt7v65+tF6LSghSIiB7fREfu6UtRJ+V0XD/48D0pyM/K2CIynW1MNaHhSweJaXGFRCnyCU/ojBI9eRulPNM0yGyzDy83e8xaBLv3+yQOs3YWTofifqNIez2V2d9cp9mq1JRlSUuK5pqcVWm+jEfZH5yD8rmKAKd4FKzE4osRaqzKfgrqExZzWKu57ZOkndMEmmSpvDjpk4SesSIOQjDphCGM217J2BIgG08GogbWrCuoPEaov4m/5Mn14U5OKkn9chWJTll+Y1BBDi1gRBgfkz0vpFrnT2CgHd6Yzznni8JGohE99WR+T33/A+pjeFZ6SdeMS2XgKw1in6GClrDE8dUtNUkwRoYVA8EuwuakvVYoG0gYrINVEYUywLqxpaqoRcR9bkAaFIxSmDkFQnQELDAxPE71cszGMgG
 4C7OYMo1
 3D4F1aP697SubNuYVy7kmX4wbb3F9NkPZsrDxQiI2JfEwtEdLwOKImQa7FVFUJdpF60vLz+N7f7CbFfJ7HVRfjuYr9NCIbqBqwi2RVLLsheVyxsHy/rPfN7IWUpUee04K/fnqEUqFkfLb+3MISh/0fTxw2DU+s22sK58/mhC8BdApEU+3omBDsKnFD2Y6TVK7q6qlIjRo2BZyc/cu2UqSLjpP7EWAI1phsXzdqRq7Y3nvQY2fYfC5pmrTmnxjbeacRvv92+/8a3DIUXlkMhWwKj6RM5oW1zhqHtlUo+hakTRBcJCCYCFPZXOxRcBiQOBCcflIL3Xj4dmnJ1M0dxmh4zuaFBtJ51JVmdIOPy0Rze1rcPopZfF7YoyRnw==
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

The value is capped at PAGE_REPORTING_CAPACITY and rounded down
to a power of 2. If unset (0), defaults to PAGE_REPORTING_CAPACITY.

The virtio_balloon driver sets capacity to the reporting virtqueue
size, letting page_reporting adapt to whatever the device provides.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c |  5 +----
 include/linux/page_reporting.h  |  3 +++
 mm/page_reporting.c             | 26 +++++++++++++++-----------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1fbc8fe8470..7ed024315539 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1017,10 +1017,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		unsigned int capacity;
 
 		capacity = virtqueue_get_vring_size(vb->reporting_vq);
-		if (capacity < PAGE_REPORTING_CAPACITY) {
-			err = -ENOSPC;
-			goto out_unregister_oom;
-		}
 
 		/*
 		 * The default page reporting order is @pageblock_order, which
@@ -1039,6 +1035,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		vb->pr_dev_info.capacity = capacity;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..306468b6c7d8 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -21,6 +21,9 @@ struct page_reporting_dev_info {
 
 	/* Minimal order of page reporting */
 	unsigned int order;
+
+	/* Max pages per report batch (default PAGE_REPORTING_CAPACITY) */
+	unsigned int capacity;
 };
 
 /* Tear-down and bring-up for page reporting devices */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..247cda44e9de 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * list processed. This should result in us reporting all pages on
 	 * an idle system in about 30 seconds.
 	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
+	 * The division here should be cheap since capacity should
+	 * always be a power of 2.
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
@@ -376,6 +376,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 			page_reporting_order = pageblock_order;
 	}
 
+	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
+		prdev->capacity = PAGE_REPORTING_CAPACITY;
+	prdev->capacity = rounddown_pow_of_two(prdev->capacity);
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
-- 
MST



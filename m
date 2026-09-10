Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C87BC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301016B00A3; Thu, 10 Sep 2026 07:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289736B00A5; Thu, 10 Sep 2026 07:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178BB6B00A6; Thu, 10 Sep 2026 07:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E63C16B00A3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9B201C2455
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:28 +0000 (UTC)
X-FDA: 85197558936.20.18700D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29AA3C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hdl9BWx9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038027;
	b=Oy5RLOxHYd+mAxAedMuGhdxA38GwtTjjkvJKHz9/HclwTF2SN8F7RLD+WabnkFf75QcVZy
	qcjswr3B/LDxBe5rWO9E3vHKvEEzJzwWPCB2dKMDSeaJhA8uQvFii07EJkFp1HCdyyea4x
	y9UZoTCM7Ygm9QyKDengLnhcVp+6/4k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hdl9BWx9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	b=W9+qp+Gryy1Nfo4QdxeA+gTsmxu3bfHnHt33r+JCpRCdU4dafCLmbcvaBPay0AneVSzyZO
	eQZsq3ynGjbUP4OaM2w7BEDuQc8NOLyxRLI1/qDqLxVpBnfB3e1OW/PiCuVojeF86M2iji
	DrzR7pq7xBBWXzwYpsY+66V+OsM2Jxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ED1443C00;
	Thu, 10 Sep 2026 11:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4831F00893;
	Thu, 10 Sep 2026 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038026;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hdl9BWx9RhV8TV6gLvkYRLFmDPO0Zs8tK3D5BFDdDdM8+3tehJbH5vh4fDmoNfyBG
	 XVUlqsCfXwgRScwZLs9GHciRieQhKTmD6/0oKVT5FX6AYGH/pgB9ipXaCWpVktu6/T
	 s1glLty3/szd0bMK+ufXwOjYcFUG2qYR/6py36MoOvxXkGvLcHN2uxDk9DmYHicqoO
	 xpGuPbC9B6KRtwAPkNaZGkug3KM20oi+eBM7ltI8MWqReXm1SF8Ro1Gys0XC5WKnzX
	 um1bWQ9ZxUFQgi8a0PUPthf7Xi5w+hxFu5nC88R3bDi7Un/olqIzi9/xy89nqe3wuV
	 cecVbzkuEjMzA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:07 +0300
Subject: [PATCH v2 05/13] s390/cio: Use kzalloc() for CHSC work areas
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-5-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29AA3C0007
X-Stat-Signature: b6pqjijnu8yp55qaspp77j8urg9og6ps
X-HE-Tag: 1789038027-687376
X-HE-Meta: U2FsdGVkX18Ql1cR+8gP+Pj9xs6/rmGNaRkmocaz5ant19RaijUulmvNSbGhMJ6ipPgDAXcmav8F+Ei/7tHBwwBX2Gez0rPuQkvFLBpxn7fHyx+YG7iP5Riuok+0oW9GshzfIoroWofGOj2pVqOcbMYWG/2AoWuvwe/M0p5xO5oIsdWRJclv9qNaSXqdkFeiG2ZUoCz2TbgcIXi1JsvarRSb+xB73keDspGIRpybZsSdYl5zc/hoDbYbR5LIh7y4exC2AwP2d05I2gY9sWfRvk8V6fGWHwB2ePHte8Fr4Dpfsr7CPfmo881tmbekxGIGskyad07+Wr3i3hSM2wf6UQzxPomulgn1KIQHMAGgpOiZ41gZ9w8+I/JbKMXtTCQKPbBUGxToTYAD1aX0oZhPdPJwwGOaWfA4NoPN70dnWOj/XG5zkIrb4e2M/VdS0DxU7ZMGDH2RgwPTVU7DGvLahxzqaa3wc9LvySNBiIwualsN7PgMZ5txUPGpSLw7Lv+x51cHvzi7F1DRY1geJ6KeBwvmNZs/xOqqY1pnn1sy7Vj7AgP2ixbOXd5io/ZKDzZXzOivUu58LEOe+M87a8d7VmUq2zhtGvKNKOZcFh0qbTvOVwoz8vX7JJYJ2pYMRc+oZDOHHzjOxcg3XMxof+L8sv3VAhIOw4qvUMun2ZmaT8wOQWMDXgVeXdHM0nE3DxTsalIZgRRTmOeH/Y1oXNXL/SSZYUFLOSpOaSLznM7n2xz4goRL7Kq9RvIAOUGBZZ9kjMHP6YWxLkP9QozgZ/q0qOses4vW6VTY0lVc3Fw6Dz9PJ/qItbSXQowuEYAjp4GeC7z2ohzXH4WUIG0q2PuI4I5kpWDpv7x8/9Z1NmTFcvremwQpOsgk/TEpJaXHmkEQMqkhuVBS+s+vTgpuxNLWU6FcuJDuknq3znE/bNq35mVsYrxgB2xoceXY2PRpdeTtWelinIYyuoOfoJOFG5e
 JhGt6g62
 d5spw/Cc/1Os04EH2f9MAcuZRrdcyqy4jicVwz0wgQPdAj8Lj976rf+OhNuG67a70cUQJ9H91SKbO9k6DXBNpFfyd0a31FhDlJmHYOBYVdZWkog4NPHzs6sOoteldDoFGp4dnVJgvbyoAWQ8v0Vkm134cYYVb4zhdV9JO0kXZDzVHET7mDEXnRG+wK6PBn6afJImDnFH9iu8URmhWk6k6OC1XQphd/L3YGxmvOAWgNXbk653bdK54Ik29T5mp1MJAfEQFIU8W3aUtby0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

chsc_init() allocates the work area for CHSC commands and
qdio_allocate() allocates one for CHSC calls during qdio_establish().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, change qdio_irq.chsc_page to void * to get rid of the casts.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c         | 6 +++---
 drivers/s390/cio/qdio.h         | 2 +-
 drivers/s390/cio/qdio_main.c    | 6 +++---
 drivers/s390/cio/qdio_setup.c   | 2 +-
 drivers/s390/cio/qdio_thinint.c | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index c3186c0a372b4..d98f629e89295 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1143,7 +1143,7 @@ int __init chsc_init(void)
 	int ret;
 
 	sei_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
-	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -1153,7 +1153,7 @@ int __init chsc_init(void)
 		goto out_err;
 	return ret;
 out_err:
-	free_page((unsigned long)chsc_page);
+	kfree(chsc_page);
 	kfree(sei_page);
 	return ret;
 }
@@ -1161,7 +1161,7 @@ int __init chsc_init(void)
 void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
-	free_page((unsigned long)chsc_page);
+	kfree(chsc_page);
 	kfree(sei_page);
 }
 
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 4bd4c00c9c0ca..dff5f53a8795d 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -244,7 +244,7 @@ struct qdio_irq {
 	int perf_stat_enabled;
 
 	struct qdr *qdr;
-	unsigned long chsc_page;
+	void *chsc_page;
 
 	struct qdio_q *input_qs[QDIO_MAX_QUEUES_PER_IRQ];
 	struct qdio_q *output_qs[QDIO_MAX_QUEUES_PER_IRQ];
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index c1e09fa34e774..d137bf8c70664 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -934,7 +934,7 @@ int qdio_free(struct ccw_device *cdev)
 
 	qdio_free_queues(irq_ptr);
 	free_page((unsigned long) irq_ptr->qdr);
-	free_page(irq_ptr->chsc_page);
+	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
 	free_page((unsigned long) irq_ptr);
 	return 0;
@@ -986,7 +986,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	 * qdio_establish. In case of low memory and swap on a zfcp disk
 	 * we may not be able to allocate memory otherwise.
 	 */
-	irq_ptr->chsc_page = get_zeroed_page(GFP_KERNEL);
+	irq_ptr->chsc_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!irq_ptr->chsc_page)
 		goto err_chsc;
 
@@ -1006,7 +1006,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 err_queues:
 	free_page((unsigned long) irq_ptr->qdr);
 err_qdr:
-	free_page(irq_ptr->chsc_page);
+	kfree(irq_ptr->chsc_page);
 err_chsc:
 err_dbf:
 	kfree(irq_ptr->ccw);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index ea09aadaae4ec..bd80703c174c7 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -253,7 +253,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 		if (!ssqd)
 			return -ENOMEM;
 	} else {
-		ssqd = (struct chsc_ssqd_area *)irq_ptr->chsc_page;
+		ssqd = irq_ptr->chsc_page;
 	}
 
 	rc = chsc_ssqd(*schid, ssqd);
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index e167aa75c3dff..a2ff51887537f 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -136,7 +136,7 @@ static struct airq_struct tiqdio_airq = {
 
 static int set_subchannel_ind(struct qdio_irq *irq_ptr, int reset)
 {
-	struct chsc_scssc_area *scssc = (void *)irq_ptr->chsc_page;
+	struct chsc_scssc_area *scssc = irq_ptr->chsc_page;
 	dma64_t summary_indicator_addr, subchannel_indicator_addr;
 	int rc;
 

-- 
2.53.0



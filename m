Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFC6606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fXPm4Y8e
Received: by kanga.kvack.org (Postfix)
	id 1F0C26B05B4; Mon, 26 Oct 2026 22:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8166B05B5; Mon, 26 Oct 2026 22:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE206B05B6; Mon, 26 Oct 2026 22:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70B26B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D30771408DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:43 +0000 (UTC)
X-FDA: 85366893486.26.20B3AC9
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27CE540002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXPm4Y8e;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 36BLgag0KCOsXRiVaYbhTUYVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=36BLgag0KCOsXRiVaYbhTUYVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
	b=NitDP5EsHO1UnAvyL/LL07yU8K6026AARf4SHzJ9PRKS4Omu0mArKLo8zeYpIGPOM8/+42
	f2TdprWRYJwpaPn+JgGYDT5ffj8tqSDtWhmytUaTui3i1UI2XSePo+s9WkoSCuR0+gPwHx
	uolSJIXWdAck8+vTv6lPh6m/1bvygNI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXPm4Y8e;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 36BLgag0KCOsXRiVaYbhTUYVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=36BLgag0KCOsXRiVaYbhTUYVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069802;
	b=mVNAxyPz5aiRoikCgnHMPPfaF11nRnbiTlIDjU3Gre36o945/MwM12MutzP1jgomauDGXU
	EkF6fPiWscET0K630n7gyuqiqwY6H8Vu3chjDVl+QUaUusajoUEEUe2hBcAkKYTKiKBjg3
	hrr2AQuFUD3LeaPJ/MUKKufrrZqQIog=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab4f652f9bso3100217b6e.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069801; x=1793674601; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
        b=fXPm4Y8e6jXeTwVHF5WXVaNHvV/Q+SPJsjyKWh22XGq5G4z4fNlVe7tZZY+N9PGX9p
         l3RC/IPn6Pi9L5IAurHNhEiYcpsW/ofPjcf7ncDedJt1KAzRNAnA19R8GB87TbUKQCYT
         RdmuAAm3T8pZewYEM18hpVN0uNnBnx81kADsxRQER6yVNDNldshva2HQjX506RUPr+FR
         8F+RrvCFGPwWghbONxORTiYwLGiO9v4wYYKBML869WTGOvr2l+kayD3g85rZgfq8PnQr
         +CRSYv3y4WZxirRavcrhCmJ2cErZFstHy355UcCQ3ozRwjwFfSMUoX+q9klT1uo6OGoQ
         OsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069801; x=1793674601;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
        b=ULiEVwX9WjhlEhlNk3AP0QR7QCbIHgKzR9mtMiO7RVx0omCL+eP0Nsvp7IjbJCboVa
         szW42BX6st3hjU0bDQ7h/1rPcr4vx1HvGUdmwzNPiKV0bE3VBWkb0arL0zq7qO8VBsbr
         pS7O6hJzI3Qw/e2yYkQUCIJZoMEJeSXXD+ajsOc2uJKjenOpFq661W0bobxti+yg5Woo
         Gf4RtneWYZJsRc4YDBcuUSJH16knUBonit0KfRWCoejuAfG117ZeD8Jqr4C54gE2D+w4
         OzoJH5XkEi6/Imf5T57lenBfmwuCIQsGazuGBblJEIK67M5YH2/RBJ7Z/zY0MZDowDEw
         H7jA==
X-Forwarded-Encrypted: i=1; AKwUvBxOqb8Ivy8e1fe8UE6BJ3UV+Scw3WqqNCUnrBqEE8rBbBoRE5joyAg5dXoVVct7cyMG8x+QATUtOg==@kvack.org
X-Gm-Message-State: AFq9FYLlvgWCGTC+cMOSp3MYFbsXKNsYc576Tn7TcRx1zd/qbzaGxGrC
	16YTy1x+gcPnSpl1N65BBr6p4ctp3q/o8aT1Z4+C201gsfCCQM7BMaqz3WiEVLg71EHdS2eRpWd
	LXZTnlQ/fPK+BqQg4D6EtM/21hHXvFGt9Og==
X-Received: from jabhk1.prod.google.com ([2002:a05:6638:8081:b0:61a:c6d0:40f4])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:148c:b0:4f6:2ccb:c2a with SMTP id 5614622812f47-55c0039eb90mr5670563b6e.68.1793069800756;
 Mon, 26 Oct 2026 19:56:40 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:04 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-2-kevinloughlin@google.com>
Subject: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27CE540002
X-Stat-Signature: usm4z1ie3j9u6htzwsgz7qq3xa5s7xc7
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069801-250586
X-HE-Meta: U2FsdGVkX19bZgez603rICG5j2SsGRap6MS31BE9JE4+ImtN64nPFy2xcySif15cQxIVF87siuxYR5wzXZCDbqpX+vm2lYZMARLPToA/CtFA0SDELoxxtFfh9Ezkab03tCkN/Wyy2Hdat74np7d1B4ngR+t9jQUt2yapCQyvSxEBmtKD7U8BaaUg+84iiSzeFrOWMVFRInTx5nIu3CPhg7WTD41e5Q/cNEhSqpI+YF4h3CJPCCd6VGV1XNI/oxNtc0022B9UOpe+TOduDCzgMYOpKvNo2LZ1YBK6Hjun9ERC11HDi4IaugFdaOQAnEJB25iftvCgHJZZUelVBeeISc3Ylu0QECnt/530aaHNs54HM/GbMXBCgrz3AxVdRfVUd1nZbk1zqBweQVqFXMjMlFj1OUkAQUpwaB1b9ylABRSXhpH6OHcie3Ml/48/0frauVlvj89uG2MXArxWg47ZDpzN50lKd/U0JujlBJvjY9VT0YbiCfdb6jGv2oIlSqjDl0Ls7TADumDvXWATtqHUG1bH3wZvFyIiwW3hAwHckaynGukkAUFpujZdf4u3Z0wbbRrjznPo+5dEmXBMshERlV7JLdSOkn8xnbXfYoeDz8HQLuA/lbOAtBsaNNSl9TNFlgDuOGWegptgTFSFj1LcW+vFEdsRFgZX/lg9xkbKARtpFgVByhh33cvvLXxlE2usu6gqIzLO80UAYvPwIcvatPzGI7+jv/UGcWWvXyWMG+1XYCG/gR8qW4Z8w4yZchImU+7Zq2yk/B0mf1Yr5QlY+kOUZJKH3h8XLvYmUnCK7XW1CIl06TKOgBLUzE0tz/K0Cx1Gg5lj103WcqifkexuyJoK9xuCiz2NzUcOHDmKoBvHUQh3ltdj/LL6lSQdiEwYA4+MvLTnb1+xgBslEb/dMq1GPYL+KUJBFYd2XefrB1Caoq3mCrn+Gcj2/PbrpqFMM0xO71smjH4G2G37UHQ
 6rE6drUR
 2iOKV6uLy+NvOUDZnvV5R0tJ59UV98nmFVe7BMH0G6S8mvHGw7CNdvtaOcd8J7Ixbp4B8+PPopl5/KGmsOQ27nUl38d+/w1rvC+UOcmHe/KxKcZmSFlU8Ze/lHUNadXWhB5r5pRDW0kJM+CpwvDqpqxhiWMSHtRJKnkwHJKf4z+BRkX2DXhmFv4CAbDljGDiTxI3dPA4/GgrHuHGq6lk6o/dYEvkzl10mRmRUfJPZp+VxJrsChKGmtqOoEMm613MR3NE2faTRgcvc3/5XLHuy6REFtoUXO67aSnQM54q5TvEEjD4AVoZ01b7Pa5vzELN7slkpOnXf+bBRB4Ud2jhxzNacvGYfrHU9pc/xEAcSQxKJi2Z5VQimiqF+mx2aoSxJBrTsDxaO/5NH/MmgEYFfpNUp4Z0/YWCaZwzrxgTLnA5Vhp1PvCBg1/RO0PDN2zWMc9Ihb8friZBX4vOmxvyURfcFsXvgs2yPPOMd7hcVxGsxfq906v+bcVOD1XvSxXqXmInDm16Yu6k9sZDB/r4XwK5+QnxQLkp0tekS+GWunqZcuA85KdaLgc6DKu9r0G4ha1X2q270I0ONw9tbNJ7TnWQhT2oK5CItGBEIutwTq3eQFUXYlFRGtEdYWhBNTvCJkbWh+6GrMu13ZZpT96M2UXWOV7lw0gVpCk2h0vXUJEpEk+6pmrB+1lN3tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow individual virtqueues to override the device-wide DMA mapping
operations via virtqueue_set_map_ops(). When custom per-virtqueue
mapping operations are configured, vring_map_one_sg(), vring_unmap_one(),
vring_mapping_error(), and the DMA sync helpers dispatch through
vq->map_ops instead of the parent virtio_device DMA API path.

Replace vring_map_single() with vring_map_indirect() and
vring_unmap_indirect() using the device-level mapping path (vdev->map
or dma_map_page_attrs()) so that indirect descriptor tables continue to
be DMA-mapped for host VMM access even when a virtqueue overrides buffer
mapping via vq->map_ops.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_ring.c | 136 ++++++++++++++++++++++++-----------
 include/linux/virtio.h       |   4 ++
 2 files changed, 98 insertions(+), 42 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index db678f5a80e0..9c6a1e9f0a0b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -261,6 +261,7 @@ struct vring_virtqueue {
 	bool we_own_ring;
 
 	union virtio_map map;
+	const struct virtio_map_ops *map_ops;
 
 #ifdef DEBUG
 	/* They're supposed to lock for us. */
@@ -477,16 +478,32 @@ static struct device *vring_dma_dev(const struct vring_virtqueue *vq)
 	return vq->map.dma_dev;
 }
 
+static inline const struct virtio_map_ops *vring_get_map_ops(const struct vring_virtqueue *vq)
+{
+	if (vq->map_ops)
+		return vq->map_ops;
+	return vq->vq.vdev->map;
+}
+
+void virtqueue_set_map_ops(struct virtqueue *_vq,
+			   const struct virtio_map_ops *map_ops)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	vq->map_ops = map_ops;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_map_ops);
+
 static int vring_mapping_error(const struct vring_virtqueue *vq,
 			       dma_addr_t addr)
 {
-	struct virtio_device *vdev = vq->vq.vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return 0;
 
-	if (vdev->map)
-		return vdev->map->mapping_error(vq->map, addr);
+	if (map_ops)
+		return map_ops->mapping_error(vq->map, addr);
 	else
 		return dma_mapping_error(vring_dma_dev(vq), addr);
 }
@@ -530,15 +547,45 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
 	return 0;
 }
 
-static dma_addr_t vring_map_single(const struct vring_virtqueue *vq,
-				   void *cpu_addr, size_t size,
-				   enum dma_data_direction direction)
+static int vring_map_indirect(const struct vring_virtqueue *vq, void *cpu_addr,
+			      size_t size, dma_addr_t *addr)
 {
-	if (!vq->use_map_api)
-		return (dma_addr_t)virt_to_phys(cpu_addr);
+	struct virtio_device *vdev = vq->vq.vdev;
+
+	if (!vq->use_map_api) {
+		kmsan_handle_dma(virt_to_phys(cpu_addr), size, DMA_TO_DEVICE);
+		*addr = (dma_addr_t)virt_to_phys(cpu_addr);
+		return 0;
+	}
+
+	if (vdev->map) {
+		*addr = vdev->map->map_page(vq->map, virt_to_page(cpu_addr),
+					    offset_in_page(cpu_addr), size,
+					    DMA_TO_DEVICE, 0);
+		if (vdev->map->mapping_error(vq->map, *addr))
+			return -ENOMEM;
+		return 0;
+	}
+
+	*addr = dma_map_page_attrs(vring_dma_dev(vq), virt_to_page(cpu_addr),
+				   offset_in_page(cpu_addr), size,
+				   DMA_TO_DEVICE, 0);
+	if (dma_mapping_error(vring_dma_dev(vq), *addr))
+		return -ENOMEM;
 
-	return virtqueue_map_single_attrs(&vq->vq, cpu_addr,
-					  size, direction, 0);
+	return 0;
+}
+
+static void vring_unmap_indirect(const struct vring_virtqueue *vq,
+				 dma_addr_t addr, size_t size)
+{
+	struct virtio_device *vdev = vq->vq.vdev;
+
+	if (vdev->map)
+		vdev->map->unmap_page(vq->map, addr, size, DMA_TO_DEVICE, 0);
+	else
+		dma_unmap_page_attrs(vring_dma_dev(vq), addr, size,
+				     DMA_TO_DEVICE, 0);
 }
 
 static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
@@ -576,6 +623,8 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 	if (flags & VRING_DESC_F_INDIRECT) {
 		if (!vq->use_map_api)
 			goto out;
+		vring_unmap_indirect(vq, extra->addr, extra->len);
+		goto out;
 	} else if (!vring_need_unmap_buffer(vq, extra))
 		goto out;
 
@@ -761,10 +810,11 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
 
 	if (indirect) {
 		/* Now that the indirect table is filled in, map it. */
-		dma_addr_t addr = vring_map_single(
-			vq, desc, total_sg * sizeof(struct vring_desc),
-			DMA_TO_DEVICE);
-		if (vring_mapping_error(vq, addr))
+		dma_addr_t addr;
+
+		if (vring_map_indirect(vq, desc,
+				       total_sg * sizeof(struct vring_desc),
+				       &addr))
 			goto unmap_release;
 
 		virtqueue_add_desc_split(vq, vq->split.vring.desc,
@@ -1370,6 +1420,7 @@ static struct virtqueue *__vring_new_virtqueue_split(unsigned int index,
 #endif
 	vq->map = map;
 	vq->use_map_api = vring_use_map_api(vdev);
+	vq->map_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -1488,6 +1539,8 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
 	if (flags & VRING_DESC_F_INDIRECT) {
 		if (!vq->use_map_api)
 			return;
+		vring_unmap_indirect(vq, extra->addr, extra->len);
+		return;
 	} else if (!vring_need_unmap_buffer(vq, extra))
 		return;
 
@@ -1585,10 +1638,9 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	}
 
 	/* Now that the indirect table is filled in, map it. */
-	addr = vring_map_single(vq, desc,
-			total_sg * sizeof(struct vring_packed_desc),
-			DMA_TO_DEVICE);
-	if (vring_mapping_error(vq, addr))
+	if (vring_map_indirect(vq, desc,
+			       total_sg * sizeof(struct vring_packed_desc),
+			       &addr))
 		goto unmap_release;
 
 	vq->packed.vring.desc[head].addr = cpu_to_le64(addr);
@@ -2620,6 +2672,7 @@ static struct virtqueue *__vring_new_virtqueue_packed(unsigned int index,
 #endif
 	vq->map = map;
 	vq->use_map_api = vring_use_map_api(vdev);
+	vq->map_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -3064,7 +3117,7 @@ struct device *virtqueue_dma_dev(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	if (vq->use_map_api && !_vq->vdev->map)
+	if (vq->use_map_api && !vring_get_map_ops(vq))
 		return vq->map.dma_dev;
 	else
 		return NULL;
@@ -3809,18 +3862,17 @@ EXPORT_SYMBOL_GPL(virtqueue_map_free_coherent);
  */
 dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
 				    struct page *page,
-				    unsigned long offset,
-				    size_t size,
+				    unsigned long offset, size_t size,
 				    enum dma_data_direction dir,
 				    unsigned long attrs)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
-	if (vdev->map)
-		return vdev->map->map_page(vq->map,
-					   page, offset, size,
-					   dir, attrs);
+	if (map_ops)
+		return map_ops->map_page(vq->map,
+					 page, offset, size,
+					 dir, attrs);
 
 	return dma_map_page_attrs(vring_dma_dev(vq),
 				  page, offset, size,
@@ -3842,11 +3894,11 @@ void virtqueue_unmap_page_attrs(const struct virtqueue *_vq,
 				unsigned long attrs)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
-	if (vdev->map)
-		vdev->map->unmap_page(vq->map,
-				      map_handle, size, dir, attrs);
+	if (map_ops)
+		map_ops->unmap_page(vq->map,
+				    map_handle, size, dir, attrs);
 	else
 		dma_unmap_page_attrs(vring_dma_dev(vq), map_handle,
 				     size, dir, attrs);
@@ -3941,13 +3993,13 @@ EXPORT_SYMBOL_GPL(virtqueue_map_mapping_error);
 bool virtqueue_map_need_sync(const struct virtqueue *_vq, dma_addr_t addr)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return false;
 
-	if (vdev->map)
-		return vdev->map->need_sync(vq->map, addr);
+	if (map_ops)
+		return map_ops->need_sync(vq->map, addr);
 	else
 		return dma_need_sync(vring_dma_dev(vq), addr);
 }
@@ -3971,14 +4023,14 @@ void virtqueue_map_sync_single_range_for_cpu(const struct virtqueue *_vq,
 					     enum dma_data_direction dir)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return;
 
-	if (vdev->map)
-		vdev->map->sync_single_for_cpu(vq->map,
-					       addr + offset, size, dir);
+	if (map_ops)
+		map_ops->sync_single_for_cpu(vq->map,
+					     addr + offset, size, dir);
 	else
 		dma_sync_single_range_for_cpu(vring_dma_dev(vq),
 					      addr, offset, size, dir);
@@ -4002,15 +4054,15 @@ void virtqueue_map_sync_single_range_for_device(const struct virtqueue *_vq,
 						enum dma_data_direction dir)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return;
 
-	if (vdev->map)
-		vdev->map->sync_single_for_device(vq->map,
-						  addr + offset,
-						  size, dir);
+	if (map_ops)
+		map_ops->sync_single_for_device(vq->map,
+						addr + offset,
+						size, dir);
 	else
 		dma_sync_single_range_for_device(vring_dma_dev(vq), addr,
 						 offset, size, dir);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index f923e42cfd01..20fe333d6778 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -44,6 +44,7 @@ struct virtqueue {
 };
 
 struct vduse_vq_group;
+struct virtio_map_ops;
 
 union virtio_map {
 	/* Device that performs DMA */
@@ -294,6 +295,9 @@ void virtqueue_map_free_coherent(struct virtio_device *vdev,
 				 size_t size, void *vaddr,
 				 dma_addr_t dma_handle);
 
+void virtqueue_set_map_ops(struct virtqueue *_vq,
+			   const struct virtio_map_ops *map_ops);
+
 dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
 				    struct page *page,
 				    unsigned long offset,
-- 
2.56.0.307.g5fe7bd680c-goog



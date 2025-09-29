Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4D5CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99D38E0027; Mon, 29 Sep 2025 16:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B225C8E0002; Mon, 29 Sep 2025 16:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976528E0027; Mon, 29 Sep 2025 16:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 847CA8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 304DE13B1F5
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:56 +0000 (UTC)
X-FDA: 83943366192.26.3D38051
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 74C9A20014
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=HkWzCL1V;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176294; a=rsa-sha256;
	cv=none;
	b=ftsGngOigFHf0tPKEMvysOv8EL/sPru6qyWi3tIc8b6rIdUuEHH5M9kNOculGXZRmBmgI5
	OyrSmYgCBwSaJpHsj/06ko4zv8CYwAeZ2MKdmi0rElH+B0nXyEYmpCeBsZFUgjfEctxJEo
	67U/3dsEt3IUe74LEHXBU69ywQMa2W0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=HkWzCL1V;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbDGddLknqveR3HZ5HKzC2Pgc9lO1H8c91k3ArNBX2o=;
	b=ObftBmF0by8hlah4f6KspIBTMN0U+EXMUN8Vp4wNH6X3Y19C1YKS1u1Ybi9Cy0ri0DyORj
	+IqicEL+ASzZg2rWNW6WEKgv65mCyCe5cxSXwqsQujjVI/+47z2wLaGaO9zW4gOOFFeCsp
	IMowcTH1EkZI87CKRUPW63nMeIaCoNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176292;
	bh=99oZ1P7VzqkhLJbQUXrJREFvLqy3hC4FKU/uBU4LITk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkWzCL1VTgODwNs2olF/EN97qvp+mVWvhDn/cRxOyHvNZ9dxHMYMo093ZkHsW6z2u
	 22bmoYV9rKtr4m9f5UozvRl1b/1iswDL7ddGAk035uAdOAlP+N8JPOJrJuegpIhHvU
	 UJXIA0ATufT54tRGQY0R4NhmSJc+DvzNX+5qDA7KP4RCM9ABxyGEO+c060P8XzMXJj
	 hz/6i138BR0DbfGO48oePQPevtNXwew61jdn2T5uu8d81Nbic6RpZymEFsUZQqCG1o
	 ABzLg51rKa+buvlGZvEwCGail5Z/WoFRBemGi1XoAdRphhyOC0OQwX74OpUHYbf6X6
	 3qgFlPvsfjOvg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1EEEE17E13C1;
	Mon, 29 Sep 2025 22:04:52 +0200 (CEST)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH 7/8] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Mon, 29 Sep 2025 22:03:15 +0200
Message-ID: <20250929200316.18417-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74C9A20014
X-Stat-Signature: 3871as6m8ggqhd1zboqfstcj7c1bnrjc
X-Rspam-User: 
X-HE-Tag: 1759176294-22409
X-HE-Meta: U2FsdGVkX19WLthfLmba0EptojsTzwa3V7xRJEoGDHduMwU2/0v/UwDSM5HcZrr7/dRnhbJPMbiqU2oS0UKt57qBsfiIXTccrAMqxaspBhYnOFcOXwv22e7/87PZw8IXmWsriboxdzUO9yg8mCHuxHcs9WCbeBh3FAMlnH3fzszBOApERmkovjP82CQERnDvUJpbkbcU54YJ65VIWVFy2TbXwqLX2Q+Y32JhUpVQNqBMCuikFOsko7MCBzXGxopNZ7xo36x28lFuo18P0FSHkBsuE4jB9yWTrNjLjSSPZDbEtCCFUPnpSYzwyBYz5v7pJk5SY6KjwTEmPQ18K8Mv57fWXnDg0O9LyHBBr9bZSXUo1jhja7+Yk775cyOpYUg5FTUOQTkh5FiWiiyD/+xr0+W5+cdc83BD+2GILJBc1BPo/wike1pcui2LxYbAeN7l8rCdh93EdmO0N4Rcc3Y33ks8sey/oAWbf3swIg1bPa1flGyoG9hZAWv8SeW5W1x18cSgs/IJJz4zlFw8YL5xGRg7MhRYdqaMk8eUVIDYz4H1OPDKhFICMWFXPAMcuhz7eVE08XtvuD2jxPDs31qZsFuZrA4eBc39WKpu8fyJ2wtqpYsX+sQkMu2MTeyj5gTQpXnac/MIJemwJ2i6XQlOJvxWGbmcnuS6TVYRqAnL1pSwGN+SMcP1hyM9CR/aNSEXhCAybiEHD4qOj2UJAroCTmzaqCT4G9D+hce2mPUSR5GupTY1nmJ6+xISRASuLkFn0lYWI8pCO5WIzZFRTUPZ/lAQfi6TZzIo9VTCOUOl/wQa3DHBdVEK0p3LB+VqtyjuNm6gEMpFwqa1hVpqn6/Jbtq4Pzu+XR+da1XkxLhlqU21AU7tcNJYhN/GALyDlxkhzuYKO9zoL75+Z3PeGwCYR09SO29cvgRrMrY/hwYaXEvivW4xfi4i4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Log the number of pages and their sizes actually mapped/unmapped by
the IOMMU page table driver. Since a map/unmap op is often split in
several ops depending on the underlying scatter/gather table, add the
start address and the total size to the debugging logs in order to
help understand which batch an op is part of.

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 6dec4354e378..aefbd83d1a75 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -917,10 +917,9 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
 {
 	struct panthor_device *ptdev = vm->ptdev;
 	struct io_pgtable_ops *ops = vm->pgtbl_ops;
+	u64 start_iova = iova;
 	u64 offset = 0;
 
-	drm_dbg(&ptdev->base, "unmap: as=%d, iova=%llx, len=%llx", vm->as.id, iova, size);
-
 	while (offset < size) {
 		size_t unmapped_sz = 0, pgcount;
 		size_t pgsize = get_pgsize(iova + offset, size - offset, &pgcount);
@@ -935,6 +934,12 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
 			panthor_vm_flush_range(vm, iova, offset + unmapped_sz);
 			return  -EINVAL;
 		}
+
+		drm_dbg(&ptdev->base,
+			"unmap: as=%d, iova=0x%llx, sz=%llu, va=0x%llx, pgcnt=%zu, pgsz=%zu",
+			vm->as.id, start_iova, size, iova + offset,
+			unmapped_sz / pgsize, pgsize);
+
 		offset += unmapped_sz;
 	}
 
@@ -950,6 +955,7 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 	struct scatterlist *sgl;
 	struct io_pgtable_ops *ops = vm->pgtbl_ops;
 	u64 start_iova = iova;
+	u64 start_size = size;
 	int ret;
 
 	if (!size)
@@ -969,15 +975,18 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 		len = min_t(size_t, len, size);
 		size -= len;
 
-		drm_dbg(&ptdev->base, "map: as=%d, iova=%llx, paddr=%pad, len=%zx",
-			vm->as.id, iova, &paddr, len);
-
 		while (len) {
 			size_t pgcount, mapped = 0;
 			size_t pgsize = get_pgsize(iova | paddr, len, &pgcount);
 
 			ret = ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot,
 					     GFP_KERNEL, &mapped);
+
+			drm_dbg(&ptdev->base,
+				"map: as=%d, iova=0x%llx, sz=%llu, va=0x%llx, pa=%pad, pgcnt=%zu, pgsz=%zu",
+				vm->as.id, start_iova, start_size, iova, &paddr,
+				mapped / pgsize, pgsize);
+
 			iova += mapped;
 			paddr += mapped;
 			len -= mapped;
-- 
2.47.3



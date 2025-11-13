Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51576CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A0D8E001A; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A668E0002; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3D48E001A; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F85A8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 533B712E822
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:23 +0000 (UTC)
X-FDA: 84106197126.15.CF294B8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 542A5120007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pdb2eHGD;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EK/wGS1Cf29Oc3ddciS9rx3mlCn5RJMoPzJ2ygAIvbU=;
	b=R/vLyVXDM2yW3KVs3pXLqpeUR1Tt59Jxs17/O7LfQogLYlfCopfRuhBO3aY5Q8rLUUrqow
	OJ1cChQNtomgjkCEaMR9+P8/g9weySPcQSSnsy2pbWW9xKUAm+I1IypJIkJLdKcDgqchU4
	gymXT2R6Uk0+Ww5Ahjq3+p5oR+VYR4w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pdb2eHGD;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053221; a=rsa-sha256;
	cv=none;
	b=KMh0N9w39JHx/O651gFMJMIFNytUT1yOCNxKcquZxBtX6buuwIpsOj1Yy8LI7m3j5wPVAt
	Z/nMsUZHzWvglRWvJR/saq5EH4rIWDIP5aClb3qtlJD7XWKopIFuSUr4pkxSwNX5T1Uqof
	syVrJGzRu2rFEp4cIY1YYSKg7hO5hCY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053220;
	bh=PYci18VlZZ5sru0Tx0m/q5hJzWG4Ytkv44neBev88QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdb2eHGDc3SXjifd/YCj4PTrkKL7xAsYwSXKYf2WvYHoXxuMgPXC2KOL9aoefU+WA
	 b5gTYL+oUwg6sNzyLRptfHCzQJB7EZ761jQTwHZlJkdoWYhdGt3V8oNQGJsDmCmDNs
	 LgLXkwd/WroB4zDGXQLKocE979pGEABZSppInfiHXtr8+o20aBtDyiQAobunN6RjNg
	 DLV9QRjmT3e8n5hvtPNvoIaMc4mY7UGsrYNll6s55m6hxcqrOywq1xLulJeK/Tx1zB
	 V5nIPbLvDTW8R9DGNV1svUV2QrRW6FnhuZnAfWaNC6hWkqO6+HPlBWzxL4HjbYm6fa
	 +M5pSsw5SsNwQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 32E5D17E156D;
	Thu, 13 Nov 2025 18:00:19 +0100 (CET)
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
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v8 09/11] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Thu, 13 Nov 2025 18:00:05 +0100
Message-ID: <20251113170008.79587-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 542A5120007
X-Stat-Signature: gg7ugk96y65n3zm6z8sak3ba8tjpdjdc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763053221-682894
X-HE-Meta: U2FsdGVkX19EbudJuXjIFcOT7H8ofU4H2rAqTA3QHFxtuDrbOswGuFhbildPY/vUh7yCmjihqcdqliw6NjQ7CcH/HYHDeObcXcv1GgEUqr4i1sMliZryGT+Ke/OmDPXrF4N8lcVGdUcksFGVT/PcfZpWMPEyJ4dnKArOD/k+zsOmn7bzJACj6FYeDLIpwrucXlPWB+wXCkeieyc/uFM38DEe/Mv+NnXmCM3CEBCyejB5ZucjU5R0zLQPLoAzoKmD3VuFciMF3ClDNMD4nIa3gx4zWGJbNDBkh6oBV3a0jsmmO0+nJgdGpzeMF+iQUW2U0SX+JS20wYJkkjTqEH9DBewR0s9C23jF5XM8bxobtDH4N9dOJuoLTbdnXNXBfF2+CKOXDxCSnUEaACH804M/IB7MmfkJL4D+ekCrCjw0QRuj5f4nENJi9xjUSAiYtZG0RRtgUYp6j2n9yknmGqFC6tEHpG36aNig7WsZ+auq34vyxkEkG3XGqPsmvVObyauxAczUSE8DBF/DUrP+EIWtZRocLyjz6OyEUw6hLGaknaMWUSh+cDYbJxf5jeJJv/JsjQpKF14tKpxDYy3vi02jC+kbcL785pQngAoYy2jcB8o2UlYhMh94uUEkFXNsGh4wX6HdmY4Env2NwTX7bQv+mZ/2ODr287f5uWM4OzgHaNLA4Mp1B4tm6d8g7MiwQqLsp2BiFgis2uORey0pWBnkzdlQpxjGYns37tzFMe3ViuAsobVYI37Toaxk1WTDCaR16E73qfthkZlgIjkdxZ16PmSMRwW6j8reHKO6Q+7C5KvCjZZOGx9jb7bj8YYuqStxcUap8Wfp+/secm0JU/JTDpkMyC7t/yu6mAr7SEWKBEGfrDXoj0oZYWVvv743wA3KQHGwRMMOsz1E/N+LiK90CBOJpQ67CV7O72G4wChbyn8teX9L7LSLE3O/3rwrivyw/bV8NSpm+k4wUzYzYCG
 j+IuCT4h
 SiljLQj9SIuofeuB1MHgZ71BmiW5J/bdRGLfFBf1AKjfnONlpV7LvQ5RiJ2hYSIn26vWSTSGmv/VXjmDAwqns7+XfpKprIrwGpkj7wOvJV1EqDYtgwx+I1+0g0MfGeYyjhLdg/vkyzeSdL3Q2aBHRlFm1sljsw2/wLK+aS1VsElDjgvVm3tJcwswkVO9s5nZlg3cZc0vrmazHx7KpYo/RRXIFwUSdSwqAxNlkLFL0x2k2WwEgzuuk4+j3XY40gJcYcTLMy01NGir0c+KATngf3guF+Buq1nyUTZtdqZ4tHFyu8+WzaToDERXdJApUS2LXkTVwFHrVsL41XxkjTQHhVVlVteOPTqFP5/Dsthq7JRDgsOsQitbHo8/B6lKZhPLoK3Q0O3lkw6sIYiY=
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
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 58fead90533a..32410713c61c 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -918,10 +918,9 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
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
@@ -936,6 +935,12 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
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
 
@@ -951,6 +956,7 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 	struct scatterlist *sgl;
 	struct io_pgtable_ops *ops = vm->pgtbl_ops;
 	u64 start_iova = iova;
+	u64 start_size = size;
 	int ret;
 
 	if (!size)
@@ -970,15 +976,18 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
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



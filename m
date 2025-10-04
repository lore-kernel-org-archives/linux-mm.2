Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA086CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2C38E0011; Sat,  4 Oct 2025 05:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D521F8E000C; Sat,  4 Oct 2025 05:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF49E8E0011; Sat,  4 Oct 2025 05:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 955C78E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C0EB13B73B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:18 +0000 (UTC)
X-FDA: 83959913436.17.878F705
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 610C5A0004
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fr5vjJJL;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6Sk5hqN3o7EU7ky7uH/S38B6QQ5U8486HycD+qBSzo=;
	b=emIf0brdErsZzE7THwlNSI+z/sqND1CiWjDQKkLXGKSj0d2H11hi4bbjvxYHeyid9/a8Te
	LQDSO14b0jBpo3bNIZ16Rl0QWfURWF5bxFnHzAcToPv/HmC9HYuHHEc/eH3Aq3UtWzpvqT
	5DCGyPb7ttYcV66FXZo7OIx4pq5irRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570276; a=rsa-sha256;
	cv=none;
	b=6jeF1kQ76FzGc6ztIThuOQtvsxsWEi/rex5FNW3FVG98j5QG3tUQ6/Z0zyXHXXGrYlSPV3
	rZuZvbJpu/Kp8UTNyr0T8a/hbo/yTatFfAqyrTXvQ3XnLjpLSoGVE0HazbjKWEW0KdYZzS
	a2nrg7ekpHoCPjJN70AFFlohk05v16M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fr5vjJJL;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570274;
	bh=ROKoonOOaPmiRlBVqml71l+74uvjDMGSuEeXXfy4kSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fr5vjJJLezWUZE/y6PH51c7nZ6qWesMFK6/h4UtO1zaEOw8K9k9eSpe3gF+4M4/Kc
	 BF0Wm+0fOvnqC9YZzeV6VrANKW13NkkRLg29nu1NKsREzCb3DSBCa16ksweI/z7PID
	 y+vnGvbrenzbK+Jc6ZyM7t6dHo4WxCFFkjVMTlCXXnYU+s62FvYr629FEELjV1YTaB
	 FrGG6iVuV/WfeEgUd/NET0l07ZJQaueiigQz/CYC16Osb70CMUQ0T1te+W3Xy+GDIf
	 pVNly8S61gLafxHpne/2nHCRUkJLFq81J3LP5Opfvr5HXtcj/Ho7LZvBTp/MVbY5Qo
	 dtNOAHaNMRogg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D1BF817E154C;
	Sat,  4 Oct 2025 11:31:13 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 08/10] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Sat,  4 Oct 2025 11:30:51 +0200
Message-ID: <20251004093054.21388-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h9mqsaa7kj39iqe1ry5qphna6i7msiju
X-Rspamd-Queue-Id: 610C5A0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759570276-988808
X-HE-Meta: U2FsdGVkX19AxzZfeLZoruY3Oiis8glGb4N7haEzDUEr5SM2MxsAjgOy6NbVnTFAg4J0GdlWhEas8gaNvPMWeILXVqqS7ogfjM320EjLiUhIWsxAcA4jQZ5c2MpdjumBhjN8fxsxElG0TxhWOjmoiIQ+fuV6laUUCjAggYfCHRO8VLefYcjnxFAQMqtzlVLZpD/MQv6QGBjZuBqtB/DmGzm2AKRS88BkS1XaJxYwHWpbUug2uXtgro8g48U60qi8zA8s1Tb0xXbCR7v4N2tRqfg9SuPo0sCbbwDWvNnqA7TwuTeUnMMRgKX1uxc7RgJ8/xIjVnA/IRbeSsM1yut6bW5tWmiuHjpZH/XR2/Tw20+miFdf7+pdP4ey6GUh5QhbaLNis7hB2+pKDap5oWsjegeywXSt9M30AokzQuy5YcRl7ANFeiC7AAis1zGyxztmQxvWcvuYNEcUAoL8spnUdTydDXeNo+SuBmhNzqepexg1mZANHl7Sv6fc8ZWYmp+sOArtN/vC0l19m7RQDIX9AjyXrLDXCQcuW28ZzgzwOzIMdnRFVHOmPde+bYwHFWsxK7ceaX5t2juR4IhCeJxieWJs5k3C3BIbutJ2zSxkRBKgOQvTzdnz+H9N4CRl7ctN5jrfE3H/3Jt+hAYfmS6KMxYHlPczqM3+B0viyGNGD1NGoYFEjpqKOCk9INPxAJ+nq5ur64tB5uOwVW4uFPAC0GaMm4unzS2YQDNFydtO5OQp1JjYBzoFhC066naUwG2201VapS7t65bPzgZhsR0z/zMVKNwYzRkzITcFBL0iqJ0nGqSnpkr98KhbBLCXW5ObW2SYoOwkirGLHEaRrixtBOptFro01Ne06sB4vgsypT9EThBxfSO4u71I5SVcGrfZh4jfaVBwnvm+9arGHxeigg7AJxANg0om7/XQ4zqd+8ipj/nh4lflXUXDXH0V0gSLa0d12+Gcbcm7flmmF3n
 fPkLxcTu
 w5GZ1rJyHmJQb39YTCKSu9zMSRpf8b+R3UhcFo5uXRnKa9k/9940mEcCBLhZLH9aOlWuWlDKdkbHjrJNr6UsOAxmnwFq8j5panECTExeEezmUjIo/IiA1TvslFFV5p2kSaop4Eu6aKm9wbmAWWoeyaeAHorrAr0hhzWId++eEpjnqHR8lz8X+tyd+o+fIhbRo6OWREaIffBIWzAjmucc/5mZnGYmYEdR0eGropiOtSo7TsrfdaYnw+6Vvt/2o/B7IR5yi+iNenMDxuJ6tHm4D+B8HBoIOuMQmEYJdUaf0z36aSYkcsmTGDJDkCoGxTxKKQa6QeXGyZv3FY4fTRmJ77cyzggdECi0wQ6qSKmWeFcsODhqSrB0iytHEFjVta7ZXu9eYYVqnCvXe1TE=
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



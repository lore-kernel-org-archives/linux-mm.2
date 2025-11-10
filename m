Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7157FCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B5D8E0002; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4298E0022; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5770F8E0002; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 397528E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED0C4514E9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:03 +0000 (UTC)
X-FDA: 84094926846.11.D163D8F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 296DBA0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="cJLj/E+4";
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6Sk5hqN3o7EU7ky7uH/S38B6QQ5U8486HycD+qBSzo=;
	b=7UZP8XoSx7wcps56cnRf5tlVi6dYih1MBLnaMzucnTQHi9QcrRDrc4HfMcLAlvXUEAS3eM
	Z7KYIyv0qF/2t59M54/UchCv6uxqdLasUYu5LMns2cPxzroFp238DQlT7IMuzOn5QOmQEF
	J4MyUHuewAjdKycN1Wslnqn1DD05JlI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="cJLj/E+4";
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784882; a=rsa-sha256;
	cv=none;
	b=bw805299rMBB5Q4QVpRW4qmrO4wMwyazEUrQVSdzQz+sFW2TnfHGmLc0fTi2Czl+1dbYlG
	jFrJB+D2KlZgK8cZkeCT8hjQIxV3Ma4nENfMnrEhIfBmNcaZW0IJxcIeidrV9X3JR5Tcv1
	FYn51GxmIj/oe8iyXCD6Jiw94EnNMxg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784880;
	bh=ROKoonOOaPmiRlBVqml71l+74uvjDMGSuEeXXfy4kSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJLj/E+4HuNHhgxJzCktpuzosBIh5t2CeL3I5aqCR1Op+VOW5Ae/ChkphYivtxnaS
	 SrJ4sh/kqbt/+C2q7wiEOuc5eVohylq5Pss+mpYbt4fJEP6ZgfFLynsv6zmGBp3hA9
	 tewP7fKHlR8Cu8gB2u6Jy8rEMK9o20ehT2T+WPRb0Tm4ugyZfidPpTbmrk/BqQANMr
	 wyBfhNWfo9zp96MEKwIr400coSgbPPMVbCJr0rG8V/yuTOghlEH8kEttutyjyAP0Rf
	 g7D9C1wKe3chh4rDRU5m9eH2CuUKLsw2efIxm/cwKY14zC7/fBdO87hgV8T0CvKDhP
	 LEcWw1AOW2yiw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 706CA17E368E;
	Mon, 10 Nov 2025 15:27:59 +0100 (CET)
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
Subject: [PATCH v6 09/11] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Mon, 10 Nov 2025 15:27:44 +0100
Message-ID: <20251110142746.3490-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 296DBA0006
X-Stat-Signature: h3yhre3g39ms6fghicu4ppxie1ejs88a
X-Rspam-User: 
X-HE-Tag: 1762784881-368403
X-HE-Meta: U2FsdGVkX19mHO4ViKf0luN6PnbHR9T+DebTi7846q3gwgxBSJ8AHykiqibZl2YhAB90R00Ma5+yCqu+3X0dyupm+k7GzqMKfiuc7YJ0uUvF1GVl7vDLXb9Qyinue/6MsYcvGayS8BU9vKIE3DZY37STFQVB0DcJ2L/Q8PP9dvE6WNlf5Jn1WBoCKvnoE7i6K/NIMzFmgthE+zUFI4LPTdlPUttAE9XhejzFnJf1LOqfhPVXiVGzBFzG9tH5LOe0xxSBcd9LUwTc0WRiNq4h75Rxis7Ub+YsNwf5f7X2vKjGeZR0Z9mqgYK4VLHiw/FLL/5ib0qAzy411pj4PpH7ZWTJ8i0ilJ5bUd2DPYKYsnvU0B2GFfXT/DVoTROTChI/v7XaqKCr9vpX3qnZrU9tMPAFnNhhip9q+wKdrH2T43VH98egnQt1IERUUynGKeCgGWK8S1nKsa2nwEDpz1wXf0gLvn5oBiy2JMOCArZdktxbYTtO0h0wONLf34/4/hxejziaZliR5fROJKNoqYHkmcw1msjIse2Lf0lFBLiuTpUhktQQByxfv4GsXRg6HS+5b5AfgasltZ0hAx3RqkdsDSW9kvXNiM2B29VwA9vzMdeK+pLoi9Xn9NL7/LOZI574ZKmH0T4izpvKyh83l6SxdRwSw1EKa0/Y/Iy5aUn2ZtafoBRGKr6TXrJ2s2NmDIdV6f8+5zhCO4/vao9Eu1XrFPjvVCEO6mUeFp4Czn9niFdCuGjKBzGbLdP4P2BL6XkMcQvx/jA5ctPdvtCSNl21pqClY/Q1d4W8TH0PZ/2VwrEnkHhBBRGJUM3+6eOeP+Nix7O5FZ/HulJPdpyhzIVQLQGG+M3PVYKAdbn6QtAfyQ+Wc7KDTGAIng09VXIugDa4hLtsS3r0qTuey65TSVSOhqbOFX4iJWQ2ZxYruyjagyTA0/yW9QqhyxeusIrGZT42Yzx9pyN6oHni6X712Yq
 DJO1tf0H
 uO4nt9MQ2CHekOvIGiljx0FDZCH16GW/8d1ICmZpzIyx+buQPllLzR0iS+rJvTX+Ip4+YFDlEgb7C8/mUXW6mEG5yA2mCKkod01RgEcxetIYdDzvY/1oqOueUsstvSaPLiYemCi2PdmSX9VnThFcWJ5xW+Alyclma82bVLpDxhrBzaz3ZtoTNtFOpyEB1C37LF1L/vbp3wAEMr6l7WP3oaK+f38q/p0kyu8kxiuAHUh+tHxXTPzJmg0znPgYFHcz6hsoFF/9dPSk++jEfF+EO7Z6RphJcUW7NOhSBisfh4JsLG0qTbZma6mpUeRJNlcNs+JvWHNoTLGk+zBLmTXJLAlApsf8PLpPWUZdVN8X2mD5wogfqqSNhZ1iTiMPIDPoA/3xXTc2plIdgM+c=
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



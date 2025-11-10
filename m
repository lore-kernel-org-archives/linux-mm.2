Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD741CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B838E0032; Mon, 10 Nov 2025 10:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022D88E0031; Mon, 10 Nov 2025 10:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7AF8E0032; Mon, 10 Nov 2025 10:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2D848E0031
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F6DB1A01A0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:19 +0000 (UTC)
X-FDA: 84095134158.08.ECB20C5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id B875D160015
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Ax0Jz5zJ;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EK/wGS1Cf29Oc3ddciS9rx3mlCn5RJMoPzJ2ygAIvbU=;
	b=JHQnRORCmfkKDuPxzo+JOgjW1Svi9jguULtpkOpPsTReImxplyadrY+OpnDsi8/vI1KJ8W
	JpPUTa1SgE4EZ+ZNfCQHAZ3rVmxtrY47PRvGopAQRy4W1GoIFk8zBEG4Kop9jpMqpe6X3t
	Lc3O/PhcQsWHJvSdB/ULOIeO7/feqNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789818; a=rsa-sha256;
	cv=none;
	b=keuCmAZt/Yz82eDupY9ZNJ/8HQO8wiKcdUrUhMpNQQefLcsr7QZppapPd3Pn8H9RXHaZTI
	nAOYOtfTamy5XeIixqq731p+pJh+9xp1hccJkLW2r2El5AnVWR6y1QTAJ1f3/wMMcSv6t6
	MBXHbVczo0jcQ5O2FL9yLbW+p3bGxDQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Ax0Jz5zJ;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789816;
	bh=PYci18VlZZ5sru0Tx0m/q5hJzWG4Ytkv44neBev88QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ax0Jz5zJrMztn6MurND2d5Vu0o1WIgRQhxZwG8QZ3zb9XEQJLQxiaQE/fma5WNn4H
	 N5AcLnvDXHoPy6/pUQiRESzAx31MnECbCMRrUWPIZbXWxmWXdFrEPw6I8bgK9KarYP
	 JR+FHnkh95EHHjrjZwuz3QCSEysm5VSWGbwrlMSwJRzGYBKyr4NILlW2W+TXdA7J50
	 rAG3kRGyStxRfQQ8PPnKx798zfibb0yvLUujHU22O95jnR0Qi+hiVpu7/6qJsimrhP
	 IDJ4LjXHvtuO07zftODPYt3H//xJk2PG7zBTMng/8RAZu0ElVBdNVxeGBdtmTIS0+g
	 7TmIhPZMc3Ouw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2CEA717E1416;
	Mon, 10 Nov 2025 16:50:15 +0100 (CET)
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
Subject: [PATCH v7 09/11] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Mon, 10 Nov 2025 16:49:57 +0100
Message-ID: <20251110155000.2936-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6c7m8y5duhfzqtwdark46pxhf43ei3g
X-Rspam-User: 
X-Rspamd-Queue-Id: B875D160015
X-Rspamd-Server: rspam01
X-HE-Tag: 1762789817-37255
X-HE-Meta: U2FsdGVkX18zsWl7hagf/0YnBDup9n4YVosBOsdt1aLqykkfrNcfy3QHZvHmCO4p7bQAPGcSEPh2nQihBilr6RCJLNaM1AYPnwn1Znkv5hy2E9G+lGbPFvguyr+SMhNsGYuUy2A+fF7eDanxLCZcFzJk7+gcBtBlEFHlZF5ZUN62FydbttHQFPUjX7WjKg1aqVzYnLLt0PSA3NReol8t34LaTBf3MiqAOPnkHZFysc3QJPbGuV6Ja/xPmLsK2D8X1/hRfmNcerOpiLVKWKLQ/DF0Cjh+myau2Uoup5W8k8IMz1vX4bUaA5hQBW3U/cUOokx4OH4oxscE1g+oG84dTsb/nlSrz0EuGGLWNKrjoocPbZau22frzBUEaJkUzc1CQm3wsHKCBC7GMxEMjQIgJqDOef4EHotDAR1HE6K7ar4l9GF2v8R4WvG53o3eogqDKd0z4vMFbiWMYXjRz2JE6FxrQ0hKGUfIdsl8QFabNPOyA0dxL4l7ptr6/41mlRApzWYuZXBT62w4eASw0zDjEPGLHnhxl3OUOrMAM4P8DkhoeHNu/EtarpoDs2ARWznJ8vGdoi3a8rSjM/L3YUv8Jya/Pq5RnsUztAkvGyTsAVb0+4DaKsgl5n2Aw/cc+G8UAt53lpDiQ0BJxushlU64Sq4wmKRpblLVGlSfEroK6txDJ2yimMFpr7OE43MJhXTK+NCcgVuGNCcWa+DV8lyg1HL6yQpAqaP3NW9yAa9SexItDvf07An9pzpeESquuD0AxjKzO2VRkvU3V55URodc8pPjZX6QtjWFO6MSbaOIAucYdjFdb/IANHqHhzG0kFMHqr7Mghk+Ci4aqLzlRePlGewIF+L1yT6by+A3L2y4nz75exxgjcJxdb6G7OYPPoredPxTHbhHfOWI3siAxYVaymonqKw15fUKhivvafAG5zRIbY2njfU6XjJdqCQ4HbRQ8cCK2LRyUyyj3J/1dws
 fE3HILWL
 GBCEdBUq4A2Jc9E/OkH6JoTDYlMFCtAj3qLK+VLG65I6I5dZiL4BydthWORqIo2icqcde+zgXgbeoml6UKPG6LhvQqFNmq4ZbJeYmI4suHhoB/wiTCAIOa51VcH+0CnZC4WBqVU1OoaPVYLipj4koFPZsegOEzuQwdMiYYRohT2IB92bHjLBBfCjUMM0pbp3zDeejPTzInbkFAMDHEdZU+FOxmss4OqUzhxybTS6AeTWLdrHOOVAB1QW5pGpHJcpOWqZiM4vFmhDMoafTz/DRdykUKk1YND1W8WGzkGj0ZxYBpD/Tk2OUrX9X0U2c7V9zn29zhnWG/qcB1bTyFUoxlrF8HSJbCbMsoUAp2kmwbs5hKQapOOod7JIsVe8HS369mxsb
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F422ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786168E0027; Tue, 21 Oct 2025 07:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736908E001A; Tue, 21 Oct 2025 07:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE808E0027; Tue, 21 Oct 2025 07:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 427B78E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEFCDB97A9
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:08 +0000 (UTC)
X-FDA: 84021905016.11.9E7CDCD
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2CB7318001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="AOEk/KsS";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046267; a=rsa-sha256;
	cv=none;
	b=vD+hFOlTJ0J5LSQhZ4Td0PapINnz3Qi5KTcnNRsft0GGNSDNzSVBEvTt3XR4Xzlt0Q2FDL
	cHseVEksXH4wGbWT+thARFA5eKI6RHmZhuFoBY9QH2QZCWtR+zutJU96RE3ZoQ3BdMS7xj
	tGr5WXnpzGO1E0C2s7eGDi/oML0Jb2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="AOEk/KsS";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6Sk5hqN3o7EU7ky7uH/S38B6QQ5U8486HycD+qBSzo=;
	b=19iEAFEpons0u7A345TxD+QMvi0O08ZeVUW4uK8wdRssNk2ZpRpIMdhA9TTpv/6w0rhNHC
	sou4Canw3hR+sZ5dmFYXtfOYXZfO39ewJB6iMQ2hdhoC784hFelYbUgSOYxZu3bpOE7jGt
	DXTezzO6HmzlQ+uplwynn9XwPDiaPlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046265;
	bh=ROKoonOOaPmiRlBVqml71l+74uvjDMGSuEeXXfy4kSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOEk/KsS2zt9mawXPmLPkeEnyAohfVhVSvWJwcYIKFAH1sx9L7MMj+N+L1onjTtEa
	 46Q7GzJgjy2k7iOSZQE9Lox6GrSxl9SIdxmESJZMhl+u/0KGySyjmqGjga+IcGcAfA
	 bnWgxwajf2uW40hzd0n/Q4X/flKY5hGXBbF5gNmOEmAIbsm8yBmbLUhs2tmgZIWPjK
	 W6ryhaZ+TwMUn7XMKo0c9X3FYt8lTDsofWZCD7VIgPWVbA2Br2NUmHPl5sBxnf2Vt6
	 H/yw5pg4mVyGc/kCyCQMrxqg7MPEToMO9LFLc1AQ/tZuYc6bPbN4elVHAVaXzDHNg2
	 d1CZEJ3IJVkvg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E3F1017E15DB;
	Tue, 21 Oct 2025 13:31:04 +0200 (CEST)
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
Subject: [PATCH v5 10/12] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Tue, 21 Oct 2025 13:30:47 +0200
Message-ID: <20251021113049.17242-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CB7318001A
X-Stat-Signature: xy16hco7rcw4i78m8bkp453m663y7s44
X-HE-Tag: 1761046266-826497
X-HE-Meta: U2FsdGVkX18MLWXYhNq8FNAAOO4+MXJn9drMibmBShzYPIwGpu5IbfmZYGHTDjvvBb4yAuJPLYrAxUs13Le/X7jKJTEmGGRC5V2Nvah6wkdEDKAvoh2HDA8hKwSQXFUposNrhA4bFL6OMAnjWJbXHaIumJ4JOjL3bQb32QupIpLqwnmQ3uA/wl5ccipP/FOG+TAQK2UcRD7c+F3coBLU0sjslIrvTEN4kjs7k/NO1PvpTtSGziVegEFg3Ivs2a3uWy8wNYNeJHDWlP8N5/PdPT0t3ApSooxWwHZK0GL8jwucZSGj47xjWvs7WIPQlPl3nb5Ww/WgMcaIcST/C5cO9MJDl1VkmBAM5XhLP+MXGQsredVBHhw1kLZ0Rk9PB+eog2/cIsgEcD1+a3hOK8Mt8O21ekM/jU8dQ9ou2Yczy5I31NC2IvuUxE1BQcJD7t+zzQVwraEZv7eJVs7fYFUHcfYXhVWqFNlT55hlu9S9ITxlJ1WugYKbSZu6lIxSRKkyB8IWw3Gj1oLuySzkRz8DS2B6isiDe+mtfiUgaYOkstJdfTrcIgOhGy4sfYagVQjC29nzMQLzD/qUM5efakdiWsv4lKBnkVE1Cc+QvcrqLhNn3aFeL3tXDXDpLTKi4kpurxinQmtVrICj+m5a7O3U+yQEnMi8THj+Bb/cGROy4XUsQ4Nccuc0aUhqoGrYdWdryUhOsbKuk97+MC8sh0hOFQUZd04FRG83BdGP1zjZaWiQr7WhB4qvjZf8xWx5uhqtcb1ihheNTOfWLARVcrgv1qprO4nE5jrIWFogLjmqM5ym9+X5IkCH32mp7K3/PDFVUNmfPODdv5Ou2nwvfaxooVhC3O0hLPm9XqWKD1oNO+cVObBGglqTLdhIJxtLH2c6jmItbB948AYNpAkeW4W/1njwHe5NbCz2gFHAEIszk9Z9W/M8USsmLuh6w9yPTNtAttIlErg0e+LyPCrprdK
 l10QLzny
 Nn7y+TgwGFIL/exSukCAzm0Is+jL3TaLLXCfHKGEzK8SAgnkDWmbsvZGdpohr0lUUaJdt
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



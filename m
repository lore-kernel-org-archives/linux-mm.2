Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05270CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCA78E003A; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3672A8E0034; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9D58E003A; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02C4A8E0034
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFD7D59042
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:19 +0000 (UTC)
X-FDA: 84109833318.11.CABAFFA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id E447118001E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=plt5tBhV;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EK/wGS1Cf29Oc3ddciS9rx3mlCn5RJMoPzJ2ygAIvbU=;
	b=bLKlRlhyrsQXf1Q3Lx1bPHOvlAQx6Lxx73scbJRn9rDWlqbKtCKzwfV1IOAqmpjurvO9Nu
	hXbhDJySo3pM4WcHXcYXv3aIxXhS/b5eaU2Ev5YVfrRqYYrZkFMOz5scTh2jaFEnqGu5Gl
	uHe1sTsyYVTgnPdO3dI4nUYJxKVW2W0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=plt5tBhV;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139798; a=rsa-sha256;
	cv=none;
	b=Zs6hKDfW2l2fR2NBfIUl1pItYfXbqkLDaGWn6WooievgB8b5x1kPYVXSKJ5BGibXJAMJpv
	WRz3nlVt1im/F3BbauLj8bzmIMTKht+m0AJivTArQYfcfcOjtWwNPyJZSySyQw00MMTzDs
	BzIN4Ad/MAUaWCKtbJWEd3Rj1BFUzn4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139796;
	bh=PYci18VlZZ5sru0Tx0m/q5hJzWG4Ytkv44neBev88QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plt5tBhVZiRemU+AUg6p17oPS/5IqLmJ84nGWfx22yDANiPoUKSL6a6BChsevEf/M
	 tj8hXCHa5Zcpw4aVu75+8hSzVF2+AGGsHKyXNtnJJExDSMKH8D236Je6v7EhzrEXRu
	 5MOaU7vEO4tECMAeoypsafKxjWoxJEsSB+FnYVCJ2vpyOmqvpzkpXsR5gQOrm2mFWH
	 fqTwX8k2pqvLMPSRoscRY7QSNE/slkh7YYfWrPc7l+U4jVbwgKm4BD4FSV4Aua0KIO
	 3GOmekLiyk6IqwBPDaysaohq1V3HTlaZnZ2rGyXvgcMJzO0KRPmPy4+VmIyzMfJjKM
	 07SuyOOUVEQ5A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9759517E35CB;
	Fri, 14 Nov 2025 18:03:15 +0100 (CET)
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
Subject: [PATCH v9 09/11] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Fri, 14 Nov 2025 18:03:00 +0100
Message-ID: <20251114170303.2800-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E447118001E
X-Stat-Signature: i9fgapijz8yp4u77s9t6cghwpyccec9q
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763139797-711448
X-HE-Meta: U2FsdGVkX18/5AixWwHLCGOJeY6RDh26dqgJw1LKoUtETaFtuNtGZW41DbL1UP7jKJk9tUVdJpH1xR+pYgL+/MJ+C36VwyhowoJ7XXNoNcDNI6uTHNnUbzJgKprydtKPWvpu4IBTcIZm/uKckn3U8JvVFD9XnMfcavAob/webv8ADG9NQXCxIOsh+OkKok2FVpbAW2aLJOqY/Dd5T/K24yVB2E5gxNINW34PZeShu9YhfHKytBs/PT9iXM/6puk/J6ATFbrpFC8IU0cgfijyXAmZN3dl3zMlw4sy9Yxf4+prfm2Q3/s0Q8T1HfBp6/cgAd9lAQF9JBEhlNmVl3O6PEG2Wggtzu7EAj2HSNrjYKN9MMSrlUTholHZmsEn9Lf71WsSEswib8PgcUrrfuo97NwxUnbAwjsgAASLZZNS98fSEuFOrJk9PaTkFSSzuy8DS8iD51u4adH61bRU03ogjoYTpOXCcRGZau+hEpsAwSm6MZNhUy7/ge5OgvejzIe1pwcuhDFDWfS1wtKlCuTpZtfr1FQEtLkd8/G9oR0hkaSfD5cwDqjLLG0SYDSoQpPWr2UxCzQMVCZSxbU6hKow4P8J63XFJJidLSbKM+EinOsjWWGzF9VZdexp3419eAH2o04eqkwzcx6cIjCNEChUwu9r9R1Y8gm6y4k90l/F+g0LPMaCJh0nz/it+vZ8AWpTVTvoTUGqAOfBngCXSSd7T1HY4d2klOMiWwbOpTQru7coCvPKRK4lOknXQzqqX7+RSBR6bphLUX68gZkiCULf0MRTVPY6Fa+GdwyVBT4kLUaO33x+yP1v28Vh525vdh6z8pXw8G6vvChG8Xp5D+y/kDAJrl3yBr3le/VZI6zWDfqBdqs2v8zhvWi/kqq9UMfVmJ00c8fDWWXJFPMuVLrlmhowNyljhpJd59Woae+9tkijM+ghpPhKdw==
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



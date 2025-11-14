Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E83CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276078E001E; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227458E0005; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0238E001E; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7D5E8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 908D5B990D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:13 +0000 (UTC)
X-FDA: 84109833066.16.FBB01A4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96B7E10000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=oDl3PZ+C;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62D/XnEn4jQ4Rczzih2IdSvbf7Cdsd6AxgytI1+Qqy8=;
	b=6h6nvvR2DJ4tei8qG35OsDwaV4bXOMJcx4JYI887NV2irWMAHX+XrgUOhrGruATRhNfCDE
	L3ktav3km0drkbVVH1rQfkOj7Xbgy//hRT6W4LmZBfspCFcYngz+UTFq58HG9kaDVs1GWl
	do6m3W2g+qylWTvgzWUrBlFi4NIBoAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139791; a=rsa-sha256;
	cv=none;
	b=1hsWeK7Am9OUkxb8UC6zt6Dga9ZfHr+rDIqeGS6Wt1krd4Ffs30GHdCmz6wiu+ORr3xUya
	8HJCH8TFGeKgzyssLBqinYmyrJI8pkotr6JUOfzZT10nIqML2j0GDOkSSgWpn9PKh77bMQ
	dA4LAeUddUftsXISnQcU6WNhedjZqdc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=oDl3PZ+C;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139789;
	bh=PO8gWy+x68NFPFgtgxVVBpssyG+zZ/+aShO0x1+KKAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDl3PZ+C420mz467u09h9ohNM3nHE7O2xcmlnsq1cFDCVBXA3/cjR9MiMSeOKSJ83
	 3hnLztp20vIVl0PJaJfK3uJljJem+KN7H4AoZPl2xe9+Yg70w/27exUy3w+QPPFoZh
	 HGuKBliF3PGNvQ6wZlyEJAt3XPUVki3lCD1AN6c7wcIFTYH62N00P70DvFOyLf4YOE
	 qn1sy2o8zpjm8T0W92mm5X1k/F41xbPO6JfxEyB3lDwHo8RCwL8Og5/TRjgu2Pmxsr
	 f+UvupAuBvH9AnDXVhYA6V9o+0a3+htEeVpvfgdasEddMsViBU421Xp2OSNji/iXxf
	 W94WhMKTn0BBw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7F48817E12D5;
	Fri, 14 Nov 2025 18:03:08 +0100 (CET)
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
Subject: [PATCH v9 02/11] drm/shmem-helper: Map huge pages in fault handler
Date: Fri, 14 Nov 2025 18:02:53 +0100
Message-ID: <20251114170303.2800-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 96B7E10000C
X-Stat-Signature: pbjjs6xaxjrtckt3ts1641fu4yn667cx
X-HE-Tag: 1763139791-671761
X-HE-Meta: U2FsdGVkX18qktY6LrYt79Lexqgx0hH1gMuSlo34psDlx3QjcNENbt1QS8uYLLUqIOeYogWPI3jnI+AIj4vpC+kZeAl8F/pezJmURokUXnqWKGb+06pUly72U/muRnTFuNYRyPsMn13d4uBwsiFJgztptDAfGRnmp/imlE4jFj/WjM5GgMtp6NFe+8zGhPvH/OfaV9jpUh7yLSikV3aVsENpniszsiCOlsG9OdLmiv55ZeDwrxe2ltBFqTg9uO3rbLAK4E2xpD9xyE1mBeGsX2QmGmfFapztssoLgQal075D+nqD/aMQ/AlUyQgfR3IzpTtfG17g01QGB9BSgIG7kfEZU/99Ne2TQaAH0umXcTfo1oH8zCNmwAe86vOiFcZEcqNiqGQAePI4cK2s6oPeoqSYqLzU6t9Q50HPaX7PvjMGItqgNx0HwADg7Y5SRGk9VGYrQmSvALFa5EUtDmS0yaZwWV3RlIWIqG3xJjkzuSymW1Jtl/pejyGFKGWzk2morcM2GFSeLWIBKwA34iFasA0Xp//15kdgCC3M41u/LxCZtR06NlwIs4gb4q1AwpIvE6Zd42ZxWQZMk1V5Tqmf/uE7/p+2Lh1hYknVEgaP/fn8PBqhHU6KLM9sHyczmR1hUiNe6rcUkXa1AAhn88assyUFXcqW7JWaRcKDzaxl8xNofVoPzbrWaSl3vVxnULHNSroRLauo6JW2g+M/PIYRAcHxxAMDSAsEt3KwCQ1xnQtE8/BD/Om8ohsDq5xSxuL/+GBQEx2zTodAxO/46QF1rpNcrzOiupy35e2YTdeB20WXF4xezFoFTxdVCROjMtnGEOacATt/Rek4djtm5O6r7GSwYrw8OtDB8P1guOJWFqMXyUoPMzxMxDfO+zKddMfT//R9ma8C4dxUZyLxHvRutEIoi7+igc+sYWqdBiVWgECoUjFQFRF6djifEDCWFQ/10/kIUveFevxeAzUSHxK
 B55nJAw0
 ACxML5oC2RldfedKDqtfo0cZQIWgdMJLKz2QkV2Wms9ZRWdEKM0gux5XxighTPuwt8GJ6m16nlFPKQibo+VjBZpnNiT2h+9/+8/vqbnks5kjT/4ueFe3DZHtLnODJV46EDhrQq8LQXJ4B93h8pCU/l0m5hO60VBcIefzUNdCRHVITomnHejHe2k717hRJYXZThPr7TsZQZJscEoKKjk2aRHRb/FyDKSZlr2TQR2QZ+l3OMTH2hQJdhYWYqkeYwF6/z7IDXw+3WT6Op2nJyUy4jb8G/U8jTOgNcqusQT4DpaHhBdzoyLgkv6IE3JiXuWkhVV72YBJQNe3Xtpbzk/815UJhG6DJfnlvaKAEvHg3yJ9MeA2FlSebmd0H36Yfvd4HPPRC1vveg55C0JBPk3cl4NdDxZRIohlUqG35UY/YZoCUJ7xD1MT6e++4x3O0+Jeco5T8TY5NnahBrjKdI/W/6xCvTF2d4mFfUGSdqqMxjxHFX1xezjJii70uCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attempt a PMD sized PFN insertion into the VMA if the faulty address
of the fault handler is part of a huge page.

On builds with CONFIG_TRANSPARENT_HUGEPAGE enabled, if the mmap() user
address is PMD size aligned, if the GEM object is backed by shmem
buffers on mountpoints setting the 'huge=' option and if the shmem
backing store manages to allocate a huge folio, CPU mapping would then
benefit from significantly increased memcpy() performance. When these
conditions are met on a system with 2 MiB huge pages, an aligned copy
of 2 MiB would raise a single page fault instead of 4096.

v4:
- implement map_pages instead of huge_fault

v6:
- get rid of map_pages handler for now (keep it for another series
  along with arm64 contpte support)

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 55 +++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index be89be1c804c..81f4ac7cb8f6 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,31 +567,68 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
+static bool drm_gem_shmem_fault_is_valid(struct drm_gem_object *obj,
+					 pgoff_t pgoff)
+{
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+
+	if (drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
+	    pgoff >= (obj->size >> PAGE_SHIFT) ||
+	    shmem->madv < 0)
+		return false;
+
+	return true;
+}
+
+static bool drm_gem_shmem_map_pmd(struct vm_fault *vmf, unsigned long addr,
+				  struct page *page)
+{
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
+
+	if (aligned &&
+	    pmd_none(*vmf->pmd) &&
+	    folio_test_pmd_mappable(page_folio(page))) {
+		pfn &= PMD_MASK >> PAGE_SHIFT;
+		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
+			return true;
+	}
+#endif
+
+	return false;
+}
+
 static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	loff_t num_pages = obj->size >> PAGE_SHIFT;
-	vm_fault_t ret;
-	struct page *page;
+	struct page **pages = shmem->pages;
 	pgoff_t page_offset;
+	unsigned long pfn;
+	vm_fault_t ret;
 
 	/* Offset to faulty address in the VMA (without the fake offset). */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-	if (page_offset >= num_pages ||
-	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
-	    shmem->madv < 0) {
+	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, page_offset))) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		page = shmem->pages[page_offset];
+		goto out;
+	}
 
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
+		ret = VM_FAULT_NOPAGE;
+		goto out;
 	}
 
+	pfn = page_to_pfn(pages[page_offset]);
+	ret = vmf_insert_pfn(vma, vmf->address, pfn);
+
+ out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
-- 
2.47.3



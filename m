Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 755FCCD8CAB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57FA68E0013; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2128E0002; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA0A8E0013; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8988E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E44FBBCBF3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:16 +0000 (UTC)
X-FDA: 84106196832.23.BB5C8A9
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07EDD40015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UOWujnGC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053215; a=rsa-sha256;
	cv=none;
	b=ydbBansLhLie2o+H2zyAHYXAF2w/RsAJgxMsgkPUvfxDvqCyuPlicJO2pU0EDtCwc+Rgsn
	Wjt4wKIuNstWZtiaNoweVfE4CySFK0Ud9C6qF7FGpaT4oOBR0cHvccPg6BVDSa57R9YeN4
	ZcfHPvEzEp2oaNVMZU8/4U5+BEp4moA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UOWujnGC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62D/XnEn4jQ4Rczzih2IdSvbf7Cdsd6AxgytI1+Qqy8=;
	b=7kOhzzhkZ9ffi4JTRkO2iPDy/LcKD/ubYRv1UH9Lz2kPGiQ2MT2u1C3QHJbCh07sUendwq
	/V6EjMmUVqqlwkLeFqITqYHN5Hv7MdP/yaYO2QuCZZiXUAsanqe1OG6cEuHp4qN03uALPq
	EJIzdSl3UYztddlpTUrwRS12WK8QQ6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053212;
	bh=PO8gWy+x68NFPFgtgxVVBpssyG+zZ/+aShO0x1+KKAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOWujnGC1MeHlXKTzCZpK8nbSkIaV9fSBqhSUWcPknJcV/0QSTIktlLGD3ogHL4Lh
	 t33HI6UjWttXvmft7wobgaiq/5ioNof59rRlhgD+jiGvMTDtKnHbM3wgp3kKOq9GZ2
	 Uln2ooq3BKdIJEnL3UuHkenOFMaMHp5CVkH8TYEZ4tEhS1asGbyVQNQN4dXXOpeYJx
	 YkQJWQTmvCF3DKSZMW0IW8TJS6+Yv84O7hCfC6zNw5ZNej8H7pjgx5SbwZy8f+pTET
	 BeeFQYEVd21tocLpapqoIrdaQmcMZ8aWJp7Xt7ymfv2i03EFhMcEdTqvMgKlh8hdgL
	 EOpfJDSXl4mtQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 11C1817E0B46;
	Thu, 13 Nov 2025 18:00:12 +0100 (CET)
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
Subject: [PATCH v8 02/11] drm/shmem-helper: Map huge pages in fault handler
Date: Thu, 13 Nov 2025 17:59:58 +0100
Message-ID: <20251113170008.79587-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 07EDD40015
X-Stat-Signature: q3bhwy8b5x1gseoexhqmpfa5nktsnohr
X-Rspam-User: 
X-HE-Tag: 1763053214-388463
X-HE-Meta: U2FsdGVkX1+efC01eFaqXl0pmbCpfzk2DJw4R0Y5tSgkTeBGJl3F5TpgCYGKLl2BzGjgoNvcaK6nc5KmzEdUXUv9W7SDKXxGcll1io+tbYRPOf3fz+/q5SD/EoANrGXjz3vwIubfFDZHCyeUQeRFG5M4VAXOi5k1QwogMt7NIziv4rX/1Gt3AWTOweN/CX0KQrxa4mYKSycicXcwoqrVhF8/YQtiOrpfRSllL8K2eW4zc/ICIwJzEbRdVKDqy3r+LM2b/Spm3TRIU0oasXQ9o2fKdPLq2iUh1cgUQdCIMjKwJqAbC7n8q9Dr14LWhG/4hvHh/nndyNX9fFmiYKqpvN8JUh2pkqKRNT9B7hjgwcK52ddc+iD3b8ufGMz2WJTBkRdMsaeU5bS2Xv3cieHHgwh4XrOpk0rEWQCR97q+HfSByaDwT9OVfjSeuOwb7Ls0hmMraZRctFer0Q70oe57KQwfSECqAwbZ6iNpHSZfUOfxo3EKQk1Bvu2XBEQz9SCDw/GhX7VVkX6bwiiqvv1lqrg41Jpt4hnre5Fml2haOROmQCXtWh5x2RSXqyOyJIH7a4FH6ORnPuNXdZzR4C5edG3ZJZbGPV/3iQbotwKYuOx+CZEgWlYEQKj48GVnsYgGl6W8kmHKFteaoBU8waEjNwH3cfDsykHaOyhxI3s9r5IxyLOmGI2jYi5PJh+u69BcXC2p2RR7xd7CrIB/ct/ngT8MfaoOZKujwB+IJH5LG8xwEaETNGD54/ffJfyJzuLwScphYckl8VGMRNoj0J4eaQkGvGlH0v3E5sEOv1IUb5fAOc2Cj2a5DlJQ4fkS+hQkgJkfTwJGWNpNNHr+HMjAmASfsOXPfduXky+hk2TBfR1tWZ5lt2uUV4MDwViazUHcSNDllWmyEZStutWwG6yJydSEgfJ/iEqt1OgCZIwsvVUj7rt8f3TEDr867hXH2SrPCej9CTY7tlOFLrlvjln
 X5Bptgqv
 cyV//GEMPQu/HHMJkPv2VmPPXxfY9R6zjCX1znqMUR9TBXR56HD1qWCM5yNDZwFwI6FX0Bh31bHFNb4GKR/U7TfHoKT9ma2KUkrzur4RqAKin8R1GFbdAWC9JqFXlSFYuN/wswRhQj+tM4nIjXkPEC6UQ1mfTVs1nf2XdgMmdMy++HxhWUxpQJ2doFuWL/uv5GPAqvChgdFjIiXLkB1WFRqPCy0DbFg0A9GneF7/wEKSKncZBV3bW2XisXIxqQNbKTO4ZsMU5g59qCPummhyVmHymCTWCi2CRxJ1Drt22yKKw73sL/XltG6rMTAHpal1Ab1eVYNPbsogBB95wIPwPycBiTbGkj5H72f0a+Vf+eHkN40jdzw6Ay3R7mNmPKRuTyKilYz1bGlqpXOVi6JKS2NF59T1hYUxlUKJoF5WUBzxHLGOgjl9DPJL09z84gtOXpq2+kbLkW3P1x9XMhwyLPSwZTLWStAgbFFlStYHHXbrRhdxLq8IhmdblPg==
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



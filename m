Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26210D11700
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614976B000E; Tue,  2 Dec 2025 05:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECD66B0010; Tue,  2 Dec 2025 05:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501AC6B0022; Tue,  2 Dec 2025 05:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC786B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD39A8A386
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:29 +0000 (UTC)
X-FDA: 84174129018.25.FD6C8BA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33C9440004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=F8zu7ZoM;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2xrVxHIUxszLmAhkrp3ZbsiVGismeNbFVIaAkX200M=;
	b=JNhe6xpV/XmGHB+0q160TZkwSt56XkYG7S/yw8cQzxd6xPHIY3Oqe2KQAEZZYJ8oJluV8Y
	5GlYV00iPrExeePu8KmhITTAoD+O/oXMoTb3P2lKCPLpaydLGXfRt2oWep4ZUvrelGrbxR
	aQCEm4QFWIOG0p0IW8EcYzTPmQwed+8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=F8zu7ZoM;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670648; a=rsa-sha256;
	cv=none;
	b=NQbRD3up+rItu80wTODvuf91Ntmv6w1QX9RVr7uE+l/AGtp3GC5IP/OX430ExaItWQkiJg
	wWBXxJnsKZwQs8AeHSOmVkE6YrjK78nWI3OaU8qZosp63v6zcIRNIyvPrMjISCEMQDBlrE
	jq9jpHoiiXx4ESq4emhzq8+xK57HA3E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670645;
	bh=N2AsdBqZNtbYogJcBwRYN1psPAl2r+q308j/n/zu/no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8zu7ZoMUaldXwPoM2FCMg/6Lzwz40NNr88YDofPZKSyv2AZnX4QHrzDcCRCSC+Fp
	 /YTMe2dI6WqtI4PhJCx/+GCvQrASYQ65bT7Y/z7g/829OWRtLWXcQX87MAcU3nSpQC
	 75lSWFhiq3cBZotUIrFisMRb+oj34k9jw1FirOKKty/tOa1qM5r9KmMB4UaKS5IZxB
	 KxrYlsvJ2phGwfsJv1eEaw0wZupnG1LKmSVZVcYOpFeSn4Izce8+wWPS0Vab2+Ht3S
	 o1wD7UzV6KFEkBtZKvUIDSSQ5ZE9naEfrkqwA7ICbWP5T7PtR+Yi7H4kg0iBPyOMTy
	 zWSamgvvtNr1A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1988317E1341;
	Tue,  2 Dec 2025 11:17:25 +0100 (CET)
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
Subject: [PATCH v11 02/10] drm/shmem-helper: Map huge pages in fault handler
Date: Tue,  2 Dec 2025 11:17:12 +0100
Message-ID: <20251202101720.3129-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujxgrhsru9xpzyohj3tfa8d37oa83onz
X-Rspam-User: 
X-Rspamd-Queue-Id: 33C9440004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764670647-103716
X-HE-Meta: U2FsdGVkX188XruSaexbCYzfZUvMT8xQT2xl+XaENZo2Kby7e4g6vztp53Z6EIPHEUpfkqB7x8ju+mY+Ute2S2Dvqjr3OUuqJ/tbeUZbW7f7R09NagKunYLLjnTxtd6W6lKTL0z8pkQcWoYI9Vr7fVAD6ZXzn0qcPTuO9hG1aOeF9SU5Hevwxlrrq3Rsjrn5Q25X2yqSjw0+3b3v561+XGiSRAAw3/ypMulNfsdchIqrZwEoFVuIxp72pAunxVu/0B/J7lsYIrJh3HzjsTrmeGwsz/G6Wtu+4DX6cbv2CRos0j/KImm1quHd8UnmFcJqWh9WbdJGuAxddb+n884GXtx9yiL3yfB+ssXMv9VWBoL/xj9YIDlX2kT11SsmHwxhABB6JY64aVR8WcQ4v3wE+myFTwIeNeS6+gZondqTYqGEIBqzEs1URjndmwfc87hTjM775nN6JPZRV+54e6F6zzf9Z5H9ygC+Gi9lfmXfC/sjpbTj31lyx5ewef5Y9lq5uzrDgv5NgMco4hOjzvKIN1/lsCmYuBoLyU0C6NkKYNDh9w4EY1EkxchgHiu2ycTUoAc39Of23I8SFQ9zys53RVwOHAGr8bH6Nx1U1qsNMYu0orc7NNJ7Z8ZcNf4EIVEgZqBNhUga2dCiPn1KrtHpjvKn67rcatlWWuqO7O6Pjn6MvpreoxhKzAIyByGMzmeA9Nm+cA7KotEDHVDzQ6vXKIjWdP3Y849JzUCoWppG2io1KWcBc2rvD0+QXUJB1ywl6tjEMMACrxpruwmsPRXVTbfosotCyqXF0xUttTt3Kg3vbo4ymETO4ogxsB6wJ8p7eG3Mbih19c18JyxEbnxY5r6IY1AHCnH2S9zlQQfazk4AQqTbqjXwoEkIbkUkoRqFc0W9CToNWblbx/BLGkgkxzMHMJKjumBOBWQow5v7FUdy4A+recPY0Q==
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

v11:
- remove page fault validity check helper
- rename drm_gem_shmem_map_pmd() to drm_gem_shmem_try_map_pmd()
- add Boris R-b

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 37 ++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index e47ab3ebb5c2..4e2e58d92b36 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,15 +567,36 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
+static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
+				      struct page *page)
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
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
-	vm_fault_t ret;
-	struct page *page;
+	struct page **pages = shmem->pages;
 	pgoff_t page_offset;
+	unsigned long pfn;
+	vm_fault_t ret;
 
 	/* Offset to faulty address in the VMA. */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
@@ -586,12 +607,18 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
 	    shmem->madv < 0) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		page = shmem->pages[page_offset];
+		goto out;
+	}
 
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
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



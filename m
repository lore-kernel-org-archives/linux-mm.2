Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA4CCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C90B8E0006; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0678E002B; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446E38E0006; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1306E8E002B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4B80C0168
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:12 +0000 (UTC)
X-FDA: 84095133864.07.9B144A4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5D784000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DKfOlcxM;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62D/XnEn4jQ4Rczzih2IdSvbf7Cdsd6AxgytI1+Qqy8=;
	b=t0mS9+2RNXeNtsiVmMKmTw0ZTl2y4N2cwgYtla+fVL0ufcCbVx9VllA30I5z1t/E86Q3uh
	VyLX60Qp/u+/kSrbOW+jPoCQ5oTLGqeJH90nn1+Cn3oeObBGBVKdh/DUCnz2qIwlQWqWQi
	zuX/hFDqKRtQ6qwaREPRB4JFEMGPzqI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DKfOlcxM;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789811; a=rsa-sha256;
	cv=none;
	b=BOql8299q3rU/0tpJZEYwWUjI0CjlEWXnLITP3cYbT6oJWcPaZD3xl1f8aBEsZo8ptPzcN
	Dz59f2AM8SSaEQaZObMPg8KJGq8C9FF79iNAMLUmGSangEllM5EhA9/X4PyCqw748kXjuq
	LFWwC6S1wAS7YQzwAO20JeDGriBcFQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789808;
	bh=PO8gWy+x68NFPFgtgxVVBpssyG+zZ/+aShO0x1+KKAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKfOlcxMWEkNkbszZViZqzNqW02NKbbCVS91sl/7LYql1gJ5K66noxG3FS7/cObzK
	 Fw6U2I/rO8svfOAh5jIWq1+tOj7aHV2LNFkVT/xctiyj57z+HSH/A7pJmDXq+1NqK7
	 nPWOzFqAoOfyJChF1Gkvv1um0v3fy5Ehq6dvfl9Fj3MgBBo54Hom/076awalq2uftZ
	 yl9mKgNGLNEUzu48tJqGUTt2GKDrEOSERJcpBNL/WSEozl4x+uq81uHiFOiz37AODI
	 qvFGJzziTZuWq9KgVs0FzJ5q1rFYYZ304RWU6ycv8pwaPH3yR55S380rt9ABfVwfwl
	 HhPXnYX4+lw8g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 16A7217E1299;
	Mon, 10 Nov 2025 16:50:08 +0100 (CET)
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
Subject: [PATCH v7 02/11] drm/shmem-helper: Map huge pages in fault handler
Date: Mon, 10 Nov 2025 16:49:50 +0100
Message-ID: <20251110155000.2936-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5D784000E
X-Stat-Signature: op9kneyh58efxnox8yciipyq4f71g1se
X-Rspam-User: 
X-HE-Tag: 1762789810-870315
X-HE-Meta: U2FsdGVkX18oIaw59vDZFtDN3DviG4+6YLwqERNl/qeLK7Pg+kwslM2wHzWfrOslCViV36zdXonPgCYvL+nlOxVPEBYSDILZj/imv0BZ7fzZFMgaikUvLETMdWUzCVAXfG0A2Ir2WOAApcVpyZFE4eiv4bvsejxN63W76ACJZFtD19y8A5dk+5HmAqKIXB9NuyjNorBdckVigp66m0I20Ng+M0LsnZgxUmP5qxjILUp9fe4Eyj9X1GqHnAgoHrcTn7iIDKRj2lKY6apsa74IbhpHmjzQK6tPpQ9+WM58PMdtJuDJXTKfl37xzbFm6A9yybwwRPuLFjIVyRKyTeKDlpZprfC5fZVLad6WgSs5Tx/6XLJe8LDx5hj2LWayybbtoytAs9+CoyedI+1oTU3MznIKBK0H0xIyEzIj3wW6V7BIMNAmtKnQaqCGTfOHSF6BAxW47JzdexwcLEruuE6ymqttjVyksagCSPkLwX4XL3DqylLlwyFA5wkqjCuHrAf1w/j10yIlFW0HPedwErIrBg5tznjo9xGStU3uv0PYHJYnFsJHqscP/e/SJ6z5O3Hm4sDbbUc3WkUTxjYu5iWFzDq5JXMx8aU8TMAxglMO/WhDmM+Vo+J9eqX9K5PbMcVdxoavZ7/NI6wdxmeNNDUSNVMlcqlQ5PD0pEtH7DTvs9S81MwmILEEOp1TTZH7WIdrLpUOkWQGAxxgCiwPZGzr5rNZEiOmJwFeUDLm9jz2+8gLBNRKYvi4gP+8nSoZNQNvgsMsyuAWfKXwVhmLULeE6TYzYLiUD4kLO8JiMlIQVQVnSN/kGZBQn8TfLjAz2aZI7BN1OnTW+08XjYGDCBPVz9jfHG9haVYvnRMhIV6Pj/0TVkGx545FuCQVqyH/NKjj8ZnvvqMLT07qAxG0U25WTfS0brra90vcZ9ssQQa9p85lKOhLpNnB7skeLVg5ixq40JUF8JAetffm8xsMtnz
 mUOGkRSr
 e3tVEVFNz12iVQE4fCqxog7fvYPjiQOg9Ice+j6jmgSAz4iywVIVEn/PEjq690Lx8tLSTOmKdWzaZ1j25+esMKSlGy3oSiMHOuO2U6M4HP4BrWtXA2KeyVgn5jlcqtfNzF3x+alukXUzf7+LzSX+cQ1M9Mc2TbdxgpRGOsUBRNyQhw2hnBO+O4aayKlySAIoySBCxSlqpaty5ZZv4/+TYDsu4ByNONSajrOD2DJ+TelMKV5vWBFLx1garEFP+vlRnr7Jq1v/luemleipa9WFyRyA0p26QrG4Jbed+uAs2hWAyO0rlQiDuA6CZnKMGzLgi0PvVPyGA+vkz2SmpH7Ff+dmc3vgFSFZw4bzCr3FHYBSEqI/ZPgyJ1Lp3tymRjl5GjhXWVfNGQjK7yRMccn2qb5cbB4nGY6lxIYgkiRSiz2DKAFFm9Vj4HF+UxSzmINLxBuWiShdPLJuPuY94DBrCFvaUCT6akWPzlwbFRAym8D2hVCPBhvEOJtMOcA==
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



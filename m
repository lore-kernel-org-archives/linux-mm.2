Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08039CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4F08E0002; Tue, 21 Oct 2025 07:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0D38E001D; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91F58E001A; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB038E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32CFBC0474
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:01 +0000 (UTC)
X-FDA: 84021904722.04.42002BE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 571C01C0012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jkEGlLvJ;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046259; a=rsa-sha256;
	cv=none;
	b=EecTMemb3SWy0tp8Aj2yvf5Fp58/a62bQrZ2NZQjepOAcKQoZy2/LrXM5eTn1QCivOtgBN
	jD1NFdx+oV/GsZhgyp/XxiYwfDe4iPP4qIYoW7Y0IJGSkxY1TnMVh1dS8jYsfvCzJq195M
	qVQiYa1trLoJWZxxvtaBYdVj+IqfrZM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jkEGlLvJ;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffTaTKqX/UqmajNLktsd3k0ak+BB8xjmRA/GNNyF0hE=;
	b=WlLz3E2wlyvTJNhfwVBmytHLpCDa2ywSsQ63bBE1GLt7ZSir3XESDFyh/rgwQzwhNA5Muw
	fHjmhgun+E3juOtD+MuuNmQMjtUf801EfBcoqfLgsfTHm6Wia03lpK1EO5fWBACBwzff6J
	DKcrA1zoAOjWbrrT53jLuMFZZov3Tno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046257;
	bh=KOWDNuw2RyynKmJ4ZsE60XfwYk9U21BJtK/dnqbhV5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkEGlLvJpL5ipkJhIbJS1NwsbTwZgBAiguvdFmT0Nrqj06FOVmUzTIWBEcuNmQBk8
	 GEDWAi9ffa5cUQhGgT5n7+VowfmdGSL99UAfy4SCACh7QyOhfvA+q+Sx4VNM6vah1p
	 TZyULGL0sK0Gf8OSBJDt1Z6OSbOo1x5ck3NP+Go821cvK0Cp22bfiYQ1T9QI65iGXT
	 KT90nErM0JkINFpGUfL1KglP4AaAgr1ukN37aLDcsHac/I3VzPt9Bx+cLChW1OjxSa
	 rZRTmqatrZkOTx02CzNmrOSNrtB0O7nhwSis/C/pHb6G6jeTfn993Bl0m+kSqjot2q
	 z5hExxJfWZ56g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BB76A17E1404;
	Tue, 21 Oct 2025 13:30:56 +0200 (CEST)
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
Subject: [PATCH v5 02/12] drm/shmem-helper: Implement map_pages fault-around handler
Date: Tue, 21 Oct 2025 13:30:39 +0200
Message-ID: <20251021113049.17242-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k7stjrniqhwq4ge5sgqyrwa1ieenuxbh
X-Rspamd-Queue-Id: 571C01C0012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761046259-767269
X-HE-Meta: U2FsdGVkX1+lU9NgNHkJsBj7H5yybXxuq+wypP8QCZVmTJCgbX16zYBQ+TQmDx/aaIBQhXioYpxS3HKLVPRYQKgaw4RUSIX0cWtea/GDtYc6zJI/tCCntl2s0ODZmLcdnz4CbromGs9CHCAdC4RbQ/cdVOoMZRXkXervkezEE7875pMYcOx8rn6Ywe/Ui36b1ro8FgmIRVuBp2AY/tY69O8VkAGmbWcYnaJABTwlHy2zZAiVewsUxdjpudaiFWoQCXIY3+SjjaeR5e3uI6woDiHfFgQ41d1f8wsz/2RCjNU4pInAlLExM26jg93rVTUHyRadJ68ow7DwHPcPClUGV8MObQE6VE1a44Mwrbar51G3bBLmpnT2jQVlYugbSw5sZ/Idri8B+rRBVbZJRbJFuS+D3pqYG+dHS4A7o9NVdJsqovVtW5nlc90PiXs4YdjKDYVuUp02tEKCa8z6ZnqJYdnL3PWiREf5sDuVvJbBQvkAgqPVbZKUEI/u4V75eKzPIFo5oVqshfV0N6bmsPBWKp8Ic7X2HQNAymWcGx06JhqEvIvS1ls6z5nZfPyu0I1Ere2/4/tk7VluulC9n3fjGj6jRc1VEwxeFuGuNk2jNO6y7uZXe587kAmrJD131hgNnakEKJpUc3pbGoAndxSKIBDZJQCWbaUQ/yj8WmwMQ/SUPay5LP3mLW/562hfMoMQ5nX3+q+brpqmJ5p/+fLnUXiuD2jNARCyrlaGpklHtkEjo/WAKdPWCLNO/W54U81KB3M/rFc6Wv6PEPdDK9CemK/W7DiH6bdN/FiJ/s5GapxsBJF3xjLtM/isWQIvdWp9lTq7uNCSoGJNyqXRPhJ0p75rHCPdD4R58RDQwyWjOWmqQHIUIn7B+u0c5BIlcAFeEeBvlKfRivwVFPnS4z/ODf6JuhXSSI9a5luQP3ghb+bBPzELeVEyrtFjRT9K3kOvmfvaRl6QfU4pEjL4XI3
 klpFu5MY
 TYuDn2ifL7v+aXoTI+RYJAD3jwkVvX/DWTgpQRO+9JwkXlHOR4MUoNDdvDHS9evAPRCkxajUezPZyqZ8vaH2UP2AVhj64CODkB8KF9FSm2IgU09vCr7kxRMKaGDg2Tcq1Ae13HVfvyNRVzfsVZu7L7vPHIlZrHT77d3PeZI8QcgV/MaZpfS5yIos9x7OtSLjRMSwRi/H4C3GOqEQpkQddyzgQe63jQnQAWHepfc/rE5VMhV1/7hIsRBsEOQH/4U9B7LCEuy6AeH+4kXGwT+t/mfFzUeKOjtVDxY/QN+AS92CXBGKx96XVZf/kpeBzDCgU+4bq3PmqPog3JzNyRGd/gEEn676tV03e4lmZeGCQJVwC63XxPP0rCJ45NRDxlnKuyv1A7mbeSpG9IRb656XSujwPQ/gbcdgBl4WTnAmPDveOerMiZ9ngtKfAmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This gives the mm subsystem the ability to increase fault handling
performance by proposing the insertion of a range of pages around the
faulty address in a single batch.

v4:
- implement map_pages instead of huge_fault

v5:
- improve patch series progression
- use dma_resv_trylock() in map_pages (many thanks to Matthew Wilcox)
- validate map_pages range based on end_pgoff instead of start_pgoff

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 72 ++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index be89be1c804c..2a9fbc9c3712 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,31 +567,82 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
-static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
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
+static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
+					  pgoff_t start_pgoff,
+					  pgoff_t end_pgoff)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	loff_t num_pages = obj->size >> PAGE_SHIFT;
+	struct page **pages = shmem->pages;
+	unsigned long addr, pfn;
 	vm_fault_t ret;
-	struct page *page;
+
+	start_pgoff -= vma->vm_pgoff;
+	end_pgoff -= vma->vm_pgoff;
+	addr = vma->vm_start + (start_pgoff << PAGE_SHIFT);
+
+	/* map_pages is called with the RCU lock for reading (sleep isn't
+	 * allowed) so just fall through to the more heavy-weight fault path.
+	 */
+	if (unlikely(!dma_resv_trylock(shmem->base.resv)))
+		return 0;
+
+	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, end_pgoff))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	/* Map a range of pages around the faulty address. */
+	do {
+		pfn = page_to_pfn(pages[start_pgoff]);
+		ret = vmf_insert_pfn(vma, addr, pfn);
+		addr += PAGE_SIZE;
+	} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);
+
+ out:
+	dma_resv_unlock(shmem->base.resv);
+
+	return ret;
+}
+
+static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
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
-
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+		goto out;
 	}
 
+	pfn = page_to_pfn(pages[page_offset]);
+	ret = vmf_insert_pfn(vma, vmf->address, pfn);
+
+ out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
@@ -632,6 +683,7 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 }
 
 const struct vm_operations_struct drm_gem_shmem_vm_ops = {
+	.map_pages = drm_gem_shmem_map_pages,
 	.fault = drm_gem_shmem_fault,
 	.open = drm_gem_shmem_vm_open,
 	.close = drm_gem_shmem_vm_close,
-- 
2.47.3



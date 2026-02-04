Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50C6E9538C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E836B0096; Wed,  4 Feb 2026 06:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6586B0098; Wed,  4 Feb 2026 06:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1C06B0099; Wed,  4 Feb 2026 06:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1B66B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:44:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C78E085D52
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:44:02 +0000 (UTC)
X-FDA: 84406590324.27.42425E1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 988B4100009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:44:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SONFhUkI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqtP6VUt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SONFhUkI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqtP6VUt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+A5QWqoW6d1rO2c2JIsl4NsgDOsKOprgGQq2z6U+QEs=;
	b=MYKUkO+fHG7LdxXE+X+LT9jjNFNbkjmXaGPrV14ZTQm6cUIjwPhxbsCiqkny6pi97qNYvV
	+J9OVnxZSijB0UpziZOm8snEz3cwSP1NUkVz/NlyedCQqXXMyjD4bQGvev77WFt5q7jXp1
	XjKAs/gLxz8MJE1Wm4m/Lb50NCvL3jE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205440; a=rsa-sha256;
	cv=none;
	b=BVGxhvfZVnb/3BlUFpWqKollbfcUU6cJfxgoJWjLPx/rPMa3EhB10xue457MFhJDEUPuYM
	kYtaBthLBeWDLHOY5rwQoI9NgRTgQgnrtsV7wwUN3ug8KjczLo9CTQBS6Qabfk+xF4NSH3
	K7+12akUM27m7AFNJBG/6sLmBflxwUU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SONFhUkI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqtP6VUt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SONFhUkI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqtP6VUt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DBCA3E70B;
	Wed,  4 Feb 2026 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5QWqoW6d1rO2c2JIsl4NsgDOsKOprgGQq2z6U+QEs=;
	b=SONFhUkIJgt02zWFvIjmMfbCsPqjzHb18sIyG7XJ9FeUkx7qjgz1Cqr2SmrUxWp5bcHAVR
	YV4XTCGOCFoYD1csAETUFI++dxXnLYOHlmSHAo9MqbuLmA5ghwmFDJ6CNuKbXnoX9z0iVp
	6kyHW6TULp5x59v4/4Gcw912e4dJmzE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5QWqoW6d1rO2c2JIsl4NsgDOsKOprgGQq2z6U+QEs=;
	b=QqtP6VUtsKILY3OoCyz3kw1pU69XU4JRSTPxX1HFiIbNGnbqeVqMfBT2bzrQsMx4CYZDMv
	S+BY1dt8FM4Pe/DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5QWqoW6d1rO2c2JIsl4NsgDOsKOprgGQq2z6U+QEs=;
	b=SONFhUkIJgt02zWFvIjmMfbCsPqjzHb18sIyG7XJ9FeUkx7qjgz1Cqr2SmrUxWp5bcHAVR
	YV4XTCGOCFoYD1csAETUFI++dxXnLYOHlmSHAo9MqbuLmA5ghwmFDJ6CNuKbXnoX9z0iVp
	6kyHW6TULp5x59v4/4Gcw912e4dJmzE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5QWqoW6d1rO2c2JIsl4NsgDOsKOprgGQq2z6U+QEs=;
	b=QqtP6VUtsKILY3OoCyz3kw1pU69XU4JRSTPxX1HFiIbNGnbqeVqMfBT2bzrQsMx4CYZDMv
	S+BY1dt8FM4Pe/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D0DF3EA63;
	Wed,  4 Feb 2026 11:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gAt2DfMwg2ldawAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 04 Feb 2026 11:43:47 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch
Cc: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 2/4] drm/gem-shmem: Map pages in mmap fault handler
Date: Wed,  4 Feb 2026 12:39:30 +0100
Message-ID: <20260204114341.195143-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204114341.195143-1-tzimmermann@suse.de>
References: <20260204114341.195143-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 988B4100009
X-Stat-Signature: 5nr4ksuczbxqyreywr7fnmrsdtj134to
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770205440-791118
X-HE-Meta: U2FsdGVkX19clNxIvQ85s2EwVDJKv5lXFXnfAo1iKTwNyAPTVGh4V1wWRk5IP9EpfbVAs4acy4XcugV5j+xDR20H8ZPHHvCjZquMd+rDmoIc337vtcMFy6/3Ua1lk84UU34GmJz2VEWeyOl4P1PxTLvmTTnGQzy2GyP93Ogo8p/gylJKRqGoKptfZCgWoM/MJm6l2dNewtm3tDBSbtaQsKC2W82EhiHskC/r96sGe9xlIOoJBqmgo9aHMhoM9YHVRbqccsvK+a3LF5gPr1iuXWFtwmT/xJ5AbK+qVAshRCa9SZJ3gHmWHcY83FlLrNcfQ1tT+FVWDEmTa6TKpdIHzww+rX7du4vbv0UltsgRGsu4vUEJirw4DUqG/uSONajsO4dITgtiqTLZf+CRH7EV+YcuM+qKK4EZOGGHumZ36NSAAtZGGpJYc34nzz/jZvwhyNumxOQF5ZcdTGBH0eypWr7qZ+EZi2qsUlCNfHwOVUnO033lkGiU2xSLYf1eenyhamC310wz76W9loxHA0R/MUCp95C3WxcxaxSylAvmrzGtkXQ33VceSER/xeAPGz4M5YVNhwMhjaByrcn1GTdNBkhEnXks52hAdfWNyMG1aqSxZRSUS1sE4I2VqvCj+asUbcyjw/x5bxvL6PUbE2Ta7l/nZ/JMisvJn/gPW+dbHtOIcPVy7q33Co9lXYbP0nTdkn9J7hjz3wiX5R+tQuWZ+P9ZtCQB/0kxBRDtWVE+NwajijmrU1XOjCFxOBhJTfRssR/EH5AH4L2K3VGt9kPoKsetTRZuNL0mL4iV+Oqou9/kL7AN4UZn6tx6FFWt69LeMWPNjyswn9BP6eUyQWARpQahNJ0zxYeTM6NW0N+8+/u1rr05scU4RsBJ8EnbapFVSGoV2ppet/ssaCxAuT3omjc7zCObOsItiPxLyYm8+PAEVt2zh3Bh87V+8WxodPld3QaYIyNrBco3mwWx4wH
 2a9HkTcD
 APyylJ2Vj0wDHzXiJwJ8m3TsbDSelJdpkVDqWWwXMbOse6ISinR/VAuGjLSSWiakryQNBhk0ICzXczF6yhUJ98t+A8x3CCQw1bLztKMiqXDUP6xAlfVULsIFoDcOVuRwCKAes+GxfKM/hzZEhHuLvBm046uh+LA3Bs1k8iOwURlDbNCkZgz6NK4gHZ3NR9+NBcvozmg0/hVD/AtWHkZHkO4OIsLt43L1aX+beOPaleuSuDYDbkQ5vOhUjhd10rCINNT91+eB7+nRClxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gem-shmem operates on pages instead of I/O memory ranges, so use them
for mmap. This will allow for tracking page dirty/accessed flags. If
hugepage support is available, insert the page's folio if possible.
Otherwise fall back to mapping individual pages.

As the PFN is no longer required for hugepage mappings, simplify the
related code and make it depend on CONFIG_TRANSPARENT_HUGEPAGE. Prepare
for tracking folio status.

v2:
- do not look up the page before testing page-array bounds (Matthew)
- simplify error handling in drm_gem_shmem_fault() (Boris)
- adapt to changes in drm_gem_shmem_try_mmap_pmd()

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 49 +++++++++++++++-----------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index e7316dc7e921..24553dec070d 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -553,16 +553,17 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 static vm_fault_t drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
 					    struct page *page)
 {
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long paddr = pfn << PAGE_SHIFT;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	phys_addr_t paddr = page_to_phys(page);
 	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
-	if (aligned &&
-	    pmd_none(*vmf->pmd) &&
-	    folio_test_pmd_mappable(page_folio(page))) {
-		pfn &= PMD_MASK >> PAGE_SHIFT;
-		return vmf_insert_pfn_pmd(vmf, pfn, false);
+	if (aligned && pmd_none(*vmf->pmd)) {
+		struct folio *folio = page_folio(page);
+
+		if (folio_test_pmd_mappable(folio)) {
+			/* Read-only mapping; split upon write fault */
+			return vmf_insert_folio_pmd(vmf, folio, false);
+		}
 	}
 #endif
 
@@ -575,13 +576,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
-	vm_fault_t ret;
 	struct page **pages = shmem->pages;
-	pgoff_t page_offset;
-	unsigned long pfn;
-
-	/* Offset to faulty address in the VMA. */
-	page_offset = vmf->pgoff - vma->vm_pgoff;
+	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
+	struct page *page;
+	vm_fault_t ret;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
@@ -592,14 +590,25 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 		goto out;
 	}
 
-	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset]);
-	if (ret == VM_FAULT_NOPAGE)
+	page = pages[page_offset];
+	if (!page) {
+		ret = VM_FAULT_SIGBUS;
 		goto out;
+	}
+
+	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
+	if (ret != VM_FAULT_NOPAGE) {
+		struct folio *folio = page_folio(page);
+
+		get_page(page);
 
-	pfn = page_to_pfn(pages[page_offset]);
-	ret = vmf_insert_pfn(vma, vmf->address, pfn);
+		folio_lock(folio);
+
+		vmf->page = page;
+		ret = VM_FAULT_LOCKED;
+	}
 
- out:
+out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
@@ -689,7 +698,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	if (ret)
 		return ret;
 
-	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	if (shmem->map_wc)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-- 
2.52.0



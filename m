Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6800DD2F02E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D7A6B0089; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCFDC6B0092; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB0D6B008A; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930C86B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A500C01BB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:51 +0000 (UTC)
X-FDA: 84377826582.11.783330A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C6A2C000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9Hx/FVh8I6trX6j+yL7L1RWu15pTDNT9Q80ih01PBQ=;
	b=BxJmzRykplKM7Buc/Tk+77SWgP6jI2B+5NCr8tUHWtVk+a/VVlK5BjEB6vyWG8/nwxrimn
	1/kso5g0pbMQsfo8L2fo258fyjZL7azSvSNKmSZGFNaFIIhgTJHmc8wAxNfzm6KvXoo4Yp
	keUaINKYOgVrSNhfL9ufl1GebKDiaRE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520589; a=rsa-sha256;
	cv=none;
	b=sBN5L98/u+4UgGJKOFYT77VVuSCj0Koc4EDm9vAexnnHUEhKF57MSpQ81XlND9OTPgkphx
	Tf23gh+vlOCcfTnlQIFD6sX7qniOlplItSqZ4MKBzxY9PInemzlkwC2gB7DolAPYIYNLq9
	eu18QMGQiu87Tly5emphQatxKIS2LHw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E50A533723;
	Tue, 27 Jan 2026 13:29:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48CD03EA61;
	Tue, 27 Jan 2026 13:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yEqWEMu9eGmeDAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 27 Jan 2026 13:29:47 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com
Cc: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 1/3] drm/gem-shmem: Map pages in mmap fault handler
Date: Tue, 27 Jan 2026 14:16:36 +0100
Message-ID: <20260127132938.429288-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260127132938.429288-1-tzimmermann@suse.de>
References: <20260127132938.429288-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: yxujzgiu4afcdo6hhpbf54cyfpx6o7ek
X-Rspamd-Queue-Id: 2C6A2C000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769520588-361686
X-HE-Meta: U2FsdGVkX182/eRwZXYOllInyVMMcO4p188KIIkvOyq6iwqs3LL5QxWsqQiRXhiIKLYWcDpldbuWKbNTnOnZt2eKLHUJkTaLgwvcSdMuDtVP1GE7hR19REYgs2lwT/LFdVBTVZ55f0Ct9rLUMEjKdCGXWCKuf0U3auQw7aPNofeU/u+nJKkRKEFj3THGDrPRWoB+ItmFDUk992NvceEjMm6EoIU5yboEDrjUtufwHjBql7w0Cv4n7IexlvkPrwJlWUgPSxsJMbI44PoAbPf6tjFwh42nOsLVaiDL0C9KmJZg9rrt+wDX3MbAiUdbw5z2cNwwh23jpLZu4kJarEBe9KtqKC8L2TOFn2pIMS8OB9BqZ4PtuhD63FLJUGfPGQVCD04t+aD6k1XcVD9EXo1RyA74fqCp/CGJ92GadluIhmclJGi/HrGXh76hc4iTD59FByyNYkpzbxYE5U2FPl7qdM9ulkNbf7UxDU2gzYxd9YjaGtFa4jmoOghHRuWfvJRKrjuMGvuzvEXPeIN+MCRWqGLANtmqX5sJVDktyrrHc/Q+qq/sZkcXgSMisqZS3rogJdSPnE8cTRtPWzSFUH9U1/Wy9Co433BC/QQOFW5mut0ZcSLTnmBU905O3JnetfImnJT8aVyzt+h+mD+QilXtSmKN23+aPXE9mwx0aJkduhba3AbqkW0lUn+R2GNbbEa+h1D8+9qIGcoN0qkCb9qyFVHGeNKFAhTEvIwsRQWpoq+zCIZG4UljUalODjTH4wDzbOAZVBPHYYpwmTTXOGPBAP4+0UbUGznxVhAl8pDLB+/LOLgOECYoXBBVPUe0vPO7hwXkC9nwfmCYi0yyYTcl8z3Ic3SKcrQziHRmr8ugJ0b+VI6NW1PDFhDaUtnvbvlfdbW/L3w3PayDIFpscrk7i0nubkzKM40mtUouULG7RsX/R9aNCBkgHGdbUFcJXcqFEJ7of7CbnUaP+f9Q5dm
 zB7Ve37U
 f5iogXSAKFkJQxIw+lKLy92kvLpPJXYnNPxC2yBEoSkzCB/XDhkOhrzWeoNwli95uoDgkwh+VBZzK0KkBQMDSldVgwlaZg8CD5sHrXgwPIpoVYyTzQtdS6vLKig==
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

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 58 ++++++++++++++++----------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3871a6d92f77..b6ddabbfcc52 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -553,17 +553,18 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
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
-		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
-			return true;
+	if (aligned && pmd_none(*vmf->pmd)) {
+		struct folio *folio = page_folio(page);
+
+		if (folio_test_pmd_mappable(folio)) {
+			/* Read-only mapping; split upon write fault */
+			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
+				return true;
+		}
 	}
 #endif
 
@@ -576,13 +577,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
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
+	struct page *page = pages[page_offset];
+	vm_fault_t ret;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
@@ -590,21 +588,35 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
 	    shmem->madv < 0) {
 		ret = VM_FAULT_SIGBUS;
-		goto out;
+		goto err_dma_resv_unlock;
 	}
 
-	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
-		ret = VM_FAULT_NOPAGE;
-		goto out;
+	page = pages[page_offset];
+	if (!page) {
+		ret = VM_FAULT_SIGBUS;
+		goto err_dma_resv_unlock;
 	}
 
-	pfn = page_to_pfn(pages[page_offset]);
-	ret = vmf_insert_pfn(vma, vmf->address, pfn);
+	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
+		ret = VM_FAULT_NOPAGE;
+	} else {
+		struct folio *folio = page_folio(page);
+
+		get_page(page);
+
+		folio_lock(folio);
+
+		vmf->page = page;
+		ret = VM_FAULT_LOCKED;
+	}
 
- out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
+
+err_dma_resv_unlock:
+	dma_resv_unlock(shmem->base.resv);
+	return ret;
 }
 
 static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
@@ -691,7 +703,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	if (ret)
 		return ret;
 
-	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	if (shmem->map_wc)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-- 
2.52.0



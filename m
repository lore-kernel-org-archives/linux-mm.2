Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D070E81BC3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FC06B0093; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5746B0095; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82C56B0096; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2C56B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 568C4560D4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:33:02 +0000 (UTC)
X-FDA: 84425009004.19.9D293AC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3539E1C0011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2HH3g3ULHCrpziRWZrUia8tzY/mbP/A2MBImdr/Sy8=;
	b=GPNmVGoq+dT21As833dxg2Ktuz+t/D1Iw6CdNmNdnkNuTmCr3yzwFASMdNKxE8aqeS1ryp
	uTVzgkj+rkerc1/uUhdq4UYIsGyW0bYJyoek2DZpRpDIEmrRdy0LDu/+nsNqkBx4WEu0Cz
	h6JwwOZ57h/l5Bh5NF1KoQL0r3dm0LE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643980; a=rsa-sha256;
	cv=none;
	b=ZVwrJIwqz2d6jGlLOF48sY2Zyp/scbH9InRNLDgyUgkgI1Y/KFQIYRuqP2GQF6mlGkpy+B
	3tzZsLHpuQGDtd1jKMkADjowg2mhyVvNOjhTCE5swgKPAPklw5USCYLCSh9ArEKTA8RPCj
	RRuFst9QOxHl2q6G6sB3iiKiO5bpaoE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 799EB3E70F;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21E923EA63;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iAfYBv/hiWmTIgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 13:32:47 +0000
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
Subject: [PATCH v3 4/6] drm/gem-shmem: Refactor drm_gem_shmem_try_map_pmd()
Date: Mon,  9 Feb 2026 14:27:13 +0100
Message-ID: <20260209133241.238813-5-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209133241.238813-1-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3539E1C0011
X-Stat-Signature: 6hqm356m7c8zhuoufmxd5h1dyx3njgib
X-Rspam-User: 
X-HE-Tag: 1770643979-249753
X-HE-Meta: U2FsdGVkX1+SsKqxaBvco3efV4Vg0bTiKcHo782TG5hgeo1HiSPSnvUJjc5GCKo7TdZiKSqIomxIqo58N306sm48x91JfAnhRqBKLSpda2Htf7a9z9xyvTrl5GyrwbTAPvEINoQDEwYdvZ8agYr7JR4v63J3q800nMgf7gEziUTcpzX/8GurCn2sKiF/90WSYOWfd7PU5S/VvBmk+cALj5aYexrT87SZZdFV30RttX3pymohiPZutc9iUonL7TnOKrdOXD8bV01VpyaWpsizm0e4PnZ96x5/LlghNzTf0DgAwT+rh+hsA01M84ITCyAhwkqUmoBvf0ZcwO3UQrUceuHQuozomUFKeS23EZcTGVuizBcybImR6VUbCTomALxbWDYF+2mzFURIaCf0gud9CkjMdfg/bG7/BvJlYYvx8dJe5j40YFnQLEs5eW42zbCrrXGCyalasZjI9Us31Ag6cglDuTtPHUUwtOmpoH6BCk9JuJUilJZ4u9miBtTZrHKj7gwvT+al0Y6EBOZNlcPzFCjXdVCRbeSGovKjfxVNO4f+dktQxBaH7SZRtGULIkEWRbIQwz6ZnUsbMJiChqwd6gpTzotc+0jZto97HJVKSknlOW1AX1bG7134HpMT4HPTywFPwgomvgI+7yrh4CTbL8tXVLMzfqZddw5L25WjYEZO7RqRjeMzUVXWb6vvgHHxTLaee/SYFJlKf+zR1UNv/puK2DN11CeBNmU31/Fgw6N5nz3GzdM/OsyF4tL4+yXzOHoumKf89K/5sU/JhXdjYRCjxynesQ3htrzK4iP2Gk/Vb6du2qnFG6I3JKvI6i9o+tZQ9ACwgl+JY40WDt9YpPpt1PeZW3O9o7HGzkKxrTE/gzH12tBqSK3bagjd2EOrjmnKFZ+hYEiaOhtjNN6QcGoxy/M32tENh56FQhs89WxPj1/JXe9hkQUlbBQLPDoePVMucXqcDEaG8WNlwhZ
 sbrKNHvk
 NKs9LO8aTltQvZ6BOjOtZYoDBvrWxl02n8is0gyoxQm7q4oSUACjbjbK8Fka4+OeSpM+2sWsvNqqTlzZHzEHKDoglTktBESivUlzHFJgjtuydgy5jEsd3fkPGdc1ob2asKxbR3v4QgbLMh5uhtfAVfkYvGbOtl7WLG0w1gZplgDKTuI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current mmap page-fault handler requires some changes before it
can track folio access.

Call to folio_test_pmd_mappable() into the mmap page-fault handler
before calling drm_gem_shmem_try_map_pmd(). The folio will become
useful for tracking the access status.

Also rename drm_gem_shmem_try_map_pmd() to _try_insert_pfn_pmd()
and only pass the page fault and page-frame number. The new name and
parameters make it similar to vmf_insert_pfn_pmd().

No functional changes. If PMD mapping fails or is not supported,
insert a regular PFN as before.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index ab8e331005f9..c3a054899ba3 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -550,17 +550,14 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
-static vm_fault_t drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
-					    struct page *page)
+static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn)
 {
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	unsigned long pfn = page_to_pfn(page);
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
+	bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
-	if (aligned &&
-	    pmd_none(*vmf->pmd) &&
-	    folio_test_pmd_mappable(page_folio(page))) {
+	if (aligned && pmd_none(*vmf->pmd)) {
+		/* Read-only mapping; split upon write fault */
 		pfn &= PMD_MASK >> PAGE_SHIFT;
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
 	}
@@ -580,6 +577,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct page **pages = shmem->pages;
 	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
 	struct page *page;
+	struct folio *folio;
 	unsigned long pfn;
 
 	dma_resv_lock(obj->resv, NULL);
@@ -591,15 +589,16 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	page = pages[page_offset];
 	if (drm_WARN_ON_ONCE(dev, !page))
 		goto out;
-
-	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
-	if (ret == VM_FAULT_NOPAGE)
-		goto out;
+	folio = page_folio(page);
 
 	pfn = page_to_pfn(page);
-	ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
- out:
+	if (folio_test_pmd_mappable(folio))
+		ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
+	if (ret != VM_FAULT_NOPAGE)
+		ret = vmf_insert_pfn(vma, vmf->address, pfn);
+
+out:
 	dma_resv_unlock(obj->resv);
 
 	return ret;
-- 
2.52.0



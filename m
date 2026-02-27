Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732ADFD7F9B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38826B0092; Fri, 27 Feb 2026 06:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE29D6B0093; Fri, 27 Feb 2026 06:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA996B0095; Fri, 27 Feb 2026 06:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A64A16B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 733811B7ADB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:39 +0000 (UTC)
X-FDA: 84490056798.26.A7B778A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52C44120007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hZXnwfzy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EJ7dP0gw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hZXnwfzy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EJ7dP0gw;
	spf=pass (imf29.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ACflo2IcJSP2BuaivXQRPYHeSVXUbTLuFXLbW+gqGM=;
	b=zUcCoj0G0oNvzPi/a1TOc7uGL5q3/Ns3UyLQXJR88sHf6vY88n3Y4g2I2QbDpfIOUH1LCb
	8vf8dpdMY1+8F9at26OYbMXLkcaoI1TaAlbHlxMuq327mmEpjmvbB46/1Kwl9fyVMvx2/e
	2Tb9aHB5QLBL1LnscZ7p3UR0gFg50J0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hZXnwfzy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EJ7dP0gw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hZXnwfzy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EJ7dP0gw;
	spf=pass (imf29.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192737; a=rsa-sha256;
	cv=none;
	b=sCs2tbm/ROP9F2vZu013ZwGWWamt31ezofuD3kQNdwuRYWyzotqHgYGw7o3mKHoce3fGfY
	UQIjFzlTHUet167oBsJnwclzArNpBdOXUgtjLrtjEZ87SEAuEGwynIKvvXts0gO9ywpc3j
	nGa7fxhT5GXBqO8XdZ+hSdPGbTlNKso=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2190B5C24A;
	Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ACflo2IcJSP2BuaivXQRPYHeSVXUbTLuFXLbW+gqGM=;
	b=hZXnwfzyU86BJQotVljF+tGFSIg2cVyW9LXEvBzBGVHZFzHTiqhUnyCBGA7gXBV8mDY8ni
	yUE4HTI5yfv51EWLyXGPIhUiBNJN1XD3BrqGipW9k6WRhUuA8mafODxduCglcUTaeA+pwE
	+Dj/g9PzOjQCXNW2yoBcml4ebMUW8RQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ACflo2IcJSP2BuaivXQRPYHeSVXUbTLuFXLbW+gqGM=;
	b=EJ7dP0gwlUoxPNwgSYx6H1kBkeXHdLE534xQvltBvQOROTAel0PAhM0gm4WyhFpvwD/ygj
	zyjDDgRykxuV34Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ACflo2IcJSP2BuaivXQRPYHeSVXUbTLuFXLbW+gqGM=;
	b=hZXnwfzyU86BJQotVljF+tGFSIg2cVyW9LXEvBzBGVHZFzHTiqhUnyCBGA7gXBV8mDY8ni
	yUE4HTI5yfv51EWLyXGPIhUiBNJN1XD3BrqGipW9k6WRhUuA8mafODxduCglcUTaeA+pwE
	+Dj/g9PzOjQCXNW2yoBcml4ebMUW8RQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ACflo2IcJSP2BuaivXQRPYHeSVXUbTLuFXLbW+gqGM=;
	b=EJ7dP0gwlUoxPNwgSYx6H1kBkeXHdLE534xQvltBvQOROTAel0PAhM0gm4WyhFpvwD/ygj
	zyjDDgRykxuV34Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7C6D3EA69;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iF6PL86DoWkvOwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 27 Feb 2026 11:45:18 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v4 4/6] drm/gem-shmem: Refactor drm_gem_shmem_try_map_pmd()
Date: Fri, 27 Feb 2026 12:42:09 +0100
Message-ID: <20260227114509.165572-5-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52C44120007
X-Stat-Signature: wohbzijafmzbxgsecdg7pqkh6yt39am5
X-Rspam-User: 
X-HE-Tag: 1772192737-987928
X-HE-Meta: U2FsdGVkX1/7ZEHZr27rlyPxl/5ziCC1r3MYbt8/pexskXEULly7cfKLmE9EE/oB4n1gmUC9beiP4n/xa2kJ/u9hIM4A8BXDGqr7iB18dkWwqb2SjNOJXx28cl8Hl09V+lItRdyM9gVik9PcfxpZYqlfUOWkN12sFbFagxl6kUIaKa1F5ojfsyV1ZnenhmU4FVosWx73i3Yocer5E8h2SRtykeno3Xi012LAngvbr8d9zHcj9YxyQrhlXiKjblpG9puyJC/wnlZKBTAoXR5ucsaakE8VCP2j+SKsu0MDWurrxhfMLqRLOewzfkJCQ7CwGkYRyqpzk5DJBRwMGmGG69Hm88VSQjKx4ALP2coQATDhy6nb/cke2e4EJZkzPvq3mfyoJRli6Vbq2fgAvQRRmvMysD593F50vdSZCUG/vS9GbGLJsTMdlzmHRB0zRFo9JBpMTCM3Vlqc632XS4m8haMGa4BkZeh5+3D4QToH+oY1v5urO/SwAUQA69meTF3D2fCbNgrE0CPdwmtic+dAmNcHUknYTcRgKOynpaC/pUu4JmjuGh/gggd9TZRoVtLNrvo90ijZ5U3T5BkvVkK50Qi+rvqFnXAl0a0X/VhyUa31m/5C6+FN63SZi7UWbjHVp1tefDIb+d1UGCAVh6dux3JbJvDBarSC1PLvzrOdFH98fWjVbuYzu2foPAD1NQbTqvChMoixgQ0cqSUt8z8VD0B6PeWAIW+SKsZwLZStauwN9ZNm5kIq9CtDAdZqvSBnihNnOx01kvLUPOWUqrTYLcEPV/e1l1FIkAcjbq3MJp38yQidu0ESdPXU5lg5EqhnM7NpaZIS0dwKSqAv6P0Knh3ycFqecXduF5GiW4sS6XTwpA91qyyE8BtUxYlpANaMjEplcAsrzwYw7Ch1IPzgZdVQyzHPzlQw/J5pbd2zBo210U04CwjWYWHYtt7zkHPzcPtTfcmuQD7hnMBecOi
 ZywXvt+I
 eyDDGKNOa5RgmtvYQES3Tt+c8k5hbsKAYirEQyvT3z7HaiwmY7sTUE+ld1P053RwCDPIisQz4DHRQkjHJaqlJ0Fz8rHKT2huOXeADc8GiRP39zdDVvWRCk0YTXOMML6ANTbqUvzPpouUfBvtAiRANZulwLGwubEiCdJBNCCkewzXMbMETpy/q8Eq7g1WicSdZrOlB7G/p52aPOCiHny3TzYdh5rC5yCGLiIeZL51yqRNfF5SjvZQlslz6LAtz9h1LjcN1Yzsaw/Ny1pjlZp3P9GIwZn90QN2sUlbj5JiZ/3pZbiS0Y4MEfKcIdSi+PN+Oam0UtJ3X6EJqOdUXMf69O7DbZ85V+DYE4rXwGV0Bdb+TadU=
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
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3c261b53c974..cefa50eaf7a4 100644
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



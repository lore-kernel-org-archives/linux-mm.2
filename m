Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4438AE81BB1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7456B0092; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB11E6B0093; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7B46B0095; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8F36B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:33:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 603F21BF66
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:33:02 +0000 (UTC)
X-FDA: 84425009004.13.CFF1B6B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46D2920005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:33:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5jhfje29dZ7pHFIdAcUp+6Xx7AcPNyYok6NHM+tkD7I=;
	b=BWRY+/8y1BxQHF3r/W9TYYLg+XxN8jdL5J8JLe9nmTYyuXkJVtFndTvGpwYEkmE8ESdltZ
	7pBWihkqmTa9tZgWlHl4+0rsTqMjhGLcgcuFmPiJHcHSwHGX6uAcYDC0AQ9n2nNpySVo6O
	JPWUEGyHKhX5S6x89/iiO9ffqt1deCM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643980; a=rsa-sha256;
	cv=none;
	b=prvrem9s5GzbsknkDc6jiQ7XZBeFgYFEvMObZcIRXlOks+/EzehPks2vVR/pansa+IXUAh
	Btxfx7faSdObVnK6/4anTcD95EVb8OuYr7NSyFMUggONbQcQqwUwm2atzKTn6dZTDZ6gqu
	+E6pDuwSLJTHeYkyEVyOHjJu/bg3mPo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D08665BD3E;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76F763EA64;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qMmaG//hiWmTIgAAD6G6ig
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
Subject: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
Date: Mon,  9 Feb 2026 14:27:14 +0100
Message-ID: <20260209133241.238813-6-tzimmermann@suse.de>
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
X-Rspamd-Queue-Id: 46D2920005
X-Stat-Signature: yc1s15boqa9ydagyckgbe7sayit17tas
X-Rspam-User: 
X-HE-Tag: 1770643980-76767
X-HE-Meta: U2FsdGVkX1/duphbhSFLVYfTj828s3E1pddnwBWdSL7G4zd58hmJbMXTYQ+WBKw4lc5LJCF7LQY87MLArq8X20pe98C7b//kaZOYecpxnZQ+ivPu594b/wAqISGMKZIHGVvXLzsyhHeHjKvS07AFbudn5sb/91h2IPuPT2i1j3OGb83yQuGz3QxLkcvqLGg5bEqEdqNGqCGFVogxv3t5opqebgO5tHKTpsMfkRF69XhFc8rHOdS6e0p+gU/tYjzRbnCf7dDTqqBl+zYr6DRTcaVcrw2jnAZj/9gf/AMxWDqZ/kLkOl/pa5paZvQ9T4l6bH7Ns5Y+1ay0SG2QRc3J50P25+q3g11LuGRuumGdE9560TpSmODqo59ZtfSRQ2HWuVpgUsz//ja7L/5xJaPdLXUZoQwY8nbN+M0NvK9hYH87uIUISump+dzKQlv8t0JZbvWsaT2OpVSXj+Tn5ru6ilF6x1T44pO4OhBxU8+qCbaSLzkh+ZYjwGH0logs7Vc+rCZ01vQ/5ZCfckm+Gm5VcfO84PP5VunVqKV/fyk0OwfSJcrqHPI53zOXny6xiaKi62oRSUB0ihfmWiU3r8qIFNF0wVGIEGC/cYJ3C/xY8D1v+pBCHi1FmbUsaVeKh3r+PTgd7r3nXeydz1jdA7zG4GbQLx4BzI8sjgqng2rk8Fr1DSDdTeicCYOtM/9TsPIH9/1kh7VZLIlCft2+3E+HCnpci7u8ec1UpWlgN47Uoh/BCKje3eP8s8GIaumbDXRSTowyv79HOhpRtHl3zqRsUvirIqjZej4BHhkoaF8VMduQIgYYDlor3AH9eob5XNiL9F23PeqHkufZ+MkD/ag4TKvuDdniB9+gbxXszxs4KQduj7PyVErlmyxDBcIC9AVhBMB0Qoq8OPD04DD7UuzSZNhzvG3ImU3sV5wBo2CStdUhXwri9HLRP88oOg+UiacSyBTeaOSUQJAtLWx+rer
 xmUD/mg8
 SKxC+5loHZCa53idcbw2Cz792Q1/+kZnDUdSISCIi0WFSeE+chIg+/ikJDPLSWly2tXDEWeooW/ypoer9Upj7UH9CaBolSGiEdhDQ7m6S9EWGuYeMN2JxiH5ntpx4VC5v2g+V2j6q/ScUNYTCu+8da1U4DIauUx1ukxUwmyNwM7NtSYRXTV/m755QqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Invoke folio_mark_accessed() in mmap page faults to add the folio to
the memory manager's LRU list. Userspace invokes mmap to get the memory
for software rendering. Compositors do the same when creating the final
on-screen image, so keeping the pages in LRU makes sense. Avoids paging
out graphics buffers when under memory pressure.

In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
for writeback should the underlying file be paged out from system memory.
This rarely happens in practice, yet it would corrupt the buffer content.

This has little effect on a system's hardware-accelerated rendering, which
only mmaps for an initial setup of textures, meshes, shaders, etc.

v3:
- rewrite for VM_PFNMAP
v2:
- adapt to changes in drm_gem_shmem_try_mmap_pmd()

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c3a054899ba3..0c86ad40a049 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	if (ret != VM_FAULT_NOPAGE)
 		ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
+	if (likely(!(ret & VM_FAULT_ERROR)))
+		folio_mark_accessed(folio);
+
 out:
 	dma_resv_unlock(obj->resv);
 
@@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 	drm_gem_vm_close(vma);
 }
 
+static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
+	struct page *page = shmem->pages[page_offset];
+	struct folio *folio = page_folio(page);
+
+	file_update_time(vma->vm_file);
+
+	folio_mark_dirty(folio);
+
+	return 0;
+}
+
 const struct vm_operations_struct drm_gem_shmem_vm_ops = {
 	.fault = drm_gem_shmem_fault,
 	.open = drm_gem_shmem_vm_open,
 	.close = drm_gem_shmem_vm_close,
+	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
 };
 EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
 
-- 
2.52.0



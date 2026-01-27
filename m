Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605E2D2F02D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F656B008A; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3566B008C; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B43B6B0092; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 795E06B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22AA01373EA
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:57 +0000 (UTC)
X-FDA: 84377826834.07.0957E24
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id E608E120003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M6uJjG+TYGOQW6Abko+asLp43o7pHDM8Ph7NKMjLQzY=;
	b=djI9r49I3KLNsy24Xk1l8GlETZhgiX4dBwpjNMS/OdZsGv+caf5+DYqEoaL+u4OeYghalu
	2S5YD48Sryp0JZQxGX5qIIyGGcrwk7fYZgcb/S5cFjSetglmhGTVkCu82hunbgLxtAdpPJ
	8fD09JrgFkgfX+VZVRxKgmsdFWtf5u4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520595; a=rsa-sha256;
	cv=none;
	b=sb4uQiizHOmYS+NPwje/szM8rttqwJ6UfuGjAvD3493i5V2V0cI3p9iWom50cKKYdUWtck
	+XWjWfwi75g/S2LKgu6G5hUM684PQuOFMK/1BcAFUv5P0bhZpIE3LltzM/CF/p0ucUM/4Z
	RvBGbLtj4q5hv5TUAyIendztU3yJkKk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6139A5BCE4;
	Tue, 27 Jan 2026 13:29:48 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8F323EA62;
	Tue, 27 Jan 2026 13:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0LPDNcu9eGmeDAAAD6G6ig
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
Subject: [PATCH 2/3] drm/gem-shmem: Track folio accessed/dirty status in mmap
Date: Tue, 27 Jan 2026 14:16:37 +0100
Message-ID: <20260127132938.429288-3-tzimmermann@suse.de>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: mpij81n5q5bmweteekr8h9naw51dj4dy
X-Rspamd-Queue-Id: E608E120003
X-Rspam-User: 
X-HE-Tag: 1769520594-137071
X-HE-Meta: U2FsdGVkX1/a4Siu4EFBaTB7hz8oMTVEKTR2l6F2crQthWyln91vtyS2DYQatZ0uz9HnJQb9TNVnRJdny1U1cRl6VQ7PEhdsrbvIAKiCPfWl+OHYiXK26HaZDXxeOi0lex2Q3vL/rV2jkhP0rQgNgBXui5Sq8E94vg/1aO6gQ7JHd061PkpTjEVNc7LZkGGkiHulAURE1jWGqwBrHT3YCd9mJJrfYmS3kG37EP5wFh3MvmA8fJ+k+C84WvTwCTpeEPGQGC0snIbeDPZEx/gNHNrci3PcoKohCRU0Ovwi4gN29/suHrVbqIElbJjk4HaH1ISfCmE5YganDNKSX0qC282y9Z6z9hJAc1K08FPALS/8OTB9LBh+TvyaVISAGNdaL6sMnQdyW+grI3br9SmCceAXrl4SKY6NoJr/NrrhrWdbn2YCavwzJiNuyq+Gs8z0u+JlbPhZyLImJOEyCTYMgTnp5hOqtfCnlPAwxhrM0kgh0xFB3Rq8fYzFgwAkd5atxVFG0GdFcRSeLsybpogSI3NAv286jDNUDIZWOuq0yLxZwJ3iov5je6EuUS79XXrefF8ndGXCirV5TNJXaI5BiARH25OMYqfIJtLjnYhiuO/K6vtyDQj+V8eNTd/KoGlfvi+eMb133p8BB12DSBc7qZB7r10g/RXg3JvGJddN0Ta0peeyiZmzL7Pf+9XSqQKeDFevSkpZBYx/WbEa6mS9muW3EW10wUBjJCjxMDpDmRlOpheljTzMCTQb16hUrQFLlqaFEmS4jHQMpYGuHQAWLDFZPsnRnptk+AZ9QxZQ7M4Sb+AD92QrubmvFKno6TgiCeRUhqtiw3hEkHf5zRQ0incLFLcsvuc339nZ1FVBCXJqQv4h9mAOdMdwuHrdz82i+R32FXVEWC/5Q+t7zE4pOwpsCBp1eEQfc/8QBTKXWXQclggx4bbPWn/+cvrWiK8wQNb+f83VoVWIe0aEO9A
 5/K7cY3T
 o5c1lFGRrusnHKnSYDy54eKuegJBlmmpkeYTV9ziTa2fMsw8ipl7zRZZbzXiL93gQQ5YV/llBD0lqOGraiaWekPSRI5NI9AxyTADrNqi0uYCxceAKBJWWUjRgow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Invoke folio_mark_accessed() in mmap page faults to add the folio to
the memory manager's LRU list. Userspace invokes mmap to get the memory
for software rendering. Later compositors will do the same to create the
final on-screen image, so keeping the pages in LRU makes sense. Avoids
paging out graphics buffers when under memory pressure.

In page_mkwrite, further invoke the folio_mark_dirty() to add the folio
for writeback, should the underlying file be paged out from system memory.
This rarely happens in practice, yet it would corrupt the buffer content.

This has little effect on a system's hardware-accelerated rendering, which
only mmaps for an initial setup of textures, meshes, shaders, etc.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index b6ddabbfcc52..30cd34d3a111 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -562,8 +562,10 @@ static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
 
 		if (folio_test_pmd_mappable(folio)) {
 			/* Read-only mapping; split upon write fault */
-			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
+			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE) {
+				folio_mark_accessed(folio);
 				return true;
+			}
 		}
 	}
 #endif
@@ -605,6 +607,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 		get_page(page);
 
 		folio_lock(folio);
+		folio_mark_accessed(folio);
 
 		vmf->page = page;
 		ret = VM_FAULT_LOCKED;
@@ -653,10 +656,23 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 	drm_gem_vm_close(vma);
 }
 
+static vm_fault_t drm_gem_shmem_page_mkwrite(struct vm_fault *vmf)
+{
+	struct folio *folio = page_folio(vmf->page);
+
+	file_update_time(vmf->vma->vm_file);
+
+	folio_lock(folio);
+	folio_mark_dirty(folio);
+
+	return VM_FAULT_LOCKED;
+}
+
 const struct vm_operations_struct drm_gem_shmem_vm_ops = {
 	.fault = drm_gem_shmem_fault,
 	.open = drm_gem_shmem_vm_open,
 	.close = drm_gem_shmem_vm_close,
+	.page_mkwrite = drm_gem_shmem_page_mkwrite,
 };
 EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
 
-- 
2.52.0



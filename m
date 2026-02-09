Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DD7E81BC5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136186B008C; Mon,  9 Feb 2026 08:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100326B0089; Mon,  9 Feb 2026 08:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA2E6B008C; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C898B6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8469254E60
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:50 +0000 (UTC)
X-FDA: 84425008500.26.187A80D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B603A001A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hpzWxrse;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ttksSl8q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hpzWxrse;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ttksSl8q;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boj9j/yGfFA2Etm+EvKg+xlbL/fVdgVk5fwC1+4q6MM=;
	b=LzJEArPqE7I7QwfpQT1qhthnw+Bli3/6roIHhZgzFcRGnAV+TWl3/jy4bOjX9HWyDenU9m
	RNjpK1WuGprNG/Dl8YIzz59CpEZUw1Bl86grJhtGdbsiRD6UQlaWkDEEpbWPjzY5VtOcqT
	1g9vy9avP6uYhJZfjvguFpnmayotrSU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hpzWxrse;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ttksSl8q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hpzWxrse;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ttksSl8q;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643968; a=rsa-sha256;
	cv=none;
	b=ISFMmUrpGdAKZpqNTKbkF0gMfHrndIPVnQBxYULdqqFAOiRqK12UME+i4mJj9cXSGASV7E
	VR+GWKe1cPUb9sRKGwBAxdtsvKP0hoC0qrlmPrcD54IoSG/1TcRVUT4+aOz8H8LKlZ/a6C
	Z5HZtUeSonaVqJNQs58loH6tgbLjIHg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C5F033E6FE;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boj9j/yGfFA2Etm+EvKg+xlbL/fVdgVk5fwC1+4q6MM=;
	b=hpzWxrseP1PXppnUk79PnOjOcaTbio3BXi5QtKGhtmvJ676U27eI/hJJrDbZ7t7KtpQAVG
	vtmIHx0zsJlFJ+aFbZxQJlY9b9l7lhJzA4xipS9hwEuAZPu5Xf+oX3UHQypI+zMC5kvFRK
	Vpw9KEBZv6hVBLNfd/e3dZbnoVk0YBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boj9j/yGfFA2Etm+EvKg+xlbL/fVdgVk5fwC1+4q6MM=;
	b=ttksSl8q4A6bVbY31sfbadXvxPQiSjsPFMuFVcYH8KxKtN9Hxb/plpH23/k6Rf3W4V8NpC
	5BeSpzVU3g5pVsCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boj9j/yGfFA2Etm+EvKg+xlbL/fVdgVk5fwC1+4q6MM=;
	b=hpzWxrseP1PXppnUk79PnOjOcaTbio3BXi5QtKGhtmvJ676U27eI/hJJrDbZ7t7KtpQAVG
	vtmIHx0zsJlFJ+aFbZxQJlY9b9l7lhJzA4xipS9hwEuAZPu5Xf+oX3UHQypI+zMC5kvFRK
	Vpw9KEBZv6hVBLNfd/e3dZbnoVk0YBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boj9j/yGfFA2Etm+EvKg+xlbL/fVdgVk5fwC1+4q6MM=;
	b=ttksSl8q4A6bVbY31sfbadXvxPQiSjsPFMuFVcYH8KxKtN9Hxb/plpH23/k6Rf3W4V8NpC
	5BeSpzVU3g5pVsCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B32A3EA63;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QKS8GP7hiWmTIgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 13:32:46 +0000
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
Subject: [PATCH v3 2/6] drm/gem-shmem: Test for existence of page in mmap fault handler
Date: Mon,  9 Feb 2026 14:27:11 +0100
Message-ID: <20260209133241.238813-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209133241.238813-1-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a6sc74jejrms4udnthhtj6dm8twn4cmg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B603A001A
X-HE-Tag: 1770643968-664469
X-HE-Meta: U2FsdGVkX19ZD8CA8d6UXX9kDYM60l914yz2iAr7zoPnoX4FHozeqfZR3nbqqOcjaH4Q8FZa2oYUrVYUHHhcxlTKP+cUpvNu1QTeTMlvSrP+FhQiE3TruRyjjaBr/ObyPNHPmMbm7DVh5isEqNFkYk1ttdsxVGOVQTS7O8rTDo0NOp590et841L9zXBb+y8rlVyelgnccFasCMQ9OYKeZLTU/EOVTDwrzfTm9CZozGdtyXVid1SHTfNB7CZ1NZED0X1csxagTSoQNbDKi8pQpCpgyZYEkxuHUPTlAIcsAz1zd5drN+dXTWPse+4tlEaCfItdQGV8w9NsrtsbD3jnxfR0z9gcaRc4eVrjHXNINQi3zDEbFSlx34AyA/jKPfw8MLyuDhx+5FXUxwsUe8VUGOI8sJyyPaX7NeaHsMImrt2Vb9wTpjvDEpvpqr6OlG+9xxgez7xVf5z7aLuMvwULUwl7n7fH0OVkgdACMw/jFMVXlIJCqKoYzg5TRh3Iw87fCxXVQfveISyJ0XJ4pwyzIKWsKblJQO6AltmGsZ09ocQHuzm6VBDv5ViIqj/wtJurte/703MF3RxcP9+L8HE962+DVWhauTF+3hnWIr0Sq7MhFWL/NGWMMQs843BHuqEdvFroOMqDD8LeubiIQbGbseghpsKYW9xyQWwOy4MDEFlchYVTi5TatEbIwlKNYiLPsZEXFx+6RPx4tMOZkjot6UUBj2+YvYxw15wL9tKJXgVzYg4uNyByxlt4cGzmB5PQzUp9Fb4AWsLWgEMkMU+VrJq59WF5JhAgsk+KsR/keBAvEZO1qIXny09DcWlzz+Uplucy/6nV/VJO5k0G7XoMInnPCXbeTnTGApaS8TGgsmJP/8VVas22y+gIJ/eKh7/LpHfR1qLUAHZV/1Wl8nn/kQqgUx5ORJ7YHiv3HNzB+5u5VAqGzKI98ilAkQQHRSngdraVnaIklACaZNcYkFo
 JhCMgtUS
 LwYpGn43Iu9PyhvQgA7755Gh0eMAiZGi2ccGwr0I3e36OjobwOlF82YdPywycZTAbuo6KQSJR0zcQqxWgCnIsPiYvbO8axRL1/6PgTXqMbWi4IkQhAlnDhzPcQiT5Ov9pDs0PSnSCHWz4n38LEUfqb+n8BCaTMgiBOi9Y38deY/0qXnKJedJ2qKfMCxBrGx4vagJLkG7rlF2qmqKRYQY+A5i69cIRtAKHSOLq9R4gh7RNK+oYGLclemkuZuTn173sc2LgmpgR5s28Cu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not having a page pointer in the mmap fault handler is an error. Test
for this situation and return VM_FAULT_SIGBUS if so. Also replace several
lookups of the page with a local variable.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 5bced7db0f1f..3ee54c24e535 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -574,31 +574,31 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_device *dev = obj->dev;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
-	vm_fault_t ret;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
 	struct page **pages = shmem->pages;
-	pgoff_t page_offset;
+	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
+	struct page *page;
 	unsigned long pfn;
 
-	/* Offset to faulty address in the VMA. */
-	page_offset = vmf->pgoff - vma->vm_pgoff;
-
 	dma_resv_lock(obj->resv, NULL);
 
-	if (page_offset >= num_pages ||
-	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
-	    shmem->madv < 0) {
-		ret = VM_FAULT_SIGBUS;
+	if (page_offset >= num_pages || drm_WARN_ON_ONCE(dev, !shmem->pages) ||
+	    shmem->madv < 0)
+		goto out;
+
+	page = pages[page_offset];
+	if (drm_WARN_ON_ONCE(dev, !page))
 		goto out;
-	}
 
-	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
+	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
 
-	pfn = page_to_pfn(pages[page_offset]);
+	pfn = page_to_pfn(page);
 	ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
  out:
-- 
2.52.0



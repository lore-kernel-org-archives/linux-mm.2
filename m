Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62932E9538C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97596B0098; Wed,  4 Feb 2026 06:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75A66B0099; Wed,  4 Feb 2026 06:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B9C6B009B; Wed,  4 Feb 2026 06:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A96846B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:44:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 759C31BC70
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:44:08 +0000 (UTC)
X-FDA: 84406590576.28.62BE73B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C0C1A0002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:44:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DESgMqgB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="GgltB/GL";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DESgMqgB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="GgltB/GL";
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npsqTdSLDnuea594DZUQ+Ck3wT+hdTqImYL3Ki0a0LI=;
	b=KzTRZD6d5Zvlzj/0ZdgfSYrmJOjZbiTf0MwXM/i1U45PgOO+2iAg8IZq0vluAcPE7VG4j6
	bVZxEzzxSL7iVIZ1Xf4wWcm/ikdoFLMkuhJpfI5ij7b0Eehk4hCzU8C71xzR4PZmaD/5v2
	e7qwp6mE3ZyYdRB0JX2sj5LhtN3+qaA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DESgMqgB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="GgltB/GL";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DESgMqgB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="GgltB/GL";
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205446; a=rsa-sha256;
	cv=none;
	b=c9I0qhgY9IKSaUIdN+4hZ2URG9KRtFJ/gH13YDI1Q3Xkzsy+eV6Lfh3mNc8nmxn0P9ndOy
	VrFOASGZREaB6OxkrvjYGVwFNITzBvmTEua/a4HwSQ04iXbnW6jx0DNdtQv8esCvk512Wo
	SWp7Sdh5adhBtkVpXkNG5T5iJTh/L2g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 074C13E710;
	Wed,  4 Feb 2026 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npsqTdSLDnuea594DZUQ+Ck3wT+hdTqImYL3Ki0a0LI=;
	b=DESgMqgBDxiuKGaeb1DEPlvnqBXV11Vv8139od7KMuma1Hp7enYPBLLqLfxrpYwTAP/kwP
	SEWdfr+se661eiSTO9QwtGOhtby7zKLI2CpUfnxL5eoqtuzhR/kAKV6sMiaI44pVl+3Xzk
	5OSEV0xrtELj0HDRma/dMWv2oRSWe3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npsqTdSLDnuea594DZUQ+Ck3wT+hdTqImYL3Ki0a0LI=;
	b=GgltB/GLs6kyyvousKewkZXRafzgkvE26FlskQb4I53oxd5EjFN6Wke29PupcaLj8zQ7oj
	OjGQ1ttcBv880vBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npsqTdSLDnuea594DZUQ+Ck3wT+hdTqImYL3Ki0a0LI=;
	b=DESgMqgBDxiuKGaeb1DEPlvnqBXV11Vv8139od7KMuma1Hp7enYPBLLqLfxrpYwTAP/kwP
	SEWdfr+se661eiSTO9QwtGOhtby7zKLI2CpUfnxL5eoqtuzhR/kAKV6sMiaI44pVl+3Xzk
	5OSEV0xrtELj0HDRma/dMWv2oRSWe3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npsqTdSLDnuea594DZUQ+Ck3wT+hdTqImYL3Ki0a0LI=;
	b=GgltB/GLs6kyyvousKewkZXRafzgkvE26FlskQb4I53oxd5EjFN6Wke29PupcaLj8zQ7oj
	OjGQ1ttcBv880vBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9BCA63EA64;
	Wed,  4 Feb 2026 11:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2HGbJPMwg2ldawAAD6G6ig
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
Subject: [PATCH v2 3/4] drm/gem-shmem: Track folio accessed/dirty status in mmap
Date: Wed,  4 Feb 2026 12:39:31 +0100
Message-ID: <20260204114341.195143-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204114341.195143-1-tzimmermann@suse.de>
References: <20260204114341.195143-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3byhn7smjczmjd37xo7g8rqh7x6capcy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C0C1A0002
X-HE-Tag: 1770205446-631722
X-HE-Meta: U2FsdGVkX18zMBpXFqr/FcG9sGOtL8HyDt3e/4SiLgCPZsqHFQjn91TtN1smEzjrMP2uiF8tdV1JEIxACwPgwM/1Y15rYfxJCR1zOfOTGGdOK9rvMt4lNRm16gboGfQdoN4oO9s9EbvGtq7vk2DVmPlZuq3P6hEq6eHAr67Ol+ivSB/5uPCrrUVhe3eTKkOqBK9QFPeqV+80k/Yh+pxnmkYIT7WfueNx2++zobgvuxN2VKkngyJgnFTZOXD3IFJf7M8jSThZCVYOZpAnuhykbzqgpq9z8nKEbK36BWBLtJoS3UjM+6fOcTN4JGQasIJaoz8eHFlU3Xdr4AUAPBGWZVVynkeNxFe7N9eFw77fNWBJnymuN3CDbCr63/8MLOQmfcdetSPHUf4yHsGmJGTHiDXO17PAxweLN3hB+R97u0Zt9uHwlDCzG9NEBjNi7Cb1lCN2yGbMf3NQ4fH1nEDNhYESryiicPAmP8jKW+mFo7WJr1jI5EbrSgUWKAg+ll5HnFKpIffBARlbKW692oCkeqOo0px60JlJEroINsXlgjPohfGixAGQb4jEw74nkcR7nrEGBCGVz/2Wx6TeBTHx8F5EVkEVMt79rGK9FM7WGzhr7hSMXBDQ6nSGM5GGMW5S+xgKseaePBKcxOgXOutPmS4yyeejYB8VW9hKUy4RjGrNO3Xf+pxRjLttrDV6MmCRCSXLUd2++wx0W3pQiz2rLjuoF4RkulwIp+dZWfX+/6EJRecuc6EyWbRtPHnFmRA0qHZYdeT2yE6S6qEQMWkGeMZEzWA2hqP9YMaKw6ALn4bw+mIlfyff2wacMC/tu2Fqv2GLo30ACIbaqeUD2Kkk76IQUSRptqHi6bEfEsL6CBkNxXTOQI5ArKKCLe1FPMHwyH3agF5WFzJt9LR2pZ0bUjnyrkkt0Cnfb3/LVwYE5JPJ+FBVVKnl/HA2HYiM7nFxmIrfjOqYOluOvhSibso
 bUuX42GR
 jhdhJybGO0nbEwXyW+NY4gttoNe1n1bQw5+rKf1xd3djmE/HJfNWYZFzXNgm88wPNjsTkpfSd7wLdUbZCxwHBB2Z8+fXeSrHqfDXHRckxJAR2QOeXE/4hsyY7RjynjV4OFJxO3oxqqn7pXjHEp1mfDbOzQYPJxmIkp8HbREBUTKVaM0AoF6k+2Qh1zAS2tINcNP7OvxK5RbNtj326sRPl76gAYWO2mARSgP4vMFmoWXE2521UbROxdQ22X4ZGV+lPp/LEN00NYG+XuEOgSDVkqLkReINNOmRV79CKGiYfj3rnjpRJpMVeeREkI6p8qpdmswSu
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

In page_mkwrite, further invoke the folio_mark_dirty() to add the folio
for writeback, should the underlying file be paged out from system memory.
This rarely happens in practice, yet it would corrupt the buffer content.

This has little effect on a system's hardware-accelerated rendering, which
only mmaps for an initial setup of textures, meshes, shaders, etc.

v2:
- adapt to changes in drm_gem_shmem_try_mmap_pmd()

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 24553dec070d..c2ee30967c41 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -597,12 +597,17 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	}
 
 	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
-	if (ret != VM_FAULT_NOPAGE) {
+	if (ret == VM_FAULT_NOPAGE) {
+		struct folio *folio = page_folio(page);
+
+		folio_mark_accessed(folio);
+	} else {
 		struct folio *folio = page_folio(page);
 
 		get_page(page);
 
 		folio_lock(folio);
+		folio_mark_accessed(folio);
 
 		vmf->page = page;
 		ret = VM_FAULT_LOCKED;
@@ -648,10 +653,23 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
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



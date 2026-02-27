Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9DEFD7F95
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDE26B0093; Fri, 27 Feb 2026 06:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7680B6B0095; Fri, 27 Feb 2026 06:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A4F6B0096; Fri, 27 Feb 2026 06:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2D06B0093
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8AC4140610
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:45 +0000 (UTC)
X-FDA: 84490057050.13.40909CC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDF97160002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G1y/HdiS";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gi41mZhN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G1y/HdiS";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gi41mZhN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192744; a=rsa-sha256;
	cv=none;
	b=M35ZHm79EYguyA+mGEF8uNjf5jQ5dfA3LgHNGEaQrlmuSBkLBVWOqfnAzzXyTR7OhiIyg8
	Fq3M5UW0JmPupBOwCZc0nDFiN5oCJ0IR4tmylWgOEGxY8EbxxyBXyR9t3UzsNFJ8lYYvP3
	NG3zRDq+3MkxvQEU+/2dJhrtyIqOads=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G1y/HdiS";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gi41mZhN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="G1y/HdiS";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gi41mZhN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qD9cPUjCfQIEcV1FM98VU8MENQsevxJO4ZITT1LTTK0=;
	b=ymqpeiPOQR6jI8M8g2gwbg00+JbPWTXvMvUbI4hpcPXjk05E1mPhu9FtYNTeHz+0qs3YHT
	ICNGAIj5AfmvETaAM8ox1Sr8QmNV5dD5Kmh555hi/9ULg1/I8uJJhEc2AvsRwygVSCuhM3
	32PEPYRXxgKZCEexMiG+HnojbStPyUw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 780FD5C382;
	Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qD9cPUjCfQIEcV1FM98VU8MENQsevxJO4ZITT1LTTK0=;
	b=G1y/HdiSDPHYCe8clvxQ+z5tm52Y5was9y2q0+78J26rAGBynXshDf8M9AvhOc/5XwtfM7
	0qTAdHRSRDcYXNr9jXtXiPZa6yaQSjtoHY+xAckUxhMIp+xgokvn7j/tyORTTIUpPogd5S
	mgvcCe3ixALpXqSDc7HIRFGAM9bKXnA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qD9cPUjCfQIEcV1FM98VU8MENQsevxJO4ZITT1LTTK0=;
	b=gi41mZhND2bu5qxDH3+mFWHCvbOiwrHCQ4TIzvV0CFtkhYbaEb53XQfGioYXHTR6hGiFZY
	TBWQmBldfhScndDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qD9cPUjCfQIEcV1FM98VU8MENQsevxJO4ZITT1LTTK0=;
	b=G1y/HdiSDPHYCe8clvxQ+z5tm52Y5was9y2q0+78J26rAGBynXshDf8M9AvhOc/5XwtfM7
	0qTAdHRSRDcYXNr9jXtXiPZa6yaQSjtoHY+xAckUxhMIp+xgokvn7j/tyORTTIUpPogd5S
	mgvcCe3ixALpXqSDc7HIRFGAM9bKXnA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qD9cPUjCfQIEcV1FM98VU8MENQsevxJO4ZITT1LTTK0=;
	b=gi41mZhND2bu5qxDH3+mFWHCvbOiwrHCQ4TIzvV0CFtkhYbaEb53XQfGioYXHTR6hGiFZY
	TBWQmBldfhScndDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 287D63EA6A;
	Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6CKwCM+DoWkvOwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 27 Feb 2026 11:45:19 +0000
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
Subject: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
Date: Fri, 27 Feb 2026 12:42:10 +0100
Message-ID: <20260227114509.165572-6-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CDF97160002
X-Stat-Signature: xf15q534gwk6hm5dhtt53ssynnp8aupr
X-HE-Tag: 1772192743-383186
X-HE-Meta: U2FsdGVkX18MPhomsVSZK46gD4WGm83AoWxiuLuqkSc2YB2uYJVDYurZYggm30xPgmBYjhSOGC3pwzThqxr4WCB+gryVs4HtwQLtXPepDwBWA3bZ/7mVK1BcMxds/PbdkLJlACMGbznnnRgMwtyTcQ9GuoNzKVFbni0irrNkWqTVtciwsVBJ/n57EK9FDVNkjdn0oXfeJdJvPG73EjkWuUFqSVezOtIaVkgYoxa2P6rjKRsxNz8WfeKpc5jbBO4//tZ8o2Js8BpoPlDHXXgedR7FmxFazduklrX6eKvVdqLvRWpmNaAqZE+9OW5hsNORXtm6sMftkzpyGamgIiceTsSI9y5t6XnKjhggwsGM8KbcxLaP1MfW5HGi2hz6/mxgzoLAw7dgeri7JkIejz9y7pqwYSh/DLHRL6ZkRjNF7yZU+KphT8eFKVTOV9t9tjQ25oadARQyzSMHwpTmRBODjn1S9uYCV1SD9NnXewxoZ1PZ4YOFSYYuWGuPwmbIkhlVUNR+UZm8LeJmb+L7HN6YD2ZlX+SiBbUDkTNcFxBp3oWcMJMVElgOQNiMhefW7/fyp/wCGSKQL4/fb7L7J8e7egVJ7YMiakvvlp0iPb0aMWlnphIffZmnkfy+bgxZmWk2/sYCYUt0ngS2gxynx/Xj+Y85Oy7vMrNx00YuFqBnhgH+3YFN6k/N2UDpDdudIP1kOAuCOU/q9CbqvQxs1KlsEn/wA2vn+lbTXIa88oTkeMkuBpqTmXMpdDBuqksNZhTcLAYiohYSVycovE22EgBC0hCuL8HY1WaOczbiGkcagbtIAVDwmnbec8bpYlKQwyu+pb0ZxDYaahfoy1V9Va8ifOehard6MdD1WPK+b7JA41Jk8Eue+GnBCNWu+NBMKi/O/v8aMn9/w3g8EAmArFiFYKMaXMrO9xNOL67QK9TPP7YeabyeRCVSlhcWNZMDifYbrfrs8xPew8OK71OoqTs
 /JDkBF/y
 QLBJJu5ZgAOVYUkYXf78MSTVSAT9ungSX6+JOaO4c7B1COdIUAs/3DuNNOD1muO7A5oPmbPQooiQRYCcPLF4RVjmQjeq8PvOfGUEyVRrkFlt1YfcDk7lOefZ0dSBc2xA1JwsCiOtuw2nZa5OBz2M90ZMlWj3u3rUnXYrApS3MnLiFdUA2lAtk/+ODGZtSrwIZ9F3cHgXmlqXxD9IFDkfbRxpSox5EnKirjRs4fADn9oXCeVYixbFaksJrbEzh5JcLXxXmcn5g8+nb+LjEEIdVMiU3Jn9WUIsuATOt8fw7aoZiyaUC5UJXMeqyvU1XPmJlR+wl
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

v4:
- test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
- test page-array bounds in mkwrite handler (Boris)
v3:
- rewrite for VM_PFNMAP
v2:
- adapt to changes in drm_gem_shmem_try_mmap_pmd()

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index cefa50eaf7a4..1ab2bbd3860c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	if (ret != VM_FAULT_NOPAGE)
 		ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
+	if (ret == VM_FAULT_NOPAGE)
+		folio_mark_accessed(folio);
+
 out:
 	dma_resv_unlock(obj->resv);
 
@@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 	drm_gem_vm_close(vma);
 }
 
+static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+	loff_t num_pages = obj->size >> PAGE_SHIFT;
+	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
+
+	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
+		return VM_FAULT_SIGBUS;
+
+	file_update_time(vma->vm_file);
+
+	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
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



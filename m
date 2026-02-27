Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2F6FD7F9B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559F76B008A; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C056B008C; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0EB6B0093; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 005AD6B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A02081A05F0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:27 +0000 (UTC)
X-FDA: 84490056294.12.2D4CCE9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6DBB020002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwXnky8N;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zgjmayhB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwXnky8N;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zgjmayhB;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJIOeSgkl30/ot4koAD8USX2eoMLUoG5EqXOcbr6xTQ=;
	b=bzEA3epNk7lJ8a0R58ekg5Ml6EWnrKgBifHThbxMIGoD6Fa4xgp1Q9ZqMKBdsCY86Sh/GX
	pKPA0FhsYADAcJ7QK7993NIp7+euaolydGPTwUAXO5BmyKNzpIYskOr+MtRN69DhmRuXTH
	TRCA8g9rL9HyE+XYUoS7reNWN4E3XAo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwXnky8N;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zgjmayhB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwXnky8N;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zgjmayhB;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192725; a=rsa-sha256;
	cv=none;
	b=TAsSUgiLUJYXgoiqA5n5vZPL0hbx043krGsPLBdndgLF7kYvQWwIj121WA6EhM2xK1O5NH
	yV7tH2h3i9dU6HtDfZwb0b5asFvCI4qfdp9ASpLs8b7efNEtGHMxE1zpuZ+4bInowBGkm5
	fYOcMm1YaIqCocv4j+qfaO6qQdYfr54=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A0505C197;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIOeSgkl30/ot4koAD8USX2eoMLUoG5EqXOcbr6xTQ=;
	b=IwXnky8NnZBqVUdhEXdWLuF8oQ1hELSs4CIDd5xUELTZ4ma7UW9p72BfVlNoF2aJ6YMs6C
	MICAkRFaFhzDDmlmJ5+CkIhAb4Q2rmTj7e8ZL53kFvrDl+RO/WebQfX9j4csKLiwtY67EF
	kIFTsDBAZe6dJjrBAuUxgKVstYICsbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIOeSgkl30/ot4koAD8USX2eoMLUoG5EqXOcbr6xTQ=;
	b=zgjmayhBt3obs9cpdiiMBSonTRbkXOGBi+eSdbhGO/oeoTv8DFf6lvkVCnIIuX5lW1ClmH
	7/Yo5kprPxw8LzCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIOeSgkl30/ot4koAD8USX2eoMLUoG5EqXOcbr6xTQ=;
	b=IwXnky8NnZBqVUdhEXdWLuF8oQ1hELSs4CIDd5xUELTZ4ma7UW9p72BfVlNoF2aJ6YMs6C
	MICAkRFaFhzDDmlmJ5+CkIhAb4Q2rmTj7e8ZL53kFvrDl+RO/WebQfX9j4csKLiwtY67EF
	kIFTsDBAZe6dJjrBAuUxgKVstYICsbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJIOeSgkl30/ot4koAD8USX2eoMLUoG5EqXOcbr6xTQ=;
	b=zgjmayhBt3obs9cpdiiMBSonTRbkXOGBi+eSdbhGO/oeoTv8DFf6lvkVCnIIuX5lW1ClmH
	7/Yo5kprPxw8LzCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CC843EA69;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eAEdBc6DoWkvOwAAD6G6ig
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
Subject: [PATCH v4 2/6] drm/gem-shmem: Test for existence of page in mmap fault handler
Date: Fri, 27 Feb 2026 12:42:07 +0100
Message-ID: <20260227114509.165572-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DBB020002
X-Stat-Signature: z6ng3x54cbwktfezhmodehi4j8ey6d1a
X-Rspam-User: 
X-HE-Tag: 1772192725-43775
X-HE-Meta: U2FsdGVkX19p30uOt8XNeKRWLLdXom6wjQqAw3aWeKZl1CpDQe/pyV8Ki+pRarvHpFWWlAYct9kOCuxrntp28JL0pc0eud1C+GPR7nZjMg7SUkKfQLVursMzCjKSZHNzs0bUK6Mz3H7DnD2cWbTD4jP3z4qghO/JFq8W9po4gNOeEADkYAMZAt83ddAygCspHUIzh+OrhGqiUttajkkoLQ/4yVMqAOZvqhjJtcRYuVqcy1xn3mpT0Y3WA3JUxmaOcp92Gsk4KAhzrrJIaLti83fE/KUVTlf+w+S0TBSdPWe47wlfugCfSpekPUkugjxZzXnIuXMyxkZp4l6hOK5atyUlnP4nmT1+GrbGZXXoteIKlMjrS3cn+RN3HWOYBKjaJWR4GZqaTCv0tBcq0aR4HA6PhcmiXASyT2EDqk/BNqLxACaFVqLYkgbXv6x4vDcMq/IoWKZSsE5s9eZd3Fk/Va0LwPOAURQJpXx+BJzJSp3B1taQWzMSi0cztT9hADvtPVy7g4EuyYv1cXWyvi+e7aWjJisoiMWR7TAzA01cKN1/FggMvWZgzxHQS6mzPjm4BnDC9pfDRWgrRJlWtPEvhZaVuHFskGoxusXpspcoEbJMOA8cnsjH4PomtzFGIE3PjDY9KZB1FnHgq5IxN7OjLXf/HbtKY7WloZw0DcCCljzl2ST3SwJWKERE+BM09xCiq/kI2TyGzkxTVnKEr5a3xZ1JbySehYAMhcf4jJdYmtZw3EjrEd8scYEolpCkYkRxRF4uVdVBcvvzbfNlS6+xUbEV/FCIm9QXhmYqfM/3QJpkj+C7h8tkwyrZLODfRqlY7vLGPkVjOQtMFAHRtdY51nImqEvB73CJXRJ/+gfiN1SU5WJGgQEXuLWNV4jNLGqtsW2A1ufxHOizaw9+I4vtkiChOdBUpxO4Z4Rpd0guQp5VArpPoc843rHtc3oCgDXipvSwYBNjfvkqqZi8WT4
 PnNIuQSP
 e7IafMyvx9wzVFU2+X+/201Q7LuUz3gryedIGLw090qad3QBAwqmKu8ApO4SsLKahVBBuPNA8K616pJP+LLHJTufOiVhpPl8hXVu9QWN5tw6G68URsvDZfCgnUIYf8SlH+8MD4hPrHZX+SkGdpkFcBOYK/Riv40kXSgUd+MDZEEgNd0oF4bcVqC/tuAUPKScMtsYkR+hL8rl9KV3D6enAxPbWnADLlm+eFVhJ1aAIQHZvF6sEH95kXP7qTDASXK4JSFXRVh89G2q8awIV4KBonR/9v/SFwCnYKScWVmrEN6gY/5QLPoLTCa6sCS4bN/RCCKooIIW8vz2r6ubPRPHnATCuBBQlGPW9zoERcmq0LD2JS7g=
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
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 1e3bfbf0cb97..cf5361946030 100644
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



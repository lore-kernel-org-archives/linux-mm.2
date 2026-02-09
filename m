Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D24E81BC1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D90E6B0089; Mon,  9 Feb 2026 08:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7981E6B0092; Mon,  9 Feb 2026 08:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8626B0093; Mon,  9 Feb 2026 08:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38CFC6B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:32:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0006D1B1B11
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:56 +0000 (UTC)
X-FDA: 84425008794.29.32D8402
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id C35491C000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FikndFvSNGC6rJWLyM24for+7q1oWyRPeJN14UaI00M=;
	b=2LYfwzX0cMxorfr7zo++BAr94IAqahQi67h+2K3WByRnrNiUnhJ+e6SuYZQg2S0HntLx/h
	uf7pLahCLH0uVNFZxNe/5u9HFd0EFMfr6HDCd51P9k1F/SPvmkF6sDJ6qvcGVkX15vxLDi
	0eCqb6nwvHEVyfHQOQlEoQ3/U73uiVU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643975; a=rsa-sha256;
	cv=none;
	b=cuqXZb1YUYhCI+G9oHVRU8QC/uuDQEvHqtKxF5Z3iNr7F+auF/c1kJImzGrIs2HshcjAMn
	Sb8zrt/aTRmZdiqYAbggwMezk/37vQUTvsHbESiXJYGNW9QtmhKyxRxwXefJtSrjWOVnGi
	GZ/JBlZjj78wG6d8vIqa57fEfklqThc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25A263E70A;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C22163EA64;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uJw2Lv7hiWmTIgAAD6G6ig
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
Subject: [PATCH v3 3/6] drm/gem-shmem: Return vm_fault_t from drm_gem_shmem_try_map_pmd()
Date: Mon,  9 Feb 2026 14:27:12 +0100
Message-ID: <20260209133241.238813-4-tzimmermann@suse.de>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: C35491C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: ryanzxedu4g4tsnrgmjwxk6fzynme8ms
X-HE-Tag: 1770643974-678798
X-HE-Meta: U2FsdGVkX1/clcz8gwb12aJP6E86urYS2Pf70u5whmFpRNjefBJBMpsNMvyR56BfHJV8hXCm2XPNo/LwEAzRyGnUciSlme8uAFS2enUDjBxjOXMmcqxEaOTl+CT1zZkwlpyLvv2u3kyF6iBCUJMD98GwGodQr1efsuYRrYLUEtereBQ8XlzDuZ1nUnqW9ciVgQG8oWM+dPdIIdFEGzrYwEINjs4Z214h41dNwkv2zELiFUe/PMBKtJ/w0eR5lsfn2J7R2jvxJkIuY3qhqBpgKgLc04Y4/X8oNcb2IrII1JNBB297N+g4Axnx+HfyqxK6OeNPlXa3DU/neBXOsnxsqP6Ntnz1XyGIPIOZsZ910ww0LWo0G0oRSOAcYN50rp/Vaek//S5D4pr7z148cmO+m9JY6G00hHBKRQc8nqaxI/2vS4q2ijo9d9mvd/w18IswEkh91fkhjnUn8cHXQTg7JLrcEZP50jFXDGWT4RrngMQv631SuJCmiKkEcxS/xsRF37HwvnLPA50/EgdPc1iTp13t1J3i9g1VrAq0BzPcLM7MqPigc3RvzOZHsqRUnZDDJNX/MCxXLTNrXZ+Lt3vvkmJM9z66PRZUuaV0XwBPA0qUJWpn8BwhLNdDquaHq7qKIHsn2QG2j+B6Vdp+eMsvxcFN8ZQ5X2C4OQKeiDYYr6kepQonzan+s2o86IxUz3juRqN9RYyJaT4cG1lg9Uoz8+Hv3XwaEg0fLkA4zQyqoVvB6TV3HhU21COXFXHmLjiKiCOMYZFdXIKhaqMGyMO8KnkTc7gPu6S2Lkan7AOK+pb1d8sKz76szVywnJuQYmx0aJcgwf5l0L6iesFe873hY50vIowFxRIpWhACDVhndaw7WG/cDi6CTPScDKA3w/eIFQ9aTIQ9LlsdiVt+OnUw14Y/JJq11LrV7qNeKCR5C/yRXnrazn/RRKLYEsj+q3sqNRplHOSQghQeaQbwPxn
 DOOheGx0
 sjU2JxA3nf3JbE/s24D5rSouNdPdIlnKuVnQZM97P3Dt3HM28TzRkpvPCBhgGD/vs/aTr2OT9kmD5RpRw5G8zsEuoWjjfiSKq6QD/vDjS7J9MjoqY0JRJ3Aszu01qdQFM4ahHTVY1HtjmEt2VXcnsiyhi6EAUFIweFByCkc2BmRfVZHWuoUVIJAzXupQqry5EfazGzYfhq/36bD8bVUW+FKjvdXq6bjDPZEcTa0Myy3LEmS3O60/MqxFclgkGSF7tN84btQ2XAPN5J3cF85hiYwXDIPhwKjQ2wcSK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Return the exact VM_FAULT_ mask from drm_gem_shmem_try_map_pmd(). Gives
the caller better insight into the result. Return 0 if nothing was done.

If the caller sees VM_FAULT_NOPAGE, drm_gem_shmem_try_map_pmd() added a
PMD entry to the page table. As before, return early from the page-fault
handler in that case.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3ee54c24e535..ab8e331005f9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -550,8 +550,8 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
-static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
-				      struct page *page)
+static vm_fault_t drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
+					    struct page *page)
 {
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	unsigned long pfn = page_to_pfn(page);
@@ -562,12 +562,11 @@ static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
 	    pmd_none(*vmf->pmd) &&
 	    folio_test_pmd_mappable(page_folio(page))) {
 		pfn &= PMD_MASK >> PAGE_SHIFT;
-		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
-			return true;
+		return vmf_insert_pfn_pmd(vmf, pfn, false);
 	}
 #endif
 
-	return false;
+	return 0;
 }
 
 static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
@@ -593,10 +592,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	if (drm_WARN_ON_ONCE(dev, !page))
 		goto out;
 
-	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
-		ret = VM_FAULT_NOPAGE;
+	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
+	if (ret == VM_FAULT_NOPAGE)
 		goto out;
-	}
 
 	pfn = page_to_pfn(page);
 	ret = vmf_insert_pfn(vma, vmf->address, pfn);
-- 
2.52.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3768FD7F95
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3641E6B008C; Fri, 27 Feb 2026 06:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346506B0092; Fri, 27 Feb 2026 06:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC266B0093; Fri, 27 Feb 2026 06:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F32476B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C44B01A05F0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:33 +0000 (UTC)
X-FDA: 84490056546.25.5E4E19C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9BD0580016
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMI6jRAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qG3+1z7X;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMI6jRAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qG3+1z7X;
	spf=pass (imf30.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXmsRVNgGN1UEYffCzJXc2JoUfHkMdrrEX6fYCskzD4=;
	b=byJzXeOuWeiNh+F6ZA0+pqV+4X3gfTyZgslm10k7iUEytv83fZ6nPrH+MasN3m13dWXQOd
	AY8e+VUEw+h0EVKtCxjSJYWQ+HRplsQXvoMBMZoxpmkP2qIG2czqSVw8RtYNGf5TLTumyb
	3hBp01UiA+TSlZ/JYOOoIgow0KJ6AKk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMI6jRAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qG3+1z7X;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMI6jRAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qG3+1z7X;
	spf=pass (imf30.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192731; a=rsa-sha256;
	cv=none;
	b=Kt7z9xh8lmOU2WG6XnjoJWUQvnGEXzfRSY83g68zr4nVUH4sPUF6HhmVkDxjEdrXZXLNGv
	h4YlDOK4wuDWfG3Key31ec0Ycv490QX21F2ePt45DKpMhKX/aaDL9sID4Q4dPOjtqUz+vS
	/iqARShDfnuhGbgcJRttHcMi1tfPZ6k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C21AE5C22F;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXmsRVNgGN1UEYffCzJXc2JoUfHkMdrrEX6fYCskzD4=;
	b=tMI6jRAc+qBlYoGDalcdzy9MIUOfZGYoZ8HR1TR0KIvrF+/bdMxUHRLt/y/oHa7nfd/mR1
	hj+LtzcWDH+Ou6nuYNyc4GBvHJV5PGtszwAXNj39p6T1gAwMTKiH2iD1w02lpTvgJ9m2pT
	nkbsyQYTSKJtZXE9qG8/cO3gBBqOdJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXmsRVNgGN1UEYffCzJXc2JoUfHkMdrrEX6fYCskzD4=;
	b=qG3+1z7XUvOaZo8072OX5LtuEFrAxkDnhuPxdslXgt4CdehWKSd2IHXIip08wcRJ3KEMoT
	KJrvJcGuOPYI7YDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXmsRVNgGN1UEYffCzJXc2JoUfHkMdrrEX6fYCskzD4=;
	b=tMI6jRAc+qBlYoGDalcdzy9MIUOfZGYoZ8HR1TR0KIvrF+/bdMxUHRLt/y/oHa7nfd/mR1
	hj+LtzcWDH+Ou6nuYNyc4GBvHJV5PGtszwAXNj39p6T1gAwMTKiH2iD1w02lpTvgJ9m2pT
	nkbsyQYTSKJtZXE9qG8/cO3gBBqOdJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXmsRVNgGN1UEYffCzJXc2JoUfHkMdrrEX6fYCskzD4=;
	b=qG3+1z7XUvOaZo8072OX5LtuEFrAxkDnhuPxdslXgt4CdehWKSd2IHXIip08wcRJ3KEMoT
	KJrvJcGuOPYI7YDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70BDF3EA6A;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QE9WGs6DoWkvOwAAD6G6ig
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
Subject: [PATCH v4 3/6] drm/gem-shmem: Return vm_fault_t from drm_gem_shmem_try_map_pmd()
Date: Fri, 27 Feb 2026 12:42:08 +0100
Message-ID: <20260227114509.165572-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gh9odihju4wxk8ijix43sxjgz7xkn6ek
X-Rspamd-Queue-Id: 9BD0580016
X-Rspamd-Server: rspam10
X-HE-Tag: 1772192731-868943
X-HE-Meta: U2FsdGVkX1/cTL2S2zxTpWFSCdQdjwhhHYqli89ib6DT7cOADDizM1JSmy4m+RmSocgjPAJIdu1PidtjrwLIYO6YEhRFctsMjuBHIJj3ERjZ/6YqWGhThLMP5hPxiM8kKrS6cDGTDCXioIQf+730qfRVIXptu+BC1Tk/fmBtDHZQq6mUvN09/sz7MVmk1YoQG5icZudNPjPozpWKAZUZrGJyEIhAEdutu+9GFbOF2QMgfSTEWoewx3L1RvOdgghCPzrA6gCYuWanikmfOYymMgWK87t/7i3TK90kSk5YEDDK74hE+YA3D1LTB9nYFeWKa+1IeOCJ4un1OY1dPbQEeGy+jR27wtmKGgWQthNdAheI1+ctzdTdU6QX+SyDjTanInhNwj6L7Ye4CGswnpDctbSWgsrwejNUnX+DWasA07eHZaWVlvbFdWjT2UPOOQawSMeN7mAD/a0jAHGeusdsirXfmHoR2UGLYTLQ39ijih+QYSE9ETdAUIhztyFpuacHJ7Ewq+Miy80YeF9GSZLTYUZT32EJSKG9z4jsi78O6N9SbqaskQClLb6x0qpUw4hK4o4tzdd9HApBpHrOhqszp57KWL9Jrw493+aML2KI4dGwlP0RsmB+z8OUvv5N2JuRc+Vq9OSej03kDMorbU//B9LmuQUTNB+qHyIQV8xsp4Al7uEUCUvAoB51A7he/0zhlIwvt3thGteoz+ViuGFHpAV7oEFE2s67vI1DpurcYLiCVnB+zCYbgatdkHnU1AJxPMZ4afUBqtj3/ulEtmXKZxpkhIsSHhF+m+Spv7DtKaOSw+cemK7VDXoRJsHThZwcfce66DPpohqv4Mb8aSwMD8MDREUzDkERsR/LGk/EDPYHBtCP7qBzxMKq7GoB3xGvZ9Q11Nfg6dQALpzLBDt47nHvZ5dy7u37TUecL18q+yVL4+Na8PTiK2+5wJMigRU0gk0PyvnvBqcahapC3GJ
 JnGMaZCe
 m2TexjVtyFtwss5bm6PdqweI5V7itivI48YBmmq8uSR2JTIf64ianseEb17lnbjYh5L3K7Q+lzfD8EyrcPcz/kn7jkaEi5iHzRGEakNnMjaIJ/pfjALEpkhp6tAM2brAV8J5xDdiNqjC50Jq4sVwxIlNUPaV4bM1WEKttVJjangYB+wW+bhyXreYjfYG+8gsy7ZGX4a1JxOCvENgFrOabrTG5PgZWwnfvgK8uCggPotRfBhLzzr2CmnYud9dhiwqMrBu8gHE8wGC7nw+7GWLqJoPWijMYV4+/6NlcH+mvMFc+HD/w/KTS/Fvym94Hj/PIjM7v5te+FE3BO8R31C2RZ7f9ytan+sfAMCpVkMWg2sFGguGGzHFgK8EUdo2hrkFZtz92aMUft3uloShvvNo9m2tsr7T7Twf4DekACVUNtJHmkK0=
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
index cf5361946030..3c261b53c974 100644
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



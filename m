Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A77AE9538D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FF06B0093; Wed,  4 Feb 2026 06:43:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD0E6B0096; Wed,  4 Feb 2026 06:43:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC92E6B0098; Wed,  4 Feb 2026 06:43:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8D7E6B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:43:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B549B5042
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:56 +0000 (UTC)
X-FDA: 84406590072.30.C670F07
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29ED0A0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5CI5g3a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yGn6juiN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5CI5g3a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yGn6juiN;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWxI+OHxGuQyYB6i463OZZD63mOUwsucPy9VqgQEJHc=;
	b=TtHf59juzQdkVop14OFz9/v+DNxJPiUasJNEmr07x8byl2mD8HZP4DxIIHqXwiE1nXyTEJ
	KKHnwK+3xIrKdCHvTOSZbhASoAWhPzKVqffEskJ0tHTMo1P4yF7PUFsy9MwTLDR0yq97yD
	x2jdMom17eJRI7ciCozWWlR8uwKn86U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205434; a=rsa-sha256;
	cv=none;
	b=zp8QfFUQnTWTrPiGDc4p565ALn8YpvGGZMOxPAuItb2hGkg1K5/McELFfxSLTrRmIStDQp
	7VOvIgZStz3ml5k+vQcSKwwJVnb5mZFdDWgxZQZnZe6bU10PqKcl3c+Y1SdUGQmjy9agQr
	J/3yKYistRyeNxyl14lN34HCWyPzQ24=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5CI5g3a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yGn6juiN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5CI5g3a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yGn6juiN;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3EFF43E707;
	Wed,  4 Feb 2026 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWxI+OHxGuQyYB6i463OZZD63mOUwsucPy9VqgQEJHc=;
	b=z5CI5g3a3WtgrUIbqLhXmQBLgp4LDp4Lp5lJ8o1Hrkd+0L0atVJOnA6g1M39FBQ1kYLw3h
	J0tuuIgk4gyVPeUvtl5GuNVFMp12Esu9nrVZ4KqGNTg09f/ofzzevwVw3KUYK0Fb8mJcrx
	cnEstunKmFek27EiQxUqK7lABe6O7tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWxI+OHxGuQyYB6i463OZZD63mOUwsucPy9VqgQEJHc=;
	b=yGn6juiNzBFNJH5H2epfeY1MTGoePtBfAcB7+EHw881Bm/kw4d8p5vlpEy/XYOW0JVcmk/
	TxkiNlRlutMW/sCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWxI+OHxGuQyYB6i463OZZD63mOUwsucPy9VqgQEJHc=;
	b=z5CI5g3a3WtgrUIbqLhXmQBLgp4LDp4Lp5lJ8o1Hrkd+0L0atVJOnA6g1M39FBQ1kYLw3h
	J0tuuIgk4gyVPeUvtl5GuNVFMp12Esu9nrVZ4KqGNTg09f/ofzzevwVw3KUYK0Fb8mJcrx
	cnEstunKmFek27EiQxUqK7lABe6O7tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWxI+OHxGuQyYB6i463OZZD63mOUwsucPy9VqgQEJHc=;
	b=yGn6juiNzBFNJH5H2epfeY1MTGoePtBfAcB7+EHw881Bm/kw4d8p5vlpEy/XYOW0JVcmk/
	TxkiNlRlutMW/sCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D26DC3EA64;
	Wed,  4 Feb 2026 11:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BztMfIwg2ldawAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 04 Feb 2026 11:43:46 +0000
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
Subject: [PATCH v2 1/4] drm/gem-shmem: Return vm_fault_t from drm_gem_shmem_try_map_pmd()
Date: Wed,  4 Feb 2026 12:39:29 +0100
Message-ID: <20260204114341.195143-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204114341.195143-1-tzimmermann@suse.de>
References: <20260204114341.195143-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 29ED0A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ofs6e14heyd7aa7q4y988shugmurf74u
X-HE-Tag: 1770205433-305506
X-HE-Meta: U2FsdGVkX1/sBcIvBZO4VgqpVBZJuCNULl77VCWsRvyiob2qf0TW3hqdegtje6UJ6hygKNRXumW1mWvp/nOS9URkFumyevlak+7wEfTLo3tBTFoqMpSCk/gRmtvwIpSUY3tlcuPMy7RjFC6XmnY97trJyXUd0NgrS7merKotJQTZBvAJg33IHgWAgIJCPqPVcVm7ptOD7JSmpgxJqE9YS0l+ChmFbBO1b/I2npM9nn/BBVH09/FFEqy3uYaHrGUOTOX4A6qici0xAFGrCyHJ8wfP4ib4MuttW3a0nXZtHOP1rJGBPE3tFtRSDaC2MfcMzvvMyvW4OcTkMaSXbEjsCuDP5VC2ZtTaqs3ey+qXGrcXp7vq1EQfjmNXcgsZak+l7gA3WlwRk7HX4j8X7pmwubfCPLLMvxczd6shs4q6KJ+Z4L0l5Tx0Hw22vwWjkcmw+aaIPfXpB1SZrtJsSaho1jFamnC0uIMZ7kgi+KL5Qi/FVpGkeMxmOvqxWi3T+sjjhQy91hDWIqgddblrnTV2aPRJezFNx+J8SfIh0HdzwDFJuOeYIjTQZp0/6mbcv7HEQKvP0yMiIA7iT4KI9abowPil2ZxjgUH/gBmuVe4zU9mzOeqVgoeIa1dbcpbyNXubAGMg6tB2gLmMdPv15VKaoJvhPU0+lNJjP6Z/jFDHyYUrq2c2oH+CA4MF44Gn/4i65b3O5PRlkJiu0+1xbAKLyg3sdxfiihdg7mkid3ngEJTHEQLBiIjrlYbGHy9pn6uk5UHxaRfs+/KzZ3kGhWHri89V7dB4FUhZJo6450/nfJhxGv9T9KmzopSeuD5OmD3P/Br0M2liaVVF70RRDd7vdRcD4WbXrdodB+k2szN3FyvBkzi3KFZwi6iZ2rsaqn9+XKzRwe0unDTLVfD6IKM/79GBDnEhS6CfLLiAAXsc9/1gBRVR+7pL6PiNV9eArcDunZPFqroXStFV8pq7H1k
 BFnj4+YI
 DYQJSh06lJx8OOyF8YnLDsuedUvwOLgiHbnPlTJYrmXTU4vS75NzApmJNHWXW/qLOrPMGrZafF5yo0AsswN3/udIExfAUAxOUzxuwopvplLu04y8a1WscvVqHofShLRx+0zsPmb8GW+JpXRRt2azjPeOTLi8AtwhBga9FSa5KJXuRbpTBbLC2djS9zCO9Uhz4FV7jltqR4RoeKOwg5hibsHc9xdcbuEl/6gXGdl61rgkat4e1Ezij6s73JXRYXSYm341OCYIFIqFCSGgAAfXaGavOYCHPrbd2b2UybjVzT1lySQqQkuyWJzaKS4psWHFsJAlWcBdfMcZJGd1LDcq3x/VpAkcpZEME+pIMbnB1TZmTUSo=
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
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3871a6d92f77..e7316dc7e921 100644
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
 		goto out;
 	}
 
-	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
-		ret = VM_FAULT_NOPAGE;
+	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset]);
+	if (ret == VM_FAULT_NOPAGE)
 		goto out;
-	}
 
 	pfn = page_to_pfn(pages[page_offset]);
 	ret = vmf_insert_pfn(vma, vmf->address, pfn);
-- 
2.52.0



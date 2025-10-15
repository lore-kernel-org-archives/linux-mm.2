Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEBFCCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D2F8E0049; Wed, 15 Oct 2025 11:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DD08E0005; Wed, 15 Oct 2025 11:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05BB8E0049; Wed, 15 Oct 2025 11:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8DB68E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6963D85624
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:37 +0000 (UTC)
X-FDA: 84000735714.28.B484124
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B1ED1C001F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bbJ9H8kS;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542235; a=rsa-sha256;
	cv=none;
	b=7aEbRJFdI3MkVaZ5aQoi/AvXGS+ScNPhkhwA/TZGHzmyqpXP27gOnnEQO+iDKu0M5OCyxk
	ZukKwLvPgxtLhv+u8zw7XYSqoE777lzzjAxKLAAOEXZHhYWvJI6nyb96/Mv/pJH3Z4Hpwt
	n2OTgbOIJNiLvRrRUyfLb7Qc09tafaM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bbJ9H8kS;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sV9n0NfuVDmze2xkGqAQuXA6g1gC2wgr6kM1UibkFhE=;
	b=WU/uTqmo277YKBwxmoW2k4UxUCXvd7qeYZzG4Z8ZKAriFpPIaP6vY5MatZWAk7v6vuhUcr
	Midnb32qxT7j5T6CLTO4+Tp+ZCDxOx9ObYqQOBfYY6O9ribTkpl7UNJpmJf1LVdN/mcqic
	xJorUYFxsCNj9c30cVfYngBbtZbq5/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542233;
	bh=i4jm8rfdS6G2Q04+yn738KVCd/HzsGzB/QnSS+UslAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbJ9H8kSS1f9ZoeWKjtxRJDn57F4aP9klFG+XuHkXvOM8yZFcdQTWI5cb2BEuBEk1
	 gVlMJJSTxWdv7EeLK6TeJ7u5ga9M4xvTanGsth/ibKUIo0KZC3bn7JO+7mQYiswrYR
	 pkac4KqbcFUdapTzUYAgNaWFReRqspgUU8FjvxSyQ5H14ybi4wPK/XEgakwCCCjVM4
	 Kj3PtLfZOyhbkx1CKLrHBeYNCKoCZCdQKzmNbkwp61DBH5Ok3vzetZkd8rGCiKiE0p
	 inqYp/LBPgAunLivVYd7YRz17mgsyxLAww+B6EVZZ/EllLRF1uf5lGlsRpq8/qrnQ6
	 OtowYlUAfOltg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7DF5917E055D;
	Wed, 15 Oct 2025 17:30:32 +0200 (CEST)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v4 03/13] drm/shmem-helper: Map huge pages in fault handlers
Date: Wed, 15 Oct 2025 17:30:07 +0200
Message-ID: <20251015153018.43735-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B1ED1C001F
X-Stat-Signature: 4bpbq9u3zc8gtqbf78fctgndfqbrmkqt
X-HE-Tag: 1760542235-779610
X-HE-Meta: U2FsdGVkX1/KuVS/XR4err/csEPIWuuGCPmXP0ndEw3RWaezkEuHlqYWfxa9tVhjI+/fOTQP2W7u8aYh46zocfN1ksl07u2/nWzIsJ9SyYGrbfgVrVXBJiAsTYiSWp89b2fbxO9dHGNCwx21Nn3pYfe0oU0S/uTULIafURScw9FUqw820qriCi+dCEd9Yv78kEXZObRdehMffrUBZ8WQ4ob4A8im+DC6EuEQFCVKTN2HJ967lvKBTsXRgzy/bKR+fq5qvzQENy+8Lgkjznre2hETkXxGaL/fmxot6C+Fdh3SEy8S41/TIBWYs6/euWdqvxJhe38YA1qrsv4/DsaHs7r000dXcGzFjE1iWssclmLLj9Dreedb0NMP5HxiXol6ZZHsWaoUlUPYWaAxTYbXS10zSfyMKNhZSR3V5Qcw+Lr/qFwi8HAuEdcH1B3ws+RSqFRWPHRO5iGOOrit5agKIqLyB2VVNkolDCSpkJejz2jzSrrUJWCIfNYw9q+lWdwUIUeY00au4YWUkEO9lJLi/VGVjEc6zB/dZ//TnDUsui9W7m3ABaxu4xDk8w/dDP1uWHBHTXmI0/hVkImfwh+SUen6JhLUmIkXKfcleO8fit9bPujzCoytSLUR6KnUHoOIjDyNxZAUVccJS0seqs+nlWOS4KU1uIx9zmQZajKokH5k4KB9F4zGFkrDqC5j2I79gBRca3xJWi6FUHOZteMEITgoywC1Wmdp/HrsNUXJXl/phFqjOg9KwpMztI4N6IMnpUZRBSpeSf8wmF88UFfpYJGw0YUyyLpn6ealgZvGCyOCbBdJ6POrs0fnH4Y8wbHyhiKxjQKZ2gbY5Onfwvhnsnum1WUSAm+ubA27OLQVV8PNydEItkMPstBTTmv+/c4QP5RhnwyRKQA2grDDuoSVKT2ksVL8qtLZ6fFrR5f/1TnCxLFiKX3xKtfIaJoV5O7lqA6ZoUTkNyIvjyywbw4
 xfgbJIxg
 TTwpzy6xZ6WAt/1TWLYzpMVckWGmk0QSvTOxKRNEouKtlOiy5VU45rAdMAU4q0NhQvO65AKjkJF6cBsSmt0Jd5OK+05yQRtnmQGG0cWg3VJ0hVgdwdYznVULCt9XkJOiXFMyii0bwUAcDvqbGrQqL9J0DWDr9qKHjae7dEv5DMOakBaa+bL5HeTTCdFyMFS1hbOLSJIojwkneAbkZyld7+lMKkqK5KScT8b7FvYecZUJ+4bue/2tqIrLeqEGi8bGA8kcZoJI5xyv+5ZRddEm9uujXd3MDTe42nNYhuzrGzHNBxMUSECmJYK2YHjTzbre5OYA0uWqUfMqlPA/WrqxR0mM9OiYomF/jQLoNKCNh9qUjeQ/b46bCj6+2Nh/T87lQS4NY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check whether the starting address in the fault-around handler or the
faulty address in the fault handler is part of a huge page in order to
attempt a PMD sized PFN insertion into the VMA.

On builds with CONFIG_TRANSPARENT_HUGEPAGE enabled, if the mmap() user
address is PMD size aligned, if the GEM object is backed by shmem
buffers on mount points setting the 'huge=' option and if the shmem
backing store manages to allocate a huge folio, CPU mapping would then
benefit from significantly increased memcpy() performance. When these
conditions are met on a system with 2 MiB huge pages, an aligned copy
of 2 MiB would raise a single page fault instead of 4096.

v4:
- Implement map_pages instead of huge_fault

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 57 +++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index e151262332f9..5d11bea573fe 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -580,6 +580,26 @@ static bool drm_gem_shmem_fault_is_valid(struct drm_gem_object *obj,
 	return true;
 }
 
+static bool drm_gem_shmem_map_pmd(struct vm_fault *vmf, unsigned long addr,
+				  struct page *page)
+{
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
+
+	if (aligned &&
+	    pmd_none(*vmf->pmd) &&
+	    folio_test_pmd_mappable(page_folio(page))) {
+		pfn &= PMD_MASK >> PAGE_SHIFT;
+		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
+			return true;
+	}
+#endif
+
+	return false;
+}
+
 static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
 					  pgoff_t start_pgoff,
 					  pgoff_t end_pgoff)
@@ -587,6 +607,7 @@ static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+	struct page **pages = shmem->pages;
 	unsigned long addr, pfn;
 	vm_fault_t ret;
 
@@ -598,15 +619,22 @@ static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
 
 	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, start_pgoff))) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		/* Map a range of pages around the faulty address. */
-		do {
-			pfn = page_to_pfn(shmem->pages[start_pgoff]);
-			ret = vmf_insert_pfn(vma, addr, pfn);
-			addr += PAGE_SIZE;
-		} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);
+		goto out;
 	}
 
+	if (drm_gem_shmem_map_pmd(vmf, addr, pages[start_pgoff])) {
+		ret = VM_FAULT_NOPAGE;
+		goto out;
+	}
+
+	/* Map a range of pages around the faulty address. */
+	do {
+		pfn = page_to_pfn(pages[start_pgoff]);
+		ret = vmf_insert_pfn(vma, addr, pfn);
+		addr += PAGE_SIZE;
+	} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);
+
+ out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
@@ -617,8 +645,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	struct page *page;
+	struct page **pages = shmem->pages;
 	pgoff_t page_offset;
+	unsigned long pfn;
 	vm_fault_t ret;
 
 	/* Offset to faulty address in the VMA (without the fake offset). */
@@ -628,12 +657,18 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 
 	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, page_offset))) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		page = shmem->pages[page_offset];
+		goto out;
+	}
 
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
+		ret = VM_FAULT_NOPAGE;
+		goto out;
 	}
 
+	pfn = page_to_pfn(pages[page_offset]);
+	ret = vmf_insert_pfn(vma, vmf->address, pfn);
+
+ out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6811ACCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78F68E001D; Tue, 21 Oct 2025 07:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB258E001A; Tue, 21 Oct 2025 07:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4C18E001D; Tue, 21 Oct 2025 07:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90B1B8E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68A0B14044B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:02 +0000 (UTC)
X-FDA: 84021904764.18.5157FB5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A4DF40005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JBo247+a;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbGXN+XvXK59i6+9r/GWbEN4hobbX1VE3B1hz8y3AXc=;
	b=W93l5dV7EqyNwgrC33ve2k4ouO0+qDc05ab1WrBliFhTX+x8b3hdeXhTRYUGMHyWZ/klH3
	+DT9IR+ooBm1kRy3j39GIFFVykTuq1GdLEQyf301nuJbtzo+TxEMozZfF0dtgdgNpRjF5u
	eeIbWOYWDrlvsfeQrVkrtXTZMFU8Pa4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JBo247+a;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046260; a=rsa-sha256;
	cv=none;
	b=jH4nvlSYwnV5nkTgZyBnq5w+k0wfInnl23Wfs0oNXoRMTJGFsB074RN5gqUzfZRp/uOkJk
	L000bGRAcjmrA7JJj0xuc5pTyzYiBZqHJyEVisJj/cDkwXz8Wd5bFjdK3eidaRZln/f+38
	wKu25rM+m1Zs44sCjMp9bccah2LWu5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046258;
	bh=b5DjKy8Ku5W6YjxLJ5sbdp7mTOI5CNz17N4tCTUcgu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBo247+aL1JX25fByWt1HEwt3SEbx1YeMbAdQ0IqQ67eXRvH9z9JYIOkfGwTd+U8l
	 QiIDDrF74o723OS5FwS7yv15E72pHMPEq4cdEVkVsxqkLq4zTH/K0PFuHLNWwb0i6r
	 jwrMmgi5KWer3/K585iB6n3sFieDrCdYYINNW7Qkaz9F4AXfUL1reEx00L+3Vu8kT7
	 hzKIdP4jN24BBm25ssnHeSV9uVYyn33s/mYOtZgxkhLnoFjzu65AHsB25SIlYwL3FX
	 g9jSs0j2u6AsE/oI/z4fSiiKG06CTZQtgtO78ervT37fjs3alX+3CkWciZc4HxbHWA
	 mTb0hr/n2bIvQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BFFB917E1407;
	Tue, 21 Oct 2025 13:30:57 +0200 (CEST)
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
Subject: [PATCH v5 03/12] drm/shmem-helper: Map huge pages in fault handlers
Date: Tue, 21 Oct 2025 13:30:40 +0200
Message-ID: <20251021113049.17242-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gkqq1duf39rq5f58u685wzgqscx16cyr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A4DF40005
X-HE-Tag: 1761046260-778467
X-HE-Meta: U2FsdGVkX1/YhEHIpbbTiezuixsQrEyjoWjfzPWb94+TGtrAM6tuMgdIgzo5jHMT/sgdnF+U69UEINpfkSudZ3ib8yHSyWqXjM3mflLSUuSpyqSGqUgZL/290GrnynhZWLpk+QbkiCsRXZsI6BXIiNJQjcf18YFhL5Nnys4WLD2YATWAWCyOVPUvgYvDYuc62op0kj3dTj7eaHtlXmvFuDzJqaUyB3tmwpYgprGtwlglV1szv1rXpcubUEMbhHX2fhGlpW8nNaITIEJqcHDoOP5yma39NB55DKZpYjScqNPfW+JOErKdGRlhLIUFGlSLmoPT7Ok9dOO70CzskvvO42ucJokutT5fUh3CUKcSO7tqF2VmIuLMc7oGpuDoceNxFziHIcwlbMY2lH8U9iiolZmwQha6mfAkivq2fXFgeWqDF+gdDixW6GuOHeeGphaD6Hw5vWMEBozFxomVDkHasrFbffdmjZl/+m9h8/iP76UwZJALgsOxXcQoeALnjLE2/Fu5n8GQJu5blRWtmixWQyk2SwsrvZzOn1KVcateW87fB1gL+5iOtRS6D0g3iUCQOjfoKn0GyxtAkUv51+8TTvmwpzaLfRxXFSD4sBWXSJ6eqVbPygMNBQlS2Fbox6fE5ergc19MXsPGji3SZ/uyRuZLKEkLbuKL/fq7oAO7G1wSfDeWvcniQm4+oGMh11NQZEaRzz+qrPZJ3D4/Gz9RZJygzXxoXoI8l+QG+VW+/TT/MMZxZPFv9QbhbVwikyB/9qioO17lco/GXtuq6zzLsGaGGWG7kwWn9O3ujWlPHI6xS+hPtcryfFEYGk1BWVwZT2MwJsg07Drn0ARyQi19RMf99I0AI4m2OeaGpwXtfWB8sYJg/VRPJV6XYv6leSQk6dnkMwRBwxY/2q1R4uJUz4siV4a4nE0emWHIpPSFVim/cfcsbL8oaAc6NhLBXKbP/TKMNPeeDGCrds8G3jg
 DprgW/Hi
 rANTXxwHTWls39xqi6Z3VYwblUjMkYxbbb7p/iSiQ9imjAwVTHOmTe6KZzdAjWOdvNms8ePHhpDwEKo0BQZepdWnX3vj3/F/Mvggb9jyBM6SNonrQGd1IC/GQ1F0pRROYjKci3tUg2fsm2eqe75z34GufwcJ4QsN7gCSnJCk4LNxYjrjHfuK04STHXEunmIA+SinXE5ga0x2CqVZH2xYL6appiqolQpQLvfQ95FUohRzjxL3Obl6QWIlBPyydxn0BC6Nu5as8oYf1WVkCtKTRuyCH7tECVbHPcevQNI/1e8ww/41PBw+4uahuDDnVbDh49AtPesp+GRf+VG0lFbFrnub74WSmSKiBkmangu9r77B+1qF7waj/k8o/HcQA99DNDN+K
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
buffers on mountpoints setting the 'huge=' option and if the shmem
backing store manages to allocate a huge folio, CPU mapping would then
benefit from significantly increased memcpy() performance. When these
conditions are met on a system with 2 MiB huge pages, an aligned copy
of 2 MiB would raise a single page fault instead of 4096.

v4:
- implement map_pages instead of huge_fault

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 2a9fbc9c3712..b7238448d4f9 100644
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
@@ -606,6 +626,11 @@ static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
 		goto out;
 	}
 
+	if (drm_gem_shmem_map_pmd(vmf, addr, pages[start_pgoff])) {
+		ret = VM_FAULT_NOPAGE;
+		goto out;
+	}
+
 	/* Map a range of pages around the faulty address. */
 	do {
 		pfn = page_to_pfn(pages[start_pgoff]);
@@ -639,6 +664,11 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 		goto out;
 	}
 
+	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
+		ret = VM_FAULT_NOPAGE;
+		goto out;
+	}
+
 	pfn = page_to_pfn(pages[page_offset]);
 	ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
-- 
2.47.3



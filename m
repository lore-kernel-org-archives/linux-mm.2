Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB4DCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F538E0012; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE66C8E0002; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFB88E0012; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC40E8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64E3253BE3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:57 +0000 (UTC)
X-FDA: 84094926594.14.F0D2B92
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93908A0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OxCbqYd+;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784875; a=rsa-sha256;
	cv=none;
	b=w8AwQwe1eUyCW/YSep0SXmBM6HAcNhoAJ36+rMGNX+L+IdtpD8xLhvcNPZER9LFQ8TH386
	gMI059gMCUPVfjq+hSzjW+O6R/fU42XAHjHUwdmj1hoMfALZaz2AbUF5EH+yuMkjuC6LGn
	9npJ0EdaIeAKrEVbnyXwkTYcr4fb8a0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OxCbqYd+;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62D/XnEn4jQ4Rczzih2IdSvbf7Cdsd6AxgytI1+Qqy8=;
	b=G/4YlNzG+4APK1SByPiyyF7wSmquDFK4wp4BYvp/AQI78l3x3tOBNMTGeGiubADpgylK7d
	1jDi869Vx2+iPYrNwHejSVyYz+pYv63RxyY1UyjAjd5C16gz7CurwkW/2t3WDdQ7bzHdrh
	x/V0b0WaHWEeeWv0KSdTYfT3B07D/MM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784873;
	bh=PO8gWy+x68NFPFgtgxVVBpssyG+zZ/+aShO0x1+KKAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxCbqYd+X4Xei4wP5jPblEpPZjh7Yge5V8c/orz2hpookmHm+vCpV2VaFCodPXrfQ
	 NBiirtgbRhXTKlROfcrDoG/0mDd+LC83UP1iP2IzC/NxBJWlMPS5mCjoXSQSBzvG7r
	 PH4qlXtX9L7lh52RhZzATj1RetnwlB8+wCoTKFyQZ0dJ0WzP/vLDqm8DtV+t5CtTNa
	 dSZsdsz79UMAuVGH+xsWXDNXULXwQr7EMso16moe49fvQkbVP4CclRgJH+RzKpBvnF
	 1SPn5YMs2t4sghp1jWtLvIBKV5RfuIlM3Nm7ImQG8kBUzJJEOl6rsWDB6kqIVxdto1
	 MkdHCSXPvxAqw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6181E17E12C4;
	Mon, 10 Nov 2025 15:27:52 +0100 (CET)
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
Subject: [PATCH v6 02/11] drm/shmem-helper: Map huge pages in fault handler
Date: Mon, 10 Nov 2025 15:27:37 +0100
Message-ID: <20251110142746.3490-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93908A0003
X-Stat-Signature: 4uwg7kgmc45d41ua5yehyq3uh331x4or
X-HE-Tag: 1762784875-514836
X-HE-Meta: U2FsdGVkX1/7mhzUk2rjxXYVSNeYxAZXD1LNC6n5bvIUm3dpvUDg5H/2zCM5fkrucWGrS2WoQhA6l1yiET1z44EXbZUo4WZ/QJ+jysirXNCUgalj4GXH+7QOrrVsFdUrrwQ5Xg4UcYqtwni0TZ/sQKhEuW2YVWI4LklvKeSip0ngYLaicxgJBsfgj21js213LJ5V4E6ONar0AmTT+qBEZsNlxZVYmn5PTPOSTZNE/cJAXZUFjJ3DC72l0KxkUnGAKbZvMye7NFMdvtvdDNhFoClYs+oHc6JslTGunQ+3OQyO2S494D+KnuWPBVdl9S8BwP9GWENpbQznjaAeuqeNA4YrQMGvttPAoDwE06CUgq294S70TMTOBByb9KU5Ln0xhlgmaTsto0ypzb48cPCnyMD6V21tAY4O1KueBcDiyimLIgAvL+3Uf1TK1qV3JT7wt41KnwusSlhkppE7s6NjBivFAvpPXAksGE0pRCoFfm3zlJfyBXdOvDTYAIWTyx4a9B06eFllKqv3yijwPzAS1lbPB2dKdYufdggcjMesOldQ73Wgi9eguPRBaNyvl5p28FW4HUmL/pdUj5kKTHdXlomkzh0+mxBQIk/Qqlytjco2WKrHB3zoqqR0ZtMV6JCx2cI3LPfl/7D7tUbilGPCZo869IMO3LYhyM6ys5bMRAprlEsgQ6UGANXlUVqyv8d/GKj7NRIar8HkJg/Yf1u40wey3zSgDIywFeurBRS61O8Ajk4o+GH8F74XmLZbCZfmInS7hsBBKinwEsaYH5KCrbI+ZYZ3j8xT/Msy3SHRoqiMmCAcf6qxXX8QQ4RaaaDy+Pai5ZA09mmtTTGRUfyNZoYNFbMD7q0RxC1IbsAtyUDOtBtTPkI1oKpQoArwzxP37OnxSn7f9Tx5WfbXCmVzVqUvJDJ2KiwIeITdGCmY7zfgzFdOpa0jRfvWA5gnK3n5OTW1hDiRV5nzvLG8ZQ/
 bcerQeh1
 15Hx3WaPq3uFQzb0Fy/4d6+pNSAUr3WRW+TypcTQLr1P3fG1ODSqBQOUrnA90hTNv6opV8cwrXGCzYu5gxw4mw/uXKe0pmUT/0Cdj6yOdLQjiMlwn80JnkKeItfssGroz3LLwA+i1GiIm22T9sWQXEbpWHDKWdlB/mgIrqv5U2+3ExsqX8OjXen7+v7lFBcqbCuVJhvuzbeyvkHjz0vNrkFpx6YI3CUuqwL00Rxcv77TWz9IRNIDKM3Ab5Wwl2vBkjhLEABkD6jwmSDL6k1ju/Rfu24sWjUpnvOtKyPftPhJfSVkaTp25DKkJHStiC1pJanvxH62vr4YmqFbWsnrDnHVzXfPab4l++ZPEITVl6c4AKaqhBYn7SDO5ixTLWXjf/pMhayMSgl4M3Ak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attempt a PMD sized PFN insertion into the VMA if the faulty address
of the fault handler is part of a huge page.

On builds with CONFIG_TRANSPARENT_HUGEPAGE enabled, if the mmap() user
address is PMD size aligned, if the GEM object is backed by shmem
buffers on mountpoints setting the 'huge=' option and if the shmem
backing store manages to allocate a huge folio, CPU mapping would then
benefit from significantly increased memcpy() performance. When these
conditions are met on a system with 2 MiB huge pages, an aligned copy
of 2 MiB would raise a single page fault instead of 4096.

v4:
- implement map_pages instead of huge_fault

v6:
- get rid of map_pages handler for now (keep it for another series
  along with arm64 contpte support)

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 55 +++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index be89be1c804c..81f4ac7cb8f6 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,31 +567,68 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
+static bool drm_gem_shmem_fault_is_valid(struct drm_gem_object *obj,
+					 pgoff_t pgoff)
+{
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+
+	if (drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
+	    pgoff >= (obj->size >> PAGE_SHIFT) ||
+	    shmem->madv < 0)
+		return false;
+
+	return true;
+}
+
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
 static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	loff_t num_pages = obj->size >> PAGE_SHIFT;
-	vm_fault_t ret;
-	struct page *page;
+	struct page **pages = shmem->pages;
 	pgoff_t page_offset;
+	unsigned long pfn;
+	vm_fault_t ret;
 
 	/* Offset to faulty address in the VMA (without the fake offset). */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-	if (page_offset >= num_pages ||
-	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
-	    shmem->madv < 0) {
+	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, page_offset))) {
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



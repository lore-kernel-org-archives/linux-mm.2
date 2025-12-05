Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64552D339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03866B01F1; Fri,  5 Dec 2025 13:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DE46B01F2; Fri,  5 Dec 2025 13:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C416B01F3; Fri,  5 Dec 2025 13:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88DD36B01F1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D28612D31
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:41 +0000 (UTC)
X-FDA: 84186238122.07.7B1D2C4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82F921C000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=l1OJITzD;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958959; a=rsa-sha256;
	cv=none;
	b=LShm29hVsENmc39IoGflnubOMmWszbehTxXCv6qg2rbxLIHSv1kgNXsfD3ZwvdbLA1iZ5y
	bK0ZT7k2HPOsYK14t+yKeH3SBFE0tXu7QR39RqrFvaYrCG7pDYu6ZWPMSL+Bpvr22t5+R+
	rQ70JST0WXIoLbcYFI6hWYdmDI/Mdcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwtuZRR14MSF73UCHadmv/P6C1lGn/xb0tBTBvgAB/s=;
	b=gcUwpEnJzAcyMgrzLVGygiKkG8IqCVo7JGirlJoJaC4hHVne37kdrDNE273b8PG7dzBQfj
	CDy/mKufC5eFjZ05YIzwwBxi+24Iyxjg/+4azILHSZ9IdN5arWY6ISrTdHhBRaxz7fugLN
	/VHjIOSVObulYhNzb4ineEsQpWt3o9w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=l1OJITzD;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958956;
	bh=Et6YpaCJQxTZg9u5ElaUSynxt3OiFubIAZT3m0KdhxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1OJITzDddBfCtq7KhUQ2GPf+0RMahMUnqBaHI+5of0gS/3lgAIhIionM2YRjlUqm
	 eJ/k+tPUed/5sfbdYwTyLeB8VsQhVka5xKk5v6HG/QMiqZIn1IdN3nPQxLTyBn1wyj
	 o9/NRa4O6mleisf8GxPFdD5IonXIX8occXrh0KRvWt4sOT4lJlWfRjgiHEGYtQKp90
	 rojegf1TyKZ8X3q/jjck9IJsQV7i8xOZ2wO4VTbfaU38dKaaP+io6teuC40KeUnSv+
	 3hnS7oE5546WqMCpirjsX2qyaSjluzBtZ6JwZdQRuXpTRWUptWBOFsUsNR1Ma2wL6U
	 ajjq10skkT8fA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1668E17E12D5;
	Fri,  5 Dec 2025 19:22:36 +0100 (CET)
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
Subject: [PATCH v13 02/10] drm/shmem-helper: Map huge pages in fault handler
Date: Fri,  5 Dec 2025 19:22:23 +0100
Message-ID: <20251205182231.194072-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82F921C000D
X-Stat-Signature: dda6kfqp1ffsosconf48cy65uxo7zzeo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764958959-215360
X-HE-Meta: U2FsdGVkX1+7da07J/kQpMJsmfkzveJvputsKX2bTls7FP+l+m4+xqL5fur5crvwFKtMVsgj6GElDyBT4vYP35ICUEwwflmTTFS9dAtrQvvOmuLnS6uHOel0VDW2PSA7bGDgHFcJaqzfNiJ9Gyk0cwC+w0SmAOu84GWPOizJRjQO9hBQAFGUS0j2b4ydviHhaeY18esAWV+8ik6B+4HL2TQk7txXFL6pGYkAlMtpGUbxWGn2lAHiAdfolZfTKKoEB4Ztke4NjVME5K4wLZ/4ibg+2esJzgdNkpmYh+v12e9aQkIm6YRniOGlkZAKTCqQGsJp24VGNHLpTjB1cIqPcLJJbQ/Jg8SYbnOHooDJkmM6LvvdrY8gE2I1XGUZET4QI6MXuFJUAjmymdlhoF2Q2gLkm2RgtMilc0sOF0scumI9d5zWEPvcX9zx/akkd34THd2p9FrLjZiVcTlKhTt3tT7SOjc/xwUEu9SkKenC5vz1ZypozeuagIEcnStBlvap76jryYaIQVWLmpaaG+EZroQpsgkqa4PrBTt8kYyMN8UcA9CSvzVOUMJCpt/Qv9R2sgTlYLWnKDW599zKHb82EEtj4K2ngIKV2flNjKgbUJ6AOK0nWkmMazmxTsN6Ul9Dmv+MhXWlQ8UFGycYM4x5H1k9pJYeCJ6xOsKP3C9iOBPpmpBVlPwCpNgOzMZTc2iVSBcMNYzhKeqxuq2keNrm9RLvC39U7nyhS/jWO37NdW+n168Mco5ebY6SyayIQXFLJmDX+z94ur+jvqdt1j4MnawtJiMjfmBVrxwutI83wrvV/vYH3M0Qm1wZEQf1Pj4ZMK1ptAuUUOztIRmz1QOHPGLns79vLkvk8sgDu1IGux91K4oHAfjzKyt+AuDlItn8UhoeWkdNlFgJTyH3FEoc+sx6k2WmLd4gEr8/CJEeKJ/js6PYwzQVgVoyzxWeGwJWZCih88ZznXOZL1uw5cw
 uvP1vYAa
 /e1nwlS/BCi+V6ODaLy9qmAEhtUhtrJBvamI+a9ZYKWa0qqUtd/XB2SJjtHERzfWKX0AKZ7YS8BY5srENhXt1Da/qKq6LL1QVy8lJxsWZfGNjS8bxZ8g0s0OGTKF71dxRFHGjqox6dTepS9NCQPO9+ZAMjYa8HUd3FgEEOeEikDaaneRspGjMOK622TfZh1a68Ll6w7+pDeL0hXqc/rwL5qCkze380i04pYe4kL8c04HjlkyU+YIkJyo9smKZ2EA1rkNngNNVQ0GjwRjDhykh0+aNgmiX1joS0RRaagZB+myD354mCW9eZUxFixfxaLaVDdOZhmi/oKQaeUVa3ge86s9gbp2h8MfqGwBNkg3d+n9LF52gcWWgVq7/cIvljU5q0F42tjLdOvtrHcdypM5D5xdIi/ONY6wEYYHjvc+p+aYXiH6NkRhS4X5qfnoaCaWMCanTwHx30yEcibx7WynmonDHnrI9VvXA/aNwb6lcfvnt3Ug7Ozy/3hF6eddcq+aaDS4F
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

v11:
- remove page fault validity check helper
- rename drm_gem_shmem_map_pmd() to drm_gem_shmem_try_map_pmd()
- add Boris R-b

v12:
- move up ret var decl in fault handler to minimize diff

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 35 +++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index e47ab3ebb5c2..e67216cbb469 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,6 +567,26 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
+static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
+				      struct page *page)
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
@@ -574,8 +594,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
 	vm_fault_t ret;
-	struct page *page;
+	struct page **pages = shmem->pages;
 	pgoff_t page_offset;
+	unsigned long pfn;
 
 	/* Offset to faulty address in the VMA. */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
@@ -586,12 +607,18 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
 	    shmem->madv < 0) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		page = shmem->pages[page_offset];
+		goto out;
+	}
 
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
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



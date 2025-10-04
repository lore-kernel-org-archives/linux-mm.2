Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8A3CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888DF8E0014; Sat,  4 Oct 2025 05:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860008E000B; Sat,  4 Oct 2025 05:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D2E8E0014; Sat,  4 Oct 2025 05:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5CF8E000B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:41:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0025787A8C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:41:07 +0000 (UTC)
X-FDA: 83959938216.08.044CC6A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1F03CA0009
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:41:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BKGLKEfc;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rme2tbC8PPzM0NR5zkfPWY391ZJqi2NXB6uGC60CwjI=;
	b=68jpBV2CQ2puBsJLGuxeG8QBhkI5T8b8c15IiEUdll+eK9UjiOmBf1jXfoXhIB/gSPq7OM
	OaMfkw+mXeaRLxvRUM1JNc1SmSayCgREXGvcBPfDa0pmnIWQ/G5Ckf0CAnAp7C5aD9jEuY
	xHGrPPg3urZ0Q2R3BrIEba2wf0tLsZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570866; a=rsa-sha256;
	cv=none;
	b=ZoP9WzYmOj4CqqVJglLI0p71JnsKBg9DfSL5z2aWma0uOlg4q/8WX2D2MqPzu/mmqfxGdm
	By6TyltxwHDk79M7fiZA5gukxvNZRGtQFohYM5BVkvP4blnpQzxSc6BsFy/BZbO2zzBleb
	zniHHefEflT1S4DI80IVnJTtAKgvRoI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BKGLKEfc;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570261;
	bh=oHlg+HHZ07jVp8oeT+nYSiSbJP/e2FkVTYagFoTUkDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKGLKEfcHJNZ+yGu1I0N7U6Owv318R8F1qC+6XrCbc5IyG8d7z+wooJU1ULUB+Vjx
	 QWtAFrKmLhOhx0+pYau0H0q7ZYtnWBAxykiTVJjJWpd4J7fI2o/0YHixzIJY0TbQCB
	 Eto6lS7tb8g4vlG0Dqt3ngxVwHp0uWoPgl1BuLjtb1FWHBnoKluDS3UB2VmtsPKzmj
	 yl+6ogpx+7N1FYPmxjMlZV5oH2+MEi1kXknLyDPdHWlF8NeEKjptHyQ3UYr7omPMRP
	 c3accRYVOOiNbIcnGWICfN/k532H6uRqliHmoibXLrsLF9+T0ZVN2mKKd9qA4isC+5
	 wbzMlkTjdBWSg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DB01617E0A2B;
	Sat,  4 Oct 2025 11:31:00 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v3 01/10] drm/shmem-helper: Add huge page fault handler
Date: Sat,  4 Oct 2025 11:30:44 +0200
Message-ID: <20251004093054.21388-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1F03CA0009
X-Stat-Signature: jcocsepcqpzez83ispkwokidibofxbuc
X-Rspam-User: 
X-HE-Tag: 1759570865-266238
X-HE-Meta: U2FsdGVkX18nDG3J08Ob9/WK0fS0q2A+Y9XGKWlpupFA5FeVO0dtc1Xia78p2SpDz7RTnzkYx8llbRXoHwvdyyFk4vho7iuhBUGCYeVkMLagrJuzTCoIwmN15V1p2aCbd+CKfcZ/f0tYBer0SOZJwebz8i6bFFrO2vsX6RxWEx8e/5MW7wGgjtEqF7HGXFhcoHS/UX40DQr6l48kCV2TgwSltu7vvaRlZWsz3X3SwpHVhX8hdTZc5o5Wm5N6lpPTsmf7bHRJzUj4Ar3CUsnFqZQWqLcBsqlHp0iMNRQ3VG7leAuxhC07nSgXxs/T7U2YMZyr4grZ6UaAk0XkpB4QSuA4DT612PUdCrc5FQToRdAnJAvoug0bzmIyCyfGXlk1rXuYLv5FJoW5KE96fb96j4eI6LYMmDTGq12GuUL0euqhZVKhRUmVRkMRVxZPBxpifsi581sFSH5q+t/JcXfQjt3IypLDtMIFkUIrwNLDOKRum8Kmib7fIfkzGLE5Uqpx1/3KUDdRnmUM0YaQ12niucTPSgoIwSQhtKsR4flrnXh8yKjX0G0jXiGvF8lH5VRxzDxtsxITnBWAdpL72iTUFDgqSNxNCEW+y8j0WwUaZmkYaMKo3AVPmSFcgAu7MAkfcs7IRQwhW+x1sRJRq+4qrrPgDW43baZ/f32h970hlJKa3suuQpLVDV8h4OKzySdlY7ksaLW1MEeP0OtrZmumvToaaat3ZHXo9NUWZFxY4KP7/pwCM6+VBO5XrsgmMaQ6jWSYRzG5Eqo8aLq8AojJtqr/SxgWrX3ByL6RUDSTXWiXKyzVE1nmpv2xz8DobeyUKPsZMJG4iNx6P7Dy1yhK0IvEmzAnlBok+C8f1oReKvh8Ij1D91D7XaazfSSsYc9VhCjYE1yoNoF1pzM+ZrSZQfHVzHa+2p/gxdxQe3M5VpsscYKcbspcfBB5gAUcWI70lFqtM1yS+pOJ+ORkKdM
 B/p5rWvQ
 frJU9ABH7/YYe/mDyRNcKlKRbTzYw9TKAwty68h3nnW2ITTLTv7lhsluepjlqmrg1DKXvz3gWZBhLdu1hkKQh24ccyknCMvDDPumNfMgDjvs5AWAJIM2EIyZyKMT5GsXeNs/anZuXpB/UpYkBXMHvN+vloVQFdj7sW7YYzDSWj2TW9OKtk+nU7pOdsGtYTMSPUZPu3oHU6mtrrtkYRD/KQnseeyJYLp4N/7a9O32SX31DNxckDSoGvLBzgD4GciobA/jS5v0gNcz8urggYGq+cGSsnp6Ww5tAxbfDHlet+ilPTGnvt3HlerSqMnthCVziUOpp+KwFZ86jEyhC+gua3ovwYEw/D7wAW+tDuOIKD9MMrhFkGakVUdLux9iTjnUdQoPR1WJMGIrJTVeP/OCKFwPUmEtDf/pnTM59+7kUYJwXJSW0e5f2bQMCWT1aMggbZUJNHzjHEVD9qQlV5BAJ3R++Qnx0kA6cbXrt5qJYhUl3Mqo0WLerzD3d5Sqq700SBcQc74qX8BEKPKHtfGWEf1L2ZjhHZBvurruY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This gives the mm subsystem the ability to propose the insertion of
PUD or PMD-sized mappings for the faulting addresses.

On builds with CONFIG_TRANSPARENT_HUGEPAGE enabled, if the mmap() user
address is aligned to a huge page size, if the GEM object is backed by
shmem buffers on mount points setting the 'huge=' option and if the
shmem backing store manages to allocate a huge folio, the CPU mapping
will then benefit from significantly increased memcpy() performance.
When these conditions are met on a system with 2 MiB huge pages, an
aligned copy of 2 MiB would raise a single page fault instead of 4096.

v2:
- set ret to VM_FAULT_FALLBACK in default switch statement
- ifdef out paddr declaration

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509241315.8jjCyL7U-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202509241654.qJk1H5kr-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202509241920.PtSEkfd4-lkp@intel.com/
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 56 ++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 50594cf8e17c..22c4b09e10a3 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -573,7 +573,8 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
-static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
+static vm_fault_t drm_gem_shmem_huge_fault(struct vm_fault *vmf,
+					   unsigned int order)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
@@ -582,6 +583,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 	struct page *page;
 	pgoff_t page_offset;
+	unsigned long pfn;
+#if defined(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) || defined(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP)
+	unsigned long paddr;
+#endif
 
 	/* We don't use vmf->pgoff since that has the fake offset */
 	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
@@ -592,17 +597,57 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
 	    shmem->madv < 0) {
 		ret = VM_FAULT_SIGBUS;
-	} else {
-		page = shmem->pages[page_offset];
+		goto out;
+	}
 
-		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
+	page = shmem->pages[page_offset];
+	pfn = page_to_pfn(page);
+
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vma, vmf->address, pfn);
+		break;
+
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		paddr = pfn << PAGE_SHIFT;
+		if (((vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK)) &&
+		    (folio_order(page_folio(page)) == PMD_ORDER))
+			ret = vmf_insert_pfn_pmd(
+				    vmf, pfn & (PMD_MASK >> PAGE_SHIFT), false);
+		else
+			ret = VM_FAULT_FALLBACK;
+		break;
+#endif
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		paddr = pfn << PAGE_SHIFT;
+		if (((vmf->address & ~PUD_MASK) == (paddr & ~PUD_MASK)) &&
+		    (folio_order(page_folio(page)) == PUD_ORDER))
+			ret = vmf_insert_pfn_pud(
+				    vmf, pfn & (PUD_MASK >> PAGE_SHIFT), false);
+		else
+			ret = VM_FAULT_FALLBACK;
+		break;
+#endif
+
+	default:
+		ret = VM_FAULT_FALLBACK;
+		break;
 	}
 
+ out:
 	dma_resv_unlock(shmem->base.resv);
 
 	return ret;
 }
 
+static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
+{
+	return drm_gem_shmem_huge_fault(vmf, 0);
+}
+
 static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
@@ -639,6 +684,9 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 
 const struct vm_operations_struct drm_gem_shmem_vm_ops = {
 	.fault = drm_gem_shmem_fault,
+#if defined(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) || defined(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP)
+	.huge_fault = drm_gem_shmem_huge_fault,
+#endif
 	.open = drm_gem_shmem_vm_open,
 	.close = drm_gem_shmem_vm_close,
 };
-- 
2.47.3



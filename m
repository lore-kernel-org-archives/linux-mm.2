Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6EDCCA46F
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF788E0014; Mon, 29 Sep 2025 16:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F2B8E0002; Mon, 29 Sep 2025 16:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E3D8E0014; Mon, 29 Sep 2025 16:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91B0E8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11F43592B0
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:42 +0000 (UTC)
X-FDA: 83943365604.06.5989A9A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3F98540007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=HqXNU8qB;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sS6QgaY3OkovNX+QYMBIOudJJ/yYYmFUflWCFg43T4=;
	b=7ODX57OCgX58cUcnLLwRbIzBsMutBMGaOz4fczCC3b00Ov62SzxzFu/vKbFYGTUTOnlCBH
	/CxStRE5tl2hy01m5AGfxAnbmGj/Qaf0BvMK1Zw4Q4O1IgieNB2t85FdDwc/ECeW8d3a1U
	ypNVSfUr03ihhf8Sz0G0jYpRCyqlifU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=HqXNU8qB;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176280; a=rsa-sha256;
	cv=none;
	b=ITsU+5Hw6+Ul/q02PV3Zsj6snqXPWMUgeQLCeCVWRHuIG5S/CyEG0vHmFMBXDAmMn8xkiB
	pGzf8/k6XV7v1gAN2wbJQXTBB+/Tvdgs+H5s291erprcDNzx6of185vlE8ZTh0BpYI68gr
	Q00pa7MnSad8Q3GFc4uMOStUw21SZhI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176277;
	bh=zMJh3TcnbKaM5I5mBMtrtGSYfeXLiD7daPO84ZxJf8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqXNU8qBxp/P4cl8VHPxMF9qVf0ye+FXHG+PQWej38gDvvYWv16Jp9L/yW0kpjXgt
	 s7XiOvEFal9TD3wnWg3eCwJxxb8YEuT93dYd+FEfnFhp2YZjpGbqe76I5FstyN0Z2y
	 c7h+jqIRhyLc8SSYCLhg6M9dPguxQcXzF2FWAT8YUeLDrMavo8hFyzSW+WkQKsuw1Q
	 bTZr4gc90xhlpGpF3nl7E+tKozFQrxJkoauhrZz7GnU5BZPzAqz3PlDjRtoXBF8K5K
	 fXycVmtE+4SKOTyDO0wVp6ZCFnNIqej9SM+YhFXABQyTJVeudq6pB46SnDuawUaD/z
	 l5ipz6pm3UWIA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 01B0417E0AC3;
	Mon, 29 Sep 2025 22:04:36 +0200 (CEST)
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
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH 1/8] drm/shmem-helper: Add huge page fault handler
Date: Mon, 29 Sep 2025 22:03:09 +0200
Message-ID: <20250929200316.18417-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F98540007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fyoqe88b9ypp41re1facb73oc1a6u85x
X-HE-Tag: 1759176280-309232
X-HE-Meta: U2FsdGVkX18ae35hEuPHbtsXUjSvzcbQylchYjnmy9ji8iAY8TYT0ex3ACh/mvocNLhsj8G4Y88YumydY9FIA//6qoY/83omz13cCJeDmyvEs5OoRD38OAi7kHug4HaeQL5+KhQYHFXD2X0tmqiQdOBH2wxRGkNUgUSdJDA+VCKxCvW+zysCGn6EErThLHiLMriKGtRHkx2gi4uC8j/F4ejj9sgX/HjRNl01l981hS/6Q0oaUmiSVJBiSiAwWHpVHzErMLyrMRU2RFAq4NAKlbpV/8F1csj7T3SsVMsTZVzK8Hz8xebNGi/A7q8wmypbVkTTlIxFeKsvsWIi2yPA8OCw6gdUCodnwUQSPFvJgA2PzeKzOpPGZ7D9k3GI6z/+HUWIDfyaEBNAFIttvQlqJLcPmbDvTiIJ+EltKYnxEjZsr60KQj2cDbwbyI92nxghX+csvz4JYVTO7KsN4kVYes7NGc0FqoBeYFxZZVWHHX/HMGTXkRDQwh6jRerwrywJzQJCzFX5bAhOMgEETjD8CsAWCFS26yOGS4+hw4Iv4UhIbMsGFrVsJw5tHbqoCDlYxYxAL4TZzdlDtJ+S9csVGyJSplUFfS1hBuR71QA7TlWW5pEiY/1yhPyqB65UJIe7MX2AFClDZHiK3U7WVi/pRw6nkCcgcnD7YgKBMf9MPjkWvARM+hHdw15AdoY0YuAQVs+CjsyTU+x/2AmEKoSgejjjT7QBsjsBy0A9v2ri122SyneD2LkrwTQjBxoqlazX0sHLse2L+cv38o5IHOZ6eIVmZsCY+Myga6p2zIMYcXq+W/4JGToIgWNxgJBh+f0CxPBRGPZp8yvfcD7dOkM3l+OzlEiVA+cGxLYVwtFbOkoNMofkKfGEVoLykdfWVsW3hb/q8t9Ym7g95grFyTn9HRVKShuwojue5riCajcNxYW9ypOaBYp5+Fyh7nXVQaOe1A4eP1ZhJHeS4UGW4VB
 pkSgUnMI
 31FgShEk77DhIEKMSoIHlWO1gRbNqc06r2RYqjBAIUG47jy1r0EU4ktq8uCYaaXKRILglAHp1p5ok/5AIgioP1XtParZTK2Ia7R5KHwAFVXGM/pkbcriswuN3TgR/CbSm0PjxQn7JzueE7xI7gVoq7so5kMEc0qcD41/+NlYdoowsU+1tDWBHBi453kT94zuJkycRRbOybNhES152TXs9EJ4vwblJzZCispDommhD0HxAhKjNwDBbPf2jwekx5g6UsyiHHMPUNeE9TY5Eg/YW0YAKkK3P+jRH1UD0HuTCsfWMRE3+sYt6k1ymvGpLkBNWBvwx6uGcfTqcdfm5yz0UUKc+0uZSyVsESALaKT42+q23qWDvuwIjcNLdNGc4F8aCc2k9
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
- improve commit message

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
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



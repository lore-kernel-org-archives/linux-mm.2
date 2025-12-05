Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3998BD2F7C7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34576B013A; Fri,  5 Dec 2025 04:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE51D6B013B; Fri,  5 Dec 2025 04:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B863D6B013D; Fri,  5 Dec 2025 04:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AED86B013A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5925388CD7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:27 +0000 (UTC)
X-FDA: 84184851534.19.B2CE123
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95A758000F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aANrR33a;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwtuZRR14MSF73UCHadmv/P6C1lGn/xb0tBTBvgAB/s=;
	b=IX/lJHhycbSfzKjoORiM1UgXN3R4TLeLRjXnYCy0r3pagD9nMlpcwRBOC08ae2zrQO/Ft6
	w8LOmkV8datETx4hrR/aTNKjEHOwLO+8ysut4bW1kIYzEKwnG587Wi8YWO+IcnfDl506+5
	SVOkcNuDeIhYDXoQ3DH/4I9RaTQK4kI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925945; a=rsa-sha256;
	cv=none;
	b=dvvQhuByM72bZMUb1zb3kUq6/oR01IVokz16F++dP40PCWCS72v/mqD65s/p6c6NcEHTsA
	gmTufhM4xUTV3d+Bu0+WJaaAr6xnptw3BECFrTpHwhG2KD0PxbAZ8QgdTYuPRiSafR2S2A
	OZ+QGL/6nDmauCqRlNIpacwBJGtAgJQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aANrR33a;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925943;
	bh=Et6YpaCJQxTZg9u5ElaUSynxt3OiFubIAZT3m0KdhxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aANrR33auyVr8TOJC5YmLZYhtLdIK7VcQmp491Kvp/ZK6/UoddVs57enAObc8Gdkp
	 T4rnp/BNeCXXVsPyQQhMtjG84kD48hMmGtQfzcsPrZLPiOo/ovSuYGAZ1vSoklvheU
	 59+rhdHXFd971BXknXepcO/rlZ0jXEsxUZiTi6TDrp88E37SIwcJKyXASCSIvsg1Us
	 dKlZkNvYqGLqWDJdpboh5Zu7cKixFCeBRcQ4MuLQMrSsq4utpHRlKd30KcKIJMzyxS
	 +thAMAX+6VFK6dxQXd0BAaFKVDeT0pE52uzyxxkaEjr0UHCxsLCUEu3MH7OEq9cEYE
	 ztDxOSEAGKf9A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 186DA17E126B;
	Fri,  5 Dec 2025 10:12:23 +0100 (CET)
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
Subject: [PATCH v12 02/10] drm/shmem-helper: Map huge pages in fault handler
Date: Fri,  5 Dec 2025 10:12:08 +0100
Message-ID: <20251205091216.150968-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95A758000F
X-Stat-Signature: yq7zz5kyrc3bzntxt4wphw6j3u1xq7pi
X-HE-Tag: 1764925945-328885
X-HE-Meta: U2FsdGVkX18dsSF/pNW9aAB2F8vlpJLXTAHZph6xOwCeD5cQ32UlG1D3K9jd679IVgLvt/udGotCGVHXb6IX7XmgrSNBfZdwU94XhcDaTA45wMiKSij209VuYHceECW4Q5RHdVe1ewXWyS1yuzEXnYpsXkiERfQW+Bl/gVRgIIJ+FMqqSmvUyQd089hMI5zpJjjaMbr/qhQOmlROLl9Yn9shR6a8Nw07nnW0Hsckq3LV+EArpOaAE4B+fKW0Nod34oJ+Vvww78fkXTNlGidGtG5tA/7wFTdu/gQ2FuU6e4Q3ZkUNI33gWloQSN/DcffZtzVL+O7wMr2HB9fbATNCcwAGDmoeJifsAdz5exeOECKe7ty7BQpiTvxHmD7KSWID21LGvNVcJLVcCmw50AXUaXgiLTMacqiEmqffdg8rracvsJsTjdYKc+s+sIUXN+J+SPz1klBcBYF/A35pOvCGlmUSlIjaHzwZt0v4yRMgeCfC3JMKgo9ObGx2H280LG/Bc118WebPWjrG2oIdiZRUHIj/GtZxcooMDmObMXVBrlrOk4jFMl94x7PtHZi7ZL2nEWNKz9s21Fjf3VolBgrt1/KD1tqQ7VJE6Zsu5xvQUbiKgBzhDTzayFmyhmNlDdpWK/FJ0VB79nebn4YojmH3l/JdVsGzkmL64QM5ancVZonIYSNkwFsSTewW0PaWtfeBParicpw6cbYrqFAJNwuzp9oQthTiyhSxoxEX/SYW4G8wLInAT1LZEEFJXRmJbbJcxWzxML0xq/8Ve+pL+aaYv38pwkILdiipZYV44zOk9IDz+c2JEebYleTTlrDWYAwGLA9WTKecnSgtPUfIY7+MGyigcjBAvA2lAuMhiBPp+o8recceyaNZzKQcAUYJm+8n4oLjzvZPnAYFtLI2HWwBnxAcJmCs5hT1gx0g2NgekGOxkwxdKs42qHGXFEzFUWnfPbwrAU1R7HpcoTuoZD+
 N28AM5wh
 /V6/WZiRXqAHVpGCJiNVXMmSZfurzouilDGmdf5v8NKpGSYh7HjG6coNTCISXZWGYCy6hzRYn8NZbXSFEaE9hyMZU4/xVyUCJI8zrgzNqBf2SuW/JV7WFdbBleONPQDBovyQj/3AV89wyxyEDvtKvwehStXtzKGEaG8bRba8NQRZSvAefqLS0W9Uhnz9Cn1eIBhHU8rUw8tjwHaaeZ8o/RTQ/+tnxL6K3C7yuWfDPm8vXkOqnMcgDV+R2ftxOM0ugdCIkfnIJwkBhnJEAlkZBrmVfHo9OW+vTv+CPfHYf9akFI+oPi3nD+G0La0Bxu+rZL0msPKYfLGMRQObgk0qN0XMOaVskAHn9wKvHIG7W3m1OonZt8oTct00+f31HHbTs28qA
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



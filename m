Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B96FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825C28E0048; Wed, 15 Oct 2025 11:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786FF8E0005; Wed, 15 Oct 2025 11:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675888E0048; Wed, 15 Oct 2025 11:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5351B8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04102842E9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:34 +0000 (UTC)
X-FDA: 84000735630.04.E33D2D7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 201DB160019
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eHAmHCJq;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7uHwW2ihAmDdxzvL/yF4JdHCEx1vSqGpgHnwYRfjqE=;
	b=xr8gyGqu4uIbFpB4Qx+bJzvgGermRmyu9UFm/ItvRg+U2dCk0ndD0jUmwY3ENTRAbGqwZO
	uowfpjicIEirqIOlIy/dmi6F4r8wukkv93z/a+Wwq9Q0JZDJmZlHUBeXOuGE85KARC74cF
	cfljDTuoJEaRTMXYxpWF8aHRpouEDgQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eHAmHCJq;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542233; a=rsa-sha256;
	cv=none;
	b=JeUhdqBKz/DVOv67+5mlEP/klBRA+DY0NgoH0oe+MZ4ZkLok+BE629J5NZMYM1UaTCSfLr
	TSMnBJLIUZr8GVMO/53HG8d98wjCcwKAMQATwJOcf2RFB2tch7EezsN2MrcJUZRDns4X3a
	A4sHDHU61PZwYUW5652Dd4g7GTm0Qi4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542230;
	bh=KQV7Ou7tPtnCCwHJMiVJOpNVyDdq8Ql41g0y4SHmXds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHAmHCJq9CHmEpVjvgz1qigTjIVJFFK9ZhUOKlaOXjDfZD2eF49vJtX3YAl+J4qG5
	 dEOcBvyK4cfnxwjrhL2CZslgUJNpEnIhuJY67F8Ok+Kt1pUTHwIsQzThMUEY59EDLx
	 9W7FHK5G5o2bk8opmpCRQU57tGjObB4fdsOpm6EabsOEkP6r0nIrjiJcLnSuD/NmiM
	 hHVcEqg/Wy4+yOf5+6exKsv8odBVsInQoQGmsORy1pXP8E0xwImciHf65R8gewSSXy
	 n3N/G7Phsqm286vuMG05Z/YZT/xKLbzRzl8UaI/cP6lqItS/4OG6gMSgngdmNgYg+q
	 VKp6Xyv4Rq+Jw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E5BF917E00A3;
	Wed, 15 Oct 2025 17:30:29 +0200 (CEST)
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
Subject: [PATCH v4 02/13] drm/shmem-helper: Implement map_pages fault-around handler
Date: Wed, 15 Oct 2025 17:30:06 +0200
Message-ID: <20251015153018.43735-3-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bpyk7qcun3iwdgzyrkcpdfkyba4ntadc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 201DB160019
X-HE-Tag: 1760542232-254748
X-HE-Meta: U2FsdGVkX1+JjtKrmdQwuZhvdymVdCYYBS5YQ5dY4Hk2eLzbqYrfE9PiY2hY4wLoYjX4RxCV3LDqYV+HqZaEBVMDbuUsPSS5+rmJP561vZcopQwLlUjlx9CcSGz1mQW6GhSoEPYaPIn2oNsfZ0mIJfm2xGIRxN8GU74S3szEtuUXJ+UOSOX5LF3z4epTdAnZfhiNISl2QAKRbnsFxaMQfNSmw5JinNiC+3oL1CpmQE02zOGaWgvl2MJT4JvyPhu6kPdtupcyiLLkHdpJRg9xmXb90rAE7HIDBAGKqlSq/RhSfafid+dqDxk9YUyiy9Bpo2G0vPxNWMhaXCYXloME9yKqNsg4KHKIy4D0e7m+eolPxKEkETOgKnRILmeXDk0hMmLBVrn1yU0E1j1hkRs68Eiy87WpOetrnzarXM36nYMojB9xX+OZaAVdhr9PKoA8WZnoHi91Gn0ut+p+mRG09Lb7n27a4c99wceA2SBmVLNdcha0B2pSdlpEFAYddiFYOGnK9lJywKBlrlEk2un2GopWY3sc4+z9BZUUnpMXQXUK38Bh1xxVwWuX5Srwz1i+YlmEu/tAaAEpOWvBJRjsYGcKKNw4vPZWJVWPZsYuPGA8g5SLHUTfE0I+PtVhlVe2/5AhgvG52cMy+0meqE4GhS5WArHzes6m7JkmfeuXAWbA/TAMbY9yBNLS0h18kqsws65gDaUwK+GVEP4Kqz/8TbQPtzNPOpMljJKxeBOMvFlaWCjlKNUhWZzEF+ijJygMTf5EtuNQI9GwLrimhqZwoAgP+1WMZOXvWQMm7vzoABXaguIH6ABbsr70IWNhRBKEivKEdcgWu1iMkRze8U2+sPIrzyUqZ/nusvQyA3x8KYrNZCPn8i/W8+bmsrtbcTtI0jAmHROMhc22qwJVUP4kWeOU4CRuhMnWZ4mgYdzRO9vb0q7z0nr7727ZKoTCK8ilzdm3iBNTrio/0m8s3QD
 az6Aik5H
 dxf+zivPg33YbaZLo5KUKiYoA6aiVggxJz8P6llXX8vejVCjcbJ/KdCIaz7JJdw5+/WS+g+UtqkG48+3ozmv61Yy6cVmFAdEBdlwZZl/OR1uUMabp57FhmEYgc0Nbrl1y2hOqh5HNm6H3YatIe9K+QZ/dUzql9jP/mNdWzC1TKbd5s1x3O7PFUEoDDcFwjg5xidjJPIPxRnmi7z4BA7b+HfZAYixr7+ipgkwM8sjf2EiJHiwJhcPp8Oxoh1SQ+E0xxw5sWDoruuwQt+lM4bMdSomji8UWmmJbUnz8h8UwV675mpS1AsMN8XUQc6uRHLm7bTOZsixSJ798EOnFuEhtP044S0FE8FISv31pcxbIViAD5tbV3lE4ocIxAIVzD4M3w1GWhcBKZF8VJL1dBgJffaaWajSf89gAOioivFur2xisU+n6RUZL9S9qCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This gives the mm subsystem the ability to increase fault handling
performance by proposing the insertion of a range of pages around the
faulty address in a single batch.

v4:
- Implement map_pages instead of huge_fault

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 53 +++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index be89be1c804c..e151262332f9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -567,24 +567,66 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
 
-static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
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
+static vm_fault_t drm_gem_shmem_map_pages(struct vm_fault *vmf,
+					  pgoff_t start_pgoff,
+					  pgoff_t end_pgoff)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	loff_t num_pages = obj->size >> PAGE_SHIFT;
+	unsigned long addr, pfn;
 	vm_fault_t ret;
+
+	start_pgoff -= vma->vm_pgoff;
+	end_pgoff -= vma->vm_pgoff;
+	addr = vma->vm_start + (start_pgoff << PAGE_SHIFT);
+
+	dma_resv_lock(shmem->base.resv, NULL);
+
+	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, start_pgoff))) {
+		ret = VM_FAULT_SIGBUS;
+	} else {
+		/* Map a range of pages around the faulty address. */
+		do {
+			pfn = page_to_pfn(shmem->pages[start_pgoff]);
+			ret = vmf_insert_pfn(vma, addr, pfn);
+			addr += PAGE_SIZE;
+		} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);
+	}
+
+	dma_resv_unlock(shmem->base.resv);
+
+	return ret;
+}
+
+static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	struct page *page;
 	pgoff_t page_offset;
+	vm_fault_t ret;
 
 	/* Offset to faulty address in the VMA (without the fake offset). */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-	if (page_offset >= num_pages ||
-	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
-	    shmem->madv < 0) {
+	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, page_offset))) {
 		ret = VM_FAULT_SIGBUS;
 	} else {
 		page = shmem->pages[page_offset];
@@ -632,6 +674,7 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
 }
 
 const struct vm_operations_struct drm_gem_shmem_vm_ops = {
+	.map_pages = drm_gem_shmem_map_pages,
 	.fault = drm_gem_shmem_fault,
 	.open = drm_gem_shmem_vm_open,
 	.close = drm_gem_shmem_vm_close,
-- 
2.47.3



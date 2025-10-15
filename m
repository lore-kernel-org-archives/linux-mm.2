Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCB5CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07BC8E0053; Wed, 15 Oct 2025 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90A78E0005; Wed, 15 Oct 2025 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81068E0053; Wed, 15 Oct 2025 11:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8F48E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7407B118BCF
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:59 +0000 (UTC)
X-FDA: 84000736638.22.84283F2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8EE30180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MEWQfOsC;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xz5DlnDmol9NIp58SrtPuU2M1b2voL88a0mIXai4rC0=;
	b=soGwnBx7BReoSOQ6DlE5yrqxuYqnExcBmr0Io3m/iuCNQnOM6W1bAHqIvj7dylqH42Q2OY
	8xoPsn+e1hisEuD3sBE07sWxZH+FmUHK2fu7evdDTvuEfgnA8Izs8VuCp0cRE6F4MmJ5LU
	F2XYWFZ03E1vhosADJlxr31IkNuU3jo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MEWQfOsC;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542257; a=rsa-sha256;
	cv=none;
	b=TF5uJnaIhr9ef6aO9bB7G0jLEup+Weaw3YGSrFNvY75fFWUXRhERP6LI+6xuZLjQ1rPh7/
	7oWJYpD3DQ0uTHrCFz3XECOsvRjElusMj3Rij4bToBEfgkDVNM5IvxpJ1GCWMa1z4tOPz4
	FgwBPzAldLtHZ6udbXfBwkmxkBGRRtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542256;
	bh=p24aKtUnOv8fOlBIkkg8gEu+LqJuafLvKyczTp6ZjwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEWQfOsCnRe6aZZhYvFIqCiIoQf3UYeJT8GZNE11MLdXGrg7qQ99gGn0Mv1U5z26U
	 hG9wdE50d/yKpuWNzmz7/B8MOUMTpJBwb05ymIJu7pAsnJs4YPyOzkvsgCcHAftyKV
	 KsQL+eY9RSD8kFFjMdo32EzSAaD2p4TJrhgq8N55T5GDpkoNXuWBr/NEu4lalt6bKG
	 bUwPvfd+5x2LCuHthh8sS/qcuAbZvG8qFEneVQHgSmPf98TC4ZhRo/5gMwZXN2W83R
	 Yd6N+hYdGkGsufOyOah/xrsePiDYufrifamK0JwB7ria3gzFXxWObkpUFVOl72Qi8O
	 nttUt+QahpoqA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2095217E00A3;
	Wed, 15 Oct 2025 17:30:55 +0200 (CEST)
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
Subject: [PATCH v4 13/13] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Wed, 15 Oct 2025 17:30:17 +0200
Message-ID: <20251015153018.43735-14-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q9ja551o541wxgba9ejiwfrzojc773of
X-Rspamd-Queue-Id: 8EE30180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760542257-790800
X-HE-Meta: U2FsdGVkX1+aLDzqsNJCq8I4w4AwSvjXmP/2bNCbqjvl0M9eTolqy27Bs6Y2S6ju7ARzYsSqQmmJ/8bY9IaW+CVALgQniIGY8dpXAqfl9NmGLTBnGeCR2z757FF1F2gcSVTRBWan9VkJ2UMtHi3XbXqCjIOFhRs3mWslS6UoEnPloWhdm8COPI29H5QPUZPPkDHTsjhZ4xrlFDMb6hZmhKhOHe6DrL4yqFAIIu8eOYpAyS7lwrjtMZLf8ncew1Bz/X8fALvdpwoWyCBdZIXfSolFjEVmU+vCMBn6M8Juww6E521MRadjnuPoezZWdEuuutHNrwgA7Tu/Nt6dm2o25EaGX8pYnh2t5OLZk5mnNpv3mk4wvz7qPF3D3x0DRqINLEHRWtPmmlYVp524D7a7sC/CtLpJxoRXW+cY36w8k566sVMXMjDnk5skAd0FrheZwlOBiAeLD4LNkOdceZyasgNtwrn3CcrUnPjtsLa08baO8DO3qRVtMXPncSon0Z9w36UG1FkHSBQQPs9brfqeWF3Omo3pBqkek7fwVkrhcNso+PxcBM5nsLc7UT+KBv5y9GTNHVzIH5L4Q1EujeHbcc/PiVYr4Si8F89Bw8u/BEPC0fv4nbt60z0wC9T6tW2VJrU9GXekmRYUSERb/7gkZpmF38Rkj1Zuj/CU1w2UebQ8pre2OcRAH8V/G/wAda2UWQs7UOdsrap4/kwGOaydjQaSGjwmeADwhK8wB6FO66zMMylbiCbpJ46KZWDCp/6/0GAyVByiKK2Moh/9jfYtDbV/uoNZs1S9ghyjOvAM8FNkiMAWLw5oG9dt0pWyXhOVmS8S4SQHwOWrAvZ4vTRQSn7y+Eq0UrdlyzgTBz3hLXkPY7P1mJtnjQsMzQKzSiRskdC0ryHsRDQowiRTLOVID1gCHW3JSNwEAIHTeGGPOzFsPyJYtTG5dTm9OzHVmZW0uydKN07KSYVwi5jrpah
 zIE4IauV
 FmWbjqlBMWV8aN+2yawfRAEKO/6Qge5UvMms1krqwklkeO15+hiyVDu+5YlW6lVbvbvkedzCJLHYPu+Uo2FLhHt+DoE0CVsUja9diJhlLXpx3lcfp9JNCfvEPWbElGSU/kLV+td6qI2tP6PJiIo5ECULNh4BDI/Ba/bwV2SYU0DsWgsDn0ulz9vMZSs983m6YadPatsA752hIZMTziNxvm2WrJZ7dA95uKUb2/VZrjELXpnCUW3B9hOlQK+zrb0PymDoC/pJ1DCYCPLV1sgKdR9C3U60RjweIJuYAPQq0OYn1r5CqsqsJyJOy/ThUSnGzTUwDVHlBPzLGKk1jZN7usuOJXqO/Z7YJ9UQHPL+ID8nHIrMGrnJ9TdCmUXSTk9MfO4mT8cgyDkICx2FXyqoZv1qTyecwQsi83vlp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a paragraph to the GEM objects mapping section explaining how
transparent huge pages are handled by GEM.

v4:
- fix wording after huge_pages handler removal

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/gpu/drm-mm.rst | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index d55751cad67c..3d6176adc7ca 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -283,6 +283,9 @@ made up of several fields, the more interesting ones being:
 		void (*open)(struct vm_area_struct * area);
 		void (*close)(struct vm_area_struct * area);
 		vm_fault_t (*fault)(struct vm_fault *vmf);
+		vm_fault_t (*map_pages)(struct vm_fault *vmf,
+					pgoff_t start_pgoff,
+					pgoff_t end_pgoff);
 	};
 
 
@@ -290,15 +293,27 @@ The open and close operations must update the GEM object reference
 count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() helper
 functions directly as open and close handlers.
 
-The fault operation handler is responsible for mapping individual pages
-to userspace when a page fault occurs. Depending on the memory
-allocation scheme, drivers can allocate pages at fault time, or can
-decide to allocate memory for the GEM object at the time the object is
-created.
+The fault and map_pages operations are responsible for mapping pages to
+userspace when a page fault occurs. Depending on the memory allocation
+scheme, drivers can allocate pages at fault time, or can decide to
+allocate memory for the GEM object at the time the object is created.
 
 Drivers that want to map the GEM object upfront instead of handling page
 faults can implement their own mmap file operation handler.
 
+In order to reduce page table overhead, if the internal shmem mountpoint
+"shm_mnt" is configured to use transparent huge pages (for builds with
+CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
+managed to allocate a huge page for a faulty address, the fault and
+map_pages handlers will first attempt to insert that huge page into the
+VMA before falling back to individual page insertion. mmap() user
+address alignment for GEM objects is handled by providing a custom
+get_unmapped_area file operation which forwards to the shmem backing
+store. For most drivers, which don't create a huge mountpoint by default
+or through a module parameter, transparent huge pages can be enabled by
+either setting the "transparent_hugepage_shmem" kernel parameter or the
+"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.
+
 For platforms without MMU the GEM core provides a helper method
 drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
 proposed address for the mapping.
-- 
2.47.3



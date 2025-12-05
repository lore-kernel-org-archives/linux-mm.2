Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53DAD339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03AF6B0201; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D8F6B0203; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8C66B0204; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB126B0201
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BD091A026F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:48 +0000 (UTC)
X-FDA: 84186238416.15.FC3FA03
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84338140008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="agGe/ysz";
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958966; a=rsa-sha256;
	cv=none;
	b=FWS6YDc3KpCBJNNOxH/K2PQ9K0OW+obPFekueczvULmBCdB9NMgrDjlsiCX5jfGryFWfI4
	N3eWoDSsxiC0vZ/qvWi2LDGwYAHz2LvZT5J4n7qROL0rLRmJpodYwculmeLw03jTeNkZi8
	JH416eOytlVKf0dZpgKF++Bj+ejUTXs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="agGe/ysz";
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf+VKQcl9mePJPsiQAi+V/qfmXsXDkUY8HSGDFcVgH0=;
	b=7HESnbBS9vsLadtVCeE+lAhymzRe9OmPBXZPauqeZ4K1ZZlj5tKaGPh+e7XSC4JlpqflBO
	ufQ0Pod+BBN0Uu5tcfppXBuCZP3asyR0XUUGJqJ5KidOKy/Q8oPGEPHb3hPOPrQYJcYUlr
	vTfUo6yNjJEArASTpor4jUnL5RiCq28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958965;
	bh=gYX/y+Q9NsyC9DrjRWsLnYa/A4w67M9CU3SA88eKex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agGe/yszAxtAeL0Z79lOCMOlzk4A5HHyGFW2JpfKftlHEaw3vngzquY+oOh4S2YQz
	 PVIaWoB5EOy01x+ZXpDaQjoKf246FCUDtvLx6xEGpww1RyGBwRALdfTcrwHANQtapU
	 qofByLcCk2Tl/EPFEglJ1jYq786FrbfvkOmfEioXhQBn/lTpX3PbF54tOvl24hTpgC
	 EhQf8l/EgGhyKF+JKIVu7USxq53kyFOxvRHYXovJN9L9I+v/NK7OSexFI6i41qseNO
	 ob2piZBkCv/7tGjdCWWc4i2/rS2NPCRq3/Vxz4XIy2/PuOVo6TO10YPvXbtj8Kwi0M
	 sMEqJC4y6lZyw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2198D17E12D5;
	Fri,  5 Dec 2025 19:22:44 +0100 (CET)
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
Subject: [PATCH v13 10/10] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Fri,  5 Dec 2025 19:22:31 +0100
Message-ID: <20251205182231.194072-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84338140008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: w9od3kexy9u8xpmd6marubjehfuxbmmd
X-HE-Tag: 1764958966-142130
X-HE-Meta: U2FsdGVkX1//mO/w9MLcS4GHIWmzpeNJv3RlwzPe714csuAls9yJ5KJ2Ia36MrAgw58mpBWxZ8DJ9VzeGt+pYxBkSGsB7/YDzIVZcoAuxNiP+ee9TYYhGj+W1nlWcT7+X7e95W+yvDN5XqlzPb9r6WxPAt0lrWvXM/zvDYCdK1Saao1Ybp8CIYCow4AtJeRRDzYlg8/Ll2UwldbOjZO7itFDfaR8xyTIjS/pzJ3k7OTTAK1SZEFz+Ju+5dwMkxXP0o5PwbLIlTdCgiG3qEFH5NbKXIHiDEc+UZ5JSjNizjftELPYkYcAw5hMrUV04yI7p3DPo+yHPTSyT7bO49K0dH+DKFl6wH3xurxwlURpvUkiTiwq/11CJ+eZjD3w3nz7m+rNenJckOjNKXXCMBeYw8sRkYyHDWAUeu9T2URz4SUvVdMP3gCjbnly7lpIOdomZcaWzbyPxZpw2bNb40jIa7Hxc0OFVIZzD5b1pXjfwme2yfkacKbrSxsiHpWkhrTwFHSSEeop1QwqTclRk3+mp/cy9ZVSLC+umfboIlgbk0igV6CUwfW20M93lLvB5EXgEPqCKt/uI3UEnmLaUyojZ1qJQH0DFj5KbSaRQadVSRCnYyKZBUmsoAJdN20GAqhymZFZXWnIzY1rzJ81cih/GwW2YTCp2J29JWsBFxlXCA4mQdNnmKAgcnQ01zcRziBor/UZk4cQb1aYcVU9LjOsDeNS+wIWRDxdrVxTqVkpx25SizAoV+K5SZ/il3X4DWyu86128Cj+iL+Hjqmaa1jGhF19astFhC5l0+v5QpVMRIJ6byFR+lKb3z373KDncLtT3kzx0NlorVFg6hqveEa9pPqG/XcHZub6tNerMEKNUEswaXhms86DEsJUdK0Yq+RNq6jJ0iBOxcWcQi7umb5XwsA3STNIky+LxqO1E3TO5s3BJRMj4Rpe2YOWCIDwMZotlkVnZxkeJGjOsY4QCiX
 +KfFZes5
 e04DeJM+x9QULHSaqqSzIwrrrd1NY3s6yxBbmZSFM0mqFghuPT1vxaTk3yaLIgBAvsj1NdrcGXg4R6xf+v7mtUILH4HBEU8J1D0vO5AkD29StAFc+bQHBJnFkOERU34/StS4sqaTnBcisFNtv9Q5zCsWwfv++Pi5qVjlPdgQ7UCC53L/AoCzpsG/ze+G9Ybk3xBcCsQEy0ZKZDpevDNvRg+iJz6013Eglqy7mvAJArtJ/ixppTUtUr8cUhoxDcvf5Z3GikJwcJrpwXNo8nzF5q2GKmrG+UcWIWzoQnHCBxj+0xnOdCrC6GNJFDOschTgkKu8KQu4539Gm/rjGzCmG5CTcpJ8KQ42OLFgNJ8fyA/UiiyQ6s3F5tArgB5o7BS1UF2FlroBOojhz3jvuw3z9WvMTwSNxWYCWJyxCFd8/EBF4dtofreWDxaMwIQrI841Ufy1BrurGFiIYgi7foWHf+74umQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a paragraph to the GEM Objects Creation section about the
drm_gem_huge_mnt_create() helper and to the GEM objects mapping
section explaining how transparent huge pages are handled by GEM.

v4:
- fix wording after huge_pages handler removal

v6:
- fix wording after map_pages handler removal

v11:
- mention drm_gem_huge_mnt_create() helper
- add Boris and Maíra R-bs

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
---
 Documentation/gpu/drm-mm.rst | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index d55751cad67c..f22433470c76 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -155,7 +155,12 @@ drm_gem_object_init() will create an shmfs file of the
 requested size and store it into the struct :c:type:`struct
 drm_gem_object <drm_gem_object>` filp field. The memory is
 used as either main storage for the object when the graphics hardware
-uses system memory directly or as a backing store otherwise.
+uses system memory directly or as a backing store otherwise. Drivers
+can call drm_gem_huge_mnt_create() to create, mount and use a huge
+shmem mountpoint instead of the default one ('shm_mnt'). For builds
+with CONFIG_TRANSPARENT_HUGEPAGE enabled, further calls to
+drm_gem_object_init() will let shmem allocate huge pages when
+possible.
 
 Drivers are responsible for the actual physical pages allocation by
 calling shmem_read_mapping_page_gfp() for each page.
@@ -290,15 +295,27 @@ The open and close operations must update the GEM object reference
 count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() helper
 functions directly as open and close handlers.
 
-The fault operation handler is responsible for mapping individual pages
-to userspace when a page fault occurs. Depending on the memory
-allocation scheme, drivers can allocate pages at fault time, or can
-decide to allocate memory for the GEM object at the time the object is
-created.
+The fault operation handler is responsible for mapping pages to
+userspace when a page fault occurs. Depending on the memory allocation
+scheme, drivers can allocate pages at fault time, or can decide to
+allocate memory for the GEM object at the time the object is created.
 
 Drivers that want to map the GEM object upfront instead of handling page
 faults can implement their own mmap file operation handler.
 
+In order to reduce page table overhead, if the internal shmem mountpoint
+"shm_mnt" is configured to use transparent huge pages (for builds with
+CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
+managed to allocate a huge page for a faulty address, the fault handler
+will first attempt to insert that huge page into the VMA before falling
+back to individual page insertion. mmap() user address alignment for GEM
+objects is handled by providing a custom get_unmapped_area file
+operation which forwards to the shmem backing store. For most drivers,
+which don't create a huge mountpoint by default or through a module
+parameter, transparent huge pages can be enabled by either setting the
+"transparent_hugepage_shmem" kernel parameter or the
+"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.
+
 For platforms without MMU the GEM core provides a helper method
 drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
 proposed address for the mapping.
-- 
2.47.3



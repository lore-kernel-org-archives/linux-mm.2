Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D69CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF5F6B002D; Tue,  2 Dec 2025 05:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3B76B002F; Tue,  2 Dec 2025 05:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894D66B0030; Tue,  2 Dec 2025 05:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 661036B002D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CD551327A0
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:37 +0000 (UTC)
X-FDA: 84174129354.04.FFF9F1E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C3ED80006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=P+DQwKjM;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf+VKQcl9mePJPsiQAi+V/qfmXsXDkUY8HSGDFcVgH0=;
	b=vDOnSUBVJ3nG0+f4EB0TUCV4fMo3Mqt6AE3xmVLXFKvvex38zJOjXXjLg+WtnXyYNa2Njd
	wDDCWRES57i7LPXht+qYTYIt0o8vE00iQXAxkonX1E/F9m/hdGfBz+ycupa27P3C1gkCpi
	cxiult3wRM+hRG/f7ahnNmBtVpqWvys=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=P+DQwKjM;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670655; a=rsa-sha256;
	cv=none;
	b=51w+Ohw0oLDKL28Y95wbr2nVD1pv8C1Eh+weR9XPe5rGw5zYcMdiihH+pfg2dDiQyHvgha
	9+0Fz98mGehiLp8m6qoMzXuY8R+4EKh1T20sz3/ks7/RVSWBJAVb2eSOMkZfnZLX8rF9Ea
	bURICqg44rj9SAN0k/kJ0a+83Ud0pB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670654;
	bh=gYX/y+Q9NsyC9DrjRWsLnYa/A4w67M9CU3SA88eKex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+DQwKjMM763POzeXVj6HCMGPB6cuDM5K6+NRAYrFIoiOoPw0mfERCNAdvSTyyMYU
	 94rowxlNMt8e8r5mBep44hB0MGPtBjOguHTn+qTDFA4uIfYyYh6YJtddr2NLfDaOff
	 1ydw7rNEOGeTigoASM87SnBHRZ57IXFe2bXccFMhT3SsP+YOsFuxHEeHmIzfO5iIq5
	 e7XNGRuEPQIvkZFbEMy9X6pNRGqrlbh2lMivat3U0pob7eteSRzP4BhGn0AaUM/KG7
	 TmdSW0j7gll5irFvtOqHoaeGX7Sigap0zXyqNLSHr8wzKkQbSrJw/fdmr4PBfPJ04Y
	 KpWGNnEW6UOlA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 300A117E13F1;
	Tue,  2 Dec 2025 11:17:33 +0100 (CET)
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
Subject: [PATCH v11 10/10] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Tue,  2 Dec 2025 11:17:20 +0100
Message-ID: <20251202101720.3129-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C3ED80006
X-Stat-Signature: hykwbwcjotg7m39a54d1m1pfh1pj7w8u
X-Rspam-User: 
X-HE-Tag: 1764670655-223165
X-HE-Meta: U2FsdGVkX1/GKaGY4uJVZSLWpKtcusMr/85r8EfEN9KxyiLCGXTFX979KYt+OodtepyTByLfKiJvlJotyIrRFnn+S5rj+2s7iua/xWboMxQumYmEwyiJOdepfBaYdqaaUmjvk4vh6AgQj6QmiVaKU3Emv5/WDjvzpb2YDyOA/5NsgfD2QsfLQYxiDTzMNBhCPiogQXrQvXFc/w993SqfG7NHzmX0n5/wO0oNlJu172v2NUj21aDL5o341S5F93JqXfqMTidPjUTPly+R3m2M1sWPRbbLvNEhr704eW2oKvm7kSIFAofqB05usdOxLayHld7B9UGnxznOm+CSGkgLKEvuRHTQ+h0h6VmazODLi6CG8fDNiAO313xZ7ePdrmynrRlsjVolJRoredPC0G6M/npEUoEaW4FGDsvub8oY63vhDHMxd5gkRzJCVcCoQt0lP3be6zNlpleVCz8lEKcJP8pyVZCHw+4+EU98js4IDTDEHntRHtg1mly1y9MqZznnkVtq9GK+FUDI/H7zBDG/Tgg1/Mg7adNGOcL9hh5qtCSByOc3bScOOX/yCu486mp91xBn1ZPYaOj6M2ij3Ud0Zcw2Uha/8rKXdYCtdl9dx7nSljBLwjGvlYVNkAumSZ78oVmT26bxEuhNcAKnHs6XoqvLaqltBEi2e6CEk2KNbVZ6WqJFtAlklxQpp3/GdxdD5zBXrdn9o4KT100vP0ywy9h2KBjRYjW8e+1YiDHXqyOxCpYZETuZPqX10C+ILtgrkIsASijaYJrOUtp89qOE0vTL4BgBwNbbx3suXdgCx7iZAQita7pIMrq8EcDiXwqigHMUhbjOFSmnL088a05j3KI92nJGgH9i1h9QSEQTaqCCm/6XuON7AGW5HGPt5//2sAX5qEDcempR0Gt/zYMERRUcdLPXKF9pG/g1aJ14c/mEgGoKQ4AEiUYBg6/jDMXyVuz8QdOdLB20AtmvZUd
 SV1lbapj
 RUFDhFMImYGQxNWHAy/LV2ngqDJI+H4JuDsyWdOGXuZ6ZyGeRb8yBOnqSj8Dqu2ZdRlTkpLnC2FLmPBDIFPt7NrLWaBvgXtA7mXwH8n5d2lusJCSpeWSXcbrsWQiNFYt60yqgIrBmzTc5xsXXuhz9gHNU/jVqelMvJ18Y3wPwS2GBT+dhuVn0unHEGQesVUbl96Q3jJ/EyWpggstFOL7A+UsF8oKeLNFr+Cp+aH0nwVgcnD5/bS8W3xQr+udHFmj95euecDfMSEhV25HL2yRnBwGnohKe8G+AiGuBQ62KXQ7p577FwuNO5HCuAmaBgFnWEI6Bb9Ry1xfuBu0ADAIMFKcwljvaQKgijc4V8PUje83X6jrJJbBZed9SQFqwKZSDt5i0VBrZXhAnVvl5wtOo39FtHUl47bWJ+rcK5KUj3V8Rp1HPtuGOXYZvFPiw2LjXR0d1iEaN7FICQRjvFEB5pTrHIg==
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E8ED2F7C8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12436B0149; Fri,  5 Dec 2025 04:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2B36B014B; Fri,  5 Dec 2025 04:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964696B014C; Fri,  5 Dec 2025 04:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9B66B0149
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46075140482
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:35 +0000 (UTC)
X-FDA: 84184851870.26.C32ED84
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A4E220013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=RzhskPBD;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf+VKQcl9mePJPsiQAi+V/qfmXsXDkUY8HSGDFcVgH0=;
	b=4TenVD+5CvvD9I0nyJdwDiCTF8PHnCo1tvabkPr3fxcnds/6t4yE01tC1kFQznPt+uBqTK
	2Zj01ursMP4JkhWBnOs9M0SqSJWgLOmQqUQ6DvUjV3v+83WgIEg7c1tcHOn8vdUThThVf0
	4X0yhiCQ6/9f6aVgbgbsCFYD4sQGMmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925953; a=rsa-sha256;
	cv=none;
	b=W8TNcul9C7jQ/6dKM9mLDX5BKbeEkG/v8AxqrSO55zFNKFWFT6bx2RWoUf4wlUh2rFza0Z
	QpL48qhlzX46i5HRaP3Lu4KoQjgyxYppC0BkkJn1xIHQmb3iR6PrmkTQuQvskV2lWpS5ei
	ma4BdphXQdRwSZGoWWg8mm7dPCKREgo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=RzhskPBD;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925952;
	bh=gYX/y+Q9NsyC9DrjRWsLnYa/A4w67M9CU3SA88eKex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzhskPBD2kPI53nxPhn8+DV9ztXVPXIG9YWLxyu/uxrbda88SOMuiUdTJpq1X/icu
	 MGW98cw5rSin9flg9xLG3TW2+bH9ymVPRg3Y+s1B5SvmcWZB4dfU6pciXYb8wYfhD8
	 JxhqYchHJeYevq5tatQ/SjHa0mlzTn6eJU373JBpjAA7qNsmcn4TnVb7+q16et/1WJ
	 9QtyyZQlEhvnOC5bOjIzNoBf7CX6zeeetwnyvY2AGW8om2drW/ynnqzYWEO/xBRKH8
	 LwjNwKKsWaW8F6HJSGb9iG7uItQThYBOpwzVpDl56P1Nx7CSxSPfr4aK7JyUcDuebF
	 hNpR5+H2vg37w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 54B8C17E1428;
	Fri,  5 Dec 2025 10:12:31 +0100 (CET)
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
Subject: [PATCH v12 10/10] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Fri,  5 Dec 2025 10:12:16 +0100
Message-ID: <20251205091216.150968-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A4E220013
X-Stat-Signature: jgwo6erb9z7jjr1kj7qk68iyfqwhdhni
X-HE-Tag: 1764925953-827317
X-HE-Meta: U2FsdGVkX1/agE3cDYT0fXX+368PlbXcMKYeu0fNyXqsZE3rvW74XhtkBaqsEkeq9uPl5GNueFAXTq2CBqlAV7zcdKuK2f/KV8Hh+Xmc9y3rlNJ+Vfrlwml7lg59QQgBJOrhQnFq5UWl7buzdub/+izPlw0cyXlVn12cZpRMSqHBLz/Z4Bi0HvUcTY62VXuse4PIhQz2n0GpqdraVGRlgsImdLKGU0XpvwuUo6qxmnV4p7onnvHQFOPpqsQ72nEKfRMG2GxZqXE+CH3dU4Ta1beDgR1sqgsSng6dyJwgnmkr1hc4cqrRE2TlXQ4W9n7fjePk3e9EN5xFkJVuGYwbwSolvKA/ekN/h4o+sRFlUVTHKbNWURXRrsrRqjn3dGVnGO1TWn87O1AIAJ6qx7QCVEDbXxIQpqwWRMQJk7OD5D+FJNKQKMEog6WXTCeP6VLwvJwas1FI44fkE0yTWZphw5yHNee4zm2pXwPktB6dTlegQDQfOInNYg/GZ8J+1IV0S2hHGu+2QBLo1ADXFMm9JZRcST+aMUBm06UPTEe3Y1oaAe62Qed2/eeWfQRVYg9cmoh0qIGXRJJPGdYBu2iZOjNcu6MbOM8am3MvgcpUMDWqslmmSBNTxZbnBI809i6rgoEsR/AtExCSrHU201FspnvQuvcsqmRO7f4T/V1r+mxCcV+Nja4qp9U5KoW0ulYSNaya3ddj2ZHl3qpVXQxji46f4ABymEd34XcpwaOa5bNrp5zgkZjU8T/vcpW5gi/CaEjuhu256MPJwtspqROKRfbJigdJ0BFqHJb02rWyhXZZ9AuMYCY1hkgu37R1zl8pVSFg8zKvbAEByTOnu/KLlOJkjfy1tjOVEmJUOnizfyGdclpx6KPlDMGKd1z+yXVh9mP4W0lLTFx8nzieEjiPv/dalKQSrLnAhqaYtdrLfdvWcyB7N0bCg10hq7FqMjZrh0URe6kQkwAVXXFHjIi
 hZILm5l2
 7rVMbtZvWgRwCiMhUpmSWmXrHfmHu+wy8U3fL4cRG9ka+v0xirRhbSPYi8B6iZS1+flsHiACf+6Vmoy7ndp05UMOAXcaFJbVA5lz7c8ffbCmqLmt9iQGaYAtutRXZTpuyzv+mHrypFyvzyizYTApfRjueoxi1F/prEo8XT7Tax8COQzASFHrkTCHNECDLPn+Qlr+q9fxeHH/QYQuUzhPs1HAbxJqqu3dM0AAI9nY2A8v23cIKadkdJWQkN/X7n1tHkKPp5YXMaDzMNp4KpalBbdP+91fjlUT5Xkz+Eqy+Kh5gi8y/6UO5WrBSDYwFs4ZvzmpaPvz6MDblmAPvV2bGVKU5SsMpQvLOatBWH8Wo5KOFONO0asxaoyydAkd36Y26/uNIZ1CNibDMGt0xXuf3sUKIZapzYIb8SZrW/xmhoF0kWzz7vu/EgA20SKJtqFkVOwPfw0Oxrv3A53pyfRsnvmidYl5GXTV1mvzANUkHsyOLadAfugTGIlxe3bmnVf2vuQwDWUTCdtb9yVCAwUcHlUo352VpXuw3pV44f/x7He91me4O+Bnm83ZLKy6jWElxnNfuziBaZYfC00U=
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



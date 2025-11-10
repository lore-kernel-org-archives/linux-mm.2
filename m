Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2ACCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD29E8E0034; Mon, 10 Nov 2025 10:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CAA8E0033; Mon, 10 Nov 2025 10:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE7E8E0034; Mon, 10 Nov 2025 10:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 753F48E0033
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4985C160186
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:21 +0000 (UTC)
X-FDA: 84095134242.04.08F48D2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60A8720002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=YaqYP3BY;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3iQY0mCR0gaZFmXghVPKyhS/yzkP9DkOi+8uk5oqWw=;
	b=xrBZfqwz7bUiyq+IbtI4TEzdj3jA4CtDsttBOGq21WIpm0nFdeuhEH/oJ/qWO3rzv2FMlG
	GgexR8s1lxkMIgZYi6nH8TQQN9/tX4JjfsouoRiwxuS/JpmM7FnvAxGkTkzwsOsioR1ipp
	k8JVrfrAkwztOHBkCtPjpodOLryCisI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789819; a=rsa-sha256;
	cv=none;
	b=TVPIoPorT5p+4SN1Owgqi6S5doRtuoPLhJrTJvGImQUViEgo0avU3JrliAyIg9StvHIWPW
	7r7AOjRBodEEk0fFzXO3z0KoCrROqxabuf0wqctkKEJzBL6QD7LDeD0h01Bl2S24sgP0mR
	9/9n8/SrkG4gq7mWaLDl9Xh1QXNP0cQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=YaqYP3BY;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789818;
	bh=40WG8/2e61IMWsDRpUFUHulUyBgQPDILQimEoI6b3o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaqYP3BYvVXp0RXTFrTVDF4A/I7xHNeDivG/xTI2MY0FwQuRsUvecjSJKhlVo7qLc
	 K/nwzBWJAFb/N7lzH0T+FKNRytciqwTzNDOIo8mrmlVxMDoaObzqT4WxrQtcs+BBLq
	 WpSeDlotcm7Lq18kiR0amNlSkEa8qqOI0Q1nZTSdupPdf8wHNoKdCNgUfC7Q2W/gvE
	 Ie0bBykl7eaA6dzrY2ixza+QNyH3Qv5/AXou8oA6k/BN71QT85PyQ3xWkJc7yN2Vz1
	 w/SKZkkQLurmWGEV3gXNhJBekN7CP8t7KsDKXTxaIqNJHimPG6zjDWlRVDehTRsnVE
	 GfDus8gNJFZjA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 30D3317E15C9;
	Mon, 10 Nov 2025 16:50:17 +0100 (CET)
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
Subject: [PATCH v7 11/11] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Mon, 10 Nov 2025 16:49:59 +0100
Message-ID: <20251110155000.2936-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fwxnzdsz971mjw6ph7w8ab4uu61wh8yh
X-Rspam-User: 
X-Rspamd-Queue-Id: 60A8720002
X-Rspamd-Server: rspam01
X-HE-Tag: 1762789819-986586
X-HE-Meta: U2FsdGVkX1+h4pjWMw6pt7xu3dEBI3NlLw74wL4rjDXrbzICad7xT3Yir4vENCIHb7Epn6ijTXLGQQCMH1FbSOCo9ML9AawIwcdMW4Xcn9zqlCbZ9zgEHCG6cH8HNwkNUC515BlffZYHTzbVv0r5qOuhcZ6R+uLCwzSa1t/MbuYTtxySxwEgLJEO9s8mG0dfSaZ7sqolLAJySTeky73aOtrn+B1Q/Sbkf1j2Y7AOhxyGbQPQxkJyZth1/V1OOlisJTOLsJe6cJEZ0q1tBS6bviJ4ixQKyARsM7gfjsvWzOcdhsVjXWJQCZse2awYzqPWtm+jfKx7tqXdpHiIoxxYF8Cv3OnbHAhb4XlwPCNJ0kc8dujxoooL9Tz0Ke90Lsajed72KbPctLp12i3QhRnxuhAxf0KW0E7xAHZCdfckssTsOPJ7R19b5tUbs0NiQt8N6Z9gAhwbFSJEeHhCtQ58k4ETCE1Hnl2J1vL4ygYX9vgWkYG7eDonfGd1pD0Oj5JJfV9Wzyn0XjsrnMrjPX1mPEYYh7OLXlF//sxE2beshB4vyfoNbXGjWCIJM2eRVybq92yZYlzW/u02r5/pp6xCV8Mwr3fsO4so8Zqx1R1omqz9GOdNjtY9pmZxr2D+cXTTWH6qUzxsNhA51xanZnz7plnjeSKJrLej1UKCiUUMSIza+szs5kRCsvYeAiSoXNn+j8oHvoZRdabofwVGnxxDYUf18+rnfay+1V91CVKaHTGrJInRdBUhjVwA1ZgRv8MrcIgWbNnKW08sHUBPEjg8BvmJY/8TjAK6SG3ddkIpFZCY1Qk2vuAzAWMhhLxrgNwHSFdn2yv5eSoo79s1nOvhvSv21Y+GJSZQ0zs8KjUeMP2ZvykElxzieItJwYTiRCrVA5YuU7jEkP77R1MtpAV1HG4TdA61jlLl3YqSlGVkqKJACyaIWddZQAxPo/UmaF7bYisDPUJdbsDMXZqCoaJ
 /b5T8U4g
 fmgUlDvPcaClaaz9zzpxj3YMW27LpD1YctvlrmxRLvA4IcnoNTWsyaaPCvIRSq/KLK3A7daJIQ7oS7JNWs9H8IZ8+9zPT+n109CnO5FKV1fu6ZijY6vwCGQA7niyECxkB1RFrh1UIfk8p3VwuQWhcSCDSmYcnrbB6WvpQX8uqfSNPKg2hzhe05ubYcvYOorzG27G+6mQrxXvQvvZdxiRFN4SXgTgrpM3t9s8ZKwmLr24j6LY8EqWkbD1QS8opK+4nUNDqcysfbZtdJbjnj0f9/5jE69/8dThcjlKSfgVjTqdWatXbUfYpmj5zFUUVuZxUy1SP1setGwJdLOCVilX69lPjSRG5mzvSt1c9ODZQ7RFDrKOA77KGb8VSwozzF6korReXd51wE0VaSwTKcSAJJUfWmIic8/cdqquzFMV49HsPz0eNwGm/K4MaWtBHkaC/zRHeC3w/5HSrzdTT55gQge9fCwTIoFiipNFME9LnKEyM4cVpMXHnnJC0eoYw8g59c3X3bA07Q75WFpmS+NpXI50Q5qXSlmmrnaA6
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

v6:
- fix wording after map_pages handler removal

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/gpu/drm-mm.rst | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index d55751cad67c..d69eab0b4093 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -290,15 +290,27 @@ The open and close operations must update the GEM object reference
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D72CE8D5D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5468E003D; Fri, 14 Nov 2025 12:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D788E0034; Fri, 14 Nov 2025 12:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F04D8E003D; Fri, 14 Nov 2025 12:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2EFA8E0034
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC87CB98D8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:21 +0000 (UTC)
X-FDA: 84109833402.13.09C5C40
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id D804940011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M8S8xBJE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139800; a=rsa-sha256;
	cv=none;
	b=xpvtUmMa1VD3QpSQR3sJTzoUz9ASV35414ZUrAD1DSpDAB2DBD1UXhuQGbZ27g4djRoRiX
	loKL6ZV2EU9Qh1tm76aWeE4kOtqEK3AxQ0sFZ1oCri29nK8dbEUJQ123vzo32K3zeyz3pj
	xbWJUfuBV/j/+nIIZ7ZCMxfFNFPIIIA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M8S8xBJE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3iQY0mCR0gaZFmXghVPKyhS/yzkP9DkOi+8uk5oqWw=;
	b=G9soc4jiwIJOXmDX9OWetKrqhyFJFzdbrjwmQb6AEd+HcqyOdq8tHKZALbn9w0cOvXnKmf
	BhhAetL1V1Vq4ylavcctpRlEZwxEx6CEZOaeHgI/cU9jSEW2XNJ2yPxZ4H1hAjAvBmhV6m
	XBomvihBUTZwojHsTvdg1KoUAUpyuVs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139798;
	bh=40WG8/2e61IMWsDRpUFUHulUyBgQPDILQimEoI6b3o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8S8xBJEF6NP0G6uCcL4pzPuSLINAukvQRezI3HLi/ICTZ6C6p+HUpJ5DhYf9vM9J
	 exc023mnPyW00DCZMTpHmT/UVdl4iNXruk/yTVBmSKhW2Hiw1F/jtWEkk2ajyqjuTI
	 res1Ab9odYCMy8hC1Twov3Ge7/dNJQIj4h+kpIbHUmM8OVVm3Z9IKAaeuG+I6m7PTw
	 C5mu6hvd8dzfamQ4S9gIM4W0YhCvD1AIZKi67gAcbmBH8q/sk/KYNjYp2dt2EP38Gq
	 Tqkoi3qGgKJQAvLhRkqeQK/uc+OkRlR9rWlHd9D+/8Fq6VaUvoUhFYFR3+yGsQFrwk
	 qUKwbWO52pcCw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9494817E0927;
	Fri, 14 Nov 2025 18:03:17 +0100 (CET)
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
Subject: [PATCH v9 11/11] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Fri, 14 Nov 2025 18:03:02 +0100
Message-ID: <20251114170303.2800-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D804940011
X-Stat-Signature: f5ddd17iyg8w6xzsz3gii9zwgq78qd4f
X-HE-Tag: 1763139799-919076
X-HE-Meta: U2FsdGVkX1+dc591S6it/j9TjESAwB+5P5CZO40JzI9pgk7rgbYnoiKftnVFCJ8OIwi427+eW68kCeGHRmXAvA3pOxVdxigGZHpgZoXKRU5g15306i2NsYoCJ7RlmJ9gLP7XWTPfwyB+ULVJuo6l/vO4vvDFLBzrpRYv4H2DtmP7lqV8RjmXGiAazWuH2a8W6jO7Bjm7RvHvWuryQBpJbeFKVXdge2PoG3cs+RqfKytTYc/WnZ7LCVdLzepSUTnZlGpFhoAxnGDZ0iJeEpaCCkUkIveN3ewYAuGPJQs0XUXlbyKniKUJuX8KA1rZNHFYb2yPlTwHyD5SiNyFh+sRr7PeNLk0+Zt0gL9ngPhlturytkVrrYlbMxFWbSCQC8VhVFK/Cb/nQq//n/QbVXeZa49aJClJ0yqff+xYbVpQH8O0BaU54ExqSBh725Dxz+8/I/EPzmDp2xGQa6CDmzN5UHoo1uVGE0shBbzPb/nSGlpWvrca+vHmE76FL9cPZD6lBkybLoRb+klBlfw4jLnX656xR7TFpes4dCzrG+T4j4XtQ4cHDfU7ZayCdEeBFFE0hrlGK6IMByaYXgjVWxRDsc8f1XweMVtV0Hzf8Yuci/6ltPvvPjWpO+Wlq6KSj7n4ULxvPu8l5qEvByrMesEwYSUND20oDt5Asg9BbEJPwanm2Tq4kIRPmHKtJrJsTPKbq8uufqGWF4kcwO0Q2GYTQnpj7gLaN4GNDQMl4BAW4HYAqQCpEDsRWy6rW2AorHXICtH+Rul0u2xwLW3CnUNPCkxy6kVgh0ZFn6gGqgDT+84/0apYYXCinLtM/aXMe4qxaKdBADC4V0K1ezVasiCkg96AsaQRabYLM7h0jezF6MBqrKZh3v2LIS9aBIrtYxuB9ddywx+bQLlCxuQJb//3Qvw3UlOBerU9JbTMC1TYS3rIyzOuBXVBNt5CpUcsgd/ivIDIeMSgfL1CCXGDCOs
 cYphgzGu
 4R/CmT/eY1PJAjZ+Uk1P20gV5X0LesIxb635ZDiBEv/jJMM+wVnMVcMmsRlVafUdiVVHzCVBeegpB8XyfZI2NwkEe2hEvoyAEVwnJjNVPh+35aWFzyqeMVYqdgLW1eP9m+7PFsxsMk5HVSIxZ5lmxs+bU3wqHVhw9nS59QstjtH2KMjeLDqYb0lNqd8LYann65Fe9jYav1ATS1bynzNUHqRz+amhLqpWWUIn7TwUdG1AtJykC2IsZKM1AnGy+n1RQRPBmPtByQvJJteRYKZl/cNzeWXdWeMTpGUqLbgwUfJ+m7tjhUSR5CsgrD7bC0VcnouWfC8jTWJejDgXYS2kWY1gMlLBa3p9TIB5TRk5vryT3L86kLfqmpDsZFDBbYdU5P53s9xB/QQs6xGSIB7Ggi1jZxdKpdMpzkhiBsnNWly2Z+jC8uTmyfkyR5Yfbg0iWGKUcjgmQgu6aSYYu10qWFcSwxzTlO1313gAdSLhC9C5htmFDkGJib0I5NWIVB6Qwq4ZYeI3RJkvsOlRG1REAPX3BIA==
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0030DCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B788E0024; Mon, 10 Nov 2025 09:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7A18E0022; Mon, 10 Nov 2025 09:28:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F088E0024; Mon, 10 Nov 2025 09:28:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C638E0022
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BDDD1DE26B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:05 +0000 (UTC)
X-FDA: 84094926930.03.2C3F296
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D673100018
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pdRpfIAF;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784883; a=rsa-sha256;
	cv=none;
	b=WCi1/QQwz45drUK2e+OKRopKuRSligkJEU5Sx0hd5OqA5PAJxWB+vq9VPqPCuNfzfKDGLp
	evKcD6UjYMbeyMNl7bdZ94jI8JYqtavPT1vJ/UrkZczkIOQTK8/l/KD91eOaDr5/h8LhrC
	k67u2utETExt7eNQcXYRSVniUVniOAQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pdRpfIAF;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3iQY0mCR0gaZFmXghVPKyhS/yzkP9DkOi+8uk5oqWw=;
	b=baajNGja252yXtKkkP8KR9a/qEKyeDkTp7v3x3QqUUWtWAbqcPQ5CKYdEGogOSVh7dyd8e
	kZcaQ8zuAlw2AFXSu085enOLSxU8PLPM+BtxfsA6BBVh4uPDmn01hwYXJISbKKm/BE5jqK
	5bHGH482LcKX5//Vi/8wc+eyjvGgr4M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784882;
	bh=40WG8/2e61IMWsDRpUFUHulUyBgQPDILQimEoI6b3o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdRpfIAFOrIos+1h0jjJtBVP6xGOZFtkU9Bx8lM53qIIlxQLD7Y5uavRnQMD2rx8s
	 OUv7m9FX02Mt9irbrZFe3zyOHTRLHosE+E+uHg17Ebs8pqp24GL94kkT16qGDlTW+M
	 DUVdh+8MHfy45CNLYS6tkU7UioE4y7cY63+1g8x0g1T9Sy8UHpD75LG+LQ9ZtiqcXh
	 pynIP43TIlgg4bZg731x/FOi2KiQKXhLrDHlzApm5e6Mwm7rcU1RhiPgOXoPaUtrIp
	 kkGrW46vwFoZWBn+95khvZCXydhMO7cneQtTQlaiei5cX76bm3axYvogMutBjhpduW
	 Ow0GGVPFesPjw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 763F017E12C4;
	Mon, 10 Nov 2025 15:28:01 +0100 (CET)
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
Subject: [PATCH v6 11/11] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Mon, 10 Nov 2025 15:27:46 +0100
Message-ID: <20251110142746.3490-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D673100018
X-Stat-Signature: opdthfs8x5cd6z7camg5ywunfrtqzk8m
X-HE-Tag: 1762784883-180620
X-HE-Meta: U2FsdGVkX18crtNX17tDwM+nnI+bBky9+gB/EllauyUfwVywM5x60c+qYUIQ8QsA1eF1uDhzwtT3hhMhFDO6wxuxvKmFIT/V85LyhoxXMdmY9GFCXzthGcJIESq7pKGo/BJNX4uSKzc3zPW3pXEVunjekIJR7IOYauCusdxlgtKxr23bnoGMJnLnHt/1sSDVZbpOxey2Q/ms7vpPKD/BOpZkl3wrAI7wJD27mjgEEDotbjadtpXRyGZwGJ3tR03G3OKdmftQR70sogabK400eCXoux7ej9kBEdeCkWWf03NPwXRn8+2uSU/9nTe6EB03hsHVEl6vjzHi1qUdSicfjlQlMYr5JbiuSfAL+r93SsxZSfzd2sU/VUUTg3mwmsKZIM85teoXgCIN69DcROTEwGxFGdnkRrTYGTSEG+/5zNOYcOR+Dh6B30sclTh1qmgTksPZhu6ECh9HpFy1j7B3tzZmkqFJrRHgwAJLhWo0DrW5QTs7WntD3XPqTlckN4JT/hnt8y2/3PuVSd/ukPmACeZkI+YhmvWpW+v6u2eNV+BZoG3hOMQCm3zr/v5Y8xZooEmHCuPcvAMuFDJhFIx6WInmh7geWSp126yW5hXbYNNlkwFutTCeY+lB5WusHo/jhRX4KeKU+qacxlnTw2put9aO/BbslskqN+4IrvOtdPtxxs3XazFKc/jqofcJHtwmrl3Llhfk6Dv+HVqYaCkYcH+qo5Hmd8gpYetb5sbXEiJTYXlmplDd8BJaZC6YgtNlIeeQcOSYrxlOf90EbOi2288K6KWdJNnEuSG3xVIKrBMedgmGBkOPGIg23BTwTbHzdozL+ZiGjG1NtF0N7mksIuUKXOmqa6PcPD+ANgh1aBd6tSnW0x615EdP3OpXvTl2L6vTwr6KmxKehuokt9XfY7Fj/VHyzu+gkyK3EokC3vXGCTAbr4LeMq0VGMMAXXit+tVNFNqeG6UeFEzIkuY
 WTGr4q7w
 Ka2BnMKSAtWJkFhCd8e+4YN12D0TN9IeE3LBNA5dWNvFUE87o69wlmb2g6KqAfiThYVkwP9ww8IuESSIAyjteWNsKMoHouE49TITYMcqv8aMAeQcYqPvPOsidZRx2zh+CqHuNdVVkileBn9tCbn1yixe2sooKeElaTB7Zhi3bzEaxtIGwUxGozu4XaSnE7p9pK7B5r8M2wSZ72znmP6MOrKbED/kFjS1sn+iJuEIyK0MpqQWzcSufTJjqjXovMScfAyg2CKdBjLHOoPFflS3dNurOYiY/mVxMXGMr1mm51Xl+H5TliVOr2DxP+QmxnUXO+9fKBH+g8cE5riapvhbgZUbVCN+PDx247EwmAzWPgM91t9t26KloKHJChV2iMfUsOOkqXRo3ByvUm8N45kA9mdGMLy73qMN8Pw1q
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



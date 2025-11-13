Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664FECD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC998E001D; Thu, 13 Nov 2025 12:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D668E0002; Thu, 13 Nov 2025 12:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF218E001D; Thu, 13 Nov 2025 12:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 666938E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DD9889F52
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:25 +0000 (UTC)
X-FDA: 84106197210.12.6019E44
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D0262001D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Xml2SVEq;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3iQY0mCR0gaZFmXghVPKyhS/yzkP9DkOi+8uk5oqWw=;
	b=BTCPfheyfoMLhK32aHcDIEdbmU4AZmcRcv0v9WZW2TOaUKwwvWdEfXb/39z51KDPbb6R0G
	MebWJYSdW9tzvL6OYROsdo6HHXDvQPTl5e8+2+DxCwZl6DTwNATOAtUPijkJW3yNAEXEta
	AyNQyPZ9AoL6QjaO5uNys/FwtQwzCQU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Xml2SVEq;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053223; a=rsa-sha256;
	cv=none;
	b=YcSbPLn1kRYVXbojYwgFJPZsoWKPHpUv0jBpDdy7rhHaVpVj7eJF7/88nla8u00Wr/chox
	NuQg0bFGGgLWWeh1fudBxmWKyj8D1GIJ3M4uDqvQ+/jJIksISHsdE7yGGo7mJHROXSgaF3
	cXIVCrfejqLxqhhrmHSO5myzyUfDLvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053222;
	bh=40WG8/2e61IMWsDRpUFUHulUyBgQPDILQimEoI6b3o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xml2SVEqAFzPzpZkeSElsymNEQxxTBtTLbeJQgyiAf6HTvOaQkBTW8Q272TuIwo79
	 DOyOmoZI2SUOIWckZ79XD/Sa04PCnNqdKQFJNuFOQ9E85CWIqiMsf21IuiQbFHr2p9
	 243pyv9ryRHyG3JMXwO16il1adjfKKu5lTWon09VbH9muSQTvCyA0XJuCWC/Abm9gE
	 g742C1ffk8rR2OckSlLC/nw0XB6Pq2bIuo2tgOl8vKXTQEpftHauFMKWQRhXpclD+s
	 5oj7pUvx6zZ7MDzwvoK2UUkoeUJRZAyjEKOobvP0c2M57Y96BijTJRAja+x3Dmi2Cd
	 f4czw3k7uWXsg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 38CA917E368C;
	Thu, 13 Nov 2025 18:00:21 +0100 (CET)
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
Subject: [PATCH v8 11/11] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Thu, 13 Nov 2025 18:00:07 +0100
Message-ID: <20251113170008.79587-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D0262001D
X-Stat-Signature: wsa4bruxbpp8q56ndinzirxjkgjmgqw4
X-Rspam-User: 
X-HE-Tag: 1763053223-91626
X-HE-Meta: U2FsdGVkX19uyokRBVPsnPMcm5GqYi4xbKY1CXU2NqTCE7Y52aiswGzaETchnBVIIL0WKJbmwNOA0mHD6Wcbiq81iRxfRNgju1iTLCb0GrKSv+Jgp1qj2vWBqrrBHkDTYJCHmzwyCbja845mAVZns0fxhFQbh++wDBOqXZ93C9tdW43ZopENHz9k4EahqlBOmoDTj4ALxE6bAvyYZkvFcbLRbSYU6e+WSJPDPSQTf+1fz4RaCLIW+i6ei0JcfLnxmw3OcJCHep1E7OWvf59gjTTNx9nV0sgEf6xTm+g8pRUMHOWrkK1pgGWOOzGsJBY/cg0vK8HC/u4Os2yrn6SdXuEM+M04+aTgTScbVYzILAJkr8nFdLpyW7xH406trCIJtzOHWj5tYmF2GDCgJcsR4+XIxaBpYWeEfr9u6qKJ0U/7Sj44R1o29QSNBBL9E9kN/pXrJC5BAIsVifnO+DLG3CMQjcaDTEgbD+TcN6MKynM3tiSQRk0W9Omp5PlMyRPiwIaK+1uzmEvm2tUzSTRZSlXVATDa17O3rhTQuJWp7o2w9tI/Rgi6KQPXlSjk31L8Tu3+1gY3G6SKCHn4KQJwI/ZwSAt+BakHM8SaYoSAIrOzsIgeUF3r/sPQb+AyrdyeFjY12AOI/ddG4k/+lKF28nC6oe8qlJkItsRnoCXK1TryWB1NMfyhS+zekN9yQRNzS5T8/AwxwIgm4StyqN+JqGVst4JCXS4v8K92DjJkCMTMq1D2OBg0svmxm5fmi69nkRMcKGt2163cCe7jPyK8AUsb5tb20w7q3KDhWo+P7+BvcjrxbzEWCuD+tGkCV8/BZRDG9A1LWmk+Ov48iSpcfgwu/2XK0QJhTSUOXR613Ioh8fmEp+sKPmhDZFGjCMyJkEb0JuhWHzoqK1fitOO42nj0TgsNSUMjj0SduciReGog1lgHGHogMxcmRDrWqcS0RR+eBeoYl9J5eydYU9w
 gdQ0bGqM
 FfSrSbsoNXS6LttVh/dVLpnsXQKXOQMNhpE8TQb6VnuvaANs7hkcMYw3bmY1ZKMXu5Zq0urOlw0UOW5Ev3upqcZu+GqnUZErcgYWAiw7Uc3r1euhsk6Xsi0SXYPxI/lhGzviYNtgmtmTIAIhBjwC6bXA4C7Ci/mqKjScI9GJNKcQr2xA5/EJZqRe7h4iUtDypWByCYJi6kYPVg+KTVQnB3OOxMI7PWC/FSETTNKMKG0qoruJu43TAwHIURnn+vx6t1qLfR4MCsaVie+gGQA8Lmh+AdiCA3N9W6n/RO65nPGZdESpjetSTHkoeTVLQy9cGNA2Ublt+RHe3BupCTc+o0yHU8fncyPom79Qu0LE0ZLDrBLvNScLBtFJyoyRNybbBgz0gjKyElXSeWdjvpcwKyJ3C2z6dT5++uP0oG3meql8cMiFJ+IgGxYgybe+KYxyvKiI8R9sacGuJ7nhlSRb7s/JUEIUTzLsXgLHEFnUFVt35+3Huml+Vh7bgDQyl7FiYPo1ucM0Uqq1KSG72+ANbh7NW8Q==
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



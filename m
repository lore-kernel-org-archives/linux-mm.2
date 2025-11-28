Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E14D116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEE26B009D; Fri, 28 Nov 2025 13:53:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475656B009E; Fri, 28 Nov 2025 13:53:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9636B009F; Fri, 28 Nov 2025 13:53:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1534F6B009D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D852FC032A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:08 +0000 (UTC)
X-FDA: 84160913256.30.48C979D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2D7A140018
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iiuP44ez;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3iQY0mCR0gaZFmXghVPKyhS/yzkP9DkOi+8uk5oqWw=;
	b=I2vkkxOExJejvY9kuPI87N3X5NzpugSHyYXnERxzuyVNsOtURpnTtX/7Qs5RcnFBLeSGz2
	T2uBmxzo3cDMvC5zPd8cBPyIPA0cI5Fj9iKwlozNOSZTNZU07cDTtbnuMgvgiDAV8PLwvr
	aoOEJ6+mjP/P2ab2deU/zc4rYz++z5U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iiuP44ez;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355987; a=rsa-sha256;
	cv=none;
	b=g0XOpRR5AVLAbKIlGCKft572Y90mAcnpxpOFnm/tIm69EYI/CqS3irtO5cNLbdU8DzQgzJ
	myYjBVJ0alpp80hYjbOhFT5JQftruoQV4K+/O06APc4gVHInYNzo8GgClhFF15WjLxSIbI
	DeH/jzR1Q3fSuDceXMbu2+Erv+Eej+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355985;
	bh=40WG8/2e61IMWsDRpUFUHulUyBgQPDILQimEoI6b3o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiuP44ezth3Y2JRlmZ1rSE+K74/8kwjO/TPviOWbw1FSgy5A9odQ4CmhNAS5FVvQq
	 UDUaAtfuZSRBLv9FRfg1M15w3uCVYBCbZp0VhNqgFw1Smij4a4R0cxQ2SZPoqyVLjs
	 AicmW2MlD5NO/bI58Q1fdMnkdKQD81oGc+uqKsSy2v6JMGfPxWJu30MP+o9FCc+8bj
	 MqE4JUcRg56N4kiMmPZFPZ1kcn4TdiLtIetYmohoFTLM7HszF2ESw4xMNCkK066M3E
	 ekn+f5BdBYQCBcxHmdv8/kuL5yYEWyY8TAOYBqrsD84n1ISi9RjJnAxjxKgCzWmRZt
	 rwpbMBoLk7bYw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 10AC217E1423;
	Fri, 28 Nov 2025 19:53:05 +0100 (CET)
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
Subject: [PATCH v10 10/10] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Fri, 28 Nov 2025 19:52:52 +0100
Message-ID: <20251128185252.3092-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D7A140018
X-Stat-Signature: f69kk76cj63ewe3pernby9rxwg7b49qc
X-Rspam-User: 
X-HE-Tag: 1764355986-433653
X-HE-Meta: U2FsdGVkX18TtOknqUCw1mU5SzuIb2PpJC53VhZOYPAUsuUodQ41WsEnjLC+9yY5nrwlIKHcYmV4VpydpIsHD6o9Z/4t5+Z9pCsndU8AzYhL8Z6dp4kx1ftc+ckAqL+MChHMsuO9ilJpubu3fjkdTeuFdAQmYPtV03BE1mMUsSK7LY9KnzocLM1QTCK/NjYr+vXvxZEx+camlA87n9my8vnl0OnwHU4aamci86ltiWnzb02YG0YxRW/4G98UUmF9n83CDRuThdMCepJmnt3dtoaFs3iKXO4qq29I/5ZtrAbxHa22lm2d5QQ13JxqrEqKTlbAqIPWhWPK1cY1qVCsYOXqfNTjQ1GtX+CJ3byXOxdnH+qJd8baCgQB72IcFPoZ1qQo/+ORiVlCMyxqlpKStdITOOYJFTUIP5dAHUBS8M22US7ung5ZxhgsABjmWXYNrb/JooSSV8H3/tcSxkZeafOyU5wKAZLZuZyKqgSKva4I41H2UFN5y+pGnjr4WX3QsDwwJd9XoZFa4mInw6XgaovwrqIOjmRKvHcgBxg43Gjrxo1SGXh9RX3rBvUxQEt7H2OPu2CcxN9+5Wpdgn6/kj1NpKwqMKXrpr3mVLZs8grADQNeJ5RU0Sht2v5vP9T381NTPF4dK5WNxDKi83FZPYJ413I2TLMNdnMGknP+ZapCl9bGm+HUwRbWjfmVIM7WaZJBHva2KYMXqOmCPHLurx+ih/uBOkZeHp5ZTkilc59CMa8fI19fnbImGDA8TzMZ8WDXFQxZveTX6JYHdcYqb1bbpJkySqz2zU8UJqCUdi06RT6Bg0M1z99gpssIzkkY9gQjVd4On4XBP+9LLGOM3ZmuD/vQ5hMpEfZOVZW5ECwhzjvhjc5Of0wSOKoGPlGLEelzEdqbZUbDYR9CIQ41W8nSCa+TYcssko1sVhanzFmSEEE6FuDRWA==
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



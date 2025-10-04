Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D0ECAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D060E8E0013; Sat,  4 Oct 2025 05:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EFC8E000C; Sat,  4 Oct 2025 05:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7E08E0013; Sat,  4 Oct 2025 05:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4688E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D40213C05A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:21 +0000 (UTC)
X-FDA: 83959913562.28.D9D71AA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92AA3180003
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AMlhrgUf;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiVUpyogTE7dsYhyk57MOUEnN9shDSt43s7j3vLTe4g=;
	b=Bok+kemNFc4qcQnLg9O7bqoikw6XlY5/hURlOPJYbkWMEr6Nf1tScIYkzCHPnDN9qhkted
	YMQIhCt0j5o7fVhLgCkYkca07R9ojidZHatF3BciJj3ZB4Bmuzb7JxW+h/EE9mT8f97UTp
	2rYz6FCTsaSNdIFtNQtk0EYeeclECMg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AMlhrgUf;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570279; a=rsa-sha256;
	cv=none;
	b=KfwiGFMx4HgKMIlomv9MTNFGDIo7dbdA++AggMJ6B8VopclWSfyNeOJIB7OQBlhpxTVrg8
	RlDFKehWgA07RuK9UyBqZf6j5y0JZBVHtZeDo68yHE/4PYQJ3SbbkUjwzvZ4C8vnT+uPWd
	Psja9XGH3VbhbLE1Fw89w2NQEoSlD9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570278;
	bh=D0Fu/ldQhntehM2Mq/IXQJTZKKJwzHie8we5EhgLjv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMlhrgUfj67oXsQPTFjfkhXxPYErzu07l7zcQuFt1VeLOO4l1kddXtiTb2X/cetOS
	 6XMF0S8g5Fu73Rg3lAVLMWykZe56IdRC60HwD9pv/MEZTOZ6Rsmkio0eJfbmu1nwCK
	 d4IdxOltI8YwNAtsLWvnJxFMf/9AVfESz8Ub5ydUncWsPC7OnRkCO+XAq+H4dRQyS2
	 llItYjnG94oPb9HEZHBOeRVHE+Lsuht91g6GWGJTZzTqRPBN3VlqNnsa57784xcp1/
	 Of2brQuMsVBOznatNjK2ireFQDvmFsXBo6sqcHe+RO6GcwaxxUcglmxauY2WbuVjd7
	 UuGUKAQRIUOaA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9C0FC17E13DA;
	Sat,  4 Oct 2025 11:31:17 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 10/10] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Sat,  4 Oct 2025 11:30:53 +0200
Message-ID: <20251004093054.21388-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92AA3180003
X-Rspamd-Server: rspam05
X-Stat-Signature: pc6kck88g1b7i8ww9auuor9kokdmkx71
X-Rspam-User: 
X-HE-Tag: 1759570279-433811
X-HE-Meta: U2FsdGVkX1+40aXb+vO9FYrTdJdA39hsz0lRHIFzZN7cgil83rzco8tLR/A/kQn+EOm0hrznrIM5WjWp8HmcqqbnrLHkoCh6sgKB6sOvyDTDI4s0agHWYJt2U1e6qf0bQ8W0Z+SDzjnIDh/K6YLNBjVUFY2cUHWW0hDVHzVpZudhKpXwOXGKVoEuq4rjQVd1VWu/1MOJv3OoBfxU7mPwlTe+doufJfBo2OI9zfsubZqtGS6g2joCMCPcJ404KgxoDOrcBH1x///0dPKfTZt2qj9xHkCx7L/lwIU60fOQYfcTCEtF+leAev0Y5/adGxmGFQlZ+n4LZcyxpx7IhWpEBwnIDTuU6K3eKckIpV9E2cyvyHtQ0exwSWjA7gWNfawOlipLQrv4zutBUXn8WIQalO/gT0UeSXrC3Hq7Zn3tMpSiL6gEFMnuQf3HatBuff9aIuAFbZgw/X5YdCEzZ4e3rhkDTpcmqK1FsUwg0PxkQv5cV/4R2TlwdaixII+RhQBAYV3Sf2oII9uC+wspQgIV3J28vkMatSPe6X0TTW774j4i22xj/RSRuGCZ4rUgAUtfdb96UWtGEPhZB9pjziOyvVtx1muQb/UHpw0aeOJhJN+bE8hEsRbDxrVXuc5pfe+u6q/zS+WZNKKcaUR2ncXcc0bqbE17sU1qpz2nWyvof9YD0m4jM4a2N4SGc2Z5cN+61P2/566tbdo13pZD6nmHe9/xaspemY7LU0TU6YSLO6DVDutmDfwhbNU+uzPTppn4E9UHnab886wPL8KIMzwDtRTiJV7y3ZNnIuok6in764HB84tJA+PK/ja8OyfiVPhXRedK8+v/OUgXEWTl9uJef8QxivboIsArQzDvcwccGVQLzbuJ1RbZ1Bv+sGP2xZM9G9Kd//whpTpokY8EMsXYqXRS67SENHCLdDFLDHSr6cNnROwnS/md60XrzjUJ+bg5srIIabLbjs3vbJEHgi1
 CZ1hoW23
 A8ums0ko+iXoJZCrCGqsxRfxOMdl1TvyPvREWOt+wsB/5ROSE/bGGsF6O1kUCtsFla+U/PpO4ubPLb3XqzrJyxBNi2J6ushDU8sS3p7UrPeeR2OL59XlaWEHVx7tU+haTAw3C7S3bYNlV2tvMseUQhL2cJAbyNAcFnQcQIpU5XiuGRuAzRyJunKO4LlpPgfnR3VK2mPd49Mm6QMB441OGfM+JG86MoWAc1LztKF6898T+1HadHmD162doCfKi9MSf688mhi+VS+vn1WNAI1iDBds5JCNu5UBx0TlF4PEf+aLvYp8HDKNsnE7CZaSsEU53PSS7sl5x2R6Qcp/YPHH+K7DwLcTOwh1Yq/kvNus9NWhU9OxFx27Gbewia5kdKbSZqMGxTvKMJ+1WY00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a paragraph to the GEM objects mapping section explaining how
transparent huge pages are handled by GEM.

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 Documentation/gpu/drm-mm.rst | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index d55751cad67c..0ce6e27f8463 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -283,6 +283,8 @@ made up of several fields, the more interesting ones being:
 		void (*open)(struct vm_area_struct * area);
 		void (*close)(struct vm_area_struct * area);
 		vm_fault_t (*fault)(struct vm_fault *vmf);
+		vm_fault_t (*huge_fault)(struct vm_fault *vmf,
+					 unsigned int order);
 	};
 
 
@@ -290,7 +292,7 @@ The open and close operations must update the GEM object reference
 count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() helper
 functions directly as open and close handlers.
 
-The fault operation handler is responsible for mapping individual pages
+The fault operation handlers are responsible for mapping individual pages
 to userspace when a page fault occurs. Depending on the memory
 allocation scheme, drivers can allocate pages at fault time, or can
 decide to allocate memory for the GEM object at the time the object is
@@ -299,6 +301,19 @@ created.
 Drivers that want to map the GEM object upfront instead of handling page
 faults can implement their own mmap file operation handler.
 
+In order to reduce page table overhead, if the internal shmem mountpoint
+"shm_mnt" is configured to use transparent huge pages (for builds with
+CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
+manages to allocate huge pages, faulty addresses within huge pages will
+be mapped into the tables using the huge page fault handler. In such
+cases, mmap() user address alignment for GEM objects is handled by
+providing a custom get_unmapped_area properly forwarding to the shmem
+backing store. For most drivers, which don't create a huge mountpoint by
+default or through a module parameter, transparent huge pages can be
+enabled by either setting the "transparent_hugepage_shmem" kernel
+parameter or the "/sys/kernel/mm/transparent_hugepage/shmem_enabled"
+sysfs knob.
+
 For platforms without MMU the GEM core provides a helper method
 drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
 proposed address for the mapping.
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198C9CCD19C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761478E0047; Wed, 15 Oct 2025 11:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAED8E0005; Wed, 15 Oct 2025 11:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6280A8E0047; Wed, 15 Oct 2025 11:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51C088E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE32D1DCE42
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:32 +0000 (UTC)
X-FDA: 84000735504.19.79870C6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id E63C18001B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=VHdkIRj7;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=skCYMSkooBF9tHzMROtH6kcpq20l36MaATfI528jHGUJLnz0N3qFM4aJp/MpxW1ZSAgqNL
	/ejii6DpmKkqQ6bcho465sR7bOaWMgnSiARuPKFN7VkK5vIe6ncxIWEUSNGM8SjeIOV84l
	ddyqUFa7TxvlskzjEfuxXUadUa5icEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=VHdkIRj7;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542231; a=rsa-sha256;
	cv=none;
	b=MssK5f91x8zKDS6AFCQPN2wAkKFmsBx9HsrZx1mEXC76FnxLObBHGTncNHr3Q2AuWvd7FL
	Szwuwo1U6s7BQRdf29MvmMfc6qAg4yv/YXyJhTymLOT6x9jHYhTaQflYLS9ssPsTcAV+Iv
	WnJYr0EiEae3CEB3UmYP5tv5jlmDgdA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542227;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHdkIRj7sg4VwSgsQanwXYtbK/UcvTe7EmUkEqqxHkXOqGzYygtHQ7zYKzTzN0BW0
	 DVlMfVVHuUVa4r3IHy86HYMx7KYMhmY6osKmaU4PMNbo+WlYSZefsYM7zb639o0aA/
	 ywmDIaSM8jVfaDD9GVr7KGmxiAMWOMnqZJI4O5IeZq7EcOlIu749ykkS7wXJ2xxBD4
	 Qb3umxLKhtjCGU/3anoP0khorYvpn7lF4YwEktiPC00IvTmS5qwmS1vf0pjGegIhmI
	 cxfqel3TgrUMeNW//bU37J3wRhpV55lJlZy1Qeq8HVTySPa4FIJHJRhrHnwvayxp17
	 yopEYsaDRwSIA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0BD0E17E1340;
	Wed, 15 Oct 2025 17:30:27 +0200 (CEST)
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
Subject: [PATCH v4 01/13] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Wed, 15 Oct 2025 17:30:05 +0200
Message-ID: <20251015153018.43735-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yhh4gjjpwd7gbadteobk3im1ck1mxkoy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E63C18001B
X-HE-Tag: 1760542230-425668
X-HE-Meta: U2FsdGVkX19fTs3BN1Qi7YQyGQSyAdknri8il9xX3UowAiQofInzbs5+KU4xkBpeF/8PFCSqhMezBfpQXu+ajGe0wgI+tUNsWd8oEzyD0f0kWTb9stU85eeBcAwcGmD0YF1VDu9/dMs5GVxhHq4lPzH+wYaXAVDQljX45rvQDmQQwqXoi3bQNp3uDk6n7t5+LTzgngVW2pBnQjYFIasuQryRn367IM4X0ZDq6pcJEF+tdYvb4uJX/opD3CMSj62WwS0KbLEALT+YqJ3jQ1uWC6/XiPSzv4rgOKa72+kFS2WRjKEq9jgSybVPF372PmuuNebztP/QEWOz7cAzvr6cFVCCBGDgya1PD69CWljqPftfl4Ks0bd4cFQSIl3bmgmi/sACf8fmYnTGeZi18H50Qw8ZS4DUTWbF9S+jKukajCGflpRIzE0zv1C5B10yQbuSOal5kRIiZXXtmzhSK8MHN4PlA8mgQrFewbSNYp3A1xkl1ao77F3fDYzMwF43H95orywrrGgFRV9lB4Km6iXGRChRfd5HV1EX4kX8/lDlv9++C9d9u8Ws5xVkm48AvOYrnmrAZrUYQEm/aQBJp53BPlSxIZ84F3BQoV1Ym66UWXKhxuNTd3GpguKAGXp2toB7oBtbX1ye1FAPGopupCk2GMGi+tB2OMUolpzRAYbqfHwDETe3AbheMNukL+Ogo2zjA1xyViNryxtK/76fKGjfF6lMbJozX7oPc4PxihuT+La22Y2gBKh3Reys6NkWXI0LyWo1PjAo1RoyCewgw9G08zmc2SxPS4KIgjZfgFEXmJBbspz6tzK30qH/zcPwnttB/zSgkZXV6H0hvhrsFMXGRShxnFIMgXRyDByXcJBmS8vRq1XdXHtnUv+5sFvFA4iPZxVee10vIEHXU6dGHqVZY5OevAuqGoJ12P5Je0VycdVe/8Nmk9FYtmvbIc4/ds7nNvvRhQBz21JPItUZFAm
 cO2nqD3h
 jh9obDJBQ1Zp401N93CbcV9OqPscXnYqxcEv9A5KPqm8oCqL/B5LvutDTwkHD9M+3bDWF89sTGlO7VCr5ssAMCQWXHsOWFb1O2zsF0+kJ5X2S6ot4xbSb47EkZnu+N0uqM/Hqlosni95qPZxcQUAWDSJjo2kQqYtDsbrQHMjwW+oRkMUF9oBLhS3xLUf9t5W6vhmuwNrfB+m5N0lj9ORbZdQryMFVMI5RSQFUFdQad8y3aqLcVsHLKv8XoSrdUoaQ2AEP0Qpy11r2qKWOF393M2Tb2JDvh5NLj1AE9aZF5FtZYdXquUBN9U5yU1Q/SbX8BjA0Oi7VDq58sZW5dd6OZgll8AtndHe5ZP19FDtjHyYNyk+3N60k7wpRvultrenezkQK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a fault at address addr, the page offset is
  page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT
              = ((addr & PAGE_MASK) - vma->vm_start) >> PAGE_SHIFT
	      = (addr - vma->vm_start) >> PAGE_SHIFT

Since the faulty logical page offset based on VMA is
  vmf->pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)

We can slightly simplify the calculation using
  page_offset = vmf->pgoff - vma->vm_pgoff

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index dc94a27710e5..be89be1c804c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct page *page;
 	pgoff_t page_offset;
 
-	/* We don't use vmf->pgoff since that has the fake offset */
-	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	/* Offset to faulty address in the VMA (without the fake offset). */
+	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-- 
2.47.3



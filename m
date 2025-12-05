Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2752D2F7CB
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCF66B0138; Fri,  5 Dec 2025 04:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EF36B013A; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF60E6B0138; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC5696B0137
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88F498A440
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:26 +0000 (UTC)
X-FDA: 84184851492.19.EBFADEA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF19C1A000F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=p3KHIGCS;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u61gmaUoZ9v3ZmsGpURrMvAa2JFBGizQKt9pLwRoWts=;
	b=xk2Vqj3/wU86iaBLcRDe1jSji7YxOoKAq/gpQIE+VN0y6bT/qNmpEMslYlU0YexDu+Cbzp
	7/c8ThFlsXnZJw3S6hBfZxqHwlenhGtxBXnaVnfFjKX6QE8YaPVhz61AtyLdZKJ4LODPTM
	NfXy+WpuN4KMvNRZY63v181MJ0MFz64=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=p3KHIGCS;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925945; a=rsa-sha256;
	cv=none;
	b=mp4LL4p+HnJTHbFQAjpuXVKkulyiA2UBTy4RhrcfN/WxUee2cBmE8FgasRP9NxbfmpqLzY
	gszObkjizRSxtV6RyMPO5kCa19SZes/fpdy7TFqerKkmKMJkoOADqAPMbdSv/TQyck2PZZ
	5DfDI6IaP476NhZQvmz4qKTM4XCCx/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925942;
	bh=YS8/vqBJoLcfbhBEgaog8sdplpPEafy556rfQqhGLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3KHIGCS0+d3V611YGzn+fvryGkA23F7J+LHEzGjfvPmDl/2vd3mbprsZidS0foz9
	 FURYHlFE70sw72zylvpcb470BTkqesz+P9n2CbHxVq2+Z1qmxIy/xP6qUSpmh63+FJ
	 2rysswTRYZw9H9aiXvCckgHGDLyGgCUEYul4KrJL7UZwVxawAeZxz+0SS7O3kcwz/m
	 Zpy8wrFr96pxBcAFeJJdTVhtexjpAbaDDnB1dz0qby72ZTH7rnfSn59ESe+u4Zstnx
	 bRdhgb3e9gjir6dzqVYz1XyJct08iyiLEzJI2uVMJxSXKCPuKtSfUaPZqQuGwdAlEq
	 ulRQMuo1IEZdA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 12A4717E1154;
	Fri,  5 Dec 2025 10:12:22 +0100 (CET)
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
Subject: [PATCH v12 01/10] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Fri,  5 Dec 2025 10:12:07 +0100
Message-ID: <20251205091216.150968-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF19C1A000F
X-Rspamd-Server: rspam02
X-Stat-Signature: ankg4g78dy87fz44co5or3mk3bb8wqj4
X-Rspam-User: 
X-HE-Tag: 1764925944-578427
X-HE-Meta: U2FsdGVkX19BLvN9OBIc01LAhZH+hgGWrgSKT78zRW0puw4H8+zh88NFfMHeugwW/WyZFrw6hJBiti1GPXNGLK+MxlOuFPKNl3wRI4u39y513mQWYHYkliGgT2eX0v55tGufrYGtm6edONhUu7lvAzvLrEI+1AP+IFRWCqChPfhJOVyuItSM7UBrbvGkUzQURdBoO/eKCpdwdOXamon0UEIpKwVoR+vtpowa653Rw8b9hqHTUKdpi+adPg7GLu9SEzjKj8Di7Z3u0wWkTVvnVC0DfQVpPvLIEkzgiKu9hh/BRx2/luoF3vYDLDAsgLYlEIAtDdDenfGE96mfdMV+LuNdoxRbxhJkxAe/2Coct8sqM3/FUdldOf7vrxcdOr/5LRA6uJ0nzmpnjD13u98IiUrzuXu471yA2cF3a8LKPJVRMvbZzp4GOABRS8ZtAlEPdmK/lxXh82KypcdE2c55pJ/YeB50RjhsvmDOr3ugE1EChIHqIiC7UHTmLHfqUYPRndG8PIjPdZBnd9wUpk0EWw7d1GJY7Y9GxbLkDe/fQj9gLiE2//mqerRTYJXdqqweLU44WHG2GJD/HdquED+U5wigxv0zuM4pJs3jO+WgJkel/8ytwE0Y4RVEUij1gZ0+K+94B/D0fFSWNanG3YnMz5w4bBcELlQ9OvWplbByd0SXDqoHgNS4C2p6ily+R6ud+YTQ4xPXRKexjU4DI9udLUuEM4oDMxUQwmDJu5OWPWfSer39fSrGmHikVo7dc4nvPvI8Imj01UEV58BU4vJJSCj/XUXHdkKl93AY87i+M7MW+vuIenaWv0rvw5OsFJYEVZWICd/xFjZowhwbeSZNFkFouVEgKz9aw9wrKToo6YPR675fdPICT9zZNDOF9jSs2xwLr3CHNNTOmptKrJyN2OPrUySGxs/FJraGzpW0ImZ7aznGYJa5vyLUzu9tHKMt42X6iUuhcNnHyzUZyTQ
 Lte1n24G
 X63KruEFyj4Up8f7ru7TJcn6si5Fdlc23ax8drhKbTqH4S9bAioFyGgT4Hrll7Psk90NvnBK2y5+8vs4=
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

v11:
- remove misleading comment
- add Boris R-b

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index dc94a27710e5..e47ab3ebb5c2 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct page *page;
 	pgoff_t page_offset;
 
-	/* We don't use vmf->pgoff since that has the fake offset */
-	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	/* Offset to faulty address in the VMA. */
+	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-- 
2.47.3



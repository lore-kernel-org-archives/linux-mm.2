Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DEF6D11701
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C12E6B0022; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B7F6B0029; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FB66B0026; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDC86B0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50A5EC05B6
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:29 +0000 (UTC)
X-FDA: 84174129018.20.16EE152
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82BA9C000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OAqlbf2t;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u61gmaUoZ9v3ZmsGpURrMvAa2JFBGizQKt9pLwRoWts=;
	b=ElbM4zEBxZu/UtAt8gAS++KhYAeDG+GrU+wkeA4ZlyvVv2pPzer3+C3m7VniHrYeuzNtHs
	q/7rdEBacFjzxCg2/wS/5s/TG0co9tgWrFbgigKcd+RCtWBrACyFRKFB+hCIKoXWm29tc7
	hJ0+tCN7LkG6nDhZwGAvfKy8UIsIW5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670647; a=rsa-sha256;
	cv=none;
	b=H1zf1uxKQpp72lNKPGtBoA/249A30XHliilr/TbSoN40t/3dos8MfoReBd57QBs0Q7yJEB
	TnVwqr3JSaNsTBc7xAy7iW4b0R7t1DTjYlHKWTHY2xbm7GWbBU/4LCL02SU/Nc5hfHTTQ6
	4eIkHpdarGNzKg5FAmEvCp0jCITk0E0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OAqlbf2t;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670644;
	bh=YS8/vqBJoLcfbhBEgaog8sdplpPEafy556rfQqhGLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAqlbf2tuonZCKf99vdYXdAbQ78Pg0EnAKueTc8M7vL7PlCHbc/gxtVucuQdTv7y1
	 0IsD7GvFknmSsSEhaCQy2E+irHI9TUVYLt5MLHEynjxBNUCuml8Zizl40qpce56JAC
	 z10FkvK2o7xoTyzuh8/k6JyOQKIesWAF5tAfX3TKz9Z3g4T3PzmneqbFmiFdvjMjtA
	 Kfx3fV8erzCUAkd5ckyXCvBPGONeSR3ip18LZ7CUe3O2ZTyup/jAZiPylc+nmEslJO
	 PMf6uwLDnCk2hRg698olJHXNMckgrRG4l3BIEXqTYOMh9YqsR8C+0Y4jm0om8j5Ap3
	 lQiE5Gw61moZg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 13DFC17E1157;
	Tue,  2 Dec 2025 11:17:24 +0100 (CET)
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
Subject: [PATCH v11 01/10] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Tue,  2 Dec 2025 11:17:11 +0100
Message-ID: <20251202101720.3129-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 82BA9C000E
X-Stat-Signature: is9bep6ei4w6zt59z13en75nhu99cfxs
X-HE-Tag: 1764670647-556947
X-HE-Meta: U2FsdGVkX19/xuqgSAnD3C9qIXjic8aXL+r+W7HcE09V0Ot4CZ0i9r287eC0NpIdY1AZEGIbzu+oAid4biyGcGa8ZMyuqdKrz1MiIBF4LvyknS/aF/7QzYmvzTlFAPE1TjIJURUJKRlxBXd3cqU1RXM/KcEvUYodnlaDRataNnGikO28Q4U3mKoVKPRpHM+8x/FVX9Eegmm0i0UBVcEtiZ0cs5yFhNZ33HcW6vsXvkbVy9iQQfxYnBu2qld7WWwhuw8HxMmfjQMaO3BTT/+1ItD6n3rfpKIT+lQqqCp8C78rv8nvI7fThK9gVmxHQzCOjFJAnhuaV6VKyJmNiGrQLC77f8j6Smw3kaGzE11ypjNU+xJVluyBXV2y+2gC3mJ0LNH33Ymv+iISChNiFx5wzY3uNd9iGwYCv7T7IJH//n+kfOIR0psS5HBiorGdn2+GvqxbQMWDitWAd7/M4ZSu1FtC7FEotVlsvmIqZlW/NOKA3YdgR/qHUjZOAW27Qw4LiUNouT/r4VxSrwnjfTFS81saUrW6HAWY2sPxKLVmVNL4NjR04PZpJSNrycMNvpzAFIPelulxBo97EqKNY6aHM3FSnB7QdVfhcr6euMUVC9Fw/6QUhmo9zQNUP/5FzuLPlrFg1sen8LrdO6f0d+IyfB53go5ZanqLpkOQiA6+5r287L5fr++MpsffsW/yyLKrMmWqH9wDO0vOYaLtIprInr1D4T76X+mqBbWpvw8RomoBvdCOQkqaNSHp44sBD0jt3UhIThjm7LxtSpNQoV6k1Ecu7eYrZnnHL76jccilYrurjMKUlG1N1BZvQ8HBO1IhYTm9s6ZV3wD4dZthyi9Bss7a7iXOCKDUmDQRrSfvSqIdQq82EV4uZePnc4PfkC9guKZu7phIHovU9/gnqLJjyCF6g9dSlwX/ZpiZ6bi1/1YpSzOrzyJtVBxofJRjlsiVfsEU5Go7/SXzdbUA+3Z
 Wv1hxw/d
 EqTS8xArhgnL+WafGRIR0cBpUP83nkX2uaKT/NX2wHybDgwKA4qgnRcAJgBrE6XlGNlKgUP+GVaOyld1FU7jS0AKXOq6o2PhJAH0ykQw4W8jJvy1Mok3TrTRPSCVPIIGk79ru6NN+ep47TPG3hMn8aoEPSq7ab7kXgsioc0gLnanuXZD04vLCM2hQMDvIVTKQxMS2wJIeduUTrXLhsD1wBFsdWrGMIqq8M5iVKZ7310KRBfIGeS2fsSfBNe5Z1xvsWNkNJ5WUN+krzp1PYUBJpN10oGu/rHuyz+MfE9tYsCBCj4H8O+nAk0Cf+xHcPt7u19CJUWD3p6cdOWHKfY9FpYxL3Ip0eCsWEtWSQbfy/FsOCUNh/N6rp/uyq8bPL6F0VgCq
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



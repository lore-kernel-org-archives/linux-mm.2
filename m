Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21854D2F7C9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93906B0130; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D4C6B0137; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30C16B0130; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0E416B0130
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FBFDC054A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:12 +0000 (UTC)
X-FDA: 84184850904.14.9ADA5B6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 99F991C0016
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=m7o7ziM6;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u61gmaUoZ9v3ZmsGpURrMvAa2JFBGizQKt9pLwRoWts=;
	b=AICi4rYiE4djU8ziWLsSLpYb9ApUbod2GBEQW17b0dRVeTqyREfBOo9oRjg0Kpso+T76cv
	qi6iVPxxLn5/b/CEjcHJEmZR41RG9WlOt+XAdqotIwbYMfSJk+ypx07RHoAKg8HNIt/94b
	0mWRZgz0LZ+9QOc6u4XwkN+MYPOTAXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925930; a=rsa-sha256;
	cv=none;
	b=T3NLsdoWLdihlhRn/QZzf8soDBiSKlHvwSsjNLi0caZXBAVhlIeszxpS5FcP5il8qd0c4n
	3jL3oyUOpVGX196Iqiycd6goSWGSQKAgU2i4y8A8bwD8LNmzlxELVANKndfosWrgu4M1oy
	vNUsv3Gwn6IpWdY6sFcwEcZ2fIK6vuU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=m7o7ziM6;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925927;
	bh=YS8/vqBJoLcfbhBEgaog8sdplpPEafy556rfQqhGLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7o7ziM6r3aamXx4xy12t/bf1O+7Hv6cfTYIazu5sTd9fF7DkjNIntugcB+x4G5XW
	 KtRtgsw36Nn1W0OnKAKH3yL1KNsL15c35rx6KQTaWpKQj9V9xl1dtZSUHyKCy2fSqo
	 AYcgyS9Lj2G+AyZsNGs6VH+hzCHXZzoBph1RjiA31lMDXlY37QCPWu1eemASbQmcjY
	 ik8mSA08i3B0l37mY4bPqqxBeErwKqahaHfGYVq11Q22F+x2VZP1MWEyradZbGQSD+
	 XsbE6SbF90VCwWQYU7toxingweUsDYNAgJwX29+RiTIZ2fNguewTEfvHdxixs01tQX
	 lAemEUBa11JXA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D136017E1154;
	Fri,  5 Dec 2025 10:12:06 +0100 (CET)
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
Date: Fri,  5 Dec 2025 10:11:54 +0100
Message-ID: <20251205091203.150895-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091203.150895-1-loic.molinari@collabora.com>
References: <20251205091203.150895-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99F991C0016
X-Stat-Signature: s5kecc5uzgfc4z6snrjkyj6jcddzrrrq
X-Rspam-User: 
X-HE-Tag: 1764925930-784565
X-HE-Meta: U2FsdGVkX18KI2zLzOp46znWS/Clw4ULRIQ3VLorMMeGpB6Hsj36CBSzhycynUG+d/0m4RGctBqh6JjdtLsJPtVq9gpmCdLWqK85UIt+8ZoNpJjpZ1nDGVh60nYzshgqTkvCSWvjY+bmweG5tjI6yarhmfX9PYxsYvtzHDf3LnQMiZpPveXzb79aeRvfLkQDTSMOg5hzk8QdaYWkumex3MBPbPNQEvtWby1WjFauZbjFUMT8l7SievJaiuObrY9yM9ZyKOGWDDmyypKkXeX1THQXNLPUMBCI9Se6STtqVP26343Sm5eVlIO1oaBLmqKx3L395iXrNs8jDkmupt4JG7iABJ/vPWPwX4iqSPfOSLfftD9/lC1V/JdeKCZ08Eui1VbHG+jjd5rBAGEC2BdTLHzQr4z6zU1vNc1eKyaDb48K6HF4fWGMOYWRuU+TndShhaR/mYX08SIor2Op7lmAc0shT4Z7GgOSYhfHepYHnnzVq8jnkrNte5ZjwNVC7GIBmb9sEOlUfBQO8DHcnLOIvUmgd2frHyKeY7+YkT8BxO6rpPcBMkUzr3vdftHlbgcp0QH70m+UQRRFbsO4gtClCGwCry055ASPigBO9+q1WEkZ/oDTQtxznrHjy1NTHG1HioqFJxM2I2CtWkXT91wprMpDexkX79ronRflkbfvqfKeiVDC35awf1+Ux+LBqimXMSr3EHvM9NsHIXMrfY0rCRXqlpP4c8cSY7miFYU6khbaHd99/aT2Qt9OhYbEuTB2aFzQ1C3G7/EU8zuU28KzXaGzXsyRBo41AQPtE2j/Y8vTSa5dC64R5wMHqENDEFdnfRA8HUmqloofKgm4wKW59ueoc70LLsGafTmq7y85se1GyAUwKQl4cw6ts59Rm2TlI66inSkhVQSh7rq/FkeRpscCpnO0fZq/N/fkh56ZiQz5Y6wTG84jY9tp2jvYyIJDIuG4VfzQYmhIIE3amPK
 x4NXGGXD
 2c1eeA41JXS3a5JnKOnPbxhOUgkgzP1i2c8EzOlpA0a8FKiYvY7jL/7uFEYQ4BEj+YS8PtmWVf6jfu3IDE2Wd2Fq3WOzwUoERMF9LpVkcfYbhmTHMtGe49IWMncWh+tWzpNW1ZPOVkxhPZVgYD2iIpjLF+Yx2xnlrGm9OhmXWRnLqBZRYSq/kDiMteFfbJ8O/vn49ipO6RitnRClplqJhkBwKDamqTRJQ+aE3cnF4cC3vbd/xHf7iv7C68lxikVQjBMl8NtVuZ/NFjIx+RFDPTRhcQO+o0A9zieCHEftdT9yhMKXNOh2Bj8YJBHRY5hl1WAu3t7SKwPYAahD5vEfpfqMPJU3KRaMVnUptPXn8VnsHESi7uswnqCprKzRIGN2P3YWq7KJmjphA0LD7PbWlvW2iEKsTioZQTuR6m/QCkJ5J09bVgdfYqsTfH5poFql1WCL3af2xY1bhUnN4akwP3DJuBOO+h7zBv0eq/H0XzElgjrd6imK5fu0+Cie+ph4xCf/T
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



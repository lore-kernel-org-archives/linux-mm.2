Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90AE8CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E4E8E002B; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0518E0029; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27668E001E; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2F098E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33D9C88EA7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:13 +0000 (UTC)
X-FDA: 84109833066.25.5BABB99
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5559980022
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kYKGbltQ;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=v+9jg8aOPogO46cetTb2HeTmhLTN9ncVUSydASYgyyDGEdlp2nnBBAYDbig+pq1t9n2pU9
	mFJLMOlUgOItwv+szfEj2V9u/UIRnfIbTW2ON+ncUXFR/J+RJhkEa6JW5KAF31tsfuiIC0
	66dq+MJz9Bv5dLGkmRomJGkOYBjspwA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kYKGbltQ;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139791; a=rsa-sha256;
	cv=none;
	b=AnRBtK6/LTuDNSv5dhcRPtPTTBgw/j7iNlIsNWBV1I/WcWeBf+GDBMl7yDA8Pvt11EZM8+
	N+a6bpL9OESpIWV68ErthONI9RgynjuWLD0a/7F+0GhQzQijlqnGCAZfyZgqWgscNDod5y
	F7gvBx+s+P4puvE1pXHMPp7C5wjDXqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139788;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYKGbltQKSPQa6YbnxxGn/A+cBP6YJyJu1PnpI/CJ7U9HId/69cWR0lhjhHn5tAVd
	 VI2OKYdYcMbo2K/cisnj0ARnfDKJ/Eoy/uDBjI7idbD+lebXr3B1zPGhwV3qYXPT3v
	 9/JYtwfIt6nIuMjKBPQGSDG57MPrTlNGOuY4qXmxvGqJoX6gYh2GCTSOQpF5uL1AUd
	 KT2BJRO4Bn0V5X8147srHtIp9ZglLJipIgxO7xadYuWUNgQpWmJCqL3ReDFsqT9okT
	 uDbhhXk8Dm5a0P4pDsML+eRf3L0BIvjTviq6wh8PWF7hfBfBqZBT2wRIxmQpMc+/h/
	 MJK1qt+7Sp/0g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7E3E717E12D4;
	Fri, 14 Nov 2025 18:03:07 +0100 (CET)
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
Subject: [PATCH v9 01/11] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Fri, 14 Nov 2025 18:02:52 +0100
Message-ID: <20251114170303.2800-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5559980022
X-Stat-Signature: 8i4jyyzayzsj4cxxbz99b5pedse7x4zy
X-Rspam-User: 
X-HE-Tag: 1763139791-348056
X-HE-Meta: U2FsdGVkX19Qb5SvZY2ThHle59/xaPzrKLtwQrbV+8F0LM5V99rIdaXWETZ+jrZYT9+lVCb12RMxO6Ql5com703zPapIBk7/kcUg2+Q1a3c4oFyi8mR7xSB4xbIuhVaWyhU73HSYecyrbTuWAnxVxEKoEhTDAhG5BqPXemuRv9JSeTbSmrvPyuJagLm84NH+3n+KXyXyMmxdZg9b/qWCi0zwZKYKy29CepBNj4VblRd4LHdsBW4/2185k/a8wA6O7oHBCUZ25ZzpVYORYQEtuoNZQ4JjbHcsA9HQk9DHMajOTjI8RJ2BqNR7HuNh7J5Duue/botpVzTtfj4XMvqcvN0t/F0DnBBso8LfKN35QAWA7mQ7/hQYxkQ6sTJNEasuNSzqB1WPA5apZigImisP2E+QpKen++LqJyp7Do4j298gNbhXltIFyxswJURK7TXaNLbrvAopHCqgUAvy0JfC9NXkQkmPKKt7g5iBzLqOL8UXwfziFoFqD4WUQEaJYJEO/+jpLlEHSsX3Q9dvIJPmUlRVTu/KAJ3CEchoplFL5In9lCQUmXKPM61azewEboC9Yhwd0Ex6S+s6u6s5LDItxjgDuMdmF3uws8Qzu9hT1+RwpFYM10hsuNghz4zGch/Xz4dPteLyHfUmENuv4Yg3j+L3FDwO4ZZ6YGlIXe7bcAS31MeIO73CqJbqERe8iITxjUZBNNxAZ261O5V/H0k0Qqp2n7fGTzU5fDZybsVf6NHMHYK5yjvVRAe2Di6RIHVT2ufhauzMu+rsQLU7R/m0cMvtY1CbQUXOAwnpRcrILFcwcHnmcUSVYsVigXq/C9aamQueFADb3bbWp8twmuykqIl9my624q3KkKQtveHWoS4EwFZFbl5Vcznael+CLmyn9RW2A4It0pPiXYXlZgnuQqc//CtUcm4oyVfkYt/OiN/5HoplQLg2vbrsias792U55rU73+T1jioK6uOy8Pl
 KI+X/Ib/
 DHX9r6w8fa7kx+nrowjfzUEWptxTHTAHVH4SxEOfueKJ8b7BZy99+Lz85YIn/UO6GgLA7ZAECok624v63BXhoaIkK2Bt3XZ9UTaOWJF7PuNO0lCNCa5RYdnp3QeiPFTT8JZe8yOYTqM01UI+wqD9tob3vdmy+ORkvgjnE305nMtGsSCtFS4QEzsHLo1fkIVlyOt5RileXkU7OoDOtB1j+9pBPLzA/ujlRYiTr355PynhH/sSblLL4OuOa6TOsPE++9231+miF5aUn6tydNLwxwAvkO7rUuddxdE9+6hUR8BIppZ66dViXWRIwxo4rFiC//i88KYY2eZjBtEJ/A1dteLIdKloI0hDYYXnBaQCm0vmH0J+3k/LDluihjfcVQCwDN40Wh9lFMgOJkzy9ApaT7XHB/qaCh3IuY0sX5pKsDK9RGKdGxvStczjiwgAC4apBByijTZ1Hzj+vRv6W3vaY2yINb7abKY00nvsVHhLIvgTwCL1+swj8w56mkMj+9QXD/0do
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



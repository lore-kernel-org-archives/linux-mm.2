Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7650ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0A38E0029; Tue, 21 Oct 2025 07:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5177C8E001A; Tue, 21 Oct 2025 07:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F7F8E0029; Tue, 21 Oct 2025 07:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1861D8E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D55F914045F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:10 +0000 (UTC)
X-FDA: 84021905100.25.761BB9D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0470F40009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iKj1EaCG;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046269; a=rsa-sha256;
	cv=none;
	b=VIwMKneKbpx54so98Vzrk4UC7ILyUU7Y4NGnblZErPs1Tc8QYyXRa7o5nYgspO7Gos3YUb
	7P9P+sicM407KZzCYURfaEthKZuVQuEcp6SLskLUJrVQBJSf4AXJeHoBDUS7QsEIGO1n7T
	JF9oKA4D3e3W6+w1/sApmz30ZSFnvHs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iKj1EaCG;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xz5DlnDmol9NIp58SrtPuU2M1b2voL88a0mIXai4rC0=;
	b=6KmiaFh7VTPEqQWsL2nb+CWQWFkCanoMHsgMnltgN3MVJb2y7b0scI/p+Ypeo7rKssGF9d
	b7PQJXCI2XTcWoXxyaxIheNgT2JhnUe8M2gVXdDTUQehMhlJfenM7D73gAqOzTdJFbJZHT
	2hAI775IT5EwKD52BnHGAxmT5lmMOSY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046267;
	bh=p24aKtUnOv8fOlBIkkg8gEu+LqJuafLvKyczTp6ZjwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKj1EaCGNTsPETrUe1acWT3vmK9qn/ywFOv/YCxZDwL+hs9ub3cAFcGJo2vdx5riY
	 almv8+xbUHu+/4zbSVqz6d/uyyMEcog7ReB8MOHdwVxOHje5lPnAViqmea6QSkQILS
	 KoH9ThSTjTF0KXo8po71Ehfap7297h05xXFxl0UxZhocpanWarLMtKM694SjxTJ5a6
	 G3uvUqza7ACZLNO7WNgwJnyx13jwf0lzemdWWanDkBa5jphjjOm3DseWwPuV5wvi5h
	 H+zHtLwBMzdMr3kBUts6BSpayKeR+SIaVEwXplBjHINiqkSbhQOtL2RfAvo7a89oWf
	 dyEilM977S4XA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EA72117E1404;
	Tue, 21 Oct 2025 13:31:06 +0200 (CEST)
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
Subject: [PATCH v5 12/12] Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section
Date: Tue, 21 Oct 2025 13:30:49 +0200
Message-ID: <20251021113049.17242-13-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xk37esr6dkdwhn41ye4xr34ttdj95pnq
X-Rspamd-Queue-Id: 0470F40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761046268-546931
X-HE-Meta: U2FsdGVkX1+xvijk7blS+2DRi7OQPckaZvD8mxlHB/aT0LeLvlB2LdEtuvjMH+W4rfGW5JXXzii5JqocLnNQZX2nfCjEbbub1hTskfJ85H7AVLaZsd7fARXQcnYkPcmyQEzXbrWRHpbMv5tMxEjZNC8dHlDP1RIgUUNEBamcpJz793KpGUqnMgEX4+p4FJOVDND64R3zTIA/DRczTIikWt4T/NIPb0XT94txX+AacbYWKAHu05eBG3zVBiKvC8eUkefqUHFePfp27Fd1nH0CXYg3uE+3gyixdZioxE5XPy2vEmlB5YgDTYSIx4yz/2h8t0iD1uOCQ6PgiCssrabojYcQ81uWGDhIAu55gVmrPGTpjRYznapSJdblCAIprNzmoKvN0B8FXVAW0+cnWRUnQJHIGXLTqCLQto5O0T91BCt28Uny3xE85fRRCyFI05Egu/qi3qVCO22NyQuNwiGwVVeEE40gFgmr/mpUnYH4Ezk+gQG5twU6f+RWTRydGl/yxEWZN7bCc2+lXAutTx2d0wHtk6o1FLTntmCkNcw9lByonjPwgQycG87+uzP62I24Tleorjwig9WnhZXbvw5iDQ06yog8RSRYg9tut4E1Ndj5BPUakiSw1gsIk9nt0yASyt0CP82d2dIMchUmM34rKNwxC+UF5s2ZAbiRhFWwozckzxC1VBDZthr0gCNw7S4ElUGViuiAO4sPsCBgskMQO+s0OrpFbBo0r2HYmxqYcpUVGUARi1s3eYu5wJcJj0eAv5RKX65eR/9p7BUU2XhdR3Jjl05r3X3HUuYB8TZf9/uLGR05YiQFZRFj5xIyg2hXrVUkuEPiasnfKZyfati0xM3RZtK2omKz6XPIR0+J09ZYZit2dVIM3BpS5y/qvLssAV8zjwkFwn4ggYDIV285W9V8Po1jpRy01l1JiUTJU+6pDtMNsECUTAXtQnS/MNar5ZIN+6xYKvA4/dAC3oz
 qCCPBcUg
 WpQvuRy5RX1J3KxSKYchXM4kDr9qPRJ+z6pUMJ1fbcVzMEgPIs4ByZdW+q7U1g4R5uu1qG52Hn7XgsAHPc5pcLQ4xKMSdcXggJzsAOAMQ10YYCf6qLGzU53E26ncJwyrB0PQnLqLcOd5egheja1o0B8eE5j3yLMdpuSUhXzjAWBW7TVvV56XIL6XwjE8ZbWyx/EE42RoCfLXf6nZCR6+PzJs412Pka/6pAQ5DJIdUp8J3g7AonmV4tJKST7VV5cnpgm/qtXpBD9e0MhvJL7iQXxRBLxPh4yxhQeZuEy4+GLdWppUpGlm2XBPGbV+gqfF3/G3NXP/5cA/5ddZvYMS0U4BEip8WELJFaxDHGgpoz6brlZ7ANGzFM7JArMNrTQKZTGHg5fTjcxQHUuudr/526FAIK1sJmrLtJOz2P0ixY5nttiNvV3QYAUTH8BLvSNphdvvOwNOh6vuoeVeZjRgJZ/IOh/X0DT624O70O6FlDB7DJc7NDMnq6dzXPWFJqHGZY9Aqe2LD5t7pnyk=
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

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/gpu/drm-mm.rst | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index d55751cad67c..3d6176adc7ca 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -283,6 +283,9 @@ made up of several fields, the more interesting ones being:
 		void (*open)(struct vm_area_struct * area);
 		void (*close)(struct vm_area_struct * area);
 		vm_fault_t (*fault)(struct vm_fault *vmf);
+		vm_fault_t (*map_pages)(struct vm_fault *vmf,
+					pgoff_t start_pgoff,
+					pgoff_t end_pgoff);
 	};
 
 
@@ -290,15 +293,27 @@ The open and close operations must update the GEM object reference
 count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() helper
 functions directly as open and close handlers.
 
-The fault operation handler is responsible for mapping individual pages
-to userspace when a page fault occurs. Depending on the memory
-allocation scheme, drivers can allocate pages at fault time, or can
-decide to allocate memory for the GEM object at the time the object is
-created.
+The fault and map_pages operations are responsible for mapping pages to
+userspace when a page fault occurs. Depending on the memory allocation
+scheme, drivers can allocate pages at fault time, or can decide to
+allocate memory for the GEM object at the time the object is created.
 
 Drivers that want to map the GEM object upfront instead of handling page
 faults can implement their own mmap file operation handler.
 
+In order to reduce page table overhead, if the internal shmem mountpoint
+"shm_mnt" is configured to use transparent huge pages (for builds with
+CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
+managed to allocate a huge page for a faulty address, the fault and
+map_pages handlers will first attempt to insert that huge page into the
+VMA before falling back to individual page insertion. mmap() user
+address alignment for GEM objects is handled by providing a custom
+get_unmapped_area file operation which forwards to the shmem backing
+store. For most drivers, which don't create a huge mountpoint by default
+or through a module parameter, transparent huge pages can be enabled by
+either setting the "transparent_hugepage_shmem" kernel parameter or the
+"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.
+
 For platforms without MMU the GEM core provides a helper method
 drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
 proposed address for the mapping.
-- 
2.47.3



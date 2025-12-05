Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6263D339B3
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0E86B01B1; Fri,  5 Dec 2025 13:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A506B01F1; Fri,  5 Dec 2025 13:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E61C6B01B1; Fri,  5 Dec 2025 13:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66DA46B01B1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31DC31602A9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:40 +0000 (UTC)
X-FDA: 84186238080.08.06BA588
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5FF0C10000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gJVyk8Gw;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958958; a=rsa-sha256;
	cv=none;
	b=AplqRd1UAYj5YRKaEhIW0Pza4+IQw5fecxFid6x2ioa7Qq1sKuqShmYfg0Haxv+u6+ayIV
	pa9/x9iEF2JHk6gBl03pA+vLFBlqEB8E+ofhXNeI03shdwhPS+5uY2bqOW2L3ikmj/qLxU
	MRFDdxQMQb63LXz1+keLIyg3+tW2lR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u61gmaUoZ9v3ZmsGpURrMvAa2JFBGizQKt9pLwRoWts=;
	b=6uesq1A1XU4eoNuDdmOfAy/QbTj5akxFciK2jKKdsvYcD+GLJWB+InckWDJGl36EAtWeAx
	4s+EQ1tk6gaSLP9Ga7jsHV63qPlk2FBea7idET1DsrYnGK/TED9olUu1N+9EEWkSPtIAxf
	U4WhFRjLk6t3hgCgp45iwglZfQMk838=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gJVyk8Gw;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958955;
	bh=YS8/vqBJoLcfbhBEgaog8sdplpPEafy556rfQqhGLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJVyk8GwvhhWGI54AEpETBCfNvxuL9VMECU5vNSrm/yMQXGJV1gX41FydeCCopRib
	 ioHw6GjLJkmPFw9zccEHJLrdlHlYRpcUUrDC2CoC90ofWBMi7WvhjICUUZrWwFVbHU
	 hcWcKMB0ADfve5PF97EdkHoVtoWzPm/Jfmxp2Vw0Vnf6ao6g98tx8HfhJ8CWG5yFf0
	 Q7XMahxXIxOdD1+koHUm5Yk8mJT/2IMd0AGwObl1L8/ofN8/TEbyoVhcQq2xE0iSra
	 oPW7sRdgdDowTSuY+S9wgABe7PCUj5uzC8V6kc+gClg3uAGVZ7L7Arl1Ar7j3krcOU
	 gZB9rvJDz246w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 15C9017E1155;
	Fri,  5 Dec 2025 19:22:35 +0100 (CET)
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
Subject: [PATCH v13 01/10] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Fri,  5 Dec 2025 19:22:22 +0100
Message-ID: <20251205182231.194072-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FF0C10000D
X-Stat-Signature: e7ghmjppa5gomqd9zzkcxfo3h4f5wbg7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764958958-318018
X-HE-Meta: U2FsdGVkX18mnons1E4n4pAOBv6L9F6ZTPyDGwoR6kg94zHy5FveGo5+qoIuAFVWcogY1zei/fZBz6WPKhmTM3hfNAspP7eQX7Vgqpn8aMIMdWMnLenx0NGDcRuhPBryjsaT/Px7dYxI8V9FDP/WufDNKPPvjG5SB4JiY+jtTMu1kVlnC+1r8ob5EvgDELsyZKdu/F3FT+Q8D0MFHdujESyw0K3IEUY5JpMy0UGhqbrUphI6kkEF77IpHavyo/hz960DdTGsxJdKQR1h3Rf5ydTeY7Mfe6h6zRWF3YpGgAeXAoVHx5kUNNFXihz5hY0hh3Sv/BzBurmwxc391OvWx2yIHtVdb2+dq5Y1joKDU190QwDRRWiSnOLXQeFgNlUFpj9hotAb+zO973AyiIor6003fQ8na8Law1bTcZM6RLJ3EJL2h365czZZ4ayhZbgBTi3hT2EfOVcMXuAYxvzuRSHKKnjghqBx1R3ay0g/6ZVz1mmedH6B5Z4ooHtDCtyl3pmw3onEwUZqztK42pSNq2PTfgVRjmTcT++LAhQGiKK3zlTrDwlD1xxMMnN/rHICxpcNRn00WBk8gXK/++zWp1yyE1VLFWGIR7XfW39nBydudiHFY4mgbHZG0O4MY+j4BQ9+YMYcwnLVy56g62aukI5fgpiW1gQ7w947KowHNy6LSe6KcZQbERS+RaB9HUBlN5F3tRE4TO1LChNAIkEGTu3oufB2vBnkdalpk3JJySqfWpySKHxBe6QQi1HTvNDjjWJ4T+dp4Gds+9kC9LS7i/8X0b5cJn2wIqYaGdvHY8C+s5xdPNS8GoISVdJJ3n7tGNLP718gso0cRm5wbnV944cIaFT8JiUb3tOsh6uXJy5Dd2BY5WXKWPK809x8pxnkzCW3XF2+rKScWollpyLi0p0oYIXZlbRH9NpppcZbORT4mdQ0LjiSi/5OwU4KScdhkzTosQgeqZm2k8EtgNJ
 exXh+OK6
 UPNOVLjMIkWxUwElGXZlfRH06CUFGrL6jMFrte63EbfAtx2qH/7J7fSzjdhqpVFdVv8xjlhX6yajMJMe+E8hezzjC5vYVz7FsoacyNbmSzY6u60vw8ZNWEi0w99kQIalxXgzxWdxM4WJE1rP8klZwxdZ+NOTGoAp6W6aoni/dDjH1kWYPRw0kyBQfdkEBF9FcncFSmsVmxpq4ksBDEPBe/7IaYFqCQNf2TUesVbvXUn984ROGbaj0aVyMPNnHJIeZwJdQKzkTo4y095K2Z5TbCfGiuO/SFhXKTNc7zbnGrGl3BxBSOQKHI4DK5lW3/FTfijg0e0kktpBy2M8K0wfmHCG6yQ1r8MPb8jdPtBO6jM6gnmS8jEIRHF0S9d/FX8zGaP0W
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



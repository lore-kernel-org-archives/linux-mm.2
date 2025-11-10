Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD42CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363798E0010; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250E88E0002; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E798E0010; Mon, 10 Nov 2025 09:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 003FB8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:27:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A457083CC1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:56 +0000 (UTC)
X-FDA: 84094926552.23.7A2D482
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB99F180009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=cS1ot4vR;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=oaIZUdriki13rALx+xhZUlIM4Z9lK4bCgGjVQXRHsElnAzyAZs+GJJM52AvYcQ5MiKbNNV
	XV0AeBx75mpYfNNtZTZ3cN876KX5TbroyivrQx3lY9MUnJBMMXdDGocpVeLrIRiHuc+zqn
	fHz3v9XrhCfjmiLv95JJIiG3HFZZkRY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=cS1ot4vR;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784875; a=rsa-sha256;
	cv=none;
	b=UkhZ4+xJMJKzlD8HEAP/O7KQa/LnfLArU+iefxsiCuS1A7GvB3rrgW/9PyQqQHno0385VN
	iCoh0VJUTfImkpksSmP7IJlJYcNLwWxND1brSxeppDZrj8He5RYLYlve5wEl1A5ARxCWko
	EvOrbXZnIhKCSYE2Xk7CoIYjZdrXJ2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784872;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS1ot4vRNiTpYwf2SDxPZ7X+NRW3f5Kubg3x8VbmxKsmpOA2ds9lt2BuHWBkJAu1P
	 iI4wVVmfXtusxUSBEvoJWvjvNpvohvdg4lojybouSt4t27QqmZ007NaWsCWistZTBM
	 mQQaxzXduyvviPjZ5N03icVSyODOqeopduWqqcv6OMNwHuwLrBMsLaBYkYGSWmBMja
	 UpRzHuIr/iLNc+JRePmjJNybKMyy9zLyE4EC3Jos/hM+7n7R5w4Y4ayLbuqZlOGOFI
	 Uqq5dE3PQ21hVo1oO+oGxwzmeXEIppRiYNHyJ0XvjBohXa02eEm+Hv3FbkQJtd9n/F
	 SG8wmh6owgwzg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 627B817E13B5;
	Mon, 10 Nov 2025 15:27:51 +0100 (CET)
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
Subject: [PATCH v6 01/11] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Mon, 10 Nov 2025 15:27:36 +0100
Message-ID: <20251110142746.3490-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB99F180009
X-Stat-Signature: 73o8o9s9mod8op71s63hm5d8pjgkqjfs
X-Rspam-User: 
X-HE-Tag: 1762784874-36118
X-HE-Meta: U2FsdGVkX1+L3GuazxU0h+VPTPbz0a6nltb3YFNf4HvKfujwu17B5yY2G72/BDvoZdIIJNulgMsd3cExQ4MhDbMqCKGG7+En2lOZkZflGco2iW8MtQ1z4HYDnh/1hx83X76Nupiok5NtUWzYs96GBHUL5R/0V2x/xdNlYrrAZMW6zMLbue1KE6JMCoi5zmWycIoQ1A9D1raYkbQbL6Ij7P6zdxR/aToZYfuldlqrhp9zNCuQgut/twvmkqWwheDef4sRl6FMMY1YSZJvU7vRq6nEXh6IxU9pHeYsCIF4sYcSkkDxFY60xIZpNQNcXhor21ZoQ5bA9B45NeB+77cS7OxCpx8GfGfN6RXIFipUTVdELKaDA9tQs+1FpILufgBaAPpNBQiaBj61GBc7MtTf03Jv0VaMj7hmQgK02zAhCadjgQ+lGtiVoVxiDp06KubMs8q7lxXvsyLoV/oes4v7OEWN9crNdg75PO9I+A5DlPglp4hCGNhAno57nVJgULhS9WX2ZJbdPV4ar0+bCgEGR+83SuI7nrNo+7PBbQautL+F/VkID3SD4r+TaYT2GtXS9xAvvO9MKQhanL7ZLzaGafUUXcm637L3ifjZziOWP9KHqVh6KCXDQTKlpUzvh7AO3/0Z9Q5C5uiRmJAJQE0Mi1ZXHaFZ2AuGZj+yl2YzG55ufrCNPmyk/clSLey6EXK+JHWJe68XYRiYu6YTB6+wbE79PiBApg7cnZuL/cpvQZ1sIDd9Qo8jf57mwuy7+8/R3itoZikilU4AUQvxKRcSReBMOD8KK7737xvFnLfIfI+xs1s26zeInejZa05XaS3V/BRh8DIKECVulNnMMlqLgKr3I0biceWXa51nbT9tAJoMuYN0pizQCCePsWScaSGidNLuDVKW3vU2HvyLDmb5NRHCrsviXt9wqDRw6H/emeeESmCuh361sK63Iv7JLn1FFoqRZ0SEyflkieW2e6O
 j0oP7tQt
 Xj8bU0Wi8HKC0Am3FwDWyvXH5O68EgisQtUFJ+BBxVtu2avRlmgSsLzpExINFLL8Qpz3pSyz5hW74ilrU+7v0o4PK7UeDomhcu+uUoncRalgc35IUlGza7zc9VnxOsVCYyBENukIcJ5itsnSKTOXm71xshxfKXFrEJbJEV1nwNmpOmfw1WokKwgyma8XIE1o7ApQ3SB4uO9DxlF9UWpE3/4FdZ45wtR8XOuQCbJEjc4kk8R9Rf96BjKekNQowldUobXbXwzn60gMHK6LytDjPNlu/BOtiNXpKzx82QUNGXo3xtXcuZ4EhItZg2J+cM+pKOL3fHQS62T2fkCTRr3pZ7bGwXJlEfcWHCKbA9uEBJVx85R2l5rMFxCeqYxeNtDvZqoC3
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



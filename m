Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F23ED116F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D746B007B; Fri, 28 Nov 2025 13:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5006B0088; Fri, 28 Nov 2025 13:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD146B0089; Fri, 28 Nov 2025 13:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B95D6B007B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4559131F95
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:00 +0000 (UTC)
X-FDA: 84160912920.30.6ADF440
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DDED40011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:52:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ISd7qpI1;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=e+uzts45XjkW1C18kPmoDTTaimBQ7ChAs/UE6tVsih8OfPrYIcf0e0EpbwUOo/VHoG5NC/
	TBE4GCngKgzAt9y0CVl6bHB3f6ksGWuP45G8+D15JpYAnxZXsWasqx/4aI862SF7rk5sey
	h8it8TmzoTVpnQYqgcN4KCW54GxJNWA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ISd7qpI1;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355979; a=rsa-sha256;
	cv=none;
	b=5cltRmUHZizrNHXIyYEw58xwE2kSXyzTXveJvbx720RwtpF2iGvvU6GQgkd2RqZ5z64WGM
	vICD5RU5cu5EBM7Ca9+uSfXjCjVgg0lWafpQgGi/s6xou5rZGIEgNOsbQPG1kzDlCoe9Al
	gtk6CffkN5kzDgjoqhF7ClKpPjN5leg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355976;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISd7qpI1Tl97k9ger7HYWaa+AKgbhXqTP2zw1rBjR9ijaa6D2AKJapF7avFUm9K3U
	 /+iDU2PcjvDIfdiFYTUMRLVtVwv+6cVb5ViJj+FIFOJtiRuGGh08wehNG3V5Jk+/9T
	 CZ2td68j7wYggUOPxG9MV+Jl/hek4Gx+eiZH2+J2uDOV+OAmrcmFf30qavplF3IeSL
	 0d6adp5WzokdRqq19AvuGSvTaveZ7PzA2CZTGQnR09yLXccosVnW5absumt7Xpm7vW
	 EZ/pxjVEaga2VTFCYsZ0hWCE8PWmalXzFbaKrhPfPiFABOxIIfMNEXiuNUgxuPC/EI
	 O5Y5LdusZKYlA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DFBE017E10F6;
	Fri, 28 Nov 2025 19:52:55 +0100 (CET)
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
Subject: [PATCH v10 01/10] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Fri, 28 Nov 2025 19:52:43 +0100
Message-ID: <20251128185252.3092-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DDED40011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8ybjrxcuqsb1uufmxnrwikhiuzj3o5ma
X-HE-Tag: 1764355978-122903
X-HE-Meta: U2FsdGVkX1/fouVAeOIMEx0Ws1wvQjN65qxDgxn7jFoBSUGbYY79gjnBOpm4K9dgMjTZScv47gL2Qf8UNFZuqnzRQ0OFXx2Q3zr++FsTrNmajNPo5Xf6mwZivMxKsW8ZVunVwpVHbOcViPP/iRDZWYlt1CtltEpTzgZGZ7eOUGivwd20feICrEr4KZNXgcQIcffTv0/7VMMzYESeSm/QzwwuAQqQK86phTH+KlNWaYuj/Mpb51inbX71VA2O3vPY2Ro7GZSfJdIy1PFz+K2ZXO8WtP0x8W/RlxH8hyFaE9Hjc0k8V7kF4CNQ7ncmWsV0EZCBGJ6N5ObVgR12wPoOiFlODaHsHKuluhvr/fgvxIpqYLKy7yS+u9GlfE/ETYiOX4vS3l4v4tcn0Tl+sgkCwXt/XRyVdEM+0Q9lJY9cpWbBRU07dJkX1V53x0idhU9X36SJP7hRktg3Zg41vi2XJvKp11eTGqbqXevN0AcD2FxcZsdUAAw6o6gU7PzM2xpPHIEb/1KlGFpEUClKyCuJPRaNrQ8w5SPZBCNDzaHNaHRqndaIIlaMCvN1jKWEayntkFoUkTjcGBb3sqE7U4cWR4RRXlHwOrYMwgl09nG73DSlzTmTsbp+DRayVn2NADuYCiGalBb31WXaoIq3j9sJ4nx0VSQnzDuQjG334AiPj4CbaYVPS32q7yEAF2iEiZhQO+VdtEAeepYNHYU5ToCFosaXUslwHER2vpHIpYy9BCP1SvjanrYnYDwJ4SRBbBXlJZp08aweMTKBY4iM6kd1GB35N2CmvbteSJzqkU4Rzp1PC4+k0f7RrH4CZWDFY9S2XVi+JDQivn+tQMGigBCSny9ZqUPJiV5UNc2A5apGU+s8dlmjvamrNyHYFkkzeicy25fhf7mgb5ws9IWw9T1xFR5/qb7JaaHUo9idVwtdRbe8ObU/ew1YMUVQK/tx9ST+DpjZlSvXPULBnZsiwoP
 EUAE34Mq
 C0lOSTU4padFwmWszFTKkcop+Zi9iaGSM83tr1b+Z8KjkxfOTaNlCuHHm94MBmULwvBIfvVABCFwPZeF08S2IVnbeOY6KTgyECVeUWEM22jW2hs0F6qNIcjDw8g6qSm9u9gHefTzk6SjvH1X8dDN/EJLnOqaKlv5zHB1RSZpMH14u0q0+N3jQNAuW6gRE1VpTq853xZRz8g+IPrVmqfKtkWmnL/0+VAIRlCBHuHU8wl1zf8cdA9/ZuhTSG+PtCzvEDJ0U70v4M4ROkX87Lplu0MJN/BbX0EuNh4wAfkkSNT90zWh0ijWSOXzVpHbPlkVJBNY8tmlTUKXqhCjYMKU2Sz8cY8c+sdavVO7R+vesrNlavAaxC2NpZFYQYLFxZLsffxG2
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



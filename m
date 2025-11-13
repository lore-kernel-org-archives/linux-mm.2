Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86C3CD8CAB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1125F8E0012; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C008E0002; Thu, 13 Nov 2025 12:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD0C8E0012; Thu, 13 Nov 2025 12:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA79C8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98ECF12E8DE
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:16 +0000 (UTC)
X-FDA: 84106196832.07.3C31919
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7568C16001D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Cpwqhjbk;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=rxv3GWTYgsmAzoDx2y4m4Qr9UZH65GgE/vj9FVx+CVtRM8KXneuxBArmvTJtPUzVtC7WNZ
	92QCJ8luTrXWmjTPK/vueohtTOwSv+Td8VJAgCkWlIbp/b9ROLHKIR/3SEYbaAgv1Kq8mu
	Wm09jkMuFs+v69lWpMhWihxK8veXpuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053214; a=rsa-sha256;
	cv=none;
	b=O2X1DjH9APj4bQkb4N90wgfXNMpcmNC3NbFh1lM3ELeB21EiU7miZK7M+w3z5uOdMAHVNv
	e55xgYwTj5G9JomUNo5oxfGgm4NYRpeyWy3A/FrOSNH0SbrUuA1/Hev08kk9q1smjWMYCX
	5NVGPBBdOpXQde22AGF1NwGHAIOxVac=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Cpwqhjbk;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053211;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cpwqhjbkdud4ST3MICGimYNSXHBC2D9rx4idwUCFN5YoiHFtbY29aAdYsANKt1ACJ
	 VhKpe9ILIe5LFZyjvdMviKh40be55tNduoDxfDKNfARDNMrG8UgB4u/ZJ0jRbovMFU
	 PrGyXce3kSGRQBam5lAZdk3jcjNazHwRbjv3oF8Ahbx8QKxuSRsGySQX0eV97y+ggV
	 Q9mPbvPp7wzosg48RGspQ0plRVy4wWc7fjMqnAnD23j6WBlpiD+Cv8Aph/DEdtIQbg
	 F+ETM6FW7uhRmJfdClDw/Eq5DnxgFjYpHOD2ko3KB7Mzyq+wA0H4dYnpGRzwKhjaCY
	 D7Mmj9xHux+Cw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0BB3317E0202;
	Thu, 13 Nov 2025 18:00:11 +0100 (CET)
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
Subject: [PATCH v8 01/11] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Thu, 13 Nov 2025 17:59:57 +0100
Message-ID: <20251113170008.79587-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4jj9y5t4zj999z9ig3p7mzuyy5mb5mbj
X-Rspam-User: 
X-Rspamd-Queue-Id: 7568C16001D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763053214-690834
X-HE-Meta: U2FsdGVkX1/DwQXBb3aabWBL9qqG8lUDjtskc+O4jwqn2zRTjXpDSWml2g1iBZerQ3IgkB2LxrK1RRK0WHLypuyrFf0btdcyohMzUa1Ost8i7pgHOdpuFAyWx+vuk3wNu0xXoekMYELu7WcN/AgMsGYMIhRg6MqDKjTbMfLGqehRQHq5+C5ZJ2v1lRSu16d3ed7+7H1quAonj59A80F6qEjiz0pFDmM8JQzk/qWUyJKkY9VwcbbyiZ21AAta7feBtVMPz9SvNxYJLgXWIPA1AZe1WXF2yzMMA/DPM05UiiKnvf3jsjXPkV9q8+9+VHNEso+z7zubS0sqgEDnQLtsQVlBRe4kmEA5qOzu18S/WDqOzXU2J7O7KFLRyUnN12dV0Bi28T9RJJfI8HWjApnLuStZ887qBu0wt66exrAd76wnEyXsphfIDUblGPfZ8lunc/MUwgwiCKArbgp/rzH+xNWSx674P20a6tcczQE9YWbwuYCO7OQrkGrRKOuuj/IdntzpCNnAnT3W0sjAWy+tAY3UUtm4D4itdMSc+BWttcv3LJ6p6ddeYCddMm4IzKg1MdzEQudBX2aryDvGj7eeH6bFuk+jFbagzgfCFx5tRGnhihfG7DQ7kRIC4NdfWGfXzJGdhgsusyDLmIFQUX7AYa1PcMFRrIy1EhSDmkNp4dQ1CNHDS3QQGHY2ew4M4M2rzWXDa31hgVHqu03xTNO2ACgXVNY0G5iVeVshG/Rh4U++NMtZzlRhL4sczTYCM8uYjCCu8HLtqItAY8HwyETJjcNhuOO89WsHvRBQ08Y/UVHaVX9g4dRq8Xiyl0h/rohyqMOENwuVm1tXu82liLeuMUWMMUrjHwK54pPEnUitsJr88ygSFO2xoyjrg2R6pwEjkZDHAwLAt5ldZd/PvP6YDoewFAjMzF/pnbLcqU4xGLuL0thj/bl7y6Ln6cv+zc1tmVA56l0eoSdYOT5F5mg
 rnCArf2m
 L+0T/vivuxJPqRK2b/RzO2UrT/SoUeB3epG1ZcEmeBETJgSNx7BGRwRfGJSbEF6Q03S2RZ33dahUOfgcgRdBB4h7p4tLdM9wX4+iFMxut93S8PubkxD67P/0AJBBmsp09TRtUDOLW+k4rGz2bJeHE8fergJhyVf1tdTKq3NIbTQKf12Z+Nz0jfgfCXUTm4pa6iXMXKhoNlkuBr7I28mp+9SPlYQv8sL3TaWT9IhAiqkLd9TxXavFlf1dJHp6yIcZneBlAGRM4Ytw32pnZknOcxVs83AyfS1e3WMsJKxjGIadJFkuXuOk4acaXcs90QrFQmRZCD8WLrSI2a7fk6/qDCifmLJVj7uOmEQpiDK9xzQDXSKgA1IO4Cnv/g13hNi3VXCCsTST6R9LcUf3fPq1Upo0LlHinpdpDVrNvWgOiT3CdQswmX2SoQWx7m32TmrlJj3/lMkN/YnyS+/V8cnvKjQXYVuxS0nsg4pm/+lnFV/CYBr1U/Ou/kh9cYgdd8AOFDil4
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



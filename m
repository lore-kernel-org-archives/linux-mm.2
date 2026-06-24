Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A00CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6ED36B00B5; Wed, 24 Jun 2026 11:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45296B00B9; Wed, 24 Jun 2026 11:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CAD6B00BA; Wed, 24 Jun 2026 11:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE3E6B00B5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:35:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3C321C559D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:34:59 +0000 (UTC)
X-FDA: 84915204360.16.ED0517C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 929BE40016
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:34:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sHs/yrnX";
	spf=pass (imf04.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782315298;
	b=3rK7MK3WkrSdIRTuOcghCq0CzXrR5qo44K32i5wYlEbhcNyMjUUH3AhpiSvE33sUeySoz4
	YAG8Lbki/TPiuVg1YPTNaKWt4FiyM10scqm+UgiPzoVUf8YyjndIH4HaGC+ENapNCKrug0
	s0iGNXUTbI7xdlEsSauunZp9PkkUWBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782315298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfzKLA6Z2+WkykRM71cw4eZ2SG7xRyEMqd3d+Bx1Mgc=;
	b=Wc7tsnO/J5ZV7llI63J2BztGoIxR+kaeGfCCVfaxhrgjXOCe4YkW24aFdROCVpbpwTFqsV
	94VCQ4DXrHdv+on3EfZLQH2tIYWCY9a6CreJhwJnFgaaSA2+vYBKQere+zkoWZUTlamRu6
	AdnmnhNyAcp8zvNFvqSx2YXZnPrmP+Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sHs/yrnX";
	spf=pass (imf04.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8E7E25E1;
	Wed, 24 Jun 2026 08:34:51 -0700 (PDT)
Received: from [10.57.80.146] (unknown [10.57.80.146])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DE0B3F905;
	Wed, 24 Jun 2026 08:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782315296; bh=8MbUdECE7vtm2+3ukK2M86Rfe7gaoQ5YuHIyq3drERg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sHs/yrnXAFcD3Ti+VgtyyEOF+UIy4qMqQx+ZzHYLwdjJUI+Lh/j1YH/cfwy1sR5n4
	 qNE8iWVmtlEBRZEwBsMpPmRs/vGQWoib8zqUt6hDjZRM33/BnP6POGuDsXp7sCyLhi
	 VQrqzANPlK2d5HKpK2mUQdWtxeLIvqmXwstdplyU=
Message-ID: <c16ba190-b979-4313-89f1-4cc2bda72304@arm.com>
Date: Wed, 24 Jun 2026 16:34:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
To: "Christian A. Ehrhardt" <lk@c--e.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 dri-devel@lists.freedesktop.org
Cc: Liviu Dudau <liviu.dudau@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623181942.1536598-1-lk@c--e.de>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260623181942.1536598-1-lk@c--e.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ye6cc5zemekzneucaq6p8xkia8yairqh
X-Rspamd-Queue-Id: 929BE40016
X-Rspamd-Server: rspam06
X-HE-Tag: 1782315297-41169
X-HE-Meta: U2FsdGVkX18BEcjiTeOfwUt1fPM+Lkl+07oN4gppKDzHQKem+wxlKfSE1qVzpQbND0yIc0tEeboHjT4KAps1Qj2T46BluxMawQt/CbaFrHmSQngJTk6+bW1cC/Rdc6mBMHi/orwP/JO524+8VqvLr+TdrkTi37j1YTwyo86iM/6AETADD9DdVfXvl2pFQ+OIdme6YxfFD+PfLG7gSinImGy+a0e4hwB6rR4brr6WHBsN/YTwINeiUQ4ZYEmbRZIt1D/uB2LBXZ7N+pVsyGl59tJPpUoK2tWVL33K2OCt7e6A1F6xctliTR2ZVJcQ+Xck+2OKTBHY1oF5AbIlTKNnp/oamIJ1H+74nS0Ao5sNreM22kvVlYw6Izm4Pbl+Ttolx2IoHlvwCPC+Abl+n4hzZuY6KewFWZ3+zihoMXNGXrUY1gxo+oRHjPpkLnr3rbajGZGszlVTMLUiN0p59VvnO1UHpUZ7SCB48OONlTfLRvjeUdJ8nPX89TxhXSpJD3aQBp8S6rAeCMEaZTkAjjLAip0nTybOTLulnOzHdc1ALWjtp50uoahnNbovK+VzsoDfRuB3EdkzAHvYr4PytH5qYVFCGf/jngMLlwQt0gmksHcMoru5eCSPgy44iLwthMtK5p3MyMCHTfMHdS/bISDRZitYzzI14H/ypcwXzp0pNXRAUPLOMHovekCJOMzyBUYvZJBL/39B5TlL7kXeIvFg5LwULZHmp2Cv0e9mRhViJZPASpqOpdOoI1SldKTz2aEY667G3hdsJfs8YIcbCVM2qSj5GNjUzVDHOIkEglP6V1gZmKqfbzk+hin5g2/tCFMMnY26mjdNGu7W/rK+zd2O/+Z11YfvjYBW3xCMiffeePsDD6AXaIklbNf0qgSmyJ8VJ91Fou2KaQ/TkQ8ErhVWRuEPLLf/kcJQVq0m6j/8q/30+VNZsEdiAXr3IPKHE/OSFc0DJLri12yjZgrfHWp
 AM+mvve5
 vTHPt317DfNj2ygmUAev//n/htShogWbMRoqf98uhJAp+I4WJ5v/N2Ej8XUxDL/83uqxK5w6KS6jU+O3pW2cd1VdpV0pArFVKoLdzY3OBRcx0W/equLlLt37M2jjMIYt8nal+YsDkxv1M+qBwkeoFC9yv7hCQVtFeOiYetGJd48zD21w9YOhMAji9Ix/gLCrExmsYxdTtWraifEsckXz9H61vTv6qpnzsiqPUa5sKsDQFu73Xr6u8v1/DP3e6vzqB28Kg0PEfiTSvAb480SX0Rt5EQOCvsWZiTA2Z/3d/+Ttv9XMT6+vrrI1DunObTU15ajJxuc7VzcPF6a9j4dGpYsmON2IXTSvHErOcBLswKeVAZh19OYZAbsldDaQwMLaUwFi3VSmuIPI3o0pp6Ais092tRKoqPUp/i3I/HjiaUrnGpX+E5VGBoOlIeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/06/2026 19:19, Christian A. Ehrhardt wrote:
> When checking a different patch[1] sashiko AI pointed out that
> panthor needs the same fix[2]:
> 
> In the ->huge_fault handler do not install a PMD huge page
> mapping if the huge page exceeds the boundaries of the VMA.
> 
> [1] https://lore.kernel.org/lkml/20260622215718.1532689-1-lk@c--e.de/
> [2] https://sashiko.dev/#/patchset/20260622215718.1532689-1-lk%40c--e.de
> 
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Fixes: 68cbf96b1e9b ("drm/panthor: Part ways with drm_gem_shmem_object")
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panthor/panthor_gem.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> NOTE:
> The panthor version is only compile tested because I don't
> have the hardware. However, the code is identical to that
> fixed in [1] and I have a reproducer for that.
> 
> No need for for stable backports. The code is new in 7.1.
> 
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
> index a1e2eb1ca7bb..54535bae2b0c 100644
> --- a/drivers/gpu/drm/panthor/panthor_gem.c
> +++ b/drivers/gpu/drm/panthor/panthor_gem.c
> @@ -802,9 +802,13 @@ static vm_fault_t insert_page(struct vm_fault *vmf, unsigned int order, struct p
>  	} else if (order == PMD_ORDER) {
>  		unsigned long pfn = page_to_pfn(page);
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long end = start + PMD_SIZE;
> +		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
>  		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -		if (aligned &&
> +		if (aligned && in_range &&
>  		    folio_test_pmd_mappable(page_folio(page))) {
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
>  			return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);



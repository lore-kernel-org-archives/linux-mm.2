Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A5ECDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9090B6B0088; Tue, 23 Jun 2026 02:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893656B008A; Tue, 23 Jun 2026 02:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734906B008C; Tue, 23 Jun 2026 02:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C10E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:46:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0284A03AF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:46:33 +0000 (UTC)
X-FDA: 84910243866.02.FB07E58
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5F5318000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:46:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=C3GJODnX;
	spf=pass (imf06.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197192;
	b=6A3MOeUmUdYkpaqqH59GRQ8D8KIykMAU0bD8xnUs65LUJLJzd8dfnxiLNzLlwcsJduoa6W
	zKSUN5MJbpEtGclTJwh/V5QpZBw+0h0/9476MGEJiV6mxHLQFrGMPMhD4Qf2J04j9cavGd
	of5Y4YTRHR9Hp0yQO3XyIR+wbYjIur4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaMkoU6KoGBYQHhJKdViWcTDZY0p8VmfhJLJivLcdgA=;
	b=3hEXdTyLFnc+OZj22JclUG6w7Fkii1SQwtMOCMOSuaSkHduwBhiMiJMs1E5SR6PBC0cycm
	xw7LiTBC2tNpcIdI4448HN+6yhDO8dyohH6Qq2YYgxQjFAkRPa8NIQFONU22Nh6iHBadT6
	8yBBjI+RdcmvrJ+fSPpvkk7z2N7kfuA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=C3GJODnX;
	spf=pass (imf06.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782197188;
	bh=S1W9nvysVTlhGlyxf8bcbMXagzfiYnWQcaO4x3GB/Ts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C3GJODnXnIJLeUfyht55qPWHoxgHOXlpiGvC0bkfGT9aUg/NOJ1CAfjwnRrLfCmtu
	 p+B5mKtpmiV9NqtPAIV0No64c4iXU9TPO4SjkAo7+XbbrNow7vb16EPZ9KjN7r7RE1
	 fZ4j55hc2KQmf5WjbrruYSw8nFo7ebqSikvqhvovC/nkSH8r1cMLjo0uW2C5yYpPfn
	 h+4sE7TI+5OR/0zxMaeGsiu53hPi8IXQ4lMFvbaHdX1hW2UycB3JCiAJ7hZylif9NA
	 kXuyzxlOtPrPydxmUATT55DNasfq4kUTkR2jTNUbTQkV1am1ofCWWvZZZugEYuIHO1
	 MhdZM2pA5m5UA==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 77B6F17E0180;
	Tue, 23 Jun 2026 08:46:28 +0200 (CEST)
Date: Tue, 23 Jun 2026 08:46:25 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: dri-devel@lists.freedesktop.org, Pedro Demarchi Gomes
 <pedrodemargomes@gmail.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] drm/shmem_helper: Check VMA boundaries for PMD mappings
Message-ID: <20260623084625.53f685fb@fedora-2.home>
In-Reply-To: <20260622215718.1532689-1-lk@c--e.de>
References: <20260622215718.1532689-1-lk@c--e.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c5kkwhb6sjypn7o1moyaky48g1pkrafx
X-Rspamd-Queue-Id: C5F5318000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782197191-483373
X-HE-Meta: U2FsdGVkX18SCVR7nokSEqOS/xlu0cGYNkfqoIFOxAHK3x4b8LgQTH7EpAl3IyeiL5BmHSCf4TvGANab1WLSUZV+QrRAxTrIg8265qu5QxaiRUy4I8kGjehlOXiPUMkIOFF2nQX2iLjXCD2uVnOqD7agxZx1QxKMRy2B/q8eSiALP+V+DKsa1M9v2xuNoBOJ8GnhFXhgbOjURuyfuCp73Ez/sNK+BQ5m+LDm8Vjfe6yxTDAAUPkzUn/VdcySlf7NBtl3cX8e+y46cKL7Pu5APCaLOk+BE4IB3C8wNnZisKAWaPvCWt5Xn6t0Bru37Wqj5+hUrlHJYyDuy8UWsxhoP5zff0eQl7q69hL7zSh9TYnP8XivVQZu1CNR0rnmSnWq2ztazsPL5Axc7RoF5SHHZ/evFfFAhpYXdDFhEmO9pGO4DeFuP8aemAYlO4XDN6rW+a/hDvk94rYFxbRGoC+hyBeKx9IcM8lCnrGA6i+N+TpuuGtbUIvWjYJ//I1jRM8iq/w2nEqZoioJpguWhoAD+tFBgsXZobk5OuozMe6kXJA6URTD0mSUU0QmfjHWvvBs/2JirQrjUSzSPx961jWyQC3dCwD6kpE/jeMPcSNFxB6lsExPHNB8ifh63quWhU+0oLWDWYFWAamANonKmgZ4Fx3ctv04Yo0yLTsY5FDb+zRvLaC2UwTRuTAM+AbWmgR0OaQRG8CeTxIoxQoAFM+Z7iUwe/y1NlXgmSjTYtYX8MegQFkHc7esRHH+D6y+P09W9Queobsvdm6sGspPzQ49c5t/jKBMVxqJY1Ia27vKliqrUlevLJuYQXXM0B/4RC2VxVoM5J0bnbFunMbTro5sGn4/eBZxm7FW4EXy8h1n968z48g9mvr6YvcJb2/QtAGBQXgCZYHq9wJUf9Rk1fS4sMRlPlPxi8tQC6qI9IcX5dvzm3A2A4u6n2qcommLYYtDuDlRiNtqxshtsIiEfVt
 PbcymCOY
 JKi/M6fLRFmrjmNgZWgmvOXlNv89vTNgSpvMMbT7/0kl7qyIfPTuwIhcn5dQ8/AREnbgE62T+XFmPsXQloffC9p5fzoz6uo3T69c5SF/tSU4+YYBw3KsgyJdjooo3WOuP1C2DF5Sa2ehm5CL1IAUSxzRB/qZa2fVYI8Cmc+MwKNcCIdS1Ghr/VJATbzcRARiXfLMJxkWCEGTZFlxSKcqQaDoXbCDF8IH0MnWlg/zHmi6WS2U+R1UGl1GNZqBBpU02UNnjKuKDcZHiQ2yCfSEIU1Bog9c3MTjAkpAPThBqGPvT/YEO69zrD/IjU4sfc5NzgJCBuVwpX7Ux6kd1agnXXaakBOzusaH0nSloC3VFJimjpCYZbTDHkTnkcPtW4NkZVtFeu374kJ89uW9LXIvqCiQs5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 23:57:17 +0200
"Christian A. Ehrhardt" <lk@c--e.de> wrote:

> In the ->huge_fault handler do not install a PMD huge page
> mapping if the huge page exceeds the boundaries of the VMA.
> 
> All other ->huge_fault handlers have similar checks and the
> resulting mapping will trigger a VM_BUG_ON_VMA() if it ever
> reaches copy_pmd_range().
> 
> Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: fc3bbf34e643 ("drm/shmem-helper: Fix huge page mapping in fault handler")
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c989459eb215..00807039f8d7 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -597,9 +597,13 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	} else if (order == PMD_ORDER) {
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long end = start + PMD_SIZE;
> +		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
>  		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -		if (aligned &&
> +		if (aligned && in_range &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
>  			vm_fault_t ret;
>  



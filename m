Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEA7C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE676B008A; Thu,  6 Aug 2026 03:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFBD6B0092; Thu,  6 Aug 2026 03:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1386B0093; Thu,  6 Aug 2026 03:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 347326B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:46:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B09871406A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:46:42 +0000 (UTC)
X-FDA: 85070062644.06.ACE0FEA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE0D32000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:46:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IxxpBJPu;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786002401;
	b=pzh3w8e9lxTdbZT5MCviypw9ba1SOK+UM9sr8mO+XhhY/+pVGMF17P5xCkwaiIG18FV61g
	ZbpU6K60qmvOkDw16DVfQJUUem+tspx8nYEU9VutXGTDVQIdpkvCoNwLp8s82ZLVDfvU+o
	LWNejDCfyCAOi78Nb5EayivgLPbAj28=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IxxpBJPu;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786002401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4YFehFFkFxwLBTcAJ+sqSgpMf/vavV69ZIXNno+stE=;
	b=HbWCnqsI6QKYFS12EIWj2NZA/hwaqTTDv9145FEgk9IM3t4AZ0Aubse624ZGJS0aFrsWK1
	ZTinhBNoIiRI+Slfb6FftkI7jynPB9fHhgsmbA3YYdRyu9JkN8jTrVt1vMU3/WPKZpJQjf
	qrSH1lJtMK8QqOysm+e7SdC1ZvqjdK4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1786002398;
	bh=P0ooqE0uPWiEJhHB6YvjmOEp8WmR+FP9n8dFeBmZRSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IxxpBJPunytUY82qqvtIABr9WtBkmhRQYkbrHm9QSFllizDfC9I4PVd9UrGDUt8Um
	 Nrq0+mPvpJFiADDahdo8clZCZzbqIGLIESsE68RUbqc9WNMNJqSqX5Z4EK0AqWmOgk
	 cDYMZzq5MgG059N0qMePBIqvhjU/q6t+LStHw7qzwWstvVI4HLxLUCbJCR6NXRSM1x
	 /AWqZa/RmoF7a1xFxwp4Gk49jW4H5KZEWkemREr7vAT40FYZ3zOV1Wje7gb5wV40mC
	 7K57/JDNDd/xbq0YvNMRNE6X7TmR/GSxrZT6tWPoJzR2OilBfdVx4WB0v6XmC0pX3q
	 753zyugKQAR5A==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8C8D617E0235;
	Thu, 06 Aug 2026 09:46:37 +0200 (CEST)
Date: Thu, 6 Aug 2026 09:46:31 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: dri-devel@lists.freedesktop.org, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <20260806094631.5796ef32@fedora-21.home>
In-Reply-To: <20260623181942.1536598-1-lk@c--e.de>
References: <20260623181942.1536598-1-lk@c--e.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE0D32000E
X-Stat-Signature: bb9zw6qjizfe1uqzgbh8oq8qtzkdbrb4
X-Rspam-User: 
X-HE-Tag: 1786002400-486101
X-HE-Meta: U2FsdGVkX1/2lnuAO8fWuQyKF1j0P125qSz9/hMOJQo0qHs7iNirLO+H1nGRiDDNfQT4S8r4Ed7q3SIb1enSCOhzBy37H6CDAkwPsYoEbvjetqH5K1FPHKB8jvDf4Hy5OJMhgfpOHk9JCuhsp5VgcHyZRCNXAmT+rPl0rV7Uyr9PQAkK9p4oXL9ITz/p37eq2ACz1nDfBRQammiC6FYrr5l10R3hUoe6hx+wtXg+18lfh+BY0hzAfkh+iSKNULRyRYp8w2wn/AopXoYIBM11uveKLNZzU466X+HwLKD1xrAIJvbVWsJ0vsSgUJX+Sff+tw5Dl98DmnFpNzPjoClblS4PO1ClYyPOQ4zpPum5gXa17WaEJstKZ6UtNfIVvNZIPd4/p3PjE0IJEmvTWNaTnX/bM2NUVZexcPPWWySA5WBvlxCg96g74enZjrITlN4229+MNiLnJOdkfTHZxX1APz7l+hbry5mAdKCCF3wBCBJc+Eon9rSBuujoqmh7s8RU+72FnHoF2xxoWHLCNkthO6sNHx/jli2UBcmGH23LDVNrHFpVImTvJMirwWjW+YsrH4wcuqtaBTh6mL/+qDwN4z55r4cxBHe0mm3VDZObiaOjLDX4uKV0ulhv0Kx/DqQ6Z3qiij1IeLFxTdJzQvIxSs1IhEva5Mow2PaeEAUpA7XeRObIK0o5X819Vg+WetxSMboXzoY09bOJMS2p4/PbdSvzo5oinQhjMuZfoRTOUh0xJ4g/McD+/hQsiDhcIZPpZK5qxSVStwzwjmON8mJysEdi75YQ+XTXLmPjyX+WPd8VIZK1W/XXkngsA9+tiULGeRUJRmvWSheFeFdnzxx1LMlrKhwTuIbjBGxgu7kNz1pOQnr71UpOhlKMv7QPtRZy4Y5lV/HffZ7Sn4FwmkVk7CUJ8bXhZdFsugh9f+sipDF8lWDqkaLkwnzbHiEbzSx2fYEkXzrQwnyYySQbUJO
 nfLzOFY9
 P4RU7Fwdw4VAK/+VzzUNLS2pFpC24Q9KQePoKe3iQ/ad2tcSmzikOlRuAUNj4qL+Gnlg1GVLR68CTKEttO8krYyCe7riVDctu8wElpTe2KbA5+/lykTJob+NmV+tkr4FzfEn6uZ6DT5gQNi4l5pBvs3XK0XVeaLH3viwQ4qKlpKhoyZeW2hBMRNcD/XLbujos/vXxuyXoum+IRwn0Tlt7rEy2G/i0LUiTWoALAICNqvCMWNi4YjMRDVMCTce5Um1siRY7x4HMtltQhXyoIVeXpIKq8Gr8KDY+cKJT4KRHkadATorjuU19y4RDc99hLA9bE262UDy8xKHJXwzabdUdYkYECR32S9CPEmKy3haE8On53uLWncd+ORXcsOwVPdqsmpTjlfwNXRIfamP6L4/21XwTvkiVz1CwXHmkEq1DttfWFdo02K3/1Ej9YRC9S6qB97b5G8VrUQsk7xU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 20:19:42 +0200
"Christian A. Ehrhardt" <lk@c--e.de> wrote:

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

Queued to drm-misc-fixes. Sorry for the delay.

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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0A2D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27906B000C; Mon,  1 Dec 2025 08:17:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF0E6B0030; Mon,  1 Dec 2025 08:17:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C116B0031; Mon,  1 Dec 2025 08:17:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6DC46B000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:17:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8577F1401EA
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:17:07 +0000 (UTC)
X-FDA: 84170952894.07.76F8382
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5388180020
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:17:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=F1ykKtUl;
	spf=pass (imf16.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPiAfx7FdDOpOGsC72ThWHuHw4YoMlt69Iwmcf91efo=;
	b=2bRoUqRRGhFWsaMqSJLkXbpsaRrSXAbqVml1xGayXykAdx3nY3ChCCUPzH51KbBfpu/QJW
	mqJi1UXiSOhlVQid7ff3npPzg09+NXT+3BjfQJhFYOewIXaOQRLMe6QjtsGaCE58sRUEkP
	pfMXvIWICd56+3MUncJKXc/UEGP7NbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595025; a=rsa-sha256;
	cv=none;
	b=i7b1IdVP4B372+Q4wiKzJEWSccgSm0HSF2MahqU2GJlrC79C9a1fG/NE36nt4UjrJvg83Z
	UFsFxv+yFxHCQm1yfdsuexIDUljCAeK1LhAqpbsJP1kLLtVaH/Y4pBJUxmXa6PFbvYbpcK
	qhg48LHz26V8sig1DZ0CL2Dpy01ZnSI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=F1ykKtUl;
	spf=pass (imf16.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cPiAfx7FdDOpOGsC72ThWHuHw4YoMlt69Iwmcf91efo=; b=F1ykKtUl8axnsePILvv1n5IyfT
	muXHi/NsapQAhJuCgTSgTUKFWi9Tu+8Hj1K25SUoeTFmSnTlUCHj9UHI6v0B7BjEIQmfZ5fpNNKJe
	LiYBm/FfDU7A000mG7ROPxNNK+OxAzR2YWroSAaFL/C3K2i6Ah3LSdYDd3KNJoNHglXTNzJYBNlfW
	+2N83hgabMUjzT0kJ7KdGAfZ33af3q2bvbQ6S2bU31PGr0NQWHJcoVfHpNX2qlPkacVxd2u80Tdvi
	mr7yDORard5qvM6WaQY6VoOjGBk0ZlDUkCKUaAF5nrNo9k6PcJalvdk71IvLKEf5BWjUEJy5UXz7d
	gyhZA/ig==;
Received: from [189.7.87.198] (helo=[192.168.0.4])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vQ3le-007OGa-VH; Mon, 01 Dec 2025 14:16:39 +0100
Message-ID: <69f7bdc1-e2e2-4a0c-94be-b096a4de218b@igalia.com>
Date: Mon, 1 Dec 2025 10:16:26 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] drm/v3d: Use huge tmpfs mountpoint helpers
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251128185252.3092-1-loic.molinari@collabora.com>
 <20251128185252.3092-7-loic.molinari@collabora.com>
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
Content-Language: en-US
In-Reply-To: <20251128185252.3092-7-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pcprkmity4xxwy3pxczc5ftz9b6oj7c3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A5388180020
X-HE-Tag: 1764595025-131284
X-HE-Meta: U2FsdGVkX1/6+tDU3LJrlwc2SvqyPws4eHayCcnIrRDV2VVtYbtBs8TwGGpyBZiLSNPC66QbTIKepb6Fw6BI1UxCEOMr7eKhytYQxwEYHSHQfzpkSlf3CZtDv7n1xCBdJshQDNMASB0cUkNhpuo1f6H7FUWorEhG04lAsmfQfutXJ8aqCBIDkLcldaJffxu/vbJjVzxeaOFKvrkpBbQn74yiY1hv7GqBHHoLfIMPCmTQED71IBqzrOB5gDSBOOIRXchsPHLzaCQdqdgp5bdFbYvMCBDypuviwZ/FjeAvPLHZJdaC0zg5JA2je8goZfwuJUuKOnlL2KtRYduMZpBJZWPwAWeTFAybxnIcdiND570BCWNYSu1r7bsIxhO8XWI8P6lmYKCQ8pkGEHyQRWU1v+n1hVE20e2mXgZpKmbnh8Z/P++Hcn3qNfSjwj+iSFT1HSa8Uv1bi0/x5aOg/buhrYeKMTyWXWqLYRXbDsq/Y8RniXPhC8JofVvEstwqAdOK5H2Q/37AIGSpNia/Ujh2Y3InNZYoVD7iGaYMvdaPzbXdzDhx5gAZiuHbzCGBDKbkqzXxCfcF8JAslYq8OdDroRE9msqEtiAUqf+bvdw1uRcrNGeCy1vOgahkVk5w4PQFSk9e2VAKlm0AqLcX43cOtpRneO8EUtoO4Vb9AKfaLMUsRh6sSFA+jPvipB7Pt0qmqBqC3sXvI+dr4GIXv5VhGkQntT+mW5cTQptfl8I2XZzhVm5FhREbPX9p4opVZLWmi7IOj9KEfyhLr8MjGaQAn31caf40Uclnkm72YPogZiEKU/kip+a0UcwViX6ntwhQbMghfpyqygmR8igD65rVHi7wbyo66SV9Dmo3h52YpvP0ZbJLX+nmgAB7fy2msuBoVZQ6siY1bj5OqHx+K3fzUYB92XIyjthA2BoQDniSuCDPt19onb2IJlS/t8ZES+eZSw1koLBgsBFXAhk/AeH
 Ez13yIeM
 68mv8Q4X+qHjeYv0FttiSSdSQcWoKfSuBBT8TkwWPdIU4VDUG3+jzcAfFkeg0burjjScNeEG1r0WHNiz8XLsEBWlqLDh3OFVcznYda7vJK9VHZ7FvyTV/VpBUu8V6zYjaKBRZOZyxOqgbHblgqHNuK6Rr3oGc8p2yeP8VX7/jjiZsGbyLWbNZb7pRtTdmkceVuHCaku/nolAAxhq3MybbFC4DZriprIH5Girurh0PGXBXQ5EiF0uICQc7Cs0xfcwSB9pN7wS5CwmPzmE0VpApsV50v9h22vmAU4kanb/SY0dUTftsTOfn3irq36ku1XCk6leFoKJCnme1IcqAbUmrUrM+85JLJzhZBIMPvTxSUsiTynDDOfpd8VB48TIf96zxAT1NZPEMb2JPxTAYmBlk6znCXn9xJ5C/l2yHNVk8ciR40TsbsfJstxTz/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

On 28/11/25 15:52, Loïc Molinari wrote:
> Make use of the new drm_gem_huge_mnt_create() and
> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
> it's just a few lines long, the single function in v3d_gemfs.c is
> moved into v3d_gem.c.
> 
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move v3d_gemfs.c into v3d_gem.c
> 
> v4:
> - clean up mountpoint creation error handling
> 
> v5:
> - fix CONFIG_TRANSPARENT_HUGEPAGE check
> - use drm_gem_has_huge_mnt() helper
> 
> v8:
> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n
> 
> v9:
> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
> 
> v10:
> - get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>

Reviewed-by: Maíra Canal <mcanal@igalia.com>

With one suggestion below:

> ---
>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>   drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>   drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>   6 files changed, 30 insertions(+), 80 deletions(-)
>   delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
> 

[...]

> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
> index 5a180dc6c452..62532a89dd14 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
>   	v3d_invalidate_slices(v3d, 0);
>   }
>   
> +static void
> +v3d_huge_mnt_init(struct v3d_dev *v3d)
> +{
> +	int err = 0;
> +
> +	/*
> +	 * By using a huge shmemfs mountpoint when the user wants to
> +	 * enable Super Pages, we can pass in mount flags that better
> +	 * match our usecase.
> +	 */

I feel that this comment is phrased in a way that isn’t very clear. If
possible, could you rephrase it or remove it? I think this comment is
no longer needed given all the documentation already added to the
DRM GEM functions.

Best Regards,
- Maíra

> +
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> +		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> +
> +	if (drm_gem_get_huge_mnt(&v3d->drm))
> +		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> +	else if (err)
> +		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
> +			 err);
> +	else
> +		drm_notice(&v3d->drm,
> +			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
> +}
> +


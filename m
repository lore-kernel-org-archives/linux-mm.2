Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35747C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AAD6B009F; Wed, 22 Jul 2026 10:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052406B00A0; Wed, 22 Jul 2026 10:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82866B00A1; Wed, 22 Jul 2026 10:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AACC56B00A0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:35:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36C5CA01DD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:35:14 +0000 (UTC)
X-FDA: 85016660148.22.44A1C7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E792840010;
	Wed, 22 Jul 2026 14:35:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoNSrvzJ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784730912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3Dka0Kxl0RaJGtuTH0yTzaDEXoIUNO9u9IFv8oVYKs=;
	b=4S5891iPpPrgOoKpqWgQUxIBMbYLKt64y7YZbLpwSvdYnbja/rCeUTjIvxm5bQGSV5c6hv
	ZjYgEv67QHWbXC10HgqEduas8bQke544VchzQk5VwvjjIqkP8T8t2CI/pk78tVNElABZYI
	mVAeSQMO/faMR7CChYoq25FqBInycmQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784730912;
	b=icVssJoEMVuj3wsvUpqUakz8p+grcCnEIq0tX4967b7CbSuVHjvIzk6BdY1djiaN0u30wr
	ue3fkdZ5VwkRpm5rdP1D+PfgtjZVuWdmf2LWCY+bFFxRh/c1L3j7CptMjwGwH+3l9xIZDW
	CMlFUEONl6yxRCfTui2UBFzXhxuQ7KM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoNSrvzJ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AEBF600AB;
	Wed, 22 Jul 2026 14:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526301F000E9;
	Wed, 22 Jul 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784730911;
	bh=v3Dka0Kxl0RaJGtuTH0yTzaDEXoIUNO9u9IFv8oVYKs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BoNSrvzJYQLAEfX3sCIxyc7ZkwirgsWknsff/Mra8/IlU74HXActL9HeMA579jh44
	 T9qmfb4rlcf+ZSuQDXLSpBUeDY2tak0s32nJdFgrBrk09Qk7VXEx5T5+B2A9t2i4lb
	 T7KREF6hvGI4oAnK+1xITP1UHiLneP8l7RBubqbljEBi0slULes/fvkmxRdOX71MpV
	 bMSLulS5NDO9ufYBlKQbRqcLa2jMXn1Kw4jzPErEyJEwl6CA4ywx5ldWZSfTgLsHwM
	 sBj+KtFeUnsVFLsqvy7yitX1QTr82nsrUT3PDi6UDnxpJzhWaBjScQs6EGuKMa4pWl
	 ZBBB1SQ2Xhywg==
Message-ID: <eea9c6bf-5ff9-45de-ac92-784a174ff61b@kernel.org>
Date: Wed, 22 Jul 2026 16:34:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] mm/vma: convert vm_pgprot_modify() to use
 vma_flags_t and rename
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Clark <robin.clark@oss.qualcomm.com>,
 Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar
 <abhinav.kumar@linux.dev>, Jessica Zhang <jesszhan0024@gmail.com>,
 Sean Paul <sean@poorly.run>, Marijn Suijten <marijn.suijten@somainline.org>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Sandy Huang <hjc@rock-chips.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?=
 <heiko@sntech.de>, Andy Yan <andy.yan@rock-chips.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-6-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-6-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E792840010
X-Stat-Signature: mniamnyxmenqu6nfs8nok3wf3quuoqiz
X-HE-Tag: 1784730911-302625
X-HE-Meta: U2FsdGVkX1+sK+jGhz/xc5IMVV4/0a0vcwBaEj3NZTyfyBQjdcvboyPLlRwkU/6ospev2btsceLT4BZxR65yQhiOKtYXG+lebtPNNW8U61Lagyerx2ga3RbXNMblH2TF8+DhTWYSxj28byh/EdNd5SytCVQ1LST1unQNyeV+lA1vtJcQuaDWNLYumPOYca0/7YRwiWsY2LdneYN7+nPOs3R0r9NG+e8T1KCOYIP8T9vZymU7WE6y1lT1NVTdMw6IxZzTJmJp9I69v1okoaFatWurYzar8Zs3wmzuZ7nltjZSCHcR7qGkqN21vqAWMNmCbitxb93NjIeFB1tFR+J+ADiyCV4nqehYBz5NEhMNMzgIfGUqmWxARcDeyM87479YqOFStPfyEqfUm4CtxCu4UWj+ZWmdiUIXiVyjXVOZc566HUey851bn2+JdKbLynwp7o6jnbwjgwGSeDGLNL00AVmpAP2TCLeYOXAeWIvGX1YvRqs7Eqah8KnsDC2SXCKxbyfJfAd7Jq7NiQeTLhjgfZwB6qUM8ihwD1hqd4aq0Dij75yV9wsQrMjG2SM/U25TsPueVbk3A7mmZXOimgceuNlvPT7JmqWCvfF5LnusSA6LBP93M5x0jOphKz7D1NR5csB4s7lCN1LH5ckGxltjWbetYcV9vebfFqMl6YU+dxUit3kI8iUThPz1V+G4ZBLKT1PaYy53LqewztK5a9ef4Y+eac/YdgbyWZze6BgbNzekbFXTFGxYr1GhFqoZ/ydxNeKrKgMe4lXWIcst/mIzFCiRh+7FNIhjitQTeOyroejJt1z22P3zZJVreNwxqWi1+eJ8ebAo4YTh8iCYvwj/5BGeBEh848Qhl14m3/PC4pRU6XCxtABOsWJ/NC2TNC+53uFaLYm8thhvmRE/XFA50cRz9hbATdgVvfYVzZO83xfiCk3K/IY2Oei3RMzhvTLTepi1hLomMAPDAovz4ZP
 cehyOPvJ
 qVU4DBP4O0+AAEllLIUTa7lmWcEMqKlETai14jU06v5ugbHR24+5O2EGNAqeeE+MxTTPP4REp9RblWBtE5Hhv8EhLbzyUBiKvtz32Zz0N2jzaVcE2rQ9vxQYy6djrC/3H4RukTfHJVjR84TXz3RX00+UTP9A44XZlVHK/za9ifjd2OC3Ql0IJyLRM4XDdyg39gF8rg7iS7RS6h/OHUkYI/u/CChb8LReIoLfcGK0S6r0ugl5+lqyELtPypwlBSSupOuGOGDjjQnS9kKRkJmFT4YlJywrKJdl94TTd0XbqszG+RFqq4eMS5y6opz778tM4lzz5qa9xzA1Wa5K5QpHhzgKfilSaF9X1pxs9Kw/ABILvzbndYDYtc2mnNyVnsEo0ts2O+ANznzQv0uxJwE8PKvtEXQGlp/R1tC2lo7BSQd0xKtQEkngZhAi0fzs8PyFFT3YLF1EZs3b5cYZ8bcMaQfoeUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Update vm_pgprot_modify() to use the new VMA flags type vma_flags_t, and
> rename to vma_pgprot_modify() accordingly.
> 
> This is part of the ongoing work to convert vm_flags_t to vma_flags_t, in
> order to eliminate the arbitrary limit of the number of bits in a system
> word on available VMA flags.
> 
> Update VMA userland tests accordingly, updating vma_set_page_prot() to no
> longer inline vma_pgprot_modify(), rather we can simply define
> vma_pgprot_modify() as a static inline function and the tests will pick it
> up from vma.h.
> 
> No functional change intended.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



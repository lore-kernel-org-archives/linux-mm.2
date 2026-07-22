Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E3EC4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E266B00E2; Wed, 22 Jul 2026 11:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE306B00C5; Wed, 22 Jul 2026 11:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268826B00E2; Wed, 22 Jul 2026 11:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A766B00C5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:52:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D2C7A09E6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:52:58 +0000 (UTC)
X-FDA: 85016856036.23.026B225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D2B8180009;
	Wed, 22 Jul 2026 15:52:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzeLJ+Mk;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784735576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufiVbs4gFZoTgyjZH/ZnFnJ99kcRuL/B6RsmsdF3mq8=;
	b=e0bdaHxalFXqtFcmRC7v0zHHj0spWsYzMZRTfW+ttNveNckiOtoBJm43lVG02HOEFrUvUN
	XQVNx/fEZLZ4voujz6q8S2kjHOalcT0vNQQnVgtXbJS75genNhfj/0JUplyZGucOl8DG6n
	KAwNLqZb2Tfuz3WDMe9CvT6doS3XUuI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzeLJ+Mk;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784735576;
	b=2fILoh6WOr1o9u4+EeSKEEQnfPLlePIHOLxKq/BQU4fFmyIU1hN93mOeNx+ZgVcvTZmSt2
	I7l/pQ06/R7U9Uy3XyLYPR7Hs2ec+paiH1x+SG4sc1YAETMJ5Gio+f+HasNypLzNKGva4v
	8FrzgLtXyagxDxz+LTrHTV0cFT/r3Wo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E5D8600AF;
	Wed, 22 Jul 2026 15:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D900D1F000E9;
	Wed, 22 Jul 2026 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735575;
	bh=ufiVbs4gFZoTgyjZH/ZnFnJ99kcRuL/B6RsmsdF3mq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lzeLJ+MkKsdPmOuFrEroytGywJNyjc5go9z+BRGANnrrerkTLT/cUGS0MryhpCrCz
	 JdnKkJXBXQDM1y9cnTXkAr+L8PkN74T9bfVYvVLVxwI2l26MDbErHm0dHSRnCdonnL
	 RS8BbhjVo2GZtG/uKLPlYNjbwXf0EqigSTo9sTrTgwAXfegti5hbCb82Ksax3+7W+n
	 QT+A4kOxO47PX305QOEXl/P2XsuHb7+PKLUJ9j688+bgVNRQrqfPt/YGk7hqqkhk7v
	 RW33FQF/uI3VdGs/EfFg+aU8yARX/BME5FRohcAXZwHejlJ9HpNhFnfFCSrg51Y2pZ
	 5PZGfjggIWn2Q==
Message-ID: <f241a140-cb65-4a77-8dc9-dfa450b2e0fa@kernel.org>
Date: Wed, 22 Jul 2026 17:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/vma: update create_init_stack_vma() to use
 vma_flags_t
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
 nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
 xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org,
 linux-sound@vger.kernel.org
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-9-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-9-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D2B8180009
X-Stat-Signature: sprod8ahn4tx4fjanu6u4ag9a756n1d3
X-HE-Tag: 1784735576-544556
X-HE-Meta: U2FsdGVkX1/IHkRq1iRtHP2crlgsMDP3mjxDpPwhAmKu9hgFt+yx+Lrea9sLhZXF0RIdoQYF7lKq08UdqcmozY9E38AyyuynUIc+TDk724NEXSSyvVEte1VgjHkP5Uvfeoox3pas9KjLEn12u+3AjCycHDH6WxCmj4OgM2l2JT3/C9cb7AfsUhFS4W5LekP/kQZeYgaDGPIKkcMT3fXEtadQe3G00VkO2J37jXJZTO0SAfc7J/5uork0tnQzaRHsaVF9KVzADqdnhtXTy47ulyz92rOdQUHVllTmHJ60clrnHqbuQxurdPkjcy5af5f49NZna1ba5wD6dPSleJrITOkNPF5ZAindVs6R4/EdeGG67s99siMPLQ8edHefm4M9K+9IP2MFfkZMOx+m4M6q4v5fS5NhiK/NVSqYarAPLDjQNwUpdvJ+229uyLr4G+vh9VU4jgMgIgehPeLWL5P6bqNdz3axr0x4BzmBSvK032AJcOsfVobA6kpjCK+Mbs9BZX+lLt1Lbja149JUz+DOvqIGMIg8cg6K3Sz19RAP6XI2GgbYkfm5hx2y1Hc4G87S6lVNWZY7RAxeUO84+0NwHw4+KR6DWdtgkB/s3tTu/YFdwVYIbeNJiq1Z8XuJjuRV7J/h5e2rpyvkprta3YsOebPJyPHGxbZNL0bn8qJ889MTaEZC/3abFXYvFk3qe/Y4pEb2YWaMy/HZO/fYYOckvuoQsjTLNC7QE7Xv4fUMeO6z84rxTyh93zW4/pBiJObmo/DDG9hB0LANbGFxZy4CS4HNYydfn+klPjGSaZkc+ZxNqLyNYfJMUCj5MY5bCJQvLPD4fnbt/U1BkXnvLrOePqS09iBZgtf9yCZH9e6jQyBAoHWzR3eDD8qMu8sk0prd4fT6xzo1gUUjWQDA8e+fquprZUjUABqlIm0Vgt+srnEJ9g3/2a7ICzs8WEySsgGt3LqeWlR09zc9JIEas+/
 wo53WhwN
 tuiQhGlRrLoh8eh1j1TNTo9IS5YW34Gh7Rt0VlVIgw/3I6ZOADZ+lh6YW1lEvs8kL3XAN/lK0kv6rIsTA+qEUPWCgBncmTIyeRdgKmS/fFKtpHC/R0yN2OC7lKcp9ev4n3ztBqv3Gkej0nFFM4HjxzQXjBSj+wBVS8c2FFSu32szqhw8BGtod+cEf5ahzMYdA3Ou6LSpgOoFNjnEgzVO5tzw3ER2PvAftlR8hMIDGTXxsfGMJlhpNtJDKpO0qgb9qNuAE0vJqdkqtETSV/9M02L/EopwUufZo9prQAKsXw5acrFfAwvwjQDojwQcylMpHHgvxSaDeabtJR4it5zC5djzepm9f3nXvYTqA0GQq2BMgIFn45YTV2eilsoEvuRR9HD+VpDH3rNVtdaMqwZQB5qYg9EChForOCI58gr2Qc+Wpza3QF0yFd1jnuz9q3UVD1IyGHRn7u6fYx31/PCe367I5Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in
> create_init_stack_vma().
> 
> As part of this change we add VMA_STACK_EARLY and VMA_STACK_INCOMPLETE
> vma_flags_t defines, and slightly rework create_init_stack_vma() for
> clarity.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



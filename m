Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3E6C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007FA6B008C; Wed, 22 Jul 2026 09:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21446B0095; Wed, 22 Jul 2026 09:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F876B0096; Wed, 22 Jul 2026 09:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A37156B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:34:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A445C01CD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:34:17 +0000 (UTC)
X-FDA: 85016506554.08.E672838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B174020005;
	Wed, 22 Jul 2026 13:34:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xf2Qo7nf;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784727255;
	b=wM99x5nbOH1llDsV7vZr1pP+HBce9Q0OPTTUlMAbwmHt2ZI9AgfaXwzIaZSipHRnBEMxXp
	cYOFmAdPvPa8Q4IbUB8CYCSh74cuN1FsUVqheqqtzxl1cs+kj/ombd49UN58enef8+NJZm
	c2JPgs0ka/fdLJ0pkSWKApiIKQYhntc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xf2Qo7nf;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784727255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjW3IoJngeCa8GtjqJn2j2qE4s7NfPfHtuHffq4DmkI=;
	b=71D7RxVODBP7yHZ03d45aZj9vCHjWr3OHB91cFG+jcVgKXZLl5pBt94W8ubaNqw1Atw4Bw
	mrOGjWywQ+br1u2d80gOMRvnHSlq/bLxdAoAIzPZ9mBHb+D7Mk8m40twcFgIPdT7EmUJWe
	v5lEgJECXUvYUj7GY9Nmahco7vFTVlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A953A43FCF;
	Wed, 22 Jul 2026 13:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05801F000E9;
	Wed, 22 Jul 2026 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784727253;
	bh=DjW3IoJngeCa8GtjqJn2j2qE4s7NfPfHtuHffq4DmkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xf2Qo7nfk8o5oFsdnRyvwfFlDT+UNHYxpWkdWS9jpYlddyaBbeTmAt4TSKYjBQ6nC
	 VQT5FSiqo8vVJq/R82X3RyjGnMFjVe2qzMcG3VgXV669ofkFC8DZnKS+UkWwrpzb6q
	 Fi0Sx6sVMnRuvnBvyBvom3YRXCjGdDRHypbqW5x1R/Uji66gdMwF7l9mOVCq62z3nl
	 gJr90z+D+N2GhFNNOkLY7sMLu7nS8Z2MkG2ZCFRrrGTu/B/Ym82LsdWUrflTm6uGaV
	 oU9g4AgXa58RSoCWW8YaDO+USyZcemM+PmqZeWYEvuz91dURSvCpGTEaOa63HF+ZkH
	 oAveIZpLt2mkA==
Message-ID: <5d133def-b9ab-4c4a-8c37-3acd05841756@kernel.org>
Date: Wed, 22 Jul 2026 15:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] mm/vma: update do_mmap() to use vma_flags_t
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
 <20260711-b4-vma-flags-mm-v2-2-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-2-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p34t6xzrki9165r8fktqrzsreub8fzuq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B174020005
X-Rspam-User: 
X-HE-Tag: 1784727254-884639
X-HE-Meta: U2FsdGVkX18vgeGK8hWXs0F1bWpJUZcxB2exoPbuA/0vgBbQjfpSMmlqriKM+PsjZYjTVLk/vSIMU58IsOt0CfWJs3yynf0ANOiL2etOzxsIs+qh6uy51d/sv4h1/8PUP3+QNJeID/T2Ugc9pypgO0enG3Z9mOQgJ8cpV2sJP5t7F2CUYsem8B4Nl6OgNk2Er7mnCfh7mjXDDY08aXLRRIzdq6cOwCnrd+4cxzc+yGX6JcVpZh+MsRsz5e7Qky9Lg2FrEKq6WwJAgIqBbJO94rlrpSst6hyBQ1xl8pEictrx/654+XeB0Z9mAaSFr8ribRkegPt8nhTUOZCf06QDsCNhfOjAbbN4K9trmwZ+QUWFKyuR97WBO/h8UzA3HfDp43dSfGdBPvB3/+XPSmTJOf9RwdIgDyBpnE2M2j+RkumXUtdlnnos87l+cLtV7i/bCiv4cmoTn1yL1k8UM2imHe/mMtVyLu94TnFkd1yCWxTJANh8LeNjEKlwuMlP+la6pFdysmWhcjVZQRH1jpg1JOA6Nat23Y+UyEDSBL+OK2iWmVKCgD2h2BaiuKT3LI0hcPOuTYDymJi/pGFXgNmDFyKsENI6WtYcPYOD8afQCUTzL6CCz7xA6GlFczXUtkGHdUS+la+v2e+fvglvUkY+y3uGGEIlMFKCRVE5aHPc0FVBZqxA27Ro9HoHXaURQFFdpj3/wZiEa3630DexOuaaBhNLE0QfXPhCNwsgE9vYGM4Is/dTI1PqH3xSS23Q0Ou86i2yRLeOdYBQ5E+t4I6VVmwDp/c5MuUwj+1Pk5hdotKgX4t49xBEEjYQ7MFs48kraOVfVdjz03vekWik6SDi9wT4TxjeFIhGOg7mgUcuvXJzVU3ZtUtIN4JK6li54hkvLRmFHpth4R1eBKdVeVzzw1KMsnfGZ2vfBX/GC8e8q1PnrdNYM9CdPrDAYaO2eLtTtc86QdRzRDpJntwx/ou
 HunQMFQL
 B53Rg+EJttyHPkfz6VokVPxBzGRH0G2B7jV1SaJUOnLwNsXv6bWQUU8OtGDYkhOfO5uhWCqp5dDCUvgkuILqz6EoVB+q7aePDcWmzImI3h+g+tcfuu4mUSdTyEWgFGlN0qiFieeGxBleEugqZAVxNidjN1WrQGOC7EqLbhLhI7xJjJwDujbBf6ygNtzkHjImyFFXOnjEhMBPWqO5jcn97H+TEWlYGFHpb8lYssZtO2xNCFzy7rW1yTsXsFsXYt/m/kX0liIGdE7FoVFof/SnsaK/EMPoBBwS1a6kWwAl4LadgETvbviHUIT4PPQB8eZiOhCgY8S5EtfeA4gfAyZLTyPUfbIDJ4ERikfcxVQ0ODwYyaVipNiVMRbxv+S1LvySZTBBzmeYO88H8zgLDHbsSqt76RF5cgm9DvGAuPhd0zebdyf8rw+jP/oo3bcKszxq56Bd7/ZvyhgH32d8W3dZgDUZ0GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:44, Lorenzo Stoakes wrote:
> The core do_mmap() function accepts a vm_flags_t parameter which it then
> manipulates before passing to mmap_region() to do the heavy lifting of the
> memory mapping.
> 
> Update do_mmap() to instead accept a vma_flags_t parameter, and adjust all
> the logic within do_mmap() to manipulate this instead.
> 
> This is as part of the ongoing effort to convert VMA flags from a system
> word size to a bitmap type which allows us to unrestrict the number of VMA
> flags, as well as gain control over how VMA flag manipulation occurs.
> 
> We do not cascade these changes to all functions which accept vm_flags_t,
> but rather use vma_flags_to_legacy() where necessary, specifically
> deferring converting calc_vm_prot_bits(), calc_vm_flag_bits() and
> __get_unmapped_area() to vma_flags_t.
> 
> Also utilise the new vma_flags_can_grow() predicate which correctly handles
> the case of architectures without upward growing stacks.
> 
> As part of this change, introduce VMA_SHADOW_STACK so we can correctly
> handle the case of the shadow stack not being defined.
> 
> No functional change intended.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



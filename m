Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7F7C4453F
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA06A6B0088; Wed, 22 Jul 2026 10:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51976B008A; Wed, 22 Jul 2026 10:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C409F6B0098; Wed, 22 Jul 2026 10:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A17406B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:18:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 287261A018D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:18:07 +0000 (UTC)
X-FDA: 85016617014.01.DE5D95F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A944B16000B;
	Wed, 22 Jul 2026 14:18:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4vdnNdZ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr20QdluTC6Xb2QJCx/L2OqHD3wYjRZzxUHD+ltN0io=;
	b=WtIc+FZZRdriGDK8Px9mMA8W0ZevKNrFIJWLjXm5on6gCNNFPOvvHxiuXFPHgaEhFyslb9
	oR+K9Qt+mVyBl+WXd3e7FoDhHl301KkId1cWK5Fjds+V9XVrITcaiSJ4sipzYJU2XZ6mNB
	JYZt0Qkxuz0I0YR5LDf7X3UV55TCA3U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4vdnNdZ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729885;
	b=EEo9Ql4mb3sVX4T8WoaPRv8Laq4JDrsbk6oN0t67nIcjROEtHPqjp2j2G0FS/X4wgfIRJb
	3SqzvhK61nijIluMuEMlg6QvGTaXHMhbJ7Xo2WzyPCfedldaSvNdxRXFBbs+GTOWbKkdN2
	0I+LXwvB7JjybpV3on9tvEhPOZGfSVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC1C4432E9;
	Wed, 22 Jul 2026 14:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998571F000E9;
	Wed, 22 Jul 2026 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784729883;
	bh=nr20QdluTC6Xb2QJCx/L2OqHD3wYjRZzxUHD+ltN0io=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a4vdnNdZSy07RDuS+C9gat8xlWANgEMGre2Gt8w50+S/RARkD/NxqriSXn9wrozPj
	 E5W9CBr1d7eepeguATkGjOrPXaqKaMp0+xcdJH6JVLGWRdkxSRqsBQirTItAu9VNRf
	 xKAJOUg/URAYNGPYd8y4vGKj+ONw/nWOpgBtlfPsR8ltFxfx8IoinmWT2jtQMA7WpP
	 nozoGRCEMkB8851Fg9u/prJ/JOJKbaLEpz8L+8Zr68k62Ilb0p88pE+y3ZC8cSKbhK
	 kBpgQZfX/d3Rxy5rU6yBQqCx1AN3uW+o51yyGmm2In6YviRmTxHVmf6qDl7Zlbt9Ib
	 DwnPnhWrhgAMw==
Message-ID: <ac18f5bc-62a9-41b0-8980-a4c465a4229a@kernel.org>
Date: Wed, 22 Jul 2026 16:17:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] mm: convert __get_unmapped_area() to use
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
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-3-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-3-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A944B16000B
X-Stat-Signature: b51qmgj56w93mqczbjf93zbood59bsar
X-HE-Tag: 1784729884-778708
X-HE-Meta: U2FsdGVkX1+hGCnJp0diqPD77XGqCZBfYgcENqreOxkpQybaOyqirNFFe/iGzfQkTBI1gmoW8nTX8mfXwa0uwkedza0keYl0d/3NpYR+kG6qSRWj/x1FgcCKPDbuw5tgnPfYp4Xw+xdbGZsu9pZ49nTboLQ+JgaqfYsr6ke/ADmRlLmDyYggRH7TMjXC6maq2bhbnyDjza+wCnAzNgSlEuaUWLl3E6GeNINMd+ZEd6+7zXAjKCDdoeWKIO3DhA5ydssWdVBhChwVcFYX/FObPVlwiPDmIzNefhVOz5ULTBG5pt0m0BUuIz3kBVLqz9DYBXBw4LH5EuZtHUCw2ChrM15nJNscW5FAzr+AU4H4ltgQ9/ojGz9nLvXM2PejrHKWUYVJ1g1TN58fCX8kauUlLOBKsEUmJ0B9Q+C76J1vVJRErcIZBXUJM1q9/+jBfU90ohprd3PjYm1uV8NuOnpGPsUBy31pekgN1NrPq/cNqXA/JQxGb4IfKKwL6vkqqwzg6huFHmHYuyhsdGk7Pk6RsodXoQb5sJwVoomkT3BJArvqZSjrlzGSlInwHx+pEIqTe2y+uTPwb7i9/ql82tJAiSDmdZRZXurUwrhEi6P0KvjGDcWYt6k2uqSDgdXvo0s2uQsV4rcv4ktH375NTQhzMrl1t3WEFqL7+VUKs+nUinulSOaf4uL5sSlvk7gP/79H6HdD/QUuREBZr3w0kahU8tgZf6fH3HK/SILDYUY/kk1EPHIzUIjJTHGpUl42x20dCuIMVVy4oe26dBsNIOjxjtK6RTL7kjImmLhDgApp1Z+6wSEmQPMyGinxwene3+JsXfp22LK/CRTHL0zbGrQzZZ1pS5veCWv9gU1n5/dT7EEb0V4EFx1IjNxv04igtEVglrpW7CxsQBVcmKIdoSJBYoI26P7r14iRtCgLbQlOMFoto/Kprwf7r97FG/jPQNAYyWgnqwzCCMJ2UOv4hJW
 MODmChB0
 XzraAhim5xiLFQXg2QKsZWDPdeFTTwwpWAxqH3s+QKh4wRMGHd0e9WM4F72vl9eprNQUYdmzgmPS6FL/K3HIjGNh4q5p3BrVcV3+6TpuDSZ2y7dW1usvYqV+bLcpQ7DWiD+jkK8+gGe1iWQaGQmsszWmrsaTcbvxWX8Xjibp7OfeIKwyDTG2HhD/BPR+WliMhbwxmB3oapEU9jT89kf6D/WSXNOB5v3QO/Wttq+cRsEWULN4HPOmZqEF359V2UbIsXHvP25GUvCKXw7gZytpGKkk/cS3qIUag7aVkfKRAHIA8dxvkkTnKAozbeqgyQuUPjh0R1j6jD9iQmyg5B+As1km4vUMZRV0czUUyRlyDJL+/6KN+m8g9Znu22KtXz+VyQP2CnurBze/7A3q7ql0bxUcK3hcFfx9Mv7aHQI9AOHF3S7cjQI05tDw80dfobyJzPqc6EZ2HCkTwRf63RPZca6rfDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Update __get_unmapped_area() to be parameterised by vma_flags_t rather than
> vm_flags_t as part of the effort to move VMA flags from a system word to a
> bitmap.
> 
> We cascade the changes up to arch_get_unmapped_area_topdown() and
> arch_get_unmapped_area(), where, for now, we use vma_flags_to_legacy() in
> order to propagate the VMA flags.
> 
> No functional change intended.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



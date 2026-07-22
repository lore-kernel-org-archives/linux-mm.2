Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB57C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F866B00CD; Wed, 22 Jul 2026 12:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFD66B00D8; Wed, 22 Jul 2026 12:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDFA6B00E8; Wed, 22 Jul 2026 12:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D34B6B00D8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:15:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69D664022D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:15:36 +0000 (UTC)
X-FDA: 85016913072.29.F258791
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBD9720006;
	Wed, 22 Jul 2026 16:15:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZFALzRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784736934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtoXCA62CyJBNC7Tbkqm6QUVmIJyF8vWZgzG8HkNlzI=;
	b=gLzYh3ceQIuh8x5gkIp9SOn/P9QmCsAJl3ku3QUB4Rfqo5MIHqZ3XfBuNBCPGJ79td9G+4
	5hrzWXLB1WGqzOnzLV9VkghXAa5u4VdASK4MxqYAgwvBLSV43Jq+s+yWwDS78kq8Is0Qfk
	+AIpOIP7ctdvtLKo2Ot+h2NAn3giKbU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZFALzRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784736934;
	b=Xlavyt6ve6ftGybw5cKGcPRDuibsXWI3+Jdx2gNGXpgEUTXcPO/c6g5B8f9/fSo3G+wvqG
	YujYiikOsLKAsWWGouSb4G/3u2QZhNrn5EyMerKweebD+4kuldfrVpeA/po06WLKJ4WB5o
	8M8CRF5aJLq6Dyw7kyv/4ogohSMq3pM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F414E43964;
	Wed, 22 Jul 2026 16:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F941F000E9;
	Wed, 22 Jul 2026 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784736932;
	bh=YtoXCA62CyJBNC7Tbkqm6QUVmIJyF8vWZgzG8HkNlzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DZFALzRwUkrcWF32RmBloDBG4APMVkGxhtgaZyfkfq4w77n6RpNrdAHXIykI0LwMX
	 tGTerPv7RnSpnWTQAISeMEzjQWr0uGJk7k+k1pIaGnKeBR4YxJpt9RyDLS1Ii9bIGB
	 43/hCcIIVUkgRJS7+JSbLJBvsJXvM8ST2ld2ORuO4pGg5dZ4eXczqK6/TJ9lcC7zTV
	 184NzHUANyj1upIfiufIzTzgFXEU4ol0nH+6Z9pEAlACTIbjzOLfqyhBSUIaxXrwXh
	 gLiKpiTLLNgHpkBvl6V4zRf6clxml/U/1TOwopiR7NwCRl7coCul519YgSFNAZ8pPL
	 5ogQPeJG8QmfA==
Message-ID: <fd9defdf-5d82-4f07-a496-4fe8064710ff@kernel.org>
Date: Wed, 22 Jul 2026 18:15:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] mm/mremap: convert mremap code to use
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
 <20260711-b4-vma-flags-mm-v2-13-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-13-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBD9720006
X-Rspam-User: 
X-Stat-Signature: 4mhum77j5rsak1hj6sciyizhu7u4awpq
X-HE-Tag: 1784736933-28985
X-HE-Meta: U2FsdGVkX1/eoEowoSIUa3jKG1PDRquspHYZ1sHM8R52xZGhIVBkPJzEgcFYRobjcrIr5yHFLlX0d2g/PlAzuDGWUCY3zORoXju/9HX59Ff9lYMAKm6/Aa1KK5YLOzhCNRjU1IaM50cPggYpCPGLPlQPaVOH+gTb0eZV2OR2X4/fIAujcvVoPosbcAxILfALP2B5wfQAmR2RL36uYP/ryI/jkQ0VEQ0a3qAtSu+m++a7rlbNm2jl4ofK3j2wXsdaC9sGN1E6aCvJsz5uhspjYUA9+UhR7VoHp4RDEMTNJJTQv5NOmhL9c03Vcn6V5acGzARIUdH55rgS/uPRY+BnQqt6HbMtrjagrajP9BAkpbi0wi7Vw2GGdmpZF/C4jR15fm/+3wC3mP61ZI56wosnKw0Pjxda344Td0ZIrOSrXIuEfeEpcrpEqI5xB8XPMeff54SvhtO7AST6F/KMHhWcM5XrDPBlms5bSgImGXtbwwlz0Nkswy/7oXxyIG3Opi9FmSZpr6op4T8SjqYmq3RDIu0ibjiaMUJySnvuddnaLx7X4x5cXtLouU/oMMF7n4sQW+af1tNaxmnTIn03AhdzEuio0jdkI6mdWuFlMQE40nBgJzhKJB1sJ4Mt7neqXpdjOdIJa/ZTwZLYNqeMFfO3it0UZlBqMjRfLOiwwNcMyaSrJc8VqueeuqRZn7/nml/L7075CuX7zu5958lF7pVwUPlAPrWX6S/Aop5BZ4EImHZeOIUiELYd9iqBEAP8OqbnLACRjhPL/lPUrgdsGZ6pkmDfoTf5/xU9VmfV4EF77OnCvLuNrndPtPLgVGwGZ9IAPycMmUkA6rhsP4+YMB1ktAbNel2/hhD5OlqML50cvamNy/urCE53f9Dfl7DEfyMB+p3QO/afQMVUk/ph+MPR210poGJIf3GKANkDVj0Gg9VRMyLcAKDbkZHmeJg3FjJKe+wVvKxW9gk2aprGVOj
 aNiIXEv+
 VkKJoG/DX52i5/W8U/htYT3boFm+otdDgBKkExtOKskGsLGMCOnL4tIxsjATRz59Nh9IPCt1YoDoEZr0YxCSJNVcbawotJQxnJtj4Bl/5oL+3CvL/HiXXfMzXkP2kEVK+JnDfdSP3DaDWmkKTs12eXwl+yu9gUQ6yKKXn7WH3p1h9A8PL0DFfLmwzse0tSH7fCAqO8GXjdGF5kTT6zwlNtoUroUC3He1mhG1lHGiCHaE6O7AAWLqi1b2az/pqwNAfIApKxMd0f+od7I/X2plVArPSWcyQCmg3vPUQ0PxIALwjqrBHL254yPSYnXwJZ/Ro2HeOCNXuNmy4WbbFCO8MryH8r+HwxUYS0JwSefXOVBFMc9YW9w+PnyUGh+oB0KES3ZRTqwy8J9AH2pasT8kcG0pUrdW8PAtaNpefb+2Zq76VByMAQPw2OBQVX9KjpvfNDKH0C132+jqsD/l4X9JgaMUce/QvDWPuGo/7T+VcxotUFHxOHDt+0TkNmrz/2fnN0mkzZruvLT748Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values
> throughout the mremap logic.
> 
> Note that, in replacing vm_flags_clear() (which takes the VMA write lock)
> with vma_clear_flags() and vma_clear_flags_mask() (which do not)
> respectively in unmap_source_vma() and dontunmap_complete(), we do not add
> a VMA write lock to account for htis.
> 
> This is because, in both cases, move_vma() is their calling function and
> this has already acquired the VMA write lock on vrm->vma whose VMA flags
> are being cleared.
> 
> In the case of vma_set_flags() in unmap_source_vma() we do need to do this
> - as prev and next were not necessarily write locked at this point.
> 
> Additionally update comments to reflect the changes to be consistent.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



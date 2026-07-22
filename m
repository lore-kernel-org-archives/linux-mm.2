Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1CAC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAE46B008A; Wed, 22 Jul 2026 10:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BCB6B0095; Wed, 22 Jul 2026 10:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C460C6B009B; Wed, 22 Jul 2026 10:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE4F6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:19:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F61BA01DE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:19:57 +0000 (UTC)
X-FDA: 85016621634.26.00A430B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D48B612000D;
	Wed, 22 Jul 2026 14:19:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqxaWu0Y;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1fZtyJMG9BfhlBz0sxJsvbizOy4XPOaAolVzZbKG2U=;
	b=APY6B+l3B25Bm5SCCDDSkhdsMQFwfbK1XXQgEXscZIWxYKgcuTAa8Dyt1qjNoq86vNn223
	aYnJdUNBdo06SCjy9xtIO67CjGDXfoW7RC4ScEXpdqk6wI3dvYX8UtLzXb1LVNqNP31IaI
	uXKBRkLQmyegesAgQT0C+Erqe3FL8H4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729995;
	b=mPEfzH5jPHSkPiGkyWgj4BKljlxqml3MCNfrA8ujKOt6h0OHvuT11LjIeQfPTCEDTnN61y
	zaXtTeDehVxAn1oXJz4fs1Ymgd7oSEIcO1aSjDADUpEADsNMnIQTV1l2uY5wjo0THRR6F7
	h1rn1+4NdFaPNXbgGVvOAPRSSFgGC2Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqxaWu0Y;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02F2244A98;
	Wed, 22 Jul 2026 14:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6961F000E9;
	Wed, 22 Jul 2026 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784729993;
	bh=E1fZtyJMG9BfhlBz0sxJsvbizOy4XPOaAolVzZbKG2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BqxaWu0YTlU0ACbArZmL1FzVAFZZB99uC8ks1vtMhYpCgqApT2szyxYcg1xfNPabV
	 vGSiTNffzTx44l3VWUJEAhlKvwfBY3Xra1IVdmogCBtFsk9nzjk+BGE1KLD5RpS7yY
	 xng/3auPQfLkXlvbFds3mkE+ZTq8CD+HG6nXSTfbPPYRYcfhkE8M7wT9pQKJoGIC6I
	 AbYfEKSjq3JxuczuH2nnoB2mE1hfB2CFJxBsxovd00Kl34r3hXvL97tmTc4k/sHWSy
	 TmquS1Z60ecsbwmO27nqyZ5HdEjOPRSPo1EtEzsS8vtOCqC7V2r8idg0kkU4mns8HT
	 nM+l659nsR41A==
Message-ID: <141b2b88-477c-4f54-a378-fbd3bb596cfd@kernel.org>
Date: Wed, 22 Jul 2026 16:19:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] mm: update generic_get_unmapped_area[_topdown]()
 to use vma_flags_t
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
 <20260711-b4-vma-flags-mm-v2-4-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-4-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D48B612000D
X-Stat-Signature: r4u19eyj6z7oc18zu78pkmbyzxmotwr9
X-Rspam-User: 
X-HE-Tag: 1784729994-293579
X-HE-Meta: U2FsdGVkX18qEfi9t03jDRxb7WZFKm5fDNuRzYo6yHM/SleeZr6d4vJm3n1XD8ONTCe8M8yYc3GVrwNMC/0cr1WxyBoi0a0iciYWgRQxfSki9IoCtWq3Sabzt5Jd90lk7nCv1yW1d2iTyq8o9ig7f0vZ4M9+i6Lmx4Bok63P0e4HjLYhQKeItXL5abhdfS9agKI20JhefMC8b7w7w7Lll7VgFTSmNr44srIRoD4oazfbJpz6kNvNIMA8//gErrMoPcDMWMPgd2ZXvgaAMn+ZhwJwooEdDpn89pt5/LC4DPSyPdO0slqkw47rFFganMqyNq0yUNvegmKA/VhxetUpko9jhntidBiwewXlpMvOyYG7YZLNbhbx5S7Cl6TBiwGlwkhWPm2fWt9SUy68Td9ABKVb0EZwDZ6wjtRxHVmywgj3ID/RH7TIzaxnaxx9yFsZY9VL2N/0OMufUkhj5iCbOfubWOUjHii9uCffX5TKp22OHUIGVKofhgm44PvWeMuJ7nRFafr93WwqPAfeb3qzAUCnZ+8EVRSjlZkusu2LCt7Yx95IzRYoig44RrNuMPJ+liv8b07fRitXa/IY4Wt9Fl1+LzyFOOz3WMCqbwNq48nNPqFMGEFEPYkp2IRtRpXX/fccfA2wC1nFo6lZvopLqiv+iQkb10n17QMMsHV+2+bpXD0jJx3+uZXrNAm1+NW37wE9FU0yxNPgUNeYttVxNuEy5UvGPNieFdNPZRbGCtjKURrtZF170qt37LG7AflFBsDODkl1Tm07X/ZBo0/Z3H6ebhGggg8n4BaGDtzYto6jUJiV6gglZsKR6Tf/MpLeNyj5C55kcss2GMwOOaO1QdRdQGgQae19R3NVvCIfB3TG6Ea74SAb8XVkvgi7EKGt1c/OVjOZC1orhDid0MZ8741BMDJx811AeZWT9WCzYQ/EE/C0q6zXK4MSYO9DiFtI594Bl86wzT29oJUMoX2
 hqxXdzbx
 WHI1aNHNA3n4QdKFr5TxZeOFGES4x/DBDMWJdXgjqqnbCuCYTadoycc9qQsh0RRnLEv1zQj3b+Qd6CPhb6IHW6AYiPsR87AOM7nRrvOcpIK/eDYB2bWvta55EJ7JQhodJHfBVvYfeY1RTmdG26Q2ef9JCw8VKxXMmoNB2nW2PCK9u41SznzFN13ln7Zbt7T4aNUoA0JStgRoA/dCy9AyM3MrMVOZt1RnIJJv728VjAclB5F/dFoF2EqlDAURuZkc5sRmnwcFWN7Vgz3YY9Vbk1oxVxsTo2owUx2vXVGiuYdZ3pk+XdjbFwgRyXDOkgG+CATCxaFI5DZsat9b2kGs7edj8opDS318epbaZGLKEU7EneDHzTwGpu9h8JIUqpEX0NRsv+AMlMNSES+xHIp3yn7Mvc5NnJxx2AGcuqRuZsxm2TaNdl/cfjzSODgDCR2j95+k9tibcif2QgQ3aI++Yab70HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> As part of the changes converting VMA flags from a system word size to a
> bitmap, extend this change to generic_get_unmapped_area() and
> generic_get_unmapped_area_topdown(), which also allows us to convert
> stack_guard_placement() as well.
> 
> We retain arch_get_unmapped_area() and arch_get_unmapped_area_topdown()
> as-is for now, using legacy_to_vma_flags() as necessary to do so.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



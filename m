Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D54BC4453F
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EDD6B00E7; Wed, 22 Jul 2026 12:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09C66B00D6; Wed, 22 Jul 2026 12:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD09C6B00E7; Wed, 22 Jul 2026 12:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A37C6B00D6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:08:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F717140206
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:08:23 +0000 (UTC)
X-FDA: 85016894886.05.5C32B9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC58414000E;
	Wed, 22 Jul 2026 16:08:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnL+GDOW;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784736501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70Ep7Q7Q+hOHdHGDd1WlBsRT3Q12DveziwsIcTZZXqU=;
	b=gMxnEi57F1egBgERiC7E/wLY5+34esTRcmEcIvh/AMvOVr265hPJcIi3lSEpI4K7/Na/0q
	Sj7r0oK+Dd2xWh0sb/HHICdxde9oqt6GAc5y7cOGgfThCcaKGKAJkBDMDsyWOWdhv2hrQQ
	Xo7MH6lCm9sY2/B62+2VnAI1xezTLMY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnL+GDOW;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784736501;
	b=sYQySqActocChP8Hcz12dgYwsA4XxGT4Hkk3JfFmhAsU080oB9WEolBvzcm1tgBUMFsnAf
	Zr/9MC6lr7ugVS8QF5w+4LyiwIZJb8AC9oKLwZoC24QFb/GoHiXbtPQmMOY2eGOlNLp1pJ
	K7WUk1SqVDPrFa8F73ymdTaV57HAI2I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D58B4071F;
	Wed, 22 Jul 2026 16:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482441F00A3F;
	Wed, 22 Jul 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784736499;
	bh=70Ep7Q7Q+hOHdHGDd1WlBsRT3Q12DveziwsIcTZZXqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lnL+GDOW1RNyK8faVj+xog2qSVNXd5RW5OZ1TweaueH4vffC3geYYJCYWnNruwaiS
	 SQlqDRNKNPkeFV8pd50akmXs+sysIAJx0dl4qQI1kgjZ6kfYnGNgnNyvZO2RHeen8x
	 X1qP6AX16FvbgJG94v217TFQnJ+LPOkihf1JEqv8cWcYINv3KHgBTg196eAiyyVzED
	 ODqqwmPRIhhkkPjChZPamQYcsNbf0LXo6MAgOs9eBCf+KjRIMLkkN7puHDnEuCp48e
	 gcPqy9EHh5p23lLq8nqHqbWffgpAuBPw/rHyQ4KXf/Fx6ZkfX9yv/WIyidH3EEOx9c
	 uKXxeAZUsAjDg==
Message-ID: <c363ab95-8d8d-46e0-b9ec-d827664b21a8@kernel.org>
Date: Wed, 22 Jul 2026 18:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] mm/mlock: convert mlock code to use vma_flags_t
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
 <20260711-b4-vma-flags-mm-v2-11-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-11-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EC58414000E
X-Rspamd-Server: rspam01
X-Stat-Signature: awt6xybhxzfn3yag38qchjbsjeemo8y4
X-HE-Tag: 1784736500-555643
X-HE-Meta: U2FsdGVkX1/z7JuAxUeTV/+pLJWWCfhsGjYDQ244YCeSPTgd8syBlYwFAP7Q7NiIDXNzsOTIXIM6qvuwCLstkshB3CDXT9E5D9zhZHSidoJoPdOfBVNH1+d0uVhyJfbcKV7lCsDWAXYewgrBgCztfnBwcBy4x9DAO/JWKycrerv/omt84EHcTc5v/Zs2FWmo0juLQ9fMsYtVcYWQbzV0OXTbg4Y/SlBHzI+cXr9V7RW7w1TzPdfLnJOM16VzDV2TQ0Yk4H54oc7RFVZq9VS6cR1fz97bJ5FNKhoVKD+CGmw3cl2Sd0vM9A08jQdr8anMbXr+W4stq+MAxJMLd8s67dkSk7GPEKG0QtKh3bmZzL49u8JqS5j1FSekvbzLk9Tg/8Ksa9j313x6E+Z36H09bMPD6QIBLTNUFr2O3XGgZGBYlaus4BYU+sHa9m5gBW6qKg8h8iLzgXW+nf/UDfSIIj03AAP9RApAQZVqJie8xF0rcburM6VO+dfclsllZYzNldqOYoEPIMaVLoqqr4q4u/a30MZXHD7fPqc8y1WikBxTeScPAYsghDkyE9emo2iNdF53br46tsMEYeyJjaWVY3glSG5fuiubb2TpxI+JTJ0DcvI7W4EF3B3Dl7H/6HUFiTueiYPs0dJx1dCg2nwMJcJkTCxliTm9ozHPeABb+qrUKT+nIK0pjoirbxW5Ntxlw73D+5sSQklCUMob/cZ5/RCqALPthvDheE0nv5qASHQ2OoS4QYnUm0Xow3CJNWRfFqcpDqLUQmglHQAYGPB3Coxq/PW+Q7qPKC6obfD0MWzxpWmRw72VEY1zEG8MaCQY9X46H3eww3n07N+PMYBiGF3c6dt6bP/U0cvQRVKjGUgJv8FE85PxH7cZnIvYq9Mpb9QNy0FUqGe+VEptWh56CLMOakA8DVsmgj6UpKkcITTgI7NJEWkb3P9J1utqsc7BAUtIviJlbA6ZJ4axely
 tFqs/ajJ
 F6z6GJ1STKTZM9r6XuBkYi/hHhlw9Qt+uytWhH9wLO2OiB8K4YINgy18QEdkovK42MTmJvfF7spuYOtKnJUEcw3Ok9mpfQWpscE/DprmYJVpQOnKni0GPXczPCtmJJdaQ7MCrTnoSrv9fkzuBM8+h1q2XF34Res49J6Qwn+a+PnADqwxNjCfGGdexuULJLKzT58IlkrTgBegOjtz70bGlP0mJLDc29GEA56ca1khjcZNH/KjVoLcFKK3bRPxw63+OvuehLRxpRrrV8phJI7s/6UjRZpJi4GH49mljvZNoAkFOHjKE/Lzd8iQx57RSuBVaBP+AO/fZqjXt0QJWNh/FbnFh0Xuyk9a7fQ423KdpLUvL8RdJc7VyF9rS7ywefkUr83o5RjxOyvZUg4PxjvyK0LJk6XFLQR0NdydmdBpUmvoU/Y+eA43huFZDj0N0cTLQiicFKUTa9HFAgRIexwaS3To5nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values
> throughout the mlock logic.
> 
> Additionally update comments to reflect the changes to be consistent.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



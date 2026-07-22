Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79964C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B606B0096; Wed, 22 Jul 2026 11:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512756B00A9; Wed, 22 Jul 2026 11:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DAE46B00A7; Wed, 22 Jul 2026 11:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06B0C6B00A5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:43:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89E0E1A01A5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:43:16 +0000 (UTC)
X-FDA: 85016831592.17.A0098E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EBDD80008;
	Wed, 22 Jul 2026 15:43:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLM0aR9e;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8WqCRRmqZNU6m++x/hJd+wI7SHuI+FdIhlbamrdG1A=;
	b=gNHKB3u4lLWOz3fxFdt3TifmkFU/kLsEyn4DLUUJ1layV2vko1h+eG9WiWtnjz0iVXT7dQ
	qjI5ysxo69kJ/F1Nm1gwaaAbZb6pujTVARSwkZKGO6godYIG2YNKL7JOYHYopLbnNKfGPn
	E/k4g3tUyIsvYfVUt4k8yeBncDEtkHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734994;
	b=0PhhuNWlXYXbkWeg+YdzQFLpdYviqd9HNyRQC+Eqt7vbne2JeNphXm3YdYwVA1KzIqYIAz
	jILpqRikStYrqvCs3Qn6dLEPaLBRlr0RxnKABFeaVvVRNmcJdjhxCe5V8oe2RUfDPSMvb2
	5nQ1JAd0RmBryYRium4ZDziz3UlPyXk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLM0aR9e;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA1E540977;
	Wed, 22 Jul 2026 15:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604121F000E9;
	Wed, 22 Jul 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784734992;
	bh=z8WqCRRmqZNU6m++x/hJd+wI7SHuI+FdIhlbamrdG1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CLM0aR9eFhPZ9spOJaHdGqkYPBvjwdadVJYlKZTl2YKiFfjcVhRSxPh1PIcdSZLqF
	 2uDQVrjKOL7KmFktl7pClbl7cKII+MRZc9/6UaOyQfALqfqRWzhAtz2P2hISt6DjII
	 CWqB/cDSvIql3IGoYwtilPu5JaZMRbvxlUgx/GqldGAVbyRwWh0ci6cxI6Nrz0fqLU
	 /E1KAynocQ7mEgmRpP4IShX5p2k0UIxlo2mteluahBk9DcIHRIpb9ZDQ/ba/6DRjn5
	 oYakHop6ZZ+DFl5M5Rcin/qKgqClJMkqtRONWZt8Qxm6ThTbv5R0wMwmL93ssw6GKd
	 eiwmeo4mk1lEw==
Message-ID: <2eb7b45e-0bf6-4b09-9b8a-ecc0f57f2c39@kernel.org>
Date: Wed, 22 Jul 2026 17:42:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] mm: introduce vma_get_page_prot() and use it
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
 linux-sound@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-8-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-8-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3EBDD80008
X-Stat-Signature: 6n86yemrji565ptnzy75g7z5dxqe8s4f
X-Rspam-User: 
X-HE-Tag: 1784734994-438486
X-HE-Meta: U2FsdGVkX19ZJLPg+6kRw/ZpSPDn8WLvT7UYbnr2nq08EmrIdBB3zlZIuIXP/ESGhgLOqSN1BykeAJ1hzF2NNxtgC6wQgyEMzNh+o3aJtaRupbDp+L7GxaOA7BE2CkDdyV8SVzZlkIk5fv7Lc1eo7PPo2XJPKDZETdbmhPBnSIOaLvBxnQ13S7pSufanSYsP1m+ddtleb1AwCjIAbXhroruLg4yutj+eu/zF4QwcHOIXdmEINdazvRt5WiAJSXaYPCu6UuWZUOewrdkb5TTrCnec3JgIVdt6nLhh6NgeWQV4oa01pDzsAW4uvUJu/pwEavF5wrsEVt5SV/3KfmW+a+3KW+DbTPsx3c8J6A8SyDIevlzsFBhMD2hpdJeLfPE3IeNoF0KfIjwVAnxY5lK6me/lkiFfIx1gWAeOXfYakeConpgKTJ8pyAP7Mlqxs0hHkboy5iOdd/L0lx4LO6MzzJ7khqwpFd+bgcaW1maOKKsg3MDJenkMJshbVewqL8X9IM/v8WKeFJSWQawHT2Osc3O+5A1WIGk6sB/oe7a5D+H2LxLrZd2YrBNRJro9pfcdtGXIpNBWUUSJgrsPgucN+zyMccaC7mqjiYec6R5ghnmG7kVUSui+/TIj2R5MQCqCMB7nxIuwInRvuLbBj7LdBHuYG0bGVC3BDcmgBclzVWtVtGYVYtauIcKo6mVib/swqblNuABYqQKpljzL/sNaW8dnOCbe43IYZPF0vdCiflIMssK+sWUYA6KZfFawpBCuU6M4xie/fF7kcZwbFJuzfstIOdXDZV5DN1RTjOELO4K5LJNmqYbWLvmbEj8RaMnB876EHuSuPsTFHXkj7qYJ9LGbTRK4FqEWgYxX3QkGD+kBHdhbC3M27yJHmFnloGjwJCiTdp8wIsMk/5it/t4bOyoNZtSbvKCtid2xnzraICZ88s70qnuo2uLYQLBLcQ+pKoT0jDQfDbtYc25PIkX
 OX5JyOpj
 aqwbGw5fbla0/yYbCkjqIrENkAWwjHB7NHxotHhLtnwJc4L7+4lOTrp3fo688bgc8wbkvZJXt5YXXWCA9ACixtKLazldQJNyK2BDJdoHrT3PAMnIFZ35g21CqwWpqVMKY3M0OfXtpqODv/99sq7mkuBCGc+g/S12ghTl1aplpppYPl+pho9ujjO14XavhZIsEBTuvaVn+cCKzVWu1zK0QoL7lMGK4L+qOIDS3ElAxz4/8UzajAJzF/RP5stxpqr3AErKiVgaG771XAgxyDrdkq6n91lE0v2Ja4OcL31abOFLPNTKTpUJV49CXu2syJUT2L9sTNWWrmFfF8ZrQmI+cWpI+qdfZc3vQ71kYY96UmNckpSpOCpGVMKe7AIaM1YwBQdkpBMdUV2QkE9w3Q5h1HgjxlSSL1KuE0zTdLskdEsTFwa2pXzznlF5erArek64yQ8HaRvnx5JbGew+0v/1JI9+bFV9LIvT8S98DA0ClcOhGXHoZt+OyuWgoSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> There's a large number of vm_get_page_prot(vma->vm_flags) invocations. Make
> life easier by introducing vma_get_page_prot() parameterised by the VMA.
> 
> This also makes converting vm_get_page_prot() to vma_flags_t easier.
> 
> Also update the userland VMA tests to reflect the change.
> 
> No functional change intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Jani Nikula <jani.nikula@intel.com> # for i915
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de> # for DRM
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD48C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF876B009E; Mon, 13 Jul 2026 22:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FF06B00A1; Mon, 13 Jul 2026 22:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37AB6B009E; Mon, 13 Jul 2026 22:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCBE6B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:25:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF3D5A0210
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:25:26 +0000 (UTC)
X-FDA: 84985790652.16.B66EECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17B15120005;
	Tue, 14 Jul 2026 02:25:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b48cJk93;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxhqIlF4Nmwz7Dc6V0zHplATkq8zPUSt2q/Zds9EZa8=;
	b=BehFXGxkg3pYMccwhrK0MphLW6oC2nlVSR5KrIb5pf9yt59Qz+62avUpT028WiVytzm5+D
	31NKWmkE/TpeepZCQO+F/KwIGk+QA5eWXTpt2kIIxpB9Nw9KZ/t6W4M+LXt3o+M3Hshly4
	jtAonIoTdZ2JA0N2WdiljTKjceonYhs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b48cJk93;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783995925;
	b=IsZ3ShWDFTtqBcbgLIpvJ5t/exVJEC6epVqBOHo2zJMxASOK+w+MLLwPpFstUZCbpCVQev
	a/Qn8x0iQy7aqIRD3oBQhAdptsVMUekR3f0hIDSieYcIcykYphi4myQbLapCHHLi3YLjON
	Abnl7pP7Xr1+eN2ZNsfLChzxbxbI5Ng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC9B660103;
	Tue, 14 Jul 2026 02:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DE31F000E9;
	Tue, 14 Jul 2026 02:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783995922;
	bh=dxhqIlF4Nmwz7Dc6V0zHplATkq8zPUSt2q/Zds9EZa8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b48cJk93FtKmn41eVdolAVE/uzQX6EHo01Pnkn0OgnY1vIvJtpHyTyl3C+S0onbuL
	 GGMGjmfE2JKefejiLP1J3PzT6MIi/Ch6j4XkBShkTRk15H8PEW9ZSYVvQQ/3WhTIGU
	 P9nMjGwkFSOLhnsQCjHUwc7HZ389d5X722tVvR6w=
Date: Mon, 13 Jul 2026 19:25:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>, Christian Gmeiner
 <christian.gmeiner@gmail.com>, Inki Dae <inki.dae@samsung.com>, Seung-Woo
 Kim <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Peter Griffin
 <peter.griffin@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, Jani
 Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Clark
 <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>,
 Abhinav Kumar <abhinav.kumar@linux.dev>, Jessica Zhang
 <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, Marijn Suijten
 <marijn.suijten@somainline.org>, Lyude Paul <lyude@redhat.com>, Danilo
 Krummrich <dakr@kernel.org>, Tomi Valkeinen
 <tomi.valkeinen@ideasonboard.com>, Sandy Huang <hjc@rock-chips.com>, Heiko
 =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>, Andy Yan
 <andy.yan@rock-chips.com>, Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter
 <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>, Gurchetan Singh
 <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, Zack Rusin
 <zack.rusin@broadcom.com>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Matthew Brost
 <matthew.brost@intel.com>, Thomas =?ISO-8859-1?Q?Hellstr=F6m?=
 <thomas.hellstrom@linux.intel.com>, Oleksandr Andrushchenko
 <oleksandr_andrushchenko@epam.com>, Helge Deller <deller@gmx.de>, Kees Cook
 <kees@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, Boris Brezillon <boris.brezillon@collabora.com>, Steven
 Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org,
 virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
 xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org,
 linux-sound@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 00/13] mm: convert more vm_flags_t users to
 vma_flags_t
Message-Id: <20260713192519.58113fa69c169d3f5f82e453@linux-foundation.org>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qkgxtgzrj44xjp5rhb84gox5qe9bod5a
X-Rspamd-Queue-Id: 17B15120005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783995923-389014
X-HE-Meta: U2FsdGVkX1+xV/m3fJJO/1Ov90/OX022awRO9nshYNd1YApmzNruZ6XRuVqj0AwHINRz+S4YdDezolpFI9V652PI/G2R9BI6BuZXVP2zVwGTEPTrXbvc80ILfASk6jKTUZ95tMZyvIOesX642C10Yn1GThNCqeX24MvlqXIRoDjp7irVd4KKIPAS8TU8cS7RhyrTquxc6NyVPLt+o84IQvK7uQmgBHfq/IKxvBlOAbay+NmvGZI+blJ23GJghJrs0cCu3d2tNxaCQe1XX0t/ZY0Xo8lASLoJwnioRG4JvSsVXuumpFHWOpSg0wl5UCdWjHFDnbCuUWAq2MS6NQEx7cg8lTIJDVWiO9vEKiqOdsqFqjKuSX4vm/hY1QX82DVq9qyRqkO67zvyE1gwmo/fN5eIGEIEFlVDTVjfVvPvKvwTu0K5qguHL6jwpknydleS1cz5KqujW52sdo3RVaGWYxkMIC4InMOz+0lOa9c7BtQQRmDZkHrxaVrSh4mtHaVkEj499Jxf2bnMc8BpU7DtIj7ZNA5DMFfNwDreFDf23WD9LzIPizjq52QR93/9+kpSqUJfURDonvdjcAR/h49067dGj4l0Y/6Io+tM7pKLEK4XnikxR71Us9WxsLR+jc2Z41fVssHNbODcmfzt3UE5irCz1Mnb2+Jl3WiVmDA45jUReI96G1dMtzWygrYqeq6o/KaYA+HkfxLBXVf6rk7gfNqiOETvmHFoTn16/tNo6d3BFn77XEB3dazY5STo5GIo4B0sSgI/JR8AWQYRoGyyx8+IwTp8fE7/NbBaTHq+yvp0N3fpOdRX5wEM7eFyeZWa97Jk0YlBwuQ+Lfup0Vb60rfMwN85chFL0rPo077/q1jj1AfA6mav8JtJ9V3sD6vY/99wnATwifSwz4vhTX0qJQehQYOmGoqh1JZnyemhe38VlizMECZcRGebdYfVzitUzC0pMczOeAjkkfC1bJs
 is8vLLvX
 ePnLwtu892AqJBiiWakcsKV+eMOzttSB1Zz7L4g6/bfQVo3WOzVmBIPTUA/mykAbyX8BbUmJ7XCqxYeDdhMvzgNA+stjQCszYqbLLDoQwZxW7UI8pMbMeucnqaoHnnQM8l/e1wISqsr/gWRbu1g+I+K/Rgy8epnUd3Hih8jTIOqURfvxm7nkRqz9fNC/pn7VDT7xtiXOfH3/06X+VuOxH2EQ0KLAjuhQTL9DlwGD5j7EJHHKbul4o/FMfMxH0s4Sq6UwA+jNZaP8oB5f7oePTLVjthVcM9lTy8qZju8NaKCKsPu1TzkMQE79iZM5D7yazEgZh8C1fXzYimYfyZJwKosYI77A9lmmpAl7KWnmxDDCcJQKwLNWUaUTjvJpTeSemYTpJ9w65pVdESlO7By9ytje7vBJgPfgfVjdAKwaKygrPrP9IVhUN7TER5rqBydx1m4PT7Atus2UK84qA13QsDjKRypOGchzq393BltUDYWlGOg23JeY3Pah1Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Jul 2026 19:44:57 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> This series makes further progress in converting usage of the deprecated
> vm_flags_t type to its replacement, vma_flags_t.
> 
> It focuses on mm, though updates some users of mm APIs also.
> 
> It updates:
> 
> * The core do_mmap() code path for VMA mapping.
> * Unmapped area logic.
> * The usage of mm->def_vma_flags.
> * VMA page protection bit logic.
> * General usage of VMA flags in core mm code, mlock, mprotect, mremap.

Added to mm-new, thanks.

And oh my, what a lot of pre-existing issues:
	https://sashiko.dev/#/patchset/20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org




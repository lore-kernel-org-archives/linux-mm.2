Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D334C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373336B017F; Thu,  2 Jul 2026 21:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B4C6B0181; Thu,  2 Jul 2026 21:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A6E6B0182; Thu,  2 Jul 2026 21:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E903B6B017F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A39571A017F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:40:41 +0000 (UTC)
X-FDA: 84944249082.16.95ABFED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7FC3618000A;
	Thu,  2 Jul 2026 15:40:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8vOAtQO;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006839;
	b=wX7B0sljttxEQRAaPZTY7Zx3T7CckeSvF4ms8yba2bbmS1pums04vu1+cI4DLH22rOhS+W
	yOmcjYZiviqnog96uf9Z1/olDNkOTAKYvk1+dqlxVuYDLclunVA0jkSk6cyCnHhU8c3L4T
	hXtNi2jxOpQLE1wuqnuibSZ7D7SSa2A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNLYS8EYE6bJ5KaXF7DR9fRu4urDF+a7laqqF8q0hcA=;
	b=k6S/h/NLVnHDJIWcuzrcJ2AtKhX4XG8sbfuv2a1fbgqrm383h2fATqaNEf1Mak/zvxCg1r
	pJTERNOtMLA0S8TEQ+TrZP6I4lHl+zkH4Wbl0L/4mp9rhlsXmiY62tqfZCp5j9MCfhDHXq
	lV+Bo6HRmDa7+5ED75EuV7pMRA4ZZwg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8vOAtQO;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7EA7601CA;
	Thu,  2 Jul 2026 15:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8E41F00A3E;
	Thu,  2 Jul 2026 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006838;
	bh=gNLYS8EYE6bJ5KaXF7DR9fRu4urDF+a7laqqF8q0hcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z8vOAtQOT+iGTiy4xQ3GfxWy9CpR6iieY1qxm1fyBJSvxEFV2aEwGeTLwIZE4UbYF
	 sH6QvDHKQJHBXcc/JYlecYNDNZBJEw63vn2taYjOLxg3iNlePJRLcm76SDX3qcqqpf
	 OAzUHT+NRGQHyZOOfos5EJuVfaKEWfkdr4crDOBp2KFX/hKeIetGWLc1I64/oz6RHQ
	 NC8RA6ivq/IEW4DV1d+3Z0k229cWnviqo6Svky+UHUgnyeaFy3m0xyIovRQ1UfVX8n
	 wqqP9ts5FpBy46j7HS+G+te0/D/3BLeS388iQo+wLiLJCSDRdl7jDwGFy3vdpkllGJ
	 NUUDfmqseIbQg==
Date: Thu, 2 Jul 2026 16:40:15 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com, 
	kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org, 
	jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
	tursulin@ursulin.net, robin.clark@oss.qualcomm.com, lumag@kernel.org, lyude@redhat.com, 
	dakr@kernel.org, tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, 
	heiko@sntech.de, andy.yan@rock-chips.com, thierry.reding@kernel.org, 
	mperttunen@nvidia.com, jonathanh@nvidia.com, kraxel@redhat.com, 
	dmitry.osipenko@collabora.com, zack.rusin@broadcom.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com, deller@gmx.de, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, hughd@google.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de, 
	kees@kernel.org, perex@perex.cz, tiwai@suse.com, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
	etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 08/13] mm: introduce vma_get_page_prot() and use it
Message-ID: <akaGOiLz-3Zx6kDs@lucifer>
References: <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
 <20260702123845.95316-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702123845.95316-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 7FC3618000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: guxnm11cfizp33bdqozw9y35qkkq78ad
X-HE-Tag: 1783006839-990519
X-HE-Meta: U2FsdGVkX1/eRAhMEvLTSPR3vMnkBrbZqudvKnqE6wdQw5WRoBZh1QwEWbKpl1xcFJJZCcrUnwyNoGZ+dAIfYtzBotQTWo4vpDJg8kOHERj52y0/TT+c5N4j9+cHBHztGUP7pQSoC6E4GJ9i+Ph249jjtCi0yPC+1QJwMAhRfjyxuKITYyXxEvRHwLDp6dY2M4Fhgpl6IDPUZYI8+6NSANkhzaxXUmImGj/1p42gqDBDO4NQAQJM5gk7EnOk3m27VVO923J0icDnt+rR6lj3Go7s065RhTUSIq5+4M6AE7DgZVoOOmQ/w5z2OwL11wzOsGpFkzp7nBMUoua9LB8SPl68aWnynmRkwJtgQ3Hrap/DtgSEhmramEHhm+4uuERReYRn4g+zfLWZJWLJCab2cWkvYkWyAiHM10tgBAyA0ve9dAZnxoHrJVWSsql2Cjb8+NAyV7+5HV+LZpEn82QylF4tfI/zJBh+XBRtf2zhItc28ELsI8U5kj9uaRR0ekJ3tpWPR7ZMFDt4XknDFlUugjhyAsxRTRlR5/lShC7OZN8aYJGkR5epltyG5N/CCUPYQV1gONhwp1kHdMu0gRFXq5qbp2M+YcZ8myGBhnfbeEqCDlrbcFzAKDTN0yk5VNNnq488cRnm8P5sWVxKZloddeifKx4B4cJD4AeQDAkPUXydkTe19hfrfviQcHoaaZZqVwPR6vlRfQj0CNU6V+OUbd7kBxqQYBrI4RtkPnj6mciLQv77Zutx7yeczJjENMuG9EuleShurny8VNDrGxajgBC7dycYIplHT43F1oeBqp7HG5++JX4oge9Ea4WdQXEZyxe9jLfPt/v/FbXs4d+dOFJMH2rHwj5jSdq0Z6cmVxt6Y3OzCu0Vjm7fpiMNUb03H+irZbmsHLvIF1fCGwwVAkAdbU2u4k2BPlK3C2QZwPWq5O8e19pc6xHvAth/5fpSWXDf0gMV+M0jyKmX+uS
 +snbHbm8
 /l4+F2jnDoW9LAER/t4VKEpqbip+z/jtVMsHeUIWKWGdX516oBw5YPZ+NUUSvtDlVuzF/5FuXoM0K27e11DOs/8ZZnQ9MWSFe3w+W+TZMeyOH8kia6FQKWBxPfBdRTUlk5k4ofrhEGUPpNi+dCfUsEv/5rzK290qdzElGtq1T0CGGaPdHX/uzmn/t7U/VJ1ZqvSPNALzYTA8aZLdWqrGR+If8bgN02sH0S0Npf71YEJJGyiTqdOdhOGoAtkPqb9sIesRA6OWuaJeyrg4MySj4b6YYD8bOK6ys6pGuyZvSjSDrzt4bl6R3l37uhleDQL97SEYY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 08:38:45PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:31PM +0100, Lorenzo Stoakes wrote:
> >There's a large number of vm_get_page_prot(vma->vm_flags) invocations. Make
> >life easier by introducing vma_get_page_prot() parameterised by the VMA.
> >
> >This also makes converting vm_get_page_prot() to vma_flags_t easier.
> >
> >Also update the userland VMA tests to reflect the change.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
> > drivers/gpu/drm/drm_gem.c                   |  2 +-
> > drivers/gpu/drm/drm_gem_dma_helper.c        |  2 +-
> > drivers/gpu/drm/drm_gem_shmem_helper.c      |  2 +-
> > drivers/gpu/drm/etnaviv/etnaviv_gem.c       |  2 +-
> > drivers/gpu/drm/exynos/exynos_drm_gem.c     |  6 +++---
> > drivers/gpu/drm/i915/gem/i915_gem_mman.c    | 12 ++++++------
> > drivers/gpu/drm/msm/msm_gem.c               |  2 +-
> > drivers/gpu/drm/nouveau/nouveau_gem.c       |  2 +-
> > drivers/gpu/drm/omapdrm/omap_fbdev.c        |  2 +-
> > drivers/gpu/drm/omapdrm/omap_gem.c          |  6 +++---
> > drivers/gpu/drm/rockchip/rockchip_drm_gem.c |  2 +-
> > drivers/gpu/drm/tegra/gem.c                 |  2 +-
> > drivers/gpu/drm/virtio/virtgpu_vram.c       |  2 +-
> > drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |  2 +-
> > drivers/gpu/drm/xe/xe_device.c              |  2 +-
> > drivers/gpu/drm/xe/xe_mmio_gem.c            |  2 +-
> > drivers/gpu/drm/xen/xen_drm_front_gem.c     |  2 +-
> > drivers/video/fbdev/core/fb_io_fops.c       |  2 +-
>
> One missed?
>
> drivers/gpu/drm/panthor/panthor_gem.c still has:
>
> 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>
> Can use vma_get_page_prot(vma) too.

Oops! Will respin and update. Good spot!

>
> [...]

Thanks, Lorenzo


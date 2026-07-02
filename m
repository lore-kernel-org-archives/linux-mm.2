Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC11C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE2B6B0146; Thu,  2 Jul 2026 20:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4E06B0149; Thu,  2 Jul 2026 20:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4D46B014A; Thu,  2 Jul 2026 20:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54CE6B0146
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B959C8BA93
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:31:50 +0000 (UTC)
X-FDA: 84944377980.14.C442322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 836F440012;
	Thu,  2 Jul 2026 16:31:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTJm75v6;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009909;
	b=XkKPXn8zs2742zPGE4A4taMnk/wg7oTzkz/2qpWSMBfvLgkGh/AKJgdnrnRZeDVd6AL4J4
	YpHZa/41dBK/T3DjN7dxhqLM2BTN8WkPu6a4be9u73MPLP/vs8T3eWGZ4aD9zci2BuKnNc
	m2Lc8e7k0k98XFS4xX1CbXQ7LqWISZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1qWf++P4fQTxTfdt1w7bxV4tlwl6MwcbrDidejiQ/c=;
	b=UCeUkLtvlIEoR3MmDxo6sAJtspfgft2v0ZMnecd6fwmDG1qL4LwewX4ft4jSAOWkFoR2uG
	XA0YjcqmbOeRS09pqCLk2wJgAEpivrRtSMSaye5dnYHlo75ts+1WjdCtouWmbOOF16ZMSx
	Mo4u75gfQDNJEUZKhIkE//j0kPLIgOk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTJm75v6;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EC6943A8D;
	Thu,  2 Jul 2026 16:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5261F00A3A;
	Thu,  2 Jul 2026 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009907;
	bh=E1qWf++P4fQTxTfdt1w7bxV4tlwl6MwcbrDidejiQ/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTJm75v6g78dw7nc2yIjeNrtd/XXU46WO/2u8nnziEKlJYchAWQ9hGEChgT4F31ah
	 HiH5xTUbuFOhBbd6C1duQ+RhK7b4oHictxqHPOAi/lrzXWZ0FTN2EDGOuyFEWt0mD1
	 vjw0IUs1vrHYSMCjr+3zzHxShdi1SoTmUIrBx0H0nw1oUHkfV6THw+nOZBnbM1ksv+
	 +IgzClZgoCati852KoF+eqgYzFxCjgh+OL3JRZibavJHQwCUYoiGfhSnInQcjeQExX
	 M1Tr3eyxRp2MXQhzrXdgxW+NoNc9BMVcJx67MLhqeaR6Vs6Z2WBP6mhtT0mJnysYek
	 vPOd4U2WlHy2g==
Date: Thu, 2 Jul 2026 17:31:24 +0100
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
Subject: Re: [PATCH 13/13] mm/mremap: convert mremap code to use vma_flags_t
Message-ID: <akaSQypCQLeW9qfK@lucifer>
References: <380f761d35a3faa4370f8b3f92e3d4af3d4c7110.1782760670.git.ljs@kernel.org>
 <20260702134947.25189-1-lance.yang@linux.dev>
 <akaJx8Zt8kazlrjq@lucifer>
 <2f36a2da-0686-485f-b4b9-ae699bef4fd4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f36a2da-0686-485f-b4b9-ae699bef4fd4@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 836F440012
X-Rspam-User: 
X-Stat-Signature: gpqidipiges87zx7gkakcq887e3m3je7
X-HE-Tag: 1783009908-818052
X-HE-Meta: U2FsdGVkX1/pWx3t4BpVZLYh/+IFZYpb4NvzHI40pdu9ZuLlf94QmAvxjMsZ2PxavBZi5N46195JQEToPu9Dj3/IFDsziyvHm+VqEx9KkNIb42l3zfPqu1Rju7oAo4k/FxSUKGl3dcEVnrFqV/y64fzNdjdbaBriyORuBe2IxDMDByEsU33dqveItgpjCTKqTakaoKqSWZR9cubWTw7Ud89yhhARq3WWB79DlxrAHOoLP4/tyOT2YtO0rhzIWPrTXJLPpQBikSkzH8iTzIoyJpPCXTEnjDMcdmOivitSMa9NSosJ84pg6SkbgTL2fadPJUFlAdVoXXJq9X1P33qK5xI6YHd1QqRJiG63nyxawYQzquCrYSwsPuzeJa++XWVIPqqKq0KiJ+mJRX4gSpvKMhd+SabhVOpYHuzsy5t3LgeKhk/joBkCEeNqzSdOlBfbHQ2lrzNhMry5VFNEcoH0MYgG5dXSrerSH8RwFVT+1aJYFTn8CPLrz4v6hfRQDIiClUz0OdlppSFSk1oKT3zgzSuXox4wpOINtD0kMXVLV1UAhXNGTkDw8SnHNFCYZ1boryAaTzrWwKhD163qFRO1bIe4hcUSEBTRqdVJlrAiatxrFbR/qLB5r/jJSObv+iHyop9SyprL885h4hj5fuIvSyRR+86YkGFW5ts65ZtG4qA1S+oxMx+PVvJDIFbi8mXMldSm46KKK6+0wA4iqUz1pP9zS9/x0yanxz6ACXMIURuJzJx19LawTtgxKNTM7FkVqPn06WL0nYnUhXNQHL5iQgRwZBluoG3zhvtWJNe095zPYbb8ei9EdLifd7bWc0NtNHmqOEG8VoFsatEVH+2Mp5rCEnO8hLGo/npwXuqTvrEcXWfaMZPu2s9BF2a5yOiIl6PVEzzZWAdnAcBptr68Fna4QjKOK7Xl9XJ4u91NWjRkTtwDpBwO5yxT0RXVzpR4ww2hFLYeKrbNjKRdMl9
 TAYkOaiR
 SMkvtQs0j0M/s2bMz7s/UZaobgRQ5V0O2tG55LZymwBnOJ2cCyadPUg1K+O9CcNHzsTo7K4eiv/e9lzIVyhBRkWUmk/dCsykKM/mmJ4kpzDZhqdk1ZXgHes8VTNOpUdIR3l79VWRIW0ci16nVeYZq1aN7xLnkaEAbCHZSeMgwbos8Nkx2dBM1kSxmnYWIcuMql+FKO40ggr+PWv8KnQyexycYFQdmzUENezbnS9on96UxpTa4evIJ05vRbcjHG7UzKCsZoV4Jyi4MRrVR63QDTE4S0CaP2sgAtrcsg7cPP+pL2u2Tqp0h+F8akqY5ErzOwate
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 12:17:29AM +0800, Lance Yang wrote:
>
>
> On 2026/7/3 00:07, Lorenzo Stoakes wrote:
> > On Thu, Jul 02, 2026 at 09:49:47PM +0800, Lance Yang wrote:
> > >
> > > On Mon, Jun 29, 2026 at 08:25:36PM +0100, Lorenzo Stoakes wrote:
> > > > Replace use of the legacy vm_flags_t flags with vma_flags_t values
> > > > throughout the mremap logic.
> > > >
> > > > Additionally update comments to reflect the changes to be consistent.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > > > ---
> > >
> > > The vm_flags_set() cases below spell out vma_start_write(), but the
> > > vm_flags_clear() cases don't?
> >
> > Yep as I said elsewhere, implicitly taking the lock is terrible and me doing
> > this is completely on purpose to get rid of that :)
> >
> > But I haven't been clear enough clearly, so I should put the argument as to why
> > that's ok in the commit message.
> >
> > Will do so on respin.
>
> Makes sense, thanks for spelling it out! A short changelog note
> should clear it up for me :D

Yeah absolutely, that's necessary and was an oversight on my part, will correct!

Thanks for your great review here, much appreciated! :)

>
> [...]

Cheers, Lorenzo


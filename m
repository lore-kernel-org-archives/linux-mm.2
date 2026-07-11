Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136C1C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 16:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A832F6B008C; Sat, 11 Jul 2026 12:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59FC6B0092; Sat, 11 Jul 2026 12:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9965C6B0095; Sat, 11 Jul 2026 12:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDA76B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:52:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCC53120742
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 16:52:53 +0000 (UTC)
X-FDA: 84977090226.13.1FAC851
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB8CA100002;
	Sat, 11 Jul 2026 16:52:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD5EgXpQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783788772;
	b=FKD+fO8xx8p5jYpDL/FY18nGc6CksXZmbfGvl8AYLm6sY4eMRXU9xvtoObKmEP4XZwQdnw
	hCF8YjcTfi+xxuueuDB7JqmzmigT4Wh+NbJ18RDI0h3Cvs3HoeegAvrvP9IlbXMmrUPEQ0
	JHILoZZaiTFbKgS5lVWTQ3aFszmnzy0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD5EgXpQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783788772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+Xf1bMSkXIMJTYDDjXYIpGx0jZ6tuDdRsUChLmc1jA=;
	b=YYHAj8yP/mWNyS7FWTwNtOKw09nXnzs6yCzv6dWqCwwrqxR+OLiPz0Tw4romQWMJVfyeyC
	VaSzUvAqJJKR87qU7mNBXhsQtv5r3IXM30G5Af+VsZ2wYUo4XCOeP4GF8TxhlJ8yafHJvZ
	cLBM8o3wF/bYkOd+qyVs5us4igyvHEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2F3560052;
	Sat, 11 Jul 2026 16:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36CE1F000E9;
	Sat, 11 Jul 2026 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783788770;
	bh=5+Xf1bMSkXIMJTYDDjXYIpGx0jZ6tuDdRsUChLmc1jA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GD5EgXpQxjlS4BgytXhuu0DKNfOXI95UIBmT8u8vTWLN8KV7KhFG3Zmjlk9IZStJ0
	 KR/rJOljXFdanDu2Ju/DptezzsTHKy80EcuHZM39Fei1b18GfZiY34ebY3hxctopz9
	 gvnFSjPShteSKooY0iw+x0xgR3Cf925KQiGVWg1A4rsZHwFxfm3bgQE5xX0JwdPBlB
	 +Tg/A3vkLuFYGTa7kkL8I1wMAy+xlY3+uuAHgvr+ArjH3xFFNogvxDp8/tF7Nnmmoy
	 dKpnRq6aW4iMGj9i3sLe5ohAdOH0LwKPvhoh09eZddiNuSwIe2yzxsxY57f7rVk8Lk
	 0S/jqug0BXp3A==
Date: Sat, 11 Jul 2026 17:52:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Lucas Stach <l.stach@pengutronix.de>, Inki Dae <inki.dae@samsung.com>, 
	Seung-Woo Kim <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Peter Griffin <peter.griffin@linaro.org>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Sandy Huang <hjc@rock-chips.com>, 
	Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>, Andy Yan <andy.yan@rock-chips.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, Zack Rusin <zack.rusin@broadcom.com>, 
	Matthew Brost <matthew.brost@intel.com>, Thomas Hellstrom <thomas.hellstrom@linux.intel.com>, 
	Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kees Cook <kees@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, 
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
	linux-fbdev@vger.kernel.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 11/13] mm/mlock: convert mlock code to use vma_flags_t
Message-ID: <alJ0K9JlFBP7KC2u@lucifer>
References: <cover.1782760670.git.ljs@kernel.org>
 <2db16db81538355ca65f778c246d2381c673cad4.1782760670.git.ljs@kernel.org>
 <DJTO4SXFAKEV.1GVVCX3LZ6R0M@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJTO4SXFAKEV.1GVVCX3LZ6R0M@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB8CA100002
X-Stat-Signature: tj7p8b8bago4spwtz6zjyjjnq3ry5p7k
X-HE-Tag: 1783788771-245498
X-HE-Meta: U2FsdGVkX18EYRkRFiiUqJOUGZjvHFFCvMTNpT0Ws4ZTZnP138EF7I1oBcYyBRdg9U0p9nRibJKLCIf22fP7MyWU+PovW1v0BcSvCiYAL1wr0SRewK2YjCZwYmaqj5FU66HeRULEWn7BDUAqWqZtFKdOXraYJrmkt1xG7fcFe2Z0+Qhf5BQWfMcYG9GyX9dZ1DN0IwPoIqwb+8gvw0FOadxSUtvl+WvfA8hetbQgvynTf+bwkkMdKCHGhIuPb2hX3YZel5dxTX1AFvnOKEN0qszBJabbdI9SAYs1oOJx6cmOXqrvZQndyVBFgX8ATZxwEie9bm6lIZ/5u8q3n4N6PGl0tqMuMOXQ3cu5jypYIWzYiiuaJPrhdoGhfXK4Rai96P58sguMOUCcOQjAFVCcOgIv68ASruG+Qsb3/DS+nUJrbpsHD9cYcXxO96jcSD5iMlYlplZkORCi8M3Lh2f+7jV9YlaZPv/PjjwUm+GIyNErW2awCTrXEgEY3YzABhgi+NGJw8w1X/IbLOYEmmG4EJuXZDGCFfDKgTclR1+Rx5Wi608RGSOr4o70o6SL+6eAO7Ji9IdKnFtcKntJeUUrSsq3fi2KRy/Hc3nDx4bUH8XoOJZunetNP0kFq3ck0treJaVlxuOALrKLfxRjm/lbdXil9EivoDBEE4CsRvv47Gi5VtO4PvSERwIOnqNatYCX2MkcVtvmoe5OiJJV7Ivi8ISrE/AUzH9Qizl3LKIz01H9D2jo0id/LkSlHmKQGXVrJZmAUipHTkvxAag0oA5gtvneNYrI/VrfuZw18GRRE7PW/TK2YW1Qn8eOHfiERLZgD+fOjQfKHcjQJDmeWXXcImJiPn11zTuEu5zEj2Am5KfFwa66zHnyRjqQm4KQsYuVg2C8qTjCT4OU98LB+i+8t8epy/0d+4xPfglkCBa9iLJ0yzFfbVDzCH+z88HFgptvYgaQ4CvrfxIY8i4tfNr
 jaGAwuAi
 fTqva0FRTCaN5gzKA2z1EUbBQmphOqNcv/1kJupWwbVKSxTlKWZqCJrY0hWbWswPYVmG5OKn17hvAi3+L6iwh+rTLXdjFFcKTfcqLot1s5QAGl495aRuwrvkBFD2IaBgIHi43yW6KjJ01W8CqD9qpAXLieNXf4d5sJTwgFlL8I+jZLD0abncG1XBkHZMM0p8dwXtbbPyHPxZYQ9fH6wmcSiRpp/B+Nb2fwyfz1hP0Y+SXfoa3sB8q/j++j3JbKcuF24Mkn5IyzSs62FVGql3fKB5D+esq7FiG8HYKWmIpR3Dq1+kftWljSPyRv25d8YDRUMk772onzysGhpou8vznX2zEHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:01:22PM -0400, Zi Yan wrote:
> On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> > Replace use of the legacy vm_flags_t flags with vma_flags_t values
> > throughout the mlock logic.
> >
> > Additionally update comments to reflect the changes to be consistent.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/mlock.c | 86 +++++++++++++++++++++++++++++-------------------------
> >  1 file changed, 46 insertions(+), 40 deletions(-)
> >
>
> LGTM. What confused me when I was reading the code is VMA_LOCKED_MASK
> and VMA_LOCKED_BIT, since both share the same prefix VMA_LOCKED. Before
> looking at the definition of VMA_LOCKED_MASK, I was wondering when to
> use _BIT or _MASK. But it is just a naming thing.

Yeah, indeed, not great naming there. Was a pre-existing though, and previously
was VM_LOCKED_MASK (also not great :)

The whole VMA_LOCKED_BIT and VMA_LOCK_ON_FAULT_BIT thing is a bit weird anyway,
since you set both and then just use the latter to know not to fault in in
GUP... anyway, can revisit that one later...! :)

>
> Anyway,
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo


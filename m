Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12352C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CEB6B00B5; Tue, 30 Jun 2026 11:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20176B00B6; Tue, 30 Jun 2026 11:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10576B00B7; Tue, 30 Jun 2026 11:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA27C6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:59:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 102F84055D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:59:52 +0000 (UTC)
X-FDA: 84937039824.04.BCD86AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71F3C20010
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:59:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ci9AAqdO;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835190;
	b=oY4Gh/d83Ebz0XBPcvXR/+wvHAVMr0GiDNlhMLL4ssDBCoy46y9RsxPzrfDBA/ZH33gmT4
	dYJ4PI4/URpI/lSBVPscjwzh8uDMaKFj/ffO46fh0nE6v4+AWzhwE8atzGxRfyGUpKipWp
	5++Jtm+29NyW578yjb9bg81iUyrOolM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djpiGDB5pDyZxxVDzk8Ai71BtRGChWWd/YRJODi7goY=;
	b=LAIxOACacU7bpAYemwW/YRwNCje3Rh9ix6VzcjwcnPRsLSh6wzb3pVIrAnmVtLKKXWswoK
	A6mnZEC0rCcBXbFeutLlmnjwtm6R8uEi65tmGuwOU+ps4VhiSqAZaWKh3fSCjp8sEebcGk
	hWIIjLg8qv3l5hYD/simrAeuDWLhz9s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ci9AAqdO;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D778D60018;
	Tue, 30 Jun 2026 15:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B121F000E9;
	Tue, 30 Jun 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782835189;
	bh=djpiGDB5pDyZxxVDzk8Ai71BtRGChWWd/YRJODi7goY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ci9AAqdOLAohpCehoyGUTmmcFqfPa2oLGOqbZA9HwlKfiaK/2p+dH9vORoffpCm86
	 q8leL4Dlsp1qy9Yr94qQi7IzIRGWwUp03Ox/TCewfjXjcvq8BGq/g74kymFs9rHjA5
	 MrW1vu5+Lfkqui3LnQKB/7BAsBT57d2t8ggydNB9+a5PQ570qdOVWQBGkR3rpMUr1z
	 JR1FOW8X2W4fY5MIuIHaayJTXpVa54bwLi465HUMNq3LdKWZJ3bAmB/5zZjweWZmk3
	 TM+KPanljb5plGckEArrF2iME4cvjeiarlcd3PZEyevECQ2zF5DwH5Jlh1E+7SjwTb
	 ITPrvbrgepgTg==
Date: Tue, 30 Jun 2026 16:59:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPnjlGP9EDhrIrw@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
 <akPlUrNWzl1ZPw1S@lucifer>
 <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 938hnrnb3rmctarocpwr379ij4siyb1o
X-Rspam-User: 
X-Rspamd-Queue-Id: 71F3C20010
X-Rspamd-Server: rspam02
X-HE-Tag: 1782835190-16462
X-HE-Meta: U2FsdGVkX1/o/YQXXY6iRp2gOcOsu8t+dXO/7yvmrnIY+VZ9Evuv6/aA5RLn1U295jEsKQlYsHGq2e2zXKO/N5n8fNpGWt1c6wbxCMSKV7U7mNClhBaUu4zFvGmY82J7Giz8j0VpGm58kezB9noqLIRWDUNIbjGLa6ayJ9Ehw83gQUcPfQDNVPqMc3PyflKIEGSZ6v0z+bcjydF2lYyOQMMYS5ljXXlMnQIwGEApnMZyQT5Vy0VNeCVf5Te+eSl55VJh3ih9eTFrvvRmV9Cm2jmPR8ZOXcrYcZ7F6FrJONvqFCs41imf2X51Esxd5CIZI2VNk4fFc/Wvs8B80N9PuUeTV8X67LQ6A9gdpPnqLeOkfLO+F5D1rilNZ4OByWIMcoCBy5bnIAP/oYW0/HeP3rXSfBb5PgcXlzv4TUnSBNsBdJC20AjqOrWDdIWXi60avZKWmRFcrtb2sVnZ0uZ8fvX8RXhtdboNBHkNnraiXCgAIE71gIybq9RkxLkzaZEUJjsQmZhz3VkANLUvKDGCfduR6k/JIVmKRIZ1ZMjaTFnmKhWM7ZRr1Q5fFIJur76Q739DcpUGHV+8XjqFxD07hs1dGFWckzGBPKBJRdMireZ809Wc6DiZ22hVClyHJHTZ8789s6evCKzNsjxIeHSoc7Yj6KDxgpmxZw/qo2wpByi35ulbOhHdGO9DWYJA+0NTfhI6bmcDhG/tJTazki25KoU+llqHhBIS6kOg/ZTv1an2V4zx4VBl8SvpugxYoMcAsdShMvrUdFkLxM7So1UONCmyM0b6Ht/5F5oBP40X5YicdASJfxcNBj8J4+3FdB7LuzIkeTsJpLA4CfvFBmOZWpX7rzIcmRScnqqrczUU4PNHCkAvSsMoROaNjiveEYVruP0RYpJ69ecrEcfppkLS9/CB9NNC/GbF2BAV5HfE732SkkRka0hc4cF5da+pOTHhOuaJJV37z4dxi42EKqL
 AafJu433
 4uaOK5yx6ZyaG8aLDSXIBTpiAGcXInkOzgXk8O5TUihcnaU7AeUkGSCUR7azpQPIx5ZzshC6LsDL9chRhVip6aD1aUHD0qt0FWmhO6U96WpIl1+fdlNVS4+jCnOsSEoqlcWbMJToDjt3+4CatklqXGNkmTI2LK9xUJpi4xIizBt+nSTuRe3Vtj4FrdUr6MkVmId50oc5eYlVwN8JqxlE0U4HoRuzPCqqRgdwUIIIbOd/YdpvoPCH6PIASOor3OLmAAKNzgIt7qtO87gZnKe3j3UmtdekYPdzkhToVrjC0huCAbNMNHmHSJYjNXy2P3SFDsOCwaPOQtfBiNOMVr7gaDFrMIHgbwkd2wkU3frcTp32iYCjS4U+5c6T6sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 11:55:12AM -0400, Gregory Price wrote:
> On Tue, Jun 30, 2026 at 04:49:45PM +0100, Lorenzo Stoakes wrote:
> > On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> > > On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > > > Similar to what we did with mapping_interval_tree*(), let's declare
> > > > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> > > >
> > > > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > > > anon_vma and the functions can figure this out themselves.
> > > >
> > > > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > > > to 'pgoff_last' to make clear what is being passed.
> > > >
> > >
> > > would it be possible to split the pure rename changes out from the
> > > changed function declarations?  It's hard to pick out this as something
> > > that needs to be looked at as more than just a %s/x/y/
> >
> > Hmmm do I have to? :P
>
> I mean, no :]
>
> > I mean sure I can on a respin potentially, but it is a
> > pretty trivial change? Just mechnically as above.
> >
>
> And yeah certainly not worth a respin.  Just learning some of the
> friction points of reviewing as I spend a little more time doing it
> every day.

Oh in the end you will be driven absolutely insane, David and I are already
there and soon you will join us! :) <- nervous smiley

But yeah, sorry if that made it harder to track what I'm doing here! Usually I
really try to split up to make each patch as easy as possibel to review, but
this one I thought 'why not at the same time' :P

>
> ~Gregory

Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2F5C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF89E6B00AF; Wed,  1 Jul 2026 05:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8806B00B0; Wed,  1 Jul 2026 05:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973706B00B1; Wed,  1 Jul 2026 05:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 689F26B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:43:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA5C34023B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:43:06 +0000 (UTC)
X-FDA: 84939719172.05.355DB7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39A60140003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:43:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMvirreP;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898985;
	b=FsqdGqgfCcshUKjAkNZOGIDWYZkxTLzh1fm5+WeQ3Psd1p9gWYmt9wiHqNYFWOeNp9HLmO
	TDAzuXlhEkqNq6nLPOTDbcdDobsN6baEQaB/KlwaDdOX3fnBubivDJSzvqmqVYCAQ8DKOR
	FLITWnPrDmJI3d+QSJbmLKRyYzZ5W0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yD2RrJDZdDL6RXjT+lWLw24YuDCa/4sSWtW/fyWFcdQ=;
	b=OwzgxGu7kRyGKE5RXH0ZYGgqas19FT8/YCFBWwfjLNmUPqW5gYAMDSin4yTKy0Dh6zdd7S
	bxMbuH51/VdgSjTaGCK7pUnCYv0QZCQi/ojV6OrHnhl3ziRhPY89Wy2o5vAMFtlfC6QD0e
	axFM3FsAzk4lqIN7sb6wjPLgw0Mw4P4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMvirreP;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 889EE418C7;
	Wed,  1 Jul 2026 09:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C261F000E9;
	Wed,  1 Jul 2026 09:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898984;
	bh=yD2RrJDZdDL6RXjT+lWLw24YuDCa/4sSWtW/fyWFcdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NMvirreP+CX8s1HLyn6zgBtUDz2oDbR9gIrXRS6YaNTcLZcnF2rsBWbQVm+Jl25Sr
	 A8lJ4z61L/giXcR/ptNpe3o3puYpqxx0hsQHO+85EjYqDjCEIO/1lP13eBb0n33jbM
	 UqdM041iHE/nTaNAA42LQ7VXM81xgA3Bi0FchvCuGazRU+YOdfKqe2mJyLfx4J0AJ1
	 B3RyYF4D778BuLdBJm0jXf0mSpjvs1QuEQapPlpQ8TZMICq6soqt5v87zbEEbs2TAJ
	 FdEluByUsfWooss92oIM/tmJ0RAV1NPZbvuLQEU3DJQZvF/ZXYqF3+AFDc5BkN379N
	 fKMeFEDS7Kh+w==
Date: Wed, 1 Jul 2026 10:42:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
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
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Message-ID: <akTfDTjDnnZ-8zwE@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
 <akPqIfmQLOs4gI7h@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPqIfmQLOs4gI7h@pedro-suse.lan>
X-Rspam-User: 
X-Stat-Signature: 97d3orrbqz51zj3nur7hrggfy7997tk6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 39A60140003
X-HE-Tag: 1782898985-591674
X-HE-Meta: U2FsdGVkX1/ZsrYGSE0mITfZmjbacxZveUdMSjjyhvvdmdu1LI2ejEa/pbqqJE2S5B3LFIYG7aJevq9EfZzip7E0d3XdFmXUexpZewkGSmfmellpNZJJsZ/hWAd+bj+h1bDB3ATAWxftzVHvTX2qDtBwVSreans3WfkzUEz/uDHEszanYUpV4V4tc3YkB8L4c0+SfjPCYEAkYBFfk9kSOtjZsafsT61t3TRTuVTXcUhZZW68hqrfRMRkg+cC9tCq5htehNa/E6RHhCvdTlPyF6NbS1gUaFLn3aVbA6cpyCHehxGRA2uWcdLnNcE7jbe80WEHp9AzM+/4iCyjgeo9LuCgcjkfeRY/NEFO6pXcKHfVzavWrhhWXCZtMgE5hB2INxn4+0KjitTUk7rNFVpsFMAW5aw/6uvFOyciYhymO7PQZsY1db2DguTdIW3rt9nuf+Q2j92A+lpgsZr+8x7lOtW0Q39ltYPd/8Vmgfibpby3dt4IqHDRzJfpkgCFTeEzjcAT0L9dHY+qz9k5bu7rBk2wJsIf4ogPRLtLOyhyZqyDzA1OwdnrdR/QTGRtxJeAO/Cyb7iRfugW3dFGKdGS5hfADvHsnCUBe4rHaNgw3NK7ycnEm/UhvpeAMKLcuuu9Nkai8zCF76oXzg/zEc6rVDHDTEjWTJIl8/Mg/pyiCobJmGy9VaPqKXLxtIwzmNcuHeP8JUtrThO/7Hk3Q5WphipsygI1bvdCM0Jkcnoz1KBMnHNBiN8UMO0gBzFln1Z3HCArRF7nvOIiVTiaN4OgPE3CNiSFAhehhnVpZskJrdn/K8qtuI69Y0qT6ye510/X2g7gqabugGfWNp2pSw6r0m3YEuhTzk6JQdmEPUnomv2WSz11GWscXhmEXMfPTiBbLX2LsX7WvksVwogXRcCdDECbrzSfeSoOQql766jxTf+gUUkU1SxibNlr0kf9O8CIXji8ShdMx7dhrL6Prxr
 KWhbHBE9
 1F4k1PZBh9pi/5nF8571//j6IoMA6OT+4WdRWEihcYqKedCNLSBmDqbRFMNBvLn8Xgyz/CAy320PzgEdMXoVIwOv1JNRouJiZYswXh1SZhLk6xhwwshOYQETbFVoJKouEk36M4HOIXlt9gEdmtKPMeDlivrako2OnalO98pMEDfOPYlVtd++wQyULEEVpjzi4jg1AFlIi7I78KBs5JLPKyfkqA1jhiqi3siJhjiQdTsaMCd/X1F9b4L97M1cDRSTJqcD+u1s7TJ3MOV9YAFVRyX71KQvhZ6nOBIwn/kgrg22HMoFdPNAxPsSDyKjIbpLV352sxfplqDrYgW/16lvdFeHVHXwFM4tZ1biToa4LByhoS36SIYth9DObMEWeYi/0+KMCPtaGBs8B6qjrxH6+en5+Uw+t+jz2bAZOexEv8uTWepEiudVhdqdpVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:10:55PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:12PM +0100, Lorenzo Stoakes wrote:
> > vma_last_pgoff() already lives there, so it's a bit odd to keep
> > vma_start_pgoff() in mm/interval_tree.c. Move them together.
>
> Hmm, a part of me wonders if this is the part where we should start cleaning
> up mm.h into vma.h or something. Probably not, it would be extra churn right
> now.

Yeah the issue is there's some confusion about vma.h - mm.h should be for
stuff that is used outside of mm, and these helpers are definitely like
that.

vma.h is purely for internal mm vma stuff, and most people should be accessing
that via internal.h (I address that in patch 27).

I do wonder if that could be done more nicely but punt that to another time.

But also probably worth doing a pass over some of the defines, I have a
bunch of series chur^W changing stuff lately so can do a follow up on that
maybe.

>
> >
> > These each return unsigned long, which pgoff_t is typedef'd to. Make this
> > consistent and have these functions return pgoff_t instead.
> >
> > Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> > we wrap the vma->vm_pgoff access, we may as well use it here.
> >
> > Also while we're here, const-ify the VMA and cleanup a bit.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> > ---
> >  include/linux/mm.h | 9 +++++++--
> >  mm/interval_tree.c | 5 -----
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..059144435729 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4278,9 +4278,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> >  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> >  }
> >
> > -static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> > +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
> >  {
> > -	return vma->vm_pgoff + vma_pages(vma) - 1;
> > +	return vma->vm_pgoff;
> > +}
> > +
> > +static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> > +{
> > +	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
> >  }
> >
> >  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> > diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> > index 32bcfbfcf15f..344d1f5946c7 100644
> > --- a/mm/interval_tree.c
> > +++ b/mm/interval_tree.c
> > @@ -10,11 +10,6 @@
> >  #include <linux/rmap.h>
> >  #include <linux/interval_tree_generic.h>
> >
> > -static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
> > -{
> > -	return v->vm_pgoff;
> > -}
> > -
> >  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
> >  		     unsigned long, shared.rb_subtree_last,
> >  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> > --
> > 2.54.0
> >
>
> --
> Pedro

Cheers, Lorenzo


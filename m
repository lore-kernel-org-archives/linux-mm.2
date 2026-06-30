Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBEFC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1016C6B00EA; Tue, 30 Jun 2026 11:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2216B0118; Tue, 30 Jun 2026 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5446B0119; Tue, 30 Jun 2026 11:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8D896B00EA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:50:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43BA21C7066
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:50:10 +0000 (UTC)
X-FDA: 84937015380.05.8E4D1B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF98918000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:50:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxSdKdn5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782834608;
	b=CS2PjSbMIpH/E8vSaSj9ZIMIBSi4U+a3bwJEQjw209yFqCjmk4hVoxkv8WJF7kX4jlacrE
	zwZ+k/rgMGk8SCA7JEkOk/Wsg3CY5eC8gOF5otsakozaFCJIpnttyIWOtddW9cMExAuOpD
	5jMB1vr1O/AZ0lkOirXjwhxKAtE8uEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782834608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miS3eC+cFOKuQvparEB9vcuI1B25HnurX/vUMM3/hkk=;
	b=JRlUAA5yyPBr9i50uk7ocniJQH4or5QCnsBLtdq7+Y0hj69OXQHWPzIiaH33dk71twoSEB
	ECcd2LhhcMKOm6fEABVTjA6my4LKUWs0x916V3OPcBK0lZOVATfYgpGsZ/axY2ss2DYO7Z
	HXVDNNNkyAt8pgDhFjlJAz8NsWYNS9o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxSdKdn5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDC3660018;
	Tue, 30 Jun 2026 15:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0901F000E9;
	Tue, 30 Jun 2026 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782834607;
	bh=miS3eC+cFOKuQvparEB9vcuI1B25HnurX/vUMM3/hkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hxSdKdn5tYWxzQMiSUZWtXeXixz28n8frcvHVVdAhflb0/y6u10yg1vqQp7dOLC/s
	 mkeAwgMLSjMZ1Gzx9I8Mby4w95CO8nSoPAPdQC2YjgnJWXbQa2Tj21eAsgsTQentQM
	 Mr6XemUKwyK+8KVvXA0JS/C9LKF0Sj7JGqJXDPvByor5pxopRci3aGfdPqf+sJ0XGL
	 rs380OMcwCwjE2LAtsEp30AZ4eX+KEAL/mQEVmPqt3GCfEUWYAZjglbKpir8HNgBUC
	 +gJ9lgc97IlCfR33+GgtUkBX0Ami8XQs3TNIWsr6vl/cNBIcISNLkD1Ly4+lJR3OMg
	 N6odwJyxTP+ug==
Date: Tue, 30 Jun 2026 16:49:45 +0100
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
Message-ID: <akPlUrNWzl1ZPw1S@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF98918000D
X-Rspam-User: 
X-Stat-Signature: w8xb3s4hu47sxybbkq5wmxz54383f63r
X-HE-Tag: 1782834608-259788
X-HE-Meta: U2FsdGVkX1+fSLQ9eGnbMWOuXeCsmKbB0vFoGNnbUjDuSbyZI6YoSCnmbSKVCcpfPnrbgXC7GnqnnjGVnRIDX8huqYMTA/Pd/9u+FbFEesTLGia9va+Axf3WeEchy4Ol9PdBjzPsTiLgSVAzmxSE53mtbygnGW/sHbLgjrOkdyMdkzCadgFCns5+BsaE75+P0W5pvHpYxl+qyq78pYsE4mG76VbgSHWh+l3EZK3JjqTJ7Cz7g9frQsxA+71Orok/br2E9EZi1dhCLNPQ4KKcr1Dj2QmO+zlhTISxZSZKuxNDxj006X1ZAUgzjEVVdKgrWz9AX2YGf90lNus1lw3HJ5JsdMW5TRTVwpEywRF0MnEkyMdHQ2GAgVHB8pVwyylIj1g3WjxwyDrdPJ8RBvX/UpeyG3cj0qVuf+U62P4IJYwhnYIvnXqYxigrnhVC6GDcRw8snUsRT+7PX5v44cGCkUGfgNdaFZCWFx9+fRldJbeMkbIGRG6LrTB6wn3D+C30pIBqJ0n7ub2wKLQjsVeemOx+ewhr7Uw7B/fM5JrDQooUYXn6XiGSFfmu6K7psrPsCK11ZGykqbRXccxccFs0zYTUWrhNS4UPKRSX+YnegChEeb1MdqTp9F4d6U/jbAcSFHY7aBMbg/SJZWXgBl8SFx4vV+OLxRi+qn48BIV2K7DFyxf27vaKJQRCv3MWCyL06WAMgWE0pYNg1zEi/Y+yrx2hQbupVjK/8v1XlM6hag8GxYDsl4UyXKE3OYXCOHkgh5TGw3+ALZZZafGI6xx2E9AV5HmYdX+0cm3m2SL8q23DcRhJj1+v2PqU7stogk68ySIhPcmQ0cPUq+kxue36cs854E3d5Ipn6cBU57+STYvmCh81Oh3xLh5kUbh2YeKXMkfE3KPuR9Qo1ZjCM4Htqko9QecPmX22cFwlSSUMV88n+KYuIJIVNLkPnB1ZibG451Upo6AVeZpQADKdspq
 n4mOin+k
 cYPTUZBPP83G7nWN173L17UeK/swEmdmheJX2ZCodQT1nuy2WtOIa2Sc6U5xRoyjNUptyk2rq89iRu76v1rc26GQlYHbOAXp1+pQQ5cGqNQ0KTqFI3WLBwHYKAtpOjLb0s6tADlcRwnn/zpnCJENnzCxUJLS+grjMm/LZ/aZMgurE+60nqOWR351He2oBuXC/z19J6nuTqYLjAw9NZNcxconGxkml9wvO/v6SnBqlHDjEd+9mSWd2OvcgZhPhOS7URGXGcn6gCKsB64l6ilIx1AXVCoc8JEuRRMZ5oNPwkVONV7dxmtGeKnvNhE1BxYlMmx+MaOOo2eMHKvnIJRYjV/QKkki1agNHQm/vJHCShUwDZc2XmOHFWyd/nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > Similar to what we did with mapping_interval_tree*(), let's declare
> > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> >
> > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > anon_vma and the functions can figure this out themselves.
> >
> > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > to 'pgoff_last' to make clear what is being passed.
> >
>
> would it be possible to split the pure rename changes out from the
> changed function declarations?  It's hard to pick out this as something
> that needs to be looked at as more than just a %s/x/y/

Hmmm do I have to? :P I mean sure I can on a respin potentially, but it is a
pretty trivial change? Just mechnically as above.

>
> > +void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
> > +				   struct anon_vma *anon_vma)
> ...
> > -	__anon_vma_interval_tree_insert(node, root);
> > +	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>
> an annoying request, sorry

:)) well it's ok I've made enough annoying requests of my own on review :)

>
> ~Gregory

Cheers, Lorenzo


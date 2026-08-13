Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361E8C5DF66
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517636B0266; Thu, 13 Aug 2026 05:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF356B0269; Thu, 13 Aug 2026 05:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEC36B026A; Thu, 13 Aug 2026 05:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 203586B0266
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:37:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B16FC1A0575
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:36:59 +0000 (UTC)
X-FDA: 85095742158.22.5DD62A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 039D8C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:36:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lz1Duy5E;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613818;
	b=sI6PehmnvRzQH5pr5oImmq4c9OeUgcyj87dnNZHHg3p22aVvnBnZE+ZmaKm53HoBrxKXB9
	AIT/LK5DDqf6ZeMi1Q8XRWBzUMWryrN/EdstJPBlbJL+fSqUmuTDko4T+05BuGdfTOmmbR
	iW5vvYoXYHpSrrDS3kY2tmpyBh6rMag=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lz1Duy5E;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSSZgUjMMjodUF2jdlWEV6On7VUDzA3+jCqusZy+uHI=;
	b=YOBb9WPZkoKmZaMUV3w3nkFUF3n5lkPi9xJ7hiZTMP++AqIF+NAivoqR2Q+QvwcWUPIN9Z
	hOi5jxJE57/G+7sS+BbxeHLqoKkjEdX3Zebe+pHyrEvxmUa4ZdMOhCVtSPvJqT2WwbNUaO
	Iac9m1eqBLHjdSaNnB4v5CoTPU4p7uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C1684050A;
	Thu, 13 Aug 2026 09:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AAC1F000E9;
	Thu, 13 Aug 2026 09:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613817;
	bh=JSSZgUjMMjodUF2jdlWEV6On7VUDzA3+jCqusZy+uHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lz1Duy5EEJcZhdAXU+VSGCAzjzSl7Kl+2x9ncpE/plgruGPWrJSXsgJ2lIhi0rQyx
	 sliVkI2Aefju0S0hgJvweLoT7d2v+tO16QpN39qrZ7iGGNqly0nKRius6h1q/JnSK7
	 cP4vdq5tefx9H6GW3cP5Mn1Ld3Jhb5QI/aIP4GAl8HTzo20BPS0/yzFBY79XYrBsGv
	 Z4czr0gSiplSdNc2NweADG0o5ddfvy2HXXlZ4RX+bbv/PrwXw1EbqM8ipXjCI1yPJI
	 xohYc83bYTwoK1dRJ0h+9ReF+fALWELNLpnn0/uGJKajxIsac9e4uOKPC0dRxQL8Gx
	 4yBEag3xPb5mw==
Date: Thu, 13 Aug 2026 10:36:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 17/20] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <an2PqxrAAJaEC4u2@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org>
 <c7930f14-5978-4709-bac2-54950c988883@kernel.org>
 <ant1xwiG3djtoXoe@lucifer>
 <14a06774-4157-4629-8327-b1a6bae24ab7@kernel.org>
 <anyst_4LGm6bpWdq@lucifer>
 <ea3c2889-343b-4eba-9758-cf56c75da4fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea3c2889-343b-4eba-9758-cf56c75da4fc@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 039D8C0006
X-Stat-Signature: j198xsipqfzwg15mkm6q3y4h6swiczdx
X-HE-Tag: 1786613817-989426
X-HE-Meta: U2FsdGVkX18BzThmPLYlLEKZnkmFnf/9mhCbkaIA3B1Z6UdEO9FZonpR/aBzsrvdWuXPFEKrJHpK2t+pSO07gRbRVMjT/H/ZJNjvCJvH7SBn4Jvzp57vmiX5qbat48vMTJqhSKueHknvbXrTKwIrYG/XY3mE30LgcdwldXcwNBjhywhHKGHhFCRA74izw6CkZmLiSrjjmnLM5yrsMIOBr/FqBIY4bPTM9O+iaoMSFNolUgC9eFxZHsecdaRASxLNGWrJxzo8FLAzTPaha7FQnc0zAIfLTUvk2hDvUzElRL2HZxAQMred42SzmgTqLWiHSsABbQa3NpNC4GfXr1h6d4f09+o2quk7UVHVpBRQ1F5D/NXi27I6n8A7wBEKi3/ATvd6Br1p+J+pV/N5d19V1xcncO49VlOOLx30aHJK/hNsALkuxsHXoYZ3LswMUDlBSHh+BtJXdQ3OeFof38ajSBVwvUSaSNPrX2v0nhPZD/Oq8+syPKkJOxfZsoREEXXCt9ZrftVG3sMYo9e8xi3vQWqtJxPTX3Ro8cgwAnNM5rAW/fS6JlU8hVSeAdJua6gloqO/xssX6ZzBjWtuRFogJ+RkmgFSJkAxYg8JV0k9mnFBsDQ2bdzbnZK4hIkUiA/vOv8Eoe/sLAV2uDfba0Zj8tri14Z968EQatS1J68tokEvXe+4+Q9UKrk9+qAxbVgRWTOfHjfPEcNKqiSfJjRIpHRcKUYy053Zso+VSbyjQlYoayQYRGvifHwuPIvYSp7Q2kabuIMgnfcTQxSt++5TtogYleJsO8c1Tv4CkGvuLm8EtQ97y5QCwicX57LNj0oLAzCozz02p4LZo8vXJcza0VzK8bXPuEV5TnDMth9gU/Z+eFltUPug7qr+/nT8+6OwtPX3Tv8gADvPc845NQCbXw/5jWxbhthCyyorU1gfzQ1lmyfO5EfTadCOcD63jMf3aWZp0qaRoZ7OTMsUULJ
 wU7M26ou
 XsBcS1JA1sX3IsRScZqA4kedZ8SQazMpRHlghLBrY4FFEjH4cKC684C7gOacKCzXvnaQq+FMDz3qpg5uF68AtNjavABs6zPRhpVgkUfB0HinXS5bKo+Aa3sCLXWdgZrm31sLyQbHFE5c4ghmhhSiPyj/NIGe2Tg2NW+VfEJQXsetJAFAULIfRcgyOsRSVyvaxxDOizKdxshXxcSXizuaZkVdn0u3D9/oDvUtSC+N4P+T99+8c/FYGhmnACO93EOe8PK2PmDjHL34NphKDQA6d7njouim3hJsQ4hXDcpFpUxmxIjZXvt8PGqbigtk/TMFTuRJ3mhceX+KsTpBZnQI0I84ANL7Jc8PyWn5Wb9sejens3mg2FuJnONm/qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:18:13AM +0200, David Hildenbrand (Arm) wrote:
> On 8/12/26 20:05, Lorenzo Stoakes (ARM) wrote:
> > TL;DR - either we need to find a way to uniquely identify it (keep my approach
> > or move it to core mm) or we should drop this patch.
> >
> > Given we're late in the cycle + you stringly objective to my approach I think
> > maybe best to drop it and respin?
>
> Yes, let's handle that separately.

Agreed. Will respin with these bits lopped off!

>
> >
> > Can do a follow up to add unique identification later, somehow.
> >
> > The key change of 'make anon-assigned file-backed MAP_PRIVATE mappings not
> > special snowflakes' will still be achieved in the other patches (but have to
> > rework them a little obviously).
> >
> > On Wed, Aug 12, 2026 at 07:15:05PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> We don't assign vm_ops for a MAP_PRIVATE-/dev/zero mapping. So that won't work.
> >>>
> >>> We could expose zero->f_ops but then it's literally in drivers/char/ and that's
> >>> just weird to expose in mm.h or whatever.
> >>
> >> Thinking out loud: could we use a dummy (empty) vm_ops?
> >>
> >> We'd place it in mm.h (zero_vm_ops) and just use it in drivers/char/.
> >
> > The entire purpose of this patch is to _uniquely identify_ MAP_PRIVATE-mapped
> > /dev/zero and only permit this to make a mapping anonymous.
> >
> > As per the commit message: 'mm/vma: only permit MAP_PRIVATE /dev/zero to be
> > mapped anonymous'
> >
> > MAP_PRIVATE-/dev/zero to anon is a historical abberation. This is why it is a
> > unique case where semantics don't make sense.
> >
> > Doing things by semantics makes sense if the semantics are a _class_ of
> > thing. This is not a class of thing it is a one of one.
> >
> > Yes the method used is ugly, but the alternatives (I can think of) are:
> >
> > 1. (your proposal) allow any in-tree non-module mmap_prepare() driver to map
> >    anonymous pages, creating an entirely new semantic for memory mapping.
> >
> >    (this is currently something that is possible, unfortunately).
> >
> >    To be safe we would have to implement then a series of checks to prevent true
> >    insanities, because doing that would permit broken madness like a PFN map
> >    being treated as anon.
> >
> >    Once this stuff is out there as an API, even in-tree, even non-module, people
> >    will abuse it because it'll go through some random tree and we'll have to
> >    support it.
> >
> >    I mean we may as well just not make a change in this case other than maybe
> >    preventing .mmap from being able to do this.
>
> As discussed off-list, we could have in in mm/ and special-case
> drivers/char/mem.c to include a mm header like fs/exec.c similarly does.
>
> drivers/char/mem.c really belongs to core-mm.

Yeah, there's no approach that won't involve something gross but it's a case of
least-worst.

As per my MAINTAINERS change putting drivers/char/mem.c in mm sections also
(first step at least :) I agree very much that it's a core mm thing or at least
large chunks of it.

>
> >
> > 2. My solution - ugly but uniquely identifies the single permitted situation
> >    where this behaviour is desired.
> >
> > 3. Export something from drivers/char/mem.c to mm - horrific for multiple
> >    reasons, violates separation of concerns etc. etc.
>
> Jup.
>
> >
> > 4. Move the driver code just for /dev/zero to mm - I thought a pretty horrible
> >    idea, but maybe we could have some mm/ bit and some driver/char bit like
> >    hugetlbfs or uffd? But I'm not sure there is a not-ugly way of doing this.
> >    MAP_SHARED /dev/zero does shmem stuff so maybe could live there.
>
> Given that I think drivers/char/mem.c really is core-mm material, something
> along these lines also make sense.

Yeah, the devil's in the details but the /dev/zero stuff can be dealt with next
cycle.

Respin incoming!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


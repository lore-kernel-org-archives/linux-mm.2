Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE15CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124C66B0088; Tue,  2 Jun 2026 16:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBCC6B008A; Tue,  2 Jun 2026 16:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D936B008C; Tue,  2 Jun 2026 16:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1E396B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:47:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DF5CC0442
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:47:35 +0000 (UTC)
X-FDA: 84836158470.06.ED1DC7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA18A1A0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:47:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzt8VJlF;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780433253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feidG2as/XbImAclBaae090g0zSDhLsjz6jl/0A4LvM=;
	b=XKcjt4vdSWHQEbo7r6ZC91YZwnwKd70MPVEMCbppLFLQPBng0UXJc09bWrcWKVtaOf00Fa
	wA0r9FUzj4lo7vlR/8Z/min4dK78COuixt8XkLTHHIFwv7OmZ1FvBMX+zsemGdsHKieEsZ
	zEK07h0caii6W3d4dPtbr9xdM/8qwJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780433253;
	b=qE1N4kLrs4K7IIWdGQnSpAousZymS4Te0yR/a+I/SAMgLQMwV7rre4ZQ7aZN/VA+vXTEQZ
	svyarfpcs82RmibiQ4G1Q+JjaXETezAObXRGPBakkH3aHK7UYs4jMrllGtgkL3qJuIv2cS
	whH3/4KBFves3hitWmWsrh4AbY809UI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzt8VJlF;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28DE360098;
	Tue,  2 Jun 2026 20:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56691F00893;
	Tue,  2 Jun 2026 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780433252;
	bh=feidG2as/XbImAclBaae090g0zSDhLsjz6jl/0A4LvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nzt8VJlFbZ1fLWVcj2WlL05fM+BocJStfm95qE/oxhpfKoTl2aVhIhpyxmUhpn7Sh
	 xXb1w5fL4q0FFF8tkj0FC0w+t18EK8wlWQcYTwE9iYo1FIOFqmw7nREQ+kjB1pSJMs
	 kWUzxzF1cdXbUuAl8PM3VZ8GosZJ7hrEFmnD5AB/scpGZu5KjU+4OQXFtWiqd2Y8Me
	 dws8W7hGRkUrW+sNeYWrqf6mUxNg9UQMRMVruAd4TJCIHU6TreYhygTZIyLW5h168K
	 tfwaQPpZ1v0nAC3JICmLT8yrtJjFUhEsnA/MbuCM0gBWDJcmpA5TskWK78MTEqkpaE
	 Bv4gjeOV7WVhg==
Date: Tue, 2 Jun 2026 21:47:17 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: Barry Song <baohua@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ah887A5VkXOcmq-g@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
 <ahlzj--3Gm5pD9ge@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahlzj--3Gm5pD9ge@lucifer>
X-Rspamd-Queue-Id: BA18A1A0005
X-Rspam-User: 
X-Stat-Signature: 6bo8mb7cn5x3gm6xu5w4wwy4rkfwfetp
X-Rspamd-Server: rspam08
X-HE-Tag: 1780433253-610575
X-HE-Meta: U2FsdGVkX18RNi6FjoVsEKfx1UYnp/euuMhkzwiYpbNIDO2BxyeLc6kjF2nQYprRrpK6AfYvtvk5ZkKnGcyUYmkRI+VB8qdN6dDERY/S6gPP35y9uK5PkG5POHgG5Nka9hkG+f292TCko3dBAbgD8xF7DrXFJJ5osFNqqVyTyjRVnqhhm7ItdfhwH1Brl50YmPr5hJp5bZ/HPwoflhnNt+j1xd7KvcQJbMW/TqRTc/k+cFINjXaL4RTCv7ERB4n9jr9nmgvIm55COX0zwEcyU0aek0qcnpGnCnVxwdaOp5GlB9KGzL60cb8ij3t51DA89QFGa/8uZIhgiEenkoTCT2Sp3gOnetXmNvrS6yAl0QuZEFo7n5H/BVnPy8ngzSYfVuOzdZ1XvBmurcKU8UAGxkGSVgg4pAfwdDmgv045HRgAdXGGH6lfdym6xppyx0EgFzoSVccWKn6EHtkU6O3hKXBJ6tm9ABitEVY8desIzVesWOUC6sCm9XMvMj6J5auFNUopBkFTaCt7OGMyW66YIBMCZxaAK0sA1wck+C7SCB6iCbp1b5kOA47j6p6Zhdqmufb82PxxQb2jqQWjIjupGfXW6ZsfGZ6prwZ0QRm1kvqoSDGHJQwt3AjcCVlK44FQmtemXTMBPBkNpcvexEgO+iQLXVbz9p8FBWhUIoEs8TLkLPH1gz969hdweNLoM4wXOESm5pjEXjOZ3M0E9hTJZVrEPOCU5J1T+l6n4c6oBtuIV6OSVPCH4H56QBa1polPXCHJbBJFLw7wiL6NRvMaocdLNdwNSv/RpHo1Ouov0bu7jOYEdVstDHK4s6Z5flzfytf6VDlICCEKB5nCHgfMyCo2ZIEWeEi3wPScuhhbX3qRDTmWFEwMFx12iARL2kUfKDRDmBSFCc/7UHzZe6iLq0BD9V3foA56K+sEbXvc/Cm31eEqa4WNSAQ2hBHH23lb6dqdOepmm8a+6/PT1M1
 wQJTpzIj
 TVNSbKk3CKoRtc2d6AZlsSlB0+sZUnN21PaOWTVLm/U6aisv5mUbx6g2lxYUv5R6a1eMp972rSKnNB2VJlyCDHUx9tOxetPEey71wQOZxDKUwvaiw31f2wRTF6YUyjt3qMNkLIT+ghp9gxUeI3PtwBXiy0KR+s0h6W7zs3LaaGRTItFmPIV1Ka5cF6OoHzr1PJ2IfgM5vcuqJsVaERIPVX9NhREd9zXI2ex1c9TzosVI3FUTVT734SENFPNCZuoduMZ8g0gtQGUIqqj/kLhsoVkkiYGU/s2LEkMsRbuPBzi+LN21IhKCRklLJf2XQpB8cmCBcoiJE1HqbREraf/1u8SXMhcpgdjJbRArBtCkXALCoiV9HX2WfxlLyKFMACMadVr7hu2eYpBamkYlrxSKEEhzDjO1UmJpdC4l52TovMGaF6WoMr5L2ZLixgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 01:04:08PM +0100, Lorenzo Stoakes wrote:
> On Fri, May 29, 2026 at 09:41:20AM +0000, wangtao wrote:
> > > Hi Tao,
> > >
> > > Lorenzo had a discussion about rmap in Zagreb here:
> > > https://lore.kernel.org/linux-mm/aec533b2-37a7-4f44-a279-
> > > c4aa604206ac@lucifer.local/
> > >
> > > He also shared the PoC code here:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/
> > > cow-context
> > >
> > > and the slides were shared as well. In case you can't find them on linux-mm (I
> > > actually couldn't find them myself), I am attaching them again here -
> > > "scalable-cow-lsf-longer-version.pdf"
> > >
> > > After coming back from Zagreb, I kept trying to find one or two full days to
> > > read Lorenzo's code and slides carefully and write a blog about them.
> > > Unfortunately, I have been completely busy with other work. Sigh... we
> > > always seem to have too many non-upstream tasks.
> > >
> > > If possible, I'd really appreciate it if you could take a deep dive into it and
> > > write a detailed blog post. I'd be very eager to read it and better understand
> > > the overall design.
> > > Otherwise, I'll try to find some time next week or later to go through it
> > > myself.
> > >
> > Hi Barry,
> >
> > Thank you very much for your reply.
> >
> > I took an initial look at the cow-context code, and a few points
> > might be worth noting:
> >
> > 1. cow_context_walk currently assumes that the rmap walk runs
> >    under RCU protection. This may need to be adjusted early,
> >    since paths such as try_to_unmap_one, page_vma_mkclean_one,
> >    and try_to_migrate_one may involve task switching.
> >
> > 2. In cow_context_walk, traverse_contexts appears to involve
> >    multiple nested loops. When there are many child processes
> >    across several fork layers, it may not be as simple or
> >    efficient as the current anon_vma approach.
> >
> >    It needs to traverse all child cow_ctx, and within each
> >    cow_ctx, remaps_for_each() has two levels of iteration:
> >    remaps_for_each_entry and remaps_for_each_entry_offset.
> >
> >    In other words, it first iterates over cow_ctx and then
> >    traverses rmap_mt inside each one. The rough complexity
>
> >    seems to be O(#proc * log(#rmap_entries_in_cow)), which
> >    may be somewhat higher than anon_vma's
> >    O(#vmas_in_anon_vma). However, in most cases the number
> >    of processes is not large, so the impact may be limited.
> >
> > Previously, I also considered converting anon_vma's rb_tree
> > to a mapletree. If one entry records a single VMA, the
> > average overhead could be less than two longs per VMA.
> >
> > However, unlike rb_tree, mapletree does not support storing
> > multiple elements under a single key. The key would need to
> > look like (vma_id/mm_id + pgoff). On 32-bit platforms, since
> > 64-bit mapletree keys are not supported yet, the remaining
> > 12 bits are not enough for vma_id/mm_id.
> >
> > Because of this limitation, I later started thinking about
> > ways to reduce anon_vma allocations instead.
> >
> > I will try to find some time next week to analyze the
> > cow-context design and code more thoroughly, and then
> > write up a summary.
>
> Tao,
>
> This response is so full of misunderstandings it's not really worth me
> responding to any of it. You've even hallucinated an imaginary field which
> is REALLY suspicious.
>
> You've no mm expertise or history and came up with this in a few hours. I
> asked Claude to analyse it and it puts it at 75-80% chance of being solely
> LLM-generated from cow_context.c.
>
> I simply don't have the time to deal with this, so unfortunately I'm going
> to have to withdraw the suggestion of further discussion with you on this
> topic.
>
> I am working on the scalable CoW project and will solicit opinions of those
> with relevant expertise.
>
> We are not interested in your approach or analysis.
>
> Thanks, Lorenzo

Apparently there's some misunderstanding about this situation here, sigh.

So for avoidance of doubt - I've now spent many hours on this, and unfortunately
(as I've already said in multiple places) this series has serious architectural
and code flaws.

And unfortunately, the anon_vma approach is not something we wish to extend, for
reasons I've gone into elsewhere - but broadly because it's a broken
abstraction, that uses lots of memory and causes lock contention.

The approach here has multiple technical issues, so many that getting into each
one would require hours more of my time to analyse, maybe all week?

And then if there were further replies and replies to the replies and respins...

However, I also feel there's substantive, overlapping, evidence of the _logic_
(not the text, we are FINE with using AI to assist text for non-native speakers)
being LLM-generated.

However you can never prove this for 100% certain. But you can certainly be more
or less sure. I would never suggest this unless I was really pretty certain.

I am very keen to avoid 'witch hunts', or rash accusations. This is not
that. It's a _carefully considered_ opinion, based on evidence.

But of course - I do not know for SURE. You can never know.

The big problem here is asymmetry of maintainer resource. I simply _cannot_
respond to every single issue here. And when the architecture is something we
don't want, then it's not really necessary to.

And my big deep underlying concern with all this is - people can generate a very
significant amount of this kind of work, and we have limited reviewer time.

I've already dealt with burnout recently that I'm thankfully recovering
from. I'm not really keen to go back to that.

I really truly worry that if we don't have a means by which we can quickly
dismiss/deprioritise things when we have a _significant_ evidence of wholesale
AI generation, then maintainer overload will increase exponentially.

And that's really a serious problem.

If we treat it like simply a technically incorrect solution, then it means we
open it up to further discussion on and onx, as we're actually observing here. If
the responses are also LLM-generated then it's even more problematic.

This is why I bring it up, and proactively say it's lead to a real loss in trust
in this case, and why, after there was a response that included a hallucinated
field in it, I went further and said that I really don't want to have a
discussion either.

It's because of this asymmetry.

And even this reply, written at 9.45pm at night, after several hours of
discussion about this off-list, is evidence of the problem we have with this
kind of asymmetry.

It's nothing personal, it's about managing time and resources.

Thanks, Lorenzo


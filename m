Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79066D65C7D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD366B0005; Wed, 17 Dec 2025 11:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B1B6B0089; Wed, 17 Dec 2025 11:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40436B008A; Wed, 17 Dec 2025 11:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4B26B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:35:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C121BCEDA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:35:20 +0000 (UTC)
X-FDA: 84229513200.03.0FEBF06
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1B4A14000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:35:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XUqiwMV6;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765989318; a=rsa-sha256;
	cv=none;
	b=7AzXJGMfFDGpaPpmlGrzUHOT61NWhmIPa7gvhKG0GCdVhb2+CP99Qpb5s7rLDkaJjy7lew
	J2qb9sdyVjWUpHhQQpUEOunwrB8p5gh21U1rpP2Q7TVrgY5f1+0HIEAhpMM0RUfI/nWWeW
	hbapH2gZo0WuJGsHQfneEGWq0Bs3IyQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XUqiwMV6;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765989318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LT/eoeOFh0CE8O8xtQLWZr34mVlrEoKfLUvdJt2VskU=;
	b=7H5U0GTIjyaf+WeeyjcHP0m1qXpyv0kpei9UK59ADYMqG8hDPLS574ySVXFamE4ifCzuFh
	j2FqqUwekL3zOL8x8yEtVzIlWxoYu5zysGVWGp3FNSIoZ2XkE/Q0LLtZyDkRIZDRWn8Q+B
	LGLExgkMvhCok0Ejh9EALFvCgH309r0=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b1bfd4b3deso512922985a.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765989317; x=1766594117; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LT/eoeOFh0CE8O8xtQLWZr34mVlrEoKfLUvdJt2VskU=;
        b=XUqiwMV69dUFuPolDVua199xMVQIB/GwOjPhN5FpTKzYdp26RZBEwnOQDEhhADo/R8
         dIXi33y0HsGDXxbfdNHmi/ENgl4rPkWMbXJ1PJjOkNYnUrY7XmQB8UlfVgiLveYd2QOc
         ktk/Ao7krLgOgAdW/kXdpO6DFPSnSjmB6RiCMJZN04TjY6z2sEK5phHGlKkqvKveqOP5
         qfTGDNzD6KE6TSicSKOZl09TJMajVdziJQf5h2pMFb2UJgakFotdF2YSZlvcjjOemLPx
         JJhlnzSLjFt0D4dNwb7pDXpgtUchKwKBDy9Xp7Qk9mLod0ge4vTUXwrKcy+lk7VHNDFE
         FmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765989317; x=1766594117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LT/eoeOFh0CE8O8xtQLWZr34mVlrEoKfLUvdJt2VskU=;
        b=CJS5UAa2ENrPUD/RFFQyRskRLU/jOjxiBNLDOKJDYmdRtTph99ihiLZTJUntyTXleh
         3LowmdJYHs0SMc1q3gfxBEJUR15k/plbFfWs3giA3h90mH5sTK/49NwdoZoLYq9qyvIf
         QuX2OOeKM7lzg8fpzynzgQPjKRsgVMWUzMFkuZDZORBXxyusFoJt9DCakCIxXe+sOgO4
         4zHLKGjTQfQtne5sCWmfT6nyXpcFLo1NL4QC8fkWrQieV3/vJ9lqvxXJPFTmRMbV69qh
         d4fgSAs8W7pavSxh9Dn0YMK41FW6XG/EdPXPkobodpvzPgO9pke4PWZ+5hP2ho98lNqs
         0JKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKQOHMa1vqzSJBZmvHdhMdmBAQJtArsvD7Ths5TZN+1rneB9jcKxWL3OsWeV3RxlQyYXkxe1C9FQ==@kvack.org
X-Gm-Message-State: AOJu0YzuLGtCu8v0dA5zv74Q+M336RQQKn8o/tB42SKkudRySH62aRl7
	tHnij85QE2nxxtjSAcHK3BoM7g6J/Cc+Zs69YJvWKx09VjFIjEVtFz+kPDz5ErHAtwgAhl+l+av
	CVcMC
X-Gm-Gg: AY/fxX6yxUCFG5yzWWudWKgeRqQWzQiVCfbSyCx3jK27VraPGpvFib1F4tUWx4keZTq
	7lNp+S8tobHl4zkjsAgN+lWA/dcvoalVFfLz3KTmP9vv9aqezVRnoenD0pTi1MQ/tzPTML8wjI3
	mxSdSQT0HJC0PHVDm3yNFw2RaawjoNH3cxc3UXNyVTAE6lrimVS2bQVmBd/1FEmc36K/HDyl96Z
	X8ifpPSnSiH9hkUad3YdhYcm0oe5bHa0dYGGFLKfEk0+Q47wfk6IL0gnpdgeU02TyNnFj/OPYgN
	/8XYThv6NxHUIsCSdQevNgydxNgH/nVGURXmTSFgc/pEiTrpGrbQb/omvox63IDdzldgx6iQ8eg
	VwJzcgxbJb3xgILXlKEyXQ+D5e92rzfLGuAADKbYAH0UJdNXCGQ8GYWiX4qc9GxxPoY3ACMG9xH
	/PktViNbzLgQ==
X-Google-Smtp-Source: AGHT+IEdVQwaRWuZqMlFZP7bAEbc17BdtpQnTZNWcSliJO6TUQ0KPHU1PoqLyumAHTZhjSEkYVESrw==
X-Received: by 2002:a05:620a:4509:b0:865:916b:2751 with SMTP id af79cd13be357-8bb399d9ae2mr2577959085a.14.1765989316709;
        Wed, 17 Dec 2025 08:35:16 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be31b669d1sm432934285a.46.2025.12.17.08.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 08:35:15 -0800 (PST)
Date: Wed, 17 Dec 2025 11:35:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY
 allocations faster
Message-ID: <aULbwOHkRvWwy6zg@cmpxchg.org>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
 <20251216203243.GJ905277@cmpxchg.org>
 <9881b540-7e22-404b-aeaa-282dc5eeb5d5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9881b540-7e22-404b-aeaa-282dc5eeb5d5@suse.cz>
X-Rspam-User: 
X-Rspamd-Queue-Id: F1B4A14000B
X-Rspamd-Server: rspam10
X-Stat-Signature: d58z5zdhdhabpsym9tq9qq7s5681gg1u
X-HE-Tag: 1765989317-780195
X-HE-Meta: U2FsdGVkX18xmFe7ZFsAk51JFlEr4qqeVMSfZho4vamIG97H3wJgodvQ12bRTZi1+rb66noSP29IuPjjS2JOZPly3/soNMe+XFoyF60zujKQVozjJQh1BaNQQf0/TUE2yeLCRNVmRT/KGaEn3xbOT5sBNuwwPYzKffIGXfed8e+mbLEm1booMFbwtQTTiihHkkqnuODbM5o1WXR8fF1dSoWr2AGE4ia2J0UzdY2+ttYZYDlQMMP439IroAUEviRX/ASKwPAlnkapUWgz2Y8pNORRO4saSj9+B6B86krJCZSee+VnoKsw8Imrlz6tdiPa1I7SiYkJwAAn+cnDzO3K6x1+CDFU5I2xae/drvq3tPNzO0kAvChT2Yb74ze3DV9g8RX/da0OuqTGw3CeuSG3CjUB1kRAWwXJ25OKvJvctqHQeD7kMsRcFlo3DOk4qphoh0SSlwJKdyZEckkkS9b80H0uZMSsXh7gMZQWz0xQ8VJUOc2ToR5UGI3OeYNWgoHpQICQImYzU0rIGYfJYgaHKuS30jiBljBUtANn5XMn0YdczTguJUgSekkqtwPjD455RsKzXGCfdKFvVE6TBBvDoWM2pGKnVULdkx5rjkUkxWCvjyRVBIN3CqEogiXWa5kRfoYmmdrPqRKYhWeUVpvSeiOxxk9fl/IX3fVKIi7H+65jDte0DNauyRmq27IPvFX980p9HoZEyvCXvDZ3NcOOHv/dd/3qCQmVpcJuDKn7YnCv49LSGlatkEUq3jDj/ty95TP7AklLeAJ+dVLaIGGoBkBQlK96daxLP+X4hSE/9UT5O08gvunxpY25RJLZx0oFA5TWDS+LO7POvOoAxv97qcsky7eIA3zKONpZpxJWwAEWadXjH3UiDD2OISnbRYctlM5hueUlye6iTf5sp8IzzIoGJWI6E2jQY66LyftZzLvEEcNUaW4Fyx1PPGSsb2NywrrGUS3bFIXMOWO9oEy
 Igj3Zvvs
 aVHJofUCPCLTX57/SY9bNM6r/tztXk0Sp4FAgvwycN/BexJindqswEnbJpH8Ks78/gac1D7nxtwSJrY5rQ+5B3gM8mARQhQh2R9Lxio795uVTAyFCqvdGVQMaX9pnk2x/sr8t6sG+OX2gofKuWNBcvTf4jKJQjTeoZzVkMvxZqtH8ykIvmldv2fl1IKBSKopb81++iTrJSnShcLuJyN4DOnaYv+E1o8itJPrIaaSjgOQaAJfX/nFF9+LxDZRdjwpa7ExdZzYCmKUpGZNEiPLur9vtup3HjrP0rOYiDGdYtjUUvA9y6zKaIVW1OziE1sRDaC9rfTHHxcz7mgg54j1WVNKgAIo76EPBs3x2ffXkNAeTVN9uWYWV4KI9dd2AEo7LI19S82UVQw2avTweW50IOL1deqm9FAbMnBbfa1FK4SMwZG6u1y4zTo+MhtuiT0BwYQxOCt+CFEspnQxPsvpuklbvbrhxBeIcSDoo6iyrxoqXHAEdkW4t4mon/eN/3Rg7RQM9vRPlUzSgvaDSFN8TmV7Jyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 09:46:34AM +0100, Vlastimil Babka wrote:
> On 12/16/25 21:32, Johannes Weiner wrote:
> > On Tue, Dec 16, 2025 at 04:54:22PM +0100, Vlastimil Babka wrote:
> >> It might make therefore more sense to just fail unconditionally after
> >> the initial compaction attempt, so do that instead. Costly allocations
> >> that do want the reclaim/compaction to happen at least once can omit
> >> __GFP_NORETRY, or even specify __GFP_RETRY_MAYFAIL for more than one
> >> attempt.
> >>
> >> There is a slight potential unfairness in that costly __GFP_NORETRY
> >> allocations that can't perform direct compaction (i.e. lack __GFP_IO)
> >> will still be allowed to direct reclaim, while those that can direct
> >> compact will now never attempt direct reclaim. However, in cases of
> >> memory pressure causing compaction to be skipped due to insufficient
> >> base pages, direct reclaim was already not done before, so there should
> >> be no functional regressions from this change.
> > 
> > Hm, kind of. There could be enough basepages for compaction_suitable()
> > but compaction odds are still higher with more free pages. So there
> > might be cases it regresses.
> > 
> > __GFP_NORETRY semantics say it'll try reclaim at least once. We should
> > be able to keep that and still simplify, no?
> > 
> >>  		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
> >> -			if (gfp_mask & __GFP_THISNODE)
> >> -				goto nopage;
> >> +			goto nopage;
> > 
> > IOW, maybe directly select for the NUMA-THP special case here?
> > 
> > 		/* Optimistic node-local huge page - only compact once */
> > 		if (costly_order &&
> >                     ((gfp_mask & (__GFP_NORETRY|__GFP_THISNODE)) ==
> >                      (__GFP_NORETRY|__GFP_THISNODE)))
> > 			goto nopage;
> > 
> > and then let other __GFP_NORETRY fall through.
> 
> I did consider it as an alternative when realizing the potential unfairness
> mentioned above, but then went with the simpler code option.
>
> With your suggestion we keep the THP-specific check but at least remove the
> arguably illogical compaction feedback.

Yes, I'm in favor of removing those either way.

Reclaim makes its own decisions around costly orders. For example, it
targets a higher number of free pages through compaction_ready() than
where compaction would return SKIPPED, to account for concurrency. I
don't think the allocator should have conflicting opinions.

Regarding __GFP_NORETRY: I think it would just be a chance to simplify
the mental model around it again. If somebody does a NORETRY request
when memory is full of stale page cache, I think it's reasonable to
expect at least one shot at dropping some cache to make it happen.

Shortcutting directly to compaction is a good optimization when we
suspect it could succeed without requiring reclaim. But I'm not sure
it's reasonable to ONLY do that and give up.

Btw, I do wonder why that up-front compaction run is so explicit, when
we have

	__alloc_pages_direct_reclaim()
	__alloc_pages_direct_compact()

calls following below. Couldn't we check for conditions upfront and
set a flag to skip reclaim initially? Then handle priority adjustments
in the retry conditions? IOW, something like:

	unsigned long did_some_progress = 0;

	if (can_compact && costly_order)
		skip_reclaim = true;

	if (can_compact && order > 0 && ac->migratetype != MIGRATE_MOVABLE)
		skip_reclaim = true;

	if (gfp_thisnode_noretry(gfp_mask))
		skip_reclaim = true;
retry:
	page = get_page_from_freelist(..., alloc_flags, ...);
	if (page)
		goto got_pg;

	if (!skip_reclaim) {
		page = __alloc_pages_direct_reclaim(..., &did_some_progress);
		if (page)
			goto got_pg;
	}

	page = __alloc_pages_direct_compact(...);
	if (page)
		goto got_pg;

	if (should_loop()) {
		skip_reclaim = false;
		compact_priority = ...;
		goto retry;
	}

That would naturally get rid of the gfp_pfmemalloc_allowed() branch
for the upfront check as well, because the ALLOC_NO_WATERMARKS attempt
happens before we do the reclaim/compaction calls.


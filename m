Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F38A2FC72B5
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 10:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E476B00BC; Sun, 22 Mar 2026 06:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA2D6B00BD; Sun, 22 Mar 2026 06:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1DB6B00BE; Sun, 22 Mar 2026 06:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C60A36B00BC
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:22:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 551955A900
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:22:32 +0000 (UTC)
X-FDA: 84573309744.24.13790ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A88B6160008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:22:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBUBeWMG;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774174950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6N0kvRYnZJDaYc0bb2dAstYX6HXCWNABBbpGHfaYFI=;
	b=I79rgf0hpOtPDz2cCfmpxVOczcOBDOD79awllttzzvRSXyW5BqOCtj025kBCgrX88jsZia
	Tos0dvwUFY1udbNXpAAn7phhVj1m85joiSsCPa/g6Jsc06WMnDQc5JtNFZrwmygmvyUSRZ
	qsE8d52WKcgRdI6IXbAboOdaRk9M3wY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774174950; a=rsa-sha256;
	cv=none;
	b=wwdHUTvtIU6aNiff55obaLbWwjRhxWSXASwgJ071CCuAL4qb9UwiThmYxf2SmXDCHCIfbN
	qjUFNF8KZI3jk0pSdlGnvhAerrKDJs6zGK4boaikEm5M6sK5kWZFm4bUaiMHElVe0sLVYV
	gLiooReuTwDSC7sKBzeigp0+vMljFds=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBUBeWMG;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2276600AE;
	Sun, 22 Mar 2026 10:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2CBC19424;
	Sun, 22 Mar 2026 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774174949;
	bh=ja8xYsnuPES+yA0rNROYguH6Aiw+cEWcqhgX6fvgPdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBUBeWMGDb+8siC07t1h2NvFCZ9g+o0BUqaeaOADmskfTDWZlRbxSMC+IV4f1YRm8
	 7xNJWwypic+vW4gFPxCCxB9YUNfWNaZLHHLQT62spAQ6sQn0pLbITciakpYMnFzlHY
	 7QV4Dthc4IrKZS/wmEJ9Avw+QhcHFpHBCQD8/snwbHF3npHHvLCLdE5+fBLHwOmLEe
	 FlzeqpsvnJIB20mxp/4p+bUvzVzHdPu6RCoL2CoJEPxfp/ZtIxNR1AD47QusOm/Ah/
	 7Elnp421pTGBrVqC/rBBgk0YRP/cFrtzTDJejpVNplpIxI1qzCtLuxd4MPY0XcGiVK
	 S48LVT8HX5yVA==
Date: Sun, 22 Mar 2026 12:22:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/15] userfaultfd: introduce mfill_get_pmd() helper.
Message-ID: <ab_C2enJ5DTIH5aH@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-4-rppt@kernel.org>
 <ac39f02d-ed00-4b8d-8156-1e999f5b0af3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac39f02d-ed00-4b8d-8156-1e999f5b0af3@kernel.org>
X-Rspam-User: 
X-Stat-Signature: od1h74ebx3z9b7aydoehzpdxq5tfcpqn
X-Rspamd-Queue-Id: A88B6160008
X-Rspamd-Server: rspam03
X-HE-Tag: 1774174950-481379
X-HE-Meta: U2FsdGVkX19Pbp3LRRteMZ2ZHtIxk7ZmrOmBNwRof9DDU+mKq9V1fWWYwu1WhTKF14UGPmiHIC8iMY+yLzK5iFF/2suPREuc9iR/2bnJ5+7uTD5ZO0k1/OI4GpkB9moTAP0HwUDbUxZ0GCRumLCeEuAzk1uaDOhB0MBGMx/G8hb5dae9Brlft9MUYBEth4jPpjPI7XG+a43VYLTeUut84/8X8itg9SM5LDhXNKkuYOBu8ZxgdjvGckXnX/S8GhcL0+Sc5KjPKcy/gDf2gHp+Om8Nf0Uy/u/weBNbzGESFYy6PtDkDA9+nnSb94N9L+SLxeagbe0Q2s+0yaaTGaFNWByX5l8XwYsPGMczdfdpKHzTAqUfL/WTejeuDTjyq6cfdu3hR8AovMPvUSxOL+KVf/9ezTkjR35p4KP25jpmuZ3ZFrDWNuN6t+rjOe9AiughiJ/Lk57mE1UmUQw4r4v6fo2+w9s/BZCN9MTs23b+LM+d0f3XxPD4FGUG0rogkbD0sDgJzz+ZozoSA0kNjcXRrbOrDLaFptSLlpdKU2O/zSZ9CX5wwfWiiL+jURGvcu8d18/DIbOQ7IoMuHxxjAD8wuSDUv47HIDRKN+XWkTkUX6/98BDYgiVCuvVHWraNl/WRncfYIRMp33+pQPqwcQ1tFQAwUi1+l4j4RbAQWThDipZKBsJ91XR/0Y7yX0tdUdrOyNnWQJzh3d//6H1ycfUCkuJYdV1mLVNSXnCExtRJrTAb4iA76tuXopHIoscTWZeZGdGLYuUB8ypmmKM1wOtu5ELvDaRN5iJ2DjH12oyzOw1gZQHIuLgVbbz9m1h4xRKHmFuCSrb0eRTECf1uzvDyVm+JHg/FWe5YHGTArK5xdj5+vlqNd5WqV4ZNDDBXPQh+5WM0DumQVf0XKdWoS/NvtpkS2OFvigkXZLmTQ+03M8aqGIqbNFGo7C6ZurTufpGheFMchyeNHPnA8MU5ZA
 JurJ+0oW
 t+TJdikEKED+2wl5pzoGkfsNKE3CLmX/daUQs5iUYeLJAK6oP8FbuAVm1yJ8h5Dn3fq4U1bHjWVXYKjsiC8hveZjg+Lmw/28bmjzMUwSi84aX/REIvHK6G1hpxgCcifovqzTINDz75PjHdaj5xDMjG/tlJ7TDZcAq7I7Fmn1oYhYtdbEifP7xFD2LO+oTzFL16bMA7YCZEwaZHRqDWABxFBszHuFD2ZMxbAE1xWKN5mtZL98O712uPU9JMw71r4otmqRstbN345GMMjB6VtR6ekJHKcb9Lbt4XVF9bNFe9O67B+QawdZ8nLSoKkJtaophL+kKRXoYAumiE4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 01:55:29PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 18:18, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Nit: "." at the end of the patch subject
 
Oops :/
 
> > +static int mfill_get_pmd(struct mfill_state *state)
> > +{
> > +	struct mm_struct *dst_mm = state->ctx->mm;
> > +	pmd_t *dst_pmd;
> > +	pmd_t dst_pmdval;
> 
> I'd just have both on a single line.

Can do :) 

> > +	/*
> > +	 * If the dst_pmd is THP don't override it and just be strict.
> > +	 * (This includes the case where the PMD used to be THP and
> > +	 * changed back to none after __pte_alloc().)
> > +	 */
> > +	if (unlikely(!pmd_present(dst_pmdval) || pmd_trans_huge(dst_pmdval)))
> 
> Can we directly switch to pmd_leaf() while touching that?

You mean instead of pmd_trans_huge()?
Yeah, sure.

> > @@ -809,41 +838,15 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  	while (state.src_addr < src_start + len) {
> >  		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
> >  
> > -		pmd_t dst_pmdval;
> > -
> > -		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
> > -		if (unlikely(!dst_pmd)) {
> > -			err = -ENOMEM;
> > +		err = mfill_get_pmd(&state);
> > +		if (err)
> 
> 
> It's a bit odd that a "get" function doesn't return a PMD pointer but
> instead stores it in the state.
> 
> Maybe more like "mfill_prepare_pmd" ? But actually you want to have a
> pte table.
> 
> mfill_prepare_pte_table() or alternatively mfill_alloc_pte_table() /
> mfill_alloc_dst_pte_table()

As it actually allocates the pte table once in 512 times, I'd prefer
mfill_establish_pmd().
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.


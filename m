Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098F2F55811
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB436B0088; Wed, 22 Apr 2026 04:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C7E6B008A; Wed, 22 Apr 2026 04:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382156B008C; Wed, 22 Apr 2026 04:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29E6D6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:24:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC625160F9B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:24:50 +0000 (UTC)
X-FDA: 84685505940.22.6C3FB42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01492C0008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:24:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cv0wwWgr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776846289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYLiGcnW+OQmYUURhujiHWOSX8EBFzucg+U6o17BlWI=;
	b=O5ZiA0MpV74sDC1X3+1Fp0t+xMVw8nkgWacH1rN9JG0wbFeJ3Kh/zoKqsNxqIwyrIb1Vue
	fTaoVtKIzBz2AymfkxY9Dr379aDZszRpwjG2tHnqpMAaSY/O/Lv2TIjX+NMauPmYuhVMYu
	RR1o+nYHoiV1fjIhnjK2bKyn5Vbhec8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cv0wwWgr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776846289; a=rsa-sha256;
	cv=none;
	b=o1yaoSA3Fb5sWHHiWL6NhpuNCPv2hKNKF2JbZ/JRwHt9pnhqGhvum14I/UVStaEdOsVPz7
	VhX83wSXFZsu/m+4tWSc1qa9GsswvtBCjsQ4g03fx131+Aj/uEyWpYiENYMhltpd0CYqpU
	DCWZaZIKhd1Eb5AtzqKhjCtp+nENApI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 059BE4069B;
	Wed, 22 Apr 2026 08:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1779C19425;
	Wed, 22 Apr 2026 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776846287;
	bh=O4CGkWR3yo72+GsjHY8NtS8RkGbc3ZGUxRZULeofgFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cv0wwWgrynQ5CA3sXK6hAWgNSFWM9M0Zf2+AiJn8U6B9PhZ8P+C4ZcFM2PTWH3/gS
	 xunfJhdsw6QoZtFJ7iQZ1jD/zF3jHLpWq1U0LzJ1UqK6dYj9WCy5q36v2PwNmOUy92
	 +ddok9+Sq2osrJYGf7HRLV38oc6lizDVYyDKEbkCaWLBoeXywA/hrW+EJmemlReyHx
	 A4tFlE44uBAEjEHQbhIY2BImZLll0veiNGSOAJpViaay+cnCilRb/Lf1uj4stLtM/3
	 yk99yteLjLs3RCIdvQqb8sXfx3R6zXyYAEYIw67qBRxVeD29gSj3H9EYJqOxWNRAEw
	 bTUUsOhSinHig==
Date: Wed, 22 Apr 2026 11:24:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
Message-ID: <aeiFx8tilasoGzwa@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com>
 <aeD2Fzr6yr4pu9-X@kernel.org>
 <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
 <aeEKksfLxQ0A7Jun@kernel.org>
 <CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
 <aecUW-Xgm5MPMyVr@kernel.org>
 <CAAi7L5d8x1MB1f6A_h2acj1CYU1wf7DijS1TENC+Lurx5wLhKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5d8x1MB1f6A_h2acj1CYU1wf7DijS1TENC+Lurx5wLhKw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01492C0008
X-Stat-Signature: semmyyn1g3zz4mc9gfocphy57epgck9y
X-Rspam-User: 
X-HE-Tag: 1776846288-798457
X-HE-Meta: U2FsdGVkX19RLY7tOyYec5ul7Ma/x3DaCr7JdeEg08L0dE+QuiP7Qd7JsTeCnXltkSaynga32bd/KBITuFc18Go1Q0TLCVWjfiWGVbWmw05HFcAI+BnR19gmy+u9/tMDYFkb8Im1fyazSt4HN4zJ0syTdIoLHFlprHvYJo86tlYtnF+svESerBf1NKvuEcNSJMpMeqsjXgF6bajSBPt9RIbP5y3/etBmH2xJxraOcp9QbeiNdsLlEh4jaRYHDXGgetK+HyVehuyF5YFqCKqOQpF6IAcMhb6vOx3NMLeWmUva4L8nguP3uExW5KKNl6e8ZKhzIn/Il9Cz8vmLsL2I7KajxPPFudFN9IRweHE+GUtYHwm3AqRkVeaHkuIZh9nJpHIGbQFw/ffzOECBUXLj/wPjitduH1c8cgTx0d9QUrip4WZvSvu01bfkaJmyo4Ius8q9gy+5An8PynbsYJa4+5Oglz/i4wwNPISbqCuXLsQUmActEChJJQGRK04yhbnMYz7xI1rZ4kH+We6DnHOJ3Jc8bvBUUm7MtlUoEW77kbKnQunSQ9M38SLyY4M9SJgiClUP8FTzL20Gfq/b7YJ5KP0whuhgeOdYTcKCpxDprRijDVQa/9YPKYzIqGrhhCwYwlJJwkvZYuxfV0b6f7ErdTH7vU7/3EQLjn0Q9V16dllivRPXvh1wapzxJI6FJIsP7AYUwoRna6K4pvmqis+Ch9NQzG0RLVqO5qzk9G+zQjbntzkTwh/0JP9F/b5X1o9XAns65mKksWwMJE2N6lrPrQsJWrFQTGnwWUZWSm63jnZSVXtvgNGzRGNHeM6fi+2jdrEbd54Fgcj1/ZnL8vY4eNNN8xY9oUyKAn1lKZXJ53wydLgK/5G9c57Qb4rTUZA2JlaT38B1cYqcrZtT9rbm23mNGp8aQBrUV9FbjdTI3Mmi96nzEpP+hn4+cHVN+OGqR3BJbP2x6P67FmjIokE
 DrdOGP/1
 VQrkovQ//Oc/P9DfG1lX5BZqSHJwe4K9/RK3WS36xTFwSSDdsWOGwoS3RkUXT6zFdv9F2GcaqZBL6sKL9gov960t43gGw4S1kDFvjl6a/k4rwvU3s0xHdt7xwzNAUq1/uD6AhAadnKeLcvwDE3ob1aCfiuimyNlVtizm6cg/qtbH54KaFkdOmazx60OUsusFJ3v4VLC0dd5QWxnDZN5yUdnEmYSXff5cJf/muqs+KHzzX6urGs8xySO9Jgd6QXV2bZgMwrpeKniEez9W3NVkfb7ytoDQK/ECzGuJSE3xxZpHMlUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:20:27PM +0200, Michał Cłapiński wrote:
> On Tue, Apr 21, 2026 at 8:08 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Apr 20, 2026 at 03:11:03PM +0200, Michał Cłapiński wrote:
> > > On Thu, Apr 16, 2026 at 6:13 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Thu, Apr 16, 2026 at 05:06:10PM +0200, Michał Cłapiński wrote:
> > > > > On Thu, Apr 16, 2026 at 4:45 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > > > >
> > > > > > Hi Michal,
> > > > > >
> > > > > > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > > > > > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
> > > > > > >                * access it yet.
> > > > > > >                */
> > > > > > >               __SetPageReserved(page);
> > > > > > > +
> > > > > > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > > > > >
> > > > > > No need for #ifdef here, there's a stub returning false for
> > > > > > CONFIG_MEMBLOCK_KHO_SCRATCH=n case.
> > > > >
> > > > > In all 3 places the #ifdef is there because MIGRATE_CMA might be
> > > > > undefined. I already broke mm-new branch in the past because of that.
> > > >
> > > > Hmm, that hurts :/
> > > >
> > > > The best I can think of is to add a static inline in memblock.h and ifdefs
> > > > around it.
> > >
> > > Sorry, I don't understand what you mean. What would that static inline contain?
> >
> > Something like this:
> >
> > #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
> >                                                        enum migratetype mt)
> > {
> >         if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
> >                 return MIGRATE_CMA
> >         return mt;
> > }
> > #else
> > static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
> >                                                        enum migratetype mt)
> > {
> >         return mt;
> > }
> > #endif
> 
> How would I use it for this code?
> 
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> +                 pageblock_aligned(pfn))
> +                     init_pageblock_migratetype(page, MIGRATE_CMA, false);
> +#endif

Something like this

		enum migratetype mt = kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);

	        ...

		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
		    pageblock_aligned(pfn)) 
			init_pageblock_migratetype(page, mt, false);

seems better to me than ifdef, even though MIGRATE_MOVABLE is bogus here.

And since we anyway changing init_pageblock_migratetype() callers in
mm_init.c the entire block in memmap_init_reserved_range() can be dropped
and the change can be done in __init_page_from_nid().

> 
> It doesn't invoke init_pageblock_migratetype unless pfn is kho scratch.
> 
> > Can't say I'm happy about the name, but could not think of something
> > better.
> >
> > > > > > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> > > > > > > +                 pageblock_aligned(pfn))
> > > > > > > +                     init_pageblock_migratetype(page, MIGRATE_CMA, false);
> > > > > > > +#endif
> > > > > > >       }
> > > > > > >  }
> > > >
> > > > --
> > > > Sincerely yours,
> > > > Mike.
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.


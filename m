Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3207DCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3558E000F; Fri, 12 Sep 2025 13:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BACB8E0007; Fri, 12 Sep 2025 13:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF3B8E000F; Fri, 12 Sep 2025 13:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC028E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:46:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B0786861
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:46:50 +0000 (UTC)
X-FDA: 83881328580.27.456B51C
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id 105C180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:46:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qe2cX+Zw;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vw7f5TtJIYqwNPOyneHeov3n6RLT179M/tH+XL6psMs=;
	b=2/H/LwznNchsSkMA3gJpSM7YpqX232v8MV8yAH8Wu/dTGG3txIaLaiLb2oUq+wmC8eAmK1
	R2DmRybRAc8wI2fI5atpVJ116nSU8koipPBPwSPVJRGNPeNarhprRvBxRBCwFXBqhvioI2
	Vw1KwvLyVtcUWq63cQD+nOapC9HQlhk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qe2cX+Zw;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699208; a=rsa-sha256;
	cv=none;
	b=LmzyQmR+Z2JuAXAUrsK0D2TyaN/y4b18INcDkNqT8QB1o6zTrggcrzgVa0MT/xbJ3BoJxv
	aVFjv1MJW5bb0jugQDqCph2a9k8Czzl5SV3vE4mjWDHrpLnRoure0DrnUqUx8GjyK22BLb
	YnTlY4hN3iJS+LvyduDrFtbt632OEog=
Date: Fri, 12 Sep 2025 10:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757699205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vw7f5TtJIYqwNPOyneHeov3n6RLT179M/tH+XL6psMs=;
	b=Qe2cX+Zw6g/o/Vyywjq1zLa6mXLmwCwRkOo7yknYXmUVxxh4yTZQHIKkPA3GDUlDAJCpo0
	o1w0bFnPJ0q+wkrUU8W5/3FPVQ7llM6tfnurK+cZ3D5UyE2pFyWBmvIfxoYrBgaN8lxDF6
	lDw+2UrHRpQ7+R61IHCGY2ASSTRLfSo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in
 alloc_pages_nolock().
Message-ID: <jcofoqbchq37v5ypzrolh4yn5qmjikmdgqkhqb7nemkzjh2igk@26kcqwo723xv>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com>
 <2kaahuvnmke2bj27cu4tu3sr5ezeohra56btxj2iu4ijof5dim@thdwhzjjqzgd>
 <aMRVNqH47mdkl5Ke@casper.infradead.org>
 <CAADnVQJbx0Wf4xrAEfQyZhhpC13zJH6NqdFjYQ+StQzzi+Y=Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJbx0Wf4xrAEfQyZhhpC13zJH6NqdFjYQ+StQzzi+Y=Nw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 105C180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: apxde6rijzjpzk1b74ddh668gbpiyxhq
X-HE-Tag: 1757699207-900538
X-HE-Meta: U2FsdGVkX1/n8+DqhlLug2Frx65d5x9qUzAT6iwj3B+d/bAbaA7ehNmTMF/eVhX3O1lghiqSwoMnafDmQZwtHnOTlNxTbQ5Hbfl4SHDKzgthgO5p94R9ueUEwsTkODFoNukSaNDd8Bzu5GD9syxkiBPFLoxTn674E6irC/t63zncMyfK0zWxxGCDCNAFOinPHyQeuFT7ugv8z9rDZUB3Ja7+fDItvbJm6ELoQX/C1gSbZwPhnRWIkIpyPEjGL1SAV1jzVmMMWnGCbr2BEgBq+hHqnSXPGFN0/4Yo4EuYlzhyK7VeBBCavReCv3JY4cIeEWvRPcOxvQiph5cA2OaDPFUjdT12/KzCd5DR+Q9WlMNuBU5y8rjp0Z0kDNXSItgyno7c2Zsd69sLpHIT2hL+dAEKQaPa3rOlpY7xTt2dWoIo/ci7S7ls1tUtjqCTDtg5NMqIExLNMQVDXseDuDtxDTmbo2Qu+N+BCwhjd35TVpe7GRFTJ/vniid/2rMZjAzYZUCunTxyJfInFs5ogipdbbL/cqC50hJj35RY5cefkWnwsUbIoo7OHIF3jIlF/DflgeXtC+xFf68Q6dW34meY65uhqor1qvCRN0g2l9bN04/Ot7i1svZ4VMnNnC1R8/JCxgIO/TenDcwBUEdCcFGT0edkf3pnIWW2am8xlPmoyP/En+1RCKFBfhw1mtz9870I3vIgOcOayhTgbtvY+yfBpzXWtZnlX78HtW+I8bZVySoRVhub+NwwVok8b9s5V3b+d7U/QSErlZsGYcAbZc9wzNCkLw5moPWCi2a+gNoQSrPIPYdV9X9waJCNvcuIMlR6frAyeu0WvpRgy/iwc6n4uJqn1ATAw0SehlWC0fl8laMG8n1Gehd1lb0wK7g+aLxcBhquCcPqsca9DSlmib9XpMw7l9q79jfnltqR/TQCpZ0U6LVhuyDdBabQMAWaWqFz3dGKfsfv8C22B0S0Tc2
 gL3ViSnZ
 FL3rNFovamhoq127QW07PM7XgiXbG8SzSabmmwMHk3PNkiXh7O/DzBxK4xbnbHrIiBwJtmd1PZCGYUiMehP/282GvKx/FZ7Np/vuV6kYcq4PGKXJAM9JVKJJnc+9WSEy45WzZPRdgNa0LWK8DDG4ha+cyVNRFfqh1jQYBOv1+i7oNpLNlH9l8U618tKbbpra8PshhWQF+wz/yG/n999WTOCoxDoGGkh820nkxtuwqJE0OJ+Yxn2tXMtct8z3+/Q1/Fi+TF/6S06wEKdZ6pcsVmbZ76+6apW/OHzORn9UmHvgy7gcwVkKOy2HlC61iAl96z7qatI7RE4rJazUXB2y9PTr2Zx+ntoyh9V+Lm0u9cL+PTFab4RT7NOANZi29JuHBvixH21PnsM/ySnlWJYnN+kUedmZ/6iFIs9HT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 10:34:15AM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 10:15 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Sep 12, 2025 at 10:11:26AM -0700, Shakeel Butt wrote:
> > > On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
> > > [...]
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index d1d037f97c5f..30ccff0283fd 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -7480,6 +7480,7 @@ static bool __free_unaccepted(struct page *page)
> > > >
> > > >  /**
> > > >   * alloc_pages_nolock - opportunistic reentrant allocation from any context
> > > > + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
> > >
> > > If only __GFP_ACCOUNT is allowed then why not use a 'bool account' in the
> > > parameter and add __GFP_ACCOUNT if account is true?
> >
> > It's clearer in the callers to call alloc_pages_nolock(__GFP_ACCOUNT)
> > than it is to call alloc_pages_nolock(true).
> >
> > I can immediately tell what the first one does.  I have no idea what
> > the polarity of 'true' might be (does it mean accounted or unaccounted?)
> > Is it rlated to accounting, GFP_COMP, highmem, whether it's OK to access
> > atomic reserves ... or literally anything else that you might want to
> > select when allocating memory.
> >
> > This use of unadorned booleans is an antipattern.  Nobody should be
> > advocating for such things.
> 
> +1.
> We strongly discourage bool in arguments in any function.
> It makes callsites unreadable.
> 
> We learned it the hard way though :(
> Some of the verifier code became a mess like:
>         err = check_load_mem(env, insn, true, false, false, "atomic_load");
> 
> it's on our todo to clean this up.

Sounds good.


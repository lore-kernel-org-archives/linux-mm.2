Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060D6F532E8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5D16B009E; Tue, 24 Mar 2026 03:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656C96B00A0; Tue, 24 Mar 2026 03:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594446B00A2; Tue, 24 Mar 2026 03:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48D7E6B009E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:35:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED8518ECF3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:35:54 +0000 (UTC)
X-FDA: 84580147428.30.909D01B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 257934000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:35:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScEn2Cwb;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774337753; a=rsa-sha256;
	cv=none;
	b=JGgkdeOVSCwFwhK5NvcBvNygYNzH5iCxCKXZQLkwgJe/6FLbv14zEZ9s7Z9IwsY8UlQLm4
	Y9dNFXhDSB6yecOCQg6FXxwisbCnT62/oQUKRuNZAjqhcoCLTxiNSw+AEUH1yxyV2SSvY5
	DYGmWna8A3W73DrPl9Yba5IdROwYQp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774337753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxbUOvQR/e9C7I70M1llHRBz8bMXCs/JzAvgwQ85M+4=;
	b=dxO72upuI3poW50/6P7Wm/SFPW8uDY97q0IiTycDcAb5CSZj3Bo5fJ8NnTc5d8Z35wH/+I
	5WA8oKCA6zrFlgU44PExJHOztNDUGypM5Q5hWauCggG4NTuDwmrFAVEi+4SpXiTSaxuQpR
	g68B3CKwxVDTsYJrc4uTIJgfk/NoXr0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScEn2Cwb;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 111C943C2E;
	Tue, 24 Mar 2026 07:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4433C19424;
	Tue, 24 Mar 2026 07:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774337751;
	bh=EIddR1V5uYs6yxK4aVXhe3hKcchvUnX0s1aNWkrkwlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ScEn2Cwb05BomUcGqM2ItmUGtVivXTJIdW+ok9yUSiPLGIpsrY4oR39AugZiHjyak
	 oIteL1yTaZrJRHSzUUytJL/OIXly/PM8CLUp634g1qjanWG+APT1r763jsXQSKPqBk
	 U5RUITEpu5S3s5wVNgSq1p1pDJJCovAoJi1P1dZ7tPNnkgFqQtAcpIOrv+3AyMjBLv
	 tErXlQ3eQla67foDObfTXT6/C9OpJssc8sgtK4XtIWu32myUJ23r/v/aeGfCIbu/rK
	 U5RiW7NOK24dJ2lCDhZHnOYuulfNoPpZNtQJzE4VjtKRlgaPtOSVD6z2CZMb/Bor5w
	 lZUPoz25ztEqQ==
Date: Tue, 24 Mar 2026 07:35:45 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <95130554-15c4-42dd-bda8-1ee8bc3fa370@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
 <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
 <4fb7fzdf4uirsxlxiwd4arbhlezgrawb72nm7sl2slntvxlng7@kimmnebrr4c4>
 <20260323170537.0aee4e4906169db510e9893c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323170537.0aee4e4906169db510e9893c@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 257934000D
X-Stat-Signature: b35n7pfno8p67c7wmf1a8zeyar5w7kyc
X-HE-Tag: 1774337752-583991
X-HE-Meta: U2FsdGVkX1/xxDyx/0bdZSglXbjI8QkLr5UqJKMXYR83OplyGqrP9hzhgQNSsEbwfbzbc8hlm7vIoV6WlRnH4wpp5RN+aoQFou9D4yxMmUAFEekK33F0BHC10kDrWRRwsdAlPAMkzpTH32ILE746bQuZ0Ror2mM10hP4kgeLIJIIs0NQ6pE00PSSacOd7lGrZ489lzGLxa2cvkRNOFS1cpc+RNIen4du0lJLoLNBYAtzbC6dBylxV9utIzs4wh/R3AoH3nKBBGdepbshNNwxCg8Ay4Whn3/TkZdOb5bQP8vcKAFgzul2tHjuLhMD4yYztfImlVTU64c1Hna0nbUpq7D92/YTmPagj9W6seeqzZHPZdkxXXwnDT6gRHKvlCn9f2wKx2IjqaXVZ1XTjBou/rnO7QrAdjHQEAIEsXOOCMEq+L4Fp3fmxstI3e5Nhrd7LXLW80BpPLzmqpHqry12NgiyZO7jfxu0tLr7MV5dX8HO3hC5+Qhueh8PxGk5zd131SYq+RmoscZcd6dvSlsGBqwIw4y82//MtMKG/nZ+fO4HZP3MLgJ0+xVDHa9JJ9ZcdtMWKG2w6Qd0zwKEKKdrg7vRYGw86TQXiOjhnzRwhs1TVtotJqz7eQhwuMiiNUBTC7oCWHu6w11yvmdGyxJq5gatmOZC/HbOhhCR/HfJiAyBXDD6DaNfl/YOQJI9jEdB4iBGvYjEAydANy/jZrSpFDvyv1+GbICsNdujEKRWPUkIqfcHlEXOx3lrsZskHXDQafpOSi4aJ61U3baeqb+oLhoNOITPC3PrTO9XR6DaMXzj1q/80vITAh93MuLm3Ts8xrjMO4uXOLFCJVm6nJEotTxiJJer6rUEhpKl2hIP+96I3qrPCMqnDrjB1cWcEjviKF8mKxkuwHX+jYhVal5DXRDzEcNTes6saf2HFUyoJBkJ5OIDIa2m3Ir6FstmD4zZblEtJsk7Oocf1CK5gus
 0y+ye2JN
 5NbGpHb5v4mbsIMX0A2sBJjz7J96pfwO4ThRLwMxSSzIB6dfCG0t8gBRQDan6AGV8WqAqQdjV8buMYjHUrtgo7ZmV7KixcfYSfK/hNklJIpMdhUw1++lc5fyOb01CwDhL1JRWcCkHpsLyd9WraRIhEYVewAsXDE4+9SyDyK6nKYCympDobqQ6R8jPo6Bzd52wrfeg2OvKo76mxFFPmZlNGvxY/kYsJF84XSG/DreZ+VBrdc/5fScVMlh72xsO4UjuMDtjJK7+ovx6kjodpmNJio5R+zresPRNePfn0/2kLit5DmIfdonXseVPUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:05:37PM -0700, Andrew Morton wrote:
> Well, I looked at some numbers.  Data!
>
> Searched for linux-mm emails which had from:akpm, message-body contains
> "sashiko".
>
> 22 emails received replies from authors indicating that alterations
> were needed.
>
> 2 emails received replies from authors indicating that no alterations
> were needed
>
> 1 email received a reply from author in which I wasn't able to decide
> either way.
>
> A few more replies said "no alteration, but we need to change other
> code".
>
> 10-15ish have yet to receive replies.
>
>
> That's a really high hit rate!  How can we possibly not use this, if we
> care about Rule #1?

Really this data doesn't support that.

If we're generous and say 10 with no replies, that's 22/35 or ~63% _where
sashiko was correct in AT LEAST ONE individual observation_.

That is not indicative of a good signal-to-noise ratio.

Do you not think we can do better?

Roughly in my experience, around ~50% of sashiko INDIVIDUAL REPORTS
(i.e. individual comments made line-by-line) have validity.

Roman has said that the strategy he takes, partly for sensible token usage,
partly to avoid throwing out the baby with the bath water, at this time
leads to more noise. And as models improve this is likely to also.

This is no criticism of him, I am grateful for this tooling.

The issue is with mm process.

This adds quite a burden to reviewers to have to deal with _every single
thing_ reported.

Which is what you unilaterally seemed to say was now a requirement, to
which I object.

There's further problems here:

1. What if a new engineer comes along and sashiko hallucinates a bunch of
   stuff and they respin + respin to match it, and now reviewers have to
   tell them to stop?

2. What if sashiko directly contradicts a human reviewer/maintainer?

3. Are you going to quietly just not take series and people find out in the
   merge window/when you gather up mm-stable in one of the many batches,
   because they didn't respond to a hallucination?

4. AI often generates new 'thoughts' just from being ran for a 2nd time, so
   do we hold series in perpetual flux trying to figure out if the latest
   set are valid?

5. Often the reported 'issues' are so complicated it requires human
   expertise to figure out if they're relevant, thereby increasing the
   already over-strained maintenance workload.

And again, I come back to you requiring sashiko to be able to apply a
series, based on unknown criteria, probably not correctly apply fix-patches
etc. - there is no sensible way for a series author to fulfill that
requirement.

Really we need input of _those doing the actual review_ in how mm review
works.

Let me make workable suggestions:

1. Defer this to sub-maintainers. We have the expertise and experience to
   make judgment calls on this.

2. Don't make this silly series applies demand. It's impossible to adhere
   to.

3. Don't require that every sashiko point be responded to.

4. Sub-maintainers use it as a tool - and only really consider
   critical/high bugs as being potentially important, and only if they can
   determine that the points made are valid AND importantly - only if doing
   so doesn't take all that much time.

Personally I am _already_ using sashiko as part of review for people to
some degree. I see that as being the more useful means of using it.

Treat it as the experiment it is, rather than reflexively deciding to
demand all points get responded to.

>
> > Sure. But I'm thinking about the human factor - I simply don't think either
> > contributors or maintainers will be particularly less stressed with the
> > introduction of obligatory AI reviews. Maintainers are still hardpressed
> > to review (as is their function), and contributors need to go through the
> > tool's output and figure out what's relevant (and _true_) or what's not.
>
> Yeah, it's a matter of figuring this out as we go along.  It will be so
> much better if/when people are able to use sashiko privately.  But
> heck, people forget to run checkpatch ;)

But we're not 'figuring it out', you're not discussing anything with
sub-maintainers or the community, you're unilaterally telling people they
HAVE to respond to everything sashiko says or you WON'T TAKE the patch.

And also (you ignored my reply on this and replied to Pedro instead)

So where's the figuring out exactly?

>
> > IF we were able to codify the MM process like in (https://docs.kernel.org/process/maintainer-netdev.html),
> > with things like:
> >  - NO patch is getting in without being 1) written by a maintainer or 2) getting Rb's and Acks from M's and R's
>
> Sure.  Where "in" means mm-stable.

I'm not sure anybody said otherwise??

>
> >   - Ideally both, but maple and DAMON need special casing for now, I guess.
>
> We do get quite a lot of patches from sole maintainers.
>
> >  - NO -next content is being accepted during the merge window. straight to /dev/null.
>
> For sure.  Well.  I usually park these thing to take a look at after we're all
> merged up, but it's usually all stale by then.
>
> >  - review state for each patch is <here>
>
> I generate that now, with the occasional "mm.git review status" emails.
> I could run it daily and add it to mm.git or something, but this
> doesn't seem to have generated much interest.
>
> > I understand. Ideally, sashiko would be a tool that maintainers and
> > reviewers (and submitters) could use to help find problems. I don't think
> > having you check every AI review scales. But I also don't think we should be
> > treating LLM output as if it were a normal review from an expert.
>
> Sure,  But that hit rate is so high!

Addressed above. Disagree.

Please listen to the people doing the actual review in mm.

Thanks, Lorenzo


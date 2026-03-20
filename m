Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE403108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182346B008A; Fri, 20 Mar 2026 07:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132B86B008C; Fri, 20 Mar 2026 07:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FF46B0092; Fri, 20 Mar 2026 07:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8AD16B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:45:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E88614019A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:45:44 +0000 (UTC)
X-FDA: 84566261808.03.BD8B00C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E196E12000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:45:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMNDdYBV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774007142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwLLq3QmrLWB5AzSReR2gD8eKTdNOjwY2/3ZSS6yUr8=;
	b=i5Yz9zN30qbGU4UR8EsA9trV6vT9xVJntR76u0MDxX3/0kw5fnFu4UQosmrtdg+ifRWfmD
	A6rqbS8bh+phD506yj+1x3UYg07S1UjWgqf3slh1i1O+/EGQi64RpQeW9a3Fw6UPcbeC0l
	wkOLAxtWEHWgdFkeWoxkOx5YyIl5ZPE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMNDdYBV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774007142; a=rsa-sha256;
	cv=none;
	b=6G0VMUKvCTn8AUGH0GrdLuDQNGTj5FY706VOtB1AeDlguLXULiwATPDyNhAYEr5/wXdfJp
	eOPjgb4zPrQYmKup74USJjDLPMZpQaTF3pPtomWop0Fs7YBke1L/nA1WAc96uYIHna8Rc1
	ZFBR2ijfJZHklsfCjfb7kjpkJQ9k/Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C27960121;
	Fri, 20 Mar 2026 11:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61018C4CEF7;
	Fri, 20 Mar 2026 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774007141;
	bh=9uYSpemjFc02l0BJoev5VXaeMVr+pvhj4ZI4N7TRYqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BMNDdYBVDRf4/rsEZDI6utjufu/E6f2DJlRkhVEXdQjNlL0A1FwPypLQU44/OTnAQ
	 WUdATRIAFL/vhZxklW/uOPlahqHV4fP0Dk2LQxQR++CiffsK712fR72ytyogsZFtVp
	 n93QeAXiOjY3lUjYYrszwbJ1stidv5XJuqxJC1xbsxjETFj7QC01GQRVr8PtYFDidE
	 SPPnrSrI1MYhU1QxDmH18n8j7qkqiGS/gs0WnFjojXDfDJxcx5G9/1SRx4canOclDU
	 XoeFhhh5m5DoL3IFeHRgw75aScqPoaBFR9lZsE+M7VV+dAYCZFxC2GMdmc/DX31mdB
	 p9zrAc9eDWOPg==
Date: Fri, 20 Mar 2026 11:45:37 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <11929205-d0dd-4e8f-8a99-2d0b02cfd5bd@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
 <9b0aaa19-b839-4ebb-a312-097b869154c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b0aaa19-b839-4ebb-a312-097b869154c1@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E196E12000C
X-Stat-Signature: 8dz5a49ck8o796d1f3jj9kqcpf5714yj
X-Rspam-User: 
X-HE-Tag: 1774007142-14364
X-HE-Meta: U2FsdGVkX18tQXcp6b5rBtHacXgwH4bH0s+BEN/JfgD8WHbdcbYgOtW8+H9ZQSOxdrQRs8DJHhP3O0MzALYPz4bLbvaC3SzDONVWdvdkWefcdwyT1QiYorzUKpx9AidPWBoPhQttcQNThriknsEVfmASoTBX1wVGZcQnBZqmQtYxYy6rcqaE9DP38Y8R8kCbcDhQ8DLNDKbmftDVbmpI8zAFQKsapH5ubJsFsXgnHew3fDncZ8Lln3miIkEBy9GvdNDEG+xENt7fAeNV8PK1e1jBobsli8DKjT/F4AfmATHUyyR3aH+cY5eqGjP7i3rLaNVYaRB3gcV7r5XWIXKbM7A/qt8da1COsjQbc7XCS3OO4IxOEGiE/Dge+BdUq3dMYkWvkn0oq6kLnz0m+GnG/tsr0M8kcX7LQovSzxjUrwOSD5K4gj82Zb6WjUMyJEptid2/pyyXKZcqBURaVyhqjFDts1hA4aKp55eie4rXoZOFuzNcOfno4Zd3o/s0MFU8tKnqcA5iA+dA1pYdY6pbKXzowsDo5IbzdLD2E2T2NKD4JWR2W6Zh+wk4e8oZs7Vpu7eoZWO0krmXYplH3Zp2q0wMnCSmZTx98w/NiDl0m5tiaGtNxgcxGip/GRq62LDaaA3elOi/HqKtJImymivJX2+O1e1fo5RitS16a47ItqkXePxlgEK4OkUTyR/AseL20VpX9NtIrtQGqW8C1g502tn5KK/S+zY2U+hAcHcOLM2X7dRBSiXb8fnzQLmFYoAVN/bef4LSFelEUze/SvR4kxf47+By8ZkA40sHflxIeqvovxb64eR9lFT6hjsAMees0iwMh+yEs6Eba/yi7Fzlb+iTIo61fJ9aDo2fQBP5AvDJY4+r+ZupMvrXzdNOmJabv+gAoqPKC2xpDlB1X1luri0fK/2yrdH5r8xApm9GBKI2GcBG/DlXjycUrVV3PMKEsg4ab5aLaYpdM1hMqwM
 g9mSseHD
 7czmU6ZzQPEOQWeHg1neMMxMPg7CJxKVJeiukd0XvxeiceIMLmssLAZZNPZN9+6fDJcbNrjKv7tuj3GACYeiGCcdtecaNDyrioUyy/b9ZZww4+h+hQK9DPS+DPrfyPlPE1DU02b7hXZMS80BvgKLUbxUdjrEDPpOkomE2QVt7HJoK942yGsA1RBS0LL1Dp6bZeJPGo7naNmVBnAOKyCL/FdPNdXIjP9913OybSZFBAniolznUiLfD9hzvBWba5cuuB6FfxWpXMv2QIH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:01:09PM +0100, David Hildenbrand (Arm) wrote:
> On 3/20/26 11:36, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 19, 2026 at 10:41:54PM +0100, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> This is all seems VERY delicate, and subject to somebody else coming along and
> >>> breaking it/causing some of these noinline/__always_inline invocations to make
> >>> things far worse.
> >>>
> >>> I also reserve the right to seriously rework this pile of crap software.
> >>>
> >>> I'd rather we try to find less fragile ways to optimise!
> >>>
> >>> Maybe there's some steps that are bigger wins than others?
> >>
> >> What we can do is, collect similar folio_pte_batch_*() variants and
> >> centralize them in mm/utils.c.
> >
> > I'm not sure that addresses any of the comments above?
>
> Well, the point is that you still end up with an optimized variant
> regarding flags, and you don't have to play games in this file with
> "inline".

Right, I mean maybe we're talking across purposes here, if the variants are say
generalised specific sets of behaviour rather than 'mprotect folio pte batch' or
'mremap folio pte batch' or whatever then that's fine.

>
> >
> > Putting logic specific to components of mm away from where those components
> > are and into mm/util.c seems like a complete regression in terms of
> > fragility and code separation.
>
> My point is that in mm/rmap.c we have another caller that passes
> FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY, that could use the same
> optimized function.
>
> For folio_pte_batch_flags() we primarily care about propagating the
> flags such that __pte_batch_clear_ignored() will become as short and
> small as possible.
>
> How much that matters in practice? For fork() and unmap() it was
> measurable. So I'd assume for mprotect() it would matter as well.

Yeah I think this was a misunderstanding, that's fine.

>
> >
> > And for what reason would you want to do that? To force a noinline of an
> > inline and people 'just have to know' that's why you randomly separated the
> > two?
>
> Again, I don't want the noinline. But providing a single optimized
> instance for two users that care about the same flags makes perfect
> sense to me.

Yup, that's fine! I agree with you now I realise this was a
misunderstanding :p

>
> >
> > Doesn't sound appealing overall.
> >
> > I'd rather we find a way to implement the batching such that it doesn't
> > exhibit bad inlining decisions in the first place.
> >
> > I mean mprotect_folio_batch() having !folio, !folio_test_large() checks
> > only there is already silly, we should have a _general_ function that does
> > optimisations like that.
> >
> > Isn't the issue rather than folio_pte_batch_flags() shouldn't be an inline
> > function in internal.h but rather a function in mm/util.c?
>
> No, we want specialized code for fork and zapping. That's the whole
> purpose: optimize out the flag checks in the loop.

Yeah, I think something isn't quite working right there though if we're
seeing measureable improvements by doing:

static noinline unsigned int blahdy_blah()
{
	...
	return folio_pte_batch_flags(...);
}

But we need to figure out exactly what via actual perf analysis, as perf is
an area that totally confounds developer expectation and 'going with your
gut' is a perfect way of doing completely the wrong thing.

(And I've repeatedly seen otherwise smart developers do this OVER and OVER
again, it's like a honey trap for the clever).

Not saying any of that applies to you or Pedro :) just a general point.

I don't _love_ that function being inline like that, but I will cede to the
data, but right now it seems, at least for I guess order-0 folios that it's
not quite doing what we want.

Anyway we're agreed the best way forwards here, for now, is to specialise
order-0 which just seems like an all-round win, and maybe the rest is not
as much of a contributor?

>
> >
> >>
> >> For
> >>
> >> 	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> >> 					   max_nr_ptes, /* flags = */ 0)
> >>
> >> We might just be able to use folio_pte_batch()?
> >
> > Yup.
> >
> >>
> >> For the other variant (soft-dirt+write) we'd have to create a helper like
> >>
> >> 	folio_pte_batch_sd_w() [better name suggestion welcome]
> >>
> >> That will reduce the code footprint overall I guess.
> >
> > I mean yeah that's a terrible name so obviously it'd have to be something
> > better.
> >
> > But again, this seems pretty stupid, now we're writing a bunch of duplicate
> > per-case code to force noinline because we made the central function inline
> > no?
> >
> > That's also super fragile, because an engineer might later decide that
> > pattern is horrible and fix it, and we regress this.
> >
> > But I mean overall, is the perf here really all that important? Are people
> > really that dependent on mprotect() et al. performing brilliantly fast?
>
> For basic primitives like mprotect/zap/fork I think yes. For other stuff
> like rmap.c, maybe not.

Well on big ranges of mprotect() it could be, and I know often databases
like to do this kind of thing potentially, so yeah sure.

But more so the microbenchmark stuff of *a million protect() invocations*
is not something to optimise for so much.

Rather I'd say mprotect() over larger ranges is what we should look to.

Fork of course is utterly critical despite fork being both a terrible
mistake and a great idea at the exact same time in OS development history
:)

>
> >
> > Couldn't we do this with any mm interface and end up making efforts that
> > degrade code quality, increase fragility for dubious benefit?
>
> I don't see a big issue here like you do.

As I've said to Pedro elsewhere here, I guess my concern is nuanced:

So if we introduce stuff like carefully chosen __always_inline or noinline
or other things that have characteristics like:

- They're beneficial for the code AS-IS.
- They're based on compiler codegen that can easily be altered by other
  changes.
- It is not obvious how other changes to the code might break them.

We are asking for trouble - because people WILL change that code and WILL
break that, OR a possibly worse outcome - something like a noinline sticks
around when it makes sense, but everybody's scared to remove it + _doesn't
know why it's there_ - so it becomes a part of 'oh yeah we don't touch
that' lore that exists for a lot of 'weird' stuff in the kernel.

Then it might end up actually _worsening_ the performance in future
accidentally because nobody dare touch it.

Or another hellish future is one in which such things cause bot perf
regression reports for otherwise fine series, on microoptimisations we're
not even clear matter, and cause developers to have to spend hours figuring
out how to avoid them, meanwhile potentially making it even more difficult
to understand why the code is the way it is.

So what is the solution?

1. Focus on the changes that are NOT brittle like this, e.g. special casing
   order-0 is fine, adding profile/benchmark-proven likely()/unlikely(),
   etc. - these are not things that have the above characteristics and are
   just wins.

2. For cases where things MIGHT have the characteristics listed above,
   avoid the issue by abstracting it as much as possible, adding lengthily
   comments and making it as hard as possible to screw it up/misunderstand
   it.

3. Often times perf issues coming up might be an indication that the
   underlying mechanism is itself not well abstracted/already adding
   unnecessary complexity that manifests in perf issues, so in that case -
   rework first.

mm/mprotect.c is a good example of case 3 I think in that it's a big ball
of mud with overly long functions (e.g. change_pte_range(),
do_mprotect_pkey()) that likely refactoring code actually see perf gains
just from the compiler not having to heuristically determine inlining/other
optimisations due to functions being in smalle rchunks.

Anwyay in this case, we can pull out an example of approach 3 (the softleaf
specialisation), and approach 1 (order-0) handling easily, and defer
considering taking approach 2 if it makes sense to later, if we get most of
the wins by doing the former 2 things.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo


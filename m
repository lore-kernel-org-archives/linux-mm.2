Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 623EFD3941A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFC06B0088; Thu,  2 Apr 2026 08:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6FE6B0089; Thu,  2 Apr 2026 08:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4106B008A; Thu,  2 Apr 2026 08:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9236B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:20:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2ABDC22FA
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:20:39 +0000 (UTC)
X-FDA: 84613524198.20.9BB0898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4490E20014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:20:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0uDeQ+6;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775132438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPQUSbMPWgdQTOH1Qw5sUxN61vx3JNFCUBg3iH5Psmc=;
	b=0CasQdlIxYgUNmREhiDI7bWPmIEnwsbN/Db0ZWmIPtfBE9k/Q/l7U/nF0h6wa041tt5Naf
	V6+1iLZaBJ3SMYWLOCnn152AHZM2EH1DDdVdKfVwGWAmyI5d+9pNVhTzmnhjomc/v/rsyl
	8baNRMmFo24tFHPmR7gSklY2uAtfMdA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0uDeQ+6;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775132438; a=rsa-sha256;
	cv=none;
	b=L83Sg/wAhtRIgsAhpB+evJ/A/XEfK43QDWDWKsHkUcYZldsZXdyq8TdTDxwNm9x/S1Ed1a
	Q1hBKJA9TM6sdJxTcECVg4ApjOUT3QF2Ul36miaz1P/tizuq0a/2qhV8an22aNlYLcFwSD
	NUoF6b8f1I0fmOIPm02BHsEN03KCUhU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AAD6361879;
	Thu,  2 Apr 2026 12:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0941AC116C6;
	Thu,  2 Apr 2026 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775132437;
	bh=SPQUSbMPWgdQTOH1Qw5sUxN61vx3JNFCUBg3iH5Psmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B0uDeQ+6FuhA4Fp4vAirox9XLTtRs13wQmvuy29r6WOq1uu7fBzfIlqGuV2d9OrGa
	 vkAURZZmGdYg5GjWNo+Obi5UriBWZ95EXyzlgOB7yg71RKxwZj/DTCVznB4//KUKZw
	 Nd2fmTn1ahK2MQwS0Q9RgeUjDM3Tm6cBzmiNuRCpvXVGZWPMnAAVDn46eJja2mQMwc
	 aDhdVEdHbMQvmh+TTbNv7aTKohJeWiU5f0rf7XA4OkWoYXGO5A6Mu37jm5w4sJOCyu
	 4s46uUu2IM59TjAcICHrFYnwhICsJx+7qfqzUEfDGARNx5bRY5qBraQ4j3/oiRNS2T
	 yIOvZC4crGA1w==
Date: Thu, 2 Apr 2026 13:20:31 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Chris Li <chriscli@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <926d7e26-4f13-4e70-a392-1111de27f700@lucifer.local>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
 <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local>
 <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: j71j9rkokagncqedgmuiairmpwxguj3h
X-Rspamd-Queue-Id: 4490E20014
X-Rspamd-Server: rspam09
X-HE-Tag: 1775132438-225970
X-HE-Meta: U2FsdGVkX19Xac1nuIajcq+RDWMjiR4Y04On/OF3Zyhu8eb4HDrokFEn3PVtt8mln76bAWnFqdcU7JETl79hUlene/X48OANmkINCIGZI6Bw9Sq9SKenFNSHdHA8P9sS4B+ppZIC6DZlul50oSVuEGW8i5eO6b/2pzgIsqo3nQEiJnP89h3cHSKqwry7sjzrWUMHrjGxTDUcJJA8T4WlBbiPgnZxoSznEzKfamdooFcWWTScD/lYIMnLejC8q81Mj4+U1h1tH5NiN/VMeMYYNlEuCiv60q5KXWjyLk9n6+qaFvLV4Zobm9AmWD+jsO58tcufhRegZ6vQo0zAPa4dOwOK79RhTNth2g6TYHgIeh2f/XyuG5DSLEs3HtLrafq5Zao8TadYQ9EXeGctkuOPZCseFKJ1hGNsmDCJzQe1rmz0tOz6WmVKx1pVks/U4S5cZtgd8p2A+5NM83/51oBnVNOXyP3RKUE7Afj6ArHfJo4F74YCVla3rdHiFlmqUPgCgWrVf3PTCog9pkioeL7Jh/Peilav/XVahFQAAzUYruS7iOke75M7lHJrhegdsMEM6FPBwnrirqUYB5XE9cVwlp+3FcGXqKh3Ig09G5XHm9EWoabiVvZ6WHc1QT4s+B3sARKEDHho0FT4iz/wlakPc23ZMuzVjQBpG8PQ26x0OI8Ob2DvgRabLpJKnI5bZ05R5meuMmnu/+/gz++gFAKWSyF+DdnahWUUDjtsvQ/zCFamGpwzVFV33gmGxq52RKYDxAGnr56Jt6vfPNFMLOhXpCsDUqdMfwXGpPVVRhvIKI97EFJTBfLXmuJG++/4B8MDU4Sn2sfVKZZL0OgVg3SIcEbbN4Lu6Ca0jSNhKJQzx5OHVgM2Uh4vcieX9YT/pEOgmTamOxcrZA/WUwdJhpO7ho0gXz33W3ESM9RTqbYXMPIsuoQLhHBXgZX4GoErzTeyMd+Kn5d5/fVyZr0iLSu
 FVdjS6Pn
 Ao5CEG67zHmcaIqZRBYJXfiRJhp2CzHKIBBvOlQXWfoB8uo+h2Kzuuwd7hoX6SsXyov0mKGSAjGSyGIf2+dDKDrbheFwMlm5gA0H5rT73FQX4SGl1NX6E73qxB4jbg7QGDMT/hAFHPc+3YYrn7xqKELB1DPriEPsPehG+HYF0HSle66Dy3QoReGUlWriG+4AMavjD7XJOvzTaPGCgvqPZhBLS01irEorEegl8xRHHbdsjzleRfaCW1JxDmWGtvqTgcIYam0QBMJZZw1LMhu6FyzKOqlSQFA7YnzKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 05:03:42AM +0800, Barry Song wrote:
> On Wed, Apr 1, 2026 at 4:43 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Wed, Apr 01, 2026 at 07:30:41AM +0800, Barry Song wrote:
> > > Hi Lorenzo,
> > >
> > > Thank you very much for bringing this up for discussion.
> > >
> > > On Tue, Mar 31, 2026 at 5:23 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> > > >
> > > > [sorry subject line was typo'd, resending with correct subject line for
> > > > visibility. Original at
> > > > https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local/]
> > > >
> > > > Currently we track the reverse mapping between folios and VMAs at a VMA level,
> > > > utilising a complicated and confusing combination of anon_vma objects and
> > > > anon_vma_chain's linking them, which must be updated when VMAs are split,
> > > > merged, remapped or forked.
> > > >
> > > > It's further complicated by various optimisations intended to avoid scalability
> > > > issues in locking and memory allocation.
> > > >
> > > > I have done recent work to improve the situation [0] which has also lead to a
> > > > reported improvement in lock scalability [1], but fundamentally the situation
> > > > remains the same.
> > > >
> > > > The logic is actually, when you think hard enough about it, is a fairly
> > > > reasonable means of implementing the reverse mapping at a VMA level.
> > > >
> > > > It is, however, a very broken abstraction as it stands. In order to work with
> > > > the logic, you have to essentially keep a broad understanding of the entire
> > > > implementation in your head at one time - that is, not much is really
> > > > abstracted.
> > > >
> > > > This results in confusion, mistakes, and bit rot. It's also very time-consuming
> > > > to work with - personally I've gone to the lengths of writing a private set of
> > > > slides for myself on the topic as a reminder each time I come back to it.
> > > >
> > > > There are also issues with lock scalability - the use of interval trees to
> > > > maintain a connection between an anon_vma and AVCs connected to VMAs requires
> > > > that a lock must be held across the entire 'CoW hierarchy' of parent and child
> > > > VMAs whenever performing an rmap walk or performing a merge, split, remap or
> > > > fork.
> > > >
> > > > This is because we tear down all interval tree mappings and reestablish them
> > > > each time we might see changes in VMA geometry. This is an issue Barry Song
> > > > identified as problematic in a real world use case [2].
> > > >
> > > > So what do we do to improve the situation?
> > > >
> > > > Recently I have been working on an experimental new approach to the anonymous
> > > > reverse mapping, in which we instead track anonymous remaps, and then use the
> > > > VMA's virtual page offset to locate VMAs from the folio.
> > >
> > > Please forgive my confusion. I’m still struggling to fully
> > > understand your approach of “tracking anonymous remaps.”
> > > Could you provide a concrete example to illustrate how it works?
> >
> > I should really put this code somewhere :)
> >
> > >
> > > For example, if A forks B, and then B forks C, how do we
> > > determine the VMAs for a folio from the original A that has
> > > not yet been COWed in B or C?
> >
> > The folio references the cow_context associated with the mm in A.
> >
> > So mm has a new cow_context field that points to cow_context, and the
> > cow_context can outlive the mm if it has children.
>
> So we can’t use list_for_each_entry_rcu(child, &parent->children, sibling)
> because in vfork() and exec() cases the mm_struct is not inherited?

Umm, memory is not preserved across an exec() :) so it works fine with that.

vfork() is CLONE_VM so the mm is shared and everything works fine.

>
> >
> > Each cow context tracks its forked children also, so an rmap search will
> > traverse A, B, C.
>
> I still don’t understand how we can get a folio’s VMA from the folio itself.
> For anonymous VMAs, vma->vm_pgoff is always zero, right?

No, not at all.

vma->vm_pgoff is equal to vma->vm_start >> PAGE_SHIFT when first faulted in for
anon.

That reduces the problem to tracking remaps, which I do.

>
> Are you changing vm_pgoff to a value equal to vm_start >> PAGE_SHIFT?

No, that's how anon works already.

>
> In case A forks B, and B unmaps a VMA then maps a new
> VMA at the same address as before, what happens? Will the
> traversal find the new VMA, which doesn’t actually map the folio?

Well you're missing stuff there, the folio would have to be non-anon exclusive
(which is rare). Yes it'd find the new VMA, then traverse, and find the folio
does not match, and traverse children.

rmap walks _always_ allow for you walking VMAs that a folio does not belong
to.

For instance, with anon_vma, if you CoW a bunch of folios to child process VMAs,
the non-CoW'd folio will _still_ traverse all of that uselessly.

In any case, this isn't a common case.

However note that if a folio _becomes_ anon exclusive, it switches its 'root'
cow context to the one associated with the mm which it became exclusive to.

>
> >
> > >
> > > Additionally, if B COWs and obtains a new folio before forking
> > > C, how do we determine its VMAs in B and C?
> >
> > The new folio would point to B's cow context, and it'd traverse B and C to find
> > relevant folios.
> >
> > Overall we pay a higher search price (though arguably, not too bad still) but
> > get to do it _all_ under RCU.
>
> Yep. I see that list_for_each_entry_rcu(child, &parent->children, sibling)
> can work safely under RCU.
>
> >
> > In exchange, we avoid the locking issues and use ~30x less memory.
> >
> > (Of course I am yet to solve rmap lock stabilisation so got to try and do that
> > first :)
> >
> > >
> > > Also, what happens if C performs a remap on the inherited VMA
> > > in the two cases described above?
> >
> > Remaps are tracked within cow_context's via an extended maple tree (currently
> > maple tree -> dynamic arrays) that also handles multiple entries and overlaps.
>
> If we have multiple remaps for multiple VMAs within one mm_struct,
> will we end up traversing all the dynamic arrays for any folio that
> might be located in a VMA that has been remapped?

Yup. But there aren't all that many, and it's all under RCU so :)

That part of the search should be quick, parts of the search involving page
tables, less so.

Also I need to figure out how to maintain stabilisation without an rmap lock, an
ongoing open problem in all this.

In the end, as the original mail said, I may conclude _this_ approach is
unworkable and come up with an alternative that's more conventional.

BUT. Doing it this way saves 30x the amount of kernel allocated memory. I tried
a heavy load case and it was very substantial. That's not to be sniffed at.

In any case, all of this is going to be _very_ driven by metrics. How slow is
it, how much overhead does it actually produce, is it workable, are the
trade-offs right, etc.

It's an exploration rather than a fait accompli.

Cheers, Lorenzo


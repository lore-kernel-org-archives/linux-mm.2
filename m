Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FD9EA7190
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 14:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554956B030B; Sun, 19 Apr 2026 10:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504E16B030C; Sun, 19 Apr 2026 10:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AA86B030D; Sun, 19 Apr 2026 10:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33E0F6B030B
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 10:21:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE6E85A3E2
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:21:53 +0000 (UTC)
X-FDA: 84675519306.12.56326B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB1E31C0003
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:21:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgZjfQmu;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776608512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwCgJVgDgS8kjFgnLxJoLrk3XWjwmw5yA3OG2fq8Q4A=;
	b=GWv6xJY4HSWL4PgpZk4UIJrVPejkAnZ92CUqBAG2a6+xg9ZmRHTj2HvfeWrPPNuBJzFFnz
	V0TG/R2c/glqCizJZC74ie7tuc7PgjhTVm2mqA/5quQuLdXaoybQapZNlKULc3JAwmiMhY
	33j8Mf4ZrfqPXsh01eokKBricgTEBtU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgZjfQmu;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776608512; a=rsa-sha256;
	cv=none;
	b=TIzjeUeg8hR0QLArdiFJfSWhTAy3FC4Ril7MzQlwE6Xp5cxrDdcZdTqENtbCSoazZThfNT
	niMoF2xmeH6/+NQtObjfJZ87Il7/SdWIyPMkN2CzT5SyUIYNKrHR9cb/BW3eQkGmM1FxL2
	0kFCMDA7tNGVgeg5i1syruUIG4hmFR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0E1F400EC;
	Sun, 19 Apr 2026 14:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788B3C2BCAF;
	Sun, 19 Apr 2026 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776608510;
	bh=vy8zGRnstlj61rrK0sLQoTI6DTMaHe3B10THiSTu6MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HgZjfQmuCjHfo1vXA4Ut6FW7Q5Fu8cpjP9A1sgSSBCH0mjrCg6oeeeiTxzkF595Sv
	 w7EA3o9ZSAxEMfJk6oqjpmMPs3Rcc2Gu53eC2NjDw60K64XdCxHfGV07EtFHyJK2E7
	 MBl1j3I41rmgu38MiG07HsDKXEb/I4kuLYsvyM/gnmDGP3JGZH+5fMStYS2mGCcu6u
	 dnE8rEH8Dy0ebd7gvHcCvzIQH31vb/ZsZWtgLiJeBK+BC8VAOYn4UjHULKuaCxLcwe
	 xQ0lGeCKlLnWYdcjkSAj8mZnLLByzyJsrsVwmwE9uWh4ac5hp9R0SLefVjzb3zhLRK
	 zTYfEPufzUE8g==
Date: Sun, 19 Apr 2026 15:21:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeTcdRL0PEg0y78s@lucifer>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
 <aeNP7mtx878gynXS@lucifer>
 <7b983108-4846-46ce-b9f5-2aef319c00dd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b983108-4846-46ce-b9f5-2aef319c00dd@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB1E31C0003
X-Stat-Signature: ukya4c1wu1p5ibnp7pcdcfbpad8pji3s
X-Rspam-User: 
X-HE-Tag: 1776608511-229830
X-HE-Meta: U2FsdGVkX181Zu+NM7ZBYGslCLmsSp8grgQcXF3NKBzHwtnzflSL7KRta7YeLE8dGbZgjzzfS0ezZC4CFT0eGWaJPB7tVcYBBu4qGnRO6mktQQSq1wPigcu7jLAgOAS/eUyGiakclswhSoRK2T2K+ZT2VM9xPwWY/qiaaV+kw4ZDFeV+ewwhE51vnRbZH89rMUZwQkWWPgabVlhlw8oOPeypaTqhFGoW2xe7xUSPmVqIprFn3GlXnVVbkIBiHhuQ80Xw61IzNlMUxCWsMaa7tFDGUDzkelvqL6OZ6fp96ummMjnXb/QVLYadRR8Y61ZIDRKongbtA3/Pb/tPmF4HZ/SR2RU/XDJl9p3SVpPQEpfoaJLW8hZq9MmNFkKJQcIBMyhVZIJf4MeqTsjFExPBXmxeGEEaPG+tRnh6wNdoIcYxSe1ZA2mV3sINfYZA4Ep5oZkhRrW/+pBoWGMxC572chzvEwmt9VIPVHS8z86Xk8vTA3uHJHLhonjnTUkzRrghB9Ymjcj6x1Qi8J35WnQg+P85KMClLfvHSHyno5gd+iq2Cv5r9pg6CCp7HS98tQhdcSJ9g0QKyY5LJ5IZU8iuDhfQh6u2hBDLP0zhWcs6wLXyX36kcqpoie5fvFJg21QZmaLfYvMKpni/0XQnbWJ+IBNOVevcf3X1Mn5BHEVJBB48EFWqjYs364OuA8jIBWniC2drqiOAVteoJUUkvUv6TQY8RFbeiBpAbFR2zbbvLfrS3cvJmf5Om56DLKhG7DbwsHnm1B2EsWEnSwO2u95W6Z/qYne7IBOAKmp5xBk2GjuAdSEi2V1axSHtcoJn7bCHvdFUjf4xvvWe+D1DvTdCerdhONO2RJCfFZNUnMzc53OPlN6S0HS0UMu04+5w2J3XzNuuXsx1b94xxdrsz7syCDJ/kJhYhHY/NkpWarNhPVyJZd50XA8K6HCOCInsBW9BmkdcR43vfcDkZy1UMYi
 wI08uHn+
 HtDYUAEKd+hy53ubXB1f6RCnq0BxXrsRe7GDwXhdVVoQ82GODY6oitElFbBsDEnMLhuAhTyEUaE8zABKszfDJ/z8t0u23/T3ZIEcWgb4WrKmJsSd2MkMsXFo7eC962zIT03rB5MYDAeWDIbTTzoxSkfIeGM3zLrOVd30tHYkHyay12r/hu5xHj3/9iR6fgLresxWV7onXtli+GazQoUBzEdooXHfuXkyDB4RcJYIZQ7mpIseNwUROzpcbX6lF4z6RMDw87XHwtAPox4FTA18LNrzVp96Whd8IHev5c0uZJyZn3A3vlygtMaCv1bXAchNaKdz+s5UsItDk3SbTzzBXy7gafIbrMZmura9uwefuRf73TVqrBw4et5DyOzHlIX3FIBg1QiUz8DH9Glsavw2IEnZTd1mZ/2RqmwmoCsxmUTFlyLQ7rvtzYYhTSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 19, 2026 at 10:19:59AM +0200, David Hildenbrand (Arm) wrote:
> On 4/18/26 11:35, Lorenzo Stoakes wrote:
> > On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
> > > Maybe there was a scenario where we could have lost vma->anon_vma during
> > > a merge, resulting in a swapped page in an anon_vma.
> >
> > Unless there's a bug (and correct me if I'm misinterpreting), VMA merge requires
> > vma->anon_vma to either be equal for merged adjacent VMAs, or one or the other
> > VMA to have NULL vma->anon_vma, in which case we set vma->anon_vma in the merged
> > VMA.
>
> I think you didn't understand what I was trying to say.

Let me take more of a look then!

>
> The reporter claimed that it happened on 6.18. Nobody knows on which patch
> version (stable tree?).
>
> I was wondering whether your fix
>
> commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> Author: Lorenzo Stoakes <ljs@kernel.org>
> Date:   Mon Jan 5 20:11:49 2026 +0000
>
>     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
>
> that went into 6.19 might have resolved this problem.

Ahhh, no not that one (it affects merge of VMAs that have a CoW hierarchy which
we shouldn't allow) but 61f67c230a5e actually could cause this.

Can see from https://kernel.dance/#61f67c230a5e it was backported to 6.18.7 I
think.

ZhengYuan - can you try seeing if it repro's with/without that?

If you're testing literally at v6.18 in Linus's tree say and NOT on a stable
tree, then that's your problem - you're essentially testing a known-buggy kernel
(we always find stuff later and send to stable, just how it is).

Fundmentally the bug was that copy_vma() called vma_merge_new_range(), setting
vmg->middle = NULL (becuase a new merge obviously can't be modifying an existing
VMA).

But, uniquely among other merge cases, it merges based on a VMA not adjacent,
and unlike an ordinary new merge, the duplicated VMA might have an anon_vma
associated with it.

And the merge logic had no knowledge of a vma with a vma->anon_vma to even
attempt to copy...

Therefore you _can_ end up with !vma->anon_vma there incorrectly after a merge.

I misremembered that because my fix was very focused on the direct consequence
of this which was a UAF for folio->mapping (!!), but yeah !vma->anon_vma is also
a consequence of that.

So yeah TL;DR it's very likely 61f67c230a5e that fixes this issue (was present
from 6.16 - 6.18, backport to 6.18 because was only relevant stable kernel).

>
> Your fix stated "allow an unfaulted/faulted merge with a VMA that has been
> forked", so I was wondering whether that could have resulted in a situation
> with anon folios without vma->anon_vma (losing vma->anon_vma during the
> merge).

Yeah sorry all this logic is very fiddly. That's about cases where the
vma->anon_vma_chain size is > 1 i.e. where you are a child of a fork operation,
i.e. one of the 'parent' or 'child' in [0].

[0]: https://ljs.io/anon_vma_example.png

If we allow merges for those, then we propagate lock contention across the whole
of the merged VMA, because anon_vma locks are held across the entire fork
hierarchy, so we intentionally disallow those.

My change accidentally undid that in this one specific mremap() case, and
3b617fd3d317 fixed that.

But 61f67c230a5e is the issue here I think!

>
> But I am not sure if 879bca0a2c4f could have triggered that. Are you aware
> of other fixes that went into 6.19 that could have fixed such a scenario?

See above!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo


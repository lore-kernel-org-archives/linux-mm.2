Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6535C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26D26B007B; Mon, 10 Aug 2026 11:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7586B008A; Mon, 10 Aug 2026 11:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5956B0092; Mon, 10 Aug 2026 11:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB526B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:55:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2111A1401F5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:55:46 +0000 (UTC)
X-FDA: 85085810292.24.CEEC671
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6AE1E40010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:55:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8FFCC3Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOFrt6pX2UwikI+9wqoJfAtsdR0PpzzASBSsjIMcp6c=;
	b=3gsmj3+rHGJdxs0tp4YrjpDJcmJQh+AYtbEPu1idaYt9Hz1Zz7S6xa1UZcHqUpJbD4rliG
	Cy+s0Zg5xBTvOj2M25KyhBwl+zxk4jXa7vfhrSvE35s8YzOuJMpYjpm4TmuM7bdgBRNBKj
	deVUMWE8qftpQDs3lcCqSpHbde65dCk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8FFCC3Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377344;
	b=ncJRi/eXBZeYCYiBPs3iqwfRfPhRsr05dD/maIH8p7WmLdAkni3swR5EbaZrnH/4jfIcNZ
	kNd/YliotU6NjCLiaR0d0EwibmRj7V9lZhmpuv7UoXJlYthhzkz6A7VPjB1fj3UwJgoBR9
	wfpywvN4l/KWAE7UregVdvWJXlaKYdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 492EC404D0;
	Mon, 10 Aug 2026 15:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77F51F000E9;
	Mon, 10 Aug 2026 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786377343;
	bh=nOFrt6pX2UwikI+9wqoJfAtsdR0PpzzASBSsjIMcp6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B8FFCC3ZMPednQD/1EUdyJySPIXs0HvY1XWzQ4usA7MCJQlumC+jb89mgmpXeAl0s
	 ZO4x5YlmLZZVzg2bN5KOkxlHcA7Jt7+hRPovbsgiLTDTo8wRVyCynkuygTFNlt6esq
	 5vgJ8Ks975Isr3s1pmRN5cpLA+NxUOwFX1jgWSjeHIdBV1LkQVymawVsxmCGuGIX3S
	 1YtUXGJ/679syTX6H3pJ4h10c9Llt4bGunQaS/hgtziB1tE/d+VndITjYxkwU3QMcG
	 e21rR4KlfMHeDRitxt8Ia2PDJee/1gTKWsceLs8gerPZbvcfRhuXCJgk9uYABYnrTF
	 m3axSva1t19Jg==
Date: Mon, 10 Aug 2026 16:55:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-ID: <annzcER_eGeBq_pY@lucifer>
References: <anmdrYGVqM-U4vlo@v4bel>
 <anmrTaWp2etxX7Fd@lucifer>
 <annzORC0NgSIsX39@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <annzORC0NgSIsX39@v4bel>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AE1E40010
X-Stat-Signature: rz3dhie4gxpdx6gnkb56cogdgum5i8dt
X-Rspam-User: 
X-HE-Tag: 1786377344-580609
X-HE-Meta: U2FsdGVkX18FJtvrXWa9XdvJv/xgbpLx4SrVPDiWOX6NOb9DyZnBlSNKwjD9yJ/u30491+s9ow6gEy46eCRJepPjc0YnasBVptoeZ4Uh4GKH54bUcdIooedNdRMBvpaUHTGQk28oiYFD5kGLkC8Aocwn3v9U5R+rJNaEtfyggaJb9vSW/paUWVRldOAfhv5/gJ3qhD15hjTB7TCrCR0sOu46wdgSVT/RDJ32zm42tJHz/78/W9ZXJapQveNNpMj45ti/DCcHO4LyJzHjis8HbaVDdFuTkza6KD4NlJT25lKTzXZntwuia2QgQIJYu5F6su1SwMvuAxy5upYawnd/xTPGyjtNvaZOdYZXgzOBUPc+TnR1Xjvt3XGuM/6769DOiqa7UPx4KG2LEEUcvZ6+MZBO38XrPp5+FTRzPbtppuXdJnTEozKAivKu0FPhL+j2bA6kRokv3RMBs+sEOnNWlkOqIzanzfo/LGqoGBJNgdakNVbD2UxjRuhtFp//0uZUPLA4OcwbXLzUPNadtzrXySIRXS+4VOP6CsaLxqLgC/8q799+ANai6wB+HF2gdwRVcv+/wH2YcJYOpfWoqwk13gIT9Uj+0U9R0QUoNxd9KcSwFuFu6VZ2W8yRiYOFJ6H0BtQiwsaVIL50ph5pRc+hM2HNU7YlKvxBI20zL8wJzufl4o4r6ftr7lNc2uxeRdOBQsnCToblNwoSqcd6YzIgkvp/dpJ9SzbM+QKEnKk6+0moypt+UofJ5mAY+qiYcyYO65DwtR7SsiDf9NUQ4+IfA7hkjodzqiyyI6CjhDpbkovJqU0Rffu8GiIX/SDdZkdllesVluFAX9GaX67ms43Y5+yWApUL2k/euaBOQcRNLGDe+SiYYyGl67ULLoykHq5egX2OvGScFRA3m44iKlfXdPzxpSm61LlLHjxegUfBXZpQ7EdJXIkv4rrRUIGSmnS7v+9DhzKim28LmsIo78Z
 +c0T350O
 I7SMUA+WM0bm1HXqyy/RJyr+Z2qlXpTEbXz3atpkdXRAkgu8W+cAHRSOpEYv0JwRBSdI+6RkOLd0uemv0kfT9BeB5c9o9I58uHQ2txfTec4OSeMkUa8i3mYrVXa1ujdv4fwNms0+cXr4djiYkb6Oe6Xyh8O1tO7ejHmrlsvl+EQwfRrnvSktDtYgR1/t09cdZtamMCPZiH73KkZSxJRyr/2ustb2aRLb5DSwVJHI769PL2A69N6wA81JWUrPbo8KP21CzIz2O3+QFCg5+Ynvl2vBD445wzcKOE/uCIzhKbbPQfqhYFYFunuwzmrsI9AYsQtHY+oUI+1dsAErimVXUrKyrvErZP3pfr3W9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 12:50:17AM +0900, Hyunwoo Kim wrote:
> On Mon, Aug 10, 2026 at 12:19:54PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Since it's 2026 + this is your first patch in mm AFAICT,
>
> Yeah, my home town is netdev :)

Ah I see :) well welcome, this is regardless a useful bug fix so it's
appreciated!

> > So it's only if you're at the end of the PMD range that it's a problem
> > right?
>
> Yes, or more precisely when nothing after it sets walk->action = ACTION_SUBTREE.

Yeah I word this a bit better in my proposed commit message :)

>
> > You should say that.
> >
> > The user-visible problem here is that you can end up calling the callbacks
> > too many times which explicitly breaks mincore.
> >
> > Given I had to decode this it does make me wonder if you fully understand
> > this or if it's just unclear language. This sort of word salad is very
> > LLM-ish :)
>
> The commit message was written with help from the lovely Claude. Not the
> most readable, admittedly :)

Yeah I did wonder :)

I'm totally fine with using an LLM to help with language, especially if English
is not your primary language, but obviously it can go... wrong :)

So will always feedback if the commit message is unclear.

LLMs seem to have a habit of constructing word salads that end up effectively
like 'the code in English' which ends up confusing more than helping.

Key thing is keeping things as short and clear as possible.

> > Is it possible to add a self test that does something like this or is it too
> > racey to be practical?
>
> It looks quite race dependent. Triggering it deterministically would need
> some of the race window widening tricks from exploit work, which I don't
> think belongs in a selftest. I can still write one if you'd like.

Yeah that's what I wondered about. It might still be useful even if it's racey,
as long as obviously the _test itself_ isn't flakey :) and also - it can't take
too long to run, either.

It'd be good to have a regression test for this.

>
> >
> > >
> > > Move the reset to the first statement of the loop body. walk_pud_range()
> > > has the same shape and gets the same change; walk_p4d_range() never looks
> > > at walk->action, so that hunk keeps the two functions in sync rather than
> > > fixing a second bug.
> >
> > Your commit message doesn't mention how you discovered this. If it was AI
> > suggesting it (whether locally or sashiko in reply to some review) you
> > should reference it.
> >
> > If it was simply hardcore code inspection then you should say so too :)
>
> It was found by accident while fuzzing a different subsystem. Either way,
> the fuzzer itself was written by AI, so,
>
> Assisted-by: Claude:claude-opus-5

Ack thanks :)

>
> >
> > >
> > > Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> > > Cc: stable@vger.kernel.org
> >
> > This all seems right.
> >
> > > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> >
> > The fix itself looks right, but you need to address the other feedback and
> > respin (also please send a respin with at least 1 day's delay).
>
> OK, will do.

Great thanks!

>
>
> Best regards,
> Hyunwoo Kim

--
Cheers, Lorenzo


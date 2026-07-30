Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC545C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E626B0088; Thu, 30 Jul 2026 05:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F216B008A; Thu, 30 Jul 2026 05:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C236B008C; Thu, 30 Jul 2026 05:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77F646B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:16:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AC93C0882
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:16:08 +0000 (UTC)
X-FDA: 85044886416.24.7D4395D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C7C8C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:16:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVdEWTfJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bz6gqBZys13PKDunxTULuH7UZpx3kjE3gYICcLet1Uw=;
	b=yusfg3NUYb1kjZ6Ack2QCPukY67w2bgRTNLVkZb6crviUzdvJ8smPAlzCSguejGUX4G94H
	4VOcDD68BI5cvuvDUaLjeVHK9GIvyYO4AM2knLkL1wDCKXfAIfknRy4F9/N5tGXu4bi6kE
	8kr5/1IAVbTbF5SeU8Sp0dZ28dDS1C0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVdEWTfJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402966;
	b=DJNV5moscg1BNdlGpVS91Sd6gxtQGp6I3cHI8vgAaSbUovZAONndPYYRsccctzOWBAvyaJ
	9ON+znmrDbMijyJ96jDK+qX8n352qv0E4CUUDKf+SM1UBw1V0lFG3c0NBEkvc8kx2DmP+V
	+VAD3WcGmRw3zLwngMqByMrOpZ6uWKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD56E600B1;
	Thu, 30 Jul 2026 09:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B91F000E9;
	Thu, 30 Jul 2026 09:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785402965;
	bh=Bz6gqBZys13PKDunxTULuH7UZpx3kjE3gYICcLet1Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fVdEWTfJVD/GakEcmYxJaNiudilKkG3cDUlakYPmzcgqsAxWrLwiEozNQsmDoJzC0
	 U9iGOSsDt7rDQP5RkxFsjX81Zwt1cjzc2iG4vE2tbSwxWZFrc3SPcV84EfbyybaFCM
	 MADr+ITHP7LeZlMYcwR8HBVjkIs5oq4fGbk7XucAEZ8LcwZRJgxSWPw3hmYmrxkIjs
	 c1yoTWiwtK3MGes9EOHp2rBRdMwq3qRJhhSk7h39QegKqYmomqqJ8GRr9v06kmy9Kd
	 /hQZ32/lW0Jn2A6Y/uLqKeWNsr5MRvw/LaVeHTdrIlo0XeZQiAMToh3jqfxQ6td8hr
	 PHqvvNi758Tig==
Date: Thu, 30 Jul 2026 10:15:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 0/2] mm/huge_memory: fix huge_zero_pfn race
Message-ID: <amsUw6_DjKRg3gJq@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <f0e39f91-8dd1-4d9d-8d4e-da5d608a7148@kernel.org>
 <amm2GOFablLbBC4H@lucifer>
 <773a043f-e135-4050-9ca1-0b5190f03ec4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <773a043f-e135-4050-9ca1-0b5190f03ec4@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C7C8C0009
X-Rspam-User: 
X-Stat-Signature: crz6hw79ijcf5yp81efea48awzy7u1ng
X-HE-Tag: 1785402966-681995
X-HE-Meta: U2FsdGVkX1/VtxejJ1/V8JVEyr4Zpjg1KFJJx4OXd5gzMU1e/NXnhpRfkjk0RNrc2wmoNKDnQ/eD6KJBEKXnuQPe8lMIdstS8Pk4B+jzl2v0HoIyukQKwPADXnQArF9a0wrkGUE79m8lobWRnXl260o5ix7S11DZjCg6Ibz5UiKTmZT0CYB+iX0dehKIsxFR4oUz9resUzLjFHG5HQvGb4MVEm69X2orVFdBbr0tTnzeQPBywJM5UyZZUn/hsi5mPSaDnAkdzHcynYCPw0H8u62uJ3JAcCDbjEqeX7gNEBrYlnX9TDCCBgEvK3Qr8zq/09fJzSOH/Gde7Lk34w26hWLsB8GlOBiTkaS2vTtL5PA9i5911HVYTcnMSTzqSUmmUJlG5ixlxwSQun6C8T9VDVviJYDJ9O3R8qD/SauGil/q5Cnvo3eqYatXLYvwfpRP3UOh6yzjg9RHvydV0d6UH3PzZFvJbpPaZuqXKXQ/PDXvkIqRpZjQ8vnPC8zuoBPF2mLItN9a3scNRyQX1sTYHPm6MtsVMsPk3qqgJxjbdV37yvxRXVfMDkLGM23avN5sSlEl/DTqdxKDqdUG2XEgJlUxUmnVjsufwqYNGgKiL0/u4SF8M35eCgpT7v9fl7XOOA9u/hz8ja0Urkh01chJ+7WIvu4fgocGtBlM4vNzEKna/OGahhIi41WwWpd/kcZIsWJ27JaEOtZj33OEDUX73WbUHyzDGZlqbweG1qDe9QbioVOH2VN5HqxPceThxP5p96F00ICCg1m136I+ZTicxNyx6Mur4ZzO9hZSnBqJTbJYMLFn7UJ2U3Ek3vprfEl5AFWHthQBZM7C5EVcwB8A12pIx727gW2KyoNZchHd8oP+ebs4o6UMo5knwrKnJdm8LDn+fpeCwXjuweAtW9qkReASt+7As+mq3teSQ0f2N/52PSe3cdph2vs9t39PwkRW+UONU6Dz0vAlpdwE+US
 fJ0WJZrb
 KMvhkZZVHqq26FT5bY2oehIUgTz9niQwA5Bl3d0Q2dw/ANDz88N5m2oUG4Ob7nC++QVN7GyvMw+EvWko7qA1y+5tC4u2+UmJCxXON/afUUd07OpXx10N57rC2g8qWcQbCziido7eKhsyDwHZZyPiy796Qagzin1B365edVgRpU4h6zYa3TR7FKh/9fdpL+Pm0CcCw9Gr48HsMhxRTAP2nJmInmPMO9sJcWDVOcIokYh4MVE75attQg+nFcgSDDxHNYNHH2rnPY1Bl2R9X63lZqO/4O0fQZQ5gUTv0z1lBLAv4t80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 11:05:49AM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 10:15, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 28, 2026 at 09:02:57PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/28/26 14:05, Lorenzo Stoakes (ARM) wrote:
> >>> There is a subtle race in the reference-counted huge_zero_folio
> >>> implementation.
> >>>
> >>> The fast path atomic logic fails to account for the fact that the
> >>> shrinker (which drops the final huge_zero_refcount pin) can overwrite
> >>> huge_zero_pfn with the ~0UL sentinel value in shrink_huge_zero_folio_scan()
> >>> after a racing get_huge_zero_folio() installed a valid value there.
> >>>
> >>> This results in huge_zero_folio being correctly set but huge_zero_pfn being
> >>> set incorrectly and thus is_huge_zero_pfn() and consequently
> >>> is_huge_zero_pmd() will misidentify the huge zero folio as being an
> >>> ordinary THP folio.
> >>>
> >>> This can result in the huge zero folio being split and otherwise treated
> >>> incorrectly.
> >>>
> >>> The solution to this is very subtle as there is an atomic fast path, and
> >>> thus ordering in weakly ordered architectures has to be treated very
> >>> carefully.
> >>>
> >>> As a result, this series first reworks the
> >>> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic so it is separated from the
> >>> refcounted code in order to make the subsequent fix reasonably
> >>> understandable.
> >>
> >> For at least somewhat easier backports, can we reverse the order?
> >
> > Since I'm going to be doing the backports can we keep it the same? :)
>
> I enjoy reviewing small targeted fixes (also for backports), so I want to
> understand why patch #1 is required at this point.
...
> >
> > I can figure things out for < persistent huge stable kernels. It'll be manual
> > work either way.
> >
> > (It'd be good to get some review on the actual changes also :)
> Sure, will get to it, but I have limited capacity.
>
> And I have more capacity for small targeted fixes :P

The fix is small and targeted, it's 2/2.

>
> >> The spinlock+proper ordering should be possible without #1, or am I missing
> >> something important?
> >
> > It's possible but this way it's a lot easier to deal with and I'd rather keep
> > things consistent for stable kernels.
>
> "A lot easier to deal with", can you elaborate?
>
> The shrinker code never runs with the persistent huge zero folio. So that is not
> a concern.
>
> So it's about get_huge_zero_folio().
>
> But there, it's simply that concurrent races are impossible.
>
> Please enlighten me.
>

Rather than debating I'll just drop that and respin.

>
> --
> Cheers,
>
> David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66523C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5086B0005; Mon, 29 Jun 2026 05:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EAE6B0088; Mon, 29 Jun 2026 05:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8B66B008A; Mon, 29 Jun 2026 05:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84FED6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:37:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC57B140604
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:37:52 +0000 (UTC)
X-FDA: 84932448384.26.D4A5E1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E26D180003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:37:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkDD6PeJ;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782725871;
	b=sRvOzmWhVdDf2smR46SVkH17Wj+p6plpFE7SOIKlMb157sKq9mmXa5aXDatPubxXjUarck
	+1J8H1wMQRKzbShhq+5YYFvZQAztzd63b2j+vOr6HLCu5JAn32Uw8Z/aB7CzyEQQ2pCA5o
	WDKHGEIuaUrFOgYo4XzDQuJLD4G6YMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782725871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ykDqQthUIfZEJ7dIbtthe8frR9Jp1b202KOCImO0vA=;
	b=pzNK29QX+7VivhTPuZcu6bhxkbo4R/+HIAuJ+Lfk/EffKfMW9p6M1+PI+WwGml+eoy2Dmp
	X8rrjl6jGfCRUa4qLihgC9QqqDu+OyY/1G1kuZq/oCf0D/l/Vmgcj2tY7SAcBrz0v7mwIE
	Gt9QytuQccO9X0fiq3N9HQ09dNt5NHU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkDD6PeJ;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FB9243458;
	Mon, 29 Jun 2026 09:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5001F000E9;
	Mon, 29 Jun 2026 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782725870;
	bh=2ykDqQthUIfZEJ7dIbtthe8frR9Jp1b202KOCImO0vA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bkDD6PeJBe0Eiz6yk4EBHTxFLSR5KVzPauMT7cIQo/w8NK//QVEAr3DqMsXywZGNk
	 TwFeTDqwgMEYIbg5ULaaOX2gu+k7PAR8HEb+vTadn8bKdJGTWhDH8cEjvCiHyNwH5Q
	 KI8Mx/1EWTD1XzWut1Gww3uSF52+pWqdKaihQj4ePwFCm90bEXHBDAXe2lhz+YwNZY
	 ccCCHn4ZESIwb9hph1uKI1qlrtdQ2L9WTQIN7GZHeu7rAJxQw5fIDS7URx/Df3c8pS
	 YF42SlHCHqOukeANTh8vaKslqZdxtTuX7CqZb6s9QNw4nE+cehWl99n2yV9ZKIqYlU
	 U65ltqXwJXG0A==
Date: Mon, 29 Jun 2026 10:37:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
Message-ID: <akI8lkVb5CICUcWi@lucifer>
References: <20260627195630.24519-1-sj@kernel.org>
 <e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org>
 <2vxzo6gtk89r.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6gtk89r.fsf@kernel.org>
X-Stat-Signature: 85boeewrbaj3timo9mtc5515ziebgknz
X-Rspamd-Queue-Id: 2E26D180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782725871-567013
X-HE-Meta: U2FsdGVkX18Inh9mAWKE427XR8XhKZsXY88gUJ2qIWCBITPFhQaj4hwS0GGSjXuk20NpSFlDJWeizMJzccA6VwRHW06v1RjtbI3Jt3BRCjev7Vl2Zcw2Cu9uifAahjhC9otVs7p8UiBvYnGljyyAZ5QmojAHymXl3bx6wMuZgCMbyQ0Do3pqYCpPvPjcNKxvbAi3eku2kFfxAsUWeTzyALY95qWRl5vPPnnxBuPWqVA/kFfc3VztB9Tn7FecDvZ2/tClBX93WkErV8Y483wG+coSmorKYaUgC1QuhbVgq67YYgm7yk4sWULcWK83mKXYWUp/fkaDPhPrL0qmiO97ZMPM9FHFavWmskL7W+T3B4zRUTFLNO89XlRFMxJca5NuibYt342+tN8LkmGdRncoKLg/8JOB6v8hPf54/aKIj06mfwGXBM4LmsGKNK/u6KhiAfcWoblhv+3Y9GmbwgQQt2TbmiW3gXGUMMUkVJwjwQJrlwa27U9ir5BYbcVZuFKStfeHxWfjKtoe1DPhSSlEQcN7gWpBMobBjNbEXYVFNW6bRBcYX81IL2bzoWvqyrKO0LgBgXA69ObcU2RrNFLOFY97zek/rbHTckSBW0jHlyOkQv++s4h5jECWJjg6JLum3I9ff3Jl3/Y+OUZjJsaHHeaUdx0PY3v7XoG+VLc11rxsZ9yYlOLtgVOYakyOv/InuaivRk+32PFubo1kXlTA4suGIKtXExRiQBZhQujpAi9Dt/PKTXcxdMUQfs6Mc2p1XYouLA6kSBl2kqeWo+jUcZ7rwKy3489I+q5l2IWsXn481lpaUGBzDRykXXapXdnFlmdrkEDXDL3mk1L4e4Uu2hMf2fC/BbdQ3V0w8mLGEIn0mrJjlWI56y/dgjdU7M4LPr4ymgE4uRle31AsB51YjFC7dVUo8lBK7b1rB44tzjf1VAVP/mUnBw4+iNa7TrEGPfI9qf1vxtm1XaZmKBp
 yrrbvUKq
 dB/s7rKKClvvNyCSOqntEjbxwY3+zMByyVjubfjkqCTD2x+pARuI41PDwLTKfnseYXVWCEvpXJns4A42WPEfP+78e9JjHPdSDYaFIXq2O4ZnC5+4E1g82Gx8ZtLkld6q9Tn7KxNLbLEzYqO88eLikjl/S7PdfXSA7zT2ZeYgox6tN0PmxchVr9cCUEFUtu6dK2GSoOsHOYWQq9niulQu/zuWFCitTW7JePvkc1kgp7ox8oOizw1igwm1XEO7ZzrnaO+uwfOb+tQYdV7h0Ou07nuNBoCuxufkWCeqLxnb2jdyt9iFohdnbX+6/PWypdRs4rb7/7KDTtoNfyIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:25:52AM +0200, Pratyush Yadav wrote:
> On Mon, Jun 29 2026, David Hildenbrand (Arm) wrote:
>
> > On 6/27/26 21:56, SJ Park wrote:
> >> My legal name and preferred first names are SeongJae and SJ,
> >> respectively.  I was using the legal name for commits and tags, while
> >> using the preferred name for conversations.  It sometimes confuses
> >> people including myself.  Consistently use the preferred name.
> >>
> >> Signed-off-by: SJ Park <sj@kernel.org>
> >
> > [...]
> >
> >>  #include <linux/pid.h>
> >> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> >> index 1cfb8c176b873..fcf7c7fadb5fe 100644
> >> --- a/mm/damon/tests/core-kunit.h
> >> +++ b/mm/damon/tests/core-kunit.h
> >> @@ -1,10 +1,6 @@
> >>  /* SPDX-License-Identifier: GPL-2.0 */
> >>  /*
> >>   * Data Access Monitor Unit Tests
> >> - *
> >> - * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
> >> - *
> >> - * Author: SeongJae Park <sj@kernel.org>
> >
> > Just curious, why do you drop the author and copyright information? (can you
> > even drop the Amazon copyright note?)
>
> Off topic, but I am curious how these copyright notices are supposed to
> work in the first place. From what I have seen, the person who creates
> the file normally adds one for themselves/their employer. But then other
> contributors who make small/medium changes don't add theirs, even though
> they should hold the copyright for the code they added. Bigger refactors
> sometimes add a notice but that isn't done consistently either.
>
> So do these notices even hold any value? They certainly don't list all
> the entities who hold the copyright to the code in the file. Only git
> log can tell you that. Is there even any point in adding them?

It strikes me as a rather loose convention.

I am not a lawyer, but I would say that individual and corporate ownership of
code are implied by S-o-b, not by comments in files.

Certainly there's not been consistency on this!

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

Thanks, Lorenzo


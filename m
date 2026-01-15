Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63305D46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5636B0005; Thu, 15 Jan 2026 13:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3C86B008C; Thu, 15 Jan 2026 13:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF766B0093; Thu, 15 Jan 2026 13:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E28C6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:05:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01A8C13B006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:05:05 +0000 (UTC)
X-FDA: 84334974612.03.094A10D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4B72F14000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:05:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UgfXRr7k;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500304; a=rsa-sha256;
	cv=none;
	b=vP/bI0Glm5YRU/wSwBarKLbbV82oY5jIlG8QlVm5wSUg5+SaxlOTMDGsh177Rvq8ql3OWf
	DKkX239fLZTRhAGMI+qxbnqU6VGcAXO/WLnT8u2WvPUV3KKQNfF1PPCTKymX6vtmQ5nY07
	3z+knggCIAAXEz7PuEqxmyDAd8OzlGA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UgfXRr7k;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhJLzuuVTOG4qRRFtbdwXgUjrXeXhvHaYW4Oj5Lwa30=;
	b=uCoOX5CTO/uqwHpHQT1AP1IxLspjzL619NQUyo3ZtF5TYCgU/b1CLk3PIFeSUGDGGs9+/S
	VWifGLD9jrTh6hepCdho1iEmIGRXVyCwDiAgPPE9p0srPlKzVRm1Eo/PUcX3no6weinIDC
	bBGJVlBd7WtPQSBj9zGUhXahgh5+Ol8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87EEE6016B;
	Thu, 15 Jan 2026 18:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF66C116D0;
	Thu, 15 Jan 2026 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768500303;
	bh=6RMWVQuyYm4C0LwDw7pTQTnW8LsYa5O8RN8wtoU7GUU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UgfXRr7kNJAlXibce6ruwyzAGqd8zPeDptyXrQLUgHymqRkTH0C1D8Oi5WNl46lH4
	 8qLdRDiByN2nxgyMDvwei4BPZrxxDk02OHj5baKYoD5Sxf8S0aVfo+seJ4C2Chd+uF
	 Ua7zODpxIPIFgwQOHJtfAbMuALXerFlAPOg9bokA=
Date: Thu, 15 Jan 2026 10:05:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Peter Zijlstra
 <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>, Prakash
 Sangappa <prakash.sangappa@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
Message-Id: <20260115100501.2b956d74aabfe142d37aa608@linux-foundation.org>
In-Reply-To: <fa37f15c-e5a8-4502-ba82-c077ee7b8e5f@lucifer.local>
References: <20251223214037.580860-1-david@kernel.org>
	<fa37f15c-e5a8-4502-ba82-c077ee7b8e5f@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B72F14000C
X-Stat-Signature: n5rx7tx78dsn443hmzwxp58hr6kmrari
X-Rspam-User: 
X-HE-Tag: 1768500304-986123
X-HE-Meta: U2FsdGVkX1/bqFLfVXWCcqWptxlxVsPJFkTOKukDJDdqSDVX3Qt3EUItgJejdpnunWJ7a8xODj7AgfA47ijrt94rToG7ynvZ3zXw2dTYMEFLTOV5qmtv/w/kuDSmN3oJrOHH+qTlsncHOL1NmWg2LKgYA3pElzt5+1a2Wwl+mieOUWsnb4ku99IFhszVFrIVPzlfvQj1MgJCmMdV+qm80gLHNAS+gC8VEzPsVUkaFiIsBJf1PUO4Dkv3BR+7caLLZTS+CnxVkMVQJRqouo04E5oT2BcuyODEzIxzNDCT060+8A2z7uEVDUzvLe8SCp5zzGnFE3yISvuNx0Tjh+I7n6J6+SrDLBIjXvxhzjtLMe03crYk+9NapaO1p7BwM6mlc/rDpLZJRy8ZOgT4LJMBBeVwuI0V1rz9tp77iTm3Z3IarwQlJjuK3jQYU3uUH7qgxU1G8wsNqh2nWn9vU56IoChvA1fVmxUPcSJgXXODVZUeybyUqwRJtLwoZJuqwjDoXCAZco1H7t47to3pZA1Oj5Z4648RPllrqBJ+jkVhMCgUfoiIjbgoYB647lezIShgSmZKP8h0BhxTwE1wIEbWc8ulEHZvzrg4NjSVvnt4n2Ps8W0uSioxYyPInTzypGBS95uTK3Iv5tdFOSFlFIbRG58W6bbbQryS8FOA8thlcTAyQPqcCB+z2X9biNVxdrq9kTGclbXxY8Cz8t+QpvZMkWtAqSGsw4NrbGfAS4/JfdQd+M4iB2Uu1deAwWC0YolQatLScvNXOC+zyTeC/IDA9+cVMvS4S/wh9kYTh7py9I1FjO0kTu5J9dvY9UqWpr8cvusVnHa1SLB5xMn34Htr6qEmKdc5M1tDOrcaDfvtPe7pPoNV7U1jcwixtu1YHDLSWSR0Cl6HAG6rAqkEVVxIv6J8RZDzGN0sHmWoDoVyqXth+uot1hlsYmgtDioXtWKSjUlusPr3EMgjvgpGjRw
 0LD57Lpk
 9bLpamhZ0KoIm9TZpb4DiLd21bBw4Q39hevyoriXh8dp7c/F5FgXaZb6RVKEzuL5FMr4r6kmGIT+3qFLVx9Bb93lGp6xo6ZD0cT6zlDm66YLY9zP79Il84hxigJixMDUG5NUheRK4D94inmoO27KIV/1yE0c1lHUZNyeyQV60SCPZPfZbvClYzEOnnV7bTGvM83T2THUXBOk+po+z9n5H5vmFJnz+Xo9KgCCEWPqEmiIMamhAouGgvu5jKnXKV23e38k1naSq8vKVjaRB2Is3+F3rYhIfSVOYS8mqPcZeBnBRtu/rcOXNYxh5ilGcNv019VkBI2TGzB6ofoyD86+M/WwvJrJDJsF4HJNpGPWB4MFuHye4vQnkwlJvHEwQVCre2Utlmy941rUQFf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 17:22:30 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Any update on this series? It's a hotfix series and I don't see it queued
> up anywhere in either mm-hotfixes-unstable or mm-hotfixes-stable, this
> issue is causing ongoing problems for a lot of people, is there any reason
> it's being delayed?
> 
> It's received extensive approval and testing, so should be GTG right?

This has been in mm-unstable for a long time.  As the series had a
mixture of cc:stable and not-cc:stable patches, I figured we'd merge
them all into next merge window and let the -stable maintainers figure
it all out.

As this is more urgent than I believed, we need to figure out what to
do.

a) Pluck out the two cc:stable patches, merge just those into 6.19-rc.

b) Merge all of them into 6.19-rc, let -stable maintainers figure it out

c) Stick with my original plan.

<checks>

The cc:stable "mm/hugetlb: fix excessive IPI broadcasts when unsharing
PMD tables using mmu_gather" has dependencies on the preceding two
non-cc:stable patches.

So I'm thinking I add cc:stable to everything and send the whole series
into 6.19-rcX.  wdyt?


Also, David, where do we stand with

: I'd love to get some generic hugetlb testing on arm64 and powerpc,
: that do hugetlb TLB flushing stuff a bit more special.
:
: I'll try doing some arm64 testing early in the new year myself.

?


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F1DC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2466B026C; Thu, 13 Aug 2026 06:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91E46B0274; Thu, 13 Aug 2026 06:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD06F6B0276; Thu, 13 Aug 2026 06:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9176E6B026C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:46:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16D291405C9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:46:01 +0000 (UTC)
X-FDA: 85095916122.16.1FE979D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6233A140006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:45:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSsOJMIn;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786617959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3ZT8E7hO3bd7VzvapxR7vDSSiOWry1NDeNwNsSPfs8=;
	b=BEJSUfgVVPNyiBfXMNbuULBvM8DQynb3lfZeQ2IG7tVuS/zrrcKS0dsrTxVvCJSeDWqe+v
	/oL/zov1LbkRHzZ/oo+GHDKvRc9aRWdQNnwwJwL/QidTsmnvhuufhc0xs/4VkUllXNjThH
	8JxizfceG4fKT/MNWdk6UghoX0snHgg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSsOJMIn;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786617959;
	b=K7DLuWXj0uVYnsFnBTNK4tl1RGQODcFg3MBPSxaFac6S9iqGSu/gkD2wlt+ZB2zBj3OdBu
	SjAyddJjOOksXMGNufbvLgieCgPIz/L87HDVoC+KVkQ5/lEZWwcF9RoBAd0inmmA1tRwOA
	dVjzJLMSAL8nX7Z6GXN2uffXn1tdxGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86C5D4078C;
	Thu, 13 Aug 2026 10:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE3F1F000E9;
	Thu, 13 Aug 2026 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786617958;
	bh=k3ZT8E7hO3bd7VzvapxR7vDSSiOWry1NDeNwNsSPfs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VSsOJMInFBGIFRG0LXurwe7jOywCBja5t41egKLBUhAp7aS2DLGX+oPmHUrzbJBl4
	 PbcUTFASInRFlRz77x+CHY5UvMReAnil2f9aHwRdHdzgH0UiV5yng1vw1mQ7vWY8iE
	 jfhaGGQxQDjWnJg0NXqGn0araFADV+vqS8/Za6mMPcJiTMaiX7mKFpOjsBGDlOCGXa
	 CJLnHvhe+n1swRrmVDRgbccdZpPJngOSSHv03+UARVfh1qTdZPmF4DAN1nrDlAMQvW
	 hhl4LgQewSVgW5tLmnReIf3VlLmGq4Mn0VcNOGKTPvVQKDB7OccB652enQ0hX2nlVm
	 jX0hcadxrAuqA==
Date: Thu, 13 Aug 2026 11:45:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, muchun.song@linux.dev, osalvador@suse.de, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, peterx@redhat.com, usama.arif@linux.dev, 
	willy@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
Message-ID: <an2ddJCknXARt3ej@lucifer>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
 <DJMS84Y4KYDY.26GNQPOZ6G4L7@nvidia.com>
 <89837004-b5c9-4b59-b795-3b79005379af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89837004-b5c9-4b59-b795-3b79005379af@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6233A140006
X-Stat-Signature: be4qaw1eiccika3atbedoqmsmokg7q1s
X-Rspam-User: 
X-HE-Tag: 1786617959-557844
X-HE-Meta: U2FsdGVkX1/ej0xq1pi6Zjd0S26F6NRtK5UavncMe/sYffeKu2UAc1UWoWPQulFGSHA0Ykl19RDa2zemMlKEyYHq23853mzBHhgZrFrkA7+T0dpGGUp+5uS7kCPfySZltDVqexz+4yhyJWy5oecvzhTCCKSLN60IvUcsn+yaLPfIaCx9vASt2MKbyOD/ks4qJGl4AAGgL9cqZlQzrCCj7jVo/Nmo0wwv3Y7v1C2+qQjIAZgp+LToLdwBJ/81L6FN4PQafs1n68gbRZi0YhYQzLTbQ7dqFNyvYsSZ4sj0HtHME4m+kgA72N+L2fTH8qVwaw5halyLHrQa+QtDWiFxz9waGqdsO6ERjf6oiOk1mAVgNunxd4MNMzSGDMOm5cKyvkZyDL6Ymap7lHGh1PvzUe+vMXlT56S2uMU5UHiAVU+GLr5qTXDEmnkYLPOS767KgFSwdO7qpurO9sITLdncj0NkyzYkBmKlxXUQOHMESk9Ra7LfhNQfzAPQPXdTY7OxZX5AVdudAB+ZF6b3O6r6WxZ3HVsVzMxuvDSN1jhCX9gaSuqh+PWUj9NCkDVPva6W9o5/bo0kOs4j9CU325pL4n8XUMzO1vZdpqkrdQApnYG/os259j1BFt/JVIDfiUEVcPqXMMcT2Rnh4gigJqtvvISAwRK0lg1z1CdCM8c6Q7AtgRtESkycdpnktIKfkVivWdk+IeifOY0obNG/GRnxZwQZomqmlxgvHR/LbpLgkE4MBOTAmPuzPpIXMIxGkL8/EKPRhJO/xZaYx8Mxpe2E2YqKAH1OUzvMl8DIezCl9JoNe961vfFQHZ7Bak8nEfftguQgHX7P4KPhBtOUADj1EkhdgwMlwSjdNFpFz0RwIlbuDnhW1ExJhok/Lyqd5hGMc2BQ+Bxa609c7/bvvsXK97JVY5SP8YZHyLuMNW37+p6wu32xXdup+1EGwt7iqynO+yWzesugGhaZTBM5IrU
 sJ85mYHB
 evaMzTuFFS+i5fPw3UJNQVx43qEYO+6WsSoNdq7EoHYJVx4SkrLmMNj8NS8dns4mGrktP+H2ssyyb07ucT96aO9n+OBGJeVVVyKSwh9pKlF/DXsPAmIwq8V2Eu2ThN2+bpO6E9QIaBkkOF6igK1YhDxWvW5cavhXYjmjaiPPflWyVMDyifSuJ9RhzlhvZ6bRTphClxpFXPC5Cdx3p8qCiVzVPxokeXYM6E7yOuf04fEeXZ3DUXQ9z2yDFvaN0TBopjTbP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 12:00:30PM +0200, David Hildenbrand (Arm) wrote:
> ... digging through old mail.
>
> >
> > You mean the reservation should be done via some file handle, like
> > memfd, so that it is easy to apply memory policies to determine where
> > reserved memory locates?
> >
> > For existing hugetlb reservation, there is no fine control, like NUMA,
> > or cgroup, of the reserved free memory.
> >
> > Is that what you mean above?
>
> I guess, it's all tricky. hugetlb reservation is a mess. We better not make
> similar mistakes with THPs.
>
> [...]
>
> >>> 3.6 Remove Hugetlb
> >>> ------------------
> >>>
> >>> Once reserved THP can completely replace the existing functions of hugetlb, we
> >>> can gradually remove Hugetlb, leaving only one huge page management system in
> >>> the kernel.
> >>
> >> I'm sorry, but no way this will work in any reasonable timeframe unless you
> >> mimic the exact user facing ABI -- and I don't think we'll gain a lot that way.
> >>
> >> I know, we all like to dream, but this just isn't feasible.
> >
> > Based on my understanding, the key takeway is that we want to have more
> > control over reserved memory, where to get the free memory, who gets how
> > much of the reserved memory, and more.
>
> yes, it's all very complicated. Slapping on some MADV_RESERVED_THP is just
> entirely the wrong way to tackle this.

I agree with David that this series is a no-go, and there are many levels of
complexity here:

- What does reservation really mean in a context where any process can indicate
  desire for THP huge pages through MADV_HUGEPAGE or more big-hammer-ly
  MADV_COLLAPSE? Let alone mapping in THP-aligning file system's files or edge
  cases like DAX or soon, huge pfn mappings once I do that series.

- There's no sense of ownership, and as David says NUMA makes everything more
  complicated. And that's before we even get on to memcg.

- We have a flaming trashpile of a codebase that needs improving. There are
  (thankfully) efforts afoot on this front, but big new shiny features are as
  far as I am concerned on pause until technical debt is paid down _anyway_.

- We have a flaming trashpile of an API which we must keep intact despite it
  having many contradictions, edge cases and points of confusion.

I mean the list goes on.

Also it feels like reservation is almost throwing up our arms and giving up on
improving compaction which is part of the problem here - stalls have been seen
in real world use cases with even /sys/kernel/mm/transparent_hugepage/defrag set
to madvise let alone anything else - and I feel are part of why people want ways
around things.

I also think the idea of reserved memory flies in the face of THP on principle -
the 'T' stands for transparent :) but in general, as David says, hugetlb is a
horror show and a terrible maintenance headache (look at the recent hugetlb hw
poison stuff for an example of this), and mimicing anything it does is already a
dangerous road to take.

As usual we keep coming back to the same broader points:

- How to control the resource that is large folios in a sensible way that allows
  some semblence of control over this.

- Do we want to give more control or be more automatic? How do we achieve a
  balance and what metrics should we use?

- How do we even accurately measure all of this?

- and let's improve compaction/migration :)

These are all bikeshed-able, lead to endless discussions and I think are
fruitless at this stage - right now we have a mess, firstly let's improve that
mess and establish some foundations to build on iteratively.

I am really rather against big concept stuff in THP to be honest and more in
favour of small, incremental _improvements_ to what we already have.

And feature-wise, 1 GiB THP is on the horizon and as David says figuring that
out sensibly should be instructive.

But notice that Usama has been providing various foundational series (like the
huge swap stuff) to establish this.

So Tl;DR - let's be incremental, cautious, and improve this damn codebase before
we even think of larger changes.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


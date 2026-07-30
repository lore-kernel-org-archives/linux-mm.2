Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3726C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589DE6B0088; Thu, 30 Jul 2026 06:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513006B008A; Thu, 30 Jul 2026 06:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBA76B008C; Thu, 30 Jul 2026 06:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2E46B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:07:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 832C5160902
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:07:00 +0000 (UTC)
X-FDA: 85045014600.26.8E29FDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D6F8B1C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:06:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/APtpjF";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785406018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUei0lD/EDb7h2v7ToPNN5nuFxLeREbeKm0rMZyUnpk=;
	b=dJvL+zuaNKtt2DD6xdw3KJIpXXDWi+HMlu6LWreUV2AD3ZMLH32D+aLDZUlE8BFksDKt9n
	emkFtdgjqI98nJqDpzpXD7H3UKQsoHsd73kCe0JwkENAZ1axpcZkKKPk8Tbr+jp5UveBdu
	trKihyrQYvlQ2cFurXcrYsF4dl8dqkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785406019;
	b=ZSsPKsXtOg3DpqgoflJvO4tJym8ZKe6ZcNDHGXJHlj7FGHIrXxJFXi7IyTDDwAHpqNKvlw
	FYAP15/gKB8GFSiDlisBnPH2Tu6qXQOjHFQQqcWHNgbNdQICxDodjRdTWbONBerQ9Qik6r
	wlAcIqV0zHL2ud3UTCIJ4k1MWMVovmc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/APtpjF";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD6C1439DA;
	Thu, 30 Jul 2026 10:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E0B1F000E9;
	Thu, 30 Jul 2026 10:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406017;
	bh=UUei0lD/EDb7h2v7ToPNN5nuFxLeREbeKm0rMZyUnpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/APtpjFfiUT/jwTB0X6v6oJZclMp055NF0CkBCD3J2nPkV89Jb8UtbLPeNNCRNRl
	 EknI0ZySGCU3e0qUKusebo8eOUMFTKtX+9U/WCYY0kfVzvZCWuya2JnoHmaA6lgTRH
	 GtHApMybmJNIXjWCNYHA2YsFvfZGjCl5LlOUTjG1zQ4OIqSvBikIjQI73QVhLPSxUY
	 z2z9rn2N8Qm4gOJ2y0ksh0jhvcniBL8ZLeel0Tq+tmBN2C/n8R6tSbilYsv6dUAnXr
	 IxmkYDU6XBKfun/Ho6JEv71ZRQLzPCUJhtEvxpwmnWOkQaBLN6a5aBhLGDxTu4pdDX
	 cmaCsWWVW9zqw==
Date: Thu, 30 Jul 2026 11:06:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, Pankaj Raghav <pankaj.raghav@linux.dev>
Subject: Re: [PATCH RFC] mm/huge_memory: eliminate reference-counted huge
 zero folio
Message-ID: <amsf4_v4EDcU6ePJ@lucifer>
References: <20260728-persist-huge-zero-folio-v1-1-e7b604eaf416@kernel.org>
 <04d881f4-419c-450e-b9b4-1341497fa93a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d881f4-419c-450e-b9b4-1341497fa93a@kernel.org>
X-Rspamd-Queue-Id: D6F8B1C0009
X-Stat-Signature: gmbn6h4i5f39qkk6133dz8tra83tj4gg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785406018-182791
X-HE-Meta: U2FsdGVkX1+LjVe22s2OF50beV8rTgLooRsmo/L5nhkE59BHj4ASMZSnf+rtqJRd3jIgN6N0PeR8s842RlbD7dy2qL/nF0D5y8U2KqkTVl1k2jOUeJP6fhXdrpbceDB58l9VQbS8oF4n38uqL/5I26Rrq9zbSCXN8P06tJ2xteg0fOn3KW9IzYwNdaUaOiAL5nJakeuer+d9uSFnnncWZcX9PkJj7kLdiBQ1VfDvA0qvlG9hZsVC7JgZaBOsh/JHXmRu2pvTEzLSJ/vWk0B98nYjC+Vz29RlrPqqmlopX7glc2F1ghqgRdtqUJdxLxXHedya1F0goiGkSTRv6IiqWBHbDGI+UEQhjk6sOiJoL9WgpSRPqJUUq2KdBm4AFj/IuHK/IVPm/5QF7cAOLzVHo9lMiE7d0jD8B5hZWX9i4rSndkMz+GRaD4c+RhQMztYItqcQognWsq+0AKmDoQSq+iDGkmKX/yCoK2HrqENAhmP+85urBySxP4HoUyaZJsmzpDoLsvBbfliOd/UVyuUNsE+6Q+i7ulB6YSZAz3/2JZCQB/Ajek6v+27eFX4Lg9uc2DYeRH2vlqOOXseyMxY7hv/BxcWMslh7OqDa2Sr+k7jArsslbTr5wWkzjqbnhX30uA/VbgnzKIw7l8TjxfBfrsrgG9iERX0UM21XLTdOPKD4r5zTs6INpOpwUntf24FfYXTPM2K9Nw5BK+gYgscnnkjPhXRnT6k7oRRqEy+/GAzFQxPLBdckeH2+5BRtgtb4VPb+F4nNYhNbNNay1Xk7yRzJAzIXBXJ7825Rjoul/QRHPLKEJ0UlDQwzfiq9Pjm0YsvqKFA7xtGw/ZR2eSTiYQVC9cZY9jhy5TXljolb8oFuqve5djUGayYuzTqdoOIcWnW8hIT9w398f+dZ6zmvRuq3dNwy5iIGN8A3RqsSrSPjsTbkFep4AKY2k0r9xKWLfu3Huh6i555n9xdzROX
 Ne6fSW0c
 KONId2enYzBsxOQ59ORmt74SKn0iQZsS3VQLiqi8oHFh5bNOyEcbhnwNOpCw1UYfZdfJ60JVM3Zl/o/lmxKjxfBsNDsFO3kLpVZw1O2grNbdjxTMXY0gvzLf6k8SC5rkD0Ok4LqAndIrLvGYKnEkdsLjtWhUJfbbMSxG9grwiE+dkm0XG/AMnD2n08W8QXRcs1a3eZw2igJ45sPNDQ9dJUinC6jGyLUG175NYCfcXu1YZx3vvEJvXjWa44YrklGYHE4qtnJpimCqyXiMrZg1iNoC+aH6T6N0zSmj62Nc8gvjBD4J5YhTkQADnY9q0MbMr7kDeM/A4fm0Kec13ADa5QYQFEQezsPxP4ipK+E5DiEgpru+gnTPosTltH/T13hBFNXmc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:16:08PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 15:06, Lorenzo Stoakes (ARM) wrote:
> > The reference-counted huge zero folio is problematic - it's prone to subtle
> > races, it can introduce allocation latency and it is confusing and
> > complicated code.
>
> Just a note that the subject is misleading: the huge zero folio is always
> refcounted (e.g., GUP must take references), it's just that the persistent huge
> zero folio never drops the refcount to 0 to free it.

I meant huge_zero_refcount not folio refcount :) but maybe could have been
clearer.

>
> What you probably mean is "mm/huge_memory: eliminate dynamically allocated huge
> zero folio".

Well that's not really getting to the core of it, the problem is the
huge_zero_refcount meaning it can come and go and you have races.

But agreed refcount is imprecise + clearly confusing vs. folio refcount given
you immediately assuemd that.

So 'mm/huge_memory: eliminiate dynmaically alloc'd/freed huge zero folio' maybe?

>
> If we go down that path here, we can also teach GUP to not take a reference on
> the huge zero folio anymore on the FOLL_PIN path, similar to how we handle the
> zero folio.
>
> See the occurrences of is_zero_folio() in mm/gup.c.

Ah yeah. Can do that on a respin, thanks.

>
> The reason we do it for now for FOLL_PIN is that a remote pin might outlive the
> process, meaning the huge folio could otherwise get freed by the shrinker even
> though someone still holds a reference. Bad. So that would no longer apply if
> the huge zero folio can no longer get freed.

Incredible that we have to think about this...

>
>
> I recall there was a discussion (dropping dynamically allocated huge zero folio)
> on this topic while upstreaming the persistent huge zero folio.
>
> I don't have time right now to dig, but it would be worthwhile to look at that
> history if there was a good reason to keep it buried in that discussion.

Maybe this:

https://lore.kernel.org/all/20250811084113.647267-4-kernel@pankajraghav.com/T/#m4100481232bae8a7b661e8f6e86ecc74532c69a4

Generally seems 'smaller systems blah blah'. But smaller systems that set
CONFIG_THP get bigger reserves etc. so the argument doesn't really work.

I suppose they might default CONFIG_THP on but not enable THP but at that point
are you really so tiny a system that 2 MiB matters?

Obviously it's more problematic for 64 KiB page size, but then if you have THP
at all your reserves will already be problematic, and any read fault on a THP
page gets you the exact same issue.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo


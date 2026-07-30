Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0326C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8A16B008A; Thu, 30 Jul 2026 11:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9794F6B008C; Thu, 30 Jul 2026 11:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842CF6B0092; Thu, 30 Jul 2026 11:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7A36B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:38:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D69AF1A0196
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:38:01 +0000 (UTC)
X-FDA: 85045848762.02.8606243
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id B60A8140013
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:37:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NFm4be6r;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785425880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+PnHKrPUlCTuzU66I3wB94qFZEna81g3SqQ9t8e0lA=;
	b=P34kNlz+GZsxGqck0p2DLjdD13Fpd+izFytbrK0iB53JhXTKl1QOF17eIICywVKEDt1vtn
	Lz1q8dDz1rHEnLYAZNZ7fv0lK4/Y4FaRGzx6/DWbqPCLZZljXsG2plKGYCzX0wnGe6eFln
	pUOQLs/SRjmAAiqe3lntC7uZWik5ZzM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NFm4be6r;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785425880;
	b=FgnyaaaeFHXJ5W9RKb3a4Kl9ZZQqdeKg09VmFFuk7Irre50CsuwEeUkxwV4JETzEERrh93
	1sJuepOCfjrt0qip9dyN6HN6GhlQAs3msCC1oY9C+1TgVJMJLYLXoqxer5ooV2rBPGmUaC
	RYQvGWYtqSIHp8W/IIprnT9dKe9vru4=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8efcef23d21so1576d6.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785425879; x=1786030679; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z+PnHKrPUlCTuzU66I3wB94qFZEna81g3SqQ9t8e0lA=;
        b=NFm4be6rPOU7+6Y90YjsD8NjvkuqOwDSTmHnPAggUe18mXZPnBqS3YrmZAFnJ2B1EX
         Zj0WqxDOITP7uLo+G9OQnUoPoHZJnBKwjhuhqlD3FjGjC2AFbxNniWHFpWQGAXzqmW3U
         +iGiyyfXRYWkK7gTdwysB/6fXqBfnW5mM8aYoInqXbX72MKOh6LKPd//s+6DaJ7jjUYL
         AY2PTBj3PbkS8t6fFMB69ZWjOEaTthyZYbgDcEsxzI5tct79UpbNNtfBQHjtr+mEJAdv
         lK+/lqeIKwwnLaDIcEIZ/dUGdEF2nUCynXZT0HWkgRLdT5IF9a+mtKAuLWzvqsHyCWfF
         //AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785425879; x=1786030679;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z+PnHKrPUlCTuzU66I3wB94qFZEna81g3SqQ9t8e0lA=;
        b=jxtASdud0lbBjVyXjlpihRN1dEOrTlgzpPxu3RYtILhWAIEfcLiCgIZX732vj0LcxQ
         BB7RMM20XQkqEboucvpnqf0nsOubouGdhYYzKX3gmMoqlQ9Z+hp39fhxqXoSQuEWTuxr
         ilM8w8rXmQMgZepEdr9Vx3kGVxr0S7pfMf7daROjz74U5SZrpdaA6lOTG7HH+oLRYsjf
         QIJP0KfzIVecGUvL4tNFtp1QqRbCYAyizBrpQ7/hnbYfPcXqMLwOUa7Zn6XuwY6wvuAF
         jG+MgqSV7uVx5V3cCwPduSPXSWaksS6XZRojlY8SvixJyKAixhQxAY3zDdlP5lnDbubY
         6S7A==
X-Forwarded-Encrypted: i=1; AHgh+RoUmIxaGBHhjQwK5A4kw1xfyZYJzWp5EItPVIE2i0tb+dXfcqae3qdCmwvQFXB5iu1du0nJKRRG5w==@kvack.org
X-Gm-Message-State: AOJu0YxmIs8EsvI/Uh/AUwv+OO1GV6gamiQ8c2XkNugSdnCuVaGtqfd4
	3ppvQGme1a+atGZu5ePM3oxw5pAun4aqwu+X0ymO7SXjwTizbmQNCEJJUEfpkCSRHtM=
X-Gm-Gg: AR+sD12kpqSWMjpckp3Um/eXWcjG3L3szWglpMXxQwMtTap445N77ksDjH3Ezvn0Ydd
	ws6oP7u69S5PInb/RyzrrXXLyLBHJ3IsKK775wowpewIWDx78xnRoU1fAb7pqacADX8lPjtb8WG
	+C0CJDbyJRuZPameHl4io5XbHidrICIpBZGQtmKLzwh13IccxPfKCxHYYd2Lurrfnwx5Dgz2TVB
	ubmViwmhZP0IOd6EmBheDId/xUE3A6A6kdOKEFrqX8v8rcTajtNz7w1Nib8jkKjPPbunB/dedBL
	M/s6s0FBhjvc0sAQjJRamEEdrRJjoAQDDncIKb93Wv1uiVmevx6ohuC8xF+xIhYmgTH3LIwLqWb
	ydGu0VRRNraRkMwgOlSapMqZ1ybaKBCOlLLy7BJGxduDHHR1M1cwZK5m3RS9P9t5e+o3AF9bY2g
	660hpoQFM+prRFoSe1JFue3dcz7eK0xAM61fJEYtdyikANSpEDYMsiv9haiQNs
X-Received: by 2002:ad4:5ae6:0:b0:907:c056:d648 with SMTP id 6a1803df08f44-908346af616mr28769396d6.2.1785425878529;
        Thu, 30 Jul 2026 08:37:58 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9083231f53csm21821006d6.19.2026.07.30.08.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:37:57 -0700 (PDT)
Date: Thu, 30 Jul 2026 11:37:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <amtv0YRbSrN6iUEo@cmpxchg.org>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B60A8140013
X-Stat-Signature: u1yeame6heufax74xzjbnjfbgdg3npth
X-HE-Tag: 1785425879-861615
X-HE-Meta: U2FsdGVkX19PQIGIVVh/DgHKalAM7/8Aq5qZ4qggAFU8OsoE3rIVXrXHR38snUsHSeAy9/3QK3WFJldzg1F0u6LUftYUkFzskBmVaZyjxhjDEvxbBlZ1rGMWM9IJqLcxpWL9nppL/Agh6qKpCIa9if1u0dJ2bo92dz5e+jmPS7JiF48/D3uX/tzQuxgSUgWdRUhwHGx+6FJ6+hJh3JwVqWr3FxIp0df2vpU9Z87/AkcB+2scBUvEhZr72yDvxCWs5ag5Vb3LdTFZ/Dw7J0o5ctR7X49O6nqZiM1tru+K4szJ/UAiNn8MjTEenYa/axbVqccZ9mTHn52HF/Ury7OKWlvMO+Vun+8m6ULhaxd7AcXH/gFUsRGNLdJzHR63X0DMAuD+oZo93xeDhV6uKGjBiIc6ia2jDwfUINJS3Ea/gVe7/tk7kkZjZMxNDZWa/cMf0feqAp9eNKtFPFIvCysDxJIuxEemIR4PoyOaMEcfM4cmTEg58NHnjWAvPjQVUhZJ4bW9okkbiWCjLTngD/Egx5wDtV1b07kl8cDXxwo4Bs1+XB60MGid5SVKTvz1HHu9PXh9qoY2x6FMSQNLAU/zLKmiqXtp9DO64K85bvLEOGiucJ5oMs63yqAoMpCc+KrjEqOIUDfGdDK+HNxLnMnqMLm+74R2IZmLI43dPNdnpw2ssPHQHDeJg5JvvmYZKMmqvGACN4XkhLBUHsPpsPlBUXyVviKEYVc41BG704ikWqHP+ci/2rKlnJk8qTcsOyy0olHkxAUHM9M/3/mgOQqqupK0H8THBxUuhJF+L3t2ZdEAYG9KhJcs2TYnpuVybQAHL0YbfoKgjkegQZj0fIvDCm91vkMUbsgp/L/i+/gXs1YOQmyVvNIXne4hq3QFrjDzjn8nY9+FyTBdh5nZCXN8A2OKzTh4/FQR2sTDZt7Nlk7PVh5kSVcepQ39qmRLAVlmJrUPQwXFzBY+cMPDpHO
 9owN/6mB
 /380kT7WD73I/frHJ3N256Q7NYcfEyUjZbU4aVpKXNhJlgjbcmrwLAiM612nBzoKs9iajxT1lpZyHHqcHA0k8S3nU9J+BH5ipu+jvn9byhXzag4zmT1+2mbk7N7U8rZQFmimA61vbH0aOB13GrAzB4OkhCKIEoyssHyYOdEHgl8edvwsSfgAIhguUitHylXRjan9JNUuk71eSAkKEg+hhT7ceVlNyIvxF8V0TDBx61R6HytWxrtdpKepjs2gZgrEkwCX8azFOvD3aoRvm1aDgi9zavwzKltjHAPrMz5DOOk3YbMiVeOsmdJGEmEwYjgIOzq2kfPkUDl7dxlXH9UhmH8NjWQ88uoUbaYv8EZ23YzlRoMqyPC8o23f8jrBh5nWa1EBoKMoRoOq5/CkkHu0NDH8YqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 03:46:25PM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 17:04, Johannes Weiner wrote:
> > (2) With a mix of basepages and THPs, there could indeed be a lot of
> >     basepages ahead of underused THPs. That means swapping before
> >     getting to space that is much cheaper to reclaim.
> > 
> >     The current setup isn't perfect in that regard, as the shrinker
> >     runs simultaneously as the LRU. But it's making guaranteed forward
> >     progress through the THPs, even as the first LRU pages are scanned.
> 
> The shrinker would obviously remain and scan the list for candidates.

That's slightly different from what I had pictured. But I don't think
it changes my arguments much.

> We might want to remember how man / if any such entries we have on
> the list.

Right. The question is how does the shrinker actually find them:

> > (3) The anon LRU has folio lifetime, but the splitqueue is one-shot:
> >     we scan each THP once, and then it's either split and dropped, or
> >     found full and dropped. That THP never needs to be revisited. The
> >     queue actually empties as the workload establishes itself.
> > 
> >     The anon LRU ~ splitqueue argument is only true around startup.
> > 
> >     If we used the anon LRU, we'd need per-page state to avoid repeat
> >     underused checks. And we need external state to not scan the anon
> >     LRU at all if there are no new THPs (and no swap). And if that's
> >     just a counter for "new, not yet scanned THPs", a single fault
> >     will cause you to walk the entire anon LRU before you get to it.
> 
> Remembering "not yet scanned" through a pageflag (for large folios) is indeed
> very easy.
> 
> I don't quite understand the "a single fault", can you elaborate?

Let's say you have a 1TB host with 800G anon populated.

The oldest folios on the list might be THP. The newest ones might
be. You could have a mix of basepages and THPs. The ordering
constantly changes as the folios are aged, rotated, reclaimed.

How can it find a handful of unscanned THPs in an ocean of folios?
Even if you mark the folio state, that's hundreds of millions of
entries whose state you have to check in the worst case?

The lru lock is one of the most congested MM locks on large
machines. *Maybe* you can do it locklessly.

Maybe you can add thresholds where you don't scan if there aren't
"that many" new THPs just yet. That means magic numbers and reduced
predictability.

Maybe you can be clever and scan from the head of the inactive list
where (most) new folios start. You still need to skip over basepages
that faulted after. Skip over the referenced pages that have been
rotated around concurrently. That could mitigate some common cases,
but not the worst case.

The search pool stays enormous for the entire runtime of the
workload. It never gets better, never converges. It continues to
include every other irrelevant anon page, and every THP that you've
previously scanned already. A single new THP fault and the search
problem starts over.

I just don't see how that's algorithmically sound.

> > So I think reusing the anon LRU is flawed. It's fundamentally
> > different needles in fundamentally different haystacks.
> > 
> > If we can agree on that, then the lock contention problem has a
> > different scope as well: it's a simple optimization issue, not a
> > fundamental data structure arrangement issue.
> 
> I don't agree yet :) But maybe I am missing something important.
> 
> Note that the "simple optimization issue" is not so simple once you
> realize what kind of a pain the batched LRU already creates us when it
> comes to predicting the number of expected folio references.
> 
> It's a pain I don't want to extend to other areas.

Since we already need to do it for the LRU pages anyway, isn't it a "+
in_deferred_cache(folio) extension to existing refcount checks?

I don't want to sound dismissive at all. It's a problem. However,

- it seems way more tractable than the shared list,
- nobody has produced hard data to show that either is justified.

> > If I understand you correctly, the concern is that people will enable
> > all manner of mTHP orders, and 99% of the anon faults, including all
> > the order-3, order-4 pagelets, will go through the list_lru lock on
> > fault, with no batching.
> 
> Yes. See Barry's LRU cache change I linked as reply to Usama who is looking for
> example at a system that mostly just uses order-2 anon folios.

I took a look, but I just see a microbenchmark. That doesn't seem
enough to make a proper cost-benefit analysis on the complexity that's
being proposed - whether that's a shared list design, or a splitqueue
cache.

(As opposed to the patch of hooking into the existing LRU cache infra,
which is kind of a no-brainer.)

So I still think somebody who actually cares needs to show that it's a
practical problem, propose a solution and show hard numbers to justify
the engineering tradeoff.


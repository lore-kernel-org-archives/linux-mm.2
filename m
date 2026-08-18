Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B794C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5658D6B0868; Mon, 17 Aug 2026 20:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3456B086E; Mon, 17 Aug 2026 20:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406F16B0870; Mon, 17 Aug 2026 20:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1DE6B0868
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:45:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FA82C095B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:45:16 +0000 (UTC)
X-FDA: 85112546232.04.DA6FB70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 038A8120006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:45:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCXeXMTz;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787013915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7IBZ9whj8N27pOck+w1kYgcf4pKNDKFKbZGgA8fyUE=;
	b=z4cT4fnQhZiP5klKxKDfdHvOs5IwqhNr4KEf801EYPfJjJVme/cL6TV6Q5p95T51RM9LmW
	FjVicQE62w/uIBN9bulJIWoJeXywvhoaPh3GgBI9lwY7CgJiXJXu6hEvm+4dtNL9n/RPyU
	QY+Y5XnVRh84a4s9LIzdRTT1ODJF8N0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCXeXMTz;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787013915;
	b=CiPmwEDrLrt8uZRkwBJ0IMaxnptfSwuBF0IgGwTFmW3J48otIDOZq89uA2SnfB+7qEhoWC
	cfdI7w3VLTPXhyM7xbQk1njhuxKRzpkSsIJoOG5O5TR3v9W/G5orZ+kuqFx3Nt/UBUrt+c
	v/dRxqhkJ9pfv3tUlVx3CSOTIoPWOt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70A60600C8;
	Tue, 18 Aug 2026 00:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6DC1F000E9;
	Tue, 18 Aug 2026 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787013914;
	bh=Y7IBZ9whj8N27pOck+w1kYgcf4pKNDKFKbZGgA8fyUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UCXeXMTz+dlXORAFIthhGIBJp/jEko/vO888JKdoWD7GCBmXYh8ZESI9OoCouAQdD
	 jHGxoQIiARkrkBpEeejYUwOSEA2iZLrskeL4TUwKK+F0oLrH8FNXzeQQIe6sMuQLjk
	 lqn/tptC1D3yAN1dyZOTOU9LmmOybo56tyGPswn1J4TUXTtrUIooZx81tb/oTyByqH
	 InLlzOwJecAefFVN8a43oEKRtI+p9bTg3err5T15cn2j/282kIOFJXvcirldJL7v6G
	 QD3mGNyb4n6PSclOX4DjCNaY1I0xOp4MyUTkHAxDmySIMg+iCq91BMzypbt6cq0Dq5
	 4/U8nL4P/xizQ==
Date: Tue, 18 Aug 2026 00:45:11 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
Message-ID: <aoOqd8Th9dhx2bjT@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
 <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
 <anJc8Ansf-QWFfFo@google.com>
 <DKONM2LHEP8I.1PW06S1B3CDC7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKONM2LHEP8I.1PW06S1B3CDC7@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 038A8120006
X-Stat-Signature: xxaw7pxomww696wiayy8mzj4g6e79mqw
X-Rspam-User: 
X-HE-Tag: 1787013914-565070
X-HE-Meta: U2FsdGVkX1+qks+0OJwpIDSbQOqfgMi+VJa3YImhwuIyg1KwsNtsWWnYQCjMaH1nxBT+/sBrwPZXchhmRi/SYzk/f/6hBuxcrISVIfQEDs80RzaBVnfJ2PWnPaz0nTh3/UubYrBmYJuKQjNwlSt7AVT/OaPmYJIZpoHTDDZ/Kxns6UzYBDoCFVa6owYsBiHuACnC0JtvAvJKS2OVPGxT34XtCrvFOgSJEdlKpBkT2oWrgVHBp4yeztebGVHm72VNQIYoVXV6nY9Idw2RVf8RGwD1ynTUvH/8c7mGig1t5FRtd0RCqCmC7Bwew/K26JcBS/HGrHDrrkRNGx4WN4g76a+8viBkEy44lgLmRxk3EyiaoGE2oAAJkKfo4wJCpY27mdOR+oirQBTzLtZ7yMrU5t7U211rqxpXJiYlsDQRBwYicHjeO5wEP5xN306bGxlA+PlTTRascaFS89eFGwoZDTjXqGZTVrulORR4tUX/ErKPj7+H7gkP89bFdODRGd4IWJ8wh5DvUhLze1/H9yYzhfBtuMtK19/HiDrJNybfL+3BioeTbMiCfP55Fw9HnV3aHh6+/8qqPd8RDTTVosByN+Uag23BdfGrAJZiAc+LOzGpDiHF7XWLPSoa2419yXHOzxCbEFv65afzaiZb+ywTND5RaNaetX6NyTyUgsdcJR0I6M8WSt/p+XmkPKO8F7/mBR0l4MVZnL6Cl8XdjGyNBU4hwd26jvR9o7hZ+4NPj/J+8Fhf5RKo+901fuZa1usXk3smvdpK6EctBFjR8/G18HWofSvF+MDlxf7Qpm6i017Ls59ptbwwF7gAP6NUXK/02t2KzAfb3io8nq26P5t2CiTX7LyM8zOQoey1I7YXOR6KuN+Bqr0X/Zjr/UHokoqxzmX1yIHU3hOiRIIyrjCAmUCdULrM9nFEF4lYWUfjSORSOMXfH7vAWzViLhrRmmjZGOzly79rJZX0VFZKkYF
 Z4Pmm9/r
 9Rc4GMx72EumpI/YVf5b/+ky5HpSfdAjis7zfv0Zw1mvbFW/0lG0tUUvPFyTQ9YL3XtF1/MXln9ScsxY3Yf4+8yblMtip3iZu3WDUX/u9EyKp3mZNGf4TOlhwDvWSQ4FlriP+ZxwL8lC8xrcsNfM0fe/RyGTlxbqXbc8Jmb2TMspP61v4O4LTDFxn7WRjwFzQBvnCoG8c01AKcLK3SR42cqjtgu/D5af4OJaZoPAikI6PNJvB2ZQ/0Y7V49aMua3iFjT7Ej3JmWBbmY1QMuzMief13Oev40QrAzPb0LfUOOfnN0BZDvKJTRx6tkbaVyt/NGBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 01:09:32PM +0100, Brendan Jackman wrote:
> On Tue Aug 4, 2026 at 10:50 PM BST, Yosry Ahmed wrote:
> > On Fri, Jul 31, 2026 at 04:52:59PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 7/27/26 00:22, Brendan Jackman wrote:
> >> > Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> >> > non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
> >> > ALLOC_NON_BLOCK because the former is "a vague description".
> >> > 
> >> > However, vagueness is accurate here, this is a vague flag. It is not set
> >> > for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
> >> > but rather "allow dipping into atomic reserves, _because_ of the need
> >> > not to block".
> >> > 
> >> > A later commit will need an alloc flag that really means "don't block
> >> > here", so go back to the flag's old name and update the commentary
> >> > to try and give it a slightly clearer meaning.
> >> > 
> >> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> Writing this to get it clear in my head, so I'll also dump it in the
> mail in case it helps get us on the same page... 
> 
> What we actually want here is a flag that tells us when we can do a TLB
> shootdown. That means (on x86) that IRQs must be on and we mustn't be
> holding some random spinlock (most spinlocks would actually be fine but
> I think it's simpler to assume we can't hold any). 
> 
> It must never be over-permissive i.e. tell us we can do a TLB flush
> when we can't. It's fine to _sometimes_ be over-restrictive i.e. tell us
> we can't do a TLB flush when we can, but if it always forbids flushing
> while GFP_BOOT_MASK is in effect then we'll fail critical allocations
> and crash.

Why is it a problem if it forbids flushing while GFP_BOOT_MASK is in
effect? We should change gfp_allowed_mask before any unmapped
allocations are possible, right?

> 
> >> I wonder if we need to do this, and instead we could repurpose
> >> ALLOC_NON_BLOCK directly. AFAIU it's about removing the side-effect of
> >> gfp_allowed_mask in the next patch. But what would happen if we did that
> >> using the existing ALLOC_NON_BLOCK (or maybe just renamed to ALLOC_NOBLOCK?).
> >>
> >> - in __zone_watermark_ok(), ALLOC_NON_BLOCK could now be *not* set in
> >> situations where previously it was set due to gfp_allowed_mask masking out
> >> __GFP_DIRECT_RECLAIM. 
> 
> Hm, I can't follow this. The first paragraph sounds like you're
> proposing that we set ALLOC_NON_BLOCk regardless of gfp_allowed_mask. I
> think that would be fine. But then the second paragraph is saying
> ALLOC_NON_BLOCK would now be unset in places where it's formerly set,
> whereas I think the proposal means it gets set in places it was formerly
> unset.
> 
> >> But it only has an effect on top of __GFP_HIGH (thus
> >> ALLOC_MIN_RESERVE... which seems contradicting the ALLOC_NON_BLOCK
> >> description comment btw). Also __GFP_DIRECT_RECLAIM is only masked out by
> >> GFP_BOOT_MASK when all memory is free, so it's kinda moot?
> 
> ... but yes, I do think making the existing ALLOC_NON_BLOCK ignore
> gfp_allowed_mask would probably work.
> 
> Aside from gfp_allowed_mask the other thing about ALLOC_NON_BLOCK is
> that it gets disabled if __GFP_NOMEMALLOC is set. That is fine for the
> current usecase, but it's pretty confusing...
> 
> >> - in rmqueue_buddy() we allow access to highatomic reserves since
> >> 281dd25c1a018. That commit describes GFP_ATOMIC so we could have been
> >> checking ALLOC_MIN_RESERVE. But we can also leave this alone because it
> >> doesn't actually matter when GFP_BOOT_MASK is set, as above.
> >
> > IIUC we are trying to find out if the callers either has interrupts
> > disabled or is holding a lock, and using __GFP_DIRECT_RECLAIM as an
> > indicator. As you mention, it seems like __GFP_DIRECT_RECLAIM is only
> > masked during boot, presumably before we can allocate any unmapped
> > memory (should always be user memory?).
> 
> Exactly.
> 
> > So maybe we should just use gfpflags_allow_blocking()?
> 
> Oh yeah, it definitely should. This doesn't change any of the plumbing
> challenges though since we've lost the GFP flags by the time we get to
> __rmqueue_direct_map().

Yeah I think I prefer just using gfpflags_allow_blocking() if we cannot
use preemtible().

> 
> > I also wonder if restricing to callers __GFP_DIRECT_RECLAIM is too
> > restrictive, 
> 
> It is overly restrictive, but I dont' know of anything better, and if it
> existed I think it would be in gfpflags_allow_blocking().
> 
> > we can probably key off __GFP_ATOMIC as I assume any
> > callers with IRQs disabled or wiht a lock have to set it.
> 
> There's no such thing as __GFP_ATOMIC. (I think there used to be?)

Duh.

> 
> > Maybe we can also use preemptible(), but that creates a dependency on
> > CONFIG_PREEMPT_COUNT as far as I can tell.
> 
> Yeah. Which...  maybe is fine nowadays? Since commit 7dadeaa6e851
> ("sched: Further restrict the preemption modes") you can only set
> PREEMPT_NONE on alpha/hexagon/m68k. And this restriction only actually
> matters on x86 anyway...

Yeah I will look into that. I like preemptible() because it encodes
exactly what we actually need.


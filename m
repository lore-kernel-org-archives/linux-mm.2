Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46254C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5667B6B0092; Thu,  6 Aug 2026 13:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516626B0095; Thu,  6 Aug 2026 13:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405CD6B009B; Thu,  6 Aug 2026 13:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5A06B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:15:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F5B612018D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:15:44 +0000 (UTC)
X-FDA: 85071496608.25.DC8B8A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2C941C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:15:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XKcmZebS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohnM/QTJNZ+57FtwY6l9db7MEahwiXQwpnCOrToPkmg=;
	b=htnuH551SzAw1qwPpRXSW55P8W6y7j5ioCtlrBsZcZ+zEO2AwPzLMS76bCgHFO1+gE6aLY
	/XPBLWpgZkSaCgG9Ynulm3vctf28fl+9A4MoGXklTbN1wpHiRa1D2zFK2I8ljErpOXBmF0
	09+yF5R1tPLAXM6MNdtqT3fXD4VrF7Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XKcmZebS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036542;
	b=7seZOFvuMkEVy45WGybX411hEizLkkAGd11Wi6taJugDsbGDoAru0MQnUVOJ+xCMG/RrQ3
	N1KSBixwb9Qr7O1zbkrrHpDDKRh7SVhA0JsI+ao/g5q6pcisemv/MlR4yqahF0PwyMFy6C
	2Hq/3/oBg9c6PKglQhaxw1zjY3Y9oIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2C90405C5;
	Thu,  6 Aug 2026 17:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC1A1F00A3A;
	Thu,  6 Aug 2026 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786036541;
	bh=ohnM/QTJNZ+57FtwY6l9db7MEahwiXQwpnCOrToPkmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XKcmZebSRKhOclLgWHO9NdRoYzuH0VLZl5rBKrCWL1gXuylkJCeiEchNqSFMmGSM6
	 vH8boDW0vXrJFmVbuai85kPhGyl6ArrCrfWjlu9sMcn5Gt5kOLITQ1IvFv1OG4B3Y+
	 1hqp1gXkTq558qykMk6eRd5lzO9SjG+yoavkuOWP0URRsjZ6Ajjh6QeNyl7evYP7MP
	 YBGIcQfTFygshxRU8t5SlwyurdMjKlk91Nz4F/8VkXHOpLfdhwl2rKLK6h7iowEtu2
	 viI37MTyeJtnNrqaTIKqxlK411bwjGjmdj+RLpA/dcNJnUr71M4oraSGHoTVek3ZR8
	 oZB4vvu1jMVmQ==
Date: Thu, 6 Aug 2026 18:15:35 +0100
From: Will Deacon <will@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anTBN7WzVZukl26p@willie-the-truck>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIXr4Kbn59Ac31Y@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: engizrsocahqyf18b641e8bzcc5cmbxt
X-Rspamd-Queue-Id: C2C941C0002
X-HE-Tag: 1786036542-172973
X-HE-Meta: U2FsdGVkX18yFfP+CcLGLfq0uk1715rLIDrQjyp2V056c4DpBP1quoUizlZoObCbNZSNfTs9+sgQeRwZF0dXIkrMEHLAqSSutvrF23Nnzf+PZ2kwvFjDNM5V15adpQoewazBGQ3GGDBHuv9ei76/H0hpmS5C3wQK3dje6AP6VecNy5rm5PJDrEr+TtbqNbMAwGQbFzELRRlzJGa8kN0APAd5pmRkNN10oWL9v4FxaxR836/MhZb2bUy/jUrOAbZysBDZ7l8XtXs/KjqFSn1Zw+WMDV3k6u3fJA9mKHROj2DdUNbIzf6MvuQ1K0JbNCY1Aq/qCAZZuihkoztjajeqBIA6dyhbEo0hQsIGJqF9kDTV7R0yUP4J07AboRDfQ9eC3P4L6guqmS/IxIKdd72WXqX1vyLBRjLBTQkle7SyfpQOOKnTVW6oGPJ2ecCKLElXQ0yDoPDkxfU3+l1stzzVC7gel+XT2Jokof/esyJmBwKqvlyg/xZgToC2CHL/VqifXea+IQ2rA6iVlPNrHzFx6WX8eezi9swEJJCUFfuGtCRs3ZCg/oIEdxwhybnM9wO1TkewUdjI2NS2EYXDG+Qud5D9jl5VtM3Wq+QpoAbqhPVTMbVbUKw1ayArZbexqpMeoBgTkPx6yUxOaKDFNvoFoWQMi+llW2kc7EWN5fkomAYabUB4dcJcaCOG1CGOVfmRd8fTsgjR3mrvNrPIQ6lfbTLd1XXO8XiEoGxM6rhw2Uqw4tCpZS6F12/o35ygvWnT1feC6qEyEe5t25UssKr6O/JcfdyquIF//cotQ8mrvZKv6IlrBaxRKQ/+XnpV7JLPVcd83/rnoZsjdCKbwW/sbMhf5mAlyDuMniL9DSxns062TkgR42Lun6e2gxTeKeQlOjUHik93fdgZ8WmraxrtZgf0wM4J5HK3QKZOFXbp8YsR85qv4ez0uKxKkQlcSoQU2D7O9b465ZgHwMQRnVs
 O6M0YKYC
 W6IQqEuF/MO0eNVohn5H5q/TE2P8EU9paJCfOOPcJxSs5JBZocvCuYHsbrGRtvaX0E3kvUlpSChQpYBCYmpffct+DeLGZctj/gLtwTa7lvvCTQeU1guoNgi+v+RRmg0ll+85E2kvR2MsKVX4y+2LggQjvM4H3s/hns9oDcNGXta4xIBsDh4f2JWz6wAIO0tpJo658BmOyzqnxUsbHWXB0CaDs+qHL0PB7tLPowwRVMJ46E5Ez1S4Oj51Y43cSrjTC4neECb40ssO8463rU/e+V3yYPipy2KfPhrvWxDVMMhErgxc+g6gDfICouBM6o4K7XSU1PwYFYvzjSK7imJTkhXD0BlN/Sa59hutfO7ZnyOKISc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 06:23:48PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 04, 2026 at 09:30:08AM -0700, Linus Torvalds wrote:
> > On Tue, 4 Aug 2026 at 09:27, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
> > >
> > > We certainly do not want to replicate that approach. We are using the per
> > > cpu page tables to avoid address calculations in the VM that other
> > > platforms can do with a segment override.
> >
> > Right, and I said that that's ok as long as it's a internal
> > architecture thing. Not a "this is how the VM works".
> >
> > Because people really have wanted to make it a "this is how the VM
> > works" thing. And that is very much what I object to.
> 
> Well :) it fundamentally changes how mm works - now we have a whole new set of
> kernel page tables and PGD's that we have to think about.
> 
> And the series either tries to hack changes that fundamentally alter how
> vmalloc works or will add its own duplicative kernel page table code to do the
> same kind of thing.
> 
> So now core mm has to worry about TLB coherency and synchronisation, how this
> might interact with things like page table isolation, and a lot of other
> headaches (and I'm not really convinced they've been thought through here).
> 
> IOW - breaking fundamental assumptions about kernel page tables is inherently a
> whole-VM change (See [0] for instance for an example of what can go wrong).
> 
> If Christoph + Yang can provide compelling data that advocates for this change
> AND the core mm and arm64 communities agree to move forward with this, then
> things are different.
> 
> However, I think the best approach here is to find the least invasive way of
> limiting the change to the architecture itself.
> 
> Mark has put forward an approach that eliminates the exact overhead that this
> series aims to address but does so without having to fundamentally alter core
> mm assumptions (v2 posted at [1]).
> 
> So that seems very clearly to be a better alternative to me.
> 
> Ultimately we need mm and arm64 maintainer agreement on the way forwards (or in
> the case of a truly isolated arm64 solution, arm64 maintainer agreement).

So the nice thing about having two implementations (i.e. the per-cpu
page-tables *and* the preemption stuff from Mark) is that we can pitch
them against each other to help us make a decision.

However, I don't see how anybody could argue that Mark's series isn't
cleaner and easier to maintain. I've seen it described as "hacky" but I
can't tell whether or not that's supposed to be a criticism. If we
seriously want to consider the per-cpu page-table approach on arm64, the
numbers need to be _really_ good and across a variety of hardware, not
just the stuff with a memory system made of baling twine. That extends
to the kernel text replication efforts too.

Will


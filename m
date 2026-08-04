Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65823C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBF36B00E3; Tue,  4 Aug 2026 10:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675596B00E7; Tue,  4 Aug 2026 10:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564B76B00EA; Tue,  4 Aug 2026 10:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24EC16B00E3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:15:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE72814013F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:15:25 +0000 (UTC)
X-FDA: 85063784610.14.59CE99B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED1E618000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:15:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnF3lgKM;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852923;
	b=GnGBuecXZ4gWVPjDasb2xIBNhxJ8ZKN+IPIgkpi2Yq+n3Vq53obLLZQecAt4o2mqxz9rke
	Lsvww7QaFD0JZjzQ0aw35z2/CC9gBP5pvLCWRRB3YMxQfKWNIouYWhngSzgCD+cGKniYml
	i32yVQekyty0i3Vk8Mjd0I+EUSeCQ6w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnF3lgKM;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJcR7YXWrmqdZ6avQy5eZ7W5n6FvlWwC3YY2riy4eDo=;
	b=3hIgJ2pqYysRQAnKfEFv7hBpubFIcb5ez945gIzdQZ2N67cdSn/okAy5EH+4xdd7bMP33m
	eYHXbQyKx7z95UJklDW3SBZ/7gs3Ix2/jtbfEl53p4LByoenKxzeRu4B/QPwZs7nB7sUQL
	byLDC0ioWvpekpEIveOnCUnfQnvq6FU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BB6560A8C;
	Tue,  4 Aug 2026 14:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396951F000E9;
	Tue,  4 Aug 2026 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785852922;
	bh=qJcR7YXWrmqdZ6avQy5eZ7W5n6FvlWwC3YY2riy4eDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BnF3lgKMxDaKGMfseCBsysay5w1WAhXZwaefobS1+NlG9tpktpOCz3c/7EuUBIr5L
	 Nku+ESaLfFmLB/UkDOOnJTp4FK+SIUH/whZfKiQDAfdhFABb4vFMkL6fg9c3EaxtyN
	 JQO0goEGVAQGH5hQXlCxtYmh95VAyy9u8sdQOw0yZ2wni6JYmtRasSR5PfNywQU4RK
	 Zmu62yC10jpcnXCb+4mfrkza2JmpRMTVvmXYuaaruwweWmg2HVYJbawtzLswJO6fvF
	 Lhx+DQClat2sSGDOkf6y6oHJVVfD5VN+xjIAQGuQCghSq/BJ25yZ8LaElY8YDbuy+S
	 5LrLdS9PwYrow==
Date: Tue, 4 Aug 2026 15:15:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, 
	Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anHuLy52o5S9Nlwp@lucifer>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED1E618000D
X-Stat-Signature: 6bbb9b3boxgt5wwwnfg4grbk991ogdkk
X-Rspam-User: 
X-HE-Tag: 1785852923-304588
X-HE-Meta: U2FsdGVkX19axlS6tC+fbzyY16D2qvTuLbBveJxl0TQrcGNfHUHwNG05dI7UF6E04fak8lMo0dsNp8bDHyHuUjaFXVq0Ydk09+fxTpxRwoYK9AGycP/xTKT9ZNGIPJfjuCekShAqTEJL/jbf2yaA08Cp3B4p/ijpxyLUqr9KLQiHVSG9E3GYvqYN4mH3JDmwu3zzfzGfOEHsclGJdlvDMOr6b5BkxLBbUqV9lL8mUAnJG4UPdXHObxdsAYHrTO6vJGHv/cEew8iPU18mEjrAmm9R8051MsLbYC4wwqghxq8oQReWhMueQYzL2Dv91KRuaMauGaNciLKOgTICLDa5fZo70uh6o/bmrrpgBvYOuA8w6pRM392CLYz/BXg6f33qXIu0hx0tJWoRWb+Rz6YRdpJweW+KZgAmvNlPxQceCAheehVaAvSthNiT3guLA57UyPEH4YkBBjdy8uMHoNgAfuvk1IPcMW9fOd2LyfLECNxFz7GLpOxgDBZeEGF1xyPxcIkQVQXzD3aoXzQvczWTXLTuY0lGHvmnoQDZU6nGwB63SCa1fjyb8pR6v79mLqYKYtkOXYcI9DNmqD/Oc0HAt2+sdTQq5SXZ5Kta4TWgMpsfQoSMIj3EvEpBM2kJJbl6Nx+1WGkYSMLOUaR5oO8a3/gm+w588dekShqhVRW6O93PFNNBoQbbERWPNLej5WcgRqcSshxDV+ZZHPo/UBYnvv3CtyldNwsAlbK8cF7ZXFS+QkHIuEFlMgUeaLs9AxK7eiAuL1A0l6QTm9UXUgxoWu3CLF4SHvOmBtAHACy9qla4VVvOi+OzNW7+i/ljG6coOr09wUr3XT3eF8zknC99NPnCJewec68wwgAziVCVFd5j2rY4aDDcoEUV0OKcYyQN2ESUPiS3aEs0B3C7xnc6VA5i/K5IS2Z/VhUhCYxM9PKughrR3Cv8qdkzZxnMS67dGIhW4s0Ddya4PdTzrDJ
 EzoNKV3q
 RyNdryDbZFd6+iKrsJOqjPd7mSlVYSI2f6m4iqiEqEggLK6byBoPUOKDyYlzdCFsmtPmu0F0tC0f6xC8o3vmV0QhxgzqrmtKPdMD2GGvKx80h6882TccbllGs7837otsaxTk6DSVyTianDwBB+XmzgW2MDT+68tsOb4Yb9BkgZCq6YGlpI41rRdj8AIXqA5c5pr4CJ2wA4RRzrLufbLubLnxcfbWhMaweo44jyqhzFCOk4iyg/I2wFRhvO5yDZV1C6SJRJ2w7y/4CLztHA+8pk5OlPOBVwYRXfXWuFYnGNIUpZurc5vyAtbyDNikaPTozac3WnqPzxmYSoideExi8QF8CVj2NHflEHbayNTnN71fK7Y07bmuL5H/W1Y76bXHyTkipJ5/j6ZnkIUsOYYEsC0bE+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Linus, Jason

On Wed, Jul 29, 2026 at 11:28:02AM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 00:06, Christoph Lameter (Ampere) wrote:
> > On Wed, 22 Jul 2026, Mark Rutland wrote:
> >
> >> I expect that should come with a reasonable benefit, but I don't have
> >> benchmark figures yet as I haven't finished converting the xchg and
> >> cmpxchg implementations.
> >>
> >>> It sounds like it just moved the cost from one place to the other
> >>> place and it also seems hacky TBH.
> >
> >
> > Yang Shi's patch has *no* critical section. There is no additional code
> > for the RMV instruction. The RMV instruction is executed on the correct
> > per cpu area. One of the reasons for the performance win is the
> > eliminattion of these critical sections. Your approach still has some form
> > of prologue and posthandling like the current preempt approach and
> > therefore will not be able to have the same performance gains.
> >
> > The code is more efficient, there is no restart necessary and the
> > technique is already widely used on x86 for a long time.
> >
> > Having the ability in general to map mmemory differently depending on the
> > cpu opens up a number of other optimization like
> >
> > 1. Per Node areas. Calculations of addresses for per node data and RMV
> > operations on per node data becomes as trivial as the per cpu data
> > handling. This will further reduce and eliminate critical sections
> > currently necessary to handle per node data modifications for NUMA
> > configurations which are increasingly becoming important for large core
> > configurations on ARM64.
> >
> > 2. Kernel text replication. Kernel text can be replicated per node or
> > per whatever memory is closer to the executing code. This avoids transfers
> > via the on chip memory busses and increases performance. We have seen
> > 20-50% on that one.
> >
> > 3. Readonly data replication. A similar approach is possible for kernel
> > read only data.
> >
> > 3. Read-mostly replication. This is a bit more complex and the writes
> > become more expensive since updates have to be made to all copies but
> > a read-mostly variable is rarely written and the replication will reduce
> > the latencies to reach these variables.
> >
> >
> > 4. Custom sets of cores that operate on shared data that is replicated
> > per node or some custom set of cores. This is for example
> > useful for network devices that have the ability to do I/O via a split
> > PCI bus or other construct where I/O lanes are duplicated to sets of
> > cores.
> >
> >
> > What we are proposing here is a basic new feature that simplifies code and
> > allows addititonal performance and functional features that are so far not
> > possible on ARM64.
>
> Most of the features you mentioned above are not supposed to be
> architecture-specific things. IIUC, Linus strongly objected per-cpu page tables
> in the past, which suggests to me that such an arm64-only thing is not the way
> to go?

Linus - I assume you still find per-cpu page tables totally unacceptable? (had a
look around to see your take on this recently and found [0] which seems to
confirm it :)

Yang/Christoph - You ran a LSF session on this but it seems there was
significant push-back there also - https://lwn.net/Articles/1073395/ - it seemed
pretty damning on the approach as a whole, so given Linus's and the community's
rejection of it is it really worth pursuing this any further?

(Adding Jason as he was involved in that discussion.)

From my side, having recently done a bunch of work with kernel page tables and
the absolute mess they're in, with intent to move to RCU kernel page table
freeing, I'm very concerned about this adding additional complexity and making
the already very fraught page table situation we have in the kernel even worse.

Since this work seems to be very much arm64-focused, perhaps it's therefore
worth looking at an alterative solution that's specific to the arch, like the
one suggested by Mark ([1])?

[0]:https://lore.kernel.org/all/CAHk-=wire3dzhHx=KiL_f5Rj0=1u9ustsa33QoR-F9-v-NU9Ng@mail.gmail.com/
[1]:https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/

>
> --
> Cheers,
>
> David
>

--
Cheers, Lorenzo


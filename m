Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88848C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0C26B00CB; Tue,  4 Aug 2026 17:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8696B00CC; Tue,  4 Aug 2026 17:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4B16B00CE; Tue,  4 Aug 2026 17:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 690146B00CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:40:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF09B1A0302
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:40:29 +0000 (UTC)
X-FDA: 85064906178.14.8D8A885
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67D0880006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:40:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=c32dVb87;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785879628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMV7HR0/CnmihINLeNXxLTzPch53Pj6muqbezN11jys=;
	b=lNBxjFnVAWGMKjoIzlSEiRBy0uq0Eqk3FhFbZ3MXg6Swscie2JUNmb+rFFhzD06Xhjw4nI
	4Y7fT3yIPozyp5Q/GCiQ9dMspzMC3Kim6xVuTnLkbuG0337SGZgPbEEFCkeRG/XVcnZpCz
	s45GYfJvIvmNAuedLJtyO6eaEPPYdQ4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=c32dVb87;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785879628;
	b=Q2PN3kkoWdsMvU5dSGPnFcjxagsL/7dDH2r6iEoYATvtigZKQAGltCW+b42yolvGmsmM9W
	ljT68FqyokdKDYnpPVkG4ISe7oFqkJnUes/uyVCJoOhtGHAhFCQ7cslX0aSZ+53OmVHJvY
	jQsT6FpB4pOVuzHb3h1aJjvvxYiJ6ro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785879627;
	bh=kMV7HR0/CnmihINLeNXxLTzPch53Pj6muqbezN11jys=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=c32dVb87oheYpHTCYBu4Zwtx7RyuIzDCmq5LWekWI3DHAiodHDoJcaJSA4i49L9MT
	 lh2khhxfNJbD9DhJ7L++CgNtUeSN/JeH/sYalP7ThMS2Q5EbmyY38W8X4vTyGRuCAm
	 7dN1Iy2GTazRY5X37jYr7i60KKXAPQXJKryy3NUQ=
Received: by gentwo.org (Postfix, from userid 1003)
	id 66A3E408AE; Tue, 04 Aug 2026 14:40:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 64A5840287;
	Tue, 04 Aug 2026 14:40:27 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:40:27 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <anIhSGs70TTzymHM@lucifer>
Message-ID: <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org> <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer> <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com> <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com> <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
 <anIhSGs70TTzymHM@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67D0880006
X-Stat-Signature: iry969kzwo3hedhgfp74c85gw9ynhy9t
X-Rspam-User: 
X-HE-Tag: 1785879628-421557
X-HE-Meta: U2FsdGVkX1+5tdRZrkp5fUEB7+2ZSuXH+7E8WLjXlZWnsiSSqIWy0mpwx98bDddfMtQ3lL2uUEHMU3YcTQwP5+6ogS+z0GxEer5/wQfTkylRuk3rb4ixFLoZjfcD/hng78K7dhSR6xGGLTz3CA8M6ma9J1hoOfK74MnnLoaDdtNjS3tyF59RkiQl/3XF39jr9Dout+wbgjXbCnfniCW/g9kXQ0dn/eirRJNCkXm5pfkwTATHhBLCQjan9vqHMQpt+tY+xLoGgUHwi1QpB9rV54jghkYym/4qJHk5fHTvAj3LKJ1+y+xWYzRLLtevwyA2v/uZnKvYB83SJLSppaMnMO8PJXGWOuKJjP5vYgSta5zS56rhOmu/1u1nsQIzUI73i+fyZvFhkWJQwhPmqhfjbE/SgS1U9kjVgr7fFAjfsUG7gTC9ZchNgewR2aKE1YRn1+t2xUNYInPXZpHWDASPAw/kayvS8eEJl//PBcA6reGOtqgfe/WWHR74oXkt3SNCP0x2Ys9sNmM5U/7slG4SOapVKXcEAm/zYhvpZikaIaOg6s4daKt8HcZ2jn28O9zndJCYzxcYEc2a5yKFayzxVDdqS1/c+84bPtKwqS+ikkf6e3mQJ1DL/tXxYX1jw2C9Wl79Q6iLjapdaMR9yiJlZZ72X5+cDU/xsFqvtyZ2ZCMj+gJgJqLmG8AkfYM7j4Q83uLuWt+F7i50OArP3r4VwibTGIpJVMRXGKEyYuncFyMpCzClha00w9g4ZxWhBF5aPQgHsvqr9WgMe8o0BC3SGHuNcBV3LO0Bt5ofFqbn0U0Gg/MOCis5w7eS0ESkVU69O+JKRIiWtZ/yinIY7hEEdmYr1R3X+o13wHd16JK9qapqMB8foz3w1ilNJplApEPtKIRot4vSo2wiksJeSx57SGxQtIZvX//yGoax9sktmY7VOcc+n78R9RhtHgEeTQRx7DbdrzBuM3c/b6EmscR
 QAFGE1hQ
 lYzmz7xGjERh+5Tku9MgUX/oJiwX4R2teyP4ZeRHvpnghygV0XDOnDQvnATTSCeOB9PVT7gaNo2o2LehHpUCdDX0oKKSqO1ytgjnLZb9Rx5F+THukVyXdiyMBFwhCKLwDGh/HKya8xe8JVjR95znSyW4wpn26Purz0UtD0oNTbUklsLDubb88WrR86FhQvy2dqoDwFW4DKm9wAkp1zOnaCL/X/N/0zEg5NXE3YWj5HEWTzl3wtmMxIbke5ayzqG2/BqQE/FgiaJ9W2/CFPZNZCTLZ9wwvAPlx2J/qlqZEwSusfzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, Lorenzo Stoakes (ARM) wrote:

> On Tue, Aug 04, 2026 at 10:01:45AM -0700, Linus Torvalds wrote:
> > So I'm just trying to clarify my stance - I don't hate percpu TLB
> > contents per se. I hate the notion of codifying them.
>
> I do worry that changing per-CPU data structures to support this is exactly
> codifying this (and will encourage other arches to follow suit).
>
> And I really don't think there's any way to implement this without
> fundamentally changing core mm or assumptions that core mm can make.

Would it be possible to discuss the technical issues instead of throwing
up this and that foggy objection? Lets not get into the complexities of
restarting a critical section from an interrupt handler that you are
proposing but lets just look at the code generated for this_cpu_*
operations:

The fundamental problem is that your patchset does


<preeamble establishing restart point>
RMV per cpu op
<post handling cleaning up setup of restart point>


What x86 does and what we can get ARM to do is:

RMW per cpu op




Why do you think that your solution that requires a complex restart
mechanism is better?


These are operations that are key to the performance in critical parts of
memory management and this code is replicated by being inlined thousands
of times in the kernel.




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81175C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423E46B00A5; Wed,  5 Aug 2026 04:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC2A6B00B1; Wed,  5 Aug 2026 04:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6266B00B4; Wed,  5 Aug 2026 04:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 029116B00A5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:16:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C9601C0BDA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:16:52 +0000 (UTC)
X-FDA: 85066509864.12.CC45F8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBD51180004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:16:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1dfoJYr;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785917810;
	b=iNwbBpOurXjfqCmDeC9YYXE5PxF7Zfu8is5/VpTAx/KHD8BS9ei3sju/lT8vMMGZPTVuL6
	mZH+ZRiMzOEUDNyK0/yVI1ffASe2IFFaMqjE1IUsy8BYCtdYlZDVHaBeFZGoIoRTEdUEm/
	tZA2v9/zONiiWuPXKP2v//Mtp5VbwsM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1dfoJYr;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785917810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmYyrdZe1B0PBpV7nWZEHOZ78x8Fhml0/nyFckT8Q5U=;
	b=QoAbCKTkxjVR4KIPZUIRugpv1POBS64rEvy7G1SHim4BOQbkJLOc6skTkU5HluxoEUYdfA
	jh7kC+QVFkBxi+5lpilBKoxwZiSgkLmCn0qryEO7wVkAAeA6bsCH9jolsryKDEC/VBP7dO
	hzAqpXsBaQhz4Rjs0rx8Bs1wvl8Pwgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 124D7600AE;
	Wed,  5 Aug 2026 08:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6411F000E9;
	Wed,  5 Aug 2026 08:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785917809;
	bh=GmYyrdZe1B0PBpV7nWZEHOZ78x8Fhml0/nyFckT8Q5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T1dfoJYrP3ggTDguqaQhaDmZLHe3mJjru4jCT/1ANuiGL1fot3+s/dHfHfhjYoyEX
	 Y/aoGoTTs2LxtCJHGd5OZv4Owb8anEX7nZ58Cgw3J9H/zzQiBn6w/oiPjSeGxP3u+E
	 mYDuXnJmHjwfW6tfBp1xS0WGTKuLh8ZX8Yh8rSfPMcpsINud33uvR4MdiF0syKhk7T
	 utgpQXaaxlwgXTCPSMKCC9+pkhuX90w61xunWQsdzZiRliIxSsrtcJDlhjr4Ykn/nQ
	 XHnITQrz2tNu+rbNWvGoQt9hshksDufbzvK3Orz/AFL06/C0FFAzaDTVmR0YTcEHVn
	 UuniWlaO51HGw==
Date: Wed, 5 Aug 2026 09:16:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anLr5Xd-sD7frihN@lucifer>
References: <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
 <anIhSGs70TTzymHM@lucifer>
 <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
X-Rspamd-Queue-Id: DBD51180004
X-Stat-Signature: fr87tir87bwkse9o9d7s4sx17xcaebw1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785917810-666579
X-HE-Meta: U2FsdGVkX1/FzMC11Q6dcF9GGMlqS7S0RaBVjV84Ox6EEj6aesL1cR6zvKTwormle3VMiA3vqoYQuO2ROwU4/Vi/57r7YnMsuMVjZixgIfWJupQG/7Zw53dJ9Ul1zuiU8HDGs0vVjWPmIwPQxhb26spDwDeJOJYoknGdmIfeTF4BG1mvqG/Du4D1NjdGdiL5v62oxkXMrJRoO4duab+5dNAaZXo+hCGLDZuyU61qkRp9yYG9d0oHm3cPBk5w5e1Pk9NxtluhbGNOuWnUjeb5pzCOSotQAXLx61s52UfrRTKkJYVvEU9h2pxa4tBbc67w/AVSWR3woBuRYUnj4GYf63daXyuHvJ0niqZXdLi55eYCqEpkllBtS3/RqsuKqLi2T1ALOMnjgwby3SLpEljaYyYT1raxpfAol1oxZDMFVpBt6OfeA+L8QCxsriY0j4xS4TxLzvDKNup7KEc/NaI9iVHw9t8Nge4T4UXlPrboIh0KN54+/eNh4ZFAeBkYc+KQx1xv64Ashxea86IfA1WBWVZ1f3RN4HK5o7qEO3IH+PvKbIwClaUZ2bbpVPeKI8RR0ieCn7lPcqcAKEBQNeUM/YpbFSG9YIn0BuTM2+9wgOAxmmDvbrRYUSQcSYfYh4k+aFw1bA0aPLGYLm0h+Gr/ssybnRf/E2cOBqWtpuvFixOr6UoTTvtBBcHr9CyAzb5/bXaIU7tIQDIGeD4hVh6VHahEXwcZLtdoZLV/8hSTlDfKnbXGyd9eW59NPrVkROQXdpprmiGNs84vCR+imMSDZdqN1avFGgCxbIZdnjKo1W3OUcDCXgr9LBjlJuwqfQlq9Suq/YLdGziq10rTfOmBvlwlvnh0V1qaqzXzxeUKpZ0IaKKSMLkTw6jVsNU9EBXi3+tpDlxaVIslu2dVqAQkgMbggv86cSBDmAI3xg1DygcUFpLpw8YXILsI8e7KF9JzyJtwyxE8tlKjdl35bF1
 jMlBkDxF
 Lj9MKBOYdnocDtHJUhCY61yJ+Rudaj+HDqk/Al4RCPTfwNGGKbPB0pwXfW2uHFZqHZv6nSuCZpNjcko3D276Zzy4DBDgDIR+P/T8Du0k10dk6L9zbmFKcnKqDJxpjqS1aNSH5b/MTxDAgjFLqBWtpBp4m9GfK2lxUoaclbHyDzfcvDTupySlhAaD3/giLKJ3NvLc7lmPBd0BFT+Z3TQOignPf1tmcf57qooSQ/oUiFQsUZr8ir8iO009G5QweY5iBs/swIaGCvqoWgLNxl7ffJv7A6eDgbIN2fuPR3bDgsymgWiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 02:40:27PM -0700, Christoph Lameter (Ampere) wrote:
> On Tue, 4 Aug 2026, Lorenzo Stoakes (ARM) wrote:
>
> > On Tue, Aug 04, 2026 at 10:01:45AM -0700, Linus Torvalds wrote:
> > > So I'm just trying to clarify my stance - I don't hate percpu TLB
> > > contents per se. I hate the notion of codifying them.
> >
> > I do worry that changing per-CPU data structures to support this is exactly
> > codifying this (and will encourage other arches to follow suit).
> >
> > And I really don't think there's any way to implement this without
> > fundamentally changing core mm or assumptions that core mm can make.
>
> Would it be possible to discuss the technical issues instead of throwing
> up this and that foggy objection? Lets not get into the complexities of

Christoph this is very unhelpful. I and other maintainers have raised
_specific_ and _technical_ objections. If you are having comprehension
issues it'd be more constructive to ask questions.

It's really simple - convince us or the series doesn't go upstream.

>
> The fundamental problem is that your patchset does
>
>
> <preeamble establishing restart point>
> RMV per cpu op
> <post handling cleaning up setup of restart point>
>
>
> What x86 does and what we can get ARM to do is:
>
> RMW per cpu op
> Why do you think that your solution that requires a complex restart
> mechanism is better?
>
>
> These are operations that are key to the performance in critical parts of
> memory management and this code is replicated by being inlined thousands
> of times in the kernel.

I mean this is just silly :)

Provide data to back any of this, and no your benchmarks of your approach
vs. nothing isn't it, nor do they demonstrate anything about what you claim
here.

You've been asked for this multiple times now.

(And please no hand waving about 'critical parts of mm'. Be specific
please.)

>
>

--
Cheers, Lorenzo


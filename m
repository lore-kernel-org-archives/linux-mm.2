Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51595C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B476B00F9; Tue,  4 Aug 2026 13:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E54D6B00FA; Tue,  4 Aug 2026 13:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADA26B00FB; Tue,  4 Aug 2026 13:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1FCB6B00F9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:24:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 181F4140295
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:24:10 +0000 (UTC)
X-FDA: 85064260260.02.886317D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6EE9C20007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:24:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYxC6jQH;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785864248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdo0g0OzljhYp8D7Lk64Y0YwWCc5s5e0e2hV/SX6BIE=;
	b=gbosytBhDHxtoiWLZdZtqvSceAxhFJBzWR8ysH1L9kDUtdTk+PZ0Bcz1fLPgB1SVdSYGse
	9iWQUw982PemlB7v5S6SysIs/zbv0tqtFeAcSbhE/bYjzltms3VRsiJLRsgcT76kS8kO3U
	zBOjp/+faCZYSipnL1CRACrH7AtA5cw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYxC6jQH;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785864248;
	b=Q3cNnTGI4BGgs6Pgs9MaIUKL7p+AJ6dYkaarLKwjAP7r8y4aPfrsDikvhBgN474I/4T/p5
	VtDQxlPuiCvRSDpDLC38czC0AmKz8vicK4RnfxOMx0WjbV+POLv5yD/Q/U+ndbwsm3F7uq
	B4bdvaKdNolaKCMU/WGoRSXtf2j3PAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 053D060A83;
	Tue,  4 Aug 2026 17:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2EA1F000E9;
	Tue,  4 Aug 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785864247;
	bh=tdo0g0OzljhYp8D7Lk64Y0YwWCc5s5e0e2hV/SX6BIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FYxC6jQHQoCG8KneX3WjShKc9ImEL+D6mwQ9pJ4Fum1n1E+DR0vkFF0VuzOhnMncP
	 UTljgqnABgSWALppud8dEdIzp5SiDln9LtWdrr/rVNq7njEEP0GxtiVN0R5oIDJb2U
	 XnIHGdreR/x+oGSbu0/tCGhc9JaK+I6u8p9sTcuooOUqhSe2qROtgvgazbhUm2wrIO
	 LvCGtZoIpfCvZN2DiugJVKPNaapL8SdnnBSC+Mfk9BNLtUDlhhGne3ReNiXgdn3Sc6
	 BvWwj5wNaqy7WkfldfQn6woSljyNqfmuyplDKZQV4LLVD7j7gSiOq3gMBYPAQ4dSGQ
	 0wcV7RmRmpNbQ==
Date: Tue, 4 Aug 2026 18:23:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anIXr4Kbn59Ac31Y@lucifer>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EE9C20007
X-Stat-Signature: 939mtgbfzj9waxrduaqjembub5in8fqf
X-HE-Tag: 1785864248-42779
X-HE-Meta: U2FsdGVkX19pGHtPWrk60pifAbiSKChz/rzKFS98VdNcxQQ2fHbZHvtV69ufUd+9sNgK5qXOueJJ5uVzfV36KqNrFOF196ueEWJ8t0rLjg8E2ZDHaiF1dre+HspjC0AH1Hc5rbXTUSHw3JOpBsXrS2GMji3tIZr/nkI8F6eHLoetTIg0OEohD6Yc+yRu+hY/CFUGNHsb8k2+7m7d1hHuNR8welqbpVdKdRZed2vS/ngyo9kIHVyZEK5ZgVD/KUiDa6+4HlskAUskaIjz85574QHeivmllZeUpzN91gHRuY3ZDr/OikjChhRHvBfglUIDKUw7fKHBFUefYEcFh92L4al6dDaLYX5kZ1a0nu9svBSqsu9lzeYJMmTc1kQUya9nEKtTSm0da8EN8WIlCl39b+mvFiHe2yLEz5U1H03oVll/4sB2ErLxXUOAaLtgUUZRay9gx3eKzH6a/Ea3OCzTQth5URDDufkCN+56nqsX3H/r/Mia4vQJLIdddUC042AZINzKli4oE/TIn4Ml6rekVqt2xf3PaCfZgdcNiSQCYkH+CXSlco/O1Lak+kmg+tLNuLvRBUXKldAyzMSDnyFriJgij5QLpI3FDOTIRMFmxxH236YEwb3fnD4eh9zYk2CMjWSgIFA9qGVAQKYWWc/50rE3tl4LuaE072pVNSn304cbHBr71o4EsOGJSx4UO1h1atOX8ngUo9NEJ1tTWaH2O+8rBHXVGi3r9n6socjCEVvORe0iUCSqFGCokDcJBkta3trD7HMhiPiu8fJNKG6ugeKvWTgEbTCUnpacDyYXbkeaBgRqUnuWjpsxK4v34Kxy43qNDJeGN2VZ1qwkJJ88ewtCqvkvWXOHt8JlBg9euIaD7tbZIcfsq6teOt0gpwiffggHh+LtysxQnXYh30s+unAhT8pc1n1q5pAi3O0p+va2QP3KehmqDU6xsnNWBYHavL6PgT8lHkU7ECvHV8y
 t3WIzkqF
 ruIYNze0NcoG9BDC/VCRpLKIWz0VYtQDlhyawf9OQ95q3D6xv7EoaF0VEJaU6ae826A4OyG7iDOs6puTnvzbovAbRG2WQKmNaW44tuXFatqC+yuRDOcGsBeJ6YXcMaHqRpZ6ebUX/WSJATyqfB5rzT1ydso+ms7PshJljty/FyI6T/LUMlHxRuWS/iCxSSqUWKW3yxPP1ISf0XM+Uc7iuj60R9Ji/FpO9NhwtNmKzKuedpUDx00doPyXJgcM3RGFab30DQjcCM/ffON3KxRS1i5JyaEoNV2eioYhM8owngWoIo/+nXDU3jaiKFhq20QXnNFZDBsuljWibKm6XeSggKNfZSa9/5I1NmD8Um1t8fiOpYZuJJCCz/m/qcaacN7Pz7kw324MsfMpHDSveguk7hTf+JitUrzD3VMTpIXWTy6Rii+01kMwxQl/GaVtQ0H1H1UItcEYASAcC9plK499yEMZxRJmShModRPUzCc0pOttIn9dfu++2GIy7SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 09:30:08AM -0700, Linus Torvalds wrote:
> On Tue, 4 Aug 2026 at 09:27, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
> >
> > We certainly do not want to replicate that approach. We are using the per
> > cpu page tables to avoid address calculations in the VM that other
> > platforms can do with a segment override.
>
> Right, and I said that that's ok as long as it's a internal
> architecture thing. Not a "this is how the VM works".
>
> Because people really have wanted to make it a "this is how the VM
> works" thing. And that is very much what I object to.

Well :) it fundamentally changes how mm works - now we have a whole new set of
kernel page tables and PGD's that we have to think about.

And the series either tries to hack changes that fundamentally alter how
vmalloc works or will add its own duplicative kernel page table code to do the
same kind of thing.

So now core mm has to worry about TLB coherency and synchronisation, how this
might interact with things like page table isolation, and a lot of other
headaches (and I'm not really convinced they've been thought through here).

IOW - breaking fundamental assumptions about kernel page tables is inherently a
whole-VM change (See [0] for instance for an example of what can go wrong).

If Christoph + Yang can provide compelling data that advocates for this change
AND the core mm and arm64 communities agree to move forward with this, then
things are different.

However, I think the best approach here is to find the least invasive way of
limiting the change to the architecture itself.

Mark has put forward an approach that eliminates the exact overhead that this
series aims to address but does so without having to fundamentally alter core
mm assumptions (v2 posted at [1]).

So that seems very clearly to be a better alternative to me.

Ultimately we need mm and arm64 maintainer agreement on the way forwards (or in
the case of a truly isolated arm64 solution, arm64 maintainer agreement).

The LSF session was not encouraging ([2]) and as an mm maintainer I'm not at all
happy with this myself, nor does the arm64 community seem all that enthused so I
would against gently suggest to Christoph to be a little more open-minded about
the the proposed alternative which he seems to have dismissed out of hand.

>
>               Linus

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org/
[1]:https://lore.kernel.org/linux-arm-kernel/20260804170503.3513916-1-mark.rutland@arm.com/
[2]:https://lwn.net/Articles/1073395/


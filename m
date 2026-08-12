Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B93C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A5A6B00EE; Wed, 12 Aug 2026 05:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62B86B00EF; Wed, 12 Aug 2026 05:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F956B00F0; Wed, 12 Aug 2026 05:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 985C56B00EE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:37:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 389AD1C0922
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:37:10 +0000 (UTC)
X-FDA: 85092113820.12.D0EE7C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A4A931C0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:37:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mw0GXJkf;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVm0I+4CnY8Kjsb/wK+YiBwR/wyOwuijfKRRaBi3qDY=;
	b=0hAx6peF7Q2zpPonI5ZG/UBEcAsZcdRMHzazkgc10bZELM0+wXRyNAmnPrKWnTRwBZZkTY
	Odf6OOVMSmbKIZIrJPXkUEkuGWCvMtf8R/8qDchkWZIHgnFwtRhUYM769vREOlvJ+KzLcl
	Ct4TmVg6VlXdMbAZ5Z2qd5mC/PI08R8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527428;
	b=1D59HaYwDTb8o+SAj/Z9Gya9Zn//VrQURA301fZUxzNjPca+CTL9TAaejcvUju5c5pvVOa
	kbVc6ESpj6a7a9mTeWI/uGfDwo0jm04lt394y22mugRv8lfAs0xpp3Rk0p2KJyy+8fiP23
	4tIOTsEJA1DMAo2f3wHDAL54cufhiRs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mw0GXJkf;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B51600E2;
	Wed, 12 Aug 2026 09:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE751F000E9;
	Wed, 12 Aug 2026 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786527427;
	bh=ZVm0I+4CnY8Kjsb/wK+YiBwR/wyOwuijfKRRaBi3qDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mw0GXJkfhxEG2wLcMT7FaBL6diGloCYSwqYBc+How1kTzqZ3Oa/hfrvLY1BZ4ju4I
	 Ya4KR76z5bVJ4Mo6a0okb/e20xVO2Vnms503UjIFFu9nI6IfTX9PaFDmW3JndgPkFu
	 onw1nEPS4CW1P3KiByYqzPZAc52L0olTqfJLx/ZMhYtkojsm2iwFezECR/5n4pS5WY
	 GIyqA2ROQjCoY15xyuWNDKTj32b7IJag3X5SYkTfyniCBdc0x4roCJsQ4YSsIRh+d1
	 INiUxKTdHzJ8+mPlBZp+ZdON0jEBmh9ShjHNsPiSUeF1kGhOZfZAqaCCdoG9o98SOV
	 0Bpu4PZIfrdOA==
Date: Wed, 12 Aug 2026 10:36:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hengbin Zhang <uqbarz@gmail.com>
Subject: Re: [PATCH mm-hotfixes v2 2/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
Message-ID: <anw-dxYi-OXFjE9r@lucifer>
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
 <20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org>
 <011609c5-deea-43f2-a2c2-90f64053eb3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011609c5-deea-43f2-a2c2-90f64053eb3a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: jgpjbbbdob64k45ubmg987xghzcp9xu5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4A931C0006
X-HE-Tag: 1786527428-669107
X-HE-Meta: U2FsdGVkX1+qgaRtlYL0Uaz9X9E+Mc9OqijZBsJOK0xTdHzF+LidWyo9My9KFtewQ1vkPkXj00troc3S+xMUdG3ld5lTMHaeO/RZhoLzmiygcxnJ7/r+J2DC+KygEqukn+0hhmWdRZuc10e0sXIk6FazKiQVux7EaEMomIeFVSAVxAcP9lMe1QOj7iDDbKyG0UeGYT0uREDITCbhpqDRUzPVA/tvizzFx3kyQq+RBBgf6SCv5QZN3320xdu09WPI7cEvxuWL3tpsH4sLnoyxPRJweBJrIzD4sQSxtf3ypDnnDj/oILbmPFLsN+ANsbM1xncwLA3XLC/JYixeUzC65CR3mhf7J+UL97WPShK0OuSGrpPMy9Wnyi8r9xRsrFixOl+8VFucVRa2VdFgoqXGSdNcBP5vTEfOGgs55QltwgLoXDRQWrMPJlk+CnJShRHR9YllOw9M6mBn4Hozxx5txAEwX6DvrUsMGi0JaMJA8pg5e53H5dn3iVTy4J85gom0LcJUSh0+pbN2teBUw4WcGofdoqPDZXUhmfliNcvjRchkxA8UctWsesqr9gIz3QCNt7aFSSNGZem1efbL6RXdbPXBmu6zJH/Y0mnOTU7SHR376n2x7Lvu7Bd9W1YRZ1ZT0n2uZzvRwVruyji4Dt/v8pu5E+cCpNMhoHthJlHCmkPKVs/yW6A4bRwhq8sxGgce4Ce3wJ6ojin18lgp45WY1o+hJWb5dDHGeOmTH+YmZSkte61hS3IqrPGO6Yiy9qfO99y5YsERDvWtn6RI75x35Wn4BnQPoNZPqx8/30gjj6hPCWYR98CiC6e2oflLrVWiO+OXEE7tqG/bontg0dgGoPoT5vQPiajv/cyVIpcdLRfAwfV5D2qVjdCbkw/ijIdKqnp2ly5KkCZK0s1G1r8U5fIkErG14yy/xNijwlsNzO5yJBen3kmNm/HpGc4ktCtGIXeTaOMd54T77zWko6h
 V1qfiu6U
 QKNV+bULBT1I08FJ5I8O0Nw5L/Wm3O00S5ifE18g9THbP793HwoC7PsU0pqv6+aeBU5LkbmyEbdYqGvKuRMw2x6JbpqdUZuLOMhaGL19hKuOnxrk/udLAOPUuzTBkE1QuTk3xe77V9ti7XkWM3koQxbOGZxODPnrPQmLySIa39KyHZgmUl84OnZNFMB5lINToEWjTCn0FuccObRTVD/G/N10bWFL/BE1zS7e6A7M9fbZaI7tnAuMAHduNhLMqZr7VrorsttSShq8QbRC4IDUTT4T1sNK9tHV/LxweK9YCcGQCbnbvxsD4SsTP0U47WkDbbnmX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 10:05:55AM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 12:55, Lorenzo Stoakes (ARM) wrote:
> > Rather than mixing the refcounted and non-refcounted
> > CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly
> > so it is clear what happens when this configuration option is set and what
> > happens when it is not.
> >
> > Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
> > introduce the refcount, lock and shrinker if
> > !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, abstract initialisation and teardown,
> > abstract the huge zero folio allocation from refcounting.
> >
> > Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.
> >
> > No functional change intended.
>
> Ugh. Why is this patch already upsteam with
>
> Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
> Cc: <stable@vger.kernel.org>

Yeah these tags weren't part of it + it was intended as a separate thing but I
guess it got lost in translation.

I should probably have just sent it entirely separately after the fix landed so
my bad on that part.

>
> It's absolutely not a fix. It's a cleanup that should have been reviewed properly.
>
> I really wanted to review this.
>
> Making David grumpy in the morning, good job everyone.

Sorry about that :) At least it's not schlop? ;))

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


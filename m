Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35D7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88416B0005; Mon, 13 Jul 2026 03:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12506B0088; Mon, 13 Jul 2026 03:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30066B008A; Mon, 13 Jul 2026 03:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7E76B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:38:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BE9E1A0ABA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:38:55 +0000 (UTC)
X-FDA: 84982951830.19.7C97E8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8508CC0006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:38:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irkwxYLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783928333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eGByJuvHEB+z2eH8QThZCFnk+Hl3GeYnz64gEkwk2c=;
	b=CLs7irGRBfiJ5SV5aqt5hH4wA3M137YglX+dQjCJCV4aEyC0t8N+NaVA4+AHWijwTjNB41
	Op3jz5yzxAOb9zT0h5V6EWPLQ8FkbHdXOAC0E4JwWJnFoEUpO1HPmbmBSNIKG2Pf4Jdm0t
	fpentkztH7Xq/YsJ6BHwysJ3TIPZNf4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irkwxYLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783928333;
	b=tDhV9zWfnx83s301zhVkEDoE7Bo3GZvILOCLKyL6KQjakE3/tkFFIqOFtXpPQK/w4/7VWf
	RS1zjMV0tUdQU3eKNmj8o0DDq/ew2nTZxyCoyRgfHtUGgpF2wDg7t7ymKDafMG9SZmpRdO
	zidsDV8nsyrBzt7QwXDXGD/+RT+Hk3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC75860018;
	Mon, 13 Jul 2026 07:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021531F000E9;
	Mon, 13 Jul 2026 07:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783928332;
	bh=9eGByJuvHEB+z2eH8QThZCFnk+Hl3GeYnz64gEkwk2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=irkwxYLpo/4GSlq8ZgR+kxtCtChgHXEvZCGUUsXjdcJJfJtdQzhs7GCTYNCMyNALI
	 8b134LpRmIPk0m5eKgadSrX80W13Zgwaf63Q83uB5upLUalokqeV0UQDC7BleA3LQj
	 JxV1nPyg4BQfta4EeMDz7MiwEeut8oPvc4NWxz1uNy+xBZzW1SiLI/Qcpjae9g4Ge9
	 0wTOqRV/F7FTZJNUVDJ5R1vr1nwuKeH23wHF9pRh66jxC8zf26J5dGw3ivs3ZxvA/k
	 ChA1qeKGTqeyQBGMP3Nw0fGhE7GTSWA6F71UXfSwT9iTJg5Khvoze2qxeDN6WuhmP+
	 MnrC7bA5Dm8WA==
Date: Mon, 13 Jul 2026 08:38:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	chengming.zhou@linux.dev, qi.zheng@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH] mm/mm_slot.h: add a helper function mm_slot_remove
Message-ID: <alST91EgYhtjkaAY@lucifer>
References: <178368585772.363984.12871786869575753171.b4-review@b4>
 <202607131344540423N-vjn1y68X614fkeZemP@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202607131344540423N-vjn1y68X614fkeZemP@zte.com.cn>
X-Rspamd-Queue-Id: 8508CC0006
X-Stat-Signature: uxdq1kp3o9cu5p5coou6zrmf4rxkkgtu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783928333-39547
X-HE-Meta: U2FsdGVkX19eg8AIgAXKyIKOTCerVp2oYfJqYhj/SQypvHkc8dpR8F/plK0GhT/Han9FtoqIs9h5nOrpqrKfF8FHmdirdsXIaN4cdf+FC8NJLmxAe548ss0s3aTzIp3SoMNLTD28OLNjXG6SNWOy9GRZwZMIHTCBNnWNtj6UE2zpcI57/Z2SaMK2gJHmtRfay6N0cMn+Bou63YVtSboJ3/bA9XRC35w5cDEzLy/o+FAvaLjLZcJ3HbOI83/O7s2TC6olh8jVzzAAu25Mmrq4hzpCWRonmbDEjVqKnvnbqF1AnkDyYRbacpcbrLzB4/vzRiGWihpVWZJrCwbWeS9P0MDg3C7fU/mGdVhwz4dY5nhoW3myvntJIIP21jxMZP1GR0VsgusCqC5U+VZ4lXNbM9qwogM7W4pgZMr9nmYZaewXYHIXqRfrvJDKcAKk5Dm97JvRexQOfbKFLkN0K0yVMczTIfAMA7bL/rFs0JdmxLbYfwmZ/OCv3lEsMMIDdBhuQafXwqxu6pEehlWawJquWmze1HLPRNxYYDdTupGwEfbEIEUIjq2In33e4aK3uoAsFT3IeBYtrKdmNM23vlF0BfSJVHS7+3/8jcG2aKua8HiHpcFQkhQyoPE1CGohwqW9/VovTo+aXFwOBbV/HTrDwrxlbn0bB6j6euTgM0LHTsqxdkJLfqsNBcVRyjvcp5BGBXqBrsWuhpjIww+bgzsyjBLiEAwKB+NpF+TkRdcdn5L6sg4zn+p93bbX0aIhzcBFYnZcUtHeabnZNY7Yoy4EU8pYcIEKiR0PDmgLLyPYfJi1W8map49Uu49bMbQgMmLkQCF17Y/5D7m/50PTm5NesYiEEcx61f+jX50fsKce16eouihi7QeGqbUkFU3JXA90Mv+gtmtbnu3iKU7PHqKypEBLY89jQ6ht7Oi0UySPMcXAJlVe5zZ11nDBkRoGdKxHvFgKt9smXNrCkp1j488
 sCIykcLl
 cLN00OCUh82l8c001dSx4+b4J5S48z/tmiJd9eHFG8SiOCgVJ1rCbAEGto0x36U1Q4glUOf1D4hDiqKanthlUwo3nH6X1OSSvBVXireGfsuab6o/UvaOTdW31XXGDaEH78jl3tAkncm+ZSkKElsOh1U6Po6JASjBRGcC7fS/aNJ4rIGikTHyCUXHTPA+hDBPFNdLB507s8wy9Er4k936bgFAcqCT9wDeGA1UqW018sFA/X805OXLdWOy7w1M3Z897r4euStqL5mIOPjxJIfh33miPujT6zLz2Pi1rVCznO0IfalzDvGG4UMrhZ0PH63BvHYRoB+KH13i6htZuRezGhwx/pVvAdaKFJEbv3T5Aw8tQIiBuCCSDxTrdAKADd5uOloZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 01:44:54PM +0800, xu.xin16@zte.com.cn wrote:
> > > No functional change is intended.
> > >
> > > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> >
> > In general it's fine but I want more :) see below.
> >
> > >
> > >
> > > diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> > > index 83f18ed1c4bd..bc3b9ae8fdbc 100644
> > > --- a/mm/mm_slot.h
> > > +++ b/mm/mm_slot.h
> > > @@ -52,4 +52,11 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
> > >  	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
> > >  })
> > >
> >
> > mm_slot.h also inexplicably implements mm_slot_lookup() and mm_slot_insert() as
> > macros. Can you change these to static inline functions in the respin?
>
> Sorry, I looked into turning mm_slot_lookup() and mm_slot_insert() into
> static inline functions, but unfortunately it’s not possible because
> they rely on hash_for_each_possible() and hash_add(), which expect an
> actual array instead of pointer so that sizeof() can determine the
> hash table size. Passing a struct hlist_head * would make sizeof() return
> the pointer size instead of the array size, leading to incorrect bucket
> indexing and memory corruption.

Ah that's fair enough then, explains why they're macros there :)


>
> >
> > Also rename the horrible names from _foo -> foo too please.
> >
> > And we don't really need 'mm_slot' in the var name for a slot just 'slot' works
> > fine.
>
> Ok, I can clean up these stuff.

Thanks!

>
> >
> > > +static inline void mm_slot_remove(struct mm_slot *_mm_slot)
> >
> > Yeah this name is gross just 'slot' please.
> >
> > > +{
> > > +	hash_del(&_mm_slot->hash);
> > > +	list_del(&_mm_slot->mm_node);
> > > +}
> > > +
> > > +
> > >  #endif /* _LINUX_MM_SLOT_H */
> >
> > Thanks, Lorenzo
> >

Cheers, Lorenzo


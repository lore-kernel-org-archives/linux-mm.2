Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE3CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1D96B0095; Wed, 26 Aug 2026 11:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B91E6B0096; Wed, 26 Aug 2026 11:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F118A6B0098; Wed, 26 Aug 2026 11:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA59E6B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:28:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AED1A27AC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:28:07 +0000 (UTC)
X-FDA: 85143801414.05.7DFFEE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA010A0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:28:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GsEYIDxR;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787758085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wXM8GEdeoqPJq30nYuopobVQoNsL83eAnMuGSZS4qk=;
	b=1JEzFaPjvA4n/wzPQUufwAD6/AdFdabKEZnxY9MfRa/49xBg/vZAjA9+dAOmkI+xUCvc19
	6GDwZwOkh8IsyoVeBvyXgpwsIltE0gyQRz6uAk8/ZWlwenND4B3K6BgDAYR4RIVsysZL4h
	Feu8BfuF6tK1b88EYFPIRZVD6ZzizgQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GsEYIDxR;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787758085;
	b=LLVX39dx4UByQyR7nAsHRzcU3xyKZLxAOOnmGAP8hHa0f6QrsnKIuoZ7tjlfVrpN+sE41L
	P1nGfQEMoLldVpP6Zt3JAvJmodRSuS/KL8VBydXyG+RlJnVIN1/pudD7LVDE0rBmcsTHHU
	iWcXw6iKFSDiL10rCcWPGBfphMDJLKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E56056001D;
	Wed, 26 Aug 2026 15:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE41F000E9;
	Wed, 26 Aug 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787758084;
	bh=6wXM8GEdeoqPJq30nYuopobVQoNsL83eAnMuGSZS4qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GsEYIDxRBh9KRJYS/157X7JLxKfDW+BFX7dfNMBTq748OE3mxl2W8DTY4tZPHUPK5
	 gnhRfze/iY3wNJiDyJboLjz9ykD82R937fUz36SeVn9G/qHET1ZoyvazDvCACXY9nP
	 Ql5QsqU+F3HWBPQUv6t/VCkWFaEmh0QNF3lvgnRnuKBXvFTzVUf19gg9UKoeeEwCNa
	 FQ3ABSm+AS/XzFz58ZQSrD+9O+7+JbrpXO3eE7gxoWGrENpoX/2812y4/8C9McOPfc
	 2YQU6m50W02azt/ocCehp838SkAF49yTMB1vTQcXEwi1s6D6n/StMh5u1F6nruY1XZ
	 YnExIlmcgksJQ==
Date: Wed, 26 Aug 2026 16:27:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
Message-ID: <ao8F2ZO2GGvxIgcQ@gremlin>
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
 <20260826151520.202465-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826151520.202465-1-kunwu.chan@linux.dev>
X-Stat-Signature: jior57mx5yye9eh4aiwhfbmnd9jjcwmx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA010A0005
X-Rspam-User: 
X-HE-Tag: 1787758085-286210
X-HE-Meta: U2FsdGVkX19eomsxewPeZCbvjyi7adi3n/gPGYLnb0s1HtOwW1mygCiQ5HajQKkQJk8KZ+hMlvEbCVn4FfIXYAN8JoFHvfDjAW6xM5ByORHfXl9roinTwIDUEs1p42yLi+AO9RDj4e/3YiFt2+gDKVH+e8Wj/7M0GVW0w1Hofl95cc2bigHQWExI4ci7ZzE3qGpDEs7hngr2fIFDc7T5/thOus+VuQceYpR/c90gH7ENAO1tp4a4pZmTUa6KAVKrwBaNtpnEt8K1fXOM5BD9Bn5oK3hKRm7WhyFIUoV+U8GUaAkQTz7X9s5QHoPSOK11vLsg5htwP9skFerLDQBKlV16Kpg7jPA/6/HSKfk07qUGFeH8vVbF9PZFU1RM1pF7sJqmKwy83DF4PQqb6ZU0Q6U2ZLBim/x8voi+V44d50OkuQlZ2hYbAL3ICyukmJkhQVjcYWZ5nPd8cQMRJD2iVwDCB3W1261dRS2Wrr+CqjXaXngKu+H65pUwhAUbUrF7XJ2AOFB1nn1AaYbduYJhgxWA2BuT9rGGZsVi3+/69lMA+Kq0cW/5E75UvOJEXB2db7diMUm1cXGSHGwRUVUpJhORUI7MgHNZFmejqqVbUp+BhGTeMbdlE1hnjEJjKGcPHE8yjNBsKqycyxrapae1HwtfZJ1TLO1vfCa53kJ/SB2OZZSSyGxbzp5TqS41m48fMnWvosX1/y9iaCrYcqtVS4dOLZyGf6pq9+/USSxUqKKsJhKJD0mp1LJjqM9bj81WFQvXQqbDJIPUWUMKSvTwSC7Bxm9t4BpAB8lF/wYf+nKKM9ywV1Mc8bchtLLkdHTwjjFMIiHqGbjBxrPE4/gCVUedmJ+3Kdqqj+9ZXyJrNITvM17EKRFUZvCEN/l1221Fa2dBqwt9i6rmmQXCXMM6AzmVApQ16XN+w6q24cHwqQsAI2SRX5fR9H2T1q0rxpZoQ85Ctvh+d/EHTJTb3mG
 VzJq4Hgz
 /rPiDnAeIx1Hz5JYp3am+hlI1gzvFivO/RmMMIiNcKc1HXVh48IwSeS1qgWnl03Ah63BKSD6qm/NFirwn46iqfKlv+4h2eWRJz4QCHmw+qGfQhxvRW8KWDsyE7j0IXyjl68mVq+3pRIncyBiEf7ka9wFi3stFRoR0kVJAub8kA7v4Cgd50O45xe9Pc8KShebg7+fsM2f1qhB4FnCI+563qNx83tucGrrIl0NyYUN2LRWn2dSzRGdDWV/0sCWfU+Hnnn2wUHtI8HsMjmN7P1KvnXOA5yuzutr/Ks2xFi5AfdQ7oddYAr50g3YD7brS2z4GBwrDayBviA/G0MWY5SYgAl5H96mG6yzBRkjNbTsstSV8N6QAWzxmm4Lzaux14L8HAFQYTn4Nv41VRmKl3rz4rb2msf6DbMgpOFPqLrdpFKK5tvJjgu0yH61eUy/4xUA6QR1UAu0tSdsFR7YFwy07eFgdy5MEe9N7qkZApz810hv1WlZIk1Cg8KcarOuSdl0DNVtz/skf7VdXBLEwAj+eU7sOPO/jLH/e5+tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 11:15:18PM +0800, Kunwu Chan wrote:
> On Tue, 25 Aug 2026 08:55:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> > a faulted VMA into an unfaulted one.
> >
> > It does so after the page tables have been moved to the copied VMA with
> > MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> > as the page tables it had are no longer present.
> >
> > However, in doing so, it violates the invariant that the anonymous page
> > offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> >
> > This is because a VMA may have been faulted in, mremap()'d (causing a delta
> > between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> > mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> >
> > This condition is a violation of a fundamental assumption in mm, but now
> > also triggers an assert in assert_sane_pgoff() which explicitly checks for
> > this condition.
> >
> > Correct it by resetting the VMA's page offset at the point of completing
> > the MREMAP_DONTUNMAP operation.
> >
> > Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
> > Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/mremap.c | 22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e8df5cdb0ac9..2b4b523a86b8 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
> >  {
> >  	unsigned long start = vrm->addr;
> >  	unsigned long end = vrm->addr + vrm->old_len;
> > -	unsigned long old_start = vrm->vma->vm_start;
> > -	unsigned long old_end = vrm->vma->vm_end;
> > +	struct vm_area_struct *vma = vrm->vma;
> > +	unsigned long old_start = vma->vm_start;
> > +	unsigned long old_end = vma->vm_end;
> >
> >  	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> > -	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> > +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
> >
> >  	/*
> >  	 * anon_vma links of the old vma is no longer needed after its page
> >  	 * table has been moved.
> >  	 */
> > -	if (new_vma != vrm->vma && start == old_start && end == old_end)
> > -		unlink_anon_vmas(vrm->vma);
> > +	if (new_vma != vma && start == old_start && end == old_end) {
> > +		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
> > +
> > +		unlink_anon_vmas(vma);
> > +		/*
> > +		 * The VMA is now unfaulted and it is an invariant that
> > +		 * unfaulted anonymous VMAs have page offset equal to
> > +		 * vma->vm_start >> PAGE_SHIFT.
> > +		 */
> > +		vma_set_anon_pgoff(vma, pgoff_unfaulted);
> > +		if (vma_is_anonymous(vma) && !vma->vm_file)
> > +			vma_set_pgoff(vma, pgoff_unfaulted);
>
>
> Hi Lorenzo,
>
> I think the fix makes sense. One thing I wanted to make sure
> I understand correctly is the distinction between anon_pgoff
> and vm_pgoff here.
> Is the intention that anon_pgoff should be reset when the
> VMA becomes unfaulted, while vm_pgoff should only be reset
> for a truly anonymous VMA, since it may retain file-offset
> semantics for VMAs with a vm_file?

Yes.

This is to account for both MAP_PRIVATE file-backed and pure anon. But to
keep everything consistent (+ simple) we always update anon pgoff for
everything.

>
> Thanks,
> KunWu
>
> > +	}
> >
> >  	/* Because we won't unmap we don't need to touch locked_vm. */
> >  }
> >
> > ---
> > base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> > change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
> >
> > Best regards,
> > --
> > Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >
>

--
Cheers, Lorenzo


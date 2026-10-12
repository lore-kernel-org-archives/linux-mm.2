Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1720CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90766B0096; Mon, 12 Oct 2026 06:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A415C6B0098; Mon, 12 Oct 2026 06:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956D36B0099; Mon, 12 Oct 2026 06:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7479D6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:38:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E608F80AE8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:38:51 +0000 (UTC)
X-FDA: 85313626062.23.6DED00F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4469AA0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:38:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZiF1tFe;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791801530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFnB4oYeE4bCYumly+rJWCEsU2f7HWQlu4FsHLMDoto=;
	b=uAY1msUsLGM8mFYVb3ob1NhFXAPKOooHf4b6UYiar+gF+v3SkXgfgfv4UCbG3yfvWOox66
	pIj5j3szBffEp8Sdb9xYeJ+Czfuz6SiU9gVE7DscSrB5j3eJIiKll/lTKAkOivbIZr0ofH
	bSKkyV9MAVHca2c0653WQ2tiW3J3Ii8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZiF1tFe;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791801530;
	b=UA1JwgbUskX/PonyXQ/WB9cR1WGb4tULDN0mT47gY5KFZ8HoqricxzN/mP8tOK/8VPcNHr
	afniMuJe6MDMscSzN1YOlBCrumC1YAooxUl55VYy3m6lVDDeCZfJekQfzbKyQMjw9EEUEa
	C9lAXqKrh0n5UBT1ihdu0FcuCVLj64Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C8DD601FE;
	Mon, 12 Oct 2026 10:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A381F0089B;
	Mon, 12 Oct 2026 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801529;
	bh=OFnB4oYeE4bCYumly+rJWCEsU2f7HWQlu4FsHLMDoto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZiF1tFehsP4WXztH/9d6Tu+xAod2MoZ3xbHyNv++uPsMRjEEEqOGDO4S6XHJUsWM
	 II+kWz1cB4zhBB/8koRmGag+WfhJEX1AAOU6yHPAaQ2gsklV+P/w8XtQbgaM4y/OVr
	 TyNJqfiVlUYoakMjg8aAzEc1AFqMNgnBgoyEk3vQjqvLKj2pCo1JNpQLpigrAsJzCE
	 tJRl+OqTXYOvhlipnx4I52OYm4TE/72tzUgMn2imr3cMxVebwQO8JgA/i4GecKq6+p
	 9yIsHGyIlYPsy7Smg8d2HkRJRQ3wDyK6yXyrPhUff4/wWE1kr8xDNvBisK4jTNvgRr
	 udS7zeCoqGCnA==
Date: Mon, 12 Oct 2026 11:38:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <asy4c7zkkmSRln1H@gremlin>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
 <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
 <asyy7Nwik5yMTNbo@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asyy7Nwik5yMTNbo@gremlin>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4469AA0004
X-Rspam-User: 
X-Stat-Signature: 9azenb58dzdej5x7ob6pb7qpgzt8o7qa
X-HE-Tag: 1791801530-435344
X-HE-Meta: U2FsdGVkX19hMYfI4x72EW8wY6o/xvrT51ZACTb8wc2RWq+mIwR5eYm4B+tD+2CPj+oHOaKFsg8oSyoBEMMLxfrxclisbUOeC3BMnkCBgRJqd9zFL/GoFVMMlVYEprvwr3R+uykWeRchEXRphhiR2N+M3ZYJfA4XzIbKg7YIqKo+jCHG5HYdc03wUx/2oigzyRzqOal7y5CRposy0fzKt+nboREObAU3KM/3x+O2gDQnXnNbJ7hRt5bgqZeuWUmxBCoZdutc3j7ZW9NXRGx6kVl7vPlNqxAOztyV3kTlernWiWny4bPPrRtzuOS0PUfI5v6jthPmC18fCXhg92TkLb4ZpFuJve6TeIuyzoyLd2oK77TJjTejUGH9HcpUe69kbmigYmFGx7raxdbyZgCL0EELzvx3rliml/WHBLz2xQzniZ0Roxb6wTIZTHRzdqQP0Psp657pojxqJ4oyLGczc2eC21WNf1GWPcGi5Op2ogLqUjFB1fppamP/qsWZmlBEmjcs7x+NXQYH1A9WJojZKdtJcjvTAMBa4xVEk+XQK3O8idYro4q7tBnSqhgBvow+h5GZ+m7xnG2rgQDpklSfcbs5Veo/hn+GJjxpgRtejJvU/0Ka6clh1cetWOuioKvT+grq+qOPkKcWUjApJ4qHL16x1898C3kw5BKs61eQ06LObmTpVII4FrT/1A12P49y95B30qdO2zRxn6224FdsbqMgv66WrWv55FqzI5Gt8UWv9Ep3Z2rCSnWKza7jF5qhQOMHgFcGJWJ3Byzm5xtgOCIQrrHPxBnNJrzU0OkOnCFMrHQ3vEBb6QG1KvFdnRm5SHHoeyHfyd562yqEe7GKlzUALOw+R4u7+5+iBBxz35rfl/NimXbt5K0furmAOUpbGCtyfXvdL6U1jtVnC8FuyTLQwdJxrOT7glVxY0nPXwokNsAL5D4ua1yPFtPiJiJEEosSL8enWxDIvyj3fQ+
 RU6PItpz
 l4Sn0CQcMFaPBGiVhY3y3u/8o46MYJicKYBLd8UYkYaFt6D1HW3lKvtfZIGCuu22qd7ATMSonWuaXiLfvvqGaI8tkYhSUdVo2mjuqVunRnA3ZVUcoyto5HULiYTht5981ObHhpTIERpRDMWuTzC309quVLJTqxRdvFUPraZpS9a0ORkVgMh+NusBW3G2FTGtrSSsLGmsFAc7RWpBa84l4kG8XYbasdbj62H0ecDM1qDe+vU0R7WzYGKzZfpBCbuwiryc7E4pxplV0HDBzkYjt0SIqzlHivqmTVBRDRcj4KmjJoribuPv+12ZlCzVJRA6n7rMLX9PWRLkhunj2NNvClis5EIDAvVaYvj8y7xrTO4zdTQnQnLyHmlMQoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Zi

On Mon, Oct 12, 2026 at 11:33:48AM +0100, Lorenzo Stoakes (ARM) wrote:
> -cc slopper.
>
> On Mon, Oct 12, 2026 at 12:09:07PM +0200, David Hildenbrand (Arm) wrote:
> > On 10/11/26 15:22, samarth.colleges@gmail.com wrote:
>
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -426,8 +426,14 @@
> > >  		}
> > >
> > >  		if (!pageout && pmd_young(orig_pmd)) {
> > > -			pmdp_invalidate(vma, addr, pmd);
> > > -			orig_pmd = pmd_mkold(orig_pmd);
> > > +			/*
> > > +			 * Rebuild from the entry pmdp_invalidate() exchanged
> > > +			 * out, not from orig_pmd: hardware may have set the
> > > +			 * dirty bit since orig_pmd was read, and a MADV_FREE'd
> > > +			 * (lazyfree) THP whose dirty bit is lost is discarded
> > > +			 * by reclaim, silently dropping the store.
> > > +			 */
> > > +			orig_pmd = pmd_mkold(pmdp_invalidate(vma, addr, pmd));
> >
> > Okay, you are saying we can lose the dirty bit that could get set concurrently.
> > And if we did an MADV_FREE before, we might not detect that the content was changed.
>
> Yeah, lazyfree -> write means you don't actually free it.
>
> As per the manpage:
>
> 	For each of the pages that has been marked to be freed but has not yet
> 	been freed, the free operation will be canceled if the caller writes
> 	into the page.
>
> This is anon memory only:
>
> 	The MADV_FREE operation can be applied only to private anonymous
> 	pages (see mmap(2)).
>
> >
> >
> > I suspect this found through the help of an LLM and not an actual use case in
> > practice?
>
> Seems very likely.
>
> >
> > Using MADV_COLD following MADV_FREE sounds odd at thirst. In particular, when
> > having MADV_COLD race with actual access.
>
> It's odd to MADV_FREE (lazyfree) then MADV_COLD (deactivate) yes,
> especially with racing accesses.
>
> I wonder if there are other cases where you could get weird races like
> this...
>
> In any case it seems a really hard thing to hit in reality. But I think we
> probably need to fix this because of the stated contract of MADV_FREE.
>
> I think probably we shouldn't have added that contract...
>
> >
> > On the PTE path we use clear_young_dirty_ptes(CYDP_CLEAR_YOUNG) which achieves
> > the same through ptep_test_and_clear_young().
> >
> >
> > ... where we also just do a
> >
> > pte = ptep_get(ptep);
> > set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
> >
> > in the generic variant and rely on the per-arch variant to do the right thing.
> >
> > Which makes me wonder whether we should actually have per-architecture PMD
> > helpers for that purpose?
>
> Is it achieving the same thing? There's an invalidation here also.
>
> pmdp_establish() is used to install a pmd_mkinvalid() entry and there's a
> flush_pmd_tlb_range().
>
> --
> Cheers, Lorenzo

OK, isn't this all moot with Zi's patch? [0]

[0]: https://lore.kernel.org/linux-mm/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com

--
Cheers, Lorenzo


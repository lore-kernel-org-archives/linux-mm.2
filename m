Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C174F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqwlOeXO
Received: by kanga.kvack.org (Postfix)
	id ADEAE6B05B2; Tue,  3 Nov 2026 13:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88A86B05B6; Tue,  3 Nov 2026 13:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DB06B05B7; Tue,  3 Nov 2026 13:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 718EA6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:24:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F25141604B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:24:56 +0000 (UTC)
X-FDA: 85394634192.02.BFAD060
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6604E4000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:24:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqwlOeXO;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/bTOMABqpVamX0NVx1RRz5vWrrSfjlCdmnKrtlIDAM=;
	b=6QmWM8lZ6o+DDUIB/L9uMuPITwv1v9QjhkZtom82jsEHvHqyJfk5wL601B4pwDi5DlCnT6
	s+leBVR/3V7XyiKtlCxwo+UyXJnPDzOZw/mzaAxl6Hb51GfFJySH0yH0E6g5DBSdAZUqOI
	6ZunUrvAXAcJ67SwtDI+RcQAUv0CkSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730295;
	b=wikfSAVcviqSy3TgxAtSaXAwNzCir5lTZWd2ULNO6COy8a8M1KEDOOkC4GJOeh9/ks7NwR
	StiSAKsOTE07DzJI8ZZoDWTTDXfSwKFCqMuxkY5FqvO3bJD+YrzuNIUVFO9dtXoehK1R6p
	3AEApXiPO8OHcjnO/TCPlbOWDKcOvY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqwlOeXO;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD97C6022B;
	Tue,  3 Nov 2026 18:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEF11F000C1;
	Tue,  3 Nov 2026 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730294;
	bh=h/bTOMABqpVamX0NVx1RRz5vWrrSfjlCdmnKrtlIDAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mqwlOeXOwK3RUJrektBfmfynzktGQFdocRd4YrTEiXZefQ9Tp0omcmn52+c7sOj3U
	 /mKCP5nctLK7qlqw/D0/1TcqjhPK7/rqo9KVc3yNnK8CbUkSllsERCgwQ831+IMSpt
	 LaIBfdIJm1RhtXSEnptNpMihW/5hBEd31q9g5JguNI2UMeO0hF3hohHjYXTKKc6Iz3
	 IizGMDt9DOdWSX6etKHgP7WE5qNnvJkwNCdEo+Gl7rHW9SMoodtT4aWVcvYBnbGpEU
	 GgTD9ugSVmyYaZtXxSU+jSdvZkU1SaJae4gekbdZLIJd/uIuls78nFCAKoEPToO/aZ
	 1GJ/sqt3fp++g==
Date: Tue, 3 Nov 2026 18:24:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read
 in do_fault_around()
Message-ID: <auoXIdTpLO60mkEw@gremlin>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
 <aumfvNWiemmuyooP@gremlin>
 <61f8a583-5ea5-4fcc-bf30-ea9cafe94d65@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f8a583-5ea5-4fcc-bf30-ea9cafe94d65@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6604E4000E
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3kf5dfsye3drc1iffddt6pr7p8gpe44o
X-Rspam-User: 
X-HE-Tag: 1793730295-480095
X-HE-Meta: U2FsdGVkX18ko3yk/z/oWAFEp0OjaIiokhSXyrhRBTC2bmLKRc8X7mYSh6yt+TZD4Q1LtfbAfTqKSZBqEuILOTdRkgbDYIcbycl39YDrbPw8qqs7HPgdFFG32I7zcdOLIp+AY1ST4uNdFyhNsqWIP6kXdAikamCb/dSErv13Lm+Jc49fOXOMpbr9n7XBMoHxxd7wHZiEfZjbSca9Yr4yz41UOpe7ksTyovnlxM26uqPDRNy0kkjBbWsGFFSf/62Pqgq/FQYzV8p5vRXroOuA/WuU2OJFeirNvuqUxuRIXmecp3atn3Ie8cdtncBowO2l11phW7Cx9rCBu5uvgSURrKPXhWk0BfcbXcHrKfPPoAl2m5rzc/5kZZb02zTRUV2k2SJx/epUg5Wx7WivAPGhyWMiuj5j76kA40fd2I5pHBY8PRvTPAo5pKFeg9eaIrITHjBqJ4D9W3TvAzv6rdkVSKbd7tvxyykl5KXn0hCBDcas5SLDArTHEnE+hi9YGsa/Y59UZ7uSuYYC4CjrwUPb1+sL0nRlvSahn5rKPNB5Hcgt7BS2r4CSF7r7RAfZVZtA6e2QuhjFUS8htv/Xohy/p0Gh6kWLHktrbdG8ihIqDw2RNHC/324z6ONlVRizHJDYsPYZaJl9bByOxV2uXJD++wKpbFzjTBSE8NCoNwlgfvx9C7HascvErQFBCJIFZrrm+7Eotdq3usXBoz0MHWwU1ivBLDpYhAbK7qIU+UK8nuThWZdjpbwW/pyrfhQQxciEv83BR190jsnzp17e6MSD13AiBV+rSbGZxHerlyp5NHhbwXb2YrhBgnhOs4sEJVEWFn9ZNJ5w75do9U+yrXytWl+4AZVjGHL6Wm5U1FcwqdR7YGetv7aoFgVbu/4U8I01PC0lffsN0Y8rNUjlnBTTzm76ikWFga12EE78ySkTaqEr8hvLeBbd6m/dukqAPw7+vPQsjK0VTLqgGRfw9q6
 3yyyK6oN
 tYPJ7ysWAwyghoBKYaT/yuVn7pDHdfy7R2AmKhqfejPYiSz80RhaRqjm78IfY4o1nrOJqjpkbiVX+KBSEh1S0aeWa8SCFrkXeX5L0CenmZn6rSqzuLJYEsvht3FJtCaUd/pNsmbuqeT6tWqUZT9cSz/NFkQHbKiLgMnIAG9/E7FNQx0lh8TeUYlCKqNNp7AePsiuDcxhmARBPAx/GJVKLylYjd/sR6Sy3HzIPC6xf/G/HzeBuNrmokgCn9Xx8l69lZSWbDge9Yywk41X7dyoBX2R+9/tppUWBOKAOJjGtywMXkaHQJmwcM/+m3dMpIajxCYrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 05:15:27PM +0100, David Hildenbrand (Arm) wrote:
>
> >> +++ b/mm/memory.c
> >> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
> >>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
> >>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
> >>
> >> -	if (pmd_none(*vmf->pmd)) {
> >
> > This pattern is definitely bad I think, we have it in many other places so
> > should probably convert those to pmdp_get() at least?
>
> Usama is working on this as part of separating HW and SW PMDs (he only sent out
> the PTE part so far).
>
> >
> >> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
> >> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
> >
> > It definitely seems right to use at least pmdp_get() here, but I wonder
> > about the need for pmdp_get_lockless() here.
>
> Whenever we're not holding the page table lock we should be using
> pmdp_get_lockless().
>
> Even if they are semantically equivalent for most cases, it serves as a good
> reminder that there are no guarantees.
>
> And that you have to look again under PT lock.
>
> >
> > pmd_none() only checks the lower word, so a torn 64-bit word on 32-bit
> > (i.e. the PAE style cases we are worried about) makes no difference:
> >
> > From x86 pmd_none():
> >
> > 	/* Only check low word on 32-bit platforms, since it might be
> > 	   out of sync with upper half. */
> >
> > And anyway I guess there is no valid PMD in such systems that would have
> > the lower word cleared and upper word not cleared.
> >
>
> I don't understand the discussion really.
>
> No PT lock -> use the lockless variant.
>
> Until we can remove the lockless variant.
>
> Are we consistent with that? Likely not.
>
> But that's all independent of this patch here.

It turns out all of this is a complicated mess, I think I've nerd-sniped myself
into sending a series at some point about this...

It turns out we're as wildly inconsistent on pmdp_get_lockless() as we are on
pmdp_get(), so TL;DR my main concern is moot so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

But for the non-TL;DR... (optional reading, will probably send something):

* Agreed that the semantics matter - and the 'use pXXp_get_lockless() if no
  locks, otherwise pXXp_get()' is preferable.

* But it turns out it's all a giant mess (of course)... for
  CONFIG_GUP_GET_PXX_LOW_HIGH arches you really actually need to also do:

pmdp_get_lockless_start();
pmd = pmdp_get_lockless(...);
pmdp_get_lockless_end();

And that's because, as Hugh points out in commit 146b42e07494 ("mm/pgtable: add
PAE safety to __pte_offset_map()")), you need IRQs disabled for these arches for
it to be safe.

The explanation is quite good:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=146b42e07494e45f7c7bcf2cbf7afd1424afd78e

And then of course there's also pmdp_get_lockless_sync() used by THP collapse
which is some kind of 'true' lockless usage that needs to synchronise with TLB
invalidation against GUP-fast and ugh.

* So I think what matters is whether you actually NEED the value un-torn or
  whether it's an optimistic check that you can live with (rechecked under lock
  as needed).

* So I wonder if we shouldn't just have e.g. pmdp_get_lockless_optimistic() or
  something like that which is just a pmdp_get() in all cases with correct kdoc
  description etc.

* Then we can convert ALL lockless users to using a lockless form without having
  to do the IRQ stuff. Including a ton of the existing lockless users.

* I am not sure why I did this in bullets. :)

--
Cheers, Lorenzo


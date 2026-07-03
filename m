Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A32C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FD76B00B4; Fri,  3 Jul 2026 06:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8088B6B00B5; Fri,  3 Jul 2026 06:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D346B00B6; Fri,  3 Jul 2026 06:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4552D6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:11:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B305F1C7400
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:11:23 +0000 (UTC)
X-FDA: 84947048046.15.839682B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E0E91C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:11:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FX8knPJ1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783073482;
	b=Ar1bbRKD5NKSvQO7Di8T+dNiTaGpYo5mJsNMbY9cKt+j2tXJFbCOKZ7S77AMtzoFdgWC6N
	sfyaZAnQm5Aky52f3DWf7aH4SdGJqQnKWuT/yAMf4tDSqbkg72yKxkdvERPJn8My+fahpv
	Puk1s9uwARRNTaeOTKVC0B5aI9gDANo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783073482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJdBsz/cwfU4w/JyuRZpMKJIVMU41Xt4kzF57y9GFnA=;
	b=dfelUOcHkqoa6wUcRVpDn+tFOGhZDlz6mgqvrCoCe4WYSa/UqdTcE7l2UsvkOOfGFb9ehy
	ZQI8fcyzPlK6jcqOb6hinKfw4PXYeG7iaIX3ZHaBr2FRcKMpq5UBxRofqHJR3/QI0hzzyY
	au1Sp9jbgoTvauA4IBfjsyZG3e4jKZY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FX8knPJ1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88E286001A;
	Fri,  3 Jul 2026 10:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6C1F000E9;
	Fri,  3 Jul 2026 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073481;
	bh=GJdBsz/cwfU4w/JyuRZpMKJIVMU41Xt4kzF57y9GFnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FX8knPJ1LaHX9Ho0qJKmvnxjo+Igu6cLNBzpWbLKrTEFe3vezWGNR1UM5VbpFrxW5
	 1e3cn7biJterKSZn1/Hui8CaIMJNtkh/ZvZf9PZxHVp0OKwDNTAYlCHjcrh+uRwsB7
	 dfeAb5PrdA6ukCZt968+3smf2GmBpDBbBCFkN9tQaIgI8x0h4RBxwPPkOUikGqwLTU
	 onL3GS4uIWzo8CU4MvhXzbPP/KCXvLPb+eDG1LpllpwI81W5whFjp8GzEAd9NeGS9P
	 GKshtCatVRRc0iWmQB76a4EUwxrXNw3bJ4GI3RPG0HXjMwg/q9mRMIJ8rrxSmc1Uhh
	 vIMQxnKU6vc7A==
Date: Fri, 3 Jul 2026 11:11:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>, 
	vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <akeJdxdZXAFb8XCr@lucifer>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
 <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
 <ajO7yI541hphWRb8@kernel.org>
 <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: asei1ixd6odrqdjw16gt3z91tasaywkg
X-Rspamd-Queue-Id: 2E0E91C0002
X-HE-Tag: 1783073482-172666
X-HE-Meta: U2FsdGVkX1/ZQdsaPIJQgj1X9+4tiQzC6denVKEfwinwN1QcPhb1eziLFql5+L9HwtMmuDCseH8JQZ0Y/z9KJEiovyhMstwcLJyro5laJX8J7zK0ZNbOLQMR9BJG1TANC8PeNUFAlXXgxWb32w9hjL6vujmNqW7u3WhIIPVGmZ/Pbdy1r2hEkM9Ph3MaQ7CjtBu0OQi4f8iCowmd8JJzei3QVelQdW278C4NG5r6heov9KGkhLe30x/zPpg+TyI07OBkEYmp8IBiR9dc59SJ+nERtED4B914FG2EZJ/zJNnGcNZCgJ2ead2hN6v0uLBlHG5Ps2pID5LbtktgiJJN7pOfetIAPY+WGKxJu1hCi5MsSCxsGqHkkiO0N4kc9pFBkcI5gZi53DfbYETpkOcmeuiyzgTbUwRr6TfeGX/L+53QmbWUdipJqg9yxXLy9qYdMyViUlR6pp5ePKY+gjbrhzdyH8+cLt6ZZ42fPPRXyNQc0GNTPYTwAaZng2L2a2Qac0+5JilMjYrz5O5lWVZ15AeUxxUc9p7DdEBekvNdAUufAT5wJEU38dATW48fhm2NIcErUXIgjYmYyXeFW3ZSDYXIOzjLs+XZ+s9iTzHWUT4UgFldre8s3mUKNN2vf82ohl7CbenzHir/3hp6yqsJKd5rhGls07a/NFWpUX3ex+OzIROo2Rs0VH7g0GJHZvua8nXFr2pmvf+SG9Zd6M9J6N3yBqpt534eDGX0+WWbqAUBs3stU4UvGSIgFUMQkI9b1oWJaZVNsrF+gzSYFGdLzORVFN5dtZWnSqj3UiPpS5g4ht3ffTmBd3krbI1/4KXnruklRD0/3cynWL+5m9jFjygm6rtq+OrNAYfD4EBVouzauLAAInsnS4vk+/OOgxAUr9PLfuCE4eXU1fZABscia08+4njoxINYmIphyc89CcdUHZT49vYJEvbtSmJYnSURAwJ9pQE72Tdvdd4ZtFi
 hPAOK9Qg
 p9MS7tmp8WEdRrydQbk5RWpC+T+AaOdieNoTzIuqK/IukQz0fCo5A1FkqMbG17XuVrVcbR0aXjKAeu75N0OCRZaVXKE8qzED339uBxciIuZZ21ulcsPkCB+Krm/yxOAbvZsGzW0SWByLum8lHkRr1cdfQgJWK3H6m5PPg7cEaEsf6gE8xmIcT95HcjHlWRGzoMpDkLK7afMRWpjgalYOx9CvglgzBFw9xci8H0Djq3+GtRDKaAEfEwm8y78HVBvkoysTj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:37:10AM +0200, David Hildenbrand (Arm) wrote:
> On 6/18/26 11:35, Mike Rapoport wrote:
> > On Thu, Jun 18, 2026 at 11:25:31AM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/18/26 11:21, Mike Rapoport wrote:
> >>>
> >>> Cleaner in what sense?
> >>> Will be uglier for sure, just take a look at vma_can_userfault().
> >>
> >> I was thinking of this:
> >>
> >> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> >> index 180bad42fc79..8a6803618a91 100644
> >> --- a/mm/userfaultfd.c
> >> +++ b/mm/userfaultfd.c
> >> @@ -2029,7 +2029,10 @@ bool vma_can_userfault(struct vm_area_struct *vma,
> >> vm_flags_t vm_flags,
> >>  {
> >>         const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >>
> >> -       if (vma->vm_flags & VM_DROPPABLE)
> >> +       if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> >> +               return false;
> >> +
> >> +       if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
> >>                 return false;

This is still pretty gross, and it's a bit odd to me that we will now enforce
userfaultfd on ranges that are somehow VMA_DONTEXPAND_BIT but not otherwise
'special'.

But I think that's because we even allow that to exist as a thing and have made
VMA_DONTEXPAND_BIT a little unclear in its behaviour.

But I'm fixing that, I'm working on a series that clears up the special flags,
and replaces the checks in general with vma_xxx() or vma_flags_xxx() predicated,
and which will ultimatately drop VM_SPECIAL/VMA_SPECIAL_FLAGS.

> >
> > In a way that's an extra check for hugetlb, but it will work.
>
> My point would be that we exclude all special VMAs, except hugetlb (which is
> special but supported ... in its special way).

Mike - you said you were respinning, it'd help my series if you respan the above
quickly so I could base my change on that :).

I can send a quick patch if you're tied up also!

>
> --
> Cheers,
>
> David
>

Thanks, Lorenzo


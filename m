Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2932A10ED64D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C176B0092; Fri, 27 Mar 2026 05:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCC76B0095; Fri, 27 Mar 2026 05:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB526B0096; Fri, 27 Mar 2026 05:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26FBE6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:58:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56B21A0841
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:58:34 +0000 (UTC)
X-FDA: 84591393348.29.60DA6BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 234CEA0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:58:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkpO8NzI;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774605513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9mPuyTXDwTsHSL/sxVGogba/6L/7eDESLwZ5y+KIZM=;
	b=2IZJob5O/d6qZ4pRBY2mDaOKTnQ0iJ+O2UFtF9/+9vQuTboqxJraoKipHl/7GYsS6GmEI7
	24hrQDhw7ACanYMHBiWm0WNUtO9xo4xdQ8ZqzBhJ4QEzE7Ew8yTyB5/SIyUNIWf+9iM/ts
	3TPkZYV967ICWZJFilDt0u16z1yk6fM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774605513; a=rsa-sha256;
	cv=none;
	b=tV9KxN6ZNn6s2fsk80hlhrnonLGPmmMV6FtJ8DqX/eJbJ73k9wRmqU9LV+U7U5gtV8VtUn
	wZRzTRWmbM73jza4W7Ka3Q36QurIL5ItscZuyRon4soIMM1TRm4lKQaU126SSkXDU+KA/k
	6huW7aR0JvR0kbGZo2QmYgCMO9+NEpk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkpO8NzI;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16EED4188D;
	Fri, 27 Mar 2026 09:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29406C2BC87;
	Fri, 27 Mar 2026 09:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774605512;
	bh=HMlp22KSsDl9iDYrEn5hV0V+6EovIfXqxc9qo3yaFgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LkpO8NzIzvHArC+61lHOwtelx3cT4v0Uh2Kn8MKcNjFVo85oMHScIXqB89WBePL54
	 J8pbjyVIVRZHXOYRXsTzWd7cipnrb7rNe5kwednYon8n6yoh5iJTIDt84Iof8BVzt9
	 pqbTtoXlkTXBt+7eitowNW6WAeRZAj0X6+yMypxrFdhx2eSAMacJIS130VCTGXUOGj
	 DtPu12np3VHtx7FEF518j4fZC13b+sOA6cJXIb2nW+gpqKTPff8XwltxUowywNpF1X
	 4QQFK9TpWENwfZ8opj9hWD+8UZKHjTY08qZJABAOPEhQp4ysfRTjvecrvESt0VA5Nt
	 3yKuvUnnT2EJA==
Date: Fri, 27 Mar 2026 09:58:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 3/3] mm/mremap: check map count under mmap write lock and
 abstract
Message-ID: <7727aad8-f5c1-479a-9036-3702d34f8cef@lucifer.local>
References: <cover.1773249037.git.ljs@kernel.org>
 <18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org>
 <fsifgilp2ra7cagtlp3x4jmm32plow7wgwfytmvtw7kq5veocp@xvcqplpyw3ia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fsifgilp2ra7cagtlp3x4jmm32plow7wgwfytmvtw7kq5veocp@xvcqplpyw3ia>
X-Rspamd-Queue-Id: 234CEA0008
X-Stat-Signature: wzrxqxjd9qdyanzrj9jua4xrsnaqaw9w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774605512-991386
X-HE-Meta: U2FsdGVkX19DQWHtBf3STXFxNB1CJFJw4eXKVFJU7NCYMCZPN4rbp/7NJdys/G7xQGJyp5/U4SS+304HbIhkQomsUaD19LqOSwivf1baeg1j8IS19NtYLFrOHrtgCkb7hLULfQfxyd1yRWMXGhiN1962v57tzGA7Z2OtazbSnDUKeB+a5bjd+R/BIX0UmCkj0VAYdlpFkPgx7/bNMmL0DnASo1z3a/O0Tfx1YFySfVtjOyHBDw4PohnAgcI13LsXaLqK+TdQth38JQW5O3P7hHBI1BYCyVlRGYVFQCWOHR8thjB300+OR2dg+lmpnPVtOZcpq0yiurezEIopXcxip9U7j+BqcbyZuArYLztpu5RnnC130/ZD8FylX/0IjpTco+iZmMJGCAlmldkmni3cqkYyU7NvxSS1AMJByppicl4evS78X+/5mrm+aYDWPGn1xB98kn4z+yOh7jtV6G4CqU+riCN9IJUFRrsaJn/ifvwz+y20J+hEGQG3f9ZMCNA6NcYKkTdllK5PSx6csDGR4eJCcHnbkq9JLieHktdnRIoEPHA91Tz77Ie4XENkI9PUbkmwo4QmeA5BAhSAQuJmMes1IDwKXVDpZQvXgJVeQdv3J7qhdttyRJBi0AaRlOkVKi50z2op79DHSGmKosudIZk1hVkAvuRZCb35sWr6iYNGD2+9pOjT5/8yZFnA8JhuoR3cr/Xz4Y0kwhaeHPA6w5utTdhdzTzoxJuj0WWaS3iL2I6rsIv/R8o4xZoX3UzPjWaOtKEgTgdEGSVHzA1elrrJCS/7pOjGjmACeYETLbKSetR4fPgq4TCkakWvn2GUuqo/8CoNYPr1zVk56AEKJmNQQOzGUcf+cH+6Ll26+iPJeqhyw4Uvxug7bcRraEhlPpmbKL7TEmax1liya2OkKpf8DB0XRUPz6+QDxVJjfVj8IgzDowfd4aE+iqSxUM3Ug4umcNiEirGprNl2zxD
 D8Up3aoA
 9/UBpD9h/eCJoF8rdEOEGIAFDYyD9xrbwtctPCbrWLMi3yoEPfC1VPdTTIpYx52lryhWZ3oIf0vARXdw9Fng9SN/DptuvtMtJVUQBuiUORKEIj5//PWhHNTMDNeX+xovcOcRsZrxHQm+bmjX0rUrBJiQ2KOooWrRRQmyGmgb8+y05lQbHD9R448g/3Iv5nQhSw02gk2yq6hTL/MKuE+w2GhrkVE+AoWoqocWLLuPwFw334sAzf4hMeYfsczFd9u2DCG8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:22:31AM +0000, Pedro Falcato wrote:
> On Wed, Mar 11, 2026 at 05:24:38PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > We are checking the mmap count in check_mremap_params(), prior to obtaining
> > an mmap write lock, which means that accesses to current->mm->map_count
> > might race with this field being updated.
> >
> > Resolve this by only checking this field after the mmap write lock is held.
> >
> > Additionally, abstract this check into a helper function with extensive
> > ASCII documentation of what's going on.
> >
> > Reported-by: Jianzhou Zhao <luckd0g@163.com>
> > Closes: https://lore.kernel.org/all/1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com/
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> Shouldn't this have a Fixes: and go to stable?

Nah this is really hard to hit and doing the check is just making it so mremap
can bail out early, so it's not worth it.

>
> > ---
> >  mm/mremap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 75 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index ba6c690f6c1b..ee46bbb031e6 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1028,6 +1028,75 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
> >  		mm->locked_vm += pages;
> >  }
> >
> > +static bool __check_map_count_against_split(struct mm_struct *mm,
> > +					    bool before_unmaps)
> > +{
> > +	const int sys_map_count = get_sysctl_max_map_count();
> > +	int map_count = mm->map_count;
> > +
> > +	mmap_assert_write_locked(mm);
> > +
> > +	/*
> > +	 * At the point of shrinking the VMA, if new_len < old_len, we unmap
> > +	 * thusly in the worst case:
> > +	 *
> > +	 *              old_addr+old_len                    old_addr+old_len
> > +	 * |---------------.----.---------|    |---------------|    |---------|
> > +	 * |               .    .         | -> |      +1       | -1 |   +1    |
> > +	 * |---------------.----.---------|    |---------------|    |---------|
> > +	 *        old_addr+new_len                     old_addr+new_len
> > +	 *
> > +	 * At the point of removing the portion of an existing VMA to make space
> > +	 * for the moved VMA if MREMAP_FIXED, we unmap thusly in the worst case:
> > +	 *
> > +	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
> > +	 * |----.---------------.---------|    |----|               |---------|
> > +	 * |    .               .         | -> | +1 |      -1       |   +1    |
> > +	 * |----.---------------.---------|    |----|               |---------|
> > +	 *
> > +	 * Therefore, before we consider the move anything, we have to account
> > +	 * for 2 additional VMAs possibly being created upon these unmappings.
> > +	 */
> > +	if (before_unmaps)
> > +		map_count += 2;
>
> oooh, shiny shiny diagrams.

:)

>
> --
> Pedro

Cheers, Lorenzo


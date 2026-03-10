Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7B5FD88C5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 23:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3916B0088; Tue, 10 Mar 2026 19:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392026B0089; Tue, 10 Mar 2026 19:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2735B6B008A; Tue, 10 Mar 2026 19:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 055716B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:32:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EE828B1FF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:32:39 +0000 (UTC)
X-FDA: 84531755238.23.91232DA
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9858640007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:32:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XeSpIpGd;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773185557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCpMwR+38iPKntKzQHGI32gwKKJyQsqbhF+5Z9Qu/wY=;
	b=EdsDNa42Vpxh4V2LHyOuWR7tPfdYKbf8pJ3N+TpVbqrqYZJmPCrmzI3Gllc+gs9ksfDK2x
	uaPvU5tFSQXZobUTefNCo0QT98Uwwhn7j9V7oZdpIHsNB6Vw/nZ76zAgT5TNRRGqNc6oY3
	JOrd9As4Zy2F1zRxbkQ8xPWf4W/nuvw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XeSpIpGd;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773185557; a=rsa-sha256;
	cv=pass;
	b=QbiAn4WbuGFJqc8x0kHefnwQHfZfMTLTQIsPC+aDZXLIjCyzrvGTJClNySCQ3Fi+2r2laq
	vXZaEEhWW82PgCllFilwAa94pl92pY42UFxy1SiQa6WdrOY53qmgr2E8FW0Lx6jUGcbL2s
	3kUYyXAiv5dBIjgbD4mkMSLsCnEWHdo=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89a1347051aso144951036d6.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:32:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773185556; cv=none;
        d=google.com; s=arc-20240605;
        b=MABkOLej6EcGYKRDtWv1jehLaj19sJdEqMyttrd28uufDR6EEk4c8fiW/HkskJF7DS
         /2hKVoD3QkgjIxDc6pXqiUky1gq3H62KQyEBpl+f+gFqLWT50Y6oacltltyvzDx8pxKn
         ulbTE0w8/MzQ7UWfjXW+4gFFhAZAGlGwy1MvmiHk/1Nxgf6BbsF5d/RUs7dfnnYQBig2
         zFxKApswp6yxm1BeGhLdSr5ptVY98/h+6D8sMvIuWByn6IMK3f95Hju2BkgsKq3KNOwV
         poJdpIXxw3+Z/lePkUYCgclZK3Ozla4WJLw5p52EkpTm+qWO/sH+cx9Nq0EBdR22zJTP
         qFnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MCpMwR+38iPKntKzQHGI32gwKKJyQsqbhF+5Z9Qu/wY=;
        fh=IuJX7/ei4sclQj2NIKxk0C7eBxSr+4v7FgOoFfseB50=;
        b=IYlXRcMmqqFhyVXizhSEJO5X+JuIWsSpOOD3BCYjD3S6TLQEtg/mdkjjMAYLnrJlZC
         JhiKn7R65dIWpgdJcQDQLNRY9HgYn6DvesfefaFLq1YOn2GxtjqOA8j69JAtDUJq8RIW
         pivpZTCadKnNQZSgUbIus5WzLWO4Yav4u160xY6zPqO6/tr+0aDB8p0el5nbKvvS46uR
         /22mCJC7/79H7FUt0yNZgxndKRRnuDjrs1H+0zGvyg06DZJIF5ErNFLIILig6o+ln9Fa
         OUlBGeM0AHRm2NkBUpygd2zcvm4sqkDJfg1tymXa8J7GPX0AQE/MW3XtegIjW0NwEwvO
         91Nw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773185556; x=1773790356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MCpMwR+38iPKntKzQHGI32gwKKJyQsqbhF+5Z9Qu/wY=;
        b=XeSpIpGdgPVT/pz9eJv2pD1FTykdfuNurgUhcRF9Y1VdM5XGyl3ebmuU/zHerAdX6Q
         UDh0csvm2oQx8VsZeL0fioiY5fvq8DA345nEO1UlV+WMvFjAfF53ZvynJbw0B9xDdf9P
         ipy9Nur6J3/3haR9cW0crH/I7Z2+Lqs+PrwISftA6AmQYjv7U0TT/cPkpME0O/CO0IZh
         GsZKnFsVm8aGR4+1IkxoB4GCKt3dTARSTAUty3064pzx2OgAbtpeiPs1V3LQhNbPycyb
         QBjeV03IRxn+9nxLb3vkZwUghLCxdI7O9UOMh11+jckrVKitSRh//VCzgoTVLK1IJzYl
         d3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773185556; x=1773790356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MCpMwR+38iPKntKzQHGI32gwKKJyQsqbhF+5Z9Qu/wY=;
        b=WOZ9na6sLrCFDBujOtgHaRt35gZ80z8+Ju04TWQqa0bTwTRddCRcwionFLJ9KcJWIg
         Gbc3KtQsO+BsredU6LBeaL93kjgpAMRieSAMdnRNYjm3mGrdhRnBbnR92d48FCwwGHyK
         fX8ywpFkacdbUGVwHOF8y3bfBOXdCP/tlvc0lPck1NINe5QckaObYquUKmapKU/6Hylw
         VCVzYQdRDdXLycc9ozPFF69vYGp0SpZXBLWd6DA+0EP2M7buKU/wApX8yjkZCZaEfvyg
         MvICGuvZj3Q9+1yRB4LdiH7O+VL9F3UHJrbQ334o10LXXsFH05YaL2qUStORvSGPD0N4
         HoNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbZVkUJPhpsdN9GBrM+wQ4xBvstkmplVl8ByXomRf1918YW/yED30oJyPv60dw3KWaFTxxWP+CXQ==@kvack.org
X-Gm-Message-State: AOJu0Yws0R+R1f14P6SsyXKjQU2sVBJ7QyiDcCFzKUdOWVrONDasLRcj
	8O+RmSlm3IU1qgK6iXiS0rO6S9TTASc4c2RjNr65RmHdn6lKOf0/wvCbinLcbha6z65xRgQHFos
	4bGe7MI7vRvnakKADhyNFZQsI9mpVm+8=
X-Gm-Gg: ATEYQzzO1nwBCIK4Uav/9aPgjVTDKvma7jr8fgO5Q/1ep0I+uqj98kGQwG7HBq5SWjN
	7ZLHIs9XqBnZg4Bf/DpOcckRPtQAnTyNGpNaV4fHvybDV1ekPaIqNqUiJpL8xkPP7jwjbm3wvUB
	Ad/QSCJvBsLQaNwtDkbXay9Us52RlxOgTmp7pRODVl3c2GuViBN/N3tR4t1j56zCsgBVWKRm5KF
	QpzapToUcONh3Djsc4dSn9HYfgSe/nJHS88XBmiVJNPR8StB96U5MKk956o56vri0caz62aXv9/
	wIqxwg==
X-Received: by 2002:a05:6214:2685:b0:899:fc48:4e68 with SMTP id
 6a1803df08f44-89a66a2537bmr6735516d6.4.1773185556234; Tue, 10 Mar 2026
 16:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260310073013.4069309-1-dev.jain@arm.com> <20260310073013.4069309-6-dev.jain@arm.com>
 <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
In-Reply-To: <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 11 Mar 2026 07:32:25 +0800
X-Gm-Features: AaiRm52xr9USne-5dvsLnM-mz9KIH4O5OtICvbE4X4qDGVFnSkKZIp2Z8ty1POE
Message-ID: <CAGsJ_4zMQReykifGVmXJEgPqORhRoFBKKJq_bjBzDGT5hfGGwQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9858640007
X-Rspamd-Server: rspam07
X-Stat-Signature: uzg9sn4ktbfqq6fyizsad8ifmkeo4s53
X-Rspam-User: 
X-HE-Tag: 1773185557-771287
X-HE-Meta: U2FsdGVkX19fD4Ytn7aTd/ABhdn0A9JaLixdgZxa6VkXqcfS22FkYwlutBEUyWJrAHpqAtXKM/4YR2tqdEAgc9pVpAfOQ/xgq0PERegcK4WGR9yI5ushl7/KzsYk9NvVJRxNkP7ulkRQpDbcjIqLgqZZb7PRDHEYWuRIpORZgHKw41gkhiVNUrTPUCVXQiGAKxCd6wlYdQcrwflgk8JISPLgZqh9AYQueUzUditKNQYajcY8J1cUdDEITFDOuEdR0HquwnIeEJqOqwT5rFPhAlBMp1GL/062gxoautblG1K0Rft6bMvwloYC8vrS2zX2tlJ58aJ/raTpNvmMnrl7i7JSVdNVzio+6DPCqQgoaHSIYlCQdnQ5Evn3qKRT5afc3Z6hcg3szz2o19ALJFg1NT+VmZCuJAQI3vNUoGyw2rXg9Y85c0lL1C27Dh2rbDvvFoLJtlX9sknJNyWQ9Z4ORMwNaLZtQz2gxdlB72sKMBAqheW2USub25cLTB4rdlL2SGmFvBRFyHq1Q38k9Q9Az7THul4yYE4enN4EazvR6wWfpX+g6rtd/Bvg8AVmOK0UuVD8mX7APTKtAroYrtSrQ5SD/HXE+fTdXvr1tUPqSsmUF4OElEbaoATlVOCZqRYbNAtreyJHmfT+Mo8gMngKne3z4edY6ytwebIDU9iBsXIOzPOha/rR4IWGhZNGB3z+v27LNpU+OvSxFmxRR3NeEPZQZpklpeWeSlnipSupZYD1Ea72bOrpc6L6OTlvpsPlE1goSCHummVE+beAOuINR38FzV+MZ7zPK94/uh0oMmF9LzWOqx+NtIl8B1eCYKXCMOU5ZgadCYyBe6ROYrNJgxIQCdXvkSBjbT52PHiOSMLqQ0a2VRBGBNyKOYgZttP2l9mVkFfbsPhGTXWZuxvkkZzCpqvRxWxbjqAF7e7pnEQwr8ezipjQ72VtZQfVsdPxL9RtSewXJYnTB6/5qah
 ++YtaLDq
 Kmj8sErPU5xcnu5bhvS4nazGGzAnmeoOV21eBwBVHAqUek9+lfIkKidzTCy61EBQdkrpvFMIdwF5LIVFd6S7eGCaRmJeIJ3t8boijyec8dho+PIDMl9L4Jl2GxXwBNMH9e2acI6xTjswJ1znVuA0GVfX2zhpf9xjsyW38MFXFEsOj8zeK+t1mTEQ1rz2+wGD4juHjXanuZwZFU+9VZ0LQ5BAruzPAwh2aB1udUzFb2gTt1tuHQee/IQjY/R0O9uz00BNAWyLt+iq+cg7favY6iyrkIWuS2pdmSbjV6qBMqe8ZuuEXIETHVHq13zuYI6u311ySd6xLCYc4/AoGE5vaEFMhkAkeyLXc3dJB9/Qgg7YezE452TP3f/heeuaQdeptU4GqwBxRKHMxMP+48GBXRn6r/e7iyOSAw9yvIzyIPS2EpH3nOESGzUs7FFcEv8mlKEDX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 4:34=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Tue, Mar 10, 2026 at 01:00:09PM +0530, Dev Jain wrote:
> > The ptes are all the same w.r.t belonging to the same type of VMA, and
> > being marked with uffd-wp or all being not marked. Therefore we can bat=
ch
> > set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enable
> > batched unmapping of folios belonging to uffd-wp VMAs by dropping that
> > condition from folio_unmap_pte_batch.
> >
> > It may happen that we don't batch over the entire folio in one go, in w=
hich
> > case, we must skip over the current batch. Add a helper to do that -
> > page_vma_mapped_walk_jump() will increment the relevant fields of pvmw
> > by nr pages.
> >
> > I think that we can get away with just incrementing pvmw->pte
> > and pvmw->address, since looking at the code in page_vma_mapped.c,
> > pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
> > and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
> > cancelling out the increment and decrement in the respective fields. Bu=
t
> > let us not rely on the pvmw implementation and keep this simple.
>
> This isn't simple...
>
> >
> > Export this function to rmap.h to enable future reuse.
> >
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  include/linux/rmap.h | 10 ++++++++++
> >  mm/rmap.c            |  8 +++-----
> >  2 files changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index 8dc0871e5f001..1b7720c66ac87 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(struc=
t page_vma_mapped_walk *pvmw)
> >               spin_unlock(pvmw->ptl);
> >  }
> >
> > +static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_wa=
lk *pvmw,
> > +             unsigned int nr)
>
> unsigned long nr_pages... 'nr' is meaningless and you're mixing + matchin=
g types
> for no reason.
>
> > +{
> > +     pvmw->pfn +=3D nr;
> > +     pvmw->nr_pages -=3D nr;
> > +     pvmw->pgoff +=3D nr;
> > +     pvmw->pte +=3D nr;
> > +     pvmw->address +=3D nr * PAGE_SIZE;
> > +}
>
> I absolutely hate this. It's extremely confusing, especially since you're=
 now
> going from looking at 1 page to nr_pages - 1, jump doesn't really mean an=
ything
> here, you're losing sight of the batch size and exposing a silly detail t=
o the
> caller, and I really don't want to 'export' this at this time.

I=E2=80=99m fairly sure I raised the same concern when Dev first suggested =
this,
but somehow it seems my comment was completely overlooked. :-)

>
> If we must have this, can you please make it static in rmap.c at least fo=
r the
> time being.
>
> Or perhaps instead, have a batched variant of page_vma_mapped_walk(), lik=
e
> page_vma_mapped_walk_batch()?

Right now, for non-anon pages we face the same issues, but
page_vma_mapped_walk() can skip those PTEs once it finds that
nr - 1 PTEs are none.

next_pte:
                do {
                        pvmw->address +=3D PAGE_SIZE;
                        if (pvmw->address >=3D end)
                                return not_found(pvmw);
                        /* Did we cross page table boundary? */
                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) =3D=3D=
 0) {
                                if (pvmw->ptl) {
                                        spin_unlock(pvmw->ptl);
                                        pvmw->ptl =3D NULL;
                                }
                                pte_unmap(pvmw->pte);
                                pvmw->pte =3D NULL;
                                pvmw->flags |=3D PVMW_PGTABLE_CROSSED;
                                goto restart;
                        }
                        pvmw->pte++;
                } while (pte_none(ptep_get(pvmw->pte)));

The difference now is that swap entries cannot be skipped.

If we're trying to find `page_vma_mapped_walk_batch()`, I suppose
it could be like this?

bool page_vma_mapped_walk_batch(struct page_vma_mapped_walk *pvmw,
unsigned long nr)
{
...
}

static inline bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
{
        return page_vma_mapped_walk_batch(pvmw, 1);
}

Thanks
barry


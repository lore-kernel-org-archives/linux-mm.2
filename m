Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DA2CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693CF6B00D5; Mon, 11 May 2026 14:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B716B00D7; Mon, 11 May 2026 14:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5819F6B00D8; Mon, 11 May 2026 14:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 474C46B00D5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:40:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4612A0207
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:40:29 +0000 (UTC)
X-FDA: 84756004578.29.2CA1F26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id B28DA140003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:40:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9lYIyb+;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778524827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7PjaT86rLSq/wvh8w10jHQ+W/AM+3PbiJmxdsDhFVc=;
	b=utTV93+A4S87OHdBxcT4xAXkGU0X4g/mTjB522x6tGQRoHjTlENFVjZFZPaDiZQIH53YUz
	J5jTMHpf+A3JkG7ZScqbss/aqW/yC/eGIV0xTlMKL+P8B4fSI7Teljl7rfQudBSAPFev09
	glMcGuqz69CjM5blqZ2ZTk5+I47LDDI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9lYIyb+;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778524827; a=rsa-sha256;
	cv=none;
	b=AQozYI/jopj8DH0eDP8w7YqSft2a7fBFGTCiBXLjz2yQDSzdUqXIWRa57Sm8gNj1EAg47D
	fgU4/m9PUA2gQPovavu2XrD2Kbu/lf+KZzNLXXLc78BZYpCf1KwYODbBLux9HQ4TgxWUYh
	vAznqQ9/z4sV3+F3zkcyF5R9Jwz74ns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778524827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N7PjaT86rLSq/wvh8w10jHQ+W/AM+3PbiJmxdsDhFVc=;
	b=c9lYIyb+igx7J5jpx1vI+X1gHpKT3thsxmxUAjYP53U8DbUCmXPwQaNN40jIVxWljKK54z
	ZYMIbx4b6JYCZgl9PiskWeqRfRa5PwtHK1xVPybXU7yIbz8gbuhK4RXkD9M/4YJ5VbMO+N
	gXTpdA+EZYUFpsGvpu6fMvOGYWFBnYQ=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-Wyu8kDPQOsCQm0tNJfMv7A-1; Mon, 11 May 2026 14:40:23 -0400
X-MC-Unique: Wyu8kDPQOsCQm0tNJfMv7A-1
X-Mimecast-MFC-AGG-ID: Wyu8kDPQOsCQm0tNJfMv7A_1778524823
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-65c5afaff48so3058638d50.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 11:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778524823; x=1779129623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N7PjaT86rLSq/wvh8w10jHQ+W/AM+3PbiJmxdsDhFVc=;
        b=CfPnlpjhrIMJb0CaTsGeTQRewAkMObssRq2FQV+IawkefIFOg+Uq1pkf+JKmp4jdPe
         4K6y0M2/9Et+cQ7bGsYeFmXqy764eNHyjd7cVidhKmIiKHavnAfASZ6VnYXQBZyJEvOl
         uev6OLqZsPnTOnNKwIZedoaiFcu4nx8IN4oVsg+2FoMvuy1OeAxZkiylFwuURsZP/Gdq
         7+1y/4jY7FkJOtjoEBog2Fki+kOXcZ0w8snEh5pdRIw9JEUofiEXNGQLVNDlXv2DQ2Rt
         vYVu3Zwv6zEX3LecPJoellWIRRnkVwU/Ely5OkdQcLgCpCzgYvMgRe8+/zoFIMOdJBa4
         inzw==
X-Gm-Message-State: AOJu0YytKiY3IG8neL1LN8ykCZjoTBOcB/bOWg5Zjn9+ZfKT6fgpvV5y
	QltCag0ugI0VAthARgiv//ki0XFJSlQcs1aHQ1dRH9adHgr05i8jBftIeMPkLgc4kofId5O7YCY
	gWsml9vZGfpQCeg1Z0s1kK5LLNIySkasbBZLxxteFOI5r3Ri2wc3BC9Dzrxd36gJUwe3LobSgzc
	lspXVrchS1yG+pkcweuWqgtS8ecTY=
X-Gm-Gg: Acq92OGPV247+xEbEwk5utNtDx7GiW4L/IoBRaZBtUHcVnDHEu+oDz2Fnxh1GHuA/EO
	GLSwS1DR5lq4B2QozCiauNAY3Doo7qQ6UaXCEEq8G9KPc4j+g8jvhjAknmFggz766DInMDwfh6D
	W3AMyfZJipEV9iRaCenR4MPGly2pNq+E0W1Djt0Xp2YJ+BJ2+GEPbkGdsyroj/2c9E6XRq7iDrb
	Fg0
X-Received: by 2002:a53:ac8f:0:b0:65d:29e1:970b with SMTP id 956f58d0204a3-65ddd4c7f63mr686799d50.14.1778524823024;
        Mon, 11 May 2026 11:40:23 -0700 (PDT)
X-Received: by 2002:a53:ac8f:0:b0:65d:29e1:970b with SMTP id
 956f58d0204a3-65ddd4c7f63mr686776d50.14.1778524822552; Mon, 11 May 2026
 11:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260508170509.640851-1-npache@redhat.com> <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
In-Reply-To: <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 11 May 2026 12:40:39 -0600
X-Gm-Features: AVHnY4ISWhiPJ8fzS5vL983bIVOVwmnR6AB7eNpUFjNmAbPpvUcJV6ruamrg6IM
Message-ID: <CAA1CXcBGEUUzUYdot9j5ftNrwhxDa+2C-aOMCtKfUBEobHP0Wg@mail.gmail.com>
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org, 
	akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0ZocJkVfRMQP7wGQlZtxbeEA3bwjU3iLejUhTJUFFc0_1778524823
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B28DA140003
X-Rspamd-Server: rspam06
X-Stat-Signature: ng3jqe1njw87hxm911a8tykshc19jauj
X-HE-Tag: 1778524827-297125
X-HE-Meta: U2FsdGVkX1/6dXktmYrIYBf6WzfDZtmNVdD/L09Qx9mLPJIvvo5nR5OQJ1agyR4on2QDjsn6n+kLen5HjKUx/sE1twZEXtCf9XDlElFQzh7lhwWwIud5XD1tNnPExFkp2rlnT0x3LUSphPinM4P6fICGqDOyr7I5qtpOSUxzoNfXftM75zYsq1DTwtkCS68fcHDPrl/4lAn2IGqF20ssQbCDI0ImouM1BkaH+S1tqGwzlNjH+K/uxg51rCZRqG3UyNkKwdlst6hfIMJkbko19wc9wmAs9s1kdJQfsZfmMREqUXLqw3pl0Pm6GPCkVQF8Mrrvy3gqGKLvxTuStOnX7LkmAJ2UKiNOTW1fF4F2AOSJM9RM09hSU9ev/pscT9NYlwivr5vVx3+a4omjkm9gu3O/BKGaNOQNAeFmUSpfPe8IILVKeCgsGRIVk+OpKjD5v84Weth6RTt8yUWOX2lj3HIzd978EhAoBA0EJszeG0qWaacq1sKSZ55IyoCWToIgRbA1ZaIbwzRhfPZVUTcWRPNCZ0PKJ0dzPWW7Ws4hGdlf11iGuZtXB3Cz96dGTIXeIcLAtT5/Nhu1eldQNHoqoYKEcmbcCtQ3ADUFLFwWmXYJn0xq7hq8LanFL16gl8W/Olmw5zVWoO90GIRQH4zU9Gl2YrvvUh23vV5fN9LVwPQ5zuavMqLPUPaxacVGvphBja6MTg0+XGiTei60VyUsjXYZ3t+E9J6egiZwZT91Q1peJcfaOXH1CrGhgFtu48Ty5x/+7N8CLoE3rK8gymZxhVtRF0joJxydjd9Rkp5HyPsCk+uRA5XmeoKhu76s8MuAssmccJAnyQYwjEF+unPxKh8OftYyBrUDM5faX/6Wa38uNiCliz/HfUp5ELYDNDFKemniRbl1EYUuVpGTMlUTJt+LBFwryP+bsH9WhPL3oAHaetxqe6bRghAe1Wda3cCXi6ES5Q4SKC+n1zlLrzJ
 hDZA96xg
 lensfzDIfQNOr2xuUYh4hsoIyrvcJ6Mibd1BnZnIg1+SZL5jyDgDQ1VQbERCvHUzdDZ37n5OW0X7axzim7tmrFVig7xzhEOuyvdpQjcbkBdTgHVnqtwxtXvxvJDfVsmCFa9RxMTM+mYJIqVcsYLnSAMKxprSjazdtKRbu/vXvqjRiftZ8sKgywZ9IUwd+RZAyObkm5QZ41KDdpcs9df/SUF9YPHv0xZ+65USRID4v1mfPFPb92dbI8Cp58RwVoAl2Q0m+IXugkIQyW6qrxYMAypscDsmVZSY/flvDZBrmuArGRZqxuMXJIJSs6dAbiKiavZsboRo/wQE0td4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 3:32=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 5/8/26 19:05, Nico Pache wrote:
> > Since commit b1f202060afe ("mm: remap unused subpages to shared zeropag=
e
> > when splitting isolated thp"), splitting an anonymous THP remaps all
> > zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE=
.
> > This flag is set unconditionally for every anonymous folio split,
> > including splits triggered by KSM.
>
> And even when the underused scanner is effectively disabled on a system. =
Hm.
>
> I don't quite like that we scan for zeropages when nobody even requested =
us to
> split because of zeropages.
>
> I can see why we would want to scan for zeropages in a setup where the un=
derused
> scanner is active, even when the split was triggered by someone/something=
 else
> (below).
>
> [...]
>
> >  /**
> > @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned in=
t new_order,
> >               struct page *split_at, struct list_head *list)
> >  {
> >       return __folio_split(folio, new_order, split_at, &folio->page, li=
st,
> > -                          SPLIT_TYPE_NON_UNIFORM);
> > +                          SPLIT_TYPE_NON_UNIFORM, false);
> > +}
> > +
> > +int folio_split_underused(struct folio *folio)
> > +{
> > +     return __folio_split(folio, 0, &folio->page, &folio->page,
> > +                          NULL, SPLIT_TYPE_NON_UNIFORM, true);
> >  }
> >
> >  /**
> > @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct s=
hrinker *shrink,
> >               }
> >               if (!folio_trylock(folio))
> >                       goto requeue;
> > -             if (!split_folio(folio)) {
> > +             if (!folio_split_underused(folio)) {
> >                       did_split =3D true;
> >                       if (underused)
> >                               count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
>
> In general, this looks clean.
>
> But imagine the following: someone splits the THP for another reason: for
> example, because migration is unable to allocate a 2M THP, or because we =
have to
> split on swapout etc.
>
> Not freeing the zero-filled pages means that these pages cannot be reclai=
med
> anymore easily. We split a possibly underused THP but didn't free the mem=
ory.
>
> The only way to free the memory would be to wait for another collapse, an=
d then
> have the new THP be detected as underused.
>
> Hm.

And what was the expected behavior before this commit? Did we just
deal with the wasted memory?

>
> (1) As you say, the alternative is to let KSM say that it wants to handle=
 the
> zero-filled pages itself. I'm not a the biggest fan of that approach. We =
still
> have two mechanisms interacting to some degree.
>
> (2) Another approach is to just let KSM handle this in VMAs that are mark=
ed as
> mergable while KSM is active. That is, we check for VM_MERGABLE and ksm_r=
un =3D=3D
> KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do its t=
hing.
>
> That really just stops both mechanisms from interacting.
>
> (3) Yet another approach I could think of (in general) is to disable the
> underused handling in a system where the underused splitting is entirely =
disabled.
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e9d499da0ac7..5eca99271957 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
>  static bool anon_orders_configured __initdata;
>
> +static bool thp_underused_split_active(void)
> +{
> +       if (!split_underused_thp)
> +               return false;
> +
> +       return khugepaged_max_ptes_none !=3D HPAGE_PMD_NR - 1;
> +}
> +
>  static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>         struct inode *inode;
> @@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int
> new_order,
>         if (nr_shmem_dropped)
>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
>
> -       if (!ret && is_anon && !folio_is_device_private(folio))
> +       if (!ret && is_anon && !folio_is_device_private(folio) &&
> +           thp_underused_split_active())
>                 ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
>
>         remap_page(folio, 1 << old_order, ttu_flags);
> @@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
>         int num_zero_pages =3D 0, num_filled_pages =3D 0;
>         int i;
>
> -       if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> +       if (!thp_underused_split_active())
>                 return false;
>
>         if (folio_contain_hwpoisoned_page(folio))
>
>
>
> I tend to like (2), and maybe (3) on top. Opinions?

I don't fully understand (2) but I definitely agree with (3).

Isn't (2) similar to my split_huge_page_no_zeropage() solution in that
it only disables the behavior for KSM? but instead handled much
further down in the call path? The "fix" commit sold this as a
solution ONLY for the underutilized shrinker, but it is not that.

Either way I can test that solution. It seems clean when I gave it a
second pass; it just seems to be hiding behavior deeper in the code,
but at the proper location (the function that checks whether this
action should occur).

Cheers,
-- Nico
>
>
> --
> Cheers,
>
> David
>



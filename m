Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F1ACA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958028E000A; Thu,  4 Sep 2025 12:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FEC6B0008; Thu,  4 Sep 2025 12:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845F38E000A; Thu,  4 Sep 2025 12:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB496B0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:32:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F1361602BC
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:32:21 +0000 (UTC)
X-FDA: 83852110482.08.3D5022D
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40F7D4000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:32:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t6bNpHBB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757003539; a=rsa-sha256;
	cv=none;
	b=5NU4f2hZorhnJhc2EpxG8u3e9kSjksoaXjxgtW7eYOTdF4s6/hgqe9wTT3tXzQccZQqEWv
	aZUOdRjA/T3U6E1iU8cLi1qz8b44qFvL5P6PHwR9FYfcz1qgBx37sls1eL9ccImvk6xxrA
	taBXEfJb2Uj5lQWQdGu11miVKTuYQlk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t6bNpHBB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757003539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvquhskjT65SmB2Nkm7CV4QXCHw4k05+VhhCF0jbgfg=;
	b=PHDapVA6wkzjC8NvlvbD49RWUBXodZZt93HyHzhMN5rGUzALF7yaU9Sz2p/bcAb0rJBDAM
	dsioA/4KNLZAlw+P+tR8HPkq3AhR9rfefFRxniOpY6Xr0JL+bOlep+MMc44KVpp379gPER
	CzzuubJkxlX5o0WcYqKrUPoE6kLX8q0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24b2337d1bfso2135ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757003538; x=1757608338; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvquhskjT65SmB2Nkm7CV4QXCHw4k05+VhhCF0jbgfg=;
        b=t6bNpHBBc1xQU8txmXFeckWs/AGMKKujozio9+gX5gv20X7+3qjop8OdHZ8xd9MwjR
         YY/uzBecT0p7xeHfZ9Yh5a/GI25MUllv7IqJjp93B7qCLwMvprAq11vnwG9BPmsHOrD8
         spjZAqfgmpmwRugzSaAIdomotgi0YsEZ6OqKCD66fulOPC72OvMHTkg4vpyZy9uky8Ms
         lY1KbPsDqHaR1BuFb4NvOJSZth+1woeigBogpfGZGFoBSfI+pwK3/AI4Nqbc1dHvVS34
         lHbMsllUt6a/+WLHK/HFj+aRl79vbh7QEqx7HJ5RCuszOOTvHPXbgHoO9J40fHIjyZ3E
         h4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003538; x=1757608338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvquhskjT65SmB2Nkm7CV4QXCHw4k05+VhhCF0jbgfg=;
        b=p6LZW/GiHvaYjOsuomb3EhLHhr8+c9NLl+0X+XIeh8Nb6ZQ6+M4vRxg6Th/B74jj0k
         ScH947MF7JxiwnOfXWEXfRHNdVHdt3rk2BycYaOezvpJAWA8wnHITjNd8FRPcwC0pcr4
         R7NutJc4ICRI0INRqD54dwdiEXPvuQygjv7qZnZNbjyxIFomIv2Qgb1VG6hEchWsrf5q
         pzgZLsjGLtT/FiIMwUa2sZ6zWRGPY1JaqVuH8hm142fgUGMLRePXtzpCsr49KAybZ/LZ
         R2S14Y0KcSsU/LcmgumunZXRAdMANMnBIPyHcoLM/hn8XC73bViZDG4Fon8Jm+GQUL0B
         W6cw==
X-Forwarded-Encrypted: i=1; AJvYcCUsZ/2fX4H4eM4C+5FV2Xwh/i+porLUu96iEal8wrYWRxSfFI7HAvl3qD2LgeJ2YzlP1fj2v6BR5A==@kvack.org
X-Gm-Message-State: AOJu0YyF2+QFkhV6ceJRxK17Ip8TlNGVdf7dYa/UBkrm9yH4LHPrF36H
	gomoL99HZpG9Tz5keITxfjcYfz54+9X1R0zy+px6rMM0VCy/hosYSPVcVf2IliUAzWNwpc2Fd5u
	wFeLMhY8lzUGwoE61xIbATYJiQiJ4KGoIh5hgHMNk
X-Gm-Gg: ASbGnct4GF0fXLqpGR2+BIYOdixhWIntYfn8RHOh4MXGOacpvcZ0hxHBfuPq09tjAhP
	bs0nFAROolOreuNGlbeuyn5QTfrmR6vb/aNmrX8WUBB9ru5g1xweDpdrYE9fTKYhC2NoW730Yaq
	YMdZAtAgrcGn1T4otT+827xXMigcvWyn0n5SMlHPWQuVsQae4FfqaeDlOjFBcWrnwt1zIBCRb/m
	CYNgiRIn4m2hv7DmbrNDpsVzDgjlsA9moVlHK+slu1J
X-Google-Smtp-Source: AGHT+IEeBGziaJB9oHadvh0/FzyqXNghHw3ReC+VBEqjlbAdsbeZ1QpzoqIvskMkWg8yzLp4wU/6HFBGcP7p0AcBS04=
X-Received: by 2002:a17:903:2f85:b0:24c:b69f:e4d2 with SMTP id
 d9443c01a7336-24cccbfbb0dmr2910515ad.1.1757003537673; Thu, 04 Sep 2025
 09:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
 <CAC_TJvd0SnHpEv0MSwXsF4UFpP0MNvRc033=JS1xTEHAOjQY5A@mail.gmail.com> <7eh332fqbhxak2afcwt6mwzaxu7s3dj2tx4hrtt7ivo3oxovcg@avz6uniwdzpi>
In-Reply-To: <7eh332fqbhxak2afcwt6mwzaxu7s3dj2tx4hrtt7ivo3oxovcg@avz6uniwdzpi>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 09:32:06 -0700
X-Gm-Features: Ac12FXyZMIliyHsJ8oJic4hRcBiiCKHL2ZYkSahpEJ8um3_mw6lFpjZ8RpCGqJs
Message-ID: <CAC_TJveTui6MPBGdB118VtL4pr69dtNt9LTe9J+cahHMdf75xw@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 40F7D4000A
X-Stat-Signature: fhebzdmgfrcejxie3xqojbnomeatwfk3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757003539-124408
X-HE-Meta: U2FsdGVkX19HRMY6lqJlbNjbH1wXu8/W+/0QE/9OqfwLV7s+VFihPby0WJV5l7xJ/C9do0qTOso8ygsByTzSy+ehOM9yfayC2FDw4a6gFFicBsxFA+Ua7QJ7fyKClLTfVjAwDADNeXJ1fF0ey+io9bmVG9o4p/nVdLJVTwx8HKUF6ffzZujAxrQZ7NODMd+a5R7kMOlAmWR3yRJeM8p5wifYgB/ENDb8RZ7igAhtU+oCBylo+FPXXCdRhNwdMdx8K+xM7CpOX/ecqZkjSlg/TqyDYOwBuhTKmOVlphFDjyaMgpRa8IK3RtABBM63iOm1EWX/OIb/QXjKyZ7vIPtOkx1EoUsuvhyxM5cGbWcFLGwNTTUNoHiIvZSaONnOXVH7600/qaG9yQGsV0ysutNH3tg/KBkqRB1AgfO5jb28/H3tH2+WRTEP6KD4ixrmVTqd7UzN2QqGqLMaOep5mOqQntYnKczK9IGl+Towt98e5K2Bir0H6S95TjtP2WYSxdsNjz+j9S6f6RvyyaFCrxqB2CbNGqbBf4U6gREb92rYibaBMH7vUXLxjRD8y/zA+z26G28N+gDyVTncAbGR3fxQ9iTu5Q88G9F4uQ4dUtBm4zIlWPZP5xKuycJ1CEfnzhfB75ynN1x1ssxdy10ttkMir+W4SGuA5a/v+KBVODZil8jlb1Pzw3P8Wy2vuORegKwGHmuk+1ySbIoTkCnE7TCzPnbTco7ynnxCGsoPNFiR7s/J0JYzqkw67Wgz64OQT9O6EksmElTu4C7uvYKVvXcq5GZBAp5UosNOYb52VD2ei2K91uYquSVwQVql6RP0WE58RzYLBIQBeTGTeOTMO3LW0z3MARP4kDjID+3Hl4xsObgi95hXCgPluXg9FBJtMgnLa4fGxKrdR+PLay++yXm2akpmNg/EM71q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 8:25=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wro=
te:
>
> On Wed, Sep 03, 2025 at 08:01:50PM -0700, Kalesh Singh wrote:
> > On Wed, Sep 3, 2025 at 4:46=E2=80=AFPM Pedro Falcato <pfalcato@suse.de>=
 wrote:
> > >
> <snip>
> > > >
> > > >       /* Too many mappings? */
> > > > -     if (mm->map_count > sysctl_max_map_count)
> > > > +     if (exceeds_max_map_count(mm, 0))
> > > >               return -ENOMEM;
> > >
> > > If the brk example is incorrect, isn't this also wrong? /me is confus=
ed
> >
> > Ahh you are right, this will also go over by 1 once we return from
> > mmap_region(). I'll batch this with the do_brk_flags() fix.
> >
> > > >
> > > >       /*
> > > > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapp=
ing(
> > > >  int sysctl_legacy_va_layout;
> > > >  #endif
> > > >
> > > > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_=
COUNT;
> > > > +
> > > > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_=
vmas)
> > > > +{
> > > > +     if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)=
) {
> > > > +             pr_warn_ratelimited("%s (%d): Map count limit %u exce=
eded\n",
> > > > +                                 current->comm, current->pid,
> > > > +                                 sysctl_max_map_count);
> > >
> > > I'm not entirely sold on the map count warn, even if it's rate limite=
d. It
> > > sounds like something you can hit in nasty edge cases and nevertheles=
s flood
> > > your dmesg (more frustrating if you can't fix the damn program).
> >
> > I don't feel strongly about this, I can drop it in the next revision.
>
> FWIW, I don't feel strongly about it either, and I would not mind if ther=
e's a
> way to shut it up (cmdline, or even sysctl knob?). Let's see if anyone ha=
s a
> stronger opinion.
>
> >
> > >
> > > In any case, if we are to make the checks more strict, we should also=
 add
> > > asserts around the place. Though there's a little case in munmap() we=
 can indeed
> > > go over temporarily, on purpose.
> >
> > To confirm, do you mean we should WARN_ON() checks where map count is
> > being incremented?
>
> Yes, _possibly_ gated off by CONFIG_DEBUG_VM.
>
> >
> > >  Though there's a little case in munmap() we can indeed
> > >  go over temporarily, on purpose.
> >
> > For the 3 way split we need 1 additional VMA after munmap completed as
> > one of the 3 gets unmapped. The check is done in the caller beforehand
> > as __split_vma() explicitly doesn't check map_count. Though if we add
> > asserts we'll need a variant of vma_complete() or the like that
> > doesn't enforce the threshold.
>
> Right, it might get a little hairy, which is partly why I'm not super int=
o
> the idea. But definitely worth considering as a way to help prevent these
> sorts of problems in the future.

Let me take a stab at this to see how it turns out.

Thanks,
Kalesh

>
> --
> Pedro


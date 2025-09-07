Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227D0CA1017
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 04:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D698A8E0003; Sun,  7 Sep 2025 00:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41908E0001; Sun,  7 Sep 2025 00:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C570A8E0003; Sun,  7 Sep 2025 00:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC7158E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 00:24:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37230B9710
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 04:24:37 +0000 (UTC)
X-FDA: 83861162994.18.9B55DFF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59C49180003
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 04:24:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YPiI7CTT;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757219075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTPgPzRrBAxJrCac5XmQ2yTlMqaTokhJ/jQ8/1ljY9I=;
	b=G5SVeuP6J+VsEWVMs6y9uoD++zgBqIVXGrS+Fr9jxQmDvHcTf9JP22i7zukub+3AMzmy+I
	03TmmLxOtzjlk7dWSE051mqKX3fvw+bcgbBREy3uA/uGHKFTLLgFI/0k4ohz6vOxi0xxq2
	km0Df9qgi3m2Wx9WwR0OUr/fmb/3CBg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YPiI7CTT;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757219075; a=rsa-sha256;
	cv=none;
	b=5auej6DRr3Zf4q8C352kpNGAaldVkP6xn2RSCLrSYTFCjXLJsaGuoL1+wHb2SXTxPYD+LZ
	5Nzb8Pag/BGA2iedO2vWkkROT9Lk3WOrppF3haBnqPFG0OsbfFtXzE16BsQOVPOKk0YxJD
	o07mylqMgsAAQzBaCPik05t80sME4yQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24cf5bcfb60so146125ad.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 21:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757219074; x=1757823874; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTPgPzRrBAxJrCac5XmQ2yTlMqaTokhJ/jQ8/1ljY9I=;
        b=YPiI7CTTV80JpHGsoRSFuYde3vKMWdc7gRc2AM59mJ2VMdu2Am25AK+Zrf1Rfmafpq
         e3rENlRcj0QIJ9xrVEW5ClIyQ7Ie2tquVB+ONd5uDDMOlqY4REez8pWgTbOwvGhTlQTU
         PbdXRYlDwkzau4FGG0BGiAiS2soJMck4MMYPxBsHx8vG/YGMth5ZIeG2kA7d3eEgItxY
         lzq6DIBKtBUFDjuJp9nq3XB8Sb/5hRsZr8kHSleZOh1GOl41FzWn5uJwqKXTY3fUyl1I
         ZwJshMc3BmhQTB2kMi1SYHFmU5oSYWzhfmWpOm+Ut9LYjRGE5sNEo+uhbFxOZOB9VLz4
         paeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757219074; x=1757823874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTPgPzRrBAxJrCac5XmQ2yTlMqaTokhJ/jQ8/1ljY9I=;
        b=D0BroA73djMFNV4kJZ1I9rpAVweDY5tUUMv68oIgmAN45v5dL0XFGr9ykBmS5mDFsJ
         4EwPxU6CCRXfqc1LaAMH0aLyu0i2KQsClAMJ3l+noeRZ58LOlvYPDJQnusrBLxhGCdaI
         UWQGGUXgdAvIEK+Rs+t+WtocBNyjDZJGa+jHD4c6xk+7GR1NUjteeku61ZvbUP25WkIo
         +kfrOF4P8OItggjxiVHdh2tIkj8eT9xMSSbOBHavw5kuLn3Xyk0bOQ52MhWySzWgVlMw
         +sRvqo+ovm68qQ5hzz6AgMVOYdI1UDJSIGX4LrHPNLXgEtqkyPz/8/XlawHzJBhaAhH7
         C1yA==
X-Forwarded-Encrypted: i=1; AJvYcCXnzsyTD1g0NC81nVzaqU+yobkYh26oR7zb8nNs3vgPjEsDcq3iWC0Ai8rz2PyoxA3ykdyMJfflFg==@kvack.org
X-Gm-Message-State: AOJu0YwojYHMfdmU9WuQ8u15+O2OjqnuIEm32KyRjHzfXJf+yaw3AScB
	+nUxxrmidDHUu77542jDYMVMsozm0gnJQ5M8CHvxxz7uNRm7a0pJ15OAakIq9GcAXxgbDtIZq7D
	v5GeTp/VnMWhYPLK76RWB1IIKgsQVlFOjrGybpwQA
X-Gm-Gg: ASbGnctgDVguomUePl/0yXXHqwe6nA3u0vb7KOxDg58Ba7L+osTce4udNFc832SJPqN
	VE6Asf/v3X9PzdRI0VSKeKewOEbVpCjA3Otkog+y0Rm/Wq1X/B/NpfWrpCEDSzjIuODG5To8Waq
	EZKRQYvFPzzT2YNVu9H8UTtEYdhR6mt5HCJOuHSWadWY6xhUqlSBJt5oOgN8rlJKgphgSCjJXhq
	BgGC5c5P8K3LDxjXtmXUKEm1BU3RszKphzufjeyYe6WHA84iJE8lvMAXA==
X-Google-Smtp-Source: AGHT+IGYa0lPcHnn6yyQH0nLs+W33hFAxTRTwUNtazygW/FTP7faT7GUxA8+33u94005mbOApW9X6E+kBz9mCu3EfpY=
X-Received: by 2002:a17:902:e887:b0:248:d063:7511 with SMTP id
 d9443c01a7336-2517484234fmr2374415ad.9.1757219073688; Sat, 06 Sep 2025
 21:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r> <aLs9f9WjxIOrE3Sr@google.com>
In-Reply-To: <aLs9f9WjxIOrE3Sr@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Sat, 6 Sep 2025 21:24:22 -0700
X-Gm-Features: Ac12FXyluFsg8rwjLeiuUN8OqbXpgEL5Ij8nUCZC_bTtjwaiTP3umbB2xEe5lA4
Message-ID: <CAC_TJvdXNJSqNjRQS92jAOBUJ+3qyS9+eZAGSJMokGQQHaxqoQ@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 59C49180003
X-Rspam-User: 
X-Stat-Signature: ffa5w374syd5sfuznrnztgywudio71m7
X-Rspamd-Server: rspam09
X-HE-Tag: 1757219075-910635
X-HE-Meta: U2FsdGVkX18/3repEqlCXiTl6IJmwLhCWAFuP93JZ9EhwtgRfggQS6txQmOtDhd+56dkK248qwJrGH5AMFCKpDDscEqx6ZPg17xwMjFhdG0wwiKlPYJZbltCajDNl6rQ7P++G0ihlh08E2Jd8UEynMwQqQzOJuOMGDJ21Wa36fjR9b9rpULvM9qRa5j7PKTmM8zSmBx4cQP6FCLONHv0YPN5gj7TwS70kTBic/OUkKRhko6lw2+MKk+qWCcbb1+KaZLFEOiWdlB1sTyvxDQDKqsKgmg7Qv97ii1Pm013d+AHlSOGnQRH1TLBLF2OKanRGNC2FVYXONZUDZZ2P447VzS4NwGXbf8YHVgJkH1YCsVou6Y8Ek8tlANj0ZfMVAMPjgqh2z2Bpv7aO/9HF9hkLUxffu3c0FWwOtW54I7gso/uO7EeDSbD8guRcsc0o5xRiUYmfbo8DHwSyQWK1YjVGv0XC96TvWCqGocIrG0kswCXgoJEsfopxUfJfccsZUV0DOpmaTZDCHpGBGAbDYjiBoOgDHZeEED3QdXP3U7DOUzYGNQcsU0rLJaXsca3NkB7aYhphTlWxEaaliLLEnlEVCPFwHdc6Bb4EFs/dYVEFq0nN21wrJN/8Ek9vc3tm69xLjmorMzQNUTSW/lexrpU2oe6g051miaSxmxGXfsO0GZk3vwzpsPQCTGH584sSUtalOim95IF2R7qfhf3jQZ9z3IZMIIwodeyIrGXnRBjazhDk+o3WLNSCrqXy4VrsT4X9mCkCofI2pR1S4orv3FPll0XNTkzl7vjal+aspSfMhlbEa8D/qjtNCLJK08S46ZE8KKzIrA4kxU8SKujsDFIClrEgHVEJqwcl8WKwSE14b1lSIcevPDbZWeY9rjjAzD0KycbUtn/5TJgRxczQMsnNsbKh3JmOCmx6PnbYTGe2AZZzZ87nxRC/YQGncEZQ7vEN4zhAvUVt3Z12OCX9Iq
 8txYENNz
 UfANZpEzN/gprbw7T5+Ajo6Qe6hMwDUwIWf6+VugXuTounOJsuIDuCgHJHga/nuc0ZFFrjm+G5073m0f+f1cm4TtdfmwqYAeW5Va7E72N4CIvMRckCKPMChD1oOUOiNSZnY5pmVcoyi8UaEhosgDQ4YbLJRqB5hEhHOvdyJcDPqgi55+qmIvdMZ1ZkhRaOJLtb5yfuJ/DG6JYgT5FnPKTUq0z4Qw5MV2AZT+Hzee4+LDZX6AjvrIlfZs8zaNuSCWcmzjfVe6ybTNPgrcMa7f3cw5io09aCRL4rpJBsVoRjIQl+jlHqaZprkK39DmAVOVo++/2yWRqwxX+Trzh+/cGAilFoUWmOeIJpB9NQLz/I9H6Kl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 12:44=E2=80=AFPM Minchan Kim <minchan@kernel.org> wr=
ote:
>
> On Thu, Sep 04, 2025 at 12:46:34AM +0100, Pedro Falcato wrote:
> > On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> > > The check against the max map count (sysctl_max_map_count) was
> > > open-coded in several places. This led to inconsistent enforcement
> > > and subtle bugs where the limit could be exceeded.
> > >
> > > For example, some paths would check map_count > sysctl_max_map_count
> > > before allocating a new VMA and incrementing the count, allowing the
> > > process to reach sysctl_max_map_count + 1:
> > >
> > >     int do_brk_flags(...)
> > >     {
> > >         if (mm->map_count > sysctl_max_map_count)
> > >             return -ENOMEM;
> > >
> > >         /* We can get here with mm->map_count =3D=3D sysctl_max_map_c=
ount */
> > >
> > >         vma =3D vm_area_alloc(mm);
> > >         ...
> > >         mm->map_count++   /* We've now exceeded the threshold. */
> > >     }
> >
> > I think this should be fixed separately, and sent for stable.
> >
> > >
> > > To fix this and unify the logic, introduce a new function,
> > > exceeds_max_map_count(), to consolidate the check. All open-coded
> > > checks are replaced with calls to this new function, ensuring the
> > > limit is applied uniformly and correctly.
> >
> > Thanks! In general I like the idea.
> >
> > >
> > > To improve encapsulation, sysctl_max_map_count is now static to
> > > mm/mmap.c. The new helper also adds a rate-limited warning to make
> > > debugging applications that exhaust their VMA limit easier.
> > >
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Minchan Kim <minchan@kernel.org>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > > ---
> > >  include/linux/mm.h | 11 ++++++++++-
> > >  mm/mmap.c          | 15 ++++++++++++++-
> > >  mm/mremap.c        |  7 ++++---
> > >  mm/nommu.c         |  2 +-
> > >  mm/util.c          |  1 -
> > >  mm/vma.c           |  6 +++---
> > >  6 files changed, 32 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct =
page *page)
> > >  #define MAPCOUNT_ELF_CORE_MARGIN   (5)
> > >  #define DEFAULT_MAX_MAP_COUNT      (USHRT_MAX - MAPCOUNT_ELF_CORE_MA=
RGIN)
> > >
> > > -extern int sysctl_max_map_count;
> > > +/**
> > > + * exceeds_max_map_count - check if a VMA operation would exceed max=
_map_count
> > > + * @mm: The memory descriptor for the process.
> > > + * @new_vmas: The number of new VMAs the operation will create.
> > > + *
> > > + * Returns true if the operation would cause the number of VMAs to e=
xceed
> > > + * the sysctl_max_map_count limit, false otherwise. A rate-limited w=
arning
> > > + * is logged if the limit is exceeded.
> > > + */
> > > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int=
 new_vmas);
> >
> > No new "extern" in func declarations please.
> >
> > >
> > >  extern unsigned long sysctl_user_reserve_kbytes;
> > >  extern unsigned long sysctl_admin_reserve_kbytes;
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 7306253cc3b5..693a0105e6a5 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned=
 long addr,
> > >             return -EOVERFLOW;
> > >
> > >     /* Too many mappings? */
> > > -   if (mm->map_count > sysctl_max_map_count)
> > > +   if (exceeds_max_map_count(mm, 0))
> > >             return -ENOMEM;
> >
> > If the brk example is incorrect, isn't this also wrong? /me is confused
> > >
> > >     /*
> > > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mappin=
g(
> > >  int sysctl_legacy_va_layout;
> > >  #endif
> > >
> > > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_CO=
UNT;
> > > +
> > > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vm=
as)
> > > +{
> > > +   if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > > +           pr_warn_ratelimited("%s (%d): Map count limit %u exceeded=
\n",
> > > +                               current->comm, current->pid,
> > > +                               sysctl_max_map_count);
> >
> > I'm not entirely sold on the map count warn, even if it's rate limited.=
 It
> > sounds like something you can hit in nasty edge cases and nevertheless =
flood
> > your dmesg (more frustrating if you can't fix the damn program).
>
> How about dynamic_debug?
>
> a1394bddf9b6, mm: page_alloc: dump migrate-failed pages

Hi Minchan,

Thanks for the suggestion to use dynamic_debug. As you may have seen
in the discussion, it has moved to a capacity based helper
(vma_count_remaining()) based on feedback for better readability at
the call sites. Unfortunately, a side effect of that design is that
we've lost the single, centralized failure point where a dynamic_debug
message could be placed. I'm going to stick with that due to the
readability benefits. However, you've raised a good point about
observability. For this I am planning to add force increment/decrement
via vma_count_* helpers and perhaps we can add trace events in the
helpers to get similar observability.

Thanks,
Kalesh


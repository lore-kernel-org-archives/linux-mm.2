Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FB9C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1546B0092; Fri, 25 Jul 2025 11:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1A96B0093; Fri, 25 Jul 2025 11:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7456B0095; Fri, 25 Jul 2025 11:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB176B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:16:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 049AF133FC5
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:16:33 +0000 (UTC)
X-FDA: 83703138708.18.A16DC96
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0B20100009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:16:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FOaKE4kE;
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753456592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3aelP86DZFm0yFMte9irE1knJWouFsxwdQo+rhBPdA=;
	b=wgvJI4aPOpW1Dq8fsmKYFbrDOd0FWnv9lX1bNUMEioJH2tFuzSH7g2kfxitLaxZd8Cgrf4
	TlyIgT09E3sUcZ61skA1Buca8Nx2EJNTOCXavcNiJ0VYkTUSydUVbn2QReSh2q7gAfEKKi
	YfPWas81koXe6wfFPmiJoXSQaFtEOgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753456592; a=rsa-sha256;
	cv=none;
	b=VPXoJfGxLmRT+BSQerhnQumB0fMgb5v2cv1/p3/mpUicyVb9M/pDaKY7khJq4X0M6L2C/O
	+H43eszf5e+sJXB+dj4kJt8CFtrPLQWaOA+8gW9wZNHc00A6Z/5oZ/YjRwnSdEECjh47+o
	LGT8ULOzYsGWKf/Qqtyv38b95YbXekk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FOaKE4kE;
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso11762a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753456590; x=1754061390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3aelP86DZFm0yFMte9irE1knJWouFsxwdQo+rhBPdA=;
        b=FOaKE4kEhf8EaB+hBIIwJywHo4eqbgqnAKXLBLxsYfSmEzIXY+R9e/HupZLNOIhnMV
         jS7TiTl4aaTh+sApT9vaOL8Qk4U2hsvz86iV4mY29scrijT+Gtl6RTumsOxLJOZVom48
         PTI1o5f+srSeM0OZAlHJb1vShM8Y8qbRFydOrbFOhdgN/Sbmml8qEfvOP3DDyqQ0bHlv
         ngM74x33jTV6QdlUJV5HTxu3NkQfA1c5XGY/zBkKTfKy7SVOtt1SSEVQUjQo1xvPeTI8
         QkMFKLJ3qbPPmnN9eaJ9qAeMAK3EpnFesRe3f4IxlbMbKibOO4GaN6QECpb5yL6FSUqv
         j+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753456590; x=1754061390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3aelP86DZFm0yFMte9irE1knJWouFsxwdQo+rhBPdA=;
        b=miU0E8Xssp1HsaM+m0DmAmipDLJsLoHq3mx8RrWXzM7L9DyxcvxUVhpaWCcg7hc9eL
         /3A2wABEERxgCeWrKEdNlakxcGL9dCpqSVFdrAGxdUTgctqQkdomn/55EOuRof0PFU+1
         e1zOpPjrM3gKSj04mUBXfp+8D3nrNUXs46Qq/rK5qRX2Yzkry8HZEhqmK9Y2TMi9ZKC2
         IUyFL46LipVdSR7pQslozZwmdgS7/KcPbUzWL0qn3FuyqiNupq/BWMJQCexHv3bs6cZv
         sx7cw21qYX4ROxpZTv1GRbqfHigK1r7krJx16fzCT9oEmMjYCx4ZSOn86DSIpGFggdad
         plhA==
X-Forwarded-Encrypted: i=1; AJvYcCW4PZLu4bJzfJ4r1gkxiHQbej5/tCv8ddpN1vGfOr3NY2LvpT4dE9UafWBoqv3SUkLEu22686fVIg==@kvack.org
X-Gm-Message-State: AOJu0YzgMSxW+lFhWRmQZ/hAe/y+sG35yXLLB6u+XPLhKB5u4lTKYTSQ
	+GS2pQ49ia7e0hHsuqwvmg4HRTZkHlFZFRMGsHEZxPEENyY3iLM38ZyXrroxy6T2rlds1yvCeWL
	Dg5QZmr66ATkMy78kuAEK7L4PV+z8e6XYrVvX4DFJ
X-Gm-Gg: ASbGnctppsTBDWZ1DGLgFM1HEpD3qUx0lqlDJc85+5SQHpch6k/r8lUa9CpGyv7eldH
	fDQfhXvcYZTEakVyrU5Zeas3OM8gVnK8hc4rNKN1JYyAHjaPjoSPwKdImfAMG9frVAL7+9p1jCM
	tviq4U4k0EFyU/Tv+ftiDJ7XpGr33+ZdwVcwOaV8yUd89EtuyTesVtai03xjL1n34DfI3jBW+ch
	8Y6n4j9W6N5CgZCFtPQJf0U/0l4R1wv2js=
X-Google-Smtp-Source: AGHT+IG9EBGRShAtcrFGVkbd/pyc3jIAaBS2H/KKd7ti9iP9SAmV0nd+9NKXpwq273HHVXLDhMDwPDOw+NQ84WKh+3M=
X-Received: by 2002:a05:6402:3134:b0:609:99a7:efdb with SMTP id
 4fb4d7f45d1cf-614e6fe3361mr88105a12.2.1753456589881; Fri, 25 Jul 2025
 08:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local> <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local> <CAG48ez1TOULrpJGsUYvRSsrdWBepCJf9jh-xPpurRUXbMmAkuA@mail.gmail.com>
 <3cfc1146-1b62-4b04-a2e5-997d10ba4124@lucifer.local>
In-Reply-To: <3cfc1146-1b62-4b04-a2e5-997d10ba4124@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 17:15:45 +0200
X-Gm-Features: Ac12FXzFQ6kL--SaRX25TSKqpOxK9bRnTErOgx7u8NlsTaYgrLohYP8OYTbs0Do
Message-ID: <CAG48ez3aiXUmCqu2i7g6qrnVmZ6PRUsA-rQzHX1r8SXeYh2sow@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0B20100009
X-Stat-Signature: sf3k6z1kn1y3izktoid4s6dumbi9frbt
X-Rspam-User: 
X-HE-Tag: 1753456591-843689
X-HE-Meta: U2FsdGVkX1+iP9Fhv1Age2/yaOloEhOGIeqZcHk7fTMiFMfHz8uZDjtJQ6uuS7WcluBCuxWQEAG8MiZ/NtAoTy721GXXFIqCdPtjWUOc0PcYe3Y+8QmbzBOjXSrc8npMYQJTEtubQMOc2wtsuqas//boFToEGWIQzLJdhgLnmXNCofVZfyqc5LGPJcJraTVWSFvdXSibS8mbU+w/W3TpO+S97vhMt3Hyu4IB2quwxNTuErZweRJUDHcDCR1DLUc6NOLoJvV22D7y71fEWi8AeNy5LcjFWoK53XAfG65wUPik87eKt6Z1MGsoZjGwSmE0+hnJfLYaOujrwIgxBDDTEXIs4piUyP1oBnZJASrFIbyhiGbCw/BPQQ6Kjbk8uVqYF9nWQYU0RYicizby8t9hqMMLauL5au5Ig8r+ZgHVkV2Prj0zPyY09AEC89UTaJxq2ln7u69qeyYMf7Dkfnk1bePaaCRv2rW1LBUl3LJ29abyEzPsJ2VNz3L2OqHdEUiErtQWf1JWCqK3+u/c4JO34WtfsA8R1CZe4TaaVwJfBDNOFIjTH1G2AC8jDttj4T0DjhuQmvoKPDGBti67N0IPAQS/B/IXKV818dPXVwSyu8RDCZ9x6b3DsrUdUdkBTEyVPlD9pRSYgTNOE6ZqVINZDl3csDXFjX+IsVvYYBoVb0dCwReDeur7q7OGacdIVhPBAn9hdyvG8MGToigamgNTMWSoOwUPU9TjcjBIQuDPItwQKcJXRd05vvTlw037Gnml7F59nKuRA98w12t0s3K78yQpqUhV6euX8VgoP2rFA4yxijsfcKmiiDg7aNX2KnGgSU2/Q5oXYrlclVnr9t9ezLiWkJ0Vy2zT+D7gAdFWYelFUf3hNwMPPSBAydXWBPFJw3ZekK4RATpTeyIYSvBjtdZFG9WHL0SHbmffWn3f4/vfogwfbtopa2YRTysnld+mtk3HP9/x48z+SSuaqel
 EcIm4dLP
 7dPsmGk8qSpKbCMeTb0tv/v4LIq9L4UzrC1oqvlx8kue+DWvypWwnlYbvR9KCzeg5avpFWvBqN/NcUknN5d1fA2fqKQv0QFCv0CtpQPr4oCkZPwpUBmTj2hAxcUDUfmy8U5tZvkqPcDN9X29ZTRdeJCWg5VemG09IPO4HKPHeq+/LZglMx7FnRKS6dJ5MK9uLrHPf7+owMPN5vvgXh3rLKmG1STyDjih1dmLb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 5:07=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Jul 25, 2025 at 04:48:09PM +0200, Jann Horn wrote:
> > On Fri, Jul 25, 2025 at 3:49=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Fri, Jul 25, 2025 at 02:00:18PM +0200, Jann Horn wrote:
> > > > > We're sort of relying on this
> > > > >
> > > > > a. being a UAF
> > > > >
> > > > > b. the thing we're UAF-ing not either corrupting this field or (i=
f that
> > > > >     memory is actually reused as an anon_vma - I'm not familiar w=
ith slab
> > > > >     caches - so maybe it's quite likely - getting its refcount in=
cremented.
> > > >
> > > > KASAN sees the memory read I'm doing with this atomic_read(), so in
> > > > KASAN builds, if this is a UAF, it should trigger a KASAN splat
> > > > (modulo KASAN limitations around when UAF can be detected). Basical=
ly,
> > > > in KASAN builds, the actual explicit check I'm doing here is only
> > > > relevant if the object has not yet been freed. That's why I wrote t=
he
> > > > comment "Part of the purpose of the atomic_read() is to make KASAN
> > > > check that the anon_vma is still alive.".
> > >
> > > Hm, I'm confused, how can you detect a UAF if the object cannot yet b=
e
> > > freed? :P
> > >
> > > or would that be the case were it not an atomic_read()?
> > >
> > > I guess this permits this to be detected in a timely manner.
> >
> > If the anon_vma hasn't yet been freed, but its refcount is 0, then
> > that's still a bug because we rely on the anon_vma to have a nonzero
> > refcount as long as there are folios with a nonzero mapcount that are
> > tied to it, and it is likely to allow UAF at a later point.
>
> But how is this happening?
>
> The only places where we might explicitly manipulate anon_vma->refcount
> are:
>
> - anon_vma_ctor() -> set to 0 on construction used by slab.
> - folio_lock_anon_vma_read() / put_anon_vma() - both cases call
>   __put_anon_vma() when 0 to free the anon_vma.
>
> So how could we get to a refcount of 0 but the anon_vma still be hanging
> around, except if it's freshly allocated?

Due to SLAB_TYPESAFE_BY_RCU, the anon_vma is guaranteed to still be
accessible (possibly post-recycling) for an RCU grace period after its
refcount drops to zero. Under CONFIG_SLUB_RCU_DEBUG (which you need
for KASAN to catch UAF in such slabs semi-reliably), from KASAN's
perspective, the anon_vma is effectively freed after an RCU grace
period.

Basically CONFIG_SLUB_RCU_DEBUG turns kmem_cache_free() on
SLAB_TYPESAFE_BY_RCU slabs into something like kfree_rcu(), and this
allows KASAN to catch UAF access.

> It's surely only UAF?

I mean, "UAF" is kind of vague when talking about SLAB_TYPESAFE_BY_RCU
slabs. I am only using the term "UAF" when talking about a situation
where accessing the anon_vma object is entirely forbidden because an
RCU grace period has passed after it was "freed" with
kmem_cache_free().


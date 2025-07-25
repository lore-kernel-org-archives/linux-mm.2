Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D900EC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB746B007B; Fri, 25 Jul 2025 08:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3456B0088; Fri, 25 Jul 2025 08:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2576B0089; Fri, 25 Jul 2025 08:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD8E6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:01:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4BC014071E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:00:59 +0000 (UTC)
X-FDA: 83702645838.25.4C02EF0
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id E23BB12000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:00:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lUVU0rT9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753444858; a=rsa-sha256;
	cv=none;
	b=TNitEzitMTyJ0JNiIsB88cOC8V0DSlush4zVDjWgrPgf5qbbhAV+P2nxCDGPU45h53NsDZ
	Kl035XCwV2w8hsBYN+NKRZME01Tgjxcb/Ku/wJ5KupeBXPmJLML8pMPNRhlqdptUGIZY+G
	9KBFCEU8uthdFA6ZgvoO8AImA0dOjBU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lUVU0rT9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753444858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh4dBPnKL9asOrMaPO22NPX8F8r/EmmrhHR2PE4LS5U=;
	b=x4SP9Bp8W7/FyZzvJjgEw38Y5/I5ki/uamd0gjoTLTlq3O6umXpxlp9dAySnrAQNwW4mMY
	jPPLPkaV7U88PUOoEOcL7w+p6AeoMyCBG58+iJo3NvIM5mUOjj0jOD4od0cVVKcVmvZBhG
	9WVtV7SOetKojxpGk5pPj4OzEc35H6g=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so6816a12.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753444856; x=1754049656; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gh4dBPnKL9asOrMaPO22NPX8F8r/EmmrhHR2PE4LS5U=;
        b=lUVU0rT9Hm8d5A8/Q7exquO/090sQ9NpAcGb0ytNlOUqdoMUHGa7h+SF2luOWog3Gf
         N9LYAWi9wsQA4AUg/LrzhCfHZog1hZcrpEn0EbeOCSz95fLIvxFIcJPi6oSYOODGrg1Q
         s46pnjnu/a4buT35WiXVl6GWfA2NMdh9MvpBjFKRe5ISILkc1aUh690AsiLmfb2tS9xo
         +Y0PG+BmpqonP28mz4Q9QaYgiuSTWOoCbiIyoqViwN1zgiW6HcUjJ0L+g1Uu4HhcxPNb
         LPm1GwX3ut+T5x0a3dHkC/XNPa4V1QHYZ1kHatlGNNfwnzUJkc7VHrbL9jmKz94vwZd7
         dEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753444856; x=1754049656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gh4dBPnKL9asOrMaPO22NPX8F8r/EmmrhHR2PE4LS5U=;
        b=jS8lJOH8O/xAB4HwbsJmEwKU45NTtohE9+G+DiefBmhBRbsF0Vw4Vgg5TS2oQzTsmV
         U2see8QGJFlqKtgIneMRBcbnbFS+8HBA2pJNxce0GJHsNxqjs3dcn+3gQucOQuPGJanF
         9I5AZp7BVKkzlDCV22nliD7vYRrCUo65viZY6zQXf0TE7SqdSstxk1ta6/2MK+nPcXLI
         7HjJA5pumCLB45H9f0e2QKsX6r6Z06hh9uAytpYeVg1L+zVI2x+MNCGIcuTZHInp3/M3
         yqK5RPezn1Mh+9Hy9Gc676KhEmxqVqoPQUEv/s7j+2ZcxwSqcWPFBtjVCO3Vezw3PpYQ
         KpaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtB3uKR+pw/u9yJwzPNmbv2qhSfVaWKlRsJHWL0FH98w7Bbiz7nHqPZtCMKv6o7yEwttrHNnPu9A==@kvack.org
X-Gm-Message-State: AOJu0YymQslYQJ3Mt1Ltuis4rt2FpcBSxcR+i9/A9BpHvW1emhGCDdXa
	EuQM7wmE/ZQ/mBFyS1GqqrDh/0tSa46s7ZcCheDPtdO49iOuKlPiZ634WEdCmHANbmH31Enlvob
	X66umMz1+UKR0XwHCsUGr0sRiYtsUHq4l1cubIpIB
X-Gm-Gg: ASbGncuMQsZk+jy8nQWFL4lNzpgPeLPQ/Awo5pCssIh+onBgaJ/FD5slH7BryxXVP68
	su4Loj7rNDEBISk48nKHULjKfmSEQwdUCWDWIWW2QmMJ2WqqzXJ8jp4CoM0AtT7/Hc22Wf3unlP
	DRKroF8mTObiOfuAegwAS1srMe/VjUw7DA/5Urn0/XXXDi63av0WThs9J0ApETu91M4iQBIV7G0
	l/YJtMDBfFDldWqS5BuCxu8zNgISWhV6O4=
X-Google-Smtp-Source: AGHT+IHSG6B8cp0/LEbloQrjETaNDXkra5YuBdrTSkhuuJTSqsINYcZjJHSwLDJBaVZSNG1/gP4CfJsXaIEu54thnsA=
X-Received: by 2002:a05:6402:2921:b0:607:41dd:5fe7 with SMTP id
 4fb4d7f45d1cf-614ea6cc834mr57442a12.1.1753444855735; Fri, 25 Jul 2025
 05:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com> <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
In-Reply-To: <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 14:00:18 +0200
X-Gm-Features: Ac12FXw7jMvLf5hIHnVYApdEf2yr5qrJO0NwRf-N9VozIjLNzSouJwtx8U7nM-M
Message-ID: <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E23BB12000D
X-Stat-Signature: 8xrosc5jhuqkzou6ppiogjbnmn14iwew
X-Rspam-User: 
X-HE-Tag: 1753444857-236249
X-HE-Meta: U2FsdGVkX1/Wuvdc+ViPSDs+bfT1Q/gQ9CBSsS+lGMo0YPx+nE5YJeNQ6TYtsQFUzonyXJCjMuUbJKgYUOwXeBNPhhrdAZkLUcJC0kMWWX6IIZBDcM389uNIzoW8MYDD8eR4heMuVUSlE+/0001uSvG6Xtmcxp92FXbFRai3fSpFq31qj9QptMmFMwhPiplvL5DqG+vSH7oF+kz48eURv6MCN3KCOvLecdEsc5zw+ja5kcgTgvYbBO1NlbxMf/2tfMf/plXI2S2SfjL3kLGFBzAcAbYmj6WRCqH0Ny0rlSui2KZbXVW+nZwWNTPv5GcFGs9/NLpQCWiotHO1paLAand1Vj6q7/HWn4QPmfc5jz/prZ/r86qcjSAXajrru+3o2IEVkwFuODeEZnscLJS+5CTWWFJUW8difSIAZbJ5ou/vdJj1hfnNssu9IvwR04zTDJ0pBGCoXykSXdk8RPXRI0SP/IE6Bewb7/1xUY2JpbLACgFezePBfXWZT8UJkt+ZoqXs+aeXe2hLxdQZBGc91qtq4ZylYHIOUNEtK9X2olx5wrUf5XXdRpo0H3s6LQ/NumH7IYPj0MYwaApKNHyOC+6wgt6sb9k6o+IkUFphe6LMXzAamuDbelXYhPhecPPCePjWtHo9mXs5xIXUX7Vftp9kXNjHnksa6FtKppqv1/p9fznHF6LfII06zvcbm6DPVoOdnpfEqG76BbwYD1J3J3x/hjAIZ1tQDroQ44kBdqDEwBHhmO7bIhW4oqBG5TebOBYj+OeOI9nUH3SFqqT+lt6CpchXxaAAw6TqsV830UkvI5uwn1l/dpjuAvCiDx14jjpakn72TWciEKX33pZPKu3TmH5IAXikVWSUhJFSNBg3KnNLVD2pBIr/mT2Dragr76zjeh99BVuoklIGwWj19240Pyl+Ewco8q/O5kivYF173acV1qJIjtpQ+kK59RMfgBKCS3x6ug63uqD8DKt
 RRotPjA2
 qYLSUVSHltsL0SzGuETYGU+CgvRG1niFR+u/HaV6kkSYDJXx+sdMRtL4KwqGw/sB81PefhWu+nGAwyg0Orlo8SfG0U1iYvtSnQlrlw0otwDZXEJF0Otod6X/bTCDrBrJ3iba69VbAlI+XU30TrjXn0l2ES0iARNHQU2tlqh33AE5UXaoHCWoIAef39HYLNAzrS+JSzqPh8Xr8Hej8JV/gYWSDb0M7OCOEXIUvNWjPqbkb/S6nf7pZe1q90BMzPDV/OIQvBFYpP30C4c8YUqs3x/W9GLTUw45CbMstPErHqq2tPSxjPXOnJNkb9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 1:32=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Jul 24, 2025 at 09:13:50PM +0200, Jann Horn wrote:
> > If an anon page is mapped into userspace, its anon_vma must be alive,
> > otherwise rmap walks can hit UAF.
>
> This is extremely weird. I guess it's a UAF of vma->anon_vma
>
> Because we:
>
> put_anon_vma()
> ->__put_anon_vma()
> ->anon_vma_free() (also the root anon_vma... interestingly!)

FWIW, the thing we're trying to access can't be the root anon_vma,
since KASAN says the UAF'd object was allocated from anon_vma_fork.

> But none of this obviously updates the vma to set vma->anon_vma to NULL.
>
> So yeah god almighty. To get this, we must be dereffing vma->anon_vma
> somewhere unexpected.

I don't see how vma->anon_vma is directly relevant. I think the
relevant things are:

An anon_vma is only kept alive as long as at least one associated VMA
is still alive.
An anon folio may outlive the VMAs it comes from, so it may also
outlive its associated anon_vma.
When an anon_vma goes away, it does not clear the ->mapping of
associated folios (this is an intentional design choice).
When an rmap traversal wants to go from a folio to the associated
anon_vma, it (under RCU) checks that the mapcount is non-zero, which
implies that there must still be associated VMAs, which implies that
the associated anon_vma must still be alive; and then it dereferences
the ->mapping.

I think the ASAN splat indicates that syzkaller must fairly often get
into situations where the ->mapping pointer is dangling despite the
mapcount being non-zero, but syzkaller likely only actually hits the
UAF when the kernel gets memory pressure by chance and does rmap walks
on the reclaim path.

So there are several invariants we're relying on here, and breaking
any one of these could allow an rmap traversal to cause UAF; a
non-exhaustive list:

1. An anon folio is only mapped into VMAs that are associated with the
folio's anon_vma.
2. Removing an anon folio mapping reduces the anon folio's mapcount
before the VMA can go away.
3. VMA splitting/merging/forking properly preserves the anon_vma associatio=
n.
4. If the anon-exclusive bit is set, the folio is only mapped in a
single place (otherwise swapout+swapin could erroneously set
RMAP_EXCLUSIVE, causing the swapped-in folio to be associated with the
wrong anon_vma).
5. When a VMA is associated with an anon_vma, it is always also
associated with the corresponding root anon_vma (necessary because
non-RMAP_EXCLUSIVE swapin falls back to associating the folio with the
root anon_vma).
6. If two VMAs in the same process have the same ->anon_vma, their
anonvma chains must be the same (otherwise VMA merging can break
stuff).

> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
>
> Will try to take a look when I get a chance.
>
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
>
> Fun.
>
> Please hook me in (I mean you're going to anyway right :P) on this stuff,
> as I'm looking to rework the anon_vma stuff so am naturally interested in
> any and all rmap anon stuff.
>
> For my sins ;)
>
> Maybe I"ll dig into these syzkallers.
>
> >
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages=
 to
> > hopefully catch such issues more reliably.
>
> Good idea.
>
> >
> > Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
> > unlike the checks above, this one would otherwise be hard to write such
> > that it completely compiles away in non-debug builds by itself, without
> > looking extremely ugly.
>
> David already addressed.
>
> >
> > [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.=
com
> > [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.c=
om
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> Nit below, and pending David's requests, but LGTM so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

> > ---
> >  include/linux/rmap.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index c4f4903b1088..ba694c436f59 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(cons=
t struct folio *folio,
> >       default:
> >               VM_WARN_ON_ONCE(true);
> >       }
> > +
> > +     /*
> > +      * Anon folios must have an associated live anon_vma as long as t=
hey're
> > +      * mapped into userspace.
> > +      * Part of the purpose of the atomic_read() is to make KASAN chec=
k that
> > +      * the anon_vma is still alive.
> > +      */
> > +     if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
> > +             unsigned long mapping =3D (unsigned long)folio->mapping;
> > +             struct anon_vma *anon_vma =3D (void *)(mapping - PAGE_MAP=
PING_ANON);
> > +
> > +             VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) =3D=3D =
0, folio);
>
> Maybe stupid question, but wouldn't we pick this up with KASAN? Or would =
we
> pick it up far too late I guess?

I mean, it depends on the exact nature of the issue. If the issue is
that we somehow end up with anon folios mapped into VMAs that are not
associated with the anon folio's anon_vma, then I think the only time
we'd notice would be if we randomly end up doing rmap walks of the
folios, as syzkaller did above.

> We're sort of relying on this
>
> a. being a UAF
>
> b. the thing we're UAF-ing not either corrupting this field or (if that
>     memory is actually reused as an anon_vma - I'm not familiar with slab
>     caches - so maybe it's quite likely - getting its refcount incremente=
d.

KASAN sees the memory read I'm doing with this atomic_read(), so in
KASAN builds, if this is a UAF, it should trigger a KASAN splat
(modulo KASAN limitations around when UAF can be detected). Basically,
in KASAN builds, the actual explicit check I'm doing here is only
relevant if the object has not yet been freed. That's why I wrote the
comment "Part of the purpose of the atomic_read() is to make KASAN
check that the anon_vma is still alive.".

> Which is fine - because hey this is the only way we can get a hint that
> this is happening, but I think we should describe what we're doing.

Sure, I can make the comment more verbose.


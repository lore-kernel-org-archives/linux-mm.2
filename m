Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06308C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 10:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464646B007B; Fri, 25 Jul 2025 06:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4131C6B0088; Fri, 25 Jul 2025 06:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328196B0089; Fri, 25 Jul 2025 06:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB456B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:59:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9571C113A79
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:59:52 +0000 (UTC)
X-FDA: 83702491824.05.FEDE567
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CEBA18000A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:59:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pE9bdUfN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753441190; a=rsa-sha256;
	cv=none;
	b=0/9pD2q5S3bLsT63INWUBua+bXIh2CEgUcxOQFHNSb/a6ybOMFFAMAn4ntQhnS9ywRRUSh
	ppWojRuemm8NmxqE4vvo9iKaFxvpjdBGKa8u5AVSPQaEEwFdjioDoj9e9BWP55R6s+ky6Y
	G4XRoz46yeKDdOfI88fcHpq64bQYkpg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pE9bdUfN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753441190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zMIKxIMeWA6Y0zyT/VEWNC40kHI/lEjExxPURm2a8w=;
	b=prSZU/5866gcSgb0yzkdKzRIjALdTWAasufv81nmyGzXsL77iOXRe5Ag+TTs1u9UWd3ZvV
	bVecGulrnjcfiUvBCNIGe4CrdhlWbvjzTaJHH26GtHJSW9lydEEAXhGMWqCeA3Q3KZ+4ia
	IpgtGW1GVuDN9fTmMNJFoukGh7N68u0=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so8385a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753441189; x=1754045989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zMIKxIMeWA6Y0zyT/VEWNC40kHI/lEjExxPURm2a8w=;
        b=pE9bdUfNT1d+PBKWs/7OGL+2d+SfsnTOY4lpUhQbkKvLww1BaOMOaN9rSnMZl9tgMR
         j5an6H7loScbZJp7un2IP1hsNiv83o4Mpv7EvMvScIPVjma3X992croYnH1D+AQkCCHO
         aVJwxPTht0NCRedREy90kAM1sq3L8Q7gmLl9UIFrAQ3DRkyMp2tK9BCmJtEE7Bg5IVKi
         J1eoLa6IX31Z8pLPSDpDpxIfN/7WoMk4gE3viidPVDE+Rl6oMFpxLLYcBY+NcVEc7dKc
         Sv2vVn44mjVJf3kWgUKB/EmlMh1LuJrF+wOWQfE9xcAVRlLbzhQR/GPTpCcjs/OkU+ab
         RPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753441189; x=1754045989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zMIKxIMeWA6Y0zyT/VEWNC40kHI/lEjExxPURm2a8w=;
        b=sfEggXckiKUNo9EazWRScyxW25o9Izs1Wx78X5iS4zjetw2zFYUJoH3qcvEKn9lokD
         jXRv6+pCbjC1GxeUAOLGS6f8b/oXorGWojC8VBGP04GGbGKKR+sdhgnp+Ge/HhSKP1Os
         uoY0DaCBCGsdbBBO+8mWRtuyW8zXsEh9/dJGJU5VTfzOqmZPIMzQog39LxqAk5GZJkaU
         Vo4Yp2D3UCnjCpAC/CR+sINOodMhHmqk8c1ZHBvV62XcFXzdJQiC3C/yH9Fkl4kkcLYp
         Fhp1oorRNWuhUcpaVqpBunMNTyNNKQH5HF3856OSMpRZLaovYGiaHNLIbsBCgcmKqeD9
         HdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/sfu+Vr10HSYopKvT0cIf2nYDk+UO48SoH2phG1rSaTsyc21qgmR93WamGyrQfJ56BJkkaiveqw==@kvack.org
X-Gm-Message-State: AOJu0YyIYeJ1pnJgCSgY5LUyDMQNW8DuIPdfuWSC5IwGSB4Yg6OhmyNX
	DoqDu3TLtbPv/4fPuYXyF3ozVj1OiisKeQ3NCLvN4s5HCmWyf7GtZdT/cKQwe5ckcI5Yda7PiRw
	T/8BpjZeoMgQXrTtga53Y7Jz0Qh50MFZu48D8Elge
X-Gm-Gg: ASbGncvy8UQSPNt4CFBtypCIm7hy5tm7eIao3fMsOwbqMHcfoXWTjAkSmXvBBuJelVm
	fbhLJJZxC/ni4kJxWL4qtni1VcyYqIScDAAYPZIpTgA6VzpuniaV/xksD3hqITTa2el2UFXLBJc
	PP9QngEBZ79TupLFsdPxwkp5V6TtsKZUoiDDxWUnarbz8yYjVia2TIURCOMe+TYPOFNTIdUhTCO
	Btw3zpkCMHgdIoj01QXsXVYah155/w7Qqw=
X-Google-Smtp-Source: AGHT+IHnqQxYja1POX2W+kA/E0n2jk+M6mImxM6eux/jmZA5LUQePcIkwPQUBgG33sEbBErZ0nUIrhQvUBFLjnx7mxU=
X-Received: by 2002:a05:6402:42c3:b0:611:ff6c:50de with SMTP id
 4fb4d7f45d1cf-614e7af1571mr97978a12.4.1753441188512; Fri, 25 Jul 2025
 03:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com> <20250724145202.7f48386e9bd6fc8e114c3436@linux-foundation.org>
In-Reply-To: <20250724145202.7f48386e9bd6fc8e114c3436@linux-foundation.org>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 12:59:11 +0200
X-Gm-Features: Ac12FXwXJZU2HaMIy-bMzONk-qt6j5Vfpoiy2m2ctrYhU5gV6LCZ70luYNXP4Xo
Message-ID: <CAG48ez1A7ugLHxeBeBxqH6g37fb4iQo4g-O5F519v3rQQGWWYw@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9CEBA18000A
X-Stat-Signature: 7nmd336bc7xdeahpm1ci9oiwm84umop6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753441190-942467
X-HE-Meta: U2FsdGVkX1/uom5XWh2PRfl7dhZ/jevDQmK1CADEi/AZfL8D3sxYfttHjqyWUhEwiD5iJepO44u2k4uJtiRvdmbxlgLXktGu43qKbenOoR5vK4wLJg5dpc0pkdQcnoeUJ1nH42WrHJdo9vVL4Kl89c1gXwoOc9ydRLLSDF/ygLVdsVESurXBViaPPHDkQQCnx2CMZ9fmUe4krrqvCCsz7SbNV4LTz0Y9WDeDnMeJ/nbEXMRWI53Jovk2qee5vOeEqdapGfp4tsFqgXZpPkORtrfUqqHAOj0HPBM5j24ibZWyxHEDUZII+BH9BJd1J/teCmDaOWGbRYlr2SHW5iQ9WEWJ25M65QMSKkwglaUe7Hr9s/94LpXTveOYBAV1hhCyhnNi028AntY49ZLmpVIejLvTZR30BrNgLkgGSBa7tskNQx7s4+cCzjhM1nXvPRifv//gtLo0txIvNg2f5w4v/lvIH4IT4rds7LepzhQyCz4A4m0V5ypFBq8mTvkmvvRG2RxPx33RVxs9MTay5HJg5CrBgnUO1wkFcqHWE67I1wr6oKbsEqXNXmkPyqfOz7bnhQ6db3U50lqt0FGtsZMePjCN2GhIaNUErkhAX+XNT5Wpw5T+0YJm9IUC0apVmIzgiFQW4FnHcmnQAZYPcHhyy9VmetcNWtir5Ol/Ycc6MG2If4IhS9TGTIoom1FPnFnMYX147qnnqBMeaNKfQ1GL7ME3W/GUVkZ4eFfKvRt55tnKq2sb8EizogoKvv64cQ6I4I70+c8NLSKDrkfBWWX0ELGfICjWBUw3SMNiGkyXzCjE+T5jlS/SOAFqPRUat4BTZrt6u4aKr5/sUffdGYIjyOZi9Xk39tyPPfdFoMcKDOkEzB3u4Eq1idTGxPIsI3rNCIkSUZRPvlx5bfA7zqzWQEC513fPcKrwFXdoLEWAS+bLIZxeI2dkmFRNigtD5pdxiTkfEawGhTelnu0EF4m
 tkciFRDH
 GzfmZYGvtUHyU2vOsUQ5t97Vo8kdOxmaxbO1BbOq80GIcD9g01+O1dL/hR5yC1kvB/7EW7u7sUnsW1OEtA93qVc6cuPoSzPj1RBQAzeHwvICCKFk2AzmFWTdCih/DEa6RXjCvq+K2+CeOPzM91BriZJup2VeykKToBUkf+xL4IitBYtkF2TlM/pmb2pSgJJi3F89mYGD0N1UuDzW/CMbro5BdnqxeQZopUefi4U3DXWIwmlH1blIdiZAGwgKJ4bsZ52bCUhNJtivQAGZdsCsXSTvDJ8BxqhNctNfmCIBgqsUEUKlY1ZSR6MlcbROM2wsdngyo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:52=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 24 Jul 2025 21:13:50 +0200 Jann Horn <jannh@google.com> wrote:
>
> > If an anon page is mapped into userspace, its anon_vma must be alive,
> > otherwise rmap walks can hit UAF.
> >
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
> >
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages=
 to
> > hopefully catch such issues more reliably.
> >
> > Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
> > unlike the checks above, this one would otherwise be hard to write such
> > that it completely compiles away in non-debug builds by itself, without
> > looking extremely ugly.
> >
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
> > +     }
> >  }
>
> PAGE_MAPPING_ANON is now FOLIO_MAPPING_ANON.

Bleh, sorry about that, I keep forgetting to write MM patches against
the MM tree...

> The subtraction to clear a bitflag works, but my brain would prefer &=3D
> FOLIO_MAPPING_ANON.  Oh well.

(I'd prefer bitmasking too but the existing code does subtraction, so
I figured I should mirror that.)


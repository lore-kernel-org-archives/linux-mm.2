Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7846CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1443E94000A; Fri, 19 Sep 2025 02:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C9E940009; Fri, 19 Sep 2025 02:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AC294000A; Fri, 19 Sep 2025 02:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E25C7940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:09:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0456B7F3F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:09:55 +0000 (UTC)
X-FDA: 83904973950.17.97E23A1
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id A893B40005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:09:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OCHPhXl2;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758262193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czdF/BR/dGeL2IrJcv1ZVWhmTtjxJafouSf2NivHLrg=;
	b=oiBEMMmYOaUMfgkX+o9z9NMM2qL4b88YMR+oqF0ogGoOPg9xgMXxbxXMtX9byjo5O3DFnJ
	f/bwXKpFabq8jx5gb13M9nuKGfA1VyOQ8lgCFl7PRYf7sVkKXMdtpgSbWeeA+zDCwHHuzR
	69AUcNcNV1PndvCzwuotMRIVmYBgFMM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OCHPhXl2;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758262193; a=rsa-sha256;
	cv=none;
	b=bZJv8ruZqh6wpHHQZDhgMNjzhk+MHOuAmnpK7Og8XIKuHCKL2To8bdkMdWpJFgzP895dXK
	2b+4wdbGZQ5fZlOEM7rKH7rm8xY0X+QGnN2/e9Qd3onnVwU35TfAr5Cwr/2FCiBReQBngW
	C3q/K2QXYVLqRS9XrXSdXaRzZnMoAlg=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so8990a12.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758262192; x=1758866992; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czdF/BR/dGeL2IrJcv1ZVWhmTtjxJafouSf2NivHLrg=;
        b=OCHPhXl2yKXzIP00MuLD/X1VMpQ4yjDNnwoPebLcXFdDbmvStnqNycaimYVmA7o8Nx
         +OQPduNndxgLlvbPrqfWlyMWYNy2/rtmDQXlsKT26GVCatapineZ9psBdDvFhmZYidMD
         xG0V0B17D29wcK8okfcy1CRh/SnIPEqUOFtg8onja5oLkdqDOCRYx3ajnQ3eT6TAFh1Z
         8Qd6EKdv98VdcJlzLE5xNsL2fa8s+NntYGtq3hqIGv8WZf4gAZsOu/mz6mvw9A6cAVMc
         wRb5wSu0NSzIZqTDxMcwuhiwKZAO+mfZHyinWNnqTcmKuD5np1lJDbp8PQQr5KdUCFn6
         8v/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758262192; x=1758866992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czdF/BR/dGeL2IrJcv1ZVWhmTtjxJafouSf2NivHLrg=;
        b=fH3MG/xJvzI8NniGlYAY+OYtCcWP8TonZ2ZYm0v08kqh0HpombMH38N+McqMd+YFZs
         reA3TPrEGEAbWK9FzEPjsjzUdIvBlSgyOQ1J9YRWUWveW/r1rCB45WMB1O9gUrVfw8u9
         8XMucnXXEAauY7vKcmrZhnTUhTwwHetA1dvhFZNTVnDptpmqH0FdRv3PHqM6dw1gd7XR
         Nl2ondTPIDNYXohrWcAu9+Wa5KCueHFO5nXQ6Ry7hUWDIYxAZHca6AX/0CGHTtFHgFiQ
         0olIXJx4rbbQb2leUbV0f5cY62tJb9PkemUIbflIeHDFAdacgb3fpKBRc5k09rczd3zL
         VqTA==
X-Forwarded-Encrypted: i=1; AJvYcCX4i/5381cUUhFsShhJHoPLLOY8q45bXaxyBBynXWXkUOCON0WpgjyAh5x0hcowZCVgfEfOZQY7Ow==@kvack.org
X-Gm-Message-State: AOJu0YymlfQLN/6SlqRWTuuAocXDJgs1/GrreB7Sxg0U0+EW+DpiYhUE
	fWrN++OOPQI3lyreAKtgegpEkLyjUg95RX2vqoT2p+l2SI//SANyQqonudBk7Bsooyn1wh334Aa
	RwJ5Zn3kpAc9d6uhZudW+w75Qxw5v5JuE2aBUzZiH
X-Gm-Gg: ASbGnctE0xKNBbLDWzaUKZH7dzcpgPNEWPz9o1/GStrPD3XDqr0eaOqcl64rFsX02th
	U0B6KLdz4edccZn3x9Hpm9EHmMnQZFbJHyxcva4L21mMlu0wBzjA8Pfn2SIqOeHtn0x24G+x3Gi
	wgj7p5DbQYSfYWjNOA6FigWd/LgxECL1h61lbOOTTM3cyTmhvG0ZwwFBshd9YvnKnHRWdaH6m1M
	7dh/RXQu4i9XbHTjmLZmfStPz45AFU05LzoBqdw5zR3uzhf97xIi7tz
X-Google-Smtp-Source: AGHT+IFzdoNwtsF6+dyUnZ/26kkei/N8PzEDubWF81f9QbaXYSA9Hs8NQRUUOigROt3LOkDblCut8Ff9/i74cyRE/tY=
X-Received: by 2002:a05:6402:cb9:b0:62f:cb1a:5c43 with SMTP id
 4fb4d7f45d1cf-62fcb1a6155mr7602a12.1.1758262191873; Thu, 18 Sep 2025 23:09:51
 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
In-Reply-To: <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 18 Sep 2025 23:09:39 -0700
X-Gm-Features: AS18NWDX3myctZaBF6BvVF5dE5emu1m7lo39BJC1TtBeXkJBSpTEyLJ6vh9YJTo
Message-ID: <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A893B40005
X-Rspamd-Server: rspam05
X-Stat-Signature: 8ysb8yeg4it9qkyedoehn5d3bmhxjnip
X-Rspam-User: 
X-HE-Tag: 1758262193-608859
X-HE-Meta: U2FsdGVkX19ADx9ldlYHnMUARhKq73R0WgFn2audwOPAa8Wf1q6jyjjryWOVcs2ClSs1VlaShv4dskO6UumYr8Fqe4Q0L5ooVqoNCcKSwx9SwT5NgRN393i6wIb6IX1/9XTKjwZvmrQy0QhJsfhqRhi6ndC09b0smtHwFOUjbIBLfzJMTw1B0DZWYW0fwVXoOt401d7nnRRHj4Qa3CcJx/UwhBykYLIOYHLMMHtmsuxFanCvKxFnZC0Wr+n3ZXV7xSk8Ra1vu95EoKTLfGSoNQG2mx/0Q4x2AwMHwRZalC0SSk0uVEeJ2yiyENxS2Ev6yo/2wQUc+8AtZA1AI8RR1CBlp0tPcDPf1Re2OimNuiXLGIUPkBghlXbNaryjM4I0LqwQUQ0+s5iLoaynQHcCO+6Qqk1Y1RGe19LAEQkerH2/TVDdCYhgpirqxKIH7X755qf8pCA8gUUIIYWqv3zbFectQiyP3oTl2ZO7Rv5qUOC1u3Rm49VRWk3UlvDUQC07jhhFLSg0Jw7MMh256Hnyi17P74h9RItc5R4cAYBfTpYdg0afvh0aJY+0V2KG1fsXFML7NriMvxKQiWAvBd56NBN84E4lNtyDUYtKNu6VujCUsddKKGN58ZCpw/m/Ds5p7Td0BO4/UOBALApRU2i9rGJl6S8VDgKcKVL7u3rLBrcFxfgCOxpJ2fIPBSuP5Cr2MB6ZpFYB9Cn9S3sQPJBn6b9dOsZ64B/CJUr79WOsM07oI9TCU3VN/6POC/QRUD93vDom0NUafSuxUXlZllcNanPI48eiqOw+JiLCXEPv70WV/NuCicphwAXOczqDiKThNEVe0D69uQaAmUy2v32yMRu3mfsfrNnUjM7mftFxR07+yAw2Mpe6x/kJtsbw1P5RDwjJsk79LOAFv+DpdtpUosjwqaGY1GhZiJ0Q6U3dB+pUQ1elIHoxVc9OG+lULLY6HSa1sNGK56yH0ecY0Rw
 8MrozThd
 yBnRuXGbA6BXknOSfdLz24AsKS7Gur0pWNL0Epf3QrsIx3kf6UzBxppqUe//fGY2QKwutTRHvWiFaEf8oE1ylgV8h1D2e0X/l+HJl05IhrNZxqpbJadDsl83PbyVWZ9ILNUKKGxTAQs49CwfWe9dcBbZRibPXa0LnHEk68wWFmE8CTc8F2M+Kv0c50VP/9tZqNoJoMQDEovAvmBa76/7h0fLWO5Mo5g2vAyNC7DgGO9LouXwt15qTBYLJ+Pl714PdebqInG7dwXGbXTyr3I0gjRWWe0VSfCPdhVivIjLqXeWef3myz/abB4HyR7Cp4k+/cwui1nmz/97efQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 5:16=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 18.09.25 07:51, Lokesh Gidra wrote:
> > Guarantee that rmap_walk() is called on locked folios so that threads
> > changing folio->mapping and folio->index for non-KSM anon folios can
> > serialize on fine-grained folio lock rather than anon_vma lock. Other
> > folio types are already always locked before rmap_walk().
> >
> > This is in preparation for removing anon_vma write-lock from
> > UFFDIO_MOVE.
>
> I think quite a big bunch of the cover letter belongs into this patch
> here. In essence, why is it okay, what could be problematic, history
> etc, etc.
>
Actually, I thought that eventually the cover letter's text will be
copied here so I didn't want to duplicate it. But I guess I can re-do
with cover letter only containing the 'why' part and each patch
containing the 'what'.
> >
> > CC: David Hildenbrand <david@redhat.com>
> > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > CC: Harry Yoo <harry.yoo@oracle.com>
> > CC: Peter Xu <peterx@redhat.com>
> > CC: Suren Baghdasaryan <surenb@google.com>
> > CC: Barry Song <baohua@kernel.org>
> > CC: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> >   mm/damon/ops-common.c | 16 ++++------------
> >   mm/memory-failure.c   |  3 +++
> >   mm/page_idle.c        |  8 ++------
> >   mm/rmap.c             | 42 ++++++++++++------------------------------
> >   4 files changed, 21 insertions(+), 48 deletions(-)
> >
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 998c5180a603..f61d6dde13dc 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
> >               .rmap_one =3D damon_folio_mkold_one,
> >               .anon_lock =3D folio_lock_anon_vma_read,
> >       };
> > -     bool need_lock;
> >
> >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> >               folio_set_idle(folio);
> >               return;
> >       }
> >
> > -     need_lock =3D !folio_test_anon(folio) || folio_test_ksm(folio);
> > -     if (need_lock && !folio_trylock(folio))
> > +     if (!folio_trylock(folio))
> >               return;
> >
> >       rmap_walk(folio, &rwc);
> > -
> > -     if (need_lock)
> > -             folio_unlock(folio);
> > +     folio_unlock(folio);
> >
> >   }
> >
> > @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
> >               .rmap_one =3D damon_folio_young_one,
> >               .anon_lock =3D folio_lock_anon_vma_read,
> >       };
> > -     bool need_lock;
> >
> >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> >               if (folio_test_idle(folio))
> > @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
> >                       return true;
> >       }
> >
> > -     need_lock =3D !folio_test_anon(folio) || folio_test_ksm(folio);
> > -     if (need_lock && !folio_trylock(folio))
> > +     if (!folio_trylock(folio))
> >               return false;
> >
> >       rmap_walk(folio, &rwc);
> > -
> > -     if (need_lock)
> > -             folio_unlock(folio);
> > +     folio_unlock(folio);
> >
> >       return accessed;
> >   }
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index a24806bb8e82..f698df156bf8 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsig=
ned long pfn, int flags,
> >   {
> >       LIST_HEAD(tokill);
> >
> > +     folio_lock(folio);
> >       collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> > +     folio_unlock(folio);
> > +
> >       kill_procs(&tokill, true, pfn, flags);
> >   }
>
> Is mf_generic_kill_procs()->collect_procs() problematic?
>
> The dax_lock_folio/dax_unlock_folio part confuses me: I think it only
> locks an entry in the page cache but not the actual folio ("Lock the DAX
> entry corresponding to a folio")?
Yeah. The name dax_lock_folio() gives an impression as if the folio is
locked but it isn't :)

IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
an address_space instead of anon_vma), right? So, I thought it wasn't
required to actually lock the folio in this case. Please let me know
if you want me to still lock the folio around collect_procs(), or add
a comment?
>
> --
> Cheers
>
> David / dhildenb
>


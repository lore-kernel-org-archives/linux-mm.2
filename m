Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7007C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C61C6B00C2; Tue, 14 Jul 2026 10:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977536B00C4; Tue, 14 Jul 2026 10:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8664F6B00CC; Tue, 14 Jul 2026 10:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5290D6B00C2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:28:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C31CC40393
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:28:04 +0000 (UTC)
X-FDA: 84987611688.06.8EFB306
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id C59021C0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:28:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hMu36plc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4B/kN2tOm8HvOthVfdrwOHJC+6JLP/8BE/hz7vCTkg=;
	b=6FoGVInHUaKmH96J/hfLmB8x65Q68JZUYIUJfDIewuyLSWiJlyP0yn4enxB0im4qFOjgF/
	jnSe7QvZnX6mRZmYdjpTDGmQ5pb8p3LgcEo19jHTcbbBrkcuF58fWpxOUePQq6qs9UWCLV
	wEWNOv58HEDgx5m0rD4j29UbehekZ3A=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hMu36plc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784039282;
	b=V1CwoTUkM/ijdnyYG3cQur3pJgIn4xeTD10klzaTD6QCfY7PI7on+SjntyWxoyuGfysAPV
	VhLw08zfI38zPdz/WNYbgmYETvfggIfXAI5un39uQ936fTFDsQZh4UxJC1X7gP6/cbUb8a
	3oJlhooIAnEaFoxDrOm1GjOapMjLkXw=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c15a5b265so317361cf.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784039282; cv=none;
        d=google.com; s=arc-20260327;
        b=en0iQxmwu+ozyncEpHLHzYlV/S5gZ0NXGc+TaskUJypnxLavrg8p4qG6gCnfgoiFbt
         M7YkjPrzHlHorwjRmEhyISoaeLvYkIhoi72dxwcO71oRtYoYI2MCPeFkfm8JgcSFUgXx
         EBQ23N2v5Mt6v+xXF3QAytz1h005xgmwnK7kyQh9sxtv5aZpY0ypy/p/+dbalS8uMgGS
         2+lW9GGRyI1BCKsQEFkRSRWFIvGtUnoyMPgQNR6vQdYw9qjAxI2JbiQs1+H5+bXsM8lg
         xB+MXM7he6u3XzgTxL0LNqmp1z/0EstjyzOdseWeAOMuyZGYZjvF6j2ilD2oAChc00zr
         1R8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4B/kN2tOm8HvOthVfdrwOHJC+6JLP/8BE/hz7vCTkg=;
        fh=eLQggCrv16O18GVrARXMaVLt3nNMxgS21AQG2QlkhYs=;
        b=h/KdsikqEaUdyGGQL0iAjsPqn0y+vxAwrsY9qP/1zxjxwREdcTWkKWVJL/OyVJChhu
         5jPbOuLCeaGAjXdg7gF94zyZGABHfbdXBVqR0ejDdr9eWDp5fLeiOvYD2GNCD/Jo5yfm
         xUFFqeggSRTR/NzzUYUzl0SslN8ESzqRrLgRUvViLxLrIx+ktY15heHOo1z5la/G9DGt
         pKMPRETt+59urYk2knko9HHmQRaWPmQ6dtyeBH5Br5Rgl3bLf7JEewb7BoRgpGmCzltx
         DZx/sphxXCnas6NqXBkv2qA6ZrOhiFTnfZF0CR2vUkshgDWHM+rJP0x6LZZwNbAKC/Px
         42Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784039282; x=1784644082; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4B/kN2tOm8HvOthVfdrwOHJC+6JLP/8BE/hz7vCTkg=;
        b=hMu36plcjTNnL8DU6Lvl4akiIaKJqYxQKSUQ6aSc89Sqml4fO4dx+dRuBHMzW+AcER
         W/NmdthCWV7owKyZAds6h8mdDsItVKIqd/liRCFREUomGbFTBXtmZhBFXMqLH2jAUpVg
         LtLEFcYAyVbHN9Qx+uJIoNBqI07U7fWABTSHONPT53D6UxAMiP9swxImQU8ImU667H4q
         1O0W9PZAgM6SdYZM0iwTl3jedF22U8zS6KwhiKFH99NMUt64uBMVX2B+3K1uspvyiwi9
         umCKltdMsmQZODwig4+9CnRK9Sz36S8UUHfaLmTkl6P9vuMg50E4hUGlPo8LsWiNiQAJ
         RtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039282; x=1784644082;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4B/kN2tOm8HvOthVfdrwOHJC+6JLP/8BE/hz7vCTkg=;
        b=Pniho+mEDDlLspIe1zlGOzyTF87Fdd6h5XRu4josYLGTZmZMr5zVGK8ASZkKPtt9a6
         tW2inBzYJ37dE6W+w973ijfZsaZYEqHOPhN0kYaB4uzMZm+dlV2F1v5RaBDNf/Qzrajx
         J7aQYl+hK7CfoWAA8Z9oapOSN0lgPCHc/mc+IkRHgin3hOS57BaITxDxWcWvYc3z2J2J
         NGkW7BU/M6E8eHhQFGqMT/bElBeA9l8p93x6ClFMIAJIzJ59TzhK3X1U9WdvNdAUpv5H
         1TKbubOyBfJkWyjvFDNsAfRPyTRtXAHXw4emrOECPWBiz593LDpOuBZqr2eOtDs6HDrq
         Aoxg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9cdj0BtGaUEQqWLc9DXyu3AcEwf8f/wAW5JInqDzIBnMG3RgAaALKXV//nYBA8Fzse1peHaMJHA==@kvack.org
X-Gm-Message-State: AOJu0YzMqc3tcJwG11YwSmwGARxKff29U1sAWlSO25pdLOym06/qY00E
	VloA9YY65BMApylvk6pg37mbSqhZjkE2czVmySCw2fAZYREZ+Wq8+AGvxq1xlA+jL6N/foRuVJp
	RtHztNYYFDof+9qZ9XESSmPJG6NIuAnlOoWcdsKMi
X-Gm-Gg: AfdE7ckPKvQOWUwJvxTcTcjKwwrHc0rLDPa/0vM1RC/7ODx3pRF/AnEOTEPM4wPyaKl
	vGSir92749w+7WY2FNBYoeMiFRoEw8cOtQkDGUiTJNDQw6HrnttYxzk8+l5cuB1a8PLJsG+LNB8
	viIjTeR9EiBN3S67yqAX7GMZkKrpyXwya0UjoblheLawknhcYFhm3ECDfkMz6pbHnvtlt9qZ4T0
	R2CwViGul3OwgIuRn09XAxFrPteOiQ9rpvX0nuAEPl9AbgLqoYDqJ4LN8GFNahmVyDb8P8Snz9B
	USHU6+IdXjFwn5R9Fm7ECSmTQSuy/wkXzYv4aA==
X-Received: by 2002:a05:622a:289:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-51d7bcc96ffmr14384931cf.7.1784039281041; Tue, 14 Jul 2026
 07:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org> <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>
 <121dda1a-f050-4035-93c0-6a36278e50b7@kernel.org> <87f607bb-3766-4b90-b3cc-a98d3cadf760@kernel.org>
In-Reply-To: <87f607bb-3766-4b90-b3cc-a98d3cadf760@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Jul 2026 07:27:50 -0700
X-Gm-Features: AUfX_mxM6MKd6lYzY5gADqHjc7MtmsEzHEclvBmankGe7_dzOZ5a3j8Vh1Q1vaI
Message-ID: <CAJuCfpGodo28+dZBJLkKPysoKg_XxMX55JrAH=Jx8OD2fLjzVg@mail.gmail.com>
Subject: Re: [PATCH slab/for-next-fixes v3 4/4] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C59021C0009
X-Stat-Signature: q1pdpqgayxftiy95y78htmyzebd4zrb6
X-HE-Tag: 1784039282-719236
X-HE-Meta: U2FsdGVkX1+cIeOqL9yM20apignimFxk2nip4ZyyFdnSmbo61MpvPo+FMGuFGQG+/BKmb5IfNM65FercuKusAxFFCq3tY+m8sclijcbLOSHpRbQBSFJ3y2fuqkGfjihCHJzEKjihbDW7enEo0kxXs+g3urbwZwpK+ONEBQi3sK+VhUXeAqDfC6Wx48NjZjpJrmU1W7bmNphk1kx46Z/hGqrv8GtuTaFHf7eyCs/TL7dQK2AWnErfncZJxHNHxSVtvpXfcigK4wAypdDAuPwBfoKgVK/XyvB8ou48nWddTcD7qQNcFaxVuTzPXlPVAvB4Z+0IWEjMyt4bsex8dP+MBCwrGaLRHo6tzDuUNZWN5NyUvTrBWjNzOT4p04OSQSvwSytINtvFxKtsbHaYlhvl8xxg0Kd0P6AzFO8f3L7IVhxB4MsMe/KlhHZzJafZu99KSmjknXu3PflJmueyKvXDOVKAhs/W4gcSJJ/F9lnBXFVHmhgTQPSaAPKWwQ+cvkrx43VAEj/52cX8d0ZNCVODxtLjbVdifn5OELJV4eGx+FUvSmfQqSSc2WvH5MOBIUbNdnGd3Nva7LBn8vnYaJDV20lRtNWaZKPKT84aZrz0XhX7TBv6SXftKBBZBCbavVbjwkZ5hHic6D2ZOsDcrg6aiyTDbXnYHAC+Rx7wuSotQW9DPGHp8OPRsT2SMZPF7Ycim159c9raWjaSa5MeKN6XDdFVz5zIMZ74Re1gKHds1JJl/Vq8787jvwi390BCev4KDrLRGDxsCmIKaBiC6Zz06cClFOnmMlZo31k3b2bAoUaVuq2z1aut6DjsaYIEJ7RG5LBHYBj5AihD9TOu+8Ob6y0hgG6qip3fRfrejDp8nf293lmrdFDYEjAURC1+F8QB8uEt6lVg7metVsmrywJgW0+Q5cz8zZC09lVk/b92gt9bfkf6sjJr3EVWEkV095lZXCo+CzKR9NwuoyBaEjK
 VBTX523e
 HTy2xLJw8wzHOpQDpE0T37AGt6dvhPIAxqSTRhuxH3JDM8uQw538SK/Znlh7NO/gPm92dY0mGvaN6oK2jEzCkJEYwtBQCOQw1VT5uQ2/bKc9yVbD540eFH8S6MUWvGb40hoQ+68USqLxkJjeTaj6U1HIbitTaRMpN4HW97LSrsywcj8oK73Osxdf3el8WH2yyC8hAf1bc8BAojTqkLtiq8IiTwQjXzvY3lsEyk1TvrA/tyJpgd1sc1CCdjPU+H+oFpvsooMk8hODOI/c4aZbQu90ct0o4wIvO6eeL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 2:12=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/14/26 07:17, Harry Yoo wrote:
> >
> > On 7/14/26 2:08 AM, Suren Baghdasaryan wrote:
> >> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kern=
el.org> wrote:
> >>> @@ -386,12 +387,17 @@ static inline unsigned int size_index_elem(unsi=
gned int bytes)
> >>>   * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
> >>>   */
> >>>  static inline struct kmem_cache *
> >>> -kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_toke=
n_t token)
> >>> +kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_toke=
n_t token,
> >>> +            unsigned int alloc_flags)
> >>>  {
> >>>         unsigned int index;
> >>> +       enum kmalloc_cache_type type =3D kmalloc_type(flags, token);
> >>> +
> >>> +       if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
> >>> +               type =3D KMALLOC_NO_OBJ_EXT;
> >
> > Hi Suren, thanks for the reviews.
> > It's indeed helpful to have an eye for those bugfixes.
> >
> >> Why not let kmalloc_type() handle alloc_flags?
> >
> > Good point!
> >
> >> Other users (there are
> >> only 4 of them) can pass SLAB_ALLOC_DEFAULT. That seems cleaner to me
> >> and more robust.
> >
> > Hmm, there was a reason... *checks notes*, oh, there is no note.
> > IIRC I was afraid of exposing SLAB_ALLOC_* flags to arbitrary users.
>
> Hm good point, they are in mm/slab.h and kmalloc_type() needs to be in th=
e
> public include/linux/slab.h. Given its usage in __builtin_constant_p(size=
)
> paths of kmalloc[_node] I would rather not complicate it (even if a
> hardcoded SLAB_ALLOC_DEFAULT should eliminate the extra code).
> So I'd rather keep KMALLOC_NO_OBJ_EXT handling hidden in mm/ as long as i=
t's
> possible.
>
> > should probably fine as long as it's not used in
> > kmalloc/kmem_cache_alloc() APIs, not sure.
> >
> >>>         if (!b)
> >>> -               b =3D &kmalloc_caches[kmalloc_type(flags, token)];
> >>> +               b =3D &kmalloc_caches[type];
> >>>         if (size <=3D 192)
> >>>                 index =3D kmalloc_size_index[size_index_elem(size)];
> >>>         else
> >>> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >>> index b6426d7ceec9..03ecac12cd86 100644
> >>> --- a/mm/slab_common.c
> >>> +++ b/mm/slab_common.c
> >>> @@ -957,6 +968,12 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_ty=
pe type)
> >>>                         return;
> >>>                 }
> >>>                 flags |=3D SLAB_ACCOUNT;
> >>> +       } else if (IS_ENABLED(CONFIG_SLAB_OBJ_EXT) && type =3D=3D KMA=
LLOC_NO_OBJ_EXT) {
> >>
> >> Hmm, you have to check IS_ENABLED(CONFIG_SLAB_OBJ_EXT) here because
> >> KMALLOC_NO_OBJ_EXT can be aliased with KMALLOC_NORMAL... Could we
> >> instead have a helper function like this (maybe with a better name):
> >
> > Hmm that's fine, but I think that bit should not be part of -stable
> > fixes at least. Here I tried to make it consistent with KMALLOC_RECLAIM
> > and KMALLOC_DMA :)
>
> Agreed.
>
> >> #ifdef CONFIG_SLAB_OBJ_EXT
> >> bool is_kmalloc_no_obj_ext_type(type) { return type =3D=3D KMALLOC_NO_=
OBJ_EXT; }
> >> #else
> >> bool is_kmalloc_no_obj_ext_type(type) { return false; }
> >> #endif
> >> ?
> >
> > is_kmalloc_no_obj_ext_type(),
> > kmalloc_type_is_no_obj_ext(),
> > is_kmalloc_type_no_obj_ext(),
> > ...
> >
> > naming is hard, ugh :)
> >
> >>
> >>> +               if (!need_kmalloc_no_objext()) {
> >>> +                       kmalloc_caches[type][idx] =3D kmalloc_caches[=
KMALLOC_NORMAL][idx];
> >>
> >> Could kmalloc_caches[KMALLOC_NORMAL][idx] be NULL here?
> >
> > No. KMALLOC_NORMAL caches are created before all other kmalloc
> > caches.
> >
> > IIRC checking if kmalloc_caches[KMALLOC_NORMAL][idx] is NULL was added
> > by commit 963e84b0f262 ("mm/slab: limit kmalloc() minimum alignment
> > to dma_get_cache_alignment()") to avoid creating kmalloc caches of same
> > type and size due to minimum alignment.
> >
> >> In general why do we special-case and do an early exit here?
> >>
> >> Can we do instead:
> >>
> >> if (need_kmalloc_no_objext())
> >>     flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
> >>
> >> and use the common path?
> >
> > Hmm, but even without SLAB_NO_MERGE, we often end up not merging
> > kmalloc caches e.g.) because of non-zero s->usersize.
> >
> > I think that's why we do special-case and an early exit?
> >
> > We could probably do some refactoring to change that, but in general
> > I'm afraid of backporting refactoring work to -stable because I fear
> > introducing very subtle behavioral changes that nobody would notice.
>
> Agreed, let's keep hotfixes as minimal as possible and refactor later.

Sounds good. Feel free to add:

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> >>> +                       return;
> >>> +               }
> >>> +               flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
> >>>         } else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type =3D=3D KMALLO=
C_DMA)) {
> >>>                 flags |=3D SLAB_CACHE_DMA;
> >>>         }
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index abe748b7dddb..a34f9b8770dc 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -2168,14 +2132,20 @@ int alloc_slab_obj_exts(struct slab *slab, st=
ruct kmem_cache *s,
> >>>         unsigned long new_exts;
> >>>         unsigned long old_exts;
> >>>         struct slabobj_ext *vec;
> >>> -       size_t sz;
> >>> +       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
> >>>
> >>>         gfp &=3D ~OBJCGS_CLEAR_MASK;
> >>> -       /* Prevent recursive extension vector allocation */
> >>> -       alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
> >>> -       alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
> >>> +       /*
> >>> +        * In most cases, obj_exts arrays are allocated from normal k=
malloc.
> >>> +        * However, normal kmalloc caches must allocate them from
> >>> +        * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
> >>
> >> For debugging it would have been convenient to allocate all obj_ext
> >> vectors from dedicated caches... Maybe we can do that for
> >> CONFIG_DEBUG_VM or someday when we add CONFIG_OBJ_EXT_DEBUG? Anyway,
> >> not really a complaint but a wish.
> >
> > Vlastimil and I had a conversation on always (even w/o debug options)
> > having dedicated caches (primarily to separate lifetime and for
> > simplicity), it would be interesting to explore.
> >
> > https://lore.kernel.org/all/2436707a-b6ab-45ec-98e5-538e18589462@kernel=
.org
> >
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B7BCCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159738E0024; Thu, 23 Oct 2025 21:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131FD8E0002; Thu, 23 Oct 2025 21:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046E38E0024; Thu, 23 Oct 2025 21:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E587E8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:17:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4E4129642
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:17:34 +0000 (UTC)
X-FDA: 84031245228.20.0CAD6E8
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE3A9140002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:17:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bMXuJI8o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761268652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3zHmHY0wWNmA7YX6JIwCze7iW5GE1jfUcaWfSkBPyQ=;
	b=v6encBNJ7yB6exEqh544y/0tBYozRbVwwsbk426qD+mIgtMwkKzImPOCMy6mzGHyQdK5Q/
	ZKcmSleTLeSZIZuD8tSASiCWvmzhwlOqN/stRynKqcKdrZ1xLQ8/Jep+x8/aLs6dzFeipV
	wh2HMNYX8bgNn3C0i7WD/heTwxBqrRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761268652; a=rsa-sha256;
	cv=none;
	b=agQQvZoIX8gG27KiOpQb1YZyZ5r2JXS1OeXa/XIf6m6gdlyqys0D6Gc+zLqFMgOOBWn+wk
	8hVKmrNv/YdfaEqgRYiHVWS3cyjW3Q9JYhOSMx8P3iJKzPv4OaFXg9yv9SSXCLh/D2LFKG
	FUjLAyxd0RcSSdD4Su5a++5dWbV2PvQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bMXuJI8o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso714440f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761268651; x=1761873451; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3zHmHY0wWNmA7YX6JIwCze7iW5GE1jfUcaWfSkBPyQ=;
        b=bMXuJI8oH0gumC/kZ+1X4yYv8vsFZ4LwIw9APm1JvXzykq0dnls5ZeHD79jc8pWWul
         JkztVOKsReurXstqlXCXYXLgP5u5SBf1pT0f0v8HZY6RjYcsAjnymuowYpE39J0fJlOz
         GiFSaP5Gg065gNodV8K91IPMtvdhV7tC/bVviJjxw144q+nALqT6Aw0EGauwgi1lAGyY
         izorL5DVCOCdyDvBrnd6owzldwWdP+oztDPs8lr4caN8YX5qx8UvtDtyTMZIk051IDap
         8bnoQF21NXHYZaALh0eyqeCFOuD8oAPMmZm8Wu1be8R5XpVFYjUYk9KtZ5Bv982zR/2/
         Eejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761268651; x=1761873451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3zHmHY0wWNmA7YX6JIwCze7iW5GE1jfUcaWfSkBPyQ=;
        b=JDcAqnQhOglMyPvDkxuk5whGkVgsrISucMh1gOFiEE+d+yfX2yZe5O6pgW3MVCdO9P
         aQB525ja4epLLckoP++/UOlYxdguJwJnwNy8SCwNIF1X9p0tdhX8PM63Nx5yxIY03Kxv
         nONdt8qyLSMNaAdIpd5CjiEOgP76BfB93w+q4QF+h3UrstED/qT6M0o4KYLHfWPqMCUy
         6JfMZ0Ju1Afbz3XxAo89EgyaaNsVh6bKMnPymT3U9ekrgOChME43eB7Q9GOJTy45LZe/
         /uV7KQyB/uwjxA9TmNnWlgFnBLr7DR1fpori8thdMUySgW7VGOHxLGbF9ulsBL77l2Zm
         kMnA==
X-Forwarded-Encrypted: i=1; AJvYcCWrh6IeCFhOwdGk5mCbGcu2uJDdLx7tF/rhT+qBeINmKXDLuAMgRKWg42s8OCX3N1WJUpgELUh+wQ==@kvack.org
X-Gm-Message-State: AOJu0YwdbVXDzAUhjIwAAsuDTPAYCovPEiSF92EHRrHlloxW3qCZwRj3
	LXWYMGONpwGw5UwXPVOhJspNnphKX7MTpcVg0bdGSLvNBsc2r4TXllWZ0wk2o/4+CpbgWCCZbcj
	/SvU5Cc96UTvmqgrn3QW4TL3yRsGCM9E=
X-Gm-Gg: ASbGncuKzu3b0riAb+j+YVA1ddBhE2jOmX7r+QQAO+vdhX3rsOR228k1i5f854jh/v8
	pshbH7AySihr7uSVZ1PLodhfvMwKlXFqICnJlekMcIjsKNhBABmj/8jYQegyAeyAIUuY3y7fUJW
	/VjXG0P2kQFros0oV8eT8SBb4B2ymvGAhqVpQMIvqtvUQnGFsCwVdN29NrqyJ5RwMobjQwJDGD/
	Nl5sysD/im0hlGnLFAxIxISuBQ8FbcgimDRZQETgFcaHTRHKpc2GvySJcwhJSzo3yWosgbCDcMZ
	l5VBPSM/x7AvSRN/ye++cPQ62iIk
X-Google-Smtp-Source: AGHT+IEGRhrEDARsG6SwhCqQZ2ggjkKy6wrPhCyBYBN8Ml1axOYzO61kARTnkCoS/FIkzkx5bn85iTPh6XC8jpxUxTQ=
X-Received: by 2002:a05:6000:420a:b0:3e5:5822:ec9d with SMTP id
 ffacd0b85a97d-42704d99f29mr17881918f8f.41.1761268650818; Thu, 23 Oct 2025
 18:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
 <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com> <aPrBp_vG_D-8qG_E@hyeyoo>
In-Reply-To: <aPrBp_vG_D-8qG_E@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 23 Oct 2025 18:17:19 -0700
X-Gm-Features: AWmQ_bmNLJKrBBELDDyir78kpvEcRY3Ls9NHMGZzBjMo5Q5IjnMYV8X6iEIDoJE
Message-ID: <CAADnVQK+3GLbq4GjOYO0Q6vhURPyNyy70bZKUUwRpLuK-R8NAA@mail.gmail.com>
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to defer_deactivate_slab()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BE3A9140002
X-Rspamd-Server: rspam02
X-Stat-Signature: od5ioxqen53jebssqucj1j7supxkfjgj
X-HE-Tag: 1761268652-612979
X-HE-Meta: U2FsdGVkX1/xe35iZA8/c77D061C+5rUg3cz+iAOHUk33x+Y8Qv/VftE2lw4dMoKPFWoWyZHFrGJE9enJveFYkV0z7xyM0TK8KTOEqwqWUXA8VftDAWtok6yJW24RrY67BGL93OvH2i3Pua4r3rsjxzoVLfkff0qB7yDd5KXooEkP/wtEYqIHFdmYidcmagRDgIzfDmhnbGKchzq0hi73DjqrYiRnXDu67dwpjyuROO2V61J6zTBAbgWrRmrBk2M0GPWjjGGowmIFnCmK5pz9FnZL7aZq5+CK5VsWW/g/CSAW3T+7yVg10RHpezQuJgmb/I+D7nAnhhas26e0Ay9eW1c8DMBUCWGTtBoqHUOnn0tQcbwo0ROmiSbxvx/3Tj+Nttk9rt4P9V42b5YcTW29K0m8bSrld34Yxmr7MgquZDJCpUqvZbCIbstviD2a6/4QeENDc9UVZmem9Z/DjaNmR8WTxvK2VWmk1nHUyFNW99EsLy6DoOpbNjTySNdgof8FV94Zq2mg2YCa6UWUCu1tg9HZE+jEC0Wo0z73sGh2QpgxA3bxUwJGie5GpQRxoNsLy2Ie1v7hAIp/fQydXwStD4nrYvcC5z6jCKXc/Ht7tuKvLEHunhrIe0z7baWtnmQQIi+YoCEBinRY9/bvlYl5u1WVmZBURUTiLsPbmDsC8TB9etXDfGFoAMvqRRsKJ/DjyHEqRZc6YesTt7MHJJek6Phdo3d2Rds3Zs25FK9DJEbedJIF8+2q0hKhk96ltu1Lurd1CZvQQrWL0Dr6oezb5t2QrH6nl9SvfoaZrQ7aGDDXZfAkbg2v15sibjBkQ4gcgCO6q7x/LUhEV7CK/N4zKery54fGz1FSEKFytkhYJQrTIV93xJ5UOXmh985kjHbjbAGoPWlnadhxjcovsTQdrta7fFJg7Z0qUH6/Rbxq1zuqjkccylFd/CIv9oFZUEIxc6S8erlvMVb0U6wt82
 HSsakENT
 plwhfkhgMb8YmiPCJqlxiZialELSWQDOj7uKDu7EPUFmryuj3kP+qqMx+Rp5qhAG/yq+AIULyT3SyFLRGdCvDSRt2DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 5:00=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Thu, Oct 23, 2025 at 04:13:37PM -0700, Alexei Starovoitov wrote:
> > On Thu, Oct 23, 2025 at 5:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> > > kfree_nolock().") there's a possibility in alloc_single_from_new_slab=
()
> > > that we discard the newly allocated slab if we can't spin and we fail=
 to
> > > trylock. As a result we don't perform inc_slabs_node() later in the
> > > function. Instead we perform a deferred deactivate_slab() which can
> > > either put the unacounted slab on partial list, or discard it
> > > immediately while performing dec_slabs_node(). Either way will cause =
an
> > > accounting imbalance.
> > >
> > > Fix this by not marking the slab as frozen, and using free_slab()
> > > instead of deactivate_slab() for non-frozen slabs in
> > > free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possib=
le
> > > case. By not using discard_slab() we avoid dec_slabs_node().
> > >
> > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolo=
ck().")
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > ---
> > > Changes in v2:
> > > - Fix the problem differently. Harry pointed out that we can't move
> > >   inc_slabs_node() outside of list_lock protected regions as that wou=
ld
> > >   reintroduce issues fixed by commit c7323a5ad078
> > > - Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v=
1-1-27870ec363ce@suse.cz
> > > ---
> > >  mm/slub.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 23d8f54e9486..87a1d2f9de0d 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct =
kmem_cache *s, struct slab *slab,
> > >
> > >         if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags=
)) {
> > >                 /* Unlucky, discard newly allocated slab */
> > > -               slab->frozen =3D 1;
> > >                 defer_deactivate_slab(slab, NULL);
> > >                 return NULL;
> > >         }
> > > @@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_w=
ork *work)
> > >                 struct slab *slab =3D container_of(pos, struct slab, =
llnode);
> > >
> > >  #ifdef CONFIG_SLUB_TINY
> > > -               discard_slab(slab->slab_cache, slab);
> > > +               free_slab(slab->slab_cache, slab);
> > >  #else
> > > -               deactivate_slab(slab->slab_cache, slab, slab->flush_f=
reelist);
> > > +               if (slab->frozen)
> > > +                       deactivate_slab(slab->slab_cache, slab, slab-=
>flush_freelist);
> > > +               else
> > > +                       free_slab(slab->slab_cache, slab);
> >
> > A bit odd to use 'frozen' flag as such a signal.
> > I guess I'm worried that truly !frozen slab can come here
> > via ___slab_alloc() -> retry_load_slab: -> defer_deactivate_slab().
> > And things will be much worse than just accounting.
>
> But the cpu slab must have been frozen before it's attached to
> c->slab?

Is it?
the path is
c =3D slub_get_cpu_ptr(s->cpu_slab);
if (unlikely(c->slab)) {
   struct slab *flush_slab =3D c->slab;
   defer_deactivate_slab(flush_slab, ...);

I don't see why it would be frozen.

> > Maybe add
> >   inc_slabs_node(s, nid, slab->objects);
> > right before
> >   defer_deactivate_slab(slab, NULL);
> >   return NULL;
> >
> > I don't quite get why c7323a5ad078 is doing everything under n->list_lo=
ck.
> > It's been 3 years since.
>
> When n->nr_slabs is inconsistent, validate_slab_node() might report an
> error (false positive) when someone wrote '1' to
> /sys/kernel/slab/<cache name>/validate

Ok. I see it now. It's the actual number of elements in n->full
list needs to match n->nr_slabs.

But then how it's not broken already?
I see that
alloc_single_from_new_slab()
unconditionally does inc_slabs_node(), but
slab itself is added either to n->full or n->partial lists.
And validate_slab_node() should be complaining already.

Anyway, I'm not arguing. Just trying to understand.
If you think the fix is fine, then go ahead.


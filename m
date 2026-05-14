Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0528FCD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC56E6B0088; Wed, 13 May 2026 20:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75996B008A; Wed, 13 May 2026 20:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D056B008C; Wed, 13 May 2026 20:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7A136B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:16:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEC648D6A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:16:06 +0000 (UTC)
X-FDA: 84764107932.29.FD525E3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA55FC0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:16:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SM2On/Xe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778717764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGX5uN02axDPiLieAjNAx0PveomaAqdXlNmPT0r0nPg=;
	b=3f9Pdz5wxWQNyMT2SPctJdFLKBar3rwIYihwWxJTTI5B0Budn7uhp9kmj6iM7LjYX6FMGg
	2NtEsvYGZyX9Bxg9AuYFqbo8HQQjHQdnRQjxEInFb/zC3nqxoZ8+0VFOVqXhq6dWtmen5G
	nInTExBnrMWomgLwQ+/98V4jJTH2hyQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778717765; a=rsa-sha256;
	cv=pass;
	b=SCZz6szFF2/Xv5H0dl7ER88cF4+gbYsQrr8fmr6QWVZt+r6xUMqdZKLRrfbFmSxz/2Z13x
	Z+8DEnAXA3u0BDzVeBmX6VFvvdhtSqR3/FDVUKKMTNJbLxRUb9SzMFo2Q5R5QM1uhyXDf0
	weBVAPpuSu/lp6pDmZJeyMy26dXul4A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SM2On/Xe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d864c23bdso145161cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 17:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778717764; cv=none;
        d=google.com; s=arc-20240605;
        b=Z4lC4SQ78n8QbvNVv5T5SPK9zAJ9LDJcscgl5u4d4B7jinpB/4FNGRweZzcjN99bkZ
         dmXMDpwzioD0fD1yFxEdxCBtix7EPc1Z6Z0ktMWa4gqgnk5SulQvUnMyXMTXbwtQ4d3H
         qIkFydaycscvX+bFJ4jS6ENs3hMNihELw7GISyRWiJxHI79+M49yWU9bksbB/SN5MHQa
         caLPdRewAgVEKzMaIH3YJ0ISTSoZi9tLwbLL7DdsDkC2JU0KBRnNqw58m8Jb7C5RiX16
         sXMEGLShBZW4eWl3HayoODBAaafxxA4PlrhZzYtBCf1VeQXC6f46kcDMeM7sVuwjxPSO
         ZuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RGX5uN02axDPiLieAjNAx0PveomaAqdXlNmPT0r0nPg=;
        fh=JZvpf3fmWaJjlQcznQV6ghs1tdLkdVgGR40UQTFQeZo=;
        b=WXOaVGn9JPXuzTpaj06cmR24qnrEmuSkoSXYnTLiIL+lD7c0xfs16kMCDVZuH/DEiV
         xqbX6iRvxM7V3u25gLXQwAsOpIGqOfSIyfh7dXSlO1aHsMTo4bhE9BTBFgM8qOqqkSs/
         kuyem9ByakVA4b9DUhc1RMWiRu3WBX4CZ8pg58QiA8z4RMn+WvjlhURbSxQut8mANUsV
         Wh58EQ5SgPg0EbLhIPQtkY2RrxH0HPAMSe3WePgYpls/TnkM/ZzBwWKnbMxdbuMTdxu7
         EJmK0rgGphXasWgdWtXjluFoe1m1FyDthfTOQoEGKX0I5bcQV2QxbT+jjVPa7qXny0MM
         8Anw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778717764; x=1779322564; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGX5uN02axDPiLieAjNAx0PveomaAqdXlNmPT0r0nPg=;
        b=SM2On/XeEhT8DBVuC3p2rCxjAPTlgRVSZeS20YcbLRLKcQ1POZBNd5x2eOvXkf9NXF
         SpZH9xs9ijStTcm0k3Bmu7wrQjTAmeILeGa5lKk+Dx2lA6/wEv83Znur+jfGDU4hQEAL
         qf4qgNaZXvUoN6ESXU8oz6KkrPQRQFOcx3oEAEIqMRKN4Xr5Ycr1IZVHas9fjc6tAISj
         9yfdgtYSyG9hCpD7OJaFmlkIELtlWZYtmaVc4aiEapybBBCiYDw9GDrOT65qRCdFUMOo
         6E9jLKGxqvxEb+tfPefFjlNBvQGpmEYY9CGXgjyHSm8QAA5kJFgR3uqlaD9ZQGGnCP0p
         qtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778717764; x=1779322564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RGX5uN02axDPiLieAjNAx0PveomaAqdXlNmPT0r0nPg=;
        b=nYOyfDj+ywPlBJmtvkT9vkxq3M6zT4G6D35DiZcUVw7f+8/MWdyMmngvr9PUUCQD8Y
         EOSprNJKlfQdkFTF+WruTkFOrffehZ0NB8qKDRdo/b9Vv2Lv0x2aR78xNCSU62+qrV0t
         JupK5HBMqSD3DkC/IeCURijS2oqbYG2ThhnXxxUE0KcQ0uWdmB5nFv0Ys91pvgGepq5w
         Hsi2xp+Y4bhmFiSGjJj2EZ2OpT+BYrDIHj9zJ4+PjqdG+2fiS4QAZ4CE8lvjWf+vRGLj
         WN4ZOAhBHtj3yBgYNEyzbr80KRuEoCo/0XjwkL9Il3Fw+Dg1X/PJ2evbJi0iaT6pw91s
         gpFA==
X-Forwarded-Encrypted: i=1; AFNElJ+f2neUSVEoS3zotINX8P+IeP9ciIFTLOkZDaD2HjfdigUJQgJMd5m0lrYDfLGBiXs7feh2Oivqog==@kvack.org
X-Gm-Message-State: AOJu0Yym/gp73rNI988Cr4fHgB/B389EZyKsH9MDVvAjvz50BLmzcwbR
	eiJRmPFdvMPKAsXP4ueXN/3hqacwJizflu/QrzoQg3BvpZSVrr3+d5SFsCOcsA3G+ZiwkWbZLRW
	Q2iedUZMZfC/t8axhl1XvUFGi6aX5xFyIkLep4evD
X-Gm-Gg: Acq92OEhGVu80g5TdMzETs0z9+NeF9XJdw+dLQWhzp6p5T4wZMy4Kh4bS+nMVp0sKus
	ZZ1WG+cT8QIMiis29pWIKhDsIkB/gssg0T6r+v3opUW7OlN0xkTwiac4L6XPRF9pAL9JsErCENZ
	52ESrqnS8qZ8wR/HCsVBTEbofX3leScC7YgoJVGtRD3971MnNB6blqMhcO7wxvMjaDAPpBF5rAU
	K9vPnUUcTYbJ0eXwXNcuVuXy0uQm+YZ0N3aATqTynqJabNpPbUrIUfBJBIqBaySBEifd7xxxNhK
	2Y7tyKXafEBOQufu
X-Received: by 2002:a05:622a:8d0a:b0:50e:5c9d:49c7 with SMTP id
 d75a77b69052e-51644c1cb5bmr3693831cf.7.1778717763334; Wed, 13 May 2026
 17:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181957.7511C256@davehans-spike.ostc.intel.com> <af4V7pP4qdIsB0yA@lucifer>
In-Reply-To: <af4V7pP4qdIsB0yA@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 17:15:51 -0700
X-Gm-Features: AVHnY4Ke5VY3VR-_x2DrM2LG8HmJgb3l87QebpE-oKD_SUYtppfmWFHWcFfWxaw
Message-ID: <CAJuCfpFHuX0Yzf_aahWrSJG+V4r5b+GYTACrGoV5voMRgXO6ug@mail.gmail.com>
Subject: Re: [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: EA55FC0005
X-Rspamd-Server: rspam04
X-Stat-Signature: d4eyycophwigdc1qxz56uht7zs56zzcj
X-HE-Tag: 1778717764-411167
X-HE-Meta: U2FsdGVkX1/t737sUBD0mO/ghDKdSWAb1gua+RRfNOK4lkv9VQ/+jtLzDVzRvw/XmLDURQXdddk/vMVNZ0w0gTNN51tA1gGaEKtOMLk5xQwTDX1atG8kB9RzAZqGGG7rIl8S6J/gopZFbTGI9BMJ4CAH3BB8+RiCvZibvhtRJuDaneuPqfWSziZH0vkoN47vNJeLoX4z1eQq5NgI0xElW0KnxQC9WWMgTCRG+QyMenawMWtu6Cabrvy8W9q4B5tVps0me+UN1z+VTcBvH7i0ApNnbpR1Kr4oXOEFuLg0Af8qsZWfnIGpJzRONi6he0KckwBB80CmSf04UdbwsL7DhKJyc9QxgeI+te6BY0c2CJU4sJjWUhrEUt6oKbGYNp9sVUPTdmWNUjBkTMS3hBq+fGot2PWc2ikPpfG//p39FTnJBKHSduwquabLMLWvXESn6tn5Tl94ne931H2ZrT9ykkk0zzG/UcJfzci9gAxJ7HXzzAcGO6hVrTXepc4Wouernu8Jm8wme7UP9e1EbQStWM/tQgD9eVxbcBgLx5S7edr7xHEKK0+VfaPkayqzeiLIdAUzfbs1EC6onP9BnFF2MKeS7/3d2Xi2sMTk60rp0iRJOBZQKZWYdJXR5xAA3E0Yi2wdarvP4q8dDYFmyglcJG06Ar0j5F/3q8iTf11gPuW8a98zccTBc4TjtV7ldKQi/dzfmp4Bv9wBv53gtrifj2MmH1AC7Y/2tOfu+qsen1qCFV1x29SNcrxHN5PW9uHqikbUvmMpew9orbTTWOW7VMLnqV0cOAod8fehn7XVehXGR8YNDy26yUPcfkfhJYCKUWS48uac3rO2vVVPCUNOQc4s+Pm68mVOjGjzWBB4bY+IEA4blVLlVMd0aCIWQmaAUrAuJs3vTl4Aa7xKLWiqjjxSpErR2dUhy/8fA5UKe+WwIZ8Zv746Z0LEvU/9GLwmeAYydj7ZmBr2BmxcYBU
 f1ZXTXF0
 uo/AMmxF8Lcna0seYlAEEE6x9e/9ILnsOtmGT/HuMyfS86x3HBKm2noPKkogyfWHqWH9e0pX+XD0adGmwXq+fLxjJ+MTJ/Swhhpqt/FNDuCbuzdxEL6C65EQ8QyYCZIQ2JWs/JcG0m+8pT4x5I+yIq5kmNFQBSkkTJICqll7Ef9vHg7hSmX/wOaVaB0lgWZjccY5x7vQMZUZwrdIU8f8kPgfj7YWNXmrFFurfw+KTMKBhU7UTM8GUzW8K/bsmddhgCJ590f8xaiToYsx8tmL4ncjg48+Yd0a5lU1uLLGzIwEnvsFJ7YfHo8qL1ZzvjPwOhDgEZxBQuWC0kzKRLMJGeD9b8XndD4MT0nqyNRO4rHHvaVdNzdv4kBiA0Pfs01UKRomKatDduuT5YUIual5UlZoqcF4XZxEb9jwM52taHgS15ioPGTCldIe/XJV+FkGpFdGo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 10:07=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 29, 2026 at 11:19:57AM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > it and mmap_read_trylock().
> >
> > Long Version:
> >
> > =3D=3D Background =3D=3D
> >
> > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > support for the per-VMA lock, but but left mmap_read_trylock() as a

s/but but/but

> > fallback.
> >
> > This was presumably because the per-VMA locking can fail for several
> > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > to mmap_read_trylock().

The fallback in most cases (I think in all cases except binder) is
mmap_read_lock()/mmap_read_lock_killable() so that we can sleep and
wait until the lock becomes available. Even get_mmap_lock_carefully()
at the end does mmap_read_lock_killable() if mmap_lock is contended.

The fallback in the binder is trylock because they don't want to block
global reclaim inside their shrinker. At least that's my
understanding.
CC'ing Carlos Llamas to chime in if we are incorrect here. An Ack from
a binder expert would be nice too.

> >
> > =3D=3D Problem =3D=3D
> >
> > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > essentially already a non-blocking trylock. The main reason it fails
> > is also the reason mmap_read_trylock() fails: something is holding
> > mmap_write_lock().
> >
> > The only remedy for a collision with mmap_write_lock() is to wait,
> > which this code can not do. So the "fallback" after
> > lock_vma_under_rcu() failure is not really a fallback: it is really
> > likely to just be retrying in vain. That retry in an of itself isn't
> > horrible. But it adds complexity.

Yep, makes sense. There is that sequence counter overflow case that
might cause lock_vma_under_rcu() to fail but that's a really rare
case, not worth considering.

> >
> > =3D=3D Solution =3D=3D
> >
> > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > will not persistently fail. Rely on it alone and simplify the code.
> >
> > Full disclosure: I originally tried to do this with
> > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > trylock semantics. Claude caught this in a review and suggested the
> > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > I guess.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>
> I mean this seems reasonable to me, I don't really understand why we'd fa=
ll back
> to mmap... try lock :)
>
> If semantically you're trylocking then as you say, lock_vma_under_rcu() a=
lready
> does that.
>
> Honestly I feel this could be submitted separate from the series.
>
> I'm not a binder guy, but this looks right to me so:
>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org> with nit below addressed.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > ---
> >
> >  b/drivers/android/binder_alloc.c |   22 +++++-----------------
> >  1 file changed, 5 insertions(+), 17 deletions(-)
> >
> > diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/an=
droid/binder_alloc.c
> > --- a/drivers/android/binder_alloc.c~binder-try-vma-lock      2026-04-2=
9 11:18:50.066607065 -0700
> > +++ b/drivers/android/binder_alloc.c  2026-04-29 11:18:50.069607180 -07=
00
> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
> >       struct vm_area_struct *vma;
> >       struct page *page_to_free;
> >       unsigned long page_addr;
> > -     int mm_locked =3D 0;
>
> Man why are we using int instead of a bool in 2026 in the first place :P
>
> >       size_t index;
> >
> >       if (!mmget_not_zero(mm))
> > @@ -1151,15 +1150,10 @@ enum lru_status binder_alloc_free_page(s
> >       index =3D mdata->page_index;
> >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> >
> > -     /* attempt per-vma lock first */
> > +     /* attempt per-vma lock */
> >       vma =3D lock_vma_under_rcu(mm, page_addr);
> > -     if (!vma) {
> > -             /* fall back to mmap_lock */
> > -             if (!mmap_read_trylock(mm))
> > -                     goto err_mmap_read_lock_failed;
> > -             mm_locked =3D 1;
> > -             vma =3D vma_lookup(mm, page_addr);
> > -     }
> > +     if (!vma)
> > +             goto err_mmap_read_lock_failed;
>
> Nit, but we probably want to rename that to err_vma_lock_failed or someth=
ing!
>
> >
> >       if (!mutex_trylock(&alloc->mutex))
> >               goto err_get_alloc_mutex_failed;
> > @@ -1191,10 +1185,7 @@ enum lru_status binder_alloc_free_page(s
> >       }
> >
> >       mutex_unlock(&alloc->mutex);
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > -             vma_end_read(vma);
> > +     vma_end_read(vma);
> >       mmput_async(mm);
> >       binder_free_page(page_to_free);
> >
> > @@ -1203,10 +1194,7 @@ enum lru_status binder_alloc_free_page(s
> >  err_invalid_vma:
> >       mutex_unlock(&alloc->mutex);
> >  err_get_alloc_mutex_failed:
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > -             vma_end_read(vma);
> > +     vma_end_read(vma);
> >  err_mmap_read_lock_failed:
> >       mmput_async(mm);
> >  err_mmget:
> > _


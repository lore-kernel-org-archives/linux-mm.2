Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD220C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 15:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCDE6B009A; Mon, 28 Jul 2025 11:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D41B6B009B; Mon, 28 Jul 2025 11:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4111C6B009C; Mon, 28 Jul 2025 11:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32A486B009A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:26:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE080586F5
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:26:15 +0000 (UTC)
X-FDA: 83714049510.08.2952490
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C8BF40006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:26:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jBPuZWAR;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753716373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqOC4wRRGhe0Mg49hUc2tJcMbQEAuNNfAJDotAhUq+A=;
	b=TOabZe97qb/4zdLHlW2g31NvIRAYj0DCJy36RSYNCU6oV0Ynci4effQrn898r5rld+5kJQ
	nERequccU3wQvlK0QtbCJjE/egf0Vx7BmHH0jG3XrE4hb0gAeFltF5+olsnWJf/c2rK13D
	Youk16NSB6VUDIxu+7g67evcCaqZnek=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jBPuZWAR;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753716373; a=rsa-sha256;
	cv=none;
	b=eNFE8WXqJmKyJPpMLUbHPFb2txpUQoy29G/4nD/YPK5sbB++3YkbezrAmTwuNjMaIWT42N
	5T/0N9aI06a5MvOFRwbNRacCwuUTAKxl4nu/vBSCfkgX2AR86c2Rbesnl4I3KSXKvc2bez
	2VVzvWlDpewM4XpekzjVfcNWR+cyZ9w=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6154c7b3ee7so9683a12.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753716372; x=1754321172; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqOC4wRRGhe0Mg49hUc2tJcMbQEAuNNfAJDotAhUq+A=;
        b=jBPuZWARm2rnrC9z6HHkAXc9mUPNh0xWfZRNZy85ixptEnFvJqZSMEdInBTxBsRGpy
         8UDlUFmb1XhYwtkTPWqJs8ar5G11R2uSKg2wzfi7LPj8JH0w/rzgBSds7SPQRSbkkZxV
         If3v1+vWZgdqoTKYdGMDGDVA6vopodGKYi9ofdbQBE28RwqMJNW3UISmFTDVnm2aedXK
         gqobs2hWqCNjcIEh5/69TM7jFhOzF8eDwU0L+kuzul3JByfYdpVssA8X6vNTgYXYGTtp
         YA3SX7FWFWJeF6KYgUev4hWBRbSau3vXTqV//jRfxk5FSzfe5W39ZJ6RV1RetZBxT6ah
         rFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716372; x=1754321172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZqOC4wRRGhe0Mg49hUc2tJcMbQEAuNNfAJDotAhUq+A=;
        b=qPd/thrAX8vkcS4YaLiknfXLeT3ffjjedjEEdLRyIFAEpr57/RZaO5w4jKUslyNjFq
         lfrumpyOju3G3e+brq46CePwWDm4r0ZamJ81AqpS0XS27n+DWMbVb1zCl/uTwPaHKTKi
         YUvSD6gKboofXJNPR+Yk1TNB7CiB3BXRz1IqpPhxqfo8JJOQrpQdvyXvB1o9nR0lIGmR
         XT9Hjf2jMaTBA4VqII1M3ut9beh6tyApi9pHNwrPNwv2a89r7MsJr/tHVJIsTNCPrZ02
         inUXqF76o/17b9oQsLctArJIZ+Ls5QKnIgdX17hfrIqZDrxDFP0t7G5ImyZv18VpUGnB
         G53Q==
X-Forwarded-Encrypted: i=1; AJvYcCXoSAupRNdppWdmV/0+VdXg5EIDL6V6Jr1I3UVz3PmuSkHkRqndGXQSOZntbgEoPk2swkPgGy9J1Q==@kvack.org
X-Gm-Message-State: AOJu0YwFDVjYhYFG66GiZco/F9Kyz7gTOK8l9PZ53oHSCON0ItxzS14C
	wwSSaQ5CGpSbCBzBe2QrtE1JPItK5O4Okp09gARwGzcMwLkkI9FEXjhqQDEmlkGl6/YieSnRGM9
	DtFZGnMO9p/s5d7ep/Fflgcnu+4wgCiJ2PuCtvRrv
X-Gm-Gg: ASbGnctKln6s9XeeCu5JVErJ6278FX3dqeYrDhja9GLMB8Rmg8yd+igLiWFmdJzVad8
	y32/+qdesCBAPG1ADpAtGbvP30wNxjoVIrLf1VMj5NTI2KGW59tF1VneCHpaQYDjdqlAOZ5fnX1
	s//0LakOKi/XAlA9F0LjxgL7ZOYc77+4l4WZcheFcpm3jxysqEBPSkLdX9G/ceErzETb+5y1lHN
	JBEsA3AvMfk36Bgf/1nvbFSPDEvwPvltpU+JjgQKDa6
X-Google-Smtp-Source: AGHT+IFCoTgiMkG4zyb1dN1lLjGmK+W5Z95dZzG2OqP6BB8BASV/3pO2SP7BdCCxF+tbZ9PLcM55cUpWngS2TlYW05k=
X-Received: by 2002:a05:6402:1a39:b0:615:2899:a4e5 with SMTP id
 4fb4d7f45d1cf-6152899a78emr101033a12.5.1753716371615; Mon, 28 Jul 2025
 08:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com> <CA+fCnZcyh52CqY+XDMMjc6f5KQoaji=7KiFM-6+2NidjfyNVGQ@mail.gmail.com>
In-Reply-To: <CA+fCnZcyh52CqY+XDMMjc6f5KQoaji=7KiFM-6+2NidjfyNVGQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jul 2025 17:25:35 +0200
X-Gm-Features: Ac12FXzgMg6AU9sijci9qK5lKdc5wEfC84NjWQbqd2yCO609j_hdZiglhUudTRA
Message-ID: <CAG48ez3Z+7pBPTShMrxZObkShCR9rE0euE76i9ciQNKy5bhyPw@mail.gmail.com>
Subject: Re: [PATCH] kasan: skip quarantine if object is still accessible
 under RCU
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p576t51u9rgo3bcck5khcnk3ayw5fjeb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C8BF40006
X-Rspam-User: 
X-HE-Tag: 1753716373-882093
X-HE-Meta: U2FsdGVkX19cxQ5IEYVeehDzlUVhzxKgI3RpDJAIINVkKmvX/ZBq5KtRpsVZq8b2fIxYm5U88J7THNantqES7SrsHFKkElL2IXlDgIQEFwP7t3yjUU1tnb/vC5Q5C15Pstokax7NKXW4Go67TFywnCqEMur+xCUTXyG0PEXHKLMtdc4+w3jUCnLcgpu2oxV6h5jD8xg+RyaN9NZqEmoNVDyT8hS4me/JuT/pQUlmvtSlSm+O/OnAaul04B5sb73h52uTnwEhtUAFPVxLVnc99KaRYguTYUd3PSSQ9whyGGC7/6adbSy5UAsnbPGmYY7iDfmxHje67H0isyXQa26WGXb24Ykxjv6TkdLNVr6hmsobG/p5DG8yz5gu8XYRm5GyCWfEgjHOFQJiaaQwirsvHYztEjWRB/qO5AFizzCEPsNA5j8PIDNH1zxfOPGqAmjfYkO3UPOtesE5/F+VwFB70oeF5/97ScTmkR/veHcf2GwvEeHFvhXrMirSC1mWlClYHURsCfkdZ5He1M84RgIPkm0Wxh3flO6mLLTEujeWaVv/Ch2ryojaCKduIDMiUFzIHSFr4YG6bk9B1H1FY7hN6TiYZB4b6m2gem0T3fKJOCBjh4EnuWSVtGJSlD2ElAqa5ueT+4BTDZS9kCbzeaZpaEc0YOfdnKSY+nooXNnw0FB1uMW/hREPuJZrhJTE9rUHC8vkVMA6JHdbYQvwnoC128ZROyhLEshDOGxkSs057ft/oeWEBm0kfyx6xI5R/S0c61T0aLsp2OBvoR0Nf1SUQmNK8mo4bbc4abIO+P6yV1pSP0IGqSTa7zrfTUNF6GENBdhvnwBIXGTUCgL2p06aDJM4EShev26Lf8biJQ3xPSMQINtM2NcwiHB84CS6teLzaiaVdTTwRStFcw/jJP0WoV/twSKcKsassLAe16djopJUnsbmN+ZrF/kYzCVVpwjA25OiMk6sB5yEY8JwhTt
 n5djUpdz
 lVZUEFewb9O6wgaPZLe6Awf8kblJxa2qG/LqRKDO3EFat5SnvmGU0W/0QpTguOR2wn7zQ+fZcTUop46M4PYQU9TRyo/yjPDtPTROE+7f7AqJ8nzvC1FeQMKkNoiO+m7xKJbPJ2o5lK1aX5n/r2yl258Rvn5Np7WDJKg+SL5DMpBB8OHUmkxX7wqxbj7v57uPGF4xs78ju93s5JDGZCSx1nXA0U9KRUSfkxmlm/cjEhjQhpSZCdTi3Smd2688SYk1VOBqNbYC749c3oeTZaWbySfZ5pGh5SCMeolgyUIKx19Fg3/zD3u/VbO76AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 27, 2025 at 12:06=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail=
.com> wrote:
> On Wed, Jul 23, 2025 at 4:59=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> >
> > Currently, enabling KASAN masks bugs where a lockless lookup path gets =
a
> > pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
> > recycled and is insufficiently careful about handling recycled objects:
> > KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarant=
ine
> > queues, even when it can't actually detect UAF in these objects, and th=
e
> > quarantine prevents fast recycling.
> >
> > When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
> > CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
> > after an RCU grace period and put them on the quarantine, while disabli=
ng
> > CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediatel=
y;
> > but that hasn't actually been working.
> >
> > I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
> > could only trigger this bug in a KASAN build by disabling
> > CONFIG_SLUB_RCU_DEBUG and applying this patch.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  mm/kasan/common.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> > index ed4873e18c75..9142964ab9c9 100644
> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -230,16 +230,12 @@ static bool check_slab_allocation(struct kmem_cac=
he *cache, void *object,
> >  }
> >
> >  static inline void poison_slab_object(struct kmem_cache *cache, void *=
object,
> > -                                     bool init, bool still_accessible)
> > +                                     bool init)
> >  {
> >         void *tagged_object =3D object;
> >
> >         object =3D kasan_reset_tag(object);
> >
> > -       /* RCU slabs could be legally used after free within the RCU pe=
riod. */
> > -       if (unlikely(still_accessible))
> > -               return;
> > -
> >         kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE=
_SIZE),
> >                         KASAN_SLAB_FREE, init);
> >
> > @@ -261,7 +257,22 @@ bool __kasan_slab_free(struct kmem_cache *cache, v=
oid *object, bool init,
> >         if (!kasan_arch_is_ready() || is_kfence_address(object))
> >                 return false;
> >
> > -       poison_slab_object(cache, object, init, still_accessible);
> > +       /*
> > +        * If this point is reached with an object that must still be
> > +        * accessible under RCU, we can't poison it; in that case, also=
 skip the
> > +        * quarantine. This should mostly only happen when CONFIG_SLUB_=
RCU_DEBUG
> > +        * has been disabled manually.
> > +        *
> > +        * Putting the object on the quarantine wouldn't help catch UAF=
s (since
> > +        * we can't poison it here), and it would mask bugs caused by
> > +        * SLAB_TYPESAFE_BY_RCU users not being careful enough about ob=
ject
> > +        * reuse; so overall, putting the object into the quarantine he=
re would
> > +        * be counterproductive.
> > +        */
> > +       if (still_accessible)
> > +               return false;
> > +
> > +       poison_slab_object(cache, object, init);
> >
> >         /*
> >          * If the object is put into quarantine, do not let slab put th=
e object
> > @@ -519,7 +530,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsig=
ned long ip)
> >         if (check_slab_allocation(slab->slab_cache, ptr, ip))
> >                 return false;
> >
> > -       poison_slab_object(slab->slab_cache, ptr, false, false);
> > +       poison_slab_object(slab->slab_cache, ptr, false);
> >         return true;
> >  }
> >
> >
> > ---
> > base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> > change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24
> >
> > --
> > Jann Horn <jannh@google.com>
> >
>
> Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks!

> Would it be hard to add KUnit test to check that KASAN detects such issue=
s?

Sent a separate patch with a kunit test.


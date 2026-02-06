Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C97EE6B46
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51586B0005; Fri,  6 Feb 2026 14:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E327E6B0088; Fri,  6 Feb 2026 14:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ECB6B0089; Fri,  6 Feb 2026 14:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C00496B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:22:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FD6C1402D0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:22:42 +0000 (UTC)
X-FDA: 84415003764.20.981346E
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 528E81C000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:22:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RCfgHL+H;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770405760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVQEzZOvJW8IWNIKc4lAQu2NPZWH1JrDJrUAOeUPtKI=;
	b=Jv/PT4lXJKYfxQPvNyPh2ILNrWT2CwdC0+V/vcdEHpDUtZejI30QBQmQlaTJ6edf/ortk2
	Dzm+FDMEdxkrIeCXDqvMDKcBqrlkD3+fZZrg5eas4Ixa0FP13hV/kZEtgLXsdJA5N0Rbxc
	GgysGzFuSQ2uXQyNHcw77R7mbvIS3oY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RCfgHL+H;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770405760; a=rsa-sha256;
	cv=pass;
	b=CkdWEPB/fJqKWkmfkmncELESV9abNtA8bvuq3QMEc6AejAkYRiLbKdjcr7DFH8SEcP1glq
	kknjuxid70XTHGY2AzgNIW73mOoJsQnc2NKHZJAOgcFxFrSjDinJrjbyA8j3eBoKq7NmoK
	kbcBG3t25ynkd3KrUs/Bb3rhI6zD/bc=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4359a16a400so2387362f8f.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:22:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770405759; cv=none;
        d=google.com; s=arc-20240605;
        b=HeWU4MLNLJfAhq5H9Qpyz8b2q5/aHom2cKAG3TUyhjaOxmV+nyfzqLYexoJ3u0mhll
         S84weOKRHMBYgAsgBhdthy+UsJ13p9Mb+b5MxfkI8wf5wtU8MxUmANthoHpmUWIDK9m3
         rM5Z4HrSt1oY1N38vAi5mJjw9NrqxXImL3hYNsIMOE9N0etaYi2WNDuPwf/7puCSrAvG
         eiR/NRd4i//dXADo1WPL3qP2O894xlkIeEqAiFPWDVGtZZleO5xn+WntwTZZ0+NXT9zR
         d0sSDaow/7grvgZ6iCdH6B6inaFLHbJlyMxUL/zOngY4meaKkzw75svByEzJMvrxe578
         nWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DVQEzZOvJW8IWNIKc4lAQu2NPZWH1JrDJrUAOeUPtKI=;
        fh=ZqTNxN851jB1S5DLVE8wshOeoyHNEjvS65KtMMFyjxQ=;
        b=Je6WJkSWzSUwHE7mwWN2vSJiNa9lqxSp33SeapIlvIzVduDY/uRTDl+tklFLp7mcNN
         PKMNX+QXJ2X8M1b7TNrpM/FB1w8Se+8ixia0lJq2M2c/IBuYTo218ROjoIGeteLOc7Xh
         J+Cvixr2cki905eYKw4bJX12MzqZo11BKIeILBbBHRjSQmkX/AEs90XrFF+qE8F1TEQa
         bJ7Tn/dNVtCeWaFPmDXMzfC4ohHv7hqoLY+Z8RE7HF2wB7k/tqkv5IhKonOuhp81FaZW
         XBdQjA/qPd52E2hfnmOqYwNghmD47aYBkR6KpFISCAxEZ/dnkqxh2yrtaT0sHyJXJ2v+
         g12w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770405759; x=1771010559; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVQEzZOvJW8IWNIKc4lAQu2NPZWH1JrDJrUAOeUPtKI=;
        b=RCfgHL+HtZmcqce72+wzXEK9SMRoHuE2EazeOFHYqh9scNIuwyEH3H650thCCkxyCv
         jeoMqm68gz5Rp9eS/i49qo80gLfR/PXub6PX662bkV8crz4AfLALpQFUyEwLLOiHNErD
         r8CArrt5RN26G0vgZHN+mzRBl0ZyejsZ1AatBqZavw8b2IqOyEsX8oh5Lyszi/msiaTx
         VJtz2NyFwfQ+vK5950zWftCz7DoUuUyb13O1UbxXX0UOXY96MbrDlkRTljXw5qjCGsAq
         BKBpk9nlfxwSPdqo2/RUm+iYOpCKXj3O5fg4W9jYTHiaQz9Imb/YBPmhbd3NoNaa61jp
         Pewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405759; x=1771010559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DVQEzZOvJW8IWNIKc4lAQu2NPZWH1JrDJrUAOeUPtKI=;
        b=MlkoOSzBF0qijzTaOja0V4YwDWtdiwp5xcfKRHrwpHhQhOfsell2zwEw0/BiShEgUl
         h4kPlXbFCSM5lyvKBpobrUugP29Mx6OeqAKC7f6Li+FkV6NJU8gyQ/lyVPtownH8+5B7
         RBljs5lZ2AHMLDCfKkPy0mlMBg5FxIGwqMf4XQAEPG4egwIYLBmmfuPnysyJddoWVFgf
         JHqTH5gJriBCtdkdigRecOjSRly04VZCvPa7TmUe+cJf78z23dFHHkWJCO5rtl4MVqjA
         432D+S9BaN85PmxLbwvm5k2oDfHNQCpj1kiMcllSw4ilNf1D/+vpsxQhWQuPTTHOMtjc
         KFwg==
X-Forwarded-Encrypted: i=1; AJvYcCV0ciJYD2MM5aR1950UUBuZx//8I34wpyqVddTkZOxvPI+GAJ2dz1tlxZPbAqEEcIJ6ytxh0DrdQw==@kvack.org
X-Gm-Message-State: AOJu0Yzl3UNF2SX0a9MFrFMN5c68EaW/BC39c8MD5Zkf+ph51ir74io7
	LaW8able6P803zxzxrn/j7zqrpwQk9K8m8upYb/+LRdTBxsV10CJJoloxdZ9V10SBemA9f/jfif
	342sZerGNu+kMdQFrJseFmaoG7jy4Pmk=
X-Gm-Gg: AZuq6aJhbDsKPit5A9EyqfV2u4cAZXXY0AFzY90r2nFlX6FMTs6DoQERaAaBdfWGDH7
	bvy1O/yZJSSNEvcN2n6iyn7baaj6QCi1yy1vu023bvqyEqV0Nx9JdyGgN+LXMJA1Kta2OJ8rDgM
	OoPyyp6/FmsXoEuGGkmXjWoHat6frqJPb3yzgIQlTB5aFJdu4MDj67TXMrN2x9rjyl1xuFN7QdL
	+UlYb1CrV+VUJ6k3nqL3nPWjEt06B9GXO2eCEoMIzAKaDs2ifk5upAuYDCkX5x6wAuQ5BavAnxv
	Bjjq7PduCLhtRiCa8xDDWh2AMrhpTnRuPO/tQnUdFPRHVuQSpltw0aXio8BrbVWyL7oBs2qwgx+
	To8VhU/yKe9KQwvwcWKh372sy
X-Received: by 2002:a5d:64e8:0:b0:433:24c7:880e with SMTP id
 ffacd0b85a97d-43629381b2fmr6575786f8f.33.1770405758760; Fri, 06 Feb 2026
 11:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20260206171348.35886-1-harry.yoo@oracle.com> <20260206171348.35886-3-harry.yoo@oracle.com>
 <52b408e8-ea29-439d-8e34-91c4cae8009a@suse.cz>
In-Reply-To: <52b408e8-ea29-439d-8e34-91c4cae8009a@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 6 Feb 2026 11:22:27 -0800
X-Gm-Features: AZwV_Qifsb8IS2VAAUQs5Z8p8kS9_HvBgFrXDAMC02FNOV2mNhMV5eiqvrN4GNY
Message-ID: <CAADnVQJ5AKmt+fNkAVRLPT5qAgfCGquBNRhg4v=U9FrH9cU+OA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/slab: use prandom if !allow_spin
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 528E81C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: s5wp3mixjx4r8aknk8opq9rsmo8khkuj
X-HE-Tag: 1770405760-921231
X-HE-Meta: U2FsdGVkX1/xY+T+yKKCGYGmu/HlOZQaewC9tOrs0JDseLdfUsnXWzbc7jxCAq0MarwmlNCik54WXBsA52UABize7PYQvnJZCXOekeayq9U6dJQtbuUoAKWYRv247NshldwH2AMsdCf8BAdszuDb6gVRSPsPo7bDDQWF6KdjPgiNubAWF9hEGs4S3GselCU67dXXuKuQ3aBv0RIIhT2zozbJ17W9J6hqkA4eF/rHb8W+rs4HYxJFu5w/6xwKQXzTyz/hqnEHZMH90bqwDEPCAN3o97LslS8fPMgZbo+6lXbxD9UJms1j591PQGUtwVsvZ/ivTWKcfHKSQFe0m0Uud8PWVjXofIMpU8EqX2MXAw2C23pf/P4q6ZgXPLfl8WPzszCQJTIdGzFDFWMqVh49HzC6LdpS5JvZEdFUG941lfqZ5cidNo6O5ZRWlZoV6Pq7qSTEqu68OfBcfZP6k2E7Vqvey8okpsk80zmuUBJ0IOA0dX+6lWvHPm0WQ4agJL1KFU9XONxGCYmYUjBvHhLhPjenchemiSvbrlCaLvFg3RvKWbwOXz20G0RFGeqYGU4yQdWpGhDQFK5Oav2L385awve1r5j9e2l9vb7MQ+7p3Ocyufci7QHd6oQ470HsfQwHY8kJHaX3/Q0KQS0y9WVYk+V2sOQGt8r5iyuiJ9mqeQLJN8QlwPDNFZNaNFM9XBm69foe79ackS3F+wJpuj5Bt7Do0DngYErRr42rtcucvgpuxnna0SpmerJ6adW6zeVf+6cg2vSj6Z/oU3XMVpCvaJzYvVo65q3ARAhE7dnzLS7oz/mqZpaqSBBTD2jojbr6Wz4+LCEnAtQsFiDd5Dd7M+RnnCoNQpOrHNYWOY0VwqChCGTvzsLozujf5u2MZboDTAV7bUqhDiOVmObxOgV15NzzTQ2if/MVkMfXAzTE9heSL+LecQi31INOqSOEQxn/bq8Mk/m+YVTyEcomliI
 nH8gpy9T
 YiCaDvO3StLrJEy0FgFxumhzS0h/1iIOYSAjVAK7HWwnkRY+/9c3Sw7MbzyF7b2rbbQSzdxpgtMDCRWX+vfqSLpUpAl7PkQWDWWASSXOVGN9ILczfKT2kP5iCKA/QlDdYHoTFmA8yLhHeGn3LKo9+/oWQoNhRnzdnKfwxupCKcB0dkqOG/TRYkZRkbqKj8g1C89d9AKFNwhfAmezBtuchyegWKvlKR1wn3j4QWy1JyEV6Cy6cD/cHiJZ35p3BcSzMhUZy0aV0UQ9CjScvYctB51SLk1ijVdjSZ5cXb2JBavrhVqOMGlIzm0d3ZpNuii4SnNB8ckqF9FE1G3oQXfqPEGeLh8qttdbJCYYJSxLCLWb2b5V0AbGeKtKVDtUMBvCQfUpN7qS6oQqSzT0BLvYcEogppH+Y3zp06a7q2KYq57HCXcnPX6NLHypcTtJLaD6yIKohWf/dUjFTjKKagcWalt1dLDGFlBk1VG1YTFIGFvq7ppI6fyICS33f29tyf6EleTTPTl59IS708vN8C0uvs1o668jKzDG3AnBgjPwSkW83Dw8ICnBAbvNO+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 10:27=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 2/6/26 18:13, Harry Yoo wrote:
> > When CONFIG_SLAB_FREELIST_RANDOM is enabled and get_random_u32()
> > is called in an NMI context, lockdep complains because it acquires
> > a local_lock:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >   WARNING: inconsistent lock state
> >   6.19.0-rc5-slab-for-next+ #325 Tainted: G                 N
> >   --------------------------------
> >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
> >   kunit_try_catch/8312 [HC2[2]:SC0[0]:HE0:SE1] takes:
> >   ffff88a02ec49cc0 (batched_entropy_u32.lock){-.-.}-{3:3}, at: get_rand=
om_u32+0x7f/0x2e0
> >   {INITIAL USE} state was registered at:
> >     lock_acquire+0xd9/0x2f0
> >     get_random_u32+0x93/0x2e0
> >     __get_random_u32_below+0x17/0x70
> >     cache_random_seq_create+0x121/0x1c0
> >     init_cache_random_seq+0x5d/0x110
> >     do_kmem_cache_create+0x1e0/0xa30
> >     __kmem_cache_create_args+0x4ec/0x830
> >     create_kmalloc_caches+0xe6/0x130
> >     kmem_cache_init+0x1b1/0x660
> >     mm_core_init+0x1d8/0x4b0
> >     start_kernel+0x620/0xcd0
> >     x86_64_start_reservations+0x18/0x30
> >     x86_64_start_kernel+0xf3/0x140
> >     common_startup_64+0x13e/0x148
> >   irq event stamp: 76
> >   hardirqs last  enabled at (75): [<ffffffff8298b77a>] exc_nmi+0x11a/0x=
240
> >   hardirqs last disabled at (76): [<ffffffff8298b991>] sysvec_irq_work+=
0x11/0x110
> >   softirqs last  enabled at (0): [<ffffffff813b2dda>] copy_process+0xc7=
a/0x2350
> >   softirqs last disabled at (0): [<0000000000000000>] 0x0
> >
> >   other info that might help us debug this:
> >    Possible unsafe locking scenario:
> >
> >          CPU0
> >          ----
> >     lock(batched_entropy_u32.lock);
> >     <Interrupt>
> >       lock(batched_entropy_u32.lock);
> >
> >    *** DEADLOCK ***
> >
> > Fix this by using pseudo-random number generator if !allow_spin.
> > This means kmalloc_nolock() users won't get truly random numbers,
> > but there is not much we can do about it.
> >
> > Note that an NMI handler might interrupt prandom_u32_state() and
> > change the random state, but that's safe.
> >
> > Link: https://lore.kernel.org/all/0c33bdee-6de8-4d9f-92ca-4f72c1b6fb9f@=
suse.cz
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/slub.c | 28 ++++++++++++++++++++++++----
> >  1 file changed, 24 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index d46464654c15..4d76af84f018 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -43,6 +43,7 @@
> >  #include <linux/prefetch.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/random.h>
> > +#include <linux/prandom.h>
> >  #include <kunit/test.h>
> >  #include <kunit/test-bug.h>
> >  #include <linux/sort.h>
> > @@ -3308,8 +3309,11 @@ static void *next_freelist_entry(struct kmem_cac=
he *s,
> >       return (char *)start + idx;
> >  }
> >
> > +static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> > +
> >  /* Shuffle the single linked freelist based on a random pre-computed s=
equence */
> > -static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
> > +static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> > +                          bool allow_spin)
> >  {
> >       void *start;
> >       void *cur;
> > @@ -3320,7 +3324,19 @@ static bool shuffle_freelist(struct kmem_cache *=
s, struct slab *slab)
> >               return false;
> >
> >       freelist_count =3D oo_objects(s->oo);
> > -     pos =3D get_random_u32_below(freelist_count);
> > +     if (allow_spin) {
> > +             pos =3D get_random_u32_below(freelist_count);
> > +     } else {
> > +             struct rnd_state *state;
> > +
> > +             /*
> > +              * kmalloc_nolock() called in an NMI context might interr=
upt
> > +              * and change the state in the middle.
> > +              */
> > +             state =3D &get_cpu_var(slab_rnd_state);
> > +             pos =3D prandom_u32_state(state) % freelist_count;
> > +             put_cpu_var(slab_rnd_state);
>
> I don't think this prevents the changing in the middle? We just stored th=
e
> pointer in a local variable state, but the prandom call will still access
> the percpu variable through that?
>
> So we might need to disable irq here, and have another percpu state that'=
s
> used when in_nmi()?

imo this is all overkill.
Just prandom_u32_state() without any protection is fine.
Even if it reenters there is no harm. Just more randomness.


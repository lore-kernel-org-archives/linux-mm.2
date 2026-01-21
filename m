Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEE8C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8336B0005; Wed, 21 Jan 2026 11:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854CA6B0088; Wed, 21 Jan 2026 11:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DA66B0089; Wed, 21 Jan 2026 11:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBA76B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:13:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA775160782
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:13:08 +0000 (UTC)
X-FDA: 84356465256.16.E9BCDF0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00EFB140015
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:13:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zh0opYTT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769011987; a=rsa-sha256;
	cv=pass;
	b=XvZq5ZxEKe87WsZUxX4s4a3is3Ds7wyrd+mNskIDrjc2gk9NnDh8HhpWEjBCCyb1up1GGw
	AS9TcA0tdDUHjCZYP+XkpanO3xT4qvS9FQqwFdH/YDU1dc8T2pKtYgTssz1S6aete5/Pma
	21/2iBy2zN5GBGUzXUmxV91+GPgfu4k=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zh0opYTT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769011987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1GwHpmSY+Ssuo+YrlkBnP/wYaSl4q4+E3mKjKXYR/c=;
	b=WPpBPOgVfGTqw4JduOEEHmJnexDrP1U4gZKt/5m5J8QCBH9w6O8qxWG6vbDhoox5ZuA1Sm
	sxei/KY5NF/g5E9/R75S27VXEqtlnCACA1POf/KywVpafxGiIeoCpK9JGgAVezC0wxlocO
	Ciko3rnKH+XcO2p/ElDngZKJVzQlIug=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5014acad6f2so88751cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:13:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769011986; cv=none;
        d=google.com; s=arc-20240605;
        b=e29dXgs5IwzDHULFHLK8ZfZTEgspYYn0xzpgwGZKwUBfbN4OwQp9XPcfiu8AfjyL4k
         4B7v7y7CCVnG9tvs1cVLIW26FU4XoxrYtwBW22Feqg9f5u98hatbq3Tx6Piv7krFmI5v
         g/IGhy4lJjmisYrW2q833k0bKezRMxcCBzzehrkTgRb77lmkTk5FdYViTZevOjpSzdeG
         lUWy5wY+t62dEzDVkASkFXn4VQ0DYX8FISrRD1y3pF9vxH0k83qLG9ahkIMxymkm9oU2
         ppd3QxQUEfWNamAQXkV6pMisGevcY9J3ECJq8IsiBbsuT/9MazCiqxwMqjGPdpZtGzrk
         iOWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y1GwHpmSY+Ssuo+YrlkBnP/wYaSl4q4+E3mKjKXYR/c=;
        fh=JtGrlMGzc+cG1WNo758wdSJwx0W/sCEYsqQHki6XQhE=;
        b=Yz6IsPCmGe23uACrueVL3s3tXcUMEOwOP9er0E2yBG6IkdXv4oDPV9a2ECIeIccUQV
         Il0rw6EQ6tKjYEI5zdUWs31afMqcvNI2j1o9yMZk5qZQA5/wnm2Zvfn5C7poaLlTcWTv
         mtYoAtZhQtFe3z8vWDCSEiBv42A1kEo5+N5Agie6icQIFgOMSWsLrnfoQo09LVXorNso
         Hab8m5V2VwRDu8ndiXQBNn/SJA/GEMyECQGYIFRG4wss1LD5aV2rVD/m0gMovCBdoiTo
         FV/Z0Voeu23LgSUvv2w8/Q3aLVljIu8UUKjxJ2XJawjp0bdlPpeYq99sKZvOQ7WZkOeb
         Bj4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769011986; x=1769616786; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1GwHpmSY+Ssuo+YrlkBnP/wYaSl4q4+E3mKjKXYR/c=;
        b=zh0opYTTaU1yjLyBLGGeJNY3OJGacEekKjHac4VBOlCWCDPir+UPtSt0TxqBr6sXXR
         h+AFYoZDTfzbzEuo9KSTJ0svkplUYBDoMNvI2IkgbjpROm9oo2ySdqe9w9zYh0Ge4Qvk
         BahxO5dy8OcGb76CfQjEpqQogLgCD92YquHBJmi6ruVTdpsh+IYXCQV0aBMOZ4265X2w
         5cCMlmwDcbSxcXDkZyURn3txWIjVK4cqmURPxT1gBcvqfBGaxdRvCgapTGMvjStD8fU5
         i26sZupXLAg4o2icnyQDPQrt+R0psjDTzj5eZ8TO3ZYE3BqRV1zAjmgGckuvypyqE7xG
         mN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769011986; x=1769616786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y1GwHpmSY+Ssuo+YrlkBnP/wYaSl4q4+E3mKjKXYR/c=;
        b=eXOBaS4f/3yDPiU1tjHgKgfLZggQOAhD5nkedujPfE5tl9T+iALEJS97DWTUyE+BpY
         c5LA97+5N6GxsPbcCYkUBh135XzrvCU562Q5sBSh2InznSh3t2htRNr9kb0xYunEfuE8
         YNg+RNNxNT+pRMD2MuMzovrXHa8hOjUbbo8fXw6sLVJPAa148wT0qoaHMwAlVWmrdAi7
         CHhX9tmzWs2fhP8SwBav0b6c8It6iZxwR5O3/U8U+Kxs304a6dmGVmUX0ZQZm8uxhmVL
         4MK7IgwUaIblsbQO49ZGIxZoasIUe+vE4KXj2woKk2ImMBK93idaSzhNPTw0AwPzlJOP
         S0Ig==
X-Forwarded-Encrypted: i=1; AJvYcCXNiQ60n7lMxqvkdn4cJNfGHQuImIiKZrAlqqCtJOj+9zCH5dj3BbdfcLz1PyDdEQGUhKzGKfU4QQ==@kvack.org
X-Gm-Message-State: AOJu0YzqDli6xrYTlphfsVXCyH+0dsXdMe0s0mz8mvnnKrApj+wdT/zV
	xbkoUPQck3C3FvwwENItXTFybwowtjYSXBUbWKVf0zCLKm1lupZiLu5kYMx+8WNDA5/kErCuZjl
	qqaI7mmzsvKJx2GiMv5+X2ZG2+NaKUZlZuHTrzxzW
X-Gm-Gg: AZuq6aIHpPLojnPb2XjcD76Jr9LUa/ocGNba/l+yG5Zb8G+zca35fBkgKGsuOaVFmj9
	qM7p0pNltCGB7ZnioJTRvfk95xcZpjAuRmDN+x8e2pTdQw/wcyJFkJbdNsPatS8NqlhgcP9x8Qo
	Z9hOESPIAcIx8UBv/JyVj3Ctxkb+GuRgbSox941HsqcV/vIibjEVXrOcUsSglVdf6H3lekyoyNc
	tNLiqV/6D55vyIUBAlrvz4Gi8CuC/RtPLxfunpsTKcmZ2tVfDZUNnjMYJEv/x1qZY0HMYcwkx7u
	3kwO/UHb1swddY5GoyChiyn4A3XlG8b3TA==
X-Received: by 2002:a05:622a:1888:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-502e1a18978mr11594511cf.1.1769011985614; Wed, 21 Jan 2026
 08:13:05 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz> <CAJuCfpErRjMi2aCCThHiS1F_LvaXjkVQvX9kJjqrpw8YnXoNBA@mail.gmail.com>
 <fec4ed92-32e1-4618-99d6-0eac77da1ff3@suse.cz>
In-Reply-To: <fec4ed92-32e1-4618-99d6-0eac77da1ff3@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 16:12:54 +0000
X-Gm-Features: AZwV_QiSjzEmuwsWdtzV6KlI2OJ4fFRrfgPi7_dAQ80cVBUvpM4Z4I7qS0kyx9I
Message-ID: <CAJuCfpFzZnbZBX84xTTtTHmKebVxWXUXjFe5AQRTGnu-9AnRLA@mail.gmail.com>
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial list
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uhi5ors1tcuy3jnb1setyibyfjo17zqs
X-Rspam-User: 
X-Rspamd-Queue-Id: 00EFB140015
X-Rspamd-Server: rspam11
X-HE-Tag: 1769011986-931566
X-HE-Meta: U2FsdGVkX19zSdTB5m3xi2Gf7ZEfRMeLTmXBbvSE94CVe8/YJIR09KXHiD1k1appqq830w7gkHEhW315iAYpZKTIwGzE6NzM2mikz3Ln3c0DFKIFmobD1vX0iirAiZA5i6mCaUDQ0p8GF9a+JkHvlwwFJihN4YafRVVtGfcf/rEeDKAKG5n+K3FudoUKgbhd3HaVjhfYsXt0V92OkTHoP+Lo2BFaduaSw1eu3wxAKmujQ+oEcwJATQzas/MQ5IjFb53paA3kEw4v0mj267fBOE+Aj/2JEzOKu6dM0o/qtQLhrR5pT5qnqKDjRDPRFbpnK9QRO2bVYxXadlvdoDdpBYvItLdiEAhBlrXdFriyOLgNX8iuZn3MpGPWFxD0bly7hmWyge3LOm+IhJtEh1MwMQSDpTj5mFErjvMfoFgXSMV6kJiPMgLpkEbqIwBLzLPYSFGss/uVPO0bEwUZ0Z/mAxutslXFJL73eEu8EuWriip25C/oMCerebBBPxJSu94mCVC4AuXLeC37YNn4xiDRdXaZce7OQ4nlIShKQaFpNO5oyNxemqRHw4iFrEG4AxKXohdCqhAqqlZr8CElddTKbEuaCu6FxdDj40LYTjBMuga6/hvBOMyKnmbYjVtkkJ84GCYR/vNG+m1kssBKAfd5M9lW3PRQ29r7bdmF61LeKSyysX1MIwXlM9qNLb0T5AA1ELTklJYhzXn8A3cY4Kb8zmqk6/G6QSnvTZBJzmwgHdktHZ7pEU2aT1r3C1PnJKPuVMl3wOjOPpYyTiuMWpeuNjsCu7z3d3IzLOejYjysgcsbCSEfcscioMVL7zQ7nUfjjMF2WtvB1ZxMBbWX1ImtcIrXESVt+0Ny6zluRzLqcSDUmb9YNYzH5yKI+HaG5LHn6XgSChqONC9MqJWEVYqxJc751OJJFK4LoTKjYNItZ6h9hXp+R4lHaDZBCbCVTD9ixWjTO2qeXWMgVGALFel
 34Cue3Dq
 sQwu1DW4kNJT861uBv4uWBJc8KukXGgjLn1BZMziaxRdQanOSPFeatsoTMGNBwkKBXZ8YDsWqa+cVklo+jmGrff1sOHKVcK2wPxtdlTPUEl1NFH6IX82kO6BJ9zMnFeefpYhb1fH8kzq3ZYrr8nMeMIyi/zsMQbx84+Xjhn39yJ4NqE1hyC6aEQc6zsb/0M6S1bbuvj4+PJUbjD2J5JcAo/HR7k47DlHvqXg1E58yzUWqVvoMf5BnA98g+Aj33dK44gmgDUy5tR7VMwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 1:22=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/20/26 18:19, Suren Baghdasaryan wrote:
> > On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> At this point we have sheaves enabled for all caches, but their refill
> >> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> >> slabs - now a redundant caching layer that we are about to remove.
> >>
> >> The refill will thus be done from slabs on the node partial list.
> >> Introduce new functions that can do that in an optimized way as it's
> >> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> >>
> >> Extend struct partial_context so it can return a list of slabs from th=
e
> >> partial list with the sum of free objects in them within the requested
> >> min and max.
> >>
> >> Introduce get_partial_node_bulk() that removes the slabs from freelist
> >> and returns them in the list.
> >>
> >> Introduce get_freelist_nofreeze() which grabs the freelist without
> >> freezing the slab.
> >>
> >> Introduce alloc_from_new_slab() which can allocate multiple objects fr=
om
> >> a newly allocated slab where we don't need to synchronize with freeing=
.
> >> In some aspects it's similar to alloc_single_from_new_slab() but assum=
es
> >> the cache is a non-debug one so it can avoid some actions.
> >>
> >> Introduce __refill_objects() that uses the functions above to fill an
> >> array of objects. It has to handle the possibility that the slabs will
> >> contain more objects that were requested, due to concurrent freeing of
> >> objects to those slabs. When no more slabs on partial lists are
> >> available, it will allocate new slabs. It is intended to be only used
> >> in context where spinning is allowed, so add a WARN_ON_ONCE check ther=
e.
> >>
> >> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> >> only refilled from contexts that allow spinning, or even blocking.
> >>
> >
> > Some nits, but otherwise LGTM.
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks.
>
> >
> > From the above code it seems like you are trying to get at least
> > pc->min_objects and as close as possible to the pc->max_objects
> > without exceeding it (with a possibility that we will exceed both
> > min_objects and max_objects in one step). Is that indeed the intent?
> > Because otherwise could could simplify these conditions to stop once
> > you crossed pc->min_objects.
>
> Yeah see my reply to Harry, it's for future tuning.

Ok.

>
> >> +       if (slab->freelist) {
> >
> > nit: It's a bit subtle that the checks for slab->freelist here and the
> > earlier one for ((slab->objects - slab->inuse) > count) are
> > effectively equivalent. That's because this is a new slab and objects
> > can't be freed into it concurrently. I would feel better if both
> > checks were explicitly the same, like having "bool extra_objs =3D
> > (slab->objects - slab->inuse) > count;" and use it for both checks.
> > But this is minor, so feel free to ignore.
>
> OK, doing this for your and Hao Li's comment:

Sounds good. Thanks!

>
> diff --git a/mm/slub.c b/mm/slub.c
> index d6fde1d60ae9..015bdef11eb6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4505,7 +4505,7 @@ static inline void *get_freelist(struct kmem_cache =
*s, struct slab *slab)
>   * Assumes the slab is isolated from node partial list and not frozen.
>   *
>   * Assumes this is performed only for caches without debugging so we
> - * don't need to worry about adding the slab to the full list
> + * don't need to worry about adding the slab to the full list.
>   */
>  static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct s=
lab *slab)
>  {
> @@ -4569,10 +4569,17 @@ static unsigned int alloc_from_new_slab(struct km=
em_cache *s, struct slab *slab,
>  {
>         unsigned int allocated =3D 0;
>         struct kmem_cache_node *n;
> +       bool needs_add_partial;
>         unsigned long flags;
>         void *object;
>
> -       if (!allow_spin && (slab->objects - slab->inuse) > count) {
> +       /*
> +        * Are we going to put the slab on the partial list?
> +        * Note slab->inuse is 0 on a new slab.
> +        */
> +       needs_add_partial =3D (slab->objects > count);
> +
> +       if (!allow_spin && needs_add_partial) {
>
>                 n =3D get_node(s, slab_nid(slab));
>
> @@ -4594,7 +4601,7 @@ static unsigned int alloc_from_new_slab(struct kmem=
_cache *s, struct slab *slab,
>         }
>         slab->freelist =3D object;
>
> -       if (slab->freelist) {
> +       if (needs_add_partial) {
>
>                 if (allow_spin) {
>                         n =3D get_node(s, slab_nid(slab));
>


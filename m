Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5EBC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 00:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60F56B0092; Wed, 21 Jan 2026 19:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E1E6B0093; Wed, 21 Jan 2026 19:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919F96B0095; Wed, 21 Jan 2026 19:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DED16B0092
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:58:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27D3B13C9A8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:58:51 +0000 (UTC)
X-FDA: 84357790062.05.DF1E3DC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33FD420004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:58:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNLTmVpd;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769043529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLIh79S7FhXMOMoT5i8cYC6nflwvZaP3UE034p5mOJs=;
	b=HnmVDwtsbeSSacHyhCTp3DfpEkSwjDFZgME8DAU3HpzN46vXOYN1EKx8YA/qtw66ekAIVb
	NupLJV/j/U1vPMIMIapDg7GzxXZ45/lpP2zs6iMlSt5jYPudqmHyRLSCYXSqqSE2VnWhm1
	dvtSwitZ/Lvl0rPvtM0wj/uABcP5UJE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNLTmVpd;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769043529; a=rsa-sha256;
	cv=pass;
	b=CADuIP4OswyMqoZWzoIQRcHxEsKROLcrJbTLHMWFV3doX0slQIaSJrT9vdD/vNeA0MKcMN
	KhVdzpmMN7Qz15u/XvU1H/wxWP7of9g2VG8sMDplQApOMIE2x7wKz3qdaX/74+S/ZipMYr
	k56FbwKPVoZ5GFgtMB15ZxkIzFU4xS4=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014b5d8551so102401cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769043528; cv=none;
        d=google.com; s=arc-20240605;
        b=DUuoikLIEFt0+rtR+ywGTHoTN0rysVX5xOapvV0+CkbdjVG1nZLyttjlhI7vInInpO
         KN5H8Nkk/T4DGEQbg24AUI3VuNvZpbkwwYwThnWafT3dcyS9fCily1H806fQjQlV5/8p
         zoRN6z5wDtkVay5q1TY3IPbX20Fgc2HntfGrjSfLIdKnxsRC8NrNVJd6yv+9C8ZEJFYG
         Od/5NvURF+aNj8g8U6VKatcjWO8ePF3lVVxFoL4HA/6FaAHzgHzH6G+1cen0w3QoWnpM
         4qv7S7HfJgK7W7TJH7/VrC4qAZ+dSH5cPKxcwpZTrzsieNy8PxfOYnW/XvLWb+QoU1yJ
         l8+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VLIh79S7FhXMOMoT5i8cYC6nflwvZaP3UE034p5mOJs=;
        fh=84H0qdT0ZfSMmzQ8mC0nWG9HSqlaNueJngvgEqXZpJ0=;
        b=f+apmZe3EoZ3kaJXryPpQ3GZs5nd1+WeWfC1qkox6tAQQDEpoC73oYRGoZdML7QDxT
         Y515woTXSw25EEc0gQbIeJr3chlLmOsPg081z03H+hncdhxUJCYJS8XEaZ9bftqPVioz
         J3Qos5buv8IOZnFweJGji2lEfUtur/wAjcmsBEb4zQ1ZvwuUDPUQZvoTr0HXoStzjJIW
         Xxuhf2ndh92tzWLLbaJqZNbmZq8wI+DX3+pijmBdiQN5kDV34f79pNz6htRsLrd8+akF
         +HLgMZumUgXe1m0H5nKbLvNwUvJXC5+Ce6dMwEjR2Xk+ZsEEzGsjvKszFBYzHEv3iUdb
         szhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769043528; x=1769648328; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLIh79S7FhXMOMoT5i8cYC6nflwvZaP3UE034p5mOJs=;
        b=BNLTmVpdowL3kV0CQuVczWE7B30F8pchnnxcOPBeQ9LTlERWp0KWRRMDuM5c1CP6FV
         lcevRJ6BUTPg9U7XBG/j9hEilKBL9ll0PbVHm+KOhlZOUf33cW1gBy5/Dj3c4LjG4DbA
         kz6RuqPvHe8fJ00OTtYPwRTbG6tGVMOZEMSG1wXWn83hAKyLex9QmZNADaKgMpJIlKeb
         LgiugyvyQ/RqLDYjjlXgfazMktsPCeoW1PiypTMQpx+EF0kg0GW/lqarskgA0zmtQYuN
         nhT1UHl+f4MpmKA41eS+qTr2ulJGIqAC9dUjhTsB+VuQ5xV9t3cDAM5tIMcUu6v6mvrz
         gjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769043528; x=1769648328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VLIh79S7FhXMOMoT5i8cYC6nflwvZaP3UE034p5mOJs=;
        b=nGJDggJB0+kMqAmiKvmQllvFG1Tl951anbmeRtO4JyLqtCR/sIy+kqOh477hZEsXA0
         cBai1XGnc/iSPEZocb7I11UkXxdhI0w0MEfHS0iMwbv2QYD4eE1fVwdZGBFFTBQ0xEwY
         Yhkq8qL1DE3JDWIVZcLVzClpMJRIj6RdCiIIYk/EwhEuJSx8n83XMjdcm7TnojyM04OP
         d94KbRUjF3ySN+Hy9+FmZJwX2ayl9XHHysUBWpSgw0u3i3qW01ytQfGGl6Y/d1aOUiIq
         McxdXgkN9UtYWzKwfY9h+enqwjVGRzT4VGFy0K4/7v8mHxkw3F9awZM50lnVqW877EH7
         UcJA==
X-Forwarded-Encrypted: i=1; AJvYcCXSdYFE5lpuLbdJTt9CqCSJ8UeMl065o4P5WfoquJPO+hsGUSUyDg/b3FQKIQVy5jmsFNSrRuisfg==@kvack.org
X-Gm-Message-State: AOJu0YweXDdFDmonohkyERdX6tiVBD9fJWtf8WfM9tSkfw14empCOTzz
	eZj9kWnzR+dncY4l8WxnLAkWdZRPFbpmQfZtf3t4GZN0sFhAQIff/TwNuKplD4hHErkiWvwUGJo
	Zzj+KjGMBYqnJ+K5pafxdms7VtjqGrFsl2hE+U0pF
X-Gm-Gg: AZuq6aILixWKKhmMhu8wsX/OvnskXknBx0KuN3/e0+ChFno9DbEJrI+X2pP393g1Z46
	DeWwrojyXPq+C9lFNdFbP5BvWTZCFS8ztbTZWIrjmdVT60esLCUVgzb0LlzYx8nHjbEEQWhtsNz
	+9Y8Tf1byxTEnAX2i0j1nMcs2F/JoM7hIwXhlscLZWt2asqEr1WvgLHDQEVlq0OxBBpe81BHz4d
	au3b0Sf2vTwATsRgqhNZwGZiGub9gZtujR7wZ73qgh2tYGxL2gZRc9QO4D+ZTLhhn0wRWGxPNsW
	507+CpmcRnMYSY4yiClc1jo=
X-Received: by 2002:a05:622a:15cb:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-502ece4dbc5mr3059331cf.17.1769043527916; Wed, 21 Jan 2026
 16:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-20-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-20-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 00:58:36 +0000
X-Gm-Features: AZwV_Qgalo5BT2cF8nB5P98paznJER_XoJhiYL5n6D0vsto2yVGgbP9TwAgaUBk
Message-ID: <CAJuCfpF8xYb2j57HzO_-cfaTrOd-+jyv8pr4uFV1KwaSxKvghg@mail.gmail.com>
Subject: Re: [PATCH v3 20/21] mm/slub: remove DEACTIVATE_TO_* stat items
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33FD420004
X-Stat-Signature: q9nhan35ebygbbr8y1gygtzw17fz7ei1
X-Rspam-User: 
X-HE-Tag: 1769043529-81421
X-HE-Meta: U2FsdGVkX19tJnSbdFwqYxFH6l8Qp8pBy0xRZ8Pbqznuh+cLW+4LKB3DZVO5x4AwTGk36onIKi67Bt3U3j+AaS02fl17TJJdjFa0zhv51xW9b5fU5Pe2Jzb2X1acOtHc85LMwShg2cAvNQCu4hW7Yr9FsfA2fbxeM3aT5tOpGAOBidSEZIkyvJKUQADOAwCiUz4PJtDD05LkYSecoKM7FThMYC0I4txEJmP67Fepfyayb0qw6e4aVWoPze0lxaTCPlbz06ll7DcBMMiPKsS7G3tSVapBG0dm8WHgNr/d2gPaoIlG9EA+WFlGz1gELV+k5a4469uplyhh/GYMt06ja014UozqZNrVbioanaOLeQIz1r6y+yMAQ7HIL8AQvdEqLgiPlXZb2P3T7zS1roTEv9kzBBr2m3toCvySDrZ9h3brGOcPIS0Ryx9vtHkC+G4mBjzXjkfHKAV3Kajye7frRIXhdDG2WRERJ713+yUyAfgxBOhmZIaeU3Krx8QHJRBzvNr+JE9/wYyepQIQTsMIfsdzQJv1ZXdMqCyAaM2YlwmP85/ZgnZi1yzKCwfbZ2Ovv9APj+eyqubcDXf4ajVBAy7cNRKie3zypi5cRfGxItq8gLIBSODBaixZJZ8ymMT0pO8UHhN37jWE30BJYwar4GgtAfvhO33Gh9Lb754bDOjeZ/L2UqyR81gs4xXl+oNbpiGEjyWle4Ivvhq8dddX61/+ln4chTROcL9lFnHCmlko4QfSzsEP2UZAHj1m+52uB76kH3Za7NBmzSFuAIlhR4nirgZQFsS8AYwJVEi9ycjjSIdgXgQsoemrFatgfuCvlOmwkutItoLhdLhcOKi5RE0gdeznOP0o0JpGwvAk8vzLdNQxFy/vmAz4fgHWSTJs9lLWDtQS1Al0qosADLo5nK8Ko/hknELjIRPlK+7+AMO0eWtI/RQ1AhaAEYRzaQtJ4/pN0Nt+y4lE8SGEeje
 Sv3fUCmm
 LIta4dOGmrwOlaQk1IcjraTGCI/jnO1cXlK7vPEbnrYVBBNslF6lOkmcTYGAb2yrrI9gOeLeQ4oMuyOv4IjyX1/kNu7/MXxKhORf0lQfRMNhJbJZDOFII02X0epuK0P7i3mYfywtJuNqs1UXCGcFiNM5Of78xn9KFSBchB4siiFf6KT5mV7590f8DWvn7TQR02Zf0VZPJp0STOa0kramHsdmtmAwHvec/gCsTC5WIKTmx4Xwj7I1/ziUDDMvBfNVODXCs66mbzESZg9JonaktLDM1iKeEVwLRMUDbsnu5VdpaCk7w4I/PyRBlzVoFxzb1Kdygei5czMazLi+iKZJxItdC2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:41=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> The cpu slabs and their deactivations were removed, so remove the unused
> stat items. Weirdly enough the values were also used to control
> __add_partial() adding to head or tail of the list, so replace that with
> a new enum add_mode, which is cleaner.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Same question about UAPI breakage, but otherwise LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 7ec7049c0ca5..c12e90cb2fca 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -324,6 +324,11 @@ static void debugfs_slab_add(struct kmem_cache *);
>  static inline void debugfs_slab_add(struct kmem_cache *s) { }
>  #endif
>
> +enum add_mode {
> +       ADD_TO_HEAD,
> +       ADD_TO_TAIL,
> +};
> +
>  enum stat_item {
>         ALLOC_PCS,              /* Allocation from percpu sheaf */
>         ALLOC_FASTPATH,         /* Allocation from cpu slab */
> @@ -343,8 +348,6 @@ enum stat_item {
>         CPUSLAB_FLUSH,          /* Abandoning of the cpu slab */
>         DEACTIVATE_FULL,        /* Cpu slab was full when deactivated */
>         DEACTIVATE_EMPTY,       /* Cpu slab was empty when deactivated */
> -       DEACTIVATE_TO_HEAD,     /* Cpu slab was moved to the head of part=
ials */
> -       DEACTIVATE_TO_TAIL,     /* Cpu slab was moved to the tail of part=
ials */
>         DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects =
*/
>         DEACTIVATE_BYPASS,      /* Implicit deactivation */
>         ORDER_FALLBACK,         /* Number of times fallback was necessary=
 */
> @@ -3268,10 +3271,10 @@ static inline void slab_clear_node_partial(struct=
 slab *slab)
>   * Management of partially allocated slabs.
>   */
>  static inline void
> -__add_partial(struct kmem_cache_node *n, struct slab *slab, int tail)
> +__add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mod=
e mode)
>  {
>         n->nr_partial++;
> -       if (tail =3D=3D DEACTIVATE_TO_TAIL)
> +       if (mode =3D=3D ADD_TO_TAIL)
>                 list_add_tail(&slab->slab_list, &n->partial);
>         else
>                 list_add(&slab->slab_list, &n->partial);
> @@ -3279,10 +3282,10 @@ __add_partial(struct kmem_cache_node *n, struct s=
lab *slab, int tail)
>  }
>
>  static inline void add_partial(struct kmem_cache_node *n,
> -                               struct slab *slab, int tail)
> +                               struct slab *slab, enum add_mode mode)
>  {
>         lockdep_assert_held(&n->list_lock);
> -       __add_partial(n, slab, tail);
> +       __add_partial(n, slab, mode);
>  }
>
>  static inline void remove_partial(struct kmem_cache_node *n,
> @@ -3375,7 +3378,7 @@ static void *alloc_single_from_new_slab(struct kmem=
_cache *s, struct slab *slab,
>         if (slab->inuse =3D=3D slab->objects)
>                 add_full(s, n, slab);
>         else
> -               add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +               add_partial(n, slab, ADD_TO_HEAD);
>
>         inc_slabs_node(s, nid, slab->objects);
>         spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -3996,7 +3999,7 @@ static unsigned int alloc_from_new_slab(struct kmem=
_cache *s, struct slab *slab,
>                         n =3D get_node(s, slab_nid(slab));
>                         spin_lock_irqsave(&n->list_lock, flags);
>                 }
> -               add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +               add_partial(n, slab, ADD_TO_HEAD);
>                 spin_unlock_irqrestore(&n->list_lock, flags);
>         }
>
> @@ -5064,7 +5067,7 @@ static noinline void free_to_partial_list(
>                         /* was on full list */
>                         remove_full(s, n, slab);
>                         if (!slab_free) {
> -                               add_partial(n, slab, DEACTIVATE_TO_TAIL);
> +                               add_partial(n, slab, ADD_TO_TAIL);
>                                 stat(s, FREE_ADD_PARTIAL);
>                         }
>                 } else if (slab_free) {
> @@ -5184,7 +5187,7 @@ static void __slab_free(struct kmem_cache *s, struc=
t slab *slab,
>          * then add it.
>          */
>         if (unlikely(was_full)) {
> -               add_partial(n, slab, DEACTIVATE_TO_TAIL);
> +               add_partial(n, slab, ADD_TO_TAIL);
>                 stat(s, FREE_ADD_PARTIAL);
>         }
>         spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -6564,7 +6567,7 @@ __refill_objects_node(struct kmem_cache *s, void **=
p, gfp_t gfp, unsigned int mi
>                                 continue;
>
>                         list_del(&slab->slab_list);
> -                       add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +                       add_partial(n, slab, ADD_TO_HEAD);
>                 }
>
>                 spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -7031,7 +7034,7 @@ static void early_kmem_cache_node_alloc(int node)
>          * No locks need to be taken here as it has just been
>          * initialized and there is no concurrent access.
>          */
> -       __add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +       __add_partial(n, slab, ADD_TO_HEAD);
>  }
>
>  static void free_kmem_cache_nodes(struct kmem_cache *s)
> @@ -8719,8 +8722,6 @@ STAT_ATTR(FREE_SLAB, free_slab);
>  STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
>  STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
>  STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
> -STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
> -STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
>  STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
>  STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
>  STAT_ATTR(ORDER_FALLBACK, order_fallback);
> @@ -8823,8 +8824,6 @@ static struct attribute *slab_attrs[] =3D {
>         &cpuslab_flush_attr.attr,
>         &deactivate_full_attr.attr,
>         &deactivate_empty_attr.attr,
> -       &deactivate_to_head_attr.attr,
> -       &deactivate_to_tail_attr.attr,
>         &deactivate_remote_frees_attr.attr,
>         &deactivate_bypass_attr.attr,
>         &order_fallback_attr.attr,
>
> --
> 2.52.0
>


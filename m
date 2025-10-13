Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C9DCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C188E008E; Mon, 13 Oct 2025 17:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353A48E0031; Mon, 13 Oct 2025 17:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269318E008E; Mon, 13 Oct 2025 17:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 156598E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:53:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A283686F4C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:53:32 +0000 (UTC)
X-FDA: 83994443064.19.E262CC1
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1CE24000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:53:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f2yjo8c7;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eznQkcbVB5NzB/bIiJpDdx0jzlo0Dnq+XZ627uhHJTw=;
	b=taPY4PNa0vHPdLjPbbRDnNYUQrYQjFe4miLsdxIdnNrNZRcaXc63UDP6rDMZqm+0Mu3+5l
	K1VSUCr3nOCrJeHg+BEmvZE2d3CZW5eHka0W7Ry5gXy0EQVw0E7goDK3isWO6gXNr8UbLW
	CKkz9QjgcFlz89ZRv3UQoIIqM1DTVRU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f2yjo8c7;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392410; a=rsa-sha256;
	cv=none;
	b=PsUlSeWQOLsu84k9h191wmsbpJaU5Yob/D1GBLgjjDnnDhmaknVsFCPTlOXbc34zzQeyak
	u0ao5UPNVl20qnDr8Nq8dj5wsSFVnAPVosYmBzvipLXto+z6KS2XQyTax/WiSISpDdedcQ
	exksUQR+I/M/1SVkP2TUfvQuyedk2yY=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so43031785e9.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760392409; x=1760997209; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eznQkcbVB5NzB/bIiJpDdx0jzlo0Dnq+XZ627uhHJTw=;
        b=f2yjo8c7kck3m1PZxN9kMlRyK7kLu+NW9Bmi/KGXKthoqphAOHHV3WC2aKt3B0iD5h
         6nZUE7JZDwer460jkkKj7rWWJHhhdjwc2pkQSon4ZJAgRlO1mFWVD8PNsgHcOvknhKcv
         nO2bkMEyJnp6561Ia1akj93zAL63ftyltvaSLjZ3zytgm6TmmqAp24CeG0yljFTzG8U7
         IwiixMPTUF2aA76qrxAISt/yWqg4q14XxHE7iGPBpgUpVDKaM2fwqBthzOtRMoepKo/x
         mb9GPDmCdY5ZhBMO6JqNSzcr5AIv8oCuPYQSS6pv+qwZhZrZYLf5dQ04E2wt9/TYUebs
         aSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392409; x=1760997209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eznQkcbVB5NzB/bIiJpDdx0jzlo0Dnq+XZ627uhHJTw=;
        b=Zo89tM7HtOq+TXMXJnYLSVCedp59gWMk1usCYTdwCDdVfUvjyu2EYl1qMVUjZK9/0H
         eSyOpLHP7JVz0NjNQmJ+GYcjlQtIu7APe7iOD51XOQ8OYRO7AekiJtq+vlWnm1N16d5n
         ugUOX24x+i4DqnFZttJH0Nxn4N1eOPQKWwulgKofluBnFXgbH1ldC0xlnCuGLPB+hypW
         JZh/BDVrPsYis5siWe5Fiv0BB463wN1d6K/Twty7FGBTIOoWx7vj+ilBTbA8QT8ZRmtN
         3OskC2OeMmLMeuR45WLbCnogy0RwsP4tEOcSeSydXI1Xm+0T5JSU3qEEmN0fB4QiLo6g
         3REw==
X-Forwarded-Encrypted: i=1; AJvYcCXuO2TNp4UkmpJvCX6cjIC74cbHmuCV0nDVEWWcPlTi8dyPoLQfXaYivfMuPLHFACZbNIlakrNpmg==@kvack.org
X-Gm-Message-State: AOJu0Yyj0fcbQq3ip2rnH/P67nYFa1dd6QPnOhZVn6p2iHcX+p3fEtma
	syqw0mZpLB6bxChoFLRoxD3KjC76NKCpD820MybTJDr/k9pPInGuxkogWQCWFRtuaVsT+HTn3BG
	/HbyRA31RnnTnjXaMEQjYy79LV1XYQTo=
X-Gm-Gg: ASbGncvRnsMetUCvJfA0VSdRxaerUzVhsfGPV8ceNL26kb4qiI9tyzuNEjpZVSR5/AL
	4XzLjh1Dss0uiZXYu30rgalYv2h/Xa9bkaHPhTPSD5IgWWoDCF8D2QxCjdp4ChQYbyniDTckUZJ
	y/cEt13tmRThD6TvuKNPlM8vakGZftxOx7uFpVceH8d4GT5Zar0YKAxJwCTgMdiVDLJfrfm0nku
	jP5T+lKLLfYycZxrPiwmSMu1JytRu9MhCdn42lgI25WBasCNJpy6M+uqL8=
X-Google-Smtp-Source: AGHT+IHjZPYSx/MFnDGMSVq+/lL2r95iSzOO5aOtH3FWckuHrmP+/J89/qhEWOR5QTdySxp5tyYSKjZsZl0Qibs5c9g=
X-Received: by 2002:a05:6000:4283:b0:3e8:b4cb:c3dc with SMTP id
 ffacd0b85a97d-4266e7ce955mr15411285f8f.3.1760392409074; Mon, 13 Oct 2025
 14:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <dhmafwxu2jj4lu6acoqdhqh46k33sbsj5jvepcfzly4c7dn2t7@ln5dgubll4ac>
In-Reply-To: <dhmafwxu2jj4lu6acoqdhqh46k33sbsj5jvepcfzly4c7dn2t7@ln5dgubll4ac>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 13 Oct 2025 14:53:17 -0700
X-Gm-Features: AS18NWCpJ5cNadN1PuP9X6HpkCgMz2QoMAjad8BXEm_SW3mlUtmGRuLdphkG_3M
Message-ID: <CAADnVQKEhfFTSkn6f_PJr6xMcjB4d45E_+TsU6+945f2XD1SmA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>, 
	Network Development <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>, 
	Harry Yoo <harry.yoo@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1CE24000A
X-Stat-Signature: zksqab6oni1jhf9shudcht5uwahun9rq
X-Rspam-User: 
X-HE-Tag: 1760392410-728947
X-HE-Meta: U2FsdGVkX1/wtWUIzBbED+s5o1UE+rwNPp54DI3PS0OWU19PZaMQReOwY+aHu27XAT++1dtFXspEqmY8/7SoT/l43vxtIkKBzpzgcIg/OeHrMtFLgLLO8Fk8oonlMfr3Z1oKEcBSRfy8xVDE+KHPgzrxadxv+f4YXaGtCbUFeAR/4UzZuHigjuOTgO3VSrCODM2OqnOqIamIZdUeUpNFmd0UNGTOSP1exrTrYrVQBMuMsbmRKu2S+sHeHp5tOuU84v7AJb91cvl2WVPzddJAxYwHAzur8vWut33K5NncW/wKhlS1NJNXV1DjaA6U2mUT/nHxp62WWzF0xbySvbuaj5pZFVBKzG2EjnVhOFFJk9s7/ZjkEJt2jSqtfu7ub6vgrOd0hCqH5lym6xqioRH+RMHUO69IfoAlvSjWt1NoKA384WsCG+Lwk3N8AS4E/GRQRIrues2xdID283MIK/AEA8mO3RuUqfXwSO4rpvJB23Wh0pkXEyw1zn4yamH6DcQ7ABRe/9EPpXhe9sJGbMAHfebMz+uJmnSDUA7hEsafDPaKMpvs1dm9YIX00WgFYeWFCqyTXK/Br/V/q0SP/eOvIr8Pqw0flPyymAJs68TYEXKeapx1eAiKMHREEdU+hjqZuISv+OfagCRDHDSbeza9emVaPM9GVOu1yLYLEob9vMAVcqxjHFXQyoQZTzWP7O4WbLxg5VxXR6ItOA2f+HGpI9Yd/tIuIYcCN2Qz2fiDwmSfJP03WsqPP+OT0lup76yiVoByE0BZ3BUnLgt/0lIU3LL65qGxBMmkH5tNxlGTKxwNEjYgihXGWXx4DZfBcY/xASN6q+nt1anKrtnK8/8OjFKul/EP3X2yS8H+f2os+G4mqb/y6KnKFRYIyPXc22iPDpZgaxBQi092eiLdOnG7kWtrXS8Ykq6ZEFOuFRMZ+tJvuN/dLqicLMftkAhfy8Fgm1bA1m4E4hEP4fTQuBW
 R39s67cs
 0kGYjLJ+u7U5uBbNIi02j/b/3tivCR9gI+/JgJp7wV2a2IYWy912XCgsMmcbLwMoXRTehSYIz327o66Y0Z5IaAvcgble0ITHNqJ8b1ySMGy54quPWu6KqqGvcFr6qg77k3EDenDJZFk39L8ZYu7cHH8NFe1LKqg9P5iXconPEIgNeVcifQbhC60bdau5oyya2Lysq74tVFyWBrwssNaw1+ZU6I1eNhvMboSVJNm8unooGj9VxHK6cvSG70qFv0SAcdxD9uLuSv2y45IsOaz8DAygo4lSbEmIHeEcO+xfR3pDPqrs6N2E4lJOWK/gsudH0oRwaESKVgOiS9OOWGejJ/4E3qU1banmxCw4hU1lYj4qrUPAVL4SyfwGcFFS0v5PXDickr+Wd5o9var7gy3hf19UTsWiJ5tlwLlIeNVKiKGYNPnoVTwgFnUwn/fU5IWP0cYIjf56NOfL2fgiPPRzIktC1Ii+85EtBVB6Cr3kTZ5ePRmyST4e9XqYuC9M5c1c8cLWsXIotDT5YQeLMUxwOYZuhnkAZ4eL30v8dYd3J0A0VqzmJ4B9gtC+P4ZDzvFhkiIuMkeo1gyFuoBw5hAO7HNJvBwQVt+kvbEVJ/e4zSUvszQKR8Dy7HlOMsACa0RawpbENyIrLFcLYIX3SV+TZ2CMBkaAQBZXK9U7Sh6pVvu0Mpaau/OBzgfZPGGoJZvqIcMgphqOEWPrtPbboGCR4kArXHMMVNTbAPITiLRyZ+Ers6SsVtfiqaZmZlTMjuGYCZdfDw+RCpP1TEMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 2:35=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Oct 13, 2025 at 08:30:13PM +0200, Vlastimil Babka wrote:
> > On 10/13/25 12:16, Barry Song wrote:
> > > From: Barry Song <v-songbaohua@oppo.com>
> > >
> > > On phones, we have observed significant phone heating when running ap=
ps
> > > with high network bandwidth. This is caused by the network stack freq=
uently
> > > waking kswapd for order-3 allocations. As a result, memory reclamatio=
n becomes
> > > constantly active, even though plenty of memory is still available fo=
r network
> > > allocations which can fall back to order-0.
> > >
> > > Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static=
 key")
> > > introduced high_order_alloc_disable for the transmit (TX) path
> > > (skb_page_frag_refill()) to mitigate some memory reclamation issues,
> > > allowing the TX path to fall back to order-0 immediately, while leavi=
ng the
> > > receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
> > > generally unaware of the sysctl and cannot easily adjust it for speci=
fic use
> > > cases. Enabling high_order_alloc_disable also completely disables the
> > > benefit of order-3 allocations. Additionally, the sysctl does not app=
ly to the
> > > RX path.
> > >
> > > An alternative approach is to disable kswapd for these frequent
> > > allocations and provide best-effort order-3 service for both TX and R=
X paths,
> > > while removing the sysctl entirely.
> > >
> > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Kuniyuki Iwashima <kuniyu@google.com>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Simon Horman <horms@kernel.org>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Michal Hocko <mhocko@suse.com>
> > > Cc: Brendan Jackman <jackmanb@google.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Zi Yan <ziy@nvidia.com>
> > > Cc: Yunsheng Lin <linyunsheng@huawei.com>
> > > Cc: Huacai Zhou <zhouhuacai@oppo.com>
> > > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > > ---
> > >  Documentation/admin-guide/sysctl/net.rst | 12 ------------
> > >  include/net/sock.h                       |  1 -
> > >  mm/page_frag_cache.c                     |  2 +-
> > >  net/core/sock.c                          |  8 ++------
> > >  net/core/sysctl_net_core.c               |  7 -------
> > >  5 files changed, 3 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation=
/admin-guide/sysctl/net.rst
> > > index 2ef50828aff1..b903bbae239c 100644
> > > --- a/Documentation/admin-guide/sysctl/net.rst
> > > +++ b/Documentation/admin-guide/sysctl/net.rst
> > > @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on=
 a per-NAPI list. This
> > >  list is then passed to the stack when the number of segments reaches=
 the
> > >  gro_normal_batch limit.
> > >
> > > -high_order_alloc_disable
> > > -------------------------
> > > -
> > > -By default the allocator for page frags tries to use high order page=
s (order-3
> > > -on x86). While the default behavior gives good results in most cases=
, some users
> > > -might have hit a contention in page allocations/freeing. This was es=
pecially
> > > -true on older kernels (< 5.14) when high-order pages were not stored=
 on per-cpu
> > > -lists. This allows to opt-in for order-0 allocation instead but is n=
ow mostly of
> > > -historical importance.
> > > -
> > > -Default: 0
> > > -
> > >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> > >  ----------------------------------------------------------
> > >
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index 60bcb13f045c..62306c1095d5 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -3011,7 +3011,6 @@ extern __u32 sysctl_wmem_default;
> > >  extern __u32 sysctl_rmem_default;
> > >
> > >  #define SKB_FRAG_PAGE_ORDER        get_order(32768)
> > > -DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
> > >
> > >  static inline int sk_get_wmem0(const struct sock *sk, const struct p=
roto *proto)
> > >  {
> > > diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> > > index d2423f30577e..dd36114dd16f 100644
> > > --- a/mm/page_frag_cache.c
> > > +++ b/mm/page_frag_cache.c
> > > @@ -54,7 +54,7 @@ static struct page *__page_frag_cache_refill(struct=
 page_frag_cache *nc,
> > >     gfp_t gfp =3D gfp_mask;
> > >
> > >  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
> > > -   gfp_mask =3D (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
> > > +   gfp_mask =3D (gfp_mask & ~__GFP_RECLAIM) |  __GFP_COMP |
> > >                __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
> >
> > I'm a bit worried about proliferating "~__GFP_RECLAIM" allocations now =
that
> > we introduced alloc_pages_nolock() and kmalloc_nolock() where it's
> > interpreted as "cannot spin" - see gfpflags_allow_spinning(). Currently=
 it's
> > fine for the page allocator itself where we have a different entry poin=
t
> > that uses ALLOC_TRYLOCK, but it can affect nested allocations of all ki=
nds
> > of debugging and accounting metadata (page_owner, memcg, alloc tags for=
 slab
> > objects etc). kmalloc_nolock() relies on gfpflags_allow_spinning() full=
y
> >
> > I wonder if we should either:
> >
> > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > determine it precisely.
> >
> > 2) keep __GFP_KSWAPD_RECLAIM for allocations that remove it for purpose=
s of
> > not being disturbing (like proposed here), but that can in fact allow
> > spinning. Instead, decide to not wake up kswapd by those when other
> > information indicates it's an opportunistic allocation
> > (~__GFP_DIRECT_RECLAIM, _GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC,
> > order > 0...)
> >
> > 3) something better?
> >
>
> For the !allow_spin allocations, I think we should just add a new __GFP
> flag instead of adding more complexity to other allocators which may or
> may not want kswapd wakeup for many different reasons.

That's what I proposed long ago, but was convinced that the new flag
adds more complexity. Looks like we walked this road far enough and
the new flag will actually make things simpler.
Back then I proposed __GFP_TRYLOCK which is not a good name.
How about __GFP_NOLOCK ? or __GFP_NOSPIN ?


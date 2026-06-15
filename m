Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E5BCD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 01:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058C46B0005; Sun, 14 Jun 2026 21:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A376B008A; Sun, 14 Jun 2026 21:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BE46B008C; Sun, 14 Jun 2026 21:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8C376B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:41:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99E29140860
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:41:22 +0000 (UTC)
X-FDA: 84880444404.06.3C2D32A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96D0B10000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:41:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="STmr/q16";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781487680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oba1y/fwWge1CAjHu+ViThvQtCh/uetPo3IoC3QoR4s=;
	b=w9yrlfjJ2tgcfa6HHX/NnuAPBSMSkk+t/Su54HsxCFcMsscqseWvC2cDZLsFs95GKX/Bsi
	dZUrFw4BPIpPGKYQnj7CZuCm3WS/PARDwQ6G1rVR5jll+URWQX3Wo6piWAy0/9ORnusMIE
	Fy6vHlLL7l+LgUFNGRMMiz4goHcTFzk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="STmr/q16";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781487680;
	b=66AkxlB1GYlrcX1KQ+KOH43TlLqi5ZG8hw/IOMTWglh5ZD8LJsipveZUn0jzwQPN0lIV0I
	eG6H5WsVtLgqScQVezirH2lsIrUhZxyguaX4C9N5E3Gmsm4CtI1Gg551I3sZGoZXsbU6yA
	e4/oANxWCxJkhJmbXohTG35k4sQPhYM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51765331535so697651cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 18:41:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781487680; cv=none;
        d=google.com; s=arc-20240605;
        b=cuwMcKt8hf/jVlkKgYyFEaz/E2N+OVvGXv2bD5qSojwaHGxOglKkBJZjaDnGkuQXk9
         +mV7TCWy5GE3gpW+qIuSW1QVSsNN8/KxbhaWwjyCoUxn08oiNuYqmns9vOByml9l21VZ
         97L+Zgv4oY82lWb4F4xM2FegMnBpDs6fcn47tUWlxHczjIk/Pe2IXZAmS9mtMn2wXPTb
         YzHIN9p7e6LPxYJQFnghJYjhcuael9D+u19zd8OH/vev+afFsCsprBc2/rdhHWs2auAE
         sgdoPteqSgQmoaymDYvMS6ApS+I1plGWw26B5pesgsIc3H/RKWj8Y+gdmXZuhwa6kcKz
         czVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Oba1y/fwWge1CAjHu+ViThvQtCh/uetPo3IoC3QoR4s=;
        fh=i4koeRhxKTt+oRdQOu/c8YlN13rQSP/xFGBCeZTN9Z4=;
        b=OkvLSB7mLVX3qwTnix8Pi9C7gfXloglPAoWGh51e8jMSb20qm+cfI7b0PRe3kDGuvg
         Qk+rd39r7ommnqP2YF6K+QObTqMSCGCbaRXz5wX/TGiZyMM/bjAZ1qN/dC0C+Bcv2yXl
         a+EO7YFgPEZwbs6gMTw35Xwr/ydEY9lNFR3LJ7KL1q7NIlgHsijJ1W2B3xQKobuFO3Na
         p5bn7nsYRb5ZHcfLQrkzd4cWTG54XXBD3wQ69lY1mrS+5K4ra6zeM+rsEV0wzZarmfH4
         I0qF6r1KL26kWjtLtt8r1MNvcpIpc72+LDcMl2p5CWfIcyVzBu46E41ijHlD5GkMVPJY
         IWdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781487680; x=1782092480; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oba1y/fwWge1CAjHu+ViThvQtCh/uetPo3IoC3QoR4s=;
        b=STmr/q16ykljvckJk9ku3aeQF0kLGkNXHh8fvobp6N98qYLKOrKHQGHCyqxnVg8xdK
         v3jjFoL+KX2u6jWwRvjdGHZcbmwPtq8imSN6bhv1FNJLcXPaP2grvhaeJHIfBeV7WITk
         wNbmTUbDgCVkzlMPXoMefnV7LFXMwd0c7po9DhMN6LEiSA7b0nRmIq6fyiCyGY0sq974
         msMhZr/gBxR1R4FE6QofE02gn+rNzelungAleScjWuXPsT4spvDpsj1oZoMVV6KzGYxh
         7v0MbAk6sIkTgh/zJIzFw7af0youoHlla9ojsNJfZXjlFhfCxJ6uEXkux0TiY15Ht3qu
         H+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781487680; x=1782092480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Oba1y/fwWge1CAjHu+ViThvQtCh/uetPo3IoC3QoR4s=;
        b=fKH2a2DhzuNf+gs5l/hZ4sYgkkY6JdMLVg8qVaf4ZorNEhFN5Aul8iUW2xourm5bsH
         SrItsGbJ9JH/JDG08kVKpMyXo+5bWWlIQPbxWJw8/JUW6NSpKEjUqAz04EHRidbjiV8f
         J5c/T+PjZf5Ck+cFW3q8/83vI4Z3DIlM7fWWCPIL85bJVPqULlC4QlxsbuN7ZMDzQmPC
         4Jk2Rb+exdzJGqcTe48DDeqoCKCIg1TmIG/K7BAoccL9QeEuiQElp2VsuWZTQJA0QI2L
         oQaZ/5KjPI/rlPgeaRRFt2grhJC3fsHGNd02mrgoCfufGwUs4ObSwlauCZuEFLmryo/e
         KKHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xo+jxtw53IJibEUnX5U15qx1PPJfa2tC/dUcuEb631z/pmpEDBVXLdTwIEookCHLvN8yad37oWA==@kvack.org
X-Gm-Message-State: AOJu0YysY9SwijKPsBWUXj2EJEAMwJ3x3tm+r19s6uIsLkRd4NVtSp/g
	/NKW6o28C1ORMCaXocnaUVcPj9PD3wE9q7E8WeWniLykj0Pl3+igGtecDRV9gn9iyI5Xk59hdPt
	gMbHu3DLYRiDgLHnjEoE7r/iA2yyTDSWuGwJRX177FsbX2pPI+9jQPnQpPck=
X-Gm-Gg: Acq92OEqNyKHG53VA7UZuvE/hN1dnCMGTQwpZdVKe/eBxCqzcgnoyRPl10wLzBMdyFs
	pH19z1aA6lLTVFX3gqq+PPPTbN8Z7ORyl4IhECVyNewMPA4RKgR0g/fAmKGxclX8kB5VBszpi3S
	EbONRB84eFrJLFKCEKwwlYyAsDs+bAJibIhelktE0XqjFvJdQeD69RRjduQk7D1jgX7H+j93ap7
	lrJU3tUnmiqjOx0qVvLOtISWkhuA/fX49RlCvlbuq1V289cMtI6+ulXf9ffCa5Wm93qT8a7IPhn
	xQohig==
X-Received: by 2002:a05:622a:a06:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-519549c5dc0mr13818591cf.8.1781487679161; Sun, 14 Jun 2026
 18:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org> <ait21B7kqfT9XhOs@fedora>
 <3914c31f-c97e-4943-9f4f-630b05785014@kernel.org>
In-Reply-To: <3914c31f-c97e-4943-9f4f-630b05785014@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 18:41:07 -0700
X-Gm-Features: AVVi8CfTaoMTbApaagpN1JA0gtF2Zr84PB2r_GpXkAamhbBg2Y1SCtUHhyR3a4M
Message-ID: <CAJuCfpE4Xxn73CaUqHF21RpqoS2N_3R37JKQgeHVV5A9omSW1g@mail.gmail.com>
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: etn8j59um8f9833q7jkws3a5h5mhm46f
X-Rspamd-Queue-Id: 96D0B10000A
X-HE-Tag: 1781487680-972080
X-HE-Meta: U2FsdGVkX18Ngv0aC1r/CTrtzP8qOPdE3vnriwH6Dx5iheAljtIVlfFAldyLheJFHl3QW4NK0XbpV3H62CSGMKuhlxE3gjlsYdYnpODr9K3X5ykyEbBj5maCF41HVAJvsHBr/hqafi4evzHbFjXoRkuQdN+kAnS+rKUR+Tbhs7CwWicA7IafRc0ZU7cgpG3yhARdKI+BcQ7c3qZeJz6OnV8pYHIywydxEcbxPNC5zgMLhBSRkW99HoMC24uH+Yvf/6GZspbRgeFj1+mUF2FexYtIkZ9jsrAb7Ri6ucbwJzW8o5hfnGWm/z0lmYbVlFu+gGosvm8O25ETGTMZbqQ3lLf5UroUmHcwYu7IdkhJ9nZiPx6gp0EiF2riaV45XNgVxTq5ablznavwnI3/eaIQaQZ82F1yfETwUEuwUiW8uF+2UwyzygPh4zWrO7agzdw3r16VKM35w4RiIkoUF+6TcpQNeeJcZEhMCj+Y01EMBxmzEobPytm42PHJZyQYFYz+Wo+Cdn0Oa4uUnyB4yLSiZkqQ22kBWzT2qsst6VgGbVbCce3X/Ec+lRWJur6q7QDZF8CLSmE70V6g26DsM9kzGT/c+pEiJdQZknHsT13esap/OxJ67qicMYlD9SDqFjGuVlSycVFtKbEQlNTDDOwQHGt9923SqYEpAa6xnnCzlWYsVqa+eKz265guxvmmQmnDkDXARnFZo4VZBrw+SiZUgXd8Vf5bm2mHJ4+0dKGMwsYJXldB24M46echo2Y24tlszDbAt2AU4qTf1kd4eqXIgKSzBIHbLkrFAaCelJUVb0pF1mk0/oH7+/JBDSfaixV8cTMNLGW6aURWuFaDfO8pU52bvbeAIPoKIuTCrvdapKMWY0kQmhwmFNxWtfpfRBVPcSwKe8Pmu4lxdFB1gERGK0AR5T9cDg0bybPiZlOmNLJlVW0eW7n4VFcpaLxC1ZLmQsqabCjpGEhKqM/XyG4
 7iRqRitb
 KDunoGGbinWJK9VRF4F3KurGkiLjU7rPU4LPt0356CT4Xuhidq9hkwtlqfeCdIWGk5Z3/WqJOp4u2634wW3IDT491EjJzzpCXt8U0MxBpc/Uldao5joQGVmhPpRePOJ6p7kTaRYihU0NyWRbpQ/oxgAT+ySqW2u7gR8p8ryN1Y1/ynn0sIkjG0qJ6M5sN32PmRlx4ak/4q0piJZYknmUp7gvs8Sz1yJn1mRIqOBlleZMY6oO9JigUnSMxuO7LqI3ME2AxReT1QguZEuGck6Tek1xsCVBvlje47l8gdjEFJ6+/WF6mcNENM16KNO6m6Q15w5UId6d2/YGXsKv94lrRtdxeSMxEBNpeNrAMx1COgVyHyb1l33ctjP5P4B239Snbv0v8AXxspQbjP21sI5QBTE5yZLFUwIcd3etR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 2:51=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/12/26 05:10, Hao Li wrote:
> > On Wed, Jun 10, 2026 at 05:40:06PM +0200, Vlastimil Babka (SUSE) wrote:
> >> @@ -5389,13 +5401,18 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS=
(size, token), gfp_t gfp_flags, in
> >>      if (ret)
> >>              goto success;
> >>
> >> +    struct slab_alloc_context ac =3D {
> >> +            .caller_addr =3D _RET_IP_,
> >> +            .orig_size =3D orig_size,
> >> +    };
> >
> > It might be better to move this to the beginning of the function, to av=
oid
> > patch09 jump to `success` before ac is initialized.
>
> Hm right, didn't compilers actually complain about goto skipping over
> declarations? But neither gcc nor clang do for me, hm. Will move, thanks.

I see it's moved in
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=3Dsl=
ab/for-next,
so

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> >> +
> >>      /*
> >>       * Do not call slab_alloc_node(), since trylock mode isn't
> >>       * compatible with slab_pre_alloc_hook/should_failslab and
> >>       * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
> >>       * and slab_post_alloc_hook() directly.
> >>       */
> >> -    ret =3D __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size=
);
> >> +    ret =3D __slab_alloc_node(s, alloc_gfp, node, &ac);
> >>
> >>      /*
> >>       * It's possible we failed due to trylock as we preempted someone=
 with
> >> @@ -7237,10 +7254,13 @@ static bool __kmem_cache_alloc_bulk(struct kme=
m_cache *s, gfp_t flags,
> >>      int i;
> >>
> >>      if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> >> +            struct slab_alloc_context ac =3D {
> >> +                    .caller_addr =3D _RET_IP_,
> >> +                    .orig_size =3D s->object_size,
> >> +            };
> >>              for (i =3D 0; i < size; i++) {
> >>
> >> -                    p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE, _R=
ET_IP_,
> >> -                                         s->object_size);
> >> +                    p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE, &a=
c);
> >>                      if (unlikely(!p[i]))
> >>                              goto error;
> >>
> >>
> >> --
> >> 2.54.0
> >>
>


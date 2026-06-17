Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B2ECD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C5F6B0092; Wed, 17 Jun 2026 10:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35BC6B009B; Wed, 17 Jun 2026 10:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C516B009D; Wed, 17 Jun 2026 10:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2FE96B0092
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:40:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 635F48DE7F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:52 +0000 (UTC)
X-FDA: 84889666344.04.3DB4B6F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2ABC0C0009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDkB3maB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLldEnRgCoRrO2LVnpcdrMsXlvj2tRLQs6man+PstFw=;
	b=Ym90ACHepa7Mf/3B+kVD17vUy+fmOC8z67dg1zj1swMrQs89sotnAszS2bF8Rpn6xsw8je
	Qg0lW3USRFoj8BzQn68cwsrTeHYhs/zRTfqBh6fPqTGSLggHUcoTsI8qKHaRCf3g84VAgU
	87yIx8PP784I1bqv9kvl+OjMhHkWzwU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDkB3maB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781707250;
	b=bddqWi2sYcWHpypHbkRJhRgZAo+YI5acIY7eb4Xay3mdC5Ty25VB4olShXArshIMms5wZk
	JXngSKF0ScavKqDf0QNK7RH1LYLI9JQXwlNOdZ5mPw6famUjwmLAreEchc3VYBBLiyBT66
	yDlwXq4BgOg89MxE0uiRQkLvid4OVA0=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5177d1ff061so265041cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781707249; cv=none;
        d=google.com; s=arc-20240605;
        b=HavTs86xp3QXa4KKKs2HmcILY7sHz6EPzwMXMV86InC8CZU81c033ElAhgDvo39duX
         VvSXUYKOHpqUD3D10fdkyB6ZRb0dF0a8ewGwn9l2n3M25ocScw1IGRYG9iVsCuhU0WJN
         BrWdYgOrJAADcvxfLVzQVoS2qdDTclvWmZzSyg2UDOZTh3FhG0PBiEexkz9H667wxnVt
         iAu47y020NZgUXURd+2jWWaU/0qpq+pfPrhwSdfmrf04okHrxmodbyYXW/m7IiHHkllu
         801FNR4tEvsVevcBKUVDnnijD9mwCVy2NMeJHl1agBF98PXz8ZDqbwQib+LJYOB1gKtN
         nuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fLldEnRgCoRrO2LVnpcdrMsXlvj2tRLQs6man+PstFw=;
        fh=30fuCMUP+8lxrpuRoGNDZ6slajbWuf32Xi0tjLFooNU=;
        b=gHNirOfrCDkEtSZKnVHRJWK7HVW04fiUwPb7Sf+wuhCk+880dcVxGCQYHIRnfA7Bvk
         qYC5O+5rK1E0H/j9ghotXX9vQtVTtZM+smXM8l9OnI27U7qbs8aCN1t4Z4YxJ5aHqoBv
         nQwdLL3xB0GhEzDGtG2JjcJcMpLOSwmqG7v6q0I6Ubv9p3ODQ0sAWy1hk2Fm7rLbyYbR
         mfVHD14V2eaH6e3fH1+TmEBTQINzps8rc8AbDRDqv5J+QI0xrBM/NQUT11xZuYI0XwAD
         vqCXxFMVvJ/h0gzFVtEWlQP3g7VbPHh5VqAwbuJIAN/ysjvyFpqfIAX0svoHBt5cfYqy
         V66A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707249; x=1782312049; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLldEnRgCoRrO2LVnpcdrMsXlvj2tRLQs6man+PstFw=;
        b=jDkB3maB13hO4ePB7lploGB6TzWeRGlfRtucZcmlzxEJn+X6O3fg0xSHWXmsGUCikQ
         CEFBWoUflmE3q8uqzuGxVjP1qOw7o9BhWnrp6E3krGOPw2E4cNYOxEmURpgvWvReVpqn
         MRTdEpNj7/Iv5Nr5uq0bCSXvbXKVgepI+vctbmAhamiNCRKFzbk0mr4QMnCCLPTUPMPG
         ns1K+oG65pV9pgUVJck/mbPeFrt8mvQwjRPenPlCiwUlbwMP3V3X6whKJ8jENN64fcU0
         bDEOr6qmBTXUcdX41Ofq1K4gD05TrKIeHNsRF/NdWYnTSI6C83FF2Lv0Qkc8khh7Njp9
         EM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707249; x=1782312049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fLldEnRgCoRrO2LVnpcdrMsXlvj2tRLQs6man+PstFw=;
        b=b7jkyhSF2a/GgikihzUi5scxVHyBk9Yv3fVS9pzSWtnfALj2LZejsZxCmzt0e/r3GJ
         u8DHt2/8o/PhrD7KO9LSrd10xkKVk64r0EGuC6qoUieTw7EA1EcLkzqzVwaqHGcH1R1c
         +FpQdd6rVdofq3iCUWnidDJshmIifipTO06ZCTE92y4Z6+gxgSTk7oLwSMhNEG4GwsXA
         Y9Lgp1L1zYPDRez607oKQ9ENSiNWDAUEB0iCCDpVF7GNZauzIuwqLXmIFXLUiPuM9lv0
         JgZ+w/+8qUTPja9N/5y/QggE4Ng0ZvVtNtEh45ZxcHVkL+E1jrCT/gRAp7rIq9DBLA9P
         N6Fg==
X-Forwarded-Encrypted: i=1; AFNElJ9mnnvwqgh22ovcy8AeNtU7Iut5BH4uNOCCudHNq5T6By0s3cO4J4pUh2lKuyXLEiqRrVXQJno4dg==@kvack.org
X-Gm-Message-State: AOJu0YxIQ89Zjh1CB0z6PhxrZ0XRsv30EQnU/VrmTRMGGe3eWJX7A74o
	oqk4sGnQpI3/mhd+Et/nAloSE/AkfDeFgTfXmNvpUatoQKm0LdA/swUAqmfMqQoRAoz5srEN1qU
	3hrZy50ft/F/poReElUyGPt+tsT16Std0F8E1xwSO
X-Gm-Gg: Acq92OGAo7AJy9MfxnKX/ZqkSbA7vxk77sazewW89ZPLBe20odyJOzQYVX/GP5yl+s9
	FR8iq1mc4DLHRJTt7YwsGzQommjUAETji3sBsWxgSk9M5vMLnH3xEuGKMeX9Zx6K/TScKr6NbXr
	h5+3gHSiHvebwp6cIEoQ7MIIFPYBCyqLGXlajrWBT1h25VIpz69JN1keCDPwm87lR0Rth317KXj
	/VW7FI98F015VHQ242P+RBHdZmG0OBHllygiDXtcdM/BHTc8V6xI02UqzggVgadGDdNes632TiR
	GJXT/m6rYL+Jff5JVVaowydqhZs=
X-Received: by 2002:a05:622a:4a06:b0:50e:595d:164 with SMTP id
 d75a77b69052e-519aa968720mr10392311cf.8.1781707248570; Wed, 17 Jun 2026
 07:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org> <20260615-slab_alloc_flags-v3-6-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-6-ce1146d140fb@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 07:40:36 -0700
X-Gm-Features: AVVi8CczXRRxBrbANo6lmOZl2uVP8dSZqTCSvZ0PGtq9Y6RVmxiC-ZjFk4f-2SI
Message-ID: <CAJuCfpEcRj46xRjRXBLeJ_ZOk5COUprNvqRrgiBiQwGTPLhXtA@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] mm/slab: add alloc_flags to slab_alloc_context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ABC0C0009
X-Stat-Signature: htgb8ncmfsxq7boq1apfx1dow3cacxt9
X-HE-Tag: 1781707250-166282
X-HE-Meta: U2FsdGVkX18HY+s0HGP8Fq2JB+TJpZdbf4iiJzqc/IKuDg73MubUNxADx8WSikJS3HlAGZHZHrML1t6nEDcSx0H+wRmSyd/m/2h8HKEv7niXYhNfHMesY51u2o9hxLZEPnpMu/lf/DhGtb38fpZA4FHZwp6C4Vs6zJElbjknpPJhf7XlZkkMuRC59QD/1uPCKIV+SLR7m5jv9YIyxPLARffU3xHIO3U66ZrZ9OKgHENjZvxvQJFX+CXeyx7MQcvNtm2dzGtPAt5+ggz3PgDvZLTu96eufqpfr2ISpGAcp8Iesn3rXYUyqkP0TaG16d7oz1PrpP45ojd/1xI7bggl61lcYPvIXNGl9MuG1vK51ke3iyPNeDDC01fs5u+9y0FdSo31nhHo9tCS7IVqej51/TlycxKYQ8kq7hZ2BwKrJ0e0b3W39TWdgnu4vBRJqNf658c0vVfJ2pB86YkEtIgp750bSAoBNW4LYiHQwrfp1AbIfx2F0L6O8ipTew9zbqYPN2Th42ldZ2rXtTDHtfuaaFQUv/8zIaSktT0PP1MflSbdh6D/+6+VMls+Vxefo7VvHoTx/jFHCdg7SaNrT3I4P7jFF5IxNujN3zrcIXMhu/jNRvl3+y0SApo54J4Rydjq+UCeyi4y8fVEpRnqUHtTAJ2hzLFG9WA4C4SXuS/jpD4q1D4qkPZlUE2Hjb7/rmckRf/vCjC567FGMghxYiqZrmWkwR0Autui8r55ROo8l0UelZ57drwHY+ib7SMQXL+jMhRHPAyu/mOIia/DO+WHyBccijGzvHprTZ192lGwPMXU5eE+Tju79u1OYjpY0GskpMN07fgz+WHBSeTveqiEpY9VoQqB3Rxf06Wick/SVJbv/3LavvgJ7fJP1sOqYepukNPHO2XTbdgs2sb7FxFFWbvp9DBQVIz56rxyWRC/3+RYrdaEftaS6SPMRyayfp3NyCHeO1Cb0D0MjiHJgT6
 L51c+SNL
 PJAGyQokzQJcCdre4UnZb0yar8PCySs7mwns+GDoHNwzi6HUfB3CvM5KxqGN/jlm9FHsLpYRWboe0kYqGlKN+tDyoaiwhFPk7RvQvnPHqnPbiihOAkiEe41RdYOknzM980kKH8OsdxxFyhhw5YNrSIIoByazTgIyhT/GL+Zb7lpjUCty9MAD3EkP5RNNiHGMBeS9kg3Sl5rUoQ6E0AhH5tvlyCpS+8k/XdtgsttEkWRuWIF8MN9NNFryIZlUZ/0IXgVatpsaAqd68p8dy92erNUbIqkYH3ynOsoMSVqq94UMxOGVIncVAuepbR0pTeesnvYUhYWwVDo2awbiKJmhA82sIb6KV+1uQAv6OIKcEPKFmZ3znR04dtYZlxQ+0Bhf6wKnQja4G5d00910nRXDYr3DmiEVIlxwetZWu8j4f1aZQ4UU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 4:55=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> Add alloc_flags as a new field to the slab_alloc_context helper struct,
> so we can pass it to more functions in the slab implementation without
> adding another function parameter.
>
> Start checking them via alloc_flags_allow_spinning() in
> alloc_single_from_new_slab() (where we can drop the allow_spin
> parameter), ___slab_alloc(), get_from_partial_node() and
> get_from_any_partial(). This further reduces false-positive
> spinning-not-allowed from allocations that are not kmalloc_nolock() but
> lack __GFP_RECLAIM flags.
>
> _kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags that
> are SLAB_ALLOC_NOLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
> are not reachable from kmalloc_nolock() and all their callers expect
> spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
> temporary as the scope of slab_alloc_context will further move to the
> callers, making the alloc_flags usage more obvious.
>
> Also change how trynode_flags are constructed in ___slab_alloc() to
> achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
> of checking allow_spin. We need to do that because we now determine
> allow_spin from alloc_flags, and would otherwise start to upgrade e.g.
> kmalloc() allocations without __GFP_KSWAPD_RECLAIM (that however do
> allow spinning) to GFP_NOWAIT, thus including __GFP_KSWAPD_RECLAIM.
>
> During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
> Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
> eliminate them, but it's not a big problem that would need a separate
> fix.
>
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-6-7190909db11=
8@kernel.org
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/slub.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 6f6c15d796e1..3a34907b881b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -217,6 +217,7 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
>  struct slab_alloc_context {
>         unsigned long caller_addr;
>         size_t orig_size;
> +       unsigned int alloc_flags;
>  };
>
>  /* Structure holding parameters for get_partial_node_bulk() */
> @@ -3687,9 +3688,9 @@ static inline void init_slab_obj_iter(struct kmem_c=
ache *s, struct slab *slab,
>   * and put the slab to the partial (or full) list.
>   */
>  static void *alloc_single_from_new_slab(struct kmem_cache *s, struct sla=
b *slab,
> -                                       const struct slab_alloc_context *=
ac,
> -                                       bool allow_spin)
> +                                       const struct slab_alloc_context *=
ac)
>  {
> +       bool allow_spin =3D alloc_flags_allow_spinning(ac->alloc_flags);
>         struct kmem_cache_node *n;
>         struct slab_obj_iter iter;
>         bool needs_add_partial;
> @@ -3835,7 +3836,7 @@ static void *get_from_partial_node(struct kmem_cach=
e *s,
>         if (!n || !n->nr_partial)
>                 return NULL;
>
> -       if (gfpflags_allow_spinning(gfp_flags))
> +       if (alloc_flags_allow_spinning(ac->alloc_flags))
>                 spin_lock_irqsave(&n->list_lock, flags);
>         else if (!spin_trylock_irqsave(&n->list_lock, flags))
>                 return NULL;
> @@ -3891,7 +3892,7 @@ static void *get_from_any_partial(struct kmem_cache=
 *s, gfp_t gfp_flags,
>         struct zone *zone;
>         enum zone_type highest_zoneidx =3D gfp_zone(gfp_flags);
>         unsigned int cpuset_mems_cookie;
> -       bool allow_spin =3D gfpflags_allow_spinning(gfp_flags);
> +       bool allow_spin =3D alloc_flags_allow_spinning(ac->alloc_flags);
>
>         /*
>          * The defrag ratio allows a configuration of the tradeoffs betwe=
en
> @@ -4449,7 +4450,7 @@ static unsigned int alloc_from_new_slab(struct kmem=
_cache *s, struct slab *slab,
>  static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int nod=
e,
>                            const struct slab_alloc_context *ac)
>  {
> -       bool allow_spin =3D gfpflags_allow_spinning(gfpflags);
> +       bool allow_spin =3D alloc_flags_allow_spinning(ac->alloc_flags);
>         gfp_t trynode_flags;
>         void *object;
>         struct slab *slab;
> @@ -4466,18 +4467,15 @@ static void *___slab_alloc(struct kmem_cache *s, =
gfp_t gfpflags, int node,
>          * 1) try to get a partial slab from target node only by having
>          *    __GFP_THISNODE in trynode_flags for get_from_partial()
>          * 2) if 1) failed, try to allocate a new slab from target node w=
ith
> -        *    GPF_NOWAIT | __GFP_THISNODE opportunistically
> +        *    (at most) GFP_NOWAIT | __GFP_THISNODE opportunistically
>          * 3) if 2) failed, retry with original gfpflags which will allow
>          *    get_from_partial() try partial lists of other nodes before
>          *    potentially allocating new page from other nodes
>          */
>         if (unlikely(node !=3D NUMA_NO_NODE && !(gfpflags & __GFP_THISNOD=
E)
>                      && try_thisnode)) {
> -               if (unlikely(!allow_spin))
> -                       /* Do not upgrade gfp to NOWAIT from more restric=
tive mode */
> -                       trynode_flags =3D gfpflags | __GFP_THISNODE;
> -               else
> -                       trynode_flags =3D GFP_NOWAIT | __GFP_THISNODE;
> +               trynode_flags &=3D GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_=
ACCOUNT;
> +               trynode_flags |=3D __GFP_NOWARN | __GFP_THISNODE;
>         }
>
>         object =3D get_from_partial(s, node, trynode_flags, ac);
> @@ -4499,7 +4497,7 @@ static void *___slab_alloc(struct kmem_cache *s, gf=
p_t gfpflags, int node,
>         stat(s, ALLOC_SLAB);
>
>         if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> -               object =3D alloc_single_from_new_slab(s, slab, ac, allow_=
spin);
> +               object =3D alloc_single_from_new_slab(s, slab, ac);
>
>                 if (likely(object))
>                         goto success;
> @@ -4918,6 +4916,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache =
*s, gfp_t gfp, size_t size,
>  static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, str=
uct list_lru *lru,
>                 gfp_t gfpflags, int node, unsigned long addr, size_t orig=
_size)
>  {
> +       const unsigned int alloc_flags =3D SLAB_ALLOC_DEFAULT;
>         void *object;
>
>         s =3D slab_pre_alloc_hook(s, gfpflags);
> @@ -4928,12 +4927,13 @@ static __fastpath_inline void *slab_alloc_node(st=
ruct kmem_cache *s, struct list
>         if (unlikely(object))
>                 goto out;
>
> -       object =3D alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
> +       object =3D alloc_from_pcs(s, gfpflags, alloc_flags, node);
>
>         if (unlikely(!object)) {
>                 const struct slab_alloc_context ac =3D {
>                         .caller_addr =3D addr,
>                         .orig_size =3D orig_size,
> +                       .alloc_flags =3D alloc_flags,
>                 };
>                 object =3D __slab_alloc_node(s, gfpflags, node, &ac);
>         }
> @@ -5366,6 +5366,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size=
, token), gfp_t gfp_flags, in
>         const struct slab_alloc_context ac =3D {
>                 .caller_addr =3D _RET_IP_,
>                 .orig_size =3D orig_size,
> +               .alloc_flags =3D alloc_flags,
>         };
>
>         VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
> @@ -7254,6 +7255,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cac=
he *s, gfp_t flags,
>                 const struct slab_alloc_context ac =3D {
>                         .caller_addr =3D _RET_IP_,
>                         .orig_size =3D s->object_size,
> +                       .alloc_flags =3D SLAB_ALLOC_DEFAULT,
>                 };
>                 for (i =3D 0; i < size; i++) {
>
>
> --
> 2.54.0
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBBCCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30BE6B0005; Mon, 15 Jun 2026 00:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1006B008A; Mon, 15 Jun 2026 00:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0496B008C; Mon, 15 Jun 2026 00:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA6566B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:35:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FE74A089F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:35:43 +0000 (UTC)
X-FDA: 84880883766.25.B24992C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C74AA0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:35:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phGaPFHZ;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781498141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bom2krBAQT6Qlap90R6BFlutbauj16k/dhPk3OXzZdQ=;
	b=U0Q28opM0WwQ10UILc3kmHzPG+CMLBZlW7bS4L9oMbjjyxrsAKxDJHoYy+Pt0+CYwALKYN
	StoYMK7p5Vneaf8M6u06exaf8x/MKsNpFtV2tPaquZq6Ezjmcu8AF0MHLagF+Ehqf02hSc
	rVSSgI/DMW19XBCelnYXr7ZEKwS0oUI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phGaPFHZ;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781498141;
	b=m/zXcGG/eNxeG7QsXGoFxOK0q6q9NiGntN2nH065GXoPEVnrj0EDayiW6hZY+dI5KVk/zF
	kZRxMU8p3raELHRdT2qI5v0Br05lggjABoloEFGVH19u2BwsindoprhE9GcOGTDHNRnNOi
	IAjk9PxoflZhCwS36zNmnKnAONCHj58=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so721331cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:35:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781498140; cv=none;
        d=google.com; s=arc-20240605;
        b=Bti90wpvTKv4TK5MgeJckPEr33Sutp/qCuoAbwsvLmm5rFcKuXPjO/U2Y/tnUMpja2
         nlayUnE70d4z67fWsvd3wxi10LX6Hq8aQq0FGqk4yAZws5gckCMH5hHagqFaqgeycOij
         ZMXYSdUPSuO9jPzMrCLERpgeArBAF8EAw+Wugdq/x71FTjs24owm3cz0rjky7+vdH3i2
         wQCJ37U7/7OcPHnFrhAKz7k8IQwXQ+Qqf14KAIpmLiTb18Lx5mMZUqkUh+8mm4gIip2I
         BklJtoewx0HTpFovim8e5cp9Ugac7w1Uaa132QMtIbqWbQ5XX0lctFyLQlf8nkfAYeC2
         8/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bom2krBAQT6Qlap90R6BFlutbauj16k/dhPk3OXzZdQ=;
        fh=XSzLrOUg+v8QtH/vT21Kx+GVK1EtxXDDYPiHUPTKWNQ=;
        b=BgFPk/JKi5nN5w6uXPf9WHUWWUO24NOx5RqlrNyBgfgGpzye01FpwCTDjWmdWSXGDA
         7GVaFODtIxDzNg3bJyyNuQxB0U0hZZCr+5A8qHF/6ZOhipzxqm1/0KQjKud+9rFy3Gfc
         NDVsKxy1Ms81i26bDmEVYaxLzrQN0UMnHLVgswPN1dGJuo088ZX2ukn5nJT64z7L+6QC
         42YLO8OnaeTmihDV0BIvwZ3vw3n+TpqHmfoNaZAPLiqTm3ABpIiHOoB39zDM48aAUTsz
         /LMWWIr6N7lOe/LikH2L8rz1E7ImLhmBdHCKoROyF7grlFC8sS35iFHE3i/PZY2JvCKI
         aPhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781498140; x=1782102940; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bom2krBAQT6Qlap90R6BFlutbauj16k/dhPk3OXzZdQ=;
        b=phGaPFHZ2IyQvmfKN55D+RlRK42eS0SUAJKDRtMcSly0AYGbu996rAhMGAi/GtcJ18
         gSD8VhDDlcKfJj1ZbALUTL3Aco4OZAnmP6t19G1Udsz6l9DDWcu5pnHaBL8fNxevCBmA
         ffwM/lebgo+9I6/zdeKEOD5kTWkGFgYvam9MtBk/7RhG71mOVQFgZHFQzJYDRuay98Oy
         DmI/kL68iEMohYhrhLb33Qc5arUPR+Ip3R0rJTiXHOIk03h/j4QdVAXUyOVf4TQcMUy6
         CA52Eaum67iWzflciWbLp0jGiCknzWDm9/qL39EZ5ODDxRdgOSlCEU8qTmcb0c+2eKo5
         CEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781498140; x=1782102940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bom2krBAQT6Qlap90R6BFlutbauj16k/dhPk3OXzZdQ=;
        b=aRxU920goha7tFKQ8g1EUQf0A9DBHI4oipaLGYHgkDbQmt0M/WHywSFKLg7BxTxsoq
         FNqICUpSyHY1C0Se2QLFxlqAjFBzTbuMVYWq8QDiP/2vWM8VY7INRW1TsxDWALPs7j7U
         h96zc3fODXa863N+jqdzC9RMDXRTVXlvtSby/8lwmORDunsNLMfcYdIldDIgaKg072DH
         ZsKzEDKX0RrMrB9b68cRWS1GWV7aCtiCd+52RFJk9l+d0DpBt6mC3kv4t7/7VGjr9TN2
         T5gKoR0+/C2l1QLCkcosO9oa9gAVcESpl7I2whRbQX7mOhDphr3jqRydJNINC5+KKfTu
         wYYg==
X-Forwarded-Encrypted: i=1; AFNElJ+l+Kk/aMRSpRWHs7kvelZ+KZsB2MQ6TV6p4Chj4bmhEX+RwEk9YsHC5vlykA5/JjJc6eTr43efGw==@kvack.org
X-Gm-Message-State: AOJu0YzBIsNiluVbyGh4AlixXXOXXT0x+qTdWPj8kb/F5qtfAtAuaTXX
	vbmr8LC9RqF96Y7kKq6bmPDMO8r3vI0e/yHtnc/aDWhV1sZsO3Cqj5oup4ymJL/iY0YykV82poN
	bvuFwP11IEdXhg0DbH0ZCrTWWp+sKLx+ZZdVtYEE+lyTA/z239I/bwOPPAYA=
X-Gm-Gg: Acq92OGsTAOyqXEHKcwPlpV03Isf0DY9qOKACLnYYw3P1WtnMn3MB3rw/55hDML/Mms
	94u+8hZyj3FcNpT8CiIyXWM0HWkVBpssk19nHI1sUgLcjyWYNCaG7A72IGVZ5YYr+g0kIhqXDSX
	TIIGFAEBd1Lt5rh372XhDs/MfmGR6zt1dS7to4z2StIRlbiiJ7rctgDT3PuKnaojZN2GG1gQyvx
	nQAo7aq0NkrOqfyHmdbmhIiPMYHDZy5bC5BUEeKt2udePqpIfpGqs4IGjZFjvXV2uzLGdMySTT0
	0drouQ==
X-Received: by 2002:ac8:598a:0:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51955eb4b1bmr11873931cf.15.1781498139606; Sun, 14 Jun 2026
 21:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org> <20260610-slab_alloc_flags-v2-9-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-9-7190909db118@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:35:26 -0700
X-Gm-Features: AVVi8CdSf5bHsSxRYmIPo23FazBd7NlQv_pUkyRlcofBL7XF0ClZnOPI_i_k6A0
Message-ID: <CAJuCfpF0mcV3TUCNi981YO=uT=5p_7OOY1S6zdgwm5PMMV3w8g@mail.gmail.com>
Subject: Re: [PATCH v2 09/16] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C74AA0005
X-Stat-Signature: uxrtigrjidngaig53jmwxsyxdeznmtoe
X-Rspam-User: 
X-HE-Tag: 1781498141-162001
X-HE-Meta: U2FsdGVkX18GNRc1cFx3sykvbiNlPkFLDypqE1SaZMG42EIUOIsWspNLFR4ENKpn/3ASRzZFTG8Gjk1AnLCEG92QS8gzT5edATXSNCAUtNfpCyLKWeDOLi363Hxr2vLhC+HoaK1kXa9hjQVisTXHKIufgiBe3+PbIBjh6y5gt57qNzNJaoFqBBLEOak6IyC2/vWpmMAeduqQWXKC8+VIxjE1crauYyq+DjvoCczZ4JU9sEJjYAVlXa54KN7/k1nGthG1e/VEGlgS+Mj72LNRDzLodOQwrHe8+ltljbjh3LHBflhHnqbBSYp1HSmuI6iY6QuMhbf0ffpD0v8ofMNDZPxLgOn1QmA9RKDY4Vps1r3mDP7ws+N+A6yR/rNkExXJjnt7+zVgABu0mVQL8NbLE+Nl1DLLpcduWBdEo0BfT2z0h1Uih/a+VJ54g2sMjrfL0CT0PafRCqK3+NxceaA55r3EW068Slm4uMyBn7EItAsXu5S40gwcsKljGYpC2dUqbZIdcEJLvbSiSlrEKuO90l5GcG1NoW1CL8eeQy4Ln0OztgfkHWb0kLXSwn0MREbprGjsyZSEc9/7RNkTMxtEHX+1pfxnXtjSWjvhBxzOp399/1r9JyA4nij/2cnTlr4FdEQzOca9y4suVUps+yqsazke81NoJAp+1RpqUovfRHbrnRee4yz/RtakJQZ2PuNgLfymXKO6X7WoYbwia/Pjix9L2q8zEoplJa463+S2f1niDpEkwijf/E2nJw/TiNR37lrrGnRUV8o5mgTO07gLetBAb0OyfbESY7vguCjE3mQH5q0xZsFrJto1LbHMGZSI13TWTYK+b653GeGDKjV1ec9rEO7y34z8ULMGX4ihjyphtygaTxdpa0ZFHHGsCU/uUDgKYQYfrh8o66m+P99xNgoDAjh8WRjkMqp0P7zoccdzpvy+hQFP/csBG3F0QqQ78a48dNVF1uxHOxY/o5V
 xJEI8Idd
 F5b0rOZcTWEXBlLFsS3131ZRUr0CuGNpsN70/qwYCGFuRY+/9PN9c1aM0ZiP6B+EqlnOhmMBr86YtTSUC2u98Bq/MMZyT+I0b64D79avVyQkS9p7PiYrGzn7A+HHkq4sRy1oYsylrbaHx/TDEKvyMJfaJo7/ex7Wi/BiDnI78sa6HMKtwoloTuvzG4pajRYuLtcSeBNCmiTYAPQBb7gUukIL/zrt8WtM01yBDfLeLdkp74ROI4q94YrKgNsSkVOD+pdFeLR00XjGHuEdYL+oBQobJdy7tKjdbJj3SP3QkWA7OTlFpKnBO72757A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:41=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> Convert the whole following call stack to pass either slab_alloc_context
> (thus including alloc_flags) or just alloc_flags as necessary:
>
> slab_post_alloc_hook()
>   alloc_tagging_slab_alloc_hook()
>     __alloc_tagging_slab_alloc_hook()
>       prepare_slab_obj_exts_hook()
>         alloc_slab_obj_exts()
>   memcg_slab_post_alloc_hook()
>     __memcg_slab_post_alloc_hook()
>       alloc_slab_obj_exts()
>
> Converting all these at once avoids unnecessary churn and is mostly
> mechanical.
>
> This ultimately allows to decide if spinning is allowed using
> alloc_flags in alloc_slab_obj_exts(), as well as slab_post_alloc_hook().
> Aside from alloc_from_pcs_bulk() (to be handled next) there is nothing
> else in slab itself relying on gfpflags_allow_spinning() which can
> be false even if not called from kmalloc_nolock().
>
> A followup change will also use the alloc_flags availability in the call
> stack above to remove the __GFP_NO_OBJ_EXT flag.
>
> For alloc_slab_obj_exts(), also replace the suboptimal "bool new_slab"
> parameter with a SLAB_ALLOC_NEW_SLAB flag with identical functionality.
>
> To further reduce the number of parameters of slab_post_alloc_hook(),
> also make 'struct list_lru *lru' (which is NULL for most callers) a new
> field of slab_alloc_context.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/memcontrol.c |  5 +--
>  mm/slab.h       |  6 ++--
>  mm/slub.c       | 94 +++++++++++++++++++++++++++++++++------------------=
------
>  3 files changed, 62 insertions(+), 43 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c03d4787d466..29390ba13baa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3424,7 +3424,8 @@ static inline size_t obj_full_size(struct kmem_cach=
e *s)
>  }
>
>  bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru =
*lru,
> -                                 gfp_t flags, size_t size, void **p)
> +                                 gfp_t flags, unsigned int slab_alloc_fl=
ags,
> +                                 size_t size, void **p)
>  {
>         size_t obj_size =3D obj_full_size(s);
>         struct obj_cgroup *objcg;
> @@ -3472,7 +3473,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>                 slab =3D virt_to_slab(p[i]);
>
>                 if (!slab_obj_exts(slab) &&
> -                   alloc_slab_obj_exts(slab, s, flags, false)) {
> +                   alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)=
) {
>                         continue;
>                 }
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 96f65b625600..4db6d8aa0ee3 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -19,6 +19,7 @@
>  /* slab's alloc_flags definitions */
>  #define SLAB_ALLOC_DEFAULT     0x00 /* no flags */
>  #define SLAB_ALLOC_TRYLOCK     0x01 /* a kmalloc_nolock() allocation */
> +#define SLAB_ALLOC_NEW_SLAB    0x02 /* a flag for alloc_slab_obj_exts() =
*/
>
>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_f=
lags)
>  {
> @@ -612,7 +613,7 @@ static inline struct slabobj_ext *slab_obj_ext(struct=
 slab *slab,
>  }
>
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> -                        gfp_t gfp, bool new_slab);
> +                       gfp_t gfp, unsigned int alloc_flags);
>
>  #else /* CONFIG_SLAB_OBJ_EXT */
>
> @@ -642,7 +643,8 @@ static inline enum node_stat_item cache_vmstat_idx(st=
ruct kmem_cache *s)
>
>  #ifdef CONFIG_MEMCG
>  bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru =
*lru,
> -                                 gfp_t flags, size_t size, void **p);
> +                                 gfp_t flags, unsigned int slab_alloc_fl=
ags,
> +                                 size_t size, void **p);
>  void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
>                             void **p, int objects, unsigned long obj_exts=
);
>  #endif
> diff --git a/mm/slub.c b/mm/slub.c
> index 8f6ca3d5fdfa..e634137b67fa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -218,6 +218,7 @@ struct slab_alloc_context {
>         unsigned long caller_addr;
>         unsigned long orig_size;
>         unsigned int alloc_flags;
> +       struct list_lru *lru;
>  };
>
>  /* Structure holding parameters for get_partial_node_bulk() */
> @@ -2155,9 +2156,9 @@ static inline size_t obj_exts_alloc_size(struct kme=
m_cache *s,
>  }
>
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> -                       gfp_t gfp, bool new_slab)
> +                       gfp_t gfp, unsigned int alloc_flags)
>  {
> -       bool allow_spin =3D gfpflags_allow_spinning(gfp);
> +       const bool allow_spin =3D alloc_flags_allow_spinning(alloc_flags)=
;
>         unsigned int objects =3D objs_per_slab(s, slab);
>         unsigned long new_exts;
>         unsigned long old_exts;
> @@ -2206,7 +2207,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>         old_exts =3D READ_ONCE(slab->obj_exts);
>         handle_failed_objexts_alloc(old_exts, vec, objects);
>
> -       if (new_slab) {
> +       if (alloc_flags & SLAB_ALLOC_NEW_SLAB) {
>                 /*
>                  * If the slab is brand new and nobody can yet access its
>                  * obj_exts, no synchronization is required and obj_exts =
can
> @@ -2331,7 +2332,7 @@ static inline void init_slab_obj_exts(struct slab *=
slab)
>  }
>
>  static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> -                              gfp_t gfp, bool new_slab)
> +                              gfp_t gfp, unsigned int alloc_flags)
>  {
>         return 0;
>  }
> @@ -2351,10 +2352,10 @@ static inline void alloc_slab_obj_exts_early(stru=
ct kmem_cache *s,
>
>  static inline unsigned long
>  prepare_slab_obj_exts_hook(struct kmem_cache *s, struct slab *slab,
> -                          gfp_t flags, void *p)
> +                          gfp_t flags, unsigned int alloc_flags, void *p=
)
>  {
>         if (!slab_obj_exts(slab) &&
> -           alloc_slab_obj_exts(slab, s, flags, false)) {
> +           alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
>                 pr_warn_once("%s, %s: Failed to create slab extension vec=
tor!\n",
>                              __func__, s->name);
>                 return 0;
> @@ -2366,7 +2367,8 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, st=
ruct slab *slab,
>
>  /* Should be called only if mem_alloc_profiling_enabled() */
>  static noinline void
> -__alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_=
t flags)
> +__alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_=
t flags,
> +                               unsigned int alloc_flags)
>  {
>         unsigned long obj_exts;
>         struct slabobj_ext *obj_ext;
> @@ -2382,7 +2384,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *=
s, void *object, gfp_t flags)
>                 return;
>
>         slab =3D virt_to_slab(object);
> -       obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, object);
> +       obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_fla=
gs, object);
>         /*
>          * Currently obj_exts is used only for allocation profiling.
>          * If other users appear then mem_alloc_profiling_enabled()
> @@ -2401,10 +2403,11 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache=
 *s, void *object, gfp_t flags)
>  }
>
>  static inline void
> -alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t =
flags)
> +alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t =
flags,
> +                             unsigned int alloc_flags)
>  {
>         if (mem_alloc_profiling_enabled())
> -               __alloc_tagging_slab_alloc_hook(s, object, flags);
> +               __alloc_tagging_slab_alloc_hook(s, object, flags, alloc_f=
lags);
>  }
>
>  /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -2443,7 +2446,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, =
struct slab *slab, void **p,
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>
>  static inline void
> -alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t =
flags)
> +alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t =
flags,
> +                             unsigned int alloc_flags)
>  {
>  }
>
> @@ -2461,8 +2465,9 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, =
struct slab *slab, void **p,
>  static void memcg_alloc_abort_single(struct kmem_cache *s, void *object)=
;
>
>  static __fastpath_inline
> -bool memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *l=
ru,
> -                               gfp_t flags, size_t size, void **p)
> +bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
> +                               size_t size, void **p,
> +                               struct slab_alloc_context *ac)
>  {
>         if (likely(!memcg_kmem_online()))
>                 return true;
> @@ -2470,7 +2475,8 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *=
s, struct list_lru *lru,
>         if (likely(!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT)=
))
>                 return true;
>
> -       if (likely(__memcg_slab_post_alloc_hook(s, lru, flags, size, p)))
> +       if (likely(__memcg_slab_post_alloc_hook(s, ac->lru, flags,
> +                                               ac->alloc_flags, size, p)=
))
>                 return true;
>
>         if (likely(size =3D=3D 1)) {
> @@ -2558,14 +2564,15 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>                 put_slab_obj_exts(obj_exts);
>         }
>
> -       return __memcg_slab_post_alloc_hook(s, NULL, flags, 1, &p);
> +       return __memcg_slab_post_alloc_hook(s, NULL, flags, SLAB_ALLOC_DE=
FAULT,
> +                                           1, &p);
>  }
>
>  #else /* CONFIG_MEMCG */
>  static inline bool memcg_slab_post_alloc_hook(struct kmem_cache *s,
> -                                             struct list_lru *lru,
> -                                             gfp_t flags, size_t size,
> -                                             void **p)
> +                                             gfp_t flags,
> +                                             size_t size, void **p,
> +                                             struct slab_alloc_context *=
ac)
>  {
>         return true;
>  }
> @@ -3352,12 +3359,14 @@ static inline void init_freelist_randomization(vo=
id) { }
>  #endif /* CONFIG_SLAB_FREELIST_RANDOM */
>
>  static __always_inline void account_slab(struct slab *slab, int order,
> -                                        struct kmem_cache *s, gfp_t gfp)
> +                                        struct kmem_cache *s, gfp_t gfp,
> +                                        unsigned int alloc_flags)
>  {
>         if (memcg_kmem_online() &&
>                         (s->flags & SLAB_ACCOUNT) &&
>                         !slab_obj_exts(slab))
> -               alloc_slab_obj_exts(slab, s, gfp, true);
> +               alloc_slab_obj_exts(slab, s, gfp,
> +                                   alloc_flags | SLAB_ALLOC_NEW_SLAB);
>
>         mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
>                             PAGE_SIZE << order);
> @@ -3434,7 +3443,7 @@ static struct slab *allocate_slab(struct kmem_cache=
 *s, gfp_t flags,
>          * to prevent the array from being overwritten.
>          */
>         alloc_slab_obj_exts_early(s, slab);
> -       account_slab(slab, oo_order(oo), s, flags);
> +       account_slab(slab, oo_order(oo), s, flags, alloc_flags);
>
>         return slab;
>  }
> @@ -4568,9 +4577,8 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_=
cache *s, gfp_t flags)
>  }
>
>  static __fastpath_inline
> -bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
> -                         gfp_t flags, size_t size, void **p,
> -                         unsigned int orig_size)
> +bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size=
,
> +                         void **p, struct slab_alloc_context *ac)

Would if be possible to make this last parameter a ""const struct
slab_alloc_context*" (here and in other functions accepting it)? I
think these functions accept it as an input parameter only and are not
supposed to change it, right? Makes it easy to veriy that
slab_alloc_context is not changed between consequitive calls reusing
it, for example inside slab_alloc_node().

>  {
>         bool init =3D slab_want_init_on_alloc(flags, s);
>         unsigned int zero_size =3D s->object_size;
> @@ -4590,7 +4598,7 @@ bool slab_post_alloc_hook(struct kmem_cache *s, str=
uct list_lru *lru,
>          * orig_size if we track it.
>          */
>         if (slub_debug_orig_size(s))
> -               zero_size =3D orig_size;
> +               zero_size =3D ac->orig_size;
>
>         /*
>          * When slab_debug is enabled, avoid memory initialization integr=
ated
> @@ -4616,14 +4624,14 @@ bool slab_post_alloc_hook(struct kmem_cache *s, s=
truct list_lru *lru,
>                                      !kasan_has_integrated_init())
>                                  && !is_kfence_address(p[i]))
>                         memset(p[i], 0, zero_size);
> -               if (gfpflags_allow_spinning(flags))
> +               if (alloc_flags_allow_spinning(ac->alloc_flags))
>                         kmemleak_alloc_recursive(p[i], s->object_size, 1,
>                                                  s->flags, init_flags);
>                 kmsan_slab_alloc(s, p[i], init_flags);
> -               alloc_tagging_slab_alloc_hook(s, p[i], flags);
> +               alloc_tagging_slab_alloc_hook(s, p[i], flags, ac->alloc_f=
lags);
>         }
>
> -       return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
> +       return memcg_slab_post_alloc_hook(s, flags, size, p, ac);
>  }
>
>  /*
> @@ -4918,6 +4926,12 @@ static __fastpath_inline void *slab_alloc_node(str=
uct kmem_cache *s, struct list
>  {
>         const unsigned int alloc_flags =3D SLAB_ALLOC_DEFAULT;
>         void *object;
> +       struct slab_alloc_context ac =3D {
> +               .caller_addr =3D addr,
> +               .orig_size =3D orig_size,
> +               .alloc_flags =3D alloc_flags,
> +               .lru =3D lru,
> +       };
>
>         s =3D slab_pre_alloc_hook(s, gfpflags);
>         if (unlikely(!s))
> @@ -4929,14 +4943,8 @@ static __fastpath_inline void *slab_alloc_node(str=
uct kmem_cache *s, struct list
>
>         object =3D alloc_from_pcs(s, gfpflags, alloc_flags, node);
>
> -       if (unlikely(!object)) {
> -               struct slab_alloc_context ac =3D {
> -                       .caller_addr =3D addr,
> -                       .orig_size =3D orig_size,
> -                       .alloc_flags =3D alloc_flags,
> -               };
> +       if (!object)

Any reason "unlikely" is removed?

>                 object =3D __slab_alloc_node(s, gfpflags, node, &ac);
> -       }
>
>         maybe_wipe_obj_freeptr(s, object);
>
> @@ -4945,7 +4953,7 @@ static __fastpath_inline void *slab_alloc_node(stru=
ct kmem_cache *s, struct list
>          * In case this fails due to memcg_slab_post_alloc_hook(),
>          * object is set to NULL
>          */
> -       slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
> +       slab_post_alloc_hook(s, gfpflags, 1, &object, &ac);
>
>         return object;
>  }
> @@ -5240,6 +5248,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cac=
he *s, gfp_t gfp,
>                                    struct slab_sheaf *sheaf)
>  {
>         void *ret =3D NULL;
> +       struct slab_alloc_context ac =3D {
> +               .orig_size =3D s->object_size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
>
>         if (sheaf->size =3D=3D 0)
>                 goto out;
> @@ -5250,7 +5262,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cach=
e *s, gfp_t gfp,
>                 ret =3D sheaf->objects[--sheaf->size];
>
>         /* add __GFP_NOFAIL to force successful memcg charging */
> -       slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->obj=
ect_size);
> +       slab_post_alloc_hook(s, gfp | __GFP_NOFAIL, 1, &ret, &ac);
>  out:
>         trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
>
> @@ -5437,7 +5449,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size=
, token), gfp_t gfp_flags, in
>
>  success:
>         maybe_wipe_obj_freeptr(s, ret);
> -       slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
> +       slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
>
>         ret =3D kasan_kmalloc(s, ret, orig_size, alloc_gfp);
>         return ret;
> @@ -7303,6 +7315,10 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cach=
e *s, gfp_t flags,
>  {
>         unsigned int i =3D 0;
>         void *kfence_obj;
> +       struct slab_alloc_context ac =3D {
> +               .orig_size =3D s->object_size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
>
>         if (!size)
>                 return false;
> @@ -7353,7 +7369,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache=
 *s, gfp_t flags,
>
>  out:
>         /* memcg and kmem_cache debug support and memory initialization *=
/
> -       return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->ob=
ject_size));
> +       return likely(slab_post_alloc_hook(s, flags, size, p, &ac));
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
>
>
> --
> 2.54.0
>


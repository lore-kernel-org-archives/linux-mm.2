Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89430C9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DAC6B0005; Fri, 16 Jan 2026 21:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAF96B0088; Fri, 16 Jan 2026 21:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C732B6B0093; Fri, 16 Jan 2026 21:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B35A66B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:11:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C9D8583A8
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:11:16 +0000 (UTC)
X-FDA: 84339828552.11.EADFB5A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70567C0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:11:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pEsgPBxI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768615874; a=rsa-sha256;
	cv=pass;
	b=nu/QeTCnHmtNdvxQ1V5LVaR/kiR1Kk1aieyy4x0cqkQmenOi9VeVIbGFHrs0KQSnXc/Yh6
	JQLvWllyqr02Brun+n7nZ/Vqz36ioyP88vOiCayDQ8NSSXajJu1A6nJaJ9ZL8M0WASpVI3
	mAgt23ln9Mp8/rBlirev4VE2SHuvhKM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pEsgPBxI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8XfzdTcYbKXbttOZYCkhexZVaSChWM1LNoqV+hh1gE=;
	b=7ggxtTUtkhMCfMDjVfcVsYjrDZEaVN+030Yq7UZY3Scufu5pMiTqUeEKFm57YsLMqlvK+k
	Be4pecCHP7+Ym/qbJd1DD80RfhQXJENLqBqgsz+w3QKSLfitFjfjJc4F1nPsLnrQT/iKhF
	EADUzdRTiACR3Yr9007aXfNn4kBggTw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50299648ae9so112381cf.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:11:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768615873; cv=none;
        d=google.com; s=arc-20240605;
        b=LMmblAmfOFHs1Y3WxYaOwW+QtA3maTg5dj5EIU9cuYRf+TOoVXPmlpoZld5Sn4paXt
         EYI03xEqnsUt1gxkTDO772jqqBGdGhBQ1zybhGbWRst+NWOqazHeISNjFEGV11rwwYz0
         60nUeK0jJ/mCFi4Pw8fjFPYSweyFY8VcsldHoKiYqC+Oo+4E4qtIEeEwTF4lwIO94UKt
         X5dU5EBrSw/Wqi4+oY98bopbtGxRY2YjNBad2ihcGv4R9F9e5JOX/y3FGwNlZ89w1kbd
         LtJVeOFjG6wvBfg9g8kP1wEbxSIYYVuSs1fXdWHpgfricbTFOYoGrrogQC5NQxtWVbvl
         YKUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z8XfzdTcYbKXbttOZYCkhexZVaSChWM1LNoqV+hh1gE=;
        fh=a4Dm5tViZt2SkUWyNcMV2EBByyfvG/B8vsjz6qSviaE=;
        b=FQtWQ/mqbhawBDdBnMsd6lqtl9NXPnfeKK+9za8vdvkz/i5mTKYuj2tC/SvAaPr3xv
         CELxCPYO+zU8pVmVXxJv5HT2fTk/J+NemLlqJpxlcaomaIL0n8ZWbZP37JmAF4j7rXin
         YY2KXqTxLscGqxTPasSIhAwq5VVZvjfvITBZLodWUAp8IWdRs6+nk05Q1aPi0jAtbFg6
         hjhJZc89RisS7hdFV9STNM6BqI2lV3vFMteX8F2P/PQGZWs/SxROmPTqrwBGmAa2kX3F
         cGHGTPhbRuCcVKGGLcn1nEEcmVDi/hjyG1YzqdfWPaKvy8Is/WVNvqK3bCKugpoRc3by
         h0lQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768615873; x=1769220673; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8XfzdTcYbKXbttOZYCkhexZVaSChWM1LNoqV+hh1gE=;
        b=pEsgPBxI6FndKRTGc7YwJTlVP2w/gH9fVeUi0JlITu70MfGKyo7qLDGrE6hsTsZ9ei
         dxC6DSk5JQM2kTQLI05fN11OKdVHKdaHQIs1I963Df5tTNomPXFcjPYpcy1I0zOqlwgD
         mvNM3ht9mcpHDkRj/mfVhzOINoDt6BbJaTjPmz5+Z0uZUWRJ07nXc/8klBoK2N1M3soc
         g6Wnp/NI3AtmSFkV31jO5VyZAGd8vSGoq80M2ZCgBcdR8/x1Mda2uw3lrMSUniwiArWD
         SxcrtNbpRelAsOPUK4jmiCI3fs7pbwK7GahRLgRvkZ5h1Ykg6jfWUlwV98KRpt/PxQxX
         Grbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768615873; x=1769220673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z8XfzdTcYbKXbttOZYCkhexZVaSChWM1LNoqV+hh1gE=;
        b=ocdzJXlMny704wiDz0c9Hom2q7Xc5JC9N74CqUOPPTHDxsxDmXZnOaGG6Xl+r99Igc
         CYZJITZENoLltG7bEmFbryDVYFTvq8rBpkNtCgAU0dQ2XDv2gFESFTazh19tLXo2qdGc
         9YsowOeDtz8k7jSFkjhp9KsXPMhRHs85eKBsLNriRlI0y9KlEiJC54cPOreQ1FdQhNhH
         r2tgqvLHCeG19alKt3tnyDjCkhlT8egVh+HrbJMkt/InPCNdZwopcGSCNli6VuzOuVNF
         0+K5i2UwKIGnSI0FT6r8VW+lfwPx5Al4sFOMWGzpuNTBFlpPe5laQac/10uCZm1GzXgo
         QzMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrKQXckfKJOtG8e1a/ikosiqZSBA5g8iu3wDS8E7LAkFFi0ULVPaz7tnLf3mfez5FJjaAy5Rfw4Q==@kvack.org
X-Gm-Message-State: AOJu0Yy6fUr+IGaAbpTf5w9TszJkAwWBLn3aFoTnCyHz+zGC+T+kqzxh
	kM3IL0EBD4bJ8Ud9KBHJ+My9JmfvSjzd4R5fNhiQ3q0srYp1xyq2HYaUdDDSqu0ur9I3lzikvpq
	AamCkLoXwB7MSlKQYt5NqfR596efn5BvmMLHylpQu
X-Gm-Gg: AY/fxX4cvDUfxaZaZaCDZJj2Ku4bZNIOqEcjPBiy33zMmCceC5aeesdot37QfIyehOo
	KXa3lcMNUoPiPjBQEqUqHXjIz51iZwp65TPDlOzAhAQmXKLZ+Lo9MyYslQ4F48GU7Z3GesAqbgj
	7zFmufwn8ghcAj2jeuRaa8lKhEmz36mW8QitjT3HLQGAzON3LOtgTW69wEjO8RJPv83Pt8iRGJZ
	y18Yk3UAF1zSxUBzh3do83pIOViHvTarDPOV3Go/uqeBENCRkCjdgLAda0H0TKlHfMyq42HkQa6
	8AS1TE/Fj9i/uE7qJV5wL0OE1jz/+lae4A==
X-Received: by 2002:a05:622a:607:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-502afa038cbmr4649721cf.12.1768615873084; Fri, 16 Jan 2026
 18:11:13 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 17 Jan 2026 02:11:02 +0000
X-Gm-Features: AZwV_QgrFpJPgQWV97FWxIc0ZsJ8CltGCxNFZv_PPGY8cU_AH1jVOdq1pMTHKpM
Message-ID: <CAJuCfpERcCzBysPVh63g7d0FpUBNQeq9nCL+ycem1iR08gDmaQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
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
X-Rspamd-Queue-Id: 70567C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: 3bq9tj94zjw9jg7fp38q499mdno6sadn
X-Rspam-User: 
X-HE-Tag: 1768615874-22477
X-HE-Meta: U2FsdGVkX1/Zyl6VGGReqaw5FNKcZylQ+FhnLhFOLQaBCOigfyATqhy/njmaQ+CiTtHzWHDkVMM4AVZwqUPuOCkaeSFZNimEDCWBb4KXAhQTbRmFkO9yPJptMGQFzozTBjc2KkxpnZu23AVtwS11iLk5R16xd3twVGEvBg2/Yvs762eg3SBqR0j+Hcx4dxBwnQTfATrvqAArahGHbDv0++02Lr43vSDRUbBS2PG55NvhjHNIEIdc6sZL37Rzc9fxq6BPvqhkEQaYwU3S3k8BZ1MT3IyTC7G5xEevNQzhurgdPDt7y0ETsITV4mRARkim2ZCHyQuj3oQvAd6miFc4LRVJk+7Q1Xw22IliGfOw97bmRRBpnkVvmYvfTev3smqCBPqvJWPp6xtF05EqEgp2kk8hBFMe53n59U5jS8FWY7nYG7wO/Z6mpiKx0s3CzfyJMPe1jwf/ZH660HKwinEnCAb214N4Q1o4o/WmZcoo5SmzYfoJ72KeTybf/5rgn8BEHXgz4ZVi9b22iqO5loBVkJtw91vN67WErrTEquIS+rx/PTErGaaXqCKCM6kvPb3hjmgJbXU3HL/nGS+hiJ4mfEjzfCJJ9bEovCvTJhbJkPha4xwLArxn2eOEFGhxsGELgOKSbNtzv3pMGqEhW9yseguyPX7EZHevUrkRpneMgP2n2UDdw39XcdW6vzATX8NLPL7TBWtSb57P4rEWKoWGPFuwB1CEXbQ7roJcroFtD5+Nk4SqMh53MaGeOQLtJ6MrRrP64/xnPCL5QnGFMszuJxaAEIv6TVQFB4CwotO4S/WZ49BmZgnTyBV3ZgXV6N6kH0llYOrkDTqPfMARHY33HQBY25e/qeTcx4UqnU8JifjXChV8nU10xxIO+B99T1TnTTs8jHAFg9leYSje3g4KxpAzHzUN2KzAyVR0GQTsLOA1JwnwPDzVjzvmSMWisBoQMoiF/5FhGgtIoCPQHMW
 HpHi6JWl
 BIfQ2NEk16F4JOdS1h0JoA/i6wGkV9rl/vPPo5lroaYCcMe/MngyCtsdAKx8SqZqs7Wx876psnDD1bUrLoVkTEnCTLxhEL4IkdbLVqsJXrmujcceLvi5ethqrE0GNHia7nsti+GHRi6gxi4JHSyc90Qbp8eU6mveYOHLjIrE4DuNMFcKtAmPZ4t+yGV6Ad11KdT61qRJWLBjxDGXaYCjiAw19pSUew1vIAiWCAAP/8uXKn/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
> sheaves enabled. Since we want to enable them for almost all caches,
> it's suboptimal to test the pointer in the fast paths, so instead
> allocate it for all caches in do_kmem_cache_create(). Instead of testing
> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
> kmem_cache->sheaf_capacity for being 0, where needed, using a new
> cache_has_sheaves() helper.
>
> However, for the fast paths sake we also assume that the main sheaf
> always exists (pcs->main is !NULL), and during bootstrap we cannot
> allocate sheaves yet.
>
> Solve this by introducing a single static bootstrap_sheaf that's
> assigned as pcs->main during bootstrap. It has a size of 0, so during
> allocations, the fast path will find it's empty. Since the size of 0
> matches sheaf_capacity of 0, the freeing fast paths will find it's
> "full". In the slow path handlers, we use cache_has_sheaves() to
> recognize that the cache doesn't (yet) have real sheaves, and fall back.

I don't think kmem_cache_prefill_sheaf() handles this case, does it?
Or do you rely on the caller to never try prefilling a bootstrapped
sheaf?
kmem_cache_refill_sheaf() and kmem_cache_return_sheaf() operate on a
sheaf obtained by calling kmem_cache_prefill_sheaf(), so if
kmem_cache_prefill_sheaf() never returns a bootstrapped sheaf we don't
need special handling there.

> Thus sharing the single bootstrap sheaf like this for multiple caches
> and cpus is safe.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 119 ++++++++++++++++++++++++++++++++++++++++++--------------=
------
>  1 file changed, 81 insertions(+), 38 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index edf341c87e20..706cb6398f05 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -501,6 +501,18 @@ struct kmem_cache_node {
>         struct node_barn *barn;
>  };
>
> +/*
> + * Every cache has !NULL s->cpu_sheaves but they may point to the
> + * bootstrap_sheaf temporarily during init, or permanently for the boot =
caches
> + * and caches with debugging enabled, or all caches with CONFIG_SLUB_TIN=
Y. This
> + * helper distinguishes whether cache has real non-bootstrap sheaves.
> + */
> +static inline bool cache_has_sheaves(struct kmem_cache *s)
> +{
> +       /* Test CONFIG_SLUB_TINY for code elimination purposes */
> +       return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
> +}
> +
>  static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int=
 node)
>  {
>         return s->node[node];
> @@ -2855,6 +2867,10 @@ static void pcs_destroy(struct kmem_cache *s)
>                 if (!pcs->main)
>                         continue;
>
> +               /* bootstrap or debug caches, it's the bootstrap_sheaf */
> +               if (!pcs->main->cache)
> +                       continue;

I wonder why we can't simply check cache_has_sheaves(s) at the
beginning and skip the loop altogether.
I realize that __kmem_cache_release()->pcs_destroy() is called in the
failure path of do_kmem_cache_create() and s->cpu_sheaves might be
partially initialized if alloc_empty_sheaf() fails somewhere in the
middle of the loop inside init_percpu_sheaves(). But for that,
s->sheaf_capacity should still be non-zero, so checking
cache_has_sheaves() at the beginning of pcs_destroy() should still
work, no?

BTW, I see one last check for s->cpu_sheaves that you didn't replace
with cache_has_sheaves() inside __kmem_cache_release(). I think that's
because it's also in the failure path of do_kmem_cache_create() and
it's possible that s->sheaf_capacity > 0 while s->cpu_sheaves =3D=3D NULL
(if alloc_percpu(struct slub_percpu_sheaves) fails). It might be
helpful to add a comment inside __kmem_cache_release() to explain why
cache_has_sheaves() can't be used there.

> +
>                 /*
>                  * We have already passed __kmem_cache_shutdown() so ever=
ything
>                  * was flushed and there should be no objects allocated f=
rom
> @@ -4030,7 +4046,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache=
 *s)
>  {
>         struct slub_percpu_sheaves *pcs;
>
> -       if (!s->cpu_sheaves)
> +       if (!cache_has_sheaves(s))
>                 return false;
>
>         pcs =3D per_cpu_ptr(s->cpu_sheaves, cpu);
> @@ -4052,7 +4068,7 @@ static void flush_cpu_slab(struct work_struct *w)
>
>         s =3D sfw->s;
>
> -       if (s->cpu_sheaves)
> +       if (cache_has_sheaves(s))
>                 pcs_flush_all(s);
>
>         flush_this_cpu_slab(s);
> @@ -4157,7 +4173,7 @@ void flush_all_rcu_sheaves(void)
>         mutex_lock(&slab_mutex);
>
>         list_for_each_entry(s, &slab_caches, list) {
> -               if (!s->cpu_sheaves)
> +               if (!cache_has_sheaves(s))
>                         continue;
>                 flush_rcu_sheaves_on_cache(s);
>         }
> @@ -4179,7 +4195,7 @@ static int slub_cpu_dead(unsigned int cpu)
>         mutex_lock(&slab_mutex);
>         list_for_each_entry(s, &slab_caches, list) {
>                 __flush_cpu_slab(s, cpu);
> -               if (s->cpu_sheaves)
> +               if (cache_has_sheaves(s))
>                         __pcs_flush_all_cpu(s, cpu);
>         }
>         mutex_unlock(&slab_mutex);
> @@ -4979,6 +4995,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, str=
uct slub_percpu_sheaves *pcs,
>
>         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>
> +       /* Bootstrap or debug cache, back off */
> +       if (unlikely(!cache_has_sheaves(s))) {
> +               local_unlock(&s->cpu_sheaves->lock);
> +               return NULL;
> +       }
> +
>         if (pcs->spare && pcs->spare->size > 0) {
>                 swap(pcs->main, pcs->spare);
>                 return pcs;
> @@ -5165,6 +5187,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache=
 *s, size_t size, void **p)
>                 struct slab_sheaf *full;
>                 struct node_barn *barn;
>
> +               if (unlikely(!cache_has_sheaves(s))) {
> +                       local_unlock(&s->cpu_sheaves->lock);
> +                       return allocated;
> +               }
> +
>                 if (pcs->spare && pcs->spare->size > 0) {
>                         swap(pcs->main, pcs->spare);
>                         goto do_alloc;
> @@ -5244,8 +5271,7 @@ static __fastpath_inline void *slab_alloc_node(stru=
ct kmem_cache *s, struct list
>         if (unlikely(object))
>                 goto out;
>
> -       if (s->cpu_sheaves)
> -               object =3D alloc_from_pcs(s, gfpflags, node);
> +       object =3D alloc_from_pcs(s, gfpflags, node);
>
>         if (!object)
>                 object =3D __slab_alloc_node(s, gfpflags, node, addr, ori=
g_size);
> @@ -5355,17 +5381,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp=
_t gfp, unsigned int size)
>
>         if (unlikely(size > s->sheaf_capacity)) {
>
> -               /*
> -                * slab_debug disables cpu sheaves intentionally so all
> -                * prefilled sheaves become "oversize" and we give up on
> -                * performance for the debugging. Same with SLUB_TINY.
> -                * Creating a cache without sheaves and then requesting a
> -                * prefilled sheaf is however not expected, so warn.
> -                */
> -               WARN_ON_ONCE(s->sheaf_capacity =3D=3D 0 &&
> -                            !IS_ENABLED(CONFIG_SLUB_TINY) &&
> -                            !(s->flags & SLAB_DEBUG_FLAGS));
> -
>                 sheaf =3D kzalloc(struct_size(sheaf, objects, size), gfp)=
;
>                 if (!sheaf)
>                         return NULL;
> @@ -6082,6 +6097,12 @@ __pcs_replace_full_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs)
>  restart:
>         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>
> +       /* Bootstrap or debug cache, back off */
> +       if (unlikely(!cache_has_sheaves(s))) {
> +               local_unlock(&s->cpu_sheaves->lock);
> +               return NULL;
> +       }
> +
>         barn =3D get_barn(s);
>         if (!barn) {
>                 local_unlock(&s->cpu_sheaves->lock);
> @@ -6280,6 +6301,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void =
*obj)
>                 struct slab_sheaf *empty;
>                 struct node_barn *barn;
>
> +               /* Bootstrap or debug cache, fall back */
> +               if (unlikely(!cache_has_sheaves(s))) {
> +                       local_unlock(&s->cpu_sheaves->lock);
> +                       goto fail;
> +               }
> +
>                 if (pcs->spare && pcs->spare->size =3D=3D 0) {
>                         pcs->rcu_free =3D pcs->spare;
>                         pcs->spare =3D NULL;
> @@ -6674,9 +6701,8 @@ void slab_free(struct kmem_cache *s, struct slab *s=
lab, void *object,
>         if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s)=
, false)))
>                 return;
>
> -       if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
> -                                    slab_nid(slab) =3D=3D numa_mem_id())
> -                          && likely(!slab_test_pfmemalloc(slab))) {
> +       if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa=
_mem_id())
> +           && likely(!slab_test_pfmemalloc(slab))) {
>                 if (likely(free_to_pcs(s, object)))
>                         return;
>         }
> @@ -7379,7 +7405,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, siz=
e_t size, void **p)
>          * freeing to sheaves is so incompatible with the detached freeli=
st so
>          * once we go that way, we have to do everything differently
>          */
> -       if (s && s->cpu_sheaves) {
> +       if (s && cache_has_sheaves(s)) {
>                 free_to_pcs_bulk(s, size, p);
>                 return;
>         }
> @@ -7490,8 +7516,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache =
*s, gfp_t flags, size_t size,
>                 size--;
>         }
>
> -       if (s->cpu_sheaves)
> -               i =3D alloc_from_pcs_bulk(s, size, p);
> +       i =3D alloc_from_pcs_bulk(s, size, p);

Doesn't the above change make this fastpath a bit longer? IIUC,
instead of bailing out right here we call alloc_from_pcs_bulk() and
bail out from there because pcs->main->size is 0.

>
>         if (i < size) {
>                 /*
> @@ -7702,6 +7727,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem=
_cache *s)
>
>  static int init_percpu_sheaves(struct kmem_cache *s)
>  {
> +       static struct slab_sheaf bootstrap_sheaf =3D {};
>         int cpu;
>
>         for_each_possible_cpu(cpu) {
> @@ -7711,7 +7737,28 @@ static int init_percpu_sheaves(struct kmem_cache *=
s)
>
>                 local_trylock_init(&pcs->lock);
>
> -               pcs->main =3D alloc_empty_sheaf(s, GFP_KERNEL);
> +               /*
> +                * Bootstrap sheaf has zero size so fast-path allocation =
fails.
> +                * It has also size =3D=3D s->sheaf_capacity, so fast-pat=
h free
> +                * fails. In the slow paths we recognize the situation by
> +                * checking s->sheaf_capacity. This allows fast paths to =
assume
> +                * s->cpu_sheaves and pcs->main always exists and is vali=
d.

s/is/are

> +                * It's also safe to share the single static bootstrap_sh=
eaf
> +                * with zero-sized objects array as it's never modified.
> +                *
> +                * bootstrap_sheaf also has NULL pointer to kmem_cache so=
 we
> +                * recognize it and not attempt to free it when destroyin=
g the
> +                * cache

missing a period at the end of the above sentence.

> +                *
> +                * We keep bootstrap_sheaf for kmem_cache and kmem_cache_=
node,
> +                * caches with debug enabled, and all caches with SLUB_TI=
NY.
> +                * For kmalloc caches it's used temporarily during the in=
itial
> +                * bootstrap.
> +                */
> +               if (!s->sheaf_capacity)
> +                       pcs->main =3D &bootstrap_sheaf;
> +               else
> +                       pcs->main =3D alloc_empty_sheaf(s, GFP_KERNEL);
>
>                 if (!pcs->main)
>                         return -ENOMEM;
> @@ -7809,7 +7856,7 @@ static int init_kmem_cache_nodes(struct kmem_cache =
*s)
>                         continue;
>                 }
>
> -               if (s->cpu_sheaves) {
> +               if (cache_has_sheaves(s)) {
>                         barn =3D kmalloc_node(sizeof(*barn), GFP_KERNEL, =
node);
>
>                         if (!barn)
> @@ -8127,7 +8174,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>         flush_all_cpus_locked(s);
>
>         /* we might have rcu sheaves in flight */
> -       if (s->cpu_sheaves)
> +       if (cache_has_sheaves(s))
>                 rcu_barrier();
>
>         /* Attempt to free all objects */
> @@ -8439,7 +8486,7 @@ static int slab_mem_going_online_callback(int nid)
>                 if (get_node(s, nid))
>                         continue;
>
> -               if (s->cpu_sheaves) {
> +               if (cache_has_sheaves(s)) {
>                         barn =3D kmalloc_node(sizeof(*barn), GFP_KERNEL, =
nid);
>
>                         if (!barn) {
> @@ -8647,12 +8694,10 @@ int do_kmem_cache_create(struct kmem_cache *s, co=
nst char *name,
>
>         set_cpu_partial(s);
>
> -       if (s->sheaf_capacity) {
> -               s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_sheave=
s);
> -               if (!s->cpu_sheaves) {
> -                       err =3D -ENOMEM;
> -                       goto out;
> -               }
> +       s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_sheaves);
> +       if (!s->cpu_sheaves) {
> +               err =3D -ENOMEM;
> +               goto out;
>         }
>
>  #ifdef CONFIG_NUMA
> @@ -8671,11 +8716,9 @@ int do_kmem_cache_create(struct kmem_cache *s, con=
st char *name,
>         if (!alloc_kmem_cache_cpus(s))
>                 goto out;
>
> -       if (s->cpu_sheaves) {
> -               err =3D init_percpu_sheaves(s);
> -               if (err)
> -                       goto out;
> -       }
> +       err =3D init_percpu_sheaves(s);
> +       if (err)
> +               goto out;
>
>         err =3D 0;
>
>
> --
> 2.52.0
>


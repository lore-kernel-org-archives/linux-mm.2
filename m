Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67493D2A54F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8726B0011; Thu,  4 Dec 2025 17:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958B56B0012; Thu,  4 Dec 2025 17:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847A56B00A0; Thu,  4 Dec 2025 17:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6E96B0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:05:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 071E85199B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:05:22 +0000 (UTC)
X-FDA: 84183170484.06.EA57992
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 00FCA8000F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:05:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=td0S35eY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764885920; a=rsa-sha256;
	cv=none;
	b=JjHwbon3hfMLCWxXaGRoQXmxZD91QJboC1s4OYJNn1i4XHl3E7qjPoPrvt/u+OyplWZMWA
	/bDI0rmB+9x1WyIlBa9yBZGxSlq1XaZjHUJ0eDiueKM4kkifB9jS04M/r3W9DyuZWQboVv
	oa+y09L0x7Iz4HmLtFQ9QjesJ4HdrdA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=td0S35eY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764885920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlMojaibJswZ58Md6lSPxnF32xXnO1Wd7Xx7hEEyCgs=;
	b=ZaS7m7KHSa0gXkBgNCsU91rYqK9jHp6WBbHV9FpKsLyKxHUVO6c3+oa4uy8XTGWgbgfn1V
	ruUkOoQ1YsDFZRvNziUCDTM9GAdewfVy+d/pG9T9SetqxHAv4Q9huiGWrnMfrDOnBTCkms
	kMfPYKKMlo3PXZzl9PV2oriDxT0Dg60=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edb8d6e98aso164981cf.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 14:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764885919; x=1765490719; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlMojaibJswZ58Md6lSPxnF32xXnO1Wd7Xx7hEEyCgs=;
        b=td0S35eYW8/om8pDRl+VazAWIuU+ZJB7ScNPOcf0086AyM6oRtYbnZJ5gKaNv6KfYd
         vWxk9pSyB5Rfd16w7IJRccwWM/AXPhyTgDmE1HNmzcp7ZFeYCF/Wsc+a87MbNbU9OXEX
         CuNIVfcQMEga//ibDAck8rizLpvtxxEXFagAJgSXCFLUgiUjCVxuLxUETLVKIRZsp+CK
         rwpw1HFWL+LupM2ZO4YUX95tEf2Yfc390G0orwFBqBdz078I7y84wTywpn1gLflo0Dd5
         5QL8Kgy2vr6hpZhhdnMrf9kMB+uatsDp63JDiWJOMBsC+H6adCwQKF2g0jwovOK8fTX8
         FLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764885919; x=1765490719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BlMojaibJswZ58Md6lSPxnF32xXnO1Wd7Xx7hEEyCgs=;
        b=ssy72MRTIKKhSE66E4V7nw+68DZYSzsZg3+uQNaRY4SSelH0PoNffPguhKhahrtqBZ
         SGLrUIJoDGB3a/nxRygKKcluseYzl5H02uH0g5/Yo+8SKJQ1PKvBrDaUOj6c1bjyt6xp
         E4wfU9QcXxfqtFCqLWyUHwoDxKhupXMlSnYJr755m6I08zIdjK880oze+gjaQtYPBXzD
         rlldWUrWLFp9sIVVJnu61Yq2d2XUILTlL6Ybt/GaiV4p5rAdZbnW0/1yn4BnYTELAJfU
         Saoxh0EeeygwWDgLIXPrwJU+RGWuwSpl6KWEmit7qnj3mj5F/KnTGISUMupB7KxTgj02
         WWvw==
X-Forwarded-Encrypted: i=1; AJvYcCXFRlXu3WH6oPVxLWrtdsHSGBRvxEzUQktbJCDn9c9waLE8k+UVnri0wtbND07yd9R4d51l3swRpg==@kvack.org
X-Gm-Message-State: AOJu0Yzv+3tv0uqTtQ0SVez1AbkCsjZIcg690sXea3vkBovsh80MDFdS
	iiIF7SN86ZQGplNoHUlXijhOKxuLZ8gV3lW1jpmjgAHPluw7uyMcnyKKvMF5ZCzUqg5m23mZXv8
	nJ1xY3vK327+/AhjHHWwXbaVtqj2LVT6gLvgHaC4I
X-Gm-Gg: ASbGnctTUpdoTrab673CH9ictaKAV+v38aM0K5CApPYgZpgz5hZ9DLHGSxVevjt86fq
	EkX3bThx6Nj76D+nzLYq5AXsQ+haVr4oKl7rhQoyrAH3lj4FCJX133Ed5H6Ks6HhUEkpZlOibfa
	eqBXmANRp7UOLTpcRJA+nTrRd26mHOZ9yQGlR/rbhrHIXfmxGSoxq878mXBODeeiEb5MsLABWim
	tZwBXKwQ2HKnzJNMFTqqEY0YJvHLNA+cBz3M813x/5wBZbdNMFAgcb7cOqSk2ViRdc3hLhh120K
	AgPv4u5jvGPZUj+XR9ryCd6MGg==
X-Google-Smtp-Source: AGHT+IFPNi1Qq6VnpviOUxpKZr81dFMcXNcb6T+4p6OQ/SGAOQNaW0ByA8FKshNAIkMbBHJmIRv/I4XWmKWNYD2+UjQ=
X-Received: by 2002:a05:622a:11c7:b0:4b7:9c77:6ba5 with SMTP id
 d75a77b69052e-4f0328c27f7mr986761cf.15.1764885918541; Thu, 04 Dec 2025
 14:05:18 -0800 (PST)
MIME-Version: 1.0
References: <20251202101626.783736-1-harry.yoo@oracle.com>
In-Reply-To: <20251202101626.783736-1-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 4 Dec 2025 14:05:07 -0800
X-Gm-Features: AQt7F2p0K1ADlvbRPKyMu031QLfpqGn6xZ7XRfN7KMrquLJSUSvofoLyz0mVl2M
Message-ID: <CAJuCfpE+g65Dm8-r=psDJQf_O1rfBG62DOzx4mE1mb+ottUKmQ@mail.gmail.com>
Subject: Re: [PATCH V2] mm/slab: introduce kvfree_rcu_barrier_on_cache() for
 cache destruction
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, Liam.Howlett@oracle.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, urezki@gmail.com, 
	sidhartha.kumar@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-modules@vger.kernel.org, mcgrof@kernel.org, petr.pavlu@suse.com, 
	samitolvanen@google.com, atomlin@atomlin.com, lucas.demarchi@intel.com, 
	akpm@linux-foundation.org, jonathanh@nvidia.com, stable@vger.kernel.org, 
	Daniel Gomez <da.gomez@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00FCA8000F
X-Stat-Signature: hh7xgm4y1kz18iej9pg8mp5efyc8muxs
X-Rspam-User: 
X-HE-Tag: 1764885919-423831
X-HE-Meta: U2FsdGVkX19gOqfesFymYPuDIJNs/aIuJMggiApBVv3oDUhKdY8U3Ro4/Q28Ibx+rNl9U3FKiSe6A0wuDxIVB1FFViOokAo4HL6perH/BoERAlBnlrKGJBptjldTnfy5RouHL/CkLVsp9joR+dDzrHogU0fAS+i2yI26NNOIltZoYbmrAkDCPuXLgCyeCvWR8IUeB9H4hoohsTSAOs85Ac5nDd3HKx/muiOYI11bqEthZmiX0nbHB24ebKzTPEXsqMso3qbaoVaFcjMqf2QdSkTdE+kWnuTtWJCsyuJigYvN7YNFSBQketvXk+O/iNInHJeGKaWmvXIdM61/kB8vMUtb3kNvzygyZUdZiaiFxm+UMfAH0zlUwm5lOwvJhFoB+o6jc2hI/f/E1xvjV+Yl3LtXqLFEbIbbCOpnQWLATf8kSomE1MIRiPAtHd/rQut0Q2PF3ienHw0VF1fb5V71Lx+NiMBT2zLQF7zYFHGeEGrkpTnrKMgj4hmk6DnC7OBAHarkmuas7j36EIPf+ARuo4QcK+aYiY4aheOY919rbGUqc4ANLM7Puj+iFimWQzIET9OcVS8taE9+wF8jmiYyck7g2N4enamGmgt3lbTRz3lu4M/rdacf453KQ8YByQ3ZJ2ndQ3QVd1AoGDfpPr9a70qxA2F7+mJSYFbjppcyRlvwxmMwpfTmCXh2IlXoC9HDg1pLMFhYDgWARtIVynf976AnawPqFnEf/Orc8aPt9hdBH/Jht+WI7/97hLUY4Ny/tP9Iur8ZgnsmHHjyBOjWknORDhjLa8YEc7tZ5naDQyOi+tog73WiMywHOxN6LdVcHgUhvuxr878XFgOMfDFS+My90rm9bU+28W0VImDPxwL+q/bGewjwgzS5/f/mJTtA1XxPCqk5ceg7UaGxX+43SgjpInhL5ZXSxAIa8enA9iPGOSGE/4eky6/9O7/FKlYu2dPqXm+jLkTY0dRo5US
 KiSE8f+t
 GwE/LoQB5COp5rou6c7xRhTDnKJlRwv/Tu9YntHo3IXKFN9lRBpq1VvmlXDqSU1fOFJLwsyv3F/AEaYiYCDIneKvXdPX6nMW47739lVeA8OwYP4wmuOJjpHAx1LhWyZvp2fQRjulf8P/IwgslAZeFqPRROZ6HhDbjvEKoXTHhiv4o0ssNJ+cl5+WQ3Eqoj+bcEEtZmV2eob41WsCi7gqIvKy0ol8fAChOsyO6k411u9IGK+PaQ+aKqNhIhfV/Z2EtvhW/kjcvRX62agup6wBYErUks3XkpMPSB3MbJgNlWZRCfug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 2:16=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wro=
te:
>
> Currently, kvfree_rcu_barrier() flushes RCU sheaves across all slab
> caches when a cache is destroyed. This is unnecessary; only the RCU
> sheaves belonging to the cache being destroyed need to be flushed.
>
> As suggested by Vlastimil Babka, introduce a weaker form of
> kvfree_rcu_barrier() that operates on a specific slab cache.
>
> Factor out flush_rcu_sheaves_on_cache() from flush_all_rcu_sheaves() and
> call it from flush_all_rcu_sheaves() and kvfree_rcu_barrier_on_cache().
>
> Call kvfree_rcu_barrier_on_cache() instead of kvfree_rcu_barrier() on
> cache destruction.
>
> The performance benefit is evaluated on a 12 core 24 threads AMD Ryzen
> 5900X machine (1 socket), by loading slub_kunit module.
>
> Before:
>   Total calls: 19
>   Average latency (us): 18127
>   Total time (us): 344414
>
> After:
>   Total calls: 19
>   Average latency (us): 10066
>   Total time (us): 191264
>
> Two performance regression have been reported:
>   - stress module loader test's runtime increases by 50-60% (Daniel)
>   - internal graphics test's runtime on Tegra23 increases by 35% (Jon)
>
> They are fixed by this change.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() op=
erations")
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/linux-mm/1bda09da-93be-4737-aef0-d47f8c5c93=
01@suse.cz
> Reported-and-tested-by: Daniel Gomez <da.gomez@samsung.com>
> Closes: https://lore.kernel.org/linux-mm/0406562e-2066-4cf8-9902-b2b0616d=
d742@kernel.org
> Reported-and-tested-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/linux-mm/e988eff6-1287-425e-a06c-805af5bb=
f262@nvidia.com
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
> No code change, added proper tags and updated changelog.
>
>  include/linux/slab.h |  5 ++++
>  mm/slab.h            |  1 +
>  mm/slab_common.c     | 52 +++++++++++++++++++++++++++++------------
>  mm/slub.c            | 55 ++++++++++++++++++++++++--------------------
>  4 files changed, 73 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index cf443f064a66..937c93d44e8c 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1149,6 +1149,10 @@ static inline void kvfree_rcu_barrier(void)
>  {
>         rcu_barrier();
>  }
> +static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
> +{
> +       rcu_barrier();
> +}
>
>  static inline void kfree_rcu_scheduler_running(void) { }
>  #else
> @@ -1156,6 +1160,7 @@ void kvfree_rcu_barrier(void);
>
>  void kfree_rcu_scheduler_running(void);
>  #endif
> +void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);

Should the above line be before the #endif? I was expecting something like =
this:

#ifndef CONFIG_KVFREE_RCU_BATCHED
...
static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
{
    rcu_barrier();
}
#else
...
void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);
#endif

but when I apply this patch on mm-new I get this:

#ifndef CONFIG_KVFREE_RCU_BATCHED
...
static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
{
    rcu_barrier();
}
#else
...
#endif
void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);

Other than that LGTM

>
>  /**
>   * kmalloc_size_roundup - Report allocation bucket size for the given si=
ze
> diff --git a/mm/slab.h b/mm/slab.h
> index f730e012553c..e767aa7e91b0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -422,6 +422,7 @@ static inline bool is_kmalloc_normal(struct kmem_cach=
e *s)
>
>  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
>  void flush_all_rcu_sheaves(void);
> +void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
>                          SLAB_CACHE_DMA32 | SLAB_PANIC | \
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 84dfff4f7b1f..dd8a49d6f9cc 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -492,7 +492,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>                 return;
>
>         /* in-flight kfree_rcu()'s may include objects from our cache */
> -       kvfree_rcu_barrier();
> +       kvfree_rcu_barrier_on_cache(s);
>
>         if (IS_ENABLED(CONFIG_SLUB_RCU_DEBUG) &&
>             (s->flags & SLAB_TYPESAFE_BY_RCU)) {
> @@ -2038,25 +2038,13 @@ void kvfree_call_rcu(struct rcu_head *head, void =
*ptr)
>  }
>  EXPORT_SYMBOL_GPL(kvfree_call_rcu);
>
> -/**
> - * kvfree_rcu_barrier - Wait until all in-flight kvfree_rcu() complete.
> - *
> - * Note that a single argument of kvfree_rcu() call has a slow path that
> - * triggers synchronize_rcu() following by freeing a pointer. It is done
> - * before the return from the function. Therefore for any single-argumen=
t
> - * call that will result in a kfree() to a cache that is to be destroyed
> - * during module exit, it is developer's responsibility to ensure that a=
ll
> - * such calls have returned before the call to kmem_cache_destroy().
> - */
> -void kvfree_rcu_barrier(void)
> +static inline void __kvfree_rcu_barrier(void)
>  {
>         struct kfree_rcu_cpu_work *krwp;
>         struct kfree_rcu_cpu *krcp;
>         bool queued;
>         int i, cpu;
>
> -       flush_all_rcu_sheaves();
> -
>         /*
>          * Firstly we detach objects and queue them over an RCU-batch
>          * for all CPUs. Finally queued works are flushed for each CPU.
> @@ -2118,8 +2106,43 @@ void kvfree_rcu_barrier(void)
>                 }
>         }
>  }
> +
> +/**
> + * kvfree_rcu_barrier - Wait until all in-flight kvfree_rcu() complete.
> + *
> + * Note that a single argument of kvfree_rcu() call has a slow path that
> + * triggers synchronize_rcu() following by freeing a pointer. It is done
> + * before the return from the function. Therefore for any single-argumen=
t
> + * call that will result in a kfree() to a cache that is to be destroyed
> + * during module exit, it is developer's responsibility to ensure that a=
ll
> + * such calls have returned before the call to kmem_cache_destroy().
> + */
> +void kvfree_rcu_barrier(void)
> +{
> +       flush_all_rcu_sheaves();
> +       __kvfree_rcu_barrier();
> +}
>  EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>
> +/**
> + * kvfree_rcu_barrier_on_cache - Wait for in-flight kvfree_rcu() calls o=
n a
> + *                               specific slab cache.
> + * @s: slab cache to wait for
> + *
> + * See the description of kvfree_rcu_barrier() for details.
> + */
> +void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
> +{
> +       if (s->cpu_sheaves)
> +               flush_rcu_sheaves_on_cache(s);
> +       /*
> +        * TODO: Introduce a version of __kvfree_rcu_barrier() that works
> +        * on a specific slab cache.
> +        */
> +       __kvfree_rcu_barrier();
> +}
> +EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> +
>  static unsigned long
>  kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *s=
c)
>  {
> @@ -2215,4 +2238,3 @@ void __init kvfree_rcu_init(void)
>  }
>
>  #endif /* CONFIG_KVFREE_RCU_BATCHED */
> -
> diff --git a/mm/slub.c b/mm/slub.c
> index 785e25a14999..7cec2220712b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4118,42 +4118,47 @@ static void flush_rcu_sheaf(struct work_struct *w=
)
>
>
>  /* needed for kvfree_rcu_barrier() */
> -void flush_all_rcu_sheaves(void)
> +void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
>  {
>         struct slub_flush_work *sfw;
> -       struct kmem_cache *s;
>         unsigned int cpu;
>
> -       cpus_read_lock();
> -       mutex_lock(&slab_mutex);
> +       mutex_lock(&flush_lock);
>
> -       list_for_each_entry(s, &slab_caches, list) {
> -               if (!s->cpu_sheaves)
> -                       continue;
> +       for_each_online_cpu(cpu) {
> +               sfw =3D &per_cpu(slub_flush, cpu);
>
> -               mutex_lock(&flush_lock);
> +               /*
> +                * we don't check if rcu_free sheaf exists - racing
> +                * __kfree_rcu_sheaf() might have just removed it.
> +                * by executing flush_rcu_sheaf() on the cpu we make
> +                * sure the __kfree_rcu_sheaf() finished its call_rcu()
> +                */
>
> -               for_each_online_cpu(cpu) {
> -                       sfw =3D &per_cpu(slub_flush, cpu);
> +               INIT_WORK(&sfw->work, flush_rcu_sheaf);
> +               sfw->s =3D s;
> +               queue_work_on(cpu, flushwq, &sfw->work);
> +       }
>
> -                       /*
> -                        * we don't check if rcu_free sheaf exists - raci=
ng
> -                        * __kfree_rcu_sheaf() might have just removed it=
.
> -                        * by executing flush_rcu_sheaf() on the cpu we m=
ake
> -                        * sure the __kfree_rcu_sheaf() finished its call=
_rcu()
> -                        */
> +       for_each_online_cpu(cpu) {
> +               sfw =3D &per_cpu(slub_flush, cpu);
> +               flush_work(&sfw->work);
> +       }
>
> -                       INIT_WORK(&sfw->work, flush_rcu_sheaf);
> -                       sfw->s =3D s;
> -                       queue_work_on(cpu, flushwq, &sfw->work);
> -               }
> +       mutex_unlock(&flush_lock);
> +}
>
> -               for_each_online_cpu(cpu) {
> -                       sfw =3D &per_cpu(slub_flush, cpu);
> -                       flush_work(&sfw->work);
> -               }
> +void flush_all_rcu_sheaves(void)
> +{
> +       struct kmem_cache *s;
> +
> +       cpus_read_lock();
> +       mutex_lock(&slab_mutex);
>
> -               mutex_unlock(&flush_lock);
> +       list_for_each_entry(s, &slab_caches, list) {
> +               if (!s->cpu_sheaves)
> +                       continue;
> +               flush_rcu_sheaves_on_cache(s);
>         }
>
>         mutex_unlock(&slab_mutex);
> --
> 2.43.0
>


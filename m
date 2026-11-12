Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF73606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eHdARFhg
Received: by kanga.kvack.org (Postfix)
	id 6AB646B00EF; Wed, 11 Nov 2026 20:15:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683526B05B0; Wed, 11 Nov 2026 20:15:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572576B05B1; Wed, 11 Nov 2026 20:15:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D69F46B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:15:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5BC9120448
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:15:25 +0000 (UTC)
X-FDA: 85424699010.20.9F5D71A
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7D781C000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:15:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eHdARFhg;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794446123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9a0zqbKXeobEqiLKUEeOvGBAydGpaXNxzwtSlXyYudU=;
	b=MuixvKNUSWsMtbBILQrDUkJqzgCBsYZ01SIHp23ZYIrLzmO+oaGzM0s/kaFQQT9ZA7rtcP
	Le3ec0ib1sWs4x0+brQTIVqpm9aXdG4FdOZ/09myzjIk0WA94lXgidCMqk5dsJsyrhZZIc
	WadJjITGB/9patznWqFKR8LlV/tXj7w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794446123;
	b=6c8HFowR+6FHYHgF9W5tRx0P5QKhaeT+OhuUyWCExMaAq37Ajv2rFAOBLjuIYqjdXW4y4Y
	9gHLZK1f6nWq0uFjA1KbnzmXeahCyibNpw1V0t7jp9pDuO/cHCFOdIQ/RlRIlRC+zdnqje
	SKEcmA7shR/coMJ4wiaTo8gFs5gUFO4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eHdARFhg;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-535f598d126so53531cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:15:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794446123; cv=none;
        d=google.com; s=arc-20260327;
        b=YC+lTbdO6OadVYK10FmWd5h0vVYaup0nNwOkhNXqoB8hreTR7n9KbWNReHiLsolEyK
         TEDX97SjwQVwoJPiv4LQX4coALj2LpZS2We1UBwxoBvSZa7jKoy4l0+KVI8KYFgKDtBQ
         hW2qZOesHzk7hL0y1nCp3ZnrY1AbaIuYwyoxyLB0n4mJq5MHM1uS+f3J/ZbRjNYmb3gy
         zf5J5hAd23hvAA8v2Nz8OwX49IQwNBVYvBk6VgJxm//boQutrEeFjqeiiaZg8oEDCNqK
         ZBBAPjnNofO0kI/9is1EzFAQ61d0ieSCQvHknH3Um/opIUjUBkRyc/2Qq3cPSMbZONFm
         Hiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9a0zqbKXeobEqiLKUEeOvGBAydGpaXNxzwtSlXyYudU=;
        fh=IFPhD8SifZ9EBRlo4zSAuzY/i73x5lKbRFNGxZk7wqs=;
        b=kuBNCSYubsvNc4khDohh3N6PuEe93aMhMCyf2ucZ4kvSFwj+moeEHtj4EevrtJCDWW
         t+pWl/RI9xkOYh+oM7Fs8iKCjn4JnjbG0kHiLim2L64i+cUrT/QCbkao+gNOCaO4yrK8
         QjAPZVaoirC8byxsFj4iom8+uUus1dQid4ZipAaP4jcVr5TUSU1unyLEUnrkn6L7qsSG
         ySxknmPhcP2ulW/f2nX9N8dOYWrg/xk/+Bmc7dME9CgA+q3JLPpkVBL0FSyMPOxeLUmi
         uSdS+bIMAkiNybnpsOIngd+7TCDaYTh87t9HqlPaTNHGXBCpAkCde/Cp0M6Xnu0FE/Mx
         dM/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794446123; x=1795050923; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9a0zqbKXeobEqiLKUEeOvGBAydGpaXNxzwtSlXyYudU=;
        b=eHdARFhg/nYDHAzA0wOuDLpLdCyOMp+mvqRRtS45/VKzMpfPGYL4SiN5lyC6NyXmmw
         YwFFiRcjrCOlRFTHyGJqGx1rUM/Yj2L0/bIbhRVdRiTPvitjqbMMXt53X3zsT0qd5/QF
         MMWSOCheS7wcA7obLebSZvPcrmqZvWyX6A/ITpmLHI6Rs55qrOdBC1zpL42w1BE26Z5/
         QEefVm5myTfvTfE8oBm3obT+hQDJn9aP81k2ywMg5lgVvk83/edNa9pWWZn76aRNEIWC
         gtdrH5dcxl6fc7yd2iIQ8MJFa93lBfRKMaazwSm4197QGP9ATgIPb9u+OmcqiBvQQlar
         ogyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794446123; x=1795050923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9a0zqbKXeobEqiLKUEeOvGBAydGpaXNxzwtSlXyYudU=;
        b=Isy/jcC8IjRY2MXSsYS9DENmAOtgQBx4HhxTBBpT5kMdyAXVieqblg17oGWdPtEu5B
         xGC8wSvrFwR6ulEBPsnp7JfLChIXpkKgPm1OIK9qKlI0smvcHft0gHYLYmR6fAVyz0IB
         CW7tfxxyrMPsyZqolyCv+WK+HpYQTdRZNEQmtWLEjNsQc/MXqF7SjWll+pyE/nEj8wHP
         b4FriZJ5JYma7qum/f4qowtXkw5UmpZ2r9ExASYj7WZw4xBriMYmG6zmC2KoIBUoTBX0
         FvWEEhWQNbf+cw2w+7BDomA+jEFfT78//Y6JAGthB6vl2621cjrDQ7E2h7HOxnnhOwRo
         60qA==
X-Forwarded-Encrypted: i=1; AL+hErFZsOeC/zrQkhp28b3YvIvOvPBH+k8MoSHefki/lgVzepT/K6RS4v8j17RY/KJzHJ0buZHtNpFg2A==@kvack.org
X-Gm-Message-State: APuU4Z8wtvXmsrhHzEMkog7pcQPm8rSr+fPAMepl98YlGn3Fp/hQV1or
	sQ80zL0Gm3OMy5PZ3J1lMtnUDvJmxuY4kAG3EauTr/IgBDTYUgSOwDKrWPFzj5ACJJ3B6k1/+md
	VSs4S6fEftvPLG8W/A1c/JOGeyCvWjBmxv466JYmL
X-Gm-Gg: AYBFou075pGVtq1ttTUbCCC8vLdtwGbshNhWMP243GrXfZX/J7646w/YIhpr7icRmP0
	0S83PCkuRYE06EfZP21rDcG+IyfiBK64AGGkzqqX2wvzHRC7d66IPrYqRUB5A027uLaMZxWWc/G
	VhP1MjN0C9XvzsjqhOocojfv/OrVEFEqkEccbEjnOlVL84Z2wyM49O/9Vswx5dvDyRXfs1YlSjs
	w6syTAwZCYaaDHfF15dgWumOJ54BoVNlxTNgshl+2QFcylXniF1+Kdcx4XiEOFoL80aAnrsOYC7
	+OtBSCKD6CSm4M5yskizmG1UH52jVBisqf1uh7JrYCg3aA1vsWZYYGWva4FY8rM/ak/g3MFaCBt
	nmkA3axXi+jHu6TcFcXrFzHS/PR0vWAQt5fSKkeZe/lD5TYNT+btDnSza4yieha0T3/JNFBoT33
	KlhxsotJGz4TkKLbmT7uRLHDpP
X-Received: by 2002:a05:622a:1e07:b0:536:97c0:dcd0 with SMTP id
 d75a77b69052e-5596dbd7d56mr8576951cf.4.1794446121968; Wed, 11 Nov 2026
 17:15:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-8-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-8-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 01:15:09 +0000
X-Gm-Features: AclHuK-zAC-IeQ8aLVFiwYzq7tLi3yUNydZZveOqio07sklDAsvxkskKKL_OCWU
Message-ID: <CAJuCfpFHaahsCNkXCOn8ks65yj_bPy33cOLZ5BW=rtTOuedLqw@mail.gmail.com>
Subject: Re: [PATCH v4 7/9] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nz79e8eoo4rnptcbh59ff3eptxke17i3
X-Rspamd-Queue-Id: B7D781C000F
X-Rspam-User: 
X-HE-Tag: 1794446123-917568
X-HE-Meta: U2FsdGVkX19yfg/tpGjG2a1Fg5rDrCV6XfIQ4mpRS2YU0Z7hanjefkBxRhWplXS37YUk8PnuPd7fBWg+5XIGkzw+eQyWN4ovlfTKizrj8hXfnmHhTxTWSCjbP/PSF0DbuetFrLI34VVbugOUf91/l5FJymOkkdYUGseNadDjKGpW+OY0ZCPOiaoBpdDcmisrgJJUC05LAnhFoumDIJaUIFLArJL1PYAcw6vyZVd1KS0Zo0tNrgDw8GuWfHciXLwMqeRFKGv1KFz72xpTknVcVWgXkHLsGtAqF3JnECqumMhcxnmjG/8pL/eB9869AJceBZCnT5WzAd9Lp8XdO2x3nykRK8Yb637RY8HzqG2XB9k9K7sQEB6GLpbyTddUyJdH/EvgZlKkGk/0vgTPB18V+Bve6wrd4sOTSjbPri6hIjr6m2vTL6cu+bHXCzEzvFLhSCcrn7yo74ysxUhoMoTHBBq75JJA577rJ6VbN+vfnlIRLW0sy/bcqwPHKLo46IZzzqLQxcvSeLcuIgFFAEKlwVzgitQIfG2u26o4AItl4ACftPX5cDtOyrhKH1t0tcQ1vl0YJWRAQyLkHAPvY3pQmqP+N0my+YL+QycIxHPA/6lXg+XZrMgsX8hOWGqH2KHZZ49iQelBjOa84I31yssaBtK6li84XlgxrnxttWytG/HOqrETyQW1rAWek9zZkWpjin2VUIF9Eu32eWFRHsZLumQLOZKsOd5BqogKgPJkri+5twgyl9JkrciscUgZCHZ6SoS2DOyb1rYyV6kp0e3XykqXAjQAFfuNsSLkW9RVz6vAlwNcD14sxdU+W1T/6AKRswzj0/s9Aoc7MQIv0XfmZ1saDsweXAsf4QbHdT28kFLIuPvNwRzI8grqfLbLCiBLN/sYXuGJBcQ/LFB3c6Rnh47PF1vJcKQEDp2QjZ69IJuOh5hjsLh+HlIhcBhygrSIp8c/HyuWx4cnReXKHkz
 3GzAH8vN
 cLBxkeWcwspDeK19CJOzB7AfSUsUC8eSSiwZgwsMD2t39BPrllg3aBYrMm7EVlCsHw7L3agoZslpbcqsyMyPeKyHTU9zcB412gBsn1kjZ5Fm+FpyrwMLDeOJ6swbY52xqSt//YEJfbi7PhF32prBSmOExn+s2LihvGze24ImLu3ROutolQ/WK3TyyxuyU1keUWw5KblLzbIe7reC1RyEcYTDZqwp9LenWpLdCIJtSdd4HTvNlX6QwyoYQ5CDFl1E0pyWoQW76b7PwLstUQNzpgTaKrjlGIDHVDutb8A+TRSmhSTNw1hzEJelGOPZUNESs8B+PKHyMpbKYbnOe/q77ZLJEJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> The vmap entry points may install some PTEs and then fail, leaving a
> partial mapping behind.
>
> The callers do not agree on who cleans it up. pcpu_map_pages() and
> kmsan_ioremap_page_range() roll back what they mapped, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() expect a clean range from the mapping function.
> For them the leftovers stay mapped, and the next attempt to map the
> same range trips the WARN_ON(!pte_none()) in vmap_pages_pte_range().
> A leftover huge pmd is even worse. During the retry, vmap_try_huge_pmd()
> calls pmd_free_pte_page() on it, and the x86 implementation cannot
> tell a leaf entry from a page table and frees the mapped page.
>
> After discussing with Suren and Ulad, we decided to put the rollback
> into the entry points of the vmap API rather than into every
> low-level helper. __vmap_pages_range_noflush() undoes the whole range
> it was asked to map when it fails, and vmap_page_range() undoes its
> range for the ioremap-style mappings.
>
> The rollback is __vunmap_range_noflush(), which only clears the PTEs.
> No TLB flush is needed, nothing has touched the mapping yet.
> vmap_pages_range_noflush() also drops the KMSAN metadata of the
> failed mapping.
>
> The undo walk skips its cond_resched() when the caller's gfp mask
> cannot block. __vmalloc() with GFP_ATOMIC or GFP_NOWAIT can run in
> atomic context, where cond_resched() cannot schedule.
> __vunmap_range_noflush() takes a can_resched argument for that, which
> the sleepable callers pass as true.
>
> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/linux/kmsan.h |  8 ++++--
>  mm/kmsan/hooks.c      | 18 ++++++++-----
>  mm/kmsan/shadow.c     |  7 ++---
>  mm/vmalloc.c          | 61 +++++++++++++++++++++++++++++++++----------
>  mm/vmalloc.h          |  6 +++--
>  5 files changed, 72 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
> index 7da9fd506b39..0016c032d1e7 100644
> --- a/include/linux/kmsan.h
> +++ b/include/linux/kmsan.h
> @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(uns=
igned long start,
>   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
>   * @start: start of vunmapped range.
>   * @end:   end of vunmapped range.
> + * @can_resched: whether the unmap walk may call cond_resched(); pass
> + * false from atomic context.
>   *
>   * KMSAN unmaps the contiguous metadata ranges created by
>   * kmsan_map_kernel_range_noflush().
>   */
> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
> +                               bool can_resched);
>
>  /**
>   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range(=
) call.
> @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range=
_noflush(
>  }
>
>  static inline void kmsan_vunmap_range_noflush(unsigned long start,
> -                                             unsigned long end)
> +                                             unsigned long end,
> +                                             bool can_resched)
>  {
>  }
>
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index 107f66841274..0cd1edaa1120 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -136,13 +136,16 @@ static unsigned long vmalloc_origin(unsigned long a=
ddr)
>                                                  KMSAN_META_ORIGIN);
>  }
>
> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
> +                               bool can_resched)
>  {
>         if (!kmsan_enabled)
>                 return;
>
> -       __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end)=
);
> -       __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end)=
);
> +       __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end)=
,
> +                              can_resched);
> +       __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end)=
,
> +                              can_resched);
>         flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>         flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>  }
> @@ -171,8 +174,9 @@ static void kmsan_iounmap_pages(unsigned long start, =
unsigned long end)
>                 if (origin)
>                         __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
>         }
> -       __vunmap_range_noflush(shadow_start, shadow_end);
> -       __vunmap_range_noflush(origin_start, origin_end);
> +       /* ioremap metadata mappings are always GFP_KERNEL, so resched is=
 safe. */
> +       __vunmap_range_noflush(shadow_start, shadow_end, true);
> +       __vunmap_range_noflush(origin_start, origin_end, true);
>         flush_tlb_kernel_range(shadow_start, shadow_end);
>         flush_tlb_kernel_range(origin_start, origin_end);
>  }
> @@ -207,7 +211,7 @@ int kmsan_ioremap_page_range(unsigned long start, uns=
igned long end,
>                 mapped =3D __vmap_pages_range_noflush(
>                         vmalloc_shadow(start + off),
>                         vmalloc_shadow(start + off + PAGE_SIZE), prot, &s=
hadow,
> -                       PAGE_SHIFT);
> +                       PAGE_SHIFT, gfp_mask);
>                 if (mapped) {
>                         err =3D mapped;
>                         goto ret;
> @@ -217,7 +221,7 @@ int kmsan_ioremap_page_range(unsigned long start, uns=
igned long end,
>                 mapped =3D __vmap_pages_range_noflush(
>                         vmalloc_origin(start + off),
>                         vmalloc_origin(start + off + PAGE_SIZE), prot, &o=
rigin,
> -                       PAGE_SHIFT);
> +                       PAGE_SHIFT, gfp_mask);
>                 if (mapped) {
>                         err =3D mapped;
>                         goto ret;
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 2166086d3dc3..452760a333e4 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long star=
t, unsigned long end,
>         origin_end =3D vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
>         kmsan_enter_runtime();
>         mapped =3D __vmap_pages_range_noflush(shadow_start, shadow_end, p=
rot,
> -                                           s_pages, page_shift);
> +                                           s_pages, page_shift, gfp_mask=
);
>         kmsan_leave_runtime();
>         if (mapped) {
>                 err =3D mapped;
> @@ -255,12 +255,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long st=
art, unsigned long end,
>         }
>         kmsan_enter_runtime();
>         mapped =3D __vmap_pages_range_noflush(origin_start, origin_end, p=
rot,
> -                                           o_pages, page_shift);
> +                                           o_pages, page_shift, gfp_mask=
);
>         kmsan_leave_runtime();
>         if (mapped) {
>                 /* Undo the shadow mapping set up above. */
>                 kmsan_enter_runtime();
> -               __vunmap_range_noflush(shadow_start, shadow_end);
> +               __vunmap_range_noflush(shadow_start, shadow_end,
> +                                      gfpflags_allow_blocking(gfp_mask))=
;
>                 kmsan_leave_runtime();
>                 err =3D mapped;
>                 goto ret;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3f98056f8c7e..d1986f68eab4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -372,8 +372,12 @@ int vmap_page_range(unsigned long addr, unsigned lon=
g end,
>         if (!err)
>                 err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
>                                                ioremap_max_page_shift);
> -       if (!err)
> +       if (err) {
> +               /* Callers are ioremap and arch setup code, always sleepa=
ble. */
> +               __vunmap_range_noflush(addr, end, true);
> +       } else {
>                 flush_cache_vmap(addr, end);
> +       }
>
>         return err;
>  }
> @@ -429,7 +433,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
>  }
>
>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned lo=
ng end,
> -                            pgtbl_mod_mask *mask)
> +                            pgtbl_mod_mask *mask, bool can_resched)
>  {
>         pmd_t *pmd;
>         unsigned long next;
> @@ -451,12 +455,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned l=
ong addr, unsigned long end,
>                         continue;
>                 vunmap_pte_range(pmd, addr, next, mask);
>
> -               cond_resched();
> +               /* The undo path may run in atomic context. */
> +               if (can_resched)
> +                       cond_resched();
>         } while (pmd++, addr =3D next, addr !=3D end);
>  }
>
>  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned lo=
ng end,
> -                            pgtbl_mod_mask *mask)
> +                            pgtbl_mod_mask *mask, bool can_resched)
>  {
>         pud_t *pud;
>         unsigned long next;
> @@ -476,12 +482,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned l=
ong addr, unsigned long end,
>                 }
>                 if (pud_none_or_clear_bad(pud))
>                         continue;
> -               vunmap_pmd_range(pud, addr, next, mask);
> +               vunmap_pmd_range(pud, addr, next, mask, can_resched);
>         } while (pud++, addr =3D next, addr !=3D end);
>  }
>
>  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned lo=
ng end,
> -                            pgtbl_mod_mask *mask)
> +                            pgtbl_mod_mask *mask, bool can_resched)
>  {
>         p4d_t *p4d;
>         unsigned long next;
> @@ -496,7 +502,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned lon=
g addr, unsigned long end,
>
>                 if (p4d_none_or_clear_bad(p4d))
>                         continue;
> -               vunmap_pud_range(p4d, addr, next, mask);
> +               vunmap_pud_range(p4d, addr, next, mask, can_resched);
>         } while (p4d++, addr =3D next, addr !=3D end);
>  }
>
> @@ -512,7 +518,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned lon=
g addr, unsigned long end,
>   *
>   * This is an internal function only. Do not use outside mm/.
>   */
> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> +                           bool can_resched)
>  {
>         unsigned long next;
>         pgd_t *pgd;
> @@ -529,7 +536,7 @@ void __vunmap_range_noflush(unsigned long start, unsi=
gned long end)
>                         mask |=3D PGTBL_PGD_MODIFIED;
>                 if (pgd_none_or_clear_bad(pgd))
>                         continue;
> -               vunmap_p4d_range(pgd, addr, next, &mask);
> +               vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
>         } while (pgd++, addr =3D next, addr !=3D end);
>
>         if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> @@ -538,8 +545,9 @@ void __vunmap_range_noflush(unsigned long start, unsi=
gned long end)
>
>  void vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> -       kmsan_vunmap_range_noflush(start, end);
> -       __vunmap_range_noflush(start, end);
> +       /* The unmap paths are sleepable, keep the resched point. */
> +       kmsan_vunmap_range_noflush(start, end, true);
> +       __vunmap_range_noflush(start, end, true);
>  }
>
>  /**
> @@ -727,18 +735,32 @@ static int vmap_pages_range_noflush_walk(unsigned l=
ong addr, unsigned long end,
>   * The caller is responsible for calling flush_cache_vmap() after this
>   * function returns successfully and before the addresses are accessed.
>   *
> + * On failure the mapping is torn down before returning, so a retry
> + * sees a clean range. When @gfp_mask cannot block, the teardown
> + * skips cond_resched(), it may run in atomic context.
> + *
>   * This is an internal function only. Do not use outside mm/.
>   */
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> -               pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
> +               pgprot_t prot, struct page **pages, unsigned int page_shi=
ft,
> +               gfp_t gfp_mask)
>  {
> +       int err;
> +
>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>                 return -EINVAL;
>
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>                 page_shift =3D PAGE_SHIFT;
>
> -       return vmap_pages_range_noflush_walk(addr, end, prot, pages, page=
_shift);
> +       err =3D vmap_pages_range_noflush_walk(addr, end, prot, pages, pag=
e_shift);
> +
> +       /* Undo the PTEs installed before the failure. */
> +       if (err)
> +               __vunmap_range_noflush(addr, end,
> +                                      gfpflags_allow_blocking(gfp_mask))=
;

I remember we discussed this before that __vunmap_range_noflush() will
be unmapping the entire range between addr and end instead of the
range vmap_pages_range_noflush_walk() actially mapped and your reply
was that this keeps things simple and avoids adding extra code in the
common path when we do not fail. This was bothering me, so I looked a
bit deeper and I think there is an issue with this approach.
vmap_pages_pte_range() fails with -EBUSY if it encounters an already
installed PTE. So, if this happens, we immediately bail out of mapping
the range and will be unmapping the entire range, including these
existing PTEs. I don't think that's ok.

A fix might be quite simple. vmap_pages_range_noflush_walk() already
counts how many pages we processed in nr variable. If we propagate
that one level up then we could unmap only the range we actually
mapped.

> +
> +       return err;
>  }
>
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -750,7 +772,18 @@ int vmap_pages_range_noflush(unsigned long addr, uns=
igned long end,
>
>         if (ret)
>                 return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift);
> +
> +       ret =3D __vmap_pages_range_noflush(addr, end, prot, pages, page_s=
hift,
> +                                        gfp_mask);
> +       /*
> +        * The page tables undo themselves on failure. Tear down the
> +        * metadata that was fully set up before the mapping failed.
> +        */
> +       if (ret)
> +               kmsan_vunmap_range_noflush(addr, end,
> +                                          gfpflags_allow_blocking(gfp_ma=
sk));
> +
> +       return ret;
>  }
>
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index d8372a4f65c4..9ea28845f713 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -40,10 +40,12 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm=
);
>
>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>                 unsigned long end, pgprot_t prot,
> -               struct page **pages, unsigned int page_shift);
> +               struct page **pages, unsigned int page_shift,
> +               gfp_t gfp_mask);
>
>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>
> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> +                           bool can_resched);
>
>  #endif /* __MM_VMALLOC_H */
> --
> 2.25.1
>


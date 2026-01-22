Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779EBC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA89A6B00B6; Wed, 21 Jan 2026 21:36:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55136B00B7; Wed, 21 Jan 2026 21:36:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56F26B00B8; Wed, 21 Jan 2026 21:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A10CC6B00B6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:36:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F2EF13CC20
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:36:06 +0000 (UTC)
X-FDA: 84358035132.25.D584B01
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B93A40009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:36:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pGz5kkiY;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769049364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1ztD/wqbKPGcB/OK5g1Xm5cGzV1LC64G0Uj3l4VYPc=;
	b=IrpoLiIhXZ10w0WbfuJaQbfrnEy8J2Kv9Ml1Xlwg+nPDKHZuWmBkOIRiOJmSu9Ht9nPmr8
	CVRGagMvu0WJqyOHyoxpeX148UCGyajwSgDXZk2qpobsEaDL9ZFGlmYT+MR3Tv7Kx4A1P/
	hK83BPeELrPsqFbF9qMf0HdKfQvHDDI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pGz5kkiY;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769049364; a=rsa-sha256;
	cv=pass;
	b=3/kSXwwsgtKLkmyXKbdlR+ILGJ/4XL28+R0OslmwvmxHYpSGlEWNnctS8XXhWmyIC7ihi3
	0CVk7sD6Zg4q5UstF6xdAtUxe9fZ0LncxEiiBqDSgrFFyUB7pijiludUC1DUP214FyjgbA
	qIu+f/V8nrGI/8sqB8DX9rHk2jdccaY=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5014b5d8551so138141cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:36:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769049363; cv=none;
        d=google.com; s=arc-20240605;
        b=epzNeHATVN6KFoFK1Lf37zCYNw3je1U5TfAG5lrcraXObUQB+mpS2mZS+gxFV7PXaw
         x7L9VuMSVidNSx29jyeWWdRg56MEwBk41qdvTJyf0NEpt+odLuGncfYc8R3OhPpo1dKA
         i7keeYjGoF8jM6lNa6PYzFoDdiWsnPkiPiQPvmEQPg1u8+O36BX3T6bY8t7GVxq1ETZc
         TsEq2gh5/fdbxgGKIPneAcqBDeEgSLkbm2CxTsKXnYl3KuCVpmVNmINvrzoExVSCbhwD
         BU3HhHNr7TTVPWUaLApsFLePBLe8OEnuRL/Bq7p3pZgt9Onx4s/k4Exjhp0RCH03O3tM
         ygeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W1ztD/wqbKPGcB/OK5g1Xm5cGzV1LC64G0Uj3l4VYPc=;
        fh=RiBF3bVF8Nva18Osp0tgrUFr4CUCrv9LqSrzZBPIy48=;
        b=IyS7NucYPXcZdEhZmcKGRNM5ab7F5lhWd89hSvXTaV7Uaqf1/SFmm3JcAy/jMWWvh7
         LThs1wgR9V13UW4PSBChJQ6TXav8LYFdvUTpamo/6i9xeywW/JMa/1x1huBKq7KSp9Yt
         Akfy95e/0ydDWayEKiUK2BSKnbybTqImLggtKzL22RnhRys3bwzpVMfV1iT7IkV4Fmtw
         b3ZSzPDSP1MqtFatWJTWgtN+86DZjYdj+hGlyUPEFyUlQVUoBA0heomahmvLVF3gZMdd
         eiaHp0MPE9/RymL/Yysc9FMpFlnrXUPvff/F3em+oBdjo/S0l29n/gEvMlU8cmtryapP
         0pkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769049363; x=1769654163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1ztD/wqbKPGcB/OK5g1Xm5cGzV1LC64G0Uj3l4VYPc=;
        b=pGz5kkiYkU6gHDLbxS1ROnEJkH3IbpV7RpTWRdc1fhb9MZZJ+t0giT+GlAOH1fz2LU
         ccTILY5O2031CKNfCkR2HV47xHyoz2L/OaVy6I+ags4YHJByR2YfkbgG6OwX5lRfCEHa
         ZEQBcC6TWzQejTKi569/culTdTF9JsB4Zx8oDgijRlFZ61G/KFMEHFGmXtWP+1RKl7Ca
         tuGpUqQdbl07aM7MPbgFY0TzeK4W6HCIEyoLe97x3PrwMBLVp+4keeiTnYgPlg+lWzXK
         wDtlz5i354y6ynzwKp8YLj98PwM4RqLhsi4oGpzLsGJVw5wW2BfbKIEmcrFZz06ePMUj
         j4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769049363; x=1769654163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W1ztD/wqbKPGcB/OK5g1Xm5cGzV1LC64G0Uj3l4VYPc=;
        b=GoJw6Q6QpQb1W4GxfooRImKxhHDFL06VYnCbjXBDcmZ1w469q2UlFeOzi92y9DPuo4
         K/Bkpi/pYa6TvVLQ4GECByBSQj4hM8NidHM+VeuBXAYJAckr+WU+mTpFYOLi9DqiNYWc
         Tp907zS/YhlowKB1GFZwKuISC8gg6ABsZzuMNlQjMREW0JUohOYLtIH+I0vF2JBgz0T4
         6YTY1LNw/hNLT9gplvcJF62JxrRtAYk2yNVrocBQPR3HlsAyx402LCHB3rsuNDwV9UWy
         qrx1IQ8UHM0EsrWrBNELnjEbH9nB8G+aHmRyZimGgATtZ0YiGlSc7cFW9HEqKOtdix3e
         oEYw==
X-Forwarded-Encrypted: i=1; AJvYcCV6UjDj/55NTLs85LSKhG9FA5OV/BwmB9wQJVXoPHmtITnWqwlgSUDyRExSA3s7xoFq5Aqho/I6Yw==@kvack.org
X-Gm-Message-State: AOJu0Yx6MwN3M5EO1c4BeoOHPzh56H5qowQL9hh6uIh1LJ7ASqD2bEXJ
	UUgWQrkrD30wi2YT8BUghoUxxbj8jkNCPIs7+4pM4dzgIWgxUL8cEp8/Oe7Z7Mal8EymoYMDkwr
	mPxPaPi0FrPqr7JRDYXYViYuTEXw32GYmC7AsuzVd
X-Gm-Gg: AZuq6aJG/uiUSmTOTr2aNHNbB8zVfTlr/Dy9yvEw7XCJ1TIbyRFDuiR0vjr5KV0FaXH
	+/FxK8XCYM6kB0F/u0XVVUAmJzbou4nUYPdz4PJD8W7bEmwEeRPWDpLh13hFpGgxtj+7qaxeI7o
	CXvP/5Nw8YULO7Sbq2tqzxMBYNuVFAxhejIJeMf5gb6Vu0a/FYl65e5aX6K0Q5OtvtATL0aZBqx
	r4EJSb3blS7Sp5Qlm6PKGaJpTlHZXrrGWWpuG2k4To5pfxWU+VqUMwEqV+44DYnPWMpSw==
X-Received: by 2002:ac8:7d13:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-502ebd66753mr6535371cf.14.1769049362800; Wed, 21 Jan 2026
 18:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-21-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-21-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 18:35:51 -0800
X-Gm-Features: AZwV_Qh9DJqdsygnR2vDEt2pFl_xN2VFuNuBwsJB6lM8tVfE5ettz4wsz-RroIY
Message-ID: <CAJuCfpHg9YfkVwtfCUvLH_0HNWzUgx1ekQ-QMyYBW_Qeqt=WjA@mail.gmail.com>
Subject: Re: [PATCH v3 21/21] mm/slub: cleanup and repurpose some stat items
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
X-Stat-Signature: xi1ih8ozx48cedqxz44679cjmwiyxqxp
X-Rspamd-Queue-Id: 1B93A40009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769049363-25162
X-HE-Meta: U2FsdGVkX192IBmJKv31rZOWkTDflW74HAj8RPgJtspTaZ3z8UJYagsur+D7Wqh2ObPkGOJ3EDvdtPm1X4/w2cbca9u3Fk0FMY1gddnhP3S2i1aJ31/RkUuFksJcJ+RamlO5cZEucnQxL+P4ivnzeEzMngG7KXJTyG/evJ83JPd0qTIJSDOIXlq4H8HqvRCCO/VgIPBP1d4mhzs9oT8zOlsl89GBQzEVrWU+uGF6HvSqbcfvTs7kA8xYsOuWjodeMfPkdl9RqZzgj5pkiI0U7k7BWbUNG4OmrR2U1KGtiifRgtMqtQ2cjKkE0BYqgu+LdMPMARCw4F8y6xYS0z9/w7LJj+y0OshU4XICsz5dboRLxdAupCWzEMQZQsvinvV+RjB6eMRUOCpymJfPjcbS/UK1Rwaev8zH4eo/5iJPoneNV6sBVIHlDMHdakEZ1ODGKI2PmgMd2s1o+FX/3uU3Aq6nHxbA20iUDY0kFHdS+eCcQXK/gUgnFcTRMo/pb9KREtzii9QazQiRWeKl3IHvR3RMh8HnoZ9+3BaVb2IROLDmXz6JkDbV5Vv/w3QPEjjgNzK8Mu7LKYCCvjY76vjKlLc7ofiYGC6QmPO+zmahDDzrVjnBcEcBrAvMqTeNdi5tA2QWznLwDRPtkovSpxs6Qygr6BP4kRl62E4H+HEAKPsMwFaNs8kfQzmOFZA8+nhg/NHCGFwcdYB1IREJKJz1bSttIWR8vohCXS6uHcfnPydqno3gO2OpRdta+S1TiZtBvY0pIYPcKskiKXyl4Alh39VsWEHkZ2yZhQDl+9SdbKuD0qOhqlyz8YEewPn6uheMgyZ09C2Z+zw9mrbeKWQjtxcnRVR4IAwB9Gvi1nA2sVOtLdSMI1edevf7l3byO0Ugf5vNCRnHxIHcAxc2ZzXrKfdo8gwXSaRHW9fggCj+68dc+Z3r+E91hbmBn3wAG5Vtpcrzz5linafbVMusS0i
 Xlu6lrUa
 o+YNVF+PRMJyWql9uSbwrme7KlATq3B3Fv5ucN5uu4+dW9ACV6L2Q5Q1ortF/sf/TUFpeZbcnzcuIgPFeFeCAKGuz7HaaW8g9V2m65dDts6sWdf5e7V93Zq43ZGTu0evAEMTOSyxEumGnCefXZb5XeQv2gKsPRz7yNO/CriEsHitwWKPP/XDWoKbQkrG8/Ayn7D+J2bykhpz0kDlFkpCSWUioEqEKol0LNQrHyKpL+yvuZiyuBXCHCOHSKoqdM8Z5A0TZotp1/OlwNeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 6:41=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> A number of stat items related to cpu slabs became unused, remove them.
>
> Two of those were ALLOC_FASTPATH and FREE_FASTPATH. But instead of
> removing those, use them instead of ALLOC_PCS and FREE_PCS, since
> sheaves are the new (and only) fastpaths, Remove the recently added
> _PCS variants instead.
>
> Change where FREE_SLOWPATH is counted so that it only counts freeing of
> objects by slab users that (for whatever reason) do not go to a percpu
> sheaf, and not all (including internal) callers of __slab_free(). Thus
> flushing sheaves (counted by SHEAF_FLUSH) no longer also increments
> FREE_SLOWPATH.

nit: I think I understand what you mean but "no longer also
increments" sounds wrong. Maybe repharase as "Thus sheaf flushing
(already counted by SHEAF_FLUSH) does not affect FREE_SLOWPATH
anymore."?

> This matches how ALLOC_SLOWPATH doesn't count sheaf
> refills (counted by SHEAF_REFILL).
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 77 +++++++++++++++++----------------------------------------=
------
>  1 file changed, 21 insertions(+), 56 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index c12e90cb2fca..d73ad44fa046 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -330,33 +330,19 @@ enum add_mode {
>  };
>
>  enum stat_item {
> -       ALLOC_PCS,              /* Allocation from percpu sheaf */
> -       ALLOC_FASTPATH,         /* Allocation from cpu slab */
> -       ALLOC_SLOWPATH,         /* Allocation by getting a new cpu slab *=
/
> -       FREE_PCS,               /* Free to percpu sheaf */
> +       ALLOC_FASTPATH,         /* Allocation from percpu sheaves */
> +       ALLOC_SLOWPATH,         /* Allocation from partial or new slab */
>         FREE_RCU_SHEAF,         /* Free to rcu_free sheaf */
>         FREE_RCU_SHEAF_FAIL,    /* Failed to free to a rcu_free sheaf */
> -       FREE_FASTPATH,          /* Free to cpu slab */
> -       FREE_SLOWPATH,          /* Freeing not to cpu slab */
> +       FREE_FASTPATH,          /* Free to percpu sheaves */
> +       FREE_SLOWPATH,          /* Free to a slab */
>         FREE_ADD_PARTIAL,       /* Freeing moves slab to partial list */
>         FREE_REMOVE_PARTIAL,    /* Freeing removes last object */
> -       ALLOC_FROM_PARTIAL,     /* Cpu slab acquired from node partial li=
st */
> -       ALLOC_SLAB,             /* Cpu slab acquired from page allocator =
*/
> -       ALLOC_REFILL,           /* Refill cpu slab from slab freelist */
> -       ALLOC_NODE_MISMATCH,    /* Switching cpu slab */
> +       ALLOC_SLAB,             /* New slab acquired from page allocator =
*/
> +       ALLOC_NODE_MISMATCH,    /* Requested node different from cpu shea=
f */
>         FREE_SLAB,              /* Slab freed to the page allocator */
> -       CPUSLAB_FLUSH,          /* Abandoning of the cpu slab */
> -       DEACTIVATE_FULL,        /* Cpu slab was full when deactivated */
> -       DEACTIVATE_EMPTY,       /* Cpu slab was empty when deactivated */
> -       DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects =
*/
> -       DEACTIVATE_BYPASS,      /* Implicit deactivation */
>         ORDER_FALLBACK,         /* Number of times fallback was necessary=
 */
> -       CMPXCHG_DOUBLE_CPU_FAIL,/* Failures of this_cpu_cmpxchg_double */
>         CMPXCHG_DOUBLE_FAIL,    /* Failures of slab freelist update */
> -       CPU_PARTIAL_ALLOC,      /* Used cpu partial on alloc */
> -       CPU_PARTIAL_FREE,       /* Refill cpu partial on free */
> -       CPU_PARTIAL_NODE,       /* Refill cpu partial from node partial *=
/
> -       CPU_PARTIAL_DRAIN,      /* Drain cpu partial to node partial */
>         SHEAF_FLUSH,            /* Objects flushed from a sheaf */
>         SHEAF_REFILL,           /* Objects refilled to a sheaf */
>         SHEAF_ALLOC,            /* Allocation of an empty sheaf */
> @@ -4347,8 +4333,10 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t g=
fp, int node)
>          * We assume the percpu sheaves contain only local objects althou=
gh it's
>          * not completely guaranteed, so we verify later.
>          */
> -       if (unlikely(node_requested && node !=3D numa_mem_id()))
> +       if (unlikely(node_requested && node !=3D numa_mem_id())) {
> +               stat(s, ALLOC_NODE_MISMATCH);
>                 return NULL;
> +       }
>
>         if (!local_trylock(&s->cpu_sheaves->lock))
>                 return NULL;
> @@ -4371,6 +4359,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gf=
p, int node)
>                  */
>                 if (page_to_nid(virt_to_page(object)) !=3D node) {
>                         local_unlock(&s->cpu_sheaves->lock);
> +                       stat(s, ALLOC_NODE_MISMATCH);
>                         return NULL;
>                 }
>         }
> @@ -4379,7 +4368,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gf=
p, int node)
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> -       stat(s, ALLOC_PCS);
> +       stat(s, ALLOC_FASTPATH);
>
>         return object;
>  }
> @@ -4451,7 +4440,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache =
*s, gfp_t gfp, size_t size,
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> -       stat_add(s, ALLOC_PCS, batch);
> +       stat_add(s, ALLOC_FASTPATH, batch);
>
>         allocated +=3D batch;
>
> @@ -5111,8 +5100,6 @@ static void __slab_free(struct kmem_cache *s, struc=
t slab *slab,
>         unsigned long flags;
>         bool on_node_partial;
>
> -       stat(s, FREE_SLOWPATH);

After moving the above accounting to the callers I think there are
several callers which won't account it anymore:
- free_deferred_objects
- memcg_alloc_abort_single
- slab_free_after_rcu_debug
- ___cache_free

Am I missing something or is that intentional?

> -
>         if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>                 free_to_partial_list(s, slab, head, tail, cnt, addr);
>                 return;
> @@ -5416,7 +5403,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object=
, bool allow_spin)
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> -       stat(s, FREE_PCS);
> +       stat(s, FREE_FASTPATH);
>
>         return true;
>  }
> @@ -5664,7 +5651,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, =
size_t size, void **p)
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> -       stat_add(s, FREE_PCS, batch);
> +       stat_add(s, FREE_FASTPATH, batch);
>
>         if (batch < size) {
>                 p +=3D batch;
> @@ -5686,10 +5673,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s=
, size_t size, void **p)
>          */
>  fallback:
>         __kmem_cache_free_bulk(s, size, p);
> +       stat_add(s, FREE_SLOWPATH, size);
>
>  flush_remote:
>         if (remote_nr) {
>                 __kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +               stat_add(s, FREE_SLOWPATH, remote_nr);
>                 if (i < size) {
>                         remote_nr =3D 0;
>                         goto next_remote_batch;
> @@ -5784,6 +5773,7 @@ void slab_free(struct kmem_cache *s, struct slab *s=
lab, void *object,
>         }
>
>         __slab_free(s, slab, object, object, 1, addr);
> +       stat(s, FREE_SLOWPATH);
>  }
>
>  #ifdef CONFIG_MEMCG
> @@ -5806,8 +5796,10 @@ void slab_free_bulk(struct kmem_cache *s, struct s=
lab *slab, void *head,
>          * With KASAN enabled slab_free_freelist_hook modifies the freeli=
st
>          * to remove objects, whose reuse must be delayed.
>          */
> -       if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt)))
> +       if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt))) {
>                 __slab_free(s, slab, head, tail, cnt, addr);
> +               stat_add(s, FREE_SLOWPATH, cnt);
> +       }
>  }
>
>  #ifdef CONFIG_SLUB_RCU_DEBUG
> @@ -6705,6 +6697,7 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, g=
fp_t flags, size_t size,
>                 i =3D refill_objects(s, p, flags, size, size);
>                 if (i < size)
>                         goto error;
> +               stat_add(s, ALLOC_SLOWPATH, i);
>         }
>
>         return i;
> @@ -8704,33 +8697,19 @@ static ssize_t text##_store(struct kmem_cache *s,=
               \
>  }                                                              \
>  SLAB_ATTR(text);                                               \
>
> -STAT_ATTR(ALLOC_PCS, alloc_cpu_sheaf);
>  STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
>  STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
> -STAT_ATTR(FREE_PCS, free_cpu_sheaf);
>  STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
>  STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
>  STAT_ATTR(FREE_FASTPATH, free_fastpath);
>  STAT_ATTR(FREE_SLOWPATH, free_slowpath);
>  STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
>  STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
> -STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
>  STAT_ATTR(ALLOC_SLAB, alloc_slab);
> -STAT_ATTR(ALLOC_REFILL, alloc_refill);
>  STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
>  STAT_ATTR(FREE_SLAB, free_slab);
> -STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
> -STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
> -STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
> -STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
> -STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
>  STAT_ATTR(ORDER_FALLBACK, order_fallback);
> -STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
>  STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
> -STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
> -STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
> -STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_node);
> -STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
>  STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
>  STAT_ATTR(SHEAF_REFILL, sheaf_refill);
>  STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
> @@ -8806,33 +8785,19 @@ static struct attribute *slab_attrs[] =3D {
>         &remote_node_defrag_ratio_attr.attr,
>  #endif
>  #ifdef CONFIG_SLUB_STATS
> -       &alloc_cpu_sheaf_attr.attr,
>         &alloc_fastpath_attr.attr,
>         &alloc_slowpath_attr.attr,
> -       &free_cpu_sheaf_attr.attr,
>         &free_rcu_sheaf_attr.attr,
>         &free_rcu_sheaf_fail_attr.attr,
>         &free_fastpath_attr.attr,
>         &free_slowpath_attr.attr,
>         &free_add_partial_attr.attr,
>         &free_remove_partial_attr.attr,
> -       &alloc_from_partial_attr.attr,
>         &alloc_slab_attr.attr,
> -       &alloc_refill_attr.attr,
>         &alloc_node_mismatch_attr.attr,
>         &free_slab_attr.attr,
> -       &cpuslab_flush_attr.attr,
> -       &deactivate_full_attr.attr,
> -       &deactivate_empty_attr.attr,
> -       &deactivate_remote_frees_attr.attr,
> -       &deactivate_bypass_attr.attr,
>         &order_fallback_attr.attr,
>         &cmpxchg_double_fail_attr.attr,
> -       &cmpxchg_double_cpu_fail_attr.attr,
> -       &cpu_partial_alloc_attr.attr,
> -       &cpu_partial_free_attr.attr,
> -       &cpu_partial_node_attr.attr,
> -       &cpu_partial_drain_attr.attr,
>         &sheaf_flush_attr.attr,
>         &sheaf_refill_attr.attr,
>         &sheaf_alloc_attr.attr,
>
> --
> 2.52.0
>


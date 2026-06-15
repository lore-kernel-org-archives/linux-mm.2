Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70594CD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E456B0005; Mon, 15 Jun 2026 00:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E846B008A; Mon, 15 Jun 2026 00:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DCA6B008C; Mon, 15 Jun 2026 00:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4866B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:58:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC2FCC2770
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:58:32 +0000 (UTC)
X-FDA: 84880941264.02.0B49DC6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id C5361A0007
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:58:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XSBehI83;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781499510;
	b=Y1QdtXYY+yHXYtIwwr0GoTPm6WpMe2Goktdp9VqxhMM+nFSTcZ9Okqn1rATOoC9jMrPMCy
	D/gluPkHslo+mTbheWw7zfTauYoe8i4fJqdAd7OMjV+HMlanZKo4A9WrPkHyz/EZttYIFE
	4qaTi3a6N3sFgmxQ5d4GMtOkSVyEuq0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XSBehI83;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781499510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZMSnIuAEoqNdnHgvV7SmrbMOmKklwpldD7yQBXnGp4=;
	b=ei5Werivi6zYlcXsNrfcTStpAokS+XwHdFI2a7ods382bSs29ueEqoJa5vEZU/3hOrwHTL
	BEbHqWgkbt053RKXGNCIJEk7nFgYiO6It+AENrcdl480BEflcCpODxTrDJiQiOa+ov9VdR
	i5OdwAmngdzntIjHapkbfUxQsQS43z4=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51765331535so761731cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781499510; cv=none;
        d=google.com; s=arc-20240605;
        b=gvqsVsrTTp0K+4aJvuKovw8FBYQRubAyLgJsRfT/WCudGD2blfBvmMUrWWzYpPnObo
         nHzGLa8vMUJXwUgMWz1sZNnWy0Wb0+BcOfWE0xZSXmsED7PxuPDHiJVYFvMchQW+a2Bj
         N3ApxHIgNqpXpIPU23qQwB6d8l9NJ82YtkWPRn1Col+ZudRrUQ+h/jGnHtxZAxsNIK0P
         JM/zZhNZlQOVHFHzrzGitby8zQCrW2rDo6I3oFPXCkYB9wtE+Lj4Y1++eWB2tpCzz0ii
         RPm1ei8yrpwnBWEZXxcLxwDVcBl/yVr3NZVlNnv5nwy/QMA6vxcd4PWKaGmFhQYsjCGA
         OqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zZMSnIuAEoqNdnHgvV7SmrbMOmKklwpldD7yQBXnGp4=;
        fh=6rpQeCpMj9r9vIWXWAfDagdnJJy6qf8Iam2h7dPiMeU=;
        b=AyCgi3efZn7LFivNy2xdikJP2owQ4QEw54dyLIXYHbC97h3sr+mIxTBNemb+dBsgvT
         VfDLhIGzAf7KXJgMfY86ZvG9IerPabr3bHDW98IcD7DObFvr85E723dG+ilUvc5rDxLs
         eHKbbDH//d4m/gwUm1TIc6OtdjZYwBee8AFftABLVAt4BoitaTk3Ft8aF/Fzo+O+RPua
         Htq7HUovLm3wIjwy+HldBg8QkekUELxxI++ve4rW9Q6Fa5KSjCkegUtlDXKEggqaeTZv
         3jXq5lSa2yF6Wd71m3oIHwtzQALs7VKy5EpGSs0PCDH1IDfh9X/u/B1r0ExEruu5qXAY
         HtJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781499510; x=1782104310; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZMSnIuAEoqNdnHgvV7SmrbMOmKklwpldD7yQBXnGp4=;
        b=XSBehI83g8owZ/26986Z9U7LY/P0J4a0endnzphRPatjAWwf0vjh9YTkshICcf9jeI
         6pH5wSNoFV0ndngyaoRcz6JrKPQEhBh2g+j8LPxfFKvW1q08YwAEUOF0WfL62Bp4MDnN
         LfjdPjfE01Jgb9pdoSgyLvMvM958Zxx/8zIEZ/3oASeYolWt22mymwUNazvA17/6Y9O5
         n6Lr4KLJy2dQ4P2fDv9SZbaMZtGpuslv2YbBvB7eDOmEWytviTMYdcPabC6XiiXghZEy
         BKWVtTaKrFAdrIh8ucM9BuUfVsjvCfWouXhPiPxDKVMpcGuwWyQvyORLFTTUBZ4GwWN8
         xG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781499510; x=1782104310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZMSnIuAEoqNdnHgvV7SmrbMOmKklwpldD7yQBXnGp4=;
        b=MhrRFJ7Q0gc0y5YJ24W9/FwmdDl3PxiYyV9Owm/KHgnhlHpkL6xlagugK1ihYUrI1s
         FA2lEQCx5kv5ihmoUbixmxZsrxwccgoPORw0pDy9fgiGozqGtgvy3g1RJ33dsL3Ll3GC
         lRGriVsLJecu1JQ4t94l/GIYeY+KEx3U5mhVV0Ji+mmwRgrOddwvu++Y36SQ0D/i64Zm
         e+SnekDW4R5nZZsLnQL0qLWeoCJjh2PoHqHyliMTmO0A6ZLxwEELQbKHiDk/f/E2OZB5
         bVV8yXVrj14iB+Hj/Yw9v0z0alkx8z62iVAEAHobIQMNAaV4Xym4fOV986TiiGf6pWZ/
         xAKg==
X-Forwarded-Encrypted: i=1; AFNElJ9CYq2VNiY5aECIicD79x9Z5DncqZbAtaMHdkjL6eL/CazpbHyICXqtKFpl04g5u0bgP2Ko9L80Gw==@kvack.org
X-Gm-Message-State: AOJu0Yy/Jc18AR4TxVKO6FAaWbLeOPULKnTQxAWFAscIw6uPagboHYjJ
	R7wzOzmGkCOMfWjZFQaZSVfq+fs6eqElTR9WLKQ9h837dU/WcTiZPTBOhFauxTVEBPT8g13mrfA
	oKzape6SRn4DAll/NVgJ6/KDDcpylA6mRUKOjVDZs
X-Gm-Gg: Acq92OF39oUXrZ3bp7NP7APLyRQs+3wjXklm4nlQaw5HvA/rJZ0qIAYKtGb6D6J+GJc
	lGafouMjqBEUKgAT39KqB3h3sqDuBfWfiATsNS6+r0zIk6iXZq3dDDFtFk4dZ5KR8kmEBztVwA3
	e9d5ixwf4xZfgJ3EUPYk8kKAgnX+wSzN4vuEECjzhOA+Kh+c181F26Ugsk3gsGtdhaPUGu+AE7n
	lL74EpT9w0X15iKJvvwdwSL6MscafH4RZHfpjAMIdfvYlOS1aTkfRdv4OpSsH1bYxY5PbEhKIkL
	ItTAMg==
X-Received: by 2002:a05:622a:1195:b0:517:99ea:ab7d with SMTP id
 d75a77b69052e-51955ec344bmr12452951cf.23.1781499504513; Sun, 14 Jun 2026
 21:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org> <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:58:12 -0700
X-Gm-Features: AVVi8CezM2Z8h-1vndfvlUnEXMPBWx1_QWpDaN8TO9wK0rWQ--byif7hloIBM0k
Message-ID: <CAJuCfpHOXkZFq8UKiSqXzG-RBFNw5gO-JR0bBCn9uRc3Oc5ZbA@mail.gmail.com>
Subject: Re: [PATCH v2 12/16] mm/slab: pass slab_alloc_context to __do_kmalloc_node()
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
X-Rspamd-Queue-Id: C5361A0007
X-Stat-Signature: 8gsjmesqgiaprxbe3hw1oo5ds3w6o4z7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781499510-974476
X-HE-Meta: U2FsdGVkX18kG0EFkbhtFDB1CwJ8gFkD0S3AbcPoVc/rO5jI8AqNg+UTg/XrzqVPQmKp9DyfomHBqmC7di7Jat6QPlxPWght+G6bgP2facaF4czdqpvl+eYfkIGgq+bbNH6A/qB2ZAUMUT3y5LBUrPguSVCPcqPWP6ljxda/Lqa/138LOyzQRH2X9r2I7eIJbSIUEf1Hs9svrM3B/Ng7R4cuAB3s7TF8xyLtEEv1naM1EmmYrjVlJs3QiO6Q7ssmQQnA8u9UpDgjTOnndODe0QNsVs62JXRNIVCgmt+boYn54aD3FY91TVaLKWFcAD4yoZass1BP3+FRtTKfe1AeMdKp7WR4gR3CCzUrIIqHbLHljmruM28IYHamR05Y4e19Qewbd5/fd1Bfx19+YuXoSfjSviwbon0V8ti5qfWZEzlPissNTAT4BZFFH4lYM8BQLcQpIWgvb0I3c8ErJXHGe8Kqeb0tboyHMgEqy9zV+CYr/FhRklKXvDwaN456uk/lmp/xtCKRn/Uo5dP1TO4D+fA+Yi1yuOO0v59nyMP6+e+UD10U5SL6zRrm2UOKvBoaT1fKoDcPZJKhcw0dHjUM6PvkUgg1krXBUQ/e0lNH7q09QnS1LtntYQNXGXTv2CMhIh1ztl4UZji92ZncZh5irbFZPQ4MLdfZjd0AVTj6b34+dhiYyB5OSkZItJU55QHl001BTZpvwSX+IpefzYr39cJ5xkb1+gfAdrs5LC+F16TJIqb/g0DntdR9/KAcuYgjpGugOm4KYw+7TEkkB4hrm8kuty2zf6twqdyTXYDuwtzqk6rNVG5IpcBwCzPwWaO4SnhHvi/SQima6X/LvXQoiqFFRtivr/i17vMBByFkA5B60VNgwUEVItXM+jm/cA0BwZKsY67Fv8oaDOrzyb3lArePFhXiOfIHXQXO2a1xBj7k62gLVtoIps7WVhnAGpR0kQp6gli2xu8Jp3wK/Vz
 nk1k5dvZ
 KC3tHfHAik3Ux4Mro+hoXQqRuYb4tSClBoohUbkt03iPKLoCfikPJIEhQyKjkXjYRRCcyP1xJ4JUQRS9wTjCUQFzQbShgsGJH8C7P8GL3eH5s5JUeyjC/INeUNP+2ydNsWGrUoC9AUqNrNlKc7jtkOxpFapjS18jrt6J/LvvSPMt4IbUeuu1GavKxRkc8Lg33wjSkjiOJWO8hnzaDgZoBoIFrHVt7OTK2/Wf5Pw24jOsmMYJe1L6IrLf/sixl42PAdpxFQ3cu/lUH2KQitKYmJXxEqJP8uy4m8K+pPSx0jVdUXKTYAtZDJaPIaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:41=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
>
> As a preparatory step, make __do_kmalloc_node() take a pointer to
> slab_alloc_context. This replaces the 'caller' parameter and includes
> alloc_flags which we'll make use of.

I think you could also eliminate __do_kmalloc_node() function's "size"
parameter as it's always the same as ac->orig_size.

>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index ef457e07db83..6845e15c148a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5338,19 +5338,14 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
>
>  static __always_inline
>  void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int n=
ode,
> -                       unsigned long caller, kmalloc_token_t token)
> +                       kmalloc_token_t token, struct slab_alloc_context =
*ac)
>  {
>         struct kmem_cache *s;
>         void *ret;
> -       struct slab_alloc_context ac =3D {
> -               .caller_addr =3D caller,
> -               .orig_size =3D size,
> -               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> -       };
>
>         if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
>                 ret =3D __kmalloc_large_node_noprof(size, flags, node);
> -               trace_kmalloc(caller, ret, size,
> +               trace_kmalloc(ac->caller_addr, ret, size,
>                               PAGE_SIZE << get_order(size), flags, node);
>                 return ret;
>         }
> @@ -5360,22 +5355,34 @@ void *__do_kmalloc_node(size_t size, kmem_buckets=
 *b, gfp_t flags, int node,
>
>         s =3D kmalloc_slab(size, b, flags, token);
>
> -       ret =3D slab_alloc_node(s, flags, node, &ac);
> +       ret =3D slab_alloc_node(s, flags, node, ac);
>         ret =3D kasan_kmalloc(s, ret, size, flags);
> -       trace_kmalloc(caller, ret, size, s->size, flags, node);
> +       trace_kmalloc(ac->caller_addr, ret, size, s->size, flags, node);
>         return ret;
>  }
>  void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t f=
lags, int node)
>  {
> +       struct slab_alloc_context ac =3D {
> +               .caller_addr =3D _RET_IP_,
> +               .orig_size =3D size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
> +
>         return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
> -                                _RET_IP_, PASS_TOKEN_PARAM(token));
> +                                PASS_TOKEN_PARAM(token), &ac);
>  }
>  EXPORT_SYMBOL(__kmalloc_node_noprof);
>
>  void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
>  {
> -       return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_I=
P_,
> -                                PASS_TOKEN_PARAM(token));
> +       struct slab_alloc_context ac =3D {
> +               .caller_addr =3D _RET_IP_,
> +               .orig_size =3D size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
> +
> +       return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE,
> +                                PASS_TOKEN_PARAM(token), &ac);
>  }
>  EXPORT_SYMBOL(__kmalloc_noprof);
>
> @@ -5471,9 +5478,14 @@ EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
>  void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, to=
ken), gfp_t flags,
>                                          int node, unsigned long caller)
>  {
> -       return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
> -                                caller, PASS_TOKEN_PARAM(token));
> +       struct slab_alloc_context ac =3D {
> +               .caller_addr =3D caller,
> +               .orig_size =3D size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
>
> +       return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
> +                                PASS_TOKEN_PARAM(token), &ac);
>  }
>  EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
>
> @@ -6874,6 +6886,11 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(s=
ize, b, token), unsigned long
>  {
>         bool allow_block;
>         void *ret;
> +       struct slab_alloc_context ac =3D {
> +               .caller_addr =3D _RET_IP_,
> +               .orig_size =3D size,
> +               .alloc_flags =3D SLAB_ALLOC_DEFAULT,
> +       };
>
>         /*
>          * It doesn't really make sense to fallback to vmalloc for sub pa=
ge
> @@ -6881,7 +6898,7 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(si=
ze, b, token), unsigned long
>          */
>         ret =3D __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
>                                 kmalloc_gfp_adjust(flags, size),
> -                               node, _RET_IP_, PASS_TOKEN_PARAM(token));
> +                               node, PASS_TOKEN_PARAM(token), &ac);
>         if (ret || size <=3D PAGE_SIZE)
>                 return ret;
>
>
> --
> 2.54.0
>


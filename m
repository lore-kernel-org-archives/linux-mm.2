Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEC6CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 02:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDE48E000B; Wed,  5 Nov 2025 21:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EAD8E0002; Wed,  5 Nov 2025 21:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DF28E000B; Wed,  5 Nov 2025 21:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 631B78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:39:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08E6D88E0D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:39:21 +0000 (UTC)
X-FDA: 84078625722.04.0D5B0FD
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09007A0012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:39:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRq4aCoQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762396759; a=rsa-sha256;
	cv=none;
	b=jOqPKbYsuNeM8XAZzM+txPVx3WlsYh8egV9CkzMXFPPNbDJvMZzb0y6OFy8Rq/+K4hs2Tb
	lancW7gg0P2okYYq5NZM7wXuzS3uJ+lfANPP7ZlROFbwoEREL4O2iQuMDK/wYMkwUo6mgP
	o+Br2dgT+66rp0pjAo0FZKsY9rQa/wQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRq4aCoQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762396759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewoAJCSF8NH/dTxpovl4STEPgaBdVGC9xI+etM7pZH8=;
	b=DHk+3SsU/izScnr+ZRnueIcE/HPNXUOI5eekn0AQQ3Q1B5ZupJT3RxwvTwaqeIi9iR8C4R
	xmihHoPqGoWPutc+3//48F727H5uH9Gi+ocKnjQEk+ORwIsPoF7DC2fF6xNbKhdh9bJORj
	RMn+mx6fgWGuT9Kv7Pb3h6QIEUZ3t6k=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so295478f8f.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 18:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762396757; x=1763001557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewoAJCSF8NH/dTxpovl4STEPgaBdVGC9xI+etM7pZH8=;
        b=YRq4aCoQknv9aLXLQnz+ijsDPFu9Q5hinod59siCv7dVwc1XsU4iUl6IV+NmV4abCk
         ezMbpk128C1/yWlS0EIp2SdTcwL0EAR/AFPh+RWUM+qk9RaQaMlDlm+Gha9heWtMD6Nu
         M/bnyTTN2NpmoSiKmPAeg6RY/GxPAOafciQlnduGwlQb+PY0TCzNnVh0vReCNBoIr9UY
         VrQI66mfckhO/yTEBs65wWuL1FIrvy34usf5g574vL0mPSoMEhhejHz1nwZ1XUs/n6OF
         v490+mRcfDiyWtrvjV/gmfWK6tKvzlXJO9P+3QECNnQu7Zu+NTo+QdMvIPjFBklw+0N+
         pAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762396757; x=1763001557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewoAJCSF8NH/dTxpovl4STEPgaBdVGC9xI+etM7pZH8=;
        b=lKFEwL9Cf5p99Q/mjpb2IwdkuUyip5zpBzbhJtDqF5RYOR/uDlsjraZaNlDrrFgrP8
         r6emCw9IAkJrgbU0Fip0V8attlViSciJPPmq9TPPzQ1Fppllk3KEk+SC5KrcgXwpMMQL
         0VDN57r0RyjeRx+AtjU7Ikc6cFDnqfCTmcOohnOE+bhtY6VBKpRHFuWp1fO3Wt5bVXuS
         15DuRWoI2cEiQn2YqvyZNtFVZWRQbe0nl1YYXqGkJQIWa8MVQcxkrKghVMylR4xKSLVb
         XLKuUNUNKDVQmRss8EycHsnjLndoSkiLIda0cigZ7v26xtRMNj/q05PXwfxjZeZSlMHA
         G03A==
X-Forwarded-Encrypted: i=1; AJvYcCUDzOu9AMvxNKIenBPSuorMDXfTAHyh4oIo9qnW6meNWGchG/uU27+5IkckGUjLOffjj0VQufQFQw==@kvack.org
X-Gm-Message-State: AOJu0YxMBQ/j1xor0MDFzfyl8BT5IZCSq79mV70ahqZnlLC8SyOoZdVh
	oLK3Ytfu9p5sV5zs6KNAMi2KwcI03M0lac+VAHpJFTSNKhy8xq3hJOrI/XsKQT8x7PFfOXmgRQb
	HcKYpyOOibVuYW5eY3Ewv9V4qgOgOD0U=
X-Gm-Gg: ASbGnctbEPeHDLXFNECKdAD9gCxUk8COvGOfI2qwHue+9UTnjrLFnO2TjoHEsOS0FFv
	NpM7TEwmR0sI+AScdFJTm00HQyZqMLaXoJ5yG3PYwfJLHsDDhphOVihGVkJMHuHhq4lEjYjvH8K
	OArg68JOycEVnHceZXNDOss5+XfKwSYbee42vkXKg8ND2g9kNVAyc8gi4UeodVdK1l2c22uIsEg
	1RPjkBSrRwcZ64AGUPI+AwcNw/aCiOkcxnlvUmWByfqXmDrLw860p49m4eSCdsy6c/wUWPt2pA8
	RLSuzdkXBqNC33aiIV1CbYil18qV
X-Google-Smtp-Source: AGHT+IEMYxYr58b+9gWCWiOxY19wV2YuCXhlo+gockn3ye5gvJ4AIE1Hket4divhHgZldaCGzsJU+k/vwey2D9OfBOE=
X-Received: by 2002:a05:6000:2dca:b0:425:75c6:7125 with SMTP id
 ffacd0b85a97d-429e32e36eamr4631215f8f.16.1762396757374; Wed, 05 Nov 2025
 18:39:17 -0800 (PST)
MIME-Version: 1.0
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz> <20251105-sheaves-cleanups-v1-2-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-2-b8218e1ac7ef@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 5 Nov 2025 18:39:06 -0800
X-Gm-Features: AWmQ_bnDlj12yke_m0UY9rM9to7dPxs3SzBTZ6_PfSj5mhKDDRMWfaCanTzBLeU
Message-ID: <CAADnVQJY_iZ5a1_GbZ7HUot7tMwpxFyABEdrRU3tcMWPnVyGjg@mail.gmail.com>
Subject: Re: [PATCH 2/5] slab: move kfence_alloc() out of internal bulk alloc
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09007A0012
X-Stat-Signature: q3taqafwdw7yu7pfmfp8dwubt1dmc9j9
X-HE-Tag: 1762396758-100424
X-HE-Meta: U2FsdGVkX1/WBYgdbIdDEKuFxpz7u6b3AJiH9XEzNc/s6WCZwxMQ3ySQWs8LezRzfJsBdtl9oIXK06g7TD5N7lO4AJSHb+XUo7iq+ZGdVGZfUBPxX9TQWz64mGPAX9jxMNKi4uQbj+PhgvDBRxPUP3sqaiqRKrPlTuT84R0m9ih5FsAAIMxs7ChTv+YoQgKhOerNq7avTJ+O2tmdrFuIgdCxFWr69QWnorSolOfYj14Vb2Fd9MkFj7bdLL7S4yinC/iuvykW97FqrqbRpXuDm7OLBktrPoTm/xMtYkL7TRAh8RHXOKetKrqDsPXWQjVGDzJoVInLNwqH3KQ2vo2xg9BPeNouuvPYpdd2amWgijw2+ze5CdOLtI8XKXKRAZej3dX6DYUYbUrDo9AMx51YV9u7EK5RvI9Jrmq71+wvQCoNa9rp4VM0IdTHQNOjMjGbzQ9FGhbi+0JaeyrKvNa8IVWyMvySm00ppNH/zmbsHy8kwRhT7zpJrwlja5fMXa0aafc5EMdaf1eYhPJnH83YLbZ5hm7kETO0AMZhAEE2sC4P8BMcAZpCySyHKCEsZYKnYwJfoY3OzgEq7OyxIH+McOEDINUACQFYbos+PJ4dltlll67EGaWYkqG5Q9pfM5fX8btLgCb4E5JbuYHTa3awiP5CLzqcNZ1POtLrvqHEpy/Mnl+2BEoulO1ryNXDCtMCd6UyF2R8RF2uwFf1cMHy2M45BBhhGWEgJKQFEGj9GqhU2gsYQSYfQDOL7z94UQ9ZGEso+xgxd+7mDhv7HTdVWUEu/0xpfW4nsGslMCUM9rxAekZ0p4fY4AbEq5c7Yj0nUsndsONckG79+X+AUmVByMbY4D6JzQTDnnkgKFxAeF+RQ62pEZ4fnRCZePU5oeZfZeLDQe9jtFmZX4vU8mz9ijxZpd0Oc4LWHnS2Up/XL8BuChCPDZq0qY4mDBOj5J13RHDhhkFtqGgMRAhuVsy
 6cgjlhLm
 fAEeAYrcUOhBodLM0p+HCOcjEUtWq4z+jCwgOB7ZRNnYHyu2PA1jppTbWt8TJim6xyg0S0SDyKVdBcK3bjb6tmrL2NZCbRN/RcMLAjdusuKCSfhBjhtP1ll1iC67i43iuGs4J0YZn0GJAzFU0zA0oZjKM9vH8a9/8MD6pDsMo587lcycC/DdyRamWeI4+rnXUHdOVqXqLlRnfbh4twxZOl3cLEAk8H5pov8yrONn22TfN3Del1nGNsQGnDWoro1raPxPy+SIzjkj7DmXF5vppYNKmOlQ3Fl9znq0So9wtYiq1/N0a2YaR3pPtGmg+iHC8tEv6/vnKamtumwdIGdEuzpQ3/AqHYn/Jh6Zp/tKRjE8OJtbf6DabsV/hnkv6MWtZc2pZ569XCx3SJzUAnDXnuyH93chMFFH1VzqdCAd47HUVLesUcX7OllbcNTpdtuDBD3cVUHWdiy3tAuoiZAY9Gy5hmGkCLiUbDu0husW0d3211rQMvwmX2P9Uaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 5, 2025 at 1:05=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
> allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
> but it's conceptually the wrong layer, as KFENCE allocations should only
> happen when objects are actually handed out from slab to its users.
>
> Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
> object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
> was refilled with KFENCE objects. Continuing like this would also
> complicate the upcoming sheaf refill changes.
>
> Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
> to the places that return slab objects to users. slab_alloc_node() is
> already covered (see above). Add kfence_alloc() to
> kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
> prefilled sheafs, with a comment that the caller should not expect the
> sheaf size to decrease after every allocation because of this
> possibility.
>
> For kmem_cache_alloc_bulk() implement a different strategy to handle
> KFENCE upfront and rely on internal batched operations afterwards.
> Assume there will be at most once KFENCE allocation per bulk allocation
> and then assign its index in the array of objects randomly.
>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 44 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 36 insertions(+), 8 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 074abe8e79f8..0237a329d4e5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5540,6 +5540,9 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, g=
fp_t gfp,
>   *
>   * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUN=
T
>   * memcg charging is forced over limit if necessary, to avoid failure.
> + *
> + * It is possible that the allocation comes from kfence and then the she=
af
> + * size is not decreased.
>   */
>  void *
>  kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
> @@ -5551,7 +5554,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cac=
he *s, gfp_t gfp,
>         if (sheaf->size =3D=3D 0)
>                 goto out;
>
> -       ret =3D sheaf->objects[--sheaf->size];
> +       ret =3D kfence_alloc(s, s->object_size, gfp);
> +
> +       if (likely(!ret))
> +               ret =3D sheaf->objects[--sheaf->size];

Judging by this direction you plan to add it to kmalloc/alloc_from_pcs too?
If so it will break sheaves+kmalloc_nolock approach in
your prior patch set, since kfence_alloc() is not trylock-ed.
Or this will stay kmem_cache specific?


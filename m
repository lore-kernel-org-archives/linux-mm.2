Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF40C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7AA6B008A; Wed, 19 Aug 2026 00:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DDD6B008C; Wed, 19 Aug 2026 00:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB676B0092; Wed, 19 Aug 2026 00:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D26F6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:34:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5846A039E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:34:37 +0000 (UTC)
X-FDA: 85116752994.23.ED45311
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF1B6C0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:34:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S8EtgkHT;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787114075;
	b=kgBFQoh/A1JO3Le41N8iFG8fc66IZrocizkVGS2wCsV74yW+048snTVV0gaMxYhy4cu92j
	nNdGF+4Lw1GfWvR0qkgescp7WgDvDh5vyMxOiCe5kdHViBGyyQsATboICYEh55ZU3Kv0j8
	q6fQZBKEF8orQarxBRHYiLKkBO8OjL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S8EtgkHT;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787114075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+YUeWNIxwzYnOb4wfIXtSVR3SjLePrIifGedKFPQa8=;
	b=OeE5RsolWGKCVTO82woQ/8sSWHz7tdyLAhxLEDskhl9IeD8irRof3oGJYR/fTMMNLpNDxL
	POd4yMHZlIufU7jKUQ6s/vovqJcRaYewnUz8dYaVBrCVm70r8gYbgjPwJvOXLz80u7jcJr
	qJ9ye4llDGWC7PZdEPSqhqVwpCf9JzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CD81601FB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF971F00A3E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787114074;
	bh=V+YUeWNIxwzYnOb4wfIXtSVR3SjLePrIifGedKFPQa8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S8EtgkHTVunaI+h3PKaVQB+8f+PnNopEo6b3Ke/FoYxcRrXZcaMW2I6pIYiYeY9/v
	 mF97B5h5EvMKGZ4JolcRTTujnuCo4PzoxzSbqb9OPBGuADKncvVwFYi+P3ewWCaWm6
	 n5+cennO2x9XvmWb8qR2ng8PmIC3iWhX70M6I4QmiPorZq0CWyjOp350CXAbZd0T/a
	 HJjQNG5jnRqdzMoJ5JCsw+jEbGuW5o1oge03KgwtPBixghl4yLvsXSCulVAdmsR3Gm
	 iaScnc/g0/ERVUarcuMdhq2badWbL71GfqfE7z/QoDP73GEI2uehMLUTiHla+6XB1q
	 H4y2mro5Hjj6w==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-934956bee57so65207085a.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqblusYBNUmwgg1RaeKafzIjUFOBoPjO3HPpB8yNZY6hTX+0zzXkwfX/Gihwag8cguQr/C0KytwuA==@kvack.org
X-Gm-Message-State: AOJu0YzHSKAwRAHbG/ba/8Ae5hH9rK3u7UL7QmQivUBU+9K03B2v6wgI
	UVFhtbZ9GV8Cj2qL27StbVWedp1zAH8e8UBfsXNGfZKZhvVjIz6eQT8SR56eG3/hHiIst04u41T
	7ttDeB8Xa4mhVSRGj2ICZgDWAS4gMkgo=
X-Received: by 2002:a05:620a:8389:b0:936:7e73:c60a with SMTP id
 af79cd13be357-9371e30ec4fmr225635885a.37.1787114074135; Tue, 18 Aug 2026
 21:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <20260818225904.55236-2-baohua@kernel.org>
In-Reply-To: <20260818225904.55236-2-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 19 Aug 2026 12:34:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xv_8HwKOQGNBvp7mu=802=RzPg_JZsnpzzcoH5i7xk3w@mail.gmail.com>
X-Gm-Features: AcwNN1V2jxhQudMzYhyXXXeCTdTk0SoUTOpiNOCOSiU5lTv50UXywTqhwMJsphA
Message-ID: <CAGsJ_4xv_8HwKOQGNBvp7mu=802=RzPg_JZsnpzzcoH5i7xk3w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/4] mm: allow smaller large folios to use lru_cache
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, 
	hughd@google.com, ackerleytng@google.com, usama.arif@linux.dev, 
	joannelkoong@gmail.com, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DF1B6C0008
X-Rspam-User: 
X-Stat-Signature: inezgutpg1ezif6e1ujkceyjue85db9b
X-Rspamd-Server: rspam06
X-HE-Tag: 1787114075-182475
X-HE-Meta: U2FsdGVkX19k4USTac+IpD0yfoVM8cJ5JivNP0o/J05mpKGRADTvk5E6Lc+Q6E9DA0DtxDU7+SpSl+eJlo9gXbMOtZBzRwZHD8UT8LorotJzS5zwCc3fa1wfxSek1JWm2dJHeoB1sK9jxWoHf4ELHLht2DTJ8+MB3sHQ/Bbq7ECWxfbG+xWjw113xXBDiXLIkjH0vxuvgTW+tBOhDUpDG35Nmves6RJnnNkfivgt1yBZrvqvhHdTV7o7+oagu/oo0OUg/EipAGxOr13MPUVkbLxO2QnuAJyAf1pnulCeQhMUSpIuBPbvPiWoQqIzJyjdsH1kdjNA0TMdJIeM/Hw1Tklt3aVS5yE0lRnMK3pce/mqNOQi+rE8QD5kMDXdwcT97UonEjS/ks9OfXjEjjdgMurkvQT/SiKujwu7oYOEc++WcfS3gfEgvWzD9ipgxoQrsbma/frYygDDjj79rBYdrQ0yEVNxMC9s12qRwQFGw0mVoJOXhjhHUTK+05LRWRmiWUA3SmzH1PieJlqUx1q4BcbOH6GSGeti+6oFP2u+oguHEwRoFO5l+DRkf69bgEG3ItTbNSMqzTVBPWwfEsnLln1s4C1Ui1BO89rU0G1NYlwgKSlFMrwSHVh5l4hqxoBQkAr90YHfGDv6cqwd104+RWRzuFPcNG3CIJQnaZzr+s/SRlu++47xGok9U+GyxlHs64/7g9e80lanlMHLXWPlDRJP1aQDil91IkSAKMvduBP8sBJC4aJcSVOupiD5wPxpfWfAJbAvrln5PmC72qtdWV5J8/x+DSq8e9NNvpmRQfXfGTKGqyyF6iQ+k2vr3uD32kOseLZY+Xg1IxV1HyDcWLl2Jozt9KuqiNRMZJf0y7rgyRY2BNejc4kBf+BHyWETYcRdhBHYYZrBygkWKtCAu16Rbu+DTuZta7oANhP63BVIlMIhNXHAhaVEcUKs+hGgvsqjNENzGw2eT4uJa7C
 PXyhvz93
 /bUxqTtsjnDK66R8Li88973Ux/OdvKo8422gBmk+Bp/pUMg4pnsh1OKQKFPWU5VOSSTo0Vx1HRNzsUf+icua1OqTlmC2gQ5mj3Gp5Y3DSwdFDYWkr1QSxnLf1kv5RbHyaLCU72Aqf63oZLvugYVsMltd4IRx6VSVg+iXsnh+FTKtTbPBqlVyDX7UeySt+lFZuycKTuf33qsINE9hhXAZ6ziOR/q92OtePcGGNotY7YcjMabfTLmCc6qzjhRM7bE/CT8GGybFd8j+1ULiP31zk/EpIyZS1X3W85kn973xl9kmtCL1QAi1Q4n+OUMyEeEwtfTtO8w8wH4JZbXWfe/L2S8W7cfH4x66ZsK7j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 6:59=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> For systems that primarily use smaller-order large folios, enabling the
> lru_cache can help reduce lock contention.
>
> For higher-order large folios, the number of folios involved is likely
> to be smaller, making lock contention less significant.
>
> This patch enables the lru_cache for large folios whose `nr_pages` is
> smaller than `FOLIO_BATCH_SIZE`. To avoid holding too many pages in the
> lru_cache, which could affect accounting and reclamation, we also limit
> the total number of pages in the cache to `FOLIO_BATCH_SIZE`.
>
> To track the number of pages, this patch adds an `unsigned short
> nr_pages` field to `struct folio_batch`. It cannot overflow because the
> batch contains at most `FOLIO_BATCH_SIZE` folios, each of which has fewer
> than `FOLIO_BATCH_SIZE` pages.
>
> For non-LRU caches, `folio_batch` only needs to track the number of
> folios, so `nr_pages` is left at zero.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/folio_batch.h | 25 +++++++++++++++++++++++++
>  mm/folio.c                  | 10 +++++++++-
>  mm/internal.h               |  4 ++--
>  3 files changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
> index b45946adc50b..ffc7de091fa3 100644
> --- a/include/linux/folio_batch.h
> +++ b/include/linux/folio_batch.h
> @@ -10,6 +10,7 @@
>  #define _LINUX_FOLIO_BATCH_H
>
>  #include <linux/types.h>
> +#include <linux/mm.h>
>
>  /* 31 pointers + header align the folio_batch structure to a power of tw=
o */
>  #define FOLIO_BATCH_SIZE       31
> @@ -28,6 +29,7 @@ struct folio;
>  struct folio_batch {
>         unsigned char nr;
>         unsigned char i;
> +       unsigned short nr_pages;

Sashiko says
"
Does adding this field break the power-of-two alignment on 32-bit
architectures?
The comment right above this struct says "31 pointers + header align
the folio_batch structure to a power of two". On 32-bit, the 31 pointers
take 124 bytes. Originally, nr, i, and percpu_pvec_drained fit into
3 bytes, allowing the struct to be exactly 128 bytes.
By adding an unsigned short here, the header expands, making the entire
struct 132 bytes and breaking the 128-byte cache alignment. Since the
maximum nr_pages is limited to slightly above FOLIO_BATCH_SIZE (which is 31=
),
could an unsigned char be used instead to preserve the layout?"

sashiko is right, sorry for my poor math. "unsigned char" is really enough.


>         bool percpu_pvec_drained;
>         struct folio *folios[FOLIO_BATCH_SIZE];
>  };
> @@ -42,6 +44,7 @@ static inline void folio_batch_init(struct folio_batch =
*fbatch)
>  {
>         fbatch->nr =3D 0;
>         fbatch->i =3D 0;
> +       fbatch->nr_pages =3D 0;
>         fbatch->percpu_pvec_drained =3D false;
>  }
>
> @@ -49,6 +52,7 @@ static inline void folio_batch_reinit(struct folio_batc=
h *fbatch)
>  {
>         fbatch->nr =3D 0;
>         fbatch->i =3D 0;
> +       fbatch->nr_pages =3D 0;
>  }
>
>  static inline unsigned int folio_batch_count(const struct folio_batch *f=
batch)
> @@ -78,6 +82,27 @@ static inline unsigned folio_batch_add(struct folio_ba=
tch *fbatch,
>         return folio_batch_space(fbatch);
>  }
>
> +/**
> + * folio_batch_add_lru_cache() - Add a folio to a batch of lru_cache
> + * @fbatch: The folio batch.
> + * @folio: The folio to add.
> + *
> + * The folio is added to the end of the batch.
> + * The batch must have previously been initialised using folio_batch_ini=
t().
> + *
> + * Return: 0 if the lru_cache is filled with more than FOLIO_BATCH_SIZE
> + *         pages; otherwise, the number of available slots.
> + */
> +static inline unsigned folio_batch_add_lru_cache(struct folio_batch *fba=
tch,
> +               struct folio *folio)
> +{
> +       fbatch->folios[fbatch->nr++] =3D folio;
> +       fbatch->nr_pages +=3D (unsigned short)folio_nr_pages(folio);
> +       if (fbatch->nr_pages > FOLIO_BATCH_SIZE)
> +               return 0;
> +       return folio_batch_space(fbatch);
> +}
> +
>  /**
>   * folio_batch_next - Return the next folio to process.
>   * @fbatch: The folio batch being processed.
> diff --git a/mm/folio.c b/mm/folio.c
> index 59c477120b9a..e5820d7263e8 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -219,7 +219,7 @@ static void __folio_batch_add_and_move(struct folio_b=
atch __percpu *fbatch,
>         else
>                 local_lock(&cpu_fbatches.lock);
>
> -       if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
> +       if (!folio_batch_add_lru_cache(this_cpu_ptr(fbatch), folio) ||
>                         !folio_may_be_lru_cached(folio) || lru_cache_disa=
bled())
>                 folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
>
> @@ -981,6 +981,7 @@ void folios_put_refs(struct folio_batch *folios, unsi=
gned int *refs)
>         int i, j;
>         struct lruvec *lruvec =3D NULL;
>         unsigned long flags =3D 0;
> +       unsigned long nr_pages =3D 0;
>
>         for (i =3D 0, j =3D 0; i < folios->nr; i++) {
>                 struct folio *folio =3D folios->folios[i];
> @@ -1020,6 +1021,7 @@ void folios_put_refs(struct folio_batch *folios, un=
signed int *refs)
>
>                 if (j !=3D i)
>                         folios->folios[j] =3D folio;
> +               nr_pages +=3D folio_nr_pages(folio);
>                 j++;
>         }
>         if (lruvec)
> @@ -1030,6 +1032,12 @@ void folios_put_refs(struct folio_batch *folios, u=
nsigned int *refs)
>         }
>
>         folios->nr =3D j;
> +       /*
> +        * For lru_cache, track the number of pages; for non-LRU caches,
> +        * folio_batch->nr_pages is always 0.
> +        */
> +       if (folios->nr_pages > 0)
> +               folios->nr_pages =3D nr_pages;

sashiko says:

"It looks like folios->nr_pages is assigned here, but is never actually rea=
d
afterwards.
The function immediately calls mem_cgroup_uncharge_folios() and
free_unref_folios(), neither of which access folios->nr_pages. In fact,
free_unref_folios() resets the entire batch by calling
folio_batch_reinit() before returning.
Can this dead store and the related tracking be removed to avoid overhead
in this hot path?"

I understand that folios->nr_pages is read by
folio_batch_add_lru_cache(), but not by folios_put_refs():

+static inline unsigned folio_batch_add_lru_cache(struct folio_batch *fbatc=
h,
+ struct folio *folio)
+{
+     fbatch->folios[fbatch->nr++] =3D folio;
+     fbatch->nr_pages +=3D (unsigned short)folio_nr_pages(folio);
+     if (fbatch->nr_pages > FOLIO_BATCH_SIZE)
+         return 0;
+     return folio_batch_space(fbatch);
+}

Thanks
Barry


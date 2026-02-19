Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0C3E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0620D6B0088; Thu, 19 Feb 2026 01:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EFE6B0089; Thu, 19 Feb 2026 01:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33086B008A; Thu, 19 Feb 2026 01:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF3516B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:56:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66BE61A0477
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:56:29 +0000 (UTC)
X-FDA: 84460297698.22.4B982F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 731E7140003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:56:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W37Bv/Qo";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv0jjqCZW6K0UsYZxjdhLa4fFJIT6hmRRv5m/ihiq14=;
	b=GDBzQA9YGII2wzqF+FccBqyABku0wB7ogNeXjM/KeENorkn4lQ1QtNiqrSrCR6dRlYE+F/
	IgKf35o19k789m3z9UVHD3pinh+Kq3R1khZ3Di5nGaOVzeu/yDIIWASXQOk0ChDdkNn41m
	6TfbCodVBoqA0JBKgDPX6H5jjXsWOAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484187; a=rsa-sha256;
	cv=none;
	b=6XkV4ArErm3U7pdLP8yhhMejND3s6AG7LX//XAQeqiReSEoryYjpuAIijb1NzKZmBGmcSK
	RbZL+U9JHt5NBALbiJo7qzhuSj9xc1ALqT1H0brGMX7lnSvA2kv4JuAasFHzw/tNq5w0mS
	9eFkPXk8ERLu9LVXJSuo/Hdt7K09R1Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W37Bv/Qo";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E4C34435C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DC7C4AF09
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484186;
	bh=AItOOAYja2tqGc39fO6iBDFywpluhZmJkOohqQpeJ4k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W37Bv/QocybyitKtZNSRWWBxtsJ9BdBLvVevBbpGtCuMF7cj2KSpqiMt+WFTCPX3H
	 6z0nTpaRrQ2DtbuJSuaXGeeUTSZ5Hi41aAiBH0DoVqLqym2mwfisBhCZ8hRs0ckXny
	 3zLw1ZwCUhq4TKivw+7wLHmv2iBBVtFOp0HcBHbeiV9pL2v0Lq3xseDqMcE7yoS4rR
	 oyie/QpdHxSu/fOG/+d8snec2a4JL3SdVOpxJ8s+z9B8Hi5sChBTR2Un1Jev7qxuzY
	 oJ+PQTcqGn2zpOAbadjhZiCjWPiS1zdOyZ4IkDD4yF/NWA4ZPwxFb1cCwPCIO9W6zn
	 +akQMg2l9efOw==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-797d3864d89so7017997b3.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:56:26 -0800 (PST)
X-Gm-Message-State: AOJu0YxD3hrjt34Fh2rvr8EY7VDF8xDToeogoHRDMY0HOL2g1gzDJPv1
	VgSlhVKB02zJFII0/1W0Z0m6bIfmszxlw0qDs3+vQP2AHg5WvmljHyQtCdaDiJU2g/jq8nuyDOw
	pJ2yGsbZT9tPjzhdJHn9ju7zU3asbWlueUCnCvOWYUg==
X-Received: by 2002:a05:690e:d0d:b0:64a:ee56:1520 with SMTP id
 956f58d0204a3-64c21b7f5efmr13690433d50.83.1771484185404; Wed, 18 Feb 2026
 22:56:25 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 22:56:14 -0800
X-Gmail-Original-Message-ID: <CACePvbWtn=5=HCy-3SSKpJoBdY=zSE4Pa0DtfH60wVa6Q0tPHg@mail.gmail.com>
X-Gm-Features: AZwV_QgdwLlOB5kCDhnsFx4CZuxLWCCIFXzS8OXSwNDRO_6xUhlmarko9nrTj-Q
Message-ID: <CACePvbWtn=5=HCy-3SSKpJoBdY=zSE4Pa0DtfH60wVa6Q0tPHg@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] mm/workingset: leave highest bits empty for anon shadow
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: psnf8f7tis4aykayt5umzmxa1ex1mwwf
X-Rspamd-Queue-Id: 731E7140003
X-Rspam-User: 
X-HE-Tag: 1771484187-642710
X-HE-Meta: U2FsdGVkX18b3kGzR2T4Boc+nsccdP6tpf9Vuc16+H6xFhkaP10U1kMxUwaodFZJas2rgHTqf4p/ihlYFqRDRdkalUEd0H/lJfmQ4fjTeqOQvlxpZ+Q6ynP4CLTSNNz2Zb/8jTBuifANNtXk8xfTVYawHpOe3c/gEO0ySAlf+95/Ddpyx/VDdfnAsF7TI0mfHY4hBD7CYn2zOZkw7YieCG6rjeiDrFOpJ4Y0EzT0Tmnp1w0eo/08DpJiuuACulhieeU2HwxXzh6GmZG+yd2zJlzud6o9Nlt7fjEkkAFIAJYo8LPxJmbLYnl7afza1HOnZ3Wrm8BzycKxrRUgFxbI7iKEuN2psGU/R9N9a4wAGRXgTYipy0XQkJ/A6TDdw2NOHgZz2P0Y9HerRZBeWkK/SdIlVxY9WofREGYpgy7GgShwC7491js30inpO5lERE0tsNtUIO4k5rncdfMzhXFjrLZE6DdZq4J3WO+UxAuYTGwIIA0+Q/1xTxVm6aErTaoD6r8/Y0+mY3upD3c7hEyVaHL6+/98y4vfnKRytanUn9DZAXtNsrhtQtdcXq4rNmtvgWG3/a6wJhEcmqsyyVU5SBSiizglXGe97IbR0YafiY3tcshxjpUJhcF7QsCv4n24fwioFbMpcXtga2g4yc/TtfPgLxzTWxCr6MGfnGsMJevg0XYwqK3nkuNupAEYktmcy2x15UVVs7mwj6yb5//IAJxUi3PmswpmzvA6D8+SmmjrXm4uBwEWkMWE8G3q2n7CrVNreWg3xsklCXvzC8LUgJqwek7UmQWLByp/RlrFctJULtNe1q9HSbiyzdPzZbzIMQBTRYppkpn53QZ7EfzsBFXE6pxwvREyBOI6DbsxoLwrBD6NPcLxDNp6ECqfNQHV/zImF5U91qll9Y0pN9A0i8QKPIY3Ib5kW+SJ/j6s6Sl7X5V2B6DPxCZ8uu43IB3BhBvQWN/VnXQm/lqoqvF
 NJvKJoQi
 HcAZPGHn7DIYiW6LAymDxYCHTGIhgSHcguYpj61oRG2hFnSvskzPARBmVYKyp4UmlRoD21DlyysMlloDFGLvKyG2sQwphZQjf6cgk/77kxW14cRF6E7O/zOQFbpzHOtO1ZLqeMxI/iEH78cDvZhJIbwiX8rsLY7z/lNzJvJmz1TEVdi3c4UAx90GHYNzy4yFtpo5rwy0zAovYdUxwCX0oCwo5T22PiJO5r0O3hgsvqnIEv9ErfM756+PJSWMGk4S/JtxTIzWr116XzqdmH/1Hhlvpy7/+lq/jdvcLI/H/VsaoYjeJdo+/X16FJMpTw/6esLKc2xfKzMbkEdQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap table entry will need 4 bits reserved for swap count in the shadow,
> so the anon shadow should have its leading 4 bits remain 0.
>
> This should be OK for the foreseeable future. Take 52 bits of physical
> address space as an example: for 4K pages, there would be at most 40
> bits for addressable pages. Currently, we have 36 bits available (64 - 1
> - 16 - 10 - 1, where XA_VALUE takes 1 bit for marker,
> MEM_CGROUP_ID_SHIFT takes 16 bits, NODES_SHIFT takes <=3D10 bits,
> WORKINGSET flags takes 1 bit).
>
> So in the worst case, we previously need to pack the 40 bits of address
> in 36 bits fields using a 64K bucket (bucket_order =3D 4). After this, th=
e
> bucket will be increased to 1M. Which should be fine, as on such large
> machines, the working set size will be way larger than the bucket size.
>
> And for MGLRU's gen number tracking, it should be even more than enough,
> MGLRU's gen number (max_seq) increment is much slower compared to the
> eviction counter (nonresident_age).
>
> And after all, either the refault distance or the gen distance is only a
> hint that can tolerate inaccuracy just fine.
>
> And the 4 bits can be shrunk to 3, or extended to a higher value if
> needed later.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swap_table.h |  4 ++++
>  mm/workingset.c | 49 ++++++++++++++++++++++++++++++-------------------
>  2 files changed, 34 insertions(+), 19 deletions(-)
>
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index ea244a57a5b7..10e11d1f3b04 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -12,6 +12,7 @@ struct swap_table {
>  };
>
>  #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) =3D=3D PAGE_SIZE)
> +#define SWP_TB_COUNT_BITS              4
>
>  /*
>   * A swap table entry represents the status of a swap slot on a swap
> @@ -22,6 +23,9 @@ struct swap_table {
>   * (shadow), or NULL.
>   */
>
> +/* Macro for shadow offset calculation */
> +#define SWAP_COUNT_SHIFT       SWP_TB_COUNT_BITS
> +
>  /*
>   * Helpers for casting one type of info into a swap table entry.
>   */
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 13422d304715..37a94979900f 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -16,6 +16,7 @@
>  #include <linux/dax.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include "swap_table.h"
>  #include "internal.h"
>
>  /*
> @@ -184,7 +185,9 @@
>  #define EVICTION_SHIFT ((BITS_PER_LONG - BITS_PER_XA_VALUE) +  \
>                          WORKINGSET_SHIFT + NODES_SHIFT + \
>                          MEM_CGROUP_ID_SHIFT)
> +#define EVICTION_SHIFT_ANON    (EVICTION_SHIFT + SWAP_COUNT_SHIFT)
>  #define EVICTION_MASK  (~0UL >> EVICTION_SHIFT)
> +#define EVICTION_MASK_ANON     (~0UL >> EVICTION_SHIFT_ANON)
>
>  /*
>   * Eviction timestamps need to be able to cover the full range of
> @@ -194,12 +197,12 @@
>   * that case, we have to sacrifice granularity for distance, and group
>   * evictions into coarser buckets by shaving off lower timestamp bits.
>   */
> -static unsigned int bucket_order __read_mostly;
> +static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
>
>  static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long ev=
iction,
> -                        bool workingset)
> +                        bool workingset, bool file)
>  {
> -       eviction &=3D EVICTION_MASK;
> +       eviction &=3D file ? EVICTION_MASK : EVICTION_MASK_ANON;
>         eviction =3D (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
>         eviction =3D (eviction << NODES_SHIFT) | pgdat->node_id;
>         eviction =3D (eviction << WORKINGSET_SHIFT) | workingset;
> @@ -244,7 +247,8 @@ static void *lru_gen_eviction(struct folio *folio)
>         struct mem_cgroup *memcg =3D folio_memcg(folio);
>         struct pglist_data *pgdat =3D folio_pgdat(folio);
>
> -       BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVI=
CTION_SHIFT);
> +       BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
> +                    BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_A=
NON));
>
>         lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>         lrugen =3D &lruvec->lrugen;
> @@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct folio *folio)
>         hist =3D lru_hist_from_seq(min_seq);
>         atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
>
> -       return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, wo=
rkingset);
> +       return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, wo=
rkingset, type);
>  }
>
>  /*
> @@ -262,7 +266,7 @@ static void *lru_gen_eviction(struct folio *folio)
>   * Fills in @lruvec, @token, @workingset with the values unpacked from s=
hadow.
>   */
>  static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
> -                               unsigned long *token, bool *workingset)
> +                               unsigned long *token, bool *workingset, b=
ool file)
>  {
>         int memcg_id;
>         unsigned long max_seq;
> @@ -275,7 +279,7 @@ static bool lru_gen_test_recent(void *shadow, struct =
lruvec **lruvec,
>         *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>
>         max_seq =3D READ_ONCE((*lruvec)->lrugen.max_seq);
> -       max_seq &=3D EVICTION_MASK >> LRU_REFS_WIDTH;
> +       max_seq &=3D (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_R=
EFS_WIDTH;

Nit pick, I saw you use this expression more than once:
"file ? EVICTION_MASK : EVICTION_MASK_ANON"

Maybe make it an inline function or macro?

>
>         return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
>  }
> @@ -293,7 +297,7 @@ static void lru_gen_refault(struct folio *folio, void=
 *shadow)
>
>         rcu_read_lock();
>
> -       recent =3D lru_gen_test_recent(shadow, &lruvec, &token, &workings=
et);
> +       recent =3D lru_gen_test_recent(shadow, &lruvec, &token, &workings=
et, type);
>         if (lruvec !=3D folio_lruvec(folio))
>                 goto unlock;
>
> @@ -331,7 +335,7 @@ static void *lru_gen_eviction(struct folio *folio)
>  }
>
>  static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
> -                               unsigned long *token, bool *workingset)
> +                               unsigned long *token, bool *workingset, b=
ool file)
>  {
>         return false;
>  }
> @@ -381,6 +385,7 @@ void workingset_age_nonresident(struct lruvec *lruvec=
, unsigned long nr_pages)
>  void *workingset_eviction(struct folio *folio, struct mem_cgroup *target=
_memcg)
>  {
>         struct pglist_data *pgdat =3D folio_pgdat(folio);
> +       int file =3D folio_is_file_lru(folio);
>         unsigned long eviction;
>         struct lruvec *lruvec;
>         int memcgid;
> @@ -397,10 +402,10 @@ void *workingset_eviction(struct folio *folio, stru=
ct mem_cgroup *target_memcg)
>         /* XXX: target_memcg can be NULL, go through lruvec */
>         memcgid =3D mem_cgroup_private_id(lruvec_memcg(lruvec));
>         eviction =3D atomic_long_read(&lruvec->nonresident_age);
> -       eviction >>=3D bucket_order;
> +       eviction >>=3D bucket_order[file];
>         workingset_age_nonresident(lruvec, folio_nr_pages(folio));
>         return pack_shadow(memcgid, pgdat, eviction,
> -                               folio_test_workingset(folio));
> +                          folio_test_workingset(folio), file);
>  }
>
>  /**
> @@ -431,14 +436,15 @@ bool workingset_test_recent(void *shadow, bool file=
, bool *workingset,
>                 bool recent;
>
>                 rcu_read_lock();
> -               recent =3D lru_gen_test_recent(shadow, &eviction_lruvec, =
&eviction, workingset);
> +               recent =3D lru_gen_test_recent(shadow, &eviction_lruvec, =
&eviction,
> +                                            workingset, file);
>                 rcu_read_unlock();
>                 return recent;
>         }
>
>         rcu_read_lock();
>         unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
> -       eviction <<=3D bucket_order;
> +       eviction <<=3D bucket_order[file];
>
>         /*
>          * Look up the memcg associated with the stored ID. It might
> @@ -495,7 +501,8 @@ bool workingset_test_recent(void *shadow, bool file, =
bool *workingset,
>          * longest time, so the occasional inappropriate activation
>          * leading to pressure on the active list is not a problem.
>          */
> -       refault_distance =3D (refault - eviction) & EVICTION_MASK;
> +       refault_distance =3D ((refault - eviction) &
> +                           (file ? EVICTION_MASK : EVICTION_MASK_ANON));

Here too.

Chris

>
>         /*
>          * Compare the distance to the existing workingset size. We
> @@ -780,8 +787,8 @@ static struct lock_class_key shadow_nodes_key;
>
>  static int __init workingset_init(void)
>  {
> +       unsigned int timestamp_bits, timestamp_bits_anon;
>         struct shrinker *workingset_shadow_shrinker;
> -       unsigned int timestamp_bits;
>         unsigned int max_order;
>         int ret =3D -ENOMEM;
>
> @@ -794,11 +801,15 @@ static int __init workingset_init(void)
>          * double the initial memory by using totalram_pages as-is.
>          */
>         timestamp_bits =3D BITS_PER_LONG - EVICTION_SHIFT;
> +       timestamp_bits_anon =3D BITS_PER_LONG - EVICTION_SHIFT_ANON;
>         max_order =3D fls_long(totalram_pages() - 1);
> -       if (max_order > timestamp_bits)
> -               bucket_order =3D max_order - timestamp_bits;
> -       pr_info("workingset: timestamp_bits=3D%d max_order=3D%d bucket_or=
der=3D%u\n",
> -              timestamp_bits, max_order, bucket_order);
> +       if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
> +               bucket_order[WORKINGSET_FILE] =3D max_order - timestamp_b=
its;
> +       if (max_order > timestamp_bits_anon)
> +               bucket_order[WORKINGSET_ANON] =3D max_order - timestamp_b=
its_anon;
> +       pr_info("workingset: timestamp_bits=3D%d (anon: %d) max_order=3D%=
d bucket_order=3D%u (anon: %d)\n",
> +               timestamp_bits, timestamp_bits_anon, max_order,
> +               bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_AN=
ON]);
>
>         workingset_shadow_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE=
 |
>                                                     SHRINKER_MEMCG_AWARE,
>
> --
> 2.52.0
>
>


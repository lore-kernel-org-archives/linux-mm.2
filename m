Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1884C606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M09S19cX
Received: by kanga.kvack.org (Postfix)
	id 33A6E6B05B2; Fri,  6 Nov 2026 17:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311F96B05B3; Fri,  6 Nov 2026 17:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227A96B05B4; Fri,  6 Nov 2026 17:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3C7A6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:30:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E5C6140248
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:30:53 +0000 (UTC)
X-FDA: 85406140386.13.BFD1056
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8AD4240010
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:30:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M09S19cX;
	spf=pass (imf01.hostedemail.com: domain of fvdl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7km9XbIZetC0r5re3sewHW/q1xGLE5OrcXCR5UGQTt8=;
	b=y1gRZKDtYgyFAhcsApkAZoh5Mw3vR+X6K7Cmunim/0cyKUaAFBlYTl9CirgLSWGoLUfxdT
	ayyu1Vf4PlBnZcEvZ40xf+0n80lzo1JA3nkl7a+bjASsSTGqlBknSTntPCfyouakDeg3Ac
	5OV0u11fjZVS1ziBrblcsrZ4pBlyDA4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794004251;
	b=veC+tZmCESPd399AJRbyplvx2OKDe8UJ6ZfO/tkZPfK8Rb8y3XajZwT5xZVjW6UEhW2hoz
	97k3XcUgEmTYbw+pnozmQRd/NW1xL99YX1V6qOieXAqpHIBaRboGLkIIs6E4m0wzrq2tOX
	UZNg3Je7RbzRIMMbt2/BBl/nuJaimno=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M09S19cX;
	spf=pass (imf01.hostedemail.com: domain of fvdl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5383c97c8cfso8951cf.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 14:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794004251; cv=none;
        d=google.com; s=arc-20260327;
        b=kS1qVzfgiG67Hiz6C4Rrzo790X/NV7xRjljB5ar/AN1kG2izxmZrqvwqg8V9Q2tDLg
         Gfy4F6LW/n6f3hAUpIMB5YYNwV6t9rpV0Vvqw+6meVITv5cAUQo+c8R+CgAmG9UwzR9v
         HxPwPEoGJHAyFd4BaXKpJ7HwuaIEyq82DZ9LaxRSWuJNH2qzwY6F1V5ULL4dxDKy+mSk
         tV7qs+a0pEF3Q1zQqgkfVZ3ldn5nOjZgO2eC77/OQKMhk4CCcXNHoEU4LXTE911HpIWa
         upk/3e8jcdxGdh9inp/Ts5F2ZdSNqkgmofSYA1500omp5tgI81pHlS/bonUHx8JwtPYp
         4sBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7km9XbIZetC0r5re3sewHW/q1xGLE5OrcXCR5UGQTt8=;
        fh=UXquDCMSsfOQyXrFf9Jmfq+pbqGMY9llI0/HwPI6csI=;
        b=lrC67sp0vmPWdyL+euda34811+pXLYNqCPpMuOG6LRWgCTN1ZXVSP/+RztswHyCxJL
         i6WcERfDN7xKICHvkiqyinqQaBoDpdcp1fueSMPv2QqSmYQTXHPDW43/1XCJdyv7NiE4
         R7OLJb9pTkrLv2IUiix22vpAdnz7QuOG9QPVvPcBhWcBXEHL7XEQ0VeEsX0lV4ftsvyY
         2aYENGCGty1IWZRdIFwR8tVq4WkZDQCcGPVRES8ZhBtb/M9PU8AoHuuZpj7O9/4tiTsF
         JuhsqXSlJSzPo9Pf1m5EWV9kmVn3ihnayyWLlX1X29GsTs5Kwu1oqfrin2EwbVSDy7oG
         12Mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794004251; x=1794609051; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7km9XbIZetC0r5re3sewHW/q1xGLE5OrcXCR5UGQTt8=;
        b=M09S19cXlKbP1xjK11jBwWJ3vWFFs/jDvhekovHJq20Ao37rOkHW2ydwJdzrdy46KM
         tqkGQqCNktFfzIPgBc6B0Oo1ilMZLcwBXRltkcfzQucHDqk1P8fm4UibO29tbl3pnYNs
         1bl+SIoWX8buHs0VL5tpKSAUGvlzCeQysM8OYnXSzR7B3RdVRv5TJUt6UDNCymZTq1as
         MLsPieVoLY174h2AnGSkmAiyiZMB1xsO7xty6RMFSGaQw/WOOKH17sxqUhNuhqgo7VtG
         PlJqHSQfDJJKHEqEtDpkoZa5yytQZELf/0IDKDIVUZapZePxyxZuSjKz4jnDEgu5t4V5
         Ti+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794004251; x=1794609051;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7km9XbIZetC0r5re3sewHW/q1xGLE5OrcXCR5UGQTt8=;
        b=FJVKAvgWs921OCu3lr/61z6wAGN32XpJsBW0NIgM+PL9rWS7E87MuUOn+ORU1s/IQ3
         +VibnG3wzE7ZikdF5dPhzjd7BEpG7moPm/kivpyfHnRb5cDzKMV5Z5BaxeyyJnkXXanu
         x9jfXS4GxH8seSfoTgHoU8U3zgpZ2DKHcZ7mSl1wSsfE4hps+BVAVYLrfpKfDG2q7wDv
         82AlISzo88YFZvsxX4oHgsOex0gFtYxcfIU+b30grUde+ZTpMzPNoY6YkJI3vN0xUels
         HHWLSyPWd04lr15JRcoUFRGvgDR6WF/Kz3o5n2RoAkTiSm5YBOdPYFn+3QDEtJi8ZXuX
         WUkw==
X-Forwarded-Encrypted: i=1; AKwUvBxXn6yv6NQ/JJa9/brZRCf5aRf3bXaVZY5M70yOM3JcOq6oxsqrx8zgsRLdqsRc1K8xUbRkiKR8Ag==@kvack.org
X-Gm-Message-State: APuU4Z/AQZvSo6PBAN/u+rUVkkdlv4vXr843KSK7u0VkoNfA287LBw8s
	U1YO66q0Tq4+Na4fuxo5Q6h48GHiOleGTFHxFQ/K3DPpGQwQ+KO7luUts7Xq6DfFIfsd5SPLC+z
	5AGWE9YCLyscKxtTIzky/SMM+JfiV6fyP6O4E7Vix
X-Gm-Gg: AYBFou1lYXCxd+TPQGXA7kcWb+H+lnOcNKm3+CaLk8UiI1R0UQuRLY/6GqRVporbHYK
	gEcyRS1jfYagKYuhjwyUmHkcJY0qJ/5gAZJaDlc7uexOLbp/gDOe6PfPRwQKrB7+p5BDLbA9LHC
	rkJUvKEeD9XmNfrIAQoZVvEPcd8xngSnqBWu4QwMcc/LsBhOmQzywE69FkN+MsTjVmtAMYjTx3G
	b4hZ073E91xUz9UH2UIYx52NrFBz/0E9h65OJ6+4b5VDzrcnFHsOHISF74+zJd8BEKqQp2bYJkC
	1sGAHmhYT6ZKASV+7JOetTMyiYMwlkc40nt4NVdKAWmgMbXpDZGKAtRS/ZKIRnkE0aaKDDsf6jd
	UA/gSf6am9+AGAjxVT6V8rJa5B2WHxP9K7Qg1
X-Received: by 2002:ac8:6f10:0:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-54f9ab01486mr4142751cf.0.1794004249631; Fri, 06 Nov 2026
 14:30:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
In-Reply-To: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 6 Nov 2026 14:30:38 -0800
X-Gm-Features: AclHuK90lFsqv1keBn7-ZLmlCrya18UgcO7zKAXShu8o4byRhpln0OSfr_V_EHM
Message-ID: <CAPTztWYzN1mkADOAJ3bskqpsv9c7qXNSMUdj_Ovg-aDQJDDmow@mail.gmail.com>
Subject: Re: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8AD4240010
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: yygutfbqy15msgu4ywuog48zmtrpu8qp
X-Rspam-User: 
X-HE-Tag: 1794004251-948463
X-HE-Meta: U2FsdGVkX1+Y4PqW1fcBpOqLDl9HrUH69+0wWZ1aR99Kme3YQ32g/exTsOoz8bVprqiJPHVoQdebVNXWgyNBt9HayswCCF+Q8i/c5RK7OCt5/2kPXJc9iu2f6l9vpRI9xlO2i+NsaQ6Na+aqjiTcoCga2vuIOLL91pY1bAaSiS86KJ9hYgMaDTx2AfBqhpA0pzupFCoLFqckXbYzoeCNfygUJKz5sPEatNHKhGtrVk9gs2CasSwTfytVADFID6ihmW0Xg0m0i1FDPApXcmnl3oIBD2Ps7PYXEV22BC9ARR9UQLzWlLtHZNeNgK9G5CEaC3r8LnZq1BryCVkLpaUoW2SFraDuFrwq3+jmLCy7BEI1KfjUl5mwCidopADX7A+jILqg/rdx3Vt0TgqPofZJZPDMGNy62zhurOHRYjYHAazs3AzPK9QcasuO3iMcfllOYY21y+TnFBM2TskeE0pT0RPCikgvkyxq2iH7ukHT6XJrR1OMmaPk0jzrXDKR0j+70rz+meps4h7uaMMWJABN/NJXCI7OIrqV0+Ee8MU+SbkQZul3dIV6mr3TQbTDhAjzRhtke3NYvO5UIu3pXlvQwk9NzJbHB50E6yJ3fr2Cw/8u9fph1vCpOmTMCraP1qHqBwsEOhIAKUn8qHG5AOBRn5KUxzE5P7t4vKd9TLmjjRhCBsqlu6HuVl8uleVUGTjlmB3jXL1QhAFBh5rvq83HctYMaVBpGsczx57cnmtJLO5QerW5FGaY8XCCgN6VxplefvNJhgE5GF+/r2/J2XDnDHtlyRFL/+mGnk+7y+B+WG+QkfXllYXXMxuCq5MwovJYQrDnzm9rTpMuRp/cv0L+f+ReigN6aB/S96MGFiIEF49BSrRliKOCd3jl9HQe7E7lYlqqWmTvlPSc7bkzNf+rUQCSXJOt0R9DXgxHTzG3NUO3eVoITRWvFqWmaBj1/M19aYaP4zhGwSUDxk3mWO4
 6/KVfVDL
 MCqd5J4XKNcG4w4zjapFsDRhXeVbBeMhet3s42T2P8l4qiihcy2j1o38wgKkc1+Ip+OHjqh/p+AaNAGAoGgy3ND2bqNagrPODZO8vNKJ83ZMvAt8QldDUZ9DoyvR/7SmThmurbsyRclKl3RhSjy3LoV301xIZ65XV9RFIzY1UE4SrSWC2d2mlN2tkorQZRcGf7gvw962DQhJDvr41pzjOTRppbYFS2PApGWIfkJzf+yVjrY0xB23sdwx0W1CMqhHwQWAW65EmYf8vtg9Ee1Lp1x9oOFADIyeyJkUI43NyTUym3VQvA1CIWgj24iW7wmoDJRRPhS9n5mYB4rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 4:56=E2=80=AFAM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
>
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
>
> This implementation has two bugs:
>
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
>
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
>
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
>
> And overall it is a lot of list management and open coded range
> selection for no real gain.
>
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
>
> After successful alocation sort the cma->ranges by their base address.
>
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.
>
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if req=
uested")
> Reported-by: Ivy Lopez <skunkolee@gmail.com>
> Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.=
com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/cma.c | 265 +++++++++++++++++++--------------------------------------=
------
>  1 file changed, 77 insertions(+), 188 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index f61d52796f4ef..ef0c49985067d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -23,8 +23,8 @@
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> -#include <linux/string_choices.h>
>  #include <linux/log2.h>
> +#include <linux/sort.h>
>  #include <linux/cma.h>
>  #include <linux/highmem.h>
>  #include <linux/io.h>
> @@ -310,56 +310,6 @@ int __init cma_init_reserved_mem(phys_addr_t base, p=
hys_addr_t size,
>         return 0;
>  }
>
> -/*
> - * Structure used while walking physical memory ranges and finding out
> - * which one(s) to use for a CMA area.
> - */
> -struct cma_init_memrange {
> -       phys_addr_t base;
> -       phys_addr_t size;
> -       struct list_head list;
> -};
> -
> -/*
> - * Work array used during CMA initialization.
> - */
> -static struct cma_init_memrange memranges[CMA_MAX_RANGES] __initdata;
> -
> -static bool __init revsizecmp(struct cma_init_memrange *mlp,
> -                             struct cma_init_memrange *mrp)
> -{
> -       return mlp->size > mrp->size;
> -}
> -
> -static bool __init basecmp(struct cma_init_memrange *mlp,
> -                          struct cma_init_memrange *mrp)
> -{
> -       return mlp->base < mrp->base;
> -}
> -
> -/*
> - * Helper function to create sorted lists.
> - */
> -static void __init list_insert_sorted(
> -       struct list_head *ranges,
> -       struct cma_init_memrange *mrp,
> -       bool (*cmp)(struct cma_init_memrange *lh, struct cma_init_memrang=
e *rh))
> -{
> -       struct list_head *mp;
> -       struct cma_init_memrange *mlp;
> -
> -       if (list_empty(ranges))
> -               list_add(&mrp->list, ranges);
> -       else {
> -               list_for_each(mp, ranges) {
> -                       mlp =3D list_entry(mp, struct cma_init_memrange, =
list);
> -                       if (cmp(mlp, mrp))
> -                               break;
> -               }
> -               __list_add(&mrp->list, mlp->list.prev, &mlp->list);
> -       }
> -}
> -
>  static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
>  {
>         if (IS_ENABLED(CONFIG_HIGHMEM)) {
> @@ -524,37 +474,71 @@ static int __init __cma_declare_contiguous_nid(phys=
_addr_t *basep,
>         return 0;
>  }
>
> +/*
> + * Find the largest free range above 4G that can hold a part of a multi-=
range
> + * CMA area.
> + */
> +static phys_addr_t __init cma_find_free_range(phys_addr_t align,
> +               phys_addr_t size_align, int nid, phys_addr_t *basep)
> +{
> +       phys_addr_t start, end, size;
> +       phys_addr_t max =3D 0;
> +       u64 i;
> +
> +       for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL=
) {
> +               if (start < SZ_4G)
> +                       continue;
> +
> +               start =3D ALIGN(start, align);
> +               if (start >=3D end)
> +                       continue;
> +
> +               size =3D ALIGN_DOWN(end - start, size_align);
> +               if (size > max) {
> +                       max =3D size;
> +                       *basep =3D start;
> +               }
> +       }
> +
> +       return max;
> +}
> +
> +static int __init cma_range_cmp(const void *a, const void *b)
> +{
> +       const struct cma_memrange *cmr_a =3D a;
> +       const struct cma_memrange *cmr_b =3D b;
> +
> +       return cmp_int(cmr_a->base_pfn, cmr_b->base_pfn);
> +}
> +
>  /*
>   * Create CMA areas with a total size of @total_size. A normal allocatio=
n
> - * for one area is tried first. If that fails, the biggest memblock
> - * ranges above 4G are selected, and allocated bottom up.
> - *
> - * The complexity here is not great, but this function will only be
> - * called during boot, and the lists operated on have fewer than
> - * CMA_MAX_RANGES elements (default value: 8).
> + * for one area is tried first. If that fails, the area is assembled fro=
m
> + * up to CMA_MAX_RANGES of the biggest free memblock ranges above 4G.
>   */
>  int __init cma_declare_contiguous_multi(phys_addr_t total_size,
>                         phys_addr_t align, unsigned int order_per_bit,
>                         const char *name, struct cma **res_cma, int nid)
>  {
> -       phys_addr_t start =3D 0, end;
> -       phys_addr_t size, sizesum, sizeleft;
> -       struct cma_init_memrange *mrp, *mlp, *failed;
> +       unsigned long size_mb =3D (unsigned long)total_size / SZ_1M;
> +       phys_addr_t size, remaining, size_align;
>         struct cma_memrange *cmrp;
> -       LIST_HEAD(ranges);
> -       LIST_HEAD(final_ranges);
> -       struct list_head *mp, *next;
> -       int ret, nr =3D 1;
> -       u64 i;
> +       phys_addr_t start =3D 0;
>         struct cma *cma;
> +       int nr =3D 0;
> +       int ret;
>
>         /*
>          * First, try it the normal way, producing just one range.
>          */
>         ret =3D __cma_declare_contiguous_nid(&start, total_size, 0, align=
,
>                         order_per_bit, false, name, res_cma, nid);
> +       if (!ret) {
> +               pr_info("Reserved %lu MiB at %pa\n", size_mb, &start);
> +               return 0;
> +       }
>         if (ret !=3D -ENOMEM)
> -               goto out;
> +               goto err;
>
>         /*
>          * Couldn't find one range that fits our needs, so try multiple
> @@ -572,151 +556,56 @@ int __init cma_declare_contiguous_multi(phys_addr_=
t total_size,
>          * aligned to @align, and a size that is aligned to
>          * both @align and @order_to_bit, things will work out.
>          */
> -       nr =3D 0;
> -       sizesum =3D 0;
> -       failed =3D NULL;
> -
>         ret =3D cma_new_area(name, total_size, order_per_bit, &cma);
> -       if (ret !=3D 0)
> -               goto out;
> +       if (ret)
> +               goto err;
>
>         align =3D max_t(phys_addr_t, align, CMA_MIN_ALIGNMENT_BYTES);
> -       /*
> -        * Create a list of ranges above 4G, largest range first.
> -        */
> -       for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL=
) {
> -               if (upper_32_bits(start) =3D=3D 0)
> -                       continue;
> -
> -               start =3D ALIGN(start, align);
> -               if (start >=3D end)
> -                       continue;
> -
> -               end =3D ALIGN_DOWN(end, align);
> -               if (end <=3D start)
> -                       continue;
> +       size_align =3D max_t(phys_addr_t, align, PAGE_SIZE << order_per_b=
it);
>
> -               size =3D end - start;
> -               size =3D ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
> +       remaining =3D total_size;
> +       while (remaining && nr < CMA_MAX_RANGES) {
> +               size =3D cma_find_free_range(align, size_align, nid, &sta=
rt);
>                 if (!size)
> -                       continue;
> -               sizesum +=3D size;
> -
> -               pr_debug("consider %016llx - %016llx\n", (u64)start, (u64=
)end);
> -
> -               /*
> -                * If we don't yet have used the maximum number of
> -                * areas, grab a new one.
> -                *
> -                * If we can't use anymore, see if this range is not
> -                * smaller than the smallest one already recorded. If
> -                * not, re-use the smallest element.
> -                */
> -               if (nr < CMA_MAX_RANGES)
> -                       mrp =3D &memranges[nr++];
> -               else {
> -                       mrp =3D list_last_entry(&ranges,
> -                                             struct cma_init_memrange, l=
ist);
> -                       if (size < mrp->size)
> -                               continue;
> -                       list_del(&mrp->list);
> -                       sizesum -=3D mrp->size;
> -                       pr_debug("deleted %016llx - %016llx from the list=
\n",
> -                               (u64)mrp->base, (u64)mrp->base + size);
> -               }
> -               mrp->base =3D start;
> -               mrp->size =3D size;
> -
> -               /*
> -                * Now do a sorted insert.
> -                */
> -               list_insert_sorted(&ranges, mrp, revsizecmp);
> -               pr_debug("added %016llx - %016llx to the list\n",
> -                   (u64)mrp->base, (u64)mrp->base + size);
> -               pr_debug("total size now %llu\n", (u64)sizesum);
> -       }
> -
> -       /*
> -        * There is not enough room in the CMA_MAX_RANGES largest
> -        * ranges, so bail out.
> -        */
> -       if (sizesum < total_size) {
> -               cma_drop_area(cma);
> -               ret =3D -ENOMEM;
> -               goto out;
> -       }
> -
> -       /*
> -        * Found ranges that provide enough combined space.
> -        * Now, sorted them by address, smallest first, because we
> -        * want to mimic a bottom-up memblock allocation.
> -        */
> -       sizesum =3D 0;
> -       list_for_each_safe(mp, next, &ranges) {
> -               mlp =3D list_entry(mp, struct cma_init_memrange, list);
> -               list_del(mp);
> -               list_insert_sorted(&final_ranges, mlp, basecmp);
> -               sizesum +=3D mlp->size;
> -               if (sizesum >=3D total_size)
>                         break;
> -       }
>
> -       /*
> -        * Walk the final list, and add a CMA range for
> -        * each range, possibly not using the last one fully.
> -        */
> -       nr =3D 0;
> -       sizeleft =3D total_size;
> -       list_for_each(mp, &final_ranges) {
> -               mlp =3D list_entry(mp, struct cma_init_memrange, list);
> -               size =3D min(sizeleft, mlp->size);
> -               if (memblock_reserve(mlp->base, size)) {
> -                       /*
> -                        * Unexpected error. Could go on to
> -                        * the next one, but just abort to
> -                        * be safe.
> -                        */
> -                       failed =3D mlp;
> +               size =3D min(size, remaining);
> +               if (memblock_reserve(start, size))
>                         break;
> -               }
> -
> -               accept_memory(mlp->base, size);
> +               accept_memory(start, size);
>
>                 pr_debug("created region %d: %016llx - %016llx\n",
> -                   nr, (u64)mlp->base, (u64)mlp->base + size);
> +                   nr, (u64)start, (u64)start + size);
>                 cmrp =3D &cma->ranges[nr++];
> -               cmrp->base_pfn =3D PHYS_PFN(mlp->base);
> +               cmrp->base_pfn =3D PHYS_PFN(start);
>                 cmrp->early_pfn =3D cmrp->base_pfn;
>                 cmrp->count =3D size >> PAGE_SHIFT;
>
> -               sizeleft -=3D size;
> -               if (sizeleft =3D=3D 0)
> -                       break;
> +               remaining -=3D size;
>         }
>
> -       if (failed) {
> -               list_for_each(mp, &final_ranges) {
> -                       mlp =3D list_entry(mp, struct cma_init_memrange, =
list);
> -                       if (mlp =3D=3D failed)
> -                               break;
> -                       memblock_phys_free(mlp->base, mlp->size);
> -               }
> -               cma_drop_area(cma);
> +       if (remaining) {
>                 ret =3D -ENOMEM;
> -               goto out;
> +               goto err_free_ranges;
>         }
>
> +       /* allocate from lower addresses first */
> +       sort(cma->ranges, nr, sizeof(cma->ranges[0]), cma_range_cmp, NULL=
);
> +
>         cma->nranges =3D nr;
>         cma->nid =3D nid;
>         *res_cma =3D cma;
>
> -out:
> -       if (ret !=3D 0)
> -               pr_err("Failed to reserve %lu MiB\n",
> -                       (unsigned long)total_size / SZ_1M);
> -       else
> -               pr_info("Reserved %lu MiB in %d range%s\n",
> -                       (unsigned long)total_size / SZ_1M, nr, str_plural=
(nr));
> +       pr_info("Reserved %lu MiB in %d ranges\n", size_mb, nr);
> +       return 0;
> +
> +err_free_ranges:
> +       for (int i =3D 0; i < nr; i++)
> +               memblock_phys_free(PFN_PHYS(cma->ranges[i].base_pfn),
> +                                  PFN_PHYS(cma->ranges[i].count));
> +       cma_drop_area(cma);
> +err:
> +       pr_err("Failed to reserve %lu MiB\n", size_mb);
>         return ret;
>  }
>
>
> ---
> base-commit: b3710a1d0f145a4f6f1d44fdaff56a6af8cffe89
> change-id: 20261106-cma-multi-ff88e84bf599
>
> --
> Sincerely yours,
> Mike.
>

Thanks for cleaning this up. You're right, what I did with the list
sorting was too much, and it contained some bugs too.

Just one remark here: I don't think you need to sort the ranges by
base address at the end, I am not aware of anything relying on the CMA
ranges being sorted. The sorting was just there to mimic bottom-up
memblock allocations while acquiring the ranges, but the eventual
result doesn't need to be sorted. I'm not aware of any CMA code that
relies on this.

- Frank


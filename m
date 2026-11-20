Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2223160A2607
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qh78vZCr
Received: by kanga.kvack.org (Postfix)
	id 212F16B05B1; Fri, 20 Nov 2026 18:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CFF6B05B2; Fri, 20 Nov 2026 18:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0160E6B05B3; Fri, 20 Nov 2026 18:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C25BD6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:25:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38962A024D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:25:51 +0000 (UTC)
X-FDA: 85457082102.08.1AF12E0
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46456A0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:25:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qh78vZCr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795217149;
	b=iEaYDokBnH+FLVA5ychTD0ZF/KYvXiUxMh0iYFPVZrthEQ08E3Kv01BCTWuJGgRPDiplJY
	bWD21tq8u9t7UX/rlorli9LEAis+KLoxq5hVt6Aq1ytdvn5MF3deSLcw0+lYyW+6jI95a6
	15G5C+4/oDtTe6zFdZxei4PNwVTL8qM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795217149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhqyN4jXJHLUBn1qwHjxlBTy4/pOd3Ul8pRQ56L+gFg=;
	b=QOaG7uia8OKbalyYEW2zqty1ewgXpf3QF+/GbCM475lcNHBIZ/g9Og9rkBxueKL9yYD1ks
	anpK5pPMkqgk5SpvwLehHNFUAek9X37t5m/xpULIpuNQMJoeKYV4Pk/KFF0YwkKfc5ObZy
	GeFbCLfkRucwiVmv7bqtK3MzwVC5lOM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qh78vZCr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so15786235e9.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795217148; cv=none;
        d=google.com; s=arc-20260327;
        b=jKuV3fADcqai+wOlsZtuZHNFS1lZpienGwLQ4/idIlleBFSEegb7JcrS2AWc5sn2tG
         FDbvSlD5BKbAXNMmy9QlqjW3O5vahA8pdiOyIlQzDzUOStkl2z5kTKa6Yh7ri9JYkqsK
         Lb4PSjz6ceaeQTUq5mxi5WAwKAUrcazn3OpSg+5z6qZron21ngOk1NqWkwXTL4Boy8rk
         IFAwXJ+M/jQgkoy0GONzZ1jrFefumQhWn1cE+M6xDSfQjoU3sk0R66Z9xoMQEDyljMKB
         cnVkOrHHdSQIoi2vN8nKd90okLG0mMoIgHu+929RHzLtfhezeF0WmWX25biucGai/Uqy
         QIyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uhqyN4jXJHLUBn1qwHjxlBTy4/pOd3Ul8pRQ56L+gFg=;
        fh=CvMM8bCAicuo9oaACOYCr4KU6foAmbL6RvmJkIeZX8Q=;
        b=E67W5oArr4dzu2jrzyi1poIwIthj9YlqvwHade657ZL8rbB4HpZShkhhvLSD0BMy+a
         MBKo4zuCiRUukYHqQrLhFyUyyGA0sACou096cdEgP+vszoJnhIUZiCYvvRx1nQyF4L4g
         rPux3MaviFLivrgLPcnNpZmTUZcfH/qAVuxiP+5jqnCUfDqtnC1n3HDRWSbQq/Nb7SaU
         +/T5lRSmVOlHaTrrZHqJE+9LKar6lzqsGhckcmIwU0tv4qb/KqWMr/Z2V8iDpva0eF7z
         GgnettWLpddLzxauRcbghTMnqbId9W00ImC5xhuMeR6wqE3UFV7LCn9xEb8JNh46aqVU
         20PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795217148; x=1795821948; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uhqyN4jXJHLUBn1qwHjxlBTy4/pOd3Ul8pRQ56L+gFg=;
        b=Qh78vZCr+UxzioSxsrJgpdpVHhFhFTd7dNTDNSYDasUF8SqqRxp+uLUGgpPVGkvsla
         hMoiVo1rZxlCIOuM0avupYEv+/Trs2bnfIPSNSe7ZTMXxgI/ne94Q3p3Xruvt1SFr3mG
         x1+/JKIgZ1oSVF+EZMvg0TwjOEliq6eOKdOKhfYcjYYHHfDzdOQqycGx1GS4ESmwsJP6
         zOjWJr1lIx0DkenHKWS8MG0RY2WGNKqPB/whCRQdWYpAUKeEa5Aoib+hkzaNUHb5R3yi
         Xjnm8Ea8+QRPX57vEtxdkybIcHQAIxHrMWKlNAXm2nxKySB0EEhPboMmgJrQMQBj/zbp
         Xlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795217148; x=1795821948;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhqyN4jXJHLUBn1qwHjxlBTy4/pOd3Ul8pRQ56L+gFg=;
        b=VCkUQ6Egp4soTHcAs9yUatXQ6eajYxtmwhOVwd84pu0HffBAu5O45eaqqrIXhkk2oi
         GasnXrjjIACplJUnIvjS5UNGlwTC8PTgplfkc3UIg7f5xOYme4+IypKxbmgUlKXXObqI
         bdcK38mxYIif7cbYOSqhM3v4RBkHr9lii13ssoDNhWNfFYDznS0fiOBlgL6zz3TWnv1u
         t18atDR6Ex1G8DyuGNK7/u7NuGyo0sLV+1Wx7al6f2Mli0gADIFaV3m17nGtJDXGq3ro
         bOV9+SdjD6FIVE1UnxDkKauiwnLFrij1icncBqv8hnIEEqie+/mAV0Ce/QypPJrGcmhN
         Z/og==
X-Forwarded-Encrypted: i=1; AL+hErF3OKqCGvFKF8TCVbj8Y2RNVT+CVm6+jFmkyDh1+6UT4riuX3IWHDYtHD99Qpf2mTL8NsTGrlPOZA==@kvack.org
X-Gm-Message-State: APuU4Z/CjeI1Lw6/Tht1EyR7nTi8fXmF6BRNaavsa9XPEcTipBZARRVH
	q1x1yuD59VqQACVCpqGhclJAqsth5lqtl4BjdbxArzPS2NC3T9O11LIDq3UqUVngatnILlsmHRU
	SP0g+G8Qj0q2p3JHDeDOVD6H394wAy+c=
X-Gm-Gg: AYBFou0OptT52hZBKJYVb4RzpUM2MnsLh3YkpZAEmxeo7A53kX1a4xfF4eRpHhtBP0g
	/PuLm2AY7aASdYCVBToUmNFg2f3kk5mffTyEovSmYU1dEQA+KrBzSIXLgMAR+AUzDsr+42FIsPA
	nKlmoAP0HO5cjJY6NVWZtR/I6nmhQH/+40ziC/FFRUNjU9C0q83VF3LewQsOkFIN2rOH9lx9m7y
	tJNPwhZFqC2H2o/sUt+eKbLbEVTIMRsXwrxkr6e4a0TRBOZToiZuS7jJPPrb6lX1DqlpTNe7lqX
	KlkVTdW+xU0XHn1W4M5b/NWY0A/PxQMck2i8+I6hWVch+hhbyg6vweqtTrDzWQ1eNZdXiU+fqDG
	EdPlPGlsLN73qzOizMnGNtADkCTCJbXBWx8xcTpyjNiVn9e0I5oNkPNL3MboGi3GOMhOW3MxCkK
	fuNoYeG9Cl8ia9rgqoalSI3x3d3IvZeqV0I6kDciWbIEYrdSc562qlhYk=
X-Received: by 2002:a05:600c:4e0e:b0:4a1:da58:1ee with SMTP id
 5b1f17b1804b1-4bb88938dc9mr114117765e9.31.1795217147625; Fri, 20 Nov 2026
 15:25:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:25:36 -0800
X-Gm-Features: Aa3M54ocqa_Rt1iaIcH01mzW7rcL-Me_kjHYSn1LGUejy8g6N8y75Tuvtfmivv8
Message-ID: <CAKEwX=Pr6t8w676ztfrONaKrRKoy6NS1priTb2c2XUikNhYU7A@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46456A0005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: moa6396dmiby8zpjbek7f94sfhyw7izu
X-HE-Tag: 1795217149-505557
X-HE-Meta: U2FsdGVkX18Lzc3O1EkJoCtPJWW8ytlO/PilAPv/pgBtTPgFF2Zq8FucCVrRJYFoiYdh1H+pV2TkVxOr31NVrA5toEXnjHpcsSPFdU0JMT55aFQUryKpTVDdJYaldm/xMhyyfBtnQVKZ1UcdWZAHcj08fSxD1BJQlpqsuoOFp1OY+54GxpLn2H0l9KKoH0W/rnH+lIMlDgyMy1zGkNekpvUWMQeGE6yDmg7N0njPrJZtgo0Mi6McNZb6geiNCv4xGDUn35HSar1S+XjkXrhpN14Tjcw7Mwe82RBEer09aSOVBrHbDFBBH8ymCOBMFMtVSnTAQ9ImooZVBjVvGHzPfteJ2Jh0BzZecHEPE0MiSEqX0WU+t6rmz7eDHlgNNbdXQhYigDHWbLsSk/VmubVHyu2TXG9EtTtNqKVj/APcOgxm+chui8rt6RHm/zrNyZ0N2rxpgn/McCGEltxL7XScjskEh/ODFC46rn6QHv3ffJxKVIuBdkFT+usKBPnFelAaoeel+4Lajjui6R9mugiSDItxp50GCLaJol42Ol2mVp1gTk76MYhpqnyr1FQ6f+4UB/h9H+q2MTqhqZ4bhwxVhb0hgPMMSBJr59SW9F5j8UI1AtgiNpN6V1zxhSyLmMP9JXoG+OFIzGJjiFptZ7XHdBIuOJ6tmCGVvhXkRRuSEtUrcku3iw3KpeGwPERsFZ269gAk4mUdg2Ircvt4sL+PLSr2Tpoqm3/bPmLcconmT4aQWkQKujrg00nc4v+zou5iuFM7BN4m4mS9CNobcPlvzhQ5Qo6mRrjPPCWJ92TEQx/HLZfTvZjyTSUE8mi1dHRSI0iucff1LQAIDg7FvraOsfcHSoabdhZjd4UTKoaJcDDJ4jpjUL24PZUWvVY8rNXqLCfUD0T56aATii3+uRH2bWDpV6a4XHtNvySvH4hDcuIf0AIRc+Caia8V0CmLfv+lX7kJRrNiTjl9Y8lQGHP
 +Ed9g9W5
 CXqh3NSzy7ugDKgbx1Vmir9zFsD5HDhQYn6TAI3spl2nhN5G2iXObF9Mffg4OX7U0mXBLaMlkJhtXj+WUo7bK0h28Vg5guM63+WqXGOg7pGgFj2R0X1t+OfeEFmC7UrJMlvIfGDvgJFvaTi5aBPIBRfhKeaX3KYkdkA6ZL9zfjxjPeK4He3rxreO1SIFPAA2HV9VJ9+nk+iJ4EqfsY0PGqUBzA91H0IMOzrFMw0Vz0WABw8qWWhVuIlNor0t9dSpceJrYZUAeGGUo/emUJZaMcJNHX35GwbsU/ckqzwMKd3cjX6dpHZnDULu6X6L9sN+A3uMnT/rVBuXyBSw/1qfiZCenavZTmxN1cimac2rEm/wXLhLxmhC0pWuckxCN+DAHuyfhefQCTuuWW17kNUWaoFITYaHcOArhBoe/EuQmQm69lmq89k/dCNlkX+wHHu1uuWRgdWZFQcijEZC2BtiDh3CR6rXKJdWyR7qfdDpUBFpfYdcpoQkanD55R61z3m1t1HxVZkfW5bPq6oTLAs3JPkLQXiovMSat5ifjxp3Q9Urns+/VDqEXnPKVo4EA0d7Bn6m2gsHZ0asdUjrnu8eRxMU7m2a2SJjf0+0CUlK7gtZ80o9W8zq4opvK9WNEHTW/M/XuGb/wGURvs876O63Fpo1HgHrTK1wEfdfsyZC4/3CjZ2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> Use batching when storing large folios in zswap. A new constant,
> ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> up to 4 pages at a time while storing large folios. This commit
> modifies the "store single page" approach to "store a batch of pages".
>
> As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> compression buffers are allocated to eventually be able to compress and
> store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
>
> For existing software compressors, the extra overhead is the
> the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> x86_64. Only the first buffer is currently used.
>
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
>
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg. Similarly, obtain the nid once to use during
> each batch store of a folio. To facilitate this, a "struct
> zswap_store_context" is introduced to keep function parameter lists
> concise.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> ---
>  mm/zswap.c | 307 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 217 insertions(+), 90 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 78d9694f75b5..df59ab0c1029 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -85,6 +85,9 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. *=
/
> +#define ZSWAP_MAX_BATCH_SIZE 4U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -144,10 +147,12 @@ struct zswap_acomp_req {
>         struct mutex mutex;
>  };
>
> -/* The compression mutex also protects the output buffer. */
> +/*
> + * The compression mutex also protects the output buffer(s).
> + */
>  struct zswap_comp_ctx {
>         struct zswap_acomp_req areq;
> -       u8 *buffer;
> +       u8 **buffers;
>  };
>
>  /* Separate requests, so that decompression does not wait for compressio=
n. */
> @@ -162,6 +167,7 @@ struct crypto_acomp_ctx {
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
>   * when a zswap_entry is taken off the lru for writeback, in that case i=
t
>   * needs to be verified that it's still valid in the tree.
> + *
>   */
>  struct zswap_pool {
>         struct zs_pool *zs_pool;
> @@ -226,6 +232,15 @@ struct zswap_entry {
>         struct list_head lru;
>  };
>
> +struct zswap_store_context {
> +       struct folio *folio;
> +       long folio_start;
> +       bool wb_enabled;
> +       int nid;
> +       u8 nr_pages;
> +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> +};
> +
>  /*
>   * No RCU section is needed around the returned pointer: a stored entry =
pins
>   * its pool via percpu_ref (taken in zswap_store_page()), so the id cann=
ot be
> @@ -284,6 +299,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref=
);
>
>  static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
>  {
> +       u8 i;
> +
>         if (!acomp_ctx)
>                 return;
>
> @@ -302,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *=
acomp_ctx)
>
>         acomp_ctx->acomp =3D NULL;
>
> -       kfree(acomp_ctx->comp.buffer);
> -       acomp_ctx->comp.buffer =3D NULL;
> +       if (acomp_ctx->comp.buffers) {
> +               for (i =3D 0; i < ZSWAP_MAX_BATCH_SIZE; ++i)
> +                       kfree(acomp_ctx->comp.buffers[i]);
> +               kfree(acomp_ctx->comp.buffers);
> +       }
> +       acomp_ctx->comp.buffers =3D NULL;
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -388,6 +409,7 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>  cpuhp_add_fail:
>         for_each_possible_cpu(cpu)
>                 acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
> +
>  error:
>         if (pool->acomp_ctx)
>                 free_percpu(pool->acomp_ctx);
> @@ -778,6 +800,44 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>         kmem_cache_free(zswap_entry_cache, entry);
>  }
>
> +static inline void zswap_entries_cache_free_batch(
> +       struct zswap_entry **entries,
> +       u8 nr_entries)
> +{
> +       /*
> +        * It is okay to use this to free entries allocated separately
> +        * by zswap_entry_cache_alloc().
> +        */
> +       kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)entr=
ies);
> +}
> +
> +static bool zswap_entries_cache_alloc_batch(
> +       struct zswap_store_context *zc,
> +       gfp_t gfp)
> +{
> +       u8 i;
> +
> +       bool ret =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> +                                        zc->nr_pages, (void **)zc->entri=
es);
> +
> +       if (likely(ret)) {
> +               for (i =3D 0; i < zc->nr_pages; ++i)
> +                       zs_handle_init(&zc->entries[i]->handle);
> +       } else {
> +               for (i =3D 0; i < zc->nr_pages; ++i) {
> +                       zc->entries[i] =3D zswap_entry_cache_alloc(GFP_KE=
RNEL);

Oh and why are we using GFP_KERNEL in the fallback path, but passing a
gfp to kmem_cache_alloc_bulk above?

(and it seems like the only caller of
zswap_entries_cache_alloc_batch() passed GFP_KERNEL for gfp anyway?).

Let's just drop gfp and use GFP_KERNEL if that's the intention?


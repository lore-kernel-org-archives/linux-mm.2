Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B4ACCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 17:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48DEE8E0005; Thu,  6 Nov 2025 12:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EB78E0002; Thu,  6 Nov 2025 12:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D968E0005; Thu,  6 Nov 2025 12:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 210148E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:46:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B091C1401A9
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:46:08 +0000 (UTC)
X-FDA: 84080910816.16.EAD9F44
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id DBCE1A001A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:46:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mLV2Tt9Z;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762451167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuqL/Wl9e/NoH3ehwAFRAdXC+fJYyatKnRax3XLipPU=;
	b=NSaoOGmsfVW6OjUrbH7bwGSz9rqg5R/fXjuop2yEp3Fd+okJSM6LnjaMKpXemq4Js2+UAJ
	yGbnzEon3H7efE+bs8lapA6ZDBz7Ujt3JoLpbbm4ml3MJBES+WV57hI3tD9aYuyiMBj38u
	kEw8d5yyOqbMyFpQpAEjRMs42+Fc5NI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762451167; a=rsa-sha256;
	cv=none;
	b=zGGDpnvj/TgE69oHJJA0mcCyQVwhvdOD8wF6Tj0tTagvZH71J9QiCHb7UJdt1ehaYLHL7+
	BQ+evjGaoPtoD4VvFZaDkVK6Sel4ryeVke7wyBSIAa0DQj8HBnr+rDTzkb2s/1eZohDxMP
	DRddIoPmY1fpbaCgYoS1562HNPQcOeE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mLV2Tt9Z;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4774f41628bso12205355e9.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 09:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762451165; x=1763055965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuqL/Wl9e/NoH3ehwAFRAdXC+fJYyatKnRax3XLipPU=;
        b=mLV2Tt9ZvW3NHWMaspcmp5Spbyck3sogkTUco5aQy6VAbrbwuAkTRTI71ZXjQCLR0N
         dd2PZaYFMqBgmRCfb0yDVzgvcLjdr8HVYJzmAfhrXjVURQgnVcmh1tELvqRlA5cK3PzO
         yWB2F41TbSPuvl1uQ/Dj8+Fs+9QQLPfvewtnmApz+KV2ejXimsiksgir+RnI/hLIreVF
         7LMin6rrLr+HPYLIOhJkFTci9q6uTtddHEgk/T3uJGshxGuSYWn7KzLrsNeIsPxWWgLq
         ttC5TKnJImIMILHElT9rCcsVPi0jIVV0JaVsjQcU2u9j6/sYYALZQKYvLXM3AjreuLHP
         sKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762451165; x=1763055965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XuqL/Wl9e/NoH3ehwAFRAdXC+fJYyatKnRax3XLipPU=;
        b=t0OJSDWlTMIN5n4rzkDzmLsCHDZvtuC5dTfV7bXJTJki/I12bstWH+aQ7tzb5+SQ7r
         TZaSGgXyBETJM1k+8+NN4Nwl3em7Y8mE9xMSXc7r1wfopvRu+BUouC4kXlLOLPvvvjWJ
         qJAEmUkcZ0DfmG7MqZcS/Fldg1La3SP9W3fY799vaYEXxiV2vizuBEJ+rIkIBFKT+YOL
         C0XcuJMPBrGfryeZ1ZIM/4Koo3B1OeTKZYpPD3D+ZRR8R93OP351E7NHBhgkdYSdy6U8
         O8WeLqfBhwcfiDqtXUUqd4sfjK8H7BQkcDjoOcBAYjpWXLYK5GYGFR941oaJN+wZkJI9
         w9rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIQ1++X/7nSJAjbV/5ckakGnXGmTwGajqHmAWmDiGBtdsJgqFI2o09ayaD+yYTa8xPs3sRqrDW2A==@kvack.org
X-Gm-Message-State: AOJu0YxaQGwluBmDSlZIl4Gwk5FCMYkO2HLt1oGmMYHy8AqhOE9mdRLv
	LSYQFUSBnbRaW1mD+hDtFIRGXH00v4PQ0LrwZ+W9mtMvxhoPa7wexfk/vfp7/hXwc5Op4v1dJ02
	ZfrCQsR/F0I35h2qV9/hEXrmsOWMPtts=
X-Gm-Gg: ASbGncsTWf0fkGOJHlnuIn89UYqiFWCFJ5wwltKfMjOqTfqj/mncQRnxwjNThkOY9nU
	UP8TZBofFyzE2zLtXj2s82BvYOSq/jfrjVo8p0SlqaZa+vhVvTFRwPVO+ZYOctwbhM253T6isH7
	hLKWYDVOyjQMEzZis4f/xE8hJAIjsSgA9L+GMD2TcWeUJX4b3NdyVe9eA9yQrCS/42MQCoPeAd5
	4d6SkSd10sr4dfr8HpQvFP9QQ8W287KSfhOKmj1UjRl7yC6ymdt72OkhMOEnga2sRb9
X-Google-Smtp-Source: AGHT+IEFawWwq0jLtchfAtfV2bMZzjg837OrBmfi2630hVEv12RxFBc5Mi569pTBPw+Jx0fhBVi+AQjxNrOpiTaxHPw=
X-Received: by 2002:a05:6000:220f:b0:429:cff0:1929 with SMTP id
 ffacd0b85a97d-42a957abae9mr449584f8f.29.1762451165029; Thu, 06 Nov 2025
 09:46:05 -0800 (PST)
MIME-Version: 1.0
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com> <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
In-Reply-To: <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 6 Nov 2025 09:45:54 -0800
X-Gm-Features: AWmQ_bl-bUbfgh-tgbtwi7OIawVv9zFYP4CJyFLME2PrDUDmGRzTAKOojNiGcsM
Message-ID: <CAKEwX=PmJcsQy5foaS6HecqLyF1gKBhbLvbw6kM9bZmJ7UMBFw@mail.gmail.com>
Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBCE1A001A
X-Stat-Signature: 53q18skfxbygiajozd1erwxsdbdskndw
X-Rspam-User: 
X-HE-Tag: 1762451166-524656
X-HE-Meta: U2FsdGVkX1/ti1l1op52Ze/mRJv+QFI/RFQCQ65XHDsJ5Dp1qCJOpv1XzdUgTSX8HsUyYnFx++Rk53VpoTvvcI3+pj2pnTObW12YF/YX8EZeCCl8tsBONJgFIH2GEAWwl8DoLzc7smYEm7FHVNQaTakYTk89MUduNSyXD7JOMxycnWuKWQo5JpmEsxGKAWhfvoNXZp2fqzFlOiIoO+7hOTi/8Jvo8yXcrxDLHCsfTmkFy5JMXY/EPyODF/2NUn8/SGCOJKoa58E8sjb1VzEOtl3MIaJ5amYpIPZE6DOs4hnC3Mlum+R9ThPovfdF3Lj7K/cvTSlrer/R1DUqzj4NmPJFviE5GWvEMjjiYkoDcurEaMY6YUMa2zmqu75+QcSYbaqTK95HC/cBPFchXy2OawjiMXLK+PEcnVqx0hhMD6SLhTuKNegaMa3oJD2zLbFUm2IXfBHk2YqzlBBR1GGxDBB9Bnqylqpz5FzfHKOxYcLduMyBqEV2EfHKKqueAnkWSB//IkdKYBZuoqFpvYon6+s/qqGDEf4YTasd8LpX7+/u1dn8LRiLTTwbMs8XeGOt5zHZ+546S7cOovsV6vCB2d8Pb/QdPUk9Lqi/iKP3KoKRo9X8iKoT697pU4oF0Dm3YDVeQX35uEYoO710psDmehL3qBDXItIdn+aQPklaPJ6mFX5Dh0SMpVhLtrz+zeNO/SqvzWrcPc8/TlGD1fNhSd6W9ZokI95dRUk7/7lZsvTWyi8Xe/DnPFzuiYJCDfj+DzIUfEzvilLHvqIVPJ+YVKVlYxSDl+aX/0Ein1NJUtCQJVzSdqeimgvkoun9IffDM8HAP58x39eYEBKBaWSRRIRGT6h5WTNQwITdCl67K0giO1HVMqed3Jrnc9yzNvXaay5NvoaLwSRUNmQtJ268fHykw84kT2aHIECdhoRKSdj3tnr77WGAJCHSNf3iYHPSntvlcmtNOn7HXIvC7yX
 Gohk+bur
 ZY1CJ3FNRZbAoxjTYexF/4EjkzZkTwUnoI+gm6FTpnDugm36gvRq75DOL4wbcXR4SpMe7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 1:12=E2=80=AFAM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch makes two major changes:
>
> First, we allocate pool batching resources if the compressor supports
> batching:
>
>   This patch sets up zswap for allocating per-CPU resources optimally
>   for non-batching and batching compressors.
>
>   A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
>   limit on the number of pages in large folios that will be batch
>   compressed.
>
>   It is up to the compressor to manage multiple requests, as needed, to
>   accomplish batch parallelism. zswap only needs to allocate the per-CPU
>   dst buffers according to the batch size supported by the compressor.
>
>   A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
>   Yosry's suggestion. pool->compr_batch_size is set as the minimum of
>   the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly,
>   pool->compr_batch_size compression dst buffers are allocated in the
>   per-CPU acomp_ctx.
>
>   zswap does not use more than one dst buffer yet. Follow-up patches
>   will actually utilize the multiple acomp_ctx buffers for batch
>   compression/decompression of multiple pages.
>
>   Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
>   batching. There is a small extra memory overhead of allocating
>   the acomp_ctx->buffers array for compressors that do not support
>   batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).
>
> Next, we store the folio in batches:
>
>   This patch modifies zswap_store() to store a batch of pages in large
>   folios at a time, instead of storing one page at a time. It does this b=
y
>   calling a new procedure zswap_store_pages() with a range of indices in
>   the folio: for batching compressors, this range contains up to
>   pool->compr_batch_size pages. For non-batching compressors, we send up
>   to ZSWAP_MAX_BATCH_SIZE pages to be sequentially compressed and stored
>   in zswap_store_pages().
>
>   zswap_store_pages() implements all the computes done earlier in
>   zswap_store_page() for a single-page, for multiple pages in a folio,
>   namely the "batch":
>
>   1) It starts by allocating all zswap entries required to store the
>      batch. New procedures, zswap_entries_cache_alloc_batch() and
>      zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>      to optimize the performance of this step.
>
>   2) The entry doesn't have to be allocated on the same node as the page
>      being stored in zswap: we let the slab allocator decide this in
>      kmem_cache_alloc_bulk(). However, to make sure the current zswap
>      LRU list/shrinker behavior is preserved, we store the folio's nid as
>      a new @nid member in the entry to enable adding it to the correct
>      LRU list (and deleting it from the right LRU list). This ensures
>      that when the folio's allocating NUMA node is under memory
>      pressure, the entries corresponding to its pages are written back.
>
>      The memory footprint of struct zswap_entry remains unchanged at
>      56 bytes with the addition of the "int nid" member by condensing
>      "length" and "referenced" into 4 bytes using bit fields and using
>      the 4 bytes available after "referenced" for the "int nid". Thanks
>      to Nhat and Yosry for these suggestions!
>
>   3) Next, the entries fields are written, computes that need to be happe=
n
>      anyway, without modifying the zswap xarray/LRU publishing order. Thi=
s
>      avoids bringing the entries into the cache for writing in different
>      code blocks within this procedure, hence improves latency.
>
>   4) Next, it calls zswap_compress() to sequentially compress each page i=
n
>      the batch.
>
>   5) Finally, it adds the batch's zswap entries to the xarray and LRU,
>      charges zswap memory and increments zswap stats.
>
>   6) The error handling and cleanup required for all failure scenarios
>      that can occur while storing a batch in zswap are consolidated to a
>      single "store_pages_failed" label in zswap_store_pages(). Here again=
,
>      we optimize performance by calling kmem_cache_free_bulk().
>
> This commit also makes a minor optimization in zswap_compress(), that
> takes a "bool wb_enabled" argument; computed once in zswap_store()
> rather than for each page in the folio.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 336 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 232 insertions(+), 104 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cb384eb7c815..257567edc587 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. *=
/
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
> +       u8 **buffers;
>         struct mutex mutex;
>         bool is_sleepable;
>  };
> @@ -149,6 +152,9 @@ struct crypto_acomp_ctx {
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
>   * when a zswap_entry is taken off the lru for writeback, in that case i=
t
>   * needs to be verified that it's still valid in the tree.
> + *
> + * @compr_batch_size: The max batch size of the compression algorithm,
> + *                    bounded by ZSWAP_MAX_BATCH_SIZE.
>   */
>  struct zswap_pool {
>         struct zs_pool *zs_pool;
> @@ -158,6 +164,7 @@ struct zswap_pool {
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> +       u8 compr_batch_size;
>  };
>
>  /* Global LRU lists shared by all zswap pools. */
> @@ -182,6 +189,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writ=
eback
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * pool - the zswap_pool the entry's data is in
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
> @@ -189,8 +197,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> -       unsigned int length;
> -       bool referenced;
> +       struct {
> +               unsigned int length:31;
> +               bool referenced:1;
> +       };

Maybe make these macro-defined constants?

Code mostly LGTM otherwise.


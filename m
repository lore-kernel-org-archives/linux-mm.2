Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6C3D46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1C06B0088; Fri, 30 Jan 2026 19:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F7C6B0089; Fri, 30 Jan 2026 19:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CD46B008A; Fri, 30 Jan 2026 19:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA076B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:33:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A841140738
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:33:44 +0000 (UTC)
X-FDA: 84390385968.26.945F695
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 05E8DC0007
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:33:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKdAaR2c;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769819622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EK14XkwGmMqqZzjiKWIL7AKo1ekIfBKRK+KFt/BRwU=;
	b=nfFj+1q7xXDASdrKxo/MPwejBXAWO4BlpdegcuRApceWidMYe+BBpRwioLHjJ+PYGX/C5W
	JkZX1Q6dvLoXiEkmPmKHSY8jZ2Jg9VnaNYdZhislJsHFeT9chscU4tNlBlRxdRagj+Diyl
	aajnbpd5v8hmniWUeY3lrFD4jonHM78=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKdAaR2c;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769819622; a=rsa-sha256;
	cv=pass;
	b=39juQegJLD9o5SvHO+M8dw3JUKldavW/MqEx0zc65cApRyvog7gvW5wn7Ah1NhHlz85JHa
	p/vBunnD7y1Ls/ceT7nRElmtVlaw0lylNe6C23bH2rR9zaqwhvvjsArDnNSU2Z/8TZbh1R
	hwMhvd950nhzcB39Qp/kksccjn+bsww=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-432da746749so1573598f8f.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:33:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769819620; cv=none;
        d=google.com; s=arc-20240605;
        b=g7vCxJW1ObFyhL++hs05gApoMAg7KFamuhHCeplqNxK6FdkU0lEXZIAGGXEHczgQUv
         UQzERyjxPfVbYmi4YxDEQy98f7gPKnDhSuiR6rK5rT9vQYEUFC5vkKHsuaYcolnjGOes
         ZXmYYvimRRMGOWSZbNb+7+mBA1QQ/5qhGHuc91lieFvRxnX2R2ViRb78acB1WI4eYygn
         DwaJrxu5MFudWoa5kRAYEPCWMbJvSrM+7mxkgLO2vzEVTi0bwUT8t+/ZxgNaVD5+fOv7
         uhcJ/fjvhiRkfkKxrD2LohTtez+rBasb5a14eJOPlxZE3lHllQtC5OhP9Hj9PRg5s/zD
         qctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8EK14XkwGmMqqZzjiKWIL7AKo1ekIfBKRK+KFt/BRwU=;
        fh=KleCMv2KT/ghIPbWvHiqBg5FAFJxWjrkaT9MCYD2+ig=;
        b=Kkcktr3m7Zu0goZ3k2BSvS+Y0WF0JSH/43iuEWL8+JAUnz1oGCVyKLvIU0Cr7Z/Iqn
         KoNOshJP2jTJa3yKX+RaluOhi8k/hNBaAzkjhFnPQJJGC1soSH/EG24/3XSmuPxyJ2WW
         TNlxtE7oWtuiN4zewvCC1LvZF4BkkAzlQP4IzIGUg4jqE50uYa8qLdQFBfn4da2c8ckT
         GqkZfFlfizYnc4GdGfsdhYG9KZEcfxlSo66Ib1ozlq1sNzOFl1raRxu0CuuljOCXFRer
         JueQqnvXn2wi+eT6J7lBm12rj4zLrAE5gpogOa94iErvS3uDu1SrcRdhvvvB4iUwFn5Y
         2C1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769819620; x=1770424420; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EK14XkwGmMqqZzjiKWIL7AKo1ekIfBKRK+KFt/BRwU=;
        b=HKdAaR2cCn3wM7Vq53GF177QZ48m0P8uppNWUiMM5EbpQn7dFDNNLFpm8C6uNUjGmm
         21dZ48Dtw/pDePe32Z3kySUHvPrPS1mI3YDWn1yEylao4Phg9RVimluCBEIzZv5rmEiG
         CynzXNTjomBRfF0UCXz+ArAIvJIL/PFxQrdWQzUnlwVBHO9NsaWE4/FvOVn5h7g228w8
         mykZvF+XhD9jMlB7WJNvAHkAVWb2TCOJGOG3T0oaliEzjogyVpnJ2ItVU9r8sELfyRFI
         EcMIf8GPwbC9+5BWpZF2DmVpiLC9WhGK9nkPFrc+ekpwX6JMQsx3FjDWcKk+3Eef0IEV
         D7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769819620; x=1770424420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8EK14XkwGmMqqZzjiKWIL7AKo1ekIfBKRK+KFt/BRwU=;
        b=l7JX/D+Uu9FtLYxCnKLGYBA7OyGlMSXMY72osxdmRdNTVwx6lYXEJ/OpZr3I6Xjh4k
         YBTpPQSeXqcpG0TQMUYhCrP3I6NbmNOMT/jAGYWOjXVRnpRlY5jq9k2Cf3YhC/xDwkdg
         RqG7Nm8TeQIfruzSMf9n99yqkEBszizaxvHycj0Vg8c5KVo05XPEV9CqjDCAcKjPuW8b
         d1PEouI6gE42gEvLuSAthtbLQ+b7u3ggkXCyJXtXmXGT4HxcXyjE5IcT4AU/R+Zdyluz
         92W3DVov6vUm9/sU+Z95Vbb0UxX/Ki3NYzxNJecLAvD6GzPRIZlp6t3TGq1lFUn4J5Ek
         E2YA==
X-Forwarded-Encrypted: i=1; AJvYcCXzqrf/3rfAs589N48p4XrNxdC8qcudquvQALOvwsPJ/LVBrdPUsf2QlbE3Fy1IACEJjvaU0rbt/Q==@kvack.org
X-Gm-Message-State: AOJu0YxyzTFVSMeCbB64CwSIjm7+LimWXvSsGyRuWAMY+uj+S+0WJKUf
	VFdOBcUqzQxiMC6YLir6iBdO2WQoj0rC8NF9P9XonWYFmarbBpuPccRZ9Z9bU90V+AtBuD9ep3H
	bGGNCs0EP/q7yC8m18clquaIxlIS4/yw=
X-Gm-Gg: AZuq6aK25SptZdH84PpXCEgmjSMdbiRWrBvt1w9VfOwi0WzDS75BKDbY9Eh1tjpVQna
	N4piQ00Ml9WG96INVLclYN07FcDEz+CX/3lTkzwKkF4fIj3PC2sU1bRWZQXtiNUk2rFncsXX0D9
	q0KHK+LMW5et/K9xNKLm4OfgJODtzzGyrWZW6cxPjVmYnFTyWE/rYamaFGJzp7HM1h2gu/OFv4b
	vx1L0b/0MZPEpjuz+hAJnWqry3u3taR0OT0+rCnAlt7EE7CpcOhqCx7q50b6eV9yKbfoikLyGrR
	5lAxN/v17/U=
X-Received: by 2002:a05:6000:4282:b0:435:af89:11be with SMTP id
 ffacd0b85a97d-435f3a8b257mr6711541f8f.15.1769819620179; Fri, 30 Jan 2026
 16:33:40 -0800 (PST)
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-26-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-26-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 30 Jan 2026 16:33:28 -0800
X-Gm-Features: AZwV_QgmSGBTWc0AW3k8iHHJLuD66znCQ4UgvbnY7Ox2V7GfkrAXx042TuHiTi4
Message-ID: <CAKEwX=PAo6s6L=WL1va6edcGznQcYWe8Xrtt-zBFdAo05wS-AA@mail.gmail.com>
Subject: Re: [PATCH v14 25/26] mm: zswap: Store large folios in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 05E8DC0007
X-Rspamd-Server: rspam07
X-Stat-Signature: hfks3uw9pkdgpr4n3fq3kj9d5qjp6zph
X-HE-Tag: 1769819621-130361
X-HE-Meta: U2FsdGVkX19XyuTxVacvKQID+vQUhe9pXUfmsEF5bQuj1kVNqGQnPI0NlYb5MZpcdikQ5W3XkauKribFtfS2TiS8p07/TlotlH6LuIt3YqKROD1VICKDqKUtNZmmJFPwAMj7FsrT63ofAUMFkeKHB6EvYXOL59A+rHGupI9hyKqeUvmsqvaE/UB9uUt4NuridtK1dcYFjIxpl4LDCwcLly9OsO+l4y3IxvvPkRrI14GwvW0be6xgiH7DoRZBCmiORHJU3k2AbjldLAjnpm/ozesgL9QsxeRY/a2zRnJsGmcUxT9JRv3kZpfhn/eq5CyrkuETZkzT9x01FRGc8Nm1ZPVw0gxTQcsr2DfkUrHKjQ+YuiTE+64iRT6OwUmmuzfdwSYmIo0WVVtaEI5HRom79bnA6s0C7Hmwuhe/pJeosy3cstfHUngnalIAPX8XnSWdQPbyOtFuACNT+xANmUEVg6B2y+REI5D/Gw8ENluv2ocjlJXre6fVtUisKhwTfySKPiofeBZ4HVdVmavRMC38Esq1eORIciRYOL5SGk7lGLUfYSkqdzZ8C3wue59qO9hwtNQrhC1h4a13r66mwUvRhq0L+uJBcgjwXklNJ3qLeYCvO3QH9OYCwgkUEImmnO9G2+EblQMkfiD2fjOGwXit41IydVxIj0LA98kEdK0bjEwVYVEMshNfUwj6CgckKOuSCOfOBuDNuj/3HzDFQKkYy2xq0xWVyUcrz7LdCbs63YaxxvpAScEjc+CpnhCnxh2d9kSH+M2uZUpmr1szTX7QFp9P5yGf5wHqo5bW070zjt3RwFHiu1GFp5XSykEPC1xGbEMee9ek0ooHqieYO/JacX15SYT27+g9CbWfFrXGkYXtCBnQSg1+0SYkvu+e6jw3ngMVYs6cbxoqcAHIkzbcr7ruyzsZAUe5UPQSZ8ZeoQcSm5H5+vxhL6kO8oNqj/pvgYEoCLyS3sMI3CzBCgn
 zEwgTTfi
 HyGcNKyft2WcTdQLuQkUeNOc5I4eTfI314XvbLQOQFLdJ1YEdzThsQb0rueK2V0+IeMlEBLJPaUMWEVQj+3FhJ3wtNlVcaIS6P721AfG1uVw/S2GfZWBgWvznv/fJLW2wto0lUurdSFl1Gnos71vXjSs0nQ7hKK8Kdd7Jtddh0gWuOUnHwUxbEbQ2uz/TRLON9y3NXDdvfjPxK3eJRbtnxAYythb/GTAVJZSnXZNZVcily3GJiY94MP991BSSf5Zhc7EthlWB6/i9BtAhEoZ9iWXx/GcCdIYyBNCvrmyNDX9i1Poxnm69ftDjrcQ39dUyXdyJpIF71OX860Ea1FVZL7idOosnFUxzQM4n9Y0thdl1ZZWycWnL0EMnHhgg8iOCb4wANy9LsGxT6mzn37bVumRJL/lRJVVibVIiC2daw1O7zp270qelGtzLbcCP2ZYM+7Mb5mVttgCv0oyZi1cgmAVOaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> Support batching when storing large folios in zswap. If the underlying
> compressor supports batching (e.g. hardware parallel compression),
> allocate multiple compression buffers, otherwise allocate one. The
> number of buffers is bounded by a new constant, ZSWAP_MAX_BATCH_SIZE, to
> limit the memory overhead. For existing software compressors, the only
> extra overhead is the extra 'buffers' pointer, so 8 bytes per-CPU on
> x86_64.
>
> Only the first buffer is currently used, but subsequent changes will use
> the remaining buffers for hardware compression batching.
>
> Regardless of compression batching, always process large folios in
> batches. For hardware compressors, the batch size is the compressor
> batch size, otherwise ZSWAP_MAX_BATCH_SIZE is used.
>
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
>
> Since batch allocations do not support specifying a node id, store the
> node id in the zswap entry instead of relying on the zswap_entry being
> allocated on the same node. The size of the zswap_entry remains
> unchanged as 'referenced' is lumped in with the 'length' (as it doesn't
> need a full unsigned int anyway).
>
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 351 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 248 insertions(+), 103 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0d56390342b7..6a22add63220 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -82,6 +82,11 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. *=
/
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +#define ZSWAP_ENTRY_SPARE_4BYTES 32U
> +#define ZSWAP_ENTRY_REF_BIT 1U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -139,7 +144,7 @@ struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
> +       u8 **buffers;
>         struct mutex mutex;
>  };
>
> @@ -148,6 +153,9 @@ struct crypto_acomp_ctx {
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
> @@ -157,6 +165,7 @@ struct zswap_pool {
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> +       u8 compr_batch_size;
>  };
>
>  /* Global LRU lists shared by all zswap pools. */
> @@ -181,6 +190,7 @@ static struct shrinker *zswap_shrinker;
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
> @@ -188,8 +198,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> -       unsigned int length;
> -       bool referenced;
> +       struct {
> +               unsigned int length:(ZSWAP_ENTRY_SPARE_4BYTES - ZSWAP_ENT=
RY_REF_BIT);
> +               bool referenced:ZSWAP_ENTRY_REF_BIT;

Hmm I thought Yosry confirmed that using values directly rather than
macros (i.e 32 and 1 instead of ZSWAP_ENTRY_SPARE_4BYTES and
ZSWAP_ENTRY_REF_BIT) was the convention? :)

https://lore.kernel.org/linux-mm/gnm6hcqlzna4p3unrad2sur7pnyovr7f2sfuiufzwe=
u2zbfb2r@ia422moyti7v/

I was just copying zsmalloc's format ;) Anyway, either way a fixlet
should be sufficient. No big deal...

> +       };
> +       int nid;
>         struct zswap_pool *pool;
>         unsigned long handle;
>         struct obj_cgroup *objcg;
> @@ -241,8 +254,10 @@ static inline struct xarray *swap_zswap_tree(swp_ent=
ry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>
> -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_=
buffers)
>  {
> +       u8 i;
> +
>         if (IS_ERR_OR_NULL(acomp_ctx))
>                 return;
>
> @@ -252,7 +267,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ct=
x *acomp_ctx)
>         if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                 crypto_free_acomp(acomp_ctx->acomp);
>
> -       kfree(acomp_ctx->buffer);
> +       if (acomp_ctx->buffers) {
> +               for (i =3D 0; i < nr_buffers; ++i)
> +                       kfree(acomp_ctx->buffers[i]);
> +               kfree(acomp_ctx->buffers);
> +       }
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -264,6 +283,7 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>         if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
>                 return NULL;
>
> +       /* Many things rely on the zero-initialization. */
>         pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
>         if (!pool)
>                 return NULL;
> @@ -316,7 +336,9 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>
>  cpuhp_add_fail:
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
> +
>  error:
>         if (pool->acomp_ctx)
>                 free_percpu(pool->acomp_ctx);
> @@ -354,7 +376,8 @@ static void zswap_pool_destroy(struct zswap_pool *poo=
l)
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
>
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
>
>         free_percpu(pool->acomp_ctx);
>
> @@ -645,14 +668,8 @@ static inline struct mem_cgroup *mem_cgroup_from_ent=
ry(struct zswap_entry *entry
>  }
>  #endif
>
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -       return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry =
*entry)
>  {
> -       int nid =3D entry_to_nid(entry);
>         struct mem_cgroup *memcg;
>
>         /*
> @@ -669,19 +686,18 @@ static void zswap_lru_add(struct list_lru *list_lru=
, struct zswap_entry *entry)
>         rcu_read_lock();
>         memcg =3D mem_cgroup_from_entry(entry);
>         /* will always succeed */
> -       list_lru_add(list_lru, &entry->lru, nid, memcg);
> +       list_lru_add(list_lru, &entry->lru, entry->nid, memcg);
>         rcu_read_unlock();
>  }
>
>  static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry =
*entry)
>  {
> -       int nid =3D entry_to_nid(entry);
>         struct mem_cgroup *memcg;
>
>         rcu_read_lock();
>         memcg =3D mem_cgroup_from_entry(entry);
>         /* will always succeed */
> -       list_lru_del(list_lru, &entry->lru, nid, memcg);
> +       list_lru_del(list_lru, &entry->lru, entry->nid, memcg);
>         rcu_read_unlock();
>  }
>
> @@ -741,6 +757,56 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>         kmem_cache_free(zswap_entry_cache, entry);
>  }
>
> +static __always_inline void zswap_entries_cache_free_batch(
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
> +static __always_inline bool zswap_entries_cache_alloc_batch(
> +       struct zswap_entry **entries,
> +       u8 nr_entries,
> +       gfp_t gfp,
> +       int nid)
> +{
> +       int nr_alloc =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> +                                            nr_entries, (void **)entries=
);
> +
> +       /*
> +        * kmem_cache_alloc_bulk() should return @nr_entries on success
> +        * and 0 on failure.
> +        */
> +       if (likely(nr_alloc =3D=3D nr_entries))
> +               return true;
> +
> +       if (WARN_ON_ONCE(unlikely(nr_alloc && (nr_alloc !=3D nr_entries))=
)) {
> +               zswap_reject_kmemcache_fail++;
> +               zswap_entries_cache_free_batch(entries, nr_alloc);
> +               nr_alloc =3D 0;
> +       }

Can partial allocation happen? I checked a couple callers of
kmem_cache_alloc_bulk() and none of them check the case nr_alloc &&
nr_alloc !=3D nr_entries.

In fact, one caller (__io_alloc_req_refill() in io_uring/io_uring.c)
even explicitly document:

    ret =3D kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);

    /*
    * Bulk alloc is all-or-nothing. If we fail to get a batch,
    * retry single alloc to be on the safe side.
    */
    if (unlikely(ret <=3D 0)) {
        reqs[0] =3D kmem_cache_alloc(req_cachep, gfp);
        if (!reqs[0])
            return false;
        ret =3D 1;
    }

Other callsers don't even bother checking the negative case (i.e ret <
0) - only the 0 case. I'm not terribly familiar with bulk allocation
though. Please fact check me :)

> +
> +       if (unlikely(!nr_alloc)) {
> +               unsigned int i;
> +
> +               for (i =3D 0; i < nr_entries; ++i) {
> +                       entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL=
, nid);
> +
> +                       if (unlikely(!entries[i])) {
> +                               zswap_reject_kmemcache_fail++;
> +                               zswap_entries_cache_free_batch(entries, i=
);
> +                               return false;
> +                       }
> +               }
> +       }
> +
> +       return true;
> +}
> +
>  /*
>   * Carries out the common pattern of freeing an entry's zsmalloc allocat=
ion,
>   * freeing the entry itself, and decrementing the number of stored pages=
.
> @@ -767,7 +833,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>  {
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
> +       int nid =3D cpu_to_node(cpu);
>         int ret =3D -ENOMEM;
> +       u8 i;
>
>         /*
>          * To handle cases where the CPU goes through online-offline-onli=
ne
> @@ -778,11 +846,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>                 return 0;
>         }
>
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_=
node(cpu));
> -       if (!acomp_ctx->buffer)
> -               return ret;
> -
> -       acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
> +       acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, nid);
>         if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>                 pr_err("could not alloc crypto acomp %s : %ld\n",
>                                 pool->tfm_name, PTR_ERR(acomp_ctx->acomp)=
);
> @@ -790,20 +854,39 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>                 goto fail;
>         }
>
> +       /*
> +        * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +        * compressor supports batching.
> +        */
> +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +                                    crypto_acomp_batch_size(acomp_ctx->a=
comp));
> +

I asssume this is going to be 0 for zstd?

>         acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> +
>         if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>                 pr_err("could not alloc crypto acomp_request %s\n",
>                        pool->tfm_name);
>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> +       acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size, sizeo=
f(u8 *),
> +                                         GFP_KERNEL, nid);
> +       if (!acomp_ctx->buffers)
> +               goto fail;
> +
> +       for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +               acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE, GFP_KER=
NEL, nid);
> +               if (!acomp_ctx->buffers[i])
> +                       goto fail;
> +       }
>
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
>          * won't be called, crypto_wait_req() will return without blockin=
g.
>          */
> +       crypto_init_wait(&acomp_ctx->wait);
> +
>         acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> @@ -813,12 +896,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>         return 0;
>
>  fail:
> -       acomp_ctx_dealloc(acomp_ctx);
> +       acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
>         return ret;
>  }
>
>  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -                          struct zswap_pool *pool)
> +                          struct zswap_pool *pool, bool wb_enabled)
>  {
>         struct crypto_acomp_ctx *acomp_ctx;
>         struct scatterlist input, output;
> @@ -832,7 +915,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffer;
> +       dst =3D acomp_ctx->buffers[0];
>         sg_init_table(&input, 1);
>         sg_set_page(&input, page, PAGE_SIZE, 0);
>
> @@ -862,8 +945,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>          * to the active LRU list in the case.
>          */
>         if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> -               if (!mem_cgroup_zswap_writeback_enabled(
> -                                       folio_memcg(page_folio(page)))) {
> +               if (!wb_enabled) {
>                         comp_ret =3D comp_ret ? comp_ret : -EINVAL;
>                         goto unlock;
>                 }
> @@ -909,7 +991,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
>         obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, entry->le=
ngth,
> -                               acomp_ctx->buffer);
> +                               acomp_ctx->buffers[0]);
>
>         /* zswap entries of length PAGE_SIZE are not compressed. */
>         if (entry->length =3D=3D PAGE_SIZE) {
> @@ -919,15 +1001,15 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
>
>         /*
>          * zs_obj_read_begin() might return a kmap address of highmem whe=
n
> -        * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
> -        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fer.
> +        * acomp_ctx->buffers[0] is not used.  However, sg_init_one() doe=
s not
> +        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fers[0].
>          */
>         if (virt_addr_valid(obj)) {
>                 src =3D obj;
>         } else {
> -               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> -               memcpy(acomp_ctx->buffer, obj, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> +               memcpy(acomp_ctx->buffers[0], obj, entry->length);
> +               src =3D acomp_ctx->buffers[0];
>         }
>
>         sg_init_one(&input, src, entry->length);
> @@ -1381,95 +1463,136 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> -static bool zswap_store_page(struct page *page,
> -                            struct obj_cgroup *objcg,
> -                            struct zswap_pool *pool)
> +/*
> + * Store multiple pages in @folio, starting from the page at index @star=
t up to
> + * the page at index @end-1.
> + */
> +static bool zswap_store_pages(struct folio *folio,
> +                             long start,
> +                             long end,
> +                             struct zswap_pool *pool,
> +                             struct crypto_acomp_ctx *acomp_ctx,
> +                             int nid,
> +                             bool wb_enabled,
> +                             struct obj_cgroup *objcg)
>  {
> -       swp_entry_t page_swpentry =3D page_swap_entry(page);
> -       struct zswap_entry *entry, *old;
> +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> +       u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
>
> -       /* allocate entry */
> -       entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> -       if (!entry) {
> -               zswap_reject_kmemcache_fail++;
> +       VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> +
> +       if (unlikely(!zswap_entries_cache_alloc_batch(entries, nr_pages,
> +                                                     GFP_KERNEL, nid)))
>                 return false;
> -       }
>
> -       if (!zswap_compress(page, entry, pool))
> -               goto compress_failed;
> +       /*
> +        * We co-locate entry initialization as much as possible here to
> +        * minimize potential cache misses.
> +        */
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> +               entries[i]->pool =3D pool;
> +               entries[i]->swpentry =3D page_swap_entry(folio_page(folio=
, start + i));
> +               entries[i]->objcg =3D objcg;
> +               entries[i]->referenced =3D true;
> +               entries[i]->nid =3D nid;
> +               INIT_LIST_HEAD(&entries[i]->lru);
> +       }
>
> -       old =3D xa_store(swap_zswap_tree(page_swpentry),
> -                      swp_offset(page_swpentry),
> -                      entry, GFP_KERNEL);
> -       if (xa_is_err(old)) {
> -               int err =3D xa_err(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct page *page =3D folio_page(folio, start + i);
>
> -               WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> -               zswap_reject_alloc_fail++;
> -               goto store_failed;
> +               if (!zswap_compress(page, entries[i], pool, wb_enabled))
> +                       goto store_pages_failed;
>         }
>
> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct zswap_entry *old, *entry =3D entries[i];
>
> -       /*
> -        * The entry is successfully compressed and stored in the tree, t=
here is
> -        * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> -        * charge zswap memory, and increment zswap_stored_pages.
> -        * The opposite actions will be performed by zswap_entry_free()
> -        * when the entry is removed from the tree.
> -        */
> -       zswap_pool_get(pool);
> -       if (objcg) {
> -               obj_cgroup_get(objcg);
> -               obj_cgroup_charge_zswap(objcg, entry->length);
> -       }
> -       atomic_long_inc(&zswap_stored_pages);
> -       if (entry->length =3D=3D PAGE_SIZE)
> -               atomic_long_inc(&zswap_stored_incompressible_pages);
> +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> +                              swp_offset(entry->swpentry),
> +                              entry, GFP_KERNEL);

Future follow-up: perhaps we can use advanced xarray API (xas_*) to
take the lock only once.

> +               if (unlikely(xa_is_err(old))) {
> +                       int err =3D xa_err(old);
>
> -       /*
> -        * We finish initializing the entry while it's already in xarray.
> -        * This is safe because:
> -        *
> -        * 1. Concurrent stores and invalidations are excluded by folio l=
ock.
> -        *
> -        * 2. Writeback is excluded by the entry not being on the LRU yet=
.
> -        *    The publishing order matters to prevent writeback from seei=
ng
> -        *    an incoherent entry.
> -        */
> -       entry->pool =3D pool;
> -       entry->swpentry =3D page_swpentry;
> -       entry->objcg =3D objcg;
> -       entry->referenced =3D true;
> -       if (entry->length) {
> -               INIT_LIST_HEAD(&entry->lru);
> -               zswap_lru_add(&zswap_list_lru, entry);
> +                       WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray er=
ror: %d\n", err);
> +                       zswap_reject_alloc_fail++;
> +                       /*
> +                        * Entries up to this point have been stored in t=
he
> +                        * xarray. zswap_store() will erase them from the=
 xarray
> +                        * and call zswap_entry_free(). Local cleanup in
> +                        * 'store_pages_failed' only needs to happen for
> +                        * entries from [@i to @nr_pages).
> +                        */
> +                       store_fail_idx =3D i;
> +                       goto store_pages_failed;
> +               }
> +
> +               /*
> +                * We may have had an existing entry that became stale wh=
en
> +                * the folio was redirtied and now the new version is bei=
ng
> +                * swapped out. Get rid of the old.
> +                */
> +               if (unlikely(old))
> +                       zswap_entry_free(old);
> +
> +               /*
> +                * The entry is successfully compressed and stored in the=
 tree,
> +                * and further failures will be cleaned up in zswap_store=
().
> +                * Grab refs to the pool and objcg, charge zswap memory, =
and
> +                * increment zswap_stored_pages. The opposite actions wil=
l be
> +                * performed by zswap_entry_free() when the entry is remo=
ved
> +                * from the tree.
> +                */
> +               zswap_pool_get(pool);
> +               if (objcg) {
> +                       obj_cgroup_get(objcg);
> +                       obj_cgroup_charge_zswap(objcg, entry->length);
> +               }
> +               atomic_long_inc(&zswap_stored_pages);
> +               if (entry->length =3D=3D PAGE_SIZE)
> +                       atomic_long_inc(&zswap_stored_incompressible_page=
s);
> +
> +               /*
> +                * We finish by adding the entry to the LRU while it's al=
ready
> +                * in xarray. This is safe because:
> +                *
> +                * 1. Concurrent stores and invalidations are excluded by=
 folio lock.
> +                *
> +                * 2. Writeback is excluded by the entry not being on the=
 LRU yet.
> +                *    The publishing order matters to prevent writeback f=
rom seeing
> +                *    an incoherent entry.
> +                */
> +               if (likely(entry->length))
> +                       zswap_lru_add(&zswap_list_lru, entry);

Hang on - how can entry->length =3D=3D 0? This is probably holdover from
back when zero pages are still managed in zswap?

Future follow-up work: remove this check if that's the case...

The rest looks solid to me - I'll defer to Yosry and Johannes.


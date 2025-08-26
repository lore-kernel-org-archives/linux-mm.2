Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB07CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB846B02A8; Tue, 26 Aug 2025 11:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C4F6B02AA; Tue, 26 Aug 2025 11:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4343D6B02AB; Tue, 26 Aug 2025 11:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B54C6B02A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:52:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFE1B56D4E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:50 +0000 (UTC)
X-FDA: 83819351700.04.72ED48E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CEAD180007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eICtvr42;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756223569; a=rsa-sha256;
	cv=none;
	b=oHPMOQl/hajeHufRWlcnfJzNlx+b1xxg77d64ULIj/h0fpHLs8rPmLPaOdR/1Xx0CS9x8x
	HlknGT0L5Yf6dOvNa5J00XQnrFRhXCk96BHusRdfGaKhXC9YZjaminD10oUZqUvtYtXkFs
	Af9F+JgXBUyYML/Kq8+3ljex2cVKvq4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eICtvr42;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756223569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVw501SU6uudltkjQH8m5gNg9OFmRl+080U2sk8LT+k=;
	b=nKvi3agNi8ZTpApKkYMATbhknHoa0aBc14SSMuYoWviK82qIszTP8yXd7oQmFf94QSdybG
	RYQ7GQMSBIqoef6hvLCKjAhib0SDu2O+Lo/tYhGNgL86K+xqET1hLVCc1XhhYhXJnNJu6W
	h3dZ6/KwkxSOTRoO023Ql75Oxj+AoV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71DEE45007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4756BC19423
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756223567;
	bh=KlCX2ZAg3q9wXdpobKxP0hTMgzjtmi46Iu31yrKbqwU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eICtvr42+J6+hYy2n8SDMDC1z3zNCoxeqOTdMYcsn2C9fBF8bCDufrhEFccejYFTL
	 2RNLzgOMCxWWiBqNMAOf6PEcH2fdv/ujIQMmztUK/UzOr8nfPImucZSB4tY1ftD5Xr
	 nxICBgGbZry+1RjKD3hyL/xyx/hoIwR4DGOgIynMZJ1BtBcjb3qgMO69Elm3mANkCV
	 zMf/sB55dut2S236PlDgbuMO7mAaYKIbHX+bWZbePExXoTe3atJrjxgCPPp5NArMog
	 s4YPNvVQG0DYYhDGxV3VTDaSwYKW6ZKXSvmLaR9betcSjOWI36W2gUurhcuDiccz75
	 vzs6FqHxTRy+A==
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e95230750ceso30124276.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:52:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPvQ4FxjAT1rU9mzOMHSNofYapf2a54eHBCsOiK4TP5XlvQ+ce/dB8H8lJr739GLrjUplDIytOQg==@kvack.org
X-Gm-Message-State: AOJu0YyewX99yoM/LtqYQsgAZd9EjJ0h/jPs9AyKT55aCy+ttle4tNV9
	puXEF5aF7RgoHSpnmH+7ebSsHVeMZsThIBiuOFUHv2IHVEQIKi7qqtQ9+2TtEskvCDJ0ydB29y/
	wiwD0yNA8hXarFbOFmmSuRgHF+2q0iDqU5b7Dn+GBJQ==
X-Google-Smtp-Source: AGHT+IEUMBoKAajA3iPBlepraJu69j4X8I0cRpMBfb6hpiggMTLtkGAy21vMq+d6fJmi2pqGEb2XkUE6TJQCFdkAvb4=
X-Received: by 2002:a25:dc04:0:b0:e94:fc8c:e1f6 with SMTP id
 3f1490d57ef6-e96e4792fadmr1443812276.5.1756223566425; Tue, 26 Aug 2025
 08:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250822190817.49287-1-sj@kernel.org>
In-Reply-To: <20250822190817.49287-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 08:52:35 -0700
X-Gmail-Original-Message-ID: <CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Lnw8=-qQ@mail.gmail.com>
X-Gm-Features: Ac12FXw9oMrwmMyOSTPZuCI29-0riX1CqHTxB7pbY4dMbsclAlSATWgfgwigVXk
Message-ID: <CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Lnw8=-qQ@mail.gmail.com>
Subject: Re: [PATCH v5] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEAD180007
X-Stat-Signature: syy6pwamzrzs5tbftxf3mhp393pfotwk
X-Rspam-User: 
X-HE-Tag: 1756223568-582001
X-HE-Meta: U2FsdGVkX1/HQHKgOzxJFSveugQaOKxCR98AesUiNGWL8iVzATotONb2BEUTsOpK+s8oby0l6BtG9Fq406w+/ZTFcbXsiwqCrHwygLX8XpeJrXbKEN8mQmA2o41fK6NuqRQcRPWZzt+v8toudffeK0Zvat/Kce+hhr+toxYytqdayh9TPH+ruH/DYLYY6gqeB9yicIWjS4CrIBfIHXjwnqbfkbtNy+4xRrQ4aRS2MXw/qdYeIkiHoY9Aa07i7NYzyBA+5pM60lJYElafuxDa7MVU2aPvINQjBIViBcqb60+2v6HK+7YwKhyhdwfW0VMoXI2RjlEL5xHyDOPu6n9HBlYKV9EyNP3Cs25tot7Z34sHd8i1UZpjs9rRY3bH9pOqZMn44I3qWdZ97gkW3caPIjqQazMwrtBPRVbAYV+/8Ya3+akz4Lw/lxjrjDsKvUfX5x1lMjxIjro+8DhpB4s4X/32jPYZgQFQqUnkvfVGRoasellU4J/mfgwC7KpR3gKOQW5VDB1gl5U80hcHZNNcFpcKWzsAxqSPwJtvUsYCt6oy2rB4sNZPo3DZKkPtE0d6vLyU2zx88lkBPMjmWxQ0aTVLbCJVqmKDWOe9t5i6h/ewJP0VRAzo3zPvmb80X9cM2WxbKiF+VJss5GL7E79fJXm4xaFNse5Xch16LC6ZgvT/etJ6IkReNKysGAEQlOE3mDBjM80b1mFeIKjvcd/XiD6heCzodOIs9ogQRvjhb9oMX/ZrLVUvnu2voCwijTWa5EWKOYT9VpCHlpXxIx1ZnCby0mrTsoPCWjFp0DSQxxJTmfx2zwjPz0FSXfpU3Y8Ii7ShK6jgMlodH/tyu6Qb70krM+RllGfE5UK0BZ4XRFm1DBsCULeC4Tsb4VFNd0FDiqKYzWida2c3mkKUYgQfb+uR3fsr4kM3P8Zg/U0ksO2WmHrI8LS3dNcGJ58Ug4rs8vru7aax3FWIeAet1Eg
 b3llCKgU
 JAOEdA6bga4H+ENjKA1WXQsArb2wxCUCwKWW3TeynBV3y6lXNmOalySuP4aD3DNzqPzZDH6KM4g8DeqJW/QBJyk1HIk2HuRANcFiCFM1OOZJUTS1uwy7IKOpaicUVzH+V7ml9nxm42C1SJGPS7LQ/NnKGB+K8sczDhYebP3l7u4UCC1vCQrEpR3kxxlukI8hLkx6DwP0MPEOaA6Chs4v9i0dDdL9Jcnz09fWvJKcNnGQpm26gVlcRV0iUf3h3rDFkAjUVAbcVEN4pwws5+iMkHZpYrxGUQSOQGX0J1StZh1bKTPcput0EUPJr+9Ohr288LruzDQyA6vttKdKhegd8jvDXXTGDjIe74bol
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

I did another pass review on it. This time with the editor so I saw
more source code context and had more feedback.
Mostly just nitpicks. See the detailed comments below.

On Fri, Aug 22, 2025 at 12:08=E2=80=AFPM SeongJae Park <sj@kernel.org> wrot=
e:
> @@ -971,8 +975,26 @@ static bool zswap_compress(struct page *page, struct=
 zswap_entry *entry,
>          */
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> -               goto unlock;
> +
> +       /*
> +        * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> +        * save the content as is without a compression, to keep the LRU =
order
> +        * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> +        * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> +        * to the active LRU list in the case.
> +        */
> +       if (comp_ret || !dlen)
> +               dlen =3D PAGE_SIZE;
> +       if (dlen >=3D PAGE_SIZE) {

I think these two if can be simplify as:

if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
              dlen =3D PAGE_SIZE;

then you do the following check.
That way when goto unlock happens, you have dlen =3D=3D PAGE_SIZE related
to my other feedback in kunmap_local()

> +               if (!mem_cgroup_zswap_writeback_enabled(
> +                                       folio_memcg(page_folio(page)))) {
> +                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +                       goto unlock;
> +               }
> +               comp_ret =3D 0;
> +               dlen =3D PAGE_SIZE;

Delete this line if you use the above suggestion on: dlen =3D PAGE_SIZE;

> +               dst =3D kmap_local_page(page);
> +       }
>
>         zpool =3D pool->zpool;
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> @@ -985,6 +1007,8 @@ static bool zswap_compress(struct page *page, struct=
 zswap_entry *entry,
>         entry->length =3D dlen;
>
>  unlock:
> +       if (dst !=3D acomp_ctx->buffer)
> +               kunmap_local(dst);

I think this has a hidden assumption that kmap_local_page() will
return a different value than acomp_ctx->buffer. That might be true. I
haven't checked the internals. Otherwise you are missing a
kunmap_local(). It also looks a bit strange in the sense that
kumap_local() should be paired with kmap_local_page() in the same
condition. The same condition is not obvious here. How about this to
make it more obvious and get rid of that assumption above:

if (dlen =3D=3D PAGE_SIZE)
               kunmap_local(dst);

That assumes you also take my suggestion above to assign dlen =3D
PAGE_SIZE earlier.


>         if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
>                 zswap_reject_compress_poor++;
>         else if (comp_ret)
> @@ -1007,6 +1031,14 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
>         obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
>
> +       /* zswap entries of length PAGE_SIZE are not compressed. */
> +       if (entry->length =3D=3D PAGE_SIZE) {
> +               memcpy_to_folio(folio, 0, obj, entry->length);

The following read_end() followed by acomp unlock() duplicates the
normal decompress ending sequence. It will create complications when
we modify the normal ending sequence in the future, we need to match
it here.How about just goto the ending sequence and share the same
return path as normal:

 +                  goto read_done;

Then insert the read_done label at ending sequence:

        dlen =3D acomp_ctx->req->dlen;

+ read_done:
        zpool_obj_read_end(zpool, entry->handle, obj);
        acomp_ctx_put_unlock(acomp_ctx);

If you adopt that, you also will need to init the comp_ret to "0"
instead of no init value in the beginning of the function:

        struct crypto_acomp_ctx *acomp_ctx;
-        int decomp_ret, dlen;
+       int decomp_ret =3D 0, dlen;
        u8 *src, *obj;


> +               zpool_obj_read_end(zpool, entry->handle, obj);
> +               acomp_ctx_put_unlock(acomp_ctx);
> +               return true;

Delete the above 3 lines inside uncompress if case.

Looks good otherwise.

Thanks for the good work.

Chris


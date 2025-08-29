Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A5FCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0CA6B0012; Fri, 29 Aug 2025 14:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8CA6B0022; Fri, 29 Aug 2025 14:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5316B0023; Fri, 29 Aug 2025 14:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBB36B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:14:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 720081607FA
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:14:32 +0000 (UTC)
X-FDA: 83830595184.11.CB8BB8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61314100013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:14:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dadxvsEd;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756491270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lqw3El7jBOxZT+qIHe+eV23VUrIZ/rFDA4IGhfLlSyA=;
	b=KSVJceyDw9E8LOBfFwDJtS7o9bZv5QbTW50Ype5JzHYcpJAcyqyCzoIcZFUapzuXLhOBWK
	4cLe0/fUlMfRNZ0fAX5LDlEXlI1umZMmbX8vcwE3HYtduRKQraS6zldmdIKCQlGkpPCCMB
	uOIW0+UZscdz4YSfpXEyaLTI1zBHPZo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dadxvsEd;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756491270; a=rsa-sha256;
	cv=none;
	b=Nt5yxALzv7tZHlQHbx0W7tto9m6+ZP+u5E5v4lsV52qAUbMhlqd8VtEVME1zxLbu9eJtx1
	ft/DnaJ9FwrU3Bjlkxv2EBys/qCNr7A64XMDOW6p4ht1mirHa9iZe0uP2y5k8TnBfEm0O3
	Od8verKnw5c0SosoTSK8OOHpeRmJP2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4A87456CE
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86B2C4CEF8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756491268;
	bh=yRJt+TegNK6W+502znezjR7f/M/raLPdTP7KKYAHCIk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dadxvsEdsUz03D4KiiBUc6rnx4w9CKtysKQ2Eg9I2yOwV2Lcyincoq9j7MNXm1TkO
	 Zc3GbMvM5v8gf3EWbLMzooNOltkGZxXWhRG5oKXrjdCTiO+uqvwJvm9T71MC7LSu7w
	 eVYSi01LnVrJphozAp7EF6+LOQoNSpruXRtbdg9w07IuFW2PaPgPdC1wSKxmTKCXr5
	 ZN211+cuxW5DyUHCOyh8IpxP8detqr/QJ7FedvATGKPfAE25V0X/SNZHaDC0yfQ9m3
	 Wz/vRB3u50epHjtJ0ea+00Lh19KZWWEW2XwWB75ei9hYbR12dQu/ypiTmjnZUo25E6
	 Sg04yo+wZ0CAQ==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b72f7f606so3405e9.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:14:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXisMj2tK6qXA6jS5Qbe6XYqmX1WXdvbDZFEnLG8iLCHt4mqa/taqfVnv76nJph1KT3zPmD9cMmgA==@kvack.org
X-Gm-Message-State: AOJu0YwuHJsOym+mqf/CqDXVjYJbqBe9G8u5yYMB7PPRatfzySjswYTk
	3itfP6uUx3x1jbFltzhXlTmpiDa0h7/kUV/9FaXwvJ40pd4UFP8gUwv9a/ER6Ixfn9gtinIsoge
	gFXo5UdzTSwcRs2OS9KSGcm85qkOkv2ocGV/6Ssve
X-Google-Smtp-Source: AGHT+IGMRQV1XZsQIwrNNqTDZtdRqBuWEXIqyZMGeqwYHLrc/h6k2Q/Qn1Z0+Fezw7s/S13TR4rhAli8suotYoqiEqU=
X-Received: by 2002:a05:600c:8906:b0:45a:2861:3625 with SMTP id
 5b1f17b1804b1-45b84b4a04fmr43005e9.4.1756491267267; Fri, 29 Aug 2025 11:14:27
 -0700 (PDT)
MIME-Version: 1.0
References: <CACePvbXnaWZh61aH=BHoGDqbKvBSE52Me+PpE-WMXcGpRy0FFw@mail.gmail.com>
 <20250828163913.57957-1-sj@kernel.org>
In-Reply-To: <20250828163913.57957-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 11:14:15 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNFEc6GpjzrTAF59jU7Z9OiGujqHm3086aUhG+Y141iyw@mail.gmail.com>
X-Gm-Features: Ac12FXwUslqnoCOE6vybxi7aGMsQj_ykVBv57KBSkgX6Y5hLisalD99VAYpNJHY
Message-ID: <CAF8kJuNFEc6GpjzrTAF59jU7Z9OiGujqHm3086aUhG+Y141iyw@mail.gmail.com>
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
X-Stat-Signature: 6xuzoxr49bw96hzz34z6xry5p49or3sa
X-Rspam-User: 
X-Rspamd-Queue-Id: 61314100013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756491270-406575
X-HE-Meta: U2FsdGVkX1/Xwa7IAH0dKl/rbA/eY3QttdsnHikP6XzW3nLGXjxm5qXj25JZuEjDI8BbdUY8T95x0WQWcXhwnmVIb7PvT0oNaZnK5WCvCl+XtkcBaMlSPXfFtRCsk+egwf7yGrJ+fJ4dMxCuFw4b6JLjCtnb5V/yTJnnPBXX1TWA1dNpFWmL3WYL5SskCNKmdcDK32op22ScKUOoltdKm9E5/WADQtNEgTRESVSvtg5XlM+4+ja4tfgD6eZRxXchkannyAUR5hFbeJjtHv+j9CQKRI1eZJj5kcDYMaoR2GzKWL9zUMneAmsm+rlCXwkySIAx8T5gSvFt8ExaEQtXcTCjUXWYMP5tQidJEVjJWa7POPJGiSdfdPLjrmp7sXvC/S1u8jhEDhy4glTCRLbK4jK9aHcKKC1pwJlfSj8uVj96AVTlGFob192dp0eF45dLLZlyHP1F9WOPc/wFGtAF2kZ24qNZGsHslOaghg9uD1cZV5TEVEOZ6a/dqyBbnDu+2KZ0fnvyiohmumX3G+WWYO4OBIOqmzFugAns+FR4Wp6T+FYtghSdoDanTwUxu1OTmucsOQIzojrX2PNnWc7bUOxNheskluZG4x31BcV7vWKET9IgTzbvosEmPPfi5iKStqBUiOGyMArPpaY3lFZCkIUbRV0FsFj/qorBOGCLq+PpBVLtlTbDVHgV7PwWiwe9TmSpFqqyNbKA3b50vgegzE9xzJ4gpDyzg3njo37ScvrmWgcPiilxkvrQuzxuxppzcTUTFSne2jhkQTRydHoSnLB6qpaWbM5+ngtfkygCIJp65w1Yq6LSc05UGpTVSmf/8JZpCeeP9OsvkRpNPOoatgWmovHT5tYQEDDU0apdOjZ8uSphLIjffFjeEIbUtl5W+CFYtEEk41fceyJxuNT5+ZeP1OeSgu4/s2gx4M3wt/s1Y4U7jkxmGmbcN7YgxuoLuA2IKJ01+dDxYiP7CY+
 aGtsayZE
 28r7I9HQ9FDabFDr+Y95ESzvYn2yNZDfDltS1NE2fbKEL8dddns/M4Ges6YtTZ5OpVQiV4mF3ylC4T2j8NVEw6y+U7WnBJUlIPCVHYnMGD/lIzFs3qPRRmulq5I/lNeDok0zx54dL4/7MoBn788S9zhE2ExZAmYWdemqcnYRFl5M+NONlEdY+DfD7FcbckFhXCDRwmULsogBQI0Ml+vkBOFlij2Rw/71l6sX2EwgOP0fMz1kybLl3oP0zla0yxBit929/GcqhrREco+ZjVkz2N8f5fChuS5clmPWZWwvd8wgZSo110lilAhpRqnze7zk80reAxAlLnspZoKw1LaSHY1yAWTej1G9yjj6WuuHpPC6+8ZDh5cchCyORWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Aug 28, 2025 at 9:39=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 27 Aug 2025 14:16:37 -0700 Chris Li <chrisl@kernel.org> wrote:
>
> > On Wed, Aug 27, 2025 at 10:45=E2=80=AFAM SeongJae Park <sj@kernel.org> =
wrote:
> [...]
> > Anyway, I just opened the editor to check again. Yes, if we goto the
> > read_done, the if condition using dlen can introduce a new incoming
> > edge that has len uninitialized value to be used. Yes, need to
> > initialize dlen =3D PAGE_SIZE or you initialize it at the memcpy of
> > page.
>
> Thank you for confirming.
>
> >
> > > I will post the fixup by tomorrow morning (Pacific time) unless I
> > > hear other opinions or find my mistakes on the above plan by tonight.
> >
> > You are too humble, that is the normal reviewing process. You can take
> > your time.
>
> No worry, I just wanted to give you an expectation of the time line :)
>
> Andrew, could you please pick the below attached cleanup patch as a fixup=
 of
> the original patch?  Please feel free to let me know if you prefer postin=
g a
> new version of the patch instead or any other approach.
>
>
> Thanks,
> SJ
>
> [...]
>
> =3D=3D=3D=3D Attachment 0 (0001-mm-zswap-cleanup-incompressible-pages-han=
dling-code.patch) =3D=3D=3D=3D
> From 867c3789fa80ac163427f1d7804bf2c8667684ca Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Wed, 27 Aug 2025 13:18:38 -0700
> Subject: [PATCH] mm/zswap: cleanup incompressible pages handling code
>
> Following Chris Li's suggestions[1], make the code easier to read and
> manage.
>
> [1] https://lore.kernel.org/CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Ln=
w8=3D-qQ@mail.gmail.com
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---
>  mm/zswap.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f865a930dc88..e5e1f5687f5e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -952,6 +952,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>         struct zpool *zpool;
>         gfp_t gfp;
>         u8 *dst;
> +       bool mapped =3D false;
>
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
>         dst =3D acomp_ctx->buffer;
> @@ -983,9 +984,8 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>          * only adds metadata overhead.  swap_writeout() will put the pag=
e back
>          * to the active LRU list in the case.
>          */
> -       if (comp_ret || !dlen)
> +       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
>                 dlen =3D PAGE_SIZE;
> -       if (dlen >=3D PAGE_SIZE) {
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> @@ -994,6 +994,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>                 comp_ret =3D 0;
>                 dlen =3D PAGE_SIZE;
>                 dst =3D kmap_local_page(page);
> +               mapped =3D true;
>         }
>
>         zpool =3D pool->zpool;
> @@ -1007,7 +1008,7 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>         entry->length =3D dlen;
>
>  unlock:
> -       if (dst !=3D acomp_ctx->buffer)
> +       if (mapped)
>                 kunmap_local(dst);
>         if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
>                 zswap_reject_compress_poor++;
> @@ -1025,7 +1026,7 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>         struct zpool *zpool =3D entry->pool->zpool;
>         struct scatterlist input, output;
>         struct crypto_acomp_ctx *acomp_ctx;
> -       int decomp_ret, dlen;
> +       int decomp_ret =3D 0, dlen =3D PAGE_SIZE;
>         u8 *src, *obj;
>
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
> @@ -1034,9 +1035,7 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>         /* zswap entries of length PAGE_SIZE are not compressed. */
>         if (entry->length =3D=3D PAGE_SIZE) {
>                 memcpy_to_folio(folio, 0, obj, entry->length);
> -               zpool_obj_read_end(zpool, entry->handle, obj);
> -               acomp_ctx_put_unlock(acomp_ctx);
> -               return true;
> +               goto read_done;
>         }
>
>         /*
> @@ -1059,6 +1058,7 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>         decomp_ret =3D crypto_wait_req(crypto_acomp_decompress(acomp_ctx-=
>req), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
>
> +read_done:
>         zpool_obj_read_end(zpool, entry->handle, obj);
>         acomp_ctx_put_unlock(acomp_ctx);
>
> --
> 2.39.5
>
>


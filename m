Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB390C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D80C6B0005; Fri, 10 Jul 2026 14:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789846B0088; Fri, 10 Jul 2026 14:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C87F6B008A; Fri, 10 Jul 2026 14:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C04D6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:22:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D89131A0519
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:22:58 +0000 (UTC)
X-FDA: 84973688436.10.832388A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E74351A0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:22:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUBp5p39;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783707777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KTDWmq+3W3+x6k58hpwkrEI3HUDGthZ7rteRUOzbhk=;
	b=r0Zea8UleDqW0s13S5JKHPex9BN1zz6SvIAzJDbHtKtQRg6eKkUkOqCf74Drq5ze6d4nv0
	IORbK3qQSBS9J4U8HEuK6OWTkgbb6Lgg3lE94ong4Cb4HEc27eG6eNxqxkimy89wtty4VX
	mTV+ekmTqmx4L23Xh7XOYW5ZV3NynBo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUBp5p39;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783707777;
	b=EUCWAvCbCTYKI9rQp0JOXTuPNbtj1mTafnKPmWh+0FwYMNnB1vYLFClU4WCFTRhgxhxBlB
	bvxVUJkrRRQpTuVcx0nmFA1TxpRDuODNqFUUf1LXpltjSeDpDpJx7NVW2s6XzCO397wO2H
	vDG3uCCMk1ptTeKmqzduGO6Ej/66Pmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCED243CE2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B851F00A3E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783707775;
	bh=3KTDWmq+3W3+x6k58hpwkrEI3HUDGthZ7rteRUOzbhk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HUBp5p39jmQ15xxjoGsrx6lWNQIzCGJh5Chq6CG15x/9ilbqrj3tiCp1Xlu/OazyF
	 0hFpr9vLmJGv/Q1UjU2GPbf/tgTX0Vs0rfse8dUGIr1M0Vvv85x7y7zM2pX2yGw9qy
	 e9G31fN4vpf1ACbtFA+prvSXXCbttLciCzlhTPejGYe7kIAGR4SLzaVlh0imSlEiw+
	 FBh3dtr4I5FnsNY3g6H1ZvtAX+pzNkwvzuk/PzsY5jpeyDkWzoSarsGsl/RxDuPabx
	 4LPr4V0xOGa+3u5Dryl1Afsmcs8vz/xQWr+IlREo2//7gmNQ4WgV8dekSgniKL++R4
	 e2yO/rALA3R/A==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69a5ecbbfb2so1936234a12.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:22:55 -0700 (PDT)
X-Gm-Message-State: AOJu0YyXCFRJEjx2VotE262OFg7FKc/7OHLzYXB4LeWvF5q6et7XEUdN
	0fUGJ/BtYIn4ygBWzAI2Mrtd+qLkwHbtNuYGnynThMXR+YFAGoll0CvHlNBo/+M/PKoMuwfU273
	5lpDUUMDlTHZ4GMJXDWM5fJGvtm0+Gk8=
X-Received: by 2002:a17:907:9483:b0:c16:86f:bb10 with SMTP id
 a640c23a62f3a-c16086fc6a1mr134332366b.48.1783707774593; Fri, 10 Jul 2026
 11:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260710082822.583930-1-husong@kylinos.cn>
In-Reply-To: <20260710082822.583930-1-husong@kylinos.cn>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 10 Jul 2026 11:22:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
X-Gm-Features: AVVi8CeP67i9q7KNHqYcdJgVdQ3EjZ8ycjdmhkWOxW_VJsXAPZdKOfvryLSDsHU
Message-ID: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression path
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E74351A0003
X-Stat-Signature: sgqi7i1i13kf7rw4w3tboi5bx47spigb
X-HE-Tag: 1783707776-502981
X-HE-Meta: U2FsdGVkX1+mL6YQvBvpSWQoTKSiyz9nikvID6M9bJS2trg8r28iX5Kay34en7N3o9HRR1RH7blutkbwUrSB2+1oVOq6pfqjesmWQa2vDD9gicSZe4H8Ma3IlZ7ci0koT8HMMsEmHtjO9XKbIjBlOwhqUk0vMV9ENpfJf7zvEi+sNLoyMoe26ZXfpgz3vCujUJRzXWwROl90BhPrLnxDRUnkc4t7y+22Xch2J+WvZ4xSrY3nirHZ3pqQMiqdmGsbnPv3/TrbZwtn/I+J6EB2Ak2Pg/UAGwSRHktBUExHCEMrIRd4bWaE00CX6CDJiq/BW1xDsk9Ka5kL3A1naxksfupQRGNA5e9J0GAZtzsqt/2Jm7jUtHKfH8l3guV6RaLRXt5KtKvOLEKXl7zGrwlXKGzPvVX/H/3ivswdNrSFIMxobzFBlF9xbbpPt9abwIoW11cBffyP8fgtVFWDDLMeqAq4+3xItHlTDkUY1K/0TXX3iSFZepd3u8vDcJ/LRMwH9tCEjga+5yMLUJSylCu/5So07Dzz+e6sFlTCxlhEM5zLCD6HmKXPCCxJwGXQtYli7F10otkAOK/6pD0zS+7d/K1Cm7eANF30zybwLfcHuMUfvBajE9xv34l5SU2FyWq3qyq6vPKOAu7WL4JXmSpF9fTgVE5KvOnqp+fiALxbU7VZsUpZAu37qoA6jOnuTqr/OW1jpzSmvBoe96Fj70bDDP5BsXJVZ6Z41lK+8y9upkTq8ALFw9KnkUjve1SCegvL4byA3inETP8XKzWTmRjIuKZ0br/CjljkBzkyEPwwtLA3c3jjEORSSdwaXQmmYMVDgzOb8ZraAb04NAzF1RbfIVOhm7pMb/XJm1Y2Kc1LROCzlw8CgIRzCnVf1xmiRn26AYjQ9qlIzeLr88Usb/X/XgNExnH4BFwJLzul9CdUOrXSa5sm2eweCeT43g3c8L0gISmNjfxR0Y3FeCrHyZD
 9nARmnQE
 ofehrut9CUc4oazTqVyt4RBT5DCz0CQiMXY/4ApEEa1bt+lCv3/q7j/ia7YepqQI+IBuzncH4uYIvQ6uQLCdViLzUB9GwMj8jLtiFeq5UaX6Wlvq7RisG269b7PENOlI6XbmZeWeH2Tli1yRO4gls+qSUySCm0GoQsvoJKWSm/ANgf2f1356mPi9lIqNp/rZdrnQmzzxUFDO/g6wA+3C4XY/jqPLs3e6IEVgQn+BjXsFxCEmRI/kAj6845jIDzI2GhNOL7ldISqfZn+c83ONo7Bqr9YwogUO54XaQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 1:28=E2=80=AFAM Song Hu <husong@kylinos.cn> wrote:
>
> Both branches of zswap_decompress() write the destination folio through a
> kernel mapping: the incompressible branch via kmap_local_folio() and the
> compressed branch via the crypto scatterwalk. Yet only the incompressible
> branch calls flush_dcache_folio(); the compressed branch was missed. On
> aliasing D-cache architectures this can leave stale cache lines visible t=
o
> userland after a zswap load.

Adding Herbert here.

Doesn't the Crypto API take care of this for the decompression path?
Maybe in scomp_acomp_comp_decomp()?

>
> zram flushes in the same situation (zram_bio_read()). Hoist a single
> flush_dcache_folio() out of the incompressible branch so both paths are
> covered.
>
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsma=
lloc")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/zswap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index b5a17ea20237..bb0c16d102d5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -943,7 +943,6 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>                 memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
>                 dlen =3D PAGE_SIZE;
>                 kunmap_local(dst);
> -               flush_dcache_folio(folio);
>         } else {
>                 sg_init_table(&output, 1);
>                 sg_set_folio(&output, folio, PAGE_SIZE, 0);
> @@ -954,6 +953,9 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>                 dlen =3D acomp_ctx->req->dlen;
>         }
>
> +       /* Both branches write the folio through a kernel alias. */
> +       flush_dcache_folio(folio);
> +
>         zs_obj_read_sg_end(pool->zs_pool, entry->handle);
>         mutex_unlock(&acomp_ctx->mutex);
>
> --
> 2.43.0
>


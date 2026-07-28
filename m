Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D30C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214986B00B0; Tue, 28 Jul 2026 18:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5D76B00B1; Tue, 28 Jul 2026 18:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4016B00B2; Tue, 28 Jul 2026 18:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D02F46B00B0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:15:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A8F2A04DB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:15:33 +0000 (UTC)
X-FDA: 85039592946.26.991F1C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 450ED160004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:15:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9dJRPoc;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0eBsWs0q2P0UZ8e/AAn7CCfkvDk0gaFdW1LovMU5z8=;
	b=0iUZH43UKEojc7sMnBas1TAG2eKhcGRX5sd2URxOjLwAcFjY9QznmqmE7BnXWn649aHA5p
	cjBomnWnpPsvjloaB7qSQJrE3A2BNMvZBj97YruncPxX/V/oc4YVsdJAMo9VzeZn2sFivc
	dQtJb1mqIHqA7WIMX+6LfL/a9VH760Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276931;
	b=x5XQZgNRZ81Ru6N00WQZQrjbdrj4xMLWMPSyxeAr61KYoNbDhZN1GY51DABXcREzJ+mZCs
	x4VkkhtlIxkmqm9ZGXhyEsNh+Hr5swRiyDQZ1i5yjVo7AddEAXqOhPVN9zrGs7m28USDLg
	4a289GhKXGfLjnL0DQfAvuVX8K1az68=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9dJRPoc;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13CC243FA6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1AC1F00ACF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785276930;
	bh=N0eBsWs0q2P0UZ8e/AAn7CCfkvDk0gaFdW1LovMU5z8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I9dJRPocb/4jRas48A2VZOL63OhqO9PhEi7JKwLeN1+D/O5pAsIl4hIMwGUhO5Xc5
	 VB/yhCs+er6VAWNnNcGTjybdde6FSRU6eWmvVikfVUpdXwDz/yZ8jF2n9XNHSnuZDD
	 QtMuJX68srRztqv28o5TcUsR2vFbiv+7Yfxczp5PbbkvAHy/aPuPafoEc81ejYVt5G
	 QS3Cizi/GD77RWYWFLUMZTibHrRNaIkcTcpzg+YNsu+jf6p6FV+Qzeez5E9szjNhZh
	 /MkifwlM8EqDL1yfZ3Q0cxCYFz/RP5hQPBYgYlO24kpt1ASFlAWYYVzdRCR4kBYLHK
	 pbkoP+DWyRYjg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15cd3fd760so37471866b.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:15:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RorpnUz8FI9b9wzWAuPDu+4XcZShA5G30Ile9ZwszZ1a9XKuIh2ps7qqBdoYq5w74m0nJKlmwD0cA==@kvack.org
X-Gm-Message-State: AOJu0Yy6ktpNcpxwCbkEhKLSyKUDll19xnCMtZI+XyVwiDXJIuKRuPNd
	tQGj5fNKZR48OYiuMIhv4jvDbNSGZdCh3BrtWaspW61WoxVCpQpVFDPHLTLr7OFTprbNoPv4tsr
	XIyVw0cJqnomhSvGsk+Vow1+29xHYfSI=
X-Received: by 2002:a17:907:7a8e:b0:c12:6632:e7f0 with SMTP id
 a640c23a62f3a-c1f7215c7e3mr220028066b.24.1785276928806; Tue, 28 Jul 2026
 15:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260125033537.334628-27-kanchana.p.sridhar@intel.com> <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
In-Reply-To: <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 28 Jul 2026 15:15:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNbf9as6ecW=ktGu21PZbixpUwADpYTQ9Z4sCp8cufX8Q@mail.gmail.com>
X-Gm-Features: AUfX_mxmAAF2OnOz1425OOiRR8ewIViwu-1NOZWKO3MtBqR-1IxZUGx5IgblJqE
Message-ID: <CAO9r8zNbf9as6ecW=ktGu21PZbixpUwADpYTQ9Z4sCp8cufX8Q@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: He Jixin <1270243756@qq.com>
Cc: kanchana.p.sridhar@intel.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	ardb@kernel.org, chengming.zhou@linux.dev, clabbe@baylibre.com, 
	davem@davemloft.net, ebiggers@google.com, giovanni.cabiddu@intel.com, 
	hannes@cmpxchg.org, herbert@gondor.apana.org.au, kasong@tencent.com, 
	kristen.c.accardi@intel.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	ryan.roberts@arm.com, senozhatsky@chromium.org, sj@kernel.org, 
	surenb@google.com, usamaarif642@gmail.com, vinicius.gomes@intel.com, 
	wajdi.k.feghali@intel.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ocq88okqkdg16szydape17me8orrmd1x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 450ED160004
X-HE-Tag: 1785276931-380369
X-HE-Meta: U2FsdGVkX1+tOIOjd6TRzxPzrcUnMteaJ8+X97pV4xNKfeCTqv5HQQfzBSBy74OZpkmLC3kS+TGsup1F7Zi5/snYh8bM1uQv2Of9v5XL9a+wcYwcJHm7Ct6gbsoTT/f50JtlMokq+l4mvTVujLNfra3tnYnGAxIGSxmWvh9ytNBsVf3l6II97rDQPU0JlWoqhvWqDsjAOFxVtZ1GCWD/kdCa8dX0ebt1N3GnGKcWPNzn7x/JykO9zC1ApDck22qIA21BcrnIJAs6MSc8TbTYYqmX+xQ1If2/VabeXpTXSNSgMTddEOiF2AuRfJoJVD/ujabfkeEC0PFioBjWa6ZGF3hdXelXRiM3hNJBSNKj6qeL9gv2kCzYnnWgxInXO9f6udRbjQDa47axxtH0kR4tyifetxFV81et2Hhj8/TufRfJn+GIahN9OlWZ6ueHrMDQFwiIUua5T/wHso6JEjh37q5+GzkcUsicJBDsgxS64qzUclLyNNiCkZJfQQj+LYzcy7lfF7GebeqcrqooCFZ8CF3Ls3m2GX/T6DCMrKdDg6jHlA0tGa7RRX6zfq1dIDz5H27/2EGlOnUMt6EBMPSGLT/RNfIF/6pgNtrQEWak8NTkUW6pG7IqKlJ/e9mrl3/x5KxQFLj4KVKjzZ4V4gwD1AnzILo7AwAc4i2cWtGqyTuFTuJ+yrVJKduzjKMSOGi5B3gMvp8JQELAWSYH3LRgYTGIML8BW9EkrhJtk4mZIwxt3qhX3/clurvVa5zYXMW1ahlXgyks+lZ7SI8NkzfrTIOxdty7qKewa+LtnkEZRWv7RAGniyawI2+CcTkPJ2YB+YQ2kFigpM9nxsIk9rrQ580ModDLUHdj23UJEvHpePfEcYEErqom4DQn37CRTx0EiDXQFyCXRQ0eH9cShJWsoTZbjhL12KcBY5/mVtkzfUS23Qy1ynfcL4IaoWXNdt2DuxjjQ1TjUvex58m+iEU
 A+mX5yjx
 qHzFSqaXxrsvNNoiFx3oFUb02SZsV7DD3bBQQklzdFQzc9tK991F/jbVCKL3mklz6oxgAWbdm1vsOeL8PlvB2wiw/gReHlBWCcCODgD862iyNTwWZAaz+ma6UyoItXM8sppF9fDtd+N+YAYZe3tWtwJdPniK6BM8Bo9oG9Va6vXavCWpB0k7hIwUJIjNleJzt4wA+9c2DR4h9jlQi6vn+N2Dh/wPBy+owGNVDKXwpugXmal246aP0qGbxIKL0KJoAi5J6RS7Y3UEeKdHZ4Qk5iJCuDG2CduAuL5mVlknucx5ZgI1yxwx2dsBsP12dVUgy4yQJnaOntvaEhh7Z9ebGUPXtOhhyb19VfrS950z4Th+HytaBDk//ik51T9fTQKaFwpR753DOAOty3zE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 8:05=E2=80=AFPM He Jixin <1270243756@qq.com> wrote:
>
> On Sat, 24 Jan 2026 19:35:37 -0800, Kanchana P Sridhar wrote:
> > +                        if (dlen < 0) {
> > +                                dlen =3D PAGE_SIZE;
> > +                                dst =3D kmap_local_page(folio_page(fol=
io,
> > +                                                      folio_start + ba=
tch_iter));
> > +                        }
> > +
> > +                        handle =3D zs_malloc(zs_pool, dlen, gfp, nid);
> > +
> > +                        if (unlikely(IS_ERR_VALUE(handle))) {
> > +                                if (PTR_ERR((void *)handle) =3D=3D -EN=
OSPC)
> > +                                        zswap_reject_compress_poor++;
> > +                                else
> > +                                        zswap_reject_alloc_fail++;
> > +
> > +                                goto err_unlock;
> > +                        }
> > ...
> > +err_unlock:
> >          mutex_unlock(&acomp_ctx->mutex);
> > -        return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > +        return false;
>
> I think there might be a resource leak when both conditions below happen:
>
> 1. `dlen < 0` enters the first if block and does `kmap_local_page()` into=
 `dst`
> 2. Then `zs_malloc()` fails, hitting the `IS_ERR_VALUE(handle)` path and =
jumping to `err_unlock`
>
> In this path, `dst` points to a kmapped page that does not appear to get =
`kunmap_local()` before `err_unlock`.
> The old code had a `mapped` flag and a common unlock path, so kunmap_loca=
l() was called on all exits after kmap_local_page().
> After the batching rewrite, the successful path still unmaps `dst`, but t=
he zs_malloc() failure path appears to bypass that cleanup.
>
> If my understanding is correct, the fix could be either:
>
> - Option A: Add `kunmap_local(dst)` right before `goto err_unlock` when `=
dlen < 0` was taken.
> - Option B: Restructure so that `kmap_local_page()` happens after `zs_mal=
loc()` succeeds, only for the compression-failed entries.
>
> I'm new to the mm subsystem, so please let me know if I missed something =
that makes this safe.

I think we are indeed missing kunmap_local() in that cleanup path.
Unfortunately, there hasn't been much progress on this patch series
recently, I don't think we'll see a new version soon :/


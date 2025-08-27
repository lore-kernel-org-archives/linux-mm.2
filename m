Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5A9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DA28E000D; Wed, 27 Aug 2025 17:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25498E0001; Wed, 27 Aug 2025 17:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62B48E000D; Wed, 27 Aug 2025 17:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 970638E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:16:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BC70118D9F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:16:53 +0000 (UTC)
X-FDA: 83823797106.01.DA4F1BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F2E110000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:16:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NGtQFa50;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756329411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+znbn45JnEb5PnxQ+24j7aBsmYjndw1zfolqGsXuUfw=;
	b=gUCogOS0xdLW0qiMF/8j321bgWCFTJsUpPExwzy8KRITfdCD5DYViEjVQ/JDh/JsaiIcW+
	EN3hDVqR45ERb36zZsDceBm6h4j3iev9fE9QeZfyFxc8RWl+PZhMeVoIr6oJCf8uK3VqS+
	/yFoD7CKcUkmd8QYtzmDMbAWj91WvVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NGtQFa50;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756329411; a=rsa-sha256;
	cv=none;
	b=v7t9gH6Z3hA/t36ikonK4sY2j1JEkqfFTT1ZCp5Fevc5JML+KybkkWIxFmr4em4ofOgZpv
	ctl4d8XHO7BeILiVvrwEa9tSZ27CeZfBU5aaF+g7qlZwynxoiLoEifhtMvRAYoUT0LfrkC
	8KCnbjI0UoBajHNdTWN129q0L3IRPqY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EECA544191
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD374C4CEF7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756329409;
	bh=h2vwcYvB52wM6p8rPx+g4cI7a/giRHNuNaRI6L0ndwg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NGtQFa50GgZfyUt2ZuklQdFNsYfU7Ys+pBXZw8rBRW1zV9/d+vb8cykG3SNhiz1ju
	 ntwrf/VUpSNZTYkw+edjpYah9yvLRRDK/+Q0pfk/KjsYptsiGmDdMOKGKytBlYH79B
	 idZv06zyv/gxjGjsMVGWdKkmFtx75Uuf+3v6UxjKAKBsaZyGYOGeS/qQjvs/aA8cg6
	 nslq5b5+CYWVk5khPQ3gcCLPMIHBrk8zcdtCNL55XL2aFJDq8gocRgru5Gv0folsVb
	 IlzJyV7zVvZGG8zVIGs0jbuLdPOHgyYH9mg+RqBhcW/O8uY6NRNeSEZIaeozATIKO4
	 VBAdq/fSgfpCA==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d60501806so2204897b3.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:16:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWf3qgOWmDFkFwD85g4sW5w3gElUWRI9i/GMEqg6ehdqHKsdSTveByELZWqg440UvOgMn0jNN8xTw==@kvack.org
X-Gm-Message-State: AOJu0YzCAgVKHmg7//wfo3RXUO26inUtyX4yHdb/n1N8aw2cEZ3x/V8k
	XlKkM2gIXBoNiFI7Hf+7aj3SSR/sWCeIxRVkRGqdMHwXONY+IrFC37xnMXJ3zlsIGgZr1M6F7dl
	48kypkwgskQEAt+YlNxScQQqFVyuH2NJ1sw5kku8AMw==
X-Google-Smtp-Source: AGHT+IFExBNFXHaK1D9PX+y6rV6yrbQyNeRcW17eknQkn390Bdly6Ur/L2Q/PGdRn8kWIwZ+xuAQ6TWixh5N9DqDn2s=
X-Received: by 2002:a05:690c:3345:b0:71f:b944:104f with SMTP id
 00721157ae682-71fdc568115mr250305367b3.50.1756329409097; Wed, 27 Aug 2025
 14:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <CACePvbWzyqJJxP8BFXS_NDLcXCz-YXkt8eYBxv3CER9RpnJVXA@mail.gmail.com>
 <20250827174513.47171-1-sj@kernel.org>
In-Reply-To: <20250827174513.47171-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 27 Aug 2025 14:16:37 -0700
X-Gmail-Original-Message-ID: <CACePvbXnaWZh61aH=BHoGDqbKvBSE52Me+PpE-WMXcGpRy0FFw@mail.gmail.com>
X-Gm-Features: Ac12FXxDZkGQigQMPqlJ2_x7uvW4YhEBBCZKu1uKYoU3sLqFVC_3DHYznctEp38
Message-ID: <CACePvbXnaWZh61aH=BHoGDqbKvBSE52Me+PpE-WMXcGpRy0FFw@mail.gmail.com>
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
X-Stat-Signature: h9y7zenspchzfptxf5j63g3si31ju4w5
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F2E110000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756329410-61813
X-HE-Meta: U2FsdGVkX1+4mkxgwJ/f7q+eOIfO+hGCEcRbi9uSCHDEAsmOLKH2E+0OC93nD6aJ0rn1eQK2Ge38u9pd1EAsCmqow6sHLbGzjTWCUlyIKB7E7iE26KlLmnJZz3SOo+jE2uMX+gbdYd5wvyoDUJRJQ5CSCWlW1c3Til5BKDREqkpHUjgGAPNVVGnSX0Ko0QUHLjtVfNmt2S06BnEZSLehNl4KOnZpy+UB+J/IeyORGR/lFeCtgXXRbClvz1DpNTZsecNZ4rbMO4wdfSKAfubI0l7ZxvXZtHMm3F2rwCBmGxvpNgQ1XfRzxEymWuiYFUl5z44sXOVZceatQLG1VPRzA7BWRJbuC9tgtVV7fyc1ffjJZ/mGFMKC5HwJlEhw9Om7GU+9HrqVo4w7CBfWYW78BHWgJ64DG2wVS43HsYmQNcSgSxNi5mm+ao3Wp8PNicrgzWNWr5qgsXNOZKp5jK7bDKxEyeeOdI+g1vzrmbuazFj5fMDyQUKWYtuUlRraumOURf+ybAFfdiv+G8L1/YeVw2iSOlYiVLLFZ9DesG6IZuyhZ7pftkjSseoMImsknXtzsW+CjOb1Eda+rgx1Iz/4d8JtgsZJNUaz+jP1ga/vO1MG5zP4HnbzD9TlOREHTTBx6VBALn1B4kf7BMUqnE0uRJSw5CgeYajtJGO5D0i+uDfvqew9ok7ufsz8JjgwEKa6JZUYfTHPdnKQ7THmUiVBn4CNy7y7lNkLBnyNyKrId23n8YwDSQ70JXdR2brFi4iOfguxyeF0lC7vXwIFON76w9if9w8q0osw4ClHfeYr5JfYIAOhQ9+gWSQH/xhwL3tlOpHDACpJfpm/xv+R9CPQvE/wFgMCpB76DaJjLV2gqBV36wdCPwQwwBPgtOdrlwbt1AqN8napfkkZ+Uc3Et4N4PCv455Wo6TeK7s/6WzEIUa8Nv2CqsSs4oqVGWDAA6HGLwQm2GovgC3Nhqv2Qxp
 all+1HPj
 MfVfaqOLuBZhNSpjB8zp6NmlRvK9GhjEx1JR/WycdWy79ySNND4Wtpdwf7LgDovybyt++XfvagLXn2i7BBYo0jK0PBt416tBlRJqoAN9A0S2DzYn1OjhmgC/bk/3E9v0z1ordDXraQSEiJBktoDDRmzUO6p7/QbuRDlTre+mc+tmHGK0sScUv7bI79YAeR8Ia39kCekMeBv4tcjl5yxUYQ1XOIfh3oDXWtqSpgejPadkhU9r/9zfVzUfyXEE7rjhxa7KNOUP/ftvQD+iBqQTBTcNRhKUgkVgRCokZsLJ9whCvhpJthUYoSPLOX0PLRCY9zRgjwOW8hGKYHMDUyfvZUko94fopP62u14OF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 10:45=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
> > > >
> > > > On Fri, Aug 22, 2025 at 12:08=E2=80=AFPM SeongJae Park <sj@kernel.o=
rg> wrote:
> [...]
> > > """
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -952,6 +952,7 @@ static bool zswap_compress(struct page *page, str=
uct zswap_entry *entry,
> > >         struct zpool *zpool;
> > >         gfp_t gfp;
> > >         u8 *dst;
> > > +       bool dst_need_unmap =3D false;
> >
> > A bit nitpicky. That variable name is too long as a C local variable.
> > We want local auto variables to be short and sweet. That is why you
> > have "dst" rather than  "u8 *destination_compressed_buffer;"
> > The local variable name is too long and it can hurt the reading as well=
.
> > Can we have something shorter? e.g. "mapped" or "has_map"
>
> I agree your points, and thank you for suggestions.  I will take "mapped"=
.

Thank you.

> > > We may also need to initialize 'dlen' as PAGE_SIZE ?
> >
> > If there is a code path can lead to dlen use not initialized value? If
> > not then we don't have to assign it.
>
> The success return path of zswap_decompress() checks dlen together with
> decomp_ret as below.  So I think we need to initialize dlen, too.  Please=
 let
> me know if I'm missing something.

I normally don't worry about those, the compiler will complain if I
get it wrong. The compiler might have false positives, but should not
have false negatives because the compiler can see all the incoming
edges of the basic block. It is a trivial graph reachability problem
if we allow false positives reports.

Anyway, I just opened the editor to check again. Yes, if we goto the
read_done, the if condition using dlen can introduce a new incoming
edge that has len uninitialized value to be used. Yes, need to
initialize dlen =3D=3D PAGE_SIZE or you initialize it at the memcpy of
page.

> I will post the fixup by tomorrow morning (Pacific time) unless I
> hear other opinions or find my mistakes on the above plan by tonight.

You are too humble, that is the normal reviewing process. You can take
your time.

Chris


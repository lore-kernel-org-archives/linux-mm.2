Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01951FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2936B0005; Sun, 26 Apr 2026 16:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B536B008A; Sun, 26 Apr 2026 16:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6333A6B008C; Sun, 26 Apr 2026 16:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCFF6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:42:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2BE1A05CE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:42:20 +0000 (UTC)
X-FDA: 84701879640.28.6E4D6A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD3BD80006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:42:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eTXvUAYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236138; a=rsa-sha256;
	cv=none;
	b=AK7Fesm9lwJbKRX/V0PDG7075zdvDBd5BNj2olqRhEgh2q1ameUrsOCjXiHZYeIyD31ufP
	pH4qvU79XpCF5ss53Tmm/RUG8+/qkMcio6uKyY1xM6qQODFLsjMjsaGU7yMStHguHC8npo
	eCLW9A9PtQiROM5XNilXHBMbYn/cTms=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eTXvUAYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g24bnuxWoCoi59yGVacUpsh/9POPs/fPjVvie5wPt/8=;
	b=QP/gkNb7jVUgfZLt7VSBvNhz2lEas3d5l8AkEe2JGjCwCmY0RUUCR/4ZRU35Sf92BZwHfO
	fYzJU3h/OOdybXQpE8LO/lEUJ556LgUSeR4zruv7s5K2vElUJtyXnd2kyNsyA0rztbkocY
	58K/Xz1hEDmBX27ShWttd/9Mnjc8IFY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A4D3445AD
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617EEC2BCF5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236137;
	bh=xNUZD1Koa0K16kJNzHeFZup3T6qziXLsWPSvI/BOT90=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eTXvUAYg63AD3E2faDWUdJ8w8VUaDX9gXGKCxr08HE4EC6LZdI2ZAi00hoLcacjPo
	 R4LOALTWo3jofJf3KNzbXmpiX+dvh5AfT3sDtE1fNZQ3p69AKo45f8FoszLM0EzLYH
	 +29JuCmBYGHOgAi5FxsK1mOalKdrKKW2p+N45L0tSHb4MskHGRSZkLTeciXNpYF47/
	 nf1AwpGxO/++boypYyj7m90TwEXPL48iFT7k1HQI2ey2ajg2m5ZWPkjWOEFdJeUbpY
	 OuUVaTibeyBhFErymh9l8rUNWExZLjCF1gRApABiHgmKEhB5hq7s+/zRanhp7UrfpN
	 Q8bnurOZB4DfQ==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8aca4e14411so118067406d6.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:42:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+38g2gYWty1aLVlHCv6W8WVMwkvjWC5vww+74op4ZADZEfY7PAjasgWjHmxnKoawGTY8ci+3mqxg==@kvack.org
X-Gm-Message-State: AOJu0YzVp5FiJ/y9SaTHLJC3OksdDT9JfOes3nWYBVZiZ3+YjXSTKJYL
	jrdLODGKTmFbsehC/QUFkBdjgc4rwoeYVG6WgZEEWZe3RDJeKli1bR+ZHsUB0QHFTuyEuGIVpKZ
	FRhRJZELY/gSJAW646FsQLYe7C+mzNvQ=
X-Received: by 2002:a05:6214:4e14:b0:8ac:af20:4f8d with SMTP id
 6a1803df08f44-8b02812c51dmr576361396d6.43.1777236136519; Sun, 26 Apr 2026
 13:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260423034917.8234-1-baohua@kernel.org> <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
In-Reply-To: <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Apr 2026 04:42:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
X-Gm-Features: AQROBzCCtS189i1Ba0WcKggp-BR5oSnUnX0xx6BspG5s6gMzK43mNVcearFZu98
Message-ID: <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o54oqngyd8pk168aupmunfo6f6faoeez
X-Rspam-User: 
X-Rspamd-Queue-Id: AD3BD80006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777236138-953108
X-HE-Meta: U2FsdGVkX1+xKur335dbqytwqPDX2mgks+qgtwMw5VoHt/TV7Eh4We4TTLOMoJQqPIugY75CfBVqIGc+mBl6nLIx2Gcz+ABxD3uzLks/BGx4MvxaR2jSjBV74DS+96qi8wlTWxxJMkk45KRp9aI11nAEEzuA+mBizPZRIF7dCw43SktW3OYfJ3fUb1kyIhStlb49ZJ8krfI2EV25vpGbl3BUWD4m4rVU6lpVF8XdFX2E1BKZ0ASR0xdumgJgCNg3cRupnbYTNNVLTRmN7l6GstoCbSNiANvcdTia5L/CiWD2ieL5aeWQal1hLL0G+ugbBiSKz2dSfYCqGlcCuSuc21iiqnHe5uHXmC/c6kL94B4r3sxMCAY19wwh6F84ZFvk8q1Hfk7b/Mt2jfcI4VUG7Ai9k1rEjgb+PAgzY07L//zWWsWOMEOOwYZRatSdJa2CN2QxbMzFneCFoyVXIe48hOLanCAob/qdXaDQOESEJNei+A2yUvcTiFwBVKExCvrso6uV0XN0r+Gf6spciolvOECneZ0cLRLcHOOEzaG9cjKPjrybqrBYg58IwZ/O12psLxIhoLZKzw+6YD4PKCS4xo/m1DFRxAJanputraV5sbkVUIk4e/NlCwssPQvekoog2K1eZR2uM2WI/LLCxTzS3Cn430qGAUSpL7Hvs24ojVuzUXZl4Nwq1cib5jMWjpZ4JsfjmAgCOi35kQwPCCMVP2HxmbAVhlWsM4yZrReutlkVCBL15qrt/bKNQirO3V9FFZtdVpGstC/zXCScJmdPlEySMy0tuwnldS1eA8Yh7aM5h/u8WHCJWDhI9z3fuf++Itk9V5P0hReCRFCqCU63t7B5btafklf5fFzoQa8GuPrQUnWLeH9d8Bvg2enHNv2B+2egcdELXoFs6x/ynKYJpRST7UlrAODqxp4ApzvjpAop1rnsMu2YnN+9z2ceZBpE+RTrYgGABJ15FAKCdZo
 XxSjs5+f
 Aq8anaM49yikHya52H9bz4xBtxYJkd1WMbuZWe6xGbirtogLRf7yHDc7TtBSyfIcTTAEwgPWPPbKX6rRB8Icr0i1u4kOfhSJIZC+xGS1MORTn+4WJFCnJC+Lw2uIxaXZL9IC06fCNGOUTsfbYx59C5oYpqVczWyoGriI9Y7dt2mOC2h/V8fltaV1fadHckRfYAcl5uvurR4Wpd0zAQZoMyUpETCy/l3tcylgUCMXCINqgZJo+wWhy/CSQMjAR70WN1VFSHuW4ba3XzXvdP0dvpEn9/EafUL54PC1mnN6DPC/rekcExFjt1GRGQPnSuVJQxldUFIgVcVUpr1EXBcOSqB2n7khYqurnU3Z74QoxOkKl6oBxrxhDzTEzAYo5vJMjt7JmjlCOQz9dofrVY7X8Nl2jhfQ16dTFIUiRuWpYTfTsiAMlwqCZKqANhNssPNO3F27Qx/7PMtI//rwfI7gaaj4dgwftiLKysSi6PQw/JBnAzMXod/ZhTJ5ClTfb+fKvuw1QXYSUtJGWQ4kYkoHF2I8mV84b/etTqjLQsNMW+aoxCqz7Tuz4UYJRmyB/tO/1O9JTD8JNSAtcW/LCLq1jRGpS+BfxUckRTIBh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 8:36=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/23/26 05:49, Barry Song (Xiaomi) wrote:
> > The comment appears to be outdated. First, add_to_swap() no longer
> > exists after Kairui=E2=80=99s commit b487a2da3575 ("mm, swap: simplify =
folio
> > swap allocation"). Second, partially zapped folios are now always
> > split before folio_alloc_swap() to avoid extra I/O, following Ryan=E2=
=80=99s
> > commit 5ed890ce5147 ("mm: vmscan: avoid split during
> > shrink_folio_list()").
>
> Not necessarily. We have some scenarios where we have partially-mapped fo=
lios
> not detected as such as of today (with CONFIG_NO_PAGE_MAPCOUNT).

Thanks, david! would it make more sense to add =E2=80=9Cwhen
CONFIG_PAGE_MAPCOUNT is enabled=E2=80=9D at the end of the
sentence? I mean:
"
following Ryan=E2=80=99s
commit 5ed890ce5147 ("mm: vmscan: avoid split during
shrink_folio_list()") when CONFIG_PAGE_MAPCOUNT is enabled.
"

>
> > Fix this by making the description more generic.
> >
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Nico Pache <npache@redhat.com>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Chris Li <chrisl@kernel.org>
> > Cc: Kairui Song <kasong@tencent.com>
> > Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> > Cc: Nhat Pham <nphamcs@gmail.com>
> > Cc: Baoquan He <bhe@redhat.com>
> > Cc: Youngjun Park <youngjun.park@lge.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/huge_memory.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 970e077019b7..4586f3ccb133 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4190,11 +4190,10 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
> >
> >               folio_unlock(new_folio);
> >               /*
> > -              * Subpages may be freed if there wasn't any mapping
> > -              * like if add_to_swap() is running on a lru page that
> > -              * had its mapping zapped. And freeing these pages
> > -              * requires taking the lru_lock so we do the put_page
> > -              * of the tail pages after the split is complete.
> > +              * Subpages whose mapping has been zapped may be freed
> > +              * earlier, but freeing them requires taking the
> > +              * lru_lock, so we defer put_page() on tail pages until
> > +              * after the split completes.
> >                */
> >               free_folio_and_swap_cache(new_folio);
> >       }
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for reviewing!

Best Regards,
Barry


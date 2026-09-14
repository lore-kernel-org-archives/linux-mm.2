Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D359C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3437E6B008C; Mon, 14 Sep 2026 04:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CEA56B0092; Mon, 14 Sep 2026 04:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CA66B0093; Mon, 14 Sep 2026 04:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD9596B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:20:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 491FDA6805
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:20:24 +0000 (UTC)
X-FDA: 85211670768.25.CD019D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4603140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:20:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhoEN7ya;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789374022;
	b=AzXMBg7ij983ysIbQ6KjQZzCsnq5XQFBXjsx6To0PPu2mxlfZLuo88TYeVBN4noLGRj6bT
	MqwReq+zP+Gi8JPgPx1gzpNfKuJpOEIWaQlLsE45ru9Wb7Kjsh4MdE9y1p3cL2l3d/Elap
	8C/cR33OHaP9V86nXA5Mop0tjVvLjP0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhoEN7ya;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789374022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48VkzgLkFFlZvv5bU6rHd8Nv9Ty0hFru+5M6Ylx2FV4=;
	b=Kvf+1QRuOqxwEnGOaHGrpt6IkIVEW4OtSU2pS5ACeutlpGJkVUMtFJpxHo3gaBz9YYulGI
	DxjxG/UY5xsGERvRnQd+zvu9TCCdzhf1YHZ6APIq4ZUxqwK28OtFQ/WQlAI0wgrUVw7eWz
	lIW0ddwyLGvssng82+v3Oge9avkzra8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D019D60142;
	Mon, 14 Sep 2026 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C041F000FF;
	Mon, 14 Sep 2026 08:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789374021;
	bh=48VkzgLkFFlZvv5bU6rHd8Nv9Ty0hFru+5M6Ylx2FV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LhoEN7ya5kNwkiVWNhTwUOrsCz9nnpUreMxiviwueY1w0h/XAn2ydO+nozTfcCnqn
	 huZ37We0XZ2LufyaM6tQODkV5h/kWhqFXohHyjJZ3jhBi3+y04JZZUg3EP26dTgrNl
	 CsL89glsADULtZYQl3jUjarQhKEJIIhjCQ6DufFkvopSHvSLiDBCoen+aTcIR4P1v8
	 EgVOk4yNi/AHTHE1DbVF1uisUaj6uZSdeLCA2ZjuInAomQL1XdIN1oS1/Y2aDSY+vG
	 TrDSNW7MUBE/DE/QrBFafRhDeiLIDF2Ar/eF4WdDfIsgqDE4yeR/ryQb5VbIaogNSe
	 QKWLA8DCuOGjg==
Date: Mon, 14 Sep 2026 11:20:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memblock: use for_each_zone() in
 reset_all_zones_managed_pages()
Message-ID: <aqeuQZwr3flydCRk@kernel.org>
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
 <178903430147.1489479.2162515570306846533.b4-ty@b4>
 <178903518466.2710705.16546329711992780120.b4-reply@b4>
 <CABFDxMEAkqGhXc93crUKjP9bKs2xh1gb0Nt32jzC08qSADJjRQ@mail.gmail.com>
 <CABFDxMGHwUrssk09-2j0yoQh9AVHTqoJDmJw3o8k10astr+bsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMGHwUrssk09-2j0yoQh9AVHTqoJDmJw3o8k10astr+bsg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4603140002
X-Stat-Signature: mkhodndm4szzr3s8dutauahzqzktdm8q
X-HE-Tag: 1789374022-289201
X-HE-Meta: U2FsdGVkX1/pE1978lcowK8NDaihrwQabKd0XKiDVya8KeUsmWmYcs6dJiutuRXG/MVFuf6gaCe653ujqB8Hp6Lxkrq7f4DqjACWt5BKwTLxjUEdAM0EOm/WRPB8fRzLIid4GsTWr0A+p0UDU5EVNUFG8Je2WV1Oj9x/xH82W6JwA2KhZ2PKICq0/TCX9iBs3bJPRmlHKlOQX3/NDsZtEb//3aI76ytP3O5mopsJczT5Y1k2Yzt3pw60OFqldLTAqvC7ZCQGt+mSoaOp/tvRtzHoS9HkClaD3insKD1SCRxquBvzXp8uKaUcoNuxPHaX8is1wvvJDslVHGvqBGMhQ1pDqwxk4YH6S0D9jtSU4IQvSDy5cyULLQpvdEW2OeDzjOCpz3obqukqnj1yMSvnQJO/R/osiMBR380W4AUcqwVY2TN2uqtRJq0W2kjPEJlOgn6biRuMt66hvyNVmkfc/XIyveAKtkSXYkOBZLIup16VS/dPjn4d1A9Zj8M202BEqRj86NVlunw62g/r+qSPYsshbPhdGd2kv4s5jx21BzEfmZG/n7xHtlzaZVqdWTCDjUf1j4wcmLxxcBF8+jLa83pT7Oi0Lhk4t/dKaXCAmvYxUkVc2ZO6WWrh4qXG7zzfHqA8x9OQx23IU38U67l0OITriJD5hsBBQwofA/VWzMbv3c4L2mptWTWzy7gJ9Qavaqg4ua3JMy5X0n/SNPGeT8koaDrIWcT6679k61Wn7GUuwpdiUZ0dDAyD0S2ggvqoftyLadgMWQ6/vItKbP+/3J/3PUFkPGW4ojG1AVpMpEXhnZng6azBeeQLM+q1SKdhX+CHFdyBtG5zZsHENQHbVgl1Mg+HuXfYZ+W+04zFSIRHR4tu0/Rqn/maCYzHjQN8Vuh7VO7WeEWaYc0AWxw8q4bs9Onwk4MewtUQmoOaUuy16yzpk6OX+KkTyHKkaRgxRMaid7cxVAA00CjB2z/
 esTCI0vm
 DPsrJkDioV2Q2FKkugqSDIOFGkIpWYhdiKX+8O5MhhqEEo2GMA+i87qQyDHMXfRAI4/lbxuS/5CeB6wPWob1ZW18rVL9zXjy45iTjSpEoaTef3IdbX2BqkjQV4IgMwuP+51NuvqEM6fE5Fdb/o5GHQ5d3PHdxBMixtqqsKVCjY5pYxLcBCpeIQCjqhkBP9WWto4VI/ulJ35l8szyEXWGhxxkkp9VH8vRWb3nQh36kuunbR3TfCmUK1Wl4pzY1J8EcE30EwYe4ITYcjlejJqh0OuHChFW0gfqK15eYWPiAqMIVp0YYehWRIicrKk9CgIL81n+GjCIimTMgu+gGrMCZtgiSEXAUJz5i7GObrn7PNhi+XJpNgQBnMuBBOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:35:41PM +0900, Sang-Heon Jeon wrote:
> On Thu, Sep 10, 2026 at 9:19 PM Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > On Thu, Sep 10, 2026 at 7:13 PM Mike Rapoport <rppt@kernel.org> wrote:
> > >
> > > On 2026-09-10 12:58 +0300, Mike Rapoport wrote:
> > > > On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> > > > > memblock: use for_each_zone() in reset_all_zones_managed_pages()
> > > >
> > > > Applied to for-next branch of memblock.git tree, thanks!
> > > >
> > > > [1/1] memblock: use for_each_zone() in reset_all_zones_managed_pages()
> > > >       commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95
> > > >
> > > > tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> > > > branch: for-next
> > >
> > > Hmm, I was too hasty.
> > > This breaks mmemblock tests, so I dropped it for now.
> >
> > Sorry for the noise. I missed it. I will keep it in mind next time.
> > Just give me a second to check.
> 
> With the below fixes, tests will be fine again. Is it okay to send the
> v2 patchset with below fixes?

memblock tests do not cover late parts of mm initialization, I believe it
would be fine to just define for_each_zone() to a nop.
 
> diff --git a/tools/testing/memblock/linux/mmzone.h
> b/tools/testing/memblock/linux/mmzone.h
> index 8d934ff5b080..631fe07923e7 100644
> --- a/tools/testing/memblock/linux/mmzone.h
> +++ b/tools/testing/memblock/linux/mmzone.h
> @@ -7,13 +7,20 @@
> 
>  struct pglist_data *first_online_pgdat(void);
>  struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
> +struct zone *next_zone(struct zone *zone);
> 
>  #define for_each_online_pgdat(pgdat)                   \
>         for (pgdat = first_online_pgdat();              \
>              pgdat;                                     \
>              pgdat = next_online_pgdat(pgdat))
> 
> +#define for_each_zone(zone)                            \
> +       for (zone = (first_online_pgdat())->node_zones; \
> +            zone;                                      \
> +            zone = next_zone(zone))
> +
>  enum zone_type {
> +       ZONE_NORMAL,
>         __MAX_NR_ZONES
>  };
> 
> @@ -27,6 +34,7 @@ enum zone_type {
>  #define pageblock_start_pfn(pfn)       ALIGN_DOWN((pfn), pageblock_nr_pages)
> 
>  struct zone {
> +       struct pglist_data      *zone_pgdat;
>         atomic_long_t           managed_pages;
>  };
> 
> diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzone.c
> index e719450f81cb..e73848bdc8d6 100644
> --- a/tools/testing/memblock/mmzone.c
> +++ b/tools/testing/memblock/mmzone.c
> @@ -1,9 +1,15 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  #include <linux/mmzone.h>
> 
> +static pg_data_t dummy_pgdat = {
> +       .node_zones = {
> +               [0 ... MAX_NR_ZONES - 1] = { .zone_pgdat = &dummy_pgdat },
> +       },
> +};
> +
>  struct pglist_data *first_online_pgdat(void)
>  {
> -       return NULL;
> +       return &dummy_pgdat;
>  }
> 
>  struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
> @@ -11,6 +17,22 @@ struct pglist_data *next_online_pgdat(struct
> pglist_data *pgdat)
>         return NULL;
>  }
> 
> +struct zone *next_zone(struct zone *zone)
> +{
> +       pg_data_t *pgdat = zone->zone_pgdat;
> +
> +       if (zone < pgdat->node_zones + MAX_NR_ZONES - 1)
> +               zone++;
> +       else {
> +               pgdat = next_online_pgdat(pgdat);
> +               if (pgdat)
> +                       zone = pgdat->node_zones;
> +               else
> +                       zone = NULL;
> +       }
> +       return zone;
> +}
> +
>  void atomic_long_set(atomic_long_t *v, long i)
>  {
>  }
> 
> > > > --
> > > > Sincerely yours,
> > > > Mike.
> > > >
> > > >
> > > >
> > > >
> > > >
> > >
> > >
> >
> > Best regards
> > Sang-Heon Jeon
> 
> Best regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.


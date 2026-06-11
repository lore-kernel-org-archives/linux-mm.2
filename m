Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2532CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C946B0005; Thu, 11 Jun 2026 09:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014036B0088; Thu, 11 Jun 2026 09:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C236B008C; Thu, 11 Jun 2026 09:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1A636B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:32:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77C051A064C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:32:18 +0000 (UTC)
X-FDA: 84867720756.25.9EBB958
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8012E40014
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:32:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i5si0gMg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuV61uJXJ0l52LWb45Ax18tS2nrRIOXXxla2pXzq8v4=;
	b=Mgfbm1BUM+GTITSwrDN9ZMaG36OsuRfZ56mLH55QLjfmhzvhMAfPR6zkOW0PotJxFe6On4
	tAjZF3exw1//NaDRdEYQCMMI0APLfYokwuxaIoD1SDPBy9rq5GBbNhv+7xvYJ9H2ikODc1
	R6UDT5VT2lqcEjcx99TXB33x27/s3Yw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i5si0gMg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184736;
	b=hz3aTDCsEm1gwVAiOxx67keKxjjSRAcPQ4lJOyZ5mY8oRHMxlXoCV8TGwNeMs9vcB6L2z+
	uHTRnlFOImH+pjhkX6U6294l6sW5MCkPGKnOdIqWdg+4PTOzwFVNOQTtKRuox5WVgLTtA4
	ocJEjrCHasEGwg526BbKJzLmuslEY0I=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781184734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuV61uJXJ0l52LWb45Ax18tS2nrRIOXXxla2pXzq8v4=;
	b=i5si0gMgCTHy3hfsP5aiUh4vUDvjaZoA/rcYZvHfTKESJKjMj788WnYkJGHQ9UNUmbBstK
	6kekJ9p9edxr+gmaynixI62jL+4AeN8b+UsnRur9f2utRd+BuKcwVRW00iKqyEtSZN7Ac5
	LqoU+FUtYHxtPOI9alvyzZnY20odt+c=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2026 13:32:04 +0000
Message-Id: <DJ69AE1CHPJC.3H4BPJUL9YYOV@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm: remove NODE_RECLAIM_xxx macros
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Petr Tesarik" <ptesarik@suse.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>
References: <20260611124501.1465806-1-ptesarik@suse.com>
In-Reply-To: <20260611124501.1465806-1-ptesarik@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8012E40014
X-Stat-Signature: ygfiimdikefs33nu7b4w6b94jzxsq9ej
X-HE-Tag: 1781184736-58104
X-HE-Meta: U2FsdGVkX1+aJgzgSrFh8zg8BaIekOrAaki6KJlLcC05ykYeIjlWbjMfwf5cAXUpK7Pcq8dGEh0s+FWNzvaJp9++toy2IphAF4np5DhLVR2RqdIDPthEZk8T/E6wc+EKOHnOrdcvXq9HTk1YVRZY27X1kGx8UjLIKsQL/XjBvvfArKGS521vEfIM7kurtDr59l5Knd+7ha6JA0i1po3k+B/9sZ44L8v/IhO2D+IdGjkyIhsA+jFIDqpRUtAUphSa5OO2uCa9l/tGES/TCbThh/qbhWgr1X3P/14rCGREbk8OQev8JpWgktpvsRCbqwuuG5ltNgz+zFnX2uN8toIr7QGM1Qi53Z6IzdjJx4adHF8YmRHEJwXq5G1lHquJUvTCwR9dTiXPTO4e9xelZqCm4SLYw8vX/MB4NdcLT8SUMoLIbHvqlA3/82x0Q4JfBHa1Hq9O76kSFkUS14nRdCHWt0tXbBEL2njG3fVHX4QnBFkl8zgjsEQC6gsreCwYGHbThEsKXRly3p+zL/F30P39WP7u/a+Tjl/t1cAbM9Urjrd6keAUSh8BN8ePjr6LgA/um0aNBV2azwr/9jDBVaR4S/hK2u3JoThoqWtY1+mMumMBNEXgGb9IAoUL7CuNb4tDbKKuP3mIdKO8jVMGy+RRkkwN5YIsRMDDJHjUqbJQQeZ3heij0wfL1OwLVWtGg9JQJUGwhLkjERlx3wt2S0Nzop5pCWzHa2LreJ5n3I0AsHD+rUA+8zzxn6lk8oR45x9Ck9qyoG3RglONtDYJ5yA3YhNurUbnXyUn7/GGBv6Ku6+o+6u7VI97XcEwEOizCkMEn05CGMOWEieQftaXDN0i/hufEBh2J9nsZJjtrN4WxEeeB9qF/S9HNhShuOz/JkenpuPv2qGajjehTNz/bKl/Z83ttmccrBAT0nWchBXRxjp5ggr/fUqXOvpJMT+aeb7ABVRuRTE5IDKSgSvIeUV
 eNyNky/I
 5B0nCGvLcGLXGnWYN33jj2a/tR+2A2sxDafoAVbGcjpm29WZUdyDVQGkEE67Us/HgL+xJOQkQB4PnApJehczuOtGUBU+JH0quMarnDamXUVfOZwS/hJkEfteyiA5eM5glMD5mM7jzf2QEyE/g2OC/QP+Nf1Dju6sUmymFQgjn+SR5HXBiD+JcTfU3i7gUM2VyEuDBUvem5ROkRfL4I3xOMg8FJsJs3ken2Bxiri6yMJuuzJt1qq4fKYEfmdTHTKP+u5eHXInw9qV5AwxL/I34rXywirhM6ZzjGXDH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 11, 2026 at 12:45 PM UTC, Petr Tesarik wrote:
> Change node_reclaim() to return a bool indicating whether any
> pages have been reclaimed, because that's the only information
> needed by the only caller, get_page_from_freelist().
>
> Originally, I wanted to convert the preprocessor macros to an
> enum, but I couldn't find any explicit use of NODE_RECLAIM_SOME
> and NODE_RECLAIM_SUCCESS. That's because they are typecast from
> a bool.=20

I'm slightly confused by the "typecast from a bool" thing - nr_reclaim
returns nr_reclaimed and then node_reclaim()'s caller gets that value
directly - is that what you're referring to?

> This seemed a bit fragile,=20

.. Which, yeah, is awkward, thanks for fixing it.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3f3ff25e561ac..64f6b649eeac1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct pglist_d=
ata *pgdat, gfp_t gfp_mask,
>  	return sc->nr_reclaimed;
>  }
> =20
> -int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int=
 order)
> +bool node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in=
t order)

I really dislike returning bools with no obvious polarity. Personally I
would keep NODE_RECLAIM_*, (optionally convert to an enum), move the
comments to the definition of the NODE_RECLAIM_ thingies instead of
get_page_from_freelist(), and fix node_reclaim() to return
NODE_RECLAIM_{SUCCESS,SOME} expliticly.

I realise this philosophy is not favourable to concision though, I won't
die on that hill but could we at least get a comment on node_reclaim()'s
defintion...


> -			ret =3D node_reclaim(zone->zone_pgdat, gfp_mask, order);
> -			switch (ret) {
> -			case NODE_RECLAIM_NOSCAN:
> -				/* did not scan */
> -				continue;
> -			case NODE_RECLAIM_FULL:
> -				/* scanned but unreclaimable */
> +			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
>  				continue;
> -			default:
> -				/* did we reclaim enough */
> -				if (zone_watermark_ok(zone, order, mark,
> -					ac->highest_zoneidx, alloc_flags))
> -					goto try_this_zone;
> =20
> +			/* did we reclaim enough */
> +			if (!zone_watermark_ok(zone, order, mark,
> +					       ac->highest_zoneidx, alloc_flags))
>  				continue;
> -			}
>  		}

... or keep the intermediate variable and do:

	bool reclaimed_some =3D node_reclaim(...):

Since then the variable name at least tells you what you're looking at
without needing to jump into the function implementation.


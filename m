Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6A4606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+RQyBut
Received: by kanga.kvack.org (Postfix)
	id C79646B05B0; Sat,  7 Nov 2026 16:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C296C6B05B1; Sat,  7 Nov 2026 16:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F8E6B05BA; Sat,  7 Nov 2026 16:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8536B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:52:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 069681C0261
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:52:39 +0000 (UTC)
X-FDA: 85409672838.04.D95D950
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6DC4320003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:52:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+RQyBut;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794088357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFE5k+b3EPTf9xyiP1cwm3DBnq7vMvtd/XV5WMMTdY=;
	b=76HmQ5ICwnHyadg6yZPUm13bYIYhcCKHetdEf9PxGea/MY6f3mF0JSOnHx0yR5k7q2UdrS
	3m0XTiyyih1nmWNScsfr6DYFT7ilH1WYG1B9pVW7Rn3TKDZsXXk0qETeTH4qL1vWdCMdaZ
	dsJl9PeLCiqM4N10gRsqGRyy7EqCWII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794088357;
	b=AWjmu7MzUnbOAOdSC24siuX+w+g1idXo/C4IqA3L7AQhJTEXQNv1ORbqExc+9zZHSfUPq8
	rYDi9+fL0sN5vwSrskd2wUOcqMLZHXWXQHKr7y3uXVikAwt5Np/p3DJEjhCeuKDgg4Gcer
	6Ycvhioy4f8QqUpZjT+Qkim4aOiSo2M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+RQyBut;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FD5405A4;
	Sat,  7 Nov 2026 21:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475821F0089F;
	Sat,  7 Nov 2026 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088356;
	bh=MTFE5k+b3EPTf9xyiP1cwm3DBnq7vMvtd/XV5WMMTdY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d+RQyButyz311+aKUVi3R/oni5G31LOAlqLgmIYGvO45yPVIki9StDy04ib5P03tJ
	 lf3BY8sV1prihECfE6gbUY9LU9qcyosU4coe97/LccZqOSW2DmgoPhjCw4dqxo9w1H
	 tOZVL43VOz30ALf0dXSl9LKZE1iHRIitrsO9dPdW/UdAK61v9qGFve55nc4VVAE1A6
	 8xQJRealNcFQ5+ZS5ZePB0KKmxoPaxllCYnjlIZlWF8SGXXhwrJRATX+QjwitLCw+t
	 1LmpLcNQEk5dOWVgoCG6fRxpRvx8swZw820IV3DEV6J+jCEJSdqBWUxJEWsMhBrCe9
	 gspFPGdYcA0tQ==
Message-ID: <sashiko-outbox-203347@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107214525.304638-2-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
 <20261107214525.304638-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 21:52:35 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: dn8qdokbe9uewwak5k4w1pf4u97h591z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6DC4320003
X-Rspam-User: 
X-HE-Tag: 1794088357-501714
X-HE-Meta: U2FsdGVkX1+wMzYp9nM3X1Zki6vYckXAcjy8Ei/wYQmJ+Y2UGPqfhNbyU9n+qPorJ0BP9ndAuTwj0roBtkoO4vm2fo9deyLpsIgUxGwh6ly8adSJcFI6PS+oEsI+zD6yttwymZJvqWceskFvbAa4ADihOql483YZfE+Dm249tVsIpMVLiSsb3n+kqVr4l7Lttljs5VeguUel4oJRmnimiA5WCf+JO4j/izgj5RI8A8/eu8OLUYSV/DYTEzftfITkbSVZzFfoOI093GV+v61hexONMove8RDrtwYpdJA6lrQ2Q/4c/5ZoivBXv2Ey710JDktyRK2pixmwiPlZ1CVpn+E7LiTLdkHBMDlvvkuNX9cw10TCdbT05XJ7A6plojcpwGzQoJvgP8keWxC7A771fLoc6pwFZihE8MhDD27aowGynmsMfUZ4m1F6VdgCKu5MZEaUWz2PO9CXdkX5BSHOd4vVnM5kwr8ysuIZxmlw8yyzPP+NP5rdPS/X9PWki4tAwI0NFncZMG79VSLNmJcDU4PTVrsCbY78uMoHzrcHT4eLCIG+xQouP1Bd5GUO9kQyMh4Vlkx0r2b0eo463DaYgau3rRh8U3qN8SD2asFfPwjPuzgSc6TIk8fC7egXQjcjZCQy7gtpgnzcpkd9QWtdWcpPhiAxiLMa+pIhicTucxFn2clexGf/DZYZwF7GGsukmvAnoXjVJKJWi6KsHI3XaPs7Vy1JngPRUI8NNKQCNZNQZ8+y4wjkWfTIg/GcMqyziNmfWLUFBcBeeQTPitia77T/R3pYCXzPDjXSvUuheRSWY6wOdfAp6gkzGko0bdJKZtcnZyLBzoGRUy+qiYBf0VChS6a+ITf3QlGo68hZ9ysvDAxtpHzMd7PWdOd9i8bzrEVTsPsMP3wzFlAASn9BegXb9cfWOPYaYfsq763rho45xwBSkxYkwLYwrfkBySEVYF2rpL1rD1amk6BPr4w
 wuNDl/H4
 Uoend894ZdVqynLk/xoRLpTX08nOaI3fsxWNwa/IAWyP48M2rI3ML1oY3BYJzdS5ubulngtsgghGDwE9rpGQKwcKQCZJ2xpXeUtYGCcQWKsKZmaIRollN3jYJ8DfvnjfQHQJ5du969F1uR7MD5HAXri2hKoAL+wgQdo9aDTwTbcQGBX9XO1jA+ISsRurR+corEXOzerWJb6VIK9BeOAUbXsHm2qzPKJkEhMBu/lGmDySqW+JxYeRbFEYv1gDGd8AUSJXIUwcw9YxhZuU2ec3B/q+oOqUUQFkOlYC2KlgxnwM06ZLWlIidijc0qWvzoy81zEtp64XuMLdOuKyGM0W+IlafJx/LikCApZLEKsKHEZ8w7HuKY05FUtO+Nu58C/G1uARF/sQry3W23aiVONezFQY6zu4Ojv4/w2k9xn+bnCKUs1GMDJQVuW119m80mYIOJFDfydSaGYRVI/KI/iBem/YCDezQsd4Jn6mUwQfVlAF6OyC5UdA9+iuY6JCCjF1UftA5PNibLZx9/tGIpZgP5BEXcUzxccqTKckQfKnddGjtX4KJRgWq/HRSFXS14QSdwzRDMtywZI3qPGhvtmFuQ2vlfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/damon/core: inaccurate tried stats on split failure in
  damos_apply_scheme()
--

commit fe019f891ca813eff979dfc83e95ba297bc45135
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit changes damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damos_apply_scheme() when splitting a region to fit the remaining size
quota fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 81d44e41de210..6ef77741b783b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1470,7 +1470,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  					DAMON_MIN_REGION);
>  			if (!sz)
>  				goto update_stat;
> -			damon_split_region_at(t, r, sz);
> +			if (damon_split_region_at(t, r, sz))
> +				goto update_stat;
>  		}
>  		if (damos_filter_out(c, t, r, s))
>  			return;

[Severity: Low]
Should this return instead of jumping to update_stat when
damon_split_region_at() fails?

At this point sz holds the non-zero aligned remaining quota, and
update_stat calls damos_update_stat(s, sz, sz_applied), which increments
s->stat.nr_tried and adds sz to s->stat.sz_tried even though scheme
application and filter evaluation were skipped.  Because quota->charged_sz
is not updated on this error path, persistent allocation failures across
subsequent regions larger than the remaining quota will repeatedly add the
remaining quota sz to s->stat.sz_tried and increment s->stat.nr_tried.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107214525.3046=
38-1-sj@kernel.org?part=3D1


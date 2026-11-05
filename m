Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D29606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9KjKHYk
Received: by kanga.kvack.org (Postfix)
	id C4FC76B05C0; Wed,  4 Nov 2026 23:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C007A6B05CA; Wed,  4 Nov 2026 23:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B189A6B05CB; Wed,  4 Nov 2026 23:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87A936B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:55:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A74B1208EC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:55:20 +0000 (UTC)
X-FDA: 85399851600.18.FA61413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3FB91C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:55:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U9KjKHYk;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854519;
	b=0HuZf8nO6gB7D3fZIPxyAArRadjjN3WrZ8pE+sFV1ODggT7wMKTFDIXN0G8/8QDH/tnUYj
	4mFg77IpnhigHdOyEvZnVr6hJKSCRAN9zoySjAex1+QVpsMwYrysEhiseBXCF5IEVA9SA2
	n3SaP4WZmfbrHcrKuiuiHgt8BAzVDn0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U9KjKHYk;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854519;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqA1v6U9I7VtulcS+AOn9l6cfVQac8Bgf0Fd+CPq7D8=;
	b=6Rs3c51YbOCuFh8UuzO0ZqFsSKW0S2Lai6Pj8SNOsLu6S1MzNOmSrifNTj/B7RCZ6fEdXv
	2A2xvOV4EKDcbT2swelr8FajerLaP7cb+4rUEzRtbawfEVc9sMdpdcMv7svMa33QRvj10t
	h0VuHsW44iJksg4N39p4ErcTa7SrxNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9AED43E5F;
	Thu,  5 Nov 2026 04:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907821F000C1;
	Thu,  5 Nov 2026 04:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793854517;
	bh=MqA1v6U9I7VtulcS+AOn9l6cfVQac8Bgf0Fd+CPq7D8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9KjKHYkLFtNg94b3bFsLOzRkcieNXJ3km+2Uh5pRlyHHDi2BjkqzuEkf8uf60GJp
	 puJntGXpoVnSTV749phc6j/wSpVuJdY2ZnKuTSmD7Kojj0MbSG7hH2OZNiLNa2jorM
	 QGALskc4xjgWvHs5MQT6YZt2miKq8DiCus4KxMkeqBuDQAbj1hdv0fTJLdkGa+INRM
	 5dBrimHzj9+jHg3ZcssZPZIYCH6juuk708yjwPIMx6mHsl9BuF23J9W48o2EM98MiN
	 3nRu9wBMjMIJC+KEBtuj/gxbJeR6mDSfd9GfjRrjIJ3JWSKLfDE7EalA1ZQeawP6mC
	 a6Lkrc/UlbXrg==
Message-ID: <sashiko-outbox-198571@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261105044425.87142-2-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
 <20261105044425.87142-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 04:55:17 +0000
X-Stat-Signature: 1ea4tzgb5un45e8ez4xwm5krbzq9ggp5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3FB91C0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793854518-262947
X-HE-Meta: U2FsdGVkX1/Wlo3zvvpa6FnGasWFGN0j1tC5vDogx0yhvX+S8bTELOS0gkBpzjQbByWbj1X83yZp+YS92Tep9YoxCRURRZGLfVf0uKoYGCrVy+Osvj3X5K/am8EsgUJR08VlNCWcmfAYL6UwCS+bwU+Z2wRwccphzXD5Yb5wSwiisYXGGNtXLzyeyAXj6eU8JgohTDtf1V6qxoKUXqtTmECnqDOdqhjtsFaYLgSWYgew9t97Bl0lwfhAvlaUMc05PXf9AuAELnS0i8Rn3PYVnRpFAllofeOQP0BSFgozoFo/DQBZVIib3kr/M7QGL3pwELLX1JMa+H5saZMB1nJ9AdduGhr2z/fpOr5iZAB7m6V8L5/hx0gbx77eVRiW7wCh1UiBjIdBknhetNTDqptiNnfRWGCvWs0wtyIeWFbWUX5XJI0S//bwJk6u6dyKHqoQ+4IEOY2EGEvfLlJ4PBxrLrouFdRyFwfiDJcYJlwFltCPY5MJW85pdUB16fWnbiVoLT5SWA/HgMCJpU/Si+D3+TzEd4KaRm+yLgJibujjgLxRgr24Av2Muq9w8UqfbursD7LJEOHeGS13CH8Hy5E9Gr1S25OWxCDzTAwhKxktWY8tWh9OG/UOsvUlHOpEkr0r8srROwBENZzjNpqIwvRyqMTqH4m5y4PHPKMRE8U2b5ynfTQ2vq7Iphq56BLpyLu+0ogYAEGvG2MeR/TGC7qTDX/ztq4pgkLJoihkQ02UdLOTqyjfq/dO7/9lu3UZTghFnZx212xCFKkfHm6Q/2Le7Z5kRh94B9tcw8ke+LjCPsZpLGTS+KI6sy50W0o2ZT6PC5iPWDjPCLZTOPgEcYmNIdFtZrkbkxyYlwdWCywrW+ktukWM9qrU2/vUZjjCpzzyYupudqYi9D8+jGnWVsWMbb6AZgVo+84xJpvQeZzdQZvOaIlpCPPDSj+fEe0eKNakej29uBNE9WSL1tsT3yl
 pr3U9yEi
 hbhnj7mPuuuqqeCb98ybjcOtBIduio0TZbb83CG7yaGSs4RAZzTGrmnbj5PoFUYhX/gbViemoWaoNARuECmCfFuJxMEvC8GBKR3tD6R2CGY0ymymPuEKDDw9+ptxqBJISXj/UcPGFmu/pSqwynBvc+8uDTNv7uqYa8KlLll/HR+sl1jKOsYE92aEvwXz91Az/E3MsAJYLHuaissiQVtaXmkpjVxpL67K6dB3vGB+buj/q91iKL2nNqlAkvVpzqYz+wFE/cbQAGgUzKQ28slqYdqDXueG7yzfiryDokkoFvLyMilkoUZx/eOIqK1CKB8cXG3T9zMjDvx7CQGgXIYIgPAiiWOpW9l63/vHd8Qnr48r3i8IOvv2GxYcchmxDCzsRRNI4EwTPzirrJf0eUL+wnX1oMV5GrbqvaYmOtZkg2ZOvqiN4eRmHqY8ruFi4yfPIhOdDVFkdkafZjZKen8M30ER1C/eiX68DxBNrXcv1BnKgu/qXdcDw1uPQdU0TBS8P+2Esr3oYOPqVkJkucaepr4gdS13/4ODmDHY86ig8WcIBL5YYdnA901HIz8+CQT9S9yF0cl7EMD0sRS3dHq3mMBgCLHlGZZCjOvccYB9yuGSVT0Pc5sQd5U2vjI8bQMp9cBjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/damon: 64-to-32-bit truncation of age_ms in damos_filter_matc=
h()
--

commit 2459402d4dc794f740b6a5720a69fe4a1a61ae62
Author: SJ Park <sj@kernel.org>

mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS

This commit introduces DAMOS_FILTER_TYPE_AGE_MS in the DAMON API and core
layer to allow filtering DAMOS target regions by age in milliseconds. It
converts the region age from aggregation intervals to milliseconds using
div_u64() and compares the result against damos_filter->range_{min,max}.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index d36823f4d0928..0a056949604f9 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[ ... ]
> @@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ct=
x, struct damon_target *t,
>  	bool matched =3D false;
>  	struct damon_target *ti;
>  	int target_idx =3D 0;
> -	unsigned long start, end, wsum;
> +	unsigned long start, end, wsum, age_ms;
> =20
>  	*err =3D 0;
>  	switch (filter->type) {
> @@ -2594,6 +2596,12 @@ static bool damos_filter_match(struct damon_ctx *c=
tx, struct damon_target *t,
>  		matched =3D filter->range_min <=3D wsum &&
>  			wsum <=3D filter->range_max;
>  		break;
> +	case DAMOS_FILTER_TYPE_AGE_MS:
> +		age_ms =3D div_u64((u64)r->age * ctx->attrs.aggr_interval,
> +				USEC_PER_MSEC);
> +		matched =3D filter->range_min <=3D age_ms &&
> +			age_ms <=3D filter->range_max;
> +		break;

[Severity: Medium]
In damos_filter_match(), age_ms is declared as unsigned long. On 32-bit
architectures, unsigned long is 32 bits wide, so storing the u64 return val=
ue
of div_u64() into age_ms truncates the upper 32 bits whenever the region age
in milliseconds exceeds ULONG_MAX (about 49.7 days, or for example
r->age >=3D 42,949,673 at the default 100,000 us aggr_interval, and
proportionally earlier when aggr_interval is larger).

When that happens during kdamond_apply_schemes() -> damon_do_apply_schemes()
-> damos_apply_scheme() -> damos_filter_out() -> damos_core_filter_out() ->
damos_filter_match(), age_ms wraps modulo 2^32 and can misclassify old
regions as young regions or fail to match old-region filters.

By comparison, damon_hot_score() in mm/damon/ops-common.c stores the result
of div_u64() in a u64 variable (as fixed in commit 0284dff76e87 ("mm/damon/
ops-common: fix 64-bit division in damon_hot_score()")):

mm/damon/ops-common.c:damon_hot_score() {
	...
	u64 age_in_sec;
	...
	age_in_sec =3D div_u64((u64)r->age * c->attrs.aggr_interval,
			     USEC_PER_SEC);
	...
}

Should age_ms be declared as u64 (or saturated to ULONG_MAX before storing =
into
age_ms so filters with range_max =3D=3D ULONG_MAX on 32-bit continue to mat=
ch) to
avoid truncating the quotient on 32-bit systems?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105044425.8714=
2-1-sj@kernel.org?part=3D1


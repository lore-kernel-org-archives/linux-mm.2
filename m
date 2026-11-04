Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9445C606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h9Yi3SVw
Received: by kanga.kvack.org (Postfix)
	id A4DDD6B05B4; Wed,  4 Nov 2026 10:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6D26B05B6; Wed,  4 Nov 2026 10:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3C26B05B4; Wed,  4 Nov 2026 10:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3706B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:44:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C91FE807AF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:44:11 +0000 (UTC)
X-FDA: 85397857902.05.CBB01EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36DB5100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:44:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9Yi3SVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793807050;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJp2+YzSERpK0Un25SgLeLNyefYf/shVUPYZJLrSfq8=;
	b=66dkz/vNE1qkzbOmb5gfr1xg6qJZaMSeOyMjRQqqaknFGew4dgdJiLweAh9CeVQ9CXu+fn
	RRmGMmkKxunKppYKAt/GfBdqXi6I+z0BAguFsLoNJMAv38GJwDPz1qQwR/oIA1owyF8MRU
	ahYJx3Qs16m4ml0Nn8mtpVT1+sLQfDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793807050;
	b=QLU2xrN2RbYN9n8O2L75JCl2eoWWNjnlL6pb0SBGZUNFEEIu1aSgVuTPCRweeLaEIwryib
	8BZN4TdhpbyJUj/G3/Epr8AGyzvU16O25BtxHLamFzXizKuqjLkpTnL0jbztwmAcsa1v1N
	QcYLltywvAc7IT5VTq/JJzk9Y91EvTc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9Yi3SVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA60860609;
	Wed,  4 Nov 2026 15:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CD61F000C1;
	Wed,  4 Nov 2026 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807049;
	bh=pJp2+YzSERpK0Un25SgLeLNyefYf/shVUPYZJLrSfq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h9Yi3SVwOGJ3TRWVqeFXN7NE7C3ObGLDThYNox677k/5H4CyGiQm+Fycvz2b1/kr3
	 J5diTkcky6pqt4EtTXb6V07N5gihfujFE20GM1fE78WMcVq05a1LgdHhfqYg00qSYO
	 AiUAdfFhgxqNxHaBa2oxj6yIuuqQaAuft032t1kHfjNoWbmeyegw9z8jHIpogDYCJ3
	 a+HNeh7wjMcKIS2LvmzoBmmnDX+B/oQcKmYJ6jiINl+aNk1esYzQUQhBBsWlH3pps1
	 BREqstvuF1+Rl3TBKjEOp5PUNwqligbm5x7fIFnS4FKi8zOCc+OlMFt3OJ/HszjJju
	 JU8ewrTr08XMQ==
Message-ID: <sashiko-outbox-197530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261104153645.82945-2-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
 <20261104153645.82945-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 15:44:08 +0000
X-Stat-Signature: d9a5u841m4awpupee1bktgm4ua5674na
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36DB5100003
X-HE-Tag: 1793807050-726212
X-HE-Meta: U2FsdGVkX19ZDLsrl4kbzeL+7qPMgcoVsjeWVTsPMerM9SqZBRI0MYg4HmeRlB452sRhdVnvXouXdae/fG+chNDOAxsUCl4ReNwIWK8YB/naqy8ikoNeDdpCm4y9swGSGCUgS7SUqqiow4C8pfLV7f2+giMB2F9NsUiFDG8jCXz4BmynzBRRmuU5r5jS2MkUI5pLhpo/i3qJ27xCaBF2bRFdfyEYxU96uuW4hrIVzb1Jnq2VaGyO2LSlxKpkZcQstADnB592XgrIIweBqob3S6zXLfBymZ4Qyb4UrIckKCwRQGO0215nJtwvYInv5OzqrN31+rzcW2dnr5GxA6AOMVaxiflcLFuM6aDgk4gLQczQTJmrMu6VCCvLlaUtcY/Hd8BcK4GCwIMhrjFDqZD6BHql8ZgCdmSw9B5flwwmu0LhucBHPsOJaZiLW4Ctnp+WeG3F9YaiE110EHatVDnqHNoplhcd5U+IYKV7XyUz+n1+w87pSifudTzfCP5SxI63snfb+4YFffFAlmBf+rcyjOn8FMIypcaoQptqIwXU+uCVL6XUXLfkzGeZ+4nbQsDqIiYNb3ITjb/Alg3OJwIW6FRgz4GKYNar9ce3CpsMxzhPXJW/CKM2vpxEmMQoalx06QvTD30YLUjgo8TCT8b5LmKw3x1BDQruK0vi7fYUBBg0xRgJzHK+gy55OaV4HHTEniPj6WGZMdpOpfcWdLXWtac1dupvPhmL8Sah/7O4/MX9eMDiqSFjFXx4XYCMG1b3ugUVL49O+gZZpk5zug5NAPlj8flE89L86i/E49fD3CWUVX7x5hrG6JAr25QgXnuKoBuwJJcoJO8iUIkL9Dl2KULplDx6haUcC6gfIvSP5kT1wzRRXlOYMf8T8aNbL6TYMDseoWYZm5V2cquUoTUHE7gadmTrx4+NoTKIIN/R5UpVN3bUd+416cehcOV3VWH63pdEVsAIq0vs7IKewOQ
 FXV8a6Sg
 NgcJ75zjEF5noBeqDSNrVP77zIYEM40RySsg8BYXDMGV5NZAq/x9Tat8xUc6WVXCpVbbhqHiqOAV98eI0NnY+vvR4yXmWttYqs+JHGPb3WGFFIucaYZNaQnkmgJvfddlBkNDRVahVo9NhMzTMU35UljHYV01gt9l9idcyDP01KdMrtGeAfy7eVtdOZLaqmVdhZlz0P4nI/W8+fEw+KmqCmmh/tIDD0D+HXiQewaIhNXxLArykhXQI1EQcafNDX+KIZrJ3gBLVcggKLmgzCssr4qHwN26OSZTCfPM/sYS9aYscUat2jA62GHK1o5KS/QusjeOTHz9r3B/kCUGPr9+ho04bYo+JInh3x45hsx5uh1wRgXy9KxREyMLC6yb3wPMgnxmCoJMneq4Qm4NFz8d5KOhpk1yCY565cGiMHkgQKhHKs/TRXDVziq6D8yW/mNvihmfqNIYy1xgEDLY/wWQfYtjoQgqHHPZFMTFHrqny7IdsG18TnAFv4+FqBDcXhvYzbrbJPl0xuXKSgyCBC43XSGB2896Vv118iItuQaW42JVPYhSbCwW0MRG5RQ2gStR/hXtSCL7Y7EHmW2VI+Ef6SZxQy+2hwJxmMKP00dVbzI9FmrKMdOj28crhQJxicuy/Z7ni
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
- [Medium] mm/damon/core: 32-bit overflow calculating age_ms in damos_filte=
r_match()
--

commit 8785e74923668744015c21ff7266b94722501bbc
Author: SJ Park <sj@kernel.org>

mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS

This commit adds a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS,
allowing schemes to filter target regions by age in milliseconds using
damos_filter->range_min and damos_filter->range_max.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index d36823f4d0928..d631863b034db 100644
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
> @@ -2594,6 +2596,11 @@ static bool damos_filter_match(struct damon_ctx *c=
tx, struct damon_target *t,
>  		matched =3D filter->range_min <=3D wsum &&
>  			wsum <=3D filter->range_max;
>  		break;
> +	case DAMOS_FILTER_TYPE_AGE_MS:
> +		age_ms =3D r->age * ctx->attrs.aggr_interval / USEC_PER_MSEC;
> +		matched =3D filter->range_min <=3D age_ms &&
> +			age_ms <=3D filter->range_max;
> +		break;

[Severity: Medium]
Can the multiplication r->age * ctx->attrs.aggr_interval in
damos_filter_match() overflow on 32-bit architectures?

Since r->age is unsigned int and ctx->attrs.aggr_interval is unsigned long
(in microseconds), the multiplication is evaluated in 32-bit unsigned long
on 32-bit platforms before dividing by USEC_PER_MSEC. Once a region's age
exceeds ULONG_MAX microseconds (about 4,295 seconds, or r->age >=3D 42,950 =
at
the default 100,000 us aggr_interval), the intermediate product wraps around
and misclassifies old regions with a small age_ms value.

By comparison, damon_hot_score() in mm/damon/ops-common.c casts r->age to
u64 and uses div_u64() to avoid this 32-bit overflow:

	age_in_sec =3D div_u64((u64)r->age * c->attrs.aggr_interval,
			     USEC_PER_SEC);

Should damos_filter_match() similarly use div_u64((u64)r->age *
ctx->attrs.aggr_interval, USEC_PER_MSEC)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104153645.8294=
5-1-sj@kernel.org?part=3D1


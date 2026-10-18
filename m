Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7783CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 22:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D196B00AF; Sun, 18 Oct 2026 18:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D3D6B00B0; Sun, 18 Oct 2026 18:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5247A6B00B1; Sun, 18 Oct 2026 18:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269C86B00AF
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:11:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 734AF16062F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:09 +0000 (UTC)
X-FDA: 85337143458.21.6525DCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D386540004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G36YZRXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792361467;
	b=uKDkcrH7PfqHCXRe4WtCbVMgYoaeKEbbfznAdQUzEKhQI63ayoftemovPzjO+kLX6+FkD/
	27vWXOHZE4VOApDKQHF4feCjEXo68p/Jv9W6ofyfKVpDdoIsP7nQEHP0WAwRxWkU+qe1tP
	NU67muUTQAq62FpwIe+PxvAmyYfhjGM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G36YZRXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792361467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og2EJsxxAc5npVZpLxXfEFaB4KJhNSzXqile489hobU=;
	b=NfW2ixSPVIszbaGMRh7NX4VpaYaBSFM965zfWAk4gvYV/4uGhjbHUEf0nD47l/mwKKMX8/
	gKjDq/ZUhEa/OMyfagYmHlSvNMpHFdylKRlS3x6dJkB+QySzL4x6nDKqJ34RkHvjP/5wkG
	jWGC1JF9RqUuTqL7ppH5FhNkUCniS5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D928B42004;
	Sun, 18 Oct 2026 22:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896B41F000C4;
	Sun, 18 Oct 2026 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792361466;
	bh=Og2EJsxxAc5npVZpLxXfEFaB4KJhNSzXqile489hobU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G36YZRXC/OTU73bwidpCd7iMYyBCjwB4nMI5dHa9raADe6QInW8Wvv7D49l9rjclC
	 kmVh9EOVY/n7HOYeUzsWYtBg4UdIlyIVJaUi8VRQZ3wxmiV/oKmIeX1aUmHVOPcwvF
	 DpH0vuTTSD/iS9TcXeC0YH768wXDoReRd1b0nim/AlmK5635zVpr+tCooybkC76fQ3
	 Wp+r6lb3xha1lBaA60L48NHd6XSxPPaok0ePQLJzGICyTeTCUG2Kn2i7/xWiumzVK0
	 /fcOM9TVP1o9cwLsU2gllYXBtHWEWCwN4DBWOTL0Z4pCl/xBBwN0tcSj6lLRFA/Qp0
	 /tqwHpyLSyq5Q==
Message-ID: <sashiko-outbox-176425@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm/damon/core: filter out damos address
 filter-split failed region
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261018220253.158238-1-sj@kernel.org>
References: <20261018220253.158238-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 22:11:06 +0000
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: D386540004
X-Stat-Signature: 4dd6e5gzxiepr7mectn1rchnepimqb33
X-HE-Tag: 1792361467-498572
X-HE-Meta: U2FsdGVkX19QncLhPcVlo0p1KAm5X03rj0VrP3h8KreczWHI9Zt0aDrrHIyMdyWTY/wer93bcxj09no54bmFROzXU8uJJMLpbkQZUtiL04+6ydgwrSP0rmuIIfXzlvL8gNIHwjQVhxmtHdHBeCjtxrCDEWxKqaatipTMD9I3hldsAurS4aobtppvUXuzs/0s+S+levcZ7qVujlrKnbuhgVElZ2RorwE0CYVis5qCopPgp053OI8l2Spa70xttbf6wdTo08Ge5PHsCK/4owjm3cCfycZoNkZSEi9QhbSBIeNM5PDuLrOLinwzwYJNPnNIbJzWWnG9L6ecTudlatKM1wIqySyg2c5r76XJGEz0U2QNosI2JP1QrHjkq3F8/woxKlwjftEw/UAi7hrF8cmX2ozo0HzvJeDFQJpIbbwbbUINJDBQlDq3c+pakAHMgrkZlMpuOc62XisvTd+yx6Fkc24WSIeEwjZlVecaYwsK7vHcVffgKTNwBgu7j9P6AhNwKQBme4ZjvKmUMgb7ZVw65ja4GueCBr58qYx7JF2iiTbMLT9c/ScGGKsib9MH6fztAy4ovZVOWp48aF4HXvLFSsn46v7R3Nsjia5Uc8h51/fuwF9CmSMgkiMJzG56dPjpAGZ3qDaXTFcGOg2C28YzjqrP0MM0GDnpXPtIK7I2WwTLlZEsRZgviyYbUR7vXlPlmbM4UzcJd/iWtAPfK5HLeYo+0lAyA5OUImYkUKXarfzr5K8dDJa1IQer2C8R5nFpFWt3ZEduAMzWcJt4oJcaIpzLmivm5GW/zzjuMgI/EKID0Q+lOxegu4MjR07X47nMxM95WOePORxb73zNZ7o4OApGIBmL31xAt6ni6dAE4pJ8frAQ4HZPPsyjl/3imc/clHCeNR6x8XErvqGSW6zIJ5eW2R8QY9nSuOSmOTRULjGewLb9zfbWcaKyAwwzrKgpvWO/vSVl4aWvd+GE4/0
 AXxB1fr0
 tWQ7joK4qP2CRJlkZXksYq5XvEpyYu54j/guOzk1aYaNcPtrKcjr2ocoTieCrlpdt1mcRN/L52TDvD0DwDj+guSRIUMh2YPp0CDpZMZfYPtSjrEH7DPWN9AnzDwT+VvuYPXgz/E2ZqbhoM52GQYnzUwQVjc7cwj6MNK995BBYdS65ZwWerT0M9JzQfidH01aJ0USvrL2w3hc1T83rYdxG2xm+nonclbk1uLdXtEKs8IzSgAiPtA1gGs8jgRTmqo/W90ZR+4dARtMYfXgG/foeM+E9ggQQ5ZNDADCCvdH95rH2RMcnpr0osxPu+GE6BWTh+28RIm0qlD/AMDZ4N6kut7R6eiUofHp0v/IGp/Fxk2/5LLrlh91IJ/exV5y3LI37aW6h49uUaw+zkvXVBLMnYkGq0khHE7Y97JfHaT/xj3vse6k1rcsKEJt7Yrt62BwRWt3IZ/GMKtliHrkFMShLK4guNDy6kpLZEtNGdjz1NFbMYFqMzeePwPsixmGp1dRM4pCBfr/az5e1wvMp4nIVFtRddG+CE3abHwt785I5ZO9KxlIr/MvZzYAUp1PlKTSbmwUjX1MBkmaMnCIs24FIp3LfTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/damon: unchecked damon_split_region_at() error in damos_filte=
r_match()
--

commit 881e287348e01011e3ec5442e7deb6f9c112db9c
Author: SJ Park <sj@kernel.org>

mm/damon/core: filter out damos address filter-split failed region

This commit updates damos_filter_match() and damos_core_filter_out() to
propagate errors from damon_split_region_at() and filter out the region if
splitting fails during DAMOS_FILTER_TYPE_ADDR evaluation.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b63e60ef89901..4d34587387456 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2551,13 +2551,14 @@ static void damos_update_stat(struct damos *s,
> =20
>  static bool damos_filter_match(struct damon_ctx *ctx, struct damon_targe=
t *t,
>  		struct damon_region *r, struct damos_filter *filter,
> -		unsigned long min_region_sz)
> +		unsigned long min_region_sz, int *err)
>  {
>  	bool matched =3D false;
>  	struct damon_target *ti;
>  	int target_idx =3D 0;
>  	unsigned long start, end, wsum;
> =20
> +	*err =3D 0;
>  	switch (filter->type) {
>  	case DAMOS_FILTER_TYPE_TARGET:
>  		damon_for_each_target(ti, ctx) {
> @@ -2588,7 +2589,9 @@ static bool damos_filter_match(struct damon_ctx *ct=
x, struct damon_target *t,
>  			break;
>  		}
>  		/* start inside the range */
> -		damon_split_region_at(t, r, end - r->ar.start);
> +		*err =3D damon_split_region_at(t, r, end - r->ar.start);
> +		if (*err)
> +			return false;
>  		matched =3D true;
>  		break;

[Severity: Medium]
Should the earlier damon_split_region_at() call in damos_filter_match()
when r->ar.start < start also propagate its return value via *err?

mm/damon/core.c:damos_filter_match() {
	case DAMOS_FILTER_TYPE_ADDR:
		...
		/* start before the range and overlap */
		if (r->ar.start < start) {
			damon_split_region_at(t, r, start - r->ar.start);
			matched =3D false;
			break;
		}
}

When a region starts before the filter range and overlaps it (r->ar.start <
start and r->ar.end > start), if damon_split_region_at(t, r, start -
r->ar.start) fails with -ENOMEM, r remains unsplit across [r->ar.start,
r->ar.end) while matched is set to false and *err remains 0.

If the filter is configured to exclude [start, end) (for example,
filter->matching =3D=3D true and filter->allow =3D=3D false with
s->core_filters_default_reject =3D=3D false, or filter->matching =3D=3D fal=
se and
filter->allow =3D=3D true), kdamond_apply_schemes() -> damos_apply_scheme()=
 ->
damos_core_filter_out() sees err =3D=3D 0, does not reject r, and proceeds =
to
call c->ops.apply_scheme() on the entire unsplit region including the
excluded address range.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018220253.1582=
38-1-sj@kernel.org?part=3D1


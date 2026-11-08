Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1CB606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cgIoyWxd
Received: by kanga.kvack.org (Postfix)
	id E071F6B05C8; Sun,  8 Nov 2026 14:35:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE7C6B05C9; Sun,  8 Nov 2026 14:35:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D5A6B05CA; Sun,  8 Nov 2026 14:35:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7686B05C8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:35:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E45E8013C
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:35:11 +0000 (UTC)
X-FDA: 85412955222.28.63AB43B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A15C1A0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:35:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cgIoyWxd;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794166509;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMoelyuk2VfMurY6waAlYQD8QytmPxb/gWAf2drSJiI=;
	b=NyVHRF2qG388QL0uFhDx1/iVe6E+xB9ibwjErAw9hxCqzRBl2G2UtNNFT/MHLifbWQofZ/
	tBX3keghHOYDTJ/SqG0S+NB4949fXrcC/BlNJrppjX3RXqkQpnTjKnDwAGmtajqQWT/jlJ
	8EvudJx6GnHtpkARw0J1+hSvZLbf0C4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794166509;
	b=rCTutvfP9UXp8F6Q6El5wQgW0Dnn4VnPdljA7Au8P+YM6ypXxy2aOb0W0h9lOKZjxwZzec
	pH7QpdeLdjCW6rPIjUHnAnHXdfS7Vf1R4jBmQFWOp1KUNOAAN2QZswTDCpBKH0pMtrCpan
	p/2FCIoYVJ64J357DmDHUhbvNBmhRfo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cgIoyWxd;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 288A161909;
	Sun,  8 Nov 2026 19:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917121F0089F;
	Sun,  8 Nov 2026 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794166507;
	bh=qMoelyuk2VfMurY6waAlYQD8QytmPxb/gWAf2drSJiI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cgIoyWxd5IGfr+5BDqb3s16fRCgVR/zP2v1rPaXGaBZomrweBeELCPCfn7LrOnOKW
	 wx8Zsb9KQZ3Jmkc+nfR5GzDOoBTkoo99Bk9xzu2wWulblYaBY1Br9Jh4xxQgAfgyo5
	 SbKORKY451zq/oBphMFweWck94KZYapODD69Ey90NZ3wFDgR6SqsWcM3Arsz3DdoUt
	 w+Cr5kyk3YNTccMLmHD/R99ihqSXS02kCQMLIZbocpJkN55zucp+GmuU3u0tbB1R4c
	 PZqYPwzbGf/lilYinYkl/bqRRljeBD02+v/uzKgDE9hdu5XqblYEfN/9dIqe7buI6D
	 4Ju0cQrTa1c5w==
Message-ID: <sashiko-outbox-203968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261108192221.114362-2-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
 <20261108192221.114362-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 19:35:07 +0000
X-Stat-Signature: ewyur9zpgth48p47xhwypm31jmtsbmzo
X-Rspamd-Queue-Id: 7A15C1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794166509-433277
X-HE-Meta: U2FsdGVkX1+r8AoHzcUJuM9S3xe3H+J2pe6uicy5LEMcdfldvjp5terHMjt0TL4c/45ADsVcmYopuVIMAij8LAp0Nr22iIYs7tBFar77stKKYrAyB0B0IjHhtjPxA0RDBdPL5kT7uRlfViffE7RZk69G9TLcg32tIuRcoixmGk8N2Dgb/AzuLH3RYNd+Uq7FOPLZGUgtWGZKtG2uql9MDcXAJUevmM+E4Q0Eg49peiXbmtz2sLgSSE6xKCKQiH/kWSGUwcRiQop0l+jXNciiQH1TCaMKSxiwvuInWDLDLVYaZ69zfHU7RaqRLw8zm1itdcYFbuGLRG0EWIOUOr4dn+ElvOKHbASdkrXi8DPi2FiXP15vOAnn0qkUbncIOvAmmbYO7a/QW5VvDaPFIhqXcqcK1Fk/edclyb/jRgz++5XXK0hSffXoPhkvJl97LyD3yhUuCYs0BtTfhEtgHNotMssBJAcxVvGefXpKHiABtjtuYHUr7cfsghEO6knAC/cvAlcz4v9fE0+eJeXrlR+jNj2yMy75ar9H7W4x4c7W/ASrL+dMEWXWCoMM0mB2PIbK4E15nKvzWSv2xeGlYnXciw1xLIBJLkqOSX8je60JGPS3Z1+XphUrx37ID+5BG5Xi05CRtHRP4VgLIrTz//aNwr8iuKi59i7JDEwQPGid4dpDqnPYEExqi2nIGCibapDfco1m6jpe5XM/tDSlbMUxFyPlJohAt7YS290dRIQmcgW9nFNN9vCsetklOOAUZhCY2gZLWoz66v+L11KqQjjybqkSzywklTBhgE8qXFosJcZAX+zJDK6rpLH1Y2T7wdrHkzZfCTVLums0lQgy0Nh6d9MpDaQ8urxqO+PrN/b0BMPZ/jdo4QRzSES7oDNFZbSLzCLthK5dZMND1nLz+OSsgRWkyAkmGa60ip8tysZ31r3o0+uCRtBt0HyO0yFy+3pcFa0O0THgGUebXJ+NG9c
 7EXihFp9
 2YqKJ03RIivpOzoH4UW83Ui29CYaZg7tUvEHbKmSXjBKqyBL55oFXgQqT3mp+yODok7xWDmD5G57L0isgt2xsfkXIIzX7OcbYL+SCVrotPaqzJNJoQdQbwfSNmsuludlUqTD9ZNSYcJn7KO/s0H7jsU0vGT1R4wDqw2MeABZ6eVDgM2UPKJLmJ+PjfIfPkymVh8HywTQ7KTsW5F8uWm0BLkDzUhCY53dYPxSRwZVscf9utxV/Y+2iJMo8dtA0Qoh3yYQlzcpBK00bxDiyfOSCS6g6eBGcGHxc1TuQtAkRSKQZrWkfO56S60M7ESPX08cSiaFggAPAKdJp5jrOQw86wlBD3nhl3LL4gC5mNF+XdKvdMGBd7WrLJNywnMVzI7uyssy0ALOfmXbA8BODQvKa7k0OsKmosGOC8d2V8p/40f5WcVJ4JTXUqkwxbk44MLgs1rWqHAB2RfsG9W6V0fU7rPeDHi/8hij6CQZ4rvsmf46ayZeRa5asd483M3yEPwUiUV/TYKVncWDW6iotVfDlk8nzejWkzrkJH2sn9YuPkTUXqryCdR5UyAQfE56GdeSQLnqO+K1sVGHJpJI5PiW+DIyyvw==
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
- [Low] mm/damon: damos_apply_scheme() inflates stats on region split
  failure
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] mm/damon/core: total_charged_ns overflow in
  damos_apply_scheme() [1]
--

commit 9174bd7b58d2e2acd57046175fb6abb05138bbb9
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying a scheme in damos_apply_scheme()
when splitting a region for quota enforcement fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8fa788b0d709c..4c536a9b958e4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  					c->min_sz_region);
>  			if (!sz)
>  				goto update_stat;
> -			damon_split_region_at(t, r, sz);
> +			if (damon_split_region_at(t, r, sz))
> +				goto update_stat;
>  		}
>  		if (damos_filter_out(c, t, r, s))
>  			return;

[Severity: Low]
Does jumping to update_stat when damon_split_region_at() fails inflate
s->stat.nr_tried and s->stat.sz_tried?

At this point sz is the non-zero aligned remaining quota size.  Jumping to
update_stat calls damos_update_stat(s, sz, 0, 0), which increments
s->stat.nr_tried and adds sz to s->stat.sz_tried even though
damos_filter_out() and c->ops.apply_scheme() were skipped.  Because
quota->charged_sz is not updated on failure, subsequent oversized regions
in the walk that also fail to split will repeatedly add sz to
s->stat.sz_tried.

[Severity: High]
This problem wasn't introduced by this patch, but can
quota->total_charged_ns overflow on 32-bit architectures [1] in
damos_apply_scheme()?

struct damos_quota defines total_charged_ns as unsigned long, which wraps
around zero after roughly 4.29 seconds of accumulated scheme execution on
32-bit platforms:

include/linux/damon.h:struct damos_quota {
    ...
	unsigned long total_charged_ns;
    ...
};

mm/damon/core.c:damos_apply_scheme() {
    ...
		quota->total_charged_ns +=3D timespec64_to_ns(&end) -
			timespec64_to_ns(&begin);
    ...
}

mm/damon/core.c:damos_set_effective_quota() {
    ...
		if (quota->total_charged_ns)
			throughput =3D mult_frac(quota->total_charged_sz, 1000000,
							quota->total_charged_ns);
    ...
}

When total_charged_ns wraps to a small value, damos_set_effective_quota()
computes an inflated throughput and effective size quota (quota->esz),
causing DAMOS to process far more memory than allowed by the time quota.

[1] https://sashiko.dev/#/bug/linux-c8969436-aa48-48c6-9f46-a12a64361494

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108192221.1143=
62-1-sj@kernel.org?part=3D1


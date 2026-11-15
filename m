Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC385606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wah75oXT
Received: by kanga.kvack.org (Postfix)
	id ABFAD6B05B0; Sun, 15 Nov 2026 15:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A707C6B05B2; Sun, 15 Nov 2026 15:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F976B05B6; Sun, 15 Nov 2026 15:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5DA6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:41:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFF8A14080C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:15 +0000 (UTC)
X-FDA: 85438523310.21.C353ED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 596261C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wah75oXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775274;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSxkxgjUByaP/FYRn8+uu178H4zEv9vDMaVbpvfzlA0=;
	b=t7pimN+RPLgiKnp/2oMZ4ok2fbo3fgND1SNSNiBz/fFdXzYmrsiGTO3ci7mVrpBNrYiZnA
	8RhZmg2m7/COfX2Px4Zl1FpSXfQUvmlugwCv/5XFZpB2IaCRIIMVZ/ir9S9UtxDAqkNUL7
	xB8+VCPxvbQOOdhPM/LfwoACo3hbDB4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wah75oXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775274;
	b=xjPbLx0kM+akffS4mDWCBXtSAuqAz1ZOWC4bJAD8H944LOvUB8oWvQvNoFHiILqVwMZfjE
	oxAAAgGMh1BjpfC9hkSf7GYfIJG0kmvjjCQF+UfeOD48zm5F4KM9a+So8JhFksOFa+RX88
	sWaHCEeSnWMzESQxJMxBF6HisXRqJik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9777601BE;
	Sun, 15 Nov 2026 20:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6ED1F000C4;
	Sun, 15 Nov 2026 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775273;
	bh=PSxkxgjUByaP/FYRn8+uu178H4zEv9vDMaVbpvfzlA0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wah75oXTv2g4ttvtDi6nwIIBo8lsoWaTHCTLZLfGxhNDoypBNWWYtaVdjs8CtVFnn
	 vFbClSO25JEdibuy+6h6C9kbRRDHAbHR2taRqwmbyPuHe24Wdnepx5JVLqwqtPTJ+b
	 kCyfdl6/1mRnRzVjsOwwV9SMMdCHyLzFatUSGIdogPj92ZQ+F3fK4K4BeCSdEkmQJg
	 WdlhqRzml3rLrUVeaFp3TYEhrlTuMkSGWUCPIhwMFcARw2vgGW1Lela+YTq60DuMIW
	 Hb6kIm+cOjT+WABlKfDWu6JfnoFcORM2oWiL3fxB3SHqlwEEk3jmsr8SRhfws9bkRm
	 irecO7xFTbLsA==
Message-ID: <sashiko-outbox-215848@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type
 probe filter setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-17-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-17-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:41:12 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 596261C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: smk653td8cmwtdw4bpyj4mu66qcqbtmj
X-HE-Tag: 1794775274-701945
X-HE-Meta: U2FsdGVkX19HuJlUehE++fxuCp+6d80EtcI1O//SoJf4G2H9YNySLkQmB9Cjkydt9z0QFkfFOHdPsRb+5mw0utONTHXtthZCzL8G3W5Xb3GBbbWmCxVsKkUn5V5B+OHz6JFEuxUUEs9cimGPsYK6RJj5kAL/1ed+lE2IwU4JE9hkoFN1T3ZsbkqNWrWqwEV4Cz2QLqpWGH5Rbce6bXSaFaBwWTIUeWrFgZS4IqEm5UoP09k8m6JkKkw134tHfTYreVyK75a9RYTHyGsUU6ZOXEzYT6nQ+0yJGoHFIexD/RNhSkdRTXR2mxFuY3Rl/6eQ1ZiLByItReG7s/EAKEzubWTmbOSl7OBRnpGyZgpq8SWhHnawHGQWqpOed3Ok8mlrLwULIqtxhfKZexughPEvBPH0PZUggzSZN3biUvx9SH8qv5sPo0uN4IDQaOEpKtBg6ruNdpyucs4K6zoECubzw8AvSy0dsea8DPZIdFGMKsLwTkSAdzllVopzXv3TEzFyt9ZNNHE9AIptAUW4sLwLptGFjsc3grxY1fzJsId70thvSy1f7xhVSey8aSwnWcWrbwyK9JFQOwuprFbqk/2akIPDgzdnE9rtzzw0UdSXuzcP4OHr2ukbR34KZ+rZ4LRcq+Eh6RBflqem1V4sG+3IoSooUEB7qtd7KdF5b1ImW8+Phf2tdIlym7GlsteOGnEvMNTQiZdQ1IVL0TfDnvprhr3mAgWwyypfpZNdcLCpnL+G7nXagU3F7qphDnZHaZ3xkjGUshnkFELmGzhYuiAWKup3ijIrVRd1rAC1AsfU+l+9PRa7vp0KjICPm57ozQolPlH+HIcSHPxBYMg6mrfv3A/SMu162ArcKKvJb+2LZxn8tSZQDylXL2MdGi7hexY3xkCQ/Hf2DsaCygyT+sg7WHgmG42DZpcGexQE5DV0JOAP9GnYH3lx1c9v4t+UnJ5Iq8z027cUGxwFjORFVot
 VN3FfiEU
 tV99UBGP+5ArQnXaDjK5t9nAbA/61cEeiEq0W/dzomq5ELplfeDvCGGWTmktyDxvUhGrY9g77iHvJlaUiUBH22MGS4zgnnWXwMHy9xKg0fi7cnC7sGOPcYKWbQPt4eE0xp2PhhA4vE14XMxeLKPMbE7sGMIbkKZWrcbJa1zkzWpr5UbHYdldVkavZA2MtypmBD9ih0fpSGgK/LJrfX1fvgTkTELCwYevh1zY+dcomEdyrp1OtwCaHTyWrkLyh6XohZHcAykemCzLll+poMZw1AFK0oQnLyRyGJ2Iq4Ekvqd3sZRAV15FCsaqor/zS+UNwCwMwfZ36eVQluLdTPHs0UXZTg/0dcXtyhdbUdwDr0mVdbK0oTq8f7+5tNASa9ppeLV0hmxP4/MJKew407IDCet0hmNjo8qxdLSywVsEDzX1kwTiPMk5mlgn9NeJcnDKTyXW86fq9SCeYa6G3FWkOMkgRbUgQG+1kjR6bpU3yj7jUvW0HVVzVDXDlCQV7zjxwVBSVETENhLu2FJV6pPPepfmLASa92CpZrEoM8qggb/7s2GQlG0LK3HEhyRmH7zxBKeLqApn/YUSGwaB+kUQ6Hg98hUXjELDJw+nqKcHbMlQpPYIiNXlXQrLNlNaCIK+f7xT1co3CyRkM4QLG741xkDF/Bul+6ZI/G3TwfqKEtcl12gCrw37N4/fMZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/damon: out-of-bounds and uninitialized access in
  damon_report_exist()
- [Medium] mm/damon: uninitialized report_type in damon_commit_filters()
--

commit 6058e18a855d5b73c171dc4b94eb6031f06fdc63
Author: SJ Park <sj@kernel.org>

mm/damon/sysfs: support REPORT_MADE type probe filter setup

This commit adds "report_made" to the DAMON sysfs probe filter type list
and copies the filter's report_type when setting up probe filters.

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index ca971cf1dcf6d..1c171af4590a8 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1016,6 +1016,10 @@ damon_sysfs_filter_type_names[] =3D {
>  		.type =3D DAMON_FILTER_TYPE_ACTIVE,
>  		.name =3D "active",
>  	},
> +	{
> +		.type =3D DAMON_FILTER_TYPE_REPORT_MADE,
> +		.name =3D "report_made",
> +	},
>  };
> =20
>  static ssize_t type_show(struct kobject *kobj,

[Severity: High]
Can enabling DAMON_FILTER_TYPE_REPORT_MADE filters cause uninitialized and
out-of-bounds accesses on queue->reports[]?

In damon_submit_report(), each report is stored at queue->reports[tail] and
then queue->tail is incremented, so queue->tail points to the next slot to
write rather than the most recent entry:

mm/damon/core.c:damon_submit_report() {
    ...
	tail =3D queue->tail;
	if (tail =3D=3D queue->size)
		tail =3D 0;
	queue->reports[tail] =3D *report;
	queue->tail++;
    ...
}

When damon_pa_filter_match() calls damon_report_exist() for a report_made
filter, the loop reads queue->reports[idx] starting at idx =3D queue->tail
before decrementing idx:

mm/damon/core.c:damon_report_exist() {
    ...
	idx =3D queue->tail;
	for (nr_read =3D 0; nr_read < queue->nr_reports; nr_read++) {
		report =3D &queue->reports[idx];
		if (idx)
			idx--;
		else
			idx =3D queue->size - 1;
    ...
}

While queue->nr_reports < queue->size, the first iteration reads the
unwritten slot at queue->reports[queue->tail] and the loop stops before
checking queue->reports[0].  Once queue->tail reaches queue->size,
damon_report_exist() reads out of bounds at queue->reports[queue->size],
and the next damon_submit_report() wraps only the local tail variable
before incrementing queue->tail past queue->size, causing subsequent
submissions and lookups to write and read out of bounds on the heap.

> @@ -2336,6 +2340,8 @@ static int damon_sysfs_set_filters(struct damon_pro=
be *probe,
>  		} else if (filter->type =3D=3D DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
>  			filter->range_min =3D sys_filter->range_min;
>  			filter->range_max =3D sys_filter->range_max;
> +		} else if (filter->type =3D=3D DAMON_FILTER_TYPE_REPORT_MADE) {
> +			filter->report_type =3D sys_filter->report_type;
>  		}
>  		damon_add_filter(probe, filter);
>  	}

[Severity: Medium]
Does committing a new DAMON_FILTER_TYPE_REPORT_MADE filter to a running
context leave new_filter->report_type uninitialized?

When damon_sysfs_commit_input() commits the context built here via
damon_commit_ctx() -> __damon_commit_ctx() -> damon_commit_probes() ->
damon_commit_filters(), newly added filters are allocated with
damon_new_filter(), which does not initialize the union in struct
damon_filter, and the switch in damon_commit_filters() does not handle
DAMON_FILTER_TYPE_REPORT_MADE:

mm/damon/core.c:damon_commit_filters() {
    ...
		new_filter =3D damon_new_filter(src_filter->type,
				src_filter->matching, src_filter->allow);
		if (!new_filter)
			return -ENOMEM;
		switch (src_filter->type) {
		case DAMON_FILTER_TYPE_MEMCG:
			new_filter->memcg_id =3D src_filter->memcg_id;
			break;
		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
			...
		default:
			break;
		}
    ...
}

As a result, damon_pa_filter_match() passes uninitialized slab memory in
new_filter->report_type to damon_report_exist().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D16


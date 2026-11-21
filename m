Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11667606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d39iIEEj
Received: by kanga.kvack.org (Postfix)
	id E92286B05E2; Sat, 21 Nov 2026 16:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43376B05E3; Sat, 21 Nov 2026 16:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59646B05E4; Sat, 21 Nov 2026 16:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B05FD6B05E2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:11:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EAFEA0538
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:11:50 +0000 (UTC)
X-FDA: 85460373180.15.9E1F143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7061D180004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:11:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d39iIEEj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795295508;
	b=uC99VjYKpK8FVXiZFw6dBE2AjbviAL9EY3q38c+iJo7R8wOa1uyT+mM4GUfHz4IXAsQk9J
	XVCm0NFiegL2c872JJkZQjZwEJyihLhqfPRtC0SKRzwj8P2juvp5F2YbV4YynJ4fBLswqn
	jgXawK27HSwqheogMwxYWrVFZo88oLM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795295508;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8ZevwdJGMQHEXIo4r3jD0w0C3WV9dYZLnb659zW1N8=;
	b=LbPCm0pi9J4z1BxEDnJf+sE0bc5dixzS1nN8A6ObcmzsIvW7WZQeW36InX0rI2CVmxlFs1
	w/24bqRdWM5dCgcq0Hkp8/BVyHEy+dy9LeJkuGho9gpvBnKWbgKVB/8YbA3mdw/wJweRb4
	KzLtwY9CYPCtn3GMkGkR3tVC//IVCpE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d39iIEEj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5B7C4436B;
	Sat, 21 Nov 2026 21:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A31F000CA;
	Sat, 21 Nov 2026 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295506;
	bh=L8ZevwdJGMQHEXIo4r3jD0w0C3WV9dYZLnb659zW1N8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d39iIEEjpKdFEcI4uJMGV50pzV1E0hbs7NqlQUiCgzW1gVYRkLOt/FM/VaNVa7ulG
	 adWSuJXs9Ldg69vcLm8Y8nfNTbbnbyBUcC8zDVJpFs2Ga2TMhWf+9Qaz4Mv1FB0roF
	 2nA0md1kzj5DtGbUn7u/gtr3meHI0jm3LtLk/f3rO4UTCPDQvj71sITuQyxx2gl/Uv
	 XAWlU7JhTdW2fPSvBUCvHAjiYmpgaNIu964S5vJYoLGANdIeycIcJnDjwaRTSVzaJd
	 PXBS4UPRWLnQ/SL+KRflx6d+rTcAZAvzieGtctAPx/3TDgHrC8LAWHHLvqrokSt8WO
	 g/UGVTjXccgqA==
Message-ID: <sashiko-outbox-227387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe
 filter
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-15-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-15-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 21:11:46 +0000
X-Stat-Signature: ju3fm3nko5jyzafzaxctsess3omaqz8f
X-Rspam-User:
X-Rspamd-Queue-Id: 7061D180004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795295508-394776
X-HE-Meta: U2FsdGVkX185wO/Bjs4NNKcfSQWe8eLfnGCfwRG1mbEdUM1oxs5tT220kEXB+yzV/qBXcQFlZcpvdnv8vEA70BOrW6fWif/fOhbxOkrKRbYbwuAhi+v1Gogx4SpMhHFSYQdlkv6EP33PRFACpbgP47GV3y1jkUqJOU1OBMbuzxplfOaJR0aPKoePEr7QgbfOOmElKLUvXgRhoGVbQRUK/Sj3idyPkH/e60krliVusYawjvnP0yMuurUcAaWEWhqJVnY0GkRO5yirLiBRFYhGY/Dt7NXIX1MnHaCYNevJCQYIwvk2wLqZRcvwRzPzZWC/qCAtjP9YSqp93/xp18T0N5OKgRc5RH9IapLSiV+RW6Be4r3++jaUhxUjoa522N7WkIwFumazRAYhrsSHBbW5uDyLcHoh5rQYf+HlQomr2ScbY2YlQ6wl/YSemWeUXmaFys0sRCWm62DF90/jykvBLhj0R3TR4pzFbTM0QzB3cPbY53odyQIFTrgNFDCF3RV2jfZMbjGxvyGZ1oCedIodYovnekvmVS36jn599+r3IU6ejaYcBYnwzO05Ym+axeNz2BD6vBRAJh5oadDbEEsxqAUxCAKA0OvUKW+p+dr3d7ccZCPkZipoYgXZxIsscviFtBGZZ/X5dZJ+/mdM8rCl0iV3RXKafY5MdpItvOKsZq2aD2Djb4bgimaSaKkuO9kcyjzlmNLhCajRw+nnwef0IVBLLybjWvHYIF8XWOn3L7S/7ErhxjhcDxmdpKFVZvkfc1n2nK3C666V9Fq+xRDsGyZXu6HmuHzTHTIZADVMJAsLfW/LPs8u9TRxNTng12SW/1whzmHzS2UgLFaMLfbxuUBEpa4H5OdlSlU+l5aYdBIe/75ThaGTO6/S/Cs0wwpI7y+uHDeYYNn8pX4LQ70AiaYzizf3kCL64XihyxkslE+F07PBzsOSbVd0rdKi8URxVng6fEKwsqcyHrsbxZR
 sND/idF+
 iVbVX7UF9nLJPB9SvLqoZO43BiUjGxIHlic49n2Lh8rwhQhIEKRhO0lLExYEQJsHkOxR0HYd2m2HtIre9oqvpuFosOJFuKN6t09171qclTBnfbg3Pm/T5lEgDvK2qLePs5lx5uyevXZiHE07AM+cNEV9kL/L4lYTs2tuqR9Mpico+pQC7eu5RZNEZRCMpIluFit2PZCWSQ3KtHb9KXDzSw9eWRkwfw7KNqJbfZJQvNu+ohtGMRLxpZEyStc87BxcHrhSQpCnvIh38Jgel7UBoCobHvkOPp91YA0jeJVRenzr8iDeR3ICdKV4kTaVGhOxY4dujuhTLaA+C/8WwfgzvXIpRCX9pk73TJvLgUhrtgOwIoh7DxtSmJMR5hqpq4gUy0gV4LeluOvNAsOA8GmWX2wlE6/mSqViZIDX8BvecK1SKmtejoVlxxbO4KwFnRCt1Cxt92vQQzFXal4ZbiyjdnE0bDNDj/+ofZESGJren6VW+lBvIc75QWgp68Yocm+pMNEGPLGlRCq+wqDHuQYfZF9aUT0gDCijpPqMasowcqoGwkUE2qq92dN7U1pe/phKJtkCRO/GIvq4YeH5FPnSS0uD0Q3UZZosCg22R9vvIg+IlMdvPVl+anOb6pX+LNc3rp0wEEBhJ8+Q9kb7GRMFPFhlO2q1rA9HEstv1IHaVuEi/cBertvUzirwjCTvl5WO9r6tezn48MHeYG5gaLZWipMYiKmrDEGng7dr4HtEqfGLqToy6yzOi0Ozc93DLNZV5dEhvXxz4l1ofn6s36qQvgsI4LX1dLDhB2g0RYavC7XcFaniGfrc3uJvUpGw0Uo7QCLALU4JbM5dJV175JbwtV4K7dPYTq+Y/MRGlI5F+I0jxTBI=
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
- [Medium] mm/damon/paddr: 64-bit phys_addr_t truncation in
  damon_pa_filter_match()
--

commit 28e4b56e5a2332a155374f4f6e67e8b3da9ffb34
Author: SJ Park <sj@kernel.org>

mm/damon/paddr: support REPORT_MADE type probe filter

This commit adds DAMON_FILTER_TYPE_REPORT_MADE probe filter support to the
physical address space operation set by querying damon_report_exist() over
the last sampling interval.

> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e89cb14ee17be..4003ae914f1a2 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *c=
tx, bool set_samples)
>  }
> =20
>  static bool damon_pa_filter_match(struct damon_filter *filter,
> -		struct folio *folio)
> +		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
>  {
>  	bool matched =3D false;
> +	struct damon_addr_range addr_range;
> =20
>  	switch (filter->type) {
>  	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
> @@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filt=
er *filter,
>  		else
>  			matched =3D damon_folio_young(folio) =3D=3D false;
>  		break;
> +	case DAMON_FILTER_TYPE_REPORT_MADE:
> +		addr_range.start =3D pa;
> +		addr_range.end =3D pa + 1;
> +		matched =3D damon_report_exist(filter->report_type, &addr_range,
> +				jiffies -
> +				usecs_to_jiffies(ctx->attrs.sample_interval));
> +		break;

[Severity: Medium]
Can assigning pa into addr_range.start and addr_range.end truncate 64-bit
physical addresses on 32-bit CONFIG_PHYS_ADDR_T_64BIT kernels?

struct damon_addr_range uses unsigned long for start and end.  When
monitoring physical addresses at or above 4 GiB with ctx->addr_unit scaling
on a 32-bit PAE/LPAE system, the upper 32 bits of pa are dropped (and
addr_range.end wraps to 0 when the lower 32 bits of pa are 0xffffffff), so
damon_report_exist() matches against the wrong address range.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121210013.1303=
97-1-sj@kernel.org?part=3D14


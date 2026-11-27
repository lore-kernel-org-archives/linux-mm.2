Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC0D606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFt7j+mY
Received: by kanga.kvack.org (Postfix)
	id CAE9A6B05B1; Fri, 27 Nov 2026 15:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E3A6B05B4; Fri, 27 Nov 2026 15:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74856B05B5; Fri, 27 Nov 2026 15:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84A046B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:48:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD61CA7FE0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:48:19 +0000 (UTC)
X-FDA: 85482086718.10.C8D82E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 49BE840002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:48:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFt7j+mY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795812498;
	b=VdIj1wWC88m8N3rpsi1mAS34zamwp7tz82FRrXAYzkz8zPRek/QfWxbYbn30L/ZkaVnUd4
	BrDG9G99Lxznlmitw2fUUsaA4FtNhU1WdiCZIRprr+BaPehFwLe+RDOBDWA0MLaoGpD888
	CmVmd1h/azXSCG/xkEr2hncm9IcF7vc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795812498;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sllkbWDxXjWYtj7uG2v2TOwOgj+n7g6G9IaAtPlGIVE=;
	b=YqPSB4J/I0l6a4hC7fBb+IBn3N1Q3jAMRR7GCq64FMJxgDb6qskJGbS5trNhlxhWqVEGvu
	bjUCn1kEimq9EtWN8eC/+1XW0awVOTKdaNKLFAdHtZsF+2qcIUeZKC/oK8cpDrAf7Jxilz
	JVTQqzpwJY5tNTg2ZBLJLxt7GClA0lE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFt7j+mY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82CD2410BD;
	Fri, 27 Nov 2026 20:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1DB1F000C1;
	Fri, 27 Nov 2026 20:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795812497;
	bh=sllkbWDxXjWYtj7uG2v2TOwOgj+n7g6G9IaAtPlGIVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bFt7j+mY7bZARjb3g9pJPiITfMS0DJEXkG9SMIhpRJqGG6LlyojRMgCzsepzLvV6B
	 KcR3DRgLYogyhtNxeL4xiyQWSnc63OhegISiFOeRKXLe9Miqux+aDC/Ukz2hoP+pxq
	 oqDwFHrdiN/fv4/+JHDdb4FYeTZ3TT5yIgh+rMtnRwICOGFb566vE7hVbckAXqQBlr
	 qe4bmyNL+N/ZhPMPwGdNuUIP98Ql/8PySR9opLPzyS5qUJYpSjjqoBkMqaIZ6uarPB
	 KeaUdJEG4jLFQwDEUcH72VNu0bQLRH5ZyQf0rLCtsrWlhspQgqpfqTyyzspJMVIqI6
	 xyz/TlJdpnMLQ==
Message-ID: <sashiko-outbox-238270@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH mm-hotfixes-unstable] mm/damon/core: do not update
 stat for core filter rejecting region
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261127203938.94339-1-sj@kernel.org>
References: <20261127203938.94339-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 20:48:16 +0000
X-Stat-Signature: 19oi1376yq8xby66qf7fkxk3i47hahub
X-Rspamd-Queue-Id: 49BE840002
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795812498-143514
X-HE-Meta: U2FsdGVkX1/8ntFeY7oPv2sOAbAAFGE4idszZnhS1S3TsZNORPKmIQoMlWguhAabLSjErs1+cKvncJIyOMujHrV01zS75v81VlZhyfyE63xfxeo8BrFsIMUakZoHU9E6ezIlIqgB2dpy84E4aP/02QNLJJHjFCVUdWPCq1X4+uqNViSqVNOE8juKLAh8XLTsA6Bm0kEre1B3HbdUcPdX3wXeiagMVK+TnVTFZ/owNSaQTQVT+qzPNA/Yn4FKbopxnIBOd0KTPUfJTjpp4pCHvXtlu6+7wsa5ObA8iPXToXLTQQ2P0rV1zHzeENfCL88ZbfZKZefOC5n4hE67HR3V0CCPSxNeg+BQNt5de5R2wC8p5Paf74nq+mx7h8/kxjdBPyjkWyKmrpYhfrvUlH6v5CdYsz1o2+Psm45a20FqQukJnTrnEhcSkOAZutD7FZZVvMDRe32A0O6P8leEfYbDIhVvqqZAKwJoVUmXAFrfTHCL4WGPkMck0klUheJU2uemyhlhH7FJiL4EjpXCbfjDddHXxGSO2BrQl0Xw9G2uWBMn/cRpiEbUwo+HbkRTKy/SqjuZui6dArYL7+qFcMQhuC2YBXiQk/+alZvepwv4DMAI9U4CWlccT7yA/vCtUg6Lktu37UdwLAYrWal9kko17kgdcz0JmE1SpWjf7KQk//gw4YPRUH7Zr/QXKNpM1835v+RYss25DIfLhgeOWNaEHZNCUTCe5uynuck43xeES3vzh7pbu/uwH1W8jR1zNjuUBFAJHlLaTP5Rgw9US0f8zb8WuSibjc8ioKl1FCkrWgtL6xZUmdqpfCeplzLhSi0y2f5SAZhCeFIx4N7DI7yj1ZXCVGLsvqKZnpG7KOgjJ32FtRHlsV6GjTj7n+ZfJoHwee1J2rEPvDrf3bgEXV7/2vIig76McaEh1XEFR/ZUikV2I4jnj4lmiRICNzavFxXg3ydot7u6coTBe1f02uy
 CHZphfpd
 lmXLswJ6+4AeK3bp3DqrQH/eHqYpcb41C+4NBtSM127gWC6Ce07qelFXcK+3PuIf2iuh/u6JgW+L0Ig2X5/5aN2XJrQYWagVSVKfPcrV0i5ymZcclicIIbHR7Pr5qYWE9hezaLCZt8u07T5QBbp7b4QVIPs3H9aOm7N5fsKzrK+4Dh6x881fnC3RSEVtt6G+JOY9MWIPs2nRklQvAO7wAzp9ns1/7L2eP1ErpG34HO2QlSxift48usHgxdgQyZLLmI9TMdHxU8TUppTb0e2lifbQS20LJxgbUyU4htWSqJ+VUxWVL3Dk2cUWxWDUfCVHWOiDGKKWzTNfNJGZHtgnuCwCiPJMrUfW+R9FffQRQ/u6LeKj91eD4ux1WIxlBtoTJv5N9fuWxunc9ywCSvBGVxKQ7GtO+FzSewXjrOD3BEdUHdVvcbrsdyOHnfbYyoRjRy5XsgF/4hArZOzHTD4p7o28ouvnpClwuQ4sQsO0JenWNkBv+lT8xj0xPffngrucBK1UK7OpHo/k7dhV7//byJyxazEeNtlK2GeehjwhLjGwH2ZlXwDjkEL5OuJx+7amA/787Dejg6ZrwHEoVvY9TAqbK0DWfveTdgoVGceZWspEQBilp8YE9mGdrOQTXKJ38HFzayKVZU75cW+raFa6AV+RG8g25Xu+qbtD+niM6OJk4Jqg3T01nmGCZqii1SNuSGdWUxTwawWxV//u9SrQVHRo3ysCSmfZUxA6DtaSkwLfoowTTSiQwQF/u7uwHyLS7R3D+g/opyFDgm8ynHCVa9lQ6qz31qZT7js2LFL/mmJtXby15JGPEXxD1dA==
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
- [High] mm/damon/core: stale region size in damos_apply_scheme()
  corrupts regions
--

commit 2aba0f31066065a1efc163e77a7548d189458afa
Author: SJ Park <sj@kernel.org>

mm/damon/core: do not update stat for core filter rejecting region

This commit moves the damos_core_filter_out() check in
damos_apply_scheme() ahead of the quota enforcement check so that
regions rejected by core filters are not accounted in DAMOS statistics
when the quota is full.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0e6b361f97ea6..e0ea93de100d8 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2785,6 +2785,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  	}
> =20
>  	if (c->ops.apply_scheme) {
> +		if (damos_core_filter_out(c, t, r, s))
> +			return;
>  		if (damos_quota_is_set(quota) &&
>  				quota->charged_sz + sz > quota->esz) {
>  			sz =3D ALIGN_DOWN(quota->esz - quota->charged_sz,
> @@ -2794,8 +2796,6 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  			if (damon_split_region_at(t, r, sz))
>  				goto update_stat;
>  		}
> -		if (damos_core_filter_out(c, t, r, s))
> -			return;
>  		sz =3D damon_sz_region(r);

[Severity: High]
Should sz be refreshed with damon_sz_region(r) right after
damos_core_filter_out() rather than after the quota check?

damos_core_filter_out() -> damos_filter_match() can split r in place and
shrink r->ar.end for a DAMOS_FILTER_TYPE_ADDR filter.  Because sz still
holds the pre-filter region size during the quota check, when the
remaining aligned quota falls between the post-filter and pre-filter
sizes, damon_split_region_at(t, r, sz) is called with sz >=3D
damon_sz_region(r).  That expands r->ar.end back across the filter
boundary and inserts a zero-length or inverted region (start >=3D end)
into t->regions_list.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127203938.9433=
9-1-sj@kernel.org?part=3D1


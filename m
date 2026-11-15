Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8B4606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCOI3UKP
Received: by kanga.kvack.org (Postfix)
	id B03F86B05EA; Sun, 15 Nov 2026 15:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADAF96B05EB; Sun, 15 Nov 2026 15:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19C96B05EC; Sun, 15 Nov 2026 15:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865D36B05EA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:36:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A2544032C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:36:05 +0000 (UTC)
X-FDA: 85438510290.11.D4CD379
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8835780002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:36:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCOI3UKP;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774963;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHToU/BiGUI+WxfYLTR89D31Aiw4o97ubpuVSP2LxpE=;
	b=6lqKXnu2PqWhVfSXMfMlJ+tR8G1roFupK3Ncc3E7C6INW/hSzOnC3RXDIyQZB8s7pz4zPb
	8QQ48M9BxHz9ZhcVPARb5ata/xuTF5p8YwE2PGL1Ish0Iz6/WiQZesAlcnTPEzjAvCK26k
	KqPQc+EzAeCYKuG3WizePVf3bx0hjnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774963;
	b=dAM7E9bPSUmhNeAEbYmUIQ6rgKk93iUt2SKpXJF3EMesqdnHmEmQg9003h5uShvNzNeVFU
	n2REdnwF+jKcORUxaLh06FCTIMHj2yQg62v2Rf1lkdMPKTHCKXBX332CS7ietv9s42RmAx
	B6VWdRAUqA5B/P0Rgnl1UvMfW1etYms=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCOI3UKP;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4D2F40567;
	Sun, 15 Nov 2026 20:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EDF1F000C5;
	Sun, 15 Nov 2026 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774962;
	bh=IHToU/BiGUI+WxfYLTR89D31Aiw4o97ubpuVSP2LxpE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cCOI3UKPD8xCU7gxQ9rrCBQF3qv4LlGfW+UCMfm+uAdGuGLixyiip6w5ph0lzIGeF
	 QOetJcW2SCJexTtScjpeBQXOTUv11nMVeh9yoEPWIgeV5Uaof0OMl+Hb2TQ44DnbIU
	 nCayCRNOs0yDRoU+TOEP9rnEnQxlTMVkni91BSeOmjZ4eHR3ncTc7RyJG2VZIZOMfK
	 pNLu9PXSpuWlCNTMclNCWQhbCMFL/H44g5giD+d3KDdqhZEtwKQVhBeOjlcEIDkSLG
	 XPm6oEBH4Xi0ls4NwK28uhsAG/9Ht/z50yN6yL6P6/VcVXS2289XIJvUzSNxi2lfQK
	 IUaS44dQUxW1g==
Message-ID: <sashiko-outbox-215843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 12/27] mm/damon/core: introduce
 DAMON_FILTER_TYPE_REPORT_MADE
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-13-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-13-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:36:01 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dz4d5n7hpxq9tr1but5zzqpo1bbj4ze3
X-Rspamd-Queue-Id: 8835780002
X-Rspam-User: 
X-HE-Tag: 1794774963-633931
X-HE-Meta: U2FsdGVkX191Cns62jDDIg7tIp0xyv/8yh/CbNhagT/ZXO2ikA4JDEaLgBDSFYEllPWFQufOHoWvRHPHF6dTh6rUviDj4IZHyuDxEIN2tDsoKUaYfqpQUkBU1W2OTR0he6emRH3J+ksZBlcy24Iw1LR9JuMCWI1BzETxGD2hYs+UEsPsSeUYRGDyV4yJJkbdUyxhPXEFDK7GWXemxczy+tNBiziIJa1zK1OasD12vQP6QHj0r2Vg+0afRwO4Qsbw2DP9rVDu6V6TLONiEX6G1x7DPOQyo0hPxl9MIINdalQNbfeMBgjs0RoI5sZuc8LymBOlTk0w4UgtJF38OZSJb4Y1ABPX5NUhG3uT1MNl1qJ9nfbenE5xY0FCZTrLniLuRwFPK8TPYDbP3/CwZfa519kFv/NLXqrps3QYA2wMIAjRFTMV2panFNm3aXobWjhZYk4nuDSqry0k9X+nPMnkZZqr7gvdTu+ekiznNI0B5Fa8zh7IwlFKtB0ZUhCMg15UHP4JPcLgqvRueajCjgDLgmgHQ1QrWMZ/Z40ScjvPBqYtDD6vcN61fkJHIf0hBKJIggwYe1jYkEHADhVvDFwzZ2vUolF8XB9ktvOV21Tdvqb4SFwPbaw2D33W3MbFRSApS43qVlXjKSAyRbGRCBoeewoATE5cFiTGpeIq+kjgVuswEMsHn+oMh6wN63CwKnlBo8l+1HmwcP3IvE1Ieq12G4AtdnyvwCT//jwr+p2edVYGvJWrECHuE994b5mEDQiTcjAILt+5k1aJ4OJemUZpkLge2RjQWBnKjXEacrIywewNcZjZOoOCfvQTjln1KsiLGn5cz/LM4ha/S9z0cdOdzatu+mcHRauMUVjwca0/+Ma4yHOAcAhDQUA6+qu6xFYBLTB19d/CmxYF3pVqdGw56UMdbGvj4MqEz6ucpF/+XPScWTeXPlZmM0Lv3UJjeFYf15i4RXW5we9Js7Yrd81
 5sIQ94V3
 DKWvsBZZZlIxc6M+tE4df6ckTM55JOtIMDXnWdBqAawh1+0+uBLVyNJnqZeDIpCKEPPOETtsGA5/RpCimtqyDJ58MvWMER1D7kidHDaRfx7dHO2SXBOGrw14dMWtPMTYJFbeAOH8Z9hS7EJe+yh3Deskjpopv7sckVIFZIX7pMoidImDtuqa/CntCZU9QBkwNb15TyF5hU4WHI9u5cilHLPGMiULNZn9JMa5mRgz/x62yKjfWoePXFxiBEUGR3DBp8l4+cMBC3g88CRo7ZWULJGlUG0GGw6+y5CINPEemKVSXJMuquIgxRdE/LUg+taEZb3bMw/DmVqgzc+L+DCtJGewotusUSzXuPYJV2qZoD0gUurROlwREc90TBUhetRoe6LUl7ZDsGGqjWGiBeS7DyGdsQEe9WX6Iek8OUF8aezWBr4PW4Ne/B6K9lnqQLlEJALx6SewxX6TF5K9fnn78FF0DdcZZW4sElMZXGNab1YHACsxDYmyJDzppFudkLbwuUrO3jN6b7eXMjy6K6TJBgjI/czf+zHQnDkRDwGdvaJug3R8IPWTbsQ9c5fOEDeTtGk7AQZOUtH1hY3CVuwjHRGDu4FcfzAOFuVBve5Hk5IU2YG9GNyNUR70gLRJSzFZ8nhiX
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
- [Medium] mm/damon: missing report_type copy in damon_commit_filters()
- [Low] mm/damon: missing kernel-doc for report_type in struct
  damon_filter
--

commit 4743cf0114c7407b0d8b853557595a3a4674cb82
Author: SJ Park <sj@kernel.org>

mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE

This commit introduces the DAMON_FILTER_TYPE_REPORT_MADE probe filter
type, adds report_type to struct damon_filter, and copies it in
damon_commit_filter().

> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index ca0135c6f6700..cce7d344c585b 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h

[ ... ]

> @@ -834,6 +836,7 @@ struct damon_filter {
>  			unsigned long range_min;
>  			unsigned long range_max;
>  		};
> +		enum damon_report_type report_type;
>  	};

[Severity: Low]
Should @report_type be documented in the kernel-doc comment for struct
damon_filter to avoid a kernel-doc warning?

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 06b85d00e38d9..c02c7fbc1d864 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1834,6 +1834,9 @@ static int damon_commit_filter(struct damon_filter =
*dst,
>  		dst->range_min =3D src->range_min;
>  		dst->range_max =3D src->range_max;
>  		break;
> +	case DAMON_FILTER_TYPE_REPORT_MADE:
> +		dst->report_type =3D src->report_type;
> +		break;

[Severity: Medium]
Does damon_commit_filters() also need to copy report_type when allocating
a new filter?

damon_commit_filter() is only called when overwriting an existing filter
in dst.  When src has more filters than dst, damon_commit_filters()
allocates new_filter via damon_new_filter() (which uses kmalloc_obj()
without initializing the union) and runs a separate switch on
src_filter->type:

mm/damon/core.c:damon_commit_filters() {
	...
		new_filter =3D damon_new_filter(
				src_filter->type, src_filter->matching,
				src_filter->allow);
		if (!new_filter)
			return -ENOMEM;
		switch (src_filter->type) {
		case DAMON_FILTER_TYPE_MEMCG:
			new_filter->memcg_id =3D src_filter->memcg_id;
			break;
		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
			...
			break;
		default:
			break;
		}
	...
}

Because DAMON_FILTER_TYPE_REPORT_MADE is not handled there, committing a
newly added report_made filter leaves new_filter->report_type
uninitialized.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D12


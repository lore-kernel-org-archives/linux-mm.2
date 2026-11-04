Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5C7606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3/ZktAz
Received: by kanga.kvack.org (Postfix)
	id 576B46B05B1; Wed,  4 Nov 2026 10:50:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5283E6B05B2; Wed,  4 Nov 2026 10:50:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D9A6B05B3; Wed,  4 Nov 2026 10:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 230E56B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:50:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95D5A120750
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:50:26 +0000 (UTC)
X-FDA: 85397873652.05.E63BAB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE5971C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:50:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I3/ZktAz";
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793807425;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2Rm/qqSbuCxIXb1iiVZqgo+p9PpDw6v0y8c0lPMvLc=;
	b=QBOTg2f/iRrf5JvkAK9Ogr6YFSQNfixffOKPrWFbWPj9GQDKeL6fQHPtsm+MatqTZbs38g
	EMYf31cmeN0KhRFiEmdHzCo1aOoKHONjuYWpD5Ij/Ch5jlfTBkJTI3VMQ0GlinHNwz7oIq
	Ir3e4GFiuTVCJyKetXS+bKo68WE+t9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793807425;
	b=rY98kW7HbYm1wrGhQb6Kec8azaOvCopKqujNJ3HEeylyCYqya3y2f+9EV6w56daXbzwF5W
	iOgLVj/e3UkSxoAPdwYmE4RbHw8+Imxqxei/ayI6Kbru+Z9Kx3tnjIgjCTYRVWxTg0eqSf
	t9cBA+36NggJGkuHT1gdLWZg48xc+Vs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I3/ZktAz";
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E2C640672;
	Wed,  4 Nov 2026 15:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85851F000C1;
	Wed,  4 Nov 2026 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807424;
	bh=K2Rm/qqSbuCxIXb1iiVZqgo+p9PpDw6v0y8c0lPMvLc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3/ZktAzonT+YJQP1B7Dfbe167+htrikqCuyVM1BQMd+f/JXPzVqNuLHllKkPiSYt
	 7rpVHNHimWsaAZSQFYYQ/GUcXH6uqne+IjWdKwyOHxrNg9DAnXORe/XgB4mao/MN45
	 f9aLgSiDPn2BsFsL1HFusNldxTDrlooToV32anBz3oTmL31kVqAL9GRhgKeI2JcGeg
	 QgmvxvdQ5BNrrYs7pmuAjNW03JLOH+lVbJtS/oKbOr9hh45VQrQvSsvNXjaxJnBGCt
	 k3PD2xA93KBNRx0Ad0q5L3NJexTpfb1p2VTSzg9blgxVDFBaN7eRHZEKq7t27Arhit
	 jD+Ixkzc8qseA==
Message-ID: <sashiko-outbox-197544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/4] mm/damon/sysfs-schemes: support
 DAMOS_FILTER_TYPE_AGE_MS
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261104153645.82945-3-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
 <20261104153645.82945-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 15:50:23 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 38hxd3q4sumywqpnrw3he39wsojc7947
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EE5971C0005
X-Rspam-User: 
X-HE-Tag: 1793807424-132735
X-HE-Meta: U2FsdGVkX1+epf9aTc8uldO4Z78RNn3vsEI3q9C9+ze4w+GPDiHcK8eW5ldst49M0Kgwcs0nQbjYv0GJeTIrtnDyccaWJbB8YPGJiMFAAoGF/k4Kv2qBD0iMQyDIq11nzgS0wFgZyn+aoJ9OwY8b+HAGhZTsNVrgR79rwNOVGwI4qfYw3vVW0wLCM3PntuNLon6OmnARlHk/A15vuPn2QxjOtzhqKiacG20L7v/rOJ+E2Pop7WZRTEAWBEpum2DAJlEa3UKo0MMMjyO7HM1W2aY49YqWzb+cxEbX/mX+Ems9M5KMTmf6CX9XOaXPDZyYdMauZgi/IoFTHNMSBlVY/Gr7WWA3XRj9kPfVR6pu9kdTltJhBFqpsDlpV7Vt0nSYYNCYZDp9nv2PWWXE6xFKV2c8KDeVX7id8vI+teIwvfyRM3ADC725ZumG8DCCuCVx1VSTufymehc/kYHUt/IT61Dmfqb56oQOqCwaTJPKbk4f6r2Rx3qRrS/xw5txLTz9iAHZ6hlR5nhBZcudIJX+KnTrEK1POHGzVVz0fTtT3WyBXb6okNI8aYptLdEgnjrMY0wonknQPtHyy4sC5yu5qYVs6D/QqsLf9bsmCsu/C3aa2aUc3ZXC4ZRL43bmyub2O10DGTvk8lcvQuZgROhy1vg8fcDkgVxoI+fpYJLcfxpkVaBSGbGS9tlUwAF01yGlGmUCPkcbssJ2Ca/Xtwi2G/jYXOoaD4N8IxcQxRIM+cMAOcaaLrP6FMX/5ddHCkivWoC0Io58wUD+iy1fhJR5AHuEJQY5ZKaotthub3243pqihRJelKg/WBhvEwMG1ZzgkXQ14uPXBY4FdRVy9gr03IqG/PWXAySdgpxyYSENM+Dy/PA7iU7TCjia3aLbEXv+7BZXcCKwt0DayBbc2mjO2k3mrV3Z6GnHTdcC50Z8R5Ka8+XUT3606spoOLs+QhKD432Ffmkpk6qDoJttgXx
 uTZx4nQH
 JlSMArd6h+BTwEUimm5HcOFTrfDG2upVO+TUG2H9y0alxC05zaRaEvWXcSin1JLaOOt4skzFDMCiPKE9BdFN+luE0RV+Gyw8c43UjM2MTG0d1iZh2zZhQhGMPTMC9gX6a9rwLYZJjbDFWFcASXaa4z9YCnQwruCvcRJPu15aApgBJ0NCccxOmiDFz7DOxxiilnafe6NrMWCHkyeb2xMAn1kY1ezETHIcMgProOeU0FOMQgsJV2iYtYo5CDKmD4aMLIi7wLXFcNjOEsEg/rcPX5Yac+14PIZRfwevQILenGWYV5DEemgy9P1pKXvXN0/CKSyxaUk1p8sJnHfQpVJUerY6e8geAZC1RC4B+PHlY4dpgDm8j/T/83iLk1WOko03vx6O+hOXuq/tRoxuxpRBkRb42lTnKscIP4ptEAAbmI0J0f7b/nzVchK/MFJNoviqZDCPwVJdj1v6UisAyKJzPyO3qJf/jp3FbmOLCXFZcg5B5i9jTeERq/2NQAX8LJ2NDNS9nHxzfD9FSlTrgW4D4An5xAgi8SOGl+WxCqTs060w312onmAEhLl4hYDgQ96MyGekkFdzhifWe7CGWwCgCdqDOLdr+o7NMgVHmQ0pL6sq6yS2bTKMn4qxTJEdrJbdXnTd1
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
- [Medium] mm/damon: 32-bit overflow calculating age_ms in damos_filter_mat=
ch()
--

commit 9c78f1b31239922167bf213c5406c37c05fd310f
Author: SJ Park <sj@kernel.org>

mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS

This commit exposes DAMOS_FILTER_TYPE_AGE_MS to the DAMON sysfs interface
using the "age_ms" filter type keyword and the existing min and max sysfs
range files.

> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 637f1bd0c950b..230987efac3ac 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c

[ ... ]

> @@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filters(struct da=
mos *scheme,
>  			filter->sz_range.max =3D sysfs_filter->range_max;
>  			break;
>  		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
> +		case DAMOS_FILTER_TYPE_AGE_MS:
>  			filter->range_min =3D sysfs_filter->range_min;
>  			filter->range_max =3D sysfs_filter->range_max;
>  			break;

[Severity: Medium]
When userspace configures an age_ms filter with range_min and range_max via
damon_sysfs_add_scheme_filters() on a 32-bit system, can age_ms overflow in
damos_filter_match()?

When kdamond evaluates the filter via
kdamond_apply_schemes()->damon_do_apply_schemes()->damos_apply_scheme()->da=
mos_core_filter_out()->damos_filter_match():

mm/damon/core.c:damos_filter_match() {
	...
	case DAMOS_FILTER_TYPE_AGE_MS:
		age_ms =3D r->age * ctx->attrs.aggr_interval / USEC_PER_MSEC;
		matched =3D filter->range_min <=3D age_ms &&
			age_ms <=3D filter->range_max;
		break;
	...
}

Here r->age is unsigned int and ctx->attrs.aggr_interval is unsigned long
(in microseconds). On 32-bit architectures, multiplying r->age by
ctx->attrs.aggr_interval is performed in 32-bit unsigned arithmetic before
dividing by USEC_PER_MSEC, which wraps around once a region's age exceeds
approximately 4,295 seconds (~71.6 minutes) even though the resulting
millisecond value fits in a 32-bit unsigned long.

A similar 32-bit overflow on r->age * c->attrs.aggr_interval in
damon_hot_score() in mm/damon/ops-common.c was fixed in commit 0284dff76e87
("mm/damon/ops-common: fix age_in_sec overflow on 32-bit"). Should
damos_filter_match() use div_u64((u64)r->age * ctx->attrs.aggr_interval,
USEC_PER_MSEC) as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104153645.8294=
5-1-sj@kernel.org?part=3D2


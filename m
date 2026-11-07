Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB507606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gB3PONk8
Received: by kanga.kvack.org (Postfix)
	id 4FDCB6B05C6; Sat,  7 Nov 2026 17:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF8A6B05C7; Sat,  7 Nov 2026 17:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FBA6B05C8; Sat,  7 Nov 2026 17:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E61CF6B05C6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:33:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F29514040C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:33:41 +0000 (UTC)
X-FDA: 85409776242.02.542FD37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3C9E140007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:33:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gB3PONk8;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MODwKQRYO4GDp3rYpGZwVLoSBR2IsHfImNwOzMkTcjM=;
	b=cHb9Fd+q7i+pboEqmfwBopZ8E8BKdlfcoY2i2IGrXxUBBBuI5T969xR0J9d94eciEW+mYY
	dOQ66N5xwRokunLBY+CkvN8RqSg7pLSrlP8pjiVIzjpl/X4BKyl/PVwS1ujwBJWmCGkj5j
	EBY4XMq8geLV0gRYgGhvzwCBQnqqW7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090819;
	b=08xOEoENqONMDH0V+17vBTMLVriCgqy5amRv+cWcMwgqWtK6KRrL+ROOsLRyF+Zl2Cg/v3
	OMnU9pIv89bzgp+oSquAH1/zg+zBDnuLlkUjHwOInZUeEcOOFiS7JXdueHQCc1fBvrLgbX
	/ZpidPz76/8tn6Ddh1P+d+QY8LYziKk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gB3PONk8;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 453F661213;
	Sat,  7 Nov 2026 22:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F931F0089F;
	Sat,  7 Nov 2026 22:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090819;
	bh=MODwKQRYO4GDp3rYpGZwVLoSBR2IsHfImNwOzMkTcjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gB3PONk8CA+MS2j6v8aMS9L8RPUu7WZYUV9OXr2DD1tEpaguD5JgV9oRmUqgvCqGd
	 E5a/66brYdG3hNqxHdJ5pt9j+KTCK6caX8FsNkEEOfvbWBpeTyjC2pVJ7OMxg6WgJA
	 oOJx/MuPF2ir7fzrGt0HL41H4fxtFkyaI/bPNON/El4sXEJmx+YvyWJz9lgbnCE5uP
	 9CP4DiaO/wGIHOf0rcglW/+OlSGJyJzt5o0mWk6r1rcJqAWWkDCeiT4R4yhNDVNuFk
	 ChtBvv/eWpzh7R5ZYIJzuxbypn3LwwzCCjhe0KRMkgg8g8zfpLssjHO1OulCRUeeCE
	 qpswuTMqSZiHA==
Message-ID: <sashiko-outbox-203366@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107222202.331476-2-sj@kernel.org>
References: <20261107222202.331476-1-sj@kernel.org>
 <20261107222202.331476-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:33:38 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 6kpbkw9kx9r6imehpqh4arxbxoot5o7z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C3C9E140007
X-Rspam-User: 
X-HE-Tag: 1794090819-217165
X-HE-Meta: U2FsdGVkX18ODl8ZQV9rsCzl5RwGO5FolJJzJ/XY2xSVsRWHxF+O0Tp9TD1/UHVUU7eYvmTS1lzNZEixeWCsTnZsbV3kGXlwmpfjrqn+JEEH1Vb8933Mk9A5IOxplictYoRKz24OfKmciGbZkDkbybhds86PyNuSrXa1Dm5QTf+OTOx9Aq5/5U/4BenQPdZPHjZuGC2IM3NFwOuRKzUwUC9bfVIa0tqmhLIZQHwHsgApgMvyII8kseB4zFwFYQcP7FUr7BNzWpOkvgPJ3NHMTJADUsr2qG4jGF0CZrZ8VtJi4gUFCE2Y9eqNhsmh6dTE/ZMi0QBPFJMDBubSvBuvfqZjFKCJXtagC/UbQLbmu2egoSUqpuOBce6sCBLCILADoHrk6R+VYztHSG49SFDH9SF73WHRZA2BTAtpKZfKccJTwppQQUUa1eV90pYqUOERqq2kLeIuonCPy4HV2kHI1N85VjQ9qUwRnezuluYdJ20AO/O0jvTRLLhBIbNXbCbEyZO5EqKoQYiwkWOwDPOgQkFLHCOLF1I4ksQdkHIOhGewiXYUC3N4VJYJOxGRjD+yoQ91zqNmJ4wpQkd/jWViVdRUdjvH+8Nnw+D+566d3O0uJqNaxHmDmW1Zn8xgieEeW0oG1Y4jNT7O0c96pZvTd+L1VMSroukMgrq3fU5kDLKouVWhiOep4xQ21Enj5K6QMS9Gahfo+4BCpFynKB/e3uVKiqycfYP0U8WoDoBOqgoTKU5xzKDXZyuKAcFo82mUvuhcRnSGaBwGUijEgVIv6jz9/qrjXK0lXJuvWkoTr06zdEwuspoZfv8oVz09U6WBX0y/G7MBs9Frbjx8/RHtZF6iP7hxGNm0gQiv/SLntfPx8wrotdv8h41PgFgNeXtmStnh33MSJnnj+5r9QidyOem8VbtKI3Bhin+bhqANr5FuAGR6rWjcNxcarLcjy95MLTis9h/q3SJ8whnerdb
 GlwXre1D
 /BLYEuK6VFP5AAilzGlTW27lt52L8LhW2JVCCvVbhZSCJffd95SJ5ZtdS0i7WFZkK5zENsthU0lUtbtuOCWAInVKEW4u6ZdzVKCYiK0g6PggS6tgE0avdHUcjSE1VUngv1bsPdyC4zlTd4CJiinc01QzFLLWJFtMVWpPdS9ZjqKEj+XpZyYJRKH5E4lTHiKlxMtCHsWyZ/5OvRFPar7cZPqj3Ql4izMI13ewDPn8ZcRTjHxGLDjzPlteWyKXf6UXX6ScMudmKde+1d5ac4fhG7JRH9uddVh67/keLz+GosHmBNSxu2TGa5AdAQ/e7y/yEdAxFHUSRMeUAyK5f8CesAXNMoiQDG/Lirl4GDFemio+4yTNff8P6oL0r4KWS7q5Tiqn4pm7tq4hOOM2TV/mScHFQ+jF3NLN+mLfGXMNJwDPQ3LzBliMXs/EGeMfAFFZ1tVKS0/NKyCF1gc9EmYIuU+mkeIkremE8zXuHg4i4lMQiypsqWx1jS66V10daSOkfx59bM5BsBa4rSJnSZ8AWultiXnV5KCzsde74l8yC9F6QAE3a6A9sf04OJGcSY/g3GKNUiDh6Ri4LT7uGvMWAUPiOmw==
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
- [Medium] mm/damon: false tried stats on split failure in
  damos_apply_scheme()
--

commit ae5a2312a946a6108ba6414ca8a1f6fb984dd078
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damos_apply_scheme() when splitting a region to fit within the remaining
size quota fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b5b6d00d7a3b5..9d4a78deaa06a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1004,7 +1004,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
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

[Severity: Medium]
Does jumping to update_stat when damon_split_region_at() fails inflate
s->stat.nr_tried and s->stat.sz_tried?

At this point sz is non-zero, so damos_update_stat(s, sz, sz_applied)
increments s->stat.nr_tried and adds the remaining quota size sz to
s->stat.sz_tried even though scheme application was skipped before
damos_filter_out() or c->ops.apply_scheme() ran.  Because quota->charged_sz
is not updated either, every subsequent matching region in the same walk
that fails to split will add sz to s->stat.sz_tried again.  Returning
directly instead of jumping to update_stat would avoid accounting the
skipped region as tried.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107222202.3314=
76-1-sj@kernel.org?part=3D1


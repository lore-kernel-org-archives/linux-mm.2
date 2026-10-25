Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D87606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvSwpLKd
Received: by kanga.kvack.org (Postfix)
	id 6CB466B05B0; Sun, 25 Oct 2026 13:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BDF6B05B1; Sun, 25 Oct 2026 13:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592006B05B2; Sun, 25 Oct 2026 13:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3516E6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:37:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCF7EA0611
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:37:58 +0000 (UTC)
X-FDA: 85361856636.28.1A9D51E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F428180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:37:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvSwpLKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792949877;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6YdtImNwe6af5qwib8NpoZYdrawK3T+YWHepB8B6hA=;
	b=VgDTUyo1uzxDz5jNHLoNs1a/w7gDg2WDZ3HeMhjuvjfi01DeLZ1F4quOnVbnWT07rsTpr+
	Nhn7H+UDD7WKrQPZLw6ZHUJCs8M1frIoXy6YTg4li1G9i9I6OwO8MTXeuNQLJb9SAq9vvz
	qrcVKlL6JWlQT5DgPaNn+PO4opLY+Nc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvSwpLKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792949877;
	b=W9v0mTQCghInS5qqIkYDkhjpvVaBJvrePyFXYWTuAYw6D1AQSjm7nYAyTALqjqIfYlSH4R
	TkxTL1mxTsdmODsx6Uk5x6mVMUTzWJR4+9ybp5cJ1NdWUNP+QpegcG4fxkIGZbYs3Y/uWc
	PS2mFjk7eSjp8efUstWD5HQUbGwPzOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F1840C4B;
	Sun, 25 Oct 2026 17:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B051F01825;
	Sun, 25 Oct 2026 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792949876;
	bh=L6YdtImNwe6af5qwib8NpoZYdrawK3T+YWHepB8B6hA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZvSwpLKdpmXM4OGa3XU/WiJXNtDxhRf07xDXwNKY8SA8kvtKYF4tTY+yw/4qi9L7x
	 emB68p76EnJS1sj9+fxWOTHn4aAuqRH43Qv6FQ/Pvdq0BtNb3pcJuOTUKByTeBAC+z
	 ODahYiDYXiqNjhuQF3tSphWkTD2zO2qsLpWc/PvDGO+eNIz2IDjz+fRi3Rszj4hDHo
	 vhXvryjnYtgAA6ebryijaAnW0YeGeWwKlcAgOltqJo27FCjn0P0IhfgaK44dVgwYUH
	 4ZKA7nElFPnD2/DCW66+kO9LFiHtTGA+Ghip3Dx/qRsz0L4SfBMcc1x8VEM+0YdAW3
	 2kwRbtSY9c3Ng==
Message-ID: <sashiko-outbox-184295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.18.y] mm/damon/core: error
 damos_commit_quota_goal() for zero target_value
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261025172712.164385-1-sj@kernel.org>
References: <20261025172712.164385-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 17:37:55 +0000
X-Rspamd-Queue-Id: 1F428180002
X-Stat-Signature: z6xrfxpshke5jeghf8x6i8jqfhs48akw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792949876-980453
X-HE-Meta: U2FsdGVkX1+iYQ1jwsQCjBD4BhDn7mFOQgwD5rc2Cbmo5Yi8YpU5XM5XftVNDQ6l+Fb00LVGc69lSlzX3LH7XeAaWvtBG5dc9Ni+EHTYZh506UUYDKNg+z0GziAsZ3zMqToVJFl73BFJJsfJMj+yMqQYFkFu9ztABgI8PrSjHFo94DSt9qVNsxd9tLb/SsSCaZlSEmTZ+GxgBsp45S+8/YHnGPXJSKU3gYODJKIFV7SSiJDV+BF+KAanG+tQQrbxhHzeSqUOlamV3I45QfqGhY2elHd2AIK3iA4SBzpClEG9oynUuFjoqznh0/FE5xTBCpKAkP5r7lJBWbRYjdLkUQsYTdWT8dLOsfwUZy85rBryLt823m/PY3aztYDxQbiK5k/3ii2DsmjnTm7PveF8iYUqY3iWT+JGdTSRl7+TDQsFYWX79cHu+sg9kEYV8/jzS9yN1pTOI6XqlV5S/LCVeE9XigH8LYED82NnernplJVCediEILgo+CRBhHIsgXY5gbi6q1EBUcIfdc6WzQI7IaWJb7H08frThUThvc5nyxeKYMKGloHqEb173lKJGLB9Tntz2Cv709BQUU47j5kynb7M0OHzQQsqQ13xjVyRtRKZg5vVbxQb10dw+OuIo2u+Ey0EPBS4OgF/Rpyt6XvU0AUBl+Hmgqw+TsenE0fwhUEXNkrzL4Qi0/473GXaMX0IHarv7XXFYhAVGUjDXDDa22eGgUmElJ4ZuYAfksg6VdMwi7eQLnOYHwCyxF8z5prjPCkEpdQRHQ55OGgDsdf7NFfpy3fhSz0GELI3+Q/+hrzOtPpwS19PRBkRjhi2vWBh2OyQGp14uOah0HkCWWUGF5JozZNjqe0pKz26idv/on2+vjaFoJvyAdRNPjY4oaevih2fALifp9lrUBBlpHaX/+9FW/3XzcMFcf8zhLQxo0f0FXuPIJ4cDvUKgWT2x37mDhyBE/lEOUH+rDh+q/V
 In6bAejO
 Qxwvr6lm9p60jss+54gPqYUO0NnR9EfA1vSrP6MoGWgtBhaOjmO3P8lgSEhd3NzTDpbtjdbl7JeMURgx6lwJYEZkInP/Xq3ZcycM4/pMofKlpbjvi+1oEZN2zQ5T6lR9I7Qd2+JqF+5teOkGjIsF3lsBvZCLVfxHC/7+GIiPsHjEduboPcB/4j7YXNiOqyDAWiNn/xJoKPAjrzROQUGyjgFaGbxylD96neAs0t2zRi4R2y0ndnV3RiR9IVIBvhnQePTZ1m4WC2GNOCJbv+acmV/TxsnvIR2A7oscbD21c5cHkHctUJaZKPTatav9wQtAMoD0m3iXGFI4E8lO7oDJEKUHUZIgrsaQrjsDjnmyzeAPPh2b+UDxLhvJucr23A7OWrUrCWBxhSfiO4Q+nbubltPZVatwfevysG192QaLNZtvytu8ydhC2ppza/z3qa8wEjWgTuK6S1wVGoI+sOlCG4pURREOP5+1CfGnSi8rJ4PhYGrYGcpNc7w5Py4niHnSnX7WMU2/KNvPuh2o6g2KNm+qexolf/4PCtWx4U57nq2pgSiFBBhst9x+/OMWnGrHKeDAXuBB8Cv/JHD3fvB7hy/Keu4rP5U6xycIOTwO+GiTu0UdClrIpYwFE+kU0hUgieUFX
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
- [High] mm/damon: incomplete zero target_value check in damos_commit_quota=
_goal()
--

commit ea716ea29282ef733822096401c5c8d92eaaef58
Author: SJ Park <sj@kernel.org>

mm/damon/core: error damos_commit_quota_goal() for zero target_value

This commit validates that a DAMOS quota goal's target_value is non-zero in
damos_commit_quota_goal(), returning -EINVAL and propagating the error thro=
ugh
damos_commit_quota_goals() to prevent a division-by-zero in
damos_quota_score().

Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 4e6e3d7d0a5c0..8fa788b0d709c 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -807,15 +807,18 @@ static void damos_commit_quota_goal_union(
>  	}
>  }
> =20
> -static void damos_commit_quota_goal(
> +static int damos_commit_quota_goal(
>  		struct damos_quota_goal *dst, struct damos_quota_goal *src)
>  {
> +	if (!src->target_value)
> +		return  -EINVAL;

[Severity: High]
Does checking for a zero target_value only in damos_commit_quota_goal() cov=
er
the path where DAMON is started via sysfs in this stable tree?

In mm/damon/sysfs-schemes.c, target_value_store() updates goal->target_value
without holding damon_sysfs_lock:

mm/damon/sysfs-schemes.c:target_value_store() {
	struct damos_sysfs_quota_goal *goal =3D container_of(kobj, struct
			damos_sysfs_quota_goal, kobj);
	int err =3D kstrtoul(buf, 0, &goal->target_value);

	return err ? err : count;
}

Meanwhile, damos_sysfs_add_quota_score() reads sysfs_goal->target_value twi=
ce
without synchronization against target_value_store():

mm/damon/sysfs-schemes.c:damos_sysfs_add_quota_score() {
		if (!sysfs_goal->target_value)
			continue;

		goal =3D damos_new_quota_goal(sysfs_goal->metric,
				sysfs_goal->target_value);
		...
		damos_add_quota_goal(quota, goal);
}

If target_value_store() writes 0 between those two reads,
damos_new_quota_goal() allocates a goal with target_value =3D=3D 0 and atta=
ches it
to quota->goals.

When starting DAMON via state_store() -> damon_sysfs_cmd_request_callback()=
 ->
damon_sysfs_handle_cmd() -> damon_sysfs_turn_damon_on(), this branch builds
the context and starts kdamond directly without calling damon_commit_ctx() =
or
damos_commit_quota_goals():

mm/damon/sysfs.c:damon_sysfs_turn_damon_on() {
	ctx =3D damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
	if (IS_ERR(ctx)) {
		kfree(repeat_call_control);
		return PTR_ERR(ctx);
	}
	err =3D damon_start(&ctx, 1, false);
}

Here damon_sysfs_build_ctx() populates scheme->quota.goals via
damon_sysfs_apply_inputs() -> damon_sysfs_add_schemes() ->
damon_sysfs_mk_scheme() -> damos_sysfs_add_quota_score(), bypassing
damos_commit_quota_goal() entirely.

When kdamond subsequently runs kdamond_fn() -> kdamond_apply_schemes() ->
damos_adjust_quota() -> damos_set_effective_quota() -> damos_quota_score():

mm/damon/core.c:damos_quota_score() {
		highest_score =3D max(highest_score,
				goal->current_value * 10000 /
				goal->target_value);
}

can this still divide by zero if the race occurs during
damon_sysfs_turn_damon_on()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025172712.1643=
85-1-sj@kernel.org?part=3D1


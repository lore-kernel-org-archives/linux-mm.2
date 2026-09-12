Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB36C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 16:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573A66B0088; Sat, 12 Sep 2026 12:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCAA6B008C; Sat, 12 Sep 2026 12:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413246B0092; Sat, 12 Sep 2026 12:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08D3A6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:48:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B4B7A052D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:48:25 +0000 (UTC)
X-FDA: 85205693370.18.B2374FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C08BD40003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:48:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPZFHPQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789231703;
	b=pPqCTByrnc1pQk5K/TcMhjTcmXh4ZGOz5PBgQaSOqN+8Td0cjHO2BlY7A6DgPPpvPt/UN9
	XNNNt1kwCuFEo1zF0MS6E846rHzcrsVrZPwlh7iRwqbi0OAHZ78Qs6d/zLQXYx4WQMjRo5
	pjM0Ho9Sfd+JPUjXYN9z7Vvhpvt0bv8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPZFHPQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789231703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJTGpq+QYVIb+Tro+6y2yguRVCq+0RN5TONlKcSTg3U=;
	b=5LY6AqfCOep1rajXjiQpF5kH/+VihpGkagM1wDxn3+4Ze4eUX97dH7ckFfgnd1qzatsRM/
	cM3q5IESV5eKaJOhn654WXI5KF9fdsdZOV/MAI8ilLkLgxcTPz3H/etb7v/UOJJrZPkA+V
	WtJhnBmivbYDC3s7yLEw0cgRw2quiVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1DEE43937;
	Sat, 12 Sep 2026 16:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5577B1F00893;
	Sat, 12 Sep 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789231702;
	bh=pJTGpq+QYVIb+Tro+6y2yguRVCq+0RN5TONlKcSTg3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPZFHPQKzNJacltdL7bXCWId11+kBuvD3FE6myUE1q6QfSAWH74K7yvtoeLNmdalt
	 x1QmbbwXTQYqaeVNgJXFYf0yHfFen5fIBlR9WqamocoNDsOskygjNiEo0feO7y6hyN
	 M7EOYlTOQ3GgmxACVyS8mn/hptMCNxv+hFN2C3T3dSwO7QrFrJPB2RSNdDkrwSsp93
	 0AqUa154/kre2iKhqIF3oFNljWHB7Y6EMiozg5gEilBLriwzliJ0J3X5/eTBxjZEGB
	 +Ps4MqUyawn8tBoRUzkhz+tYfTC7bX01C0Je8XlQuMEf4kFnLP5s9N/YowfhBLZ+rS
	 UydjYMbRqWFhw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon/core: add short circuit for temporal-goal schemes in damos_adjust_quota()
Date: Sat, 12 Sep 2026 09:48:14 -0700
Message-ID: <20260912164815.94400-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912124406.96535-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C08BD40003
X-Stat-Signature: c9epk5ggn613hz5cchfu1k6679rspc4u
X-HE-Tag: 1789231703-720699
X-HE-Meta: U2FsdGVkX18vrhSP68ZvATjVNsDBOC/3/uYSXbhjwEzXHcXVye3CWCmZ6URfQn5NSccte5hqrX7DTAx0f6DCNP0fNlS3dopZS61Ja4CEr6KUhrckG8cvpUFIg0rdeD825+oawYGSqjiU9hTbuIK5+052Ex4V3/4a9DJHzej3svt/oXe5CW4S0uXG/77fkUSRzm+U5z+rPA/LUdOQB/Mm91pxzLk9qFoqmo94l67Ndl+pXYNv4MSvnerSwMBL22vnECiG66FtBrRXglAB0e4/Y3WxIXY46MqwpjRkabIb/Zea9pN5d7YyaSeZtaCTB9ssp9KQvcIf+BsgRCW5RZ9yLfPpzrgw80bwm6vYy6OWy30u5pBxvW1TWmbUPrKvUOwmX1fYUk8AHvev8e7RGktm0LQhVvPjFqhjRjb5gbXIp5aTL9sZEfetk8qrrMilDpM5nKfyDjyZrVJoAWo7x3dNI96b4+T2ttS6PMpKvGNkzlqwtjqeqo+Q6SXOoODVWA4Bn698JOYGgoDMZ0IyX0u9lcxreOJK4fErW2eQJkdvlczKEQ9nO0CTSKbjwth62iXkc351uEyWl/IoT2IHL157FE1UyPKCKmr9SQnRnbhjr5/2eBbSXnGQITQD7by3AFqCJzrkrdsb4iRJ0/gjSxn3OmYEEfM7NtG0886ere67Pd1eiH4fdeSOge/UJnbuZ4YkOZgwr+69Z4G3KA2hh+TrI/zL/pTxsH/SPd6z8cXm9p9m5P4864fFNnIvJdVDftZbMB+gc1/oE2kiR0+2CtdPtUl/L0dKFio927yustcJzErvZEu6y6DBFChJy0OlSTpxyWjizDMxGqpcvyt6O/ZTHYtFlJeVlazWfgK2niThuyAtQutZ8nuaavjsbXlx6MDKONzOJ/h8Z1VZfKbPTX6qIIefjdQy208j088L6AVLM+aS0ZXdnihEdtklYzDv+5XuA9qZcN3A4MjqGoLWaVm
 7Tr66o62
 32wv4Fq/3+IIZgfKi/aJ4qwUYo63SkqaDY0jA2W3kvZJ2Gfw+jSiYXOLWe8I1udHV22owiv4SZ7McaC5A36AaSeLpZMJQ1gCDviLEG0+9tNvZ5/1MrxqqOq1TejsEBbkUsVFc0xposMKrmiovpEgkPFd2Rs3EESDU1bdGCgcdtAcAaSDDcQ40ceipmZ/2OrLu34+t15goy5fUcXzfC1eOMPf8KlxfdVsstZCVDiWkqddvCcn+8FTz/l0ZmManoTAcJIxce1Kz2gyWcwUPm2G33Oa8TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 20:43:12 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> When using the temporal auto-tuning algorithm, the effective size quota
> becomes zero once the goal is [over-]achieved.
> 
> In this situation, damos_adjust_quota() still calculates
> quota->min_score for it.  However, this min_score will not be used in
> this window, because in damon_do_apply_schemes(), damos_quota_is_full()
> will always returns true, preventing the scheme from being applied to
> any region.
> 
> Therefore, add a short circuit for temporal-goal algorithm schemes to
> early return from damos_adjust_quota() before calculating min_score.

Nice catch.  Makes sense to me.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> 
> I tested with virtme-ng + perf on a Proactive Memory Reclaim workload;
> within measurement noise (~3%), no measurable difference was observed.
> 
> The purpose of this patch is to reduce unnecessary operations
> (calculating min_score).  But, I'd like to know if this patch needs to
> demonstrate that it provides better performance before it's merged.

This function is supposed to be not performance critical.  I expect performance
difference would be shown only in some setups that I didn't imagine.

But the change is small and makes sense.  I wouldn't mind having no performance
measurement for this small change.

> 
> ---
>  mm/damon/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index ce8c6f99106e..fdcea989f0e0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3320,6 +3320,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  
>  	if (!c->ops.get_scheme_score)
>  		return;
> +	if (quota->esz == 0)
> +		return;

Direct zero esz comparison looks redundant and incomplete.  It doesn't catch
the case that <min_region_sz remaining quota case.  Let's use
damos_quota_is_full() instead.  Also, let's do the check before the
get_scheme_score check.  If quota is already full, get_scheme_score check also
makes no sense.

>  
>  	/* Fill up the score histogram */
>  	memset(c->regions_score_histogram, 0,
> -- 
> 2.55.0


Thanks,
SJ


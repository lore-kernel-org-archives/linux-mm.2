Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4605C606A334
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EwQHu0Ih
Received: by kanga.kvack.org (Postfix)
	id 4F74C6B05C1; Sun, 15 Nov 2026 15:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4816F6B05C3; Sun, 15 Nov 2026 15:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398C06B05C4; Sun, 15 Nov 2026 15:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBB06B05C1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:42:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87F1E4080A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:42:43 +0000 (UTC)
X-FDA: 85438527006.19.EE1FBCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E10211C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:42:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwQHu0Ih;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775362;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+fnsq6nNb+xpVBHQjdCD20xN1KOTbGtm9ZI5ilhmXQ=;
	b=cFaXxlzgLFmkHn2Qlrne0uLKu9femxO3XpSSiBGl1rXXKbeVtUl6vDvp3oYu4FU0M66M6s
	/wreaRUncralajmZO0IPTIkITDOcgV/ZK2H/hmbrLqYu3BxoGNz5qS1b8Twh2tz8Mc4v/r
	4yjUkXoFamKfWwQhl7BN9Kv95ogSKYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775362;
	b=tUqCaFmw5evWBNuXJIJoMA/8yB3FKUMylDdLj/bEQFttrjWrUr944nmMH134T18Rwb4RWz
	vl0O5Xm/ajmUxpBlVUF4SXdzQut7amG6+KKYX/KHjlB2sEiQsdk3YCGMWqykwdUhsGvf3m
	PEpbzGBF8oQNdPHx9sQCa8HYMaRgIFk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwQHu0Ih;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D4543E40;
	Sun, 15 Nov 2026 20:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9191F000C4;
	Sun, 15 Nov 2026 20:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775361;
	bh=J+fnsq6nNb+xpVBHQjdCD20xN1KOTbGtm9ZI5ilhmXQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EwQHu0Ihzk7asjxuCCKyAoub+Dl6eWnzX31BDUHVHZ/uc+OYXFXix3OqRDrJHVw4c
	 BVdZ5ugXhFLRXY7BXa1mJHZbdadQZZYw6BJq/uyXkk7n78edKN5+RvU+01o7PBTZfk
	 eJNcA4+dFSKSW7DyemrVUplsg+dlRIwbI3s3frM9XunF9DjPZvwT6b4BMvgbfHNghq
	 EBJNva0C1AefbYTjROMQDhnTX7bX3bWwRrCKODeiyROj33Ys6x7Fokp6tfwVVkyXlL
	 o2DIfBuuywkTxmfx4BbRUZBT+6zrTJlrLvcFxD0kw9TyHRS1+PgfyEd0YA425o56Mr
	 Xs/YEEhJovOqw==
Message-ID: <sashiko-outbox-215851@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 03/27] mm/damon/core: introduce
 damon_submit_report()
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-4-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:42:40 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ccdg95yrcp3u8crb5ysxc8ubf8i3rk5s
X-Rspamd-Queue-Id: E10211C0004
X-Rspam-User: 
X-HE-Tag: 1794775361-847427
X-HE-Meta: U2FsdGVkX1+RydYYKIZeidNsoQBnHj1Zs3o8CRtI6JFzZ0FsU0+ZXO3vpBMbM+4eovaHSiNRntxJO5ecWyXvL0QNKr9gP064zZ8icexmS/uCXhD6ZAaTWJ6Fzs/ZbPrYrk2iP3KXclD9zfpgh/ACvAyJS6ZE4m5eNfv6mE6+Q3v1wY1s7sK+C4nRCrJOS3hP824YGCtO8l+JG/cF+hiTjBSth595XWAj2bJDNDxjvt3EMjC1Vbno5engeNKKe+fSdfvDmhqdHjIG6d9er0b4JZ3UJmWaDv8IusgTl8Qx0WvaJj0vrJfYNc1XlLSAHihI+HyMY2G+V2eCTa3QFrHyIHiGJqQCz6VSgSXaSL7FLUWCtHu2qy5hxfcC8Kw3+UCKB0QshDZIDs48rPxs0YOKfhqHoLUfQ9T/cc+A4Aed0eB90mYYfV1JvN0t1EUWOQyihnnvGCa0Ru0UwK+ry1TYeDaIPaMVuyovu63PHwTEqRC8pHsg4x6TWVK1NcnscZzc8cW2yY9Jh3e2tDFLdhr2DP8zW8iuAUqKWju8QZpOSL8qDkNZQhhM1b6wL2YbgHEBSI8VvW7GGwe2mkA1aoGUkofT5GdK3d9UUFcGagbJbEMNSHeFg9ftQqYYhmZux25Oaw4kLWdQkrGsc8TGY9BCUlykb59P6TyaxX+b6vwMs9nfHOgcabWALlcRIyFbwGQpyuHDrafITNiOu5/6b/Yu3f++s4JAxk4vu5+vsW+zX3rUikt4pHqMIMuPs5ZSi8M9iJJRp7d2xSItRRSlPqJnKU5ryZARNYmO7hoUgsAzZBEh5LSEXR/yfnNw1ExeZrWU7IEz5KNH7AQa4Xr4bT9uJ6FWb1eXfTHZg3rU9HQKHM+XyEmt7gWKCF3bMO9fRj7qHc8SJ7TqVQMnkSw9cLiGhOxtQDbKjyWqS/lchKr1hmG/0DP5q1TY5hl3AVO93tWnlrSXGme+oQUe6oEoPXZ
 9qxmMBjO
 iHMzSJz/47HSJJ/VMMLxFCYDEogt0zH0TBrIa2PTMxutACep2hSpw/R/yrH7F2lSfVxfLttakXDzSUPtY1uQn6XDNnvgYPMqG9DqK2Uuzyv5aPZ2M51XHz1e1JgGNczrLUY90j69xJUEzWbIJ/tM7F9iwbB7wmePf01jQdDwTRmm9xXEcifH5nUv7TXJ2FxZ1FWyRf69K3kCFYSBL65IRi14zReyyCPFrdcfj9p3pm0/I+xvQ46hIau/YdnrUZUMWD8niZRlDIcoPaWAFzjyfL9vflL9btm311DTR0gG6Sy6chQ9NB7FHfQN1vGtTO3VOvhhBCL2FYAPFbbBGPkdSPzqPZd9c65ThQ7WNLWDO3JdRP/a9G3es1cy6f89DUsrfPLVlSSki8kBlLDotGXQujGpbGdssqQ++nET5oEZfJjBNxKkv3Co6M/TKqUCacsXswmh+JiZFbbQIYPP/4Mur2bJ2xDU2ThJo1nw9YNc2DGh90yasuMCipwE8Py/VSGNiKZqeQyMP8t6W/FvKoigkzsW2IutrCFaUXogTk4gDn2JcaYk9XgtWkubE1fA2OUPTLXId7QVAyW81cZVJwsKGgMovzJTW+u9RejZ5Pgi9Qo33585V/WUHzJeANBV0nlaicDz0
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
- [High] mm/damon/core: out-of-bounds write in damon_submit_report() on
  queue wrap
- [Low] mm/damon/core: missing Return section in damon_submit_report()
  kernel-doc
--

commit bcb278386fb51304d0c224892db9744bf9e27c8f
Author: SJ Park <sj@kernel.org>

mm/damon/core: introduce damon_submit_report()

This commit adds damon_submit_report() to enqueue a data attribute report
into the DAMON internal report queue using CAS-based try-locking.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3f87a7eec442e..06b85d00e38d9 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2353,6 +2353,36 @@ struct damon_report_queue {
> =20
>  struct damon_report_queue damon_report_queue;
> =20
> +/**
> + * damon_submit_report() - Enqueue a given report to DAMON internal buff=
er.
> + * @report:	The report to enqueue.
> + *
> + * This function can be called from any context including the NMI contex=
t.
> + */
> +int damon_submit_report(struct damon_report *report)

[Severity: Low]
This isn't a bug, but the kernel-doc comment for damon_submit_report() is
missing a Return: section describing the 0 and -EBUSY return values, which
triggers a kernel-doc warning under W=3D2 builds.

> +{
> +	struct damon_report_queue *queue;
> +	int lock_old_val;
> +	unsigned int tail;
> +
> +	queue =3D &damon_report_queue;
> +	report->jiffies =3D jiffies;
> +	lock_old_val =3D atomic_cmpxchg(&queue->lock, 0, 1);
> +	if (lock_old_val)
> +		return -EBUSY;
> +
> +	tail =3D queue->tail;
> +	if (tail =3D=3D queue->size)
> +		tail =3D 0;
> +	queue->reports[tail] =3D *report;
> +	queue->tail++;

[Severity: High]
Does this write out of bounds of queue->reports[] after the queue wraps?

When queue->tail reaches queue->size, only the local variable tail is
reset to 0 while queue->tail++ increments queue->tail to queue->size + 1.
Every subsequent submission then bypasses the tail =3D=3D queue->size check
and writes past the end of the queue->reports heap array, corrupting
adjacent slab memory.  Updating queue->tail =3D tail + 1 would wrap the
index properly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D3


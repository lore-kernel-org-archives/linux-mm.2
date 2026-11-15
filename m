Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F561606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGCaiakI
Received: by kanga.kvack.org (Postfix)
	id 395BB6B05B8; Sun, 15 Nov 2026 15:41:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D036B05B9; Sun, 15 Nov 2026 15:41:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA7F6B05BB; Sun, 15 Nov 2026 15:41:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF486B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:41:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A6A21205B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:37 +0000 (UTC)
X-FDA: 85438524234.08.5C1AA27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE57C140002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGCaiakI;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775296;
	b=GJaZiZw31nWTfsMa7sdTJr8zQ0KBL4NQOiiV5kOD83fPGhN5yf75m2+DDs8IRHBNwvjU2O
	1N6c2mlVfCUG5sFHbDv+9gWLrMzlzvXEotHTm1YPO/Qt/JLqwYM4APVrx30slWe390yiQe
	1s6eRDYkTki8nWWe+x8O9Z0NfDTcTyM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGCaiakI;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775296;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4vAPhP/V1Bp8qYGqnFchGNpQrdWi5lSaW3Lmn/+Q0E=;
	b=k1W1UjzWFdH8nohcr2hS9sFkQvkeSfvGr9rsCMAexeqOChLoe5tNpbhzkgYbJxxhJUJSsG
	9u++fqICJKKrhHmzR903na/SpFpCWsoAYpke3QAECjITBl3zT5p94lJdc/GTFSjv5iHfHA
	t0s5htLT5ekfKUMz+IOZRpn94WbnGDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 299D544831;
	Sun, 15 Nov 2026 20:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE87D1F000C4;
	Sun, 15 Nov 2026 20:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775295;
	bh=Q4vAPhP/V1Bp8qYGqnFchGNpQrdWi5lSaW3Lmn/+Q0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eGCaiakIfl1kezaf+/ujmceYlD7vtcZ0Ev8DWvP5MSBcLVTnKerZQofuwmGY7/LLa
	 2a0NuYDoXGKY72Uc+2yah1dVO5COdg6izZ5D2YrwEZwgtytMjy4cFYXjNdS/jx8zUp
	 Axp11qCyNEX1is3jALAC5fo5xhtgMCT1l413hb+tqmR7LteRoVhvzKWCuFYfinj0JU
	 +5PyZR1DHVG5vNz3bvhjZ52ZODUAgWO+GyaKh2uprvy9vk9/+dBBCS7JRFea8SXNC5
	 hHzfvu1hb3HmEtr+LSuXuGVjCgqKSMHQduj6w7ksO544b9HdqOI4xWUWbuhHV0iUv3
	 7Lt/WPL5eo5VA==
Message-ID: <sashiko-outbox-215850@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 14/27] mm/damon/paddr: support REPORT_MADE type
 probe filter
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-15-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-15-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:41:34 +0000
X-Stat-Signature: yirjhxgrhih8ypey4c8549m9i3nsxssa
X-Rspamd-Queue-Id: DE57C140002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794775295-160415
X-HE-Meta: U2FsdGVkX19ltmXX0GUCcEZb8WRhBKn2DP7QBxL9KZKw90Cu3iocUomo+QMj24TdWx2C0rQ4DYd6mM7CmywcuuXbNuTCPPXxfVdEsww1Msmi7aGBNcdOFcoAgQK4oLHR+bXI+9zjuHhdyRTOWOHUFZ26u47Pi7GcmhHfHOAMfvwQnRusby5fwndMzTC0s57chZChYBzq7QtpeCp7ndRBumrBZOp445A+PZhZN9fe9J1ZwH2nsy2umb9BEOa4foTbZFmYAc19a3VSzOK8kcmNvTl8PI/zhqgGT4wDmZ993XGnwz0CtvmmCGXAba3dEfUfuv5hZSTVNBrIDT1SLUXj3JG+xaHWRt15QAZ9kw99NIaOXythAPCSfmCrXIdZQ6DA9B17xzOO05RubQgur4BZsdQOO40n7NugUIhDJrWiFpbsVd9CwhWZhFbjP+HM4OS5sg4NvkBq+tLDeRn4aRcBV0o8/2MGTSphFY88Vd1gWWjg6otcqF4d7CyXsGOFDWjNuMmc+FJpxl/Ix8T8u0wLcMxZ1RDf23eQpgO28jXFcqYiAhaAJp68XbpEb4/H7OfQplHy3W0YKwhntweShg5LYuvdu5VT12QiZ/kXvzf9XfHPYYja3ZTlEHA2xt4Us0BceJO07BE3lZC6qCHPhlHuzMKN1Hh5Rbixw6Kk+1/DXET5JypYwipv9D+vqsk6Foj+KSM6o+OJ+n4YD4GRRrksTIb4EhMmgy8FJY/tHImypAhpRvQknokhpw3f10t5iYhKXWHRoFA9+w1liu3yLJO9stfST4w/FZ0AMMQXw1PBuLwGdnopm639BLQL4GMB2r2cXYu1dFPFZuqCltyVBAALdVV2xDdGfGGBDewN9WUAUotLMufBREFk3Itoi4a4KwQu9C+ZIDi1MpswLrC5Qq2CYc+xWWqNHR0Eg7fMcgxuWhEBxvEfHHFLb+kd4kdKiULeDDFG+PpLUQ7p2PUc+ey
 WwU4/U5E
 F5NoYq0QOgjiZX/YKx9CzYc4Fw+PqRdBpN4WNCY9CY6nDYJWXaE1hiuf1GhWIJH8AptRHEwi9YCdBC+6CZnZ5e6MRtuuhO1V5b20DY1AB5fcv9VQqqzWk86TNm5z4TI+FKD0SoifCP0HrkhJzWXN+5RtCjFirQa3SFcFMx9Mp7YxTzczi6/pZw0JEih22xnCmZKz0kExPAXKylGUJGJRl5SSSL0t72T+QvvkgnNlE4C+rSjX9hsi/WcQLwBvm7POWsGBfwNFOv7r0Sxfio6iAJS/Pl64+ztwtJCTkJV1TMsm8ZylaDAU/LQHR2e0F/FqkflDhMjqI2CgzxVyTxPPgrcI2RRFqKp81DD0uIDlehbnusQIZKbH0pYScD6g0rjJ2bJ7+hCagL9T+T3lx8QzaDc+W3D+Gp1bOiSs0QIybPVSO+/YZeA+SXgVQKd5UUw6OlIs6k4Sti/1viijqUMeWiEs09OnwqBwlWBRSYPdWcHTkMuqGUB3WCMd8/jlrQiXS85QJ7r4/+AY1YlxYL/339fgJ0GrSRk6uwzYdl6j9IpqsmkXPbjbsM0xMnhtsjtOQrvKlfKA8KGCdhNyyjwdHUM8dgAaPsIhP2k64UswOkJ6Nb5Fyk0mVn16ZR0EcMQOX/1I6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm/damon: out-of-bounds and uninitialized read in
  damon_report_exist()
- [Medium] mm/damon: phys_addr_t truncation and unit mismatch in
  damon_pa_filter_match()
- [Medium] mm/damon: uninitialized filter->report_type in
  damon_pa_filter_match()
--

commit db7c0b8660ac4e99fdce33921b7535218eaa4dc6
Author: SJ Park <sj@kernel.org>

mm/damon/paddr: support REPORT_MADE type probe filter

This commit adds support for the DAMON_FILTER_TYPE_REPORT_MADE probe
filter in the physical address space operation set by querying
damon_report_exist() over the last sampling interval.

> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5b773012a8764..04e95047f8cea 100644
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

[Severity: Medium]
Can assigning pa and pa + 1 into addr_range truncate 64-bit physical
addresses and miss reports when ctx->addr_unit > 1?

struct damon_addr_range defines start and end as unsigned long, so on
32-bit PAE/LPAE systems where phys_addr_t is 64-bit, physical addresses
at or above 4 GiB lose their upper 32 bits (and pa + 1 wraps to 0 when
the low 32 bits are 0xffffffff).  In addition, when ctx->addr_unit > 1,
pa is aligned to ctx->addr_unit, so setting addr_range.end =3D pa + 1 only
checks the first byte of the sampled unit instead of [pa, pa +
ctx->addr_unit).

> +		matched =3D damon_report_exist(filter->report_type, &addr_range,
> +				jiffies -
> +				usecs_to_jiffies(ctx->attrs.sample_interval));
> +		break;

[Severity: High]
Does calling damon_report_exist() read uninitialized or out-of-bounds
elements from damon_report_queue.reports?

In damon_submit_report(), the report is written at queue->reports[tail]
and queue->tail is then incremented, so queue->tail points to the next
slot to be written and is never wrapped when it reaches queue->size:

mm/damon/core.c:damon_submit_report() {
    ...
	tail =3D queue->tail;
	if (tail =3D=3D queue->size)
		tail =3D 0;
	queue->reports[tail] =3D *report;
	queue->tail++;
    ...
}

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

Because damon_report_exist() indexes queue->reports[idx] at queue->tail
before decrementing idx, it reads uninitialized heap memory on the first
iteration while 1 <=3D nr_reports < queue->size (and never inspects index
0), and reads out of bounds at queue->reports[queue->size] and beyond once
queue->size reports have been submitted.

[Severity: Medium]
Can filter->report_type be uninitialized here when a new
DAMON_FILTER_TYPE_REPORT_MADE filter is added via damon_commit_ctx()?

damon_new_filter() allocates struct damon_filter with kmalloc_obj()
without zeroing the union, and when damon_commit_filters() creates a new
filter it only copies union members for DAMON_FILTER_TYPE_MEMCG and
DAMON_FILTER_TYPE_HUGEPAGE_SIZE:

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
			if (src_filter->range_max < src_filter->range_min) {
				damon_destroy_filter(new_filter);
				return -EINVAL;
			}
			new_filter->range_min =3D src_filter->range_min;
			new_filter->range_max =3D src_filter->range_max;
			break;
		default:
			break;
		}
    ...
}

As a result, new_filter->report_type retains uninitialized slab bytes
when damon_pa_filter_match() passes it to damon_report_exist().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D14


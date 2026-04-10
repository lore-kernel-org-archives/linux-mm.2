Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D643F36B96
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 00:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30596B0088; Thu,  9 Apr 2026 20:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE18C6B0089; Thu,  9 Apr 2026 20:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6E26B008A; Thu,  9 Apr 2026 20:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9D5C6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:02:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E82B16029E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:02:05 +0000 (UTC)
X-FDA: 84640693410.07.7966FF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A986FA0012
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:02:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7mfx3hN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775779323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8e13kivJWqmaumC0+mttXXxjbuPTtW5l7WW7hw+9DZw=;
	b=KcC2KjYo6VNDQRldv+1ndr9iZXYkOW9S9ULduP/GxjPHcRIIH0JA1yKdkxYyNHKWP90QWQ
	lTqxCKDjrXOCY2N0DkRircrfnYeuSBwMR/Wk1RVNVDgkj1xkJ3vxoQU487yKZUzg5KjJt/
	ecUIvt4TkvTZMpYy7tMX0NBQywQwBpg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7mfx3hN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775779323; a=rsa-sha256;
	cv=none;
	b=5U4Bj1i8BL4tD2rYzwwHn0B9e9/WmHsx97KDZ6otG5wcdRrPKP48g1awgH9JRebNSkGKYx
	vzzSJ3hnqoQp1iCCkRD2kuNWeVhoL7aBSQ6V2f5QiUOfifDjPafhXdBPmpg5YsP/ipchwO
	E3YhSVIWJZ+YcJ6JP2A5AfYfq4j9anU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 641BF4199E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DFAC2BC87;
	Fri, 10 Apr 2026 00:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775779322;
	bh=ez6gdXVL+QxicuQvdpa4+woumc6vz5Jo3YbeIe0Hkns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7mfx3hNjHdVJNOz5K5rMiV/3plQogbP5dmDBvh2MRoN0as+hizLkAuTR5rzRpEw7
	 U08YAVytBQzCab25higNwt8+8oNX0kORcwq8q9zigjFAsHAN3LFz3sv++Pbzqmwjsd
	 Ljop0zy++OCzeqR6rt02L3oXEwlW6Qq/CMyzjoCN9AmtyzUUNxwZ5UAZo9WcgNVUjh
	 ttcTjb6sOjYjrJ9CgXhRD00sNm8l3m/rC2ZsflqAliXo3sbmC95vSVfMi9oSeUdk2P
	 5NQzpXwufmra6vv8zO1G0AopkGCsY5xqXnv67X5KuusRm0aOV+2s73yTtIuJuG+5Hn
	 TshuK4YARUWUA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 02/11] mm/damon/core: merge quota-sliced regions back
Date: Thu,  9 Apr 2026 17:01:54 -0700
Message-ID: <20260410000154.77600-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A986FA0012
X-Stat-Signature: jxoywoh84difnuzs8rqgypx3yoxdn157
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775779323-836476
X-HE-Meta: U2FsdGVkX18yMmWj0qBkgetnSbf0yvSCAGXkHISUgH79vKK3rodUbBSfF1wj2hKeefWamJTFCLCxDHCirCcIOPuSuEUuFSn1v7RreXgOxkNc59y+lRV2qUMECOgokyuFR0zUNFN2XoPXoQEEuc4yS9stcPutOmbanmDoDQR+DI99W91YeWhjD8GBOLLinjCCGIY/t27p2k76bbUrvreJcWe59apU3wGN8I1TnjpjytiQPSHtZZD2x/9BYQGBFXulR5bTOeR48hARFCOP26hxyA2JhTvOZ/Y6dL8NzxffrfZnobNvlTKrtM0YqTn3e282ShreQCHQfdjsO+2/GP6EuGmAQSGuMsfCduZqPHhbumyqTAkCJjvp5ASTctKviHngtAZCcb72z9H/VsCIbSpHmwWT0ucGjXKMReR3hXwtLO0UI3eanEQ95LFJDMmNE0hbxRRjoP8b2hd82FI1NUYoLiM1C1x8gqDwaEx95ENVeYYbJ8T9tc/zWGn4mihTk3bj/+agRYGWcb5lcpvl7NNhkf3p9yvBRfqLGTUBh73ETkCnfohbfLfrPrJ2NhE7sVvAmWS7PMc/XWBBP73tKRS/LTfrpRZ/17ztwloPnK3g4Srty+O7iqj+t+Y19j1JsfwxyBO4Fr3W0gXCLojUNWnjGCoj4pHJxTcr4c6NsVW4yPnuA7v3I4i+4ID4YerEnKx/jp2zC0ndKS0i0ABndNdgczQdJqnF5rCmsFg7dbKpdNhIrJ8a8o7FnUkeK0izQQ0pfNkccdlkdkhrfR9jJFle2KP8NuxvUQKVWCmNF7UvI4nxUdg+w8u4Li7GTUVorMspTJX3EvcjV4GIsc77NyDyAE+k1ZRdR73zOdYkHkC5D+W9HyxxuSFhCz/CZSLHyPifF7R3ZzBjisUz9o5FPMJH5mUsWvz5BeBrQ8qDVvxcrfJxyxsAAeXdE0la2UepXKVYRyq67any6WY9kETKD0q
 bxZ5XN0H
 BiBJix3Ir6q60vUKCkqWQHAXDVdBHXp8nyfwRZ7mGWsZHgbxeVkEXMcl0oeAx8X/rL0iMB5ZKxbO5soYPUiD0ov22D4mwCMBHKTftec0Sfj3w9xHAD6IDXrqPoPDYGbxMNqnmYiqw/7gSsNwCVFBB+23cKAq1/s+kcJx1dfSqtZBE63gUExeoJSzkxJ9pHw3JnWbphQhxpAg/eQS7aY4Ckf3CLIgMBZlOf+PlMHLQ1YMpiOxafQS5AQfaxUW2XbKvP25iLsYIEnuAEAIiKLTtA6Vhh4Gct6ut0pBX+wzPjqF5Ob9DLIRGqZUJQCQ/KT2bv/2L+tjpw9nf2gwiBnFMS2ZL4405eUJmRbP+ctqgTtrcR1cBVqNw90fJ4Uggh5nBspGy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found clear issues.  I will fix those in the next revision.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260409142148.60652-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit e2cfd0aa5e77f600726ed8baabf9eb6c27b3546d
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: merge quota-sliced regions back
> 
> This commit modifies the DAMON core to merge back regions that were sliced
> due to quota limits during scheme application. This aims to prevent the total
> number of regions from exceeding the user-defined max_nr_regions limit.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2158,6 +2158,33 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> [ ... ]
> > +static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
> > +{
> > +	struct damon_region *r, *next, *orig_region = NULL;
> > +	unsigned long orig_end_addr;
> > +
> > +	damon_for_each_region_safe(r, next, t) {
> 
> Since damon_for_each_region_safe uses list_for_each_entry_safe, it will cache
> the next element before executing the loop body. If damon_do_apply_schemes
> splits the region r by inserting a new slice immediately after r, won't the
> loop advance to the cached next element and skip evaluating the newly inserted
> slice?
> 
> If the newly inserted slice is bypassed, it looks like the merge-back logic
> below would become dead code for that slice, leaving the slice stranded in
> the list and defeating the patch's goal of avoiding max_nr_regions violations.

That's correct.  I will fix this on the next revision.

> 
> > +		/*
> > +		 * damon_do_apply_schemes() split the region if applying the
> > +		 * action to the whole region can make quota exceeded.  That
> > +		 * split can result in DAMON snapshot having more than
> > +		 * max_nr_regions regions.
> > +		 *
> > +		 * Merge back the sliced regions to the original region, as
> > +		 * soon as the schemes-handling of the slice is completed.
> > +		 */
> > +		if (!orig_region || orig_end_addr <= r->ar.start) {
> > +			orig_region = r;
> > +			orig_end_addr = r->ar.end;
> > +		}
> > +		damon_do_apply_schemes(c, t, r);
> > +		if (r == orig_region)
> > +			continue;
> > +		orig_region->ar.end = r->ar.end;
> > +		damon_destroy_region(r, t);
> 
> Does this merge-back logic permanently destroy the monitoring state of the
> unapplied portion of the region?
> 
> When damon_do_apply_schemes applies a scheme to the first part of a region,
> its state might be modified (for example, resetting its age). The second part
> of the region that was split off and skipped due to quota limits is supposed
> to retain its original state.
> 
> By destroying the unapplied slice and extending the applied region's end
> address, the unapplied slice's original state appears to be clobbered by the
> applied slice's modified state. Could this prevent the unapplied memory from
> meeting thresholds like min_age in subsequent intervals?

Again, good finding.  I will fix this in the next revision.

> 
> > +	}
> > +}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260409142148.60652-3-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260409142148.60652-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail


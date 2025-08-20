Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B57CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 21:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA926B00BF; Wed, 20 Aug 2025 17:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2056B00C0; Wed, 20 Aug 2025 17:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8026B00C1; Wed, 20 Aug 2025 17:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8F4D6B00BF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:56:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7117A1D9AFF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:56:20 +0000 (UTC)
X-FDA: 83798494920.26.385BA8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A05BA40004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:56:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0OwBUBb;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755726977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCh0XMtqTVCz2EddUyGRNpS2ishe3yqNnIEomDp/Xjg=;
	b=GhgGgxqgGQs4HjJvm0khcZnunRtJ8947GRc1fPk1519tzxX+qXNzEUwMmwnNZ7+Zr6NQd+
	gf72zwggZwY3HOoF2+7EbdEZcfgPATzKsymocdn+5jTpH+hBtrTdawMS7LUAqqKL0TEfpQ
	pFGKxtRaLKWOMmIQ9s/ZJGtckMXyfIw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0OwBUBb;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755726978; a=rsa-sha256;
	cv=none;
	b=epZAAPTRnQh3LfEJEy8/LF7ZspY3VR+jEBvHpaMOxjbZ2Fvt6d8i2ADOEUAIsUrBIykVUL
	8p0/OAvoRNEl1//ecsGADtqmoIzI0Lid6PzVGOEqH5Syz098cWWnPGwBy7Rd5KFkynriwd
	szhq4MRwjfFZN/uLKqqH+CIJE8uuNPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E78B46783;
	Wed, 20 Aug 2025 21:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2525C4CEE7;
	Wed, 20 Aug 2025 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755726976;
	bh=TbHr4WxSbmucCqnfKSp7TV8ALsL0B0uMK0/BeRbY3s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0OwBUBbLZZamDwIFYIdMUZS8wjPI0S+YnBUD2MQ3Jp1PCHp9wrg2DDZJrdl6dDgR
	 6D2b10qvk1UChGOlKLPVbhZ2LYZCXgfddRWu2Pfg4TfARGtiflrBmKzp6vYgk7P3S5
	 H+eVtRjf9mnEBfwvaqES28EEB90iI4QBNU4vh2xlTBX8u600W6tKyyNuNoiKxfznaW
	 1U9uPtjSG37awMn1XHOkwjZPWpbVW6Ufw3MsCJhnyj6al08Nr/TibZDggumyS7VCIx
	 V6rw1zxNwEyp8aHHxWMN345LvAfY9a6kSd41FbZoye68uY89MA53S6UdJho5sO8GLc
	 EDP80sD0Y0rcg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH mm-next v2 11/12] mm/damon: add damon_ctx->min_region
Date: Wed, 20 Aug 2025 14:56:12 -0700
Message-Id: <20250820215612.86678-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250820080623.3799131-12-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4wef7t1fub5o89zk8rakguukmiy45cwk
X-Rspam-User: 
X-Rspamd-Queue-Id: A05BA40004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755726977-984173
X-HE-Meta: U2FsdGVkX19n9CW6rEyG0+lEJuIZJvL1chvACYmxrKRC4jqmy2+lRp/QH/5einz99R2/CWQzjCLJNuknngmWCnBgxKCSuE5hc47ajSmtg6XKFJaN3NggBvKaCRNzLoAi7y7bcG7MA9OQ7Ap2VEPudUrjcoBBgtymvvvwuLIcnHtzXsj9mZEDDRcYD9H6DdG5nBv4PAzqKxG9gooiz+i7T0fokRUXdSI0r8j30LCEcB54Bb7qs4dSPWVrhVW3XnoO7zZUaGNVXl/qgJwi2P0hmXUQhYp6T+IJjCkoAfiLUZL5e2EXxVK+qREKh6Ed9h9ps2QEWnuOrQGAs4ttacCJQiZaFMKRm7OuIKDhP5yna86KLVXkeHvAOMmNvBJXP34gtNwdtRboNHZd3Ynx5Ub/rGReZJgkrag0C2g5URdZGAX0fc2cIKj8visFn1XVGUgWtkmXc4C+/I63kWJiGrM++M7L13uUMskvJFNs4San0vZi3QWpuV+IF24LHTPcAM+PpM+IcX/t5Vo5Cggmz+eP+NaUo3QyV/KUxG1Vkd5Ow5FI6JVMnK77jbBwAqUlGD5qrTNd13tcbJ/cfycKLZbBzXKru3rANxRJ3SL3e0lT5XDMLbtbCPtcVs+CEW9LKuvV0BDj7UqcVZRgREaFiBDZn3PZWRN9PgokOPqllqlD4YGpt1GVu1cSm39ukyS9hoHg5xwN2icWJs6KzJhkTc3LWggcghSbniFiM/P8DSZNZ3O930rby3NaEjBTWgaTT7y4YDRoRRe5Mu4dxLL/W4JfbUS26YeLmUrvFLXHCzgnbl3LwioiofAxxgZUQTnUMhfTBqw3Gl4d4KvkZA4WgeTtQgIMu8Ai3TCAEP26Ao/bVi/srPwBf6yhVelErTLv+WZfuo3AopYSTVh/bNgJS+wyaqTTtK3OqIC78463aSvyzvxXPYtn/6xYYnAyEiozAbe/pUjZWtvstebFYj3qF+g
 EwkyYDcs
 26aHXU+bJptJDv990ak5E+K7GixX/+xr1RFCS7aPa535FoypY+q07RAbZ0U8ENCfPICG7nszgAbNG8h8uhCtCHJF7PLBVPxU/HRaVVVQtwejY3GPgT7UCdLfRjy/4r8o9IgoqWhGd458lHaf7oq8ENNZXrvPMDfYiMHYRIUc3j3k5IaST1WCmfpKcL7mnQxVNMIKzy7Y3h1WH7W6bBe8djLFJxk0Du2sX6u65e1w0sBdm9gxMkESYUdylvuIf+Sesixwbaj9ZjtNv4MVQOzXyTfx3uV/TDxV8sfrnuDDImD2t4HtZou0vkKJCZJVkW/SRD1FIQh6LE21k4pGcXQm5yne5LEPtf0PxxrDyaXkJZCucW7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 16:06:21 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> bytes and cause data alignment issues[1].
> 
> Add damon_ctx->min_region to change DAMON_MIN_REGION from a global
> macro value to per-context variable.
> 
> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  include/linux/damon.h        |  4 ++-
>  mm/damon/core.c              | 68 ++++++++++++++++++++----------------
>  mm/damon/sysfs.c             |  8 +++--
>  mm/damon/tests/core-kunit.h  | 16 ++++-----
>  mm/damon/tests/vaddr-kunit.h |  2 +-
>  mm/damon/vaddr.c             |  2 +-
>  6 files changed, 56 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6fa52f7495d9..bebd791f37f1 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -747,6 +747,7 @@ struct damon_attrs {
>   *
>   * @ops:	Set of monitoring operations for given use cases.
>   * @addr_unit:	Scale factor for core to ops address conversion.
> + * @min_region:		Minimum Region Size.

The name feels not very clear to me.  What about min_sz_region?  Also, the
description can be like more general sentence, e.g., 'Minimum region size.'

Apparently the name came from DAMON_MIN_REGION, which I named.  Let's blame SJ
of 2021 :)  Let's not change DAMON_MIN_REGION's name, though.  Maybe such a
change is not really necessary for now.

I was thinking I gave a same comment to RFC v1, but I didn't.  Seems I forgot
sending a draft.  Sorry for late comment.

>   * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
>   * @schemes:		Head of schemes (&damos) list.
>   */
> @@ -789,6 +790,7 @@ struct damon_ctx {
>  
>  	struct damon_operations ops;
>  	unsigned long addr_unit;
> +	unsigned long min_region;
>  
>  	struct list_head adaptive_targets;
>  	struct list_head schemes;
> @@ -877,7 +879,7 @@ static inline void damon_insert_region(struct damon_region *r,
>  void damon_add_region(struct damon_region *r, struct damon_target *t);
>  void damon_destroy_region(struct damon_region *r, struct damon_target *t);
>  int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
> -		unsigned int nr_ranges);
> +		unsigned int nr_ranges, unsigned long min_region);
>  void damon_update_region_access_rate(struct damon_region *r, bool accessed,
>  		struct damon_attrs *attrs);
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8f8aa84953ac..980e271e42e9 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -208,7 +208,7 @@ static int damon_fill_regions_holes(struct damon_region *first,
>   * Return: 0 if success, or negative error code otherwise.
>   */
>  int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
> -		unsigned int nr_ranges)
> +		unsigned int nr_ranges, unsigned long min_region)
>  {
>  	struct damon_region *r, *next;
>  	unsigned int i;
> @@ -245,16 +245,16 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
>  			/* no region intersects with this range */
>  			newr = damon_new_region(
>  					ALIGN_DOWN(range->start,
> -						DAMON_MIN_REGION),
> -					ALIGN(range->end, DAMON_MIN_REGION));
> +						min_region),
> +					ALIGN(range->end, min_region));
>  			if (!newr)
>  				return -ENOMEM;
>  			damon_insert_region(newr, damon_prev_region(r), r, t);
>  		} else {
>  			/* resize intersecting regions to fit in this range */
>  			first->ar.start = ALIGN_DOWN(range->start,
> -					DAMON_MIN_REGION);
> -			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
> +					min_region);
> +			last->ar.end = ALIGN(range->end, min_region);
>  
>  			/* fill possible holes in the range */
>  			err = damon_fill_regions_holes(first, last, t);
> @@ -545,6 +545,7 @@ struct damon_ctx *damon_new_ctx(void)
>  	ctx->attrs.max_nr_regions = 1000;
>  
>  	ctx->addr_unit = 1;
> +	ctx->min_region = DAMON_MIN_REGION;
>  
>  	INIT_LIST_HEAD(&ctx->adaptive_targets);
>  	INIT_LIST_HEAD(&ctx->schemes);
> @@ -1127,8 +1128,8 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
>   *
>   * If @src has no region, @dst keeps current regions.
>   */
> -static int damon_commit_target_regions(
> -		struct damon_target *dst, struct damon_target *src)
> +static int damon_commit_target_regions(struct damon_target *dst,
> +		struct damon_target *src, unsigned long src_min_region)
>  {
>  	struct damon_region *src_region;
>  	struct damon_addr_range *ranges;
> @@ -1145,18 +1146,19 @@ static int damon_commit_target_regions(
>  	i = 0;
>  	damon_for_each_region(src_region, src)
>  		ranges[i++] = src_region->ar;
> -	err = damon_set_regions(dst, ranges, i);
> +	err = damon_set_regions(dst, ranges, i, src_min_region);
>  	kfree(ranges);
>  	return err;
>  }
>  
>  static int damon_commit_target(
>  		struct damon_target *dst, bool dst_has_pid,
> -		struct damon_target *src, bool src_has_pid)
> +		struct damon_target *src, bool src_has_pid,
> +		unsigned long src_min_region)
>  {
>  	int err;
>  
> -	err = damon_commit_target_regions(dst, src);
> +	err = damon_commit_target_regions(dst, src, src_min_region);
>  	if (err)
>  		return err;
>  	if (dst_has_pid)
> @@ -1178,7 +1180,8 @@ static int damon_commit_targets(
>  		if (src_target) {
>  			err = damon_commit_target(
>  					dst_target, damon_target_has_pid(dst),
> -					src_target, damon_target_has_pid(src));
> +					src_target, damon_target_has_pid(src),
> +					src->min_region);
>  			if (err)
>  				return err;
>  		} else {
> @@ -1201,7 +1204,8 @@ static int damon_commit_targets(
>  		if (!new_target)
>  			return -ENOMEM;
>  		err = damon_commit_target(new_target, false,
> -				src_target, damon_target_has_pid(src));
> +				src_target, damon_target_has_pid(src),
> +				src->min_region);
>  		if (err) {
>  			damon_destroy_target(new_target, NULL);
>  			return err;
> @@ -1248,6 +1252,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  	}
>  	dst->ops = src->ops;
>  	dst->addr_unit = src->addr_unit;
> +	dst->min_region = max(DAMON_MIN_REGION / dst->addr_unit, 1);

Can't we set this as src->min_region?

>  
>  	return 0;
>  }
> @@ -1280,8 +1285,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
>  
>  	if (ctx->attrs.min_nr_regions)
>  		sz /= ctx->attrs.min_nr_regions;
> -	if (sz < DAMON_MIN_REGION)
> -		sz = DAMON_MIN_REGION;
> +	if (sz < ctx->min_region)
> +		sz = ctx->min_region;
>  
>  	return sz;
>  }
> @@ -1641,8 +1646,9 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
>   *
>   * Return: true if the region should be entirely skipped, false otherwise.
>   */
> -static bool damos_skip_charged_region(struct damon_target *t,
> -		struct damon_region **rp, struct damos *s)
> +static bool damos_skip_charged_region(

The above line is not really required to be changed.  Let's keep it.

> +		struct damon_target *t, struct damon_region **rp,
> +		struct damos *s, unsigned long min_region)
>  {
>  	struct damon_region *r = *rp;
>  	struct damos_quota *quota = &s->quota;
> @@ -1664,11 +1670,11 @@ static bool damos_skip_charged_region(struct damon_target *t,
>  		if (quota->charge_addr_from && r->ar.start <
>  				quota->charge_addr_from) {
>  			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
> -					r->ar.start, DAMON_MIN_REGION);
> +					r->ar.start, min_region);
>  			if (!sz_to_skip) {
> -				if (damon_sz_region(r) <= DAMON_MIN_REGION)
> +				if (damon_sz_region(r) <= min_region)
>  					return true;
> -				sz_to_skip = DAMON_MIN_REGION;
> +				sz_to_skip = min_region;
>  			}
>  			damon_split_region_at(t, r, sz_to_skip);
>  			r = damon_next_region(r);
> @@ -1693,7 +1699,8 @@ static void damos_update_stat(struct damos *s,
>  }
>  
>  static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> -		struct damon_region *r, struct damos_filter *filter)
> +		struct damon_region *r, struct damos_filter *filter,
> +		unsigned long min_region)
>  {
>  	bool matched = false;
>  	struct damon_target *ti;
> @@ -1710,8 +1717,8 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
>  		matched = target_idx == filter->target_idx;
>  		break;
>  	case DAMOS_FILTER_TYPE_ADDR:
> -		start = ALIGN_DOWN(filter->addr_range.start, DAMON_MIN_REGION);
> -		end = ALIGN_DOWN(filter->addr_range.end, DAMON_MIN_REGION);
> +		start = ALIGN_DOWN(filter->addr_range.start, min_region);
> +		end = ALIGN_DOWN(filter->addr_range.end, min_region);
>  
>  		/* inside the range */
>  		if (start <= r->ar.start && r->ar.end <= end) {
> @@ -1747,7 +1754,7 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
>  
>  	s->core_filters_allowed = false;
>  	damos_for_each_filter(filter, s) {
> -		if (damos_filter_match(ctx, t, r, filter)) {
> +		if (damos_filter_match(ctx, t, r, filter, ctx->min_region)) {
>  			if (filter->allow)
>  				s->core_filters_allowed = true;
>  			return !filter->allow;
> @@ -1882,7 +1889,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
>  	if (c->ops.apply_scheme) {
>  		if (quota->esz && quota->charged_sz + sz > quota->esz) {
>  			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
> -					DAMON_MIN_REGION);
> +					c->min_region);
>  			if (!sz)
>  				goto update_stat;
>  			damon_split_region_at(t, r, sz);
> @@ -1930,7 +1937,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
>  		if (quota->esz && quota->charged_sz >= quota->esz)
>  			continue;
>  
> -		if (damos_skip_charged_region(t, &r, s))
> +		if (damos_skip_charged_region(t, &r, s, c->min_region))
>  			continue;
>  
>  		if (!damos_valid_target(c, t, r, s))
> @@ -2324,7 +2331,8 @@ static void damon_split_region_at(struct damon_target *t,
>  }
>  
>  /* Split every region in the given target into 'nr_subs' regions */
> -static void damon_split_regions_of(struct damon_target *t, int nr_subs)
> +static void damon_split_regions_of(struct damon_target *t,
> +		int nr_subs, unsigned long min_region)

Let's keep having nr_subs on the upper line.

>  {
>  	struct damon_region *r, *next;
>  	unsigned long sz_region, sz_sub = 0;
> @@ -2334,13 +2342,13 @@ static void damon_split_regions_of(struct damon_target *t, int nr_subs)
>  		sz_region = damon_sz_region(r);
>  
>  		for (i = 0; i < nr_subs - 1 &&
> -				sz_region > 2 * DAMON_MIN_REGION; i++) {
> +				sz_region > 2 * min_region; i++) {
>  			/*
>  			 * Randomly select size of left sub-region to be at
>  			 * least 10 percent and at most 90% of original region
>  			 */
>  			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
> -					sz_region / 10, DAMON_MIN_REGION);
> +					sz_region / 10, min_region);
>  			/* Do not allow blank region */
>  			if (sz_sub == 0 || sz_sub >= sz_region)
>  				continue;
> @@ -2380,7 +2388,7 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
>  		nr_subregions = 3;
>  
>  	damon_for_each_target(t, ctx)
> -		damon_split_regions_of(t, nr_subregions);
> +		damon_split_regions_of(t, nr_subregions, ctx->min_region);
>  
>  	last_nr_regions = nr_regions;
>  }
> @@ -2769,7 +2777,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
>  
>  	addr_range.start = *start;
>  	addr_range.end = *end;
> -	return damon_set_regions(t, &addr_range, 1);
> +	return damon_set_regions(t, &addr_range, 1, DAMON_MIN_REGION);
>  }
>  
>  /*
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 98bf15d403b2..840b3a73147a 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1329,7 +1329,8 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
>  }
>  
>  static int damon_sysfs_set_regions(struct damon_target *t,
> -		struct damon_sysfs_regions *sysfs_regions)
> +		struct damon_sysfs_regions *sysfs_regions,
> +		unsigned long min_region)
>  {
>  	struct damon_addr_range *ranges = kmalloc_array(sysfs_regions->nr,
>  			sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
> @@ -1351,7 +1352,7 @@ static int damon_sysfs_set_regions(struct damon_target *t,
>  		if (ranges[i - 1].end > ranges[i].start)
>  			goto out;
>  	}
> -	err = damon_set_regions(t, ranges, sysfs_regions->nr);
> +	err = damon_set_regions(t, ranges, sysfs_regions->nr, min_region);
>  out:
>  	kfree(ranges);
>  	return err;
> @@ -1372,7 +1373,7 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
>  			/* caller will destroy targets */
>  			return -EINVAL;
>  	}
> -	return damon_sysfs_set_regions(t, sys_target->regions);
> +	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_region);
>  }
>  
>  static int damon_sysfs_add_targets(struct damon_ctx *ctx,
> @@ -1430,6 +1431,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
>  	if (err)
>  		return err;
>  	ctx->addr_unit = sys_ctx->addr_unit;
> +	ctx->min_region = max(DAMON_MIN_REGION / ctx->addr_unit, 1);
>  	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
>  	if (err)
>  		return err;
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 5f5dc9db2e90..a7fa078da405 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -230,14 +230,14 @@ static void damon_test_split_regions_of(struct kunit *test)
>  	t = damon_new_target();
>  	r = damon_new_region(0, 22);
>  	damon_add_region(r, t);
> -	damon_split_regions_of(t, 2);
> +	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
>  	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
>  	damon_free_target(t);
>  
>  	t = damon_new_target();
>  	r = damon_new_region(0, 220);
>  	damon_add_region(r, t);
> -	damon_split_regions_of(t, 4);
> +	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
>  	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
>  	damon_free_target(t);
>  	damon_destroy_ctx(c);
> @@ -303,7 +303,7 @@ static void damon_test_set_regions(struct kunit *test)
>  
>  	damon_add_region(r1, t);
>  	damon_add_region(r2, t);
> -	damon_set_regions(t, &range, 1);
> +	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);
>  
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
>  	damon_for_each_region(r, t) {
> @@ -450,25 +450,25 @@ static void damos_test_filter_out(struct kunit *test)
>  	damon_add_region(r, t);
>  
>  	/* region in the range */
> -	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));

Let's break lines longer than 80 columns.  Same for below four changes.

[1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings

>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region before the range */
>  	r->ar.start = DAMON_MIN_REGION * 1;
>  	r->ar.end = DAMON_MIN_REGION * 2;
> -	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region after the range */
>  	r->ar.start = DAMON_MIN_REGION * 6;
>  	r->ar.end = DAMON_MIN_REGION * 8;
> -	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region started before the range */
>  	r->ar.start = DAMON_MIN_REGION * 1;
>  	r->ar.end = DAMON_MIN_REGION * 4;
> -	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
>  	/* filter should have split the region */
>  	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
> @@ -481,7 +481,7 @@ static void damos_test_filter_out(struct kunit *test)
>  	/* region started in the range */
>  	r->ar.start = DAMON_MIN_REGION * 2;
>  	r->ar.end = DAMON_MIN_REGION * 8;
> -	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
>  	/* filter should have split the region */
>  	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
> diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
> index d2b37ccf2cc0..fce38dd53cf8 100644
> --- a/mm/damon/tests/vaddr-kunit.h
> +++ b/mm/damon/tests/vaddr-kunit.h
> @@ -141,7 +141,7 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
>  		damon_add_region(r, t);
>  	}
>  
> -	damon_set_regions(t, three_regions, 3);
> +	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
>  
>  	for (i = 0; i < nr_expected / 2; i++) {
>  		r = __nth_region_of(t, i);
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 66ef9869eafe..8c048f9b129e 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -299,7 +299,7 @@ static void damon_va_update(struct damon_ctx *ctx)
>  	damon_for_each_target(t, ctx) {
>  		if (damon_va_three_regions(t, three_regions))
>  			continue;
> -		damon_set_regions(t, three_regions, 3);
> +		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
>  	}
>  }
>  
> -- 
> 2.43.0

Other than the abovely added comments, looks good to me, overall.


Thanks,
SJ


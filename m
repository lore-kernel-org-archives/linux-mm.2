Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10D7C56201
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48786B0005; Fri, 20 Feb 2026 10:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF65D6B0089; Fri, 20 Feb 2026 10:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4D06B008A; Fri, 20 Feb 2026 10:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A14BA6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:13:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 341BC16020A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:13:12 +0000 (UTC)
X-FDA: 84465178224.29.96853E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BD9212000E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:13:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y2Zz/QGq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771600390; a=rsa-sha256;
	cv=none;
	b=N3YHenba0PlDYYmrhu+4ZhhwGvl0lOl+r+tZfT89qf6H2bDGmH50bblzgf4i1PLZWIF44+
	AU5eJ5PfmOBrtVf+9LGteBH1WqC3Dw1C+KBHZkewpZMMNb2IPAbPy3GUbHijXhASf/hLnN
	Vjm7G0ScmqSgO/Konw1ABnPhxvidCyw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y2Zz/QGq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771600390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYOfV68EdaEdcphrZW8/+oyXS+G1KP4timAHwxNfHAA=;
	b=6/p3gk8zxYbzanC6xNSpPHZ0dJTr21D1Dk+bDsX23fnjndOmzdTkvaahjndQ6VmkK9Mzgc
	DZZaTCF0MzNq77FxKLlRoxC/1H/+OLyozgqUSpDtAjUhh5+ik/KHX8NV0gt6p3BRQjj44w
	QFcHuOJjWgAfYOfnyjvPsO83fpc7zBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FAF040796;
	Fri, 20 Feb 2026 15:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD94FC116C6;
	Fri, 20 Feb 2026 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771600389;
	bh=bxc8WQnT+E88+rul66mNDSnJZSPkzlLofI8XEyaYAa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2Zz/QGqB+9T41rAe3ishgh1PkcnDNXsjFBUbEQ+fYuxFle4s9oQ+fg/g5V/a0WV+
	 DVhU9fny1+YX9LhRAUkel2oaDOjDazbHFhSrj7cg+VeCT78zrW9beN15K3VTOJGfkW
	 zKU8CYOaoPuaLPWSQmZfeVoDSumX3+WiGQMAiQaN5kLC36SeTTB19Qtp5Ko/ddKdb/
	 wW5sBhFPg+fcTgkOqbn+arKymDBuz0Ix/pWcC3O7/8VymRy4Dfg1WLv8+Xfph4S229
	 /6DIJ1MPH6w8B4Gp/bKUo/jNilheMG1tp5ZuqKyz67XlqoYWsf9QdtAzBIxkhzlpcW
	 GU2Mt2Kukw4nA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] mm/damon/core: split regions for min_nr_regions at beginning
Date: Fri, 20 Feb 2026 07:13:01 -0800
Message-ID: <20260220151301.58159-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260217000400.69056-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BD9212000E
X-Stat-Signature: yq1ymu8nsi6ependm8zmeeyf4odouqj9
X-HE-Tag: 1771600390-557633
X-HE-Meta: U2FsdGVkX1/VJbqXHpDkjtJQWqq1kTTuRVhcYAuUcVnWyHTRw6foM/fg5eKDJ2yrVq6XzYc9VstsNLIMbS+OnWZdjMcYh8fHItb3NlS/wHAWgLNAlXuQvuGtptDQnLcbGLjn2hMSjah3wsjndj5/dZ/kzAA1lgligBWptFFG2fBPPCGqUwDxCkkOl7ljRZhLXOSyJpDg2KgIbNIwi2+X6h+ZL2fcJ8hojE7HkGUs4saa703EfYRM9u8c1WSLEZAPWEAymQo11gmfBoqbnrFGMdOY4rqCSfkqLZmeGYNQ2Uk32xuwe88ZBgaO20JNqGSkAJkb2pJ6TFeVHUcp3lJiAVRKX+BLdcvX/dUSjhHSkYJIPguoTY4D1pEFFtR3md33NAEiKngfRd6qwWYrwxb8Xts5+yQbx5sdMWfuccd7zqxAqUbV2IiQN1iBsYUH8VdgyPrO/1JlDZ0bFexnLRC7emLBPF9Dk/PQyURtQhv+abRfKUykUn+9S6atWrA91N3iRFo4VqXF4nq6yc1ZG35MAk/mPG1d+QGXViSjFhkOCv70UcIH2/GQXJCWsgsoaVIkMTGLwfVs3v8W3ItDCxDUuCo3Q8rWdV9LZHXl6P9guZ8LGFq3b/7Mm6UYyQd2HAXXPZjH0/TekcQPcOdd0xSWqogkBgeslL2A/4af16NK1XSkWE/2voF4vZqi0x7OyTK2ml4E6Q18SDJJdvKsrXbRt472U4K30JwqTESdYjqCgR+C9PWWQhSziBscPP8+8eoRbUPH928R6psXmamAEeAedSNvhKyj4g2QnyW1bBdmO1+ffFLHxAkby//E3CaAElnIoyVCUU+M1WgGR8VodcIqC62ZMC3tG9TJEVbtqzUvZAP4QVyMxd+j3/7f2837+FouTZCl4CEg+HEWKWV17IxDpUCec0gLp58VdjLS8X+10xsTskC4ufWCs3K7Ow8SvIN/SA8g18xRM/ur+WcK3dI
 kxmTRj6E
 FhmffAlwg+58pePnk2TcwTkYXrJaynGQKIjNH6W9CYIg5ONzy2X0krt6g6xKBahukTO2gOkUgnQGzA37kkC3wGfOmspdXOV7Tl+X2qziszN7L+US3ubabxDC6EG4leMTyG/LxH/7FNr/u8PVt14vjFUFnUdA3eR1yu/wC7TxRB124IXZcEcGcTePSn5TrBxblwYpzM8gqNaVLssAxxTyDfYkwDuGBqjvU8RX6AEanl7w6DyFdGAocaRogNcI7Tj/lDchvyKtXg/JFxSBZVu9Zoiylp7RLEdXrl5zs0Y8Mz50FX0ReAoFj6taGdM1J7/OXHZEub4cugvW3VVF4JhNUjpqcivRaAU4UY+VSilAHqUX6hAtYAAPdyJO/yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026 16:03:56 -0800 SeongJae Park <sj@kernel.org> wrote:

> DAMON core layer respects the min_nr_regions parameter by setting the
> maximum size of each region as total monitoring region size divided by
> the parameter value.  And the limit is applied by preventing merge of
> regions that result in a region larger than the maximum size.
> 
> It does nothing for the beginning state.  That's because the users can
> set the initial monitoring regions as they want.  That is, if the users
> really care about the min_nr_regions, they are supposed to set the
> initial monitoring regions to have more than min_nr_regions regions.
> 
> When 'min_nr_regions' is high, such initial setup is difficult.  Even in
> the case, DAMON will eventually make more than min_nr_regions regions,
> but it will take time.  If the aggregation interval is long, the delay
> could be problematic.  There was actually a report [1] of the case.
> 
> Split regions larger than the size at the beginning of the kdamond main
> loop, to fix the problem.  This means the behavior is slightly changed.
> That is, the initial monitoring regions that the user set ain't be
> strictly respected, in terms of the number of the regions.  It is
> difficult to imagine a use case that actually depends on the behavior,
> though, so this change should be fine.
> 
> Note that the size limit is aligned by damon_ctx->min_region_sz and
> cannot be zero.  That is, if min_nr_region is larger than the total size
> of monitoring regions divided by ->min_region_sz, that cannot be
> respected.
> 
> [1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 39 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8e4cf71e2a3ed..fd1b2cbfe2c80 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1316,6 +1316,40 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
>  	return sz;
>  }
>  
> +static void damon_split_region_at(struct damon_target *t,
> +				  struct damon_region *r, unsigned long sz_r);
> +
> +/*
> + * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
> + * @ctx:	monitoring context.
> + *
> + * This function implement min_nr_regions (minimum number of damon_region
> + * objects in the given monitoring context) behavior.  It first calculates
> + * maximum size of each region for enforcing the min_nr_regions as total size
> + * of the regions divided by the min_nr_regions.  After that, this function
> + * splits regions to ensure all regions are equal to or smaller than the size
> + * limit.  Finally, this function returns the maximum size limit.
> + *
> + * Returns: maximum size of each region for convincing min_nr_regions.
> + */
> +static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
> +{
> +	unsigned long max_region_sz = damon_region_sz_limit(ctx);
> +	struct damon_target *t;
> +	struct damon_region *r, *next;
> +
> +	max_region_sz = ALIGN(max_region_sz, ctx->min_region_sz);
> +	damon_for_each_target(t, ctx) {
> +		damon_for_each_region_safe(r, next, t) {
> +			while (damon_sz_region(r) > max_region_sz) {
> +				damon_split_region_at(t, r, max_region_sz);
> +				r = damon_next_region(r);
> +			}
> +		}
> +	}
> +	return max_region_sz;
> +}
> +
>  static int kdamond_fn(void *data);
>  
>  /*
> @@ -1672,9 +1706,6 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
>  	damon_set_attrs(c, &new_attrs);
>  }
>  
> -static void damon_split_region_at(struct damon_target *t,
> -				  struct damon_region *r, unsigned long sz_r);
> -
>  static bool __damos_valid_target(struct damon_region *r, struct damos *s)
>  {
>  	unsigned long sz;
> @@ -2778,7 +2809,7 @@ static int kdamond_fn(void *data)
>  	if (!ctx->regions_score_histogram)
>  		goto done;
>  
> -	sz_limit = damon_region_sz_limit(ctx);
> +	sz_limit = damon_apply_min_nr_regions(ctx);
>  
>  	while (!kdamond_need_stop(ctx)) {
>  		/*

As the commit message is saying, and Akinobu pointed out [1], this patch is
incomplete.  It doesn't cover the online updates of monitoring regions and
min_nr_regions.  I was planning to solve this case first and continu works for
the online updates.  The followup work was taking time more than I expected,
mainly because I wanted to do that in an efficient way.  That is,
damon_apply_min_nr_regions() iterates regions twice.  I wanted to reduce that.
But now I realize maybe I was thinking too much.

Just calling damon_apply_min_nr_regions() after kdamond_merge_regions() like
below should work in a not that inefficient way.  I believe it is not that
inefficient because it will be executed only in aggregation interval.  We are
doing the region iterations multiple times per sampling interval, which is 1/20
of the aggregation interval by default and smaller portion of the aggregation
interval in experimental setups, anyway.

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3371,10 +3371,13 @@ static int kdamond_fn(void *data)
                        max_nr_accesses = ctx->ops.check_accesses(ctx);

                if (time_after_eq(ctx->passed_sample_intervals,
-                                       next_aggregation_sis))
+                                       next_aggregation_sis)) {
                        kdamond_merge_regions(ctx,
                                        max_nr_accesses / 10,
                                        sz_limit);
+                       /* online updates might be made */
+                       sz_limit = damon_apply_min_nr_regions(ctx);
+               }

                /*
                 * do kdamond_call() and kdamond_apply_schemes() after
@@ -3434,7 +3437,6 @@ static int kdamond_fn(void *data)
                                sample_interval;
                        if (ctx->ops.update)
                                ctx->ops.update(ctx);
-                       sz_limit = damon_region_sz_limit(ctx);
                }
        }
 done:
'''

If nobodys finds some problems on this, I will post RFC v2 of this after
squashing the above diff into this patch, probably within this weekend.


[1] https://lore.kernel.org/CAC5umygPq8+FQWTG73-QPOKHT1P5=N2+qFkrRfZAkL_7G=gQXQ@mail.gmail.com


Thanks,
SJ

[...]


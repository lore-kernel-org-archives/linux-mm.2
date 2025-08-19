Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE683CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 05:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A136B009B; Tue, 19 Aug 2025 01:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA506B009C; Tue, 19 Aug 2025 01:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F07F6B009D; Tue, 19 Aug 2025 01:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0A76B009B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:25:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89A2A140219
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:25:44 +0000 (UTC)
X-FDA: 83792369808.29.AD346F2
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFF3540010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:25:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lspyx+YZ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755581142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaWC+il5RtCEHBtBy5mhfhgtShm18SoClavT6S9KpFQ=;
	b=sgyeXROZxH+tWtRu43a3wt5EhoJq5g26sJ2MQKgcgc/oj9MHXDbftkDlYvT2sRMn3tfGb7
	hsLUXTXlyIPV8ZxkkRMjgrJTjVkkIgKU5EzXmYFJjjdoICIJwDIiRYpCiq1gUyDgmPYszS
	O1MxdTkW2mF4lTtE5iKNLk1OLrvO2PQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lspyx+YZ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755581142; a=rsa-sha256;
	cv=none;
	b=uRBT16C9Z+nXHqc+JPaH5PJeHBjYws0qjt0T/O+L+VSrMuMWjtK80/xyp80fLxhec7Tzl6
	4/ieRdjL+dsiMRTIt892dI17skzm2SCSrjQhIpmggeyBpicbkHO7HUxJJQTyD2SINK5U/i
	YNFPo3crQPfZnu3A9fc/tswHQ9RDRts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A8A0D5C4D4A;
	Tue, 19 Aug 2025 05:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2257BC4CEF4;
	Tue, 19 Aug 2025 05:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755581141;
	bh=yXQc+PcrnqyNAoKXW51Z4gByum0niSizmcaNBF/bkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lspyx+YZetpxjXUtPxcRf/mI08qHrcYp3O2eqjl/8OgA8iJT9CTM0PXrO4zd1ouCv
	 V54YX61/XA2SgRktPK6B8eSd5oLS2ezzbsu3w0z4Mmw6vuKHd1eU0rE2W1au3dIdvi
	 DFhJBdSul6AK3LP2ZOG9oj5F8ljIF/I9iACys78irLCviSEf4GrPXSxEoZV0l3IuOf
	 kLA3uGsgWZ4sDRbNeAlA4pVPClsBciim+CaQhK6kOC8Ih4nEImghkJ9tA9x4x8C6Zm
	 2jRg9hbBwss5qHcnVJlIxIL7L1pIS8wVI+ISd9zZOI5u9tCUUnI7ysRiJ7kCAHJbi9
	 l56sBQnVJP19g==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
Date: Mon, 18 Aug 2025 22:25:39 -0700
Message-Id: <20250819052539.38526-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250818183803.1450539-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4uaidnskqmnch68czqp3df9a8un3xy1
X-Rspam-User: 
X-Rspamd-Queue-Id: BFF3540010
X-Rspamd-Server: rspam01
X-HE-Tag: 1755581142-740783
X-HE-Meta: U2FsdGVkX1/BXMvCu3UPvlDC80s06WPkCB72aiZxEu7/NGma0BFacFdkYwSX5KUxuyWnKlMUG6Wa94+3GWhW7Fe0fdrKHsAp2CUkCldWlR3JwWqnhNJfU+vHOc8d15mR+HxLZmlJPTO8lK1Rii158xJUT/Pg30F0raa8D0uD9URBqU8HNvze8JWvdk8sqXtKdjVbECyeGcWt/mOu2oY72zLYrfBlsqyUYyUPxRDo5ae5dhDLbizCh9am62acs6Yv1M9n5pJC4QY1vrldopE6sXsisrZOWy1yeRIxAQKU7l2RRi74de26iVy+wL54Zbz4pohFDzLLequcboCeToAnQ/3IE+iH+gklcsgPrv/xK95ZRFxbTz8CdP4WL9KOgL49+ZX6B65V7P7IxkRy8WF/XeLmraqJ/ZTR4pIsd7S2R0OjRPP4dOgdogTWf3/NWsnW+9s8w1bt/WCJ5O8GvnF+5yvvPdKUxYK99rYUT9BsjGoPPrBR+ptrj8FqgHCVtOwb/tAOXiQrrDNKWll7xKz1aLe28sM9Kaqkd3Qj2wwB7t1bryUg+tVZxBxrSfJw6a6F7F7lV2a+5p9yTl5xEU6tQK+4dmd2I/TpcnE6jFJmt49jmufSzW+hdak8IxHCDmfzfKdbJ5+JNiUMRXa6T3Gb3hY0F85Ae9UUSyNcV9k+nxTZN0ZBPBb5DqcTdYhKQ/rHXt8/5wBZBmYqSQl9Fo4P0r3GttFD319di+sJy3glHO7dFqOMJVmxYcHzSDnhhpdgiBzQriPYm/rvJ/SuJIhh0VHDOM4tNGeVi418Bow5DxqODrpvBh/ocvPteqml+f3KWqDzm/86lj8iNfl3MmK+LcicT2fIUFxyO9SuAeAmZYbtRVfkYRc2/fRuXhceIKwjwv3BkHlkPA17kNbrLlcezy431XqWoj2PBm5QKB4p6owq1CDZZxTlHypwT8Tg5QwUWJMXNP2mObjSrVBbqYr
 NMVxUTpn
 zD9Dskxz8M9NAhwAp4k9PwUsOErueb1FgCpw4Alp1Jz0RvlCfENlzsBcwgVMeBg/n3CltbDdr4fxFB+L1mAS3a0VKAFGWvzysP/nX252gGZDu7tgbhzFA9jd9ysIpCWDZ7c8Fqvd9RwntLQYEhHNCDQHS3K/7T5DmskAM5hvS90xYe6gbpRT+zhw072hW5SReEPbRpn9ekgD9ZICn8plOK6Oj6H4Ef14ftcALDvC/nhTjzUBR28ISxMBP7Xj/MuJinfpg/jIJDZC7kUBzwUvLlQfg8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 03:38:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
>  /*
>   * Have the 32 bit jiffies value wrap 5 minutes after boot
>   * so jiffies wrap bugs show up earlier.
>   */
>   #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> In 32bit system, if quota->charged_from is initialized to 0 as it now,
> it will not adjust event if reset_interval_ms passes for the first 5
> minutes.

Thanks to your clarification on another mail, I now understand this can happen
because time_after_eq() casts the diff of the given two unsigned long values
into signed long type.  I might be not the only one who can be confused on this
part, though.  I think at least I of future will be confused again.  Please add
the detail on the changelog.

The above explanation is not technically wrong, but I think it is not
describing the issue completely.  The above description is saying about only a
case that a DAMOS scheme with quotas is applied just after the system is boot.

But, a similar and much worse problems can happen at anytime if such scheme is
applied while jiffies value is somewhat that can be casted into any negative
signed long value, e.g., about 25 days after the boot, assuming HZ value 1,000.
In the worst case, hence, a quota charging window can continue for up to about
25 days.

The same problem can theoretically happen on 64 bit machines too, though not
practically early (about 300 million years after the boot, assuming HZ value
1,000).

If I'm not wrong, I think the fix of this bug deserves Cc-ing stable@.

> 
> So change initialize value of quota->charged_from to INITIAL_JIFFIES.

So this will fix only just-after-boot time issue.

I think it should be initialized to the jiffies value of the time that the
quota really starts being charged.

> This soultion has already been applied in commit 7d70e15480c0 ("writeback:
> add missing INITIAL_JIFFIES init in global_update_bandwidth()") or else.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> I think it would be good to add selftest of below senario. 
> 
> 1. Set DAMON with quota.
> 2. Wait and check esz is updated well.
> 3. If esz is not updated after quite long time, set test to fail.
> 
> but I'm not sure that selftest can support environment handling; jiffies
> with INITIAL_JIFFIES or near there.
> 
> If there is another method that i don't know. Could you please let me
> know? Or any better idea?
> 
> ---
>  mm/damon/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index cb41fddca78c..90317a3bcf78 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -366,7 +366,7 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
>  	quota->total_charged_sz = 0;
>  	quota->total_charged_ns = 0;
>  	quota->charged_sz = 0;
> -	quota->charged_from = 0;
> +	quota->charged_from = INITIAL_JIFFIES;

As I argued above, I think we should at least set this as 'jiffies', not
INITIAL_JIFFIES.

Also, damos_quota_init() is called by damon_new_scheme().  We cannot guarantee
if the caller will directly start DAMON with it, or commit it into running
DAMON.

So a better approach would be initializing ->charged_from at the beginning of
kdamond_fn(), e.g., inside kdamond_init_ctx().  For commit case, damos_commit()
may also need to be updated.  To me, this feels too complicated for stable
kernel backports.

What about modifying damos_adjust_quota() to initialize ->charged_from, like
below?

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2130,6 +2130,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
        if (!quota->ms && !quota->sz && list_empty(&quota->goals))
                return;

+       /* First charge window */
+       if (!quota->total_charged_sz && !quota->charged_from)
+               quota->charged_from = jiffies;
+
        /* New charge window starts */
        if (time_after_eq(jiffies, quota->charged_from +
                                msecs_to_jiffies(quota->reset_interval))) {
[...]

In theory, this can also incur wrong behavior in a case that charged_from is
overflowed to zero while total_charged_sz remains zero.  Such cases would be
unrealistic, though.  And even if it happens, nothing goes really wrong.  It
will only extend the current charging window for one reset_interval, once per
jiffies overflow.  Meanwhile, this fix is simple and can be easily backported
to old stable kernels.  So I'd like to recommend this option.

What do you think, Sang-Heon?


Thanks,
SJ


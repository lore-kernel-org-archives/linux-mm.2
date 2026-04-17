Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B4DF8E497
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA7A6B0099; Thu, 16 Apr 2026 21:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991D86B009B; Thu, 16 Apr 2026 21:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF256B009D; Thu, 16 Apr 2026 21:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D02D6B0099
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:12:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DF1F8CA40
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:12:35 +0000 (UTC)
X-FDA: 84666272670.12.2B07E78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 828CC140002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:12:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEEDYi8m;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IS3oCEzOjZjm2QLUQ8g/kDjt/4+mDdyhiNqj7Y1OdCo=;
	b=KcrNHJeSOlbsV18+Fbc/+5252j/hKN/tl827iZbHo1rDl57W1MN0tuaB4fC30C5nFVVcPa
	UrFp8k4IKtwIORvHolrXjYPip9IcN9UhhAxAjxErIz9cDMoFh2+c5gnnJXjBf6AkV0wr+j
	mtOrbkelP8NPI1oL8lUUMD8FZJcIIm8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEEDYi8m;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388353; a=rsa-sha256;
	cv=none;
	b=S6ZsQmEJlRTPJlPhXqA79oY455FazRo1y/142JekjgSxmwK+geaR9me9LagHh5quOZFJ0O
	daABqmPljN2e6PGeZskI2sJ9gr13BbHuRpiPwYqb0AxtsNYxMYRYmTTP8+EYnxoXhei+vN
	AaY494pwkV9/8CxYGKI8zEEjMSMVeh0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81F0C44114;
	Fri, 17 Apr 2026 01:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B8C2BCAF;
	Fri, 17 Apr 2026 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776388352;
	bh=Kl1/BBAo5AN0a7pqkV9e0HsNYs4ybzxNUCF9Q9XUNbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEEDYi8mLB7BY4EkqX0WdN9j41CWHbU78MAK/bgyMyLWiykG5Kg0s8AdMMWopa+Ss
	 sRiVV4t9JWu5HYihaKjNpLuxSvyl8T+xo35ClrGEw3XDmHoVwwRZN4rVC61UHI9Ul3
	 vp8ElM7UQtXx9yWQ5kUVOXCUxLjG/38+vqnyxTiO8OAz5hZcWUatMydEy4IBfx6pNB
	 CiQHk0hkXnIAiJyxlQaqI1GG7D7GUO6+56t4/h95fI1zV8aL5YBGaLKY8ZkmTxZ9ib
	 QQUESEtuHnZTaPUtCgqqPblSGvN0VvS6X4zfFyL7md4OoaW3G9wRQo3oBboufh4fkR
	 cHVQ9dbu4fF8w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Thu, 16 Apr 2026 18:12:28 -0700
Message-ID: <20260417011229.75947-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416062818.949-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7stfm73zjp3y35ckyjf9psw1iboentkh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 828CC140002
X-HE-Tag: 1776388353-32851
X-HE-Meta: U2FsdGVkX1+Zzkh7QtX/32fslbwONI56VpSdiCQaBNFxHoDjtCbJ4tn/Jfh4HfPuEBx8J5m9DoQ/1T3sXDbCdvAfFp36pLwqbPA0AhpyOEkcfCGTmF54tvjT2bCACae3T13oSX8apqUmkgbIvrHzUrACc0wsNf5wbnb+zNJEMU3/cVfhsh0YbC3NWxghpwRTlkZJNIt55ozsBpgbXQ3UfNtAfcyo5e0cF6YCIIjMAtNCzCCnrYOgDRu+kahMuxx0LqZhQULhsfC21mXxzi98losazC/UE7+XCEWNSs9x6uc1QlRpSUO20IxSY/2pTV2RJ965bAdRn+Ajagk2vdwtmgHo8RbvuXgL/SoXQcjmK8eZwP5MiETIphRlGthNY6LA9RMlPrd8c39TyGqbDPxmtHxnOWi2XwaZuYqdbQD3hhB3VImQ7+wl65FKHQveURuStD4Qj9E2HKI5v8FJ4NzEAMz7j9NNSj9tZi/zQIODnpXBZgPMI7vQjJZJ03ro6DTIr3r8zkR3roYlgMlfDSpF4FWirKUldt0/fhd0t/wdYFZHL4OTVkJ48MnFcz7UraYMUwMqneICFFn9jT6EyKpUa5PMR7Ym3iQfNNQBoKAACligMQseV2iInAJgDQn+spagLaOESFIqdc+zKsHhWmZxn7SyM1NV/O1WphQRjxWc3mOz7zzYuClQEeiAcze8WmmRXDMriRgxoFPGPdo6zOSZ18d2qi2/8oq1H7Z6qVX743G7mzg63LP0Ns+8bpYzJdbP2rsAJ/fIm+4mfU5sNohgIfcng+CPunmq8/MenriLOcDBNngQGfrlXv2t1Wfou1iIqpKcAFmmDrvIEqP8GpEgIAec2F9I1N7b8QTsN8lnKdVNpS2k/TPX7w1K6MEX9O3BBQ3XjPWZQu/KH0i538zDncgwv1+caAx8FwU0ju8jEX0L243GhJ0oKls9lLvxyV2D3bjGQppY0qXEWbJiLAZ
 ISKrdV0m
 DeEgZ2C27EIEBBQhEY/0n/IpKaCH3YrOK3ScsEm2sNpxWazevHLhpv7SokIjQp/HxBvYWg0derVsVItUXJOMMSSJ5x4vqlHuc+5gHYnHu/B6sVIgGA3fHxdelYa3BjogQaRcc+oYh2p4NI/NwUqi426nyXiCplaxSGQIdQTQDl7i5xzvt/IQUpNwyi7mDTeGAUpgU/aqBrQ7aZ4bLWIL46Ydu5taC4l+jiwFYGJzo1cmO3ZPEdWlLn5w9UAMexcvgufuJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 23:28:17 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 15 Apr 2026 16:55:29 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Thu, 16 Apr 2026 02:45:12 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Mon, 13 Apr 2026 17:34:34 -0700 SeongJae Park <sj@kernel.org> wrote:
> > > 
> > > > On Mon, 13 Apr 2026 17:23:03 -0700 SeongJae Park <sj@kernel.org> wrote:
> > > > 
> > > > > On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > > 
> > > > > > Problem
> > > > > > ========
> > > > > 
> > > > > Let's align the underline with the subject.  Also, let's add one blank line
> > > > > after the underline.
> > > > > 
> > > > > > When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> > > > > > 'kdamond_pid' remains stale. This prevents user from restarting DAMON
> > > > > > because both writing 'Y' and 'N' to 'enabled' will fail.
> > > > > > 
> > > > > > "Unexpected termination" here means the kdamond exits without any user
> > > > > > request (e.g., not by writing 'N' to 'enabled').
> > > > > 
> > > > > Could you please further explain when such termination can happen?
> > > > > 
> > > > > > 
> > > > > > User Impact
> > > > > > ===========
> > > > > > Once kdamond terminates this way, it cannot be restarted via sysfs
> > > > > > because:
> > > > > > 
> > > > > > 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
> > > > > >    be unloaded and reloaded at runtime.
> > > > > 
> > > > > I think this is quite obvious, so may better to be dropped.
> > > > > 
> > > > > > 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
> > > > > >    Writing 'Y' does nothing, as 'enabled' is already Y.
> > > > > > 
> > > > > > As a result, the only way to restore DAMON functionality is a full
> > > > > > system reboot.
> > > > > 
> > > > > Thank you for clarifying the user impact.  I think this deserves Cc-ing
> > > > > stable@.
> > > > > 
> > > > > I think 'Problem' and 'User Impact' can be unified into one section.
> > > > > 
> > > > > > 
> > > > > > Solution
> > > > > > ========
> > > > > > damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
> > > > > > sets it to false upon successful completion. When 'maybe_corrupted'
> > > > > > remains true, kdamond will terminate eventually.
> > > > > 
> > > > > This seems better to be explained earlier, on the problem section.
> > > 
> > > Okay, this is my current commit message:
> > > 
> > >     Problem
> > >     =======
> > > 
> > >     When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> > >     'kdamond_pid' remains stale. This prevents user from restarting DAMON
> > >     because both writing 'Y' and 'N' to 'enabled' will fail.
> > > 
> > >     "Unexpected termination" here means the kdamond exits without any user
> > >     request (e.g., not by writing 'N' to 'enabled'). This can happen when:
> > >     - Internal error of kdamond.
> > >     - Invalid parameters commit via 'commit_inputs' (e.g., addr_unit=3).
> > > 
> > >     The root cause is that damon_commit_ctx() sets 'maybe_corrupted=true' at
> > >     the beginning and only sets it to false upon successful completion. When
> > >     'maybe_corrupted' remains true, kdamond will terminate eventually.
> > > 
> > >     Once kdamond terminates this way, it cannot be restarted via sysfs
> > >     because writing 'N' to 'enabled' fails (kdamond no longer exists) and
> > >     writing 'Y' does nothing ('enabled' is already Y). As a result, the only
> > >     way to restore DAMON functionality is a full system reboot.
> > > 
> > >     Solution
> > >     ========
> > > 
> > >     The problem is that 'enable' parameter value is not trustworthy.
> > >     Instead of relying on the 'enabled' variable, use damon_is_running(ctx)
> > >     which reflects the true kdamond state.
> > 
> > I don't want to be picky, but ...  I still feels this is easy to make readers
> > including future myslef be confused for some points.  Given this is a bit
> > serious bug fix, I feel I have to raise the bar, at least for future myself.
> > What about below?
> > 
> > 	Kdamonds for DAMON_RECLAIM and DAMON_LRU_SORT could stop without
> > 	properly updating 'enabled' parameter value, when parameters online
> > 	commit fails due to invalid user inputs or internal memory allocation
> > 	failures.  The enabled parameter value, which can be stale after
> > 	certain kdamond stops, is used by the modules' kdamond start/stop
> > 	logic, to avoid doing unnecessary start/stop works.  As a result, uses
> > 	cannot restart the kdamonds before the system is rebooted and 'enabled'
> > 	parameter value is correctly reset.  For example, the issue can be
> > 	reproduced like below:
> > 
> > 	<your reproducer>
> > 
> > 	Fix the issue by using damon_is_running(), which should reflect the
> > 	true kdamond state, instead of the 'enabled' parameter.
> > 
> > > 
> > > > > [...]
> > > > > So the problem is that 'enable' parameter value is not trustworthy, and this
> > > > > series is trying to make it trustworthy.  I think it is bit complicated,
> > > > > especially for stable@ fix.  What about simply using more trustworthy
> > > > > information, e.g.,
> > > > > 
> > > > > '''
> > > > > --- a/mm/damon/reclaim.c
> > > > > +++ b/mm/damon/reclaim.c
> > > > > @@ -390,7 +390,7 @@ MODULE_PARM_DESC(addr_unit,
> > > > >  static int damon_reclaim_enabled_store(const char *val,
> > > > >                 const struct kernel_param *kp)
> > > > >  {
> > > > > -       bool is_enabled = enabled;
> > > > > +       bool is_enabled = false;
> > > > >         bool enable;
> > > > >         int err;
> > > > > 
> > > > > @@ -398,6 +398,9 @@ static int damon_reclaim_enabled_store(const char *val,
> > > > >         if (err)
> > > > >                 return err;
> > > > > 
> > > > > +       if (ctx)
> > > > > +               is_enabled = damon_is_running(ctx);
> > > > > +
> > > > >         if (is_enabled == enable)
> > > > >                 return 0;
> > > > > 
> > > > > '''
> > > 
> > > Thank you for the suggestion. I have tested this implementation and it
> > > works expected. I agree that its complexity is much lower and more
> > > suitable for a stable fix.
> > 
> > Thank you for testing!
> 
> Hmm, and now I think we migt be able to use this kind of trustworthy
> information for reading part too, for not only enabled but also kdamond_pid,
> like below.
> 
> '''
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index ecfc6b58d07d2..775b33dbc952f 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -159,15 +159,6 @@ static unsigned long addr_unit __read_mostly = 1;
>  static bool skip_anon __read_mostly;
>  module_param(skip_anon, bool, 0600);
>  
> -/*
> - * PID of the DAMON thread
> - *
> - * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
> - * Else, -1.
> - */
> -static int kdamond_pid __read_mostly = -1;
> -module_param(kdamond_pid, int, 0400);
> -
>  static struct damos_stat damon_reclaim_stat;
>  DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
>  		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
> @@ -343,12 +334,8 @@ static int damon_reclaim_turn(bool on)
>  {
>  	int err;
>  
> -	if (!on) {
> -		err = damon_stop(&ctx, 1);
> -		if (!err)
> -			kdamond_pid = -1;
> -		return err;
> -	}
> +	if (!on)
> +		return damon_stop(&ctx, 1);
>  
>  	err = damon_reclaim_apply_parameters();
>  	if (err)
> @@ -357,9 +344,6 @@ static int damon_reclaim_turn(bool on)
>  	err = damon_start(&ctx, 1, true);
>  	if (err)
>  		return err;
> -	kdamond_pid = damon_kdamond_pid(ctx);
> -	if (kdamond_pid < 0)
> -		return kdamond_pid;
>  	return damon_call(ctx, &call_control);
>  }
>  
> @@ -387,10 +371,16 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
>  MODULE_PARM_DESC(addr_unit,
>  	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
>  
> +static bool damon_reclaim_enabled(void)
> +{
> +	if (!ctx)
> +		return false;
> +	return damon_is_running(ctx);
> +}
> +
>  static int damon_reclaim_enabled_store(const char *val,
>  		const struct kernel_param *kp)
>  {
> -	bool is_enabled = enabled;
>  	bool enable;
>  	int err;
>  
> @@ -398,7 +388,7 @@ static int damon_reclaim_enabled_store(const char *val,
>  	if (err)
>  		return err;
>  
> -	if (is_enabled == enable)
> +	if (damon_reclaim_enabled() == enable)
>  		return 0;
>  
>  	/* Called before init function.  The function will handle this. */
> @@ -414,15 +404,48 @@ static int damon_reclaim_enabled_store(const char *val,
>  	return err;
>  }
>  
> +static int damon_reclaim_enabled_load(char *buffer,
> +		const struct kernel_param *kp)
> +{
> +	return sprintf(buffer, "%c\n", damon_reclaim_enabled() ? 'Y' : 'N');
> +}
> +
>  static const struct kernel_param_ops enabled_param_ops = {
>  	.set = damon_reclaim_enabled_store,
> -	.get = param_get_bool,
> +	.get = damon_reclaim_enabled_load,
>  };
>  
>  module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
>  MODULE_PARM_DESC(enabled,
>  	"Enable or disable DAMON_RECLAIM (default: disabled)");
>  
> +static int damon_reclaim_kdamond_pid_load(char *buffer,
> +		const struct kernel_param *kp)
> +{
> +	int kdamond_pid;
> +
> +	if (ctx) {
> +		kdamond_pid = damon_kdamond_pid(ctx);
> +		if (kdamond_pid < 0)
> +			kdamond_pid = -1;
> +	} else {
> +		kdamond_pid = -1;
> +	}
> +	return sprintf(buffer, "%d\n", kdamond_pid);
> +}
> +
> +static const struct kernel_param_ops kdamond_pid_param_ops = {
> +	.get = damon_reclaim_kdamond_pid_load,
> +};
> +
> +/*
> + * PID of the DAMON thread
> + *
> + * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
> + * Else, -1.
> + */
> +module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
> +
>  static int __init damon_reclaim_init(void)
>  {
>  	int err;
> '''
> 
> This is much bigger change than your original suggestion.  But I feel this is
> simpler, because this eliminates the needs to keep the states.  What do you
> think?

Maybe I suggested too much...  If we decide to take both my suggested commit
description and the above change direction, maybe it is difficult to say you
are the main author who should be primarily responsible for any followup issues
on the patch.  Of course you will still deserve to have credits.  Maybe
'Co-developed-by:'?

Meanwhile, I feel like the fix of this bug is taking bit unnecessarily long
time...

If you agree, hence, I'd like to take this over from this point, and finish up
the remaining works for this patch.  If you also agree, I will also take the
responsibility (authorship) from you, while keeping keep your credits with
'Co-developed-by:' tag.  What do you think?

By the way, I hope I'm not making you to get me wrong.  I'm not trying to steal
your credit (authorship).  In my opinion the authorship means the
responsibility (or, who to blame) more than the credit.  Putting right name to
the place for the responsibility is important for the long term maintenance and
evolvement of the community and the product (Linux) in my opinion, so I have to
say this.


Thanks,
SJ

[...]

> 
> 
> Thanks,
> SJ
> 
> > 
> > > 
> > > > > 
> > > > > > 
> > > > > > Changes from RFC-v1
> > > > > > (https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
> > > > > > - Remove RFC tag.
> > > > > 
> > > > > When dropping RFC tag, let's start from v1 again, from the next time.
> > > 
> > > Regarding the versioning, I have two questions:
> > > 1. Is version number inhritance only required when converting from
> > >    non-RFC to an RFC?
> > 
> > I'd request such conversion when dropping RFC tag.  E.g.,
> > 
> > RFC -> RFC v2 ... -- (drop RFC) -> v1 -> v2 ...
> > 
> > > 2. Should my next version be tagged as v3 (since the current one is v2)?
> > 
> > The ship is already sailed for this patch series.  Please tag it with v3.  But
> > please follow the suggestion from next times.
> > 
> > > 
> > > > 
> > > > Also, I just found the patches don't have Fixes: and Cc: stable@.  Could you
> > > > please add those appripriately?
> > > 
> > > Regarding the Fixes: tags, I will include the following:
> > > - Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
> > 
> > This seems correct, but ...
> > 
> > > - Fixes: 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays active")
> > 
> > Is this correct?  At the point of this commit, there was no commit_inputs
> > parameter.  Were you able to confirm this issue can and cannot be reproduced on
> > this commit and its parent commit, respectively?
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]


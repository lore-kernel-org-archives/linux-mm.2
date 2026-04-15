Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF56AF433D0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 23:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065F76B0005; Wed, 15 Apr 2026 19:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016496B0088; Wed, 15 Apr 2026 19:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E536B008A; Wed, 15 Apr 2026 19:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31A96B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:55:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CCD0C233D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:55:40 +0000 (UTC)
X-FDA: 84662450040.15.8193F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB44AC0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I6KBWJaQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776297338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2PTKm8oxld53Riscxg5i5EwnDqKfi3Vg0BPwKXcgeQ=;
	b=IxIB1tXuSa8k98rsgyOq9/SbASH8ByJ3rmlPEt9WGPjz609p97dQ5BSHX0/ZAaSqqMoI5F
	EfKRBgG50Ky1MpK9BLtJdEgTgD7Ag708IHxM0e3w3YEBqj6sF57jXS9MEkXiNPZkmXYMjw
	bfCi3YTECAI0okfTABR2ADrGzHfqHDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776297338; a=rsa-sha256;
	cv=none;
	b=Gu/FMAE6d99NwlfdT8PbBVBvL44AVq5kSrN9p2aDIHyyfWgvvgna4aNL0ox6B/vFBE1tgY
	l+lLrMBaGZlBsfhEEeBBaT4kiLgi7zpVcG4JkFeGDp7HpmZEs0eeBt/szR0VkYsWMva/0o
	hvJud0lc6lDsjOWADUg0UR3TzzfYBqs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I6KBWJaQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE1A8417F3;
	Wed, 15 Apr 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71773C19424;
	Wed, 15 Apr 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776297337;
	bh=2ndUQ7WOyZeVIswHE1bYk6rDm8lMOU3HeDaztOLdi4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6KBWJaQU6ji0uWaMjS6ilsQ5ZrtJEE2iaaqev0LY44UO0vvEAI/kuqE8EZ0fcDxN
	 ZUSay40jUaFnjCZ5T8H0dvR7albPK84NOmsjZqrM1IZAHB3KZWwcwQkyrCPQYgRWcN
	 W2nBHbcXPhFdn8Z8Kqp4q+wtmE/2axpnpPHFxQQPkOtxl2o4S/rRrEI+NKZm8/xOIj
	 Sqv5Ba9IC0TShzXrr23Iuvyr8CuntXFfV25zE8nHcYbgW5ZhRlLzxwg84XmJC3skSI
	 LtyKDdmSFxw7bhcVAQtYQYpHOcS0nmhlbI+nw31ZBdzW87H9roZwKBoby2Zo4XJc4G
	 B3wFLz8YV1aiQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed, 15 Apr 2026 16:55:29 -0700
Message-ID: <20260415235529.86329-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415184512.14026-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB44AC0006
X-Rspamd-Server: rspam07
X-Stat-Signature: t4dh6u5ye6peqxzniw5knxktwmad7dik
X-Rspam-User: 
X-HE-Tag: 1776297338-191890
X-HE-Meta: U2FsdGVkX18tcZTEuXxAxnnEBITbDbbG80HFgCMCotfEAhdQePUe9Ck+Ui/QD0DxctejpExLPWUzl+W7IoZ1XkZu4OxhnedPhc+zsi4OVlL6xZM4Uvc34hYyOo5JdMnZkuzUvalgKn0CCdXYEyktu08xx/iIXvIezy3myrAODyRDvp5lAnZB9ADWIfPPIrGwGERikeKs7TB7JZK5fc9T/V/CO7qRdGaB9LTGae1g6jiMAPEZIwaqSq2YQjnMd8N4ix+xfkO6ZH/o0iiZLzzArm5NtwP7W26efvMzhPx7HtRkdZi6SPK/CgTGjA/+GZVaaMuaguzvjYRbxiVfcF+w1m4awR2M76XSVY+qS3RPvHh0GU65SgECqJCOqsjE3vq4GyiiUau7HgU1zezs7GVcSdjjh+syx8LawZ+meazVYmBSLYHb6LNeKwKPqKyBR3YHIyreiLvJ7akTx3WJwn+RRcYSOiBlXn+e2uU2szHQyI5bQcfGnrEZlKV8fzvbPVPqgx8sPiyXxIr4LWmO0QvV4LW1Uwz7Wfo574YuMAwiDQM73HKkFsBddWT7qa+Dv3qCZ6Cnscs7o57xtp1Y/7tUixaIkwfSh2kGz47kiN7vcpwhElflEFH22sunfzjhF0zm28hqP8Ot49zVPGTjutxBRZ1e3au/etLb+FIKCgMmFiWtIlwUo+IuerFFD50MY/aRn6oRlFoAojtS6dfIRahrdzFgSIofPAvn0kqvOvZalYzhuNFBSWEQHmD6aeJiSXi9h6QG1CQc6ZfDsit7gn/0d4aOQgyr233SRcTyQyGEqIxn2aTC5rBntLJEJ4cDvrDhGylDkQxsvM1YRIRxXS7SYtmSxsYfARP/ji+1LX3hFJQpGUrCVi/Q7jn2cQ24Ms8e0rZtACsIppw1S5V4vdjnAI/syqsbU/Okralh6b0wTX4yQ46wW9wrMU08oCroPXyvi8+vBN/OmYDfHtdPITv
 98YQ+3tC
 i48EOJSILrchwz4A1BoYuTWXh8i2W6WWS/YtjPmCMZ4eq2Nk/OZnLi3tUwD7K3ywNLD6DnvfTXMCJWUdzTVzC/n11HEq3YAK61G1v939r0+C+hLMOPVs36uz62LYZzPxaTBcJtQna7YB+xJEnxAoFmdftoY93/CGZiG2fva9pJUBfGI+uXRSxahfHgTKAmxT1WVv5zVxedfPuW8m1gEL8BXMEmCODpQ7/lkpcEkASf5j3H3axt6BquNid+dKS9r/3/Std
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Apr 2026 02:45:12 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Mon, 13 Apr 2026 17:34:34 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Mon, 13 Apr 2026 17:23:03 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > Problem
> > > > ========
> > > 
> > > Let's align the underline with the subject.  Also, let's add one blank line
> > > after the underline.
> > > 
> > > > When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> > > > 'kdamond_pid' remains stale. This prevents user from restarting DAMON
> > > > because both writing 'Y' and 'N' to 'enabled' will fail.
> > > > 
> > > > "Unexpected termination" here means the kdamond exits without any user
> > > > request (e.g., not by writing 'N' to 'enabled').
> > > 
> > > Could you please further explain when such termination can happen?
> > > 
> > > > 
> > > > User Impact
> > > > ===========
> > > > Once kdamond terminates this way, it cannot be restarted via sysfs
> > > > because:
> > > > 
> > > > 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
> > > >    be unloaded and reloaded at runtime.
> > > 
> > > I think this is quite obvious, so may better to be dropped.
> > > 
> > > > 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
> > > >    Writing 'Y' does nothing, as 'enabled' is already Y.
> > > > 
> > > > As a result, the only way to restore DAMON functionality is a full
> > > > system reboot.
> > > 
> > > Thank you for clarifying the user impact.  I think this deserves Cc-ing
> > > stable@.
> > > 
> > > I think 'Problem' and 'User Impact' can be unified into one section.
> > > 
> > > > 
> > > > Solution
> > > > ========
> > > > damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
> > > > sets it to false upon successful completion. When 'maybe_corrupted'
> > > > remains true, kdamond will terminate eventually.
> > > 
> > > This seems better to be explained earlier, on the problem section.
> 
> Okay, this is my current commit message:
> 
>     Problem
>     =======
> 
>     When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
>     'kdamond_pid' remains stale. This prevents user from restarting DAMON
>     because both writing 'Y' and 'N' to 'enabled' will fail.
> 
>     "Unexpected termination" here means the kdamond exits without any user
>     request (e.g., not by writing 'N' to 'enabled'). This can happen when:
>     - Internal error of kdamond.
>     - Invalid parameters commit via 'commit_inputs' (e.g., addr_unit=3).
> 
>     The root cause is that damon_commit_ctx() sets 'maybe_corrupted=true' at
>     the beginning and only sets it to false upon successful completion. When
>     'maybe_corrupted' remains true, kdamond will terminate eventually.
> 
>     Once kdamond terminates this way, it cannot be restarted via sysfs
>     because writing 'N' to 'enabled' fails (kdamond no longer exists) and
>     writing 'Y' does nothing ('enabled' is already Y). As a result, the only
>     way to restore DAMON functionality is a full system reboot.
> 
>     Solution
>     ========
> 
>     The problem is that 'enable' parameter value is not trustworthy.
>     Instead of relying on the 'enabled' variable, use damon_is_running(ctx)
>     which reflects the true kdamond state.

I don't want to be picky, but ...  I still feels this is easy to make readers
including future myslef be confused for some points.  Given this is a bit
serious bug fix, I feel I have to raise the bar, at least for future myself.
What about below?

	Kdamonds for DAMON_RECLAIM and DAMON_LRU_SORT could stop without
	properly updating 'enabled' parameter value, when parameters online
	commit fails due to invalid user inputs or internal memory allocation
	failures.  The enabled parameter value, which can be stale after
	certain kdamond stops, is used by the modules' kdamond start/stop
	logic, to avoid doing unnecessary start/stop works.  As a result, uses
	cannot restart the kdamonds before the system is rebooted and 'enabled'
	parameter value is correctly reset.  For example, the issue can be
	reproduced like below:

	<your reproducer>

	Fix the issue by using damon_is_running(), which should reflect the
	true kdamond state, instead of the 'enabled' parameter.

> 
> > > [...]
> > > So the problem is that 'enable' parameter value is not trustworthy, and this
> > > series is trying to make it trustworthy.  I think it is bit complicated,
> > > especially for stable@ fix.  What about simply using more trustworthy
> > > information, e.g.,
> > > 
> > > '''
> > > --- a/mm/damon/reclaim.c
> > > +++ b/mm/damon/reclaim.c
> > > @@ -390,7 +390,7 @@ MODULE_PARM_DESC(addr_unit,
> > >  static int damon_reclaim_enabled_store(const char *val,
> > >                 const struct kernel_param *kp)
> > >  {
> > > -       bool is_enabled = enabled;
> > > +       bool is_enabled = false;
> > >         bool enable;
> > >         int err;
> > > 
> > > @@ -398,6 +398,9 @@ static int damon_reclaim_enabled_store(const char *val,
> > >         if (err)
> > >                 return err;
> > > 
> > > +       if (ctx)
> > > +               is_enabled = damon_is_running(ctx);
> > > +
> > >         if (is_enabled == enable)
> > >                 return 0;
> > > 
> > > '''
> 
> Thank you for the suggestion. I have tested this implementation and it
> works expected. I agree that its complexity is much lower and more
> suitable for a stable fix.

Thank you for testing!

> 
> > > 
> > > > 
> > > > Changes from RFC-v1
> > > > (https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
> > > > - Remove RFC tag.
> > > 
> > > When dropping RFC tag, let's start from v1 again, from the next time.
> 
> Regarding the versioning, I have two questions:
> 1. Is version number inhritance only required when converting from
>    non-RFC to an RFC?

I'd request such conversion when dropping RFC tag.  E.g.,

RFC -> RFC v2 ... -- (drop RFC) -> v1 -> v2 ...

> 2. Should my next version be tagged as v3 (since the current one is v2)?

The ship is already sailed for this patch series.  Please tag it with v3.  But
please follow the suggestion from next times.

> 
> > 
> > Also, I just found the patches don't have Fixes: and Cc: stable@.  Could you
> > please add those appripriately?
> 
> Regarding the Fixes: tags, I will include the following:
> - Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")

This seems correct, but ...

> - Fixes: 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays active")

Is this correct?  At the point of this commit, there was no commit_inputs
parameter.  Were you able to confirm this issue can and cannot be reproduced on
this commit and its parent commit, respectively?


Thanks,
SJ

[...]


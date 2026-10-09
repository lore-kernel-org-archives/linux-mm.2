Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EA4CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD75A6B0095; Fri,  9 Oct 2026 04:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B880F6B0096; Fri,  9 Oct 2026 04:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EBC6B0098; Fri,  9 Oct 2026 04:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829596B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:01:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03D40140293
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:01:46 +0000 (UTC)
X-FDA: 85302343854.01.F8632BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 594C84000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:01:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TT+hhu45;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791532905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMBpY4Ja4OxQaFfdpcju0OFEgyiZ03AkeppjckG5j0U=;
	b=DA9JSUBaHc8grMJrzQCYgrVCECCIqVsHP8wmyIOeauNKI8iBuVzFxoYXkRdvao9/mJjQAz
	h041YoJMIY1DeaSK2bDLC3L1J51sB9cy0qxKzvohTpL/mEdI9xiRxRfWOYPvRUUXcT1QwJ
	UQKg4QgojBz2ylt6+ohpllXpF1lCmUs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TT+hhu45;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791532905;
	b=hMdgFoLHRO/PfvGT7Ccek7u2rb1oSJ1DV80hICfmLX/dLfKaFB1nJEi9oBZRK01nKGDjSP
	ps2dMxGMHlgHBz5wnwRPNKQXoP/Hhrw4EEWQ6Z71rSE+tQ2I1mGf0qHQSHAwPwKbilAmue
	93zv7kMGCAZTKcN/Lu6By/XBeKy7MK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C867B43389;
	Fri,  9 Oct 2026 08:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6944B1F000FF;
	Fri,  9 Oct 2026 08:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791532903;
	bh=IMBpY4Ja4OxQaFfdpcju0OFEgyiZ03AkeppjckG5j0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TT+hhu454othJLmsJYnVm+7YlAMThU5/yMgzOlC9SAQXNtTuLoXlH970I5riKo60w
	 zb5uowt7VQPY5jb5JJ6aMcHIl1PDJXH58o2GTrWZCkJfWHeZm6QcVrPmr8BzZ+UvWe
	 G6LyHNJMCmEPp7iUecbRJ+vOLjbZtCsLFL1XKMG9DH9gryVbND6szqAZNxPqW6TWTM
	 13dIiAur6VaRHI4TqCsv7Nlzc88EDXhjRXcnyJxtxyD+XFO9OZRrAbwdnkpekrhyjl
	 3+k9BImW011cHtqoi0QV462qT1qZKhg7+GTA+sDFiifiS98vWn/WTjr/1BIHzSniAG
	 Fj5gWpN2I5PZw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Fri,  9 Oct 2026 01:01:38 -0700
Message-ID: <20261009080138.41269-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008161621.45669-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 594C84000A
X-Rspam-User: 
X-Stat-Signature: n1tpho989o3e9fi1cwtkbjyfbe3eyain
X-HE-Tag: 1791532905-185253
X-HE-Meta: U2FsdGVkX1+5k4xgJvmjEONoqkoZBeEE/kl6hHsUgChAF5LNhehJjLXWV88z614DhRhkvb3pG5wBuVKv0tbCHiGrVleqgoDrpwlXWi8x/lDyZ6Z5zHFtQmrLnwHkPBBZvA/g4fbZ+A00x3ZIjWdEsD1SkoY4c/CXpWIXu22reXo8O3uA8bYtOEW/njMQ1dN3AO3GHCHaI3U9Qba2p+lB/YArvkG17mCbFU2OzRgvj5QWeGxxk0h81ieSiY8hglDLK8bLjm95YTBhIqnqhJUtmC87/xudK+Hl1iOV3V6XZMMEEnujMi0gS9b15JVTIOIEc7imkTPHHbXOPVH6Dr/8Bm047Qb2Fe0sodZLwYwTHcPCwJPhIb48KfyfwStQEqHplevrbT0jYz6212UWKt/LYQCT+zB426oI4E54G1dpLtUEA1bSaOEnlyPIA0lSQUd3nknu+RxGY4nGnnLWKCUu5ncDAAn3WzyC5wGXBaLJAp8l37CbS4YjnXlB32qs1f+d/IlPG8zV5eh4a5pafYAkIUORjw/yb6+AZOu8qenMaSrvNlL4wEvRgl1h+D7lamQeATh6LqFaX/V72MmMQQsI1vlckn2jmbiCyAiGTGgWZ8LT5ML0OLt+28lDe+x0eVbGR29F9K+1G7ydo+gkbULFv4wmmaJoMt5omnG0//UAsabcOIDuLz7+xqKandBu7wIZL+kHoCN0nkR8u1/Py/X8mQQ2h4+17ksOlDf2/YtlrfwgxehOAb5N8PeYqdJRPjgmtSce90g3LG70FWa9KzAVV9rIr6bWP2zUJVVfzLExIcrNLjFiW995f2ZFzTfxISqwoehLfX+WQCDklOEbnZmlwymkESnrPBVMc3vzAI5++6VFwTViPFZl2fNRvQsX6SYol2ofW6jVycLR8INSZvuci1SH+ne+JQwRuyd4QBR9M7pTw2OQDqrZSnTLvTQ0W8D1VKEIyZdIxpbtN8eWjMo
 5Lfz+m7W
 vEp1itwpmVPTEzjgp35EWYnSSaNEtXj8+CKFvVdDFQEGfAFBthtzQiElIFeNZi4CzHqaMgL6NfqWlgd5nEoowjvWlT/5jempIHVXbDqDbHq5vRZneO+12wsuJpMF6va9Ndlb0tzBzTc/dwAUdTUvSrXjITVlj3bSh4+a0OHBC/jMyyNWhJJ5WIQZNDPN2L8dqSXnBgJWEikX0sgBJn2mUrG2CxeKO6IcI5xi1NrBzrQAJuP0G/9H37oaRWOHYTjSVF9rH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Oct 2026 00:14:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, 08 Oct 2026 08:00:43 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Thu,  8 Oct 2026 21:44:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Thu, 08 Oct 2026 05:32:31 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > Hi Liew,
> > > > 
> > > > On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > > Hi SJ,
> > > > > 
> > > > > Just a reminder, I think you might have missed the question I asked.
> > > > 
> > > > Could you please clarify what is the question that is not yet answered?
> > > 
> > > It seems I forgot to ask the question, my apologies.
> > 
> > No worry!
> > 
> > > 
> > > I would like to ask: after reviewing the reproduction, do you still
> > > think this is a real issue?  If so, I will start working on a fix.
> > 
> > I'm not good at reading the diff in your previous reply.  It makes me difficult
> > to understand what the issue is.  So I tried the commands on my system.
> > 
> > '''
> > $ sudo ./damo start
> > $ sudo ./damo args damon > damo_args_damon.json
> > $ sudo ./damo report damon --json > damo_report_damon.json
> > $ sudo ./damo stop
> > $ sudo ./damo start --kdamonds damo_args_damon.json
> > $ sudo ./damo report damon --json > damo_report_damon_aftr.json
> > $ diff -u damo_report_damon.json damo_report_damon_aftr.json
> > --- damo_report_damon.json      2026-10-08 07:56:04.979178016 -0700
> > +++ damo_report_damon_aftr.json 2026-10-08 07:56:27.717941609 -0700
> > @@ -1,7 +1,7 @@
> >  [
> >      {
> >          "state": "on",
> > -        "pid": "46402",
> > +        "pid": "46449",
> >          "refresh_ms": 0,
> >          "contexts": [
> >              {
> > '''
> > 
> > And still it is unclear what is the problem.  Could I ask your elaboration?
> 
> Thank you for testing this!
> 
> The reason it did not reproduce is that no DAMOS Schemes were configured
> during this test.
> 
> This is a bash script for reproduce:
> 
> '''
> #!/bin/bash
> 
> mkdir -p /tmp/config
> mkdir -p /tmp/output
> 
> ./damo args damon \
> --kdamond --damon_ctx --ops paddr \
>     --monitoring_intervals 5000 100000 1000000 \
>     --damon_target --regions 0-4096 \
>     --damos_scheme --damos_action lru_deprio \
>         --damos_sz_region 4096 max \
>         --damos_access_rate 0 max \
>         --damos_age 120000000 max \
>         --damos_quota_interval 1000 \
>         --damos_quota_time 0 \
>         --damos_quota_space 16777216 \
>         --damos_quota_weights 0 1000 1000 \
> > /tmp/config/lru.json
> 
> ./damo stop
> ./damo start --kdamonds /tmp/config/lru.json
> ./damo args damon > /tmp/output/damo_args_damon.json
> ./damo report damon --json > /tmp/output/damo_report_damon.json
> ./damo stop
> ./damo start --kdamonds /tmp/output/damo_args_damon.json
> ./damo report damon --json > /tmp/output/damo_report_damon_aftr.json
> diff -u /tmp/output/damo_report_damon.json /tmp/output/damo_report_damon_aftr.json
> ./damo stop
> 
> rm -r /tmp/config
> rm -r /tmp/output
> '''

Thank you for sharing this script.

However, issue reports in genral are better to clarify the expected and
unexpected behaviors of the repro together.  Please add such clarifications
from the next time.

And maybe because of the lack of such clarification, I still don't get what is
the problem.  Clarify, please?


Thanks,
SJ

[...]


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D786CCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0196B008C; Sat, 17 Oct 2026 12:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FF36B0092; Sat, 17 Oct 2026 12:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD0E6B0095; Sat, 17 Oct 2026 12:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD756B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:27:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0195A1202C4
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:27:15 +0000 (UTC)
X-FDA: 85332648072.01.4D533C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6439F8000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:27:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcXJLNUA;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792254434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsWRQEfX03GTNdb56tV6nXJjKEivM5tx+oNkBb8EiW8=;
	b=rfjGwLYjMCL1L+4rrTjs0ZWLNrPMde5Q+k46YHGBimu91FCIYYQ45SQmyWqhIhHxz+HzEf
	EM6hUwJmrnvkXZ9BrySDcMhm/e6gEhlVIGR66mt228gV9Fu/ib0d7VqtqIk5xGZtolNbDA
	1ga9z4SRB4LLjAkulHwEphWiiqsHhGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792254434;
	b=aZhNMn3ZFOSovPtuqzjc2vGpIyhIrbnWwVzGb5vb9KV2h9NQbmS8VJhSndsUmuHgeg0xwq
	nf7/cpbYpQGVrER+ho4rHbsP5Q08ZPcFqqNVbJ9s9pTVX3YMnhHbZocildfzHLFVgBj0nE
	t57nQr/ALXXEG5sdtFOCWnC6KW2dOLE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcXJLNUA;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D610B60AAE;
	Sat, 17 Oct 2026 16:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398261F000C5;
	Sat, 17 Oct 2026 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792254433;
	bh=EsWRQEfX03GTNdb56tV6nXJjKEivM5tx+oNkBb8EiW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcXJLNUAAE7A1QqxYvjonnyJ/dHuGFZZFHa+Fw/mJNHP09tddIrnZeEPGlfu/ruFK
	 qYTSYHjzR2CyxjvvwTqYHeLtXjj6r6kR40Y56TiM4JzTvv1ZEfQPpFz+HQwSmR5z2i
	 Cwpa/oAysGRTlJS6itL4TLmY3cvMHONyQakixRexzo9FdhxHvLUuGLso2Sjt+apYtH
	 0yXyygobq94FYENsTnKfmi8FE0HLRFGujY/tKEGT0XEnkK4TrVsrDUTnY5khrxrrBw
	 5DshkCSv5rCOlv27ZQb0aySFP8AcyVcgx/28CU5LmH4MAcB29DyiIAUzVW3RPotxOV
	 cO07tYtyxgzDw==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
Date: Sat, 17 Oct 2026 09:27:02 -0700
Message-ID: <20261017162706.103996-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c575314d3e52d5fcff3d6fc47d12dc118a24bd63.camel@mailbox.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6439F8000A
X-Stat-Signature: x5o95fdyj7c8sxbk8e96muufey79iea8
X-Rspamd-Server: rspam05
X-HE-Tag: 1792254434-567074
X-HE-Meta: U2FsdGVkX1+IttOvBgQZhhSkQt+GWkFYHwz6xyA8C6FGG+tY705Wz4baTDgeis4hqVrgo7BCv9M8elailZRO0S2qcID+inKydTe/hofgButXNRLi9051xh6p3bIq+rYMMMMeKPJ2tixhlsSHh6UWLC1vuhsnw/8YwZ4bgXgAo9OToblD5/RaDhEnLrZ6wMY0DG6yCIKfjZLojP1wlx1v13TVX6C/hDDAkED40sKbXuIitSbqIhDhEqux8+TC4BaeA4GPfD09GH2NK2rXteyQ0TgP4awt6q5JcmDkhaZ0cThlJ8PySq0YD+cwqxZcmolAxCuT08kfzF5w+gvApgc9V+w6D6QBCM6DSUc1Ta/vRMnklhj8Dy/pMrT2w0yjsvWJcJRr0ePu8CC4zrHdIhDuG+9ZYSTZ2cVZuhjmLTdu/eByYFnZLyNpgMQwOOe633g6MmPizxSzbNMkNv5ogu5rA1yysohU+fnxlRHhiopGEBGljtXJ0UH1fVuYjnH28liBQwWldF2HfjoJtbectAD35KyU5+rF00jpJR5S+yNykZ0NjSiFCv9d6L00Mz+++7BXg4RZBmfzIU9g6mrg1RrOcc1dhL88u71/f4SyjOinhpAK7E9u7mJ/RqTIpS6il8u3JDzN51JIyBZqwVbqQ8BL1BDrxRDxeQeut4GraRRZOitKbb9t458jeaVaRJdRfqpQosUZnEncFRznJalY+yqa36SoN3+t4lIDp1KjV9VOb51hudrwiK+y0/WGYEO2XZYCFKmIDjCWohWkAP3x5ONzaLpmNsHAi2siGZEZVi+3/ZSgyqJ82iyJyPhs2mbh543SeF7v2NBcRZHUfN07DVyWIkU8q7+Nn1fBRfLmG29woxlL22H1sp0eGCd0G0mQiLRZNH5gdQLptPCfmCuolzH+BvjSuo5lywCAJ1Pf6krTiVuDR2RkJuhNQU1F4EivNIef202Sb7ST6FNVG32FSMO
 xlWpwYrs
 +ZgmMJplquDzLYcByypceIpmiEryBKb0fBna76opbZcoKqXMqKuHuFPsGmySFJsELDutxf5AF5Sgcm0W+cILnuF53LEHgEqfRgyzKRo9UHXh/cO+DW1qg0Lj3Kui0RFPNodEh0DowCT7mCi7EQA+ytFGDJFnpPjJNvnUHleCVp47IK+GfP0eE6HXGhCDCRKqTar8pXcV1WJhtdZMyiOAjSQQtd60r2T0Zfi7Ae8TeC6VXGoJY74xnP2jpndr86k27p9q3AMku5Gj0oK+ES7s3/oC+oV6v2YteXJ7+K765wFC4O/fbC7MXtzc9n9X9g4cKuwkeW7Xl7/RBi9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 11:18:34 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi SJ,
> 
> On Thu, 2026-10-15 at 07:01 -0700, SJ Park wrote:
> > On Thu, 15 Oct 2026 10:06:23 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > 
> > > Fix tenses. Replace 'set as' with 'set to'.
> > > Rewrite complex sentences.
> > 
> > Let's put two sentences in one line, while breaking it for the 75 column limit.
> 
> Will do.
> > 
> > [...]
> > > @@ -113,8 +113,8 @@ quota_sz
> > >  
> > >  Limit of size of memory for the reclamation in bytes.
> > >  
> > > -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> > > -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> > > +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim within a time
> > 
> > s/recordes/charges/  or s/recordes/records/ ?
> 
> For me charge is such a weird word exepct in 'charge a battery' or 'charge a fee'. And
> 'recordes' is a typo. Does this work:

'charge' in this sentence is somewhat like 'charge a fee'.  I personally don't
feel it is weird.  But 'record' also work for me.

> 
> DAMON_RECLAIM records the amount of memory which it tried to reclaim within a time

So this looks good to me, too.

> 
> I could do this in a second patch aswell.
> 
> > 
> > I'd prefer charges, but my English is definitely bad, so looking for your
> > suggestion.
> > 
> > > +window (quota_reset_interval_ms) and stops when this memory limit is reached.
> > 
> > I feel like readers might wonder what is stopped.  How about "stops trying
> > reclaiming memory when ..." ?
> 
> window (quota_reset_interval_ms) and stops trying to reclaim memory when this limit is reached.

Looks good.

> 
> > 
> > >  This can be used for limiting consumption of CPU and IO.  If this value is
> > >  zero, the limit is disabled.
> > >  
> > > @@ -125,19 +125,19 @@ quota_reset_interval_ms
> > >  
> > >  The time/size quota charge reset interval in milliseconds.
> > >  
> > > -The charge reset interval for the quota of time (quota_ms) and size
> > > -(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
> > > +The quota reset interval of time is quota_ms and of size is
> > > +quota_sz.  That is, DAMON_RECLAIM does not try reclamation for more than
> > 
> > I think this change is just wrong?  quota_ms is not quota reset interval of
> > time.  Which part of the original sentence was difficult to read?
> 
> 'charge' again, and I think there is the verb is missing.

If use of the term 'charge' is really making reading difficult, we could add a
short definition of 'charge' as a separate patch.

E.g., 

'''
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -695,7 +695,9 @@ dynamic.
 To mitigate that situation, DAMOS provides an upper-bound overhead control
 feature called quotas.  It lets users specify an upper limit of time that DAMOS
 can use for applying the action, and/or a maximum bytes of memory regions that
-the action can be applied within a user-specified time duration.
+the action can be applied within a user-specified time duration.  DAMOS tracks
+(charge) the amount of memory that the action is applied, and stops applying
+the action once the limit is reached.

 To know how user-space can set the basic quotas via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`quotas <sysfs_quotas>` part of the
'''

Please let me know if you'd like to send such a patch.

> 
> > 
> > >  quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
> > >  milliseconds.
> > >  
> > > -1 second by default.
> > > +1000 (1 second) by default.
> > 
> > Isn't this (1 second in milliseconds is 1,000) easy enough to infer for
> > readers?
> 
> Ok.
> 
> > >  
> > >  quota_mem_pressure_us
> > >  ---------------------
> > >  
> > >  Desired level of memory pressure-stall time in microseconds.
> > >  
> > > -While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
> > > +While keeping the caps set by other quotas, DAMON_RECLAIM automatically
> > 
> > How about "caps that are set by ..." ?
> 
> Yes, this was my second choice.
> 
> > 
> > >  increases and decreases the effective level of the quota aiming this level of
> > >  memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
> > >  per quota reset interval (``quota_reset_interval_ms``) is collected and
> > 
> > 
> > Thanks,
> > SJ
> 
> I messed up the subject line, should be:
> Docs/admin-guide/mm/damon/reclaim: improve grammar and style
> 
> I'll follow up with a [v2], including Aveline suggestions.

Sounds good.  But let's finish the discussion about use of the term, 'charge'
before posting v2.


Thanks,
SJ

[...]


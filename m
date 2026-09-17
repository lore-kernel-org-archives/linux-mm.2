Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E6EC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF7D6B009F; Thu, 17 Sep 2026 12:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B974C6B00A0; Thu, 17 Sep 2026 12:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5876B00A1; Thu, 17 Sep 2026 12:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 902D86B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:23:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 224131203FE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:23:33 +0000 (UTC)
X-FDA: 85223774706.25.BD6BC18
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 856354000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:23:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LON76xnC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662211;
	b=GYH7xZQA5B9kPotKvMnVlUQcvQ819E5rzI5k+e632wIyEd3EwPRf4+HXqcWAm3eJKoeqqH
	dMk1Pama+k4/TcMQdIysnq1ED0E4cI3/lYM5SQ/w+bkXiPDMQDfp6CF1np5AuXoV4aMLGD
	hY5bWuaKCPSPbei/BkCllnhMgL/t5gU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LON76xnC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akxJwcOoJrvjy31LionuZZGpZM3k20wc3rbedtFuCUI=;
	b=sVHic/dlYsVNOQYB6YNsE95Vm7gdXFPSl/ojNIKB8e77GB/1XT+67gMGqXd7nGvnbRTpM+
	5rxaPpsCeWFPc1h2l9JMMQyvmBIMl5gTNi0z3ELOO0aIPzsmL97TWj/2PM1cr2HrjWOyIZ
	trEI6GbVjTzrs4Do6iSMuHgpy0acSOE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=akxJwcOoJrvjy31LionuZZGpZM3k20wc3rbedtFuCUI=; b=LON76xnCeHbv2ylczLrJJF42Wu
	yOy+OAZXXgl93ZHt9cCEq6IsAl6qiI0NjT1zz4oDHHi4s1+yqNeRPBfyqGMQDeUQ1Ptr1sBPFxePm
	lYLHliWUlJtZB+c8QKojwptdjZnpwRjedSUTh9SvYgMRiWH6oWwp29dGqobOj91gpqjxcOT2U0wbV
	RXFyFIUk6e/EEtKYC/lxFq/Wfqjg19F3opRtlAasce3lkGps0GdnLEr0UttV6k8/rhTRRyjZLnmHs
	BtNpl1SFml80noMK9mg5aH9wp6PS6IW6xuJIkxfl6ynACjQ9CEuX01793uKLjj6ML9aIWIilpQgfL
	Qqq9Znsw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7EtR-0000000B13U-2L6c;
	Thu, 17 Sep 2026 16:23:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4FD47301BD5; Thu, 17 Sep 2026 18:23:24 +0200 (CEST)
Date: Thu, 17 Sep 2026 18:23:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <20260917162324.GP4121339@noisy.programming.kicks-ass.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <20260917160827.GN4121339@noisy.programming.kicks-ass.net>
 <aqwSBkeP-Df2GBLa@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqwSBkeP-Df2GBLa@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 856354000E
X-Stat-Signature: oi45c5tr4scs3bmihxia8grrmawzc4fi
X-HE-Tag: 1789662211-214463
X-HE-Meta: U2FsdGVkX1+Ms3rTVCoS2Ys1lNQ+WAI3O/6Lff1qj46pal+eMSkOKNm5Po3HjyLYZ8ztBMcK5Bcek3g8Zm3YFD3vRMnW0ZWl5TdtLBQpu7KSfN8anHrvzgCi36+R8vx7vkstzINwg3hmVaCWuQDjRu9kP88/VhjAKR4cmPcdFcWmW3Mi2H7RSPWhMydTjM2HjXkeLkcwkOZCN3WDwvh4KYCYAcQ2A3fb5ncKOqdkVz9IFDaQUMrHowIfwSfmrsk5RAdz3gGh4fBfYwD/N5fSLdMT5RehTzcSKqNfJ0udKharsPxwJzWuY1v3wZeLLXyWZWU61DA46KJNxm2/DMb5iFGTuqgKn3IF+xA8b3cSrlcTTaXPx7qDufYY8KbrOwdDnqvCmy82hS+VAv6hWELle2dqBRa6GM4Qds94N9a8+J7crAqUGeISuNX3EZBLVhvv6kYiSrWxCyPkaN6p3M5YLchxE8bkpsR8EsaSLG0W1LXd0e8tgjXpZbwHcX5bt63/3DOsAFM57EQmhQLmmag9ofzSinaZyZnmLQuyi7dCh850HOVOBqCi5tqP6IQT1sd+lHBSmpxjocA+z7lEgQr5UlphsUgTj2G0ZK2j/8c+HoGU3taHSs6Qra4F9fHc7MEwMguxSC/SRgPX4Qr4tv+wVf1x0/I8kORujFKvh5RaM2NyAm043GCHO/cfEI8jdPqjCQEfDh9pMb0h+1IsZIRTnrcON1Yg5eACoxxo5z3yS4TWg1lgjHiqpANSBunxWbjk5Uqzqfrn2+sCEaamDtjSJBnDAuJ3VPdokpuqVw9kPep5QeBnAK0qaSkqOOh4AQyebqMSpCvsHYiw2iZshJfEEDY7O9Zyo7PXntnGbwxvIr0NlD8vTAi/udJIRC51zWwqwASFxR0kQ/yTW5Ti9G/T9CyjyU3OPYWme0w56kwnAFu7OsDJ2WLYAlCyWa/+2oOdby2n56HUaVeISlZibK4
 e4R2sp1W
 axZJCodEMTmKp8xpJE9rc/DuQ4g71tPwnmxBTcOwHDhsL3HK7WPxuc79s2QeXGalujjFtopL2hOrV7yi19z3ymwbNDFRizZpt5dkw9q1gpH8RA07DfYk7Ww/yVAQuD1d0rRUNQ5DoYysn9BBeI6QCJzWf5jQvIx62LCfISDIr/fHmce5jX/b+MhKVyyJWq0obXjMHZvQjzLF/hsnXfHAbJLNA1GdrCRUk0kf/V5qMDYOPKH8vX5UUlZi3YO9hvjlgk0hPgAI7O0nAKEOORfEmNlAt+U9WZUO6H3Jq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 12:18:24PM -0400, Gregory Price wrote:
> On Thu, Sep 17, 2026 at 06:08:27PM +0200, Peter Zijlstra wrote:
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index a369d0c95c38..afd9c97d2389 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
> > >  		/*
> > >  		 * Do not migrate file folios that are mapped in multiple
> > >  		 * processes with execute permissions as they are probably
> > > -		 * shared libraries.
> > > +		 * shared libraries, unless this is a promotion from a slow tier.
> > >  		 *
> > >  		 * See folio_maybe_mapped_shared() on possible imprecision
> > >  		 * when we cannot easily detect if a folio is shared.
> > >  		 */
> > > -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> > > +		if ((vma->vm_flags & VM_EXEC) &&
> > > +		    folio_maybe_mapped_shared(folio) &&
> > > +		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
> > >  			return -EACCES;
> > >  
> > 
> > Semi related; I've often wondered if we should still account shared and
> > pinned vmas in the fault statistic, even though we should not migrate
> > them.
> > 
> > After all, those pages are still used and by not accounting them in the
> > fault statistics, it becomes easier to migrate a task away from them.
> >
> 
> I don't have a strong opinion here to be honest, I'm just trying to get
> tiering back on track.  There's some scheduler voodoo there that I will
> happily claim ignorance on, so I just tried to keep things as-is here.

Yeah, fair enough.

> > Using the scanning for two different things has made a mess of things
> > though :/
> 
> This has been my takeaway from this fix as well.
> 
> Honestly I'm starting to think hint faults are a big hammer making up
> for the lack of hardware support for getting this data.
> 
> Would be nice to just have the hardware report what's hot (and how hot)
> rather than depending on a software-heuristic like deriving hotness
> from a page fault.

Yeah, there is/was this patch-set from AMD that uses their IBS counters
for this, but 'ab'-using the performance counters for this also has ick.
PMU data isn't ideal either. Mostly they generate a ton of data that
needs to be analyzed as well. Its not clear cut and easy.

I'm not sure there's been proposals for better hardware support.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C66FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AA06B0005; Tue,  5 May 2026 01:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBC86B008A; Tue,  5 May 2026 01:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201636B008C; Tue,  5 May 2026 01:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5B96B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:05:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 926A7C01D4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:05:04 +0000 (UTC)
X-FDA: 84732176928.12.33E465F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B98D1A0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:05:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQdIe8ip;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777957503; a=rsa-sha256;
	cv=none;
	b=X9T2Un5J/SJ/nNNfOWrMwqvMsC9QlaS85Kk2lbryB9Fvb+wg/lIHClZTRlWwipJP9IL8DQ
	gm5DBtAhx7b3SQIUk7UnW1XqXu6atD6G2I1x2i3KmwUcRY3hn/INrg0W540+Y2vAzjIADK
	Sc3Se/uTdiZaq1w21zEl//6W5HHVg7A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQdIe8ip;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777957503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leYUW52eUVmjA3/N1Q3p/hGukPOapRF/Sg4LgJrU73k=;
	b=h2j6o2Q9KQ52QsrA2JlKpQKOdKmqRhxHzG9LpR9+GKOFvDbfsJDO1BzdYwdrdTyFOUDpBY
	s2PYKNil7GBrPG+w+381ZAAs9pHpR+M55XTRx+df5VSd91omFnMCWKlrROYHtNiQsW9MHA
	WpO44/1MCpR8/gHXmJ4l+CJYLQyxBn8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73F724327A;
	Tue,  5 May 2026 05:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED059C2BCB4;
	Tue,  5 May 2026 05:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777957501;
	bh=ulYwfhIrZiiyOA+ej0SzTrh2d/+ULM4vkEf6B8JaKfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YQdIe8ipp3zoPQt/M1IT100RhJkC1LW7HKyjFJV5+jOWmbpwh82QuzbAQDo5jHwcH
	 zXZ1pTxLQu3i0metigYKkT9eK/TSWmxLHxaSnrXUlvjZVlh5yHVJAHUfUHsYJArZjg
	 qnzp/NMRdY+bXEj0RqUZJ1/sGsTnM3Wxbu0y/KABvw/LSoGO2CC26cYIjJssFtu0eZ
	 gJMgVE/nHI9ss534NzOBzovG17IXtAPTv9e9xXKHvg6kuAFYAZWYmuVQsDFPz+PFo7
	 h1b+OOmlAr9lI5p8WhktdQhvYSz+abjWJ8Aj896wtbG2xwjbvpoJKzTUfzeo6f+8Ep
	 3I4JbmUkM80Yg==
Date: Mon, 4 May 2026 22:04:59 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afl6e__ljPCkVX6j@google.com>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afhQB0CWEcflXpOi@tiehlicka>
X-Stat-Signature: 6i33zmx1izuxzckejoi6hs6p7iub7y6k
X-Rspam-User: 
X-Rspamd-Queue-Id: B98D1A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777957502-884272
X-HE-Meta: U2FsdGVkX1/nbd1yrtMghHpQt/hqs9NczwJGTTVROSvt8yd2hth2Q1cN/AY0zKJWCBT67LWU8eQN4bSB0yKLNGv6qhlydPk7MBUSQRsy+aHe9EtO0hqjiuxxQzAi4uu5hkB29v/6XKnHPaGF1Cd16GOAE9Mg5HFksX5C2RKmBeElTumhFweH7iKbTFexTlNEgnRrzJNRLmhla6XGW09jzeKeQkzFSVfpHyJBHRyIvTWJK3rG9IHipGFvUyYX8sgfGcJBK1ciH+7Al5CI/JIOtf5z+gMEOyWKlze6LHUyvg4Pq/IbhswbNyHi8OOhRDDObDvWOJyLg4r6lrnczI+kf96NGZYUEzZXCOwS0RZRjypCkmD1xb6nMVgAKUfkCf05BZFBzOPNjt6/mPtMnCKnYWNyCBSg9Fh5O0YgnyfPW3/Pd8/gT6pkhi4Qhu/tOuHIkKaPiH1NdCYAHGPXFWQ6ew/kRc3X8akXnX0zKyz3EoK8dOeBs6w0H1QUiAf0DhIm0Rdv+jJdRIjy5gvKDUGEIc/AHnXj0pJ7nx6iVs02iPdSoZZ/6QqQ8HwbISw6aBA7YmVxNnTOgFuL7vyMKtmBdWIwZ0ihdl36nwzCjUeJeBsfe5UXEkWdm48++fRWtSJ7jfz3tu5H5vcj2mwt/wVHT1eKt5LEy3xg2VOtOdF5ek+LwSVHOR5a8Wyb/cNol9fRwtyaH5dp8Cr/idFdNqlcFdrM6Rc/54x2baJlceEWXDio2698G7UCt/oAZJfAosdMwlvqgl21i+UxQV03ibRcZtZUehRaupHQygpCpNu+MQXarUiQI23nUaWbuCStoKZYoqm1CjGeJgmBX+85YWyC5tnSfia+HXwmL2s33Y+TqElmYiOcJ/4cyhNu1RIdkaon+igURP29HYj/tPQUAfL0rvOf1xh4s9Nn/ATcLlsHlaOjC5N7s7tk9nOa+th7HJ/GnRJdioTD0Bja2pSW7l3
 m+Z44chY
 lt15ApkUCpqV10VypiKZYNBDKp06jNTCafOUzCYozVGaVCEJsebcv5lNWHp5JD5eW2LEPPsMqAqbq3M/6teSWeVUbFViX9vsifPkhdoW3XcvBM+LqjCFumMkNxBaHgZDEVGzoG8KunQU5X4xZqJXNx/MP+LP1TooRYd5omdnPXlmjjmd+gM4Af7dLL5h1CgPHvTDlr2G4U3enP6oG4kGKdSx+ILhnoaVfo4Zw7lGiEJk+TdoF7KhtCGdW6DHM+cBLieS8WItOMHB2/hYCsPlQUd0B6H4Hbs74buVjveCovyK8LLFKHWTrNRv37Uc6UyZqB/R3x2RzRZXJL8NiAOI7ZoNPQFm9p32aVNcX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:51:35AM +0200, Michal Hocko wrote:
> On Fri 01-05-26 14:17:50, Minchan Kim wrote:
> > On Thu, Apr 30, 2026 at 11:55:54AM +0200, Michal Hocko wrote:
> > > On Wed 29-04-26 14:13:59, Minchan Kim wrote:
> > > > This policy differs from the global OOM killer, which kills all processes
> > > > sharing the same mm to guarantee memory reclamation at all costs (preventing
> > > > system hangs).
> > > 
> > > Incorrect, we do the same for memcg OOM killer as well. This is not
> > > about preventing system hands. But rather to 
> > > 
> > > > However, process_mrelease() is invoked by userspace policy.
> > > > If it fails due to sharing, userspace can simply adapt and select another
> > > > victim process (such as another background app in Android case) to release
> > > > memory. We do not need to force success or affect processes that were not
> > > > targeted.
> > > 
> > > This is a wrong justification for the proposed semantic. You seem to be
> > > assuming this is just fine rather than this would be problematic for
> > > reasons a), b) and c). If there are no strong reasons _against_
> > > following the global policy then we should stick with it. There are very
> > > good reasons why we are doing that on the global level.
> > > 
> > > If for no other reasons then the proposed semantic severly criples the
> > > shared MM case. You are left with a racy kill and call process_mrelease
> > > approach. You certainly do not want to allow a simple way for tasks to
> > > evade your LMK, do you? So just choose something else is a very bad
> > > approach.
> > > 
> > > So unless you are aware of a specific reason(s) where collective kill is a
> > > clearly an incorrect behavior then I believe the proper way is to kill
> > > all processes sharing the mm (unless you are crossing any security
> > > boundary when doing that).
> > 
> > I agree that in the case of a global or memcg OOM, the kernel deals with an
> > emergency, system-wide crisis where killing all sibling processes sharing
> > the same mm is an absolute necessity for system survival, bypassing
> > user-space privilege screening.
> 
> You are misinterpreting or missing my point. I am not suggesting to
> cross privilege boundaries. The syscall should fail if the mm is shared
> with tasks the caller cannot kill (same as it does now).
> 
> > However, process_mrelease() is an explicit user-space initiated system call,
> > and I am still hesitant to place that same raw, destructive policy blindly
> > at the UAPI syscall level even though I don't know of any known security
> > issues right now.
> 
> This is very wrong argument to introduce a potentially crippled syscall
> semantic.
>  
> > If we really want to go that way for the collective kill, at least, we should
> > evaluate signal authorization (kill permission) against *every single*
> > sibling process beforehand instead of only the target task of
> > process_mrelease. Do you agree?
> 
> This is what I've proposed already.

Sounds good.

One thing to note is that this approach is still not perfect, as some sibling
processes sharing the mm might not be killed due to different UID or SELinux
policies while others are. In such cases, the actual memory reaping via
process_mrelease() will still fail anyway.

If we are okay with this limitation - meaning it acts as a best-effort
approach where we might end up killing some processes without successfully
releasing the memory — then I can proceed with this design.

> 
> > Also, I wonder what the signal/process maintainer thinks about this approach.
> > Christian Brauner <brauner@kernel.org>?
> 
> Yes, this makes sense. There might be a very good reason why we might
> not want to introduce a way to kill cross thread groups when they share
> mm from userspace. I do not see any as long as you keep the proper
> permissions for all affected tasks. Maybe we cannot do that sanely now.
> But these reasons have to be properly documented. You whole argument
> that this is different from in-kernel oom killing is just not valid.

Okay, let's wait for any valid reasons or concerns they might raise.

Thanks.


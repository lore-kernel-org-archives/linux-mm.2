Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC9CCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E34F6B00BE; Fri,  1 May 2026 17:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693C36B00BF; Fri,  1 May 2026 17:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A96D6B00C8; Fri,  1 May 2026 17:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47DF46B00BE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:17:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85C89A031E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:17:55 +0000 (UTC)
X-FDA: 84720113310.27.40B41B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1DF6180012
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBCThL0Z;
	spf=pass (imf06.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777670273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T2n/KBbW3NBL55cGdlKQzPZExIb/r6p2VnlOAy9tW0=;
	b=78ipwYdkJQE6sqe2v6s2QDD1yiSXwCz4yTizVvPX2Qs6347U/Zi7xGEqBSWZJQWHXS/AXh
	fnOzHsMmI+2wsbKhHoH0hIUpc37TlVv61V/xGtyEXM1e/YycuU7SjYF3ze/dBywH3FNlZd
	F7Kz1Yocwexa3wwebtWqL5GTor1VMbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBCThL0Z;
	spf=pass (imf06.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777670273; a=rsa-sha256;
	cv=none;
	b=BBkq25mrd6prjlliwDFJe8bgg+j940HcmOsp0I00NzvYuJe6VTOg9O9xDTfKbjMbodmiSK
	eiHntpoltpUyJbiy4AGodAca2m8cWCPLqp6ge15vswMhXE/wZeG6s/2Sj7D8FaEXRzZuOl
	wz4VuChLEnNX3S8cTH1Z5eqUxmgoEQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4F4741880;
	Fri,  1 May 2026 21:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201CC2BCB4;
	Fri,  1 May 2026 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777670272;
	bh=vlOkMj8GrldfLKQy/WTdxUydoj8upb7F0jPdovFF7F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jBCThL0ZUOciVlUdDPlkZOk2cwVOOm8Tbr2iNkMf1UGQrhNwVAoYKLFZTpPGFIugP
	 CqIPbpV2kLYCf98CGWmWPPj6kC5jgCpM6j2ptLOpMUKKF3lFhrXG1YmCUhVoADAayI
	 kJl0abVkEp8vQhV144UzJ7SeaBM5+Nrw3EneesVRY12GOeH95mQQuElzJpImNe8ygq
	 ZIwcBr2eGznEeLx7R3QktlCeMAd6ttF4Ov8uCuxvX/cvkctsDe/NY8BkUl7IBTC+EY
	 FEPU5ZI3zs5pRja1ojW9ao3vP6IaxyzGTCsDFql6UajD++8QUl6QYku9G8t22L60lr
	 ElPjU2QMNNO7Q==
Date: Fri, 1 May 2026 14:17:50 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>, Christian Brauner <brauner@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afUYfpwWsUQoB9hz@google.com>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afMnKrYT0xG_a-b3@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1DF6180012
X-Stat-Signature: kabgq7gbuky4mq3h1mz3z6r5rmaqbzon
X-HE-Tag: 1777670273-516519
X-HE-Meta: U2FsdGVkX1997K0YiLQG6GjGsd/q23cMX3AE8BymJiO8vhDieqq/YbMjuv4G86JSrFp+MEczAWEqAWQTY5hhw9t0X/3/H9EmNHuJvSYXlfvPC/Jw0SPn4Zn1Ql9z54pqiEEhfUPO6Brsga/ulLigQrJpGFiW126dXN6X9qk0dtnX/XtV9CsNnhuypyWY4TafZPTiiM/i9nTzXWAa2O+OTqhRAM8I6Kx7RUl6Og/FyZ0nu9rEIukI7i6nEmK0NQ+6s7PwXcJX07BqwdPyJQvmcZ5OI0GAdMTJK14CB9HtR1Q+hKqybKwRuC7CGev5K2SWZcbxCDCCf+7D9CtcGx/+k/fg+B1hrAFxNV6IrFYvnVAxBk6Ko0WQjLe3DH9ZlU3HovfNGQOB4bo32Y3yTmXUfpa3P+wGVfcAjWD5ectrIClnHU5iSHKX6mF9cnUIyhFoLvMiaiOUgXTxzomd09T1B58vKdbjgvbm6I7r1JVq8ZzIUvEVs2BSoRPePF5f9Q8M13bv3DS/P2dzm3n2GteUgcjm1ET4YMrkfchwB/8ubQIHFobQOsKWHJdItdDdYIuJ07p1TTJjb+tS/xEVGeR4+FSPeQLsUoZsu9k45nW33rQXM5yrC7m7AKIx2hIpO+JhIZ4AdDO3wcaqdaNFJb9f23TiHLbRyogO1ZcMHSeWlRsk+71gEIFRpR3SQtDq8jEuIf1D7FFSLBYllRS7rOGC46Nkvrqg1X38AoN+CWRW717aZ3Hadv8B6fuhkRu1TpANcc3oFRRVEmfi7cUeCKX/MJNSc+lCA9MS0hzdjM5DRr2OJi7kuntASkt89wT0HtPbGn/Vs5nuMxP848fa+2OtIOX04qeu+jFJ16/Aa02i7YPzuVGyUEQ3zqfJX/daZH+WaDj6CH4YDZvVFFuhZNy4v1t+Lla6xvwNCY4FX/VDGeptFAgwkJS7J1gGLM5EjBGVuTTYXUoNb06hop26SIJ
 oR0HyoJg
 1Gh0XMaqIhC9x0hePhEXJK1cMSLRmJzc11mnXWnGN9YHvVY6o67hxmqaK2C3s6/roP9KzydDZjLU14lHcOrq1cROllTccZuV6jcVHthJS/KbqajOLQOI1WqzzN491enfNZO4HJtQHKV/1RHgXyumwMYX+XOXb8MPxvzEb5NBuybaWMy7CeUvOtgOP4hb3NUwMPb0d4QbMuvAFb+APUFn3eAvHxHTLiJdLg1M7pNykHYD7uKmn5QyIuMFwr43c0IlIMo0Dt4BnIXPZOt3o1vFYF5WXb6zmxHJ7UQCTEbXyTMOwatkKubzdLjYu6DqwkPcf5upu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 11:55:54AM +0200, Michal Hocko wrote:
> On Wed 29-04-26 14:13:59, Minchan Kim wrote:
> > This policy differs from the global OOM killer, which kills all processes
> > sharing the same mm to guarantee memory reclamation at all costs (preventing
> > system hangs).
> 
> Incorrect, we do the same for memcg OOM killer as well. This is not
> about preventing system hands. But rather to 
> 
> > However, process_mrelease() is invoked by userspace policy.
> > If it fails due to sharing, userspace can simply adapt and select another
> > victim process (such as another background app in Android case) to release
> > memory. We do not need to force success or affect processes that were not
> > targeted.
> 
> This is a wrong justification for the proposed semantic. You seem to be
> assuming this is just fine rather than this would be problematic for
> reasons a), b) and c). If there are no strong reasons _against_
> following the global policy then we should stick with it. There are very
> good reasons why we are doing that on the global level.
> 
> If for no other reasons then the proposed semantic severly criples the
> shared MM case. You are left with a racy kill and call process_mrelease
> approach. You certainly do not want to allow a simple way for tasks to
> evade your LMK, do you? So just choose something else is a very bad
> approach.
> 
> So unless you are aware of a specific reason(s) where collective kill is a
> clearly an incorrect behavior then I believe the proper way is to kill
> all processes sharing the mm (unless you are crossing any security
> boundary when doing that).

I agree that in the case of a global or memcg OOM, the kernel deals with an
emergency, system-wide crisis where killing all sibling processes sharing
the same mm is an absolute necessity for system survival, bypassing
user-space privilege screening.

However, process_mrelease() is an explicit user-space initiated system call,
and I am still hesitant to place that same raw, destructive policy blindly
at the UAPI syscall level even though I don't know of any known security
issues right now.

If we really want to go that way for the collective kill, at least, we should
evaluate signal authorization (kill permission) against *every single*
sibling process beforehand instead of only the target task of
process_mrelease. Do you agree?

Also, I wonder what the signal/process maintainer thinks about this approach.
Christian Brauner <brauner@kernel.org>?


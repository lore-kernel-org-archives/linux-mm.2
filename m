Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5C0FDEE28
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB676B0088; Thu, 23 Apr 2026 19:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CAD6B008A; Thu, 23 Apr 2026 19:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398D56B008C; Thu, 23 Apr 2026 19:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23D6C6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:43:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AE4E12062A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:43:53 +0000 (UTC)
X-FDA: 84691450746.23.7CA28FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D108A80008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:43:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdgSbMUb;
	spf=pass (imf30.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776987831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbRzdeDcPqrC9w51AYxbOS+lzicIUTy6xwufhVWXV6k=;
	b=t7/ryVW1k9W3SqZKdx9YzZO10Gyxx7dp7vELzWQFx2BGICtJS8C7xUpVnHGzBTV6hGMByv
	3eRKKZ2a8ckU1tZ3AKhj23BQT1FytrAN+FuTyoXZua1MnN0XK/8IN+0Jj1LyDCoMX0elMe
	eg38xze4FHj2Q0itI0x8Btn42COcdwk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdgSbMUb;
	spf=pass (imf30.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776987832; a=rsa-sha256;
	cv=none;
	b=tEegoHZIck5eASmQ6OV3ySKZ71yekVfCB2YXBNalo+hsgadOAT3Sp8y/UPaz2GvU5+WBAi
	3QoPYJ5oFmyEfUTxXknvAxX85RrtjGrgGt7Ce+57h7e+2NiJkJBHR10tBnTDVPj69AYsXn
	Cu/Euo9kO73DBMLjEYdyPM+2IC9HhKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C561042D8C;
	Thu, 23 Apr 2026 23:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776AC2BCAF;
	Thu, 23 Apr 2026 23:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776987830;
	bh=L8UjojQ4C9OHvxfnYPiaBUQe+uUACvjG8z63K3NPYcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VdgSbMUbmTZtntLFWfuHRn0Ckp56gsL/T/g1o4+oezFMJCeAnfvYUPSGxMsgFjXLU
	 q1aBdJTqBOaVLEAFDl+VWbtlsGepfoz3K38b/I1/txOYjhW92x3UDsMlZ/wvA9vD1B
	 JMdkgcGqpz0mUCOwffTZLnum87aPWLWy2jAJf74VQGssWigSRDrQzW91Rgof1c2JTR
	 uFdh90VZt6WBKlI7zAVcgpmBjnhGyA1q9CXIMgOEUsyeDD1W2Wqz6ul1+7LK8XwUfR
	 hUdgQy0LfeYjj7goWK0NjgbvjB4EZbg2VNMV22yz9JUwYx07eUaWL9CTtR+FUpNEo0
	 PhewFnAmCnU9A==
Date: Thu, 23 Apr 2026 16:43:48 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aequtFtklmfbN7n0@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
 <aeHTcXfCyCED4WSl@google.com>
 <aeHbf7joGitRz7rB@tiehlicka>
 <aeae2Cl4ybcx0fHA@google.com>
 <aenHk3E-1ZIRI2YU@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aenHk3E-1ZIRI2YU@tiehlicka>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D108A80008
X-Stat-Signature: n5w1ow66y9u7ecoionagzbwxtzcrjtxw
X-Rspam-User: 
X-HE-Tag: 1776987831-644175
X-HE-Meta: U2FsdGVkX1+VM0Y/bbll3K7l7QQ4l1tOnkL9uB2zGDYXBfuSEJ1oWH+7mmTfRN00wmTsLAWr19rMSLthIdTziB9m394ExwzweZolLZICck84REJmeQvljIG1jhSgieewW3TyS1k5G3DKA45RejzB9EyRuc/IfOYICL/j5TGUIsfuYq8F3anx3ZlvpnbuHubbpOgltxddDRvlto7u676V0Yz/htlUmHC144sNSDvLher7sEeLzHT3BA5L2eeyp3wGQSnc8Ti6ctfsqdVH0/27/QIePFrgKRFCH8LKBDVG6P1GH0TU03iqaKmBSY+1cWjBNqNxqHI3u9SCtldQCKEg5YyQlFGw4vtLIRjn7fYpeFwKXBZ8LPvbDZ9RQRnfnkCdRdoK3I61JAX74gdPOXcfIW2HQDStcKHRGs/p6PPDiDINLAKTwHuWrqyZtETxH+uJ/wNXjL5h6CDaEb8GSUvcPfdRflYFdGaYwxN3/n7uywOxmvbJPMg5MetH94BaTVZpDUITyQRdHT3tKMhQo+tU4/S6y/6rLOkgSx1MTgAvwX8eMgUde4IvHr8XwIhk9tl8PNar8+ZwA0SFbHvcwx7RbvqdIeKaTIW13JaIj2WzWDgD+6kfvnuMDCtzPP81U3/09MQlAA4Ic9OQXI6hOJtn35ksrV9/reKgUUpviMrQr+cEY5qA/3UVU+lO5TxAwWzkQxin/r+7pp9PwSl4z+nFdgZxAVo1CjBEbfpmDhcimapzMD/PU8t1CLJsvPLIaru0IjlwMJf3Uqsc7+wTjhUqG2O8lJj9UIbmycqlBT65w9NHbEs663aE0tpmdHXOZQtYrPevKmnE3b1nBGtjRIg/ChtOFY9MXJBYJcJhD+RaM7jDefSkYeiX11q8NwgFsuIWnm+qFzhlvu5D/YYpBIKFrTOEtvPVx3nAXGWLGo4z8t7ayYTexCG56oVD7NYV3syBmx+xuxYq//jmJgkH9Cy
 kvOZv3qN
 wSwA/a7M6pTsFTYUHSwgS592yENHkgAQNJN7ZR4f54hh2B+AQP/13D+jQ0CwSR6dvEbkd4UcREbwDDWMSQ8GB8yI2vxEous6xy7LGwittt0yjVcLIsK4LLme9c7etsKEJ8FhbwbtZjSibsEk402Ji6URCpOBDJw3HIwQbdIQv5H0aeejMClKIhoX5FH5OJMYIyaFOPS32L8pKlhEmsM258Yv18h7jkMQ6p3awsLeFrqweVmh+Sul2PXcMuglrQ3ypz652S9f/rLgcujnG+RqWeDV7V9aT8jrQHAXK2LBcPtQgGprmqYa+O06q9FAY8oBSgPBd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:17:39AM +0200, Michal Hocko wrote:
> On Mon 20-04-26 14:47:04, Minchan Kim wrote:
> > On Fri, Apr 17, 2026 at 09:04:31AM +0200, Michal Hocko wrote:
> > > On Thu 16-04-26 23:30:09, Minchan Kim wrote:
> > > > If I send the SIGKILL first to satisfy the process_mrelease() requirement,
> > > > we immediately run into the scheduling race condition where the victim can
> > > > enter the exit path before the reaper can set the flag.
> > > 
> > > Why don't you just grab the mm before you send the signal and then continue
> > > with reaping? You just want to avoid a race where the victim manages to
> > > process fatal signal, start its exit path and mrelease path losing that
> > > race so you rely on the exit path, right?
> > 
> > The problem is that process_mrelease() operates on a task obtained from a pidfd.
> > 
> > Once the victim process receives the SIGKILL and enters the exit path (exit_mm),
> > the kernel sets task->mm to NULL.
> > 
> > Even if we could somehow hold a reference to the mm_struct beforehand,
> > process_mrelease() would still fail because mm_struct via task returns NULL
> > after exit_mm() has been called.
> > 
> > Therefore, we cannot simply "grab the mm" before sending the signal and expect
> > process_mrelease() to work after the victim starts exiting.
> 
> I do not follow. Why cannot you simply do this

I misunderstood your point. Do you mean this?

https://lore.kernel.org/linux-mm/20260421230239.172582-4-minchan@kernel.org/

There are more details to figure out.

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..b80a96f5460a 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1241,9 +1241,14 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	if (task_will_free_mem(p))
>  		reap = true;
>  	else {
> +		if (flags & PROCESS_MRELEASE_REAP_KILL) {
> +		} else {
> +			/* send SIGKILL */
> +			reap = true;
>  		/* Error only if the work has not been done already */
> -		if (!mm_flags_test(MMF_OOM_SKIP, mm))
> -			ret = -EINVAL;
> +			if (!mm_flags_test(MMF_OOM_SKIP, mm))
> +				ret = -EINVAL;
> +		}
>  	}
>  	task_unlock(p);
>  
> 
> -- 
> Michal Hocko
> SUSE Labs


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434B7C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE40F6B0089; Mon,  4 Aug 2025 08:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93E36B008C; Mon,  4 Aug 2025 08:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9B96B0095; Mon,  4 Aug 2025 08:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 970556B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:08:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10EEBB70B3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:08:23 +0000 (UTC)
X-FDA: 83738952486.25.776B3B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D79C1C000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:08:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309301; a=rsa-sha256;
	cv=none;
	b=gvz1wlpITn3R0O5M2qa3KFwMm1HanJWo54LbpkVmQjV05a1g5Cw1uwT6u5HaX43v8TK2fF
	OUA7uAjhLJ9PkZNzFQyrvDgYvAPyr3qe8lQ8wHWEOItr+KNQTgIVtPOBsAA7laUngurnzV
	UmpVhzVP4rBIuisQAQxrDGunZI1Bvx4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0a+sWP3mGqHzZa0IHw4Iqf9uFeHL+V3UMBkfLJiNIA=;
	b=SqtvUxWraKyiaxFfFQ886JWZOBYSnye3ywW1Y8FShVq/JjGFV6j0VWg6tq7AmWUWwlOn8X
	SPrQ/bHh848A/HT2ik5raCxS0rbndjoMje7lFUkMc/KnkGEtpM4SbVGCr+ftf3ozQwJQ9m
	imnWE3gXZdVwEPGw9EK7tRCBqxASDJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6D45418E6;
	Mon,  4 Aug 2025 12:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407B1C4CEE7;
	Mon,  4 Aug 2025 12:08:18 +0000 (UTC)
Date: Mon, 4 Aug 2025 13:08:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Waiman Long <llong@redhat.com>, Gu Bowen <gubowen5@huawei.com>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	Lu Jialin <lujialin4@huawei.com>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJCir5Wh362XzLSx@arm.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
 <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
X-Rspamd-Queue-Id: 4D79C1C000B
X-Stat-Signature: qnbufh7oaajutw461fzznusrebjwyho9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754309301-431356
X-HE-Meta: U2FsdGVkX1/bXBfxDxyePn6a30xmm7SV0UfHqhU8l6qn0WDEaYltZMmhyhmFM86TCm2/Svo2oDPZy+yt1XnHyhhr0Q6DK2DMn/RY6DRl+AqAH8SqQputGyq8S4ctVTBVxowmqhIcT2e0vMMNP95doMSdwm2+9rOLc4bIZX7K/CJRVwZoZ3cP/tnUhZT3df7Wy6uypgqBxqxpWQxFmkghGEBCqZ3KWTq653x59Ewm6VcvAtg4nQR9f9Icza7kTIfozW6Phv13JE0GgDUXeQHFhIsjXe3RVkIXIfIxC8nZCcJEIUnzpTF3wGV+IuFO3iCtm5v9LvBy8vu40XBt00F6X81+PGyCYyLNP6CnebGpTtoXeex/eEKYAGS18nBLfVYAZ81UljE4I4W/kRYlL+ugouc7gTMLphtUYZsO6QHq6PypVBqKoc70rqXg/yWgL/6fsnOBr42XDgRoEfv2bWZvHHunAiMa4ZVDxGWTNyYMPy9nRLqsQPLBwlKnelOIiJfiWCa4BJ6ztehh+Nn3i+bHELviYd/l/K0UYWcu8LvlPLfNgIBtNIjj+VJ8ZLFn1qqS3MsomNdCiYg1D0hR6vI6g0A7WKKgPg1d9Ew8KRSXs5ZMSMAjMnZkVUbi6B1QKrQMpYBu9BHSHvmxOflIo/gkwbwMjC1qA7NLckAxJDTAwDnDChVKCtws5xkx/G01t3kydopL/T8VEDCBBHWaxRucTpknEwVyOq6yrI5i1uTCyHAygZ4CHWz1qQ3/K3hsE/+SUGiTAU9qt0bRYrTPn9IDU2CUNa79oI0hNWLsj94MPnaO6uN+DriafVHWnPknlvLMx1zni5/lM109oQZK0OTZLAu460y/ogOuuB8J5PGuu+2hm3kmMfkEZjHVPe0joV0fYGxCxD8ZQB+LXEmfySpxLvMwyvYrPDAQJYHTvWLfJsEecE9d/e/24uSXSUHuALDwJ6kidOWPdqzVaA3RYbt
 i1RANtVy
 zWWa2tKzzP0zbkM2Kq1nsbysVZKUTUx9NozhVvw3k92eqt+MWw2RlHtUIarn30IQy9xOH4PBczZRbTmiYN8iKx0mVyYT6hlBZmUgmFBBdRAmysjNQD8HDWa3BfIaDCCyQGa6oA7V29+PZ1mjRWNuemNuwvwvUrFJLzNTcjd3vV+ajRul4psvTMCYmsbSr0NQkFA7gDcpJgLkyRL7N1ilUfBZA6SPUxy7crDO1dP0ipkuYh2B8tnWJR/FO094RXevr64PNw2o833eJxuP2NiQRHHB3NPd+av9xJVj4ffw5oOYjKO8tCxk5Fs4WAgPHEaZJ8dADwAXZnnqpDucIVNxuVQQt33LNMq/Uy+hsdy/H2GUGGXSowQNOo1MfwaaJDz/tvKKjQrGl1yncBpP9Zo86feyz8YTWYVn7SZ4tTdp2h/yrjFXPtyk63jyW55RYn27EQw8Gqu55zTgLFLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 08:53:23PM -0700, Andrew Morton wrote:
> On Fri, 1 Aug 2025 23:09:31 -0400 Waiman Long <llong@redhat.com> wrote:
> > > There have been a few kmemleak locking fixes lately.
> > >
> > > I believe this fix is independent from the previous ones:
> > >
> > > https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org

That's a similar bug in another part of the kmemleak code but fixed
differently (which I actually prefer if feasible).

> > > https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com

That's a soft lockup, unrelated to the printk deadlock.

> > I believe that __printk_safe_enter()/_printk_safe_exit() are for printk 
> > internal use only. The proper API to use should be 
> > printk_deferred_enter()/printk_deferred_exit() if we want to deferred 
> > the printing. Since kmemleak_lock will have been acquired with irq 
> > disabled, it meets the condition that printk_deferred_*() APIs can be used.
> 
> Gotcha, thanks.
> 
> kmemleak;c:__lookup_object() has a lot of callers.  I hope you're
> correct that all have local irqs enabled, but I'll ask Gu to verify
> that then please send along a new patch which uses
> printk_deferred_enter()?

__lookup_object() must be called with kmemleak_lock held (unless we have
a bug in kmemleak).

Using printk_deferred_enter() is more convenient, though I think some of
these places can defer the printing with something similar to the first
patch above from Breno.

For __lookup_object(), we could move the warning outside the lock but
this function would have to lock the respective object, return it and
somehow inform the caller that it was an error and the object needs
unlocking. Given that this is a very rare/never event (only happens if
someone messes up the kmemleak_alloc/free calls), I'd say the
printk_deferred_enter() works best.

We have delete_object_part() which calls kmemleak_warn() with the
kmemleak_lock held. The warning can be moved outside similar to Breno's
patch.

We have a kmemleak_stop() -> kmemleak_warn() called in __link_object()
with the kmemleak_lock held. We could also use the printk deferring here
as well. That's another rare corner case.

The patch should add a code comment on why printk deferring is used in
case others will wonder in the future.

I'm surprised we haven't seen these until recently. Has printk always
allocated memory?

-- 
Catalin


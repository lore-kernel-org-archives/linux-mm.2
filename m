Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31AAC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A246B0095; Mon, 24 Aug 2026 14:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A896B0096; Mon, 24 Aug 2026 14:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919416B0099; Mon, 24 Aug 2026 14:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7016E6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:39:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F094340236
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:39:22 +0000 (UTC)
X-FDA: 85137025764.16.B9E7094
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29A5EC000F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:39:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cdNkR56V;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787596761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UBV4/KgDhQsiGNcw2DjCpLZivT52o2Vrno9SL3MwTs=;
	b=zXX1VehVVEHLZkhASJtaVmOg3/CQR4gll6xPMDklb25uggCLyYHDeQzUVJfGFABxOrKpja
	KZQFIQ2cr5O9+TwNihbaIg4ZYW7JjYvElQd8o55R/X9JQtI4VMs3AZOetRQSOpycsghqlq
	dk3ccg+n4EFUnHBdkNiFDvg0hVboSv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787596761;
	b=K6Gm09HXJ0RRSL24CReHgC6pFYSl+oNtNYLt0NnF/o1FRW32X5eR4O5E1CH33ZZrtQyDHO
	0KOxB/hfusi+FTi4MY9x7YEQHcnlbr3um1Kha5j1MPFqSyFXyUXMWZwH2Sd+2FdDcBQjs5
	E+/nc//RMQFaDhhf4SYkgrGRV9I5n8Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cdNkR56V;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ADD36011F;
	Mon, 24 Aug 2026 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3401F000E9;
	Mon, 24 Aug 2026 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787596760;
	bh=1UBV4/KgDhQsiGNcw2DjCpLZivT52o2Vrno9SL3MwTs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cdNkR56VYQtfw3xp9l6ugyxRzV/Y5SUht8XoNKHe+E8IBBMIExHu//hqJ50tihgyy
	 0ms0WN5XD0q/QB/Ky7TM9nPdIgdP4pR5/0JtRZCBg/9MKZ6/WyUPiiEpI2GxhQGgtN
	 Ypil4wPiIwTUStSuR8ZAjWEKl1Afz2VzFKpmRIoQ=
Date: Mon, 24 Aug 2026 11:39:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, edumazet@google.com, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org, david@kernel.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mempolicy: refcount the weighted interleave state
 instead of copying it
Message-Id: <20260824113919.caa89dd75553365977f8a42c@linux-foundation.org>
In-Reply-To: <20260824024117.1755899-1-gourry@gourry.net>
References: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
	<20260824024117.1755899-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8uxj8dyd5779hhmgnzkoz1hdu8ru9cme
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29A5EC000F
X-HE-Tag: 1787596761-614434
X-HE-Meta: U2FsdGVkX1+N1BQlgVmPCywq4eyDDUNBZwXDwY5vzPEt7UQ0GvNM2Jya5NU3LUaxHbsdE8XvmU1VmovvvWlLRrWEYSR4XaD5ykjrz+v3cyRl0vPViWZYV/jFilq4/vyIbLBpcrbhbzoi64ey3JPFSoQoEXnR2dQzF8ru93JE8RnSp5cNBUJqMs8YwPfb7XLsyGY1pj9LhVzLKOcscZ1G/6LhDy+92ePutLY9X35NcN8kAj+ddy0tgvLr20Pk98s/nNlZlitvr7nbnbvBKgfA+03U+u6g8NcLzx9NGHjEBQvqtEwq46qd7yK4zvVji8XLOeEO51Q0qdNFn1rLgPA7YS9JBtQSwxpecNM8OJ8GoyuPKYgxebAsRON5XyXKL5OSLHWJHctw2PKNLQ68c1S6m1yEKqFjxuprem4i2NJh3+zr8dGe4OWPN5eb2dO4zQmCAq4fYxMCLekRX3WrRXbrjMNDk7Sw2IxFo5HddPwF0yrNrZDpvXXo7HI3ThTPPdCPSVH3VhGQh4nAShNybEuh/YlfCxhkp1Try4tVETht+3XhUHWdQoK/OS2al7RmgMBHVlLWCubQ6L5JSAfbraJU7temlKc4NTRl8pBfhwBNyP9HDw1Pr19MeoYktbzRIJR0soRn2h0tepCrwXNkebEeMhzyaksr7EzKf5IxqNggFrWU8Uvp7cA9jhMxoL2cOTZS2Rdk/wqGmwUEIYdev6UwnRaFq7By2CFCwP5AJz6xa01v6I98+df1IlPzoN5i0xJGLM2dDW6E8afxgy0BJhURo3cLvpOxNXeBJBoJsPo/6nQ2aKAZbYEz5JBCraoojKVdFIawCucSCc6zVmLt+C9qD0R+cMayBSEbG/NY26Io9KaDUn7rCgPSAi871ZaUoDW78ySrco0BKaeGu+RccJ8SXE9g+SalyHtFU6xTJptBSlJku5bhOnaspgyL7cw+6o2ms43dPLoMJB/L2ZB3mQg
 jATvstVm
 WkSgSgNQnya0kAIRyzBsrA7Gjl+m6C1494DdqXHx+RtIXiiIYTBGAD1NOKtvrdNxpR45nO3YvG95BiOd4icKN5abqextDBO2D9HbKNUKTWzjDuhC1BB0kx0XUBZHmcLmo/JN9fCMlavj9CqvzFsjVk+PzBBQcx3haRlBD4P8nQMOATmKn0giyjRQMJDsI8muNtbSO4NGuVztxA5lIGVbGBnaJ0f2ThFIk5ZRP8xHOnYqCAWAQlcKLOVpOdamK3uIkF95rJeFv7gnrmXETmRaPwaXryyDhxQyCdP3fZTn3H8IAU8CylkAb2P6ToI1dcdjsS9chWTlGwxtao0f9aHQ3psZvNDKsbH9jfqcmxJR0Udzlo1iNNINfUDfxzk8va7e0LNZK77zqVLmxFVOyRXkEVGW8ZsMY4r9ONbFUxLwzCoYVXNQHM43tXDcd44nJNa3hApYJQnTh8Vlyjxan/L2wa2t/Ks264I7syrQ2uR6n4A+nGzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Aug 2026 22:41:17 -0400 Gregory Price <gourry@gourry.net> wrote:

> alloc_pages_bulk_weighted_interleave() copies iw_table into a scratch
> array on every call to get the table outside of RCU.
> 
> Refcount the weighted interleave state and cleanup with kfree_rcu().
> Refcount and iw_table get their own cachelines to prevent false sharing.
> 
> This drops a kzalloc/memcpy/kfree per call and deals with a bug induced
> by the scratch array's hardcoded GFP_KERNEL and the partial allocation it
> returned when that failed.
> 
> Tested in VM (KASAN, PROVE_LOCKING and DEBUG_OBJECTS_RCU_HEAD) with a
> udelay() injected between the rcu_dereference() and the refcount_inc
> to stress the race. Six concurrent bulk allocators racing four threads
> writing the sysfs weights took the retry path 2536 times with no splat,
> and the published state was back to a count of one at rest.
> 
> Replacing the kfree_rcu() with a bare kfree() in that same test reports
> a use-after-free immediately, so the test does exercise what the deferred
> free protects.
> 
> ...
> 
> Hi Andrew - please consider this instead.

Let's keep Eric's nice simple one-liner
(https://lore.kernel.org/20260821170407.3721004-1-edumazet@google.com)
for a backportable fix.  THen we can work on more sophisticated
approaches in the next -rc cycle.



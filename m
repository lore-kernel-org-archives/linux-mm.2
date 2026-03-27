Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6885310ED64A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31166B0092; Fri, 27 Mar 2026 07:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1EF6B0095; Fri, 27 Mar 2026 07:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8026B0096; Fri, 27 Mar 2026 07:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2D76B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:14:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3437E13C592
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:14:12 +0000 (UTC)
X-FDA: 84591583944.05.6BC9288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D8181C0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:14:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRn6p8Fo;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774610050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3wd5VwuijjrciyZY7oyUSjts3ozR9+8YEGkP7ZIwkg=;
	b=3UVV2s6YSUvpsxIZqwae83+fTq0dKOK/kaKtKzgFNXPGD3ZhysIc0ro4NV1PbQ2TIBgKSd
	4yaZGP60SjIT3JqGUHgp2wLxDul9WOBfjoAiY4rKBuKKJo2ZuEi7K9wwEicgk9vIw0Mp2w
	LQwyK8Jd6DIVq32nbXqdbr34KAJEOfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774610050; a=rsa-sha256;
	cv=none;
	b=g9n313v1DypQL+zvkit0O5H2NHscXvspxzXFh4zAwHqxiId2VpURdiIuDaAq2sR+M1bj4d
	7v1rZwH4g413/hF0BH9uVdMIM34o8z8eL/HC2zBwJ5RxD189+jRvWIyJ37egOUcbnyW1Pd
	T2AIxFnHsrj2ZmenhFZ2d2SHSmQWiUg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRn6p8Fo;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E57F761871;
	Fri, 27 Mar 2026 11:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB01C19423;
	Fri, 27 Mar 2026 11:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774610049;
	bh=jELwswd/uYPzAV137eapCnhCT1uBdil42D5dYvNpMG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRn6p8FomfT9UzD59UdjGNoxWNuzRXV7BnOv2YdTuU+sGkaCWNeVMS+suez3EXmrm
	 oZOGH8VuEtYcUQn7BfGZLC6ffTuFe7Uq+MaDCx4Jhv2oeO0p1M2jUN4RNepaRZDSZB
	 kxM+uERaI26l9aMvrAlxYFhikfghtZRmmiV5uNoAqyEQq8VTGjs9L4EqI50lRcjyuf
	 pr/Qdwbp0ld6W7Vvn0mhR7H+G8HBsgp6gLjqvOXJj3QV7TapWUAmpGdlLys1nT8Kb9
	 OkL4lGiC5KdRKYX7iHv4AxLuVxxQNtdTZTgZghQo0/q6dVw2efMzOVS+JnFMO2yQ/S
	 mbRmcrthcrcMQ==
Date: Fri, 27 Mar 2026 11:14:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: akpm@linux-foundation.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Audra Mitchell <audra@redhat.com>, linux-kselftest@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <f00dce3f-d6dd-477e-bac5-b9b8253b03ba@lucifer.local>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
 <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
X-Rspamd-Server: rspam12
X-Stat-Signature: w5617ufdyesh1pd6p8qpceqdcckd86rt
X-Rspamd-Queue-Id: 9D8181C0005
X-Rspam-User: 
X-HE-Tag: 1774610050-723624
X-HE-Meta: U2FsdGVkX1+ddptWZM4Ww0H4iXyrLyqRaGLZ1+mYwm/eRlyc/71rzsJDGb0M+QVHuwNtSl2l7FwDoCCdyvxs4A7yirAdPCWbo9RR4khgi8pa1BWTBv9eo29ppxg3fG4SZ+1BAUhnthiWIXDC9Afiosc2nxz9v0v417bmYyPz5IoCjNiSm38KgG1lYRNx9Ee1BrPqkETibemthjGoFulJiifTDI3uNmbD4pOYjpYHqH0kPluI+1ddF5BSwLEuzXxHA1V3UVNwtRTJFiuBRq44eXazZO+r74aJizeYqNGfcM3oAMt7WXVZbmiCsUw+rlqOhMZYVJLvKDryXSlnkdRDc/uD6C04JUPzMJvzPzwH85SbcGJYs5PlyYv25SiUN5t0gx4LvemVARBiLBowxo6m5pPZbyvtV69hGpNiA9P1ndd+F85vxGlHJc8oi255VW67+7gq+YDmgMh3Dd2G7br9r/UaiUTPlLHC8c8KkM+MonjjreEVCwdt/dS2r/iZbSS81oeJllzCOEusYbwKtUpNxIawrtqWXzytYABmebopAbV0zpLgNm0NaOOWm1hd3+/TkKS3CBSY/InNKR4zFjoB9pm+SXcI1rIn2xQ0YJ+UdmRl4u+x4wKUqlVcQGplc1dedyhWjR8hOqHHQJC/yQG1ZHT7D7H+HqYHxEfdA2euNk6TJjx6kXRM4kIc3rmegW1Tq5cJizvFkk1Vlk1ccjNjbmX6FwfIQAp+7csoNQ0apK3X49KuDcr0Z91+1pErQxnMIvcB7fveVRAo28kVUnSq0RJTWXDf4jxkUB8PV1wHwrzyJG0obyM95+Rxlb709AwCiZXKQE8B4W0dYqQPEZvSTgyAsJFHxseWRTwxmP/k+5ki0zlDMe/G8R6utZ/X9BU9f8tr/cPnzh8Bmz9TgbUt1gyrsIPSrYZNSNSb1FlM4NolPDv81Z0zgs1oo19TBIGZ+INEaWySm+ThDKxSs7/
 wL6m3IRy
 ZfVdxvQo2ZGGF5L/NH+/l4ZORsv01TSYM27C/VMhBv9UVB+DDnvu3bS0lUKdKtau6DceMbSv6fJraDuX/BU2OQpZxF64tNrM1jdyz6zlIx/6vsg14uU0RnBu8/IzyRJjCcs1z04xUzm0k4lbdHKQcM5GxxpHZxEW38KjpulMrX0MKC308j2CiePe0IsPEDm6mDfspKh22XVGydVfY+DDEmiaO9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:52:24AM +0000, Lorenzo Stoakes (Oracle) wrote:
> OK again I'm starting to think we just shouldn't support fix-patches at all any
> more.
>
> This is an example  of a change being done in a fix-patch that's _really_
> causing issues.

I didn't see there was a v2 in-reply-to here sorry.

So in this case less fix patch more:

1. We shouldn't automatically take stuff to mm-unstable until it's settled

2. We should have clear separate branches for stuff-for-7.1 and stuff-for-7.2

3. We should build test stuff (!)

4. We should root cause the source of problems and update the thing that cause.

Part of the problem here is that mm-unstable is a totally unreliable base. Not
as bad as mm-new, but it's forgiveable that Audra didn't see Chris Down's patch
there because who knows when that went in etc.

if we had a for-7.1 git branch that only got stuff that had settled we'd not
have this issue.

And we could have a for-7.2 git branch for stuff that's arrived late.

We could have:

mm-untested (was mm-new)
mm-under-review (was mm-unstable) -> THIS doesn't go to -next
mm-for-7.1 (was mm-stable)        -> THIS goes to -next
mm-for-7.2 (fresh and new!)       -> THIS only goes to -next next cycle

And workflow could be:

-> patch comes in
go straight to mm-untested - we are undiscerning
[ make sure series gets build tested + self tests + etc ]
goes to mm-under-review
WEEKLY:
Stuff that has sub-M signoff and seen no further issues -> for-7.1 (i.e. next release)
if it's <= rc4 and no other reasons to hold off

OR for stuff that doesn't fit the rc4/no other reason criteria
-> for-7.2 if signoff and no issues

If things get reviewed and respun

-> back to mm-untested until tests pass no matter tags
-> (if stable) can jump right to for-7.1/for-7.2 if signed off already. if not then mm-under-review

This way we reduce chance of late yank, give reasonable rebase target of
for-[release you are interested in], documents and simplifies the process.

Thoughts?...

Cheers, Lorenzo


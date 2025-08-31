Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B39CA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 20:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A292E8E0003; Sun, 31 Aug 2025 16:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9C28E0001; Sun, 31 Aug 2025 16:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF1E8E0003; Sun, 31 Aug 2025 16:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4CD8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 16:03:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 094D3160564
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:03:45 +0000 (UTC)
X-FDA: 83838128010.11.86182AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 447D9140002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:03:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I9cY79ni;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756670623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=US0oW+Ut2SDHZ1JMHn38QBTm/yueAPRYljZcVZPlsPo=;
	b=h7b8en5lUqcty92wBfPtoOWflSphg9K7sexiFWoYrULwzxnfRMVnL93SGrwAzEQUlDREP7
	ZjQosIlogwmNV7+bdSQSLQ480MAQP4kJrPw96viGX4QMuHW31ffxSw/ZLIsBErTuW74rGf
	Bzf1THEHXXO/FlQITk7Mlm1VTwOlFLY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I9cY79ni;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756670623; a=rsa-sha256;
	cv=none;
	b=8AD8LWSeEhkUHBDYaFza4uxzCNs0rcuSzDyzeDD40XKU9o1f5coD4r5furqmQbtR52zvd1
	KUGnf82vpULX3dtYI/xJp93mVH3jRYS7/6UiS/suyNOP5rG7u/uIWvBStBqQ0QqjbHGAcq
	Fr38o+p/bYBPvosX0hmaJEtSZZjk6LE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 341AF43461;
	Sun, 31 Aug 2025 20:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B50C4CEED;
	Sun, 31 Aug 2025 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756670622;
	bh=DPPkcb21slAFTG9P0dPfTMqmPZQZs0zA6URZPmIF4aQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I9cY79niBHMOtwU5hsj7SCJxtuY2+gGtapyoxfF8v+481gGJZRLlj15P+mbhewE9U
	 6WCA4kEeFGXjQw0z86jDb80fzDEAPnyf7wgNxXkEZ4JTzB9l4VP200eSkqXEZfZJhx
	 Cw+qht02yc54pcjkoNk+/jH6Jws2xsl6DOYUNCbQ=
Date: Sun, 31 Aug 2025 13:03:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: richard.weiyang@gmail.com, Liam.Howlett@oracle.com, davem@davemloft.net,
 david@redhat.com, edumazet@google.com, gnoack@google.com, horms@kernel.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, mic@digikod.net, ming.lei@redhat.com, pabeni@redhat.com,
 rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
 surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH v2 2/2] selftests: Replace relative includes with
 non-relative for kselftest.h and kselftest_harness.h
Message-Id: <20250831130340.c096ab001dd38bcdb11146b8@linux-foundation.org>
In-Reply-To: <20250830163949.20952-3-reddybalavignesh9979@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
	<20250830163949.20952-1-reddybalavignesh9979@gmail.com>
	<20250830163949.20952-3-reddybalavignesh9979@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 447D9140002
X-Stat-Signature: xmrknr75pq3yxwi3ujmssyeba3h1cotx
X-Rspam-User: 
X-HE-Tag: 1756670623-220511
X-HE-Meta: U2FsdGVkX1/8xAuGsyONqLvbYnhGrwEfgTuEilGiK6CO7GS7YIxtYzkB7I8wm0/qNULI0g1ff9zDbZlstbY9zsSMz2r7nxipSoJFRyMsy5yG6HQalR8voK5MJPCjvZmQ69eH4iWOBqz3AlBVPBeVGHULze+3jeHaLTC1Csm/NU7ClYoxXlR//hEJBSerfbHMZZT6Dqr6FvvD7jTx09h8M3fk/CqmM3oMF0aNARnwVgEgX0aVdPftGAOtp3TmyCqCC+xLEfi3FxouYiS13to55Fur9b73Lu8PIAiQZyH8O36zH792bxEwaulrQVzXlgH6TYm0YKuwm0LY7NeOz7glF+FaxMvKpGoqnSsFBhugXe3hOFtL5PcqhFyVKxPd7e3VZPFiyUr9oAIxIbwzYtyGpCjskzbvWXsWnw09ul5AnHCuHu7r2mAT0WiOKR+K1ht4pvd0q+2ZXK4ygbcI4hirgPrCLRPhsJPkA9z1UIkq/1RHjsGxWvnba8LOX0HZLqiIsoXukp4AqjSnp8RYFBjUeh/GbFRYLivRYA5XLE7YBuhgwfzqB8fgv+aUf03rR7UdF2G+QEAffTwsXJ4YYovzUDu0PpKwAzJJadhml1+e3kt5jZprDwC+pFhbFjW1jT2uM0656ZZEn6pnX1fC+BVNSTvMS8j4FkmTiZLUiNq9ETH6EiYKClM/HZ4GDsHsYK4UOb7Je9s8tdZ9a3IfCu7POWd8tOeRj3tS1fxGP0hzMoxSVxWHJTj6A6yrRFGZIz5KTnUHd/0/723u3KrzD/iirE/tNeE3AXUwImkiKfd92juiRt2LHA8cpTsdF7OVtwi1UHt3zmcq8YD4NVWANshvFU3hzkXf/ZY8mW1WMpO5L/vQB+ajrASY7CGTXZQJLI5nNaf2B2n3RxQd16tUyj+u4Z2vrBVzUSmSkPrqmAI1peuu0LHSWHqgoTVOfEjKqagLzOgsMG8eyicxc96+yZc
 MhEd9VWQ
 cCR490AxHqhVEUGuODTyhkDHlnCZGB7lZVJgdHXKzWz/e3V8QS7rv6f5S0Z/qGDxqVm58TDxQ2d6LGFmgfzs9zR6pBkbkPVBpAUPjH6DaHr7usXaw6E9MwWN3rj4FS+j85G4uwpRcAjPfGdDRx/Eg/xf3XKmSAz0a/c07S8+3aYMyi3/WwVhdxlxUtuWDXiJybn/JGE4JQwa9++0WY98xRCF+LlD/3DUbgnBvftW1tznPcEp2WcGkk7zWEGC37W7AeIq3fpz0CIwzaZNoSHodFG1sEL5GB21EX9h+WRGQfIQ87kY8CENMJ/hV9v7JlwecTv5MnjcJh0lqNvYT4pUSfrukowzJQIEpjVb0i7ZoX+YTUBtVsrzZpt4BybJJMFSnpZleKt2lC/F8/lg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 Aug 2025 22:09:49 +0530 Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com> wrote:

> Replaced relative path of kselftest.h and kselftest_harness.h
> to a non-relative path

This patch causes me some trouble.  It alters things which are also
altered in both mm.git's `mm' and `non-mm' branches.  I try to keep
those branches independent and this patch won't apply to either branch.
And I'd rather not mess around doing git tricks to address this just
for one patch.

So what I plan to do is to simply drop the problematic hunks from this
patch.  So what will be queued in mm.git's mm-nonmm will have a few
missed conversion sites.  Everything should still work OK and I'll ask
that after 6.17 is released, you send along a followup patch which fixes
those missed sites, OK?



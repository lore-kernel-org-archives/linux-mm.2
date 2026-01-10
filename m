Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCD8D25028
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 23:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33496B0089; Sat, 10 Jan 2026 18:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1556B008A; Sat, 10 Jan 2026 18:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECE46B008C; Sat, 10 Jan 2026 18:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFD686B0089
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:29:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 522D5C18FA
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:29:29 +0000 (UTC)
X-FDA: 84317648058.11.61447E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9426100005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:29:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2ASNKvMY;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768087767; a=rsa-sha256;
	cv=none;
	b=PpSCKpDv9vFQrajtyyDZT6+L8HFfcyvr2RCQGDwQ9syBILnDCRAvKhw1Pbva5h/Ren0Ei5
	dursLVzNGa/cyn8C1y7S+7zl9txzFWbk7bVuXycBq/bjcl5LlQfvVareWtPHfQS4l+AGZf
	ifElslfrcStNvRBoxwACJx3gmxhsZ1A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2ASNKvMY;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768087767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YEo1xQMK8bKYKlyiNTa+nPJAamcxkd3bSPBhcxLleA=;
	b=MUuAwQ5ah28uSvGZBE58Ip0sicSnroIm2C/+uCYFL8LxkdLqQiW36kztNLt7FQidB24ove
	ESwbRl9lQPNPX+/4AqJ5Cq8mRdz+k8vbVbW3nCd99nFIQJJRIJDN1CffJ5+kDXImILPz19
	lA9CWVEHzzM3MP99VuRns+iASOHllWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D368560010;
	Sat, 10 Jan 2026 23:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F2DC4CEF1;
	Sat, 10 Jan 2026 23:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768087766;
	bh=8feMRPd7kn/QU8hVFk5c80/pgbFRqhrP8JeGJi4HKKo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2ASNKvMY/09pxE3gVtRyni1RtnWh7WNCcnBqDVsO8H4jx32rQTeIhsrsO2mVgQQ2F
	 LvOSWCm606uCj9CmtdJk4WRXEsxAj1FCf/sYSDUjHFu1Fanx/Wcm8vLEPbqPmj/xJd
	 Ycm/hbHm+qIpKzbB1MRyf1eYlcpw6lNy+EJGBKhw=
Date: Sat, 10 Jan 2026 15:29:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Message-Id: <20260110152925.a2f98e1be21fac5bc8bc0bd5@linux-foundation.org>
In-Reply-To: <20260110064613.606532-1-kartikey406@gmail.com>
References: <20260110064613.606532-1-kartikey406@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9426100005
X-Stat-Signature: dx4xoi87hdjhsjisn3q1b3kqskcr1xny
X-Rspam-User: 
X-HE-Tag: 1768087767-612635
X-HE-Meta: U2FsdGVkX1/n2bFSe7oeBen8WXxNyr/rFHGpF3tZxxkTSyfta1vwUWUZYB2bLMSUGoDC5/OlKUZFkhGTirwZAX6H39b1FWzFYlnRBZ4UqL+amSqH3+X/dPCTqdTg4LJDv6Om21lJ4RU5kRpObG2Frp0635CdNB2j3rUkxkiDdrs11J6N9/S5R0QiNFQdipPZBQMBAhxMTiSUz7zd0AuGzYMtAql2q07ssoqNNx5DX6bH0CAegijqAlOZDWjEofNX6zJA1dCbEzCYlZNgGs6NpPPjXsD47i2HizSL5p129SLeEFdCQ+FPP/SAg6TG0FpY0wQHL/IVtTIvplTiCZgsqgwUW3UhwbUT2jGQhd5QxLeJ4HeBvD3/x3QoMrQmQFLB2wT1j1ofvdqsGOI28B8wE26IDJ3BGx7r3xWWJfvCcAYK9B+SXu4Qr96i+PlXl7JuJB/Euzp9R8R881u7VHZSGCkAhh1zzcfj9RzvhT9ABPQ4nUcEVegzw4bCMTl5SVqJl7SNd01tSlvQnl8raH/vUx3xSZL7fiAlR2mG+nPoz+7QbvGEUgHEcGh4Airy9/gC/n68UWpohYGddl+BJYM2XBLDHWVGRd7/YCOqHDvDeeXviSV/Hh2DvRU0lK+1t8CiiAckLH49aSoF0dnhFsqet7Flf7kCma2M87c6JVhPuUNIK5f87PdZWMgrZVvDqE9quYcESqFZ2Rx52mWMrD07dhTPh2RjeGIDfOO+Fit2aXhv4CXUxEUtLFFE/HhYZ+bvmQy9a3pMtC0bTaqkIDpkcBxbIcjFqbc8Inh6iyF3OeeYDbA6Q3tdr4wR6UsfCfDb3A1+YetDwcb7FUKakzv87Z019QotrroYk5CpS7HG0F+7oqqU3icKLsK0xVNFWscOxzpI55NYdse3r8M58qdtMbB6+oQNECd1iApp8ySBXo/+BF2oTbt3lzAaB+vwrTZZIyxdVq3lSrJAagonuhp
 rHWfL2SJ
 xMGNXymZAGQ6tWv/VsKtTH6uD0vGHpGYnMExYARAN/F+zATIHrmcYtbBYaxPfSC70HChVRpjrHzk8zPWTP6wv+1CTZBqnlEIB7phK4qgcuco53OnfxSz45yhI0cTG9cDCI/jqs/QTQaHxDMFpO4RS5mMMHwn1QjXPvBSFsdtFf1qjnZS5poeYwharnNOrNqAIDtUa2tykEjc8BatmLXmDqSsghhxrSkgUE5EtyWP6fG7JCIynxHQET8chpPauRHyQJ57Jo4QV8nzWLHCnOGfTImHm3ZhZJa4IyrB20fhr+zVtz/tFHHRZBbg+Y4l6Rx+tczQYRWKvFsCpZgUVNRwp6z5JCtbHim3iQvXlkud4cJKMLBcalb44No7Ec4WBx4D50R7PRNf7NDgAavPYjCgmAW3aVkN5BBWuszC/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026 12:16:13 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:

> When using MADV_PAGEOUT, pages can remain in swapcache with their swap
> entries assigned. If MADV_PAGEOUT is called again on these pages, they
> reuse the same swap entries, causing memcg1_swapout() to call
> swap_cgroup_record() with an already-recorded entry.
> 
> The existing code assumes swap entries are always being recorded for the
> first time (oldid == 0), triggering VM_BUG_ON when it encounters an
> already-recorded entry:
> 
>   ------------[ cut here ]------------
>   kernel BUG at mm/swap_cgroup.c:78!
>   Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>   CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted
>   RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
>   Call Trace:
>    memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
>    __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
>    shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
>    reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
>    reclaim_pages+0x454/0x520 mm/vmscan.c:2245
>    madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
>    ...
>    do_madvise+0x1bc/0x270 mm/madvise.c:2030
>    __do_sys_madvise mm/madvise.c:2039
> 
> This bug occurs because pages in swapcache can be targeted by
> MADV_PAGEOUT multiple times without being swapped in between. Each time,
> the same swap entry is reused, but swap_cgroup_record() expects to only
> record new, unused entries.
> 
> Fix this by checking if the swap entry already has the correct cgroup ID
> recorded before attempting to record it. Use the existing
> lookup_swap_cgroup_id() to read the current cgroup ID, and return early
> from memcg1_swapout() if the entry is already correctly recorded. Only
> call swap_cgroup_record() when the entry needs to be set or updated.
> 
> This approach avoids unnecessary atomic operations, reference count
> manipulations, and statistics updates when the entry is already correct.

Thanks.  This looks like a fairly old bug and it annoyingly predates a
lot of memcg code movement.

What do people think?  Should we backport this into -stable kernels? 
If so, can some intrepid soul please help figure out what it Fixes:?

Deepanshu, if we do decide to put a cc:stable on this then some -stable
maintainers will complain that the patch alters things in a file which
doesn't exist and they'll hope that you can help.  Which means
backporting the fix into kernels which predate 89ce924f0bd44.




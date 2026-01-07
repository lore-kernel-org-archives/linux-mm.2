Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53644CFD65D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F066B008A; Wed,  7 Jan 2026 11:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEB36B0093; Wed,  7 Jan 2026 11:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801936B0095; Wed,  7 Jan 2026 11:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7098D6B008A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:19:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 078631AAD5F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:19:26 +0000 (UTC)
X-FDA: 84305677932.15.BDCACBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E629100002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:19:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNTsXeCD;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767802764; a=rsa-sha256;
	cv=none;
	b=7GVQJQ4xVujfkZmKPflWyEENqsE71ct/PM5tcm6TU6c13Aa1qI8zj4P+/548T3Tlk9un9w
	oXrAGlU9ZtqSVJgAXocqjOZ5qTGV4v+FDqTS/ZOW9K2f88AsaIQJJfgwGcGS6oKc0OGbtO
	AQwNuMvXWu/QuP+1JbTGRBg6Kf7SE7c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNTsXeCD;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767802764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnLlLWsoEoaUstNmkE/BV8bAFgpqkj4IgfCpGTmGKNQ=;
	b=4eVUWKIvOmnlT2dCQB2MnW2lX4ekh176a0CHWh5/xlQ2APWeJP030Y9GpaMZwirrvR02NX
	pJeIcDSQ+EkQBDsVMY804vrTaMzYgT4L8gTui8Z1g4/7rBkYdodKTPiSWZ4hAtAupKsv4g
	YD9TAADKSCJAlhJXLXVUbdfD/zwgMwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCE4642E05;
	Wed,  7 Jan 2026 16:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A2AC4CEF1;
	Wed,  7 Jan 2026 16:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767802762;
	bh=gd+v5+A9Bh9zbZ/0HpEvUqibh1+TbB0iDi23P/TTm/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hNTsXeCD1PbB7GIwsAyk6f+eQbR1sw/HfR4+E17JNvLZH4SZc7ETGFZQex1FnYdIO
	 rc+YH1EpVmew3wTDYe46yVrnvRN2WkKlxdNipoiJ5gawQYkQqbenR+Xusk7wCeoweP
	 fk8R7wn0gFjum/pJbV1oJSAhd1NE3vG6nhuIw/qQ=
Date: Wed, 7 Jan 2026 08:19:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <fvdl@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-Id: <20260107081921.0e189904060f49a555142e28@linux-foundation.org>
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E629100002
X-Stat-Signature: bt6pqox8w7qnz45asrxyqjsbd4d85gct
X-Rspam-User: 
X-HE-Tag: 1767802763-164202
X-HE-Meta: U2FsdGVkX18cBFRprHWG82ByHgbcE1MTAE/YzdPIsxruLzFA+t4HYp2829JdiXXZ40qLz8gUv7WK+Fzx2jEkFITmuaQsvTJDiFXr+4YyhiFS83Sw6fVTrCxoLVvO/bhifAtvW7+IbRTjBXWYIlyUSuHqszRS9SUTaPtxaX8vKWddbPVXW7vxotgZyg4rWPFmPkcgIglpZqPxyWuI8mkja3gW1q8vFXseVlVJof6sOyRCVgydDtwg+zDcKWNsUUGv9iVZGi9A54LNV804mshzECgKfx3eyqOQB11NwVcrjRSuQM8Sjr8npqbKw5Zqb7Ux9pHNAA0d0q1ZIi/6uqmqpjejQDoo3jQaI0F9L8pIgIYmkUhA4UGO12kIhXYpJff8ERI9E3+4S7TK0gmCIIRZ6QGZJ+FMdi6VDdpaZ0Arst5WoZoXbmYPpfGKVw7asvYhHY9IwWY3+DFMyAL+8SM4+Fl71KFRiSXwoq6gCLt7whfdJe2z9VC7JCtGh5jvj0gBu6vzDOx/JjzBYOHo2uPzlGKTvJoaxP5UySql02g0+VmSc+kJd2+K24vkX8+0UIll8EJMKPp4oQZIv2S0XKSsVR7Y6u/WvgPIYoC7bYEs1neWBCCMC9Mp33tw6qUvWTf6h+vGUS3q3IQ6JtttcjTqJMzy+d733JAZMgVrTghdsYUSuzK651Vs32lM9NC9eQkxaMQbnLTxqgbJA/FTAzSxuNgLl2sIhg38AItJ5polBTxZ239VJBjlR3FdxWrTFoFSd6Ll6aUNQyyb4Y5nRDZxu5M7U9GLtAmIDVvaKLwf2E7f7j4URpzhvVs4TBO10ga7ZxOvu5wmTfPPucI53desYfsil7wophkUcQHnhIs07zwNBR4gfhFwSFa9NxbixFEMEooEHQ86rH7sO/YKWFfgzgx990QeJ1/2PhYv/TAkbVW887aKxeV3rH9W1h1tYwJ3R/li6jGwEAmETJthsCU
 1cxKMGNE
 LJctfODYPaDmvJoBZ3KE0wlRdDV4JShglRxAD+zQEPlRMc6cIvzSrrOWr0KPz64XpIyndrmQsaEm4GdPYKNfsG6JHErGMLG1eYev8wAEedzbsvhW8HnWQS+xcfEmu7d7H/YThC9I1aMcTQ8rP7hcGnGJ8AJDAJ9wh3GWNFajYeGg85Y7rbzd5ZKUAhVTIFigk8OsjEWrJI3TBNF5/fWSEgKwXEkkiwKdpqvOiWaFY+J9sv+lNmezGQINo8HtWRthJQDVo/TZpY9/YpBsXAzeU9ahpxlqMr21bDuK2Z6tsv4TMjWc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 19:31:22 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").
> 
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 250
> milliseconds for a 1G page on a Skylake machine).
> 
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
> 
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application starts (such as a VM backed
> by these pages), rendering the launch noticeably slow.
> 
> On an Skylake platform running v6.19-rc2, faulting in 64 × 1 GB huge
> pages takes about 16 seconds, roughly 250 ms per page. Even with
> Ankur’s optimizations[2], the time drops only to ~13 seconds,
> ~200 ms per page, still a noticeable delay.
> 
> To accelerate the above scenario, this patchset exports a per-node,
> read-write "zeroable_hugepages" sysfs interface for every hugepage size.
> This interface reports how many hugepages on that node can currently
> be pre-zeroed and allows user space to request that any integer number
> in the range [0, max] be zeroed in a single operation.
> 
> This mechanism offers the following advantages:
> 
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
> 
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
> 
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
> 
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
> 
> (5) The CPU consumption incurred by zeroing can be throttled and contained
> with cgroups, ensuring that the cost is not borne system-wide.
> 
> Tested on the same Skylake platform as above, when the 64 GiB of memory
> was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
> latency test completed in negligible time.
> 
> In user space, we can use system calls such as epoll and write to zero
> huge folios as they become available, and sleep when none are ready. The
> following pseudocode illustrates this approach. The pseudocode spawns
> eight threads (each running thread_fun()) that wait for huge pages on
> node 0 to become eligible for zeroing; whenever such pages are available,
> the threads clear them in parallel.

This seems to be quite a lot of messing around in userspace.  Perhaps
unavoidable given the tradeoffs which are involved, and reasonable in
the sort of environments in which this will be used.  I guess there are
many alternatives - let's see what others think.

>  fs/hugetlbfs/inode.c    |   3 +-
>  include/linux/hugetlb.h |  26 +++++
>  mm/hugetlb.c            | 131 ++++++++++++++++++++++---
>  mm/hugetlb_internal.h   |   6 ++
>  mm/hugetlb_sysfs.c      | 206 ++++++++++++++++++++++++++++++++++++----
>  5 files changed, 337 insertions(+), 35 deletions(-)

Let's find places in Documentation/ (and Documentation/ABI) to document
the userspace interface?


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC18CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 17:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5BC6B008A; Tue, 19 May 2026 13:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD686B008C; Tue, 19 May 2026 13:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAC76B0092; Tue, 19 May 2026 13:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE1D6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:02:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C25BE14062B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:01:59 +0000 (UTC)
X-FDA: 84784786758.27.EE9CC2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 036D280014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:01:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e6nV9Gpf;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779210118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Dj+ULUFE/pU4JOGMl4yn2EWRU5617nR29Uc0u6svks=;
	b=Zv7GMlYlQTykJNbxvGVBmHpkf1SjUiggk3cngmYG9V7AvRSXmNeB8wi5oKE1alstJNeI75
	oBiTRzyjJ2mGqmp+6GmdMFqotOw0sBqQrRi9jvWAkfzfi+CQzYxVrfEhgWiT8zKGL+2Y4v
	4E09kgRq7js5+VuyDuKUqLqdw2W377s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779210118; a=rsa-sha256;
	cv=none;
	b=CWNrFra4c0Crulbu+fTl0GZ2n1dDBpub/FKMhFdOZDt2AzCl7B3GEAcoRjX0x2XfCNLqju
	2OVvpB985UtCF41cdubOYTqtmrnjvwKWEmgdFPDbWyamDpOOIvBQAlzuKFdPYlobvz5YKZ
	A+rmzlZ8eO+guA6eMNc8Ltup6eOpCY8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e6nV9Gpf;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FD1360252;
	Tue, 19 May 2026 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B437CC2BCFA;
	Tue, 19 May 2026 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779210117;
	bh=Cy/D7M3r9Gy98bOyegXLfNg7rkuz/ohcygE5dOo+HPQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=e6nV9GpfNstBdXq6ZdsifSX+niJrrOXZl12ydNb3DF/WfXaGAtFI7yoqe2zVJ8NRR
	 YpdqqA+LAOQP3cxAnOzxgE0qm03+DNHWn4hmI42t/HUXFBji5yQmTuX5WxtgsEPJp0
	 eGE4DycP5JbWZc63g1bO7iONJzCvzbELkvLRp0ug=
Date: Tue, 19 May 2026 10:01:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <michel@lespinasse.org>, <corbet@lwn.net>, <wang.yaxin@zte.com.cn>
Subject: Re: [PATCH v5 0/5] KSM: performance optimizations for rmap_walk_ksm
Message-Id: <20260519100156.05043f9d043889a5f60e22d3@linux-foundation.org>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 036D280014
X-Rspamd-Server: rspam04
X-Stat-Signature: 3um16hbry5o8e4eidackfhkjbbrnczmo
X-HE-Tag: 1779210117-832828
X-HE-Meta: U2FsdGVkX1+JtTJBgSZmo/LVkjGtmhp53E3dRUH2XMWOM7Vb3drYtM8/+9B3LPmtijS0DtbxRm09YhvSRna8KzZ91RlxeFj6Zlie0ehl91qeNyrN5udAlBwo8IBUHLU4S9jKgE0jo26AGD0wSbQP9vopV/aa29/T2M7878CpShbxSnFDkrHYO3os1s2nCA2jkf8nNJo4XjVdNEodWJWKXCTKZHcKYvqsleuZfOva3Z+y4nrxxItOfoJz6yfvdm4wNEwIkU4SDIldfr9oCIUdpvGlBtlB6SMy1HkJNm6+0L5TRrfUxyk6/303Oo//DEDjXaNFMzivGoePJlEkKCIUKGha4+LRBhgIQakfvBUGOHAoS8UpQ34NcLTRiqJKkg0UwR+DL7UntcXu0Anaea/zLKHTmnUazBIGtb4BeEkRUcCrHUd2G35q4bQg1fANts5JZEsA8WHxcAC964/Ucqjri1mFGSWyMNi6/xoeDPg/3eiLBA9gU7dYOAQiQCaEgmN5FNTBRbbtdQf9CNLWYrIblOdz7o5o10t/EPHf1OoHO8pXDh0Cho6atrXzOdat7X8dHLBsc+w2bpupoSia0ZpI2O8tISV3QBH+XT5ZQK2LOdUX2PUTlheLRwJtXZQ/2H2zOHBTqPhYm8ge1eLeg2Kpt2nHB4mKW+Kc6pLfChq59D0BWOn2pSnIK+/YQwYV45wVZOIpeBtWlR1ZIb+N5AV6/Ho2orQ4StODow3zFpCxWju/sZZue/aTEP9oxft0CRbg65RhqdzGxegK0ZBzs5vbkv08XFDPIg5La6sBaC7WJXlQGoRfO8PDr4dcommGzDdTINXC9qQazIw+KxMd+nVIvqqPSp78yt+YpO5Q7WpFJGLhMc0QaA3JgRWHSDMhypCsghkVnA/ID3YWNMlhtmyUMbbVvxTyJAIwRcDVVQfgeUGCtFTZKr9rB+usGTErpZ0coQqq/cQSz5PfUrepryX
 SQ64lbS7
 lzWt2SWy8DdFQIUeiCMod3/e3mA9YSglk4k4XdFVPM4iymQpmr80tgr51FtFZTBBTejodrwHk7I18AoRi3TOTBhFggCUOz4og3V/6+d+cpYGHzpAB2A4i/6Itq2tH1xF5aHPNTuS7pMBXH3qRaZvRrBivkZ83ZU/iG8KWUjwlgeVtwSgNbwPjBqIHFGE/dRBXpMUDV0X5F497Y5stIrhdtJ5n1CeDyBQUGKAAoYy6RBSSMlYl88vD1ImTcNg1wBC5fR0+k6mUEmzD/wgAk0ZZ+7Y40o5VvCzD71TBIYrz6IujP7lLpx8XmYkpiZ9Ze0cXYHP8Y9jiyfvH4K/4n4VkmpbwIqUqgUM12oKXlmPernbv38wMIC3e3TkREqvqNodhThLlYW7NwY5p9halaE4XdaymmnBm2VW1S72NlGUaM+rgv6JNlXjUeUJyKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 22:05:36 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> From: xu xin <xu.xin16@zte.com.cn>
> 
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> This series fixes a severe KSM reverse-mapping performance problem
> that can freeze applications for hundreds of milliseconds under
> memory pressure especially when a lot of unrelated VMAs sharing a
> single anon_vma.

That would be good to fix.

> Two key highlights:
> 
> 1. Lock hold time drops from >500ms to <2ms
>    - In our benchmark (20,000 VMAs sharing an anon_vma), worst-case
>      anon_vma lock hold time during KSM rmap walk went from 705ms
>      down to 1.67ms (max) and 1.44ms (avg).

How real-worldish is that benchmark?

How much effect are our users likely to see from this patchset in their
real-world workloads?

> 2. Real user impact
>    - The anon_vma lock is also acquired by page faults, reclaim,
>      migration, compaction, mlock, exit_mmap, and cgroup accounting.
> 
>    - A long hold due to inefficient rmap walks stalls application
>      threads, causing latency spikes, reduced throughput, or even
>      container timeouts.
> 
>    - The problem occurs even without fork() – VMA splitting (e.g.,
>      via mprotect or madvise over time) can create tens of thousands
>      of VMAs all attached to the same anon_vma.
> 
> ...
>
> Changes in v5:
> - Patch 1: replaced local_clock() with tracepoints – no overhead
>            when tracepoints are disabled.

Thanks for that change.

> - Patch 3: switched from vm_pgoff (unstable after VMA split) to a
>            linear page offset.
> - Patch 4: adapted to the linear page offset; added user-impact
>            description (real workloads, lock contention examples,
>            VMA splitting scenario).
> - Patch 5: simplified to a single process with 32 pages (instead
>            of multi-process), as suggested by David.
> 
>  MAINTAINERS                          |   3 +

I don't recall seeing any discussion about you becoming an rmap
M:aintainer, perhaps I missed it.  Thanks for the interest, but it
probably would be better to propose this as a standalone patch,
separated from this series.


>  include/trace/events/rmap.h          |  73 ++++
>  mm/ksm.c                             |  48 ++-
>  mm/rmap.c                            |   9 +
>  tools/testing/rmap/Makefile          |  11 +
>  tools/testing/rmap/rmap_benchmark.c  | 529 +++++++++++++++++++++++++++
>  tools/testing/selftests/mm/rmap.c    |  76 ++++
>  tools/testing/selftests/mm/vm_util.c |  38 ++
>  tools/testing/selftests/mm/vm_util.h |   2 +
>  9 files changed, 781 insertions(+), 8 deletions(-)
>  create mode 100644 include/trace/events/rmap.h
>  create mode 100644 tools/testing/rmap/Makefile
>  create mode 100644 tools/testing/rmap/rmap_benchmark.c

AI review was only partial, for unclear reasons:

	https://sashiko.dev/#/patchset/20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn

Please take a look, see if there's anything useful there?


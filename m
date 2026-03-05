Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D3CF30959
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD426B0095; Thu,  5 Mar 2026 08:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AF96B0096; Thu,  5 Mar 2026 08:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75FE06B0098; Thu,  5 Mar 2026 08:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6260E6B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:33:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 031B0160144
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:33:01 +0000 (UTC)
X-FDA: 84512100204.30.A0DAABF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4247D40005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:33:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPcRkrdS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772717580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGJRH2dUOlTxcja4KlQNlyYSEAHWL+xcv8VfogJsxkE=;
	b=UnMmCbgYCeis91V0x0CSnUVEUriPCdfVdHwPH7D1ZbQXDG5uwmLAHD2gd914hakz21AElC
	ZqRfy9rf7o1ygU4wmq/htx4QQYTZGsx1XrcIo4TKY3xXaF3EY+KLmx1jhT/b0b50Vbox8D
	tf1uxl2/yDOnZvBNkuSPOuL7Q+wLrOs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPcRkrdS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772717580; a=rsa-sha256;
	cv=none;
	b=olEhc/4DrTIuxYXLJXDZbw4iil2lySaXA0e/PSOSwwcU4q/G706sv4MDQB6ZhIBxKYrb+u
	Vrf274JfzRmfq0521xl4TRvL8li6fyoncMvHdgLa0Zv/2YKwHj43xUAbjotVTfF+zsST54
	BLzoh7pioPPL2F1ue8KvgKzPTTk457k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D0966184D;
	Thu,  5 Mar 2026 13:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549B7C116C6;
	Thu,  5 Mar 2026 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772717578;
	bh=siCDPUyJkhmZJ+Z9bW2VgMjcMK37fNr6QVsSBWZ4794=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RPcRkrdSnQlgCCOm5dAW5evRzE0anV8F9AUk+zy5lNaC77Dl99PL+duuKShSHMr6N
	 AazFdGtXtGiyPBV+5aB2O0MiW3P7yUIX0K2npXhP0JzEtDR9u9IQu3d4Le8xuYP1Xm
	 mLIbPNMUQrHuulR3FkDQ1XCh12+/TvxwgrNSuw4kQzKLepia6V9DjiKKzKsFJS6WU4
	 5ocJPdt8T5wzYdBN8vOvKqYPOdZE81PryU7nwQgbSWzTLfyXK77kh7gWtvHXSKSYaK
	 cyC7uUqY+lTXrzPFhAbHr6DTZ3DzgKdaAgvOF9Q7HHD7K0Gy3LEtpB2ebfs6Ij+mZq
	 +49fFjmPcKjIQ==
Message-ID: <c5330f9e-db41-496b-b580-73ebec9cd811@kernel.org>
Date: Thu, 5 Mar 2026 14:32:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Andi Kleen <ak@linux.intel.com>
References: <20260304155636.77433-1-david@kernel.org>
 <b24be8c2-32d3-4e3e-9fbf-8a0068c360d6@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b24be8c2-32d3-4e3e-9fbf-8a0068c360d6@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4247D40005
X-Rspamd-Server: rspam07
X-Stat-Signature: r1jcba4rs51n9gfyxoet73hprar33iq8
X-Rspam-User: 
X-HE-Tag: 1772717580-952102
X-HE-Meta: U2FsdGVkX1/5i/WZVo/a7bEkyKTw5Ilb6GxLqNJulJANxO3dI5OV1UDbtV61OayRsKAT8pdCaW18JaCc9v0V/0Prx6YYT++k5x/YjfzDFuqEUt6K1bTwSqyv9YGcpZt8tkCwjJcW0QrWDov3KxU5kiNfQtwb1PeKTeRkiRGC24KZgkf43qocgwbTqqgeST5LME2fJFqkfoPE4MJsuOzzQOoV/iJBl0XiObqo3DSxJbDA5kobuFVZ4D1XZYYV2uQYFvHuR3ltwo1EOb/Tb/TqQV5o18gGStpcc7hS1zCcZbmYV54GLIDap5ZuMDVm8nkyWV7dDYMpbVFiTO0e83QzEmy/4XBbFba493I/3UbiJOkkAa+CAYsrNH0/u5a415bTk/UECUVRJGXXPC622BZzsLqKHZwlNoPezxEcniKfLgfXK6AQ1ndYp2CyZOF7TAHCu4qdt7fe8KuVzUgXXREhQAPlbVelbB0cILDOoFXQLh4FQm4YGniZYWQSm1+g1ic6FKgxaQYFtAkoIyBjhZqk+E+uALE9CG6aXUjBOHGNIM5u3nsCbAnq5Ze73gt3qgYJNTnty2/FFCgac4gu6yUJrD2W8ULG2ADv0ktyRwG5j3j3YNJlmx4+6UVsvOP9xUjxjtXQfXzwWa1t+frHW4uT8BSvPkxiqsCzk9b5HvoE3Bf/CC8QnGnS7kKVYh1szo4UdzUxxT1AWMWkXBp7BjjXHiY756HdAil8JC7UuA+msfEYJWBJBbnzcHzVjqEk7CPJe21iuE4j3uT3TVqF9inMgktetxZNijDjSChpKa51sjIbemj3Zsa7lqlxL4VbqeY9/RkOa7rG9LPtr4Yy+qB4rKfIBT8zwknEpThDznoxGjhAEG+SjH+4mog/gawEVnherevGjPCdJ46AY2DuWwKc5FdPtyZo5dO75AkHNrx5qgvyMYmb3lPDyZvem+dIquw2PM9U0Abm9mZhp3ybvLI
 VOgxwYqW
 VOa50NYULiFJ5/0D+Swz8ZStQosoSkr1TBDgncgVPl3Wd4CBT1tyg6YSnTrzgnOdSkJCseUwI4YSnXci+6f6NqKjnheS7YLt6kL4MitMFWUX7A6t3CpUbKSbBmvyxQlzqRoD/N4YzphvNNMJpqKvpXvmfwOEHex0EWnS1b75Rhvw0lMS8/+NRmcJMR/d+CxQgBNn7AzQ+J5GEM8Uq315JZcerPiqTRCGlb3GxvLnkhU/RLzArrITxKd/Z5B971DAH84ti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Ah wait you dedicate a whole paragraph after this to tha :)

Correct :)

> 
>> +mapping that is currently resident in RAM (RSS); the process's proportional
>> +share of this mapping (PSS); and the number of clean and dirty shared and
>> +private pages in the mapping.
>> +
>> +Historically, the "KernelPageSize" always corresponds to the "MMUPageSize",
>> +except when a larger kernel page size is emulated on a system with a smaller
> 
> NIT: is -> was, as historically implies past tense.
> 
> But it's maybe better to say:
> 
> +Historically, the "KernelPageSize" has always corresponded to the "MMUPageSize",
> 
> And:
> 
> +except when a larger kernel page size is being emulated on a system with a smaller
> 

Given that the PPC64 thingy still exists in the tree, I'll probably do:

"KernelPageSize" always corresponds to "MMUPageSize", except when a
larger kernel page size is emulated on a system with a smaller page size
used by the MMU, which is the case for some PPC64 setups with hugetlb.

>> +page size used by the MMU, which was the case for PPC64 in the past.
>> +Further, "KernelPageSize" and "MMUPageSize" always correspond to the
> 
> NIT: Further -> Furthermore
> 

Helpful.

>> +smallest possible granularity (fallback) that could be encountered in a
> 
> could be -> can be
> 
> Since we are really talking about the current situation, even if this, is
> effect, a legacy thing.
> 
>> +VMA throughout its lifetime.  These values are not affected by any current
>> +transparent grouping of pages by Linux (Transparent Huge Pages) or any
> 
> 'transparent grouping of pages' reads a bit weirdly.
> 
> Maybe simplify to:
> 
> +These values are not affected by Transparent Huge Pages being in effect, or any...

Works for me.

> 
>> +current usage of larger MMU page sizes (either through architectural
> 
> NIT: current usage -> usage

Ack.

> 
>> +huge-page mappings or other transparent groupings done by the MMU).
> 
> Again I think 'transparent groupings' is a bit unclear. Perhaps instead:
> 
> +huge-page mappings or other explicit or implicit coalescing of virtual ranges
> +performed by the MMU).

I'd assume the educated reader does not know what "explicit/implicit
coalescing" even means, but works for me. :)

> 
> ?
> 
>> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" provide insight into
>> +the usage of some architectural huge-page mappings.
> 
> Is 'some' necessary here? Seems to make it a bit vague.

I had PUDs in mind. I can just call it

"PMD-level architectural ..."

> 
>>
>>  The "proportional set size" (PSS) of a process is the count of pages it has
>>  in memory, where each page is divided by the number of processes sharing it.
>> @@ -528,10 +541,14 @@ pressure if the memory is clean. Please note that the printed value might
>>  be lower than the real value due to optimizations used in the current
>>  implementation. If this is not desirable please file a bug report.
>>
>> -"AnonHugePages" shows the amount of memory backed by transparent hugepage.
>> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
>> +memory backed by transparent hugepages that are currently mapped through
>> +architectural huge-page mappings (PMD). "AnonHugePages" corresponds to memory
> 
> 'mapped through architectural huge-page mappings (PMD)' reads a bit strangely to
> me,
> 
> Perhaps 'mapped by transparent huge pages at a PMD page table level' instead?
> 

I'll simplify to

"mapped by architectural huge-page mappings at the PMD level"


>> +that does not belong to a file, "ShmemPmdMapped" to shared memory (shmem/tmpfs)
>> +and "FilePmdMapped" to file-backed memory (excluding shmem/tmpfs).
>>
>> -"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
>> -huge pages.
>> +There are no dedicated entries for transparent huge pages (or similar concepts)
>> +that are not mapped through architectural huge-page mappings (PMD).
> 
> similarly, perhaps better as 'are not mapped by transparent huge pages at a PMD
> page table level'?

I'll similarly call it "mapped by architectural huge-page mappings at
the PMD level"

Thanks a bunch!

-- 
Cheers,

David


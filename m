Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D87DFD7F97
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9544E6B0005; Fri, 27 Feb 2026 06:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902046B0088; Fri, 27 Feb 2026 06:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800C56B0089; Fri, 27 Feb 2026 06:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69AD66B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:14:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEFBC8BFDB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:14:06 +0000 (UTC)
X-FDA: 84489977292.04.B816138
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B68B20010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:14:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fjb+QxCd;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772190845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXPJJ+uhWU3/FibG5pPc63uoF/bg2b2LZnaOHcLIOXA=;
	b=abkayBLa6KQhowsxrkdfW11SkemxuyILW5d6fgMofJmCbE29W4srqOm4MLUC0AH8boR+yJ
	c4urkYFhD+zklwKQG6eFndNk2M/2Ip0yhdB6/U5tjNkyRVyZRax6LJCHnBEvaaYHcPn7ZG
	iq4NAEcLv72hnT9/IkKyTUT/Z4FZ9WQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fjb+QxCd;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772190845; a=rsa-sha256;
	cv=none;
	b=uKPGpfef5L4wGUM4adCPFq4y3KmlZmDtuzJHdzJDepGTbjo8xqFqSL4gbSu6BhEqeRn3og
	hOt4ToPVD/YWEXGvGBZqMsjhZY+6IgmmcUhL+N431GPgZEA67FfkeCmqg7QvJ6LKbR3X8u
	FE0G25zxBNKjQyHcisFbgMszO/G3Oc0=
Message-ID: <1d3a4e8e-9ea0-42e7-b8e7-d92fb27f80f4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772190839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXPJJ+uhWU3/FibG5pPc63uoF/bg2b2LZnaOHcLIOXA=;
	b=fjb+QxCdpTD3b4hr6YJTVtQxFdL+ygkZ8Otiw+cAUP2giw6sWDiSAgMSDuqQT6kvToVNoO
	8K59vpmdlkwEvSNRr24BZt7S48RvMyWCLaDD2DvslmD5YU5FO7ZumLMbqR8ln6N1qw/OQO
	ZU+NrOiKyaHHCpYxVLcB1Tyhayipyrk=
Date: Fri, 27 Feb 2026 11:13:55 +0000
MIME-Version: 1.0
Subject: Re: [RFC v2 00/21] mm: thp: lazy PTE page table allocation at PMD
 split
Content-Language: en-GB
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <CAA1CXcAYt3OfW_uBTYZgr-dBhg99x=5pUs5uvqtpg+PNJ1KxGQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAA1CXcAYt3OfW_uBTYZgr-dBhg99x=5pUs5uvqtpg+PNJ1KxGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kynhtz4p6ownxzcbjwcgj6etwrq315qn
X-Rspamd-Queue-Id: 5B68B20010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772190843-721319
X-HE-Meta: U2FsdGVkX18Ooo2HyNkCVC/pcPPAhkMnlt0sbqGc+8QeXfRnYeASxs2ZOjWfBXBYsY+jsaBu1cpr44owt5jWM+/r8lHMxUzQUZIVlcGVqtlYEIQn1pvcYDY6g8QB04rsOsohIHasGPQTZtOqCd0ZQW0JPASnEqCnD1pqGJXA2dUH9umIhwrPBM72h+2OvT7ClFXAgFkiuoYxXxXxrYdsMqBKr7sCBLOT3SARVsZEF/e0lyDtdz1q1/MK1SZaXyOzxKw4gvUX4BdF9dtf2YNuvjFbcfCsZzc1kTNUdwznTGumQJvRqCrlG34K1H1ZQVYkacmosudqKGq/9lm8/9qWv7x0WIpzfrs4rUzYn11TcAv/8UTSoojQDNhxmvYVjBhMYbjqKXxag1oJsPb78yh7FfAbPSRD2fZ4jkEozmerbZVx7odLOn5fprpXp3lsS5KcDEirDMzKY5qg6TBOWFmnu3aoY8LaCD3CAEcj68ZHNEHi7DFl7Vg84E0AIsuufmY+cI8CkmpxeB3l12vaZ5COJm2Nh98ioCIZZenI1RZ8ZbsTyDtI195GZpUEtOKTOfPgXg0XcK0+0S/YXA+ZoOkDCDT70v4YeAGNIilNjnRmyGx+FEmT3+IA5HQK2+vJDW+rUTrZqEfJqWHR40pRLjRcEVn3lC2ZiDf0Bl6Q/KSp3BD+4D04jPv3NzRQt4PVnjFfnsTpAhR41OYVtqVa62cwH/YHS7ZBFJnGgLpn1HZZnd/i4DZ/4Vw/fhbZqybOH2M4eyqfdCikGh9TmVoXyq4+LTtcs2TJGQVPc4nOtfEerCc3grtdf7HLZkf2zxji7qg31SqpE+WlmX8kEGEpiSen2tRjessoYysO2Tm8j/ZktZxw39o1IDG7fuNLv0cULkh9WJAlHANruGWlJ42r8dRsg51puSiOxXcw7+iJ2iLpISye5J2/1Xu6zHZYkT64SoVaBcvl8RACf6z6mE5CTtT
 EHGwABYc
 YwTC52vsgbPHjjRR6hYdHGgP354ujsAQyaF5Zr4MN0LfrII2OrcISQ43falCxzEFzZ+hXHLjnlqfuofmCeBg6lIPyoK0M2F6pGrBQvbFm041e/45C4yoauwBYa98MYOa5FxbEcqdLWXnRTJEDgsfCkgVJ3y0EbdKHIsQGdA/bJhJ2pWCBL05IzZX8avpk8MKrXZGs/opYtvN3KJyBWi3HubUqekIhyIFURkg3NyEAcvQQkrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/2026 21:01, Nico Pache wrote:
> On Thu, Feb 26, 2026 at 4:33 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> When the kernel creates a PMD-level THP mapping for anonymous pages, it
>> pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
>> page table sits unused in a deposit list for the lifetime of the THP
>> mapping, only to be withdrawn when the PMD is split or zapped. Every
>> anonymous THP therefore wastes 4KB of memory unconditionally. On large
>> servers where hundreds of gigabytes of memory are mapped as THPs, this
>> adds up: roughly 200MB wasted per 100GB of THP memory. This memory
>> could otherwise satisfy other allocations, including the very PTE page
>> table allocations needed when splits eventually occur.
>>
>> This series removes the pre-deposit and allocates the PTE page table
>> lazily — only when a PMD split actually happens. Since a large number
>> of THPs are never split (they are zapped wholesale when processes exit or
>> munmap the full range), the allocation is avoided entirely in the common
>> case.
>>
>> The pre-deposit pattern exists because split_huge_pmd was designed as an
>> operation that must never fail: if the kernel decides to split, it needs
>> a PTE page table, so one is deposited in advance. But "must never fail"
>> is an unnecessarily strong requirement. A PMD split is typically triggered
>> by a partial operation on a sub-PMD range — partial munmap, partial
>> mprotect, partial mremap and so on.
>> Most of these operations already have well-defined error handling for
>> allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
>> fail and propagating the error through these existing paths is the natural
>> thing to do. Furthermore, split failing requires an order-0 allocation for
>> a page table to fail, which is extremely unlikely.
>>
>> Designing functions like split_huge_pmd as operations that cannot fail
>> has a subtle but real cost to code quality. It forces a pre-allocation
>> pattern - every THP creation path must deposit a page table, and every
>> split or zap path must withdraw one, creating a hidden coupling between
>> widely separated code paths.
>>
>> This also serves as a code cleanup. On every architecture except powerpc
>> with hash MMU, the deposit/withdraw machinery becomes dead code. The
>> series removes the generic implementations in pgtable-generic.c and the
>> s390/sparc overrides, replacing them with no-op stubs guarded by
>> arch_needs_pgtable_deposit(), which evaluates to false at compile time
>> on all non-powerpc architectures.
> 
> Hi Usama,
> 
> Thanks for tackling this, it seems like an interesting problem. Im
> trying to get more into reviewing, so bare with me I may have some
> stupid comments or questions. Where I can really help out is with
> testing. I will build this for all RH-supported architectures and run
> some automated test suites and performance metrics. I'll report back
> if I spot anything.
> 
> Cheers!
> -- Nico
> 

Thanks for the build and looking into reviewing this. All comments
and questions are welcome! I had only tested on x86, and I had a look
at the link you shared so its great to know that powerPC and s390 are fine.



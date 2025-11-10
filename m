Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB994CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D43A8E001A; Mon, 10 Nov 2025 03:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D318E0002; Mon, 10 Nov 2025 03:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6D28E001A; Mon, 10 Nov 2025 03:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECCFA8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:57:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF0D64CA00
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:16 +0000 (UTC)
X-FDA: 84094093272.30.F13E079
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E47D1C0009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUPDg6ra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762765035; a=rsa-sha256;
	cv=none;
	b=5TOg1zEGnzv/21GqdwoP4qzh6HuEHo6fxWdeFud9PVZV2p7ksb1CAZ0pOoYJMRyuJHGJNX
	V4ESxXr96xyW4X1tR0AlcSO3XysSN60nRPRlguS4YCGak2Wyh44Aphncb1d2jAcffta3aO
	TibY1bzR1+NHw0l4z5ypytWGbmFfr4Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUPDg6ra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762765035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxoQM4MZjtvP43L1sUBdHepjW32L635LM9t36Y1IPmg=;
	b=21WkoNc6k3VHDtTWDJi7OlJxWScZaU9pd5/h+9GdZ33V9xBecKbGWcnebrcMtwN7D0AZzu
	EzHOGF8hLSCYiN0uNA2OhALlWFLb1pdfg+PVjZ/duGvcB4fk6IJE5wFJc2PYQP2UaOJ1Qb
	prTz5ZCp7HnQMwI0+VNt+qrP3a7Bp0I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A25E60008;
	Mon, 10 Nov 2025 08:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C041BC4CEFB;
	Mon, 10 Nov 2025 08:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762765034;
	bh=IWZV6AGpsZj8OoXU3sEMbwaFtC47+y+rHg8Ngr2ah+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kUPDg6raagQDZr8nbIX4JGggpv2JCysZCrSuuJBXAvkOkpmldIwBO2hWImaNLdiJv
	 kuyZ+YysstcvNnb4WQPgVmbZM5CSDtPWRGxcrTlfEUOdvecOls9IMpgTaix+urYgbu
	 huWs+vQUy8KEoxb/3haW7OgXGUzXil/5g8ZfAqscM5+mxa+3Pfxw/t+wKX864xd4Ae
	 uy9sv43PYe2X08SideJ5+3Lm7vIMvh9xT8Vh59rBA4rVMl5Omjqti6IE8JnpWXPJqa
	 s309ybxosVHLOgq907b6dWUgmCDm4Nqb1urxPtDviC514V8DQgkz6Vj1x9eJ8eCQSL
	 wY9WtHl2+H3Dg==
Message-ID: <93b2f5eb-362c-49b7-9d90-01d250c9b6ff@kernel.org>
Date: Mon, 10 Nov 2025 09:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] mm, folio_zero_user: support clearing page ranges
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-7-ankur.a.arora@oracle.com>
 <77b2ae9c-2700-4c7a-ae45-323af6beaff3@kernel.org> <87346o582b.fsf@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87346o582b.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E47D1C0009
X-Stat-Signature: 3iqj4gzwptojuz8kbb3kdb9wb6kzc35o
X-HE-Tag: 1762765034-68971
X-HE-Meta: U2FsdGVkX190/686/knWlTuE0MCo+/7J/P3VW2AMCbi1GnR+rzc9tGyiqn+AwMJWM6r8XYzRm5q49H2+pCQ6LQ5kDR9s+D+qkeGYRd8p65y9Ss65XG1bzyo0HI/pycQLX8RMC34QPl4pd3cekCFwSKBbiOJhlalEttnu8FSK+52dXXujnjlIV9BlozVjsqkYUQTuBjSW/05GJ/OJH7EIYEvPhydgS4Q2c7KOe8MeFIe9zqisl9zgwa0DBi/bM3R5Ewq70LhcP1fZxphAqoLtfPnAEAkKENV4ktG1Eufb7T0D/BlERDwh2mIe5laH1EdFxpcvSl9Jxtz9oLmL2tGITyZPYPbmrzA1OxGubH7n3JajB2NxoE3RCKLlZv8Ne8JJZ5tsdKjVr+fyFIXYN/gVrylVpry60C7+blTnTbPqgZc9ZO35qLQO7GxSaQZAvzl0qEd1ct8CEBXXy2AYuKRD3rgrU/3nEWuJbTX+z9fe/FFL5VLfhbq6VCXumzpbFn3afUiSRUuT/AM3Gbo+Tvr1oHa0m+GdRXZl9rMbvVaFC3Gdg9UMez+cA415o/+If7RVpfLIGDXzAmx7N5wMDLT3N8TIuAxxd1bpVo41mLaQzCn0fM+o1re9sJMV3NPovuE3Prppfw4OJj6SdmpLFbRd0Y7GPiUnBGEmtrLvZOkhvnLDY8OebQNA2fDR35SaPWbBmPu81zyboNBPQlAY/DYodBdFTqb2n9DzpAXrQ3ngMnGmqviz+XLBO3KfRH/SUYNyDgSRjQ/jXNiWQv+UbRfoDZWfVqxAKNUiZ+PMFf2Bk3UwHxF8r0n1/SIdR5aGf/OMpr+It6QtMM8NiMxrvOlKJRBfXU0h8dDsErjrwQGns51fQHqZZJriViwU+SXLL02hNTru14DDZ55xp+HQTfh9njE0smyclskRuQJuFmxdT8fbdxRvAZeDnR53ON6TpsYQJXhAaRnsWQmCJJKjg3f
 B7SeFqwG
 oi30oSCZ+1RgSdlS84UQJmQ7qoITjQbwv4mpcxLYNCn0RV58caq+5eQ/v4MZ54V/uQeQe9cQVSECYd1qatuxepMnWJMTID0YgFO3IbCh5eOD9nhL6F0X4qLHIhu8onGAm46+rsirLeAhwMvb/bV9eGakVoWtV+SB4OFcKmSBikwjnlx6KgAMSxWbJSAtqMR2DcdGLHZiCVGvc/eN96ccPy/Y04AXqUnlRfh4tas60Dv0DdsLC3Fr0dHX7GMHp9/iCqgpawRDMQY2E3O7+oYcWxgeYLH0BQs6o79Odl7EGXeWYslXTic6d7zVR8Q9qB1aKfb2yGb5JrN843C3g0UDzpsaUitkFGNqc5OrY/sPSSlb8plap6aHm1aLqX8x/y/dshWM/LI3vBLxFAFSWQeAJXkjuTWBs6WSY2Hy9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 08:20, Ankur Arora wrote:
> 
> David Hildenbrand (Red Hat) <david@kernel.org> writes:
> 
>> On 27.10.25 21:21, Ankur Arora wrote:
>>> Clear contiguous page ranges in folio_zero_user() instead of clearing
>>> a page-at-a-time. This enables CPU specific optimizations based on
>>> the length of the region.
>>> Operating on arbitrarily large regions can lead to high preemption
>>> latency under cooperative preemption models. So, limit the worst
>>> case preemption latency via architecture specified PAGE_CONTIG_NR
>>> units.
>>> The resultant performance depends on the kinds of optimizations
>>> available to the CPU for the region being cleared. Two classes of
>>> of optimizations:
>>>     - clearing iteration costs can be amortized over a range larger
>>>       than a single page.
>>>     - cacheline allocation elision (seen on AMD Zen models).
>>> Testing a demand fault workload shows an improved baseline from the
>>> first optimization and a larger improvement when the region being
>>> cleared is large enough for the second optimization.
>>> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
>>>    $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
>>>                       page-at-a-time     contiguous clearing      change
>>>                     (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>>      pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%
>>> preempt=*
>>>      pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%
>>> preempt=none|voluntary
>>>      pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy
>>> [#] AMD Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
>>> allocation, which is larger than ARCH_PAGE_CONTIG_NR, so
>>> preempt=none|voluntary see no improvement on the pg-sz=1GB.
>>> Also as mentioned earlier, the baseline improvement is not specific to
>>> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
>>> improvement as the Milan pg-sz=2MB workload above (~30%).
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>>> ---
>>>    include/linux/mm.h |  6 ++++++
>>>    mm/memory.c        | 42 +++++++++++++++++++++---------------------
>>>    2 files changed, 27 insertions(+), 21 deletions(-)
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index ecbcb76df9de..02db84667f97 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3872,6 +3872,12 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>    				unsigned int order) {}
>>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>    +#ifndef ARCH_PAGE_CONTIG_NR
>>> +#define PAGE_CONTIG_NR	1
>>> +#else
>>> +#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
>>> +#endif
>>
>> The name is a bit misleading. We need something that tells us that this is for
>> patch-processing (clearing? maybe alter copying?) contig pages. Likely spelling
>> out that this is for the non-preemptible case only.
>>
>> I assume we can drop the "CONTIG", just like clear_pages() doesn't contain it
>> etc.
>>
>> CLEAR_PAGES_NON_PREEMPT_BATCH
>>
>> PROCESS_PAGES_NON_PREEMPT_BATCH
> 
> I think this version is clearer. And would be viable for copying as well.
> 
>> Can you remind me again why this is arch specific, and why the default is 1
>> instead of, say 2,4,8 ... ?
> 
> So, the only use for this value is to decide a reasonable frequency
> for calling cond_resched() when operating on hugepages.
> 
> And the idea was the arch was best placed to have a reasonably safe
> value based on the expected spread of bandwidths it might see across
> uarchs. And the default choice of 1 was to keep it close to what we
> have now.
> 
> Thinking about it now though, maybe it is better to instead do this
> in common code. We could have two sets of defines,
> PROCESS_PAGES_NON_PREEMPT_BATCH_{LARGE,SMALL}, the first for archs
> that define __HAVE_ARCH_CLEAR_PAGES and the second, without.

Right, avoiding this dependency on arch code would be nice.

Also, it feels like something we can later optimize for archs without 
__HAVE_ARCH_CLEAR_PAGES in common code.

-- 
Cheers

David


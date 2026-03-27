Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C6A10F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B2A6B0096; Fri, 27 Mar 2026 12:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB356B00A0; Fri, 27 Mar 2026 12:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB436B00A3; Fri, 27 Mar 2026 12:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9BA6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:25:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49E8F1B7120
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:25:14 +0000 (UTC)
X-FDA: 84592367748.29.2E4BC77
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5BCA2140010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:25:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YiI6Npr6;
	spf=pass (imf09.hostedemail.com: domain of aishwarya.rambhadran@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=aishwarya.rambhadran@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HZCCG8+XA3oTSuTyTt9BxxABsUMwIETk9fp94vf3ws=;
	b=pa/wDcii1GujLUx+Sy30u3xOregj4ssZuSLO1tQwLmkRPKqyKRFw6KPE2ZB/IC5u/v6kMm
	KLSGxpBPIIrweP8uaYbYPXgAG7++z529ZlISKt5uF3D0CGDXOn8ptuJpotXy2WNHMoWIGl
	Yn8OiGl7lK1k98NG5uqo/cWTTDcABIU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YiI6Npr6;
	spf=pass (imf09.hostedemail.com: domain of aishwarya.rambhadran@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=aishwarya.rambhadran@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628712; a=rsa-sha256;
	cv=none;
	b=z25tyL1ihdaoFlShuKXgVGHMcCwsiC3sIjwhJLqZSIE0Fv65A4E3dVWGcwTP7rj8EvaGZx
	SHKij5emMUzQDLwrnjvuyXEeXoFTO515XMJd8yUwyX0IZHcHisPzwTSirv8ma4AMgHsG6p
	RLp0iMewvjgPiBzyl9eWTe5txxKfSz8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24FC935DA;
	Fri, 27 Mar 2026 09:25:05 -0700 (PDT)
Received: from [10.163.180.175] (unknown [10.163.180.175])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB3E73F905;
	Fri, 27 Mar 2026 09:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774628711; bh=o37e/u2s3ApNY3T2Mivm5sQi2e7lLw78zt9EIlgSSfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YiI6Npr6YyJq4PlBLVpfqiUTOOL161bptBTF8MU82La2TI82X2RO4XSVDq+AGrDXt
	 LHhV9Pdl3j6OF27Npzjr4tIAziCsnEIupAbkdCevLtRBxf4jTYQjxcj+BAnG3ri7lV
	 w2AICP2O5dCu263VnHUEwfdWQqetcjrXRZ2nJ/Wg=
Message-ID: <346eeb8c-616b-4f4e-b811-ad1a3ae4a58f@arm.com>
Date: Fri, 27 Mar 2026 21:54:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
 Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org> <acV36oPNFMgL4puz@milan>
 <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
 <eafefe7a-a33b-4102-93cf-fecc33ddf49e@arm.com>
 <0f441d8f-d84c-470a-a4cb-0249b15220a2@kernel.org>
 <f100305b-6c56-4499-98a4-6a22f8c49443@arm.com> <acZVS-ehXCtvcA9s@hyeyoo>
 <d120d8d3-f785-47ec-9c6b-b28d42ebb1f7@kernel.org>
Content-Language: en-US
From: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
In-Reply-To: <d120d8d3-f785-47ec-9c6b-b28d42ebb1f7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1kjesh3btjqrwu6zsajy3ft45kzmiu41
X-Rspamd-Queue-Id: 5BCA2140010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774628712-383616
X-HE-Meta: U2FsdGVkX19cvSUp3FBfK5J9zPW36IRqtsevTAXQjuZ06M6r9EXBTXiDBbKRe3znzl1yGshJ7Sm1sQq/uKGFdWWLQ07QzyeGrc9w++1qxa/rzAj/16mM339XqsGCZD63CHX8T5GTSIqKIPHKGR3UbSUPLA83thKuEz+7obvn4fpNBt0rZa6/mXkcvnraNJlFjYSuIaD2Iwm8+p5yqBTEyM/SvBoXZOwZ7GjpONEUZ6m8ZrwYD7QevFxF4IW27/Z5nNV7tisMz0Ffw7fx9Kxb4KpFb6hyZiL4NnR2gPytzaJ9mUAlhVhS6SkoRYydbruxo6dg48OQ3V1afno6FFyjpsyepyPG1nDwBrLxPgVMhOvSxdbCKbIG8UCVN0r7D8tkS7geMM0zm7gMCdsIFTHxlVsQzuMNv8H0y7ZHc/llT7ddQlA6Y3cY0Bw4dZXxm/l1K1aI/ZQBMIl11YWI0WXnDTq+cJJ1h3bxq1wZCowsqkd3p7yHHyN3RruwSjglZTGc2GIY+xUFVB8XxxrQ1vS5tjPlUbPA2tz0hmeR2MDdiUcH/WRyIeUjZuhlJXMxIuUijdurDn0wH92X7zqoZ4UYqk2CLPsM+PFeYpovj91BdsWFpD3fCq/rlm/EebhwHkhfD0DibD1zWyRmUn9+IkBtKCgNUCue4YSUOuSQ134UgkkUBN+d4sna7/sTNk8rf0PvD/r3wwsQoAVQftklAIOUEu9GzE4h4XQlvl4oMnyxHWawS5nBVFd3zQ5gBs1rk4r3uiRH7hNFqai3pjePuRfMmdaXnGqsW9EIhklimzU6FURpfy/De9QSWJKyy5vB66xG+9xPBKylXk5BiEk16HHAo0Pj2fdsR39td8eyBOA1BHcgiLo6c9169bptOaEtIRQZ+NpAe+D3JcbC9fYrxshHMhte1kh9H5CRS1LZMydcZIVTkdit4jUcxJE1O4AME1hKlcDXU5Oy0JPI23NmWSf
 aOjG5CZO
 8ai7E7IrzNhduPVcN5QOYwVkU2fM/7OXZNMP9u76PCK51iBgZ7FZO2dS97JFIcAVIqi/MfeT0aGyjwyXW+SEr406B2OlrW62zsrtxZTbpVsvZDlRgHliylZ2o4Mh0WhZr4C+KjSSMVD4vLYlEcr9vfkpYS739b3TV5ww6QvafW+/1DIHoFcR1xqOBUvN1I7qgK59D8mUrgOt7gUp8y2/VYfl+rcCbwCzm/8sFpNa9e1yZeZtmeibBjTB0vQfCeUNPCLt9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Thanks for the discussion and the insights.

For completeness, the SUTs used are single NUMA node:
$ numactl -H
available: 1 nodes (0)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42
43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
node 0 size: 257218 MB
node 0 free: 255376 MB
node distances:
node   0
   0:  10

As suggested by Ryan, I re-ran and compared the perf benchmarks
across 6.17, 6.18, and later kernels. The behavior is consistent
with what has been discussed in this thread and aligns with our
observations.

Thanks again for the clarifications and apologies for the table
rendering issues in the initial email.

Regards,
Aishwarya Rambhadran

On 27/03/26 4:51 PM, Vlastimil Babka (SUSE) wrote:
> On 3/27/26 11:00, Harry Yoo (Oracle) wrote:
>> On Fri, Mar 27, 2026 at 08:58:36AM +0000, Ryan Roberts wrote:
>>>>>>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote: 
>>>>>> Right so there should be just the overhead of the extra 
>>>>>> is_vmalloc_addr() test. Possibly also the call of 
>>>>>> kfree_rcu_sheaf() if it's not inlined. I'd say it's something we 
>>>>>> can just accept? It seems this is a unit test being used as a 
>>>>>> microbenchmark, so it can be very sensitive even to such details, 
>>>>>> but it should be negligible in practice. 
>>>>> The perf/syscall cases might be a bit more concerning though? 
>>>>> (those tests are from "perf bench syscall fork|execve"). Yes they 
>>>>> are microbenchmarks, but a 7% increased cost for fork seems like 
>>>>> something we'd want to avoid if we can. 
>>>> Sure, I tried to explain those in my first reply. Harry then linked 
>>>> to how that explanation can be verified. Hopefully it's really the 
>>>> same reason. 
>>> Ahh sorry I missed your first email. We only added that benchmark 
>>> from 6.19 so don't have results for earlier kernels, but I'll ask 
>>> Aishu to run it for 6.17 and 6.18 to see if the results correlate 
>>> with your expectation. But from a high level perspective, a 7% 
>>> regression on fork is not ideal even if there was a 7% improvement 
>>> in 6.18. 
> In retrospect it was an oversight not to disable the pre-existing cpu 
> caching layer immediately for sheaf-enabled caches in 6.18. Can't undo 
> that mistake now, unfortunately.
>> If that improvement comes from the number of objects cached per CPU, 
>> I'm not sure if determining the default value (# of cached objs) 
>> based on "a point when microbenchmarks stop improving" is a 
>> reasonable measure because the default value affects all slab caches 
>> and will inevitably increase overall memory usage. 
> Yeah that's the thing, some workloads might just keep improving as you 
> throw more caching at them, but there's a memory usage cost to that. A 
> case of stress test doing nothing but forks might also not be 
> representative of performance of forks under normal workload where 
> other operations also happen, returning the related slab objects, so 
> in the end it doesn't expose the batch size that much.
>> Hopefully we could discuss what a reasonable heuristic that "works 
>> for most situations" looks like, and allow users to tune it further 
>> based on their needs. As a side note, changing sheaf capacity at 
>> runtime is not supported yet (I'm working on it) and targeting at 
>> least before the next LTS. 



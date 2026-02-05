Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AABEC1EBC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BBD6B0089; Thu,  5 Feb 2026 10:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEF26B008A; Thu,  5 Feb 2026 10:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB4A6B0092; Thu,  5 Feb 2026 10:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFEE6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:01:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B087C1605D5
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:01:52 +0000 (UTC)
X-FDA: 84410717664.24.5F10484
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27F2A140007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:01:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1OGaVme;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770303710; a=rsa-sha256;
	cv=none;
	b=pleeTs4UqM3sS5hRtjDj+C632lXQRNHhRdgPjZQ6VAH22L7/04wz10ue37eifwPl6g2eX6
	yqztbNxvkAS7ZPehW7E4yUdMJ9LaJ2v+K1NieVGCsnOA+x/7Nf2Lkj87f4Rxf4JfVJJ8dT
	mopPc2v6frKvvpdK2ZFAIqXc5z1IpO0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1OGaVme;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770303710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeEv7fnd0NPkK8yO5EsGkSZ8yT0L8dwlwYeRPZ0uSkk=;
	b=JztoYf5UPiFdAGtLZe6b8eJNB/yRWwmoPj11vBKfzIWNmNXlBLJY+hSu8ztE8t/c/QUxaY
	6hHTlbRNX9szVddHV7v4jJ9AYRozL0eta53+4jUDgrEFmRXhRTyxN3IVDkgjAnGTK3fm5W
	OFUmXlKj7Gg2Pc002FKzva8d4TNqCGQ=
Message-ID: <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770303707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oeEv7fnd0NPkK8yO5EsGkSZ8yT0L8dwlwYeRPZ0uSkk=;
	b=R1OGaVmeCDAWYZLObcFuiWzoPWWNt28v4igYWupPC//Zz1G0EDHuFGPWKTGAtHEUZLW2Fy
	3v4fmgvc2ba3Usxdf4CZjRo+kqepU2FyfthjVzh8xwyIbi026D1Signk4cST/7CbkfmxUI
	4G4+Ec/ufy2updDebH445fX0FG0OzlE=
Date: Thu, 5 Feb 2026 23:01:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, dave.hansen@intel.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 27F2A140007
X-Stat-Signature: seq9pubk9ez1tpam3c4adu6o9gosebc7
X-HE-Tag: 1770303709-716325
X-HE-Meta: U2FsdGVkX1/ffUdMLopNH/dGus3vlem3IcyXlVCVkXTjtl6qDpcu2DGrAXPziwQnkbSX2uopffwGJ3mtO0O4N+k8mClgx8Dnuib/Lj6o92TJOmNP9HqjLwncCP/Gxd9nN60QUQAZ9HLtnTHlai1j60wjJKADghJvKhkKnTYlvk19rgck6i+Ttdb36CBIj+Xjf4wlxGdoHZkFHfGCdVMNz30DhMcoZzg6Q6PHQh6WJiSdr4oXRfkrMix8bEFjckE71a2YHmKjTMPLx/ccPmkHA3FNjZX6oiStD5yHbZtQEc39GmQL064XsihTt+2oYJciZyXyY3FZPhGhk5jmJa/Ug0sWjFCXXDXxvTZgwGfve3DH76F6bC3oG1qyF11llOSOX/DcE2fonz8sGD/ceMhRlgdSJxdBIYoCZMskI93h8ODC1/Ydfb3rUrnPzfTrNVz8jSGoFLvPQDwOSQDOOLUUFSaohDVLI+tMLsJek60+c9LqAJ+druxHgY0vLTe+mOWhhE9TQxkHudqzaw7YqDZ0Nw/fyhvxdtkNeK4+QHNhKPX0AYoIFghNDPOsH70g1mJCHvTC3CyXsgcBjyyrUiyT+RXzDOR/K5UdYXujuU4FdSj2M8g9cGaNBRZhi8pde9UKjuqMcvbISRlO6zTcZAB3440llEXw7ILzl+yRKWt2HLuzDvVLcL3U2t1B92bf1RxZARdwE1MBAS55gFQtDMi6ca8cNdsIobiIFMcdEIQCFRyBniNziKOCxT9r2F5mQkl0nHUF8JLN+LJB5AFlwiAgHShr56wlgDLWieQ+8Z/uSvLIFXLEAh05Qw0Rmyhubca9sVlUhaOijYwP/CY3JXSzuvOtOjVA0HWFg9myZcjtXTYjDpJ5ct+QItXc5j+0I9pX1ouMzyX5etlfy9M3hTxZiu4hq6OmPh3vH4GQIsY32X6BAQvQ3XsTlSvRPdXOge08XqCRua3U/gCaA57bvFB
 TDjqb7dS
 Q/57ZA6YRJOtnUAAIYd5rgzNA4B/3Z+nZv3iFHzjnSfPNEr4x445tEPMv7RDQPjrGyPJLded1SkrTsAx5eti2Yv9F+f2Pd1UA83pVQCh2JoirepygH3RwFmW5J1eX2nCxew9KGgjZWj0j8vVDRpKBzAdjBld7fdk71g4j8KDb4Dou4qJMhwKhB50Kk03bg82S4lPR3MDduSw1sPVn+iWjydu5luNZoRKbpYUROvt8fOypd1Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/5 21:25, David Hildenbrand (Arm) wrote:
> On 2/2/26 16:52, Lance Yang wrote:
>>
>>
>> On 2026/2/2 23:09, Peter Zijlstra wrote:
>>> On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
>>>>
>>>>
>>>>
>>>> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
>>>> tlb_flush_unshared_tables() (for hugetlb unshare) and 
>>>> collapse_huge_page()
>>>> (in khugepaged collapse), which already send IPIs today (broadcast 
>>>> to all
>>>> CPUs via tlb_remove_table_sync_one()).
>>>>
>>>> What PT_RECLAIM=y doesn't need IPI for is table freeing (
>>>> __tlb_remove_table_one() uses call_rcu() instead). But table 
>>>> modification
>>>> (unshare, collapse) still needs IPI to synchronize with lockless 
>>>> walkers,
>>>> regardless of PT_RECLAIM.
>>>>
>>>> So PT_RECLAIM=y is not broken; it already has IPI where needed. This 
>>>> series
>>>> just makes those IPIs targeted instead of broadcast. Does that clarify?
>>>
>>> Oh bah, reading is hard. I had missed they had more table_sync_one() 
>>> calls,
>>> rather than remove_table_one().
>>>
>>> So you *can* replace table_sync_one() with rcu_sync(), that will provide
>>> the same guarantees. Its just a 'little' bit slower on the update side,
>>> but does not incur the read side cost.
>>
>> Yep, we could replace the IPI with synchronize_rcu() on the sync side:
>>
>> - Currently: TLB flush → send IPI → wait for walkers to finish
>> - With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
>> grace period
>>
>> Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
>> synchronize_rcu() also
>> waits for regions with preemption/interrupts disabled, so it should 
>> work, IIUC.
>>
>> And then, the trade-off would be:
>> - Read side: zero cost (no per-CPU tracking)
>> - Write side: wait for RCU grace period (potentially slower)
>>
>> For collapse/unshare, that write-side latency might be acceptable :)
>>
>> @David, what do you think?
> 
> Given that we just fixed the write-side latency from breaking Oracle's 
> databases completely, we have to be a bit careful here :)

Yep, agreed.

> 
> The thing is: on many x86 configs we don't need *any* TLB flushed or RCU 
> syncs.

Right. Looks like that is low-hanging fruit. I'll send that out 
separately :)

> 
> So "how much slower" are we talking about, especially on bigger/loaded 
> systems?

Unfortunately the numbers are pretry bad. On an x86-64 64-core system
under high load, each synchronize_rcu() is about *22.9* ms on average ...

So for now, neither approach looks good: tracking on the read side adss
cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
is too slow on large systems.


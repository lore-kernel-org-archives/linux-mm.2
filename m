Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B821BEC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0016B0092; Thu,  5 Feb 2026 08:25:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A14E6B0093; Thu,  5 Feb 2026 08:25:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DD6B0096; Thu,  5 Feb 2026 08:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D816F6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:25:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 861471604D2
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:25:18 +0000 (UTC)
X-FDA: 84410474316.15.20052C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8C3FC000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:25:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=syUPtY6w;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770297916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgQmMdETUQ1xH4jY5DUWEzekvlBDx253VXHHEKvaWks=;
	b=7C/OVxkAhCwo/NRRfUb78/0cxpSd9pGKpOCymiDOxFgPeNZmV3pTuGGxKs0ij1hdMfw11T
	ic3HsmbQiIyCxzLMwM9Jc9CIAAe/N2Oh+crXNKTFZ2OTxREKkq2w7DEuIiSAbvUF6rYzll
	+pbItkjLYayR+tJBGXeAURIG3rMGBzo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=syUPtY6w;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770297916; a=rsa-sha256;
	cv=none;
	b=t9aE1/ScPJOiV7C4u3iv3nEGQai6mGN8ZybE0tCLk9kqmNc/+XWggHsvTvCbWTSAoW2/R+
	4CubdriQfgslekF1ZxlmeNiP5yxB+Qu/PT86ttlj4WftyTzGAxfDk7J8EDg4G/PzWPc7Jr
	AOHh4307qx4hmN5o1UJigYYi1wrbgxY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EB46403ED;
	Thu,  5 Feb 2026 13:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0607C4CEF7;
	Thu,  5 Feb 2026 13:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770297915;
	bh=ZNnRI00WuKNETmTvhJmd7z3KdSrnG1/LdsurzwSvMV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=syUPtY6w30APzE75pzBQSESfdtrxIxyU+Wb4bl5STSoesRAQgZAS+B+O+5/jpmJ/U
	 dwYjT+SAXdf+ZZni8ujBAnmCclEaVM5dBvrXYnIhbsKNPU3gtHi5r4sGtLP1weUGYy
	 hzyqogeLtiOPBgN0XJ/SYMRW08nXrLGWMBCvKNhLMHwPDQKpEarWGo6DTaRt4zpimH
	 crT8snBDtzAZtyRImNdKI6ysnP2zgsFZlir3ohopfVbsA1xQ2YaEQWoVE5ZzRzzz2A
	 lSg5p4stvb3eFmwiaADNk+wNfUJ/QbF67gqJowQTAQ+JAgHWbYza83XTiqoRQKKqkH
	 HNeqrs7dTvAhA==
Message-ID: <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
Date: Thu, 5 Feb 2026 14:25:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Lance Yang <lance.yang@linux.dev>, Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, dev.jain@arm.com,
 hpa@zytor.com, hughd@google.com, ioworker0@gmail.com, jannh@google.com,
 jgross@suse.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 85fqs4o6h44koqegu4wyimh9ekpnziop
X-Rspamd-Queue-Id: B8C3FC000C
X-Rspam-User: 
X-HE-Tag: 1770297916-706751
X-HE-Meta: U2FsdGVkX19uYXqGqbmBCmLynhcCZPvNeikRhNOraFlw54yn+OFA7VL93ZioncPsdsll0YccHOyYBFPZjhn8nal/OLhhEUNN+2SYpyTJhYEwVI3cpGpklntW9s1WKJ0ytSllfwd4cHuYVXomcKChhviDIUc84V4WkYypSEi0dcYgx5ATdU4KUK5dJEcpKFIt5ri6HrQZ/cMChaQ72gaZdAjitYpkx4+81x23W1DtjDRzt8iVGPPaTGpYBjBwUNclMbqdB/nrcF/eMGFa48jrnRlVxQa9o5fXVlGj7/AmYZFdbgHvesGQqTJHY4oDQm8Uyz7Bt2X3cWnK2w0CvuUtRWibiqM2W1uAvc8zU135nb1jKet2JN/QW7bXWBiDk+torE2pv+hMdXL8JZXuOPGGqIaZCu4YQ3UHE/jcYXpNBClBTglI6KO9SAOxLqDsddgqLMx9F/uPQjIxl4OQc0ZA7XRheU34HxJIGij3UuGFGnmSXVA2QU5785OuKdFPJ1WgU/R7JHf0wQeMz/iEYTq9sYhp4hxk6TRLJvx7GSASCGd1UBXV1xPSzDETBPFcYY7j8EURKTOYLo2SKSsK4OYpcXvBmqAv11jabakvdxtWVMCor0s/IGH9wwCRw2ZTlCv7WRFmLoN9DZe/yosKbuJpnfxJZP/30Kf4MUNMTMDgn41hA5hKUcjBGfPydjBi9z7dQIlbudwmNLim8X+bjqmrH9m8LjIH5uXtuJxeRgB4/IeIqSCbPxhPBNLJ7xm/dGd/2u9RHLpS8lHcpzbee3Py6H6CQe9SKzcaKZvYf9rufl8jCKG7HqgUBoHrE9MUxGZsxFkgpEB1EMU+jN3vd1rNvtcAorV9ZisaDmnn8eBKx8BlKDCadzddUv6Fs+TD/bHugAcGGRDNHr9ItXvdWQugmKGVGSFTYNYGGXIQ50QVto0jIkRRq7M+7lRP6vXDwtJG+ecqqGltbsM0sF3GmE5
 hniSsfrd
 PZFLfC7JNYkZ5kcyYYHkOlNIOE3HAAxTe0KaSegv0Thfhe3bs7rY9rvFuZbzDnpC/HZfVqbAWW1aUvW4MlCizELeUcC1vOMGzpnPnMOHvN6fjAvOQq+J8s7+vf/hmnS8mwpm0cCMXjDjvTUHWc6Av8nlRnBDnxu1kNBRSDQB0oj7apPEPfLs/2VU92MKpa8EW8ODG94sqE4G7scB4s/vhH8LwCOf+U1FtLBTZj1tr1fcqDgTvr+WCrvA17JtoKF1+1ghd9arry3KvDdBRNgYCINc/kl7eA9vdFBBk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:52, Lance Yang wrote:
> 
> 
> On 2026/2/2 23:09, Peter Zijlstra wrote:
>> On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
>>>
>>>
>>>
>>> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
>>> tlb_flush_unshared_tables() (for hugetlb unshare) and 
>>> collapse_huge_page()
>>> (in khugepaged collapse), which already send IPIs today (broadcast to 
>>> all
>>> CPUs via tlb_remove_table_sync_one()).
>>>
>>> What PT_RECLAIM=y doesn't need IPI for is table freeing (
>>> __tlb_remove_table_one() uses call_rcu() instead). But table 
>>> modification
>>> (unshare, collapse) still needs IPI to synchronize with lockless 
>>> walkers,
>>> regardless of PT_RECLAIM.
>>>
>>> So PT_RECLAIM=y is not broken; it already has IPI where needed. This 
>>> series
>>> just makes those IPIs targeted instead of broadcast. Does that clarify?
>>
>> Oh bah, reading is hard. I had missed they had more table_sync_one() 
>> calls,
>> rather than remove_table_one().
>>
>> So you *can* replace table_sync_one() with rcu_sync(), that will provide
>> the same guarantees. Its just a 'little' bit slower on the update side,
>> but does not incur the read side cost.
> 
> Yep, we could replace the IPI with synchronize_rcu() on the sync side:
> 
> - Currently: TLB flush → send IPI → wait for walkers to finish
> - With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
> grace period
> 
> Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
> synchronize_rcu() also
> waits for regions with preemption/interrupts disabled, so it should 
> work, IIUC.
> 
> And then, the trade-off would be:
> - Read side: zero cost (no per-CPU tracking)
> - Write side: wait for RCU grace period (potentially slower)
> 
> For collapse/unshare, that write-side latency might be acceptable :)
> 
> @David, what do you think?

Given that we just fixed the write-side latency from breaking Oracle's 
databases completely, we have to be a bit careful here :)

The thing is: on many x86 configs we don't need *any* TLB flushed or RCU 
syncs.

So "how much slower" are we talking about, especially on bigger/loaded 
systems?

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B159CCD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B076B0093; Sat, 13 Jun 2026 15:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C196B0095; Sat, 13 Jun 2026 15:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22466B0096; Sat, 13 Jun 2026 15:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B43A36B0093
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:48:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B073120531
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:48:43 +0000 (UTC)
X-FDA: 84875926926.04.9EF1454
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61A26A0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:48:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PyTSQqhD;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781380121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZ+fKOUTrjEe7a3Zt3i1yWnHuMhAMIAMfhCXMZjpQqs=;
	b=IcYLOM/ed74JVML4ab9Xk2lbwUQ3UrU+njbYnfn9FtjjtXCuVvj2s9QFYCEKU+lSBMjxYD
	H2kFYbqKTMSQR2LsFzXqW8iK46sct+kNDhRuXYyEv8ToUwTCPNAYLPWAVNOeDo+541XYwM
	UyvQU6apZ838UgAjYSnAdZ/yhbtSovw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PyTSQqhD;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781380121;
	b=OyNii7P2l3i8hy/bB8SKzyqQU/bykObDJg4haE+Qzo2JlF+KyllHFq4MZmho1t8UDxJe28
	0Ankc7nIcyeCzI+MP58zuXyKKBp82iL/v8iY5pVX0E5rQvBwVGFGue6Ud7u3bT03JfE0an
	5E1RDJ/kwrkj7Ts/3YMf07BRVpBVkyQ=
Message-ID: <c5ae6e6f-9b48-4ec2-a1c1-33ec3b1d3143@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781380119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZ+fKOUTrjEe7a3Zt3i1yWnHuMhAMIAMfhCXMZjpQqs=;
	b=PyTSQqhD+BW5yEDNAXx+KB2ulV77CTZTqLX1GbgHChLzen4D2CbswxLKGyx+PODnGqFPrv
	/etQxw3IVOHnMjPfkidjebfWxFJjP41UpvOUT+CW9rQLo6vmnxFf5VvpPajVMfnmnqpAax
	2GVD2viEmXL5PLmsX7CHByop8H28eZ4=
Date: Sat, 13 Jun 2026 20:48:24 +0100
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 david@kernel.org, Lance Yang <lance.yang@linux.dev>
Cc: chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com>
 <e68d5c68-9b4e-4959-a507-a9f94f3ce6e0@linux.dev>
Content-Language: en-US
In-Reply-To: <e68d5c68-9b4e-4959-a507-a9f94f3ce6e0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 61A26A0005
X-Stat-Signature: srkki14437f8do6njo8cdg5ch3t4c3fa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781380121-435303
X-HE-Meta: U2FsdGVkX18ktKZc76znyPhRt4SgB/jaOGB+yxlUr3INP304mDof8Zya+mS9Av0RQZ0z28WJLbkUm1Q48OkAAF0GwtFqT1CwxRBmLSw3vMIkqRnID9YfSGLUqRUpVIkCQvrmfZK7kzrSGbmV7Zf0wjrSsAYMAscb88fTLS4QCdoMZHQ1mPPRvV3X4bSdO2z2fYAkmj6ulhDStVXBPh3UCZhf2T1Df5u893m4BjK/BDaVRJ84s0qZQycBFv3faE1fPfT3pDIn868xBRElqJurjdTCZ2ryMsI6JIFIOfH+CR9ZzcrM7aHj1+RT/+emRkDmDqXJZIZpGZzYpS6T3vGZJhacWSH4mzJbvM9lpGqIDJwj+t1gX4Y4giwQzzeA4P69X+/LgZqB+ys6lXp8LeHh6IBz9Y0X16Vrk1+PUbvI3hIFP6i335WQEpIDPFdgHikxZpEG0LkdYTOj3YS6+7hk6rq90RlXSorNKWS4KlB/yPVYAvDlKDS6QPnqBZimlsP7mTK4rUwxCA3vsOu6ina0ZK4gYpboov8eb2Uwq6EkC2TlhiXzOkHF73RwSSYeSlXB0wXZ+93aUq2ROLhjUCEHsMmi9bQJXnKNoZ88a1j9I5yN70zgAaaKsgZatxlPhAhl59dNeKOikVK/jdmnC1tfwMmIBn+Z6cwqZ8feOrqQaHXsg1D3x7ydIDJRKy47NqjUFZ8eoANASZ32OokP1UsQBlzRqUkXtyIYwc6WVkH3mQSTdRv9++2T5ucSFYmP9Lv9FgSXQ9P/ghwkgtFIrqafwbqJ2KKhE5xHtPXq9rpbTtPXOhziG+a8JgdNnYLCa8DYrP4ORr4BahUXcHfTDHKkSfgQb0OjKtQFnwez2vng77zxOJDvxbpogFT33R+AsMOAT6ng0x/D4U9vNlm018GyXfPT2X2GgaW3dDexKiIj/MMAop9hIXxZ9n53DT45e96khXHI7OJi0O26SlELLPp
 sHtWO6dd
 BfaAuJ0uUhXp8i9HLVaTjd7mdC5sp9AsWK6fI2Lw25QjJb2hgEJxQdZ0usd13fgdvNnNqg9eg2omZGyLSYeoWV95Aqbs2ufpj3/DVHCPqapMMwg2eCz+vwY+J1wZlL5ITuWvSLTsoyRgqLMM6T6gmDpRHHP8HJ1vUOxmBiK19WuYXFEneyGC9FM4f2so+DJbosUFLufVKFCHjdqWguRcNpXe6lpwvSqvdp/rytPUAUVx5C8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/2026 20:34, Usama Arif wrote:
> 
> 
> On 13/06/2026 20:27, Zi Yan wrote:
>> On 9 Jun 2026, at 10:29, Usama Arif wrote:
>>
>>> On 02/06/2026 15:24, Usama Arif wrote:
>>>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>>>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>>>> unmap.
>>>>
>>>> This series introduces a PMD-level swap entry. The huge mapping is
>>>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>>>> resolves the entire 2 MB region in a single fault on swap-in,
>>>> no khugepaged involvement is needed. swap_map metadata is identical
>>>> either way (512 single-slot counts), so the PTE split buys nothing
>>>> on the swap side, it is purely a page-table representation change.
>>>>
>>>
>>> Hello!
>>>
>>> Just following up if there were any reviews/comments on this series!
>>>
>>> I know its a large series but was just checking if there was any
>>> feedback?
>>
>> Maybe send first 6 clean-up patches separately to get them merged first?
> 
> Good idea! Will do that. Thanks! 
> 

So what I will do is once the merge window closes, send the first 6 patches
for review, then when they make it into mm-new (so that we get sashiko feedback),
send the core patches that I have reworked based on Lances' feedback. [1] [2]

[1] https://lore.kernel.org/all/526fdbc0-1944-4328-9ff6-7922d021828d@linux.dev/
[2] https://lore.kernel.org/all/20260612142124.73367-1-lance.yang@linux.dev/



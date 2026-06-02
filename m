Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19902CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3776B0093; Tue,  2 Jun 2026 11:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D7F6B009E; Tue,  2 Jun 2026 11:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D6E6B00A1; Tue,  2 Jun 2026 11:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3BD6B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:44:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B831A090E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:44:56 +0000 (UTC)
X-FDA: 84835395792.29.A58DE67
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 255B3160012
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:44:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dUPN8UjC;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780415094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8W9tKC2C6NAekt7xw/i353pEy5xESfITkwO5U4ZKyM=;
	b=edvhcRdEq6NgOx7UvkUH+5dBgP7NELe982j5cuX9LYE0gOkyG00fi9UuICWOaA/45nJcsY
	uRzL85htr+xKQK/oRmla99qeU3BSFE8e7U7BE0SUI8R27IYrykyaNUXH7jwXYjdfmPmSn8
	5bS73rWmTdYwGmpTa3xfuU3tF61Nigg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dUPN8UjC;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780415094;
	b=RwuTSQS/UJoSMoWISJruifxb/9a7ZktMFMmXGeqfNanqS/Uhp2Kl+6roHwruYMQDnqraXW
	KKghbDR3Kq6/mNf3E0Ot34cXouKkyCxM49ssu6yr672D6XVDE2OmoldYeBJ+SuTkhTeckB
	xOESIwsAMJ3sc4YzcQXAQs3VNH0zwno=
Message-ID: <185f5699-3797-4300-8c54-bb99fc2a45e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780415088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f8W9tKC2C6NAekt7xw/i353pEy5xESfITkwO5U4ZKyM=;
	b=dUPN8UjCk9D//WfVj3ZIPIfxri7y0+DyfDfey/e1A6zAzAK6UEAwk60rmDdQMBMczBTVfQ
	eYmfVDCyFQ4DgX5Zvih0NOTAT5JeaRkrMW9fNX91jRnKuwjIyKGOWl6TgNiUuKF1OUIs5y
	itnu61NoSa2Vsg4tbFTDOK/aUcpzzfM=
Date: Tue, 2 Jun 2026 23:44:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-12-npache@redhat.com>
 <20260531071845.10875-1-lance.yang@linux.dev>
 <CAA1CXcA+oZmp=cxiC2_EBDxqGX94gAd335d9eFPNv=j_0=og7Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcA+oZmp=cxiC2_EBDxqGX94gAd335d9eFPNv=j_0=og7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 255B3160012
X-Stat-Signature: dgr5s7wq6eqnbohp4igs8ams5fqgunr6
X-Rspam-User: 
X-HE-Tag: 1780415093-839794
X-HE-Meta: U2FsdGVkX18yPHefaIStFHq0KOcCD7chP3UNXhVUNtdJMtf4b4NTS1D/X1WfsxoGoMYBC/ovteZpDFLKhtknooO9AejcTZAASHxuDEfRblhFACz5vLYSZWO3ZGVYnZUIY1TJBG2cPPdVSNyn8gXdWSa+QRIqMfUDk5yps0VyKvpatT6ZMNDMv9kkoQGIeO9A1vgVIE+SmTQ8w2R2s/uxg0+PMf0IirhEerCWnR7Eg4XW0QiCM3m4wo9BKcKdfoTsDY6H9gBKJjGQfKB4s7XpDbd9+vmtJIYT5HoBq2wg1vDHxkZDh0qmp74MmD8z35LzJe1MK4MTpHg269kna0DT7DiYwemxHcyfPaZ3OKTqbn95+csWLC6wHILz8c9Ljaa9jxhiEq0vMuMWcuAk2rVC1wtwC/F5IGLfTgAZJY0CiI8GVgIHSJSq954YAftIXspBIIYiEy1+mdMuakSokkCGD11a8/7dgZ1YItuQiM+KDiNX4g7Zy6C6N2hqQV0bs5zClg8gCVUqySK1jKek/da+tmS1t6JEac5lzbVf6OtG7E3c9SOkwFwNdxyyyFdu08WZm7s1h601T+tmMNNRK6G/9WuPTYsrRFDJLIS10+3lHLb0TwjNmTmL5Prnp569Nh8ApBNfOcmBgaUXT+ezhJzQU2ykwOcM9ANE2imthjJsuZ73jArOIs8YdMxjsd6dlMWo4e3jco2U0XZLqrhpbmRAxHTALkPgpmcCsGcTkLFLABDatD3AL/SyHfsC7K8bNe6ijiXfvO1AUTy3D1/iQnkcTVw5jxyejFhCGjh2zcpmBSn80p5oLO00A+qWRxi+Z8BwDwisSW8N1mNtQUN3dGFLu9EtpcNYJP/2iCDQNb6lA5E4J1Jh9CWtUtHCYgAy1VSLmAi7pPMucqEYTMclU5eJq+1D6575uUqHuDcjFJB1VGd6neSEiOGai5ggnscC/8GGTBqcLLR3lTFoKADmZuy
 NaB+axYy
 sBkxfi+pm4nsk9PegDepgcaxfUC8LXp9vNWMPsQ7DnHQjnQsp6mA2FNEL+g+Q6ugrarkfLArdEA7b7tHkHd1TBUAo+Y1vBiluWBH5L+UJBEAFYljVFCfOuyIMNcKaCazH3EESkpvtEHJjQeW3JAsRoEj1uuxrlr4oiCeH4njpR4Gq09A+HjiEUcoz3MFUMagGg/tvNGU43GZlMO2Tvehp46hFJGjTyN43nfAYM2O1sqU7Lw417TokxaxYNm5ZgBzdkXeUv9FktSu+ITdteF0rFjuaKLDRenal86odYd4NS6qSlSnzZvoh8vDUVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/2 18:58, Nico Pache wrote:
> On Sun, May 31, 2026 at 1:19 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>> On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
>> [...]
>>> @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>>>        if (result == SCAN_SUCCEED) {
>>>                /* collapse_huge_page expects the lock to be dropped before calling */
>>>                mmap_read_unlock(mm);
>>> -              result = collapse_huge_page(mm, start_addr, referenced,
>>> -                                          unmapped, cc, HPAGE_PMD_ORDER);
>>> -              /* collapse_huge_page will return with the mmap_lock released */
>>> +              nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
>>> +                                           unmapped, cc, enabled_orders);
>>> +              /* mmap_lock was released above, set lock_dropped */
>>>                *lock_dropped = true;
>>> +              result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>>
>> Hmm ... don't we lose the allocation-failure result here?
>>
>> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
>> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
>> in khugepaged_do_scan().
>>
>> Now if allocation fails and nr_collapsed stays 0, we just return
>> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?
> 
> Ok I did the error propagation! I think I handled both of these cases
> you brought up pretty easily.

Thanks.

> However I don't know what to do in the following case: We successfully
> collapsed some portion of the PMD, but during that process, we also
> hit an allocation failure. Is it best to back off entirely? or can we
> treat some forward progress as a sign we can continue trying collapses
> without sleeping.
> 
> Basically, do we prioritize SCAN_ALLOC_HUGE_PAGE_FAIL or the
> successful collapses as the returned value?

Thinking out loud, forward progress should win here, the allocation
failure only matter if we made no progress at all?

> This is what I currently have:
> done:
>      if (collapsed)
>          return SCAN_SUCCEED;
>      if (alloc_failed)
>          return SCAN_ALLOC_HUGE_PAGE_FAIL;

I'd go with this ordering :)

Cheers, Lance


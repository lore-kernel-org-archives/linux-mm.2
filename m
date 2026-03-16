Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88BEEFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0B46B013A; Mon, 16 Mar 2026 02:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381D86B013B; Mon, 16 Mar 2026 02:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC236B013C; Mon, 16 Mar 2026 02:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB036B013A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:25:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD981160D8E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:25:26 +0000 (UTC)
X-FDA: 84550939452.06.4C97FDA
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 08739C0004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:25:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vHi2ydNR;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHrVuzmWPg0Uih3557YZ5qAt41GrwBcJIT++eX/grpM=;
	b=jmhPMWlRyeUzTvgHMNA2utD1U6M0VKvLhHbRaSkRxrOiE+ypUvCBe92nz6xaaXAxqDj1rK
	tBkB7gcOWyrwSYXU/8I0kFj9R28qwmqKogoSWaBQerAM5s+2Da3YPQWEH9LKF0/QD6rHHN
	pSQ7PB8AkNrXe/HgO/VH2p7AdmpWX34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642325; a=rsa-sha256;
	cv=none;
	b=D1I3EX1EROQMTt5LnXCN1Qx3WyX6uhkNdPCFnHcz+GUMLXNRrumqtfD/p8c1DwUDi36qHo
	Vs6ZxjMXM/Loc86XKa8NLQ5C+TPsJ9cX+t3voxGkgG+4oJlm1/SZiC//eCmjXNAkhN6eK0
	Kl+ZXxDwxyT0MqUg95MZB8mlnGXdf1k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vHi2ydNR;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773642319; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GHrVuzmWPg0Uih3557YZ5qAt41GrwBcJIT++eX/grpM=;
	b=vHi2ydNREc+4jny7D0w8SVH4+nWVdXbFS+UoN1NlkZfPAIcPw5Cc9iIHf955OAWnd4D9BNsGoSiuio+V48QxKn1rmfyqZWjzXSI+X9TV8P0QgNce6ZqncV85BrYBGVxGSU5Vm6z84Uk3gx40SnXmiHVxhAT0jHPHgytFhvIvV1U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X..tuWa_1773642316;
Received: from 30.74.144.148(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X..tuWa_1773642316 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 14:25:17 +0800
Message-ID: <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
Date: Mon, 16 Mar 2026 14:25:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08739C0004
X-Stat-Signature: 1yf6pj4m3a3ygx7hynn4pjn19if4p5qz
X-HE-Tag: 1773642323-657077
X-HE-Meta: U2FsdGVkX18nDmNSLiGnqr8F1vA2EG3LZgoubhMXIuAC0V1iBOVBb1kJt/nA11TY+SHCmQdunE04ibueYz4FdE9i6OiCPLjN9H7rIC8rUPQDvm16gkOWWdiV+Gsxk66NKTU2h9KwBiNfVZcLMOS/uuQj3UaeNZ6xuCSJXSnfbxktvL2OAlThCt3EOvXHKNaPsrdReh3mBYCygih7fYbZJ7EOc03MikTdkMCq/fQvM2bieJFhQB8bsbfsEFd1D3EuXubp7NmLbhm4LZDTHqfxlpTSOK2sowAGN4jA9NWMotAyT1QsRkOsUdl+i5Pp4tc7FGE01ecT9pq9A5Io5/3cjwDLFW5ihzF7bkgTg+0Rv60c4Rci+Sh51otI84ZmHfJS48EzQQNJGSajeLRtlGLIFhmGBGqHM3OY+cg2mQh8t8/RIlz1TZUGCJV2vbVbH9yOE6fvTLi1ziw3rNNA20cXnArqfG2UgvJcONfoFEkRiwAMEBijAqsgCZrlc+DuDoH4Uj4yvQ6yLYn0OOX5iYpEQR39zMnXz6TQfRaTXVH3FpWrP6t6MFPtrkgZMZLZEKBaHRizQ4qB0IvQh2iRV85+Siuqcfkf3hn4Y3+y+dq+/Ve3/tJz3KzCAXW9TF5rvcs9RRh9DlFZ3mxwm4tIClnCygL+6y18u22KBurQkJEBZILFIbKnsk1UoWKhuezOCUmd+SWdj/O3Qa5IOkcVuhe7T+kk16RZVSl5Cu2r0zV+uWTfr4z8owU6F9AdclVHBmaXRsTnq4jSWpPStw8ZJEmGagg5LvlukTJ8DIvZfnGjoWDWiEnmL75N6/mYibFOgOUz14Xn4iPMqO3htAMFGeACjYux+Sj1afyTmkEU5xWCnyhaBTtppRegeKsWbsQb8MRrUFNA95n1GTlZQV31VJi+OvvVh2S1WvoLljZFwc7M8XTXeddQcN6kLbiBaJhpmtNPlr9YEXxkbwP3HwYz0ce
 gSm8uagi
 bw6niASWzegAH09blSv52kNEXgLD6oKnom2XatO0Iix+pWf0PRmdO/fmTrqDy3KJCi0+AbpgYsTbAOspKTU+om0hB07htw5N32EGNWU4QwkB1GFs1I3KIayA6Zso+4VpfWb830ktWoLBM6pmc0h38RDWFYVvTup/OrZ4m3Z8zXIKiHGKjkJyx/qFon/0sbnfUyq6hnutLIvZe6tCSAN4j9dNp+92qBFpr58rrZjmkl1abUC3R+9T9OHeDYMY3Y/jHUY3ASgbwlIQKbwcT1wdOr+WaDmObLfBeZw9BPjWvgOeH1zj2b/qhjgR6tCeuq3g6T+HYtMrSTLtAdLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/10/26 4:17 PM, David Hildenbrand (Arm) wrote:
> On 3/10/26 02:37, Baolin Wang wrote:
>>
>>
>> On 3/7/26 4:02 PM, Barry Song wrote:
>>> On Sat, Mar 7, 2026 at 10:22 AM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>>
>>>> Thanks.
>>>>
>>>>
>>>> Yes. In addition, this will involve many architectures’ implementations
>>>> and their differing TLB flush mechanisms, so it’s difficult to make a
>>>> reasonable per-architecture measurement. If any architecture has a more
>>>> efficient flush method, I’d prefer to implement an architecture‑specific
>>>> clear_flush_young_ptes().
>>>
>>> Right! Since TLBI is usually quite expensive, I wonder if a generic
>>> implementation for architectures lacking clear_flush_young_ptes()
>>> might benefit from something like the below (just a very rough idea):
>>>
>>> int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>                   unsigned long addr, pte_t *ptep, unsigned int nr)
>>> {
>>>           unsigned long curr_addr = addr;
>>>           int young = 0;
>>>
>>>           while (nr--) {
>>>                   young |= ptep_test_and_clear_young(vma, curr_addr,
>>> ptep);
>>>                   ptep++;
>>>                   curr_addr += PAGE_SIZE;
>>>           }
>>>
>>>           if (young)
>>>                   flush_tlb_range(vma, addr, curr_addr);
>>>           return young;
>>> }
>>
>> I understand your point. I’m concerned that I can’t test this patch on
>> every architecture to validate the benefits. Anyway, let me try this on
>> my X86 machine first.
> 
> In any case, please make that a follow-up patch :)

Sure. However, after investigating RISC‑V and x86, I found that 
ptep_clear_flush_young() does not flush the TLB on these architectures:

int ptep_clear_flush_young(struct vm_area_struct *vma,
			   unsigned long address, pte_t *ptep)
{
	/*
	 * On x86 CPUs, clearing the accessed bit without a TLB flush
	 * doesn't cause data corruption. [ It could cause incorrect
	 * page aging and the (mistaken) reclaim of hot pages, but the
	 * chance of that should be relatively low. ]
	 *
	 * So as a performance optimization don't flush the TLB when
	 * clearing the accessed bit, it will eventually be flushed by
	 * a context switch or a VM operation anyway. [ In the rare
	 * event of it not getting flushed for a long time the delay
	 * shouldn't really matter because there's no real memory
	 * pressure for swapout to react to. ]
	 */
	return ptep_test_and_clear_young(vma, address, ptep);
}

I don't have access to other architectures, so I think we can postpone 
this optimization unless someone is interested in optimizing the TLB flush.


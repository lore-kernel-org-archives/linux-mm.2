Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2BAE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A578B6B0005; Thu, 19 Feb 2026 10:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A053C6B0089; Thu, 19 Feb 2026 10:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911046B008A; Thu, 19 Feb 2026 10:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4FA6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:53:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D6DC1A0602
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:53:19 +0000 (UTC)
X-FDA: 84461650518.02.43A147B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 595D8100014
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:53:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TD64GyPq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771516397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUb1MPPUwyCxzj2goytrraqmabyZ5teqolKXmyMrBc0=;
	b=vAoiSU0mMZ3Qz2nJ2QoX2kmRp9xeJC/Q5iqp0m+QTj8SLjgquew5jAyBb07212RgHkCJ3b
	2slYlDh/xjvwkEY5ucdR2O8V/VLhDtQ8tk+lJl/mu6HpXVyHwmv898pcZD2R47Yf4bdeq7
	iysFwPowbzvHiZKTm/Clb8RTqE8b2jQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TD64GyPq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771516397; a=rsa-sha256;
	cv=none;
	b=wJBGTbBz8J5fcEwhrqr8sxqS5er3bMDoZhIglzAfeuzrgo4/Kqz0cC7JV3Z0OGDwusvR59
	0okn9l/7muMBohfpNqeTTvWNJqm/x8RBpTUM8ovL95kYQTNgBoZ/19jKYA860kfIb0CNcM
	TKJ5qVVKDJQ3skBrRts9mjLYmI14KNc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8730660054;
	Thu, 19 Feb 2026 15:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E18C4CEF7;
	Thu, 19 Feb 2026 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516396;
	bh=qFXqzjhF6S1cndDPwj4lCD499Qd5CkE/vgQLAzospSA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TD64GyPqIFjUiJBCF3Qqom32GDBmy8sLsSlPBIRYxajLBWNG82r24/a0CI6JgeaCt
	 Xtl22DieFcViEZYL8D8lqFSjrBnUJtL9eeK+8enxDDpSItJ1mQgm6vGfnTjVN3+Lmn
	 GuZ3CZZFulPFXU9sMcCSRfdSMozNs9Ht8Z63Jqx9dfUxYoR75wsxVoWRPuDamOgcYl
	 Fo6S00ejc00Xaq7MKaSTZVDx42NfOPwnbkq7upj9kObqNHbiuWv+B1THyWMvwy6920
	 cSduj/bWJHrcOUUM1jpJT3aHz+w+lPhGPC82kdGgnPkT58XOpI3XoazTQd9szWCTxl
	 gaSj1zuIK+04Q==
Message-ID: <0e2621c6-8829-46d1-9f29-81aebf365ba3@kernel.org>
Date: Thu, 19 Feb 2026 16:53:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <l5lnb7fvqk2fndlvejibcrxru7i5xwdchl2hcnlk6dzttdfkyc@vtuqkied3mtt>
 <aZcuvbTTXn1MD5KK@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZcuvbTTXn1MD5KK@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pygj88ppjwon7rbqaaqxehdn8z1rrcij
X-Rspam-User: 
X-Rspamd-Queue-Id: 595D8100014
X-Rspamd-Server: rspam01
X-HE-Tag: 1771516397-320094
X-HE-Meta: U2FsdGVkX18yZJ0WRZk9AfDdmgvRbnhxwLbSUMtWq+ykKDi+ZM54FyPXSTIbx2fbxf8DToC6FmmgsI7rN4Wv4tFRaA1E/nhgcwG1UmxXIjOHJ4H4JcrixiMaQQmyirJRmiILBe9j0Klw3b+nRPCyFMxusvh40oIexYWelqCwknbGngJ8yodLR9anAAyliEbSL0xjbC8sp4QcdMTKzHUm6nVzSwGLfEBz/naDmolBQpPiYwmHnQ7tCyIfsNqiCmNEi+O224R5KX568+KrTr3eKU665UcmhomhmtxXrtz9dxL2Z5g+ycKqEDJAi6kKC/J2Kt1wNPGCT+SZzvit1XQWZTQMSuPIXfupyQ+0Q0+muXgJgdHrxUTZFYQHyYzBzvuDcTF4CXHt5pBe+lbMX406LFig2dcS3ZpKRzqo/m/b2BOOky8ZvLJa8CPq1xh1iZm7psWKZ5wuewIt6fyn100VTg6b0zlCzYAJXseG/EgTituymRDY/5HdT3RV01/2a5KXhqJD6DUhTwu3fb6X60jj6296Ksec0I13LmYzHAwtsyVZL0h17Fqp2g+T4K5mIuUi/wuDsnQEVlIFL19sPS6/PXxAZbMc+7Z/tBZITx1M/qh/MusgokgiZhkDhNfPT6toQL4EiFfzBbPDNu7B6RFuv78McIWlw8Liuh9uERyPHLm2c+/+vp1wuJAbsTR86uFsvS4ybqFiLmxtvD9atsNsQgWL77mVasp47LjND28N/HgdAs4xos0tE3q5rlFxhADmhpJ2EB2ttsM04LkSLtXI+r07CWeKfiKK6dQOL9qbW5v4lSswORdVrKMRk/+Lqn2TCc6c38YXfDwx6/hmlY4n9iX1zwzeZr0HpeUm/3Zvh0Nb+EVdmsigcwLrV1WdGZsLGHIuxElgj7DqqgeF1SlNLpHNONCtl1iS5hN9AXCDB0b231IjKe0SjuDXfUG+GeLwWt+AZYY3LvjFjjNCij5
 YAwJ6lb0
 8VZv+ahVztwDwU3wKxJLfad5Ky7pOcPzb+IbD0cl6m5Mcf33jg+pppnPpI0/PYQm12g+EyhtXYEE9MVS6JjJrxqbREhUDoXXOzJowdazoYgVm8V+Gh93+4dM7K/xVh03PNE7dOCksgWqQOdbLcTMhJfOeSYo3X+N/JQC0E3GFpl2AUvIrDYevK6jZMpJQ8yj/XiPdr96YOhN2VhEnliQPsyMkqrcBBzE/6hkCfAr2JHsOoe2SC7Y2MayBe1SR0FaL9z45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 16:50, Kiryl Shutsemau wrote:
> On Thu, Feb 19, 2026 at 03:33:47PM +0000, Pedro Falcato wrote:
>> On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
>>> No, there's no new hardware (that I know of). I want to explore what page size
>>> means.
>>>
>>> The kernel uses the same value - PAGE_SIZE - for two things:
>>>
>>>    - the order-0 buddy allocation size;
>>>
>>>    - the granularity of virtual address space mapping;
>>>
>>> I think we can benefit from separating these two meanings and allowing
>>> order-0 allocations to be larger than the virtual address space covered by a
>>> PTE entry.
>>>
>>
>> Doesn't this idea make less sense these days, with mTHP? Simply by toggling one
>> of the entries in /sys/kernel/mm/transparent_hugepage.
> 
> mTHP is still best effort. This is way you don't need to care about
> fragmentation, you will get your 64k page as long as you have free
> memory.
> 
>>> The main motivation is scalability. Managing memory on multi-terabyte
>>> machines in 4k is suboptimal, to say the least.
>>>
>>> Potential benefits of the approach (assuming 64k pages):
>>>
>>>    - The order-0 page size cuts struct page overhead by a factor of 16. From
>>>      ~1.6% of RAM to ~0.1%;
>>>
>>>    - TLB wins on machines with TLB coalescing as long as mapping is naturally
>>>      aligned;
>>>
>>>    - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
>>>
>>>    - 1G pages are within possibility for the buddy allocator - order-14
>>>      allocation. It can open the road to 1G THPs.
>>>
>>>    - As with THP, fewer pages - less pressure on the LRU lock;
>>
>> We could perhaps add a way to enforce a min_order globally on the page cache,
>> as a way to address it.
> 
> Raising min_order is not free. I puts more pressure on page allocator.
> 
>> There are some points there which aren't addressed by mTHP work in any way
>> (1G THPs for one), others which are being addressed separately (memdesc work
>> trying to cut down on struct page overhead).
>>
>> (I also don't understand your point about order-5 allocation, AFAIK pcp will
>> cache up to COSTLY_ORDER (3) and PMD order, but I'm probably not seeing the
>> full picture)
> 
> With higher base page size, page allocator doesn't need to do as much
> work to merge/split buddy pages. So serving the same 2M as order-5 is
> cheaper than order-9.

I think the idea is that if most of your allocations (anon + pagecache) 
are 64k instead of 4k, on average, you'll just naturally do less merging 
splitting.

-- 
Cheers,

David


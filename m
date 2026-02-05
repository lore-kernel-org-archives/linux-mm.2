Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DB5ECD9A6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 21:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFF66B008A; Thu,  5 Feb 2026 16:30:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E882D6B0092; Thu,  5 Feb 2026 16:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32236B0093; Thu,  5 Feb 2026 16:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEC866B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:30:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58C4313B8DA
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:30:29 +0000 (UTC)
X-FDA: 84411696978.07.51268B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9255A140011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:30:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWJa58im;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770327027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV6lOMhQwHxIKaaDmlM3BFVff/Q2VSOnebunH9gwrKQ=;
	b=0ubsh3/B233tH4jphws8XZFvFFB10Vgh5Qd+uGDY/99QGaPvtowRNHc2dI4lPIFiFOPfjq
	XwNEQxgHmrQvx4YfBTLLaOGyAfEowu35TN4taGfDJ7cy8nyb9vuGC/zExFNQcXKZ73rrdi
	K+lQSmGAtuXjO8wT9td5dRFFIfr908Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWJa58im;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770327027; a=rsa-sha256;
	cv=none;
	b=14JreG3FqCIXtqVp3unV+PQ54zxRIAgasc77WGCRWFu11MF9OWlvOm1YgJfphZ1Xls7ktO
	IGTdH2sRRDM4hp8VsQteSwyLAC2HNBnSIAguzuLBKjkG5x6wwKrF6RAu4UAVzBSPW+Sj5t
	45HJgUGzsqwuIfhvUeKD21q+r8JiwNs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACA8F600AD;
	Thu,  5 Feb 2026 21:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF3DC4CEF7;
	Thu,  5 Feb 2026 21:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770327026;
	bh=Lx+GDw84ajKkD7Q7e2YiWEUXDPohIGrcgs1E8NQihRE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=UWJa58imC0523bdHUwOv4s43hDkqXGIQPMlrIIoBFoNK5Q4WIDQtxwtXe9LRgv7C3
	 1QOhGsuqa7ynp1ftSHwRBc4UYKNQPQHilUoIRYBu6uIlD7s6MVOdVRrnDVQMKnA0lt
	 e6+/I/RmUZ3ndJGVodsAmXmCGSnYIDW3QpvPkGhYuqgaC5hXHneSYbLeskpQPGHxZ2
	 IwNCwiebzbU5H7TgTuurErSwRhUQVzMASWNT0ykO2LdV0Co4UK752mykmHWViMd30t
	 Z7FcWNRAjEhgh2CYvI6dF9duOwmDfMiuXG3HQsi8YuTLX66jVqQuIVP3rADGoClRKg
	 7odoQAFZkaeLQ==
Message-ID: <2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org>
Date: Thu, 5 Feb 2026 22:30:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, Lance Yang <lance.yang@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
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
References: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
 <aYTJzft5cuqD9akC@casper.infradead.org>
 <6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9255A140011
X-Stat-Signature: h38j57ptzkewwbi1c7q4hco1r1jzh5f3
X-Rspam-User: 
X-HE-Tag: 1770327027-590850
X-HE-Meta: U2FsdGVkX1/yPLkAvhwLwBw58JrTiFTiqJhTpBe/dU1Nzyt731v8yi53cCngvwysOo3Bj47QmiDozoXZDS4cE1Nch67l/23nmUUWAaEWNZQ+1LhZbef48XPG/0ULndX3XyMbHyNDFsFNg2nrI4rFr7ck8KiMrQNfISu3XgR9w4Xkuh4rulck88gBEFleJ6XguH6ejdoaHXC8rNGCDnju4CGyAlouY9YiFisFFn4hlOy31qRlt61aL3X/0b1Ah1C2sk2pRV70jemlvZOjv7u1P7UyNvbV6893NqoYzj6kCHkxva4lzTGX5hEAQM5I5c2eiAvj8kFHMf3noBQqTXpyMMZKOWeA6blwGrZkydxQc3JIfC33QtjSBokGf/2jE9OeKAdDtyAaj5d4wpV4QkJ25vgJkZZgUTCQh1oxckEpQl8rEF9MM2UZdSvztEYWJGWdewtTQluAetBt09AVHqNc6VK/Inr/1Njjkh95ZB09hkCZY8qt6YJsrH2TQ+VecOhHq/wF3NIcCEBcWde5zcX9Kbl3Var29YO7JYm1IMaV/ftTrLp27BQ+WcbhIqJz8KJfTVaya9AX8GMQDRYkG2ksWkf82yf0S+zSVIG3wieDKpILhWpWVzuJ8HbbtppoWNRL9y6TyM+HaxEwWa/5JZf9Zi4VYSmzjzQ5j/DD4cICmanCXD+y5WluUP4txf2HMXv1hs/Cm0MB4mlDi/lrZnWhVDFCkDNyWxEAWcP2FVqi6BLXg2jB2gbzTlPe7wRceZylatzGF4/bywpCpdQsicety3L/nquys9jqmhCQTL0duycMOHQPrBYEYeod1eHWdAqpmi3HvIuKtcnziqo/lljV7xUgWNH+X5QTKiMRyWwfb/OQ0Y1xxRE+PjvG2YBrfwuZy61WuP1uw6LFfTuI8qY20nTTH2RCsFGuMOj772Q3V1DpvyYrfE749nJ6xVC/KzEhpn7Xy4k4gY/UoaQ3O42
 gAty6mQO
 ePDs34/8ON4Be7xImyLq8CMnUuZuvLHMEXSbg5Sz4vI0YyHKA88TTWAHwAh5KEiL3nWHNn6uFnm+4ImrAuAa2lTT7YHue7srdhcA/1t8U3JIuJ7qkfsli0ir7+51gvMIuoFGKhBVwuIlo0PJdRfKEZDfCur+yeP0MEqBCnZXhQaea73dloC+KmfxDK2fxTO0SES9Q61JYPUGViyNA+H8BnS8Um3OMjlCy65azrMYgc3ZztG4drbEWYGP1FQqZqZsqg+M3mdasM8Wcux2Vp/lDQJ1iFZHBtKHLezCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 18:06, David Hildenbrand (Arm) wrote:
> On 2/5/26 17:48, Matthew Wilcox wrote:
>> On Fri, Feb 06, 2026 at 12:30:56AM +0800, Lance Yang wrote:
>>>
>>> The issue is we're about to free the page table (e.g.
>>> pmdp_collapse_flush()).
>>>
>>> We have to ensure no walker is still doing a lockless page-table walk
>>> when the page directories are freed, otherwise we get use-after-free.
>>
>> But can't we RCU-free the page table?  Why do we need to wait for the
>> RCU readers to finish?
> 
> For unsharing hugetlb PMD tables the problem is not the freeing but the 
> reuse of the PMD table for other purposes in the last remaining user. 
> It's complicated.
> 
> For page table freeing, we only do it if we fail to allocate memory -- 
> if we cannot use RCU IIRC.
> 
> khugepaged, no idea.

Now that I had dinner my memory comes back: for khugepaged, we have to 
make sure there is no concurrent GUP-fast before collapsing and 
(possibly) freeing the page table / re-depositing it.

-- 
Cheers,

David


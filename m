Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C30ECD982
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5BD6B0089; Thu,  5 Feb 2026 10:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193676B008A; Thu,  5 Feb 2026 10:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068986B0092; Thu,  5 Feb 2026 10:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7FCB6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:28:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D22D8BFF6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:28:36 +0000 (UTC)
X-FDA: 84410785032.29.8322507
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C936100012
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:28:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IEGzDoIL;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770305314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SL5gP8QX8DLMYTu036KBvNCXId/b3s1citx/YK+obQ=;
	b=NocevGGLQ5YsfVohoFtqJK95iUtZ611YgtZg2mFZGGTn2UOz7NrcUMI5uDpn3apkp7Q/tv
	bG9AN8gJCBoKxwkXMBcMRGWFCFmbiLtAQIhdvYdVvILEv5aBkeBMJ9vDFziVqOz1MpRXm/
	6KmtQgtv3zHNuEGrXsXn9/mV9KXq2qQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IEGzDoIL;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770305314; a=rsa-sha256;
	cv=none;
	b=vjE9CiqU/4ztCDvFMX8xe1BldkoCsSQ1gBQlAnlK8Sj5721vQneJlDiYsFTVjI8maXYtuB
	eN5ExRjZDrXIu9OoXAUQsbwqL+Spl6aAyBxeNGuvKb7ZxN1a/F4vWhwmzlPvt62cs6flSK
	ZxRibW7Z28Y3SZIvoV0BA/y3YIXdv3w=
Message-ID: <8f5f7617-7a35-4cb2-97b2-0a73c6d9622c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770305311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/SL5gP8QX8DLMYTu036KBvNCXId/b3s1citx/YK+obQ=;
	b=IEGzDoILmn6RaziZQkRjyJvvzWlaFO58iWze8rY0jh1kOJLRhJO6HZpFljbyPC+X0L84Av
	Cj3u8KxpQa88wJ2ZLpjRYTRBp6+7l5b63JFvgtpcdm+Vg8KJhKoywh+RxTy+/vns8wVrSm
	I/WRZ4sW+DSRbVjCNuvHzj//KzAkgjE=
Date: Thu, 5 Feb 2026 23:28:14 +0800
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
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <13205d28-7478-4578-8bf3-ead18b4dc6b0@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <13205d28-7478-4578-8bf3-ead18b4dc6b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zms6gng1wfi41r8dnxgezpsf4c4u6oen
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C936100012
X-HE-Tag: 1770305314-205659
X-HE-Meta: U2FsdGVkX1+i+7jVo5fNyTmRQN/AbEDBjR8paes8JVo315VHxtnp9EQk1pVRI2s8+rSJl3tLN9cKuodzcwUMriSWzLpnfkmPlecE25hynv5MwdNUNf6LeJjSJeD4X1UM9GzCuXpU10yCyy+4lHfr421DcUHXWp7RWuWy3oz4dROndh917iP6M9z+PiD+DBrCuaG3kTbirgYzh/VS+7kz2fCw9RKJsphVzevRnGsSJtgwQZQPuRfcHfsSIelzrcy6aiQEQfXzO6zglN264PEPqChKsHyIkm8cR2G7dPgKJ6J+pdd7Fw3JKphGSMdetDSEg0mTtsQEzwK/RN0kJX3auCX2F6pPjlB32825T6t97uzaWKxh6ja1p+NEqdt57pdS7wn6rn0Ddrm2gVLE2b+HVvKLtHX+GDTrtAcZf/JOtUy8gX6ibj1kkqghY7bnf/8CDJ8T5ScvWYYwy9lvZJCiK8CoAuD7AJ1dNcg7tmc7fVVEpKCEJw/u7oeiL6sLdd7yAQ192XO9CUH+n1ZEQALp23RXeP3Nd7Pazu36dwKkX8NHaODIQOoTW81CNSNvTKrv8eawO0A/BrLqgcOfRk4/2SERp+wNq1vWGsKs8an8UuY0O5qDW5jQkYk6wZRFl05ITtBBtW/6WLMInP7G3i1meT9OemctnT2uTFG4tCPEJWrONNkM3EQQ06u+J/hDgkaVDdqUH6n15X83d55Uo6lqL0xTDbWjGs+lWCPm4RhbvwRN78It+H6JvqAv7G+dPjcSdj8aRnnrFDIgcOX0IbfBXh9atuI4ASibtgWH4E8+img5EAq74JD32vn0Qf4Vy3OFj6/pDaTnCLHsuQTRMOcuY2uA+g2sD5acQeKerDaRsDhW6/xjbmoa1R5Dmx69kV77+ex2VCHbgnKcrRF2ncsqu5pB7Fux+8NeU49wqXJAwHUSgbZBFiO2T5UGFKwdbMY0zkg2FzSqyWuLDuMl3xF
 5ywV2ndY
 +FCoRgL9jSPxcojhVvb0Cse/v/Cmjr34P4LDC/4y6692oTXp/IJUZgNhnCL2pVEMMbUoFCmOCPoRZo8AOVmmGVFp1tRmr+oedjj7D86UkzskFLhUX2ghwciTKrytqADjKBTwzrRfa1ywo8AMqGmH4nRU1r6gOFvdwY1YHYtfxvB17/wJMcWGmaxbI5gGZF3VzqMV2PbOWUWsP/NPr0KSuSqQlcQ6FQ18Ik1OmQ2pXrgp639I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/5 23:05, David Hildenbrand (Arm) wrote:
> On 2/5/26 16:01, Lance Yang wrote:
>>
>>
>> On 2026/2/5 21:25, David Hildenbrand (Arm) wrote:
>>> On 2/2/26 16:52, Lance Yang wrote:
>>>>
>>>>
>>>>
>>>> Yep, we could replace the IPI with synchronize_rcu() on the sync side:
>>>>
>>>> - Currently: TLB flush → send IPI → wait for walkers to finish
>>>> - With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
>>>> grace period
>>>>
>>>> Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
>>>> synchronize_rcu() also
>>>> waits for regions with preemption/interrupts disabled, so it should 
>>>> work, IIUC.
>>>>
>>>> And then, the trade-off would be:
>>>> - Read side: zero cost (no per-CPU tracking)
>>>> - Write side: wait for RCU grace period (potentially slower)
>>>>
>>>> For collapse/unshare, that write-side latency might be acceptable :)
>>>>
>>>> @David, what do you think?
>>>
>>> Given that we just fixed the write-side latency from breaking 
>>> Oracle's databases completely, we have to be a bit careful here :)
>>
>> Yep, agreed.
>>
>>>
>>> The thing is: on many x86 configs we don't need *any* TLB flushed or 
>>> RCU syncs.
>>
>> Right. Looks like that is low-hanging fruit. I'll send that out 
>> separately :)
>>
>>>
>>> So "how much slower" are we talking about, especially on bigger/ 
>>> loaded systems?
>>
>> Unfortunately the numbers are pretry bad. On an x86-64 64-core system
>> under high load, each synchronize_rcu() is about *22.9* ms on average ...
>>
>> So for now, neither approach looks good: tracking on the read side adss
>> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
>> is too slow on large systems.
> 
> GUP-fast is 3%, right? Any way we can reduce that to 1% and call it 
> noise? :)

Yes, GUP-fast is ~3%. I'll keep trying to do that, but first getting
the low-hanging fruit done :)


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DC3CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3D16B0088; Tue, 23 Jun 2026 03:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74726B008A; Tue, 23 Jun 2026 03:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930C66B008C; Tue, 23 Jun 2026 03:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 627FF6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:50:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB5ED8D5F2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:50:12 +0000 (UTC)
X-FDA: 84910404264.13.0538CA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 080FD18000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:50:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPR4U6tK;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782201011;
	b=R79OKMHiJF9d4t1HVezPKqmYR447xPm0hb9i0duT0f8+PfL3BFlSqPBX4ipP5j55zYqo3b
	c9Pf50axKxB3ASzi780arNEQpKg2QR2AvFXaZEgFcBUUla1cjL+PD259mHfp1BJWdHuZKL
	lAvc8395gPJVbm3koAgSq1x4+vMT3FU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782201011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRZgnHp3vWPKvY+OhddSqzZ6Xb2MgcroWOqVWlw/iSM=;
	b=20mVe6PIHc44hXutZivEJYBmOEEH/Mdtk96K4xJW0ld7lsP67q9lAhNr0t0rvsUJjv2SMv
	IKSC/big7i/i0IiKLtQjk4uCQJ08rNSeihKhy16ooetC/eIBegpL2hm214D1xBwy0JYJO7
	2a8NhGqueTNOwNGxUU6oKUF3fk6H7JM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPR4U6tK;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B57F6001D;
	Tue, 23 Jun 2026 07:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E281F000E9;
	Tue, 23 Jun 2026 07:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201010;
	bh=aRZgnHp3vWPKvY+OhddSqzZ6Xb2MgcroWOqVWlw/iSM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OPR4U6tKdwXmWBc8A9pDEZwar5IrIaNRo0eFZlmF5sh7Yll8uDpailB1OGPW/e2ba
	 pJkVpUXosNijxf4wqTWliWYpab5dBPb+sWyE9e8MwGPs6Ejcqq/ynzmnfjqklSENPJ
	 /yPi8PXmbMbAM1B5ie8+tWfHSHNlk28Ta5iVTFnlpqbqnAvHCzWHWNewqOyS1o1atO
	 ReLaqZbdEjQM7N7oi5gR4Ev793oSPNyd7aoPU0GzzoQx4L+7PwCz7ay1MCMUStC/Pk
	 eoJ5VrPy5YAb5J4PzWUeczMtIZYUYXS58IkpF+oYjDD5trjTHpX1DfjYeJUIGtu+/5
	 azh4kB0ilrlXQ==
Message-ID: <d4926c7a-32e4-498d-be6c-ab2969c8f672@kernel.org>
Date: Tue, 23 Jun 2026 09:50:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Zach O'Keefe <zokeefe@google.com>, Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cypamibhhqkxj5iugbhgrmmqd6wewkyi
X-Rspamd-Queue-Id: 080FD18000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782201010-367288
X-HE-Meta: U2FsdGVkX1/ygcqIl/my324vqyaYn/z1e9s2Z6hPRaT+hEr9cX+h7+aCVt8c7W5aTRjsFFD0rTKMVW51VCF8vR2uGQ2Vgan206G7EugzAKxvOhdBdj2zri0axG9xgPWC654RctnO66QenPgFMmLz9+g9R6noodUcVk4d37ZP+ljaRP7bug69I4tpprKThhGBeZ5fFMd71LP3b6cLEP3BLeJ9KiVLr18nXoZtjageloEIt3vjXbwKbq/zYxIUL5IVjwemnWGPnCzcAlniswyKREzv5FoQmHiAl2AjJPvGr3gDyV6QA/4dq8Hgt6yTuMdeuBJqAb6C+NxEEUts0c7VsMa4ls4lmT+KJ+G9m0rltjuaQDKvHNj9Q+8TUBiMy5Saz5SaKV2fUn6abLQLGogSe3MSfTymgbLcdk6beqVrMxzT1tEMjGCV76tiyEbBEGWpzis3cS4NeWqgZeVrEYMSBx2TnZRsva95t/0JAQYpu3PQpwMrADPm2eEYO+ILA++skoUyGZtdfq99GaoJbS9+2svGYch+jNSk5EQgfrWIMiyrVQ4uJ4XC/xya+H85SIxIb0TUhSM4hJpcM0jv46N2a8J2JrlewroZsmKrcZO3c1pxUPM3+Tm0Ci3qIwKRMXooHKRz7ZDPl7WPi7htjHF04X2rW71xq9NpDas+Di6RSogPUCA7azPTrVs2ega44otyNUKBiKvz73m6qRFV+QbRhBr59qlw4s4NThWE9OMpzRaUYV0UbeUAJO1op0fYEbShRKXqHoQBrJo9jzjGmeTWZayx6nId0Uswuw4t6GdoHAYx7JO0KRncTv2rNftGEDPzWbLktgGy8kbNM7lr/A7xoTtQn5qQ76TMTrL6hsiMXWdtMjZFDkGRMQIF9q3MfCDX7+mYdmTeTGr+YRsFPUBtmGqTW/Oh05Q3/ZHXRAGJvIBB3fYf0LE2cQ6ymY/sBQiyUIGFE0uEmhltCocJvZ2
 L9kiIeUM
 I2QtnECYmiBDey/drR1qP8KCVVQX7yQsBLvdi5KMa3uPYmf7UvjTTQRnKghUR/edf/jBA8ZV15OEgIBBPq1xsC++IZhd+hTscifGq19sHGejXAM3jvtkthV/k+elEPY0dpkh98JVAqn3DTKuUJosItvXytvUKyn4Jx4WHEZPme7Nu964t74GqndSMT7zPYLFt+37SPGXxpZOOnpoK5lZRNtIhWcPZJIS3NbNpNcN62d3Dxhmz2ukmmZzmI9ghOgKZBZ0AmGFN0k5GYQDCqXmIRy3/+JoVSYc+1lcR+2r5qNggWZLddpxl+WVLbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 01:00, Zach O'Keefe wrote:
> On Sat, Jun 20, 2026 at 4:34 PM Thomas Gleixner <tglx@kernel.org> wrote:
> 
> Thomas, thanks for taking the time, as always, for such a thoughtful response.
> 
>> On Sat, Jun 20 2026 at 12:33, Zach O'Keefe wrote:
>>>
>>> Ya, that's my concern as well, as I don't have a good intuition for
>>> how perf critical kernel #PF is for real workloads. If this is your
>>> primary concern, I'll take that as a _good_ thing ; i.e. there's
>>> nothing architecturally stopping us from doing this downgrade safely.
>>> We'll still need the analysis, but that can be a later stage -- we're
>>> more than happy to get this data for all.
>>
>> No. That's not a later stage optional requirement.
>>
>> You have a PoC which works for you otherwise you wouldn't have posted
>> it. So you can trivially microbenchmark the costs of the
>> up/downgrade. And that's critical information for us but also for
>> you. If the costs are significant then you really have to think about
>> the tradeoffs.
>>
>> Care to read Documentation/process/* carefully? It applies to you as it
>> applies to anyone else.
>>
>>>
>>> This is actually the most understood aspect. With O(100B) active tasks
>>> fleetwide at any point, it only takes an average savings of O(10KiB)
>>> per task to get to 1PiB. At least for our fleet, we know the % of
>>> tasks that use only 4KiB, 8KiB, or require the full 16KiB, and the
>>> math confirms that we expect O(PiB) aggregate savings. The % of stacks
>>> requiring the full 16KiB is minuscule, but it still occurs at a rate
>>> higher than what we can tolerate for SO panics. Given the vast
>>> majority of stacks never exceed the first 4KiB, this enables the
>>> significant opportunity.
>>
>> I know that the potential savings are well understood and my
>> understanding of math is sufficient to calculate how much tasks and
>> average saving it takes to save 1PiB on a fleet.
>>
>> That's a no-brainer, but this is an aggregate saving, which sounds WOW
>> but does not tell much about anything else.
>>
>>  1) What's the actual percentage of savings in relation to the overall
>>     memory?
>>
>>  2) Does the saving allow you to get more stuff done on a machine, pack
>>     more threads on it?
>>
>>  3) Can you actually downsize the memory on the machines?
>>
>>  4) What is the performance tradeoff for that?
>>
>> IOW, you fail to tell what the actual benefit of such an intrusive
>> change is. Just boasting an aggregate Petabyte number does not tell
>> anything at all.
>>
>> Let me give you a trivial example with a scenario which I have access
>> to:
>>
>>     256  CPUs
>>     256  GiB Memory
>>     64k  Threads
>>
>> Let's assume the full saving of 12k per thread. That sums up to
>>
>>       64k * 12k = 768MB of memory
>>
>> which is 0.29% of the total 256 GiB of memory. Not so impressive as the
>> petabyte aggregate number, right?
>>
>> The workload consumes about 80% of the overall memory and is already
>> constraint on close to 100% CPU utilization.
>>
>> Now let's assume that the runtime overhead of this amounts to 1% then
>> this is a net loss.
>>
>> Let me turn that around and use a made up example assuming the 1Mio
>> threads per compute unit taken from some reply in this thread.
>>
>> Now the full saving of 12k per thread amounts to:
>>
>>     1M * 12k = 12G
>>
>> which is 4.7% of the overall available memory. Agreed that's a
>> substantial number.
>>
>> That 12G saving does not do anything in terms of hardware downsizing.
>>
>> The only way that has a benefit is when the system is constraint by
>> overall memory consumption, but has quite some compute capacity left.
>>
>> IOW, if 1M threads hit the memory limit that means that the savings in
>> kernel stack consumed memory allows you to add about 4% (~40k) more
>> threads. If that ups the CPU utilization accordingly then yes, I can see
>> the benefit. But TBH, if that's the case then you are trying to fix a
>> user space implementation problem in the kernel.
>>
>> That said you really have to describe the scenarios where there is a
>> benefit and I do not buy this "fleet level" argument at all because
>> there is no single fleet which has a uniform workload distribution.
> 
> These are good thoughts, thank you. Perhaps I've been too biased by
> our particular environment—apologies for that.
> 
> We (mostly) punt this problem to cluster-level scheduling, which
> ironically exploits this non-uniformity of workload dynamics to
> appropriately bin-pack machines and materialize these small savings.
> 
> In the general case, I guess a lot hinges on that overhead cost -- in
> the best (memory-constrained) case.
> 
>> Aside of that. If your argument holds that there are only a few
>> scenarios which require a deep stack, then we are better off to identify
>> them and fix them up rather than trying to hack around the occacional
>> insanity of deep stack usage by adding complexity for complexity sake.
>>
>> As you say that you have numbers of your fleet which confirm that the
>> vast majority of the stack depth is below 4k, you can surely figure out
>> the information which call chains are actually exceeding the limit.
>>
>> I prefer to fix such shitty code and downgrade the stacksize in general
>> instead of papering over the underlying issues which probably have been
>> ignored for years if not decades.
>>
>> Have you ever thought about that instead of adding complexity with a
>> dubious value?

There was some (hallway?) talk at LSF/MM about possibly removing direct reclaim,
similar to how other operating systems handle it. Now, I don't know how feasible
it is (I guess devil is in the detail ;) ), or any details how that would work,
but direct reclaim was repeatedly called out as one of the main reasons we can
get huge stacks.

So I guess direct reclaim (incl. compaction) is one of the main problematic
pieces. Are we aware of other scenarios where we (easily) trigger consumption of
larger stacks?

Wild idea: as a first step to test the waters, use smaller stacks on selected
kernel threads and disallow direct reclaim/compaction if the stack for the
thread is small?

-- 
Cheers,

David


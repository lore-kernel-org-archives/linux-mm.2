Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54342CAC5B9
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 07:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6790E8E0003; Sat, 27 Sep 2025 03:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCEA8E0001; Sat, 27 Sep 2025 03:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C32F8E0003; Sat, 27 Sep 2025 03:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 346328E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 03:38:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F86987C03
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 07:38:40 +0000 (UTC)
X-FDA: 83934228000.12.2B408BA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C6CE8000A
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 07:38:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MDhzVIrG;
	spf=pass (imf30.hostedemail.com: domain of patrick.roy@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=patrick.roy@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758958718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wr7c37MXYsi1SZjRIiCMW6TvRd9zbqLAteCUC2bU040=;
	b=bf5ANkZdPHZ1Q5aMIFjlh6OmcBxfbG31Jd3mEL14E5kWDs6O3jUd+fxQ5wegsgzZ8fkKxF
	uJMKE39aodVsK3HcX3Riwtn1gwZSFXIdS/Bg/2ceQewQEfMHkBdJPa8P3DqxXk9TZ7tkEP
	QVMEeXBtPL1/exyC2pQUCvdPsjZvujM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MDhzVIrG;
	spf=pass (imf30.hostedemail.com: domain of patrick.roy@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=patrick.roy@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758958718; a=rsa-sha256;
	cv=none;
	b=Zm7f84KXaGzSbdqmYu/vCDpJu0G3U9s/fPDxlwoTHaeDNwP7HVmVJMciyoB8AB8V7xF2nF
	CGBWQuLvLbrLpAt0abgh9dvdWhA0Tkwa9cK6SoIE9EK6Td07K060V2lJG9Pt6hXclc/osu
	3JeQpbdjZR3edPXGn7+/9Q/lDI3SmiU=
Message-ID: <be89abc6-97ca-47d8-b8e7-95f58ab9cc67@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758958715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wr7c37MXYsi1SZjRIiCMW6TvRd9zbqLAteCUC2bU040=;
	b=MDhzVIrG9XqOhn+X4EyvqT5WFEC48i0ScQW1M2TEQNfH+Abi956kVrFuXVs5+tNbHUeEBS
	HSH1dZ6zZI6FfoXFd0qRETX0UB3fscW0ypzjqRJvDzeO0w95mYEUlUuw8Y//m8zDINyAux
	7aMnDrKrTlaK0SG5hxR2LTl6ILFDhs4=
Date: Sat, 27 Sep 2025 08:38:29 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick"
 <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
 <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
 <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
 <aNZwmPFAxm_HRYpC@willie-the-truck>
 <5d11b5f7-3208-4ea8-bbff-f535cf62d576@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Patrick Roy <patrick.roy@linux.dev>
Content-Language: en-US
In-Reply-To: <5d11b5f7-3208-4ea8-bbff-f535cf62d576@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C6CE8000A
X-Stat-Signature: gyra9zywfwxncng1eqbrjrfdrduiq9xy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758958718-720889
X-HE-Meta: U2FsdGVkX1/H9HbKy6tvk/VqW9cXCoTkoBrcNf3IVOe/1oLk4Ec1Tz5OaE4QvwUWEXHqSwsjI1D5Mn901mTIM13MWdziMVeR8z7DrmOEIJkbu14gtv0G5keVkcQ4pKqzhj+xXj0Hqi+AwrvoOZxFbIn9ig/04H6lk5J6p9KHOutz1cWnku3uPC8jiQH6xMA2gjFPoJ4MM/b4w7vqs5rUHbM6VMoGHtaAGoKn0rLnDwptBXpFNrx2r8B2tLcHREhFprO8xV4gy79t+Qq8ohboot+PUKGfcpYDTruQUhbnSiTMYIyJGnSbZv7/IzASPhk8eHX/iNz1+LEgqUgB8DOLuYTTFfMZsmubj7I4gfJbUNurD4OKZw3psEc4aOrZR6wW0N4NV8GQ4B7enY8K+0/Uj5HZTMGvPdeOFH1AQbhslxwkuKAX7qOPuWxFvYD4SbqfWUmubFOHQJJ0Y5lRLtjzUpsUrzsgUN9HNvgToXOOH35B2MxuRXuYPtSEiRA01/Uw7eGy/itYj4I6/eUqxC3O5o9cxWLEEV/m4Y70e3SP4C2kUv07bBFMecunbUI1QtB5AupW3AA33laO21huoArUgX2yEwN5UaJ2mR2rnJ2BBaWyE79pc6yBB3OFLTpvBXL9kplPWqzQw+Dc6Qb+okWU11TPdMyG01B8vl4l2NZDm5hYhnxp9NCHUMvlK/7VXRj6pMhZWwJsYireJnENuOFfOD0+WKgGbSs4DoyJYMiaCjD1qJnr/IFx25VY2jt39ldOXvP6uStI1QrKJB04e3iYDyx3FqGu1rnXq91SzDXmm8eXBnivKjL7tm8+enATV//ZkXxgznH+yWEMewsVkLNP8+uDaAIynpxYherZJVfdMMmxIu7APMfJy3TU0XrhLtnuQ9uPPRnBhXXL3XxrZgUvSlFfV4dlW2irkRel6UPmQH+3hlI9jFeiYBh9vovUpeL7dAN2l2+VCnWQsUVaXiF
 aEfosqEd
 Igi3vginwDYfqUCEdyhGx1lesM5UQR00oFvv3XBZ9QmFIpXcct6D4ai0xL/O0av4hHqEIVQWFxxBcQrLsyQk3eJFQc/RSHQd4fOFw2/SnibZ/ZXYSRlZ7bf4FBy/pw840F9ajrM3PRWlqyuL3Ytm71IuoOyJsenEYn/e8SgC9uh5ZFJtDq/9pibhGXyyRkCw27QBevUwWMmC9Hyy6Xk7AG1YBZwXWZGBkc7Xl068iypeeME5JvLAoV0A0kUpoHvarsmlnWVuOTMZPeHLSXVeRJfzXxEm1Z3L6pQUClvNZtnnrgBgC7oGcro55RGnazQ8DmW3QjqyadNcjx+CMl+1Xjd2tX+U4u7sbtLaE+Ty17oa44vdrQiR0Q5kk1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 2025-09-26 at 21:09 +0100, David Hildenbrand wrote:
> On 26.09.25 12:53, Will Deacon wrote:
>> On Fri, Sep 26, 2025 at 10:46:15AM +0100, Patrick Roy wrote:
>>>
>>>
>>> On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
>>>> On 25.09.25 21:59, Dave Hansen wrote:
>>>>> On 9/25/25 12:20, David Hildenbrand wrote:
>>>>>> On 25.09.25 20:27, Dave Hansen wrote:
>>>>>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>>>>>> Add an option to not perform TLB flushes after direct map manipulations.
>>>>>>>
>>>>>>> I'd really prefer this be left out for now. It's a massive can of worms.
>>>>>>> Let's agree on something that works and has well-defined behavior before
>>>>>>> we go breaking it on purpose.
>>>>>>
>>>>>> May I ask what the big concern here is?
>>>>>
>>>>> It's not a _big_ concern.
>>>>
>>>> Oh, I read "can of worms" and thought there is something seriously problematic :)
>>>>
>>>>> I just think we want to start on something
>>>>> like this as simple, secure, and deterministic as possible.
>>>>
>>>> Yes, I agree. And it should be the default. Less secure would have to be opt-in and documented thoroughly.
>>>
>>> Yes, I am definitely happy to have the 100% secure behavior be the
>>> default, and the skipping of TLB flushes be an opt-in, with thorough
>>> documentation!
>>>
>>> But I would like to include the "skip tlb flushes" option as part of
>>> this patch series straight away, because as I was alluding to in the
>>> commit message, with TLB flushes this is not usable for Firecracker for
>>> performance reasons :(
>>
>> I really don't want that option for arm64. If we're going to bother
>> unmapping from the linear map, we should invalidate the TLB.
> 
> Reading "TLB flushes result in a up to 40x elongation of page faults in
> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
> of memory population,", I can understand why one would want that optimization :)
> 
> @Patrick, couldn't we use fallocate() to preallocate memory and batch the TLB flush within such an operation?
> 
> That is, we wouldn't flush after each individual direct-map modification but after multiple ones part of a single operation like fallocate of a larger range.
> 
> Likely wouldn't make all use cases happy.
>

For Firecracker, we rely a lot on not preallocating _all_ VM memory, and
trying to ensure only the actual "working set" of a VM is faulted in (we
pack a lot more VMs onto a physical host than there is actual physical
memory available). For VMs that are restored from a snapshot, we know
pretty well what memory needs to be faulted in (that's where @Nikita's
write syscall comes in), so there we could try such an optimization. But
for everything else we very much rely on the on-demand nature of guest
memory allocation (and hence direct map removal). And even right now,
the long pole performance-wise are these on-demand faults, so really, we
don't want them to become even slower :(

Also, can we really batch multiple TLB flushes as you suggest? Even if
pages are at consecutive indices in guest_memfd, they're not guaranteed
to be continguous physically, e.g. we couldn't just coalesce multiple
TLB flushes into a single TLB flush of a larger range.

There's probably other things we can try. Backing guest_memfd with
hugepages would reduce the number TLB flushes by 512x (although not all
users of Firecracker at Amazon [can] use hugepages).

And I do still wonder if it's possible to have "async TLB flushes" where
we simply don't wait for the IPI (x86 terminology, not sure what the
mechanism on arm64 is). Looking at
smp_call_function_many_cond()/invlpgb_kernel_range_flush() on x86, it
seems so? Although seems like on ARM it's actually just handled by a
single instruction (TLBI) and not some interprocess communication
thingy. Maybe there's a variant that's faster / better for this usecase?



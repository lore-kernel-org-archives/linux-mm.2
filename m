Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3A0E909A5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA6D6B008A; Tue, 17 Feb 2026 08:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1926B008C; Tue, 17 Feb 2026 08:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE696B0092; Tue, 17 Feb 2026 08:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8046B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:56:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 173E2139550
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:56:56 +0000 (UTC)
X-FDA: 84454099632.24.40FFA7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 645F24000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:56:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LAH8TVyK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771336614; a=rsa-sha256;
	cv=none;
	b=zhMGKp6gIxrEWnKS84IBBWVJKuS0B3rn8BD1NKgaq7rumVY4w1zBxqFK7SaKfMv66SvM95
	AaMcvVrEUxrB9V2emIK27dqcLGdyqfbiL4+mYN1tWhJl/XsKAs/i9EDRnn0wVtWs+3JMBL
	TIi1AYTsfx236dpCEb4z60nqj1sbdWM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LAH8TVyK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771336614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQhqp/wtDIUiWssz+9qZ91D/50c74+1ToDq6TLqlWrM=;
	b=2oguJr4A5i3juQ32duPL38ZFwKM3eYjvK9c2qzuW49B84zLt3PLstdEDUGmm5wZAxhZIgo
	CTq7a3rcsi3w2nZY92MA8qJ+i1tf9yTJWhWuFR50Y0LOvn4A3K5uQWmQfeqKqlWqDQL9eU
	JNFRkBnSQildd+Lcwj8qDzuXWNzaCQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19BA740846;
	Tue, 17 Feb 2026 13:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16983C4CEF7;
	Tue, 17 Feb 2026 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771336613;
	bh=Iy8wdT/7KAZeU5VN9H+5axw4leXfO3No4pUMNhfmehA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LAH8TVyKuqZ1PTZK2SPxb77WGWq9rrJnTXa8+AaHsLa8LU33ezmTFDSf9iiuYgzki
	 KSMC1o18J22PW2j9Yl0y0Aa4PYgizeauOPWSsffdEInipCNLZz4O/6vmmCPeqb6Ki9
	 Y47RTHZib0CZBu0JDyhPZ9iSuJK4gLu6gHtfwep5/yv5ZkXi1ED3A3DtLdPhpwAJJw
	 zSL6YukxGYdam1yXs/MTSZ4KJ+UI6Cz5MVqbPId7qWo18iAVJ3zQJ7S34x/c3izW/5
	 H5mVWCmKlxykBZdJD3fVhfz1S+f/Obtbd6MVSfkTtXrGy0HFrBrjBAy7jtAr6/pcjJ
	 qdYINAgGknjOQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <aZRWOIPThLfIZ1Ph@google.com>
References: <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh> <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <kkmXYWYC07oImDD0FJFVCCWl45alQdraRLHoLr7zowZfE0tMz0MmPIpuyEYQRSLjBQqrp_Ch0iR2Rix_g49lNg==@protonmail.internalid>
 <aZRWOIPThLfIZ1Ph@google.com>
Date: Tue, 17 Feb 2026 14:56:40 +0100
Message-ID: <87ecmjcw2v.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 645F24000F
X-Stat-Signature: 33g96cfjqmbj9tg7updcyr14xixz66od
X-HE-Tag: 1771336614-476772
X-HE-Meta: U2FsdGVkX1/vKWXHLZOvooMZ4YBm0QiJGYGXF/bznWwaO/h287gcb3Il2fiyPO/6uiEnwnuhbOkzpqcZw6bVpcd48SUOupgcRook37zaAIa0uMaF/W6oq43KLM/sr+Nm5DYVg4wuKTKfQz7Ki5rsVUznLP4/Hsy/Hw27gyIXt3eHpXHEFPVHJn6Ccxy4nn91ZL/z5UfQhMyr3kM05Ec5CPAYw4exgm6P87WE1L3GybSdHg7zB4MLkFrLpYS23Yn3iXlQ+CoseuFZbXXolAOA+Vihf9ae1sB0jQzM0h+j6zIK55nlu+ryH7CC58RvTx2DrKo4LLyjd5B2MKkaDCFbb/0YSDr0BPPpdHVK1S9tgdtGJe5VeDXVXDnXqQgnrSAn7+i349Y2Yoylal04gbUlv0j5ab6rk07EHJrtgBGnOZAyfqf/5nfZkYoshLKDPE9n0ngIWVgeoMQCJXGDw4d7qdmxXS0FDvBGTEkFRxUM4xretYwJ9w7fB+iNJPNCLmnKraHA2ZTocJKsV+ip+ZEvD65al06Im4cmvRdd7+wT51avHXPGZuZhtWoUdq9e3oWr/Rv3V1VJ8lq8NpcbnuDUColOP4rVcSjsYQ07uL9HSqulN3BEs7B+8FHuHzy7APTCPqIw9Ifo4YybQT9Dtcm2NNxy6k0XWRLg3D5XK1OncpUYG3LQMqQFNN/uJiMVAzD/Bn8i/DftLocZ/XqZzmOJzfrouqf8eY6ASkXoHsch1OjsuuoGrmFaRE37wlN9JcZWWXMm765Mz5CFsqeJfPB50h10oWax8wUCi26sYH1W8HgyU7SS6N6x72nv06r7lTYUM+wUtx/9SB9R01z06W0jFlGpoxVqRwpBSwdF/rCVsk/YjSnonVc/T5VIp/FD/w3Bm94ruFbuD6uvNjjfVll82eEa4C8oGiAD9O8X/nE1q/G6JBMIy1yOtWjEuWHPZZD7LfF/fTbXZSEUJB+SDVJ
 PVvMKtMG
 8IqPt6TvCDXqMOUZlkkXNfGB98ldRBiP/EzfIm3M618ewdQxeZCrFT87JbO2Iff4zr69U39ABMRA6USVXVIl6d6A9SUyiqeiYQgp3OXcdPzusFCZsoUs1HXT1dJU9Uw/lP9B+CG6tGCV+NhCM28PukFGsFpmc991ZbPhrHCDEGNSbU0ksYJJAUWOywid0w39AXxvy8DlHA5Rf7+7TZ1bodLVVaN+dPq2xQ5T+PuW4CnduC+AoRgBwcxTwogPssMTsaoAu6VLedvDkcgcKLXk6mVf2Udr0vU5g7BJ6vscxpNp0D9E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Tue, Feb 17, 2026 at 12:09:11PM +0100, Peter Zijlstra wrote:
>> On Tue, Feb 17, 2026 at 10:47:03AM +0000, Alice Ryhl wrote:
>> > > > 	// OK!
>> > > > 	unsigned long *a, b;
>> > > > 	b = READ_ONCE(a);
>> > > > 	if is_valid(b) {
>> > > > 	    // do stuff
>> > > > 	}
>> > > >
>> > > > Now consider the following code:
>> > > >
>> > > > 	// Is this ok?
>> > > > 	unsigned long *a, b;
>> > > > 	memcpy(a, &b, sizeof(unsigned long));
>> > > > 	if is_valid(b) {
>> > > > 	    // do stuff
>> > > > 	}
>> > >
>> > > Why the hell would you want to write that? But sure. I think similar but
>> > > less weird example would be with structures, where value copies end up
>> > > being similar to memcpy.
>> >
>> > I mean sure, let's say that it was a structure or whatever instead of a
>> > long. The point is that the general pattern of memcpy, then checking the
>> > bytes you copied, then use the bytes you copied, is potentially
>> > susceptible to this exacty optimization.
>>
>> > > And in that case, you can still use volatile and compiler must not do
>> > > silly.
>> >
>> > What you mean by "volatile" here is the same as what this patch means
>> > when it says "per-byte atomic". If you agree that a "volatile memcpy"
>> > would be a good idea to use in this scenario, then it sounds like you
>> > agree with the patch except for its naming / terminology.
>>
>>   struct foo {
>>     int a, b;
>>   };
>>
>>   struct foo *ptr, val;
>>
>>   val = *(volatile struct foo *)ptr;
>>
>> why would we need a an explicit new memcpy for this?
>
> In my experience with dealing with `struct page` that is mapped into a
> vma, you need memcpy because the struct might be split across two
> different pages in the vma. The pages are adjacent in userspace's
> address space, but not necessarily adjacent from the kernel's POV.
>
> So you might end up with something that looks like this:
>
> struct foo val;
> void *ptr1 = kmap_local_page(p1);
> void *ptr2 = kmap_local_page(p2);
> memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
> memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
> kunmap_local(ptr2);
> kunmap_local(ptr1);
>
> if (is_valid(&val)) {
>     // use val
> }
>
> This exact thing happens in Binder. It has to be a memcpy.
>
>> > > So I'm still not exactly sure why this is a problem all of a sudden?
>> >
>> > I mean, this is for `struct page` specifically. If you have the struct
>> > page for a page that might also be mapped into a userspace vma, then the
>> > way to perform a "copy_from_user" operation is to:
>> >
>> > 1. kmap_local_page()
>> > 2. memcpy()
>> > 3. kunmap_local()
>> >
>> > Correct me if I'm wrong, but my understanding is that on 64-bit systems,
>> > kmap/kunmap are usually complete no-ops since you have enough address
>> > space to simply map all pages into the kernel's address space. Not even
>> > a barrier - just a `static inline` with an empty body.
>>
>> That is all correct -- however that cannot be all you do.
>>
>> Any shared memory will involved memory barriers of a sort. You cannot
>> just memcpy() and think you're done.
>>
>> So yeah, on x86_64 those 1,2,3 are insufficient to inhibit the re-load,
>> but nobody should ever just do 1,2,3 and think job-done. There must
>> always be more.
>>
>> If it is a ring-buffer like thing, you get:
>>
>>          *   if (LOAD ->data_tail) {            LOAD ->data_head
>>          *                      (A)             smp_rmb()       (C)
>>          *      STORE $data                     LOAD $data
>>          *      smp_wmb()       (B)             smp_mb()        (D)
>>          *      STORE ->data_head               STORE ->data_tail
>>          *   }
>>
>> if it is a seqlock like thing you get that.
>>
>> If it is DMA, you need dma fences.
>>
>> And the moment you use any of that, the re-load goes out the window.
>
> I don't know how Andreas is using this, but the usage pattern I'm
> familiar with for `struct page` from my work on Binder is this one:
>
> 1. memcpy into the page
> 2. return from ioctl
> 3. userspace reads from vma
>
> or
>
> 1. userspace writes to vma
> 2. call ioctl
> 3. kernel reads from page
>
> which needs no barriers whatsoever. There is nothing to prevent this
> kind of optimization in this kind of code, so an evil userspace could
> trigger TOCTOU bugs in the kernel that are not present in the source
> code if the code was optimized like I described.

I'm processing disk IO in the Rust null block driver. The pages backing
the IO requests may be simultaneously mapped to user space, so there is
no way to guarantee that there is no concurrent memory operation to/from
the memory area. User space programs can do whatever.

I don't have any control flow depending on the data I copy. I just store
it somewhere and return it if a read IO for the same sector arrive.

Let me add a bit of context as to why I sent this patch. I am not an
expert on the finer details of this subject, so I rely on available
expertise in our community. It is my understanding that copying the
memory in the situation outlined above, without special consideration
(in Rust) would be undefined behavior. Such are the rules of the
language. Of course I don't want undefined behavior in the Rust null
block driver. When asked how to solve this, the experts suggested
defining this byte-wise atomic memory copy function, A function that
would have well defined behavior in this particular situation.

That seems like a reasonable course of action to me. I don't understand
why this is such a big deal, and I don't understand the need to use
aggressive language and swearing.

I would suggest that if we are failing to understand each other, or if
we are miscommunicating, let's be curious instead of angry. It get's us
to where we want to be, way faster. And it is a much more pleasant
journey.


Best regards,
Andreas Hindborg




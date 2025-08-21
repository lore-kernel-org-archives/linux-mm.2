Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D29CCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AFC6B0011; Thu, 21 Aug 2025 10:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933826B0012; Thu, 21 Aug 2025 10:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8221A6B0022; Thu, 21 Aug 2025 10:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9B56B0011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:15:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F4BEC0441
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:15:31 +0000 (UTC)
X-FDA: 83800962504.20.2D9D46A
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id 612ED4001C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:15:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=OF5LdvWf;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=Jf2Wgg3J
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755785730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsvDeHWgZc93f0po8wwYyN06rP47fEkn9doFP/7K+wk=;
	b=iPA0QCIAvR/uNTuBFQwqccuIffDVeYC0pW55P3lNScNOkxaUX/iNVXf6qElfd8N63JEgB8
	vefsZhjXvQLECPBoyC3x136+xPAPFPjV3DCjt98wFfX4enYOMEOVhPCsznvGDaIlaVvGCe
	mi5Z3Is6EpZfv/mkoaHpnv+FCeSb+lk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=OF5LdvWf;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=Jf2Wgg3J;
	spf=none (imf11.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755785730; a=rsa-sha256;
	cv=none;
	b=Vrm/fRHxwH71Dn2dlng+yoHUUfNk8TeyZPqDWKekXIL1Z/JTlQ8c8LEi+xoC/mWoxZhosI
	mL7OtvfEvlc8DRpEMMEZVrKwgoEBoF87teI01S0W0UGLNJVYSOV+3Pmhw6JXd1hLbPbabN
	REBu3ODU8Gk/DQxQC4ajFHJNWpgdDL0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755785727; x=1756390527;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=GsvDeHWgZc93f0po8wwYyN06rP47fEkn9doFP/7K+wk=;
	b=OF5LdvWfkSvMzcTHcMlUF39vdcWjEzEDTmzloomgJ6NfyC6x8w6taLxUYXvAByTttkJKQD5QjRlSm
	 EaoZkzevvggjEJPic7NGw2lN3GI5UT+AI2wJ2bxqjSN+PgIWhoGrjGUe/Mrk55Ut+grkQWZosTLXHH
	 lJdN8MmfSVJPGAblL52nE7sIY2HmD1ZNhGh1Me7Xvjrls7zVtKHxLgJpYCmZ50cx0wqMKEF4//8cVU
	 HvHqFM3BHr7pI4tpdAe3WORP9WmVeX+q21pgKE6Pq4RqGTg/zke3m824Kkab0LRw2atV2AJ5tTcgMf
	 u0ARy3Eu0cAEbR27bCBQczKJZnQEjPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755785727; x=1756390527;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=GsvDeHWgZc93f0po8wwYyN06rP47fEkn9doFP/7K+wk=;
	b=Jf2Wgg3JfJiS9bqME6Trr5NLTaI9eMvGOUZD4OsL7dogfQDVtmITkVTHCwPUwC7kaPB/xm9tFfMlt
	 8dMiRIXBw==
X-HalOne-ID: 4883bd8a-7e99-11f0-ba34-4f541c8bf1cc
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 4883bd8a-7e99-11f0-ba34-4f541c8bf1cc;
	Thu, 21 Aug 2025 14:15:26 +0000 (UTC)
Message-ID: <27139676-8470-4067-b259-f01022751bbc@konsulko.se>
Date: Thu, 21 Aug 2025 16:15:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rust: zpool: add abstraction for zpool drivers
To: Danilo Krummrich <dakr@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
References: <20250821111718.512936-1-vitaly.wool@konsulko.se>
 <DC83A2M3G8EH.12FRM3C05ABCR@kernel.org>
 <DC83WSYHY3K1.1D3XEES0BIKGS@kernel.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DC83WSYHY3K1.1D3XEES0BIKGS@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d1gqzuxr8ue835r4i3hyg55nsxkpsnfp
X-Rspam-User: 
X-Rspamd-Queue-Id: 612ED4001C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755785729-604456
X-HE-Meta: U2FsdGVkX19nvgOfet8VXm4mgHS/DYdyTVO3h1OSxsXuFlUhYxf4dLK0vXodLlOKiQ8Ue632XzoL/he2aLc6ZeU5YyMe6jlTLXvSvuHkTjUyM6ZFhk0OZWMi+QrCVlM9SoP/cIxu5qPrsSIzvLwcLrC9UP0O2CCjp39q1FsBbVTRB6zuHAR9UeMtHkhFJvLUHq/lnY92vQ8jYfChcrzhmlTcWwT6w68IkSfTh/S+5pt4VaJEH7SJMck5rv+ejQezOzQZ8LS77FlFBjATBvqgXPnzTNjBoaxVKM1KGxWe541sTX6oc66xazZ65Ne8MlAG0lgKnoNdgvbcbNVbijB/eSOeQnPkRTKIzoYbZl8XxUX8KyddGO4oszaLMFprHcgwq0q/k56nSn8Yqu+CVCK6PsTLqGABnV/RZdVMGi2lgq4gv1WrkmMe2Se+6kCjDxWNCVEeRO65H1wd9ysZFmuRFwlPR7+lJp1XCPUxl04hCAsehXntL6Q18k8aMeE21w91Hs7ch3i72HCnUYo0AZv+/5aConLWTmLzKlMaFolbK/uEIUlGidj0kmDDQRcgwdu9Eu0emfx3+qiGOP3TrSpxOO1ffHGjS4PwEiIDz21DiOYNwUMrTcbd6ndc1U++LjdRJ4H8l7reVetzsY1x+Md8xYR4fC3Nke6oJdBtHg9MkMZNZu4NAIR7Y2W5deIg9iMQZsDfraBDVSKGBa+fDBXatz6fjvoiLV3mc/1oDvISbw4V1huC4kGoS/mb2Ql7Wv0snTkuOoS7ME8phR1jWkFe4pbTT/m7tBiJqHRzXBrc1al6KeWlTN8YPIU3J8rwhi8GIHQ8nyr48UjoL/bxV5uix1Jr1N3zWb/mFe05K653WFjVESBnpKlgqULYSwIOWq4cK1SmiPQMEHAl2adQ2xCj4tRN9O2os6sa9e8EVbXgnetXyXQrDaKqUS0rr1b6WMnBSR849BEPjZbTSTKK9NK
 z+yj6f13
 5L65r00rAJGZOXZMlwoSPUUmrWx11FgaM2vtcW6j+FgYmoJXMrd9/jvU9LDHtJ5QwZbN7KWpDuN3L9cQeqdh34f1o5dyay7ZAX/2jNXKsld0nkXdZW64gJivw4RrgCHUH/TrgWABacI1gefQY3DZJne1YebjgntbYB1P4L4WsZBRl95sWallRRDj8TH8ULjrQyredqhKT0P80vV/+Q7AjmTLnKvMxxKVTIClTdLY96QRYQJU8Qqa4LdNFT/sYlVYgdz/X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/25 14:32, Danilo Krummrich wrote:
> On Thu Aug 21, 2025 at 2:03 PM CEST, Danilo Krummrich wrote:
>> On Thu Aug 21, 2025 at 1:17 PM CEST, Vitaly Wool wrote:
>>> +    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
>>> +    fn malloc(
>>> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
>>> +        size: usize,
>>> +        gfp: Flags,
>>> +        nid: NumaNode,
>>> +    ) -> Result<usize>;
>>
>> I still think we need a proper type representation of a zpool handle that
>> guarantees validity and manages its lifetime.
>>
>> For instance, what prevents a caller from calling write() with a random handle?
>>
>> Looking at zsmalloc(), if I call write() with a random number, I will most
>> likely oops the kernel. This is not acceptable for safe APIs.
>>
>> Alternatively, all those trait functions have to be unsafe, which would be very
>> unfortunate.
> 
> I just noticed that I confused something here. :)
> 
> So, for the backend driver this trait is obviously fine, since you have to implement
> the C ops -- sorry for the confusion.
> 
> However, you still have to mark all functions except alloc() and total_pages()
> as unsafe and document and justify the corresponding safety requirements.

How is destroy() different from alloc() in terms of safety? I believe 
it's only free, read_{begin|end}, write that should be marked as unsafe.

>>> +    /// Free a previously allocated from the `pool` object, represented by `handle`.
>>> +    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
>>
>> What happens if I forget to call free()?
>>
>>> +    /// Make all the necessary preparations for the caller to be able to read from the object
>>> +    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
>>> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize)
>>> +        -> NonNull<u8>;
>>
>> Same for this, making it a NonNull<u8> is better than a *mut c_void, but it's
>> still a raw pointer. Nothing prevents users from using this raw pointer after
>> read_end() has been called.
>>
>> This needs a type representation that only lives until read_end().
>>
>> In general, I think this design doesn't really work out well. I think the design
>> should be something along the lines of:
>>
>>    (1) We should only provide alloc() on the Zpool itself and which returns a
>>        Zmem instance. A Zmem instance must not outlive the Zpool it was allocated
>>        with.
>>
>>    (2) Zmem should call free() when it is dropped. It should provide read_begin()
>>        and write() methods.
>>
>>    (3) Zmem::read_begin() should return a Zslice which must not outlive Zmem and
>>        calls read_end() when dropped.
> 
> This design is obiously for when you want to use a Zpool, but not implement its
> backend. :)




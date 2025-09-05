Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7128CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376F46B0008; Fri,  5 Sep 2025 08:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E8B6B000D; Fri,  5 Sep 2025 08:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BD06B000E; Fri,  5 Sep 2025 08:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 188766B0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:03:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBEEBB5EDA
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:03:50 +0000 (UTC)
X-FDA: 83855062620.03.DDFFF79
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf12.hostedemail.com (Postfix) with ESMTP id 411EC40014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:03:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=NZ4B7WJy;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=ZErcmkJW
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757073828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lT96qRu0B7WnFHrHqRSMSqB3AcU/t9e++Ul2OxkBts=;
	b=GJIF20zK+h2igS4k7kBMuJd64kg/+Hilev5GmW7RbnDhdKsGQ2GpMFHdDRRLflRHDF4R+t
	XG5tYBC9saDvWnF14ZvpivkK18RtwkRnC9/vNuxin3RXauxbnfRjvziZ4+cicl5nEsGDUo
	tj1yuSRqeaRukv1p/5dUwnoyOZ4N5uM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=NZ4B7WJy;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=ZErcmkJW;
	spf=none (imf12.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757073828; a=rsa-sha256;
	cv=none;
	b=e31G5v4+eG51DkO5mg6337rtdLRDcZmM+qU5SMh5CRHVoIL1M6ClWbrzaSZUHlDBjeEyKn
	Mal/2jtXkBxd+cs5+uIcwg7FHpimBYSKsLIoiYZnfJO6V/c2BktjCnz8zhgmOJLUqt1aRB
	rPCVxuufNSKBOcM8rWxFH168N2EU30Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757073825; x=1757678625;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=4lT96qRu0B7WnFHrHqRSMSqB3AcU/t9e++Ul2OxkBts=;
	b=NZ4B7WJyCkuvvWe+8/kOVc88qCQz1R09Sm/iphxSmGP/cLkImXIEZJteH9drIeedFoVO721rcI1ZB
	 7YORVBtpEAQlSwSiguNyZZpy6fuO1wHBAMWSN3VakwZWxVGoelpCd2xUbS5/LO1EcjORfrktjwl+vk
	 vwVN5O6R8AW4rt6zjiBbFUAdm0Ir/gu5F1qVFt9xi7Rr35STwviiq+q1J+3JD1oFXoZf8UZeu15QOG
	 SPh7LX8XFG10s0TlsW6Cr/VrUiTpDiyS544OaLqDWUvTx8NrVV5MzAeNDEuJytjHC/IUl2ajexRh39
	 0It9pSzN2mksSd3a2XXFhh8PtpOccwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757073825; x=1757678625;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=4lT96qRu0B7WnFHrHqRSMSqB3AcU/t9e++Ul2OxkBts=;
	b=ZErcmkJWrxAGuYVv6lFP9TeOcvcbIhp0ZtAnQMhQL89kJyKB8BCTmxnHMoBJLgdZ06kpqV1HOyeNh
	 NaKweGRAQ==
X-HalOne-ID: 5e268e94-8a50-11f0-a450-d510462faafc
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay4.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 5e268e94-8a50-11f0-a450-d510462faafc;
	Fri, 05 Sep 2025 12:03:44 +0000 (UTC)
Message-ID: <8feaad36-7d58-48a0-b83d-d503e3343ed6@konsulko.se>
Date: Fri, 5 Sep 2025 14:03:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
To: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250826124454.GA1502@cmpxchg.org>
 <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
 <c0b9d34e-1a21-4a97-b898-c33f7c8b49dd@suse.cz>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <c0b9d34e-1a21-4a97-b898-c33f7c8b49dd@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 411EC40014
X-Rspam-User: 
X-Stat-Signature: eachaw9kwg11qowuc3hj1xfd5eyka6j8
X-Rspamd-Server: rspam09
X-HE-Tag: 1757073827-794636
X-HE-Meta: U2FsdGVkX1+Pguv+ybD7O/bNsLSqC/DwQBkSdTeEMoBIakzRN+ZoP5hmur39ZiRckLuEsrQhFqWaQZ57GqmnCE8owVRmuU+20dsHkA1u05XhXLGRs0f/TnEEFeeqdoU77T4/+pmn/o8qksiQ401Y6XcWyEkW20zXH87VDyBTEAXFOJg0EMuPfDAB5jzuj2eEHGoWBXjK+wSwPtWfroSARLCI3Ls5X+4QLtgOu1jmvOy4SYtSlOfIACF/uT8Jh5CMVVzTNNf0YoK5BaowI2BJOEJjG6l5DubAnoHJ0I/BHYb6CLA/II/vxjuMUeuKC8nVjlQh5u43JNdx0kzGxUwKkr253OiQv05qgql60q4rTYzSHdHC4BbPPFS5wbgXbo1WqP9Y532tsrnEb1YiNoudyYNlzHy8WZYadYZOfsDIj2qARijN7lHU4EXf3kzbNA37eYgSUgpi2EMfyeENzEwDDyyD8o+dUM49gr8g1YB73CyFlrC30debUxhyeDw4BWLlK8sWSQ0UbD4pucNeC1XUh1xf07WiuazpUHvNDaDVLj9kQuq0R1XyI39UXQXzfd48wXv/dIEzYTVg5ff32yZBlBMYPYu7PWpO5KS9smRrHKEvMul6VRGExSpMpEZwpBc7DfDnCswYozws4PeTYVNRNboz346SmvvjNfSSv97dzuPcjFzqteZ2geUUTZS6T7/1S2bMSHTEOJyFoSq04vjRsKWTIcyVZ1mjJui5RrQvneuxwV3DJhq1ssjED2Q8RmoDO/F+3BW0hLgdfG9MgiETRiC2WhtzMDUl9CgqLm28dkqVzWOiit7e4tXX6MYXz1/J1mNAF9O2ZUGIHoEWgIBjGPqe01cGZyCc6JVg+SLVW1jH/ecSD1LXdUvO5dyO3ghaYBb7C0sFXJ2X8603DUmrVwo85ZwtizcKNFrxgG2NCUXNQ3MWdB3L88PbdxzHiUByi3Az0E6DDDg0cpjyjm3
 BdgqInPv
 wHfBjR2s27sh5Z/on7DZoMzHcv4mSCxEcoda5MP3ZPnnNxpmqSjGMJ+sCqLMnp5VYl33kGj0Yl/ULuHjfoakjJ78o/W+U8lVPAciZQTZZN+XmGsORZsXjSEyolZslB+pC+LRfPw2gQbZQ36xC+NdtdO7YIukLdIr3qe6VJu/pubL6F7JpsZWATAO9BjjEWoRL+HNuVOz/SoEIzL5doUP+4lJB0/xUQoCFOrilFPnLxoGKBfr4tmat1wxwhO0QJ37kFSOXLrwj/KlXEevWtIHezCxPb8Vczou6I58ZWV9yT2s73zra6g8mSNWTfdPhjYEzZAxfXuUT/Z/LRrlvuDukvQ8D1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/5/25 08:58, Vlastimil Babka wrote:
> On 8/26/25 16:56, Vitaly Wool wrote:
>>
>>
>>> On Aug 26, 2025, at 2:44 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>>>
>>> On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
>>>> Zpool is a common frontend for memory storage pool implementations.
>>>> These pools are typically used to store compressed memory objects,
>>>> e. g. for Zswap, the lightweight compressed cache for swap pages.
>>>>
>>>> This patch provides the interface to use Zpool in Rust kernel code,
>>>> thus enabling Rust implementations of Zpool allocators for Zswap.
>>>
>>> The zpool indirection is on its way out.
>>>
>>> When you submitted an alternate allocator backend recently, the
>>> resounding feedback from the zswap maintainers was that improvements
>>> should happen to zsmalloc incrementally. It is a lot of code and has a
>>> lot of features that go beyond allocation strategy. We do not want to
>>> fork it and fragment this space again with niche, incomplete backends.
>>>
>>> It's frustrating that you not only ignored this, but then went ahead
>>> and made other people invest their time and effort into this as well.
>>>
>>
>> I don’t think we have a consensus on that.
>>
>> And zblock is, after some additional improvements, just better than
>> zsmalloc in all meaningful aspects, let alone the simplicity. It is fas
>> easier to implement in Rust than zsmalloc, too. Besides, zram is a good
>> candidate to be rewritten in Rust as well and after that is done, zblock
> 
> If your target is zram (not zswap) then I don't understand why insist on the
> zpool layer, as zram refused to adopt it in the first place?

The target is zswap in the first place.

Then, I apologize for quoting myself, but what I wrote was "zram is a 
good candidate to be rewritten in Rust", and I still hold on to this 
idea. zram can be greatly simplified by that rewrite and the code line 
savings will be far more than 700.

So, back to my point in the initial post. When/if zram is rewritten in 
Rust it will make more sense for it to use an allocator which is also 
written in Rust rather then zsmalloc, provided that the allocator 
written in Rust is good enough. And *that* will leave zsmalloc a niche 
backend.

You see,

>> will be even safer and faster. So while not being “incomplete", it’s
>> zsmalloc that is becoming a niche backend moving forward, and I would
>> argue that it could make more sense to eventually obsolete *it* rather
>> than the zpool API.
>>
>> ~Vitaly
> 
> 



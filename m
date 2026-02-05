Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493E7EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FEC6B0088; Thu,  5 Feb 2026 07:14:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA3A6B00A0; Thu,  5 Feb 2026 07:14:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC946B00A2; Thu,  5 Feb 2026 07:14:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2446B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:14:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58B76B9BAD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:14:12 +0000 (UTC)
X-FDA: 84410295144.07.CF82BE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 76B351C000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:14:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=txhaHddU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293650; a=rsa-sha256;
	cv=none;
	b=lr1woIrvMEYE2D7nvWa53t7hcTBVfXEb+qiSw5hkJQPFK4pFk8MF0Ni9l0OTIB4Ny6MwBg
	mvp1/nLArDthbq3h6yHIDtoBFOrJpWgUmQMSU0YyNsTN7/cntTxz4rUly7JhnMxvDWgf2o
	IFd1Y9xmc/aDhU1t20iKaqKqS1PD7Xk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=txhaHddU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhYPLtv5BFAgr4tC4nIgAxGDdR/vYikfsQgf2DkWK7g=;
	b=R/8UMTL43sXXzi55ArH3HSDJTmK4PlS2a7ggcNxMmqRbr/McOM4s95ow7B6ULmmHxyko/H
	sDywNDMQ1/+xq1McMmHVHg3k7OAVhu5NlTUjDhSwL3kwUNfcR+WYbBU22OAxNjh2Q8XgYN
	RPnVTkrV9QACmNIMmauvIwAfqq2pMbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C6AF44051;
	Thu,  5 Feb 2026 12:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32FAC4CEF7;
	Thu,  5 Feb 2026 12:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770293649;
	bh=9jN+BDod/6cgG8UocPpmqHvElwEiGgALIRDijtAwY7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=txhaHddUgt/UaFox6Pdrerak+6DEPlsx89yBDu8X5lNmpAOI+2aNvXhhA8Wy0f7Rw
	 XaJoXos2ZJBNTjYnT7/TBcx5N2amKWji5Ew1eC3Y3xG+jYabr2R89cCtzZzPhvAoFO
	 eSp7SnV9Drd0srxU9vK7Y7dmDpFCaF7NnHijOJMn0lANPzA3K1TfaRMVRDEpobJ++1
	 5Dr5UkpTHJ2WsFsqe53OgGMjJwaZOKT3jSrXJIZ4ta86IgXTn1AHuxIIQDPyU05JPy
	 XX5i8AmYpFGFA5fFTBYl3bbFnevKVsewpDXPqqSdGX7I49JRRirjDnyrMsGDmdFuKj
	 pSUdok4N4FgBw==
Message-ID: <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
Date: Thu, 5 Feb 2026 13:13:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76B351C000C
X-Stat-Signature: oihp9r9fbq5exe1soj7nohux5mp4x9f1
X-HE-Tag: 1770293650-853689
X-HE-Meta: U2FsdGVkX1/jp+e8iHPyd14/IcTxs/zzdKkOqxvWN/BfA9bLEj1EVpb7nmNcayjNq6c/XOELlRckZpDTAwl/n4tHzYRleMSn9pf2LkWFRcon9nFuEy6Kg1XivmmUg8X0l7sZfPZ0B6i5mmTqHsxUJkjH1PhR6gvqpFV6TDhWXSrWM4bDDkEexO9D6o2FNplv+Wa4++10DVULNZuowLzXBZdtitEPvVeq65NxlwVdnBoxaA+4eZsBxTASEaqCL0VeV4V88FXcvoM1da1hV/GiRVGAp856X9ojSsvm3prLFwfcw6uxTcdGQg6Br5nMoaR53Lm+NKrqGVQCvk87inTzILBKXldLQnQXVxn1ttTTw9JleKZcW8tHnt5Jtt8LJf/5+VLNwnai5y5RKvEhf9S9So5zvH3lNNqq4esDisT2l0+SadA8KJxKZ9d1eTG8fJBNr/YdRAjA5+dYFtvr3KX309qOLCsvYHBMKtTbYV5OvCnfwGkb6GgtOEbuRzlXDB72N5ihHz5jxwQmO6ySwpI9ZR/o8IepdMXvdCMLiZAUb+SznHV0RlbPAzF/YQlt1VZFGGlMgoYYI3+4fclR35wNWBWjTklCr07EWZtULLzXprcwouYBUCTkdnSjT9AFfTgjKcu0Oi9NWywZZviD3sxUrLn3bfz2Skx/tZySbySe5wGJjdcE0CoY1YwSxOGP1uOi1RG+8ZHnCYFNCGQbD4XQrVwLhTcQnt/YG18p3y+Hj+JkJEgZqRjiTrSS1fyff+NpZCr1yPK+caIZnbtkBpB7bD1LH3lfYkQt+Vi2FeoUiDyNag3u6l5YmxTYreO6BY6BA9NCC3VcGi0wkOLDPMADmR6gn9f3fgvhiIrdogqYjnvShpjby5Cm6U07l4wUPLXbOeb4V92OdmFJB51KwXSyjgNtAJYFW4HYXpjXUCJdA0SnXz0OLCw7k+o41MwUmVASDAPTjBJx+sp84MPh3q4
 hpnJVnK7
 8XQwDtCmhRVZZ63obbsxMuh88BygRET+cLXIVYUgBK6MdymMs01Z5DWl+iwcpUgdFybIdfFVuxnz+Pl0H+JZPplqtHlJhBoXwKO/H9/VL0H9+x+4LkDt8uX50VMyw02Xbx1v8YRIIoH9T8QTsCyEqwmScXGhZiUmgc8/CF9Kw8Fz36Ck9ROnFzFPZA+Kbl3pUn07Ns9FFcorIosNzJwJi4fVllK6QS1ef3vVPb4Vk1VhRLcDHHI39fO9prQfIzcWLM24wC65vkM3R35/moVIRSy50z9pTXgaLdMYzaWBsrVhUA+lqyRqaXtThh43qhOgm5aePZab6wPSDN9Yog0tEZb+N4DNHLnNIY36Omr8VHzjfJP70KT0PGCUbnLyNt/pZmbrq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:10, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 11:58:00AM +0000, Alice Ryhl wrote:
>> On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
>>>
>>> I don't expect anybody to set zap_details, but yeah, it could be abused.
>>> It could be abused right now from anywhere else in the kernel
>>> where we don't build as a module :)
>>>
>>> Apparently we export a similar function in rust where we just removed the last parameter.
>>
>> To clarify, said Rust function gets inlined into Rust Binder, so Rust
>> Binder calls the zap_page_range_single() symbol directly.
> 
> Presumably only for things compiled into the kernel right?

Could Rust just use zap_vma_ptes() or does it want to zap things in VMAs 
that are not VM_PFNMAP?

-- 
Cheers,

David


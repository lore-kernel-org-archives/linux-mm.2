Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40045D29FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F3E6B00A5; Wed, 14 Jan 2026 07:41:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCDC6B00A6; Wed, 14 Jan 2026 07:41:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE6A6B00A7; Wed, 14 Jan 2026 07:41:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79BC46B00A5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F20991604BF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:41:47 +0000 (UTC)
X-FDA: 84330531054.05.B2DFEC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 33CB0140008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:41:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q8LHkD8/";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdZdjYIW2p1fIMYYZHfKbd2QOLQDQmRWwSWrD6ijEsc=;
	b=aoJK2KCL+L5zY1a0ehK6uYbBxpXCinifByAjL45vWAdetkz6fRNjR3LG5J5Zb5YJrWUNEs
	rutnCp8PpZZmGtckS9pFJMbJF94m/wHhh47+4H2Oi4CrnoXx5Bz2XQFoWdPpteg149Ku+j
	6dD9l/heHV5pJ+nrN77wTlO9n42Vjew=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q8LHkD8/";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394506; a=rsa-sha256;
	cv=none;
	b=0lpHw5EuCGZupENbRgT85oSpeGsTZh+lWyKYumTWxTLBffW5+Mf7x3jJ8u8WiKDfZUoRhu
	od3LGtADcZOaC656IhpFiz6hf517wlWXlBH5CqPgyblD7A9+XRnYmOBOt1p/DAcnqUkak2
	84xHeqf0WEP9/8W7qLESg1dNORRYXRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97B4960121;
	Wed, 14 Jan 2026 12:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61030C4CEF7;
	Wed, 14 Jan 2026 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768394505;
	bh=JwZI01KEkeAbq/F5CtxNA2KXP372EI6k8cykcrWJRS4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Q8LHkD8/pkeUy7tSQ8FtNurSnSf31sqSIMXPeJCQROif9hrZjWnTCPCvP19kd7R0a
	 kaYDzAXMkbnVULpmubYOny7/R5eD6lnEf1pRHFrrjAdW7k88mMlhnzh7QEsi6G2ZNS
	 cGavenQ5cbd1xh8eT2YTxPg33A/LDRJN49JOzoCNwrtSIEkqzOL5UXv8vwQ2jJ3r6e
	 FVjWzeHV59KthJnX0PS+16YZdYSLvT0z2ZH129TE6rnGdFTVk1UBrB2kSfyO0WG6b8
	 w7W2t2uHIqfC2gh6HOUrnnOf98LUhpdkdyTcv6xrYOf81tzoIyeXti4QdopEWyasD3
	 Q2lKJrtZpDRJA==
Message-ID: <1edfe356-8334-42d2-9d68-7c5bf21a01db@kernel.org>
Date: Wed, 14 Jan 2026 13:41:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com>
 <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
 <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
 <d9fbc00d-182b-4463-b718-73c2f0eef3a0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <d9fbc00d-182b-4463-b718-73c2f0eef3a0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33CB0140008
X-Stat-Signature: ibamim4z54cspad9juot5568ihhu9aoh
X-HE-Tag: 1768394506-720821
X-HE-Meta: U2FsdGVkX18WnoThoHfdOn1O/JJDoafG0lSOoMw+02Wo/V8e5y1jTZb+8PCx2SYtJYf+zjOMIl3TXf2R5u/hwix0Q524346u9xnEM6MeFKprQJ5f/y4jyE03pn9lfKPv4BxiXSxrcdSMqEof9wajxd7tCN4zMwJ2726Re0gDZZahhFDjBOL+u6rCgS9UGtshGd1Vl0UPJoBJgcsPmQ+8IDXX8QfSmScnmvam7J/jnO65Td+vmmfomZi1E28Cs5nNpBTDH3Le6WgfpOIv0VRCyJF2Nqs3uskD4EAyzPee88zDzuqmGQepVkYXuK2MG/FxQEuvGOxVerfDiO2ai7ACs6hyCW2qJak6U3YZQeSNJ1sRjbYsAE2sDFFvQlG+T8ilzhpqV9EGocggOjnRf7urhS7LcTcIQE5SGNrWZEmnwM7OQkZ+JsM6laLyutsh/dQ/Z1DjyHPvSAzMYa53Zbd+5fuWsMvuGA1hzcox+s5Zj4RP5oyZqfwrJ957b6dai8X0+1Ga50Ixhdux178Je459IzYhU8S8KdWEKUPoAbJCXS/NTre05ORi3gfQ1W8h53wKsbUWxlJbzCX20qmmkEPG1xqzBThYlnWZUOUz52/neAPV2ReePfJH4oIGWKNBJs3kb1m09kriA/z3U05wteZ6LTDBPdkO6/Le9wCeHtjr9hW/7u7Sm5VMyUQeezkZqiiJEzyx8NkR6EfL3nQHvfFDp1Dr3v8sR92vbvKwpuu8Vm2d60rIKseui4N/RWj1c9kFjdL2xlfJmxmybzqrbtLLxSjRQHxkfKOgsRRf3LCvks4jUp8Xzecr3AnLIF1eMBqDfJ0jIdtxwPuIFWlWeZzOkSg/iJuwg7/vUANYlCiN6XVs5KF7d/sTAI3NUoprMjnHhvcflFjXLP6UWUgqUceBRLLBC+dqc2QwonSWrjXuhi/JysvzWY9ktdcGY67L+cfhbYP1dbR6aU33qR8VcsJ
 o0G6ZHni
 locV7NXWzEYM+IQKk8Y/EqoXKL1zAshJ1GQaeuTP5egaRRUIM8kqctOhHdu8Oo+heaVDtMoTclaYPBIVoR4r93VLCxWJHXSm8++L5+32AzOYBFfrLFE5Hde3nbhsAdwtHT6SNO+Sm/ut4sfT3j7oTYWld+4KuhnhwaTuTBxqPuGgtl/0AML5G+h7tyBAOrJHavfiA/7Zc6aZcCB+LEzoy5fN8WDVWAH16gUZUxFNC2yT9D2PtdfHmvDJQ7B0T6ipPqNzBALNaNlTCaUlEwAKTzYh+DphGCQ/C25HuWRkDqdI7/fzyjgiUqiNYBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 13:33, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 13:11, Mateusz Guzik wrote:
>> On Wed, Jan 14, 2026 at 12:55 PM David Hildenbrand (Red Hat)
>> <david@kernel.org> wrote:
>>> You said "I wonder if implementing hugepage pre-zeroing directly within
>>> the kernel would be a simpler and more direct way to accelerate VM
>>> creation".
>>>
>>> And I agree. But to make that fly (no user space polling interface), I
>>> was wondering whether we could do it like "init_on_free" and let whoever
>>> frees a hugetlb folio just reinitialize it with 0.
>>>
>>> No kernel thread, no user space thread involved.
>>>
>>
>> i don't see how this is supposed to address the stated problem of
>> zeroing being incredibly expensive.
> 
> The price of zeroing has to be paid somewhere.
> 
> Currently it's done at allocation time, we could move it to freeing time.
> 
> That would make application startup faster and application shutdown slower.
> 
> And we're aware that application shutdown can be expensive, which is why
> e.g., QEMU implements an async shutdown operation, where the MM gets
> torn down from another process.

Also, just to mention it, assuming a VM is backed by a hugetlb file, the 
user space thread destroying that file (or parts of it by punshing holes 
and freeing hugetlb folios) would be paying that price.

That could be done whenever there is a CPU to spare to perform some freeing.

But again, I think the main motivation here is "increase application 
startup", not optimize that the zeroing happens at specific points in 
time during system operation (e.g., when idle etc).

-- 
Cheers

David


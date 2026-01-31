Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F87E7C6EC
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 21:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAC66B0005; Sat, 31 Jan 2026 16:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87A56B0088; Sat, 31 Jan 2026 16:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93EB6B008A; Sat, 31 Jan 2026 16:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9531D6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:31:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDC66BA018
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:31:25 +0000 (UTC)
X-FDA: 84393555330.16.77B45F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5EE47180005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:31:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBFb3XMi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769895084; a=rsa-sha256;
	cv=none;
	b=XRx5nV+TMwlpIGUMSO+vfO9NcNfFON9/XakFAGxE7XOlfYuOmDFRbnK7NkehWnlbowIcfK
	KY1c5jes7akz6/nZWoUBrPWBKkZIgWW9cAfPVnjSfnXANWLjviuvV7C9lkyeIDq2TLgrLI
	DRxJ77WsX9m/ogNKh5IoGYANHl4Db3U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBFb3XMi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769895084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rW9GLjLpKLue5JwGniSpSvStYQRe51vQoxuzZCwTYDo=;
	b=dRwZ0mBMCujHzpp02aZlHSGlbLcv4JO8+aYmWwe9rUPY3OvtvEGOVGEyedUMw40CAikfJv
	53AgrF0SF4GoSTiZMq8yOe1lzfClgKfVl2tIOcSjKY0Y09Eiw5FbZnk1NSoKRja4i/irC4
	ah6vwlWQee1ySjavUS1cuDKZnlCTGGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A39E6020D;
	Sat, 31 Jan 2026 21:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30075C4CEF1;
	Sat, 31 Jan 2026 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769895083;
	bh=rW9GLjLpKLue5JwGniSpSvStYQRe51vQoxuzZCwTYDo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mBFb3XMiuKTBm5bOqI1UNyF2Q4bxGK6HJTHWCKWGtg8yqJRYmiYpiS3i5HxL5bRmW
	 fQo4xiCRLRyNnquu1AZxkZ2pVfZ9S1hnK3JIFg+bKTeTR5JiAjsevC/1ZSSDfGwjde
	 1I6oEpmhJo1cG4bvVF9q3hsRDliCyWbcQPg9AKssKO5h5CjoT4RfYREVVf8Bhk75yN
	 c3acd81rH1xIP02WejcH3G8Kn8mrTJ3pNvUluqSOSogzn6viIiIFqOGc5uWINt+Uj8
	 +UTJ+Azwzw2Xqjgf/58a5SxcZ78JyHbezRA4jWdEp+9FGhUTkrfGZ+RKSuQSIBYmwC
	 lw7vOmZkWT0tg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
References: <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
 <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
Date: Sat, 31 Jan 2026 22:31:13 +0100
Message-ID: <878qddqxjy.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5EE47180005
X-Stat-Signature: 5jb6dxmdre65k1aqjiq4zo9mb1hdwmfi
X-HE-Tag: 1769895084-791381
X-HE-Meta: U2FsdGVkX18JG6ZP0+Lz4HoxnQwc8JtNQs9a6Vo/V4qjhroyVFSB8i/48EMrXa0A0Kp6D6q00ihxl3PsSdFytS3t17lVO9n/xcLG8NSjluGhQOj3J+r/9A13oAtmvbkT+/i19MLHonrP0Kq/EY8VBHqBsCzRv9XMIxOiVBEatcWe8LJjbCYu+opT2gyrpc397OjclexzVJ/f0xjIydkJwRuWre5Cfoa6ZpTYSUVTnTWQaM7s/ZmEy6HzyKciTngCJS6dhWBkZhJHVHg9x+AKk7MxskJQgeg5hFcZ2YUPVFccTuBoypJ8f30P0Ui+Sa1dpdc3lhaKtmssSZFwegZzXbKiqOTL2o2qiNOxQy7NgPN9phrhFd/UYZJy1OVGpQmCjQEWrBgAVbdfWeGjnZyFCo+vPlynNvEkS9h1LPPcEkwq4iTEWKJ14eGmDnwJhpDq6NrHVVlyW0dF+UFTKmPFFbVcuTnu9wBobb3l6Ms4s60/Ky0NuChnGYayYzecP3CSyQuFGCDBafMI7gpn/5n3FP0gwcD6ZITuznhtH17gd4q7nHxIjziOMuZyfwM838xachjFgEPj9+M3tqsrDM7KEb97wdPCQ3IK6/svp6AZYIEWGXTkHiFW7T5BEoZUTtONLOTJKFljxirKa1cVB722DAVNiSUHsVLx22OxprikOq81r8LGFtgngBwRdSAb/vizhzhxboth77SVjneF2aZHYtbWsXpZTvt/FyYLJt6iG+hvBrAe6ciVLc68weUfBGu+VnpCEg9jcsXyLr2DBsn+D5Iga3gDbmyANpxDLdq5ene3QB6C4TVzaoNxGlgR7iFu4q7qwXJPnuvNAmw6qd0pwiH93iWL0oUwflrKSjFS9lN4nF/12/aEMR89TvLQ6WIkc8tBdtmoExr3Hp10PBRLdAKlzti3YFyQkQSz/Mlm3+SjJHdV6XYKHPlp0+E4HTu8J9i42Dgo4a36+CkYVNU
 fl2hw9Db
 KrGzKgfXLbIcMtWRjR3gDXyBf5sKnv11dgx03+j6Bdx7XQN403NPm667eBUbvdK2LM/w9K7H/nX1TC9iXqU/0qNndtL96mbQqPHpVN/EkTuRKPVgNla/56NxHMPxI8vUpRupR0+vGd0k8CxbH/ZJlbBzbjFBG5mN1W8fLSxyYcCusg00ux/cQO3X/XsieZHVncnrt7b4gYcgAJLPFaxUhxCXjj8icXHJEne+WfP5L9Pr0qIWeX4cdlKZtByw2LnuTz2yyladV/8s8/AVcIQJGVapQKub3p+0N7ek7N0d9z3FlXHtZHua9uvLPAsYY8CzV+PaC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Hindborg <a.hindborg@kernel.org> writes:

> "Gary Guo" <gary@garyguo.net> writes:
>
>> On Sat Jan 31, 2026 at 1:34 PM GMT, Andreas Hindborg wrote:
>>> "Boqun Feng" <boqun@kernel.org> writes:
>>>
>>>> On Fri, Jan 30, 2026 at 01:41:05PM -0800, Boqun Feng wrote:
>>>>> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
>>>>> [...]
>>>>> > >> In the last discussions we had on this, the conclusion was to use
>>>>> > >> `volatile_copy_memory` whenever that is available, or write a volatile
>>>>> > >> copy function in assembly.
>>>>> > >>
>>>>> > >> Using memcpy_{from,to}io is the latter solution. These functions are
>>>>> > >> simply volatile memcpy implemented in assembly.
>>>>> > >>
>>>>> > >> There is nothing special about MMIO. These functions are name as they
>>>>> > >> are because they are useful for MMIO.
>>>>> > >
>>>>> > > No. MMIO are really special. A few architectures require them to be accessed
>>>>> > > completely differently compared to normal memory. We also have things like
>>>>> > > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
>>>>> > > readb to perform access on the __iomem pointer. They should not be mixed with
>>>>> > > normal memory. They must be treated as if they're from a completely separate
>>>>> > > address space.
>>>>> > >
>>>>> > > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
>>>>> > > different types of barriers needed to order things correctly for each type of
>>>>> > > memory region.
>>>>> > >
>>>>> > > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
>>>>> > > the least special one out of these. They could practically share all atomic infra
>>>>> > > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
>>>>> >
>>>>> > I see. I did not consider this.
>>>>> >
>>>>> > At any rate, I still don't understand why I need an atomic copy function, or why I
>>>>> > need a byte-wise copy function. A volatile copy function should be fine, no?
>>>>> >
>>>>>
>>>>> but memcpy_{from,to}io() are not just volatile copy functions, they have
>>>>> additional side effects for MMIO ;-)
>>>>>
>>>>
>>>> For example, powerpc's memcpy_fromio() has eioio() in it, which we don't
>>>> need for normal (user -> kernel) memory copy.
>>>
>>> Ok, I see. Thanks for explaining. I was only looking at the x86
>>> implementation, which is of course not enough.
>>>
>>>>
>>>>> > And what is the exact problem in using memcpy_{from,to}io. Looking at
>>>>
>>>> I think the main problem of using memcpy_{from,to}io here is not that
>>>> they are not volatile memcpy (they might be), but it's because we
>>>> wouldn't use them for the same thing in C, because they are designed for
>>>> memory copying between MMIO and kernel memory (RAM).
>>>>
>>>> For MMIO, as Gary mentioned, because they are different than the normal
>>>> memory, special instructions or extra barriers are needed.
>>>
>>> I see, I was not aware.
>>>
>>>>
>>>> For DMA memory, it can be almost treated as external normal memory,
>>>> however, different archictures/systems/platforms may have different
>>>> requirement regarding cache coherent between CPU and devices, specially
>>>> mapping or special instructions may be needed.
>>>
>>> Cache flushing and barriers, got it.
>>>
>>>>
>>>> For __user memory, because kernel is only given a userspace address, and
>>>> userspace can lie or unmap the address while kernel accessing it,
>>>> copy_{from,to}_user() is needed to handle page faults.
>>>
>>> Just to clarify, for my use case, the page is already mapped to kernel
>>> space, and it is guaranteed to be mapped for the duration of the call
>>> where I do the copy. Also, it _may_ be a user page, but it might not
>>> always be the case.
>>
>> In that case you should also assume there might be other kernel-space users.
>> Byte-wise atomic memcpy would be best tool.
>
> Other concurrent kernel readers/writers would be a kernel bug in my use
> case. We could add this to the safety requirements.
>

Actually, one case just crossed my mind. I think nothing will prevent a
user space process from concurrently submitting multiple reads to the
same user page. It would not make sense, but it can be done.

If the reads are issued to different null block devices, the null block
driver might concurrently write the user page when servicing each IO
request concurrently.

The same situation would happen in real block device drivers, except the
writes would be done by dma engines rather than kernel threads.


Best regards,
Andreas Hindborg




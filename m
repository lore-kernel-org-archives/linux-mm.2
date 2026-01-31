Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2118D79767
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 13:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193246B0005; Sat, 31 Jan 2026 08:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1413E6B0088; Sat, 31 Jan 2026 08:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CBA6B008A; Sat, 31 Jan 2026 08:34:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E96866B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 08:34:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90B401406F3
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:34:13 +0000 (UTC)
X-FDA: 84392352786.21.EA50CEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB92518000D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:34:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CmiDtb2b;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769866452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSALxL5+MFk5Sj9+OTgyZflH86KfchG0tfgD4nghV9o=;
	b=REiG5eIIf/HrkD5gZOukKcKF295YmuowcEane0/7finm4Az9IiryvqWHApgBwSmMbhNPmv
	CgdBWy2S0pgf6Q1xzfUFnMJrvkXjEwh5+Fow3K+vqB49CLzteMZxj/Y3BR00m8JYQ8B/x8
	N9k+LqtGqmv0kMAlEBhxdlOgaykwW1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769866452; a=rsa-sha256;
	cv=none;
	b=XW6ttN3s4KenCie58EADwTrTVpDKlFaeXopIUyHwweoZgttpvMVPww6fwk9OoqcvvkU28l
	otf3wUI8iQ5rBTrCVvDxhSwOXsszrRV54Tog9zzafMHRqz2wG41/mAVy+YNVT1K35PDGED
	5dVLCvOR7n3bUGCTHlYEviQGiIHt24s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CmiDtb2b;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFB2A443AC;
	Sat, 31 Jan 2026 13:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9EBC4CEF1;
	Sat, 31 Jan 2026 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769866450;
	bh=OSALxL5+MFk5Sj9+OTgyZflH86KfchG0tfgD4nghV9o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CmiDtb2bRU0cdHgidAIfD3SQmhVHJXWiIMRTu8RVPlXgzcSU47b11OFJYfX+EhFov
	 2HycDkjTxGWdkXRYZt0i5GwgeNvRDgm4lll9IZtH41A5Jxx1nlud6hPMJ9SXQbk0Nv
	 c6Mf0wYakAvmTRR3h8GwwEzxzj5x8EobRQajzXHo8wykxY+N6M5iMeX9UIQzBt6Jho
	 RCEmQt8ccIx0HfHvHsqQ6VXbgdkBhaB8J0Z1TQbJH+rSQ4jK5yrnzvKJbD4jKUMwuP
	 DMFkG4py0t7xx2laHrS+2o+0JVaZk8ip3uW4qyz3m/0rN1Zd+1ZA9A5lYjfLbEI7VK
	 7rIDzrBrGoM4Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
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
In-Reply-To: <aX2tyn9nBUEKM-SN@tardis.local>
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
Date: Sat, 31 Jan 2026 14:34:02 +0100
Message-ID: <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: DB92518000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6hyhffgksx9xu31e8z61kqr45mhrzz3j
X-HE-Tag: 1769866451-140245
X-HE-Meta: U2FsdGVkX1+IYKjg6sOatoM6LJagiu21on4htxnL/XJ2Y+3t1yDzJppfOZkJil0CGyydz21v6zC6A8oXXbKQrfbF9gN9mt3bPsdSi4A0pfZcaShBKuy9flTojinJPpKZ6nNP3gESA4N97mTe+dhD+fBJ2F+e58f+g19v1N/pCHnzOjYPB3zoTACsxzrzQQUz/3M03IpYbLASpgsaOF7xxmOt/zfpOQnczaQcpnKBokZqrvQCusAWe1o/GloNZv6bpaX9UzKbX8qhTMo7RebyeXNRLfxPtiR6hlVwKRknN4KoYFPQCVsI0LNP4v94VGkT9BTMy29x7SKWejwTdb+y1PkB3E1PNCnxoF7Ehp0jmqC/qXb6htg8uMB+IFkjMXdkt0nW3ln0jJmRWbSzmGrimgNYyM561jJO9vcyQDEZePhBC/6ivZdRGNVCFnZ+fkCpDbENI3Z09m2QXTg1wLnJBIku+fvlUL7G5WQYJnWPpVq0FQ8rig3/XI6VR6X4G1oF+n1FvSKcOnLI5iHYSpT02ysNvL2AcQgzukR9B2fwU6PdPLL+Mi66/nN5ChcBTdNPkx4kwkKkW6HMyCXvar3eRuMeg/H4SdU4j9D0LQeH/WhSz/Ct9COolPIKP42+z6cuAaHYJdBF8HecJsa/NWDZY0z8NSFvupJEiMK1Km7kNMXLDMBV/HSR93H6RJwlPuP8NFzRGCqcN/V+tcEpNdO510COT/Db1x2mI8rcricIg5SN2SeXSxbTRUrYsfFSijq4ph/f4cDMIc/4+ows+SCK5MDL44Jz6q6AbAFi9cazVgI8fKgj0tG+/20aye/Rg8cAh+arFPpuT53uEaZYlSMupEleJqvhKE+GYvabiS+LDDEsHA5MIpS8tYq0gVp6fQQ5sAmQuI5oZ+lhHWVzOY4W7ReHhAKKaV+pDPv+SvyxWle3GdYk8GkQCYr9pf6SD8UWwnDKj+6IAbyCY8OmB39
 fVJAcyHR
 8zsdF3razJeco+ZWZb4K4wHIRzeATZoaYbFAT+1fEQL3KqSJdGrsqdRIfRJo5UwR9lLmn/H0gFkCPmVfLFlL+pGLuhdj4C9NgQG8+wEQTSbjkkCYv9w0Sj0wMha3iNmeK0FIM7Db3woAqUDnzInRksPyJ8zn/P0JtEhhTcp8oISHdO8Jt9loYcSOmVl5XEdtW5LkJtAUGExU9MuLokQDzc8QH1uh7GACo7EBr2QuIU29dkSqZYmNi//oTxj7cacyYBgFo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Fri, Jan 30, 2026 at 01:41:05PM -0800, Boqun Feng wrote:
>> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
>> [...]
>> > >> In the last discussions we had on this, the conclusion was to use
>> > >> `volatile_copy_memory` whenever that is available, or write a volatile
>> > >> copy function in assembly.
>> > >>
>> > >> Using memcpy_{from,to}io is the latter solution. These functions are
>> > >> simply volatile memcpy implemented in assembly.
>> > >>
>> > >> There is nothing special about MMIO. These functions are name as they
>> > >> are because they are useful for MMIO.
>> > >
>> > > No. MMIO are really special. A few architectures require them to be accessed
>> > > completely differently compared to normal memory. We also have things like
>> > > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
>> > > readb to perform access on the __iomem pointer. They should not be mixed with
>> > > normal memory. They must be treated as if they're from a completely separate
>> > > address space.
>> > >
>> > > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
>> > > different types of barriers needed to order things correctly for each type of
>> > > memory region.
>> > >
>> > > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
>> > > the least special one out of these. They could practically share all atomic infra
>> > > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
>> >
>> > I see. I did not consider this.
>> >
>> > At any rate, I still don't understand why I need an atomic copy function, or why I
>> > need a byte-wise copy function. A volatile copy function should be fine, no?
>> >
>>
>> but memcpy_{from,to}io() are not just volatile copy functions, they have
>> additional side effects for MMIO ;-)
>>
>
> For example, powerpc's memcpy_fromio() has eioio() in it, which we don't
> need for normal (user -> kernel) memory copy.

Ok, I see. Thanks for explaining. I was only looking at the x86
implementation, which is of course not enough.

>
>> > And what is the exact problem in using memcpy_{from,to}io. Looking at
>
> I think the main problem of using memcpy_{from,to}io here is not that
> they are not volatile memcpy (they might be), but it's because we
> wouldn't use them for the same thing in C, because they are designed for
> memory copying between MMIO and kernel memory (RAM).
>
> For MMIO, as Gary mentioned, because they are different than the normal
> memory, special instructions or extra barriers are needed.

I see, I was not aware.

>
> For DMA memory, it can be almost treated as external normal memory,
> however, different archictures/systems/platforms may have different
> requirement regarding cache coherent between CPU and devices, specially
> mapping or special instructions may be needed.

Cache flushing and barriers, got it.

>
> For __user memory, because kernel is only given a userspace address, and
> userspace can lie or unmap the address while kernel accessing it,
> copy_{from,to}_user() is needed to handle page faults.

Just to clarify, for my use case, the page is already mapped to kernel
space, and it is guaranteed to be mapped for the duration of the call
where I do the copy. Also, it _may_ be a user page, but it might not
always be the case.

>
> Your use case (copying between userspace-mapped memory and kernel
> memory) is, as Gary said, the least special here. So using
> memcpy_{from,to}io() would be overkill and probably misleading.

Ok, I understand.

> I
> suggest we use `{read,write}_volatile()` (unless I'm missing something
> subtle of course), however `{read,write}_volatile()` only works on Sized
> types,

We can copy as u8? Or would it be more efficient to copy as a larger size?

You suggested atomic in the other email, did you abandon that idea?

> so we may have to use `bindings::memcpy()` or
> core::intrinsics::volatile_copy_memory() [1]

I was looking at this one, but it is unstable behind `core_intrinsics`.
I was uncertain about pulling in additional unstable features. This is
why I was looking for something in the C kernel to use.

I think `bindings::memcpy` is not guaranteed to be implemented as inline
assembly, so it may not have volatile semantics?


Best regards,
Andreas Hindborg





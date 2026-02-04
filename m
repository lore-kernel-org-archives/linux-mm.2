Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B917E95396
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2436B00A9; Wed,  4 Feb 2026 08:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A3F6B00AA; Wed,  4 Feb 2026 08:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689136B00AC; Wed,  4 Feb 2026 08:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 571966B00A9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:16:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC9C31BFB1
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:16:49 +0000 (UTC)
X-FDA: 84406824138.15.49CEF1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6165CC000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:16:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TLqvIPTg;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770211008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjrOFWSPNYyipT5loTZH36ibiLYoeTCKGJiud/B8xVE=;
	b=tqciFRJ8nlSLM7pXgTAzwKj14BHkPslA1Woq5a5QUL4E4zh+Kku5N9CrhXXlLdSQFJZdVD
	6mk6jqn/r0H+pXoXYGYWTm09t5NC9had8imklhOeOr51g51HthEvhGkYh+l+riv9Ta3B5g
	B+nBKRQkLds/bstQLWI153TtBQinNJQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TLqvIPTg;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770211008; a=rsa-sha256;
	cv=none;
	b=L7+D8gmyYJxB1zd+YpWFcqv7haMaYr4aYs/EjTA2tWeLfPZhcY0XV6C11mrQmgehWDRYzO
	sYEjwzqxE8xiv6fOABpLsHX4YrPzYlVcZgJ+4cbTPaUHCqXu27M40aZUHMKx2H8ArDNVg5
	HdYcudWQLVGsWqkTyCQG1l0gF+6dZRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9133660133;
	Wed,  4 Feb 2026 13:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04119C4CEF7;
	Wed,  4 Feb 2026 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770211007;
	bh=U65dLrebsUvHoLgUboK8QjnppPopUTT702V9iDjRq/c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TLqvIPTgXEv96WN+eCtentVGfATIvpIxujtjtrndQR2J+tWvrud6Umx5DXM34Yayr
	 APy5tjLiHooNJekVXn/XywSjycdheJleK9/di4M3bvG7Y+c91Z4Qmn7JbpryGZxq5m
	 PkbZfo9W2TWBDD2Hlm5V1Q+pvYXeCxdT5q2MhJvIPE8l3GdGTmAt8F91npen3QYRl8
	 OFOw9nClvoCRBTgRGnbTTdlfSXfYiMbJzQi0F6Id2BFVNV9wSfPxenVPrc7SxqTHZ8
	 jCRuPVt9mnUjvkbMNcUtLO0z5LtVAsrnaWN6+BG/ViTAp3N2RfqhfpEjUU5G0ysVvc
	 zJ1Wu6ydxLkNw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <aYFKbWfQmTInYy91@tardis.local>
References: <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
 <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
 <878qddqxjy.fsf@t14s.mail-host-address-is-not-set>
 <aYFKbWfQmTInYy91@tardis.local>
Date: Wed, 04 Feb 2026 14:16:37 +0100
Message-ID: <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6165CC000D
X-Stat-Signature: gpbsuoemoryb1sm8doqtkofztdfm8pdr
X-Rspam-User: 
X-HE-Tag: 1770211008-926822
X-HE-Meta: U2FsdGVkX1+IyHN08twL3B5UsChSK0+Wtm+zECpKoxbYmEyyBDZA9M6E+tIpsX0nyo3D7Qifh8Vz/dG8OmL1de2fld0eva+DNSCoKVOLCPBm5GjjESjWWRm7vIy8AzpEo2jNlzGYQF/MhxAHzW6KJxr/Ke0Nny0CxvY9TmFwhN1qXO60phhDSjrsQO7sbgOzokTBcxaZnk0mmffnrnjsGFRfMYJbmA5fApYEKbE7YvyHhyIA9lu3D+kZpCRyyXl8SlM7zDu2hDZCD5VwsDzlYMbep6llWIgmuiRYnyezSU0xwGFvENUoNh5zTxODJDiOtlK5KQOpjX2v4fwUyz5VHy+LLisD6Q1W7EF7ovPJkvkhxyz0CYjvs0HbaytVAvRDqXZ92mGzhuJyl/BHTSw8FdDUSpAjihLsAuFahoK6B8fQeKnGvNad2XfEs7cAvfnWl0tEAhhA4XX2Gq/xoA18BHd7+wCctUQCExcpHFEhTIBa7hVQIryDgoTPmEG0hPvpxU+HYqxavoXu+mQZn5ejE3kpWosv26iN4Yh2nz4N1n/m3tP8U6LVeeePd6FrEvbEXZJLGKtKVzMxKX2RYxkISYffsQUc6bIHHkubMCijI1lU38acs3dFPQkaCMjFafsx+FFxxihQHnHkn/B0ZAhis6sF4V1SP3DwiRa07UrNt/ykKRD3IzcKLuw4vJkoGILWgU6m5H7f8BCUMPPPmN4S2edTW/60mHYB+ezZiOx1oswnjmdPIhV/ZMSPg2rgV1ZeC2TUj0/5Tw0vt4vV8xtiiPP2aJ2u9/62zg2GRog/iMIrfwcfDR3QCLYNmvFJsfIm3Skse2YM52hW4gqeiB9mNLUPo3fcKuT+YSgucMSj8b0Em0kOJkJRHuxVRfLL7AYDUD/PlpdTc3jLTRWmTrcYP4qXog6AiwYhJUeyhENiR+EzPHRxHbxoyZHwVpXdfkU3HylpTfHHC/setvMI2yS
 Y1r6tKYh
 QfsAW77hVf+Qcx4x03bfv/QXqNQT1zEL2EguPRieMfivOdmX8Wu9Yy1ViHBkuwQMIOsIJi1/8TVVqtYZgvda3Jb/na6YMSx5d4O7huMUfvMM0Tb1ZQcOr9+5+Czgld66jB0/jAbgNc+eliOolcxN7p7QFF5WHspHpTu1QtraCRuVcJli0As5a28uKnNM0bFk1NAKY2JZmvIYhqceAsRn0aHxCJYotI8TXhbCTjk8U1kl7ay8NdMG4NqAUS1x4rJC4E8HP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Boqun Feng <boqun@kernel.org> writes:

> On Sat, Jan 31, 2026 at 10:31:13PM +0100, Andreas Hindborg wrote:
> [...]
>> >>>>
>> >>>> For __user memory, because kernel is only given a userspace address, and
>> >>>> userspace can lie or unmap the address while kernel accessing it,
>> >>>> copy_{from,to}_user() is needed to handle page faults.
>> >>>
>> >>> Just to clarify, for my use case, the page is already mapped to kernel
>> >>> space, and it is guaranteed to be mapped for the duration of the call
>> >>> where I do the copy. Also, it _may_ be a user page, but it might not
>> >>> always be the case.
>> >>
>> >> In that case you should also assume there might be other kernel-space users.
>> >> Byte-wise atomic memcpy would be best tool.
>> >
>> > Other concurrent kernel readers/writers would be a kernel bug in my use
>> > case. We could add this to the safety requirements.
>> >
>> 
>> Actually, one case just crossed my mind. I think nothing will prevent a
>> user space process from concurrently submitting multiple reads to the
>> same user page. It would not make sense, but it can be done.
>> 
>> If the reads are issued to different null block devices, the null block
>> driver might concurrently write the user page when servicing each IO
>> request concurrently.
>> 
>> The same situation would happen in real block device drivers, except the
>> writes would be done by dma engines rather than kernel threads.
>> 
>
> Then we better use byte-wise atomic memcpy, and I think for all the
> architectures that Linux kernel support, memcpy() is in fact byte-wise
> atomic if it's volatile. Because down the actual instructions, either a
> byte-size read/write is used, or a larger-size read/write is used but
> they are guaranteed to be byte-wise atomic even for unaligned read or
> write. So "volatile memcpy" and "volatile byte-wise atomic memcpy" have
> the same implementation.
>
> (The C++ paper [1] also says: "In fact, we expect that existing assembly
> memcpy implementations will suffice when suffixed with the required
> fence.")
>
> So to make thing move forward, do you mind to introduce a
> `atomic_per_byte_memcpy()` in rust::sync::atomic based on
> bindings::memcpy(), and cc linux-arch and all the archs that support
> Rust for some confirmation? Thanks!

There is a few things I do not fully understand:

 - Does the operation need to be both atomic and volatile, or is atomic enough on its
   own (why)?
 - The article you reference has separate `atomic_load_per_byte_memcpy`
   and `atomic_store_per_byte_memcpy` that allows inserting an acquire
   fence before the load and a release fence after the store. Do we not
   need that?
 - It is unclear to me how to formulate the safety requirements for
   `atomic_per_byte_memcpy`. In this series, one end of the operation is
   the potential racy area. For `atomic_per_byte_memcpy` it could be
   either end (or both?). Do we even mention an area being "outside the
   Rust AM"?

First attempt below. I am quite uncertain about this. I feel like we
have two things going on: Potential races with other kernel threads,
which we solve by saying all accesses are byte-wise atomic, and reaces
with user space processes, which we solve with volatile semantics?

Should the functin name be `volatile_atomic_per_byte_memcpy`?

/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
///
/// This copy operation is volatile.
///
/// # Safety
///
/// Callers must ensure that:
///
/// * The source memory region is readable and reading from the region will not trap.
/// * The destination memory region is writable and writing to the region will not trap.
/// * No references exist to the source or destination regions.
/// * If the source or destination region is within the Rust AM, any concurrent reads or writes to
///   source or destination memory regions by the Rust AM must use byte-wise atomic operations.
pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
    // SAFETY: By the safety requirements of this function, the following operation will not:
    //  - Trap.
    //  - Invalidate any reference invariants.
    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
    //    operation and all operations by the Rust AM use byte-wise atomic semantics.
    //
    //  Further, as `bindings::memcpy` is a volatile operation, the operation will not race with any
    //  read or write operation to the source or destination area if the area can be considered to
    //  be outside the Rust AM.
    unsafe { bindings::memcpy(dst.cast::<kernel::ffi::c_void>(), src.cast::<kernel::ffi::c_void>(), len) };
}


Best regards,
Andreas Hindborg




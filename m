Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99DFE9D3FB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36916B0089; Wed,  4 Feb 2026 10:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE48A6B0092; Wed,  4 Feb 2026 10:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3776B0098; Wed,  4 Feb 2026 10:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCA736B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:58:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59F83573D8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:58:29 +0000 (UTC)
X-FDA: 84407231538.20.18A84D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B201D4000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:58:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAPPMSnp;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770220707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCJU+AlCdD98kZf6091TTf2MpaC/MEZRasFgyPw0G40=;
	b=NSp31qV+HVmHSXPCG/+XJWmv7ZPEJrCUDjqVPXUKNn5kPp/ICmBQ3k+uVWc74i7lAR8sMw
	MRrc/PJnbAvF5QptfFJDKdUVR/Uh7MHIlXBauEkWDqwmrlrwhs0eHo49NQ5kk3OY9EbErn
	hdPeSyGhlIng84QGtPTtcbi4SvEJJYw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAPPMSnp;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770220707; a=rsa-sha256;
	cv=none;
	b=PQFs+AqjnQn0CAf8SQrcVw6gu0W608h2qCdWHq2WWWmR0LZjMuVia6D57mI288zD1XsiSQ
	nPG5FOahfMLDBTMYGHBY5I2QlsfE6Qcgb5ihGKdekM2rv+zS0cxedra80Q7wzmuB2xusq6
	jHtyTRXZqYGLcFOwLZrrZS85Nc7hT9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6AAF43F03;
	Wed,  4 Feb 2026 15:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B13C4CEF7;
	Wed,  4 Feb 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770220706;
	bh=3bUz2AaZf5udaWQISdBQH/xVAmAdhsGVcK8NDcYpos8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OAPPMSnp2yeeCopj0oweHQxNJWIJrec4WzMqF8B3zJgb3lS7G+RTrpcHbqMkmK8c+
	 7Ci/YU1Wnd7WYm/c4der193cO64OzJqSlJpMLNaGcA58bWnPbhWCXIq/u7TJ9GI695
	 XKHGxGW/o8drcDO68GDrdtXE2uGxxpyPbIh1eCOfyIsgAsD2PgsopugGvHwLiYe2wD
	 WwdCv9zs9HLEW6c3BCB8PUxqasxgii8YkqwPEVKzJOtN8bC8DP6eM0F63zc4UHNnJn
	 8YLPkrjQjP5m1j/KB/OYaRm2VjFFo64D+EzIImDYO/3/Y3VvAg0O7OiPGI0NwZ3bdq
	 rHH+8NWhh/Y1Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <aYNOLt_kj6buuhH9@google.com>
References: <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
 <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
 <878qddqxjy.fsf@t14s.mail-host-address-is-not-set>
 <aYFKbWfQmTInYy91@tardis.local>
 <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
 <6QJArRFFMpiUrEi-zRSP4gEUGBGzGiajuJusY3rvLVeNC63eAefWPrDVPQbZnKRwV0PSTG3DrLdobBa4YUm1HQ==@protonmail.internalid>
 <aYNOLt_kj6buuhH9@google.com>
Date: Wed, 04 Feb 2026 16:58:17 +0100
Message-ID: <87ikccpkkm.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B201D4000C
X-Stat-Signature: arzwez4gj78ouog16uyjgwrio44tn648
X-Rspam-User: 
X-HE-Tag: 1770220707-313330
X-HE-Meta: U2FsdGVkX18ylcJpZLnk3Rqiow8EHbwaN8yUJca9ScUPRMFLbglDXsfQm1rItMbmmX3e7sqLqa4pppjb7pW9lRigzh2obLf7eCHp090TGd2R6ZqnardQIcwSUq89FQ4xgIsqxKBsTszxu34jbd/N3wS9y3rFRuqPDYpL9j3Nt04JaANHIMtbnxLEs4YMkGF6k2ZYoSbYeebrNUZGR/jW9fz/mTplJtJ7umrtAD6j9NrMjuF04x+wIFyWLEOEoeQrXhwAvihA6pVyGq5ZWZs6NAWtagzxTetgcc1B/JfxZlVlUYaflUEtYbGmwUSH01hDtWu5kkRozPvVHOC0VDLvVwY+XNMadhso3TGksbO6aoVDxUFDSTimLHxTn6lxu0EArq4p6jql0stDvl2i5v21MxYbtXVYHjs55g8ajyplRfmcILZmDsmoIRXe535Ptqdc0CBJh4/Nb9I+bpnD5bxyareUnDiKfboqhKT96LCdbIenB38DDn0Lnqfd1TH51m7tpu1uggTUYqUX4wtQM4Sco4K3xvg0WpFMpqoEtnJQvp5rDDOJd9VuxgtWyvWq6KbAfEWlKNXsXcTv3YDz4SWHoiAdd1fQBxAjhMGj+0/WmD96dXOVo4vxVRFw8FoaSq5PWvdb8RLJp8E6vzBdrc635p36ao5THabmYdQaQHkdKC9KeoJ5AvWqtg0mPGE5gDwy6TyriABcy5RToSeeEWp3kQWP/92Ux7O7kOA8cIbY5F/kETfVZiX35ypRfCqF9vo7SZSpyeRLL/d/mxV8Rrzx9D/F+6aaHXQ7bxDJ0fQ/3BDZ+MH7BQDr10EvxlxDSuJOLNP6J76Tl1agNtj0vfs1CfTtH1n4g8nQSfALoQdc9AWPvH94cRuwG33zK143xcWgXEHw25QPmskyWAZiHx+1gHGBNKlmChdzqICNs6B1s/9bTwJc8+hjM07//y21sxZYK1PpcG5sOqRrXia7HSj
 Q2uSkWko
 uLv8JBcLvoDFHdHlHeg4WWzwKngxJIHIrwhUQfEgXwVST56RqI03uTIBGNKf6XoecInBE72DMRToyeLFMyOypMBN+ZQziTNadLmV5RYP2Gx0ThkH2SKnnYOBLAsazdJ92WjtUgZ9s0M/R6IiEBxcGAx8Zw4pgFLaXkgbGthZSeTH75WFob3lKxaFQT0uY1vBhOsZFAiojUwCjvIomfJlJiTpuYWK8iobmMrjauKpTDVLkN38DPVxYmX3StPdaeEYMg8pUaMVtBoZ6BL0aYtzs198LK09XjDIafMvz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Wed, Feb 04, 2026 at 02:16:37PM +0100, Andreas Hindborg wrote:
>> Boqun Feng <boqun@kernel.org> writes:
>>
>> > On Sat, Jan 31, 2026 at 10:31:13PM +0100, Andreas Hindborg wrote:
>> > [...]
>> >> >>>>
>> >> >>>> For __user memory, because kernel is only given a userspace address, and
>> >> >>>> userspace can lie or unmap the address while kernel accessing it,
>> >> >>>> copy_{from,to}_user() is needed to handle page faults.
>> >> >>>
>> >> >>> Just to clarify, for my use case, the page is already mapped to kernel
>> >> >>> space, and it is guaranteed to be mapped for the duration of the call
>> >> >>> where I do the copy. Also, it _may_ be a user page, but it might not
>> >> >>> always be the case.
>> >> >>
>> >> >> In that case you should also assume there might be other kernel-space users.
>> >> >> Byte-wise atomic memcpy would be best tool.
>> >> >
>> >> > Other concurrent kernel readers/writers would be a kernel bug in my use
>> >> > case. We could add this to the safety requirements.
>> >> >
>> >>
>> >> Actually, one case just crossed my mind. I think nothing will prevent a
>> >> user space process from concurrently submitting multiple reads to the
>> >> same user page. It would not make sense, but it can be done.
>> >>
>> >> If the reads are issued to different null block devices, the null block
>> >> driver might concurrently write the user page when servicing each IO
>> >> request concurrently.
>> >>
>> >> The same situation would happen in real block device drivers, except the
>> >> writes would be done by dma engines rather than kernel threads.
>> >>
>> >
>> > Then we better use byte-wise atomic memcpy, and I think for all the
>> > architectures that Linux kernel support, memcpy() is in fact byte-wise
>> > atomic if it's volatile. Because down the actual instructions, either a
>> > byte-size read/write is used, or a larger-size read/write is used but
>> > they are guaranteed to be byte-wise atomic even for unaligned read or
>> > write. So "volatile memcpy" and "volatile byte-wise atomic memcpy" have
>> > the same implementation.
>> >
>> > (The C++ paper [1] also says: "In fact, we expect that existing assembly
>> > memcpy implementations will suffice when suffixed with the required
>> > fence.")
>> >
>> > So to make thing move forward, do you mind to introduce a
>> > `atomic_per_byte_memcpy()` in rust::sync::atomic based on
>> > bindings::memcpy(), and cc linux-arch and all the archs that support
>> > Rust for some confirmation? Thanks!
>>
>> There is a few things I do not fully understand:
>>
>>  - Does the operation need to be both atomic and volatile, or is atomic enough on its
>>    own (why)?
>>  - The article you reference has separate `atomic_load_per_byte_memcpy`
>>    and `atomic_store_per_byte_memcpy` that allows inserting an acquire
>>    fence before the load and a release fence after the store. Do we not
>>    need that?
>
> We can just make both src and dst into per-byte atomics. We don't really
> lose anything from it. Technically we're performing unnecessary atomic
> ops on one side, but who cares?

OK.

>
>>  - It is unclear to me how to formulate the safety requirements for
>>    `atomic_per_byte_memcpy`. In this series, one end of the operation is
>>    the potential racy area. For `atomic_per_byte_memcpy` it could be
>>    either end (or both?). Do we even mention an area being "outside the
>>    Rust AM"?
>>
>> First attempt below. I am quite uncertain about this. I feel like we
>> have two things going on: Potential races with other kernel threads,
>> which we solve by saying all accesses are byte-wise atomic, and reaces
>> with user space processes, which we solve with volatile semantics?
>>
>> Should the functin name be `volatile_atomic_per_byte_memcpy`?
>>
>> /// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
>> ///
>> /// This copy operation is volatile.
>> ///
>> /// # Safety
>> ///
>> /// Callers must ensure that:
>> ///
>> /// * The source memory region is readable and reading from the region will not trap.
>> /// * The destination memory region is writable and writing to the region will not trap.
>
> Ok.
>
>> /// * No references exist to the source or destination regions.
>
> You can omit this requirement. Creating references have safety
> requirements, and if such references exist, you're also violating the
> safety requirements of creating a reference, so you do not need to
> repeat it here.

Cool.

>
>> /// * If the source or destination region is within the Rust AM, any concurrent reads or writes to
>> ///   source or destination memory regions by the Rust AM must use byte-wise atomic operations.
>
> Unless you need to support memory outside the Rust AM, we can drop this.

I need to support pages that are concurrently mapped to user processes.
I think we decided these pages are outside the Rust AM if we only do
non-reference volatile IO operations on them from kernel space.

They are different than pages that are never mapped to user space, in
the sense that they can incur concurrent reads/writes from the user
space process, and we cannot require any kind of atomicity for these
reads/writes.


Best regards,
Andreas Hindborg





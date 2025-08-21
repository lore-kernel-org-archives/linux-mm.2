Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA7DCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60658E0051; Thu, 21 Aug 2025 08:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37EB8E0020; Thu, 21 Aug 2025 08:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D755D8E0051; Thu, 21 Aug 2025 08:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C465B8E0020
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:32:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BDAF11751A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:32:53 +0000 (UTC)
X-FDA: 83800703826.06.85A140E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A848680010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:32:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCQggHcA;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755779571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2aiwtj26yZn9uIyQ18sZsGcJqaIU4p1CzDJFaC9tG8=;
	b=pYgQ3IvqPwlkOnXG0e7Ru4MgRKZAMN8Bi03J5YCEun6EgJ9rTy4CDFqmEk/JtFN6QcYh9b
	PYAZcCqPNLnZ7zx1tUfnLHM+CMqa8NucW936/TkJDP0xDCpRQKxTwvlqVy1y6iGSef3LdT
	ErxKBrXYvqQGRKKwxaR+TVhwqblc9RM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755779571; a=rsa-sha256;
	cv=none;
	b=TlP2hiaICvuGgToKyKGQhzIjlQwTQUAVm37zSUtkxHD9UxaqqWzRwa8kaGAv7huezK29qx
	+eLXavWFsyW4RUWR3yjTIec6SuOxcsFF9JtB+7A1nW78D14VAk1ASdnOa8nQBEUyyWhB8D
	jkB/n0NLWQq+5zdEh1bj2VMvuj44mJs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCQggHcA;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52ED0454B7;
	Thu, 21 Aug 2025 12:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD5AC4CEEB;
	Thu, 21 Aug 2025 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755779570;
	bh=SrTqUvmK+NpBlB3NybcMH+08tW6CxEGC7b7hfNmTs+o=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=uCQggHcA5Li5qLEFUvSJkmHidXQNxNdMzvaTqeAw29JRR9pkLETXDXfe08yyby1cU
	 jVDiELhFQAVMpMSslcmgWwO8sHb6M0J9GqGT29uI0UB2ILITqHU5Hr9u/n+2xxzUZt
	 RsqrBROsXWPY03PYjVcFjbBF/otcl0NvdUtvnJZnDTuZMNmFcIpYRuFzhMkcwuziQJ
	 tuNs4MMlFfsLQVZG7dhWb0lRWYDNt6pEwhmL299fAMqRKPu8oj7zrcJ9ZX+mrAUmzQ
	 TT7MYIYJK6aMRtQap+bRB7fBadnrIesb6mDbR84FskI7npl1Rswn+1gv8kLsChp6t/
	 hIPmY9joAf4TQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2025 14:32:44 +0200
Message-Id: <DC83WSYHY3K1.1D3XEES0BIKGS@kernel.org>
Subject: Re: [PATCH v2] rust: zpool: add abstraction for zpool drivers
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry.ahmed@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 <linux-mm@kvack.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250821111718.512936-1-vitaly.wool@konsulko.se>
 <DC83A2M3G8EH.12FRM3C05ABCR@kernel.org>
In-Reply-To: <DC83A2M3G8EH.12FRM3C05ABCR@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A848680010
X-Stat-Signature: 9kdzcjqxr6yqwzaf5saumo7hpzrcwg77
X-Rspam-User: 
X-HE-Tag: 1755779571-534526
X-HE-Meta: U2FsdGVkX1/9AW26TANU71qt8OxoDwW9cXgrEsgp+W4hm1El2tGRW56K3vqfx1Ia+geW4IOjwhsI68LDRbyQjTnYQ1ycvFK2A5w9pG7S5BKC8axqwYdZDQrr+b+PPhz37O5FcCDgSDONAGj6XTqmJQ4+A1peB6Qm/ccbv6UatLfdwMw+DPsf6HBccvs4mPnQqqBUOEkvgQbgHP/Ydp7+C5bz000MH96z/vALVw+XMsIICVrQasenycOn0mc6Aq9dMODMEpx/ZjMVIWwEGxv6CGvoYj9mRq/xXK5ZQnlgQSMkkf23TquEoFgSvY1TzKXyLU5dg84px3fQ5RGegzvWdEhBWiVL5Dls6vLGjNBu9CSnCiIzR/n9sNcox4oNn+tbRczIEc4kwumNRxmPL6bsmZfJu9VXw5LsQYf+r+hiT2MRs5rOQTHYp8O2XHCMh6mxA0Pg+RIa+P0F7nCR2MdqiPy63thYmeAYgO5sgagQ/FvRJECRWnLd+iPltt/O+k+dSbDqHFWDbSe/slaEf+S7Jmr2NmKtxQV1feu5Gpk+uduURIy7nK/T56hziVc43z0MdsuWVhQxKXApLBSlSr/idfkt7klKH5UfzsEmOXPyI/mUEGZCTrlXiuuvypR4MWHq+BpvKMo727D6NBGGnoJwjcJ64ckC2K/cp5+dUoX3yVrVvWgvkvTLduxRZvCds3i9vJHUcsh/0OPIOBEz+gh5McgC2K3Ej8W7H51hXeTHDburQEKdSILSnhToHg8KLh4017FppriTRHyVnvIjMWRT59zkyuiXboKmALDgXblEQRKciVCsPYAo1nqaMxzCgb1hQJMndPczsnBDitWctGBfRQfwFv8bq8oV1YINYxRdIilCJ0GV+/9eFrpxIFakfjcHxfyGhM7QWI1E1BIQMAHnN42h2b0i/SDvnRSVLjVMx93/RySf5VKFdftZUxuPea3jK0QkbZSQbyIhRwACrHu
 bHjVZFPH
 UYQkcrrAXPBeyK8bn2rgy9hG7QEdpAN+6oFCLQS3RoQb4zegGsX8a9OhvQPqP0mcMBei7eXhKMqS2K4iVHuTdcDzGPz5uB+VhTARZ+7hVlnIN5I56lhLFQa5AL9zO8/fa5nysiWHNJ6QR1KSccwppHq3btrZg0zgBbK9Ssx8Wa509472MuzRgIoC2jYaCHwxHKxhNo0O/G5Zwc7PKi+1sXERpo6ORTfItfvT+mGNlmUgtg9SIWOe1rOXJGVNVnXpCamZu5mWd+3/WcaCqKwMEoKguiJtT4CGa/+yl6rnRNtePRlz7x+SlBZbKM+Xuiw9Y1/6REPWrondkMYw+6sP/llrFMmKTJEZNzY27
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 21, 2025 at 2:03 PM CEST, Danilo Krummrich wrote:
> On Thu Aug 21, 2025 at 1:17 PM CEST, Vitaly Wool wrote:
>> +    /// preferred NUMA node `nid`. If the allocation is successful, an =
opaque handle is returned.
>> +    fn malloc(
>> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
>> +        size: usize,
>> +        gfp: Flags,
>> +        nid: NumaNode,
>> +    ) -> Result<usize>;
>
> I still think we need a proper type representation of a zpool handle that
> guarantees validity and manages its lifetime.
>
> For instance, what prevents a caller from calling write() with a random h=
andle?
>
> Looking at zsmalloc(), if I call write() with a random number, I will mos=
t
> likely oops the kernel. This is not acceptable for safe APIs.
>
> Alternatively, all those trait functions have to be unsafe, which would b=
e very
> unfortunate.

I just noticed that I confused something here. :)

So, for the backend driver this trait is obviously fine, since you have to =
implement
the C ops -- sorry for the confusion.

However, you still have to mark all functions except alloc() and total_page=
s()
as unsafe and document and justify the corresponding safety requirements.

>> +    /// Free a previously allocated from the `pool` object, represented=
 by `handle`.
>> +    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle:=
 usize);
>
> What happens if I forget to call free()?
>
>> +    /// Make all the necessary preparations for the caller to be able t=
o read from the object
>> +    /// represented by `handle` and return a valid pointer to the `hand=
le` memory to be read.
>> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, h=
andle: usize)
>> +        -> NonNull<u8>;
>
> Same for this, making it a NonNull<u8> is better than a *mut c_void, but =
it's
> still a raw pointer. Nothing prevents users from using this raw pointer a=
fter
> read_end() has been called.
>
> This needs a type representation that only lives until read_end().
>
> In general, I think this design doesn't really work out well. I think the=
 design
> should be something along the lines of:
>
>   (1) We should only provide alloc() on the Zpool itself and which return=
s a
>       Zmem instance. A Zmem instance must not outlive the Zpool it was al=
located
>       with.
>
>   (2) Zmem should call free() when it is dropped. It should provide read_=
begin()
>       and write() methods.
>
>   (3) Zmem::read_begin() should return a Zslice which must not outlive Zm=
em and
>       calls read_end() when dropped.

This design is obiously for when you want to use a Zpool, but not implement=
 its
backend. :)


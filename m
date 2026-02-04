Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B81E8307C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD74A6B00A6; Wed,  4 Feb 2026 08:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84806B00AA; Wed,  4 Feb 2026 08:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983D86B00AC; Wed,  4 Feb 2026 08:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 864206B00A6
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:48:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB7598916E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:48:35 +0000 (UTC)
X-FDA: 84406904190.24.924969C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id E90B340008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:48:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s9e8yEDm;
	spf=pass (imf01.hostedemail.com: domain of 3ME6DaQkKCC0JURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ME6DaQkKCC0JURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770212914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQOU9fiGU/IdG2FA/ukwr6QBBLgngyP+vP4uJb+th2I=;
	b=cszWajPPv50aiy+DfgxrEiqHQi4xicONgqfwudHuu1miGYgMygXIHUmjFnPEpk+1mZpmLB
	dOOYCIsUBIHd31ir25j9DvdMbprE4kVFmyOcFxmuHUeSDZBKgLe276vaCDffAiAURacIxj
	nGWIzEMJoEkIhLFkuf4ySCcYzNkgaQU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s9e8yEDm;
	spf=pass (imf01.hostedemail.com: domain of 3ME6DaQkKCC0JURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ME6DaQkKCC0JURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770212914; a=rsa-sha256;
	cv=none;
	b=mJPWyCbHo1JnzCrhncGauyNZfW12vNG+A0zTKqhI+QnZLOl/w9jDiN45Tb8jNwBvxGGYcn
	hOBOrMPeZ3S31FaXkWMk9a1geNDLfUiS+dbxEubKeB5S+iICEqEhmTke6pG5GR5FmVDB/2
	lghRMjH2sLwO/tsa+BAJvg3oYCDfTa0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483101623e9so6571545e9.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 05:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770212912; x=1770817712; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LQOU9fiGU/IdG2FA/ukwr6QBBLgngyP+vP4uJb+th2I=;
        b=s9e8yEDmBd6LgL9vkYASaY3eMzlR31T9JUKuAw8w6+VIJJYuRJmgAK3VznCP4gUGEA
         W2SRMJ8193zdp6q9xQv6JjJ+xI4YYJK2sMBJKnkJud3U0PMF623i+/wzNos/oCgrhOnV
         gh82qJyIB4KYvwz6aKP+/pjnMVQp+MrpPhTNEP2xIYzS/xxExeeqXuatX8mqWNrDI1yh
         1/vb+ldghllHe2l1y81GrIiSSqIJPZmUFm3gaenij0uVqJHppfqoaE0PlmL63JD3Lmwe
         gvBsSzY0M0EqCkK82JTDibVYoj2KrrUBGszElyRZlDF2aUGh8J2gYuv1jV4We9g3HE1Q
         JOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770212912; x=1770817712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQOU9fiGU/IdG2FA/ukwr6QBBLgngyP+vP4uJb+th2I=;
        b=gzQNbazq7iQoHCaxSbRrSluXhXJE/SJf9VxKfLYrwoLze4yuZNGF4oaNfWePJAKeQY
         ftH85J5FAMJZU5vUsa9iCyOJjo/zL2yV6cpJlQ4ouPh9j+BU5tHH2WvYr758+6+TQSWj
         6qA9RL33XBA3VbnDVQ4bcEKg/kUXY5Gjz/C+2TUpq3zvy/KBna+Z5lubMzB44V01zSoM
         jIPcNcrz/dN7Pric79os5qsRwBZmZrcvOC2V/QvPlQJ4K7+Xy+sZnNEuzUDVOJE7ldmX
         6hCbIdtQX8JYmJSZ7jQ+EJmYxCgNFGIdLkXrLwrgfrwW0FXP+ZT7OzGEMDQMEwaZfqQa
         AMLA==
X-Forwarded-Encrypted: i=1; AJvYcCUIo1v6E6Ia1j7a9Kq7ZRQqOk4qEbW3B0UiWLnEbO+WCLmVZ2YJ9qduzj8mLNB2sYsruPBdeVO3ZA==@kvack.org
X-Gm-Message-State: AOJu0YzAVig0VzmCJUkVUYskXjM7YaZzcbBFQZNn5UTyFDHoDQYk8B1w
	j6GpRpH5FsCWcWV0x2kpYC+4R4B6ruyPCpYo9uDj784lHRz6SycWApnignnmdeSLsglWfqy8XyX
	6oV3LJJlnDahDfeRwHA==
X-Received: from wmdq4.prod.google.com ([2002:a05:600c:304:b0:47a:9289:c5d8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5250:b0:480:3bba:1ca9 with SMTP id 5b1f17b1804b1-4830e922965mr37422955e9.4.1770212912043;
 Wed, 04 Feb 2026 05:48:32 -0800 (PST)
Date: Wed, 4 Feb 2026 13:48:30 +0000
In-Reply-To: <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
Mime-Version: 1.0
References: <aX0lcVngRcRwqgd5@tardis.local> <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local> <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net> <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
 <878qddqxjy.fsf@t14s.mail-host-address-is-not-set> <aYFKbWfQmTInYy91@tardis.local>
 <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
Message-ID: <aYNOLt_kj6buuhH9@google.com>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E90B340008
X-Stat-Signature: dxxjeydhbyte1h1w5dzust3ywr5phctb
X-Rspam-User: 
X-HE-Tag: 1770212913-485611
X-HE-Meta: U2FsdGVkX1/uAneR9JXp0y9fc3GZEhTts0haP0uCAvh4YN7Xvak5uDee0F+Lz/if9BT/jGhos/XalUG4g101FTUIY9/TiK13Oa4+G2hfbS8vWqw2xn50LmQRLIJQBsdn21czrr4Ut1T1KsKLZgt7a0trKwrwuKfZvTaJ0hkKLjyuQNy5TFMICdO6qBxWbW9bF6oomT8HzzbWU+ltEay1IMJaZ9GL5uDViMU1nBam2rAShqKjiv3pGJTpYq5uA9hresMvpIkJ8e7B7C4LVXAdXzc4zyQADon51SsCAm3B4Yd7cEaVgEIHL0wuviq0T9kFCX7na3Lr1MfWvIptv10XNxbNsJXvEMWRh4pWna2HLg+E2Fwahmqqml+S1cpm3YjlA2MVHu+y8st5MaE1lwOUadamuWZ/O/4A/cqD2f2XCkLFGfw+EPJrheOu0LZ3NEt+zc67DIsLrucLId/XiM+UGKrtY8lxez351HrsB4oK5XGWNUXFxpCYcvx44NX0Lgng2RbGYGYbCwccVUIQ0vu1ZIdiuvIH/B6CgdhsuAKbywmgUJjw/QHfBFYTl9iCtGGS45K/NGQWfrP65XlWpnXqifYULIWBXDaI/Wqih/WbJme52vlCFsfScxMymHNu2VkVIoh1+mdD3w9DOLiPdcwPjRLTlEs0v7tYFZnYwUrHn1eKyXM78xINnHNVYHduMVdKrcExKbUwF11rvPsUABk6VF2qhAnmaRqzl+GJZscbXHzzcFfqVgw5N9nf28wxubPM3bvLAmInkbuefewnTuPjKrAoDH8qJ3l4hQKbqEAZSHNjYV2YoLrLZijdtTSSYRfVinMNn2gB4wsuuWXZo22ZK1lReB4dN4V6/7N3TDyEKQdk+k9DrTBsVDNryGtmGY58yYvL/L0LSlAPqo+FyN466WmrRLDA+FFoMnBU4jXN26I9+Y2LLqDki2NAKqdX0jQ7nGUMzyDYCS2loWbfDxr
 /yl/M0r0
 dl/Ja+iR/5su5hOUqqD/EicYxJeyxt0hWLPyRsxqJ8VJ+DJXZhxn7vuAZLNrGGmuHutibY0PjL7TS2aRoigxDJ33Yej2DEUW6bZKUF2rLOuSW7hL1yNUuqej5dqnKadsjwmyRTJbp2q6O1oUl1ttaRa7t3+f0APFZUI0y2SG+qsxPUbYOP8M2iVaUYA2ALWETY2/0ZqlZzM+HXZ+Of48TzPEZ7DsF4hdNIOhgZ6Ydbh5nbN/afkrjyYqg7SnEaveCnmSOdoNnaPYaE8pzbz3TbIrFpbgeAUKOyG/qAYkfrAnhvoOQY8QQizzMIL/bXyjIkQpfmDsmEm3D/8k8J/VrBsxqN8lV5sRljpsxKbd43m7Gu44bI04Xu9pN54A8BuYZi3tMyJoANBlRgPCiJBMFLOJKm0rXCYyG3oiWYgXCxM6fxz5BiLQB1pxj/iFoG0ERoaPJCOcWg3ubi9pbPjDy6RAKhKyQU4wEfO2HQ9r4u6oJNOOEonXy8CnwZuGhRxg3Zg5xUlxEgh1++6Cxj6q9hcmbtLjcNW7YcsqF5AqUhDjCdX7Nk44VpiPuePxVNzYhwsAF2+k8iTRKYJMuHpsQFSef5vPYVTYanJj92zkaPSI+iUmA0sOBUVmYW7tfZzbUwMd9dd1xSg43yXpNBTYJgE8TGvz+bNBfdM4lhARCv/vibfBzwWr1s4chLWYE3gmytm8wmxmbx8a77SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 02:16:37PM +0100, Andreas Hindborg wrote:
> Boqun Feng <boqun@kernel.org> writes:
> 
> > On Sat, Jan 31, 2026 at 10:31:13PM +0100, Andreas Hindborg wrote:
> > [...]
> >> >>>>
> >> >>>> For __user memory, because kernel is only given a userspace address, and
> >> >>>> userspace can lie or unmap the address while kernel accessing it,
> >> >>>> copy_{from,to}_user() is needed to handle page faults.
> >> >>>
> >> >>> Just to clarify, for my use case, the page is already mapped to kernel
> >> >>> space, and it is guaranteed to be mapped for the duration of the call
> >> >>> where I do the copy. Also, it _may_ be a user page, but it might not
> >> >>> always be the case.
> >> >>
> >> >> In that case you should also assume there might be other kernel-space users.
> >> >> Byte-wise atomic memcpy would be best tool.
> >> >
> >> > Other concurrent kernel readers/writers would be a kernel bug in my use
> >> > case. We could add this to the safety requirements.
> >> >
> >> 
> >> Actually, one case just crossed my mind. I think nothing will prevent a
> >> user space process from concurrently submitting multiple reads to the
> >> same user page. It would not make sense, but it can be done.
> >> 
> >> If the reads are issued to different null block devices, the null block
> >> driver might concurrently write the user page when servicing each IO
> >> request concurrently.
> >> 
> >> The same situation would happen in real block device drivers, except the
> >> writes would be done by dma engines rather than kernel threads.
> >> 
> >
> > Then we better use byte-wise atomic memcpy, and I think for all the
> > architectures that Linux kernel support, memcpy() is in fact byte-wise
> > atomic if it's volatile. Because down the actual instructions, either a
> > byte-size read/write is used, or a larger-size read/write is used but
> > they are guaranteed to be byte-wise atomic even for unaligned read or
> > write. So "volatile memcpy" and "volatile byte-wise atomic memcpy" have
> > the same implementation.
> >
> > (The C++ paper [1] also says: "In fact, we expect that existing assembly
> > memcpy implementations will suffice when suffixed with the required
> > fence.")
> >
> > So to make thing move forward, do you mind to introduce a
> > `atomic_per_byte_memcpy()` in rust::sync::atomic based on
> > bindings::memcpy(), and cc linux-arch and all the archs that support
> > Rust for some confirmation? Thanks!
> 
> There is a few things I do not fully understand:
> 
>  - Does the operation need to be both atomic and volatile, or is atomic enough on its
>    own (why)?
>  - The article you reference has separate `atomic_load_per_byte_memcpy`
>    and `atomic_store_per_byte_memcpy` that allows inserting an acquire
>    fence before the load and a release fence after the store. Do we not
>    need that?

We can just make both src and dst into per-byte atomics. We don't really
lose anything from it. Technically we're performing unnecessary atomic
ops on one side, but who cares?

>  - It is unclear to me how to formulate the safety requirements for
>    `atomic_per_byte_memcpy`. In this series, one end of the operation is
>    the potential racy area. For `atomic_per_byte_memcpy` it could be
>    either end (or both?). Do we even mention an area being "outside the
>    Rust AM"?
> 
> First attempt below. I am quite uncertain about this. I feel like we
> have two things going on: Potential races with other kernel threads,
> which we solve by saying all accesses are byte-wise atomic, and reaces
> with user space processes, which we solve with volatile semantics?
> 
> Should the functin name be `volatile_atomic_per_byte_memcpy`?
> 
> /// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> ///
> /// This copy operation is volatile.
> ///
> /// # Safety
> ///
> /// Callers must ensure that:
> ///
> /// * The source memory region is readable and reading from the region will not trap.
> /// * The destination memory region is writable and writing to the region will not trap.

Ok.

> /// * No references exist to the source or destination regions.

You can omit this requirement. Creating references have safety
requirements, and if such references exist, you're also violating the
safety requirements of creating a reference, so you do not need to
repeat it here.

> /// * If the source or destination region is within the Rust AM, any concurrent reads or writes to
> ///   source or destination memory regions by the Rust AM must use byte-wise atomic operations.

Unless you need to support memory outside the Rust AM, we can drop this.

Alice


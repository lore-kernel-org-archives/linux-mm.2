Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728AB606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQC0Wr3l
Received: by kanga.kvack.org (Postfix)
	id 5A5CF6B05BA; Fri, 20 Nov 2026 07:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C706B05BB; Fri, 20 Nov 2026 07:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B99B6B05BC; Fri, 20 Nov 2026 07:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2037C6B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:03:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A72B2A0670
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:55 +0000 (UTC)
X-FDA: 85455363630.16.8ABB6BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB879C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQC0Wr3l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176234;
	b=QQ6ZGZvCArHdTl+8rgHDpuBFk11j790jScelKOHb0ZZlNMnPySqk8n6Ao0+8J8mBr2BfLc
	jKnDoET9t0PJCz3QY2xeBhCrMdfU5Zpzc3kV2tPT0LW+WZfcyutBRqELVWnhmGWRPjvK2q
	v4jJLhZJDxPQKYz9r2iLhL+Jn+iF+MQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqWIR9Se+KYSxOeedAPrX5X3Izc466RyyVllm8girYs=;
	b=pBYAKKjWXrh2OC962YhxSyHM4wDNIOAuDAAsm17497fRhJdp15JU/XKqD8UPJDCmH7Fwb5
	lb0Q+zpahYzPFkoTQtKDX6dNR9aokw3KNUgzg+oFfvE0Naz0GerqqVnJehnHaMvaAQ+xMF
	erFvkD6xXRuSE2gS9NBPIEA3fp6OmjU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQC0Wr3l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3610D45052;
	Fri, 20 Nov 2026 12:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9F91F000CA;
	Fri, 20 Nov 2026 12:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176232;
	bh=SqWIR9Se+KYSxOeedAPrX5X3Izc466RyyVllm8girYs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=eQC0Wr3lgUzzTkfZ+g++WQ6i9+JSsJkWmnj3lI8kE0w++Fj0Aif+hZDqhIL9sLyIx
	 a8Di/kqKCukJGTJC1zXepv5Sdr2LCP9iPBbdWF+A8jhGBp1iOQaNYJN7adT34Y3W9S
	 Pb+nv+aR2c9r1M0sYYw7/cHzuoRB8xHITNvgoDwEKeBy2Gh1Ujc9EBblYVSC3NiU26
	 a4amGvRPy1ozUlU0xEE6aDwbhw359/SVKYSi0RWbGncSHF6ILeSO+SgPi2eCETCBk6
	 z9bgDTJwIM9aRQu/yAj/ctpZU9mN6fxaqnl7WJSRpJYz286xTIXsEojssbBso6V1c4
	 oiEmhIyhrZC5A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, David
 Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Mike
 Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie
 Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>,
 Danilo Krummrich <dakr@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6r?=
 =?utf-8?Q?n?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5u?=
 =?utf-8?B?ZXbDpWc=?=
 <arve@android.com>, Todd Kjos <tkjos@android.com>, Christian Brauner
 <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Igor B
 <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v22 0/6] rust: page: add page kinds
In-Reply-To: <3C3421E5-5B7D-42B8-ABD2-185375693D7A@nvidia.com>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
 <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
 <871p8iue5y.fsf@t14s.mail-host-address-is-not-set>
 <3C3421E5-5B7D-42B8-ABD2-185375693D7A@nvidia.com>
Date: Fri, 20 Nov 2026 13:03:30 +0100
Message-ID: <87se0vu2ul.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EB879C0008
X-Stat-Signature: 3cibp8z51iugf6kctiwfpbz9q5osi5rw
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795176233-435036
X-HE-Meta: U2FsdGVkX1+RI6mbuMnSS1OIsNhvUWdbVf0NwFAAgenBJmG8w/muR9xZ6DW57hs4AV0AzYUXQtCQ4Iu/5olROmIHrrB7ZN7ImNUEU9muLW4IFdv1BgTsvYPx18gPW+0X9lX8Conb/Ju71/VT77qHk4PaVF44cXJW2e5ErKk+YOsaOmrEOucO8zulZ//McharYQsHtMfFeIsUC1EPvH0DgHKF9dE2aKrD/3dF9wyPl4Eo4mOIVbPmmV71LgmP2al5YFlDVVywxnfXvWpbJCcHxKUGgIjGhU6VgueiWD56iDJqIqvmd4Vk2AxRTV5ANB22GztzTnGFubFcRmiHT+PT+Q/oO60wpdinP6UE8ESdaDTFFiIi7ms0oHbleKJPwZ0+xF0D4TYfmrr4pa3Az1Q5Iqvsi01zbJ/xhUPXoemPUVGTIJbHWbDYCe8BJE3mhz/lsYbmPL8o2TtEm55jahZm9iDH13/hqCN2TfZ9Sf6gRXHn6lHgGTD1lTgexb3ADcgKhSwtznaoS18e4w1AtwO7A/A63HnTOwpHVNOD9fgNR9aIBjJ803+iZT9hJwcdOjy8PrAKmHPEMP4KbNmM3+mUMEI74Pxo7n9VnGlqQWK4ebQECVLsaGPHytGsbms6kD4hYk8u+FwMDL/brn4yxe1NQxszpfVkCyfu1dG4hiB4aWcvvisy9JyskL7RUCPco5fd86gHUbVf1vZv+hDqbYlJX72WUpuV8rJg/M30gcasvS7fPzltuXwHNNuxHUheLGF/XU7ZPo1VmbGPAZ+6eC4Foeat6dkRbJ1U4rNJNrUIPtXj3JLQv368/u9FEpels2wTH3utUiCpK/RnQHnBAtxRB77kj9MsR09U2Qyxy4NnqDH3pDvziHwI+28/4vvs9p7ZBgKCclbXk6s9qMUP7mEXzEdTWjdbjjzBBFeWxSMDwG0plswLZLaNbbGsgBdP3DjSivHH4SsO8VKTJchaH7I
 RMA5rAbA
 HceF7T77UoC0TdTHiERxb1GGpxSHqJmyVlb1S38r6rq2f1oUtSe+rUKtn5XhLM7ehQe52NknUAqba2Pf5k4vgycM1arATAr9X0eui5fhOPJEcyUou6sh0dn12xlkPgItEJyXsoNSfbPonkUNWOURrFjCCYoLHuuc7akZ7SB6Fc49Ve1UPsTEY5u0VhKMuaMGxetKQoDsMYuqHeufOnZ3WNjJXgpD80nJ4tQKwVVfMdgCoADRY6ipUTaig5HDVbdhnKbfnxA3Aim/3gyMFwndFNa926hyUvvdhsBGZJeF3BbQhEZTG3xRK45MOK1UQ4ZLwZgKFckmsWtxg382/F2cQKOnJWV8NF5PmwgURwjeWtGiH1UmLeLv+73hjrAzZcx63y68ggCxvBsmG30CxCmocEtA2z/qkEW97Iwc6RkCZ8u2vUd24GjaMULAGFSz/bY/R724BYzC6v95MMoKWoeIsKxeCe1HF427A4oxPT07+aJFbKqi9lcUedVeX2nTPTdXjQzSp1qR1QNYuW2sb+SXf4tlYZeOYnC7aPSpJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi Yan <ziy@nvidia.com> writes:

> On 18 Nov 2026, at 14:34, Andreas Hindborg wrote:
>
>> Zi Yan <ziy@nvidia.com> writes:
>>
>>> On 18 Nov 2026, at 11:18, Andreas Hindborg wrote:
>>>
>>>> Note: The page patches were part of the `Ownable` series [1] until v21.
>>>> This series continues the version numbering of that series, and it dep=
ends
>>>> on v22 of that series for `Ownable`, `Owned` and the split of `RefCoun=
ted`
>>>> and `AlwaysRefCounted`.
>>>>
>>>> Not all pages can be treated the same way. A page allocated with
>>>> `alloc_pages()` is managed by the page reference count, and kernel C c=
ode
>>>> routinely takes its own references to such a page. A page owned by the
>>>> slab allocator must not have references taken to it, but it can still
>>>> show up in places such as a bio vector. A frozen page has a reference
>>>> count of zero and is exclusively owned by the party that allocated it.
>>>>
>>>> A single `Page` type cannot describe all of these. This series makes
>>>> `Page` generic over a sealed `PageKind` that describes what is known a=
bout
>>>> the page:
>>>>
>>>>  - `Page<Base>` is the base kind. Nothing is known about the page
>>>>    beyond the validity of the `struct page`.
>>>>  - `Page<RefCounted>` is the default kind. The page is managed by the
>>>>    page reference count, and `Page<RefCounted>` implements
>>>>    `AlwaysRefCounted`.
>>>>  - `Page<Exclusive>` is a uniquely owned frozen page whose data area
>>>>    follows standard Rust aliasing rules, so the data is available as
>>>>    `&[u8]` and `&mut [u8]`. It is handled through
>>>>    `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
>>>>  - `Page<Frozen>` is a frozen page whose allocation is uniquely owned.
>>>>    Unlike for `Page<Exclusive>`, nothing is known about who accesses t=
he
>>>>    data of the page, so the data is only available through the unsafe
>>>>    raw accessors.
>>>
>>> Why do we need to allocate Page<Frozen> when we can allocate Page<Exclu=
sive>?
>>> To me, Page<Frozen> is an observed page state from a non-owner point
>>> of view.
>>
>> I'm not sure we need it, which is why I added this note:
>>
>>  This currently has no users, but I add it here for completeness. Let's
>>  discuss if we should keep it or not.
>>
>> The difference between the `Page<Frozen>` and `Page<Exclusive>` is that
>> `Page<Exclusive>` has stronger invariants. Namely that the (physical)
>> memory region of the page does not incur data races, and that the page
>> not in highmem. From a Rust point of view, this allows us to obtain a
>> reference to the page contents without jumping through any hoops.
>
> But access to memory region of the page is associated with page table
> mapping or IOMMU mapping (for device, and I assume devices are accessing
> data via virtual addresses instead of physical addresses to avoid further
> complication). It seems that you are trying to use page refcount =3D=3D 0
> to infer that no page table mapping exists for the page. But how about
> kernel direct map?

`Page<Exclusive>` has the invariant that it must not be in highmem, and
as such is always accessible in the kernel virtual address space. As far
as I understand, this means we do not need `kmap_local` before accessing
the contents.

> Anyone with struct page can use kmap_local*()
> to get kernel direct map and access the page content. kmap_local*()
> does not reject frozen pages.

`Page<Exclusive>` is a unique handle. Nobody can get a hold of the
underlying `struct page` to perform mapping operations on the page.

>
>>
>> I do not have a user for a frozen page without these invariants, but I
>> would assume there are use cases?
>
> For the above reason, everything is Page<Frozen>?

Pages that are part of user space process vmas are not frozen? We see
these in system calls for IO.

>
>>
>>> In core-mm, a page is frozen, when its refcount =3D=3D 0. The code look=
ing
>>> at the page knows the page is exclusively owned by others. If the code
>>> allocates a frozen page, it will not check its refcount, because
>>> the code knows it has the exclusive ownership of the page. To reflect
>>> this, the code calling alloc_frozen_pages() should just get
>>> Page<Exclusive>
>>
>> Is it always the case that users of frozen pages will use them in such a
>> way that they can guarantee no races to the page contents (physical
>> memory)? They cannot be mapped for DMA access or anything like that -
>> that always requires a refcount?
>
> See kmap_local*() case above.

Right. Both `Page<Frozen>` and `Page<Exclusive>` are guaranteed to be
the only reference the underlying `struct page`, and so nobody can do
mapping operations from under us. The difference of the two is that
`Page<Exclusive>` provides guarantees about placement out of highmem and
no races on the page contents.

>
>>
>>> and if the code encounters a Page<Base> and finds it has no refcount,
>>> it should convert it to Page<Frozen> or there should be a method
>>> that accepts PFN and return Page<Frozen> if the page of the PFN has no
>>> refcount, for PFN walkers.
>>
>> We can add conversion functions, that makes sense.
>>
>>>
>>> =E2=80=9Cthe data=E2=80=9D mentioned in Page<Exclusive> and Page<Frozen=
> is struct page
>>> data or the data in the physical frame pointed by Page<...>? If it
>>> is the former, is it better to use metadata?
>>
>> I'm referring to the actual physical memory region that the struct page
>> describes.
>>
>>>
>>> I am new to Rust, so feel free to correct me. Thanks. :)
>>>
>>
>> I'm new to mm, I really appreciate your eyes on this.
>
> Do you mind describing the high level workflow around Page in Rust?
> From my point of view, exclusive page content access is more related
> to page table (including IOMMU page table) than struct page itself.
> struct page ownership is more about the metadata stored in struct
> page for physical memory maintenance.

Just as in C code, there are many workflows around `Page`. Three main
ones I have seen in Rust code are:

- Pages that are part of io buffers during a syscall. The pages are
  mapped in at least one user space process and the kernel may want to
  read or write from/to them. These would be `Page<RefCounted>`.

- Pages that hit the block device driver API via the block layer. These
  can be anything, so we model them as `Page<Base>`.

- Pages used for backing storage like in the null block driver. These
  are modeled as `Page<Exclusive>`.

I think for the first one, binder is inserting and removing pages from
vmas to do it's IPC thing.

If someone were to write an allocator of some kind, they would probably
reach for the `Page<Frozen>`, as they would like to have ownership of
the metadata, but not the contents.

Best regards,
Andreas Hindborg



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCE1606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFmf/9UI
Received: by kanga.kvack.org (Postfix)
	id 594406B05B0; Thu, 26 Nov 2026 05:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546276B05B1; Thu, 26 Nov 2026 05:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433526B05B3; Thu, 26 Nov 2026 05:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18A4D6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:28:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94E4BA8A8E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:28:42 +0000 (UTC)
X-FDA: 85476896484.27.4C52553
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DC1404000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:28:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XFmf/9UI";
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795688921;
	b=ptdXVuNDCD3rAYUfqerwSBpvC+s2Es55GFSVQDy9UjaByiX0IksiZKad/xMWWvvVIllj+R
	82IaTr8SLTa37+VS4zAwOKEy5rOpJnO4gOEEL2tBvJjVwoVXYi1TJNIsW2KLXZfKwXX0by
	cEjxHtcfZrgV96cSXuyjGfxIVqjYFog=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795688921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPD3/o6xCiF7f4XJKB2+X8m6YFpbVm6rmbxAd1zz7Ok=;
	b=1+pm6VRqdaMhMuFMp+MKp2fA1zhWzb/SN1Skb3P7qTFxrgv272u0XwP5jGG07qmVF8XVLp
	oUX2pbDMfAUBpzLpNU3bNoOijM6ZVgUkOCfNRI5D/eqIyswYViPf0EHFDq2BcCf4w3prQC
	LvnKNT0Y6u3envf/zGHG44X9UKu3NLA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XFmf/9UI";
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4782046069;
	Thu, 26 Nov 2026 10:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A041F000C4;
	Thu, 26 Nov 2026 10:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795688919;
	bh=xPD3/o6xCiF7f4XJKB2+X8m6YFpbVm6rmbxAd1zz7Ok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XFmf/9UIQgxftAv9Jb8YIvR1VUIRRpK5a5WDDrP7Uhm80itZxyjRzwO97cd1dnVI5
	 olOjHHH0kKch+m2XiYjK6zmh3p9bwSvareVD2CktSmffyvqKLWrF9zsTnPzwA9ypfs
	 sH1SyEbxaLTF4XBvVeKORQb9Ts9WqSboQhXLaNKj8wHOyODSIfN8o1J9Nb3KLICr+2
	 FMsDr6zqVQEK8jUv83B4V6im8d7yduBzl4ulRHFxeMyfN8+h6IZATsKb+DEhI+5iSQ
	 +m/18p2oHDdt/LYlO6nfWSedQVdXNnFEZGddyFt6o1Z3Od9mF+CGzaskFZ1dNTc4qT
	 pSmRjObl5T4mw==
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
In-Reply-To: <C1137621-6CF4-4C52-A40A-C2875D37EC6F@nvidia.com>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
 <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
 <871p8iue5y.fsf@t14s.mail-host-address-is-not-set>
 <3C3421E5-5B7D-42B8-ABD2-185375693D7A@nvidia.com>
 <87se0vu2ul.fsf@t14s.mail-host-address-is-not-set>
 <C1137621-6CF4-4C52-A40A-C2875D37EC6F@nvidia.com>
Date: Thu, 26 Nov 2026 11:28:23 +0100
Message-ID: <874id3vqd4.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: DC1404000A
X-Stat-Signature: wzsaw6khjamm5a5xzc4x46to1kf4fjbn
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795688920-83715
X-HE-Meta: U2FsdGVkX1/nU15Ikj001yMqe/9dztqcKCf+OiIIMlI3Zgp3tZCoMNAWJCezPQkTr3H8o5c9MfteGLnmVf9Ol7+QkmXVc0SpRPE5pSHw/SARYFIBwUjLi1JaumLlVE7B97CQ5WnXQbowUCWItLpzjZ5fSrKDGshZU6ItUl68yIN8oSBsl6hb8cDss69H2eAWy+llF18uQOprVgaqHTFI7OHPsCFVndsb2x2oAFUz65wMrez4AmstbzgeaYpvpggT1v41k25Fi62z71alrU+BB/9yHoJZX41LoV3ojoMONdmw2tJ8A0gHB9eNjiutI295DQfqTqn3lC9zgGxCBg1/5al1h9UgEay+93RuchMsyL6BZljXyl7u9V2Nt2zuRSU/IA5Dt7cAT+vtdE9e0a115ZLIWnrkV9sUXOkCXcvBwGeySZ8J3HmJviwW7wqmHl5bn1/fgAQ1BLs+lCK9MbIa8oUAEUP+ZlRcBCD0qtVWL8RArzQ/8XmETpZq3/cNqymo2LXI0FXKuul+2w0thLRQgkmiwjGuxlRs+/yw0PXcxJkaz2ZQW6ucg62zFIf4JWO3Ps8HI2K3DHhi9/nRym2l2ztJ1J/o9matFeQ5Bxwt3La/DY6o+uW/dwuLbJh+OLGnPcbXa9VOD5DfSGTIPymyPz2PNeBJa6j7r0vmqCWzTntzUActdx7cPXcRs/ROthJosr/KeMKiq40IFGGVtNOPYnukWzm4CfSToZDXrm981BAbA5gZAKquWKbc3LnfrS/1XvYfmsVg4GAFYtLFpBBrESRy3hceYv2iQunUCSl0P/2FS9uxaJlTlmJdv9p+qmS6TOEQ+JKbtvSmYstUPzmDzI6nCURfsevMuRNuAwQdvu6MjmqgIeP/WXSAa7VprUVuZAnd9w4APTdUGW1D+BFjFQQIsHnd02572X7ZUXM1xAI0pzt8X4GefJJ+P2D1MwGpKqBnPBgVwz7jRJEBh3S
 8c+gig/F
 kRnCAcHGYJ9sof4hNVSYsnTz5jiXuFp8tkHKxT12Ly94HIb+IKAmAaAz8qHSXzqycIvms5DK9PA/sQBovTw5V2xUUyum/HoEjqpkobMeVMjQI08F1d9lDp1cHJSZgJGBx+0FbrLor8BbD8YPlYsjrXJWf2sC398A2cJ24ooK3QUBwbZzDAASHMKMHdk+8+sKHvHLAd+VIBGvB6OsOpcr7C+6NJ5nAh4nF3y5MSTmW4CsSh8EqAa9mgmd4CMOgEbr8t0NQ7YPeG6C5DG3Ax7Ukyo90dJDHaKljB8QAJNT2+ZNvTsD1sZYk0g9ksa2lT63aVMvwT2LE37MYfFPatxWHYBVLDl43bTq/7MTE113ho63gkF1dKorq1OkPSCOfF5BRKupWVYfclYQWI9+ImAXYWa1033WpyV1OqcIyqtLuqFmDu5OFvRRycLOAM8aTILxETazCeaL8R07+/h3NWH7ieu3OdkYOv0RiOPMTqZNfhSgnGt1F335r/NfIGmmt+UYI6BzXaqhZbzuwI4gE9bpxpCgQezAb9ucDsDyR4ElO3Q/YYQoFdffoDQVew/8XO2HkvxA/LE/HYJ27UIe2fGcyqBWNvhMzqfAM7OQiVlZ9vx+GVzg8DCs0AtpQkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi Yan <ziy@nvidia.com> writes:

> On 20 Nov 2026, at 7:03, Andreas Hindborg wrote:
>
>> Zi Yan <ziy@nvidia.com> writes:
>>
>>> On 18 Nov 2026, at 14:34, Andreas Hindborg wrote:
>>>
>>>> Zi Yan <ziy@nvidia.com> writes:
>>>>
>>>>> On 18 Nov 2026, at 11:18, Andreas Hindborg wrote:
>>>>>
>>>>>> Note: The page patches were part of the `Ownable` series [1] until v=
21.
>>>>>> This series continues the version numbering of that series, and it d=
epends
>>>>>> on v22 of that series for `Ownable`, `Owned` and the split of `RefCo=
unted`
>>>>>> and `AlwaysRefCounted`.
>>>>>>
>>>>>> Not all pages can be treated the same way. A page allocated with
>>>>>> `alloc_pages()` is managed by the page reference count, and kernel C=
 code
>>>>>> routinely takes its own references to such a page. A page owned by t=
he
>>>>>> slab allocator must not have references taken to it, but it can still
>>>>>> show up in places such as a bio vector. A frozen page has a reference
>>>>>> count of zero and is exclusively owned by the party that allocated i=
t.
>>>>>>
>>>>>> A single `Page` type cannot describe all of these. This series makes
>>>>>> `Page` generic over a sealed `PageKind` that describes what is known=
 about
>>>>>> the page:
>>>>>>
>>>>>>  - `Page<Base>` is the base kind. Nothing is known about the page
>>>>>>    beyond the validity of the `struct page`.
>>>>>>  - `Page<RefCounted>` is the default kind. The page is managed by the
>>>>>>    page reference count, and `Page<RefCounted>` implements
>>>>>>    `AlwaysRefCounted`.
>>>>>>  - `Page<Exclusive>` is a uniquely owned frozen page whose data area
>>>>>>    follows standard Rust aliasing rules, so the data is available as
>>>>>>    `&[u8]` and `&mut [u8]`. It is handled through
>>>>>>    `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
>>>>>>  - `Page<Frozen>` is a frozen page whose allocation is uniquely owne=
d.
>>>>>>    Unlike for `Page<Exclusive>`, nothing is known about who accesses=
 the
>>>>>>    data of the page, so the data is only available through the unsafe
>>>>>>    raw accessors.
>>>>>
>>>>> Why do we need to allocate Page<Frozen> when we can allocate Page<Exc=
lusive>?
>>>>> To me, Page<Frozen> is an observed page state from a non-owner point
>>>>> of view.
>>>>
>>>> I'm not sure we need it, which is why I added this note:
>>>>
>>>>  This currently has no users, but I add it here for completeness. Let's
>>>>  discuss if we should keep it or not.
>>>>
>>>> The difference between the `Page<Frozen>` and `Page<Exclusive>` is that
>>>> `Page<Exclusive>` has stronger invariants. Namely that the (physical)
>>>> memory region of the page does not incur data races, and that the page
>>>> not in highmem. From a Rust point of view, this allows us to obtain a
>>>> reference to the page contents without jumping through any hoops.
>>>
>>> But access to memory region of the page is associated with page table
>>> mapping or IOMMU mapping (for device, and I assume devices are accessing
>>> data via virtual addresses instead of physical addresses to avoid furth=
er
>>> complication). It seems that you are trying to use page refcount =3D=3D=
 0
>>> to infer that no page table mapping exists for the page. But how about
>>> kernel direct map?
>>
>> `Page<Exclusive>` has the invariant that it must not be in highmem, and
>> as such is always accessible in the kernel virtual address space. As far
>> as I understand, this means we do not need `kmap_local` before accessing
>> the contents.
>>
>>> Anyone with struct page can use kmap_local*()
>>> to get kernel direct map and access the page content. kmap_local*()
>>> does not reject frozen pages.
>>
>> `Page<Exclusive>` is a unique handle. Nobody can get a hold of the
>> underlying `struct page` to perform mapping operations on the page.
>>
>
> Right, but if kernel direct map exists, how can you claim
> =E2=80=9Cthe (physical) memory region of the page does not incur data rac=
es=E2=80=9D?
> At least, =E2=80=9Cassuming no one is accessing the region via kernel dir=
ect
> map=E2=80=9D could be added.

I think I see the disconnect. Let me see if I can explain.

In Rust, when you allocate memory that is not reference counted, you get
a handle to it. In safe Rust, you are the only one with that handle. The
type system makes sure that you can only write through this handle if
you did not share it with anyone. All this is ensured statically, and
the handle compiles down to a pointer at runtime. `Page<Exclusive>` is
such a handle. Assuming absence of unsafe Rust and C code, the allocated
memory is race free.

In the kernel of course we have C code and any thread in the kernel can
access any piece of memory mapped into the address space, including all
physical memory via the direct map (assuming no highmem). But that is
not how we generally write software. If we want to access the contents
of a frozen `struct page`, we will get the pointer to it from somewhere,
probably an allocator. Probably we will call `alloc_frozen_pages()`. And
assuming the allocator is correct, it will not hand out the same page
twice, at least not until it is freed first.

So the page backing `Page<Exclusive>` comes from `alloc_frozen_pages`,
and since this function will not hand out pages that are already in use,
we can claim that the page contents is free of data races. If this is
not the case, there is a bug in the kernel. Pages handed out by
`alloc_frozen_pages` should not be in use.

And because of the type system, users of `Page<Exclusive>` can only
write the page contents if the compiler can assert that the handle is
unique. This is called an exclusive reference, or a mutable reference,
in Rust.

They `Page<Exclusive>` type makes sure that the page cannot be used in a
way that would cause the page contents to incur data races. It cannot be
inserted into a vma, for instance.

So the guarantee comes from ownership of the allocation, not from mm
preventing direct map access.

>
>>>
>>>>
>>>> I do not have a user for a frozen page without these invariants, but I
>>>> would assume there are use cases?
>>>
>>> For the above reason, everything is Page<Frozen>?
>>
>> Pages that are part of user space process vmas are not frozen? We see
>> these in system calls for IO.
>
> Sorry I was too vague. I mean Page<Exclusive> and Page<Frozen> should
> be Page<Frozen> given that kernel direct map exists. Strictly speaking,
> Page<Exclusive> should be pages allocated without kernel direct mapping.

It is OK for the pages to be direct mapped. In fact I think they _have_
to be, otherwise we would not be able to access their content.

>
>>
>>>
>>>>
>>>>> In core-mm, a page is frozen, when its refcount =3D=3D 0. The code lo=
oking
>>>>> at the page knows the page is exclusively owned by others. If the code
>>>>> allocates a frozen page, it will not check its refcount, because
>>>>> the code knows it has the exclusive ownership of the page. To reflect
>>>>> this, the code calling alloc_frozen_pages() should just get
>>>>> Page<Exclusive>
>>>>
>>>> Is it always the case that users of frozen pages will use them in such=
 a
>>>> way that they can guarantee no races to the page contents (physical
>>>> memory)? They cannot be mapped for DMA access or anything like that -
>>>> that always requires a refcount?
>>>
>>> See kmap_local*() case above.
>>
>> Right. Both `Page<Frozen>` and `Page<Exclusive>` are guaranteed to be
>> the only reference the underlying `struct page`, and so nobody can do
>> mapping operations from under us. The difference of the two is that
>> `Page<Exclusive>` provides guarantees about placement out of highmem and
>> no races on the page contents.
>>
>
> Sorry for being pedantic, but IMHO =E2=80=9Cno races on the page content=
=E2=80=9D is
> too strong. LLM tells me, let me know if it is wrong, that DMA map
> code does not check page refcount and currently gives a dma_addr_t
> for slab and kmalloc pages, which are frozen. This means a Page<Exclusive>
> can be mapped via dma map C code. What is the plan to prevent that?

`Page<Exclusive>` cannot be mapped for dma with safe Rust code. We use
the Rust type system to ensure this. We use different types to express
different capabilities.

(Future) Rust DMA mapping APIs may not take `Page<Exclusive>` or
`Page<Base>` as arguments.

>
>>>
>>>>
>>>>> and if the code encounters a Page<Base> and finds it has no refcount,
>>>>> it should convert it to Page<Frozen> or there should be a method
>>>>> that accepts PFN and return Page<Frozen> if the page of the PFN has no
>>>>> refcount, for PFN walkers.
>>>>
>>>> We can add conversion functions, that makes sense.
>>>>
>>>>>
>>>>> =E2=80=9Cthe data=E2=80=9D mentioned in Page<Exclusive> and Page<Froz=
en> is struct page
>>>>> data or the data in the physical frame pointed by Page<...>? If it
>>>>> is the former, is it better to use metadata?
>>>>
>>>> I'm referring to the actual physical memory region that the struct page
>>>> describes.
>>>>
>>>>>
>>>>> I am new to Rust, so feel free to correct me. Thanks. :)
>>>>>
>>>>
>>>> I'm new to mm, I really appreciate your eyes on this.
>>>
>>> Do you mind describing the high level workflow around Page in Rust?
>>> From my point of view, exclusive page content access is more related
>>> to page table (including IOMMU page table) than struct page itself.
>>> struct page ownership is more about the metadata stored in struct
>>> page for physical memory maintenance.
>>
>> Just as in C code, there are many workflows around `Page`. Three main
>> ones I have seen in Rust code are:
>>
>> - Pages that are part of io buffers during a syscall. The pages are
>>   mapped in at least one user space process and the kernel may want to
>>   read or write from/to them. These would be `Page<RefCounted>`.
>
> Is RefCounted too broad for this? A refcounted page might or might not
> be mapped and a mapped page might not might not be mapped into userspace.
> Is UserMapped more descriptive?

I think for the invariants we put on `Page<RefCounted>` it does not
matter whether the page is mapped or not. The fact that it _may_ be
mapped is enough. If we need to figure out whether a page is mapped or
not in order to give access to particular functionality, we can add
another type for that. This pattern is some times referred to as
typestates.

>
> FYI, I am working on adding PG_folio to distinguish user rmappable
> folios from general mapped pages. In terms of pages mapped into
> userspace process, they can be either rmappable or vm_insert*()
> into userspace.

For now we do not have any infrastructure for handling folios in Rust.
We only handle order 0 regular pages. But I imagine we will need it
eventually.

>
>>
>> - Pages that hit the block device driver API via the block layer. These
>>   can be anything, so we model them as `Page<Base>`.
>
> Even they can be frozen without a refcount?

Yes. Quick robot overview on v7.4-rc2 (I did not verify all of it):

  Kernel buffers from kmalloc() live on frozen pages (refcount 0). The
  block layer turns such a buffer into a bio_vec with plain
  virt_to_page() and never takes a page reference, so the frozen page
  ends up in bi_io_vec unchanged.

  1. Where frozen pages come from

  SLUB allocates the backing pages for all slabs as frozen pages:

  - Normal slabs: mm/slub.c:3379-3384, allocate_slab() =E2=86=92
    alloc_frozen_pages() / __alloc_frozen_pages().
  - Large kmalloc (bigger than KMALLOC_MAX_CACHE_SIZE):
    mm/slub.c:5474-5477 calls alloc_frozen_pages_noprof() and then
    __SetPageLargeKmalloc(page).

  So every kmalloc()'d buffer sits on a page whose _refcount is 0,
  whether it comes from a slab or the large-kmalloc path. The pages are
  freed again with free_frozen_pages().

  2. How the block layer turns a kernel buffer into a bvec

  Everything goes through bio_add_virt_nofail() (block/bio.c:1055):

  void bio_add_virt_nofail(struct bio *bio, void *vaddr, unsigned len)
  {
          __bio_add_page(bio, virt_to_page(vaddr), len, offset_in_page(vadd=
r));
  }

  __bio_add_page() (block/bio.c:1030) just calls
  bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, ...). There is no
  get_page() and no pinning. The bio borrows the page, and the caller
  has to keep the buffer alive until completion. bvec_set_virt()
  (include/linux/bvec.h:71) does the same thing for bvecs built by hand.

  3. Concrete call paths

  Passthrough requests (most common for a blk-mq driver):

  nvme_identify_ctrl()                    drivers/nvme/host/core.c:1500
    id =3D kmalloc_obj(struct nvme_id_ctrl) // 4 KiB, slab page, frozen
    __nvme_submit_sync_cmd()              core.c:1210
      blk_rq_map_kern(req, buffer, len)   block/blk-map.c:652
        // aligned and not on stack, so no bounce copy
        bio_map_kern()                    blk-map.c:312
          // !is_vmalloc_addr(data)
          bio_add_virt_nofail(bio, data, len)
            virt_to_page(data)            // frozen slab page
            -> bio->bi_io_vec[n].bv_page

  Other blk_rq_map_kern() callers follow the same path: SCSI
  scsi_execute_cmd() (drivers/scsi/scsi_lib.c:318), virtio_blk zone
  report and ID string (virtio_blk.c:581, :831), and ublk
  (ublk_drv.c:679). Only misaligned buffers or buffers on the stack get
  bounced through bio_copy_kern(), which uses freshly allocated,
  normally refcounted pages.

  Filesystem metadata I/O through bdev_rw_virt() (block/bio.c:1613): XFS
  (xfs_bio_io.c:27), btrfs scrub (scrub.c:2922), gfs2, hfsplus, zonefs,
  ntfs and hibernation swap (kernel/power/swap.c:268) all pass kmalloc'd
  buffers. bdev_rw_virt() calls bio_add_virt_nofail() directly. The same
  applies to code that sizes its bio with bio_add_max_vecs() and then
  adds a virtual address, such as xfs_buf.c:1290 and
  dm-pcache/backing_dev.c:227.

  KVEC iov_iters: iov_iter_extract_kvec_pages() (lib/iov_iter.c:~1747)
  also does a plain virt_to_page(kaddr) with no reference.
  iov_iter_extract_will_pin() is false for kvecs, so BIO_PAGE_PINNED is
  not set (block/bio.c:1365).

>
>>
>> - Pages used for backing storage like in the null block driver. These
>>   are modeled as `Page<Exclusive>`.
>
> null_alloc_page() uses alloc_pages() and gets refcount =3D=3D 1 pages.
> unless you mean struct nullb_page.

Yes, the C null block driver uses reference counted pages. The Rust null
block driver implementation will use frozen pages. Matthew suggested
this approach.

Best regards,
Andreas Hindborg




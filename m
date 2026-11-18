Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1223606B13E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caoGkr+z
Received: by kanga.kvack.org (Postfix)
	id 116466B05B5; Wed, 18 Nov 2026 14:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5766B05B6; Wed, 18 Nov 2026 14:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CB16B05B7; Wed, 18 Nov 2026 14:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D15A46B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:34:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5800C0876
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:34:53 +0000 (UTC)
X-FDA: 85449242466.11.504AA0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 268231C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:34:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caoGkr+z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RxXpz7hlprBpizDk9lL07D5e79Ppid8aeCKYprG2ME=;
	b=W4p98EQoybASWWIW32cBe75xBZLs/Z1GWnMcwOYG0qJlWIKllUkJngnvulw2ZOpTf49f5X
	DDQU3apEW5vJ+/60ox0FSKmu+Mf2n62/Bg+QbWUdWjEuvhsDSP3Y2zhXhU8+83/c147obF
	uy+P+qG1b1w6hHdw1ILJ3QrZqbCq7Mg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caoGkr+z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030492;
	b=wvI8Aq/809s5kyx6i/K74oKbeI5s3vQ5o+7iw9izq7VbDWLrSp7hxEyuu+UISA+Zbj8N4c
	OsfYtr0AbNTmedxr5VXvM852gN55Eq+HV3MDLq5yB8oKBP0c0DrXwntYDqrNv7Bhbph9Td
	IWCnwuEXUxWQDHRP81knXqHdCWNQqLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC37F6226C;
	Wed, 18 Nov 2026 19:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529431F000C4;
	Wed, 18 Nov 2026 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030490;
	bh=8RxXpz7hlprBpizDk9lL07D5e79Ppid8aeCKYprG2ME=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=caoGkr+zi/fmbkrr6iGkrj0lzntp1e/kLAEuFcRbtktyvJK3yN3X8rgZDmtbwYUQr
	 6ytq8smNIkQQivbFExvo7pKBefVUcpxEXMIxFKWiDjN7pNkIeHK8C/p53IGsVfgFMh
	 Q1vr3TshI+heEGfti+KqZJHs5fkBzaCGPG5RZn9LR8jfuGr1LQChhKuQRv2bZZvuZp
	 zHuqWeftO6eyNXWCaPUbRiH1I9XDagZin13eFA2ReaVkEN4yOSjcOfVN8pR6ccYZ1K
	 h8j7JIthGjIqSk0TsFcWwqmR+H1FrUWSPuLwwIz4lSwQdkAzIA8tsTitcQ3VsAdUpq
	 GZT0wyHNfvUGg==
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
In-Reply-To: <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
 <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
Date: Wed, 18 Nov 2026 20:34:33 +0100
Message-ID: <871p8iue5y.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 268231C0004
X-Stat-Signature: pgi9j64q8b8zmokc7f67yu7uf4oy7enb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795030491-863326
X-HE-Meta: U2FsdGVkX19QLH52uRk8Y8DSCSI37E/3H99l501b3+tAxHz8bRVTXSFw2W2mvdJnuT9wSueGtyUZlppsKgC/Yp7mACgqxFNTNBkLLfjtCLelz0v6+Ng2lo2kk+Jy0teXtN2aoog8Ahm38UAFaa2tFQSMw4meN/4IPCZ1oO0j3FIDFelCmOf4lsH7EMoqXNNDi7/c9ZnziJqnHCD73BdXQfQYwIFT50wgXyE+N9/M+j9YnJqDi/zrgGTkRXeTU9cqM6Vruc73QshmVeONJeAB97J02zC3TNLNMSoD/00P2azb2uCoKhQnUHrzg/J0gjATIABAOh2KifrMSEWl4XxfAQ02eSaaEIbnZLQkM3ZxKr1HxC7n397vTtTsg1jJD/BPGReXCjwYFbxXvISNc16DZA3zBEiVzo/1MAn9P200oY8LgGJI8RHP02OUoFbk8nlL897nZNBC64qnYXHYnVYcGrXehwzTZLPgPgg2WCEA8t/LEkPl2BphZrc7ooo6XNdCz34csBzH14hDJ7dAI8VbPOkFl4qjjWbPeuB6sCm2+K3fiZ1B6ERfth1lGRegRbza20ier4LVmj9rBJpek1ReOzYQfiEbF3zRA4SOJE6CjAyMYw5LCHmMQNEvnMaQVU/smj3wFFm5WRYOJ539byQgwGFN+1bEeU01vX1slfuNfdXPsIZX3mIvak3Z7Yj5GAWy84qpB6S3WDzozkB20ZNUW5D1sXmUyD99OafcMeNOAH3t288lUZTxhoFul3wkka3iZhk9jUjGR9d24cV474Dlm1ULUJ+D6QzCblWpEKdNW7Mu2YI5di6q1grrVXWCHSAyKEGsU2jQ7H3EEMt5zbS/JB8+0OAUD5ucJvWHWA9R0lcqm1Jvy+2tnYj+goJIm1GVTNCJHzsxMHkmUEWopnP0NBUhEmD1n1Xo7XkFWDHvlFD0UMFgogXgapcv2iyQEK3yRn49SjuuWkyLrEDGnN3
 7hH6zQGF
 h0TVcINAENQ5ElNa0lKgU3RAg3vXcGUtMj1/Tw/5MgS2K9un/XNXnOicf05HcZKnruPqUgTzlPKC+Q/We6944NGxoc55w5vXIkudErHvVLy4EK4rQV+H8Rj/Wxxrc/k4TSebh6s8hsVOXOYOh4vOggsOk0xmHWZglttuK0ChjhmTFiLCqZXNGVi29kYgZLVOvFNJOQW31X98f4MMXttNcTPBQcKuLxf+0hqq46bGAtIYoOzdM/IFZD+Zc0GtNEtJvAH22GiIp2oq1V3cTuupvV1RYmPDJe1+ms68chMLg1jiZbAf5RIiWYnsYHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi Yan <ziy@nvidia.com> writes:

> On 18 Nov 2026, at 11:18, Andreas Hindborg wrote:
>
>> Note: The page patches were part of the `Ownable` series [1] until v21.
>> This series continues the version numbering of that series, and it depen=
ds
>> on v22 of that series for `Ownable`, `Owned` and the split of `RefCounte=
d`
>> and `AlwaysRefCounted`.
>>
>> Not all pages can be treated the same way. A page allocated with
>> `alloc_pages()` is managed by the page reference count, and kernel C code
>> routinely takes its own references to such a page. A page owned by the
>> slab allocator must not have references taken to it, but it can still
>> show up in places such as a bio vector. A frozen page has a reference
>> count of zero and is exclusively owned by the party that allocated it.
>>
>> A single `Page` type cannot describe all of these. This series makes
>> `Page` generic over a sealed `PageKind` that describes what is known abo=
ut
>> the page:
>>
>>  - `Page<Base>` is the base kind. Nothing is known about the page
>>    beyond the validity of the `struct page`.
>>  - `Page<RefCounted>` is the default kind. The page is managed by the
>>    page reference count, and `Page<RefCounted>` implements
>>    `AlwaysRefCounted`.
>>  - `Page<Exclusive>` is a uniquely owned frozen page whose data area
>>    follows standard Rust aliasing rules, so the data is available as
>>    `&[u8]` and `&mut [u8]`. It is handled through
>>    `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
>>  - `Page<Frozen>` is a frozen page whose allocation is uniquely owned.
>>    Unlike for `Page<Exclusive>`, nothing is known about who accesses the
>>    data of the page, so the data is only available through the unsafe
>>    raw accessors.
>
> Why do we need to allocate Page<Frozen> when we can allocate Page<Exclusi=
ve>?
> To me, Page<Frozen> is an observed page state from a non-owner point
> of view.

I'm not sure we need it, which is why I added this note:

 This currently has no users, but I add it here for completeness. Let's
 discuss if we should keep it or not.

The difference between the `Page<Frozen>` and `Page<Exclusive>` is that
`Page<Exclusive>` has stronger invariants. Namely that the (physical)
memory region of the page does not incur data races, and that the page
not in highmem. From a Rust point of view, this allows us to obtain a
reference to the page contents without jumping through any hoops.

I do not have a user for a frozen page without these invariants, but I
would assume there are use cases?

> In core-mm, a page is frozen, when its refcount =3D=3D 0. The code looking
> at the page knows the page is exclusively owned by others. If the code
> allocates a frozen page, it will not check its refcount, because
> the code knows it has the exclusive ownership of the page. To reflect
> this, the code calling alloc_frozen_pages() should just get
> Page<Exclusive>

Is it always the case that users of frozen pages will use them in such a
way that they can guarantee no races to the page contents (physical
memory)? They cannot be mapped for DMA access or anything like that -
that always requires a refcount?

> and if the code encounters a Page<Base> and finds it has no refcount,
> it should convert it to Page<Frozen> or there should be a method
> that accepts PFN and return Page<Frozen> if the page of the PFN has no
> refcount, for PFN walkers.

We can add conversion functions, that makes sense.

>
> =E2=80=9Cthe data=E2=80=9D mentioned in Page<Exclusive> and Page<Frozen> =
is struct page
> data or the data in the physical frame pointed by Page<...>? If it
> is the former, is it better to use metadata?

I'm referring to the actual physical memory region that the struct page
describes.

>
> I am new to Rust, so feel free to correct me. Thanks. :)
>

I'm new to mm, I really appreciate your eyes on this.


Best regards,
Andreas Hindborg




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57C1C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B946B6B0096; Tue,  8 Sep 2026 05:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45AC6B0098; Tue,  8 Sep 2026 05:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34496B0099; Tue,  8 Sep 2026 05:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76DE26B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:00:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D3E716045E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:00:09 +0000 (UTC)
X-FDA: 85189998138.11.3BDF86B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 525A9A0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:00:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuBC24f9;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858007;
	b=U/2fVTjgn/sXN26fSNZ4PNfklvE2euv9k+6iC6Nok9pcWgRBcgd33fKcewkQ89Nt49IWhp
	yCbhJsqX08CiwbAAVKC6GNhUuYNBDIr3+VSP/Tf6D420simYNgK2F3ONANbfF6H4Hfa/5o
	QUdXkVJI5QDc4Kjs2L2go/DbyfTaddk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuBC24f9;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=untjC3R5unkqrbBKG3Kk2zewkBrUw7LG0Av0ChJGZUc=;
	b=rR0l96B5KGveBmdcAE7F+MLK2bsWVzufkbE9CKDRPlGEODoV/ymfQxxFp4H3BNcz9ZOS+9
	vQDCXFxuZRIw+KotkUs4aDimyhk3U9j69xXaw/Be/KtWjvDg3S/eDXXSPKjJjPNlASvd25
	sSc1XA8Bl2sgB+eCRC5TRDjvfcK3gO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79B34417B1;
	Tue,  8 Sep 2026 09:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18731F00A3A;
	Tue,  8 Sep 2026 08:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858006;
	bh=untjC3R5unkqrbBKG3Kk2zewkBrUw7LG0Av0ChJGZUc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VuBC24f9OPpyU6RZ5YcWsuOQIHiBXVzStsfZ6KLHWxnkDUu5F4/T4CCCr6aQxJ03C
	 RnShT64miQYk2T8sGQ7OnVpHe1UrnYJy04QxoSPBUJ4An6P3/IId7LZOAPRMlBF8HW
	 pfge9RAFb0FsUOT8fWsQ6zKyvgAnLeFA0vbHur9FacGxYKtW+seyToAdha6igfwH3I
	 mJ9b6O2jStQyCUGLeCaIppQpryp2gbZ7yFkJYGiIMir7EsT+7m2CJIyAihBWfSKp+I
	 P01YzMOThfDS8cnMqwyWzGMlXvEvln2gBFgI9hil0Ywd51oUYQAwHpmouq0x9t+Hw6
	 dwshvv+wKxNeQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Gary Guo <gary@garyguo.net>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel
 Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>, Lyude Paul
 <lyude@redhat.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXY=?=
 =?utf-8?B?w6Vn?=
 <arve@android.com>, Todd Kjos <tkjos@android.com>, Christian Brauner
 <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Pavel Tikhomirov
 <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>,
 Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, Asahi Lina
 <lina+kernel@asahilina.net>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
In-Reply-To: <CAH5fLgjYmvp1Ph3dYXnTKkAvWgNpgCAPeq_7PZhRai6pCNmVmw@mail.gmail.com>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
 <ao2WubjLtDuHvRzx@google.com> <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
 <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
 <2dpwVpJS3VbfQ7CmE3HeY4IJSSMXTP_O9sSP3HHHUD7Z29RNEG4Hc0m8f94jKWjFlekcTXvIBA-QdGYrf8w1sw==@protonmail.internalid>
 <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
 <87zextw4c4.fsf@t14s.mail-host-address-is-not-set>
 <CAH5fLgjYmvp1Ph3dYXnTKkAvWgNpgCAPeq_7PZhRai6pCNmVmw@mail.gmail.com>
Date: Tue, 08 Sep 2026 10:46:59 +0200
Message-ID: <87qzj4w2nw.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 525A9A0005
X-Stat-Signature: ekoijy3b9gmcregggij6q9r5twsjyqqt
X-Rspam-User: 
X-HE-Tag: 1788858007-899823
X-HE-Meta: U2FsdGVkX1/ORP3SLCdn0UmZjNKfR2WJW8dkqjIPso6ZhD9jJ5bmLOObBcRwp4n2/SAzXnK6syEALUUiNvACm+xfSIeIrI6zrG4lLgrUluDgXHR5U/LYEVbiEa+9ighwWosQz8qZ1c6w7+zKh6wpeQF9bXGrODmvcK2pE4BNzf0XPpII2/z4EZeVi9dJw4JwhG7x+cprmqt8RttxtrVTqK1rZRvO+eMmB1BrJej6bv/+sogxZIideW1cU7WacSe3PfKzNF8ZDJU7PVL9yLzc3Bx2LJ6Hh3dmVeirAZ3llfOB0EYE9xzd2HAhwbXXDGu2kqBwIBylcKmvV3TznQhGSOLcZnL151BI0D/724pMbuYEYUOcZkkQC8Qf+JzurfXO9X3D51hj/CQCJMZo+InNl9qYYrgXPS7g2DvlRSpNnky4NEhfCBtKjxWWjIImigqFoLKIC/YFMU7HlWZyNYg8ePppHKt8xALbeL+sszGNorc5FwAHoBxDcMhcyBFRe0ekTGrEYEGhxLTP7XgU7cQz1AtJWBg/26a5M+WV2wSQB3ViO0VVOkGlmINfesFbeKpo5dPJIBApTvRyIrDta1eH41uV0xkHOWOsvDiB7moZOY0QK7+mN4EWDfyUr40AIc2RCI+EVAKCWsflBmhpbZLl+y/2lGzKV+YjTqhE9Md5wncAy7Bo7DaOL7J/ODnTSIfj2AiHRhlhUQ9kxOeb3rjQjQI/aCOp2KM3cdoNON8h5j6ycBjWvO5Aht2AHwD6lWwnikTMQglvzzG5tIlSRI3+um34cQPSyMRBeQymFKGt2nEOZZDwjGTFxWeTe9xGb538V5zcQaxFVtAPW+Dwaoaj6wirbxrrmmbdW6Ab6vMv+/othzB2eF5014hm1kJri2C0iJR8xI7AjZ1DFiyIHguS0fRUq6+nqp59RrykxSiFSZvfAXa54izqo5aMIv7zCaGd4TDbk7vpKGE/4TDPI4K
 OwUsx6xa
 qH823JuA5DXabJQmfRJRC6/SZmlwtuCP9qO7jDGaLXd+AbdZMhOR8ia0M1mdip7sLBzuS3RJyShI1wEdoci8z26vo7QDiqfDHFGO0SkJCKn5eW5i3MHudsL1xD7l6WuxJNYrBFnqn585IWsLIzfW2MsU2xMk1enB493jxNtypBGXuEtxYBE3FXlKiQbXtTpVK+ULQq/TSNeG7fzRzN/6PkfD14HKVUTTgXl5UG65V5gpsrCdk50hBL2YSuUS7RTjdQH3JxhfiDq6KjrXWVJQyWH3LalqouO6IBD+nxTsMWA3TfpAJCPdYA1RGYbj1Ni7OZ7aYhipIWQvyqHxL2gBU/VHbElpXceDzAKMdYTD5bdPQK5P6nn393MOf4tYqStsLhJwmrmA5NSSRG31igXlrZPnWVKdLbqm+tbfZ0sE8kR+GZH2T79ChCcgE5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Sep 7, 2026 at 3:58=E2=80=AFPM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>>
>> "Alice Ryhl" <aliceryhl@google.com> writes:
>>
>> > On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg@ke=
rnel.org> wrote:
>> >>
>> >> Alice Ryhl <aliceryhl@google.com> writes:
>> >>
>> >> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> =
wrote:
>> >> >>
>> >> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
>> >> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
>> >> >> >> +        // SAFETY: We just successfully allocated a page, so w=
e now have ownership of the newly
>> >> >> >> +        // allocated page. We transfer that ownership to the n=
ew `Owned<Page>` object.
>> >> >> >> +        // Since `Page` is transparent, we can cast the pointe=
r directly.
>> >> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
>> >> >> >
>> >> >> > This doesn't satisfy the safety requirements of Owned::from_raw()
>> >> >> > because the page may be used with vm_insert_page(), which increm=
ents its
>> >> >> > refcount and causes it to be shared the vma system, and this occ=
urs
>> >> >> > before Page::release() is called.
>> >> >>
>> >> >> I suppose the existing vm_insert_page() abstraction we have is alr=
eady
>> >> >> problematic, because it uses `&Page`?
>> >> >>
>> >> >> Maybe we want to change the API to use `ARef<Page>` so it already =
has to be
>> >> >> shared? Conceptually it takes a reference count from a `&Page`, wh=
ich isn't
>> >> >> possible because `Page` is not `AlwaysRefCounted`, so it needs a `=
&ARef<Page>`
>> >> >> to be able to do that op.
>> >> >
>> >> > Honestly, the problem is the safety requirements of Owned::from_raw=
().
>> >> > Pages have a "special" main reference, and free_page() does more th=
an
>> >> > put_page(). It even does something when the refcount does not hit
>> >> > zero.
>> >> >
>> >> > The correct behavior for Page is to allow the user to hold one
>> >> > Owned<Page> whose drop calls free_page(), *plus* any number of
>> >> > ARef<Page> references that invoke put_page() on drop. This way, the
>> >> > owned page controls the special drop codepath.
>> >>
>> >> This does not mesh well with the model of `Owned` behaving like
>> >> `UniqueArc` to `ARef` behaving like an `Arc`.
>> >
>> > It's a different case, I agree.
>> >
>> >> Please help me understand; with page having a main ref and an auxilia=
ry
>> >> refcount, if we model that with a single `Owned<Page>` and a number of
>> >> `ARef<Page>`, what would happen in the case where the main ref (`Owne=
d`)
>> >> is dropped first? Is this legal?
>> >
>> > Yes, it's legal.
>> >
>> >> My intuition here would be to follow Garry's suggestion and have
>> >> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this is =
not
>> >> an option?
>> >
>> > That would be the wrong ownership semantics. The C side increments the
>> > refcount rather than take ownership of a passed-in refcount, so the
>> > correct argument type is &Page.
>>
>> Or `&ARef<Page>`? Because with `Page` being `Ownable` it would not be
>> OK to increment the refcount from just a `&Page`.
>
> That's just a limitation in your traits. There is no problem with
> creating a refcount from just a &Page.

Yes, I agree. The limitation is by design. My point is, `vm_insert_page`
can work fine with the `&ARef<Page>` type. So if that would be OK with
you, I would patch that as part of this patch.

>
>> > Now, for the use-case in Binder I believe we could switch to
>> > put_page(), as we don't need the extra stuff from free_page(), in
>> > which case we only want ARef<Page> and do not require Owned support.
>> > But as long as we are calling free_page(), it needs to not be
>> > clonable.
>>
>> You are calling `__free_page` directly in binder? I could not find this
>> with grep except in the C binder. Is this code you are calling into from
>> Rust binder?
>
> Via the Drop of Page, not directly of course.
>
>> From `__free_pages()` kernel-doc (`mm/page_alloc.c`):
>>
>> > If the last reference to this page is speculative, it will be
>> > released by put_page() which only frees the first page of a
>> > non-compound allocation. [...] **If you want to use the page's
>> > reference count to decide when to free the allocation, you should
>> > allocate a compound page, and use put_page() instead of
>> > __free_pages().**
>>
>> I guess this is what you are referring to? We could change `Page` to
>> this style as well and all would be fine I think?
>>
>> At any rate, today I learned about Pfn walkers, compaction,
>> memory-failure, etc. that take transient refcounts
>> pages. With that in mind we need to reformulate the invariant of
>> `Ownable` to exclude optimistic transient references.
>
> Yes we can switch Rust Binder to use put_page() and have Page not
> implement Ownable at all. That would be okay, because Binder's pages
> are not higher order.

As far as I can tell, we can also switch `Owned<Page>` to allocate the
page with `__GFP_COMP` and use `put_page` in drop.

> But this case still does highlight that
> Ownable<_> currently does not address the use-case where the
> Ownable<T> is a special reference there can only be one of, rather
> than a completely unique reference.

This is not the use case `Ownable` aims to solve.

> For instance, the GPUVM abstraction would be another case where
> Ownable<_> could be used if we have this other model where Ownable<_>
> and ARef<_> are legal at the same time. Currently GPUVM uses a special
> UniqueRefGpuVm type to solve this problem.

I am wondering if we can make case I intend to solve (Ownable is a
unique reference) coexist with the "at most one of this ref can exist".
The "at most one of this kind" sounds similar to the `ListArc` use case
to me, which is a different problem.

Best regards,
Andreas Hindborg




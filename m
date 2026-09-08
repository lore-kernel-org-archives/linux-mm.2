Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F359DC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051DF6B008A; Tue,  8 Sep 2026 08:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0033A6B008C; Tue,  8 Sep 2026 08:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33876B0092; Tue,  8 Sep 2026 08:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0DB66B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:11:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABAE0C0571
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:11:04 +0000 (UTC)
X-FDA: 85190479248.28.F28BAC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1023D4000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:11:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGMrz+Uo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788869463;
	b=ivW4f5CdWWwhTaM1vuJwxzcmQUoBdYlHWLr4LdXCtTzjCg6eBTy99yAFlUFgmq97WgQrDd
	KXzcoCC4MT2zmd18nsix4edJ2xtxvtO6/ozunPCKPi8tjGhccphsJuy0tDB6ENusheUZIe
	GyjAT6gYtmTZozZRpr6h9PebDOVXI08=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGMrz+Uo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788869463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iogr4guSukTn7BNwHpl36e5eQOn5fbSrjKYt1mM0zZs=;
	b=dMzPu5V+W8XEPtTImKtGBxRCqfTRfezvF//8lE/H4T5gBWHnyqCz8WUVw93zje1o2W2iPj
	5JnC2mm2decEiQyg9QBZXposKzXW9A8Hn9JYTAgp8qhdNuP9zOvwRrXoF2t8jhmnnMiTdG
	P1rlcmRy6StNRCr87XJPPLhNf9PZCgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B56260A9B;
	Tue,  8 Sep 2026 12:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836221F00A3A;
	Tue,  8 Sep 2026 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788869462;
	bh=Iogr4guSukTn7BNwHpl36e5eQOn5fbSrjKYt1mM0zZs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NGMrz+UoNf/gzaQ74JTfvoy7vqEpiw+5cmO1q4iP3yGfSAjHDVAN4/CMNqORDPu4n
	 HJl+Qq+4W8rI5VQ2LeiZLjAJlqVYQ4R5FU5MHyCF+oFtznk29zfKuTL5ZLchElsBNb
	 0eJCxdkHcn1mvaRAmCxAu8WD9YZH/RgfqaJKn1EWHoMuT9EFFfyR+r+Ju1UjOUBm3e
	 8KwKksoimiSzXS34OkSVnFOGIYz9tkgwPyHprsro/tRuNIUakklpM4RlWUmnJFCrSY
	 wpu/sO5kJMg1HOOsq68qOmuarpS+zYwOP/2zS07HgExdpFKBauBYGI68RBci+m6JUw
	 k0/p5zwRBIfFg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Gary Guo <gary@garyguo.net>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel
 Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 Lyude Paul
 <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
 =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian
 Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, "Rafael
 J.
 Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski
 <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, Philipp Stanner
 <phasta@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-usb@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
In-Reply-To: <CAH5fLgjrQDWSPX-81TNdnc=AU3Jge57vUJ_SHCn8=uUyGfRq=g@mail.gmail.com>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
 <ao2WubjLtDuHvRzx@google.com> <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
 <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
 <2dpwVpJS3VbfQ7CmE3HeY4IJSSMXTP_O9sSP3HHHUD7Z29RNEG4Hc0m8f94jKWjFlekcTXvIBA-QdGYrf8w1sw==@protonmail.internalid>
 <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
 <87zextw4c4.fsf@t14s.mail-host-address-is-not-set>
 <CAH5fLgjYmvp1Ph3dYXnTKkAvWgNpgCAPeq_7PZhRai6pCNmVmw@mail.gmail.com>
 <87qzj4w2nw.fsf@t14s.mail-host-address-is-not-set>
 <BHf9mFp5zLg4GcKDzWhjsF9lzCPG1Pd8-nPd6b9HODeCiw9Nj9OAjU7aDmN6rnk-koAD37kW_flzkTMbOjp9Tg==@protonmail.internalid>
 <CAH5fLgjrQDWSPX-81TNdnc=AU3Jge57vUJ_SHCn8=uUyGfRq=g@mail.gmail.com>
Date: Tue, 08 Sep 2026 14:10:45 +0200
Message-ID: <87mrtsvt8a.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1023D4000C
X-Stat-Signature: chy18cfj7ohzg3bhef8f9rkqcdemaafs
X-HE-Tag: 1788869462-962591
X-HE-Meta: U2FsdGVkX19nIbYP+d5YtROkGmuazSO/5DDepfgaqPEwkEsGgHBdaWNP2qYqA35HK14odR6L3iyaYbX/q57lyMNnknghdGtFM5oHd/iF/k3YFFgKjqqjR+N9X0XRXwuEhNAUqGA7IQdD4Uxk3uAHq5rmQqK5fxdCv2aqAV9EjkLtOpsY8v/vUogYEsqa/RWpFDGm28zmJw+2++8h3vEz8wH5jSj7DWibj1PntnGSFtdz5wIaTgEo50A2lTIFQmw0su4dKI8XOjDd+H4w6Go0fAqhzpFYETJTM4QDSCaNNtUMpAUazRIV6/YLgfHG7bAdBoMzBA6iQja4N+dVV/PvlJRXhaPvbFa2jZ43TNZaJJArF2/G3w85tca07C59yNcG2e/ekA5upx77SiKbDAgC7KUVahiLElWI2oixjYnbqD0e+lMXVs5UcAG1xPN3GVBogSHYP8rlYEoxGuRMVr/mFAvOD0M01EbZGP34oL3xfej0o4bCck++X1pm4XaFpUnPm7slchA2yTEy/k9xlOzeKxy9V5hbLuHixbZnBV7amaGwld4RGi4fe6KY+5Mmf3IJH1XHal7hM035pcl2BuoT4c+84Du5JQCn+eUFcXQ5bL8oQLP8zHe7LLmxiHQbt5pF8wD1G4vl6uZBh47UJEjP8h4JOr9jur4laixNMpWeCE7t39QDhuO3KrlJpOJBWspI37CBz+1yLZDD1TWijOzxuKR3Bf6b5WpYflDFVpUJFk9TPWk5gHMtl5nK+83dUDr43vTO5JUDgkqNqQPgunnvFKT0KmXwNw3Q4V5EGmRLjXK3hX52CmOnlxA/UxHPJQlgAGGLr8hoYZqePOVAipvDMRGr++ngKV20B6ne9nEOFfYCqwA6O/pq3oL3VZPprdYautZEKqYpOW+6UCezItVk7bV3ubbMhZ0Q+zZwrLXk0pw8vHz/gYNQZOV3jpu9h/E8dpF2oHEFakM+h8BL9XA
 SCSR0Jdr
 zSd9/oENPUxfPBwiR8+nPjGZLmLs9w2NchoHzHMqi9Nqpah4UZQ14yOceUzKG+Bbf9JzvI5Dnw31Ws/TvGNekijJqtTzDCTQQ15N4+bU3IIr5TierUa1VwfNqPoRfiFS/iJKVCrRCfJnXlkKLFgEforNFBvyZHPfmo7n4tgTRw0uggG4Z4izhVO3A4weLJga+FsksoGwY3QEVqKL09Qr3pyCR3l+Msuw1oHtLmDb8I6BB+bowrfdWfC3WetbA/QKXA8GH8jT0DT1fmBZpOJuESIg/CCcb/ljONAPj5L1gj3ldGR9HgOZJYZPxQn0ypDw53otgYDHk7zt8aV/whQqFrOgtWHhUTYDzy6+q2H3JNcQPNxoD+ALHRzNjhExLyKNV50hohUpMyxSmu2h/OA4iAn0X3C/iDFQX0j9udgGUX5jle5ezQIyp/eb0oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Tue, Sep 8, 2026 at 11:00=E2=80=AFAM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> Alice Ryhl <aliceryhl@google.com> writes:
>>
>> > On Mon, Sep 7, 2026 at 3:58=E2=80=AFPM Andreas Hindborg <a.hindborg@ke=
rnel.org> wrote:
>> >>
>> >> "Alice Ryhl" <aliceryhl@google.com> writes:
>> >>
>> >> > On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg=
@kernel.org> wrote:
>> >> >>
>> >> >> Alice Ryhl <aliceryhl@google.com> writes:
>> >> >>
>> >> >> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.ne=
t> wrote:
>> >> >> >>
>> >> >> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
>> >> >> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wr=
ote:
>> >> >> >> >> +        // SAFETY: We just successfully allocated a page, s=
o we now have ownership of the newly
>> >> >> >> >> +        // allocated page. We transfer that ownership to th=
e new `Owned<Page>` object.
>> >> >> >> >> +        // Since `Page` is transparent, we can cast the poi=
nter directly.
>> >> >> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
>> >> >> >> >
>> >> >> >> > This doesn't satisfy the safety requirements of Owned::from_r=
aw()
>> >> >> >> > because the page may be used with vm_insert_page(), which inc=
rements its
>> >> >> >> > refcount and causes it to be shared the vma system, and this =
occurs
>> >> >> >> > before Page::release() is called.
>> >> >> >>
>> >> >> >> I suppose the existing vm_insert_page() abstraction we have is =
already
>> >> >> >> problematic, because it uses `&Page`?
>> >> >> >>
>> >> >> >> Maybe we want to change the API to use `ARef<Page>` so it alrea=
dy has to be
>> >> >> >> shared? Conceptually it takes a reference count from a `&Page`,=
 which isn't
>> >> >> >> possible because `Page` is not `AlwaysRefCounted`, so it needs =
a `&ARef<Page>`
>> >> >> >> to be able to do that op.
>> >> >> >
>> >> >> > Honestly, the problem is the safety requirements of Owned::from_=
raw().
>> >> >> > Pages have a "special" main reference, and free_page() does more=
 than
>> >> >> > put_page(). It even does something when the refcount does not hit
>> >> >> > zero.
>> >> >> >
>> >> >> > The correct behavior for Page is to allow the user to hold one
>> >> >> > Owned<Page> whose drop calls free_page(), *plus* any number of
>> >> >> > ARef<Page> references that invoke put_page() on drop. This way, =
the
>> >> >> > owned page controls the special drop codepath.
>> >> >>
>> >> >> This does not mesh well with the model of `Owned` behaving like
>> >> >> `UniqueArc` to `ARef` behaving like an `Arc`.
>> >> >
>> >> > It's a different case, I agree.
>> >> >
>> >> >> Please help me understand; with page having a main ref and an auxi=
liary
>> >> >> refcount, if we model that with a single `Owned<Page>` and a numbe=
r of
>> >> >> `ARef<Page>`, what would happen in the case where the main ref (`O=
wned`)
>> >> >> is dropped first? Is this legal?
>> >> >
>> >> > Yes, it's legal.
>> >> >
>> >> >> My intuition here would be to follow Garry's suggestion and have
>> >> >> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this =
is not
>> >> >> an option?
>> >> >
>> >> > That would be the wrong ownership semantics. The C side increments =
the
>> >> > refcount rather than take ownership of a passed-in refcount, so the
>> >> > correct argument type is &Page.
>> >>
>> >> Or `&ARef<Page>`? Because with `Page` being `Ownable` it would not be
>> >> OK to increment the refcount from just a `&Page`.
>> >
>> > That's just a limitation in your traits. There is no problem with
>> > creating a refcount from just a &Page.
>>
>> Yes, I agree. The limitation is by design. My point is, `vm_insert_page`
>> can work fine with the `&ARef<Page>` type. So if that would be OK with
>> you, I would patch that as part of this patch.
>
> IMO, Page should implement AlwaysRefcounted and this method should
> take &Page. Anything else just adds limitations that are not needed.
> But I'm ok not implementing Ownable for it.

Ok, I think you have me convinced. Mainly because `Page` as it is has no
benefit of exclusive access.

>> >> > Now, for the use-case in Binder I believe we could switch to
>> >> > put_page(), as we don't need the extra stuff from free_page(), in
>> >> > which case we only want ARef<Page> and do not require Owned support.
>> >> > But as long as we are calling free_page(), it needs to not be
>> >> > clonable.
>> >>
>> >> You are calling `__free_page` directly in binder? I could not find th=
is
>> >> with grep except in the C binder. Is this code you are calling into f=
rom
>> >> Rust binder?
>> >
>> > Via the Drop of Page, not directly of course.
>> >
>> >> From `__free_pages()` kernel-doc (`mm/page_alloc.c`):
>> >>
>> >> > If the last reference to this page is speculative, it will be
>> >> > released by put_page() which only frees the first page of a
>> >> > non-compound allocation. [...] **If you want to use the page's
>> >> > reference count to decide when to free the allocation, you should
>> >> > allocate a compound page, and use put_page() instead of
>> >> > __free_pages().**
>> >>
>> >> I guess this is what you are referring to? We could change `Page` to
>> >> this style as well and all would be fine I think?
>> >>
>> >> At any rate, today I learned about Pfn walkers, compaction,
>> >> memory-failure, etc. that take transient refcounts
>> >> pages. With that in mind we need to reformulate the invariant of
>> >> `Ownable` to exclude optimistic transient references.
>> >
>> > Yes we can switch Rust Binder to use put_page() and have Page not
>> > implement Ownable at all. That would be okay, because Binder's pages
>> > are not higher order.
>>
>> As far as I can tell, we can also switch `Owned<Page>` to allocate the
>> page with `__GFP_COMP` and use `put_page` in drop.
>
> I'm not entirely sure if __GFP_COMP is needed, since the page is order
> zero to begin with, so I don't think it makes a difference.

With alignment on `Page: AlwaysRefCounted`, I think this becomes
orthogonal. When we want to support allocations of more than one page,
we should probably make them compound pages (folios) and manage them
with the refcount (put_page), rather than non-compound high-order pages.
But this can wait.

>> > But this case still does highlight that
>> > Ownable<_> currently does not address the use-case where the
>> > Ownable<T> is a special reference there can only be one of, rather
>> > than a completely unique reference.
>>
>> This is not the use case `Ownable` aims to solve.
>
> Maybe not, but then it doesn't apply to Page.

I agree.

>> > For instance, the GPUVM abstraction would be another case where
>> > Ownable<_> could be used if we have this other model where Ownable<_>
>> > and ARef<_> are legal at the same time. Currently GPUVM uses a special
>> > UniqueRefGpuVm type to solve this problem.
>>
>> I am wondering if we can make case I intend to solve (Ownable is a
>> unique reference) coexist with the "at most one of this ref can exist".
>> The "at most one of this kind" sounds similar to the `ListArc` use case
>> to me, which is a different problem.
>
> I think they can co-exist. If AlwaysRefcounted is implemented, it is
> the ListArc use-case. If Refcounted but not AlwaysRefcounted is
> implemented, it is UniqueArc use-case.

I see.

So for v21 I will implement RefCounted + AlwaysRefCounted for Page and
drop the Ownable implementation, have alloc_page() return ARef<Page>,
keep vm_insert_page() taking &Page, and switch Rust Binder to hold
ARef<Page>.

I will also include the SafePage/ExclusivePage series [1] in v21 as a user
of `Ownable` with a few modifications. It will no longer be possible for
this type to deref to `&Page`, due to `Page: AlwaysRefCounted` and
`vm_insert_page` taking refcounts through `&Page`.

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/rust-for-linux/20260605-page-additions-v2-0-03f=
04c8fdbbf@kernel.org/



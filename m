Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162CDC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075766B00A0; Mon,  7 Sep 2026 09:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C936B00A1; Mon,  7 Sep 2026 09:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E800E6B00A2; Mon,  7 Sep 2026 09:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8067E6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:58:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F8316017F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:58:57 +0000 (UTC)
X-FDA: 85187122314.21.07AD559
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5E18B20004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:58:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu3IZRZr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6HvKokTBWQ5qgUPDm6WwxT5+vJL6f+t/uawYA58zoY=;
	b=z/WFcgs3rF3YtSvYU9zBiZOOtCyyjgVmD5AlHOfqEzA/dqu3Fz6w81b/JNvSi6VCKYIlwj
	LD00dHlE5bRqJHNK4i9kzFXTUszE+IiajqEfMD7LAFO5yru3CJQ3jcpXKu2QlojjBk0tIR
	w9v0K/9cfDbJuYqrh9lGWSgSgOapU7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789535;
	b=VJ+PSOLk8oqHhLrpdXwfu1TMFT51XSYFrHp/9e+Dh2ucnbxWiFwqmDnesYTPqZWRT9T4HX
	ABJlaUlWgwjuxMmuR6QfUsZciDLjUUmwZecB4rZiqjZju/8picLoLDbIORV5itcX2z2T2F
	oyeI13vCxiSeyuFcyWbjWJ42rttRKsc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu3IZRZr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A502C4086C;
	Mon,  7 Sep 2026 13:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7821F00A3A;
	Mon,  7 Sep 2026 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789534;
	bh=I6HvKokTBWQ5qgUPDm6WwxT5+vJL6f+t/uawYA58zoY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Wu3IZRZrPimxJw8Xrfy4xfMIQYTFuR01X8avL7jkL6VDDrRR/R5ZOFA2yk6u1qm/w
	 AKoK2kijj6fYGv5w8z+yajL7wx8MHIt41AhSubYNt4+Zd6KlEXkqZX/mbd8drzk9W4
	 BhAcsbTdhvbMQ0uxnwA4wAf3wYS7iFq4rFc1zYtkKv1sUwUKX2MnKP8p3a2Kd5g6iU
	 gI55Yv2wG8TFVCTbExYoWOrB4WMke5xHKiy6gRZJDHOIqxHvyE18ycr3ZJ8xPejC3Y
	 IggNAEHiJaevSjwpzqvJKs3X3UeTqGP8ry5v4xe4lCj+SE0wSrAqt5ojIe9ehxWWS7
	 fBME7tR0VAR4g==
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
In-Reply-To: <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
 <ao2WubjLtDuHvRzx@google.com> <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
 <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
 <2dpwVpJS3VbfQ7CmE3HeY4IJSSMXTP_O9sSP3HHHUD7Z29RNEG4Hc0m8f94jKWjFlekcTXvIBA-QdGYrf8w1sw==@protonmail.internalid>
 <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
Date: Mon, 07 Sep 2026 15:58:35 +0200
Message-ID: <87zextw4c4.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E18B20004
X-Stat-Signature: m1cze8dx5g1z5sinwafemzqj6mwrpjem
X-Rspam-User: 
X-HE-Tag: 1788789535-772712
X-HE-Meta: U2FsdGVkX1+q63b4U/vqjs73vJnQJH3nx7Junp4nZABYaOSoROoyXflgQuTF8JAIUOBpuTOj/VQ9R8g/Mt7RmU+w6+bo11+K0n39efAw4u9TW243kTxouDVbkLoZMZ8GdSBJa+NJ9hfE+APmUPaWKjDzBRaKEilv/slX5zzRDJnwrlgILk0YdHsjueI92LQ4NKO1qOBbkAZMXIggZHThZVOcLWQg8CayShYHW3duvTotC4Ak3bjIcA19M1uFY/nExEOqKJwdxf6n1w1o/my20FZHWabp6CMJKTU2ANts4C/QF7UpLoHkEine+51cIWotR4BqSReaQsy56A3+2JnxY041J3QMy58dtspA459AhW8oSQlPQvyvRBuVwK8K0Dr5SDI/1fHor1qUP1/yRX5UMNidcaKgZPUlUo8pSUK/yTTidhlEKBKdotCu0K7ntNtM7o3LM8A6WClz1PkA5QlitcbF6KNuy16+PbRdkgszMMXnI7c8ndDMcudcoVycdZ2+yOCzl7U+1Ws2SyQdoS+AjcpelthfdxyrMXvIQF9rEeJWnepKU5pkxgvK9a5rQfNJd8pQOtM3op9W/6UQQyo98RntrylahrVqHi0JrwWPwEWU8mMSuX1DpthB+lpabTMnTUndZrxMkKfWOBS0jq2/3qX2BvNxPMdtz5dv5WdA6RdIu57pP48XbE6x3LtFeaFAjMbfeKd3+ZqquHJyOj4YTk3XhqiQcsyW+6vDl9aksuukjj9FbvqCzvSJ62R1OfCv70XnhqCGqH0uiZdY/YymAbnqR1eTBNpScXvSqUJgnhpIlX0fFOeW7tnyHQp7b2uROgh+S6DF2Ngaqot7Cz/b/wzSfjPdO41EQraEPjxGUgJtacvoOSsSz1iNsx9iJc6NYx+QW4vpE5r+u6v8vm8pSNKxQXSnfQcv0BTja23CfRxnI14cXn+CufaaET2Clat/CdWh03aDb9m0HM8geVb
 ad35HDBg
 2l4t8DmQc6Vpo9dFnpgBvGVh6YWSYC8uk3/wxjQUampcIUIo3P2o33YukkXmtudJwflC3Wwc5/G2Znb7ajaAJXFQRweJ81jArZLkdB6Olm8MuqJNqg6WDPEI9HhSq8DWR+q9sLiucyWrNoXlLxohVExVZu8vECKV6oOkK8Q24LLb4cE1YBxV8wNY906SjlB/FaP4s9vD5Ku96M5MY65Vo3XXGKyeyW+JKLrB8StqUjBIDYGFE3fywgIemlTfyFlST+zdOgMj/OLn2ta2KTINA8aHx8uVBMygHUFVhX2HgjUD8otWnnjJEm0JoO9BaBnwEeibKwJxMr7OWmjL2MZywmmVX/N7zhAFKwJQyTK1gyZ4yBMW+1DOLlXfg4wcl8q5FaBfwyiIfvoOleXj71DOuZva19XTGgyK9z2XFQ0Oj0B26m97lWnACGdlhvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>>
>> Alice Ryhl <aliceryhl@google.com> writes:
>>
>> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> wro=
te:
>> >>
>> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
>> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
>> >> >> +        // SAFETY: We just successfully allocated a page, so we n=
ow have ownership of the newly
>> >> >> +        // allocated page. We transfer that ownership to the new =
`Owned<Page>` object.
>> >> >> +        // Since `Page` is transparent, we can cast the pointer d=
irectly.
>> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
>> >> >
>> >> > This doesn't satisfy the safety requirements of Owned::from_raw()
>> >> > because the page may be used with vm_insert_page(), which increment=
s its
>> >> > refcount and causes it to be shared the vma system, and this occurs
>> >> > before Page::release() is called.
>> >>
>> >> I suppose the existing vm_insert_page() abstraction we have is already
>> >> problematic, because it uses `&Page`?
>> >>
>> >> Maybe we want to change the API to use `ARef<Page>` so it already has=
 to be
>> >> shared? Conceptually it takes a reference count from a `&Page`, which=
 isn't
>> >> possible because `Page` is not `AlwaysRefCounted`, so it needs a `&AR=
ef<Page>`
>> >> to be able to do that op.
>> >
>> > Honestly, the problem is the safety requirements of Owned::from_raw().
>> > Pages have a "special" main reference, and free_page() does more than
>> > put_page(). It even does something when the refcount does not hit
>> > zero.
>> >
>> > The correct behavior for Page is to allow the user to hold one
>> > Owned<Page> whose drop calls free_page(), *plus* any number of
>> > ARef<Page> references that invoke put_page() on drop. This way, the
>> > owned page controls the special drop codepath.
>>
>> This does not mesh well with the model of `Owned` behaving like
>> `UniqueArc` to `ARef` behaving like an `Arc`.
>
> It's a different case, I agree.
>
>> Please help me understand; with page having a main ref and an auxiliary
>> refcount, if we model that with a single `Owned<Page>` and a number of
>> `ARef<Page>`, what would happen in the case where the main ref (`Owned`)
>> is dropped first? Is this legal?
>
> Yes, it's legal.
>
>> My intuition here would be to follow Garry's suggestion and have
>> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this is not
>> an option?
>
> That would be the wrong ownership semantics. The C side increments the
> refcount rather than take ownership of a passed-in refcount, so the
> correct argument type is &Page.

Or `&ARef<Page>`? Because with `Page` being `Ownable` it would not be
OK to increment the refcount from just a `&Page`.

> Now, for the use-case in Binder I believe we could switch to
> put_page(), as we don't need the extra stuff from free_page(), in
> which case we only want ARef<Page> and do not require Owned support.
> But as long as we are calling free_page(), it needs to not be
> clonable.

You are calling `__free_page` directly in binder? I could not find this
with grep except in the C binder. Is this code you are calling into from
Rust binder?

From `__free_pages()` kernel-doc (`mm/page_alloc.c`):

> If the last reference to this page is speculative, it will be
> released by put_page() which only frees the first page of a
> non-compound allocation. [...] **If you want to use the page's
> reference count to decide when to free the allocation, you should
> allocate a compound page, and use put_page() instead of
> __free_pages().**

I guess this is what you are referring to? We could change `Page` to
this style as well and all would be fine I think?

At any rate, today I learned about Pfn walkers, compaction,
memory-failure, etc. that take transient refcounts
pages. With that in mind we need to reformulate the invariant of
`Ownable` to exclude optimistic transient references.

Best regards,
Andreas Hindborg




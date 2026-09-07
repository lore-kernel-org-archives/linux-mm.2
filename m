Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDC1C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C736B00A1; Mon,  7 Sep 2026 08:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CDB6B00A2; Mon,  7 Sep 2026 08:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C566B00A6; Mon,  7 Sep 2026 08:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1DB6B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:38:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C69581C00BE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:38:44 +0000 (UTC)
X-FDA: 85186920168.06.736B42A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 276BC1C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:38:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYVCxLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD+2zcpvmkcDZ3cJuCNDIPkcI/BtMjbq/CkWlis/PbU=;
	b=Zn6FNuxoar6ZMKgR9G82G1LoYJifzES20ItQjplsr2y5jvWmAdaD37voniudMsFMOc9zrY
	EJaHT9JMKasU8iil+CqouXo1+HeOvEkbaLFRC+/P0BMsZ13fit9XhKTN5lQ0HhCRf1hrjT
	Ems/vdPZfcSVnXY3RkByjJMEab6jGcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784723;
	b=VqJ1GEcz0/mZBYdADSnXI93aEx/ZRdrGW+fg2smtQXlZ27iJEAfOYGNIxCz7g8yH/ILh9L
	qL9q8YbyZ3YN5jEBLQPesXvBKxnebPabUO3iaGzprufDg9Fo83WidXvYxbiCURDNmp8sxB
	Hm/ArpaITWPgdmZsUVUFBCv1uww7tAU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYVCxLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 516E342E18;
	Mon,  7 Sep 2026 12:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804011F00A3A;
	Mon,  7 Sep 2026 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784722;
	bh=KD+2zcpvmkcDZ3cJuCNDIPkcI/BtMjbq/CkWlis/PbU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kRYVCxLY0/vTJ+fbmiuidiZQ+nIGH/QQuK/Qi8lQ02VhxlPUZ0WJUQjPMPR57SbcW
	 q9ArkX+lA0h0qlH46NRcal31nv+ecnkEemNBrVHbmQ1h71tj5VST7+zO0x6YXSzB3i
	 cPQW6OnsBJ7tUaclciTTf0zGW4oR1lCVNyUm6YsyUC9aGtgib7AnMYkJNGu41k6wdO
	 /F3gYxxJ0BBinS+JZ2un9pBUwwbDdmNSaUG9m9bFQvkpJN3EFGFST8Mmq0yV6ViYwW
	 7xvSkClBpumHKJBZnZ2b9YGNbICmSo0MxgutXJ3cXXgZrZrwS7637pq/UkkfPReY2B
	 x5Ldt7pD8EE7Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Gary Guo <gary@garyguo.net>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
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
In-Reply-To: <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
 <ao2WubjLtDuHvRzx@google.com> <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
 <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
Date: Mon, 07 Sep 2026 14:38:23 +0200
Message-ID: <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 276BC1C0006
X-Stat-Signature: 7kpeazdt6g4d5knma3ohb7j8r4u39339
X-Rspam-User: 
X-HE-Tag: 1788784723-875830
X-HE-Meta: U2FsdGVkX1+K/QSmD7EAY1zhLRZWUvOFevOBWm+H3oNzNPwhNg5Sep3PDWNidxBHmru7bVwMemmoDv81Yc0a1XaGeOTlHV6/g81WbeUQcV6Mzf7QiXWd4LW/u4Y4sqljjq8l1SVGykEa7QvAEc66eELEjOtIJF/URHL1bZKs/5POKDZNA/RgscPoRFZl7ZuQCkXD5c7gY6mjJd/HRIp774d3w3CSMU8IanWTu0CtvgcnHKXiN+6IfgZiZziJkzdYb2yb6udR95j2Et/csflD4IqSgJqBWhv1JSwqQqKQMtyxy0J3lURhjUVW5tEqfAaUDATBzt/vtuGYUu9MF0T0o2DDkdRGPpofHcp4bP33xguKRcqlwOgZu5tpGyPaXpHMDEmVOr4lPEwWfL5hsEgVB3Pwgm2vL7Vy+d+J4003hTDHxkKLXUEBcQTzSuNsPow+yWhifVc6bqHAHDMIdljONBC8bGbmK3FFU0kE1mhltGGrYWVYZcwg6na1tpwq8kZXWFk66LCQIcfzhODKRp6zSqhzQ8JGI/qjbw6jdrrnqSsWZ1G9aEKi7Zs4kPw3n9Ggjj/MUBlgAq4LuDiVOYcwCBajaQS2MGZANpIvHEo0GD9edvhO32cjkUdOT9sjQtEOH6eIpEe7AIR+4Gvx7dNqYdLALEFCy0qKcysQ+TEcyj1ZbRYvE8T7AZBSuO0VLgMiHvUmQBJ1ng1NOzlcHDM++x48+Si1OIezn9KFYDutJj3+x281J773Gj82DPo74YrlmN0Ch1If+49exn+BjKQ+DgQ61u0njhNQFOElwn/N74V4rRJMOAz2pZ8v6zPvramcDLb2ZguavaAFyO4aCBTRjy7ZqU450aFpPAAGoeZ7d5VZqaR/gTG0sDZ8SJq0FcyRTigE0/QRPbJQH5OdVjvz/C/cYX+z6fsH2+vr6yzF4d0O07Y17AIPcQFyG+JR6qPAGJnoJ4itPqaRbU8dlW8
 +iu66C5I
 1mC7fnUs2k11msCyDLZoFDNhJVWNOeJXVlS3EtgembAQSaF464WClm9dJ464O/ZtLMrpZy9gwVEz36Y8WfWvHdjOGy67pBDKaLQQ6nyuIZ5zsEj6RiAebHggd9nGha9HwwHbelM9wPE253iwOyn4Z0YtLoWkZGyq+5fMaCDLxpxNd87HNm4lHk0AySUAqvWTt6Kn7L8EZeQO1jVgxy0gE3pTQGa4vx38rONjOn2QKhZTc4Um8I94z+4IGmNcal54npFoeaR03KtjGqjjM1wMNodmE0wDhEoBkLcFWOb6W6WndblUKGMGkcFS8i/DFsvvtlMm9vItBiYfdnRJzlH/acwesp+rYl73GaHAqm7nwrCe5xCPAFRF+JoGv0vPFUHAssFxyclNvwDa8cTNB39DNzX7JyNdAiQiCUMXc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>>
>> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
>> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
>> >> +        // SAFETY: We just successfully allocated a page, so we now =
have ownership of the newly
>> >> +        // allocated page. We transfer that ownership to the new `Ow=
ned<Page>` object.
>> >> +        // Since `Page` is transparent, we can cast the pointer dire=
ctly.
>> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
>> >
>> > This doesn't satisfy the safety requirements of Owned::from_raw()
>> > because the page may be used with vm_insert_page(), which increments i=
ts
>> > refcount and causes it to be shared the vma system, and this occurs
>> > before Page::release() is called.
>>
>> I suppose the existing vm_insert_page() abstraction we have is already
>> problematic, because it uses `&Page`?
>>
>> Maybe we want to change the API to use `ARef<Page>` so it already has to=
 be
>> shared? Conceptually it takes a reference count from a `&Page`, which is=
n't
>> possible because `Page` is not `AlwaysRefCounted`, so it needs a `&ARef<=
Page>`
>> to be able to do that op.
>
> Honestly, the problem is the safety requirements of Owned::from_raw().
> Pages have a "special" main reference, and free_page() does more than
> put_page(). It even does something when the refcount does not hit
> zero.
>
> The correct behavior for Page is to allow the user to hold one
> Owned<Page> whose drop calls free_page(), *plus* any number of
> ARef<Page> references that invoke put_page() on drop. This way, the
> owned page controls the special drop codepath.

This does not mesh well with the model of `Owned` behaving like
`UniqueArc` to `ARef` behaving like an `Arc`.

Please help me understand; with page having a main ref and an auxiliary
refcount, if we model that with a single `Owned<Page>` and a number of
`ARef<Page>`, what would happen in the case where the main ref (`Owned`)
is dropped first? Is this legal?

My intuition here would be to follow Garry's suggestion and have
`vm_insert_page` take an `ARef<Page>`. Can you elaborate why this is not
an option?


Best regards,
Andreas Hindborg



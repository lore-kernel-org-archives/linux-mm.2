Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A36EC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 09:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76006B0088; Sun, 13 Sep 2026 05:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27866B008C; Sun, 13 Sep 2026 05:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16806B0092; Sun, 13 Sep 2026 05:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8AA16B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:49:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3ED8140601
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 09:49:30 +0000 (UTC)
X-FDA: 85208266500.30.4B26267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0494B20004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 09:49:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfBvxpKE;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789292969;
	b=mtgR2nRDJo5FsxkJ2UGsqAOa1wzox+ZUaEWyYABuG7VI2RZ2hwo7BwrJ3uZEYo0WDlrp3p
	Wu+ST0eIkG2K1hJLyMLh9r4rey0NnP0vZKh2YPTfMSMdt5SIk9l8N4xG4uK+e+yV+QEn4r
	w9j41Qsof++7cPW+ummFSNC5rzbSpTo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfBvxpKE;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789292969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tg5IU0+H9KMkSOpIVEYusfjm6bIb4fQEllwynyz0EVc=;
	b=ODBzPDRAieYDKf5joDAHiOZTUzfMlvZoC3AfEzjrmD3VvNSNkBFeK3QAiG1VFpU2ve3MUD
	QfLUnVoDLPyxGlYriLLpDFYSMdfp32V/pYwMqQxoyr+FKa6YlqPi3OniNRWugyKNmCIzTW
	HTjzyAjGRrTyBbZuB3nYdnQxYSyLiIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB11242AC6;
	Sun, 13 Sep 2026 09:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DC51F000FF;
	Sun, 13 Sep 2026 09:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789292967;
	bh=Tg5IU0+H9KMkSOpIVEYusfjm6bIb4fQEllwynyz0EVc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=PfBvxpKEvpJ5VLvXhFNDyHaYXB+ow/oOmmQUHohuPRTQ5OidCuKr72NVna21Lhj74
	 r5JNth+EicGcrCC7nWRPU3KP7VvVO3pSw3SMgGmOSz4IhFnNf6O4Pe/2yjIehooC1j
	 V5gfQBN3V7CSTiFObippk57pdzCBTAaYjhpBs8h86PcRmrAVE5mHCe8CBXR8sdZ9lI
	 hOiIl8GhtQRUZJhWmq4v0gpGo2yCDfi4JJ5+JCDbKJMzUMLQpHEY7eL23wcPEXXOYK
	 YUZArZv4sXfKDhvHqKab4q5jTSS5LAjaBXREtzk2jtVz45lYaQ3li0P61UqlG1ww9i
	 AGBthjzkxuVUQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
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
 <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Philipp Stanner <phasta@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, Oliver Mangold
 <oliver.mangold@pm.me>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v21 4/9] rust: rename `AlwaysRefCounted` to `RefCounted`.
In-Reply-To: <DLCHKYBQ3WF1.B8YPUTAKNM7@garyguo.net>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
 <20260910-unique-ref-v21-4-e83257373062@kernel.org>
 <CAH5fLghUQW5urTfLCCDT4BhuqoFVoLUAG46TS-SxaS37bJcgWQ@mail.gmail.com>
 <DLCHKYBQ3WF1.B8YPUTAKNM7@garyguo.net>
Date: Sun, 13 Sep 2026 11:49:12 +0200
Message-ID: <875x09v5uv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0494B20004
X-Rspam-User: 
X-Stat-Signature: oawufpp5wdpeqgkimozhf69fhoiracgr
X-HE-Tag: 1789292968-19768
X-HE-Meta: U2FsdGVkX18wXLmIwymebZOsBhA/UY1nA/hY1wwicLCozbH1AZUhs1KZC7xUcM1w23qvYIOt0yivh4mbZEHvtBEWiKO1bwDgFFmKr5KOIMQMBdgMmAe6c9Ux+T4ITVeRTVVdMaMPFEXa0/C7Y2CU240VVPn0lDgg8SD0G1UOicKTETPVW1vg1mfylvqOn3tlpH6C8l2r/5SfPDH0lAeBeQch4C5bo55UJBTTp27oolfmyIt3nUp9zCZAdC76oLaUcxwYLcQFeEuxb6+D+g+vjChGB2TWbZ7vMMz9dB/H0Gxbr6pQx7H1KQHgTRaVHH7Ay6zv12uca4L0KLRyUQc8w1Y5xs/Q7BnBnn2P3cYIJcetXo6aDsrpQhuUHIisidbZ5H5urxac1Xqhcip/hSc0kDIMp0HEnbFtKKORE0sgqg/4LgNwQuCTVEPA7LLxvdLeumZCNUgfppAFlS/hb6a0aZQ8jxDBOwi/B8P+Q0gq6Ep27cjCbZ4jk3LizJr3DEgkovKkG1W9hjNCvzwC3bafiaxhuk7Dp7PbQXSE/n6TvjQom8i9ArLax5Ge7hssZMPeMMrjRsJiAgKnMRgSpUIWTYLZo4LHvMFPhmEM2oagln9XB9RlMsN7Hj5jMF8xVkusvwpIV9nnsrvowb5KpdY5qaYLW7hA5bxgxOCYfnHcv36+IjNffTYU45FOU/7d/TPYyD3NGvGEwIOPpJ2794otj7rKUdvxq+I7eKYKdwhTC4NLDczOoSKkQjEEg/iX2qv/bBmhbDWKyTalUmO5ONquLFAuh5ZD9lmapsfv7+TJqimiKf2xfqVBtxMhMEy7WWVgEsr9GnOe1tBmJ3FZ8I4f7c9LIIJwSbWEFmCHhPu7m3wSEaH8MBLE6HkYTaBa8lxJXOrWNyG8AnVShsCLs/cW8b1iqzL1HhApwFWsflSJOwmz2xrDnaotRc0RUfGWwtI2ptxAM//58nM9XJhDbwe
 P48LcTC6
 xhqr4yTGUrQAGs1fwmvUpl6eonu6qwLt9QcuVaUZNmqKJRFvN1qsiQB+wB1OPQ5GcRvCj7ztDDZAU9CvxiUFDy+LLE0EFwKb40Ua2ykJjUuo83ft2cunGKtpvaFW2fBrF7Aq8HZnGsXu5M93KOK2Uwpmh7yOfHhjznzvtUd8rdcAFBi62JlhyVStN498f4zPLKTAQPyVtD6obWcevo5DguEsFOVXRlB+VBlfhXpizDE7IlHs5Ej9S+GVuPOeT43vbK7P0UqFYtTDZLhgTAQPX1zFRaPvssXhApcUcYE4QPHAHwKGu5nn9V7SE9Uv5lcyte//gKZgngFvqcERVqObmwzPXWaotmapq9md17bJmTkGVtRwKfIiwupSCq9R50nSYW/anLUyHZiv02yqQ1BVSFZLZNCckpHOvIRWSJjiJOAmhLlOJD/pMufMnu0Y1Uavd29ejmr5jZ7oJQ1wpkR2Zqb1lFbYU8wz5a9UkJB/1n8DMh+l1rzTlZJECzTiZhb96TGxIlGNkjv1sofOAgVpv4ktUEhMpgpIqA38g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Sep 11, 2026 at 10:08 AM BST, Alice Ryhl wrote:
>> On Thu, Sep 10, 2026 at 11:01=E2=80=AFAM Andreas Hindborg <a.hindborg@ke=
rnel.org> wrote:
>>>
>>> From: Oliver Mangold <oliver.mangold@pm.me>
>>>
>>> There are types where it may both be reference counted in some cases and
>>> owned in others. In such cases, obtaining `ARef<T>` from `&T` would be
>>> unsound as it allows creation of `ARef<T>` copy from `&Owned<T>`.
>>>
>>> Therefore, we split `AlwaysRefCounted` into `RefCounted` (which `ARef<T=
>`
>>> would require) and a marker trait to indicate that the type is always
>>> reference counted (and not `Ownable`) so the `&T` -> `ARef<T>` conversi=
on
>>> is possible.
>>>
>>> - Rename `AlwaysRefCounted` to `RefCounted`.
>>> - Add a new unsafe trait `AlwaysRefCounted`.
>>> - Implement the new trait `AlwaysRefCounted` for the newly renamed
>>>   `RefCounted` implementations. This leaves functionality of existing
>>>   implementers of `AlwaysRefCounted` intact.
>>>
>>> Suggested-by: Alice Ryhl <aliceryhl@google.com>
>>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>>> [ Andreas: Updated commit message and rebase on rust-next (7.2) ]
>>> Acked-by: Igor Korotin <igor.korotin.linux@gmail.com>
>>> Acked-by: Danilo Krummrich <dakr@kernel.org>
>>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> Reviewed-by: Gary Guo <gary@garyguo.net>
>>> Assisted-by: LLM
>>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>
>> This has a lot of safety comments of the form "This does not implement
>> Ownable, *therefore* it can implement AlwaysRefcounted". But I think
>> the safety comment should instead explain that it's okay to create an
>> ARef<_> from an &_ for this type. The fact that Ownable is not
>> implemented is not sufficient argument.
>>
>> Alice
>
> Yeah, I think for types that currently implement `AlwaysRefCounted` and d=
oes not
> have a new `Ownable` form, it should keep saying that "this is always ref=
erence
> counted".

Makes sense, I will fix them.

Best regards,
Andreas Hindborg





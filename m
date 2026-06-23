Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C427CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCFA6B008C; Tue, 23 Jun 2026 09:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B56B6B0092; Tue, 23 Jun 2026 09:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34AE6B0093; Tue, 23 Jun 2026 09:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C48546B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:13:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48E8F1404B6
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:13:01 +0000 (UTC)
X-FDA: 84911217762.22.11F5D24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE63D1C000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:12:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLxbvif4;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220379;
	b=qQCmJc6mmS1TGMy2zyxSqkmLB7SWfAYgZveG5fzEau8Rn2cwMzRu6g2XsE6zSgxvynuo81
	JCQ1znFZ9IvWup/zfzLJVDuOa5xMoF+XYi6vHETTHAu8MB/d6LWyQSX6K2UzEYjUyc9tDW
	vUP/GjIowz5AiNee7eSe1XLDAl9Xe+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Phdfqke0BCmhfc0oBfjNrqGUeVtsij2zEYdCciFrjo=;
	b=vNMoXlp9L2rvGGT+TsBEGUbJMngjtWpwnRlQxFBnacZPQ8pjCYlpqClB5QxNN3o194MNXw
	sowt9Q80jM9U0nfIqgACZqwlZDzOsamd7LV5MYe239ZsIIGSxLQnpR7TvF+8mL6HXFvItw
	CZcvpygW7MZ9VDCzyeB9lj+d5UjuhL0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLxbvif4;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5700460052;
	Tue, 23 Jun 2026 13:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D151F00A3A;
	Tue, 23 Jun 2026 13:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782220379;
	bh=8Phdfqke0BCmhfc0oBfjNrqGUeVtsij2zEYdCciFrjo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TLxbvif4peVjybpzPACL2R6+EOftsA4RL/WHYu2NfjIJb4nO+Rp0EnDsa5BN94xeZ
	 ZsOQDq2DKWAFC1a5u0Q+k8BO0R7+erFAA6/QI5e8JarlMRkJ1u1iSSIyBJ44mMaLXN
	 X1QixsoCdk60pFdaSEQbhkazqlAGZibmpF5HBHKZIgjmIAFxgPcXbHPuZhwsTNqEgn
	 vxr3cW01mAE9ooGjLqhBsA6PO7WQVIV2xEnEr/GYA0jnm0OyNpxbAFZNDY/0MCHbkw
	 XDn/gxkjeEeTsBiOYrsQx1U99GagLanBoJ8AUSBoZLbyuELioTYmiVVPTeWZdDhm8a
	 gBaGy/Nou1o5A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Daniel Almeida <daniel.almeida@collabora.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, Pavel
 Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev, Asahi Lina <lina+kernel@asahilina.net>
Subject: Re: [PATCH v17 05/10] rust: page: convert to `Ownable`
In-Reply-To: <ajKGv5ioLSassmND@google.com>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
 <ajKGv5ioLSassmND@google.com>
Date: Tue, 23 Jun 2026 15:12:33 +0200
Message-ID: <878q85pfi6.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: xbukb5bhpidg1ar6yhh5xw3xmiqq3tf6
X-Rspam-User: 
X-Rspamd-Queue-Id: BE63D1C000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1782220379-563410
X-HE-Meta: U2FsdGVkX1+AueqhCijpKs3xmY+KObobrmSaSPPdtsl652yCFrHwyJ0GY+BIZtITSJSv3oy92MLSrF2rc62JF/YM5di0jvmULUj+FH2Wsl+Y2+OKY7N1gU1qbqQcO2avFjL1mq3gXDw9lCTUUv86QiGvJgaFg4fmGl7wsIfGXYkcxedetN17td5NkU3dUZusfKh32igSOA7jTXPi7oSoIfbKzllO7dJdjbjvu/vuT5SJXG8r5DJllejcPePid9OHQjouQ6QRoRFPHwuPYQGkeQi0inYWe4JJaBm8uS8GuALpckTDgdNmjgHQ0MOYLT1K6BrRetfs5yEz6tfWVL+vwRepIbhEfUoTUGKz2IQ7r8CeWS5zIe6yJPjUB49sRooSaZKnRDNYRypJDw2ufqlSDQLBUQuWxw9Ew6odGJTaya+X19IqfVcZ1KENzbm48JkseIc4mE1TaB06kNUGuJVAKm5Z45IHn+bHaJzKqDztz5/N41F3d2L3JO9LPmqyODQUdW8sh+XS6vaFh5GlIydzSZ+X7YCcsmdfDsHlWdftVBIXmC+vGnOIhVGPlp9NJLqCvdp6dn5kCOcmNWNDE6+CG/KoMcR0sBYXQTOcdX4bUpbwsmvHTdheA1BNUgI5HsDQeQxp7D52I60xD0PfARZxDE8x2CltBgAHcrfb65UhYrqnVz/Jp1dxkIPFCAYDgeWfxziRf7oMDbNdCFgIYuQZRLpfR1WPTrl6uSdNrFtlGP8fU2o8qMcDbHoaiTZvxolZJ9p1zNTV6Nvnef/xhMgb3SYZUhnyFp/AkoaLgPrhwQIhG9k1+2bZFke86P52wEdVDDPYVA+N00V00lym3O+77WurzRq4nBe0m4snA/b14xyJEYLeiYiPx476GUL8VmNXRcnceYOzA516WXOCB3EgcsZmU0sexQBuaoPIG3ui/G6E2ik+blzXahNl7G1PgaKQngSx3MMIzkMjbO/8u3v
 ONC8JTz6
 trP0e/pC1nM1Wb1WjPIKhVi3zlWgyxinu+5YxtreiNaQ20+fCFG9lx+VwoMlQBuAWGrj0YTVlgVbM/ExBb0jYqLb/1ZCKzZIPJyrPYKny3D/UosOyszaAA3JwdO8T/03jyBLA6OwBCwUqZB7u9jMdbb+mecJCO6o4pad9IZS3lOLO7vPo0pB01ePTJHQVReyxj4ztNsKifhEBvbQ6VOA3EgXdreUgAhQ9sFXvagMZ0r2ymPHJErhGgJLM9wy2pxWKFgXRxuLNhNcwm7fq62Tj7qgdGi8Sj3Et2uIa+d+znGSs4mdKK5JVeruIaLtQIGeQz650TKmEgd7WbvyXD7Eh4qDmxNMI2kKyZ8yErb5Hk89ykTDFvyZGig4NJejk4BTGbnym+3B+gP4Ndt+gpK0YaIPc+rnUgarlbFvxRcPsKBvVR4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Thu, Jun 04, 2026 at 10:11:17PM +0200, Andreas Hindborg wrote:
>> From: Asahi Lina <lina@asahilina.net>
>> 
>> This allows Page references to be returned as borrowed references,
>> without necessarily owning the struct page.
>> 
>> Signed-off-by: Asahi Lina <lina@asahilina.net>
>> [ Andreas: Fix formatting and add a safety comment. ]
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/page.rs | 38 +++++++++++++++++++++++++-------------
>>  1 file changed, 25 insertions(+), 13 deletions(-)
>> 
>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>> index 3bdcee0e16a8..844c75e54134 100644
>> --- a/rust/kernel/page.rs
>> +++ b/rust/kernel/page.rs
>> @@ -10,6 +10,11 @@
>>      bindings,
>>      error::code::*,
>>      error::Result,
>> +    types::{
>> +        Opaque,
>> +        Ownable,
>> +        Owned, //
>> +    },
>>      uaccess::UserSliceReader, //
>>  };
>>  use core::{
>> @@ -105,7 +110,7 @@ pub const fn page_align(addr: usize) -> Option<usize> {
>>  ///
>>  /// [`VBox`]: kernel::alloc::VBox
>>  /// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
>> -pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
>> +pub struct BorrowedPage<'a>(ManuallyDrop<NonNull<Page>>, PhantomData<&'a Page>);
>
> BorrowedPage<'a> is no longer needed because it's just &Page.

I'll add some cleaning then.


Best regards,
Andreas Hindborg





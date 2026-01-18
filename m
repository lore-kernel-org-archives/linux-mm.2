Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14AFC9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 21:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9870C6B00D6; Sun, 18 Jan 2026 16:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9359B6B00D7; Sun, 18 Jan 2026 16:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841E76B00D8; Sun, 18 Jan 2026 16:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C7A6B00D6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 16:26:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF75359ABF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:26:58 +0000 (UTC)
X-FDA: 84346369716.23.834CD04
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 10B8840002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:26:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HW3OkAt+;
	spf=pass (imf11.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768771617; a=rsa-sha256;
	cv=none;
	b=4Bjas0X+w//MTxOxYifIaOrAqLVJVSwkuSZHaWokSV/DAylacTURtdT7C2UtPiD0taLLuE
	y+6QC9a7jZ6l9G3BGdG5TKuWKiGlLGASePCDa/J215KmF3WZ9GKLCwnkBJ7AjZw0zlvj79
	FFK/7C1BYKXOhTGJRwaqLfgjN+Dw5Sw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HW3OkAt+;
	spf=pass (imf11.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768771617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pnjSbcwTDJPyjARUCkOFovY6DECA+drGJOQrxdaQuI=;
	b=0TtbOK1+t/pDnlJKDITl2NCkvz8QKz8+Ut2wi9OVWYnF2FuWmg8ATGAeN1ZxIu86NfixG7
	Vfc7pMjQZOmK2m3aPxTvPdXl07+zfDk899BkR/JH0tL+YBg9Jds6wDF/U/yFPMZ1qE0Ij5
	Kc0hDuRWfR7ELwSqDUAE9oa5fD7ncJs=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4801bc328easo28184575e9.3
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768771615; x=1769376415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pnjSbcwTDJPyjARUCkOFovY6DECA+drGJOQrxdaQuI=;
        b=HW3OkAt+PjEA+GVmqGukuUqmuLLB67w7YlMg8i0+cP4+JpFwhp022rcKx79SaPWJe1
         sUiEi6BkZLX2S0O+dWYpHdZc9rRapcFEIN64ZruLWyhDkCRNhRP4RUqIZZGhHLmxjMfB
         60f8P/6D1sQIgHyPdq8fQEY0PXlftZNfBjKamQhq4q0hE8bGCKH1rJW2mhhlkkD4IS18
         JViTIMYI0WgNzaWuofr/9kj7cd4RqFwLf5UIKHaKl+FMpQIJ14bMmoxgDeKUjAu8Sm7l
         HO3u/cQlEN8Wu4lHUEZ2KZd8sIdpFq2/A66rLJYyCoseWezMFp2Csv89B1pY7qbiKhPp
         rVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768771615; x=1769376415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3pnjSbcwTDJPyjARUCkOFovY6DECA+drGJOQrxdaQuI=;
        b=SnpQjjeZMQa37jUIKaS7r+1bgJQN5Ftc3PJRFcpf/HzSs2zHfou8DK1VQjfQCoW6h6
         vQs5m/W1HwZ4nsdZ0zJp0Y0Av1m96fz5NZN/u6dwbTABlKdG1C6kHcrCSVOQxDzJbp+n
         wAWLoaUZHXn01YTM+P6MTCu9g+QqM9ePy0BPsbMPuA1VyPECS1vaJwo0LLcg93Ucdfaa
         M64m4ro91ABqlo7x+TTr/jk6tzjBC70/Vj87q0Y9zK2irMs4w7kpxA9htaJp6jgF6ypl
         LqZvKsXFZ8OLzs6Aa+rEBGXGWcWtdVYN7jJJQ9fHub9iE5yLVntavuGLEBI6g8iXW81V
         mKfA==
X-Forwarded-Encrypted: i=1; AJvYcCW+hDiVrhEcxhgwXK/Dc0zFFZxc09IQnvQ1hRmejgoxYR+Xj2ofkKYuHorgdFGgOW6XBt+9dq2WFg==@kvack.org
X-Gm-Message-State: AOJu0YxJOZPyLK1ch5gDk71DdE8Ri5tayBycT7Mf+DU4qPdsUF8vZ4hH
	L7O6me1qIXEdYPq1wq/zCqFfaQASakk5dzRBNpI+4ZtZidvuWZkF0d9S3YgTTB/p/NFIDuHwfWu
	k7r3ILPrjvBApVsaTmulR4lWt/q2C+Adq8HRkLjD4
X-Gm-Gg: AY/fxX6Nam0z2wnSLJBPxfrM6YHPQhTQQYaVVHPP7LHUhO79/SxcjscG9c7RPuauSgJ
	V3BO8Tz2zN/jMY7I2S77Vj44VB8QOLSaWkyjRjpR+ABwh7kd9dLf8IH5QxWKnC2Ydd9xyYBhbkW
	Rm7jObgWU3QnzX/6gKQqzMaLr0tPX4WzuEN+f7nxZU8IvV3JGh1fAlWMEHVq9vJky2+lqEBcYnj
	P24hLdVhJbQG9YI+dTVBlIfwr3Z3EZv4d2JidUlXeWRqKuEFqsTXgVVZaQhd5qSeEw0bIWURH1z
	DP0uVcwQHogPXj7JkFEbSgtVUA==
X-Received: by 2002:a05:600c:4e4e:b0:47e:e5c5:f3a3 with SMTP id
 5b1f17b1804b1-4801eb03400mr115935075e9.24.1768771615269; Sun, 18 Jan 2026
 13:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20260118-io-pgtable-v6-1-423846996883@google.com> <DFRU7CF0SSWN.3KMT2U5FWC2NU@garyguo.net>
In-Reply-To: <DFRU7CF0SSWN.3KMT2U5FWC2NU@garyguo.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 18 Jan 2026 22:26:42 +0100
X-Gm-Features: AZwV_Qj7Ytcb-na5JqnBbBWkuBfdmD0Fjpd7nsTfSWVrZPy72RgoS5eee2IXRDQ
Message-ID: <CAH5fLgixtTyrRcHE6i5RWE3_DgeY59b4B81gF4iDEu1shT_ikw@mail.gmail.com>
Subject: Re: [PATCH v6] rust: iommu: add io_pgtable abstraction
To: Gary Guo <gary@garyguo.net>
Cc: Joerg Roedel <joro@8bytes.org>, Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
	Deborah Brouwer <deborah.brouwer@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jozjf4nqsaos5wynzcbz7prngh9ia643
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10B8840002
X-Rspam-User: 
X-HE-Tag: 1768771616-394860
X-HE-Meta: U2FsdGVkX19GvOwHxbRDF3k8tbCus5133xbTwfsWQbv1+YXzySWa6MVuC5WHdIa/qjMmMhKaDzsLg7SAh4mCuhf3lD6lW4ZzrfFstMgpbIFSUzUqO1WaK0n9W4oR1oqxNejfO+t4aJOv/I2a3zYPcvR4ufgze1J4SUnsPglzMFb+50NesinNoeALCflZHWZPmjLchF8FHcs8PU9mMxTZujxhlHWQH+9AeeddI3VF4UZtuXM7HO069BRfMdLUo0orR1quDYRg5fuLItZjqhpjnYpSw5UvCZ1JTQGVKICR+UNr9FKwQV6T+BLu4P3WQPp9bOhN2VBJvW1hIpqmcvndpAS2tf8Y5eiD/zDgqr6pUrchbsXTyW8TmE4aRjX9ga7RG1TC75IqOSQJYaIUGjuoPJEZO2Dzdn3LhPHgFwtzqKuPpE1S4LK29PAffIM+qBQAEd1yHfaWC+yZzQ8++qlc363g7EnESwri9QgKogg/ZUY6cZPr9soKCOz8HqenvTPQ7DEQhhzXca4ROF/18pkqB8wk968RTFUqnba9ltomcGT8u9Qx6rQDgmW5rWVVDEe8rhJSOYyp1kBHRY0VN+QEcHBAr5J9AsvYsrk9OeHyuN3yeQftzy6kQf9dKRMO3lcIoIMbg1pZwckloYfl0JcHJUUQ/uXD5Qd+9a1D+n1neacIniALJXzMD0XtUMg6R/23rx8KNQBqD72D1aPvs8CQQ5BjPWbWLOa1LH3mjZEzmMzsmFyNjB2Wp6wdOIdzDgPOYLPu5GQ4XwolYhuLTTgI3j74fiUSedewkfOSwzttGFyNhKK1vW4O/1r6IhP/nRTq7XtnKOXZkW84jTV2TlIwzbrFV65SKso95KdD5AAHVjqvnNMLxVgUCSX2U3QIAshPQzVxvt2I73mFXdX1E2rhJr+sNmxOkIgERWVqPbqIdnOIbinoRSkZjAFr/M2yBIWiRES8tTYoe7IpRBnAMUb
 YKq/MB0Q
 q2S/K3ZrqR9LQoDLUT1gqPHDAQ7Bp7f9TSsNA6H8DpUnj9YPy5P+HbUHipGpbcjP3/jQj9gGc3+eXGHmZL8lAzJXt8lfGkIcvSiojfCt7sb+xB1KfViczQaqXWIdPMydDc06QzsRVmbWsS/UQc50nC4gF+VCB7yOzHluEyJIXgs5274O40skbsXopXJq3lfy6K5z3qzj6b4HMCg0udzp9Tms6OrEdYYOqNJr35/hNBA0JtnqJMHJ9lyaOZyBKiGdtwHuSF4ZOd5shP7UoZSARIBCcKjh8FZk+1QQWpHvptIZW1iEUEs0zIOK1TRyrgKWE8QOQ8PBTlGK7wZzffzw4RGESwZSxNd4dgPCKtaPh+NPk3rBMIC2ymRdPHEyWkuXBS8pp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 4:57=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> On Sun Jan 18, 2026 at 10:08 AM GMT, Alice Ryhl wrote:
> > +// For the initial users of these rust bindings, the GPU FW is managin=
g the IOTLB and performs all
> > +// required invalidations using a range. There is no need for it get A=
RM style invalidation
> > +// instructions from the page table code.
> > +//
> > +// Support for flushing the TLB with ARM style invalidation instructio=
ns may be added in the
> > +// future.
> > +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops =3D bindings::iommu_f=
lush_ops {
> > +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> > +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> > +    tlb_add_page: None,
> > +};
> > +
> > +#[no_mangle]
> > +extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut core::ffi::c_void)=
 {}
>
> Any reason that these needs to be `#[no_mangle]`? Would just `extern "C"`=
 not be
> enough? If there is a good reason, I think this should be noted as such (=
note
> that `#[no_mangle]` would be unsafe in edition 2024 so we probably would =
want to
> avoid using it if possible.

No, it's not required because these are referenced only via function
pointers stored in NOOP_FLUSH_OPS. In principle #[no_mangle] may be
removed here.

However, keeping it doesn't hurt either. There's no particular risk of
overlap with other symbols of the same name. I won't send another
version just for this. Joerg may remove it if he cares, but I don't
think it's a big deal.

> The rest LGTM, so
>
> Reviewed-by: Gary Guo <gary@garyguo.net>

Thanks for the review!

Alice


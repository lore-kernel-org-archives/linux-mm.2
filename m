Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FA10106F318
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B5C6B0132; Thu, 26 Mar 2026 06:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC0C6B0133; Thu, 26 Mar 2026 06:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9356B0134; Thu, 26 Mar 2026 06:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD8C56B0132
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:10:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BBB5E1126
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:10:15 +0000 (UTC)
X-FDA: 84587793990.11.DEE2E02
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id A934A80018
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:10:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HddpbqIw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3AwbFaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3AwbFaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBGicU27laianFvyzY656GHLSJPIgkYXNKTwZ0wPpek=;
	b=IpmH5vMOIwbgJGXRGYtlaAL4Fvs5CWGpNmGeosOKk54ljhx3IKNDz06vevLNVEzofgrwUq
	Bf1x8zNyaxVSLB9ZvRyqX5GIbCm7ATKk4L3Vx0tSVv5YaYytw+cJBSNNvPs6Pu2eQm4Bw7
	cA/V9qKM1WSs7QHQZK8iUZasUARoClA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519813; a=rsa-sha256;
	cv=none;
	b=Hyk2vBSIB+LIbbWMEW/X2wQQ/z2MSL7UrliXzx1EL0WEwRB0kCdSYHnFYYKgnRtRnMWl1C
	xrp/i75qfLhbAfQG7GaBEME63R5zfEGVsF8ls/ryBsEDp7Eq+KXVAm6WtnfL8bebfJNO70
	WcUzr4ly3RL/B/YV20r1XX50u5OjOxs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HddpbqIw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3AwbFaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3AwbFaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b3d3d2d22so808614f8f.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774519812; x=1775124612; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBGicU27laianFvyzY656GHLSJPIgkYXNKTwZ0wPpek=;
        b=HddpbqIw5b53vih9TNDzZThBLMauPeiKzC/780lknT2xfwj6jU5xqPttzPU2/kw5Jp
         gakR8heUB5AJcSXe3AtgBSVEDiktYQE2kuns0iv91Md1owTw1pFGfR+eXuKkfKii/Ip8
         TwxhjgvW0iA1djco9mYKLHrISDN3BBs5ekZ40ISBLpE+6g13lfTrCzSMRZtbZ5qDaA2j
         TdHtV+MKBuX+hpHsI3JcG9TsJnmWgH1I7/yYGFzpVqEp47qOMIFbscOOdJC8vThCwqRD
         yMcgL1eLkUiQ+Jms7Jby4uvUEGA9HW+qbAj+Utwgblyuc01tmx+KNu3NsYedTlBDKVJH
         Xisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774519812; x=1775124612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lBGicU27laianFvyzY656GHLSJPIgkYXNKTwZ0wPpek=;
        b=FMjn4mFV8WM86zu8w40E1coTj2j3Uv89fGzvqIAQ03dGF28z4g6il1dPb5tAHp8qmY
         xoztapcsf6C/s8XJ2uVbm39ylTxzRPBlZ0s0RRWVERXpo0tXAksdwkD+onoDa6Fay6tq
         amtMe3MnYtbroJn0PAAMvKDJMwa5ZO2gQP1bwwT9OzlX4ReIP05hOmu4JdIb+9WQaLUV
         XCEOe8s7bcO9hi2lYEzm+CuVS30TkTKw4YfRCxXs4KRVIrChuAwy662oJXCYP8IAXW7J
         j/3N+V9GI05b77IuB+ip/h6VfyRqrtTx0dd9XYJg5N7UPqcYZ+vMsp5BsLKesadNuk61
         LrPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7PdJHBVYfLwaeBDMNXqhxzLHSXn4i3Auip6JbYY3l23evWPUbW4JVJ0brLLAeiD+xt/sy5t0kvQ==@kvack.org
X-Gm-Message-State: AOJu0YwBQLXuoypAZEgPGeWNwtjQTRc4Wf/4hbJSmDiG1YG84jtqU9Dl
	jp78QKIGRpi1B+xNOcRo52BrlxzfvETGlN6cko3ogRq5FJHh1fQn342232GjYdOFlgX3HLCVTex
	IwNwpYsn1O7+QT59s4g==
X-Received: from wmoo2.prod.google.com ([2002:a05:600d:102:b0:47d:5bef:a379])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:890b:b0:485:6ec7:2df with SMTP id 5b1f17b1804b1-48715fd50abmr80350625e9.8.1774519811752;
 Thu, 26 Mar 2026 03:10:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 10:10:10 +0000
In-Reply-To: <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
Mime-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
Message-ID: <acUGAsjYvNvTEO92@google.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
From: Alice Ryhl <aliceryhl@google.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org, 
	david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net, 
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: A934A80018
X-Stat-Signature: mgq3bk7b9sgiote9iphmpmpu4ri4mq3h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774519813-654708
X-HE-Meta: U2FsdGVkX18BwAwuQ4XpzgIu33qegcFqqLObbNF2dp7e7DMMCo4nSG8NGHy4vJHvxLyy5DMRPtLv3/gMo/YwGhRpQJ7NIPQGcgmc6HCtQQzryQlJwdo1CAI+65UoeDJsHKyAVWhMUKMoHy0c4wMYyb/WKlHb2Odzrv+t9oheZcQnbUSclSDpyQG+AtA0BpUMgEpTvgxAeXCB6ewtvQWHUQsO+e43etYYiK823xuavfciZLji6iYDuCZGVp0DTo7M53XFUaqmxgfYAjQBdJCkvJOi8pzPGMzRPBvePnbCUIlAoyTXq3l0yj+0iEyvk+RpTxXIELKNO6l7rZx96kpS0mlWyPOdw+eKQlbRrbsEXEloDqSs3mr42JSPNyikbv/kSE3iHfJWNOUm0RbAXXeMmi0a7ToiCxZp2Y1X/xhd9pIbGVmHHvDjeES2Z0JC2qp87fTmU/uliCyYgeQxbnqSmJu5pmmfSBDWjjvXAztm35t+kwf50yiQ/8SW627E6ovh13vFYW2YY7E9yJYRkOKnkOKxN89CJvo8DYUizHH41u7YCYdBW202BGqr3st1kmu6CCqFPKZ9xS7Xow4l60V0yuBTmZUdf4vH2Y81zdzhb8srA8ExDjANydIdFTkKjB+JC5ulpOTOIrhYClG9JAx79hFnK4wVd9REGg71OB+6rq+z6B/wqTh6+M03JHaBnKrqgghP69Os0AaIsSvUD23pbVQX+ZtdT6YRQkct0ZLigjZEmWdoK+ONufRNpLgyl0XUiURC/d6jlQCVfZKZxh/nzv3Pqd7oZ3uP7U+m5Fn+PSayjti74XmnRzeRR/ON7KT+sSz/U+fhd9zIINQkW1eCs414DTmGGANRHl+kCp08QIg38ftKJwHuSBmqjm2GiMwzy8WAH26imGFBDi6jrq2eWTKYyOrUIc4EzRkiQvIS8unaEOOc6vG8hVvOQQBsp1ehopqb5+WIsS/aP9naS/m
 5B+qxQhN
 5UuW4N/fUivGqldsdkBLj98dNc69Bz8SifIXmaUPb2wmJr20YvJj5tQiidBSw58L+0xhKCdlTFUEg7WY5uXvPD8BXLHIg0zitiQQdPWhsNIYfsM+uRKB8UULy0eAxgaLR2QTShfa2GFWZVocb0jdMbU8I4ZD19vzhubIju2TXTYPyCDnuhLFUSQSqDVesMEVCBxXEE/riQRzoXaODWMyrJzURUfV2aFvfY4rVX+tmOwFQFrjnC6Im8vV8e0xewrUaqzh5EX09MVfH+bMfeCtop1EFFHBh+BXRm56XXnIMXhRi1qRWKiJZ20XgFkhf5M1GXQyRCaL6TtOg5dY6NYOUHmzK+F2y/Uy7XhimagKPg1hhA98PXqq4r9GC2+yGMUPiOjQaQ0cOsrjvK6LbQXGiIm1jRfs5vb+8nMfqDuaKRbG+dvA0zhxOWJgGnrDpV/jyJvdg+0D1jHkyEeF1CEfMVqJZ9VMIBKLPrXQ0BXISZizAwFKn2Ks6ihyLwqj9GYKchqDoWBbKkY6JMxqWehnFRlMPbng4I2Kkqc7HrkIHcdPxJ7mnWRm6OutKrj6wam6ZoqJt8q5+Swtcf3yXx075KrcCk52rVy6XlujkcWDf7+8F2TA3AeVK6lX9JerE46LclY7entRMwjdjaClwCXUKC6/CZSqwke0fH4330Uvn0yBmF+lTGESLJYkBGri3Y8o7QdgWOju5UljO2UsFk4SJt4GQ8SMI+5pcwJldWBbMxy1gT0FA2IGx7NR03g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:03:26AM +0000, Russell King (Oracle) wrote:
> On Mon, Mar 23, 2026 at 01:03:27AM +0100, Miguel Ojeda wrote:
> > On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
> > >
> > >     On the other hand, regardless of whether we fix this (and another
> > >     issue in a separate email found thanks to the UML build), we could
> > >     instead add `depends on` listing explicitly the architectures where
> > >     this is going to be actually tested. That way maintainers can decide
> > >     whether they want to support it when they are ready. Thoughts?
> > 
> > Another one for arm 32-bit:
> > 
> >       LD      .tmp_vmlinux1
> >     ld.lld: error: undefined symbol: __aeabi_read_tp
> >     >>> referenced by uaccess.rs:349 (rust/kernel/uaccess.rs:349)
> >     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
> >     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
> >     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
> >     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
> >     >>>               drivers/android/binder/rust_binder_main.o:(rust_binder_main::rust_binder_ioctl) in archive vmlinux.a
> >     >>> referenced 36 more times
> 
> Why is Rust generating code for userspace thread accessors for kernel
> space, where userspace threads are meaningless. This is totally wrong.
> The kernel must not reference __aeabi_read_tp().
> 
> Note: I know nothing about Rust, but I know enough to say the above is
> pointing to a fundamental issue in Rust for 32-bit ARM.

I noticed that the Makefile currently uses the arm-unknown-linux-gnueabi
target. It should probably not be -linux target to avoid this? Probably
it should just be armv7a-none-eabi, right? We gate HAVE_RUST on
CPU_32v7, so we should not need to consider the other variants.

Alice


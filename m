Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3164DCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1428E000F; Thu,  2 Oct 2025 18:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852248E0002; Thu,  2 Oct 2025 18:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745FA8E000F; Thu,  2 Oct 2025 18:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7E88E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:32:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 024B014056E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:32:53 +0000 (UTC)
X-FDA: 83954625468.10.A9953DC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 25D75120004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:32:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1rNlEFH6;
	spf=pass (imf29.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759444372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUtPgFs+a1OL7nG/nqf9VG8T8Iw8/JxdJFSGGo+Duvw=;
	b=aa5Jg3bEe4UUQv0fdmJ1MIAoQ8x1fqv7z2N95KU57OKW+u0+fX/JSwqtbmMBU6wirssKrR
	f09/+ESezHzkmcJ3uNlnOpsKTFLxzYBd4Z3a+OJvXXIydy8RBbTc91GX7bU9OFPJyPLegv
	DcEGZcsn0uhje8awPfimw9wOJ4BBrMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759444372; a=rsa-sha256;
	cv=none;
	b=lx7d6LIT5kDE0ucqAoSAD67V0bPHTQOTCKaHziQuo1uWNt6a0AIdd/4MyQOn2t73Vhmf0A
	18Ecf3exNEpyuCQ7fx1TMpvTiS8ipnhjUjPc9T4u3dwz9XgHxD3lP0Qf22X/rUw1H6NvaR
	rI36sJrBtwtCUEFYw9melpjyzJwCm/M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1rNlEFH6;
	spf=pass (imf29.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so12436005e9.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759444370; x=1760049170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUtPgFs+a1OL7nG/nqf9VG8T8Iw8/JxdJFSGGo+Duvw=;
        b=1rNlEFH6KDdabVftZJHyd9qYsBhk7YlwjPwCvjOQBjYCxIEKiUEvfftE4QuT+AuQoF
         RN53EKU/k9rbf8YgCI+UcaCsHRclLB4j6m62OK9RcU0t2xGPeSl6BHWZ3qS6Ig42v5Zs
         R+tk5AIVJZWoB8OdKfnjzNyTOS+WXmL0Xxcj3s3Ji3daUJM66dPP3idZg6fP1CJFHn5U
         ROt1GCR/+rEJ6zI4PV0bHX45I4X+kjHL4JQiiGtLrWU1cNSexTODspFu1L+mXZ+MezC2
         XQ4xoFn+Y51g90BxMNeakwDeVljzIlzNDBb0pWPfJs81vBjAa/84ghtsZzhvQLWgK7E6
         rKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759444370; x=1760049170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUtPgFs+a1OL7nG/nqf9VG8T8Iw8/JxdJFSGGo+Duvw=;
        b=R6R8urZUxo7sEmvEMORGlqwl/qDiOqlQyNQsFZG8QlPu9E3w3PnIW58amDJAw3FDOj
         ZtqIyNHFlsPp1TBQ0tWnzm3QZ5cGq5InSIYMgB5wMwxCBpL9PKVw6T7PT64LSlJH5J05
         g2d5BwA3mh7/H9EgdnlXS8f+Hj9XwkbGIqQpj3lA/VbSAPoGGb107KB1r+oEBUIWh8pc
         zXY8BmrlCxsxSYdjsMad15upAdC34o8cOTFABlgD5wXQApr9naFDSZpOM0g7J0MTsMWs
         kLafEE/hdiGniLmRQz5ThrsKjXS+tGNT9DSIEcUhD1uQI4WVYTqWlOJ+TD8Ec1A7w2du
         mRTg==
X-Forwarded-Encrypted: i=1; AJvYcCUTZFG+m/FOGoEOMpqlTwUtv9jQhAX+CaH8Du3Pd+dwOoZhy4rtDyz0rLz8Qg/5x3pFYWklpjUubA==@kvack.org
X-Gm-Message-State: AOJu0YwU0JSZfoMCoKfnzBXfuhvz+1R5cWmLY+HmXyvCKmRINOaZjAmF
	fjwlmTTYJkzpO6u3RnSrW8ediVtJkFVgAWucRd/3S3uC0Ti4wea1oOz7sAIMGV+iQMD2JykgRP5
	wimNRAKK/PdiKVMFHGqalrPhAAJsQvBbEmpHuWnOl
X-Gm-Gg: ASbGncsOnS+3edG0pJtP29XdgMqILgsFkluUBRzV7C2zVP/3bWPB+Okee7OtklOtR9l
	TrMU9LgHWmj2W1nlGKyB/dTrtSO6L5KXUOxE61ZQpP3IQvQD4oFrtWN9eSc6CZy6+aJHg3UctV8
	hwDWWUVXdYNnYv0ipvrGYZsK4OylLVfoAq/A2LwsRd0MS8fpl3qw33jenQODcceBUPzQQ+wLABq
	A9QtChEy0x8qhO5WCDlziUYM1urkIzoZBbR00s=
X-Google-Smtp-Source: AGHT+IGdWGPoz5PKrFGJEg2IcZ3ZPwnel+t94IMPQoWxzpXWAW09OSY4bzY7R+GccI211DbppmE2wBVRR005RgsZt+w=
X-Received: by 2002:a5d:5d07:0:b0:414:6fe6:8fa1 with SMTP id
 ffacd0b85a97d-4256719dfa1mr547619f8f.38.1759444370371; Thu, 02 Oct 2025
 15:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com> <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
In-Reply-To: <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 3 Oct 2025 00:32:37 +0200
X-Gm-Features: AS18NWD-5OHn1TKOTve9_yuzsaz2MvZIT_RmmhqjCCsJ6y7cPsY7xJ_qWzQC8XQ
Message-ID: <CAH5fLggBkR=n-8UfVcOhHTQ-gda0VLBpaK1p5aA=3s=tWSiGRw@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, kernel test robot <lkp@intel.com>, 
	Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25D75120004
X-Stat-Signature: 3zk5kgghoczqu4ys7e6th146mwjiwgsy
X-Rspam-User: 
X-HE-Tag: 1759444371-120506
X-HE-Meta: U2FsdGVkX1/tihxQx0KiArtI9g/vjQUV1B3t0w8bGJ+P+AUIZvFxtrHGe4HEhMM0jye/Wb2u7JpoHGh9RfUUO7se+7dWfCwIWBcRWiA8Bh24AoWSdWM+34tWayDnDt091ThhExRqVWQ8EQuGei0lG6+6CUaJZf1cYlEfAA7Qyq1synJr+yjDuOkSgbZJ75EUazvUY/biwwVKqkFULZAqXSfq7TfDppux5skacS3SDX9v/5sfTFEWpLfe5YKiHS3qSk4FGoM6ZS7ql04ocAGTCoTKywgUxBX4mBD7apjKIYGSrsbJlKP5UUZdVSR/POkRLsYwVmn5+m/vnWYMz4iDZQcpFE5L4SuO/+ru2V1wlExiEFT5O/EzqJInJVLGKlILeKYG9cAIdV4jTDA8Gl+rjRqN172Mtn98I5UYQFYXIVjR6nbkvPBSb2FtP/JZjFpA8NUxFAaF5hYReIWY5her3Ek0ROtAnrlpddsAQzJEAMm+nJb0TR3AZZV1V/6ed4P64YMynI2jc8GxGeGeFXhjCR7PAcaFV7d6bSZJgqIIwxQGI1HCdfE2FyOcJ9JqcJ5JH3cmNDf+FMcmLKXwB/Jv9YXfwjmMf/GfxJWfLXWw81B6XdvAjvEV4Em2aOgVXfuxTSZwhYHVRSPFBj0KxBRdHHNruebNC6REXCy7+ilHTPnXPUrvBLTLZTPZfg/h9KxBTBKvTkzMJt2ZtNmUXnlraIcOm2RGLzwrz/jHKm/BHtUjG+0bBO9NpMwW6mIV7JXMeI9im7rqJYUGOltEuW/z6m8SUPSdjN9mibm5clbJ3/N7NP7nZsBF9zPDrER8l7HdtYTT9hf5xfipgv56piXa0aIjlthRD16NU7LCoC11S1mhb/abYCTblYaHbqb/Y1/+/v7R9Iu1AI5i/xD3M75ShkhizILJQzcFitKkW0BrWwLBt0hqPiUkGQaFPL/gE5ipZCY5DrKIXCxAEFrSUgg
 Mqd5Ag32
 1vmZaL1EFXA7Bw0IWZ82722GN9pGyOmTUk4ILZRjKjZoxGyFccrK1bJEGJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:28=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 2 Oct 2025 23:42:59 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gma=
il.com> wrote:
>
> > On Thu, Oct 2, 2025 at 11:19=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > No idea.  Let me cc rust-for-linux.
> > >
> > > It's a one-line patch:
> > >
> > > --- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_mad=
vise
> > > +++ a/include/linux/mm.h
> > > @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
> > >  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" =
and pure PFN pages */
> > >  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this =
vma */
> > >  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked thi=
s vma */
> > > -#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pa=
ges */
> > > +#define VM_MERGEABLE   BIT(31)         /* KSM may merge identical pa=
ges */
> > >
> > >  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
> > >  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit =
architectures */
> >
> > Yeah, non-trivial macros confuse `bindgen`.
> >
> > For the moment, you can do e.g. [1].
> >
> > Other times, we have changed `#define`s into `enum`s -- that also works=
.
> >
> > ...
> >
> > --- a/rust/bindings/bindings_helper.h
> > +++ b/rust/bindings/bindings_helper.h
> > @@ -106,3 +106,5 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D XA=
_PRESENT;
> >
> >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
> >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> > +
> > +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;
>
> Sorry, this is rather annoying.  Rust is breaking the build for a very
> simple patch.  Many developers aren't rust-enabled and probably aren't
> even able to test a fix - my attempt to get a rust build setup working
> didn't end happily.
>
> Jakub's patch fixes a kernel crash and needs to be merged into mainline
> and -stable reasonably soon.  But that is now blocked until someone who
> knows how to fix this error and how to test it gets down and does those
> things.
>
> Jakub's patch is present in current linux-next.  Can someone please
> send us a fix?

I don't have my git-send-mail-capable laptop with me right now, but
the diff Miguel shared that adds one line to
rust/bindings/bindings_helper.h will fix this build error.

Alice


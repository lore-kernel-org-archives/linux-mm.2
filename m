Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32AA7CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 20:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8FE8E0010; Wed,  8 Oct 2025 16:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691078E0002; Wed,  8 Oct 2025 16:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEFC8E0010; Wed,  8 Oct 2025 16:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2318E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:46:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1C0A1DE6B4
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:46:33 +0000 (UTC)
X-FDA: 83976130266.03.C6610A8
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE8C418000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:46:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EzJLqeE8;
	spf=pass (imf24.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759956392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxhkbVa/uEXngkfUo+dBA3TFbsCdSBF++Qy9JKTTAdY=;
	b=uZG4lItdeTsvFeYMm5pB9qPBoPjYsS+PJfqJLUlpa+EB0zQQbIzarCaucF07zLigsUytg/
	wnZWTuqyza8tcPO3uAcGxmvvD6OhKRfQk8DISnfHZFMEtUy9+tjixXTK7+Mkp5oI/F7YzG
	qye/2bp+/0zVlhqsMa8T+axR/oUWZQY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EzJLqeE8;
	spf=pass (imf24.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759956392; a=rsa-sha256;
	cv=none;
	b=TXelaM1HD4Y6MOFf0Dw2gAc2jXK1++6uYPOG2FOU3olnZkZXg8GpoRFgFFL051HwDWKFNH
	gQik2h5nkhyxbHKWK2xXRFg0t6P8Irtdp/cTXgqbXShFXLx97rACiz0n9AbaUIGayqtzpT
	qBREnuUVpGAhGQlAEUi1YzIU697Kd6M=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3637d6e9923so1811251fa.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 13:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759956390; x=1760561190; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxhkbVa/uEXngkfUo+dBA3TFbsCdSBF++Qy9JKTTAdY=;
        b=EzJLqeE8WixDH88KsIaL/ld2u3Y7Nh31HEzBk/M/vqfDtf2Xff35JTeqmH6FK6FO2S
         SJy3NDRfChH/4zKHJb4MC14yyAqLEQvQA+DTmJmpawLwBUmmOBKA73ROu6bWwMjtUEEj
         CKRWbQROPZuBMBqGI80Gy01R0AQpLNW47DamiEh3R+6eOwhP3vGQ4eERGMHO4q0MDllc
         LwIcrJLYAXToDxqCvi6rjJHMfxUuUOJ+/g2Su2amB0KBYpZzcwE9WV47qwfzTHm0fgEy
         o3Ovf7OVmJ0Mg3OYDXc/nKzrqLZbQT1xxAjLTAAIDDPIcKxaQFhZ9zQRj8zt0zmpky9z
         S2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759956390; x=1760561190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxhkbVa/uEXngkfUo+dBA3TFbsCdSBF++Qy9JKTTAdY=;
        b=J1EVJjm28Vv/B9/9QwtWy/9qam9Ao3iKYWwyyBZYXGK8OI31DcOhmiq1H5yAzO0I4d
         KVqAO3s0EHVogn+8s8qD4rINZKFqPO4+RLdVcXmPPRxu4R9SpZ2a0pQNI8w39l2rfNcN
         i7skbHoBnxS/fqA583hPq/4tPEH3ojAuRtt0MlmW7PHfQTcwHRFVUuDmaH670mDT+ldk
         AJXcO4v86pCIcTXvowc+sQ9Uj7XPD+qXJ/YK3TvidFRgLJJZaLJ3rvsUtfPIKKIogYN6
         E3S6wvo/7g4ETjzBEbZmF0SbGD3sU0fgvyoFX2wY2XukT663XT5dvuJtW79r+z8Nlo+h
         UuDg==
X-Forwarded-Encrypted: i=1; AJvYcCWWdG/9lqclltsqrDjcR3dEPgehYjMY5kVzVjX479I/7pzfCyssjA75pvOD+KZ5KY6hXXTykKs6mw==@kvack.org
X-Gm-Message-State: AOJu0YytAV7O3M1agzXquTKP6Buw2k+dhtjVWka07u259uNohBGgZlz8
	K7zcAAXOQXyHYVMmt8ZB9Wf6J0Xjkfyur9vSszsv1vQqJHjVWkHG3267XIqvdJhMY+qvi+FwS9V
	dLqKRv9npt/0N9bijckZyAwyniZvKWCI=
X-Gm-Gg: ASbGncvKw5FEJj+ftwjjhDpaA1iZdXDM7U00xPui9xAr4iugftdvDNPMvqk2GstDF5R
	aAB9M/cf7dXniT/aIjTAxmnF6yRqu+Yg9eS75vZh9ap5v42pHTwJlnDYEp5UxqlSlvUmJrl1Iai
	HEeJUuPlkO3D7TJ1gMNw8dG74uAifEX/ByLtKerR8//NWd0we6uu/Rz3xrOxpomsmE8Ky67iUY/
	BgN3yZNTXzYlcAV2Gfun4GsBsP1XKyXqYBfejy7rgZUGn6pI/hJnA7wORK1L2AkuB8dUPrZUMki
	RdZU7kX+n0nnXT0LX8HUnGO3YsBkZRgXqdF8EFJ/vTmd
X-Google-Smtp-Source: AGHT+IFJhp/tSRDD6lbiN5FsweIVaBTWj0SEmB759OfG5ef5vYNgy9NHDR6XMGwyweNedzBOPTYTzZLdyknCujsFpWk=
X-Received: by 2002:a05:651c:1992:b0:372:8ccc:2629 with SMTP id
 38308e7fff4ca-37609ea7f6fmr12329021fa.34.1759956389715; Wed, 08 Oct 2025
 13:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251008124619.3160-1-work@onurozkan.dev> <20251008124619.3160-3-work@onurozkan.dev>
 <CAJ-ks9mtfVmP+SwZvBVuQSwViiqo2ZngSGQuU5Y7A-Q_JSwjKQ@mail.gmail.com> <20251008225002.011378ed@nimda.home>
In-Reply-To: <20251008225002.011378ed@nimda.home>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 8 Oct 2025 13:45:53 -0700
X-Gm-Features: AS18NWCgbeEJXhSg6SR3UxIn3ImEaYtYHA2yKjUMu36X7Q4evawJbCU6rPxkSEU
Message-ID: <CAJ-ks9nMziN2LU=T=XGhV8xau6UfGXOMZ49+2Lrt8KGbL7Qngg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
To: =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org, 
	linux-kernel@vger.kernel.org, acourbot@nvidia.com, airlied@gmail.com, 
	simona@ffwll.ch, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EE8C418000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: omy4ycmbo99ng6u1r5wfxeyjjbascqhj
X-HE-Tag: 1759956391-13327
X-HE-Meta: U2FsdGVkX19kPRO7H/JR/RWjNvuTewaHEkrhEKQY2mWGLsQ8kTk+BOWcq684hiNT8fSigzL6JnIIG/ZCGxjGH9ykUsIYUmnfegqkWvqrU1fda/SbtwhvoGjxMRAQqlRqwNInJ7yqo3tF874LVKKhCe8+CTLY+X+abZy4vQyeaM1b6IjdfnH++wNnUiQyQOAmxcdmMy05fMD144Qj9hOKuwEhF3f40K/MM/bVv+E7Q2cvz/JF6kmTo4z3CcH6AGAj7FNohl42TgAAZnLIxnWiitqu6DVsSLc9Qf16qiNkYTUpXf05dSI/w7IXylxdYDpbZMHb01Ocrk9VegQM+anTh+lcljjmpt+SP8iGLJa0CeG8IC0tDTXa9pLsfgx/4x73k6K9uX5KgZbv+1my3pg4sI+MDtCZ2HQtBySlo/uDwkItYTKVPr8Cd1N2vQfEVeECzbRDdMIbYds+OIO0Oa3n2Im8HWXaGB4k2alF9/7JpZquqPheSzmYHU8Op3pSLHiYyX/u/bcMiArjDsROJX9aAQmHd3PMGN3RZcWcqLklgsc/UwZa/MvnS3/00Ig60QmuzvD1g9qzRlyOnQPrvGQrdG9eJvmG5Bs6vDTK6oO6GF2lpHhqWVZo5QVEDuiRnL7An5w31Q6znQC+v/3Nm2a55tOkPxCh4HAvvJri6GwugAvSPsTsDEMZyndoBmikvSNKL+LxAFyfAO9omuKkbPYjQ+7MoqqlS1tdIrsIqXR2/7+w6ZNltAaV6kE2j/FdV6eNS3/70uFwRtLL3UHTPp7uyQs0H/J31Pk+yuSnpDy4L3HrWKDtcubSJHqVdS7UvXip1hqs17FtA0bzASaoY9kpXUm7+aC6xM8NgQ9PwXYolywCptZZdfANAJfblPD9xq8oxXWywOTsnxe3oW+ZTA/NLz+uC8uIB3cME+SDJfeQnQKXk8bjYQUTq6f/pLR9qSE3tCjb048IcUBWyFV/Z2f
 Nr+4DHHx
 8yroVfXIwTMVynVsHqtPn/pbcjBVIio4pKKDL8EN3VGuAwkcuDH6+cIaHvCP9H7v18eZxhVJZOGUr0UVvJ6ku45GGMD31oTNw5AyBmpQhkB+OI3OvScn6uAF0DLUIehzOf/RO74hu1f6ChQfAMHuOdS1p4sagmUXsq73V+YtwOWiRTsv1ThCsykBHz1j7V+sLwPGh2WvbeZ+sabPCrVgQ4DAbXb7dQDa2WhnthSSjIO3AWuaqulDK7NqSPVdtSDLhN8iOlwu4rz68kdq+TwCKLwt3EjB+eR0vuV1Pp5HoqOs051e0akX+NaqFF0t5ATrRZfw5MA+HLk0w/uuF6uS0mNHewW2RKOUPgc+dQErozk3FxXplMBU0rJe/7N1dZiG0/55A26tAOqy1R4Vnfsuj0pyQBNa1bcS9pTtvXQk3MLQICxUx3kaRw9i6N2iKayC5UnelSYQYCxuEAyK9bRQkoG9knAP5Gql0WiGMnO4cht/kGtLaBM9GN3fVnX6IyRgXGWkFknHuQ/mjYcr3uOUEo6pB1uhJu0NGwNTn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 12:50=E2=80=AFPM Onur =C3=96zkan <work@onurozkan.dev=
> wrote:
>
> On Wed, 8 Oct 2025 09:59:12 -0700
> Tamir Duberstein <tamird@gmail.com> wrote:
>
> > On Wed, Oct 8, 2025 at 6:05=E2=80=AFAM Onur =C3=96zkan <work@onurozkan.=
dev> wrote:
> > >
> > > Implements `alloc` function to `XArray<T>` that wraps
> > > `xa_alloc` safely, which will be used to generate the
> > > auxiliary device IDs.
> > >
> > > Resolves a task from the nova/core task list under the "XArray
> > > bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
> > > file.
> > >
> > > Signed-off-by: Onur =C3=96zkan <work@onurozkan.dev>
> > > ---
> > >  rust/kernel/xarray.rs | 41
> > > ++++++++++++++++++++++++++++++++++++++++- 1 file changed, 40
> > > insertions(+), 1 deletion(-)
> > >
> > > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > > index 90e27cd5197e..0711ccf99fb4 100644
> > > --- a/rust/kernel/xarray.rs
> > > +++ b/rust/kernel/xarray.rs
> > > @@ -10,7 +10,7 @@
> > >      ffi::c_void,
> > >      types::{ForeignOwnable, NotThreadSafe, Opaque},
> > >  };
> > > -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> > > +use core::{iter, marker::PhantomData, ops::Range, pin::Pin,
> > > ptr::NonNull}; use pin_init::{pin_data, pin_init, pinned_drop,
> > > PinInit};
> > >
> > >  /// An array which efficiently maps sparse integer indices to
> > > owned objects. @@ -268,6 +268,45 @@ pub fn store(
> > >              Ok(unsafe { T::try_from_foreign(old) })
> > >          }
> > >      }
> > > +
> > > +    /// Allocates an empty slot within the given `limit` and
> > > stores `value` there.
> > > +    ///
> > > +    /// May drop the lock if needed to allocate memory, and then
> > > reacquire it afterwards.
> > > +    ///
> > > +    /// On success, returns the allocated index.
> >
> > Returning the index is not a very good abstraction. Would the
> > reservation API meet your needs?
> >
> > https://lore.kernel.org/all/20250713-xarray-insert-reserve-v2-3-b939645=
808a2@gmail.com/
> >
> > If yes, I would appreciate your tags there.
>
> It should be "allocated key", I misdocumented it. I don't have a
> use-case for this implementation, I am just trying to help on the nova
> task list:
>     https://docs.kernel.org/gpu/nova/core/todo.html#xarray-bindings-xarr

I think implementing things without understanding the use-case is a
good way to build the wrong thing.

> The task mentions "generate the auxiliary device IDs", which should be
> the returned key, right?

I dunno.

> There is also this reference [1] that shows that the returned key will
> be useful.
>
> [1]: https://lore.kernel.org/all/aOTyVzpJNDOaxxs6@google.com/

Sure, it's useful - the reservation API also exposes it. But it is not
a proper abstraction.

Cheers.

Tamir


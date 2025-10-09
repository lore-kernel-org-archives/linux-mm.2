Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B13CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 04:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241248E004E; Thu,  9 Oct 2025 00:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1DB8E0002; Thu,  9 Oct 2025 00:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12EFF8E004E; Thu,  9 Oct 2025 00:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F32208E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:51:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98A681409DB
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:51:07 +0000 (UTC)
X-FDA: 83977351374.24.B8051CC
Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D6C320007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:51:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b="U5E/xReg";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.80 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759985466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dd0xy8YVEGEJYa0deBqYb5TfXlH/zF7B3uABe0y3qUI=;
	b=gRuA3Amw3cBDXYNZnOhLifwdbTOIhpZsPMDUgiavvK1PLhrPt9ncvWKRpOlm2+BLvt8dcJ
	9hyAMjB/Pi3EPs2XeNzqsmixAz9OWeOj541VoZQ1QbCmApJ1VOOup8auQSzLbZkhBQTJyf
	Ua70IybuKbRpce6w0UNXcM//TVrCKlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759985466; a=rsa-sha256;
	cv=none;
	b=i2BF8sdnzXEhD4PmRnGJBUuQVAZJd0isLRaZTnHwTEUBDKBlegDAZkvor7ES2AxlbURxIa
	9sCrybdf8hHQ/6Ssp6KUfUL3gVsyYk5JjwWKVbF7lw1WHgl17PxnGO2PJ4VEiz9mUtcG2p
	w+Nn06sYp9VrjQcT3vYDb0IXjJhaKQY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b="U5E/xReg";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.80 as permitted sender) smtp.mailfrom=work@onurozkan.dev
Received: from mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:1311:0:640:df31:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTPS id 6B5DA81AA4;
	Thu, 09 Oct 2025 07:51:02 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id uoB8DgVLPGk0-JyaASLja;
	Thu, 09 Oct 2025 07:51:01 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759985461;
	bh=dd0xy8YVEGEJYa0deBqYb5TfXlH/zF7B3uABe0y3qUI=;
	h=Cc:Message-ID:Subject:Date:References:To:From:In-Reply-To;
	b=U5E/xRegcJD26gARSedDkHL71OVqDPD3OboEiPavvJuUUo1HWMap3/vcMEm17JiZ9
	 OUtCaS3TcHjuLC+pz6wc4no/Nwz/qbZ3rqnVSaWPpYydq2xxssH0ML1fxG3xsYD20N
	 26/6EAKblaYEFC8qnx0nFndDgLvGixd99of6T3cw=
Date: Thu, 9 Oct 2025 07:50:54 +0300
From: Onur =?UTF-8?B?w5Z6a2Fu?= <work@onurozkan.dev>
To: Tamir Duberstein <tamird@gmail.com>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
 dakr@kernel.org, linux-kernel@vger.kernel.org, acourbot@nvidia.com,
 airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com,
 linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
Message-ID: <20251009075054.7ed640c0@nimda.home>
In-Reply-To: <CAJ-ks9nMziN2LU=T=XGhV8xau6UfGXOMZ49+2Lrt8KGbL7Qngg@mail.gmail.com>
References: <20251008124619.3160-1-work@onurozkan.dev>
	<20251008124619.3160-3-work@onurozkan.dev>
	<CAJ-ks9mtfVmP+SwZvBVuQSwViiqo2ZngSGQuU5Y7A-Q_JSwjKQ@mail.gmail.com>
	<20251008225002.011378ed@nimda.home>
	<CAJ-ks9nMziN2LU=T=XGhV8xau6UfGXOMZ49+2Lrt8KGbL7Qngg@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D6C320007
X-Rspamd-Server: rspam02
X-Stat-Signature: gjjxb6nz67afo5w9f68pau36guncaps7
X-HE-Tag: 1759985465-162526
X-HE-Meta: U2FsdGVkX18tsiZ8azkTi1cEFCgWAOnzDdhoRjEPeN+gdTp40uXFIedfm7+DXazP0aYAJ+P8Hugk8aB8bEodLwIsSDXGyB9ZtXyWr+ib2ebn4FcNHwvx1PD0s8/Lf/kroFRAsFCcw/fdbNMGx4tnXpYpqs9TVrLCzEPEm8tQ1vweu1djds87BKie6IKQlkMpSQdX44/E2BPRUZVb/TlwagLPhzUn1COs9+669c9pnfKfn8ijuUvOm79ji8VYGDbhI9a5pZrTBZlUdoQNgp9zI12O/gJY8+kVNVb6wL8g020j35VBCu8VqijgKaMINPa3sgwKlCSvHex19ZygNKkJLJ8084WxLl339ixuwQE3U7i19Uno2C+OzH87FexbzN1AJehWdQAA4yayc3cSvVH0lBU8d1tfURF++nf0Zj1hm4PA1dvWAPlVYRyMgSVroPGraN1/HfST3t/1QkPKZQhii0/6yfR3ue3B3dI7ts4uU8vbhEYj77vtM75tJcgJjT37EtRWLQSc/hwbh8oZlH+LKDxPMNx+0mgPEJAYL+XT6f3OTU9Kb5oMTazTzmACb3T9Mbk2w4b02PuErZyryCKrZYGFL0J63QvltUFAX6RqCy/uOCZOrvV7x6YCPjw1JqCkHAgF2MeSw4OPCAmm+L2JkQHRRG6nrCbJ1a3QnpLQOKwAUL69kfUNYE7z2fJVgt2WUnKUS5vP0NT+XlENM5yMkeg5vfHlg8+GyfYU1Lld2gx2S4RBZRqaQ/Sqi558dWDcgbkdGgm3P6oO/UeMnzUVLLHgE93vgN5LEFxsrfFTZoferCPw5Mw+6y/Z9urBWmhvb5+8iCVHpVSLTwNNlc47FOwC15onl5pWRDnx96ceqGr9c2KbB/e69ggDR1ikNcQNbfS1q/RSL951p3tSI7cen5A3VtrY1Eo2NjYtdS7n744wbWQRyvmjA7NmUCJr2vnJL+oGG7VonqQGrqfEizm
 Vvkxefu/
 IL2IodM9C42d8tFRcTSVTuFqD9ii0GKDnC6CHIZiIAfZ921I3lOqITf9iHjnfJmoM4MgiM0OWMarDyGnNrddohdmsV+QX7wg0n7MAhm7wNGTzd34FunYkkYYBbZ6Yx1ibocKOFhhyw6XlNc6bfQPYx5TWBQYDGtWrXbLMp5KhqgWYRTqNul3EoKVPVoCiHNO7A1XQIg8hlXVXF7a/VLM+95U8nqOZRN7iJ5KsQrRkKo3KstMN0uVPbY3o35n3xxqgtvMxQ0nS13bJy5xCePChALF83p4bpkKbqtDTPOyf/Anc28PM2dmhSvFJHI+Xd9LoY+6ig+BYd4UIp3OQIQfqew7XOutcR0CK9XCdTAj7A8QmFA3rJmf3+yDoS2Mf+7ljDTfm/PjAwtiKfmdFAazr7BEdWGz/0k/txBP9hVLmAJP8oQR/F3jKhyIQ9/JyaO9tcidAsBOFRtD2SpWiA8Ul5/gx9smyYyI2ISTm6/TMWfKykGcG9YMiI6zioQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 13:45:53 -0700
Tamir Duberstein <tamird@gmail.com> wrote:

> On Wed, Oct 8, 2025 at 12:50=E2=80=AFPM Onur =C3=96zkan <work@onurozkan.d=
ev> wrote:
> >
> > On Wed, 8 Oct 2025 09:59:12 -0700
> > Tamir Duberstein <tamird@gmail.com> wrote:
> >
> > > On Wed, Oct 8, 2025 at 6:05=E2=80=AFAM Onur =C3=96zkan <work@onurozka=
n.dev>
> > > wrote:
> > > >
> > > > Implements `alloc` function to `XArray<T>` that wraps
> > > > `xa_alloc` safely, which will be used to generate the
> > > > auxiliary device IDs.
> > > >
> > > > Resolves a task from the nova/core task list under the "XArray
> > > > bindings [XARR]" section in
> > > > "Documentation/gpu/nova/core/todo.rst" file.
> > > >
> > > > Signed-off-by: Onur =C3=96zkan <work@onurozkan.dev>
> > > > ---
> > > >  rust/kernel/xarray.rs | 41
> > > > ++++++++++++++++++++++++++++++++++++++++- 1 file changed, 40
> > > > insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > > > index 90e27cd5197e..0711ccf99fb4 100644
> > > > --- a/rust/kernel/xarray.rs
> > > > +++ b/rust/kernel/xarray.rs
> > > > @@ -10,7 +10,7 @@
> > > >      ffi::c_void,
> > > >      types::{ForeignOwnable, NotThreadSafe, Opaque},
> > > >  };
> > > > -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> > > > +use core::{iter, marker::PhantomData, ops::Range, pin::Pin,
> > > > ptr::NonNull}; use pin_init::{pin_data, pin_init, pinned_drop,
> > > > PinInit};
> > > >
> > > >  /// An array which efficiently maps sparse integer indices to
> > > > owned objects. @@ -268,6 +268,45 @@ pub fn store(
> > > >              Ok(unsafe { T::try_from_foreign(old) })
> > > >          }
> > > >      }
> > > > +
> > > > +    /// Allocates an empty slot within the given `limit` and
> > > > stores `value` there.
> > > > +    ///
> > > > +    /// May drop the lock if needed to allocate memory, and
> > > > then reacquire it afterwards.
> > > > +    ///
> > > > +    /// On success, returns the allocated index.
> > >
> > > Returning the index is not a very good abstraction. Would the
> > > reservation API meet your needs?
> > >
> > > https://lore.kernel.org/all/20250713-xarray-insert-reserve-v2-3-b9396=
45808a2@gmail.com/
> > >
> > > If yes, I would appreciate your tags there.
> >
> > It should be "allocated key", I misdocumented it. I don't have a
> > use-case for this implementation, I am just trying to help on the
> > nova task list:
> >     https://docs.kernel.org/gpu/nova/core/todo.html#xarray-bindings-xarr
>=20
> I think implementing things without understanding the use-case is a
> good way to build the wrong thing.
>=20

I was thinking I would get some review notes from people who actually
need this if something wasn't right. Maybe Alexandre can clarify what
the expected outcome was, since he created the task.

Onur

> > The task mentions "generate the auxiliary device IDs", which should
> > be the returned key, right?
>=20
> I dunno.
>=20
> > There is also this reference [1] that shows that the returned key
> > will be useful.
> >
> > [1]: https://lore.kernel.org/all/aOTyVzpJNDOaxxs6@google.com/
>=20
> Sure, it's useful - the reservation API also exposes it. But it is not
> a proper abstraction.
>=20
> Cheers.
>=20
> Tamir



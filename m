Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2ABCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E1F8E004F; Wed,  8 Oct 2025 15:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E9F8E0002; Wed,  8 Oct 2025 15:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465B08E004F; Wed,  8 Oct 2025 15:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3538B8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:50:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0305C0714
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:50:16 +0000 (UTC)
X-FDA: 83975988432.25.1399453
Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
	by imf11.hostedemail.com (Postfix) with ESMTP id B5EDF40011
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:50:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=iTHDHS8m;
	spf=pass (imf11.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.144 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759953015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aidSHiomRyJ68d+Z7mwP/WOC8Nu++7GfxKmsEuxZL0Y=;
	b=Ntvdn4WaERrRWGm3QQ4kx7u9DpO7fOEmQfFr9cbZEOh1Ua5kB/zXe0BY3UlUloHl1BoPmD
	1fxWurwEwhHlczfu8RmILpbmCYvvfaHXZaHeIwofCm57NM4M+BKcf5krrnzTW6NXwVrlVq
	LGWHDXmeL5YQxW4Jcgp8LupNt6a7tJE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=iTHDHS8m;
	spf=pass (imf11.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.144 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759953015; a=rsa-sha256;
	cv=none;
	b=jYW7bH7/0UaSJU3XME6P7Fj4l2ebR1XNa0nmDCV8jE4B/GE0RasgZeB4n7r3gbKvvIWCL6
	0eYj4ulVmhFiTO9B9rnm+vT0wNze1AW0vVGUz58kcJB8p/ZbcWX+Yk3Mra55szq8ldlL1p
	aRPub31+jhKoLqSOPPRaTL+UGAngZ/w=
Received: from mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:942:0:640:e3c0:0])
	by forward500b.mail.yandex.net (Yandex) with ESMTPS id A4C8FC16BA;
	Wed, 08 Oct 2025 22:50:12 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 4osbeDSLxuQ0-JRjQwJ60;
	Wed, 08 Oct 2025 22:50:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759953011;
	bh=aidSHiomRyJ68d+Z7mwP/WOC8Nu++7GfxKmsEuxZL0Y=;
	h=Cc:Message-ID:Subject:Date:References:To:From:In-Reply-To;
	b=iTHDHS8m61dQbStfx6p7wgmXgY37iaY49Yi7jcclZCiCiWYsj37RvbH4iSZ0kMKA9
	 0XXHakq9hDleSRtOQGrdRMTOLt4xS0rmUKwKMHavZb2LKF5rF1/+wkp8j1uT2r706Y
	 gIr2DhgWkcl9o6qepF7aKUUjeF689xNkFupAVRHM=
Date: Wed, 8 Oct 2025 22:50:02 +0300
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
Message-ID: <20251008225002.011378ed@nimda.home>
In-Reply-To: <CAJ-ks9mtfVmP+SwZvBVuQSwViiqo2ZngSGQuU5Y7A-Q_JSwjKQ@mail.gmail.com>
References: <20251008124619.3160-1-work@onurozkan.dev>
	<20251008124619.3160-3-work@onurozkan.dev>
	<CAJ-ks9mtfVmP+SwZvBVuQSwViiqo2ZngSGQuU5Y7A-Q_JSwjKQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5EDF40011
X-Stat-Signature: 5sk1co1did46kt3u5gqopxkau8k4d4r6
X-Rspam-User: 
X-HE-Tag: 1759953014-422695
X-HE-Meta: U2FsdGVkX18hbeSehj5ut2sgV+jdFqmGu+gqdPUy4wtx67NiG2vRZgtPWOZfVKFc7jMUELIawno17gVo11w2cQy9mUyBWB7Pv8AECiFwhY8i2a9bSyvs4cMieoorqqYgdHzfyfKJ9EBf7xem0zSDpa8gsrQVCOxzzXfhpikjt6X0UzBmbILNh9347PMI6qvVZzRF7P370CpZ4uXcFWsZDO+w0udu/Pytjj3yjX7i6VuexW7CiAcufGVAOiUkwI4RC4SuVNpvXWpVXplJOjGlpmuXIKjpATYwflvdDwyJm06EkdreHNfvgYdG9h80nCmU6QwpkthX48YYz7BH4BDoGG/0kyb7hu2s4vyPG34KmY55nttN0qIS0mVonn1TtouzCYz9b/M/QLPBVcT+aTbc4O1R82rwV9KjKcyYAnWoNpz40581No6LPhv0T35DN4A+1DAcWBhXFQr929g2IXOM6eKV1uyjKOoFaJh3ndbU+IerOpsm/GYnqNXYGJMnDZvuZsGg3o7Wp7L0U1yH0w+Il4YhXYnW5CJmPj923F4jRFUXzCZRHP4hxMUpASr9JG5gODbMaQAJMw2Jn7jm8oLCI/FISKSPXAf759HPdv+Q9HW7iRCtq1hi9jwyaNn0rLZz4AMiXtBLLF9aaSN4svPgz0/ZjPeeRpTqxyA3DOkdgrSsiyF/I9Jh7tPSShUE3V0oNr5infzcSu7iuscZIrnoC9bZtLabwmIh2HP6lJRgl8Frh+waDZ+ef5vybLQ3O/pvhETpoKy+9apUEQ7IzfAuvNslJT8SGPCPDScaIYV19WFGGabCAdavrUChAWrc7ldSj7CmAFbyvoqGaF1cNNbgLiorEPo/aQxfcSq83xaNfaeElBu2iJ7fOgtzhxJ8TeKAd/t0ATrmU19Iav7WvSYm0EQcumaBvoBgSKYFRLYx80lwpgWbaCjShsCjb8B42bcckIE4Zh8eSKexh/wE8G6
 sHx7gtBp
 osfQVH+JnjSNbbmQlyQCaBm7EznmUzHaZEvhyaQe21eGygnuUwyUoi2RCCPwzvlAd4Yu0kYqBaCDqT/S6rwYHi5eHGIU11fPiTPSAJQJs8a8uu9gTbk4PmJDeREU06m4OMi8QtD2XPTHAVNjOAn78/qTSFl0AKwkYW9AflQDvQLHF1p1YG+teSBI7GVMIM3IQepxUx0bq0HaJ3x0w6cDRGhFQSyrcX4fZvOUrdjk/uRQEWA/Rx8tF0y71lWW+XKZhVyHHRaYfq2KsI4L82K4FJaJYgdUDSC7yVt9Bhw4Tvk/QzhwXReeEyBe9+v8hJ+RJu/7mmGwH/1gLsJhD8VQW3N2AB7vy+pAA7vOw8j+PEhp3ADd27+vZHsV61RzzAAQ9RVUextL+ZjRy7AsVsHw5wo7Q5kjLxov06CSoKwJpGJEOeNICFzofS5UZvJhNU5OqOTuv7dhpWZZgnMrXyaGgIysLe+BhGx1aqJzemxC8Hf3bVgHNQABtrd1A7bwaEhm+tME9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 09:59:12 -0700
Tamir Duberstein <tamird@gmail.com> wrote:

> On Wed, Oct 8, 2025 at 6:05=E2=80=AFAM Onur =C3=96zkan <work@onurozkan.de=
v> wrote:
> >
> > Implements `alloc` function to `XArray<T>` that wraps
> > `xa_alloc` safely, which will be used to generate the
> > auxiliary device IDs.
> >
> > Resolves a task from the nova/core task list under the "XArray
> > bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
> > file.
> >
> > Signed-off-by: Onur =C3=96zkan <work@onurozkan.dev>
> > ---
> >  rust/kernel/xarray.rs | 41
> > ++++++++++++++++++++++++++++++++++++++++- 1 file changed, 40
> > insertions(+), 1 deletion(-)
> >
> > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > index 90e27cd5197e..0711ccf99fb4 100644
> > --- a/rust/kernel/xarray.rs
> > +++ b/rust/kernel/xarray.rs
> > @@ -10,7 +10,7 @@
> >      ffi::c_void,
> >      types::{ForeignOwnable, NotThreadSafe, Opaque},
> >  };
> > -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> > +use core::{iter, marker::PhantomData, ops::Range, pin::Pin,
> > ptr::NonNull}; use pin_init::{pin_data, pin_init, pinned_drop,
> > PinInit};
> >
> >  /// An array which efficiently maps sparse integer indices to
> > owned objects. @@ -268,6 +268,45 @@ pub fn store(
> >              Ok(unsafe { T::try_from_foreign(old) })
> >          }
> >      }
> > +
> > +    /// Allocates an empty slot within the given `limit` and
> > stores `value` there.
> > +    ///
> > +    /// May drop the lock if needed to allocate memory, and then
> > reacquire it afterwards.
> > +    ///
> > +    /// On success, returns the allocated index.
>=20
> Returning the index is not a very good abstraction. Would the
> reservation API meet your needs?
>=20
> https://lore.kernel.org/all/20250713-xarray-insert-reserve-v2-3-b93964580=
8a2@gmail.com/
>=20
> If yes, I would appreciate your tags there.

It should be "allocated key", I misdocumented it. I don't have a
use-case for this implementation, I am just trying to help on the nova
task list:
    https://docs.kernel.org/gpu/nova/core/todo.html#xarray-bindings-xarr

The task mentions "generate the auxiliary device IDs", which should be
the returned key, right?

There is also this reference [1] that shows that the returned key will
be useful.

[1]: https://lore.kernel.org/all/aOTyVzpJNDOaxxs6@google.com/

Regards,
Onur


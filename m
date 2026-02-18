Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8042E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 16:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16766B0088; Wed, 18 Feb 2026 11:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3C36B0089; Wed, 18 Feb 2026 11:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0196B008A; Wed, 18 Feb 2026 11:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7B3D6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:39:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10A9F140236
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:39:47 +0000 (UTC)
X-FDA: 84458138814.27.F9EEE98
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50B638001C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:39:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KE2yDKZM;
	spf=pass (imf30.hostedemail.com: domain of 3T-uVaQkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3T-uVaQkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771432785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m3FE3NLfAZuYbLihlpXnQVS0zlKL81UVUgeOf6oH6Q=;
	b=AZLrY8HwmnQSLtKjK6Qf2C2V5qGlT8KDJgvPjQpx1Iy1UaFSso9NHOetkmO4RDaF6pIPYA
	cSvgtCKmLozokphTWrDi7atRkijWTCMtSQnOjbKy30asv7rwivIEVGzSH0P0zub2AFTAEY
	Qf7HgHU1HFpFXvttQRdiE+vU+lCbbOo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KE2yDKZM;
	spf=pass (imf30.hostedemail.com: domain of 3T-uVaQkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3T-uVaQkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771432785; a=rsa-sha256;
	cv=none;
	b=rg9ZT0BT1wnVvGfT40TJ+IexZDVaAB/DjZklzkgoW4ZxZS8t02AoQW45vONMQj//jJwpdw
	Em7md1UfQFFQAzbuNNYUoX8Q8QO5whCrbhy8z5MRJH0KJaWAT1JbW3ZO1TSJzzNPXYYOPU
	EAe7/uO015imVXQ2aBuwzmxDWEnqwrE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837a718f41so142355e9.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771432784; x=1772037584; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0m3FE3NLfAZuYbLihlpXnQVS0zlKL81UVUgeOf6oH6Q=;
        b=KE2yDKZMLm6jKF6aB2IRxZ0y98aOTUpFSHje5O1V8kEHoo91lPn1RuOKUFhfZaPF2I
         JZwlJMtS8uzntL3L58YaXMK7NoYlXrivYucguQZjciWKOCr/Xc59qHiE1f/GwT/wvhcZ
         4VQ5Hr5ezdHDUSViK1p+wDjNrv0vGGOae7Xbmh2sYe/5pQiKXu1Bd38bHK69tFw7z8/S
         U2wOhwEkw3IvKgpD3zedz1uJ6O5B5Ne+QZd6TR02np0y651iAlJ3wTCC6Z+jnLF8aDKw
         So2u+qz1CLIzdXXie2ONTgYsEzt1iYm0xbEuajNHgR7xascpM622ZjtBhYALASANrNco
         +SCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771432784; x=1772037584;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0m3FE3NLfAZuYbLihlpXnQVS0zlKL81UVUgeOf6oH6Q=;
        b=nmvYpXZvBNVGCpgubSWLn6QP5iu9CRmCh1LYtnb2yEk4hcJu34wWA8TTnD0fJxpWIq
         AC5yapYjsrYUcDkLO9Taa65g2gI5FBY5Dy33Mx2igd12MVUX/EwMZNnQgUvKCrWi1H7U
         OzQ8bv6aQeRBaenKdMGm3PVFztj9PkIOp3F+qpwW8iu6vZwvV7cQmX6T5+5+jDpogehp
         u8oTASWMwGFmXO28wf6odxEvzZqRRWwUjzhge9aEFce6lplxXl55gIrB/ihnKtpajlTn
         X4ZWLVW2FzpNY+QJnRIlEXdhsoUR0H4+XI3uNU6YTd7W5C6ABfgA/wvQeOMRdsJ1lAdF
         QiOA==
X-Forwarded-Encrypted: i=1; AJvYcCXXv6ku1nWi/2cfFA5Mw+QQSI6L81ZFUh7dgwqxv/8gR6kXpoqAWJ98RQIIMTeZs29J2e7Y3MNtEA==@kvack.org
X-Gm-Message-State: AOJu0YwlzCdXawNuZfoq4bz2OdY54pklN2lWmNwZ1tArNIn6pERj4i9T
	e1dqlNqvLcy+GZcRdKNyL2S/daNxR5AtQQbHQrkRApo0YymjHXvFye06PHjAL7hzkGuLHhaDAg9
	E7veeGw8owRBHd9/4xg==
X-Received: from wmben5.prod.google.com ([2002:a05:600c:8285:b0:480:69c2:3949])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8444:20b0:483:7813:90d8 with SMTP id 5b1f17b1804b1-48379b8c02emr192248545e9.1.1771432783657;
 Wed, 18 Feb 2026 08:39:43 -0800 (PST)
Date: Wed, 18 Feb 2026 16:39:42 +0000
In-Reply-To: <n2nq4aypj6hgafy36z2527tyvetgcypcrn2v3hvs6dws2mtwnl@jiszbxj4mrog>
Mime-Version: 1.0
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
 <20260218-binder-vma-check-v2-1-60f9d695a990@google.com> <n2nq4aypj6hgafy36z2527tyvetgcypcrn2v3hvs6dws2mtwnl@jiszbxj4mrog>
Message-ID: <aZXrTlNHyW-HZs1C@google.com>
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50B638001C
X-Stat-Signature: kf9yqnspbfty7urmr8s87xozs9c3choh
X-Rspam-User: 
X-HE-Tag: 1771432785-82072
X-HE-Meta: U2FsdGVkX1/I6og85n38qyZqVPvO6XRxT694BEI13Yv1hF1Ben+wGD9yN0xlnR92Hwy7+FYWTy44leiFxmuYWx/Lq36lP23fv08vKlQ5OjuExNYEpdW4O3e4IW2gK+Wg6lJN0V2JYGRRo9vSj+UhOHhw+SiUnRJndEOPEAoq6tYGJ7dO7RwKadEeyGT2DEJSzzzQI4FrPCvnKNPR37Ar010GhXoZMpZhOjypou5m4nFtstoBytX7syOJgLdeK/eXS6lQLQVlKBy7YmjftkRCjCRsWK9VVKVSbwcKGxdRoS9ROGOFYm3p1lawjvv06faBlw4UNrbK1Fjkqfaq3R8oUij67rtKGDZvknSlQH/gaF9k/r546CdC6K6vi2o3scx2mtXP0jP/NGTGAHsw4cxwV2/6wGIPftrZYzuSy8iR2OCPCbkLSP2SQhfNVEmbee7p8lCr0QItAx559xvUVJPZRCmxOLLdkQngN0rxLEWBHaLhW2t48hJYq4b0Tfyo8gKEaahQCbivbUZX4/OrlID7pVi6bEd36r+mn2SbYoMp76yeeS0btfbISUI6/lsQGVZmC7EE0/jtxd1FxNoIVPn81+LjxS/QeU6C28nBJbeDx311zAVbftHEZM5mRc0xmJCG9kTjKui4zPT7Q6czxFKQlVRToEshyoVM6s7PwZt9aTPjiU4CkFY2VkRCEzlVaTQ9hC5MZrNhSAsM5J2DFm/jUPqCsh2n9CESWymOv90Dbap4JUgofVF1y3pVplo/ab9lZvOo19xteocobr2rz3sVbdJfqhBi1FjJvJLOk1mf9tjH16g0THP2rHLwdY1jfFWUKM7JOq8k72XwfPtx8aTJgauBg/bvblCv6IiH5MYV9+WKsFDATAihoYfDgbqoYEt3OaCQMJ0546adYQp4jmAaWvrnKx7EW01mE9mHSHx59PaQ6ewiYTXlygiIOzSmyN21v948tJMMDXz8laoof/T
 fi28ZmSq
 1cv6RquLgpxryj+m1KTiZqRx2+bE5leT+cK0dnR5dtOV9kruW6psP+r+1jlyhHarUmq6+cMX18hoxDJ7U63ni4PDN1lLJ0cNh2DGzigMTwEH+//wPFaym3FBPatKgAECqfNe7J+NZz5HKCbRkg91vU/P0dreTkKBCUPh+MWtQlkmhYWvDe5c2QUzfQKpoZHQXqa4+TDXNQr0ttUNy4OU0txcyXNvWznZ1P4cx6o0kr9SsaNbW8f36RDC+05R3Ci6XUUfVafsvjm+Vz1t1kY8Pc/Fz124oX5souKqwU6/lWNst3QYH/u1hvJJXThbN+g3+qD1kBUAfZFaNYq7mRmBfa47R1fzLLJ2pEYiyHIEkn1ZreOfvz1jkbj6uEwiAq5knBLK+XkJJXWT8AVRU28Sn8aAbZneIjayl4HWuimsKBR3hdtkhOMNwCZI1Ilpc0ypf7gwoK15dNkTEjO2W2l6OYzAdJJHsW87Rjvu5C7wKFoKDzRYjSQrWPEzqyBe3+itc4hsqO9ibpryTMD2MxtmOM87Gu2qubuENJxwrStIgEa/7vjWVenTzlRQe7nruDe9QZYpkpokUNhtaLieyyuA/zBhdp22WRShVyvEGqz9K/2xxVrt3HkXm2HCoN9eJxFyG1UF6vjTIsu4kOwsx3o+JdUMNhhY3nYXUlS0qzepeJ4lLghdd6TKf+9uFD+RvFX9Y1LAU3Mi0VIM2w8F53Gd8WUB81CK5xz0iQhePsCPHy1cH83g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 10:54:46AM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260218 06:53]:
> > When installing missing pages (or zapping them), Rust Binder will look
> > up the vma in the mm by address, and then call vm_insert_page (or
> > zap_page_range_single). However, if the vma is closed and replaced with
> > a different vma at the same address, this can lead to Rust Binder
> > installing pages into the wrong vma.
> > 
> > By installing the page into a writable vma, it becomes possible to write
> > to your own binder pages, which are normally read-only. Although you're
> > not supposed to be able to write to those pages, the intent behind the
> > design of Rust Binder is that even if you get that ability, it should not
> > lead to anything bad. Unfortunately, due to another bug, that is not the
> > case.
> > 
> > To fix this, store a pointer in vm_private_data and check that the vma
> > returned by vma_lookup() has the right vm_ops and vm_private_data before
> > trying to use the vma. This should ensure that Rust Binder will refuse
> > to interact with any other VMA. The plan is to introduce more vma
> > abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> > but for now let's start with the simplest possible fix.
> 
> You probably already know this, but there are a list of ways we can
> ensure the vma is stable, listed in Documentation/mm/process_addrs.rst.
> Check the "Lock usage" section.
> 
> I'd feel more comfortable using one of the described ways to maintain a
> stable vma instead of rolling your own here - we may break your way by
> accident, or it might cause issues with future changes.
> 
> When do you think we can move to one of the standard ways of ensuring
> the vma is stable?

If you're referring to the fact that the vma can't change while you hold
a lock, then that doesn't apply here because this is about finding the
vma again from an ioctl or shrinker callback, not keeping is stable
during a single function call scope.

It would be nice to get rid of all this special mm logic in Binder,
though. For the vm_insert_page() call from ioctls, we can replace it
with a vm_fault callback (pending perf analysis). I have no idea how to
get rid of the zap_page_range_single() in the shrinker, though.


To give a quick recap: The basic idea behind what Binder does is that it
maintains an array of nullable struct page pointers. Each page may be on
one of three states:

1. In use.
2. Not in use.
3. Completely missing. (Access is segfault.)

Accessing a page in state 2 or 3 isn't legal. Pages may alternate
between 1 and 2 in very quick succession, so for perf reasons we do not
free or unmap pages when they stop being in use. That happens only in
the shrinker callback, which is when pages are moved from 2 to 3 by
unmapping and freeing the page.

Binder explicitly calls vm_insert_page() to move from 3 to 1 (from ioctl
context), and explicitly calls zap_page_range_single() to move from 2 to 3
(from shrinker context). This way, the vma reflects Binder's internal
struct page array at all times.

Changing a Binder vma after creation is not really supported at all.

Note that vm_insert_page() is called from the ioctl context of a
*different* process than the one the vma is mapped in. That's because
it's called from the sender process, and the vma is mapped into the
receiver's address space.

> > C Binder performs the same check in a slightly different way: it
> > provides a vm_ops->close that sets a boolean to true, then checks that
> > boolean after calling vma_lookup(), but this is more fragile
> > than the solution in this patch. (We probably still want to do both, but
> > the vm_ops->close callback will be added later as part of the follow-up
> > vma API changes.)
> 
> If I understand this correctly, setting the boolean to true will close
> the loophole of replacing the vma with an exact duplicate (including
> private data and vm_ops) but with different write permissions.  I assume
> that is why we want both?

No, Binder clears VM_MAYWRITE in mmap so you can never create a writable
version of a Binder vma.

> > It's still possible to remap the vma so that pages appear in the right
> > vma, but at the wrong offset, but this is a separate issue and will be
> > fixed when Rust Binder gets a vm_ops->close callback.

The main thing a close callback would give you is ensuring the Binder fd
becomes unusable once you close the vma.

Alice


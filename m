Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8D5C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 16:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417A66B008A; Sat, 26 Jul 2025 12:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C83E6B008C; Sat, 26 Jul 2025 12:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3053F6B0092; Sat, 26 Jul 2025 12:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 220A46B008A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:15:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C96541A0B42
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:15:27 +0000 (UTC)
X-FDA: 83706915894.07.001E9E9
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4E3C1C000E
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:15:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wIMF1rd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753546525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjXI2/7oThbWzLYU7IbCDr+QFqFWddGsPEoOiITUQfo=;
	b=NwkfAUyO05/mj8CiWSvYI2+4PuBxDL/A6nm2QTURl1fBDXynODi3I54AAlr0iEObsL0od3
	fu9yRsPRnj6LVEDPmWn8s8rtC3owO+4QENtOLI3DNvzwjk/Wm0kZUWlpdqNd51XG0dmZzG
	3OFHoni6fJVY8ugPobq8TMe35sYmzR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753546525; a=rsa-sha256;
	cv=none;
	b=zMXbYooOMQg96vVmGfmprtYMSg23LlClv5h7G8t+1lpJn+Ti4Dyf5rdCANJg9loVpZdlGD
	ASIGVnEE6dVkZQ+hFhqWxLJwP91PafpZhpWvo6y8NMakMQEf8nqMOdIt2UfUZuFSEXKu8a
	xCNGdoOA6w0QrfrrLDE/jVupFjoRCiI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wIMF1rd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45555e3317aso16510315e9.3
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753546524; x=1754151324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjXI2/7oThbWzLYU7IbCDr+QFqFWddGsPEoOiITUQfo=;
        b=1wIMF1rd3KAFt5Ffbpaf/gENlhS0k60iaLPQWTsGIHWgTNa/MZakxXaYxQFI7O0H5w
         KM7fOHxdETb1KjQK5JEEDAFskaQsqFnCo1feMYoBzuf6YZcYwCc4mDFjmCuryjq8BVtR
         lVDY8ew7WITtg+ziMliGsh8ZVOKFV37UvDzZiMAMxzQ+XlgT62m74QeDb5GjfWBozTcj
         F2h/7Zjv3V/PzhaHUBwPmN8NugjnI4LTMu8fTPFOxTBMjb8SEEo/Vbj2ro6EfJ6A3HJw
         VxNH6i4zqUZJyFxevLDEOPrMy7OIXo105u4ygGhwRN6MbRN1Rdr0bWV+kVAsVLlPF9aW
         7XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753546524; x=1754151324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjXI2/7oThbWzLYU7IbCDr+QFqFWddGsPEoOiITUQfo=;
        b=TbZ52nxJG+piG3K6GmiU99WPY6bNpCggpYlDstaoKQvmrUEx8lQbZ4JDy9EUk9Hiss
         oKRYvY9XK+iR1QI0nJSVMInjkJH46S6lM/K2y8VIaHKnOPLlO0ypB4zjeu/vVe+GAwKf
         wWNDTLSzxQlMuhxqnydMwjWE13IYkk7Z1+k35P3fHSA02iOX3fyKb4uAI3u9aa/C023G
         VsVMaLgmX5+OuZJZnBu3zRJ9GCbqaCNkuy+8hNogvjXViu+qZB+VwMLUuSV0zDyq5Bp5
         O4+GqdBodtx9LOK62YedHc6+7PRC027e8HkymXrFMikbiMDqYx/mA/xsHuMQ4DGHbasn
         XxXw==
X-Forwarded-Encrypted: i=1; AJvYcCV/hdrhKO0/6AjrtTqwK5XRS6t+JeBCPsMVDDGtMYiRGLVk3kQ3HBmXRWbF6JU0+Lc/2QqLaZA73A==@kvack.org
X-Gm-Message-State: AOJu0YxrwvP2rBQE9c/VfV/warCuRYJVCo/RqlR4DRAZCfibLxx2dq7D
	LvXP744uEM6GfQ/Mful4cz9wuzrVl1jKguh4ORNelSCHUT2APB8pW6o2nMX59wTyCc1HIAl3tDo
	hgR2ImiVjr0K1vvp6JPFUeAxmawCqFrS9ZS/yIzou
X-Gm-Gg: ASbGncvPXLngH5z+GWz+Tv3gqFaT26wpK2NGwZPZ1uliGfLMXfj6N/u6xs+XgRlfBTr
	G0c4t9auFNFUEmuRLCiC/R1w5GPW/V1Yg5gFVOacCv5IzuLX/w5Y+bDP1uxtaJoVrXWuCPSD+Pe
	vVcBSddraokA29/FAamG2JA3gVZGkJWZo+JhkPURWhltczRIR8AchNZndzDk7PQ84HOs6Fxq2BZ
	sslXKST
X-Google-Smtp-Source: AGHT+IGq6r0MeHgvQseFz5cMv43K6MbZdaH5JloddQpsWGT5eYrYGrycXYiguGwgXRqrUoDt0sDmanBfxCMNYLu8MmY=
X-Received: by 2002:a5d:438a:0:b0:3b7:8154:aa36 with SMTP id
 ffacd0b85a97d-3b78154e3camr932195f8f.7.1753546524220; Sat, 26 Jul 2025
 09:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com> <20250726165020.46880c31.gary@garyguo.net>
In-Reply-To: <20250726165020.46880c31.gary@garyguo.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 26 Jul 2025 18:15:11 +0200
X-Gm-Features: Ac12FXzISFN9wsDXMX_LgKfYNxwErnQbej7ZyIa_oJ8UfCOGwdNe7zdwJtk0UtI
Message-ID: <CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
To: Gary Guo <gary@garyguo.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D4E3C1C000E
X-Stat-Signature: mci789gfmujw6mgukjegswdmsdb51sca
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753546525-726004
X-HE-Meta: U2FsdGVkX1/nGJcyFD9XMxcO75LGdPPH7lR6xbpng3Ria3NkJ37m9fIwMVT2VC5V9PthqbywI0r8IOJhcbuPU/+BDIM75dNull1LN586yFe1jrIbGB0CdnWigymZdrwpnFN68bGhvrwu8mf4aCRCQiLQZq0fnq22rkKEUbOMqr0qyxZxEGA9rirz2ujnMVNMJvga3XuGDJ58fLBJcuz+xaC9E8q2F7l3PpxfrPgxh7c5eTjkDl1Gm+FxMMbVkcpxKPpg74TfDhEgdGoJ6DwDH1wmxOCj2xC2DXoNvRl+zpCFziX+bD2Kw4ocRx2GCodr9AD9S1DmzhpFQHAsbgPaWC6wFB44ERmrxUqRugUviMav3eFxr2zq4m/Ms+iEv25iYcgCAiPnN0upMX+D+cthEjaWznmtC5jGPSqNmp8hlcZVVLFaDgItJMoqeYi+aDPMzGOlDqouL6mEKwym4v4sM7k9RQH0htuthYrczIHkscae1XtZIx7xnhAx4UjGLPx+YAcwdbWw6a1wOzWMeFBzI913/ExUdEdfisg2lQpNlmhzPQlNorjdxFrvclDLDLkdoRAZKm84hxoVJ4W+zOw3x9y/mDIRtbsnTJlfDCXvJ8TnxKk0qL1tzCbJaVDcLqjnXjeRGVfvBIhA4chzY/fz8mkW4rR4W9/PprylPBFgsZVQjjKAPfQVLEYXJlJMG0uGErI0OgMLzSRZikp6/R7a+ypgHOnnEXDAkOKIOCEL9BSPQufHhZCDtT4KRJ9l+nE94QlzRAIb1GowFaxGAbcoU+eZsvb7UVUfwqWt59fmJiR//bwdRTusMZ1iqN9riLY5SQXgjM0+LwxgyXBkjRczbYcH1cgqTsJgm3aSc+UJ2jcASlxc0OQg+YiNYLPaLfoTXMhjEHXoptU7pValJ128xuwosdxdHaOvBKNcVF4Ihe6C6RrfgzdgBBY/vZHB0BXa2drHW7q82OjCM1q03UT
 1Wk77Qn/
 LehrHJVNEP7EXsk9GJK53Z0CV0A0RzYs0jnyo2YqcuMemGXpiT799sDf/3M5pk4o4d66GGqrTWh+12mwuUu7KUIXWCaRjdD9xe6NXo8QGCprT+xkvi435SeJ7tUlquaLJ3+cXkMmQklNadt59JpoTH7y/xq6+4rFqecbGWKLlGFdlc1K3eKaT1Ojvdju6oI6416W+x8P/2Zj4t/eCZ1Zykbs2YSpPaKnNj4OiXVbPyRbghot1vylan/6p5CijdySE7wS3+DVt4NeszWmB8sdMk0ot3Mf889iko+1HaLiXgKqGmBO4XfJNRQBTL+F6losKQNgPziVohwmhpYHArlU+qHJgy63UJonWTd9wzrAah8606t5S2EfE4wUoO0CAQKLs6BiaMNRNi/6cdoVpHD9H7O03Ute91o3uobHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 5:50=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> On Sat, 26 Jul 2025 13:23:23 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>
> > To load a value, one must be careful to hold the lock while accessing
> > it. To enable this, we add a lock() method so that you can perform
> > operations on the value before the spinlock is released.
> >
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 94 insertions(+)
> >
> > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b=
4f5337fb6277182d1 100644
> > --- a/rust/kernel/maple_tree.rs
> > +++ b/rust/kernel/maple_tree.rs
> > @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
> >          unsafe { T::try_from_foreign(ret) }
> >      }
> >
> > +    /// Lock the internal spinlock.
> > +    #[inline]
> > +    pub fn lock(&self) -> MapleLock<'_, T> {
> > +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > +
> > +        // INVARIANT: We just took the spinlock.
> > +        MapleLock(self)
> > +    }
> > +
> > +    #[inline]
> > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > +        // SAFETY: This pointer offset operation stays in-bounds.
> > +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bindgen_an=
on_1.ma_lock };
> > +        lock.cast()
> > +    }
>
> Could this return `&SpinLock<()>` using `Lock::from_raw`?
>
> I guess it has the drawback of having `MapleLock` needing to store
> `ma_lock` pointer but the guard is usually just all on stack and
> inlined so it probably won't make a difference?
>
> This way you remove `unsafe` from `lock` and gets a free `drop`.

I ended up going this way to avoid the extra field in MapleLock, like
you mention.

Alice


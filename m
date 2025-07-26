Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB15C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 16:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC316B0092; Sat, 26 Jul 2025 12:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A841A6B0093; Sat, 26 Jul 2025 12:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999B96B0095; Sat, 26 Jul 2025 12:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD316B0092
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:18:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2193380A80
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:18:18 +0000 (UTC)
X-FDA: 83706923076.13.5290179
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 271D34000C
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:18:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lisg/UrL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753546696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiLS2MBgpKK7dn/WFA7kJ/QtNdTGL5/cM0Nxh/9FxvY=;
	b=ibEphp+9NVIeH+reBc/lgmG0JQB1G+OZvHVJnIxgQinjQ6u9gq1355tYgm6+YO63/FDoGK
	dtZ2NCGSSqi6QqVQetDue8YLf1sYhSmuKYv9VGEuuJv7p1HL8Kvjbni7YRvg1G+nO0QAWe
	BJzd5YqdzUxw+0hZyK6KD4WVvv5WBhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753546696; a=rsa-sha256;
	cv=none;
	b=tx6jzRgY6boVxKaoS87dasqFVuTWHR2D+aJMobmHs9HLrPNFsyE2jdVytPn512reNH+Uex
	OCIzhG/E5CmVumEZs6soCKShTx8/A9BVsUb7jzh81w55Y+GidmPXSPcZ7GQhPWZLjT+/y+
	7C76kaITRetpP8lrMHPDk9ux2nSzmqs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lisg/UrL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-455b00339c8so20157395e9.3
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753546695; x=1754151495; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiLS2MBgpKK7dn/WFA7kJ/QtNdTGL5/cM0Nxh/9FxvY=;
        b=lisg/UrL+mqPWZTeidW1Qe00CpD6yBnAer+C2XWL9Sn6VbNZ1YW8RKMKUihNvdUHEQ
         JbjUv39um3x5qpazQ083h/zdxEN8LdTZ23IC+SYREd2BxHe0fzNjx+SrZxlOefKBb3O4
         Fhd39/2JPCSnyleBojE+MYrk0PJi+LwQZQAu6itUIKUMMe/d3oyLXsTT+fNKpk1FcAEz
         Ttqd8cwkfOsPwipNmdGhLKDhHe83fuZj6X9kj++HGe9iU8C++3ZVWIcTY52dG3AOGjoN
         KuayW2MPl+JvmqYLxxLAutTd8BW+mU3Z3Rb/mDBS4jsBvY5tBXdNHR//ZVJIMxAXIla4
         WLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753546695; x=1754151495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RiLS2MBgpKK7dn/WFA7kJ/QtNdTGL5/cM0Nxh/9FxvY=;
        b=b66bKjIE90DuiyuQp0PTex/CRKBSfCeUqmibA/8eIZ8PnfEsxQVOIyFWyiW2fGajJ8
         vVM8k4nvJ0cdKBJFCvqu/JPnC1y1BY/0SZfmGqnnZ5zLxte/LbdEdgsvSa7q6Sk9UWNA
         ZM0LvWjZm0JHQ+LgVtT3tuBV7BI0TMMtP+iNDMff30lbyM5gP0X94lkbKpaQuJxwE0Ly
         v2CuKsEspdHcBv81SFU8saP990kPESTdbbTvFQqRAR6OERcACvySwwpAr+Y+UIbi5KyU
         9kOcvbHw6oQYsJGtaV2syE1hIr65l8rprTXmvRqve0f5JaLSetfd7BBh0mWIyad2mYSw
         +IJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKbYc8N1N5qPr1nc9wuwDC26Pihl4imBMRnJOchAvL1JkkLSDcQkRNj2AjOK2TyV8ShpOegU0aXw==@kvack.org
X-Gm-Message-State: AOJu0Yzhk1iYhQKgkD8qnKuXxSidxQiutYWAQOpD/TVm5TZMzaUETHS8
	Ne6waxGeWmSZdACSp8ccLdngtgrUtX5SSgBiEEPfLGwpGBPzijGMP+c2FJtAuGP894mG/LdRBJV
	Vf+SYqeFNao9TiVPrzzWzQEionwGS4DXK0InyySBz
X-Gm-Gg: ASbGncvtWF5Io10oP0AX9IiW0TRa6nmmhVmimTmERKEjA9oWZdxoNdgH+CEvtdEwpMP
	4B+smNBPQjcQLOCqeVOj9n7nEzzNm9jiYHiE8UvbO3jm9zQ9wuB/031cVQikZJHclZVkxLINOiN
	MC4DYwwP5xZ+vr2uJNZH8y+AXvVPzAD/aHalhjfdeHvftZb9pSQyowpUGbHNZGNK5MrdkTMdWLC
	dvXTdAZ
X-Google-Smtp-Source: AGHT+IE4T2Sn+YCnW4UddIk8IedAnI3g7v/KjWu/nPuK/MNxlZtY8DLAjeFjfi7qmMPpMkzy+RMzIlyv7WFJGSZZYKQ=
X-Received: by 2002:a05:6000:1886:b0:3b5:d726:b7c with SMTP id
 ffacd0b85a97d-3b7766641a0mr4429309f8f.40.1753546694652; Sat, 26 Jul 2025
 09:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com> <20250726165020.46880c31.gary@garyguo.net>
 <CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
In-Reply-To: <CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 26 Jul 2025 18:18:02 +0200
X-Gm-Features: Ac12FXz05m1OoGuwnB7bHkQoMy2rtk_a0qxycMPIapq4u8Ue_k0Q0z6l5hoUYyU
Message-ID: <CAH5fLgjB7-xJ2OjVa6nxnUPk-1+wyxPMWQ15-Vc3mUp36+_Rhg@mail.gmail.com>
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
X-Rspamd-Queue-Id: 271D34000C
X-Stat-Signature: ji5x7zmny1zfu8mxcs3za7h881ewti54
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753546695-222032
X-HE-Meta: U2FsdGVkX1+bxwEcpLO/x++dCzf9PXN2sCPt8K9PACnDobMRyub1W/SL8/PXjDCpfZ9dKghxkxjmZTGM5W9f6kIeUYdCdS4Rv171XivQeqtZkdlS7oOkp2iYWcESuYIUdjwjcx+ByFVfp4IiMLP093prGeBJMKV5BO7VN1doT7Q6q3LKut2PaSXTkKIH+5IIznVPjBMJ0fAtWvB8FofGWzQBGDfBW6SmKCvPl7jlvbJGSmWq5FXVkRIbXeOr/kd6b6MoeIiSZ9jp1b3pvigQ4rL2I2KiCD4wDktZhO6I9v7FoCEGDTeljewcIMsrwesZT4oRueMNevYIWzxlK+uiMl8NC2vSkpeC+bdyAdL1p0ph2xmPF7TP8PAEpQjLOM+mKXiIne3tYTSjHqm+DiLtB2qZ8v3TGSnxnr3j/1EU9k9NnCod+YJhIYvtO0vfWHfMntjkssUVBLL3sWeSPXG28N2M+Dr9UDY0XE3I88TUfx3ic25WUkKlnsN8p2AKGvQv8kmwKNK9WjCRVLOfCEVWQe1k1aBLcpoaalUFyfd+HgxH01fHVQVwciGqBcTDNTp17Acc+b8xXzSCBP6+gHplIqNWcuCChamY32Qk0qJzmG6RCUzoa5l8qFioCoVPLWYyQerVIIeELPQYLn33HVqlZUTHxrPP7EMvcyfKqehwJucpa+6VnRnSlOtBABQAigaweU9BXe0lq8r1K7Xi3Q01v1fQ+9DyqjBXQ2V0EBoT+DWq03zi/mngOOkjc8GXwJKRuFd947asoKuW0/c5ZpWisbTOM3Kpw+007lsdpY0HC7jEp0my3yYUwSlI4wsrfg/aNHLUdoLSdGKFnT/ZMDZxNQ7S1b/WrQlcfEcoWKjAp/w7yutXerVbKhmMOsVwcBkEoPYRIl1Ltn1dZTDYmTnDEfm2EP9pwV8lHx5p+7JBODMxDrZpVQ9UVtp7jj5aKmn5L4gmAHbrepXYXQFa2Xa
 mlW32IXQ
 8AEuf+ZwjgjTYXeMOtKhxZ5f2Qzfer9vBYaogxhOc/gJxqv5bTu3/ogsR8Q0W2f5nLaCQCwVFUn/MmbSk3EKfd6/6hgxHagrSaGM14yM5ij40NznGd6kuVOMybTIzuBHD4+y5DbtnQ27jl6OqRxuu4wnNUDhQjSfcJap+jqGax6vcGZtxGsNVYxLMXQfEADxqfTP1e8lg+Ksn3fiIH4lZ0WMfinkWkHxODfwxIDVNOWRyRGDashRuuz7IOlfrbb3OfrUTqPbRgyiBK6pw+cVYbhl/RxjtcSVX5sM9pqC6AifXufAIDhsoRKU26xp9BuT86gQN3HNNYD1Jile8v2J3+txtYAG5Jj9/5iHZ3oKy47uYiqF81p3pNVqzA01DM5TGvu0jtJc/x+V7Ddhh+y09mj4SGqTPhBZ2OiDt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 6:15=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> On Sat, Jul 26, 2025 at 5:50=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote=
:
> >
> > On Sat, 26 Jul 2025 13:23:23 +0000
> > Alice Ryhl <aliceryhl@google.com> wrote:
> >
> > > To load a value, one must be careful to hold the lock while accessing
> > > it. To enable this, we add a lock() method so that you can perform
> > > operations on the value before the spinlock is released.
> > >
> > > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > > ---
> > >  rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++++=
++++++++++
> > >  1 file changed, 94 insertions(+)
> > >
> > > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > > index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d575=
2b4f5337fb6277182d1 100644
> > > --- a/rust/kernel/maple_tree.rs
> > > +++ b/rust/kernel/maple_tree.rs
> > > @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
> > >          unsafe { T::try_from_foreign(ret) }
> > >      }
> > >
> > > +    /// Lock the internal spinlock.
> > > +    #[inline]
> > > +    pub fn lock(&self) -> MapleLock<'_, T> {
> > > +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> > > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > > +
> > > +        // INVARIANT: We just took the spinlock.
> > > +        MapleLock(self)
> > > +    }
> > > +
> > > +    #[inline]
> > > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > > +        // SAFETY: This pointer offset operation stays in-bounds.
> > > +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bindgen_=
anon_1.ma_lock };
> > > +        lock.cast()
> > > +    }
> >
> > Could this return `&SpinLock<()>` using `Lock::from_raw`?
> >
> > I guess it has the drawback of having `MapleLock` needing to store
> > `ma_lock` pointer but the guard is usually just all on stack and
> > inlined so it probably won't make a difference?
> >
> > This way you remove `unsafe` from `lock` and gets a free `drop`.
>
> I ended up going this way to avoid the extra field in MapleLock, like
> you mention.

Oh, and it also avoids assuming anything about the layout of SpinLock<()>

Alice


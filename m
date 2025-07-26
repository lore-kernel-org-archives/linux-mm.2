Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412F4C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 16:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDCE66B0088; Sat, 26 Jul 2025 12:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4886B0089; Sat, 26 Jul 2025 12:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1306B008A; Sat, 26 Jul 2025 12:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2136B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:13:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 184C48095C
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:13:51 +0000 (UTC)
X-FDA: 83706911862.28.1072D88
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2AAF440008
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:13:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4MVqu0bM;
	spf=pass (imf07.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753546429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSmE2/IG78aP+245fYXp3PxN702DvxPZXYlkAkGpEZk=;
	b=4p6w0kNRGoAeV1UvkbIjw05yt/jA0v/kyeYJRdTo608nBZveTK4/A/l2k/EdnLpa3odxmr
	ShMFUL8EB0G1AZfOzkVmE8GtjoxQIfQpehT5wMMg8yDcYQDUdyNTNXMZqmUVv1LMskN13u
	m17qUVfgKhPvFof5RW8r3ria4vrNOnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753546429; a=rsa-sha256;
	cv=none;
	b=OWVR5yQJLjVCo4N0Z1gyWzOIUC9Ch9pEaiseZtUPpsVFZ13xfhZX+OiE5eiP4rd0nL/BTd
	JMyKA4XbBIEls7oeecNUPtIE4EloeEmDmE3f9h1lnDM8KC3tllFPriPetd8FJnF6mrk8D0
	zyYF4BQnV94YrzNIwXmRjvB3l0PO9+8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4MVqu0bM;
	spf=pass (imf07.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-455b00339c8so20141605e9.3
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753546427; x=1754151227; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSmE2/IG78aP+245fYXp3PxN702DvxPZXYlkAkGpEZk=;
        b=4MVqu0bM5y1ENSuZD5vf3zZnHt0+LI9x1b4x/u3miUFxHcys8hO1Kd8DeqWmXnm6QB
         dyg5HIe7zpOlgqDXV11rRQUatSBN3n0lSRBZfrJSVBPihJhjK9Y64DtB4Mn+1pF2unbG
         ACaaxHCIsDlmt0cQgRs3YRYzPb1waT5oNhaUuIF6t7tP9DufhMG5Ej/R0JivfWcpOhOm
         NQez9fSgWTNw5KSr2/3OodRg5wXrihEdgy6YwHR1fqn18QYmEoqbGkc/Yh3rmkUzw8rw
         6Bm57W92RC1GKcQEnbOjqljpYnrFLBbPGenmMm0jDbUQI7OH2VVaFqCDf9gkmGMrn2P1
         JVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753546427; x=1754151227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSmE2/IG78aP+245fYXp3PxN702DvxPZXYlkAkGpEZk=;
        b=w9eyNjyqTjf3e/9E9itWINVLnOZ6ymT+MDXcgTvz+NCCIa3GP3uQKMhMMUritYklIn
         gFSCBcH0bLJrexoP+T7rzJSRyVqxM5TjFtv0IyYECX9LYkTx4s3YHcJpXY8BWTo0SKlf
         3luSVR1wVjOUbPgyI3Kudx5HcQZro0MkghjeguGl7ylRpW7A8PnOsL8JBofPJkLK0vMc
         +/N/p+9lSVtLokEjjJC4qJXnqdvoGWjFfNa6ImTcDTKZ8e2/yqbtQBk0r9dqGJURRhiD
         +/mCNjHnwySy8nbLxtNl04v3ta9bYC/nyvzBUtB+WdzoUrt1nKYDU+6noIcA8PK8iioa
         Am/A==
X-Forwarded-Encrypted: i=1; AJvYcCW14WcZNRQYMkNxxmAn1nh24HDsYwvwHMCswLvwPg8txTeMiTqhooNHLYktorGQeOtxZPRbt5FM8Q==@kvack.org
X-Gm-Message-State: AOJu0YwHjxpN9omGUfVAbnQUEI9sqbZd8eaYNaQkpjACQM1wT7wEolvO
	UIbV0D1PkPS8ZMpW8bQYh+JEu8PbKqn9JED/mIf2Zo7Z/ogPdrJB9el3URg2tA6UGY35pzD2bIP
	zicqpO4iv9H1c5xYHYWF+YJZXEw5AH4V5vInqJqaf
X-Gm-Gg: ASbGncsJwsfTynGRPVfIpW7QfIab4dYp31TulGlJdr0XzJoN5jYlE9iDLTeX3YcE2rq
	xcuGe8beqny4e7jPrXcn00tbjwHul+YrpzlciNeXudTi2Moka5y786wosfHltNE2xKAs+PJnzvb
	UO7YyZSBLZnMXyEdrApOPSRVwwary62XGc9k3ROVLnqFzrIJT0r0grVSc7N3jeRrto1yS38kIE3
	ioqzBFn
X-Google-Smtp-Source: AGHT+IGjmxfhiuSOXZOdKrAjq/2iLUvcoITJyFtLrM3SVjwxEvIE+xW4uFMAM5xc3aH0PtQ9ZEiVJc9cs0p0ckcKSlA=
X-Received: by 2002:a05:600c:4f87:b0:456:133f:a02d with SMTP id
 5b1f17b1804b1-4587644278emr60085665e9.17.1753546427335; Sat, 26 Jul 2025
 09:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-3-27a3da7cb8e5@google.com> <20250726165446.2768c6ee.gary@garyguo.net>
In-Reply-To: <20250726165446.2768c6ee.gary@garyguo.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 26 Jul 2025 18:13:34 +0200
X-Gm-Features: Ac12FXxFtdvvjbSWz68LToYZuz9O8rpVTX_BUoiCo2Gz6b2RLEu8Wxik0sZefPk
Message-ID: <CAH5fLghiXEvcAfdCRJ==i4JWE0DQh6fFD4ppVM2DytHTjwA8sQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: maple_tree: add MapleTreeAlloc
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2AAF440008
X-Stat-Signature: n61nt8qizuskiwff7hpoj75owff7oa4r
X-Rspam-User: 
X-HE-Tag: 1753546428-232315
X-HE-Meta: U2FsdGVkX18epn+6/e4YAwxtA8VAuI5izNS05ta1bzUDmkwAbk14h68IaKNe7rcT5limo1V16sC2+V2Dm1ctVdheJFMlbcKqEmnD0RjzQuhoiRL9twJPia45fk3uVzhQ6hv8+6rHVFc8+eCXCxxhmMCK2rmEETP1lGc9gghAuhWVl1QNX0q3MWOMgFVnCl/y30cP9pc5WrVMZoLhzIYPSCbXkpCBZvlHtkGCM7Lx/aIx9kQhnTottJU+VLO2owpoaQnEl4uX7xCEj/RXTfesUWNNRCqstgL8nRezqN7x1EiRfI8++z7sE3T+ePiN+1zX+UIDhibPgohE5X4a3evOAW3YrhZyFm3Ec3YnB6tAKy0LZliv5aKPKf7RI8MZaVlZ/Ucul2CurgrcptxcG1Xwa/xB40cWMW2BXsewLmrKqM2i1SmNnJk4xb4y28V6lOZV34zAsBS4VPK1IIehXKEad38ArD0shupng1kpzlENNMm7ZY+mBsKl7FHFxT8FO4ayGyxeb6hKnc+/jCYGI+1kRuOGsGpFaF3RSJStglsJXdXEzIzfNOTb8QuyzzrBZUyDrZ/Y7JOQ7rMSN03N5zoVCDVKOPqs59VFOiHMrHHP6uj53UOP7FWBoJK5c15T+E0i6o+8hfbnwRr5Y20CrIiCg9UOroHB/KbwGFr+rSYQV0x0z+b7iFFSnFzFiXXIc64LyQVm1XTODVbcUbI+qhgc9xVxSmNq7MMvyeugVDvrwIHTLxNsc+6P7unWyEoYaUG5NGu5lOC4ENYydC4X7hWd6XmNwUxD+rvaNac4IGnQpBjfL7owsNA9ODsYvrgxpeX3g04SRADAZkjlizQVWQwNaSyP0xa/tOBw2cvOLbvEYDIetmYHdYoVG/kjFMk1bL5rCjA2M4vzy4NUtF1Jnz+0A+E4UCq7fLzhFZVofrRK+BSqFFxgYjzHmzBC+BmrQGIV91otQaPXbEe6d3jQKJE
 O4pRiRkX
 /Ql6Vm8x4HXjRqFvNmm6ywOGohURArSzPnpfhikSeGuStaO4uG9dZnQKQoSRnpHRU3RJQEdjAMYSCZ1eouc9giFGfKVEwEJfHPhdg/EsQzeX5ziImylpnRgJ1SeUkoECtnxnAJJk2/D95pOx3NSKMieyf6NeOoDOe62xCw2FJdZaUy/1EpG6/9mc5xgkp+c+GTuMrOobAZGAxf58Y0d7MmWVKj1jQOZsIM7+Zxns/SxxQIUtQXDo84AYpaA1j+gD8iqG5PEGX8H1wUW0wCXIW7ktHbqIXRDURh4ezXLOIIvBReZ25auS/zRARisi2TxBMy42694cNLIvem2UHWvJpB9egk3sw8wFLZzgPQL5OTQLeoKkt7gdHdA+dWQvQUAVqGx9k/XQ8QqVU5WM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 5:54=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> On Sat, 26 Jul 2025 13:23:24 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>
> > To support allocation trees, we introduce a new type MapleTreeAlloc for
> > the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensur=
e
> > that you can only call mtree_alloc_range on an allocation tree, we
> > restrict thta method to the new MapleTreeAlloc type. However, all
> > methods on MapleTree remain accessible to MapleTreeAlloc as allocation
> > trees can use the other methods without issues.
> >
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  rust/kernel/maple_tree.rs | 158 ++++++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 158 insertions(+)
> >
> > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > index c7ef504a9c78065b3d5752b4f5337fb6277182d1..8c025d2c395b6d57f1fb162=
14b4e87d4e7942d6f 100644
> > --- a/rust/kernel/maple_tree.rs
> > +++ b/rust/kernel/maple_tree.rs
> >
> >  /// Error type for failure to insert a new value.
> >  pub struct InsertError<T> {
> >      /// The value that could not be inserted.
> > @@ -378,3 +499,40 @@ fn from(insert_err: InsertError<T>) -> Error {
> >          Error::from(insert_err.cause)
> >      }
> >  }
> > +
> > +/// Error type for failure to insert a new value.
> > +pub struct AllocError<T> {
> > +    /// The value that could not be inserted.
> > +    pub value: T,
> > +    /// The reason for the failure to insert.
> > +    pub cause: AllocErrorKind,
> > +}
> > +
> > +/// The reason for the failure to insert.
> > +#[derive(PartialEq, Eq, Copy, Clone)]
> > +pub enum AllocErrorKind {
> > +    /// There is not enough space for the requested allocation.
> > +    Busy,
> > +    /// Failure to allocate memory.
> > +    Nomem,
> > +    /// The insertion request was invalid.
> > +    InvalidRequest,
> > +}
> > +
> > +impl From<AllocErrorKind> for Error {
> > +    #[inline]
> > +    fn from(kind: AllocErrorKind) -> Error {
> > +        match kind {
> > +            AllocErrorKind::Busy =3D> EBUSY,
> > +            AllocErrorKind::Nomem =3D> ENOMEM,
> > +            AllocErrorKind::InvalidRequest =3D> EINVAL,
> > +        }
> > +    }
> > +}
> > +
> > +impl<T> From<AllocError<T>> for Error {
> > +    #[inline]
> > +    fn from(insert_err: AllocError<T>) -> Error {
> > +        Error::from(insert_err.cause)
> > +    }
> > +}
> >
>
> This looks identical to `InsertError`?

They differ on whether the error code is EBUSY or EEXIST.

Alice


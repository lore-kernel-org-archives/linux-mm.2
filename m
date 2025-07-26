Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ED5C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 16:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC7B6B0088; Sat, 26 Jul 2025 12:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6BA6B0089; Sat, 26 Jul 2025 12:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC0D6B008A; Sat, 26 Jul 2025 12:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA506B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:42:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0F4F160A7F
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:42:07 +0000 (UTC)
X-FDA: 83706983094.19.B223F7D
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id B48A440002
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:42:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wJdxgDKP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753548125; a=rsa-sha256;
	cv=none;
	b=d0HJMHnzgVAanlzCAH5/gTk3H2USUw/N8cbinkFHaqVpDRYYGB4u0Megm61IwAqB73h7Y7
	qSZCjLzEidgUE2uOol55z2H9TZ4mqV1g22NfOy6r1bKTWeRvnnAO3uR73sRJsyEFpXcTJK
	4bwBO517zkAdf9aWiH6+jQsvk9vairg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wJdxgDKP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753548125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVowoy9yXuuyjz9Y28xfyjUbBH8nqnAtp4z7aeOQXpE=;
	b=60k0l34RzaxOT7MhSLv4GKC4qlqkFmLNZMugnHU+l0tc3T2dcFjW1IA+CgoAX4ObZ62O3I
	0ylonYwE0knvvY3U/zy3mI9kg/Sy2L0gfTVQx92bpkgPS2Cma/UwprijkbAAAzSdrdxlop
	q2C/hSusaz5MGSEMj6PA3Gcu1uvd4Qk=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a54700a463so1830074f8f.1
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753548124; x=1754152924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVowoy9yXuuyjz9Y28xfyjUbBH8nqnAtp4z7aeOQXpE=;
        b=wJdxgDKP0vcWnWF2SrUhYsnvHhCFt3W0G2a3rKig3wiSXCcDmphefZz3aC3Ga2YBQU
         LJ0hX68gyBi/8WSre+c1GKV0dzT94nmGHmHW9nOPzlyUzF/j1v8w7r7RYtzJQtuBihUv
         ANZD4rBR3dYbjwm36sdAN3FZoM3U9YcP5rs8NaE1837urfg7fIgeEAOHO4qQW4JOd3ae
         GbSkyqgfN669+zQBDjW0oEPFf+fn8/pEIvDiYfqbR6yUzZFVSEUt5dvRCcab27kjI8xl
         59auk4eNIxh0XeV6hu90UanUnVI0zAK95FwOfOtXUsH+Z4s8HY8G47r4MX1keO33BEg/
         B3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753548124; x=1754152924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVowoy9yXuuyjz9Y28xfyjUbBH8nqnAtp4z7aeOQXpE=;
        b=kXUK8EwgtpCwKqrwEGF0/VhY8RxbOhCHLBdO82nOLPLGKKjUoGyeGRZ64KktRQWky0
         XcB+dcEpIypI5neZwwRMp41Rl1MdZeDOr9utZLcZ7kL/gyrUUyGez+7WaBoOhDQZXSOA
         Sh2DwedNZjTXv4PLHxOEO1SAcL1S8lvGL3IOhKh7ecXRpG8KPx6MdOaiEuJ8duYgPp9b
         DCxsUc2VcZVUjr/TaFSeZF+YnaxSIeYrMV03lJm5qFKwjEkBMXdTYYWOYyVL5VCpZBZk
         mxeA94wbYz7cNrTZHWcJPUyXQNuSA/GbyBijxJlyP4GAU/Ib948n62III3N7SzjfHYXL
         nodA==
X-Forwarded-Encrypted: i=1; AJvYcCXvnmmgqK89lXoB913ECkJITaTKrw6tIL8RtocUgCMx/HsEPEk7FjcUTwgNu6TYB0Q16I1X8cxBVw==@kvack.org
X-Gm-Message-State: AOJu0YxthhgxMv9WjdfZHiaiZXpzz4fhywF5h65IIWmuWSU0kkrMM/bC
	poj2JQR0gq3RR+smuq3qQFIJrY9jofCRYCHyBfW7la57KBCwqPLGyJAcpj2xjGJFyzQ5NEgP8Yd
	uU2KizFezLB+33w5BzUACo9ExMv9sHvmlI8UqPvpK
X-Gm-Gg: ASbGnctKV7zwfCm9yLh7w6Ek7whqk+QX2+LnCV/gclKG53IlmTWCRgYEyDhx0ESTYtS
	uTescUWsk/uITdrerDLvuXOVLS4VDrqz7OsqE5gznYqeB1xdTpBAOPcz6+BWj1V0ZUf5TqAJ5XC
	g/u5/OZFPtrAL3vdfrh2Mn7zYAyIfruqtGDTUHO3HhouQOYIeb5Dou7IUN2CeYXypp+OZUUVdmU
	QJSSiXG
X-Google-Smtp-Source: AGHT+IHKtlVV1+6ax8KWh5Kp9Dj1RbPC7OFascTx/drEMtBpiZ7aEXwLkXXw7M9yya1yZA3wXzUXFkeg8MSM4MgMQ+I=
X-Received: by 2002:a5d:5f46:0:b0:3b5:f6f9:e803 with SMTP id
 ffacd0b85a97d-3b771356b1emr8410888f8f.14.1753548123995; Sat, 26 Jul 2025
 09:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com> <aIUA_HFLXMYNxWDM@casper.infradead.org>
In-Reply-To: <aIUA_HFLXMYNxWDM@casper.infradead.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 26 Jul 2025 18:41:52 +0200
X-Gm-Features: Ac12FXyIP9paBBXsCG4P9QMFCVmav0Ib6KKVd8mim4mgY57RAzHx1WLjuMaq_mc
Message-ID: <CAH5fLghw=6VeXkJm29a0y6QX=--u27FT8erYxDceB8JyT4KTUA@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B48A440002
X-Stat-Signature: xwrp9jp3hio9haamo4pmdzmb59kpdhja
X-HE-Tag: 1753548125-92382
X-HE-Meta: U2FsdGVkX19raka7lwQzW7eiG4Vr0sSWe4YRxOiVk1PER570BrqKb6yi8CoHavwzieoLomDIHmfJ9REptjjCR2K4SXLO69CLUNx6GvR3mfAnvKOo0E466W4b5nfXSMqETydyiRzXoXCkqx5tCA70zLUXkbsyRNh+hI2T+oT5QnxK8j7NBvbTJ28YYpGWlMhx8mpN6k8wzZOjNuEJsKv3LVaYNtH1/o+t9GvvCsuTqzHAlWgVfAABIH2OmgxJobbBLxiKCx0G4DJ/3ibq0A8+a7pWrzio3awUDAeUqVCqw363mMg9FEGBBAUslMOLGVqEImdOyPns1vC7zJIM8Ftt+37sEr48Mp7xHl1Ws+bTjRGBxWQSBk/W5F6ei6UUapJcPKPL61it8NwCVq7oEcOgmrJI7uq9FlJD30eP4EhEpmZMXc+nBJfsbjH24o8PEpRPtOSdqBKKC4urwcqngm6jtZXTj0yhBAdl9IK7gG+wBnAisG9KCwjPvJPPb7FAfNjE2wzm23gcNd5mLQ4jFb29aODX9zL+/ORbM5oNgMiXI+iJv7nWckvfM427SgU1P1XIC2aIVhz4W6CpzC+MIDu624CE9ChHMqCb93y0uBcAhq91h3xpSRhNxwk/TveTO55E2d3B6dDEcynpTkmtBMILQOUQLYaBsNI112EF8tpuehy2kl0yIL3epRkUEjz9T1b5Y4elFns/TR1saPNbKpZHIlGd8sU60B5yb2WQtfZMX91uC7bjQ6/hq+CCyw+jJQ9FEaAEFJ5Z8WcHcdFZG5YUdsI6JT9JArS04SLptmNhFpjf+TXPcBro1a0nmy9pToYfMcaBSM1YPpKuCTkHcS+PX+gvVHJQdxxbiq65jL3/n41L26sExkirnDLTZWT5NQD6hanT5HvvEahajpijzxd4nS+0HFvkTbgkPzQLBXVwdnr8KScJWePWu6DPXbZa1SaSZf98uRrFZZt3fqYEGQO
 lEyU1k+h
 +n7pT+3/jlO7oXKvm1ayj9ZF56RmPrXp5w1b55GQRe4QcvMIPZKkkHqzePdQcd2e4Tmny54uNenlEvreNfJb+AsEpSC7BlKkbIz0DwrB74DefDPhxfzApNiPv46/BkCsqrFanyT3LxudnmvtJz4LMxHiT/RV2X5+kPB5slq1Qkd+2UmrDf+k6ra5BgHbx5Bk4J+5qUNpjsiwcv4/4/puQ5O+d6Bw/TSU11OHGiKJlNIk+Uy4QH0KHEweKIhdzCXSTRBkCtSzmn9GQZlApYwpZHvmx+U1MYZFb1BQ3NSY/9OumwwP4UJ/fcI3hOqacGbodcfJALtCOaHOaKgztRNkdD+sfgYSAy6dckB+NTgRCFhLsYMfBblInZxDUng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 6:23=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sat, Jul 26, 2025 at 01:23:22PM +0000, Alice Ryhl wrote:
> > +struct ma_state rust_helper_MA_STATE(struct maple_tree *mt, unsigned l=
ong start, unsigned long end)
> > +{
> > +     MA_STATE(mas, mt, start, end);
> > +     return mas;
> > +}
>
> This seems very inefficient.  Returning a struct larger than two words
> (on x86 anyway) means that the compiler implements this as:
>
> void rust_helper_MA_STATE(struct ma_state *masp, ...)
> {
>         MA_STATE(mas, mt, start, end);
>         *masp =3D mas;
> }
>
> so that's about 72 bytes being memcpy'd per access to the maple tree.
> Sure, it's stack, so it's cache hot, but surely we can implement
> the equivalent of MA_STATE in Rust and see a significant performance
> win, at least on read operations.

Some of the methods go through the mtree_* functions that create the
MA_STATE on the C side, so this isn't always the case.

Regardless, we definitely can avoid this helper. It has the
consequence that if MA_STATE is changed in the future, then the Rust
version of the method must also be changed. I can add a comment to
that effect to the header file to remind people of that.

Alice


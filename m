Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5002CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349566B009A; Thu, 21 Aug 2025 05:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA406B009B; Thu, 21 Aug 2025 05:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9A16B009C; Thu, 21 Aug 2025 05:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 061A96B009A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:45:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8478B117561
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:45:27 +0000 (UTC)
X-FDA: 83800281894.08.C2D98AF
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 830BA140014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:45:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mWF2h5SM;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755769525; a=rsa-sha256;
	cv=none;
	b=SECDh2rsdFHiOV7dXkcR4C/usIQ6N3edTQSsJs+RbvvdwUcMSpyLQDVXR419/OoWfIzUuE
	EB+hSVjTOfqSbqSopyAH7FfwavDOEKnwp4V3uMRFetKRGb8hdPs9VDUVMIGsU5yhgvH2Ml
	WholnaRpRzvJ2kAhDX1skbCn7P23WlI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mWF2h5SM;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755769525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYYHIISUuCy2JfQNPh+L51Upj+t6+AJZfjbcWAfxVxk=;
	b=XzPq/fHo9YrwkLWjvTFSmcf5xvd3FBuHTA855tCjbJcYx6oAjDavr3Ap7GnnjfB4oTgUxJ
	Ri3dVuu8ap3nm2ID3YpJLytCeL4bKv8+2dj+u/h3G4BforW9pZynFP7BOBa9hKRy1QHenK
	DFDHjAnJn4SV/C3CxROaM7qQmxKqNMk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9a342e8ffso562507f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755769524; x=1756374324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYYHIISUuCy2JfQNPh+L51Upj+t6+AJZfjbcWAfxVxk=;
        b=mWF2h5SMXy0QuGGDlVxvmado1vAFeAk6un8mW5ijf/v9son3e1nF0Oh066toYVtyfm
         RbuQHaEkpt7ZKUJKxH6fPOJnW328AOI0QWkWBb4rtu0G9ItxMFgVkbwi/BPZ3CN91qgx
         gmRWAj5rwqdT6jX75sQC1611Oqu44RY1Q3el4fPTwq/NNksYL8xlYwEoL+MHo6Bql0IM
         DP2WsZ0JvLFaRUg2QAUGN0xbZ9fHuY46qd6tk2KACPlyE1rGXFMHbQ1jMpg03nOgMgWB
         OIrTbltOqfe79Rahf26A8Y3DxI6DTizOAZlCnpLef5Ja/yx6sWY1LIw1vftREB8OU8Kt
         z54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755769524; x=1756374324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYYHIISUuCy2JfQNPh+L51Upj+t6+AJZfjbcWAfxVxk=;
        b=eruWEWdtX4c1N2/j9UrnKd3TGXizTmjLYio5yDFMiS1CR+nSbtUnJ+xjAHWPBcDYcp
         XE6HayPczL30a6pUnVl7RViCbTJRfkHCTiGu/UEPJxs8+1VEgZs4i/z+zCPiVTXrR/Ka
         CUIzYyFR9DA5iUzcUmyeJ/6dijbsTpdudzPzupK3+xOv0Svinfr2uoLEP8O4KKbjq5jc
         57vdUKyHhK9YW49j0Ld/wg5FNyACOWFL3w0dm8JP0bvC76tGDzZbeQWcRNJ5k4iTUSxH
         YWOkFzZYzD1BoUut2/j9AaqJtbD76AyIu1UsDiHUJpJArQ1I4z5HeFPhCuraDBh2uaYW
         rEbg==
X-Forwarded-Encrypted: i=1; AJvYcCUMZ9ax95UDZg5njRmn/86t+PKnp4NyYnU9Q/fiD24hRaADb0Ub5wcx59SL+B9v0AJPs8btmTNIuQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6e20Q7zEp78rcVEyE+SL1NU54pOyQm0KuX55MQUzrBlcUB4gM
	ucR244vsA+g0pz9XbTW1/tADmUROFT2nWhKSbQP+Z53xEPIQq2XUX5taws7H9RSm1/BPzBdEHIe
	H6ZSs8PLkIMlTHtr+VS4frTyBRKnW+HNX6Q74x4Am
X-Gm-Gg: ASbGncuaEI7wOidFN1rWrJPz3B+V+hijOxbiZqVxkZhBCBLMCZ9dCnKTbnx9xxwhkLx
	qTcYfvU8Ddjsw/NUcaNek6SAPzTww23cQBWEAIdYL66yedwkpp6LEAIe5Fvvhhy9GQVQi4rdtK+
	PBdosuY1PBgX7HFmpLV+X4kfmQm2pQ93WQhIpQAS7963WuHlVUPBC+gmgiNqh55AnfTwMY6mo1c
	2nkEtH6sYiX/sOZQCaXHK7e/U0IRiTcW4N3yq7Ebxrw
X-Google-Smtp-Source: AGHT+IGn/wQOgVGJFmdB5PCUsV9/j1HIemTZs47Lm99Ax8kZZi+0rJsXvH9qzrIslE8FnssJag3hkMGPPm2tMopx1XE=
X-Received: by 2002:adf:a19c:0:b0:3a4:e231:8632 with SMTP id
 ffacd0b85a97d-3c4b4c0f1c4mr1130278f8f.12.1755769523630; Thu, 21 Aug 2025
 02:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250812132712.61007-1-baptiste.lepers@gmail.com> <20250820162927.34201cfb395ec7319b15920a@linux-foundation.org>
In-Reply-To: <20250820162927.34201cfb395ec7319b15920a@linux-foundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 21 Aug 2025 11:45:11 +0200
X-Gm-Features: Ac12FXwc6xuQOhVNEpGEy9nGpcxRQ0IxCgJJo1p3FE9jDQG2LnUgqbP8cpbBPG0
Message-ID: <CAH5fLghx7K1fsdx15VsaTT1i3DRQD8zH2Yd-sEwumiByefTVAQ@mail.gmail.com>
Subject: Re: [PATCH] rust: mm: Mark VmaNew as transparent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baptiste Lepers <baptiste.lepers@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 830BA140014
X-Stat-Signature: i1ykdcb5tpw47e79r9s34tmbm1qp8wip
X-Rspam-User: 
X-HE-Tag: 1755769525-368145
X-HE-Meta: U2FsdGVkX1+CJmbH9xuSqm09arIB5KsLAYDy9zDRHMV58vGA2CkJTx4uy3lAcLz7JqkB32k0jRtoQycXr6lYobbGMRiot8IbwtRulOABW4stqCAjfo0Iutm6c28zXFeZQjVEBPJZMV5rBddkDGGDc9d33IyOIKRXy2ElvX0BSU5fSuuQ27RgoBLZBuFDjt3AQH1uH4+Vz3iUMTYUSflMQX1m0w/0MZcMzON5k4t4mwefs19Fax5GMD1JX78l1KTNE1Xbl5kSgEKiyrbl4jVmM0hgXJYjVj63Toemyz5wM/st/7fR5lR0a9YPknfmZk9r7qvh5sJssh4XHvYQMEQr5vWAaL1AxRC5yeGYlZvVmqzVPTlca0FD0kJHt9m3UeQBihxqIOKxk24Wv4VLq/mvRTiFIslHqlPUNiYa1PTzpM9/AF08pGt/cv1QvGFjnLhfjj9YIgUPu7lBO/9iALd+UySSg9vATyU29RmUhBSc1VN5t1EUxD+106Kb62D+Jlf7+WOWa/KbNai+NYFqAjc054GjU/E7avwL0td0tguXUFjFkBV3XcOstBKM4JaJuhbX5XyNYHLUnt1GfUasRDRPuHfvrjnuvbGxHwlr+V0xHZlE+PIWSuRSS8v0vhg9tpmQU1S/qNbFq6Ve90KDK/Gzc3XRTBSy1YWN/HihZgY8gpuy414yOpYV0Wm9sdgpxnwYBAjw2HcqjesoqMfZ+dJowfDFhd915UD4W+z38flCkz7FQYE/DPuVt5onxKFdgrzYfGpwNDaWTW7HUy87tFucQQD5S+gTCYnBhoGVSFibuRkg9f2vJ0YVuxR7g920cM9aG+EvkqSos8iNm950i+/dkvvRYOlQrTtNcjbuMWQf5fQ34gQkmHV3CbkL5Mp1+sNyINWCTA5ZfT24fb8M/CNoccRijF7ca9nh2dshGDZSnnss2PgMoAFFkBWEbJPFpQc8H9/JVvWvfDbC8/g/6pD
 5gYVB7+q
 APt5DRboRP5jcS62G8UIBHhL5mPo/mf78yWm9bDZspOgqPdHirT+lb3GK/RAc1nhh5RAsnLaSa1L9n3a+QG3yrTH8Tsrgl/HSYOms87VsijyV7mSuOX4uaWdf6nmFQ4H6Izc7MtNk2jwzoQJrB9gKKe5NHV/w5FMT81o4PXas601N4juW3QBssje0dRM5oCCMPCQOjYQMMinVyQzn+0p01rjQLfUKYt3R/+HGDFY9DEgMOgLTHo43BPVky12V2QBnhcGmkJDaDSS0dzN8A/zDXmByfalcxvaYbNJ6Ir7jGkABxN6DQEGny+1JCPn1y8UcZ4IpnNsHYEyNPg2sI29TJMoIUZsFACZN6OgU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 1:29=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 12 Aug 2025 15:26:56 +0200 Baptiste Lepers <baptiste.lepers@gmail=
.com> wrote:
>
> > Unsafe code in VmaNew's methods assumes that the type has the same
> > layout as the inner `bindings::vm_area_struct`. This is not guaranteed =
by
> > the default struct representation in Rust, but requires specifying the
> > `transparent` representation.
> >
> > ...
> >
> > +++ b/rust/kernel/mm/virt.rs
> > @@ -209,6 +209,7 @@ pub fn vm_insert_page(&self, address: usize, page: =
&Page) -> Result {
> >  ///
> >  /// For the duration of 'a, the referenced vma must be undergoing init=
ialization in an
> >  /// `f_ops->mmap()` hook.
> > +#[repr(transparent)]
> >  pub struct VmaNew {
> >      vma: VmaRef,
> >  }
>
> Alice suggests that I add a cc:stable to this.  But I see nothing in
> the changelog which explains why we're proposing a backport.
>
> So please send us a description of the userspace-visible runtime
> impact of this flaw and I'll paste it into the changelog, thanks.

I don't think it has any userspace-visible runtime impact. But I've
seen many things get backported when they are incorrect even if it
works in practice, so that is why I suggested to backport it anyway.

The annotation makes it so that VmaNew is guaranteed to have the same
layout and ABI as struct vm_area_struct, which is required for
correctness. Without the annotation, rustc doesn't *guarantee* that
the layout/ABI is identical, but in this case, they are identical in
practice even if the annotation is missing.

Alice


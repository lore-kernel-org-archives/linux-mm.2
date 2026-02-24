Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC94F3C99E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054ED6B008A; Tue, 24 Feb 2026 10:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C226B008C; Tue, 24 Feb 2026 10:53:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BBC6B0092; Tue, 24 Feb 2026 10:53:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41146B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:53:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79782139389
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:53:02 +0000 (UTC)
X-FDA: 84479793804.03.4133945
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 646EB1A0002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:53:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OFZWLh4W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771948380; a=rsa-sha256;
	cv=pass;
	b=D5TcHqheZdCnez/uDAFOazbvLYaTbTb+BcdWcsW9a7ycX+TAiMSSuGijfWx6KCTFKqUyzn
	+EMeh0dJbxVgM2kw2Ne2twpK6Ifa5nXlGjasY0nwSV02BrVu0QxwBzbS7d+fALkgBIQfkF
	VhN3+RqhuN5JkXwARKvC5QziAl4YLCg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OFZWLh4W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771948380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JziVrq5fss/MAO+7T8PtTVr7rtP/29alI+wDNgqPzLs=;
	b=W6ZnFxHJy2CXn6+4J97uPbvkFX5cSUiRvvDqL6rvU1oKlOxts5txZaeveUklJpbxqwaMM0
	yFLKVnsgwWFxacWp1s8gji/0eCpwnt9uY9Z4xeo29+o7dEYljln5qTjTaMdLJDmokzOCKY
	ot86QOu0hBFUXZIn1227E8K1dIBpYYo=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3870cbd6c40so50281361fa.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771948378; cv=none;
        d=google.com; s=arc-20240605;
        b=XgKnAok/9I9gNSvzmqG0XwxDtuJ0+v2ie51QfkJC8KJ10yWYZPbujKn5sYaD25XKpO
         pIgoVljH2ZMVNQ09GJPlPlP6Nx22a8G5YV2OSWE2rw9HnGySSyKJazVhCN1jOkypnAd3
         LZ2TEHk0xuHom0fKoMm6vVEJyD4XN6Vv+uUhF9Rmg9cre5f18P294oPa0nUenx4PDRVI
         MhFeCj5Meh28EiW7rF8Ux+0c7VbiUlkkxGwyYEvXHIgAKYjyvY7BYxqxBfauL0gAhoeg
         qiEdX/x2jf29uk0PK8yKiXYscyW6CateLHGBZC7zaV5VGwUW1TzwdfUheM3egteIV2Pq
         q1aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JziVrq5fss/MAO+7T8PtTVr7rtP/29alI+wDNgqPzLs=;
        fh=iuLnU9W1+fpuHgar5F9gGIHPqkCi9iE593PNalvzCS0=;
        b=K1oFcDmpdjarNZb5OrtLtbtVfI414XtFMnteebZwDqgJBOq9BPhb0G/hm/Bkmpc6pP
         jS9zVA2XLV/gJlbk3uVN1dEoynXOz7C6xWCpOsz44uepnuPHV0zXTFMa6dkxzlvo8Fq0
         BDLcEr1TSRlOowffwIDn/sdKdQJMT4GrhyyWdbtGiNOctBkWxec7IM4GbAWPxGGkBD+v
         gYbJRR0DXebwL5Xwhkj0GcF6NXApdT7Lm1Ef3MD1Ec3oUu7pp2uKejW1/Qtz2TdtwwsM
         pISNahIMvXBcYsEmXK9fHI/HPVyLVvlpVAFDbvbSBCFfAnd0LwfTKuIDtcLto4Jxitm3
         4jMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771948378; x=1772553178; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JziVrq5fss/MAO+7T8PtTVr7rtP/29alI+wDNgqPzLs=;
        b=OFZWLh4WBfnRvlEDz/h2d+qwKEcsKqJYey4jCC2gSgs8wfsw3EMhYIJrWWW/PzKFre
         w+EKV9RNSZuxTu6Dtk00Q4lbNWpXa12EMTH75ozbx2YxghZpWOUIOpFv0TtI3QbaB8Aj
         zFnlXm0iqXcgYBY6yWM16r5TA5Jw3yTJh7dG+l9mbEnSXDWvJuBot2vVZIR4cGra/YTa
         auhoP1Q1JJcqnZY9CkmZIXxWcOQ7viWo1wtDxPa/LRrW7Bwj8hwu9CdgvnBzlqud+ILY
         3wnTfw8Z2WlHtMY8Ytpqn/NtgqrNwSy2zQADvkwC0JrzGmbivqVqszFaf4MXURNNdUYk
         VhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948378; x=1772553178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JziVrq5fss/MAO+7T8PtTVr7rtP/29alI+wDNgqPzLs=;
        b=BNK9zdgn6QoKirvLybDPTkFv2Ih6rZwK3jTYbWYZq7X2hdL88pQ2Jmjds57YY6PKri
         QSRSCvVOQ+1vj3tTjYfHQAZss9W6FF5F5Y5frkk5J/F4rcUC/vIVdmTs17jAcFzHB0fg
         3ZS2auzI7CKGsrWleanHRMkZsCx7RIYflNRWSuXZ8vCXQCgFTlKJB4+r2y5q6a0W6bCV
         WZa6ptIg8NvlJzTzB1pS6nPQn4EpiGkja7+L7uLQkWgYWPwQ/j1zvyWnnc2TOpu1ahua
         L5Pa7dPqnjDqc+WTlb0bvytFkNjBuy3ZmnICx35JEDPSEVq9Cjm6jkYjnup9rMxem26e
         NzLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2D95opUCqoCIJrx1zi4+qhAo7O5VSa6u+NXnmMLEdK+Q76auwbhXHFEReDVRLWryReYnjrDC3pg==@kvack.org
X-Gm-Message-State: AOJu0Ywf8EWPA/0xiOXyrBCJaDAFc4AXEPY8xW9E5VJd3xvHWQ0IWiCh
	UtUXAYPpKz5cyjZ6Fi0ZWrVKUBIBSLfS2QGJst7DKnFBrqdx3bQguR4klbolrdA/a99dbdRh8sV
	qoLdLZGoPymjYNolh7Yfsly1tFWiZb6U=
X-Gm-Gg: ATEYQzy3MhbniCR4iYbNfc3JqOdQBz1O8GpiO2Ds7xLJiCzPF1jwE2V+4sABlbAvrN7
	E1MCh/2jBlG0KkIAMpt4AwcTLwHu+y27kypI95fMFuwjDl4RYmQn9uewiGFgQsknlbRWRbZL6T1
	FPNlZythE/ARv83hX3YBedwogypRw0+7i7+gFr6aZQmH6dSvW0QnpzjuvCft7vB+fEa3oZBTqyh
	I6hLIf2A75FyG0YAfI0gBETSMTrZeL1/i2qa9o6r9TWJ5G7E9ZBC9vhLdLwkRgVS5ujaRCMAdCe
	zZngeCltyGWxVa4KFI47kcTlqRsyx3t2RaoD6Rdwgxo4Y+U66L+OfipRx6PndjNrNMWW15nvVBw
	WalThzZ9EjOxw3ShINA==
X-Received: by 2002:a05:651c:110b:b0:386:fe97:a538 with SMTP id
 38308e7fff4ca-389a5cd69damr32928291fa.9.1771948378286; Tue, 24 Feb 2026
 07:52:58 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org> <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
 <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set> <4V-olEAuXuPUO6t34rF2sn2KT3zYNdPHxGclD7-fJjKJNoXQPZNDJfc_ukQ3VyGVnbbdbCasUteYnH3U97s2zQ==@protonmail.internalid>
 <CAJ-ks9mtwo6eAvmT6qbL+Mg_=A+-zdtiBw6BtsfO2eZ8HbkXWg@mail.gmail.com> <87jyw2171v.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87jyw2171v.fsf@t14s.mail-host-address-is-not-set>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 24 Feb 2026 10:52:22 -0500
X-Gm-Features: AaiRm52Cj0fzcvfpEDR8RU4d6CIE1LaOtFAAcUcZ8Cs4-VUqujC-H0IrySo1FlA
Message-ID: <CAJ-ks9nPaQ4oWGkr0fesvPdfxt7gb-4g5xE2xUdzi+OB5EJ9pg@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 646EB1A0002
X-Stat-Signature: bmbrfyquhin3xjw7jj5i6dp6sr83i1z8
X-HE-Tag: 1771948380-88595
X-HE-Meta: U2FsdGVkX19tC1h2PebxS4CoH7ClovA4cUIRU35QppiH4UUSf4Ut9W/gXnwpLGr+qmfh1cwTv4B92imeGn0z6DWKsYCPAk74POJx0XoT0GZzQcbeJ+ClJmDGvq6S6POoXMujFZeak8zMC2S62fKNJKB9FQ/QtVJRjiGQ3+GvthAnVn4xAPkdSJ92FdCckvrPfBFEeOiMWxIqbp5ko7hlnOpIAJpH+ffwFfG2mAtbyG03R9VAIU9yEH2q78lQRHhs8RzdJcWeLI439F0okpWATZ6IKOPkYXz8DMRULpH1ZHw9qqUANqplgRCgeRTDs8jusd+rDrPsoMgCFz/zhMS2bgADql7GEejuH0upcm1SL3i4K1r7lTTu2ie9qNLl9UwMiCTuQ7EhNAjhcHPkAM/2CpeC2sXkkZJem+vfP+bJrmm0SC+j92Fwd3nNhZvRJwL0mcPRmbxDIo0MwUh6V+qv5Mr5ru8VIC6ViENWpAaKQWEgYxRVSB2Lfd593dB5bPC3tHteEhM2heyt/M4IS4tN5Mlol4cxzNh+L918T9zHBianmkC0VzbhGVNOEmyKMKhC5WlrEZ4y4Qu42yq5l99E2vWK/Q9l3Qa7qNmgHWcc/fy+nhpTbQEFz/35O+r/c4DzO8CJh+xb9FGd3DDaQWqtJq/kmI2UHBCRcyn5Zi021Nm5yWBjG8SwY6uyWN0SkKEPH7Z0NlAtThxLVJHsUZOhKAK9lVMqt/3eylEm6lPaWLrg7Ue3LOY1pyEGg4xPP8P/l12bbk8sZX1ywCo0BFhFmlOpM21PuoWp2g2qU0vegLoBpu5wE55Gg0T4rAJ9MWvnOrqeYoNpVmyeoh7myZ1m1kCq0HgW4g8b5dRD43dcYX6ZPTBbb1JRqUpBjpH/gRWTws2ixy+sd42hqgKUgE+/LO7tQckvBjZL9tk9lm/BPNpyQSTYswJU7k/8jQjKEC+U8yaE/kJ5rUouXA79CTC
 GUtnoyW1
 NFwOV0npWJmkotVtfBMK3X2f/1G9HXGPjyKyjbVDrNBNy2sUkqiIWO1jWYzaSHbI3uTsQ3SXMyN2ZWiR7+onZIISpSUivrnq7NxJHRMGM/kJ/kaGSJMJ/+aYBgHUQtWtlocj/WFcPFKbzEYOH/lAQOXCPheNyBp3ADQnzj3O67Q4A+Dl+JnehxmLF/D8xMciFrG29rWsuT1JDaPpfj2aEfIhv36KTRLZOI+Kf1K0bqbhrgy0xYmqfv9NXPpArttOWQEotENVkYUo8JKfI7ff9uYUrUMnb4EynbCGJpx63U8nJzJoCImnG+Hhc/GmdpjAYw8QIcWoG7J9uvg7OSYKbIPpd0xa+qDuvSVv+iP1DR3ygzm0WMQw5Ast8YfnSA2yx3rHzzhM8eCCJgtZEtdlhchU9mZ2uDrSojmTUK0eK1YmvSoSQbsFgX6hxmAAMF4GUZQG9mYxnU26RKDOjysg5QGEyXcEPXP344qibTfqcM7b+Udtf2Lq+fCp3Z4ktb8qWTU14ELyscittLXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:43=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> "Tamir Duberstein" <tamird@gmail.com> writes:
>
> > On Tue, Feb 24, 2026 at 9:27=E2=80=AFAM Andreas Hindborg <a.hindborg@ke=
rnel.org> wrote:
> >>
> >> Tamir Duberstein <tamird@gmail.com> writes:
> >>
> >> > On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg@=
kernel.org> wrote:
> >> >>
> >> >> Add `XArrayState` as internal state for XArray iteration and entry
> >> >> operations. This struct wraps the C `xa_state` structure and holds =
a
> >> >> reference to a `Guard` to ensure exclusive access to the XArray for=
 the
> >> >> lifetime of the state object.
> >> >>
> >> >> The `XAS_RESTART` constant is also exposed through the bindings hel=
per
> >> >> to properly initialize the `xa_node` field.
> >> >>
> >> >> The struct and its constructor are marked with `#[expect(dead_code)=
]` as
> >> >> there are no users yet. We will remove this annotation in a later p=
atch.
> >> >>
> >> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >> >> ---
> >> >>  rust/bindings/bindings_helper.h |  1 +
> >> >>  rust/kernel/xarray.rs           | 41 +++++++++++++++++++++++++++++=
+++++++++++-
> >> >>  2 files changed, 41 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindin=
gs_helper.h
> >> >> index a067038b4b422..58605c32e8102 100644
> >> >> --- a/rust/bindings/bindings_helper.h
> >> >> +++ b/rust/bindings/bindings_helper.h
> >> >> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =
=3D XA_PRESENT;
> >> >>
> >> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
> >> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> >> >> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTART=
;
> >> >
> >> > Please add a comment to explain the cast.
> >>
> >> How is this:
> >>
> >> // `XAS_RESTART` is defined with type `struct xa_node *`. `bindgen`
> >> // cannot generate pointer typed constants, so we cast to `size_t`.
> >
> > Can we include a citation or explain why bindgen can't generate
> > pointer typed constants?
>
> If you have one, I can add it. I don't know why this is the case. My
> guess is that it's just not implemented yet.

If that's the state of your understanding, that's what the comment
should say. But IMO the burden of finding out the reason, filing
appropriate issues upstream, and documenting these things is on you as
part of this change.

>
> Best regards,
> Andreas Hindborg
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C375FD3760
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C0E6B0088; Wed, 25 Feb 2026 09:09:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32F86B0089; Wed, 25 Feb 2026 09:09:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F946B008C; Wed, 25 Feb 2026 09:09:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD4876B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:09:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A6ADC2258
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:09:12 +0000 (UTC)
X-FDA: 84483160944.23.83E6370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B2AAB1C000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:09:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOcsX32u;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772028550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NfB3KO6N7vk7ILMVW2/3j3b+lh46c7b0pbhNBVWRL8=;
	b=BCFN0UHK69/0oZTbtUpQvvUe5nD/Z0yKRn/jkj96ACLHZOZ+iQasnQWT0MI3kSbJhSps0x
	yYYdsRR8wm6HVc5iaaiuOGdSk03SYXQQHHSdAG3hJiUWYxlhGsa9fFQ9yUuL5iiL//am+7
	add8spVLyN9DW4+tQxSjZdoLhU4zAmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772028550; a=rsa-sha256;
	cv=none;
	b=tfXCoCCcjyYu7wdKjq2/q4swHLOWrFnXOKoZzz30YIcNhAx0+BN+ApZef0Q1HnFvBvlStD
	jUK/4fe5fcE09sgS+7MdlGw2smVR/gJkldCiwW2sgk8Mer7TLUdaKY37dkNZbnBHiU61NS
	krpefoF8bZHipCcz8A20Pa/a9w6a+FM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOcsX32u;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 313B160054;
	Wed, 25 Feb 2026 14:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2A0C19421;
	Wed, 25 Feb 2026 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772028549;
	bh=jyzQIOXdKcvuEjR46zRIHrsm/Dnr2GXzK3bzDHAh+o4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bOcsX32utSzSiHypuBvSMNMSUQyZpzVy4Gcj7yHnKrO7+lu8ZYFeblHo0vdvBjXEl
	 EXpAbxyaWSMoxi9/GjHJ5r1sf3T6S5I0UYjgCMIxMgGuDqvCoCIReItbCRRQlDKJie
	 HcHPR/ofuyTeE4jXlrTynOzr2xRNSxEx9uM5C1DGhaAUMPf495zjKF05JKtgIhBln9
	 jqdD0iyOe5BB6LYRpeanuB+kjt3BlIzm6tc1MtW9M6vD33xajiJtZw9Cuxq31QVJJS
	 RMNuuZUDUPswTXtgwCeYtBZi20umVzEpawp3HYcCdoAsl8r1bY2z7//Cd93ASdjQof
	 GC6BVSznVR8ag==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph
 Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Daniel
 Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
In-Reply-To: <CAJ-ks9nPaQ4oWGkr0fesvPdfxt7gb-4g5xE2xUdzi+OB5EJ9pg@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
 <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
 <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set>
 <4V-olEAuXuPUO6t34rF2sn2KT3zYNdPHxGclD7-fJjKJNoXQPZNDJfc_ukQ3VyGVnbbdbCasUteYnH3U97s2zQ==@protonmail.internalid>
 <CAJ-ks9mtwo6eAvmT6qbL+Mg_=A+-zdtiBw6BtsfO2eZ8HbkXWg@mail.gmail.com>
 <87jyw2171v.fsf@t14s.mail-host-address-is-not-set>
 <y_QmIp8ZbHAqIsn7zWUrSFIzrpWSQWuyla5VvrJq5HUF7SwF_-mwdg1prwQxDAZkyqzHgVOxvEGUEkWE9ukSbA==@protonmail.internalid>
 <CAJ-ks9nPaQ4oWGkr0fesvPdfxt7gb-4g5xE2xUdzi+OB5EJ9pg@mail.gmail.com>
Date: Wed, 25 Feb 2026 15:08:59 +0100
Message-ID: <87y0kghq4k.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4t8krq1h7gt7zjgqk3qm5snkgpwbeqed
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2AAB1C000E
X-HE-Tag: 1772028550-47607
X-HE-Meta: U2FsdGVkX18mKMGL8t0ucnmRywvKlEKbYlMYowEYr5P+R6kiQSk0MyhL/zVkelNg9HWcs+li1pom4eCXkE2LpgcQUd86w4hgpk8DR8ufcqyyYpQSpsFTtQdG3+jx1leQ9eJVO9MklhnDhR2ml64RDZHkQr7YYu2r/hdyDUUTjU2W3JW9V49IMWMXH3miHpVeP9haY895XKEaIojMpFhuk1R7M4y7fgcWOaGb8n4pQWrwItt1zdywbDhIvGTtxYKvheb3PWOTCJ8DaiRIUtMiOzBgsSTMDe0Gv/13TDA3FiXb+q+RceM0ZarlydTKPCVfw+I3GLRPn7w6+E18SOzEXH3BjDKhV5019yDUpTZ41h5YpXJGmqDk5BeBkVNapiTyKG9nP8j4lImtRYuLZQPYGGcn0xbF1GWfhx7hQkihET89Wa47L9p7bnMNGUMJivQwYbTB/9zP5822WXBeBxOPLM9Mj6KGAyOb2cFw4NtekHo2G5WXAnGe+gAM38l56FwblZz5SbANq/TsF47UXtA1xy4fvaipeX6Y/9yuvNReP5ExaLTcd3uLRG5UeXrnhMNjZhZJupCUhMMmMHrsD7EXVvhdTrimyPcM1XwfFEW/l0C1zhkjfd5nMgzVtMmsZRBd7ZuKMP7nzSCnr3CyCDeAKSTCXRmnaKqHlPH+5omUDwn692t7V7dXiGZutPKoViYM8gJxEOr6aP3HPcsmoOXyk6lDM8tmWRiDr2HCP+VMlPatEO72OODrx6hZA4qVaubCGgnSo3yhg2u+jHC59iSni+2HIT2Vh7vfUS/n7qP0vRq6rPKefPkoVzlWHJsHp38WFaqT24RIs9RB0kimhCNhVlhMxJw/pzzWgb8N3cSbHj1Z4OwkdOyGCvwX24c4LKpWmUCFeRLMdN2cHDWp2cgD3p+ndMHrsnbAab+bSpcQ5ZQQRdyuV7u+4KX8v71bfVdoEPCNBAxfcJMMyxINJK3
 ZEaiXyVJ
 q6xFrPq9ARHY5FLnqpMQxCSKyL24M30MR/2ZONNQjaqOphAH8durWZCi/GLYWIbiEDUS9ZYgUM3ddZ8EfWII03wf/fmtSV94/U5tY5+s4Nz8wp6pCN+LqXLxTMDirHK7zCfTYjw0yL42NbOLznFHKV2cuCsfX8mZjBtgxOrYJ6FuqCZ9fk6mJZYSC6Mtkvs84l/GbZwZDGM273k/UQ+gPbynYU7VGneZm3nAsvtM7t8eYTpw3B3U86MddGuZiLSB4J4E/qsLXZ5rWf+u3Q91djGtYt15sNmeklnlIBekfxzWOcgWVMF3cnfjIo1T3y+8r53sTRDqCPF1FIsqBt9eF9xGFWJpcz1/Eu7+yklgpWmXjT6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> On Tue, Feb 24, 2026 at 10:43=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> "Tamir Duberstein" <tamird@gmail.com> writes:
>>
>> > On Tue, Feb 24, 2026 at 9:27=E2=80=AFAM Andreas Hindborg <a.hindborg@k=
ernel.org> wrote:
>> >>
>> >> Tamir Duberstein <tamird@gmail.com> writes:
>> >>
>> >> > On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg=
@kernel.org> wrote:
>> >> >>
>> >> >> Add `XArrayState` as internal state for XArray iteration and entry
>> >> >> operations. This struct wraps the C `xa_state` structure and holds=
 a
>> >> >> reference to a `Guard` to ensure exclusive access to the XArray fo=
r the
>> >> >> lifetime of the state object.
>> >> >>
>> >> >> The `XAS_RESTART` constant is also exposed through the bindings he=
lper
>> >> >> to properly initialize the `xa_node` field.
>> >> >>
>> >> >> The struct and its constructor are marked with `#[expect(dead_code=
)]` as
>> >> >> there are no users yet. We will remove this annotation in a later =
patch.
>> >> >>
>> >> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> >> >> ---
>> >> >>  rust/bindings/bindings_helper.h |  1 +
>> >> >>  rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++=
++++++++++++-
>> >> >>  2 files changed, 41 insertions(+), 1 deletion(-)
>> >> >>
>> >> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindi=
ngs_helper.h
>> >> >> index a067038b4b422..58605c32e8102 100644
>> >> >> --- a/rust/bindings/bindings_helper.h
>> >> >> +++ b/rust/bindings/bindings_helper.h
>> >> >> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =
=3D XA_PRESENT;
>> >> >>
>> >> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
>> >> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
>> >> >> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTAR=
T;
>> >> >
>> >> > Please add a comment to explain the cast.
>> >>
>> >> How is this:
>> >>
>> >> // `XAS_RESTART` is defined with type `struct xa_node *`. `bindgen`
>> >> // cannot generate pointer typed constants, so we cast to `size_t`.
>> >
>> > Can we include a citation or explain why bindgen can't generate
>> > pointer typed constants?
>>
>> If you have one, I can add it. I don't know why this is the case. My
>> guess is that it's just not implemented yet.
>
> If that's the state of your understanding, that's what the comment
> should say. But IMO the burden of finding out the reason, filing
> appropriate issues upstream, and documenting these things is on you as
> part of this change.

I opened an issue with bindgen [1]. Depending on what they say I will update
the comment.


Best regards,
Andreas Hindborg

[1] https://github.com/rust-lang/rust-bindgen/issues/3347



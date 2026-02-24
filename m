Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F476F3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A326B0088; Tue, 24 Feb 2026 10:43:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB656B008A; Tue, 24 Feb 2026 10:43:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327D76B008C; Tue, 24 Feb 2026 10:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6896B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:43:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABBCD56581
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:43:25 +0000 (UTC)
X-FDA: 84479769570.14.B69A267
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 032B6C0011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:43:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DUA/AIrg";
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxQtv1uCPlkY/Cl0eOvXynVYDeQwO+q6e8rMdbg/8Wo=;
	b=Ah4Nmfy4TwJuiriOcrMobJ2lpF6Qq1pSvnuBcVPHJ3JsX2f/uEm8YTtGqpT/XRiM8WHY1Z
	niFDKSsaaI49t4Yw1sNqULt+WlqQDJwqrxto2ZJ6O2zl3bNRJFx/HMZB614TVmOHvCGxSZ
	smMpMzcvEccP6vTeefPq57Zl3zNhmo0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DUA/AIrg";
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947804; a=rsa-sha256;
	cv=none;
	b=45IhHYRYXl9XeRcQIRnkFKhtW9MvWPswoXWg66Gee2XByPwsPmEXhSAbPMVmMmMdE14+20
	JDqN0bKAlbjT6A+9ppmqkggxVgmkpdP0NC845tIa1aNOYVpSaltxbIcFLNFveFgu73677P
	M8tI7Bc7JYY32Cav3QPw8P5+UE9Ad+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE5661118;
	Tue, 24 Feb 2026 15:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A26DC116D0;
	Tue, 24 Feb 2026 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771947802;
	bh=iRZC6waXaSyGTg1hlX1XWHKiFbNvR501T87XQTbp4n8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DUA/AIrgxR7k3FnJJyTi+5evvX6Reg7BYI9fTQkvua1sozXzRqKFFLgpOZlxxE9mm
	 2nwS2J79qmsDcq0Jhb8SFzgIrFJLZ7JAzTUBVLzdoKh9r49gNsNsZAzIWThDiUyNnp
	 LkmYsWTusEIyM4rPVD6rMEXxfhB75OLqaZUlpdjGCHi6v1WR5Vohm2ArLxKVWKFJ9/
	 rr7nO6FJFWla+Gb/dNXMt/geN8+B/2RSjwsUU4x1ajxgfXrE43J8dpnuj17yzzlyTT
	 on4AhSwayhjlmXEfCdfiX4Lt+OfldYwdBFbdeZ0sPdMgLcD8dLtXUQEg+noodaiwcQ
	 9JSAZaOENEfnw==
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
In-Reply-To: <CAJ-ks9mtwo6eAvmT6qbL+Mg_=A+-zdtiBw6BtsfO2eZ8HbkXWg@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
 <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
 <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set>
 <4V-olEAuXuPUO6t34rF2sn2KT3zYNdPHxGclD7-fJjKJNoXQPZNDJfc_ukQ3VyGVnbbdbCasUteYnH3U97s2zQ==@protonmail.internalid>
 <CAJ-ks9mtwo6eAvmT6qbL+Mg_=A+-zdtiBw6BtsfO2eZ8HbkXWg@mail.gmail.com>
Date: Tue, 24 Feb 2026 16:43:08 +0100
Message-ID: <87jyw2171v.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 032B6C0011
X-Stat-Signature: d9n49pe5rmnszx4gb8zqcxazppmcksnh
X-HE-Tag: 1771947803-97977
X-HE-Meta: U2FsdGVkX1/V+4viEO1jGiK2yxQFbE2tKKVjYrUawuQGpn8fhd/mGAUFfxWupvuvMFLQgX14VpLITBXOOuFT4p68dJq+thBSo2QfkxyJIv8goIYzVqoC3qAhNlugMEaB+wHDT1fPI1KBfoMPXogMfW0uiPbobO+8BjLFkmcIEgpXdA/iwU9FHHVD6uRc/QIAPU/k4lVBDmi71R2bV39Kzg2naO/DJR1T8JI5R1wFM5PyJSM+xoiEjeU955WiFvgNj1s3GE4z5tdMWzlz5z+hdniATc/1XBxhoFmvA7xXD8ui6T1rUdsyiutIa8CV3OFrJnib25rlaBQfORSntMYNPb+KWEpr1w4Pj+t1YUUVc+vpBGbfTyrdabQWrfCOPmdtRgrtwaORfXkAc4xkM+3yCyiNe6srhisu+AXtB8H1CcqEk45a5fyxfa0c8R5rhzYtabWPxn6kdj9whrunzN5/cHwQaPiaXd0s/5fGh1xXWtSY0OOAV3IGVmt+Zrq2i2dC09XaTbCMVvsTv/xdk9W59V6mOi6yI0kosEGpljgESlJ7cjq7YwZkMUrC3/VBS8VUOx9i6dWflF//OQ3nJCaDNy/ErCL/P2ncErsxYN/SZ+Wz06QB7/V7IxcDkcTVSb+4/wWhY9JU2chlCTUhMPxq4ag6QpaMPq6mqli1DSWNyowOkb06BnBVLGkGR/OAG+OUXXep90ULOvKQ8U34KbTuF5rrvF/qOleY6IL3yOgqFWotO7HpJNbxQl/adw8YBAlP1k7FDo709lu3k255XjofRVHs0wuBGANA5l4i+pLWnG35fFF5Qdj+3UCsGSnF4a4bP4FLM/DDrzmdNczLZUzv5djbrUmhCKz72rALViSUSUnCMkmns1ujPqaRG38I5P4HPwe8QkFoQEPaMsON4SbSfI5eWvDK1lcbduweu3BeGdqdk0JlfxM2LjvOoWKZTBHEAhzExfbNIc2osE32Eik
 oM5gi+/4
 1bIW7TP1YC9U2k0mpD2sp66PODEtHh54g8OTMSKliSXxHKYEi1OXkzdyDEZpkgBKWmd3sbocYl1WeHqS4tt5F+Q/A0+Fp6tziH0Xz/PKv+JgP8wNBwppNiu8m10/FB6bj3mf1MSHVOWjPxQCR0FwRTzCjsqE276mtLc0i//GVcZrYnShk8Kqi2pLOVuXfamlGY5jnMREoXug9oApF54AFKtpcBD3w52mKnflzItQzviDvZlRpDk/te90mLequSVih71dOWTp3tz2XgJrUG880gTI6vLlTfCG8BsBC8oFW+r+SJrEYKaSvSMnh+J57MjT/rZXZrcGEb9LGbZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> On Tue, Feb 24, 2026 at 9:27=E2=80=AFAM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> Tamir Duberstein <tamird@gmail.com> writes:
>>
>> > On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg@ke=
rnel.org> wrote:
>> >>
>> >> Add `XArrayState` as internal state for XArray iteration and entry
>> >> operations. This struct wraps the C `xa_state` structure and holds a
>> >> reference to a `Guard` to ensure exclusive access to the XArray for t=
he
>> >> lifetime of the state object.
>> >>
>> >> The `XAS_RESTART` constant is also exposed through the bindings helper
>> >> to properly initialize the `xa_node` field.
>> >>
>> >> The struct and its constructor are marked with `#[expect(dead_code)]`=
 as
>> >> there are no users yet. We will remove this annotation in a later pat=
ch.
>> >>
>> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> >> ---
>> >>  rust/bindings/bindings_helper.h |  1 +
>> >>  rust/kernel/xarray.rs           | 41 +++++++++++++++++++++++++++++++=
+++++++++-
>> >>  2 files changed, 41 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings=
_helper.h
>> >> index a067038b4b422..58605c32e8102 100644
>> >> --- a/rust/bindings/bindings_helper.h
>> >> +++ b/rust/bindings/bindings_helper.h
>> >> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D =
XA_PRESENT;
>> >>
>> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
>> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
>> >> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTART;
>> >
>> > Please add a comment to explain the cast.
>>
>> How is this:
>>
>> // `XAS_RESTART` is defined with type `struct xa_node *`. `bindgen`
>> // cannot generate pointer typed constants, so we cast to `size_t`.
>
> Can we include a citation or explain why bindgen can't generate
> pointer typed constants?

If you have one, I can add it. I don't know why this is the case. My
guess is that it's just not implemented yet.

Best regards,
Andreas Hindborg



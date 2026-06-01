Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3A0CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CDF6B032F; Mon,  1 Jun 2026 07:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE5F6B0331; Mon,  1 Jun 2026 07:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A216B0332; Mon,  1 Jun 2026 07:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1096B032F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:16:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3B891A05DC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:16:58 +0000 (UTC)
X-FDA: 84831091716.28.0D9BA7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FF78C0011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:16:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8uki+OG;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRHoP5VdkIAyG5qDOl9IysDCvNb5MiyLvpUd9S+gzQM=;
	b=gAnQBWQbyjWJZEPI/dgmXCh+g4NzrtRvAoZU6PMxh/nr7JVp7TSMkcWDvUZaz1qT7eBoby
	GFNopNgPL4KlVoRZw9elc9aK/HFOdchJ//joLsJW7satlPkJ4pLMDu8RIcjtFFQDbZSBBx
	LK02RLVP+rCIIW+5h1bdzEoTFIrs1LI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8uki+OG;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312617; a=rsa-sha256;
	cv=none;
	b=fboEq0CJ37ZYqMRLsNi+oV39VsbEkoY6TtKGHvubiRF0SSAt/MzzRTvu0/Y6D8GJ4c7xmu
	cNZp4IQX3rL/fujPxfjhBAtACZlkmhpR6xAN3LbZTUO1WCvvPsTNTfo6PE8rp8NvWgvSEH
	lO4j49rP2XYqqQyQ781JyOcXjtOmig8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99AA860098;
	Mon,  1 Jun 2026 11:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86091F00898;
	Mon,  1 Jun 2026 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780312616;
	bh=CRHoP5VdkIAyG5qDOl9IysDCvNb5MiyLvpUd9S+gzQM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=G8uki+OG4nJXKcRZtOFdjfuVaje7IhPsSBlyQxDVK6rQ2U2XfNst+LmO0FDBhPdXO
	 S09iAU4U8VXKGMxtoIGANyksSGGohF++3CaROL4ZLv35QNRbjgTN7rdFwI2udY/yGB
	 MlSzA2LgcqfOXO8ZeuobJNEqbV3AjxWUeDbFUynLg9wmnrD1qtE7iJ+3sCn7vj5gWn
	 k+/0phmTAOUi1PJrkemVvfv1wuJkLg3+nfOLY1HRONfiINTWcn/IB4to5JOUD+BLda
	 6KSEpSUYUbufzVG9aM3tzf6WzRvhetNrL3fEil0hi7jD6r5dRl7YswnbbOgM8JSKFJ
	 X9/wW7jFtnY7g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/79] block: rust: fix generation of bindings to
 `BLK_STS_.*`
In-Reply-To: <CAH5fLgi+K_5So-kLwyZGhaagEx-rRXPmk=zCOTqG3yh=bSe9Ww@mail.gmail.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-4-de9a7af4b469@kernel.org>
 <abfNByL15D4s69Al@google.com>
 <CAH5fLgi+K_5So-kLwyZGhaagEx-rRXPmk=zCOTqG3yh=bSe9Ww@mail.gmail.com>
Date: Mon, 01 Jun 2026 13:16:35 +0200
Message-ID: <875x427bos.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4fs1swcyktqywgmrun7btaezjw33zs6n
X-Rspamd-Queue-Id: 0FF78C0011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780312616-319662
X-HE-Meta: U2FsdGVkX1853U/qimZqaoOBNeXWeZm5oVADytZZ8UHZRoeAMV1NqumnKUq2NbESknpn5o4WfwdltHlY36StR98MgK2e3UHqIz26mQ8dk/1AeNGsG9SVeE4MnMFVdzkGcbWdwMRJHBR4xyMGlSV4uX4eqL8HJN2t2I0KQEGXJn+o6u3YiTZsspAfHrVa2BI2klqRPXcrCeTHOZaERFinFupksVY6Hw9So+4GZ2gk8Weyk3uZiPH9e/dXQChzNsD4KwDY9GK5wL3TzFBcTbxDC1J0/N0tQKxnBwSx1KIJyLY0QFHlqBFXHMIQQeNGSgbnsTx4v02pwRB7lG3m/y15sIClSXuWgfuzaDprxYkXSuHwBEWul9gsRiPnlBRl+vO5rA/CIqPMrWRyYkc1oiJXWN/iIQ98xkkabKdk+n+a/7rRzIrWVtVG0hqK20NeRMvWzxUgh62JIKUaqeMB8paWdTPydsoayE0K6B/yph0YKbKJzLElSJeffCwVAjDfedeiM26hWtqpeRYTZzFgEqO0Vk+Oo9E91B91rYQwiknz+kdNMJmkAvqZA71aqZkv9bR7364hfWHCEyHIgBluvYPIYTzLp9Le367Waht5Z0RbzAoVN00YWKrURL2plEfV5zvs6EGqwGVlMO6XlVCcllPwYqf8D+eclx9IpwnoBfafB3AQCKcZjCEUtFH8Cu7iABW8Vf5AqR3O/mx/g56JfZgQxhqBUqK1z93z6hcaP1p9eEmiPDM+1LhfcVjtMT1wiXVTRYPkZgpA3CK4nTFlTggZY62wbK+nJMutHDc6D+UsCZA3SLAHPlIBHsGGUDkghzxhYmvAe8/20joAGSzgGg8Wviyw+oIXVPY88PqA14lZv/u1j5HNnk/7FD4wwwAaXFYPqy1Hom/I2++VOrd5cSkv+bSBTa7nqESKZ8ry/vHRyMCvXeDaSupiKLKb8ZlkEHpqteQQrIaXOvi8CKAwh8P
 lC2+/SmR
 9BojFDIhJDmMznPWyimk8bf3qXrXeuyzYW7P7Ea9dLuC4JqWcuwU3sISV1F5Sqmsk0QOv6U+jWBmh7jrG2K8y5xfWpCu6vZMMd9VL5TQgNAXq7QoFQrQQfCUR4puOqRwSQQI1lV8GZMOH50cjy9DXZT3NrTRP7kw8wPvV1veUIaKkrL1YC++PY3+AcSLjmhWrQ3ZkSlaYJqPdJ/sLgINGX1exDi7LPGgfDSc2sWNpibmcKSQ8GcYppRXf1IYE4T2O4+9JomFQ8UUL+jeY2XvZ9IRcANBEXg8ikr0KWIQu6JEX1p1n7E64AQLrZs3RT4Zc8Mttj7OX7mnM7F40xh9Ky3H7cmblBQeu8y6iTzkvHCIPWY6bik9vYOh+EMA/GgUAyrEmKsCJvrXRQAB5evNtzSIwCiJEp7KeoyaO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Mar 16, 2026 at 10:27=E2=80=AFAM Alice Ryhl <aliceryhl@google.com=
> wrote:
>>
>> On Mon, Feb 16, 2026 at 12:34:51AM +0100, Andreas Hindborg wrote:
>> > Bindgen generates constants for CPP integer literals as u32. The
>> > `blk_status_t` type is defined as `u8` but the variants of the type are
>> > defined as integer literals via CPP macros. Thus the defined variants =
of
>> > the type are not of the same type as the type itself.
>> >
>> > Prevent bindgen from emitting generated bindings for the `BLK_STS_.*`
>> > defines and instead define constants manually in `bindings_helper.h`
>> >
>> > Also remove casts that are no longer necessary.
>> >
>> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>
>> It'd be ideal to change the C header to use an enum, but that may not
>> work as I'm not sure you can specify the integer width you want for an
>> enum.
>>
>> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
> Honestly, it might be better just to declare a Rust module somewhere
> with each constant redeclared:
>
> const BLK_STS_FOO: blk_status_t =3D bindings::BLK_STS_FOO as blk_status_t;

As it turns out, `bindgen` only emits a binding for `BLK_STS_OK`. It
cannot parse the rest, because they are declared as `((__force
blk_status_t)<N>)`. So in order to avoid special casing the `BLK_STS_OK`
constant, I think we should just keep the patch as is. I don't think we
will gain much from re-declaring all these in a local module.

I will update the comment on the `blocklist-item`:

+# Bindgen cannot extract values from the `((__force blk_status_t)N)`
+# CPP-macro form used by most of these and emits the few it can extract
+# as `u32`. Block them entirely; the `RUST_CONST_HELPER_BLK_STS_*`
+# definitions in `bindings_helper.h` expose them as `blk_status_t`.


Best regards,
Andreas Hindborg




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09CC1C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B98B6B008A; Thu, 27 Aug 2026 05:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0919F6B008C; Thu, 27 Aug 2026 05:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA046B00B4; Thu, 27 Aug 2026 05:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6AD6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:48:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5161E1403A3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:48:40 +0000 (UTC)
X-FDA: 85146574800.24.9FDD9BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF9A840009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:48:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+FsKYtf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nok1TFu4g+w3tBHe+ny2+kk60gpMbaISESgPnxbz4EQ=;
	b=m1aPus8X4TzjHfkMDXgQKrCfkLbqrWcGhv3caP8cmAChmeWjBoUTZ6AdPFAigu0B7HNyca
	n8ot9z12CiBWO1sbeC9XRlYzlRTjlD4NCcfxW7xWFzarBcBYpWwd8xvB/tq08dgalYhnnR
	tO0QtwcPbzKPuiUgeekHBnC81hU2Wis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824118;
	b=4NsgrlA1lIaP8YOspvJGY42B2MVJ4hEi6mOq0qZqPjSopMKypdDTXcHDrX7Wbz4x/JTELw
	CHJ3mnxs0J0OhvJrD0t+WEj51I18J+eeiaUwqAJPY11fd6x/XIa6bmC3+2Lm/lu/a5bgSL
	xZr/Wj2W8E2v/O/DOCPDMpQqIRv+GQI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+FsKYtf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C4EA600DB;
	Thu, 27 Aug 2026 09:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E11F000E9;
	Thu, 27 Aug 2026 09:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787824118;
	bh=nok1TFu4g+w3tBHe+ny2+kk60gpMbaISESgPnxbz4EQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=C+FsKYtfWGQh6HjlOLXX1WiSa6SZ5jW7ybtMWLlgLblbAQI+OIQY7C7KGjGcyj1mq
	 eSrbidPdmQGLlSSpiBTzapjkU7JaMMsMerlyM2B2XP/Qd4Dsm+Aoe02v5rslSjrKQy
	 dDbnQ1QNNRyvmX+UlmZHUreo7wK+oiUuZr74sMd7x2xldKZa+iRVWv32DuBPor4Z3v
	 HfwjSp2etPvE1ksE2Sw55jj8OHR8ChVF4YpzHo4ilJg9JkYZu16OPEZVo6N2dhNCJZ
	 9+YAJWiqqp2l6NZRVSI9htRrYZUM8neD6txMjI526UzxSeEpc1e1T2zTQtLVRw0WJB
	 r8Q8HUY33NqKw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 03/11] rust: xarray: add `XArrayState`
In-Reply-To: <66630DA9-0546-4211-BF30-C99123B76E5B@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
 <66630DA9-0546-4211-BF30-C99123B76E5B@collabora.com>
Date: Thu, 27 Aug 2026 11:48:27 +0200
Message-ID: <87pkz328t0.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF9A840009
X-Stat-Signature: jfqt351ajgkzbuqhta8w85cn64k14ujd
X-Rspam-User: 
X-HE-Tag: 1787824118-857546
X-HE-Meta: U2FsdGVkX19tfLAR0aYcRLMaeTVJEN2MjQVsCzBpZ2tVAObJnqtfZacaU4Rv3vT+hV+75lNANlR8+MRbVzZr0aRYyL4J33yCOvwKD2uPpjy4sOPRScA3uE7llp+T6tgluOEo/DJouP+kgn7lQvAR9+AIyNx6dSwlQLFW2uqFDmruJd4pQYvP6sS/jm80KkD2jeBje4gl4WT9K9z0drB/4UHfo0WmqRI6qnkvLFXEgzSmIOmvu8eiSya1iuZZ5nZXeh5H4k36dQShR0wHXtKYLvd6JfZLqzcUpBlQYSFkusBIirLCw4Wap1S/8wWRAVdO3cF/TpoX/y3ckH7vADRWlassSPo793CkEuZ2tU3atCTiAUfAPSGrBX7z86MxOwCnaRHJXG/BWUAioSKOVsLWlfMgaptGp5joAlm/VEeaF4RaiFZS02fxoZVUOnNyp842/IRpgmT4bLjyzr8+tK0ngBuYTLpJrZeHQCymdAT+1QtzTy8bXW1ijxfwUWgoTCZNiaVu+lNjC56iBi3buQsgfTc+Emfariokd/n7m6Y8KXhY1KIR3pu+CP0XdKFfU19+vEfBrgBpLEkNhPaaGCu8zxELDum8qDX3kZqYeOUWqrG1xqzlDkTu0kjpjthzW7zc2KGMu88j5kUEhiJwT+Hz3XolNansPewpLtED+ODrEpDyc2DKzqeY/3iSG/PAMNdGLyDdOhWJrwltwvMJmFHip4t7DmTA7YHQjX7/X7Tbt2wt29zUeJYB3OY2iRbXndmLJQh5PAmwSRruQYz8FAUKNPWsU8EEeKdJneD0fjoODEWwghbewdKI0VMNZpNPvEs91QqO7S/VvJhfgZ/xPMosvCeBYSlzuQYwAfQAo4D4xn8n+vSxO4LN9/Va9kvv4MribgWytgByfZ/7hhedJTaO8vP09nm76EmAfsdZ1vWys+/9UAwdl8H3ymDJtuG3zLM0F3RE7p4gFELyYVjpZjv
 uWirg7Pn
 In736MlUESZPbYEZmlIRtRHsx0v7v/d9hxEDOJyMCUzHdLLlvr3egGCA0pSEZxl7qE0+ZGnd2x7kpich4kxO0AFiS964+R9JejS4N5ma3hf8ZPVBpPWDS1SeRO5iLs+sMQP8Sp3MCq8JC3OYaeZeQZABeLSMjXTmP4W42MnBCpXF5kTHoZiH4xMO5KfJ07SexqitDRgMJ1dZkdyCddkE5rWX2mN/1f8EMNAJQ1WkTwRxeubwSe20aOA/nPogSlsDK0XyQQHKpP3ajfUzHkiYkQrGmHbu+NJgKNqC5N1or00NWTOOBmz82TdkP9FpKbNdwjQ0L81urFoT5pqT/GECkracUvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Almeida <daniel.almeida@collabora.com> writes:

> Hi Andreas,
>
> My main worry here is cursor invalidation, i.e.: what happens if someone
> mutates the tree while we have live instances of XArrayState handed out via
> patch 7? For example, what if someone writes "self.state.guard.remove(...)"
> inside the kernel crate itself while some user code has an OccupiedEntry?

The type system handles this. Obtaining `Entry` requires a mutable
reference whose lifetime is extended to the `Entry`. So while entry is
alive, it is not possible to construct `XArrayState`.

For the operations directly on `Guard` that require shared ownership,
multiple `XArrayState` instances may exist at the same time. But as
these are only used for reads and can never modify the tree,
invalidation can not occur.

>
> I think this could be solved by hiding XArrayState in its own module and
> exposing only a small set of checked helpers while its fields remain private so
> that we carefully vet against the situation above.

I did not consider safe code within the xarray module modifying the
fields of the state object. Do we really need to handle that?

> Additionally we have to ensure that, in order to get the guard, one must
> destroy the XArrayState, for the same reason. This is currently the case with
> into_guard() IIUC, but I think it's worth to spell it out in the
> invariant section.

Since users outside of the module cannot construct `Guard` safely, I
don't think this is an issue?

But, something is not right. I did not consider the safety of
`XArrayState::new`, because it is a private method. But it should be
unsafe as it is, because it allows insert operations with only a shared
reference to the guard.

I think if I just gate he modifying operations (only
`XArrayState::insert` for now) on `R` being a mutable reference to the
guard, we should be fine?


Best regards,
Andreas Hindborg




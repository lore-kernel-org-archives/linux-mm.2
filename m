Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4E2F357AC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF06C6B0092; Tue, 24 Feb 2026 09:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0C86B0093; Tue, 24 Feb 2026 09:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3F66B0095; Tue, 24 Feb 2026 09:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFA956B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:27:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 708D9160182
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:27:12 +0000 (UTC)
X-FDA: 84479577504.28.1F0C8FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DD32940003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:27:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CcKZczLD;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771943230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByXln8vR9Cgnh3q1qwZuqgwtUgt1pMUyvMPwJCFZeGY=;
	b=IP9HZlPhjOjIa93lhf3M0VO6vc/SvZl6v7WkhZqF3/2T9726bQMTjQcywn9ZBKSSnA0w9G
	C3+4y57/yLYX+cA2neMmPeZjSp+8jBCGL0iSAXztTolUKNZ0gEuZf5HoCCFy0goTBuQEyT
	pK+Q9Er9d55xjALGbKBNTv1uVyH1BG0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CcKZczLD;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771943230; a=rsa-sha256;
	cv=none;
	b=ECCWyejGoM0SfIrDPkdt4fQKYCja9jiPJ5RyUpvA08FUgID7EJswvMfPPssYAqBkPLBj7Z
	1SOf6b+EOv3R++L87jPyG+ZTtEwJfITx/FdJALXhcu2HSApjmsvEDECr/NevgapYebTjh/
	DQ3cunfsg2xu9pgEVEJV0ebwWu3C0gc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2396E6132D;
	Tue, 24 Feb 2026 14:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E61CC116D0;
	Tue, 24 Feb 2026 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771943229;
	bh=uafOB0Tp7QVjAwnRblJUmMVdq5doGs3C2G3o+M2e8F0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CcKZczLDoduGlH3ZRkDfEPtT31kBJlUYdWrl2UpzW37JXgV1CcAMtHJcuEDy3qMXv
	 ALjj6/ZPPD8QCHNs6kb6PqkAL5I6rmrDYKT1jJuOrs4x89+dsk48g1QB3tTI1yvVFz
	 ckO4uIg6WpwTM4S/mps0chHqVO7faGID79bVCSIL6P0RpAxIZhzp/bZk5jApG3GWtL
	 kxb6ItxYgdt2d6U10qMCMNj5YKuhQXZDzm5BCWGiAWUHKmUfbu42hFv5MZkjEVpuN5
	 MQ8iOH1FRI2aOzPzCvJD37n4Drwy8nAaQltLliAsCWsxy2jCdoruSsdWXD0dZXVfKb
	 Mu8zWkPICfmcg==
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
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
In-Reply-To: <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
 <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
Date: Tue, 24 Feb 2026 15:26:58 +0100
Message-ID: <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD32940003
X-Stat-Signature: mactpiaqbktjg6iyb1esf8erkkhp3fn1
X-HE-Tag: 1771943230-287361
X-HE-Meta: U2FsdGVkX1/2+z2oDRbQcJoFjpnm+zl0Ed9akeYxD8U3JuYY85RFXI84w2pfo369LaV8s3D2Octk3/jgqKwibGoq7XBb8ncXyEcSUdkHyMMN0pWz+5JZWXlgpqPQm1hgFCO4RbzHxH/PaVAqjIGOFKi/M/WBppK+0fTPNkNWYb71OcrTdAYWFnYc+GutaOEj3+fEoK6e1dhYODwjwOHhhxlk6Ix946+lK6V8rv0XCKO3dQRu8KQe2LNgtjRtOIBwWp+RlRwFwzuVaaSacpKRRPXkkguGjSI3pok7F3DJlTjXob2JDI6HUYHOrfpXltBNDB39AyA/0xkWc4d6yHLs/T3R6tx9pgjjlLZ63KXZrOeE2yd4jbgk2SvaisTxGQnN1KHGqd30weaMuv+k/anMT0UrhMnFtgVjZeSMalwVPdKTHNnyRQeAv8co0ZP0kQjugR1flyjDL9vK1jgiKh+hsG/aSp55G6Oj0s5uGj+iWoF2jn56XIacVvooB0ge/+xfKzyJih+qHYAz6y4ZwZrJYq7cfTIkj9XvciCJ1jOIK7vIZvLYjBa959A/0xqctbulp7TMiZ48bRvnCk8PANUUayq6zVm3UvaQUr7fZ8QasznyI1FlZn4zSDWkdXDcEqEeVhM3Tlfs/hRZauKVVudNjp8l7MCMhEpbFw7MH6eJQqEPpJ3VxTHLklR1nQSUXqWxYY/fjF89SzRhPdo61GMwpyxgqfsSNPUtntS5OWNWJlfd6N1ZBYqKus4WrUnvc5Q7pmyKjvMjzlS7HE5meIxPA2rD//cFUIxfrnt2ZybCLqj0cXfeOrHPxyNgrvy3wRYbM/IHQSiD4Vx2B5fkCkakMOX7yXqUXsMf0SRkBmT3ENAmE7jYEgFNYklIYJ6ICMYZ8ktJAoeh+aC/sEJXE+EmqgmIRL0abLe/yxTf6T43ixQiFJgUz3poIwe7RJ2D95Ibqj7sfcvZjXtP1AFxKJE
 OJBGQBIY
 +ulrzU3O6y0tOmAmOO1hlUSbyp0J2sIGye7zOqzqVY5r+y/TaUYZ7lX78IudZqywbpAgacemdBBaik1wc5Zejt7Qh4yJrJ/c+n5hN5mhIgbPAgAdIKjGYi7XRn5B1YUyBsbF0O7BnqlciWEu/F8aYaqOg7CI0Qmd/GvA+TrPRWejaDQ9a0lpMJkfnedRfwDdp4eNYpSsI6pzuM4eY/MFJPFTnkkhVzSi8zO5DWIV3xUsdS3OHxsqDJYdj7Is5ZeLspJ4BXaRZ5DqliDPV3zUsyWUyynjycQUdk0+HBKjcqZTl98O1n7kKfjsQ35xDL0dA7d9jJ5eMNmAVytc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@gmail.com> writes:

> On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>>
>> Add `XArrayState` as internal state for XArray iteration and entry
>> operations. This struct wraps the C `xa_state` structure and holds a
>> reference to a `Guard` to ensure exclusive access to the XArray for the
>> lifetime of the state object.
>>
>> The `XAS_RESTART` constant is also exposed through the bindings helper
>> to properly initialize the `xa_node` field.
>>
>> The struct and its constructor are marked with `#[expect(dead_code)]` as
>> there are no users yet. We will remove this annotation in a later patch.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/bindings/bindings_helper.h |  1 +
>>  rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++++++++=
++++++-
>>  2 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_he=
lper.h
>> index a067038b4b422..58605c32e8102 100644
>> --- a/rust/bindings/bindings_helper.h
>> +++ b/rust/bindings/bindings_helper.h
>> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D XA_=
PRESENT;
>>
>>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
>>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
>> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTART;
>
> Please add a comment to explain the cast.

How is this:

// `XAS_RESTART` is defined with type `struct xa_node *`. `bindgen`
// cannot generate pointer typed constants, so we cast to `size_t`.


Best regards,
Andreas Hindborg




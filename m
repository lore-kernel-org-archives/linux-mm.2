Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50C0606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ip9du/PW
Received: by kanga.kvack.org (Postfix)
	id F3ABF6B05B1; Tue, 10 Nov 2026 05:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB116B05B2; Tue, 10 Nov 2026 05:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2EB6B05B3; Tue, 10 Nov 2026 05:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A718B6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:38:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42F09A04D4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:04 +0000 (UTC)
X-FDA: 85418859288.21.D9A45D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B6DF80005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ip9du/PW";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794307082;
	b=4RxCnsKR/AvuatA07lYrlnhLJLLVvGbi0Efcr0+q5gkP4r4N9FO07Ka+3p9Vl2tWqvLoBa
	w+ow4GGKJqzuZlbxfL+g8EvHqOT74xVtAdQkXwY6fvZnAXq2oKjw8RAMuLVKzAy3DkW7xx
	0+fAuKiOx4/J2oCX0l0rQR3Yxuwi2ik=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ip9du/PW";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794307082;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2Gq9BK7mt4RyAB9fOrbZzlCxy1UiGy5QVH65hM3wgw=;
	b=7b/dvDCP00SGKWKTmD/AlNIxJQZJA/OeTYtU3fvztYP7/eqtln1dbSa4MpdUrU+3QG4ktT
	861PMYQAl25JNeSPxhElxZoE71jwOsHiHnzDQHw07POGdqWhFms5iocvjVmtK32bipqYhz
	sbosvtFuvvOjWjgMoYeY6wAkTm8chh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFA5241AAC;
	Tue, 10 Nov 2026 10:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE76D1F008A3;
	Tue, 10 Nov 2026 10:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794307081;
	bh=W2Gq9BK7mt4RyAB9fOrbZzlCxy1UiGy5QVH65hM3wgw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ip9du/PW/M5YU+G5ulWsLh05WENw6Xmg9uq3aAfz0Ph/u0/wwb4EdhDadRsB1GBKi
	 8wc+5+d3S4qMfi35OxnDTQVdU7vQI/zeYlUwr78dKZEWyS8ivG/RHirC3RLw4wsYId
	 h1GCbVG0i2v9GLzrbo/i48i0MVyMU68M0WhCaS4r4yE/300KQ0xJp7f6a3rbX0xtGa
	 ctpr2xXemG9I9pZki0S10f98rfn3xFERH3kRP5OBn64lHaoDfVhY46B92C16cpHDtx
	 rRKBF0ibJCBIuEoLkNN4NltUdw9EEeV3jaiLLTnDj4MbCeDs/lGHVuvVpjFLFurszo
	 YBkxncx9zFz3A==
Message-ID: <sashiko-outbox-206880@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] rust: alloc: add per-task memalloc scope
 abstractions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>, =?utf-8?b?Qmo=?=
 =?utf-8?b?w7ZybiBSb3kgQmFyb24=?= <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>
Cc: linux-mm@kvack.org
In-Reply-To: <20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org>
References: <20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 10:38:00 +0000
X-Stat-Signature: p1ekozwafj3pcx47ryedt8q49hp9rng3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B6DF80005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794307082-904748
X-HE-Meta: U2FsdGVkX18nk/ULjuIaGiNelDRiFDkh5Kbf7nYHl5fudJnXFdKg+87f2x/W3uuW+vPtCLhxgEHUIXZP6HSsFZz+vX+GQtWbwlWCIRej/3j/aSlUqAzW4sQvwWHOBHoeUTppL5ySOtuI7nY5Z2NDyDmgdfntRZv2zye6hkEM0gh6wpXNM2IpJ+sqgRWh3SBKcWdiu2V3breOKsRW7KiFN5KrGqgR133hZvpiyN7X1we/Rqs9u953u1SV/4P0vloyYeG0Oo39tLMrgM5somYTwDDMSIx1qnNyyb1KcJCN9QZiRXeGU+zCVxbiQypkcP0jT5v3TSACQAh2fAtNDC5KOKiR0dNWOB3wgPj7Xv6irdeCKnMsEnKWTs0Fa79VYWeTIiRs1jdb0T6SW4rvqkA9ePuN8JVcTy4y6Xp5wrfk8LIMSpAhcrrzZipB74fdKEzxpfbRw4oK8INQW/W4NsvZKBJCr9pCmQITLJel7y19yYScSgaC/9d96Xl6zz2I7eoKndG9/2OSnipwhnGdtk+N+5b5/Updy0gHteqVlOfOhfjxgXKVkuA0ij9WfCATwwfWGd9K0hdsJUS65Ku/04gTaWfTEnWKYb8UFbzvff1SkwT9WJzq+YuGmguELFokIzZ3346ow/aD7U3A7/MG9gwsLCd/kw5JPEDkjTFG3O6IEjKmiBa3Z38p+pfGiSGJUDyZK4K5Dew+SIMZExRH96uAVTM1xbyY1UZFENGqh9Pez1LmUEkPRChL8V+XaGmTBTYr9EvisPq5+V0mjtd289ZzMuTv9kWG8c+8zhJgzljw0PUZZpy+Iadc5bMNHcLzSQF++3ATgOw31S11AxRdlVVGalmwwE/2cx/i/Fna/oDihZ3b6GqKLmOLZs4mNCgwW1dy+xdKIg8CojN6Bgf+iXhlFBh1g9tS2l3w6d/pgLpwVbi/GYkqjfHmx055Rz4JHFOSP44uIJupabe/CQTAvBE
 GWOIM4Yg
 yEhPubg866u1rgxMiH27SPWuwoKPCAlZXlACpCaLc00EUkfENuLYulWW3vJ7N/9h13v+/etdOF54EKOCMhQkOaRmKryctfmN1yy8PX6XMSrwj8QgxdkC8waAWRnVRB5i04iupS1Q21dWHXRaINohW5oeXtEoqlqd32NU8v1hMnTOO7Pf2pw2SXEqUn8I297h2VzbW0SqxA/P4bKnXiFEfHV05vTRIHQUPOyAP5p1TAEOyMio+hqMz37qLMdmIwhFYZ9BAh7okh8zUJQtO6r9y7nmy1ZmcYkVm0weFey95q3aLa1mwz9tofUcfboucH48pafwaoDEd+4EtwrZcYjW+LzHz5IfdtixLIM9tYxZnj+YkZXxzsvRY5EWDxUtG7BI3it3fW3Mqy4iSv9qttqwS7jiKZyVeHdzNuqkCnN8YfU69KW/y4yU3MzsFP2sF1HDkdxy9ezQDe1XMuMwKUfkBTyfPtGSaj5YveLJaDwvi6Ex6cMyp7FwoV2sVJ9O/S4ZairXE4Jzpd8w4Xb3AtqtLewD8+USuEO0rdFHbvlnn210rFieUCwpTVhpaJRiG8QgZYhaVUQJ+gIyaItZf4ecwfcPN+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] rust: alloc: safe ScopeKind::save() allows violating
  restore() safety
- [Low] rust: alloc: missing #[inline] on ScopeKind::with() and C
  forwarders
--

commit 41cec7ee242c1aa90cf2533b8574e3fdf2331dac
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: alloc: add per-task memalloc scope abstractions

This commit adds a ScopeKind trait and the tag types NoIo, NoFs, NoReclaim,
and MemallocPin to expose the per-task memalloc_*_save() and
memalloc_*_restore() helpers in Rust through a closure-based ScopeKind::wit=
h()
method.

> diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
> new file mode 100644
> index 0000000000000..6745c06d6725c
> --- /dev/null
> +++ b/rust/kernel/alloc/scoped.rs

[ ... ]

> +pub trait ScopeKind {
> +    /// Begin a scope on the current task and return the flags added to =
`current->flags`.
> +    ///
> +    /// Every call must be paired with a [`restore`] call on the same ta=
sk, in LIFO order with
> +    /// respect to other scopes. Prefer [`with`], which arranges this au=
tomatically.
> +    ///
> +    /// [`restore`]: ScopeKind::restore
> +    /// [`with`]: ScopeKind::with
> +    fn save() -> c_uint;
> +
> +    /// End a scope on the current task.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `prev` must be the value returned by the matching [`save`] call,=
 the call must execute on
> +    /// the same task that ran [`save`], and no scope begun after the ma=
tching [`save`] may still be
> +    /// active.
> +    ///
> +    /// [`save`]: ScopeKind::save
> +    unsafe fn restore(prev: c_uint);
> +
> +    /// Run `f` with this policy applied.
> +    ///
> +    /// The current policy is saved before `f` runs and restored when `f=
` returns.
> +    fn with<R>(f: impl FnOnce() -> R) -> R {
> +        let prev =3D Self::save();
> +        let ret =3D f();
> +        // SAFETY: `prev` was produced by the `save` above on this task.=
 `f` is a synchronous
> +        // closure, so it has already returned and any scope it began ha=
s already been restored.
> +        unsafe { Self::restore(prev) };
> +        ret
> +    }
> +}

[Severity: Medium]
Should ScopeKind::save() be marked unsafe or moved to a private sealed
supertrait?

Because ScopeKind::save() is a safe public method, safe code can call
NoIo::save(), NoFs::save(), NoReclaim::save(), or MemallocPin::save() witho=
ut
a matching restore(), permanently leaving PF_MEMALLOC_NOIO, PF_MEMALLOC_NOF=
S,
PF_MEMALLOC, or PF_MEMALLOC_PIN set in current->flags. Safe code inside the
closure passed to ScopeKind::with() can also call save() and return without
restoring it, violating the safety precondition on ScopeKind::restore() that
no scope begun after the matching save() is still active.

[ ... ]

> +pub enum NoIo {}
> +
> +impl ScopeKind for NoIo {
> +    fn save() -> c_uint {
> +        // SAFETY: Updates a per-task flag and is documented as safe fro=
m any context.
> +        unsafe { bindings::memalloc_noio_save() }
> +    }
> +
> +    unsafe fn restore(prev: c_uint) {
> +        // SAFETY: Per the trait contract, `prev` is the value returned =
by the matching `save`, on
> +        // the same task.
> +        unsafe { bindings::memalloc_noio_restore(prev) };
> +    }
> +}

[Severity: Low]
This isn't a bug, but ScopeKind::with() and the save() and restore()
implementations for NoIo, NoFs, NoReclaim, and MemallocPin are small kernel
crate helpers and direct C binding forwarders that are missing #[inline]
attributes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-gfp-noio-v=
3-1-a573e7be9c44@kernel.org?part=3D1


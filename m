Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6BDE9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AA16B0088; Tue, 24 Feb 2026 08:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918D36B0089; Tue, 24 Feb 2026 08:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F916B008A; Tue, 24 Feb 2026 08:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3946B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:43:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D0FD1A0128
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:43:58 +0000 (UTC)
X-FDA: 84479468556.10.1730F0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8728580011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:43:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5abUyVu;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771940636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIwZbWDQIuP6v7yy+7hParJ/5dFiqLCUMBjdEBG4ZJ0=;
	b=jA1nirM6VpfyeXFcAom5kao6EyP7Z7K1Cmr0Eu0mnHF3i3Fex/iI7X9uesZFVrHlol4toa
	IkKcAlfvzZlQmvYGi/7mAVo5ysf6ve1oBgog6XWPsInThB8JwHUxnuZv6OSnmgzJnzxCwJ
	jaOe/JCQ+MMKcX50EUDOQwjsR0V5Ljk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5abUyVu;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771940636; a=rsa-sha256;
	cv=none;
	b=U8YmMuSuX4n78juvoXgd8ahpWri5+uzboqlANdv2jzrfPc1/y4ryn4ys7r6feHhKIVI/zS
	57cA1TY1crTTyI7Zcq4ixCvOdMU+RDiitSXkg5J+Ic1cYsa27AoKX0TqjEwFaCVq6hAA1i
	JxDAYiWOiokXfWTRDK+RABPXaJRagVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E615C6111B;
	Tue, 24 Feb 2026 13:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEA2C116D0;
	Tue, 24 Feb 2026 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771940635;
	bh=cf5jR5VnxDpEVpRWGkRobwj32v0PB+NedyrQEUkzTY8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b5abUyVuheZDAu6Ntgt3cKF1vnkvDOnrmp/gIwHIkSLBTcI1OfhuN3xc2RwVsKcZZ
	 ykgGKgHKgWXC4VtH+4hXtiwfbjdmdyHW16aYcbhvD4ZG5xmgUW933XxU6Sl44OznyV
	 J3rBRIlm3BGXeB25hv4VMPj4u6FbsKk1HF7W9C0yWuNmT50iw9LgCfrRp4nQGpnQkp
	 sEpzIKEWLSsukHB+ZmZ9SgYKjEWBwAwH5dhopKXq4oew19UpKnM7rDJD589x+AYK4b
	 jehMZ5sWor44SN3T3In6liByiLbb32F5wd6HgHTDhhLDtCoBd4BrRPZc/62nf+EWZ0
	 82Iwar1/ZthWQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Daniel Gomez <da.gomez@kernel.org>
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
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 02/12] rust: xarray: add debug format for `StoreError`
In-Reply-To: <CAJ-ks9k5=jGFWRsTmHbsvzJF3YTYzbDTQ43-uUNe8gaZfsnc8w@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
 <aYr-gyQN_AaIJkSH@macos>
 <CAJ-ks9k5=jGFWRsTmHbsvzJF3YTYzbDTQ43-uUNe8gaZfsnc8w@mail.gmail.com>
Date: Tue, 24 Feb 2026 14:40:51 +0100
Message-ID: <87v7fm1cpo.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 95werxco3uza7qrbyj4izz8rf7wburao
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8728580011
X-HE-Tag: 1771940636-794093
X-HE-Meta: U2FsdGVkX19NYuRaaMctjmMCek32IwFhmp171zxc7f5saNT0zj3BrHV4+VZBUNSbxYVgFF3u3PSyCKs5AthZxQvsksS3mfi2UJvd+wSuK3dbyrrEOUoHxs6ylbrjHpMdO4d1ITxHn/CUdajRe5cA9vo2PboXXIqM3tUe9ahZWDi/44APgswU2J98UZ4TCH+0Es8rcfa9kuJzeNSKTran9lQJDC9Fa6OYwJtE7YwgzwP0zEhSuhD6FLPRR+8CA8kwGtnxVoOLs9sw3JIYfiJLNRWwKrTwNf6eMbfTfzEmtPKhoPVHEsO7XFX7U7papM3PWzmpf9m8s3iJa3ob5AZXaN6oCAaT2NrEuYTRKOvDgS1jbeZ1Z3MxJf2j6Ct8TJUDb9LQgR457eZUsGt7ripBTMPh0WwR1lT7pqaQlw3XF2zHSHmS117l5soqM2b816yT/4wLgcpH4xbwPOpVkpdqXQqz49svkkAG4/noZttYhcEODtD5kXk9ovO72ALUxq15Ve7teiwyX0g/VyAIUbeU19FCgKf7x9MpDq7bywGpMAltxl44r9lkvi2mVCNETnaLJ5x9U+RZsx9wdKloEfluAQ3MYk0LnvdgIZzKHcASW+MUehOG0nh8blbi3Ii8A83KESz497mHcoZQ0E3069fd0jibwSt5V/u+VoYdDCIhnWXKgCwy5pP+6LRICGE23L1vSXKhSSEt9AWesest0Aw0BNtF5arc+zf6OWrM9SKVZXji2jJ1URt0RisQMCC2D72Gz/ICRI6TeIH4/s4LNVM+uPc94wrolIp9eDY7KFEjgKnngFaOAd8E7w/TtfnG9YfQSDdB8baP+cAhY6sf63I3uKXxRM8X44201FSieu8aTEi863RhkT+ZZrmlMkcKdRV/bYxkxZ9TxxZzwyHgHMuaCMl4zdy5hwEFyV1yrCTZZORfhBYPqcOtMdG0fSQhsLgg2WgEOJTUBwbDEvc1sMo
 3A8gfRT/
 nde4YW8EDB6pBEozuDvtMVTm7srGqz8AYboRmoyPckRV4al2ndoQZSKboq5Q7u0euc666Pnf9z5cRpcp3WT16HC7R2A/a7QYOh5DCc6MNgfx4SdBtlvRtvC/7cVMX8KDQjaUP6aM/8NuGl6DfAQki0IehPfwZOTG5dnqVT73VTz0mAJjjkzp9bMiZUKACfnI47QvRdlLKZnx6/p70uBQvuM2zaSQpLaFTE60Qpvlom7QmQvgIX55W/LJW93SVPipxzpv7R7d7wxBy7Htp8dBDMFmlPSC6kKizn4Uf6u/+WksX3PufSBXE9OGC9TcT9ppPPh3F46vNE1UUuH58jz1hoBZqCBWeuphXVUiPxtwxb1aBUDLS8yoqTk6DwbdEGq68XYWkx0aBqfpuXGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@gmail.com> writes:

> On Tue, Feb 10, 2026 at 8:45=E2=80=AFAM Daniel Gomez <da.gomez@kernel.org=
> wrote:
>>
>> On 2026-02-09 15:38, Andreas Hindborg wrote:
>> > Add a `Debug` implementation for `StoreError<T>` to enable better error
>> > reporting and debugging. The implementation only displays the `error`
>> > field and omits the `value` field, as `T` may not implement `Debug`.
>> >
>> > Reviewed-by: Gary Guo <gary@garyguo.net>
>> > Acked-by: Tamir Duberstein <tamird@gmail.com>
>> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> > ---
>> >  rust/kernel/xarray.rs | 8 ++++++++
>> >  1 file changed, 8 insertions(+)
>> >
>> > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> > index 88625c9abf4ef..d9762c6bef19c 100644
>> > --- a/rust/kernel/xarray.rs
>> > +++ b/rust/kernel/xarray.rs
>> > @@ -193,6 +193,14 @@ pub struct StoreError<T> {
>> >      pub value: T,
>> >  }
>> >
>> > +impl<T> core::fmt::Debug for StoreError<T> {
>> > +    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Res=
ult {
>> > +        f.debug_struct("StoreError")
>> > +            .field("error", &self.error)
>> > +            .finish()
>> > +    }
>> > +}
>> > +
>>
>> Is there any best practice for when to include use core::fmt::*, so you =
can
>> avoid being verbose here?
>>
>> I see other cases like this, but I couldn't find anything in the code
>> guidelines.

I don't think there is a best practice here. I feel that if we only
invoke a path a few times, we might as well write it out at the use site
rather than clobber the name space of the compilation unit.

>
> It would probably be better to use kernel::fmt::* rather than
> core::fmt so that we can interpose our own trait in the future, if we
> want.

I'll change to `kernel::fmt::*`.

Best regards,
Andreas Hindborg




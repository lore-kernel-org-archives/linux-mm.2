Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D054E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D22F6B0088; Wed, 18 Feb 2026 04:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77FB96B0089; Wed, 18 Feb 2026 04:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6614B6B008A; Wed, 18 Feb 2026 04:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51F486B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:37:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFEE68BB3A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:37:53 +0000 (UTC)
X-FDA: 84457075626.14.EE2FF93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28C1C2000E
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:37:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kPqyI43l;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771407472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ7Z8m395IoLgcg6kkA6jJpUO+vr9RLA7/yczoGzCcQ=;
	b=WSR33AvU2OghmpabBXgKRqwRnjQ05guxeewWrgAP8g6kRP8CI8I03frHrIP1c3dp3CALsh
	Xp5RvUcO6JA8RrlkAJIERCOlMtbR1Es65/3dq+yWvhUDacmw2DzC17a1N9dvgyXLLm94Ha
	NswgjgUrIg5SitDSFIKSkMiyIvEwH0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771407472; a=rsa-sha256;
	cv=none;
	b=WF+ZNn5jexf4TpIvDSuz2lxSMbdWWAHN7yM1sdCsRH/e2eEYq3lySWvccFogRp+u2tbaMe
	1k81Yyi4lPhp1RJydEGrBsOuVgeu7ztDFTKcWqBPXOjhIht5X3KiD0N5su0IiIB5Ac45Lg
	2RTDiVzLmnSQ99BtSuAX42NRqatO9EQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kPqyI43l;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31FFD44319;
	Wed, 18 Feb 2026 09:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4685AC19421;
	Wed, 18 Feb 2026 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771407471;
	bh=5BhDohxi/Dt4pM2Aom0/HfkXZ43SmgfuTX1tvwIrp8w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kPqyI43lDuyH6COoxx8Jlawwo7f3PIUTUm3np3lZ3uUtlPTJNBhXG4I7B4hnl9Gmi
	 /yAWsqGgdzL9yHIh3nDunHON6BIqLbR7ZE9lK8QpEVWFdhNmstlelVuuiYFY3/9rRa
	 oje/E/aYEw8zgoOYUAmP35mpChGING4E2TF6Vuv+1wikJlty9OTYwF+wl8svtE5MuT
	 AMeNE/2CGnP8ycuwSL/ZebbuwtnORNKnH4Rbtk2VgQwCNUwiwie7dOK1N2fB3O36er
	 ADC3JXSKGa5j4wh0BQBf9V3tvqNcz5JZWJ7Hu316Tb2NNtUq540K29U5fGsNth3HD+
	 fEiDWQaE3rN7w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rust: page: add method to copy data between safe pages
In-Reply-To: <CANiq72kZQiu9DbQgkHXDDjHORwUdTm7oOhZOE4Tr8eHiyW7RbQ@mail.gmail.com>
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
 <20260215-page-additions-v1-2-4827790a9bc4@kernel.org>
 <g4ihY-XQwSZ3ysINoU0v3jFzzJG7Uzonq0b6C-EYEYDx4pbJWHHJ1hYmQsmGATIDzexHv6NFea8YNikY6zXq6w==@protonmail.internalid>
 <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com>
 <87ldgteftm.fsf@t14s.mail-host-address-is-not-set>
 <RHTfcS8-6wqboBRd0aNAk2RG-phiMsedyL_E78rwI1FbLtNzmdCAlk5Es1KyQMPV_-KAtJw_-ImmDchI0Mp0Gg==@protonmail.internalid>
 <CANiq72kZQiu9DbQgkHXDDjHORwUdTm7oOhZOE4Tr8eHiyW7RbQ@mail.gmail.com>
Date: Wed, 18 Feb 2026 10:37:43 +0100
Message-ID: <87v7fubdeg.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 28C1C2000E
X-Stat-Signature: q7z1s5cemq86gmma1t9bw8w1wt6intpf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771407471-890701
X-HE-Meta: U2FsdGVkX1/tbsxCGuchOQOUHR9Kxt70JNvZUErIE5P5HMNVYa9RvXfA81LFfzwJxq0u9nccQASlmVuW6UER4WJB+HSlf0c1awys88/gJModGJOBz49ZEA7Cvd/drd/f2JOaf/k1KSb1JeebhEMyNn9+pY1O+t2pVRBbSfDuiPfauXcZ5wz+vfMJ6VvUKDfb+BRwsEzIN7lI3wkQlKJ1c3UrWVm2iZI+7PjIDCbmREMIvjbATSJUv5XkeKfh/iExwZs8O5hWXIMcVLo2eopbBr2huifNQ3AVyiw/CprrQCeQReR7SBybFxxmh1283eddNn9CFVGTK8Nqwfla64OVRzFg5Gggouijsi8DZ/lf4p/TgGKF1X0XnHRpffTSrzKxXHdN3u44tZmf37ymbi8CcMUL/pDoT6gjHVzKYj7R2/5TreLpsm9wpyVGJQw8+LYTTDwcEo4NYRnqEKbAInNQDqQTgfy8so8FMM0Qg6dpzwN/vCxkmAkhbdF5ju4pV89zvlBewSWqIroPahe0l9T/iTZ4c/lrEzeZHbUmV7UjhygPwiiAxLX3WDodJuQs8WJ/41KKKKDFAKeCvxSK0zsDOKkMrO2O5IDYrpo6q1bvMnEdXRHYMjE165i+PtlBiWtzVQYaY78nCViiMWYpkhu7jVwnKYDYowx4772FUBQ6uWzOyreK2DIQd6oxS6EqEDozhy+ObEr2SBH3OvzxyE2N+obNhOaRnlj3UOliLtuDpmsH2AZMoP8HtGR25bZF4DbC0c6fqSFhEhzU9x71yaFIk80gS1Zhv5TvTrB+kPusJTllZlbmfpAPHX1/dabdLHoM2rZV9goPYtSKtLxQ1/w0QBX3yyeGFLvzB9iJw42n8CArHaUTH19PY45yk82HSuCrFuAFjlW3GV8lRcNcVd/y5kORNST5VM97ZKN9zpDOiPsiR5LCdkrREXBm2Yb1liOTzZnifzDOAQkjdt0MG/D
 ImHfB7CN
 9hLMFayhrViPHIqQv4ggbJXHa7JD0xhdkfGJPu+C4lT8PjxoLOKrkxmfoHNXrN0HPYkmzL4oN4bpZiwQPxJtajkCzJcNpWfayiiymRS+RsbOJs8mTNQXmhtyMEJ43pVVlCy6yNPuolED6HBxE2qkjPiO1qmS3ITOYydMMyQnn2nOxiOWreNG2eZzo1i5q4Aj2RYUEYhQJwaA9BJhsCsW9w920aLlWvHvOgDi7LMonzbuyrqy3EgG4Orn+a7qZIze6K06RHSXiU8h4f8qVtjS+sg8bk6If2XXeEVwKdmVNNulYvl1rpu7sfRDYpTFFVz0uArNx7NQm3yZFaWgS+GtNg4Ozrz47zz5vR/JohaqrArKLBm5VRhF+T1C8nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Mon, Feb 16, 2026 at 12:42=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> Why?
>
> If you mean why we don't do it everywhere, then it is because for many
> functions it wouldn't add much value, but it would add substantial
> verbosity, which has a cost for both readers and writers.
>
> Originally, we picked the standard library style, because it seemed
> like a good balance that both had shown good results (especially for
> this language, where we have rich, strong types in signatures which
> help reduce the need) and that would get others to write docs easily.
>
> Sometimes it may be needed, e.g. there are many parameters with
> details to explain that wouldn't read well otherwise, or there are
> primitive integers parameters with constraints on them (instead of a
> newtype that enforces them) and so on.
>
> i.e. why do you think you need it here? When a reader sees the list,
> they will need to pause to read it, thinking there is something
> important/subtle there -- is there?
>
> (I say this as someone that generally likes structured, "exhaustive"
> documentation such as, say, the classic Win32 docs...)

I would rather not get into an argument about things that are subjective,
but if we picked a style, I should for sure follow that.

If we picked a style for documenting argument lists, perhaps we should
add it to Documentation/rust/coding-guidelines.rst?

>
>> Writes require a mutable reference. There cannot be a mutable reference
>> while we have a shared reference.
>
> Ok, but I am trying to map what you wrote with what the callee
> requires. In the second bullet point, you justify there are no races
> for the read side, and the third one for the write side. But you refer
> to the type invariant in the second one, for some reason, and that
> type invariant already promises no data races for `SafePage`, and all
> we have here are `SafePage`s on both sides, no?
>
> So to me it sounds like either you could justify everything just by
> invoking the type invariant (that is why I mentioned circular
> reasoning, because the type invariant doesn't seem justified itself in
> `// INVARIANT:`) or the type invariant is actually a different, weaker
> one (which would explain why you need extra explanations in `//
> SAFETY:` on top of the type invariant).
>
> (By the way, if we use bullet points, then I think we should map each
> to the callee's one, i.e. #2 and #3 would be together since #2 is the
> one in the callee about data races).

Others called out that the type invariant on `SafePage` is mushy. I will
try to tighten that up. I want it to convey the information that the
data of this page follows standard Rust aliasing rules. If you have a
shared reference to a `SafePage`, there can be no writes to the data. If
you have an exclusive reference, you are the only writer, and there are
no other readers.

I disagree that the bullets should be swapped. The second bullet at the
call site:

  // - By type invariant and existence of shared reference, there are no ot=
her writes to
  //   `src` during this call.

Maps to the second bullet in the callee safety requirements:

  /// * Callers must ensure that there are no concurrent writes to the sour=
ce memory region.

The third bullet at the call site:

  // - By exclusive ownership of `dst`, there are no other writes to `dst` =
during this
  //   call.

Maps to the third bullet of the callee safety requirements:


  /// * Callers must ensure that this call does not race with a read or wri=
te to the same page
  ///   that overlaps with this write.

I think it checks out? `self` becomes `src` at the call site.

But now that I look, I think it should say:

  // - By type invariant and existence of shared reference, there are no wr=
ites to
  //   `src` during this call.

That is, the word "other" is misleading. There are no writers, not us -
not others. We are doing a read of `src`.

Best regards,
Andreas Hindborg




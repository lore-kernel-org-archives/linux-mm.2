Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22974E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625A26B0088; Tue, 17 Feb 2026 16:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD1D6B0089; Tue, 17 Feb 2026 16:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF5A6B008A; Tue, 17 Feb 2026 16:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1376B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:35:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA6F7B837C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:35:54 +0000 (UTC)
X-FDA: 84455256228.28.5D873ED
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB5931A000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:35:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=botoeWYD;
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771364152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlTDEr9XEhP0NbtXCAh2y2xp31drr7QfyS/Mc76R+jI=;
	b=6GFcLpBcCz2cSE+pKVKTM/uAkilIyFJPkjN+3zPAPGi8dThwA4kN+GcmA75K7Ky/+p+Su2
	ZXCyZ839kNd+0uoVJXkoOFudnSw3EPk8mDMya5vYFhHxQZtfopCoDlFSq+z3Fkhs8FRlsT
	JaVavhZQOzxl4FNTDPd4uBN3VIvR0vs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771364152; a=rsa-sha256;
	cv=pass;
	b=eERpriY3Xefyq4ChaM+rywMDPJV1rPH8M1DCiN7Ouv3xqa6spJmOWkuytk7mDzDIIFaS4J
	U8K0LtU4/5dE0ejJC4SCCFse4Em/F7pjPKzRg5UTe5rynFwj/h7uMm6VhfwR0NJ2+OKOqQ
	dpgSwxQ7rsCXjrjr0HhYmPgbZdis9Xs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=botoeWYD;
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2ba76e80509so416394eec.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:35:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771364151; cv=none;
        d=google.com; s=arc-20240605;
        b=Bd3DI5hSCpK8CdgBY6Og3KUmJV35bV69a86Z2XNpmcOEiiEH1QxndJ9ZjvuECelSMT
         Y9LtqGte2cTPRONbUd2n2yRl43TPmXAynP0EpxzwGk7bwMa4Z/x476UVeprtXIiUrImN
         aozlX6rc97kyS+EndMGfsObUOpi23ngEpDT9CuxcUjSUPZsatKUWjFLtkxWpE4nTOy3v
         SfhocqnzRY0inSydzjRH8w7cQLorpM5Yhv78I+eK0YZR0MT1Q8PJPthHVW9U/CAp41Di
         +py66GGFzSperzH+4MQ20FRr+KnNwCgVa0nDkbLyAZKZR+yqqGzy6H9ZFTdd7k2wTAAf
         Pl8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AlTDEr9XEhP0NbtXCAh2y2xp31drr7QfyS/Mc76R+jI=;
        fh=BDOgNLOX7COqhcZROp0xOoFmSXd3awUA5uryh9pmCdg=;
        b=IKK/3kxap0H8nLwosoOum9k4ZPAL6AY+cJwADvnG/pQu25MpSDE8KoHdiiy4IpqJ2n
         PXSW+6ryNzEyf8tOeyE8EehVCvSQ8XB4QJhfgUilbUTSiWxWK3AxEphePxvE3qWr+oYm
         qL7YtOe36K4hVCMaRdxxEl7XltyjA5D1CkcHFFuC6z9FsgQvwjW5KzUrgWK9oWV/jhMg
         hLataULJMfMUPnt1TRj3awjheIFjwoNax1RKI3IbTaFuzixqDif0Y0pijTFV0TZcErE3
         /1SpS8y20S0PmgMvrNLCklpfiUC3NViWo6Y2CWnILVQ3kJdSH3Tk+PmqfINzI1C1nsvO
         yG9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771364151; x=1771968951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlTDEr9XEhP0NbtXCAh2y2xp31drr7QfyS/Mc76R+jI=;
        b=botoeWYDq6fvifRVI4fD0lJTVYLd7uwbqUto25gdcXVM3rUDhYfUvYl0pGyxsmJEW3
         j7b6oCiwdpBVnV10nXZ495BUJKgZWYVI2mR5U6RhqwbJWnX22rHqm+2pJF3k4dhEuUQM
         huKaFlSgcjySX6higjvjTucMd4x2GM6o908Ykl4TdPucRaY/lhGNBIluKPY+N2Y2yUmw
         U6qTEsfixG+WM6gkwDCC/WRrFzSCgL4EhmgsiU1xxXI1EW+aWnT/J06GyMbJ8rWamzwQ
         GNoySymIsqvo1r8TeeP6E7J0e4gjUqYqBHcVz4O3bqFwlWttatPcheEV1Ip8HsVstC/W
         XdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771364151; x=1771968951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AlTDEr9XEhP0NbtXCAh2y2xp31drr7QfyS/Mc76R+jI=;
        b=IbaMxxwngYIKMuQ11KAtITMrOAMk0dxjpX9ox/HIAoKdXWOy/X8LM6muG4GbC8QctB
         KM3qmCH7M8rChhQb8/ScAcfedafdhxBUW3DAJ55/0iu+93uHpYZKUfDf28LjFrbl3pqK
         PXw/vI5mGwtYIUTNerowp6FHBwck9fJXhAHspfx1HfbhPbHIlM0o6BWOfvq9MaCdqf1v
         Q/No7ZWX950nQrH1YJ/y6qHtkjco8O0oa0XwPW/yQ+jhz431qf3fehENBtHjV6GQ/IPM
         GGdypJ56N4E5xYPIROVMMJfxvuwcU05ZH1osPvGBt6EMWXEfge5jKtGVX8y2uU8FF90V
         yb/A==
X-Forwarded-Encrypted: i=1; AJvYcCXGGTxLfsQTxItyoudez8y8AakhL0Y8cZrA1D4ZHGggWifH8KruF2v2ZyyQ35Q5j/nbeDR+RVcitQ==@kvack.org
X-Gm-Message-State: AOJu0YxYfTVqPo1ABfNJmd1ltZi++HNuIe6aaWuZJ+Dq7vlxtTt6VbSg
	PqoI1kX7wqeIgzgFUT9Ia6+R53989fJMW2XDAhN6jB4s4ZK5SMN6aotY991LxoSfQKLncpXf0sm
	d0ntlkaj1kSOiwb2/zV4T5IX+cGrs8vA=
X-Gm-Gg: AZuq6aIVLQgJ2A3iDwgySqWFlg+hT0QdZngF+aUDqJLWMdEhNIOaGePZ/ugNzky4+j5
	6KdX0h2JNRWWRh4sxOmBSEC3gUCo2PHwBUSB4cPV2ScsvA9uu/VftFKEW18D+7TtOCqGizQbBiL
	JR2bSAw7X26QssLGZS1GgAo2Ru8SQCGo/qld9+MFRHmXHdQm11jH0JtI+apfWPxNPM/4kbVunWA
	sjq2ijiu71uqkFzArG0XIkJ3yAwyqSSLkQm9Ea1dp0CmaOsG3BV3A8s0qqYtpZik4GpzBjRHtnn
	Qo4RP4BBQUDdrVe5ewO0xTPJoNiU0UJJz/F5rTf63rOAaTjTYvXSF3hB4v29kxtkJdSQB7iMVv1
	/qOJ84r54G/C1phZLg9c1U5yX
X-Received: by 2002:a05:7301:3f19:b0:2ba:8496:47e with SMTP id
 5a478bee46e88-2baba10f3f4mr3422217eec.8.1771364151417; Tue, 17 Feb 2026
 13:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
 <20260215-page-additions-v1-2-4827790a9bc4@kernel.org> <g4ihY-XQwSZ3ysINoU0v3jFzzJG7Uzonq0b6C-EYEYDx4pbJWHHJ1hYmQsmGATIDzexHv6NFea8YNikY6zXq6w==@protonmail.internalid>
 <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com> <87ldgteftm.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87ldgteftm.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Feb 2026 22:35:39 +0100
X-Gm-Features: AaiRm523b5qMOhoIdKn4-pyxHU1Rpi-47kriAyvWums9a9bruJTWdRHw7N9WR4U
Message-ID: <CANiq72kZQiu9DbQgkHXDDjHORwUdTm7oOhZOE4Tr8eHiyW7RbQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: page: add method to copy data between safe pages
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 3kepgfgab9bhbrerd5q8uskutrphfrbm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB5931A000C
X-HE-Tag: 1771364152-108952
X-HE-Meta: U2FsdGVkX1/VaJpPuixHcEW7/9H0yqvYDOHIV7pzJyGFAxeUitjxZlTnsYd4q1I40sKegXvLihyelg5wjf+37eTz3fEWH6Yj5jmewi+InJrNdC2590g4eitRSPvrUQs/EGzv8VNi9oW/VTTtrB8RJDhhtGtnL/OQw/wXq0mhdUy6Jmxilvh+FhyeRYCFuavJ9VfHfHKfd6zEnDx/BmpFllddJGRR7WqN4kboFAvEGXME3VqXKauBEIMdvUgogh4/fctMIAllWlR27wwlf1JP1J6yRCbzzXuD3XwiCjvbBz1b8Y8n9JP2tR6ctquKSh+ax6t7ulK2oaVT3jWxX6o1EvpFkwJOZWEccu3xGeafY/WTNap4AhdOj+JeMl7NkFaPeO4y2+egljhVoE/wInlIsdFI3ItGiWNzilswgn9Q3Dw2V/LTnt7vOPCfd2OYIAF1jlfsBbKGJSncsaV6cvU3eJ0mkHd6EVJXKfv7YeZ6dPMTDEAb7Gg1oDAaxD41BYhx1PXiM/dWGBAPClg0IubBkaayQaycfauOTj2gPCIImx7QR4+90r0d51IGPeEj5kawHg4wdIOIHXdXaaWhjJeJoOHuNedX64l+X/Y5+9fwJ9qp+aRKKJLN+VH7z3wKaEY3mzq3o32ACrDXKZOAUMWfYTTM6klF/9FysGoaB2SB/t3cskIIt7lyXATD7sjZYqVQitL0Z3QMhSTbVDNhH66bWfqlgxuDBelFpywpywk2UuLawt8Pp4zPUj1t56BkzFQTh6b6KPR5oL2omfkTIr2WmraesAYxRJ5z/cKnk518vf1VmRSu7AhDdD7XAvBthDono/JG1T8HlCYhyMLvu81b5RwiY7rdiD/5RTlFQXrJVCuA/slczp4zGFJs3txRCmHKC4B+pkuaUDM0Lb+i/OTVReXhSx2NVXvuCXE4keRuIJCVvanNNA89oHhn0BrPX82IADGZr1Xo6P+wyXEjPrs
 g7o9q+Ny
 6skXfm821ENlx0KDTjuZ2afkWsiQC4zz3bCFsK9hed5cI6ipkDOE3XzfApmMBFgj+bK7oMNfxsYET/V035ctJ2HMbtSPI2r3O6DMfcu4s3KgM7EEye/z9/8I8XJw5La4+vRBBRbKF5wrGcrMVy6Fva6zWFvemKpsaYJufXSLD9HaKUG+Dmr8Wx4NE/rKZHATii4a6jBi9mDBQXzHH3lh9zWQiYE3Nx/UNDWbIs/w3oR4AgfP2TSo4fTyzXj4+UVYnYXdoKKwrt2jY6qdffSkJFj57yJoJ1DDFJFJOL1ROeH6M9Ne9Jqly7W5YyZnkGUCeaI8r0OV2BG6tDo7m9Jnki1jfSU2Hoo5BH+wfRhlPO1Ieef9tBwBmY3+MsZwQ9wWtGAUzXHjKZW9hM8kcNgxpGhBVUmRaF5/A5yi03FsRPOL0duBbyyzxenCvcOWUwXLgra/tG08bE4C9Fj/tOhhOLplIpryOWPLmgD3HM2Do3JJWkkqdSQuaQ+ceIAywy9BKu/mvVNCZZm7B2VHe6DHFP60HFdCOWRlziyHhiKv1bTZooPy9ldUYwUK62Hr44yKWGuNVDM0hB/POZP8SLs7fGHxdD11YP7cPPeaDh0d8jYu9qlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:42=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Why?

If you mean why we don't do it everywhere, then it is because for many
functions it wouldn't add much value, but it would add substantial
verbosity, which has a cost for both readers and writers.

Originally, we picked the standard library style, because it seemed
like a good balance that both had shown good results (especially for
this language, where we have rich, strong types in signatures which
help reduce the need) and that would get others to write docs easily.

Sometimes it may be needed, e.g. there are many parameters with
details to explain that wouldn't read well otherwise, or there are
primitive integers parameters with constraints on them (instead of a
newtype that enforces them) and so on.

i.e. why do you think you need it here? When a reader sees the list,
they will need to pause to read it, thinking there is something
important/subtle there -- is there?

(I say this as someone that generally likes structured, "exhaustive"
documentation such as, say, the classic Win32 docs...)

> Writes require a mutable reference. There cannot be a mutable reference
> while we have a shared reference.

Ok, but I am trying to map what you wrote with what the callee
requires. In the second bullet point, you justify there are no races
for the read side, and the third one for the write side. But you refer
to the type invariant in the second one, for some reason, and that
type invariant already promises no data races for `SafePage`, and all
we have here are `SafePage`s on both sides, no?

So to me it sounds like either you could justify everything just by
invoking the type invariant (that is why I mentioned circular
reasoning, because the type invariant doesn't seem justified itself in
`// INVARIANT:`) or the type invariant is actually a different, weaker
one (which would explain why you need extra explanations in `//
SAFETY:` on top of the type invariant).

(By the way, if we use bullet points, then I think we should map each
to the callee's one, i.e. #2 and #3 would be together since #2 is the
one in the callee about data races).

Cheers,
Miguel


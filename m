Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C6EC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B9D8E005A; Mon, 11 Aug 2025 09:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02C38E0045; Mon, 11 Aug 2025 09:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A848E005A; Mon, 11 Aug 2025 09:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7681D8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:56:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EC6E1146CE
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:56:47 +0000 (UTC)
X-FDA: 83764627254.02.9A8D432
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E29E40004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:56:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gowW3LjX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754920605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCOQyeQgQCrSvbOG3qdi00ec7ZXwXD5w2RBXU1VKOdY=;
	b=S2gbZ1Cy88mJ8x+ygAWQ92a8M5+eVjmxj5KJrWtxxgngT+JTzQsrCwb1FpYG5+8WtEqWHM
	G90mioMboiGFjqHsMImVz0zIacozSdV954Ee0R8i+EiZYYxaSUz5C+2gra2gKQ7gk7Bk0U
	SgRsThzTU22s0J7EjDCnQ84IzBizEbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754920605; a=rsa-sha256;
	cv=none;
	b=UEm/bjaQ8dyiOvUILGhwY7Jo7B1WUb2EUYvdZHpnUJcPj8D6peGnXBFCXbBILvZtQtVNAQ
	UbjHcU8Ou/AUq9ekt6QVAIZofutH8VmbqblmuId/1LGhP5YZmW4yza1MMT8DgwyrvOV0r7
	B+Yd3+VCI3tHchpOMcBszGQ5AfbjNOw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gowW3LjX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b44819668cfso58809a12.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754920604; x=1755525404; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCOQyeQgQCrSvbOG3qdi00ec7ZXwXD5w2RBXU1VKOdY=;
        b=gowW3LjXFcklmzDESlwMBAFmaPU3LeV12MUbMum30l6MHFw+KB36vyZ2OiLrC9Ib9Q
         kkS1JoQLow33v+lXBpPrM6Y8nk0RqmTRoZlPrfEnb8ubvXT4G7PNhOarZ/IhIE9aUKEk
         b21IVnKwJag4bPPeeNw8Aoo2oYVnqwpMDc3QwFBb6SmeiYFYYKBGw2Ks6VoumFnJoAmF
         zhvl1ziMHF44ylpz4ngl0poX37i1UhjnTRhBdIOIWa2aJS6kvVEiZXjbjU2WedokpCOr
         qrCxfwSiK61YGnFmvBj2qwI7lu71C0S8q/iUhklstqtS5wrsvZHIXz1jMm9a02/1cNC2
         bnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754920604; x=1755525404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCOQyeQgQCrSvbOG3qdi00ec7ZXwXD5w2RBXU1VKOdY=;
        b=ftTJ6acupq5+f02TEAy1JevidlDBIWZPXko8uUQJNGfH22Shnl4z+69PKmpZD1dLA2
         PMg//9Vq9HHFM1TkaywBK1wzqKXB1SEuGYrTUxO8G225LrKrB3Bm8wu//avEXO28ssFD
         Z3SA2lf2WWmmy0rgrinq0sx2jjDf+6qpeI0alC4fC/BTMBn6gIkBqhoTO4D34jd/xFQd
         TSq6IyJ8QHHMEIefFCWPBAOKQRvq4jyzA+pGAVrlW4z3L5qOOuMUI8p+u5eWml8WbE4F
         +T+2vbXe4o3rnd2ENiworiF5TowguuAu6Pc9ITzATmR73dnkM+RopgK9qdD6OdO/3FxW
         9EDA==
X-Forwarded-Encrypted: i=1; AJvYcCWCk3Hs4dtsiqGUaZg3nFdu40+M9DQEvq8qcVVaMf0Kamzuvh4PTcv/mulm052WlJ+k2HWxK8d+Ag==@kvack.org
X-Gm-Message-State: AOJu0YxEIQXMK0ouEb84wKes8HH8VCG7+cT8kF3+Xudx1C93rP5+cojW
	HCmiW3CWqlX8mNVSgJmRPHd/oEyop2u3pn423yQgNhsMBZfRlhg0E/tBGTm0FARgJR7o/zilqEp
	7it+ug6wP7QnHIZjQCRntNuyC2zy0umU=
X-Gm-Gg: ASbGncssxWO1yIYfImu/SBu858wYnfmZ+CSFmAtHDi7u06JlFnXLxcA4W7WOEDUi8pF
	5NZCuPWXzXpJkSO7sLgU8tAqERE4ucj3kbWHW6LXuH/3yjAtzEubM4bb4EMYUpuJz6hIbBjDoyu
	iLgKqXWaVoHofBtCL9jLBtMMSAsWpQxi2HHW5JKS5+NV/lHx25OOJ24dREkgj1igwZq9NleNL2E
	XNRSGMK
X-Google-Smtp-Source: AGHT+IGm51CikGHL6+jYmpTwxrPxuovvEiRL6i4rcZPBDkpdQusZ94Avk47mANayPiICPGjLYk5AoIIPxCie5iZ/BD8=
X-Received: by 2002:a17:90b:1c85:b0:31f:3d6:6d98 with SMTP id
 98e67ed59e1d1-32199dcd917mr5571397a91.5.1754920604001; Mon, 11 Aug 2025
 06:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <iPv7ly-33WYOq_9Fait3DBD6dQCAn1WCRGwXjlPgNBmuj5yejzu0D6-qfg3VYyJfwu9uS4rJOu9o3L2ebudROw==@protonmail.internalid>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
 <87o6smf0no.fsf@t14s.mail-host-address-is-not-set> <CAJ-ks9kTacXO_PbcH8c-60Ae88vJ_w6_pbmXLzOpzTKgRjiXPw@mail.gmail.com>
In-Reply-To: <CAJ-ks9kTacXO_PbcH8c-60Ae88vJ_w6_pbmXLzOpzTKgRjiXPw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 11 Aug 2025 15:56:32 +0200
X-Gm-Features: Ac12FXxaMvGNNkQ2aB4e9UkhjuY-poUIRWZU0YDLB8I_zmJcCDsbhfY45An33jQ
Message-ID: <CANiq72nR1EfB3SRyusswrHY0Wo1JYky_Cap8Lb1NjuHGwC9ggA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rust: xarray: add `insert` and `reserve`
To: Tamir Duberstein <tamird@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4E29E40004
X-Stat-Signature: b7zbyzx4qrsf9mon35jfcs86pog4635p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754920605-588025
X-HE-Meta: U2FsdGVkX1/nczbUYM92RAPJulnkZPmQammDLf0atFV8C3t7GrHE/5TNqRfp0PwyD1oMs0RuLVPLic9Ig0j49ZJBVCxaSUyKxkN293XKx+rQrmn5M/YZETnEnOLcu10b2AsMNxuMVGZBtmggsiPDQWWtcSPj3pvvpLfjJ6wXyZgzU6PYzBI/yBjCF+jaLIHFNcP6IjnigHuOPMGrv5hIdajgIcJzEAmSHL2iPjLXLpSF1hMxLb67GlSibly8NjnJxccuHlNFelgYN/16GQQy+gI8PuMAs9B7rApmdPepvxpnRAKxfn4P0AHM1t/1CB5aNM7lGVb+55SWaQ+PaiaKB7e0IdQQSoXoOHGecAeyWBRGPxadpxdgfu5Ib7kh1sbclr9sa44keTpM6HWpPQgPvQOuesslAzxmAqphipupMw+HuEAda1NVaEr+wa6zwG5wUD+9irgdMMVX32GRCzO8sAJju8CESXRuUF5MTRC5OVfVgDRb0IXfH2ZFqx5aEjDQaeXwpijBEfXA7rRi/vpMxfXjJcNoM05+aYa9dullyw/zAEh9x5d1sDe8ps7nM4LKhXqcJtzuI/miEcXni6sfrZyYMeEEIB2+VH/vkcQSYp3KD3V7aM21lSLa5JGb8K2d7biBtAWNfbFvv+8A7ELhR5jnmyDAQ0wo8DBzP+7GOxSBp2WLwpgE9ATqYXAllisD33dCgwzBCqWocGrOTm9PApb+uGr6TVgFmYWVHMcnDI2sqPUc9CkDYCTVsYgkjLGb/3f+omrlETYoD56nIoZXx2y8TE3eoQ+CZ2byrVuQVgZ+WYkaVGAM4cjcUw8jXIqoLuVsFdxo3yAkzk7SZQBFtxiMBM37Wk8/IqhB97Eb/sqNLHfkQ7jNB2Wvnky0eVortH5Pp3cgFYI2zqSjvzkVX3s+gHPUpNoKGVBbFe53/ehSjGJma/B4Mx8ry8awEYy04SVsSq4xeZ7zHE+b5Lp
 kQQ2hpod
 mPfhol0al85A/WDOWymj8Nv80JWPWc4XOpMiNj+yhiPTVMGJIceZrg6doO6rcRLsdXw0D7Rv03AxayPaYV//vgwSUek8NlUdnOhVALGl8YquWNPupOoYpHVElg37QaJp+XGmlE4ree0nkQ5aGqi/UxYbIERRDIzMe9jE/vab0aSl3SHPzcMpyOzB0dBSCJ1vEqshJQJjgujLc/7basx6eGQXXZT8ywloxTBylUvvy3/HFrOlPrR1dzNhBYhYUxVnilkC5EQZqcOgHqqZ5nyqeYsYGzV5IgAFrzvzIAKMCT67sWsIgs0pDtWh1SPFM9mjjx3cm3M9i4lI1/XGP41NjUbD6NBwrerg9Di23I8zsb1lETIlqaVbvudsSPtwPY+r8RrL5oQxIZ+0g8o4TP1lnUIk0aKFrCO8qeJLD03LsmtkAfLsO84y3unhidkivNPYgYv9Gr1//BG3ln95ZNxsnjW3oorGgSxZszMpLWP7J6kHCQeBxf/XE63+/4AjjrdrtZ7VY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 3:43=E2=80=AFPM Tamir Duberstein <tamird@gmail.com>=
 wrote:
>
> I think I prefer to hew close to the C naming. Is there prior art
> where Rust names deviate from C names?

If it is a name that exists in the standard library and that we have
to use (e.g. for another standard type/trait), then sometimes we pick
that name instead of the kernel one.

For certain things, like constructors, we try to follow the usual Rust
conventions.

Moreover, sometimes there has been arguments about the chance to
improve naming on Rust abstractions vs. the underlying APIs, e.g.
`iget_locked()` vs. `get_or_create_inode()`.

But, generally, we stick to the C names unless there is a good reason.
It depends on not just the code, but also the C side maintainers and
their plans.

Cheers,
Miguel


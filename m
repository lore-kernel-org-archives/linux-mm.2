Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533B9D78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 12:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68486B0088; Sat, 20 Dec 2025 07:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B414E6B0089; Sat, 20 Dec 2025 07:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F2F6B008A; Sat, 20 Dec 2025 07:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 942906B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:54:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F535888E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:54:02 +0000 (UTC)
X-FDA: 84239841924.26.2335D9E
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 44BC31A0017
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:54:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dLfY1L7Y;
	spf=pass (imf19.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766235240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCt1NiXGvYVNiSKFRGiFenUe4OH0SVeIOjJJWZ88kDs=;
	b=wCLBpmLOpqkPribQ6jmL4mVCkeBZj0OGoo0CcWJ0uO2iQ+wIB/3vv1YsFejcvYbC/sGbKY
	OQU1OVI4T3vOt3CDwtzdeLgMqKfQuDDuuQ0lUH+0xQAeKLTqn1LbF7S3oaYGM5NhKihiql
	0qC4DygeQ1VEbXOv5EDqVZuZi9w/5ho=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dLfY1L7Y;
	spf=pass (imf19.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766235240; a=rsa-sha256;
	cv=none;
	b=bKRq6uzn48QVQ7EBpa37CDiWrJHRi2qeNFVpq8aqjDxRhm+BITEGC5wIsR1dyJYrzui0fQ
	aUhU6Fxg+aNuF4C+0F0/iUyTSD6DkXOmK+25wUEp1hoJzMgNIqXF25pQpflNM0FX2k5bEo
	QFt46eJRBR7hKNgek6gbBj5+voEZk8A=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34aa62f9e74so3380687a91.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766235239; x=1766840039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCt1NiXGvYVNiSKFRGiFenUe4OH0SVeIOjJJWZ88kDs=;
        b=dLfY1L7YnfUJIDe1GEcLRIDWLhxGNEuP7loElHOVsW7CrW+acoD7P97FOqob68s0w7
         fqaTjKo+HKuZ1Cn46eOgFO1ZawZwkZ04aO7K/AtYeBVK9EJbywQhfpiomeVrHmawv5MW
         mjpp2fiSSj7sWz5MkRUAVcTfHkxUf/Wrv77u0YOp9z70eqKp1G1/Ki3tTyNiunmpqpPn
         D1vHnpfuNeLPo2xdqX4wYYU0RkVSJlMaqkR9D2h3+5Dwik9Fn3m+LEqO5N/ZxaJrg3KH
         odSfMPbGej6UUdh/XAAzSytGZ/BdbatHm5mRqK14npTq3sm0xdkMGqKav/ZjjpTR37Wa
         k5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766235239; x=1766840039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DCt1NiXGvYVNiSKFRGiFenUe4OH0SVeIOjJJWZ88kDs=;
        b=Tk6/tmszUjzJNm2FGWjuSSVorhI6XFRtRdqSTlCsNReJeW3xNMjjll4bf+aEcVlMiC
         FohbaALeDcQ7G+168nF2hiEObxOByw/Mvh6dnVet1mCKDosRl2aKWKvGi1Eghh7DdhrU
         95j3XCQAe84CS/oDfYJvI68gAz4E9+mVo/brA+XPMZLTNs1o+YsIs6OJSnm1Drek3Zoc
         2sHoiFc4JubQF3tiegURfLcmt0qN8teIJUlJKjpwRzFwdFB267Fw7IV8a3Lzx/PVSbpB
         JWa88LjcDvce3QlN7d2uBmV+QNr6tOgLQUil6c0edXAcKViUN+0OiS9tzrrPSUjTkVPU
         Nh1A==
X-Forwarded-Encrypted: i=1; AJvYcCW442dQTbKYoMbcRbD9rvZ/JuIZrmK2f06i2R1u+99nCMwjN7rKRZXw5twwI23k2SlEnd9Sab+kbg==@kvack.org
X-Gm-Message-State: AOJu0YxbqrN6dNhVUBEtTnDNLyY/7LEXMa6HyVale2w7gX4V6+rcEv3J
	HK4JAHzAcRtYV91gGjA1p3mDJUgCnidGeLJIt74zUxvq5sLOa1KrmuuYWjbpEnFLrmZhc2fiZI1
	ashLEcM6hPi1dXm1H5ayxKcfJKt82BRQ=
X-Gm-Gg: AY/fxX7+oxGn4ztwH91xBnO6EKRDoXoFgaYTFBO1fPybOdZeAjJPQQZazcG+ReVqR5w
	ulVq60SUVZgt3ZIB8qyyVKFyXtt/W/1kgZrSY8dHpY+Eyy4pfpjl/OK7y5wS01Tgy1fBMqP2zer
	7PQX/FxVAAD6kMA4mEIdpU3YlT6RWT5BV/HM19EttS2UTQ8MYfXvbIPpr9Twy4CK9LVtadnq2My
	YCysYWve/7+Nc9XWks3N46+3qS7QBnLvokpnefmwi4t8DtobZRqBja/jo4yjjtIzg2w8MgMknyj
	Kpp33ryA/CtquGcvDmkQD4Y8Uww=
X-Google-Smtp-Source: AGHT+IGxNP/OFMZ9VQzxbDRyZknUn4r2tWcISDr4M8YPv4RUlT3pFlEiCYhZwoZk9P9jMjfG7pp8xWIa63+jRalj8zo=
X-Received: by 2002:a17:90b:590b:b0:34e:5aa2:cf61 with SMTP id
 98e67ed59e1d1-34e921cc3b8mr4507598a91.28.1766235239094; Sat, 20 Dec 2025
 04:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com> <9efae3dc-05d5-475b-bc69-250c2186dd70@gmail.com>
In-Reply-To: <9efae3dc-05d5-475b-bc69-250c2186dd70@gmail.com>
From: Kari Argillander <kari.argillander@gmail.com>
Date: Sat, 20 Dec 2025 14:53:43 +0200
X-Gm-Features: AQt7F2q2KCAmh1RkxHvGyCP5QJH5FmUFdWQjor_e7FhxwJWiL0SnJgUIgH-KIfU
Message-ID: <CAC=eVgSkqruKPn=-5RJW-1SR5TmPRj5BtbPH0Nu3_kuUqk53Eg@mail.gmail.com>
Subject: Re: [PATCH] rust: page: Simplify overflow check using checked_add()
To: Dirk Behme <dirk.behme@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: 8kw4d84ku3xi3sprhaciu1b9wp9qa7es
X-Rspam-User: 
X-Rspamd-Queue-Id: 44BC31A0017
X-HE-Tag: 1766235240-90186
X-HE-Meta: U2FsdGVkX19PEmnVdNGwF/Eyskd784wofl8RLGPNOV6jNAKEiM9zR1VPmeKtG+fapA10QEMVhLyD8qqTd7YPSEe/cz7WwafCOgSodDDM6rgM+IsOD3BULbHHJFgcqMO0x0A5+OhzDeT87ZcO9CsZrXZSK8fhg5+U67E1LIf39Jsg35RdkLeKkS0K+FohJFvmuwGydPaI5Uq0QNLSa0RY9IYIcK7xm7ba6j2pdzN4rADE/u8QCs+1UBvKvl0FLatYOcGz1Z6ghL5pt4B/G1KDwjWF5fwq/fVQ+BgRAMsYKuDuPMS9vFb157KYUNxkcsghluqxTvP/KfwSu0Q4gqGw5GGqp9USmLneRj3z1UbJ0ijox3z4JZ6djMdKOHNGBZW6aIUOJ9qLrJX04cFCJa/ad9aM5Q66q3SFBUsqeY+1Eq1mXT8tB2Z9GrXMIt4VkLaJQBKInMTUZX9W2+WptnzyYU5ZjBHyCVPtGm2aekZG6ZduUSdc8Zxk3th9Ojc3EH7Xu7ji89X5GLSBciaiCg7Bg/Xk/xMu2WJC3dLLOwIBF/7x8SNIVnp4olCf2NUnoI9P2+PLAz4lvsApE42B7xQyKSAbSsRf8YOqjhRQJi3ISYZIN6OR8DWse4xLGJ++LEFzwp4KcbmgvjdXEOtD1yLbxBEwCuUcp8tiQhH6cJLeaBiUuvkXI2rwDFXHm6aRe+vnJye3sfLmnKBzlJ7rkvUi7wyKbbDPhRI7wAxdxFwy7PYRiNwAMyLt+1iZHZiDQQRtSat49+oKuLiu0CR/YsfGV3KEICslaVFYJpAeTtu7GD75stP+guTWD4YE7smNXpITiek7Rw8eq2gdCcMRpMDyHqUs3pXVGk2tCjMaZX0knIfLaG2dcer2RHtf3A5qEBF+GAl6XVmbFc/IRM06JhekmCEkTX4+5/2Lmi/WUnVqHqr/ZuHRk9JU0z7jAmne920X6hWgagCUWji3p/DR4V8
 mQFCKtSF
 VTH6TGEWRZekSi0zNxj1R+gn2fZvmVBmA6sSRSN+4QYBsWem0XgBhzg9zrBBvneLUNADTeJU9bpzQwJbQepfq5RjnJ+pTbqb+INKGHLW150PMui0ZbaYZKbafe6TeLwyI8MRcQLr4byf3TJ7Nlq27W9uBmE4Y4T5FmWcXMqP05hZkWuGiff177bNx0EooV1yw4s9DQjzkNeE8hUvvuAgpUiKHeccn98iFcM1dzGtyHazTVHltFL8BczKRSlcgPHHD6NTaGwNJxeqftkeCGiSQ4meuqaRUNHU+p6T/7NIdhECra+iqothQuxAKkFZfGU3WiekVk+pS2wvcmLmMuqoXbeJOQ8AU0KznHtbQDBKHfRJcN4d4zCjWeOwPHz5put3e74MGRKNL2KpNbZd71tLTslHzg0gr0fNOli6VxAhsKgQpT4HAXr1HyX/xNKpBIk6Ynj2z0iW6AgHw4K7mMoLXLoMADV2BVAH+DqCH2l1Lu1ttbLU4Qsd08RtXhcWSTO37k/9Zk30XPkgHs5yXwNGb6W6aKCJtp389ZdRCr7C6LvK+p94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.12.2025 10.41 Dirk Behme (dirk.behme@gmail.com) wrote:
>
> On 19.12.25 22:29, Kari Argillander wrote:
> > Option::is_none_or() would be nicer, but it requires Rust 1.82; the
> > kernel currently targets 1.78.
> >
>
> I just wonder if we would like to add a comment like
>
> // TODO: replace `map_or` with `is_none_or` once the MSRV is >=3D 1.82.
>
> like we do in e.g. transmute.rs [2]?

Sure, I can do that. I=E2=80=99ll send a respin maybe next Tuesday.

> [2]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/r=
ust/kernel/transmute.rs#n75


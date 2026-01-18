Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FAF5C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 10:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50456B008A; Sun, 18 Jan 2026 05:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07976B008C; Sun, 18 Jan 2026 05:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933E56B0092; Sun, 18 Jan 2026 05:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB2C6B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:08:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2002A140363
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:08:53 +0000 (UTC)
X-FDA: 84344660946.27.57575DC
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E047140006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:08:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y0xtC+i+;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768730931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhEepC620f7PSurENGJkYTsztzKlzLPGFJM6HD3c33o=;
	b=v7j2uOrjCz62Qtwk47YG3vS57po9QW9RD4yPzhDonJ/LpBsoQP0iH4T/JnrbMJGykDv/0i
	+db9vM6fvkJFJtJCWK0rfGJd4+G8S6q6MuJkMwwyxAyqxIPhAAkw9B7y9NqSibzEEvvcgs
	o8ZjPH0pHNH/3uc5+DD2qut9wr7OH3M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y0xtC+i+;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768730931; a=rsa-sha256;
	cv=none;
	b=crDfDD4WjCa4fqpEEQ1uT57MdEFMTqQdba5PuGYY/3Ur2UXB9qEJ0XXjUp2gELqQNLKKvM
	aYIwraXTbTwxDV7XNRkBlURj8sYO6RDXcpGL6WcXOfnMeoTNREA1RE5gNBNkuEqfHaDkUk
	QdMBQColEyaNWbpfN9JX+GRv+pYCH+E=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso22657385e9.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768730930; x=1769335730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhEepC620f7PSurENGJkYTsztzKlzLPGFJM6HD3c33o=;
        b=Y0xtC+i+6rt1G4lalxuCQ2GQ6/dPeX10Y+TmDlTOqWN9zKPiyCqQvJvL34FeklV/mU
         dC2RUTFfGG17q9NgKJ3Tw9dZ93PiSfsGB4uQ1+AISRL/cnzx2yIjV9VdumNcMiozeGvA
         SNRzQz/evDjPeRs9msBLjFv+xYo5hiZYSHBmqxt7m8bP5r+y4/Ug3SjYemHfSgfgqr8u
         rOc+bgeY9OMaTQFsgCbqgA6xjqM3W7g9CbBiyEklbXV2d8TC8o2dU+shWN1V0SKr/kO7
         TjP45SMZ9xzMtqA3Qz8b6OaXG39MLkzYlQfiF56kV3CwQIjNRvWoRlrUuxLPnLep9MQM
         juwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768730930; x=1769335730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JhEepC620f7PSurENGJkYTsztzKlzLPGFJM6HD3c33o=;
        b=iu7FPm74woLrEUSlbrk+NnI7UDL8n8S5zdCqFVQW3lxoySGsNeAjBFrEu1TcVOGXXC
         QAIjegOhcn2NkuD9CwDG5gHOK090a5EviyiV6EC0hpqOHpAjrWJsDYQLro30Rt4irFw5
         MnRqR4yCZCb2Uca01i+Y24GQRlsr7luMaRFUZLkM0DElvUy9eEdep6suQ9m51tTCy1eF
         Q54NkbPJPhOcVrvh1qm5uJupQapINBs1PeG+RluE0vW8rQNKp7KrQwMt+um4zgFF23xl
         lRk4zRawcHdxfIIFJquOUGM+A5oQlo9m7F2FFFCQly9WHA5HJC14IWBeXRdabtFdgb3w
         ZFhg==
X-Forwarded-Encrypted: i=1; AJvYcCUoLEFNXga5N5SDOhDrmlpgQWEbziXkEd1HBeSHtRzoJCMBswd3Z8yHEWEoXp0tGre+JlT4M53hYg==@kvack.org
X-Gm-Message-State: AOJu0Yz+3qJ4lTZv4YeRtp1+t8j8axiQO+UetGO3CVvgBGhVG0S1M0xP
	Py9m2WAqJI0VZLcb9d03mflmpE5BhRyZyGz0IYPF9EGP47Kq+intRBmFh9uHtaMs51sZ5GHSkgp
	ZjUba7OPCUjw8buE9xObPTrjYZ7QRiGi1uRs2tXOY
X-Gm-Gg: AY/fxX49I8HyZlud3Wbs/Z03qQKh9AjuzjWpXkQJLAgsJ8g0Zb1BUqrE8lhPnzXGoss
	sbhKKDHR2YKn0yxPIet28veg3/CNnDGQb/S46HGE3rkERsjSxvJQIBPxhE8CDC9rDZbeaHLmyzs
	J5Qn2I4qZQpXaQXeQ6rpORyBXFt+x2xd7exvCZeQ4AThC5p9FFrFNM/TDLvrRmW2TIJOHctJCha
	ia0Emqpwuuo3d6PBmiKGlcT8KkFNEcVVb+vlwGP4ehafQqES0T39t4uyyytg+ygUAupe0eZhbbQ
	fmWquhlWC5gZtO/AEWhgd1v3/dubU8FqfOmq
X-Received: by 2002:a05:600c:5486:b0:477:afc5:fb02 with SMTP id
 5b1f17b1804b1-4801e33a82bmr102416435e9.21.1768730929647; Sun, 18 Jan 2026
 02:08:49 -0800 (PST)
MIME-Version: 1.0
References: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com> <swz2lj4xhs6vjmjs56aj5u7pbk4uaqur3cqt4zoybqrx7yckg5@ifu7j7i2fmco>
In-Reply-To: <swz2lj4xhs6vjmjs56aj5u7pbk4uaqur3cqt4zoybqrx7yckg5@ifu7j7i2fmco>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 18 Jan 2026 11:08:37 +0100
X-Gm-Features: AZwV_QgEnja4-Py9gRSQ--EfuDMdE5KO9EC5s-5Nzmv9xxOLMF8VJHFVFbHfPAQ
Message-ID: <CAH5fLgi3sPq5BfkPWJ0ytqyGx7hKb=4GsTcX-ReVtEkKG-re7Q@mail.gmail.com>
Subject: Re: [PATCH v5] io: add io_pgtable abstraction
To: Joerg Roedel <joro@8bytes.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: aqr67rxfcectskqb1jqa9hwoirgrdp4j
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E047140006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768730931-353212
X-HE-Meta: U2FsdGVkX1/HnRMH1qCD0V2xkNkw2ivd7VH0DasbtYX5/WJ8XvunShTZQqK+y7Rcha7rJwI7qqLPFCg99J+3v7vSRL85u6OAZcjUacLFE1IMFue/oROTc0gTMrFezHYSdJeT+yuINPinNyQANpIdmPQ1OkNL8O5teRbQfe67GvdCtI2X6nnIhBaUWZHC/u+3M88TeLgO1oS+uDo7VI8lSMGFNATzoZOoOP5S16jrShLV6bkBfRmFPh/YaHErfYB5loK+07y1Wn1Dem+4Ne54ILp0vRRIGZPwiOpl6SXqIHmwAiBdJKH4oMjRKmCDreTauJs2SG+FCher0ScklcjrydRO8Gz+oAKDthVspRRUTu1nDQu3aUq0qQYcuQ7x8eX246Cb/KlXffZjQMglmWJDJzy1AveRxuwOY7XCORV61fIrVKXhvdZKarAfvuSm5Tyhpv+w3JFR7yWehZPVxwAL8W/UbIg6FhnWTVl97D6Gp7myTuaeO2omTSepisPo+LXM57o30ATF79uZbaAknve4ZbELpZmGRxwqXEDMriv/7SZzmLD4jfnPSyKALKe5X1nDvPqupZw/h1wCajD9BJbREBFvDPXHHa5/dP3sDRW7BOXejG9vsrEyRYJD3Ys7lTY5sEjr/xH8ulk4JQPkUAH2t5J8xx+wA8oZ7hw/a+/DvLABkKkCFxy88hIp/4m6LXumKh8MaYpPuoMk+riu1KSJTpRpSdgH5VDkShdNzgaNMOj5WtIkHYpXTFwCZGtHyRXSngGmMOEI8o+Xs5oWQEsJ2SZqVj5AhRsrIRXI94hlaN0bbUCId3XTx1oDrFpaBQRIeRhDTtGuNmFXqZZaOw5i0mmZ8ZvT6zZfNZ69P0RWLBlLq1nRjbrhdxLvpyzQ/1Qe6adAQVephvGble5fa3Hjp3MaVcutHY2iEpIByq3RzuYDpWH7CVkHwt76bg09/J9HMWio6onlXGt73k82ReS
 xhsLZZx9
 1QfA4v0a6VYxyiP98rMuQe7JAnJY6sEco/rtfXH9iAfNKV41OKWpCdTY/XA/FYni1EafKSAKB90LoXoXt9FxNOi2LjslCtdqouO0YfrEUrZfC9kTkzSKXq1OjMOEPXIGaJ+9k94bLQr0NRXIZWjVL3HkCJ2H+c7vjGBvu8tapyDxdMy2PKgAU6IuTPfDHVjtuXVhWTLQ2hMZ99tus6XLvcP8EQO+akD/ZreEGZJrNYG7tyl1j5mdtbZR4YYS54tFA9ddDc92LHxX7/s2I9mLQi82WVnochijfOP97dmZuTuXNaxFyfFxFkaaOO2yCztkq3Mn08Tpyf1UKFoB2C2pXQDSQ81O19kfC/6Kut41ucrQq+05L762MMLuV1U4o00cJ7w6w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 10:50=E2=80=AFAM Joerg Roedel <joro@8bytes.org> wro=
te:
>
> Hi Alice,
>
> On Tue, Jan 13, 2026 at 08:49:27AM +0000, Alice Ryhl wrote:
> >  MAINTAINERS                     |   1 +
> >  rust/bindings/bindings_helper.h |   3 +-
> >  rust/kernel/io.rs               |   1 +
> >  rust/kernel/io/pgtable.rs       | 276 ++++++++++++++++++++++++++++++++=
++++++++
> >  4 files changed, 280 insertions(+), 1 deletion(-)
>
> Thanks for your contribution! I'd like to queue that for 6.20 but agree w=
ith
> Danilo that there should be a dedicated iommu directory under rust/kernel=
/. Can
> you please move the file and send a v6?
>
> That directory might some day also contain everything needed to having fu=
ll
> IOMMU drivers written in Rust :)

Done!


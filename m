Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B06D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F2A6B002B; Mon,  1 Dec 2025 12:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456E66B002F; Mon,  1 Dec 2025 12:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D5F6B0030; Mon,  1 Dec 2025 12:09:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2217B6B002B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:09:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 955DC13A6E6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:09:26 +0000 (UTC)
X-FDA: 84171538332.19.231606B
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id A582D80013
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:09:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avJxu5dP;
	spf=pass (imf30.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764608964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10oqy7XG0ziR1jN7iIJoYu4N7Sm/NTHUpb4SiggOXnk=;
	b=8qzklkrKPdEP+qA21ZqeiuBL7r9yi6zWpxa2FJirqsuvV5/ifPYqtWaXBNtFJPHYa0J+HU
	DElrhB5FIlFoQ92NtoCuXmZLRTyl4wUR5jWx5Pn75ZWLRVgq796yOJYGJh6XFTRdulkwv1
	DU7hgXyFDfvuxaLQtwJZgnwqPuCpU6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764608964; a=rsa-sha256;
	cv=none;
	b=fVLE9VteTcZ7iLIYDm68dcWfHZpuattnbxKTqEJdvEcQB3fX86kDNJ8Qa1Quk/vvAX4FiV
	UJEWTUKM03LQT5SFk6ztBxRrfh8S9yX8pZ+ipwesFg6us+TuBHWVhBYDsuOMonOtIz4H9f
	3N/g7D2qgKpKjjWz5gaxP+Gv0h/ViHY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avJxu5dP;
	spf=pass (imf30.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc144564e07so125655a12.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 09:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764608963; x=1765213763; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10oqy7XG0ziR1jN7iIJoYu4N7Sm/NTHUpb4SiggOXnk=;
        b=avJxu5dPowqNYaniL6VI3dxCMWG3zhuERCypJp43tHsZiJTI7y4N924wN3eHdBFDEb
         znNFQpW6LeL5hceMkOmp/copoO+umWpWNSrJZj520hdpFQ9q3ImKo5DQmieKBH8KjTeq
         u0vD/20ZL7YyrAhhFb36x6vNRdjduHcPM879F07w176Lia0vFuZ9/F7iS6kdd0YyM4rp
         WQcqSW1IUIimfQ9rmIHn71aJB5EL/inI+6EMAKYF3i2U96t8THi4eqA0vnSbko5Sw5md
         s7qCrvZKFZbNaklVlg7NmSbjnLKP4KbyAcJMLJESo5MKEvuBB9tgM9CZGNLFbWkGYXgF
         BJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764608963; x=1765213763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10oqy7XG0ziR1jN7iIJoYu4N7Sm/NTHUpb4SiggOXnk=;
        b=mm4kQNd15FnYJp294B5Z9WpBJ+BhB5xEvarwtQN34mELMXlNyAs8+qYrSUckjMs/c9
         P9II9UEpxoZmcY6RIs2YZdrZUAuIwTuPHBqX47af58PYJs/F4mRDgb64jso0rRWJFld0
         nYtOlnmFuu/zRx35PICJrTOPZqXF7tVCPrrSpGRjDhAwe1M5MKEdvfVKS5UgDSXZdlVC
         f7KaAbeCWevng92YiCQeiVSLlLXcGgYUBy84WI+ss304M3CC9cYfUUuMwMuRJLdP8+tR
         ZGSF6RO9Yk/EfBTUvpsTY0RMvz0yQ55A/sA+TJWUUphH0y8+GIzmml/t24aw48Lg38x5
         oDjA==
X-Forwarded-Encrypted: i=1; AJvYcCVZugH2xfbMAUGLLfkVFCdSAZlmJdxe59Tl2Vy2O8pbPyqbYsR5SyrVYC44xn3DYTGxExBWWGA3eg==@kvack.org
X-Gm-Message-State: AOJu0YzyAYs1sQYvT8x3l6YRdXppghRcNTWJCJKMPPz3rdfd9VhChP14
	Ndp0Hfx388ycL6uqbZn4Lv2/hus1zMGrkrGyMb57H5zCFpfK6FxJrvhpOQepTjabOgv4DUf5gBi
	Y9Y5xdCuc19OSfZPrAHaSaVlesmGpsrA=
X-Gm-Gg: ASbGncu/qHjfawbrX5MTbAuujQ0+TqGyPao9zcPp5foTuJ+SCGv5imD80ND/KrPNS83
	ASIpkdjaff7BD+s5jJuYtdU6fqXDXw+SlcMRoSyYH/5AENu15iMei8N1PE5PuUWPoLWeWJfeeKw
	40rVtUO8dUCQaE4Hip5wZ+fubFMkhT/+e7BjlfrHPHjvWEwVhnCyvUq9LxvFIfi29yFqq4BmiO5
	roIP+sUhorF0wzqntsiUUxh92DMvqAaa5/mrJLXcyOHPe/5mcAKIov3vih6D0fSU3G7y0m4HLAO
	NzDuzSvthi52Y5Lc3oez36KJgk1K1f9Dmclxn15dkrtoyhngddSl+G/ja5oh/bxziQOWMHgYNPB
	KOI8fr6UxXJOygg==
X-Google-Smtp-Source: AGHT+IF1YPYGD/E+eDHxFkwlvTUf8jqG51M5LA+tdLWxMqHx4a8yCVti7p4nga92l9CsKYM8VN2f66dz5zEFbxtTTgc=
X-Received: by 2002:a05:7301:e24:b0:2a4:3593:2c07 with SMTP id
 5a478bee46e88-2a7243ec7b9mr21959223eec.0.1764608963077; Mon, 01 Dec 2025
 09:09:23 -0800 (PST)
MIME-Version: 1.0
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me> <20251117-unique-ref-v13-4-b5b243df1250@pm.me>
 <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com> <aS1slBD1t-Y_K-aC@mango>
In-Reply-To: <aS1slBD1t-Y_K-aC@mango>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Dec 2025 18:09:10 +0100
X-Gm-Features: AWmQ_bnmy3Os7dUuxEXbA4TScnRqySjzLSX-NOnwmbpPdF9z2OcK2znpi-34sDw
Message-ID: <CANiq72=mZXc5+fMzsdTRupUsmsuLdsx=GZucn2MNoCTLAT1qkw@mail.gmail.com>
Subject: Re: [PATCH v13 4/4] rust: Add `OwnableRefCounted`
To: Oliver Mangold <oliver.mangold@pm.me>
Cc: Daniel Almeida <daniel.almeida@collabora.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	Asahi Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A582D80013
X-Stat-Signature: sptbssgw6tdscpy41c4jypsh55iiyjer
X-Rspam-User: 
X-HE-Tag: 1764608964-850135
X-HE-Meta: U2FsdGVkX18q9ZyHGc9L49uLsreiTRFAQbz3vgN4UGeXyv9llSX5Q1lazJQ82PTFqgNnMR7ivH7Y8Ij5NnpoS3bReb6pbmQJDSZPUyq1eLgS/8k4nYWmlZ96soOndiENnHj+UnhwldVMUtqJAw0/6SFO30XqD0c6B4nsRZqFvswci+9FVEH3ABSLAd3lDfbiK6ABWAxwlLPnkVf8pk6jEYonv8UaNeJVx6dBrcN0tZvQjMfYnNYnLF0TrNlAlYyP6oRI2C1b+UJFx/FDkO/Kv/lmZSinlpfTZnlsRcyvDeXOsXgTIkNJBvwOIVkdlX8s0c0cACfMAWkdh+84F5dl8N0kxl4BFOXV90eliy4TKEdtakkVPxvL8yzzmR0N6HjjU5UQHVxSuGuUk7FJMC+TuHHW3GooIWZ38JalsMrQVJzcd+sZjuI5LEueaM6Bs1SKBlTwUXfd486HHVEQdKdaf0ANvOuMIdQhLse08M96vtCtM2lGjLK6o+pIPOVEuqeZQUaxo16TjkV7u+i/g/XmwKKwhDWeRss1VspsTVOz2aSdLjubsAqHVVds5+bogtmo5LTi9mF7tY89DZMdUk77iUBYnLufwAvCpi7E4nS8RJUQ4M994HIzaK6IoffEtHMjP++znelUtY8v0uTqF6mHAmmx37rYcXInWmWYiFcFVau+0e9WWCF3IZP+aHW7AW4XFg3S1xAsXyi7tsHo84S+tDLtFMqvKVstDDY/gt8K8PR7PE535cbRNEm9k/DDPA+dmmiRBLkYru1MgoKWCDo0/eSe9UWbTdRWyQsMKyjm1psdvfhbFBhgtlxeTpSU2DaGH4Jeg2zOygcR1PPUTMA0qqQsGQb4o4oT/6qGgUi5ml47uetN+fvA9vrJLweCOCjsTnA1v7cMl+IF8IEg3/RSIVDif6eERdWLuw4Db32cvxhb6KNQHhV9O4QHrgtowOfmLoYnHDppubHJNfpcsbT
 h5aH4/ph
 W7R3IIh+JNYjhhJJHSG4eeq+AbvXM2fY5/vmzGXhj71VDoYPM5rwp6nddiVJmBGMXSp3+3svYhLZsu/C6hwZUgfOKH935F+3eHmt56AiZDQ6X0cK/C3wTvebGPJSbbPvYN4fb+lPdQ1ua+K+sqoU6XV+zM9i2XxKzP45cP2+AqlCg9s8k/7RvvB0w5EgHGwHqBiXIobcZktQD5HSdpHYB6GApR3Vwpa68M2F1lAMl63qenyJIsm4wSxcJSChMZeiEoyzZ7MPBEDm2wNSGN1/t0wYcBkJ8O2UaC3Aa2tewYC1NwHazEbBrxEH3+ank5hywVbla8kUVLD//3c8h1yr3zKSCQ/AUfSmIPiR9enQYXyoxQXeldhjk8zso6jJJZ5g0Bu2CQ9k8iCttfaUIicSARWedXHbjM7bIGuzh/MhjQbPNldarN+5m8F6KWNN4hTmFV4olWueLWWQjOFSkP2lrgvdpBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 11:23=E2=80=AFAM Oliver Mangold <oliver.mangold@pm.m=
e> wrote:
>
> Ah, yes, rustfmt must I done that, and I missed it. Will fix.

Strange -- if you noticed a case where `rustfmt` wasn't idempotent,
please let us (and upstream) know about it.

> Not sure what you mean by fictional function. Do you mean a non-existent
> function? We want to compile this code as a unit test.

Typically that means either using a (hidden on rendering) function
that wraps the code and returns a `Result` or directly a doctest that
returns one (better, when applicable). Please check other tests for
lines like

    /// # Ok::<(), Error>(())

I hope that helps!

Cheers,
Miguel


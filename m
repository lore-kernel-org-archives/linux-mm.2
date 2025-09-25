Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6306CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F014F8E0002; Thu, 25 Sep 2025 13:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8508E0001; Thu, 25 Sep 2025 13:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15E38E0002; Thu, 25 Sep 2025 13:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEF9F8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:54:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58E5C13B0F2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:54:44 +0000 (UTC)
X-FDA: 83928522888.23.BE9094A
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 789F81C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:54:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=15NUvkiY;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758822882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jz/FU9gMOI1RQz/pPYAELxAXstJ4fI13ftJQ5KfyUQI=;
	b=tTrkxrIgExsru1q0PU1yOgwHrbQ5EO7bovT25dbXPNESNlEdCiVljWIsr4mcPbwQYmG4yn
	iE49qDKUG73fYphx8PxDDBNMtAghi8xSUKZexMTQ4wadF1DIUJbqsJ4E86rJ5t/+uKRcRn
	FDqNpX1MxwJ/BGvdexCw1jKH2/PZjyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758822882; a=rsa-sha256;
	cv=none;
	b=UC6W/ylnRmrz+9K7YSXuNul+PPtYOxOO+S2gOZbiS/5FfX8klUfPpHSgl2mOSuycdetq7z
	8ni+Tr2IPBpJj08BaFvh5Bh8p+sHX8pCBEPZ/xyKUt2giniRsYF94eP0tHFt8UeW1pcEyl
	2HJjRQBIXyEH57ZB/1xs+n+VTE1cedk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=15NUvkiY;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso1272696f8f.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758822881; x=1759427681; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jz/FU9gMOI1RQz/pPYAELxAXstJ4fI13ftJQ5KfyUQI=;
        b=15NUvkiY6K1zSL91M5LJFV6cfiSoiO3aiZ2S6DyPtjp1Q+qeymUV8wNgp3v3KYYDdM
         P38HG3G1a4axIEA7WxxC2sPsImypOWc0UGUt+PBzuXnRxs6VIj9OWTGiYHGeE4pG5CFg
         CIIkDOyM2CEolM3DmjzYB13aLJRJSWgCoZj6MAUudfxX+B8wvQmKtygLSu70Dbv15GLy
         YrcpeBdt7W5RwoZpc1/3xJ7CHrTcx9z/aaAloa9utJ0GNEgnj8W3ytkG/cWZgjF/ftfU
         KGhlyuZV8Ab2lkRuEhiJIvpiIKuFqNSJTX4EQG3AbyMAS3ZFr4ago+++PdX9m/cwoYtx
         9+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758822881; x=1759427681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jz/FU9gMOI1RQz/pPYAELxAXstJ4fI13ftJQ5KfyUQI=;
        b=Z9NWa0K7ozbWBWKq7FJj5TXqTxR2thvrcBGdAI8Wl9XPxhl2gohCo3TBJRBzmVTfNC
         4qGVMm/WSLtVlC/PVj3iBiUQbuQ00b9VloK8ot1dPwJb06vC/7MqMKqWl/j0n9qnxJ5g
         BjRymPw82ZKIBa53gzfyicJqswAYaDBeLygEXzZ44rQNLrxx62CwIAG5RfgnkFA7oK4f
         FJhB+/LLkf6DjLPSCglaZH7FTyNEfdliR26zcLCeCqOj/oJy6fWIKw8lzVNh0Tt3mUOC
         XFsSojr+Pcz1wwrIEGH7eIUpeAiu0MF5TpLhN8vRJDq56ruIT9KhXve57nymrHe3rjUZ
         uf2g==
X-Forwarded-Encrypted: i=1; AJvYcCWk8P8YOIZFK2ngDq9s/V/wfLir8C7n8umdKSpD6FgmMdQ3jX98eF9v+qyC4urB75g95gcTWAwyZQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4HEIiF2tYPRQ+15ZT9fstUbnmGfHMr9xZeZaEFXuPrGCDuvlm
	zdazV/H3PhqB9+YLqyC40nbA1698PKViFpOKeITQjhgapYM/OgpDOThZqM0xvKgrDGhQhjOyjf6
	i9x2QpOwY6IR3XpP72VcJtyEOTUTh65dFFViA5wdr
X-Gm-Gg: ASbGncuIMQAR1geXcHdhv+oI9yQRO0mRROG921WQh0pi9AK949C7IYPmV4Z3x3/R10X
	sqqHy96MgvQHOToA2SFQGQPVhCRIQtrvZ46UiW8Ud/LkVhr+mXb4AJW7WkisdswFYSlaeLYaQ1B
	xe4zTAAMv0S30xGyRPlgK2UBHn7KAtXNWEYxeEfzli3kPr38w42EvMVVX9KspXqB+2qVP0/vdLf
	qy1iaLn3sHlfUJ9VoFAZdpdqg==
X-Google-Smtp-Source: AGHT+IFzhjepmcnkySqZnqtGL/digFIArYndMvrBK8eZnF0PUW11M75uUihTaOx6kNBLQ87MKzuyVbx9HY7bWhwTHhk=
X-Received: by 2002:a05:6000:22c7:b0:3fd:bf1d:15ac with SMTP id
 ffacd0b85a97d-40e43b08da3mr4411702f8f.20.1758822880702; Thu, 25 Sep 2025
 10:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250924193643.4001-1-git@elijahs.space> <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
In-Reply-To: <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 25 Sep 2025 19:54:27 +0200
X-Gm-Features: AS18NWBiws6t4fAdWzQ-PgXG_fzqdadithN1M-LZqvce_KX7s1jnm83BsVbdFZg
Message-ID: <CAH5fLgiRFMyXkcx-CngRQOdYuJMkoTdXTOjGsdTYizvApArrmw@mail.gmail.com>
Subject: Re: [PATCH] rust: slab: add basic slab module
To: Danilo Krummrich <dakr@kernel.org>
Cc: Elijah Wright <git@elijahs.space>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ymbaqtshq6fuzhwszapra6jmxmfmwx6c
X-Rspam-User: 
X-Rspamd-Queue-Id: 789F81C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758822882-846070
X-HE-Meta: U2FsdGVkX19YFoEiSIwOA0V1hTKccwG+24iayAyI0bseie+QrmW1TuNOvSbSM2TcKOdTXvQEv8FDB1wxOf9V9EPV1ObrVnWBMKewtWclrv7sZLgG68Cy1UR7sQbikwy6hF6RineKPec5WVZExLUfp+C7cBSxLYk6OhmP3Mdos78K47RiO23cjYlHL3Cy8nSgt4/6LvtrU4jlTxnZS/9MTmJeHOqV4gsIxgIhLtA8wfyG3PJ6vcmWDUjuejB6r3BDLFEIDsNv2JRCPZuwQkhqhDZFykdaTijn8oyRTgz4haSBvBnBOjqLDFLwhUQafM/MaUJ4+5ILtGV9rlBmGpJQmG80CAvG0y9A1aVT/wVfHiI4f+pBCsTFCzr0gRhwO9iTRe7chq5cukdN03MihL8fqgL6UDh1gFtCgvVflDJ+977TOtYwe5/276poDGEENyTXiOqiT1wg1d0hvUAXA6b6XogA7uSiWP3ELAHpVrKJRgM6qGh4YXL8Xlwc9HIkZoqVOMSuVAMvmbJQmE0DA9ucDSWu6JUzoPYZHAqQr860+YrwXdFmh58ed8kXoz72aECP0oH99day/HAjRBga4QhKRWtyhGN4gMrtn+VYe1yLVzhnS0JSFXCsgA1pORUhkj1jusziR52Rtx5xD0hrvNTqXmh4KwDfZY/DDEcjyEUmIrxZfbPIhzNOrJMrOhuS2PiHfn5Xckj96BkH5TONaIcLspfVaWowOzkXdqOc/5rCVHTZNIcC9p9lVtLZ8YEcKfFVGO9KsdHNLXMwRvnnY6jq/QGtBMrVgiGfM41D6P8BtshVPR0RXRuQTyTamkhG89aPdmqhIJhKVWYLN60aJApPA+fdkjL/68QRt7DGw9e/nIqRsPz0gToofnpo/8OmL/+OVgg+OgKuxG/cSvDr6EktdRuOocYL2siFd/5+aT1y4Rb4hf+cORT9Y53Cq/U+ktWOAlXP5qGAg4RJf8+mM1g
 fKddqV6T
 ALbONStL5YHer6rWtx/RKRHiV5VeH5YEfPEJYDwlkN6gPM0jzRqcSJTzG1G4M9OCDLNdY6l503bDm8o+eukxKNC0lLdGamM6y5yhQiWsxG2uyAGpmGT9cOkonbgGAnHsMLXiwK+SLKB3jzbbzk8p8kXxTGA/gqoXPqr3klkqqeLc+Ef1EnTso9JzMAht2Xk1zvWdZSDf372QJYFrBAXLNu1dENJZ6CHQLi1NgPTgF59eD90V2m5HVjyM4juYI15lOX05InXTrHuy+SDsQGLdJ+T31d8mA7nXpVQkX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 11:54=E2=80=AFAM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>   (3) Implement a macro to generate a custom KmemCache Allocator trait
>       implementation for every KmemCache instance with a static lifetime.
>
>       This makes KmemCache technically equivalent to the other allocators=
, such
>       as Kmalloc, etc. but obviously has the downside that the KmemCache =
might
>       live much longer than required.
>
>       Technically, most KmemCache instances live for the whole module lif=
etime,
>       so it might be fine though.
>
>       (This is what I think Alice proposed.)

Yes, this is what I proposed. Most kmemcaches live for the duration of
the module, so it's no issue if they are global.

Alice


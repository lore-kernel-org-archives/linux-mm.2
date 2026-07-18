Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0244C4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 21:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5A46B007B; Sat, 18 Jul 2026 17:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F7E6B0088; Sat, 18 Jul 2026 17:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F806B008A; Sat, 18 Jul 2026 17:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31686B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 17:17:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 624D11A0464
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 21:17:06 +0000 (UTC)
X-FDA: 85003157652.26.EE2FF8C
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8516B20006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 21:17:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uz15IP0o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of burak.emir@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=burak.emir@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784409424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+3x11ZcqtE9a/DE9C4Zw2ioxu64CvrijxbkRIHuMcA=;
	b=UErwueLnPI3xQ/6AGv39pHTQYIW8lHBLngAANoHKnWr+j1ohjlJKXagt3eEyjWsLXgI2RP
	v+pJIdV6jAvn/S99qRSbDHR7s3RERA+WowIhzAodjbkZBH6EPYKwQH34E87eI0uevLmw5x
	t0JH1tssXdFFTsoBKHAY0IS3p9SwTx0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uz15IP0o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of burak.emir@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=burak.emir@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784409424;
	b=mseKt9xTsFIceSIuJMp7xOV2mM2+roNaU6h5bUx9vbZcgnfYZTbI2GBPDJFYvBDK9cg0JX
	ZYISGg5Mj0XTPoPFyzBNfDtlXqryKGpEOCkri7YfzaLFW/yIlPn4D7wbM3zNntkkVZ4/YQ
	mv4D/xxL5Qbz+ZQU/Gn5Jww6siYdKTg=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca12086c06eso7398868a12.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:17:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784409423; cv=none;
        d=google.com; s=arc-20260327;
        b=ON5sg+mvhXmRJr2ITcEfvv5k5VkTRtd3zSJSJNCgp+VVXRnWZBBntzMsmXi/WIsK67
         izUwrPd/Z7pczwLDDdSh2ghqlGOCZgEhSmYOifLwZJBJ34PUy/6QeMy60hsJY8u79TGL
         SpgT04NH7slXTqJHik22kx0Kxi9VJ49BKeIs3W55bsscgKBikCRwEQdVXLE8Wpf3nbKf
         BJGork3Wks9VnEckPJsE+ppcxqqgaG8mo5TbT7BL4U/MIpFF9lVTaJf6HK5Zza2MW4NK
         jPl1zJqpEWKQlRu0xTWLib/RPw3rSrHDscnyuN3rLIEMphSPUZ4iXjfN3p0fbDRtvHZz
         0d/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b+3x11ZcqtE9a/DE9C4Zw2ioxu64CvrijxbkRIHuMcA=;
        fh=KAG3qZlPTHI5ACK83KYyfDSUuV8Ld8OZNSQ2pDzDSP4=;
        b=VVO5vyjR6+GszXQ3GSsxGykhQh5fvbOVPFSGQPjEAV+v95P65fpD5g6AVQQPGWO8d9
         znn+lCtfzGvB5dcYTwX4BXiJH6HYNipd5VWkMSk+fPyzlfokSiGkCfG0RUNbcfCWC8TD
         7c7bGa2FRaexBFy8RDj0q425DmclblB/hxPgBJypf54kL/EK13UvSs9XLleRG5kiB4uA
         PEr7C2hPwjED+Ck2Ok7pyyHyZRibmGaxdNK3lRuWvkq+Et+oGa7zfiI/pak/Sh8mMbqb
         DS7/6tGVgeKG1tbPiINGEwLKPYjs6t1v8H0RwWPqoljUkAO455AvtiHu+KwSW0ypn6v7
         DiVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784409423; x=1785014223; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b+3x11ZcqtE9a/DE9C4Zw2ioxu64CvrijxbkRIHuMcA=;
        b=Uz15IP0o6jX2wSAWtXuB4gKOyDOwsHgtagBWNUxshwY3bsaCnKqzccGmMMGimcvc34
         y8oXJJ566RhwvPOLqu5au+/NZ05vYNkItoKpk9f6bqkI/usdm2CAwcO/jZV0tP1+7A74
         vOSPBTE+CWh4IsVoV0dq99PsTbD0kFjTJ8NMhmxoqv7ZtlxMvw+9eminH+n3jLYkF5J7
         okaD0xjYgBYL3PDnwbC64zdDx4pS7GfaOu/GNBSmIoAYdr/RBkVPcqHlDFBQSDeRpDy4
         sQybsfoMGSaUA24WtCBBS61gCovNqwuYdDMx3RUVMJ01LBEWeO5oUtIQDPPdVg+xQ6HA
         0YPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784409423; x=1785014223;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b+3x11ZcqtE9a/DE9C4Zw2ioxu64CvrijxbkRIHuMcA=;
        b=Odz0M+mjtOddxkyB1gJ8PrnfDHNjT3r/VTzsYMwEhpoQcXyypDZaqc0pplJ+csJcCp
         pClyTVijfSdPxvujk2A6PDOd1yj8atNgTuDy7yXHdf1IJPMf1cYxZpTENd+wdqy1u+8t
         sY5Lj1X0coLGZt8j+yMulIz/gXxR9cJV+EdE+Hwy7tU12Zq2WDfxbn7YLlwfpKFE/YBK
         iHx2htDC7x5TwBpr9KUTLBJiwgP+/IvELBHXxvBO4XqT2WyKqu4z3OCmzClfotk0ZeOy
         hyUFyULMCO0kqN4RYZo92unalzEWGQNS7kWyqof9hZajrOYtlzhPqxZQ75tMqoMhh5Kn
         w9lA==
X-Forwarded-Encrypted: i=1; AHgh+RrAU+I0C6o1W4V3WW4aKsero4UfmfZDmGSpZM5Tknpi/D63cLnleOTVz50o2Mnd+akbFfn4gk323Q==@kvack.org
X-Gm-Message-State: AOJu0Yz3RcpAGX/nBO9xoVs1nFyI/oj7M32xCjMH9kPRh1wgqe+JDKDh
	SvNNjW+IxTwu4wAwR2p30WBfB6CkgZ5GMSfjdHbNewyfM0j0oiONp7b7zqMTFTAIlvo0a7FZPw/
	/izlS8Ts/P3DPh7M1jXZf4AUeyd+jHGA=
X-Gm-Gg: AfdE7clu22Pg2vs0yh8Lb5VFhvtaIJDvc1eQGOtSCI+YzdxyMf2YfAVDLYPryDDHJP/
	J5TlFUt6D8Agr2EDFEGNrDw3h/Wtw7EwNSmsUNiQq44/Gqm9BF7/E/kKvW/e0gqCAaDI1xhZp5v
	dUAQt1/fjW3YRe96s/g/HL0L4bWlpsdvHCsxEYa+Tc75W0yiTPmefMEld9WE3bRdJrUw/tYeyKV
	ekPPiY0PlB2VVRq203EIV3ji2jgj95Ia8QQaaUD1D1VFiXq8ga3iQqs5VjTNN1O3r3wlP63vJEJ
	nRYHxcnUBi4pvKmArKtWwUcyvH4aGVQY0yqd94BmuYj1dicQ
X-Received: by 2002:a05:6a20:2583:b0:3b4:605c:2163 with SMTP id
 adf61e73a8af0-3c3ad78de40mr9171821637.4.1784409423135; Sat, 18 Jul 2026
 14:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
In-Reply-To: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
From: Burak Emir <burak.emir@gmail.com>
Date: Sat, 18 Jul 2026 23:16:51 +0200
X-Gm-Features: AUfX_mzD2A7tzRvT0wfJ4sImRRe5a5kmfvx8TKWr-iujwCqAP7VLhO6-tyToFZA
Message-ID: <CABwQupMNO5mdq+nSg-gpMcgatnG0P=XYJN-bH96Jjzs-_b-6BQ@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: encourage using xarray/maple_tree instead
 of id_pool
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Liam R . Howlett" <liam@infradead.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Eliot Courtney <ecourtney@nvidia.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Hubbard <jhubbard@nvidia.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Carlos Llamas <cmllamas@google.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Danilo Krummrich <dakr@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Lorenzo Stoakes <ljs@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8516B20006
X-Stat-Signature: q1om9puoihh5rb6bpimeayekai7gt997
X-Rspam-User: 
X-HE-Tag: 1784409424-899370
X-HE-Meta: U2FsdGVkX1+m+0pfozrhDzvQPaqQowKmd+KyQiKaiyOypwQQvkw7OShfTOn5y0xGxzkpDWpCQd/lVQzYDLvlrdSwYXJXTaHr8UKRtANfQvjoVNURtBo2YYlv/DrHQXFutiPchfUwJzaSXOeho8O604Hmf5qiBPnyKzRhAqyJiwJQfWJVRf4RnJqI5ytk1YMbCmzPPtWItlkILhMp6hSxVnj7HASe7jyDLi1sMpqHKpx2ogM+wtKRDyx73bA8fTWGX4GgGmZHveqUFsg+KeJRsaOQ96vqVZRInD9Ymbi78vCPx7GNT93ErJUXDXYK2Q5ES/Bx3zwoLPWfG74TrzWLcMeJVTXujlJDWz6ItJQeJ1MKBYC7FZ9Q0/GEIwbJg/ZdGZVY2CA3GrOmWyaWWLMbWC96tlh53W8Z8Sq1Cx4525pYPd1GKuq+l/wDbUUuUuVJPlORCAqdSZHN12MZ64kd/Fn4zUFxJlvuPMLK5GC+Qk6xBab1Q2ct7TmqZJhq6EgnekQNHvBQOhpxnVrRxPoHdaNhdNW2L0kvIi2b5oD8rRvlyDnNP7nsT7xoLhnZbZaulo6LHq29wq4+27cCw0WnPbs56xue2kaQ/oMjU8DJf5kl0mfkBReuqCQUKaE+T3sszisLkr3TKihPBZ+KiL7SX3qQQMS9CqrLR11+NCHcyslMhN1Rgi6+ZQO3LiHKNWQfGjO39el6dfWLTkGdnRO6AYsT7z61+jHyXJnwxtAJJTegTXaDlovwfi7gQ0gSm6A1MoWdcUlULE+8Ellta3Vd3QzqwU4t6+8GHnmbNaOgmCiuz1kTso3jAucbe+S3JPTROfoNK+s2KlF5VQDSAxH4dg+fW50hAxS2lcAjOIGJms2HZCm9EfV9cTqVgu25+3pLMeMjrjKoaaFdpLuPjq0tcsSARyobXtc9bctz2G8xzTip2hNk5XwpIbnFFQBc0938Qp1bUIGvn+eCnXlMsoR
 fYCP7TV+
 3qtxOSQ5XDKVYUxtJAAlaPBy/iqkGF8NJ40jml6w4cIbcTDu7urtpxHmPN2xAxrZO7W0jEL8P5u3w1Sp5NZfr1mKBwNKnWECvg+miG/UZpBdg6Up6JWGZayCYhZT5SxTPCurLZtuhoV1nW8i2YXgZsXKkJuDRuceI6cf4uPZJR3RUXSI6GWVU8hMw9bfS0ZIJku2QyZSeTIKyj3KwhXCl7m9gh5eTUAH94zg6kw6VoEqqjLATjcTj9DjMe3Yl348ahhnneaB9QEmVC/nF5FF+CJss0jcsU/PKZCJw27XeO76VVTD/X3s2Kohqx1EcV9zL0ywnE9yvfG04ZjcWztBIh+ruNot8OCQCh7PIw6I853cIX+YCYzQzoZnk7U12NOAwlCICK8mejz+GA8N70x9CqkjJAl/ct/OfOgqvsOLkeGfRY/BFGphgq98QhJ4LfgQx1y9F9zexclZMnQwTfBJ474tBGop9dsSQ6ZQRlu0P8nbi/n7GdjD/xfQJFgLyBEVs3baY/2WCB+EPbcA6M2svPRRV2uPp98xFpaSgRs9E3nzuCwU/pY8/IqIJoAI5xKIL0kJDwQTZxjPI7Eo/k4cciZWK7pyAKwzIyHYBYphhDEGKgW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 3:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> The id_pool.rs file was added for use in the Binder driver, which is
> using a bitmap rather than the normal IDR implementation due its
> specialized needs and performance/spinlock requirements. However, its
> current name as kernel::id_pool encourages using it over other IDR
> solutions.
>
> To discourage choosing this pool when you don't need it, move it to
> kernel::bitmap and add a comment recommending the xarray or maple tree
> for generic IDR use-cases.
>
> Please see the below links for the discussion that prompted moving this
> file.
>
> Link: https://lore.kernel.org/rust-for-linux/2026070334-dollar-hexagram-e=
49c@gregkh/
> Link: https://lore.kernel.org/rust-for-linux/84bc8bd2-e292-4b84-9580-a1b5=
df4c5bdc@nvidia.com/
> Link: https://lore.kernel.org/rust-for-linux/20260711063602.426311-1-ynor=
ov@nvidia.com/
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Burak Emir <burak.emir@gmail.com>

Looks good. I built, ran the tests and checked the rustdoc.

cheers,
Burak


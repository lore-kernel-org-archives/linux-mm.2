Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E5CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD358E01EC; Fri, 15 Aug 2025 09:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4DE8E0003; Fri, 15 Aug 2025 09:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E134F8E01EC; Fri, 15 Aug 2025 09:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0B618E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:51:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55A921D9CBB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:51:47 +0000 (UTC)
X-FDA: 83779129854.14.AEFF3E4
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7700DC0017
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:51:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zSb+9UiY;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755265905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=093IlVQTdAFvs60Lglv1mh61RWoRsNADFmPT6VwOqcw=;
	b=bXjYEdZMGXNaE2EH56axIw//NXEPKURU8FtzX3tEJTXRocnhKdCw+/JuxDh35p2t5c05EG
	gks5RZiUJ/aerCxJhYB/Vkq/Tuds8hATaDP7WXVpdhO6bP1P16wvWsSIxIUkVwym1mbsR/
	8/IlxGceTkSeLtfwJ2v9qcFJQuICYf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755265905; a=rsa-sha256;
	cv=none;
	b=WTSlgNi0GdGH8d2fbF5A/iy60+lKz1EUL7HpUpFyffogoMF3xQNkj3v4fJdxw3BVObUeIn
	LENniJNCLI4XIzTy1ZhRqbatqWUN4rPnGoaucVc8OoMDGqIPqt2zdDViRPBO60H/Kz7FtK
	MlsgRAN3NorwuOgV7N1fnl+r+MsbGiA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zSb+9UiY;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b00f23eso10839625e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755265904; x=1755870704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=093IlVQTdAFvs60Lglv1mh61RWoRsNADFmPT6VwOqcw=;
        b=zSb+9UiYK0+ViaKW9WYhPUS+IYB4a0H8oWdwmjKHqcs3CrehpACYu7m8S/fCR7zQ6V
         K++xh9nbgOFBj/31+I6nIAVtECEGqucATin4Wju/w57uvc317YCRGIAsMuuYzgR0gF3d
         3jczlAZuAof83TS5lf5DrKZgp8zPNmY4b1YpVmn0xWY+cmvVGN3KnjvsKCSfjN1T3gZE
         Ie1VG8hPTfHIWU0G11Y0IbYzYjcwMA5oxo6CCdmutaAhUw7j6kYfCUoc8koPdVqz1RdV
         uH5rWBl+L9mH1XfXNgY0RGvaQtYmuAHJZAGQd6m33QKBLx1Wme9CyXAqzQCTOV1z5du6
         yX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755265904; x=1755870704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=093IlVQTdAFvs60Lglv1mh61RWoRsNADFmPT6VwOqcw=;
        b=ind0CzmhNX6XK6FV2CT9/DydeVNrS8/MbrEXbqIwYHQdV9FVSNCXIvGCrts7AcoDLY
         i2Rr1rHyu4nJ9YWuVqK/BHDjDsiUG8HFYidLyNmYwchApwrs45GUXj1O/ZnAI9h8bc2O
         w0WmrB7etcrMtllFl71i1xFBzaULnVukgA+n5fJmNd8RJz7aZpPwNvvnQlI+rIPBP1ha
         v5csBPyFapVujgHrBjZmCe4eBRH8lXZZinhiA3+mBkF0LnXvluVypngVQDmBS8Hcz8si
         lA1Ub5ZVTJJFsXYXdEpoANFRdt1M0ygMNARP77//VhsVsspc/NajzwMcliT206RqviwO
         cmow==
X-Forwarded-Encrypted: i=1; AJvYcCV1QXffLgKULIG2PlTrC5N4QoVfhpjK5BC+AZ7FnaudfaZ5sgy/zMFXs2kADgfLmiEnKtyv7m6tRA==@kvack.org
X-Gm-Message-State: AOJu0Yzial6j20yg5qm27dIXYPiCQmpG/2iSG23x5Z0JjU8ips1iQ0qX
	JSda/zZ6cUWmymppXj/DGWmAs6hew2pUJWopYzKAhY+k2Rd0xHmMV2eRg7p4vJBME+ssYgjWpJn
	aWpAsnp4risGGGMlqazltJ/Q9UVTrXmo1U3QHMAV4
X-Gm-Gg: ASbGnctP9RFhotQeaFIRwCQQaJfxKVSuTyyeb2QDuJdlMWBTrg+Z68E3SThRyhOL77r
	UGykOsmur7pWiT4r9gVXMZnLzmlfVh/ynQNkIUjsaZOcR49eeX+JAAHQnyBli+FSAHL7ge1zAz7
	8hHx1524DOTx1AN3uM6O5Le4wNzm0X2Wm8oIt6ydOx4OQqQVhUEvGyrTvXmdL7lbtA4/LhRD1Gf
	Qd4nowUDWZ7FJA/kdx1qH3PiN7Vzf7HvTrzTcSvYH2WHVdpYAoHhtU=
X-Google-Smtp-Source: AGHT+IFv6jZ3CYzc8+DB8tcb3iOZ0eSeAMRULpcmDGXTdj1HKyqd8QladLBnI4IfXS+FlzQLbMsVXltn+AO6gJPqM/U=
X-Received: by 2002:a05:6000:2481:b0:3b5:f93a:bcc with SMTP id
 ffacd0b85a97d-3bb68a17993mr1756183f8f.35.1755265903498; Fri, 15 Aug 2025
 06:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250716091158.812860-1-shankari.ak0208@gmail.com>
In-Reply-To: <20250716091158.812860-1-shankari.ak0208@gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 15 Aug 2025 15:51:31 +0200
X-Gm-Features: Ac12FXzFwpjZfyVT_iQ3XLEvKiGOnwXqbtcp9YGn_MuwLv_LAEO4d7-XhWxUDaA
Message-ID: <CAH5fLgiUfZG4e0k6ajkkKo+iaidWHu4dTRfBbgm4Y_CQPGLHpg@mail.gmail.com>
Subject: Re: [PATCH 3/7] rust: mm: update ARef and AlwaysRefCounted imports
 from sync::aref
To: Shankari Anand <shankari.ak0208@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7700DC0017
X-Stat-Signature: b5zpmqjipbhm9j8am75cte6wbb78uaxo
X-HE-Tag: 1755265905-276874
X-HE-Meta: U2FsdGVkX1+4goZ72EPhTDCWTyawuF4sjgL8ZtCjPdAxrUT/JygveELrqd1hcpysV+gZ09vYtGn2/pyaueOXPP6ZLdRsHNTvL4P29Ry4SFvgtzmn7zfzJgke0miEt7F2P6b91dfPCqhE17lJGblgdb5q9Yl+JiiL8enlpV7vCoiStWKcKxIp9+JgEq1+pVvap+EYKKEVlT50J+BBc7PgQp83qIRu0xslUkOSQw+t7qpOqh7X5f9YtvVL74TTUdKeriHp3QY9ZUpm8jdKrbpxCJnRD/6oxzeaSMxyZOe06BDW88YvO81wVMoe8CYbvRIZOUAmgvXcL7IKM6YsMRZbgxiQ6If95pv8u4irU2wjGgOxyC1FLL+l5wrPqZXqlO7VBDKHNOSd8tkjjYREq98gs7i5xKM33A0PCF1RB247hcBBPs5s/gbfJdSuMYtOsDeWX5s7Ji5EesCLt5xou82+SmrqA/M8f8oMAKPOp7Jhz8Zpq/yj1TnPpeEP5K6kgSiHpWFYK2oSHUyt1eyg0hw9E6rc6F0YG7wNb2dT2ccNU6on7+hwzf5Ld8ozqxpDXXlZXKPEoiVap1+DfeYxAnNA0iO6mW/BEZdv+DS47vii4uRX9t0sQcSZifGYKxqLIlWbRu/9sr8/UUDA05vIMkKsL/21lKbTYP8BQ7eiOjXoyqc25rzO2wXllLA0w8E8/Nrz7hCqLQXIx4DpHhFxX4DCFZiWnoNM8PbgC37ZsCfNSzcfCyHjD6PRCRNmrdKH+JSaD87KoO4evXOY1IvWI8kpNieWMhKKZHJNXRUNFlG4yJHejHcgwHR1kdAzLqaOWVlGYoipxHu5JQ/ywBF4wLkPBfQZd6Sc/IEunjz5jsLC4hF9kGj54TsnOX3FNse8ZTK8ZOztIfEaSq5p2zNwETEY1JOmJ2HW5IaKPmL/5uXjqbSfDMhm3Duh+6zJGgvM14rNWVvLc1xervxehU38Wwf
 e9mSH/WZ
 oVqLCMhirYT0G8iopAHm+WkNuUfvfSba85Fo8HH21HnAkCGHiluHz560BpuLdxMMQlfI3+UbW3J0xJUbkZvlS5NuhdydUvlJY0nzhGhcq7aM8LZSOCMaRW4uyKK4TmVMvVurLT3N9/Y4/jGee8WX6KZy2iGaGstsqH7Ocw3+aN9ZEwItxIS+MB9sAZS+WGcPbL21SSCEe1PNCXTlFNDGEJRWrYJccwTgZULofw/xJO7p3mVVxNe+caHr7Iy0HcZSZXaMNs3vwlJ0SUq77NgZNFfZIP/UFYypOKo+1cUBiPv+Os5D2rtLt/4UiY4RrI133KXaahkw7o3Zz5/cGAVI3SkJD+pRuEsGMZqu5tJ/dKXcAbRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 16, 2025 at 11:16=E2=80=AFAM Shankari Anand
<shankari.ak0208@gmail.com> wrote:
>
> Update call sites in the mm subsystem to import `ARef` and
> `AlwaysRefCounted` from `sync::aref` instead of `types`.
>
> This aligns with the ongoing effort to move `ARef` and
> `AlwaysRefCounted` to sync.
>
> Suggested-by: Benno Lossin <lossin@kernel.org>
> Link: https://github.com/Rust-for-Linux/linux/issues/1173
> Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>

Andrew, would you be able to pick up this patch? Thanks!

Acked-by: Alice Ryhl <aliceryhl@google.com>

> It part of a subsystem-wise split series, as suggested in:
> https://lore.kernel.org/rust-for-linux/CANiq72=3DNSRMV_6UxXVgkebmWmbgN4i=
=3DsfRszr-G+x3W5A4DYOg@mail.gmail.com/T/#u
> This split series is intended to ease review and subsystem-level maintena=
nce.
>
> The original moving patch is here:
> https://lore.kernel.org/rust-for-linux/20250625111133.698481-1-shankari.a=
k0208@gmail.com/
>
> Gradually the re-export from types.rs will be eliminated in the
> future cycle.
> ---
>  rust/kernel/mm.rs             | 3 ++-
>  rust/kernel/mm/mmput_async.rs | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 43f525c0d16c..4764d7b68f2a 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -13,7 +13,8 @@
>
>  use crate::{
>      bindings,
> -    types::{ARef, AlwaysRefCounted, NotThreadSafe, Opaque},
> +    sync::aref::{ARef, AlwaysRefCounted},
> +    types::{NotThreadSafe, Opaque},
>  };
>  use core::{ops::Deref, ptr::NonNull};
>
> diff --git a/rust/kernel/mm/mmput_async.rs b/rust/kernel/mm/mmput_async.r=
s
> index 9289e05f7a67..b8d2f051225c 100644
> --- a/rust/kernel/mm/mmput_async.rs
> +++ b/rust/kernel/mm/mmput_async.rs
> @@ -10,7 +10,7 @@
>  use crate::{
>      bindings,
>      mm::MmWithUser,
> -    types::{ARef, AlwaysRefCounted},
> +    sync::aref::{ARef, AlwaysRefCounted},
>  };
>  use core::{ops::Deref, ptr::NonNull};
>
> --
> 2.34.1
>


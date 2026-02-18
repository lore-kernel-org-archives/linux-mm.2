Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6BAE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 16:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82B96B0088; Wed, 18 Feb 2026 11:21:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30906B0089; Wed, 18 Feb 2026 11:21:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D125E6B008A; Wed, 18 Feb 2026 11:21:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDEC86B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:21:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59F291A01B6
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:21:43 +0000 (UTC)
X-FDA: 84458093286.05.30A70A7
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5492F4000E
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:21:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qORQXBG7;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771431701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCb7YiNC9EbJODNenpr0byXl5zVWMU3mhtJ8bdZBpH4=;
	b=eRZFc55GCztxduW7DAEFFqCmfIrFef8cvRSiBWCuJOMJjLyxfzpC1dUsyC7GcTB52DLLJj
	MLEqAfN0o1WWA5ct16XNZ5dHN/ZY8F8/+vkJh5wqtfut4izZb7bw2+wSZS6i9Fk+PChCRU
	ZzMybKcACXzXDYDvDbdf+zsR1onUnnc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771431701; a=rsa-sha256;
	cv=pass;
	b=pn1Uxh4MsSz0dgnyuP1QVZt5QCJ5ipo0dmTlJSOtHmJPbR5riydER4mxzg5pta2ECr51YC
	vuTNauaOlRwArBrwrAPTGH0LTh+O7XSBIJkY5fo/Goi8wCkv6ryHDU+GHXBNHbswOmPPs3
	UkybaZhTrOU6muLt6EL5/y9swszHfpU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qORQXBG7;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65a3a1740e7so12452a12.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:21:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771431700; cv=none;
        d=google.com; s=arc-20240605;
        b=kHUgoOJC6ZaP5/Cn7/Su/f5S2KnkvAyP/PWamA16Qj7R4dMYKohLSPp3+TPf9JIra8
         CHUb8vJEXsukV6AlxEoSSq1vpmn5i4lw3fchm6ZRudi3rBgT0nv8vml0YTYTHerWD1Id
         Dt29rQUFxkrX9tqz3EDguz8O71xlK49OTqnIDlNgVx5GQA9fk3ci0nZZX90ut0d/4jLw
         cBAS6r+C0XAMxN548tfUN5fhYXjqBm5CVe7wXm2uWU9FgFCLTs7hhIV5iZxxPSh1vw7I
         zT6bg9C1ZGMo4U7T7MhWh2VWSsni35c/ZlyRG4Ukb09Ygez307Glsk1/bt0t6HtlqTWY
         +CEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zCb7YiNC9EbJODNenpr0byXl5zVWMU3mhtJ8bdZBpH4=;
        fh=o+wa6lqFVPhwQlkh8j78exrnoVKPxE7BGHSVDHCjKgo=;
        b=I+ssRPTjsuY0AzedDNgvN7a0yHGJVebtnE+j73bbw0bLB8QBoFU2CsPOSI1MgbZ9G5
         HQ8BFXz4eAMVR4SUgomnFQl6Jp9aU3lou/aN3sXKl0Xels9ddw3Y9zH1VeEVRWBL7Pnn
         3ZpHymyMylHVxZI2sUZfXJ172aI1wUdSHNx61nHoCz9iRKds2TfBBdpnfMy7ekOZzt1T
         1P9HWTqF9TCjYfyjDfw15aJu8nWStTVIeGWQNCbV0DIJy5Qrqtf0eC/oPlk776Jh4tEp
         N1hm/5Rk+0Yc7LhTcysOc0BG74zI7bysfEKc29V5nX9HNRSMQwJNeij5npnBMD+7PmLv
         g8FA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771431700; x=1772036500; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCb7YiNC9EbJODNenpr0byXl5zVWMU3mhtJ8bdZBpH4=;
        b=qORQXBG7DjAL1TZ59DIkH2Df0+V0MTo0Y/l43GJhIjgXRmpjRIATSmx/PQ4nNYlDeR
         156QSbyLp9oZSgm0m+A7ireyvbu6DB0v215vVHe0LWtViphSBcLrw4tGr8S0kj2qenr9
         k06pnzFvTH2ltRu8N23oF+kE5OAKCOZ5QdKS1kiyvS41pLYKvRRJf6ARCckIYmkBV0hb
         TA9+/I61+Hi7Mo+XVuTdk3PIL2HlNtmsqsRloB2efAdM7iURpgaLyLBokel3D+lwegzA
         dcJi8uNLBbrthhD05QXJyhZxsLvmlzIXqLlhmzmGkllkkfiSEEvNV+9X05oSRAe1sDCG
         h4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771431700; x=1772036500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zCb7YiNC9EbJODNenpr0byXl5zVWMU3mhtJ8bdZBpH4=;
        b=tNckEno1kEhDOgl36EHl58MR98RuqTWWbE9TCCpb5FmUhmUa4AncZ2LOtO9E1HsH81
         ORAsnOdeUdEZSiM7QVb0yTi7bqF0At+PqZ+yvAG+GgDeXBRRS65hx//awuQhtfQ/q38Q
         Of3vwYs2YBvsp2u8FOO6ucWDG7czgPMuSZV1EDksKBMBQ5mPZbYFH9FHclr1hxOop2NT
         INoqQcr10ca2clexGBhZUofirQcL/5MYLF3btUiB7A6BFBJvC9bYgGDKPRb62p0qgadN
         1XLY1NJjM5vpRKS/FzmZxSmcjInruL+qJaUjnzG9aKdmKCKwmA6FY4nCPHl0iZOFEuDp
         qKJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5cSbD79UhHnweo9ra/BRYMsmpp871A64Sjs59yq2p5ErZHXkBVFpw1yxeE5HtWn2q++7VwMMebQ==@kvack.org
X-Gm-Message-State: AOJu0YyzgCLhifG4Dhty5tmk0mLg4HfNGXlFrzQVAs3XMDZx0niislMq
	+utIVT8tS2QWxwXtTxB+g0IBFIhNKXfmrUWdN85qiuEZ19KhisGVUAJqFRXGqweeWH9d8L+WKNo
	Tm78wdEj5lOxZriqd4g6vZrt98u6E8eCSurbc0vEC
X-Gm-Gg: AZuq6aJxwtMT8nxU+wwOOAXaB8Zg/UHZiZdGhO9GaJLlO9cpFHYKF2fuwdLyXkttPAe
	EEZSdXYlyaeR4BJEIfgFSKS5OJlkvW5+uJuskZR3IvoZQ0Yln0myI3D6lmmljK5m2MfKwNcvZbq
	WpybRq2m4a6ZJgTvUNc76p1ABjc0KgS/ogBmUwG7Ae6LiX3GqN6LodQRy64RegkykxdduZfE2G+
	vENwHrpBZbp3pZF+KsUvnCxxKAWg0LF7KmcxnyBpB7BLiSJVK1/p7Zr74i2SEi6LbDGiVrsYkVn
	5TKKj/QFtRgpAfAqDbvLJfYl/gJdT0X2Kom5
X-Received: by 2002:a05:6402:43ce:b0:65c:1e9a:eaf9 with SMTP id
 4fb4d7f45d1cf-65c78b73dd1mr32034a12.6.1771431699117; Wed, 18 Feb 2026
 08:21:39 -0800 (PST)
MIME-Version: 1.0
References: <20260218-binder-vma-rcu-v1-1-8bd45b2b1183@google.com>
In-Reply-To: <20260218-binder-vma-rcu-v1-1-8bd45b2b1183@google.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 18 Feb 2026 17:21:01 +0100
X-Gm-Features: AaiRm51ZVP5ooWZ_n6gAsTEQdsiNCjUAPCM-PZs3XG2hJOqTY0v5t8E4kpEAp9I
Message-ID: <CAG48ez2v3RoHhOiKYJqBA=UvF+0PnKCZMLiemztTFxNwc4gH=A@mail.gmail.com>
Subject: Re: [PATCH] rust_binder: use lock_vma_under_rcu() in use_page_slow()
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4wzbg5jg8q16u7z1tiu8jc1ue1i8uoep
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5492F4000E
X-HE-Tag: 1771431701-811908
X-HE-Meta: U2FsdGVkX1+J3eYAKE5IcKVLqQiuolZbBawdFjff5uQwuWdS/xhaLqVHZVnL7Ln6Bl6GQE/+CbXeKu3jUvEsNm44ItsCTa48WNv14K8WJX+9T7z3L74XQhQYS6HUaoSFH5uO/rQvHZB1epoo5Aj917QgAv1l2E4VIrRb5SJAMWmSZlP6dk98ZlD38es4y+wac5mTZnzXPwXKTT7EmClRqkUpYfGaE285DNmhU/v5PkNJ6q/pbOwsjYwargGZH7jmH47ZOHKK+mmzT8CPTqq7lA2JateQ2lz0DXyfLtjsIyhTj9PM1ZegZWYqcbLspSQryaA8bpXhpNATE5DejvGfpvT8G8nAJ+ymQk12A8+dwyP3XTTL3hLeHtUjiRtmvwtswVCZW1K4R6wuu9NMVzMGOEuLPPEBX5mthdxhaXmE/Q1TggdLW5ebCqkdcZowSfa2TlkXllk8Fc3NR2A/Ks4aCgKTknmQrUXjwf17nSfI/oPwbkVH24a67A49Ig5SUiSTEn9BIYUPN0thxbEnh61JYmj6sN87FCsVzMCnSUlp93Oq8XZiiYrQw4I4icrSRrpOLw4e2EhtIfJD0SMiQwMe2RNmT3YhFPl6AOJbq+60hE/fXsUoZX0Yu6Ocwwyb2fE0IUtA6qIH/4NFp8F41cDeyuuclQJlvuds+oGDrjeJdwAL0q2/UXc1MViPQvGwBDV/n+nbsjHLgFQv8QZzAPZ7IbOV9+65bMRbVN2JVfitJ9sC092IdHI+dPSG9J0stman+vaLnoZlLpCsSYau/W+I+I6OljUHnIR23pue8zd6aBs6hpYNrs5FCqk8rD9dJje0bz/373fs7N/eGaTnaUYbZG4ymcnGSgNZzrWnfV60vC4O5Tr9UC9t+6lR03+sGchLSkTTQJ4sfZA4wuFZdjyrbzTU3NI1V8eknyunbnkp12qWZUyEGMP/Ym8GtHGUiHeik8MJ788ToyPXxjJK8BZ
 0FhdSEva
 279BAj+0u8oVdg8Hkt81N9IEL4aOEilNqEhQxioykVoaIupO4kl2HJ/qj9gl1h4yG+4gfvXoNNT4B56n63luf1rXBh5VKL+IBNaW5r8iNEJ2QVnY6AqaxV38WgkQ0pWERmHjq4IWNnvaLRwoHzUcftThy2c/vp8oSG+aMC2HhXmCdGqfVNuYfNvoHp/Yq/LSTd+JR7mjIIoZH/PpSO2RUQQbOoGZuk7FmAp53FrCXO7Ev4BML2pTG6lXKeqRVeL0DK/e+XNz4bMScW0iVA4clky+eLpMBu4y1tHGfxeolQb81pBcHUYXxlfkoP+fAIF0STgx6wqAyjuW7278=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 4:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
> There's no reason to lock the whole mm when we are doing operations on
> the vma if we can help it, so to reduce contention, use the
> lock_vma_under_rcu() abstraction.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Jann Horn <jannh@google.com>

> ---
> Depends on:
> https://lore.kernel.org/all/20260218-binder-vma-check-v2-0-60f9d695a990@g=
oogle.com/
> ---
>  drivers/android/binder/page_range.rs | 37 ++++++++++++++++++------------=
------
>  1 file changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binde=
r/page_range.rs
> index 67aae783e8b8b7cf60ecf7e711d5f6f6f5d1dbe3..9dfc154e5dd4e889c4f3aa89e=
5edb89434113e1a 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -435,24 +435,25 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<=
()> {
>          //
>          // Using `mmput_async` avoids this, because then the `mm` cleanu=
p is instead queued to a
>          // workqueue.
> -        check_vma(
> -            MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(=
ESRCH)?)
> -                .mmap_read_lock()
> -                .vma_lookup(vma_addr)
> -                .ok_or(ESRCH)?,
> -            self,
> -        )
> -        .ok_or(ESRCH)?
> -        .vm_insert_page(user_page_addr, &new_page)
> -        .inspect_err(|err| {
> -            pr_warn!(
> -                "Failed to vm_insert_page({}): vma_addr:{} i:{} err:{:?}=
",
> -                user_page_addr,
> -                vma_addr,
> -                i,
> -                err
> -            )
> -        })?;
> +        let mm =3D MmWithUser::into_mmput_async(self.mm.mmget_not_zero()=
.ok_or(ESRCH)?);
> +        {
> +            let vma_read;
> +            let mmap_read;
> +            let vma =3D if let Some(ret) =3D mm.lock_vma_under_rcu(vma_a=
ddr) {
> +                vma_read =3D ret;
> +                check_vma(&vma_read, self)

nit: this might look nicer if the check_vma() calls were moved out of
the two separate branches

> +            } else {
> +                mmap_read =3D mm.mmap_read_lock();
> +                mmap_read
> +                    .vma_lookup(vma_addr)
> +                    .and_then(|vma| check_vma(vma, self))
> +            };
> +
> +            match vma {
> +                Some(vma) =3D> vma.vm_insert_page(user_page_addr, &new_p=
age)?,
> +                None =3D> return Err(ESRCH),
> +            }
> +        }


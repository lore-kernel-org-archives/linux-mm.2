Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443A8C55197
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56FA66B0088; Fri, 20 Feb 2026 05:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550E66B0089; Fri, 20 Feb 2026 05:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F936B008A; Fri, 20 Feb 2026 05:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC706B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:49:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DEE61C564
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:49:21 +0000 (UTC)
X-FDA: 84464513322.26.89FF27B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74DF880016
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:49:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aZgZKXIp;
	spf=pass (imf30.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771584559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ab0aEJOyc1j8sAVck7x1NuXrJJFBzT+zHKOVXAo2rqQ=;
	b=QNPlAT0I6LVzU5zKvYUJKADiiTdIUgt1MVIqFzn6xABt4tETSITrDNlneeSo5GmRksqjWr
	z7zbFF3Rdr41Dj28xh7IGMQ/3J96GnqXBK6Tvb7omIzIREUFRqbPXnig3hCs8oj2Uco/jU
	JbsEbcMPCgG6z0W/cUONj4+mKUOO1v8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aZgZKXIp;
	spf=pass (imf30.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771584559; a=rsa-sha256;
	cv=pass;
	b=TwlzuIheIXQqWlS4BEUllh2wfYqz/9RBypgvOczEhgsfRixR/0Hj6+htinoSEfC5OY3Cvl
	CDpwAjVdEpsJbbwZhTBAUZNhx5USudiHTv5hz7e0yTRAe38HfXN2PqSYNYtA/4ZT1dFWF/
	s5aM6cla9SMUsxo/ayHYaN3rMtWGrOU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371119eacso18002425e9.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:49:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771584558; cv=none;
        d=google.com; s=arc-20240605;
        b=L6TL7EKT/p4mknJmhsDTsTaTX0LFdcAU4KVHiL/t55Hx/CbKvSNAdHB8bqmpU5XOv6
         QgrCNcfhPd/SKZ0+dWuETTHSvupS9WiubcJo42110Vb8nxyAYIQyWC94KJY1q9qsqhNc
         +okvKxgTsiExilDzqdYFnF52ZTD1D5Dy+g2yESgSL3K/oJHiZwrhg1KfOiATzb6j7Cgw
         WiraWyOLPi0R9KhhhZjq5eddnAPNKqzuSG4sKud+DyyK3Jmv5lVJ8rvCR8DeLQ4v7d9T
         NcAJD/H532a7ulTKTlF1aC5PPrI/j3qxtDuET4Y+/Wc9mbY5hPUkVsBtc/D5TM7FgtOL
         Q5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ab0aEJOyc1j8sAVck7x1NuXrJJFBzT+zHKOVXAo2rqQ=;
        fh=2lKXgOZcKrYnqcPsqumITJtYmZArfsT6P477c5YfGPs=;
        b=F9XWdcDjBXAKeTPz/i2wIR66JBleTMaGFkDEhB4FCE6LPYCelYIGj8XMKbZIm4672K
         lQm+z7MSWjDgQ28xRPVUKOTm3672HSu+Ih1Lxn6GWjWezHt7hJuul15O+jikfwE9Mt6F
         pslSwQc9UPDpNxys6VcbVwaX5A6lSn7OPtt2exlIV9UJAAFZGccQQUlh4Sv/I6GApUqS
         V+CmGj1369muocK6D4GkRgSujuqXda/vV1lBBBXQXTDHKZqi4FlLziTEprX5FxeS8eWv
         XfH7XYi3SprDrPLrP5isDK3C3IHT3V47t96YTDGrjNOivSusGmm/CFmS5/DvT7xChx47
         RX0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771584558; x=1772189358; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ab0aEJOyc1j8sAVck7x1NuXrJJFBzT+zHKOVXAo2rqQ=;
        b=aZgZKXIpTtUHgDe+fhjBx5t6RGvgs78q8N0J8oo4fuYtvpFgMfv7wJ1VSt/kgl/9k4
         IjYKCQDb/tBnLLk0V39wQqzj3EAX3EudMyFrLppF91lLM7LSaXsjEZB8ufz3E27DFc7p
         5wWIQXE+rNJCLrxta9iDnqLsgD/CA94V1v3JzrE2mozujbPdm07jzWeUDVDEPFRCgckZ
         RjnemWIG2XjFPKkvG7i/v5xNR6EvANO7GI0e9XlxnSCvEBV6kmKX+Wk5oKDlmcfgZP4B
         9TL1Pk3TtwVIeWZaO8cbh6WniYFPEjKq4M2h8pgFiW6G4ogUw9M/boN2XgThYrhsglGy
         VjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771584558; x=1772189358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ab0aEJOyc1j8sAVck7x1NuXrJJFBzT+zHKOVXAo2rqQ=;
        b=FNs4D/I2vGrdqV6+3Jbwors21Nw5DuUlhrFI3HhLnV0VW0cSS13ocL52nsww8eU/HX
         UHnzk8oDUxIm98iJV2JPcPJ38FyfgAUcCqXXqYzyRISORjx7wdljvTos/5CbEnKOpjFe
         I7HD9iw63mo5/fq5wU72Ozq+RmVwT3y2A5pAZinm5sc9eNhW/HedsiMRvdoF81Ss4YpH
         m/M7cyfmyzwrNR/orpPWm6HA8yMf7wPqNhx21VLL0gIrbujhBthc4fKi/pgTjucSpbkU
         9Xv6NVdRMQIN9t/aUaQSL7DJ0cea+fAIrFmWEVRwzE2XoKeSZJGyBY5JgJL21Cja83IX
         qLUg==
X-Forwarded-Encrypted: i=1; AJvYcCUIczzrcXSLFwCWr39giyylBJklvMxr21kG24RjhD17sriyEtmv3P0yLIjoQ5KA8x9OMvwG/5pIRw==@kvack.org
X-Gm-Message-State: AOJu0YyfrXZ7E/bPlofjaFQBIpd/3lgkv9q1flhQP8um/JdbBfTJdiEz
	GR30RxZoCmP480thHtJm2DgDORypwYcopli3XfD2BJV44VtQZhPhZa74LNYxNkKTp+maDj29aa3
	Q2EZW0J6OObN6IqKVKrZDFo4LwRAFV3OAsTECzJXK
X-Gm-Gg: AZuq6aL9NUrprI1ThjXCCngWZw0X2AK9m0wf7zo3QVdWN6+NsaYZM8uCd0PyCKQKNx6
	nQjSxb+sL1gOorfcS54xsbwSozeBCQTbGl/vTZqQXnEmNfTUFaK3L8MynDmoE3QFI18d4WmrI9I
	UzC4weI/ubaiZ11/IspzcF5JX4NCiS7VEkM2H1LPJOcvK1yjMwEKhePfaLxTtVyl35KmsZGU601
	2AU9tCBBSOl4wk1CTCY4kbZKt9zVms9YVtQy4RN8eu3NXPWxTNlwJLh24y9HhAqv9OL2tjMaxi5
	vgDSYVmJekpswlru1i4kTaRHMT8/MytKsURLxw==
X-Received: by 2002:a05:600c:5289:b0:483:71f7:2782 with SMTP id
 5b1f17b1804b1-48398b0990dmr130223325e9.12.1771584557648; Fri, 20 Feb 2026
 02:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org> <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 20 Feb 2026 11:49:06 +0100
X-Gm-Features: AaiRm51MAhLW1OtRkAHOYwRwshfGarw67yqaE2vYRvgLvB2RCqsl8u_ReojFPGo
Message-ID: <CAH5fLggNQD+TbA7rXVB5w+O+qHcJcYC4u0b3W+mHR2DZiUe4eQ@mail.gmail.com>
Subject: Re: [PATCH v15 9/9] rust: page: add `from_raw()`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 74DF880016
X-Rspamd-Server: rspam02
X-Stat-Signature: 5cmaan3g6tc1irj91wwmcer1h5acb7yh
X-HE-Tag: 1771584559-942613
X-HE-Meta: U2FsdGVkX19fHh5y7Hesqn6B+6kwpmDwCeZlLt7AxlB60aXNyTlk3DxTrOwDQ3qQfS1AvBTG7BKDhQFF0uuFj5Ni6GEq8raqST6J0IyfuKQrFoVs3CxY4wTFyWs0t29RnK/Q8f1jnoV1ecRc+4YnpeYbWkvrTyBbxy6f9XSsAwEhZnjw4p/xbzg7RQhWySZx2cgm7iFfMy25ITTUg1EnuEGzl9XnwtzyMP4SmzouEfEbvsRyUjw/93jHuAixTNp4i9CKYSu5hsWSHXaHPH4wVyB/Si74hM0U59lMC4QhTFUYl0srJ46z8gYkEavkngI5TnK9sBZ2d//OUlwS3ib8veOSRiMMfY89mHkyCtIW5NPGfZjymi3s/QmlIogCxY3KPV9xV7v2KSLOi72UYaToLfIR/vz3FeryaDsPUNqvLCWRIYMmCu1JzpuTv0F1dcZUxaqhXDgFXdP1Eaico7EfshcI13xPvIGf9FLQNiD7ZIpOOf16CK6htPtOMfzpY6Ixvj2d8XTJQ0Pc7vUSUWizOIAQ54mli2ykFsMXOePEqfU9dF+CCsxgKXPKKeGbckfOSGjlgiOTEBgGOFx0EJfRige7vJyXUPyb0exrNZfmh76EZWCbQNc8nwUwpvhPJ/vRek6VHDoDeKJOEugIK9J0VYJoyhc2ZfKNptn+wabQGo5UvMemNGbsuodaDN4ivV2QAR/UMnx4pejpat/IxP9pStK92N/QnN+cZ8/nuXHE7teBg5L/R8bbFelRcb6In4aIhuErV4q8IJKRSoYapHtLeK/MjNTA/cuIxDay13kH2CTNJDHxsm9ikTrF/J9LICw33nFgLTFaAWGoyouT10HIKvlfCtd987Tn0up1ii9r4O+SskDujulkhxLfgWaIHn0uN60155OUh3vs5Eciomcm4ayMKT+VOqMqSkohygyHEXR4XRAQdBo6PoK2boAxe2Duk8ZglAT9k9JRTpFnUvW
 U+pt1JOT
 hpkOJMl9JvHwjptqKbZADdSGO0tMuCE+SH3UjmB5i8HXx+JrN7/2wPx+ufx8OdVyR2ISHMVfJqBGGCeWOcz81cxtTFt1L9k4e+v7jGJN4bgVhlOB6qryxllSlOMITIZmpiXy9l5KCugb1o7ZZQIgzajIYyYGa7fD4gIbMeQ6eZJX3JwsvmbBIFejFMbj35hzA5piFS1kEwHP9mAOpAIVFwUCHf92jqyFP5loO8h6lRZP+0RYIDvctgnXtgGqGFsqs3NeM1n6XAuAAZLJ0scArqwRkuDnxY1+I8jH0ZCNpAaXq0F5ptf/6C84edm1abVt2Ac22ocDvimlJa+BKsFOUk3Dh0sxvy98g7BazdMVeZtw2aNekKCO8WV4xKTYQSV4bilKPnxZN8NnrinZd5NW0lUCUCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Add a method to `Page` that allows construction of an instance from `stru=
ct
> page` pointer.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
> ---
>  rust/kernel/page.rs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 4591b7b01c3d2..803f3e3d76b22 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -191,6 +191,17 @@ pub fn nid(&self) -> i32 {
>          unsafe { bindings::page_to_nid(self.as_ptr()) }
>      }
>
> +    /// Create a `&Page` from a raw `struct page` pointer
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must be valid for use as a reference for the duration of `=
'a`.
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
> +        // SAFETY: By function safety requirements, ptr is not null and =
is
> +        // valid for use as a reference.
> +        unsafe { &*Opaque::cast_from(ptr).cast::<Self>() }

If you're going to do a pointer cast, then keep it simple and just do
&*ptr.cast().

Alice


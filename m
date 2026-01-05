Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4097C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102E56B0161; Mon,  5 Jan 2026 10:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA746B0162; Mon,  5 Jan 2026 10:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BF56B0163; Mon,  5 Jan 2026 10:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF67A6B0161
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:27:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C96289086
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:27:25 +0000 (UTC)
X-FDA: 84298289250.07.82F8999
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D3694000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:27:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fwyqmg9L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767626843; a=rsa-sha256;
	cv=none;
	b=BoBkbBHlmWC8hK8DFsjLYRG1WOKI69bzAhRM5IeZGxARGyRqeKx239qK8eZ+YMGMYzjN3S
	gGFxdhbBpT5/n9v0FZKnQAaWrfp3E8/krZXmzkfADOIZ/A3mztRDcwI/WJJxpk5CpBwLvY
	C9uL2KZNSzGKOvPrY21epyhOuHH+WBI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fwyqmg9L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767626843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kn43i3LzpcaVKx8sZkO5nilSDYZhIbH7gusssvJywO0=;
	b=ARz/gHJHIpus3hSiCz6JXp3AfI/ssBY4MdWrnbv0wgVkg2ZSLs8qLpLHVv1Vnr6kPRlnXL
	sfELc3QKjx5sMoTc0NTsagMVH6USlC8JAyCZH3rokRE628ASalFZRvHCgZWh4tr6UQKulJ
	aFpZo5wjSCqQoHawGkk2RwQoj7utY4Y=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3825ae23d95so449891fa.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 07:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767626841; x=1768231641; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kn43i3LzpcaVKx8sZkO5nilSDYZhIbH7gusssvJywO0=;
        b=Fwyqmg9L6XOBxBUfNEzEAS4ZiiTTDwoAtaWTUxP5pDKf6V+ms0MH013Bl/u46XfGm9
         adTx0IZOuAsjOkoLjOio7t8suXwiIcVEUf3G7ocnkH1ahQdDVJkr7lC2WcL7Y6zyDU9r
         01GqIVGuZCpKlMC7uX3YBvsgBrH7116CnH2WmCFysRiqECO+j+Zvfs5gqvIUDEdhTZPD
         vAkDLxUwIxVyQkPHHsYC8qZlerX6s5PFvl3IbfE5cvoSefidc9gHAiMDR9zev94h1xa9
         B/nrCY7qa0F+DAh4XhBVIPAvSTfMr6zF38c9BrTQPOYBj2pmJhK2eKLla4uF5S+ozZCk
         7ffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767626841; x=1768231641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kn43i3LzpcaVKx8sZkO5nilSDYZhIbH7gusssvJywO0=;
        b=j49bfjmOmu8/0o0ebong5VHcJ7hJsV5o0HRjhlsg8fIeXU+CZi1y0QUhb4wOoV+4bC
         50TKdcxOt+bsZd8e0DJHIju3UyUuPM4n0cDAthrGHmAXDsh1FfF6WQAcAoiy9t4ARSii
         m2TDg2ONTYPUwiWVSzThr0r1RQw1No86kSkyUJJRiRexi4QJoqTSJ/XKnvP0JsjEBu5i
         nq+0oCkhdm4JsZvxCmh4wiVQJ0GGjlUB+A1lPVDNMDGTztMV+ox6sYAxElWT6CWpHPUW
         MtaUHXKk2SYMbbUIGkkYEoFgqScrdbDwVsRynotqts2pyfXrkyVpIvqrZtr5cc38gyEs
         792w==
X-Forwarded-Encrypted: i=1; AJvYcCULpsjGW/3WN2wdC42SlkS2NMW+Jza/Oe+p+aAHigGDUzLhZpKYAD5SkT92OUXB6zC4nADn36PQJA==@kvack.org
X-Gm-Message-State: AOJu0YwFUY20zmgCYFfPex5mWcB5CM3hqj2z1IspCF8+nK/6yGZhIhr5
	ECqV6tILJuCqeuvuoNJ0LtslId1t/d6VC2o2LxcaORo8dq1LpVv67iGRsdhfgmUJpKi0TlXacZn
	NeItZMa1h6kWhnuNyJoj89mFxygJBcX0=
X-Gm-Gg: AY/fxX6PCvvGx8UWzZHdKSzgfbUJS7067HgxE3XQgCaRuCBCQhuom4UYCZ23Qi+76sx
	5Q6uyHGK5XPKt2TrUW2O4JZU3xd8Xa3aewU4CbTwd/BkfcaCzb9Gq8Gp3K9EUe+XqZdHmLX96Uj
	vgfBr5sPSYZIVN7Khz+zs89c+xrYwwePwVLnQUkYKbWV7Lrb1vF9b+NlWyKzvUbTsH/di0i/Z4Y
	WlhX8vNJQonIr6f7NE7eCiYztUClyGTMXV+Km04YBsm3bbdKV6uN8JNPK2OhegPWGqa1RMBpGWc
	fQ0aYJ6fKGzn8LjU5xZbe+R6L7Dn1K/C2FuWv1vdR+mPf70PT+K4pxp8tWiSs8uVBsHEJHuUBm+
	VS5H/22RguxBjqR00YsAuQSPf5sNrDhqX3HfDMudubg==
X-Google-Smtp-Source: AGHT+IHLPkk84HDbctsvqovRdNwO8VvPLDd80eOVW7PHacCQOYIdRdymbqSCwJh/PEO5EV8UmN/IUnVVjDjqV/oUkCU=
X-Received: by 2002:a05:651c:1a08:b0:372:628b:5cb4 with SMTP id
 38308e7fff4ca-381216a75b0mr155117721fa.45.1767626841435; Mon, 05 Jan 2026
 07:27:21 -0800 (PST)
MIME-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com> <20260105-define-rust-helper-v2-27-51da5f454a67@google.com>
In-Reply-To: <20260105-define-rust-helper-v2-27-51da5f454a67@google.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Mon, 5 Jan 2026 10:26:45 -0500
X-Gm-Features: AQt7F2qJLVbMjEOQg2dt-RJ8P2I5PmniDGVk1Kk9Jbi2wHHMLCGhrUjUoujZw4c
Message-ID: <CAJ-ks9mh9ni0_td285C+=o8TDshrKKzUE64-hQ5hx4pO0v0vXQ@mail.gmail.com>
Subject: Re: [PATCH v2 27/27] rust: xarray: add __rust_helper to helpers
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D3694000B
X-Stat-Signature: xhxfgtzidp8b7ans7pxmnuzpc3asi6yh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767626843-556500
X-HE-Meta: U2FsdGVkX1+6c0eZUiVE1mYMkcKpYyG0KTrubBPwztFOANC1fnIzf1x7LX/U+jVx4+7Z7iT0qfet1BA5+y9NQwnbvmbkf31N3h4ZuJXkmI2Hj11F3hfhU00+N/Q3eawQdTx76yiFLBhcTa8kwMekv5klpSQS2k8uVudjqIZh4tIWhovW6xF6iYhpPWJQZuCtD6I0Avf+3d7hCyqaw55/FwWiVgPkKLsq2lI/KSWJ34ZE2xTNgq81DLH4AIgFxjOOeYRTS98vYu6M3DwlNJNAmhaMwH3JVAtjI4LiowjNUJhZJI70rpg5qjfLU40MZ9xCxxg3h02tnS/N5zxIY3CX3wNXKhxNOKIDwsFbT26FR4YYVoAWw0OyUb4KSUunhwq7k1xi2//6mmhGEWH0LdaWe4+l63IMWhnjyAC2ogSdBW8Jp1iv2OgcRBD0olPOsaQ/b/CbwuVLZ7sHQXxc2400iARYmr6AzmklGqBJa8dgD9s/XiUCvZ4RaHzrE7G36e7/dVn81pPjuBPWw8YcjkE8nDFjRQ/ktPirMgawTF9vBBMbEslbT44QIiEJYvzxHQ3bFYCC/+TJEztwcVvPJ0ChRexegWXnRJ4wqjiwmd9a38dIjstaOI69gWnxVAl9SmmLSeOpVRLLwhITUbVhejz1fvCT6HPihsSVAWU8RIgWBHIh3OvRN/SI/Y0licMXDHXiv+5aFwSBs22C1PDLtVHnZOMUaM6q4vQ1fERRMXuH2qZx6ZJtNFrAj0wk2I4Sik737tU9+qshZkF9+SKtlItmA9q+tlP/5D/kQaF2qP+0WpsRvIFn/Y/R07rkudPYK8eXYlS/nAt6q/b6mVbntnuzHH/n02DYbVErDRdV6l/C/wZMBzXUGq5BhoGVk5vIf/vNS/1g5kTMyi80dwb1Swr6BR6r0W88UU7RokOuhUXRyKppJ3tvrZEtUsyboprVICMs4Ol3fjYpOTTuUM1YQUW
 zV0uPY0Q
 S0tfsRuq6VHMjWwj3dhyP1g14bknyRrrGgktfWQMzb8xnJDjWowFstM1LzuzpYq2tuGQNvOaUOTGDoFiCfeERX6puPXKkAaE10CFDVmAdkMneObAchztVWrbcejJeMdOaSgoSsmK5oWOAsgpNI7Jfpe4OfXleXLSAf2avd5DJ2gH+cBXoF4S/63uuvrwQx3uddzcS71VvPWENVcx+aCuH6CwLDlASw49ev4DN/UNMlZHYWHH61KB1B6Ic+BquBVhou41tI2QCR9RIMIvypH1gwRv0Vi/RGH0BASu+Xso0ASFiIxu7ZmjFdRlCZLuGYMG/iGAxv8JnOWv3rOg6vXvIw+azKLIG4YfKNpkFJkDTzV6ApjSVm8E93oEtnlTR0jr0+n5qQYXPs3+UDj+abw7nzmFcCUUtXnzmion+wIfDFHl5U79EFKzgeLIBkPz4J56VUFWjOf3RdSsCWLzdZ/BSpvoC+8Eryop23YeoQUzp/DWKzI2Qx0blk5aFdEzAkczOxKDuUdPX19abtB8vVt56nK4N23eSKx3u6Xp1RK1t2Z17TVgssl8Pbpv4VmLhkCslR8w+Wp3WoStTjSihBZPRADshyEGL4KGYHckf34CoCYeZOxTqzTSuvVqyAcpc5icOM4KYTOQBekz96OId6vlPLnJxqB+tbsXfmehY6Q9gR+AS1ThINHmgl6hCc/2uZD2pE4DvxqK3oqT2aTnhcUPll/QHHC0lQEnEPewSmsBSkwBLlNIMoGv8+RAbfJLQtQWv033Oqa5cjLg3Xby37CrI7AXaaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 7:43=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> This is needed to inline these helpers into Rust code.
>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Acked-by: Tamir Duberstein <tamird@gmail.com>

> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Tamir Duberstein <tamird@gmail.com>
> Cc: Andreas Hindborg <a.hindborg@kernel.org>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  rust/helpers/xarray.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
> index 60b299f11451d2c4a75e50e25dec4dac13f143f4..08979b3043410ff89d2adc0b2=
597825115c5100f 100644
> --- a/rust/helpers/xarray.c
> +++ b/rust/helpers/xarray.c
> @@ -2,27 +2,27 @@
>
>  #include <linux/xarray.h>
>
> -int rust_helper_xa_err(void *entry)
> +__rust_helper int rust_helper_xa_err(void *entry)
>  {
>         return xa_err(entry);
>  }
>
> -void rust_helper_xa_init_flags(struct xarray *xa, gfp_t flags)
> +__rust_helper void rust_helper_xa_init_flags(struct xarray *xa, gfp_t fl=
ags)
>  {
>         return xa_init_flags(xa, flags);
>  }
>
> -int rust_helper_xa_trylock(struct xarray *xa)
> +__rust_helper int rust_helper_xa_trylock(struct xarray *xa)
>  {
>         return xa_trylock(xa);
>  }
>
> -void rust_helper_xa_lock(struct xarray *xa)
> +__rust_helper void rust_helper_xa_lock(struct xarray *xa)
>  {
>         return xa_lock(xa);
>  }
>
> -void rust_helper_xa_unlock(struct xarray *xa)
> +__rust_helper void rust_helper_xa_unlock(struct xarray *xa)
>  {
>         return xa_unlock(xa);
>  }
>
> --
> 2.52.0.351.gbe84eed79e-goog
>


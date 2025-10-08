Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CEACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB5E8E001C; Wed,  8 Oct 2025 12:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AC68E0002; Wed,  8 Oct 2025 12:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222228E001C; Wed,  8 Oct 2025 12:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2F18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:59:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5279C068D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:59:52 +0000 (UTC)
X-FDA: 83975559024.24.4F4BF8E
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3AF612000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:59:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LH08m5J/";
	spf=pass (imf29.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759942790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbyHQEVZUWM5+b8hXROM9euWoMjNsVjY1q+gc+HNpdk=;
	b=8i8gcFOWnqGummfX+kw8SfAq05WjrmYCd8EAXgMN3fQfcx22Z7M6bDJ4exI0DmMpsqYGha
	wIQ1PyaZpC+MDaD5LhY1XFuemAsLuwRP2fgdNs6ibiITvTrP+R+KGAzaG3dA7AFyv+argG
	D3BdJhU6DH9BZyXIX0W0hSIsAGFkKLs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LH08m5J/";
	spf=pass (imf29.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759942790; a=rsa-sha256;
	cv=none;
	b=vMvoW4hHZneoQxu7tVSAPELNk6UFXBq7JBHqPO7I6FjVISKAJ/DAzcQSbEpQVISv7vaRfv
	UVAL6IQOGkmUysP9kScQD1J3eO+9+iXd8pfPF4pZv4zvIJ1rWBwCbEHG5KzEssFlH08EvZ
	p/htUoBUg0Ch9Z+uvtf/LFUdxyuUeKc=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-375eff817a3so34161501fa.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759942789; x=1760547589; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbyHQEVZUWM5+b8hXROM9euWoMjNsVjY1q+gc+HNpdk=;
        b=LH08m5J/2curTd2rcvujZEoLFwlXx4sIxftvC7DQfjSL9w96ct0u/Xe8rFu4xEsV1r
         aIpim6S+d8clFAxT8+pK7Pi5pavyQE8TUkSmGyh3Z3S0CSErLkQZWyAdChSEWinwqtVN
         nHMPWR+Hh8kXEeFadIld2pLsrTQueyTaWBI6fTMdvmRm9BuSJI6VN/oTmj8WQXuy17mL
         2oQJvtTtKayOykOUM5BTIjuPFCmhxRjppUJG1QN2vXLxcE/UpfXc/Bbcy/IN9ftFG+1+
         NW1zr0n2XZtIwHCl+6tqqYKkuRSXSDjq/ev1vO663QXZlQuyFbBVsBpq2MEPDFQC8JjK
         H4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759942789; x=1760547589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tbyHQEVZUWM5+b8hXROM9euWoMjNsVjY1q+gc+HNpdk=;
        b=RGPyoJUG38o0TTZIskePbM2uAHvOlfumNdWvLLotyEqhv2oDdZX3siSPatjEC+5O3T
         JSpYwgTZc+wWt+h62qWgyG2SS260hc7Ab3vbV2+Z1PvcFzp7Mhk798zooeDWnsu2/roM
         ANIjDHmUDSGlAmSuHP1MU0RuMSwWMsyaqobo8HXmG3/w2BZMor1imoZGtGb4NnAoVvIZ
         b8KQ9PbjjBOcgmIsy1VvyrSHdrnP9qH2pFlpslcxtB0TNYFh3jsKlLIcORa5PVZT5XgD
         yI7RFywWzbftubUuJzoYz9r7dRLrc8pglrDMepTZzWphMNqjCmb2Pg9+CAcDfQtxL9ZK
         c9kg==
X-Forwarded-Encrypted: i=1; AJvYcCWEaZRrnDa2nV5IMLYyiWCUZ2raaSqzhJTVo5XzPAvYw5M0ecspK622LHPhuJozHn+Jsw+/IKZqjg==@kvack.org
X-Gm-Message-State: AOJu0YwsgF4hsJ+PmmATJiupKBNI8nWByeZkb9aulB/YOG4W6XocVf0B
	rEoBEAqRgW8MTkByK0jm1dEfabrO44LYWFiYjFKTO0Qfxnk/t3f8E0Alic+IuX8sHKg8LFG2qwy
	iFNjQ+Omx2UfypDh1qsnkf7pN+HIO/34=
X-Gm-Gg: ASbGncu7rT69CKk85Zex9waXruULilN2eWZDDlrN/BFr2lglg87qhFjaZKtp3eiozoo
	jzoTYMw/xoLnElLLnG/HmekICO2BGLjPCVans+99AIZ7f6x/082g0PcRRexl1mwzsBja2w5kAf1
	efafOP67TUyohaVaSF7uAe9d2gT4x7lQGoidus3KukbLe1o0Ss8CxX32CvcCsI/efk/ttaoDR12
	L10cdDPpH8d+QJPCtgGLsMrGrC0fOuv2aTefUn4noR5xQRRB2UdqVG4SOd3auAvn1QPklpYoS6o
	/6UmlqH1cutUC26JmkkN8/euuFb68i0ISn+GmhEB1Mn5VwLZ5/Niok8=
X-Google-Smtp-Source: AGHT+IGwE31TEki+9bgtGRuJBI0XpflFmiVXP2InI4RexshP1L9r4vs0K8grtJNFkGtKKh4judP6Mucbj50jbGgWQT0=
X-Received: by 2002:a05:651c:12c3:b0:336:6c93:9726 with SMTP id
 38308e7fff4ca-37609cc1c50mr12805851fa.4.1759942788553; Wed, 08 Oct 2025
 09:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20251008124619.3160-1-work@onurozkan.dev> <20251008124619.3160-3-work@onurozkan.dev>
In-Reply-To: <20251008124619.3160-3-work@onurozkan.dev>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 8 Oct 2025 09:59:12 -0700
X-Gm-Features: AS18NWB_7cIMONd68nAMOTgSvZDlnnuuRjeTROznbec4OLsuftEiYVOVmU_FLrg
Message-ID: <CAJ-ks9mtfVmP+SwZvBVuQSwViiqo2ZngSGQuU5Y7A-Q_JSwjKQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
To: =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org, 
	linux-kernel@vger.kernel.org, acourbot@nvidia.com, airlied@gmail.com, 
	simona@ffwll.ch, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3AF612000B
X-Stat-Signature: h5nf3skedxeqzhisa6de4peqkcfabnu1
X-Rspam-User: 
X-HE-Tag: 1759942790-865366
X-HE-Meta: U2FsdGVkX1/Ie5XAeh3hxUSTCuVAJVstLg0KKQHPjKNyPlAtWxIxXN6dQgCx9V1OAnvZDQjrA/VT9vItQcZfYlH58LEVJBI7Ag9Lc3cw5Q/j/BXDHXzRBQyCg/LEOPngw98PtspONyVzgaefEfFsPgxlCA3LXphuEB0LyMU6SHjKT9OfcEyvzyMMrgYjwEjR+Fb6SF+xHwN5gJtGLuk4uGshKDcfKFYpcCWea4JLAEy6I+qiYeUJy6jNrUCw5hJw+2X3nL/+pf+jEfDxu2KXj+j9nSUy30QreIniMDOY1AJOaqiP4bQpdNi+qXcP2hiV0F8F5XdqftmAqrjzVSpvd54grwcUU242PEtgMx3iZhzHGITOZCsoGbgrdjAuST4Liru+jKq4hhTgnxgxm1qYSokaoQUwacoYLP5rddw8CUTyyJDxFgICq3vfExi5rnAmEBrFJi5ka2zM/eNVJ9ASwjxqYpDROrO92WMdg4rWQO+cQsIBbSGv0Jll0xendvaRFdH4GDxUksAZuMhD9NxRNbQBjurtUzDkZrWSD6dynQ5alloHCohS0Gnb9T/Dz9p2ZkDbTG47e2KwpsitQA/9FPHtk5ktl8PPnco8O2p+4WFA2zsqy/gMRTGLdnN4+xMfGnHaMJ+7TTTIGfNCmnUjFE3nlVQ/n3OYelbaZVWThzrayzzhUUsLoJ8F3c3V2QiO78lzQIkeP5vXCq2mgeYnWBYWgbSqEIn4TvTKZQ/eOJtaS6UHFfAi9frtOGWUpkaJ0Ute3QYwXBXli1hgu0NLSwy6wDT4Yvy8gf5rOjz1H0kwac+Z4FIezocHZhjtr2+Fi8a/dZOhN/W9O90ZVJDxLnfGJqwPAUKL5xT4tDpImr4uJm8gq3HmyQBD22sQ6t8AOUrVpynOWx4XPGsWHwtG8tCZ6LtLNJCBcE7koikgfLFRBwo7olhFMyRzmoWzOQVwGlOo0ubdPCu1OuvNYrn
 AGVqyiM/
 47N5nrBJ65WdtkaUlPjzachPb2mT4xpNIxI0P5owsaf4QMkDDepaVLWUICa1rFNKwpBbLOkEGqEy892c02UMY16YsQeB3Lr8S64HnAWvEJT8gfiepYUOnRd5d1bgk/4Ajzace/P42+ieJx2VDiTSyLiiOgZfwEtZfuK0Q75DMipuFN9Ms5qQFvDQda6sUdeTQZzkp7invbG7Bstjc2/8Je7EnrPsmAS4oK6hRXT5fQCJLkz7jiVU9ibLUkf4z0ZO+yGwpMDMGTbnlBl3vKDx3OuH/8nu1cVOS5L/HTXrlLEyHBtO4qrLq4rVOSJioE7Tacdf7YHWnAtnCGWdbV0OkMln+oYtTojqPwdWYX5zFT0zQK7K8OoTc6kMFuyRRSZNdohqwfR1kJs2nGzOHVHOLL0ny93fyz7rJ6jgmbflLqhhdBz0O/I7e3TMvfQs0JHCTgxhAjNPHrr4fxAOQYNBWoO8g/3UlNv2BwvXbLfMs2r/oF5YtQ+ZBWUpfWb8f1TaolvHmP7THqorGYog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 6:05=E2=80=AFAM Onur =C3=96zkan <work@onurozkan.dev>=
 wrote:
>
> Implements `alloc` function to `XArray<T>` that wraps
> `xa_alloc` safely, which will be used to generate the
> auxiliary device IDs.
>
> Resolves a task from the nova/core task list under the "XArray
> bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
> file.
>
> Signed-off-by: Onur =C3=96zkan <work@onurozkan.dev>
> ---
>  rust/kernel/xarray.rs | 41 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 90e27cd5197e..0711ccf99fb4 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -10,7 +10,7 @@
>      ffi::c_void,
>      types::{ForeignOwnable, NotThreadSafe, Opaque},
>  };
> -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> +use core::{iter, marker::PhantomData, ops::Range, pin::Pin, ptr::NonNull=
};
>  use pin_init::{pin_data, pin_init, pinned_drop, PinInit};
>
>  /// An array which efficiently maps sparse integer indices to owned obje=
cts.
> @@ -268,6 +268,45 @@ pub fn store(
>              Ok(unsafe { T::try_from_foreign(old) })
>          }
>      }
> +
> +    /// Allocates an empty slot within the given `limit` and stores `val=
ue` there.
> +    ///
> +    /// May drop the lock if needed to allocate memory, and then reacqui=
re it afterwards.
> +    ///
> +    /// On success, returns the allocated index.

Returning the index is not a very good abstraction. Would the
reservation API meet your needs?

https://lore.kernel.org/all/20250713-xarray-insert-reserve-v2-3-b939645808a=
2@gmail.com/

If yes, I would appreciate your tags there.


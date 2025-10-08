Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DCECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 13:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E298E0026; Wed,  8 Oct 2025 09:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365D28E0002; Wed,  8 Oct 2025 09:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2542E8E0026; Wed,  8 Oct 2025 09:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED738E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:04:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEF37C055D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:04:16 +0000 (UTC)
X-FDA: 83974965312.15.07D2CA8
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEFD540012
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:04:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xCWs+0Tv;
	spf=pass (imf17.hostedemail.com: domain of 3TGHmaAkKCPUXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TGHmaAkKCPUXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759928654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqAM5J5K6OQvQzOQHzxihWMwPVqmYeUpdruR6N5ZdUg=;
	b=uTmesAKJoX+vTUA6hblccJwkeFyUBjeo3dnu1ykXYbPRMpR9nZyFQYX4UgB9UNg+Gkqc7I
	Ea7SZKD1Eix7SJOr9kS4SjOzV16z0Ctm/z5mrU8XsHPvloWU2JpaJpFjggmFGSCjlWlPNy
	M8Xwx9jxmUd1pD2VQNQlTWCiu9DYm40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759928654; a=rsa-sha256;
	cv=none;
	b=LamwN17YFKXwd68NZ04450eILFF3UR8os8jTNejLuZ4gYQREe6xNhgvztg6ZGR5dA5pVTI
	7YgLnjW4cSLc43pEg+whaOYvVC8wgL3r8yCWuqWUa6AfAOHRavbjvqiOjzkFf5JlDWejKv
	qWXk09FO0NbL5X9TMUmYbOCHvSsSzwE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xCWs+0Tv;
	spf=pass (imf17.hostedemail.com: domain of 3TGHmaAkKCPUXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TGHmaAkKCPUXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b3d525fb67eso703125966b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 06:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759928653; x=1760533453; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqAM5J5K6OQvQzOQHzxihWMwPVqmYeUpdruR6N5ZdUg=;
        b=xCWs+0TvP4e0OVueUSud60ky7eJTbLTYim3u6YkLqGLtmbQ0BjZez/Fwmq/7EBeTyb
         2n/Mw2XKxJP/4ch06BSAmm4ufdegfxjVjAggPIM5KZWFkS/BD6vbHRiSHpLblMVHr/Su
         ixIkG62FmgYcnuXRRVxh9PGVWTbJlOUABWfoldknIMgMfqNNgev9ufBj+eqSpPg6NGMb
         Zk//OEZyC9pbb8XQ0R4h+99ULC51+Xja4bp5oAZ5FrJ2w4H3mOE51w0Ey8Eiy/7btir9
         6EvxBQB7mks6q3P8WZb8yXeeSbnzPoElmq7+6C+3+8N8bio07ctM4ItXYiflxUN9a9EC
         SQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759928653; x=1760533453;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UqAM5J5K6OQvQzOQHzxihWMwPVqmYeUpdruR6N5ZdUg=;
        b=VPS51L82neGc8myjWcO4gHh0ITJIUBvvPUokGTB49Owy20Q2iQJJRSqzeAESzF9Cgw
         radAlGw9nqczTXM3vJ+fVbCHE03ibtZUxplvQ3JeIYZwGL6DltpPQ9BQYbCrhG6Ubk70
         yCCbSljzc9iQB1zpIL4LBMd4ED0w/lUKbdtDv1eFdMfx/pDOV2g5TfpNdKzaBQsEaHMO
         Pp9UGJFbz7L2kpl2DWw+qiz0XCUOCtZJY9FnjQqaDVA5zC6vX7tKBHL/STIfYZnJEoZl
         CayZa0B2I4SizvCS/fWeWDMbCWCs/SgR5zC+TfO56d4azXXEyIYKcHducw2X2EIaX0BF
         zEOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUILFI6zxpsSEgBwLNwrVfjjg3rITN2Ou1Opu7XOvPsgdKNtPrASDT2NSKnf7HUkGVZzjhmCJvc6Q==@kvack.org
X-Gm-Message-State: AOJu0YwTsEtFsQT4Bj18M/y+OraS5Y9x4dIK7VQ9QxF3yHsyFkL0rYvs
	vS5J1YI0Yw17JdzDhUfmZoUr/13k5V58pnLeZAuJhhEdGYDJ2PjFoRsgW2IIuNdI8BJs+UW6Fqi
	3wZT+GLSX7xiSYXOcqw==
X-Google-Smtp-Source: AGHT+IEwDtKAOG3+0GlDuiqWNfaiYirepvfQDt/Qk9gvr2w2apCZsFLWkE0cR2CwoYx8kDzMVpCqB89Jb5iURts=
X-Received: from edbde21.prod.google.com ([2002:a05:6402:3095:b0:62f:d279:8fa2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:40cf:b0:636:23c2:e61f with SMTP id 4fb4d7f45d1cf-639d5c5a38dmr3342530a12.26.1759928652918;
 Wed, 08 Oct 2025 06:04:12 -0700 (PDT)
Date: Wed, 8 Oct 2025 13:04:11 +0000
In-Reply-To: <20251008124619.3160-3-work@onurozkan.dev>
Mime-Version: 1.0
References: <20251008124619.3160-1-work@onurozkan.dev> <20251008124619.3160-3-work@onurozkan.dev>
Message-ID: <aOZhS9nTDnH3Zh7N@google.com>
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
From: Alice Ryhl <aliceryhl@google.com>
To: "Onur =?utf-8?B?w5Z6a2Fu?=" <work@onurozkan.dev>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, tmgross@umich.edu, dakr@kernel.org, 
	linux-kernel@vger.kernel.org, acourbot@nvidia.com, airlied@gmail.com, 
	simona@ffwll.ch, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 173k58g7k1yq1d1ciepjiyd8efe4r13e
X-Rspam-User: 
X-Rspamd-Queue-Id: CEFD540012
X-HE-Tag: 1759928654-897744
X-HE-Meta: U2FsdGVkX18HY++gNXJxtLhoQyFjTlkaD4cPHJwaBZl3CpgF6r6hbMeOX2mJwuz7is6pstFJjr0WZ3W4bDQCkplo5/TSej/o0vxGFCrPNM0/mE6kGHtUqgV37HUbnQqB2LOiBSqAA+1RqW97/1K38XNiAkuM85HsrwAE4r01lozsOcQ5sVpPB4/yQeDBM+QfMhbHtcHMFB1pLLqyAyHMZSUhvoqh5vvtEvmSx+6JS7BtUYHJ7RdMrAIh3WnkDPKuYIfE3ifK0TAoM0132TTW619sc3bTE+yzfzVWhU0asVqx5x1YhwPyseyUp0x38GvgLhRIkzE2R62YVDlrhlJDpOwAoAFYvD92XCKXlFBZcztas6PCpeS936ntp++KhChVWypWzeVPPireZNXxrAs+TjN94sORzbnM9hiAZYwlprqAYEZEYk/ETbZIPQ+7H5+Gl5ewxhW+gyli92tO47x/f+Yyl3s9t8dFy/61XMxdgbruosf3OErnY8Lh61lvNTeE28U0XImI5lU4cp2eyXVWU95jh5k93JoiefbeeDrupQcK7Ngz+3DQVgxO4OHfaAA8JrfoWDbDs1r5cr8Jef4TJD8n7UICwnQPDCzNcX9++yU4whaxImVr3PvCndfLO7saivzzwbwsEG3PQL3KH+hVJWMjmnxGo+EYTNRCdj2KeCTlrJBH3Uvf3UR3JtNAQUGcQRfprQcDP5DHXip5ocM4tttv5r0X5aY4vUgtxA7IkuBPQgO9Lxt2iWrpboHt6rgBckiaQWH8E3N2GVKClFJd0vMdoCOMY2aoHtcz1s1OJR5KlUs7Nuyz1qJH7it4uvQqY/z0r+eN/yK8bhEdSMiYNZS63rMsu9P9Y1NfJCNejsEPvcEMD406IjXTGdrbkazL+OqmZ16AlkVTG1G3TTGR3eXpeSVyqvvkj6Z+vzG6v/H/7p8SELU984bsZqr2mm6BoiIDwVAnULfwnWbk2X6
 pvIC7Hu+
 aMEhsfI6YVhAFT7gOYWzoNquki/etqlEZrZpkUmY6KkFcNGlNyST9ROhkjPOn7AUubmeTzW01uKhFpCGqXUVzSclh9f7ZsCylSJbIRnYKwcWiSsRUgN9gY2k6BB3AgKq4FzWF2mzUYA/tsRtdY0/TLc2E+DLVeJImcFJAji6iTqsmd5c2e3FofVPumYrP3taHucJgqs3pYXdDVc3riPykP34HGi2NaGYU9z2yEWLzWYLH30Tn5LipUUky5P7vI24QfmZpEJLOgJ/gRyYkxqehzFV5a6bS9fVfPgTrXUyNEugkbxg+0F8HqasiA+FoVG9hIBYJt8upIbeztybopQIEZpDwW7KFDGMCnCeCZJq+nqizux3bby5JYNaGDPkQxiOBEfZ6FKBbPlfEhM0IKnhRaDyH4Dap/4GhAVeZh0zxRhvSa2ITErcm986/SyMbExl+4Ac7xWfOb3cbtcA4ET++OiQ3OsZb764hbJq2c2rIxT4XIfKEPeg/qMjexGBl9JPRJ15mQjUhttWx8wBsBRZidqzjTV5u/qOfmWT7OUsT7bCYRNh7Zf5JiQaG+ztPiezSIzidiHzxUpD6rzDDGa2XcyDqq6DOeuyTvxAGLFU03rZYV/99zsT0ZplIkxx+ZXnnaUn27Km3DgkpFrUCt39KXylaxpDJMAK1ie6yTz4beABjq45tQYrDjcUOWcdSsPE7xKtW9qRVH54BXqvmZ1kgwOZc8uT9+f4QcKOfkgnFCPZhtS3UpDKMU6l3G/hLseM7U1DYVPrsKntheJRYz8uPESUmQlIh8AMKEdysG9ylU3WFVqjlTXMxVhWcMjM+mgjwC4dE/Y45DVp0/m3RpxOh84u5hMaOqxDEITTZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 03:46:17PM +0300, Onur =C3=96zkan wrote:
> Implements `alloc` function to `XArray<T>` that wraps
> `xa_alloc` safely, which will be used to generate the
> auxiliary device IDs.
>=20
> Resolves a task from the nova/core task list under the "XArray
> bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
> file.
>=20
> Signed-off-by: Onur =C3=96zkan <work@onurozkan.dev>
> ---
>  rust/kernel/xarray.rs | 41 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
>=20
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
>=20
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
> +    ///
> +    /// On failure, returns the element which was attempted to be stored=
.
> +    pub fn alloc(
> +        &mut self,
> +        limit: Range<u32>,

The Range type is inclusive/exclusive but xa_limit is
inclusive/inclusive. They should match to avoid confusion.

Alice


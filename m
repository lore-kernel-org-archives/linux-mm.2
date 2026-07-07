Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E471AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58196B00A6; Tue,  7 Jul 2026 09:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08916B00A7; Tue,  7 Jul 2026 09:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1916B00AA; Tue,  7 Jul 2026 09:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2A86B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:04:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B53B1C141F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:04:30 +0000 (UTC)
X-FDA: 84961999500.15.C25F92D
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2BA47A0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:04:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EhEg32KL;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783429468;
	b=n0mhBtgL+4KNNk6J/36j0twdVmLUF1mu+1lyCmALCGzP53Mdiod8ovMSlreMdJqWHMQ2Q0
	SYFG+oCc1Y3Xyb3FH8IFbqV1IcYziF2lqkp5k1VMp5zcyRjGcueU5yRxd/vRwOQMb7nhoQ
	QYxZkvorfHltkzBhZEDtd7Ir8k/DeyI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EhEg32KL;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMZTTwd8MYpbLMhgPf9wJy+JM0u3tngYW75375hm26s=;
	b=x/yNnXBUYttWISnuVnEtGfAb0qa6uFQl9CZUyx0eNBcBZ6iXiy0eaYIHLhHcE8bYrD0+ax
	ndD8z2nTIAoLKUZaRHWEHx+jWm7y1ZIp9yulK3/RKIo9sZHactp2/MpsHla8X9ArJwBUtn
	6+yH7S0BQm53kLSeOumEiyyuxtKM6LA=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493c733f15aso40224325e9.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783429466; cv=none;
        d=google.com; s=arc-20260327;
        b=DxnygU/JwkRA7psiad+4eylN1Ys3mI411dEdURkMXK07jVP6hKlI1CoQuYBU7Xsei/
         LEv7z+IMZtGU+6k/7rPXfyGlM3uezj+82DdGUPlkIDAkOtjXDreCdpuGEe8EjZOZ8liY
         ZHqUdSz3BEr83UdmJfPYG43C9Yzn06bkNg/puX+9BQC5ag1h6E1rcijDlNNaaR65dIs3
         /2EZOXELJK6Bv/Sqiq8Fs9D808XulqCGnwcbAZH8A0hkvS7f8AdWwtCG4fORfqv5NFZR
         gqT1WzPJaA+rM/sVCL5wFVsybnjI3AcaqFbjcAtyaxWYmV1pqR+fXUkNzf71qZepFLwW
         mS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kMZTTwd8MYpbLMhgPf9wJy+JM0u3tngYW75375hm26s=;
        fh=YwC0YhC4q0k/4wbbaR9u/lf82StNOgZSEes7ebaA4P4=;
        b=EsX0u6Bj0VlQOBypW9sxEIKn+OdPVyr0VxkWVk1uhiiBnYG901A2nEl5H55Bz8mD1U
         fgCr9HDDaZdrh/RKMpQvsUISI95f7a++YBuUhd9ok9OeHPLpNdc0eELRI2eCqti9KAK+
         CtfkcjTWhxBm295pua2VzpbXkBmOB0vm+Q52l/zUKb4tSWzAEuwCw3OIV77UjXGVPKHi
         YQMytyfglJKoO9mpS1OeHil1VHVEWd2JRkKa4cP760f9i4WU7j7Em0kQ0yoSlRXqvVNx
         7jueAd5MoyNls8D4XCMq4uUbwhgejRpY2K5MfUKUf+wZzE+Jh+BgEusWyaWd00hy5O0v
         M6oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783429466; x=1784034266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMZTTwd8MYpbLMhgPf9wJy+JM0u3tngYW75375hm26s=;
        b=EhEg32KLFU2zKAllECmB0OccTf7pl4nY55WpJESXTWso48vxVaTcCVtoiLDblXaS4h
         qLy8ofaGfM9JH13TX9XI5rulxXzttSMry8lfZC/W/SZ2qvqYCekj62LhAsyqK9myBnDn
         5eVwoZ6OhJV3UyOuXH+RdL6TEJe+xKKLE4RFhEdyvuwxWEZ/L5P6SGbrHHECocc98A4w
         iGOqNFvCBtvsO7DJRhc63FvpnznTRm3Uut0LZP8gds/M0WEx01qMuEF2o43hzVQIcrXg
         RCr+cpnb+oh4enguBwLPS0mf2uZ9EbAHH1CnjygLOU4ScLNRg0SzIOdJCYxG2ZDqwYhE
         AvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429466; x=1784034266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kMZTTwd8MYpbLMhgPf9wJy+JM0u3tngYW75375hm26s=;
        b=R0k3r2PfLDrR+K/IdzowoMkxra2dmwOkimvwdPrTfn1Mlf3CKXiN2B4A/7KV+jtFJN
         JMfTbduVmlw6K62Ir9r2q4WNjfp5RXxUyoztnbO6Old3mSwvYUR4ldinJAlPaz3bcj1p
         Gw3MlWfcb/JMSTmzpRgyTkK8lSNHnvUMbEep09Kd2NZ37B+4+5ixS33Do7TqCrX2Qpxv
         4RmS871cDGASPHK42R9zKrZThc+6cFQzgNrDvvIOgDkzUaa9ndf1n0juTE/hJQQqPEnw
         0XV4XclW85T2WgMfdpCTaILXrTWL3YhPblO91RjxxumioKE+znLbMN4vkYkYURPrzazn
         Z2pQ==
X-Forwarded-Encrypted: i=1; AHgh+RrG6qqmKwmYcPW2eTQ4/XQy3CZMI/ivGSgz/BOUl9ZDkZN60AFcnFZIZc5n3dq8QaKmB2T5fJRDog==@kvack.org
X-Gm-Message-State: AOJu0YwTfQQiT6YvMbJ+U9ndi6Ia9BjU+k0YT0tEBnsmD1o+CXsySfJa
	JI9yeYFbnQsxOXlHjYXShf/NuaqqiKszAF/vDWYx5ajG1bLKLcRUxBQkZM2d5TwzUn+/rDa4vco
	Ny0cbUKEBRd5gnaYpJNWaJk3ihVybnxBWOuDtVBEg
X-Gm-Gg: AfdE7clogApe5IW38FMeGODVvi2KbEbCnQt6psbDwQrLk5wL+7r1nJAiS1LSasVrFU1
	fPEMwtDzY6gzuqYWVakxxDE4Hyl1GydPjTher1Xezmz5xI6gCTPQ7wyTBH43Wuovmk48JNopAwt
	zxAq0/wbC1zjgf0IJiP7QUZxZ2/p0HWrE6obglcbcJ3yaTxzdbYgb0PDzZkXGRMJc8EQFS56mBL
	fXaJnhIZqujZspS20JsTXxqxGFYgji1fvS9ruoUne+JsD77uf3UJCv27CFt0c7Mz04foJoOpUw/
	h3wBaOeoEZJoUsN9DgzRMmKCsPI=
X-Received: by 2002:a05:600c:3e14:b0:493:bc4a:e7d3 with SMTP id
 5b1f17b1804b1-493df0a08d1mr56240095e9.39.1783429465838; Tue, 07 Jul 2026
 06:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org> <20260626-unique-ref-v19-4-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-4-2607ca88dfdf@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 7 Jul 2026 15:04:13 +0200
X-Gm-Features: AVVi8CcTh9Rs6YX_7yLE2pYLhG0EOfuYJdmTfdwdI6hvKkhrcisIrByGWFuDPNk
Message-ID: <CAH5fLgguLAQG7mUwD1NPECYSsPdpPD_tLskU3NdwLZhKR1H=aQ@mail.gmail.com>
Subject: Re: [PATCH v19 4/8] rust: page: convert to `Ownable`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2BA47A0004
X-Rspam-User: 
X-Stat-Signature: rsjzgsmut67bdmn4ih5c4u4p5c9ozeb6
X-Rspamd-Server: rspam03
X-HE-Tag: 1783429468-531830
X-HE-Meta: U2FsdGVkX1/lxcytdVSlnN/etg60+6kSUV8WsBV7rUI7nYJqkpkLXwxXy/5EBGhGax0J6bvVGMBzsI513aziPv5uzhbseYn0ttkZkAhbO7kqbzuHJKt1OfR1coi/b0Rs2b6k8SVGjCYtb7UNyTtvFznzjkU8ZFf31Sqc9Y+ho5Kjy5SPvjsqYl5NXRCMjNcrt7vTqWCqx94+549iJF/ytYgaTO0gSzEdoT4P3fXP0SVUEwJknZWAyAyachA+c+CVnMf4KAQ2DH0TskXZZ+NM2W1lbdpuxTOm3zqvA1LR7JWw6HtWQ9JYd0FX0ig+APnsn3OyO2F3HJa0V4h0D0V0BO4THQDfGxrI9jBiSx0we2wehV0cXaMZUeCRZjaF0ZGXaJwYMVOhPKs7D3ry3rExQNGANyrJiGJca5e0yv+H09IFKgOPIW2sd6Xcje0DFJ46GRDEm222lM2aOIHYGVZ99hcLl1HE67TTg2795khBXVkkjiKhoPRmAy6IiPWItJfxOyryrrKcRzbMM3VmqfXsRUZC1r0IRZJxzdEC97oE5mJT6+Zsji3Mzc29gNA6ty133NKF0Suylhhbeu6e3YGl59+inRwsIx5yfRhnU3hPxYpExGVyj9pzbgnycfk7oNSitBXvylpmxWFNVZ+OvBLZsHa307xTngEzaUcDq+vIurePXi1snY6s4Qkp07NzkE25212DakbeuHCeTV3GoY7JY82AK0R1+tt7eO5yZ8vBgpvqhEQbdehP8ctZe7dsUlheI3fyJ+Uhi9OiUWK7Lb6nkjh0TpZidYi6KtTvFAHPnMHye8NKppgewq470KNQOKRRqT/h1WYI3yggGqvQkDSN6aLrWP7hzUQIX/VD+vFfNrvhl0STG35Tq0Czr0qdd9xZQlJGDEid55/Q87dLrN8I0PPQKKQhbssG2emIhEGQC8ajrEN0sSAZnTCyoqEmdVEkJVJ2rIpcPEuinx8aOML
 edbTHiwb
 4nt5/HpJ7EGewwLswwbYpX3bp6TeFFFSZaQAKJRvi9aJrEgbgB+Z2/1uNmWGB/TcqaQ4TgwQGtXAGOYmH+icx4eTBU8YMcpol7b0GOE37DWcaFOS5Ap3jBPo5YPWah3eZ/sX4DZhCM0cfCitByBIQlqMfKKN39mbtTkei+nw4FrQdLfAFQGOIV15zinQa4vgG1BUgygaeek8X2Dw2zUgR8ZCNRVK6VB3Ykah12r1DFwQ4PSWKQMuA9XjoivVOf7p+BAqCFI/i+cGxRYI6CQfIF4y9nKO0fSSD8Qzbk/F1UtUrwcZxkBhFZSricfqZEDBJFtoT8rtRBqzgszeHdUtkUnN0CjumRrMsDgdxiDpnUpo6yl3ijrdtxygsVGKh17zF+b/fKPXbxMLskg0Zy2NwPuRvfWu3XtvKmvhRQlcVGEfVoU/ao7Ce8uy+t56zXs8T8Vjg13BQKLjq9CUZv5ODkgqje0nz4E3Wt8fXf2TXm4RpySDCbXx9mIcC8eUA2+pRB4CuCRl2/hxNPIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 1:56=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> From: Asahi Lina <lina@asahilina.net>
>
> This allows Page references to be returned as borrowed references,
> without necessarily owning the struct page.
>
> Remove `BorrowedPage` and update users to use `Owned<Page>`.
>
> Signed-off-by: Asahi Lina <lina@asahilina.net>
> [ Andreas: Fix formatting and add a safety comment, update users. ]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Reviewed-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>      /// Returns a raw pointer to the page.
>      pub fn as_ptr(&self) -> *mut bindings::page {
> -        self.page.as_ptr()
> +        Opaque::cast_into(&self.page)

cast_into() is mainly used when you have a raw pointer to opaque. When
you have a reference, you can just do self.page.get()

Alice


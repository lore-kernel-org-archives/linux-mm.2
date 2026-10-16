Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27164CCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4462A6B009B; Fri, 16 Oct 2026 14:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41EFC6B009D; Fri, 16 Oct 2026 14:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E9B6B009E; Fri, 16 Oct 2026 14:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF7546B009B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:42:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89A831A057D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:42:11 +0000 (UTC)
X-FDA: 85329359262.01.0A4F27E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8FCEA4000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:42:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="e/Bcq3Od";
	spf=pass (imf07.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792176129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1xjoNmScVM7o+Z3W17w/ZXE10zFAZ2XykabI7Wb19Q=;
	b=xqOuo+drxWUsWTE4bW9ZyhEfJzCTgx+MtWLLZgKHvMvKTPDYhxxGRPXPphF7U3fYs73H7u
	qcrkEgOuA5D1/kLhENmSCk+5Aad7Kt55mQ3qnA+i5KPtgduR8xaISRbgRh1oRQ1v1vHbl9
	Prbt2Css9hbWDrNrFqu8PqoFMsCeiJo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792176129;
	b=xQieJiVatK1vNklwI7y0uNxxQdv2NSXB5fLCtgMZ0w5c37NrWROVKWoEx2F3PqbFpB39QF
	ExjXy+Qr2tAf8EOIHKGrK6u/C8CZdCRBOfLloWCQ04pTOVW6CjbJQSycN2TF/FLWXtoHVd
	9IYzM2LAbwy7REhJrD8i59tN+wekuLc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="e/Bcq3Od";
	spf=pass (imf07.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a021c28046so5645e9.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:42:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792176128; cv=none;
        d=google.com; s=arc-20260327;
        b=fYFR2W9Cpj0nCmL9uI6pqVf5sBCK6wboz5ktbHPCkRIAM/4APIYo2qTEZLahW1EDb+
         5qSZJcoMPPygUyEWYhQTk0dWdg7qeoHuugqBdH3sUYVCrQ7QggaVwpf3B+9pRqFTVxCK
         hOprcp+LRqd4biW6dZULA152MIplr7KFHLQBMLna8pJQNIyTcxNBISzVbY7Msg2VGRn8
         O5/nLlt0RNEvwQwFfCi9ezk89wARKDH0XBgFdU2CJPpp54qGnCF/9EqZV/7lt7VmUGab
         9Z+ZM50TQUgHakEbbslsSbt2qOuhC+FVusjy+MI1vYM3FAiva4hJ1wttCKudIPSAdS5D
         3n8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l1xjoNmScVM7o+Z3W17w/ZXE10zFAZ2XykabI7Wb19Q=;
        fh=uVSbaY/2mM48sqz/DuBZY0MJZI8FLEY8XT7mXCclwEM=;
        b=YRlVvTssK0z+OOSHntijDmZkb0nkzvh2svE1o1crLoQ1t5H5ntt4fCmtHOl0BNROTK
         x3ZNje/9hzzlVsihC3ijRuaNvq1DBB9mUcdmd6iJiRiDvt5EWJOcOAUQLhfb3rSHLyUU
         m2aNUyAMrESNGBx7SXU7gmH33U7XAGa2NNbUiLhr9vs5E/s5tP6S3T4a38ffQu9RJ96L
         clO/yVQ3QWYaMinQTvxEDhXw27EDLEuxApYc4u9/7lK/6F8Q00RGy8V/erYM54CvOPzh
         4wPoyp5iGCYiHzDDFxZuUkJ7p865yX92AzoAHtv6PcRxBRV5pQCVgNRf9Zva1sMetb25
         +Suw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792176128; x=1792780928; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l1xjoNmScVM7o+Z3W17w/ZXE10zFAZ2XykabI7Wb19Q=;
        b=e/Bcq3OdFqNHpsCPH/6mmSUhS2Co6z7/pErg6XDiLPQBm4s5ODhWniGoru61p1MJfI
         XO/UNnFTtCEOLGWaMgJffSTFOa2yKxKCex95saTz5HzPFZsX71wALkni6Y8LC7QBMPRd
         uEXnc4NzZEdNnZO20hFp3mRhT8RNy9VfChMdbjnimz8ibxP1HT5FrEjOMQhkag+X9VgX
         1Ctvo5dHy12KgiXmoruCgqdU9VektJBOR0X3rMGcIuEiwoBo9DHGexdZcmGVdYaDvaav
         tBMDr1D/AdIkDPi9KMAWJTMmBVtW7QAihjttKeBWLSXXPem+lNn6NH9d7I6qQEsWrcMi
         k4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792176128; x=1792780928;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l1xjoNmScVM7o+Z3W17w/ZXE10zFAZ2XykabI7Wb19Q=;
        b=Rk1xYcnylYv1SPY4z67+IbSiilpR7rmDp8tPm9Ie26unDoIfrrf3uw9JoF0IGQKNCG
         GWgqxdcr9FOSZh7r3eEQR5mfFKad+IWkp9xC+LwzArVqd9V93GlS8PFhO9lNoolzX1dO
         dxLEGvGeps7f9d9n5C4IbETqkh1cbkz9Smd+jnpze4XocTPwM/hTGauyNuGohYOnCAp4
         APG6rQSGdUvcAoQfWO+JsRiOU6tgW1G2AWq1gGD8p1bqdmeaTkHZAMLRwM5K4wMnFOo7
         UZ2V1lVXb53ChH/e7vSP4GLnmbDEF8UNNOCkBmRU6xQ2R5pCAt08j+AFqWd0E5Y/DoEn
         1ZYg==
X-Forwarded-Encrypted: i=1; AKwUvBwna740mCIPpaWm+fT9gI3F9+B0ckGR9updFZVi769TBVZXJlsXJYyQ2E4WlJGFB6gxprOfn9Q8xg==@kvack.org
X-Gm-Message-State: AFq9FYLCwmIPp6NSKQS5v4/kkfeGTQuJMSErI2XIhkCRa2IGK07F2yVI
	u2feE/NdYLOxkXtrfBIkXR7EkWfSMOJOLPOBvdJGCQdH/tvJew8lS5rBa+GmdEEKZJZ7K3LW8Oo
	GaVoAXmEV7BKGxpuERbugSfU+OjyCn4jFnRnS+f2y
X-Gm-Gg: AYBFou2Ey3TsPWZiw+5V3EHMlNXI11vUCjRyTQzJyuhfZrm43Etu6rkTkv0z9PGxu4S
	iFkpBf8AZR1ftI1hkO15X6v8gHp6LhVD71IrhclqH8SWrjGVZJUjGM7RY3lwXU9czKCLegUaap9
	4h8GEGQnjG1MQQR4vIa+tqiNwSHBqfSzP+3iyz7NQgtNiJgzxz9QySPwjgKfK5qIMwtcGZjsYl1
	9rWkrM5SgqAyE1nXOyhz9QU/zMRGToXNMQ9Q/Ng3z5QAhz7spi2MqcwAd8dosukRjjF0HbmVeFA
	x1HuOkTe3Bs34wAve1a6n3qex3rWQVht0X08tFrh5BBdS2leN1ACbbR9uPW2d8FsrJWT+Pti95+
	EcEnN8xRHi642IDRRcj88SgW1wUoWVZvaaVa3OJ3IkS6Up41yDybexPwUy8LL1dcCLQLPVMxNB1
	qtikiFo9aSb5WZyiUzf3J1mK7m7WefMLRzZlZZ5wqrt1M2
X-Received: by 2002:a05:600c:5249:b0:49e:b733:7277 with SMTP id
 5b1f17b1804b1-4a1d8942d80mr134455e9.2.1792176127813; Fri, 16 Oct 2026
 11:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com> <20261016-binder-memcg-v1-2-d659b8ae088b@google.com>
In-Reply-To: <20261016-binder-memcg-v1-2-d659b8ae088b@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 16 Oct 2026 11:41:55 -0700
X-Gm-Features: AclHuK88AWrWkzvJx0KAHsGzJXLD0z9tLNjEcqb2uVEbpJmeuWX5FgW7WUISGzs
Message-ID: <CABdmKX1fLKvC_TnO3g_DkPjcfoXiU2rM-Fa+ZjriYctVQPkFTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust_binder: charge allocated pages to memcg
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FCEA4000A
X-Rspamd-Server: rspam08
X-Stat-Signature: siinmybdmar8a5hx11skj8q3q6jtwd99
X-HE-Tag: 1792176129-159191
X-HE-Meta: U2FsdGVkX1/uoTgVBTvF/0AVavOfJRziSiNcAqFyyub3f12dRq9ZteACq18pEdj1+FsfF/ePVTXRTN0J5kwCv/CRgcXRRIPBfVaa9stQWhmqUASd/agpwY81ZFi04+moUsm2gHfYusesZ0/qyQQlrfpMv+FNjayD/V+ffUkbDtfw1YPepYIEffk0L4yIR/JBiVKHFp+9YsHMuQHgnmCQV7pcU8CWV0BlL7OG3cOKMKvPia//OT0QUL7sZUJrbuAPW9PqeEgPebDi/B1MlPRQpNi/Ec/DF0PKgN3yAS9zqyoVbozQNB22PsLSnMrn4U6Xwf8HiopbcMwuWe2fYCHRFWoaUHzh8q/N2ZHpne4j5dSLxKWADOZvDfVPYPDd/1QI8/Fb5COIg2h7kN/0ENCFW4DUBbn7N6O2OjUVbKNIEV3tEpsCd1KbY5A3Ymo6TcCyKv2UUADDu99noNdzzPxP37hDOLzR9KYM5JkOEYFSiX1MQ7OX/+JoSqMZUlbboloSFXAjZOf43KXf4Gnsxiq5OdroI0/Hoq1KJpdN9eT4rlEsRcGuAY1iqIF0kwKYzo4qHimbr5rWQMgzds9gy3ZUI9Iofb7ulotPWduz6IAXuwgvT9rE1zpr/vi4pq/o/4lD9cOvpJv7NJAxg0WZQxS6h3NwHFOH/YtXg80K4bXX9w10Oh45x77E0/DOhllcvADDUv8lRwPIxMtRNhvO20goecgwZCMSviMmphbYQqVWma7JtQm1XTI09iaw61sLtEgeGUjG2uaUIq6HQnM+Dn+L6yTwqCvDCvZK7fcS8gnibuzM6chKLuCsTr34JQVW7WDBOgUowY/ejoVLqX6GlriH0PAfdRpGIt2MDgwWJlLvcWhDSv9XPeknGjoBGi5SdZeE8Mcw0lhs1uesu6mKAA6TBlcjml13aHggf/i7axMltoOlE9OXBam+8TICca8A3FEofkjQLYcizmWUfE3ULuw
 4u+vGZKO
 qc1cP1SsV+8lcerwFf0njH7MzVK9ut1GdwV/Ouvr0Mnl7EE0kOyvaDKk42GKkrjc7CfvNImIF3zbLSVt9RU1j2V573yH71qBoW8P8v+vum7tSFZGVQtjMpz6Z1hqyCC7p8FEaF1/zKjqDbEJ3OzUjqDuRtJ5cLFKKE9+31oo80p+F/6Rr8qr+PKDqRr1dkX5mqPYDAiUEW+SB8CLdVDUsNJ7gd5n1rewWh+sZOFjaUBudf8zclvtt//nkEqDiCLkPnfFoZx/B90cPXMWsh5zf6Ac46CA6IfMlJ9j1B46kH42Ky/IT5YRa4J1KcwKHf7b2wBR6s2Ttkt0wTMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 6:30=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Pages allocated for a binder VMA are currently not charged to any memory
> cgroup. Thus, use `Page::alloc_page_memcg()` to charge them to the
> owning process's `mm_struct`.
>
> Suggested-by: T.J. Mercier <tjmercier@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  drivers/android/binder/page_range.rs | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binde=
r/page_range.rs
> index 52ffbf3504e7..57da47243967 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -27,7 +27,7 @@
>      ffi::{c_ulong, c_void},
>      mm::{virt, Mm, MmWithUser},
>      new_mutex, new_spinlock,
> -    page::{Page, PAGE_SHIFT, PAGE_SIZE},
> +    page::{MemcgAllocError, Page, PAGE_SHIFT, PAGE_SIZE},
>      prelude::*,
>      str::CStr,
>      sync::{aref::ARef, Mutex, SpinLock},
> @@ -399,7 +399,16 @@ pub(crate) fn use_range(&self, start: usize, end: us=
ize) -> Result<()> {
>      /// Assumes that `i` is in bounds.
>      #[cold]
>      unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
> -        let new_page =3D Page::alloc_page(GFP_KERNEL | __GFP_HIGHMEM | _=
_GFP_ZERO)?;
> +        let new_page =3D Page::alloc_page_memcg(GFP_KERNEL | __GFP_HIGHM=
EM | __GFP_ZERO, &self.mm)

Not related to this change, but I think it might be better to ditch
GFP_KERNEL | __GFP_HIGHMEM and use GFP_HIGHUSER. We're already mapping
this into userspace (and now charging the memcg for it).

Is current the sender here? If memory.high is exceeded, current gets
blamed for it in try_charge_memcg()'s done_restock section. So if it's
the sender, that's not exactly what we want since the sender would be
throttled for it. So I think this depends on
https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.dev=
/.



> +            .inspect_err(|err| {
> +                if *err =3D=3D MemcgAllocError::Memcg {
> +                    binder_debug!(
> +                        FailedTransaction,
> +                        "page allocation for message to {} was blocked b=
y memory cgroup limits",
> +                        self.pid,
> +                    );
> +                }
> +            })?;
>
>          let mm_mutex =3D self.mm_lock.lock();
>          let inner =3D self.lock.lock();
>
> --
> 2.56.0.212.g129ede20d9-goog
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918C5E909DC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFAE86B0088; Tue, 17 Feb 2026 11:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA82F6B0089; Tue, 17 Feb 2026 11:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7FFF6B008A; Tue, 17 Feb 2026 11:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 935A96B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:55:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48DB81A0269
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:55:28 +0000 (UTC)
X-FDA: 84454549536.17.2299475
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32EA3180010
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:55:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dJQ4aXWD;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771347326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ2rqxYuKMwKtIc1bHNkX7YmlF2LDfgfhBLsz256tX0=;
	b=qEfDMt01BPQ6jYp1fjqAaQ2mhRk1vSZa4X04UTTdJH4C27jlsQlKNtL5s4vngQU0YvjVm5
	Ja2vOp6e6g9sGyj+6axz4aRnLKtPgHwf83fvXgkPnXXcY2MdF1ys71lmLwedDzR3gcgkkZ
	zjdmuMKeN/TLNDUkjldVoNOfUIW3nBI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771347326; a=rsa-sha256;
	cv=pass;
	b=U6fQoBCLH/wu2i+WvjREtQD/uqS10BQ9Qg1er2vXu3Axv+iUGdiYxYiAbHM7rEGlUOG5Gf
	BS/UetAdsLRxqKEB0CB/XOi2afrTjCBHEX1PUjyxunDxkRKx1Ret6/g++LCJrujg/Qmdi9
	II2wyqM4miO2RVTP2+7a3Ohj9l3y9lY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dJQ4aXWD;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso23014a12.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:55:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771347325; cv=none;
        d=google.com; s=arc-20240605;
        b=H817O8QhULmXMIWsaOzGkqm0dMEH4lR2N8epZReagLXDVjYCVNnppeD6e+EdFXizwC
         xqT/0zbY8lhjMx4ZFlo4+ch4awL9FRB2MXz4W/4xRk8XtCv4pd8OeJGHxiWaUEnyKq5o
         sK/dWa44Xb0T7sK0D4VJpXvsvXmDi2ZvV2fjZMDfbGYRpJoN8DERDOIxcF/isGmoL8Au
         m4u+/q8zPuTXNL+C1P4eEBRJWNmntFjNiCnRYJyd5LvnIGPPS6ZmIieJ4G9l1DysaFPJ
         M8e2IAB0dRAPn6UCNwkBRz3+8rEkItCeYERg3wgq9fpMlJCET2Xlp1o19RQG0B2Qdf/+
         3Gcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sJ2rqxYuKMwKtIc1bHNkX7YmlF2LDfgfhBLsz256tX0=;
        fh=SHIyg8qRD+aINmyNEL0+1oMl/RsynzIeoQXs8z1tXfw=;
        b=Yr097edUES+GajAVWQVCtIv50SAYrJGD5xm8WtaqYloQoYzEPuRw/RjyYlMR8Ai4cj
         9cIqA2ztEmZNL75TRY0dITHg8qyz3XCL6xUbpbVE67SeDj3mET9BvU7csL3nnzNS7qP3
         yZmLehIXlPyywtUg8YEFxjuoqAwJNzM1bNOD07dPy5+Mp2ycE+s3zlgvGfMa5OWFXADs
         y4SFT6kpdANZ8v8NRSpFgVqGwHr/3A+qbguoXq9V8XoPbGnvN2cZsqW3NLwoDPtOjipC
         1wI+E0kspqgmvA9KyHFcAI9Q6Emj+wwBJ6IID7U/TybBnrxy6yk6gyTJTVH66nvDhgEK
         AxrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771347325; x=1771952125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ2rqxYuKMwKtIc1bHNkX7YmlF2LDfgfhBLsz256tX0=;
        b=dJQ4aXWD5o9iWR0zW4eJc1yooXxrpNLHXsELPhAIkbCU6g5w0xjEYiJk/Y+6xbOcid
         eXQBhcYg7vL8Bk6btY6bsTHOT6TP4EmPp3Wa0cYQkmjNyTK0l/zlqabGXz3d6HlpMHsG
         hEqVN85kRZAfF9QUC9BElr6Sd3BqsiQwWPyWY3+aoyWhNONi2HhNeyj3zMGwHxFWkYDA
         9D0ZKu0ASNIAP8eO3CZ/O58cfHUvmS5xINZVYWgo9pSAqdIhQXzzg5is1zlnmTfJOg3i
         g2XRWklWpBhDNxG5NhhuMBvSwMiQgWwRjdIaVSRJFZxNcHo99nMN8tLkfIyi3RpeXC3I
         VU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771347325; x=1771952125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sJ2rqxYuKMwKtIc1bHNkX7YmlF2LDfgfhBLsz256tX0=;
        b=QqXJcdh/fv0NfyUZ0TLnUh3L1K9ZZnbVwNC40RVMDvWSjdRNVsncQbqmqzC1eG+LYa
         pyRtkvacaSUJHGJrCKc/2XqBMOi+4MARGDEBj2elwZkRtoVf0mgwuITCF0pKZAwLcVBl
         OF99NHzHDRgHPXq9Jgr98GHKJ+FKACHl59R+g00n45scyujwUEZLYDVUkuFnAmmO+TZ0
         h/WCpklUgnRbrrQGE6TULb9PIczvAUws3OyjayjmPwjmgLkw7ZFKN9Wdenbbd8R6ZR0X
         kRu2GyGpFNxi6YBl4V0fKjVvzX7DdeCf4KAYJWDgalS9Nx0yTfPqPpZRDSl7i5HSnsIN
         Ng6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6PTLyjgyK5mOYzkzEA7b4AoH34IkDO84OSbi/YbhEinGUJzx38owt62KdcK4dP2jKp1y2SH36Kw==@kvack.org
X-Gm-Message-State: AOJu0YzErgYybDH59GgKX40Fnp96qajq/TW1TLNLVcVDHSupVAQFE+Te
	rZSW0PlMlEdrciv65rOokfd7OHcq8gycXEw6507yRuDwaBbrkK0gA93CVD+qmexETEP0CDkWNaN
	wf5tU+E6wJiSk5ekXU6x4X+FFr0i+2o63ZUJB0JFZ
X-Gm-Gg: AZuq6aK+Vrr4mhATIKprdqhA13z88wvWFRWhiE/RGsqP87evHx9idqCf9XO2564miM3
	qaO8c+JmqkFx00rV8T+FtLI5mvyPb7cITas6fW2ShS/LtkLY4viT5pKpgFSMcG58SiXpwbQ2uZF
	fvAoBgSCjAF/uaHcN4AkxWimC4h9e/CcRidWDe9xKPUff8SxvQPFZhtb9fcYNRUS5zOwwwnhEN3
	K7wx2fIgAEY9T6jBQALceotB2Kf0ZD4fzkxwRMi6h+a+jaQlqnfIG/gYDyjFUBmaPWLnlfDbPNj
	/ZlVqzVJVOXgoD7HLzRX7jd8/UezH9Mmh7JVuQ==
X-Received: by 2002:a05:6402:b18:b0:658:1d3:33c3 with SMTP id
 4fb4d7f45d1cf-65c14a4fe33mr56118a12.8.1771347324036; Tue, 17 Feb 2026
 08:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com> <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
In-Reply-To: <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 17 Feb 2026 17:54:46 +0100
X-Gm-Features: AaiRm53xdNxP3D4hVKWPqXGAMAozDOb21HTNRGps1S3nOEwdUFrseEV130fDG9Y
Message-ID: <CAG48ez2mUQ-D3jpPbvdZzcOz16LMXRnzcudOZsfdoftBF5yvPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: xtgfkgk6ergbipt3ex9qj6f4j4ptrzip
X-Rspamd-Queue-Id: 32EA3180010
X-Rspam-User: 
X-HE-Tag: 1771347325-185934
X-HE-Meta: U2FsdGVkX19fTyGsUuNuW9CfBfhMluyonhNCis3Uz3P/U84E16oN9gCphfjuTQF1oASUOuFRt0pzm8I3Z2t2FyU5UmZHI8Lu30HvaLIvSJCUE3z5GJdW6DuFVr+5wMutgNd2lWgWLX9n7IYQsbc2BRv3m82ll0F6yWlXl3aiXoo6JKM2ySpGb80joqoZMy9BV8UaPEy8ouZ5YQej02qhP0aU1D06FXXxU1HkU6dp0FtIjv7B7Woylprm3zKnOuV2GW2kaBfE4Xs3BsXvahXppjal5zY5gop9bv3HWBCUqaqsN71V6GdE2ycZq8G8D9n1OpVxIK0C70swo0mpD567R3PhxCv+9dWStaJneC8dSoF++MlE48p9/4ef39RodEBvrPH3yIUttpq2oGvCbhmm6dvv3kQI9mDgzKW+dBSdiBtbh0vjXtg3uC5BPndr1lWKMHCEJCaZUh5Shcg0wSIjRZpY6U+Hilcs7RwF5dmF4N0jHxufRTge9FrZJD3avcpYqeg1UmoiEoabeQVx3ZygW1F4/UjtpYDzNwkMiiJynuaFM8jBu3L0VdNC3pp3WbEetFKQLSusINWynXHi8m7cvysB/Ul3sO9cshlOinWtrYrq/3ID1hlhKXctvtMuRrq4Xe5nYqQ2PnDfKZ1L3Mouz4HOqRvRt+xtZZtA7WlzoJmGbu+tI2yq6HaSF8gKpBFeEICuxqlAN0luiJHyd9RGPMbm6rAchFnqZ292U5xvUqd5iBZFqovzoV8qOWXMS5Js/FXTudGhg0fdUYvhkvzzHnuQIcEFc33Rr6+jSMuQk++FOqPj8Yd/3s86seH1B1N8zxQ3V/XMaJCub7WhgddmBchUe8rSYvm/v50uY9GpgtolbjQDrnrHvDflH3D6j4f03McGsSSGYeH45l6g+rGA9RlNtD7XqYopL4wwi6Ksk4XPzzaikGOApPT04nRb/bvtKYQT0GjVTvSHqy3nkPB
 /gD8o1SV
 J96FRTB4O2uzNggi3YjFuVUcXORu7QWwY6r+dgz+btPjLJ5i3BFjxzpYZKcoGIZCsd2RNKFC+BOHhS2edbm+yf06SJ1f89FNgPT7BVr28/DvqVmETeI1KtN5V/N1qQO2ciQQmMHSCouUmEBT2ABWE55CvqeWCkT0ZetyqN15A3cyVoIxMUaz7J0cj6JZ/VW2vE8Un0P/zzQPtI5/eXa7bZrqB+5T57De3oWU5pbrGDdccrzM5ICmu1mJuIA5ua1XF81gFixowLmfU/Jvqu4r4oSax3fThZbh2M14yn4yxS9jkDQSA1akJu+iWLyjHurig/+0w4E999dHOKbA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 3:22=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
> When installing missing pages (or zapping them), Rust Binder will look
> up the vma in the mm by address, and then call vm_insert_page (or
> zap_page_range_single). However, if the vma is closed and replaced with
> a different vma at the same address, this can lead to Rust Binder
> installing pages into the wrong vma.
>
> By installing the page into a writable vma, it becomes possible to write
> to your own binder pages, which are normally read-only. Although you're
> not supposed to be able to write to those pages, the intent behind the
> design of Rust Binder is that even if you get that ability, it should not
> lead to anything bad. Unfortunately, due to another bug, that is not the
> case.
>
> To fix this, I will store a pointer in vm_private_data and check that
> the vma returned by vma_lookup() has the right vm_ops and
> vm_private_data before trying to use the vma. This should ensure that
> Rust Binder will refuse to interact with any other VMA. I will follow up
> this patch with more vma abstractions to avoid this unsafe access to
> vm_ops and vm_private_data, but for now I'd like to start with the
> simplest possible fix.

This sounds good to me.
(Userspace could still trick Rust Binder into accessing the VMA at the
wrong offset, but nothing will go wrong in that case.)

> C Binder performs the same check in a slightly different way: it
> provides a vm_ops->close that sets a boolean to true, then checks that
> boolean after calling vma_lookup(), but I think this is more fragile
> than the solution in this patch. (We probably still want to do both, but
> I'll add the vm_ops->close callback with the follow-up vma API changes.)
>
> Cc: stable@vger.kernel.org
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Jann Horn <jannh@google.com>

> ---
>  drivers/android/binder/page_range.rs | 78 +++++++++++++++++++++++++++---=
------
>  1 file changed, 58 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binde=
r/page_range.rs
> index fdd97112ef5c8b2341e498dc3567b659f05e3fd7..90bab18961443c6e59699cb73=
45e41e0db80f0dd 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -142,6 +142,27 @@ pub(crate) struct ShrinkablePageRange {
>      _pin: PhantomPinned,
>  }
>
> +// We do not define any ops. For now, used only to check identity of vma=
s.
> +static BINDER_VM_OPS: bindings::vm_operations_struct =3D pin_init::zeroe=
d();
> +
> +// To ensure that we do not accidentally install pages into or zap pages=
 from the wrong vma, we
> +// check its vm_ops and private data before using it.
> +fn check_vma(vma: &virt::VmaRef, owner: *const ShrinkablePageRange) -> O=
ption<&virt::VmaMixedMap> {
> +    // SAFETY: Just reading the vm_ops pointer of any active vma is safe=
.
> +    let vm_ops =3D unsafe { (*vma.as_ptr()).vm_ops };
> +    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
> +        return None;
> +    }
> +
> +    // SAFETY: Reading the vm_private_data pointer of a binder-owned vma=
 is safe.
> +    let vm_private_data =3D unsafe { (*vma.as_ptr()).vm_private_data };
> +    if !ptr::eq(vm_private_data, owner.cast()) {
> +        return None;
> +    }

(And the ShrinkablePageRange is only dropped when the Process is
dropped, which only happens once the file's ->release handler is
invoked, which means the ShrinkablePageRange outlives any VMA
associated with it, so there can't be any false positives due to
pointer reuse here.)


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD9F8E909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2996B0005; Tue, 17 Feb 2026 10:13:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50AF6B0089; Tue, 17 Feb 2026 10:13:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D4B6B008A; Tue, 17 Feb 2026 10:13:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68576B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:13:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33B9414020A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:13:17 +0000 (UTC)
X-FDA: 84454292034.24.DE37C21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34E8D120009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:13:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnqbbF+9;
	spf=pass (imf29.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771341195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vq2VYtNt9BHHejz5SzYiF9BUmPa65oXSMfvKZWwDMwY=;
	b=je0zmjV0fSf4Sb9BjbVC+vLzvTrI1dLW9xu/PBT2LNOquORDaOrVHmj1Nwm3z0USw61Ctl
	CS64cEx99fRiHRGl/6QOLnEWkSlpcxRecDPNY1JgjhdbrGgtNWUhmWp87j6eCTwJyYWfEw
	e+mCmp5LQ68DktnZDXCFkd3KI5acbTU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnqbbF+9;
	spf=pass (imf29.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771341195; a=rsa-sha256;
	cv=none;
	b=APiQo7SBLio6HCsfyHoBv5E5CrpXyjO83zfQLPen9IpFOA3sBvXKNaJc92Tbgo1Gr4GWdB
	yxyM+ILWIb9oQFw50doFOJ626bOGjjzf4P7JYmqLphqBJqt41j6+/XJlAFzUs3hhOJGhO2
	GAfSui8y+QJLoXvshsMnKaEAjGfvOCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E05B60128;
	Tue, 17 Feb 2026 15:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28159C4CEF7;
	Tue, 17 Feb 2026 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771341194;
	bh=q4lpe0QHbE4GGbcGYoiqsGdbAX3UVPzDsH/s+Fwz5I4=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=VnqbbF+9M1KozvnJynWTRyiwnmd/bz3qGOF+wNTRpsj/o6hVklSmzdEwa+L5Gq0SL
	 VMauwQDNwgydoo5TUdMDL+5/ENQvyE6lwgJKcQrW3Tpr7PpBQaYrc8NAPdh+Uw8Sxq
	 quzTc9Z83wPZVS0BQSCIOiYX0vdT2vaEO88/9weIzA3Qm70l6OcVE3BtI+HldcrbHm
	 qAxZUU8xowd9rWZe4oaaJ3RDzctOWV1r8QNXafUrW9yNSKOULwgLs3RQRNJf4kZwwN
	 7RqvjVOXbBuYrSgjDyNsT89aig5ykpzYwPyx/DTj/G/4FRHgl4ftx0NdZRBxwX58ow
	 7xd2KJRVaaYyQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2026 16:13:09 +0100
Message-Id: <DGHC1OLDIXC7.Q4IAOOSMHIY@kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Carlos Llamas"
 <cmllamas@google.com>, "Jann Horn" <jannh@google.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
In-Reply-To: <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
X-Stat-Signature: etkbm6r7np3zzkzwtwa319tdmmpiu5ai
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E8D120009
X-HE-Tag: 1771341195-58325
X-HE-Meta: U2FsdGVkX19ghtyr0u3GT4fDXzweqscC/+aI2FEix60eKgsQdhZyj45LqhGAZNtoL4Sgq8vboZnoIxA4KHOxxfXsZPKACYs6RYDb5OoJnZ6vpRoJSzkpBh/EjI03xBAb1aVR2O6Dm2uOI44c+8VtpaMP+y+JW+/C0G0gDUYW2m/36gBVmenyFDkx/10FU1Qo473Khe7O1Dj2Y/ZMTZPcx1kLGF1EtXoKDe8i4eHQrnnK247x2Cs26vinmfjQ12KMBFfOQsoJXCQT2gzXGc8cPZw3lkDV0Ty0GpAyPDeJxUNXIyEDlhZssJ48XGXa/GEkgPTZC63rZ1LUANPn00Bsvdup1q3PmElJqOPdQnmsvfwvJlBoo6zFefz2G4z134uiH6iMLvrp588Xk4Qa3iP9XxXlalolAsHSZL7X0NIzViD56O65pOYzC802RCn3PS0CVaSisNyfgypg5VO2eSjEkZpTwpWjSR3pUL2IkWck0+9MvGB1fM/l/MoTVNVTX4wCKFwOI2+QjZKcqt55TIn/jl4k8KnS2q/be+i0rT2Nx37jX01XCcbZXG7APfbXOOPFK9bzPMTDw8qYAWzEmMOpooUENJiqWyUfDcRks+/XQWJkKJe29wPXV2TOjcr66LuhU/jXOr2p+19UdJmcKklLgTRcBUKjZxA23LHIq/MSgAqm6VWiPManx7/iRnWlB5cbA176xELp59gOV4t/J52f6Ijlexitlg7pjP8jYOrd9c3reP7Lsyz5KwSf1ddx1knfcub5UL8TD4t1+sn/7lROJedAMubL/+d0cxCF5jnmu5F7GBpPU7ZHIogYxYsMCEKbxaSs9wGw9w7utOagez3aYPlCrvNFfILkAo8rt3VTx04GqJ24wh0tbI4l+iK2Z80yUgYg7Mg3JMncirqRuUJ/+HHjNRS3B29u48QRYXDjzDXKl0p+qMNxgpkEaSvF+DRpFDuNQpbuULCsf/Y/IgQ
 b6MPQrks
 nsWMyxmIotxjEbWE/e7K0r0zewRPWiKdTuvZYkYnY1nVwbMXKWZxQboSfgThea7gWIYqu1XcWL1+Xp6m+ggwRxk9x3obFFPJ3Ln/F9th75nWB7xxQ8EIVmNheWKXDIPKvNfyrfgZcg55T56IleKhL0Hv3Ns+I4bMWxK8+iOKu27lIvCsuhezcpSpoqfXdqUWUetO2Vc9ppnL8YYS77WgYbf790zuuGcM6T5yeWriew1VPZKOqgLVbG5SeLL9uCtL0Z+kSllEXnsMTKtwvPA/MDRnQtJ/mTLKIUGWXKGDprmr2FMzR5thNnTjleiFRdVoLCP4ICu/1jqCsonXwWT6f5jVboH9Gl5pw7lNn3sDHiElOpZ3mmtmX3vR/9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Feb 17, 2026 at 3:22 PM CET, Alice Ryhl wrote:
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

I suggest to use imperative mood instead.

> C Binder performs the same check in a slightly different way: it
> provides a vm_ops->close that sets a boolean to true, then checks that
> boolean after calling vma_lookup(), but I think this is more fragile
> than the solution in this patch. (We probably still want to do both, but
> I'll add the vm_ops->close callback with the follow-up vma API changes.)
>
> Cc: stable@vger.kernel.org
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Reported-by: Jann Horn <jannh@google.com>

If you have a link, please add Closes: after Reported-by:.

> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
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
> =20
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

Here and in a few other places, missing markdown.

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
> +
> +    vma.as_mixedmap_vma()
> +}
> +
>  struct Inner {
>      /// Array of pages.
>      ///
> @@ -308,6 +329,16 @@ pub(crate) fn register_with_vma(&self, vma: &virt::V=
maNew) -> Result<usize> {
>          inner.size =3D num_pages;
>          inner.vma_addr =3D vma.start();
> =20
> +        // This pointer is only used for comparison - it's not dereferen=
ced.
> +        //
> +        // SAFETY: We own the vma, and we don't use any methods on VmaNe=
w that rely on
> +        // `vm_private_data`.
> +        unsafe { (*vma.as_ptr()).vm_private_data =3D self as *const Self=
 as *mut c_void };

Maybe use from_ref(self).cast_mut().cast::<c_void>() instead?

Please don't consider any of those NITs a blocker. :)


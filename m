Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC18CCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160FA6B0098; Fri, 16 Oct 2026 14:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1384A6B0099; Fri, 16 Oct 2026 14:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050FF6B009B; Fri, 16 Oct 2026 14:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42BF6B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:42:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D43361A0581
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:42:04 +0000 (UTC)
X-FDA: 85329358968.29.A555CAC
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id E205514000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:42:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iFz277i6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792176122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MGdpuHW/L5Zmmr4IQf9JmPKDG4lNfOLKsaZahdnDXI=;
	b=MIxijox9E1gG2uCMU6+zwjiYQvfBeJB7rlbnJsmWJincxRlPqlQoOgCnnI8CC3yGumyE9Q
	nBKi4SKCC5SvLzDnSyWCZ/uviPlXM38HkLYg9sxiub0r044Mw1J7UoAZcMclK/qaAqEZkk
	Pu9Iq68lyuiAp2e9jBP5vgUuqNPYaeM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iFz277i6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792176122;
	b=uYNrNF9cNrlR6qxqwlrPllRrl6GoRmoYsF9FAELHWu7RJKbMkhOBNQwypgmIUBdqrZ4Fjg
	RCOrk6uSQ6IoXy+fE4hMpg0UG44+ask+sugeXMLy2SKUmDzHNBCvBalgZGFGiSauxfO7Df
	jpK9Gp84pkDrD9jtVBKwUTERWUXW/ew=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a021c28046so5575e9.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792176121; cv=none;
        d=google.com; s=arc-20260327;
        b=HoJ/gQE0E7M1t8AU0eJnmaD+dTLTT0g/EOKfYOSTA+lWKnZhEtVrM05U2dxcBLGZNH
         oD1txQSLJNZgotnC00NrAmtqJSyY6OglK+hY0HlmY6NN5viwrpaAp4oG63cM/XdaYlyC
         bgGfnPrNn5gCI5RM2iQLOthNHzJR+R8BSwSC41C1pK8LQqic/EiuOUrhN9R7HFyvw8ia
         rhinOXyYxnsAVQE5LQmpVY4JnwuDK66X8likH9WkZbylSe+qy/yfVs+R57gBlkTpVgCC
         ixia3aRv1prW66wjPXrXVbkIbXLUe0P/11s49b5mebjpej2EMlC/VCnfb/uRBrGEnbi9
         o5/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4MGdpuHW/L5Zmmr4IQf9JmPKDG4lNfOLKsaZahdnDXI=;
        fh=6oLasEdJod0WmwVvBbDxgHTi0d0xXj1IBs3VJuJ94Zg=;
        b=JRUSDmEhlxfkZqAPS3aBORDvvqvCqqslaAc+nfNhMMMoHc2F5TfPN0sD2HlzbHZLmt
         CJxHl2VcVIcJPqKmYgnwYRVi1BrcxwNYPkk2GYNaDxBvsUbADkKf11qdvly3YwIQUUhY
         GkMfPV6gdVwY3DXH3+kdSDAPvyKtICCZAp3K8k/MctqAc4ZTf0GhcQhl3F/ByEl+aJOE
         nx/wKDVCuK4FvP1t6vAgVvIk0KS9cq/ZYbloNn0M+3QZVrvj+kqtOh8SSa/PPclMywa1
         2Dq5R9YDexh2btWkp9hl6KPltyGjChi4Fyhol/cNqMK1hAEz9OQ2jA+ihCL6ZXOPB0Ue
         n7ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792176121; x=1792780921; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4MGdpuHW/L5Zmmr4IQf9JmPKDG4lNfOLKsaZahdnDXI=;
        b=iFz277i6uIof8va8piLT1m54Gs7/x+F6JP1PRqyUyXUM/mcY5qGnI+D5jS/hwxtvw8
         c43NP4+s2zyYRbv/V2mPBkfnsVHfRaESfs1fDFqLiJSr0qjfwhzHIySdGSvVIQh8UoRn
         bTfbKxumCwxDLpOQY3JXaG8q1T3o34iFhW25u5311Jupjy2PzXs637E8U+nWPbpi5c9f
         570FqO37aDwsGrleC/7byF7JtqZ9WHpmo8XFVLOBm+BIBYhmhgEflZfliYkTyFjUKVu+
         pvIVLUVKAzIxVmraaWUvPuCgkDV4DXru4Ied7NOqc7ujeBvtAwz3Egyl455S6LRFTAxW
         CPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792176121; x=1792780921;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4MGdpuHW/L5Zmmr4IQf9JmPKDG4lNfOLKsaZahdnDXI=;
        b=C4/Gpj5QY/+i20j9EwbX0aavUgArz1NvzrWYCjWocB7ewEI3f7E7G38PqKv71TCIri
         gxIBEIxd7JwjUqEO4L/P5ny6wNKReUFj+iTfDHPNaTQsyQkc2cHTLvH+Vf25PSA7auhV
         QOf7K20z1uefu4a8Nza1eQcCYFRfitBGPvOOUlQRwuUutQQSa+1Cn4ZR1EElpKhWbkEN
         Ca/x1r2t55bAKtcJdkNvY9+Rx3erg/rkN1/xrnH6vWo5bJMNwex6Qv4CTgogYeameEvB
         Ta83Sp7DsQktjJdNAfKfm94YvmVSttWfteylaPIyFmQpLZB1UnW/7sbud/6Ma2wU/NTz
         ip/A==
X-Forwarded-Encrypted: i=1; AKwUvBzG53yo7wRaf/TukpclDjRE5CZLabBaV/66Uxo/mHxRSx93nUPxp5tdovPZPkpf/uW30B7SqsK6Bw==@kvack.org
X-Gm-Message-State: AFq9FYJM9cIpWzdnN0V0r2m7YJXpXMHBynGp7eKP7hmubmq3mMZP82oT
	i/PmcmRswO/Yc+wihSYqNEq3RGyuNK2yN49BVOc/xnjyiwdcY6XsITQD6d+lF7fHp58WvcTKJum
	pERyxF69gsJc7aWac/L81WnUC41kO6GeE4P9Yj9Le
X-Gm-Gg: AYBFou0nOY7G0trFx6CR8PQN6uHMRdHi6POcqdMhpc4pNnz8D9lhTF+HUCI0kdZeJiv
	N1T57s62CrzxuDgkJfGoWlZ8WWzHGt5xVprXeEswuB9ngD0ZO8B7qHbTwlE8Xb2jZOAd9DDde5Q
	+4aP6MVBPaW/MzKoaCK9UjfyxnERvghm9ghvlRDxN8hj0qloF/9K+PRVgyZpX6aCHfcjb9tSzmN
	83TJm2PZdIg/loX+bWbWos4oXV9nQ8qnMX766k+YoJy2JklrZvxNEutg6Pe6xI/jGF82ADztS26
	pwH8lq3mALbFU0mP8SaCZy8MsVIYiI9wvdtDLdEhIe39zdOG3OSLbnYaeFwmANcsx8QgpYF2+JI
	c9KZq4KgdCP5FdMB8hVGhCc7MufeGWywJbs8Hl3UqMw==
X-Received: by 2002:a7b:c3d1:0:b0:4a1:d373:5759 with SMTP id
 5b1f17b1804b1-4a1d89362c4mr66215e9.8.1792176120903; Fri, 16 Oct 2026 11:42:00
 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com> <20261016-binder-memcg-v1-1-d659b8ae088b@google.com>
In-Reply-To: <20261016-binder-memcg-v1-1-d659b8ae088b@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 16 Oct 2026 11:41:47 -0700
X-Gm-Features: AclHuK9APEBKrgB4cPVdNX9-JhNjIO32BvrHhv1beJHZa-WfokICUu6lsS8CM-4
Message-ID: <CABdmKX1L36W0aZmhmOgTJTJwoMA+t4PG4ok3++G6Ggfg-RvfFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: page: add Page::alloc_page_memcg()
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
X-Rspamd-Queue-Id: E205514000B
X-Stat-Signature: mpjk6cyzxo656ekh1ip1ecpb7sn1dtjx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792176122-797218
X-HE-Meta: U2FsdGVkX198XWahJKQKa+IJOGG1I9KJpAQsTqghrLLmr0ba+EVcc5fZUd2II/GJ7yf5oufWetIpOR6f160BuGkMPYeiX/KIs8YIuPloIljV01r1ovCfmDuEOxxiW4uXdna8Dy2hZohY34lJ23sbzzxO4zRKsfXn0uxbSzbMeDMqqPwU32NU3N+j+x7uKthLcHAJsCG45HUd6uaMu5ifahDpmEdnGQFUA9VRVj4QCu35YszsCSFphEFwfLpS+CyRVNhQJBgdA8rB+vQEj6yvJjJDE8PsFpOSQXtPWy0c5kMmp4kyrR7S/OgU7xq3lZqzSw3vWWDX5R/2Ac0dBwpXgQ/GIhM68Em+tW1nI6RSDOpMOjGqlDqwy/mTZ/OXZl3Vz20DEEdEKeJmrpMyt3+/BsiyzMO6lLBfVDwUfa4rngAWZBySZBo/7hTe22OD31y7l2Qa11kTSKVUqUuuYDnEVQ3Ow2Azsv8uFFPIPLFrRdzCmrl0CWJmYqnObxiXGWGJSOZofDZ9DnymBjjvK7SER5hTiePGb+u0BPS2iVv1EFjSPNk+stsh7xEJZyU2EzWMs9DVeOsrvivGN0qZUUQGF7JKhEIZoTYitiFfjM9EfvD+HuUcokEGeQ4HztFYssS1IHn9vafN8ry5nmjxDHfEy6RH73MeeAVbrrNo72RX9Ag6BQknJ1D+0Lq3AR0mmVtkAAXCrbCRXY5YHZLndGbR8cG4Ss8rQcXoNmE4/sieBnK9ZNYB5ZNrp3jYMODdqb9zdg0lD65Gki0zVOeu3Assi2uqbhfAzjjADT4No7s4uhf74vGHZyNQY/GO/eaovNns8ZX7Tj07ACTmeG+qN/qanZxHpGsGHVQQnjkyv6OH18n04BR607jsvtpzoRFyDZiQukArcvoKmMfDEMSXpci+3gyyQ+mf+ZFSq5sJexuDCd5YuPqmQwaRofDagneXXXxPFHxqC5KU77gQq1dp//b
 7ODH2/ao
 3c9r0zQ/94WrS59lQwPESP3nwnddJoNUbm/BklT3LhOdUn9KkzpM/tNypnMR+HahVNkFM8ZoYKuDHaqufpiVeKlxs54EqFi8GjEapQLDwMQt0V2D/8teLEmv9ooJvRg8aScMSgX7ofzu2MpzmfSCVi7Av3+bTqovcGTEt/nChtZ8zwmFIhLnQ4R/ifza2HRr49pzMcn45SOLK7QN7Wj91lLBfWo0p9nMlObT29vG+sQ8fQDM5OlDRbBKyeorN527ozLe38iM1cYw+WoOlHpOKBMHNC23QWX+v0al1JOGjZUhSgZF0qMwNXBiAbaWlA+Ta37F6LqtaXLxuYQ707xKIa7MssCdY3XK8O4Lm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 6:30=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Pages allocated on behalf of a userspace process and mapped into its
> address space should be accounted to the process's memory cgroup. Thus,
> add `Page::alloc_page_memcg()` to charge newly allocated pages using
> `mem_cgroup_charge()`, and switch `Page::drop()` from `__free_pages()`
> to `put_page()` so that charged folios are uncharged when freed.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/helpers/page.c | 17 +++++++++++++++++
>  rust/kernel/page.rs | 50 +++++++++++++++++++++++++++++++++++++++++++++++=
++-
>  2 files changed, 66 insertions(+), 1 deletion(-)
>
> diff --git a/rust/helpers/page.c b/rust/helpers/page.c
> index f8463fbed2a2..145758a8a954 100644
> --- a/rust/helpers/page.c
> +++ b/rust/helpers/page.c
> @@ -2,6 +2,7 @@
>
>  #include <linux/gfp.h>
>  #include <linux/highmem.h>
> +#include <linux/memcontrol.h>
>  #include <linux/mm.h>
>
>  __rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
> @@ -10,6 +11,22 @@ __rust_helper struct page *rust_helper_alloc_pages(gfp=
_t gfp_mask,
>         return alloc_pages(gfp_mask, order);
>  }
>
> +__rust_helper void rust_helper_put_page(struct page *page)
> +{
> +       put_page(page);
> +}
> +
> +__rust_helper struct folio *rust_helper_page_folio(struct page *page)
> +{
> +       return page_folio(page);
> +}
> +
> +__rust_helper int rust_helper_mem_cgroup_charge(struct folio *folio,
> +                                               struct mm_struct *mm, gfp=
_t gfp)
> +{
> +       return mem_cgroup_charge(folio, mm, gfp);
> +}
> +
>  __rust_helper void *rust_helper_kmap_local_page(struct page *page)
>  {
>         return kmap_local_page(page);
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 1c0796ea229f..7a36b7dd6c9c 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -10,8 +10,10 @@
>      bindings,
>      error::{
>          code::*,
> +        Error,
>          Result, //
>      },
> +    mm::Mm,
>      uaccess::UserSliceReader, //
>  };
>  use core::{
> @@ -195,6 +197,28 @@ pub fn alloc_page(flags: Flags) -> Result<Self, Allo=
cError> {
>          Ok(Self { page })
>      }
>
> +    /// Allocates a new page and charges it to the memory cgroup of `mm`=
.
> +    #[inline]
> +    pub fn alloc_page_memcg(flags: Flags, mm: &Mm) -> Result<Self, Memcg=
AllocError> {
> +        let page =3D Self::alloc_page(flags)?;
> +        // Note: Charging the folio with `mem_cgroup_charge()` only work=
s because `Page::drop` uses
> +        // `put_page()` (which uncharges the folio before freeing it) ra=
ther than `__free_pages()`.
> +        //
> +        // SAFETY: `page` was just allocated, so we hold the only refere=
nce to it and it is not
> +        // yet charged to any memcg. `mm.as_raw()` is a valid pointer to=
 an `mm_struct`.
> +        let ret =3D unsafe {
> +            bindings::mem_cgroup_charge(
> +                bindings::page_folio(page.as_ptr()),
> +                mm.as_raw(),
> +                flags.as_raw(),

I wonder if we should we mask out __GFP_ACCOUNT from flags? It's not
provided by the new caller in the next patch, but it could be included
inadvertently in a future call elsewhere. The VM_BUG_ON_FOLIO that
checks if the page would be double charged only happens when
CONFIG_DEBUG_VM=3Dy. Without it on production builds, folio->memcg_data
just gets overwritten. We'd probably catch that eventually in a
CONFIG_DEBUG_VM build, but not sure if we should rely on that. I don't
feel strongly, just


> +            )
> +        };
> +        if ret !=3D 0 {
> +            return Err(MemcgAllocError::Memcg);
> +        }
> +        Ok(page)
> +    }
> +
>      /// Returns a raw pointer to the page.
>      pub fn as_ptr(&self) -> *mut bindings::page {
>          self.page.as_ptr()
> @@ -376,7 +400,31 @@ pub unsafe fn copy_from_user_slice_raw(
>  impl Drop for Page {
>      #[inline]
>      fn drop(&mut self) {
> +        // We need to use `put_page()` instead of `__free_pages()` to pr=
operly handle memcg
> +        // accounting.
> +        //
>          // SAFETY: By the type invariants, we have ownership of the page=
 and can free it.
> -        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
> +        unsafe { bindings::put_page(self.page.as_ptr()) };
> +    }
> +}
> +
> +/// Error returned by [`Page::alloc_page_memcg`].
> +#[derive(Copy, Clone, PartialEq, Eq, Debug)]
> +pub enum MemcgAllocError {
> +    /// Allocating the page failed.
> +    Alloc,
> +    /// Charging the page to the memory cgroup failed.
> +    Memcg,
> +}
> +
> +impl From<AllocError> for MemcgAllocError {
> +    fn from(_: AllocError) -> Self {
> +        Self::Alloc
> +    }
> +}
> +
> +impl From<MemcgAllocError> for Error {
> +    fn from(_: MemcgAllocError) -> Error {
> +        ENOMEM
>      }
>  }
>
> --
> 2.56.0.212.g129ede20d9-goog
>


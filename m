Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE5CE9A047
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F186B00A4; Tue, 17 Feb 2026 15:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606BF6B00A5; Tue, 17 Feb 2026 15:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512AB6B00A6; Tue, 17 Feb 2026 15:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFE76B00A4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:13:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD1568B364
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:13:12 +0000 (UTC)
X-FDA: 84455047824.29.59317A5
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id AA9D8180015
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:13:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rLfUQ2FL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359190; a=rsa-sha256;
	cv=pass;
	b=bh+BFQfizxk3o5DYjox1xEKrFPwuxi6CKnaqhJ7BZWfvCH+5qJEL0YTwaVlNixW8+r+HVY
	VMzYmgQkzBJ09gGxoTlboLSmobgB9ebeqfRSPTENXrweCicO68RpB4fj7qE2cwAuJDJj1F
	WdDL8YQ1+JzqSKej5mWHr7MkOCwmoRU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rLfUQ2FL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvSItU0sreEL4B15MgR7qAnJZMB2EOXjlw60m4SYry4=;
	b=DeltBbZIhzv3DQPBEI3JXLa9gk/KTT8Kw5b++DKePCsF4kbjupJNfEv5OeFs9Zo3taUtUr
	uRlwHZpT/PxlHqvFEizu+B1J8WVxJnBG9l2Km8saRtI86WLVT4lwJLOtIDDIC8qdHYB7Jk
	PuD1ThiDGufmYJm2bxv9oBMD6LF/PT0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48068127f00so49097325e9.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359189; cv=none;
        d=google.com; s=arc-20240605;
        b=dqwvV4TzN7a0M1LaB991fP6CrnoaKPNvbrsoSRtlXNVypnFBSNbhDhUyclNe1+QuMM
         pjXLQRQ0qtpuNxAWexEYMso23yhs3/TR81/ypoEfPaofj5DVemr2EdOV34OjzcQ2DZnQ
         WxIVLMM/FA3U+bbNUt74WGZusjGc3r0ya9YohknO6Eaj0icvbRXBNzC3Tvc9x8L6RWL0
         EMVKyPfO/wGw215OjgnlqD7t+ONFVXdZzqPQE+CA5rCjolcM2GyLUVMPrNfONvZGLjwf
         ttR2t+Cp4UrSFOrZvnLnvFPySZXfv9bhzUy7FuKoWTtBTTvn5JHt7InJYdHzFgaY/Z6k
         koCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CvSItU0sreEL4B15MgR7qAnJZMB2EOXjlw60m4SYry4=;
        fh=a3M8pJynZ1L+f3S6fExDGTAj97QYsqgWYRiZ75GSrNk=;
        b=A1sEgsZJKGPRR9c1hlgKX+Uupmiut0/8CpevebKTqzHNjxWx5uLkoAD4TVvCBF2/aj
         9foms7O2dzn925aMgLv2Vucokb4Gt81aoMewAmPFGZZ4bYekHIaidzAQebxssp0nxc1M
         bCXQ/38ZKrAq1oGgr4y0ioFIMVxuL5d5xcSggECOV/WQe4uZxOv7MbDZNXeWrT/1otgi
         CxmROZFqxEuRJNOjNnP2cBIzO8+SHjXynjl5p7NC8h+drPjoIUMXSUXoLo8crEqRHw3W
         RoKs6Zlzt5L89V6u/zqIqZhebmpX17UMXHQ1AGb/APn0BhJPr6aQd7e4hh+X8vkHiwdd
         +YjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771359189; x=1771963989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvSItU0sreEL4B15MgR7qAnJZMB2EOXjlw60m4SYry4=;
        b=rLfUQ2FLX/4J+Hz1Hmvm51sboohrOGfvbHptpNH7TjT4AFsMS7+OJEFT0le157G+2Y
         zmwAMMFc9L6k7hqfVRCAb3vbgrIhaqPylp71YFUAxi4lF3anf9z6zLkrTHQMUNtrf5xg
         b32SPDOmvQTggj3sRYKfg9YYgAd0cMollyK9Jo+TeuLQt3sFheqPUmAhdydaOgZ7YMWM
         vBCSCAI7XNAS/Lomgl8nQRgUfFhjAd2xc52/QamVf0XHyEJzCb/5P8mNZ8misXwKabFX
         aQGmArUt81iIW65J9fKJsvJ3h0anRss/TcMVVCgxg9NdtOsoquO9FokLEtwmH9YEV7zn
         lpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359189; x=1771963989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CvSItU0sreEL4B15MgR7qAnJZMB2EOXjlw60m4SYry4=;
        b=eQtlux6BLNBtQU4ZoEH9vXNrsmV8+AC+y88yM2FVzIBaPCWbagNL4SSwJWMnUFYggG
         9iX2IZ5Fa6UFNfS7nGqP/6acrNiB5iXZFwoY/YKGQVB04sp8ARojTkw6NjatSEEzoHy/
         /b/tvVtf0sVjqUT5S34ov3rsOZ5kIqL7nrpbtAyBjHArGVJHwa56pk6x4glxbL1aCd2/
         qJmKDobPj3FHrUcK9Eenw2qpJzHtDUbBSYtLzq1vfMzOsb326TLB6e8gfM6J2MQjzYU9
         Mt5ArTkUIPLsJGcvksGh4xBZUihFD04rFMauvgQ01RCZGOOI9VKGSNI8xASzN50kVlR5
         SBzw==
X-Forwarded-Encrypted: i=1; AJvYcCWyrZTu8DNroWUJdgGwEKJMYI61kHLiAlNuLjY82etshaj4VMO5vUP6sKc0SsEHTDm7l8k5FQQiWg==@kvack.org
X-Gm-Message-State: AOJu0YzpSW2+jYnCAZmAlYVKahsKAQqtf1PulK8w1wiQVvWi6x79wHui
	NfBXUEEj+LrPy46Ai6gZRmnU9PneOj8MOXUCwfYxeshhSfoRvXvWF0uT7PeSCfREytKVHJq8YJx
	OLshv3bSUgrlldAHeFDPW6imAmcVVQQFMsGnmgRLL
X-Gm-Gg: AZuq6aJ6lip3EgDA56/ATc/+BS/XZ1RB5BXkepnekYi7Gn3vr6eccIG0gKO5bgHEajZ
	bMYHcpXfiwMHDIMA5n3te3FrCsWJ5M3PyLBAy3X2fYUO3dqBp1Ax49j3Pg3PNyn6+kuGPVCFt0Q
	0Uxh+WEcSssM6AkHQD1Pt2F3P18/YUoGcVekOCCzucxRsgXFUgibqOpXzQKuPH/Ceio+D5CdN5g
	htnUM06Bp/sGVDvC4NfMXsB8u08sVfnKb/qxf036kYUi1t2aBDxyI3hyUZciAobqO2ALHFn/KsK
	CZs5Omc9YMilc+ju7CXBIij4Q80rE87R1CmgHaYRCpv2WwZV
X-Received: by 2002:a05:600c:3496:b0:477:fcb:2256 with SMTP id
 5b1f17b1804b1-48373a5ba90mr257612055e9.17.1771359188669; Tue, 17 Feb 2026
 12:13:08 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com> <DGHC1OLDIXC7.Q4IAOOSMHIY@kernel.org>
In-Reply-To: <DGHC1OLDIXC7.Q4IAOOSMHIY@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 17 Feb 2026 21:12:56 +0100
X-Gm-Features: AaiRm53IBeHjKaJgOILHNfxfP3AsdI88i44Wfx6908SXCYMlXXgAxRb7b8ZWSRs
Message-ID: <CAH5fLgj2+XUzsuAnvwL=dc=5yOZvXCapBWRbFGwJAX2v5Wk4dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
To: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AA9D8180015
X-Stat-Signature: d8nup11uqudmk31gra3qbmr5gcozh4k8
X-HE-Tag: 1771359190-527577
X-HE-Meta: U2FsdGVkX1/8TEuDYnSqy9jko3OFS/CYCFqOfnexwV6Gr+OB7R4tWA4fWSrBCbTb2HLIKteyLFkJziNz6pYcQ0ZGpz3XMwkQ7sVq0N41fTo1Tfg5PR6bQZSXi5QSXGnTIMXOlAsuD1xbW2BXwCabrjm4lVr9C4t6rySD7y9ULk1c8ZMmSysChtwMaXTi6UCyQTn38XEjx13HTQ2pNc+7CxhgkcKYRotMOzjkcaeQSa8dIutdx4Vz/DE8hz9kKIorhi8jpf1le6PyfWuOgj9uu+qIHXAjECYD9jQjtiecCkM0wehWLQYamvbU42C1HPq255lLu2eygEGu+HUd522/6vkBc0ybg1RgUMHh9a6FU/jhIw5UVBEWlMdtl+qA5/lHiDAQg8+hMwZtVVE/0Vb6kzBREcUUUiRAOv6ohLUgLyrbst9sKATKLgEWT2Ko50aGR7TkdTlMrUl0OfzwCha8FU8GwN4qBVkSmgemQyatWJ71T5bVllawFQOvsrxXMrnQtfKdQXaRCCMtaM/1MdB/FeAZGJthikg/aXFdHtWsl9xeMXuLiGtwQ9XcYyMxpbMBm3qVam2fylPgFP24t7vR0hlO4aw6leG/C7AE6TJJBBhKpf/8RY3nsCuB3qdRyQ3bu1jPjS5sr73nfy2PnL4Z7x2OACGuTQEW00StsaIzpYXTmFDP1pf0dDRzsYkNNfif2fQZhX4oSf58TICSVLRvj6riPhgBBpfid70aVcZwd0pIUiWKOMIslRs9LUz0AacUMLwNt/ZQLvB7E+y0LOpQXf0GNruZkQn2W7qh06oEgDorF9rLZ4mSw3xogAX+8V+Rk8r0I0tx9ycRNVQ/lXbDU9y3gD0+XObLd+vtgrssiuVExzm44/fb1VjKjHLShVZuve2exslEBe5Jr6QqVTnqUX23m8su5JthbyoVUJqsHlfdZkelQK/XzLiUHzMA+u5FOdurpbA7+YrhbUT338t
 v8LlRGvo
 hHrmTWCI1EhplHuqQTX4kQaJDThY1zpwyeYT4ZvtCZlxV2xgVJnriR5f0g9TWzSlR7iqRfcJ52O3z2jocRjQPYyG3Y4sLPo59HQnINQ+Zqz6JpNI7HLF05J6mvhYEhGJkONEYkoAOAv8Vy4wFjgkPQ0fTE3T6go8XZItOiRgDt1ocegNAZ67lhAe8u3bi+pvcqY4ZLBHTPsjqhRwA/H0CuOYA0vT5BZPz0XEC2h6L6/3BFqQjUYDvelg2rTv4+WbTnV64r+jIqqazwa4NDjtxWWGGcElK5vOuUiHqD5h/so62zvlNEUFbZVkMmeg4DyQFOtIHtQRZSgCcMBU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 4:13=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> On Tue Feb 17, 2026 at 3:22 PM CET, Alice Ryhl wrote:
> > When installing missing pages (or zapping them), Rust Binder will look
> > up the vma in the mm by address, and then call vm_insert_page (or
> > zap_page_range_single). However, if the vma is closed and replaced with
> > a different vma at the same address, this can lead to Rust Binder
> > installing pages into the wrong vma.
> >
> > By installing the page into a writable vma, it becomes possible to writ=
e
> > to your own binder pages, which are normally read-only. Although you're
> > not supposed to be able to write to those pages, the intent behind the
> > design of Rust Binder is that even if you get that ability, it should n=
ot
> > lead to anything bad. Unfortunately, due to another bug, that is not th=
e
> > case.
> >
> > To fix this, I will store a pointer in vm_private_data and check that
> > the vma returned by vma_lookup() has the right vm_ops and
> > vm_private_data before trying to use the vma. This should ensure that
> > Rust Binder will refuse to interact with any other VMA. I will follow u=
p
> > this patch with more vma abstractions to avoid this unsafe access to
> > vm_ops and vm_private_data, but for now I'd like to start with the
> > simplest possible fix.
>
> I suggest to use imperative mood instead.

How do you propose to reword "I will follow up this patch with"?

> > C Binder performs the same check in a slightly different way: it
> > provides a vm_ops->close that sets a boolean to true, then checks that
> > boolean after calling vma_lookup(), but I think this is more fragile
> > than the solution in this patch. (We probably still want to do both, bu=
t
> > I'll add the vm_ops->close callback with the follow-up vma API changes.=
)
> >
> > Cc: stable@vger.kernel.org
> > Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> > Reported-by: Jann Horn <jannh@google.com>
>
> If you have a link, please add Closes: after Reported-by:.

There is no publicly accessible link.

> > +    let vm_ops =3D unsafe { (*vma.as_ptr()).vm_ops };
> > +    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
> > +        return None;
> > +    }
> > +
> > +    // SAFETY: Reading the vm_private_data pointer of a binder-owned v=
ma is safe.
> > +    let vm_private_data =3D unsafe { (*vma.as_ptr()).vm_private_data }=
;
> > +    if !ptr::eq(vm_private_data, owner.cast()) {
> > +        return None;
> > +    }
> > +
> > +    vma.as_mixedmap_vma()
> > +}
> > +
> >  struct Inner {
> >      /// Array of pages.
> >      ///
> > @@ -308,6 +329,16 @@ pub(crate) fn register_with_vma(&self, vma: &virt:=
:VmaNew) -> Result<usize> {
> >          inner.size =3D num_pages;
> >          inner.vma_addr =3D vma.start();
> >
> > +        // This pointer is only used for comparison - it's not derefer=
enced.
> > +        //
> > +        // SAFETY: We own the vma, and we don't use any methods on Vma=
New that rely on
> > +        // `vm_private_data`.
> > +        unsafe { (*vma.as_ptr()).vm_private_data =3D self as *const Se=
lf as *mut c_void };
>
> Maybe use from_ref(self).cast_mut().cast::<c_void>() instead?

Honestly I think this one is easier to read as-is.

Alice


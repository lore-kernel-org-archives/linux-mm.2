Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EB1EF48C9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 08:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D0B6B0005; Mon, 16 Feb 2026 03:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0E16B0088; Mon, 16 Feb 2026 03:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC5E6B0089; Mon, 16 Feb 2026 03:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CDDA6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 03:52:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAF65140BEC
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:52:05 +0000 (UTC)
X-FDA: 84449702610.27.0FC7392
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 154E4C0007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:52:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LQxRIMef;
	spf=pass (imf28.hostedemail.com: domain of 3stqSaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3stqSaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771231924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjj5IXbObxNi606Z5qjJ0Qk+HGDfGi8eP2D19UZKb1Y=;
	b=DXONK09FsF66cy257v0VFm7g5rr3QvQGhHWX9Su4CIUKXTBnHfliwpn3VFK3akOezSzX2c
	cTrxY9bzwwhlpV6njE0KX1G3aVgmSrDakCvUPKRZmSmHCHvOkJUXrvmrA8oHc16a246bHl
	U0P//88xdYwogbsx7ozqXtuxl/FSZSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771231924; a=rsa-sha256;
	cv=none;
	b=YQssJ0+cQJZD/oS2sE3kq4oPt6LuhrB+xH5PnlgQFTH/EoWzmVFVGRjp6BE6SSBFz5cgF5
	K+kieCoutCzWBlN7qFTtw70BZEZpu6ogxnTXjsZFzdUVqPH9F+yYGMQMKRyK2Wy7Vdq7fJ
	EzCjOFUP0/jpekPtWBDZkXT/BpZi8/g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LQxRIMef;
	spf=pass (imf28.hostedemail.com: domain of 3stqSaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3stqSaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4376ec2b1cfso2055372f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 00:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771231922; x=1771836722; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kjj5IXbObxNi606Z5qjJ0Qk+HGDfGi8eP2D19UZKb1Y=;
        b=LQxRIMefCZaS4WeGt3WRfo1bzCTWFV9hqVt5M+yx73gj+bnwzfS12WECbrBqgIds/I
         mrYLc3r4Qhxzk7EaLEwfyb9OoZitm0c7KQ9anjVD+18tfMZmfNl0Qf/xeQsGN77LuBUL
         X6L3uyIFXb+d9XR1k/+WdeXBbGvoEciaXXlAXV8lcg/HXxsG97vd324MK7m9UpIhm9WB
         mpizQ/8jXZ8396TfBgxEawbwlHVR4OkJOg2yMxS2JHSRv+LVSqEp4069OOs535pPk2B9
         na2jviPh9BVx84uoXUjjBPlaiJs4BAPTZVoxB7uXVkAOpNwJSweP/v6b1D0O5lm0HsT1
         ibBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771231922; x=1771836722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kjj5IXbObxNi606Z5qjJ0Qk+HGDfGi8eP2D19UZKb1Y=;
        b=ZUWrAmi281+oyysitwlVk8EYshuA7rCU+8flMeipHF73Vk3A2qrNFIx4Jo6dJ7jWkj
         jVmVMu7RCUPgIJV/MgemU2h5vCNUYaKIiPXEk2DdDgZeLkm7Jqh4nHX2sfKawAWQosPt
         P55ZU9PCDC+6m2VeynjuVeDZ4s68hw8t77AFoflZHIWgb37EefSorFBautnHMCfV+rb6
         ZP2MZOmGLzZXFwtr6emmgoEJiZ60QXkaTokYcEUZcDTPwflNxFzrLVXLSU8C35Fr4Vle
         H16aLPV9pTDBPpw6Hv2kujnW1fK9G1E5j1uXtlnpKlQYsxnFNBR/bW1JYiGuaa6O/Amr
         8Rag==
X-Forwarded-Encrypted: i=1; AJvYcCV8iipIZHci7oeItf0OC8R3sQMazEgvIcriR70b5wQb7Gwcliu7AEovhFfXy5fg89nk2EUscWAx2A==@kvack.org
X-Gm-Message-State: AOJu0Yycwz3eHSl0TbuIsk3paBBIpCPhP6SVks//e6qwnUyo7igaUyGO
	IqXW+QUPDUjBY/0pEVGWeyPE9AohzApHunD+w0QYcIPK8ngSbHKl+rH5m7ehjqmMeCQQIkY5JR/
	4YtB2j/f4LXl3IbuAXw==
X-Received: from wrvf7.prod.google.com ([2002:a5d:5687:0:b0:436:d0e7:35fd])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:240e:b0:437:6906:8235 with SMTP id ffacd0b85a97d-4379db2576fmr11778027f8f.3.1771231922263;
 Mon, 16 Feb 2026 00:52:02 -0800 (PST)
Date: Mon, 16 Feb 2026 08:52:01 +0000
In-Reply-To: <20260215-page-additions-v1-1-4827790a9bc4@kernel.org>
Mime-Version: 1.0
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org> <20260215-page-additions-v1-1-4827790a9bc4@kernel.org>
Message-ID: <aZLasQroRyhfiplu@google.com>
Subject: Re: [PATCH 1/2] rust: page: add `SafePage` for race-free page access
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 154E4C0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d1gn83geykf6oreg3jsd1ff4n7o1gztp
X-HE-Tag: 1771231923-818464
X-HE-Meta: U2FsdGVkX18NtijIYbH5P4qMsjNTOKGQak0l/L+47cj4Uq08ItNjutrWNYqRglWigSj0bWeyCOiQpbjVwOM/6ktLqwHETBD28DqK7TRFFhnR98W6lphVwIECMcgRGX3ztuj4hgRAEuVOjef+ew6zUaB0UzmmJfLp1GtoF/4/3R19Rrt1b0mcZ1Rwj5aMh0244W/yVRpb+O7XhbUK8rLNTLMVg1C6I2TnviQZbYh7du+ZbceVQGWakkKLJuZUMtDailT+IvifBc1TJJiHXRTLqx5UwZOXLLHnR8m8NjIiFlt5ZTo8ly9F2r1LzU+cWdflHxUo0wnpFHwKP5ICcdI8EIXiZQwQRHG1maiqcLIEg3IxXcYORbqwsVax78iAStC1yy76WJEF0uvhrImyMTPhaACeDufH5kTlzvnJn6HKCUK+vi5bNJAvqRbw9jcJiSTFyvKiaMU9lObZNVgjNl2GMdRaqbOZEFanOdP5XdS0hV7/ASRFKpbI9SlFkTsgkBBzGWdEzV80nJ2hmlBIymKxhPUyUj7w35KS6Ambh2MrTph6lcBxZBe0HTnF9edfC4P7H7uDnUU6NMMyXp7QSKHaCuUR/JqzO5c7oR3G/sNlJVknV5k8twukM3jU6mXviVREpaoOmJuP7s2HuT+geHMf4IgTxP3+cBu7sLUVX4BoKqW78I5QN+JhGPa/iPMt10FYs3Fk+4Jy4FNOSWA9gEslVuxPTPlaXi7gYhkXO3UGcevOUZGebLZD3rwMdVRmJhqj3lUcugJ1jK8Iwld0cJoZi0zStCnx+mtHNsLe9uF8HC9wdOmA8oRoJXEzUhFeNPlX6LfBQl9kxtdanCN0tJxCO1F7Jow3gyG+Bik1nJP/ewuOfgZboLtIt6N3twXKATRaIFPy4wXAKXOipYmW/X61s4gTgrFguEAYaxhgOrn3dMXbYkmfrSiqqp1hZQbbfa2f+FDibkOtjN6nf19AvEh
 Pa5karcm
 +YknHJSpqvgC3l47g0kstvhmESsG9OAWWwQyzOSCITmfaKKDwexjRPPAtHTqk31q6QGPUW85UiCy7HaPp2/opH5CrN8kjzImcQpxbEs5sT8i+8DKR3t3X4QRFjcX2CFl5oVUru9UE1bqBEA7M87skRW8+zq+QlWIHDlYyYLsVYa0/nHy20R0QzXGhiIc07GPt/LmkWtk3h7R5epyg00LwXm8ihB5biNXSLOvQSiTiAUzHGUanrWbUV3jLoBdI3JXW68RAR9WJNbDuvbAgqOBgwEKuwdG2OgZ3VS08OTFWKL9AY7IHXsXJMughS6DBcdVUet/IWHgihIOE/ZRKUtNAPxqOlkCDpA7AQ+aGdYl84Ym0i/6URtun8oMK1O/+X6kv1Pwt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 09:03:30PM +0100, Andreas Hindborg wrote:
> `SafePage` wraps a regular page but adds an invariant that the page data
> area does not incur data races. This means `SafePage` cannot be mapped to
> user space or shared with devices, and it becomes simpler to directly
> reference the contents of the page.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

>  impl Page {
> +    fn alloc_page_raw(flags: Flags) -> Result<NonNull<bindings::page>, AllocError> {
> +        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
> +        // is always safe to call this method.
> +        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
> +        NonNull::new(page).ok_or(AllocError)
> +    }

Could potentially just implement Page::alloc_page() in terms of
SafePage::alloc_page()

> +/// A page whose data area does not incur data races.
> +///
> +/// [`SafePage`] has the same usage constraints as other Rust types. Thus, it cannot be mapped to
> +/// user space or shared with devices. This makes it safe to reference the contents of the page
> +/// while the page is mapped in kernel space.
> +///
> +/// # Invariants
> +///
> +/// There are no data races for the contents of this page.

This isn't really a great invariant. You could say something more direct
such as "has exclusive access to the contents of the page".

Alice


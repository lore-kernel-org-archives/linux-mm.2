Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BA4C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755E16B0092; Fri, 11 Sep 2026 05:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF496B0093; Fri, 11 Sep 2026 05:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8A66B0095; Fri, 11 Sep 2026 05:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24DE76B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:20:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CF04A3CBF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:20:04 +0000 (UTC)
X-FDA: 85200934728.09.95E29C9
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50620100002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:20:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JVWNG82b;
	spf=pass (imf14.hostedemail.com: domain of 3wMejagkKCDsXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3wMejagkKCDsXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZtTwWLqkTlApSCCjwtFSfuFmwluELYL36xqCuH39yY=;
	b=XXC+4gNVHVAKFzhus28RpmbvSoVzHf/XJglpf1a8rFd2I1JRKZ3fwOIyfE9qC4xpOCdFwf
	spqHF+mUkTb2o3aZo3IHotGESAk8ie06/b9UgJBGR2U2LtL/L4XQvJ5r76NUQ1XxttyTQJ
	WI+TgKEeKK/18d8C3Pyoc57FzukQmLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118402;
	b=d5IVaRAiZXC0N8ky56FVdQRp5mHjtMup/NQLSumFfJD2+ylFmEVRuWu9yMJ0U3E4VPku5V
	pg6xyuoWp7hS1Ds4d/m/8vHkWEJpjud+DybsKsk5KSMnkjMBP2ILAqXSAHUtTQxh02e88/
	cGRvZYkjgXu5AqjP8lCjxcbV6AC1YHk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JVWNG82b;
	spf=pass (imf14.hostedemail.com: domain of 3wMejagkKCDsXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3wMejagkKCDsXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so6132645e9.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789118401; x=1789723201; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NZtTwWLqkTlApSCCjwtFSfuFmwluELYL36xqCuH39yY=;
        b=JVWNG82b0uXCgpgXNPetWnOrAn2ez2mgqqeSXfMnAHojIBV8gmAMmshQVNU+B/ILbD
         jhcr399VlPhSSQrSm0ZYpSa6rgc5HpA2KpeAP9z7Cw4TN/lrxyLIGHDW0yqjM70GPdsU
         ackIGkAk2D9hYY2QLnKR+v9p3Zisg7ddrBQ8BwsEzi5a2UobYOZf/bSCx5dmI35xeZfo
         dTgjEw4LYfWiZ1REivsAzx6amZdiYAjkTCcjSp70LMaRO7JrY77N2cwj/JqPJSjRBIJR
         8+91VOhGZPftrng7uBW0Ly3mfhi3LxQ9ec+zCZz0A/exEULT64DrOxfWbxGp3lTBGyxL
         WKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789118401; x=1789723201;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZtTwWLqkTlApSCCjwtFSfuFmwluELYL36xqCuH39yY=;
        b=XbS9bRW5e+sD/zrwYjBsGU+0NmlgRoZ8a6Qc+8cxLvbXPMz0fwi59hPopZkjxAK2s1
         wFB2/bBtQl10oUUZioZrh9xlYy9Zf3toy4POxvYPR1YGSzdvYeoMWqHQhcLYMRzSUlVw
         oDWWLMaaEq8AihReDYJ2KedfK0iVEKeubyhJMfltgBEotown/OHTfQxllg2RbhXVnDI5
         TZOOGk3okT5wv8KYKKlN1ZuMhIarY+Mpm839Lfxk5zqYxW6mMMhVmJMyBxZ7PbbcO+km
         fzBbRipQN4VJocIVyqjsRvBa7Pssc+JLsaFbeWbcYItHuTHgel05bwNaiQBH+QhS6fZy
         oyvw==
X-Forwarded-Encrypted: i=1; AKwUvBwJ/wNoDbDtTR+3fpy9Y0NAOnmmLO1gyAnGfMVPCk2J9zuNp/xqRH7zATLAoJmEJxnfBn6QjUxACA==@kvack.org
X-Gm-Message-State: AFuF++lIr2ovr22A27jdA98TPZsiKYuSkVNoOoto7iY8rGk+o2/HW7qz
	00x1d367AeDwDBQDDDnKrrvxoNZc82wf3i4tIsNCZyLu1+O9R7gTAoQ2MXUKDtzMX+KEfCv1fGY
	FzZFYHQJ7oPRjN9IN2Q==
X-Received: from wmga6.prod.google.com ([2002:a05:600c:2d46:b0:499:b8f0:3186])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8490:20b0:49d:e0c:e560 with SMTP id 5b1f17b1804b1-49e61983771mr27226365e9.4.1789118400242;
 Fri, 11 Sep 2026 02:20:00 -0700 (PDT)
Date: Fri, 11 Sep 2026 09:19:58 +0000
In-Reply-To: <20260910-unique-ref-v21-6-e83257373062@kernel.org>
Mime-Version: 1.0
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org> <20260910-unique-ref-v21-6-e83257373062@kernel.org>
Message-ID: <aqPHvi1xFnMXvYLW@google.com>
Subject: Re: [PATCH v21 6/9] rust: Add `OwnableRefCounted`
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"Onur =?utf-8?B?w5Z6a2Fu?=" <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, 
	"Thomas =?utf-8?Q?Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Philipp Stanner <phasta@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
	linux-usb@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50620100002
X-Stat-Signature: xy7913myyc634ahpsjyzpxyt5jwp3gkr
X-Rspam-User: 
X-HE-Tag: 1789118402-684573
X-HE-Meta: U2FsdGVkX1/+MUaqdIAAykN2BK999uKS3cbGcvxPBeRFu6CN5edt3/NMALnHq/mj9O9BM2NreXn21TYotD86nbXlEfV7EYcRKskexxt9T4afZt6PsUEawaMCFqCxMJsugKJ5a2wqvtb+VIkHal5mdact08dqjNpqR420Mx/0Lsmn38ydUuFcSSDk5RtqCdUJnlvGx4eT4hebnMJxrDVPXDF8+9ejERV7w30Bfz/hrcxK46PoaH1odG2ra0MchFs7dw2POcbJM/RYtDeJcYeW1nC+E9qYUaxburMkwwcnElXPLCT92ShFdCelXAI5CqxXJYKkTWJtYzdcHFXE1bJfXKx6HvXjvL5zR5gJKz7HtssiRrDW7sHIrZbZmQO3368DjaQ3KlwM87q8+ce4vuHw0HLAzB3ohfX8C9gUFJ3/6fGlSIBLnRnvMZ4OZAoBWtDhTDLormw2alf1UH9xlJcu/BWQ5mCZrVdFJjMMDz0P3fgUs2fVHSNzH6hoRwh5aErb7mnaEgwetoBPvEOWlrWHfDBqgV68azrqDWRP1tPI+qRFKFbJ18r8EYmPY1JpTLjfrmHTZk2XotEQ6VqR+xnIS/lCO+AVzjH8tPkg8RHCRoY7uELW30XNt+nkRIBvueUTCgPoiHTCXSbPiOg901OUKdkoAhHfYVjt8BrToRSuM1o/s40/Pf+jWuqurvOfFfDtCNX5pZ9AO+ZGyuk/4FXclIPJdvjS1oaZcFPLKm+UUHUn2S1tQ0rsa5ZxirNw36gJ0DSZ0kyQrY/hIL9Cgz/XsNFHqLnBKeiAczcksBcEyA8Gjyl5jso0KwG1UUH5fitSRZsfBbIX6WPk+5gdCCFEu0TBk4vJ1GjGPUyml/gKJMpILeYjozPvd1drLCr45HktRxAtlcgCYX67JRONjOJTRyeYpr6yZntHaJMjcb0hm8rw79ztgaSpaj+1INuJ96k3IVz/EzL/LIVNH/sr8z+
 u9czxPaF
 HW8yxkCWcGWv77uYez8db6e2Vhv3sxXU0Vs6BeOvOzABMQMAtbvzgBz82WLjuZCI7tLN/8iYQkZ79FQvBoYtvYtpK7DbzcoX2V+E+UW2HGnlTZpcpsD280xXpSqnWTDl6Du0ewZ6K0zmkYRV9Wx6FPCv49cUuVUl9CAHGGRAIG2Ytnkz74zXIIsOJixjsWi9nrc/QwyckBq05ao3y5RzyfZqpJI06WEhvP3yszWMHqB07Np2Iccosj8CEFubkvdL9oSTnZ0DJVTC0QflBM+kjRmLzUaai43dBzl1+5vDhGynwC3oiRmcm7cgBcdiQXRAyIGwwf59iWg6aAq1urS67w9Rm2NQrmhXkzpWK3IPkq73jmbfO60YCQ4mmX9oAh2N4Cvdy2X1WUPskPc3jO6pevA6cONyhtV4h0M1PJaPfli2gw6edjp+BAlN+gWKN/Tmwu4x4yDC4Un45qzm6P6rC5fCglx+6mILWUlWaefsYN3UHWBvGKkJvM0bgcFeEJSYAokTulNfrmMluZ6+3mbuVgB6VywTwHdCvyjh2HcrNzxvzRaDVWb7KL/DB402g9AsosyIuvRxHYmJkMNHc5owdJSQBWNyAkAD3+9j7BIGzD6NBpZJSFkxmDEDTBw8goT5K93arFfnNFwFT2CRz7tQMqLX0fFhMrAmrHQrRp70gs3gr7SQRvCOsw7KaWdWSR+V7Iagr6I4l7u0XNwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:00:10AM +0200, Andreas Hindborg wrote:
> From: Oliver Mangold <oliver.mangold@pm.me>
> 
> Types implementing one of these traits can safely convert between an
> `ARef<T>` and an `Owned<T>`.
> 
> This is useful for types which generally are accessed through an `ARef`
> but have methods which can only safely be called when the reference is
> unique, like e.g. `block::mq::Request::end_ok()`.
> 
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> [ Andreas: Fix formatting, update documentation, fix error handling in
>   examples. ]
> Assisted-by: LLM
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

>  /// Types that specify their own way of performing allocation and destruction. Typically, this trait
>  /// is implemented on types from the C side.
>  ///
> -/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
> -/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
> -/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
> -/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
> +/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type.
> +///  - This is useful when it is desirable to tie the lifetime of an object reference to an owned
> +///    object, rather than pass around a bare reference.
> +///  - [`Ownable`] types can define custom drop logic that is executed when the owned reference
> +///    of type [`Owned<_>`] pointing to the object is dropped.

This diff looks like it should be in the patch introducing Ownable.

> +/// # #![expect(clippy::disallowed_names)]
> +/// # use core::ptr::NonNull;
> +/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
> +/// # use kernel::sync::aref::{ARef, RefCounted};
> +/// # use kernel::sync::atomic::Acquire;
> +/// # use kernel::sync::Refcount;
> +/// # use kernel::types::{Owned, Ownable, OwnableRefCounted};
> +///

This newline will appear weirdly in generated docs because no content is
shown above it. Consider not hiding the imports.

> +pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
> +    /// Checks if the [`ARef`] is unique and converts it to an [`Owned`] if that is the case.
> +    /// Otherwise it returns again an [`ARef`] to the same underlying object.
> +    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>>;
> +
> +    /// Converts the [`Owned`] into an [`ARef`].
> +    fn into_shared(this: Owned<Self>) -> ARef<Self>;
> +}

This trait provides two methods that have very different conditions for
existing, IMO.

The into_shared() method is so likely to exist, that I would almost
consider placing it on the Ownable trait.

pub trait Ownable {
    unsafe fn release(this: NonNull<Self>);

    fn into_shared(this: Owned<Self>) -> ARef<Self>
    where
    	Self: Refcounted;
}

On the other hand, I think try_from_shared() is more likely to be a
tricky operation you cannot necessarily implement, and as such it can be
on its own separate trait like you have here.

At the very least, I can easily imagine that some types can never become
unique again after having been shared.

Alice


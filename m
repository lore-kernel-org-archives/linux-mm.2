Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BAAECD6D7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C016B0088; Wed, 11 Feb 2026 13:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF926B0089; Wed, 11 Feb 2026 13:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1CF6B008A; Wed, 11 Feb 2026 13:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEE96B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:30:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28E63B9D3F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:30:26 +0000 (UTC)
X-FDA: 84433016052.24.0F6187C
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4BFD91C0011
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:30:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NO9i7G12;
	spf=pass (imf21.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770834624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YN82cp9Kv7HhSvnFdzWBPH1jHCDlC2a71VyAWReHMLQ=;
	b=YbDiElZ5JYPz9y56/tEpuJuttUY/bSGmWSnYtLDYba9VPS9VTcta+1v6OzZsLHKL6L8kJC
	QNYKI2v7rQXpVb55iH3OwK/Ht89VXxp8iQ1FIsiuYDxXtGl5eo4DZ1V4IpVKXKo3a1fFPR
	Nkg13S9ET+7N+3bkc48Xh650Ly7lN60=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NO9i7G12;
	spf=pass (imf21.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770834624; a=rsa-sha256;
	cv=none;
	b=8olc8Me4M8aBZqyP7d4G8jqAtNxqagEvwsyHfM3ZXnIUwSNczXNCSsuGM1+fVMxT7q1+AJ
	j5Jd/oh0pt8Ir25VPn+58rPdxhQAGAl6a/F1Ztz1z6uYaosG878JhQmnpkks+2XrCXfe6y
	YLXjf1HuApOEwdDsGml+Y0vYT6nGXzk=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-824adc96ad2so246958b3a.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770834623; x=1771439423; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YN82cp9Kv7HhSvnFdzWBPH1jHCDlC2a71VyAWReHMLQ=;
        b=NO9i7G128EBKy+yXv33r55YFqiPKoTfMvbju8Y0papk7SrtqFFuQ/RcEKbpfU1gOa0
         C6g0G0tTtb0ZJXYhP55psF5dtM2D7kuChu8jDec0IirBgfujQzvxmFKiDCTw0kfSKEYz
         B4Z9BfZy64KHGbgbAY8sq/7sNxsJ1HBRcTq0T19uFvFq1pbVJBQnGVymaV1eUWY3jxb9
         3Xqy9+dxMH0gBk4cAqMn14H9F1KZtk2+Z1fKQQTpk9i6z4T73FDXcFO3V7kR0+Lr7EOn
         NRFB1xckUiV63s4SYT0I/sCh35M+VXrtSulBNHsRQf3O+UuGMopiAjz7+wghbX1kBZAn
         SR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770834623; x=1771439423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YN82cp9Kv7HhSvnFdzWBPH1jHCDlC2a71VyAWReHMLQ=;
        b=xFqTmMbHLV0NVhsiF2qpBhBEGWWoSasStIKtwT818amaJ7jCkGnjrnBJbc3q8VZ2ZE
         YPzChDNwTVVsGgPww0QnHZP8coe6tdOplBrtbC6ZaLl68LkTM1mpgzBQmz9PpPxm4GXv
         FXSGN8ttxhkFsksvUK9dYHJz5dRshYjM6tRIpnXK4Hz3mml6NBzBceW+WPQhHaaE3NA8
         mtCN9b8ycCC6TUx+YtpdR3myJCAxzQMQirHkCgd47Of5wqEozQOMDHsAEaaqTgOaSsxL
         QkWwMPMOEyTWx+G7uLy1iVBXUzKPSlH7XumiQGngFjIvHvF7S3v0NobCci7rh3m4rZa7
         G6BQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwmdNvpjJuGyG7oAI/SxHRtQR1RSG9f0TxELlaQcjnI1aHIBlDgJMYL6GncWhMT3etjCqLN1Y9nw==@kvack.org
X-Gm-Message-State: AOJu0YxpXstcFX1r0HQTKq58/s+aq8Yfu479fCLBSH41yk+mM94MsZSf
	jN8eq8Ey7Ow/+hskfhBkqndRahqhWhFWMJt0/vIqs3N0RYX3DRktqdrn
X-Gm-Gg: AZuq6aInhtJq266HRKmaTDVdafK6EFvh5Q4NU4tQGewan5NMi16StOG6CvED+UicdtT
	zBUpJ0Q2wCqco4housqY00RULBv2Dw8257F3FUAAl5N7kY14dKB4KbDWsAXxgtjHjxyph0/uxQX
	qgSTWzYPlWvRyAL/oBpejmWzlx4Cg2pYwL2HOqVyEpjuWhEomd9yAmfYyPy4iW2lKE5V1eUd9E7
	mhiUm65y2Gv+gq59gqqXj+jxYM9Ui262KjUZAJpPhHVhnFxmQy8E5p/NUaqsauSYuZ2aBAU4PKA
	L4L25Jeoc/5ablgmcOSOBpcTmjJgiVN/zKInEvpc3VEEqsaTBcJ9cmrZtXcqHjr5H3G4WlRi76b
	dFR2Ct0Qr0nswW7ySfmjyFBrpQR5Czi5o2BuQUquRVMTWoxm0vM14uYZocRiBXK3Kp1VdVEyOsV
	+H6w2gGA7Bnb37t6EsSYv48JOrKfKuxGLu9FAY5knO5yaD8od2aCr1xh/Ckgqf7+ZvLvy4k7I=
X-Received: by 2002:a05:6a00:ac89:b0:81f:9a5c:5b95 with SMTP id d2e1a72fcca58-824b062018cmr10429b3a.68.1770834622846;
        Wed, 11 Feb 2026 10:30:22 -0800 (PST)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([106.51.162.165])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e84d679sm2828110b3a.59.2026.02.11.10.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 10:30:22 -0800 (PST)
Date: Thu, 12 Feb 2026 00:00:12 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 01/12] rust: xarray: minor formatting fixes
Message-ID: <aYzKjwHW2J9cE4kl@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4BFD91C0011
X-Stat-Signature: sknpxh19teqiceabuqo4zngscueee4kt
X-Rspam-User: 
X-HE-Tag: 1770834624-801404
X-HE-Meta: U2FsdGVkX18hj7q7bIg8/2Yl21Fg30MB435H2D7o2mr13RwLau5uNXChLKt+tblmpJRiKQx+hzzn844k1CNfkqPjLuHZR11/L5AyvEnC+tJEdSGWid4NGx9EFNbI+odvvNA2shZN8nlzq9FN4f5CHrZWb04ALvr3SkrGiR37vjDq+vNI1XB1fmQTO+HSe4suRQplhwNyr+HJYlN9XJzCGUw+LYKmhwHLmD0kc19LEjjdwZH/fM97C2LiOdNJo65O66j2y7YDuJVgbFynF/XxrY0PfuULD6YRyrFzLmYOhhGp05oUaLABVs+KtCz9Zk3067ZYEPDQDyTWh8XlLCY2VT5DonlBWrClZYeE1tfJa2yzD/VEK36J0Aq7ojWamjwm7cfI1PJ1f963xGOyqrmCwabrYaquIdoJxw+D5IQ2o5tBjaNM+aqPmo9jOzdOTwIVIMDkqhgNfB5mhaaRqZRCtK0yP/qYtEgFTzV6NdNeWvDYz4UrUM9DcD8T1Y0Tb1YJhyQact8bjUaXsptLpEomDZwh7lzK4SzzQqh4eFy2A2QkAC3kNAfMMx4zTVCHqgJHYNt/awZ8mDR5/JJP+41yFt4q9Z09DdRvxy3Qi/O8Y3rrbuj+2yvQWBfWShPZ8qReWCU8Y7nvKWxvYrOozgDVatluWnK9hvg63cc9axNrjvM0y8Sff6HR3tC8GUAjn6LnZTsKoig63tj+u78mFAE7QJf8euFGWJcVhn0+ZZii+yHfeMI3IlxsQcxpdJRK1jh85ajl7Icvq+nyjG2iPrI4WcpMwK+4opMp5Vt3MPO99MxOxHAdhZOUY/gSkD0JJEgoRzU4lUX1gT9pwZfSXNIOUUTK2hXCnFJYO0Xj8mdl2dvCbDClEZjTh/jiW3GcVUzCplBM21mu0Yupz8Al1MpzAaUsbzCT9dPuHYvB0RJYnNIViQpKUNEowES33SFgJTea4oqlinixOdyobjqrhuw
 iWgSeYvn
 ykkP+HadVC+jld55HrhPZlKm2W5lktB3fNjOsFJ8lgQCBhHnm+YAq7jVo9kvAdXsBkGp1hIPE0LZ5FjrPVLjkslwQyrW29F5P/nFO038o1KxHTsvASqSYdkA5VYhzCc3zC0GBQMfr1QXWvxWxMMhpA1i5QoPuuagpe6TYu61yyr/D4WshfsaI9cwxkugjKbthx74eh0noQv/Lw1+6fQrRbeXKStbB99JFGC62H0zy7F/jibVhf4n0oFky0LNUPE5QLKDRFbig7R42LdlPPp4jPVwhp54FVV8RazUD2RcjPm2KP50nlOFTuCeuVh9iGQt3ZMkxmT1O9hm8+SW/oqSIzMvGw6bwm4MuPzBkin+gmkhm+jAG4JoW47VPlFGKVIVBFlJVnWImeZqx4FvyYZOv795Fq+k8QqM4awHOrePyJ2IcjcDPPaC2E2cbj8Q0JncLpTjx3+YGQMVzKaAm9IbMoezIGairndGXeeLwRf4lbxFEzaqmhRpp9q0KlaxydBR+CBAYYZgFwlTYM9qO2IbmnWJbvttW+iwI0lYVTvErm4a7t2NT4oBcNY8cRAyROpKXVhhE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 03:38:06PM +0100, Andreas Hindborg wrote:
> Fix formatting in xarray module to comply with kernel coding
> guidelines:
> 
> - Update use clauses to use vertical layout with each import on its
>   own line.
> - Add trailing empty comments to preserve formatting and prevent
>   rustfmt from collapsing imports.
> - Break long assert_eq! statement in documentation across multiple
>   lines for better readability.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Reviewed-by: Tamir Duberstein <tamird@gmail.com>
> Acked-by: Tamir Duberstein <tamird@gmail.com>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index a49d6db288458..88625c9abf4ef 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -4,14 +4,33 @@
>  //!
>  //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
>  
> -use crate::{
> -    alloc, bindings, build_assert,
> -    error::{Error, Result},
> +use core::{
> +    iter,
> +    marker::PhantomData,
> +    pin::Pin,
> +    ptr::NonNull, //
> +};
> +use kernel::{
> +    alloc,
> +    bindings,
> +    build_assert, //
> +    error::{
> +        Error,
> +        Result, //
> +    },
>      ffi::c_void,
> -    types::{ForeignOwnable, NotThreadSafe, Opaque},
> +    types::{
> +        ForeignOwnable,
> +        NotThreadSafe,
> +        Opaque, //
> +    },
> +};
> +use pin_init::{
> +    pin_data,
> +    pin_init,
> +    pinned_drop,
> +    PinInit, //
>  };
> -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> -use pin_init::{pin_data, pin_init, pinned_drop, PinInit};
>  
>  /// An array which efficiently maps sparse integer indices to owned objects.
>  ///
> @@ -44,7 +63,10 @@
>  /// *guard.get_mut(0).unwrap() = 0xffff;
>  /// assert_eq!(guard.get(0).copied(), Some(0xffff));
>  ///
> -/// assert_eq!(guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(), Some(0xffff));
> +/// assert_eq!(
> +///     guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(),
> +///     Some(0xffff)
> +/// );
>  /// assert_eq!(guard.get(0).copied(), Some(0xbeef));
>  ///
>  /// guard.remove(0);
> 
> -- 
> 2.51.2
> 
LGTM

Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
> 


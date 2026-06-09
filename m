Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EDACD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B0A6B00EA; Tue,  9 Jun 2026 16:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBB66B00EB; Tue,  9 Jun 2026 16:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA596B00EC; Tue,  9 Jun 2026 16:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D38F6B00EA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:44:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BDB3406E7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:44:49 +0000 (UTC)
X-FDA: 84861553098.21.4BA70E4
Received: from mx-lax3-1.ucr.edu (mx-lax3-1.ucr.edu [169.235.156.35])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2996F80006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:44:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ucr.edu header.s=selector3 header.b=l95cZb27;
	dkim=pass header.d=ucr.edu header.s=rmail header.b=CQOAMIQY;
	dmarc=pass (policy=quarantine) header.from=ucr.edu;
	spf=pass (imf02.hostedemail.com: domain of ytan089@ucr.edu designates 169.235.156.35 as permitted sender) smtp.mailfrom=ytan089@ucr.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781037887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/abfg35H7IlctjRX6krk+X6+hGMS0ZINuVZqAAtOu4=;
	b=qrIgagnmliN0NHEV1Ssl2DAnejkBQIVMIVD7pDJ/R35eFPMi59Q5Ek48bXhgmB8cHVJ5BG
	Y3YyzRucGOoJNSefJnw/+BDuWFv+/c0JoyzjiWTgBjuc5xGFe+Kj6XI1ywYnSGu7lNYuy0
	mFIn0WfBH4QjdrgmvUDnGI882MXWuC4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=ucr.edu header.s=selector3 header.b=l95cZb27;
	dkim=pass header.d=ucr.edu header.s=rmail header.b=CQOAMIQY;
	dmarc=pass (policy=quarantine) header.from=ucr.edu;
	spf=pass (imf02.hostedemail.com: domain of ytan089@ucr.edu designates 169.235.156.35 as permitted sender) smtp.mailfrom=ytan089@ucr.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781037887;
	b=hG4qJyrds9kxoIO0rhgKDjj2r5kBNxgk6X/q0vr8joTab1509gRX985atqlh8pHN+IWdF3
	bJaWC/ayO8jqH/ek6/r0PJxB+Pa/4cfv8z03YFSIB1xF3v5+MDu9xsd4UetLsd0P7j3dam
	WUk8NVqe97kUVixagMMa1Jm43zUNZxc=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1781037887; x=1812573887;
  h=arc-seal:arc-message-signature:
   arc-authentication-results:dkim-signature:
   x-google-dkim-signature:x-forwarded-encrypted:
   x-gm-message-state:x-gm-gg:mime-version:references:
   in-reply-to:from:date:x-gm-features:message-id:subject:to:
   cc:content-type:x-cse-connectionguid:x-cse-msgguid;
  bh=HleLb3lfcnqEda9vG+8pFH5CNGcTKPUIaFiVO+0FuyE=;
  b=l95cZb27e/276EyZNo2EZfgIWVeM3iouYdnsRoVLRa+J4KhvXLE9yabu
   bxjDy/O4vi/uX+r8yG1+VSzpNMFYp19I4WzBHaWV3oGZz1bP6fAmtMvMp
   rYiq18P4+N7YuBIaXUFfTPzpck16MbjfHpA+4LGpKvV9pZZvhyfWRM7DD
   LdU4zbhaYrtSTzc7caYwk0T+yBslQRSJqBKp5Ammm5xEL+EaRe+Gi8ONX
   t1UdipwBiUoT0uCd57ygtA+A759G9NlxYG5LHMT9EabL4SAJ7EH/41gnK
   jSUH+ClAKTOx/NIbcN52uZEywAnQEEUbI5z7oziG2FHYfFBUYfCTvWncz
   w==;
X-CSE-ConnectionGUID: CGGqjHydSLGkpbgMTXmjBQ==
X-CSE-MsgGUID: ugWhce1URzWTIsm4IEMzuQ==
Received: from mail-lf1-f69.google.com ([209.85.167.69])
  by smtp-lax3-1.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 09 Jun 2026 13:44:45 -0700
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aa68e509ccso3871413e87.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781037883; cv=none;
        d=google.com; s=arc-20240605;
        b=lMMfAhGPZy+2D830t+3GJnGQ6+nIlRexgYq378/4KboND269WkgDgYyWCISnOmuzl7
         +W3N+TX7nO2kEpU40hWX2BGdNWq4xyUMsc04VYNOXmBzqOCSwMnXHbo/G1JAT6dfNyL4
         VvHcDmTEYKKCbkBKap40Pmh1tpTxYEx5bl1c3Ue+IlwwUm1f8TN3faTnWVoqwps7BoCc
         T3TyNblP65newOUWk33enlDnJgsOnE3GVWQ79s0I4M1TQnPMvb1RqMqrwATjCx9SLG9j
         yWXKaGRjnlKsaey3pVsHJdG0NC3TJZx5trDGFvSmKqaHl14vxdni9xk+XSgDDVE4YnJP
         2meQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p/abfg35H7IlctjRX6krk+X6+hGMS0ZINuVZqAAtOu4=;
        fh=aTSDGdxviIr3GfnsuL84CTGOdoWp2DHa9Ezy+3Vgc7E=;
        b=NdM4kCwXqzKTqsKqZyBBAgFRCej+5rFWzaIrQuM+3x1QBEaXB+45RTasegx9GwfS7K
         M3WfN2/ojLb5k5xpdzoUd7i3DGrTkpobkePVG9h+v4TtPQEDElYKiHEVuGWpg81sBNnb
         S9Kh7HCJI0xq/jl5jwtybiLB4Qg8yRE+9LL/6Ny5exLlQlxhurHvotcYbOvUr+5eYju+
         9Yu3dBGbfyyGU5xFOKqjrq8RKX/SSwh0RUHYxTB6/sMDXzFTJOuUvii9XdY8UbtMmLQE
         AcYl/s8l2BB1ymZz9UvmEboA8Na0A0Is8NHr/H4B2aOv9CowrmWfyOHoYQYtxT6TTO51
         bgCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1781037883; x=1781642683; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p/abfg35H7IlctjRX6krk+X6+hGMS0ZINuVZqAAtOu4=;
        b=CQOAMIQY4WC9y4mkGFbLPwHoIZk1bsBLn1yGQ8+akgxdwFtsfChRkCPl8nybILw4iE
         SsYf5/ywzA3VTgg8jc9u3fLOkDj5MeQ04D/P6NanWLhyrT7HTC3aV0D+yvaQ9kdHe+S5
         lrH16OuEZSxlAOGaPK5DicSpfpC+CYqZ4p8YY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037883; x=1781642683;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/abfg35H7IlctjRX6krk+X6+hGMS0ZINuVZqAAtOu4=;
        b=kmrEGjidtn/YAtybtkt8+vvi2Ca0UGegYvVkhViCtJRjHwd5qMGY6HHTHpobTtusTj
         4CHPxsPusH9hJdfsVybxukNrDDF5dggen04/MdO89sVpge+xmaTSV/XuRCEbpCvXyFMk
         fKBPsl+JpACh3WEIj5DDel8FenSbKODfyDaUvJjMR0+fAdzoEvmalDOwdwi0tksVZQdz
         He71039zZruZsVwrYNwzFGdssF3EAQ8w1MO00Dn7kFlY5jD1sdLtP+dPCVBhetJU4klR
         l8iz7W27oB0jmdXucBBOKYzYp2shudiDhK1d0Ov3WCpjVFcJu9pOFefGNHxTp8Q1zxiA
         8ODA==
X-Forwarded-Encrypted: i=1; AFNElJ9bwOyTbVQsnwb6N6FUP1eQvq7hW07w90hr+PAH6CHb1340ZV5EhJdSNX2CiYqVe5flzQqCDPGnvw==@kvack.org
X-Gm-Message-State: AOJu0YylAnGCpgNa5jt6uDFw60l0FAoXaWSZCSfNIVfyJayohfbZMuw7
	Cpw9lGFsGHAiUr6Prg44lahHLw93IcMz/UVQh1MV4FqV0oIHTEOI+FQ5ta2kHlnUmP33PszAtcM
	wYOGdYEy3cVhezCHNFcb8nvg/nUC6LooMB4Zf8IZHYSA5NixQfQYpDusK8cdpFogrrAJLu7ZiwM
	U5lTKcQuM+lJW1jXSv2ddd7cLHmMT4
X-Gm-Gg: Acq92OFLh+EXaOojIF+qWtO3bLb+vlDS2jXhLXlQx9RvaVljr7oe4Q1jR333B0RzbhZ
	JjPG9ZfAkOs+H1aVO1W/WDHbjGQTN9nts+K+zuHvsGv/l1uv82xtusNM+Qx4x2rtvT+Ey2UUDSi
	lgRd1RJS2/tPF+8HQYQDIc84CaIXW9YtaopapvcKInQ1tKY4w/+S6y87ouSWqpbuWFjQWwyL7Gm
	q6+xdSwCxSJcMJwQgYepN8VfPMp34Z/SNOQU1iJrfX1I14mPQ==
X-Received: by 2002:a05:6512:8053:b0:5aa:6f8e:ffdf with SMTP id 2adb3069b0e04-5aa87bc1892mr3609944e87.22.1781037883429;
        Tue, 09 Jun 2026 13:44:43 -0700 (PDT)
X-Received: by 2002:a05:6512:8053:b0:5aa:6f8e:ffdf with SMTP id
 2adb3069b0e04-5aa87bc1892mr3609932e87.22.1781037882903; Tue, 09 Jun 2026
 13:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org> <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
From: Yuan Tan <ytan089@ucr.edu>
Date: Tue, 9 Jun 2026 13:44:20 -0700
X-Gm-Features: AVVi8CfYq4UE7tixi4IXCzWEACoNZSblF_VKcKMh55F37KEu6I2V_qiyECKu-pk
Message-ID: <CABrc2FWddXtpZ6r-+9DLvSK26-VYOCu2jYiu-C6ACBSMj43p8w@mail.gmail.com>
Subject: Re: [PATCH v2 01/83] block: rust: fix `Send` bound for `GenDisk`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000579cce0653d83280"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2996F80006
X-Stat-Signature: qnco9ax9rjp3bn8xtxo61jff5jzu75ci
X-Rspam-User: 
X-HE-Tag: 1781037886-115878
X-HE-Meta: U2FsdGVkX185X20qAJCz40zkN+Km/O+RHmi5n/lSCUEZ/W4Ywb+dfByjSdK9pN/AHuTT9ZFGwJFIBHZvlDcsaQuiabZ0xDM4IPTVTANC4RSLoy+td09zAi/Z3DZgnkbtlgLfYHYNexVdFqQDFDjH7kZyadOTKKaEtthylBDTg98Sj1n7cCXVJ85AbUU3cchNLBepOnHvYV3is3TVR6PKYJePPzJSrKA2aXdA+dAcWeUU1l24tE7Gfz2cth/vnTThWAh049pwNO6/nDDMVPLELV4WhdWf+PuUu1trEwFzgiD3m/gxuV1FpIKv7+ATsnWq8pTZY/DfSk8910d38Rg/VAiuORkDqUDacScsOMRLEH2BX08ybW+T/ieZWNvHv6MdkGY0NOy2/uYl457GkAgXLdUUj7tYzIPJ/f/ekHoDW83rRhvTPZ17YoAJf4XavrN7WwI9dizbpd99gBtxDbEROUkyEpNaLlNRt9yNveHXXXhjWDh/EtfkmFZuws/gWF/IkaXraV5qLd3S+wwsB5bNLht2Ft+XUJIo4hbccaA9bCGp+tXa21Eaw8ERBnTJM0kcp6Iu9ufBiNk28M2/rQ8j0asmWPJjM7wIcGwmbJjMLDCex+FEaiy/ySRm4KwajGc1j5+qT/NVJN3cF/lJY4TS12WLlIfzK3PzGW2GqwAKxIsrrwFlRCvPPcU/ablkrfq6ahPH3S94v2Gq1vDVVKPBSXIww0y1eqHcGEYrGGUs9VKUr38xm7tcQOcZ1O03N9hPCw6k2rAJMbA5mzf/KWTYVTdZermkX+5UQZ/etksDJQbETc2O+XaRWeLBvJWisccDdiEHMNi4HSuxltvAV/MyNwoSn2F+ka2Vc6sxxYemLNtpIbb0uRrJPA0mtK05AOoMg8NxYYb/KWeViYSJfnHtGw9wvqt3WZqSpLqyX4yW1gFN27AmQebCltRNVOjCFa6Kr3zr9+g4WGs8huXzUIr
 5+86QF6A
 NClahN9LFbP9VABVJD0CyaVOkATQ89PwwZH/tS5uMSHAT6ir3tb5ZuE9qKOeZQ4c8gmBgBMl2K4XvKj6pudLXlhOwZljOmg+2rtAwFmShiC5QHIh41qUf9/7F1yImRoEl3buD+IZ21mNguCDZMA7GTVj0U4hSrTBVfwxkFvvzWW4KHDFJ97EGOE+WQUnYQRDDQNgqHRMRO0E6yUpV2/60DTsqakG5ZmZ2cFtMaQBaQRrZhM1Au8R9UGoMilB8ffeMzDdzKEeHeP1e26Kt3Fy9u2yBcYKVjBWmDP9CO0hsKcXgeZqgTcKzUbnSAs6R7y9bW73p0tkcG5P8nwh3ecybLm/17FJ3IXp+EERIYjtgHXhNyssULjJ9UHEly8QfmU6cyfIXEsIY0yg7PUAy00I7S2YZWMKGBFKyP7+/kL9hRfyJMdvgNy0lWELf6J+MCM1cJGJ0KAGrMa2HAeWdIDJdclwC9FmKEmgNXzyeU+WJwi6YGxfzggbJ0EpJIbbIWHGrapBmRlqPIK7aETUx6Vxv8DCcQOpx0awR47IpTAdtxjY9ra9+QujhxSvao2zQv3LOKIlwO5uQYFPUPeg+B0ZUaG294Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000579cce0653d83280
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 12:13=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org>
wrote:

> The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
> This constrains the wrong type. `T` is the `Operations` implementation,
> which is typically a zero-sized marker type that carries no data, so `T:
> Send` says nothing about whether the data a `GenDisk` actually owns can b=
e
> moved to another thread.
>
> A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
> `gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
> `Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is se=
nt
> across a thread boundary, so the `Send` bound must constrain exactly them=
.
> Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.
>
> Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
> Suggested-by: Yuan Tan <ytan089@ucr.edu>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>
> Please take patch from Yuan instead of this one, if they send a fixed
> version [1].
>
> [1]
> https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc3e2dd8.178063=
3578.git.ytan089@ucr.edu


Sorry, I've been busy with other things and haven't had the chance to send
the fixed version.

Thank you very much for reviewing the patch and for preparing the v2
version.

Could you please add the following when applying this patch?
Reported-by: Priya Bala Govindasamy <pgovind2@uci.edu>
Reported-by: Dylan Zueck <dzueck@uci.edu>

I didn't discover this issue myself. I just helped write the patch and I
don't want them to lose their credit for it.

Please let me know if you would prefer that I send a v3 instead.


>
> ---
>  rust/kernel/block/mq/gen_disk.rs | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/rust/kernel/block/mq/gen_disk.rs
> b/rust/kernel/block/mq/gen_disk.rs
> index 912cb805caf5..b36d24382cc3 100644
> --- a/rust/kernel/block/mq/gen_disk.rs
> +++ b/rust/kernel/block/mq/gen_disk.rs
> @@ -199,8 +199,14 @@ pub struct GenDisk<T: Operations> {
>  }
>
>  // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an
> `Arc` to a
> -// `TagSet` It is safe to send this to other threads as long as T is Sen=
d.
> -unsafe impl<T: Operations + Send> Send for GenDisk<T> {}
> +// `TagSet`. It is safe to send this to other threads as long as these
> two are `Send`.
> +unsafe impl<T> Send for GenDisk<T>
> +where
> +    T: Operations,
> +    T::QueueData: Send,
> +    Arc<TagSet<T>>: Send,
> +{
> +}
>
>  impl<T: Operations> Drop for GenDisk<T> {
>      fn drop(&mut self) {
>
> --
> 2.51.2
>
>
>

--000000000000579cce0653d83280
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jun 9, =
2026 at 12:13=E2=80=AFPM Andreas Hindborg &lt;<a href=3D"mailto:a.hindborg@=
kernel.org">a.hindborg@kernel.org</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">The `Send` implementation for `GenDisk&lt;=
T&gt;` was conditioned on `T: Send`.<br>
This constrains the wrong type. `T` is the `Operations` implementation,<br>
which is typically a zero-sized marker type that carries no data, so `T:<br=
>
Send` says nothing about whether the data a `GenDisk` actually owns can be<=
br>
moved to another thread.<br>
<br>
A `GenDisk&lt;T&gt;` owns the queue data `T::QueueData` (stored as the<br>
`gendisk`&#39;s `queuedata` and dropped when the `GenDisk` is dropped) and =
an<br>
`Arc&lt;TagSet&lt;T&gt;&gt;`. These are the values transferred when a `GenD=
isk` is sent<br>
across a thread boundary, so the `Send` bound must constrain exactly them.<=
br>
Bound `T::QueueData: Send` and `Arc&lt;TagSet&lt;T&gt;&gt;: Send` instead.<=
br>
<br>
Fixes: 3253aba3408a (&quot;rust: block: introduce `kernel::block::mq` modul=
e&quot;)<br>
Suggested-by: Yuan Tan &lt;<a href=3D"mailto:ytan089@ucr.edu" target=3D"_bl=
ank">ytan089@ucr.edu</a>&gt;<br>
Signed-off-by: Andreas Hindborg &lt;<a href=3D"mailto:a.hindborg@kernel.org=
" target=3D"_blank">a.hindborg@kernel.org</a>&gt;<br>
---<br>
<br>
Please take patch from Yuan instead of this one, if they send a fixed<br>
version [1].<br>
<br>
[1] <a href=3D"https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc=
3e2dd8.1780633578.git.ytan089@ucr.edu" rel=3D"noreferrer" target=3D"_blank"=
>https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc3e2dd8.1780633=
578.git.ytan089@ucr.edu</a></blockquote><div><br>Sorry, I&#39;ve been busy =
with other things and haven&#39;t had the chance to send the fixed version.=
<br><br>Thank you very much for reviewing the patch and for preparing the v=
2 version.<br><br>Could you please add the following when applying this pat=
ch?<br>Reported-by: Priya Bala Govindasamy &lt;<a href=3D"mailto:pgovind2@u=
ci.edu">pgovind2@uci.edu</a>&gt;<br>Reported-by: Dylan Zueck &lt;<a href=3D=
"mailto:dzueck@uci.edu">dzueck@uci.edu</a>&gt;<br><br>I didn&#39;t discover=
 this issue myself. I just helped write the patch and I don&#39;t want them=
 to lose their credit for it.<br><br>Please let me know if you would prefer=
 that I send a v3 instead.<br>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);p=
adding-left:1ex"><br>
---<br>
=C2=A0rust/kernel/block/mq/gen_disk.rs | 10 ++++++++--<br>
=C2=A01 file changed, 8 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_di=
sk.rs<br>
index 912cb805caf5..b36d24382cc3 100644<br>
--- a/rust/kernel/block/mq/gen_disk.rs<br>
+++ b/rust/kernel/block/mq/gen_disk.rs<br>
@@ -199,8 +199,14 @@ pub struct GenDisk&lt;T: Operations&gt; {<br>
=C2=A0}<br>
<br>
=C2=A0// SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an=
 `Arc` to a<br>
-// `TagSet` It is safe to send this to other threads as long as T is Send.=
<br>
-unsafe impl&lt;T: Operations + Send&gt; Send for GenDisk&lt;T&gt; {}<br>
+// `TagSet`. It is safe to send this to other threads as long as these two=
 are `Send`.<br>
+unsafe impl&lt;T&gt; Send for GenDisk&lt;T&gt;<br>
+where<br>
+=C2=A0 =C2=A0 T: Operations,<br>
+=C2=A0 =C2=A0 T::QueueData: Send,<br>
+=C2=A0 =C2=A0 Arc&lt;TagSet&lt;T&gt;&gt;: Send,<br>
+{<br>
+}<br>
<br>
=C2=A0impl&lt;T: Operations&gt; Drop for GenDisk&lt;T&gt; {<br>
=C2=A0 =C2=A0 =C2=A0fn drop(&amp;mut self) {<br>
<br>
-- <br>
2.51.2<br>
<br>
<br>
</blockquote></div></div>

--000000000000579cce0653d83280--


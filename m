Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2019CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 12:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFA48E0006; Sun, 24 Aug 2025 08:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7238E0001; Sun, 24 Aug 2025 08:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE40D8E0006; Sun, 24 Aug 2025 08:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9D48E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:36:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 425DE1A08F9
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:36:41 +0000 (UTC)
X-FDA: 83811599802.27.C365514
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 624CF180005
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:36:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="u7/EIqgu";
	spf=pass (imf24.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756038999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1rvfNHN5EBKyNOHUU8ULCvyPiJC4yatsNx2Khd/v5w=;
	b=ChAaadVJqj01HQao/wyW1qU16yYTovZGtL4XFcCf/N9E/V9BA3nWju82NocyatRsolQ9oi
	j6SOWBi9yae/uWH1KZmNRHHy+igxOyyhjLX7vJL4T4dz/+kdLkMxPj30mz/hulqnNDuxRE
	qMpmicxaWkTuih7VTIZeA4REpH1Jg94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="u7/EIqgu";
	spf=pass (imf24.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756038999; a=rsa-sha256;
	cv=none;
	b=cs7bM8hBWE+ynAvF208lGuEQyqg+Tuxbkf0NEUJTPu8zuY1ilThesjDa7vJipOfWZlnXDr
	vzQo/lZNIozMdxc9vxIuquHhuj794BlSMvdnFyzig806j9aKUZGLdn9y5Q+yfYnPVBfI+C
	0eiiMQVXVIam0nJBZKxOT9G5bzBMQ6w=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c4e9efb88aso1925204f8f.2
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 05:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756038998; x=1756643798; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1rvfNHN5EBKyNOHUU8ULCvyPiJC4yatsNx2Khd/v5w=;
        b=u7/EIqguQr5btEfs7+AyKrGQs/F70DRZeSyiBG0cK77Y9hw4CxaNCqDEIJuSLiJz1J
         8KPsdnnXO8QaSMtqFjyMSY2RFr1DK2GOxiteYp2/cGb7BAOkPKY5L4EGB+ElwYVC5qjr
         JuvskMe6zIOnDHw146WjMoPBoBUYv5aExEmN2u0COYjOnmoHCLAsVBi6i33G7G1WwSaK
         nYjqrpalq5Hk/qew0icgdV7nY/L7s/cwA8/8hAAGAgnzWkibp/ArGUGjXrXyvxkL6Y2E
         SUXhQtpaSavusbgqIF7ifIjEkymmk7wdJ3cbGxD+972lRGVqgveARe7lBblfAwwhz3zd
         tfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756038998; x=1756643798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1rvfNHN5EBKyNOHUU8ULCvyPiJC4yatsNx2Khd/v5w=;
        b=Y2BaCupZ9rMBO6JQCSDf/v5s0DYy0fFzjffMWTCWYXkY/UixjfAF2/+vMykWSWnbtE
         s62X2yWyTG610REeiME4f/zyBPbEsJyf8Bt9rkA20XWy3u6j1wvJd2KEU4NGswtgZDNr
         IDtoFNy0VHh74+i4DbOVHdAGUJKMYnBN/YPAHYFsgKlqyk3IYeKca9cqJBFQQ8Qr5h1V
         B+IPfOh5lFStt4IXEKhSZTUPjiwrGqvfJl2qkZi+kDwv2dWoB1rEiFcQboYoXD16hcER
         ay8ZKfkP9rwiNEDd3WKhdTJMdaWJ5iMCdydfajErKPALQGGbz9epa+5XQVO1wwr8YutN
         keRw==
X-Forwarded-Encrypted: i=1; AJvYcCXmQ0Y/4DTCk/LeE29j3JFYdxUO0R2qr9pBQA0PFZU1Qqz8HyLBuOJyRsh6vithPj5Uz2vtosGeAA==@kvack.org
X-Gm-Message-State: AOJu0YwwQPaKALmKmHgseDsTcgnWdxRs3vOYH/j9HspfkeAYtm/oTpLD
	sGvZ1JqFRxf/q5okE6MpLxYTlsG0RB4Fg8GovNGJuzRD8sIonLJ5QGgXzBG+Au7w8IiNPhCeeL2
	nG10Z8/5C5FT8LzmuMu3RGIpbfPfMfE6oA6tDpf1t
X-Gm-Gg: ASbGncul1FEYL1ALwC5fc7Tq6YCyKpMrZfg5EfXTJ875wTHVUIesVD9wzQXDPTAxJdY
	Z+80RAQ35xUmooyRL1Y6wFXnpme3nGdkaNoNC/YFeiZ955baK+fuaTE89wurzwd9Y1UeSYntbBE
	ZTnfC6on8K+CROhhS4l9ah2AyOQGLGa9y08rZEtYcH31XLMYQqQ1vrp5xoN1+VfH7oU0Q0Xfho5
	lh9ZAJ6Hnz61MEnHMtJkCESOhIOQeTcxVx+U0nlB0sKL34=
X-Google-Smtp-Source: AGHT+IGAL5ULN6cDtVMn93M/6ltr7rdoUlydoLJ5qmCG4isos1KCUAU1xW3/q5G82kK7ZLVPIwo+5OAa2y0XrKB//9s=
X-Received: by 2002:a5d:64ec:0:b0:3a6:d95e:f38c with SMTP id
 ffacd0b85a97d-3c5dd8aa9e5mr6585495f8f.33.1756038997507; Sun, 24 Aug 2025
 05:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250824120656.208978-1-dakr@kernel.org>
In-Reply-To: <20250824120656.208978-1-dakr@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 24 Aug 2025 14:36:25 +0200
X-Gm-Features: Ac12FXy27UlG8cvRS22_xj_eY3EZjdfdCW0w79oJGZ1pNncxo0nvIdODvAPLrn0
Message-ID: <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to Cmalloc
To: Danilo Krummrich <dakr@kernel.org>
Cc: lorenzo.stoakes@oracle.com, vbabka@suse.cz, Liam.Howlett@oracle.com, 
	urezki@gmail.com, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, a.hindborg@kernel.org, tmgross@umich.edu, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 624CF180005
X-Rspam-User: 
X-Stat-Signature: scq9osyndg6rqdhw5smi3cohwp7oo1u3
X-Rspamd-Server: rspam09
X-HE-Tag: 1756038999-226758
X-HE-Meta: U2FsdGVkX19LYDe9/O4GWXd2RvGZaFAuvTsV9khIxiJLHv93hel657cghoa8dtUTM3bWGDAG60fXogJ7Dkx69WXE/NwPltAJpR2BoRyFm+OTd1NMQEB+990Qjd1PODIEIWchfWroq4vZS2MIRfxyKoGISN79vXa3zWz1Z2vepnJgwK9QqBvIDvyjE7lui5nPfaJnIDHr45FwJUY2W4+J3HI3SaW3nUdFowJaXwIkroX4utXDv/L6DFTIdCMIQQRnJEPmNnhCRy2MG0sScK/SxT21RcYjR5KeJAZRyndAJ4e/x1k7RHjHqgFoDQIY9DEGL/Vd4ECJoSfwhSWxqHFZQLVTvWGyGb8dFeEnJxswxl5Fa6ZZT3gRX10HLjLDk+ww9rnhOwZPjBgE3XtSrJ1PEQ8tTgukYUsaLLKZdEXqBB4j6i5iHdSgoka1MJSxmNZ/4iIUVpS+p9Jan7j/Qd6RfowZazJ1++7Z4up9z7Dg9nrjsZXWtiv6xgH9q3GDLabp67b5lsnGvtF74K8yOBjAmVYSm8U2h3Jty/7bikY7sEKt+UJWwafPZcWRqSKMoVLs/uUB9BXcwxw1Bck3KrxnPMq1rZdAdFzCSMWLCCyxkedRSbPLH8Lskyl3ZHMN/cs5I5FBwcS9h2f48A2VDzWTIi7MZRp1+lu1XepOVY/xd8YErdUGZl2Et4Ad2dXyhloefDt7ftqt8g/fp/7xqcjSN9OfaQb1Aa3MA+HgWcl5OQ+x7Mr6EgGK6kws3lZP1PXgNQfFpx/LxqZFm0X51wszF1mTqX7vKPl3jpBBk4/wyabs/FPmltyMuDfD/X+ilcnO7epezIPT4OcJqbUo43vcKAc/Z1kDzItHp0eHVPM2/3JhqS/faGYA/43nt/mLVXh0/oOJCf8X0XuyBu5m69ViYXSo3ZpMFnqlwBoRYc/Fvels9MSsjK3HDNXAbwunqbmaVCznXpJQ60H6ADt2akm
 flakEid+
 21TXweoy9bEf7hwxYAYTKPAZlE6OJkl2od1oYGXT1J0r/f73jgb3MgnKRmrvmZ2LMpkNQU3XOB+06L+tEhoGs+qvh5vdxc27PQ1lz/uGU1Gjeqouz2Mfv62uPQoDpZDwydPdSno3jKKjTEDB3essqDOQbVHRuT0u35G/vtDqebFNqW8QXNY08TPSaD1W/ygUHtUSyjvehxCoN1WtvAqXOv6b5jk+iwsp+wwG93U1p9S9AaOBKewlkWdFIJVfkv47qm1yn80eG04qgZsSZ4mHpHBJk//gk2ju0Xeu8sOoT0RBip4R+4LdO79ZpNxz2hgfFEubEgaBLSnpdZ9CxdO2f9VzVkU9+rKlAdYGjwK1zoNu6bn9ewopsCXq2HtHYbb2at5KS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 2:07=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Cmalloc is missing the trait item MIN_ALIGN introduced by commit
> 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each
> allocator"), causing the following error on the `rusttest` make target.
>
>         error[E0046]: not all trait items implemented, missing: `MIN_ALIG=
N`
>            --> rust/kernel/alloc/allocator_test.rs:37:1
>             |
>         37  | unsafe impl Allocator for Cmalloc {
>             | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ missing `MIN_ALIGN` in im=
plementation
>             |
>            ::: rust/kernel/alloc.rs:146:5
>             |
>         146 |     const MIN_ALIGN: usize;
>             |     ---------------------- `MIN_ALIGN` from trait
>
> Implement MIN_ALIGN for Cmalloc to fix this.
>
> Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Closes: https://lore.kernel.org/all/CANiq72k0FSBTB2yOjiAy9PnAuyM=3D-PHxL3=
uQQ_Cv+zwswnr_bA@mail.gmail.com/
> Fixes: 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each =
allocator")
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>

Thanks for taking of it. Assuming a satisfactory answer to the quesiton bel=
ow:

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

> ---
>  rust/kernel/alloc/allocator_test.rs | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allo=
cator_test.rs
> index a3074480bd8d..0d3c78ddcd69 100644
> --- a/rust/kernel/alloc/allocator_test.rs
> +++ b/rust/kernel/alloc/allocator_test.rs
> @@ -35,6 +35,8 @@
>  // - passing a pointer to a valid memory allocation created by this `All=
ocator` is always OK,
>  // - `realloc` provides the guarantees as provided in the `# Guarantees`=
 section.
>  unsafe impl Allocator for Cmalloc {
> +    const MIN_ALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN;

Is this the right value for normal malloc?

Alice


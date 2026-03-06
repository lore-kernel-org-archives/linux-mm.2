Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE55BFCC04D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428516B00B0; Fri,  6 Mar 2026 12:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5B46B00B5; Fri,  6 Mar 2026 12:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4B36B00B8; Fri,  6 Mar 2026 12:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B06D6B00B0
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:32:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BC541405B5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:32:37 +0000 (UTC)
X-FDA: 84516332754.30.26916EE
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5D94C000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:32:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MRxzaH9K;
	spf=pass (imf10.hostedemail.com: domain of 3sg-raQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sg-raQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772818355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vcQthuk1eWzIx9SkfXAplSVF+zzfp3bHB4lRD3w+Jw=;
	b=jSxsouLaV7U2nWXuCWnMtH9qlWXxJECC6CGrZ5TyXQCVXDj4x5eTnNR5sPUteXcRCMgran
	I5JJ5aY86dGTkkrzLhmigvn9eAETwqb59kzXIR5ytlZ+Lqx4CK/t6ItwpogoORyPvI/z+f
	RKEiPXh1k3kfVU/D89XIHShJMPd4clw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MRxzaH9K;
	spf=pass (imf10.hostedemail.com: domain of 3sg-raQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sg-raQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772818355; a=rsa-sha256;
	cv=none;
	b=AzIFrNO7ZgLeLahHZ++k2WtGxNZ8Zzf3/oZiiTf4ziIYibdSn75cjcnLhP9p9y/e1LgvOr
	ryj3A6DPs74nXzFJjiPb01jXQgWmBj6Xcb1fyzukZ7afkOTRH3+KJ/vHPO6WbzNmb+2OTf
	AdyABgsHQhCichqPREUpAE73RPOV3gg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836e35292cso81264065e9.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 09:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772818354; x=1773423154; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/vcQthuk1eWzIx9SkfXAplSVF+zzfp3bHB4lRD3w+Jw=;
        b=MRxzaH9KOdzA9heZFDwuTs5UGu0MziZidf18epyo3XPah9gHtGrgYgyyFN5vdTv4q4
         EExWuod+zZG6IDj12nKRK/Nn8nlVFQV+JlSQu6JC90P+AqHnjF+R5WNDUphFpY9Weutg
         zFAQ7715p6a7P6+NJ8gju7MBiCyeCEI7Cwb7PD3Y5zAYs7l77xO/Rg2Zgt6vGqAqigm7
         w3NDoY4P4GH1H793w/jlpwozH9ZSA1D30nsNTm0iGrMCnj2DsVp80MpF1jRlbcMIr4BZ
         JyxACu0WS23bn827QvgYsDkCJrcRGfuXmMlgq2AO1Rv5DX8Z4ma1lBZZnfo9ijVle6fz
         MEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772818354; x=1773423154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vcQthuk1eWzIx9SkfXAplSVF+zzfp3bHB4lRD3w+Jw=;
        b=QFegO3UuRWRsxdD+MwfWGB1Pa0D3/kxGvYI8OGpzbxpmsGv8dhQW/lxweGojzBPenw
         ybLBbEpp2Rb0s51jVsFaI5pah5Kn4zgBnXkdPH2GB22Vgt3ggU+evX250L9MxQBbWfk8
         S0c5iYHPga0AMzQYB17M9JNEUyVLtZ8FAsqFrdWXy4DVFFzVDHyuKOq49fkqhN8myJdK
         mz+NBqE+WZinv0kEb7bYeQ/hY1IzHea7kGSlQ2lE2Hrjxl+xjil0f28ELCugBu4ECa2H
         FHfYMJZKJAly+Na8rd3ZxR0JiT7TBqovhMyrr7Awrn1aeWBNHFmehoz1NNr+3IjASxiA
         HpeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgCAB0cKXC42OXxvgXj44crbqmCR3QdOTi8UCndJ2rYcFFBpMV96//1kCiGw/zH3g2gaXQ8V1YDQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3q5dIjJafuS1sj5kHLHW0SCLAqgd9XyMa2UXTYJH1LySuerd0
	oOsWzOvgj/NUhLD084n2/0ARUqOmBbzYmUHaeGaWcMNPhmUIJlgh7gINWBQ8lxpIS3LHkjjyRoj
	S73p/kBRLV/eNmjnGDg==
X-Received: from wmc2.prod.google.com ([2002:a05:600c:6002:b0:483:43e2:3e67])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4710:b0:480:20f1:7abd with SMTP id 5b1f17b1804b1-48526978dc0mr46728455e9.31.1772818354024;
 Fri, 06 Mar 2026 09:32:34 -0800 (PST)
Date: Fri, 6 Mar 2026 17:32:33 +0000
In-Reply-To: <20260203-inline-helpers-v2-3-beb8547a03c9@google.com>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com> <20260203-inline-helpers-v2-3-beb8547a03c9@google.com>
Message-ID: <aasPsbMEsX6iGUl8@google.com>
Subject: Re: [PATCH v2 3/3] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5D94C000C
X-Stat-Signature: ncak91peugffr7teb8h3mjmscu8gb5jh
X-Rspam-User: 
X-HE-Tag: 1772818355-766603
X-HE-Meta: U2FsdGVkX1++7ee4sH5U4WlooMF7BshO49kH6aaOIFZPNX+yhby04vK0xTc0Jq4WgsZCL8j71DFBQ/gBp1KItGgLg5zALZpoQZgJUUwUWNAQy6UwaniVl9rVLcWIKJrtFH9j0nL8TQIAy3o5rVBwhhMtnx2UmNZqqO/CYQ+ci7xCG1lziKcfdiKedqpgFhbnW9j+IoPRJCEsSYPTt7r7109fB9SzplWKk3WBoLxiE6DZXhohBdTg2emBNK4D8hea+VbllLJtzALjtltd13llCfi5SK7Qnwt6IMgtdEpuM9MUUVlgCZpZc40eTIIdOuXFPeOGny4J1561bGMg8UYkBTSEjcqdg6thHYabjPjI0HMTJ2cDRhifmp3zy+r1SVEVN7Q6MKs4/03iPJGG9F8XKF4BTON/I8b4Jit44dCWc5rEKqr7XUlKP/1QZcYTYLZrvl4lfLAAxN9IK7UGtzlhoczYSZJlRZ+U6XYrep4DwFyyj6XgALogASM2UloczYjfAwvswZ7b8VSNEesyGAqIf+ih+S9cjdNcH58/FK9VyM/kWEUq2633unN6/efZ4WsPbssPxc/ZVVmX7OWFDGZPZ3I7ZHzC5cQ+0DgypIigC+I1iJENHeaYzcvXIC29xKZ/qFeAvtzcPQS1B5KOiU4Cx3pOHqJG2vNz4214xTuZWXw33r3SYpNa8hGxyYdajU/MG9phwpXTNlpcPKMobXg5zwQE/7f0YU1Y26gWVAGPZtNplSm0+puNj6HlArPjB4LbBtaSFwO2NEWhIydLGgjnykpTfaAZ1PtR+RQr3tL61/lDlVAOSNIdAr19zjdyiNq2amJCQBitQLVCLY8Sq7NDu8Pa8Fw1BoVumOQHZhxEi7IqSfn2lyMVVPsBZUI0twZ4lH8ZdhWY6Lq3Oy+wdDHW80BAC8wlMH/1TZCec95p2JjOkM4EVcxzr7i1b8bM8Qn/nNlNZfeCdjZqEzJv5qt
 hWhdo/nv
 9w3bLrvPQ+FurKJ5yDjZjQd+aA9agnoBymgOFuYcAmVG07UFOauCw9DFLlryRNiWgj1WSknS220KiOzo1+3gb4RQrrivNxecmu9k2nF+pygo9mb1/V6+k7jjyP8vmOYOwLDeX5Xzz5cHVdUsf3Gmyt2QK9DKT7m97NAexRtcEMiKxETioXnbM0+k27X+WWTuJBueXQeHDCzwmhCdHRWmptVLGBPNwoRqqv8ODEGcSh1cBxzfOl9l6+xwmfzq8GkEHzkCYY1rreSNE90YYNdBPPZrhL1w6aJvZqVJV5/2iflx6u177Qeiof1pCjVoiLddG02JbCidx/M+TKPknuF1GAaQApyl9zBbeTbzspiJ9YvVdmog/4c1Vq1gRV7MrzrkfuCJeQr0jFGP7bZLQvPqOAkyXQgpRTyFXSqQR22c9mih/6HI47CUiBWZEeryjYhIokFh/6BCKpk8wbjAYCjlBbSXJPamC0oLRtyoRxLnbF2ac8MOlixCQKgohVncXdWeZQ+3oJRBtY9+RG1JGAtJQOGtZouAq7IKsPR7T6U5W8tgYLCCYPGClXgXnIFgtqcaauWWVoULstzYhuikk38p+a3lioaZHuZV1H9V2JJWLmfzaTU+GxRVn/u1qSXsgRcFca/UYmUg95aGWBH2gIQb1ePpJ5A2CcpFU5UqpVpYW/8Nx+c6foG1vr0Szv376qC/rFr4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:34:10AM +0000, Alice Ryhl wrote:
>  $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
>  	$(call if_changed_dep,bindgen)
>  
> +quiet_cmd_rust_helper = HELPER  $@
> +      cmd_rust_helper = \
> +	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) \
> +		-c -g0 $< $(if $(filter %_module.bc,$@),-DMODULE) -emit-llvm -o $@
> +
> +$(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpers.c FORCE
> +	+$(call if_changed_dep,rust_helper)

I think this needs:

$(obj)/helpers/helpers.bc: private part-of-builtin := y
$(obj)/helpers/helpers_module.bc: private part-of-module := y

at least it seems to make a difference for AutoFDO.

Alice


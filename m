Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D548CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E47A8E000C; Thu,  6 Nov 2025 19:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC2A8E0002; Thu,  6 Nov 2025 19:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D22C8E000C; Thu,  6 Nov 2025 19:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFE48E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:57:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B07C4B30D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:57:36 +0000 (UTC)
X-FDA: 84081998112.07.EB18387
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 432D71C0007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:57:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cc43KIme;
	spf=pass (imf21.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762477054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmTmAuWcZZ8TrHlA0PNPFsEDtNa6QN4lB5lfJtGBXPQ=;
	b=oEXSF7DwKHrLkAQx0pxn5eInIE4aALxVyEcW7SvaBSIcrrFsSWePqfEikyiGRogUo6TcV1
	72xIvWk2w+YtEPLazs/Xd5jtRkHHZGMSbMZmNNjoX339YJnqAo15wMm58NEbXLRqG9mag2
	6lXFadcQAoTeYTr51orncOzSRRCJb74=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cc43KIme;
	spf=pass (imf21.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762477054; a=rsa-sha256;
	cv=none;
	b=ScyX39lsxhiF5MuaKcAlsI3yevXcaVk6tqFxqmCi2NP1g50FyvH2Ve8fy+Y3atEMaloUaV
	izsQIU1rQLSAZNL+w1Tnmitx+zTJcKaYPFF/5gZG+1ekv7i2OBHLALuZkUVODSxbtQLM33
	vADsz7p05HTHvwDzjGnFZIwcCTSRju4=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-88f8f346c2cso21967585a.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 16:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762477053; x=1763081853; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AmTmAuWcZZ8TrHlA0PNPFsEDtNa6QN4lB5lfJtGBXPQ=;
        b=Cc43KImeSNGCPpYxkiS7d7tjhCOsYeTxEnSHuHI196Tr5c1zXkoN02PNCJNM7huUEU
         BnHWflfVC3aBZzbvWM4vOrICJFZBEXPu+QRWhMQoRn8V650zBp27g6qZ4ViU2MtMxdYb
         +TJF76/FOORwd9yjBHUVPnaXTZuwlcpUTzYc0M6MZNYKiC7/B0zSoJCjGqW702bbnp1J
         3EuNwGuGDgtHIJMrh8FxeVq3fI9Or9HocYgxlw2DCLTX6n8irS5i5Srv+5wz+Mzupvuj
         t3swrMGxCpNSAZGhdw87CTkW1QQuwE11tFf6oLrzyiyXTj6SKt1sivduFg5FVuSHWghe
         lDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762477053; x=1763081853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmTmAuWcZZ8TrHlA0PNPFsEDtNa6QN4lB5lfJtGBXPQ=;
        b=Il+3A/TdNoIZDNV/eW8Ere5UU9pooliPVRCZlv78uBmkcmlc7JL68TBGxyBoyhGjew
         s394alhVePz/4dQ6vgngyE6wwFO+wXiUCEFhggUtLTaL6TZQtEocep+b0+M4z/tpfANb
         b+anAC6TXn+mY3LXf7Z9WNmzr0xrlyk0XW03W8Ezjzd0E0VApXfFQv5eDLz5BXc4MOV/
         awD0yFePsM8XFiY1ut+RMKDDJ1Ld7fR3diTzW96zjH4K/tOS3YudJW4vJa5u67DFDZ9d
         z01/y5gEgHsc3pUO81GuCgV2GJWvHjDTiyhmtdw8KVorfCPas9NJYodlDTASvJIPmoQL
         uMug==
X-Forwarded-Encrypted: i=1; AJvYcCUTRUj2TvMFn8lWIUy6NjkSKmK+027Th+yokkawnAq3AHYfHlcqoyzU3oIKDDvbnnVV5F2SxcYTJw==@kvack.org
X-Gm-Message-State: AOJu0Yw5SRS4m8mgL7zaiWdei2JKLW2qAudOFlGDHOjUsscYOjKpRS/K
	rdCo4a8bTXbkiqccFYhVgivSN2Wh0uc5QUxxZnCGymfIs3y6klUf9FXi
X-Gm-Gg: ASbGncuSjvDTW+hSu8wAD4z3Jmmish2vef9hVCP+D8N6M29w85VBcKFDAAq0N9iklOd
	D4jsKHlTlJXiF3pBEjL9tmN1hS2B5OohXnivONtZJq2n8mRVPocNejNlc+8GaIMCcQUe78gmLII
	dqMeLK6Bn4BDKACOCRAMNWo3m9Hyt8LDwXAmr2Agy/QPVSR2R5jYflgposhMmehRDm6oX0VEhPZ
	Oy30GvmTPmTpzyGIX0Dm5VVfad6uh0vsx8CvndwlkL2wWjpl6oHmdNT58+dUOIu+YFstWP13g/Z
	t54Isicpa6J/CEU1f6G3Ln3HzjDOVudi89AK3lDdckgWLd8U/aDxicuSSk422PdGleeo6N8mTqj
	ne+tCLZ7UENM8gSARV0rCERh7wEs5Lw8fjIN9DNjvKky23xSBiWwxvw1g1KZapBUG08TzgMa/
X-Google-Smtp-Source: AGHT+IGSPrynqp7inqEF4hBhUuDdjVXrb1BDsz7SS+ixO0ukO9wh+YU5CvVH5IrgWRaBImngE8S1zA==
X-Received: by 2002:a05:620a:4541:b0:88b:72c0:aaec with SMTP id af79cd13be357-8b2453689fdmr201926585a.88.1762477053268;
        Thu, 06 Nov 2025 16:57:33 -0800 (PST)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355e9a35sm300204985a.20.2025.11.06.16.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 16:57:32 -0800 (PST)
Date: Thu, 6 Nov 2025 19:57:30 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 3/9] rust: percpu: Add C bindings for per-CPU variable
 API
Message-ID: <aQ1D-skdKLV6xmJo@yury>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-3-984b1470adcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-rust-percpu-v4-3-984b1470adcb@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 432D71C0007
X-Stat-Signature: eyt79nxj6di78q7e8zppfw9ax31h348s
X-Rspam-User: 
X-HE-Tag: 1762477054-875520
X-HE-Meta: U2FsdGVkX1+jw8CICaIcVbeB9cseF7pCgHwLINoRWqcd8jJjr/ij9GogWXe1Urj0mFR0+S/CgN8p5jyaedJgdtYJOjeGrwwh74SONaUmK2BL2yjcALZfkk5suc7+v+jJRe13lWjQO38OGe9avjM2opNPza0WXOx2YnS4qbHY8OlOA0m5lY2OvcQvNPLMHVDMjuTopsGyxZ5PUWzXDhqe9IgtcV7hIa07SOFySTW2NDWAgYrFR5QoseqgtycN5F6O3CdbseZT5/vI1E3KfZCgFjuRlz1SrAMxyD86yrgHIfSFt4vKZzB2azNHxRmL5xImTDw/flAm81RtW0fBw2xRXLbKdKUN0lof2pIR3aJF9oGxL9okH/grK00nNeU1ktmE0QsHaXxmI21hg/oBMxFHjIe2I2wQ6E3HrW9dtkqTg5kS3dQZyLaLc9GLOU8zmvd3rPwm6E5MtbW4mxCLDkhVtpnlHFd0QAsHP3E9LZyxA+2+4JjpRo6A4GavfMc5FP2J5koIew2Go9rpVwZuyYRgeJKu75zqH43on2egkPuJjCP/Um4UjvTW1rB6k8jmqdvsXuPc8bzTaUPiEak7l+j4cwBaw7q6oA874EHb5v7cmgReHycFI7G7q08pn/ni6wbakueXskMD0AziJYj6z8Ro2tEU9rcsr4MHzprsimmpcoFhm1wEjn3Y1ycJuJxC2yq0ZQ3ysD8UDgQgNI9WFLuWuFV7529q0STuUOLG6X6KAjiSgBrw0lGJ3cjcAC+NSssCRL004wNVo79VykgsEUbEfCIeXyZitLv8Frpnx/E1JfU9DWUtU2qte6FsVl749Nf/rsROdJHSX6gs6tBc3Thot5vb1Wm6EMvlXfR3u0tF67YTjztEnnYt5I/4gwsI5qK1aBD6n6uidj9dUviUpH4Ne2DSjo2S9Bpa7OZfSgxBXgHygvQTUqqqgDgDpk42LzZ762JhR0RD5FzHdZAqc0U
 fJRS8qQp
 E0SgSRvtPBY06P//s50tnUMWIX1vC7o6xt4JVM2uZbH3wVC/GpxkWvSm1ATmZMBFqeZZ4nrhQ2Vgf18q9xvsBjOaL7M3LebTNbzlFjcpCmhcqgd8T5kImtlC9yF4eVVu01DskCBdx+YerSBI5tAr+HZ0JEESKkFgAToanI0HNRSx3wsSjHxop+KKr3s0+jMpVGJy+zBVI8d1gh1TeS5kiK2gO2jPnE2QLspCliXNON/yHqXk64foBuhZOT9EfhYPWVr/dVBkrvINiC/dJYoOixsLvn6G2N1NkURecX6BaMX/CCLGjB9QBjNN5G+RluObDf+ENYng9XQPitx4YAowiILfRUXeTYg15phZOwzIaBzhUJC1wZkojSXvA8VZ8HIE1k+QVo324neo5/hs2Sfny/JTXcZI42HTCIynlfoz8iOYDeXvH9r+6AoCcq0qWaI3p7gYdsYp2gnL2g1ibjfdlUHhR2zoMldWrXNYgdS7uyRUZ58oa+jS524A5t3fuIzrgu64hSeS/YEASonP15S381wqHX26xvStXN74zx16mbWHrQyjtkT/6wo7z9jYGgdMi3Dmr3PR/b4iGZj6noQONTTHAKOtW/yRdH0rcKw9MhYCvlr+XEvvAO4qcBWu3O2vPUeZQcxwrtGbT4u8iBPERv7H3O47yMuzbXj7+V3LL2gT5Zls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 03:01:15PM -0800, Mitchell Levy wrote:
> Add bindings necessary to implement a Rust per-CPU variable API,
> specifically per-CPU variable allocation and management of CPU
> preemption.
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>

Acked-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>

> ---
>  rust/helpers/helpers.c |  2 ++
>  rust/helpers/percpu.c  |  9 +++++++++
>  rust/helpers/preempt.c | 14 ++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> index 7cf7fe95e41d..2fc8d26cfe66 100644
> --- a/rust/helpers/helpers.c
> +++ b/rust/helpers/helpers.c
> @@ -31,9 +31,11 @@
>  #include "of.c"
>  #include "page.c"
>  #include "pci.c"
> +#include "percpu.c"
>  #include "pid_namespace.c"
>  #include "platform.c"
>  #include "poll.c"
> +#include "preempt.c"
>  #include "property.c"
>  #include "rbtree.c"
>  #include "rcu.c"
> diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
> new file mode 100644
> index 000000000000..a091389f730f
> --- /dev/null
> +++ b/rust/helpers/percpu.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/percpu.h>
> +
> +void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
> +{
> +	return __alloc_percpu(sz, align);
> +}
> +
> diff --git a/rust/helpers/preempt.c b/rust/helpers/preempt.c
> new file mode 100644
> index 000000000000..2c7529528ddd
> --- /dev/null
> +++ b/rust/helpers/preempt.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/preempt.h>
> +
> +void rust_helper_preempt_disable(void)
> +{
> +	preempt_disable();
> +}
> +
> +void rust_helper_preempt_enable(void)
> +{
> +	preempt_enable();
> +}
> +
> 
> -- 
> 2.34.1

